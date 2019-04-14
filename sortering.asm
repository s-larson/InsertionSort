## ** Insertion Sort made by Simon Larson**
##
## Insertion Sort will divide the inserted array into two parts,
## the left part is sorted, right is unsorted. Iterations will be based on the
## "invisible" line between sorted/unsorted values. 
## The program will check the next value to the right of the sorted stack and compare to right-most sorted value
## if the new value is smaller, the array if shifted one step to the right until the value is fitted into the sorted part of the array
## The loop then repeats until array is sorted in ascending order
## 
## To use this algoritm, insert your data at "data:" and the number of values at "datalen" 

.data
datalen:	.word	0x0010	# 16

data:
		.word	0xffff7e81
		.word	0x00000001
		.word	0x00000002
		.word	0xffff0001
		.word	0x00000000
		.word	0x00000001
		.word	0xffffffff
		.word	0x00000000
		.word	0xe3456687
		.word	0xa001aa88
		.word	0xf0e159ea
		.word	0x9152137b
		.word	0xaab385a1
		.word	0x31093c54
		.word	0x42102f37
		.word	0x00ee655b
	
newline:	.asciiz	"\n"
sortlabel1:	.asciiz "......Sorting.......\n"
sortlabel2:	.asciiz "Sorting successful!\n"
printlabel:	.asciiz "\n......Printing.......\n"

.text

main:
	la	$a0, sortlabel1
	li	$v0, 4
	syscall
	
	jal	initiate	# Start sorting
	nop
	la	$a0, sortlabel2
	li	$v0, 4
	syscall
	la	$a0, printlabel
	li	$v0, 4
	syscall	
	j	printresult	# Print the sorted array
	nop
initiate:
	la	$s0, data	# Pointer to array
	lw	$s3, datalen	# Size of data
	li	$s1, 0		# i = 0

sortarray: # Save "left-most"  unsorted value (at position "i") and set j to i-1 (previous value in array)
	bge	$s1, $s3, exit		# run loop while i < n
	nop
	sll	$t0, $s1, 2		# $t2 = i * 4
	add	$t0, $t0, $s0
	lw	$t0, 0($t0)		# $t0 = array[i]
	addi	$s2, $s1, -1		# j = i - 1 
innerloop: # Find a value greater than array[i], otherwise increase i and run this comparison again
	blt	$s2, $zero, increment	# i++ if j < 0
	nop
	sll	$t3, $s2, 2		# $t3 = j * 4
	add	$t3, $t3, $s0		# $t3 = address of array[j]
	lw	$t1, 0($t3)		# $t0 = array[j]
	
	bgt	$t1, $t0, sortvalues	# if array[j] > array [i], start sorting
	nop
	
	addi	$s2, $s2, -1		# j--
	j	innerloop
	nop
increment:
	addi	$s1, $s1, 1		# i++
	j	sortarray
	nop
sortvalues: # Save the unsorted value to $t7, shift values until $t7 is in the "right spot", then insert
	move	$t7, $t0		# save array[i]
shiftarray:
	sw	$t1, 4($t3)		# move array[j] to array[i] (one step to the right)
	addi	$s2, $s2, -1		# j--
	bltz	$s2, insertinback	# if no bigger value is found, insert "temp" at start of array
	nop
	sll	$t3, $s2, 2		# $t3 = j * 4
	add	$t3, $t3, $s0		# $t3 = address of array[j]
	lw	$t1, 0($t3)		# $t1 = array[j]
	bge	$t7, $t1, insert	# insert "temp" value at $t7 into right spot in array
	j	shiftarray
	nop
	
insert:
	sw	$t7, 4($t3)
	j	increment		# i++ and next value is compared
	nop
insertinback:
	sw	$t7, 0($t3)
	j	increment		# i++ and next value is compared
	nop
exit:	
	jr	$ra			# go back to main and start printing
	nop

printresult: # Subroutine to print content of array
	move	$s1, $zero	# i = 0
printfor:
	slt	$t0, $s1, $s3		# set $t0 = 0 if i > datalen
	beq	$t0, $zero, exitprogram	# exit if i > datalen
	
	sll	$t1, $s1, 2		# $t1 = i * 4
	add	$t1, $t1, $s0		# 
	lw	$a0, 0($t1)		# $a0 = array[i]
	nop
	li	$v0, 1			# Print int loaded in $a0 and print a new line
	syscall	
	la	$a0, newline
	li	$v0, 4		
	syscall	
	addi	$s1, $s1, 1		# i++
	j	printfor		# run loop again
	nop
exitprogram:	
	li	$v0, 10		# Exit program cleanly
	syscall
