require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'

enable :sessions

get '/' do
  erb :index
end

get '/signin' do
    erb :sign_in
end

get '/signup' do
    erb :sign_up
end

post '/signin' do
    user = User.find_by(mail: params[:mail])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/home'
end

post '/signup' do
    user = User.create(mail: params[:mail], name: params[:name], password: params[:password],
                        password_confirmation: params[:password_confirmation])
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/home'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/home' do
    if current_user.nil?
        @tasks = Task.none
    else
        @tasks = current_user.tasks
    end
    
    # @tasks.each do |task|
    #     if (task.date_start..task.date_end).include? Date.today 
    #         task.id
    erb :home
end

get '/tasks/new' do
    erb :new
end

post '/tasks' do
    current_user.tasks.create(title: params[:title], date_start: params[:date_start], date_end: params[:date_end],
                                quantity: params[:quantity], quantity_finished: 0, color: params[:color])
    redirect '/home'
end