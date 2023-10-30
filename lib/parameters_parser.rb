require 'byebug'
class ParametersParser
  def self.parse(params)
    # If the input is already a hash, simply return it.
    return params if params.is_a?(Hash)
    return nil if params.nil? || params.empty?

    search_fields = {}    
    # Iterate through each parameter in the array AND store in search_fields.
    params.each do |param|
      key, value = param.split("=")
      search_fields[key.to_s] = value
    end
    
    # Return the parsed query parameters as a hash.
    search_fields
  end
end
