class Twitter::API < Grape::API
  version 'v1', :using => :header, :vendor => 'twitter'

  helpers do
    def current_user
      @current_user ||= User.authorize!(env)
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless current_user
    end
  end

  resource :statuses do
    get :public_timeline do
      Tweet.limit(20)
    end

    get :home_timeline do
      authenticate!
      current_user.home_timeline
    end

    get '/show/:id' do
      Tweet.find(params[:id])
    end

    post :update do
      authenticate!
      Tweet.create(
        :user => current_user,
        :text => params[:status]
      )
    end
  end

  resource :account do
    before { authenticate! }

    get '/private' do
      "Congratulations, you found the secret!"
    end
  end

end