require './mastermind.rb'
require 'sinatra'
#require 'sinatra/reloader'

class GameController < Sinatra::Base
  enable :sessions

  get '/' do
    erb :mastermind, :locals => { :game => false }
  end

  get '/new' do
    code = []
    4.times { code << Mastermind.colors.sample }
    session[:game] = Mastermind.new(code)
    @game = session[:game]
    erb :mastermind, :locals => { :game => @game }
  end

  get '/play' do
    @game = session[:game]
    unless ( @game.victory? || @game.defeat? )
      guess = params['guess'].upcase.split(//)
      @game.guess(guess) if Mastermind.legal?(guess)
    end
    erb :mastermind, :locals => { :game => @game }

  end

end