require 'sinatra'
require 'json'
require_relative 'lib/client_manager'

# Set the port for the Sinatra application
set :port, 3000

# Initialize the ClientManager with the clients.json data
manager = ClientManager.new('./data/clients.json')

# Route for searching clients based on query parameters
get '/search' do
  content_type :json

  # Parse the query string into search fields using ParametersParser
  search_fields = ParametersParser.parse(params[:q])

  if search_fields  
      
    # Search for matching clients using the ClientManager
    matching_clients = manager.search_clients(search_fields)
    
    if matching_clients.empty?
      { error: 'No Results Found' }.to_json
    else
      matching_clients.to_json
    end
  else
    # Handle missing query parameter with a 400 status code
    status 400
    { error: 'Invalid search filters' }.to_json
  end
end

# Route for finding duplicate field values
get '/duplicates' do
  content_type :json

  # Get the field parameter or default to "email"
  field = params[:field] || "email"
  
  # Split the field parameter into an array if it contains multiple fields
  fields_array = field.split(",")

  if fields_array
    # Find duplicate field values using the ClientManager
    duplicate_field_values = manager.find_duplicate_field_values(fields_array)

    if duplicate_field_values.empty?
      { error: 'No Duplicate Results Found' }.to_json
    else
      # Return duplicate field values as JSON
      duplicate_field_values.to_json
    end
  else
    # Handle missing field parameter with a 400 status code
    status 400
    { error: 'Missing field parameter' }.to_json
  end
end
