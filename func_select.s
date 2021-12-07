#206821258 Idan Simai
.data
.section  .rodata
Case5060_first_str:  .string "first pstring length: %d, "
Case5060_second_str: .string "second pstring length: %d\n"
Case52_old_char:     .string "old char: %c, "
Case52_new_char:     .string "new char: %c, "
Case52_first_str:    .string "first string: %s, "
Case52_second_str:   .string "second string: %s\n"
Case5354_len:        .string "length: %d, "
Case5354_str:        .string "string: %s\n"
Case55:              .string "compare result: %d\n"
Invalid:	         .string "invalid option!\n"
Char:       	     .string " %c"
Int:		         .string "%d"
.align 8 # Align the address to multiple of 8.
.cases:
	.quad	.case5060           #The 50/60 case.
	.quad	.invalid            #Invalid case.
	.quad	.case52             #The 52 case.
	.quad	.case53             #The 53 case.
	.quad	.case54             #The 54 case.
	.quad	.case55             #The 55 case.
.text
.global run_func
.extern pstrlen, replaceChar, pstrijcpy, swapCase, pstrijcmp
.type run_func, @function
run_func:
    subq    $50, %rdi           #Detecting the last number (0,2,3,4,5).
   	cmpq	$10, %rdi           #Check if it is the 50/60 case.
   	je      .case5060           #Jump to the 5060 case.
    cmpq	$5, %rdi		    #Check if the difference is more than 5.
    ja	    .invalid	        #Jump to the invalid case.
    cmpq	$0, %rdi		    #Check if the difference  is less than 0.
    jb	    .invalid            #Jump to the invalid case.
    jmp	*   .cases(,%rdi,8)	    #Go to the jumptable.

.invalid:
 	movq	$Invalid, %rdi      #Put the format as the first argument.
 	xor	    %rax, %rax          #Assign %rax to 0.
 	subq    $8, %rsp            #Align %rsp so it ends with 0.
 	call 	printf
 	addq    $8, %rsp            #Add back what we allocated.
 	ret

.case5060:
	pushq	%r12                #Push %r12 to the stack.
	pushq	%r13                #Push %r13 to the stack.
	subq    $8, %rsp            #Subtract 8 from %rsp.
	leaq	(%rsi), %rdi	    #Put the first string as the first argument.
	call	pstrlen
	xor     %rsi, %rsi          #Assign %rsi to 0.
	movq	%rax, %rsi	        #Put the string's length as the second argument.
	movq    $Case5060_first_str, %rdi         #Put String format as the first argument.
	leaq	(%rdx), %r13	    #Put the second string in %r13.
	xor	    %rax, %rax          #Assign %rax to 0.
	call    printf
    movq    %r13, %rdi          #Put the second string as the first argument.
	call	pstrlen
	movq	%rax, %r12	        #Move the retruned value from psrtlen(%rax) to %r13.
	movq	$Case5060_second_str, %rdi        #Put the String format as the first argument.
	xor     %rsi, %rsi
	leaq	(%r12), %rsi        #Put the string's length as the second argument.
	xor	    %rax, %rax          #Assign %rax to 0.
	call	printf
	addq    $8, %rsp            #Return %rsp to his previous value.
	popq	%r13                #Pop and put it in %r13.
	popq	%r12                #Pop and put it in %r12.
	ret

