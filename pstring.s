#206821258 Idan Simai
.section	.rodata
Error: 		.string "invalid input!\n"
.text
.global pstrlen
.type pstrlen, @function
pstrlen:
	movzbq	(%rdi), %rax        #Set the string length as the retruned value.
	ret

.global replaceChar
.type replaceChar, @function
replaceChar:
	pushq	%rdi                #Push the string address to the stack.
	call	pstrlen             #Get the string length.
	addq	$1, %rdi            #Get the string address 1 byte further.
	xor	    %r8, %r8            #Assign %r8 to 0.
	xor	    %r9, %r9            #Assign %r9 to 0.
	jmp     .replace_loop

.replace_loop:
	cmpq	%rax, %r8           #Compare %r8 (the counter) to %rax (the string length).
	je	    .replace_end        #If they are equal, jump to the end of loop.
	movb	(%rdi), %r9b        #Move the char in i'th place to %r9b.
	cmpq	%r9, %rsi           #Check if the i'th char is equal to the char we want to replace.
	je 	    .replace            #If they are, jump to replace.
	jmp     .replace_iter

.replace:
	movb	%dl, (%rdi)         #Replace the old char with new char.
	jmp	    .replace_iter       #Continue iterating in the loop.

.replace_iter:
	addq	$1, %r8             #Add 1 to the counter(%r8).
	addq	$1, %rdi            #Get the string's address 1 byte further.
	jmp	    .replace_loop       #Jump to excute the loop.

.replace_end:
	popq	%rdi                #Pop the original %rdi back to %rdi.
	movq	%rdi, %rax          #Move the original string address to %rax(the returned value.
	ret

.global pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
    pushq   %rbp                #Push %rbp to the stack for a backup.
    pushq   %rbx                #Push %rbx to the stack for a backup.
    pushq   %r12                #Push %r12 to the stack for a backup.
	pushq 	%r13                #Push %r13 to the stack for a backup.
	pushq   %r14                #Push %r14 to the stack for a backup.
	pushq   %r15                #Push %r13 to the stack for a backup.
	xor     %r13, %r13          #Assign %r13 to 0.
	leaq	(%rdi), %r14        #The destination string (1).
	leaq	(%rsi), %r15        #The source string (2).
	call 	pstrlen             #Get the destination's length.
	movq 	%rax, %rbx          #Save the destination's length in %rbp.
	movq	%rsi, %rdi          #Put the source as the argument.
	call 	pstrlen             #Get the source's length.
	movq	%rax, %rbp          #Save the source's length in %rbx.
	movq    %r14, %r12          #Put %r14 in %r12.
	cmpq 	$0, %rdx
    jl 	    .pstrijcpy_error    #Jump if i < 0.
    cmpq 	$0, %rcx
	jl   	.pstrijcpy_error    #Jump if j < 0.
	cmpq	%rcx, %rdx
	jg 	    .pstrijcpy_error    #Jump if i > j.
	cmpq 	%rbp, %rcx
	jge 	.pstrijcpy_error    #Jump if j > source's length.
	cmpq 	%rbx, %rcx
	jge 	.pstrijcpy_error    #Jump if j > destination's length.
	leaq	1(%rdx, %r14), %r14 #Add %rdx(i) + 1 to the destination string.
	leaq	1(%rdx, %r15), %r15 #Add %rdx(i) + 1 to the source string.
	jmp     .pstrijcpy_loop

.pstrijcpy_loop:
	cmpq	%rcx, %rdx
	ja  	.pstrijcpy_end      #Jump to the end of the function.
	movb	(%r15), %r13b       #Move from memory to register.
	movb	%r13b, (%r14)       #Move from register to memory.
	addq	$1, %r14            #Get the destination strings' address 1 byte further.
	addq	$1, %r15            #Get the source string's address 1 byte further.
	addq	$1, %rdx            #i++.
	jmp 	.pstrijcpy_loop

.pstrijcpy_error:
    subq    $8, %rsp            #Align %rsp so it ends with 0.
    xor     %rbp, %rbp          #Assign %rbp to 0.
	movq	%r12, %rbp          #Put the original destination in %rbp.
	movq	$Error, %rdi        #Put the format as the first argument.
	xor	    %rax, %rax          #Assign %rax to 0.
	call 	printf
	addq    $8, %rsp            #Add what we allocated back to %rsp.
	jmp     .pstrijcpy_end

