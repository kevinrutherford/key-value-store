require 'sinatra/base'
require 'json'

class KeyValueStore < Sinatra::Application

  configure do
    set :pairs, {}
  end

  before do
    headers 'Access-Control-Allow-Origin' => '*'
  end

  get '/forms/:formid' do
    content_type :json
    return JSON.pretty_generate({
      fields: settings.pairs
    })
  end

  post '/forms/:formid/fieldvalue' do
    request.body.rewind
    payload = JSON.parse(request.body.read, symbolize_names: true)
    settings.pairs[payload[:fieldName]] = payload[:fieldValue]
    return 200
  end

end
