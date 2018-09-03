#Logan Moon
#CS 3340.003 Final Project

.data

bitmapDisplay: 		.space 0x80000 #create space for bitmap display
width: 			.word  0x00000100 #width of bitmap display
height:			.word  0x00000200 #height of bitmap display
playerScore: 		.word  0x00000000 #the score of the player (starts at 0)
playerLocation: 	.word  0x10011004 #location of the player
playerColor:		.word  0x00ffa500 #color of the player
borderColor:		.word  0x00000ff  #color of the border
enemyColor:		.word  0x00ffff00 #color of the enemy
black: 			.word  0x00000000 #black
speed: 			.word  0x00000064 #speed (how much delay)
speedIncreaseScore:	.word  0x00000032 #when to increase the speed

startOfBorderTop:	.word  0x10010000 #start of the top row border
endOfBorderTop:		.word  0x100100fc #end of the top row border
startOfBorderBottom:	.word  0x10011f00 #start of the bottom row border
endOfBorderBottom:	.word  0x10011ffc #end of the bottom row border
startOfPlayerColumn:	.word  0x10010104 #start of the player column
endOfPlayerColumn:	.word  0x10011e04 #end of the player column


enemy1Location: 	.word 0x100101fc #location of enemy 1
enemy2Location: 	.word 0x100101ec #location of enemy 2
enemy3Location: 	.word 0x100101dc #location of enemy 3
enemy4Location: 	.word 0x100101cc #location of enemy 4
enemy5Location: 	.word 0x100101bc #location of enemy 5
enemy6Location: 	.word 0x100101ac #location of enemy 6
enemy7Location: 	.word 0x1001019c #location of enemy 7
enemy8Location: 	.word 0x1001018c #location of enemy 8
enemy9Location: 	.word 0x1001017c #location of enemy 9
enemy10Location: 	.word 0x1001016c #location of enemy 10
enemy11Location: 	.word 0x1001015c #location of enemy 11
enemy12Location: 	.word 0x1001014c #location of enemy 12
enemy13Location: 	.word 0x1001013c #location of enemy 13
enemy14Location: 	.word 0x1001012c #location of enemy 14
enemy15Location: 	.word 0x1001011c #location of enemy 15
enemy16Location: 	.word 0x1001010c #location of enemy 16

gameMusic: 		.word 39 #MIDI tone 39
gameMusic2: 		.word 40 #MIDI tone 40 (not used)
duration1:		.word 150 #duration of 150 milliseconds
duration2:		.word 750 #duration of #750 milliseconds
pitch1:			.word 70  #1st pitch
pitch2:			.word 65  #2nd pitch
pitch3:			.word 60  #3rd pitch
pitch4:			.word 55  #4th pitch
pitch5:			.word 50  #5th pitch
volume:			.word 100 #volume level
delayBtwnNotes:		.word 300 #delay time between notes

currentScoreMessage: 	.asciiz "Current Score is: "
endMessage: 		.asciiz "Game Over, Final Score is: "
newLine: 		.asciiz "\n"


.text



jal makeBoard #make the board

runGame:
li $v0, 32 #delay based on speed setting
lw $a0, speed
syscall
 jal setSpeed #set the speed of the game
 jal getKeyboardInput #get input from the keyboard
 jal moveEnemiesLeft #move all enemies left
 jal checkBoard #check for any collisions with the player

j runGame #go back to top of loop


exit: #after the player collided with an enemy, print final score, make end music and terminate program
li $v0, 4 #print end message
la $a0, endMessage
syscall

li $v0, 1 #print end score
lw $a0, playerScore
syscall

jal endMusic #play end music



li $v0, 10 #end program
syscall
#****************************************************************************************************************************
#***************************************************************************************************************************
makeBoard:

 lw $t0, borderColor #color of the border
 lw $t1, startOfBorderTop #location of the start of the top border (top left of screen in bitmap display)

 lw $s0, endOfBorderTop #location of the end of the top border (top right of screen in bitmap display)
 lw $s1, endOfBorderBottom #location of the end of the bottom border (bottom right of the screen in bitmap)
  makeTop: #make the top row
  sw $t0, ($t1) #set pixel to $t0 color
  addi $t1, $t1, 4 #move to next pixel
  bne $t1, $s0, makeTop #if end of border top not reached, continue coloring
  sw $t0, ($t1) #make last pixel $t0 color
  
 lw $t1, startOfBorderBottom #location of the start of the bottom border (bottom left of the screen in bitmap display)
  makeBottom: #make the bottom row
  sw $t0, ($t1) #set pixel to $t0 color
  addi $t1, $t1, 4 #move to next pixel
  bne $t1, $s1, makeBottom #if end of border bottom not reached, continue coloring
  sw $t0, ($t1) #make last pixel $t0
  
  lw $t0, playerColor #color of the player
  lw $t1, playerLocation #location of the player
  makePlayer:
  sw $t0, ($t1) #set the player location to the player color
  
  return1:
  jr $ra #return back to caller
