# encoding: UTF-8

require 'spec_helper'
require 'game'

describe Game do
  let(:word_raffler) { double("raffler").as_null_object }

  subject(:game) { Game.new(word_raffler) }

  describe '#ended?' do
    it 'returns false when the game just started' do
      game.should_not be_ended
    end
  end

  describe "#raffle" do
    it "raffles a word with the given length" do
      word_raffler.should_receive(:raffle).with(3)

      game.raffle(3)
    end

    it "saves the raffled word" do
      raffled_word = "mom"
      word_raffler.stub(raffle: raffled_word)

      game.raffle(3)

      game.raffled_word.should == raffled_word
    end

    it "makes a transition from :initial to :word_raffled on success" do
      word_raffler.stub(raffle: "word")

      expect do
        game.raffle(3)
      end.to change { game.state }.from(:initial).to(:word_raffled)
    end

    it "stays on the :initial state when a word can't be raffled" do
      word_raffler.stub(raffle: nil)

      game.raffle(3)

      game.state.should == :initial
    end
  end

  describe "#finish" do
    it "sets the game as ended" do
      game.finish

      game.should be_ended
    end
  end

  context "when just created" do
    its(:state) { should == :initial }
  end
end