# Import the necessary dependencies and set up RSpec
require_relative 'spec_helper'

# Describe the ClientManager API tests
describe 'ClientManager API' do
  # Include the Rack::Test::Methods module to simulate HTTP requests
  include Rack::Test::Methods

  # Define the app method to specify the Sinatra application
  def app
    Sinatra::Application
  end

  # Define tests for the 'GET /search' endpoint
  describe 'GET /search' do
    it 'returns matching clients for full_name' do
      get '/search?[q][full_name]=john'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body).size).to eq(4)
    end

    it 'returns matching clients for email' do
      get '/search?[q][email]=john.doe@gmail.com'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body).size).to eq(2)
    end

    it 'returns matching clients for full_name and email' do
      get '/search?[q][full_name]=john&[q][email]=john.doe@gmail.com'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body).size).to eq(2)
    end

    it 'returns an error for missing search parameters' do
      get '/search'
      expect(last_response.status).to eq(400)
      expect(JSON.parse(last_response.body)['error']).to eq('Invalid search filters')
    end
  end

  # Define tests for the 'GET /duplicates' endpoint
  describe 'GET /duplicates' do
    it 'returns duplicate emails' do
      get '/duplicates'
      expect(last_response).to be_ok

      expect(JSON.parse(last_response.body)).to eq({"john.doe@gmail.com"=>{"count"=>2, "records"=>[{"id"=>1, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}, {"id"=>6, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}]}, "jane.smith@yahoo.com"=>{"count"=>2, "records"=>[{"id"=>2, "full_name"=>"John Doe", "email"=>"jane.smith@yahoo.com"}, {"id"=>15, "full_name"=>"Another Jane Smith", "email"=>"jane.smith@yahoo.com"}]}})  # Adjust based on your sample data
    end

    it 'returns duplicate full_names' do
      get '/duplicates?[field]=full_name'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq({"John Doe"=>{"count"=>3, "records"=>[{"id"=>1, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}, {"id"=>2, "full_name"=>"John Doe", "email"=>"jane.smith@yahoo.com"}, {"id"=>6, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}]}})  # Adjust based on your sample data
    end

    it 'returns duplicate emails' do
      get '/duplicates?[field]=email'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq({"john.doe@gmail.com"=>{"count"=>2, "records"=>[{"id"=>1, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}, {"id"=>6, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}]}, "jane.smith@yahoo.com"=>{"count"=>2, "records"=>[{"id"=>2, "full_name"=>"John Doe", "email"=>"jane.smith@yahoo.com"}, {"id"=>15, "full_name"=>"Another Jane Smith", "email"=>"jane.smith@yahoo.com"}]}})  # Adjust based on your sample data
    end

    it 'returns duplicate emails and full_names' do
      get '/duplicates?[field]=email,full_name'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq({"john.doe@gmail.com, John Doe"=>{"count"=>2, "records"=>[{"id"=>1, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}, {"id"=>6, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}]}})  # Adjust based on your sample data
    end
  end
end
