class EscapeGame
	attr_accessor :floor_is_wet
	attr_accessor :gloves, :mop, :knife, :door, :desk, :pen, :paper, :puzzlebox, :key, :glassbox, :circuitbox, :horror, :turns_remain
	attr_reader :object_hash

	def initialize
		
		@floor_is_wet = true
		@turns_remain = 10;

		populate_objects
		populate_obj_hash
	end

	def populate_obj_hash
		@object_hash = {
			"gloves" => @gloves, "mop" => @mop, "knife" => @knife, "door" => @door, "desk" => @desk, "pen" => @pen, 
			"paper" => @paper, "key" => @key, "glassbox" => @glassbox, "circuitbox" => @circuitbox, "puzzlebox" => @puzzlebox
		}
	end

	def populate_objects
		@gloves = Gloves.new
		@mop = Mop.new
		@knife = Knife.new
		@door = Door.new
		@desk = Desk.new
		@pen = Pen.new
		@paper = Paper.new
		@puzzlebox = Puzzlebox.new
		@key = Key.new
		@glassbox = Glassbox.new
		@circuitbox = Circuitbox.new
		@horror = Horror.new
	end

	def test_status
		# puts @paper.is_equipped ? "paper equipped" : "paper not equipped"
		# puts @puzzlebox.is_equipped ? "puzzlebox equipped" : "puzzlebox not equipped"
		puts turns_remain.to_s
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
			when "gloves", "mop", "knife", "door", "desk", "pen", "paper", "key", "glassbox", "circuitbox", "puzzlebox", "horror"
			when "rubber gloves" 
				object = "gloves"
			when "desk drawer", "drawer"
				object = "desk"
			when "glass box" 
				object = "glassbox"
			when "circuit box" 
				object = "circuitbox"
			when "puzzle box", "puzzle", "key box"
				object = "puzzlebox"
			when "box"
				puts "Which box are you referring to?"
				box = gets.chomp
				box.downcase!
				if box == "glass" || box == "glass box"
					object = "glassbox"
				elsif box == "circuit" || box == "circuit box"
					object = "circuitbox"	
				elsif box == "puzzle" || box == "puzzle box"
					object == "puzzlebox"
				else
					puts "I'm sorry, I don't recognize that box."
					return
				end
			when "nameless horror"
				object = "horror"
			when object.nil? == true
				puts "Unless asked for clarification, always enter text in the form of: action object"
				puts "Where action and object are separated by a space."
				return
			else
				puts "I'm sorry, I don't recognize that object."
				return
		end
		
		puts action
		puts object

		if object.nil? == false
			@object_hash[object].send(act, game)
			game.turns_remain -= 1
		end
		
		test_status
	end

	def end_game
		puts "Exit room..."
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

	attr_accessor :is_equipped

	def initialize
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
		if game.glassbox.is_open == true
			if @is_equipped == true
				puts "You are already wearing the rubber gloves."
			else
				@is_equipped = true
				puts "You put on the rubber gloves."
			end
		else
			puts "You can't get to the gloves. They are still locked in the glass box."
			
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
			case mop_what
			when "water", "puddle", "floor"
				if game.floor_is_wet && !game.gloves.is_equipped
					puts "When you touch the mop to the puddle you feel a considerable electic shock that blows you back away from the puddle and the door."
				else
					game.floor_is_wet == false
					puts "This fantastic state-of-the-art mop has left the floor completely dry."
				end
			when "glassbox", "glass box", "box"
				if mop_what == "box"
					puts "Which box would you like to use the mop on?"
					which_box = gets.chomp
					if which_box == "glass" || which_box == "glass box" || which_box == "glassbox"
						if game.glassbox.is_open == true
							puts "The glass box is already open."
							puts game.gloves.is_equipped ? "There is nothing else in the box." : "The rubber gloves are in the glass box."
						else
							game.glassbox.is_open = true
							puts "You smash open the glass box with the heavy metal handle of the mop. The rubber gloves inside have some glass on them but are undamaged."
						end
					end
				end
			when "horror", "nameless horror"
				if game.horror.in_room == true 
					if game.horror.is_staggered == false
						puts "You swing the heavy handled mop at the nameless horror. It staggers back a few steps mildly stunned."
						game.turns_remain += 2
					else
						puts "The horror ignores additional attacks with the mop."
					end
					else
						puts "The nameless horror isn't in the room with you."
				end
			when "door", "doorhandle", "door handle", "jamb", "door jamb"
				puts "You swing the mop handle at the door. Other than some knicks and scratches the door is unaffected."
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
		if game.desk.is_open == true
			if game.knife.is_equipped == false
				@is_equipped =true
				puts "You now have the knife."
			else
				puts "You already have the knife."
			end
		else
			puts "You don't see a knife in the room."
		end
	end

	def take(game)
		get(game)
	end

	def use(game)
		if @is_equipped == true
			puts "What would you like to use the knife on?"
			input = gets.chomp
			input.downcase!
			case input
			when "circuit box", "circuitbox"
				if game.circuitbox.is_open == false
					game.circuitbox.is_open = true
					puts "You stick the knife behind the edge of the door and manage to pry it open."
				else
					puts "You jab the knife in the open circuit box. You manage to scratch it up a bit."
				end
			when "box"
				puts "Which box would you like to use the knife on?"
				which_box = gets.chomp
				which_box.downcase!
				if which_box == "circuitbox" || which_box == "circuit box" || which_box == "circuit"
					if game.circuitbox.is_open == false
						game.circuitbox.is_open = true
						puts "You stick the knife behind the edge of the door and manage to pry it open."
					else
						puts "You jab the knife in the open circuit box. You manage to scratch it up a bit."
					end
				else
					puts "Using the knife on that succeeds in nothing more than creating some scratches."
				end
			when "horror", "nameless horror"
				if game.horror.in_room == true 
					if game.horror.is_stabbed == false
						puts "You stab the nameless horror and it jumps back away from you granting you a quick moment of safety."
						game.turns_remain += 2
					else
						puts "The horror is ready for your knife attack and parries it with ease."
					end
					else
						puts "The nameless horror isn't in the room with you."
				end
			else
				puts "Using the knife on that succeeds in nothing more than creating some scratches."
			end
		else
			puts "You don't have the knife."
		end
	end

	def wear(game)
		get(game)
	end

	def equip(game)
		get(game)
	end

	def inspect(game)
		puts "The knife is sufficiently sharp, has an weathered ivory handle and a 4 inch blade."
	end
