# Battleships COM1001 Individual Assignment 1
# Written by Ben Reitz

require "colorize"
require "text-table"

## CREATES A 10x10 array ##
def createArray
	return Array.new(10) { Array.new(10, 0) }
end

## DISPLAYS THE GAME BOARD IN A CLEAR AND AESTHETICALLY PLEASING WAY ##
def displayArray(size=10, array)
	
	puts ""
	print "  "
	print "  ".colorize(:background => :white)
	(0...10).each do |num|
		print " #{num}".white.on_magenta
	end
	puts ""
	for row in 0...10
		print "  "
		print " #{row}".white.on_green
		for col in 0...10
			case array[row][col] # only outputs ship locations
			when 0		# Hidden empty water
				print "  "
			when 1		# Hidden ship (length 5)
				print "  "
			when 2		# Hidden ship (length 4)
				print "  "
			when 3		# Hidden ship (length 3)
				print "  "
			when 4		# Hidden ship (length 3)
				print "  "
			when 5		# Hidden ship (length 2)
				print "  "
			when 6		# Visible empty water bombed
				print "  ".colorize(:background => :blue)
			when 7		# Visible ship bombed
				print " S".white.on_red
			end
		end
		puts ""
	end
end

## PLACES SHIP ON BOARD BY FINDING A RANDOM EMPTY LOCATION FOR IT AND CHANGING THE VALUES TO THE SHIP'S ID ON THE BOARD ##
def placeShip(length, array, id)

	#FINDS RANDOM AND EMPTY CELLS IN WHICH TO PLACE SHIP
	
	cellsOccupied = true	# Default value
	randomRow = 0			# Default value
	randomCol = 0			# Default value
	vertical = 0			# Default value
	until cellsOccupied == false # Carries out loop until it finds random, empty cells for ship

		vertical = rand(2) == 1 # 50/50 chance of ship being placed vertically/horizontally
  
		if vertical
  
			randomRow = rand(11-length)	# Ensures ship's starting cell won't mean the ship will go outside the array boundary
			randomCol = rand(10)
					
			cellsOccupied = verticalShipCheck(array, length, randomRow, randomCol) # Checks that random location for this ship has not already been filled
		
		else
			randomRow = rand(10)
			randomCol = rand(11-length)
					
			cellsOccupied = horizontalShipCheck(array, length, randomRow, randomCol)
  
		end
		
		if cellsOccupied == false
			startingCell = array[randomRow][randomCol]
		end	
	end
	
	#PLACES  SHIP
	
	if vertical
		for num in 0...length
			array[randomRow+num][randomCol] = id
		end
	else
		for num in 0...length
			array[randomRow][randomCol+num] = id
		end
	end	
	
	return array
	
end

## CHECKS IF A SHIP CAN BE PLACED HORIZONTALLY DEPENDING ON LENGTH, OCCUPIED SPACES AND BOARD SIZE ##
def verticalShipCheck (arr, length, row, col) #checks if there is a ship in the space where it has randomly chosen to place a ship
	
	counter = 0
	for num in 0...length
		counter += arr[row + num][col]
	end
	
	return counter > 0
	
end

## CHECKS IF A SHIP CAN BE PLACED HORIZONTALLY DEPENDING ON LENGTH, OCCUPIED SPACES AND BOARD SIZE ##
def horizontalShipCheck (arr, length, row, col) 
	
	counter = 0
	for num in 0...length
		counter += arr[row][col + num]
	end

	return counter > 0
	
end

## CREATES GAMEBOARD AND PLACES SHIPS ON BOARD USING placeShip METHOD ##
def initialiseGameboard
	
	puts ""
	puts "     Welcome to BATTLESHIPS!     ".colorize(:red).colorize(:background => :white)
	initialArray = createArray

	initialArray = placeShip(5, initialArray, 1) # (length, board array, ship ID)
	initialArray = placeShip(4, initialArray, 2)
	initialArray = placeShip(3, initialArray, 3)
	initialArray = placeShip(3, initialArray, 4)
	initialArray = placeShip(2, initialArray, 5)
	
	puts "\n  There are now 5 ships hidden on the board:\n\n"
	print "  1 x "
	print "SSSSS".white.on_red
	puts " (Ship #1 - Aircraft Carrier)"
	print "  1 x "
	print "SSSS".white.on_red
	puts " (Ship #2 - Cruiser)"
	print "  2 x "
	print "SSS".white.on_red
	puts " (Ship #3 & Ship #4 - Destroyers)"
	print "  1 x "
	print "SS".white.on_red
	puts " (Ship #5 - Submarine)"
	puts "\n  Just choose any co-ordinate to drop a bomb and try to hit a ship!"
	print "  The aim is to "
	print "DESTROY".colorize(:white).colorize(:background => :red)
	puts " all ships in as few moves as possible.\n"
	
	return initialArray

