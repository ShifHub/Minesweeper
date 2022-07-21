require_relative 'board.rb'

class Game 
    def initialize()
        size, difficulty = board_settings
        @board = Board.new(size, difficulty)
        play
    end

    def board_settings()
        puts "Welcome to my take on Mine Sweeper!!"
        puts "Lets get started!"
        sleep(2)
        system("clear")
        #size
        # puts "Chose the size of your board by its length"
        # puts "Chose a number between 9, and 50"
        # size = gets.chomp.to_i
        # until size > 8 && size < 51
             size = 9 #gets.chomp.to_i
        # end
        puts "Great!"
        sleep(1)
        system("clear")
        #difficulty
        # puts "Chose your difficulty!"
        # puts "Type: 'easy', 'medium', or 'hard'"
        # difficulty = gets.chomp.downcase
        # until difficultys.include?(difficulty)
            difficulty = "easy" #gets.chomp.downcase
        # end
        puts "Let the games begin!!"
        sleep(1.5)
        system("clear")
        return [size, difficulty]
    end

    def play()
        until @board.game_over?
            @board.display
            x, y = get_guess
            if user_to_flag?
                @board.flag_tile(x, y)
            else
                @board.reveal_tile(x, y)
            end
        end
        puts "GAME OVER!! Try again!"
    end

    def user_to_flag?
        puts "Would you like to reveal the square or flag it?"
        puts "Enter 'R' to reveal, or 'F' to flag and/or unflag"
        answer = gets.chomp.downcase
        until answer.length == 1 && ['r', 'f'].include?(answer)
            answer = gets.chomp.downcase
        end

        case answer
        when 'f'
            true
        when 'r'
            false
        end
    end
    
    def get_guess()
        guess = ask_pos
        until guess.length == 2 && good_guess?(guess)
            guess = ask_pos
        end 
        guess[0], guess[1] = guess[0].to_i, guess[1].to_i
        guess
    end

    def ask_pos()
        puts "Choose a row, and a column"
        puts "seperate the numbers with a comma"
        puts "Ex: '0,0'"
        guess = gets.chomp.gsub(/\s+/, "").split(",")
    end

    def good_guess?(arr)
        arr[0].match?(/\A-?\d+\Z/) && arr[1].match?(/\A-?\d+\Z/)
    end


end

game = Game.new()