end

class Door < EG_Object
	attr_accessor :is_locked

	def initialize
		@is_locked = true
	end

	def open(game)
		if @is_locked
			if game.floor_is_wet && game.circuitbox.outlets_on
				puts "When your bare feet touch the water on the floor as you go to the door you are jolted by an electric shock and thrown back away from the door."
			else
				puts "You try the handle but the door is locked."
			end
		else
			puts "The unlocked doorhandle turns and you open the door."
			game.end_game
		end
	end

	def use(game)
		open(game)
	end

	def inspect
		puts "This is an old style door made of solid wood that won't break easily. The door jamb also appears to be constructed of quality materials that will withstand considerable punishment. There is a keyhole below the doorhandle."
	end
end

class Desk < EG_Object
	attr_accessor :is_open

	def initializer
		@is_open = false
	end

	def open(game)
		if @is_open == true
			puts "The desk drawer is already open."
		else
			@is_open = true
			puts "You open the desk drawer. Inside you see a pen and a knife with an ivory handle and 4 inch blade."
		end
	end

	def use(game)
		open(game)
	end

	def inspect(game)
		description = "This is a beautiful mohagany desk that has been very well taken care of. "
		if game.paper.is_equipped == false
			description << "There is a blank piece of paper on top of the desk. "
		end
		if game.puzzlebox.is_equipped == false
			description << "There is a puzzle box on top of the desk. "
		end
		if @is_open == true
			description << "There is an open drawer in the front of the desk. "
			if game.pen.is_equipped == false
				description << "There is a pen in the drawer. "
			end
			if game.knife.is_equipped == false
				description << "There is an ivory handled 4 inch knife in the drawer. "
			end
		else
			description << "There is a closed drawer in the front of the desk."
		end
		puts description
	end

	def search(game)
		inspect(game)
	end
