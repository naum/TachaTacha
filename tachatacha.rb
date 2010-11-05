require 'sinatra'
require 'dm-core'
require 'appengine-apis/users'
require 'creare'
require 'cgi'

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
  def auth_editor?
    AppEngine::Users.logged_in? && AppEngine::Users.admin?
  end
  def add_dashes(str) 
    str.gsub(/ /, '-')
  end
  def strip_dashes(str)
    str.gsub(/\-/, ' ')
  end
  def u(str)
    #CGI::unescape(str)
    str
  end
end

get '/' do
  @articles = Article.all(:order => [ :mtime.desc], :limit => 40)
  erb :index
end

get '/404' do
  erb :notfound
end

get '/article/:title' do
  clean_title = strip_dashes params[:title]
  @article = Article.first(:title => clean_title)
  redirect "/edit/#{params[:title]}" unless @article
  @hbody = Creare.creolize(@article.body) 
  erb :article
end

get '/edit' do
  redirect "/edit/#{params[:title]}"
end

get '/edit/' do
  erb :emptyq
end

get '/edit/:title' do
  redirect '/404' unless auth_editor?
  @title = strip_dashes params[:title]
  @article = Article.first(:title => u(params[:title]))
  @body = (@article) ? @article.body : ''
  erb :edit
end

get '/infodump' do
  pout = "<p>" + request.inspect 
  if AppEngine::Users.logged_in?
    u = AppEngine::Users.current_user()
    pout << "<p>email: #{u.email}"
    pout << "<p>nickname: #{u.nickname}"
  end
  pout
end

get '/login' do
  redirect AppEngine::Users.create_login_url('/')
end

get '/logout' do
  redirect AppEngine::Users.create_logout_url('/')
end

get '/unauthorized' do
  erb :unauthorized
end

not_found do
  erb :notfound
end

post '/edit' do
  redirect '/unauthorized' unless auth_editor?
  @title = params[:title]
  ts = Time.now.to_i
  @article = Article.first(:title => u(params[:title]))
  if (@article) 
    if params[:body].strip.length > 0
      @article[:body] = params[:body]
      @article[:mtime] = ts
    else
      @article.destroy
      redirect '/'
    end
  else
    @article = Article.new(
      :title => params[:title], 
      :body => params[:body], 
      :ctime => ts, :mtime => ts
    )
  end
  @article.save
  pretty_title = @title.gsub(/ /, '-')
  redirect "/article/#{pretty_title}"
end


