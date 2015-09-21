require 'sinatra/base'
require 'json'
require 'uuidtools'

class KeyValueStore < Sinatra::Application

  configure do
    set :pairs, {}
  end

  before do
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Credentials' => 'true'
    headers 'Access-Control-Allow-Methods' => 'GET. PUT, POST, DELETE, OPTIONS'
    headers 'Access-Control-Allow-Headers' => 'origin, content-type, accept, authorization'
  end

  options /.*/ do
    200
  end

  post '/users/authenticate' do
    'token'
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
      id:     params[:formid],
      fields: settings.pairs
    })
  end

  post '/forms/:formid/fieldvalue' do
    request.body.rewind
    payload = JSON.parse(request.body.read, symbolize_names: true)
    settings.pairs[payload[:fieldName]] = payload[:fieldValue]
    200
  end

  delete '/forms/:formid/fieldvalue' do
    request.body.rewind
    payload = JSON.parse(request.body.read, symbolize_names: true)
    settings.pairs.delete(payload[:fieldName])
    200
  end

  get '/users' do
    content_type :json
    JSON.pretty_generate({
      resourceList: []
    })
  end

  get '/organisations' do
    content_type :json
    JSON.pretty_generate({
      resourceList: []
    })
  end

  get '/readmodels/allforms' do
    content_type :json
    JSON.pretty_generate({
      forms: [
        {streamName: 'stream-1', users: []},
        {streamName: 'stream-2', users: ['b']},
        {streamName: 'stream-2', users: ['a'], status: 'Failed'}
      ]
    })
  end

  get '/readmodels/dodgyformevents' do
    content_type :json
    JSON.pretty_generate({
      dodgyFormEvents: []
    })
  end

end
