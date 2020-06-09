# frozen_string_literal: true

require 'spec_helper'

describe 'Route Params' do
  def app
    Class.new(Grape::API) do
      format :json

      route_param :a_route_param, type: String, 
                                documentation: { 
                                  description: "description of a route param", 
                                  example: "abcdef" 
                                } do
        get '/route_param'
      end

      add_swagger_documentation
    end
  end

  subject do
    get '/swagger_doc'
    expect(last_response.status).to eq 200
    body = JSON.parse last_response.body
    body['paths']['/{a_route_param}/route_param']['get']['parameters']
  end

  it 'should have a param' do
    expect(subject).to eq [
      { 'in' => 'path', 'name' => 'a_route_param', 'type' => 'string', 'required' => true }
    ]
  end

  it 'should have a param with a description' do
    expect(subject).to eq [
      { 'description' => 'description of a route param'}
    ]
  end

  it 'should have a param with an example' do
    expect(subject).to eq [
      { 'example' => 'abcdef' }
    ]
  end
end
