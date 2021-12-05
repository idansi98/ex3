#206821258 Idan Simai
Int:	.string "%d"
String:	.string "%s"

.text
.global run_main
.extern run_func
.type run_main, @function
run_main:
	pushq	%rbp		        #Push %rbp to the stack so we can know what's the original %rbp.
	movq	%rsp, %rbp	        #Move %rsp to %rbp so we can start the frame.
	pushq   %r13                #Push %r13 to the stack for a backup.
	pushq   %r14                #Push %r14 to the stack for a backup.
	pushq   %r15                #Push %r15 to the stack for a backup.
	subq	$264, %rsp          #Align %rsp so it ends with 0 and allocate memory in the stack.
   	movq	$Int, %rdi	        #Put the format as the first argument.
   	movq	%rsp, %rsi 	        #Put %rsp as the second argument.
   	xor	    %rax, %rax	        #Assign %rax to 0.
   	call 	scanf
   	leaq    (%rsp), %r14        #Put %rsp in %r14.
    addq	$1, %r14	        #Add 1 to the register so we can put the string in the stack.
   	movq	$String, %rdi	    #Put the format as the first argument.
   	movq	%r14, %rsi          #Put %r14 as the second argument.
   	xor	    %rax, %rax	        #Assign %rax to 0.
    call    scanf
    subq    $1, %r14            #Subtract 1 from %r14 so we can get back to the end of the stack.
    movq    %r14, %rsp          #Move %r14 to %rsp so we will be able to continue with it as a stack pointer.
    subq	$272, %rsp          #Align %rsp so it ends with 0 and allocate memory in the stack.
    movq	$Int, %rdi	        #Put the format as the first argument.
    movq	%rsp, %rsi 	        #Put %rsp as the second argument.
    xor	    %rax, %rax	        #Assign %rax to 0.
    call 	scanf
    leaq    (%rsp), %r15        #Put %rsp in %r15.
    addq	$1, %r15            #Add 1 to the register so we can put the string in the stack.
    movq	$String, %rdi       #Put the format as the first argument.
    movq	%r15, %rsi          #Put %r15 as the second argument.
    xor	    %rax, %rax          #Assign %rax to 0.
    call    scanf
    subq    $1, %r15            #Subtract 1 from %r15 so we can get back to the end of the stack.
    movq    %r15, %rsp          #Return %rsp to the top of the stack.
    subq    $8, %rsp            #Subtract 8 from %rsp.
    subq    $8, %rsp            #Subtract 8 from %rsp.
    leaq    (%rsp), %r13        #Move %rsp to %r13.
    movq    $Int, %rdi          #Put the format as the first argument.
    movq    %r13, %rsi          #Put %r13 as the second argument.
    xor	    %rax, %rax          #Assign %rax to 0.
    call    scanf
    xor     %rdi, %rdi          #Assign %rdi to 0.
    movb    (%r13), %dil        #Put the value stored in the memory address r13 points to as the first argument.
    movq    %r14, %rsi          #Put %r14(first string) as the second argument.
    movq    %r15, %rdx          #Put %r15(second string) as the third argument.
    call    run_func
    xor     %rax, %rax          #Assign %rax to 0.
    popq    %r15                #Pop and put it in %r15.
    popq    %r14                #Pop and put it in %r14.
    popq    %r13                #Pop and put it in %r13.
    add     $552, %rsp          #Add what we allocated back to %rsp.
    movq    %rbp, %rsp          #Move %rsp back to %rbp.
    popq    %rbp                #Pop and put it in %rbp.
    ret

