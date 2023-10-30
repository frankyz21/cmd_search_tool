require 'json'
require_relative 'parameters_parser'
require 'byebug'

class ClientManager
  def initialize(file_path)
    @data = load_data(file_path)
  end

  # Load client data from a JSON file
  def load_data(file_path)
    json_data = File.read(file_path)
    JSON.parse(json_data)
  end

  # Search for clients based on query parameters
  def search_clients(query)
    @data.select do |client|
      # Currently Check if any of the specified fields partially match the 

      #  query.keys.all? if you want both fields to match.
      matches = query.keys.all? do |field|
        client[field].to_s.downcase.include?(query[field].downcase)
      end
      matches
    end
  end

  # Find duplicate field values in client data
  def find_duplicate_field_values(*fields)
    fields = fields.flatten
    # Initialize a hash to store counts and records for duplicate field values
    field_values_count = Hash.new { |hash, key| hash[key] = { count: 0, records: [] } }
    
    @data.each do |client|
      # Get values for specified fields
      field_values = fields.map { |field| client[field] }
      # Convert field values to a string for grouping duplicates
      field_values_str = field_values.join(', ')
      
      # Increment the count and store the record for each duplicate value
      field_values_count[field_values_str][:count] += 1
      field_values_count[field_values_str][:records] << client
    end
    
    # Select and return duplicates based on count
    field_values_count.select { |_, data| data[:count] > 1 }
  end
end
