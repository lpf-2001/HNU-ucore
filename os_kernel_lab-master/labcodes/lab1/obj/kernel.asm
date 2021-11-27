
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  10000f:	2d 16 0a 11 00       	sub    $0x110a16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 0a 11 00 	movl   $0x110a16,(%esp)
  100027:	e8 d7 2f 00 00       	call   103003 <memset>

    cons_init();                // init the console
  10002c:	e8 16 16 00 00       	call   101647 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 40 38 10 00 	movl   $0x103840,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 5c 38 10 00 	movl   $0x10385c,(%esp)
  100046:	e8 49 02 00 00       	call   100294 <cprintf>

    print_kerninfo();
  10004b:	e8 07 09 00 00       	call   100957 <print_kerninfo>

    grade_backtrace();
  100050:	e8 9a 00 00 00       	call   1000ef <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 58 2c 00 00       	call   102cb2 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 3d 17 00 00       	call   10179c <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 bd 18 00 00       	call   101921 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 63 0d 00 00       	call   100dcc <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 7a 18 00 00       	call   1018e8 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 87 01 00 00       	call   1001fa <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	f3 0f 1e fb          	endbr32 
  100079:	55                   	push   %ebp
  10007a:	89 e5                	mov    %esp,%ebp
  10007c:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100086:	00 
  100087:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008e:	00 
  10008f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100096:	e8 1b 0d 00 00       	call   100db6 <mon_backtrace>
}
  10009b:	90                   	nop
  10009c:	c9                   	leave  
  10009d:	c3                   	ret    

0010009e <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009e:	f3 0f 1e fb          	endbr32 
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	53                   	push   %ebx
  1000a6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000af:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000c1:	89 04 24             	mov    %eax,(%esp)
  1000c4:	e8 ac ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c9:	90                   	nop
  1000ca:	83 c4 14             	add    $0x14,%esp
  1000cd:	5b                   	pop    %ebx
  1000ce:	5d                   	pop    %ebp
  1000cf:	c3                   	ret    

001000d0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d0:	f3 0f 1e fb          	endbr32 
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	8b 45 10             	mov    0x10(%ebp),%eax
  1000dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e4:	89 04 24             	mov    %eax,(%esp)
  1000e7:	e8 b2 ff ff ff       	call   10009e <grade_backtrace1>
}
  1000ec:	90                   	nop
  1000ed:	c9                   	leave  
  1000ee:	c3                   	ret    

001000ef <grade_backtrace>:

void
grade_backtrace(void) {
  1000ef:	f3 0f 1e fb          	endbr32 
  1000f3:	55                   	push   %ebp
  1000f4:	89 e5                	mov    %esp,%ebp
  1000f6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000fe:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100105:	ff 
  100106:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100111:	e8 ba ff ff ff       	call   1000d0 <grade_backtrace0>
}
  100116:	90                   	nop
  100117:	c9                   	leave  
  100118:	c3                   	ret    

00100119 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100119:	f3 0f 1e fb          	endbr32 
  10011d:	55                   	push   %ebp
  10011e:	89 e5                	mov    %esp,%ebp
  100120:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100123:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100126:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100129:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10012c:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100133:	83 e0 03             	and    $0x3,%eax
  100136:	89 c2                	mov    %eax,%edx
  100138:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10013d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100141:	89 44 24 04          	mov    %eax,0x4(%esp)
  100145:	c7 04 24 61 38 10 00 	movl   $0x103861,(%esp)
  10014c:	e8 43 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	89 c2                	mov    %eax,%edx
  100157:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10015c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100160:	89 44 24 04          	mov    %eax,0x4(%esp)
  100164:	c7 04 24 6f 38 10 00 	movl   $0x10386f,(%esp)
  10016b:	e8 24 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100170:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100174:	89 c2                	mov    %eax,%edx
  100176:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10017b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100183:	c7 04 24 7d 38 10 00 	movl   $0x10387d,(%esp)
  10018a:	e8 05 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100193:	89 c2                	mov    %eax,%edx
  100195:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10019a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a2:	c7 04 24 8b 38 10 00 	movl   $0x10388b,(%esp)
  1001a9:	e8 e6 00 00 00       	call   100294 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ae:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001b2:	89 c2                	mov    %eax,%edx
  1001b4:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 99 38 10 00 	movl   $0x103899,(%esp)
  1001c8:	e8 c7 00 00 00       	call   100294 <cprintf>
    round ++;
  1001cd:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001d2:	40                   	inc    %eax
  1001d3:	a3 20 0a 11 00       	mov    %eax,0x110a20
}
  1001d8:	90                   	nop
  1001d9:	c9                   	leave  
  1001da:	c3                   	ret    

001001db <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001db:	f3 0f 1e fb          	endbr32 
  1001df:	55                   	push   %ebp
  1001e0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001e2:	83 ec 08             	sub    $0x8,%esp
  1001e5:	cd 78                	int    $0x78
  1001e7:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001e9:	90                   	nop
  1001ea:	5d                   	pop    %ebp
  1001eb:	c3                   	ret    

001001ec <lab1_switch_to_kernel>:




static void
lab1_switch_to_kernel(void) {
  1001ec:	f3 0f 1e fb          	endbr32 
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001f3:	cd 79                	int    $0x79
  1001f5:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001f7:	90                   	nop
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:


static void
lab1_switch_test(void) {
  1001fa:	f3 0f 1e fb          	endbr32 
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
  100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100204:	e8 10 ff ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100209:	c7 04 24 a8 38 10 00 	movl   $0x1038a8,(%esp)
  100210:	e8 7f 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_user();
  100215:	e8 c1 ff ff ff       	call   1001db <lab1_switch_to_user>
    lab1_print_cur_status();
  10021a:	e8 fa fe ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021f:	c7 04 24 c8 38 10 00 	movl   $0x1038c8,(%esp)
  100226:	e8 69 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_kernel();
  10022b:	e8 bc ff ff ff       	call   1001ec <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100230:	e8 e4 fe ff ff       	call   100119 <lab1_print_cur_status>
}
  100235:	90                   	nop
  100236:	c9                   	leave  
  100237:	c3                   	ret    

00100238 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100238:	f3 0f 1e fb          	endbr32 
  10023c:	55                   	push   %ebp
  10023d:	89 e5                	mov    %esp,%ebp
  10023f:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100242:	8b 45 08             	mov    0x8(%ebp),%eax
  100245:	89 04 24             	mov    %eax,(%esp)
  100248:	e8 2b 14 00 00       	call   101678 <cons_putc>
    (*cnt) ++;
  10024d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100250:	8b 00                	mov    (%eax),%eax
  100252:	8d 50 01             	lea    0x1(%eax),%edx
  100255:	8b 45 0c             	mov    0xc(%ebp),%eax
  100258:	89 10                	mov    %edx,(%eax)
}
  10025a:	90                   	nop
  10025b:	c9                   	leave  
  10025c:	c3                   	ret    

0010025d <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025d:	f3 0f 1e fb          	endbr32 
  100261:	55                   	push   %ebp
  100262:	89 e5                	mov    %esp,%ebp
  100264:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100271:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100275:	8b 45 08             	mov    0x8(%ebp),%eax
  100278:	89 44 24 08          	mov    %eax,0x8(%esp)
  10027c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100283:	c7 04 24 38 02 10 00 	movl   $0x100238,(%esp)
  10028a:	e8 e0 30 00 00       	call   10336f <vprintfmt>
    return cnt;
  10028f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100292:	c9                   	leave  
  100293:	c3                   	ret    

00100294 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100294:	f3 0f 1e fb          	endbr32 
  100298:	55                   	push   %ebp
  100299:	89 e5                	mov    %esp,%ebp
  10029b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10029e:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ae:	89 04 24             	mov    %eax,(%esp)
  1002b1:	e8 a7 ff ff ff       	call   10025d <vcprintf>
  1002b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002bc:	c9                   	leave  
  1002bd:	c3                   	ret    

001002be <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002be:	f3 0f 1e fb          	endbr32 
  1002c2:	55                   	push   %ebp
  1002c3:	89 e5                	mov    %esp,%ebp
  1002c5:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	89 04 24             	mov    %eax,(%esp)
  1002ce:	e8 a5 13 00 00       	call   101678 <cons_putc>
}
  1002d3:	90                   	nop
  1002d4:	c9                   	leave  
  1002d5:	c3                   	ret    

001002d6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002d6:	f3 0f 1e fb          	endbr32 
  1002da:	55                   	push   %ebp
  1002db:	89 e5                	mov    %esp,%ebp
  1002dd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e7:	eb 13                	jmp    1002fc <cputs+0x26>
        cputch(c, &cnt);
  1002e9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002ed:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002f4:	89 04 24             	mov    %eax,(%esp)
  1002f7:	e8 3c ff ff ff       	call   100238 <cputch>
    while ((c = *str ++) != '\0') {
  1002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	89 55 08             	mov    %edx,0x8(%ebp)
  100305:	0f b6 00             	movzbl (%eax),%eax
  100308:	88 45 f7             	mov    %al,-0x9(%ebp)
  10030b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10030f:	75 d8                	jne    1002e9 <cputs+0x13>
    }
    cputch('\n', &cnt);
  100311:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100314:	89 44 24 04          	mov    %eax,0x4(%esp)
  100318:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10031f:	e8 14 ff ff ff       	call   100238 <cputch>
    return cnt;
  100324:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100327:	c9                   	leave  
  100328:	c3                   	ret    

00100329 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100329:	f3 0f 1e fb          	endbr32 
  10032d:	55                   	push   %ebp
  10032e:	89 e5                	mov    %esp,%ebp
  100330:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100333:	90                   	nop
  100334:	e8 6d 13 00 00       	call   1016a6 <cons_getc>
  100339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10033c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100340:	74 f2                	je     100334 <getchar+0xb>
        /* do nothing */;
    return c;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100347:	f3 0f 1e fb          	endbr32 
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100355:	74 13                	je     10036a <readline+0x23>
        cprintf("%s", prompt);
  100357:	8b 45 08             	mov    0x8(%ebp),%eax
  10035a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035e:	c7 04 24 e7 38 10 00 	movl   $0x1038e7,(%esp)
  100365:	e8 2a ff ff ff       	call   100294 <cprintf>
    }
    int i = 0, c;
  10036a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100371:	e8 b3 ff ff ff       	call   100329 <getchar>
  100376:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100379:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10037d:	79 07                	jns    100386 <readline+0x3f>
            return NULL;
  10037f:	b8 00 00 00 00       	mov    $0x0,%eax
  100384:	eb 78                	jmp    1003fe <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100386:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10038a:	7e 28                	jle    1003b4 <readline+0x6d>
  10038c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100393:	7f 1f                	jg     1003b4 <readline+0x6d>
            cputchar(c);
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100398:	89 04 24             	mov    %eax,(%esp)
  10039b:	e8 1e ff ff ff       	call   1002be <cputchar>
            buf[i ++] = c;
  1003a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003a3:	8d 50 01             	lea    0x1(%eax),%edx
  1003a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003ac:	88 90 40 0a 11 00    	mov    %dl,0x110a40(%eax)
  1003b2:	eb 45                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003b4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003b8:	75 16                	jne    1003d0 <readline+0x89>
  1003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003be:	7e 10                	jle    1003d0 <readline+0x89>
            cputchar(c);
  1003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c3:	89 04 24             	mov    %eax,(%esp)
  1003c6:	e8 f3 fe ff ff       	call   1002be <cputchar>
            i --;
  1003cb:	ff 4d f4             	decl   -0xc(%ebp)
  1003ce:	eb 29                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003d4:	74 06                	je     1003dc <readline+0x95>
  1003d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003da:	75 95                	jne    100371 <readline+0x2a>
            cputchar(c);
  1003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003df:	89 04 24             	mov    %eax,(%esp)
  1003e2:	e8 d7 fe ff ff       	call   1002be <cputchar>
            buf[i] = '\0';
  1003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ea:	05 40 0a 11 00       	add    $0x110a40,%eax
  1003ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003f2:	b8 40 0a 11 00       	mov    $0x110a40,%eax
  1003f7:	eb 05                	jmp    1003fe <readline+0xb7>
        c = getchar();
  1003f9:	e9 73 ff ff ff       	jmp    100371 <readline+0x2a>
        }
    }
}
  1003fe:	c9                   	leave  
  1003ff:	c3                   	ret    

00100400 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100400:	f3 0f 1e fb          	endbr32 
  100404:	55                   	push   %ebp
  100405:	89 e5                	mov    %esp,%ebp
  100407:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10040a:	a1 40 0e 11 00       	mov    0x110e40,%eax
  10040f:	85 c0                	test   %eax,%eax
  100411:	75 5b                	jne    10046e <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100413:	c7 05 40 0e 11 00 01 	movl   $0x1,0x110e40
  10041a:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10041d:	8d 45 14             	lea    0x14(%ebp),%eax
  100420:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100423:	8b 45 0c             	mov    0xc(%ebp),%eax
  100426:	89 44 24 08          	mov    %eax,0x8(%esp)
  10042a:	8b 45 08             	mov    0x8(%ebp),%eax
  10042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100431:	c7 04 24 ea 38 10 00 	movl   $0x1038ea,(%esp)
  100438:	e8 57 fe ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  10043d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100440:	89 44 24 04          	mov    %eax,0x4(%esp)
  100444:	8b 45 10             	mov    0x10(%ebp),%eax
  100447:	89 04 24             	mov    %eax,(%esp)
  10044a:	e8 0e fe ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  10044f:	c7 04 24 06 39 10 00 	movl   $0x103906,(%esp)
  100456:	e8 39 fe ff ff       	call   100294 <cprintf>
    
    cprintf("stack trackback:\n");
  10045b:	c7 04 24 08 39 10 00 	movl   $0x103908,(%esp)
  100462:	e8 2d fe ff ff       	call   100294 <cprintf>
    print_stackframe();
  100467:	e8 3d 06 00 00       	call   100aa9 <print_stackframe>
  10046c:	eb 01                	jmp    10046f <__panic+0x6f>
        goto panic_dead;
  10046e:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10046f:	e8 80 14 00 00       	call   1018f4 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10047b:	e8 5d 08 00 00       	call   100cdd <kmonitor>
  100480:	eb f2                	jmp    100474 <__panic+0x74>

00100482 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100482:	f3 0f 1e fb          	endbr32 
  100486:	55                   	push   %ebp
  100487:	89 e5                	mov    %esp,%ebp
  100489:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10048c:	8d 45 14             	lea    0x14(%ebp),%eax
  10048f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	89 44 24 08          	mov    %eax,0x8(%esp)
  100499:	8b 45 08             	mov    0x8(%ebp),%eax
  10049c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a0:	c7 04 24 1a 39 10 00 	movl   $0x10391a,(%esp)
  1004a7:	e8 e8 fd ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  1004ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b6:	89 04 24             	mov    %eax,(%esp)
  1004b9:	e8 9f fd ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  1004be:	c7 04 24 06 39 10 00 	movl   $0x103906,(%esp)
  1004c5:	e8 ca fd ff ff       	call   100294 <cprintf>
    va_end(ap);
}
  1004ca:	90                   	nop
  1004cb:	c9                   	leave  
  1004cc:	c3                   	ret    

001004cd <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004cd:	f3 0f 1e fb          	endbr32 
  1004d1:	55                   	push   %ebp
  1004d2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004d4:	a1 40 0e 11 00       	mov    0x110e40,%eax
}
  1004d9:	5d                   	pop    %ebp
  1004da:	c3                   	ret    

001004db <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004db:	f3 0f 1e fb          	endbr32 
  1004df:	55                   	push   %ebp
  1004e0:	89 e5                	mov    %esp,%ebp
  1004e2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e8:	8b 00                	mov    (%eax),%eax
  1004ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f0:	8b 00                	mov    (%eax),%eax
  1004f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004fc:	e9 ca 00 00 00       	jmp    1005cb <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100501:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100504:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100507:	01 d0                	add    %edx,%eax
  100509:	89 c2                	mov    %eax,%edx
  10050b:	c1 ea 1f             	shr    $0x1f,%edx
  10050e:	01 d0                	add    %edx,%eax
  100510:	d1 f8                	sar    %eax
  100512:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100518:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10051b:	eb 03                	jmp    100520 <stab_binsearch+0x45>
            m --;
  10051d:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100523:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100526:	7c 1f                	jl     100547 <stab_binsearch+0x6c>
  100528:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052b:	89 d0                	mov    %edx,%eax
  10052d:	01 c0                	add    %eax,%eax
  10052f:	01 d0                	add    %edx,%eax
  100531:	c1 e0 02             	shl    $0x2,%eax
  100534:	89 c2                	mov    %eax,%edx
  100536:	8b 45 08             	mov    0x8(%ebp),%eax
  100539:	01 d0                	add    %edx,%eax
  10053b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053f:	0f b6 c0             	movzbl %al,%eax
  100542:	39 45 14             	cmp    %eax,0x14(%ebp)
  100545:	75 d6                	jne    10051d <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10054d:	7d 09                	jge    100558 <stab_binsearch+0x7d>
            l = true_m + 1;
  10054f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100552:	40                   	inc    %eax
  100553:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100556:	eb 73                	jmp    1005cb <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100558:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10055f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100562:	89 d0                	mov    %edx,%eax
  100564:	01 c0                	add    %eax,%eax
  100566:	01 d0                	add    %edx,%eax
  100568:	c1 e0 02             	shl    $0x2,%eax
  10056b:	89 c2                	mov    %eax,%edx
  10056d:	8b 45 08             	mov    0x8(%ebp),%eax
  100570:	01 d0                	add    %edx,%eax
  100572:	8b 40 08             	mov    0x8(%eax),%eax
  100575:	39 45 18             	cmp    %eax,0x18(%ebp)
  100578:	76 11                	jbe    10058b <stab_binsearch+0xb0>
            *region_left = m;
  10057a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100580:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100585:	40                   	inc    %eax
  100586:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100589:	eb 40                	jmp    1005cb <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	89 d0                	mov    %edx,%eax
  100590:	01 c0                	add    %eax,%eax
  100592:	01 d0                	add    %edx,%eax
  100594:	c1 e0 02             	shl    $0x2,%eax
  100597:	89 c2                	mov    %eax,%edx
  100599:	8b 45 08             	mov    0x8(%ebp),%eax
  10059c:	01 d0                	add    %edx,%eax
  10059e:	8b 40 08             	mov    0x8(%eax),%eax
  1005a1:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005a4:	73 14                	jae    1005ba <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1005af:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005b4:	48                   	dec    %eax
  1005b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005b8:	eb 11                	jmp    1005cb <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c0:	89 10                	mov    %edx,(%eax)
            l = m;
  1005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005c8:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005d1:	0f 8e 2a ff ff ff    	jle    100501 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005db:	75 0f                	jne    1005ec <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  1005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e0:	8b 00                	mov    (%eax),%eax
  1005e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e8:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005ea:	eb 3e                	jmp    10062a <stab_binsearch+0x14f>
        l = *region_right;
  1005ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ef:	8b 00                	mov    (%eax),%eax
  1005f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005f4:	eb 03                	jmp    1005f9 <stab_binsearch+0x11e>
  1005f6:	ff 4d fc             	decl   -0x4(%ebp)
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	8b 00                	mov    (%eax),%eax
  1005fe:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100601:	7e 1f                	jle    100622 <stab_binsearch+0x147>
  100603:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100606:	89 d0                	mov    %edx,%eax
  100608:	01 c0                	add    %eax,%eax
  10060a:	01 d0                	add    %edx,%eax
  10060c:	c1 e0 02             	shl    $0x2,%eax
  10060f:	89 c2                	mov    %eax,%edx
  100611:	8b 45 08             	mov    0x8(%ebp),%eax
  100614:	01 d0                	add    %edx,%eax
  100616:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10061a:	0f b6 c0             	movzbl %al,%eax
  10061d:	39 45 14             	cmp    %eax,0x14(%ebp)
  100620:	75 d4                	jne    1005f6 <stab_binsearch+0x11b>
        *region_left = l;
  100622:	8b 45 0c             	mov    0xc(%ebp),%eax
  100625:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100628:	89 10                	mov    %edx,(%eax)
}
  10062a:	90                   	nop
  10062b:	c9                   	leave  
  10062c:	c3                   	ret    

