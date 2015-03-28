class EscapeGame
	attr_accessor :drawer_is_open, :glassbox_is_open, :keybox_is_open, :circuitbox_is_open, :gloves_are_on, :floor_is_wet, :horror_in_room
	attr_accessor :gloves, :mop, :knife, :door, :desk, :drawer, :pen, :paper, :key, :glassbox, :circuitbox, :horror, :turns_remain
	attr_reader :object_hash

	def initialize
		@drawer_is_open = false
		@glassbox_is_open = false
		@keybox_is_open = false
		@circuitbox_is_open = false
		@floor_is_wet = true
		@horror_in_room = false
		@turns_remain = 10;

		populate_objects
		populate_obj_hash
	end

	def populate_obj_hash
		@object_hash = {
			"gloves" => @gloves, "mop" => @mop, "knife" => @knife, "door" => @door, "desk" => @desk, "drawer" => @drawer, 
			"pen" => @pen, "paper" => @paper, "key" => @key, "glassbox" => @glassbox, "circuitbox" => @circuitbox
		}
	end

	def populate_objects
		@gloves = Gloves.new
		@mop = Mop.new
		@knife = Knife.new
		@door = Door.new
		@desk = Desk.new
		@drawer = Drawer.new
		@pen = Pen.new
		@paper = Paper.new
		@key = Key.new
		@glassbox = Glassbox.new
		@circuitbox = Circuitbox.new
		@horror = Horror.new
	end

	def action(act, object, game)

		act.downcase!

		case act
			when "get", "take", "use", "open", "wear", "equip", "inspect", "search"
			else
				puts "I'm sorry, I don't recognize that action."
				return
		end

		object.downcase!

		case object
			when "gloves", "mop", "knife", "door", "desk", "drawer", "pen", "paper", "key", "glassbox", "circuitbox", "horror"
			when "rubber gloves" 
				object = "gloves"
			when "desk drawer" 
				object = "drawer"
			when "glass box" 
				object = "glassbox"
			when "circuit box" 
				object = "circuitbox"
			when "box"
				puts "Which box are you referring to?"
				box = gets.chomp
				box.downcase!
				if box == "glass" || box == "glass box"
					object = "glassbox"
				elsif box == "circuit" || box == "circuit box"
					object = "circuitbox"					
				else
					puts "I'm sorry, I don't recognize that box."
					return
				end
			when "nameless horror"
				object = "horror"
			else
				puts "I'm sorry, I don't recognize that object."
				return
		end

		
		@object_hash[object].send(act, game)
		game.turns_remain -= 1


	end
end

# class Player
	
# 	attr_accessor :inventory, :equipped

# 	def initialize
# 		@inventory = []
# 		@equipped = []
# 	end

# end


class EG_Object

	attr_accessor :has_moved, :is_equipped

	def initialize
		@has_moved = false
		@is_equipped = false
	end
	
	def get(game)
		puts "You can't get that."
	end

	def take(game)
		puts "You can't take that."
	end

	def use(game)
		puts "You can't use that."
	end

	def open(game)
		puts "You can't open that."
	end

	def wear(game)
		puts "You can't wear that."
	end

	def equip(game)
		puts "You can't equip that."
	end
	
	def inspect(game)
		puts "You don't see anything of interest."
	end

	def search(game)
		puts "You don't find anything."
	end

end

# VARIOUS EG_Object SUBCLASSES:

class Gloves < EG_Object
	def get(game)
		if @has_moved == true
			puts "You're already wearing the rubber gloves."
		elsif game.glassbox_is_open == false
			puts "You can't get to the gloves. The glass box is closed."
		else
			@is_equipped = true
			game.gloves_are_on = true
			puts "You put on the rubber gloves."
		end
	end

	def take(game)
		get(game)
	end

	def use(game)
		get(game)
	end

	def wear(game)
		get(game)
	end

	def equip(game)
		get(game)
	end

	def inspect(game)
		puts "The gloves are yellow and appear to made entirely of a reasonably thick rubber. 
		They look like a well made, pricy, pair of dishwashing gloves."
	end
	
end

class Mop < EG_Object
	def get(game)
		if @is_equipped == true
			puts "You already have the mop."
		else
			@is_equipped = true
			puts "You are now holding the mop."
		end
	end

	def take(game)
		get(game)
	end

	def use(game)
		if is_equipped == true
			puts "What would you like to use the mop on?"
			mop_what = gets.chomp
			if mop_what == "water" || mop_what == "puddle" || mop_what == "floor"
				if game.floor_is_wet && !game.gloves_are_on
					puts "When you touch the mop to the puddle you feel a considerable electic shock that blows you back away from the puddle and the door."
				else
					game.floor_is_wet == false
					puts "This fantastic state-of-the-art mop has left the floor completely dry."
				end
			elsif mop_what == "horror" || mop_what == "nameless horror"
				if game.horror_in_room == true 
					if game.horror.is_staggered == false
						puts "You swing the heavy handled mop at the nameless horror. It staggers back a few steps mildly stunned."
						game.turns_remain += 2
					else
						puts "The horror ignores additional attacks with the mop."
					end
					else
						puts "The nameless horror isn't in the room with you."
				end
			else
				puts "This fantastic mop has left the #{mop_what} perfectly dry. Although it was probably pretty dry to begin with."
			end
		else
			puts "You don't have the mop."
		end

	end

	def equip(game)
		get(game)
	end

	def inspect(game)
		puts "This is a very impressive mop. It has a strong metal handle and what appears to be a very modern mop head. This mop is so good that if you place it in a damp basement you could throw out the humidifier."
	end
end

class Knife < EG_Object
	def get(game)
		if @has_moved == true
			puts "You already have the knife."
		elsif game.glassbox_is_open == false
			puts "You can't get to the gloves. The glass box is closed."
		else
			@is_equipped = true
			game.gloves_are_on = true
			puts "You put on the rubber gloves."
		end
	end

	def take(game)
		get(game)
	end

	def use(game)
		puts "What would you like to use the knife on?"
		input = gets.chomp
		input.downcase!
		case input
		when "glass box", "glassbox"
			
		end
	end

	def wear(game)
		get(game)
	end

	def equip(game)
		get(game)
	end

	def inspect(game)
		puts "The gloves are yellow and appear to made entirely of a reasonably thick rubber. 
		They look like a well made, pricy, pair of dishwashing gloves."
	end
end

class Door < EG_Object
	
end

class Desk < EG_Object
	
end

class Drawer < EG_Object
	
end

class Pen < EG_Object
	
end

class Paper < EG_Object
	
end

class Key < EG_Object
	
end

class Glassbox < EG_Object
	
end

class Circuitbox < EG_Object
	
end

class Horror < EG_Object
	attr_accessor :is_staggered, :is_stabbed
end



game = EscapeGame.new

while true
	get_input = gets.chomp
	input_array = get_input.split(" ")
	act = input_array[0]
	object = input_array[1]
	game.action(act, object, game)
end





