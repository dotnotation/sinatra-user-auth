class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  get '/registrations/signup' do
    #render the sign-up form
    erb :'/registrations/signup'
  end

  post '/registrations' do
    #get the new user info from params hash, creates a new user, signs them in, and redirects them
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id
    puts params
    redirect '/users/home'
  end

  get '/sessions/login' do
    #rendering the login form
    # the line of code below render the view page in app/views/sessions/login.erb
    erb :'sessions/login'
  end

  post '/sessions' do
    #receives the post request when a user hits submit on login form
    #grabs user info from params hash, looks to match info to existing entries in the database
    #if matching entry in found, signs the user in
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect '/users/home'
    end
    redirect '/sessions/login'
  end

  get '/sessions/logout' do
    #logs out user by clearing the session hash
    session.clear
    redirect '/'
  end

  get '/users/home' do
    #renders user's homepage
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end
end
