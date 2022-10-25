class Mastermind
  @@DIGITS = ['1', '2', '3', '4', '5', '6']
  @@reduced_code
  @@start = true

  attr_accessor :player_guess, :code, :start, :guesses_remaining, :correct_digits, :reduced_code, :guess_hint

  def initialize 
    @code = get_random_code
    #@player_guess
    @guesses_remaining = 12
    @computer_guesses = []
    @correct_digits = []
    @@reduced_code = @code.clone
  end

  def get_random_code
    random_code = []
    (1..4).each {random_code.push(@@DIGITS.sample)}
    return random_code
  end

  def get_player_guess
    puts "Enter guess (no spaces) (enter 'quit' to give up):"

    loop do
      @player_guess = gets.chomp.split("")
      unless @player_guess.length == 4 && @player_guess.all? {|c| c.to_i.between?(1,6)} || @player_guess.join.downcase == "quit"
        puts "Invalid response, please guess a 4 digit code using only numbers 1-6 (no spaces)"
      else
        break
      end
    end
    @player_guess
  end

  def get_player_code
    puts "Please enter a secret code for the computer to guess (or enter 'quit' to end): "

    loop do
      @code = gets.chomp.split("")
      unless @code.length == 4 && @code.all? {|c| c.to_i.between?(1,6)} || @code.join.downcase == "quit"
        puts "Invalid input, please make a 4 digit code using only numbers 1-6 (no spaces)"
      else
        break
      end
    end
    @@reduced_code = @code.clone
  end

  def correct_c_and_p # digit and position are both correct
    n_correct = 0
    @player_guess.each_with_index do |digit, i|
      if digit == @code[i]
        n_correct += 1
        @@reduced_code[i] = 0
      end
    end
    return n_correct
  end

  def correct_c_only # only digit is correct, not position
    n_correct = 0
    @player_guess.each_with_index do |digit, i|
      if @@reduced_code[i] != 0 && @@reduced_code.any?(digit)
        n_correct += 1
        @@reduced_code[@@reduced_code.find_index(digit)] = ""
      end
    end
    return n_correct
  end

  def get_guess_hint # return the [num correct DIGITS in correct position, num correct DIGITS in wrong position]
    hint = [correct_c_and_p, correct_c_only]
    @@reduced_code = @code.clone
    return hint
  end

  def self.intro_screen
    puts "\nGuess the secret 4 digit code! (only using DIGITS 1 to 6)"
    puts "After each guess, you will get a hint about: "
    puts "[number of correct digits in the correct position, number of correct digits in the incorrect position]"
  end

  def play_round (guesser, guess = nil, round_n = nil)
    puts "\nGuesses remaining: #{@guesses_remaining}"
    guess = self.get_player_guess if guesser == "P"
    @player_guess = guess
    @guess_hint = get_guess_hint
    return -1 if guess.join.downcase == "quit" || @code.join.downcase == "quit"
    if guesser == "C"
      puts "Computer guessed: #{@player_guess.join}"
      if @correct_digits.length < 4
        @guess_hint.sum.times { @correct_digits.push(round_n.to_s) }
        (4 - @correct_digits.length).times { @correct_digits.push("6") } if round_n == 5
        if @correct_digits.length == 4
          sleep 1
          puts "Hint: #{@guess_hint}"
          sleep 1
          @guesses_remaining -= 1
          return -1
        end
      else
        @computer_guesses.push(@correct_digits.dup)
        @correct_digits.insert(@guess_hint[0], @correct_digits[3]).pop
        @correct_digits.shuffle! while @computer_guesses.any?(@correct_digits)
      end
    end
    sleep 1
    puts "Hint: #{@guess_hint}"
    sleep 1
    return -1 if @guess_hint[0] == 4

    @guesses_remaining -= 1
    return -1 if @guesses_remaining.zero?
  end

  def self.set_start
    @@start = false
    @@start = true if ["y", "yes"].any?(gets.chomp.downcase)
  end

  def self.start
    @@start
  end
end

Mastermind.intro_screen

while Mastermind.start
  game = Mastermind.new

  puts "\nWould you like to make or guess the code? [Enter 1 for make, 2 for guess]"
  game_mode = gets.chomp
  while !(game_mode.to_i.between?(1, 2))
    puts "Invalid input, please enter '1' for make or '2' for guess"
    game_mode = gets.chomp
  end

  if game_mode == "2"
    12.times do
      round = game.play_round("P")
      break if round == -1
    end
  elsif game_mode == "1"
    game.get_player_code
    (1..5).each do |i|
      round = game.play_round("C", Array.new(4, i.to_s), i)
      break if round == -1
    end
    unless game.guess_hint[0] == 4
      loop do
        round = game.play_round("C", game.correct_digits)
        break if round == -1
      end
    end
  end

  puts "\nGuesser wins!" if game.guesses_remaining.positive? && game.guess_hint[0] == 4
  puts "\nGuesser loses." if game.guesses_remaining.zero?
  puts "The code was #{game.code.join}" if game.code.join.downcase != "quit"
  puts "Play again? [y/n]"
  Mastermind.set_start
end



