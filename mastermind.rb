class Mastermind
  attr_reader :guesses

  @@colors = ['R','G','B','C','M','Y']

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
      @key_code if @guesses.last && @guesses.last[:correct] == 4
  end

  def defeat?
      @key_code if @guesses.length >= 8
  end

  def self.legal?(code)
      code.kind_of?(Array)&&
      code.length == 4&&
      code.all? { |e| @@colors.include?(e) }
  end

  def self.colors
    @@colors
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