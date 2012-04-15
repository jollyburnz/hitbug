require 'sinatra'
require 'slim'
require 'bundler'
require 'faraday'
require 'octokit'
Bundler.require

get '/' do
	@githubber = Octokit.user("rumplefraggle")
	@githubber2 = Octokit.user("jollyburnz")
	slim :index
end