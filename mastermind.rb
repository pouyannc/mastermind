class Mastermind
  @@DIGITS = ['1', '2', '3', '4', '5', '6']
  @@reduced_computer_code
  @@start = false

  attr_accessor :player_guess, :computer_code, :start, :guesses_remaining, :correct_digits, :reduced_computer_code

  def initialize 
    @computer_code = get_random_code
    @player_guess
    @guesses_remaining = 12
    @correct_digits = []
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
      @player_guess = gets.chomp.split("")
      unless @player_guess.length == 4 && @player_guess.all? {|c| c.to_i.between?(1,6)}
        puts "Invalid response, please guess a 4 digit code using DIGITS 1-6 (no spaces)"
      else
        break
      end
    end
    @player_guess
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

  def play_round (guess, guesser, round_n = nil)
    puts "\nGuesses remaining: #{@guesses_remaining}"
    @player_guess = guess
    guess_hint = get_guess_hint
    if guesser == "C"
      puts "Computer guessed: #{@player_guess.join}"
      if @correct_digits.length < 4
        guess_hint.sum.times { @correct_digits.push(round_n.to_s) }
        (4 - @correct_digits.length).times { @correct_digits.push("6") } if round_n == 5
        if @correct_digits.length == 4
          @guesses_remaining -= 1
          return -1
        end
      else
        @correct_digits.insert(guess_hint[0], @correct_digits[3]).pop
      end
      p @correct_digits
    end
    sleep 1
    puts "Hint: #{guess_hint}"
    sleep 1
    return -1 if guess_hint[0] == 4

    @guesses_remaining -= 1
    return -1 if @guesses_remaining.zero?
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

  puts "Would you like to make or guess the code? [Enter 1 for make, 2 for guess]"
  game_mode = gets.chomp

  if game_mode == "2"
    12.times do
      round = game.play_round(game.get_player_guess, "P")
      break if round == -1
    end
  elsif game_mode == "1"
    (1..5).each do |i|
      round = game.play_round(Array.new(4, i.to_s), "C", i)
      break if round == -1
    end
    loop do
      round = game.play_round(game.correct_digits, "C")
      break if round == -1
    end
  end

  puts "\nYou win!" if game.guesses_remaining.positive?
  puts "\nYou lose." if game.guesses_remaining.zero?
  puts "The code was #{game.computer_code.join}"
  puts "Play again? [y/n]"
  Mastermind.set_start
end



