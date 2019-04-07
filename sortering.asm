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
loopcount:	.word 0	# Compares to "datalen" to loop correct amount of times

.text

main:
	lw	$t1, datalen	# Size of data. Needed for counting iterations 
	#jal	sortarray	# Start sorting
	nop	
	j	printresult	# Print the sorted array
####################################################################################################

# 1. Kolla om i >= n --> Hoppa ut loopen
# 2. Spara värdet som pekaren pekar på (index 0)
# 3. Sänk pointern ett steg och Jämför med sparade värdet
# 4. Om mindre, flytta nedre värdet uppåt
# 5. Jämför sparade värdet igen med pointer --?
#
# En till pointer?
# https://www.youtube.com/watch?v=i-SKeOcBwko
# SRL ? Spara ner värden till höger i ett nytt register först, sedan skifta dessa höger. 

sortarray:
	# Sorting algoritm starts
	move	$s0, $zero	# i = 0
	la	$t0, array	# Create pointer to array in $t0
	
	## kalla på detta senare?
	move	$s1, $s0 	# j = i
	
sortfor1:
	slt	$t2, $s0, $t1		# reg $t0 = 0 if $s0 >= $a1 (i >= n)
	beq	$t2, $zero, exit1	# go to exit1 if $s0 >= $a1 (i >= n)
	
	## BODY
	lw	$t3, 0($t0)	# Load value that $t0 points to in $t3
sortfor2:
	addi	$t0, $t0, -4	# Decrease pointer by 4 to point to previous word in array
	slt	$t4, $t3, $t0	# Compare value at index i with index j (i-1). If this returns 1, sort values
	beqz	$t4, sortfor2	# Decrease pointer and compare again
	
	# flytta ett steg upp 
	
	### END LOOP 2	
	addi	$t0, $t0, 4		# Increase pointer by 4 to point to next word in array
	addi	$s0, $s0, 1		# i++
	j	sortfor1		# run loop again
exit1:
	jr	$ra			# jump back to main
	nop
####################################################################################################
printresult:
	# Subroutine to print content of array1
	la	$t0, array	# Create pointer to array in $t0
	move	$s0, $zero	# i = 0
printfor:
	#### RESET POINTER???
	slt	$t2, $s0, $t1		# reg $t2 = 0 if $s0 >= $a1 (i >= datalen)
	beq	$t2, $zero, exitprogram	# exit if $s0 >= $a1 (i >= datalen)
	
	## BODY
	
	lw	$a0, 0($t0)	# Load value that $t0 points to in $a0
	nop
	
	li	$v0, 1		# Print int loaded in $a0 and print a new line
	syscall	
	la	$a0, newline
	li	$v0, 4		
	syscall	
	
	addi	$t0, $t0, 4	#Increase pointer by 4 to point to next word in array
	
	## BODY
	
	addi	$s0, $s0, 1		# i++
	j	printfor		# run loop again

exitprogram:	
	li	$v0, 10		# Exit program cleanly
	syscall