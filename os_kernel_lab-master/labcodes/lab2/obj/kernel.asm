
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 a0 11 00       	mov    $0x11a000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 a0 11 c0       	mov    %eax,0xc011a000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 90 11 c0       	mov    $0xc0119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	f3 0f 1e fb          	endbr32 
c010003a:	55                   	push   %ebp
c010003b:	89 e5                	mov    %esp,%ebp
c010003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100040:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0100045:	2d 00 c0 11 c0       	sub    $0xc011c000,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 c0 11 c0 	movl   $0xc011c000,(%esp)
c010005d:	e8 98 58 00 00       	call   c01058fa <memset>

    cons_init();                // init the console
c0100062:	e8 44 16 00 00       	call   c01016ab <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 20 61 10 c0 	movl   $0xc0106120,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 3c 61 10 c0 	movl   $0xc010613c,(%esp)
c010007c:	e8 39 02 00 00       	call   c01002ba <cprintf>

    print_kerninfo();
c0100081:	e8 f7 08 00 00       	call   c010097d <print_kerninfo>

    grade_backtrace();
c0100086:	e8 95 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 dc 31 00 00       	call   c010326c <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 91 17 00 00       	call   c0101826 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 36 19 00 00       	call   c01019d0 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 53 0d 00 00       	call   c0100df2 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 ce 18 00 00       	call   c0101972 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	f3 0f 1e fb          	endbr32 
c01000aa:	55                   	push   %ebp
c01000ab:	89 e5                	mov    %esp,%ebp
c01000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b7:	00 
c01000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bf:	00 
c01000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c7:	e8 10 0d 00 00       	call   c0100ddc <mon_backtrace>
}
c01000cc:	90                   	nop
c01000cd:	c9                   	leave  
c01000ce:	c3                   	ret    

c01000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cf:	f3 0f 1e fb          	endbr32 
c01000d3:	55                   	push   %ebp
c01000d4:	89 e5                	mov    %esp,%ebp
c01000d6:	53                   	push   %ebx
c01000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f2:	89 04 24             	mov    %eax,(%esp)
c01000f5:	e8 ac ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000fa:	90                   	nop
c01000fb:	83 c4 14             	add    $0x14,%esp
c01000fe:	5b                   	pop    %ebx
c01000ff:	5d                   	pop    %ebp
c0100100:	c3                   	ret    

c0100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100101:	f3 0f 1e fb          	endbr32 
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010b:	8b 45 10             	mov    0x10(%ebp),%eax
c010010e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100112:	8b 45 08             	mov    0x8(%ebp),%eax
c0100115:	89 04 24             	mov    %eax,(%esp)
c0100118:	e8 b2 ff ff ff       	call   c01000cf <grade_backtrace1>
}
c010011d:	90                   	nop
c010011e:	c9                   	leave  
c010011f:	c3                   	ret    

c0100120 <grade_backtrace>:

void
grade_backtrace(void) {
c0100120:	f3 0f 1e fb          	endbr32 
c0100124:	55                   	push   %ebp
c0100125:	89 e5                	mov    %esp,%ebp
c0100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010012a:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100136:	ff 
c0100137:	89 44 24 04          	mov    %eax,0x4(%esp)
c010013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100142:	e8 ba ff ff ff       	call   c0100101 <grade_backtrace0>
}
c0100147:	90                   	nop
c0100148:	c9                   	leave  
c0100149:	c3                   	ret    

c010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010014a:	f3 0f 1e fb          	endbr32 
c010014e:	55                   	push   %ebp
c010014f:	89 e5                	mov    %esp,%ebp
c0100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100164:	83 e0 03             	and    $0x3,%eax
c0100167:	89 c2                	mov    %eax,%edx
c0100169:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010016e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100172:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100176:	c7 04 24 41 61 10 c0 	movl   $0xc0106141,(%esp)
c010017d:	e8 38 01 00 00       	call   c01002ba <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100186:	89 c2                	mov    %eax,%edx
c0100188:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 4f 61 10 c0 	movl   $0xc010614f,(%esp)
c010019c:	e8 19 01 00 00       	call   c01002ba <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a5:	89 c2                	mov    %eax,%edx
c01001a7:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b4:	c7 04 24 5d 61 10 c0 	movl   $0xc010615d,(%esp)
c01001bb:	e8 fa 00 00 00       	call   c01002ba <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c4:	89 c2                	mov    %eax,%edx
c01001c6:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d3:	c7 04 24 6b 61 10 c0 	movl   $0xc010616b,(%esp)
c01001da:	e8 db 00 00 00       	call   c01002ba <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e3:	89 c2                	mov    %eax,%edx
c01001e5:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f2:	c7 04 24 79 61 10 c0 	movl   $0xc0106179,(%esp)
c01001f9:	e8 bc 00 00 00       	call   c01002ba <cprintf>
    round ++;
c01001fe:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100203:	40                   	inc    %eax
c0100204:	a3 00 c0 11 c0       	mov    %eax,0xc011c000
}
c0100209:	90                   	nop
c010020a:	c9                   	leave  
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020c:	f3 0f 1e fb          	endbr32 
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100213:	90                   	nop
c0100214:	5d                   	pop    %ebp
c0100215:	c3                   	ret    

c0100216 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100216:	f3 0f 1e fb          	endbr32 
c010021a:	55                   	push   %ebp
c010021b:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c010021d:	90                   	nop
c010021e:	5d                   	pop    %ebp
c010021f:	c3                   	ret    

c0100220 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100220:	f3 0f 1e fb          	endbr32 
c0100224:	55                   	push   %ebp
c0100225:	89 e5                	mov    %esp,%ebp
c0100227:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010022a:	e8 1b ff ff ff       	call   c010014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010022f:	c7 04 24 88 61 10 c0 	movl   $0xc0106188,(%esp)
c0100236:	e8 7f 00 00 00       	call   c01002ba <cprintf>
    lab1_switch_to_user();
c010023b:	e8 cc ff ff ff       	call   c010020c <lab1_switch_to_user>
    lab1_print_cur_status();
c0100240:	e8 05 ff ff ff       	call   c010014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100245:	c7 04 24 a8 61 10 c0 	movl   $0xc01061a8,(%esp)
c010024c:	e8 69 00 00 00       	call   c01002ba <cprintf>
    lab1_switch_to_kernel();
c0100251:	e8 c0 ff ff ff       	call   c0100216 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100256:	e8 ef fe ff ff       	call   c010014a <lab1_print_cur_status>
}
c010025b:	90                   	nop
c010025c:	c9                   	leave  
c010025d:	c3                   	ret    

c010025e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010025e:	f3 0f 1e fb          	endbr32 
c0100262:	55                   	push   %ebp
c0100263:	89 e5                	mov    %esp,%ebp
c0100265:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100268:	8b 45 08             	mov    0x8(%ebp),%eax
c010026b:	89 04 24             	mov    %eax,(%esp)
c010026e:	e8 69 14 00 00       	call   c01016dc <cons_putc>
    (*cnt) ++;
c0100273:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100276:	8b 00                	mov    (%eax),%eax
c0100278:	8d 50 01             	lea    0x1(%eax),%edx
c010027b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010027e:	89 10                	mov    %edx,(%eax)
}
c0100280:	90                   	nop
c0100281:	c9                   	leave  
c0100282:	c3                   	ret    

c0100283 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100283:	f3 0f 1e fb          	endbr32 
c0100287:	55                   	push   %ebp
c0100288:	89 e5                	mov    %esp,%ebp
c010028a:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010028d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100294:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100297:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010029b:	8b 45 08             	mov    0x8(%ebp),%eax
c010029e:	89 44 24 08          	mov    %eax,0x8(%esp)
c01002a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01002a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002a9:	c7 04 24 5e 02 10 c0 	movl   $0xc010025e,(%esp)
c01002b0:	e8 b1 59 00 00       	call   c0105c66 <vprintfmt>
    return cnt;
c01002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002b8:	c9                   	leave  
c01002b9:	c3                   	ret    

c01002ba <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002ba:	f3 0f 1e fb          	endbr32 
c01002be:	55                   	push   %ebp
c01002bf:	89 e5                	mov    %esp,%ebp
c01002c1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002c4:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d4:	89 04 24             	mov    %eax,(%esp)
c01002d7:	e8 a7 ff ff ff       	call   c0100283 <vcprintf>
c01002dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002e2:	c9                   	leave  
c01002e3:	c3                   	ret    

c01002e4 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002e4:	f3 0f 1e fb          	endbr32 
c01002e8:	55                   	push   %ebp
c01002e9:	89 e5                	mov    %esp,%ebp
c01002eb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f1:	89 04 24             	mov    %eax,(%esp)
c01002f4:	e8 e3 13 00 00       	call   c01016dc <cons_putc>
}
c01002f9:	90                   	nop
c01002fa:	c9                   	leave  
c01002fb:	c3                   	ret    

c01002fc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002fc:	f3 0f 1e fb          	endbr32 
c0100300:	55                   	push   %ebp
c0100301:	89 e5                	mov    %esp,%ebp
c0100303:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100306:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010030d:	eb 13                	jmp    c0100322 <cputs+0x26>
        cputch(c, &cnt);
c010030f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100313:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100316:	89 54 24 04          	mov    %edx,0x4(%esp)
c010031a:	89 04 24             	mov    %eax,(%esp)
c010031d:	e8 3c ff ff ff       	call   c010025e <cputch>
    while ((c = *str ++) != '\0') {
c0100322:	8b 45 08             	mov    0x8(%ebp),%eax
c0100325:	8d 50 01             	lea    0x1(%eax),%edx
c0100328:	89 55 08             	mov    %edx,0x8(%ebp)
c010032b:	0f b6 00             	movzbl (%eax),%eax
c010032e:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100331:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100335:	75 d8                	jne    c010030f <cputs+0x13>
    }
    cputch('\n', &cnt);
c0100337:	8d 45 f0             	lea    -0x10(%ebp),%eax
c010033a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100345:	e8 14 ff ff ff       	call   c010025e <cputch>
    return cnt;
c010034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010034d:	c9                   	leave  
c010034e:	c3                   	ret    

c010034f <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010034f:	f3 0f 1e fb          	endbr32 
c0100353:	55                   	push   %ebp
c0100354:	89 e5                	mov    %esp,%ebp
c0100356:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100359:	90                   	nop
c010035a:	e8 be 13 00 00       	call   c010171d <cons_getc>
c010035f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100366:	74 f2                	je     c010035a <getchar+0xb>
        /* do nothing */;
    return c;
c0100368:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036b:	c9                   	leave  
c010036c:	c3                   	ret    

c010036d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010036d:	f3 0f 1e fb          	endbr32 
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100377:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010037b:	74 13                	je     c0100390 <readline+0x23>
        cprintf("%s", prompt);
c010037d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100380:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100384:	c7 04 24 c7 61 10 c0 	movl   $0xc01061c7,(%esp)
c010038b:	e8 2a ff ff ff       	call   c01002ba <cprintf>
    }
    int i = 0, c;
c0100390:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100397:	e8 b3 ff ff ff       	call   c010034f <getchar>
c010039c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010039f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01003a3:	79 07                	jns    c01003ac <readline+0x3f>
            return NULL;
c01003a5:	b8 00 00 00 00       	mov    $0x0,%eax
c01003aa:	eb 78                	jmp    c0100424 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c01003ac:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c01003b0:	7e 28                	jle    c01003da <readline+0x6d>
c01003b2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c01003b9:	7f 1f                	jg     c01003da <readline+0x6d>
            cputchar(c);
c01003bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003be:	89 04 24             	mov    %eax,(%esp)
c01003c1:	e8 1e ff ff ff       	call   c01002e4 <cputchar>
            buf[i ++] = c;
c01003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003c9:	8d 50 01             	lea    0x1(%eax),%edx
c01003cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003d2:	88 90 20 c0 11 c0    	mov    %dl,-0x3fee3fe0(%eax)
c01003d8:	eb 45                	jmp    c010041f <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01003da:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003de:	75 16                	jne    c01003f6 <readline+0x89>
c01003e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e4:	7e 10                	jle    c01003f6 <readline+0x89>
            cputchar(c);
c01003e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003e9:	89 04 24             	mov    %eax,(%esp)
c01003ec:	e8 f3 fe ff ff       	call   c01002e4 <cputchar>
            i --;
c01003f1:	ff 4d f4             	decl   -0xc(%ebp)
c01003f4:	eb 29                	jmp    c010041f <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c01003f6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003fa:	74 06                	je     c0100402 <readline+0x95>
c01003fc:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c0100400:	75 95                	jne    c0100397 <readline+0x2a>
            cputchar(c);
c0100402:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100405:	89 04 24             	mov    %eax,(%esp)
c0100408:	e8 d7 fe ff ff       	call   c01002e4 <cputchar>
            buf[i] = '\0';
c010040d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100410:	05 20 c0 11 c0       	add    $0xc011c020,%eax
c0100415:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c0100418:	b8 20 c0 11 c0       	mov    $0xc011c020,%eax
c010041d:	eb 05                	jmp    c0100424 <readline+0xb7>
        c = getchar();
c010041f:	e9 73 ff ff ff       	jmp    c0100397 <readline+0x2a>
        }
    }
}
c0100424:	c9                   	leave  
c0100425:	c3                   	ret    

c0100426 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100426:	f3 0f 1e fb          	endbr32 
c010042a:	55                   	push   %ebp
c010042b:	89 e5                	mov    %esp,%ebp
c010042d:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100430:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
c0100435:	85 c0                	test   %eax,%eax
c0100437:	75 5b                	jne    c0100494 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100439:	c7 05 20 c4 11 c0 01 	movl   $0x1,0xc011c420
c0100440:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100443:	8d 45 14             	lea    0x14(%ebp),%eax
c0100446:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100449:	8b 45 0c             	mov    0xc(%ebp),%eax
c010044c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100450:	8b 45 08             	mov    0x8(%ebp),%eax
c0100453:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100457:	c7 04 24 ca 61 10 c0 	movl   $0xc01061ca,(%esp)
c010045e:	e8 57 fe ff ff       	call   c01002ba <cprintf>
    vcprintf(fmt, ap);
c0100463:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100466:	89 44 24 04          	mov    %eax,0x4(%esp)
c010046a:	8b 45 10             	mov    0x10(%ebp),%eax
c010046d:	89 04 24             	mov    %eax,(%esp)
c0100470:	e8 0e fe ff ff       	call   c0100283 <vcprintf>
    cprintf("\n");
c0100475:	c7 04 24 e6 61 10 c0 	movl   $0xc01061e6,(%esp)
c010047c:	e8 39 fe ff ff       	call   c01002ba <cprintf>
    
    cprintf("stack trackback:\n");
c0100481:	c7 04 24 e8 61 10 c0 	movl   $0xc01061e8,(%esp)
c0100488:	e8 2d fe ff ff       	call   c01002ba <cprintf>
    print_stackframe();
c010048d:	e8 3d 06 00 00       	call   c0100acf <print_stackframe>
c0100492:	eb 01                	jmp    c0100495 <__panic+0x6f>
        goto panic_dead;
c0100494:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100495:	e8 e4 14 00 00       	call   c010197e <intr_disable>
    while (1) {
        kmonitor(NULL);
c010049a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01004a1:	e8 5d 08 00 00       	call   c0100d03 <kmonitor>
c01004a6:	eb f2                	jmp    c010049a <__panic+0x74>

c01004a8 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c01004a8:	f3 0f 1e fb          	endbr32 
c01004ac:	55                   	push   %ebp
c01004ad:	89 e5                	mov    %esp,%ebp
c01004af:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c01004b2:	8d 45 14             	lea    0x14(%ebp),%eax
c01004b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c01004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004bb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01004bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01004c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004c6:	c7 04 24 fa 61 10 c0 	movl   $0xc01061fa,(%esp)
c01004cd:	e8 e8 fd ff ff       	call   c01002ba <cprintf>
    vcprintf(fmt, ap);
c01004d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01004dc:	89 04 24             	mov    %eax,(%esp)
c01004df:	e8 9f fd ff ff       	call   c0100283 <vcprintf>
    cprintf("\n");
c01004e4:	c7 04 24 e6 61 10 c0 	movl   $0xc01061e6,(%esp)
c01004eb:	e8 ca fd ff ff       	call   c01002ba <cprintf>
    va_end(ap);
}
c01004f0:	90                   	nop
c01004f1:	c9                   	leave  
c01004f2:	c3                   	ret    

c01004f3 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004f3:	f3 0f 1e fb          	endbr32 
c01004f7:	55                   	push   %ebp
c01004f8:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004fa:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
}
c01004ff:	5d                   	pop    %ebp
c0100500:	c3                   	ret    

c0100501 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100501:	f3 0f 1e fb          	endbr32 
c0100505:	55                   	push   %ebp
c0100506:	89 e5                	mov    %esp,%ebp
c0100508:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c010050b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050e:	8b 00                	mov    (%eax),%eax
c0100510:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100513:	8b 45 10             	mov    0x10(%ebp),%eax
c0100516:	8b 00                	mov    (%eax),%eax
c0100518:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010051b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100522:	e9 ca 00 00 00       	jmp    c01005f1 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
c0100527:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010052d:	01 d0                	add    %edx,%eax
c010052f:	89 c2                	mov    %eax,%edx
c0100531:	c1 ea 1f             	shr    $0x1f,%edx
c0100534:	01 d0                	add    %edx,%eax
c0100536:	d1 f8                	sar    %eax
c0100538:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010053b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010053e:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100541:	eb 03                	jmp    c0100546 <stab_binsearch+0x45>
            m --;
c0100543:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100546:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100549:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010054c:	7c 1f                	jl     c010056d <stab_binsearch+0x6c>
c010054e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100551:	89 d0                	mov    %edx,%eax
c0100553:	01 c0                	add    %eax,%eax
c0100555:	01 d0                	add    %edx,%eax
c0100557:	c1 e0 02             	shl    $0x2,%eax
c010055a:	89 c2                	mov    %eax,%edx
c010055c:	8b 45 08             	mov    0x8(%ebp),%eax
c010055f:	01 d0                	add    %edx,%eax
c0100561:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100565:	0f b6 c0             	movzbl %al,%eax
c0100568:	39 45 14             	cmp    %eax,0x14(%ebp)
c010056b:	75 d6                	jne    c0100543 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
c010056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100570:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100573:	7d 09                	jge    c010057e <stab_binsearch+0x7d>
            l = true_m + 1;
c0100575:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100578:	40                   	inc    %eax
c0100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010057c:	eb 73                	jmp    c01005f1 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
c010057e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100585:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100588:	89 d0                	mov    %edx,%eax
c010058a:	01 c0                	add    %eax,%eax
c010058c:	01 d0                	add    %edx,%eax
c010058e:	c1 e0 02             	shl    $0x2,%eax
c0100591:	89 c2                	mov    %eax,%edx
c0100593:	8b 45 08             	mov    0x8(%ebp),%eax
c0100596:	01 d0                	add    %edx,%eax
c0100598:	8b 40 08             	mov    0x8(%eax),%eax
c010059b:	39 45 18             	cmp    %eax,0x18(%ebp)
c010059e:	76 11                	jbe    c01005b1 <stab_binsearch+0xb0>
            *region_left = m;
c01005a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005a6:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01005a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005ab:	40                   	inc    %eax
c01005ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005af:	eb 40                	jmp    c01005f1 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
c01005b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b4:	89 d0                	mov    %edx,%eax
c01005b6:	01 c0                	add    %eax,%eax
c01005b8:	01 d0                	add    %edx,%eax
c01005ba:	c1 e0 02             	shl    $0x2,%eax
c01005bd:	89 c2                	mov    %eax,%edx
c01005bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01005c2:	01 d0                	add    %edx,%eax
c01005c4:	8b 40 08             	mov    0x8(%eax),%eax
c01005c7:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005ca:	73 14                	jae    c01005e0 <stab_binsearch+0xdf>
            *region_right = m - 1;
c01005cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005cf:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d5:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005da:	48                   	dec    %eax
c01005db:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005de:	eb 11                	jmp    c01005f1 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005e6:	89 10                	mov    %edx,(%eax)
            l = m;
c01005e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005ee:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005f7:	0f 8e 2a ff ff ff    	jle    c0100527 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
c01005fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100601:	75 0f                	jne    c0100612 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
c0100603:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100606:	8b 00                	mov    (%eax),%eax
c0100608:	8d 50 ff             	lea    -0x1(%eax),%edx
c010060b:	8b 45 10             	mov    0x10(%ebp),%eax
c010060e:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c0100610:	eb 3e                	jmp    c0100650 <stab_binsearch+0x14f>
        l = *region_right;
c0100612:	8b 45 10             	mov    0x10(%ebp),%eax
c0100615:	8b 00                	mov    (%eax),%eax
c0100617:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c010061a:	eb 03                	jmp    c010061f <stab_binsearch+0x11e>
c010061c:	ff 4d fc             	decl   -0x4(%ebp)
c010061f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100622:	8b 00                	mov    (%eax),%eax
c0100624:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100627:	7e 1f                	jle    c0100648 <stab_binsearch+0x147>
c0100629:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010062c:	89 d0                	mov    %edx,%eax
c010062e:	01 c0                	add    %eax,%eax
c0100630:	01 d0                	add    %edx,%eax
c0100632:	c1 e0 02             	shl    $0x2,%eax
c0100635:	89 c2                	mov    %eax,%edx
c0100637:	8b 45 08             	mov    0x8(%ebp),%eax
c010063a:	01 d0                	add    %edx,%eax
c010063c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100640:	0f b6 c0             	movzbl %al,%eax
c0100643:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100646:	75 d4                	jne    c010061c <stab_binsearch+0x11b>
        *region_left = l;
c0100648:	8b 45 0c             	mov    0xc(%ebp),%eax
c010064b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010064e:	89 10                	mov    %edx,(%eax)
}
c0100650:	90                   	nop
c0100651:	c9                   	leave  
c0100652:	c3                   	ret    

c0100653 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100653:	f3 0f 1e fb          	endbr32 
c0100657:	55                   	push   %ebp
c0100658:	89 e5                	mov    %esp,%ebp
c010065a:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010065d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100660:	c7 00 18 62 10 c0    	movl   $0xc0106218,(%eax)
    info->eip_line = 0;
c0100666:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100670:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100673:	c7 40 08 18 62 10 c0 	movl   $0xc0106218,0x8(%eax)
    info->eip_fn_namelen = 9;
c010067a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100684:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100687:	8b 55 08             	mov    0x8(%ebp),%edx
c010068a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010068d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100690:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100697:	c7 45 f4 60 74 10 c0 	movl   $0xc0107460,-0xc(%ebp)
    stab_end = __STAB_END__;
c010069e:	c7 45 f0 84 3d 11 c0 	movl   $0xc0113d84,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01006a5:	c7 45 ec 85 3d 11 c0 	movl   $0xc0113d85,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01006ac:	c7 45 e8 9e 68 11 c0 	movl   $0xc011689e,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006b9:	76 0b                	jbe    c01006c6 <debuginfo_eip+0x73>
c01006bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006be:	48                   	dec    %eax
c01006bf:	0f b6 00             	movzbl (%eax),%eax
c01006c2:	84 c0                	test   %al,%al
c01006c4:	74 0a                	je     c01006d0 <debuginfo_eip+0x7d>
        return -1;
c01006c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006cb:	e9 ab 02 00 00       	jmp    c010097b <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006da:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01006dd:	c1 f8 02             	sar    $0x2,%eax
c01006e0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006e6:	48                   	dec    %eax
c01006e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ed:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006f1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006f8:	00 
c01006f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006fc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100700:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100703:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100707:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010070a:	89 04 24             	mov    %eax,(%esp)
c010070d:	e8 ef fd ff ff       	call   c0100501 <stab_binsearch>
    if (lfile == 0)
c0100712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100715:	85 c0                	test   %eax,%eax
c0100717:	75 0a                	jne    c0100723 <debuginfo_eip+0xd0>
        return -1;
c0100719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010071e:	e9 58 02 00 00       	jmp    c010097b <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100726:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100729:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010072f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100732:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100736:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010073d:	00 
c010073e:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100741:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100745:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100748:	89 44 24 04          	mov    %eax,0x4(%esp)
c010074c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074f:	89 04 24             	mov    %eax,(%esp)
c0100752:	e8 aa fd ff ff       	call   c0100501 <stab_binsearch>

    if (lfun <= rfun) {
c0100757:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010075a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010075d:	39 c2                	cmp    %eax,%edx
c010075f:	7f 78                	jg     c01007d9 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100761:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100764:	89 c2                	mov    %eax,%edx
c0100766:	89 d0                	mov    %edx,%eax
c0100768:	01 c0                	add    %eax,%eax
c010076a:	01 d0                	add    %edx,%eax
c010076c:	c1 e0 02             	shl    $0x2,%eax
c010076f:	89 c2                	mov    %eax,%edx
c0100771:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100774:	01 d0                	add    %edx,%eax
c0100776:	8b 10                	mov    (%eax),%edx
c0100778:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010077b:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010077e:	39 c2                	cmp    %eax,%edx
c0100780:	73 22                	jae    c01007a4 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100782:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100785:	89 c2                	mov    %eax,%edx
c0100787:	89 d0                	mov    %edx,%eax
c0100789:	01 c0                	add    %eax,%eax
c010078b:	01 d0                	add    %edx,%eax
c010078d:	c1 e0 02             	shl    $0x2,%eax
c0100790:	89 c2                	mov    %eax,%edx
c0100792:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	8b 10                	mov    (%eax),%edx
c0100799:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010079c:	01 c2                	add    %eax,%edx
c010079e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a1:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01007a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007a7:	89 c2                	mov    %eax,%edx
c01007a9:	89 d0                	mov    %edx,%eax
c01007ab:	01 c0                	add    %eax,%eax
c01007ad:	01 d0                	add    %edx,%eax
c01007af:	c1 e0 02             	shl    $0x2,%eax
c01007b2:	89 c2                	mov    %eax,%edx
c01007b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b7:	01 d0                	add    %edx,%eax
c01007b9:	8b 50 08             	mov    0x8(%eax),%edx
c01007bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bf:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c5:	8b 40 10             	mov    0x10(%eax),%eax
c01007c8:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007d7:	eb 15                	jmp    c01007ee <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007dc:	8b 55 08             	mov    0x8(%ebp),%edx
c01007df:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007f1:	8b 40 08             	mov    0x8(%eax),%eax
c01007f4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007fb:	00 
c01007fc:	89 04 24             	mov    %eax,(%esp)
c01007ff:	e8 6a 4f 00 00       	call   c010576e <strfind>
c0100804:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100807:	8b 52 08             	mov    0x8(%edx),%edx
c010080a:	29 d0                	sub    %edx,%eax
c010080c:	89 c2                	mov    %eax,%edx
c010080e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100811:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100814:	8b 45 08             	mov    0x8(%ebp),%eax
c0100817:	89 44 24 10          	mov    %eax,0x10(%esp)
c010081b:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100822:	00 
c0100823:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100826:	89 44 24 08          	mov    %eax,0x8(%esp)
c010082a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010082d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100831:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100834:	89 04 24             	mov    %eax,(%esp)
c0100837:	e8 c5 fc ff ff       	call   c0100501 <stab_binsearch>
    if (lline <= rline) {
c010083c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010083f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100842:	39 c2                	cmp    %eax,%edx
c0100844:	7f 23                	jg     c0100869 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
c0100846:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100849:	89 c2                	mov    %eax,%edx
c010084b:	89 d0                	mov    %edx,%eax
c010084d:	01 c0                	add    %eax,%eax
c010084f:	01 d0                	add    %edx,%eax
c0100851:	c1 e0 02             	shl    $0x2,%eax
c0100854:	89 c2                	mov    %eax,%edx
c0100856:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100859:	01 d0                	add    %edx,%eax
c010085b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010085f:	89 c2                	mov    %eax,%edx
c0100861:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100864:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100867:	eb 11                	jmp    c010087a <debuginfo_eip+0x227>
        return -1;
c0100869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010086e:	e9 08 01 00 00       	jmp    c010097b <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100873:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100876:	48                   	dec    %eax
c0100877:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010087a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010087d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100880:	39 c2                	cmp    %eax,%edx
c0100882:	7c 56                	jl     c01008da <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
c0100884:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100887:	89 c2                	mov    %eax,%edx
c0100889:	89 d0                	mov    %edx,%eax
c010088b:	01 c0                	add    %eax,%eax
c010088d:	01 d0                	add    %edx,%eax
c010088f:	c1 e0 02             	shl    $0x2,%eax
c0100892:	89 c2                	mov    %eax,%edx
c0100894:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100897:	01 d0                	add    %edx,%eax
c0100899:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010089d:	3c 84                	cmp    $0x84,%al
c010089f:	74 39                	je     c01008da <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01008a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008a4:	89 c2                	mov    %eax,%edx
c01008a6:	89 d0                	mov    %edx,%eax
c01008a8:	01 c0                	add    %eax,%eax
c01008aa:	01 d0                	add    %edx,%eax
c01008ac:	c1 e0 02             	shl    $0x2,%eax
c01008af:	89 c2                	mov    %eax,%edx
c01008b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008b4:	01 d0                	add    %edx,%eax
c01008b6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008ba:	3c 64                	cmp    $0x64,%al
c01008bc:	75 b5                	jne    c0100873 <debuginfo_eip+0x220>
c01008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008c1:	89 c2                	mov    %eax,%edx
c01008c3:	89 d0                	mov    %edx,%eax
c01008c5:	01 c0                	add    %eax,%eax
c01008c7:	01 d0                	add    %edx,%eax
c01008c9:	c1 e0 02             	shl    $0x2,%eax
c01008cc:	89 c2                	mov    %eax,%edx
c01008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008d1:	01 d0                	add    %edx,%eax
c01008d3:	8b 40 08             	mov    0x8(%eax),%eax
c01008d6:	85 c0                	test   %eax,%eax
c01008d8:	74 99                	je     c0100873 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008e0:	39 c2                	cmp    %eax,%edx
c01008e2:	7c 42                	jl     c0100926 <debuginfo_eip+0x2d3>
c01008e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008e7:	89 c2                	mov    %eax,%edx
c01008e9:	89 d0                	mov    %edx,%eax
c01008eb:	01 c0                	add    %eax,%eax
c01008ed:	01 d0                	add    %edx,%eax
c01008ef:	c1 e0 02             	shl    $0x2,%eax
c01008f2:	89 c2                	mov    %eax,%edx
c01008f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f7:	01 d0                	add    %edx,%eax
c01008f9:	8b 10                	mov    (%eax),%edx
c01008fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01008fe:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100901:	39 c2                	cmp    %eax,%edx
c0100903:	73 21                	jae    c0100926 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100905:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100908:	89 c2                	mov    %eax,%edx
c010090a:	89 d0                	mov    %edx,%eax
c010090c:	01 c0                	add    %eax,%eax
c010090e:	01 d0                	add    %edx,%eax
c0100910:	c1 e0 02             	shl    $0x2,%eax
c0100913:	89 c2                	mov    %eax,%edx
c0100915:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100918:	01 d0                	add    %edx,%eax
c010091a:	8b 10                	mov    (%eax),%edx
c010091c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010091f:	01 c2                	add    %eax,%edx
c0100921:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100924:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100926:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100929:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010092c:	39 c2                	cmp    %eax,%edx
c010092e:	7d 46                	jge    c0100976 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
c0100930:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100933:	40                   	inc    %eax
c0100934:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100937:	eb 16                	jmp    c010094f <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010093c:	8b 40 14             	mov    0x14(%eax),%eax
c010093f:	8d 50 01             	lea    0x1(%eax),%edx
c0100942:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100945:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010094b:	40                   	inc    %eax
c010094c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010094f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100952:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100955:	39 c2                	cmp    %eax,%edx
c0100957:	7d 1d                	jge    c0100976 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100959:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010095c:	89 c2                	mov    %eax,%edx
c010095e:	89 d0                	mov    %edx,%eax
c0100960:	01 c0                	add    %eax,%eax
c0100962:	01 d0                	add    %edx,%eax
c0100964:	c1 e0 02             	shl    $0x2,%eax
c0100967:	89 c2                	mov    %eax,%edx
c0100969:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010096c:	01 d0                	add    %edx,%eax
c010096e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100972:	3c a0                	cmp    $0xa0,%al
c0100974:	74 c3                	je     c0100939 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
c0100976:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010097b:	c9                   	leave  
c010097c:	c3                   	ret    

c010097d <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010097d:	f3 0f 1e fb          	endbr32 
c0100981:	55                   	push   %ebp
c0100982:	89 e5                	mov    %esp,%ebp
c0100984:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100987:	c7 04 24 22 62 10 c0 	movl   $0xc0106222,(%esp)
c010098e:	e8 27 f9 ff ff       	call   c01002ba <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100993:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c010099a:	c0 
c010099b:	c7 04 24 3b 62 10 c0 	movl   $0xc010623b,(%esp)
c01009a2:	e8 13 f9 ff ff       	call   c01002ba <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009a7:	c7 44 24 04 1e 61 10 	movl   $0xc010611e,0x4(%esp)
c01009ae:	c0 
c01009af:	c7 04 24 53 62 10 c0 	movl   $0xc0106253,(%esp)
c01009b6:	e8 ff f8 ff ff       	call   c01002ba <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009bb:	c7 44 24 04 00 c0 11 	movl   $0xc011c000,0x4(%esp)
c01009c2:	c0 
c01009c3:	c7 04 24 6b 62 10 c0 	movl   $0xc010626b,(%esp)
c01009ca:	e8 eb f8 ff ff       	call   c01002ba <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009cf:	c7 44 24 04 28 cf 11 	movl   $0xc011cf28,0x4(%esp)
c01009d6:	c0 
c01009d7:	c7 04 24 83 62 10 c0 	movl   $0xc0106283,(%esp)
c01009de:	e8 d7 f8 ff ff       	call   c01002ba <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009e3:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c01009e8:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01009ed:	05 ff 03 00 00       	add    $0x3ff,%eax
c01009f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009f8:	85 c0                	test   %eax,%eax
c01009fa:	0f 48 c2             	cmovs  %edx,%eax
c01009fd:	c1 f8 0a             	sar    $0xa,%eax
c0100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a04:	c7 04 24 9c 62 10 c0 	movl   $0xc010629c,(%esp)
c0100a0b:	e8 aa f8 ff ff       	call   c01002ba <cprintf>
}
c0100a10:	90                   	nop
c0100a11:	c9                   	leave  
c0100a12:	c3                   	ret    

c0100a13 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a13:	f3 0f 1e fb          	endbr32 
c0100a17:	55                   	push   %ebp
c0100a18:	89 e5                	mov    %esp,%ebp
c0100a1a:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a20:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a27:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a2a:	89 04 24             	mov    %eax,(%esp)
c0100a2d:	e8 21 fc ff ff       	call   c0100653 <debuginfo_eip>
c0100a32:	85 c0                	test   %eax,%eax
c0100a34:	74 15                	je     c0100a4b <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a36:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3d:	c7 04 24 c6 62 10 c0 	movl   $0xc01062c6,(%esp)
c0100a44:	e8 71 f8 ff ff       	call   c01002ba <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a49:	eb 6c                	jmp    c0100ab7 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a52:	eb 1b                	jmp    c0100a6f <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
c0100a54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5a:	01 d0                	add    %edx,%eax
c0100a5c:	0f b6 10             	movzbl (%eax),%edx
c0100a5f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a68:	01 c8                	add    %ecx,%eax
c0100a6a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a6c:	ff 45 f4             	incl   -0xc(%ebp)
c0100a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a72:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a75:	7c dd                	jl     c0100a54 <print_debuginfo+0x41>
        fnname[j] = '\0';
c0100a77:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a80:	01 d0                	add    %edx,%eax
c0100a82:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a88:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a8b:	89 d1                	mov    %edx,%ecx
c0100a8d:	29 c1                	sub    %eax,%ecx
c0100a8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a92:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a95:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a99:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aa3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aab:	c7 04 24 e2 62 10 c0 	movl   $0xc01062e2,(%esp)
c0100ab2:	e8 03 f8 ff ff       	call   c01002ba <cprintf>
}
c0100ab7:	90                   	nop
c0100ab8:	c9                   	leave  
c0100ab9:	c3                   	ret    

c0100aba <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100aba:	f3 0f 1e fb          	endbr32 
c0100abe:	55                   	push   %ebp
c0100abf:	89 e5                	mov    %esp,%ebp
c0100ac1:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100ac4:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ac7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100acd:	c9                   	leave  
c0100ace:	c3                   	ret    

c0100acf <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100acf:	f3 0f 1e fb          	endbr32 
c0100ad3:	55                   	push   %ebp
c0100ad4:	89 e5                	mov    %esp,%ebp
c0100ad6:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100ad9:	89 e8                	mov    %ebp,%eax
c0100adb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ae4:	e8 d1 ff ff ff       	call   c0100aba <read_eip>
c0100ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100aec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100af3:	e9 84 00 00 00       	jmp    c0100b7c <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100afb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b06:	c7 04 24 f4 62 10 c0 	movl   $0xc01062f4,(%esp)
c0100b0d:	e8 a8 f7 ff ff       	call   c01002ba <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b15:	83 c0 08             	add    $0x8,%eax
c0100b18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100b1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100b22:	eb 24                	jmp    c0100b48 <print_stackframe+0x79>
            cprintf("0x%08x ", args[j]);
c0100b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b31:	01 d0                	add    %edx,%eax
c0100b33:	8b 00                	mov    (%eax),%eax
c0100b35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b39:	c7 04 24 10 63 10 c0 	movl   $0xc0106310,(%esp)
c0100b40:	e8 75 f7 ff ff       	call   c01002ba <cprintf>
        for (j = 0; j < 4; j ++) {
c0100b45:	ff 45 e8             	incl   -0x18(%ebp)
c0100b48:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b4c:	7e d6                	jle    c0100b24 <print_stackframe+0x55>
        }
        cprintf("\n");
c0100b4e:	c7 04 24 18 63 10 c0 	movl   $0xc0106318,(%esp)
c0100b55:	e8 60 f7 ff ff       	call   c01002ba <cprintf>
        print_debuginfo(eip - 1);
c0100b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b5d:	48                   	dec    %eax
c0100b5e:	89 04 24             	mov    %eax,(%esp)
c0100b61:	e8 ad fe ff ff       	call   c0100a13 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b69:	83 c0 04             	add    $0x4,%eax
c0100b6c:	8b 00                	mov    (%eax),%eax
c0100b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b74:	8b 00                	mov    (%eax),%eax
c0100b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100b79:	ff 45 ec             	incl   -0x14(%ebp)
c0100b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b80:	74 0a                	je     c0100b8c <print_stackframe+0xbd>
c0100b82:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b86:	0f 8e 6c ff ff ff    	jle    c0100af8 <print_stackframe+0x29>
    }
}
c0100b8c:	90                   	nop
c0100b8d:	c9                   	leave  
c0100b8e:	c3                   	ret    

c0100b8f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b8f:	f3 0f 1e fb          	endbr32 
c0100b93:	55                   	push   %ebp
c0100b94:	89 e5                	mov    %esp,%ebp
c0100b96:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ba0:	eb 0c                	jmp    c0100bae <parse+0x1f>
            *buf ++ = '\0';
c0100ba2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba5:	8d 50 01             	lea    0x1(%eax),%edx
c0100ba8:	89 55 08             	mov    %edx,0x8(%ebp)
c0100bab:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb1:	0f b6 00             	movzbl (%eax),%eax
c0100bb4:	84 c0                	test   %al,%al
c0100bb6:	74 1d                	je     c0100bd5 <parse+0x46>
c0100bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bbb:	0f b6 00             	movzbl (%eax),%eax
c0100bbe:	0f be c0             	movsbl %al,%eax
c0100bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc5:	c7 04 24 9c 63 10 c0 	movl   $0xc010639c,(%esp)
c0100bcc:	e8 67 4b 00 00       	call   c0105738 <strchr>
c0100bd1:	85 c0                	test   %eax,%eax
c0100bd3:	75 cd                	jne    c0100ba2 <parse+0x13>
        }
        if (*buf == '\0') {
c0100bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd8:	0f b6 00             	movzbl (%eax),%eax
c0100bdb:	84 c0                	test   %al,%al
c0100bdd:	74 65                	je     c0100c44 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bdf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100be3:	75 14                	jne    c0100bf9 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100be5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bec:	00 
c0100bed:	c7 04 24 a1 63 10 c0 	movl   $0xc01063a1,(%esp)
c0100bf4:	e8 c1 f6 ff ff       	call   c01002ba <cprintf>
        }
        argv[argc ++] = buf;
c0100bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bfc:	8d 50 01             	lea    0x1(%eax),%edx
c0100bff:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100c02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c0c:	01 c2                	add    %eax,%edx
c0100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c11:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c13:	eb 03                	jmp    c0100c18 <parse+0x89>
            buf ++;
c0100c15:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1b:	0f b6 00             	movzbl (%eax),%eax
c0100c1e:	84 c0                	test   %al,%al
c0100c20:	74 8c                	je     c0100bae <parse+0x1f>
c0100c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c25:	0f b6 00             	movzbl (%eax),%eax
c0100c28:	0f be c0             	movsbl %al,%eax
c0100c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c2f:	c7 04 24 9c 63 10 c0 	movl   $0xc010639c,(%esp)
c0100c36:	e8 fd 4a 00 00       	call   c0105738 <strchr>
c0100c3b:	85 c0                	test   %eax,%eax
c0100c3d:	74 d6                	je     c0100c15 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c3f:	e9 6a ff ff ff       	jmp    c0100bae <parse+0x1f>
            break;
c0100c44:	90                   	nop
        }
    }
    return argc;
c0100c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c48:	c9                   	leave  
c0100c49:	c3                   	ret    

c0100c4a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c4a:	f3 0f 1e fb          	endbr32 
c0100c4e:	55                   	push   %ebp
c0100c4f:	89 e5                	mov    %esp,%ebp
c0100c51:	53                   	push   %ebx
c0100c52:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c55:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c5f:	89 04 24             	mov    %eax,(%esp)
c0100c62:	e8 28 ff ff ff       	call   c0100b8f <parse>
c0100c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c6e:	75 0a                	jne    c0100c7a <runcmd+0x30>
        return 0;
c0100c70:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c75:	e9 83 00 00 00       	jmp    c0100cfd <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c81:	eb 5a                	jmp    c0100cdd <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c83:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c89:	89 d0                	mov    %edx,%eax
c0100c8b:	01 c0                	add    %eax,%eax
c0100c8d:	01 d0                	add    %edx,%eax
c0100c8f:	c1 e0 02             	shl    $0x2,%eax
c0100c92:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100c97:	8b 00                	mov    (%eax),%eax
c0100c99:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c9d:	89 04 24             	mov    %eax,(%esp)
c0100ca0:	e8 ef 49 00 00       	call   c0105694 <strcmp>
c0100ca5:	85 c0                	test   %eax,%eax
c0100ca7:	75 31                	jne    c0100cda <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cac:	89 d0                	mov    %edx,%eax
c0100cae:	01 c0                	add    %eax,%eax
c0100cb0:	01 d0                	add    %edx,%eax
c0100cb2:	c1 e0 02             	shl    $0x2,%eax
c0100cb5:	05 08 90 11 c0       	add    $0xc0119008,%eax
c0100cba:	8b 10                	mov    (%eax),%edx
c0100cbc:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100cbf:	83 c0 04             	add    $0x4,%eax
c0100cc2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100cc5:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100ccb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cd3:	89 1c 24             	mov    %ebx,(%esp)
c0100cd6:	ff d2                	call   *%edx
c0100cd8:	eb 23                	jmp    c0100cfd <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cda:	ff 45 f4             	incl   -0xc(%ebp)
c0100cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ce0:	83 f8 02             	cmp    $0x2,%eax
c0100ce3:	76 9e                	jbe    c0100c83 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100ce5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cec:	c7 04 24 bf 63 10 c0 	movl   $0xc01063bf,(%esp)
c0100cf3:	e8 c2 f5 ff ff       	call   c01002ba <cprintf>
    return 0;
c0100cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cfd:	83 c4 64             	add    $0x64,%esp
c0100d00:	5b                   	pop    %ebx
c0100d01:	5d                   	pop    %ebp
c0100d02:	c3                   	ret    

c0100d03 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100d03:	f3 0f 1e fb          	endbr32 
c0100d07:	55                   	push   %ebp
c0100d08:	89 e5                	mov    %esp,%ebp
c0100d0a:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100d0d:	c7 04 24 d8 63 10 c0 	movl   $0xc01063d8,(%esp)
c0100d14:	e8 a1 f5 ff ff       	call   c01002ba <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d19:	c7 04 24 00 64 10 c0 	movl   $0xc0106400,(%esp)
c0100d20:	e8 95 f5 ff ff       	call   c01002ba <cprintf>

    if (tf != NULL) {
c0100d25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d29:	74 0b                	je     c0100d36 <kmonitor+0x33>
        print_trapframe(tf);
c0100d2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d2e:	89 04 24             	mov    %eax,(%esp)
c0100d31:	e8 e1 0d 00 00       	call   c0101b17 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d36:	c7 04 24 25 64 10 c0 	movl   $0xc0106425,(%esp)
c0100d3d:	e8 2b f6 ff ff       	call   c010036d <readline>
c0100d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d49:	74 eb                	je     c0100d36 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
c0100d4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d55:	89 04 24             	mov    %eax,(%esp)
c0100d58:	e8 ed fe ff ff       	call   c0100c4a <runcmd>
c0100d5d:	85 c0                	test   %eax,%eax
c0100d5f:	78 02                	js     c0100d63 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
c0100d61:	eb d3                	jmp    c0100d36 <kmonitor+0x33>
                break;
c0100d63:	90                   	nop
            }
        }
    }
}
c0100d64:	90                   	nop
c0100d65:	c9                   	leave  
c0100d66:	c3                   	ret    

c0100d67 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d67:	f3 0f 1e fb          	endbr32 
c0100d6b:	55                   	push   %ebp
c0100d6c:	89 e5                	mov    %esp,%ebp
c0100d6e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d78:	eb 3d                	jmp    c0100db7 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d7d:	89 d0                	mov    %edx,%eax
c0100d7f:	01 c0                	add    %eax,%eax
c0100d81:	01 d0                	add    %edx,%eax
c0100d83:	c1 e0 02             	shl    $0x2,%eax
c0100d86:	05 04 90 11 c0       	add    $0xc0119004,%eax
c0100d8b:	8b 08                	mov    (%eax),%ecx
c0100d8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d90:	89 d0                	mov    %edx,%eax
c0100d92:	01 c0                	add    %eax,%eax
c0100d94:	01 d0                	add    %edx,%eax
c0100d96:	c1 e0 02             	shl    $0x2,%eax
c0100d99:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100d9e:	8b 00                	mov    (%eax),%eax
c0100da0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100da4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100da8:	c7 04 24 29 64 10 c0 	movl   $0xc0106429,(%esp)
c0100daf:	e8 06 f5 ff ff       	call   c01002ba <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100db4:	ff 45 f4             	incl   -0xc(%ebp)
c0100db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100dba:	83 f8 02             	cmp    $0x2,%eax
c0100dbd:	76 bb                	jbe    c0100d7a <mon_help+0x13>
    }
    return 0;
c0100dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dc4:	c9                   	leave  
c0100dc5:	c3                   	ret    

c0100dc6 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100dc6:	f3 0f 1e fb          	endbr32 
c0100dca:	55                   	push   %ebp
c0100dcb:	89 e5                	mov    %esp,%ebp
c0100dcd:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100dd0:	e8 a8 fb ff ff       	call   c010097d <print_kerninfo>
    return 0;
c0100dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dda:	c9                   	leave  
c0100ddb:	c3                   	ret    

c0100ddc <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ddc:	f3 0f 1e fb          	endbr32 
c0100de0:	55                   	push   %ebp
c0100de1:	89 e5                	mov    %esp,%ebp
c0100de3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100de6:	e8 e4 fc ff ff       	call   c0100acf <print_stackframe>
    return 0;
c0100deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df0:	c9                   	leave  
c0100df1:	c3                   	ret    

c0100df2 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100df2:	f3 0f 1e fb          	endbr32 
c0100df6:	55                   	push   %ebp
c0100df7:	89 e5                	mov    %esp,%ebp
c0100df9:	83 ec 28             	sub    $0x28,%esp
c0100dfc:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100e02:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e06:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e0a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e0e:	ee                   	out    %al,(%dx)
}
c0100e0f:	90                   	nop
c0100e10:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e16:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e1a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e1e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e22:	ee                   	out    %al,(%dx)
}
c0100e23:	90                   	nop
c0100e24:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e2a:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e2e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e32:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e36:	ee                   	out    %al,(%dx)
}
c0100e37:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e38:	c7 05 0c cf 11 c0 00 	movl   $0x0,0xc011cf0c
c0100e3f:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e42:	c7 04 24 32 64 10 c0 	movl   $0xc0106432,(%esp)
c0100e49:	e8 6c f4 ff ff       	call   c01002ba <cprintf>
    pic_enable(IRQ_TIMER);
c0100e4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e55:	e8 95 09 00 00       	call   c01017ef <pic_enable>
}
c0100e5a:	90                   	nop
c0100e5b:	c9                   	leave  
c0100e5c:	c3                   	ret    

c0100e5d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e5d:	55                   	push   %ebp
c0100e5e:	89 e5                	mov    %esp,%ebp
c0100e60:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e63:	9c                   	pushf  
c0100e64:	58                   	pop    %eax
c0100e65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e6b:	25 00 02 00 00       	and    $0x200,%eax
c0100e70:	85 c0                	test   %eax,%eax
c0100e72:	74 0c                	je     c0100e80 <__intr_save+0x23>
        intr_disable();
c0100e74:	e8 05 0b 00 00       	call   c010197e <intr_disable>
        return 1;
c0100e79:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e7e:	eb 05                	jmp    c0100e85 <__intr_save+0x28>
    }
    return 0;
c0100e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e85:	c9                   	leave  
c0100e86:	c3                   	ret    

c0100e87 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e87:	55                   	push   %ebp
c0100e88:	89 e5                	mov    %esp,%ebp
c0100e8a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e91:	74 05                	je     c0100e98 <__intr_restore+0x11>
        intr_enable();
c0100e93:	e8 da 0a 00 00       	call   c0101972 <intr_enable>
    }
}
c0100e98:	90                   	nop
c0100e99:	c9                   	leave  
c0100e9a:	c3                   	ret    

c0100e9b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e9b:	f3 0f 1e fb          	endbr32 
c0100e9f:	55                   	push   %ebp
c0100ea0:	89 e5                	mov    %esp,%ebp
c0100ea2:	83 ec 10             	sub    $0x10,%esp
c0100ea5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eab:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100eaf:	89 c2                	mov    %eax,%edx
c0100eb1:	ec                   	in     (%dx),%al
c0100eb2:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100eb5:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100ebb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100ebf:	89 c2                	mov    %eax,%edx
c0100ec1:	ec                   	in     (%dx),%al
c0100ec2:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100ec5:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100ecb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100ecf:	89 c2                	mov    %eax,%edx
c0100ed1:	ec                   	in     (%dx),%al
c0100ed2:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100ed5:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100edb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100edf:	89 c2                	mov    %eax,%edx
c0100ee1:	ec                   	in     (%dx),%al
c0100ee2:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100ee5:	90                   	nop
c0100ee6:	c9                   	leave  
c0100ee7:	c3                   	ret    

c0100ee8 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100ee8:	f3 0f 1e fb          	endbr32 
c0100eec:	55                   	push   %ebp
c0100eed:	89 e5                	mov    %esp,%ebp
c0100eef:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ef2:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100efc:	0f b7 00             	movzwl (%eax),%eax
c0100eff:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f06:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f0e:	0f b7 00             	movzwl (%eax),%eax
c0100f11:	0f b7 c0             	movzwl %ax,%eax
c0100f14:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100f19:	74 12                	je     c0100f2d <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f1b:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100f22:	66 c7 05 46 c4 11 c0 	movw   $0x3b4,0xc011c446
c0100f29:	b4 03 
c0100f2b:	eb 13                	jmp    c0100f40 <cga_init+0x58>
    } else {
        *cp = was;
c0100f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f30:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f34:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f37:	66 c7 05 46 c4 11 c0 	movw   $0x3d4,0xc011c446
c0100f3e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f40:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f47:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f4b:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f4f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f53:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f57:	ee                   	out    %al,(%dx)
}
c0100f58:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f59:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f60:	40                   	inc    %eax
c0100f61:	0f b7 c0             	movzwl %ax,%eax
c0100f64:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f68:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f6c:	89 c2                	mov    %eax,%edx
c0100f6e:	ec                   	in     (%dx),%al
c0100f6f:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f72:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f76:	0f b6 c0             	movzbl %al,%eax
c0100f79:	c1 e0 08             	shl    $0x8,%eax
c0100f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f7f:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f86:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f8a:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f8e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f92:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f96:	ee                   	out    %al,(%dx)
}
c0100f97:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f98:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f9f:	40                   	inc    %eax
c0100fa0:	0f b7 c0             	movzwl %ax,%eax
c0100fa3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fa7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100fab:	89 c2                	mov    %eax,%edx
c0100fad:	ec                   	in     (%dx),%al
c0100fae:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100fb1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fb5:	0f b6 c0             	movzbl %al,%eax
c0100fb8:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fbe:	a3 40 c4 11 c0       	mov    %eax,0xc011c440
    crt_pos = pos;
c0100fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100fc6:	0f b7 c0             	movzwl %ax,%eax
c0100fc9:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
}
c0100fcf:	90                   	nop
c0100fd0:	c9                   	leave  
c0100fd1:	c3                   	ret    

c0100fd2 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fd2:	f3 0f 1e fb          	endbr32 
c0100fd6:	55                   	push   %ebp
c0100fd7:	89 e5                	mov    %esp,%ebp
c0100fd9:	83 ec 48             	sub    $0x48,%esp
c0100fdc:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fe2:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fe6:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fea:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fee:	ee                   	out    %al,(%dx)
}
c0100fef:	90                   	nop
c0100ff0:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100ff6:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ffa:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100ffe:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101002:	ee                   	out    %al,(%dx)
}
c0101003:	90                   	nop
c0101004:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c010100a:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010100e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101012:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101016:	ee                   	out    %al,(%dx)
}
c0101017:	90                   	nop
c0101018:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c010101e:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101022:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101026:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010102a:	ee                   	out    %al,(%dx)
}
c010102b:	90                   	nop
c010102c:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101032:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101036:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010103a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010103e:	ee                   	out    %al,(%dx)
}
c010103f:	90                   	nop
c0101040:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101046:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010104a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010104e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101052:	ee                   	out    %al,(%dx)
}
c0101053:	90                   	nop
c0101054:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010105a:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010105e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101062:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101066:	ee                   	out    %al,(%dx)
}
c0101067:	90                   	nop
c0101068:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010106e:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101072:	89 c2                	mov    %eax,%edx
c0101074:	ec                   	in     (%dx),%al
c0101075:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101078:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010107c:	3c ff                	cmp    $0xff,%al
c010107e:	0f 95 c0             	setne  %al
c0101081:	0f b6 c0             	movzbl %al,%eax
c0101084:	a3 48 c4 11 c0       	mov    %eax,0xc011c448
c0101089:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010108f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101093:	89 c2                	mov    %eax,%edx
c0101095:	ec                   	in     (%dx),%al
c0101096:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101099:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010109f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010a3:	89 c2                	mov    %eax,%edx
c01010a5:	ec                   	in     (%dx),%al
c01010a6:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01010a9:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01010ae:	85 c0                	test   %eax,%eax
c01010b0:	74 0c                	je     c01010be <serial_init+0xec>
        pic_enable(IRQ_COM1);
c01010b2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01010b9:	e8 31 07 00 00       	call   c01017ef <pic_enable>
    }
}
c01010be:	90                   	nop
c01010bf:	c9                   	leave  
c01010c0:	c3                   	ret    

c01010c1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01010c1:	f3 0f 1e fb          	endbr32 
c01010c5:	55                   	push   %ebp
c01010c6:	89 e5                	mov    %esp,%ebp
c01010c8:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010d2:	eb 08                	jmp    c01010dc <lpt_putc_sub+0x1b>
        delay();
c01010d4:	e8 c2 fd ff ff       	call   c0100e9b <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010d9:	ff 45 fc             	incl   -0x4(%ebp)
c01010dc:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010e2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010e6:	89 c2                	mov    %eax,%edx
c01010e8:	ec                   	in     (%dx),%al
c01010e9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010ec:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010f0:	84 c0                	test   %al,%al
c01010f2:	78 09                	js     c01010fd <lpt_putc_sub+0x3c>
c01010f4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010fb:	7e d7                	jle    c01010d4 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
c01010fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101100:	0f b6 c0             	movzbl %al,%eax
c0101103:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101109:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010110c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101110:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101114:	ee                   	out    %al,(%dx)
}
c0101115:	90                   	nop
c0101116:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010111c:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101120:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101124:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101128:	ee                   	out    %al,(%dx)
}
c0101129:	90                   	nop
c010112a:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101130:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101134:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101138:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010113c:	ee                   	out    %al,(%dx)
}
c010113d:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010113e:	90                   	nop
c010113f:	c9                   	leave  
c0101140:	c3                   	ret    

c0101141 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101141:	f3 0f 1e fb          	endbr32 
c0101145:	55                   	push   %ebp
c0101146:	89 e5                	mov    %esp,%ebp
c0101148:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010114b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010114f:	74 0d                	je     c010115e <lpt_putc+0x1d>
        lpt_putc_sub(c);
c0101151:	8b 45 08             	mov    0x8(%ebp),%eax
c0101154:	89 04 24             	mov    %eax,(%esp)
c0101157:	e8 65 ff ff ff       	call   c01010c1 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010115c:	eb 24                	jmp    c0101182 <lpt_putc+0x41>
        lpt_putc_sub('\b');
c010115e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101165:	e8 57 ff ff ff       	call   c01010c1 <lpt_putc_sub>
        lpt_putc_sub(' ');
c010116a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101171:	e8 4b ff ff ff       	call   c01010c1 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101176:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010117d:	e8 3f ff ff ff       	call   c01010c1 <lpt_putc_sub>
}
c0101182:	90                   	nop
c0101183:	c9                   	leave  
c0101184:	c3                   	ret    

c0101185 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101185:	f3 0f 1e fb          	endbr32 
c0101189:	55                   	push   %ebp
c010118a:	89 e5                	mov    %esp,%ebp
c010118c:	53                   	push   %ebx
c010118d:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101190:	8b 45 08             	mov    0x8(%ebp),%eax
c0101193:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101198:	85 c0                	test   %eax,%eax
c010119a:	75 07                	jne    c01011a3 <cga_putc+0x1e>
        c |= 0x0700;
c010119c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01011a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01011a6:	0f b6 c0             	movzbl %al,%eax
c01011a9:	83 f8 0d             	cmp    $0xd,%eax
c01011ac:	74 72                	je     c0101220 <cga_putc+0x9b>
c01011ae:	83 f8 0d             	cmp    $0xd,%eax
c01011b1:	0f 8f a3 00 00 00    	jg     c010125a <cga_putc+0xd5>
c01011b7:	83 f8 08             	cmp    $0x8,%eax
c01011ba:	74 0a                	je     c01011c6 <cga_putc+0x41>
c01011bc:	83 f8 0a             	cmp    $0xa,%eax
c01011bf:	74 4c                	je     c010120d <cga_putc+0x88>
c01011c1:	e9 94 00 00 00       	jmp    c010125a <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
c01011c6:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011cd:	85 c0                	test   %eax,%eax
c01011cf:	0f 84 af 00 00 00    	je     c0101284 <cga_putc+0xff>
            crt_pos --;
c01011d5:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011dc:	48                   	dec    %eax
c01011dd:	0f b7 c0             	movzwl %ax,%eax
c01011e0:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01011e9:	98                   	cwtl   
c01011ea:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011ef:	98                   	cwtl   
c01011f0:	83 c8 20             	or     $0x20,%eax
c01011f3:	98                   	cwtl   
c01011f4:	8b 15 40 c4 11 c0    	mov    0xc011c440,%edx
c01011fa:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c0101201:	01 c9                	add    %ecx,%ecx
c0101203:	01 ca                	add    %ecx,%edx
c0101205:	0f b7 c0             	movzwl %ax,%eax
c0101208:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010120b:	eb 77                	jmp    c0101284 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
c010120d:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101214:	83 c0 50             	add    $0x50,%eax
c0101217:	0f b7 c0             	movzwl %ax,%eax
c010121a:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101220:	0f b7 1d 44 c4 11 c0 	movzwl 0xc011c444,%ebx
c0101227:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c010122e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c0101233:	89 c8                	mov    %ecx,%eax
c0101235:	f7 e2                	mul    %edx
c0101237:	c1 ea 06             	shr    $0x6,%edx
c010123a:	89 d0                	mov    %edx,%eax
c010123c:	c1 e0 02             	shl    $0x2,%eax
c010123f:	01 d0                	add    %edx,%eax
c0101241:	c1 e0 04             	shl    $0x4,%eax
c0101244:	29 c1                	sub    %eax,%ecx
c0101246:	89 c8                	mov    %ecx,%eax
c0101248:	0f b7 c0             	movzwl %ax,%eax
c010124b:	29 c3                	sub    %eax,%ebx
c010124d:	89 d8                	mov    %ebx,%eax
c010124f:	0f b7 c0             	movzwl %ax,%eax
c0101252:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
        break;
c0101258:	eb 2b                	jmp    c0101285 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010125a:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c0101260:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101267:	8d 50 01             	lea    0x1(%eax),%edx
c010126a:	0f b7 d2             	movzwl %dx,%edx
c010126d:	66 89 15 44 c4 11 c0 	mov    %dx,0xc011c444
c0101274:	01 c0                	add    %eax,%eax
c0101276:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101279:	8b 45 08             	mov    0x8(%ebp),%eax
c010127c:	0f b7 c0             	movzwl %ax,%eax
c010127f:	66 89 02             	mov    %ax,(%edx)
        break;
c0101282:	eb 01                	jmp    c0101285 <cga_putc+0x100>
        break;
c0101284:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101285:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010128c:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101291:	76 5d                	jbe    c01012f0 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101293:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101298:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010129e:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012a3:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012aa:	00 
c01012ab:	89 54 24 04          	mov    %edx,0x4(%esp)
c01012af:	89 04 24             	mov    %eax,(%esp)
c01012b2:	e8 86 46 00 00       	call   c010593d <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012b7:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01012be:	eb 14                	jmp    c01012d4 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
c01012c0:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012c8:	01 d2                	add    %edx,%edx
c01012ca:	01 d0                	add    %edx,%eax
c01012cc:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012d1:	ff 45 f4             	incl   -0xc(%ebp)
c01012d4:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012db:	7e e3                	jle    c01012c0 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
c01012dd:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012e4:	83 e8 50             	sub    $0x50,%eax
c01012e7:	0f b7 c0             	movzwl %ax,%eax
c01012ea:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012f0:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012f7:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012fb:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012ff:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101303:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101307:	ee                   	out    %al,(%dx)
}
c0101308:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c0101309:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101310:	c1 e8 08             	shr    $0x8,%eax
c0101313:	0f b7 c0             	movzwl %ax,%eax
c0101316:	0f b6 c0             	movzbl %al,%eax
c0101319:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101320:	42                   	inc    %edx
c0101321:	0f b7 d2             	movzwl %dx,%edx
c0101324:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101328:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010132b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010132f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101333:	ee                   	out    %al,(%dx)
}
c0101334:	90                   	nop
    outb(addr_6845, 15);
c0101335:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c010133c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101340:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101344:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101348:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010134c:	ee                   	out    %al,(%dx)
}
c010134d:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c010134e:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101355:	0f b6 c0             	movzbl %al,%eax
c0101358:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c010135f:	42                   	inc    %edx
c0101360:	0f b7 d2             	movzwl %dx,%edx
c0101363:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101367:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010136a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010136e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101372:	ee                   	out    %al,(%dx)
}
c0101373:	90                   	nop
}
c0101374:	90                   	nop
c0101375:	83 c4 34             	add    $0x34,%esp
c0101378:	5b                   	pop    %ebx
c0101379:	5d                   	pop    %ebp
c010137a:	c3                   	ret    

c010137b <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010137b:	f3 0f 1e fb          	endbr32 
c010137f:	55                   	push   %ebp
c0101380:	89 e5                	mov    %esp,%ebp
c0101382:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010138c:	eb 08                	jmp    c0101396 <serial_putc_sub+0x1b>
        delay();
c010138e:	e8 08 fb ff ff       	call   c0100e9b <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101393:	ff 45 fc             	incl   -0x4(%ebp)
c0101396:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010139c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013a0:	89 c2                	mov    %eax,%edx
c01013a2:	ec                   	in     (%dx),%al
c01013a3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013a6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013aa:	0f b6 c0             	movzbl %al,%eax
c01013ad:	83 e0 20             	and    $0x20,%eax
c01013b0:	85 c0                	test   %eax,%eax
c01013b2:	75 09                	jne    c01013bd <serial_putc_sub+0x42>
c01013b4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01013bb:	7e d1                	jle    c010138e <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
c01013bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c0:	0f b6 c0             	movzbl %al,%eax
c01013c3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01013c9:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013cc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01013d0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01013d4:	ee                   	out    %al,(%dx)
}
c01013d5:	90                   	nop
}
c01013d6:	90                   	nop
c01013d7:	c9                   	leave  
c01013d8:	c3                   	ret    

c01013d9 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013d9:	f3 0f 1e fb          	endbr32 
c01013dd:	55                   	push   %ebp
c01013de:	89 e5                	mov    %esp,%ebp
c01013e0:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013e3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013e7:	74 0d                	je     c01013f6 <serial_putc+0x1d>
        serial_putc_sub(c);
c01013e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ec:	89 04 24             	mov    %eax,(%esp)
c01013ef:	e8 87 ff ff ff       	call   c010137b <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013f4:	eb 24                	jmp    c010141a <serial_putc+0x41>
        serial_putc_sub('\b');
c01013f6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013fd:	e8 79 ff ff ff       	call   c010137b <serial_putc_sub>
        serial_putc_sub(' ');
c0101402:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101409:	e8 6d ff ff ff       	call   c010137b <serial_putc_sub>
        serial_putc_sub('\b');
c010140e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101415:	e8 61 ff ff ff       	call   c010137b <serial_putc_sub>
}
c010141a:	90                   	nop
c010141b:	c9                   	leave  
c010141c:	c3                   	ret    

c010141d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010141d:	f3 0f 1e fb          	endbr32 
c0101421:	55                   	push   %ebp
c0101422:	89 e5                	mov    %esp,%ebp
c0101424:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101427:	eb 33                	jmp    c010145c <cons_intr+0x3f>
        if (c != 0) {
c0101429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010142d:	74 2d                	je     c010145c <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
c010142f:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101434:	8d 50 01             	lea    0x1(%eax),%edx
c0101437:	89 15 64 c6 11 c0    	mov    %edx,0xc011c664
c010143d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101440:	88 90 60 c4 11 c0    	mov    %dl,-0x3fee3ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101446:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c010144b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101450:	75 0a                	jne    c010145c <cons_intr+0x3f>
                cons.wpos = 0;
c0101452:	c7 05 64 c6 11 c0 00 	movl   $0x0,0xc011c664
c0101459:	00 00 00 
    while ((c = (*proc)()) != -1) {
c010145c:	8b 45 08             	mov    0x8(%ebp),%eax
c010145f:	ff d0                	call   *%eax
c0101461:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101464:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101468:	75 bf                	jne    c0101429 <cons_intr+0xc>
            }
        }
    }
}
c010146a:	90                   	nop
c010146b:	90                   	nop
c010146c:	c9                   	leave  
c010146d:	c3                   	ret    

c010146e <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010146e:	f3 0f 1e fb          	endbr32 
c0101472:	55                   	push   %ebp
c0101473:	89 e5                	mov    %esp,%ebp
c0101475:	83 ec 10             	sub    $0x10,%esp
c0101478:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010147e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101482:	89 c2                	mov    %eax,%edx
c0101484:	ec                   	in     (%dx),%al
c0101485:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101488:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010148c:	0f b6 c0             	movzbl %al,%eax
c010148f:	83 e0 01             	and    $0x1,%eax
c0101492:	85 c0                	test   %eax,%eax
c0101494:	75 07                	jne    c010149d <serial_proc_data+0x2f>
        return -1;
c0101496:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010149b:	eb 2a                	jmp    c01014c7 <serial_proc_data+0x59>
c010149d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014a3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014a7:	89 c2                	mov    %eax,%edx
c01014a9:	ec                   	in     (%dx),%al
c01014aa:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014ad:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014b1:	0f b6 c0             	movzbl %al,%eax
c01014b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014b7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014bb:	75 07                	jne    c01014c4 <serial_proc_data+0x56>
        c = '\b';
c01014bd:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01014c7:	c9                   	leave  
c01014c8:	c3                   	ret    

c01014c9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01014c9:	f3 0f 1e fb          	endbr32 
c01014cd:	55                   	push   %ebp
c01014ce:	89 e5                	mov    %esp,%ebp
c01014d0:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01014d3:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01014d8:	85 c0                	test   %eax,%eax
c01014da:	74 0c                	je     c01014e8 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01014dc:	c7 04 24 6e 14 10 c0 	movl   $0xc010146e,(%esp)
c01014e3:	e8 35 ff ff ff       	call   c010141d <cons_intr>
    }
}
c01014e8:	90                   	nop
c01014e9:	c9                   	leave  
c01014ea:	c3                   	ret    

c01014eb <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014eb:	f3 0f 1e fb          	endbr32 
c01014ef:	55                   	push   %ebp
c01014f0:	89 e5                	mov    %esp,%ebp
c01014f2:	83 ec 38             	sub    $0x38,%esp
c01014f5:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014fe:	89 c2                	mov    %eax,%edx
c0101500:	ec                   	in     (%dx),%al
c0101501:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101504:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101508:	0f b6 c0             	movzbl %al,%eax
c010150b:	83 e0 01             	and    $0x1,%eax
c010150e:	85 c0                	test   %eax,%eax
c0101510:	75 0a                	jne    c010151c <kbd_proc_data+0x31>
        return -1;
c0101512:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101517:	e9 56 01 00 00       	jmp    c0101672 <kbd_proc_data+0x187>
c010151c:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101522:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101525:	89 c2                	mov    %eax,%edx
c0101527:	ec                   	in     (%dx),%al
c0101528:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010152b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010152f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101532:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101536:	75 17                	jne    c010154f <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
c0101538:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010153d:	83 c8 40             	or     $0x40,%eax
c0101540:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101545:	b8 00 00 00 00       	mov    $0x0,%eax
c010154a:	e9 23 01 00 00       	jmp    c0101672 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010154f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101553:	84 c0                	test   %al,%al
c0101555:	79 45                	jns    c010159c <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101557:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010155c:	83 e0 40             	and    $0x40,%eax
c010155f:	85 c0                	test   %eax,%eax
c0101561:	75 08                	jne    c010156b <kbd_proc_data+0x80>
c0101563:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101567:	24 7f                	and    $0x7f,%al
c0101569:	eb 04                	jmp    c010156f <kbd_proc_data+0x84>
c010156b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010156f:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101572:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101576:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c010157d:	0c 40                	or     $0x40,%al
c010157f:	0f b6 c0             	movzbl %al,%eax
c0101582:	f7 d0                	not    %eax
c0101584:	89 c2                	mov    %eax,%edx
c0101586:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010158b:	21 d0                	and    %edx,%eax
c010158d:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101592:	b8 00 00 00 00       	mov    $0x0,%eax
c0101597:	e9 d6 00 00 00       	jmp    c0101672 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c010159c:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015a1:	83 e0 40             	and    $0x40,%eax
c01015a4:	85 c0                	test   %eax,%eax
c01015a6:	74 11                	je     c01015b9 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015a8:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015ac:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015b1:	83 e0 bf             	and    $0xffffffbf,%eax
c01015b4:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    }

    shift |= shiftcode[data];
c01015b9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015bd:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c01015c4:	0f b6 d0             	movzbl %al,%edx
c01015c7:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015cc:	09 d0                	or     %edx,%eax
c01015ce:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    shift ^= togglecode[data];
c01015d3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015d7:	0f b6 80 40 91 11 c0 	movzbl -0x3fee6ec0(%eax),%eax
c01015de:	0f b6 d0             	movzbl %al,%edx
c01015e1:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015e6:	31 d0                	xor    %edx,%eax
c01015e8:	a3 68 c6 11 c0       	mov    %eax,0xc011c668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015ed:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015f2:	83 e0 03             	and    $0x3,%eax
c01015f5:	8b 14 85 40 95 11 c0 	mov    -0x3fee6ac0(,%eax,4),%edx
c01015fc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101600:	01 d0                	add    %edx,%eax
c0101602:	0f b6 00             	movzbl (%eax),%eax
c0101605:	0f b6 c0             	movzbl %al,%eax
c0101608:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010160b:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101610:	83 e0 08             	and    $0x8,%eax
c0101613:	85 c0                	test   %eax,%eax
c0101615:	74 22                	je     c0101639 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101617:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010161b:	7e 0c                	jle    c0101629 <kbd_proc_data+0x13e>
c010161d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101621:	7f 06                	jg     c0101629 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101623:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101627:	eb 10                	jmp    c0101639 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101629:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010162d:	7e 0a                	jle    c0101639 <kbd_proc_data+0x14e>
c010162f:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101633:	7f 04                	jg     c0101639 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101635:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101639:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010163e:	f7 d0                	not    %eax
c0101640:	83 e0 06             	and    $0x6,%eax
c0101643:	85 c0                	test   %eax,%eax
c0101645:	75 28                	jne    c010166f <kbd_proc_data+0x184>
c0101647:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010164e:	75 1f                	jne    c010166f <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101650:	c7 04 24 4d 64 10 c0 	movl   $0xc010644d,(%esp)
c0101657:	e8 5e ec ff ff       	call   c01002ba <cprintf>
c010165c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101662:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101666:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010166a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010166d:	ee                   	out    %al,(%dx)
}
c010166e:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101672:	c9                   	leave  
c0101673:	c3                   	ret    

c0101674 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101674:	f3 0f 1e fb          	endbr32 
c0101678:	55                   	push   %ebp
c0101679:	89 e5                	mov    %esp,%ebp
c010167b:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c010167e:	c7 04 24 eb 14 10 c0 	movl   $0xc01014eb,(%esp)
c0101685:	e8 93 fd ff ff       	call   c010141d <cons_intr>
}
c010168a:	90                   	nop
c010168b:	c9                   	leave  
c010168c:	c3                   	ret    

c010168d <kbd_init>:

static void
kbd_init(void) {
c010168d:	f3 0f 1e fb          	endbr32 
c0101691:	55                   	push   %ebp
c0101692:	89 e5                	mov    %esp,%ebp
c0101694:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101697:	e8 d8 ff ff ff       	call   c0101674 <kbd_intr>
    pic_enable(IRQ_KBD);
c010169c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016a3:	e8 47 01 00 00       	call   c01017ef <pic_enable>
}
c01016a8:	90                   	nop
c01016a9:	c9                   	leave  
c01016aa:	c3                   	ret    

c01016ab <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016ab:	f3 0f 1e fb          	endbr32 
c01016af:	55                   	push   %ebp
c01016b0:	89 e5                	mov    %esp,%ebp
c01016b2:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016b5:	e8 2e f8 ff ff       	call   c0100ee8 <cga_init>
    serial_init();
c01016ba:	e8 13 f9 ff ff       	call   c0100fd2 <serial_init>
    kbd_init();
c01016bf:	e8 c9 ff ff ff       	call   c010168d <kbd_init>
    if (!serial_exists) {
c01016c4:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01016c9:	85 c0                	test   %eax,%eax
c01016cb:	75 0c                	jne    c01016d9 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01016cd:	c7 04 24 59 64 10 c0 	movl   $0xc0106459,(%esp)
c01016d4:	e8 e1 eb ff ff       	call   c01002ba <cprintf>
    }
}
c01016d9:	90                   	nop
c01016da:	c9                   	leave  
c01016db:	c3                   	ret    

c01016dc <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016dc:	f3 0f 1e fb          	endbr32 
c01016e0:	55                   	push   %ebp
c01016e1:	89 e5                	mov    %esp,%ebp
c01016e3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016e6:	e8 72 f7 ff ff       	call   c0100e5d <__intr_save>
c01016eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01016f1:	89 04 24             	mov    %eax,(%esp)
c01016f4:	e8 48 fa ff ff       	call   c0101141 <lpt_putc>
        cga_putc(c);
c01016f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01016fc:	89 04 24             	mov    %eax,(%esp)
c01016ff:	e8 81 fa ff ff       	call   c0101185 <cga_putc>
        serial_putc(c);
c0101704:	8b 45 08             	mov    0x8(%ebp),%eax
c0101707:	89 04 24             	mov    %eax,(%esp)
c010170a:	e8 ca fc ff ff       	call   c01013d9 <serial_putc>
    }
    local_intr_restore(intr_flag);
c010170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101712:	89 04 24             	mov    %eax,(%esp)
c0101715:	e8 6d f7 ff ff       	call   c0100e87 <__intr_restore>
}
c010171a:	90                   	nop
c010171b:	c9                   	leave  
c010171c:	c3                   	ret    

c010171d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010171d:	f3 0f 1e fb          	endbr32 
c0101721:	55                   	push   %ebp
c0101722:	89 e5                	mov    %esp,%ebp
c0101724:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101727:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010172e:	e8 2a f7 ff ff       	call   c0100e5d <__intr_save>
c0101733:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101736:	e8 8e fd ff ff       	call   c01014c9 <serial_intr>
        kbd_intr();
c010173b:	e8 34 ff ff ff       	call   c0101674 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101740:	8b 15 60 c6 11 c0    	mov    0xc011c660,%edx
c0101746:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c010174b:	39 c2                	cmp    %eax,%edx
c010174d:	74 31                	je     c0101780 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
c010174f:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c0101754:	8d 50 01             	lea    0x1(%eax),%edx
c0101757:	89 15 60 c6 11 c0    	mov    %edx,0xc011c660
c010175d:	0f b6 80 60 c4 11 c0 	movzbl -0x3fee3ba0(%eax),%eax
c0101764:	0f b6 c0             	movzbl %al,%eax
c0101767:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010176a:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c010176f:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101774:	75 0a                	jne    c0101780 <cons_getc+0x63>
                cons.rpos = 0;
c0101776:	c7 05 60 c6 11 c0 00 	movl   $0x0,0xc011c660
c010177d:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101780:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101783:	89 04 24             	mov    %eax,(%esp)
c0101786:	e8 fc f6 ff ff       	call   c0100e87 <__intr_restore>
    return c;
c010178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010178e:	c9                   	leave  
c010178f:	c3                   	ret    

c0101790 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101790:	f3 0f 1e fb          	endbr32 
c0101794:	55                   	push   %ebp
c0101795:	89 e5                	mov    %esp,%ebp
c0101797:	83 ec 14             	sub    $0x14,%esp
c010179a:	8b 45 08             	mov    0x8(%ebp),%eax
c010179d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01017a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017a4:	66 a3 50 95 11 c0    	mov    %ax,0xc0119550
    if (did_init) {
c01017aa:	a1 6c c6 11 c0       	mov    0xc011c66c,%eax
c01017af:	85 c0                	test   %eax,%eax
c01017b1:	74 39                	je     c01017ec <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
c01017b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017b6:	0f b6 c0             	movzbl %al,%eax
c01017b9:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01017bf:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017c2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017c6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017ca:	ee                   	out    %al,(%dx)
}
c01017cb:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01017cc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017d0:	c1 e8 08             	shr    $0x8,%eax
c01017d3:	0f b7 c0             	movzwl %ax,%eax
c01017d6:	0f b6 c0             	movzbl %al,%eax
c01017d9:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017df:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017e6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017ea:	ee                   	out    %al,(%dx)
}
c01017eb:	90                   	nop
    }
}
c01017ec:	90                   	nop
c01017ed:	c9                   	leave  
c01017ee:	c3                   	ret    

c01017ef <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017ef:	f3 0f 1e fb          	endbr32 
c01017f3:	55                   	push   %ebp
c01017f4:	89 e5                	mov    %esp,%ebp
c01017f6:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01017f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01017fc:	ba 01 00 00 00       	mov    $0x1,%edx
c0101801:	88 c1                	mov    %al,%cl
c0101803:	d3 e2                	shl    %cl,%edx
c0101805:	89 d0                	mov    %edx,%eax
c0101807:	98                   	cwtl   
c0101808:	f7 d0                	not    %eax
c010180a:	0f bf d0             	movswl %ax,%edx
c010180d:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101814:	98                   	cwtl   
c0101815:	21 d0                	and    %edx,%eax
c0101817:	98                   	cwtl   
c0101818:	0f b7 c0             	movzwl %ax,%eax
c010181b:	89 04 24             	mov    %eax,(%esp)
c010181e:	e8 6d ff ff ff       	call   c0101790 <pic_setmask>
}
c0101823:	90                   	nop
c0101824:	c9                   	leave  
c0101825:	c3                   	ret    

c0101826 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101826:	f3 0f 1e fb          	endbr32 
c010182a:	55                   	push   %ebp
c010182b:	89 e5                	mov    %esp,%ebp
c010182d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101830:	c7 05 6c c6 11 c0 01 	movl   $0x1,0xc011c66c
c0101837:	00 00 00 
c010183a:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101840:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101844:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101848:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010184c:	ee                   	out    %al,(%dx)
}
c010184d:	90                   	nop
c010184e:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101854:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101858:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010185c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101860:	ee                   	out    %al,(%dx)
}
c0101861:	90                   	nop
c0101862:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101868:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010186c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101870:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101874:	ee                   	out    %al,(%dx)
}
c0101875:	90                   	nop
c0101876:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c010187c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101880:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101884:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101888:	ee                   	out    %al,(%dx)
}
c0101889:	90                   	nop
c010188a:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101890:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101894:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101898:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010189c:	ee                   	out    %al,(%dx)
}
c010189d:	90                   	nop
c010189e:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01018a4:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018a8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01018ac:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01018b0:	ee                   	out    %al,(%dx)
}
c01018b1:	90                   	nop
c01018b2:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01018b8:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018bc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01018c0:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01018c4:	ee                   	out    %al,(%dx)
}
c01018c5:	90                   	nop
c01018c6:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01018cc:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01018d4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01018d8:	ee                   	out    %al,(%dx)
}
c01018d9:	90                   	nop
c01018da:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018e0:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018e4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018e8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018ec:	ee                   	out    %al,(%dx)
}
c01018ed:	90                   	nop
c01018ee:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018f4:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018f8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018fc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101900:	ee                   	out    %al,(%dx)
}
c0101901:	90                   	nop
c0101902:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101908:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010190c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101910:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101914:	ee                   	out    %al,(%dx)
}
c0101915:	90                   	nop
c0101916:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010191c:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101920:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101924:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101928:	ee                   	out    %al,(%dx)
}
c0101929:	90                   	nop
c010192a:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101930:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101934:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101938:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010193c:	ee                   	out    %al,(%dx)
}
c010193d:	90                   	nop
c010193e:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101944:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101948:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010194c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101950:	ee                   	out    %al,(%dx)
}
c0101951:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101952:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101959:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010195e:	74 0f                	je     c010196f <pic_init+0x149>
        pic_setmask(irq_mask);
c0101960:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101967:	89 04 24             	mov    %eax,(%esp)
c010196a:	e8 21 fe ff ff       	call   c0101790 <pic_setmask>
    }
}
c010196f:	90                   	nop
c0101970:	c9                   	leave  
c0101971:	c3                   	ret    

c0101972 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101972:	f3 0f 1e fb          	endbr32 
c0101976:	55                   	push   %ebp
c0101977:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101979:	fb                   	sti    
}
c010197a:	90                   	nop
    sti();
}
c010197b:	90                   	nop
c010197c:	5d                   	pop    %ebp
c010197d:	c3                   	ret    

c010197e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010197e:	f3 0f 1e fb          	endbr32 
c0101982:	55                   	push   %ebp
c0101983:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101985:	fa                   	cli    
}
c0101986:	90                   	nop
    cli();
}
c0101987:	90                   	nop
c0101988:	5d                   	pop    %ebp
c0101989:	c3                   	ret    

c010198a <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010198a:	f3 0f 1e fb          	endbr32 
c010198e:	55                   	push   %ebp
c010198f:	89 e5                	mov    %esp,%ebp
c0101991:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101994:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010199b:	00 
c010199c:	c7 04 24 80 64 10 c0 	movl   $0xc0106480,(%esp)
c01019a3:	e8 12 e9 ff ff       	call   c01002ba <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01019a8:	c7 04 24 8a 64 10 c0 	movl   $0xc010648a,(%esp)
c01019af:	e8 06 e9 ff ff       	call   c01002ba <cprintf>
    panic("EOT: kernel seems ok.");
c01019b4:	c7 44 24 08 98 64 10 	movl   $0xc0106498,0x8(%esp)
c01019bb:	c0 
c01019bc:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01019c3:	00 
c01019c4:	c7 04 24 ae 64 10 c0 	movl   $0xc01064ae,(%esp)
c01019cb:	e8 56 ea ff ff       	call   c0100426 <__panic>

c01019d0 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01019d0:	f3 0f 1e fb          	endbr32 
c01019d4:	55                   	push   %ebp
c01019d5:	89 e5                	mov    %esp,%ebp
c01019d7:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019e1:	e9 c4 00 00 00       	jmp    c0101aaa <idt_init+0xda>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01019e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e9:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c01019f0:	0f b7 d0             	movzwl %ax,%edx
c01019f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f6:	66 89 14 c5 80 c6 11 	mov    %dx,-0x3fee3980(,%eax,8)
c01019fd:	c0 
c01019fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a01:	66 c7 04 c5 82 c6 11 	movw   $0x8,-0x3fee397e(,%eax,8)
c0101a08:	c0 08 00 
c0101a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a0e:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c0101a15:	c0 
c0101a16:	80 e2 e0             	and    $0xe0,%dl
c0101a19:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a23:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c0101a2a:	c0 
c0101a2b:	80 e2 1f             	and    $0x1f,%dl
c0101a2e:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a38:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a3f:	c0 
c0101a40:	80 e2 f0             	and    $0xf0,%dl
c0101a43:	80 ca 0e             	or     $0xe,%dl
c0101a46:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a50:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a57:	c0 
c0101a58:	80 e2 ef             	and    $0xef,%dl
c0101a5b:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a62:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a65:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a6c:	c0 
c0101a6d:	80 e2 9f             	and    $0x9f,%dl
c0101a70:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a77:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a7a:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a81:	c0 
c0101a82:	80 ca 80             	or     $0x80,%dl
c0101a85:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a8f:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101a96:	c1 e8 10             	shr    $0x10,%eax
c0101a99:	0f b7 d0             	movzwl %ax,%edx
c0101a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a9f:	66 89 14 c5 86 c6 11 	mov    %dx,-0x3fee397a(,%eax,8)
c0101aa6:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101aa7:	ff 45 fc             	incl   -0x4(%ebp)
c0101aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aad:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101ab2:	0f 86 2e ff ff ff    	jbe    c01019e6 <idt_init+0x16>
c0101ab8:	c7 45 f8 60 95 11 c0 	movl   $0xc0119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101abf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ac2:	0f 01 18             	lidtl  (%eax)
}
c0101ac5:	90                   	nop
    }
    lidt(&idt_pd);
}
c0101ac6:	90                   	nop
c0101ac7:	c9                   	leave  
c0101ac8:	c3                   	ret    

c0101ac9 <trapname>:

static const char *
trapname(int trapno) {
c0101ac9:	f3 0f 1e fb          	endbr32 
c0101acd:	55                   	push   %ebp
c0101ace:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad3:	83 f8 13             	cmp    $0x13,%eax
c0101ad6:	77 0c                	ja     c0101ae4 <trapname+0x1b>
        return excnames[trapno];
c0101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101adb:	8b 04 85 00 68 10 c0 	mov    -0x3fef9800(,%eax,4),%eax
c0101ae2:	eb 18                	jmp    c0101afc <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101ae4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101ae8:	7e 0d                	jle    c0101af7 <trapname+0x2e>
c0101aea:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101aee:	7f 07                	jg     c0101af7 <trapname+0x2e>
        return "Hardware Interrupt";
c0101af0:	b8 bf 64 10 c0       	mov    $0xc01064bf,%eax
c0101af5:	eb 05                	jmp    c0101afc <trapname+0x33>
    }
    return "(unknown trap)";
c0101af7:	b8 d2 64 10 c0       	mov    $0xc01064d2,%eax
}
c0101afc:	5d                   	pop    %ebp
c0101afd:	c3                   	ret    

c0101afe <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101afe:	f3 0f 1e fb          	endbr32 
c0101b02:	55                   	push   %ebp
c0101b03:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b08:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b0c:	83 f8 08             	cmp    $0x8,%eax
c0101b0f:	0f 94 c0             	sete   %al
c0101b12:	0f b6 c0             	movzbl %al,%eax
}
c0101b15:	5d                   	pop    %ebp
c0101b16:	c3                   	ret    

c0101b17 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101b17:	f3 0f 1e fb          	endbr32 
c0101b1b:	55                   	push   %ebp
c0101b1c:	89 e5                	mov    %esp,%ebp
c0101b1e:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b21:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b28:	c7 04 24 13 65 10 c0 	movl   $0xc0106513,(%esp)
c0101b2f:	e8 86 e7 ff ff       	call   c01002ba <cprintf>
    print_regs(&tf->tf_regs);
c0101b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b37:	89 04 24             	mov    %eax,(%esp)
c0101b3a:	e8 8d 01 00 00       	call   c0101ccc <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b42:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b4a:	c7 04 24 24 65 10 c0 	movl   $0xc0106524,(%esp)
c0101b51:	e8 64 e7 ff ff       	call   c01002ba <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b59:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b61:	c7 04 24 37 65 10 c0 	movl   $0xc0106537,(%esp)
c0101b68:	e8 4d e7 ff ff       	call   c01002ba <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b70:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b78:	c7 04 24 4a 65 10 c0 	movl   $0xc010654a,(%esp)
c0101b7f:	e8 36 e7 ff ff       	call   c01002ba <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b87:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8f:	c7 04 24 5d 65 10 c0 	movl   $0xc010655d,(%esp)
c0101b96:	e8 1f e7 ff ff       	call   c01002ba <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9e:	8b 40 30             	mov    0x30(%eax),%eax
c0101ba1:	89 04 24             	mov    %eax,(%esp)
c0101ba4:	e8 20 ff ff ff       	call   c0101ac9 <trapname>
c0101ba9:	8b 55 08             	mov    0x8(%ebp),%edx
c0101bac:	8b 52 30             	mov    0x30(%edx),%edx
c0101baf:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101bb3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101bb7:	c7 04 24 70 65 10 c0 	movl   $0xc0106570,(%esp)
c0101bbe:	e8 f7 e6 ff ff       	call   c01002ba <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc6:	8b 40 34             	mov    0x34(%eax),%eax
c0101bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bcd:	c7 04 24 82 65 10 c0 	movl   $0xc0106582,(%esp)
c0101bd4:	e8 e1 e6 ff ff       	call   c01002ba <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bdc:	8b 40 38             	mov    0x38(%eax),%eax
c0101bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be3:	c7 04 24 91 65 10 c0 	movl   $0xc0106591,(%esp)
c0101bea:	e8 cb e6 ff ff       	call   c01002ba <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bfa:	c7 04 24 a0 65 10 c0 	movl   $0xc01065a0,(%esp)
c0101c01:	e8 b4 e6 ff ff       	call   c01002ba <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c09:	8b 40 40             	mov    0x40(%eax),%eax
c0101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c10:	c7 04 24 b3 65 10 c0 	movl   $0xc01065b3,(%esp)
c0101c17:	e8 9e e6 ff ff       	call   c01002ba <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c23:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c2a:	eb 3d                	jmp    c0101c69 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2f:	8b 50 40             	mov    0x40(%eax),%edx
c0101c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c35:	21 d0                	and    %edx,%eax
c0101c37:	85 c0                	test   %eax,%eax
c0101c39:	74 28                	je     c0101c63 <print_trapframe+0x14c>
c0101c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c3e:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c45:	85 c0                	test   %eax,%eax
c0101c47:	74 1a                	je     c0101c63 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
c0101c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c4c:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c57:	c7 04 24 c2 65 10 c0 	movl   $0xc01065c2,(%esp)
c0101c5e:	e8 57 e6 ff ff       	call   c01002ba <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c63:	ff 45 f4             	incl   -0xc(%ebp)
c0101c66:	d1 65 f0             	shll   -0x10(%ebp)
c0101c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c6c:	83 f8 17             	cmp    $0x17,%eax
c0101c6f:	76 bb                	jbe    c0101c2c <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c74:	8b 40 40             	mov    0x40(%eax),%eax
c0101c77:	c1 e8 0c             	shr    $0xc,%eax
c0101c7a:	83 e0 03             	and    $0x3,%eax
c0101c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c81:	c7 04 24 c6 65 10 c0 	movl   $0xc01065c6,(%esp)
c0101c88:	e8 2d e6 ff ff       	call   c01002ba <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c90:	89 04 24             	mov    %eax,(%esp)
c0101c93:	e8 66 fe ff ff       	call   c0101afe <trap_in_kernel>
c0101c98:	85 c0                	test   %eax,%eax
c0101c9a:	75 2d                	jne    c0101cc9 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9f:	8b 40 44             	mov    0x44(%eax),%eax
c0101ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca6:	c7 04 24 cf 65 10 c0 	movl   $0xc01065cf,(%esp)
c0101cad:	e8 08 e6 ff ff       	call   c01002ba <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb5:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbd:	c7 04 24 de 65 10 c0 	movl   $0xc01065de,(%esp)
c0101cc4:	e8 f1 e5 ff ff       	call   c01002ba <cprintf>
    }
}
c0101cc9:	90                   	nop
c0101cca:	c9                   	leave  
c0101ccb:	c3                   	ret    

c0101ccc <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101ccc:	f3 0f 1e fb          	endbr32 
c0101cd0:	55                   	push   %ebp
c0101cd1:	89 e5                	mov    %esp,%ebp
c0101cd3:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd9:	8b 00                	mov    (%eax),%eax
c0101cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cdf:	c7 04 24 f1 65 10 c0 	movl   $0xc01065f1,(%esp)
c0101ce6:	e8 cf e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cee:	8b 40 04             	mov    0x4(%eax),%eax
c0101cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf5:	c7 04 24 00 66 10 c0 	movl   $0xc0106600,(%esp)
c0101cfc:	e8 b9 e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d04:	8b 40 08             	mov    0x8(%eax),%eax
c0101d07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d0b:	c7 04 24 0f 66 10 c0 	movl   $0xc010660f,(%esp)
c0101d12:	e8 a3 e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1a:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d21:	c7 04 24 1e 66 10 c0 	movl   $0xc010661e,(%esp)
c0101d28:	e8 8d e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d30:	8b 40 10             	mov    0x10(%eax),%eax
c0101d33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d37:	c7 04 24 2d 66 10 c0 	movl   $0xc010662d,(%esp)
c0101d3e:	e8 77 e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d46:	8b 40 14             	mov    0x14(%eax),%eax
c0101d49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d4d:	c7 04 24 3c 66 10 c0 	movl   $0xc010663c,(%esp)
c0101d54:	e8 61 e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d5c:	8b 40 18             	mov    0x18(%eax),%eax
c0101d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d63:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0101d6a:	e8 4b e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d72:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d79:	c7 04 24 5a 66 10 c0 	movl   $0xc010665a,(%esp)
c0101d80:	e8 35 e5 ff ff       	call   c01002ba <cprintf>
}
c0101d85:	90                   	nop
c0101d86:	c9                   	leave  
c0101d87:	c3                   	ret    

c0101d88 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d88:	f3 0f 1e fb          	endbr32 
c0101d8c:	55                   	push   %ebp
c0101d8d:	89 e5                	mov    %esp,%ebp
c0101d8f:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d95:	8b 40 30             	mov    0x30(%eax),%eax
c0101d98:	83 f8 79             	cmp    $0x79,%eax
c0101d9b:	0f 87 e6 00 00 00    	ja     c0101e87 <trap_dispatch+0xff>
c0101da1:	83 f8 78             	cmp    $0x78,%eax
c0101da4:	0f 83 c1 00 00 00    	jae    c0101e6b <trap_dispatch+0xe3>
c0101daa:	83 f8 2f             	cmp    $0x2f,%eax
c0101dad:	0f 87 d4 00 00 00    	ja     c0101e87 <trap_dispatch+0xff>
c0101db3:	83 f8 2e             	cmp    $0x2e,%eax
c0101db6:	0f 83 00 01 00 00    	jae    c0101ebc <trap_dispatch+0x134>
c0101dbc:	83 f8 24             	cmp    $0x24,%eax
c0101dbf:	74 5e                	je     c0101e1f <trap_dispatch+0x97>
c0101dc1:	83 f8 24             	cmp    $0x24,%eax
c0101dc4:	0f 87 bd 00 00 00    	ja     c0101e87 <trap_dispatch+0xff>
c0101dca:	83 f8 20             	cmp    $0x20,%eax
c0101dcd:	74 0a                	je     c0101dd9 <trap_dispatch+0x51>
c0101dcf:	83 f8 21             	cmp    $0x21,%eax
c0101dd2:	74 71                	je     c0101e45 <trap_dispatch+0xbd>
c0101dd4:	e9 ae 00 00 00       	jmp    c0101e87 <trap_dispatch+0xff>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101dd9:	a1 0c cf 11 c0       	mov    0xc011cf0c,%eax
c0101dde:	40                   	inc    %eax
c0101ddf:	a3 0c cf 11 c0       	mov    %eax,0xc011cf0c
        if (ticks % TICK_NUM == 0) {
c0101de4:	8b 0d 0c cf 11 c0    	mov    0xc011cf0c,%ecx
c0101dea:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101def:	89 c8                	mov    %ecx,%eax
c0101df1:	f7 e2                	mul    %edx
c0101df3:	c1 ea 05             	shr    $0x5,%edx
c0101df6:	89 d0                	mov    %edx,%eax
c0101df8:	c1 e0 02             	shl    $0x2,%eax
c0101dfb:	01 d0                	add    %edx,%eax
c0101dfd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101e04:	01 d0                	add    %edx,%eax
c0101e06:	c1 e0 02             	shl    $0x2,%eax
c0101e09:	29 c1                	sub    %eax,%ecx
c0101e0b:	89 ca                	mov    %ecx,%edx
c0101e0d:	85 d2                	test   %edx,%edx
c0101e0f:	0f 85 aa 00 00 00    	jne    c0101ebf <trap_dispatch+0x137>
            print_ticks();
c0101e15:	e8 70 fb ff ff       	call   c010198a <print_ticks>
        }
        break;
c0101e1a:	e9 a0 00 00 00       	jmp    c0101ebf <trap_dispatch+0x137>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101e1f:	e8 f9 f8 ff ff       	call   c010171d <cons_getc>
c0101e24:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e27:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e2b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e2f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e37:	c7 04 24 69 66 10 c0 	movl   $0xc0106669,(%esp)
c0101e3e:	e8 77 e4 ff ff       	call   c01002ba <cprintf>
        break;
c0101e43:	eb 7b                	jmp    c0101ec0 <trap_dispatch+0x138>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e45:	e8 d3 f8 ff ff       	call   c010171d <cons_getc>
c0101e4a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e4d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e51:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e55:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e5d:	c7 04 24 7b 66 10 c0 	movl   $0xc010667b,(%esp)
c0101e64:	e8 51 e4 ff ff       	call   c01002ba <cprintf>
        break;
c0101e69:	eb 55                	jmp    c0101ec0 <trap_dispatch+0x138>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101e6b:	c7 44 24 08 8a 66 10 	movl   $0xc010668a,0x8(%esp)
c0101e72:	c0 
c0101e73:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101e7a:	00 
c0101e7b:	c7 04 24 ae 64 10 c0 	movl   $0xc01064ae,(%esp)
c0101e82:	e8 9f e5 ff ff       	call   c0100426 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e8e:	83 e0 03             	and    $0x3,%eax
c0101e91:	85 c0                	test   %eax,%eax
c0101e93:	75 2b                	jne    c0101ec0 <trap_dispatch+0x138>
            print_trapframe(tf);
c0101e95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e98:	89 04 24             	mov    %eax,(%esp)
c0101e9b:	e8 77 fc ff ff       	call   c0101b17 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101ea0:	c7 44 24 08 9a 66 10 	movl   $0xc010669a,0x8(%esp)
c0101ea7:	c0 
c0101ea8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101eaf:	00 
c0101eb0:	c7 04 24 ae 64 10 c0 	movl   $0xc01064ae,(%esp)
c0101eb7:	e8 6a e5 ff ff       	call   c0100426 <__panic>
        break;
c0101ebc:	90                   	nop
c0101ebd:	eb 01                	jmp    c0101ec0 <trap_dispatch+0x138>
        break;
c0101ebf:	90                   	nop
        }
    }
}
c0101ec0:	90                   	nop
c0101ec1:	c9                   	leave  
c0101ec2:	c3                   	ret    

c0101ec3 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101ec3:	f3 0f 1e fb          	endbr32 
c0101ec7:	55                   	push   %ebp
c0101ec8:	89 e5                	mov    %esp,%ebp
c0101eca:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ecd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed0:	89 04 24             	mov    %eax,(%esp)
c0101ed3:	e8 b0 fe ff ff       	call   c0101d88 <trap_dispatch>
}
c0101ed8:	90                   	nop
c0101ed9:	c9                   	leave  
c0101eda:	c3                   	ret    

c0101edb <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101edb:	6a 00                	push   $0x0
  pushl $0
c0101edd:	6a 00                	push   $0x0
  jmp __alltraps
c0101edf:	e9 69 0a 00 00       	jmp    c010294d <__alltraps>

c0101ee4 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101ee4:	6a 00                	push   $0x0
  pushl $1
c0101ee6:	6a 01                	push   $0x1
  jmp __alltraps
c0101ee8:	e9 60 0a 00 00       	jmp    c010294d <__alltraps>

c0101eed <vector2>:
.globl vector2
vector2:
  pushl $0
c0101eed:	6a 00                	push   $0x0
  pushl $2
c0101eef:	6a 02                	push   $0x2
  jmp __alltraps
c0101ef1:	e9 57 0a 00 00       	jmp    c010294d <__alltraps>

c0101ef6 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101ef6:	6a 00                	push   $0x0
  pushl $3
c0101ef8:	6a 03                	push   $0x3
  jmp __alltraps
c0101efa:	e9 4e 0a 00 00       	jmp    c010294d <__alltraps>

c0101eff <vector4>:
.globl vector4
vector4:
  pushl $0
c0101eff:	6a 00                	push   $0x0
  pushl $4
c0101f01:	6a 04                	push   $0x4
  jmp __alltraps
c0101f03:	e9 45 0a 00 00       	jmp    c010294d <__alltraps>

c0101f08 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f08:	6a 00                	push   $0x0
  pushl $5
c0101f0a:	6a 05                	push   $0x5
  jmp __alltraps
c0101f0c:	e9 3c 0a 00 00       	jmp    c010294d <__alltraps>

c0101f11 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f11:	6a 00                	push   $0x0
  pushl $6
c0101f13:	6a 06                	push   $0x6
  jmp __alltraps
c0101f15:	e9 33 0a 00 00       	jmp    c010294d <__alltraps>

c0101f1a <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f1a:	6a 00                	push   $0x0
  pushl $7
c0101f1c:	6a 07                	push   $0x7
  jmp __alltraps
c0101f1e:	e9 2a 0a 00 00       	jmp    c010294d <__alltraps>

c0101f23 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f23:	6a 08                	push   $0x8
  jmp __alltraps
c0101f25:	e9 23 0a 00 00       	jmp    c010294d <__alltraps>

c0101f2a <vector9>:
.globl vector9
vector9:
  pushl $0
c0101f2a:	6a 00                	push   $0x0
  pushl $9
c0101f2c:	6a 09                	push   $0x9
  jmp __alltraps
c0101f2e:	e9 1a 0a 00 00       	jmp    c010294d <__alltraps>

c0101f33 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f33:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f35:	e9 13 0a 00 00       	jmp    c010294d <__alltraps>

c0101f3a <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f3a:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f3c:	e9 0c 0a 00 00       	jmp    c010294d <__alltraps>

c0101f41 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f41:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f43:	e9 05 0a 00 00       	jmp    c010294d <__alltraps>

c0101f48 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f48:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f4a:	e9 fe 09 00 00       	jmp    c010294d <__alltraps>

c0101f4f <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f4f:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f51:	e9 f7 09 00 00       	jmp    c010294d <__alltraps>

c0101f56 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f56:	6a 00                	push   $0x0
  pushl $15
c0101f58:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f5a:	e9 ee 09 00 00       	jmp    c010294d <__alltraps>

c0101f5f <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f5f:	6a 00                	push   $0x0
  pushl $16
c0101f61:	6a 10                	push   $0x10
  jmp __alltraps
c0101f63:	e9 e5 09 00 00       	jmp    c010294d <__alltraps>

c0101f68 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f68:	6a 11                	push   $0x11
  jmp __alltraps
c0101f6a:	e9 de 09 00 00       	jmp    c010294d <__alltraps>

c0101f6f <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f6f:	6a 00                	push   $0x0
  pushl $18
c0101f71:	6a 12                	push   $0x12
  jmp __alltraps
c0101f73:	e9 d5 09 00 00       	jmp    c010294d <__alltraps>

c0101f78 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f78:	6a 00                	push   $0x0
  pushl $19
c0101f7a:	6a 13                	push   $0x13
  jmp __alltraps
c0101f7c:	e9 cc 09 00 00       	jmp    c010294d <__alltraps>

c0101f81 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f81:	6a 00                	push   $0x0
  pushl $20
c0101f83:	6a 14                	push   $0x14
  jmp __alltraps
c0101f85:	e9 c3 09 00 00       	jmp    c010294d <__alltraps>

c0101f8a <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f8a:	6a 00                	push   $0x0
  pushl $21
c0101f8c:	6a 15                	push   $0x15
  jmp __alltraps
c0101f8e:	e9 ba 09 00 00       	jmp    c010294d <__alltraps>

c0101f93 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f93:	6a 00                	push   $0x0
  pushl $22
c0101f95:	6a 16                	push   $0x16
  jmp __alltraps
c0101f97:	e9 b1 09 00 00       	jmp    c010294d <__alltraps>

c0101f9c <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f9c:	6a 00                	push   $0x0
  pushl $23
c0101f9e:	6a 17                	push   $0x17
  jmp __alltraps
c0101fa0:	e9 a8 09 00 00       	jmp    c010294d <__alltraps>

c0101fa5 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101fa5:	6a 00                	push   $0x0
  pushl $24
c0101fa7:	6a 18                	push   $0x18
  jmp __alltraps
c0101fa9:	e9 9f 09 00 00       	jmp    c010294d <__alltraps>

c0101fae <vector25>:
.globl vector25
vector25:
  pushl $0
c0101fae:	6a 00                	push   $0x0
  pushl $25
c0101fb0:	6a 19                	push   $0x19
  jmp __alltraps
c0101fb2:	e9 96 09 00 00       	jmp    c010294d <__alltraps>

c0101fb7 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101fb7:	6a 00                	push   $0x0
  pushl $26
c0101fb9:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101fbb:	e9 8d 09 00 00       	jmp    c010294d <__alltraps>

c0101fc0 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101fc0:	6a 00                	push   $0x0
  pushl $27
c0101fc2:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101fc4:	e9 84 09 00 00       	jmp    c010294d <__alltraps>

c0101fc9 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101fc9:	6a 00                	push   $0x0
  pushl $28
c0101fcb:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101fcd:	e9 7b 09 00 00       	jmp    c010294d <__alltraps>

c0101fd2 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101fd2:	6a 00                	push   $0x0
  pushl $29
c0101fd4:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101fd6:	e9 72 09 00 00       	jmp    c010294d <__alltraps>

c0101fdb <vector30>:
.globl vector30
vector30:
  pushl $0
c0101fdb:	6a 00                	push   $0x0
  pushl $30
c0101fdd:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101fdf:	e9 69 09 00 00       	jmp    c010294d <__alltraps>

c0101fe4 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101fe4:	6a 00                	push   $0x0
  pushl $31
c0101fe6:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101fe8:	e9 60 09 00 00       	jmp    c010294d <__alltraps>

c0101fed <vector32>:
.globl vector32
vector32:
  pushl $0
c0101fed:	6a 00                	push   $0x0
  pushl $32
c0101fef:	6a 20                	push   $0x20
  jmp __alltraps
c0101ff1:	e9 57 09 00 00       	jmp    c010294d <__alltraps>

c0101ff6 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ff6:	6a 00                	push   $0x0
  pushl $33
c0101ff8:	6a 21                	push   $0x21
  jmp __alltraps
c0101ffa:	e9 4e 09 00 00       	jmp    c010294d <__alltraps>

c0101fff <vector34>:
.globl vector34
vector34:
  pushl $0
c0101fff:	6a 00                	push   $0x0
  pushl $34
c0102001:	6a 22                	push   $0x22
  jmp __alltraps
c0102003:	e9 45 09 00 00       	jmp    c010294d <__alltraps>

c0102008 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102008:	6a 00                	push   $0x0
  pushl $35
c010200a:	6a 23                	push   $0x23
  jmp __alltraps
c010200c:	e9 3c 09 00 00       	jmp    c010294d <__alltraps>

c0102011 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102011:	6a 00                	push   $0x0
  pushl $36
c0102013:	6a 24                	push   $0x24
  jmp __alltraps
c0102015:	e9 33 09 00 00       	jmp    c010294d <__alltraps>

c010201a <vector37>:
.globl vector37
vector37:
  pushl $0
c010201a:	6a 00                	push   $0x0
  pushl $37
c010201c:	6a 25                	push   $0x25
  jmp __alltraps
c010201e:	e9 2a 09 00 00       	jmp    c010294d <__alltraps>

c0102023 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102023:	6a 00                	push   $0x0
  pushl $38
c0102025:	6a 26                	push   $0x26
  jmp __alltraps
c0102027:	e9 21 09 00 00       	jmp    c010294d <__alltraps>

c010202c <vector39>:
.globl vector39
vector39:
  pushl $0
c010202c:	6a 00                	push   $0x0
  pushl $39
c010202e:	6a 27                	push   $0x27
  jmp __alltraps
c0102030:	e9 18 09 00 00       	jmp    c010294d <__alltraps>

c0102035 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102035:	6a 00                	push   $0x0
  pushl $40
c0102037:	6a 28                	push   $0x28
  jmp __alltraps
c0102039:	e9 0f 09 00 00       	jmp    c010294d <__alltraps>

c010203e <vector41>:
.globl vector41
vector41:
  pushl $0
c010203e:	6a 00                	push   $0x0
  pushl $41
c0102040:	6a 29                	push   $0x29
  jmp __alltraps
c0102042:	e9 06 09 00 00       	jmp    c010294d <__alltraps>

c0102047 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102047:	6a 00                	push   $0x0
  pushl $42
c0102049:	6a 2a                	push   $0x2a
  jmp __alltraps
c010204b:	e9 fd 08 00 00       	jmp    c010294d <__alltraps>

c0102050 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102050:	6a 00                	push   $0x0
  pushl $43
c0102052:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102054:	e9 f4 08 00 00       	jmp    c010294d <__alltraps>

c0102059 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102059:	6a 00                	push   $0x0
  pushl $44
c010205b:	6a 2c                	push   $0x2c
  jmp __alltraps
c010205d:	e9 eb 08 00 00       	jmp    c010294d <__alltraps>

c0102062 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102062:	6a 00                	push   $0x0
  pushl $45
c0102064:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102066:	e9 e2 08 00 00       	jmp    c010294d <__alltraps>

c010206b <vector46>:
.globl vector46
vector46:
  pushl $0
c010206b:	6a 00                	push   $0x0
  pushl $46
c010206d:	6a 2e                	push   $0x2e
  jmp __alltraps
c010206f:	e9 d9 08 00 00       	jmp    c010294d <__alltraps>

c0102074 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102074:	6a 00                	push   $0x0
  pushl $47
c0102076:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102078:	e9 d0 08 00 00       	jmp    c010294d <__alltraps>

c010207d <vector48>:
.globl vector48
vector48:
  pushl $0
c010207d:	6a 00                	push   $0x0
  pushl $48
c010207f:	6a 30                	push   $0x30
  jmp __alltraps
c0102081:	e9 c7 08 00 00       	jmp    c010294d <__alltraps>

c0102086 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102086:	6a 00                	push   $0x0
  pushl $49
c0102088:	6a 31                	push   $0x31
  jmp __alltraps
c010208a:	e9 be 08 00 00       	jmp    c010294d <__alltraps>

c010208f <vector50>:
.globl vector50
vector50:
  pushl $0
c010208f:	6a 00                	push   $0x0
  pushl $50
c0102091:	6a 32                	push   $0x32
  jmp __alltraps
c0102093:	e9 b5 08 00 00       	jmp    c010294d <__alltraps>

c0102098 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102098:	6a 00                	push   $0x0
  pushl $51
c010209a:	6a 33                	push   $0x33
  jmp __alltraps
c010209c:	e9 ac 08 00 00       	jmp    c010294d <__alltraps>

c01020a1 <vector52>:
.globl vector52
vector52:
  pushl $0
c01020a1:	6a 00                	push   $0x0
  pushl $52
c01020a3:	6a 34                	push   $0x34
  jmp __alltraps
c01020a5:	e9 a3 08 00 00       	jmp    c010294d <__alltraps>

c01020aa <vector53>:
.globl vector53
vector53:
  pushl $0
c01020aa:	6a 00                	push   $0x0
  pushl $53
c01020ac:	6a 35                	push   $0x35
  jmp __alltraps
c01020ae:	e9 9a 08 00 00       	jmp    c010294d <__alltraps>

c01020b3 <vector54>:
.globl vector54
vector54:
  pushl $0
c01020b3:	6a 00                	push   $0x0
  pushl $54
c01020b5:	6a 36                	push   $0x36
  jmp __alltraps
c01020b7:	e9 91 08 00 00       	jmp    c010294d <__alltraps>

c01020bc <vector55>:
.globl vector55
vector55:
  pushl $0
c01020bc:	6a 00                	push   $0x0
  pushl $55
c01020be:	6a 37                	push   $0x37
  jmp __alltraps
c01020c0:	e9 88 08 00 00       	jmp    c010294d <__alltraps>

c01020c5 <vector56>:
.globl vector56
vector56:
  pushl $0
c01020c5:	6a 00                	push   $0x0
  pushl $56
c01020c7:	6a 38                	push   $0x38
  jmp __alltraps
c01020c9:	e9 7f 08 00 00       	jmp    c010294d <__alltraps>

c01020ce <vector57>:
.globl vector57
vector57:
  pushl $0
c01020ce:	6a 00                	push   $0x0
  pushl $57
c01020d0:	6a 39                	push   $0x39
  jmp __alltraps
c01020d2:	e9 76 08 00 00       	jmp    c010294d <__alltraps>

c01020d7 <vector58>:
.globl vector58
vector58:
  pushl $0
c01020d7:	6a 00                	push   $0x0
  pushl $58
c01020d9:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020db:	e9 6d 08 00 00       	jmp    c010294d <__alltraps>

c01020e0 <vector59>:
.globl vector59
vector59:
  pushl $0
c01020e0:	6a 00                	push   $0x0
  pushl $59
c01020e2:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020e4:	e9 64 08 00 00       	jmp    c010294d <__alltraps>

c01020e9 <vector60>:
.globl vector60
vector60:
  pushl $0
c01020e9:	6a 00                	push   $0x0
  pushl $60
c01020eb:	6a 3c                	push   $0x3c
  jmp __alltraps
c01020ed:	e9 5b 08 00 00       	jmp    c010294d <__alltraps>

c01020f2 <vector61>:
.globl vector61
vector61:
  pushl $0
c01020f2:	6a 00                	push   $0x0
  pushl $61
c01020f4:	6a 3d                	push   $0x3d
  jmp __alltraps
c01020f6:	e9 52 08 00 00       	jmp    c010294d <__alltraps>

c01020fb <vector62>:
.globl vector62
vector62:
  pushl $0
c01020fb:	6a 00                	push   $0x0
  pushl $62
c01020fd:	6a 3e                	push   $0x3e
  jmp __alltraps
c01020ff:	e9 49 08 00 00       	jmp    c010294d <__alltraps>

c0102104 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102104:	6a 00                	push   $0x0
  pushl $63
c0102106:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102108:	e9 40 08 00 00       	jmp    c010294d <__alltraps>

c010210d <vector64>:
.globl vector64
vector64:
  pushl $0
c010210d:	6a 00                	push   $0x0
  pushl $64
c010210f:	6a 40                	push   $0x40
  jmp __alltraps
c0102111:	e9 37 08 00 00       	jmp    c010294d <__alltraps>

c0102116 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102116:	6a 00                	push   $0x0
  pushl $65
c0102118:	6a 41                	push   $0x41
  jmp __alltraps
c010211a:	e9 2e 08 00 00       	jmp    c010294d <__alltraps>

c010211f <vector66>:
.globl vector66
vector66:
  pushl $0
c010211f:	6a 00                	push   $0x0
  pushl $66
c0102121:	6a 42                	push   $0x42
  jmp __alltraps
c0102123:	e9 25 08 00 00       	jmp    c010294d <__alltraps>

c0102128 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102128:	6a 00                	push   $0x0
  pushl $67
c010212a:	6a 43                	push   $0x43
  jmp __alltraps
c010212c:	e9 1c 08 00 00       	jmp    c010294d <__alltraps>

c0102131 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102131:	6a 00                	push   $0x0
  pushl $68
c0102133:	6a 44                	push   $0x44
  jmp __alltraps
c0102135:	e9 13 08 00 00       	jmp    c010294d <__alltraps>

c010213a <vector69>:
.globl vector69
vector69:
  pushl $0
c010213a:	6a 00                	push   $0x0
  pushl $69
c010213c:	6a 45                	push   $0x45
  jmp __alltraps
c010213e:	e9 0a 08 00 00       	jmp    c010294d <__alltraps>

c0102143 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102143:	6a 00                	push   $0x0
  pushl $70
c0102145:	6a 46                	push   $0x46
  jmp __alltraps
c0102147:	e9 01 08 00 00       	jmp    c010294d <__alltraps>

c010214c <vector71>:
.globl vector71
vector71:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $71
c010214e:	6a 47                	push   $0x47
  jmp __alltraps
c0102150:	e9 f8 07 00 00       	jmp    c010294d <__alltraps>

c0102155 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102155:	6a 00                	push   $0x0
  pushl $72
c0102157:	6a 48                	push   $0x48
  jmp __alltraps
c0102159:	e9 ef 07 00 00       	jmp    c010294d <__alltraps>

c010215e <vector73>:
.globl vector73
vector73:
  pushl $0
c010215e:	6a 00                	push   $0x0
  pushl $73
c0102160:	6a 49                	push   $0x49
  jmp __alltraps
c0102162:	e9 e6 07 00 00       	jmp    c010294d <__alltraps>

c0102167 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102167:	6a 00                	push   $0x0
  pushl $74
c0102169:	6a 4a                	push   $0x4a
  jmp __alltraps
c010216b:	e9 dd 07 00 00       	jmp    c010294d <__alltraps>

c0102170 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $75
c0102172:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102174:	e9 d4 07 00 00       	jmp    c010294d <__alltraps>

c0102179 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102179:	6a 00                	push   $0x0
  pushl $76
c010217b:	6a 4c                	push   $0x4c
  jmp __alltraps
c010217d:	e9 cb 07 00 00       	jmp    c010294d <__alltraps>

c0102182 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102182:	6a 00                	push   $0x0
  pushl $77
c0102184:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102186:	e9 c2 07 00 00       	jmp    c010294d <__alltraps>

c010218b <vector78>:
.globl vector78
vector78:
  pushl $0
c010218b:	6a 00                	push   $0x0
  pushl $78
c010218d:	6a 4e                	push   $0x4e
  jmp __alltraps
c010218f:	e9 b9 07 00 00       	jmp    c010294d <__alltraps>

c0102194 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102194:	6a 00                	push   $0x0
  pushl $79
c0102196:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102198:	e9 b0 07 00 00       	jmp    c010294d <__alltraps>

c010219d <vector80>:
.globl vector80
vector80:
  pushl $0
c010219d:	6a 00                	push   $0x0
  pushl $80
c010219f:	6a 50                	push   $0x50
  jmp __alltraps
c01021a1:	e9 a7 07 00 00       	jmp    c010294d <__alltraps>

c01021a6 <vector81>:
.globl vector81
vector81:
  pushl $0
c01021a6:	6a 00                	push   $0x0
  pushl $81
c01021a8:	6a 51                	push   $0x51
  jmp __alltraps
c01021aa:	e9 9e 07 00 00       	jmp    c010294d <__alltraps>

c01021af <vector82>:
.globl vector82
vector82:
  pushl $0
c01021af:	6a 00                	push   $0x0
  pushl $82
c01021b1:	6a 52                	push   $0x52
  jmp __alltraps
c01021b3:	e9 95 07 00 00       	jmp    c010294d <__alltraps>

c01021b8 <vector83>:
.globl vector83
vector83:
  pushl $0
c01021b8:	6a 00                	push   $0x0
  pushl $83
c01021ba:	6a 53                	push   $0x53
  jmp __alltraps
c01021bc:	e9 8c 07 00 00       	jmp    c010294d <__alltraps>

c01021c1 <vector84>:
.globl vector84
vector84:
  pushl $0
c01021c1:	6a 00                	push   $0x0
  pushl $84
c01021c3:	6a 54                	push   $0x54
  jmp __alltraps
c01021c5:	e9 83 07 00 00       	jmp    c010294d <__alltraps>

c01021ca <vector85>:
.globl vector85
vector85:
  pushl $0
c01021ca:	6a 00                	push   $0x0
  pushl $85
c01021cc:	6a 55                	push   $0x55
  jmp __alltraps
c01021ce:	e9 7a 07 00 00       	jmp    c010294d <__alltraps>

c01021d3 <vector86>:
.globl vector86
vector86:
  pushl $0
c01021d3:	6a 00                	push   $0x0
  pushl $86
c01021d5:	6a 56                	push   $0x56
  jmp __alltraps
c01021d7:	e9 71 07 00 00       	jmp    c010294d <__alltraps>

c01021dc <vector87>:
.globl vector87
vector87:
  pushl $0
c01021dc:	6a 00                	push   $0x0
  pushl $87
c01021de:	6a 57                	push   $0x57
  jmp __alltraps
c01021e0:	e9 68 07 00 00       	jmp    c010294d <__alltraps>

c01021e5 <vector88>:
.globl vector88
vector88:
  pushl $0
c01021e5:	6a 00                	push   $0x0
  pushl $88
c01021e7:	6a 58                	push   $0x58
  jmp __alltraps
c01021e9:	e9 5f 07 00 00       	jmp    c010294d <__alltraps>

c01021ee <vector89>:
.globl vector89
vector89:
  pushl $0
c01021ee:	6a 00                	push   $0x0
  pushl $89
c01021f0:	6a 59                	push   $0x59
  jmp __alltraps
c01021f2:	e9 56 07 00 00       	jmp    c010294d <__alltraps>

c01021f7 <vector90>:
.globl vector90
vector90:
  pushl $0
c01021f7:	6a 00                	push   $0x0
  pushl $90
c01021f9:	6a 5a                	push   $0x5a
  jmp __alltraps
c01021fb:	e9 4d 07 00 00       	jmp    c010294d <__alltraps>

c0102200 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102200:	6a 00                	push   $0x0
  pushl $91
c0102202:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102204:	e9 44 07 00 00       	jmp    c010294d <__alltraps>

c0102209 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102209:	6a 00                	push   $0x0
  pushl $92
c010220b:	6a 5c                	push   $0x5c
  jmp __alltraps
c010220d:	e9 3b 07 00 00       	jmp    c010294d <__alltraps>

c0102212 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $93
c0102214:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102216:	e9 32 07 00 00       	jmp    c010294d <__alltraps>

c010221b <vector94>:
.globl vector94
vector94:
  pushl $0
c010221b:	6a 00                	push   $0x0
  pushl $94
c010221d:	6a 5e                	push   $0x5e
  jmp __alltraps
c010221f:	e9 29 07 00 00       	jmp    c010294d <__alltraps>

c0102224 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102224:	6a 00                	push   $0x0
  pushl $95
c0102226:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102228:	e9 20 07 00 00       	jmp    c010294d <__alltraps>

c010222d <vector96>:
.globl vector96
vector96:
  pushl $0
c010222d:	6a 00                	push   $0x0
  pushl $96
c010222f:	6a 60                	push   $0x60
  jmp __alltraps
c0102231:	e9 17 07 00 00       	jmp    c010294d <__alltraps>

c0102236 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102236:	6a 00                	push   $0x0
  pushl $97
c0102238:	6a 61                	push   $0x61
  jmp __alltraps
c010223a:	e9 0e 07 00 00       	jmp    c010294d <__alltraps>

c010223f <vector98>:
.globl vector98
vector98:
  pushl $0
c010223f:	6a 00                	push   $0x0
  pushl $98
c0102241:	6a 62                	push   $0x62
  jmp __alltraps
c0102243:	e9 05 07 00 00       	jmp    c010294d <__alltraps>

c0102248 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102248:	6a 00                	push   $0x0
  pushl $99
c010224a:	6a 63                	push   $0x63
  jmp __alltraps
c010224c:	e9 fc 06 00 00       	jmp    c010294d <__alltraps>

c0102251 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102251:	6a 00                	push   $0x0
  pushl $100
c0102253:	6a 64                	push   $0x64
  jmp __alltraps
c0102255:	e9 f3 06 00 00       	jmp    c010294d <__alltraps>

c010225a <vector101>:
.globl vector101
vector101:
  pushl $0
c010225a:	6a 00                	push   $0x0
  pushl $101
c010225c:	6a 65                	push   $0x65
  jmp __alltraps
c010225e:	e9 ea 06 00 00       	jmp    c010294d <__alltraps>

c0102263 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102263:	6a 00                	push   $0x0
  pushl $102
c0102265:	6a 66                	push   $0x66
  jmp __alltraps
c0102267:	e9 e1 06 00 00       	jmp    c010294d <__alltraps>

c010226c <vector103>:
.globl vector103
vector103:
  pushl $0
c010226c:	6a 00                	push   $0x0
  pushl $103
c010226e:	6a 67                	push   $0x67
  jmp __alltraps
c0102270:	e9 d8 06 00 00       	jmp    c010294d <__alltraps>

c0102275 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102275:	6a 00                	push   $0x0
  pushl $104
c0102277:	6a 68                	push   $0x68
  jmp __alltraps
c0102279:	e9 cf 06 00 00       	jmp    c010294d <__alltraps>

c010227e <vector105>:
.globl vector105
vector105:
  pushl $0
c010227e:	6a 00                	push   $0x0
  pushl $105
c0102280:	6a 69                	push   $0x69
  jmp __alltraps
c0102282:	e9 c6 06 00 00       	jmp    c010294d <__alltraps>

c0102287 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102287:	6a 00                	push   $0x0
  pushl $106
c0102289:	6a 6a                	push   $0x6a
  jmp __alltraps
c010228b:	e9 bd 06 00 00       	jmp    c010294d <__alltraps>

c0102290 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102290:	6a 00                	push   $0x0
  pushl $107
c0102292:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102294:	e9 b4 06 00 00       	jmp    c010294d <__alltraps>

c0102299 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102299:	6a 00                	push   $0x0
  pushl $108
c010229b:	6a 6c                	push   $0x6c
  jmp __alltraps
c010229d:	e9 ab 06 00 00       	jmp    c010294d <__alltraps>

c01022a2 <vector109>:
.globl vector109
vector109:
  pushl $0
c01022a2:	6a 00                	push   $0x0
  pushl $109
c01022a4:	6a 6d                	push   $0x6d
  jmp __alltraps
c01022a6:	e9 a2 06 00 00       	jmp    c010294d <__alltraps>

c01022ab <vector110>:
.globl vector110
vector110:
  pushl $0
c01022ab:	6a 00                	push   $0x0
  pushl $110
c01022ad:	6a 6e                	push   $0x6e
  jmp __alltraps
c01022af:	e9 99 06 00 00       	jmp    c010294d <__alltraps>

c01022b4 <vector111>:
.globl vector111
vector111:
  pushl $0
c01022b4:	6a 00                	push   $0x0
  pushl $111
c01022b6:	6a 6f                	push   $0x6f
  jmp __alltraps
c01022b8:	e9 90 06 00 00       	jmp    c010294d <__alltraps>

c01022bd <vector112>:
.globl vector112
vector112:
  pushl $0
c01022bd:	6a 00                	push   $0x0
  pushl $112
c01022bf:	6a 70                	push   $0x70
  jmp __alltraps
c01022c1:	e9 87 06 00 00       	jmp    c010294d <__alltraps>

c01022c6 <vector113>:
.globl vector113
vector113:
  pushl $0
c01022c6:	6a 00                	push   $0x0
  pushl $113
c01022c8:	6a 71                	push   $0x71
  jmp __alltraps
c01022ca:	e9 7e 06 00 00       	jmp    c010294d <__alltraps>

c01022cf <vector114>:
.globl vector114
vector114:
  pushl $0
c01022cf:	6a 00                	push   $0x0
  pushl $114
c01022d1:	6a 72                	push   $0x72
  jmp __alltraps
c01022d3:	e9 75 06 00 00       	jmp    c010294d <__alltraps>

c01022d8 <vector115>:
.globl vector115
vector115:
  pushl $0
c01022d8:	6a 00                	push   $0x0
  pushl $115
c01022da:	6a 73                	push   $0x73
  jmp __alltraps
c01022dc:	e9 6c 06 00 00       	jmp    c010294d <__alltraps>

c01022e1 <vector116>:
.globl vector116
vector116:
  pushl $0
c01022e1:	6a 00                	push   $0x0
  pushl $116
c01022e3:	6a 74                	push   $0x74
  jmp __alltraps
c01022e5:	e9 63 06 00 00       	jmp    c010294d <__alltraps>

c01022ea <vector117>:
.globl vector117
vector117:
  pushl $0
c01022ea:	6a 00                	push   $0x0
  pushl $117
c01022ec:	6a 75                	push   $0x75
  jmp __alltraps
c01022ee:	e9 5a 06 00 00       	jmp    c010294d <__alltraps>

c01022f3 <vector118>:
.globl vector118
vector118:
  pushl $0
c01022f3:	6a 00                	push   $0x0
  pushl $118
c01022f5:	6a 76                	push   $0x76
  jmp __alltraps
c01022f7:	e9 51 06 00 00       	jmp    c010294d <__alltraps>

c01022fc <vector119>:
.globl vector119
vector119:
  pushl $0
c01022fc:	6a 00                	push   $0x0
  pushl $119
c01022fe:	6a 77                	push   $0x77
  jmp __alltraps
c0102300:	e9 48 06 00 00       	jmp    c010294d <__alltraps>

c0102305 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102305:	6a 00                	push   $0x0
  pushl $120
c0102307:	6a 78                	push   $0x78
  jmp __alltraps
c0102309:	e9 3f 06 00 00       	jmp    c010294d <__alltraps>

c010230e <vector121>:
.globl vector121
vector121:
  pushl $0
c010230e:	6a 00                	push   $0x0
  pushl $121
c0102310:	6a 79                	push   $0x79
  jmp __alltraps
c0102312:	e9 36 06 00 00       	jmp    c010294d <__alltraps>

c0102317 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102317:	6a 00                	push   $0x0
  pushl $122
c0102319:	6a 7a                	push   $0x7a
  jmp __alltraps
c010231b:	e9 2d 06 00 00       	jmp    c010294d <__alltraps>

c0102320 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $123
c0102322:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102324:	e9 24 06 00 00       	jmp    c010294d <__alltraps>

c0102329 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102329:	6a 00                	push   $0x0
  pushl $124
c010232b:	6a 7c                	push   $0x7c
  jmp __alltraps
c010232d:	e9 1b 06 00 00       	jmp    c010294d <__alltraps>

c0102332 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102332:	6a 00                	push   $0x0
  pushl $125
c0102334:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102336:	e9 12 06 00 00       	jmp    c010294d <__alltraps>

c010233b <vector126>:
.globl vector126
vector126:
  pushl $0
c010233b:	6a 00                	push   $0x0
  pushl $126
c010233d:	6a 7e                	push   $0x7e
  jmp __alltraps
c010233f:	e9 09 06 00 00       	jmp    c010294d <__alltraps>

c0102344 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $127
c0102346:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102348:	e9 00 06 00 00       	jmp    c010294d <__alltraps>

c010234d <vector128>:
.globl vector128
vector128:
  pushl $0
c010234d:	6a 00                	push   $0x0
  pushl $128
c010234f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102354:	e9 f4 05 00 00       	jmp    c010294d <__alltraps>

c0102359 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102359:	6a 00                	push   $0x0
  pushl $129
c010235b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102360:	e9 e8 05 00 00       	jmp    c010294d <__alltraps>

c0102365 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102365:	6a 00                	push   $0x0
  pushl $130
c0102367:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010236c:	e9 dc 05 00 00       	jmp    c010294d <__alltraps>

c0102371 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102371:	6a 00                	push   $0x0
  pushl $131
c0102373:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102378:	e9 d0 05 00 00       	jmp    c010294d <__alltraps>

c010237d <vector132>:
.globl vector132
vector132:
  pushl $0
c010237d:	6a 00                	push   $0x0
  pushl $132
c010237f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102384:	e9 c4 05 00 00       	jmp    c010294d <__alltraps>

c0102389 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102389:	6a 00                	push   $0x0
  pushl $133
c010238b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102390:	e9 b8 05 00 00       	jmp    c010294d <__alltraps>

c0102395 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102395:	6a 00                	push   $0x0
  pushl $134
c0102397:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010239c:	e9 ac 05 00 00       	jmp    c010294d <__alltraps>

c01023a1 <vector135>:
.globl vector135
vector135:
  pushl $0
c01023a1:	6a 00                	push   $0x0
  pushl $135
c01023a3:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01023a8:	e9 a0 05 00 00       	jmp    c010294d <__alltraps>

c01023ad <vector136>:
.globl vector136
vector136:
  pushl $0
c01023ad:	6a 00                	push   $0x0
  pushl $136
c01023af:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01023b4:	e9 94 05 00 00       	jmp    c010294d <__alltraps>

c01023b9 <vector137>:
.globl vector137
vector137:
  pushl $0
c01023b9:	6a 00                	push   $0x0
  pushl $137
c01023bb:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023c0:	e9 88 05 00 00       	jmp    c010294d <__alltraps>

c01023c5 <vector138>:
.globl vector138
vector138:
  pushl $0
c01023c5:	6a 00                	push   $0x0
  pushl $138
c01023c7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023cc:	e9 7c 05 00 00       	jmp    c010294d <__alltraps>

c01023d1 <vector139>:
.globl vector139
vector139:
  pushl $0
c01023d1:	6a 00                	push   $0x0
  pushl $139
c01023d3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01023d8:	e9 70 05 00 00       	jmp    c010294d <__alltraps>

c01023dd <vector140>:
.globl vector140
vector140:
  pushl $0
c01023dd:	6a 00                	push   $0x0
  pushl $140
c01023df:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023e4:	e9 64 05 00 00       	jmp    c010294d <__alltraps>

c01023e9 <vector141>:
.globl vector141
vector141:
  pushl $0
c01023e9:	6a 00                	push   $0x0
  pushl $141
c01023eb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01023f0:	e9 58 05 00 00       	jmp    c010294d <__alltraps>

c01023f5 <vector142>:
.globl vector142
vector142:
  pushl $0
c01023f5:	6a 00                	push   $0x0
  pushl $142
c01023f7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01023fc:	e9 4c 05 00 00       	jmp    c010294d <__alltraps>

c0102401 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102401:	6a 00                	push   $0x0
  pushl $143
c0102403:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102408:	e9 40 05 00 00       	jmp    c010294d <__alltraps>

c010240d <vector144>:
.globl vector144
vector144:
  pushl $0
c010240d:	6a 00                	push   $0x0
  pushl $144
c010240f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102414:	e9 34 05 00 00       	jmp    c010294d <__alltraps>

c0102419 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102419:	6a 00                	push   $0x0
  pushl $145
c010241b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102420:	e9 28 05 00 00       	jmp    c010294d <__alltraps>

c0102425 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102425:	6a 00                	push   $0x0
  pushl $146
c0102427:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010242c:	e9 1c 05 00 00       	jmp    c010294d <__alltraps>

c0102431 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102431:	6a 00                	push   $0x0
  pushl $147
c0102433:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102438:	e9 10 05 00 00       	jmp    c010294d <__alltraps>

c010243d <vector148>:
.globl vector148
vector148:
  pushl $0
c010243d:	6a 00                	push   $0x0
  pushl $148
c010243f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102444:	e9 04 05 00 00       	jmp    c010294d <__alltraps>

c0102449 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102449:	6a 00                	push   $0x0
  pushl $149
c010244b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102450:	e9 f8 04 00 00       	jmp    c010294d <__alltraps>

c0102455 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102455:	6a 00                	push   $0x0
  pushl $150
c0102457:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010245c:	e9 ec 04 00 00       	jmp    c010294d <__alltraps>

c0102461 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102461:	6a 00                	push   $0x0
  pushl $151
c0102463:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102468:	e9 e0 04 00 00       	jmp    c010294d <__alltraps>

c010246d <vector152>:
.globl vector152
vector152:
  pushl $0
c010246d:	6a 00                	push   $0x0
  pushl $152
c010246f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102474:	e9 d4 04 00 00       	jmp    c010294d <__alltraps>

c0102479 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102479:	6a 00                	push   $0x0
  pushl $153
c010247b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102480:	e9 c8 04 00 00       	jmp    c010294d <__alltraps>

c0102485 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102485:	6a 00                	push   $0x0
  pushl $154
c0102487:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010248c:	e9 bc 04 00 00       	jmp    c010294d <__alltraps>

c0102491 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102491:	6a 00                	push   $0x0
  pushl $155
c0102493:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102498:	e9 b0 04 00 00       	jmp    c010294d <__alltraps>

c010249d <vector156>:
.globl vector156
vector156:
  pushl $0
c010249d:	6a 00                	push   $0x0
  pushl $156
c010249f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01024a4:	e9 a4 04 00 00       	jmp    c010294d <__alltraps>

c01024a9 <vector157>:
.globl vector157
vector157:
  pushl $0
c01024a9:	6a 00                	push   $0x0
  pushl $157
c01024ab:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01024b0:	e9 98 04 00 00       	jmp    c010294d <__alltraps>

c01024b5 <vector158>:
.globl vector158
vector158:
  pushl $0
c01024b5:	6a 00                	push   $0x0
  pushl $158
c01024b7:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01024bc:	e9 8c 04 00 00       	jmp    c010294d <__alltraps>

c01024c1 <vector159>:
.globl vector159
vector159:
  pushl $0
c01024c1:	6a 00                	push   $0x0
  pushl $159
c01024c3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01024c8:	e9 80 04 00 00       	jmp    c010294d <__alltraps>

c01024cd <vector160>:
.globl vector160
vector160:
  pushl $0
c01024cd:	6a 00                	push   $0x0
  pushl $160
c01024cf:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01024d4:	e9 74 04 00 00       	jmp    c010294d <__alltraps>

c01024d9 <vector161>:
.globl vector161
vector161:
  pushl $0
c01024d9:	6a 00                	push   $0x0
  pushl $161
c01024db:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024e0:	e9 68 04 00 00       	jmp    c010294d <__alltraps>

c01024e5 <vector162>:
.globl vector162
vector162:
  pushl $0
c01024e5:	6a 00                	push   $0x0
  pushl $162
c01024e7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01024ec:	e9 5c 04 00 00       	jmp    c010294d <__alltraps>

c01024f1 <vector163>:
.globl vector163
vector163:
  pushl $0
c01024f1:	6a 00                	push   $0x0
  pushl $163
c01024f3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01024f8:	e9 50 04 00 00       	jmp    c010294d <__alltraps>

c01024fd <vector164>:
.globl vector164
vector164:
  pushl $0
c01024fd:	6a 00                	push   $0x0
  pushl $164
c01024ff:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102504:	e9 44 04 00 00       	jmp    c010294d <__alltraps>

c0102509 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102509:	6a 00                	push   $0x0
  pushl $165
c010250b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102510:	e9 38 04 00 00       	jmp    c010294d <__alltraps>

c0102515 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102515:	6a 00                	push   $0x0
  pushl $166
c0102517:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010251c:	e9 2c 04 00 00       	jmp    c010294d <__alltraps>

c0102521 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102521:	6a 00                	push   $0x0
  pushl $167
c0102523:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102528:	e9 20 04 00 00       	jmp    c010294d <__alltraps>

c010252d <vector168>:
.globl vector168
vector168:
  pushl $0
c010252d:	6a 00                	push   $0x0
  pushl $168
c010252f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102534:	e9 14 04 00 00       	jmp    c010294d <__alltraps>

c0102539 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102539:	6a 00                	push   $0x0
  pushl $169
c010253b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102540:	e9 08 04 00 00       	jmp    c010294d <__alltraps>

c0102545 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102545:	6a 00                	push   $0x0
  pushl $170
c0102547:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010254c:	e9 fc 03 00 00       	jmp    c010294d <__alltraps>

c0102551 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102551:	6a 00                	push   $0x0
  pushl $171
c0102553:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102558:	e9 f0 03 00 00       	jmp    c010294d <__alltraps>

c010255d <vector172>:
.globl vector172
vector172:
  pushl $0
c010255d:	6a 00                	push   $0x0
  pushl $172
c010255f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102564:	e9 e4 03 00 00       	jmp    c010294d <__alltraps>

c0102569 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102569:	6a 00                	push   $0x0
  pushl $173
c010256b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102570:	e9 d8 03 00 00       	jmp    c010294d <__alltraps>

c0102575 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102575:	6a 00                	push   $0x0
  pushl $174
c0102577:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010257c:	e9 cc 03 00 00       	jmp    c010294d <__alltraps>

c0102581 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102581:	6a 00                	push   $0x0
  pushl $175
c0102583:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102588:	e9 c0 03 00 00       	jmp    c010294d <__alltraps>

c010258d <vector176>:
.globl vector176
vector176:
  pushl $0
c010258d:	6a 00                	push   $0x0
  pushl $176
c010258f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102594:	e9 b4 03 00 00       	jmp    c010294d <__alltraps>

c0102599 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102599:	6a 00                	push   $0x0
  pushl $177
c010259b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01025a0:	e9 a8 03 00 00       	jmp    c010294d <__alltraps>

c01025a5 <vector178>:
.globl vector178
vector178:
  pushl $0
c01025a5:	6a 00                	push   $0x0
  pushl $178
c01025a7:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01025ac:	e9 9c 03 00 00       	jmp    c010294d <__alltraps>

c01025b1 <vector179>:
.globl vector179
vector179:
  pushl $0
c01025b1:	6a 00                	push   $0x0
  pushl $179
c01025b3:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01025b8:	e9 90 03 00 00       	jmp    c010294d <__alltraps>

c01025bd <vector180>:
.globl vector180
vector180:
  pushl $0
c01025bd:	6a 00                	push   $0x0
  pushl $180
c01025bf:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025c4:	e9 84 03 00 00       	jmp    c010294d <__alltraps>

c01025c9 <vector181>:
.globl vector181
vector181:
  pushl $0
c01025c9:	6a 00                	push   $0x0
  pushl $181
c01025cb:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01025d0:	e9 78 03 00 00       	jmp    c010294d <__alltraps>

c01025d5 <vector182>:
.globl vector182
vector182:
  pushl $0
c01025d5:	6a 00                	push   $0x0
  pushl $182
c01025d7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025dc:	e9 6c 03 00 00       	jmp    c010294d <__alltraps>

c01025e1 <vector183>:
.globl vector183
vector183:
  pushl $0
c01025e1:	6a 00                	push   $0x0
  pushl $183
c01025e3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01025e8:	e9 60 03 00 00       	jmp    c010294d <__alltraps>

c01025ed <vector184>:
.globl vector184
vector184:
  pushl $0
c01025ed:	6a 00                	push   $0x0
  pushl $184
c01025ef:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01025f4:	e9 54 03 00 00       	jmp    c010294d <__alltraps>

c01025f9 <vector185>:
.globl vector185
vector185:
  pushl $0
c01025f9:	6a 00                	push   $0x0
  pushl $185
c01025fb:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102600:	e9 48 03 00 00       	jmp    c010294d <__alltraps>

c0102605 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102605:	6a 00                	push   $0x0
  pushl $186
c0102607:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010260c:	e9 3c 03 00 00       	jmp    c010294d <__alltraps>

c0102611 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102611:	6a 00                	push   $0x0
  pushl $187
c0102613:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102618:	e9 30 03 00 00       	jmp    c010294d <__alltraps>

c010261d <vector188>:
.globl vector188
vector188:
  pushl $0
c010261d:	6a 00                	push   $0x0
  pushl $188
c010261f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102624:	e9 24 03 00 00       	jmp    c010294d <__alltraps>

c0102629 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102629:	6a 00                	push   $0x0
  pushl $189
c010262b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102630:	e9 18 03 00 00       	jmp    c010294d <__alltraps>

c0102635 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102635:	6a 00                	push   $0x0
  pushl $190
c0102637:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010263c:	e9 0c 03 00 00       	jmp    c010294d <__alltraps>

c0102641 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102641:	6a 00                	push   $0x0
  pushl $191
c0102643:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102648:	e9 00 03 00 00       	jmp    c010294d <__alltraps>

c010264d <vector192>:
.globl vector192
vector192:
  pushl $0
c010264d:	6a 00                	push   $0x0
  pushl $192
c010264f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102654:	e9 f4 02 00 00       	jmp    c010294d <__alltraps>

c0102659 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102659:	6a 00                	push   $0x0
  pushl $193
c010265b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102660:	e9 e8 02 00 00       	jmp    c010294d <__alltraps>

c0102665 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102665:	6a 00                	push   $0x0
  pushl $194
c0102667:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010266c:	e9 dc 02 00 00       	jmp    c010294d <__alltraps>

c0102671 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102671:	6a 00                	push   $0x0
  pushl $195
c0102673:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102678:	e9 d0 02 00 00       	jmp    c010294d <__alltraps>

c010267d <vector196>:
.globl vector196
vector196:
  pushl $0
c010267d:	6a 00                	push   $0x0
  pushl $196
c010267f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102684:	e9 c4 02 00 00       	jmp    c010294d <__alltraps>

c0102689 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102689:	6a 00                	push   $0x0
  pushl $197
c010268b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102690:	e9 b8 02 00 00       	jmp    c010294d <__alltraps>

c0102695 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102695:	6a 00                	push   $0x0
  pushl $198
c0102697:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010269c:	e9 ac 02 00 00       	jmp    c010294d <__alltraps>

c01026a1 <vector199>:
.globl vector199
vector199:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $199
c01026a3:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01026a8:	e9 a0 02 00 00       	jmp    c010294d <__alltraps>

c01026ad <vector200>:
.globl vector200
vector200:
  pushl $0
c01026ad:	6a 00                	push   $0x0
  pushl $200
c01026af:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01026b4:	e9 94 02 00 00       	jmp    c010294d <__alltraps>

c01026b9 <vector201>:
.globl vector201
vector201:
  pushl $0
c01026b9:	6a 00                	push   $0x0
  pushl $201
c01026bb:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026c0:	e9 88 02 00 00       	jmp    c010294d <__alltraps>

c01026c5 <vector202>:
.globl vector202
vector202:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $202
c01026c7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026cc:	e9 7c 02 00 00       	jmp    c010294d <__alltraps>

c01026d1 <vector203>:
.globl vector203
vector203:
  pushl $0
c01026d1:	6a 00                	push   $0x0
  pushl $203
c01026d3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01026d8:	e9 70 02 00 00       	jmp    c010294d <__alltraps>

c01026dd <vector204>:
.globl vector204
vector204:
  pushl $0
c01026dd:	6a 00                	push   $0x0
  pushl $204
c01026df:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026e4:	e9 64 02 00 00       	jmp    c010294d <__alltraps>

c01026e9 <vector205>:
.globl vector205
vector205:
  pushl $0
c01026e9:	6a 00                	push   $0x0
  pushl $205
c01026eb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01026f0:	e9 58 02 00 00       	jmp    c010294d <__alltraps>

c01026f5 <vector206>:
.globl vector206
vector206:
  pushl $0
c01026f5:	6a 00                	push   $0x0
  pushl $206
c01026f7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01026fc:	e9 4c 02 00 00       	jmp    c010294d <__alltraps>

c0102701 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102701:	6a 00                	push   $0x0
  pushl $207
c0102703:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102708:	e9 40 02 00 00       	jmp    c010294d <__alltraps>

c010270d <vector208>:
.globl vector208
vector208:
  pushl $0
c010270d:	6a 00                	push   $0x0
  pushl $208
c010270f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102714:	e9 34 02 00 00       	jmp    c010294d <__alltraps>

c0102719 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102719:	6a 00                	push   $0x0
  pushl $209
c010271b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102720:	e9 28 02 00 00       	jmp    c010294d <__alltraps>

c0102725 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102725:	6a 00                	push   $0x0
  pushl $210
c0102727:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010272c:	e9 1c 02 00 00       	jmp    c010294d <__alltraps>

c0102731 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102731:	6a 00                	push   $0x0
  pushl $211
c0102733:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102738:	e9 10 02 00 00       	jmp    c010294d <__alltraps>

c010273d <vector212>:
.globl vector212
vector212:
  pushl $0
c010273d:	6a 00                	push   $0x0
  pushl $212
c010273f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102744:	e9 04 02 00 00       	jmp    c010294d <__alltraps>

c0102749 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102749:	6a 00                	push   $0x0
  pushl $213
c010274b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102750:	e9 f8 01 00 00       	jmp    c010294d <__alltraps>

c0102755 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102755:	6a 00                	push   $0x0
  pushl $214
c0102757:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010275c:	e9 ec 01 00 00       	jmp    c010294d <__alltraps>

c0102761 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102761:	6a 00                	push   $0x0
  pushl $215
c0102763:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102768:	e9 e0 01 00 00       	jmp    c010294d <__alltraps>

c010276d <vector216>:
.globl vector216
vector216:
  pushl $0
c010276d:	6a 00                	push   $0x0
  pushl $216
c010276f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102774:	e9 d4 01 00 00       	jmp    c010294d <__alltraps>

c0102779 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $217
c010277b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102780:	e9 c8 01 00 00       	jmp    c010294d <__alltraps>

c0102785 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102785:	6a 00                	push   $0x0
  pushl $218
c0102787:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010278c:	e9 bc 01 00 00       	jmp    c010294d <__alltraps>

c0102791 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102791:	6a 00                	push   $0x0
  pushl $219
c0102793:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102798:	e9 b0 01 00 00       	jmp    c010294d <__alltraps>

c010279d <vector220>:
.globl vector220
vector220:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $220
c010279f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01027a4:	e9 a4 01 00 00       	jmp    c010294d <__alltraps>

c01027a9 <vector221>:
.globl vector221
vector221:
  pushl $0
c01027a9:	6a 00                	push   $0x0
  pushl $221
c01027ab:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01027b0:	e9 98 01 00 00       	jmp    c010294d <__alltraps>

c01027b5 <vector222>:
.globl vector222
vector222:
  pushl $0
c01027b5:	6a 00                	push   $0x0
  pushl $222
c01027b7:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01027bc:	e9 8c 01 00 00       	jmp    c010294d <__alltraps>

c01027c1 <vector223>:
.globl vector223
vector223:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $223
c01027c3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01027c8:	e9 80 01 00 00       	jmp    c010294d <__alltraps>

c01027cd <vector224>:
.globl vector224
vector224:
  pushl $0
c01027cd:	6a 00                	push   $0x0
  pushl $224
c01027cf:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01027d4:	e9 74 01 00 00       	jmp    c010294d <__alltraps>

c01027d9 <vector225>:
.globl vector225
vector225:
  pushl $0
c01027d9:	6a 00                	push   $0x0
  pushl $225
c01027db:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027e0:	e9 68 01 00 00       	jmp    c010294d <__alltraps>

c01027e5 <vector226>:
.globl vector226
vector226:
  pushl $0
c01027e5:	6a 00                	push   $0x0
  pushl $226
c01027e7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01027ec:	e9 5c 01 00 00       	jmp    c010294d <__alltraps>

c01027f1 <vector227>:
.globl vector227
vector227:
  pushl $0
c01027f1:	6a 00                	push   $0x0
  pushl $227
c01027f3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01027f8:	e9 50 01 00 00       	jmp    c010294d <__alltraps>

c01027fd <vector228>:
.globl vector228
vector228:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $228
c01027ff:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102804:	e9 44 01 00 00       	jmp    c010294d <__alltraps>

c0102809 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102809:	6a 00                	push   $0x0
  pushl $229
c010280b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102810:	e9 38 01 00 00       	jmp    c010294d <__alltraps>

c0102815 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102815:	6a 00                	push   $0x0
  pushl $230
c0102817:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010281c:	e9 2c 01 00 00       	jmp    c010294d <__alltraps>

c0102821 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $231
c0102823:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102828:	e9 20 01 00 00       	jmp    c010294d <__alltraps>

c010282d <vector232>:
.globl vector232
vector232:
  pushl $0
c010282d:	6a 00                	push   $0x0
  pushl $232
c010282f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102834:	e9 14 01 00 00       	jmp    c010294d <__alltraps>

c0102839 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $233
c010283b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102840:	e9 08 01 00 00       	jmp    c010294d <__alltraps>

c0102845 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102845:	6a 00                	push   $0x0
  pushl $234
c0102847:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010284c:	e9 fc 00 00 00       	jmp    c010294d <__alltraps>

c0102851 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102851:	6a 00                	push   $0x0
  pushl $235
c0102853:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102858:	e9 f0 00 00 00       	jmp    c010294d <__alltraps>

c010285d <vector236>:
.globl vector236
vector236:
  pushl $0
c010285d:	6a 00                	push   $0x0
  pushl $236
c010285f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102864:	e9 e4 00 00 00       	jmp    c010294d <__alltraps>

c0102869 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102869:	6a 00                	push   $0x0
  pushl $237
c010286b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102870:	e9 d8 00 00 00       	jmp    c010294d <__alltraps>

c0102875 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102875:	6a 00                	push   $0x0
  pushl $238
c0102877:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010287c:	e9 cc 00 00 00       	jmp    c010294d <__alltraps>

c0102881 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102881:	6a 00                	push   $0x0
  pushl $239
c0102883:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102888:	e9 c0 00 00 00       	jmp    c010294d <__alltraps>

c010288d <vector240>:
.globl vector240
vector240:
  pushl $0
c010288d:	6a 00                	push   $0x0
  pushl $240
c010288f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102894:	e9 b4 00 00 00       	jmp    c010294d <__alltraps>

c0102899 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102899:	6a 00                	push   $0x0
  pushl $241
c010289b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01028a0:	e9 a8 00 00 00       	jmp    c010294d <__alltraps>

c01028a5 <vector242>:
.globl vector242
vector242:
  pushl $0
c01028a5:	6a 00                	push   $0x0
  pushl $242
c01028a7:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01028ac:	e9 9c 00 00 00       	jmp    c010294d <__alltraps>

c01028b1 <vector243>:
.globl vector243
vector243:
  pushl $0
c01028b1:	6a 00                	push   $0x0
  pushl $243
c01028b3:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01028b8:	e9 90 00 00 00       	jmp    c010294d <__alltraps>

c01028bd <vector244>:
.globl vector244
vector244:
  pushl $0
c01028bd:	6a 00                	push   $0x0
  pushl $244
c01028bf:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028c4:	e9 84 00 00 00       	jmp    c010294d <__alltraps>

c01028c9 <vector245>:
.globl vector245
vector245:
  pushl $0
c01028c9:	6a 00                	push   $0x0
  pushl $245
c01028cb:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01028d0:	e9 78 00 00 00       	jmp    c010294d <__alltraps>

c01028d5 <vector246>:
.globl vector246
vector246:
  pushl $0
c01028d5:	6a 00                	push   $0x0
  pushl $246
c01028d7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028dc:	e9 6c 00 00 00       	jmp    c010294d <__alltraps>

c01028e1 <vector247>:
.globl vector247
vector247:
  pushl $0
c01028e1:	6a 00                	push   $0x0
  pushl $247
c01028e3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01028e8:	e9 60 00 00 00       	jmp    c010294d <__alltraps>

c01028ed <vector248>:
.globl vector248
vector248:
  pushl $0
c01028ed:	6a 00                	push   $0x0
  pushl $248
c01028ef:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01028f4:	e9 54 00 00 00       	jmp    c010294d <__alltraps>

c01028f9 <vector249>:
.globl vector249
vector249:
  pushl $0
c01028f9:	6a 00                	push   $0x0
  pushl $249
c01028fb:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102900:	e9 48 00 00 00       	jmp    c010294d <__alltraps>

c0102905 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102905:	6a 00                	push   $0x0
  pushl $250
c0102907:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010290c:	e9 3c 00 00 00       	jmp    c010294d <__alltraps>

c0102911 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102911:	6a 00                	push   $0x0
  pushl $251
c0102913:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102918:	e9 30 00 00 00       	jmp    c010294d <__alltraps>

c010291d <vector252>:
.globl vector252
vector252:
  pushl $0
c010291d:	6a 00                	push   $0x0
  pushl $252
c010291f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102924:	e9 24 00 00 00       	jmp    c010294d <__alltraps>

c0102929 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102929:	6a 00                	push   $0x0
  pushl $253
c010292b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102930:	e9 18 00 00 00       	jmp    c010294d <__alltraps>

c0102935 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102935:	6a 00                	push   $0x0
  pushl $254
c0102937:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010293c:	e9 0c 00 00 00       	jmp    c010294d <__alltraps>

c0102941 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102941:	6a 00                	push   $0x0
  pushl $255
c0102943:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102948:	e9 00 00 00 00       	jmp    c010294d <__alltraps>

c010294d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010294d:	1e                   	push   %ds
    pushl %es
c010294e:	06                   	push   %es
    pushl %fs
c010294f:	0f a0                	push   %fs
    pushl %gs
c0102951:	0f a8                	push   %gs
    pushal
c0102953:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102954:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102959:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010295b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010295d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010295e:	e8 60 f5 ff ff       	call   c0101ec3 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102963:	5c                   	pop    %esp

c0102964 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102964:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102965:	0f a9                	pop    %gs
    popl %fs
c0102967:	0f a1                	pop    %fs
    popl %es
c0102969:	07                   	pop    %es
    popl %ds
c010296a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010296b:	83 c4 08             	add    $0x8,%esp
    iret
c010296e:	cf                   	iret   

c010296f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010296f:	55                   	push   %ebp
c0102970:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102972:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0102977:	8b 55 08             	mov    0x8(%ebp),%edx
c010297a:	29 c2                	sub    %eax,%edx
c010297c:	89 d0                	mov    %edx,%eax
c010297e:	c1 f8 02             	sar    $0x2,%eax
c0102981:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102987:	5d                   	pop    %ebp
c0102988:	c3                   	ret    

c0102989 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102989:	55                   	push   %ebp
c010298a:	89 e5                	mov    %esp,%ebp
c010298c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010298f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102992:	89 04 24             	mov    %eax,(%esp)
c0102995:	e8 d5 ff ff ff       	call   c010296f <page2ppn>
c010299a:	c1 e0 0c             	shl    $0xc,%eax
}
c010299d:	c9                   	leave  
c010299e:	c3                   	ret    

c010299f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010299f:	55                   	push   %ebp
c01029a0:	89 e5                	mov    %esp,%ebp
c01029a2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01029a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a8:	c1 e8 0c             	shr    $0xc,%eax
c01029ab:	89 c2                	mov    %eax,%edx
c01029ad:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01029b2:	39 c2                	cmp    %eax,%edx
c01029b4:	72 1c                	jb     c01029d2 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01029b6:	c7 44 24 08 50 68 10 	movl   $0xc0106850,0x8(%esp)
c01029bd:	c0 
c01029be:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01029c5:	00 
c01029c6:	c7 04 24 6f 68 10 c0 	movl   $0xc010686f,(%esp)
c01029cd:	e8 54 da ff ff       	call   c0100426 <__panic>
    }
    return &pages[PPN(pa)];
c01029d2:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c01029d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01029db:	c1 e8 0c             	shr    $0xc,%eax
c01029de:	89 c2                	mov    %eax,%edx
c01029e0:	89 d0                	mov    %edx,%eax
c01029e2:	c1 e0 02             	shl    $0x2,%eax
c01029e5:	01 d0                	add    %edx,%eax
c01029e7:	c1 e0 02             	shl    $0x2,%eax
c01029ea:	01 c8                	add    %ecx,%eax
}
c01029ec:	c9                   	leave  
c01029ed:	c3                   	ret    

c01029ee <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01029ee:	55                   	push   %ebp
c01029ef:	89 e5                	mov    %esp,%ebp
c01029f1:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01029f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01029f7:	89 04 24             	mov    %eax,(%esp)
c01029fa:	e8 8a ff ff ff       	call   c0102989 <page2pa>
c01029ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a05:	c1 e8 0c             	shr    $0xc,%eax
c0102a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a0b:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102a10:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102a13:	72 23                	jb     c0102a38 <page2kva+0x4a>
c0102a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a18:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102a1c:	c7 44 24 08 80 68 10 	movl   $0xc0106880,0x8(%esp)
c0102a23:	c0 
c0102a24:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102a2b:	00 
c0102a2c:	c7 04 24 6f 68 10 c0 	movl   $0xc010686f,(%esp)
c0102a33:	e8 ee d9 ff ff       	call   c0100426 <__panic>
c0102a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a3b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102a40:	c9                   	leave  
c0102a41:	c3                   	ret    

c0102a42 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102a42:	55                   	push   %ebp
c0102a43:	89 e5                	mov    %esp,%ebp
c0102a45:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4b:	83 e0 01             	and    $0x1,%eax
c0102a4e:	85 c0                	test   %eax,%eax
c0102a50:	75 1c                	jne    c0102a6e <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102a52:	c7 44 24 08 a4 68 10 	movl   $0xc01068a4,0x8(%esp)
c0102a59:	c0 
c0102a5a:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102a61:	00 
c0102a62:	c7 04 24 6f 68 10 c0 	movl   $0xc010686f,(%esp)
c0102a69:	e8 b8 d9 ff ff       	call   c0100426 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a76:	89 04 24             	mov    %eax,(%esp)
c0102a79:	e8 21 ff ff ff       	call   c010299f <pa2page>
}
c0102a7e:	c9                   	leave  
c0102a7f:	c3                   	ret    

c0102a80 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102a80:	55                   	push   %ebp
c0102a81:	89 e5                	mov    %esp,%ebp
c0102a83:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102a86:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a8e:	89 04 24             	mov    %eax,(%esp)
c0102a91:	e8 09 ff ff ff       	call   c010299f <pa2page>
}
c0102a96:	c9                   	leave  
c0102a97:	c3                   	ret    

c0102a98 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102a98:	55                   	push   %ebp
c0102a99:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a9e:	8b 00                	mov    (%eax),%eax
}
c0102aa0:	5d                   	pop    %ebp
c0102aa1:	c3                   	ret    

c0102aa2 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102aa2:	55                   	push   %ebp
c0102aa3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102aab:	89 10                	mov    %edx,(%eax)
}
c0102aad:	90                   	nop
c0102aae:	5d                   	pop    %ebp
c0102aaf:	c3                   	ret    

c0102ab0 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102ab0:	55                   	push   %ebp
c0102ab1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab6:	8b 00                	mov    (%eax),%eax
c0102ab8:	8d 50 01             	lea    0x1(%eax),%edx
c0102abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102abe:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac3:	8b 00                	mov    (%eax),%eax
}
c0102ac5:	5d                   	pop    %ebp
c0102ac6:	c3                   	ret    

c0102ac7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102ac7:	55                   	push   %ebp
c0102ac8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0102acd:	8b 00                	mov    (%eax),%eax
c0102acf:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ada:	8b 00                	mov    (%eax),%eax
}
c0102adc:	5d                   	pop    %ebp
c0102add:	c3                   	ret    

c0102ade <__intr_save>:
__intr_save(void) {
c0102ade:	55                   	push   %ebp
c0102adf:	89 e5                	mov    %esp,%ebp
c0102ae1:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102ae4:	9c                   	pushf  
c0102ae5:	58                   	pop    %eax
c0102ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102aec:	25 00 02 00 00       	and    $0x200,%eax
c0102af1:	85 c0                	test   %eax,%eax
c0102af3:	74 0c                	je     c0102b01 <__intr_save+0x23>
        intr_disable();
c0102af5:	e8 84 ee ff ff       	call   c010197e <intr_disable>
        return 1;
c0102afa:	b8 01 00 00 00       	mov    $0x1,%eax
c0102aff:	eb 05                	jmp    c0102b06 <__intr_save+0x28>
    return 0;
c0102b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b06:	c9                   	leave  
c0102b07:	c3                   	ret    

c0102b08 <__intr_restore>:
__intr_restore(bool flag) {
c0102b08:	55                   	push   %ebp
c0102b09:	89 e5                	mov    %esp,%ebp
c0102b0b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102b0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b12:	74 05                	je     c0102b19 <__intr_restore+0x11>
        intr_enable();
c0102b14:	e8 59 ee ff ff       	call   c0101972 <intr_enable>
}
c0102b19:	90                   	nop
c0102b1a:	c9                   	leave  
c0102b1b:	c3                   	ret    

c0102b1c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102b1c:	55                   	push   %ebp
c0102b1d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b22:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102b25:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b2a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102b2c:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b31:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102b33:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b38:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102b3a:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b3f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102b41:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b46:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102b48:	ea 4f 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102b4f
}
c0102b4f:	90                   	nop
c0102b50:	5d                   	pop    %ebp
c0102b51:	c3                   	ret    

c0102b52 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102b52:	f3 0f 1e fb          	endbr32 
c0102b56:	55                   	push   %ebp
c0102b57:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b5c:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
}
c0102b61:	90                   	nop
c0102b62:	5d                   	pop    %ebp
c0102b63:	c3                   	ret    

c0102b64 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102b64:	f3 0f 1e fb          	endbr32 
c0102b68:	55                   	push   %ebp
c0102b69:	89 e5                	mov    %esp,%ebp
c0102b6b:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102b6e:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0102b73:	89 04 24             	mov    %eax,(%esp)
c0102b76:	e8 d7 ff ff ff       	call   c0102b52 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102b7b:	66 c7 05 a8 ce 11 c0 	movw   $0x10,0xc011cea8
c0102b82:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102b84:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0102b8b:	68 00 
c0102b8d:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102b92:	0f b7 c0             	movzwl %ax,%eax
c0102b95:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0102b9b:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102ba0:	c1 e8 10             	shr    $0x10,%eax
c0102ba3:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0102ba8:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102baf:	24 f0                	and    $0xf0,%al
c0102bb1:	0c 09                	or     $0x9,%al
c0102bb3:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102bb8:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102bbf:	24 ef                	and    $0xef,%al
c0102bc1:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102bc6:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102bcd:	24 9f                	and    $0x9f,%al
c0102bcf:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102bd4:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102bdb:	0c 80                	or     $0x80,%al
c0102bdd:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102be2:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102be9:	24 f0                	and    $0xf0,%al
c0102beb:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bf0:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102bf7:	24 ef                	and    $0xef,%al
c0102bf9:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bfe:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c05:	24 df                	and    $0xdf,%al
c0102c07:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c0c:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c13:	0c 40                	or     $0x40,%al
c0102c15:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c1a:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c21:	24 7f                	and    $0x7f,%al
c0102c23:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c28:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102c2d:	c1 e8 18             	shr    $0x18,%eax
c0102c30:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102c35:	c7 04 24 30 9a 11 c0 	movl   $0xc0119a30,(%esp)
c0102c3c:	e8 db fe ff ff       	call   c0102b1c <lgdt>
c0102c41:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102c47:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102c4b:	0f 00 d8             	ltr    %ax
}
c0102c4e:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0102c4f:	90                   	nop
c0102c50:	c9                   	leave  
c0102c51:	c3                   	ret    

c0102c52 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102c52:	f3 0f 1e fb          	endbr32 
c0102c56:	55                   	push   %ebp
c0102c57:	89 e5                	mov    %esp,%ebp
c0102c59:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102c5c:	c7 05 10 cf 11 c0 48 	movl   $0xc0107248,0xc011cf10
c0102c63:	72 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102c66:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c6b:	8b 00                	mov    (%eax),%eax
c0102c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102c71:	c7 04 24 d0 68 10 c0 	movl   $0xc01068d0,(%esp)
c0102c78:	e8 3d d6 ff ff       	call   c01002ba <cprintf>
    pmm_manager->init();
c0102c7d:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c82:	8b 40 04             	mov    0x4(%eax),%eax
c0102c85:	ff d0                	call   *%eax
}
c0102c87:	90                   	nop
c0102c88:	c9                   	leave  
c0102c89:	c3                   	ret    

c0102c8a <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102c8a:	f3 0f 1e fb          	endbr32 
c0102c8e:	55                   	push   %ebp
c0102c8f:	89 e5                	mov    %esp,%ebp
c0102c91:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102c94:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c99:	8b 40 08             	mov    0x8(%eax),%eax
c0102c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c9f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102ca3:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ca6:	89 14 24             	mov    %edx,(%esp)
c0102ca9:	ff d0                	call   *%eax
}
c0102cab:	90                   	nop
c0102cac:	c9                   	leave  
c0102cad:	c3                   	ret    

c0102cae <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102cae:	f3 0f 1e fb          	endbr32 
c0102cb2:	55                   	push   %ebp
c0102cb3:	89 e5                	mov    %esp,%ebp
c0102cb5:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102cb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cbf:	e8 1a fe ff ff       	call   c0102ade <__intr_save>
c0102cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102cc7:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102ccc:	8b 40 0c             	mov    0xc(%eax),%eax
c0102ccf:	8b 55 08             	mov    0x8(%ebp),%edx
c0102cd2:	89 14 24             	mov    %edx,(%esp)
c0102cd5:	ff d0                	call   *%eax
c0102cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cdd:	89 04 24             	mov    %eax,(%esp)
c0102ce0:	e8 23 fe ff ff       	call   c0102b08 <__intr_restore>
    return page;
c0102ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102ce8:	c9                   	leave  
c0102ce9:	c3                   	ret    

c0102cea <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102cea:	f3 0f 1e fb          	endbr32 
c0102cee:	55                   	push   %ebp
c0102cef:	89 e5                	mov    %esp,%ebp
c0102cf1:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cf4:	e8 e5 fd ff ff       	call   c0102ade <__intr_save>
c0102cf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102cfc:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d01:	8b 40 10             	mov    0x10(%eax),%eax
c0102d04:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d07:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102d0b:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d0e:	89 14 24             	mov    %edx,(%esp)
c0102d11:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d16:	89 04 24             	mov    %eax,(%esp)
c0102d19:	e8 ea fd ff ff       	call   c0102b08 <__intr_restore>
}
c0102d1e:	90                   	nop
c0102d1f:	c9                   	leave  
c0102d20:	c3                   	ret    

c0102d21 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102d21:	f3 0f 1e fb          	endbr32 
c0102d25:	55                   	push   %ebp
c0102d26:	89 e5                	mov    %esp,%ebp
c0102d28:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d2b:	e8 ae fd ff ff       	call   c0102ade <__intr_save>
c0102d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102d33:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d38:	8b 40 14             	mov    0x14(%eax),%eax
c0102d3b:	ff d0                	call   *%eax
c0102d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d43:	89 04 24             	mov    %eax,(%esp)
c0102d46:	e8 bd fd ff ff       	call   c0102b08 <__intr_restore>
    return ret;
c0102d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102d4e:	c9                   	leave  
c0102d4f:	c3                   	ret    

c0102d50 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102d50:	f3 0f 1e fb          	endbr32 
c0102d54:	55                   	push   %ebp
c0102d55:	89 e5                	mov    %esp,%ebp
c0102d57:	57                   	push   %edi
c0102d58:	56                   	push   %esi
c0102d59:	53                   	push   %ebx
c0102d5a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102d60:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102d67:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102d6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102d75:	c7 04 24 e7 68 10 c0 	movl   $0xc01068e7,(%esp)
c0102d7c:	e8 39 d5 ff ff       	call   c01002ba <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102d88:	e9 1a 01 00 00       	jmp    c0102ea7 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102d8d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d93:	89 d0                	mov    %edx,%eax
c0102d95:	c1 e0 02             	shl    $0x2,%eax
c0102d98:	01 d0                	add    %edx,%eax
c0102d9a:	c1 e0 02             	shl    $0x2,%eax
c0102d9d:	01 c8                	add    %ecx,%eax
c0102d9f:	8b 50 08             	mov    0x8(%eax),%edx
c0102da2:	8b 40 04             	mov    0x4(%eax),%eax
c0102da5:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102da8:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102dab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102dae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102db1:	89 d0                	mov    %edx,%eax
c0102db3:	c1 e0 02             	shl    $0x2,%eax
c0102db6:	01 d0                	add    %edx,%eax
c0102db8:	c1 e0 02             	shl    $0x2,%eax
c0102dbb:	01 c8                	add    %ecx,%eax
c0102dbd:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102dc0:	8b 58 10             	mov    0x10(%eax),%ebx
c0102dc3:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102dc6:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102dc9:	01 c8                	add    %ecx,%eax
c0102dcb:	11 da                	adc    %ebx,%edx
c0102dcd:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102dd0:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102dd3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dd9:	89 d0                	mov    %edx,%eax
c0102ddb:	c1 e0 02             	shl    $0x2,%eax
c0102dde:	01 d0                	add    %edx,%eax
c0102de0:	c1 e0 02             	shl    $0x2,%eax
c0102de3:	01 c8                	add    %ecx,%eax
c0102de5:	83 c0 14             	add    $0x14,%eax
c0102de8:	8b 00                	mov    (%eax),%eax
c0102dea:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102ded:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102df0:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102df3:	83 c0 ff             	add    $0xffffffff,%eax
c0102df6:	83 d2 ff             	adc    $0xffffffff,%edx
c0102df9:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0102dff:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102e05:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e08:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e0b:	89 d0                	mov    %edx,%eax
c0102e0d:	c1 e0 02             	shl    $0x2,%eax
c0102e10:	01 d0                	add    %edx,%eax
c0102e12:	c1 e0 02             	shl    $0x2,%eax
c0102e15:	01 c8                	add    %ecx,%eax
c0102e17:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e1a:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e1d:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102e20:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0102e24:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102e2a:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102e30:	89 44 24 14          	mov    %eax,0x14(%esp)
c0102e34:	89 54 24 18          	mov    %edx,0x18(%esp)
c0102e38:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e3b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102e42:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102e46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102e4a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102e4e:	c7 04 24 f4 68 10 c0 	movl   $0xc01068f4,(%esp)
c0102e55:	e8 60 d4 ff ff       	call   c01002ba <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102e5a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e60:	89 d0                	mov    %edx,%eax
c0102e62:	c1 e0 02             	shl    $0x2,%eax
c0102e65:	01 d0                	add    %edx,%eax
c0102e67:	c1 e0 02             	shl    $0x2,%eax
c0102e6a:	01 c8                	add    %ecx,%eax
c0102e6c:	83 c0 14             	add    $0x14,%eax
c0102e6f:	8b 00                	mov    (%eax),%eax
c0102e71:	83 f8 01             	cmp    $0x1,%eax
c0102e74:	75 2e                	jne    c0102ea4 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
c0102e76:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e7c:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102e7f:	89 d0                	mov    %edx,%eax
c0102e81:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0102e84:	73 1e                	jae    c0102ea4 <page_init+0x154>
c0102e86:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0102e8b:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e90:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0102e93:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0102e96:	72 0c                	jb     c0102ea4 <page_init+0x154>
                maxpa = end;
c0102e98:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e9b:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102e9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102ea1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102ea4:	ff 45 dc             	incl   -0x24(%ebp)
c0102ea7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102eaa:	8b 00                	mov    (%eax),%eax
c0102eac:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102eaf:	0f 8c d8 fe ff ff    	jl     c0102d8d <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102eb5:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0102eba:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ebf:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0102ec2:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0102ec5:	73 0e                	jae    c0102ed5 <page_init+0x185>
        maxpa = KMEMSIZE;
c0102ec7:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102ece:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102edb:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102edf:	c1 ea 0c             	shr    $0xc,%edx
c0102ee2:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102ee7:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102eee:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0102ef3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102ef6:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ef9:	01 d0                	add    %edx,%eax
c0102efb:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102efe:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102f01:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f06:	f7 75 c0             	divl   -0x40(%ebp)
c0102f09:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102f0c:	29 d0                	sub    %edx,%eax
c0102f0e:	a3 18 cf 11 c0       	mov    %eax,0xc011cf18

    for (i = 0; i < npage; i ++) {
c0102f13:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f1a:	eb 2f                	jmp    c0102f4b <page_init+0x1fb>
        SetPageReserved(pages + i);
c0102f1c:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c0102f22:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f25:	89 d0                	mov    %edx,%eax
c0102f27:	c1 e0 02             	shl    $0x2,%eax
c0102f2a:	01 d0                	add    %edx,%eax
c0102f2c:	c1 e0 02             	shl    $0x2,%eax
c0102f2f:	01 c8                	add    %ecx,%eax
c0102f31:	83 c0 04             	add    $0x4,%eax
c0102f34:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0102f3b:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f3e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102f41:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102f44:	0f ab 10             	bts    %edx,(%eax)
}
c0102f47:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0102f48:	ff 45 dc             	incl   -0x24(%ebp)
c0102f4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f4e:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102f53:	39 c2                	cmp    %eax,%edx
c0102f55:	72 c5                	jb     c0102f1c <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102f57:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0102f5d:	89 d0                	mov    %edx,%eax
c0102f5f:	c1 e0 02             	shl    $0x2,%eax
c0102f62:	01 d0                	add    %edx,%eax
c0102f64:	c1 e0 02             	shl    $0x2,%eax
c0102f67:	89 c2                	mov    %eax,%edx
c0102f69:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0102f6e:	01 d0                	add    %edx,%eax
c0102f70:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102f73:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0102f7a:	77 23                	ja     c0102f9f <page_init+0x24f>
c0102f7c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102f7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102f83:	c7 44 24 08 24 69 10 	movl   $0xc0106924,0x8(%esp)
c0102f8a:	c0 
c0102f8b:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102f92:	00 
c0102f93:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0102f9a:	e8 87 d4 ff ff       	call   c0100426 <__panic>
c0102f9f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102fa2:	05 00 00 00 40       	add    $0x40000000,%eax
c0102fa7:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102faa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102fb1:	e9 4b 01 00 00       	jmp    c0103101 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102fb6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fb9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fbc:	89 d0                	mov    %edx,%eax
c0102fbe:	c1 e0 02             	shl    $0x2,%eax
c0102fc1:	01 d0                	add    %edx,%eax
c0102fc3:	c1 e0 02             	shl    $0x2,%eax
c0102fc6:	01 c8                	add    %ecx,%eax
c0102fc8:	8b 50 08             	mov    0x8(%eax),%edx
c0102fcb:	8b 40 04             	mov    0x4(%eax),%eax
c0102fce:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102fd1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102fd4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fd7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fda:	89 d0                	mov    %edx,%eax
c0102fdc:	c1 e0 02             	shl    $0x2,%eax
c0102fdf:	01 d0                	add    %edx,%eax
c0102fe1:	c1 e0 02             	shl    $0x2,%eax
c0102fe4:	01 c8                	add    %ecx,%eax
c0102fe6:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102fe9:	8b 58 10             	mov    0x10(%eax),%ebx
c0102fec:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ff2:	01 c8                	add    %ecx,%eax
c0102ff4:	11 da                	adc    %ebx,%edx
c0102ff6:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ff9:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102ffc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fff:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103002:	89 d0                	mov    %edx,%eax
c0103004:	c1 e0 02             	shl    $0x2,%eax
c0103007:	01 d0                	add    %edx,%eax
c0103009:	c1 e0 02             	shl    $0x2,%eax
c010300c:	01 c8                	add    %ecx,%eax
c010300e:	83 c0 14             	add    $0x14,%eax
c0103011:	8b 00                	mov    (%eax),%eax
c0103013:	83 f8 01             	cmp    $0x1,%eax
c0103016:	0f 85 e2 00 00 00    	jne    c01030fe <page_init+0x3ae>
            if (begin < freemem) {
c010301c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010301f:	ba 00 00 00 00       	mov    $0x0,%edx
c0103024:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103027:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010302a:	19 d1                	sbb    %edx,%ecx
c010302c:	73 0d                	jae    c010303b <page_init+0x2eb>
                begin = freemem;
c010302e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103031:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103034:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010303b:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103040:	b8 00 00 00 00       	mov    $0x0,%eax
c0103045:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103048:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010304b:	73 0e                	jae    c010305b <page_init+0x30b>
                end = KMEMSIZE;
c010304d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103054:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010305b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010305e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103061:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103064:	89 d0                	mov    %edx,%eax
c0103066:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103069:	0f 83 8f 00 00 00    	jae    c01030fe <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
c010306f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103076:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103079:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010307c:	01 d0                	add    %edx,%eax
c010307e:	48                   	dec    %eax
c010307f:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103082:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103085:	ba 00 00 00 00       	mov    $0x0,%edx
c010308a:	f7 75 b0             	divl   -0x50(%ebp)
c010308d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103090:	29 d0                	sub    %edx,%eax
c0103092:	ba 00 00 00 00       	mov    $0x0,%edx
c0103097:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010309a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010309d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01030a0:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01030a3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01030a6:	ba 00 00 00 00       	mov    $0x0,%edx
c01030ab:	89 c3                	mov    %eax,%ebx
c01030ad:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c01030b3:	89 de                	mov    %ebx,%esi
c01030b5:	89 d0                	mov    %edx,%eax
c01030b7:	83 e0 00             	and    $0x0,%eax
c01030ba:	89 c7                	mov    %eax,%edi
c01030bc:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01030bf:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c01030c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01030c8:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01030cb:	89 d0                	mov    %edx,%eax
c01030cd:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01030d0:	73 2c                	jae    c01030fe <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01030d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01030d5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01030d8:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01030db:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01030de:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01030e2:	c1 ea 0c             	shr    $0xc,%edx
c01030e5:	89 c3                	mov    %eax,%ebx
c01030e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030ea:	89 04 24             	mov    %eax,(%esp)
c01030ed:	e8 ad f8 ff ff       	call   c010299f <pa2page>
c01030f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01030f6:	89 04 24             	mov    %eax,(%esp)
c01030f9:	e8 8c fb ff ff       	call   c0102c8a <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c01030fe:	ff 45 dc             	incl   -0x24(%ebp)
c0103101:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103104:	8b 00                	mov    (%eax),%eax
c0103106:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103109:	0f 8c a7 fe ff ff    	jl     c0102fb6 <page_init+0x266>
                }
            }
        }
    }
}
c010310f:	90                   	nop
c0103110:	90                   	nop
c0103111:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103117:	5b                   	pop    %ebx
c0103118:	5e                   	pop    %esi
c0103119:	5f                   	pop    %edi
c010311a:	5d                   	pop    %ebp
c010311b:	c3                   	ret    

c010311c <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010311c:	f3 0f 1e fb          	endbr32 
c0103120:	55                   	push   %ebp
c0103121:	89 e5                	mov    %esp,%ebp
c0103123:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103126:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103129:	33 45 14             	xor    0x14(%ebp),%eax
c010312c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103131:	85 c0                	test   %eax,%eax
c0103133:	74 24                	je     c0103159 <boot_map_segment+0x3d>
c0103135:	c7 44 24 0c 56 69 10 	movl   $0xc0106956,0xc(%esp)
c010313c:	c0 
c010313d:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103144:	c0 
c0103145:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010314c:	00 
c010314d:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103154:	e8 cd d2 ff ff       	call   c0100426 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103159:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103160:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103163:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103168:	89 c2                	mov    %eax,%edx
c010316a:	8b 45 10             	mov    0x10(%ebp),%eax
c010316d:	01 c2                	add    %eax,%edx
c010316f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103172:	01 d0                	add    %edx,%eax
c0103174:	48                   	dec    %eax
c0103175:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103178:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010317b:	ba 00 00 00 00       	mov    $0x0,%edx
c0103180:	f7 75 f0             	divl   -0x10(%ebp)
c0103183:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103186:	29 d0                	sub    %edx,%eax
c0103188:	c1 e8 0c             	shr    $0xc,%eax
c010318b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010318e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103191:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103194:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010319c:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010319f:	8b 45 14             	mov    0x14(%ebp),%eax
c01031a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01031a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01031a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01031ad:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01031b0:	eb 68                	jmp    c010321a <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01031b2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01031b9:	00 
c01031ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01031c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01031c4:	89 04 24             	mov    %eax,(%esp)
c01031c7:	e8 8a 01 00 00       	call   c0103356 <get_pte>
c01031cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01031cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01031d3:	75 24                	jne    c01031f9 <boot_map_segment+0xdd>
c01031d5:	c7 44 24 0c 82 69 10 	movl   $0xc0106982,0xc(%esp)
c01031dc:	c0 
c01031dd:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c01031e4:	c0 
c01031e5:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01031ec:	00 
c01031ed:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c01031f4:	e8 2d d2 ff ff       	call   c0100426 <__panic>
        *ptep = pa | PTE_P | perm;
c01031f9:	8b 45 14             	mov    0x14(%ebp),%eax
c01031fc:	0b 45 18             	or     0x18(%ebp),%eax
c01031ff:	83 c8 01             	or     $0x1,%eax
c0103202:	89 c2                	mov    %eax,%edx
c0103204:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103207:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103209:	ff 4d f4             	decl   -0xc(%ebp)
c010320c:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103213:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010321a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010321e:	75 92                	jne    c01031b2 <boot_map_segment+0x96>
    }
}
c0103220:	90                   	nop
c0103221:	90                   	nop
c0103222:	c9                   	leave  
c0103223:	c3                   	ret    

c0103224 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0103224:	f3 0f 1e fb          	endbr32 
c0103228:	55                   	push   %ebp
c0103229:	89 e5                	mov    %esp,%ebp
c010322b:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010322e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103235:	e8 74 fa ff ff       	call   c0102cae <alloc_pages>
c010323a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010323d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103241:	75 1c                	jne    c010325f <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
c0103243:	c7 44 24 08 8f 69 10 	movl   $0xc010698f,0x8(%esp)
c010324a:	c0 
c010324b:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103252:	00 
c0103253:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c010325a:	e8 c7 d1 ff ff       	call   c0100426 <__panic>
    }
    return page2kva(p);
c010325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103262:	89 04 24             	mov    %eax,(%esp)
c0103265:	e8 84 f7 ff ff       	call   c01029ee <page2kva>
}
c010326a:	c9                   	leave  
c010326b:	c3                   	ret    

c010326c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010326c:	f3 0f 1e fb          	endbr32 
c0103270:	55                   	push   %ebp
c0103271:	89 e5                	mov    %esp,%ebp
c0103273:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0103276:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010327b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010327e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103285:	77 23                	ja     c01032aa <pmm_init+0x3e>
c0103287:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010328a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010328e:	c7 44 24 08 24 69 10 	movl   $0xc0106924,0x8(%esp)
c0103295:	c0 
c0103296:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010329d:	00 
c010329e:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c01032a5:	e8 7c d1 ff ff       	call   c0100426 <__panic>
c01032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032ad:	05 00 00 00 40       	add    $0x40000000,%eax
c01032b2:	a3 14 cf 11 c0       	mov    %eax,0xc011cf14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01032b7:	e8 96 f9 ff ff       	call   c0102c52 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01032bc:	e8 8f fa ff ff       	call   c0102d50 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01032c1:	e8 f3 03 00 00       	call   c01036b9 <check_alloc_page>

    check_pgdir();
c01032c6:	e8 11 04 00 00       	call   c01036dc <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01032cb:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01032d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032d3:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01032da:	77 23                	ja     c01032ff <pmm_init+0x93>
c01032dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032df:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01032e3:	c7 44 24 08 24 69 10 	movl   $0xc0106924,0x8(%esp)
c01032ea:	c0 
c01032eb:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01032f2:	00 
c01032f3:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c01032fa:	e8 27 d1 ff ff       	call   c0100426 <__panic>
c01032ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103302:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0103308:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010330d:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103312:	83 ca 03             	or     $0x3,%edx
c0103315:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103317:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010331c:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0103323:	00 
c0103324:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010332b:	00 
c010332c:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0103333:	38 
c0103334:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010333b:	c0 
c010333c:	89 04 24             	mov    %eax,(%esp)
c010333f:	e8 d8 fd ff ff       	call   c010311c <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103344:	e8 1b f8 ff ff       	call   c0102b64 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103349:	e8 2e 0a 00 00       	call   c0103d7c <check_boot_pgdir>

    print_pgdir();
c010334e:	e8 b3 0e 00 00       	call   c0104206 <print_pgdir>

}
c0103353:	90                   	nop
c0103354:	c9                   	leave  
c0103355:	c3                   	ret    

c0103356 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0103356:	f3 0f 1e fb          	endbr32 
c010335a:	55                   	push   %ebp
c010335b:	89 e5                	mov    %esp,%ebp
c010335d:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)]; //首先使用PDX函数获取一级页表的位置
c0103360:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103363:	c1 e8 16             	shr    $0x16,%eax
c0103366:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010336d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103370:	01 d0                	add    %edx,%eax
c0103372:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {//如果获取不成功就尝试是否创建一个二级页表
c0103375:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103378:	8b 00                	mov    (%eax),%eax
c010337a:	83 e0 01             	and    $0x1,%eax
c010337d:	85 c0                	test   %eax,%eax
c010337f:	0f 85 af 00 00 00    	jne    c0103434 <get_pte+0xde>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {//创建二级页表通过create标记位来设置如果为0就不创建
c0103385:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103389:	74 15                	je     c01033a0 <get_pte+0x4a>
c010338b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103392:	e8 17 f9 ff ff       	call   c0102cae <alloc_pages>
c0103397:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010339a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010339e:	75 0a                	jne    c01033aa <get_pte+0x54>
            return NULL;
c01033a0:	b8 00 00 00 00       	mov    $0x0,%eax
c01033a5:	e9 e7 00 00 00       	jmp    c0103491 <get_pte+0x13b>
        }
        set_page_ref(page, 1); //如果能够创建二级页表首先需要将页表引用次数加一
c01033aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033b1:	00 
c01033b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033b5:	89 04 24             	mov    %eax,(%esp)
c01033b8:	e8 e5 f6 ff ff       	call   c0102aa2 <set_page_ref>
        uintptr_t pa = page2pa(page);//得到page管理的该页物理地址
c01033bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033c0:	89 04 24             	mov    %eax,(%esp)
c01033c3:	e8 c1 f5 ff ff       	call   c0102989 <page2pa>
c01033c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);//KADDR返回pa对应虚拟地址（线性地址），然后因为没有映射到物理地址所以全部设置为0
c01033cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033d4:	c1 e8 0c             	shr    $0xc,%eax
c01033d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01033da:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01033df:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01033e2:	72 23                	jb     c0103407 <get_pte+0xb1>
c01033e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01033eb:	c7 44 24 08 80 68 10 	movl   $0xc0106880,0x8(%esp)
c01033f2:	c0 
c01033f3:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
c01033fa:	00 
c01033fb:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103402:	e8 1f d0 ff ff       	call   c0100426 <__panic>
c0103407:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010340a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010340f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103416:	00 
c0103417:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010341e:	00 
c010341f:	89 04 24             	mov    %eax,(%esp)
c0103422:	e8 d3 24 00 00       	call   c01058fa <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;//设置控制位
c0103427:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010342a:	83 c8 07             	or     $0x7,%eax
c010342d:	89 c2                	mov    %eax,%edx
c010342f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103432:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];//最后返回对应地址
c0103434:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103437:	8b 00                	mov    (%eax),%eax
c0103439:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010343e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103441:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103444:	c1 e8 0c             	shr    $0xc,%eax
c0103447:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010344a:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c010344f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103452:	72 23                	jb     c0103477 <get_pte+0x121>
c0103454:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103457:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010345b:	c7 44 24 08 80 68 10 	movl   $0xc0106880,0x8(%esp)
c0103462:	c0 
c0103463:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
c010346a:	00 
c010346b:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103472:	e8 af cf ff ff       	call   c0100426 <__panic>
c0103477:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010347a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010347f:	89 c2                	mov    %eax,%edx
c0103481:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103484:	c1 e8 0c             	shr    $0xc,%eax
c0103487:	25 ff 03 00 00       	and    $0x3ff,%eax
c010348c:	c1 e0 02             	shl    $0x2,%eax
c010348f:	01 d0                	add    %edx,%eax
}
c0103491:	c9                   	leave  
c0103492:	c3                   	ret    

c0103493 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103493:	f3 0f 1e fb          	endbr32 
c0103497:	55                   	push   %ebp
c0103498:	89 e5                	mov    %esp,%ebp
c010349a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010349d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01034a4:	00 
c01034a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01034af:	89 04 24             	mov    %eax,(%esp)
c01034b2:	e8 9f fe ff ff       	call   c0103356 <get_pte>
c01034b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01034ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01034be:	74 08                	je     c01034c8 <get_page+0x35>
        *ptep_store = ptep;
c01034c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01034c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01034c6:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01034c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034cc:	74 1b                	je     c01034e9 <get_page+0x56>
c01034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d1:	8b 00                	mov    (%eax),%eax
c01034d3:	83 e0 01             	and    $0x1,%eax
c01034d6:	85 c0                	test   %eax,%eax
c01034d8:	74 0f                	je     c01034e9 <get_page+0x56>
        return pte2page(*ptep);
c01034da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034dd:	8b 00                	mov    (%eax),%eax
c01034df:	89 04 24             	mov    %eax,(%esp)
c01034e2:	e8 5b f5 ff ff       	call   c0102a42 <pte2page>
c01034e7:	eb 05                	jmp    c01034ee <get_page+0x5b>
    }
    return NULL;
c01034e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01034ee:	c9                   	leave  
c01034ef:	c3                   	ret    

c01034f0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01034f0:	55                   	push   %ebp
c01034f1:	89 e5                	mov    %esp,%ebp
c01034f3:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
if (*ptep & PTE_P) {
c01034f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01034f9:	8b 00                	mov    (%eax),%eax
c01034fb:	83 e0 01             	and    $0x1,%eax
c01034fe:	85 c0                	test   %eax,%eax
c0103500:	74 4d                	je     c010354f <page_remove_pte+0x5f>
    struct Page *page = pte2page(*ptep);//获取该页表项对应的物理页的page结构
c0103502:	8b 45 10             	mov    0x10(%ebp),%eax
c0103505:	8b 00                	mov    (%eax),%eax
c0103507:	89 04 24             	mov    %eax,(%esp)
c010350a:	e8 33 f5 ff ff       	call   c0102a42 <pte2page>
c010350f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page_ref_dec(page) == 0) {
c0103512:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103515:	89 04 24             	mov    %eax,(%esp)
c0103518:	e8 aa f5 ff ff       	call   c0102ac7 <page_ref_dec>
c010351d:	85 c0                	test   %eax,%eax
c010351f:	75 13                	jne    c0103534 <page_remove_pte+0x44>
        free_page(page);     //free a page
c0103521:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103528:	00 
c0103529:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010352c:	89 04 24             	mov    %eax,(%esp)
c010352f:	e8 b6 f7 ff ff       	call   c0102cea <free_pages>
    }
    *ptep = 0;//将二级页表置0表示取消映射
c0103534:	8b 45 10             	mov    0x10(%ebp),%eax
c0103537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    tlb_invalidate(pgdir, la);//刷新tlb，保证tlb中的缓存不会有错误映射关系
c010353d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103540:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103544:	8b 45 08             	mov    0x8(%ebp),%eax
c0103547:	89 04 24             	mov    %eax,(%esp)
c010354a:	e8 09 01 00 00       	call   c0103658 <tlb_invalidate>
}
}
c010354f:	90                   	nop
c0103550:	c9                   	leave  
c0103551:	c3                   	ret    

c0103552 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103552:	f3 0f 1e fb          	endbr32 
c0103556:	55                   	push   %ebp
c0103557:	89 e5                	mov    %esp,%ebp
c0103559:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010355c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103563:	00 
c0103564:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103567:	89 44 24 04          	mov    %eax,0x4(%esp)
c010356b:	8b 45 08             	mov    0x8(%ebp),%eax
c010356e:	89 04 24             	mov    %eax,(%esp)
c0103571:	e8 e0 fd ff ff       	call   c0103356 <get_pte>
c0103576:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010357d:	74 19                	je     c0103598 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
c010357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103582:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103586:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103589:	89 44 24 04          	mov    %eax,0x4(%esp)
c010358d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103590:	89 04 24             	mov    %eax,(%esp)
c0103593:	e8 58 ff ff ff       	call   c01034f0 <page_remove_pte>
    }
}
c0103598:	90                   	nop
c0103599:	c9                   	leave  
c010359a:	c3                   	ret    

c010359b <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010359b:	f3 0f 1e fb          	endbr32 
c010359f:	55                   	push   %ebp
c01035a0:	89 e5                	mov    %esp,%ebp
c01035a2:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01035a5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01035ac:	00 
c01035ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01035b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01035b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01035b7:	89 04 24             	mov    %eax,(%esp)
c01035ba:	e8 97 fd ff ff       	call   c0103356 <get_pte>
c01035bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01035c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01035c6:	75 0a                	jne    c01035d2 <page_insert+0x37>
        return -E_NO_MEM;
c01035c8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01035cd:	e9 84 00 00 00       	jmp    c0103656 <page_insert+0xbb>
    }
    page_ref_inc(page);
c01035d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035d5:	89 04 24             	mov    %eax,(%esp)
c01035d8:	e8 d3 f4 ff ff       	call   c0102ab0 <page_ref_inc>
    if (*ptep & PTE_P) {
c01035dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e0:	8b 00                	mov    (%eax),%eax
c01035e2:	83 e0 01             	and    $0x1,%eax
c01035e5:	85 c0                	test   %eax,%eax
c01035e7:	74 3e                	je     c0103627 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
c01035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ec:	8b 00                	mov    (%eax),%eax
c01035ee:	89 04 24             	mov    %eax,(%esp)
c01035f1:	e8 4c f4 ff ff       	call   c0102a42 <pte2page>
c01035f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01035f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01035ff:	75 0d                	jne    c010360e <page_insert+0x73>
            page_ref_dec(page);
c0103601:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103604:	89 04 24             	mov    %eax,(%esp)
c0103607:	e8 bb f4 ff ff       	call   c0102ac7 <page_ref_dec>
c010360c:	eb 19                	jmp    c0103627 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103611:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103615:	8b 45 10             	mov    0x10(%ebp),%eax
c0103618:	89 44 24 04          	mov    %eax,0x4(%esp)
c010361c:	8b 45 08             	mov    0x8(%ebp),%eax
c010361f:	89 04 24             	mov    %eax,(%esp)
c0103622:	e8 c9 fe ff ff       	call   c01034f0 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103627:	8b 45 0c             	mov    0xc(%ebp),%eax
c010362a:	89 04 24             	mov    %eax,(%esp)
c010362d:	e8 57 f3 ff ff       	call   c0102989 <page2pa>
c0103632:	0b 45 14             	or     0x14(%ebp),%eax
c0103635:	83 c8 01             	or     $0x1,%eax
c0103638:	89 c2                	mov    %eax,%edx
c010363a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010363d:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010363f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103642:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103646:	8b 45 08             	mov    0x8(%ebp),%eax
c0103649:	89 04 24             	mov    %eax,(%esp)
c010364c:	e8 07 00 00 00       	call   c0103658 <tlb_invalidate>
    return 0;
c0103651:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103656:	c9                   	leave  
c0103657:	c3                   	ret    

c0103658 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103658:	f3 0f 1e fb          	endbr32 
c010365c:	55                   	push   %ebp
c010365d:	89 e5                	mov    %esp,%ebp
c010365f:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103662:	0f 20 d8             	mov    %cr3,%eax
c0103665:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0103668:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010366b:	8b 45 08             	mov    0x8(%ebp),%eax
c010366e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103671:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103678:	77 23                	ja     c010369d <tlb_invalidate+0x45>
c010367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010367d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103681:	c7 44 24 08 24 69 10 	movl   $0xc0106924,0x8(%esp)
c0103688:	c0 
c0103689:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
c0103690:	00 
c0103691:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103698:	e8 89 cd ff ff       	call   c0100426 <__panic>
c010369d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036a0:	05 00 00 00 40       	add    $0x40000000,%eax
c01036a5:	39 d0                	cmp    %edx,%eax
c01036a7:	75 0d                	jne    c01036b6 <tlb_invalidate+0x5e>
        invlpg((void *)la);
c01036a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01036af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036b2:	0f 01 38             	invlpg (%eax)
}
c01036b5:	90                   	nop
    }
}
c01036b6:	90                   	nop
c01036b7:	c9                   	leave  
c01036b8:	c3                   	ret    

c01036b9 <check_alloc_page>:

static void
check_alloc_page(void) {
c01036b9:	f3 0f 1e fb          	endbr32 
c01036bd:	55                   	push   %ebp
c01036be:	89 e5                	mov    %esp,%ebp
c01036c0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01036c3:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c01036c8:	8b 40 18             	mov    0x18(%eax),%eax
c01036cb:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01036cd:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c01036d4:	e8 e1 cb ff ff       	call   c01002ba <cprintf>
}
c01036d9:	90                   	nop
c01036da:	c9                   	leave  
c01036db:	c3                   	ret    

c01036dc <check_pgdir>:

static void
check_pgdir(void) {
c01036dc:	f3 0f 1e fb          	endbr32 
c01036e0:	55                   	push   %ebp
c01036e1:	89 e5                	mov    %esp,%ebp
c01036e3:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01036e6:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01036eb:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01036f0:	76 24                	jbe    c0103716 <check_pgdir+0x3a>
c01036f2:	c7 44 24 0c c7 69 10 	movl   $0xc01069c7,0xc(%esp)
c01036f9:	c0 
c01036fa:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103701:	c0 
c0103702:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0103709:	00 
c010370a:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103711:	e8 10 cd ff ff       	call   c0100426 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103716:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010371b:	85 c0                	test   %eax,%eax
c010371d:	74 0e                	je     c010372d <check_pgdir+0x51>
c010371f:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103724:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103729:	85 c0                	test   %eax,%eax
c010372b:	74 24                	je     c0103751 <check_pgdir+0x75>
c010372d:	c7 44 24 0c e4 69 10 	movl   $0xc01069e4,0xc(%esp)
c0103734:	c0 
c0103735:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c010373c:	c0 
c010373d:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0103744:	00 
c0103745:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c010374c:	e8 d5 cc ff ff       	call   c0100426 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103751:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103756:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010375d:	00 
c010375e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103765:	00 
c0103766:	89 04 24             	mov    %eax,(%esp)
c0103769:	e8 25 fd ff ff       	call   c0103493 <get_page>
c010376e:	85 c0                	test   %eax,%eax
c0103770:	74 24                	je     c0103796 <check_pgdir+0xba>
c0103772:	c7 44 24 0c 1c 6a 10 	movl   $0xc0106a1c,0xc(%esp)
c0103779:	c0 
c010377a:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103781:	c0 
c0103782:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0103789:	00 
c010378a:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103791:	e8 90 cc ff ff       	call   c0100426 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103796:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010379d:	e8 0c f5 ff ff       	call   c0102cae <alloc_pages>
c01037a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01037a5:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01037aa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01037b1:	00 
c01037b2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037b9:	00 
c01037ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01037bd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01037c1:	89 04 24             	mov    %eax,(%esp)
c01037c4:	e8 d2 fd ff ff       	call   c010359b <page_insert>
c01037c9:	85 c0                	test   %eax,%eax
c01037cb:	74 24                	je     c01037f1 <check_pgdir+0x115>
c01037cd:	c7 44 24 0c 44 6a 10 	movl   $0xc0106a44,0xc(%esp)
c01037d4:	c0 
c01037d5:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c01037dc:	c0 
c01037dd:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c01037e4:	00 
c01037e5:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c01037ec:	e8 35 cc ff ff       	call   c0100426 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01037f1:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01037f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037fd:	00 
c01037fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103805:	00 
c0103806:	89 04 24             	mov    %eax,(%esp)
c0103809:	e8 48 fb ff ff       	call   c0103356 <get_pte>
c010380e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103815:	75 24                	jne    c010383b <check_pgdir+0x15f>
c0103817:	c7 44 24 0c 70 6a 10 	movl   $0xc0106a70,0xc(%esp)
c010381e:	c0 
c010381f:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103826:	c0 
c0103827:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c010382e:	00 
c010382f:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103836:	e8 eb cb ff ff       	call   c0100426 <__panic>
    assert(pte2page(*ptep) == p1);
c010383b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010383e:	8b 00                	mov    (%eax),%eax
c0103840:	89 04 24             	mov    %eax,(%esp)
c0103843:	e8 fa f1 ff ff       	call   c0102a42 <pte2page>
c0103848:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010384b:	74 24                	je     c0103871 <check_pgdir+0x195>
c010384d:	c7 44 24 0c 9d 6a 10 	movl   $0xc0106a9d,0xc(%esp)
c0103854:	c0 
c0103855:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c010385c:	c0 
c010385d:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0103864:	00 
c0103865:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c010386c:	e8 b5 cb ff ff       	call   c0100426 <__panic>
    assert(page_ref(p1) == 1);
c0103871:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103874:	89 04 24             	mov    %eax,(%esp)
c0103877:	e8 1c f2 ff ff       	call   c0102a98 <page_ref>
c010387c:	83 f8 01             	cmp    $0x1,%eax
c010387f:	74 24                	je     c01038a5 <check_pgdir+0x1c9>
c0103881:	c7 44 24 0c b3 6a 10 	movl   $0xc0106ab3,0xc(%esp)
c0103888:	c0 
c0103889:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103890:	c0 
c0103891:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0103898:	00 
c0103899:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c01038a0:	e8 81 cb ff ff       	call   c0100426 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01038a5:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01038aa:	8b 00                	mov    (%eax),%eax
c01038ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01038b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038b7:	c1 e8 0c             	shr    $0xc,%eax
c01038ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01038bd:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01038c2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01038c5:	72 23                	jb     c01038ea <check_pgdir+0x20e>
c01038c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01038ce:	c7 44 24 08 80 68 10 	movl   $0xc0106880,0x8(%esp)
c01038d5:	c0 
c01038d6:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c01038dd:	00 
c01038de:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c01038e5:	e8 3c cb ff ff       	call   c0100426 <__panic>
c01038ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038ed:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01038f2:	83 c0 04             	add    $0x4,%eax
c01038f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01038f8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01038fd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103904:	00 
c0103905:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010390c:	00 
c010390d:	89 04 24             	mov    %eax,(%esp)
c0103910:	e8 41 fa ff ff       	call   c0103356 <get_pte>
c0103915:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103918:	74 24                	je     c010393e <check_pgdir+0x262>
c010391a:	c7 44 24 0c c8 6a 10 	movl   $0xc0106ac8,0xc(%esp)
c0103921:	c0 
c0103922:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103929:	c0 
c010392a:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0103931:	00 
c0103932:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103939:	e8 e8 ca ff ff       	call   c0100426 <__panic>

    p2 = alloc_page();
c010393e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103945:	e8 64 f3 ff ff       	call   c0102cae <alloc_pages>
c010394a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010394d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103952:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103959:	00 
c010395a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103961:	00 
c0103962:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103965:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103969:	89 04 24             	mov    %eax,(%esp)
c010396c:	e8 2a fc ff ff       	call   c010359b <page_insert>
c0103971:	85 c0                	test   %eax,%eax
c0103973:	74 24                	je     c0103999 <check_pgdir+0x2bd>
c0103975:	c7 44 24 0c f0 6a 10 	movl   $0xc0106af0,0xc(%esp)
c010397c:	c0 
c010397d:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103984:	c0 
c0103985:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c010398c:	00 
c010398d:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103994:	e8 8d ca ff ff       	call   c0100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103999:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010399e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039a5:	00 
c01039a6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01039ad:	00 
c01039ae:	89 04 24             	mov    %eax,(%esp)
c01039b1:	e8 a0 f9 ff ff       	call   c0103356 <get_pte>
c01039b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039bd:	75 24                	jne    c01039e3 <check_pgdir+0x307>
c01039bf:	c7 44 24 0c 28 6b 10 	movl   $0xc0106b28,0xc(%esp)
c01039c6:	c0 
c01039c7:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c01039ce:	c0 
c01039cf:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c01039d6:	00 
c01039d7:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c01039de:	e8 43 ca ff ff       	call   c0100426 <__panic>
    assert(*ptep & PTE_U);
c01039e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039e6:	8b 00                	mov    (%eax),%eax
c01039e8:	83 e0 04             	and    $0x4,%eax
c01039eb:	85 c0                	test   %eax,%eax
c01039ed:	75 24                	jne    c0103a13 <check_pgdir+0x337>
c01039ef:	c7 44 24 0c 58 6b 10 	movl   $0xc0106b58,0xc(%esp)
c01039f6:	c0 
c01039f7:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c01039fe:	c0 
c01039ff:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103a06:	00 
c0103a07:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103a0e:	e8 13 ca ff ff       	call   c0100426 <__panic>
    assert(*ptep & PTE_W);
c0103a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a16:	8b 00                	mov    (%eax),%eax
c0103a18:	83 e0 02             	and    $0x2,%eax
c0103a1b:	85 c0                	test   %eax,%eax
c0103a1d:	75 24                	jne    c0103a43 <check_pgdir+0x367>
c0103a1f:	c7 44 24 0c 66 6b 10 	movl   $0xc0106b66,0xc(%esp)
c0103a26:	c0 
c0103a27:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103a2e:	c0 
c0103a2f:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0103a36:	00 
c0103a37:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103a3e:	e8 e3 c9 ff ff       	call   c0100426 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103a43:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103a48:	8b 00                	mov    (%eax),%eax
c0103a4a:	83 e0 04             	and    $0x4,%eax
c0103a4d:	85 c0                	test   %eax,%eax
c0103a4f:	75 24                	jne    c0103a75 <check_pgdir+0x399>
c0103a51:	c7 44 24 0c 74 6b 10 	movl   $0xc0106b74,0xc(%esp)
c0103a58:	c0 
c0103a59:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103a60:	c0 
c0103a61:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0103a68:	00 
c0103a69:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103a70:	e8 b1 c9 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p2) == 1);
c0103a75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a78:	89 04 24             	mov    %eax,(%esp)
c0103a7b:	e8 18 f0 ff ff       	call   c0102a98 <page_ref>
c0103a80:	83 f8 01             	cmp    $0x1,%eax
c0103a83:	74 24                	je     c0103aa9 <check_pgdir+0x3cd>
c0103a85:	c7 44 24 0c 8a 6b 10 	movl   $0xc0106b8a,0xc(%esp)
c0103a8c:	c0 
c0103a8d:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103a94:	c0 
c0103a95:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0103a9c:	00 
c0103a9d:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103aa4:	e8 7d c9 ff ff       	call   c0100426 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103aa9:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103aae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103ab5:	00 
c0103ab6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103abd:	00 
c0103abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ac1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ac5:	89 04 24             	mov    %eax,(%esp)
c0103ac8:	e8 ce fa ff ff       	call   c010359b <page_insert>
c0103acd:	85 c0                	test   %eax,%eax
c0103acf:	74 24                	je     c0103af5 <check_pgdir+0x419>
c0103ad1:	c7 44 24 0c 9c 6b 10 	movl   $0xc0106b9c,0xc(%esp)
c0103ad8:	c0 
c0103ad9:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103ae0:	c0 
c0103ae1:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0103ae8:	00 
c0103ae9:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103af0:	e8 31 c9 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p1) == 2);
c0103af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103af8:	89 04 24             	mov    %eax,(%esp)
c0103afb:	e8 98 ef ff ff       	call   c0102a98 <page_ref>
c0103b00:	83 f8 02             	cmp    $0x2,%eax
c0103b03:	74 24                	je     c0103b29 <check_pgdir+0x44d>
c0103b05:	c7 44 24 0c c8 6b 10 	movl   $0xc0106bc8,0xc(%esp)
c0103b0c:	c0 
c0103b0d:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103b14:	c0 
c0103b15:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103b1c:	00 
c0103b1d:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103b24:	e8 fd c8 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p2) == 0);
c0103b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b2c:	89 04 24             	mov    %eax,(%esp)
c0103b2f:	e8 64 ef ff ff       	call   c0102a98 <page_ref>
c0103b34:	85 c0                	test   %eax,%eax
c0103b36:	74 24                	je     c0103b5c <check_pgdir+0x480>
c0103b38:	c7 44 24 0c da 6b 10 	movl   $0xc0106bda,0xc(%esp)
c0103b3f:	c0 
c0103b40:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103b47:	c0 
c0103b48:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0103b4f:	00 
c0103b50:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103b57:	e8 ca c8 ff ff       	call   c0100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103b5c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b61:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103b68:	00 
c0103b69:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103b70:	00 
c0103b71:	89 04 24             	mov    %eax,(%esp)
c0103b74:	e8 dd f7 ff ff       	call   c0103356 <get_pte>
c0103b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b80:	75 24                	jne    c0103ba6 <check_pgdir+0x4ca>
c0103b82:	c7 44 24 0c 28 6b 10 	movl   $0xc0106b28,0xc(%esp)
c0103b89:	c0 
c0103b8a:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103b91:	c0 
c0103b92:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0103b99:	00 
c0103b9a:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103ba1:	e8 80 c8 ff ff       	call   c0100426 <__panic>
    assert(pte2page(*ptep) == p1);
c0103ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ba9:	8b 00                	mov    (%eax),%eax
c0103bab:	89 04 24             	mov    %eax,(%esp)
c0103bae:	e8 8f ee ff ff       	call   c0102a42 <pte2page>
c0103bb3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103bb6:	74 24                	je     c0103bdc <check_pgdir+0x500>
c0103bb8:	c7 44 24 0c 9d 6a 10 	movl   $0xc0106a9d,0xc(%esp)
c0103bbf:	c0 
c0103bc0:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103bc7:	c0 
c0103bc8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0103bcf:	00 
c0103bd0:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103bd7:	e8 4a c8 ff ff       	call   c0100426 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bdf:	8b 00                	mov    (%eax),%eax
c0103be1:	83 e0 04             	and    $0x4,%eax
c0103be4:	85 c0                	test   %eax,%eax
c0103be6:	74 24                	je     c0103c0c <check_pgdir+0x530>
c0103be8:	c7 44 24 0c ec 6b 10 	movl   $0xc0106bec,0xc(%esp)
c0103bef:	c0 
c0103bf0:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103bf7:	c0 
c0103bf8:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0103bff:	00 
c0103c00:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103c07:	e8 1a c8 ff ff       	call   c0100426 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103c0c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c11:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103c18:	00 
c0103c19:	89 04 24             	mov    %eax,(%esp)
c0103c1c:	e8 31 f9 ff ff       	call   c0103552 <page_remove>
    assert(page_ref(p1) == 1);
c0103c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c24:	89 04 24             	mov    %eax,(%esp)
c0103c27:	e8 6c ee ff ff       	call   c0102a98 <page_ref>
c0103c2c:	83 f8 01             	cmp    $0x1,%eax
c0103c2f:	74 24                	je     c0103c55 <check_pgdir+0x579>
c0103c31:	c7 44 24 0c b3 6a 10 	movl   $0xc0106ab3,0xc(%esp)
c0103c38:	c0 
c0103c39:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103c40:	c0 
c0103c41:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0103c48:	00 
c0103c49:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103c50:	e8 d1 c7 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p2) == 0);
c0103c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c58:	89 04 24             	mov    %eax,(%esp)
c0103c5b:	e8 38 ee ff ff       	call   c0102a98 <page_ref>
c0103c60:	85 c0                	test   %eax,%eax
c0103c62:	74 24                	je     c0103c88 <check_pgdir+0x5ac>
c0103c64:	c7 44 24 0c da 6b 10 	movl   $0xc0106bda,0xc(%esp)
c0103c6b:	c0 
c0103c6c:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103c73:	c0 
c0103c74:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0103c7b:	00 
c0103c7c:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103c83:	e8 9e c7 ff ff       	call   c0100426 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103c88:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c8d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103c94:	00 
c0103c95:	89 04 24             	mov    %eax,(%esp)
c0103c98:	e8 b5 f8 ff ff       	call   c0103552 <page_remove>
    assert(page_ref(p1) == 0);
c0103c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ca0:	89 04 24             	mov    %eax,(%esp)
c0103ca3:	e8 f0 ed ff ff       	call   c0102a98 <page_ref>
c0103ca8:	85 c0                	test   %eax,%eax
c0103caa:	74 24                	je     c0103cd0 <check_pgdir+0x5f4>
c0103cac:	c7 44 24 0c 01 6c 10 	movl   $0xc0106c01,0xc(%esp)
c0103cb3:	c0 
c0103cb4:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103cbb:	c0 
c0103cbc:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0103cc3:	00 
c0103cc4:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103ccb:	e8 56 c7 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p2) == 0);
c0103cd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cd3:	89 04 24             	mov    %eax,(%esp)
c0103cd6:	e8 bd ed ff ff       	call   c0102a98 <page_ref>
c0103cdb:	85 c0                	test   %eax,%eax
c0103cdd:	74 24                	je     c0103d03 <check_pgdir+0x627>
c0103cdf:	c7 44 24 0c da 6b 10 	movl   $0xc0106bda,0xc(%esp)
c0103ce6:	c0 
c0103ce7:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103cee:	c0 
c0103cef:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103cf6:	00 
c0103cf7:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103cfe:	e8 23 c7 ff ff       	call   c0100426 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103d03:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d08:	8b 00                	mov    (%eax),%eax
c0103d0a:	89 04 24             	mov    %eax,(%esp)
c0103d0d:	e8 6e ed ff ff       	call   c0102a80 <pde2page>
c0103d12:	89 04 24             	mov    %eax,(%esp)
c0103d15:	e8 7e ed ff ff       	call   c0102a98 <page_ref>
c0103d1a:	83 f8 01             	cmp    $0x1,%eax
c0103d1d:	74 24                	je     c0103d43 <check_pgdir+0x667>
c0103d1f:	c7 44 24 0c 14 6c 10 	movl   $0xc0106c14,0xc(%esp)
c0103d26:	c0 
c0103d27:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103d2e:	c0 
c0103d2f:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0103d36:	00 
c0103d37:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103d3e:	e8 e3 c6 ff ff       	call   c0100426 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103d43:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d48:	8b 00                	mov    (%eax),%eax
c0103d4a:	89 04 24             	mov    %eax,(%esp)
c0103d4d:	e8 2e ed ff ff       	call   c0102a80 <pde2page>
c0103d52:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d59:	00 
c0103d5a:	89 04 24             	mov    %eax,(%esp)
c0103d5d:	e8 88 ef ff ff       	call   c0102cea <free_pages>
    boot_pgdir[0] = 0;
c0103d62:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103d6d:	c7 04 24 3b 6c 10 c0 	movl   $0xc0106c3b,(%esp)
c0103d74:	e8 41 c5 ff ff       	call   c01002ba <cprintf>
}
c0103d79:	90                   	nop
c0103d7a:	c9                   	leave  
c0103d7b:	c3                   	ret    

c0103d7c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103d7c:	f3 0f 1e fb          	endbr32 
c0103d80:	55                   	push   %ebp
c0103d81:	89 e5                	mov    %esp,%ebp
c0103d83:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103d86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103d8d:	e9 ca 00 00 00       	jmp    c0103e5c <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d9b:	c1 e8 0c             	shr    $0xc,%eax
c0103d9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103da1:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103da6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103da9:	72 23                	jb     c0103dce <check_boot_pgdir+0x52>
c0103dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dae:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103db2:	c7 44 24 08 80 68 10 	movl   $0xc0106880,0x8(%esp)
c0103db9:	c0 
c0103dba:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0103dc1:	00 
c0103dc2:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103dc9:	e8 58 c6 ff ff       	call   c0100426 <__panic>
c0103dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dd1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103dd6:	89 c2                	mov    %eax,%edx
c0103dd8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103ddd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103de4:	00 
c0103de5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103de9:	89 04 24             	mov    %eax,(%esp)
c0103dec:	e8 65 f5 ff ff       	call   c0103356 <get_pte>
c0103df1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103df4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103df8:	75 24                	jne    c0103e1e <check_boot_pgdir+0xa2>
c0103dfa:	c7 44 24 0c 58 6c 10 	movl   $0xc0106c58,0xc(%esp)
c0103e01:	c0 
c0103e02:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103e09:	c0 
c0103e0a:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0103e11:	00 
c0103e12:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103e19:	e8 08 c6 ff ff       	call   c0100426 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103e1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e21:	8b 00                	mov    (%eax),%eax
c0103e23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e28:	89 c2                	mov    %eax,%edx
c0103e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e2d:	39 c2                	cmp    %eax,%edx
c0103e2f:	74 24                	je     c0103e55 <check_boot_pgdir+0xd9>
c0103e31:	c7 44 24 0c 95 6c 10 	movl   $0xc0106c95,0xc(%esp)
c0103e38:	c0 
c0103e39:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103e40:	c0 
c0103e41:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0103e48:	00 
c0103e49:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103e50:	e8 d1 c5 ff ff       	call   c0100426 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103e55:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e5f:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103e64:	39 c2                	cmp    %eax,%edx
c0103e66:	0f 82 26 ff ff ff    	jb     c0103d92 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103e6c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e71:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103e76:	8b 00                	mov    (%eax),%eax
c0103e78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e7d:	89 c2                	mov    %eax,%edx
c0103e7f:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e87:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103e8e:	77 23                	ja     c0103eb3 <check_boot_pgdir+0x137>
c0103e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e93:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e97:	c7 44 24 08 24 69 10 	movl   $0xc0106924,0x8(%esp)
c0103e9e:	c0 
c0103e9f:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0103ea6:	00 
c0103ea7:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103eae:	e8 73 c5 ff ff       	call   c0100426 <__panic>
c0103eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103eb6:	05 00 00 00 40       	add    $0x40000000,%eax
c0103ebb:	39 d0                	cmp    %edx,%eax
c0103ebd:	74 24                	je     c0103ee3 <check_boot_pgdir+0x167>
c0103ebf:	c7 44 24 0c ac 6c 10 	movl   $0xc0106cac,0xc(%esp)
c0103ec6:	c0 
c0103ec7:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103ece:	c0 
c0103ecf:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0103ed6:	00 
c0103ed7:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103ede:	e8 43 c5 ff ff       	call   c0100426 <__panic>

    assert(boot_pgdir[0] == 0);
c0103ee3:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103ee8:	8b 00                	mov    (%eax),%eax
c0103eea:	85 c0                	test   %eax,%eax
c0103eec:	74 24                	je     c0103f12 <check_boot_pgdir+0x196>
c0103eee:	c7 44 24 0c e0 6c 10 	movl   $0xc0106ce0,0xc(%esp)
c0103ef5:	c0 
c0103ef6:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103efd:	c0 
c0103efe:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0103f05:	00 
c0103f06:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103f0d:	e8 14 c5 ff ff       	call   c0100426 <__panic>

    struct Page *p;
    p = alloc_page();
c0103f12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f19:	e8 90 ed ff ff       	call   c0102cae <alloc_pages>
c0103f1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103f21:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103f26:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103f2d:	00 
c0103f2e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103f35:	00 
c0103f36:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103f39:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f3d:	89 04 24             	mov    %eax,(%esp)
c0103f40:	e8 56 f6 ff ff       	call   c010359b <page_insert>
c0103f45:	85 c0                	test   %eax,%eax
c0103f47:	74 24                	je     c0103f6d <check_boot_pgdir+0x1f1>
c0103f49:	c7 44 24 0c f4 6c 10 	movl   $0xc0106cf4,0xc(%esp)
c0103f50:	c0 
c0103f51:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103f58:	c0 
c0103f59:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0103f60:	00 
c0103f61:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103f68:	e8 b9 c4 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p) == 1);
c0103f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f70:	89 04 24             	mov    %eax,(%esp)
c0103f73:	e8 20 eb ff ff       	call   c0102a98 <page_ref>
c0103f78:	83 f8 01             	cmp    $0x1,%eax
c0103f7b:	74 24                	je     c0103fa1 <check_boot_pgdir+0x225>
c0103f7d:	c7 44 24 0c 22 6d 10 	movl   $0xc0106d22,0xc(%esp)
c0103f84:	c0 
c0103f85:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103f8c:	c0 
c0103f8d:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0103f94:	00 
c0103f95:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103f9c:	e8 85 c4 ff ff       	call   c0100426 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103fa1:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103fa6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103fad:	00 
c0103fae:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0103fb5:	00 
c0103fb6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103fb9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fbd:	89 04 24             	mov    %eax,(%esp)
c0103fc0:	e8 d6 f5 ff ff       	call   c010359b <page_insert>
c0103fc5:	85 c0                	test   %eax,%eax
c0103fc7:	74 24                	je     c0103fed <check_boot_pgdir+0x271>
c0103fc9:	c7 44 24 0c 34 6d 10 	movl   $0xc0106d34,0xc(%esp)
c0103fd0:	c0 
c0103fd1:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0103fd8:	c0 
c0103fd9:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0103fe0:	00 
c0103fe1:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0103fe8:	e8 39 c4 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p) == 2);
c0103fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ff0:	89 04 24             	mov    %eax,(%esp)
c0103ff3:	e8 a0 ea ff ff       	call   c0102a98 <page_ref>
c0103ff8:	83 f8 02             	cmp    $0x2,%eax
c0103ffb:	74 24                	je     c0104021 <check_boot_pgdir+0x2a5>
c0103ffd:	c7 44 24 0c 6b 6d 10 	movl   $0xc0106d6b,0xc(%esp)
c0104004:	c0 
c0104005:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c010400c:	c0 
c010400d:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104014:	00 
c0104015:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c010401c:	e8 05 c4 ff ff       	call   c0100426 <__panic>

    const char *str = "ucore: Hello world!!";
c0104021:	c7 45 e8 7c 6d 10 c0 	movl   $0xc0106d7c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0104028:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010402b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010402f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104036:	e8 db 15 00 00       	call   c0105616 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010403b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104042:	00 
c0104043:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010404a:	e8 45 16 00 00       	call   c0105694 <strcmp>
c010404f:	85 c0                	test   %eax,%eax
c0104051:	74 24                	je     c0104077 <check_boot_pgdir+0x2fb>
c0104053:	c7 44 24 0c 94 6d 10 	movl   $0xc0106d94,0xc(%esp)
c010405a:	c0 
c010405b:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c0104062:	c0 
c0104063:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c010406a:	00 
c010406b:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0104072:	e8 af c3 ff ff       	call   c0100426 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104077:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010407a:	89 04 24             	mov    %eax,(%esp)
c010407d:	e8 6c e9 ff ff       	call   c01029ee <page2kva>
c0104082:	05 00 01 00 00       	add    $0x100,%eax
c0104087:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010408a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104091:	e8 22 15 00 00       	call   c01055b8 <strlen>
c0104096:	85 c0                	test   %eax,%eax
c0104098:	74 24                	je     c01040be <check_boot_pgdir+0x342>
c010409a:	c7 44 24 0c cc 6d 10 	movl   $0xc0106dcc,0xc(%esp)
c01040a1:	c0 
c01040a2:	c7 44 24 08 6d 69 10 	movl   $0xc010696d,0x8(%esp)
c01040a9:	c0 
c01040aa:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c01040b1:	00 
c01040b2:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c01040b9:	e8 68 c3 ff ff       	call   c0100426 <__panic>

    free_page(p);
c01040be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040c5:	00 
c01040c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040c9:	89 04 24             	mov    %eax,(%esp)
c01040cc:	e8 19 ec ff ff       	call   c0102cea <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c01040d1:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01040d6:	8b 00                	mov    (%eax),%eax
c01040d8:	89 04 24             	mov    %eax,(%esp)
c01040db:	e8 a0 e9 ff ff       	call   c0102a80 <pde2page>
c01040e0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040e7:	00 
c01040e8:	89 04 24             	mov    %eax,(%esp)
c01040eb:	e8 fa eb ff ff       	call   c0102cea <free_pages>
    boot_pgdir[0] = 0;
c01040f0:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01040f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01040fb:	c7 04 24 f0 6d 10 c0 	movl   $0xc0106df0,(%esp)
c0104102:	e8 b3 c1 ff ff       	call   c01002ba <cprintf>
}
c0104107:	90                   	nop
c0104108:	c9                   	leave  
c0104109:	c3                   	ret    

c010410a <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010410a:	f3 0f 1e fb          	endbr32 
c010410e:	55                   	push   %ebp
c010410f:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104111:	8b 45 08             	mov    0x8(%ebp),%eax
c0104114:	83 e0 04             	and    $0x4,%eax
c0104117:	85 c0                	test   %eax,%eax
c0104119:	74 04                	je     c010411f <perm2str+0x15>
c010411b:	b0 75                	mov    $0x75,%al
c010411d:	eb 02                	jmp    c0104121 <perm2str+0x17>
c010411f:	b0 2d                	mov    $0x2d,%al
c0104121:	a2 08 cf 11 c0       	mov    %al,0xc011cf08
    str[1] = 'r';
c0104126:	c6 05 09 cf 11 c0 72 	movb   $0x72,0xc011cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010412d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104130:	83 e0 02             	and    $0x2,%eax
c0104133:	85 c0                	test   %eax,%eax
c0104135:	74 04                	je     c010413b <perm2str+0x31>
c0104137:	b0 77                	mov    $0x77,%al
c0104139:	eb 02                	jmp    c010413d <perm2str+0x33>
c010413b:	b0 2d                	mov    $0x2d,%al
c010413d:	a2 0a cf 11 c0       	mov    %al,0xc011cf0a
    str[3] = '\0';
c0104142:	c6 05 0b cf 11 c0 00 	movb   $0x0,0xc011cf0b
    return str;
c0104149:	b8 08 cf 11 c0       	mov    $0xc011cf08,%eax
}
c010414e:	5d                   	pop    %ebp
c010414f:	c3                   	ret    

c0104150 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104150:	f3 0f 1e fb          	endbr32 
c0104154:	55                   	push   %ebp
c0104155:	89 e5                	mov    %esp,%ebp
c0104157:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010415a:	8b 45 10             	mov    0x10(%ebp),%eax
c010415d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104160:	72 0d                	jb     c010416f <get_pgtable_items+0x1f>
        return 0;
c0104162:	b8 00 00 00 00       	mov    $0x0,%eax
c0104167:	e9 98 00 00 00       	jmp    c0104204 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c010416c:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c010416f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104172:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104175:	73 18                	jae    c010418f <get_pgtable_items+0x3f>
c0104177:	8b 45 10             	mov    0x10(%ebp),%eax
c010417a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104181:	8b 45 14             	mov    0x14(%ebp),%eax
c0104184:	01 d0                	add    %edx,%eax
c0104186:	8b 00                	mov    (%eax),%eax
c0104188:	83 e0 01             	and    $0x1,%eax
c010418b:	85 c0                	test   %eax,%eax
c010418d:	74 dd                	je     c010416c <get_pgtable_items+0x1c>
    }
    if (start < right) {
c010418f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104192:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104195:	73 68                	jae    c01041ff <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0104197:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010419b:	74 08                	je     c01041a5 <get_pgtable_items+0x55>
            *left_store = start;
c010419d:	8b 45 18             	mov    0x18(%ebp),%eax
c01041a0:	8b 55 10             	mov    0x10(%ebp),%edx
c01041a3:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01041a5:	8b 45 10             	mov    0x10(%ebp),%eax
c01041a8:	8d 50 01             	lea    0x1(%eax),%edx
c01041ab:	89 55 10             	mov    %edx,0x10(%ebp)
c01041ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01041b5:	8b 45 14             	mov    0x14(%ebp),%eax
c01041b8:	01 d0                	add    %edx,%eax
c01041ba:	8b 00                	mov    (%eax),%eax
c01041bc:	83 e0 07             	and    $0x7,%eax
c01041bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01041c2:	eb 03                	jmp    c01041c7 <get_pgtable_items+0x77>
            start ++;
c01041c4:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01041c7:	8b 45 10             	mov    0x10(%ebp),%eax
c01041ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01041cd:	73 1d                	jae    c01041ec <get_pgtable_items+0x9c>
c01041cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01041d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01041d9:	8b 45 14             	mov    0x14(%ebp),%eax
c01041dc:	01 d0                	add    %edx,%eax
c01041de:	8b 00                	mov    (%eax),%eax
c01041e0:	83 e0 07             	and    $0x7,%eax
c01041e3:	89 c2                	mov    %eax,%edx
c01041e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041e8:	39 c2                	cmp    %eax,%edx
c01041ea:	74 d8                	je     c01041c4 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
c01041ec:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01041f0:	74 08                	je     c01041fa <get_pgtable_items+0xaa>
            *right_store = start;
c01041f2:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01041f5:	8b 55 10             	mov    0x10(%ebp),%edx
c01041f8:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01041fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041fd:	eb 05                	jmp    c0104204 <get_pgtable_items+0xb4>
    }
    return 0;
c01041ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104204:	c9                   	leave  
c0104205:	c3                   	ret    

c0104206 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104206:	f3 0f 1e fb          	endbr32 
c010420a:	55                   	push   %ebp
c010420b:	89 e5                	mov    %esp,%ebp
c010420d:	57                   	push   %edi
c010420e:	56                   	push   %esi
c010420f:	53                   	push   %ebx
c0104210:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104213:	c7 04 24 10 6e 10 c0 	movl   $0xc0106e10,(%esp)
c010421a:	e8 9b c0 ff ff       	call   c01002ba <cprintf>
    size_t left, right = 0, perm;
c010421f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104226:	e9 fa 00 00 00       	jmp    c0104325 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010422b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010422e:	89 04 24             	mov    %eax,(%esp)
c0104231:	e8 d4 fe ff ff       	call   c010410a <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104236:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104239:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010423c:	29 d1                	sub    %edx,%ecx
c010423e:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104240:	89 d6                	mov    %edx,%esi
c0104242:	c1 e6 16             	shl    $0x16,%esi
c0104245:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104248:	89 d3                	mov    %edx,%ebx
c010424a:	c1 e3 16             	shl    $0x16,%ebx
c010424d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104250:	89 d1                	mov    %edx,%ecx
c0104252:	c1 e1 16             	shl    $0x16,%ecx
c0104255:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104258:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010425b:	29 d7                	sub    %edx,%edi
c010425d:	89 fa                	mov    %edi,%edx
c010425f:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104263:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104267:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010426b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010426f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104273:	c7 04 24 41 6e 10 c0 	movl   $0xc0106e41,(%esp)
c010427a:	e8 3b c0 ff ff       	call   c01002ba <cprintf>
        size_t l, r = left * NPTEENTRY;
c010427f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104282:	c1 e0 0a             	shl    $0xa,%eax
c0104285:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104288:	eb 54                	jmp    c01042de <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010428a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010428d:	89 04 24             	mov    %eax,(%esp)
c0104290:	e8 75 fe ff ff       	call   c010410a <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104295:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104298:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010429b:	29 d1                	sub    %edx,%ecx
c010429d:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010429f:	89 d6                	mov    %edx,%esi
c01042a1:	c1 e6 0c             	shl    $0xc,%esi
c01042a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042a7:	89 d3                	mov    %edx,%ebx
c01042a9:	c1 e3 0c             	shl    $0xc,%ebx
c01042ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042af:	89 d1                	mov    %edx,%ecx
c01042b1:	c1 e1 0c             	shl    $0xc,%ecx
c01042b4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01042b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042ba:	29 d7                	sub    %edx,%edi
c01042bc:	89 fa                	mov    %edi,%edx
c01042be:	89 44 24 14          	mov    %eax,0x14(%esp)
c01042c2:	89 74 24 10          	mov    %esi,0x10(%esp)
c01042c6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01042ca:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01042ce:	89 54 24 04          	mov    %edx,0x4(%esp)
c01042d2:	c7 04 24 60 6e 10 c0 	movl   $0xc0106e60,(%esp)
c01042d9:	e8 dc bf ff ff       	call   c01002ba <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01042de:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01042e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01042e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042e9:	89 d3                	mov    %edx,%ebx
c01042eb:	c1 e3 0a             	shl    $0xa,%ebx
c01042ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042f1:	89 d1                	mov    %edx,%ecx
c01042f3:	c1 e1 0a             	shl    $0xa,%ecx
c01042f6:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01042f9:	89 54 24 14          	mov    %edx,0x14(%esp)
c01042fd:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104300:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104304:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0104308:	89 44 24 08          	mov    %eax,0x8(%esp)
c010430c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104310:	89 0c 24             	mov    %ecx,(%esp)
c0104313:	e8 38 fe ff ff       	call   c0104150 <get_pgtable_items>
c0104318:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010431b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010431f:	0f 85 65 ff ff ff    	jne    c010428a <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104325:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010432a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010432d:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104330:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104334:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104337:	89 54 24 10          	mov    %edx,0x10(%esp)
c010433b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010433f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104343:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010434a:	00 
c010434b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104352:	e8 f9 fd ff ff       	call   c0104150 <get_pgtable_items>
c0104357:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010435a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010435e:	0f 85 c7 fe ff ff    	jne    c010422b <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104364:	c7 04 24 84 6e 10 c0 	movl   $0xc0106e84,(%esp)
c010436b:	e8 4a bf ff ff       	call   c01002ba <cprintf>
}
c0104370:	90                   	nop
c0104371:	83 c4 4c             	add    $0x4c,%esp
c0104374:	5b                   	pop    %ebx
c0104375:	5e                   	pop    %esi
c0104376:	5f                   	pop    %edi
c0104377:	5d                   	pop    %ebp
c0104378:	c3                   	ret    

c0104379 <page2ppn>:
page2ppn(struct Page *page) {
c0104379:	55                   	push   %ebp
c010437a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010437c:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0104381:	8b 55 08             	mov    0x8(%ebp),%edx
c0104384:	29 c2                	sub    %eax,%edx
c0104386:	89 d0                	mov    %edx,%eax
c0104388:	c1 f8 02             	sar    $0x2,%eax
c010438b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104391:	5d                   	pop    %ebp
c0104392:	c3                   	ret    

c0104393 <page2pa>:
page2pa(struct Page *page) {
c0104393:	55                   	push   %ebp
c0104394:	89 e5                	mov    %esp,%ebp
c0104396:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104399:	8b 45 08             	mov    0x8(%ebp),%eax
c010439c:	89 04 24             	mov    %eax,(%esp)
c010439f:	e8 d5 ff ff ff       	call   c0104379 <page2ppn>
c01043a4:	c1 e0 0c             	shl    $0xc,%eax
}
c01043a7:	c9                   	leave  
c01043a8:	c3                   	ret    

c01043a9 <page_ref>:
page_ref(struct Page *page) {
c01043a9:	55                   	push   %ebp
c01043aa:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01043ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01043af:	8b 00                	mov    (%eax),%eax
}
c01043b1:	5d                   	pop    %ebp
c01043b2:	c3                   	ret    

c01043b3 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01043b3:	55                   	push   %ebp
c01043b4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01043b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01043b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043bc:	89 10                	mov    %edx,(%eax)
}
c01043be:	90                   	nop
c01043bf:	5d                   	pop    %ebp
c01043c0:	c3                   	ret    

c01043c1 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01043c1:	f3 0f 1e fb          	endbr32 
c01043c5:	55                   	push   %ebp
c01043c6:	89 e5                	mov    %esp,%ebp
c01043c8:	83 ec 10             	sub    $0x10,%esp
c01043cb:	c7 45 fc 1c cf 11 c0 	movl   $0xc011cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01043d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01043d8:	89 50 04             	mov    %edx,0x4(%eax)
c01043db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043de:	8b 50 04             	mov    0x4(%eax),%edx
c01043e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043e4:	89 10                	mov    %edx,(%eax)
}
c01043e6:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01043e7:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c01043ee:	00 00 00 
}
c01043f1:	90                   	nop
c01043f2:	c9                   	leave  
c01043f3:	c3                   	ret    

c01043f4 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01043f4:	f3 0f 1e fb          	endbr32 
c01043f8:	55                   	push   %ebp
c01043f9:	89 e5                	mov    %esp,%ebp
c01043fb:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01043fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104402:	75 24                	jne    c0104428 <default_init_memmap+0x34>
c0104404:	c7 44 24 0c b8 6e 10 	movl   $0xc0106eb8,0xc(%esp)
c010440b:	c0 
c010440c:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104413:	c0 
c0104414:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010441b:	00 
c010441c:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104423:	e8 fe bf ff ff       	call   c0100426 <__panic>
    struct Page *p = base;
c0104428:	8b 45 08             	mov    0x8(%ebp),%eax
c010442b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010442e:	eb 7d                	jmp    c01044ad <default_init_memmap+0xb9>
        assert(PageReserved(p));
c0104430:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104433:	83 c0 04             	add    $0x4,%eax
c0104436:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010443d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104440:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104443:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104446:	0f a3 10             	bt     %edx,(%eax)
c0104449:	19 c0                	sbb    %eax,%eax
c010444b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010444e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104452:	0f 95 c0             	setne  %al
c0104455:	0f b6 c0             	movzbl %al,%eax
c0104458:	85 c0                	test   %eax,%eax
c010445a:	75 24                	jne    c0104480 <default_init_memmap+0x8c>
c010445c:	c7 44 24 0c e9 6e 10 	movl   $0xc0106ee9,0xc(%esp)
c0104463:	c0 
c0104464:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c010446b:	c0 
c010446c:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104473:	00 
c0104474:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c010447b:	e8 a6 bf ff ff       	call   c0100426 <__panic>
        p->flags = p->property = 0;
c0104480:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104483:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010448a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010448d:	8b 50 08             	mov    0x8(%eax),%edx
c0104490:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104493:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0104496:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010449d:	00 
c010449e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044a1:	89 04 24             	mov    %eax,(%esp)
c01044a4:	e8 0a ff ff ff       	call   c01043b3 <set_page_ref>
    for (; p != base + n; p ++) {
c01044a9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01044ad:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044b0:	89 d0                	mov    %edx,%eax
c01044b2:	c1 e0 02             	shl    $0x2,%eax
c01044b5:	01 d0                	add    %edx,%eax
c01044b7:	c1 e0 02             	shl    $0x2,%eax
c01044ba:	89 c2                	mov    %eax,%edx
c01044bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01044bf:	01 d0                	add    %edx,%eax
c01044c1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01044c4:	0f 85 66 ff ff ff    	jne    c0104430 <default_init_memmap+0x3c>
    }
    base->property = n;
c01044ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01044cd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044d0:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01044d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d6:	83 c0 04             	add    $0x4,%eax
c01044d9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01044e0:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01044e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01044e6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01044e9:	0f ab 10             	bts    %edx,(%eax)
}
c01044ec:	90                   	nop
    nr_free += n;
c01044ed:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c01044f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044f6:	01 d0                	add    %edx,%eax
c01044f8:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
    list_add_before(&free_list, &(base->page_link));
c01044fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104500:	83 c0 0c             	add    $0xc,%eax
c0104503:	c7 45 e4 1c cf 11 c0 	movl   $0xc011cf1c,-0x1c(%ebp)
c010450a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010450d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104510:	8b 00                	mov    (%eax),%eax
c0104512:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104515:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104518:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010451b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010451e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104521:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104524:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104527:	89 10                	mov    %edx,(%eax)
c0104529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010452c:	8b 10                	mov    (%eax),%edx
c010452e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104531:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104534:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104537:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010453a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010453d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104540:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104543:	89 10                	mov    %edx,(%eax)
}
c0104545:	90                   	nop
}
c0104546:	90                   	nop
}
c0104547:	90                   	nop
c0104548:	c9                   	leave  
c0104549:	c3                   	ret    

c010454a <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c010454a:	f3 0f 1e fb          	endbr32 
c010454e:	55                   	push   %ebp
c010454f:	89 e5                	mov    %esp,%ebp
c0104551:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104554:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104558:	75 24                	jne    c010457e <default_alloc_pages+0x34>
c010455a:	c7 44 24 0c b8 6e 10 	movl   $0xc0106eb8,0xc(%esp)
c0104561:	c0 
c0104562:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104569:	c0 
c010456a:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0104571:	00 
c0104572:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104579:	e8 a8 be ff ff       	call   c0100426 <__panic>
    if (n > nr_free) {
c010457e:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104583:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104586:	76 0a                	jbe    c0104592 <default_alloc_pages+0x48>
        return NULL;
c0104588:	b8 00 00 00 00       	mov    $0x0,%eax
c010458d:	e9 43 01 00 00       	jmp    c01046d5 <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
c0104592:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104599:	c7 45 f0 1c cf 11 c0 	movl   $0xc011cf1c,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c01045a0:	eb 1c                	jmp    c01045be <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
c01045a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a5:	83 e8 0c             	sub    $0xc,%eax
c01045a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01045ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045ae:	8b 40 08             	mov    0x8(%eax),%eax
c01045b1:	39 45 08             	cmp    %eax,0x8(%ebp)
c01045b4:	77 08                	ja     c01045be <default_alloc_pages+0x74>
            page = p;
c01045b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01045bc:	eb 18                	jmp    c01045d6 <default_alloc_pages+0x8c>
c01045be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01045c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045c7:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01045ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045cd:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c01045d4:	75 cc                	jne    c01045a2 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
c01045d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045da:	0f 84 f2 00 00 00    	je     c01046d2 <default_alloc_pages+0x188>
        if (page->property > n) {
c01045e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045e3:	8b 40 08             	mov    0x8(%eax),%eax
c01045e6:	39 45 08             	cmp    %eax,0x8(%ebp)
c01045e9:	0f 83 8f 00 00 00    	jae    c010467e <default_alloc_pages+0x134>
            struct Page *p = page + n;
c01045ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01045f2:	89 d0                	mov    %edx,%eax
c01045f4:	c1 e0 02             	shl    $0x2,%eax
c01045f7:	01 d0                	add    %edx,%eax
c01045f9:	c1 e0 02             	shl    $0x2,%eax
c01045fc:	89 c2                	mov    %eax,%edx
c01045fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104601:	01 d0                	add    %edx,%eax
c0104603:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0104606:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104609:	8b 40 08             	mov    0x8(%eax),%eax
c010460c:	2b 45 08             	sub    0x8(%ebp),%eax
c010460f:	89 c2                	mov    %eax,%edx
c0104611:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104614:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0104617:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010461a:	83 c0 04             	add    $0x4,%eax
c010461d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104624:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104627:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010462a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010462d:	0f ab 10             	bts    %edx,(%eax)
}
c0104630:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
c0104631:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104634:	83 c0 0c             	add    $0xc,%eax
c0104637:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010463a:	83 c2 0c             	add    $0xc,%edx
c010463d:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0104640:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104643:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104646:	8b 40 04             	mov    0x4(%eax),%eax
c0104649:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010464c:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010464f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104652:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104655:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c0104658:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010465b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010465e:	89 10                	mov    %edx,(%eax)
c0104660:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104663:	8b 10                	mov    (%eax),%edx
c0104665:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104668:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010466b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010466e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104671:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104674:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104677:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010467a:	89 10                	mov    %edx,(%eax)
}
c010467c:	90                   	nop
}
c010467d:	90                   	nop
        }
        list_del(&(page->page_link));
c010467e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104681:	83 c0 0c             	add    $0xc,%eax
c0104684:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104687:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010468a:	8b 40 04             	mov    0x4(%eax),%eax
c010468d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104690:	8b 12                	mov    (%edx),%edx
c0104692:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0104695:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104698:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010469b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010469e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01046a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01046a4:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01046a7:	89 10                	mov    %edx,(%eax)
}
c01046a9:	90                   	nop
}
c01046aa:	90                   	nop
        nr_free -= n;
c01046ab:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01046b0:	2b 45 08             	sub    0x8(%ebp),%eax
c01046b3:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
        ClearPageProperty(page);
c01046b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046bb:	83 c0 04             	add    $0x4,%eax
c01046be:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01046c5:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01046c8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01046cb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01046ce:	0f b3 10             	btr    %edx,(%eax)
}
c01046d1:	90                   	nop
    }
    return page;
c01046d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01046d5:	c9                   	leave  
c01046d6:	c3                   	ret    

c01046d7 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01046d7:	f3 0f 1e fb          	endbr32 
c01046db:	55                   	push   %ebp
c01046dc:	89 e5                	mov    %esp,%ebp
c01046de:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c01046e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01046e8:	75 24                	jne    c010470e <default_free_pages+0x37>
c01046ea:	c7 44 24 0c b8 6e 10 	movl   $0xc0106eb8,0xc(%esp)
c01046f1:	c0 
c01046f2:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c01046f9:	c0 
c01046fa:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0104701:	00 
c0104702:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104709:	e8 18 bd ff ff       	call   c0100426 <__panic>
    struct Page *p = base;
c010470e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104711:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104714:	e9 9d 00 00 00       	jmp    c01047b6 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
c0104719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010471c:	83 c0 04             	add    $0x4,%eax
c010471f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104726:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104729:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010472c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010472f:	0f a3 10             	bt     %edx,(%eax)
c0104732:	19 c0                	sbb    %eax,%eax
c0104734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104737:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010473b:	0f 95 c0             	setne  %al
c010473e:	0f b6 c0             	movzbl %al,%eax
c0104741:	85 c0                	test   %eax,%eax
c0104743:	75 2c                	jne    c0104771 <default_free_pages+0x9a>
c0104745:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104748:	83 c0 04             	add    $0x4,%eax
c010474b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104752:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104755:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104758:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010475b:	0f a3 10             	bt     %edx,(%eax)
c010475e:	19 c0                	sbb    %eax,%eax
c0104760:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0104763:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104767:	0f 95 c0             	setne  %al
c010476a:	0f b6 c0             	movzbl %al,%eax
c010476d:	85 c0                	test   %eax,%eax
c010476f:	74 24                	je     c0104795 <default_free_pages+0xbe>
c0104771:	c7 44 24 0c fc 6e 10 	movl   $0xc0106efc,0xc(%esp)
c0104778:	c0 
c0104779:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104780:	c0 
c0104781:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0104788:	00 
c0104789:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104790:	e8 91 bc ff ff       	call   c0100426 <__panic>
        p->flags = 0;
c0104795:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104798:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c010479f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01047a6:	00 
c01047a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047aa:	89 04 24             	mov    %eax,(%esp)
c01047ad:	e8 01 fc ff ff       	call   c01043b3 <set_page_ref>
    for (; p != base + n; p ++) {
c01047b2:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01047b6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047b9:	89 d0                	mov    %edx,%eax
c01047bb:	c1 e0 02             	shl    $0x2,%eax
c01047be:	01 d0                	add    %edx,%eax
c01047c0:	c1 e0 02             	shl    $0x2,%eax
c01047c3:	89 c2                	mov    %eax,%edx
c01047c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c8:	01 d0                	add    %edx,%eax
c01047ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01047cd:	0f 85 46 ff ff ff    	jne    c0104719 <default_free_pages+0x42>
    }
    base->property = n;
c01047d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01047d6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047d9:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01047dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01047df:	83 c0 04             	add    $0x4,%eax
c01047e2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01047e9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01047ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01047ef:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01047f2:	0f ab 10             	bts    %edx,(%eax)
}
c01047f5:	90                   	nop
c01047f6:	c7 45 d4 1c cf 11 c0 	movl   $0xc011cf1c,-0x2c(%ebp)
    return listelm->next;
c01047fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104800:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104803:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104806:	e9 0e 01 00 00       	jmp    c0104919 <default_free_pages+0x242>
        p = le2page(le, page_link);
c010480b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010480e:	83 e8 0c             	sub    $0xc,%eax
c0104811:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104814:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104817:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010481a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010481d:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104820:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0104823:	8b 45 08             	mov    0x8(%ebp),%eax
c0104826:	8b 50 08             	mov    0x8(%eax),%edx
c0104829:	89 d0                	mov    %edx,%eax
c010482b:	c1 e0 02             	shl    $0x2,%eax
c010482e:	01 d0                	add    %edx,%eax
c0104830:	c1 e0 02             	shl    $0x2,%eax
c0104833:	89 c2                	mov    %eax,%edx
c0104835:	8b 45 08             	mov    0x8(%ebp),%eax
c0104838:	01 d0                	add    %edx,%eax
c010483a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010483d:	75 5d                	jne    c010489c <default_free_pages+0x1c5>
            base->property += p->property;
c010483f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104842:	8b 50 08             	mov    0x8(%eax),%edx
c0104845:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104848:	8b 40 08             	mov    0x8(%eax),%eax
c010484b:	01 c2                	add    %eax,%edx
c010484d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104850:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104853:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104856:	83 c0 04             	add    $0x4,%eax
c0104859:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104860:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104863:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104866:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104869:	0f b3 10             	btr    %edx,(%eax)
}
c010486c:	90                   	nop
            list_del(&(p->page_link));
c010486d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104870:	83 c0 0c             	add    $0xc,%eax
c0104873:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104876:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104879:	8b 40 04             	mov    0x4(%eax),%eax
c010487c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010487f:	8b 12                	mov    (%edx),%edx
c0104881:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104884:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0104887:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010488a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010488d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104890:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104893:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104896:	89 10                	mov    %edx,(%eax)
}
c0104898:	90                   	nop
}
c0104899:	90                   	nop
c010489a:	eb 7d                	jmp    c0104919 <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
c010489c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010489f:	8b 50 08             	mov    0x8(%eax),%edx
c01048a2:	89 d0                	mov    %edx,%eax
c01048a4:	c1 e0 02             	shl    $0x2,%eax
c01048a7:	01 d0                	add    %edx,%eax
c01048a9:	c1 e0 02             	shl    $0x2,%eax
c01048ac:	89 c2                	mov    %eax,%edx
c01048ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b1:	01 d0                	add    %edx,%eax
c01048b3:	39 45 08             	cmp    %eax,0x8(%ebp)
c01048b6:	75 61                	jne    c0104919 <default_free_pages+0x242>
            p->property += base->property;
c01048b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048bb:	8b 50 08             	mov    0x8(%eax),%edx
c01048be:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c1:	8b 40 08             	mov    0x8(%eax),%eax
c01048c4:	01 c2                	add    %eax,%edx
c01048c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048c9:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01048cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01048cf:	83 c0 04             	add    $0x4,%eax
c01048d2:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c01048d9:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01048dc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01048df:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01048e2:	0f b3 10             	btr    %edx,(%eax)
}
c01048e5:	90                   	nop
            base = p;
c01048e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048e9:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c01048ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ef:	83 c0 0c             	add    $0xc,%eax
c01048f2:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c01048f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01048f8:	8b 40 04             	mov    0x4(%eax),%eax
c01048fb:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01048fe:	8b 12                	mov    (%edx),%edx
c0104900:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104903:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104906:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104909:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010490c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010490f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104912:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104915:	89 10                	mov    %edx,(%eax)
}
c0104917:	90                   	nop
}
c0104918:	90                   	nop
    while (le != &free_list) {
c0104919:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c0104920:	0f 85 e5 fe ff ff    	jne    c010480b <default_free_pages+0x134>
        }
    }
    nr_free += n;
c0104926:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c010492c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010492f:	01 d0                	add    %edx,%eax
c0104931:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
c0104936:	c7 45 9c 1c cf 11 c0 	movl   $0xc011cf1c,-0x64(%ebp)
    return listelm->next;
c010493d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104940:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0104943:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104946:	eb 74                	jmp    c01049bc <default_free_pages+0x2e5>
        p = le2page(le, page_link);
c0104948:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010494b:	83 e8 0c             	sub    $0xc,%eax
c010494e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0104951:	8b 45 08             	mov    0x8(%ebp),%eax
c0104954:	8b 50 08             	mov    0x8(%eax),%edx
c0104957:	89 d0                	mov    %edx,%eax
c0104959:	c1 e0 02             	shl    $0x2,%eax
c010495c:	01 d0                	add    %edx,%eax
c010495e:	c1 e0 02             	shl    $0x2,%eax
c0104961:	89 c2                	mov    %eax,%edx
c0104963:	8b 45 08             	mov    0x8(%ebp),%eax
c0104966:	01 d0                	add    %edx,%eax
c0104968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010496b:	72 40                	jb     c01049ad <default_free_pages+0x2d6>
            assert(base + base->property != p);
c010496d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104970:	8b 50 08             	mov    0x8(%eax),%edx
c0104973:	89 d0                	mov    %edx,%eax
c0104975:	c1 e0 02             	shl    $0x2,%eax
c0104978:	01 d0                	add    %edx,%eax
c010497a:	c1 e0 02             	shl    $0x2,%eax
c010497d:	89 c2                	mov    %eax,%edx
c010497f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104982:	01 d0                	add    %edx,%eax
c0104984:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104987:	75 3e                	jne    c01049c7 <default_free_pages+0x2f0>
c0104989:	c7 44 24 0c 21 6f 10 	movl   $0xc0106f21,0xc(%esp)
c0104990:	c0 
c0104991:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104998:	c0 
c0104999:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01049a0:	00 
c01049a1:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c01049a8:	e8 79 ba ff ff       	call   c0100426 <__panic>
c01049ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049b0:	89 45 98             	mov    %eax,-0x68(%ebp)
c01049b3:	8b 45 98             	mov    -0x68(%ebp),%eax
c01049b6:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c01049b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01049bc:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c01049c3:	75 83                	jne    c0104948 <default_free_pages+0x271>
c01049c5:	eb 01                	jmp    c01049c8 <default_free_pages+0x2f1>
            break;
c01049c7:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c01049c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01049cb:	8d 50 0c             	lea    0xc(%eax),%edx
c01049ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d1:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01049d4:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01049d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01049da:	8b 00                	mov    (%eax),%eax
c01049dc:	8b 55 90             	mov    -0x70(%ebp),%edx
c01049df:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01049e2:	89 45 88             	mov    %eax,-0x78(%ebp)
c01049e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01049e8:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c01049eb:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01049ee:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01049f1:	89 10                	mov    %edx,(%eax)
c01049f3:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01049f6:	8b 10                	mov    (%eax),%edx
c01049f8:	8b 45 88             	mov    -0x78(%ebp),%eax
c01049fb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01049fe:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104a01:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104a04:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104a07:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104a0a:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104a0d:	89 10                	mov    %edx,(%eax)
}
c0104a0f:	90                   	nop
}
c0104a10:	90                   	nop
}
c0104a11:	90                   	nop
c0104a12:	c9                   	leave  
c0104a13:	c3                   	ret    

c0104a14 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104a14:	f3 0f 1e fb          	endbr32 
c0104a18:	55                   	push   %ebp
c0104a19:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104a1b:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
}
c0104a20:	5d                   	pop    %ebp
c0104a21:	c3                   	ret    

c0104a22 <basic_check>:

static void
basic_check(void) {
c0104a22:	f3 0f 1e fb          	endbr32 
c0104a26:	55                   	push   %ebp
c0104a27:	89 e5                	mov    %esp,%ebp
c0104a29:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104a2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104a3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a46:	e8 63 e2 ff ff       	call   c0102cae <alloc_pages>
c0104a4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104a52:	75 24                	jne    c0104a78 <basic_check+0x56>
c0104a54:	c7 44 24 0c 3c 6f 10 	movl   $0xc0106f3c,0xc(%esp)
c0104a5b:	c0 
c0104a5c:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104a63:	c0 
c0104a64:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0104a6b:	00 
c0104a6c:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104a73:	e8 ae b9 ff ff       	call   c0100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104a78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a7f:	e8 2a e2 ff ff       	call   c0102cae <alloc_pages>
c0104a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a8b:	75 24                	jne    c0104ab1 <basic_check+0x8f>
c0104a8d:	c7 44 24 0c 58 6f 10 	movl   $0xc0106f58,0xc(%esp)
c0104a94:	c0 
c0104a95:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104a9c:	c0 
c0104a9d:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0104aa4:	00 
c0104aa5:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104aac:	e8 75 b9 ff ff       	call   c0100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104ab1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ab8:	e8 f1 e1 ff ff       	call   c0102cae <alloc_pages>
c0104abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104ac4:	75 24                	jne    c0104aea <basic_check+0xc8>
c0104ac6:	c7 44 24 0c 74 6f 10 	movl   $0xc0106f74,0xc(%esp)
c0104acd:	c0 
c0104ace:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104ad5:	c0 
c0104ad6:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104add:	00 
c0104ade:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104ae5:	e8 3c b9 ff ff       	call   c0100426 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104aed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104af0:	74 10                	je     c0104b02 <basic_check+0xe0>
c0104af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104af5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104af8:	74 08                	je     c0104b02 <basic_check+0xe0>
c0104afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104afd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b00:	75 24                	jne    c0104b26 <basic_check+0x104>
c0104b02:	c7 44 24 0c 90 6f 10 	movl   $0xc0106f90,0xc(%esp)
c0104b09:	c0 
c0104b0a:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104b11:	c0 
c0104b12:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0104b19:	00 
c0104b1a:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104b21:	e8 00 b9 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b29:	89 04 24             	mov    %eax,(%esp)
c0104b2c:	e8 78 f8 ff ff       	call   c01043a9 <page_ref>
c0104b31:	85 c0                	test   %eax,%eax
c0104b33:	75 1e                	jne    c0104b53 <basic_check+0x131>
c0104b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b38:	89 04 24             	mov    %eax,(%esp)
c0104b3b:	e8 69 f8 ff ff       	call   c01043a9 <page_ref>
c0104b40:	85 c0                	test   %eax,%eax
c0104b42:	75 0f                	jne    c0104b53 <basic_check+0x131>
c0104b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b47:	89 04 24             	mov    %eax,(%esp)
c0104b4a:	e8 5a f8 ff ff       	call   c01043a9 <page_ref>
c0104b4f:	85 c0                	test   %eax,%eax
c0104b51:	74 24                	je     c0104b77 <basic_check+0x155>
c0104b53:	c7 44 24 0c b4 6f 10 	movl   $0xc0106fb4,0xc(%esp)
c0104b5a:	c0 
c0104b5b:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104b62:	c0 
c0104b63:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0104b6a:	00 
c0104b6b:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104b72:	e8 af b8 ff ff       	call   c0100426 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b7a:	89 04 24             	mov    %eax,(%esp)
c0104b7d:	e8 11 f8 ff ff       	call   c0104393 <page2pa>
c0104b82:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104b88:	c1 e2 0c             	shl    $0xc,%edx
c0104b8b:	39 d0                	cmp    %edx,%eax
c0104b8d:	72 24                	jb     c0104bb3 <basic_check+0x191>
c0104b8f:	c7 44 24 0c f0 6f 10 	movl   $0xc0106ff0,0xc(%esp)
c0104b96:	c0 
c0104b97:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104b9e:	c0 
c0104b9f:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0104ba6:	00 
c0104ba7:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104bae:	e8 73 b8 ff ff       	call   c0100426 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bb6:	89 04 24             	mov    %eax,(%esp)
c0104bb9:	e8 d5 f7 ff ff       	call   c0104393 <page2pa>
c0104bbe:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104bc4:	c1 e2 0c             	shl    $0xc,%edx
c0104bc7:	39 d0                	cmp    %edx,%eax
c0104bc9:	72 24                	jb     c0104bef <basic_check+0x1cd>
c0104bcb:	c7 44 24 0c 0d 70 10 	movl   $0xc010700d,0xc(%esp)
c0104bd2:	c0 
c0104bd3:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104bda:	c0 
c0104bdb:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0104be2:	00 
c0104be3:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104bea:	e8 37 b8 ff ff       	call   c0100426 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bf2:	89 04 24             	mov    %eax,(%esp)
c0104bf5:	e8 99 f7 ff ff       	call   c0104393 <page2pa>
c0104bfa:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104c00:	c1 e2 0c             	shl    $0xc,%edx
c0104c03:	39 d0                	cmp    %edx,%eax
c0104c05:	72 24                	jb     c0104c2b <basic_check+0x209>
c0104c07:	c7 44 24 0c 2a 70 10 	movl   $0xc010702a,0xc(%esp)
c0104c0e:	c0 
c0104c0f:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104c16:	c0 
c0104c17:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0104c1e:	00 
c0104c1f:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104c26:	e8 fb b7 ff ff       	call   c0100426 <__panic>

    list_entry_t free_list_store = free_list;
c0104c2b:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104c30:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c0104c36:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104c39:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104c3c:	c7 45 dc 1c cf 11 c0 	movl   $0xc011cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104c43:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c46:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c49:	89 50 04             	mov    %edx,0x4(%eax)
c0104c4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c4f:	8b 50 04             	mov    0x4(%eax),%edx
c0104c52:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c55:	89 10                	mov    %edx,(%eax)
}
c0104c57:	90                   	nop
c0104c58:	c7 45 e0 1c cf 11 c0 	movl   $0xc011cf1c,-0x20(%ebp)
    return list->next == list;
c0104c5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c62:	8b 40 04             	mov    0x4(%eax),%eax
c0104c65:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104c68:	0f 94 c0             	sete   %al
c0104c6b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104c6e:	85 c0                	test   %eax,%eax
c0104c70:	75 24                	jne    c0104c96 <basic_check+0x274>
c0104c72:	c7 44 24 0c 47 70 10 	movl   $0xc0107047,0xc(%esp)
c0104c79:	c0 
c0104c7a:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104c81:	c0 
c0104c82:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0104c89:	00 
c0104c8a:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104c91:	e8 90 b7 ff ff       	call   c0100426 <__panic>

    unsigned int nr_free_store = nr_free;
c0104c96:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104c9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104c9e:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0104ca5:	00 00 00 

    assert(alloc_page() == NULL);
c0104ca8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104caf:	e8 fa df ff ff       	call   c0102cae <alloc_pages>
c0104cb4:	85 c0                	test   %eax,%eax
c0104cb6:	74 24                	je     c0104cdc <basic_check+0x2ba>
c0104cb8:	c7 44 24 0c 5e 70 10 	movl   $0xc010705e,0xc(%esp)
c0104cbf:	c0 
c0104cc0:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104cc7:	c0 
c0104cc8:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104ccf:	00 
c0104cd0:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104cd7:	e8 4a b7 ff ff       	call   c0100426 <__panic>

    free_page(p0);
c0104cdc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ce3:	00 
c0104ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ce7:	89 04 24             	mov    %eax,(%esp)
c0104cea:	e8 fb df ff ff       	call   c0102cea <free_pages>
    free_page(p1);
c0104cef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104cf6:	00 
c0104cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cfa:	89 04 24             	mov    %eax,(%esp)
c0104cfd:	e8 e8 df ff ff       	call   c0102cea <free_pages>
    free_page(p2);
c0104d02:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d09:	00 
c0104d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d0d:	89 04 24             	mov    %eax,(%esp)
c0104d10:	e8 d5 df ff ff       	call   c0102cea <free_pages>
    assert(nr_free == 3);
c0104d15:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104d1a:	83 f8 03             	cmp    $0x3,%eax
c0104d1d:	74 24                	je     c0104d43 <basic_check+0x321>
c0104d1f:	c7 44 24 0c 73 70 10 	movl   $0xc0107073,0xc(%esp)
c0104d26:	c0 
c0104d27:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104d2e:	c0 
c0104d2f:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104d36:	00 
c0104d37:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104d3e:	e8 e3 b6 ff ff       	call   c0100426 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104d43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d4a:	e8 5f df ff ff       	call   c0102cae <alloc_pages>
c0104d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d52:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104d56:	75 24                	jne    c0104d7c <basic_check+0x35a>
c0104d58:	c7 44 24 0c 3c 6f 10 	movl   $0xc0106f3c,0xc(%esp)
c0104d5f:	c0 
c0104d60:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104d67:	c0 
c0104d68:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0104d6f:	00 
c0104d70:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104d77:	e8 aa b6 ff ff       	call   c0100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104d7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d83:	e8 26 df ff ff       	call   c0102cae <alloc_pages>
c0104d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d8f:	75 24                	jne    c0104db5 <basic_check+0x393>
c0104d91:	c7 44 24 0c 58 6f 10 	movl   $0xc0106f58,0xc(%esp)
c0104d98:	c0 
c0104d99:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104da0:	c0 
c0104da1:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0104da8:	00 
c0104da9:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104db0:	e8 71 b6 ff ff       	call   c0100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104db5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104dbc:	e8 ed de ff ff       	call   c0102cae <alloc_pages>
c0104dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104dc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104dc8:	75 24                	jne    c0104dee <basic_check+0x3cc>
c0104dca:	c7 44 24 0c 74 6f 10 	movl   $0xc0106f74,0xc(%esp)
c0104dd1:	c0 
c0104dd2:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104dd9:	c0 
c0104dda:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0104de1:	00 
c0104de2:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104de9:	e8 38 b6 ff ff       	call   c0100426 <__panic>

    assert(alloc_page() == NULL);
c0104dee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104df5:	e8 b4 de ff ff       	call   c0102cae <alloc_pages>
c0104dfa:	85 c0                	test   %eax,%eax
c0104dfc:	74 24                	je     c0104e22 <basic_check+0x400>
c0104dfe:	c7 44 24 0c 5e 70 10 	movl   $0xc010705e,0xc(%esp)
c0104e05:	c0 
c0104e06:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104e0d:	c0 
c0104e0e:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0104e15:	00 
c0104e16:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104e1d:	e8 04 b6 ff ff       	call   c0100426 <__panic>

    free_page(p0);
c0104e22:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e29:	00 
c0104e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e2d:	89 04 24             	mov    %eax,(%esp)
c0104e30:	e8 b5 de ff ff       	call   c0102cea <free_pages>
c0104e35:	c7 45 d8 1c cf 11 c0 	movl   $0xc011cf1c,-0x28(%ebp)
c0104e3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104e3f:	8b 40 04             	mov    0x4(%eax),%eax
c0104e42:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104e45:	0f 94 c0             	sete   %al
c0104e48:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104e4b:	85 c0                	test   %eax,%eax
c0104e4d:	74 24                	je     c0104e73 <basic_check+0x451>
c0104e4f:	c7 44 24 0c 80 70 10 	movl   $0xc0107080,0xc(%esp)
c0104e56:	c0 
c0104e57:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104e5e:	c0 
c0104e5f:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0104e66:	00 
c0104e67:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104e6e:	e8 b3 b5 ff ff       	call   c0100426 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104e73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e7a:	e8 2f de ff ff       	call   c0102cae <alloc_pages>
c0104e7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e85:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104e88:	74 24                	je     c0104eae <basic_check+0x48c>
c0104e8a:	c7 44 24 0c 98 70 10 	movl   $0xc0107098,0xc(%esp)
c0104e91:	c0 
c0104e92:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104e99:	c0 
c0104e9a:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0104ea1:	00 
c0104ea2:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104ea9:	e8 78 b5 ff ff       	call   c0100426 <__panic>
    assert(alloc_page() == NULL);
c0104eae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104eb5:	e8 f4 dd ff ff       	call   c0102cae <alloc_pages>
c0104eba:	85 c0                	test   %eax,%eax
c0104ebc:	74 24                	je     c0104ee2 <basic_check+0x4c0>
c0104ebe:	c7 44 24 0c 5e 70 10 	movl   $0xc010705e,0xc(%esp)
c0104ec5:	c0 
c0104ec6:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104ecd:	c0 
c0104ece:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0104ed5:	00 
c0104ed6:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104edd:	e8 44 b5 ff ff       	call   c0100426 <__panic>

    assert(nr_free == 0);
c0104ee2:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104ee7:	85 c0                	test   %eax,%eax
c0104ee9:	74 24                	je     c0104f0f <basic_check+0x4ed>
c0104eeb:	c7 44 24 0c b1 70 10 	movl   $0xc01070b1,0xc(%esp)
c0104ef2:	c0 
c0104ef3:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104efa:	c0 
c0104efb:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0104f02:	00 
c0104f03:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104f0a:	e8 17 b5 ff ff       	call   c0100426 <__panic>
    free_list = free_list_store;
c0104f0f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f12:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f15:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c0104f1a:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    nr_free = nr_free_store;
c0104f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f23:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_page(p);
c0104f28:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f2f:	00 
c0104f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f33:	89 04 24             	mov    %eax,(%esp)
c0104f36:	e8 af dd ff ff       	call   c0102cea <free_pages>
    free_page(p1);
c0104f3b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f42:	00 
c0104f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f46:	89 04 24             	mov    %eax,(%esp)
c0104f49:	e8 9c dd ff ff       	call   c0102cea <free_pages>
    free_page(p2);
c0104f4e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f55:	00 
c0104f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f59:	89 04 24             	mov    %eax,(%esp)
c0104f5c:	e8 89 dd ff ff       	call   c0102cea <free_pages>
}
c0104f61:	90                   	nop
c0104f62:	c9                   	leave  
c0104f63:	c3                   	ret    

c0104f64 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104f64:	f3 0f 1e fb          	endbr32 
c0104f68:	55                   	push   %ebp
c0104f69:	89 e5                	mov    %esp,%ebp
c0104f6b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0104f71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104f78:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104f7f:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104f86:	eb 6a                	jmp    c0104ff2 <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
c0104f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f8b:	83 e8 0c             	sub    $0xc,%eax
c0104f8e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0104f91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104f94:	83 c0 04             	add    $0x4,%eax
c0104f97:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104f9e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104fa1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104fa4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104fa7:	0f a3 10             	bt     %edx,(%eax)
c0104faa:	19 c0                	sbb    %eax,%eax
c0104fac:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104faf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104fb3:	0f 95 c0             	setne  %al
c0104fb6:	0f b6 c0             	movzbl %al,%eax
c0104fb9:	85 c0                	test   %eax,%eax
c0104fbb:	75 24                	jne    c0104fe1 <default_check+0x7d>
c0104fbd:	c7 44 24 0c be 70 10 	movl   $0xc01070be,0xc(%esp)
c0104fc4:	c0 
c0104fc5:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0104fcc:	c0 
c0104fcd:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0104fd4:	00 
c0104fd5:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0104fdc:	e8 45 b4 ff ff       	call   c0100426 <__panic>
        count ++, total += p->property;
c0104fe1:	ff 45 f4             	incl   -0xc(%ebp)
c0104fe4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104fe7:	8b 50 08             	mov    0x8(%eax),%edx
c0104fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fed:	01 d0                	add    %edx,%eax
c0104fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ff5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104ff8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104ffb:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104ffe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105001:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c0105008:	0f 85 7a ff ff ff    	jne    c0104f88 <default_check+0x24>
    }
    assert(total == nr_free_pages());
c010500e:	e8 0e dd ff ff       	call   c0102d21 <nr_free_pages>
c0105013:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105016:	39 d0                	cmp    %edx,%eax
c0105018:	74 24                	je     c010503e <default_check+0xda>
c010501a:	c7 44 24 0c ce 70 10 	movl   $0xc01070ce,0xc(%esp)
c0105021:	c0 
c0105022:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105029:	c0 
c010502a:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0105031:	00 
c0105032:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0105039:	e8 e8 b3 ff ff       	call   c0100426 <__panic>

    basic_check();
c010503e:	e8 df f9 ff ff       	call   c0104a22 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0105043:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010504a:	e8 5f dc ff ff       	call   c0102cae <alloc_pages>
c010504f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0105052:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105056:	75 24                	jne    c010507c <default_check+0x118>
c0105058:	c7 44 24 0c e7 70 10 	movl   $0xc01070e7,0xc(%esp)
c010505f:	c0 
c0105060:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105067:	c0 
c0105068:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c010506f:	00 
c0105070:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0105077:	e8 aa b3 ff ff       	call   c0100426 <__panic>
    assert(!PageProperty(p0));
c010507c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010507f:	83 c0 04             	add    $0x4,%eax
c0105082:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0105089:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010508c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010508f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105092:	0f a3 10             	bt     %edx,(%eax)
c0105095:	19 c0                	sbb    %eax,%eax
c0105097:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010509a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010509e:	0f 95 c0             	setne  %al
c01050a1:	0f b6 c0             	movzbl %al,%eax
c01050a4:	85 c0                	test   %eax,%eax
c01050a6:	74 24                	je     c01050cc <default_check+0x168>
c01050a8:	c7 44 24 0c f2 70 10 	movl   $0xc01070f2,0xc(%esp)
c01050af:	c0 
c01050b0:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c01050b7:	c0 
c01050b8:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01050bf:	00 
c01050c0:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c01050c7:	e8 5a b3 ff ff       	call   c0100426 <__panic>

    list_entry_t free_list_store = free_list;
c01050cc:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c01050d1:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c01050d7:	89 45 80             	mov    %eax,-0x80(%ebp)
c01050da:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01050dd:	c7 45 b0 1c cf 11 c0 	movl   $0xc011cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01050e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01050e7:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01050ea:	89 50 04             	mov    %edx,0x4(%eax)
c01050ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01050f0:	8b 50 04             	mov    0x4(%eax),%edx
c01050f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01050f6:	89 10                	mov    %edx,(%eax)
}
c01050f8:	90                   	nop
c01050f9:	c7 45 b4 1c cf 11 c0 	movl   $0xc011cf1c,-0x4c(%ebp)
    return list->next == list;
c0105100:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105103:	8b 40 04             	mov    0x4(%eax),%eax
c0105106:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0105109:	0f 94 c0             	sete   %al
c010510c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010510f:	85 c0                	test   %eax,%eax
c0105111:	75 24                	jne    c0105137 <default_check+0x1d3>
c0105113:	c7 44 24 0c 47 70 10 	movl   $0xc0107047,0xc(%esp)
c010511a:	c0 
c010511b:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105122:	c0 
c0105123:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c010512a:	00 
c010512b:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0105132:	e8 ef b2 ff ff       	call   c0100426 <__panic>
    assert(alloc_page() == NULL);
c0105137:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010513e:	e8 6b db ff ff       	call   c0102cae <alloc_pages>
c0105143:	85 c0                	test   %eax,%eax
c0105145:	74 24                	je     c010516b <default_check+0x207>
c0105147:	c7 44 24 0c 5e 70 10 	movl   $0xc010705e,0xc(%esp)
c010514e:	c0 
c010514f:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105156:	c0 
c0105157:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c010515e:	00 
c010515f:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0105166:	e8 bb b2 ff ff       	call   c0100426 <__panic>

    unsigned int nr_free_store = nr_free;
c010516b:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0105170:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0105173:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c010517a:	00 00 00 

    free_pages(p0 + 2, 3);
c010517d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105180:	83 c0 28             	add    $0x28,%eax
c0105183:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010518a:	00 
c010518b:	89 04 24             	mov    %eax,(%esp)
c010518e:	e8 57 db ff ff       	call   c0102cea <free_pages>
    assert(alloc_pages(4) == NULL);
c0105193:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010519a:	e8 0f db ff ff       	call   c0102cae <alloc_pages>
c010519f:	85 c0                	test   %eax,%eax
c01051a1:	74 24                	je     c01051c7 <default_check+0x263>
c01051a3:	c7 44 24 0c 04 71 10 	movl   $0xc0107104,0xc(%esp)
c01051aa:	c0 
c01051ab:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c01051b2:	c0 
c01051b3:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01051ba:	00 
c01051bb:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c01051c2:	e8 5f b2 ff ff       	call   c0100426 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01051c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01051ca:	83 c0 28             	add    $0x28,%eax
c01051cd:	83 c0 04             	add    $0x4,%eax
c01051d0:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01051d7:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01051da:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01051dd:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01051e0:	0f a3 10             	bt     %edx,(%eax)
c01051e3:	19 c0                	sbb    %eax,%eax
c01051e5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01051e8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01051ec:	0f 95 c0             	setne  %al
c01051ef:	0f b6 c0             	movzbl %al,%eax
c01051f2:	85 c0                	test   %eax,%eax
c01051f4:	74 0e                	je     c0105204 <default_check+0x2a0>
c01051f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01051f9:	83 c0 28             	add    $0x28,%eax
c01051fc:	8b 40 08             	mov    0x8(%eax),%eax
c01051ff:	83 f8 03             	cmp    $0x3,%eax
c0105202:	74 24                	je     c0105228 <default_check+0x2c4>
c0105204:	c7 44 24 0c 1c 71 10 	movl   $0xc010711c,0xc(%esp)
c010520b:	c0 
c010520c:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105213:	c0 
c0105214:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010521b:	00 
c010521c:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0105223:	e8 fe b1 ff ff       	call   c0100426 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0105228:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010522f:	e8 7a da ff ff       	call   c0102cae <alloc_pages>
c0105234:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105237:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010523b:	75 24                	jne    c0105261 <default_check+0x2fd>
c010523d:	c7 44 24 0c 48 71 10 	movl   $0xc0107148,0xc(%esp)
c0105244:	c0 
c0105245:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c010524c:	c0 
c010524d:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0105254:	00 
c0105255:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c010525c:	e8 c5 b1 ff ff       	call   c0100426 <__panic>
    assert(alloc_page() == NULL);
c0105261:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105268:	e8 41 da ff ff       	call   c0102cae <alloc_pages>
c010526d:	85 c0                	test   %eax,%eax
c010526f:	74 24                	je     c0105295 <default_check+0x331>
c0105271:	c7 44 24 0c 5e 70 10 	movl   $0xc010705e,0xc(%esp)
c0105278:	c0 
c0105279:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105280:	c0 
c0105281:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105288:	00 
c0105289:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0105290:	e8 91 b1 ff ff       	call   c0100426 <__panic>
    assert(p0 + 2 == p1);
c0105295:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105298:	83 c0 28             	add    $0x28,%eax
c010529b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010529e:	74 24                	je     c01052c4 <default_check+0x360>
c01052a0:	c7 44 24 0c 66 71 10 	movl   $0xc0107166,0xc(%esp)
c01052a7:	c0 
c01052a8:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c01052af:	c0 
c01052b0:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01052b7:	00 
c01052b8:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c01052bf:	e8 62 b1 ff ff       	call   c0100426 <__panic>

    p2 = p0 + 1;
c01052c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052c7:	83 c0 14             	add    $0x14,%eax
c01052ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01052cd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01052d4:	00 
c01052d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052d8:	89 04 24             	mov    %eax,(%esp)
c01052db:	e8 0a da ff ff       	call   c0102cea <free_pages>
    free_pages(p1, 3);
c01052e0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01052e7:	00 
c01052e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052eb:	89 04 24             	mov    %eax,(%esp)
c01052ee:	e8 f7 d9 ff ff       	call   c0102cea <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01052f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052f6:	83 c0 04             	add    $0x4,%eax
c01052f9:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0105300:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105303:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105306:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105309:	0f a3 10             	bt     %edx,(%eax)
c010530c:	19 c0                	sbb    %eax,%eax
c010530e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0105311:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105315:	0f 95 c0             	setne  %al
c0105318:	0f b6 c0             	movzbl %al,%eax
c010531b:	85 c0                	test   %eax,%eax
c010531d:	74 0b                	je     c010532a <default_check+0x3c6>
c010531f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105322:	8b 40 08             	mov    0x8(%eax),%eax
c0105325:	83 f8 01             	cmp    $0x1,%eax
c0105328:	74 24                	je     c010534e <default_check+0x3ea>
c010532a:	c7 44 24 0c 74 71 10 	movl   $0xc0107174,0xc(%esp)
c0105331:	c0 
c0105332:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105339:	c0 
c010533a:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0105341:	00 
c0105342:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0105349:	e8 d8 b0 ff ff       	call   c0100426 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010534e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105351:	83 c0 04             	add    $0x4,%eax
c0105354:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010535b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010535e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105361:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105364:	0f a3 10             	bt     %edx,(%eax)
c0105367:	19 c0                	sbb    %eax,%eax
c0105369:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010536c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105370:	0f 95 c0             	setne  %al
c0105373:	0f b6 c0             	movzbl %al,%eax
c0105376:	85 c0                	test   %eax,%eax
c0105378:	74 0b                	je     c0105385 <default_check+0x421>
c010537a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010537d:	8b 40 08             	mov    0x8(%eax),%eax
c0105380:	83 f8 03             	cmp    $0x3,%eax
c0105383:	74 24                	je     c01053a9 <default_check+0x445>
c0105385:	c7 44 24 0c 9c 71 10 	movl   $0xc010719c,0xc(%esp)
c010538c:	c0 
c010538d:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105394:	c0 
c0105395:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c010539c:	00 
c010539d:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c01053a4:	e8 7d b0 ff ff       	call   c0100426 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01053a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01053b0:	e8 f9 d8 ff ff       	call   c0102cae <alloc_pages>
c01053b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053bb:	83 e8 14             	sub    $0x14,%eax
c01053be:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01053c1:	74 24                	je     c01053e7 <default_check+0x483>
c01053c3:	c7 44 24 0c c2 71 10 	movl   $0xc01071c2,0xc(%esp)
c01053ca:	c0 
c01053cb:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c01053d2:	c0 
c01053d3:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c01053da:	00 
c01053db:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c01053e2:	e8 3f b0 ff ff       	call   c0100426 <__panic>
    free_page(p0);
c01053e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01053ee:	00 
c01053ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053f2:	89 04 24             	mov    %eax,(%esp)
c01053f5:	e8 f0 d8 ff ff       	call   c0102cea <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01053fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0105401:	e8 a8 d8 ff ff       	call   c0102cae <alloc_pages>
c0105406:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105409:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010540c:	83 c0 14             	add    $0x14,%eax
c010540f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105412:	74 24                	je     c0105438 <default_check+0x4d4>
c0105414:	c7 44 24 0c e0 71 10 	movl   $0xc01071e0,0xc(%esp)
c010541b:	c0 
c010541c:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105423:	c0 
c0105424:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c010542b:	00 
c010542c:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0105433:	e8 ee af ff ff       	call   c0100426 <__panic>

    free_pages(p0, 2);
c0105438:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010543f:	00 
c0105440:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105443:	89 04 24             	mov    %eax,(%esp)
c0105446:	e8 9f d8 ff ff       	call   c0102cea <free_pages>
    free_page(p2);
c010544b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105452:	00 
c0105453:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105456:	89 04 24             	mov    %eax,(%esp)
c0105459:	e8 8c d8 ff ff       	call   c0102cea <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010545e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105465:	e8 44 d8 ff ff       	call   c0102cae <alloc_pages>
c010546a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010546d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105471:	75 24                	jne    c0105497 <default_check+0x533>
c0105473:	c7 44 24 0c 00 72 10 	movl   $0xc0107200,0xc(%esp)
c010547a:	c0 
c010547b:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105482:	c0 
c0105483:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c010548a:	00 
c010548b:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0105492:	e8 8f af ff ff       	call   c0100426 <__panic>
    assert(alloc_page() == NULL);
c0105497:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010549e:	e8 0b d8 ff ff       	call   c0102cae <alloc_pages>
c01054a3:	85 c0                	test   %eax,%eax
c01054a5:	74 24                	je     c01054cb <default_check+0x567>
c01054a7:	c7 44 24 0c 5e 70 10 	movl   $0xc010705e,0xc(%esp)
c01054ae:	c0 
c01054af:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c01054b6:	c0 
c01054b7:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01054be:	00 
c01054bf:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c01054c6:	e8 5b af ff ff       	call   c0100426 <__panic>

    assert(nr_free == 0);
c01054cb:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01054d0:	85 c0                	test   %eax,%eax
c01054d2:	74 24                	je     c01054f8 <default_check+0x594>
c01054d4:	c7 44 24 0c b1 70 10 	movl   $0xc01070b1,0xc(%esp)
c01054db:	c0 
c01054dc:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c01054e3:	c0 
c01054e4:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c01054eb:	00 
c01054ec:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c01054f3:	e8 2e af ff ff       	call   c0100426 <__panic>
    nr_free = nr_free_store;
c01054f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054fb:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_list = free_list_store;
c0105500:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105503:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105506:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c010550b:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    free_pages(p0, 5);
c0105511:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0105518:	00 
c0105519:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010551c:	89 04 24             	mov    %eax,(%esp)
c010551f:	e8 c6 d7 ff ff       	call   c0102cea <free_pages>

    le = &free_list;
c0105524:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010552b:	eb 1c                	jmp    c0105549 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
c010552d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105530:	83 e8 0c             	sub    $0xc,%eax
c0105533:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0105536:	ff 4d f4             	decl   -0xc(%ebp)
c0105539:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010553c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010553f:	8b 40 08             	mov    0x8(%eax),%eax
c0105542:	29 c2                	sub    %eax,%edx
c0105544:	89 d0                	mov    %edx,%eax
c0105546:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105549:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010554c:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c010554f:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105552:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105555:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105558:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c010555f:	75 cc                	jne    c010552d <default_check+0x5c9>
    }
    assert(count == 0);
c0105561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105565:	74 24                	je     c010558b <default_check+0x627>
c0105567:	c7 44 24 0c 1e 72 10 	movl   $0xc010721e,0xc(%esp)
c010556e:	c0 
c010556f:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c0105576:	c0 
c0105577:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c010557e:	00 
c010557f:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c0105586:	e8 9b ae ff ff       	call   c0100426 <__panic>
    assert(total == 0);
c010558b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010558f:	74 24                	je     c01055b5 <default_check+0x651>
c0105591:	c7 44 24 0c 29 72 10 	movl   $0xc0107229,0xc(%esp)
c0105598:	c0 
c0105599:	c7 44 24 08 be 6e 10 	movl   $0xc0106ebe,0x8(%esp)
c01055a0:	c0 
c01055a1:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c01055a8:	00 
c01055a9:	c7 04 24 d3 6e 10 c0 	movl   $0xc0106ed3,(%esp)
c01055b0:	e8 71 ae ff ff       	call   c0100426 <__panic>
}
c01055b5:	90                   	nop
c01055b6:	c9                   	leave  
c01055b7:	c3                   	ret    

c01055b8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01055b8:	f3 0f 1e fb          	endbr32 
c01055bc:	55                   	push   %ebp
c01055bd:	89 e5                	mov    %esp,%ebp
c01055bf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01055c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01055c9:	eb 03                	jmp    c01055ce <strlen+0x16>
        cnt ++;
c01055cb:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c01055ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d1:	8d 50 01             	lea    0x1(%eax),%edx
c01055d4:	89 55 08             	mov    %edx,0x8(%ebp)
c01055d7:	0f b6 00             	movzbl (%eax),%eax
c01055da:	84 c0                	test   %al,%al
c01055dc:	75 ed                	jne    c01055cb <strlen+0x13>
    }
    return cnt;
c01055de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01055e1:	c9                   	leave  
c01055e2:	c3                   	ret    

c01055e3 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01055e3:	f3 0f 1e fb          	endbr32 
c01055e7:	55                   	push   %ebp
c01055e8:	89 e5                	mov    %esp,%ebp
c01055ea:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01055ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01055f4:	eb 03                	jmp    c01055f9 <strnlen+0x16>
        cnt ++;
c01055f6:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01055f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01055ff:	73 10                	jae    c0105611 <strnlen+0x2e>
c0105601:	8b 45 08             	mov    0x8(%ebp),%eax
c0105604:	8d 50 01             	lea    0x1(%eax),%edx
c0105607:	89 55 08             	mov    %edx,0x8(%ebp)
c010560a:	0f b6 00             	movzbl (%eax),%eax
c010560d:	84 c0                	test   %al,%al
c010560f:	75 e5                	jne    c01055f6 <strnlen+0x13>
    }
    return cnt;
c0105611:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105614:	c9                   	leave  
c0105615:	c3                   	ret    

c0105616 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105616:	f3 0f 1e fb          	endbr32 
c010561a:	55                   	push   %ebp
c010561b:	89 e5                	mov    %esp,%ebp
c010561d:	57                   	push   %edi
c010561e:	56                   	push   %esi
c010561f:	83 ec 20             	sub    $0x20,%esp
c0105622:	8b 45 08             	mov    0x8(%ebp),%eax
c0105625:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105628:	8b 45 0c             	mov    0xc(%ebp),%eax
c010562b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010562e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105631:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105634:	89 d1                	mov    %edx,%ecx
c0105636:	89 c2                	mov    %eax,%edx
c0105638:	89 ce                	mov    %ecx,%esi
c010563a:	89 d7                	mov    %edx,%edi
c010563c:	ac                   	lods   %ds:(%esi),%al
c010563d:	aa                   	stos   %al,%es:(%edi)
c010563e:	84 c0                	test   %al,%al
c0105640:	75 fa                	jne    c010563c <strcpy+0x26>
c0105642:	89 fa                	mov    %edi,%edx
c0105644:	89 f1                	mov    %esi,%ecx
c0105646:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105649:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010564c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010564f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105652:	83 c4 20             	add    $0x20,%esp
c0105655:	5e                   	pop    %esi
c0105656:	5f                   	pop    %edi
c0105657:	5d                   	pop    %ebp
c0105658:	c3                   	ret    

c0105659 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105659:	f3 0f 1e fb          	endbr32 
c010565d:	55                   	push   %ebp
c010565e:	89 e5                	mov    %esp,%ebp
c0105660:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105663:	8b 45 08             	mov    0x8(%ebp),%eax
c0105666:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105669:	eb 1e                	jmp    c0105689 <strncpy+0x30>
        if ((*p = *src) != '\0') {
c010566b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010566e:	0f b6 10             	movzbl (%eax),%edx
c0105671:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105674:	88 10                	mov    %dl,(%eax)
c0105676:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105679:	0f b6 00             	movzbl (%eax),%eax
c010567c:	84 c0                	test   %al,%al
c010567e:	74 03                	je     c0105683 <strncpy+0x2a>
            src ++;
c0105680:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105683:	ff 45 fc             	incl   -0x4(%ebp)
c0105686:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105689:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010568d:	75 dc                	jne    c010566b <strncpy+0x12>
    }
    return dst;
c010568f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105692:	c9                   	leave  
c0105693:	c3                   	ret    

c0105694 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105694:	f3 0f 1e fb          	endbr32 
c0105698:	55                   	push   %ebp
c0105699:	89 e5                	mov    %esp,%ebp
c010569b:	57                   	push   %edi
c010569c:	56                   	push   %esi
c010569d:	83 ec 20             	sub    $0x20,%esp
c01056a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01056ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056b2:	89 d1                	mov    %edx,%ecx
c01056b4:	89 c2                	mov    %eax,%edx
c01056b6:	89 ce                	mov    %ecx,%esi
c01056b8:	89 d7                	mov    %edx,%edi
c01056ba:	ac                   	lods   %ds:(%esi),%al
c01056bb:	ae                   	scas   %es:(%edi),%al
c01056bc:	75 08                	jne    c01056c6 <strcmp+0x32>
c01056be:	84 c0                	test   %al,%al
c01056c0:	75 f8                	jne    c01056ba <strcmp+0x26>
c01056c2:	31 c0                	xor    %eax,%eax
c01056c4:	eb 04                	jmp    c01056ca <strcmp+0x36>
c01056c6:	19 c0                	sbb    %eax,%eax
c01056c8:	0c 01                	or     $0x1,%al
c01056ca:	89 fa                	mov    %edi,%edx
c01056cc:	89 f1                	mov    %esi,%ecx
c01056ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01056d1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01056d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01056d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01056da:	83 c4 20             	add    $0x20,%esp
c01056dd:	5e                   	pop    %esi
c01056de:	5f                   	pop    %edi
c01056df:	5d                   	pop    %ebp
c01056e0:	c3                   	ret    

c01056e1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01056e1:	f3 0f 1e fb          	endbr32 
c01056e5:	55                   	push   %ebp
c01056e6:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01056e8:	eb 09                	jmp    c01056f3 <strncmp+0x12>
        n --, s1 ++, s2 ++;
c01056ea:	ff 4d 10             	decl   0x10(%ebp)
c01056ed:	ff 45 08             	incl   0x8(%ebp)
c01056f0:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01056f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01056f7:	74 1a                	je     c0105713 <strncmp+0x32>
c01056f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01056fc:	0f b6 00             	movzbl (%eax),%eax
c01056ff:	84 c0                	test   %al,%al
c0105701:	74 10                	je     c0105713 <strncmp+0x32>
c0105703:	8b 45 08             	mov    0x8(%ebp),%eax
c0105706:	0f b6 10             	movzbl (%eax),%edx
c0105709:	8b 45 0c             	mov    0xc(%ebp),%eax
c010570c:	0f b6 00             	movzbl (%eax),%eax
c010570f:	38 c2                	cmp    %al,%dl
c0105711:	74 d7                	je     c01056ea <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105713:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105717:	74 18                	je     c0105731 <strncmp+0x50>
c0105719:	8b 45 08             	mov    0x8(%ebp),%eax
c010571c:	0f b6 00             	movzbl (%eax),%eax
c010571f:	0f b6 d0             	movzbl %al,%edx
c0105722:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105725:	0f b6 00             	movzbl (%eax),%eax
c0105728:	0f b6 c0             	movzbl %al,%eax
c010572b:	29 c2                	sub    %eax,%edx
c010572d:	89 d0                	mov    %edx,%eax
c010572f:	eb 05                	jmp    c0105736 <strncmp+0x55>
c0105731:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105736:	5d                   	pop    %ebp
c0105737:	c3                   	ret    

c0105738 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105738:	f3 0f 1e fb          	endbr32 
c010573c:	55                   	push   %ebp
c010573d:	89 e5                	mov    %esp,%ebp
c010573f:	83 ec 04             	sub    $0x4,%esp
c0105742:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105745:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105748:	eb 13                	jmp    c010575d <strchr+0x25>
        if (*s == c) {
c010574a:	8b 45 08             	mov    0x8(%ebp),%eax
c010574d:	0f b6 00             	movzbl (%eax),%eax
c0105750:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105753:	75 05                	jne    c010575a <strchr+0x22>
            return (char *)s;
c0105755:	8b 45 08             	mov    0x8(%ebp),%eax
c0105758:	eb 12                	jmp    c010576c <strchr+0x34>
        }
        s ++;
c010575a:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c010575d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105760:	0f b6 00             	movzbl (%eax),%eax
c0105763:	84 c0                	test   %al,%al
c0105765:	75 e3                	jne    c010574a <strchr+0x12>
    }
    return NULL;
c0105767:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010576c:	c9                   	leave  
c010576d:	c3                   	ret    

c010576e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010576e:	f3 0f 1e fb          	endbr32 
c0105772:	55                   	push   %ebp
c0105773:	89 e5                	mov    %esp,%ebp
c0105775:	83 ec 04             	sub    $0x4,%esp
c0105778:	8b 45 0c             	mov    0xc(%ebp),%eax
c010577b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010577e:	eb 0e                	jmp    c010578e <strfind+0x20>
        if (*s == c) {
c0105780:	8b 45 08             	mov    0x8(%ebp),%eax
c0105783:	0f b6 00             	movzbl (%eax),%eax
c0105786:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105789:	74 0f                	je     c010579a <strfind+0x2c>
            break;
        }
        s ++;
c010578b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c010578e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105791:	0f b6 00             	movzbl (%eax),%eax
c0105794:	84 c0                	test   %al,%al
c0105796:	75 e8                	jne    c0105780 <strfind+0x12>
c0105798:	eb 01                	jmp    c010579b <strfind+0x2d>
            break;
c010579a:	90                   	nop
    }
    return (char *)s;
c010579b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010579e:	c9                   	leave  
c010579f:	c3                   	ret    

c01057a0 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01057a0:	f3 0f 1e fb          	endbr32 
c01057a4:	55                   	push   %ebp
c01057a5:	89 e5                	mov    %esp,%ebp
c01057a7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01057aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01057b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01057b8:	eb 03                	jmp    c01057bd <strtol+0x1d>
        s ++;
c01057ba:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01057bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c0:	0f b6 00             	movzbl (%eax),%eax
c01057c3:	3c 20                	cmp    $0x20,%al
c01057c5:	74 f3                	je     c01057ba <strtol+0x1a>
c01057c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ca:	0f b6 00             	movzbl (%eax),%eax
c01057cd:	3c 09                	cmp    $0x9,%al
c01057cf:	74 e9                	je     c01057ba <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
c01057d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d4:	0f b6 00             	movzbl (%eax),%eax
c01057d7:	3c 2b                	cmp    $0x2b,%al
c01057d9:	75 05                	jne    c01057e0 <strtol+0x40>
        s ++;
c01057db:	ff 45 08             	incl   0x8(%ebp)
c01057de:	eb 14                	jmp    c01057f4 <strtol+0x54>
    }
    else if (*s == '-') {
c01057e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e3:	0f b6 00             	movzbl (%eax),%eax
c01057e6:	3c 2d                	cmp    $0x2d,%al
c01057e8:	75 0a                	jne    c01057f4 <strtol+0x54>
        s ++, neg = 1;
c01057ea:	ff 45 08             	incl   0x8(%ebp)
c01057ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01057f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01057f8:	74 06                	je     c0105800 <strtol+0x60>
c01057fa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01057fe:	75 22                	jne    c0105822 <strtol+0x82>
c0105800:	8b 45 08             	mov    0x8(%ebp),%eax
c0105803:	0f b6 00             	movzbl (%eax),%eax
c0105806:	3c 30                	cmp    $0x30,%al
c0105808:	75 18                	jne    c0105822 <strtol+0x82>
c010580a:	8b 45 08             	mov    0x8(%ebp),%eax
c010580d:	40                   	inc    %eax
c010580e:	0f b6 00             	movzbl (%eax),%eax
c0105811:	3c 78                	cmp    $0x78,%al
c0105813:	75 0d                	jne    c0105822 <strtol+0x82>
        s += 2, base = 16;
c0105815:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105819:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105820:	eb 29                	jmp    c010584b <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
c0105822:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105826:	75 16                	jne    c010583e <strtol+0x9e>
c0105828:	8b 45 08             	mov    0x8(%ebp),%eax
c010582b:	0f b6 00             	movzbl (%eax),%eax
c010582e:	3c 30                	cmp    $0x30,%al
c0105830:	75 0c                	jne    c010583e <strtol+0x9e>
        s ++, base = 8;
c0105832:	ff 45 08             	incl   0x8(%ebp)
c0105835:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010583c:	eb 0d                	jmp    c010584b <strtol+0xab>
    }
    else if (base == 0) {
c010583e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105842:	75 07                	jne    c010584b <strtol+0xab>
        base = 10;
c0105844:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010584b:	8b 45 08             	mov    0x8(%ebp),%eax
c010584e:	0f b6 00             	movzbl (%eax),%eax
c0105851:	3c 2f                	cmp    $0x2f,%al
c0105853:	7e 1b                	jle    c0105870 <strtol+0xd0>
c0105855:	8b 45 08             	mov    0x8(%ebp),%eax
c0105858:	0f b6 00             	movzbl (%eax),%eax
c010585b:	3c 39                	cmp    $0x39,%al
c010585d:	7f 11                	jg     c0105870 <strtol+0xd0>
            dig = *s - '0';
c010585f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105862:	0f b6 00             	movzbl (%eax),%eax
c0105865:	0f be c0             	movsbl %al,%eax
c0105868:	83 e8 30             	sub    $0x30,%eax
c010586b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010586e:	eb 48                	jmp    c01058b8 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105870:	8b 45 08             	mov    0x8(%ebp),%eax
c0105873:	0f b6 00             	movzbl (%eax),%eax
c0105876:	3c 60                	cmp    $0x60,%al
c0105878:	7e 1b                	jle    c0105895 <strtol+0xf5>
c010587a:	8b 45 08             	mov    0x8(%ebp),%eax
c010587d:	0f b6 00             	movzbl (%eax),%eax
c0105880:	3c 7a                	cmp    $0x7a,%al
c0105882:	7f 11                	jg     c0105895 <strtol+0xf5>
            dig = *s - 'a' + 10;
c0105884:	8b 45 08             	mov    0x8(%ebp),%eax
c0105887:	0f b6 00             	movzbl (%eax),%eax
c010588a:	0f be c0             	movsbl %al,%eax
c010588d:	83 e8 57             	sub    $0x57,%eax
c0105890:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105893:	eb 23                	jmp    c01058b8 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105895:	8b 45 08             	mov    0x8(%ebp),%eax
c0105898:	0f b6 00             	movzbl (%eax),%eax
c010589b:	3c 40                	cmp    $0x40,%al
c010589d:	7e 3b                	jle    c01058da <strtol+0x13a>
c010589f:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a2:	0f b6 00             	movzbl (%eax),%eax
c01058a5:	3c 5a                	cmp    $0x5a,%al
c01058a7:	7f 31                	jg     c01058da <strtol+0x13a>
            dig = *s - 'A' + 10;
c01058a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ac:	0f b6 00             	movzbl (%eax),%eax
c01058af:	0f be c0             	movsbl %al,%eax
c01058b2:	83 e8 37             	sub    $0x37,%eax
c01058b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01058b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058bb:	3b 45 10             	cmp    0x10(%ebp),%eax
c01058be:	7d 19                	jge    c01058d9 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
c01058c0:	ff 45 08             	incl   0x8(%ebp)
c01058c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01058c6:	0f af 45 10          	imul   0x10(%ebp),%eax
c01058ca:	89 c2                	mov    %eax,%edx
c01058cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058cf:	01 d0                	add    %edx,%eax
c01058d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01058d4:	e9 72 ff ff ff       	jmp    c010584b <strtol+0xab>
            break;
c01058d9:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01058da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01058de:	74 08                	je     c01058e8 <strtol+0x148>
        *endptr = (char *) s;
c01058e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058e3:	8b 55 08             	mov    0x8(%ebp),%edx
c01058e6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01058e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01058ec:	74 07                	je     c01058f5 <strtol+0x155>
c01058ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01058f1:	f7 d8                	neg    %eax
c01058f3:	eb 03                	jmp    c01058f8 <strtol+0x158>
c01058f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01058f8:	c9                   	leave  
c01058f9:	c3                   	ret    

c01058fa <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01058fa:	f3 0f 1e fb          	endbr32 
c01058fe:	55                   	push   %ebp
c01058ff:	89 e5                	mov    %esp,%ebp
c0105901:	57                   	push   %edi
c0105902:	83 ec 24             	sub    $0x24,%esp
c0105905:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105908:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010590b:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c010590f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105912:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105915:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105918:	8b 45 10             	mov    0x10(%ebp),%eax
c010591b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010591e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105921:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105925:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105928:	89 d7                	mov    %edx,%edi
c010592a:	f3 aa                	rep stos %al,%es:(%edi)
c010592c:	89 fa                	mov    %edi,%edx
c010592e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105931:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105934:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105937:	83 c4 24             	add    $0x24,%esp
c010593a:	5f                   	pop    %edi
c010593b:	5d                   	pop    %ebp
c010593c:	c3                   	ret    

c010593d <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010593d:	f3 0f 1e fb          	endbr32 
c0105941:	55                   	push   %ebp
c0105942:	89 e5                	mov    %esp,%ebp
c0105944:	57                   	push   %edi
c0105945:	56                   	push   %esi
c0105946:	53                   	push   %ebx
c0105947:	83 ec 30             	sub    $0x30,%esp
c010594a:	8b 45 08             	mov    0x8(%ebp),%eax
c010594d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105950:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105953:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105956:	8b 45 10             	mov    0x10(%ebp),%eax
c0105959:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010595c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010595f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105962:	73 42                	jae    c01059a6 <memmove+0x69>
c0105964:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105967:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010596a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010596d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105970:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105973:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105976:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105979:	c1 e8 02             	shr    $0x2,%eax
c010597c:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010597e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105981:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105984:	89 d7                	mov    %edx,%edi
c0105986:	89 c6                	mov    %eax,%esi
c0105988:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010598a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010598d:	83 e1 03             	and    $0x3,%ecx
c0105990:	74 02                	je     c0105994 <memmove+0x57>
c0105992:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105994:	89 f0                	mov    %esi,%eax
c0105996:	89 fa                	mov    %edi,%edx
c0105998:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010599b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010599e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01059a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c01059a4:	eb 36                	jmp    c01059dc <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01059a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059a9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059af:	01 c2                	add    %eax,%edx
c01059b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059b4:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01059b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059ba:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01059bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059c0:	89 c1                	mov    %eax,%ecx
c01059c2:	89 d8                	mov    %ebx,%eax
c01059c4:	89 d6                	mov    %edx,%esi
c01059c6:	89 c7                	mov    %eax,%edi
c01059c8:	fd                   	std    
c01059c9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01059cb:	fc                   	cld    
c01059cc:	89 f8                	mov    %edi,%eax
c01059ce:	89 f2                	mov    %esi,%edx
c01059d0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01059d3:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01059d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01059d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01059dc:	83 c4 30             	add    $0x30,%esp
c01059df:	5b                   	pop    %ebx
c01059e0:	5e                   	pop    %esi
c01059e1:	5f                   	pop    %edi
c01059e2:	5d                   	pop    %ebp
c01059e3:	c3                   	ret    

c01059e4 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01059e4:	f3 0f 1e fb          	endbr32 
c01059e8:	55                   	push   %ebp
c01059e9:	89 e5                	mov    %esp,%ebp
c01059eb:	57                   	push   %edi
c01059ec:	56                   	push   %esi
c01059ed:	83 ec 20             	sub    $0x20,%esp
c01059f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01059ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a05:	c1 e8 02             	shr    $0x2,%eax
c0105a08:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a10:	89 d7                	mov    %edx,%edi
c0105a12:	89 c6                	mov    %eax,%esi
c0105a14:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105a16:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105a19:	83 e1 03             	and    $0x3,%ecx
c0105a1c:	74 02                	je     c0105a20 <memcpy+0x3c>
c0105a1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105a20:	89 f0                	mov    %esi,%eax
c0105a22:	89 fa                	mov    %edi,%edx
c0105a24:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a27:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105a30:	83 c4 20             	add    $0x20,%esp
c0105a33:	5e                   	pop    %esi
c0105a34:	5f                   	pop    %edi
c0105a35:	5d                   	pop    %ebp
c0105a36:	c3                   	ret    

c0105a37 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105a37:	f3 0f 1e fb          	endbr32 
c0105a3b:	55                   	push   %ebp
c0105a3c:	89 e5                	mov    %esp,%ebp
c0105a3e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105a41:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a44:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105a47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105a4d:	eb 2e                	jmp    c0105a7d <memcmp+0x46>
        if (*s1 != *s2) {
c0105a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a52:	0f b6 10             	movzbl (%eax),%edx
c0105a55:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a58:	0f b6 00             	movzbl (%eax),%eax
c0105a5b:	38 c2                	cmp    %al,%dl
c0105a5d:	74 18                	je     c0105a77 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a62:	0f b6 00             	movzbl (%eax),%eax
c0105a65:	0f b6 d0             	movzbl %al,%edx
c0105a68:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a6b:	0f b6 00             	movzbl (%eax),%eax
c0105a6e:	0f b6 c0             	movzbl %al,%eax
c0105a71:	29 c2                	sub    %eax,%edx
c0105a73:	89 d0                	mov    %edx,%eax
c0105a75:	eb 18                	jmp    c0105a8f <memcmp+0x58>
        }
        s1 ++, s2 ++;
c0105a77:	ff 45 fc             	incl   -0x4(%ebp)
c0105a7a:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105a7d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a80:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a83:	89 55 10             	mov    %edx,0x10(%ebp)
c0105a86:	85 c0                	test   %eax,%eax
c0105a88:	75 c5                	jne    c0105a4f <memcmp+0x18>
    }
    return 0;
c0105a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a8f:	c9                   	leave  
c0105a90:	c3                   	ret    

c0105a91 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105a91:	f3 0f 1e fb          	endbr32 
c0105a95:	55                   	push   %ebp
c0105a96:	89 e5                	mov    %esp,%ebp
c0105a98:	83 ec 58             	sub    $0x58,%esp
c0105a9b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105aa1:	8b 45 14             	mov    0x14(%ebp),%eax
c0105aa4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105aa7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105aaa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105aad:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ab0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105ab3:	8b 45 18             	mov    0x18(%ebp),%eax
c0105ab6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105abc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105abf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ac2:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105acb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105acf:	74 1c                	je     c0105aed <printnum+0x5c>
c0105ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ad4:	ba 00 00 00 00       	mov    $0x0,%edx
c0105ad9:	f7 75 e4             	divl   -0x1c(%ebp)
c0105adc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ae2:	ba 00 00 00 00       	mov    $0x0,%edx
c0105ae7:	f7 75 e4             	divl   -0x1c(%ebp)
c0105aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105af3:	f7 75 e4             	divl   -0x1c(%ebp)
c0105af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105af9:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105afc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105aff:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b02:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b05:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105b08:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b0b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105b0e:	8b 45 18             	mov    0x18(%ebp),%eax
c0105b11:	ba 00 00 00 00       	mov    $0x0,%edx
c0105b16:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105b19:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105b1c:	19 d1                	sbb    %edx,%ecx
c0105b1e:	72 4c                	jb     c0105b6c <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105b20:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105b23:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b26:	8b 45 20             	mov    0x20(%ebp),%eax
c0105b29:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105b2d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105b31:	8b 45 18             	mov    0x18(%ebp),%eax
c0105b34:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105b38:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105b3e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b42:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105b46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b50:	89 04 24             	mov    %eax,(%esp)
c0105b53:	e8 39 ff ff ff       	call   c0105a91 <printnum>
c0105b58:	eb 1b                	jmp    c0105b75 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b61:	8b 45 20             	mov    0x20(%ebp),%eax
c0105b64:	89 04 24             	mov    %eax,(%esp)
c0105b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b6a:	ff d0                	call   *%eax
        while (-- width > 0)
c0105b6c:	ff 4d 1c             	decl   0x1c(%ebp)
c0105b6f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105b73:	7f e5                	jg     c0105b5a <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105b75:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105b78:	05 e4 72 10 c0       	add    $0xc01072e4,%eax
c0105b7d:	0f b6 00             	movzbl (%eax),%eax
c0105b80:	0f be c0             	movsbl %al,%eax
c0105b83:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b86:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b8a:	89 04 24             	mov    %eax,(%esp)
c0105b8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b90:	ff d0                	call   *%eax
}
c0105b92:	90                   	nop
c0105b93:	c9                   	leave  
c0105b94:	c3                   	ret    

c0105b95 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105b95:	f3 0f 1e fb          	endbr32 
c0105b99:	55                   	push   %ebp
c0105b9a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105b9c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105ba0:	7e 14                	jle    c0105bb6 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
c0105ba2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba5:	8b 00                	mov    (%eax),%eax
c0105ba7:	8d 48 08             	lea    0x8(%eax),%ecx
c0105baa:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bad:	89 0a                	mov    %ecx,(%edx)
c0105baf:	8b 50 04             	mov    0x4(%eax),%edx
c0105bb2:	8b 00                	mov    (%eax),%eax
c0105bb4:	eb 30                	jmp    c0105be6 <getuint+0x51>
    }
    else if (lflag) {
c0105bb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105bba:	74 16                	je     c0105bd2 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
c0105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbf:	8b 00                	mov    (%eax),%eax
c0105bc1:	8d 48 04             	lea    0x4(%eax),%ecx
c0105bc4:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bc7:	89 0a                	mov    %ecx,(%edx)
c0105bc9:	8b 00                	mov    (%eax),%eax
c0105bcb:	ba 00 00 00 00       	mov    $0x0,%edx
c0105bd0:	eb 14                	jmp    c0105be6 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105bd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd5:	8b 00                	mov    (%eax),%eax
c0105bd7:	8d 48 04             	lea    0x4(%eax),%ecx
c0105bda:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bdd:	89 0a                	mov    %ecx,(%edx)
c0105bdf:	8b 00                	mov    (%eax),%eax
c0105be1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105be6:	5d                   	pop    %ebp
c0105be7:	c3                   	ret    

c0105be8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105be8:	f3 0f 1e fb          	endbr32 
c0105bec:	55                   	push   %ebp
c0105bed:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105bef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105bf3:	7e 14                	jle    c0105c09 <getint+0x21>
        return va_arg(*ap, long long);
c0105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf8:	8b 00                	mov    (%eax),%eax
c0105bfa:	8d 48 08             	lea    0x8(%eax),%ecx
c0105bfd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c00:	89 0a                	mov    %ecx,(%edx)
c0105c02:	8b 50 04             	mov    0x4(%eax),%edx
c0105c05:	8b 00                	mov    (%eax),%eax
c0105c07:	eb 28                	jmp    c0105c31 <getint+0x49>
    }
    else if (lflag) {
c0105c09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c0d:	74 12                	je     c0105c21 <getint+0x39>
        return va_arg(*ap, long);
c0105c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c12:	8b 00                	mov    (%eax),%eax
c0105c14:	8d 48 04             	lea    0x4(%eax),%ecx
c0105c17:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c1a:	89 0a                	mov    %ecx,(%edx)
c0105c1c:	8b 00                	mov    (%eax),%eax
c0105c1e:	99                   	cltd   
c0105c1f:	eb 10                	jmp    c0105c31 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
c0105c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c24:	8b 00                	mov    (%eax),%eax
c0105c26:	8d 48 04             	lea    0x4(%eax),%ecx
c0105c29:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c2c:	89 0a                	mov    %ecx,(%edx)
c0105c2e:	8b 00                	mov    (%eax),%eax
c0105c30:	99                   	cltd   
    }
}
c0105c31:	5d                   	pop    %ebp
c0105c32:	c3                   	ret    

c0105c33 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105c33:	f3 0f 1e fb          	endbr32 
c0105c37:	55                   	push   %ebp
c0105c38:	89 e5                	mov    %esp,%ebp
c0105c3a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105c3d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c46:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c4a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c4d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5b:	89 04 24             	mov    %eax,(%esp)
c0105c5e:	e8 03 00 00 00       	call   c0105c66 <vprintfmt>
    va_end(ap);
}
c0105c63:	90                   	nop
c0105c64:	c9                   	leave  
c0105c65:	c3                   	ret    

c0105c66 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105c66:	f3 0f 1e fb          	endbr32 
c0105c6a:	55                   	push   %ebp
c0105c6b:	89 e5                	mov    %esp,%ebp
c0105c6d:	56                   	push   %esi
c0105c6e:	53                   	push   %ebx
c0105c6f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105c72:	eb 17                	jmp    c0105c8b <vprintfmt+0x25>
            if (ch == '\0') {
c0105c74:	85 db                	test   %ebx,%ebx
c0105c76:	0f 84 c0 03 00 00    	je     c010603c <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
c0105c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c83:	89 1c 24             	mov    %ebx,(%esp)
c0105c86:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c89:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105c8b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c8e:	8d 50 01             	lea    0x1(%eax),%edx
c0105c91:	89 55 10             	mov    %edx,0x10(%ebp)
c0105c94:	0f b6 00             	movzbl (%eax),%eax
c0105c97:	0f b6 d8             	movzbl %al,%ebx
c0105c9a:	83 fb 25             	cmp    $0x25,%ebx
c0105c9d:	75 d5                	jne    c0105c74 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105c9f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105ca3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105caa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105cad:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105cb0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105cb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105cba:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105cbd:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cc0:	8d 50 01             	lea    0x1(%eax),%edx
c0105cc3:	89 55 10             	mov    %edx,0x10(%ebp)
c0105cc6:	0f b6 00             	movzbl (%eax),%eax
c0105cc9:	0f b6 d8             	movzbl %al,%ebx
c0105ccc:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105ccf:	83 f8 55             	cmp    $0x55,%eax
c0105cd2:	0f 87 38 03 00 00    	ja     c0106010 <vprintfmt+0x3aa>
c0105cd8:	8b 04 85 08 73 10 c0 	mov    -0x3fef8cf8(,%eax,4),%eax
c0105cdf:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105ce2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105ce6:	eb d5                	jmp    c0105cbd <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105ce8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105cec:	eb cf                	jmp    c0105cbd <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105cee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105cf5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105cf8:	89 d0                	mov    %edx,%eax
c0105cfa:	c1 e0 02             	shl    $0x2,%eax
c0105cfd:	01 d0                	add    %edx,%eax
c0105cff:	01 c0                	add    %eax,%eax
c0105d01:	01 d8                	add    %ebx,%eax
c0105d03:	83 e8 30             	sub    $0x30,%eax
c0105d06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105d09:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d0c:	0f b6 00             	movzbl (%eax),%eax
c0105d0f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105d12:	83 fb 2f             	cmp    $0x2f,%ebx
c0105d15:	7e 38                	jle    c0105d4f <vprintfmt+0xe9>
c0105d17:	83 fb 39             	cmp    $0x39,%ebx
c0105d1a:	7f 33                	jg     c0105d4f <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
c0105d1c:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105d1f:	eb d4                	jmp    c0105cf5 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105d21:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d24:	8d 50 04             	lea    0x4(%eax),%edx
c0105d27:	89 55 14             	mov    %edx,0x14(%ebp)
c0105d2a:	8b 00                	mov    (%eax),%eax
c0105d2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105d2f:	eb 1f                	jmp    c0105d50 <vprintfmt+0xea>

        case '.':
            if (width < 0)
c0105d31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105d35:	79 86                	jns    c0105cbd <vprintfmt+0x57>
                width = 0;
c0105d37:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105d3e:	e9 7a ff ff ff       	jmp    c0105cbd <vprintfmt+0x57>

        case '#':
            altflag = 1;
c0105d43:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105d4a:	e9 6e ff ff ff       	jmp    c0105cbd <vprintfmt+0x57>
            goto process_precision;
c0105d4f:	90                   	nop

        process_precision:
            if (width < 0)
c0105d50:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105d54:	0f 89 63 ff ff ff    	jns    c0105cbd <vprintfmt+0x57>
                width = precision, precision = -1;
c0105d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105d60:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105d67:	e9 51 ff ff ff       	jmp    c0105cbd <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105d6c:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105d6f:	e9 49 ff ff ff       	jmp    c0105cbd <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105d74:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d77:	8d 50 04             	lea    0x4(%eax),%edx
c0105d7a:	89 55 14             	mov    %edx,0x14(%ebp)
c0105d7d:	8b 00                	mov    (%eax),%eax
c0105d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105d82:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d86:	89 04 24             	mov    %eax,(%esp)
c0105d89:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8c:	ff d0                	call   *%eax
            break;
c0105d8e:	e9 a4 02 00 00       	jmp    c0106037 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105d93:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d96:	8d 50 04             	lea    0x4(%eax),%edx
c0105d99:	89 55 14             	mov    %edx,0x14(%ebp)
c0105d9c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105d9e:	85 db                	test   %ebx,%ebx
c0105da0:	79 02                	jns    c0105da4 <vprintfmt+0x13e>
                err = -err;
c0105da2:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105da4:	83 fb 06             	cmp    $0x6,%ebx
c0105da7:	7f 0b                	jg     c0105db4 <vprintfmt+0x14e>
c0105da9:	8b 34 9d c8 72 10 c0 	mov    -0x3fef8d38(,%ebx,4),%esi
c0105db0:	85 f6                	test   %esi,%esi
c0105db2:	75 23                	jne    c0105dd7 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
c0105db4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105db8:	c7 44 24 08 f5 72 10 	movl   $0xc01072f5,0x8(%esp)
c0105dbf:	c0 
c0105dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dca:	89 04 24             	mov    %eax,(%esp)
c0105dcd:	e8 61 fe ff ff       	call   c0105c33 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105dd2:	e9 60 02 00 00       	jmp    c0106037 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
c0105dd7:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105ddb:	c7 44 24 08 fe 72 10 	movl   $0xc01072fe,0x8(%esp)
c0105de2:	c0 
c0105de3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105de6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dea:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ded:	89 04 24             	mov    %eax,(%esp)
c0105df0:	e8 3e fe ff ff       	call   c0105c33 <printfmt>
            break;
c0105df5:	e9 3d 02 00 00       	jmp    c0106037 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105dfa:	8b 45 14             	mov    0x14(%ebp),%eax
c0105dfd:	8d 50 04             	lea    0x4(%eax),%edx
c0105e00:	89 55 14             	mov    %edx,0x14(%ebp)
c0105e03:	8b 30                	mov    (%eax),%esi
c0105e05:	85 f6                	test   %esi,%esi
c0105e07:	75 05                	jne    c0105e0e <vprintfmt+0x1a8>
                p = "(null)";
c0105e09:	be 01 73 10 c0       	mov    $0xc0107301,%esi
            }
            if (width > 0 && padc != '-') {
c0105e0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105e12:	7e 76                	jle    c0105e8a <vprintfmt+0x224>
c0105e14:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105e18:	74 70                	je     c0105e8a <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e21:	89 34 24             	mov    %esi,(%esp)
c0105e24:	e8 ba f7 ff ff       	call   c01055e3 <strnlen>
c0105e29:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105e2c:	29 c2                	sub    %eax,%edx
c0105e2e:	89 d0                	mov    %edx,%eax
c0105e30:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105e33:	eb 16                	jmp    c0105e4b <vprintfmt+0x1e5>
                    putch(padc, putdat);
c0105e35:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105e39:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105e3c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e40:	89 04 24             	mov    %eax,(%esp)
c0105e43:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e46:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105e48:	ff 4d e8             	decl   -0x18(%ebp)
c0105e4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105e4f:	7f e4                	jg     c0105e35 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105e51:	eb 37                	jmp    c0105e8a <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105e53:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105e57:	74 1f                	je     c0105e78 <vprintfmt+0x212>
c0105e59:	83 fb 1f             	cmp    $0x1f,%ebx
c0105e5c:	7e 05                	jle    c0105e63 <vprintfmt+0x1fd>
c0105e5e:	83 fb 7e             	cmp    $0x7e,%ebx
c0105e61:	7e 15                	jle    c0105e78 <vprintfmt+0x212>
                    putch('?', putdat);
c0105e63:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e6a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105e71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e74:	ff d0                	call   *%eax
c0105e76:	eb 0f                	jmp    c0105e87 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
c0105e78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e7f:	89 1c 24             	mov    %ebx,(%esp)
c0105e82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e85:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105e87:	ff 4d e8             	decl   -0x18(%ebp)
c0105e8a:	89 f0                	mov    %esi,%eax
c0105e8c:	8d 70 01             	lea    0x1(%eax),%esi
c0105e8f:	0f b6 00             	movzbl (%eax),%eax
c0105e92:	0f be d8             	movsbl %al,%ebx
c0105e95:	85 db                	test   %ebx,%ebx
c0105e97:	74 27                	je     c0105ec0 <vprintfmt+0x25a>
c0105e99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e9d:	78 b4                	js     c0105e53 <vprintfmt+0x1ed>
c0105e9f:	ff 4d e4             	decl   -0x1c(%ebp)
c0105ea2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105ea6:	79 ab                	jns    c0105e53 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
c0105ea8:	eb 16                	jmp    c0105ec0 <vprintfmt+0x25a>
                putch(' ', putdat);
c0105eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ead:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105eb1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105eb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ebb:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105ebd:	ff 4d e8             	decl   -0x18(%ebp)
c0105ec0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105ec4:	7f e4                	jg     c0105eaa <vprintfmt+0x244>
            }
            break;
c0105ec6:	e9 6c 01 00 00       	jmp    c0106037 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105ecb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ece:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ed2:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ed5:	89 04 24             	mov    %eax,(%esp)
c0105ed8:	e8 0b fd ff ff       	call   c0105be8 <getint>
c0105edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ee0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ee9:	85 d2                	test   %edx,%edx
c0105eeb:	79 26                	jns    c0105f13 <vprintfmt+0x2ad>
                putch('-', putdat);
c0105eed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ef4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105efb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105efe:	ff d0                	call   *%eax
                num = -(long long)num;
c0105f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f06:	f7 d8                	neg    %eax
c0105f08:	83 d2 00             	adc    $0x0,%edx
c0105f0b:	f7 da                	neg    %edx
c0105f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f10:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105f13:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105f1a:	e9 a8 00 00 00       	jmp    c0105fc7 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105f1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f26:	8d 45 14             	lea    0x14(%ebp),%eax
c0105f29:	89 04 24             	mov    %eax,(%esp)
c0105f2c:	e8 64 fc ff ff       	call   c0105b95 <getuint>
c0105f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f34:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105f37:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105f3e:	e9 84 00 00 00       	jmp    c0105fc7 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f4a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105f4d:	89 04 24             	mov    %eax,(%esp)
c0105f50:	e8 40 fc ff ff       	call   c0105b95 <getuint>
c0105f55:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f58:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105f5b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105f62:	eb 63                	jmp    c0105fc7 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
c0105f64:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f6b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105f72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f75:	ff d0                	call   *%eax
            putch('x', putdat);
c0105f77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f7e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105f85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f88:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105f8a:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f8d:	8d 50 04             	lea    0x4(%eax),%edx
c0105f90:	89 55 14             	mov    %edx,0x14(%ebp)
c0105f93:	8b 00                	mov    (%eax),%eax
c0105f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105f9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105fa6:	eb 1f                	jmp    c0105fc7 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105faf:	8d 45 14             	lea    0x14(%ebp),%eax
c0105fb2:	89 04 24             	mov    %eax,(%esp)
c0105fb5:	e8 db fb ff ff       	call   c0105b95 <getuint>
c0105fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105fc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105fc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fce:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105fd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105fd5:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105fd9:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fe0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105fe3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105fe7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105feb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ff2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ff5:	89 04 24             	mov    %eax,(%esp)
c0105ff8:	e8 94 fa ff ff       	call   c0105a91 <printnum>
            break;
c0105ffd:	eb 38                	jmp    c0106037 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105fff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106002:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106006:	89 1c 24             	mov    %ebx,(%esp)
c0106009:	8b 45 08             	mov    0x8(%ebp),%eax
c010600c:	ff d0                	call   *%eax
            break;
c010600e:	eb 27                	jmp    c0106037 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106010:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106013:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106017:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010601e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106021:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106023:	ff 4d 10             	decl   0x10(%ebp)
c0106026:	eb 03                	jmp    c010602b <vprintfmt+0x3c5>
c0106028:	ff 4d 10             	decl   0x10(%ebp)
c010602b:	8b 45 10             	mov    0x10(%ebp),%eax
c010602e:	48                   	dec    %eax
c010602f:	0f b6 00             	movzbl (%eax),%eax
c0106032:	3c 25                	cmp    $0x25,%al
c0106034:	75 f2                	jne    c0106028 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
c0106036:	90                   	nop
    while (1) {
c0106037:	e9 36 fc ff ff       	jmp    c0105c72 <vprintfmt+0xc>
                return;
c010603c:	90                   	nop
        }
    }
}
c010603d:	83 c4 40             	add    $0x40,%esp
c0106040:	5b                   	pop    %ebx
c0106041:	5e                   	pop    %esi
c0106042:	5d                   	pop    %ebp
c0106043:	c3                   	ret    

c0106044 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106044:	f3 0f 1e fb          	endbr32 
c0106048:	55                   	push   %ebp
c0106049:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010604b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010604e:	8b 40 08             	mov    0x8(%eax),%eax
c0106051:	8d 50 01             	lea    0x1(%eax),%edx
c0106054:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106057:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010605a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010605d:	8b 10                	mov    (%eax),%edx
c010605f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106062:	8b 40 04             	mov    0x4(%eax),%eax
c0106065:	39 c2                	cmp    %eax,%edx
c0106067:	73 12                	jae    c010607b <sprintputch+0x37>
        *b->buf ++ = ch;
c0106069:	8b 45 0c             	mov    0xc(%ebp),%eax
c010606c:	8b 00                	mov    (%eax),%eax
c010606e:	8d 48 01             	lea    0x1(%eax),%ecx
c0106071:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106074:	89 0a                	mov    %ecx,(%edx)
c0106076:	8b 55 08             	mov    0x8(%ebp),%edx
c0106079:	88 10                	mov    %dl,(%eax)
    }
}
c010607b:	90                   	nop
c010607c:	5d                   	pop    %ebp
c010607d:	c3                   	ret    

c010607e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010607e:	f3 0f 1e fb          	endbr32 
c0106082:	55                   	push   %ebp
c0106083:	89 e5                	mov    %esp,%ebp
c0106085:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106088:	8d 45 14             	lea    0x14(%ebp),%eax
c010608b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010608e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106091:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106095:	8b 45 10             	mov    0x10(%ebp),%eax
c0106098:	89 44 24 08          	mov    %eax,0x8(%esp)
c010609c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010609f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01060a6:	89 04 24             	mov    %eax,(%esp)
c01060a9:	e8 08 00 00 00       	call   c01060b6 <vsnprintf>
c01060ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01060b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01060b4:	c9                   	leave  
c01060b5:	c3                   	ret    

c01060b6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01060b6:	f3 0f 1e fb          	endbr32 
c01060ba:	55                   	push   %ebp
c01060bb:	89 e5                	mov    %esp,%ebp
c01060bd:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01060c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01060c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01060c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060c9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01060cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01060cf:	01 d0                	add    %edx,%eax
c01060d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01060db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01060df:	74 0a                	je     c01060eb <vsnprintf+0x35>
c01060e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01060e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060e7:	39 c2                	cmp    %eax,%edx
c01060e9:	76 07                	jbe    c01060f2 <vsnprintf+0x3c>
        return -E_INVAL;
c01060eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01060f0:	eb 2a                	jmp    c010611c <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01060f2:	8b 45 14             	mov    0x14(%ebp),%eax
c01060f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01060fc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106100:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0106103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106107:	c7 04 24 44 60 10 c0 	movl   $0xc0106044,(%esp)
c010610e:	e8 53 fb ff ff       	call   c0105c66 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0106113:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106116:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106119:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010611c:	c9                   	leave  
c010611d:	c3                   	ret    
