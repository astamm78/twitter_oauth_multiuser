class User < ActiveRecord::Base

  def post_tweet(content)
    twitter_client.update(content)
  end

  def tweets
    twitter_client.user_timeline
  end

  private

  def twitter_client
    Twitter::Client.new( :oauth_token => self.oauth_token, :oauth_token_secret => self.oauth_secret )
  end

end
