class Hangman
  dictionary 

  attr_accessor :guess_word,:attempted_chars,:remaining_incorrect_guesses
  def initialize
    @secret_word = "World"
    @guess_word = guess_word
    @attempted_chars = []
    @remaining_incorrect_guesses = 5
  end
  def already_attempted?(char)
    attempted_chars.include? char
  end
  def get_matching_indices(single_char)

  end

end

