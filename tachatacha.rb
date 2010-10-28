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


