# frozen_string_literal: true

# mastermind game module
module Mastermind
  COLORS = %w[red blue green yellow purple orange].freeze
  HOLES = 4
  # mastermind game class
  class Game
    def initialize
      @turns = 8
      @game_end = false
      @codemaker = ComputerPlayer.new
      @codebreaker = HumanPlayer.new
      puts 'Mastermind'
    end

    def play
      self.secret_code = codemaker.create_code
      display_rules if codebreaker.type == 'human'
      until game_end
        guess = take_guess
        check_guess(guess)
        if turns <= 0
          puts 'You lose!' if codebreaker.type == 'human'
          self.game_end = true
        end
      end
    end

    def take_guess
      puts 'Input your guess'
      guess = gets.chomp.downcase.split(' ')
      if correct_input?(guess)
        guess
      else
        puts 'Incorrect input, please input your guess again'
        take_guess
      end
    end

    def correct_input?(input)
      if input.length != HOLES || input.any? { |color| !COLORS.include?(color) }
        false
      else
        true
      end
    end

    def check_guess(guess)
      if guess == secret_code
        codebreaker_wins
      else
        display_hints(guess)
      end
    end

    def display_hints(guess)
      buff_code = secret_code.clone
      buff_guess = []
      guess.each_with_index do |pos, i|
        if pos == secret_code[i]
          puts 'red key peg'
          buff_code.delete_at(i)
        else
          buff_guess.push(pos)
        end
      end
      buff_guess.each do |pos|
        if buff_code.include?(pos)
          puts 'white key peg'
          buff_code.delete(pos)
        end
      end
    end

    def codebreaker_wins; end

    def codemaker_wins; end

    def display_rules
      puts 'Possible colors:'
      COLORS.each { |color| puts "- #{color}" }
      puts "To guess the code you should input #{HOLES} color names, for example:"
      puts 'red blue yellow green'
    end

    attr_accessor :turns, :game_end, :secret_code, :codemaker, :codebreaker
  end

  # human player class
  class HumanPlayer
    def initialize
      @type = 'human'
    end

    attr_reader :type
  end

  # computer player class
  class ComputerPlayer
    def initialize
      @type = 'computer'
    end

    def create_code
      code = Array.new(HOLES)
      code.map do
        random_number = rand(COLORS.length)
        COLORS[random_number]
      end
    end
    attr_reader :type
  end
end

include Mastermind
game = Game.new
game.play