.case52:
	pushq	%r15                #Push %r15 to the stack for a backup.
	pushq	%r14                #Push %r14 to the stack for a backup.
	pushq	%r13                #Push %r13 to the stack for a backup.
	pushq	%r12                #Push %r12 to the stack for a backup.
	pushq   %rbp                #Push %rbp to the stack for a backup.
	pushq   %rbx                #Push %rbx to the stack for a backup.
	leaq	(%rsi), %r12        #Put the first string in %r12.
	leaq	(%rdx), %r13        #Put the first string in %r13.
	subq	$8, %rsp	        #Add 8 bytes in the stack.
	movq	$Char, %rdi         #Put the format as the first argument.
	movq	%rsp, %rsi          #Put %rsp as the second as the secnd argument.
	xor	    %rax, %rax	        #Assign %rax to 0.
	call	scanf
	movzbq 	(%rsp), %r14        #Put the old char in %r14.
	movq	$Char, %rdi	        #Put the format as the first argument.
	movq	%rsp, %rsi          #Put %rsp as the second argument.
	xor	    %rax, %rax  	    #Assign %rax to 0.
	call	scanf
	movzbq 	(%rsp), %r15        #Put the new char in %r15.
	movq	%r12, %rdi          #Put the first string as the first argument.
	xor     %rsi, %rsi
	xor     %rdx, %rdx
	movq	%r14, %rsi          #Put the old char as the second argument.
	movq 	%r15, %rdx          #Put the new char as the third argument.
	call 	replaceChar
	movq 	%rax, %rbx          #Put the new first string in %rbx.
	movq 	%r13, %rdi          #Put the second string as the first argument.
	call 	replaceChar
	movq 	%rax, %rbp          #Put the new second string in %r9.
	movq 	$Case52_old_char, %rdi   #Put the old char format as the first argument.
	xor     %rsi, %rsi
	movq	%r14, %rsi          #Put the old char as the second argument.
	xor     %rax, %rax          #Assign %rax to 0.
	call    printf
	movq    $Case52_new_char, %rdi   #Put the new char format as the first argument.
	xor     %rsi, %rsi
	movq	%r15, %rsi          #Put the new char as the second argument.
	xor     %rax, %rax          #Assign %rax to 0.
	call    printf
	movq 	$Case52_first_str, %rdi  #Put the first string format as the first argument.
	leaq    1(%rbx), %rsi       #Put the new first string as the second argument.
	xor 	%rax, %rax          #Assign %rax to 0.
	call 	printf
	movq 	$Case52_second_str, %rdi #Put the second string format as the first argument.
    leaq    1(%rbp), %rsi       #Put the new second string as the second argument.
   	xor 	%rax, %rax          #Assign %rax to 0.
   	call 	printf
   	addq    $8, %rsp            #Return %rsp to his previous place.
   	popq    %rbx                #Pop and put it in %rbx.
   	popq    %rbp                #Pop and put it in %rbp.
	popq	%r12                #Pop and put it in %r12.
	popq	%r13                #Pop and put it in %r13.
	popq	%r14                #Pop and put it in %r14.
	popq	%r15                #Pop and put it in %r15.
	ret

.case53:
    pushq   %r15                #Push %r15 to the stack for a backup.
    pushq   %r14                #Push %r14 to the stack for a backup.
    pushq   %r13                #Push %r13 to the stack for a backup.
    pushq   %r12                #Push %r12 to the stack for a backup.
    xor     %r12, %r12          #Assign %r12 to 0.
    xor     %r13, %r13          #Assign %r13 to 0.
    xor     %r14, %r14          #Assign %r14 to 0.
    xor     %r15, %r15          #Assign %r15 to 0.
    subq    $8, %rsp            #Subtract 8 from %rsp.
    leaq    (%rsi), %r12        #Put the first string in %r12.
    leaq    (%rdx), %r13        #Put the second string in %r13.
    xor     %rsi, %rsi
    movq    %rsp, %rsi          #Put %rsp as the second argument.
    movq    $Int, %rdi          #Put the format as the first argument.
    xor     %rax, %rax          #Assign %rax to 0.
    call    scanf
    movb    (%rsp), %r14b       #Put the value stored in the memory address %rsp points to in %r14.
    movq    $Int, %rdi          #Put the format as the first argument.
    movq    %rsp, %rsi          #Put %rsp as the second argument.
    xor     %rax, %rax          #Assign %rax to 0.
    call    scanf
    movb    (%rsp), %r15b       #Put the value stored in the memory address %rsp points to in %r15.
    movq    %r12, %rdi          #Put %r12 as the first argument.
    movq    %r13, %rsi          #Put %r13 as the second argument.
    xor     %rdx, %rdx
    xor     %rcx, %rcx
    movq    %r14, %rdx          #Put %r14 as the third argument.
    movq    %r15, %rcx          #Put %r15 as the fourth argument.
    call 	pstrijcpy
    leaq    (%rax), %r12        #Put %rax in %r12
    leaq    (%rax), %rdi        #Put %rax as the first argument.
    call    pstrlen
    xor     %rsi, %rsi
    movq    %rax, %rsi          #Put %rax as the second argument.
    movq    $Case5354_len, %rdi #Put the format as the first argument.
    xor     %rax, %rax          #Assign %rax to 0.
    call    printf
    movq    $Case5354_str, %rdi #Put the format as the first argument.
    leaq    1(%r12), %rsi       #Put the new pstring as the second argument.
    xor     %rax, %rax          #Assign %rax to 0.
    call    printf
    leaq    (%r13), %rdi        #Put %r13(the original second string) as the first argument.
    call    pstrlen
    xor     %rsi, %rsi
    movq    %rax, %rsi          #Put the original second string's length as the second argument.
    xor     %rax, %rax          #Assign %rax to 0.
    movq    $Case5354_len, %rdi #Put the format as the first argument.
    call    printf
    leaq    1(%r13), %rsi       #Put the second string as the second argument.
    movq    $Case5354_str, %rdi #Put the format as the first argument.
    xor     %rax, %rax          #Assign %rax to 0.
    call    printf
    addq    $8, %rsp            #Add what we allocated back to %rsp.
    popq    %r12                #Pop and put it in %r12.
    popq    %r13                #Pop and put it in %r13.
    popq    %r14                #Pop and put it in %r14.
    popq    %r15                #Pop and put it in %r15.
    ret

