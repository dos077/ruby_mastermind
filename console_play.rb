class Game
    attr_reader :guesses

    $colors = ['R','G','B','C','M','Y']

    def initialize(key_code)
        @key_code = key_code
        @guesses = []
    end

    def guess(code)
        score = self.class.check_response(code, @key_code)
        @guesses << { code: code, correct: score[0], colors: score[1] }
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

    def self.check_response(code, key )
        colors = 0
        color_key = key.clone
        code.each do |e|
            if index = color_key.index(e)
                colors+=1
                color_key.delete_at(index)
            end
        end
        correct = 0
        4.times { |i| correct+=1 if key[i] == code[i] }
        [correct, colors]
    end

    private

    def display_code(code)
        screen = ""
        code.each { |c| screen+="#{c}" }
        screen
    end

end

class AI

    def initialize
        @set = $colors.repeated_permutation(4).to_a
    end

    def self.generate_code
        code = []
        4.times { code << $colors.sample }
        code
    end
    
    def guess(last_guess)
        return [$colors[1], $colors[1], $colors[2], $colors[2]] unless last_guess
        #eliminating the impossibles
        @set.delete_if {
            |key| Game.check_response(last_guess[:code], key) != [last_guess[:correct], last_guess[:colors]]
        }
        best_guess = @set.sample
        score = 1
        @set.each do |branch|
            branch_score = score_move(branch, score)
            if branch_score > score
                best_guess = branch
                score = branch_score
            end
        end
        best_guess
    end

    def score_move(guess, alpha)
        score = @set.length-1
        (0..3).each do |b|
            (b..4).each do |w|
                branch_score = @set.length-1
                @set.each do |branch|
                    branch_score-=1 if Game.check_response(guess, branch) == [b,w]
                end
                return branch_score if alpha < branch_score
                score = branch_score if branch_score < score
            end
        end
        score
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
            puts "Computer is generating a random code..."
            sleep 10
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
        ai_breaker = AI.new if @player_2 == "AI"
        until @game.victory? || @game.defeat?
            if ai_breaker
                puts "AI is making a guess..."
                @game.guess(ai_breaker.guess(@game.guesses.last))
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

puts "Please enter the name for codemaster, or if you want a computer generated code, enter AI"
player_1 = gets.chomp
puts "Please enter the name for codebreaker, or if you to test the codebreaking skill of AI(it's perfect), type AI."
player_2 = gets.chomp

new_round = GameController.new(player_1, player_2)