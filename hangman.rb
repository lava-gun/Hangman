require 'yaml'

class Hangman
	def initialize
		content = File.open("5desk.txt", 'r'){|file| file.read}
		dictionary = content.split.select {|word| word.length.between?(5,12)}
		@word = dictionary[rand(dictionary.size)].downcase.split('')
		@display = Array.new(@word.length, '_')
		@misses = Array.new
		@turns = 6
		print @display.join
		puts
	end

	def display
		print @display.join
		puts
		print "Misses: #{@misses}"
		puts
		puts "Number of incorrect guesses left: #{@turns}"
	end

	def guess(letter)
		if @word.include? letter
			@word.each_with_index do |character, index|
				if character == letter
					@display[index] = letter
					puts "That guess was correct!"
				end
			end
		else
			@misses <<letter
			puts "That guess was incorrect"
			@turns -= 1
		end
	end

	def win
		if @display == @word
			puts "You win!"
			return 1
		elsif @turns == 0
			puts "You lose!"
			puts "The word was #{@word}!"
			return -1
		else
			return 0
		end			
	end

	def play
		loop do 
			puts "Enter a letter to guess (0 to quit, 1 to save)"
			letter = gets.chomp
			if (@misses.include?(letter) || @display.include?(letter) )
				puts "That letter has already been used! Guess again"
			elsif letter == "0"
				return nil
			elsif letter == "1"
				save_game				
			else
				guess(letter)
			end
			last = win
			if last == 1
				return nil
			end
			if last == -1
				return nil
			end
			display
		end
	end
end

def save_game
		Dir.mkdir("save") unless Dir.exists? "save"
		filename = "save/save.yaml"
		temp = YAML.dump(self)
		File.open(filename, 'w') do |file|
			file.puts temp
		end
	end
def load_game
	content = File.open("save/save.yaml", 'r'){|file| file.read}
	YAML.load(content)
end


loop do
	greeting = %q(
		Welcome to Hangman!
		What would you like to do?
		0- Quit
		1- New Game 
		2- Load Game
		)
	puts greeting
	choice = gets.chomp.to_i
	if choice == 1
		new_game = Hangman.new
		new_game.play
	elsif choice == 0
		puts "Goodbye!"
		return nil
	elsif choice == 2
		new_game =load_game 
		new_game.display
		new_game.play
	end

end