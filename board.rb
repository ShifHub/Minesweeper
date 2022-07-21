require_relative 'tile.rb'
require 'byebug'
class Board
    def initialize(size = 9, difficulty = "easy")
        @size = size
        @grid = self.generate_board(size)
        generate_bombs(num_of_bombs_for(difficulty))
        @game_over = false
    end

    def display
        top_row = " "
        (0...@size).each { |n| top_row += " " + n.to_s }
        puts top_row
        columns = ""
        #TODO: fill columns with tiles
        (0...@size).each do |column| 
            columns += column.to_s 
            (0...@size).each do |row|
                columns += " " + @grid[row][column].dev_only_reveal_value
            end
            columns += "\n"
        end
        puts columns
    end

    def game_over?
        @game_over
    end

    def generate_board(size)
        @grid = empty_board()
    end

    def empty_board()
        rows = Array.new(@size) { Array.new(@size)}
        (0...@size).each do |row|
            (0...@size).each do |column|
                rows[row][column] = Tile.new
            end
        end
        rows
    end

    def flag_tile(x, y)
        @grid[x][y].is_flagged? ? @grid[x][y].unflag : @grid[x][y].flag
    end

    def reveal_tile(x, y)
        tile = @grid[x][y]
        if tile.is_bomb?
            @game_over = true
        elsif tile.is_flagged?
            puts "You cannot reveal a flagged tile! You must unflag first."
        else
            tile.reveal
            if tile.adjacent_bomb_count == 0
                adjacent_tiles([x, y]).each { |x, y| reveal_tile(x, y) unless bad_coordinates?(x, y) || (@grid[x][y].is_revealed || @grid[x][y].is_flagged?) }
            end 
        end
    end

    def generate_bombs(num)
        positions = []
        until positions.length >= num
            row, column = rand(0...@size), rand(0...@size)
            unless positions.include?([row, column])
                positions << [row, column]
            end
        end
        #Array of bomb positions available
        positions.each do |x, y|
            @grid[x][y].set_to_bomb
        end
        #Bombs set
        positions.each { |pos| increment_surrounding_tiles(pos) }
        #Adjacent tiles to bombs incremented
    end

    def num_of_bombs_for(difficulty)
        case difficulty
        when "easy"
            @size
        when "medium"
            @size * 2
        when "hard"
            @size * 3
        else 
            @size
        end
    end

    def increment_surrounding_tiles(pos)
    #Helper - generate_bombs()
        adjacent_tiles(pos).each do |x, y|
            @grid[x][y].increment_adj_bomb_count unless @grid[x] == nil || @grid[x][y] == nil
        end
    end

    def adjacent_tiles(pos)
        x, y = pos[0], pos[1]
        tiles_for_incr = []
        unless y == 0 
            tiles_for_incr += [[x, y - 1], [x + 1, y - 1]]
        end
        unless x == 0 
            tiles_for_incr += [[x - 1, y], [x - 1, y + 1]]
        end
        tiles_for_incr += [[x - 1, y - 1]] if x != 0 && y != 0
        tiles_for_incr += [[x, y + 1], [x + 1, y], [x + 1, y + 1]]
        return tiles_for_incr
    end

    def bad_coordinates?(x, y)
        @grid[x] == nil || @grid[x][y] == nil
    end
end
