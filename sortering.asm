.data

array:
	.word 42
	.word -3
	.word 110
	.word 1024
	.word -77
	.word 9
	.word 501
	
newline:	.asciiz	"\n"
datalen:	.word 7

.text

main:
	lw	$t7, datalen	# Size of data. Needed for counting iterations 
	jal	sortarray	# Start sorting
	nop	
	j	printresult	# Print the sorted array
####################################################################################################

# En till pointer?
# https://www.youtube.com/watch?v=i-SKeOcBwko
# SRL ? Spara ner värden till höger i ett nytt register först, sedan skifta dessa höger. 

sortarray:
	# Sorting algoritm starts
	la	$t0, array		# Pointer X
	la	$t1, array		# Pointer Y
	
	la	$t2, 0			# i = 0
	addi	$t0, $t0, 4		# Set pointer X to index 1
	
sortloop1:
	slt	$t6, $t1, $t7		# reg $t6 = 0 if i >= n)
	beq	$t6, $zero, exit1	# go to exit1 if i >= n)

	lw	$t4, 0($t0)		# X = array[i]
	addi	$t3, $t2, -1		# j = i - 1 
	jal	sortloop2
	nop
	
	add	$t0, $t3, $zero		# array[i] = X 
	addi	$t2, $t1, 1		# i++
	addi	$t0, $t0, 4		# Pointer 1++
	
sortloop2:
	ble	$t3, $zero, sortloop1	# while j >= 0
	bge	$t1, $t3, sortloop1	# && while array[j] >= X
	lw	$t0, 0($t1)		# array[i] = array[j] 
	addi	$t1, $t1, 1		# j++
	addi	$t1, $t0, -4		# Pointer Y--
	j	sortloop2
	nop
exit1:
	jr	$ra			# jump back to previous register
	nop
####################################################################################################
printresult:
	# Subroutine to print content of array1
	la	$t0, array	# Create pointer to array in $t0
	move	$s0, $zero	# i = 0
printfor:
	#### RESET POINTER???
	slt	$t2, $s0, $t7		# reg $t2 = 0 if $s0 >= $a1 (i >= datalen)
	beq	$t2, $zero, exitprogram	# exit if $s0 >= $a1 (i >= datalen)
	lw	$a0, 0($t0)	# Load value that $t0 points to in $a0
	nop
	
	li	$v0, 1		# Print int loaded in $a0 and print a new line
	syscall	
	la	$a0, newline
	li	$v0, 4		
	syscall	
	addi	$t0, $t0, 4	#Increase pointer by 4 to point to next word in array
		
	addi	$s0, $s0, 1		# i++
	j	printfor		# run loop again
	nop
exitprogram:	
	li	$v0, 10		# Exit program cleanly
	syscall
