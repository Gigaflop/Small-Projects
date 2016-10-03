#Austin McKay
#CSE 2304 Section 1
#Lab 3, Problem 3
#Given a string, determine whether or not it is a palindrome using a stack.

.data
	emptytest:			.asciiz "\nis empty? "
	popping:			.asciiz "\npopped: "
	adding:				.asciiz "\nadding: "
	
	inputmsg:			.asciiz "\nPlease enter a string, up to 80 chars: "
	strlength:			.asciiz "\nString is this many characters long: "
	newline:			.asciiz "\n"
	ispalindrome:		.asciiz "\nIs this a palindrome?\n1 = yes, 0 = no: "
	
	pushing:			.asciiz "\n pushing a value"
	comma:				.asciiz ","
	comparing:			.asciiz "\nComparing: "
	
	stringmem:			.space 80			#80 bytes = 640 bits = 8 bits per character * 80 characters
.text

main:
	#do stuff
	#will automatically go into ISPAL
	
	jal ISPAL
	move $t1, $v0				#result in t1
	li $v0, 4
	la $a0, ispalindrome
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
	j exit
	
ISPAL:
	move $s3, $ra
	add $s0 $sp $zero			#s0 stores the value of the empty sp, this is needed
	la $s1, stringmem			#reserve $s1 for the string
	
	#read a string from the console
	li $v0, 4
	la $a0, inputmsg
	syscall
	
	li $v0, 8
	la $a0, stringmem			#store string in stringmem
	li $a1, 80
	syscall
	
	#testing: print the string
	
#	li $v0, 4
#	la $a0, stringmem
#	syscall

	#stringmem holds the string, 
	#s1 holds the start of its location

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
#testing to see how memory addresses interact with character data	
#	lb $t2, 0($s1)
#	lb $t3, 4($s1)
	
#	li $v0, 11
#	move $a0, $t2
#	syscall
	
#	li $v0, 11
#	move $a0, $t3
#	syscall
	
#	j exit
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#find the last character to determine string length
	
	add $t0, $s1, $zero
	add $s2, $zero, $zero
#	la $t3, newline
findLength:
	lb $t2, 0($t0)				#load first byte

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#for testing purposes, print the character
#	li $v0, 11
#	move $a0, $t2
#	syscall
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



	beq $t2, $zero, foundit
#	beq $t2, $t3, foundit
	addi $s2, $s2, 1			#increment s2, which will be length of given string
	addi $t0, $t0, 1
	j findLength
	
	
foundit:
	#string length is in s2
	#The length we're given is the amount of characters +1, for the implicit \n in the string
	addi $s2, $s2, -1

#~~~~~~~~~~~~~~~~~~~~~~	
#Prints the character count of the string
#	li $v0, 4
#	la $a0, strlength
#	syscall
#	li $v0, 1
#	move $a0, $s2
#	syscall
#~~~~~~~~~~~~~~~~~~~~~~~
	
	#move all characters into stack
	
	add $t0, $zero, $zero		#t0 is counter
	add $t1, $s1, $zero			#t1 is base address of string
pushloop:
	lb $t2, 0($t1)				#get character at index
	move $a0, $t2
	jal PUSH					#push value
	addi $t1, $t1, 1			#increment on string
	addi $t0, $t0, 1			#increment counter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Prints the characters of the string as they're pushed in
#	li $v0, 4
#	la $a0, pushing
#	syscall
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	bne $t0, $s2, pushloop

	#entire string should be in stack
	#now compare!
	
	#s2 is counter for string

	add $t0, $zero, $zero	#t0 = 0
	add $t1, $s1, $zero		#t1 = base address of string
	add $t2, $s2, $zero		#counting from the top
	
loopcheck:

	jal ISEMPTY
	bgtz $v0, true			#if the stack is empty, return true.
	
	jal POP
	move $t3, $v0			#t3 = popped item
	lb $t4, 0($t1)			#t4 = character of string
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~
#This block is for debugging, in order to see what's being compared
#	li $v0, 4				
#	la $a0, comparing
#	syscall
#	li $v0, 11
#	move $a0, $t3
#	syscall
#	li $v0, 4
#	la $a0, comma
#	syscall
#	li $v0, 11
#	move $a0, $t4
#	syscall
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	 	 
	addi $t0, $t0, 1		#increment counter
	addi $t1, $t1, 1		#index string position
	addi $t2, $t2, -1		#decrement reverse counter

	beq $t3, $t4, loopcheck	#loop again if characters are equal
	j false					#else, false
	
	
false:
	add $v0, $zero, $zero
	jr $s3	
true:
	addi $v0, $zero, 1
	jr $s3
	
	
PUSH:
	#add $a0 to Stack
	
	#Decrement $sp first
	addi $sp, $sp, -4		#sp = sp-4
	sw $a0, 0($sp)			#add the element
	
	jr $ra


POP:
	#remove the value from current $sp location, return it in v0, adjust $sp
	
	lw $v0, 0($sp)			#v0 = top item
	addi $sp, $sp, 4		#adjust sp
	
	jr $ra

ISEMPTY:
	
	#0x8000 0000 = empty $sp
	#if the current location is below/lesser than the one above, SP is not empty

	sub $v0, $s0, $sp		#v0 = s0-sp = 0x8000 0000 - sp
	slti $v0, $v0, 1		#if v0 < 1, v0 = 0 -> sp = s0 -> empty sp
	
	jr $ra

	
	
exit:
	li $v0, 10
	syscall