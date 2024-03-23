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
    end

    def play
      self.secret_code = codemaker.create_code
      until game_end

      end
    end

    attr_accessor :turns, :game_end, :secret_code, :codemaker, :codebreaker
  end

  # human player class
  class HumanPlayer
    def initialize
      @type = 'human'
    end
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
  end
end