end

class Pen < EG_Object
	def get(game)
		if game.desk.is_open == true
			if @is_equipped == true
				puts "You already have the pen."
			else
				@is_equipped = true
				puts "You take the pen."
			end
		else
			puts "You don't see a pen in the room."
		end
	end

	def take(game)
		get(game)
	end

	def use(game)
		if @is_equipped == true
			puts "What would you like to use the pen on?"
			input = gets.chomp
			if input == "paper" || input == "blank paper"
				puts "What would you like to write on the paper?"
				game.paper.writing << gets.chomp << " "
				puts "You wrote on the paper."
			else
				puts "You scribble on the #{input}"
			end
		else
			puts "You don't have the pen."
		end
			
	end

	def equip(game)
		get(game)
	end

	def inspect(game)
		if game.desk.is_open
			puts "This is a fairly expensive but tasteful refillable ball point pen."
		else
			puts "You don't see a pen in the room."
		end
	end
end

class Paper < EG_Object
	attr_accessor :writing

	def initialize
		super
		@writing = ""
	end

	def get(game)
		if @is_equipped == "true"
			puts "You already have the piece of paper."
		else
			@is_equipped = true
			puts "You now have a blank piece of paper."
		end
	end

	def take(game)
		get(game)
	end

	def use(game)
		puts "What would you like to use the paper with?"
		use_with = gets.chomp
		use_with.downcase!
		if use_with == "pen" || use_with == "ballpoint pen" || use_with == "ball point pen"
			if game.pen.is_equipped == true
				puts "What would you like to write on the paper?"
				@writing << gets.chomp << " "
			else
				puts "You don't have the pen."
			end
		else
			puts "You can't use paper with #{use_with}"
		end
	end

	def equip(game)
		get(game)
	end

	def inspect(game)
		if @writing.length == 0
			puts "It is a blank piece of 28lb bright white paper. Probably from Staples."
		else
			puts "On this paper you have written: " << @writing
		end
	end

	def search(game)
		inspect(game)
	end
end

class Puzzlebox < EG_Object
	attr_accessor :is_open, :solution

	def initialize
		super
		@is_open = false
		@solution = "QUEEN"
	end

	def get(game)
		@is_equipped = true
		puts "You take the puzzle box."
	end

	def take(game)
		get(game)
	end

	def use(game)
		puts "The puzzle box can't be opened but there is no lock. \nOn the top of the box is a picture of a key and five buttons. \nEach button has a letter printed on it as follows:"
		puts "E  U  N  E  Q"
		puts "Enter the order you press the buttons:"
		entry = gets.chomp
		entry.tr!(' ,.;:()[]{}"\'', '').upcase!
		if entry.length < 5
			puts "You enter '#{entry} but the box fails to open."
		else
			if entry == solution
				@is_open = true
				puts "You enter #{entry}. The box emits a click and then opens. Inside you see a key."
			else
				puts "You enter '#{entry} but the box fails to open."
			end
		end
	end
end

class Key < EG_Object
	
end

class Glassbox < EG_Object
	attr_accessor :is_open

	def initialize
		is_open = false
	end
end

class Circuitbox < EG_Object
	attr_accessor :is_open, :lights_on, :outlets_on

	def initialize
		@is_open = false
		@lights_on = true
		@outlets_on = true
		
	end
end

class Horror < EG_Object
	attr_accessor :in_room, :is_staggered, :is_stabbed

	def initialize
		@in_room = false
		@is_staggered = false
		@is_stabbed = false

		
	end
end



game = EscapeGame.new

while true
	get_input = gets.chomp
	input_array = get_input.split(" ")
	if input_array.length >= 2
		act = input_array[0]
		object = input_array[1]
		game.action(act, object, game)
	else
		puts "Please enter commands in the form of: action object"
		puts "Where ACTION and OBJECT are separated by a space."
	end
	
end





