
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 a0 11 40       	mov    $0x4011a000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 a0 11 00       	mov    %eax,0x11a000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 90 11 00       	mov    $0x119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	f3 0f 1e fb          	endbr32 
  10003a:	55                   	push   %ebp
  10003b:	89 e5                	mov    %esp,%ebp
  10003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100040:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  100045:	2d 36 9a 11 00       	sub    $0x119a36,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 9a 11 00 	movl   $0x119a36,(%esp)
  10005d:	e8 98 58 00 00       	call   1058fa <memset>

    cons_init();                // init the console
  100062:	e8 44 16 00 00       	call   1016ab <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 20 61 10 00 	movl   $0x106120,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 3c 61 10 00 	movl   $0x10613c,(%esp)
  10007c:	e8 39 02 00 00       	call   1002ba <cprintf>

    print_kerninfo();
  100081:	e8 f7 08 00 00       	call   10097d <print_kerninfo>

    grade_backtrace();
  100086:	e8 95 00 00 00       	call   100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 dc 31 00 00       	call   10326c <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 91 17 00 00       	call   101826 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 36 19 00 00       	call   1019d0 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 53 0d 00 00       	call   100df2 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 ce 18 00 00       	call   101972 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	f3 0f 1e fb          	endbr32 
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b7:	00 
  1000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bf:	00 
  1000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c7:	e8 10 0d 00 00       	call   100ddc <mon_backtrace>
}
  1000cc:	90                   	nop
  1000cd:	c9                   	leave  
  1000ce:	c3                   	ret    

001000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000cf:	f3 0f 1e fb          	endbr32 
  1000d3:	55                   	push   %ebp
  1000d4:	89 e5                	mov    %esp,%ebp
  1000d6:	53                   	push   %ebx
  1000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000f2:	89 04 24             	mov    %eax,(%esp)
  1000f5:	e8 ac ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000fa:	90                   	nop
  1000fb:	83 c4 14             	add    $0x14,%esp
  1000fe:	5b                   	pop    %ebx
  1000ff:	5d                   	pop    %ebp
  100100:	c3                   	ret    

00100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100101:	f3 0f 1e fb          	endbr32 
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  10010b:	8b 45 10             	mov    0x10(%ebp),%eax
  10010e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100112:	8b 45 08             	mov    0x8(%ebp),%eax
  100115:	89 04 24             	mov    %eax,(%esp)
  100118:	e8 b2 ff ff ff       	call   1000cf <grade_backtrace1>
}
  10011d:	90                   	nop
  10011e:	c9                   	leave  
  10011f:	c3                   	ret    

00100120 <grade_backtrace>:

void
grade_backtrace(void) {
  100120:	f3 0f 1e fb          	endbr32 
  100124:	55                   	push   %ebp
  100125:	89 e5                	mov    %esp,%ebp
  100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10012a:	b8 36 00 10 00       	mov    $0x100036,%eax
  10012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100136:	ff 
  100137:	89 44 24 04          	mov    %eax,0x4(%esp)
  10013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100142:	e8 ba ff ff ff       	call   100101 <grade_backtrace0>
}
  100147:	90                   	nop
  100148:	c9                   	leave  
  100149:	c3                   	ret    

0010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10014a:	f3 0f 1e fb          	endbr32 
  10014e:	55                   	push   %ebp
  10014f:	89 e5                	mov    %esp,%ebp
  100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100164:	83 e0 03             	and    $0x3,%eax
  100167:	89 c2                	mov    %eax,%edx
  100169:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10016e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100172:	89 44 24 04          	mov    %eax,0x4(%esp)
  100176:	c7 04 24 41 61 10 00 	movl   $0x106141,(%esp)
  10017d:	e8 38 01 00 00       	call   1002ba <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100186:	89 c2                	mov    %eax,%edx
  100188:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 4f 61 10 00 	movl   $0x10614f,(%esp)
  10019c:	e8 19 01 00 00       	call   1002ba <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001a5:	89 c2                	mov    %eax,%edx
  1001a7:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b4:	c7 04 24 5d 61 10 00 	movl   $0x10615d,(%esp)
  1001bb:	e8 fa 00 00 00       	call   1002ba <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c4:	89 c2                	mov    %eax,%edx
  1001c6:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d3:	c7 04 24 6b 61 10 00 	movl   $0x10616b,(%esp)
  1001da:	e8 db 00 00 00       	call   1002ba <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e3:	89 c2                	mov    %eax,%edx
  1001e5:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f2:	c7 04 24 79 61 10 00 	movl   $0x106179,(%esp)
  1001f9:	e8 bc 00 00 00       	call   1002ba <cprintf>
    round ++;
  1001fe:	a1 00 c0 11 00       	mov    0x11c000,%eax
  100203:	40                   	inc    %eax
  100204:	a3 00 c0 11 00       	mov    %eax,0x11c000
}
  100209:	90                   	nop
  10020a:	c9                   	leave  
  10020b:	c3                   	ret    

0010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10020c:	f3 0f 1e fb          	endbr32 
  100210:	55                   	push   %ebp
  100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  100213:	90                   	nop
  100214:	5d                   	pop    %ebp
  100215:	c3                   	ret    

00100216 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100216:	f3 0f 1e fb          	endbr32 
  10021a:	55                   	push   %ebp
  10021b:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  10021d:	90                   	nop
  10021e:	5d                   	pop    %ebp
  10021f:	c3                   	ret    

00100220 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100220:	f3 0f 1e fb          	endbr32 
  100224:	55                   	push   %ebp
  100225:	89 e5                	mov    %esp,%ebp
  100227:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10022a:	e8 1b ff ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10022f:	c7 04 24 88 61 10 00 	movl   $0x106188,(%esp)
  100236:	e8 7f 00 00 00       	call   1002ba <cprintf>
    lab1_switch_to_user();
  10023b:	e8 cc ff ff ff       	call   10020c <lab1_switch_to_user>
    lab1_print_cur_status();
  100240:	e8 05 ff ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100245:	c7 04 24 a8 61 10 00 	movl   $0x1061a8,(%esp)
  10024c:	e8 69 00 00 00       	call   1002ba <cprintf>
    lab1_switch_to_kernel();
  100251:	e8 c0 ff ff ff       	call   100216 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100256:	e8 ef fe ff ff       	call   10014a <lab1_print_cur_status>
}
  10025b:	90                   	nop
  10025c:	c9                   	leave  
  10025d:	c3                   	ret    

0010025e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10025e:	f3 0f 1e fb          	endbr32 
  100262:	55                   	push   %ebp
  100263:	89 e5                	mov    %esp,%ebp
  100265:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100268:	8b 45 08             	mov    0x8(%ebp),%eax
  10026b:	89 04 24             	mov    %eax,(%esp)
  10026e:	e8 69 14 00 00       	call   1016dc <cons_putc>
    (*cnt) ++;
  100273:	8b 45 0c             	mov    0xc(%ebp),%eax
  100276:	8b 00                	mov    (%eax),%eax
  100278:	8d 50 01             	lea    0x1(%eax),%edx
  10027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10027e:	89 10                	mov    %edx,(%eax)
}
  100280:	90                   	nop
  100281:	c9                   	leave  
  100282:	c3                   	ret    

00100283 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100283:	f3 0f 1e fb          	endbr32 
  100287:	55                   	push   %ebp
  100288:	89 e5                	mov    %esp,%ebp
  10028a:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10028d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100294:	8b 45 0c             	mov    0xc(%ebp),%eax
  100297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10029b:	8b 45 08             	mov    0x8(%ebp),%eax
  10029e:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a9:	c7 04 24 5e 02 10 00 	movl   $0x10025e,(%esp)
  1002b0:	e8 b1 59 00 00       	call   105c66 <vprintfmt>
    return cnt;
  1002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002b8:	c9                   	leave  
  1002b9:	c3                   	ret    

001002ba <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002ba:	f3 0f 1e fb          	endbr32 
  1002be:	55                   	push   %ebp
  1002bf:	89 e5                	mov    %esp,%ebp
  1002c1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002c4:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d4:	89 04 24             	mov    %eax,(%esp)
  1002d7:	e8 a7 ff ff ff       	call   100283 <vcprintf>
  1002dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002e2:	c9                   	leave  
  1002e3:	c3                   	ret    

001002e4 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002e4:	f3 0f 1e fb          	endbr32 
  1002e8:	55                   	push   %ebp
  1002e9:	89 e5                	mov    %esp,%ebp
  1002eb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f1:	89 04 24             	mov    %eax,(%esp)
  1002f4:	e8 e3 13 00 00       	call   1016dc <cons_putc>
}
  1002f9:	90                   	nop
  1002fa:	c9                   	leave  
  1002fb:	c3                   	ret    

001002fc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002fc:	f3 0f 1e fb          	endbr32 
  100300:	55                   	push   %ebp
  100301:	89 e5                	mov    %esp,%ebp
  100303:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100306:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10030d:	eb 13                	jmp    100322 <cputs+0x26>
        cputch(c, &cnt);
  10030f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100313:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100316:	89 54 24 04          	mov    %edx,0x4(%esp)
  10031a:	89 04 24             	mov    %eax,(%esp)
  10031d:	e8 3c ff ff ff       	call   10025e <cputch>
    while ((c = *str ++) != '\0') {
  100322:	8b 45 08             	mov    0x8(%ebp),%eax
  100325:	8d 50 01             	lea    0x1(%eax),%edx
  100328:	89 55 08             	mov    %edx,0x8(%ebp)
  10032b:	0f b6 00             	movzbl (%eax),%eax
  10032e:	88 45 f7             	mov    %al,-0x9(%ebp)
  100331:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100335:	75 d8                	jne    10030f <cputs+0x13>
    }
    cputch('\n', &cnt);
  100337:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10033a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10033e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100345:	e8 14 ff ff ff       	call   10025e <cputch>
    return cnt;
  10034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10034d:	c9                   	leave  
  10034e:	c3                   	ret    

0010034f <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10034f:	f3 0f 1e fb          	endbr32 
  100353:	55                   	push   %ebp
  100354:	89 e5                	mov    %esp,%ebp
  100356:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100359:	90                   	nop
  10035a:	e8 be 13 00 00       	call   10171d <cons_getc>
  10035f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100366:	74 f2                	je     10035a <getchar+0xb>
        /* do nothing */;
    return c;
  100368:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036b:	c9                   	leave  
  10036c:	c3                   	ret    

0010036d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10036d:	f3 0f 1e fb          	endbr32 
  100371:	55                   	push   %ebp
  100372:	89 e5                	mov    %esp,%ebp
  100374:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100377:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10037b:	74 13                	je     100390 <readline+0x23>
        cprintf("%s", prompt);
  10037d:	8b 45 08             	mov    0x8(%ebp),%eax
  100380:	89 44 24 04          	mov    %eax,0x4(%esp)
  100384:	c7 04 24 c7 61 10 00 	movl   $0x1061c7,(%esp)
  10038b:	e8 2a ff ff ff       	call   1002ba <cprintf>
    }
    int i = 0, c;
  100390:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100397:	e8 b3 ff ff ff       	call   10034f <getchar>
  10039c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10039f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1003a3:	79 07                	jns    1003ac <readline+0x3f>
            return NULL;
  1003a5:	b8 00 00 00 00       	mov    $0x0,%eax
  1003aa:	eb 78                	jmp    100424 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  1003ac:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  1003b0:	7e 28                	jle    1003da <readline+0x6d>
  1003b2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003b9:	7f 1f                	jg     1003da <readline+0x6d>
            cputchar(c);
  1003bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003be:	89 04 24             	mov    %eax,(%esp)
  1003c1:	e8 1e ff ff ff       	call   1002e4 <cputchar>
            buf[i ++] = c;
  1003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003c9:	8d 50 01             	lea    0x1(%eax),%edx
  1003cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003d2:	88 90 20 c0 11 00    	mov    %dl,0x11c020(%eax)
  1003d8:	eb 45                	jmp    10041f <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003da:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003de:	75 16                	jne    1003f6 <readline+0x89>
  1003e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e4:	7e 10                	jle    1003f6 <readline+0x89>
            cputchar(c);
  1003e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003e9:	89 04 24             	mov    %eax,(%esp)
  1003ec:	e8 f3 fe ff ff       	call   1002e4 <cputchar>
            i --;
  1003f1:	ff 4d f4             	decl   -0xc(%ebp)
  1003f4:	eb 29                	jmp    10041f <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003f6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003fa:	74 06                	je     100402 <readline+0x95>
  1003fc:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100400:	75 95                	jne    100397 <readline+0x2a>
            cputchar(c);
  100402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100405:	89 04 24             	mov    %eax,(%esp)
  100408:	e8 d7 fe ff ff       	call   1002e4 <cputchar>
            buf[i] = '\0';
  10040d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100410:	05 20 c0 11 00       	add    $0x11c020,%eax
  100415:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100418:	b8 20 c0 11 00       	mov    $0x11c020,%eax
  10041d:	eb 05                	jmp    100424 <readline+0xb7>
        c = getchar();
  10041f:	e9 73 ff ff ff       	jmp    100397 <readline+0x2a>
        }
    }
}
  100424:	c9                   	leave  
  100425:	c3                   	ret    

00100426 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100426:	f3 0f 1e fb          	endbr32 
  10042a:	55                   	push   %ebp
  10042b:	89 e5                	mov    %esp,%ebp
  10042d:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100430:	a1 20 c4 11 00       	mov    0x11c420,%eax
  100435:	85 c0                	test   %eax,%eax
  100437:	75 5b                	jne    100494 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100439:	c7 05 20 c4 11 00 01 	movl   $0x1,0x11c420
  100440:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100443:	8d 45 14             	lea    0x14(%ebp),%eax
  100446:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100449:	8b 45 0c             	mov    0xc(%ebp),%eax
  10044c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100450:	8b 45 08             	mov    0x8(%ebp),%eax
  100453:	89 44 24 04          	mov    %eax,0x4(%esp)
  100457:	c7 04 24 ca 61 10 00 	movl   $0x1061ca,(%esp)
  10045e:	e8 57 fe ff ff       	call   1002ba <cprintf>
    vcprintf(fmt, ap);
  100463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100466:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046a:	8b 45 10             	mov    0x10(%ebp),%eax
  10046d:	89 04 24             	mov    %eax,(%esp)
  100470:	e8 0e fe ff ff       	call   100283 <vcprintf>
    cprintf("\n");
  100475:	c7 04 24 e6 61 10 00 	movl   $0x1061e6,(%esp)
  10047c:	e8 39 fe ff ff       	call   1002ba <cprintf>
    
    cprintf("stack trackback:\n");
  100481:	c7 04 24 e8 61 10 00 	movl   $0x1061e8,(%esp)
  100488:	e8 2d fe ff ff       	call   1002ba <cprintf>
    print_stackframe();
  10048d:	e8 3d 06 00 00       	call   100acf <print_stackframe>
  100492:	eb 01                	jmp    100495 <__panic+0x6f>
        goto panic_dead;
  100494:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100495:	e8 e4 14 00 00       	call   10197e <intr_disable>
    while (1) {
        kmonitor(NULL);
  10049a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1004a1:	e8 5d 08 00 00       	call   100d03 <kmonitor>
  1004a6:	eb f2                	jmp    10049a <__panic+0x74>

001004a8 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  1004a8:	f3 0f 1e fb          	endbr32 
  1004ac:	55                   	push   %ebp
  1004ad:	89 e5                	mov    %esp,%ebp
  1004af:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  1004b2:	8d 45 14             	lea    0x14(%ebp),%eax
  1004b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1004c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004c6:	c7 04 24 fa 61 10 00 	movl   $0x1061fa,(%esp)
  1004cd:	e8 e8 fd ff ff       	call   1002ba <cprintf>
    vcprintf(fmt, ap);
  1004d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004dc:	89 04 24             	mov    %eax,(%esp)
  1004df:	e8 9f fd ff ff       	call   100283 <vcprintf>
    cprintf("\n");
  1004e4:	c7 04 24 e6 61 10 00 	movl   $0x1061e6,(%esp)
  1004eb:	e8 ca fd ff ff       	call   1002ba <cprintf>
    va_end(ap);
}
  1004f0:	90                   	nop
  1004f1:	c9                   	leave  
  1004f2:	c3                   	ret    

001004f3 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004f3:	f3 0f 1e fb          	endbr32 
  1004f7:	55                   	push   %ebp
  1004f8:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004fa:	a1 20 c4 11 00       	mov    0x11c420,%eax
}
  1004ff:	5d                   	pop    %ebp
  100500:	c3                   	ret    

00100501 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100501:	f3 0f 1e fb          	endbr32 
  100505:	55                   	push   %ebp
  100506:	89 e5                	mov    %esp,%ebp
  100508:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  10050b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050e:	8b 00                	mov    (%eax),%eax
  100510:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100513:	8b 45 10             	mov    0x10(%ebp),%eax
  100516:	8b 00                	mov    (%eax),%eax
  100518:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10051b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100522:	e9 ca 00 00 00       	jmp    1005f1 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100527:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10052d:	01 d0                	add    %edx,%eax
  10052f:	89 c2                	mov    %eax,%edx
  100531:	c1 ea 1f             	shr    $0x1f,%edx
  100534:	01 d0                	add    %edx,%eax
  100536:	d1 f8                	sar    %eax
  100538:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10053b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10053e:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100541:	eb 03                	jmp    100546 <stab_binsearch+0x45>
            m --;
  100543:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100549:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10054c:	7c 1f                	jl     10056d <stab_binsearch+0x6c>
  10054e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100551:	89 d0                	mov    %edx,%eax
  100553:	01 c0                	add    %eax,%eax
  100555:	01 d0                	add    %edx,%eax
  100557:	c1 e0 02             	shl    $0x2,%eax
  10055a:	89 c2                	mov    %eax,%edx
  10055c:	8b 45 08             	mov    0x8(%ebp),%eax
  10055f:	01 d0                	add    %edx,%eax
  100561:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100565:	0f b6 c0             	movzbl %al,%eax
  100568:	39 45 14             	cmp    %eax,0x14(%ebp)
  10056b:	75 d6                	jne    100543 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  10056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100570:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100573:	7d 09                	jge    10057e <stab_binsearch+0x7d>
            l = true_m + 1;
  100575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100578:	40                   	inc    %eax
  100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10057c:	eb 73                	jmp    1005f1 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  10057e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100585:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100588:	89 d0                	mov    %edx,%eax
  10058a:	01 c0                	add    %eax,%eax
  10058c:	01 d0                	add    %edx,%eax
  10058e:	c1 e0 02             	shl    $0x2,%eax
  100591:	89 c2                	mov    %eax,%edx
  100593:	8b 45 08             	mov    0x8(%ebp),%eax
  100596:	01 d0                	add    %edx,%eax
  100598:	8b 40 08             	mov    0x8(%eax),%eax
  10059b:	39 45 18             	cmp    %eax,0x18(%ebp)
  10059e:	76 11                	jbe    1005b1 <stab_binsearch+0xb0>
            *region_left = m;
  1005a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005a6:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1005a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005ab:	40                   	inc    %eax
  1005ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005af:	eb 40                	jmp    1005f1 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  1005b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b4:	89 d0                	mov    %edx,%eax
  1005b6:	01 c0                	add    %eax,%eax
  1005b8:	01 d0                	add    %edx,%eax
  1005ba:	c1 e0 02             	shl    $0x2,%eax
  1005bd:	89 c2                	mov    %eax,%edx
  1005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c2:	01 d0                	add    %edx,%eax
  1005c4:	8b 40 08             	mov    0x8(%eax),%eax
  1005c7:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005ca:	73 14                	jae    1005e0 <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d5:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005da:	48                   	dec    %eax
  1005db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005de:	eb 11                	jmp    1005f1 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005e6:	89 10                	mov    %edx,(%eax)
            l = m;
  1005e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005ee:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005f7:	0f 8e 2a ff ff ff    	jle    100527 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100601:	75 0f                	jne    100612 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	8b 00                	mov    (%eax),%eax
  100608:	8d 50 ff             	lea    -0x1(%eax),%edx
  10060b:	8b 45 10             	mov    0x10(%ebp),%eax
  10060e:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100610:	eb 3e                	jmp    100650 <stab_binsearch+0x14f>
        l = *region_right;
  100612:	8b 45 10             	mov    0x10(%ebp),%eax
  100615:	8b 00                	mov    (%eax),%eax
  100617:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10061a:	eb 03                	jmp    10061f <stab_binsearch+0x11e>
  10061c:	ff 4d fc             	decl   -0x4(%ebp)
  10061f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100622:	8b 00                	mov    (%eax),%eax
  100624:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100627:	7e 1f                	jle    100648 <stab_binsearch+0x147>
  100629:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10062c:	89 d0                	mov    %edx,%eax
  10062e:	01 c0                	add    %eax,%eax
  100630:	01 d0                	add    %edx,%eax
  100632:	c1 e0 02             	shl    $0x2,%eax
  100635:	89 c2                	mov    %eax,%edx
  100637:	8b 45 08             	mov    0x8(%ebp),%eax
  10063a:	01 d0                	add    %edx,%eax
  10063c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100640:	0f b6 c0             	movzbl %al,%eax
  100643:	39 45 14             	cmp    %eax,0x14(%ebp)
  100646:	75 d4                	jne    10061c <stab_binsearch+0x11b>
        *region_left = l;
  100648:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10064e:	89 10                	mov    %edx,(%eax)
}
  100650:	90                   	nop
  100651:	c9                   	leave  
  100652:	c3                   	ret    

00100653 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100653:	f3 0f 1e fb          	endbr32 
  100657:	55                   	push   %ebp
  100658:	89 e5                	mov    %esp,%ebp
  10065a:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10065d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100660:	c7 00 18 62 10 00    	movl   $0x106218,(%eax)
    info->eip_line = 0;
  100666:	8b 45 0c             	mov    0xc(%ebp),%eax
  100669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100670:	8b 45 0c             	mov    0xc(%ebp),%eax
  100673:	c7 40 08 18 62 10 00 	movl   $0x106218,0x8(%eax)
    info->eip_fn_namelen = 9;
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100684:	8b 45 0c             	mov    0xc(%ebp),%eax
  100687:	8b 55 08             	mov    0x8(%ebp),%edx
  10068a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100690:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100697:	c7 45 f4 60 74 10 00 	movl   $0x107460,-0xc(%ebp)
    stab_end = __STAB_END__;
  10069e:	c7 45 f0 84 3d 11 00 	movl   $0x113d84,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006a5:	c7 45 ec 85 3d 11 00 	movl   $0x113d85,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006ac:	c7 45 e8 9e 68 11 00 	movl   $0x11689e,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1006b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006b9:	76 0b                	jbe    1006c6 <debuginfo_eip+0x73>
  1006bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006be:	48                   	dec    %eax
  1006bf:	0f b6 00             	movzbl (%eax),%eax
  1006c2:	84 c0                	test   %al,%al
  1006c4:	74 0a                	je     1006d0 <debuginfo_eip+0x7d>
        return -1;
  1006c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006cb:	e9 ab 02 00 00       	jmp    10097b <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006da:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006dd:	c1 f8 02             	sar    $0x2,%eax
  1006e0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006e6:	48                   	dec    %eax
  1006e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006f1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006f8:	00 
  1006f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100700:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100703:	89 44 24 04          	mov    %eax,0x4(%esp)
  100707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10070a:	89 04 24             	mov    %eax,(%esp)
  10070d:	e8 ef fd ff ff       	call   100501 <stab_binsearch>
    if (lfile == 0)
  100712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100715:	85 c0                	test   %eax,%eax
  100717:	75 0a                	jne    100723 <debuginfo_eip+0xd0>
        return -1;
  100719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10071e:	e9 58 02 00 00       	jmp    10097b <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100726:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10072f:	8b 45 08             	mov    0x8(%ebp),%eax
  100732:	89 44 24 10          	mov    %eax,0x10(%esp)
  100736:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10073d:	00 
  10073e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100741:	89 44 24 08          	mov    %eax,0x8(%esp)
  100745:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100748:	89 44 24 04          	mov    %eax,0x4(%esp)
  10074c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074f:	89 04 24             	mov    %eax,(%esp)
  100752:	e8 aa fd ff ff       	call   100501 <stab_binsearch>

    if (lfun <= rfun) {
  100757:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10075a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10075d:	39 c2                	cmp    %eax,%edx
  10075f:	7f 78                	jg     1007d9 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100761:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100764:	89 c2                	mov    %eax,%edx
  100766:	89 d0                	mov    %edx,%eax
  100768:	01 c0                	add    %eax,%eax
  10076a:	01 d0                	add    %edx,%eax
  10076c:	c1 e0 02             	shl    $0x2,%eax
  10076f:	89 c2                	mov    %eax,%edx
  100771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100774:	01 d0                	add    %edx,%eax
  100776:	8b 10                	mov    (%eax),%edx
  100778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10077b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10077e:	39 c2                	cmp    %eax,%edx
  100780:	73 22                	jae    1007a4 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100782:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100785:	89 c2                	mov    %eax,%edx
  100787:	89 d0                	mov    %edx,%eax
  100789:	01 c0                	add    %eax,%eax
  10078b:	01 d0                	add    %edx,%eax
  10078d:	c1 e0 02             	shl    $0x2,%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	8b 10                	mov    (%eax),%edx
  100799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10079c:	01 c2                	add    %eax,%edx
  10079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a1:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1007a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a7:	89 c2                	mov    %eax,%edx
  1007a9:	89 d0                	mov    %edx,%eax
  1007ab:	01 c0                	add    %eax,%eax
  1007ad:	01 d0                	add    %edx,%eax
  1007af:	c1 e0 02             	shl    $0x2,%eax
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b7:	01 d0                	add    %edx,%eax
  1007b9:	8b 50 08             	mov    0x8(%eax),%edx
  1007bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bf:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c5:	8b 40 10             	mov    0x10(%eax),%eax
  1007c8:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007d7:	eb 15                	jmp    1007ee <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007dc:	8b 55 08             	mov    0x8(%ebp),%edx
  1007df:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f1:	8b 40 08             	mov    0x8(%eax),%eax
  1007f4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007fb:	00 
  1007fc:	89 04 24             	mov    %eax,(%esp)
  1007ff:	e8 6a 4f 00 00       	call   10576e <strfind>
  100804:	8b 55 0c             	mov    0xc(%ebp),%edx
  100807:	8b 52 08             	mov    0x8(%edx),%edx
  10080a:	29 d0                	sub    %edx,%eax
  10080c:	89 c2                	mov    %eax,%edx
  10080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100811:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100814:	8b 45 08             	mov    0x8(%ebp),%eax
  100817:	89 44 24 10          	mov    %eax,0x10(%esp)
  10081b:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100822:	00 
  100823:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100826:	89 44 24 08          	mov    %eax,0x8(%esp)
  10082a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10082d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100834:	89 04 24             	mov    %eax,(%esp)
  100837:	e8 c5 fc ff ff       	call   100501 <stab_binsearch>
    if (lline <= rline) {
  10083c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10083f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100842:	39 c2                	cmp    %eax,%edx
  100844:	7f 23                	jg     100869 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100846:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100849:	89 c2                	mov    %eax,%edx
  10084b:	89 d0                	mov    %edx,%eax
  10084d:	01 c0                	add    %eax,%eax
  10084f:	01 d0                	add    %edx,%eax
  100851:	c1 e0 02             	shl    $0x2,%eax
  100854:	89 c2                	mov    %eax,%edx
  100856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100859:	01 d0                	add    %edx,%eax
  10085b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	8b 45 0c             	mov    0xc(%ebp),%eax
  100864:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100867:	eb 11                	jmp    10087a <debuginfo_eip+0x227>
        return -1;
  100869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10086e:	e9 08 01 00 00       	jmp    10097b <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100873:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100876:	48                   	dec    %eax
  100877:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10087a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10087d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100880:	39 c2                	cmp    %eax,%edx
  100882:	7c 56                	jl     1008da <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  100884:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100887:	89 c2                	mov    %eax,%edx
  100889:	89 d0                	mov    %edx,%eax
  10088b:	01 c0                	add    %eax,%eax
  10088d:	01 d0                	add    %edx,%eax
  10088f:	c1 e0 02             	shl    $0x2,%eax
  100892:	89 c2                	mov    %eax,%edx
  100894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100897:	01 d0                	add    %edx,%eax
  100899:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10089d:	3c 84                	cmp    $0x84,%al
  10089f:	74 39                	je     1008da <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1008a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a4:	89 c2                	mov    %eax,%edx
  1008a6:	89 d0                	mov    %edx,%eax
  1008a8:	01 c0                	add    %eax,%eax
  1008aa:	01 d0                	add    %edx,%eax
  1008ac:	c1 e0 02             	shl    $0x2,%eax
  1008af:	89 c2                	mov    %eax,%edx
  1008b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008b4:	01 d0                	add    %edx,%eax
  1008b6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008ba:	3c 64                	cmp    $0x64,%al
  1008bc:	75 b5                	jne    100873 <debuginfo_eip+0x220>
  1008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	89 d0                	mov    %edx,%eax
  1008c5:	01 c0                	add    %eax,%eax
  1008c7:	01 d0                	add    %edx,%eax
  1008c9:	c1 e0 02             	shl    $0x2,%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d1:	01 d0                	add    %edx,%eax
  1008d3:	8b 40 08             	mov    0x8(%eax),%eax
  1008d6:	85 c0                	test   %eax,%eax
  1008d8:	74 99                	je     100873 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008e0:	39 c2                	cmp    %eax,%edx
  1008e2:	7c 42                	jl     100926 <debuginfo_eip+0x2d3>
  1008e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e7:	89 c2                	mov    %eax,%edx
  1008e9:	89 d0                	mov    %edx,%eax
  1008eb:	01 c0                	add    %eax,%eax
  1008ed:	01 d0                	add    %edx,%eax
  1008ef:	c1 e0 02             	shl    $0x2,%eax
  1008f2:	89 c2                	mov    %eax,%edx
  1008f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f7:	01 d0                	add    %edx,%eax
  1008f9:	8b 10                	mov    (%eax),%edx
  1008fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008fe:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100901:	39 c2                	cmp    %eax,%edx
  100903:	73 21                	jae    100926 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100905:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100908:	89 c2                	mov    %eax,%edx
  10090a:	89 d0                	mov    %edx,%eax
  10090c:	01 c0                	add    %eax,%eax
  10090e:	01 d0                	add    %edx,%eax
  100910:	c1 e0 02             	shl    $0x2,%eax
  100913:	89 c2                	mov    %eax,%edx
  100915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100918:	01 d0                	add    %edx,%eax
  10091a:	8b 10                	mov    (%eax),%edx
  10091c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10091f:	01 c2                	add    %eax,%edx
  100921:	8b 45 0c             	mov    0xc(%ebp),%eax
  100924:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100926:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100929:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10092c:	39 c2                	cmp    %eax,%edx
  10092e:	7d 46                	jge    100976 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  100930:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100933:	40                   	inc    %eax
  100934:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100937:	eb 16                	jmp    10094f <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100939:	8b 45 0c             	mov    0xc(%ebp),%eax
  10093c:	8b 40 14             	mov    0x14(%eax),%eax
  10093f:	8d 50 01             	lea    0x1(%eax),%edx
  100942:	8b 45 0c             	mov    0xc(%ebp),%eax
  100945:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10094b:	40                   	inc    %eax
  10094c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10094f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100952:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100955:	39 c2                	cmp    %eax,%edx
  100957:	7d 1d                	jge    100976 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100959:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10095c:	89 c2                	mov    %eax,%edx
  10095e:	89 d0                	mov    %edx,%eax
  100960:	01 c0                	add    %eax,%eax
  100962:	01 d0                	add    %edx,%eax
  100964:	c1 e0 02             	shl    $0x2,%eax
  100967:	89 c2                	mov    %eax,%edx
  100969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10096c:	01 d0                	add    %edx,%eax
  10096e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100972:	3c a0                	cmp    $0xa0,%al
  100974:	74 c3                	je     100939 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100976:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10097b:	c9                   	leave  
  10097c:	c3                   	ret    

0010097d <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10097d:	f3 0f 1e fb          	endbr32 
  100981:	55                   	push   %ebp
  100982:	89 e5                	mov    %esp,%ebp
  100984:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100987:	c7 04 24 22 62 10 00 	movl   $0x106222,(%esp)
  10098e:	e8 27 f9 ff ff       	call   1002ba <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100993:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  10099a:	00 
  10099b:	c7 04 24 3b 62 10 00 	movl   $0x10623b,(%esp)
  1009a2:	e8 13 f9 ff ff       	call   1002ba <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009a7:	c7 44 24 04 1e 61 10 	movl   $0x10611e,0x4(%esp)
  1009ae:	00 
  1009af:	c7 04 24 53 62 10 00 	movl   $0x106253,(%esp)
  1009b6:	e8 ff f8 ff ff       	call   1002ba <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009bb:	c7 44 24 04 36 9a 11 	movl   $0x119a36,0x4(%esp)
  1009c2:	00 
  1009c3:	c7 04 24 6b 62 10 00 	movl   $0x10626b,(%esp)
  1009ca:	e8 eb f8 ff ff       	call   1002ba <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009cf:	c7 44 24 04 28 cf 11 	movl   $0x11cf28,0x4(%esp)
  1009d6:	00 
  1009d7:	c7 04 24 83 62 10 00 	movl   $0x106283,(%esp)
  1009de:	e8 d7 f8 ff ff       	call   1002ba <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009e3:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  1009e8:	2d 36 00 10 00       	sub    $0x100036,%eax
  1009ed:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009f8:	85 c0                	test   %eax,%eax
  1009fa:	0f 48 c2             	cmovs  %edx,%eax
  1009fd:	c1 f8 0a             	sar    $0xa,%eax
  100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a04:	c7 04 24 9c 62 10 00 	movl   $0x10629c,(%esp)
  100a0b:	e8 aa f8 ff ff       	call   1002ba <cprintf>
}
  100a10:	90                   	nop
  100a11:	c9                   	leave  
  100a12:	c3                   	ret    

00100a13 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100a13:	f3 0f 1e fb          	endbr32 
  100a17:	55                   	push   %ebp
  100a18:	89 e5                	mov    %esp,%ebp
  100a1a:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a20:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a27:	8b 45 08             	mov    0x8(%ebp),%eax
  100a2a:	89 04 24             	mov    %eax,(%esp)
  100a2d:	e8 21 fc ff ff       	call   100653 <debuginfo_eip>
  100a32:	85 c0                	test   %eax,%eax
  100a34:	74 15                	je     100a4b <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a36:	8b 45 08             	mov    0x8(%ebp),%eax
  100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3d:	c7 04 24 c6 62 10 00 	movl   $0x1062c6,(%esp)
  100a44:	e8 71 f8 ff ff       	call   1002ba <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a49:	eb 6c                	jmp    100ab7 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a52:	eb 1b                	jmp    100a6f <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	01 d0                	add    %edx,%eax
  100a5c:	0f b6 10             	movzbl (%eax),%edx
  100a5f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a68:	01 c8                	add    %ecx,%eax
  100a6a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a6c:	ff 45 f4             	incl   -0xc(%ebp)
  100a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a72:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a75:	7c dd                	jl     100a54 <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a77:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a80:	01 d0                	add    %edx,%eax
  100a82:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a88:	8b 55 08             	mov    0x8(%ebp),%edx
  100a8b:	89 d1                	mov    %edx,%ecx
  100a8d:	29 c1                	sub    %eax,%ecx
  100a8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a95:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a99:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100aa3:	89 54 24 08          	mov    %edx,0x8(%esp)
  100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aab:	c7 04 24 e2 62 10 00 	movl   $0x1062e2,(%esp)
  100ab2:	e8 03 f8 ff ff       	call   1002ba <cprintf>
}
  100ab7:	90                   	nop
  100ab8:	c9                   	leave  
  100ab9:	c3                   	ret    

00100aba <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100aba:	f3 0f 1e fb          	endbr32 
  100abe:	55                   	push   %ebp
  100abf:	89 e5                	mov    %esp,%ebp
  100ac1:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100ac4:	8b 45 04             	mov    0x4(%ebp),%eax
  100ac7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100acd:	c9                   	leave  
  100ace:	c3                   	ret    

00100acf <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100acf:	f3 0f 1e fb          	endbr32 
  100ad3:	55                   	push   %ebp
  100ad4:	89 e5                	mov    %esp,%ebp
  100ad6:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ad9:	89 e8                	mov    %ebp,%eax
  100adb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ae4:	e8 d1 ff ff ff       	call   100aba <read_eip>
  100ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100aec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100af3:	e9 84 00 00 00       	jmp    100b7c <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100afb:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b06:	c7 04 24 f4 62 10 00 	movl   $0x1062f4,(%esp)
  100b0d:	e8 a8 f7 ff ff       	call   1002ba <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b15:	83 c0 08             	add    $0x8,%eax
  100b18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100b1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100b22:	eb 24                	jmp    100b48 <print_stackframe+0x79>
            cprintf("0x%08x ", args[j]);
  100b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b31:	01 d0                	add    %edx,%eax
  100b33:	8b 00                	mov    (%eax),%eax
  100b35:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b39:	c7 04 24 10 63 10 00 	movl   $0x106310,(%esp)
  100b40:	e8 75 f7 ff ff       	call   1002ba <cprintf>
        for (j = 0; j < 4; j ++) {
  100b45:	ff 45 e8             	incl   -0x18(%ebp)
  100b48:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b4c:	7e d6                	jle    100b24 <print_stackframe+0x55>
        }
        cprintf("\n");
  100b4e:	c7 04 24 18 63 10 00 	movl   $0x106318,(%esp)
  100b55:	e8 60 f7 ff ff       	call   1002ba <cprintf>
        print_debuginfo(eip - 1);
  100b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b5d:	48                   	dec    %eax
  100b5e:	89 04 24             	mov    %eax,(%esp)
  100b61:	e8 ad fe ff ff       	call   100a13 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b69:	83 c0 04             	add    $0x4,%eax
  100b6c:	8b 00                	mov    (%eax),%eax
  100b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b74:	8b 00                	mov    (%eax),%eax
  100b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100b79:	ff 45 ec             	incl   -0x14(%ebp)
  100b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b80:	74 0a                	je     100b8c <print_stackframe+0xbd>
  100b82:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b86:	0f 8e 6c ff ff ff    	jle    100af8 <print_stackframe+0x29>
    }
}
  100b8c:	90                   	nop
  100b8d:	c9                   	leave  
  100b8e:	c3                   	ret    

00100b8f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b8f:	f3 0f 1e fb          	endbr32 
  100b93:	55                   	push   %ebp
  100b94:	89 e5                	mov    %esp,%ebp
  100b96:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ba0:	eb 0c                	jmp    100bae <parse+0x1f>
            *buf ++ = '\0';
  100ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba5:	8d 50 01             	lea    0x1(%eax),%edx
  100ba8:	89 55 08             	mov    %edx,0x8(%ebp)
  100bab:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bae:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb1:	0f b6 00             	movzbl (%eax),%eax
  100bb4:	84 c0                	test   %al,%al
  100bb6:	74 1d                	je     100bd5 <parse+0x46>
  100bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  100bbb:	0f b6 00             	movzbl (%eax),%eax
  100bbe:	0f be c0             	movsbl %al,%eax
  100bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc5:	c7 04 24 9c 63 10 00 	movl   $0x10639c,(%esp)
  100bcc:	e8 67 4b 00 00       	call   105738 <strchr>
  100bd1:	85 c0                	test   %eax,%eax
  100bd3:	75 cd                	jne    100ba2 <parse+0x13>
        }
        if (*buf == '\0') {
  100bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd8:	0f b6 00             	movzbl (%eax),%eax
  100bdb:	84 c0                	test   %al,%al
  100bdd:	74 65                	je     100c44 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bdf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100be3:	75 14                	jne    100bf9 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100be5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bec:	00 
  100bed:	c7 04 24 a1 63 10 00 	movl   $0x1063a1,(%esp)
  100bf4:	e8 c1 f6 ff ff       	call   1002ba <cprintf>
        }
        argv[argc ++] = buf;
  100bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bfc:	8d 50 01             	lea    0x1(%eax),%edx
  100bff:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100c02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c0c:	01 c2                	add    %eax,%edx
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c13:	eb 03                	jmp    100c18 <parse+0x89>
            buf ++;
  100c15:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c18:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1b:	0f b6 00             	movzbl (%eax),%eax
  100c1e:	84 c0                	test   %al,%al
  100c20:	74 8c                	je     100bae <parse+0x1f>
  100c22:	8b 45 08             	mov    0x8(%ebp),%eax
  100c25:	0f b6 00             	movzbl (%eax),%eax
  100c28:	0f be c0             	movsbl %al,%eax
  100c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c2f:	c7 04 24 9c 63 10 00 	movl   $0x10639c,(%esp)
  100c36:	e8 fd 4a 00 00       	call   105738 <strchr>
  100c3b:	85 c0                	test   %eax,%eax
  100c3d:	74 d6                	je     100c15 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c3f:	e9 6a ff ff ff       	jmp    100bae <parse+0x1f>
            break;
  100c44:	90                   	nop
        }
    }
    return argc;
  100c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c48:	c9                   	leave  
  100c49:	c3                   	ret    

00100c4a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c4a:	f3 0f 1e fb          	endbr32 
  100c4e:	55                   	push   %ebp
  100c4f:	89 e5                	mov    %esp,%ebp
  100c51:	53                   	push   %ebx
  100c52:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c55:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  100c5f:	89 04 24             	mov    %eax,(%esp)
  100c62:	e8 28 ff ff ff       	call   100b8f <parse>
  100c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c6e:	75 0a                	jne    100c7a <runcmd+0x30>
        return 0;
  100c70:	b8 00 00 00 00       	mov    $0x0,%eax
  100c75:	e9 83 00 00 00       	jmp    100cfd <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c81:	eb 5a                	jmp    100cdd <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c83:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c89:	89 d0                	mov    %edx,%eax
  100c8b:	01 c0                	add    %eax,%eax
  100c8d:	01 d0                	add    %edx,%eax
  100c8f:	c1 e0 02             	shl    $0x2,%eax
  100c92:	05 00 90 11 00       	add    $0x119000,%eax
  100c97:	8b 00                	mov    (%eax),%eax
  100c99:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c9d:	89 04 24             	mov    %eax,(%esp)
  100ca0:	e8 ef 49 00 00       	call   105694 <strcmp>
  100ca5:	85 c0                	test   %eax,%eax
  100ca7:	75 31                	jne    100cda <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cac:	89 d0                	mov    %edx,%eax
  100cae:	01 c0                	add    %eax,%eax
  100cb0:	01 d0                	add    %edx,%eax
  100cb2:	c1 e0 02             	shl    $0x2,%eax
  100cb5:	05 08 90 11 00       	add    $0x119008,%eax
  100cba:	8b 10                	mov    (%eax),%edx
  100cbc:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cbf:	83 c0 04             	add    $0x4,%eax
  100cc2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100cc5:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ccb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd3:	89 1c 24             	mov    %ebx,(%esp)
  100cd6:	ff d2                	call   *%edx
  100cd8:	eb 23                	jmp    100cfd <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cda:	ff 45 f4             	incl   -0xc(%ebp)
  100cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce0:	83 f8 02             	cmp    $0x2,%eax
  100ce3:	76 9e                	jbe    100c83 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ce5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cec:	c7 04 24 bf 63 10 00 	movl   $0x1063bf,(%esp)
  100cf3:	e8 c2 f5 ff ff       	call   1002ba <cprintf>
    return 0;
  100cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cfd:	83 c4 64             	add    $0x64,%esp
  100d00:	5b                   	pop    %ebx
  100d01:	5d                   	pop    %ebp
  100d02:	c3                   	ret    

00100d03 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100d03:	f3 0f 1e fb          	endbr32 
  100d07:	55                   	push   %ebp
  100d08:	89 e5                	mov    %esp,%ebp
  100d0a:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d0d:	c7 04 24 d8 63 10 00 	movl   $0x1063d8,(%esp)
  100d14:	e8 a1 f5 ff ff       	call   1002ba <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d19:	c7 04 24 00 64 10 00 	movl   $0x106400,(%esp)
  100d20:	e8 95 f5 ff ff       	call   1002ba <cprintf>

    if (tf != NULL) {
  100d25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d29:	74 0b                	je     100d36 <kmonitor+0x33>
        print_trapframe(tf);
  100d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2e:	89 04 24             	mov    %eax,(%esp)
  100d31:	e8 e1 0d 00 00       	call   101b17 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d36:	c7 04 24 25 64 10 00 	movl   $0x106425,(%esp)
  100d3d:	e8 2b f6 ff ff       	call   10036d <readline>
  100d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d49:	74 eb                	je     100d36 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d55:	89 04 24             	mov    %eax,(%esp)
  100d58:	e8 ed fe ff ff       	call   100c4a <runcmd>
  100d5d:	85 c0                	test   %eax,%eax
  100d5f:	78 02                	js     100d63 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d61:	eb d3                	jmp    100d36 <kmonitor+0x33>
                break;
  100d63:	90                   	nop
            }
        }
    }
}
  100d64:	90                   	nop
  100d65:	c9                   	leave  
  100d66:	c3                   	ret    

00100d67 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d67:	f3 0f 1e fb          	endbr32 
  100d6b:	55                   	push   %ebp
  100d6c:	89 e5                	mov    %esp,%ebp
  100d6e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d78:	eb 3d                	jmp    100db7 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d7d:	89 d0                	mov    %edx,%eax
  100d7f:	01 c0                	add    %eax,%eax
  100d81:	01 d0                	add    %edx,%eax
  100d83:	c1 e0 02             	shl    $0x2,%eax
  100d86:	05 04 90 11 00       	add    $0x119004,%eax
  100d8b:	8b 08                	mov    (%eax),%ecx
  100d8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d90:	89 d0                	mov    %edx,%eax
  100d92:	01 c0                	add    %eax,%eax
  100d94:	01 d0                	add    %edx,%eax
  100d96:	c1 e0 02             	shl    $0x2,%eax
  100d99:	05 00 90 11 00       	add    $0x119000,%eax
  100d9e:	8b 00                	mov    (%eax),%eax
  100da0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100da8:	c7 04 24 29 64 10 00 	movl   $0x106429,(%esp)
  100daf:	e8 06 f5 ff ff       	call   1002ba <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100db4:	ff 45 f4             	incl   -0xc(%ebp)
  100db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dba:	83 f8 02             	cmp    $0x2,%eax
  100dbd:	76 bb                	jbe    100d7a <mon_help+0x13>
    }
    return 0;
  100dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dc4:	c9                   	leave  
  100dc5:	c3                   	ret    

00100dc6 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dc6:	f3 0f 1e fb          	endbr32 
  100dca:	55                   	push   %ebp
  100dcb:	89 e5                	mov    %esp,%ebp
  100dcd:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100dd0:	e8 a8 fb ff ff       	call   10097d <print_kerninfo>
    return 0;
  100dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dda:	c9                   	leave  
  100ddb:	c3                   	ret    

00100ddc <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100ddc:	f3 0f 1e fb          	endbr32 
  100de0:	55                   	push   %ebp
  100de1:	89 e5                	mov    %esp,%ebp
  100de3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100de6:	e8 e4 fc ff ff       	call   100acf <print_stackframe>
    return 0;
  100deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df0:	c9                   	leave  
  100df1:	c3                   	ret    

00100df2 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100df2:	f3 0f 1e fb          	endbr32 
  100df6:	55                   	push   %ebp
  100df7:	89 e5                	mov    %esp,%ebp
  100df9:	83 ec 28             	sub    $0x28,%esp
  100dfc:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100e02:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e06:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e0a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e0e:	ee                   	out    %al,(%dx)
}
  100e0f:	90                   	nop
  100e10:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e16:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e1a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e1e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e22:	ee                   	out    %al,(%dx)
}
  100e23:	90                   	nop
  100e24:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e2a:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e2e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e32:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e36:	ee                   	out    %al,(%dx)
}
  100e37:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e38:	c7 05 0c cf 11 00 00 	movl   $0x0,0x11cf0c
  100e3f:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e42:	c7 04 24 32 64 10 00 	movl   $0x106432,(%esp)
  100e49:	e8 6c f4 ff ff       	call   1002ba <cprintf>
    pic_enable(IRQ_TIMER);
  100e4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e55:	e8 95 09 00 00       	call   1017ef <pic_enable>
}
  100e5a:	90                   	nop
  100e5b:	c9                   	leave  
  100e5c:	c3                   	ret    

00100e5d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e5d:	55                   	push   %ebp
  100e5e:	89 e5                	mov    %esp,%ebp
  100e60:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e63:	9c                   	pushf  
  100e64:	58                   	pop    %eax
  100e65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e6b:	25 00 02 00 00       	and    $0x200,%eax
  100e70:	85 c0                	test   %eax,%eax
  100e72:	74 0c                	je     100e80 <__intr_save+0x23>
        intr_disable();
  100e74:	e8 05 0b 00 00       	call   10197e <intr_disable>
        return 1;
  100e79:	b8 01 00 00 00       	mov    $0x1,%eax
  100e7e:	eb 05                	jmp    100e85 <__intr_save+0x28>
    }
    return 0;
  100e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e85:	c9                   	leave  
  100e86:	c3                   	ret    

00100e87 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e87:	55                   	push   %ebp
  100e88:	89 e5                	mov    %esp,%ebp
  100e8a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e91:	74 05                	je     100e98 <__intr_restore+0x11>
        intr_enable();
  100e93:	e8 da 0a 00 00       	call   101972 <intr_enable>
    }
}
  100e98:	90                   	nop
  100e99:	c9                   	leave  
  100e9a:	c3                   	ret    

00100e9b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e9b:	f3 0f 1e fb          	endbr32 
  100e9f:	55                   	push   %ebp
  100ea0:	89 e5                	mov    %esp,%ebp
  100ea2:	83 ec 10             	sub    $0x10,%esp
  100ea5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eab:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eaf:	89 c2                	mov    %eax,%edx
  100eb1:	ec                   	in     (%dx),%al
  100eb2:	88 45 f1             	mov    %al,-0xf(%ebp)
  100eb5:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ebb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ebf:	89 c2                	mov    %eax,%edx
  100ec1:	ec                   	in     (%dx),%al
  100ec2:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ec5:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ecb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ecf:	89 c2                	mov    %eax,%edx
  100ed1:	ec                   	in     (%dx),%al
  100ed2:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ed5:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100edb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100edf:	89 c2                	mov    %eax,%edx
  100ee1:	ec                   	in     (%dx),%al
  100ee2:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ee5:	90                   	nop
  100ee6:	c9                   	leave  
  100ee7:	c3                   	ret    

00100ee8 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ee8:	f3 0f 1e fb          	endbr32 
  100eec:	55                   	push   %ebp
  100eed:	89 e5                	mov    %esp,%ebp
  100eef:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ef2:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100efc:	0f b7 00             	movzwl (%eax),%eax
  100eff:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f06:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0e:	0f b7 00             	movzwl (%eax),%eax
  100f11:	0f b7 c0             	movzwl %ax,%eax
  100f14:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100f19:	74 12                	je     100f2d <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100f1b:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100f22:	66 c7 05 46 c4 11 00 	movw   $0x3b4,0x11c446
  100f29:	b4 03 
  100f2b:	eb 13                	jmp    100f40 <cga_init+0x58>
    } else {
        *cp = was;
  100f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f30:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f34:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f37:	66 c7 05 46 c4 11 00 	movw   $0x3d4,0x11c446
  100f3e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f40:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f47:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f4b:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f4f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f53:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f57:	ee                   	out    %al,(%dx)
}
  100f58:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f59:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f60:	40                   	inc    %eax
  100f61:	0f b7 c0             	movzwl %ax,%eax
  100f64:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f68:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f6c:	89 c2                	mov    %eax,%edx
  100f6e:	ec                   	in     (%dx),%al
  100f6f:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f72:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f76:	0f b6 c0             	movzbl %al,%eax
  100f79:	c1 e0 08             	shl    $0x8,%eax
  100f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f7f:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f86:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f8a:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f8e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f92:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f96:	ee                   	out    %al,(%dx)
}
  100f97:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f98:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f9f:	40                   	inc    %eax
  100fa0:	0f b7 c0             	movzwl %ax,%eax
  100fa3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fa7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fab:	89 c2                	mov    %eax,%edx
  100fad:	ec                   	in     (%dx),%al
  100fae:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100fb1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fb5:	0f b6 c0             	movzbl %al,%eax
  100fb8:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fbe:	a3 40 c4 11 00       	mov    %eax,0x11c440
    crt_pos = pos;
  100fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fc6:	0f b7 c0             	movzwl %ax,%eax
  100fc9:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
}
  100fcf:	90                   	nop
  100fd0:	c9                   	leave  
  100fd1:	c3                   	ret    

00100fd2 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fd2:	f3 0f 1e fb          	endbr32 
  100fd6:	55                   	push   %ebp
  100fd7:	89 e5                	mov    %esp,%ebp
  100fd9:	83 ec 48             	sub    $0x48,%esp
  100fdc:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fe2:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fe6:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fea:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fee:	ee                   	out    %al,(%dx)
}
  100fef:	90                   	nop
  100ff0:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ff6:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ffa:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100ffe:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101002:	ee                   	out    %al,(%dx)
}
  101003:	90                   	nop
  101004:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  10100a:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10100e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101012:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101016:	ee                   	out    %al,(%dx)
}
  101017:	90                   	nop
  101018:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  10101e:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101022:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101026:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10102a:	ee                   	out    %al,(%dx)
}
  10102b:	90                   	nop
  10102c:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101032:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101036:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10103a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10103e:	ee                   	out    %al,(%dx)
}
  10103f:	90                   	nop
  101040:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101046:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10104a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10104e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101052:	ee                   	out    %al,(%dx)
}
  101053:	90                   	nop
  101054:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  10105a:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10105e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101062:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101066:	ee                   	out    %al,(%dx)
}
  101067:	90                   	nop
  101068:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10106e:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101072:	89 c2                	mov    %eax,%edx
  101074:	ec                   	in     (%dx),%al
  101075:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101078:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10107c:	3c ff                	cmp    $0xff,%al
  10107e:	0f 95 c0             	setne  %al
  101081:	0f b6 c0             	movzbl %al,%eax
  101084:	a3 48 c4 11 00       	mov    %eax,0x11c448
  101089:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10108f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101093:	89 c2                	mov    %eax,%edx
  101095:	ec                   	in     (%dx),%al
  101096:	88 45 f1             	mov    %al,-0xf(%ebp)
  101099:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10109f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1010a3:	89 c2                	mov    %eax,%edx
  1010a5:	ec                   	in     (%dx),%al
  1010a6:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1010a9:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1010ae:	85 c0                	test   %eax,%eax
  1010b0:	74 0c                	je     1010be <serial_init+0xec>
        pic_enable(IRQ_COM1);
  1010b2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010b9:	e8 31 07 00 00       	call   1017ef <pic_enable>
    }
}
  1010be:	90                   	nop
  1010bf:	c9                   	leave  
  1010c0:	c3                   	ret    

001010c1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010c1:	f3 0f 1e fb          	endbr32 
  1010c5:	55                   	push   %ebp
  1010c6:	89 e5                	mov    %esp,%ebp
  1010c8:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010d2:	eb 08                	jmp    1010dc <lpt_putc_sub+0x1b>
        delay();
  1010d4:	e8 c2 fd ff ff       	call   100e9b <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010d9:	ff 45 fc             	incl   -0x4(%ebp)
  1010dc:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010e2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010e6:	89 c2                	mov    %eax,%edx
  1010e8:	ec                   	in     (%dx),%al
  1010e9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010ec:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010f0:	84 c0                	test   %al,%al
  1010f2:	78 09                	js     1010fd <lpt_putc_sub+0x3c>
  1010f4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010fb:	7e d7                	jle    1010d4 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  1010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101100:	0f b6 c0             	movzbl %al,%eax
  101103:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101109:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10110c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101110:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101114:	ee                   	out    %al,(%dx)
}
  101115:	90                   	nop
  101116:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10111c:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101120:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101124:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101128:	ee                   	out    %al,(%dx)
}
  101129:	90                   	nop
  10112a:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101130:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101134:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101138:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10113c:	ee                   	out    %al,(%dx)
}
  10113d:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10113e:	90                   	nop
  10113f:	c9                   	leave  
  101140:	c3                   	ret    

00101141 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101141:	f3 0f 1e fb          	endbr32 
  101145:	55                   	push   %ebp
  101146:	89 e5                	mov    %esp,%ebp
  101148:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10114b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10114f:	74 0d                	je     10115e <lpt_putc+0x1d>
        lpt_putc_sub(c);
  101151:	8b 45 08             	mov    0x8(%ebp),%eax
  101154:	89 04 24             	mov    %eax,(%esp)
  101157:	e8 65 ff ff ff       	call   1010c1 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10115c:	eb 24                	jmp    101182 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  10115e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101165:	e8 57 ff ff ff       	call   1010c1 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10116a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101171:	e8 4b ff ff ff       	call   1010c1 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101176:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10117d:	e8 3f ff ff ff       	call   1010c1 <lpt_putc_sub>
}
  101182:	90                   	nop
  101183:	c9                   	leave  
  101184:	c3                   	ret    

00101185 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101185:	f3 0f 1e fb          	endbr32 
  101189:	55                   	push   %ebp
  10118a:	89 e5                	mov    %esp,%ebp
  10118c:	53                   	push   %ebx
  10118d:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101190:	8b 45 08             	mov    0x8(%ebp),%eax
  101193:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101198:	85 c0                	test   %eax,%eax
  10119a:	75 07                	jne    1011a3 <cga_putc+0x1e>
        c |= 0x0700;
  10119c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1011a6:	0f b6 c0             	movzbl %al,%eax
  1011a9:	83 f8 0d             	cmp    $0xd,%eax
  1011ac:	74 72                	je     101220 <cga_putc+0x9b>
  1011ae:	83 f8 0d             	cmp    $0xd,%eax
  1011b1:	0f 8f a3 00 00 00    	jg     10125a <cga_putc+0xd5>
  1011b7:	83 f8 08             	cmp    $0x8,%eax
  1011ba:	74 0a                	je     1011c6 <cga_putc+0x41>
  1011bc:	83 f8 0a             	cmp    $0xa,%eax
  1011bf:	74 4c                	je     10120d <cga_putc+0x88>
  1011c1:	e9 94 00 00 00       	jmp    10125a <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  1011c6:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011cd:	85 c0                	test   %eax,%eax
  1011cf:	0f 84 af 00 00 00    	je     101284 <cga_putc+0xff>
            crt_pos --;
  1011d5:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011dc:	48                   	dec    %eax
  1011dd:	0f b7 c0             	movzwl %ax,%eax
  1011e0:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1011e9:	98                   	cwtl   
  1011ea:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011ef:	98                   	cwtl   
  1011f0:	83 c8 20             	or     $0x20,%eax
  1011f3:	98                   	cwtl   
  1011f4:	8b 15 40 c4 11 00    	mov    0x11c440,%edx
  1011fa:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  101201:	01 c9                	add    %ecx,%ecx
  101203:	01 ca                	add    %ecx,%edx
  101205:	0f b7 c0             	movzwl %ax,%eax
  101208:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10120b:	eb 77                	jmp    101284 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  10120d:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101214:	83 c0 50             	add    $0x50,%eax
  101217:	0f b7 c0             	movzwl %ax,%eax
  10121a:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101220:	0f b7 1d 44 c4 11 00 	movzwl 0x11c444,%ebx
  101227:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  10122e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101233:	89 c8                	mov    %ecx,%eax
  101235:	f7 e2                	mul    %edx
  101237:	c1 ea 06             	shr    $0x6,%edx
  10123a:	89 d0                	mov    %edx,%eax
  10123c:	c1 e0 02             	shl    $0x2,%eax
  10123f:	01 d0                	add    %edx,%eax
  101241:	c1 e0 04             	shl    $0x4,%eax
  101244:	29 c1                	sub    %eax,%ecx
  101246:	89 c8                	mov    %ecx,%eax
  101248:	0f b7 c0             	movzwl %ax,%eax
  10124b:	29 c3                	sub    %eax,%ebx
  10124d:	89 d8                	mov    %ebx,%eax
  10124f:	0f b7 c0             	movzwl %ax,%eax
  101252:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
        break;
  101258:	eb 2b                	jmp    101285 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10125a:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  101260:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101267:	8d 50 01             	lea    0x1(%eax),%edx
  10126a:	0f b7 d2             	movzwl %dx,%edx
  10126d:	66 89 15 44 c4 11 00 	mov    %dx,0x11c444
  101274:	01 c0                	add    %eax,%eax
  101276:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101279:	8b 45 08             	mov    0x8(%ebp),%eax
  10127c:	0f b7 c0             	movzwl %ax,%eax
  10127f:	66 89 02             	mov    %ax,(%edx)
        break;
  101282:	eb 01                	jmp    101285 <cga_putc+0x100>
        break;
  101284:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101285:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10128c:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101291:	76 5d                	jbe    1012f0 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101293:	a1 40 c4 11 00       	mov    0x11c440,%eax
  101298:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10129e:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012a3:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1012aa:	00 
  1012ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  1012af:	89 04 24             	mov    %eax,(%esp)
  1012b2:	e8 86 46 00 00       	call   10593d <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012b7:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1012be:	eb 14                	jmp    1012d4 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  1012c0:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012c8:	01 d2                	add    %edx,%edx
  1012ca:	01 d0                	add    %edx,%eax
  1012cc:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012d1:	ff 45 f4             	incl   -0xc(%ebp)
  1012d4:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012db:	7e e3                	jle    1012c0 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  1012dd:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012e4:	83 e8 50             	sub    $0x50,%eax
  1012e7:	0f b7 c0             	movzwl %ax,%eax
  1012ea:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012f0:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  1012f7:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012fb:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012ff:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101303:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101307:	ee                   	out    %al,(%dx)
}
  101308:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101309:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101310:	c1 e8 08             	shr    $0x8,%eax
  101313:	0f b7 c0             	movzwl %ax,%eax
  101316:	0f b6 c0             	movzbl %al,%eax
  101319:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  101320:	42                   	inc    %edx
  101321:	0f b7 d2             	movzwl %dx,%edx
  101324:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101328:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10132b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10132f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101333:	ee                   	out    %al,(%dx)
}
  101334:	90                   	nop
    outb(addr_6845, 15);
  101335:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  10133c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101340:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101344:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101348:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10134c:	ee                   	out    %al,(%dx)
}
  10134d:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  10134e:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101355:	0f b6 c0             	movzbl %al,%eax
  101358:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  10135f:	42                   	inc    %edx
  101360:	0f b7 d2             	movzwl %dx,%edx
  101363:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101367:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10136a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10136e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101372:	ee                   	out    %al,(%dx)
}
  101373:	90                   	nop
}
  101374:	90                   	nop
  101375:	83 c4 34             	add    $0x34,%esp
  101378:	5b                   	pop    %ebx
  101379:	5d                   	pop    %ebp
  10137a:	c3                   	ret    

0010137b <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10137b:	f3 0f 1e fb          	endbr32 
  10137f:	55                   	push   %ebp
  101380:	89 e5                	mov    %esp,%ebp
  101382:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10138c:	eb 08                	jmp    101396 <serial_putc_sub+0x1b>
        delay();
  10138e:	e8 08 fb ff ff       	call   100e9b <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101393:	ff 45 fc             	incl   -0x4(%ebp)
  101396:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10139c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013a0:	89 c2                	mov    %eax,%edx
  1013a2:	ec                   	in     (%dx),%al
  1013a3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013a6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1013aa:	0f b6 c0             	movzbl %al,%eax
  1013ad:	83 e0 20             	and    $0x20,%eax
  1013b0:	85 c0                	test   %eax,%eax
  1013b2:	75 09                	jne    1013bd <serial_putc_sub+0x42>
  1013b4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1013bb:	7e d1                	jle    10138e <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  1013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1013c0:	0f b6 c0             	movzbl %al,%eax
  1013c3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1013c9:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1013cc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1013d0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013d4:	ee                   	out    %al,(%dx)
}
  1013d5:	90                   	nop
}
  1013d6:	90                   	nop
  1013d7:	c9                   	leave  
  1013d8:	c3                   	ret    

001013d9 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013d9:	f3 0f 1e fb          	endbr32 
  1013dd:	55                   	push   %ebp
  1013de:	89 e5                	mov    %esp,%ebp
  1013e0:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013e3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013e7:	74 0d                	je     1013f6 <serial_putc+0x1d>
        serial_putc_sub(c);
  1013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ec:	89 04 24             	mov    %eax,(%esp)
  1013ef:	e8 87 ff ff ff       	call   10137b <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013f4:	eb 24                	jmp    10141a <serial_putc+0x41>
        serial_putc_sub('\b');
  1013f6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013fd:	e8 79 ff ff ff       	call   10137b <serial_putc_sub>
        serial_putc_sub(' ');
  101402:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101409:	e8 6d ff ff ff       	call   10137b <serial_putc_sub>
        serial_putc_sub('\b');
  10140e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101415:	e8 61 ff ff ff       	call   10137b <serial_putc_sub>
}
  10141a:	90                   	nop
  10141b:	c9                   	leave  
  10141c:	c3                   	ret    

0010141d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10141d:	f3 0f 1e fb          	endbr32 
  101421:	55                   	push   %ebp
  101422:	89 e5                	mov    %esp,%ebp
  101424:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101427:	eb 33                	jmp    10145c <cons_intr+0x3f>
        if (c != 0) {
  101429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10142d:	74 2d                	je     10145c <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  10142f:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101434:	8d 50 01             	lea    0x1(%eax),%edx
  101437:	89 15 64 c6 11 00    	mov    %edx,0x11c664
  10143d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101440:	88 90 60 c4 11 00    	mov    %dl,0x11c460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101446:	a1 64 c6 11 00       	mov    0x11c664,%eax
  10144b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101450:	75 0a                	jne    10145c <cons_intr+0x3f>
                cons.wpos = 0;
  101452:	c7 05 64 c6 11 00 00 	movl   $0x0,0x11c664
  101459:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10145c:	8b 45 08             	mov    0x8(%ebp),%eax
  10145f:	ff d0                	call   *%eax
  101461:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101464:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101468:	75 bf                	jne    101429 <cons_intr+0xc>
            }
        }
    }
}
  10146a:	90                   	nop
  10146b:	90                   	nop
  10146c:	c9                   	leave  
  10146d:	c3                   	ret    

0010146e <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10146e:	f3 0f 1e fb          	endbr32 
  101472:	55                   	push   %ebp
  101473:	89 e5                	mov    %esp,%ebp
  101475:	83 ec 10             	sub    $0x10,%esp
  101478:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10147e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101482:	89 c2                	mov    %eax,%edx
  101484:	ec                   	in     (%dx),%al
  101485:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101488:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10148c:	0f b6 c0             	movzbl %al,%eax
  10148f:	83 e0 01             	and    $0x1,%eax
  101492:	85 c0                	test   %eax,%eax
  101494:	75 07                	jne    10149d <serial_proc_data+0x2f>
        return -1;
  101496:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10149b:	eb 2a                	jmp    1014c7 <serial_proc_data+0x59>
  10149d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014a3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1014a7:	89 c2                	mov    %eax,%edx
  1014a9:	ec                   	in     (%dx),%al
  1014aa:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1014ad:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1014b1:	0f b6 c0             	movzbl %al,%eax
  1014b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1014b7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1014bb:	75 07                	jne    1014c4 <serial_proc_data+0x56>
        c = '\b';
  1014bd:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1014c7:	c9                   	leave  
  1014c8:	c3                   	ret    

001014c9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1014c9:	f3 0f 1e fb          	endbr32 
  1014cd:	55                   	push   %ebp
  1014ce:	89 e5                	mov    %esp,%ebp
  1014d0:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1014d3:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1014d8:	85 c0                	test   %eax,%eax
  1014da:	74 0c                	je     1014e8 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1014dc:	c7 04 24 6e 14 10 00 	movl   $0x10146e,(%esp)
  1014e3:	e8 35 ff ff ff       	call   10141d <cons_intr>
    }
}
  1014e8:	90                   	nop
  1014e9:	c9                   	leave  
  1014ea:	c3                   	ret    

001014eb <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014eb:	f3 0f 1e fb          	endbr32 
  1014ef:	55                   	push   %ebp
  1014f0:	89 e5                	mov    %esp,%ebp
  1014f2:	83 ec 38             	sub    $0x38,%esp
  1014f5:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014fe:	89 c2                	mov    %eax,%edx
  101500:	ec                   	in     (%dx),%al
  101501:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101504:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101508:	0f b6 c0             	movzbl %al,%eax
  10150b:	83 e0 01             	and    $0x1,%eax
  10150e:	85 c0                	test   %eax,%eax
  101510:	75 0a                	jne    10151c <kbd_proc_data+0x31>
        return -1;
  101512:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101517:	e9 56 01 00 00       	jmp    101672 <kbd_proc_data+0x187>
  10151c:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101525:	89 c2                	mov    %eax,%edx
  101527:	ec                   	in     (%dx),%al
  101528:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10152b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10152f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101532:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101536:	75 17                	jne    10154f <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  101538:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10153d:	83 c8 40             	or     $0x40,%eax
  101540:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101545:	b8 00 00 00 00       	mov    $0x0,%eax
  10154a:	e9 23 01 00 00       	jmp    101672 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10154f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101553:	84 c0                	test   %al,%al
  101555:	79 45                	jns    10159c <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101557:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10155c:	83 e0 40             	and    $0x40,%eax
  10155f:	85 c0                	test   %eax,%eax
  101561:	75 08                	jne    10156b <kbd_proc_data+0x80>
  101563:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101567:	24 7f                	and    $0x7f,%al
  101569:	eb 04                	jmp    10156f <kbd_proc_data+0x84>
  10156b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10156f:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101572:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101576:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  10157d:	0c 40                	or     $0x40,%al
  10157f:	0f b6 c0             	movzbl %al,%eax
  101582:	f7 d0                	not    %eax
  101584:	89 c2                	mov    %eax,%edx
  101586:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10158b:	21 d0                	and    %edx,%eax
  10158d:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101592:	b8 00 00 00 00       	mov    $0x0,%eax
  101597:	e9 d6 00 00 00       	jmp    101672 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10159c:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015a1:	83 e0 40             	and    $0x40,%eax
  1015a4:	85 c0                	test   %eax,%eax
  1015a6:	74 11                	je     1015b9 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1015a8:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1015ac:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015b1:	83 e0 bf             	and    $0xffffffbf,%eax
  1015b4:	a3 68 c6 11 00       	mov    %eax,0x11c668
    }

    shift |= shiftcode[data];
  1015b9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015bd:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  1015c4:	0f b6 d0             	movzbl %al,%edx
  1015c7:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015cc:	09 d0                	or     %edx,%eax
  1015ce:	a3 68 c6 11 00       	mov    %eax,0x11c668
    shift ^= togglecode[data];
  1015d3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015d7:	0f b6 80 40 91 11 00 	movzbl 0x119140(%eax),%eax
  1015de:	0f b6 d0             	movzbl %al,%edx
  1015e1:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015e6:	31 d0                	xor    %edx,%eax
  1015e8:	a3 68 c6 11 00       	mov    %eax,0x11c668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015ed:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015f2:	83 e0 03             	and    $0x3,%eax
  1015f5:	8b 14 85 40 95 11 00 	mov    0x119540(,%eax,4),%edx
  1015fc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101600:	01 d0                	add    %edx,%eax
  101602:	0f b6 00             	movzbl (%eax),%eax
  101605:	0f b6 c0             	movzbl %al,%eax
  101608:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10160b:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101610:	83 e0 08             	and    $0x8,%eax
  101613:	85 c0                	test   %eax,%eax
  101615:	74 22                	je     101639 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101617:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10161b:	7e 0c                	jle    101629 <kbd_proc_data+0x13e>
  10161d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101621:	7f 06                	jg     101629 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101623:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101627:	eb 10                	jmp    101639 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101629:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10162d:	7e 0a                	jle    101639 <kbd_proc_data+0x14e>
  10162f:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101633:	7f 04                	jg     101639 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101635:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101639:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10163e:	f7 d0                	not    %eax
  101640:	83 e0 06             	and    $0x6,%eax
  101643:	85 c0                	test   %eax,%eax
  101645:	75 28                	jne    10166f <kbd_proc_data+0x184>
  101647:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10164e:	75 1f                	jne    10166f <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101650:	c7 04 24 4d 64 10 00 	movl   $0x10644d,(%esp)
  101657:	e8 5e ec ff ff       	call   1002ba <cprintf>
  10165c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101662:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101666:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10166a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10166d:	ee                   	out    %al,(%dx)
}
  10166e:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101672:	c9                   	leave  
  101673:	c3                   	ret    

00101674 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101674:	f3 0f 1e fb          	endbr32 
  101678:	55                   	push   %ebp
  101679:	89 e5                	mov    %esp,%ebp
  10167b:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10167e:	c7 04 24 eb 14 10 00 	movl   $0x1014eb,(%esp)
  101685:	e8 93 fd ff ff       	call   10141d <cons_intr>
}
  10168a:	90                   	nop
  10168b:	c9                   	leave  
  10168c:	c3                   	ret    

0010168d <kbd_init>:

static void
kbd_init(void) {
  10168d:	f3 0f 1e fb          	endbr32 
  101691:	55                   	push   %ebp
  101692:	89 e5                	mov    %esp,%ebp
  101694:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101697:	e8 d8 ff ff ff       	call   101674 <kbd_intr>
    pic_enable(IRQ_KBD);
  10169c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1016a3:	e8 47 01 00 00       	call   1017ef <pic_enable>
}
  1016a8:	90                   	nop
  1016a9:	c9                   	leave  
  1016aa:	c3                   	ret    

001016ab <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1016ab:	f3 0f 1e fb          	endbr32 
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
  1016b2:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1016b5:	e8 2e f8 ff ff       	call   100ee8 <cga_init>
    serial_init();
  1016ba:	e8 13 f9 ff ff       	call   100fd2 <serial_init>
    kbd_init();
  1016bf:	e8 c9 ff ff ff       	call   10168d <kbd_init>
    if (!serial_exists) {
  1016c4:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1016c9:	85 c0                	test   %eax,%eax
  1016cb:	75 0c                	jne    1016d9 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1016cd:	c7 04 24 59 64 10 00 	movl   $0x106459,(%esp)
  1016d4:	e8 e1 eb ff ff       	call   1002ba <cprintf>
    }
}
  1016d9:	90                   	nop
  1016da:	c9                   	leave  
  1016db:	c3                   	ret    

001016dc <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016dc:	f3 0f 1e fb          	endbr32 
  1016e0:	55                   	push   %ebp
  1016e1:	89 e5                	mov    %esp,%ebp
  1016e3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1016e6:	e8 72 f7 ff ff       	call   100e5d <__intr_save>
  1016eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f1:	89 04 24             	mov    %eax,(%esp)
  1016f4:	e8 48 fa ff ff       	call   101141 <lpt_putc>
        cga_putc(c);
  1016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1016fc:	89 04 24             	mov    %eax,(%esp)
  1016ff:	e8 81 fa ff ff       	call   101185 <cga_putc>
        serial_putc(c);
  101704:	8b 45 08             	mov    0x8(%ebp),%eax
  101707:	89 04 24             	mov    %eax,(%esp)
  10170a:	e8 ca fc ff ff       	call   1013d9 <serial_putc>
    }
    local_intr_restore(intr_flag);
  10170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101712:	89 04 24             	mov    %eax,(%esp)
  101715:	e8 6d f7 ff ff       	call   100e87 <__intr_restore>
}
  10171a:	90                   	nop
  10171b:	c9                   	leave  
  10171c:	c3                   	ret    

0010171d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10171d:	f3 0f 1e fb          	endbr32 
  101721:	55                   	push   %ebp
  101722:	89 e5                	mov    %esp,%ebp
  101724:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101727:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10172e:	e8 2a f7 ff ff       	call   100e5d <__intr_save>
  101733:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101736:	e8 8e fd ff ff       	call   1014c9 <serial_intr>
        kbd_intr();
  10173b:	e8 34 ff ff ff       	call   101674 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101740:	8b 15 60 c6 11 00    	mov    0x11c660,%edx
  101746:	a1 64 c6 11 00       	mov    0x11c664,%eax
  10174b:	39 c2                	cmp    %eax,%edx
  10174d:	74 31                	je     101780 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
  10174f:	a1 60 c6 11 00       	mov    0x11c660,%eax
  101754:	8d 50 01             	lea    0x1(%eax),%edx
  101757:	89 15 60 c6 11 00    	mov    %edx,0x11c660
  10175d:	0f b6 80 60 c4 11 00 	movzbl 0x11c460(%eax),%eax
  101764:	0f b6 c0             	movzbl %al,%eax
  101767:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10176a:	a1 60 c6 11 00       	mov    0x11c660,%eax
  10176f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101774:	75 0a                	jne    101780 <cons_getc+0x63>
                cons.rpos = 0;
  101776:	c7 05 60 c6 11 00 00 	movl   $0x0,0x11c660
  10177d:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101783:	89 04 24             	mov    %eax,(%esp)
  101786:	e8 fc f6 ff ff       	call   100e87 <__intr_restore>
    return c;
  10178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10178e:	c9                   	leave  
  10178f:	c3                   	ret    

00101790 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101790:	f3 0f 1e fb          	endbr32 
  101794:	55                   	push   %ebp
  101795:	89 e5                	mov    %esp,%ebp
  101797:	83 ec 14             	sub    $0x14,%esp
  10179a:	8b 45 08             	mov    0x8(%ebp),%eax
  10179d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1017a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017a4:	66 a3 50 95 11 00    	mov    %ax,0x119550
    if (did_init) {
  1017aa:	a1 6c c6 11 00       	mov    0x11c66c,%eax
  1017af:	85 c0                	test   %eax,%eax
  1017b1:	74 39                	je     1017ec <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  1017b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017b6:	0f b6 c0             	movzbl %al,%eax
  1017b9:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1017bf:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017c2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017c6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017ca:	ee                   	out    %al,(%dx)
}
  1017cb:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1017cc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1017d0:	c1 e8 08             	shr    $0x8,%eax
  1017d3:	0f b7 c0             	movzwl %ax,%eax
  1017d6:	0f b6 c0             	movzbl %al,%eax
  1017d9:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1017df:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017e2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017e6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
}
  1017eb:	90                   	nop
    }
}
  1017ec:	90                   	nop
  1017ed:	c9                   	leave  
  1017ee:	c3                   	ret    

001017ef <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017ef:	f3 0f 1e fb          	endbr32 
  1017f3:	55                   	push   %ebp
  1017f4:	89 e5                	mov    %esp,%ebp
  1017f6:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1017fc:	ba 01 00 00 00       	mov    $0x1,%edx
  101801:	88 c1                	mov    %al,%cl
  101803:	d3 e2                	shl    %cl,%edx
  101805:	89 d0                	mov    %edx,%eax
  101807:	98                   	cwtl   
  101808:	f7 d0                	not    %eax
  10180a:	0f bf d0             	movswl %ax,%edx
  10180d:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101814:	98                   	cwtl   
  101815:	21 d0                	and    %edx,%eax
  101817:	98                   	cwtl   
  101818:	0f b7 c0             	movzwl %ax,%eax
  10181b:	89 04 24             	mov    %eax,(%esp)
  10181e:	e8 6d ff ff ff       	call   101790 <pic_setmask>
}
  101823:	90                   	nop
  101824:	c9                   	leave  
  101825:	c3                   	ret    

00101826 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101826:	f3 0f 1e fb          	endbr32 
  10182a:	55                   	push   %ebp
  10182b:	89 e5                	mov    %esp,%ebp
  10182d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101830:	c7 05 6c c6 11 00 01 	movl   $0x1,0x11c66c
  101837:	00 00 00 
  10183a:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101840:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101844:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101848:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184c:	ee                   	out    %al,(%dx)
}
  10184d:	90                   	nop
  10184e:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101854:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101858:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10185c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101860:	ee                   	out    %al,(%dx)
}
  101861:	90                   	nop
  101862:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101868:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10186c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101870:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101874:	ee                   	out    %al,(%dx)
}
  101875:	90                   	nop
  101876:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10187c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101880:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101884:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101888:	ee                   	out    %al,(%dx)
}
  101889:	90                   	nop
  10188a:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101890:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101894:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101898:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10189c:	ee                   	out    %al,(%dx)
}
  10189d:	90                   	nop
  10189e:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1018a4:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018a8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1018ac:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1018b0:	ee                   	out    %al,(%dx)
}
  1018b1:	90                   	nop
  1018b2:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1018b8:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018bc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1018c0:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1018c4:	ee                   	out    %al,(%dx)
}
  1018c5:	90                   	nop
  1018c6:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1018cc:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1018d4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1018d8:	ee                   	out    %al,(%dx)
}
  1018d9:	90                   	nop
  1018da:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1018e0:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018e4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1018e8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018ec:	ee                   	out    %al,(%dx)
}
  1018ed:	90                   	nop
  1018ee:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018f4:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018f8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018fc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101900:	ee                   	out    %al,(%dx)
}
  101901:	90                   	nop
  101902:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101908:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10190c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101910:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101914:	ee                   	out    %al,(%dx)
}
  101915:	90                   	nop
  101916:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10191c:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101920:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101924:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101928:	ee                   	out    %al,(%dx)
}
  101929:	90                   	nop
  10192a:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101930:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101934:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101938:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10193c:	ee                   	out    %al,(%dx)
}
  10193d:	90                   	nop
  10193e:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101944:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101948:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10194c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101950:	ee                   	out    %al,(%dx)
}
  101951:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101952:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101959:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10195e:	74 0f                	je     10196f <pic_init+0x149>
        pic_setmask(irq_mask);
  101960:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101967:	89 04 24             	mov    %eax,(%esp)
  10196a:	e8 21 fe ff ff       	call   101790 <pic_setmask>
    }
}
  10196f:	90                   	nop
  101970:	c9                   	leave  
  101971:	c3                   	ret    

00101972 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101972:	f3 0f 1e fb          	endbr32 
  101976:	55                   	push   %ebp
  101977:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101979:	fb                   	sti    
}
  10197a:	90                   	nop
    sti();
}
  10197b:	90                   	nop
  10197c:	5d                   	pop    %ebp
  10197d:	c3                   	ret    

0010197e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10197e:	f3 0f 1e fb          	endbr32 
  101982:	55                   	push   %ebp
  101983:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101985:	fa                   	cli    
}
  101986:	90                   	nop
    cli();
}
  101987:	90                   	nop
  101988:	5d                   	pop    %ebp
  101989:	c3                   	ret    

0010198a <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10198a:	f3 0f 1e fb          	endbr32 
  10198e:	55                   	push   %ebp
  10198f:	89 e5                	mov    %esp,%ebp
  101991:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101994:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10199b:	00 
  10199c:	c7 04 24 80 64 10 00 	movl   $0x106480,(%esp)
  1019a3:	e8 12 e9 ff ff       	call   1002ba <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1019a8:	c7 04 24 8a 64 10 00 	movl   $0x10648a,(%esp)
  1019af:	e8 06 e9 ff ff       	call   1002ba <cprintf>
    panic("EOT: kernel seems ok.");
  1019b4:	c7 44 24 08 98 64 10 	movl   $0x106498,0x8(%esp)
  1019bb:	00 
  1019bc:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1019c3:	00 
  1019c4:	c7 04 24 ae 64 10 00 	movl   $0x1064ae,(%esp)
  1019cb:	e8 56 ea ff ff       	call   100426 <__panic>

001019d0 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1019d0:	f3 0f 1e fb          	endbr32 
  1019d4:	55                   	push   %ebp
  1019d5:	89 e5                	mov    %esp,%ebp
  1019d7:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1019e1:	e9 c4 00 00 00       	jmp    101aaa <idt_init+0xda>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1019e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e9:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  1019f0:	0f b7 d0             	movzwl %ax,%edx
  1019f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f6:	66 89 14 c5 80 c6 11 	mov    %dx,0x11c680(,%eax,8)
  1019fd:	00 
  1019fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a01:	66 c7 04 c5 82 c6 11 	movw   $0x8,0x11c682(,%eax,8)
  101a08:	00 08 00 
  101a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0e:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  101a15:	00 
  101a16:	80 e2 e0             	and    $0xe0,%dl
  101a19:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a23:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  101a2a:	00 
  101a2b:	80 e2 1f             	and    $0x1f,%dl
  101a2e:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a38:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a3f:	00 
  101a40:	80 e2 f0             	and    $0xf0,%dl
  101a43:	80 ca 0e             	or     $0xe,%dl
  101a46:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a50:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a57:	00 
  101a58:	80 e2 ef             	and    $0xef,%dl
  101a5b:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a65:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a6c:	00 
  101a6d:	80 e2 9f             	and    $0x9f,%dl
  101a70:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a7a:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a81:	00 
  101a82:	80 ca 80             	or     $0x80,%dl
  101a85:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a8f:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101a96:	c1 e8 10             	shr    $0x10,%eax
  101a99:	0f b7 d0             	movzwl %ax,%edx
  101a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a9f:	66 89 14 c5 86 c6 11 	mov    %dx,0x11c686(,%eax,8)
  101aa6:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101aa7:	ff 45 fc             	incl   -0x4(%ebp)
  101aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aad:	3d ff 00 00 00       	cmp    $0xff,%eax
  101ab2:	0f 86 2e ff ff ff    	jbe    1019e6 <idt_init+0x16>
  101ab8:	c7 45 f8 60 95 11 00 	movl   $0x119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101abf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ac2:	0f 01 18             	lidtl  (%eax)
}
  101ac5:	90                   	nop
    }
    lidt(&idt_pd);
}
  101ac6:	90                   	nop
  101ac7:	c9                   	leave  
  101ac8:	c3                   	ret    

00101ac9 <trapname>:

static const char *
trapname(int trapno) {
  101ac9:	f3 0f 1e fb          	endbr32 
  101acd:	55                   	push   %ebp
  101ace:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad3:	83 f8 13             	cmp    $0x13,%eax
  101ad6:	77 0c                	ja     101ae4 <trapname+0x1b>
        return excnames[trapno];
  101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  101adb:	8b 04 85 00 68 10 00 	mov    0x106800(,%eax,4),%eax
  101ae2:	eb 18                	jmp    101afc <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ae4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ae8:	7e 0d                	jle    101af7 <trapname+0x2e>
  101aea:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101aee:	7f 07                	jg     101af7 <trapname+0x2e>
        return "Hardware Interrupt";
  101af0:	b8 bf 64 10 00       	mov    $0x1064bf,%eax
  101af5:	eb 05                	jmp    101afc <trapname+0x33>
    }
    return "(unknown trap)";
  101af7:	b8 d2 64 10 00       	mov    $0x1064d2,%eax
}
  101afc:	5d                   	pop    %ebp
  101afd:	c3                   	ret    

00101afe <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101afe:	f3 0f 1e fb          	endbr32 
  101b02:	55                   	push   %ebp
  101b03:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b05:	8b 45 08             	mov    0x8(%ebp),%eax
  101b08:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b0c:	83 f8 08             	cmp    $0x8,%eax
  101b0f:	0f 94 c0             	sete   %al
  101b12:	0f b6 c0             	movzbl %al,%eax
}
  101b15:	5d                   	pop    %ebp
  101b16:	c3                   	ret    

00101b17 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b17:	f3 0f 1e fb          	endbr32 
  101b1b:	55                   	push   %ebp
  101b1c:	89 e5                	mov    %esp,%ebp
  101b1e:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b21:	8b 45 08             	mov    0x8(%ebp),%eax
  101b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b28:	c7 04 24 13 65 10 00 	movl   $0x106513,(%esp)
  101b2f:	e8 86 e7 ff ff       	call   1002ba <cprintf>
    print_regs(&tf->tf_regs);
  101b34:	8b 45 08             	mov    0x8(%ebp),%eax
  101b37:	89 04 24             	mov    %eax,(%esp)
  101b3a:	e8 8d 01 00 00       	call   101ccc <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b42:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b46:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4a:	c7 04 24 24 65 10 00 	movl   $0x106524,(%esp)
  101b51:	e8 64 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b56:	8b 45 08             	mov    0x8(%ebp),%eax
  101b59:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b61:	c7 04 24 37 65 10 00 	movl   $0x106537,(%esp)
  101b68:	e8 4d e7 ff ff       	call   1002ba <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b70:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b78:	c7 04 24 4a 65 10 00 	movl   $0x10654a,(%esp)
  101b7f:	e8 36 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b84:	8b 45 08             	mov    0x8(%ebp),%eax
  101b87:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8f:	c7 04 24 5d 65 10 00 	movl   $0x10655d,(%esp)
  101b96:	e8 1f e7 ff ff       	call   1002ba <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9e:	8b 40 30             	mov    0x30(%eax),%eax
  101ba1:	89 04 24             	mov    %eax,(%esp)
  101ba4:	e8 20 ff ff ff       	call   101ac9 <trapname>
  101ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  101bac:	8b 52 30             	mov    0x30(%edx),%edx
  101baf:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bb3:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bb7:	c7 04 24 70 65 10 00 	movl   $0x106570,(%esp)
  101bbe:	e8 f7 e6 ff ff       	call   1002ba <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc6:	8b 40 34             	mov    0x34(%eax),%eax
  101bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcd:	c7 04 24 82 65 10 00 	movl   $0x106582,(%esp)
  101bd4:	e8 e1 e6 ff ff       	call   1002ba <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdc:	8b 40 38             	mov    0x38(%eax),%eax
  101bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be3:	c7 04 24 91 65 10 00 	movl   $0x106591,(%esp)
  101bea:	e8 cb e6 ff ff       	call   1002ba <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfa:	c7 04 24 a0 65 10 00 	movl   $0x1065a0,(%esp)
  101c01:	e8 b4 e6 ff ff       	call   1002ba <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	8b 40 40             	mov    0x40(%eax),%eax
  101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c10:	c7 04 24 b3 65 10 00 	movl   $0x1065b3,(%esp)
  101c17:	e8 9e e6 ff ff       	call   1002ba <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c23:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c2a:	eb 3d                	jmp    101c69 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2f:	8b 50 40             	mov    0x40(%eax),%edx
  101c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c35:	21 d0                	and    %edx,%eax
  101c37:	85 c0                	test   %eax,%eax
  101c39:	74 28                	je     101c63 <print_trapframe+0x14c>
  101c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c3e:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101c45:	85 c0                	test   %eax,%eax
  101c47:	74 1a                	je     101c63 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c4c:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101c53:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c57:	c7 04 24 c2 65 10 00 	movl   $0x1065c2,(%esp)
  101c5e:	e8 57 e6 ff ff       	call   1002ba <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c63:	ff 45 f4             	incl   -0xc(%ebp)
  101c66:	d1 65 f0             	shll   -0x10(%ebp)
  101c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c6c:	83 f8 17             	cmp    $0x17,%eax
  101c6f:	76 bb                	jbe    101c2c <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c71:	8b 45 08             	mov    0x8(%ebp),%eax
  101c74:	8b 40 40             	mov    0x40(%eax),%eax
  101c77:	c1 e8 0c             	shr    $0xc,%eax
  101c7a:	83 e0 03             	and    $0x3,%eax
  101c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c81:	c7 04 24 c6 65 10 00 	movl   $0x1065c6,(%esp)
  101c88:	e8 2d e6 ff ff       	call   1002ba <cprintf>

    if (!trap_in_kernel(tf)) {
  101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c90:	89 04 24             	mov    %eax,(%esp)
  101c93:	e8 66 fe ff ff       	call   101afe <trap_in_kernel>
  101c98:	85 c0                	test   %eax,%eax
  101c9a:	75 2d                	jne    101cc9 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9f:	8b 40 44             	mov    0x44(%eax),%eax
  101ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca6:	c7 04 24 cf 65 10 00 	movl   $0x1065cf,(%esp)
  101cad:	e8 08 e6 ff ff       	call   1002ba <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb5:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbd:	c7 04 24 de 65 10 00 	movl   $0x1065de,(%esp)
  101cc4:	e8 f1 e5 ff ff       	call   1002ba <cprintf>
    }
}
  101cc9:	90                   	nop
  101cca:	c9                   	leave  
  101ccb:	c3                   	ret    

00101ccc <print_regs>:

void
print_regs(struct pushregs *regs) {
  101ccc:	f3 0f 1e fb          	endbr32 
  101cd0:	55                   	push   %ebp
  101cd1:	89 e5                	mov    %esp,%ebp
  101cd3:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd9:	8b 00                	mov    (%eax),%eax
  101cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdf:	c7 04 24 f1 65 10 00 	movl   $0x1065f1,(%esp)
  101ce6:	e8 cf e5 ff ff       	call   1002ba <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cee:	8b 40 04             	mov    0x4(%eax),%eax
  101cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf5:	c7 04 24 00 66 10 00 	movl   $0x106600,(%esp)
  101cfc:	e8 b9 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d01:	8b 45 08             	mov    0x8(%ebp),%eax
  101d04:	8b 40 08             	mov    0x8(%eax),%eax
  101d07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0b:	c7 04 24 0f 66 10 00 	movl   $0x10660f,(%esp)
  101d12:	e8 a3 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d17:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1a:	8b 40 0c             	mov    0xc(%eax),%eax
  101d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d21:	c7 04 24 1e 66 10 00 	movl   $0x10661e,(%esp)
  101d28:	e8 8d e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d30:	8b 40 10             	mov    0x10(%eax),%eax
  101d33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d37:	c7 04 24 2d 66 10 00 	movl   $0x10662d,(%esp)
  101d3e:	e8 77 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d43:	8b 45 08             	mov    0x8(%ebp),%eax
  101d46:	8b 40 14             	mov    0x14(%eax),%eax
  101d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d4d:	c7 04 24 3c 66 10 00 	movl   $0x10663c,(%esp)
  101d54:	e8 61 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d59:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5c:	8b 40 18             	mov    0x18(%eax),%eax
  101d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d63:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  101d6a:	e8 4b e5 ff ff       	call   1002ba <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d72:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d79:	c7 04 24 5a 66 10 00 	movl   $0x10665a,(%esp)
  101d80:	e8 35 e5 ff ff       	call   1002ba <cprintf>
}
  101d85:	90                   	nop
  101d86:	c9                   	leave  
  101d87:	c3                   	ret    

00101d88 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d88:	f3 0f 1e fb          	endbr32 
  101d8c:	55                   	push   %ebp
  101d8d:	89 e5                	mov    %esp,%ebp
  101d8f:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d92:	8b 45 08             	mov    0x8(%ebp),%eax
  101d95:	8b 40 30             	mov    0x30(%eax),%eax
  101d98:	83 f8 79             	cmp    $0x79,%eax
  101d9b:	0f 87 e6 00 00 00    	ja     101e87 <trap_dispatch+0xff>
  101da1:	83 f8 78             	cmp    $0x78,%eax
  101da4:	0f 83 c1 00 00 00    	jae    101e6b <trap_dispatch+0xe3>
  101daa:	83 f8 2f             	cmp    $0x2f,%eax
  101dad:	0f 87 d4 00 00 00    	ja     101e87 <trap_dispatch+0xff>
  101db3:	83 f8 2e             	cmp    $0x2e,%eax
  101db6:	0f 83 00 01 00 00    	jae    101ebc <trap_dispatch+0x134>
  101dbc:	83 f8 24             	cmp    $0x24,%eax
  101dbf:	74 5e                	je     101e1f <trap_dispatch+0x97>
  101dc1:	83 f8 24             	cmp    $0x24,%eax
  101dc4:	0f 87 bd 00 00 00    	ja     101e87 <trap_dispatch+0xff>
  101dca:	83 f8 20             	cmp    $0x20,%eax
  101dcd:	74 0a                	je     101dd9 <trap_dispatch+0x51>
  101dcf:	83 f8 21             	cmp    $0x21,%eax
  101dd2:	74 71                	je     101e45 <trap_dispatch+0xbd>
  101dd4:	e9 ae 00 00 00       	jmp    101e87 <trap_dispatch+0xff>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101dd9:	a1 0c cf 11 00       	mov    0x11cf0c,%eax
  101dde:	40                   	inc    %eax
  101ddf:	a3 0c cf 11 00       	mov    %eax,0x11cf0c
        if (ticks % TICK_NUM == 0) {
  101de4:	8b 0d 0c cf 11 00    	mov    0x11cf0c,%ecx
  101dea:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101def:	89 c8                	mov    %ecx,%eax
  101df1:	f7 e2                	mul    %edx
  101df3:	c1 ea 05             	shr    $0x5,%edx
  101df6:	89 d0                	mov    %edx,%eax
  101df8:	c1 e0 02             	shl    $0x2,%eax
  101dfb:	01 d0                	add    %edx,%eax
  101dfd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e04:	01 d0                	add    %edx,%eax
  101e06:	c1 e0 02             	shl    $0x2,%eax
  101e09:	29 c1                	sub    %eax,%ecx
  101e0b:	89 ca                	mov    %ecx,%edx
  101e0d:	85 d2                	test   %edx,%edx
  101e0f:	0f 85 aa 00 00 00    	jne    101ebf <trap_dispatch+0x137>
            print_ticks();
  101e15:	e8 70 fb ff ff       	call   10198a <print_ticks>
        }
        break;
  101e1a:	e9 a0 00 00 00       	jmp    101ebf <trap_dispatch+0x137>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e1f:	e8 f9 f8 ff ff       	call   10171d <cons_getc>
  101e24:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e27:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e2b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e2f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e37:	c7 04 24 69 66 10 00 	movl   $0x106669,(%esp)
  101e3e:	e8 77 e4 ff ff       	call   1002ba <cprintf>
        break;
  101e43:	eb 7b                	jmp    101ec0 <trap_dispatch+0x138>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e45:	e8 d3 f8 ff ff       	call   10171d <cons_getc>
  101e4a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e4d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e51:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e55:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e5d:	c7 04 24 7b 66 10 00 	movl   $0x10667b,(%esp)
  101e64:	e8 51 e4 ff ff       	call   1002ba <cprintf>
        break;
  101e69:	eb 55                	jmp    101ec0 <trap_dispatch+0x138>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e6b:	c7 44 24 08 8a 66 10 	movl   $0x10668a,0x8(%esp)
  101e72:	00 
  101e73:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101e7a:	00 
  101e7b:	c7 04 24 ae 64 10 00 	movl   $0x1064ae,(%esp)
  101e82:	e8 9f e5 ff ff       	call   100426 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e87:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e8e:	83 e0 03             	and    $0x3,%eax
  101e91:	85 c0                	test   %eax,%eax
  101e93:	75 2b                	jne    101ec0 <trap_dispatch+0x138>
            print_trapframe(tf);
  101e95:	8b 45 08             	mov    0x8(%ebp),%eax
  101e98:	89 04 24             	mov    %eax,(%esp)
  101e9b:	e8 77 fc ff ff       	call   101b17 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ea0:	c7 44 24 08 9a 66 10 	movl   $0x10669a,0x8(%esp)
  101ea7:	00 
  101ea8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  101eaf:	00 
  101eb0:	c7 04 24 ae 64 10 00 	movl   $0x1064ae,(%esp)
  101eb7:	e8 6a e5 ff ff       	call   100426 <__panic>
        break;
  101ebc:	90                   	nop
  101ebd:	eb 01                	jmp    101ec0 <trap_dispatch+0x138>
        break;
  101ebf:	90                   	nop
        }
    }
}
  101ec0:	90                   	nop
  101ec1:	c9                   	leave  
  101ec2:	c3                   	ret    

00101ec3 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ec3:	f3 0f 1e fb          	endbr32 
  101ec7:	55                   	push   %ebp
  101ec8:	89 e5                	mov    %esp,%ebp
  101eca:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed0:	89 04 24             	mov    %eax,(%esp)
  101ed3:	e8 b0 fe ff ff       	call   101d88 <trap_dispatch>
}
  101ed8:	90                   	nop
  101ed9:	c9                   	leave  
  101eda:	c3                   	ret    

00101edb <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $0
  101edd:	6a 00                	push   $0x0
  jmp __alltraps
  101edf:	e9 69 0a 00 00       	jmp    10294d <__alltraps>

00101ee4 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $1
  101ee6:	6a 01                	push   $0x1
  jmp __alltraps
  101ee8:	e9 60 0a 00 00       	jmp    10294d <__alltraps>

00101eed <vector2>:
.globl vector2
vector2:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $2
  101eef:	6a 02                	push   $0x2
  jmp __alltraps
  101ef1:	e9 57 0a 00 00       	jmp    10294d <__alltraps>

00101ef6 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $3
  101ef8:	6a 03                	push   $0x3
  jmp __alltraps
  101efa:	e9 4e 0a 00 00       	jmp    10294d <__alltraps>

00101eff <vector4>:
.globl vector4
vector4:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $4
  101f01:	6a 04                	push   $0x4
  jmp __alltraps
  101f03:	e9 45 0a 00 00       	jmp    10294d <__alltraps>

00101f08 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $5
  101f0a:	6a 05                	push   $0x5
  jmp __alltraps
  101f0c:	e9 3c 0a 00 00       	jmp    10294d <__alltraps>

00101f11 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $6
  101f13:	6a 06                	push   $0x6
  jmp __alltraps
  101f15:	e9 33 0a 00 00       	jmp    10294d <__alltraps>

00101f1a <vector7>:
.globl vector7
vector7:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $7
  101f1c:	6a 07                	push   $0x7
  jmp __alltraps
  101f1e:	e9 2a 0a 00 00       	jmp    10294d <__alltraps>

00101f23 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f23:	6a 08                	push   $0x8
  jmp __alltraps
  101f25:	e9 23 0a 00 00       	jmp    10294d <__alltraps>

00101f2a <vector9>:
.globl vector9
vector9:
  pushl $0
  101f2a:	6a 00                	push   $0x0
  pushl $9
  101f2c:	6a 09                	push   $0x9
  jmp __alltraps
  101f2e:	e9 1a 0a 00 00       	jmp    10294d <__alltraps>

00101f33 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f33:	6a 0a                	push   $0xa
  jmp __alltraps
  101f35:	e9 13 0a 00 00       	jmp    10294d <__alltraps>

00101f3a <vector11>:
.globl vector11
vector11:
  pushl $11
  101f3a:	6a 0b                	push   $0xb
  jmp __alltraps
  101f3c:	e9 0c 0a 00 00       	jmp    10294d <__alltraps>

00101f41 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f41:	6a 0c                	push   $0xc
  jmp __alltraps
  101f43:	e9 05 0a 00 00       	jmp    10294d <__alltraps>

00101f48 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f48:	6a 0d                	push   $0xd
  jmp __alltraps
  101f4a:	e9 fe 09 00 00       	jmp    10294d <__alltraps>

00101f4f <vector14>:
.globl vector14
vector14:
  pushl $14
  101f4f:	6a 0e                	push   $0xe
  jmp __alltraps
  101f51:	e9 f7 09 00 00       	jmp    10294d <__alltraps>

00101f56 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $15
  101f58:	6a 0f                	push   $0xf
  jmp __alltraps
  101f5a:	e9 ee 09 00 00       	jmp    10294d <__alltraps>

00101f5f <vector16>:
.globl vector16
vector16:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $16
  101f61:	6a 10                	push   $0x10
  jmp __alltraps
  101f63:	e9 e5 09 00 00       	jmp    10294d <__alltraps>

00101f68 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f68:	6a 11                	push   $0x11
  jmp __alltraps
  101f6a:	e9 de 09 00 00       	jmp    10294d <__alltraps>

00101f6f <vector18>:
.globl vector18
vector18:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $18
  101f71:	6a 12                	push   $0x12
  jmp __alltraps
  101f73:	e9 d5 09 00 00       	jmp    10294d <__alltraps>

00101f78 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f78:	6a 00                	push   $0x0
  pushl $19
  101f7a:	6a 13                	push   $0x13
  jmp __alltraps
  101f7c:	e9 cc 09 00 00       	jmp    10294d <__alltraps>

00101f81 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $20
  101f83:	6a 14                	push   $0x14
  jmp __alltraps
  101f85:	e9 c3 09 00 00       	jmp    10294d <__alltraps>

00101f8a <vector21>:
.globl vector21
vector21:
  pushl $0
  101f8a:	6a 00                	push   $0x0
  pushl $21
  101f8c:	6a 15                	push   $0x15
  jmp __alltraps
  101f8e:	e9 ba 09 00 00       	jmp    10294d <__alltraps>

00101f93 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $22
  101f95:	6a 16                	push   $0x16
  jmp __alltraps
  101f97:	e9 b1 09 00 00       	jmp    10294d <__alltraps>

00101f9c <vector23>:
.globl vector23
vector23:
  pushl $0
  101f9c:	6a 00                	push   $0x0
  pushl $23
  101f9e:	6a 17                	push   $0x17
  jmp __alltraps
  101fa0:	e9 a8 09 00 00       	jmp    10294d <__alltraps>

00101fa5 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fa5:	6a 00                	push   $0x0
  pushl $24
  101fa7:	6a 18                	push   $0x18
  jmp __alltraps
  101fa9:	e9 9f 09 00 00       	jmp    10294d <__alltraps>

00101fae <vector25>:
.globl vector25
vector25:
  pushl $0
  101fae:	6a 00                	push   $0x0
  pushl $25
  101fb0:	6a 19                	push   $0x19
  jmp __alltraps
  101fb2:	e9 96 09 00 00       	jmp    10294d <__alltraps>

00101fb7 <vector26>:
.globl vector26
vector26:
  pushl $0
  101fb7:	6a 00                	push   $0x0
  pushl $26
  101fb9:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fbb:	e9 8d 09 00 00       	jmp    10294d <__alltraps>

00101fc0 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fc0:	6a 00                	push   $0x0
  pushl $27
  101fc2:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fc4:	e9 84 09 00 00       	jmp    10294d <__alltraps>

00101fc9 <vector28>:
.globl vector28
vector28:
  pushl $0
  101fc9:	6a 00                	push   $0x0
  pushl $28
  101fcb:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fcd:	e9 7b 09 00 00       	jmp    10294d <__alltraps>

00101fd2 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fd2:	6a 00                	push   $0x0
  pushl $29
  101fd4:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fd6:	e9 72 09 00 00       	jmp    10294d <__alltraps>

00101fdb <vector30>:
.globl vector30
vector30:
  pushl $0
  101fdb:	6a 00                	push   $0x0
  pushl $30
  101fdd:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fdf:	e9 69 09 00 00       	jmp    10294d <__alltraps>

00101fe4 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fe4:	6a 00                	push   $0x0
  pushl $31
  101fe6:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fe8:	e9 60 09 00 00       	jmp    10294d <__alltraps>

00101fed <vector32>:
.globl vector32
vector32:
  pushl $0
  101fed:	6a 00                	push   $0x0
  pushl $32
  101fef:	6a 20                	push   $0x20
  jmp __alltraps
  101ff1:	e9 57 09 00 00       	jmp    10294d <__alltraps>

00101ff6 <vector33>:
.globl vector33
vector33:
  pushl $0
  101ff6:	6a 00                	push   $0x0
  pushl $33
  101ff8:	6a 21                	push   $0x21
  jmp __alltraps
  101ffa:	e9 4e 09 00 00       	jmp    10294d <__alltraps>

00101fff <vector34>:
.globl vector34
vector34:
  pushl $0
  101fff:	6a 00                	push   $0x0
  pushl $34
  102001:	6a 22                	push   $0x22
  jmp __alltraps
  102003:	e9 45 09 00 00       	jmp    10294d <__alltraps>

00102008 <vector35>:
.globl vector35
vector35:
  pushl $0
  102008:	6a 00                	push   $0x0
  pushl $35
  10200a:	6a 23                	push   $0x23
  jmp __alltraps
  10200c:	e9 3c 09 00 00       	jmp    10294d <__alltraps>

00102011 <vector36>:
.globl vector36
vector36:
  pushl $0
  102011:	6a 00                	push   $0x0
  pushl $36
  102013:	6a 24                	push   $0x24
  jmp __alltraps
  102015:	e9 33 09 00 00       	jmp    10294d <__alltraps>

0010201a <vector37>:
.globl vector37
vector37:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $37
  10201c:	6a 25                	push   $0x25
  jmp __alltraps
  10201e:	e9 2a 09 00 00       	jmp    10294d <__alltraps>

00102023 <vector38>:
.globl vector38
vector38:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $38
  102025:	6a 26                	push   $0x26
  jmp __alltraps
  102027:	e9 21 09 00 00       	jmp    10294d <__alltraps>

0010202c <vector39>:
.globl vector39
vector39:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $39
  10202e:	6a 27                	push   $0x27
  jmp __alltraps
  102030:	e9 18 09 00 00       	jmp    10294d <__alltraps>

00102035 <vector40>:
.globl vector40
vector40:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $40
  102037:	6a 28                	push   $0x28
  jmp __alltraps
  102039:	e9 0f 09 00 00       	jmp    10294d <__alltraps>

0010203e <vector41>:
.globl vector41
vector41:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $41
  102040:	6a 29                	push   $0x29
  jmp __alltraps
  102042:	e9 06 09 00 00       	jmp    10294d <__alltraps>

00102047 <vector42>:
.globl vector42
vector42:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $42
  102049:	6a 2a                	push   $0x2a
  jmp __alltraps
  10204b:	e9 fd 08 00 00       	jmp    10294d <__alltraps>

00102050 <vector43>:
.globl vector43
vector43:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $43
  102052:	6a 2b                	push   $0x2b
  jmp __alltraps
  102054:	e9 f4 08 00 00       	jmp    10294d <__alltraps>

00102059 <vector44>:
.globl vector44
vector44:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $44
  10205b:	6a 2c                	push   $0x2c
  jmp __alltraps
  10205d:	e9 eb 08 00 00       	jmp    10294d <__alltraps>

00102062 <vector45>:
.globl vector45
vector45:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $45
  102064:	6a 2d                	push   $0x2d
  jmp __alltraps
  102066:	e9 e2 08 00 00       	jmp    10294d <__alltraps>

0010206b <vector46>:
.globl vector46
vector46:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $46
  10206d:	6a 2e                	push   $0x2e
  jmp __alltraps
  10206f:	e9 d9 08 00 00       	jmp    10294d <__alltraps>

00102074 <vector47>:
.globl vector47
vector47:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $47
  102076:	6a 2f                	push   $0x2f
  jmp __alltraps
  102078:	e9 d0 08 00 00       	jmp    10294d <__alltraps>

0010207d <vector48>:
.globl vector48
vector48:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $48
  10207f:	6a 30                	push   $0x30
  jmp __alltraps
  102081:	e9 c7 08 00 00       	jmp    10294d <__alltraps>

00102086 <vector49>:
.globl vector49
vector49:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $49
  102088:	6a 31                	push   $0x31
  jmp __alltraps
  10208a:	e9 be 08 00 00       	jmp    10294d <__alltraps>

0010208f <vector50>:
.globl vector50
vector50:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $50
  102091:	6a 32                	push   $0x32
  jmp __alltraps
  102093:	e9 b5 08 00 00       	jmp    10294d <__alltraps>

00102098 <vector51>:
.globl vector51
vector51:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $51
  10209a:	6a 33                	push   $0x33
  jmp __alltraps
  10209c:	e9 ac 08 00 00       	jmp    10294d <__alltraps>

001020a1 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $52
  1020a3:	6a 34                	push   $0x34
  jmp __alltraps
  1020a5:	e9 a3 08 00 00       	jmp    10294d <__alltraps>

001020aa <vector53>:
.globl vector53
vector53:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $53
  1020ac:	6a 35                	push   $0x35
  jmp __alltraps
  1020ae:	e9 9a 08 00 00       	jmp    10294d <__alltraps>

001020b3 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $54
  1020b5:	6a 36                	push   $0x36
  jmp __alltraps
  1020b7:	e9 91 08 00 00       	jmp    10294d <__alltraps>

001020bc <vector55>:
.globl vector55
vector55:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $55
  1020be:	6a 37                	push   $0x37
  jmp __alltraps
  1020c0:	e9 88 08 00 00       	jmp    10294d <__alltraps>

001020c5 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $56
  1020c7:	6a 38                	push   $0x38
  jmp __alltraps
  1020c9:	e9 7f 08 00 00       	jmp    10294d <__alltraps>

001020ce <vector57>:
.globl vector57
vector57:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $57
  1020d0:	6a 39                	push   $0x39
  jmp __alltraps
  1020d2:	e9 76 08 00 00       	jmp    10294d <__alltraps>

001020d7 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $58
  1020d9:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020db:	e9 6d 08 00 00       	jmp    10294d <__alltraps>

001020e0 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $59
  1020e2:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020e4:	e9 64 08 00 00       	jmp    10294d <__alltraps>

001020e9 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $60
  1020eb:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020ed:	e9 5b 08 00 00       	jmp    10294d <__alltraps>

001020f2 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $61
  1020f4:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020f6:	e9 52 08 00 00       	jmp    10294d <__alltraps>

001020fb <vector62>:
.globl vector62
vector62:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $62
  1020fd:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020ff:	e9 49 08 00 00       	jmp    10294d <__alltraps>

00102104 <vector63>:
.globl vector63
vector63:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $63
  102106:	6a 3f                	push   $0x3f
  jmp __alltraps
  102108:	e9 40 08 00 00       	jmp    10294d <__alltraps>

0010210d <vector64>:
.globl vector64
vector64:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $64
  10210f:	6a 40                	push   $0x40
  jmp __alltraps
  102111:	e9 37 08 00 00       	jmp    10294d <__alltraps>

00102116 <vector65>:
.globl vector65
vector65:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $65
  102118:	6a 41                	push   $0x41
  jmp __alltraps
  10211a:	e9 2e 08 00 00       	jmp    10294d <__alltraps>

0010211f <vector66>:
.globl vector66
vector66:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $66
  102121:	6a 42                	push   $0x42
  jmp __alltraps
  102123:	e9 25 08 00 00       	jmp    10294d <__alltraps>

00102128 <vector67>:
.globl vector67
vector67:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $67
  10212a:	6a 43                	push   $0x43
  jmp __alltraps
  10212c:	e9 1c 08 00 00       	jmp    10294d <__alltraps>

00102131 <vector68>:
.globl vector68
vector68:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $68
  102133:	6a 44                	push   $0x44
  jmp __alltraps
  102135:	e9 13 08 00 00       	jmp    10294d <__alltraps>

0010213a <vector69>:
.globl vector69
vector69:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $69
  10213c:	6a 45                	push   $0x45
  jmp __alltraps
  10213e:	e9 0a 08 00 00       	jmp    10294d <__alltraps>

00102143 <vector70>:
.globl vector70
vector70:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $70
  102145:	6a 46                	push   $0x46
  jmp __alltraps
  102147:	e9 01 08 00 00       	jmp    10294d <__alltraps>

0010214c <vector71>:
.globl vector71
vector71:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $71
  10214e:	6a 47                	push   $0x47
  jmp __alltraps
  102150:	e9 f8 07 00 00       	jmp    10294d <__alltraps>

00102155 <vector72>:
.globl vector72
vector72:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $72
  102157:	6a 48                	push   $0x48
  jmp __alltraps
  102159:	e9 ef 07 00 00       	jmp    10294d <__alltraps>

0010215e <vector73>:
.globl vector73
vector73:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $73
  102160:	6a 49                	push   $0x49
  jmp __alltraps
  102162:	e9 e6 07 00 00       	jmp    10294d <__alltraps>

00102167 <vector74>:
.globl vector74
vector74:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $74
  102169:	6a 4a                	push   $0x4a
  jmp __alltraps
  10216b:	e9 dd 07 00 00       	jmp    10294d <__alltraps>

00102170 <vector75>:
.globl vector75
vector75:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $75
  102172:	6a 4b                	push   $0x4b
  jmp __alltraps
  102174:	e9 d4 07 00 00       	jmp    10294d <__alltraps>

00102179 <vector76>:
.globl vector76
vector76:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $76
  10217b:	6a 4c                	push   $0x4c
  jmp __alltraps
  10217d:	e9 cb 07 00 00       	jmp    10294d <__alltraps>

00102182 <vector77>:
.globl vector77
vector77:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $77
  102184:	6a 4d                	push   $0x4d
  jmp __alltraps
  102186:	e9 c2 07 00 00       	jmp    10294d <__alltraps>

0010218b <vector78>:
.globl vector78
vector78:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $78
  10218d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10218f:	e9 b9 07 00 00       	jmp    10294d <__alltraps>

00102194 <vector79>:
.globl vector79
vector79:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $79
  102196:	6a 4f                	push   $0x4f
  jmp __alltraps
  102198:	e9 b0 07 00 00       	jmp    10294d <__alltraps>

0010219d <vector80>:
.globl vector80
vector80:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $80
  10219f:	6a 50                	push   $0x50
  jmp __alltraps
  1021a1:	e9 a7 07 00 00       	jmp    10294d <__alltraps>

001021a6 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $81
  1021a8:	6a 51                	push   $0x51
  jmp __alltraps
  1021aa:	e9 9e 07 00 00       	jmp    10294d <__alltraps>

001021af <vector82>:
.globl vector82
vector82:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $82
  1021b1:	6a 52                	push   $0x52
  jmp __alltraps
  1021b3:	e9 95 07 00 00       	jmp    10294d <__alltraps>

001021b8 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $83
  1021ba:	6a 53                	push   $0x53
  jmp __alltraps
  1021bc:	e9 8c 07 00 00       	jmp    10294d <__alltraps>

001021c1 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $84
  1021c3:	6a 54                	push   $0x54
  jmp __alltraps
  1021c5:	e9 83 07 00 00       	jmp    10294d <__alltraps>

001021ca <vector85>:
.globl vector85
vector85:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $85
  1021cc:	6a 55                	push   $0x55
  jmp __alltraps
  1021ce:	e9 7a 07 00 00       	jmp    10294d <__alltraps>

001021d3 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $86
  1021d5:	6a 56                	push   $0x56
  jmp __alltraps
  1021d7:	e9 71 07 00 00       	jmp    10294d <__alltraps>

001021dc <vector87>:
.globl vector87
vector87:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $87
  1021de:	6a 57                	push   $0x57
  jmp __alltraps
  1021e0:	e9 68 07 00 00       	jmp    10294d <__alltraps>

001021e5 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $88
  1021e7:	6a 58                	push   $0x58
  jmp __alltraps
  1021e9:	e9 5f 07 00 00       	jmp    10294d <__alltraps>

001021ee <vector89>:
.globl vector89
vector89:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $89
  1021f0:	6a 59                	push   $0x59
  jmp __alltraps
  1021f2:	e9 56 07 00 00       	jmp    10294d <__alltraps>

001021f7 <vector90>:
.globl vector90
vector90:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $90
  1021f9:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021fb:	e9 4d 07 00 00       	jmp    10294d <__alltraps>

00102200 <vector91>:
.globl vector91
vector91:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $91
  102202:	6a 5b                	push   $0x5b
  jmp __alltraps
  102204:	e9 44 07 00 00       	jmp    10294d <__alltraps>

00102209 <vector92>:
.globl vector92
vector92:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $92
  10220b:	6a 5c                	push   $0x5c
  jmp __alltraps
  10220d:	e9 3b 07 00 00       	jmp    10294d <__alltraps>

00102212 <vector93>:
.globl vector93
vector93:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $93
  102214:	6a 5d                	push   $0x5d
  jmp __alltraps
  102216:	e9 32 07 00 00       	jmp    10294d <__alltraps>

0010221b <vector94>:
.globl vector94
vector94:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $94
  10221d:	6a 5e                	push   $0x5e
  jmp __alltraps
  10221f:	e9 29 07 00 00       	jmp    10294d <__alltraps>

00102224 <vector95>:
.globl vector95
vector95:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $95
  102226:	6a 5f                	push   $0x5f
  jmp __alltraps
  102228:	e9 20 07 00 00       	jmp    10294d <__alltraps>

0010222d <vector96>:
.globl vector96
vector96:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $96
  10222f:	6a 60                	push   $0x60
  jmp __alltraps
  102231:	e9 17 07 00 00       	jmp    10294d <__alltraps>

00102236 <vector97>:
.globl vector97
vector97:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $97
  102238:	6a 61                	push   $0x61
  jmp __alltraps
  10223a:	e9 0e 07 00 00       	jmp    10294d <__alltraps>

0010223f <vector98>:
.globl vector98
vector98:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $98
  102241:	6a 62                	push   $0x62
  jmp __alltraps
  102243:	e9 05 07 00 00       	jmp    10294d <__alltraps>

00102248 <vector99>:
.globl vector99
vector99:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $99
  10224a:	6a 63                	push   $0x63
  jmp __alltraps
  10224c:	e9 fc 06 00 00       	jmp    10294d <__alltraps>

00102251 <vector100>:
.globl vector100
vector100:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $100
  102253:	6a 64                	push   $0x64
  jmp __alltraps
  102255:	e9 f3 06 00 00       	jmp    10294d <__alltraps>

0010225a <vector101>:
.globl vector101
vector101:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $101
  10225c:	6a 65                	push   $0x65
  jmp __alltraps
  10225e:	e9 ea 06 00 00       	jmp    10294d <__alltraps>

00102263 <vector102>:
.globl vector102
vector102:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $102
  102265:	6a 66                	push   $0x66
  jmp __alltraps
  102267:	e9 e1 06 00 00       	jmp    10294d <__alltraps>

0010226c <vector103>:
.globl vector103
vector103:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $103
  10226e:	6a 67                	push   $0x67
  jmp __alltraps
  102270:	e9 d8 06 00 00       	jmp    10294d <__alltraps>

00102275 <vector104>:
.globl vector104
vector104:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $104
  102277:	6a 68                	push   $0x68
  jmp __alltraps
  102279:	e9 cf 06 00 00       	jmp    10294d <__alltraps>

0010227e <vector105>:
.globl vector105
vector105:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $105
  102280:	6a 69                	push   $0x69
  jmp __alltraps
  102282:	e9 c6 06 00 00       	jmp    10294d <__alltraps>

00102287 <vector106>:
.globl vector106
vector106:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $106
  102289:	6a 6a                	push   $0x6a
  jmp __alltraps
  10228b:	e9 bd 06 00 00       	jmp    10294d <__alltraps>

00102290 <vector107>:
.globl vector107
vector107:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $107
  102292:	6a 6b                	push   $0x6b
  jmp __alltraps
  102294:	e9 b4 06 00 00       	jmp    10294d <__alltraps>

00102299 <vector108>:
.globl vector108
vector108:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $108
  10229b:	6a 6c                	push   $0x6c
  jmp __alltraps
  10229d:	e9 ab 06 00 00       	jmp    10294d <__alltraps>

001022a2 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $109
  1022a4:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022a6:	e9 a2 06 00 00       	jmp    10294d <__alltraps>

001022ab <vector110>:
.globl vector110
vector110:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $110
  1022ad:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022af:	e9 99 06 00 00       	jmp    10294d <__alltraps>

001022b4 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $111
  1022b6:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022b8:	e9 90 06 00 00       	jmp    10294d <__alltraps>

001022bd <vector112>:
.globl vector112
vector112:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $112
  1022bf:	6a 70                	push   $0x70
  jmp __alltraps
  1022c1:	e9 87 06 00 00       	jmp    10294d <__alltraps>

001022c6 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $113
  1022c8:	6a 71                	push   $0x71
  jmp __alltraps
  1022ca:	e9 7e 06 00 00       	jmp    10294d <__alltraps>

001022cf <vector114>:
.globl vector114
vector114:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $114
  1022d1:	6a 72                	push   $0x72
  jmp __alltraps
  1022d3:	e9 75 06 00 00       	jmp    10294d <__alltraps>

001022d8 <vector115>:
.globl vector115
vector115:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $115
  1022da:	6a 73                	push   $0x73
  jmp __alltraps
  1022dc:	e9 6c 06 00 00       	jmp    10294d <__alltraps>

001022e1 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $116
  1022e3:	6a 74                	push   $0x74
  jmp __alltraps
  1022e5:	e9 63 06 00 00       	jmp    10294d <__alltraps>

001022ea <vector117>:
.globl vector117
vector117:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $117
  1022ec:	6a 75                	push   $0x75
  jmp __alltraps
  1022ee:	e9 5a 06 00 00       	jmp    10294d <__alltraps>

001022f3 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $118
  1022f5:	6a 76                	push   $0x76
  jmp __alltraps
  1022f7:	e9 51 06 00 00       	jmp    10294d <__alltraps>

001022fc <vector119>:
.globl vector119
vector119:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $119
  1022fe:	6a 77                	push   $0x77
  jmp __alltraps
  102300:	e9 48 06 00 00       	jmp    10294d <__alltraps>

00102305 <vector120>:
.globl vector120
vector120:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $120
  102307:	6a 78                	push   $0x78
  jmp __alltraps
  102309:	e9 3f 06 00 00       	jmp    10294d <__alltraps>

0010230e <vector121>:
.globl vector121
vector121:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $121
  102310:	6a 79                	push   $0x79
  jmp __alltraps
  102312:	e9 36 06 00 00       	jmp    10294d <__alltraps>

00102317 <vector122>:
.globl vector122
vector122:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $122
  102319:	6a 7a                	push   $0x7a
  jmp __alltraps
  10231b:	e9 2d 06 00 00       	jmp    10294d <__alltraps>

00102320 <vector123>:
.globl vector123
vector123:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $123
  102322:	6a 7b                	push   $0x7b
  jmp __alltraps
  102324:	e9 24 06 00 00       	jmp    10294d <__alltraps>

00102329 <vector124>:
.globl vector124
vector124:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $124
  10232b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10232d:	e9 1b 06 00 00       	jmp    10294d <__alltraps>

00102332 <vector125>:
.globl vector125
vector125:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $125
  102334:	6a 7d                	push   $0x7d
  jmp __alltraps
  102336:	e9 12 06 00 00       	jmp    10294d <__alltraps>

0010233b <vector126>:
.globl vector126
vector126:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $126
  10233d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10233f:	e9 09 06 00 00       	jmp    10294d <__alltraps>

00102344 <vector127>:
.globl vector127
vector127:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $127
  102346:	6a 7f                	push   $0x7f
  jmp __alltraps
  102348:	e9 00 06 00 00       	jmp    10294d <__alltraps>

0010234d <vector128>:
.globl vector128
vector128:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $128
  10234f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102354:	e9 f4 05 00 00       	jmp    10294d <__alltraps>

00102359 <vector129>:
.globl vector129
vector129:
  pushl $0
  102359:	6a 00                	push   $0x0
  pushl $129
  10235b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102360:	e9 e8 05 00 00       	jmp    10294d <__alltraps>

00102365 <vector130>:
.globl vector130
vector130:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $130
  102367:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10236c:	e9 dc 05 00 00       	jmp    10294d <__alltraps>

00102371 <vector131>:
.globl vector131
vector131:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $131
  102373:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102378:	e9 d0 05 00 00       	jmp    10294d <__alltraps>

0010237d <vector132>:
.globl vector132
vector132:
  pushl $0
  10237d:	6a 00                	push   $0x0
  pushl $132
  10237f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102384:	e9 c4 05 00 00       	jmp    10294d <__alltraps>

00102389 <vector133>:
.globl vector133
vector133:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $133
  10238b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102390:	e9 b8 05 00 00       	jmp    10294d <__alltraps>

00102395 <vector134>:
.globl vector134
vector134:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $134
  102397:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10239c:	e9 ac 05 00 00       	jmp    10294d <__alltraps>

001023a1 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023a1:	6a 00                	push   $0x0
  pushl $135
  1023a3:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023a8:	e9 a0 05 00 00       	jmp    10294d <__alltraps>

001023ad <vector136>:
.globl vector136
vector136:
  pushl $0
  1023ad:	6a 00                	push   $0x0
  pushl $136
  1023af:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023b4:	e9 94 05 00 00       	jmp    10294d <__alltraps>

001023b9 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $137
  1023bb:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023c0:	e9 88 05 00 00       	jmp    10294d <__alltraps>

001023c5 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023c5:	6a 00                	push   $0x0
  pushl $138
  1023c7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023cc:	e9 7c 05 00 00       	jmp    10294d <__alltraps>

001023d1 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023d1:	6a 00                	push   $0x0
  pushl $139
  1023d3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023d8:	e9 70 05 00 00       	jmp    10294d <__alltraps>

001023dd <vector140>:
.globl vector140
vector140:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $140
  1023df:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023e4:	e9 64 05 00 00       	jmp    10294d <__alltraps>

001023e9 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023e9:	6a 00                	push   $0x0
  pushl $141
  1023eb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023f0:	e9 58 05 00 00       	jmp    10294d <__alltraps>

001023f5 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023f5:	6a 00                	push   $0x0
  pushl $142
  1023f7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023fc:	e9 4c 05 00 00       	jmp    10294d <__alltraps>

00102401 <vector143>:
.globl vector143
vector143:
  pushl $0
  102401:	6a 00                	push   $0x0
  pushl $143
  102403:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102408:	e9 40 05 00 00       	jmp    10294d <__alltraps>

0010240d <vector144>:
.globl vector144
vector144:
  pushl $0
  10240d:	6a 00                	push   $0x0
  pushl $144
  10240f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102414:	e9 34 05 00 00       	jmp    10294d <__alltraps>

00102419 <vector145>:
.globl vector145
vector145:
  pushl $0
  102419:	6a 00                	push   $0x0
  pushl $145
  10241b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102420:	e9 28 05 00 00       	jmp    10294d <__alltraps>

00102425 <vector146>:
.globl vector146
vector146:
  pushl $0
  102425:	6a 00                	push   $0x0
  pushl $146
  102427:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10242c:	e9 1c 05 00 00       	jmp    10294d <__alltraps>

00102431 <vector147>:
.globl vector147
vector147:
  pushl $0
  102431:	6a 00                	push   $0x0
  pushl $147
  102433:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102438:	e9 10 05 00 00       	jmp    10294d <__alltraps>

0010243d <vector148>:
.globl vector148
vector148:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $148
  10243f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102444:	e9 04 05 00 00       	jmp    10294d <__alltraps>

00102449 <vector149>:
.globl vector149
vector149:
  pushl $0
  102449:	6a 00                	push   $0x0
  pushl $149
  10244b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102450:	e9 f8 04 00 00       	jmp    10294d <__alltraps>

00102455 <vector150>:
.globl vector150
vector150:
  pushl $0
  102455:	6a 00                	push   $0x0
  pushl $150
  102457:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10245c:	e9 ec 04 00 00       	jmp    10294d <__alltraps>

00102461 <vector151>:
.globl vector151
vector151:
  pushl $0
  102461:	6a 00                	push   $0x0
  pushl $151
  102463:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102468:	e9 e0 04 00 00       	jmp    10294d <__alltraps>

0010246d <vector152>:
.globl vector152
vector152:
  pushl $0
  10246d:	6a 00                	push   $0x0
  pushl $152
  10246f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102474:	e9 d4 04 00 00       	jmp    10294d <__alltraps>

00102479 <vector153>:
.globl vector153
vector153:
  pushl $0
  102479:	6a 00                	push   $0x0
  pushl $153
  10247b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102480:	e9 c8 04 00 00       	jmp    10294d <__alltraps>

00102485 <vector154>:
.globl vector154
vector154:
  pushl $0
  102485:	6a 00                	push   $0x0
  pushl $154
  102487:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10248c:	e9 bc 04 00 00       	jmp    10294d <__alltraps>

00102491 <vector155>:
.globl vector155
vector155:
  pushl $0
  102491:	6a 00                	push   $0x0
  pushl $155
  102493:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102498:	e9 b0 04 00 00       	jmp    10294d <__alltraps>

0010249d <vector156>:
.globl vector156
vector156:
  pushl $0
  10249d:	6a 00                	push   $0x0
  pushl $156
  10249f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024a4:	e9 a4 04 00 00       	jmp    10294d <__alltraps>

001024a9 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024a9:	6a 00                	push   $0x0
  pushl $157
  1024ab:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024b0:	e9 98 04 00 00       	jmp    10294d <__alltraps>

001024b5 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024b5:	6a 00                	push   $0x0
  pushl $158
  1024b7:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024bc:	e9 8c 04 00 00       	jmp    10294d <__alltraps>

001024c1 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024c1:	6a 00                	push   $0x0
  pushl $159
  1024c3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024c8:	e9 80 04 00 00       	jmp    10294d <__alltraps>

001024cd <vector160>:
.globl vector160
vector160:
  pushl $0
  1024cd:	6a 00                	push   $0x0
  pushl $160
  1024cf:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024d4:	e9 74 04 00 00       	jmp    10294d <__alltraps>

001024d9 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024d9:	6a 00                	push   $0x0
  pushl $161
  1024db:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024e0:	e9 68 04 00 00       	jmp    10294d <__alltraps>

001024e5 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024e5:	6a 00                	push   $0x0
  pushl $162
  1024e7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024ec:	e9 5c 04 00 00       	jmp    10294d <__alltraps>

001024f1 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024f1:	6a 00                	push   $0x0
  pushl $163
  1024f3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024f8:	e9 50 04 00 00       	jmp    10294d <__alltraps>

001024fd <vector164>:
.globl vector164
vector164:
  pushl $0
  1024fd:	6a 00                	push   $0x0
  pushl $164
  1024ff:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102504:	e9 44 04 00 00       	jmp    10294d <__alltraps>

00102509 <vector165>:
.globl vector165
vector165:
  pushl $0
  102509:	6a 00                	push   $0x0
  pushl $165
  10250b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102510:	e9 38 04 00 00       	jmp    10294d <__alltraps>

00102515 <vector166>:
.globl vector166
vector166:
  pushl $0
  102515:	6a 00                	push   $0x0
  pushl $166
  102517:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10251c:	e9 2c 04 00 00       	jmp    10294d <__alltraps>

00102521 <vector167>:
.globl vector167
vector167:
  pushl $0
  102521:	6a 00                	push   $0x0
  pushl $167
  102523:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102528:	e9 20 04 00 00       	jmp    10294d <__alltraps>

0010252d <vector168>:
.globl vector168
vector168:
  pushl $0
  10252d:	6a 00                	push   $0x0
  pushl $168
  10252f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102534:	e9 14 04 00 00       	jmp    10294d <__alltraps>

00102539 <vector169>:
.globl vector169
vector169:
  pushl $0
  102539:	6a 00                	push   $0x0
  pushl $169
  10253b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102540:	e9 08 04 00 00       	jmp    10294d <__alltraps>

00102545 <vector170>:
.globl vector170
vector170:
  pushl $0
  102545:	6a 00                	push   $0x0
  pushl $170
  102547:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10254c:	e9 fc 03 00 00       	jmp    10294d <__alltraps>

00102551 <vector171>:
.globl vector171
vector171:
  pushl $0
  102551:	6a 00                	push   $0x0
  pushl $171
  102553:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102558:	e9 f0 03 00 00       	jmp    10294d <__alltraps>

0010255d <vector172>:
.globl vector172
vector172:
  pushl $0
  10255d:	6a 00                	push   $0x0
  pushl $172
  10255f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102564:	e9 e4 03 00 00       	jmp    10294d <__alltraps>

00102569 <vector173>:
.globl vector173
vector173:
  pushl $0
  102569:	6a 00                	push   $0x0
  pushl $173
  10256b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102570:	e9 d8 03 00 00       	jmp    10294d <__alltraps>

00102575 <vector174>:
.globl vector174
vector174:
  pushl $0
  102575:	6a 00                	push   $0x0
  pushl $174
  102577:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10257c:	e9 cc 03 00 00       	jmp    10294d <__alltraps>

00102581 <vector175>:
.globl vector175
vector175:
  pushl $0
  102581:	6a 00                	push   $0x0
  pushl $175
  102583:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102588:	e9 c0 03 00 00       	jmp    10294d <__alltraps>

0010258d <vector176>:
.globl vector176
vector176:
  pushl $0
  10258d:	6a 00                	push   $0x0
  pushl $176
  10258f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102594:	e9 b4 03 00 00       	jmp    10294d <__alltraps>

00102599 <vector177>:
.globl vector177
vector177:
  pushl $0
  102599:	6a 00                	push   $0x0
  pushl $177
  10259b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025a0:	e9 a8 03 00 00       	jmp    10294d <__alltraps>

001025a5 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025a5:	6a 00                	push   $0x0
  pushl $178
  1025a7:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025ac:	e9 9c 03 00 00       	jmp    10294d <__alltraps>

001025b1 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025b1:	6a 00                	push   $0x0
  pushl $179
  1025b3:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025b8:	e9 90 03 00 00       	jmp    10294d <__alltraps>

001025bd <vector180>:
.globl vector180
vector180:
  pushl $0
  1025bd:	6a 00                	push   $0x0
  pushl $180
  1025bf:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025c4:	e9 84 03 00 00       	jmp    10294d <__alltraps>

001025c9 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025c9:	6a 00                	push   $0x0
  pushl $181
  1025cb:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025d0:	e9 78 03 00 00       	jmp    10294d <__alltraps>

001025d5 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025d5:	6a 00                	push   $0x0
  pushl $182
  1025d7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025dc:	e9 6c 03 00 00       	jmp    10294d <__alltraps>

001025e1 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025e1:	6a 00                	push   $0x0
  pushl $183
  1025e3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025e8:	e9 60 03 00 00       	jmp    10294d <__alltraps>

001025ed <vector184>:
.globl vector184
vector184:
  pushl $0
  1025ed:	6a 00                	push   $0x0
  pushl $184
  1025ef:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025f4:	e9 54 03 00 00       	jmp    10294d <__alltraps>

001025f9 <vector185>:
.globl vector185
vector185:
  pushl $0
  1025f9:	6a 00                	push   $0x0
  pushl $185
  1025fb:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102600:	e9 48 03 00 00       	jmp    10294d <__alltraps>

00102605 <vector186>:
.globl vector186
vector186:
  pushl $0
  102605:	6a 00                	push   $0x0
  pushl $186
  102607:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10260c:	e9 3c 03 00 00       	jmp    10294d <__alltraps>

00102611 <vector187>:
.globl vector187
vector187:
  pushl $0
  102611:	6a 00                	push   $0x0
  pushl $187
  102613:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102618:	e9 30 03 00 00       	jmp    10294d <__alltraps>

0010261d <vector188>:
.globl vector188
vector188:
  pushl $0
  10261d:	6a 00                	push   $0x0
  pushl $188
  10261f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102624:	e9 24 03 00 00       	jmp    10294d <__alltraps>

00102629 <vector189>:
.globl vector189
vector189:
  pushl $0
  102629:	6a 00                	push   $0x0
  pushl $189
  10262b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102630:	e9 18 03 00 00       	jmp    10294d <__alltraps>

00102635 <vector190>:
.globl vector190
vector190:
  pushl $0
  102635:	6a 00                	push   $0x0
  pushl $190
  102637:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10263c:	e9 0c 03 00 00       	jmp    10294d <__alltraps>

00102641 <vector191>:
.globl vector191
vector191:
  pushl $0
  102641:	6a 00                	push   $0x0
  pushl $191
  102643:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102648:	e9 00 03 00 00       	jmp    10294d <__alltraps>

0010264d <vector192>:
.globl vector192
vector192:
  pushl $0
  10264d:	6a 00                	push   $0x0
  pushl $192
  10264f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102654:	e9 f4 02 00 00       	jmp    10294d <__alltraps>

00102659 <vector193>:
.globl vector193
vector193:
  pushl $0
  102659:	6a 00                	push   $0x0
  pushl $193
  10265b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102660:	e9 e8 02 00 00       	jmp    10294d <__alltraps>

00102665 <vector194>:
.globl vector194
vector194:
  pushl $0
  102665:	6a 00                	push   $0x0
  pushl $194
  102667:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10266c:	e9 dc 02 00 00       	jmp    10294d <__alltraps>

00102671 <vector195>:
.globl vector195
vector195:
  pushl $0
  102671:	6a 00                	push   $0x0
  pushl $195
  102673:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102678:	e9 d0 02 00 00       	jmp    10294d <__alltraps>

0010267d <vector196>:
.globl vector196
vector196:
  pushl $0
  10267d:	6a 00                	push   $0x0
  pushl $196
  10267f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102684:	e9 c4 02 00 00       	jmp    10294d <__alltraps>

00102689 <vector197>:
.globl vector197
vector197:
  pushl $0
  102689:	6a 00                	push   $0x0
  pushl $197
  10268b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102690:	e9 b8 02 00 00       	jmp    10294d <__alltraps>

00102695 <vector198>:
.globl vector198
vector198:
  pushl $0
  102695:	6a 00                	push   $0x0
  pushl $198
  102697:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10269c:	e9 ac 02 00 00       	jmp    10294d <__alltraps>

001026a1 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026a1:	6a 00                	push   $0x0
  pushl $199
  1026a3:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026a8:	e9 a0 02 00 00       	jmp    10294d <__alltraps>

001026ad <vector200>:
.globl vector200
vector200:
  pushl $0
  1026ad:	6a 00                	push   $0x0
  pushl $200
  1026af:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026b4:	e9 94 02 00 00       	jmp    10294d <__alltraps>

001026b9 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026b9:	6a 00                	push   $0x0
  pushl $201
  1026bb:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026c0:	e9 88 02 00 00       	jmp    10294d <__alltraps>

001026c5 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026c5:	6a 00                	push   $0x0
  pushl $202
  1026c7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026cc:	e9 7c 02 00 00       	jmp    10294d <__alltraps>

001026d1 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026d1:	6a 00                	push   $0x0
  pushl $203
  1026d3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026d8:	e9 70 02 00 00       	jmp    10294d <__alltraps>

001026dd <vector204>:
.globl vector204
vector204:
  pushl $0
  1026dd:	6a 00                	push   $0x0
  pushl $204
  1026df:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026e4:	e9 64 02 00 00       	jmp    10294d <__alltraps>

001026e9 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026e9:	6a 00                	push   $0x0
  pushl $205
  1026eb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026f0:	e9 58 02 00 00       	jmp    10294d <__alltraps>

001026f5 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026f5:	6a 00                	push   $0x0
  pushl $206
  1026f7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026fc:	e9 4c 02 00 00       	jmp    10294d <__alltraps>

00102701 <vector207>:
.globl vector207
vector207:
  pushl $0
  102701:	6a 00                	push   $0x0
  pushl $207
  102703:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102708:	e9 40 02 00 00       	jmp    10294d <__alltraps>

0010270d <vector208>:
.globl vector208
vector208:
  pushl $0
  10270d:	6a 00                	push   $0x0
  pushl $208
  10270f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102714:	e9 34 02 00 00       	jmp    10294d <__alltraps>

00102719 <vector209>:
.globl vector209
vector209:
  pushl $0
  102719:	6a 00                	push   $0x0
  pushl $209
  10271b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102720:	e9 28 02 00 00       	jmp    10294d <__alltraps>

00102725 <vector210>:
.globl vector210
vector210:
  pushl $0
  102725:	6a 00                	push   $0x0
  pushl $210
  102727:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10272c:	e9 1c 02 00 00       	jmp    10294d <__alltraps>

00102731 <vector211>:
.globl vector211
vector211:
  pushl $0
  102731:	6a 00                	push   $0x0
  pushl $211
  102733:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102738:	e9 10 02 00 00       	jmp    10294d <__alltraps>

0010273d <vector212>:
.globl vector212
vector212:
  pushl $0
  10273d:	6a 00                	push   $0x0
  pushl $212
  10273f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102744:	e9 04 02 00 00       	jmp    10294d <__alltraps>

00102749 <vector213>:
.globl vector213
vector213:
  pushl $0
  102749:	6a 00                	push   $0x0
  pushl $213
  10274b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102750:	e9 f8 01 00 00       	jmp    10294d <__alltraps>

00102755 <vector214>:
.globl vector214
vector214:
  pushl $0
  102755:	6a 00                	push   $0x0
  pushl $214
  102757:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10275c:	e9 ec 01 00 00       	jmp    10294d <__alltraps>

00102761 <vector215>:
.globl vector215
vector215:
  pushl $0
  102761:	6a 00                	push   $0x0
  pushl $215
  102763:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102768:	e9 e0 01 00 00       	jmp    10294d <__alltraps>

0010276d <vector216>:
.globl vector216
vector216:
  pushl $0
  10276d:	6a 00                	push   $0x0
  pushl $216
  10276f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102774:	e9 d4 01 00 00       	jmp    10294d <__alltraps>

00102779 <vector217>:
.globl vector217
vector217:
  pushl $0
  102779:	6a 00                	push   $0x0
  pushl $217
  10277b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102780:	e9 c8 01 00 00       	jmp    10294d <__alltraps>

00102785 <vector218>:
.globl vector218
vector218:
  pushl $0
  102785:	6a 00                	push   $0x0
  pushl $218
  102787:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10278c:	e9 bc 01 00 00       	jmp    10294d <__alltraps>

00102791 <vector219>:
.globl vector219
vector219:
  pushl $0
  102791:	6a 00                	push   $0x0
  pushl $219
  102793:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102798:	e9 b0 01 00 00       	jmp    10294d <__alltraps>

0010279d <vector220>:
.globl vector220
vector220:
  pushl $0
  10279d:	6a 00                	push   $0x0
  pushl $220
  10279f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027a4:	e9 a4 01 00 00       	jmp    10294d <__alltraps>

001027a9 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027a9:	6a 00                	push   $0x0
  pushl $221
  1027ab:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027b0:	e9 98 01 00 00       	jmp    10294d <__alltraps>

001027b5 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027b5:	6a 00                	push   $0x0
  pushl $222
  1027b7:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027bc:	e9 8c 01 00 00       	jmp    10294d <__alltraps>

001027c1 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027c1:	6a 00                	push   $0x0
  pushl $223
  1027c3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027c8:	e9 80 01 00 00       	jmp    10294d <__alltraps>

001027cd <vector224>:
.globl vector224
vector224:
  pushl $0
  1027cd:	6a 00                	push   $0x0
  pushl $224
  1027cf:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027d4:	e9 74 01 00 00       	jmp    10294d <__alltraps>

001027d9 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027d9:	6a 00                	push   $0x0
  pushl $225
  1027db:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027e0:	e9 68 01 00 00       	jmp    10294d <__alltraps>

001027e5 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027e5:	6a 00                	push   $0x0
  pushl $226
  1027e7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027ec:	e9 5c 01 00 00       	jmp    10294d <__alltraps>

001027f1 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027f1:	6a 00                	push   $0x0
  pushl $227
  1027f3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027f8:	e9 50 01 00 00       	jmp    10294d <__alltraps>

001027fd <vector228>:
.globl vector228
vector228:
  pushl $0
  1027fd:	6a 00                	push   $0x0
  pushl $228
  1027ff:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102804:	e9 44 01 00 00       	jmp    10294d <__alltraps>

00102809 <vector229>:
.globl vector229
vector229:
  pushl $0
  102809:	6a 00                	push   $0x0
  pushl $229
  10280b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102810:	e9 38 01 00 00       	jmp    10294d <__alltraps>

00102815 <vector230>:
.globl vector230
vector230:
  pushl $0
  102815:	6a 00                	push   $0x0
  pushl $230
  102817:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10281c:	e9 2c 01 00 00       	jmp    10294d <__alltraps>

00102821 <vector231>:
.globl vector231
vector231:
  pushl $0
  102821:	6a 00                	push   $0x0
  pushl $231
  102823:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102828:	e9 20 01 00 00       	jmp    10294d <__alltraps>

0010282d <vector232>:
.globl vector232
vector232:
  pushl $0
  10282d:	6a 00                	push   $0x0
  pushl $232
  10282f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102834:	e9 14 01 00 00       	jmp    10294d <__alltraps>

00102839 <vector233>:
.globl vector233
vector233:
  pushl $0
  102839:	6a 00                	push   $0x0
  pushl $233
  10283b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102840:	e9 08 01 00 00       	jmp    10294d <__alltraps>

00102845 <vector234>:
.globl vector234
vector234:
  pushl $0
  102845:	6a 00                	push   $0x0
  pushl $234
  102847:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10284c:	e9 fc 00 00 00       	jmp    10294d <__alltraps>

00102851 <vector235>:
.globl vector235
vector235:
  pushl $0
  102851:	6a 00                	push   $0x0
  pushl $235
  102853:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102858:	e9 f0 00 00 00       	jmp    10294d <__alltraps>

0010285d <vector236>:
.globl vector236
vector236:
  pushl $0
  10285d:	6a 00                	push   $0x0
  pushl $236
  10285f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102864:	e9 e4 00 00 00       	jmp    10294d <__alltraps>

00102869 <vector237>:
.globl vector237
vector237:
  pushl $0
  102869:	6a 00                	push   $0x0
  pushl $237
  10286b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102870:	e9 d8 00 00 00       	jmp    10294d <__alltraps>

00102875 <vector238>:
.globl vector238
vector238:
  pushl $0
  102875:	6a 00                	push   $0x0
  pushl $238
  102877:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10287c:	e9 cc 00 00 00       	jmp    10294d <__alltraps>

00102881 <vector239>:
.globl vector239
vector239:
  pushl $0
  102881:	6a 00                	push   $0x0
  pushl $239
  102883:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102888:	e9 c0 00 00 00       	jmp    10294d <__alltraps>

0010288d <vector240>:
.globl vector240
vector240:
  pushl $0
  10288d:	6a 00                	push   $0x0
  pushl $240
  10288f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102894:	e9 b4 00 00 00       	jmp    10294d <__alltraps>

00102899 <vector241>:
.globl vector241
vector241:
  pushl $0
  102899:	6a 00                	push   $0x0
  pushl $241
  10289b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028a0:	e9 a8 00 00 00       	jmp    10294d <__alltraps>

001028a5 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028a5:	6a 00                	push   $0x0
  pushl $242
  1028a7:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028ac:	e9 9c 00 00 00       	jmp    10294d <__alltraps>

001028b1 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028b1:	6a 00                	push   $0x0
  pushl $243
  1028b3:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028b8:	e9 90 00 00 00       	jmp    10294d <__alltraps>

001028bd <vector244>:
.globl vector244
vector244:
  pushl $0
  1028bd:	6a 00                	push   $0x0
  pushl $244
  1028bf:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028c4:	e9 84 00 00 00       	jmp    10294d <__alltraps>

001028c9 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028c9:	6a 00                	push   $0x0
  pushl $245
  1028cb:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028d0:	e9 78 00 00 00       	jmp    10294d <__alltraps>

001028d5 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028d5:	6a 00                	push   $0x0
  pushl $246
  1028d7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028dc:	e9 6c 00 00 00       	jmp    10294d <__alltraps>

001028e1 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028e1:	6a 00                	push   $0x0
  pushl $247
  1028e3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028e8:	e9 60 00 00 00       	jmp    10294d <__alltraps>

001028ed <vector248>:
.globl vector248
vector248:
  pushl $0
  1028ed:	6a 00                	push   $0x0
  pushl $248
  1028ef:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028f4:	e9 54 00 00 00       	jmp    10294d <__alltraps>

001028f9 <vector249>:
.globl vector249
vector249:
  pushl $0
  1028f9:	6a 00                	push   $0x0
  pushl $249
  1028fb:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102900:	e9 48 00 00 00       	jmp    10294d <__alltraps>

00102905 <vector250>:
.globl vector250
vector250:
  pushl $0
  102905:	6a 00                	push   $0x0
  pushl $250
  102907:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10290c:	e9 3c 00 00 00       	jmp    10294d <__alltraps>

00102911 <vector251>:
.globl vector251
vector251:
  pushl $0
  102911:	6a 00                	push   $0x0
  pushl $251
  102913:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102918:	e9 30 00 00 00       	jmp    10294d <__alltraps>

0010291d <vector252>:
.globl vector252
vector252:
  pushl $0
  10291d:	6a 00                	push   $0x0
  pushl $252
  10291f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102924:	e9 24 00 00 00       	jmp    10294d <__alltraps>

00102929 <vector253>:
.globl vector253
vector253:
  pushl $0
  102929:	6a 00                	push   $0x0
  pushl $253
  10292b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102930:	e9 18 00 00 00       	jmp    10294d <__alltraps>

00102935 <vector254>:
.globl vector254
vector254:
  pushl $0
  102935:	6a 00                	push   $0x0
  pushl $254
  102937:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10293c:	e9 0c 00 00 00       	jmp    10294d <__alltraps>

00102941 <vector255>:
.globl vector255
vector255:
  pushl $0
  102941:	6a 00                	push   $0x0
  pushl $255
  102943:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102948:	e9 00 00 00 00       	jmp    10294d <__alltraps>

0010294d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10294d:	1e                   	push   %ds
    pushl %es
  10294e:	06                   	push   %es
    pushl %fs
  10294f:	0f a0                	push   %fs
    pushl %gs
  102951:	0f a8                	push   %gs
    pushal
  102953:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102954:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102959:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10295b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10295d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10295e:	e8 60 f5 ff ff       	call   101ec3 <trap>

    # pop the pushed stack pointer
    popl %esp
  102963:	5c                   	pop    %esp

00102964 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102964:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102965:	0f a9                	pop    %gs
    popl %fs
  102967:	0f a1                	pop    %fs
    popl %es
  102969:	07                   	pop    %es
    popl %ds
  10296a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10296b:	83 c4 08             	add    $0x8,%esp
    iret
  10296e:	cf                   	iret   

0010296f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10296f:	55                   	push   %ebp
  102970:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102972:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  102977:	8b 55 08             	mov    0x8(%ebp),%edx
  10297a:	29 c2                	sub    %eax,%edx
  10297c:	89 d0                	mov    %edx,%eax
  10297e:	c1 f8 02             	sar    $0x2,%eax
  102981:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102987:	5d                   	pop    %ebp
  102988:	c3                   	ret    

00102989 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102989:	55                   	push   %ebp
  10298a:	89 e5                	mov    %esp,%ebp
  10298c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10298f:	8b 45 08             	mov    0x8(%ebp),%eax
  102992:	89 04 24             	mov    %eax,(%esp)
  102995:	e8 d5 ff ff ff       	call   10296f <page2ppn>
  10299a:	c1 e0 0c             	shl    $0xc,%eax
}
  10299d:	c9                   	leave  
  10299e:	c3                   	ret    

0010299f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  10299f:	55                   	push   %ebp
  1029a0:	89 e5                	mov    %esp,%ebp
  1029a2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a8:	c1 e8 0c             	shr    $0xc,%eax
  1029ab:	89 c2                	mov    %eax,%edx
  1029ad:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1029b2:	39 c2                	cmp    %eax,%edx
  1029b4:	72 1c                	jb     1029d2 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1029b6:	c7 44 24 08 50 68 10 	movl   $0x106850,0x8(%esp)
  1029bd:	00 
  1029be:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1029c5:	00 
  1029c6:	c7 04 24 6f 68 10 00 	movl   $0x10686f,(%esp)
  1029cd:	e8 54 da ff ff       	call   100426 <__panic>
    }
    return &pages[PPN(pa)];
  1029d2:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  1029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1029db:	c1 e8 0c             	shr    $0xc,%eax
  1029de:	89 c2                	mov    %eax,%edx
  1029e0:	89 d0                	mov    %edx,%eax
  1029e2:	c1 e0 02             	shl    $0x2,%eax
  1029e5:	01 d0                	add    %edx,%eax
  1029e7:	c1 e0 02             	shl    $0x2,%eax
  1029ea:	01 c8                	add    %ecx,%eax
}
  1029ec:	c9                   	leave  
  1029ed:	c3                   	ret    

001029ee <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1029ee:	55                   	push   %ebp
  1029ef:	89 e5                	mov    %esp,%ebp
  1029f1:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  1029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f7:	89 04 24             	mov    %eax,(%esp)
  1029fa:	e8 8a ff ff ff       	call   102989 <page2pa>
  1029ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a05:	c1 e8 0c             	shr    $0xc,%eax
  102a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a0b:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102a10:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102a13:	72 23                	jb     102a38 <page2kva+0x4a>
  102a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a18:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102a1c:	c7 44 24 08 80 68 10 	movl   $0x106880,0x8(%esp)
  102a23:	00 
  102a24:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102a2b:	00 
  102a2c:	c7 04 24 6f 68 10 00 	movl   $0x10686f,(%esp)
  102a33:	e8 ee d9 ff ff       	call   100426 <__panic>
  102a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a3b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102a40:	c9                   	leave  
  102a41:	c3                   	ret    

00102a42 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102a42:	55                   	push   %ebp
  102a43:	89 e5                	mov    %esp,%ebp
  102a45:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102a48:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4b:	83 e0 01             	and    $0x1,%eax
  102a4e:	85 c0                	test   %eax,%eax
  102a50:	75 1c                	jne    102a6e <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102a52:	c7 44 24 08 a4 68 10 	movl   $0x1068a4,0x8(%esp)
  102a59:	00 
  102a5a:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102a61:	00 
  102a62:	c7 04 24 6f 68 10 00 	movl   $0x10686f,(%esp)
  102a69:	e8 b8 d9 ff ff       	call   100426 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a76:	89 04 24             	mov    %eax,(%esp)
  102a79:	e8 21 ff ff ff       	call   10299f <pa2page>
}
  102a7e:	c9                   	leave  
  102a7f:	c3                   	ret    

00102a80 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102a80:	55                   	push   %ebp
  102a81:	89 e5                	mov    %esp,%ebp
  102a83:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102a86:	8b 45 08             	mov    0x8(%ebp),%eax
  102a89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a8e:	89 04 24             	mov    %eax,(%esp)
  102a91:	e8 09 ff ff ff       	call   10299f <pa2page>
}
  102a96:	c9                   	leave  
  102a97:	c3                   	ret    

00102a98 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102a98:	55                   	push   %ebp
  102a99:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9e:	8b 00                	mov    (%eax),%eax
}
  102aa0:	5d                   	pop    %ebp
  102aa1:	c3                   	ret    

00102aa2 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102aa2:	55                   	push   %ebp
  102aa3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  102aab:	89 10                	mov    %edx,(%eax)
}
  102aad:	90                   	nop
  102aae:	5d                   	pop    %ebp
  102aaf:	c3                   	ret    

00102ab0 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102ab0:	55                   	push   %ebp
  102ab1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab6:	8b 00                	mov    (%eax),%eax
  102ab8:	8d 50 01             	lea    0x1(%eax),%edx
  102abb:	8b 45 08             	mov    0x8(%ebp),%eax
  102abe:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac3:	8b 00                	mov    (%eax),%eax
}
  102ac5:	5d                   	pop    %ebp
  102ac6:	c3                   	ret    

00102ac7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102ac7:	55                   	push   %ebp
  102ac8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102aca:	8b 45 08             	mov    0x8(%ebp),%eax
  102acd:	8b 00                	mov    (%eax),%eax
  102acf:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad5:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  102ada:	8b 00                	mov    (%eax),%eax
}
  102adc:	5d                   	pop    %ebp
  102add:	c3                   	ret    

00102ade <__intr_save>:
__intr_save(void) {
  102ade:	55                   	push   %ebp
  102adf:	89 e5                	mov    %esp,%ebp
  102ae1:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102ae4:	9c                   	pushf  
  102ae5:	58                   	pop    %eax
  102ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102aec:	25 00 02 00 00       	and    $0x200,%eax
  102af1:	85 c0                	test   %eax,%eax
  102af3:	74 0c                	je     102b01 <__intr_save+0x23>
        intr_disable();
  102af5:	e8 84 ee ff ff       	call   10197e <intr_disable>
        return 1;
  102afa:	b8 01 00 00 00       	mov    $0x1,%eax
  102aff:	eb 05                	jmp    102b06 <__intr_save+0x28>
    return 0;
  102b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b06:	c9                   	leave  
  102b07:	c3                   	ret    

00102b08 <__intr_restore>:
__intr_restore(bool flag) {
  102b08:	55                   	push   %ebp
  102b09:	89 e5                	mov    %esp,%ebp
  102b0b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102b0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b12:	74 05                	je     102b19 <__intr_restore+0x11>
        intr_enable();
  102b14:	e8 59 ee ff ff       	call   101972 <intr_enable>
}
  102b19:	90                   	nop
  102b1a:	c9                   	leave  
  102b1b:	c3                   	ret    

00102b1c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b1c:	55                   	push   %ebp
  102b1d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b22:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b25:	b8 23 00 00 00       	mov    $0x23,%eax
  102b2a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b2c:	b8 23 00 00 00       	mov    $0x23,%eax
  102b31:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b33:	b8 10 00 00 00       	mov    $0x10,%eax
  102b38:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b3a:	b8 10 00 00 00       	mov    $0x10,%eax
  102b3f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b41:	b8 10 00 00 00       	mov    $0x10,%eax
  102b46:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b48:	ea 4f 2b 10 00 08 00 	ljmp   $0x8,$0x102b4f
}
  102b4f:	90                   	nop
  102b50:	5d                   	pop    %ebp
  102b51:	c3                   	ret    

00102b52 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102b52:	f3 0f 1e fb          	endbr32 
  102b56:	55                   	push   %ebp
  102b57:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102b59:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5c:	a3 a4 ce 11 00       	mov    %eax,0x11cea4
}
  102b61:	90                   	nop
  102b62:	5d                   	pop    %ebp
  102b63:	c3                   	ret    

00102b64 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b64:	f3 0f 1e fb          	endbr32 
  102b68:	55                   	push   %ebp
  102b69:	89 e5                	mov    %esp,%ebp
  102b6b:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102b6e:	b8 00 90 11 00       	mov    $0x119000,%eax
  102b73:	89 04 24             	mov    %eax,(%esp)
  102b76:	e8 d7 ff ff ff       	call   102b52 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102b7b:	66 c7 05 a8 ce 11 00 	movw   $0x10,0x11cea8
  102b82:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102b84:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  102b8b:	68 00 
  102b8d:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102b92:	0f b7 c0             	movzwl %ax,%eax
  102b95:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  102b9b:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102ba0:	c1 e8 10             	shr    $0x10,%eax
  102ba3:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  102ba8:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102baf:	24 f0                	and    $0xf0,%al
  102bb1:	0c 09                	or     $0x9,%al
  102bb3:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102bb8:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102bbf:	24 ef                	and    $0xef,%al
  102bc1:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102bc6:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102bcd:	24 9f                	and    $0x9f,%al
  102bcf:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102bd4:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102bdb:	0c 80                	or     $0x80,%al
  102bdd:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102be2:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102be9:	24 f0                	and    $0xf0,%al
  102beb:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bf0:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bf7:	24 ef                	and    $0xef,%al
  102bf9:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bfe:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102c05:	24 df                	and    $0xdf,%al
  102c07:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102c0c:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102c13:	0c 40                	or     $0x40,%al
  102c15:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102c1a:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102c21:	24 7f                	and    $0x7f,%al
  102c23:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102c28:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102c2d:	c1 e8 18             	shr    $0x18,%eax
  102c30:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102c35:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  102c3c:	e8 db fe ff ff       	call   102b1c <lgdt>
  102c41:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102c47:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c4b:	0f 00 d8             	ltr    %ax
}
  102c4e:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102c4f:	90                   	nop
  102c50:	c9                   	leave  
  102c51:	c3                   	ret    

00102c52 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102c52:	f3 0f 1e fb          	endbr32 
  102c56:	55                   	push   %ebp
  102c57:	89 e5                	mov    %esp,%ebp
  102c59:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102c5c:	c7 05 10 cf 11 00 48 	movl   $0x107248,0x11cf10
  102c63:	72 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102c66:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c6b:	8b 00                	mov    (%eax),%eax
  102c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c71:	c7 04 24 d0 68 10 00 	movl   $0x1068d0,(%esp)
  102c78:	e8 3d d6 ff ff       	call   1002ba <cprintf>
    pmm_manager->init();
  102c7d:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c82:	8b 40 04             	mov    0x4(%eax),%eax
  102c85:	ff d0                	call   *%eax
}
  102c87:	90                   	nop
  102c88:	c9                   	leave  
  102c89:	c3                   	ret    

00102c8a <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102c8a:	f3 0f 1e fb          	endbr32 
  102c8e:	55                   	push   %ebp
  102c8f:	89 e5                	mov    %esp,%ebp
  102c91:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102c94:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c99:	8b 40 08             	mov    0x8(%eax),%eax
  102c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c9f:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  102ca6:	89 14 24             	mov    %edx,(%esp)
  102ca9:	ff d0                	call   *%eax
}
  102cab:	90                   	nop
  102cac:	c9                   	leave  
  102cad:	c3                   	ret    

00102cae <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102cae:	f3 0f 1e fb          	endbr32 
  102cb2:	55                   	push   %ebp
  102cb3:	89 e5                	mov    %esp,%ebp
  102cb5:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102cb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102cbf:	e8 1a fe ff ff       	call   102ade <__intr_save>
  102cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102cc7:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  102ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  102cd2:	89 14 24             	mov    %edx,(%esp)
  102cd5:	ff d0                	call   *%eax
  102cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cdd:	89 04 24             	mov    %eax,(%esp)
  102ce0:	e8 23 fe ff ff       	call   102b08 <__intr_restore>
    return page;
  102ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ce8:	c9                   	leave  
  102ce9:	c3                   	ret    

00102cea <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102cea:	f3 0f 1e fb          	endbr32 
  102cee:	55                   	push   %ebp
  102cef:	89 e5                	mov    %esp,%ebp
  102cf1:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102cf4:	e8 e5 fd ff ff       	call   102ade <__intr_save>
  102cf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102cfc:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d01:	8b 40 10             	mov    0x10(%eax),%eax
  102d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d07:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  102d0e:	89 14 24             	mov    %edx,(%esp)
  102d11:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d16:	89 04 24             	mov    %eax,(%esp)
  102d19:	e8 ea fd ff ff       	call   102b08 <__intr_restore>
}
  102d1e:	90                   	nop
  102d1f:	c9                   	leave  
  102d20:	c3                   	ret    

00102d21 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102d21:	f3 0f 1e fb          	endbr32 
  102d25:	55                   	push   %ebp
  102d26:	89 e5                	mov    %esp,%ebp
  102d28:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102d2b:	e8 ae fd ff ff       	call   102ade <__intr_save>
  102d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102d33:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d38:	8b 40 14             	mov    0x14(%eax),%eax
  102d3b:	ff d0                	call   *%eax
  102d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d43:	89 04 24             	mov    %eax,(%esp)
  102d46:	e8 bd fd ff ff       	call   102b08 <__intr_restore>
    return ret;
  102d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102d4e:	c9                   	leave  
  102d4f:	c3                   	ret    

00102d50 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102d50:	f3 0f 1e fb          	endbr32 
  102d54:	55                   	push   %ebp
  102d55:	89 e5                	mov    %esp,%ebp
  102d57:	57                   	push   %edi
  102d58:	56                   	push   %esi
  102d59:	53                   	push   %ebx
  102d5a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102d60:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102d67:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102d6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102d75:	c7 04 24 e7 68 10 00 	movl   $0x1068e7,(%esp)
  102d7c:	e8 39 d5 ff ff       	call   1002ba <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102d81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d88:	e9 1a 01 00 00       	jmp    102ea7 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102d8d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d93:	89 d0                	mov    %edx,%eax
  102d95:	c1 e0 02             	shl    $0x2,%eax
  102d98:	01 d0                	add    %edx,%eax
  102d9a:	c1 e0 02             	shl    $0x2,%eax
  102d9d:	01 c8                	add    %ecx,%eax
  102d9f:	8b 50 08             	mov    0x8(%eax),%edx
  102da2:	8b 40 04             	mov    0x4(%eax),%eax
  102da5:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102da8:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102dab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102dae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102db1:	89 d0                	mov    %edx,%eax
  102db3:	c1 e0 02             	shl    $0x2,%eax
  102db6:	01 d0                	add    %edx,%eax
  102db8:	c1 e0 02             	shl    $0x2,%eax
  102dbb:	01 c8                	add    %ecx,%eax
  102dbd:	8b 48 0c             	mov    0xc(%eax),%ecx
  102dc0:	8b 58 10             	mov    0x10(%eax),%ebx
  102dc3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102dc6:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102dc9:	01 c8                	add    %ecx,%eax
  102dcb:	11 da                	adc    %ebx,%edx
  102dcd:	89 45 98             	mov    %eax,-0x68(%ebp)
  102dd0:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102dd3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dd9:	89 d0                	mov    %edx,%eax
  102ddb:	c1 e0 02             	shl    $0x2,%eax
  102dde:	01 d0                	add    %edx,%eax
  102de0:	c1 e0 02             	shl    $0x2,%eax
  102de3:	01 c8                	add    %ecx,%eax
  102de5:	83 c0 14             	add    $0x14,%eax
  102de8:	8b 00                	mov    (%eax),%eax
  102dea:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102ded:	8b 45 98             	mov    -0x68(%ebp),%eax
  102df0:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102df3:	83 c0 ff             	add    $0xffffffff,%eax
  102df6:	83 d2 ff             	adc    $0xffffffff,%edx
  102df9:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102dff:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102e05:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e0b:	89 d0                	mov    %edx,%eax
  102e0d:	c1 e0 02             	shl    $0x2,%eax
  102e10:	01 d0                	add    %edx,%eax
  102e12:	c1 e0 02             	shl    $0x2,%eax
  102e15:	01 c8                	add    %ecx,%eax
  102e17:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e1a:	8b 58 10             	mov    0x10(%eax),%ebx
  102e1d:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102e20:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102e24:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102e2a:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102e30:	89 44 24 14          	mov    %eax,0x14(%esp)
  102e34:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e38:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e3b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e42:	89 54 24 10          	mov    %edx,0x10(%esp)
  102e46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102e4a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102e4e:	c7 04 24 f4 68 10 00 	movl   $0x1068f4,(%esp)
  102e55:	e8 60 d4 ff ff       	call   1002ba <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102e5a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e60:	89 d0                	mov    %edx,%eax
  102e62:	c1 e0 02             	shl    $0x2,%eax
  102e65:	01 d0                	add    %edx,%eax
  102e67:	c1 e0 02             	shl    $0x2,%eax
  102e6a:	01 c8                	add    %ecx,%eax
  102e6c:	83 c0 14             	add    $0x14,%eax
  102e6f:	8b 00                	mov    (%eax),%eax
  102e71:	83 f8 01             	cmp    $0x1,%eax
  102e74:	75 2e                	jne    102ea4 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
  102e76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e7c:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102e7f:	89 d0                	mov    %edx,%eax
  102e81:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  102e84:	73 1e                	jae    102ea4 <page_init+0x154>
  102e86:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  102e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  102e90:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  102e93:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  102e96:	72 0c                	jb     102ea4 <page_init+0x154>
                maxpa = end;
  102e98:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e9b:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102e9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ea1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102ea4:	ff 45 dc             	incl   -0x24(%ebp)
  102ea7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102eaa:	8b 00                	mov    (%eax),%eax
  102eac:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102eaf:	0f 8c d8 fe ff ff    	jl     102d8d <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102eb5:	ba 00 00 00 38       	mov    $0x38000000,%edx
  102eba:	b8 00 00 00 00       	mov    $0x0,%eax
  102ebf:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  102ec2:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  102ec5:	73 0e                	jae    102ed5 <page_init+0x185>
        maxpa = KMEMSIZE;
  102ec7:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102ece:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102edb:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102edf:	c1 ea 0c             	shr    $0xc,%edx
  102ee2:	a3 80 ce 11 00       	mov    %eax,0x11ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102ee7:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  102eee:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  102ef3:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ef6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ef9:	01 d0                	add    %edx,%eax
  102efb:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102efe:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102f01:	ba 00 00 00 00       	mov    $0x0,%edx
  102f06:	f7 75 c0             	divl   -0x40(%ebp)
  102f09:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102f0c:	29 d0                	sub    %edx,%eax
  102f0e:	a3 18 cf 11 00       	mov    %eax,0x11cf18

    for (i = 0; i < npage; i ++) {
  102f13:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f1a:	eb 2f                	jmp    102f4b <page_init+0x1fb>
        SetPageReserved(pages + i);
  102f1c:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  102f22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f25:	89 d0                	mov    %edx,%eax
  102f27:	c1 e0 02             	shl    $0x2,%eax
  102f2a:	01 d0                	add    %edx,%eax
  102f2c:	c1 e0 02             	shl    $0x2,%eax
  102f2f:	01 c8                	add    %ecx,%eax
  102f31:	83 c0 04             	add    $0x4,%eax
  102f34:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  102f3b:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f3e:	8b 45 90             	mov    -0x70(%ebp),%eax
  102f41:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102f44:	0f ab 10             	bts    %edx,(%eax)
}
  102f47:	90                   	nop
    for (i = 0; i < npage; i ++) {
  102f48:	ff 45 dc             	incl   -0x24(%ebp)
  102f4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f4e:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102f53:	39 c2                	cmp    %eax,%edx
  102f55:	72 c5                	jb     102f1c <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102f57:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  102f5d:	89 d0                	mov    %edx,%eax
  102f5f:	c1 e0 02             	shl    $0x2,%eax
  102f62:	01 d0                	add    %edx,%eax
  102f64:	c1 e0 02             	shl    $0x2,%eax
  102f67:	89 c2                	mov    %eax,%edx
  102f69:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  102f6e:	01 d0                	add    %edx,%eax
  102f70:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102f73:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  102f7a:	77 23                	ja     102f9f <page_init+0x24f>
  102f7c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102f7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f83:	c7 44 24 08 24 69 10 	movl   $0x106924,0x8(%esp)
  102f8a:	00 
  102f8b:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102f92:	00 
  102f93:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  102f9a:	e8 87 d4 ff ff       	call   100426 <__panic>
  102f9f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102fa2:	05 00 00 00 40       	add    $0x40000000,%eax
  102fa7:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102faa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fb1:	e9 4b 01 00 00       	jmp    103101 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102fb6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fb9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fbc:	89 d0                	mov    %edx,%eax
  102fbe:	c1 e0 02             	shl    $0x2,%eax
  102fc1:	01 d0                	add    %edx,%eax
  102fc3:	c1 e0 02             	shl    $0x2,%eax
  102fc6:	01 c8                	add    %ecx,%eax
  102fc8:	8b 50 08             	mov    0x8(%eax),%edx
  102fcb:	8b 40 04             	mov    0x4(%eax),%eax
  102fce:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102fd1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fd4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fd7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fda:	89 d0                	mov    %edx,%eax
  102fdc:	c1 e0 02             	shl    $0x2,%eax
  102fdf:	01 d0                	add    %edx,%eax
  102fe1:	c1 e0 02             	shl    $0x2,%eax
  102fe4:	01 c8                	add    %ecx,%eax
  102fe6:	8b 48 0c             	mov    0xc(%eax),%ecx
  102fe9:	8b 58 10             	mov    0x10(%eax),%ebx
  102fec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ff2:	01 c8                	add    %ecx,%eax
  102ff4:	11 da                	adc    %ebx,%edx
  102ff6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102ff9:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102ffc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103002:	89 d0                	mov    %edx,%eax
  103004:	c1 e0 02             	shl    $0x2,%eax
  103007:	01 d0                	add    %edx,%eax
  103009:	c1 e0 02             	shl    $0x2,%eax
  10300c:	01 c8                	add    %ecx,%eax
  10300e:	83 c0 14             	add    $0x14,%eax
  103011:	8b 00                	mov    (%eax),%eax
  103013:	83 f8 01             	cmp    $0x1,%eax
  103016:	0f 85 e2 00 00 00    	jne    1030fe <page_init+0x3ae>
            if (begin < freemem) {
  10301c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10301f:	ba 00 00 00 00       	mov    $0x0,%edx
  103024:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103027:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10302a:	19 d1                	sbb    %edx,%ecx
  10302c:	73 0d                	jae    10303b <page_init+0x2eb>
                begin = freemem;
  10302e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103031:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103034:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10303b:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103040:	b8 00 00 00 00       	mov    $0x0,%eax
  103045:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  103048:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10304b:	73 0e                	jae    10305b <page_init+0x30b>
                end = KMEMSIZE;
  10304d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103054:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10305b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10305e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103061:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103064:	89 d0                	mov    %edx,%eax
  103066:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103069:	0f 83 8f 00 00 00    	jae    1030fe <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
  10306f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  103076:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103079:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10307c:	01 d0                	add    %edx,%eax
  10307e:	48                   	dec    %eax
  10307f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  103082:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103085:	ba 00 00 00 00       	mov    $0x0,%edx
  10308a:	f7 75 b0             	divl   -0x50(%ebp)
  10308d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103090:	29 d0                	sub    %edx,%eax
  103092:	ba 00 00 00 00       	mov    $0x0,%edx
  103097:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10309a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10309d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030a0:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1030a3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1030a6:	ba 00 00 00 00       	mov    $0x0,%edx
  1030ab:	89 c3                	mov    %eax,%ebx
  1030ad:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  1030b3:	89 de                	mov    %ebx,%esi
  1030b5:	89 d0                	mov    %edx,%eax
  1030b7:	83 e0 00             	and    $0x0,%eax
  1030ba:	89 c7                	mov    %eax,%edi
  1030bc:	89 75 c8             	mov    %esi,-0x38(%ebp)
  1030bf:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  1030c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030c8:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1030cb:	89 d0                	mov    %edx,%eax
  1030cd:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1030d0:	73 2c                	jae    1030fe <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1030d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030d5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1030d8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1030db:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1030de:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1030e2:	c1 ea 0c             	shr    $0xc,%edx
  1030e5:	89 c3                	mov    %eax,%ebx
  1030e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030ea:	89 04 24             	mov    %eax,(%esp)
  1030ed:	e8 ad f8 ff ff       	call   10299f <pa2page>
  1030f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1030f6:	89 04 24             	mov    %eax,(%esp)
  1030f9:	e8 8c fb ff ff       	call   102c8a <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  1030fe:	ff 45 dc             	incl   -0x24(%ebp)
  103101:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103104:	8b 00                	mov    (%eax),%eax
  103106:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103109:	0f 8c a7 fe ff ff    	jl     102fb6 <page_init+0x266>
                }
            }
        }
    }
}
  10310f:	90                   	nop
  103110:	90                   	nop
  103111:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103117:	5b                   	pop    %ebx
  103118:	5e                   	pop    %esi
  103119:	5f                   	pop    %edi
  10311a:	5d                   	pop    %ebp
  10311b:	c3                   	ret    

0010311c <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10311c:	f3 0f 1e fb          	endbr32 
  103120:	55                   	push   %ebp
  103121:	89 e5                	mov    %esp,%ebp
  103123:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103126:	8b 45 0c             	mov    0xc(%ebp),%eax
  103129:	33 45 14             	xor    0x14(%ebp),%eax
  10312c:	25 ff 0f 00 00       	and    $0xfff,%eax
  103131:	85 c0                	test   %eax,%eax
  103133:	74 24                	je     103159 <boot_map_segment+0x3d>
  103135:	c7 44 24 0c 56 69 10 	movl   $0x106956,0xc(%esp)
  10313c:	00 
  10313d:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103144:	00 
  103145:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  10314c:	00 
  10314d:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103154:	e8 cd d2 ff ff       	call   100426 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103159:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103160:	8b 45 0c             	mov    0xc(%ebp),%eax
  103163:	25 ff 0f 00 00       	and    $0xfff,%eax
  103168:	89 c2                	mov    %eax,%edx
  10316a:	8b 45 10             	mov    0x10(%ebp),%eax
  10316d:	01 c2                	add    %eax,%edx
  10316f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103172:	01 d0                	add    %edx,%eax
  103174:	48                   	dec    %eax
  103175:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10317b:	ba 00 00 00 00       	mov    $0x0,%edx
  103180:	f7 75 f0             	divl   -0x10(%ebp)
  103183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103186:	29 d0                	sub    %edx,%eax
  103188:	c1 e8 0c             	shr    $0xc,%eax
  10318b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10318e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103191:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10319c:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10319f:	8b 45 14             	mov    0x14(%ebp),%eax
  1031a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1031a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1031ad:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1031b0:	eb 68                	jmp    10321a <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1031b2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1031b9:	00 
  1031ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c4:	89 04 24             	mov    %eax,(%esp)
  1031c7:	e8 8a 01 00 00       	call   103356 <get_pte>
  1031cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1031cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1031d3:	75 24                	jne    1031f9 <boot_map_segment+0xdd>
  1031d5:	c7 44 24 0c 82 69 10 	movl   $0x106982,0xc(%esp)
  1031dc:	00 
  1031dd:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  1031e4:	00 
  1031e5:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1031ec:	00 
  1031ed:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  1031f4:	e8 2d d2 ff ff       	call   100426 <__panic>
        *ptep = pa | PTE_P | perm;
  1031f9:	8b 45 14             	mov    0x14(%ebp),%eax
  1031fc:	0b 45 18             	or     0x18(%ebp),%eax
  1031ff:	83 c8 01             	or     $0x1,%eax
  103202:	89 c2                	mov    %eax,%edx
  103204:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103207:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103209:	ff 4d f4             	decl   -0xc(%ebp)
  10320c:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103213:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10321a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10321e:	75 92                	jne    1031b2 <boot_map_segment+0x96>
    }
}
  103220:	90                   	nop
  103221:	90                   	nop
  103222:	c9                   	leave  
  103223:	c3                   	ret    

00103224 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103224:	f3 0f 1e fb          	endbr32 
  103228:	55                   	push   %ebp
  103229:	89 e5                	mov    %esp,%ebp
  10322b:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10322e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103235:	e8 74 fa ff ff       	call   102cae <alloc_pages>
  10323a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10323d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103241:	75 1c                	jne    10325f <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
  103243:	c7 44 24 08 8f 69 10 	movl   $0x10698f,0x8(%esp)
  10324a:	00 
  10324b:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103252:	00 
  103253:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  10325a:	e8 c7 d1 ff ff       	call   100426 <__panic>
    }
    return page2kva(p);
  10325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103262:	89 04 24             	mov    %eax,(%esp)
  103265:	e8 84 f7 ff ff       	call   1029ee <page2kva>
}
  10326a:	c9                   	leave  
  10326b:	c3                   	ret    

0010326c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10326c:	f3 0f 1e fb          	endbr32 
  103270:	55                   	push   %ebp
  103271:	89 e5                	mov    %esp,%ebp
  103273:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  103276:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10327b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10327e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103285:	77 23                	ja     1032aa <pmm_init+0x3e>
  103287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10328a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10328e:	c7 44 24 08 24 69 10 	movl   $0x106924,0x8(%esp)
  103295:	00 
  103296:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10329d:	00 
  10329e:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  1032a5:	e8 7c d1 ff ff       	call   100426 <__panic>
  1032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032ad:	05 00 00 00 40       	add    $0x40000000,%eax
  1032b2:	a3 14 cf 11 00       	mov    %eax,0x11cf14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1032b7:	e8 96 f9 ff ff       	call   102c52 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1032bc:	e8 8f fa ff ff       	call   102d50 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1032c1:	e8 f3 03 00 00       	call   1036b9 <check_alloc_page>

    check_pgdir();
  1032c6:	e8 11 04 00 00       	call   1036dc <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1032cb:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032d3:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1032da:	77 23                	ja     1032ff <pmm_init+0x93>
  1032dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032e3:	c7 44 24 08 24 69 10 	movl   $0x106924,0x8(%esp)
  1032ea:	00 
  1032eb:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1032f2:	00 
  1032f3:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  1032fa:	e8 27 d1 ff ff       	call   100426 <__panic>
  1032ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103302:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  103308:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10330d:	05 ac 0f 00 00       	add    $0xfac,%eax
  103312:	83 ca 03             	or     $0x3,%edx
  103315:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103317:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10331c:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  103323:	00 
  103324:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10332b:	00 
  10332c:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103333:	38 
  103334:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10333b:	c0 
  10333c:	89 04 24             	mov    %eax,(%esp)
  10333f:	e8 d8 fd ff ff       	call   10311c <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103344:	e8 1b f8 ff ff       	call   102b64 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103349:	e8 2e 0a 00 00       	call   103d7c <check_boot_pgdir>

    print_pgdir();
  10334e:	e8 b3 0e 00 00       	call   104206 <print_pgdir>

}
  103353:	90                   	nop
  103354:	c9                   	leave  
  103355:	c3                   	ret    

00103356 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  103356:	f3 0f 1e fb          	endbr32 
  10335a:	55                   	push   %ebp
  10335b:	89 e5                	mov    %esp,%ebp
  10335d:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)]; //首先使用PDX函数获取一级页表的位置
  103360:	8b 45 0c             	mov    0xc(%ebp),%eax
  103363:	c1 e8 16             	shr    $0x16,%eax
  103366:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10336d:	8b 45 08             	mov    0x8(%ebp),%eax
  103370:	01 d0                	add    %edx,%eax
  103372:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {//如果获取不成功就尝试是否创建一个二级页表
  103375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103378:	8b 00                	mov    (%eax),%eax
  10337a:	83 e0 01             	and    $0x1,%eax
  10337d:	85 c0                	test   %eax,%eax
  10337f:	0f 85 af 00 00 00    	jne    103434 <get_pte+0xde>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {//创建二级页表通过create标记位来设置如果为0就不创建
  103385:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103389:	74 15                	je     1033a0 <get_pte+0x4a>
  10338b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103392:	e8 17 f9 ff ff       	call   102cae <alloc_pages>
  103397:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10339a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10339e:	75 0a                	jne    1033aa <get_pte+0x54>
            return NULL;
  1033a0:	b8 00 00 00 00       	mov    $0x0,%eax
  1033a5:	e9 e7 00 00 00       	jmp    103491 <get_pte+0x13b>
        }
        set_page_ref(page, 1); //如果能够创建二级页表首先需要将页表引用次数加一
  1033aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033b1:	00 
  1033b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033b5:	89 04 24             	mov    %eax,(%esp)
  1033b8:	e8 e5 f6 ff ff       	call   102aa2 <set_page_ref>
        uintptr_t pa = page2pa(page);//得到page管理的该页物理地址
  1033bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033c0:	89 04 24             	mov    %eax,(%esp)
  1033c3:	e8 c1 f5 ff ff       	call   102989 <page2pa>
  1033c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);//KADDR返回pa对应虚拟地址（线性地址），然后因为没有映射到物理地址所以全部设置为0
  1033cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d4:	c1 e8 0c             	shr    $0xc,%eax
  1033d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033da:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1033df:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1033e2:	72 23                	jb     103407 <get_pte+0xb1>
  1033e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1033eb:	c7 44 24 08 80 68 10 	movl   $0x106880,0x8(%esp)
  1033f2:	00 
  1033f3:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
  1033fa:	00 
  1033fb:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103402:	e8 1f d0 ff ff       	call   100426 <__panic>
  103407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10340a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10340f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103416:	00 
  103417:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10341e:	00 
  10341f:	89 04 24             	mov    %eax,(%esp)
  103422:	e8 d3 24 00 00       	call   1058fa <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;//设置控制位
  103427:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10342a:	83 c8 07             	or     $0x7,%eax
  10342d:	89 c2                	mov    %eax,%edx
  10342f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103432:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];//最后返回对应地址
  103434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103437:	8b 00                	mov    (%eax),%eax
  103439:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10343e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103441:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103444:	c1 e8 0c             	shr    $0xc,%eax
  103447:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10344a:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  10344f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103452:	72 23                	jb     103477 <get_pte+0x121>
  103454:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103457:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10345b:	c7 44 24 08 80 68 10 	movl   $0x106880,0x8(%esp)
  103462:	00 
  103463:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  10346a:	00 
  10346b:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103472:	e8 af cf ff ff       	call   100426 <__panic>
  103477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10347a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10347f:	89 c2                	mov    %eax,%edx
  103481:	8b 45 0c             	mov    0xc(%ebp),%eax
  103484:	c1 e8 0c             	shr    $0xc,%eax
  103487:	25 ff 03 00 00       	and    $0x3ff,%eax
  10348c:	c1 e0 02             	shl    $0x2,%eax
  10348f:	01 d0                	add    %edx,%eax
}
  103491:	c9                   	leave  
  103492:	c3                   	ret    

00103493 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  103493:	f3 0f 1e fb          	endbr32 
  103497:	55                   	push   %ebp
  103498:	89 e5                	mov    %esp,%ebp
  10349a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10349d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1034a4:	00 
  1034a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1034af:	89 04 24             	mov    %eax,(%esp)
  1034b2:	e8 9f fe ff ff       	call   103356 <get_pte>
  1034b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1034ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1034be:	74 08                	je     1034c8 <get_page+0x35>
        *ptep_store = ptep;
  1034c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1034c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034c6:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1034c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034cc:	74 1b                	je     1034e9 <get_page+0x56>
  1034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034d1:	8b 00                	mov    (%eax),%eax
  1034d3:	83 e0 01             	and    $0x1,%eax
  1034d6:	85 c0                	test   %eax,%eax
  1034d8:	74 0f                	je     1034e9 <get_page+0x56>
        return pte2page(*ptep);
  1034da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034dd:	8b 00                	mov    (%eax),%eax
  1034df:	89 04 24             	mov    %eax,(%esp)
  1034e2:	e8 5b f5 ff ff       	call   102a42 <pte2page>
  1034e7:	eb 05                	jmp    1034ee <get_page+0x5b>
    }
    return NULL;
  1034e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034ee:	c9                   	leave  
  1034ef:	c3                   	ret    

001034f0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1034f0:	55                   	push   %ebp
  1034f1:	89 e5                	mov    %esp,%ebp
  1034f3:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
if (*ptep & PTE_P) {
  1034f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1034f9:	8b 00                	mov    (%eax),%eax
  1034fb:	83 e0 01             	and    $0x1,%eax
  1034fe:	85 c0                	test   %eax,%eax
  103500:	74 4d                	je     10354f <page_remove_pte+0x5f>
    struct Page *page = pte2page(*ptep);//获取该页表项对应的物理页的page结构
  103502:	8b 45 10             	mov    0x10(%ebp),%eax
  103505:	8b 00                	mov    (%eax),%eax
  103507:	89 04 24             	mov    %eax,(%esp)
  10350a:	e8 33 f5 ff ff       	call   102a42 <pte2page>
  10350f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page_ref_dec(page) == 0) {
  103512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103515:	89 04 24             	mov    %eax,(%esp)
  103518:	e8 aa f5 ff ff       	call   102ac7 <page_ref_dec>
  10351d:	85 c0                	test   %eax,%eax
  10351f:	75 13                	jne    103534 <page_remove_pte+0x44>
        free_page(page);     //free a page
  103521:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103528:	00 
  103529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10352c:	89 04 24             	mov    %eax,(%esp)
  10352f:	e8 b6 f7 ff ff       	call   102cea <free_pages>
    }
    *ptep = 0;//将二级页表置0表示取消映射
  103534:	8b 45 10             	mov    0x10(%ebp),%eax
  103537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    tlb_invalidate(pgdir, la);//刷新tlb，保证tlb中的缓存不会有错误映射关系
  10353d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103540:	89 44 24 04          	mov    %eax,0x4(%esp)
  103544:	8b 45 08             	mov    0x8(%ebp),%eax
  103547:	89 04 24             	mov    %eax,(%esp)
  10354a:	e8 09 01 00 00       	call   103658 <tlb_invalidate>
}
}
  10354f:	90                   	nop
  103550:	c9                   	leave  
  103551:	c3                   	ret    

00103552 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103552:	f3 0f 1e fb          	endbr32 
  103556:	55                   	push   %ebp
  103557:	89 e5                	mov    %esp,%ebp
  103559:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10355c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103563:	00 
  103564:	8b 45 0c             	mov    0xc(%ebp),%eax
  103567:	89 44 24 04          	mov    %eax,0x4(%esp)
  10356b:	8b 45 08             	mov    0x8(%ebp),%eax
  10356e:	89 04 24             	mov    %eax,(%esp)
  103571:	e8 e0 fd ff ff       	call   103356 <get_pte>
  103576:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10357d:	74 19                	je     103598 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
  10357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103582:	89 44 24 08          	mov    %eax,0x8(%esp)
  103586:	8b 45 0c             	mov    0xc(%ebp),%eax
  103589:	89 44 24 04          	mov    %eax,0x4(%esp)
  10358d:	8b 45 08             	mov    0x8(%ebp),%eax
  103590:	89 04 24             	mov    %eax,(%esp)
  103593:	e8 58 ff ff ff       	call   1034f0 <page_remove_pte>
    }
}
  103598:	90                   	nop
  103599:	c9                   	leave  
  10359a:	c3                   	ret    

0010359b <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10359b:	f3 0f 1e fb          	endbr32 
  10359f:	55                   	push   %ebp
  1035a0:	89 e5                	mov    %esp,%ebp
  1035a2:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1035a5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1035ac:	00 
  1035ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1035b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1035b7:	89 04 24             	mov    %eax,(%esp)
  1035ba:	e8 97 fd ff ff       	call   103356 <get_pte>
  1035bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1035c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1035c6:	75 0a                	jne    1035d2 <page_insert+0x37>
        return -E_NO_MEM;
  1035c8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1035cd:	e9 84 00 00 00       	jmp    103656 <page_insert+0xbb>
    }
    page_ref_inc(page);
  1035d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035d5:	89 04 24             	mov    %eax,(%esp)
  1035d8:	e8 d3 f4 ff ff       	call   102ab0 <page_ref_inc>
    if (*ptep & PTE_P) {
  1035dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035e0:	8b 00                	mov    (%eax),%eax
  1035e2:	83 e0 01             	and    $0x1,%eax
  1035e5:	85 c0                	test   %eax,%eax
  1035e7:	74 3e                	je     103627 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
  1035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035ec:	8b 00                	mov    (%eax),%eax
  1035ee:	89 04 24             	mov    %eax,(%esp)
  1035f1:	e8 4c f4 ff ff       	call   102a42 <pte2page>
  1035f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1035f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1035ff:	75 0d                	jne    10360e <page_insert+0x73>
            page_ref_dec(page);
  103601:	8b 45 0c             	mov    0xc(%ebp),%eax
  103604:	89 04 24             	mov    %eax,(%esp)
  103607:	e8 bb f4 ff ff       	call   102ac7 <page_ref_dec>
  10360c:	eb 19                	jmp    103627 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103611:	89 44 24 08          	mov    %eax,0x8(%esp)
  103615:	8b 45 10             	mov    0x10(%ebp),%eax
  103618:	89 44 24 04          	mov    %eax,0x4(%esp)
  10361c:	8b 45 08             	mov    0x8(%ebp),%eax
  10361f:	89 04 24             	mov    %eax,(%esp)
  103622:	e8 c9 fe ff ff       	call   1034f0 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103627:	8b 45 0c             	mov    0xc(%ebp),%eax
  10362a:	89 04 24             	mov    %eax,(%esp)
  10362d:	e8 57 f3 ff ff       	call   102989 <page2pa>
  103632:	0b 45 14             	or     0x14(%ebp),%eax
  103635:	83 c8 01             	or     $0x1,%eax
  103638:	89 c2                	mov    %eax,%edx
  10363a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10363d:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10363f:	8b 45 10             	mov    0x10(%ebp),%eax
  103642:	89 44 24 04          	mov    %eax,0x4(%esp)
  103646:	8b 45 08             	mov    0x8(%ebp),%eax
  103649:	89 04 24             	mov    %eax,(%esp)
  10364c:	e8 07 00 00 00       	call   103658 <tlb_invalidate>
    return 0;
  103651:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103656:	c9                   	leave  
  103657:	c3                   	ret    

00103658 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103658:	f3 0f 1e fb          	endbr32 
  10365c:	55                   	push   %ebp
  10365d:	89 e5                	mov    %esp,%ebp
  10365f:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103662:	0f 20 d8             	mov    %cr3,%eax
  103665:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103668:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  10366b:	8b 45 08             	mov    0x8(%ebp),%eax
  10366e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103671:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103678:	77 23                	ja     10369d <tlb_invalidate+0x45>
  10367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10367d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103681:	c7 44 24 08 24 69 10 	movl   $0x106924,0x8(%esp)
  103688:	00 
  103689:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
  103690:	00 
  103691:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103698:	e8 89 cd ff ff       	call   100426 <__panic>
  10369d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036a0:	05 00 00 00 40       	add    $0x40000000,%eax
  1036a5:	39 d0                	cmp    %edx,%eax
  1036a7:	75 0d                	jne    1036b6 <tlb_invalidate+0x5e>
        invlpg((void *)la);
  1036a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1036af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036b2:	0f 01 38             	invlpg (%eax)
}
  1036b5:	90                   	nop
    }
}
  1036b6:	90                   	nop
  1036b7:	c9                   	leave  
  1036b8:	c3                   	ret    

001036b9 <check_alloc_page>:

static void
check_alloc_page(void) {
  1036b9:	f3 0f 1e fb          	endbr32 
  1036bd:	55                   	push   %ebp
  1036be:	89 e5                	mov    %esp,%ebp
  1036c0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1036c3:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  1036c8:	8b 40 18             	mov    0x18(%eax),%eax
  1036cb:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1036cd:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  1036d4:	e8 e1 cb ff ff       	call   1002ba <cprintf>
}
  1036d9:	90                   	nop
  1036da:	c9                   	leave  
  1036db:	c3                   	ret    

001036dc <check_pgdir>:

static void
check_pgdir(void) {
  1036dc:	f3 0f 1e fb          	endbr32 
  1036e0:	55                   	push   %ebp
  1036e1:	89 e5                	mov    %esp,%ebp
  1036e3:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1036e6:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1036eb:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1036f0:	76 24                	jbe    103716 <check_pgdir+0x3a>
  1036f2:	c7 44 24 0c c7 69 10 	movl   $0x1069c7,0xc(%esp)
  1036f9:	00 
  1036fa:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103701:	00 
  103702:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  103709:	00 
  10370a:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103711:	e8 10 cd ff ff       	call   100426 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103716:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10371b:	85 c0                	test   %eax,%eax
  10371d:	74 0e                	je     10372d <check_pgdir+0x51>
  10371f:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103724:	25 ff 0f 00 00       	and    $0xfff,%eax
  103729:	85 c0                	test   %eax,%eax
  10372b:	74 24                	je     103751 <check_pgdir+0x75>
  10372d:	c7 44 24 0c e4 69 10 	movl   $0x1069e4,0xc(%esp)
  103734:	00 
  103735:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  10373c:	00 
  10373d:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  103744:	00 
  103745:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  10374c:	e8 d5 cc ff ff       	call   100426 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103751:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103756:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10375d:	00 
  10375e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103765:	00 
  103766:	89 04 24             	mov    %eax,(%esp)
  103769:	e8 25 fd ff ff       	call   103493 <get_page>
  10376e:	85 c0                	test   %eax,%eax
  103770:	74 24                	je     103796 <check_pgdir+0xba>
  103772:	c7 44 24 0c 1c 6a 10 	movl   $0x106a1c,0xc(%esp)
  103779:	00 
  10377a:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103781:	00 
  103782:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  103789:	00 
  10378a:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103791:	e8 90 cc ff ff       	call   100426 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103796:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10379d:	e8 0c f5 ff ff       	call   102cae <alloc_pages>
  1037a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1037a5:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1037aa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1037b1:	00 
  1037b2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037b9:	00 
  1037ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1037bd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1037c1:	89 04 24             	mov    %eax,(%esp)
  1037c4:	e8 d2 fd ff ff       	call   10359b <page_insert>
  1037c9:	85 c0                	test   %eax,%eax
  1037cb:	74 24                	je     1037f1 <check_pgdir+0x115>
  1037cd:	c7 44 24 0c 44 6a 10 	movl   $0x106a44,0xc(%esp)
  1037d4:	00 
  1037d5:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  1037dc:	00 
  1037dd:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  1037e4:	00 
  1037e5:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  1037ec:	e8 35 cc ff ff       	call   100426 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1037f1:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1037f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037fd:	00 
  1037fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103805:	00 
  103806:	89 04 24             	mov    %eax,(%esp)
  103809:	e8 48 fb ff ff       	call   103356 <get_pte>
  10380e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103815:	75 24                	jne    10383b <check_pgdir+0x15f>
  103817:	c7 44 24 0c 70 6a 10 	movl   $0x106a70,0xc(%esp)
  10381e:	00 
  10381f:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103826:	00 
  103827:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  10382e:	00 
  10382f:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103836:	e8 eb cb ff ff       	call   100426 <__panic>
    assert(pte2page(*ptep) == p1);
  10383b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10383e:	8b 00                	mov    (%eax),%eax
  103840:	89 04 24             	mov    %eax,(%esp)
  103843:	e8 fa f1 ff ff       	call   102a42 <pte2page>
  103848:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10384b:	74 24                	je     103871 <check_pgdir+0x195>
  10384d:	c7 44 24 0c 9d 6a 10 	movl   $0x106a9d,0xc(%esp)
  103854:	00 
  103855:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  10385c:	00 
  10385d:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  103864:	00 
  103865:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  10386c:	e8 b5 cb ff ff       	call   100426 <__panic>
    assert(page_ref(p1) == 1);
  103871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103874:	89 04 24             	mov    %eax,(%esp)
  103877:	e8 1c f2 ff ff       	call   102a98 <page_ref>
  10387c:	83 f8 01             	cmp    $0x1,%eax
  10387f:	74 24                	je     1038a5 <check_pgdir+0x1c9>
  103881:	c7 44 24 0c b3 6a 10 	movl   $0x106ab3,0xc(%esp)
  103888:	00 
  103889:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103890:	00 
  103891:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  103898:	00 
  103899:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  1038a0:	e8 81 cb ff ff       	call   100426 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1038a5:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1038aa:	8b 00                	mov    (%eax),%eax
  1038ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1038b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1038b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038b7:	c1 e8 0c             	shr    $0xc,%eax
  1038ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1038bd:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1038c2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1038c5:	72 23                	jb     1038ea <check_pgdir+0x20e>
  1038c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1038ce:	c7 44 24 08 80 68 10 	movl   $0x106880,0x8(%esp)
  1038d5:	00 
  1038d6:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  1038dd:	00 
  1038de:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  1038e5:	e8 3c cb ff ff       	call   100426 <__panic>
  1038ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038ed:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1038f2:	83 c0 04             	add    $0x4,%eax
  1038f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1038f8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1038fd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103904:	00 
  103905:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10390c:	00 
  10390d:	89 04 24             	mov    %eax,(%esp)
  103910:	e8 41 fa ff ff       	call   103356 <get_pte>
  103915:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103918:	74 24                	je     10393e <check_pgdir+0x262>
  10391a:	c7 44 24 0c c8 6a 10 	movl   $0x106ac8,0xc(%esp)
  103921:	00 
  103922:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103929:	00 
  10392a:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  103931:	00 
  103932:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103939:	e8 e8 ca ff ff       	call   100426 <__panic>

    p2 = alloc_page();
  10393e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103945:	e8 64 f3 ff ff       	call   102cae <alloc_pages>
  10394a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10394d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103952:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103959:	00 
  10395a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103961:	00 
  103962:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103965:	89 54 24 04          	mov    %edx,0x4(%esp)
  103969:	89 04 24             	mov    %eax,(%esp)
  10396c:	e8 2a fc ff ff       	call   10359b <page_insert>
  103971:	85 c0                	test   %eax,%eax
  103973:	74 24                	je     103999 <check_pgdir+0x2bd>
  103975:	c7 44 24 0c f0 6a 10 	movl   $0x106af0,0xc(%esp)
  10397c:	00 
  10397d:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103984:	00 
  103985:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  10398c:	00 
  10398d:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103994:	e8 8d ca ff ff       	call   100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103999:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10399e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039a5:	00 
  1039a6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1039ad:	00 
  1039ae:	89 04 24             	mov    %eax,(%esp)
  1039b1:	e8 a0 f9 ff ff       	call   103356 <get_pte>
  1039b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039bd:	75 24                	jne    1039e3 <check_pgdir+0x307>
  1039bf:	c7 44 24 0c 28 6b 10 	movl   $0x106b28,0xc(%esp)
  1039c6:	00 
  1039c7:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  1039ce:	00 
  1039cf:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  1039d6:	00 
  1039d7:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  1039de:	e8 43 ca ff ff       	call   100426 <__panic>
    assert(*ptep & PTE_U);
  1039e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039e6:	8b 00                	mov    (%eax),%eax
  1039e8:	83 e0 04             	and    $0x4,%eax
  1039eb:	85 c0                	test   %eax,%eax
  1039ed:	75 24                	jne    103a13 <check_pgdir+0x337>
  1039ef:	c7 44 24 0c 58 6b 10 	movl   $0x106b58,0xc(%esp)
  1039f6:	00 
  1039f7:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  1039fe:	00 
  1039ff:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103a06:	00 
  103a07:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103a0e:	e8 13 ca ff ff       	call   100426 <__panic>
    assert(*ptep & PTE_W);
  103a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a16:	8b 00                	mov    (%eax),%eax
  103a18:	83 e0 02             	and    $0x2,%eax
  103a1b:	85 c0                	test   %eax,%eax
  103a1d:	75 24                	jne    103a43 <check_pgdir+0x367>
  103a1f:	c7 44 24 0c 66 6b 10 	movl   $0x106b66,0xc(%esp)
  103a26:	00 
  103a27:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103a2e:	00 
  103a2f:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  103a36:	00 
  103a37:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103a3e:	e8 e3 c9 ff ff       	call   100426 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103a43:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103a48:	8b 00                	mov    (%eax),%eax
  103a4a:	83 e0 04             	and    $0x4,%eax
  103a4d:	85 c0                	test   %eax,%eax
  103a4f:	75 24                	jne    103a75 <check_pgdir+0x399>
  103a51:	c7 44 24 0c 74 6b 10 	movl   $0x106b74,0xc(%esp)
  103a58:	00 
  103a59:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103a60:	00 
  103a61:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103a68:	00 
  103a69:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103a70:	e8 b1 c9 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 1);
  103a75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a78:	89 04 24             	mov    %eax,(%esp)
  103a7b:	e8 18 f0 ff ff       	call   102a98 <page_ref>
  103a80:	83 f8 01             	cmp    $0x1,%eax
  103a83:	74 24                	je     103aa9 <check_pgdir+0x3cd>
  103a85:	c7 44 24 0c 8a 6b 10 	movl   $0x106b8a,0xc(%esp)
  103a8c:	00 
  103a8d:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103a94:	00 
  103a95:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  103a9c:	00 
  103a9d:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103aa4:	e8 7d c9 ff ff       	call   100426 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103aa9:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103aae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103ab5:	00 
  103ab6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103abd:	00 
  103abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103ac1:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ac5:	89 04 24             	mov    %eax,(%esp)
  103ac8:	e8 ce fa ff ff       	call   10359b <page_insert>
  103acd:	85 c0                	test   %eax,%eax
  103acf:	74 24                	je     103af5 <check_pgdir+0x419>
  103ad1:	c7 44 24 0c 9c 6b 10 	movl   $0x106b9c,0xc(%esp)
  103ad8:	00 
  103ad9:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103ae0:	00 
  103ae1:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  103ae8:	00 
  103ae9:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103af0:	e8 31 c9 ff ff       	call   100426 <__panic>
    assert(page_ref(p1) == 2);
  103af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103af8:	89 04 24             	mov    %eax,(%esp)
  103afb:	e8 98 ef ff ff       	call   102a98 <page_ref>
  103b00:	83 f8 02             	cmp    $0x2,%eax
  103b03:	74 24                	je     103b29 <check_pgdir+0x44d>
  103b05:	c7 44 24 0c c8 6b 10 	movl   $0x106bc8,0xc(%esp)
  103b0c:	00 
  103b0d:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103b14:	00 
  103b15:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103b1c:	00 
  103b1d:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103b24:	e8 fd c8 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b2c:	89 04 24             	mov    %eax,(%esp)
  103b2f:	e8 64 ef ff ff       	call   102a98 <page_ref>
  103b34:	85 c0                	test   %eax,%eax
  103b36:	74 24                	je     103b5c <check_pgdir+0x480>
  103b38:	c7 44 24 0c da 6b 10 	movl   $0x106bda,0xc(%esp)
  103b3f:	00 
  103b40:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103b47:	00 
  103b48:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103b4f:	00 
  103b50:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103b57:	e8 ca c8 ff ff       	call   100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103b5c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103b61:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b68:	00 
  103b69:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b70:	00 
  103b71:	89 04 24             	mov    %eax,(%esp)
  103b74:	e8 dd f7 ff ff       	call   103356 <get_pte>
  103b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103b80:	75 24                	jne    103ba6 <check_pgdir+0x4ca>
  103b82:	c7 44 24 0c 28 6b 10 	movl   $0x106b28,0xc(%esp)
  103b89:	00 
  103b8a:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103b91:	00 
  103b92:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  103b99:	00 
  103b9a:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103ba1:	e8 80 c8 ff ff       	call   100426 <__panic>
    assert(pte2page(*ptep) == p1);
  103ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ba9:	8b 00                	mov    (%eax),%eax
  103bab:	89 04 24             	mov    %eax,(%esp)
  103bae:	e8 8f ee ff ff       	call   102a42 <pte2page>
  103bb3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103bb6:	74 24                	je     103bdc <check_pgdir+0x500>
  103bb8:	c7 44 24 0c 9d 6a 10 	movl   $0x106a9d,0xc(%esp)
  103bbf:	00 
  103bc0:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103bc7:	00 
  103bc8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  103bcf:	00 
  103bd0:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103bd7:	e8 4a c8 ff ff       	call   100426 <__panic>
    assert((*ptep & PTE_U) == 0);
  103bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bdf:	8b 00                	mov    (%eax),%eax
  103be1:	83 e0 04             	and    $0x4,%eax
  103be4:	85 c0                	test   %eax,%eax
  103be6:	74 24                	je     103c0c <check_pgdir+0x530>
  103be8:	c7 44 24 0c ec 6b 10 	movl   $0x106bec,0xc(%esp)
  103bef:	00 
  103bf0:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103bf7:	00 
  103bf8:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  103bff:	00 
  103c00:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103c07:	e8 1a c8 ff ff       	call   100426 <__panic>

    page_remove(boot_pgdir, 0x0);
  103c0c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103c11:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103c18:	00 
  103c19:	89 04 24             	mov    %eax,(%esp)
  103c1c:	e8 31 f9 ff ff       	call   103552 <page_remove>
    assert(page_ref(p1) == 1);
  103c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c24:	89 04 24             	mov    %eax,(%esp)
  103c27:	e8 6c ee ff ff       	call   102a98 <page_ref>
  103c2c:	83 f8 01             	cmp    $0x1,%eax
  103c2f:	74 24                	je     103c55 <check_pgdir+0x579>
  103c31:	c7 44 24 0c b3 6a 10 	movl   $0x106ab3,0xc(%esp)
  103c38:	00 
  103c39:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103c40:	00 
  103c41:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103c48:	00 
  103c49:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103c50:	e8 d1 c7 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c58:	89 04 24             	mov    %eax,(%esp)
  103c5b:	e8 38 ee ff ff       	call   102a98 <page_ref>
  103c60:	85 c0                	test   %eax,%eax
  103c62:	74 24                	je     103c88 <check_pgdir+0x5ac>
  103c64:	c7 44 24 0c da 6b 10 	movl   $0x106bda,0xc(%esp)
  103c6b:	00 
  103c6c:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103c73:	00 
  103c74:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  103c7b:	00 
  103c7c:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103c83:	e8 9e c7 ff ff       	call   100426 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103c88:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103c8d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103c94:	00 
  103c95:	89 04 24             	mov    %eax,(%esp)
  103c98:	e8 b5 f8 ff ff       	call   103552 <page_remove>
    assert(page_ref(p1) == 0);
  103c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ca0:	89 04 24             	mov    %eax,(%esp)
  103ca3:	e8 f0 ed ff ff       	call   102a98 <page_ref>
  103ca8:	85 c0                	test   %eax,%eax
  103caa:	74 24                	je     103cd0 <check_pgdir+0x5f4>
  103cac:	c7 44 24 0c 01 6c 10 	movl   $0x106c01,0xc(%esp)
  103cb3:	00 
  103cb4:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103cbb:	00 
  103cbc:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  103cc3:	00 
  103cc4:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103ccb:	e8 56 c7 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103cd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cd3:	89 04 24             	mov    %eax,(%esp)
  103cd6:	e8 bd ed ff ff       	call   102a98 <page_ref>
  103cdb:	85 c0                	test   %eax,%eax
  103cdd:	74 24                	je     103d03 <check_pgdir+0x627>
  103cdf:	c7 44 24 0c da 6b 10 	movl   $0x106bda,0xc(%esp)
  103ce6:	00 
  103ce7:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103cee:	00 
  103cef:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103cf6:	00 
  103cf7:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103cfe:	e8 23 c7 ff ff       	call   100426 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103d03:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d08:	8b 00                	mov    (%eax),%eax
  103d0a:	89 04 24             	mov    %eax,(%esp)
  103d0d:	e8 6e ed ff ff       	call   102a80 <pde2page>
  103d12:	89 04 24             	mov    %eax,(%esp)
  103d15:	e8 7e ed ff ff       	call   102a98 <page_ref>
  103d1a:	83 f8 01             	cmp    $0x1,%eax
  103d1d:	74 24                	je     103d43 <check_pgdir+0x667>
  103d1f:	c7 44 24 0c 14 6c 10 	movl   $0x106c14,0xc(%esp)
  103d26:	00 
  103d27:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103d2e:	00 
  103d2f:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  103d36:	00 
  103d37:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103d3e:	e8 e3 c6 ff ff       	call   100426 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103d43:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d48:	8b 00                	mov    (%eax),%eax
  103d4a:	89 04 24             	mov    %eax,(%esp)
  103d4d:	e8 2e ed ff ff       	call   102a80 <pde2page>
  103d52:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103d59:	00 
  103d5a:	89 04 24             	mov    %eax,(%esp)
  103d5d:	e8 88 ef ff ff       	call   102cea <free_pages>
    boot_pgdir[0] = 0;
  103d62:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103d6d:	c7 04 24 3b 6c 10 00 	movl   $0x106c3b,(%esp)
  103d74:	e8 41 c5 ff ff       	call   1002ba <cprintf>
}
  103d79:	90                   	nop
  103d7a:	c9                   	leave  
  103d7b:	c3                   	ret    

00103d7c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103d7c:	f3 0f 1e fb          	endbr32 
  103d80:	55                   	push   %ebp
  103d81:	89 e5                	mov    %esp,%ebp
  103d83:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103d86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103d8d:	e9 ca 00 00 00       	jmp    103e5c <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d9b:	c1 e8 0c             	shr    $0xc,%eax
  103d9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103da1:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103da6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103da9:	72 23                	jb     103dce <check_boot_pgdir+0x52>
  103dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103dae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103db2:	c7 44 24 08 80 68 10 	movl   $0x106880,0x8(%esp)
  103db9:	00 
  103dba:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103dc1:	00 
  103dc2:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103dc9:	e8 58 c6 ff ff       	call   100426 <__panic>
  103dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103dd1:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103dd6:	89 c2                	mov    %eax,%edx
  103dd8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103ddd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103de4:	00 
  103de5:	89 54 24 04          	mov    %edx,0x4(%esp)
  103de9:	89 04 24             	mov    %eax,(%esp)
  103dec:	e8 65 f5 ff ff       	call   103356 <get_pte>
  103df1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103df4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103df8:	75 24                	jne    103e1e <check_boot_pgdir+0xa2>
  103dfa:	c7 44 24 0c 58 6c 10 	movl   $0x106c58,0xc(%esp)
  103e01:	00 
  103e02:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103e09:	00 
  103e0a:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103e11:	00 
  103e12:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103e19:	e8 08 c6 ff ff       	call   100426 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103e1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103e21:	8b 00                	mov    (%eax),%eax
  103e23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e28:	89 c2                	mov    %eax,%edx
  103e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e2d:	39 c2                	cmp    %eax,%edx
  103e2f:	74 24                	je     103e55 <check_boot_pgdir+0xd9>
  103e31:	c7 44 24 0c 95 6c 10 	movl   $0x106c95,0xc(%esp)
  103e38:	00 
  103e39:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103e40:	00 
  103e41:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  103e48:	00 
  103e49:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103e50:	e8 d1 c5 ff ff       	call   100426 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103e55:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103e5f:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103e64:	39 c2                	cmp    %eax,%edx
  103e66:	0f 82 26 ff ff ff    	jb     103d92 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103e6c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e71:	05 ac 0f 00 00       	add    $0xfac,%eax
  103e76:	8b 00                	mov    (%eax),%eax
  103e78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e7d:	89 c2                	mov    %eax,%edx
  103e7f:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e87:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103e8e:	77 23                	ja     103eb3 <check_boot_pgdir+0x137>
  103e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e97:	c7 44 24 08 24 69 10 	movl   $0x106924,0x8(%esp)
  103e9e:	00 
  103e9f:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  103ea6:	00 
  103ea7:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103eae:	e8 73 c5 ff ff       	call   100426 <__panic>
  103eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103eb6:	05 00 00 00 40       	add    $0x40000000,%eax
  103ebb:	39 d0                	cmp    %edx,%eax
  103ebd:	74 24                	je     103ee3 <check_boot_pgdir+0x167>
  103ebf:	c7 44 24 0c ac 6c 10 	movl   $0x106cac,0xc(%esp)
  103ec6:	00 
  103ec7:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103ece:	00 
  103ecf:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  103ed6:	00 
  103ed7:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103ede:	e8 43 c5 ff ff       	call   100426 <__panic>

    assert(boot_pgdir[0] == 0);
  103ee3:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103ee8:	8b 00                	mov    (%eax),%eax
  103eea:	85 c0                	test   %eax,%eax
  103eec:	74 24                	je     103f12 <check_boot_pgdir+0x196>
  103eee:	c7 44 24 0c e0 6c 10 	movl   $0x106ce0,0xc(%esp)
  103ef5:	00 
  103ef6:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103efd:	00 
  103efe:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  103f05:	00 
  103f06:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103f0d:	e8 14 c5 ff ff       	call   100426 <__panic>

    struct Page *p;
    p = alloc_page();
  103f12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103f19:	e8 90 ed ff ff       	call   102cae <alloc_pages>
  103f1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103f21:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103f26:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103f2d:	00 
  103f2e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103f35:	00 
  103f36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103f39:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f3d:	89 04 24             	mov    %eax,(%esp)
  103f40:	e8 56 f6 ff ff       	call   10359b <page_insert>
  103f45:	85 c0                	test   %eax,%eax
  103f47:	74 24                	je     103f6d <check_boot_pgdir+0x1f1>
  103f49:	c7 44 24 0c f4 6c 10 	movl   $0x106cf4,0xc(%esp)
  103f50:	00 
  103f51:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103f58:	00 
  103f59:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  103f60:	00 
  103f61:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103f68:	e8 b9 c4 ff ff       	call   100426 <__panic>
    assert(page_ref(p) == 1);
  103f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f70:	89 04 24             	mov    %eax,(%esp)
  103f73:	e8 20 eb ff ff       	call   102a98 <page_ref>
  103f78:	83 f8 01             	cmp    $0x1,%eax
  103f7b:	74 24                	je     103fa1 <check_boot_pgdir+0x225>
  103f7d:	c7 44 24 0c 22 6d 10 	movl   $0x106d22,0xc(%esp)
  103f84:	00 
  103f85:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103f8c:	00 
  103f8d:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  103f94:	00 
  103f95:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103f9c:	e8 85 c4 ff ff       	call   100426 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103fa1:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103fa6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103fad:	00 
  103fae:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103fb5:	00 
  103fb6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103fb9:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fbd:	89 04 24             	mov    %eax,(%esp)
  103fc0:	e8 d6 f5 ff ff       	call   10359b <page_insert>
  103fc5:	85 c0                	test   %eax,%eax
  103fc7:	74 24                	je     103fed <check_boot_pgdir+0x271>
  103fc9:	c7 44 24 0c 34 6d 10 	movl   $0x106d34,0xc(%esp)
  103fd0:	00 
  103fd1:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  103fd8:	00 
  103fd9:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  103fe0:	00 
  103fe1:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  103fe8:	e8 39 c4 ff ff       	call   100426 <__panic>
    assert(page_ref(p) == 2);
  103fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ff0:	89 04 24             	mov    %eax,(%esp)
  103ff3:	e8 a0 ea ff ff       	call   102a98 <page_ref>
  103ff8:	83 f8 02             	cmp    $0x2,%eax
  103ffb:	74 24                	je     104021 <check_boot_pgdir+0x2a5>
  103ffd:	c7 44 24 0c 6b 6d 10 	movl   $0x106d6b,0xc(%esp)
  104004:	00 
  104005:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  10400c:	00 
  10400d:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104014:	00 
  104015:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  10401c:	e8 05 c4 ff ff       	call   100426 <__panic>

    const char *str = "ucore: Hello world!!";
  104021:	c7 45 e8 7c 6d 10 00 	movl   $0x106d7c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  104028:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10402b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10402f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104036:	e8 db 15 00 00       	call   105616 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10403b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104042:	00 
  104043:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10404a:	e8 45 16 00 00       	call   105694 <strcmp>
  10404f:	85 c0                	test   %eax,%eax
  104051:	74 24                	je     104077 <check_boot_pgdir+0x2fb>
  104053:	c7 44 24 0c 94 6d 10 	movl   $0x106d94,0xc(%esp)
  10405a:	00 
  10405b:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  104062:	00 
  104063:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  10406a:	00 
  10406b:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  104072:	e8 af c3 ff ff       	call   100426 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104077:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10407a:	89 04 24             	mov    %eax,(%esp)
  10407d:	e8 6c e9 ff ff       	call   1029ee <page2kva>
  104082:	05 00 01 00 00       	add    $0x100,%eax
  104087:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10408a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104091:	e8 22 15 00 00       	call   1055b8 <strlen>
  104096:	85 c0                	test   %eax,%eax
  104098:	74 24                	je     1040be <check_boot_pgdir+0x342>
  10409a:	c7 44 24 0c cc 6d 10 	movl   $0x106dcc,0xc(%esp)
  1040a1:	00 
  1040a2:	c7 44 24 08 6d 69 10 	movl   $0x10696d,0x8(%esp)
  1040a9:	00 
  1040aa:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  1040b1:	00 
  1040b2:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  1040b9:	e8 68 c3 ff ff       	call   100426 <__panic>

    free_page(p);
  1040be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1040c5:	00 
  1040c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1040c9:	89 04 24             	mov    %eax,(%esp)
  1040cc:	e8 19 ec ff ff       	call   102cea <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1040d1:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1040d6:	8b 00                	mov    (%eax),%eax
  1040d8:	89 04 24             	mov    %eax,(%esp)
  1040db:	e8 a0 e9 ff ff       	call   102a80 <pde2page>
  1040e0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1040e7:	00 
  1040e8:	89 04 24             	mov    %eax,(%esp)
  1040eb:	e8 fa eb ff ff       	call   102cea <free_pages>
    boot_pgdir[0] = 0;
  1040f0:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1040f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1040fb:	c7 04 24 f0 6d 10 00 	movl   $0x106df0,(%esp)
  104102:	e8 b3 c1 ff ff       	call   1002ba <cprintf>
}
  104107:	90                   	nop
  104108:	c9                   	leave  
  104109:	c3                   	ret    

0010410a <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10410a:	f3 0f 1e fb          	endbr32 
  10410e:	55                   	push   %ebp
  10410f:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104111:	8b 45 08             	mov    0x8(%ebp),%eax
  104114:	83 e0 04             	and    $0x4,%eax
  104117:	85 c0                	test   %eax,%eax
  104119:	74 04                	je     10411f <perm2str+0x15>
  10411b:	b0 75                	mov    $0x75,%al
  10411d:	eb 02                	jmp    104121 <perm2str+0x17>
  10411f:	b0 2d                	mov    $0x2d,%al
  104121:	a2 08 cf 11 00       	mov    %al,0x11cf08
    str[1] = 'r';
  104126:	c6 05 09 cf 11 00 72 	movb   $0x72,0x11cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10412d:	8b 45 08             	mov    0x8(%ebp),%eax
  104130:	83 e0 02             	and    $0x2,%eax
  104133:	85 c0                	test   %eax,%eax
  104135:	74 04                	je     10413b <perm2str+0x31>
  104137:	b0 77                	mov    $0x77,%al
  104139:	eb 02                	jmp    10413d <perm2str+0x33>
  10413b:	b0 2d                	mov    $0x2d,%al
  10413d:	a2 0a cf 11 00       	mov    %al,0x11cf0a
    str[3] = '\0';
  104142:	c6 05 0b cf 11 00 00 	movb   $0x0,0x11cf0b
    return str;
  104149:	b8 08 cf 11 00       	mov    $0x11cf08,%eax
}
  10414e:	5d                   	pop    %ebp
  10414f:	c3                   	ret    

00104150 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104150:	f3 0f 1e fb          	endbr32 
  104154:	55                   	push   %ebp
  104155:	89 e5                	mov    %esp,%ebp
  104157:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10415a:	8b 45 10             	mov    0x10(%ebp),%eax
  10415d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104160:	72 0d                	jb     10416f <get_pgtable_items+0x1f>
        return 0;
  104162:	b8 00 00 00 00       	mov    $0x0,%eax
  104167:	e9 98 00 00 00       	jmp    104204 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  10416c:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  10416f:	8b 45 10             	mov    0x10(%ebp),%eax
  104172:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104175:	73 18                	jae    10418f <get_pgtable_items+0x3f>
  104177:	8b 45 10             	mov    0x10(%ebp),%eax
  10417a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104181:	8b 45 14             	mov    0x14(%ebp),%eax
  104184:	01 d0                	add    %edx,%eax
  104186:	8b 00                	mov    (%eax),%eax
  104188:	83 e0 01             	and    $0x1,%eax
  10418b:	85 c0                	test   %eax,%eax
  10418d:	74 dd                	je     10416c <get_pgtable_items+0x1c>
    }
    if (start < right) {
  10418f:	8b 45 10             	mov    0x10(%ebp),%eax
  104192:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104195:	73 68                	jae    1041ff <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  104197:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10419b:	74 08                	je     1041a5 <get_pgtable_items+0x55>
            *left_store = start;
  10419d:	8b 45 18             	mov    0x18(%ebp),%eax
  1041a0:	8b 55 10             	mov    0x10(%ebp),%edx
  1041a3:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1041a5:	8b 45 10             	mov    0x10(%ebp),%eax
  1041a8:	8d 50 01             	lea    0x1(%eax),%edx
  1041ab:	89 55 10             	mov    %edx,0x10(%ebp)
  1041ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1041b5:	8b 45 14             	mov    0x14(%ebp),%eax
  1041b8:	01 d0                	add    %edx,%eax
  1041ba:	8b 00                	mov    (%eax),%eax
  1041bc:	83 e0 07             	and    $0x7,%eax
  1041bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1041c2:	eb 03                	jmp    1041c7 <get_pgtable_items+0x77>
            start ++;
  1041c4:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1041c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1041ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1041cd:	73 1d                	jae    1041ec <get_pgtable_items+0x9c>
  1041cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1041d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1041d9:	8b 45 14             	mov    0x14(%ebp),%eax
  1041dc:	01 d0                	add    %edx,%eax
  1041de:	8b 00                	mov    (%eax),%eax
  1041e0:	83 e0 07             	and    $0x7,%eax
  1041e3:	89 c2                	mov    %eax,%edx
  1041e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041e8:	39 c2                	cmp    %eax,%edx
  1041ea:	74 d8                	je     1041c4 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
  1041ec:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1041f0:	74 08                	je     1041fa <get_pgtable_items+0xaa>
            *right_store = start;
  1041f2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1041f5:	8b 55 10             	mov    0x10(%ebp),%edx
  1041f8:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1041fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041fd:	eb 05                	jmp    104204 <get_pgtable_items+0xb4>
    }
    return 0;
  1041ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104204:	c9                   	leave  
  104205:	c3                   	ret    

00104206 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104206:	f3 0f 1e fb          	endbr32 
  10420a:	55                   	push   %ebp
  10420b:	89 e5                	mov    %esp,%ebp
  10420d:	57                   	push   %edi
  10420e:	56                   	push   %esi
  10420f:	53                   	push   %ebx
  104210:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104213:	c7 04 24 10 6e 10 00 	movl   $0x106e10,(%esp)
  10421a:	e8 9b c0 ff ff       	call   1002ba <cprintf>
    size_t left, right = 0, perm;
  10421f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104226:	e9 fa 00 00 00       	jmp    104325 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10422b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10422e:	89 04 24             	mov    %eax,(%esp)
  104231:	e8 d4 fe ff ff       	call   10410a <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104236:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104239:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10423c:	29 d1                	sub    %edx,%ecx
  10423e:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104240:	89 d6                	mov    %edx,%esi
  104242:	c1 e6 16             	shl    $0x16,%esi
  104245:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104248:	89 d3                	mov    %edx,%ebx
  10424a:	c1 e3 16             	shl    $0x16,%ebx
  10424d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104250:	89 d1                	mov    %edx,%ecx
  104252:	c1 e1 16             	shl    $0x16,%ecx
  104255:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104258:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10425b:	29 d7                	sub    %edx,%edi
  10425d:	89 fa                	mov    %edi,%edx
  10425f:	89 44 24 14          	mov    %eax,0x14(%esp)
  104263:	89 74 24 10          	mov    %esi,0x10(%esp)
  104267:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10426b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10426f:	89 54 24 04          	mov    %edx,0x4(%esp)
  104273:	c7 04 24 41 6e 10 00 	movl   $0x106e41,(%esp)
  10427a:	e8 3b c0 ff ff       	call   1002ba <cprintf>
        size_t l, r = left * NPTEENTRY;
  10427f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104282:	c1 e0 0a             	shl    $0xa,%eax
  104285:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104288:	eb 54                	jmp    1042de <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10428a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10428d:	89 04 24             	mov    %eax,(%esp)
  104290:	e8 75 fe ff ff       	call   10410a <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104295:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104298:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10429b:	29 d1                	sub    %edx,%ecx
  10429d:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10429f:	89 d6                	mov    %edx,%esi
  1042a1:	c1 e6 0c             	shl    $0xc,%esi
  1042a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042a7:	89 d3                	mov    %edx,%ebx
  1042a9:	c1 e3 0c             	shl    $0xc,%ebx
  1042ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042af:	89 d1                	mov    %edx,%ecx
  1042b1:	c1 e1 0c             	shl    $0xc,%ecx
  1042b4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1042b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042ba:	29 d7                	sub    %edx,%edi
  1042bc:	89 fa                	mov    %edi,%edx
  1042be:	89 44 24 14          	mov    %eax,0x14(%esp)
  1042c2:	89 74 24 10          	mov    %esi,0x10(%esp)
  1042c6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1042ca:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1042ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  1042d2:	c7 04 24 60 6e 10 00 	movl   $0x106e60,(%esp)
  1042d9:	e8 dc bf ff ff       	call   1002ba <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1042de:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1042e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1042e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042e9:	89 d3                	mov    %edx,%ebx
  1042eb:	c1 e3 0a             	shl    $0xa,%ebx
  1042ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042f1:	89 d1                	mov    %edx,%ecx
  1042f3:	c1 e1 0a             	shl    $0xa,%ecx
  1042f6:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1042f9:	89 54 24 14          	mov    %edx,0x14(%esp)
  1042fd:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104300:	89 54 24 10          	mov    %edx,0x10(%esp)
  104304:	89 74 24 0c          	mov    %esi,0xc(%esp)
  104308:	89 44 24 08          	mov    %eax,0x8(%esp)
  10430c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104310:	89 0c 24             	mov    %ecx,(%esp)
  104313:	e8 38 fe ff ff       	call   104150 <get_pgtable_items>
  104318:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10431b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10431f:	0f 85 65 ff ff ff    	jne    10428a <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104325:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10432a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10432d:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104330:	89 54 24 14          	mov    %edx,0x14(%esp)
  104334:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104337:	89 54 24 10          	mov    %edx,0x10(%esp)
  10433b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10433f:	89 44 24 08          	mov    %eax,0x8(%esp)
  104343:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10434a:	00 
  10434b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104352:	e8 f9 fd ff ff       	call   104150 <get_pgtable_items>
  104357:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10435a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10435e:	0f 85 c7 fe ff ff    	jne    10422b <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104364:	c7 04 24 84 6e 10 00 	movl   $0x106e84,(%esp)
  10436b:	e8 4a bf ff ff       	call   1002ba <cprintf>
}
  104370:	90                   	nop
  104371:	83 c4 4c             	add    $0x4c,%esp
  104374:	5b                   	pop    %ebx
  104375:	5e                   	pop    %esi
  104376:	5f                   	pop    %edi
  104377:	5d                   	pop    %ebp
  104378:	c3                   	ret    

00104379 <page2ppn>:
page2ppn(struct Page *page) {
  104379:	55                   	push   %ebp
  10437a:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10437c:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  104381:	8b 55 08             	mov    0x8(%ebp),%edx
  104384:	29 c2                	sub    %eax,%edx
  104386:	89 d0                	mov    %edx,%eax
  104388:	c1 f8 02             	sar    $0x2,%eax
  10438b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104391:	5d                   	pop    %ebp
  104392:	c3                   	ret    

00104393 <page2pa>:
page2pa(struct Page *page) {
  104393:	55                   	push   %ebp
  104394:	89 e5                	mov    %esp,%ebp
  104396:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104399:	8b 45 08             	mov    0x8(%ebp),%eax
  10439c:	89 04 24             	mov    %eax,(%esp)
  10439f:	e8 d5 ff ff ff       	call   104379 <page2ppn>
  1043a4:	c1 e0 0c             	shl    $0xc,%eax
}
  1043a7:	c9                   	leave  
  1043a8:	c3                   	ret    

001043a9 <page_ref>:
page_ref(struct Page *page) {
  1043a9:	55                   	push   %ebp
  1043aa:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1043ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1043af:	8b 00                	mov    (%eax),%eax
}
  1043b1:	5d                   	pop    %ebp
  1043b2:	c3                   	ret    

001043b3 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1043b3:	55                   	push   %ebp
  1043b4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1043b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1043b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043bc:	89 10                	mov    %edx,(%eax)
}
  1043be:	90                   	nop
  1043bf:	5d                   	pop    %ebp
  1043c0:	c3                   	ret    

001043c1 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1043c1:	f3 0f 1e fb          	endbr32 
  1043c5:	55                   	push   %ebp
  1043c6:	89 e5                	mov    %esp,%ebp
  1043c8:	83 ec 10             	sub    $0x10,%esp
  1043cb:	c7 45 fc 1c cf 11 00 	movl   $0x11cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1043d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1043d8:	89 50 04             	mov    %edx,0x4(%eax)
  1043db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043de:	8b 50 04             	mov    0x4(%eax),%edx
  1043e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043e4:	89 10                	mov    %edx,(%eax)
}
  1043e6:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  1043e7:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  1043ee:	00 00 00 
}
  1043f1:	90                   	nop
  1043f2:	c9                   	leave  
  1043f3:	c3                   	ret    

001043f4 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1043f4:	f3 0f 1e fb          	endbr32 
  1043f8:	55                   	push   %ebp
  1043f9:	89 e5                	mov    %esp,%ebp
  1043fb:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1043fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104402:	75 24                	jne    104428 <default_init_memmap+0x34>
  104404:	c7 44 24 0c b8 6e 10 	movl   $0x106eb8,0xc(%esp)
  10440b:	00 
  10440c:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104413:	00 
  104414:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  10441b:	00 
  10441c:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104423:	e8 fe bf ff ff       	call   100426 <__panic>
    struct Page *p = base;
  104428:	8b 45 08             	mov    0x8(%ebp),%eax
  10442b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10442e:	eb 7d                	jmp    1044ad <default_init_memmap+0xb9>
        assert(PageReserved(p));
  104430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104433:	83 c0 04             	add    $0x4,%eax
  104436:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10443d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104440:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104443:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104446:	0f a3 10             	bt     %edx,(%eax)
  104449:	19 c0                	sbb    %eax,%eax
  10444b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10444e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104452:	0f 95 c0             	setne  %al
  104455:	0f b6 c0             	movzbl %al,%eax
  104458:	85 c0                	test   %eax,%eax
  10445a:	75 24                	jne    104480 <default_init_memmap+0x8c>
  10445c:	c7 44 24 0c e9 6e 10 	movl   $0x106ee9,0xc(%esp)
  104463:	00 
  104464:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  10446b:	00 
  10446c:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  104473:	00 
  104474:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  10447b:	e8 a6 bf ff ff       	call   100426 <__panic>
        p->flags = p->property = 0;
  104480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104483:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10448a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10448d:	8b 50 08             	mov    0x8(%eax),%edx
  104490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104493:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  104496:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10449d:	00 
  10449e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044a1:	89 04 24             	mov    %eax,(%esp)
  1044a4:	e8 0a ff ff ff       	call   1043b3 <set_page_ref>
    for (; p != base + n; p ++) {
  1044a9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1044ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044b0:	89 d0                	mov    %edx,%eax
  1044b2:	c1 e0 02             	shl    $0x2,%eax
  1044b5:	01 d0                	add    %edx,%eax
  1044b7:	c1 e0 02             	shl    $0x2,%eax
  1044ba:	89 c2                	mov    %eax,%edx
  1044bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1044bf:	01 d0                	add    %edx,%eax
  1044c1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1044c4:	0f 85 66 ff ff ff    	jne    104430 <default_init_memmap+0x3c>
    }
    base->property = n;
  1044ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1044cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044d0:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1044d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d6:	83 c0 04             	add    $0x4,%eax
  1044d9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1044e0:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1044e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1044e6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1044e9:	0f ab 10             	bts    %edx,(%eax)
}
  1044ec:	90                   	nop
    nr_free += n;
  1044ed:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  1044f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044f6:	01 d0                	add    %edx,%eax
  1044f8:	a3 24 cf 11 00       	mov    %eax,0x11cf24
    list_add_before(&free_list, &(base->page_link));
  1044fd:	8b 45 08             	mov    0x8(%ebp),%eax
  104500:	83 c0 0c             	add    $0xc,%eax
  104503:	c7 45 e4 1c cf 11 00 	movl   $0x11cf1c,-0x1c(%ebp)
  10450a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  10450d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104510:	8b 00                	mov    (%eax),%eax
  104512:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104515:	89 55 dc             	mov    %edx,-0x24(%ebp)
  104518:	89 45 d8             	mov    %eax,-0x28(%ebp)
  10451b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10451e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104521:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104524:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104527:	89 10                	mov    %edx,(%eax)
  104529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10452c:	8b 10                	mov    (%eax),%edx
  10452e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104531:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104534:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104537:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10453a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10453d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104540:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104543:	89 10                	mov    %edx,(%eax)
}
  104545:	90                   	nop
}
  104546:	90                   	nop
}
  104547:	90                   	nop
  104548:	c9                   	leave  
  104549:	c3                   	ret    

0010454a <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  10454a:	f3 0f 1e fb          	endbr32 
  10454e:	55                   	push   %ebp
  10454f:	89 e5                	mov    %esp,%ebp
  104551:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  104554:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104558:	75 24                	jne    10457e <default_alloc_pages+0x34>
  10455a:	c7 44 24 0c b8 6e 10 	movl   $0x106eb8,0xc(%esp)
  104561:	00 
  104562:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104569:	00 
  10456a:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  104571:	00 
  104572:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104579:	e8 a8 be ff ff       	call   100426 <__panic>
    if (n > nr_free) {
  10457e:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104583:	39 45 08             	cmp    %eax,0x8(%ebp)
  104586:	76 0a                	jbe    104592 <default_alloc_pages+0x48>
        return NULL;
  104588:	b8 00 00 00 00       	mov    $0x0,%eax
  10458d:	e9 43 01 00 00       	jmp    1046d5 <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
  104592:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104599:	c7 45 f0 1c cf 11 00 	movl   $0x11cf1c,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
  1045a0:	eb 1c                	jmp    1045be <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
  1045a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045a5:	83 e8 0c             	sub    $0xc,%eax
  1045a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  1045ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045ae:	8b 40 08             	mov    0x8(%eax),%eax
  1045b1:	39 45 08             	cmp    %eax,0x8(%ebp)
  1045b4:	77 08                	ja     1045be <default_alloc_pages+0x74>
            page = p;
  1045b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  1045bc:	eb 18                	jmp    1045d6 <default_alloc_pages+0x8c>
  1045be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  1045c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1045c7:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1045ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045cd:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  1045d4:	75 cc                	jne    1045a2 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
  1045d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045da:	0f 84 f2 00 00 00    	je     1046d2 <default_alloc_pages+0x188>
        if (page->property > n) {
  1045e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045e3:	8b 40 08             	mov    0x8(%eax),%eax
  1045e6:	39 45 08             	cmp    %eax,0x8(%ebp)
  1045e9:	0f 83 8f 00 00 00    	jae    10467e <default_alloc_pages+0x134>
            struct Page *p = page + n;
  1045ef:	8b 55 08             	mov    0x8(%ebp),%edx
  1045f2:	89 d0                	mov    %edx,%eax
  1045f4:	c1 e0 02             	shl    $0x2,%eax
  1045f7:	01 d0                	add    %edx,%eax
  1045f9:	c1 e0 02             	shl    $0x2,%eax
  1045fc:	89 c2                	mov    %eax,%edx
  1045fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104601:	01 d0                	add    %edx,%eax
  104603:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  104606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104609:	8b 40 08             	mov    0x8(%eax),%eax
  10460c:	2b 45 08             	sub    0x8(%ebp),%eax
  10460f:	89 c2                	mov    %eax,%edx
  104611:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104614:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  104617:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10461a:	83 c0 04             	add    $0x4,%eax
  10461d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  104624:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104627:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10462a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10462d:	0f ab 10             	bts    %edx,(%eax)
}
  104630:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
  104631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104634:	83 c0 0c             	add    $0xc,%eax
  104637:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10463a:	83 c2 0c             	add    $0xc,%edx
  10463d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  104640:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
  104643:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104646:	8b 40 04             	mov    0x4(%eax),%eax
  104649:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10464c:	89 55 d8             	mov    %edx,-0x28(%ebp)
  10464f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104652:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104655:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  104658:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10465b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10465e:	89 10                	mov    %edx,(%eax)
  104660:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104663:	8b 10                	mov    (%eax),%edx
  104665:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104668:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10466b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10466e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104671:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104674:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104677:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10467a:	89 10                	mov    %edx,(%eax)
}
  10467c:	90                   	nop
}
  10467d:	90                   	nop
        }
        list_del(&(page->page_link));
  10467e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104681:	83 c0 0c             	add    $0xc,%eax
  104684:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  104687:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10468a:	8b 40 04             	mov    0x4(%eax),%eax
  10468d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104690:	8b 12                	mov    (%edx),%edx
  104692:	89 55 b8             	mov    %edx,-0x48(%ebp)
  104695:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104698:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10469b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10469e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1046a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1046a4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1046a7:	89 10                	mov    %edx,(%eax)
}
  1046a9:	90                   	nop
}
  1046aa:	90                   	nop
        nr_free -= n;
  1046ab:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  1046b0:	2b 45 08             	sub    0x8(%ebp),%eax
  1046b3:	a3 24 cf 11 00       	mov    %eax,0x11cf24
        ClearPageProperty(page);
  1046b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046bb:	83 c0 04             	add    $0x4,%eax
  1046be:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  1046c5:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1046c8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1046cb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1046ce:	0f b3 10             	btr    %edx,(%eax)
}
  1046d1:	90                   	nop
    }
    return page;
  1046d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1046d5:	c9                   	leave  
  1046d6:	c3                   	ret    

001046d7 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  1046d7:	f3 0f 1e fb          	endbr32 
  1046db:	55                   	push   %ebp
  1046dc:	89 e5                	mov    %esp,%ebp
  1046de:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  1046e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1046e8:	75 24                	jne    10470e <default_free_pages+0x37>
  1046ea:	c7 44 24 0c b8 6e 10 	movl   $0x106eb8,0xc(%esp)
  1046f1:	00 
  1046f2:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  1046f9:	00 
  1046fa:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  104701:	00 
  104702:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104709:	e8 18 bd ff ff       	call   100426 <__panic>
    struct Page *p = base;
  10470e:	8b 45 08             	mov    0x8(%ebp),%eax
  104711:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104714:	e9 9d 00 00 00       	jmp    1047b6 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
  104719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10471c:	83 c0 04             	add    $0x4,%eax
  10471f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104726:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104729:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10472c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10472f:	0f a3 10             	bt     %edx,(%eax)
  104732:	19 c0                	sbb    %eax,%eax
  104734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104737:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10473b:	0f 95 c0             	setne  %al
  10473e:	0f b6 c0             	movzbl %al,%eax
  104741:	85 c0                	test   %eax,%eax
  104743:	75 2c                	jne    104771 <default_free_pages+0x9a>
  104745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104748:	83 c0 04             	add    $0x4,%eax
  10474b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104752:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104755:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104758:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10475b:	0f a3 10             	bt     %edx,(%eax)
  10475e:	19 c0                	sbb    %eax,%eax
  104760:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  104763:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104767:	0f 95 c0             	setne  %al
  10476a:	0f b6 c0             	movzbl %al,%eax
  10476d:	85 c0                	test   %eax,%eax
  10476f:	74 24                	je     104795 <default_free_pages+0xbe>
  104771:	c7 44 24 0c fc 6e 10 	movl   $0x106efc,0xc(%esp)
  104778:	00 
  104779:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104780:	00 
  104781:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  104788:	00 
  104789:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104790:	e8 91 bc ff ff       	call   100426 <__panic>
        p->flags = 0;
  104795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104798:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  10479f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1047a6:	00 
  1047a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047aa:	89 04 24             	mov    %eax,(%esp)
  1047ad:	e8 01 fc ff ff       	call   1043b3 <set_page_ref>
    for (; p != base + n; p ++) {
  1047b2:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1047b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047b9:	89 d0                	mov    %edx,%eax
  1047bb:	c1 e0 02             	shl    $0x2,%eax
  1047be:	01 d0                	add    %edx,%eax
  1047c0:	c1 e0 02             	shl    $0x2,%eax
  1047c3:	89 c2                	mov    %eax,%edx
  1047c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1047c8:	01 d0                	add    %edx,%eax
  1047ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1047cd:	0f 85 46 ff ff ff    	jne    104719 <default_free_pages+0x42>
    }
    base->property = n;
  1047d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1047d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047d9:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1047dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1047df:	83 c0 04             	add    $0x4,%eax
  1047e2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1047e9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1047ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1047ef:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1047f2:	0f ab 10             	bts    %edx,(%eax)
}
  1047f5:	90                   	nop
  1047f6:	c7 45 d4 1c cf 11 00 	movl   $0x11cf1c,-0x2c(%ebp)
    return listelm->next;
  1047fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104800:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104803:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104806:	e9 0e 01 00 00       	jmp    104919 <default_free_pages+0x242>
        p = le2page(le, page_link);
  10480b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10480e:	83 e8 0c             	sub    $0xc,%eax
  104811:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104817:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10481a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10481d:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  104820:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
  104823:	8b 45 08             	mov    0x8(%ebp),%eax
  104826:	8b 50 08             	mov    0x8(%eax),%edx
  104829:	89 d0                	mov    %edx,%eax
  10482b:	c1 e0 02             	shl    $0x2,%eax
  10482e:	01 d0                	add    %edx,%eax
  104830:	c1 e0 02             	shl    $0x2,%eax
  104833:	89 c2                	mov    %eax,%edx
  104835:	8b 45 08             	mov    0x8(%ebp),%eax
  104838:	01 d0                	add    %edx,%eax
  10483a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10483d:	75 5d                	jne    10489c <default_free_pages+0x1c5>
            base->property += p->property;
  10483f:	8b 45 08             	mov    0x8(%ebp),%eax
  104842:	8b 50 08             	mov    0x8(%eax),%edx
  104845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104848:	8b 40 08             	mov    0x8(%eax),%eax
  10484b:	01 c2                	add    %eax,%edx
  10484d:	8b 45 08             	mov    0x8(%ebp),%eax
  104850:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  104853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104856:	83 c0 04             	add    $0x4,%eax
  104859:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  104860:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104863:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104866:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104869:	0f b3 10             	btr    %edx,(%eax)
}
  10486c:	90                   	nop
            list_del(&(p->page_link));
  10486d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104870:	83 c0 0c             	add    $0xc,%eax
  104873:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104876:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104879:	8b 40 04             	mov    0x4(%eax),%eax
  10487c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10487f:	8b 12                	mov    (%edx),%edx
  104881:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104884:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104887:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10488a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10488d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104890:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104893:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104896:	89 10                	mov    %edx,(%eax)
}
  104898:	90                   	nop
}
  104899:	90                   	nop
  10489a:	eb 7d                	jmp    104919 <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
  10489c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10489f:	8b 50 08             	mov    0x8(%eax),%edx
  1048a2:	89 d0                	mov    %edx,%eax
  1048a4:	c1 e0 02             	shl    $0x2,%eax
  1048a7:	01 d0                	add    %edx,%eax
  1048a9:	c1 e0 02             	shl    $0x2,%eax
  1048ac:	89 c2                	mov    %eax,%edx
  1048ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b1:	01 d0                	add    %edx,%eax
  1048b3:	39 45 08             	cmp    %eax,0x8(%ebp)
  1048b6:	75 61                	jne    104919 <default_free_pages+0x242>
            p->property += base->property;
  1048b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048bb:	8b 50 08             	mov    0x8(%eax),%edx
  1048be:	8b 45 08             	mov    0x8(%ebp),%eax
  1048c1:	8b 40 08             	mov    0x8(%eax),%eax
  1048c4:	01 c2                	add    %eax,%edx
  1048c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048c9:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  1048cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1048cf:	83 c0 04             	add    $0x4,%eax
  1048d2:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  1048d9:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1048dc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1048df:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1048e2:	0f b3 10             	btr    %edx,(%eax)
}
  1048e5:	90                   	nop
            base = p;
  1048e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048e9:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  1048ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ef:	83 c0 0c             	add    $0xc,%eax
  1048f2:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  1048f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1048f8:	8b 40 04             	mov    0x4(%eax),%eax
  1048fb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1048fe:	8b 12                	mov    (%edx),%edx
  104900:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104903:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  104906:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104909:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10490c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10490f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104912:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104915:	89 10                	mov    %edx,(%eax)
}
  104917:	90                   	nop
}
  104918:	90                   	nop
    while (le != &free_list) {
  104919:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  104920:	0f 85 e5 fe ff ff    	jne    10480b <default_free_pages+0x134>
        }
    }
    nr_free += n;
  104926:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  10492c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10492f:	01 d0                	add    %edx,%eax
  104931:	a3 24 cf 11 00       	mov    %eax,0x11cf24
  104936:	c7 45 9c 1c cf 11 00 	movl   $0x11cf1c,-0x64(%ebp)
    return listelm->next;
  10493d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104940:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  104943:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104946:	eb 74                	jmp    1049bc <default_free_pages+0x2e5>
        p = le2page(le, page_link);
  104948:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10494b:	83 e8 0c             	sub    $0xc,%eax
  10494e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  104951:	8b 45 08             	mov    0x8(%ebp),%eax
  104954:	8b 50 08             	mov    0x8(%eax),%edx
  104957:	89 d0                	mov    %edx,%eax
  104959:	c1 e0 02             	shl    $0x2,%eax
  10495c:	01 d0                	add    %edx,%eax
  10495e:	c1 e0 02             	shl    $0x2,%eax
  104961:	89 c2                	mov    %eax,%edx
  104963:	8b 45 08             	mov    0x8(%ebp),%eax
  104966:	01 d0                	add    %edx,%eax
  104968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10496b:	72 40                	jb     1049ad <default_free_pages+0x2d6>
            assert(base + base->property != p);
  10496d:	8b 45 08             	mov    0x8(%ebp),%eax
  104970:	8b 50 08             	mov    0x8(%eax),%edx
  104973:	89 d0                	mov    %edx,%eax
  104975:	c1 e0 02             	shl    $0x2,%eax
  104978:	01 d0                	add    %edx,%eax
  10497a:	c1 e0 02             	shl    $0x2,%eax
  10497d:	89 c2                	mov    %eax,%edx
  10497f:	8b 45 08             	mov    0x8(%ebp),%eax
  104982:	01 d0                	add    %edx,%eax
  104984:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104987:	75 3e                	jne    1049c7 <default_free_pages+0x2f0>
  104989:	c7 44 24 0c 21 6f 10 	movl   $0x106f21,0xc(%esp)
  104990:	00 
  104991:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104998:	00 
  104999:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  1049a0:	00 
  1049a1:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  1049a8:	e8 79 ba ff ff       	call   100426 <__panic>
  1049ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049b0:	89 45 98             	mov    %eax,-0x68(%ebp)
  1049b3:	8b 45 98             	mov    -0x68(%ebp),%eax
  1049b6:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  1049b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1049bc:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  1049c3:	75 83                	jne    104948 <default_free_pages+0x271>
  1049c5:	eb 01                	jmp    1049c8 <default_free_pages+0x2f1>
            break;
  1049c7:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  1049c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1049cb:	8d 50 0c             	lea    0xc(%eax),%edx
  1049ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049d1:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1049d4:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  1049d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1049da:	8b 00                	mov    (%eax),%eax
  1049dc:	8b 55 90             	mov    -0x70(%ebp),%edx
  1049df:	89 55 8c             	mov    %edx,-0x74(%ebp)
  1049e2:	89 45 88             	mov    %eax,-0x78(%ebp)
  1049e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1049e8:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  1049eb:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1049ee:	8b 55 8c             	mov    -0x74(%ebp),%edx
  1049f1:	89 10                	mov    %edx,(%eax)
  1049f3:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1049f6:	8b 10                	mov    (%eax),%edx
  1049f8:	8b 45 88             	mov    -0x78(%ebp),%eax
  1049fb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1049fe:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104a01:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104a04:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104a07:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104a0a:	8b 55 88             	mov    -0x78(%ebp),%edx
  104a0d:	89 10                	mov    %edx,(%eax)
}
  104a0f:	90                   	nop
}
  104a10:	90                   	nop
}
  104a11:	90                   	nop
  104a12:	c9                   	leave  
  104a13:	c3                   	ret    

00104a14 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104a14:	f3 0f 1e fb          	endbr32 
  104a18:	55                   	push   %ebp
  104a19:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104a1b:	a1 24 cf 11 00       	mov    0x11cf24,%eax
}
  104a20:	5d                   	pop    %ebp
  104a21:	c3                   	ret    

00104a22 <basic_check>:

static void
basic_check(void) {
  104a22:	f3 0f 1e fb          	endbr32 
  104a26:	55                   	push   %ebp
  104a27:	89 e5                	mov    %esp,%ebp
  104a29:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104a2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104a3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a46:	e8 63 e2 ff ff       	call   102cae <alloc_pages>
  104a4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104a52:	75 24                	jne    104a78 <basic_check+0x56>
  104a54:	c7 44 24 0c 3c 6f 10 	movl   $0x106f3c,0xc(%esp)
  104a5b:	00 
  104a5c:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104a63:	00 
  104a64:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  104a6b:	00 
  104a6c:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104a73:	e8 ae b9 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104a78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a7f:	e8 2a e2 ff ff       	call   102cae <alloc_pages>
  104a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a8b:	75 24                	jne    104ab1 <basic_check+0x8f>
  104a8d:	c7 44 24 0c 58 6f 10 	movl   $0x106f58,0xc(%esp)
  104a94:	00 
  104a95:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104a9c:	00 
  104a9d:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  104aa4:	00 
  104aa5:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104aac:	e8 75 b9 ff ff       	call   100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104ab1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ab8:	e8 f1 e1 ff ff       	call   102cae <alloc_pages>
  104abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104ac4:	75 24                	jne    104aea <basic_check+0xc8>
  104ac6:	c7 44 24 0c 74 6f 10 	movl   $0x106f74,0xc(%esp)
  104acd:	00 
  104ace:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104ad5:	00 
  104ad6:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  104add:	00 
  104ade:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104ae5:	e8 3c b9 ff ff       	call   100426 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104aed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104af0:	74 10                	je     104b02 <basic_check+0xe0>
  104af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104af5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104af8:	74 08                	je     104b02 <basic_check+0xe0>
  104afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104afd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b00:	75 24                	jne    104b26 <basic_check+0x104>
  104b02:	c7 44 24 0c 90 6f 10 	movl   $0x106f90,0xc(%esp)
  104b09:	00 
  104b0a:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104b11:	00 
  104b12:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  104b19:	00 
  104b1a:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104b21:	e8 00 b9 ff ff       	call   100426 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b29:	89 04 24             	mov    %eax,(%esp)
  104b2c:	e8 78 f8 ff ff       	call   1043a9 <page_ref>
  104b31:	85 c0                	test   %eax,%eax
  104b33:	75 1e                	jne    104b53 <basic_check+0x131>
  104b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b38:	89 04 24             	mov    %eax,(%esp)
  104b3b:	e8 69 f8 ff ff       	call   1043a9 <page_ref>
  104b40:	85 c0                	test   %eax,%eax
  104b42:	75 0f                	jne    104b53 <basic_check+0x131>
  104b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b47:	89 04 24             	mov    %eax,(%esp)
  104b4a:	e8 5a f8 ff ff       	call   1043a9 <page_ref>
  104b4f:	85 c0                	test   %eax,%eax
  104b51:	74 24                	je     104b77 <basic_check+0x155>
  104b53:	c7 44 24 0c b4 6f 10 	movl   $0x106fb4,0xc(%esp)
  104b5a:	00 
  104b5b:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104b62:	00 
  104b63:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  104b6a:	00 
  104b6b:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104b72:	e8 af b8 ff ff       	call   100426 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b7a:	89 04 24             	mov    %eax,(%esp)
  104b7d:	e8 11 f8 ff ff       	call   104393 <page2pa>
  104b82:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104b88:	c1 e2 0c             	shl    $0xc,%edx
  104b8b:	39 d0                	cmp    %edx,%eax
  104b8d:	72 24                	jb     104bb3 <basic_check+0x191>
  104b8f:	c7 44 24 0c f0 6f 10 	movl   $0x106ff0,0xc(%esp)
  104b96:	00 
  104b97:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104b9e:	00 
  104b9f:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  104ba6:	00 
  104ba7:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104bae:	e8 73 b8 ff ff       	call   100426 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bb6:	89 04 24             	mov    %eax,(%esp)
  104bb9:	e8 d5 f7 ff ff       	call   104393 <page2pa>
  104bbe:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104bc4:	c1 e2 0c             	shl    $0xc,%edx
  104bc7:	39 d0                	cmp    %edx,%eax
  104bc9:	72 24                	jb     104bef <basic_check+0x1cd>
  104bcb:	c7 44 24 0c 0d 70 10 	movl   $0x10700d,0xc(%esp)
  104bd2:	00 
  104bd3:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104bda:	00 
  104bdb:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  104be2:	00 
  104be3:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104bea:	e8 37 b8 ff ff       	call   100426 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bf2:	89 04 24             	mov    %eax,(%esp)
  104bf5:	e8 99 f7 ff ff       	call   104393 <page2pa>
  104bfa:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104c00:	c1 e2 0c             	shl    $0xc,%edx
  104c03:	39 d0                	cmp    %edx,%eax
  104c05:	72 24                	jb     104c2b <basic_check+0x209>
  104c07:	c7 44 24 0c 2a 70 10 	movl   $0x10702a,0xc(%esp)
  104c0e:	00 
  104c0f:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104c16:	00 
  104c17:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  104c1e:	00 
  104c1f:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104c26:	e8 fb b7 ff ff       	call   100426 <__panic>

    list_entry_t free_list_store = free_list;
  104c2b:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  104c30:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  104c36:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104c39:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104c3c:	c7 45 dc 1c cf 11 00 	movl   $0x11cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104c43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c46:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c49:	89 50 04             	mov    %edx,0x4(%eax)
  104c4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c4f:	8b 50 04             	mov    0x4(%eax),%edx
  104c52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c55:	89 10                	mov    %edx,(%eax)
}
  104c57:	90                   	nop
  104c58:	c7 45 e0 1c cf 11 00 	movl   $0x11cf1c,-0x20(%ebp)
    return list->next == list;
  104c5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c62:	8b 40 04             	mov    0x4(%eax),%eax
  104c65:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104c68:	0f 94 c0             	sete   %al
  104c6b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104c6e:	85 c0                	test   %eax,%eax
  104c70:	75 24                	jne    104c96 <basic_check+0x274>
  104c72:	c7 44 24 0c 47 70 10 	movl   $0x107047,0xc(%esp)
  104c79:	00 
  104c7a:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104c81:	00 
  104c82:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  104c89:	00 
  104c8a:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104c91:	e8 90 b7 ff ff       	call   100426 <__panic>

    unsigned int nr_free_store = nr_free;
  104c96:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104c9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104c9e:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  104ca5:	00 00 00 

    assert(alloc_page() == NULL);
  104ca8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104caf:	e8 fa df ff ff       	call   102cae <alloc_pages>
  104cb4:	85 c0                	test   %eax,%eax
  104cb6:	74 24                	je     104cdc <basic_check+0x2ba>
  104cb8:	c7 44 24 0c 5e 70 10 	movl   $0x10705e,0xc(%esp)
  104cbf:	00 
  104cc0:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104cc7:	00 
  104cc8:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104ccf:	00 
  104cd0:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104cd7:	e8 4a b7 ff ff       	call   100426 <__panic>

    free_page(p0);
  104cdc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ce3:	00 
  104ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ce7:	89 04 24             	mov    %eax,(%esp)
  104cea:	e8 fb df ff ff       	call   102cea <free_pages>
    free_page(p1);
  104cef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104cf6:	00 
  104cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cfa:	89 04 24             	mov    %eax,(%esp)
  104cfd:	e8 e8 df ff ff       	call   102cea <free_pages>
    free_page(p2);
  104d02:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d09:	00 
  104d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d0d:	89 04 24             	mov    %eax,(%esp)
  104d10:	e8 d5 df ff ff       	call   102cea <free_pages>
    assert(nr_free == 3);
  104d15:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104d1a:	83 f8 03             	cmp    $0x3,%eax
  104d1d:	74 24                	je     104d43 <basic_check+0x321>
  104d1f:	c7 44 24 0c 73 70 10 	movl   $0x107073,0xc(%esp)
  104d26:	00 
  104d27:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104d2e:	00 
  104d2f:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104d36:	00 
  104d37:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104d3e:	e8 e3 b6 ff ff       	call   100426 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104d43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d4a:	e8 5f df ff ff       	call   102cae <alloc_pages>
  104d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d52:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104d56:	75 24                	jne    104d7c <basic_check+0x35a>
  104d58:	c7 44 24 0c 3c 6f 10 	movl   $0x106f3c,0xc(%esp)
  104d5f:	00 
  104d60:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104d67:	00 
  104d68:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  104d6f:	00 
  104d70:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104d77:	e8 aa b6 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104d7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d83:	e8 26 df ff ff       	call   102cae <alloc_pages>
  104d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104d8f:	75 24                	jne    104db5 <basic_check+0x393>
  104d91:	c7 44 24 0c 58 6f 10 	movl   $0x106f58,0xc(%esp)
  104d98:	00 
  104d99:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104da0:	00 
  104da1:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  104da8:	00 
  104da9:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104db0:	e8 71 b6 ff ff       	call   100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104db5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104dbc:	e8 ed de ff ff       	call   102cae <alloc_pages>
  104dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104dc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104dc8:	75 24                	jne    104dee <basic_check+0x3cc>
  104dca:	c7 44 24 0c 74 6f 10 	movl   $0x106f74,0xc(%esp)
  104dd1:	00 
  104dd2:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104dd9:	00 
  104dda:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  104de1:	00 
  104de2:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104de9:	e8 38 b6 ff ff       	call   100426 <__panic>

    assert(alloc_page() == NULL);
  104dee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104df5:	e8 b4 de ff ff       	call   102cae <alloc_pages>
  104dfa:	85 c0                	test   %eax,%eax
  104dfc:	74 24                	je     104e22 <basic_check+0x400>
  104dfe:	c7 44 24 0c 5e 70 10 	movl   $0x10705e,0xc(%esp)
  104e05:	00 
  104e06:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104e0d:	00 
  104e0e:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  104e15:	00 
  104e16:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104e1d:	e8 04 b6 ff ff       	call   100426 <__panic>

    free_page(p0);
  104e22:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e29:	00 
  104e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e2d:	89 04 24             	mov    %eax,(%esp)
  104e30:	e8 b5 de ff ff       	call   102cea <free_pages>
  104e35:	c7 45 d8 1c cf 11 00 	movl   $0x11cf1c,-0x28(%ebp)
  104e3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104e3f:	8b 40 04             	mov    0x4(%eax),%eax
  104e42:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104e45:	0f 94 c0             	sete   %al
  104e48:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104e4b:	85 c0                	test   %eax,%eax
  104e4d:	74 24                	je     104e73 <basic_check+0x451>
  104e4f:	c7 44 24 0c 80 70 10 	movl   $0x107080,0xc(%esp)
  104e56:	00 
  104e57:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104e5e:	00 
  104e5f:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  104e66:	00 
  104e67:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104e6e:	e8 b3 b5 ff ff       	call   100426 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104e73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e7a:	e8 2f de ff ff       	call   102cae <alloc_pages>
  104e7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e85:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104e88:	74 24                	je     104eae <basic_check+0x48c>
  104e8a:	c7 44 24 0c 98 70 10 	movl   $0x107098,0xc(%esp)
  104e91:	00 
  104e92:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104e99:	00 
  104e9a:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  104ea1:	00 
  104ea2:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104ea9:	e8 78 b5 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  104eae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104eb5:	e8 f4 dd ff ff       	call   102cae <alloc_pages>
  104eba:	85 c0                	test   %eax,%eax
  104ebc:	74 24                	je     104ee2 <basic_check+0x4c0>
  104ebe:	c7 44 24 0c 5e 70 10 	movl   $0x10705e,0xc(%esp)
  104ec5:	00 
  104ec6:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104ecd:	00 
  104ece:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  104ed5:	00 
  104ed6:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104edd:	e8 44 b5 ff ff       	call   100426 <__panic>

    assert(nr_free == 0);
  104ee2:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104ee7:	85 c0                	test   %eax,%eax
  104ee9:	74 24                	je     104f0f <basic_check+0x4ed>
  104eeb:	c7 44 24 0c b1 70 10 	movl   $0x1070b1,0xc(%esp)
  104ef2:	00 
  104ef3:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104efa:	00 
  104efb:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  104f02:	00 
  104f03:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104f0a:	e8 17 b5 ff ff       	call   100426 <__panic>
    free_list = free_list_store;
  104f0f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f12:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104f15:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  104f1a:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    nr_free = nr_free_store;
  104f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f23:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_page(p);
  104f28:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f2f:	00 
  104f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f33:	89 04 24             	mov    %eax,(%esp)
  104f36:	e8 af dd ff ff       	call   102cea <free_pages>
    free_page(p1);
  104f3b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f42:	00 
  104f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f46:	89 04 24             	mov    %eax,(%esp)
  104f49:	e8 9c dd ff ff       	call   102cea <free_pages>
    free_page(p2);
  104f4e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f55:	00 
  104f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f59:	89 04 24             	mov    %eax,(%esp)
  104f5c:	e8 89 dd ff ff       	call   102cea <free_pages>
}
  104f61:	90                   	nop
  104f62:	c9                   	leave  
  104f63:	c3                   	ret    

00104f64 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104f64:	f3 0f 1e fb          	endbr32 
  104f68:	55                   	push   %ebp
  104f69:	89 e5                	mov    %esp,%ebp
  104f6b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  104f71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104f78:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104f7f:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104f86:	eb 6a                	jmp    104ff2 <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
  104f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f8b:	83 e8 0c             	sub    $0xc,%eax
  104f8e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  104f91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104f94:	83 c0 04             	add    $0x4,%eax
  104f97:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104f9e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104fa1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104fa4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104fa7:	0f a3 10             	bt     %edx,(%eax)
  104faa:	19 c0                	sbb    %eax,%eax
  104fac:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104faf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104fb3:	0f 95 c0             	setne  %al
  104fb6:	0f b6 c0             	movzbl %al,%eax
  104fb9:	85 c0                	test   %eax,%eax
  104fbb:	75 24                	jne    104fe1 <default_check+0x7d>
  104fbd:	c7 44 24 0c be 70 10 	movl   $0x1070be,0xc(%esp)
  104fc4:	00 
  104fc5:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  104fcc:	00 
  104fcd:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  104fd4:	00 
  104fd5:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  104fdc:	e8 45 b4 ff ff       	call   100426 <__panic>
        count ++, total += p->property;
  104fe1:	ff 45 f4             	incl   -0xc(%ebp)
  104fe4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104fe7:	8b 50 08             	mov    0x8(%eax),%edx
  104fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fed:	01 d0                	add    %edx,%eax
  104fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ff5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104ff8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104ffb:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104ffe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105001:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  105008:	0f 85 7a ff ff ff    	jne    104f88 <default_check+0x24>
    }
    assert(total == nr_free_pages());
  10500e:	e8 0e dd ff ff       	call   102d21 <nr_free_pages>
  105013:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105016:	39 d0                	cmp    %edx,%eax
  105018:	74 24                	je     10503e <default_check+0xda>
  10501a:	c7 44 24 0c ce 70 10 	movl   $0x1070ce,0xc(%esp)
  105021:	00 
  105022:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105029:	00 
  10502a:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  105031:	00 
  105032:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  105039:	e8 e8 b3 ff ff       	call   100426 <__panic>

    basic_check();
  10503e:	e8 df f9 ff ff       	call   104a22 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  105043:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10504a:	e8 5f dc ff ff       	call   102cae <alloc_pages>
  10504f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  105052:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105056:	75 24                	jne    10507c <default_check+0x118>
  105058:	c7 44 24 0c e7 70 10 	movl   $0x1070e7,0xc(%esp)
  10505f:	00 
  105060:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105067:	00 
  105068:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  10506f:	00 
  105070:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  105077:	e8 aa b3 ff ff       	call   100426 <__panic>
    assert(!PageProperty(p0));
  10507c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10507f:	83 c0 04             	add    $0x4,%eax
  105082:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  105089:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10508c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10508f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  105092:	0f a3 10             	bt     %edx,(%eax)
  105095:	19 c0                	sbb    %eax,%eax
  105097:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10509a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10509e:	0f 95 c0             	setne  %al
  1050a1:	0f b6 c0             	movzbl %al,%eax
  1050a4:	85 c0                	test   %eax,%eax
  1050a6:	74 24                	je     1050cc <default_check+0x168>
  1050a8:	c7 44 24 0c f2 70 10 	movl   $0x1070f2,0xc(%esp)
  1050af:	00 
  1050b0:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  1050b7:	00 
  1050b8:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1050bf:	00 
  1050c0:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  1050c7:	e8 5a b3 ff ff       	call   100426 <__panic>

    list_entry_t free_list_store = free_list;
  1050cc:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  1050d1:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  1050d7:	89 45 80             	mov    %eax,-0x80(%ebp)
  1050da:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1050dd:	c7 45 b0 1c cf 11 00 	movl   $0x11cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1050e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1050e7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1050ea:	89 50 04             	mov    %edx,0x4(%eax)
  1050ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1050f0:	8b 50 04             	mov    0x4(%eax),%edx
  1050f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1050f6:	89 10                	mov    %edx,(%eax)
}
  1050f8:	90                   	nop
  1050f9:	c7 45 b4 1c cf 11 00 	movl   $0x11cf1c,-0x4c(%ebp)
    return list->next == list;
  105100:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105103:	8b 40 04             	mov    0x4(%eax),%eax
  105106:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  105109:	0f 94 c0             	sete   %al
  10510c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10510f:	85 c0                	test   %eax,%eax
  105111:	75 24                	jne    105137 <default_check+0x1d3>
  105113:	c7 44 24 0c 47 70 10 	movl   $0x107047,0xc(%esp)
  10511a:	00 
  10511b:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105122:	00 
  105123:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  10512a:	00 
  10512b:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  105132:	e8 ef b2 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  105137:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10513e:	e8 6b db ff ff       	call   102cae <alloc_pages>
  105143:	85 c0                	test   %eax,%eax
  105145:	74 24                	je     10516b <default_check+0x207>
  105147:	c7 44 24 0c 5e 70 10 	movl   $0x10705e,0xc(%esp)
  10514e:	00 
  10514f:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105156:	00 
  105157:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  10515e:	00 
  10515f:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  105166:	e8 bb b2 ff ff       	call   100426 <__panic>

    unsigned int nr_free_store = nr_free;
  10516b:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  105170:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  105173:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  10517a:	00 00 00 

    free_pages(p0 + 2, 3);
  10517d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105180:	83 c0 28             	add    $0x28,%eax
  105183:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10518a:	00 
  10518b:	89 04 24             	mov    %eax,(%esp)
  10518e:	e8 57 db ff ff       	call   102cea <free_pages>
    assert(alloc_pages(4) == NULL);
  105193:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10519a:	e8 0f db ff ff       	call   102cae <alloc_pages>
  10519f:	85 c0                	test   %eax,%eax
  1051a1:	74 24                	je     1051c7 <default_check+0x263>
  1051a3:	c7 44 24 0c 04 71 10 	movl   $0x107104,0xc(%esp)
  1051aa:	00 
  1051ab:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  1051b2:	00 
  1051b3:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1051ba:	00 
  1051bb:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  1051c2:	e8 5f b2 ff ff       	call   100426 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1051c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051ca:	83 c0 28             	add    $0x28,%eax
  1051cd:	83 c0 04             	add    $0x4,%eax
  1051d0:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1051d7:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1051da:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1051dd:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1051e0:	0f a3 10             	bt     %edx,(%eax)
  1051e3:	19 c0                	sbb    %eax,%eax
  1051e5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1051e8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1051ec:	0f 95 c0             	setne  %al
  1051ef:	0f b6 c0             	movzbl %al,%eax
  1051f2:	85 c0                	test   %eax,%eax
  1051f4:	74 0e                	je     105204 <default_check+0x2a0>
  1051f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051f9:	83 c0 28             	add    $0x28,%eax
  1051fc:	8b 40 08             	mov    0x8(%eax),%eax
  1051ff:	83 f8 03             	cmp    $0x3,%eax
  105202:	74 24                	je     105228 <default_check+0x2c4>
  105204:	c7 44 24 0c 1c 71 10 	movl   $0x10711c,0xc(%esp)
  10520b:	00 
  10520c:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105213:	00 
  105214:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10521b:	00 
  10521c:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  105223:	e8 fe b1 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105228:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10522f:	e8 7a da ff ff       	call   102cae <alloc_pages>
  105234:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105237:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10523b:	75 24                	jne    105261 <default_check+0x2fd>
  10523d:	c7 44 24 0c 48 71 10 	movl   $0x107148,0xc(%esp)
  105244:	00 
  105245:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  10524c:	00 
  10524d:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  105254:	00 
  105255:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  10525c:	e8 c5 b1 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  105261:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105268:	e8 41 da ff ff       	call   102cae <alloc_pages>
  10526d:	85 c0                	test   %eax,%eax
  10526f:	74 24                	je     105295 <default_check+0x331>
  105271:	c7 44 24 0c 5e 70 10 	movl   $0x10705e,0xc(%esp)
  105278:	00 
  105279:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105280:	00 
  105281:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  105288:	00 
  105289:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  105290:	e8 91 b1 ff ff       	call   100426 <__panic>
    assert(p0 + 2 == p1);
  105295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105298:	83 c0 28             	add    $0x28,%eax
  10529b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10529e:	74 24                	je     1052c4 <default_check+0x360>
  1052a0:	c7 44 24 0c 66 71 10 	movl   $0x107166,0xc(%esp)
  1052a7:	00 
  1052a8:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  1052af:	00 
  1052b0:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  1052b7:	00 
  1052b8:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  1052bf:	e8 62 b1 ff ff       	call   100426 <__panic>

    p2 = p0 + 1;
  1052c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052c7:	83 c0 14             	add    $0x14,%eax
  1052ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1052cd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1052d4:	00 
  1052d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052d8:	89 04 24             	mov    %eax,(%esp)
  1052db:	e8 0a da ff ff       	call   102cea <free_pages>
    free_pages(p1, 3);
  1052e0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1052e7:	00 
  1052e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052eb:	89 04 24             	mov    %eax,(%esp)
  1052ee:	e8 f7 d9 ff ff       	call   102cea <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1052f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052f6:	83 c0 04             	add    $0x4,%eax
  1052f9:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  105300:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105303:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105306:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105309:	0f a3 10             	bt     %edx,(%eax)
  10530c:	19 c0                	sbb    %eax,%eax
  10530e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  105311:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105315:	0f 95 c0             	setne  %al
  105318:	0f b6 c0             	movzbl %al,%eax
  10531b:	85 c0                	test   %eax,%eax
  10531d:	74 0b                	je     10532a <default_check+0x3c6>
  10531f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105322:	8b 40 08             	mov    0x8(%eax),%eax
  105325:	83 f8 01             	cmp    $0x1,%eax
  105328:	74 24                	je     10534e <default_check+0x3ea>
  10532a:	c7 44 24 0c 74 71 10 	movl   $0x107174,0xc(%esp)
  105331:	00 
  105332:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105339:	00 
  10533a:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  105341:	00 
  105342:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  105349:	e8 d8 b0 ff ff       	call   100426 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10534e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105351:	83 c0 04             	add    $0x4,%eax
  105354:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10535b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10535e:	8b 45 90             	mov    -0x70(%ebp),%eax
  105361:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105364:	0f a3 10             	bt     %edx,(%eax)
  105367:	19 c0                	sbb    %eax,%eax
  105369:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10536c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105370:	0f 95 c0             	setne  %al
  105373:	0f b6 c0             	movzbl %al,%eax
  105376:	85 c0                	test   %eax,%eax
  105378:	74 0b                	je     105385 <default_check+0x421>
  10537a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10537d:	8b 40 08             	mov    0x8(%eax),%eax
  105380:	83 f8 03             	cmp    $0x3,%eax
  105383:	74 24                	je     1053a9 <default_check+0x445>
  105385:	c7 44 24 0c 9c 71 10 	movl   $0x10719c,0xc(%esp)
  10538c:	00 
  10538d:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105394:	00 
  105395:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  10539c:	00 
  10539d:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  1053a4:	e8 7d b0 ff ff       	call   100426 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1053a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1053b0:	e8 f9 d8 ff ff       	call   102cae <alloc_pages>
  1053b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053bb:	83 e8 14             	sub    $0x14,%eax
  1053be:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1053c1:	74 24                	je     1053e7 <default_check+0x483>
  1053c3:	c7 44 24 0c c2 71 10 	movl   $0x1071c2,0xc(%esp)
  1053ca:	00 
  1053cb:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  1053d2:	00 
  1053d3:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  1053da:	00 
  1053db:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  1053e2:	e8 3f b0 ff ff       	call   100426 <__panic>
    free_page(p0);
  1053e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053ee:	00 
  1053ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053f2:	89 04 24             	mov    %eax,(%esp)
  1053f5:	e8 f0 d8 ff ff       	call   102cea <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1053fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105401:	e8 a8 d8 ff ff       	call   102cae <alloc_pages>
  105406:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105409:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10540c:	83 c0 14             	add    $0x14,%eax
  10540f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105412:	74 24                	je     105438 <default_check+0x4d4>
  105414:	c7 44 24 0c e0 71 10 	movl   $0x1071e0,0xc(%esp)
  10541b:	00 
  10541c:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105423:	00 
  105424:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  10542b:	00 
  10542c:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  105433:	e8 ee af ff ff       	call   100426 <__panic>

    free_pages(p0, 2);
  105438:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10543f:	00 
  105440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105443:	89 04 24             	mov    %eax,(%esp)
  105446:	e8 9f d8 ff ff       	call   102cea <free_pages>
    free_page(p2);
  10544b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105452:	00 
  105453:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105456:	89 04 24             	mov    %eax,(%esp)
  105459:	e8 8c d8 ff ff       	call   102cea <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10545e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105465:	e8 44 d8 ff ff       	call   102cae <alloc_pages>
  10546a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10546d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105471:	75 24                	jne    105497 <default_check+0x533>
  105473:	c7 44 24 0c 00 72 10 	movl   $0x107200,0xc(%esp)
  10547a:	00 
  10547b:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105482:	00 
  105483:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  10548a:	00 
  10548b:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  105492:	e8 8f af ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  105497:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10549e:	e8 0b d8 ff ff       	call   102cae <alloc_pages>
  1054a3:	85 c0                	test   %eax,%eax
  1054a5:	74 24                	je     1054cb <default_check+0x567>
  1054a7:	c7 44 24 0c 5e 70 10 	movl   $0x10705e,0xc(%esp)
  1054ae:	00 
  1054af:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  1054b6:	00 
  1054b7:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  1054be:	00 
  1054bf:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  1054c6:	e8 5b af ff ff       	call   100426 <__panic>

    assert(nr_free == 0);
  1054cb:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  1054d0:	85 c0                	test   %eax,%eax
  1054d2:	74 24                	je     1054f8 <default_check+0x594>
  1054d4:	c7 44 24 0c b1 70 10 	movl   $0x1070b1,0xc(%esp)
  1054db:	00 
  1054dc:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  1054e3:	00 
  1054e4:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  1054eb:	00 
  1054ec:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  1054f3:	e8 2e af ff ff       	call   100426 <__panic>
    nr_free = nr_free_store;
  1054f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054fb:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_list = free_list_store;
  105500:	8b 45 80             	mov    -0x80(%ebp),%eax
  105503:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105506:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  10550b:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    free_pages(p0, 5);
  105511:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105518:	00 
  105519:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10551c:	89 04 24             	mov    %eax,(%esp)
  10551f:	e8 c6 d7 ff ff       	call   102cea <free_pages>

    le = &free_list;
  105524:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10552b:	eb 1c                	jmp    105549 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
  10552d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105530:	83 e8 0c             	sub    $0xc,%eax
  105533:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  105536:	ff 4d f4             	decl   -0xc(%ebp)
  105539:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10553c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10553f:	8b 40 08             	mov    0x8(%eax),%eax
  105542:	29 c2                	sub    %eax,%edx
  105544:	89 d0                	mov    %edx,%eax
  105546:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105549:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10554c:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  10554f:	8b 45 88             	mov    -0x78(%ebp),%eax
  105552:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105555:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105558:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  10555f:	75 cc                	jne    10552d <default_check+0x5c9>
    }
    assert(count == 0);
  105561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105565:	74 24                	je     10558b <default_check+0x627>
  105567:	c7 44 24 0c 1e 72 10 	movl   $0x10721e,0xc(%esp)
  10556e:	00 
  10556f:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  105576:	00 
  105577:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  10557e:	00 
  10557f:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  105586:	e8 9b ae ff ff       	call   100426 <__panic>
    assert(total == 0);
  10558b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10558f:	74 24                	je     1055b5 <default_check+0x651>
  105591:	c7 44 24 0c 29 72 10 	movl   $0x107229,0xc(%esp)
  105598:	00 
  105599:	c7 44 24 08 be 6e 10 	movl   $0x106ebe,0x8(%esp)
  1055a0:	00 
  1055a1:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
  1055a8:	00 
  1055a9:	c7 04 24 d3 6e 10 00 	movl   $0x106ed3,(%esp)
  1055b0:	e8 71 ae ff ff       	call   100426 <__panic>
}
  1055b5:	90                   	nop
  1055b6:	c9                   	leave  
  1055b7:	c3                   	ret    

001055b8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1055b8:	f3 0f 1e fb          	endbr32 
  1055bc:	55                   	push   %ebp
  1055bd:	89 e5                	mov    %esp,%ebp
  1055bf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1055c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1055c9:	eb 03                	jmp    1055ce <strlen+0x16>
        cnt ++;
  1055cb:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1055ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d1:	8d 50 01             	lea    0x1(%eax),%edx
  1055d4:	89 55 08             	mov    %edx,0x8(%ebp)
  1055d7:	0f b6 00             	movzbl (%eax),%eax
  1055da:	84 c0                	test   %al,%al
  1055dc:	75 ed                	jne    1055cb <strlen+0x13>
    }
    return cnt;
  1055de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1055e1:	c9                   	leave  
  1055e2:	c3                   	ret    

001055e3 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1055e3:	f3 0f 1e fb          	endbr32 
  1055e7:	55                   	push   %ebp
  1055e8:	89 e5                	mov    %esp,%ebp
  1055ea:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1055ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1055f4:	eb 03                	jmp    1055f9 <strnlen+0x16>
        cnt ++;
  1055f6:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1055f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1055ff:	73 10                	jae    105611 <strnlen+0x2e>
  105601:	8b 45 08             	mov    0x8(%ebp),%eax
  105604:	8d 50 01             	lea    0x1(%eax),%edx
  105607:	89 55 08             	mov    %edx,0x8(%ebp)
  10560a:	0f b6 00             	movzbl (%eax),%eax
  10560d:	84 c0                	test   %al,%al
  10560f:	75 e5                	jne    1055f6 <strnlen+0x13>
    }
    return cnt;
  105611:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105614:	c9                   	leave  
  105615:	c3                   	ret    

00105616 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105616:	f3 0f 1e fb          	endbr32 
  10561a:	55                   	push   %ebp
  10561b:	89 e5                	mov    %esp,%ebp
  10561d:	57                   	push   %edi
  10561e:	56                   	push   %esi
  10561f:	83 ec 20             	sub    $0x20,%esp
  105622:	8b 45 08             	mov    0x8(%ebp),%eax
  105625:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105628:	8b 45 0c             	mov    0xc(%ebp),%eax
  10562b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10562e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105634:	89 d1                	mov    %edx,%ecx
  105636:	89 c2                	mov    %eax,%edx
  105638:	89 ce                	mov    %ecx,%esi
  10563a:	89 d7                	mov    %edx,%edi
  10563c:	ac                   	lods   %ds:(%esi),%al
  10563d:	aa                   	stos   %al,%es:(%edi)
  10563e:	84 c0                	test   %al,%al
  105640:	75 fa                	jne    10563c <strcpy+0x26>
  105642:	89 fa                	mov    %edi,%edx
  105644:	89 f1                	mov    %esi,%ecx
  105646:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105649:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10564c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  10564f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105652:	83 c4 20             	add    $0x20,%esp
  105655:	5e                   	pop    %esi
  105656:	5f                   	pop    %edi
  105657:	5d                   	pop    %ebp
  105658:	c3                   	ret    

00105659 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105659:	f3 0f 1e fb          	endbr32 
  10565d:	55                   	push   %ebp
  10565e:	89 e5                	mov    %esp,%ebp
  105660:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105663:	8b 45 08             	mov    0x8(%ebp),%eax
  105666:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105669:	eb 1e                	jmp    105689 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  10566b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10566e:	0f b6 10             	movzbl (%eax),%edx
  105671:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105674:	88 10                	mov    %dl,(%eax)
  105676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105679:	0f b6 00             	movzbl (%eax),%eax
  10567c:	84 c0                	test   %al,%al
  10567e:	74 03                	je     105683 <strncpy+0x2a>
            src ++;
  105680:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105683:	ff 45 fc             	incl   -0x4(%ebp)
  105686:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105689:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10568d:	75 dc                	jne    10566b <strncpy+0x12>
    }
    return dst;
  10568f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105692:	c9                   	leave  
  105693:	c3                   	ret    

00105694 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105694:	f3 0f 1e fb          	endbr32 
  105698:	55                   	push   %ebp
  105699:	89 e5                	mov    %esp,%ebp
  10569b:	57                   	push   %edi
  10569c:	56                   	push   %esi
  10569d:	83 ec 20             	sub    $0x20,%esp
  1056a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1056a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1056ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056b2:	89 d1                	mov    %edx,%ecx
  1056b4:	89 c2                	mov    %eax,%edx
  1056b6:	89 ce                	mov    %ecx,%esi
  1056b8:	89 d7                	mov    %edx,%edi
  1056ba:	ac                   	lods   %ds:(%esi),%al
  1056bb:	ae                   	scas   %es:(%edi),%al
  1056bc:	75 08                	jne    1056c6 <strcmp+0x32>
  1056be:	84 c0                	test   %al,%al
  1056c0:	75 f8                	jne    1056ba <strcmp+0x26>
  1056c2:	31 c0                	xor    %eax,%eax
  1056c4:	eb 04                	jmp    1056ca <strcmp+0x36>
  1056c6:	19 c0                	sbb    %eax,%eax
  1056c8:	0c 01                	or     $0x1,%al
  1056ca:	89 fa                	mov    %edi,%edx
  1056cc:	89 f1                	mov    %esi,%ecx
  1056ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1056d1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1056d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1056d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1056da:	83 c4 20             	add    $0x20,%esp
  1056dd:	5e                   	pop    %esi
  1056de:	5f                   	pop    %edi
  1056df:	5d                   	pop    %ebp
  1056e0:	c3                   	ret    

001056e1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1056e1:	f3 0f 1e fb          	endbr32 
  1056e5:	55                   	push   %ebp
  1056e6:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1056e8:	eb 09                	jmp    1056f3 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  1056ea:	ff 4d 10             	decl   0x10(%ebp)
  1056ed:	ff 45 08             	incl   0x8(%ebp)
  1056f0:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1056f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1056f7:	74 1a                	je     105713 <strncmp+0x32>
  1056f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1056fc:	0f b6 00             	movzbl (%eax),%eax
  1056ff:	84 c0                	test   %al,%al
  105701:	74 10                	je     105713 <strncmp+0x32>
  105703:	8b 45 08             	mov    0x8(%ebp),%eax
  105706:	0f b6 10             	movzbl (%eax),%edx
  105709:	8b 45 0c             	mov    0xc(%ebp),%eax
  10570c:	0f b6 00             	movzbl (%eax),%eax
  10570f:	38 c2                	cmp    %al,%dl
  105711:	74 d7                	je     1056ea <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105713:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105717:	74 18                	je     105731 <strncmp+0x50>
  105719:	8b 45 08             	mov    0x8(%ebp),%eax
  10571c:	0f b6 00             	movzbl (%eax),%eax
  10571f:	0f b6 d0             	movzbl %al,%edx
  105722:	8b 45 0c             	mov    0xc(%ebp),%eax
  105725:	0f b6 00             	movzbl (%eax),%eax
  105728:	0f b6 c0             	movzbl %al,%eax
  10572b:	29 c2                	sub    %eax,%edx
  10572d:	89 d0                	mov    %edx,%eax
  10572f:	eb 05                	jmp    105736 <strncmp+0x55>
  105731:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105736:	5d                   	pop    %ebp
  105737:	c3                   	ret    

00105738 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105738:	f3 0f 1e fb          	endbr32 
  10573c:	55                   	push   %ebp
  10573d:	89 e5                	mov    %esp,%ebp
  10573f:	83 ec 04             	sub    $0x4,%esp
  105742:	8b 45 0c             	mov    0xc(%ebp),%eax
  105745:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105748:	eb 13                	jmp    10575d <strchr+0x25>
        if (*s == c) {
  10574a:	8b 45 08             	mov    0x8(%ebp),%eax
  10574d:	0f b6 00             	movzbl (%eax),%eax
  105750:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105753:	75 05                	jne    10575a <strchr+0x22>
            return (char *)s;
  105755:	8b 45 08             	mov    0x8(%ebp),%eax
  105758:	eb 12                	jmp    10576c <strchr+0x34>
        }
        s ++;
  10575a:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10575d:	8b 45 08             	mov    0x8(%ebp),%eax
  105760:	0f b6 00             	movzbl (%eax),%eax
  105763:	84 c0                	test   %al,%al
  105765:	75 e3                	jne    10574a <strchr+0x12>
    }
    return NULL;
  105767:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10576c:	c9                   	leave  
  10576d:	c3                   	ret    

0010576e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10576e:	f3 0f 1e fb          	endbr32 
  105772:	55                   	push   %ebp
  105773:	89 e5                	mov    %esp,%ebp
  105775:	83 ec 04             	sub    $0x4,%esp
  105778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10577b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10577e:	eb 0e                	jmp    10578e <strfind+0x20>
        if (*s == c) {
  105780:	8b 45 08             	mov    0x8(%ebp),%eax
  105783:	0f b6 00             	movzbl (%eax),%eax
  105786:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105789:	74 0f                	je     10579a <strfind+0x2c>
            break;
        }
        s ++;
  10578b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10578e:	8b 45 08             	mov    0x8(%ebp),%eax
  105791:	0f b6 00             	movzbl (%eax),%eax
  105794:	84 c0                	test   %al,%al
  105796:	75 e8                	jne    105780 <strfind+0x12>
  105798:	eb 01                	jmp    10579b <strfind+0x2d>
            break;
  10579a:	90                   	nop
    }
    return (char *)s;
  10579b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10579e:	c9                   	leave  
  10579f:	c3                   	ret    

001057a0 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1057a0:	f3 0f 1e fb          	endbr32 
  1057a4:	55                   	push   %ebp
  1057a5:	89 e5                	mov    %esp,%ebp
  1057a7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1057aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1057b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1057b8:	eb 03                	jmp    1057bd <strtol+0x1d>
        s ++;
  1057ba:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1057bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c0:	0f b6 00             	movzbl (%eax),%eax
  1057c3:	3c 20                	cmp    $0x20,%al
  1057c5:	74 f3                	je     1057ba <strtol+0x1a>
  1057c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ca:	0f b6 00             	movzbl (%eax),%eax
  1057cd:	3c 09                	cmp    $0x9,%al
  1057cf:	74 e9                	je     1057ba <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  1057d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d4:	0f b6 00             	movzbl (%eax),%eax
  1057d7:	3c 2b                	cmp    $0x2b,%al
  1057d9:	75 05                	jne    1057e0 <strtol+0x40>
        s ++;
  1057db:	ff 45 08             	incl   0x8(%ebp)
  1057de:	eb 14                	jmp    1057f4 <strtol+0x54>
    }
    else if (*s == '-') {
  1057e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e3:	0f b6 00             	movzbl (%eax),%eax
  1057e6:	3c 2d                	cmp    $0x2d,%al
  1057e8:	75 0a                	jne    1057f4 <strtol+0x54>
        s ++, neg = 1;
  1057ea:	ff 45 08             	incl   0x8(%ebp)
  1057ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1057f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1057f8:	74 06                	je     105800 <strtol+0x60>
  1057fa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1057fe:	75 22                	jne    105822 <strtol+0x82>
  105800:	8b 45 08             	mov    0x8(%ebp),%eax
  105803:	0f b6 00             	movzbl (%eax),%eax
  105806:	3c 30                	cmp    $0x30,%al
  105808:	75 18                	jne    105822 <strtol+0x82>
  10580a:	8b 45 08             	mov    0x8(%ebp),%eax
  10580d:	40                   	inc    %eax
  10580e:	0f b6 00             	movzbl (%eax),%eax
  105811:	3c 78                	cmp    $0x78,%al
  105813:	75 0d                	jne    105822 <strtol+0x82>
        s += 2, base = 16;
  105815:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105819:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105820:	eb 29                	jmp    10584b <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  105822:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105826:	75 16                	jne    10583e <strtol+0x9e>
  105828:	8b 45 08             	mov    0x8(%ebp),%eax
  10582b:	0f b6 00             	movzbl (%eax),%eax
  10582e:	3c 30                	cmp    $0x30,%al
  105830:	75 0c                	jne    10583e <strtol+0x9e>
        s ++, base = 8;
  105832:	ff 45 08             	incl   0x8(%ebp)
  105835:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10583c:	eb 0d                	jmp    10584b <strtol+0xab>
    }
    else if (base == 0) {
  10583e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105842:	75 07                	jne    10584b <strtol+0xab>
        base = 10;
  105844:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10584b:	8b 45 08             	mov    0x8(%ebp),%eax
  10584e:	0f b6 00             	movzbl (%eax),%eax
  105851:	3c 2f                	cmp    $0x2f,%al
  105853:	7e 1b                	jle    105870 <strtol+0xd0>
  105855:	8b 45 08             	mov    0x8(%ebp),%eax
  105858:	0f b6 00             	movzbl (%eax),%eax
  10585b:	3c 39                	cmp    $0x39,%al
  10585d:	7f 11                	jg     105870 <strtol+0xd0>
            dig = *s - '0';
  10585f:	8b 45 08             	mov    0x8(%ebp),%eax
  105862:	0f b6 00             	movzbl (%eax),%eax
  105865:	0f be c0             	movsbl %al,%eax
  105868:	83 e8 30             	sub    $0x30,%eax
  10586b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10586e:	eb 48                	jmp    1058b8 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105870:	8b 45 08             	mov    0x8(%ebp),%eax
  105873:	0f b6 00             	movzbl (%eax),%eax
  105876:	3c 60                	cmp    $0x60,%al
  105878:	7e 1b                	jle    105895 <strtol+0xf5>
  10587a:	8b 45 08             	mov    0x8(%ebp),%eax
  10587d:	0f b6 00             	movzbl (%eax),%eax
  105880:	3c 7a                	cmp    $0x7a,%al
  105882:	7f 11                	jg     105895 <strtol+0xf5>
            dig = *s - 'a' + 10;
  105884:	8b 45 08             	mov    0x8(%ebp),%eax
  105887:	0f b6 00             	movzbl (%eax),%eax
  10588a:	0f be c0             	movsbl %al,%eax
  10588d:	83 e8 57             	sub    $0x57,%eax
  105890:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105893:	eb 23                	jmp    1058b8 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105895:	8b 45 08             	mov    0x8(%ebp),%eax
  105898:	0f b6 00             	movzbl (%eax),%eax
  10589b:	3c 40                	cmp    $0x40,%al
  10589d:	7e 3b                	jle    1058da <strtol+0x13a>
  10589f:	8b 45 08             	mov    0x8(%ebp),%eax
  1058a2:	0f b6 00             	movzbl (%eax),%eax
  1058a5:	3c 5a                	cmp    $0x5a,%al
  1058a7:	7f 31                	jg     1058da <strtol+0x13a>
            dig = *s - 'A' + 10;
  1058a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ac:	0f b6 00             	movzbl (%eax),%eax
  1058af:	0f be c0             	movsbl %al,%eax
  1058b2:	83 e8 37             	sub    $0x37,%eax
  1058b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1058b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  1058be:	7d 19                	jge    1058d9 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  1058c0:	ff 45 08             	incl   0x8(%ebp)
  1058c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1058c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  1058ca:	89 c2                	mov    %eax,%edx
  1058cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058cf:	01 d0                	add    %edx,%eax
  1058d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1058d4:	e9 72 ff ff ff       	jmp    10584b <strtol+0xab>
            break;
  1058d9:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1058da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1058de:	74 08                	je     1058e8 <strtol+0x148>
        *endptr = (char *) s;
  1058e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1058e6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1058e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1058ec:	74 07                	je     1058f5 <strtol+0x155>
  1058ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1058f1:	f7 d8                	neg    %eax
  1058f3:	eb 03                	jmp    1058f8 <strtol+0x158>
  1058f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1058f8:	c9                   	leave  
  1058f9:	c3                   	ret    

001058fa <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1058fa:	f3 0f 1e fb          	endbr32 
  1058fe:	55                   	push   %ebp
  1058ff:	89 e5                	mov    %esp,%ebp
  105901:	57                   	push   %edi
  105902:	83 ec 24             	sub    $0x24,%esp
  105905:	8b 45 0c             	mov    0xc(%ebp),%eax
  105908:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10590b:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  10590f:	8b 45 08             	mov    0x8(%ebp),%eax
  105912:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105915:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105918:	8b 45 10             	mov    0x10(%ebp),%eax
  10591b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10591e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105921:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105925:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105928:	89 d7                	mov    %edx,%edi
  10592a:	f3 aa                	rep stos %al,%es:(%edi)
  10592c:	89 fa                	mov    %edi,%edx
  10592e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105931:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105934:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105937:	83 c4 24             	add    $0x24,%esp
  10593a:	5f                   	pop    %edi
  10593b:	5d                   	pop    %ebp
  10593c:	c3                   	ret    

0010593d <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10593d:	f3 0f 1e fb          	endbr32 
  105941:	55                   	push   %ebp
  105942:	89 e5                	mov    %esp,%ebp
  105944:	57                   	push   %edi
  105945:	56                   	push   %esi
  105946:	53                   	push   %ebx
  105947:	83 ec 30             	sub    $0x30,%esp
  10594a:	8b 45 08             	mov    0x8(%ebp),%eax
  10594d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105950:	8b 45 0c             	mov    0xc(%ebp),%eax
  105953:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105956:	8b 45 10             	mov    0x10(%ebp),%eax
  105959:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10595c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10595f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105962:	73 42                	jae    1059a6 <memmove+0x69>
  105964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105967:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10596a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10596d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105973:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105976:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105979:	c1 e8 02             	shr    $0x2,%eax
  10597c:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10597e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105981:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105984:	89 d7                	mov    %edx,%edi
  105986:	89 c6                	mov    %eax,%esi
  105988:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10598a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10598d:	83 e1 03             	and    $0x3,%ecx
  105990:	74 02                	je     105994 <memmove+0x57>
  105992:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105994:	89 f0                	mov    %esi,%eax
  105996:	89 fa                	mov    %edi,%edx
  105998:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10599b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10599e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1059a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  1059a4:	eb 36                	jmp    1059dc <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1059a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1059a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1059ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059af:	01 c2                	add    %eax,%edx
  1059b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1059b4:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1059b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059ba:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1059bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1059c0:	89 c1                	mov    %eax,%ecx
  1059c2:	89 d8                	mov    %ebx,%eax
  1059c4:	89 d6                	mov    %edx,%esi
  1059c6:	89 c7                	mov    %eax,%edi
  1059c8:	fd                   	std    
  1059c9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1059cb:	fc                   	cld    
  1059cc:	89 f8                	mov    %edi,%eax
  1059ce:	89 f2                	mov    %esi,%edx
  1059d0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1059d3:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1059d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1059d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1059dc:	83 c4 30             	add    $0x30,%esp
  1059df:	5b                   	pop    %ebx
  1059e0:	5e                   	pop    %esi
  1059e1:	5f                   	pop    %edi
  1059e2:	5d                   	pop    %ebp
  1059e3:	c3                   	ret    

001059e4 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1059e4:	f3 0f 1e fb          	endbr32 
  1059e8:	55                   	push   %ebp
  1059e9:	89 e5                	mov    %esp,%ebp
  1059eb:	57                   	push   %edi
  1059ec:	56                   	push   %esi
  1059ed:	83 ec 20             	sub    $0x20,%esp
  1059f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1059ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a05:	c1 e8 02             	shr    $0x2,%eax
  105a08:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a10:	89 d7                	mov    %edx,%edi
  105a12:	89 c6                	mov    %eax,%esi
  105a14:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105a16:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105a19:	83 e1 03             	and    $0x3,%ecx
  105a1c:	74 02                	je     105a20 <memcpy+0x3c>
  105a1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105a20:	89 f0                	mov    %esi,%eax
  105a22:	89 fa                	mov    %edi,%edx
  105a24:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105a27:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105a30:	83 c4 20             	add    $0x20,%esp
  105a33:	5e                   	pop    %esi
  105a34:	5f                   	pop    %edi
  105a35:	5d                   	pop    %ebp
  105a36:	c3                   	ret    

00105a37 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105a37:	f3 0f 1e fb          	endbr32 
  105a3b:	55                   	push   %ebp
  105a3c:	89 e5                	mov    %esp,%ebp
  105a3e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105a41:	8b 45 08             	mov    0x8(%ebp),%eax
  105a44:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105a4d:	eb 2e                	jmp    105a7d <memcmp+0x46>
        if (*s1 != *s2) {
  105a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a52:	0f b6 10             	movzbl (%eax),%edx
  105a55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a58:	0f b6 00             	movzbl (%eax),%eax
  105a5b:	38 c2                	cmp    %al,%dl
  105a5d:	74 18                	je     105a77 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a62:	0f b6 00             	movzbl (%eax),%eax
  105a65:	0f b6 d0             	movzbl %al,%edx
  105a68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a6b:	0f b6 00             	movzbl (%eax),%eax
  105a6e:	0f b6 c0             	movzbl %al,%eax
  105a71:	29 c2                	sub    %eax,%edx
  105a73:	89 d0                	mov    %edx,%eax
  105a75:	eb 18                	jmp    105a8f <memcmp+0x58>
        }
        s1 ++, s2 ++;
  105a77:	ff 45 fc             	incl   -0x4(%ebp)
  105a7a:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  105a80:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a83:	89 55 10             	mov    %edx,0x10(%ebp)
  105a86:	85 c0                	test   %eax,%eax
  105a88:	75 c5                	jne    105a4f <memcmp+0x18>
    }
    return 0;
  105a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a8f:	c9                   	leave  
  105a90:	c3                   	ret    

00105a91 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105a91:	f3 0f 1e fb          	endbr32 
  105a95:	55                   	push   %ebp
  105a96:	89 e5                	mov    %esp,%ebp
  105a98:	83 ec 58             	sub    $0x58,%esp
  105a9b:	8b 45 10             	mov    0x10(%ebp),%eax
  105a9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  105aa4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105aa7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105aaa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105aad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105ab0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105ab3:	8b 45 18             	mov    0x18(%ebp),%eax
  105ab6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105abc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105abf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105ac2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105acb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105acf:	74 1c                	je     105aed <printnum+0x5c>
  105ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ad4:	ba 00 00 00 00       	mov    $0x0,%edx
  105ad9:	f7 75 e4             	divl   -0x1c(%ebp)
  105adc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ae2:	ba 00 00 00 00       	mov    $0x0,%edx
  105ae7:	f7 75 e4             	divl   -0x1c(%ebp)
  105aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105af3:	f7 75 e4             	divl   -0x1c(%ebp)
  105af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105af9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105afc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105aff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b02:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105b05:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105b08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105b0b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105b0e:	8b 45 18             	mov    0x18(%ebp),%eax
  105b11:	ba 00 00 00 00       	mov    $0x0,%edx
  105b16:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105b19:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105b1c:	19 d1                	sbb    %edx,%ecx
  105b1e:	72 4c                	jb     105b6c <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  105b20:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105b23:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b26:	8b 45 20             	mov    0x20(%ebp),%eax
  105b29:	89 44 24 18          	mov    %eax,0x18(%esp)
  105b2d:	89 54 24 14          	mov    %edx,0x14(%esp)
  105b31:	8b 45 18             	mov    0x18(%ebp),%eax
  105b34:	89 44 24 10          	mov    %eax,0x10(%esp)
  105b38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b42:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b50:	89 04 24             	mov    %eax,(%esp)
  105b53:	e8 39 ff ff ff       	call   105a91 <printnum>
  105b58:	eb 1b                	jmp    105b75 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b61:	8b 45 20             	mov    0x20(%ebp),%eax
  105b64:	89 04 24             	mov    %eax,(%esp)
  105b67:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6a:	ff d0                	call   *%eax
        while (-- width > 0)
  105b6c:	ff 4d 1c             	decl   0x1c(%ebp)
  105b6f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105b73:	7f e5                	jg     105b5a <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105b75:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105b78:	05 e4 72 10 00       	add    $0x1072e4,%eax
  105b7d:	0f b6 00             	movzbl (%eax),%eax
  105b80:	0f be c0             	movsbl %al,%eax
  105b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  105b86:	89 54 24 04          	mov    %edx,0x4(%esp)
  105b8a:	89 04 24             	mov    %eax,(%esp)
  105b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b90:	ff d0                	call   *%eax
}
  105b92:	90                   	nop
  105b93:	c9                   	leave  
  105b94:	c3                   	ret    

00105b95 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105b95:	f3 0f 1e fb          	endbr32 
  105b99:	55                   	push   %ebp
  105b9a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105b9c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105ba0:	7e 14                	jle    105bb6 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  105ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba5:	8b 00                	mov    (%eax),%eax
  105ba7:	8d 48 08             	lea    0x8(%eax),%ecx
  105baa:	8b 55 08             	mov    0x8(%ebp),%edx
  105bad:	89 0a                	mov    %ecx,(%edx)
  105baf:	8b 50 04             	mov    0x4(%eax),%edx
  105bb2:	8b 00                	mov    (%eax),%eax
  105bb4:	eb 30                	jmp    105be6 <getuint+0x51>
    }
    else if (lflag) {
  105bb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105bba:	74 16                	je     105bd2 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbf:	8b 00                	mov    (%eax),%eax
  105bc1:	8d 48 04             	lea    0x4(%eax),%ecx
  105bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  105bc7:	89 0a                	mov    %ecx,(%edx)
  105bc9:	8b 00                	mov    (%eax),%eax
  105bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  105bd0:	eb 14                	jmp    105be6 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  105bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd5:	8b 00                	mov    (%eax),%eax
  105bd7:	8d 48 04             	lea    0x4(%eax),%ecx
  105bda:	8b 55 08             	mov    0x8(%ebp),%edx
  105bdd:	89 0a                	mov    %ecx,(%edx)
  105bdf:	8b 00                	mov    (%eax),%eax
  105be1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105be6:	5d                   	pop    %ebp
  105be7:	c3                   	ret    

00105be8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105be8:	f3 0f 1e fb          	endbr32 
  105bec:	55                   	push   %ebp
  105bed:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105bef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105bf3:	7e 14                	jle    105c09 <getint+0x21>
        return va_arg(*ap, long long);
  105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf8:	8b 00                	mov    (%eax),%eax
  105bfa:	8d 48 08             	lea    0x8(%eax),%ecx
  105bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  105c00:	89 0a                	mov    %ecx,(%edx)
  105c02:	8b 50 04             	mov    0x4(%eax),%edx
  105c05:	8b 00                	mov    (%eax),%eax
  105c07:	eb 28                	jmp    105c31 <getint+0x49>
    }
    else if (lflag) {
  105c09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105c0d:	74 12                	je     105c21 <getint+0x39>
        return va_arg(*ap, long);
  105c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c12:	8b 00                	mov    (%eax),%eax
  105c14:	8d 48 04             	lea    0x4(%eax),%ecx
  105c17:	8b 55 08             	mov    0x8(%ebp),%edx
  105c1a:	89 0a                	mov    %ecx,(%edx)
  105c1c:	8b 00                	mov    (%eax),%eax
  105c1e:	99                   	cltd   
  105c1f:	eb 10                	jmp    105c31 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  105c21:	8b 45 08             	mov    0x8(%ebp),%eax
  105c24:	8b 00                	mov    (%eax),%eax
  105c26:	8d 48 04             	lea    0x4(%eax),%ecx
  105c29:	8b 55 08             	mov    0x8(%ebp),%edx
  105c2c:	89 0a                	mov    %ecx,(%edx)
  105c2e:	8b 00                	mov    (%eax),%eax
  105c30:	99                   	cltd   
    }
}
  105c31:	5d                   	pop    %ebp
  105c32:	c3                   	ret    

00105c33 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105c33:	f3 0f 1e fb          	endbr32 
  105c37:	55                   	push   %ebp
  105c38:	89 e5                	mov    %esp,%ebp
  105c3a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105c3d:	8d 45 14             	lea    0x14(%ebp),%eax
  105c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c46:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  105c4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c54:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c58:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5b:	89 04 24             	mov    %eax,(%esp)
  105c5e:	e8 03 00 00 00       	call   105c66 <vprintfmt>
    va_end(ap);
}
  105c63:	90                   	nop
  105c64:	c9                   	leave  
  105c65:	c3                   	ret    

00105c66 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105c66:	f3 0f 1e fb          	endbr32 
  105c6a:	55                   	push   %ebp
  105c6b:	89 e5                	mov    %esp,%ebp
  105c6d:	56                   	push   %esi
  105c6e:	53                   	push   %ebx
  105c6f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c72:	eb 17                	jmp    105c8b <vprintfmt+0x25>
            if (ch == '\0') {
  105c74:	85 db                	test   %ebx,%ebx
  105c76:	0f 84 c0 03 00 00    	je     10603c <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  105c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c83:	89 1c 24             	mov    %ebx,(%esp)
  105c86:	8b 45 08             	mov    0x8(%ebp),%eax
  105c89:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  105c8e:	8d 50 01             	lea    0x1(%eax),%edx
  105c91:	89 55 10             	mov    %edx,0x10(%ebp)
  105c94:	0f b6 00             	movzbl (%eax),%eax
  105c97:	0f b6 d8             	movzbl %al,%ebx
  105c9a:	83 fb 25             	cmp    $0x25,%ebx
  105c9d:	75 d5                	jne    105c74 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105c9f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105ca3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105caa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105cad:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105cb0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105cb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105cba:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  105cc0:	8d 50 01             	lea    0x1(%eax),%edx
  105cc3:	89 55 10             	mov    %edx,0x10(%ebp)
  105cc6:	0f b6 00             	movzbl (%eax),%eax
  105cc9:	0f b6 d8             	movzbl %al,%ebx
  105ccc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105ccf:	83 f8 55             	cmp    $0x55,%eax
  105cd2:	0f 87 38 03 00 00    	ja     106010 <vprintfmt+0x3aa>
  105cd8:	8b 04 85 08 73 10 00 	mov    0x107308(,%eax,4),%eax
  105cdf:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105ce2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105ce6:	eb d5                	jmp    105cbd <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105ce8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105cec:	eb cf                	jmp    105cbd <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105cee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105cf5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105cf8:	89 d0                	mov    %edx,%eax
  105cfa:	c1 e0 02             	shl    $0x2,%eax
  105cfd:	01 d0                	add    %edx,%eax
  105cff:	01 c0                	add    %eax,%eax
  105d01:	01 d8                	add    %ebx,%eax
  105d03:	83 e8 30             	sub    $0x30,%eax
  105d06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105d09:	8b 45 10             	mov    0x10(%ebp),%eax
  105d0c:	0f b6 00             	movzbl (%eax),%eax
  105d0f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105d12:	83 fb 2f             	cmp    $0x2f,%ebx
  105d15:	7e 38                	jle    105d4f <vprintfmt+0xe9>
  105d17:	83 fb 39             	cmp    $0x39,%ebx
  105d1a:	7f 33                	jg     105d4f <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  105d1c:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105d1f:	eb d4                	jmp    105cf5 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105d21:	8b 45 14             	mov    0x14(%ebp),%eax
  105d24:	8d 50 04             	lea    0x4(%eax),%edx
  105d27:	89 55 14             	mov    %edx,0x14(%ebp)
  105d2a:	8b 00                	mov    (%eax),%eax
  105d2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105d2f:	eb 1f                	jmp    105d50 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  105d31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105d35:	79 86                	jns    105cbd <vprintfmt+0x57>
                width = 0;
  105d37:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105d3e:	e9 7a ff ff ff       	jmp    105cbd <vprintfmt+0x57>

        case '#':
            altflag = 1;
  105d43:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105d4a:	e9 6e ff ff ff       	jmp    105cbd <vprintfmt+0x57>
            goto process_precision;
  105d4f:	90                   	nop

        process_precision:
            if (width < 0)
  105d50:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105d54:	0f 89 63 ff ff ff    	jns    105cbd <vprintfmt+0x57>
                width = precision, precision = -1;
  105d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105d60:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105d67:	e9 51 ff ff ff       	jmp    105cbd <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105d6c:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105d6f:	e9 49 ff ff ff       	jmp    105cbd <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105d74:	8b 45 14             	mov    0x14(%ebp),%eax
  105d77:	8d 50 04             	lea    0x4(%eax),%edx
  105d7a:	89 55 14             	mov    %edx,0x14(%ebp)
  105d7d:	8b 00                	mov    (%eax),%eax
  105d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105d82:	89 54 24 04          	mov    %edx,0x4(%esp)
  105d86:	89 04 24             	mov    %eax,(%esp)
  105d89:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8c:	ff d0                	call   *%eax
            break;
  105d8e:	e9 a4 02 00 00       	jmp    106037 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105d93:	8b 45 14             	mov    0x14(%ebp),%eax
  105d96:	8d 50 04             	lea    0x4(%eax),%edx
  105d99:	89 55 14             	mov    %edx,0x14(%ebp)
  105d9c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105d9e:	85 db                	test   %ebx,%ebx
  105da0:	79 02                	jns    105da4 <vprintfmt+0x13e>
                err = -err;
  105da2:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105da4:	83 fb 06             	cmp    $0x6,%ebx
  105da7:	7f 0b                	jg     105db4 <vprintfmt+0x14e>
  105da9:	8b 34 9d c8 72 10 00 	mov    0x1072c8(,%ebx,4),%esi
  105db0:	85 f6                	test   %esi,%esi
  105db2:	75 23                	jne    105dd7 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  105db4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105db8:	c7 44 24 08 f5 72 10 	movl   $0x1072f5,0x8(%esp)
  105dbf:	00 
  105dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  105dca:	89 04 24             	mov    %eax,(%esp)
  105dcd:	e8 61 fe ff ff       	call   105c33 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105dd2:	e9 60 02 00 00       	jmp    106037 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  105dd7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105ddb:	c7 44 24 08 fe 72 10 	movl   $0x1072fe,0x8(%esp)
  105de2:	00 
  105de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105de6:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dea:	8b 45 08             	mov    0x8(%ebp),%eax
  105ded:	89 04 24             	mov    %eax,(%esp)
  105df0:	e8 3e fe ff ff       	call   105c33 <printfmt>
            break;
  105df5:	e9 3d 02 00 00       	jmp    106037 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105dfa:	8b 45 14             	mov    0x14(%ebp),%eax
  105dfd:	8d 50 04             	lea    0x4(%eax),%edx
  105e00:	89 55 14             	mov    %edx,0x14(%ebp)
  105e03:	8b 30                	mov    (%eax),%esi
  105e05:	85 f6                	test   %esi,%esi
  105e07:	75 05                	jne    105e0e <vprintfmt+0x1a8>
                p = "(null)";
  105e09:	be 01 73 10 00       	mov    $0x107301,%esi
            }
            if (width > 0 && padc != '-') {
  105e0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e12:	7e 76                	jle    105e8a <vprintfmt+0x224>
  105e14:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105e18:	74 70                	je     105e8a <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e21:	89 34 24             	mov    %esi,(%esp)
  105e24:	e8 ba f7 ff ff       	call   1055e3 <strnlen>
  105e29:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105e2c:	29 c2                	sub    %eax,%edx
  105e2e:	89 d0                	mov    %edx,%eax
  105e30:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105e33:	eb 16                	jmp    105e4b <vprintfmt+0x1e5>
                    putch(padc, putdat);
  105e35:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105e39:	8b 55 0c             	mov    0xc(%ebp),%edx
  105e3c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105e40:	89 04 24             	mov    %eax,(%esp)
  105e43:	8b 45 08             	mov    0x8(%ebp),%eax
  105e46:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105e48:	ff 4d e8             	decl   -0x18(%ebp)
  105e4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e4f:	7f e4                	jg     105e35 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105e51:	eb 37                	jmp    105e8a <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  105e53:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105e57:	74 1f                	je     105e78 <vprintfmt+0x212>
  105e59:	83 fb 1f             	cmp    $0x1f,%ebx
  105e5c:	7e 05                	jle    105e63 <vprintfmt+0x1fd>
  105e5e:	83 fb 7e             	cmp    $0x7e,%ebx
  105e61:	7e 15                	jle    105e78 <vprintfmt+0x212>
                    putch('?', putdat);
  105e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e66:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e6a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105e71:	8b 45 08             	mov    0x8(%ebp),%eax
  105e74:	ff d0                	call   *%eax
  105e76:	eb 0f                	jmp    105e87 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  105e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e7f:	89 1c 24             	mov    %ebx,(%esp)
  105e82:	8b 45 08             	mov    0x8(%ebp),%eax
  105e85:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105e87:	ff 4d e8             	decl   -0x18(%ebp)
  105e8a:	89 f0                	mov    %esi,%eax
  105e8c:	8d 70 01             	lea    0x1(%eax),%esi
  105e8f:	0f b6 00             	movzbl (%eax),%eax
  105e92:	0f be d8             	movsbl %al,%ebx
  105e95:	85 db                	test   %ebx,%ebx
  105e97:	74 27                	je     105ec0 <vprintfmt+0x25a>
  105e99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105e9d:	78 b4                	js     105e53 <vprintfmt+0x1ed>
  105e9f:	ff 4d e4             	decl   -0x1c(%ebp)
  105ea2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105ea6:	79 ab                	jns    105e53 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  105ea8:	eb 16                	jmp    105ec0 <vprintfmt+0x25a>
                putch(' ', putdat);
  105eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ead:	89 44 24 04          	mov    %eax,0x4(%esp)
  105eb1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  105ebb:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105ebd:	ff 4d e8             	decl   -0x18(%ebp)
  105ec0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105ec4:	7f e4                	jg     105eaa <vprintfmt+0x244>
            }
            break;
  105ec6:	e9 6c 01 00 00       	jmp    106037 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105ecb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ece:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ed2:	8d 45 14             	lea    0x14(%ebp),%eax
  105ed5:	89 04 24             	mov    %eax,(%esp)
  105ed8:	e8 0b fd ff ff       	call   105be8 <getint>
  105edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ee0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ee9:	85 d2                	test   %edx,%edx
  105eeb:	79 26                	jns    105f13 <vprintfmt+0x2ad>
                putch('-', putdat);
  105eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ef0:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ef4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105efb:	8b 45 08             	mov    0x8(%ebp),%eax
  105efe:	ff d0                	call   *%eax
                num = -(long long)num;
  105f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f06:	f7 d8                	neg    %eax
  105f08:	83 d2 00             	adc    $0x0,%edx
  105f0b:	f7 da                	neg    %edx
  105f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f10:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105f13:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105f1a:	e9 a8 00 00 00       	jmp    105fc7 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105f1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f22:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f26:	8d 45 14             	lea    0x14(%ebp),%eax
  105f29:	89 04 24             	mov    %eax,(%esp)
  105f2c:	e8 64 fc ff ff       	call   105b95 <getuint>
  105f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f34:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105f37:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105f3e:	e9 84 00 00 00       	jmp    105fc7 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f46:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f4a:	8d 45 14             	lea    0x14(%ebp),%eax
  105f4d:	89 04 24             	mov    %eax,(%esp)
  105f50:	e8 40 fc ff ff       	call   105b95 <getuint>
  105f55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f58:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105f5b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105f62:	eb 63                	jmp    105fc7 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  105f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f67:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f6b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105f72:	8b 45 08             	mov    0x8(%ebp),%eax
  105f75:	ff d0                	call   *%eax
            putch('x', putdat);
  105f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f7e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105f85:	8b 45 08             	mov    0x8(%ebp),%eax
  105f88:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105f8a:	8b 45 14             	mov    0x14(%ebp),%eax
  105f8d:	8d 50 04             	lea    0x4(%eax),%edx
  105f90:	89 55 14             	mov    %edx,0x14(%ebp)
  105f93:	8b 00                	mov    (%eax),%eax
  105f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105f9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105fa6:	eb 1f                	jmp    105fc7 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105fab:	89 44 24 04          	mov    %eax,0x4(%esp)
  105faf:	8d 45 14             	lea    0x14(%ebp),%eax
  105fb2:	89 04 24             	mov    %eax,(%esp)
  105fb5:	e8 db fb ff ff       	call   105b95 <getuint>
  105fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105fc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105fc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105fce:	89 54 24 18          	mov    %edx,0x18(%esp)
  105fd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105fd5:	89 54 24 14          	mov    %edx,0x14(%esp)
  105fd9:	89 44 24 10          	mov    %eax,0x10(%esp)
  105fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fe0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105fe3:	89 44 24 08          	mov    %eax,0x8(%esp)
  105fe7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fee:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ff5:	89 04 24             	mov    %eax,(%esp)
  105ff8:	e8 94 fa ff ff       	call   105a91 <printnum>
            break;
  105ffd:	eb 38                	jmp    106037 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  106002:	89 44 24 04          	mov    %eax,0x4(%esp)
  106006:	89 1c 24             	mov    %ebx,(%esp)
  106009:	8b 45 08             	mov    0x8(%ebp),%eax
  10600c:	ff d0                	call   *%eax
            break;
  10600e:	eb 27                	jmp    106037 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  106010:	8b 45 0c             	mov    0xc(%ebp),%eax
  106013:	89 44 24 04          	mov    %eax,0x4(%esp)
  106017:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10601e:	8b 45 08             	mov    0x8(%ebp),%eax
  106021:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  106023:	ff 4d 10             	decl   0x10(%ebp)
  106026:	eb 03                	jmp    10602b <vprintfmt+0x3c5>
  106028:	ff 4d 10             	decl   0x10(%ebp)
  10602b:	8b 45 10             	mov    0x10(%ebp),%eax
  10602e:	48                   	dec    %eax
  10602f:	0f b6 00             	movzbl (%eax),%eax
  106032:	3c 25                	cmp    $0x25,%al
  106034:	75 f2                	jne    106028 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  106036:	90                   	nop
    while (1) {
  106037:	e9 36 fc ff ff       	jmp    105c72 <vprintfmt+0xc>
                return;
  10603c:	90                   	nop
        }
    }
}
  10603d:	83 c4 40             	add    $0x40,%esp
  106040:	5b                   	pop    %ebx
  106041:	5e                   	pop    %esi
  106042:	5d                   	pop    %ebp
  106043:	c3                   	ret    

00106044 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  106044:	f3 0f 1e fb          	endbr32 
  106048:	55                   	push   %ebp
  106049:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10604b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10604e:	8b 40 08             	mov    0x8(%eax),%eax
  106051:	8d 50 01             	lea    0x1(%eax),%edx
  106054:	8b 45 0c             	mov    0xc(%ebp),%eax
  106057:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10605a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10605d:	8b 10                	mov    (%eax),%edx
  10605f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106062:	8b 40 04             	mov    0x4(%eax),%eax
  106065:	39 c2                	cmp    %eax,%edx
  106067:	73 12                	jae    10607b <sprintputch+0x37>
        *b->buf ++ = ch;
  106069:	8b 45 0c             	mov    0xc(%ebp),%eax
  10606c:	8b 00                	mov    (%eax),%eax
  10606e:	8d 48 01             	lea    0x1(%eax),%ecx
  106071:	8b 55 0c             	mov    0xc(%ebp),%edx
  106074:	89 0a                	mov    %ecx,(%edx)
  106076:	8b 55 08             	mov    0x8(%ebp),%edx
  106079:	88 10                	mov    %dl,(%eax)
    }
}
  10607b:	90                   	nop
  10607c:	5d                   	pop    %ebp
  10607d:	c3                   	ret    

0010607e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10607e:	f3 0f 1e fb          	endbr32 
  106082:	55                   	push   %ebp
  106083:	89 e5                	mov    %esp,%ebp
  106085:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106088:	8d 45 14             	lea    0x14(%ebp),%eax
  10608b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10608e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106091:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106095:	8b 45 10             	mov    0x10(%ebp),%eax
  106098:	89 44 24 08          	mov    %eax,0x8(%esp)
  10609c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10609f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1060a6:	89 04 24             	mov    %eax,(%esp)
  1060a9:	e8 08 00 00 00       	call   1060b6 <vsnprintf>
  1060ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1060b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1060b4:	c9                   	leave  
  1060b5:	c3                   	ret    

001060b6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1060b6:	f3 0f 1e fb          	endbr32 
  1060ba:	55                   	push   %ebp
  1060bb:	89 e5                	mov    %esp,%ebp
  1060bd:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1060c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1060c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1060c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1060cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1060cf:	01 d0                	add    %edx,%eax
  1060d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1060db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1060df:	74 0a                	je     1060eb <vsnprintf+0x35>
  1060e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1060e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060e7:	39 c2                	cmp    %eax,%edx
  1060e9:	76 07                	jbe    1060f2 <vsnprintf+0x3c>
        return -E_INVAL;
  1060eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1060f0:	eb 2a                	jmp    10611c <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1060f2:	8b 45 14             	mov    0x14(%ebp),%eax
  1060f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1060f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1060fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  106100:	8d 45 ec             	lea    -0x14(%ebp),%eax
  106103:	89 44 24 04          	mov    %eax,0x4(%esp)
  106107:	c7 04 24 44 60 10 00 	movl   $0x106044,(%esp)
  10610e:	e8 53 fb ff ff       	call   105c66 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  106113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106116:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  106119:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10611c:	c9                   	leave  
  10611d:	c3                   	ret    