0010062d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10062d:	f3 0f 1e fb          	endbr32 
  100631:	55                   	push   %ebp
  100632:	89 e5                	mov    %esp,%ebp
  100634:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100637:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063a:	c7 00 38 39 10 00    	movl   $0x103938,(%eax)
    info->eip_line = 0;
  100640:	8b 45 0c             	mov    0xc(%ebp),%eax
  100643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064d:	c7 40 08 38 39 10 00 	movl   $0x103938,0x8(%eax)
    info->eip_fn_namelen = 9;
  100654:	8b 45 0c             	mov    0xc(%ebp),%eax
  100657:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10065e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100661:	8b 55 08             	mov    0x8(%ebp),%edx
  100664:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100671:	c7 45 f4 8c 41 10 00 	movl   $0x10418c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100678:	c7 45 f0 14 d1 10 00 	movl   $0x10d114,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10067f:	c7 45 ec 15 d1 10 00 	movl   $0x10d115,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100686:	c7 45 e8 22 f2 10 00 	movl   $0x10f222,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100690:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100693:	76 0b                	jbe    1006a0 <debuginfo_eip+0x73>
  100695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100698:	48                   	dec    %eax
  100699:	0f b6 00             	movzbl (%eax),%eax
  10069c:	84 c0                	test   %al,%al
  10069e:	74 0a                	je     1006aa <debuginfo_eip+0x7d>
        return -1;
  1006a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a5:	e9 ab 02 00 00       	jmp    100955 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006b4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006b7:	c1 f8 02             	sar    $0x2,%eax
  1006ba:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006c0:	48                   	dec    %eax
  1006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006c7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006cb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006d2:	00 
  1006d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 ef fd ff ff       	call   1004db <stab_binsearch>
    if (lfile == 0)
  1006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ef:	85 c0                	test   %eax,%eax
  1006f1:	75 0a                	jne    1006fd <debuginfo_eip+0xd0>
        return -1;
  1006f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006f8:	e9 58 02 00 00       	jmp    100955 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100700:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100706:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100709:	8b 45 08             	mov    0x8(%ebp),%eax
  10070c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100710:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100717:	00 
  100718:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10071b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100722:	89 44 24 04          	mov    %eax,0x4(%esp)
  100726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100729:	89 04 24             	mov    %eax,(%esp)
  10072c:	e8 aa fd ff ff       	call   1004db <stab_binsearch>

    if (lfun <= rfun) {
  100731:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100734:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100737:	39 c2                	cmp    %eax,%edx
  100739:	7f 78                	jg     1007b3 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10073b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10073e:	89 c2                	mov    %eax,%edx
  100740:	89 d0                	mov    %edx,%eax
  100742:	01 c0                	add    %eax,%eax
  100744:	01 d0                	add    %edx,%eax
  100746:	c1 e0 02             	shl    $0x2,%eax
  100749:	89 c2                	mov    %eax,%edx
  10074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	8b 10                	mov    (%eax),%edx
  100752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100755:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100758:	39 c2                	cmp    %eax,%edx
  10075a:	73 22                	jae    10077e <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 c2                	mov    %eax,%edx
  100761:	89 d0                	mov    %edx,%eax
  100763:	01 c0                	add    %eax,%eax
  100765:	01 d0                	add    %edx,%eax
  100767:	c1 e0 02             	shl    $0x2,%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076f:	01 d0                	add    %edx,%eax
  100771:	8b 10                	mov    (%eax),%edx
  100773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100776:	01 c2                	add    %eax,%edx
  100778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10077e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100781:	89 c2                	mov    %eax,%edx
  100783:	89 d0                	mov    %edx,%eax
  100785:	01 c0                	add    %eax,%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	c1 e0 02             	shl    $0x2,%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100791:	01 d0                	add    %edx,%eax
  100793:	8b 50 08             	mov    0x8(%eax),%edx
  100796:	8b 45 0c             	mov    0xc(%ebp),%eax
  100799:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10079c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079f:	8b 40 10             	mov    0x10(%eax),%eax
  1007a2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007b1:	eb 15                	jmp    1007c8 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1007b9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cb:	8b 40 08             	mov    0x8(%eax),%eax
  1007ce:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007d5:	00 
  1007d6:	89 04 24             	mov    %eax,(%esp)
  1007d9:	e8 99 26 00 00       	call   102e77 <strfind>
  1007de:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007e1:	8b 52 08             	mov    0x8(%edx),%edx
  1007e4:	29 d0                	sub    %edx,%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007eb:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1007f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007f5:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007fc:	00 
  1007fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100800:	89 44 24 08          	mov    %eax,0x8(%esp)
  100804:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100807:	89 44 24 04          	mov    %eax,0x4(%esp)
  10080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080e:	89 04 24             	mov    %eax,(%esp)
  100811:	e8 c5 fc ff ff       	call   1004db <stab_binsearch>
    if (lline <= rline) {
  100816:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100819:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10081c:	39 c2                	cmp    %eax,%edx
  10081e:	7f 23                	jg     100843 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100820:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	89 d0                	mov    %edx,%eax
  100827:	01 c0                	add    %eax,%eax
  100829:	01 d0                	add    %edx,%eax
  10082b:	c1 e0 02             	shl    $0x2,%eax
  10082e:	89 c2                	mov    %eax,%edx
  100830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100833:	01 d0                	add    %edx,%eax
  100835:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100841:	eb 11                	jmp    100854 <debuginfo_eip+0x227>
        return -1;
  100843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100848:	e9 08 01 00 00       	jmp    100955 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	48                   	dec    %eax
  100851:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100854:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10085a:	39 c2                	cmp    %eax,%edx
  10085c:	7c 56                	jl     1008b4 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10085e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	89 d0                	mov    %edx,%eax
  100865:	01 c0                	add    %eax,%eax
  100867:	01 d0                	add    %edx,%eax
  100869:	c1 e0 02             	shl    $0x2,%eax
  10086c:	89 c2                	mov    %eax,%edx
  10086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100871:	01 d0                	add    %edx,%eax
  100873:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100877:	3c 84                	cmp    $0x84,%al
  100879:	74 39                	je     1008b4 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10087b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	89 d0                	mov    %edx,%eax
  100882:	01 c0                	add    %eax,%eax
  100884:	01 d0                	add    %edx,%eax
  100886:	c1 e0 02             	shl    $0x2,%eax
  100889:	89 c2                	mov    %eax,%edx
  10088b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10088e:	01 d0                	add    %edx,%eax
  100890:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100894:	3c 64                	cmp    $0x64,%al
  100896:	75 b5                	jne    10084d <debuginfo_eip+0x220>
  100898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089b:	89 c2                	mov    %eax,%edx
  10089d:	89 d0                	mov    %edx,%eax
  10089f:	01 c0                	add    %eax,%eax
  1008a1:	01 d0                	add    %edx,%eax
  1008a3:	c1 e0 02             	shl    $0x2,%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ab:	01 d0                	add    %edx,%eax
  1008ad:	8b 40 08             	mov    0x8(%eax),%eax
  1008b0:	85 c0                	test   %eax,%eax
  1008b2:	74 99                	je     10084d <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008ba:	39 c2                	cmp    %eax,%edx
  1008bc:	7c 42                	jl     100900 <debuginfo_eip+0x2d3>
  1008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	89 d0                	mov    %edx,%eax
  1008c5:	01 c0                	add    %eax,%eax
  1008c7:	01 d0                	add    %edx,%eax
  1008c9:	c1 e0 02             	shl    $0x2,%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d1:	01 d0                	add    %edx,%eax
  1008d3:	8b 10                	mov    (%eax),%edx
  1008d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008d8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008db:	39 c2                	cmp    %eax,%edx
  1008dd:	73 21                	jae    100900 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e2:	89 c2                	mov    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	01 c0                	add    %eax,%eax
  1008e8:	01 d0                	add    %edx,%eax
  1008ea:	c1 e0 02             	shl    $0x2,%eax
  1008ed:	89 c2                	mov    %eax,%edx
  1008ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f2:	01 d0                	add    %edx,%eax
  1008f4:	8b 10                	mov    (%eax),%edx
  1008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008f9:	01 c2                	add    %eax,%edx
  1008fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fe:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100900:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100903:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100906:	39 c2                	cmp    %eax,%edx
  100908:	7d 46                	jge    100950 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10090a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10090d:	40                   	inc    %eax
  10090e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100911:	eb 16                	jmp    100929 <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100913:	8b 45 0c             	mov    0xc(%ebp),%eax
  100916:	8b 40 14             	mov    0x14(%eax),%eax
  100919:	8d 50 01             	lea    0x1(%eax),%edx
  10091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10091f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100925:	40                   	inc    %eax
  100926:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10092c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10092f:	39 c2                	cmp    %eax,%edx
  100931:	7d 1d                	jge    100950 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100936:	89 c2                	mov    %eax,%edx
  100938:	89 d0                	mov    %edx,%eax
  10093a:	01 c0                	add    %eax,%eax
  10093c:	01 d0                	add    %edx,%eax
  10093e:	c1 e0 02             	shl    $0x2,%eax
  100941:	89 c2                	mov    %eax,%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10094c:	3c a0                	cmp    $0xa0,%al
  10094e:	74 c3                	je     100913 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100955:	c9                   	leave  
  100956:	c3                   	ret    

00100957 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100957:	f3 0f 1e fb          	endbr32 
  10095b:	55                   	push   %ebp
  10095c:	89 e5                	mov    %esp,%ebp
  10095e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100961:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  100968:	e8 27 f9 ff ff       	call   100294 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10096d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100974:	00 
  100975:	c7 04 24 5b 39 10 00 	movl   $0x10395b,(%esp)
  10097c:	e8 13 f9 ff ff       	call   100294 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100981:	c7 44 24 04 27 38 10 	movl   $0x103827,0x4(%esp)
  100988:	00 
  100989:	c7 04 24 73 39 10 00 	movl   $0x103973,(%esp)
  100990:	e8 ff f8 ff ff       	call   100294 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100995:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  10099c:	00 
  10099d:	c7 04 24 8b 39 10 00 	movl   $0x10398b,(%esp)
  1009a4:	e8 eb f8 ff ff       	call   100294 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009a9:	c7 44 24 04 80 1d 11 	movl   $0x111d80,0x4(%esp)
  1009b0:	00 
  1009b1:	c7 04 24 a3 39 10 00 	movl   $0x1039a3,(%esp)
  1009b8:	e8 d7 f8 ff ff       	call   100294 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009bd:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  1009c2:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009c7:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009cc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009d2:	85 c0                	test   %eax,%eax
  1009d4:	0f 48 c2             	cmovs  %edx,%eax
  1009d7:	c1 f8 0a             	sar    $0xa,%eax
  1009da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009de:	c7 04 24 bc 39 10 00 	movl   $0x1039bc,(%esp)
  1009e5:	e8 aa f8 ff ff       	call   100294 <cprintf>
}
  1009ea:	90                   	nop
  1009eb:	c9                   	leave  
  1009ec:	c3                   	ret    

001009ed <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009ed:	f3 0f 1e fb          	endbr32 
  1009f1:	55                   	push   %ebp
  1009f2:	89 e5                	mov    %esp,%ebp
  1009f4:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009fa:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a01:	8b 45 08             	mov    0x8(%ebp),%eax
  100a04:	89 04 24             	mov    %eax,(%esp)
  100a07:	e8 21 fc ff ff       	call   10062d <debuginfo_eip>
  100a0c:	85 c0                	test   %eax,%eax
  100a0e:	74 15                	je     100a25 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a10:	8b 45 08             	mov    0x8(%ebp),%eax
  100a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a17:	c7 04 24 e6 39 10 00 	movl   $0x1039e6,(%esp)
  100a1e:	e8 71 f8 ff ff       	call   100294 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a23:	eb 6c                	jmp    100a91 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a2c:	eb 1b                	jmp    100a49 <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	01 d0                	add    %edx,%eax
  100a36:	0f b6 10             	movzbl (%eax),%edx
  100a39:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a42:	01 c8                	add    %ecx,%eax
  100a44:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a46:	ff 45 f4             	incl   -0xc(%ebp)
  100a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a4f:	7c dd                	jl     100a2e <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a51:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	01 d0                	add    %edx,%eax
  100a5c:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a62:	8b 55 08             	mov    0x8(%ebp),%edx
  100a65:	89 d1                	mov    %edx,%ecx
  100a67:	29 c1                	sub    %eax,%ecx
  100a69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a6f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a73:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a79:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a7d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a85:	c7 04 24 02 3a 10 00 	movl   $0x103a02,(%esp)
  100a8c:	e8 03 f8 ff ff       	call   100294 <cprintf>
}
  100a91:	90                   	nop
  100a92:	c9                   	leave  
  100a93:	c3                   	ret    

00100a94 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a94:	f3 0f 1e fb          	endbr32 
  100a98:	55                   	push   %ebp
  100a99:	89 e5                	mov    %esp,%ebp
  100a9b:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a9e:	8b 45 04             	mov    0x4(%ebp),%eax
  100aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100aa7:	c9                   	leave  
  100aa8:	c3                   	ret    

00100aa9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100aa9:	f3 0f 1e fb          	endbr32 
  100aad:	55                   	push   %ebp
  100aae:	89 e5                	mov    %esp,%ebp
  100ab0:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ab3:	89 e8                	mov    %ebp,%eax
  100ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100ab8:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100abe:	e8 d1 ff ff ff       	call   100a94 <read_eip>
  100ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100ac6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100acd:	e9 84 00 00 00       	jmp    100b56 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ad5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae0:	c7 04 24 14 3a 10 00 	movl   $0x103a14,(%esp)
  100ae7:	e8 a8 f7 ff ff       	call   100294 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aef:	83 c0 08             	add    $0x8,%eax
  100af2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100af5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100afc:	eb 24                	jmp    100b22 <print_stackframe+0x79>
            cprintf("0x%08x ", args[j]);
  100afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b0b:	01 d0                	add    %edx,%eax
  100b0d:	8b 00                	mov    (%eax),%eax
  100b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b13:	c7 04 24 30 3a 10 00 	movl   $0x103a30,(%esp)
  100b1a:	e8 75 f7 ff ff       	call   100294 <cprintf>
        for (j = 0; j < 4; j ++) {
  100b1f:	ff 45 e8             	incl   -0x18(%ebp)
  100b22:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b26:	7e d6                	jle    100afe <print_stackframe+0x55>
        }
        cprintf("\n");
  100b28:	c7 04 24 38 3a 10 00 	movl   $0x103a38,(%esp)
  100b2f:	e8 60 f7 ff ff       	call   100294 <cprintf>
        print_debuginfo(eip - 1);
  100b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b37:	48                   	dec    %eax
  100b38:	89 04 24             	mov    %eax,(%esp)
  100b3b:	e8 ad fe ff ff       	call   1009ed <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b43:	83 c0 04             	add    $0x4,%eax
  100b46:	8b 00                	mov    (%eax),%eax
  100b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b4e:	8b 00                	mov    (%eax),%eax
  100b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100b53:	ff 45 ec             	incl   -0x14(%ebp)
  100b56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b5a:	74 0a                	je     100b66 <print_stackframe+0xbd>
  100b5c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b60:	0f 8e 6c ff ff ff    	jle    100ad2 <print_stackframe+0x29>
    }
}
  100b66:	90                   	nop
  100b67:	c9                   	leave  
  100b68:	c3                   	ret    

00100b69 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b69:	f3 0f 1e fb          	endbr32 
  100b6d:	55                   	push   %ebp
  100b6e:	89 e5                	mov    %esp,%ebp
  100b70:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b7a:	eb 0c                	jmp    100b88 <parse+0x1f>
            *buf ++ = '\0';
  100b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7f:	8d 50 01             	lea    0x1(%eax),%edx
  100b82:	89 55 08             	mov    %edx,0x8(%ebp)
  100b85:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b88:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8b:	0f b6 00             	movzbl (%eax),%eax
  100b8e:	84 c0                	test   %al,%al
  100b90:	74 1d                	je     100baf <parse+0x46>
  100b92:	8b 45 08             	mov    0x8(%ebp),%eax
  100b95:	0f b6 00             	movzbl (%eax),%eax
  100b98:	0f be c0             	movsbl %al,%eax
  100b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b9f:	c7 04 24 bc 3a 10 00 	movl   $0x103abc,(%esp)
  100ba6:	e8 96 22 00 00       	call   102e41 <strchr>
  100bab:	85 c0                	test   %eax,%eax
  100bad:	75 cd                	jne    100b7c <parse+0x13>
        }
        if (*buf == '\0') {
  100baf:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb2:	0f b6 00             	movzbl (%eax),%eax
  100bb5:	84 c0                	test   %al,%al
  100bb7:	74 65                	je     100c1e <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bb9:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bbd:	75 14                	jne    100bd3 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bbf:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bc6:	00 
  100bc7:	c7 04 24 c1 3a 10 00 	movl   $0x103ac1,(%esp)
  100bce:	e8 c1 f6 ff ff       	call   100294 <cprintf>
        }
        argv[argc ++] = buf;
  100bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd6:	8d 50 01             	lea    0x1(%eax),%edx
  100bd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  100be6:	01 c2                	add    %eax,%edx
  100be8:	8b 45 08             	mov    0x8(%ebp),%eax
  100beb:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bed:	eb 03                	jmp    100bf2 <parse+0x89>
            buf ++;
  100bef:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf5:	0f b6 00             	movzbl (%eax),%eax
  100bf8:	84 c0                	test   %al,%al
  100bfa:	74 8c                	je     100b88 <parse+0x1f>
  100bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  100bff:	0f b6 00             	movzbl (%eax),%eax
  100c02:	0f be c0             	movsbl %al,%eax
  100c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c09:	c7 04 24 bc 3a 10 00 	movl   $0x103abc,(%esp)
  100c10:	e8 2c 22 00 00       	call   102e41 <strchr>
  100c15:	85 c0                	test   %eax,%eax
  100c17:	74 d6                	je     100bef <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c19:	e9 6a ff ff ff       	jmp    100b88 <parse+0x1f>
            break;
  100c1e:	90                   	nop
        }
    }
    return argc;
  100c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c22:	c9                   	leave  
  100c23:	c3                   	ret    

00100c24 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c24:	f3 0f 1e fb          	endbr32 
  100c28:	55                   	push   %ebp
  100c29:	89 e5                	mov    %esp,%ebp
  100c2b:	53                   	push   %ebx
  100c2c:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c2f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c36:	8b 45 08             	mov    0x8(%ebp),%eax
  100c39:	89 04 24             	mov    %eax,(%esp)
  100c3c:	e8 28 ff ff ff       	call   100b69 <parse>
  100c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c48:	75 0a                	jne    100c54 <runcmd+0x30>
        return 0;
  100c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  100c4f:	e9 83 00 00 00       	jmp    100cd7 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c5b:	eb 5a                	jmp    100cb7 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c5d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c63:	89 d0                	mov    %edx,%eax
  100c65:	01 c0                	add    %eax,%eax
  100c67:	01 d0                	add    %edx,%eax
  100c69:	c1 e0 02             	shl    $0x2,%eax
  100c6c:	05 00 00 11 00       	add    $0x110000,%eax
  100c71:	8b 00                	mov    (%eax),%eax
  100c73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c77:	89 04 24             	mov    %eax,(%esp)
  100c7a:	e8 1e 21 00 00       	call   102d9d <strcmp>
  100c7f:	85 c0                	test   %eax,%eax
  100c81:	75 31                	jne    100cb4 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c86:	89 d0                	mov    %edx,%eax
  100c88:	01 c0                	add    %eax,%eax
  100c8a:	01 d0                	add    %edx,%eax
  100c8c:	c1 e0 02             	shl    $0x2,%eax
  100c8f:	05 08 00 11 00       	add    $0x110008,%eax
  100c94:	8b 10                	mov    (%eax),%edx
  100c96:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c99:	83 c0 04             	add    $0x4,%eax
  100c9c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c9f:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ca5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cad:	89 1c 24             	mov    %ebx,(%esp)
  100cb0:	ff d2                	call   *%edx
  100cb2:	eb 23                	jmp    100cd7 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cb4:	ff 45 f4             	incl   -0xc(%ebp)
  100cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cba:	83 f8 02             	cmp    $0x2,%eax
  100cbd:	76 9e                	jbe    100c5d <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cbf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc6:	c7 04 24 df 3a 10 00 	movl   $0x103adf,(%esp)
  100ccd:	e8 c2 f5 ff ff       	call   100294 <cprintf>
    return 0;
  100cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd7:	83 c4 64             	add    $0x64,%esp
  100cda:	5b                   	pop    %ebx
  100cdb:	5d                   	pop    %ebp
  100cdc:	c3                   	ret    

00100cdd <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cdd:	f3 0f 1e fb          	endbr32 
  100ce1:	55                   	push   %ebp
  100ce2:	89 e5                	mov    %esp,%ebp
  100ce4:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ce7:	c7 04 24 f8 3a 10 00 	movl   $0x103af8,(%esp)
  100cee:	e8 a1 f5 ff ff       	call   100294 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cf3:	c7 04 24 20 3b 10 00 	movl   $0x103b20,(%esp)
  100cfa:	e8 95 f5 ff ff       	call   100294 <cprintf>

    if (tf != NULL) {
  100cff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d03:	74 0b                	je     100d10 <kmonitor+0x33>
        print_trapframe(tf);
  100d05:	8b 45 08             	mov    0x8(%ebp),%eax
  100d08:	89 04 24             	mov    %eax,(%esp)
  100d0b:	e8 d6 0d 00 00       	call   101ae6 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d10:	c7 04 24 45 3b 10 00 	movl   $0x103b45,(%esp)
  100d17:	e8 2b f6 ff ff       	call   100347 <readline>
  100d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d23:	74 eb                	je     100d10 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d25:	8b 45 08             	mov    0x8(%ebp),%eax
  100d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d2f:	89 04 24             	mov    %eax,(%esp)
  100d32:	e8 ed fe ff ff       	call   100c24 <runcmd>
  100d37:	85 c0                	test   %eax,%eax
  100d39:	78 02                	js     100d3d <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d3b:	eb d3                	jmp    100d10 <kmonitor+0x33>
                break;
  100d3d:	90                   	nop
            }
        }
    }
}
  100d3e:	90                   	nop
  100d3f:	c9                   	leave  
  100d40:	c3                   	ret    

00100d41 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d41:	f3 0f 1e fb          	endbr32 
  100d45:	55                   	push   %ebp
  100d46:	89 e5                	mov    %esp,%ebp
  100d48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d52:	eb 3d                	jmp    100d91 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d57:	89 d0                	mov    %edx,%eax
  100d59:	01 c0                	add    %eax,%eax
  100d5b:	01 d0                	add    %edx,%eax
  100d5d:	c1 e0 02             	shl    $0x2,%eax
  100d60:	05 04 00 11 00       	add    $0x110004,%eax
  100d65:	8b 08                	mov    (%eax),%ecx
  100d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d6a:	89 d0                	mov    %edx,%eax
  100d6c:	01 c0                	add    %eax,%eax
  100d6e:	01 d0                	add    %edx,%eax
  100d70:	c1 e0 02             	shl    $0x2,%eax
  100d73:	05 00 00 11 00       	add    $0x110000,%eax
  100d78:	8b 00                	mov    (%eax),%eax
  100d7a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d82:	c7 04 24 49 3b 10 00 	movl   $0x103b49,(%esp)
  100d89:	e8 06 f5 ff ff       	call   100294 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d8e:	ff 45 f4             	incl   -0xc(%ebp)
  100d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d94:	83 f8 02             	cmp    $0x2,%eax
  100d97:	76 bb                	jbe    100d54 <mon_help+0x13>
    }
    return 0;
  100d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d9e:	c9                   	leave  
  100d9f:	c3                   	ret    

00100da0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100da0:	f3 0f 1e fb          	endbr32 
  100da4:	55                   	push   %ebp
  100da5:	89 e5                	mov    %esp,%ebp
  100da7:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100daa:	e8 a8 fb ff ff       	call   100957 <print_kerninfo>
    return 0;
  100daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100db4:	c9                   	leave  
  100db5:	c3                   	ret    

00100db6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100db6:	f3 0f 1e fb          	endbr32 
  100dba:	55                   	push   %ebp
  100dbb:	89 e5                	mov    %esp,%ebp
  100dbd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100dc0:	e8 e4 fc ff ff       	call   100aa9 <print_stackframe>
    return 0;
  100dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dca:	c9                   	leave  
  100dcb:	c3                   	ret    

00100dcc <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dcc:	f3 0f 1e fb          	endbr32 
  100dd0:	55                   	push   %ebp
  100dd1:	89 e5                	mov    %esp,%ebp
  100dd3:	83 ec 28             	sub    $0x28,%esp
  100dd6:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100ddc:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100de0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100de4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100de8:	ee                   	out    %al,(%dx)
}
  100de9:	90                   	nop
  100dea:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100df0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100df4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100df8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dfc:	ee                   	out    %al,(%dx)
}
  100dfd:	90                   	nop
  100dfe:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e04:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e08:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e0c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e10:	ee                   	out    %al,(%dx)
}
  100e11:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e12:	c7 05 08 19 11 00 00 	movl   $0x0,0x111908
  100e19:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e1c:	c7 04 24 52 3b 10 00 	movl   $0x103b52,(%esp)
  100e23:	e8 6c f4 ff ff       	call   100294 <cprintf>
    pic_enable(IRQ_TIMER);
  100e28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e2f:	e8 31 09 00 00       	call   101765 <pic_enable>
}
  100e34:	90                   	nop
  100e35:	c9                   	leave  
  100e36:	c3                   	ret    

00100e37 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e37:	f3 0f 1e fb          	endbr32 
  100e3b:	55                   	push   %ebp
  100e3c:	89 e5                	mov    %esp,%ebp
  100e3e:	83 ec 10             	sub    $0x10,%esp
  100e41:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e47:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e4b:	89 c2                	mov    %eax,%edx
  100e4d:	ec                   	in     (%dx),%al
  100e4e:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e51:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e57:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e5b:	89 c2                	mov    %eax,%edx
  100e5d:	ec                   	in     (%dx),%al
  100e5e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e61:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e67:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e6b:	89 c2                	mov    %eax,%edx
  100e6d:	ec                   	in     (%dx),%al
  100e6e:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e71:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e77:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e7b:	89 c2                	mov    %eax,%edx
  100e7d:	ec                   	in     (%dx),%al
  100e7e:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e81:	90                   	nop
  100e82:	c9                   	leave  
  100e83:	c3                   	ret    

00100e84 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e84:	f3 0f 1e fb          	endbr32 
  100e88:	55                   	push   %ebp
  100e89:	89 e5                	mov    %esp,%ebp
  100e8b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e8e:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e98:	0f b7 00             	movzwl (%eax),%eax
  100e9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea2:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	0f b7 00             	movzwl (%eax),%eax
  100ead:	0f b7 c0             	movzwl %ax,%eax
  100eb0:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100eb5:	74 12                	je     100ec9 <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100eb7:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100ebe:	66 c7 05 66 0e 11 00 	movw   $0x3b4,0x110e66
  100ec5:	b4 03 
  100ec7:	eb 13                	jmp    100edc <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ed0:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100ed3:	66 c7 05 66 0e 11 00 	movw   $0x3d4,0x110e66
  100eda:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100edc:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100ee3:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ee7:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eeb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eef:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ef3:	ee                   	out    %al,(%dx)
}
  100ef4:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ef5:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100efc:	40                   	inc    %eax
  100efd:	0f b7 c0             	movzwl %ax,%eax
  100f00:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f04:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f08:	89 c2                	mov    %eax,%edx
  100f0a:	ec                   	in     (%dx),%al
  100f0b:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f0e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f12:	0f b6 c0             	movzbl %al,%eax
  100f15:	c1 e0 08             	shl    $0x8,%eax
  100f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f1b:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f22:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f26:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f2a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f2e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f32:	ee                   	out    %al,(%dx)
}
  100f33:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f34:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f3b:	40                   	inc    %eax
  100f3c:	0f b7 c0             	movzwl %ax,%eax
  100f3f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f43:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f47:	89 c2                	mov    %eax,%edx
  100f49:	ec                   	in     (%dx),%al
  100f4a:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f4d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f51:	0f b6 c0             	movzbl %al,%eax
  100f54:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f5a:	a3 60 0e 11 00       	mov    %eax,0x110e60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f62:	0f b7 c0             	movzwl %ax,%eax
  100f65:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
}
  100f6b:	90                   	nop
  100f6c:	c9                   	leave  
  100f6d:	c3                   	ret    

00100f6e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f6e:	f3 0f 1e fb          	endbr32 
  100f72:	55                   	push   %ebp
  100f73:	89 e5                	mov    %esp,%ebp
  100f75:	83 ec 48             	sub    $0x48,%esp
  100f78:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f7e:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f82:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f86:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f8a:	ee                   	out    %al,(%dx)
}
  100f8b:	90                   	nop
  100f8c:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f92:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f96:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f9a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f9e:	ee                   	out    %al,(%dx)
}
  100f9f:	90                   	nop
  100fa0:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fa6:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100faa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fae:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fb2:	ee                   	out    %al,(%dx)
}
  100fb3:	90                   	nop
  100fb4:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fba:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fbe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fc2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fc6:	ee                   	out    %al,(%dx)
}
  100fc7:	90                   	nop
  100fc8:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fce:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fd2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fd6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fda:	ee                   	out    %al,(%dx)
}
  100fdb:	90                   	nop
  100fdc:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fe2:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fe6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fea:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fee:	ee                   	out    %al,(%dx)
}
  100fef:	90                   	nop
  100ff0:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100ff6:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ffa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ffe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101002:	ee                   	out    %al,(%dx)
}
  101003:	90                   	nop
  101004:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10100a:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10100e:	89 c2                	mov    %eax,%edx
  101010:	ec                   	in     (%dx),%al
  101011:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101014:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101018:	3c ff                	cmp    $0xff,%al
  10101a:	0f 95 c0             	setne  %al
  10101d:	0f b6 c0             	movzbl %al,%eax
  101020:	a3 68 0e 11 00       	mov    %eax,0x110e68
  101025:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10102b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10102f:	89 c2                	mov    %eax,%edx
  101031:	ec                   	in     (%dx),%al
  101032:	88 45 f1             	mov    %al,-0xf(%ebp)
  101035:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10103b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10103f:	89 c2                	mov    %eax,%edx
  101041:	ec                   	in     (%dx),%al
  101042:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101045:	a1 68 0e 11 00       	mov    0x110e68,%eax
  10104a:	85 c0                	test   %eax,%eax
  10104c:	74 0c                	je     10105a <serial_init+0xec>
        pic_enable(IRQ_COM1);
  10104e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101055:	e8 0b 07 00 00       	call   101765 <pic_enable>
    }
}
  10105a:	90                   	nop
  10105b:	c9                   	leave  
  10105c:	c3                   	ret    

0010105d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10105d:	f3 0f 1e fb          	endbr32 
  101061:	55                   	push   %ebp
  101062:	89 e5                	mov    %esp,%ebp
  101064:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101067:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10106e:	eb 08                	jmp    101078 <lpt_putc_sub+0x1b>
        delay();
  101070:	e8 c2 fd ff ff       	call   100e37 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101075:	ff 45 fc             	incl   -0x4(%ebp)
  101078:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10107e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101082:	89 c2                	mov    %eax,%edx
  101084:	ec                   	in     (%dx),%al
  101085:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101088:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10108c:	84 c0                	test   %al,%al
  10108e:	78 09                	js     101099 <lpt_putc_sub+0x3c>
  101090:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101097:	7e d7                	jle    101070 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  101099:	8b 45 08             	mov    0x8(%ebp),%eax
  10109c:	0f b6 c0             	movzbl %al,%eax
  10109f:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010a5:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010a8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010ac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b0:	ee                   	out    %al,(%dx)
}
  1010b1:	90                   	nop
  1010b2:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010b8:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010bc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010c0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010c4:	ee                   	out    %al,(%dx)
}
  1010c5:	90                   	nop
  1010c6:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010cc:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010d0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010d4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010d8:	ee                   	out    %al,(%dx)
}
  1010d9:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010da:	90                   	nop
  1010db:	c9                   	leave  
  1010dc:	c3                   	ret    

