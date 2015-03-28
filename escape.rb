class EscapeGame
	attr_accessor :drawer_is_open, :glassbox_is_open, :keybox_is_open, :circuitbox_is_open, :gloves_are_on, :floor_is_wet
	attr_accessor :gloves, :mop, :knife, :door, :desk, :drawer, :pen, :paper, :key, :glassbox, :circuitbox
	attr_reader :object_hash

	def initialize
		@drawer_is_open = false
		@glassbox_is_open = false
		@keybox_is_open = false
		@circuitbox_is_open = false
		@floor_is_wet = true

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
			when "gloves", "mop", "knife", "door", "desk", "drawer", "pen", "paper", "key", "glassbox", "circuitbox"
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
			else
				puts "I'm sorry, I don't recognize that object."
				return
		end

		
		@object_hash[object].send(act, game)
		# action_on_object = @object_hash[object].method(act)
		# action_on_object.call()


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
	
end

class Knife < EG_Object
	
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



game = EscapeGame.new

while true
	get_input = gets.chomp
	input_array = get_input.split(" ")
	act = input_array[0]
	object = input_array[1]
	game.action(act, object, game)
end





