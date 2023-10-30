ENV['RACK_ENV'] = 'test'  # Set the environment to 'test'

require 'rack/test'
require 'rspec'

require_relative '../app'  # Load your Sinatra app file here

RSpec.configure do |config|
  config.include Rack::Test::Methods
end