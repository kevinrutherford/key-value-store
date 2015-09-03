require 'sinatra/base'
require 'json'
require 'uuidtools'

class KeyValueStore < Sinatra::Application

  configure do
    set :pairs, {}
  end

  before do
    headers 'Access-Control-Allow-Origin' => '*'
  end

  options /.*/ do
    200
  end

  get '/user' do
    content_type :json
    JSON.pretty_generate({
      id:             UUIDTools::UUID.random_create.to_s,
      organisationId: UUIDTools::UUID.random_create.to_s,
      friendlyName:   'linux!',
      permissions:    ['Create_SDLT']
    })
  end

  get '/forms/:formid' do
    content_type :json
    JSON.pretty_generate({
      fields: settings.pairs
    })
  end

  post '/forms/:formid/fieldvalue' do
    request.body.rewind
    payload = JSON.parse(request.body.read, symbolize_names: true)
    settings.pairs[payload[:fieldName]] = payload[:fieldValue]
    200
  end

end
