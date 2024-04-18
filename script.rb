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
      @response = [[], []]
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
          res[0].push(0)
        end
      end
      buff_guess.each do |pos|
        next unless buff_code.include?(pos)

        puts 'white key peg'
        res[1].push(pos)
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

    def take_guess(_response)
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
    attr_reader :type
    attr_accessor :prev_guess, :color_array

    def initialize
      @type = 'computer'
      @color_array = COLORS.map(&:clone)
    end

    def create_code
      code = Array.new(HOLES)
      code.map do
        random_number = rand(COLORS.length)
        COLORS[random_number]
      end
    end

    def take_guess(response)
      guess = Array.new(HOLES)

      if (response[0].empty? || response[0].all? { |pos| pos == 0 }) && response[1].empty? && !prev_guess.nil?
        prev_guess.each do |pos|
          color_array.delete(pos)
        end
      elsif !prev_guess.nil?
        prev_guess.each_with_index do |pos, i|
          guess[i] = pos if response[0][i] == 1
        end
      end

      guess = handle_white_pegs(guess, response)

      self.prev_guess = guess
      p guess
      guess
    end

    def handle_white_pegs(guess, response)
      rand_pos = ''
      if response[1].length > 1 && !prev_guess.nil?
        guess = guess.map.with_index do |pos, i|
          if pos.nil?
            loop do
              random_number = rand(response[1].length)
              rand_pos = response[1][random_number]
              break if rand_pos != prev_guess[i]
            end
            rand_pos
          else
            pos
          end
        end
        p guess
      elsif response[1].length == 1 && !prev_guess.nil?
        guess = guess.map.with_index do |pos, i|
          if pos.nil?

            random_number = rand(response[1].length)
            rand_pos = response[1][random_number]
            if rand_pos == prev_guess[i]
              random_number = rand(color_array.length)
              rand_pos = color_array[random_number]
            end
            rand_pos
          else
            pos
          end
        end
        p guess
      else
        guess = create_guess(guess)
      end
      guess
    end

    def create_guess(guess)
      guess.map.with_index do |pos, i|
        if pos.nil?
          random_number = rand(color_array.length)
          rand_pos = color_array[random_number]
          unless prev_guess.nil?
            while rand_pos == prev_guess[i]
              random_number = rand(color_array.length)
              rand_pos = color_array[random_number]
            end
          end
          rand_pos
        else
          pos
        end
      end
    end

    def display_rules
      puts "\nCreate code for the computer to guess"
      puts "Code length should be: #{HOLES}"
      puts 'Possible colors:'
      COLORS.each { |color| puts "- #{color}" }
    end
  end
end

include Mastermind
game = Game.new
game.play
