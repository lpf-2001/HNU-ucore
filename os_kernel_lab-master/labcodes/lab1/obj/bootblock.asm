
obj/bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    7c00:	fa                   	cli    
    cld                                             # String operations increment
    7c01:	fc                   	cld    

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
    movw %ax, %ds                                   # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
    movw %ax, %ss                                   # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    7c0a:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c0c:	a8 02                	test   $0x2,%al
    jnz seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    7c14:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c16:	a8 02                	test   $0x2,%al
    jnz seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
    7c1c:	e6 60                	out    %al,$0x60

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	6c                   	insb   (%dx),%es:(%edi)
    7c22:	7c 0f                	jl     7c33 <protcseg+0x1>
    movl %cr0, %eax
    7c24:	20 c0                	and    %al,%al
    orl $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
    movl %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
    7c2d:	ea                   	.byte 0xea
    7c2e:	32 7c 08 00          	xor    0x0(%eax,%ecx,1),%bh

00007c32 <protcseg>:

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds                                   # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
    movw %ax, %fs                                   # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
    movw %ax, %gs                                   # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
    movw %ax, %ss                                   # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    7c40:	bd 00 00 00 00       	mov    $0x0,%ebp
    movl $start, %esp
    7c45:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    call bootmain
    7c4a:	e8 c0 00 00 00       	call   7d0f <bootmain>

00007c4f <spin>:

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin
    7c4f:	eb fe                	jmp    7c4f <spin>
    7c51:	8d 76 00             	lea    0x0(%esi),%esi

00007c54 <gdt>:
	...
    7c5c:	ff                   	(bad)  
    7c5d:	ff 00                	incl   (%eax)
    7c5f:	00 00                	add    %al,(%eax)
    7c61:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c68:	00                   	.byte 0x0
    7c69:	92                   	xchg   %eax,%edx
    7c6a:	cf                   	iret   
	...

00007c6c <gdtdesc>:
    7c6c:	17                   	pop    %ss
    7c6d:	00 54 7c 00          	add    %dl,0x0(%esp,%edi,2)
	...

00007c72 <readseg>:
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c72:	55                   	push   %ebp
    7c73:	89 e5                	mov    %esp,%ebp
    7c75:	57                   	push   %edi
    7c76:	56                   	push   %esi
    7c77:	89 c6                	mov    %eax,%esi
    7c79:	53                   	push   %ebx
    uintptr_t end_va = va + count;
    7c7a:	01 d0                	add    %edx,%eax
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c7c:	83 ec 08             	sub    $0x8,%esp
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7c7f:	bb f7 01 00 00       	mov    $0x1f7,%ebx
    uintptr_t end_va = va + count;
    7c84:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7c87:	89 c8                	mov    %ecx,%eax

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    7c89:	c1 e9 09             	shr    $0x9,%ecx
    va -= offset % SECTSIZE;
    7c8c:	25 ff 01 00 00       	and    $0x1ff,%eax
    7c91:	29 c6                	sub    %eax,%esi
    uint32_t secno = (offset / SECTSIZE) + 1;
    7c93:	8d 41 01             	lea    0x1(%ecx),%eax
    7c96:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7c99:	3b 75 ec             	cmp    -0x14(%ebp),%esi
    7c9c:	73 6a                	jae    7d08 <readseg+0x96>
    7c9e:	89 da                	mov    %ebx,%edx
    7ca0:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7ca1:	24 c0                	and    $0xc0,%al
    7ca3:	3c 40                	cmp    $0x40,%al
    7ca5:	75 f7                	jne    7c9e <readseg+0x2c>
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
    7ca7:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7cac:	b0 01                	mov    $0x1,%al
    7cae:	ee                   	out    %al,(%dx)
    7caf:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7cb4:	8a 45 f0             	mov    -0x10(%ebp),%al
    7cb7:	ee                   	out    %al,(%dx)
    outb(0x1F4, (secno >> 8) & 0xFF);
    7cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7cbb:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cc0:	c1 e8 08             	shr    $0x8,%eax
    7cc3:	ee                   	out    %al,(%dx)
    outb(0x1F5, (secno >> 16) & 0xFF);
    7cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7cc7:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7ccc:	c1 e8 10             	shr    $0x10,%eax
    7ccf:	ee                   	out    %al,(%dx)
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    7cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7cd3:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cd8:	c1 e8 18             	shr    $0x18,%eax
    7cdb:	24 0f                	and    $0xf,%al
    7cdd:	0c e0                	or     $0xe0,%al
    7cdf:	ee                   	out    %al,(%dx)
    7ce0:	b0 20                	mov    $0x20,%al
    7ce2:	89 da                	mov    %ebx,%edx
    7ce4:	ee                   	out    %al,(%dx)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7ce5:	89 da                	mov    %ebx,%edx
    7ce7:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7ce8:	24 c0                	and    $0xc0,%al
    7cea:	3c 40                	cmp    $0x40,%al
    7cec:	75 f7                	jne    7ce5 <readseg+0x73>
    asm volatile (
    7cee:	89 f7                	mov    %esi,%edi
    7cf0:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cf5:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cfa:	fc                   	cld    
    7cfb:	f2 6d                	repnz insl (%dx),%es:(%edi)
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7cfd:	ff 45 f0             	incl   -0x10(%ebp)
    7d00:	81 c6 00 02 00 00    	add    $0x200,%esi
    7d06:	eb 91                	jmp    7c99 <readseg+0x27>
        readsect((void *)va, secno);
    }
}
    7d08:	58                   	pop    %eax
    7d09:	5a                   	pop    %edx
    7d0a:	5b                   	pop    %ebx
    7d0b:	5e                   	pop    %esi
    7d0c:	5f                   	pop    %edi
    7d0d:	5d                   	pop    %ebp
    7d0e:	c3                   	ret    

