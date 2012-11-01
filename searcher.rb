require 'sinatra'
require 'yaml'
require 'rubygems'
require 'net/http'
require 'uri'
require 'json'
require 'oauth'
require 'googleajax'

get '/' do 
  "hello"
end

get '/q/:word' do
  @tweets = []
  @googles = []
  tw_search("http://search.twitter.com/search.json?q=#{params[:word]}")
  goo_search(params[:word])
  erb :index
end

def tw_search(url)
  # parse the url we want to access
  uri = URI.parse(url)

  # creating a request object
  req = Net::HTTP.get(uri)

  hash = JSON.parse(req.to_s)
  hash["results"].each do |tweet|
    @tweets << {from: tweet["from_user"], text: tweet["text"]}
  end
end

def goo_search(word)
  GoogleAjax.referer = "Searcher"
  GoogleAjax::Search.web(word)[:results].each do |goo|
    @googles << {title: goo[:title], content: goo[:content]}
  end
end