#***************************************************************************************************************
#****************************************************************************************************************
getKeyboardInput:



lw $t1, 0xffff0004 #location to read input from
lw $t2, playerLocation #location of the player
lw $t3, playerColor #color of the player
lw $t4, black #the color black
lw $t5, startOfPlayerColumn #the start of the player column (top of column in bitmap display)
lw $t6, endOfPlayerColumn #the end of the player column (bottom of the column in bitmap display)

beq $t1, 119, moveUp #based on input move up or move down
beq $t1, 115, moveDown
  return2: #return
   sw $t2, playerLocation #store new player location
   jr $ra #return back to caller
   
  moveUp: #if input is the 'w' character move up
    ble $t2, $t5, return2 #if player location is less than start of player column (above or equal to the top of the column in bitmap display)
   sw $t4, ($t2) #make old location black
   addi $t2, $t2, -256 #move player location back 256 (move up on bitmap display)
   sw $t3, ($t2) #make new player location player color
   
   j return2 #return back to caller
  moveDown: #if input is the 's' character
   bge $t2, $t6, return2 #if player location is greater than start of end of player column (below or equal to the top of the column in bitmap display)
   sw $t4, ($t2) #make old location black
   addi $t2, $t2, +256 #move player location forward 256 (move down on bitmap display)
   sw $t3, ($t2) #make new player location player color
   j return2
  #**********************************************************************************************************
  #*********************************************************************************************************

checkBoard:
lw $t0, playerLocation #get player location

lw $t1, enemy1Location #get player location of 1st enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy2Location #get player location of 2nd enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy3Location #get player location of 3rd enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy4Location #get player location of 4th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy5Location #get player location of 5th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy6Location #get player location of 6th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy7Location #get player location of 7th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy8Location #get player location of 8th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy9Location #get player location of 9th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy10Location #get player location of 10th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy11Location #get player location of 11th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy12Location #get player location of 12th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy13Location #get player location of 13th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy14Location #get player location of 14th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy15Location #get player location of 15th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

lw $t1, enemy16Location #get player location of 16th enemy
beq $t1, $t0, exit #if player location is at same point as enemy location then exit

jr $ra #return to caller
#*********************************************************************************************************************************
moveEnemiesLeft: #shifts all enemies left one on bitmap display
lw $t0, enemyColor #color of the enemy
lw $t2, black #the color black

li $t4, 0xfc000000 #used later to check if enemy has reached left most side of the bitmap display

addi $s1, $ra, 0 #store the return address ($ra will be overwritten later so we store it in $s1)

#enemy 1
lw $t1, enemy1Location #get location of 1st enemy
sw $t2, ($t1) #make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy1Location #store new enemy location 
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy1Location #get location of 1st enemy (again)
sll $t3, $a2, 24  #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy1 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy1 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy1:
  jal generateNewEnemy #call generateNewEnemy with $a2 as an argument holding enemy1Location
 noGenerateNewEnemy1:
sw $a2, enemy1Location #store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2) #make new location enemy color

#enemy2
lw $t1, enemy2Location #get location of 2nd enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy2Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy2Location #get location of 2nd enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy2 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy2 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy2:
  jal generateNewEnemy #call generateNewEnemy with $a2 as an argument holding enemy2Location
 noGenerateNewEnemy2:
sw $a2, enemy2Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy 3
lw $t1, enemy3Location #get location of 3rd enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy3Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy3Location #get location of 3rd enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy3 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy3 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy3:
  jal generateNewEnemy #call generateNewEnemy with $a2 as an argument holding enemy3Location
 noGenerateNewEnemy3:
sw $a2, enemy3Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy 4
lw $t1, enemy4Location #get location of 4th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy4Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy4Location #get location of 4th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy4 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy4 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy4:
  jal generateNewEnemy #call generateNewEnemy with $a2 as an argument holding enemy4Location
 noGenerateNewEnemy4:
sw $a2, enemy4Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy5
lw $t1, enemy5Location #get location of 5th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy5Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy5Location #get location of 5th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy5 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy5 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy5:
  jal generateNewEnemy #call generateNewEnemy with $a2 as an argument holding enemy5Location
 noGenerateNewEnemy5:
sw $a2, enemy5Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy6
lw $t1, enemy6Location #get location of 6th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy6Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy6Location #get location of 6th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy6 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy6 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy6:
  jal generateNewEnemy #call generateNewEnemy with $a2 as an argument holding enemy6Location
 noGenerateNewEnemy6:
sw $a2, enemy6Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy7
lw $t1, enemy7Location #get location of 7th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy7Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy7Location #get location of 7th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy7#if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy7 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy7:
  jal generateNewEnemy #call generateNewEnemy with $a2 as an argument holding enemy7Location
 noGenerateNewEnemy7:
sw $a2, enemy7Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy8
lw $t1, enemy8Location #get location of 8th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4  #shift $t1 left by 4
sw $t1, enemy8Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy8Location #get location of 8th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy8 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy8 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy8:
  jal generateNewEnemy#call generateNewEnemy with $a2 as an argument holding enemy8Location
 noGenerateNewEnemy8:
sw $a2, enemy8Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color



#enemy 9
lw $t1, enemy9Location #get location of 9th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy9Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy9Location #get location of 9th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy9 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy9 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy9:
  jal generateNewEnemy#call generateNewEnemy with $a2 as an argument holding enemy9Location
 noGenerateNewEnemy9:
sw $a2, enemy9Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy 10
lw $t1, enemy10Location #get location of 10th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy10Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy10Location #get location of 10th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy10 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy10 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy10:
  jal generateNewEnemy#call generateNewEnemy with $a2 as an argument holding enemy10Location
 noGenerateNewEnemy10:
sw $a2, enemy10Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy 11
lw $t1, enemy11Location #get location of 11th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy11Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy11Location #get location of 11th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy11 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy11 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy11:
  jal generateNewEnemy#call generateNewEnemy with $a2 as an argument holding enemy11Location
 noGenerateNewEnemy11:
sw $a2, enemy11Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy 12
lw $t1, enemy12Location #get location of 12th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy12Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy12Location #get location of 12th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy12 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy12 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy12:
  jal generateNewEnemy#call generateNewEnemy with $a2 as an argument holding enemy12Location
 noGenerateNewEnemy12:
sw $a2, enemy12Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy 13
lw $t1, enemy13Location #get location of 13th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy13Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy13Location #get location of 13th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy13 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy13 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy13:
  jal generateNewEnemy#call generateNewEnemy with $a2 as an argument holding enemy13Location
 noGenerateNewEnemy13:
sw $a2, enemy13Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy 14
lw $t1, enemy14Location #get location of 14th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy14Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy14Location #get location of 14th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy14 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy14 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy14:
  jal generateNewEnemy#call generateNewEnemy with $a2 as an argument holding enemy14Location
 noGenerateNewEnemy14:
sw $a2, enemy14Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy 15
lw $t1, enemy15Location #get location of 15th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy15Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy15Location #get location of 15th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy15 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy15 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy15:
  jal generateNewEnemy#call generateNewEnemy with $a2 as an argument holding enemy15Location
 noGenerateNewEnemy15:
sw $a2, enemy15Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

#enemy 16
lw $t1, enemy16Location #get location of 16th enemy
sw $t2, ($t1)#make old location black
addi $t1, $t1, -4 #shift $t1 left by 4
sw $t1, enemy16Location #store new enemy location
sw $t0, ($t1) #make new location enemy color

lw $a2, enemy16Location #get location of 16th enemy (again)
sll $t3, $a2, 24   #shift left 24 times (addresses are in hexidecimal representation but sll operates on them as binary numbers)
		  #this is to determine in what column of the bitmap display the enemy in in

beq $t3, $t4, jumpToGenerateNewEnemy16 #if the enemy is in the furthest right column generate a new enemy (It appears on the bitmap display that 
				      #the enemies disappear after they pass the left most column, so we check if the right most column
				      #contains an enemy. This is because the address left of a leftmost column address is the right most
				      #column address moved up one row.)
j noGenerateNewEnemy16 #if we dont need to generate a new enemy then skip over next two lines of code
 jumpToGenerateNewEnemy16:
  jal generateNewEnemy#call generateNewEnemy with $a2 as an argument holding enemy16Location
 noGenerateNewEnemy16:
sw $a2, enemy16Location#store $a2 as the new enemy location (this will only change the location if generateNewEnemy was called)
sw $t0, ($a2)#make new location enemy color

addi $ra, $s1, 0 #set $ra back to its old value



jr $ra #return back to caller



generateNewEnemy:
lw $t4, playerScore #get player score
addi $t4, $t4, 1 #add 1 to $t4
sw $t4, playerScore #set new player score (old score + 1)

lw $t2, black #get black color
sw $t2, ($a2) #make the argument in $a2 black
addi $s7, $a2, 0 #store the address of $a2 in $s7 (because the soud generator below requires a different value for $a2)

li $v0, 42
li $a0, 117 #psuedo random number generator number
li $a1, 30
syscall

li $t1, 256 #put 256 in $t1
mult $a0, $t1 #multiply the randomly generated number by 256
mflo $t5 #get result
lw $t3, endOfBorderTop #get the end of boder top
addi $t3, $t3, 256 #add 256 to $t3 (go down a row on bitmap display)
add $a2, $t5, $t3 #add $t3 with the randomwly generated number that was multiplied by 256 to get a random starting location for our enemy


li $v0, 4 #print out current score message
la $a0, currentScoreMessage 
syscall

li $v0, 1 #print out current score
lw $a0, playerScore
syscall

li $v0, 4 #make new line
la $a0, newLine
syscall

lw $t5, endOfBorderTop #get end of border top
lw $t6, borderColor #get border color
sw $6, ($t5) #make end of border top the color of borderColor (this is because endOfBorderTop may have been made black and we need to change it back)

addi $t7, $a2, 0 #save $a2 in $t7


#Music generator for every time a point is aquired
#Commented out because it doesnt sound good
#Uncomment if you want to hear sound for getting points

#lw $a1, speed
#li $v0, 31
#lw $a0, pitch1
#sll $a1, $a1, 1
#lw $a2, gameMusic
#lw $a3, volume
#syscall


addi $a2, $t7, 0 #restore $a2 to its previous value



jr $ra #return to caller




setSpeed: #set the speed of the game based on the amount of points the player has
 lw $t0, speed #speed of the game
 lw $t1, speedIncreaseScore #number that indicates when to increase the speed (if the player's score reaches this number increase the speed)
 lw $t2, playerScore #current score of the player
 beq $t2, $t1, increaseDifficulty #if the player's score is at the point where we need to increase the speed
 jr $ra #return to caller
 
 increaseDifficulty:
 beq $t0, $zero, skip #if the speed is already as fast as it can be then skip (anyone who reaches this point in the game must be AMAZING!!!)
 addi $t0, $t0, -20 #decrease $t0 by 20
 sll $t1, $t1, 1 #shift $t1 left 1
 sw $t1, speedIncreaseScore #set new speedIncreaseScore
 sw $t0, speed #set new speed
 

 skip:
 
 jr $ra #return to caller
 
endMusic: #music played at the end of the game
li $v0, 31
lw $a0, pitch1 #pitch to use
lw $a1, duration1 #length the tone will be played
lw $a2, gameMusic #type of sound
lw $a3, volume #how loud it will be
syscall

li $v0, 32 #delay between notes
lw $a0, delayBtwnNotes
syscall

li $v0, 31
lw $a0, pitch2 #pitch to use
lw $a1, duration1 #length the tone will be played
lw $a2, gameMusic #type of sound
lw $a3, volume #how loud it will be
syscall

li $v0, 32 #delay between notes
lw $a0, delayBtwnNotes
syscall

li $v0, 31
lw $a0, pitch3 #pitch to use
lw $a1, duration1 #length the tone will be played
lw $a2, gameMusic #type of sound
lw $a3, volume #how loud it will be
syscall

li $v0, 32 #delay between notes
lw $a0, delayBtwnNotes
syscall

li $v0, 31
lw $a0, pitch4 #pitch to use
lw $a1, duration1 #length the tone will be played
lw $a2, gameMusic #type of sound
lw $a3, volume #how loud it will be
syscall

li $v0, 32 #delay between notes
lw $a0, delayBtwnNotes
syscall

li $v0, 31
lw $a0, pitch5 #pitch to use
lw $a1, duration2 #length the tone will be played
lw $a2, gameMusic #type of sound
lw $a3, volume #how loud it will be
syscall

li $v0, 32 #delay between notes
lw $a0, delayBtwnNotes
syscall
 
jr $ra #return to caller