00007d0f <bootmain>:

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7d0f:	f3 0f 1e fb          	endbr32 
    7d13:	55                   	push   %ebp
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d14:	31 c9                	xor    %ecx,%ecx
bootmain(void) {
    7d16:	89 e5                	mov    %esp,%ebp
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d18:	ba 00 10 00 00       	mov    $0x1000,%edx
bootmain(void) {
    7d1d:	56                   	push   %esi
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d1e:	b8 00 00 01 00       	mov    $0x10000,%eax
bootmain(void) {
    7d23:	53                   	push   %ebx
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d24:	e8 49 ff ff ff       	call   7c72 <readseg>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
    7d29:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d30:	45 4c 46 
    7d33:	75 3f                	jne    7d74 <bootmain+0x65>
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7d35:	a1 1c 00 01 00       	mov    0x1001c,%eax
    eph = ph + ELFHDR->e_phnum;
    7d3a:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7d41:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
    eph = ph + ELFHDR->e_phnum;
    7d47:	c1 e6 05             	shl    $0x5,%esi
    7d4a:	01 de                	add    %ebx,%esi
    for (; ph < eph; ph ++) {
    7d4c:	39 f3                	cmp    %esi,%ebx
    7d4e:	73 18                	jae    7d68 <bootmain+0x59>
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d50:	8b 43 08             	mov    0x8(%ebx),%eax
    for (; ph < eph; ph ++) {
    7d53:	83 c3 20             	add    $0x20,%ebx
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d56:	8b 4b e4             	mov    -0x1c(%ebx),%ecx
    7d59:	8b 53 f4             	mov    -0xc(%ebx),%edx
    7d5c:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d61:	e8 0c ff ff ff       	call   7c72 <readseg>
    7d66:	eb e4                	jmp    7d4c <bootmain+0x3d>
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
    7d68:	a1 18 00 01 00       	mov    0x10018,%eax
    7d6d:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d72:	ff d0                	call   *%eax
}

static inline void
outw(uint16_t port, uint16_t data) {
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port));
    7d74:	ba 00 8a ff ff       	mov    $0xffff8a00,%edx
    7d79:	89 d0                	mov    %edx,%eax
    7d7b:	66 ef                	out    %ax,(%dx)
    7d7d:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7d82:	66 ef                	out    %ax,(%dx)
    7d84:	eb fe                	jmp    7d84 <bootmain+0x75>
