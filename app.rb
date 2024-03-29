require 'sinatra'
require 'bundler'
require 'oauth2'
require 'json'
Bundler.require

class Github
	include HTTParty
	format :json
	default_params :output => 'json'

	def self.user(user)
		get("https://api.github.com/users/#{user}")
	end
end

def new_client
  OAuth2::Client.new('992663999b8bb6e29d52', 'e7121f0d98df8b42c1f3d118a86b71d7666ea22e',
                     :ssl => {:ca_file => '/etc/ssl/ca-bundle.pem'},
                     :site => 'https://api.github.com',
                     :authorize_url => 'https://github.com/login/oauth/authorize',
                     :token_url => 'https://github.com/login/oauth/access_token')
end

get '/test.js' do
	coffee :test
end

get '/' do
	slim :index
end
=begin
get '/login' do
  url = client.auth_code.authorize_url(:scope => 'user, public_repo, repo, gist')
  puts "Redirecting to URL: #{url.inspect}"
  redirect url
end
get '/main' do
  puts params[:code]
  begin
    access_token = client.auth_code.get_token(params[:code])
    user = JSON.parse(access_token.get('/user').body)
    "<p>Your OAuth access token: #{access_token.token}</p><p>Your extended profile data:\n#{user.inspect}</p>"
  rescue OAuth2::Error => e
    %(<p>Outdated ?code=#{params[:code]}:</p><p>#{$!}</p><p><a href="/auth/github">Retry</a></p>)
  end
end
=end

get '/auth/github' do
  url = new_client.auth_code.authorize_url(
    :redirect_uri => redirect_uri,
    :scope => 'user, public_repo, repo, gist'
  )
  puts "Redirecting to URL: #{url.inspect}"
  redirect url
end
# If the user authorizes it, this request gets your access token
# and makes a successful api call.
get '/auth/github/callback' do
  begin
    access_token = new_client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
    user = JSON.parse(access_token.get('/user').body)
    "<p>Your OAuth access token: #{access_token.token}</p><p>Your extended profile data:\n#{user.inspect}</p>"
  rescue OAuth2::HTTPError => e
    %(<p>Outdated ?code=#{params[:code]}:</p><p>#{$!}</p><p><a href="/auth/github">Retry</a></p>)
  end
end

def redirect_uri(path = '/auth/github/callback', query = nil)
  uri = URI.parse(request.url)
  uri.path  = path
  uri.query = query
  uri.to_s
end