class Mastermind
  @@DIGITS = ["1", "2", "3", "4", "5", "6"]
  @@reduced_computer_code
  @@start = false

  attr_accessor :player_guess, :computer_code, :start

  def initialize 
    @computer_code = get_random_code
    @player_guess
    @@reduced_computer_code = @computer_code.clone
  end

  def get_random_code
    random_code = []
    (1..4).each {random_code.push(@@DIGITS.sample)}
    return random_code
  end

  def get_player_guess
    puts "Enter guess (no spaces):"

    loop do
      @player_guess = gets.chomp.downcase.split("")
      unless @player_guess.length == 4 && @player_guess.all? {|c| c.to_i.between?(1,6)}
        puts "Invalid response, please guess a 4 digit code using DIGITS 1-6 (no spaces)"
      else
        break
      end
    end

  end

  def correct_c_and_p # digit and position are both correct
    n_correct = 0
    @player_guess.each_with_index do |digit, i|
      if digit == @computer_code[i]
        n_correct += 1 
        @@reduced_computer_code[i] = 0
      end
    end
    return n_correct
  end

  def correct_c_only # only digit is correct, not position
    n_correct = 0
    @player_guess.each_with_index do |digit, i|
      if @@reduced_computer_code[i] != 0 && @@reduced_computer_code.any?(digit)
        n_correct += 1
        @@reduced_computer_code[@@reduced_computer_code.find_index(digit)] = ""
      end
    end
    return n_correct
  end

  def get_guess_hint # return the [num correct DIGITS in correct position, num correct DIGITS in wrong position]
    hint = [correct_c_and_p, correct_c_only]
    @@reduced_computer_code = @computer_code.clone
    return hint
  end

  def self.intro_screen
    puts "\nGuess the secret 4 digit code! (only using DIGITS 1 to 6)"
    puts "After each guess, you will get a hint about: "
    puts "[number of correct digits in the correct position, number of correct digits in the incorrect position]"
    puts "Start? [y/n]"
    set_start
  end

  def self.set_start
    @@start = false
    @@start = true if gets.chomp.downcase == "y"
  end

  def self.start
    @@start
  end
  
end


Mastermind.intro_screen

while Mastermind.start
  game = Mastermind.new
  guesses_remaining = 12

  (0..11).each do
    puts "\nGuesses remaining: #{guesses_remaining}"
    game.get_player_guess
    guess_hint = game.get_guess_hint
    sleep 1
    puts "Hint: #{guess_hint}"
    sleep 1
    if guess_hint[0] == 4
      puts "\nYou win!"
      break
    end
    guesses_remaining -= 1
  end

  puts "\nYou lose." if guesses_remaining == 0
  puts "The code was #{game.computer_code.join}"
  puts "Play again? [y/n]"
  game.set_start
end