end

## GETS ROW NUMBER TO BOMB FROM USER ##
def getRow
	row = nil	# default value
	loop do	# gets row from user until it is a valid row number
		puts ""
		print "  What "
		print "row".upcase.white.on_green
		print " (0-9) would you like to bomb? : "
		row = gets.chomp.to_i
	break if (row >= 0) && (row < 10)
		puts "  #{row} not a valid row number!  Your row must be a value from 0 to 9.".colorize(:red)
	end
	return row
end

## GETS COLUMN NUMBER TO BOMB FROM USER ##
def getCol
	col = nil
	loop do # gets column from user until it is a valid column number
		puts ""
		print "  What "
		print "column".upcase.white.on_magenta
		print " (0-9) would you like to bomb? : "
		col = gets.chomp.to_i
	break if (col >= 0) && (col < 10)
		puts "  #{col} is not a valid column number!  Your column must be a value from 0 to 9.".colorize(:red)
	end
	return col
end

## CHECKS SURROUNDING CELLS FOR ANY HIDDEN SHIPS - RETURNS FALSE IF THERE ARE NONE ##
def nearMissCheck(arr, row, column)

	nearMiss = false
	case row  # Ignores any locations outside the game board to prevent any errors
	when 0
		case column
		when 0
			case arr[row+1][column]
			when 1..5 then nearMiss = true
			end
			case arr[row][column+1]
			when 1..5 then nearMiss = true
			end
		when 9
			case arr[row+1][column]
			when 1..5 then nearMiss = true
			end
			case arr[row][column-1]
			when 1..5 then nearMiss = true
			end
		else
			case arr[row+1][column]
			when 1..5 then nearMiss = true
			end
			case arr[row][column+1]
			when 1..5 then nearMiss = true
			end
			case arr[row][column-1]
			when 1..5 then nearMiss = true
			end
		end
	when 9
		case column
		when 0
			case arr[row-1][column]
			when 1..5 then nearMiss = true
			end
			case arr[row][column+1]
			when 1..5 then nearMiss = true
			end
		when 9
			case arr[row-1][column]
			when 1..5 then nearMiss = true
			end
			case arr[row][column-1]
			when 1..5 then nearMiss = true
			end
		else
			case arr[row-1][column]
			when 1..5 then nearMiss = true
			end
			case arr[row][column+1]
			when 1..5 then nearMiss = true
			end
			case arr[row][column-1]
			when 1..5 then nearMiss = true
			end
		end
	else
		case arr[row+1][column]
		when 1..5 then nearMiss = true
		end
		case arr[row-1][column]
		when 1..5 then nearMiss = true
		end
		case arr[row][column+1]
		when 1..5 then nearMiss = true
		end
		case arr[row][column-1]
		when 1..5 then nearMiss = true
		end
	end	
	return nearMiss
end