001010dd <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010dd:	f3 0f 1e fb          	endbr32 
  1010e1:	55                   	push   %ebp
  1010e2:	89 e5                	mov    %esp,%ebp
  1010e4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010e7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010eb:	74 0d                	je     1010fa <lpt_putc+0x1d>
        lpt_putc_sub(c);
  1010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f0:	89 04 24             	mov    %eax,(%esp)
  1010f3:	e8 65 ff ff ff       	call   10105d <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010f8:	eb 24                	jmp    10111e <lpt_putc+0x41>
        lpt_putc_sub('\b');
  1010fa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101101:	e8 57 ff ff ff       	call   10105d <lpt_putc_sub>
        lpt_putc_sub(' ');
  101106:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10110d:	e8 4b ff ff ff       	call   10105d <lpt_putc_sub>
        lpt_putc_sub('\b');
  101112:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101119:	e8 3f ff ff ff       	call   10105d <lpt_putc_sub>
}
  10111e:	90                   	nop
  10111f:	c9                   	leave  
  101120:	c3                   	ret    

00101121 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101121:	f3 0f 1e fb          	endbr32 
  101125:	55                   	push   %ebp
  101126:	89 e5                	mov    %esp,%ebp
  101128:	53                   	push   %ebx
  101129:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10112c:	8b 45 08             	mov    0x8(%ebp),%eax
  10112f:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101134:	85 c0                	test   %eax,%eax
  101136:	75 07                	jne    10113f <cga_putc+0x1e>
        c |= 0x0700;
  101138:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10113f:	8b 45 08             	mov    0x8(%ebp),%eax
  101142:	0f b6 c0             	movzbl %al,%eax
  101145:	83 f8 0d             	cmp    $0xd,%eax
  101148:	74 72                	je     1011bc <cga_putc+0x9b>
  10114a:	83 f8 0d             	cmp    $0xd,%eax
  10114d:	0f 8f a3 00 00 00    	jg     1011f6 <cga_putc+0xd5>
  101153:	83 f8 08             	cmp    $0x8,%eax
  101156:	74 0a                	je     101162 <cga_putc+0x41>
  101158:	83 f8 0a             	cmp    $0xa,%eax
  10115b:	74 4c                	je     1011a9 <cga_putc+0x88>
  10115d:	e9 94 00 00 00       	jmp    1011f6 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  101162:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101169:	85 c0                	test   %eax,%eax
  10116b:	0f 84 af 00 00 00    	je     101220 <cga_putc+0xff>
            crt_pos --;
  101171:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101178:	48                   	dec    %eax
  101179:	0f b7 c0             	movzwl %ax,%eax
  10117c:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101182:	8b 45 08             	mov    0x8(%ebp),%eax
  101185:	98                   	cwtl   
  101186:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10118b:	98                   	cwtl   
  10118c:	83 c8 20             	or     $0x20,%eax
  10118f:	98                   	cwtl   
  101190:	8b 15 60 0e 11 00    	mov    0x110e60,%edx
  101196:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  10119d:	01 c9                	add    %ecx,%ecx
  10119f:	01 ca                	add    %ecx,%edx
  1011a1:	0f b7 c0             	movzwl %ax,%eax
  1011a4:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011a7:	eb 77                	jmp    101220 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  1011a9:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011b0:	83 c0 50             	add    $0x50,%eax
  1011b3:	0f b7 c0             	movzwl %ax,%eax
  1011b6:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011bc:	0f b7 1d 64 0e 11 00 	movzwl 0x110e64,%ebx
  1011c3:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011ca:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011cf:	89 c8                	mov    %ecx,%eax
  1011d1:	f7 e2                	mul    %edx
  1011d3:	c1 ea 06             	shr    $0x6,%edx
  1011d6:	89 d0                	mov    %edx,%eax
  1011d8:	c1 e0 02             	shl    $0x2,%eax
  1011db:	01 d0                	add    %edx,%eax
  1011dd:	c1 e0 04             	shl    $0x4,%eax
  1011e0:	29 c1                	sub    %eax,%ecx
  1011e2:	89 c8                	mov    %ecx,%eax
  1011e4:	0f b7 c0             	movzwl %ax,%eax
  1011e7:	29 c3                	sub    %eax,%ebx
  1011e9:	89 d8                	mov    %ebx,%eax
  1011eb:	0f b7 c0             	movzwl %ax,%eax
  1011ee:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
        break;
  1011f4:	eb 2b                	jmp    101221 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011f6:	8b 0d 60 0e 11 00    	mov    0x110e60,%ecx
  1011fc:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101203:	8d 50 01             	lea    0x1(%eax),%edx
  101206:	0f b7 d2             	movzwl %dx,%edx
  101209:	66 89 15 64 0e 11 00 	mov    %dx,0x110e64
  101210:	01 c0                	add    %eax,%eax
  101212:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101215:	8b 45 08             	mov    0x8(%ebp),%eax
  101218:	0f b7 c0             	movzwl %ax,%eax
  10121b:	66 89 02             	mov    %ax,(%edx)
        break;
  10121e:	eb 01                	jmp    101221 <cga_putc+0x100>
        break;
  101220:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101221:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101228:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10122d:	76 5d                	jbe    10128c <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10122f:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101234:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10123a:	a1 60 0e 11 00       	mov    0x110e60,%eax
  10123f:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101246:	00 
  101247:	89 54 24 04          	mov    %edx,0x4(%esp)
  10124b:	89 04 24             	mov    %eax,(%esp)
  10124e:	e8 f3 1d 00 00       	call   103046 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101253:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10125a:	eb 14                	jmp    101270 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  10125c:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101264:	01 d2                	add    %edx,%edx
  101266:	01 d0                	add    %edx,%eax
  101268:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10126d:	ff 45 f4             	incl   -0xc(%ebp)
  101270:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101277:	7e e3                	jle    10125c <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  101279:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101280:	83 e8 50             	sub    $0x50,%eax
  101283:	0f b7 c0             	movzwl %ax,%eax
  101286:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10128c:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  101293:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101297:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10129b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10129f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012a3:	ee                   	out    %al,(%dx)
}
  1012a4:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012a5:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012ac:	c1 e8 08             	shr    $0x8,%eax
  1012af:	0f b7 c0             	movzwl %ax,%eax
  1012b2:	0f b6 c0             	movzbl %al,%eax
  1012b5:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012bc:	42                   	inc    %edx
  1012bd:	0f b7 d2             	movzwl %dx,%edx
  1012c0:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012c4:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012cb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012cf:	ee                   	out    %al,(%dx)
}
  1012d0:	90                   	nop
    outb(addr_6845, 15);
  1012d1:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  1012d8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012dc:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012e0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012e4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012e8:	ee                   	out    %al,(%dx)
}
  1012e9:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012ea:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012f1:	0f b6 c0             	movzbl %al,%eax
  1012f4:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012fb:	42                   	inc    %edx
  1012fc:	0f b7 d2             	movzwl %dx,%edx
  1012ff:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101303:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101306:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10130a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10130e:	ee                   	out    %al,(%dx)
}
  10130f:	90                   	nop
}
  101310:	90                   	nop
  101311:	83 c4 34             	add    $0x34,%esp
  101314:	5b                   	pop    %ebx
  101315:	5d                   	pop    %ebp
  101316:	c3                   	ret    

00101317 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101317:	f3 0f 1e fb          	endbr32 
  10131b:	55                   	push   %ebp
  10131c:	89 e5                	mov    %esp,%ebp
  10131e:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101321:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101328:	eb 08                	jmp    101332 <serial_putc_sub+0x1b>
        delay();
  10132a:	e8 08 fb ff ff       	call   100e37 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10132f:	ff 45 fc             	incl   -0x4(%ebp)
  101332:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101338:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10133c:	89 c2                	mov    %eax,%edx
  10133e:	ec                   	in     (%dx),%al
  10133f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101342:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101346:	0f b6 c0             	movzbl %al,%eax
  101349:	83 e0 20             	and    $0x20,%eax
  10134c:	85 c0                	test   %eax,%eax
  10134e:	75 09                	jne    101359 <serial_putc_sub+0x42>
  101350:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101357:	7e d1                	jle    10132a <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  101359:	8b 45 08             	mov    0x8(%ebp),%eax
  10135c:	0f b6 c0             	movzbl %al,%eax
  10135f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101365:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101368:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10136c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101370:	ee                   	out    %al,(%dx)
}
  101371:	90                   	nop
}
  101372:	90                   	nop
  101373:	c9                   	leave  
  101374:	c3                   	ret    

00101375 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101375:	f3 0f 1e fb          	endbr32 
  101379:	55                   	push   %ebp
  10137a:	89 e5                	mov    %esp,%ebp
  10137c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10137f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101383:	74 0d                	je     101392 <serial_putc+0x1d>
        serial_putc_sub(c);
  101385:	8b 45 08             	mov    0x8(%ebp),%eax
  101388:	89 04 24             	mov    %eax,(%esp)
  10138b:	e8 87 ff ff ff       	call   101317 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101390:	eb 24                	jmp    1013b6 <serial_putc+0x41>
        serial_putc_sub('\b');
  101392:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101399:	e8 79 ff ff ff       	call   101317 <serial_putc_sub>
        serial_putc_sub(' ');
  10139e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013a5:	e8 6d ff ff ff       	call   101317 <serial_putc_sub>
        serial_putc_sub('\b');
  1013aa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013b1:	e8 61 ff ff ff       	call   101317 <serial_putc_sub>
}
  1013b6:	90                   	nop
  1013b7:	c9                   	leave  
  1013b8:	c3                   	ret    

001013b9 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013b9:	f3 0f 1e fb          	endbr32 
  1013bd:	55                   	push   %ebp
  1013be:	89 e5                	mov    %esp,%ebp
  1013c0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013c3:	eb 33                	jmp    1013f8 <cons_intr+0x3f>
        if (c != 0) {
  1013c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013c9:	74 2d                	je     1013f8 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013cb:	a1 84 10 11 00       	mov    0x111084,%eax
  1013d0:	8d 50 01             	lea    0x1(%eax),%edx
  1013d3:	89 15 84 10 11 00    	mov    %edx,0x111084
  1013d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013dc:	88 90 80 0e 11 00    	mov    %dl,0x110e80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013e2:	a1 84 10 11 00       	mov    0x111084,%eax
  1013e7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013ec:	75 0a                	jne    1013f8 <cons_intr+0x3f>
                cons.wpos = 0;
  1013ee:	c7 05 84 10 11 00 00 	movl   $0x0,0x111084
  1013f5:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1013fb:	ff d0                	call   *%eax
  1013fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101400:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101404:	75 bf                	jne    1013c5 <cons_intr+0xc>
            }
        }
    }
}
  101406:	90                   	nop
  101407:	90                   	nop
  101408:	c9                   	leave  
  101409:	c3                   	ret    

0010140a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10140a:	f3 0f 1e fb          	endbr32 
  10140e:	55                   	push   %ebp
  10140f:	89 e5                	mov    %esp,%ebp
  101411:	83 ec 10             	sub    $0x10,%esp
  101414:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10141a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10141e:	89 c2                	mov    %eax,%edx
  101420:	ec                   	in     (%dx),%al
  101421:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101424:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101428:	0f b6 c0             	movzbl %al,%eax
  10142b:	83 e0 01             	and    $0x1,%eax
  10142e:	85 c0                	test   %eax,%eax
  101430:	75 07                	jne    101439 <serial_proc_data+0x2f>
        return -1;
  101432:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101437:	eb 2a                	jmp    101463 <serial_proc_data+0x59>
  101439:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10143f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101443:	89 c2                	mov    %eax,%edx
  101445:	ec                   	in     (%dx),%al
  101446:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101449:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10144d:	0f b6 c0             	movzbl %al,%eax
  101450:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101453:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101457:	75 07                	jne    101460 <serial_proc_data+0x56>
        c = '\b';
  101459:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101460:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101463:	c9                   	leave  
  101464:	c3                   	ret    

00101465 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101465:	f3 0f 1e fb          	endbr32 
  101469:	55                   	push   %ebp
  10146a:	89 e5                	mov    %esp,%ebp
  10146c:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10146f:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101474:	85 c0                	test   %eax,%eax
  101476:	74 0c                	je     101484 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101478:	c7 04 24 0a 14 10 00 	movl   $0x10140a,(%esp)
  10147f:	e8 35 ff ff ff       	call   1013b9 <cons_intr>
    }
}
  101484:	90                   	nop
  101485:	c9                   	leave  
  101486:	c3                   	ret    

00101487 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101487:	f3 0f 1e fb          	endbr32 
  10148b:	55                   	push   %ebp
  10148c:	89 e5                	mov    %esp,%ebp
  10148e:	83 ec 38             	sub    $0x38,%esp
  101491:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10149a:	89 c2                	mov    %eax,%edx
  10149c:	ec                   	in     (%dx),%al
  10149d:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014a4:	0f b6 c0             	movzbl %al,%eax
  1014a7:	83 e0 01             	and    $0x1,%eax
  1014aa:	85 c0                	test   %eax,%eax
  1014ac:	75 0a                	jne    1014b8 <kbd_proc_data+0x31>
        return -1;
  1014ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014b3:	e9 56 01 00 00       	jmp    10160e <kbd_proc_data+0x187>
  1014b8:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014c1:	89 c2                	mov    %eax,%edx
  1014c3:	ec                   	in     (%dx),%al
  1014c4:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014c7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014cb:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014ce:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014d2:	75 17                	jne    1014eb <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  1014d4:	a1 88 10 11 00       	mov    0x111088,%eax
  1014d9:	83 c8 40             	or     $0x40,%eax
  1014dc:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  1014e1:	b8 00 00 00 00       	mov    $0x0,%eax
  1014e6:	e9 23 01 00 00       	jmp    10160e <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ef:	84 c0                	test   %al,%al
  1014f1:	79 45                	jns    101538 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014f3:	a1 88 10 11 00       	mov    0x111088,%eax
  1014f8:	83 e0 40             	and    $0x40,%eax
  1014fb:	85 c0                	test   %eax,%eax
  1014fd:	75 08                	jne    101507 <kbd_proc_data+0x80>
  1014ff:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101503:	24 7f                	and    $0x7f,%al
  101505:	eb 04                	jmp    10150b <kbd_proc_data+0x84>
  101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10150e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101512:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101519:	0c 40                	or     $0x40,%al
  10151b:	0f b6 c0             	movzbl %al,%eax
  10151e:	f7 d0                	not    %eax
  101520:	89 c2                	mov    %eax,%edx
  101522:	a1 88 10 11 00       	mov    0x111088,%eax
  101527:	21 d0                	and    %edx,%eax
  101529:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  10152e:	b8 00 00 00 00       	mov    $0x0,%eax
  101533:	e9 d6 00 00 00       	jmp    10160e <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101538:	a1 88 10 11 00       	mov    0x111088,%eax
  10153d:	83 e0 40             	and    $0x40,%eax
  101540:	85 c0                	test   %eax,%eax
  101542:	74 11                	je     101555 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101544:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101548:	a1 88 10 11 00       	mov    0x111088,%eax
  10154d:	83 e0 bf             	and    $0xffffffbf,%eax
  101550:	a3 88 10 11 00       	mov    %eax,0x111088
    }

    shift |= shiftcode[data];
  101555:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101559:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101560:	0f b6 d0             	movzbl %al,%edx
  101563:	a1 88 10 11 00       	mov    0x111088,%eax
  101568:	09 d0                	or     %edx,%eax
  10156a:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  10156f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101573:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  10157a:	0f b6 d0             	movzbl %al,%edx
  10157d:	a1 88 10 11 00       	mov    0x111088,%eax
  101582:	31 d0                	xor    %edx,%eax
  101584:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  101589:	a1 88 10 11 00       	mov    0x111088,%eax
  10158e:	83 e0 03             	and    $0x3,%eax
  101591:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  101598:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10159c:	01 d0                	add    %edx,%eax
  10159e:	0f b6 00             	movzbl (%eax),%eax
  1015a1:	0f b6 c0             	movzbl %al,%eax
  1015a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015a7:	a1 88 10 11 00       	mov    0x111088,%eax
  1015ac:	83 e0 08             	and    $0x8,%eax
  1015af:	85 c0                	test   %eax,%eax
  1015b1:	74 22                	je     1015d5 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015b3:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015b7:	7e 0c                	jle    1015c5 <kbd_proc_data+0x13e>
  1015b9:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015bd:	7f 06                	jg     1015c5 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015bf:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015c3:	eb 10                	jmp    1015d5 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015c5:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015c9:	7e 0a                	jle    1015d5 <kbd_proc_data+0x14e>
  1015cb:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015cf:	7f 04                	jg     1015d5 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015d1:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015d5:	a1 88 10 11 00       	mov    0x111088,%eax
  1015da:	f7 d0                	not    %eax
  1015dc:	83 e0 06             	and    $0x6,%eax
  1015df:	85 c0                	test   %eax,%eax
  1015e1:	75 28                	jne    10160b <kbd_proc_data+0x184>
  1015e3:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015ea:	75 1f                	jne    10160b <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015ec:	c7 04 24 6d 3b 10 00 	movl   $0x103b6d,(%esp)
  1015f3:	e8 9c ec ff ff       	call   100294 <cprintf>
  1015f8:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015fe:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101602:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101606:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101609:	ee                   	out    %al,(%dx)
}
  10160a:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10160e:	c9                   	leave  
  10160f:	c3                   	ret    

00101610 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101610:	f3 0f 1e fb          	endbr32 
  101614:	55                   	push   %ebp
  101615:	89 e5                	mov    %esp,%ebp
  101617:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10161a:	c7 04 24 87 14 10 00 	movl   $0x101487,(%esp)
  101621:	e8 93 fd ff ff       	call   1013b9 <cons_intr>
}
  101626:	90                   	nop
  101627:	c9                   	leave  
  101628:	c3                   	ret    

00101629 <kbd_init>:

static void
kbd_init(void) {
  101629:	f3 0f 1e fb          	endbr32 
  10162d:	55                   	push   %ebp
  10162e:	89 e5                	mov    %esp,%ebp
  101630:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101633:	e8 d8 ff ff ff       	call   101610 <kbd_intr>
    pic_enable(IRQ_KBD);
  101638:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10163f:	e8 21 01 00 00       	call   101765 <pic_enable>
}
  101644:	90                   	nop
  101645:	c9                   	leave  
  101646:	c3                   	ret    

00101647 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101647:	f3 0f 1e fb          	endbr32 
  10164b:	55                   	push   %ebp
  10164c:	89 e5                	mov    %esp,%ebp
  10164e:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101651:	e8 2e f8 ff ff       	call   100e84 <cga_init>
    serial_init();
  101656:	e8 13 f9 ff ff       	call   100f6e <serial_init>
    kbd_init();
  10165b:	e8 c9 ff ff ff       	call   101629 <kbd_init>
    if (!serial_exists) {
  101660:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101665:	85 c0                	test   %eax,%eax
  101667:	75 0c                	jne    101675 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101669:	c7 04 24 79 3b 10 00 	movl   $0x103b79,(%esp)
  101670:	e8 1f ec ff ff       	call   100294 <cprintf>
    }
}
  101675:	90                   	nop
  101676:	c9                   	leave  
  101677:	c3                   	ret    

00101678 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101678:	f3 0f 1e fb          	endbr32 
  10167c:	55                   	push   %ebp
  10167d:	89 e5                	mov    %esp,%ebp
  10167f:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101682:	8b 45 08             	mov    0x8(%ebp),%eax
  101685:	89 04 24             	mov    %eax,(%esp)
  101688:	e8 50 fa ff ff       	call   1010dd <lpt_putc>
    cga_putc(c);
  10168d:	8b 45 08             	mov    0x8(%ebp),%eax
  101690:	89 04 24             	mov    %eax,(%esp)
  101693:	e8 89 fa ff ff       	call   101121 <cga_putc>
    serial_putc(c);
  101698:	8b 45 08             	mov    0x8(%ebp),%eax
  10169b:	89 04 24             	mov    %eax,(%esp)
  10169e:	e8 d2 fc ff ff       	call   101375 <serial_putc>
}
  1016a3:	90                   	nop
  1016a4:	c9                   	leave  
  1016a5:	c3                   	ret    

001016a6 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016a6:	f3 0f 1e fb          	endbr32 
  1016aa:	55                   	push   %ebp
  1016ab:	89 e5                	mov    %esp,%ebp
  1016ad:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016b0:	e8 b0 fd ff ff       	call   101465 <serial_intr>
    kbd_intr();
  1016b5:	e8 56 ff ff ff       	call   101610 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016ba:	8b 15 80 10 11 00    	mov    0x111080,%edx
  1016c0:	a1 84 10 11 00       	mov    0x111084,%eax
  1016c5:	39 c2                	cmp    %eax,%edx
  1016c7:	74 36                	je     1016ff <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016c9:	a1 80 10 11 00       	mov    0x111080,%eax
  1016ce:	8d 50 01             	lea    0x1(%eax),%edx
  1016d1:	89 15 80 10 11 00    	mov    %edx,0x111080
  1016d7:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  1016de:	0f b6 c0             	movzbl %al,%eax
  1016e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016e4:	a1 80 10 11 00       	mov    0x111080,%eax
  1016e9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016ee:	75 0a                	jne    1016fa <cons_getc+0x54>
            cons.rpos = 0;
  1016f0:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  1016f7:	00 00 00 
        }
        return c;
  1016fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016fd:	eb 05                	jmp    101704 <cons_getc+0x5e>
    }
    return 0;
  1016ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101704:	c9                   	leave  
  101705:	c3                   	ret    

00101706 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101706:	f3 0f 1e fb          	endbr32 
  10170a:	55                   	push   %ebp
  10170b:	89 e5                	mov    %esp,%ebp
  10170d:	83 ec 14             	sub    $0x14,%esp
  101710:	8b 45 08             	mov    0x8(%ebp),%eax
  101713:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10171a:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  101720:	a1 8c 10 11 00       	mov    0x11108c,%eax
  101725:	85 c0                	test   %eax,%eax
  101727:	74 39                	je     101762 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  101729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10172c:	0f b6 c0             	movzbl %al,%eax
  10172f:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101735:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101738:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10173c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101740:	ee                   	out    %al,(%dx)
}
  101741:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101742:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101746:	c1 e8 08             	shr    $0x8,%eax
  101749:	0f b7 c0             	movzwl %ax,%eax
  10174c:	0f b6 c0             	movzbl %al,%eax
  10174f:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101755:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101758:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
}
  101761:	90                   	nop
    }
}
  101762:	90                   	nop
  101763:	c9                   	leave  
  101764:	c3                   	ret    

00101765 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101765:	f3 0f 1e fb          	endbr32 
  101769:	55                   	push   %ebp
  10176a:	89 e5                	mov    %esp,%ebp
  10176c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10176f:	8b 45 08             	mov    0x8(%ebp),%eax
  101772:	ba 01 00 00 00       	mov    $0x1,%edx
  101777:	88 c1                	mov    %al,%cl
  101779:	d3 e2                	shl    %cl,%edx
  10177b:	89 d0                	mov    %edx,%eax
  10177d:	98                   	cwtl   
  10177e:	f7 d0                	not    %eax
  101780:	0f bf d0             	movswl %ax,%edx
  101783:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  10178a:	98                   	cwtl   
  10178b:	21 d0                	and    %edx,%eax
  10178d:	98                   	cwtl   
  10178e:	0f b7 c0             	movzwl %ax,%eax
  101791:	89 04 24             	mov    %eax,(%esp)
  101794:	e8 6d ff ff ff       	call   101706 <pic_setmask>
}
  101799:	90                   	nop
  10179a:	c9                   	leave  
  10179b:	c3                   	ret    

0010179c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10179c:	f3 0f 1e fb          	endbr32 
  1017a0:	55                   	push   %ebp
  1017a1:	89 e5                	mov    %esp,%ebp
  1017a3:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017a6:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  1017ad:	00 00 00 
  1017b0:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017b6:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ba:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017be:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017c2:	ee                   	out    %al,(%dx)
}
  1017c3:	90                   	nop
  1017c4:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017ca:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ce:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017d2:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017d6:	ee                   	out    %al,(%dx)
}
  1017d7:	90                   	nop
  1017d8:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017de:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e2:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017e6:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
}
  1017eb:	90                   	nop
  1017ec:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017f2:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f6:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017fa:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017fe:	ee                   	out    %al,(%dx)
}
  1017ff:	90                   	nop
  101800:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101806:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10180a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10180e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101812:	ee                   	out    %al,(%dx)
}
  101813:	90                   	nop
  101814:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10181a:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10181e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101822:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101826:	ee                   	out    %al,(%dx)
}
  101827:	90                   	nop
  101828:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10182e:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101832:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101836:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10183a:	ee                   	out    %al,(%dx)
}
  10183b:	90                   	nop
  10183c:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101842:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101846:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10184a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
}
  10184f:	90                   	nop
  101850:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101856:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10185a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10185e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101862:	ee                   	out    %al,(%dx)
}
  101863:	90                   	nop
  101864:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10186a:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10186e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101872:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101876:	ee                   	out    %al,(%dx)
}
  101877:	90                   	nop
  101878:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10187e:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101882:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101886:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10188a:	ee                   	out    %al,(%dx)
}
  10188b:	90                   	nop
  10188c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101892:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101896:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10189a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10189e:	ee                   	out    %al,(%dx)
}
  10189f:	90                   	nop
  1018a0:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018a6:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018aa:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018ae:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018b2:	ee                   	out    %al,(%dx)
}
  1018b3:	90                   	nop
  1018b4:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018ba:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018be:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018c2:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018c6:	ee                   	out    %al,(%dx)
}
  1018c7:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018c8:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018cf:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1018d4:	74 0f                	je     1018e5 <pic_init+0x149>
        pic_setmask(irq_mask);
  1018d6:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018dd:	89 04 24             	mov    %eax,(%esp)
  1018e0:	e8 21 fe ff ff       	call   101706 <pic_setmask>
    }
}
  1018e5:	90                   	nop
  1018e6:	c9                   	leave  
  1018e7:	c3                   	ret    

001018e8 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1018e8:	f3 0f 1e fb          	endbr32 
  1018ec:	55                   	push   %ebp
  1018ed:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018ef:	fb                   	sti    
}
  1018f0:	90                   	nop
    sti();
}
  1018f1:	90                   	nop
  1018f2:	5d                   	pop    %ebp
  1018f3:	c3                   	ret    

