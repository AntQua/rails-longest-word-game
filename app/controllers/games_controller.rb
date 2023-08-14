require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    # @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)

    # Update the session with the score if the word is valid
    if @english_word && @included
      session[:grand_score] ||= 0
      session[:grand_score] += @word.length
    end
  end

  private

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

end
