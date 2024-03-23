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
        take_guess
        if turns <= 0
          puts 'You lose!' if codebreaker.type == 'human'
          self.game_end = true
        end
      end
    end

    def take_guess
      puts 'Input your guess'
      guess = gets.chomp.split(' ')
      p guess
    end

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
