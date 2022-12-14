require_relative ("./entity.rb")

class Player < Entity
	def initialize(x,y,width,height,window,collides_with)
		super	
		@animation = [Gosu::Image.new("./images/frog1.png"), Gosu::Image.new("./images/frog2.png"), Gosu::Image.new("./images/frog3.png"), Gosu::Image.new("./images/frog4.png")]
		@player = @animation[0]
		@animation_index = 0
		@flipped = 1

		@x_vel = 0 
		@y_vel = 0
		@x = 0 
		@y = @window.height - @player.width

		@player_speed = 6
		@max_speed = 16
		@friction = 2

		@jump_height = 22
		@gravity = 2

		@dead = false
	end

	attr_reader :dead

	def collide_with(entity, direction)
		if entity.class == Enemy
			@dead = true
		end
	end

	def jump
		if @y == @window.height - @player.width
			@y_vel -= @jump_height
		end
	end

	def move_left
		@x_vel -= @player_speed
	end

	def jump_sound
		if @y == @window.height - @player.width
			#jump_sound = Gosu::Song::new("./audio/#{rand(1..4)}.mp3")
			#jump_sound.play
		end
	end

	def move_right
		@x_vel += @player_speed
	end

	def animate
		if @animation_index != 3 
			@animation_index += 1
		else
			@animation_index = 0 
		end

		@player = @animation[@animation_index]
	end

	def update
			#&& jump_sound
		jump if Gosu.button_down? Gosu::KB_UP
		move_left && animate && @flipped = -1.0 if Gosu.button_down? Gosu::KB_LEFT
		move_right && animate && @flipped = 1.0 if Gosu.button_down? Gosu::KB_RIGHT
		crash_lol if Gosu.button_down? Gosu::KB_C
		
		if @x_vel > 0
			@x_vel -= @friction
		elsif @x_vel < 0         #checks if player is going left or right
			@x_vel += @friction  #and decelerates each frame, basically friction for the x-axis
		end 

		if @x_vel > @max_speed
			@x_vel = @max_speed     #sets a max speed in both directions
		elsif @x_vel < @max_speed * -1
			@x_vel = @max_speed * -1
		end
		
		if !@on_platform
			@y_vel += @gravity         #gravity, basically... if the player is in the air, pull them down
		end

        if @x_vel == 0
            @player = @animation[0]
        end

		@x += @x_vel
		@y += @y_vel

		if @x >= @window.width - @player.width    
			@x = @window.width - @player.width
		elsif @x <= 0      #keeps player within the x-axis boundaries
			@x = 0
		end

		if @y >= @window.height-@player.width && @y_vel > 0 #checks if you're on the ground and speeding downwards
            @y_vel = 0
			@y = @window.height-@player.width
		end

	end

	# b ? x : y
	# if b then x else y
	
	def draw
		@player.draw(@flipped < 0 ? @x + @player.width : @x, @y, 0, @flipped, 1.0)
	end
end