001018f4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1018f4:	f3 0f 1e fb          	endbr32 
  1018f8:	55                   	push   %ebp
  1018f9:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1018fb:	fa                   	cli    
}
  1018fc:	90                   	nop
    cli();
}
  1018fd:	90                   	nop
  1018fe:	5d                   	pop    %ebp
  1018ff:	c3                   	ret    

00101900 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  101900:	f3 0f 1e fb          	endbr32 
  101904:	55                   	push   %ebp
  101905:	89 e5                	mov    %esp,%ebp
  101907:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10190a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101911:	00 
  101912:	c7 04 24 a0 3b 10 00 	movl   $0x103ba0,(%esp)
  101919:	e8 76 e9 ff ff       	call   100294 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10191e:	90                   	nop
  10191f:	c9                   	leave  
  101920:	c3                   	ret    

00101921 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101921:	f3 0f 1e fb          	endbr32 
  101925:	55                   	push   %ebp
  101926:	89 e5                	mov    %esp,%ebp
  101928:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10192b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101932:	e9 c4 00 00 00       	jmp    1019fb <idt_init+0xda>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101937:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193a:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101941:	0f b7 d0             	movzwl %ax,%edx
  101944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101947:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  10194e:	00 
  10194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101952:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  101959:	00 08 00 
  10195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195f:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  101966:	00 
  101967:	80 e2 e0             	and    $0xe0,%dl
  10196a:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  101971:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101974:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  10197b:	00 
  10197c:	80 e2 1f             	and    $0x1f,%dl
  10197f:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  101986:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101989:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101990:	00 
  101991:	80 e2 f0             	and    $0xf0,%dl
  101994:	80 ca 0e             	or     $0xe,%dl
  101997:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  10199e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a1:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019a8:	00 
  1019a9:	80 e2 ef             	and    $0xef,%dl
  1019ac:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b6:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019bd:	00 
  1019be:	80 e2 9f             	and    $0x9f,%dl
  1019c1:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019cb:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019d2:	00 
  1019d3:	80 ca 80             	or     $0x80,%dl
  1019d6:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e0:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  1019e7:	c1 e8 10             	shr    $0x10,%eax
  1019ea:	0f b7 d0             	movzwl %ax,%edx
  1019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f0:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  1019f7:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019f8:	ff 45 fc             	incl   -0x4(%ebp)
  1019fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fe:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a03:	0f 86 2e ff ff ff    	jbe    101937 <idt_init+0x16>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a09:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a0e:	0f b7 c0             	movzwl %ax,%eax
  101a11:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101a17:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101a1e:	08 00 
  101a20:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a27:	24 e0                	and    $0xe0,%al
  101a29:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a2e:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a35:	24 1f                	and    $0x1f,%al
  101a37:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a3c:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a43:	24 f0                	and    $0xf0,%al
  101a45:	0c 0e                	or     $0xe,%al
  101a47:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a4c:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a53:	24 ef                	and    $0xef,%al
  101a55:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a5a:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a61:	0c 60                	or     $0x60,%al
  101a63:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a68:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a6f:	0c 80                	or     $0x80,%al
  101a71:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a76:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a7b:	c1 e8 10             	shr    $0x10,%eax
  101a7e:	0f b7 c0             	movzwl %ax,%eax
  101a81:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
  101a87:	c7 45 f8 60 05 11 00 	movl   $0x110560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a91:	0f 01 18             	lidtl  (%eax)
}
  101a94:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
  101a95:	90                   	nop
  101a96:	c9                   	leave  
  101a97:	c3                   	ret    

00101a98 <trapname>:

static const char *
trapname(int trapno) {
  101a98:	f3 0f 1e fb          	endbr32 
  101a9c:	55                   	push   %ebp
  101a9d:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	83 f8 13             	cmp    $0x13,%eax
  101aa5:	77 0c                	ja     101ab3 <trapname+0x1b>
        return excnames[trapno];
  101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aaa:	8b 04 85 40 3f 10 00 	mov    0x103f40(,%eax,4),%eax
  101ab1:	eb 18                	jmp    101acb <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ab3:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ab7:	7e 0d                	jle    101ac6 <trapname+0x2e>
  101ab9:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101abd:	7f 07                	jg     101ac6 <trapname+0x2e>
        return "Hardware Interrupt";
  101abf:	b8 aa 3b 10 00       	mov    $0x103baa,%eax
  101ac4:	eb 05                	jmp    101acb <trapname+0x33>
    }
    return "(unknown trap)";
  101ac6:	b8 bd 3b 10 00       	mov    $0x103bbd,%eax
}
  101acb:	5d                   	pop    %ebp
  101acc:	c3                   	ret    

00101acd <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101acd:	f3 0f 1e fb          	endbr32 
  101ad1:	55                   	push   %ebp
  101ad2:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101adb:	83 f8 08             	cmp    $0x8,%eax
  101ade:	0f 94 c0             	sete   %al
  101ae1:	0f b6 c0             	movzbl %al,%eax
}
  101ae4:	5d                   	pop    %ebp
  101ae5:	c3                   	ret    

00101ae6 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101ae6:	f3 0f 1e fb          	endbr32 
  101aea:	55                   	push   %ebp
  101aeb:	89 e5                	mov    %esp,%ebp
  101aed:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101af0:	8b 45 08             	mov    0x8(%ebp),%eax
  101af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af7:	c7 04 24 fe 3b 10 00 	movl   $0x103bfe,(%esp)
  101afe:	e8 91 e7 ff ff       	call   100294 <cprintf>
    print_regs(&tf->tf_regs);
  101b03:	8b 45 08             	mov    0x8(%ebp),%eax
  101b06:	89 04 24             	mov    %eax,(%esp)
  101b09:	e8 8d 01 00 00       	call   101c9b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b11:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b19:	c7 04 24 0f 3c 10 00 	movl   $0x103c0f,(%esp)
  101b20:	e8 6f e7 ff ff       	call   100294 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b25:	8b 45 08             	mov    0x8(%ebp),%eax
  101b28:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b30:	c7 04 24 22 3c 10 00 	movl   $0x103c22,(%esp)
  101b37:	e8 58 e7 ff ff       	call   100294 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b47:	c7 04 24 35 3c 10 00 	movl   $0x103c35,(%esp)
  101b4e:	e8 41 e7 ff ff       	call   100294 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b53:	8b 45 08             	mov    0x8(%ebp),%eax
  101b56:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5e:	c7 04 24 48 3c 10 00 	movl   $0x103c48,(%esp)
  101b65:	e8 2a e7 ff ff       	call   100294 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6d:	8b 40 30             	mov    0x30(%eax),%eax
  101b70:	89 04 24             	mov    %eax,(%esp)
  101b73:	e8 20 ff ff ff       	call   101a98 <trapname>
  101b78:	8b 55 08             	mov    0x8(%ebp),%edx
  101b7b:	8b 52 30             	mov    0x30(%edx),%edx
  101b7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b82:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b86:	c7 04 24 5b 3c 10 00 	movl   $0x103c5b,(%esp)
  101b8d:	e8 02 e7 ff ff       	call   100294 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b92:	8b 45 08             	mov    0x8(%ebp),%eax
  101b95:	8b 40 34             	mov    0x34(%eax),%eax
  101b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9c:	c7 04 24 6d 3c 10 00 	movl   $0x103c6d,(%esp)
  101ba3:	e8 ec e6 ff ff       	call   100294 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bab:	8b 40 38             	mov    0x38(%eax),%eax
  101bae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb2:	c7 04 24 7c 3c 10 00 	movl   $0x103c7c,(%esp)
  101bb9:	e8 d6 e6 ff ff       	call   100294 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc9:	c7 04 24 8b 3c 10 00 	movl   $0x103c8b,(%esp)
  101bd0:	e8 bf e6 ff ff       	call   100294 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd8:	8b 40 40             	mov    0x40(%eax),%eax
  101bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdf:	c7 04 24 9e 3c 10 00 	movl   $0x103c9e,(%esp)
  101be6:	e8 a9 e6 ff ff       	call   100294 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bf2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bf9:	eb 3d                	jmp    101c38 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfe:	8b 50 40             	mov    0x40(%eax),%edx
  101c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c04:	21 d0                	and    %edx,%eax
  101c06:	85 c0                	test   %eax,%eax
  101c08:	74 28                	je     101c32 <print_trapframe+0x14c>
  101c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c0d:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c14:	85 c0                	test   %eax,%eax
  101c16:	74 1a                	je     101c32 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c1b:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c26:	c7 04 24 ad 3c 10 00 	movl   $0x103cad,(%esp)
  101c2d:	e8 62 e6 ff ff       	call   100294 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c32:	ff 45 f4             	incl   -0xc(%ebp)
  101c35:	d1 65 f0             	shll   -0x10(%ebp)
  101c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c3b:	83 f8 17             	cmp    $0x17,%eax
  101c3e:	76 bb                	jbe    101bfb <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c40:	8b 45 08             	mov    0x8(%ebp),%eax
  101c43:	8b 40 40             	mov    0x40(%eax),%eax
  101c46:	c1 e8 0c             	shr    $0xc,%eax
  101c49:	83 e0 03             	and    $0x3,%eax
  101c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c50:	c7 04 24 b1 3c 10 00 	movl   $0x103cb1,(%esp)
  101c57:	e8 38 e6 ff ff       	call   100294 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5f:	89 04 24             	mov    %eax,(%esp)
  101c62:	e8 66 fe ff ff       	call   101acd <trap_in_kernel>
  101c67:	85 c0                	test   %eax,%eax
  101c69:	75 2d                	jne    101c98 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6e:	8b 40 44             	mov    0x44(%eax),%eax
  101c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c75:	c7 04 24 ba 3c 10 00 	movl   $0x103cba,(%esp)
  101c7c:	e8 13 e6 ff ff       	call   100294 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c81:	8b 45 08             	mov    0x8(%ebp),%eax
  101c84:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8c:	c7 04 24 c9 3c 10 00 	movl   $0x103cc9,(%esp)
  101c93:	e8 fc e5 ff ff       	call   100294 <cprintf>
    }
}
  101c98:	90                   	nop
  101c99:	c9                   	leave  
  101c9a:	c3                   	ret    

00101c9b <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c9b:	f3 0f 1e fb          	endbr32 
  101c9f:	55                   	push   %ebp
  101ca0:	89 e5                	mov    %esp,%ebp
  101ca2:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca8:	8b 00                	mov    (%eax),%eax
  101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cae:	c7 04 24 dc 3c 10 00 	movl   $0x103cdc,(%esp)
  101cb5:	e8 da e5 ff ff       	call   100294 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cba:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbd:	8b 40 04             	mov    0x4(%eax),%eax
  101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc4:	c7 04 24 eb 3c 10 00 	movl   $0x103ceb,(%esp)
  101ccb:	e8 c4 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd3:	8b 40 08             	mov    0x8(%eax),%eax
  101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cda:	c7 04 24 fa 3c 10 00 	movl   $0x103cfa,(%esp)
  101ce1:	e8 ae e5 ff ff       	call   100294 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf0:	c7 04 24 09 3d 10 00 	movl   $0x103d09,(%esp)
  101cf7:	e8 98 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cff:	8b 40 10             	mov    0x10(%eax),%eax
  101d02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d06:	c7 04 24 18 3d 10 00 	movl   $0x103d18,(%esp)
  101d0d:	e8 82 e5 ff ff       	call   100294 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d12:	8b 45 08             	mov    0x8(%ebp),%eax
  101d15:	8b 40 14             	mov    0x14(%eax),%eax
  101d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1c:	c7 04 24 27 3d 10 00 	movl   $0x103d27,(%esp)
  101d23:	e8 6c e5 ff ff       	call   100294 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d28:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2b:	8b 40 18             	mov    0x18(%eax),%eax
  101d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d32:	c7 04 24 36 3d 10 00 	movl   $0x103d36,(%esp)
  101d39:	e8 56 e5 ff ff       	call   100294 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d41:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d48:	c7 04 24 45 3d 10 00 	movl   $0x103d45,(%esp)
  101d4f:	e8 40 e5 ff ff       	call   100294 <cprintf>
}
  101d54:	90                   	nop
  101d55:	c9                   	leave  
  101d56:	c3                   	ret    

00101d57 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d57:	f3 0f 1e fb          	endbr32 
  101d5b:	55                   	push   %ebp
  101d5c:	89 e5                	mov    %esp,%ebp
  101d5e:	57                   	push   %edi
  101d5f:	56                   	push   %esi
  101d60:	53                   	push   %ebx
  101d61:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d64:	8b 45 08             	mov    0x8(%ebp),%eax
  101d67:	8b 40 30             	mov    0x30(%eax),%eax
  101d6a:	83 f8 79             	cmp    $0x79,%eax
  101d6d:	0f 84 cb 02 00 00    	je     10203e <trap_dispatch+0x2e7>
  101d73:	83 f8 79             	cmp    $0x79,%eax
  101d76:	0f 87 0e 03 00 00    	ja     10208a <trap_dispatch+0x333>
  101d7c:	83 f8 78             	cmp    $0x78,%eax
  101d7f:	0f 84 5b 02 00 00    	je     101fe0 <trap_dispatch+0x289>
  101d85:	83 f8 78             	cmp    $0x78,%eax
  101d88:	0f 87 fc 02 00 00    	ja     10208a <trap_dispatch+0x333>
  101d8e:	83 f8 2f             	cmp    $0x2f,%eax
  101d91:	0f 87 f3 02 00 00    	ja     10208a <trap_dispatch+0x333>
  101d97:	83 f8 2e             	cmp    $0x2e,%eax
  101d9a:	0f 83 1f 03 00 00    	jae    1020bf <trap_dispatch+0x368>
  101da0:	83 f8 24             	cmp    $0x24,%eax
  101da3:	74 5e                	je     101e03 <trap_dispatch+0xac>
  101da5:	83 f8 24             	cmp    $0x24,%eax
  101da8:	0f 87 dc 02 00 00    	ja     10208a <trap_dispatch+0x333>
  101dae:	83 f8 20             	cmp    $0x20,%eax
  101db1:	74 0a                	je     101dbd <trap_dispatch+0x66>
  101db3:	83 f8 21             	cmp    $0x21,%eax
  101db6:	74 74                	je     101e2c <trap_dispatch+0xd5>
  101db8:	e9 cd 02 00 00       	jmp    10208a <trap_dispatch+0x333>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101dbd:	a1 08 19 11 00       	mov    0x111908,%eax
  101dc2:	40                   	inc    %eax
  101dc3:	a3 08 19 11 00       	mov    %eax,0x111908
        if (ticks % TICK_NUM == 0) {
  101dc8:	8b 0d 08 19 11 00    	mov    0x111908,%ecx
  101dce:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101dd3:	89 c8                	mov    %ecx,%eax
  101dd5:	f7 e2                	mul    %edx
  101dd7:	c1 ea 05             	shr    $0x5,%edx
  101dda:	89 d0                	mov    %edx,%eax
  101ddc:	c1 e0 02             	shl    $0x2,%eax
  101ddf:	01 d0                	add    %edx,%eax
  101de1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101de8:	01 d0                	add    %edx,%eax
  101dea:	c1 e0 02             	shl    $0x2,%eax
  101ded:	29 c1                	sub    %eax,%ecx
  101def:	89 ca                	mov    %ecx,%edx
  101df1:	85 d2                	test   %edx,%edx
  101df3:	0f 85 c9 02 00 00    	jne    1020c2 <trap_dispatch+0x36b>
            print_ticks();
  101df9:	e8 02 fb ff ff       	call   101900 <print_ticks>
        }
        break;
  101dfe:	e9 bf 02 00 00       	jmp    1020c2 <trap_dispatch+0x36b>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e03:	e8 9e f8 ff ff       	call   1016a6 <cons_getc>
  101e08:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e0b:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e0f:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e13:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e17:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e1b:	c7 04 24 54 3d 10 00 	movl   $0x103d54,(%esp)
  101e22:	e8 6d e4 ff ff       	call   100294 <cprintf>
        break;
  101e27:	e9 9d 02 00 00       	jmp    1020c9 <trap_dispatch+0x372>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e2c:	e8 75 f8 ff ff       	call   1016a6 <cons_getc>
  101e31:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e34:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e38:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e3c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e44:	c7 04 24 66 3d 10 00 	movl   $0x103d66,(%esp)
  101e4b:	e8 44 e4 ff ff       	call   100294 <cprintf>
        if(c == '0')
  101e50:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101e54:	0f 85 8c 00 00 00    	jne    101ee6 <trap_dispatch+0x18f>
        {
            if (tf->tf_cs != KERNEL_CS) {
  101e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e61:	83 f8 08             	cmp    $0x8,%eax
  101e64:	0f 84 5b 02 00 00    	je     1020c5 <trap_dispatch+0x36e>
                cprintf("+++ switch to  kernel  mode +++\n");
  101e6a:	c7 04 24 78 3d 10 00 	movl   $0x103d78,(%esp)
  101e71:	e8 1e e4 ff ff       	call   100294 <cprintf>
                tf->tf_cs = KERNEL_CS;
  101e76:	8b 45 08             	mov    0x8(%ebp),%eax
  101e79:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
                tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e82:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e88:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e92:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                tf->tf_eflags &= ~FL_IOPL_MASK;
  101e96:	8b 45 08             	mov    0x8(%ebp),%eax
  101e99:	8b 40 40             	mov    0x40(%eax),%eax
  101e9c:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101ea1:	89 c2                	mov    %eax,%edx
  101ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea6:	89 50 40             	mov    %edx,0x40(%eax)
                switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  101eac:	8b 40 44             	mov    0x44(%eax),%eax
  101eaf:	83 e8 44             	sub    $0x44,%eax
  101eb2:	a3 6c 19 11 00       	mov    %eax,0x11196c
                memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101eb7:	a1 6c 19 11 00       	mov    0x11196c,%eax
  101ebc:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101ec3:	00 
  101ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  101ec7:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ecb:	89 04 24             	mov    %eax,(%esp)
  101ece:	e8 73 11 00 00       	call   103046 <memmove>
                *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101ed3:	8b 15 6c 19 11 00    	mov    0x11196c,%edx
  101ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  101edc:	83 e8 04             	sub    $0x4,%eax
  101edf:	89 10                	mov    %edx,(%eax)
                switchk2u.tf_eflags |= FL_IOPL_MASK;
                *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
            }
        }
       
        break;
  101ee1:	e9 df 01 00 00       	jmp    1020c5 <trap_dispatch+0x36e>
        else if(c == '3')
  101ee6:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  101eea:	0f 85 d5 01 00 00    	jne    1020c5 <trap_dispatch+0x36e>
              if (tf->tf_cs != USER_CS) {
  101ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ef7:	83 f8 1b             	cmp    $0x1b,%eax
  101efa:	0f 84 c5 01 00 00    	je     1020c5 <trap_dispatch+0x36e>
                cprintf("+++ switch to  user  mode +++\n");
  101f00:	c7 04 24 9c 3d 10 00 	movl   $0x103d9c,(%esp)
  101f07:	e8 88 e3 ff ff       	call   100294 <cprintf>
                switchk2u = *tf;
  101f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  101f0f:	b8 20 19 11 00       	mov    $0x111920,%eax
  101f14:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101f19:	89 c1                	mov    %eax,%ecx
  101f1b:	83 e1 01             	and    $0x1,%ecx
  101f1e:	85 c9                	test   %ecx,%ecx
  101f20:	74 0c                	je     101f2e <trap_dispatch+0x1d7>
  101f22:	0f b6 0a             	movzbl (%edx),%ecx
  101f25:	88 08                	mov    %cl,(%eax)
  101f27:	8d 40 01             	lea    0x1(%eax),%eax
  101f2a:	8d 52 01             	lea    0x1(%edx),%edx
  101f2d:	4b                   	dec    %ebx
  101f2e:	89 c1                	mov    %eax,%ecx
  101f30:	83 e1 02             	and    $0x2,%ecx
  101f33:	85 c9                	test   %ecx,%ecx
  101f35:	74 0f                	je     101f46 <trap_dispatch+0x1ef>
  101f37:	0f b7 0a             	movzwl (%edx),%ecx
  101f3a:	66 89 08             	mov    %cx,(%eax)
  101f3d:	8d 40 02             	lea    0x2(%eax),%eax
  101f40:	8d 52 02             	lea    0x2(%edx),%edx
  101f43:	83 eb 02             	sub    $0x2,%ebx
  101f46:	89 df                	mov    %ebx,%edi
  101f48:	83 e7 fc             	and    $0xfffffffc,%edi
  101f4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  101f50:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101f53:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101f56:	83 c1 04             	add    $0x4,%ecx
  101f59:	39 f9                	cmp    %edi,%ecx
  101f5b:	72 f3                	jb     101f50 <trap_dispatch+0x1f9>
  101f5d:	01 c8                	add    %ecx,%eax
  101f5f:	01 ca                	add    %ecx,%edx
  101f61:	b9 00 00 00 00       	mov    $0x0,%ecx
  101f66:	89 de                	mov    %ebx,%esi
  101f68:	83 e6 02             	and    $0x2,%esi
  101f6b:	85 f6                	test   %esi,%esi
  101f6d:	74 0b                	je     101f7a <trap_dispatch+0x223>
  101f6f:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101f73:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101f77:	83 c1 02             	add    $0x2,%ecx
  101f7a:	83 e3 01             	and    $0x1,%ebx
  101f7d:	85 db                	test   %ebx,%ebx
  101f7f:	74 07                	je     101f88 <trap_dispatch+0x231>
  101f81:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101f85:	88 14 08             	mov    %dl,(%eax,%ecx,1)
                switchk2u.tf_cs = USER_CS;
  101f88:	66 c7 05 5c 19 11 00 	movw   $0x1b,0x11195c
  101f8f:	1b 00 
                switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101f91:	66 c7 05 68 19 11 00 	movw   $0x23,0x111968
  101f98:	23 00 
  101f9a:	0f b7 05 68 19 11 00 	movzwl 0x111968,%eax
  101fa1:	66 a3 48 19 11 00    	mov    %ax,0x111948
  101fa7:	0f b7 05 48 19 11 00 	movzwl 0x111948,%eax
  101fae:	66 a3 4c 19 11 00    	mov    %ax,0x11194c
                switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb7:	83 c0 44             	add    $0x44,%eax
  101fba:	a3 64 19 11 00       	mov    %eax,0x111964
                switchk2u.tf_eflags |= FL_IOPL_MASK;
  101fbf:	a1 60 19 11 00       	mov    0x111960,%eax
  101fc4:	0d 00 30 00 00       	or     $0x3000,%eax
  101fc9:	a3 60 19 11 00       	mov    %eax,0x111960
                *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101fce:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd1:	83 e8 04             	sub    $0x4,%eax
  101fd4:	ba 20 19 11 00       	mov    $0x111920,%edx
  101fd9:	89 10                	mov    %edx,(%eax)
        break;
  101fdb:	e9 e5 00 00 00       	jmp    1020c5 <trap_dispatch+0x36e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        
if (tf->tf_cs!=USER_CS){
  101fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fe7:	83 f8 1b             	cmp    $0x1b,%eax
  101fea:	0f 84 d8 00 00 00    	je     1020c8 <trap_dispatch+0x371>
   tf->tf_ss = USER_DS;
  101ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff3:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
   tf->tf_cs = USER_CS;
  101ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ffc:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
   tf->tf_ds = USER_DS;
  102002:	8b 45 08             	mov    0x8(%ebp),%eax
  102005:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
   tf->tf_es = USER_DS;
  10200b:	8b 45 08             	mov    0x8(%ebp),%eax
  10200e:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
   tf->tf_fs = USER_DS;
  102014:	8b 45 08             	mov    0x8(%ebp),%eax
  102017:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
   tf->tf_gs = USER_DS;
  10201d:	8b 45 08             	mov    0x8(%ebp),%eax
  102020:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
   tf->tf_eflags |= FL_IOPL_MASK;
  102026:	8b 45 08             	mov    0x8(%ebp),%eax
  102029:	8b 40 40             	mov    0x40(%eax),%eax
  10202c:	0d 00 30 00 00       	or     $0x3000,%eax
  102031:	89 c2                	mov    %eax,%edx
  102033:	8b 45 08             	mov    0x8(%ebp),%eax
  102036:	89 50 40             	mov    %edx,0x40(%eax)
}
break;
  102039:	e9 8a 00 00 00       	jmp    1020c8 <trap_dispatch+0x371>

    case T_SWITCH_TOK:
         tf->tf_cs = KERNEL_CS;
  10203e:	8b 45 08             	mov    0x8(%ebp),%eax
  102041:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
    tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
  102047:	8b 45 08             	mov    0x8(%ebp),%eax
  10204a:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  102050:	8b 45 08             	mov    0x8(%ebp),%eax
  102053:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  102057:	8b 45 08             	mov    0x8(%ebp),%eax
  10205a:	66 89 50 48          	mov    %dx,0x48(%eax)
  10205e:	8b 45 08             	mov    0x8(%ebp),%eax
  102061:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  102065:	8b 45 08             	mov    0x8(%ebp),%eax
  102068:	66 89 50 20          	mov    %dx,0x20(%eax)
  10206c:	8b 45 08             	mov    0x8(%ebp),%eax
  10206f:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  102073:	8b 45 08             	mov    0x8(%ebp),%eax
  102076:	66 89 50 28          	mov    %dx,0x28(%eax)
  10207a:	8b 45 08             	mov    0x8(%ebp),%eax
  10207d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  102081:	8b 45 08             	mov    0x8(%ebp),%eax
  102084:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        break;
  102088:	eb 3f                	jmp    1020c9 <trap_dispatch+0x372>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  10208a:	8b 45 08             	mov    0x8(%ebp),%eax
  10208d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102091:	83 e0 03             	and    $0x3,%eax
  102094:	85 c0                	test   %eax,%eax
  102096:	75 31                	jne    1020c9 <trap_dispatch+0x372>
            print_trapframe(tf);
  102098:	8b 45 08             	mov    0x8(%ebp),%eax
  10209b:	89 04 24             	mov    %eax,(%esp)
  10209e:	e8 43 fa ff ff       	call   101ae6 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  1020a3:	c7 44 24 08 bb 3d 10 	movl   $0x103dbb,0x8(%esp)
  1020aa:	00 
  1020ab:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  1020b2:	00 
  1020b3:	c7 04 24 d7 3d 10 00 	movl   $0x103dd7,(%esp)
  1020ba:	e8 41 e3 ff ff       	call   100400 <__panic>
        break;
  1020bf:	90                   	nop
  1020c0:	eb 07                	jmp    1020c9 <trap_dispatch+0x372>
        break;
  1020c2:	90                   	nop
  1020c3:	eb 04                	jmp    1020c9 <trap_dispatch+0x372>
        break;
  1020c5:	90                   	nop
  1020c6:	eb 01                	jmp    1020c9 <trap_dispatch+0x372>
break;
  1020c8:	90                   	nop
        }
    }
}
  1020c9:	90                   	nop
  1020ca:	83 c4 2c             	add    $0x2c,%esp
  1020cd:	5b                   	pop    %ebx
  1020ce:	5e                   	pop    %esi
  1020cf:	5f                   	pop    %edi
  1020d0:	5d                   	pop    %ebp
  1020d1:	c3                   	ret    

