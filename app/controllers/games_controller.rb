require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def check?(arr1, arr2, result)
    arr1.each_with_index do |c, i|
      next if c <= arr2[i]

      result[:message] = 'not in the grid'
      result[:score] = 0
      return true
    end
    return false
  end

  def get_result(attempt, result)
    is_valid = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)["found"]
    if is_valid
      result[:message] = 'Well done!'
    else
      result[:message] = 'not an english word'
    end
    return result
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    arr1 = Array.new(26, 0)
    arr2 = Array.new(26, 0)
    result = {}

    attempt.chars.each { |ele| arr1[ele.downcase.ord - 'a'.ord] += 1 }
    grid.each { |ele| arr2[ele.downcase.ord - 'a'.ord] += 1 }
    return result if check?(arr1, arr2, result)

    get_result(attempt, result)
  end

  def new
    @grid = generate_grid(10)
    session[:grid] = @grid
    session[:start_time] = Time.now
  end

  def score
    @end_time = Time.now
    # raise
    @result = run_game(params[:guess], session[:grid])
  end
end
