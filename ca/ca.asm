# Author: Coleton Watt
# Date: October 24, 2022
# Description: Multiplication table that takes input and builds the respective table

.globl main, user_info,mult_table			# Do not remove this line
# Data for the program goes here
.data
	#string constants
	info: 		.ascii "CS2810 MIPS Program 3\n"
				.asciiz "Welcome to the multiplication table program\n"
	prompt0:    .asciiz "Please enter your name: "
	prompt1:	.asciiz "Up to what multiplication table you want?\n" 
	message:  	.asciiz "\nHello: "
	bye:    	.asciiz "\nBye."
	tab: 		.asciiz "\t"
	nl:  		.asciiz "\n"
	
	line:  		.asciiz "|"				
	lineHorizontal:  		.asciiz "_"	
	table:  		.asciiz "Multi Table"					
		
	num: .word 0
	name: .space 80
	
	size: .word 80



# Code goes here
.text


##########M
main:
	
	# Task 1: Call user_info procedure
	# jal user_info
	
	jal user_info
	
	# Task 2: Capture integer input
		# print(prompt1)
		# r = readInt()
		# save register into num
	li $v0, 4
	la $a0, prompt1 #print(prompt1)
	syscall 
	

	li $v0, 5
	syscall #get input of in and save it in num
	sw $v0, num		


	#li $v0, 1
	#lw $a0, num #pritn int num to confirm input 
	#syscall 
	
	# Task 3: Call mult_table procedure
	# jal mult_table
	jal mult_table
	
#j exit_main	#move to exit not needed
exit_main:
	li   $v0, 4		# print(bye)
	la   $a0, bye
	syscall
	
	li $v0, 10		# 10 is the exit program syscall
	syscall			# execute call

## end of ca.asm


###############################################################
# Display User information
#
# $a0 - input, None
# $v0 - output, None
user_info:
	
	li $v0, 4
	la $a0, prompt0 # print(prompt)
	syscall 

	
	li $v0, 8 #prepare for string read
	la $a0, name #set input name for string read
	lw $a1, size # set size of string not used
	syscall
	
	# print("hello" + name)
	li $v0, 4
	la $a0, message #print("hello")
	syscall 
	li $v0, 4
	la $a0, name #print("name")
	syscall 
	
    # print(info)
  	 li $v0, 4
	la $a0, info #print ("info")
	syscall 
	
end_user_info:
	jr $ra #return to main and last location


###############################################################
# Display Multiplication Table
#
# $a0 - input, None
# $v0 - output, None

mult_table:
	######################## Begin Outer loop
	# TODO: Load Word number
	li $t0, 0  	# Initialize beginning 

	
	lw $t7, num #save num to resigster $t7
	addi $t7, $t7,1 #increase $t7 by 1 0 - num inculding number (wouldn't need to incriment if i used <= vs !="
	
	move $t6, $t7 #make a copy of $t7
	mul $t6, $t6, 10 #multiupy copy of t7 t6 by 10 t6 is used to print the bars 10 times more then numbers to account for tabs
	
	li $v0, 4
	la $a0, table #print(table)
	syscall 
	
	li $v0, 4
	la $a0, tab #print ("\t") 
	syscall 
	 
	 #create topBard of table 
	topBar:
		li $v0, 1
		move $a0, $t0 #prints t0 0-num
		syscall 
		
		li $v0, 4
		la $a0, tab #print ("\t")
		syscall 
	
		addi $t0, $t0, 1

		bne $t0, $t7, topBar #if t0 != t7 jump back up or $t0 < $t7 
		
		li $t0, 0 # Reset $t0 to 0
		
		li $v0, 4
		la $a0, nl #print newLine
		syscall 
		
	end_topBar:
		li $v0, 4
		la $a0, lineHorizontal #prints the horizonal bar across the bottom 10* more for tabs
		syscall 
		addi $t0, $t0, 1
		bne $t0, $t6, 	end_topBar
	
	#prepares for rest of tabel
	li $v0, 4
	la $a0, nl #print newLine
	syscall 
	
	li $t0, 0  	# Reset $t0 to 0
	verticalLoop:
		li $t1, 0
		
		li $v0, 1
		move $a0, $t0 #print(t0) shows what vertical number we are in
		syscall 
		
		li $v0, 4
		la $a0, tab #print ("\t")
		syscall 
		
		li $v0, 4
		la $a0, line #print(" |")
		syscall 
		
		li $v0, 4
		la $a0, tab #print ("\t")
		syscall 
		horizontalLoop:
			mul $t3, $t1, $t0
		
			li $v0, 1
			move $a0, $t3 #print $t0 * $t0 or the multplcation
			syscall 
			
			li $v0, 4
			la $a0, tab #print ("\t")
			syscall 
		
			addi $t1, $t1, 1 #incrament $t1 by one
		
			bne $t1, $t7, horizontalLoop #if $t1 == $t7 then continues down the line
		end_horizontalLoop:
		addi $t0, $t0, 1 #increment vertical line
		
		li $v0, 4
		la $a0, nl #print ("\n")
		syscall 
		
		bne $t0, $t7, verticalLoop #if $t0 != t7 go to vertalLoop else continue
		
end_mult_table:
        jr $ra #jumps back up to main