001020d2 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  1020d2:	f3 0f 1e fb          	endbr32 
  1020d6:	55                   	push   %ebp
  1020d7:	89 e5                	mov    %esp,%ebp
  1020d9:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  1020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1020df:	89 04 24             	mov    %eax,(%esp)
  1020e2:	e8 70 fc ff ff       	call   101d57 <trap_dispatch>
}
  1020e7:	90                   	nop
  1020e8:	c9                   	leave  
  1020e9:	c3                   	ret    

001020ea <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $0
  1020ec:	6a 00                	push   $0x0
  jmp __alltraps
  1020ee:	e9 69 0a 00 00       	jmp    102b5c <__alltraps>

001020f3 <vector1>:
.globl vector1
vector1:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $1
  1020f5:	6a 01                	push   $0x1
  jmp __alltraps
  1020f7:	e9 60 0a 00 00       	jmp    102b5c <__alltraps>

001020fc <vector2>:
.globl vector2
vector2:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $2
  1020fe:	6a 02                	push   $0x2
  jmp __alltraps
  102100:	e9 57 0a 00 00       	jmp    102b5c <__alltraps>

00102105 <vector3>:
.globl vector3
vector3:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $3
  102107:	6a 03                	push   $0x3
  jmp __alltraps
  102109:	e9 4e 0a 00 00       	jmp    102b5c <__alltraps>

0010210e <vector4>:
.globl vector4
vector4:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $4
  102110:	6a 04                	push   $0x4
  jmp __alltraps
  102112:	e9 45 0a 00 00       	jmp    102b5c <__alltraps>

00102117 <vector5>:
.globl vector5
vector5:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $5
  102119:	6a 05                	push   $0x5
  jmp __alltraps
  10211b:	e9 3c 0a 00 00       	jmp    102b5c <__alltraps>

00102120 <vector6>:
.globl vector6
vector6:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $6
  102122:	6a 06                	push   $0x6
  jmp __alltraps
  102124:	e9 33 0a 00 00       	jmp    102b5c <__alltraps>

00102129 <vector7>:
.globl vector7
vector7:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $7
  10212b:	6a 07                	push   $0x7
  jmp __alltraps
  10212d:	e9 2a 0a 00 00       	jmp    102b5c <__alltraps>

00102132 <vector8>:
.globl vector8
vector8:
  pushl $8
  102132:	6a 08                	push   $0x8
  jmp __alltraps
  102134:	e9 23 0a 00 00       	jmp    102b5c <__alltraps>

00102139 <vector9>:
.globl vector9
vector9:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $9
  10213b:	6a 09                	push   $0x9
  jmp __alltraps
  10213d:	e9 1a 0a 00 00       	jmp    102b5c <__alltraps>

00102142 <vector10>:
.globl vector10
vector10:
  pushl $10
  102142:	6a 0a                	push   $0xa
  jmp __alltraps
  102144:	e9 13 0a 00 00       	jmp    102b5c <__alltraps>

00102149 <vector11>:
.globl vector11
vector11:
  pushl $11
  102149:	6a 0b                	push   $0xb
  jmp __alltraps
  10214b:	e9 0c 0a 00 00       	jmp    102b5c <__alltraps>

00102150 <vector12>:
.globl vector12
vector12:
  pushl $12
  102150:	6a 0c                	push   $0xc
  jmp __alltraps
  102152:	e9 05 0a 00 00       	jmp    102b5c <__alltraps>

00102157 <vector13>:
.globl vector13
vector13:
  pushl $13
  102157:	6a 0d                	push   $0xd
  jmp __alltraps
  102159:	e9 fe 09 00 00       	jmp    102b5c <__alltraps>

0010215e <vector14>:
.globl vector14
vector14:
  pushl $14
  10215e:	6a 0e                	push   $0xe
  jmp __alltraps
  102160:	e9 f7 09 00 00       	jmp    102b5c <__alltraps>

00102165 <vector15>:
.globl vector15
vector15:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $15
  102167:	6a 0f                	push   $0xf
  jmp __alltraps
  102169:	e9 ee 09 00 00       	jmp    102b5c <__alltraps>

0010216e <vector16>:
.globl vector16
vector16:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $16
  102170:	6a 10                	push   $0x10
  jmp __alltraps
  102172:	e9 e5 09 00 00       	jmp    102b5c <__alltraps>

00102177 <vector17>:
.globl vector17
vector17:
  pushl $17
  102177:	6a 11                	push   $0x11
  jmp __alltraps
  102179:	e9 de 09 00 00       	jmp    102b5c <__alltraps>

0010217e <vector18>:
.globl vector18
vector18:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $18
  102180:	6a 12                	push   $0x12
  jmp __alltraps
  102182:	e9 d5 09 00 00       	jmp    102b5c <__alltraps>

00102187 <vector19>:
.globl vector19
vector19:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $19
  102189:	6a 13                	push   $0x13
  jmp __alltraps
  10218b:	e9 cc 09 00 00       	jmp    102b5c <__alltraps>

00102190 <vector20>:
.globl vector20
vector20:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $20
  102192:	6a 14                	push   $0x14
  jmp __alltraps
  102194:	e9 c3 09 00 00       	jmp    102b5c <__alltraps>

00102199 <vector21>:
.globl vector21
vector21:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $21
  10219b:	6a 15                	push   $0x15
  jmp __alltraps
  10219d:	e9 ba 09 00 00       	jmp    102b5c <__alltraps>

001021a2 <vector22>:
.globl vector22
vector22:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $22
  1021a4:	6a 16                	push   $0x16
  jmp __alltraps
  1021a6:	e9 b1 09 00 00       	jmp    102b5c <__alltraps>

001021ab <vector23>:
.globl vector23
vector23:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $23
  1021ad:	6a 17                	push   $0x17
  jmp __alltraps
  1021af:	e9 a8 09 00 00       	jmp    102b5c <__alltraps>

001021b4 <vector24>:
.globl vector24
vector24:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $24
  1021b6:	6a 18                	push   $0x18
  jmp __alltraps
  1021b8:	e9 9f 09 00 00       	jmp    102b5c <__alltraps>

001021bd <vector25>:
.globl vector25
vector25:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $25
  1021bf:	6a 19                	push   $0x19
  jmp __alltraps
  1021c1:	e9 96 09 00 00       	jmp    102b5c <__alltraps>

001021c6 <vector26>:
.globl vector26
vector26:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $26
  1021c8:	6a 1a                	push   $0x1a
  jmp __alltraps
  1021ca:	e9 8d 09 00 00       	jmp    102b5c <__alltraps>

001021cf <vector27>:
.globl vector27
vector27:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $27
  1021d1:	6a 1b                	push   $0x1b
  jmp __alltraps
  1021d3:	e9 84 09 00 00       	jmp    102b5c <__alltraps>

001021d8 <vector28>:
.globl vector28
vector28:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $28
  1021da:	6a 1c                	push   $0x1c
  jmp __alltraps
  1021dc:	e9 7b 09 00 00       	jmp    102b5c <__alltraps>

001021e1 <vector29>:
.globl vector29
vector29:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $29
  1021e3:	6a 1d                	push   $0x1d
  jmp __alltraps
  1021e5:	e9 72 09 00 00       	jmp    102b5c <__alltraps>

001021ea <vector30>:
.globl vector30
vector30:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $30
  1021ec:	6a 1e                	push   $0x1e
  jmp __alltraps
  1021ee:	e9 69 09 00 00       	jmp    102b5c <__alltraps>

001021f3 <vector31>:
.globl vector31
vector31:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $31
  1021f5:	6a 1f                	push   $0x1f
  jmp __alltraps
  1021f7:	e9 60 09 00 00       	jmp    102b5c <__alltraps>

001021fc <vector32>:
.globl vector32
vector32:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $32
  1021fe:	6a 20                	push   $0x20
  jmp __alltraps
  102200:	e9 57 09 00 00       	jmp    102b5c <__alltraps>

00102205 <vector33>:
.globl vector33
vector33:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $33
  102207:	6a 21                	push   $0x21
  jmp __alltraps
  102209:	e9 4e 09 00 00       	jmp    102b5c <__alltraps>

0010220e <vector34>:
.globl vector34
vector34:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $34
  102210:	6a 22                	push   $0x22
  jmp __alltraps
  102212:	e9 45 09 00 00       	jmp    102b5c <__alltraps>

00102217 <vector35>:
.globl vector35
vector35:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $35
  102219:	6a 23                	push   $0x23
  jmp __alltraps
  10221b:	e9 3c 09 00 00       	jmp    102b5c <__alltraps>

00102220 <vector36>:
.globl vector36
vector36:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $36
  102222:	6a 24                	push   $0x24
  jmp __alltraps
  102224:	e9 33 09 00 00       	jmp    102b5c <__alltraps>

00102229 <vector37>:
.globl vector37
vector37:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $37
  10222b:	6a 25                	push   $0x25
  jmp __alltraps
  10222d:	e9 2a 09 00 00       	jmp    102b5c <__alltraps>

00102232 <vector38>:
.globl vector38
vector38:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $38
  102234:	6a 26                	push   $0x26
  jmp __alltraps
  102236:	e9 21 09 00 00       	jmp    102b5c <__alltraps>

0010223b <vector39>:
.globl vector39
vector39:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $39
  10223d:	6a 27                	push   $0x27
  jmp __alltraps
  10223f:	e9 18 09 00 00       	jmp    102b5c <__alltraps>

00102244 <vector40>:
.globl vector40
vector40:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $40
  102246:	6a 28                	push   $0x28
  jmp __alltraps
  102248:	e9 0f 09 00 00       	jmp    102b5c <__alltraps>

0010224d <vector41>:
.globl vector41
vector41:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $41
  10224f:	6a 29                	push   $0x29
  jmp __alltraps
  102251:	e9 06 09 00 00       	jmp    102b5c <__alltraps>

00102256 <vector42>:
.globl vector42
vector42:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $42
  102258:	6a 2a                	push   $0x2a
  jmp __alltraps
  10225a:	e9 fd 08 00 00       	jmp    102b5c <__alltraps>

0010225f <vector43>:
.globl vector43
vector43:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $43
  102261:	6a 2b                	push   $0x2b
  jmp __alltraps
  102263:	e9 f4 08 00 00       	jmp    102b5c <__alltraps>

00102268 <vector44>:
.globl vector44
vector44:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $44
  10226a:	6a 2c                	push   $0x2c
  jmp __alltraps
  10226c:	e9 eb 08 00 00       	jmp    102b5c <__alltraps>

00102271 <vector45>:
.globl vector45
vector45:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $45
  102273:	6a 2d                	push   $0x2d
  jmp __alltraps
  102275:	e9 e2 08 00 00       	jmp    102b5c <__alltraps>

0010227a <vector46>:
.globl vector46
vector46:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $46
  10227c:	6a 2e                	push   $0x2e
  jmp __alltraps
  10227e:	e9 d9 08 00 00       	jmp    102b5c <__alltraps>

00102283 <vector47>:
.globl vector47
vector47:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $47
  102285:	6a 2f                	push   $0x2f
  jmp __alltraps
  102287:	e9 d0 08 00 00       	jmp    102b5c <__alltraps>

0010228c <vector48>:
.globl vector48
vector48:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $48
  10228e:	6a 30                	push   $0x30
  jmp __alltraps
  102290:	e9 c7 08 00 00       	jmp    102b5c <__alltraps>

00102295 <vector49>:
.globl vector49
vector49:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $49
  102297:	6a 31                	push   $0x31
  jmp __alltraps
  102299:	e9 be 08 00 00       	jmp    102b5c <__alltraps>

0010229e <vector50>:
.globl vector50
vector50:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $50
  1022a0:	6a 32                	push   $0x32
  jmp __alltraps
  1022a2:	e9 b5 08 00 00       	jmp    102b5c <__alltraps>

001022a7 <vector51>:
.globl vector51
vector51:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $51
  1022a9:	6a 33                	push   $0x33
  jmp __alltraps
  1022ab:	e9 ac 08 00 00       	jmp    102b5c <__alltraps>

001022b0 <vector52>:
.globl vector52
vector52:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $52
  1022b2:	6a 34                	push   $0x34
  jmp __alltraps
  1022b4:	e9 a3 08 00 00       	jmp    102b5c <__alltraps>

001022b9 <vector53>:
.globl vector53
vector53:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $53
  1022bb:	6a 35                	push   $0x35
  jmp __alltraps
  1022bd:	e9 9a 08 00 00       	jmp    102b5c <__alltraps>

001022c2 <vector54>:
.globl vector54
vector54:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $54
  1022c4:	6a 36                	push   $0x36
  jmp __alltraps
  1022c6:	e9 91 08 00 00       	jmp    102b5c <__alltraps>

001022cb <vector55>:
.globl vector55
vector55:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $55
  1022cd:	6a 37                	push   $0x37
  jmp __alltraps
  1022cf:	e9 88 08 00 00       	jmp    102b5c <__alltraps>

001022d4 <vector56>:
.globl vector56
vector56:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $56
  1022d6:	6a 38                	push   $0x38
  jmp __alltraps
  1022d8:	e9 7f 08 00 00       	jmp    102b5c <__alltraps>

001022dd <vector57>:
.globl vector57
vector57:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $57
  1022df:	6a 39                	push   $0x39
  jmp __alltraps
  1022e1:	e9 76 08 00 00       	jmp    102b5c <__alltraps>

001022e6 <vector58>:
.globl vector58
vector58:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $58
  1022e8:	6a 3a                	push   $0x3a
  jmp __alltraps
  1022ea:	e9 6d 08 00 00       	jmp    102b5c <__alltraps>

001022ef <vector59>:
.globl vector59
vector59:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $59
  1022f1:	6a 3b                	push   $0x3b
  jmp __alltraps
  1022f3:	e9 64 08 00 00       	jmp    102b5c <__alltraps>

001022f8 <vector60>:
.globl vector60
vector60:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $60
  1022fa:	6a 3c                	push   $0x3c
  jmp __alltraps
  1022fc:	e9 5b 08 00 00       	jmp    102b5c <__alltraps>

00102301 <vector61>:
.globl vector61
vector61:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $61
  102303:	6a 3d                	push   $0x3d
  jmp __alltraps
  102305:	e9 52 08 00 00       	jmp    102b5c <__alltraps>

0010230a <vector62>:
.globl vector62
vector62:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $62
  10230c:	6a 3e                	push   $0x3e
  jmp __alltraps
  10230e:	e9 49 08 00 00       	jmp    102b5c <__alltraps>

00102313 <vector63>:
.globl vector63
vector63:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $63
  102315:	6a 3f                	push   $0x3f
  jmp __alltraps
  102317:	e9 40 08 00 00       	jmp    102b5c <__alltraps>

0010231c <vector64>:
.globl vector64
vector64:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $64
  10231e:	6a 40                	push   $0x40
  jmp __alltraps
  102320:	e9 37 08 00 00       	jmp    102b5c <__alltraps>

00102325 <vector65>:
.globl vector65
vector65:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $65
  102327:	6a 41                	push   $0x41
  jmp __alltraps
  102329:	e9 2e 08 00 00       	jmp    102b5c <__alltraps>

0010232e <vector66>:
.globl vector66
vector66:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $66
  102330:	6a 42                	push   $0x42
  jmp __alltraps
  102332:	e9 25 08 00 00       	jmp    102b5c <__alltraps>

00102337 <vector67>:
.globl vector67
vector67:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $67
  102339:	6a 43                	push   $0x43
  jmp __alltraps
  10233b:	e9 1c 08 00 00       	jmp    102b5c <__alltraps>

00102340 <vector68>:
.globl vector68
vector68:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $68
  102342:	6a 44                	push   $0x44
  jmp __alltraps
  102344:	e9 13 08 00 00       	jmp    102b5c <__alltraps>

00102349 <vector69>:
.globl vector69
vector69:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $69
  10234b:	6a 45                	push   $0x45
  jmp __alltraps
  10234d:	e9 0a 08 00 00       	jmp    102b5c <__alltraps>

00102352 <vector70>:
.globl vector70
vector70:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $70
  102354:	6a 46                	push   $0x46
  jmp __alltraps
  102356:	e9 01 08 00 00       	jmp    102b5c <__alltraps>

0010235b <vector71>:
.globl vector71
vector71:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $71
  10235d:	6a 47                	push   $0x47
  jmp __alltraps
  10235f:	e9 f8 07 00 00       	jmp    102b5c <__alltraps>

00102364 <vector72>:
.globl vector72
vector72:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $72
  102366:	6a 48                	push   $0x48
  jmp __alltraps
  102368:	e9 ef 07 00 00       	jmp    102b5c <__alltraps>

0010236d <vector73>:
.globl vector73
vector73:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $73
  10236f:	6a 49                	push   $0x49
  jmp __alltraps
  102371:	e9 e6 07 00 00       	jmp    102b5c <__alltraps>

00102376 <vector74>:
.globl vector74
vector74:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $74
  102378:	6a 4a                	push   $0x4a
  jmp __alltraps
  10237a:	e9 dd 07 00 00       	jmp    102b5c <__alltraps>

0010237f <vector75>:
.globl vector75
vector75:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $75
  102381:	6a 4b                	push   $0x4b
  jmp __alltraps
  102383:	e9 d4 07 00 00       	jmp    102b5c <__alltraps>

00102388 <vector76>:
.globl vector76
vector76:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $76
  10238a:	6a 4c                	push   $0x4c
  jmp __alltraps
  10238c:	e9 cb 07 00 00       	jmp    102b5c <__alltraps>

00102391 <vector77>:
.globl vector77
vector77:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $77
  102393:	6a 4d                	push   $0x4d
  jmp __alltraps
  102395:	e9 c2 07 00 00       	jmp    102b5c <__alltraps>

0010239a <vector78>:
.globl vector78
vector78:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $78
  10239c:	6a 4e                	push   $0x4e
  jmp __alltraps
  10239e:	e9 b9 07 00 00       	jmp    102b5c <__alltraps>

001023a3 <vector79>:
.globl vector79
vector79:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $79
  1023a5:	6a 4f                	push   $0x4f
  jmp __alltraps
  1023a7:	e9 b0 07 00 00       	jmp    102b5c <__alltraps>

001023ac <vector80>:
.globl vector80
vector80:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $80
  1023ae:	6a 50                	push   $0x50
  jmp __alltraps
  1023b0:	e9 a7 07 00 00       	jmp    102b5c <__alltraps>

001023b5 <vector81>:
.globl vector81
vector81:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $81
  1023b7:	6a 51                	push   $0x51
  jmp __alltraps
  1023b9:	e9 9e 07 00 00       	jmp    102b5c <__alltraps>

001023be <vector82>:
.globl vector82
vector82:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $82
  1023c0:	6a 52                	push   $0x52
  jmp __alltraps
  1023c2:	e9 95 07 00 00       	jmp    102b5c <__alltraps>

001023c7 <vector83>:
.globl vector83
vector83:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $83
  1023c9:	6a 53                	push   $0x53
  jmp __alltraps
  1023cb:	e9 8c 07 00 00       	jmp    102b5c <__alltraps>

001023d0 <vector84>:
.globl vector84
vector84:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $84
  1023d2:	6a 54                	push   $0x54
  jmp __alltraps
  1023d4:	e9 83 07 00 00       	jmp    102b5c <__alltraps>

001023d9 <vector85>:
.globl vector85
vector85:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $85
  1023db:	6a 55                	push   $0x55
  jmp __alltraps
  1023dd:	e9 7a 07 00 00       	jmp    102b5c <__alltraps>

001023e2 <vector86>:
.globl vector86
vector86:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $86
  1023e4:	6a 56                	push   $0x56
  jmp __alltraps
  1023e6:	e9 71 07 00 00       	jmp    102b5c <__alltraps>

001023eb <vector87>:
.globl vector87
vector87:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $87
  1023ed:	6a 57                	push   $0x57
  jmp __alltraps
  1023ef:	e9 68 07 00 00       	jmp    102b5c <__alltraps>

001023f4 <vector88>:
.globl vector88
vector88:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $88
  1023f6:	6a 58                	push   $0x58
  jmp __alltraps
  1023f8:	e9 5f 07 00 00       	jmp    102b5c <__alltraps>

001023fd <vector89>:
.globl vector89
vector89:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $89
  1023ff:	6a 59                	push   $0x59
  jmp __alltraps
  102401:	e9 56 07 00 00       	jmp    102b5c <__alltraps>

00102406 <vector90>:
.globl vector90
vector90:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $90
  102408:	6a 5a                	push   $0x5a
  jmp __alltraps
  10240a:	e9 4d 07 00 00       	jmp    102b5c <__alltraps>

0010240f <vector91>:
.globl vector91
vector91:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $91
  102411:	6a 5b                	push   $0x5b
  jmp __alltraps
  102413:	e9 44 07 00 00       	jmp    102b5c <__alltraps>

00102418 <vector92>:
.globl vector92
vector92:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $92
  10241a:	6a 5c                	push   $0x5c
  jmp __alltraps
  10241c:	e9 3b 07 00 00       	jmp    102b5c <__alltraps>

00102421 <vector93>:
.globl vector93
vector93:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $93
  102423:	6a 5d                	push   $0x5d
  jmp __alltraps
  102425:	e9 32 07 00 00       	jmp    102b5c <__alltraps>

0010242a <vector94>:
.globl vector94
vector94:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $94
  10242c:	6a 5e                	push   $0x5e
  jmp __alltraps
  10242e:	e9 29 07 00 00       	jmp    102b5c <__alltraps>

00102433 <vector95>:
.globl vector95
vector95:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $95
  102435:	6a 5f                	push   $0x5f
  jmp __alltraps
  102437:	e9 20 07 00 00       	jmp    102b5c <__alltraps>

0010243c <vector96>:
.globl vector96
vector96:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $96
  10243e:	6a 60                	push   $0x60
  jmp __alltraps
  102440:	e9 17 07 00 00       	jmp    102b5c <__alltraps>

00102445 <vector97>:
.globl vector97
vector97:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $97
  102447:	6a 61                	push   $0x61
  jmp __alltraps
  102449:	e9 0e 07 00 00       	jmp    102b5c <__alltraps>

0010244e <vector98>:
.globl vector98
vector98:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $98
  102450:	6a 62                	push   $0x62
  jmp __alltraps
  102452:	e9 05 07 00 00       	jmp    102b5c <__alltraps>

00102457 <vector99>:
.globl vector99
vector99:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $99
  102459:	6a 63                	push   $0x63
  jmp __alltraps
  10245b:	e9 fc 06 00 00       	jmp    102b5c <__alltraps>

00102460 <vector100>:
.globl vector100
vector100:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $100
  102462:	6a 64                	push   $0x64
  jmp __alltraps
  102464:	e9 f3 06 00 00       	jmp    102b5c <__alltraps>

00102469 <vector101>:
.globl vector101
vector101:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $101
  10246b:	6a 65                	push   $0x65
  jmp __alltraps
  10246d:	e9 ea 06 00 00       	jmp    102b5c <__alltraps>

00102472 <vector102>:
.globl vector102
vector102:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $102
  102474:	6a 66                	push   $0x66
  jmp __alltraps
  102476:	e9 e1 06 00 00       	jmp    102b5c <__alltraps>

0010247b <vector103>:
.globl vector103
vector103:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $103
  10247d:	6a 67                	push   $0x67
  jmp __alltraps
  10247f:	e9 d8 06 00 00       	jmp    102b5c <__alltraps>

00102484 <vector104>:
.globl vector104
vector104:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $104
  102486:	6a 68                	push   $0x68
  jmp __alltraps
  102488:	e9 cf 06 00 00       	jmp    102b5c <__alltraps>

0010248d <vector105>:
.globl vector105
vector105:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $105
  10248f:	6a 69                	push   $0x69
  jmp __alltraps
  102491:	e9 c6 06 00 00       	jmp    102b5c <__alltraps>

00102496 <vector106>:
.globl vector106
vector106:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $106
  102498:	6a 6a                	push   $0x6a
  jmp __alltraps
  10249a:	e9 bd 06 00 00       	jmp    102b5c <__alltraps>

0010249f <vector107>:
.globl vector107
vector107:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $107
  1024a1:	6a 6b                	push   $0x6b
  jmp __alltraps
  1024a3:	e9 b4 06 00 00       	jmp    102b5c <__alltraps>

001024a8 <vector108>:
.globl vector108
vector108:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $108
  1024aa:	6a 6c                	push   $0x6c
  jmp __alltraps
  1024ac:	e9 ab 06 00 00       	jmp    102b5c <__alltraps>

001024b1 <vector109>:
.globl vector109
vector109:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $109
  1024b3:	6a 6d                	push   $0x6d
  jmp __alltraps
  1024b5:	e9 a2 06 00 00       	jmp    102b5c <__alltraps>

001024ba <vector110>:
.globl vector110
vector110:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $110
  1024bc:	6a 6e                	push   $0x6e
  jmp __alltraps
  1024be:	e9 99 06 00 00       	jmp    102b5c <__alltraps>

001024c3 <vector111>:
.globl vector111
vector111:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $111
  1024c5:	6a 6f                	push   $0x6f
  jmp __alltraps
  1024c7:	e9 90 06 00 00       	jmp    102b5c <__alltraps>

