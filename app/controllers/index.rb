get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  username = @access_token.params[:screen_name]
  user_params = {:oauth_token => @access_token.token, :oauth_secret => @access_token.secret, :username => username}

  @user = User.find_by_username(username)
  if @user
    @user.update_attributes(user_params)
  else
    @user = User.create(user_params)
  end
                                            
  session[:user_id] = @user.id

  erb :index
  
end


get '/user/:user_id/recent_tweets' do
  @tweets = current_user.tweets
  erb :recent_tweets
end
