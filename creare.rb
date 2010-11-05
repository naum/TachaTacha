require 'creole'
include Rack::Utils

class Creare < Creole
  
  def make_local_link(link)
    '/article/' + link.gsub(/ /, '-')
  end

end
