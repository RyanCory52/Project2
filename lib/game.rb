require_relative 'player_creator'

class Game

    def initialize
        @player_creator = PlayerCreator.new
    end

    def add_players
        @players = @player_creator.get_players
        puts "Welcome #{@players.join(' and ')}"
    end

    #Will create a card with all of the data. A card will contain a color, shape, and a number. All of this data will be randomized and will be stored in an array called info
    # return: the "card", aka an array of information of the color, shape, and number. Color will always be the first position in the array, the shape being second, and number being third
    def card
        #generate random info on the color, shape, and number
        @color = rand(3)
        @shape = rand(3)
        @number = rand(3)

        @info = ['temp', 'temp', 'temp']

        #places the number associated with the card and places it in the correct place in the array. No spacing provided
        @info[2] = @number

        #calculates the random information and places them in the correct place in the array. Spacing provided for the cards
        if @color == 0
            @info[0] = 'red      '
        elsif @color == 1
            @info[0] = 'green    '
        else
            @info[0] = 'blue     '
        end

        if @shape == 0
            @info[1] = 'square   '
        elsif @shape == 1
            @info[1] = 'circle   '
        else
            @info[1] = 'triangle '
        end

        #returns the array with all of the information of the card
        @info
    end

    #Will print the info on the card in a format 
    # param: 3 cards. All 3 cards have to be in the same row
    def print_card(card1, card2, card3)
        puts '------------          ------------          ------------'
        puts "|#{card1[0]} |          |#{card2[0]} |          |#{card3[0]} |"
        puts "|#{card1[1]} |          |#{card2[1]} |          |#{card3[1]} |"
        puts "|#{card1[2]}         |          |#{card2[2]}         |          |#{card3[2]}         |"
        puts '------------          ------------          ------------'
    end

    #Will decide who will start the game randomly. This will also show a quick message of how to play to the user
    def who_starts
        puts ' '
        puts 'The computer will decide who goes first'
        #generates who goes first, and then sends a message
        @order = rand(2)
        if @order == 0
            puts "Player 1 will go first"
        else
            puts "Player 2 will go first"
        end
        #prints a quick instruction on how to play
        puts ' '
        puts 'Each player will go turn for turn to find a set.'
        puts 'The board is created with 4 rows of 3 cards. In order to input a card, you must put the number of the card into the terminal line, followed by a space.'
        puts 'When you are done choosing cards that you believe have a set, then you can press "return" or "enter"'
        puts ' '
        puts 'The cards numbers will look like this: '
        puts '1     2     3'
        puts '4     5     6'
        puts '7     8     9'
        puts '10    11    12'
        puts ' '
        @order
    end

    #Will create an array that will hold the information of the cards and will print the cards out to the terminal
    # returns: the cards that are currently on the board in an array
    def board
        @cardInBoard = []
        @boardCounter = 0
        #gets randomly generated cards and puts them into an array.
        until @boardCounter == 12 do
            @cardInBoard[@boardCounter] = card
            @boardCounter = @boardCounter + 1
        end

        #Will get 3 cards at a time, and then will call print_card, which will print the cards, 3 at a time
        @tempCounter = 0
        until @tempCounter == 12 do
            @tempCard1 = @cardInBoard[@tempCounter]
            @tempCounter = @tempCounter + 1
            @tempCard2 = @cardInBoard[@tempCounter]
            @tempCounter = @tempCounter + 1
            @tempCard3 = @cardInBoard[@tempCounter]
            print_card(@tempCard1, @tempCard2, @tempCard3)
            @tempCounter = @tempCounter + 1
        end

        #returns all of the cards in the board
        @cardInBoard
    end

    #Will manage the game play for the users
    # param: who will start the game, as decided by the computer
    def game_play(starter)
        puts ' '
        @playerOnePlaying = 1
        @points = [0, 0]
        if starter == 0
            puts 'Player 1, you may now begin' 
        else
            puts 'Player 2, you may now begin'
            @playerOnePlaying = 0
        end
        puts ' '

        #prints the board out for the user
        board

        #While the user doesn't input quit, work the scoring. If the user inputs quit, then "end" the game
        @inputFromUser = 'go'
        while @inputFromUser != 'quit'
            @cardsPlayed = []
            @inputFromUser = gets.chomp
            @chars = @inputFromUser.split('')

            if @inputFromUser != 'quit'
                if @playerOnePlaying == 1
                    @points[0] = @points[0] + 1
                    @playerOnePlaying = 0
                else
                  @points[1] = @points[1] + 1
                   @playerOnePlaying = 1
                 end
                 board
            end
        end

        end_message(@points)

    end

    #Will print the end message for the users to know who won the game with a final score-board
    # param: an array of all of the points earned from both players
    def end_message(pointsEarned)
        #prints the start of the message with the final score-board
        puts ' '
        puts 'Game over'
        puts 'Great game!'
        puts ' '
        puts 'Here are the final points: '
        puts "Player 1: #{pointsEarned[0]}"
        puts "Player 2: #{pointsEarned[1]}"
        puts ' '
        
        #Will print the message for who won
        if pointsEarned[0] > pointsEarned[1]
            puts 'Congrats player 1, you won!'
        elsif pointsEarned[1] > pointsEarned[0]
            puts 'Congrats player 2, you won!'
        else
            puts "Congrats both players! It's a tie!"
        end
    end

    def start
        @starterOfGame = who_starts
        game_play(@starterOfGame)
    end

end