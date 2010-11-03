require 'creole'

class Creare < Creole
  
  def make_local_link(link)
    '/article/' + link
  end

end
