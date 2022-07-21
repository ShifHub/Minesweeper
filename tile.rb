class Tile
    attr_reader :is_revealed, :adjacent_bomb_count

    def initialize(is_bomb = false)
        @is_bomb = is_bomb
        @adjacent_bomb_count = 0
        @is_revealed = false
        @is_flagged = false
    end

    def value
        @is_revealed ? @adjacent_bomb_count.to_s : @is_flagged ? "F" : "*"
    end

    def is_bomb?
        @is_bomb
    end

    def is_flagged?
        @is_flagged
    end

    def flag
        @is_flagged = true
    end

    def unflag
        @is_flagged = false
    end 

    def increment_adj_bomb_count
        @adjacent_bomb_count += 1
    end

    def set_to_bomb
        @is_bomb = true
    end

    def reveal
        @is_revealed = true
    end

    def dev_only_reveal_value
        if @is_flagged
            "F"
        elsif @is_bomb
            "X"
        else
            @adjacent_bomb_count.to_s
        end
    end

end