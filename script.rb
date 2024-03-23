# frozen_string_literal: true

# mastermind game module
module Mastermind
  COLORS = %w[red blue green yellow purple orange].freeze
  HOLES = 4
  # mastermind game class
  class Game
    def initialize
      @turns = 8
    end

    def play; end

    attr_accessor :turns
  end

  class Player
  end

  # computer player class
  class ComputerPlayer
    def create_code
      code = Array.new(HOLES)
      code.map do
        random_number = rand(COLORS.length)
        COLORS[random_number]
      end
    end
  end
end
