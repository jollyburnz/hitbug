require 'sinatra'
require 'slim'
require 'coffee-script'
require 'bundler'
require 'httparty'
require 'cgi'
#require 'octokit'
Bundler.require

class Github
	include HTTParty
	format :json
	default_params :output => 'json'

	def self.user(user)
		get("https://api.github.com/users/#{user}")
	end
end

get '/test.js' do
	coffee :test
end

get '/' do
	Slim::Engine.set_default_options :disable_escape => true
	@a = Github.user('jollyburnz')
	slim :index
end