## CARRIES OUT ACTION AND RETURNS OUTCOME TO USER.  RETURNS GAME BOARD ARRAY AFTER ACTION HAS FINISHED ##
def shoot(column,row,board)

	puts "----------------------------------------------------------------------------"
	puts "  RESULTS".white.on_black
	puts ""
	case board[row][column]
	when 0  #Hidden water square
		board[row][column] = 6
		@numTurns += 1

		print "  "
		print "It's just empty water at at #{column}, #{row}!".white.on_blue
		if nearMissCheck(board,row,column)
			print "  ||  "
			puts "That was a near miss though!".cyan
			puts ""
		else
			print "  ||"
		end
		@outcome = "Hit empty water :("
	when 1  #Ship #1 hidden
		board[row][column] = 7
		@numTurns += 1
		ship1LeftToHit = 0 # Defaults counter value to 0 before count
		board.each do |column|
			ship1LeftToHit += column.count(1)
		end
		print "  "
		print "You hit Ship #1 at #{column}, #{row}!".cyan.on_red
		print "  ||  "
		ship1LeftToHit.times {print "S".white.on_red}  # Graphically displays how many parts of this ship are still left to hit.
		(5-ship1LeftToHit).times {print "X".red.on_red}
		if ship1LeftToHit == 0
			print "  ||  "
			puts "YOU HAVE DESTROYED THE AIRCRAFT CARRIER!\n".red
			@outcome = "DESTROYED Aircraft Carrier (Ship #1)!"
		else
			print "  ||"
			@outcome = "Hit Ship #1!"
		end
	when 2  #Ship #2 Hidden
		board[row][column] = 7
		@numTurns += 1
		ship2LeftToHit = 0 # Defaults counter value to 0 before count
		board.each do |column|
			ship2LeftToHit += column.count(2)
		end
		print "  "
		print "You hit Ship #2 at #{column}, #{row}!".cyan.on_red
		print "  ||  "
		ship2LeftToHit.times {print "S".white.on_red}  # Graphically displays how many parts of this ship are still left to hit.
		(4-ship2LeftToHit).times {print "X".red.on_red}
		if ship2LeftToHit == 0
			print "  ||  "
			puts "YOU HAVE DESTROYED THE CRUISER!\n".red
			@outcome = "DESTROYED Cruiser (Ship #2)!"
		else
			print "  ||"
			@outcome = "Hit Ship #2!"
		end
	when 3  #Ship #3 Hidden
		board[row][column] = 7
		@numTurns += 1
		ship3LeftToHit = 0 # Defaults counter value to 0 before count
		board.each do |column|
			ship3LeftToHit += column.count(3)
		end
		print "  "
		print "You hit Ship #3 at #{column}, #{row}!".cyan.on_red
		print "  ||  "
		ship3LeftToHit.times {print "S".white.on_red}  # Graphically displays how many parts of this ship are still left to hit.
		(3-ship3LeftToHit).times {print "X".red.on_red}
		if ship3LeftToHit == 0
			print "  ||  "
			puts "YOU HAVE DESTROYED A DESTROYER!\n".red
			@outcome = "DESTROYED DESTROYER (Ship #3)!"
		else
			print "  ||"
			@outcome = "Hit Ship #3!"
		end
	when 4  #Ship #4 Hidden
		board[row][column] = 7
		@numTurns += 1
		ship4LeftToHit = 0 # Defaults counter value to 0 before count
		board.each do |column|
			ship4LeftToHit += column.count(4)
		end
		print "  "
		print "You hit Ship #4 at #{column}, #{row}!".cyan.on_red
		print "  ||  "
		ship4LeftToHit.times {print "S".white.on_red}  # Graphically displays how many parts of this ship are still left to hit.
		(3-ship4LeftToHit).times {print "X".red.on_red}
		if ship4LeftToHit == 0
			print "  ||  "
			puts "YOU HAVE DESTROYED A DESTROYER!\n".red
			@outcome = "DESTROYED Destroyer (Ship #4)!"
		else
			print "  ||"
			@outcome = "Hit Ship #4!"
		end
	when 5  #Ship #5 hidden
		board[row][column] = 7
		@numTurns += 1
		ship5LeftToHit = 0 # Defaults counter value to 0 before count
		board.each do |column|
			ship5LeftToHit += column.count(5)
		end
		print "  "
		print "You hit Ship #5 at #{column}, #{row}!".cyan.on_red
		print "  ||  "
		ship5LeftToHit.times {print "S".white.on_red}  # Graphically displays how many parts of this ship are still left to hit.
		(2-ship5LeftToHit).times {print "X".red.on_red}
		if ship5LeftToHit == 0
			print "  ||  "
			puts "YOU HAVE DESTROYED THE SUBMARINE!\n".red
			@outcome = "DESTROYED Submarine (Ship #5)!"
		else
			print "  ||"
			@outcome = "Hit Ship #5!"
		end
	else
		print "\n  You've already shot there! Try again.".red
		@outcome = "Already hit here"
	end
	return board
	
end

###### MAIN GAME METHOD BELOW ######

gameBoard = initialiseGameboard # Creates and initialises gameBoard

# STATS #
@numTurns = 0  # Counter for number of turns
@outcome = nil  # Records outcome of each turn in the statsTable below.  Instance variable so can be accessed in shoot method.
statsTable = Text::Table.new  #Statistics table to be shown at end of game
statsTable.head = ['Turn', 'Ship squares left','Square','Outcome']
# /STATS #

loop do  # Loops player turns until they have won the game
	puts ""
	puts "         TURN #{@numTurns+1}         ".white.on_cyan  # Shows turn number at top of turn
	displayArray(gameBoard)
	col = getCol
	row = getRow
	gameBoard = shoot(col, row, gameBoard)
	numToHit = 0  # Default value for number of ship tiles left to hit
	gameBoard.each do |column|  # Counts how many tiles containing a ship are left
		numToHit += column.count(1)+column.count(2)+column.count(3)+column.count(4)+column.count(5)
	end
	statsTable.rows << [@numTurns, numToHit,"(#{col}, #{row})",@outcome]
	puts "  #{numToHit} ship tiles still to hit!".green
	puts "----------------------------------------------------------------------------"
	
	## Does countdown of 3 seconds before next turn to allow user to read the outcome of their turn
	print "  Time until next turn:  3..".yellow
	sleep(1)
	print" 2..".yellow
	sleep(1)
	print " 1..".yellow
	sleep(1)
	puts ""
	break if numToHit == 0  # Breaks loop if all ship tiles have been hit
end
puts ""
puts statsTable.to_s  # Displays table of statistics at the end
displayArray(gameBoard)  # Displays final game board
puts ""
print "  "
puts "Well done! You completed the game in #{@numTurns} turns.".white.on_green

###### GAME OVER ######