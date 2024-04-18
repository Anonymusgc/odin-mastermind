# frozen_string_literal: true

# mastermind game module
module Mastermind
  COLORS = %w[red blue green yellow purple orange].freeze
  HOLES = 4

  # mastermind game class
  class Game
    attr_accessor :turns, :game_end, :secret_code, :codemaker, :codebreaker, :response

    def initialize
      @turns = 8
      @game_end = false
      # @codemaker = ComputerPlayer.new
      # @codebreaker = HumanPlayer.new
      puts 'Mastermind'
    end

    def play
      choose_gamemode
      codebreaker.display_rules

      self.secret_code = codemaker.create_code

      until game_end
        guess = codebreaker.take_guess(response)
        self.response = check_guess(guess)
        update_turns if game_end == false
      end
    end

    def choose_gamemode
      puts '--------------------------------------'
      puts 'Select what gamemode you want to play: '
      puts '1. Code creator'
      puts '2. Code guesser'
      puts '--------------------------------------'
      gamemode = gets.chomp
      if gamemode == '1'
        self.codebreaker = ComputerPlayer.new
        self.codemaker = HumanPlayer.new
      elsif gamemode == '2'
        self.codebreaker = HumanPlayer.new
        self.codemaker = ComputerPlayer.new
      else
        puts 'Incorrect choice, please input again'
        choose_gamemode
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
      res = [[], []]
      puts "\nHints:"
      buff_code = secret_code.clone
      buff_guess = []
      incorrect_guess = true
      guess.each_with_index do |pos, i|
        if pos == secret_code[i]
          puts 'red key peg'
          res[0].push(1)
          incorrect_guess = false
          buff_code.delete_at(buff_code.index(pos) || buff_code.length)
        else
          buff_guess.push(pos)
        end
      end
      buff_guess.each do |pos|
        next unless buff_code.include?(pos)

        puts 'white key peg'
        res[1].push(1)
        incorrect_guess = false
        buff_code.delete_at(buff_code.index(pos))
      end

      puts "\nNo hints, incorrect guess\n" if incorrect_guess
      puts "\n"
      # p res
      res
    end

    def update_turns
      self.turns -= 1
      puts "#{turns} turns left"
      return unless turns <= 0

      codemaker_wins
    end

    def codebreaker_wins
      puts "\n #{codebreaker.type.capitalize} Player wins"
      self.game_end = true
      p secret_code
    end

    def codemaker_wins
      puts "\n #{codemaker.type.capitalize} Player wins!"
      self.game_end = true
      p secret_code
    end
  end

  # human player class
  class HumanPlayer
    def initialize
      @type = 'human'
    end

    def display_rules
      puts "\nTo guess the code you should input #{HOLES} color names, for example:"
      puts 'red blue yellow green'
      puts "\nPossible colors:"
      COLORS.each { |color| puts "- #{color}" }
    end

    def create_code
      puts 'Input secret code: '
      puts '(example: red blue yellow green)'
      code = gets.chomp.downcase.split(' ')
      if correct_input?(code)
        code
      else
        puts 'Incorrect input, please input your secret code again'
        create_code
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

    def take_guess
      guess = Array.new(HOLES)
    end

    def display_rules
      puts "\nCreate code for the computer to guess"
      puts "Code length should be: #{HOLES}"
      puts 'Possible colors:'
      COLORS.each { |color| puts "- #{color}" }
    end

    attr_reader :type
  end
end

include Mastermind
game = Game.new
game.play
