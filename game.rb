class Game
    attr_reader :guesses

    $colors = ['R','G','B','C','M','Y']

    def initialize(key_code)
        @key_code = key_code
        @guesses = []
    end

    def guess(code)
        right_color = 0
        answer_key = @key_code.clone
        code.each do |e|
            if index = answer_key.index(e)
                right_color+=1
                answer_key.delete_at(index)
            end
        end
        correct = 0
        4.times { |i| correct+=1 if @key_code[i] == code[i] }
        @guesses << { code: code, correct: correct, colors: right_color }
    end

    def display
        screen = "==============\n"
        @guesses.each do |guess|
            screen+=display_code(guess[:code])
            screen+=":"
            guess[:correct].times { screen+="b" }
            (guess[:colors] - guess[:correct]).times { screen+="w" }
            screen+="\n"
        end
        screen+="==============="
        screen
    end

    def victory?
        display_code(@key_code) if @guesses.last && @guesses.last[:correct] == 4
    end

    def defeat?
        display_code(@key_code) if @guesses.length > 10
    end

    def self.legal?(code)
        code.kind_of?(Array)&&
        code.length == 4&&
        code.all? { |e| $colors.include?(e) }
    end

    private

    def display_code(code)
        screen = ""
        code.each { |c| screen+="#{c}" }
        screen
    end

end

module AI
    def self.generate_code
        code = []
        4.times { code << $colors.sample }
        code
    end
    
    def self.guess(history)
    end
end

class GameController
    def initialize(player_1, player_2)
        @player_1 = player_1
        @player_2 = player_2
        setup
    end

    def setup
        puts "Welcome to Mastermind. You will be decoding a four digit code made up of\n(R)ed\n(G)reen\n(B)lue\n(C)yan\n(Y)ellow\n(M)agenta\nYou have 10 tries and each entry will be graded with up to four letters:\n(b)-one for every correct digit\n(w)-one for every correct color but wrong position"
        if @player_1 == "AI"
            @game = Game.new(AI.generate_code)
            play_game 
        else
            loop do
                puts "#{@player_1}, you are the codemaker, please input the code."
                code = gets.chomp.upcase.split(//)
                unless Game.legal?(code)
                    puts "That's not a valid code. Please input a four letter combo of R/G/B/C/Y/M"
                else
                    @game = Game.new(code)
                    play_game
                    break
                end
            end
        end
    end

    def play_game
        system "clear"
        until @game.victory? || @game.defeat?
            if @player_2 == "AI"
                puts "AI is making a guess..."
                @game.guess(AI.guess(@game.guesses))
                puts @game.display
            else
                puts "#{@player_2}, please make your guess."
                code = gets.chomp.upcase.split(//)
                until Game.legal?(code)
                    puts "That's not a valid code. Please input a four letter combo of R/G/B/C/Y/M"
                    code = gets.chomp.upcase.split(//)
                end
                @game.guess(code)
                puts @game.display
            end
        end
        if @game.victory?
            puts "Codebreaker #{@player_2} won."
        elsif @game.defeat?
            puts "Key code: " + @game.defeat?
            puts "Codemaster #{@player_1} won."
        end
    end
end

new_round = GameController.new("AI","Lily")