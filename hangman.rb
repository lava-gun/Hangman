require 'yaml'

class Hangman
	def initialize
		content = File.open("5desk.txt", 'r'){|file| file.read}
		dictionary = content.split.select {|word| word.length.between?(5,12)}
		@word = dictionary[rand(dictionary.size)].downcase.split('')
		@display = Array.new(@word.length, '_')
		@misses = Array.new
		@turns = 6
	end

	def display
		print @display.join
		puts
		print @misses
		puts
		puts @turns
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
			puts "Enter a letter to guess (0 to quit)"
			letter = gets.chomp
			if (@misses.include?(letter) || @display.include?(letter) )
				puts "That letter has already been used! Guess again"
			elsif letter == "0"
				return nil
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

loop do
	greeting = %q(
		Welcome to Hangman!
		What would you like to do?
		1- New Game 
		0- Quit
		)
	puts greeting
	choice = gets.chomp.to_i
	if choice == 1
		new_game = Hangman.new
		new_game.play
	elsif choice == 0
		puts "Goodbye!"
		return nil
	end

end