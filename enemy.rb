require_relative("./entity.rb")

class Enemy < Entity
    def initialize(x, y, width, height, window, collides_with)
        super
        @enemy = Gosu::Image.new("./images/enemy.png")
        @x_vel = 3
        @flipped = 1
    end

    def collide_with(entity, direction)
		if entity.class == Platform
            @falling = false
        else
            @falling = true
        end
		# end
	end

    def update
        if @x >= @window.width - @enemy.width    
            @x = @window.width - @enemy.width
            @x_vel *= -1
            @flipped *= -1
        elsif @x <= 0      #bounces enemy back the other way when it hits the x-axis boundaries
            @x = 0
            @x_vel *= -1
            @flipped *= -1
        end
        
        @x += @x_vel
    end

    def draw
        @enemy.draw(@flipped < 0 ? @x + @enemy.width : @x, @y, 0, @flipped, 1.0)
    end
end

class BigEnemy < Enemy
    def initialize
        super
    end

    def draw
    end
end