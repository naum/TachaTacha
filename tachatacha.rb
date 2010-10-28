require 'sinatra'
require 'dm-core'

DataMapper.setup(:default, "appengine://auto")

class Article
  include DataMapper::Resource
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  erb :index
end

get '/stirup' do
  require 'creole'
  Creole.creolize("**Hello //all//, and welcome to tacha tacha**")
end



