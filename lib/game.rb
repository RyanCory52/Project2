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
        @color = rand(3)
        @shape = rand(3)
        @number = rand(3)

        @info = ['temp', 'temp', 'temp']

        @info[2] = @number

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
        @order = rand(2)
        if @order == 0
            puts "Player 1 will go first"
        else
            puts "Player 2 will go first"
        end
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
        until @boardCounter == 12 do
            @cardInBoard[@boardCounter] = card
            @boardCounter = @boardCounter + 1
        end

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

        @currentCardsInBoard = board

        @inputFromUser = 'go'
        while @inputFromUser != 'quit'
            @cardsPlayedAfterRead = []
            @inputFromUser = gets.chomp
            @chars = @inputFromUser.split('')

            if @inputFromUser != 'quit'
                @cardsPlayedAfterRead = chars_to_cards_played(@inputFromUser)
                @colorValue = getCardColor(@currentCardsInBoard, @cardsPlayedAfterRead)
                @shapeValue = getCardShapes(@currentCardsInBoard, @cardsPlayedAfterRead)
                @numberValue = getCardNums(@currentCardsInBoard, @cardsPlayedAfterRead)
                @setCreated = isSet(@colorValue, @shapeValue, @numberValue)
                if @playerOnePlaying == 1 && @setCreated == 1
                    @points[0] = @points[0] + 1
                    puts 'That was a set, good job'
                    @playerOnePlaying = 0
                elsif @playerOnePlaying == 0 && @setCreated == 1
                    @points[1] = @points[1] + 1
                    puts 'That was a set, good job'
                    @playerOnePlaying = 1
                else
                    puts 'That was not a set, better luck next time'
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
        while @charCounter < @charLength
            @curChar = charsInput[@charCounter]
            if @curChar == ' '
                @cardCounter = @cardCounter + 1
            elsif @cardsPlayed[@cardCounter] == nil
                @curChar = @curChar.to_i
                @cardsPlayed[@cardCounter] = 0
                @cardsPlayed[@cardCounter] = @cardsPlayed[@cardCounter] + @curChar
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
        @duplicateColorVal = 0
        @duplicateShapeVal = 0
        @duplicateNumberVal = 0
        @firstColor = colorArr[0]
        @firstShape = shapeArr[0]
        @firstNumber = numberArr[0]
        @setCounter = 1
        @setLength = colorArr.length
        @setInArrs = 1
        @innerCounter = 1
        @outerCounter = 0
        while @outerCounter < @setLength - 1
            while @innerCounter < @setLength
                if colorArr[@outerCounter] == colorArr[@innerCounter]
                    @duplicateColorVal = 1
                end
                if shapeArr[@outerCounter] == shapeArr[@innerCounter]
                    @duplicateShapeVal = 1
                end
                if numberArr[@outerCounter] == numberArr[@innerCounter]
                    @duplicateNumberVal = 1
                end
                @innerCounter = @innerCounter + 1
            end
            @outerCounter = @outerCounter + 1
        end
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
            @setCounter = @setCounter + 1
        end
        if @colorSet == 0 && @numberSet == 0 && @shapeSet == 0
            @setInArrs = 0
        elsif @duplicateColorVal + @duplicateNumberVal + @duplicateShapeVal >= 2
            @setInArrs = 0
        end
        @setInArrs
    end

    #Will print the end message for the users to know who won the game with a final score-board
    # param: pointsEarned -> player1 points [0], player2 points [1]
    def end_message(pointsEarned)
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
