require './mastermind.rb'
require 'sinatra'
#require 'sinatra/reloader'

enable :sessions

class GameController < Sinatra::Base
  get '/' do
    @session = session
    erb :mastermind, :locals => { :game => false }
    puts @session.to_s
  end

  get '/new' do
    code = []
    4.times { code << $colors.sample }
    session[:game] = Mastermind.new(code)
    session[:message] = "new game created"
    @game = session[:game]
    erb :mastermind, :locals => { :game => @game }
  end

  get '/play' do
    @game = session[:game]
    unless @game.victory? || @game.defeat?
      guess = params['guess'].upcase.split(//)
      @game.guess(guess) if Game.legal?(guess)
    end
    erb :mastermind, :locals => { :game => @game }

  end

end