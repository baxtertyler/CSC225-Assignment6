# Tyler Baxter and Jack Herberger

.globl swap 
.globl selectionSort
.globl printArray
 
# a0 = start of the stack
# a1 = i
# a2 = n
# t0 = i
# t1 = min

#void selectionSort(int arr[], int i, int n){
selectionSort:
	add	t1, t1, a0
	mv	s8, ra

createStack: 
	lw	t0, 0(t1)
	beq	t0, zero, stackReady
	
	addi	sp, sp, -16
	
	sw	t0, 0(sp)
	lw	t0, 4(t1)
	sw	t0, 4(sp)
	
	lw	t0, 8(t1)
	sw	t0, 8(sp)
	
	lw	t0, 12(t1)
	sw	t0, 12(sp)
	
	addi	t1, t1, 16
	
	#addi	t1, t1, 16
	b	createStack
	
stackReady:
	sw	ra, -4(a0)
	
	
selectionSort_:

# int j;
	li	t0, 0			# j(t0) = 0

# int min = i;
	mv	t1, a1			# min(t1) = i(al)


# for (j = i + 1; j < n; j++)    {
	addi	t0, a1, 1		# j(t0) = i(a1) + 1
for:
# j = i + 1;
	
	
	slli	t3, t0, 4		# t3 = j(t0) * 16
	add	t3, t3, a0		# t3 = (j * 16) + start of stack(a0)
	addi	t3, t3, 8		# t3 = (j * 16) + start of stack(a0) + 8
	lw	t5, 0(t3)		# t5 = stack location of t3 = arr[j].id
	
	slli	t3, t1, 4		# t3 = i(a1) * 16
	add	t3, t3, a0		# t4 = (i * 16) + start of stack(a0)
	addi	t3, t3, 8		# t4 = (i * 16) + start of stack(a0) + 8
	lw	t6, 0(t3)		# t6 = stack location of t3 = arr[min].id
	

forloop:
# j < n
	bge	t0, a2, endfor		# branch to endfor if j >= n

if1:
	
	blt	t6, t5, endif1		# branch to endif1 if arr[min].id < arr[j].id
	
# min = j;
	mv	t1, t0			# min(t1) = j(t0)

endif1:
	addi	t0, t0, 1		# increase j by 1
	b	for			# go back to the top of the for loop


endfor:
 

# swap(arr, min, i);

	mv	a3, a2			# temp hold n in a3 for method call
	mv	a4, a1			# temp hold i in a4 for method call
	mv	a2, a1			# move i to third parameter
	mv	a1, t1			# move min to second parameter
	
	jal	swap			# jump to swap val at min and i

 	mv	a1, a4			# move i back into second parameter
 	mv	a2, a3			# move n back into third parameter
 	
# if (i + 1 < n) {
if2:
	addi	a1, a1, 1		# increase i by 1
	beq	a2, a1, endif2		# if n > i(-> i + 1) end sort
	jal	selectionSort_		# recursive call(arr, i+1, n)

# selectionSort(arr, i + 1, n);

endif2:
	#jal	printArray
	#lw	ra, -4(a0)
	mv	ra, s8
	ret



printArray:
#callee setup goes here
	mv	a6, a0
	mv	a5, a0

#    int i;
	li	t0, 0

#    for (i = 0; i < n; i++) {
for2:
	beq	t0, a1, endfor2


forloop2:

#use ecalls to implement printf
#        printf("%d ", arr[i].studentid);
	lw	a0, 8(a6)
	li	a7, 1
	ecall
	
		la	a0, space
		li	a7, 4
		ecall

#        printf("%s ", arr[i].name);

	li	a4, 5
printName:
	beqz	a4, moveOn
	lb 	a0, 0(a6)
	li	a7, 11
	ecall
	addi	a6, a6, 1
	addi	a4, a4, -1
	b printName
	
moveOn:
	addi	a6, a6, -5
		la	a0, space
		li	a7, 4
		ecall

#        printf("%d\n", arr[i].coursenum);
	lw	a0, 12(a6)
	li	a7, 1
	ecall

	addi	t0, t0, 1
	addi	a6, a6, 16
	
		la	a0, newLine
		li	a7, 4
		ecall
	
	b	for2
#    }
endfor2:
	lw	a0, -4(a5)
	ret
#caller teardown goes here

#}






#void swap(int arr[], int i, int j) {
swap:

	li	t0, 0
	li	t1, 7

swapNameStart:
			# swap Name
#    int temp = arr[i];
	slli	t3, a1, 4		# t3 = i * 16
	add	t3, t3, a0		# t3 = (start of stack) + (i * 16)
	add	t3, t3, t0
	lb	t6, 0(t3)		# t6(temp) = arr[i]
#    arr[i] = arr[j];
	slli	t4, a2, 4		# t4 = j(min) * 16
	add	t4, t4, a0		# t4 = (start of stack) + (j(min) * 16)	
	add	t4, t4, t0
	lb	t5, 0(t4)		# t5 = arr[j(min)]
	sb	t5, 0(t3)		# location of arr[i] = arr[j]
#    arr[j] = temp;
	sb	t6, 0(t4)		# move value in temp(t4) into arr[j]
	
	addi	t0, t0, 1
	bne	t0, t1, swapNameStart

	
			# swap ID
#    int temp = arr[i];
	slli	t3, a1, 4		# t3 = i * 16
	add	t3, t3, a0		# t3 = (start of stack) + (i * 16)
	addi	t3, t3, 8		# t3 = (start of stack) + (i * 16) + 8
	lb	t6, 0(t3)		# t6(temp) = arr[i]
#    arr[i] = arr[j];
	slli	t4, a2, 4		# t4 = j(min) * 16
	add	t4, t4, a0		# t4 = (start of stack) + (j(min) * 16)	
	addi	t4, t4, 8		# t4 = (start of stack) + (j(min) * 16)	+ 8
	lw	t5, 0(t4)		# t5 = arr[j(min)]
	sw	t5, 0(t3)		# location of arr[i] = arr[j]
#    arr[j] = temp;
	sw	t6, 0(t4)		# move value in temp(t4) into arr[j]
	
			# swap Year
#    int temp = arr[i];
	slli	t3, a1, 4		# t3 = i * 16
	add	t3, t3, a0		# t3 = (start of stack) + (i * 16)
	addi	t3, t3, 12		# t3 = (start of stack) + (i * 16) + 12
	lw	t6, 0(t3)		# t6(temp) = arr[i]
#    arr[i] = arr[j];
	slli	t4, a2, 4		# t4 = j(min) * 16
	add	t4, t4, a0		# t4 = (start of stack) + (j(min) * 16)	
	addi	t4, t4, 12		# t4 = (start of stack) + (j(min) * 16)	+ 12
	lw	t5, 0(t4)		# t5 = arr[j(min)]
	sw	t5, 0(t3)		# location of arr[i] = arr[j]
#    arr[j] = temp;
	sw	t6, 0(t4)		# move value in temp(t4) into arr[j]
	
	ret				# return back to where swap was caled
	
.data

space:		.string	" "
newLine:	.string "\n"
	