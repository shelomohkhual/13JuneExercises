require "hangman"

# The code below suppresses stdout while rspec runs.
#################################################################
RSpec.configure do |config|
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do
    $stderr = File.open(File::NULL, "w")
    $stdout = File.open(File::NULL, "w")
  end
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
#################################################################

puts "\nNOTE: Once you complete all specs, run `ruby lib/play_hangman.rb` in your terminal!"

describe "Hangman" do
  let(:hangman) { Hangman.new }

  describe "::DICTIONARY" do
    it "should be an array of words" do
      expect(Hangman::DICTIONARY).to be_an(Array)
    end
  end

  describe "::random_word" do
    it "should return a random word in the dictionary" do
      expect(Hangman::DICTIONARY).to include(Hangman.random_word)
    end

    it "should call Array#sample" do
      expect(Hangman::DICTIONARY).to receive(:sample)
      Hangman.random_word
    end
  end

  describe "#initialize" do
    it "should call Hangman::random_word" do
      allow(Hangman).to receive(:random_word).and_return("dog")
      expect(Hangman).to receive(:random_word)
      hangman
    end

    it "should set @secret_word with the random word " do
      allow(Hangman).to receive(:random_word).and_return("dog")
      expect(hangman.instance_variable_get(:@secret_word)).to eq("dog")
    end

    it "should set @guess_word to be an array with the same length as the @secret_word containing '_' as each element" do
      allow(Hangman).to receive(:random_word).and_return("dog")
      expect(Hangman.new.instance_variable_get(:@guess_word)).to eq(Array.new(3, "_"))

      allow(Hangman).to receive(:random_word).and_return("bootcamp")
      expect(Hangman.new.instance_variable_get(:@guess_word)).to eq(Array.new(8, "_"))
    end

    it "should set @attempted_chars to be an empty array" do
      expect(hangman.instance_variable_get(:@attempted_chars)).to eq([])
    end

    it "should set @remaining_incorrect_guesses to 5" do
      expect(hangman.instance_variable_get(:@remaining_incorrect_guesses)).to eq(5)
    end
  end

  describe "#guess_word" do
    it "should get (return) @guess_word" do
      expect(hangman.guess_word).to be(hangman.instance_variable_get(:@guess_word))
    end
  end

  describe "#attempted_chars" do
    it "should get (return) @attempted_chars" do
      expect(hangman.attempted_chars).to be(hangman.instance_variable_get(:@attempted_chars))
    end
  end

  describe "#remaining_incorrect_guesses" do
    it "should get (return) @remaining_incorrect_guesses" do
      expect(hangman.remaining_incorrect_guesses).to be(hangman.instance_variable_get(:@remaining_incorrect_guesses))
    end
  end

  describe "#already_attempted?" do
    it "should accept a char as an arg" do
      hangman.already_attempted?("b")
    end

    context "when the given char is in @attempted_chars" do
      it "should return true" do
        hangman.instance_variable_set(:@attempted_chars, ["b"])
        expect(hangman.already_attempted?("b")).to eq(true)
      end
    end

    context "when the given char is not in @attempted_chars" do
      it "should return false" do
        hangman.instance_variable_set(:@attempted_chars, ["b"])
        expect(hangman.already_attempted?("c")).to eq(false)
      end
    end
  end

  describe "#get_matching_indices" do
    it "should accept a single char as an arg" do
      hangman.get_matching_indices("o")
    end

    it "should return an array containing all indices of @secret_word where the char can be found" do
      allow(Hangman).to receive(:random_word).and_return("bootcamp")
      expect(hangman.get_matching_indices("o")).to eq([1, 2])
      expect(hangman.get_matching_indices("c")).to eq([4])
    end

    context "when the char is not found in @secret_word" do
      it "should return an empty array" do
        allow(Hangman).to receive(:random_word).and_return("bootcamp")
        expect(hangman.get_matching_indices("x")).to eq([])
      end
    end
  end

  describe "#fill_indices" do
    it "should accept a char and an array of indices" do
      allow(Hangman).to receive(:random_word).and_return("bootcamp")
      hangman.fill_indices("o", [1, 2])
    end

    it "should set the given indices of @guess_word to the given char" do
      allow(Hangman).to receive(:random_word).and_return("bootcamp")
      hangman.fill_indices("o", [1, 2])
      expect(hangman.guess_word).to eq(["_", "o", "o", "_", "_", "_", "_", "_"])
    end
  end

  describe "#try_guess" do
    it "should accept a char as an arg" do
      hangman.try_guess("o")
    end

    it "should call Hangman#already_attempted?" do
      expect(hangman).to receive(:already_attempted?).with("o")
      hangman.try_guess("o")
    end

    context "if the char was already attempted" do
      it "should print 'that has already been attempted'" do
        hangman.instance_variable_set(:@attempted_chars, ["o"])
        expect { hangman.try_guess("o") }.to output(/already/).to_stdout
      end

      it "should return false to indicate the guess was previously attempted" do
        hangman.instance_variable_set(:@attempted_chars, ["o"])
        expect(hangman.try_guess("o")).to eq(false)
      end
    end

    context "if the char was not already attempted" do
      it "should add the char to @attempted_chars" do
        hangman.try_guess("o")
        expect(hangman.attempted_chars).to eq(["o"])

        hangman.try_guess("c")
        expect(hangman.attempted_chars).to eq(["o", "c"])

        hangman.try_guess("x")
        expect(hangman.attempted_chars).to eq(["o", "c", "x"])
      end

      it "should return true to indicate the guess was not previously attempted" do
        expect(hangman.try_guess("o")).to eq(true)
      end
    end

    context "if the char has no match indices in @secret_word" do
      it "should decrement @remaining_incorrect_guesses" do
        allow(Hangman).to receive(:random_word).and_return("bootcamp")

        hangman.try_guess("o")
        expect(hangman.remaining_incorrect_guesses).to eq(5)

        hangman.try_guess("x")
        expect(hangman.remaining_incorrect_guesses).to eq(4)
      end
    end

    it "should call Hangman#get_matching_indices with the char" do
      allow(Hangman).to receive(:random_word).and_return("bootcamp")
      allow(hangman).to receive(:get_matching_indices) { [1, 2] }
      expect(hangman).to receive(:get_matching_indices).with("o")
      hangman.try_guess("o")
    end

    it "should call Hangman#fill_indices with the char and it's matching indices" do
      allow(Hangman).to receive(:random_word).and_return("bootcamp")
      expect(hangman).to receive(:fill_indices).with("o", [1, 2])
      hangman.try_guess("o")
    end
  end

  describe "#ask_user_for_guess" do
    it "should print 'Enter a char:'" do
      allow(hangman).to receive(:gets).and_return("o\n")
      expect { hangman.ask_user_for_guess }.to output(/Enter a char/).to_stdout
    end

    it "should call gets.chomp to get input from the user " do
      char = double("o\n", :chomp => "o")
      allow(hangman).to receive(:gets).and_return(char)
      expect(char).to receive(:chomp)
      expect(hangman).to receive(:gets)
      hangman.ask_user_for_guess
    end

    it "should call Hangman#try_guess with the user's char" do
      char = double("o\n", :chomp => "o")
      allow(hangman).to receive(:gets).and_return(char)
      expect(hangman).to receive(:try_guess).with(char.chomp)
      hangman.ask_user_for_guess
    end

    it "should return the return value of Hangman#try_guess" do
      char = double("o\n", :chomp => "o")
      allow(hangman).to receive(:gets).and_return(char)

      allow(hangman).to receive(:try_guess).and_return(false)
      expect(hangman.ask_user_for_guess).to eq(false)

      allow(hangman).to receive(:try_guess).and_return(true)
      expect(hangman.ask_user_for_guess).to eq(true)
    end
  end

  describe "win?" do
    context "when @guess_word matches @secret_word" do
      it "should print 'WIN'" do
        allow(Hangman).to receive(:random_word).and_return("cat")
        hangman.instance_variable_set(:@guess_word, ["c", "a", "t"])
        expect { hangman.win? }.to output(/WIN/).to_stdout
      end

      it "should return true" do
        allow(Hangman).to receive(:random_word).and_return("cat")
        hangman.instance_variable_set(:@guess_word, ["c", "a", "t"])
        expect(hangman.win?).to eq(true)
      end
    end

    context "when @guess_word does not match @secret_word" do
      it "should return false" do
        allow(Hangman).to receive(:random_word).and_return("cat")
        hangman.instance_variable_set(:@guess_word, ["c", "_", "t"])
        expect(hangman.win?).to eq(false)
      end
    end
  end

  describe "lose?" do
    context "when @remaining_incorrect_guesses is 0" do
      it "should print 'LOSE'" do
        hangman.instance_variable_set(:@remaining_incorrect_guesses, 0)
        expect { hangman.lose? }.to output(/LOSE/).to_stdout
      end

      it "should return true" do
        hangman.instance_variable_set(:@remaining_incorrect_guesses, 0)
        expect(hangman.lose?).to eq(true)
      end
    end

    context "when @remaining_incorrect_guesses is not 0" do
      it "should return false" do
        hangman.instance_variable_set(:@remaining_incorrect_guesses, 2)
        expect(hangman.lose?).to eq(false)
      end
    end
  end

  describe "game_over?" do
    it "should call Hangman#win?" do
      allow(hangman).to receive(:lose?).and_return(false)
      allow(hangman).to receive(:win?).and_return(true)
      expect(hangman).to receive(:win?)
      hangman.game_over?
    end

    it "should call Hangman#lose?" do
      allow(hangman).to receive(:win?).and_return(false)
      allow(hangman).to receive(:lose?).and_return(true)
      expect(hangman).to receive(:lose?)
      hangman.game_over?

    end

    context "when the game is won or lost" do
      it "should print @secret_word" do
        allow(Hangman).to receive(:random_word).and_return("cat")

        allow(hangman).to receive(:lose?).and_return(false)
        allow(hangman).to receive(:win?).and_return(true)
        expect { hangman.game_over? }.to output(/cat/).to_stdout

        allow(hangman).to receive(:lose?).and_return(true)
        allow(hangman).to receive(:win?).and_return(false)
        expect { hangman.game_over? }.to output(/cat/).to_stdout
      end

      it "should return true" do
        allow(hangman).to receive(:lose?).and_return(false)
        allow(hangman).to receive(:win?).and_return(true)
        expect(hangman.game_over?).to eq(true)

        allow(hangman).to receive(:lose?).and_return(true)
        allow(hangman).to receive(:win?).and_return(false)
        expect(hangman.game_over?).to eq(true)
      end
    end

    context "when the game is not over" do
      it "should return false" do
        allow(hangman).to receive(:lose?).and_return(false)
        allow(hangman).to receive(:win?).and_return(false)
        expect(hangman.game_over?).to eq(false)
      end
    end
  end
end
