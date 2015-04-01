class EscapeGame
	attr_accessor :floor_is_wet
	attr_accessor :gloves, :mop, :knife, :door, :desk, :pen, :paper, :puzzlebox, :key, :glassbox, :circuitbox, :outlet, :horror, :turns_remain, :end_count, :game_over

	attr_reader :object_hash

	def initialize
		
		@floor_is_wet = true
		@turns_remain = 10
		@game_over = false
		@end_count = 0

		populate_objects
		populate_obj_hash
		open_story
		print_help
		run_game
	end

	def populate_obj_hash
		@object_hash = {
			"gloves" => @gloves, "mop" => @mop, "knife" => @knife, "door" => @door, "desk" => @desk, "pen" => @pen, 
			"paper" => @paper, "key" => @key, "glassbox" => @glassbox, "circuitbox" => @circuitbox, "outlet" => @outlet, "puzzlebox" => @puzzlebox, "horror" => @horror
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
		@outlet = Outlet.new
		@horror = Horror.new
	end

	def test_status
		# puts @paper.is_equipped ? "paper equipped" : "paper not equipped"
		# puts @puzzlebox.is_equipped ? "puzzlebox equipped" : "puzzlebox not equipped"
		# puts @floor_is_wet ? "floor is wet" : "floor is dry"
		# puts @circuitbox.outlets_on ? "outlets on" : "outlets off"
		puts turns_remain.to_s
	end

	def run_game

		while true # This will change to @turns_remain > 0 && @game_over == false
			if game_over == true || turns_remain <= 0
				game_over = true
				break
			end
			puts game_over ? "game_over = true" : "game_over = false"
			get_input = gets.chomp
			input_array = get_input.split(" ")
			print_help if get_input.downcase == "help"
			next if get_input.downcase == "help"
			if input_array.length >= 2
				act = input_array[0]
				object = input_array[1]
				action(act, object, self)
				@horror.move(self)
			else
				puts "Please enter commands in the form of: action object"
				puts "Where ACTION and OBJECT are separated by a space."
			end
			
		end
		end_game
	end
		
	def print_help
		puts "help."
	end

	def open_story
		puts "story opening"
	end

	def describe_room
		puts "describe room"
	end

	def action(act, object, game)
		puts ""
		act.downcase!

		case act
			when "get", "take", "use", "open", "wear", "equip", "inspect", "search"
			else
				puts "I'm sorry, I don't recognize that action."
				return
		end

		object.downcase!

		case object
			when "gloves", "mop", "knife", "door", "desk", "pen", "paper", "key", "glassbox", "circuitbox", "puzzlebox", "horror", "outlet"
			when "rubber gloves" 
				object = "gloves"
			when "desk drawer", "drawer"
				object = "desk"
			when "glass box", "glass"
				object = "glassbox"
			when "circuit box", "circuit"
				object = "circuitbox"
			when "puzzle box", "puzzle"
				object = "puzzlebox"
			when "box"
				puts "Which box are you referring to?"
				box = gets.chomp
				box.downcase!
				if box == "glass" || box == "glass box"
					object = "glassbox"
				elsif box == "circuit" || box == "circuit box"
					object = "circuitbox"
				elsif box == "puzzle" || box == "puzzle box" || box == "puzzlebox"
					object = "puzzlebox"
				else
					puts "I'm sorry, I don't recognize that box."
					return
				end
			when "nameless horror"
				object = "horror"
			when "game", "room"
				if act == "inspect" || act == "search"
					describe_room
					return # I don't want this to cost an action so it skips the rest of the method
				else
					puts "You can't do that with the room. "
				end
			else
				puts "I'm sorry, I don't recognize that object."
				return
		end

		
		@object_hash[object].send(act, game)
		if @horror.in_room == false
			@turns_remain -= 1
		else

		end



		test_status
	end

	def end_game

		puts "End game..."

		if @circuitbox.lights_on == false
			puts "Lights out ending."
		elsif @door.is_open == true
			puts "Door open ending."
		else
			puts "Out of turns ending."
		end

		# lights out ending
		# door open ending
		# no more turns ending

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
					game.floor_is_wet = false
					puts "This fantastic state-of-the-art mop has left the floor completely dry."
				end
			when "glassbox", "glass box", "box", "glass"
				if mop_what == "box"
					puts "Which box would you like to use the mop on?"
					which_box = gets.chomp
					if which_box == "glass" || which_box == "glass box" || which_box == "glassbox"
						# This is intended to just skip the rest of the elsifs and continue the method
					elsif which_box == "circuit" || which_box == "circuitbox" || which_box == "circuit box"
						puts "You stike the circuit box with the mop but nothing happens."
						return
					elsif which_box == "puzzle" || which_box == "puzzlebox" || which_box == "puzzle box"
						puts "You strike the puzzle box with the mop but nothing happens."
						return
					else
						puts "You don't see that kind of box in the room."
						return
					end
				end
				if game.glassbox.is_open == true
					puts "The glass box is already open so striking it with the mop would be pointless. It is also perfectly dry."
					puts game.gloves.is_equipped ? "There is nothing else in the box." : "The rubber gloves are in the glass box."
				else
					game.glassbox.is_open = true
					puts "You smash open the glass box with the heavy metal handle of the mop. The rubber gloves inside have some glass on them but are undamaged."
				end
			when "horror", "nameless horror"
				if game.horror.in_room == true 
					if game.horror.is_staggered == false
						puts "You swing the heavy handled mop at the nameless horror. It staggers back a few steps mildly stunned."
						game.end_count = 2
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
			when "circuit box", "circuitbox", "circuit"
				if game.circuitbox.is_open == false
					game.circuitbox.is_open = true
					puts "You stick the knife behind the edge of the door and manage to pry it open. Inside you see two circuit breakers. One is labelled 'Lights', the other 'Outlets'. They are both in the 'ON' position."
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
						puts "You stick the knife behind the edge of the door and manage to pry it open. Inside you see two circuit breakers. One is labelled 'Lights', the other 'Outlets'. They are both in the 'ON' position."
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
						game.end_count = 2
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
	attr_accessor :is_locked, :is_open

	def initialize
		@is_locked = true
		@is_open = false
	end

	def open(game)
		if @is_locked == true
			if game.floor_is_wet == true && game.circuitbox.outlets_on == true
				puts "When your bare feet touch the water on the floor as you go to the door you are jolted by an electric shock and thrown back away from the door."
			else
				puts "You try the handle but the door is locked."
			end
		else
			@is_open = true
			puts "The unlocked doorhandle turns and you open the door."
			game.game_over = true
		end
	end

	def use(game)
		open(game)
	end

	def inspect(game)
		puts "This is an old style door made of solid wood that won't break easily. The door jamb also appears to be constructed of quality materials that will withstand considerable punishment. There is a keyhole below the doorhandle."
		if @is_open == true
			puts "The door is open."
		elsif game.floor_is_wet && game.circuitbox.outlets_on == true
			puts "The door is closed but you have not been able to test to see if it is locked."
		else
			puts "The door is closed but unlocked."
		end
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
	attr_accessor :is_open
	attr_reader :solution

	def initialize
		super
		@is_open = false
		@solution = "QUEEN"
	end

	def get(game)
		if @is_equipped == false
			@is_equipped = true
			puts "You take the puzzle box."
		else
			puts "You already have the puzzle box."
		end
		
	end

	def take(game)
		get(game)
	end

	def use(game)
		if @is_open == false
			puts "The puzzle box can't be opened but there is no lock. \nOn the top of the box is a picture of a key and five buttons. \nEach button has a letter printed on it as follows:"
			puts "E  U  N  E  Q"
			puts "Enter the letters in the order you press them:"
			entry = gets.chomp
			entry.tr!(' ,.;:()[]{}"\'', '')
			entry.upcase!
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
		else
			puts "The puzzle box is already open."
		end
	end

	def open(game)
		use(game)
	end

	def equip(game)
		get(game)
	end

	def inspect(game)
		description = "This puzzle box has an image of a key and 5 buttons, each labelled with a letter, on the lid. The buttons, in order, are labelled: E U N E Q. "
		if @is_open == true
			
			description << "Having solved the puzzle, the lid is now open. "
			if game.key.is_equipped == true
				description << "You have taken the key that was in the box. There is nothing in here now. "
			else
				description << "There is a key inside the box. "
			end
		else
			description << "The box is locked shut."
		end
		puts description
	end

	def search(game)
		inspect(game)
	end
end

class Key < EG_Object
	def get(game)
		if @is_equipped == true
			puts "You already have the key."
		else
			if game.puzzlebox.is_open == true
				@is_equipped = true
				puts "You take the key from inside the box."
			else
				puts "You don't see a key in the room."
			end
		end
	end

	def take(game)
		get(game)
	end

	def use(game)
		if @is_equipped == true
			puts "What would you like to use the key on?"
			input = gets.chomp
			input.downcase!
			case input
			when "door"
				if game.door.is_locked == false
					puts "The door is already unlocked."
				else
					if game.floor_is_wet == true && game.circuitbox.outlets_on == true
						puts "When you step into the puddle to try the key in the door you recieve an electric shock and are knocked back away from the door."
					else
						game.door.is_locked = false
						puts "The key slides in the lock easily. You unlock the door."
					end
				end
			when "glass", "glassbox", "glass box", "box"
				if input == "box"
					puts "Which box would you like to use the key on?"
					which_box = gets.chomp
					if which_box == "glass" || which_box == "glass box" || which_box == "glassbox"
						# This is intended to just skip the rest of the elsifs and continue the method
					elsif which_box == "circuit" || which_box == "circuitbox" || which_box == "circuit box"
						puts "The circuit box doesn't have a lock to use a key on."
						return
					elsif which_box == "puzzle" || which_box == "puzzlebox" || which_box == "puzzle box"
						puts "The puzzle box doesn't have a keyed lock."
						return
					else
						puts "You don't see that kind of box in the room."
						return
					end
				end
				puts "The key doesn't fit in the glass box's lock."
			else
				puts "You can't use the key with that."
			end
		else
			puts "You don't have the key."
		end
	end

	def open(game)
		use(game)
	end

	def equip(game)
		get(game)
	end
	
	def inspect(game)
		puts "It's a pretty standard key. Made of metal, round head, grooves along the length, teeth along the bottom."
	end
end

class Glassbox < EG_Object
	attr_accessor :is_open

	def initialize
		@is_open = false
	end

	def get(game)
		puts "The glass box is embedded in he wall and can't be removed."
	end

	def take(game)
		get(game)
	end

	def use(game)
		if @is_open == false
			puts "The glass box is locked and securely attached to the wall."
		else
			puts "The glass box has been smashed open allowing access to its contents."
			if game.gloves.is_equipped == true
				puts "You have taken the rubber gloves that were in here."
			else
				puts "There is a pair of rubber gloves inside."
			end
		end
	end

	def open(game)
		use(game)
	end

	def inspect(game)
		puts "This is a 'glass box' embedded in the wall much like one you would see in many buildings containing emergency fire equipment. It has a metal door with a keyable lock. "
		if @is_open == false
			puts "A large portion of the door is made of glass, revealing the glass box's contents."
		else
			puts "The glass has been broken out of the door allowing access to the box. "
		end
		if game.gloves.is_equipped == true
			puts "You have taken the rubber gloves that were in here. There is nothing else in the box."
		else
			puts "There is a pair of yellow rubber gloves inside the box."
		end
	end

	def search(game)
		inspect(game)
	end
end

class Circuitbox < EG_Object
	attr_accessor :is_open, :lights_on, :outlets_on

	def initialize
		@is_open = false
		@lights_on = true
		@outlets_on = true
	end

	def use(game)
		if @is_open == true
			puts "There are two circuit breakers. One is labelled 'Lights', the other is labelled 'Outlets'. "
			if lights_on == true && outlets_on == true
				puts "Both breakers are set to the 'ON' position. "
			elsif lights_on == false && outlets_on == false
				puts "Both breakers are set to the 'OFF' position. "
			elsif lights_on == true && outlets_on == false
				puts "The lights breaker is set to on, the outlets breaker is set to off."
			else
				puts "The lights breaker is set to off, the outlets breaker is set to on."	
			end
			puts "Do you trip one of the breakers?"
			input = gets.chomp
			input.downcase!
			if input[0] == "y"
				puts "Break the lights or outlets?"
				which_circuit = gets.chomp
				which_circuit.downcase!
				if which_circuit == "lights"
					@lights_on = false
					puts "As you trip the breaker for the lights the box emits a considerable spark which blinds you as the lights go out. You take an involuntary step back. "
					if outlets_on == true
						puts "You step into the puddle which electifies you again. You can't see and you've lost your bearings."
					else
						puts "You can't see and you've lost your bearings. "
					end
					game.game_over = true
				elsif which_circuit == "outlets"
					if @outlets_on == true
						@outlets_on = false
						puts "You flip the breaker that claims to control the outlets. It is now in the 'OFF' position. "
					else
						@outlets_on = true
						puts "You flip the breaker controlling the outlets again. The power feeding the outlets should be on. "
					end
				else
					puts "You don't see a breaker with that label in the circuit box."
				end
			elsif input[0] == "n"
				puts "You leave the breakers alone."
			else
				puts "I'm going to take that as a no. You leave the breakers alone."
			end
		else
			puts "The circuit box door is closed. "
		end
	end

	def open(game)
		if @is_open == false
			puts "There is a small lip on the circuit box door that's used to open it but the door is very tight and your fingers can't get enough purchase to open it. You see many scratches worn into area next to the lip. "
		else
			puts "The circuit box door is already open."
		end
	end

	def inspect(game)
		description = "The circuit box is in the wall near the door. You don't have to step in the puddle to get to it. "
		if @is_open == false
			description << "The door to the circuit box is closed. On the right side of the door is a small lip intended to assist in opening the box. There are a lot of scratches in the wall immediately next to the lip. "
		else
			description << "The door to the circuit box is open, inside you see two circuit breakers. One is marked 'Lights', the other 'Outlets'. "
			if lights_on == true
				description << "The breaker for the lights is in the on position. "
			else
				description << "The breaker for the lights is in the off position. "
			end
			if outlets_on == true
				description << "The outlets breaker is #{"also " if lights_on == true}set to on. "
			else
				description << "The outlets breaker is #{"also " if lights_on == false}set to off. "
			end
		end
		puts description
	end
end

class Outlet < EG_Object
	def inspect(game)
		description = "The outlet is to the right of the door you want to exit through. The outlet no longer has plugs or a faceplate. All that's left are exposed wires which reach down far enough to touch the floor. "
		if game.floor_is_wet == true
			description << "The ends of the wires are sitting in the pool of water on the floor. "
		end
		if game.circuitbox.outlets_on == true
			description << "The wires appear to be live, which is evident because the wires spark periodically. "
		else
			description << "The wires are no longer sparking every few seconds, the power feeding them seems to have been successfully turned off. "
		end
		puts description
	end

	def search(game)
		inspect(game)
	end
end

class Horror < EG_Object
	attr_accessor :in_room, :is_staggered, :is_stabbed

	def initialize
		@in_room = false
		@is_staggered = false
		@is_stabbed = false
	end

	def move(game)
		if @in_room == false
			case game.turns_remain
			when condition
				
		end
	end
end



game = EscapeGame.new








