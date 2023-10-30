# Import the ClientManager class from the 'client_manager' library.
require_relative 'lib/client_manager'

manager = ClientManager.new('./data/clients.json')

if $PROGRAM_NAME == __FILE__
  # Check the command-line arguments for specific commands.
  query = ParametersParser.parse(ARGV[1..])
  
  if ARGV[0] == 'search' && query
        
    # Search for matching clients based on the query.
    matching_clients = manager.search_clients(query)

    # Display a message if no matching clients are found.
    if matching_clients.empty?
      puts "No Results Found"
    end
    matching_clients.each { |client| puts "#{client['full_name']} (#{client['email']})" }
  elsif ARGV[0] == 'duplicates'
    fields = (fields = ARGV[1..-1]).nil? || fields.empty? ? ["email"] : fields
    
    # Find duplicate field values for the specified fields.
    duplicate_values = manager.find_duplicate_field_values(*fields)

    # Display a message if no duplicate values are found.
    if duplicate_values.empty?
      puts "No Duplicate Results Found"
    end
    duplicate_values.each do |field_values, data|
      puts "#{field_values}, count: #{data[:count]}\nrecords: #{data[:records]}\n\n"
    end
  else
    puts "Usage: ruby cli.rb search field=value [field=value]..."
  end
end
