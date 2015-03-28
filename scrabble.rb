require 'rubygems'
require 'ruby-dictionary'

class Scrabble
  
  attr_reader :letter_scores, :dictionary
  attr_accessor :word_score
  
  def initialize
    @letter_scores = {
      "A"=>1, "B"=>3, "C"=>3, "D"=>2,
      "E"=>1, "F"=>4, "G"=>2, "H"=>4,
      "I"=>1, "J"=>8, "K"=>5, "L"=>1,
      "M"=>3, "N"=>1, "O"=>1, "P"=>3,
      "Q"=>10, "R"=>1, "S"=>1, "T"=>1,
      "U"=>1, "V"=>4, "W"=>4, "X"=>8,
      "Y"=>4, "Z"=>10
    }
    @dictionary = Dictionary.from_file('words.txt')
    @word_score = 0
    
  end
  
  def score(word)
    if @dictionary.exists?(word)
      word.upcase!
      word.split("").each {|letter|
        @word_score += @letter_scores[letter]
        }
      puts "\n#{word.capitalize} has a value of #{@word_score}.\n\n"
    else
      puts "\n'#{word.capitalize}' doesn't exist in the dictionary.\n\n"
    end
  end
end


puts "\n\n\n//////////   SCRABBLE SCORER!   \\\\\\\\\\\\\\\\\\\\ \n\n"
puts "Loading dictionary (I think), this may take a few seconds...\n\n"
game = Scrabble.new

while true
  puts "Please enter word to be scored (Leave blank and press ENTER to quit):"
  word = gets.chomp
  if word.length > 0
    game.score(word)
  else
    puts "Thanks for using Myster3's Scrabble\u00AE Scorer!\n\n"
    break
  end
end





