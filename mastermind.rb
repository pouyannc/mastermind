# computer generates random 4 color code from 6 possible colors [g, b, r, y, o, p]
# player has 12 turns to guess correct code
# each turn return the number of correct guesses in correct spot and correct guesses in incorrect spot

class Mastermind
  @@COLORS = ["g", "b", "r", "y", "o", "p"]
  @@reduced_computer_code

  attr_accessor :player_guess, :computer_code

  def initialize 
    @computer_code = get_random_code
    @player_guess
    @@reduced_computer_code = @computer_code
  end

  def get_random_code
    random_code = []
    (1..4).each {random_code.push(@@COLORS.sample)}
    return random_code
  end

  def get_player_guess
    puts "Please enter your guess (first letter of color [cccc])"
    @player_guess = gets.chomp.downcase.split("")
  end

  def correct_c_and_p # color and position are both correct
    n_correct = 0
    @player_guess.each_with_index do |color, i|
      if color == @computer_code[i]
        n_correct += 1 
        @@reduced_computer_code[i] = 0
      end
    end
    return n_correct
  end

  def correct_c_only # only color is correct, not position
    n_correct = 0
    @player_guess.each_with_index do |color, i|
      if @@reduced_computer_code.any?(color)
        n_correct += 1
        @@reduced_computer_code[@@reduced_computer_code.find_index(color)] = 0
      end
    end
    return n_correct
  end

  def get_guess_response # return the [num correct colors in correct position, num correct colors in wrong position]
    response = [correct_c_and_p, correct_c_only]
    @@reduced_computer_code = @computer_code
    return response
  end
  
end

game = Mastermind.new
p game.computer_code
p game.get_player_guess
p game.get_guess_response