.pstrijcpy_end:
    movq    %rbp, %rax          #Set %rbp as the returned value.
	popq    %r15                #Pop and put it in %r15.
	popq    %r14                #Pop and put it in %r14.
	popq    %r13                #Pop and put it in %r13.
	popq    %r12                #Pop and put it in %r12.
	popq    %rbx                #Pop and put it in %rbx.
	popq    %rbp                #Pop and put it in %rbp.
	ret

.global swapCase
.type swapCase, @function
swapCase:
	pushq	%r12
	leaq 	(%rdi), %r12        #Put the string in %r12.
	call	pstrlen
	addq	$1, %rdi            #Get the string's address 1 byte further.
	xor	    %r8, %r8            #Assign %r8 to 0.
	xor	    %r9, %r9            #Assign %r9 to 0.
	jmp     .swap_loop

.swap_loop:
	cmpq	%rax, %r8           #Compare the counter(%r8) with the string's length.
	je	    .swap_end
	movb	(%rdi), %r9b        #Move the char in the i'th place to %r9.
	cmpb	$65, %r9b  	        #Check if %r9 is lower than 'A''s ascii value.
	jl	    .swap_iter
	cmpb	$90, %r9b  	        #Check if %r9 is lower or equal to 'Z''s ascii value.
	jle	    .up_to_low
	cmpb	$97, %r9b           #Check if %r9 is lower than 'a''s ascii value.
	jl	    .swap_iter
	cmpb	$122, %r9b	        #Check if %r9 is lower or equal to 'z''s ascii value.
	jle	    .low_to_up
	jmp	    .swap_iter

.swap_iter:
	addq	$1, %r8             #Add 1 to the counter(%r8).
	addq	$1, %rdi            #Get the string's address 1 byte further.
	jmp	    .swap_loop

.up_to_low:
	addq	$32, %r9            #Add 32 to make the upper case lower.
	movb	%r9b, (%rdi)        #Put the new char in the string.
	jmp	.swap_iter

.low_to_up:
	subq	$32, %r9            #Sub 32 to make the lower case upper.
	movb	%r9b, (%rdi)       #Put the new char in the string.
	jmp	    .swap_iter

.swap_end:
	movq	%r12, %rax          #Set %r12 as the returned value.
	popq	%r12                #Pop and put it in %r12.
	ret

.global pstrijcmp
.type pstrijcmp, @function
pstrijcmp:
    pushq   %rbp
    movq    %rsp, %rbp
    cmpl    $0, %edx    # i<0
    jl      .mistake
    cmpb    (%rsi), %cl # j>src
    jge     .mistake
    cmpb    (%rdi), %cl # j>dst
    jge     .mistake
    cmpl    %edx, %ecx  # i>j
    jl      .mistake
    jmp     .ok
.mistake:   #   print mistake
    movq    $0, %rax
    movq    $error, %rdi
    call    printf
    movq    $0, %rax
    xorq    %r8, %r8
    movq    $-2, %r8
    movq    %r8, %rax
    jmp     .finish
.ok:    #   dst +=1, src+=1
    movq    $0, %rax
    leaq    1(%rdx, %rdi), %rdi
    leaq    1(%rdx, %rsi), %rsi
.pstrijcmp_loop:
    movq    (%rdi), %r11    # r11==dst
    cmpb    %r11b, (%rsi)   # compear
    jl      .bigger         # case big
    cmpb    %r11b, (%rsi)   # compear
    jg      .smaller        # case small
    jmp     .equal
.bigger:   # put 1 in return
    movq    $1, %rax
    jmp     .finish
.smaller:   #   put -1 in retun
    movq    $-1, %rax
    jmp     .finish
.equal:     #   while i<j loop
    incq    %rdi
    incq    %rsi
    incq    %rdx
    cmpl    %edx, %ecx
    jge     .pstrijcmp_loop
.finish:    # omg doneeeeee
    movq    %rbp, %rsp
    popq    %rbp
    ret