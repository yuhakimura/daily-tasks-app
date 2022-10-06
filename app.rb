require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'

enable :sessions

get '/' do
    if current_user.nil?
        redirect '/top'
    else
        @tasks = current_user.tasks
        erb :home
    end
end

get '/top' do
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
        redirect '/'
    else
        redirect '/signin'
    end
end

post '/signup' do
    if params[:password] != params[:password_confirmation]
        redirect '/signup'
    else
        user = User.create(mail: params[:mail], name: params[:name], password: params[:password],
                            password_confirmation: params[:password_confirmation])
    end
    if user.persisted?
        session[:user] = user.id
        redirect '/'
    else
        erb :sign_up
    end
end

get '/signout' do
    session[:user] = nil
    redirect '/top'
end

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/tasks/new' do
    erb :new
end

post '/tasks' do
    current_user.tasks.create(title: params[:title], date_start: params[:date_start], date_end: params[:date_end],
                                quantity: params[:quantity], unit: params[:unit], quantity_finished: 0, color: params[:color],
                                importance: params[:importance])
    redirect '/'
end

get '/tasks/:id/delete' do
    task = Task.find(params[:id])
    task.destroy
    redirect '/'
end

get '/tasks/:id/edit' do
    @task = Task.find(params[:id])
    erb :edit
end

post '/tasks/:id' do
    task = Task.find(params[:id])
    
    task.title = params[:title]
    task.date_start = params[:date_start]
    task.date_end = params[:date_end]
    task.quantity = params[:quantity]
    task.unit = params[:unit]
    task.quantity_finished = 0
    task.color = params[:color]
    task.importance = params[:importance]
    task.save
    redirect '/'
end