001024cc <vector112>:
.globl vector112
vector112:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $112
  1024ce:	6a 70                	push   $0x70
  jmp __alltraps
  1024d0:	e9 87 06 00 00       	jmp    102b5c <__alltraps>

001024d5 <vector113>:
.globl vector113
vector113:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $113
  1024d7:	6a 71                	push   $0x71
  jmp __alltraps
  1024d9:	e9 7e 06 00 00       	jmp    102b5c <__alltraps>

001024de <vector114>:
.globl vector114
vector114:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $114
  1024e0:	6a 72                	push   $0x72
  jmp __alltraps
  1024e2:	e9 75 06 00 00       	jmp    102b5c <__alltraps>

001024e7 <vector115>:
.globl vector115
vector115:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $115
  1024e9:	6a 73                	push   $0x73
  jmp __alltraps
  1024eb:	e9 6c 06 00 00       	jmp    102b5c <__alltraps>

001024f0 <vector116>:
.globl vector116
vector116:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $116
  1024f2:	6a 74                	push   $0x74
  jmp __alltraps
  1024f4:	e9 63 06 00 00       	jmp    102b5c <__alltraps>

001024f9 <vector117>:
.globl vector117
vector117:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $117
  1024fb:	6a 75                	push   $0x75
  jmp __alltraps
  1024fd:	e9 5a 06 00 00       	jmp    102b5c <__alltraps>

00102502 <vector118>:
.globl vector118
vector118:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $118
  102504:	6a 76                	push   $0x76
  jmp __alltraps
  102506:	e9 51 06 00 00       	jmp    102b5c <__alltraps>

0010250b <vector119>:
.globl vector119
vector119:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $119
  10250d:	6a 77                	push   $0x77
  jmp __alltraps
  10250f:	e9 48 06 00 00       	jmp    102b5c <__alltraps>

00102514 <vector120>:
.globl vector120
vector120:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $120
  102516:	6a 78                	push   $0x78
  jmp __alltraps
  102518:	e9 3f 06 00 00       	jmp    102b5c <__alltraps>

0010251d <vector121>:
.globl vector121
vector121:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $121
  10251f:	6a 79                	push   $0x79
  jmp __alltraps
  102521:	e9 36 06 00 00       	jmp    102b5c <__alltraps>

00102526 <vector122>:
.globl vector122
vector122:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $122
  102528:	6a 7a                	push   $0x7a
  jmp __alltraps
  10252a:	e9 2d 06 00 00       	jmp    102b5c <__alltraps>

0010252f <vector123>:
.globl vector123
vector123:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $123
  102531:	6a 7b                	push   $0x7b
  jmp __alltraps
  102533:	e9 24 06 00 00       	jmp    102b5c <__alltraps>

00102538 <vector124>:
.globl vector124
vector124:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $124
  10253a:	6a 7c                	push   $0x7c
  jmp __alltraps
  10253c:	e9 1b 06 00 00       	jmp    102b5c <__alltraps>

00102541 <vector125>:
.globl vector125
vector125:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $125
  102543:	6a 7d                	push   $0x7d
  jmp __alltraps
  102545:	e9 12 06 00 00       	jmp    102b5c <__alltraps>

0010254a <vector126>:
.globl vector126
vector126:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $126
  10254c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10254e:	e9 09 06 00 00       	jmp    102b5c <__alltraps>

00102553 <vector127>:
.globl vector127
vector127:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $127
  102555:	6a 7f                	push   $0x7f
  jmp __alltraps
  102557:	e9 00 06 00 00       	jmp    102b5c <__alltraps>

0010255c <vector128>:
.globl vector128
vector128:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $128
  10255e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102563:	e9 f4 05 00 00       	jmp    102b5c <__alltraps>

00102568 <vector129>:
.globl vector129
vector129:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $129
  10256a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10256f:	e9 e8 05 00 00       	jmp    102b5c <__alltraps>

00102574 <vector130>:
.globl vector130
vector130:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $130
  102576:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10257b:	e9 dc 05 00 00       	jmp    102b5c <__alltraps>

00102580 <vector131>:
.globl vector131
vector131:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $131
  102582:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102587:	e9 d0 05 00 00       	jmp    102b5c <__alltraps>

0010258c <vector132>:
.globl vector132
vector132:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $132
  10258e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102593:	e9 c4 05 00 00       	jmp    102b5c <__alltraps>

00102598 <vector133>:
.globl vector133
vector133:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $133
  10259a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10259f:	e9 b8 05 00 00       	jmp    102b5c <__alltraps>

001025a4 <vector134>:
.globl vector134
vector134:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $134
  1025a6:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1025ab:	e9 ac 05 00 00       	jmp    102b5c <__alltraps>

001025b0 <vector135>:
.globl vector135
vector135:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $135
  1025b2:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1025b7:	e9 a0 05 00 00       	jmp    102b5c <__alltraps>

001025bc <vector136>:
.globl vector136
vector136:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $136
  1025be:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1025c3:	e9 94 05 00 00       	jmp    102b5c <__alltraps>

001025c8 <vector137>:
.globl vector137
vector137:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $137
  1025ca:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1025cf:	e9 88 05 00 00       	jmp    102b5c <__alltraps>

001025d4 <vector138>:
.globl vector138
vector138:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $138
  1025d6:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1025db:	e9 7c 05 00 00       	jmp    102b5c <__alltraps>

001025e0 <vector139>:
.globl vector139
vector139:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $139
  1025e2:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1025e7:	e9 70 05 00 00       	jmp    102b5c <__alltraps>

001025ec <vector140>:
.globl vector140
vector140:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $140
  1025ee:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1025f3:	e9 64 05 00 00       	jmp    102b5c <__alltraps>

001025f8 <vector141>:
.globl vector141
vector141:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $141
  1025fa:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1025ff:	e9 58 05 00 00       	jmp    102b5c <__alltraps>

00102604 <vector142>:
.globl vector142
vector142:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $142
  102606:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10260b:	e9 4c 05 00 00       	jmp    102b5c <__alltraps>

00102610 <vector143>:
.globl vector143
vector143:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $143
  102612:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102617:	e9 40 05 00 00       	jmp    102b5c <__alltraps>

0010261c <vector144>:
.globl vector144
vector144:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $144
  10261e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102623:	e9 34 05 00 00       	jmp    102b5c <__alltraps>

00102628 <vector145>:
.globl vector145
vector145:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $145
  10262a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10262f:	e9 28 05 00 00       	jmp    102b5c <__alltraps>

00102634 <vector146>:
.globl vector146
vector146:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $146
  102636:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10263b:	e9 1c 05 00 00       	jmp    102b5c <__alltraps>

00102640 <vector147>:
.globl vector147
vector147:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $147
  102642:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102647:	e9 10 05 00 00       	jmp    102b5c <__alltraps>

0010264c <vector148>:
.globl vector148
vector148:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $148
  10264e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102653:	e9 04 05 00 00       	jmp    102b5c <__alltraps>

00102658 <vector149>:
.globl vector149
vector149:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $149
  10265a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10265f:	e9 f8 04 00 00       	jmp    102b5c <__alltraps>

00102664 <vector150>:
.globl vector150
vector150:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $150
  102666:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10266b:	e9 ec 04 00 00       	jmp    102b5c <__alltraps>

00102670 <vector151>:
.globl vector151
vector151:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $151
  102672:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102677:	e9 e0 04 00 00       	jmp    102b5c <__alltraps>

0010267c <vector152>:
.globl vector152
vector152:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $152
  10267e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102683:	e9 d4 04 00 00       	jmp    102b5c <__alltraps>

00102688 <vector153>:
.globl vector153
vector153:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $153
  10268a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10268f:	e9 c8 04 00 00       	jmp    102b5c <__alltraps>

00102694 <vector154>:
.globl vector154
vector154:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $154
  102696:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10269b:	e9 bc 04 00 00       	jmp    102b5c <__alltraps>

001026a0 <vector155>:
.globl vector155
vector155:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $155
  1026a2:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1026a7:	e9 b0 04 00 00       	jmp    102b5c <__alltraps>

001026ac <vector156>:
.globl vector156
vector156:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $156
  1026ae:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1026b3:	e9 a4 04 00 00       	jmp    102b5c <__alltraps>

001026b8 <vector157>:
.globl vector157
vector157:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $157
  1026ba:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1026bf:	e9 98 04 00 00       	jmp    102b5c <__alltraps>

001026c4 <vector158>:
.globl vector158
vector158:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $158
  1026c6:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1026cb:	e9 8c 04 00 00       	jmp    102b5c <__alltraps>

001026d0 <vector159>:
.globl vector159
vector159:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $159
  1026d2:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1026d7:	e9 80 04 00 00       	jmp    102b5c <__alltraps>

001026dc <vector160>:
.globl vector160
vector160:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $160
  1026de:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1026e3:	e9 74 04 00 00       	jmp    102b5c <__alltraps>

001026e8 <vector161>:
.globl vector161
vector161:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $161
  1026ea:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1026ef:	e9 68 04 00 00       	jmp    102b5c <__alltraps>

001026f4 <vector162>:
.globl vector162
vector162:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $162
  1026f6:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1026fb:	e9 5c 04 00 00       	jmp    102b5c <__alltraps>

00102700 <vector163>:
.globl vector163
vector163:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $163
  102702:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102707:	e9 50 04 00 00       	jmp    102b5c <__alltraps>

0010270c <vector164>:
.globl vector164
vector164:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $164
  10270e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102713:	e9 44 04 00 00       	jmp    102b5c <__alltraps>

00102718 <vector165>:
.globl vector165
vector165:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $165
  10271a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10271f:	e9 38 04 00 00       	jmp    102b5c <__alltraps>

00102724 <vector166>:
.globl vector166
vector166:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $166
  102726:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10272b:	e9 2c 04 00 00       	jmp    102b5c <__alltraps>

00102730 <vector167>:
.globl vector167
vector167:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $167
  102732:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102737:	e9 20 04 00 00       	jmp    102b5c <__alltraps>

0010273c <vector168>:
.globl vector168
vector168:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $168
  10273e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102743:	e9 14 04 00 00       	jmp    102b5c <__alltraps>

00102748 <vector169>:
.globl vector169
vector169:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $169
  10274a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10274f:	e9 08 04 00 00       	jmp    102b5c <__alltraps>

00102754 <vector170>:
.globl vector170
vector170:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $170
  102756:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10275b:	e9 fc 03 00 00       	jmp    102b5c <__alltraps>

00102760 <vector171>:
.globl vector171
vector171:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $171
  102762:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102767:	e9 f0 03 00 00       	jmp    102b5c <__alltraps>

0010276c <vector172>:
.globl vector172
vector172:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $172
  10276e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102773:	e9 e4 03 00 00       	jmp    102b5c <__alltraps>

00102778 <vector173>:
.globl vector173
vector173:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $173
  10277a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10277f:	e9 d8 03 00 00       	jmp    102b5c <__alltraps>

00102784 <vector174>:
.globl vector174
vector174:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $174
  102786:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10278b:	e9 cc 03 00 00       	jmp    102b5c <__alltraps>

00102790 <vector175>:
.globl vector175
vector175:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $175
  102792:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102797:	e9 c0 03 00 00       	jmp    102b5c <__alltraps>

0010279c <vector176>:
.globl vector176
vector176:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $176
  10279e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1027a3:	e9 b4 03 00 00       	jmp    102b5c <__alltraps>

001027a8 <vector177>:
.globl vector177
vector177:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $177
  1027aa:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1027af:	e9 a8 03 00 00       	jmp    102b5c <__alltraps>

001027b4 <vector178>:
.globl vector178
vector178:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $178
  1027b6:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1027bb:	e9 9c 03 00 00       	jmp    102b5c <__alltraps>

001027c0 <vector179>:
.globl vector179
vector179:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $179
  1027c2:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1027c7:	e9 90 03 00 00       	jmp    102b5c <__alltraps>

001027cc <vector180>:
.globl vector180
vector180:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $180
  1027ce:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1027d3:	e9 84 03 00 00       	jmp    102b5c <__alltraps>

001027d8 <vector181>:
.globl vector181
vector181:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $181
  1027da:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1027df:	e9 78 03 00 00       	jmp    102b5c <__alltraps>

001027e4 <vector182>:
.globl vector182
vector182:
  pushl $0
  1027e4:	6a 00                	push   $0x0
  pushl $182
  1027e6:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1027eb:	e9 6c 03 00 00       	jmp    102b5c <__alltraps>

001027f0 <vector183>:
.globl vector183
vector183:
  pushl $0
  1027f0:	6a 00                	push   $0x0
  pushl $183
  1027f2:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1027f7:	e9 60 03 00 00       	jmp    102b5c <__alltraps>

001027fc <vector184>:
.globl vector184
vector184:
  pushl $0
  1027fc:	6a 00                	push   $0x0
  pushl $184
  1027fe:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102803:	e9 54 03 00 00       	jmp    102b5c <__alltraps>

00102808 <vector185>:
.globl vector185
vector185:
  pushl $0
  102808:	6a 00                	push   $0x0
  pushl $185
  10280a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10280f:	e9 48 03 00 00       	jmp    102b5c <__alltraps>

00102814 <vector186>:
.globl vector186
vector186:
  pushl $0
  102814:	6a 00                	push   $0x0
  pushl $186
  102816:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10281b:	e9 3c 03 00 00       	jmp    102b5c <__alltraps>

00102820 <vector187>:
.globl vector187
vector187:
  pushl $0
  102820:	6a 00                	push   $0x0
  pushl $187
  102822:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102827:	e9 30 03 00 00       	jmp    102b5c <__alltraps>

0010282c <vector188>:
.globl vector188
vector188:
  pushl $0
  10282c:	6a 00                	push   $0x0
  pushl $188
  10282e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102833:	e9 24 03 00 00       	jmp    102b5c <__alltraps>

00102838 <vector189>:
.globl vector189
vector189:
  pushl $0
  102838:	6a 00                	push   $0x0
  pushl $189
  10283a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10283f:	e9 18 03 00 00       	jmp    102b5c <__alltraps>

00102844 <vector190>:
.globl vector190
vector190:
  pushl $0
  102844:	6a 00                	push   $0x0
  pushl $190
  102846:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10284b:	e9 0c 03 00 00       	jmp    102b5c <__alltraps>

00102850 <vector191>:
.globl vector191
vector191:
  pushl $0
  102850:	6a 00                	push   $0x0
  pushl $191
  102852:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102857:	e9 00 03 00 00       	jmp    102b5c <__alltraps>

0010285c <vector192>:
.globl vector192
vector192:
  pushl $0
  10285c:	6a 00                	push   $0x0
  pushl $192
  10285e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102863:	e9 f4 02 00 00       	jmp    102b5c <__alltraps>

00102868 <vector193>:
.globl vector193
vector193:
  pushl $0
  102868:	6a 00                	push   $0x0
  pushl $193
  10286a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10286f:	e9 e8 02 00 00       	jmp    102b5c <__alltraps>

00102874 <vector194>:
.globl vector194
vector194:
  pushl $0
  102874:	6a 00                	push   $0x0
  pushl $194
  102876:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10287b:	e9 dc 02 00 00       	jmp    102b5c <__alltraps>

00102880 <vector195>:
.globl vector195
vector195:
  pushl $0
  102880:	6a 00                	push   $0x0
  pushl $195
  102882:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102887:	e9 d0 02 00 00       	jmp    102b5c <__alltraps>

0010288c <vector196>:
.globl vector196
vector196:
  pushl $0
  10288c:	6a 00                	push   $0x0
  pushl $196
  10288e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102893:	e9 c4 02 00 00       	jmp    102b5c <__alltraps>

00102898 <vector197>:
.globl vector197
vector197:
  pushl $0
  102898:	6a 00                	push   $0x0
  pushl $197
  10289a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10289f:	e9 b8 02 00 00       	jmp    102b5c <__alltraps>

001028a4 <vector198>:
.globl vector198
vector198:
  pushl $0
  1028a4:	6a 00                	push   $0x0
  pushl $198
  1028a6:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1028ab:	e9 ac 02 00 00       	jmp    102b5c <__alltraps>

001028b0 <vector199>:
.globl vector199
vector199:
  pushl $0
  1028b0:	6a 00                	push   $0x0
  pushl $199
  1028b2:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1028b7:	e9 a0 02 00 00       	jmp    102b5c <__alltraps>

001028bc <vector200>:
.globl vector200
vector200:
  pushl $0
  1028bc:	6a 00                	push   $0x0
  pushl $200
  1028be:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1028c3:	e9 94 02 00 00       	jmp    102b5c <__alltraps>

001028c8 <vector201>:
.globl vector201
vector201:
  pushl $0
  1028c8:	6a 00                	push   $0x0
  pushl $201
  1028ca:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1028cf:	e9 88 02 00 00       	jmp    102b5c <__alltraps>

001028d4 <vector202>:
.globl vector202
vector202:
  pushl $0
  1028d4:	6a 00                	push   $0x0
  pushl $202
  1028d6:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1028db:	e9 7c 02 00 00       	jmp    102b5c <__alltraps>

001028e0 <vector203>:
.globl vector203
vector203:
  pushl $0
  1028e0:	6a 00                	push   $0x0
  pushl $203
  1028e2:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1028e7:	e9 70 02 00 00       	jmp    102b5c <__alltraps>

001028ec <vector204>:
.globl vector204
vector204:
  pushl $0
  1028ec:	6a 00                	push   $0x0
  pushl $204
  1028ee:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1028f3:	e9 64 02 00 00       	jmp    102b5c <__alltraps>

001028f8 <vector205>:
.globl vector205
vector205:
  pushl $0
  1028f8:	6a 00                	push   $0x0
  pushl $205
  1028fa:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1028ff:	e9 58 02 00 00       	jmp    102b5c <__alltraps>

00102904 <vector206>:
.globl vector206
vector206:
  pushl $0
  102904:	6a 00                	push   $0x0
  pushl $206
  102906:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10290b:	e9 4c 02 00 00       	jmp    102b5c <__alltraps>

00102910 <vector207>:
.globl vector207
vector207:
  pushl $0
  102910:	6a 00                	push   $0x0
  pushl $207
  102912:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102917:	e9 40 02 00 00       	jmp    102b5c <__alltraps>

0010291c <vector208>:
.globl vector208
vector208:
  pushl $0
  10291c:	6a 00                	push   $0x0
  pushl $208
  10291e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102923:	e9 34 02 00 00       	jmp    102b5c <__alltraps>

00102928 <vector209>:
.globl vector209
vector209:
  pushl $0
  102928:	6a 00                	push   $0x0
  pushl $209
  10292a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10292f:	e9 28 02 00 00       	jmp    102b5c <__alltraps>

00102934 <vector210>:
.globl vector210
vector210:
  pushl $0
  102934:	6a 00                	push   $0x0
  pushl $210
  102936:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10293b:	e9 1c 02 00 00       	jmp    102b5c <__alltraps>

00102940 <vector211>:
.globl vector211
vector211:
  pushl $0
  102940:	6a 00                	push   $0x0
  pushl $211
  102942:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102947:	e9 10 02 00 00       	jmp    102b5c <__alltraps>

0010294c <vector212>:
.globl vector212
vector212:
  pushl $0
  10294c:	6a 00                	push   $0x0
  pushl $212
  10294e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102953:	e9 04 02 00 00       	jmp    102b5c <__alltraps>

00102958 <vector213>:
.globl vector213
vector213:
  pushl $0
  102958:	6a 00                	push   $0x0
  pushl $213
  10295a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10295f:	e9 f8 01 00 00       	jmp    102b5c <__alltraps>

00102964 <vector214>:
.globl vector214
vector214:
  pushl $0
  102964:	6a 00                	push   $0x0
  pushl $214
  102966:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10296b:	e9 ec 01 00 00       	jmp    102b5c <__alltraps>

00102970 <vector215>:
.globl vector215
vector215:
  pushl $0
  102970:	6a 00                	push   $0x0
  pushl $215
  102972:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102977:	e9 e0 01 00 00       	jmp    102b5c <__alltraps>

0010297c <vector216>:
.globl vector216
vector216:
  pushl $0
  10297c:	6a 00                	push   $0x0
  pushl $216
  10297e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102983:	e9 d4 01 00 00       	jmp    102b5c <__alltraps>

00102988 <vector217>:
.globl vector217
vector217:
  pushl $0
  102988:	6a 00                	push   $0x0
  pushl $217
  10298a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10298f:	e9 c8 01 00 00       	jmp    102b5c <__alltraps>

00102994 <vector218>:
.globl vector218
vector218:
  pushl $0
  102994:	6a 00                	push   $0x0
  pushl $218
  102996:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10299b:	e9 bc 01 00 00       	jmp    102b5c <__alltraps>

001029a0 <vector219>:
.globl vector219
vector219:
  pushl $0
  1029a0:	6a 00                	push   $0x0
  pushl $219
  1029a2:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1029a7:	e9 b0 01 00 00       	jmp    102b5c <__alltraps>

001029ac <vector220>:
.globl vector220
vector220:
  pushl $0
  1029ac:	6a 00                	push   $0x0
  pushl $220
  1029ae:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1029b3:	e9 a4 01 00 00       	jmp    102b5c <__alltraps>

001029b8 <vector221>:
.globl vector221
vector221:
  pushl $0
  1029b8:	6a 00                	push   $0x0
  pushl $221
  1029ba:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1029bf:	e9 98 01 00 00       	jmp    102b5c <__alltraps>

001029c4 <vector222>:
.globl vector222
vector222:
  pushl $0
  1029c4:	6a 00                	push   $0x0
  pushl $222
  1029c6:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1029cb:	e9 8c 01 00 00       	jmp    102b5c <__alltraps>

001029d0 <vector223>:
.globl vector223
vector223:
  pushl $0
  1029d0:	6a 00                	push   $0x0
  pushl $223
  1029d2:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1029d7:	e9 80 01 00 00       	jmp    102b5c <__alltraps>

001029dc <vector224>:
.globl vector224
vector224:
  pushl $0
  1029dc:	6a 00                	push   $0x0
  pushl $224
  1029de:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1029e3:	e9 74 01 00 00       	jmp    102b5c <__alltraps>

001029e8 <vector225>:
.globl vector225
vector225:
  pushl $0
  1029e8:	6a 00                	push   $0x0
  pushl $225
  1029ea:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1029ef:	e9 68 01 00 00       	jmp    102b5c <__alltraps>

001029f4 <vector226>:
.globl vector226
vector226:
  pushl $0
  1029f4:	6a 00                	push   $0x0
  pushl $226
  1029f6:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1029fb:	e9 5c 01 00 00       	jmp    102b5c <__alltraps>

00102a00 <vector227>:
.globl vector227
vector227:
  pushl $0
  102a00:	6a 00                	push   $0x0
  pushl $227
  102a02:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102a07:	e9 50 01 00 00       	jmp    102b5c <__alltraps>

00102a0c <vector228>:
.globl vector228
vector228:
  pushl $0
  102a0c:	6a 00                	push   $0x0
  pushl $228
  102a0e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102a13:	e9 44 01 00 00       	jmp    102b5c <__alltraps>

00102a18 <vector229>:
.globl vector229
vector229:
  pushl $0
  102a18:	6a 00                	push   $0x0
  pushl $229
  102a1a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102a1f:	e9 38 01 00 00       	jmp    102b5c <__alltraps>

00102a24 <vector230>:
.globl vector230
vector230:
  pushl $0
  102a24:	6a 00                	push   $0x0
  pushl $230
  102a26:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102a2b:	e9 2c 01 00 00       	jmp    102b5c <__alltraps>

00102a30 <vector231>:
.globl vector231
vector231:
  pushl $0
  102a30:	6a 00                	push   $0x0
  pushl $231
  102a32:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102a37:	e9 20 01 00 00       	jmp    102b5c <__alltraps>

00102a3c <vector232>:
.globl vector232
vector232:
  pushl $0
  102a3c:	6a 00                	push   $0x0
  pushl $232
  102a3e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102a43:	e9 14 01 00 00       	jmp    102b5c <__alltraps>

00102a48 <vector233>:
.globl vector233
vector233:
  pushl $0
  102a48:	6a 00                	push   $0x0
  pushl $233
  102a4a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102a4f:	e9 08 01 00 00       	jmp    102b5c <__alltraps>

00102a54 <vector234>:
.globl vector234
vector234:
  pushl $0
  102a54:	6a 00                	push   $0x0
  pushl $234
  102a56:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102a5b:	e9 fc 00 00 00       	jmp    102b5c <__alltraps>

00102a60 <vector235>:
.globl vector235
vector235:
  pushl $0
  102a60:	6a 00                	push   $0x0
  pushl $235
  102a62:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102a67:	e9 f0 00 00 00       	jmp    102b5c <__alltraps>

00102a6c <vector236>:
.globl vector236
vector236:
  pushl $0
  102a6c:	6a 00                	push   $0x0
  pushl $236
  102a6e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102a73:	e9 e4 00 00 00       	jmp    102b5c <__alltraps>

00102a78 <vector237>:
.globl vector237
vector237:
  pushl $0
  102a78:	6a 00                	push   $0x0
  pushl $237
  102a7a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102a7f:	e9 d8 00 00 00       	jmp    102b5c <__alltraps>

00102a84 <vector238>:
.globl vector238
vector238:
  pushl $0
  102a84:	6a 00                	push   $0x0
  pushl $238
  102a86:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102a8b:	e9 cc 00 00 00       	jmp    102b5c <__alltraps>

00102a90 <vector239>:
.globl vector239
vector239:
  pushl $0
  102a90:	6a 00                	push   $0x0
  pushl $239
  102a92:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102a97:	e9 c0 00 00 00       	jmp    102b5c <__alltraps>

00102a9c <vector240>:
.globl vector240
vector240:
  pushl $0
  102a9c:	6a 00                	push   $0x0
  pushl $240
  102a9e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102aa3:	e9 b4 00 00 00       	jmp    102b5c <__alltraps>

00102aa8 <vector241>:
.globl vector241
vector241:
  pushl $0
  102aa8:	6a 00                	push   $0x0
  pushl $241
  102aaa:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102aaf:	e9 a8 00 00 00       	jmp    102b5c <__alltraps>

