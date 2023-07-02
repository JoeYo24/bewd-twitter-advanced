class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all.order(created_at: :desc)
    render 'tweets/index'
  end

  def create
    if !current_user.pass_rate_limit?
      return render 'tweets/rate_limit_error'
    end

    @tweet = current_user.tweets.new(tweet_params)

    if @tweet.save 
      render 'tweets/create'
    end
  end

  def destroy 
    authenticate_user!
    @tweet = current_user&.tweets&.find_by(id: params[:id])

    if @tweet && @tweet.destroy 
      render json: { success: true }
    end
  end

  def index_by_user
    user = User.find_by(username: params[:username])

    if user
      @tweets = user.tweets
      render 'tweets/index'
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message, :image)
  end
end
