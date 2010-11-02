require 'sinatra'
require 'dm-core'

DataMapper.setup(:default, "appengine://auto")

class Article
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :ctime, Integer
  property :mtime, Integer
end

helpers do
  include Rack::Utils
  alias_method :e, :escape
  alias_method :h, :escape_html
  alias_method :u, :unescape
end

get '/' do
  erb :index
end

get '/edit/:page' do
end

get '/wiki/:page' do
end

post '/edit' do
end

get '/stirup' do
  require 'creole'
  Creole.creolize("**Hello //all//, and welcome to tacha tacha**")
end