00102ab4 <vector242>:
.globl vector242
vector242:
  pushl $0
  102ab4:	6a 00                	push   $0x0
  pushl $242
  102ab6:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102abb:	e9 9c 00 00 00       	jmp    102b5c <__alltraps>

00102ac0 <vector243>:
.globl vector243
vector243:
  pushl $0
  102ac0:	6a 00                	push   $0x0
  pushl $243
  102ac2:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102ac7:	e9 90 00 00 00       	jmp    102b5c <__alltraps>

00102acc <vector244>:
.globl vector244
vector244:
  pushl $0
  102acc:	6a 00                	push   $0x0
  pushl $244
  102ace:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102ad3:	e9 84 00 00 00       	jmp    102b5c <__alltraps>

00102ad8 <vector245>:
.globl vector245
vector245:
  pushl $0
  102ad8:	6a 00                	push   $0x0
  pushl $245
  102ada:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102adf:	e9 78 00 00 00       	jmp    102b5c <__alltraps>

00102ae4 <vector246>:
.globl vector246
vector246:
  pushl $0
  102ae4:	6a 00                	push   $0x0
  pushl $246
  102ae6:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102aeb:	e9 6c 00 00 00       	jmp    102b5c <__alltraps>

00102af0 <vector247>:
.globl vector247
vector247:
  pushl $0
  102af0:	6a 00                	push   $0x0
  pushl $247
  102af2:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102af7:	e9 60 00 00 00       	jmp    102b5c <__alltraps>

00102afc <vector248>:
.globl vector248
vector248:
  pushl $0
  102afc:	6a 00                	push   $0x0
  pushl $248
  102afe:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102b03:	e9 54 00 00 00       	jmp    102b5c <__alltraps>

00102b08 <vector249>:
.globl vector249
vector249:
  pushl $0
  102b08:	6a 00                	push   $0x0
  pushl $249
  102b0a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102b0f:	e9 48 00 00 00       	jmp    102b5c <__alltraps>

00102b14 <vector250>:
.globl vector250
vector250:
  pushl $0
  102b14:	6a 00                	push   $0x0
  pushl $250
  102b16:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102b1b:	e9 3c 00 00 00       	jmp    102b5c <__alltraps>

00102b20 <vector251>:
.globl vector251
vector251:
  pushl $0
  102b20:	6a 00                	push   $0x0
  pushl $251
  102b22:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102b27:	e9 30 00 00 00       	jmp    102b5c <__alltraps>

00102b2c <vector252>:
.globl vector252
vector252:
  pushl $0
  102b2c:	6a 00                	push   $0x0
  pushl $252
  102b2e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102b33:	e9 24 00 00 00       	jmp    102b5c <__alltraps>

00102b38 <vector253>:
.globl vector253
vector253:
  pushl $0
  102b38:	6a 00                	push   $0x0
  pushl $253
  102b3a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102b3f:	e9 18 00 00 00       	jmp    102b5c <__alltraps>

00102b44 <vector254>:
.globl vector254
vector254:
  pushl $0
  102b44:	6a 00                	push   $0x0
  pushl $254
  102b46:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102b4b:	e9 0c 00 00 00       	jmp    102b5c <__alltraps>

00102b50 <vector255>:
.globl vector255
vector255:
  pushl $0
  102b50:	6a 00                	push   $0x0
  pushl $255
  102b52:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102b57:	e9 00 00 00 00       	jmp    102b5c <__alltraps>

00102b5c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102b5c:	1e                   	push   %ds
    pushl %es
  102b5d:	06                   	push   %es
    pushl %fs
  102b5e:	0f a0                	push   %fs
    pushl %gs
  102b60:	0f a8                	push   %gs
    pushal
  102b62:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102b63:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102b68:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102b6a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102b6c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102b6d:	e8 60 f5 ff ff       	call   1020d2 <trap>

    # pop the pushed stack pointer
    popl %esp
  102b72:	5c                   	pop    %esp

00102b73 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102b73:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102b74:	0f a9                	pop    %gs
    popl %fs
  102b76:	0f a1                	pop    %fs
    popl %es
  102b78:	07                   	pop    %es
    popl %ds
  102b79:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102b7a:	83 c4 08             	add    $0x8,%esp
    iret
  102b7d:	cf                   	iret   

00102b7e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b7e:	55                   	push   %ebp
  102b7f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b81:	8b 45 08             	mov    0x8(%ebp),%eax
  102b84:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b87:	b8 23 00 00 00       	mov    $0x23,%eax
  102b8c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b8e:	b8 23 00 00 00       	mov    $0x23,%eax
  102b93:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b95:	b8 10 00 00 00       	mov    $0x10,%eax
  102b9a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b9c:	b8 10 00 00 00       	mov    $0x10,%eax
  102ba1:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102ba3:	b8 10 00 00 00       	mov    $0x10,%eax
  102ba8:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102baa:	ea b1 2b 10 00 08 00 	ljmp   $0x8,$0x102bb1
}
  102bb1:	90                   	nop
  102bb2:	5d                   	pop    %ebp
  102bb3:	c3                   	ret    

00102bb4 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102bb4:	f3 0f 1e fb          	endbr32 
  102bb8:	55                   	push   %ebp
  102bb9:	89 e5                	mov    %esp,%ebp
  102bbb:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102bbe:	b8 80 19 11 00       	mov    $0x111980,%eax
  102bc3:	05 00 04 00 00       	add    $0x400,%eax
  102bc8:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102bcd:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102bd4:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102bd6:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102bdd:	68 00 
  102bdf:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102be4:	0f b7 c0             	movzwl %ax,%eax
  102be7:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102bed:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102bf2:	c1 e8 10             	shr    $0x10,%eax
  102bf5:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102bfa:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102c01:	24 f0                	and    $0xf0,%al
  102c03:	0c 09                	or     $0x9,%al
  102c05:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102c0a:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102c11:	0c 10                	or     $0x10,%al
  102c13:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102c18:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102c1f:	24 9f                	and    $0x9f,%al
  102c21:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102c26:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102c2d:	0c 80                	or     $0x80,%al
  102c2f:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102c34:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102c3b:	24 f0                	and    $0xf0,%al
  102c3d:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102c42:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102c49:	24 ef                	and    $0xef,%al
  102c4b:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102c50:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102c57:	24 df                	and    $0xdf,%al
  102c59:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102c5e:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102c65:	0c 40                	or     $0x40,%al
  102c67:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102c6c:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102c73:	24 7f                	and    $0x7f,%al
  102c75:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102c7a:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102c7f:	c1 e8 18             	shr    $0x18,%eax
  102c82:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102c87:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102c8e:	24 ef                	and    $0xef,%al
  102c90:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102c95:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102c9c:	e8 dd fe ff ff       	call   102b7e <lgdt>
  102ca1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102ca7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102cab:	0f 00 d8             	ltr    %ax
}
  102cae:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102caf:	90                   	nop
  102cb0:	c9                   	leave  
  102cb1:	c3                   	ret    

00102cb2 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102cb2:	f3 0f 1e fb          	endbr32 
  102cb6:	55                   	push   %ebp
  102cb7:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102cb9:	e8 f6 fe ff ff       	call   102bb4 <gdt_init>
}
  102cbe:	90                   	nop
  102cbf:	5d                   	pop    %ebp
  102cc0:	c3                   	ret    

00102cc1 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102cc1:	f3 0f 1e fb          	endbr32 
  102cc5:	55                   	push   %ebp
  102cc6:	89 e5                	mov    %esp,%ebp
  102cc8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ccb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102cd2:	eb 03                	jmp    102cd7 <strlen+0x16>
        cnt ++;
  102cd4:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cda:	8d 50 01             	lea    0x1(%eax),%edx
  102cdd:	89 55 08             	mov    %edx,0x8(%ebp)
  102ce0:	0f b6 00             	movzbl (%eax),%eax
  102ce3:	84 c0                	test   %al,%al
  102ce5:	75 ed                	jne    102cd4 <strlen+0x13>
    }
    return cnt;
  102ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102cea:	c9                   	leave  
  102ceb:	c3                   	ret    

00102cec <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102cec:	f3 0f 1e fb          	endbr32 
  102cf0:	55                   	push   %ebp
  102cf1:	89 e5                	mov    %esp,%ebp
  102cf3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102cf6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102cfd:	eb 03                	jmp    102d02 <strnlen+0x16>
        cnt ++;
  102cff:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d05:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102d08:	73 10                	jae    102d1a <strnlen+0x2e>
  102d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0d:	8d 50 01             	lea    0x1(%eax),%edx
  102d10:	89 55 08             	mov    %edx,0x8(%ebp)
  102d13:	0f b6 00             	movzbl (%eax),%eax
  102d16:	84 c0                	test   %al,%al
  102d18:	75 e5                	jne    102cff <strnlen+0x13>
    }
    return cnt;
  102d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102d1d:	c9                   	leave  
  102d1e:	c3                   	ret    

00102d1f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102d1f:	f3 0f 1e fb          	endbr32 
  102d23:	55                   	push   %ebp
  102d24:	89 e5                	mov    %esp,%ebp
  102d26:	57                   	push   %edi
  102d27:	56                   	push   %esi
  102d28:	83 ec 20             	sub    $0x20,%esp
  102d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102d37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d3d:	89 d1                	mov    %edx,%ecx
  102d3f:	89 c2                	mov    %eax,%edx
  102d41:	89 ce                	mov    %ecx,%esi
  102d43:	89 d7                	mov    %edx,%edi
  102d45:	ac                   	lods   %ds:(%esi),%al
  102d46:	aa                   	stos   %al,%es:(%edi)
  102d47:	84 c0                	test   %al,%al
  102d49:	75 fa                	jne    102d45 <strcpy+0x26>
  102d4b:	89 fa                	mov    %edi,%edx
  102d4d:	89 f1                	mov    %esi,%ecx
  102d4f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102d52:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102d5b:	83 c4 20             	add    $0x20,%esp
  102d5e:	5e                   	pop    %esi
  102d5f:	5f                   	pop    %edi
  102d60:	5d                   	pop    %ebp
  102d61:	c3                   	ret    

00102d62 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102d62:	f3 0f 1e fb          	endbr32 
  102d66:	55                   	push   %ebp
  102d67:	89 e5                	mov    %esp,%ebp
  102d69:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102d72:	eb 1e                	jmp    102d92 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d77:	0f b6 10             	movzbl (%eax),%edx
  102d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d7d:	88 10                	mov    %dl,(%eax)
  102d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d82:	0f b6 00             	movzbl (%eax),%eax
  102d85:	84 c0                	test   %al,%al
  102d87:	74 03                	je     102d8c <strncpy+0x2a>
            src ++;
  102d89:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102d8c:	ff 45 fc             	incl   -0x4(%ebp)
  102d8f:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102d92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d96:	75 dc                	jne    102d74 <strncpy+0x12>
    }
    return dst;
  102d98:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102d9b:	c9                   	leave  
  102d9c:	c3                   	ret    

00102d9d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102d9d:	f3 0f 1e fb          	endbr32 
  102da1:	55                   	push   %ebp
  102da2:	89 e5                	mov    %esp,%ebp
  102da4:	57                   	push   %edi
  102da5:	56                   	push   %esi
  102da6:	83 ec 20             	sub    $0x20,%esp
  102da9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dbb:	89 d1                	mov    %edx,%ecx
  102dbd:	89 c2                	mov    %eax,%edx
  102dbf:	89 ce                	mov    %ecx,%esi
  102dc1:	89 d7                	mov    %edx,%edi
  102dc3:	ac                   	lods   %ds:(%esi),%al
  102dc4:	ae                   	scas   %es:(%edi),%al
  102dc5:	75 08                	jne    102dcf <strcmp+0x32>
  102dc7:	84 c0                	test   %al,%al
  102dc9:	75 f8                	jne    102dc3 <strcmp+0x26>
  102dcb:	31 c0                	xor    %eax,%eax
  102dcd:	eb 04                	jmp    102dd3 <strcmp+0x36>
  102dcf:	19 c0                	sbb    %eax,%eax
  102dd1:	0c 01                	or     $0x1,%al
  102dd3:	89 fa                	mov    %edi,%edx
  102dd5:	89 f1                	mov    %esi,%ecx
  102dd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102dda:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ddd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102de3:	83 c4 20             	add    $0x20,%esp
  102de6:	5e                   	pop    %esi
  102de7:	5f                   	pop    %edi
  102de8:	5d                   	pop    %ebp
  102de9:	c3                   	ret    

00102dea <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102dea:	f3 0f 1e fb          	endbr32 
  102dee:	55                   	push   %ebp
  102def:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102df1:	eb 09                	jmp    102dfc <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102df3:	ff 4d 10             	decl   0x10(%ebp)
  102df6:	ff 45 08             	incl   0x8(%ebp)
  102df9:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e00:	74 1a                	je     102e1c <strncmp+0x32>
  102e02:	8b 45 08             	mov    0x8(%ebp),%eax
  102e05:	0f b6 00             	movzbl (%eax),%eax
  102e08:	84 c0                	test   %al,%al
  102e0a:	74 10                	je     102e1c <strncmp+0x32>
  102e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0f:	0f b6 10             	movzbl (%eax),%edx
  102e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e15:	0f b6 00             	movzbl (%eax),%eax
  102e18:	38 c2                	cmp    %al,%dl
  102e1a:	74 d7                	je     102df3 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102e1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e20:	74 18                	je     102e3a <strncmp+0x50>
  102e22:	8b 45 08             	mov    0x8(%ebp),%eax
  102e25:	0f b6 00             	movzbl (%eax),%eax
  102e28:	0f b6 d0             	movzbl %al,%edx
  102e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e2e:	0f b6 00             	movzbl (%eax),%eax
  102e31:	0f b6 c0             	movzbl %al,%eax
  102e34:	29 c2                	sub    %eax,%edx
  102e36:	89 d0                	mov    %edx,%eax
  102e38:	eb 05                	jmp    102e3f <strncmp+0x55>
  102e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e3f:	5d                   	pop    %ebp
  102e40:	c3                   	ret    

00102e41 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102e41:	f3 0f 1e fb          	endbr32 
  102e45:	55                   	push   %ebp
  102e46:	89 e5                	mov    %esp,%ebp
  102e48:	83 ec 04             	sub    $0x4,%esp
  102e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e4e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102e51:	eb 13                	jmp    102e66 <strchr+0x25>
        if (*s == c) {
  102e53:	8b 45 08             	mov    0x8(%ebp),%eax
  102e56:	0f b6 00             	movzbl (%eax),%eax
  102e59:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102e5c:	75 05                	jne    102e63 <strchr+0x22>
            return (char *)s;
  102e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e61:	eb 12                	jmp    102e75 <strchr+0x34>
        }
        s ++;
  102e63:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102e66:	8b 45 08             	mov    0x8(%ebp),%eax
  102e69:	0f b6 00             	movzbl (%eax),%eax
  102e6c:	84 c0                	test   %al,%al
  102e6e:	75 e3                	jne    102e53 <strchr+0x12>
    }
    return NULL;
  102e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e75:	c9                   	leave  
  102e76:	c3                   	ret    

00102e77 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102e77:	f3 0f 1e fb          	endbr32 
  102e7b:	55                   	push   %ebp
  102e7c:	89 e5                	mov    %esp,%ebp
  102e7e:	83 ec 04             	sub    $0x4,%esp
  102e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e84:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102e87:	eb 0e                	jmp    102e97 <strfind+0x20>
        if (*s == c) {
  102e89:	8b 45 08             	mov    0x8(%ebp),%eax
  102e8c:	0f b6 00             	movzbl (%eax),%eax
  102e8f:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102e92:	74 0f                	je     102ea3 <strfind+0x2c>
            break;
        }
        s ++;
  102e94:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102e97:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9a:	0f b6 00             	movzbl (%eax),%eax
  102e9d:	84 c0                	test   %al,%al
  102e9f:	75 e8                	jne    102e89 <strfind+0x12>
  102ea1:	eb 01                	jmp    102ea4 <strfind+0x2d>
            break;
  102ea3:	90                   	nop
    }
    return (char *)s;
  102ea4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ea7:	c9                   	leave  
  102ea8:	c3                   	ret    

00102ea9 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102ea9:	f3 0f 1e fb          	endbr32 
  102ead:	55                   	push   %ebp
  102eae:	89 e5                	mov    %esp,%ebp
  102eb0:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102eb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102eba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102ec1:	eb 03                	jmp    102ec6 <strtol+0x1d>
        s ++;
  102ec3:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec9:	0f b6 00             	movzbl (%eax),%eax
  102ecc:	3c 20                	cmp    $0x20,%al
  102ece:	74 f3                	je     102ec3 <strtol+0x1a>
  102ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed3:	0f b6 00             	movzbl (%eax),%eax
  102ed6:	3c 09                	cmp    $0x9,%al
  102ed8:	74 e9                	je     102ec3 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102eda:	8b 45 08             	mov    0x8(%ebp),%eax
  102edd:	0f b6 00             	movzbl (%eax),%eax
  102ee0:	3c 2b                	cmp    $0x2b,%al
  102ee2:	75 05                	jne    102ee9 <strtol+0x40>
        s ++;
  102ee4:	ff 45 08             	incl   0x8(%ebp)
  102ee7:	eb 14                	jmp    102efd <strtol+0x54>
    }
    else if (*s == '-') {
  102ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  102eec:	0f b6 00             	movzbl (%eax),%eax
  102eef:	3c 2d                	cmp    $0x2d,%al
  102ef1:	75 0a                	jne    102efd <strtol+0x54>
        s ++, neg = 1;
  102ef3:	ff 45 08             	incl   0x8(%ebp)
  102ef6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102efd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f01:	74 06                	je     102f09 <strtol+0x60>
  102f03:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102f07:	75 22                	jne    102f2b <strtol+0x82>
  102f09:	8b 45 08             	mov    0x8(%ebp),%eax
  102f0c:	0f b6 00             	movzbl (%eax),%eax
  102f0f:	3c 30                	cmp    $0x30,%al
  102f11:	75 18                	jne    102f2b <strtol+0x82>
  102f13:	8b 45 08             	mov    0x8(%ebp),%eax
  102f16:	40                   	inc    %eax
  102f17:	0f b6 00             	movzbl (%eax),%eax
  102f1a:	3c 78                	cmp    $0x78,%al
  102f1c:	75 0d                	jne    102f2b <strtol+0x82>
        s += 2, base = 16;
  102f1e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102f22:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102f29:	eb 29                	jmp    102f54 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102f2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f2f:	75 16                	jne    102f47 <strtol+0x9e>
  102f31:	8b 45 08             	mov    0x8(%ebp),%eax
  102f34:	0f b6 00             	movzbl (%eax),%eax
  102f37:	3c 30                	cmp    $0x30,%al
  102f39:	75 0c                	jne    102f47 <strtol+0x9e>
        s ++, base = 8;
  102f3b:	ff 45 08             	incl   0x8(%ebp)
  102f3e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102f45:	eb 0d                	jmp    102f54 <strtol+0xab>
    }
    else if (base == 0) {
  102f47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f4b:	75 07                	jne    102f54 <strtol+0xab>
        base = 10;
  102f4d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102f54:	8b 45 08             	mov    0x8(%ebp),%eax
  102f57:	0f b6 00             	movzbl (%eax),%eax
  102f5a:	3c 2f                	cmp    $0x2f,%al
  102f5c:	7e 1b                	jle    102f79 <strtol+0xd0>
  102f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f61:	0f b6 00             	movzbl (%eax),%eax
  102f64:	3c 39                	cmp    $0x39,%al
  102f66:	7f 11                	jg     102f79 <strtol+0xd0>
            dig = *s - '0';
  102f68:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6b:	0f b6 00             	movzbl (%eax),%eax
  102f6e:	0f be c0             	movsbl %al,%eax
  102f71:	83 e8 30             	sub    $0x30,%eax
  102f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f77:	eb 48                	jmp    102fc1 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102f79:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7c:	0f b6 00             	movzbl (%eax),%eax
  102f7f:	3c 60                	cmp    $0x60,%al
  102f81:	7e 1b                	jle    102f9e <strtol+0xf5>
  102f83:	8b 45 08             	mov    0x8(%ebp),%eax
  102f86:	0f b6 00             	movzbl (%eax),%eax
  102f89:	3c 7a                	cmp    $0x7a,%al
  102f8b:	7f 11                	jg     102f9e <strtol+0xf5>
            dig = *s - 'a' + 10;
  102f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f90:	0f b6 00             	movzbl (%eax),%eax
  102f93:	0f be c0             	movsbl %al,%eax
  102f96:	83 e8 57             	sub    $0x57,%eax
  102f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f9c:	eb 23                	jmp    102fc1 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa1:	0f b6 00             	movzbl (%eax),%eax
  102fa4:	3c 40                	cmp    $0x40,%al
  102fa6:	7e 3b                	jle    102fe3 <strtol+0x13a>
  102fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  102fab:	0f b6 00             	movzbl (%eax),%eax
  102fae:	3c 5a                	cmp    $0x5a,%al
  102fb0:	7f 31                	jg     102fe3 <strtol+0x13a>
            dig = *s - 'A' + 10;
  102fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb5:	0f b6 00             	movzbl (%eax),%eax
  102fb8:	0f be c0             	movsbl %al,%eax
  102fbb:	83 e8 37             	sub    $0x37,%eax
  102fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fc4:	3b 45 10             	cmp    0x10(%ebp),%eax
  102fc7:	7d 19                	jge    102fe2 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102fc9:	ff 45 08             	incl   0x8(%ebp)
  102fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fcf:	0f af 45 10          	imul   0x10(%ebp),%eax
  102fd3:	89 c2                	mov    %eax,%edx
  102fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fd8:	01 d0                	add    %edx,%eax
  102fda:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102fdd:	e9 72 ff ff ff       	jmp    102f54 <strtol+0xab>
            break;
  102fe2:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102fe3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102fe7:	74 08                	je     102ff1 <strtol+0x148>
        *endptr = (char *) s;
  102fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fec:	8b 55 08             	mov    0x8(%ebp),%edx
  102fef:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102ff1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102ff5:	74 07                	je     102ffe <strtol+0x155>
  102ff7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ffa:	f7 d8                	neg    %eax
  102ffc:	eb 03                	jmp    103001 <strtol+0x158>
  102ffe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103001:	c9                   	leave  
  103002:	c3                   	ret    

00103003 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103003:	f3 0f 1e fb          	endbr32 
  103007:	55                   	push   %ebp
  103008:	89 e5                	mov    %esp,%ebp
  10300a:	57                   	push   %edi
  10300b:	83 ec 24             	sub    $0x24,%esp
  10300e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103011:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103014:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  103018:	8b 45 08             	mov    0x8(%ebp),%eax
  10301b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10301e:	88 55 f7             	mov    %dl,-0x9(%ebp)
  103021:	8b 45 10             	mov    0x10(%ebp),%eax
  103024:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103027:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10302a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10302e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103031:	89 d7                	mov    %edx,%edi
  103033:	f3 aa                	rep stos %al,%es:(%edi)
  103035:	89 fa                	mov    %edi,%edx
  103037:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10303a:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10303d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103040:	83 c4 24             	add    $0x24,%esp
  103043:	5f                   	pop    %edi
  103044:	5d                   	pop    %ebp
  103045:	c3                   	ret    

00103046 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103046:	f3 0f 1e fb          	endbr32 
  10304a:	55                   	push   %ebp
  10304b:	89 e5                	mov    %esp,%ebp
  10304d:	57                   	push   %edi
  10304e:	56                   	push   %esi
  10304f:	53                   	push   %ebx
  103050:	83 ec 30             	sub    $0x30,%esp
  103053:	8b 45 08             	mov    0x8(%ebp),%eax
  103056:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103059:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10305f:	8b 45 10             	mov    0x10(%ebp),%eax
  103062:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103068:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10306b:	73 42                	jae    1030af <memmove+0x69>
  10306d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103070:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103073:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103076:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103079:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10307c:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10307f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103082:	c1 e8 02             	shr    $0x2,%eax
  103085:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103087:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10308a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10308d:	89 d7                	mov    %edx,%edi
  10308f:	89 c6                	mov    %eax,%esi
  103091:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103093:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103096:	83 e1 03             	and    $0x3,%ecx
  103099:	74 02                	je     10309d <memmove+0x57>
  10309b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10309d:	89 f0                	mov    %esi,%eax
  10309f:	89 fa                	mov    %edi,%edx
  1030a1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1030a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1030a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  1030aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  1030ad:	eb 36                	jmp    1030e5 <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1030af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030b8:	01 c2                	add    %eax,%edx
  1030ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030bd:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1030c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030c3:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1030c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030c9:	89 c1                	mov    %eax,%ecx
  1030cb:	89 d8                	mov    %ebx,%eax
  1030cd:	89 d6                	mov    %edx,%esi
  1030cf:	89 c7                	mov    %eax,%edi
  1030d1:	fd                   	std    
  1030d2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1030d4:	fc                   	cld    
  1030d5:	89 f8                	mov    %edi,%eax
  1030d7:	89 f2                	mov    %esi,%edx
  1030d9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1030dc:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1030df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1030e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1030e5:	83 c4 30             	add    $0x30,%esp
  1030e8:	5b                   	pop    %ebx
  1030e9:	5e                   	pop    %esi
  1030ea:	5f                   	pop    %edi
  1030eb:	5d                   	pop    %ebp
  1030ec:	c3                   	ret    

001030ed <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1030ed:	f3 0f 1e fb          	endbr32 
  1030f1:	55                   	push   %ebp
  1030f2:	89 e5                	mov    %esp,%ebp
  1030f4:	57                   	push   %edi
  1030f5:	56                   	push   %esi
  1030f6:	83 ec 20             	sub    $0x20,%esp
  1030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  103102:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103105:	8b 45 10             	mov    0x10(%ebp),%eax
  103108:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10310b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10310e:	c1 e8 02             	shr    $0x2,%eax
  103111:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103113:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103119:	89 d7                	mov    %edx,%edi
  10311b:	89 c6                	mov    %eax,%esi
  10311d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10311f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103122:	83 e1 03             	and    $0x3,%ecx
  103125:	74 02                	je     103129 <memcpy+0x3c>
  103127:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103129:	89 f0                	mov    %esi,%eax
  10312b:	89 fa                	mov    %edi,%edx
  10312d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103130:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103133:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103136:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103139:	83 c4 20             	add    $0x20,%esp
  10313c:	5e                   	pop    %esi
  10313d:	5f                   	pop    %edi
  10313e:	5d                   	pop    %ebp
  10313f:	c3                   	ret    

00103140 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103140:	f3 0f 1e fb          	endbr32 
  103144:	55                   	push   %ebp
  103145:	89 e5                	mov    %esp,%ebp
  103147:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10314a:	8b 45 08             	mov    0x8(%ebp),%eax
  10314d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103150:	8b 45 0c             	mov    0xc(%ebp),%eax
  103153:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103156:	eb 2e                	jmp    103186 <memcmp+0x46>
        if (*s1 != *s2) {
  103158:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10315b:	0f b6 10             	movzbl (%eax),%edx
  10315e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103161:	0f b6 00             	movzbl (%eax),%eax
  103164:	38 c2                	cmp    %al,%dl
  103166:	74 18                	je     103180 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103168:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10316b:	0f b6 00             	movzbl (%eax),%eax
  10316e:	0f b6 d0             	movzbl %al,%edx
  103171:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103174:	0f b6 00             	movzbl (%eax),%eax
  103177:	0f b6 c0             	movzbl %al,%eax
  10317a:	29 c2                	sub    %eax,%edx
  10317c:	89 d0                	mov    %edx,%eax
  10317e:	eb 18                	jmp    103198 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  103180:	ff 45 fc             	incl   -0x4(%ebp)
  103183:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103186:	8b 45 10             	mov    0x10(%ebp),%eax
  103189:	8d 50 ff             	lea    -0x1(%eax),%edx
  10318c:	89 55 10             	mov    %edx,0x10(%ebp)
  10318f:	85 c0                	test   %eax,%eax
  103191:	75 c5                	jne    103158 <memcmp+0x18>
    }
    return 0;
  103193:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103198:	c9                   	leave  
  103199:	c3                   	ret    

0010319a <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10319a:	f3 0f 1e fb          	endbr32 
  10319e:	55                   	push   %ebp
  10319f:	89 e5                	mov    %esp,%ebp
  1031a1:	83 ec 58             	sub    $0x58,%esp
  1031a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1031a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1031aa:	8b 45 14             	mov    0x14(%ebp),%eax
  1031ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1031b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1031b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031b9:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1031bc:	8b 45 18             	mov    0x18(%ebp),%eax
  1031bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1031c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1031c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1031cb:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1031ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1031d8:	74 1c                	je     1031f6 <printnum+0x5c>
  1031da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031dd:	ba 00 00 00 00       	mov    $0x0,%edx
  1031e2:	f7 75 e4             	divl   -0x1c(%ebp)
  1031e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1031e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031eb:	ba 00 00 00 00       	mov    $0x0,%edx
  1031f0:	f7 75 e4             	divl   -0x1c(%ebp)
  1031f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031fc:	f7 75 e4             	divl   -0x1c(%ebp)
  1031ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103202:	89 55 dc             	mov    %edx,-0x24(%ebp)
  103205:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103208:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10320b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10320e:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103211:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103214:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103217:	8b 45 18             	mov    0x18(%ebp),%eax
  10321a:	ba 00 00 00 00       	mov    $0x0,%edx
  10321f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103222:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103225:	19 d1                	sbb    %edx,%ecx
  103227:	72 4c                	jb     103275 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  103229:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10322c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10322f:	8b 45 20             	mov    0x20(%ebp),%eax
  103232:	89 44 24 18          	mov    %eax,0x18(%esp)
  103236:	89 54 24 14          	mov    %edx,0x14(%esp)
  10323a:	8b 45 18             	mov    0x18(%ebp),%eax
  10323d:	89 44 24 10          	mov    %eax,0x10(%esp)
  103241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103244:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103247:	89 44 24 08          	mov    %eax,0x8(%esp)
  10324b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10324f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103252:	89 44 24 04          	mov    %eax,0x4(%esp)
  103256:	8b 45 08             	mov    0x8(%ebp),%eax
  103259:	89 04 24             	mov    %eax,(%esp)
  10325c:	e8 39 ff ff ff       	call   10319a <printnum>
  103261:	eb 1b                	jmp    10327e <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103263:	8b 45 0c             	mov    0xc(%ebp),%eax
  103266:	89 44 24 04          	mov    %eax,0x4(%esp)
  10326a:	8b 45 20             	mov    0x20(%ebp),%eax
  10326d:	89 04 24             	mov    %eax,(%esp)
  103270:	8b 45 08             	mov    0x8(%ebp),%eax
  103273:	ff d0                	call   *%eax
        while (-- width > 0)
  103275:	ff 4d 1c             	decl   0x1c(%ebp)
  103278:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10327c:	7f e5                	jg     103263 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10327e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103281:	05 10 40 10 00       	add    $0x104010,%eax
  103286:	0f b6 00             	movzbl (%eax),%eax
  103289:	0f be c0             	movsbl %al,%eax
  10328c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10328f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103293:	89 04 24             	mov    %eax,(%esp)
  103296:	8b 45 08             	mov    0x8(%ebp),%eax
  103299:	ff d0                	call   *%eax
}
  10329b:	90                   	nop
  10329c:	c9                   	leave  
  10329d:	c3                   	ret    

