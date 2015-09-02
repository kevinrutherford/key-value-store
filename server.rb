require 'sinatra/base'

class KeyValueStore < Sinatra::Application
  get '/' do
    redirect '/index.html'
  end
end
