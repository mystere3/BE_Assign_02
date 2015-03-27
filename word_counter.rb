def para_to_array(para)
  para.delete!("/.,!;:?()").downcase!
  word_array = para.split(' ')
  return word_array
end

def wordcount_hash(array)
  word_hash = Hash.new
  array.each{|word|
    if word_hash.has_key?(word)
      word_hash[word] += 1
    else
      word_hash[word] = 1
    end
    }
  return word_hash
end

def largest_hash_key(hash)
  hash.max_by{|k,v| v}
end

def get_max_word(para)
  word_array = para_to_array(para)
  word_hash = wordcount_hash(word_array)
  return largest_hash_key(word_hash)
end


puts "Enter paragraph to analyze: "
paragraph = gets.chomp
max_word = get_max_word(paragraph)


puts "The most frequent word was '#{max_word[0]}' which occured #{max_word[1]} time#{max_word[1] > 1 ? 's' : ''}."