0010329e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10329e:	f3 0f 1e fb          	endbr32 
  1032a2:	55                   	push   %ebp
  1032a3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1032a5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1032a9:	7e 14                	jle    1032bf <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  1032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ae:	8b 00                	mov    (%eax),%eax
  1032b0:	8d 48 08             	lea    0x8(%eax),%ecx
  1032b3:	8b 55 08             	mov    0x8(%ebp),%edx
  1032b6:	89 0a                	mov    %ecx,(%edx)
  1032b8:	8b 50 04             	mov    0x4(%eax),%edx
  1032bb:	8b 00                	mov    (%eax),%eax
  1032bd:	eb 30                	jmp    1032ef <getuint+0x51>
    }
    else if (lflag) {
  1032bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032c3:	74 16                	je     1032db <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  1032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c8:	8b 00                	mov    (%eax),%eax
  1032ca:	8d 48 04             	lea    0x4(%eax),%ecx
  1032cd:	8b 55 08             	mov    0x8(%ebp),%edx
  1032d0:	89 0a                	mov    %ecx,(%edx)
  1032d2:	8b 00                	mov    (%eax),%eax
  1032d4:	ba 00 00 00 00       	mov    $0x0,%edx
  1032d9:	eb 14                	jmp    1032ef <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  1032db:	8b 45 08             	mov    0x8(%ebp),%eax
  1032de:	8b 00                	mov    (%eax),%eax
  1032e0:	8d 48 04             	lea    0x4(%eax),%ecx
  1032e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1032e6:	89 0a                	mov    %ecx,(%edx)
  1032e8:	8b 00                	mov    (%eax),%eax
  1032ea:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1032ef:	5d                   	pop    %ebp
  1032f0:	c3                   	ret    

001032f1 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1032f1:	f3 0f 1e fb          	endbr32 
  1032f5:	55                   	push   %ebp
  1032f6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1032f8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1032fc:	7e 14                	jle    103312 <getint+0x21>
        return va_arg(*ap, long long);
  1032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103301:	8b 00                	mov    (%eax),%eax
  103303:	8d 48 08             	lea    0x8(%eax),%ecx
  103306:	8b 55 08             	mov    0x8(%ebp),%edx
  103309:	89 0a                	mov    %ecx,(%edx)
  10330b:	8b 50 04             	mov    0x4(%eax),%edx
  10330e:	8b 00                	mov    (%eax),%eax
  103310:	eb 28                	jmp    10333a <getint+0x49>
    }
    else if (lflag) {
  103312:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103316:	74 12                	je     10332a <getint+0x39>
        return va_arg(*ap, long);
  103318:	8b 45 08             	mov    0x8(%ebp),%eax
  10331b:	8b 00                	mov    (%eax),%eax
  10331d:	8d 48 04             	lea    0x4(%eax),%ecx
  103320:	8b 55 08             	mov    0x8(%ebp),%edx
  103323:	89 0a                	mov    %ecx,(%edx)
  103325:	8b 00                	mov    (%eax),%eax
  103327:	99                   	cltd   
  103328:	eb 10                	jmp    10333a <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  10332a:	8b 45 08             	mov    0x8(%ebp),%eax
  10332d:	8b 00                	mov    (%eax),%eax
  10332f:	8d 48 04             	lea    0x4(%eax),%ecx
  103332:	8b 55 08             	mov    0x8(%ebp),%edx
  103335:	89 0a                	mov    %ecx,(%edx)
  103337:	8b 00                	mov    (%eax),%eax
  103339:	99                   	cltd   
    }
}
  10333a:	5d                   	pop    %ebp
  10333b:	c3                   	ret    

0010333c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10333c:	f3 0f 1e fb          	endbr32 
  103340:	55                   	push   %ebp
  103341:	89 e5                	mov    %esp,%ebp
  103343:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103346:	8d 45 14             	lea    0x14(%ebp),%eax
  103349:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10334f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103353:	8b 45 10             	mov    0x10(%ebp),%eax
  103356:	89 44 24 08          	mov    %eax,0x8(%esp)
  10335a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10335d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103361:	8b 45 08             	mov    0x8(%ebp),%eax
  103364:	89 04 24             	mov    %eax,(%esp)
  103367:	e8 03 00 00 00       	call   10336f <vprintfmt>
    va_end(ap);
}
  10336c:	90                   	nop
  10336d:	c9                   	leave  
  10336e:	c3                   	ret    

0010336f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10336f:	f3 0f 1e fb          	endbr32 
  103373:	55                   	push   %ebp
  103374:	89 e5                	mov    %esp,%ebp
  103376:	56                   	push   %esi
  103377:	53                   	push   %ebx
  103378:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10337b:	eb 17                	jmp    103394 <vprintfmt+0x25>
            if (ch == '\0') {
  10337d:	85 db                	test   %ebx,%ebx
  10337f:	0f 84 c0 03 00 00    	je     103745 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  103385:	8b 45 0c             	mov    0xc(%ebp),%eax
  103388:	89 44 24 04          	mov    %eax,0x4(%esp)
  10338c:	89 1c 24             	mov    %ebx,(%esp)
  10338f:	8b 45 08             	mov    0x8(%ebp),%eax
  103392:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103394:	8b 45 10             	mov    0x10(%ebp),%eax
  103397:	8d 50 01             	lea    0x1(%eax),%edx
  10339a:	89 55 10             	mov    %edx,0x10(%ebp)
  10339d:	0f b6 00             	movzbl (%eax),%eax
  1033a0:	0f b6 d8             	movzbl %al,%ebx
  1033a3:	83 fb 25             	cmp    $0x25,%ebx
  1033a6:	75 d5                	jne    10337d <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1033a8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1033ac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1033b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1033b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1033c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1033c3:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1033c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1033c9:	8d 50 01             	lea    0x1(%eax),%edx
  1033cc:	89 55 10             	mov    %edx,0x10(%ebp)
  1033cf:	0f b6 00             	movzbl (%eax),%eax
  1033d2:	0f b6 d8             	movzbl %al,%ebx
  1033d5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1033d8:	83 f8 55             	cmp    $0x55,%eax
  1033db:	0f 87 38 03 00 00    	ja     103719 <vprintfmt+0x3aa>
  1033e1:	8b 04 85 34 40 10 00 	mov    0x104034(,%eax,4),%eax
  1033e8:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1033eb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1033ef:	eb d5                	jmp    1033c6 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1033f1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1033f5:	eb cf                	jmp    1033c6 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1033f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1033fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103401:	89 d0                	mov    %edx,%eax
  103403:	c1 e0 02             	shl    $0x2,%eax
  103406:	01 d0                	add    %edx,%eax
  103408:	01 c0                	add    %eax,%eax
  10340a:	01 d8                	add    %ebx,%eax
  10340c:	83 e8 30             	sub    $0x30,%eax
  10340f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103412:	8b 45 10             	mov    0x10(%ebp),%eax
  103415:	0f b6 00             	movzbl (%eax),%eax
  103418:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10341b:	83 fb 2f             	cmp    $0x2f,%ebx
  10341e:	7e 38                	jle    103458 <vprintfmt+0xe9>
  103420:	83 fb 39             	cmp    $0x39,%ebx
  103423:	7f 33                	jg     103458 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  103425:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103428:	eb d4                	jmp    1033fe <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10342a:	8b 45 14             	mov    0x14(%ebp),%eax
  10342d:	8d 50 04             	lea    0x4(%eax),%edx
  103430:	89 55 14             	mov    %edx,0x14(%ebp)
  103433:	8b 00                	mov    (%eax),%eax
  103435:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103438:	eb 1f                	jmp    103459 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  10343a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10343e:	79 86                	jns    1033c6 <vprintfmt+0x57>
                width = 0;
  103440:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103447:	e9 7a ff ff ff       	jmp    1033c6 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  10344c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  103453:	e9 6e ff ff ff       	jmp    1033c6 <vprintfmt+0x57>
            goto process_precision;
  103458:	90                   	nop

        process_precision:
            if (width < 0)
  103459:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10345d:	0f 89 63 ff ff ff    	jns    1033c6 <vprintfmt+0x57>
                width = precision, precision = -1;
  103463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103466:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103469:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103470:	e9 51 ff ff ff       	jmp    1033c6 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103475:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  103478:	e9 49 ff ff ff       	jmp    1033c6 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10347d:	8b 45 14             	mov    0x14(%ebp),%eax
  103480:	8d 50 04             	lea    0x4(%eax),%edx
  103483:	89 55 14             	mov    %edx,0x14(%ebp)
  103486:	8b 00                	mov    (%eax),%eax
  103488:	8b 55 0c             	mov    0xc(%ebp),%edx
  10348b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10348f:	89 04 24             	mov    %eax,(%esp)
  103492:	8b 45 08             	mov    0x8(%ebp),%eax
  103495:	ff d0                	call   *%eax
            break;
  103497:	e9 a4 02 00 00       	jmp    103740 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10349c:	8b 45 14             	mov    0x14(%ebp),%eax
  10349f:	8d 50 04             	lea    0x4(%eax),%edx
  1034a2:	89 55 14             	mov    %edx,0x14(%ebp)
  1034a5:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1034a7:	85 db                	test   %ebx,%ebx
  1034a9:	79 02                	jns    1034ad <vprintfmt+0x13e>
                err = -err;
  1034ab:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1034ad:	83 fb 06             	cmp    $0x6,%ebx
  1034b0:	7f 0b                	jg     1034bd <vprintfmt+0x14e>
  1034b2:	8b 34 9d f4 3f 10 00 	mov    0x103ff4(,%ebx,4),%esi
  1034b9:	85 f6                	test   %esi,%esi
  1034bb:	75 23                	jne    1034e0 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  1034bd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1034c1:	c7 44 24 08 21 40 10 	movl   $0x104021,0x8(%esp)
  1034c8:	00 
  1034c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1034d3:	89 04 24             	mov    %eax,(%esp)
  1034d6:	e8 61 fe ff ff       	call   10333c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1034db:	e9 60 02 00 00       	jmp    103740 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  1034e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1034e4:	c7 44 24 08 2a 40 10 	movl   $0x10402a,0x8(%esp)
  1034eb:	00 
  1034ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1034f6:	89 04 24             	mov    %eax,(%esp)
  1034f9:	e8 3e fe ff ff       	call   10333c <printfmt>
            break;
  1034fe:	e9 3d 02 00 00       	jmp    103740 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103503:	8b 45 14             	mov    0x14(%ebp),%eax
  103506:	8d 50 04             	lea    0x4(%eax),%edx
  103509:	89 55 14             	mov    %edx,0x14(%ebp)
  10350c:	8b 30                	mov    (%eax),%esi
  10350e:	85 f6                	test   %esi,%esi
  103510:	75 05                	jne    103517 <vprintfmt+0x1a8>
                p = "(null)";
  103512:	be 2d 40 10 00       	mov    $0x10402d,%esi
            }
            if (width > 0 && padc != '-') {
  103517:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10351b:	7e 76                	jle    103593 <vprintfmt+0x224>
  10351d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103521:	74 70                	je     103593 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103526:	89 44 24 04          	mov    %eax,0x4(%esp)
  10352a:	89 34 24             	mov    %esi,(%esp)
  10352d:	e8 ba f7 ff ff       	call   102cec <strnlen>
  103532:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103535:	29 c2                	sub    %eax,%edx
  103537:	89 d0                	mov    %edx,%eax
  103539:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10353c:	eb 16                	jmp    103554 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  10353e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103542:	8b 55 0c             	mov    0xc(%ebp),%edx
  103545:	89 54 24 04          	mov    %edx,0x4(%esp)
  103549:	89 04 24             	mov    %eax,(%esp)
  10354c:	8b 45 08             	mov    0x8(%ebp),%eax
  10354f:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  103551:	ff 4d e8             	decl   -0x18(%ebp)
  103554:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103558:	7f e4                	jg     10353e <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10355a:	eb 37                	jmp    103593 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  10355c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103560:	74 1f                	je     103581 <vprintfmt+0x212>
  103562:	83 fb 1f             	cmp    $0x1f,%ebx
  103565:	7e 05                	jle    10356c <vprintfmt+0x1fd>
  103567:	83 fb 7e             	cmp    $0x7e,%ebx
  10356a:	7e 15                	jle    103581 <vprintfmt+0x212>
                    putch('?', putdat);
  10356c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10356f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103573:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10357a:	8b 45 08             	mov    0x8(%ebp),%eax
  10357d:	ff d0                	call   *%eax
  10357f:	eb 0f                	jmp    103590 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  103581:	8b 45 0c             	mov    0xc(%ebp),%eax
  103584:	89 44 24 04          	mov    %eax,0x4(%esp)
  103588:	89 1c 24             	mov    %ebx,(%esp)
  10358b:	8b 45 08             	mov    0x8(%ebp),%eax
  10358e:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103590:	ff 4d e8             	decl   -0x18(%ebp)
  103593:	89 f0                	mov    %esi,%eax
  103595:	8d 70 01             	lea    0x1(%eax),%esi
  103598:	0f b6 00             	movzbl (%eax),%eax
  10359b:	0f be d8             	movsbl %al,%ebx
  10359e:	85 db                	test   %ebx,%ebx
  1035a0:	74 27                	je     1035c9 <vprintfmt+0x25a>
  1035a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1035a6:	78 b4                	js     10355c <vprintfmt+0x1ed>
  1035a8:	ff 4d e4             	decl   -0x1c(%ebp)
  1035ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1035af:	79 ab                	jns    10355c <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  1035b1:	eb 16                	jmp    1035c9 <vprintfmt+0x25a>
                putch(' ', putdat);
  1035b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035ba:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1035c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1035c4:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1035c6:	ff 4d e8             	decl   -0x18(%ebp)
  1035c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1035cd:	7f e4                	jg     1035b3 <vprintfmt+0x244>
            }
            break;
  1035cf:	e9 6c 01 00 00       	jmp    103740 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1035d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035db:	8d 45 14             	lea    0x14(%ebp),%eax
  1035de:	89 04 24             	mov    %eax,(%esp)
  1035e1:	e8 0b fd ff ff       	call   1032f1 <getint>
  1035e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1035ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035f2:	85 d2                	test   %edx,%edx
  1035f4:	79 26                	jns    10361c <vprintfmt+0x2ad>
                putch('-', putdat);
  1035f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035fd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  103604:	8b 45 08             	mov    0x8(%ebp),%eax
  103607:	ff d0                	call   *%eax
                num = -(long long)num;
  103609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10360c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10360f:	f7 d8                	neg    %eax
  103611:	83 d2 00             	adc    $0x0,%edx
  103614:	f7 da                	neg    %edx
  103616:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103619:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10361c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103623:	e9 a8 00 00 00       	jmp    1036d0 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103628:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10362b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10362f:	8d 45 14             	lea    0x14(%ebp),%eax
  103632:	89 04 24             	mov    %eax,(%esp)
  103635:	e8 64 fc ff ff       	call   10329e <getuint>
  10363a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10363d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103640:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103647:	e9 84 00 00 00       	jmp    1036d0 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10364c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10364f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103653:	8d 45 14             	lea    0x14(%ebp),%eax
  103656:	89 04 24             	mov    %eax,(%esp)
  103659:	e8 40 fc ff ff       	call   10329e <getuint>
  10365e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103661:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103664:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10366b:	eb 63                	jmp    1036d0 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  10366d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103670:	89 44 24 04          	mov    %eax,0x4(%esp)
  103674:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10367b:	8b 45 08             	mov    0x8(%ebp),%eax
  10367e:	ff d0                	call   *%eax
            putch('x', putdat);
  103680:	8b 45 0c             	mov    0xc(%ebp),%eax
  103683:	89 44 24 04          	mov    %eax,0x4(%esp)
  103687:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10368e:	8b 45 08             	mov    0x8(%ebp),%eax
  103691:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103693:	8b 45 14             	mov    0x14(%ebp),%eax
  103696:	8d 50 04             	lea    0x4(%eax),%edx
  103699:	89 55 14             	mov    %edx,0x14(%ebp)
  10369c:	8b 00                	mov    (%eax),%eax
  10369e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1036a8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1036af:	eb 1f                	jmp    1036d0 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1036b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036b8:	8d 45 14             	lea    0x14(%ebp),%eax
  1036bb:	89 04 24             	mov    %eax,(%esp)
  1036be:	e8 db fb ff ff       	call   10329e <getuint>
  1036c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1036c9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1036d0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1036d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036d7:	89 54 24 18          	mov    %edx,0x18(%esp)
  1036db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1036de:	89 54 24 14          	mov    %edx,0x14(%esp)
  1036e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1036e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1036ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1036f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1036fe:	89 04 24             	mov    %eax,(%esp)
  103701:	e8 94 fa ff ff       	call   10319a <printnum>
            break;
  103706:	eb 38                	jmp    103740 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103708:	8b 45 0c             	mov    0xc(%ebp),%eax
  10370b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10370f:	89 1c 24             	mov    %ebx,(%esp)
  103712:	8b 45 08             	mov    0x8(%ebp),%eax
  103715:	ff d0                	call   *%eax
            break;
  103717:	eb 27                	jmp    103740 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103719:	8b 45 0c             	mov    0xc(%ebp),%eax
  10371c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103720:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103727:	8b 45 08             	mov    0x8(%ebp),%eax
  10372a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10372c:	ff 4d 10             	decl   0x10(%ebp)
  10372f:	eb 03                	jmp    103734 <vprintfmt+0x3c5>
  103731:	ff 4d 10             	decl   0x10(%ebp)
  103734:	8b 45 10             	mov    0x10(%ebp),%eax
  103737:	48                   	dec    %eax
  103738:	0f b6 00             	movzbl (%eax),%eax
  10373b:	3c 25                	cmp    $0x25,%al
  10373d:	75 f2                	jne    103731 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  10373f:	90                   	nop
    while (1) {
  103740:	e9 36 fc ff ff       	jmp    10337b <vprintfmt+0xc>
                return;
  103745:	90                   	nop
        }
    }
}
  103746:	83 c4 40             	add    $0x40,%esp
  103749:	5b                   	pop    %ebx
  10374a:	5e                   	pop    %esi
  10374b:	5d                   	pop    %ebp
  10374c:	c3                   	ret    

0010374d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10374d:	f3 0f 1e fb          	endbr32 
  103751:	55                   	push   %ebp
  103752:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103754:	8b 45 0c             	mov    0xc(%ebp),%eax
  103757:	8b 40 08             	mov    0x8(%eax),%eax
  10375a:	8d 50 01             	lea    0x1(%eax),%edx
  10375d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103760:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103763:	8b 45 0c             	mov    0xc(%ebp),%eax
  103766:	8b 10                	mov    (%eax),%edx
  103768:	8b 45 0c             	mov    0xc(%ebp),%eax
  10376b:	8b 40 04             	mov    0x4(%eax),%eax
  10376e:	39 c2                	cmp    %eax,%edx
  103770:	73 12                	jae    103784 <sprintputch+0x37>
        *b->buf ++ = ch;
  103772:	8b 45 0c             	mov    0xc(%ebp),%eax
  103775:	8b 00                	mov    (%eax),%eax
  103777:	8d 48 01             	lea    0x1(%eax),%ecx
  10377a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10377d:	89 0a                	mov    %ecx,(%edx)
  10377f:	8b 55 08             	mov    0x8(%ebp),%edx
  103782:	88 10                	mov    %dl,(%eax)
    }
}
  103784:	90                   	nop
  103785:	5d                   	pop    %ebp
  103786:	c3                   	ret    

00103787 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103787:	f3 0f 1e fb          	endbr32 
  10378b:	55                   	push   %ebp
  10378c:	89 e5                	mov    %esp,%ebp
  10378e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103791:	8d 45 14             	lea    0x14(%ebp),%eax
  103794:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10379a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10379e:	8b 45 10             	mov    0x10(%ebp),%eax
  1037a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1037a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1037af:	89 04 24             	mov    %eax,(%esp)
  1037b2:	e8 08 00 00 00       	call   1037bf <vsnprintf>
  1037b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1037ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1037bd:	c9                   	leave  
  1037be:	c3                   	ret    

001037bf <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1037bf:	f3 0f 1e fb          	endbr32 
  1037c3:	55                   	push   %ebp
  1037c4:	89 e5                	mov    %esp,%ebp
  1037c6:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1037c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1037cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1037cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1037d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1037d8:	01 d0                	add    %edx,%eax
  1037da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1037e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1037e8:	74 0a                	je     1037f4 <vsnprintf+0x35>
  1037ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1037ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037f0:	39 c2                	cmp    %eax,%edx
  1037f2:	76 07                	jbe    1037fb <vsnprintf+0x3c>
        return -E_INVAL;
  1037f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1037f9:	eb 2a                	jmp    103825 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1037fb:	8b 45 14             	mov    0x14(%ebp),%eax
  1037fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103802:	8b 45 10             	mov    0x10(%ebp),%eax
  103805:	89 44 24 08          	mov    %eax,0x8(%esp)
  103809:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10380c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103810:	c7 04 24 4d 37 10 00 	movl   $0x10374d,(%esp)
  103817:	e8 53 fb ff ff       	call   10336f <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10381c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10381f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103822:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103825:	c9                   	leave  
  103826:	c3                   	ret    