.case54:
    pushq	%r12                #Push %r12 to the stack for a backup.
	pushq	%r13                #Push %r13 to the stack for a backup.
	pushq   %r14                #Push %r14 to the stack for a backup.
	pushq   %r15                #Push %r15 to the stack for a backup.
	xor     %r12, %r12          #Assign %r12 to 0.
	xor     %r13, %r13          #Assign %r13 to 0.
	xor     %r14, %r14          #Assign %r14 to 0.
	xor     %r15, %r15          #Assign %r15 to 0.
	subq    $8, %rsp            #Align %rsp so it ends with 0 and allocate memory in the stack.
	leaq	(%rsi), %r12        #Put the first string in %r12.
	leaq	(%rdx), %r13        #Put the second string in %r13.
	leaq 	(%r12), %rdi 	    #Put the first string(%r12) as the first argument.
	call 	swapCase
	movq 	%rax, %r12          #Put the swapped first string in %r12.
	movq 	%rax, %rdi          #Put the swapped first string as the first argument.
	call 	pstrlen
	movq 	%rax, %r14          #Put the first string's length in %r14.
	leaq    (%r13), %rdi        #Put the second string as the first argument.
	call 	swapCase
	leaq    (%rax), %r13        #Put the swaaped second string in %r13.
	movq 	%rax, %rdi          #Put the swapped second string as the first argument.
	call 	pstrlen
	movq 	%rax, %r15          #Put the second string's length in %r15.
	movq 	$Case5354_len, %rdi	#Put the format as the first argument.
	xor     %rsi, %rsi
	movq    %r14, %rsi          #Put the first string's length as the second argument.
	xor 	%rax, %rax          #Assign %rax to 0.
	call 	printf
	movq    $Case5354_str, %rdi #Put the format as the first argument.
	leaq    1(%r12), %rsi       #Put the first swapped string as the second argument.
	xor 	%rax, %rax          #Assign %rax to 0.
	call    printf
	movq 	$Case5354_len, %rdi	#Put the format as the first argument.
	xor     %rsi, %rsi
    movq    %r15, %rsi          #Put the second string's length as the second argument.
    xor 	%rax, %rax          #Assign %rax to 0.
    call    printf
    movq    $Case5354_str, %rdi #Put the format as the first argument.
    leaq    1(%r13), %rsi       #Put the second swapped string as the second argument.
	xor 	%rax, %rax          #Assign %rax to 0.
	call    printf
	addq    $8, %rsp            #Add what we allocated back to %rsp.
	popq	%r15                #Pop and put it in %r15.
	popq	%r14                #Pop and put it in %r14.
	popq    %r13                #Pop and put it in %r13.
	popq    %r12                #Pop and put it in %r12.
	ret

.case55:
    pushq   %r12                #Push %r12 to the stack for a backup.
    pushq   %r13                #Push %r13 to the stack for a backup.
    pushq   %r14                #Push %r14 to the stack for a backup.
    subq    $16, %rsp           #Allocate memory for the two ints.
    xor     %r12, %r12          #Assign %r12 to 0.
    xor     %r13, %r13          #Assign %r13 to 0.
    xor     %r14, %r14          #Assign %r14 to 0.
    leaq    (%rsi), %r13        #Put the first string in %r13.
    leaq    (%rdx), %r14        #Put the second string in %r14.
    movq    $Int, %rdi          #Put the format as the first argument.
    movq    %rsp, %r12          #Put %rsp in %r12
    movq    %r12, %rsi          #Put %r12 as the second argument.
    xor     %rax, %rax          #Assign %rax to 0.
    call    scanf
    movq    $Int, %rdi          #Put the format as the first argument.
    leaq    8(%r12), %rsi       #Move %r12 value 8 bytes further and put in %rsi.
    xor     %rax, %rax          #Assign %rax to 0.
    call    scanf
    xor     %rdx, %rdx          #Assign %rdx to 0.
    xor     %rcx, %rcx          #Assign %rcx to 0.
    movb    (%r12), %dl         #Put the first index(%r12) as the third argument.
    leaq    8(%r12), %r12       #Add 8 bytes to %r12
    movb    (%r12), %cl         #Put the second index(%r12 + 8) as the fourth argument.
    leaq    (%r13), %rdi        #Put the first string (%r13) as the first argument.
    leaq    (%r14), %rsi        #Put the second string (%r14) as the second argument.
    call    pstrijcmp
    movq    $Case55, %rdi       #Put the format as the first argument.
    xor     %rsi, %rsi
    movq    %rax, %rsi          #Put the comparison result as the second argument.
    xor     %rax, %rax          #Assign %rax to 0.
    call    printf
    addq    $16, %rsp           #Add what we allocated back to %rsp.
    popq    %r14                #Pop and put it in %r14.
    popq    %r13                #Pop and put it in %r13.
    popq    %r12                #Pop and put it in %r12.
    ret