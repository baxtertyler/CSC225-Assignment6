.globl swap 
.globl selectionSort
 
# a0 = start of the stack
# a1 = i
# a2 = n
# t0 = i
# t1 = min

#void selectionSort(int arr[], int i, int n){
selectionSort:
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
	
	
	slli	t3, t0, 2		# t3 = j(t0) * 4
	add	t3, t3, a0		# t3 = (j * 4) + start of stack(a0)
	lw	t5, 0(t3)		# t5 = stack location of t3 = arr[j]
	
	slli	t3, t1, 2		# t3 = i(a1) * 4
	add	t3, t3, a0		# t4 = (i * 4) + start of stack(a0)
	lw	t6, 0(t3)		# t6 = stack location of t3 = arr[min]
	

forloop:
# j < n
	bge	t0, a2, endfor		# branch to endfor if j >= n

if1:
	
	blt	t6, t5, endif1		# branch to endif1 if arr[min] < arr[j]
	
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
	lw	ra, -4(a0)
	ret

#void swap(int arr[], int i, int j) {
swap: 

#    int temp = arr[i];

	slli	t3, a1, 2		# t3 = i * 4
	add	t3, t3, a0		# t3 = (start of stack) + (i * 4)

	lb	t6, 0(t3)		# t6(temp) = arr[i]

#    arr[i] = arr[j];

	slli	t4, a2, 2		# t4 = j(min) * 4
	add	t4, t4, a0		# t2 = (start of stack) + (j(min) * 4)
		
	lw	t5, 0(t4)		# t5 = arr[j(min)]
		
	sw	t5, 0(t3)		# location of arr[i] = arr[j]

#    arr[j] = temp;

	sw	t6, 0(t4)		# move value in temp(t4) into arr[j]
	ret				# return back to where swap was caled
	
