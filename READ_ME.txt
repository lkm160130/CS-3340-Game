Written by: Logan Moon
Class: CS 3340.003
Semester: 2018 Spring
Email: lkm160130@utdallas.edu

IMPORTANT NOTE: This program should be run in a modified version of MARS (Included in this repo as version 4.5). The modification is to fix a bug in the KeyboardAndDisplaySimulator.java file of MARS. Credit to the one who discovered the
 bug fix: https://dtconfect.wordpress.com/2013/02/09/mars-mips-simulator-lockup-hackfix/ . If the program is run without
 the bug fix it will eventually cause MARS to freeze up and become unresponsive (thus needing a complete restart of MARS).

What is this: This program is a game in which the player uses the 'w' and 's' keys to move a player square up and down.
 Many enemy squares will approach the player. The goal of the game is to dodge as many enemies as possible. Once the player
 collides with an enemy the game is over. Points are based on the number of enemies dodged. As the player's score increases,
 difficulty will increase by increasing the speed of the enemy squares.

How to run: Once the modified MARS is running, open up the project.asm file (included in this repo). Then in the 
 "Tools" drop down menu select "Bitmap Display". 
	Bitmap Display Settings:
	  Unit Width in Pixels:		8
	  Unit Height in Pixels: 	8
	  Display Width in Pixels:	512
	  Display Height in Pixels:	256
	  Base address for display:	0x10010000(static data)
 Now open the "Keyboard and Display Simulator" (also in the Tools dropdown)
 Make sure both the Bitmap Display and the Keyboard and Display Simulator are connected to mips
 Then assemble and run the Program. Entering 'w' or 's' in the Keyboard and Display Simulator will move the player up and down
	
  
