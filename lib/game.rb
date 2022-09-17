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
    # param: 3 cards -> All 3 cards have to be in the same row
    def print_card(card1, card2, card3)
        puts '------------          ------------          ------------'
        puts "|#{card1[0]} |          |#{card2[0]} |          |#{card3[0]} |"
        puts "|#{card1[1]} |          |#{card2[1]} |          |#{card3[1]} |"
        puts "|#{card1[2]}         |          |#{card2[2]}         |          |#{card3[2]}         |"
        puts '------------          ------------          ------------'
    end

    #Will decide who will start the game randomly. This will also show a quick message of how to play to the user
    # return: whoever will go first
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
        puts "The board is created with 4 rows of 3 cards. In order to input a card, you must put the number of the card into the terminal line, followed by a space. Please don't input at the front and end of the line."
        puts 'When you are done choosing cards that you believe have a set, then you can press "return" or "enter"'
        puts ' '
        puts 'The cards numbers will look like this: '
        puts '0     1     2'
        puts '3     4     5'
        puts '6     7     8'
        puts '9    10    11'
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
    # param: starter -> who will start the game, as decided by the computer
    def game_play(starter)
        puts ' '
        @playerOnePlaying = 1
        @points = [0, 0]
        @currentCardsInBoard = []
        if starter == 0
            puts 'Player 1, you may now begin' 
        else
            puts 'Player 2, you may now begin'
            @playerOnePlaying = 0
        end
        puts ' '

        #prints the board out for the user
        @currentCardsInBoard = board

        #While the user doesn't input quit, work the scoring. If the user inputs quit, then "end" the game
        @inputFromUser = 'go'
        while @inputFromUser != 'quit'
            @cardsPlayedAfterRead = []
            @inputFromUser = gets.chomp
            @chars = @inputFromUser.split('')

            if @inputFromUser != 'quit'
                @cardsPlayedAfterRead = chars_to_cards_played(@inputFromUser)
                if @playerOnePlaying == 1
                    @points[0] = @points[0] + 1
                    @playerOnePlaying = 0
                else
                  @points[1] = @points[1] + 1
                   @playerOnePlaying = 1
                 end
                 @currentCardsInBoard = board
            end
        end

        end_message(@points)

    end

    #Will get the numbers of the cards on the board and return an array of the value of the numbers on the card
    # param: boardParamNum -> the current value of the board
    # param: cardsParamNum -> the cards that were inputed from the user
    # returns: array of the numbers in the cards that the user selected
    def getCardNums(boardParamNum, cardsParamNum)
        @numbers = []
        @cardsParamNumCounter = 0
        @cardsParamNumLength = cardsParamNum.length
        while @cardsParamNumCounter < @cardsParamNumLength
            @cardNum = cardsParamNum[@cardsParamNumCounter]
            @numbers[@cardsParamNumCounter] = boardParamNum[@cardNum][2]
            @cardsParamNumCounter = @cardsParamNumCounter + 1
        end
        @numbers
    end

    #Will get the shapes of the cards on the board and return an array of the value of the shapes on the card
    # param: boardParamShape -> the current value of the board
    # param: cardsParamShape -> the cards that were inputed from the user
    # returns: array of the shapes in the cards that the user selected
    def getCardShapes(boardParamShape, cardsParamShape)
        @cardShapes = []
        @cardsParamShapeCounter = 0
        @cardsParamShapeLength = cardsParamShape.length
        while @cardsParamShapeCounter < @cardsParamShapeLength
            @cardShapeNum = cardsParamShape[@cardsParamShapeCounter]
            @cardShapes[@cardsParamShapeCounter] = boardParamShape[@cardShapeNum][1]
            @cardsParamShapeCounter = @cardsParamShapeCounter + 1
        end
        @cardShapes
    end

    #Will get the color of the cards on the board and return an array of the value of the color on the card
    # param: boardParamColor -> the current value of the board
    # param: cardsParamColor -> the cards that were inputed from the user
    # returns: array of the colors in the cards that the user selected
    def getCardColor(boardParamColor, cardsParamColor)
        @cardColor = []
        @cardsParamColorCounter = 0
        @cardsParamColorLength = cardsParamColor.length
        while @cardsParamColorCounter < @cardsParamColorLength
            @cardColorNum = cardsParamColor[@cardsParamColorCounter]
            @cardColor[@cardsParamColorCounter] = boardParamColor[@cardColorNum][0]
            @cardsParamColorCounter = @cardsParamColorCounter + 1
        end
        @cardColor
    end

    #Will get the characters that were inputed from the user and will move return an array with all of the information of the cards used by the user
    # param: Array of chars that the user inputed 
    # return: an array of the card numbers that the user inputed
    def chars_to_cards_played(charsInput)
        @charCounter = 0
        @curCardNum = 0
        @cardsPlayed = []
        @cardCounter = 0
        @charLength = charsInput.length 
        @curChar
        #loop through the array of characters until we reach the end
        while @charCounter < @charLength
            @curChar = charsInput[@charCounter]
            #if the current value is a space, then we know that the current number is not a space and move on
            if @curChar == ' '
                @cardCounter = @cardCounter + 1
            #if the current card is nil, then we need to create it and set it to the value of the current number
            elsif @cardsPlayed[@cardCounter] == nil
                @curChar = @curChar.to_i
                @cardsPlayed[@cardCounter] = 0
                @cardsPlayed[@cardCounter] = @cardsPlayed[@cardCounter] + @curChar
            #if the card is not null, add the current integer to the end of the current value of the card
            else
                @curChar = @curChar.to_i
                @curCardNum = @cardsPlayed[@cardCounter]
                @curCardNum = @curCardNum * 10
                @curCardNum = @curCardNum + @curChar
                @cardsPlayed[@cardCounter] = @curCardNum
            end
            @charCounter = @charCounter + 1
        end

        @cardsPlayed
    end

    #Will check to see if there is a set from the cards chosen
    # param: colorArr -> the values of the colors from the cards
    # param: shapeArr -> the values of the shapes from the cards
    # param: numberArr -> the values of the numbers from the cards
    # returns: whether there is a set from the cards that the user inputs. 1 = yes, 0 = no
    def isSet(colorArr, shapeArr, numberArr)
        @colorSet = 1
        @shapeSet = 1
        @numberSet = 1
        @firstColor = colorArr[0]
        @firstShape = shapeArr[0]
        @firstNumber = numberArr[0]
        @setCounter = 1
        @setLength = @colorArr.length
        @setInArrs = 1
        while @setCounter < @setLength
            @curColor = colorArr[@setCounter]
            @curShape = shapeArr[@setCounter]
            @curNum = numberArr[@setCounter]
            if @curColor != @firstColor
                @colorSet = 0
            end
            if @curShape != @firstShape
                @shapeSet = 0
            end
            if @curNum != @firstNumber
                @numberSet = 0
            end
        end
        if @colorSet == 0 && @numberSet == 0 && @shapeSet == 0
            @setInArrs = 0
        end
        @setInArrs
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
#        @starterOfGame = who_starts
#        game_play(@starterOfGame)
        @tempBoard = []
        @tempBoard = board
        @userCards = []
        @tempValues = []
        @userInput = gets.chomp
        @charsInn = @userInput.split('')
        @userCards = chars_to_cards_played(@charsInn)
        @tempValues = getCardColor(@tempBoard, @userCards)

        puts "value 1: #{@tempValues[0]}"
        puts "value 2: #{@tempValues[1]}"
    end

end