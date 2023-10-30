# cli_spec.rb

RSpec.describe 'Test CLI Commands' do
  context 'search command' do
    it 'returns matching clients by name' do
      output = `ruby cli.rb search full_name="John"`
      expect(output).to include("John Doe (john.doe@gmail.com)")
    end

    it 'returns matching clients by name and email' do
      output = `ruby cli.rb search full_name="John"`
      expect(output).to include("John Doe (john.doe@gmail.com)")
    end

    it 'handles missing query parameter' do
      output = `ruby cli.rb search`
      expect(output).to include("Usage: ruby cli.rb search field=value [field=value]...")
      expect($?.exitstatus).to eq(0)  # Ensure the exit status is 0 for a usage message
    end
  end

  context 'duplicates command' do
    it 'returns duplicate' do
      #defaults to email
      output = `ruby cli.rb duplicates`
      expect(output).to include("john.doe@gmail.com")
      expect(output).to include("jane.smith@yahoo.com")
    end

    it 'returns duplicate emails' do
      output = `ruby cli.rb duplicates email`
      expect(output).to include("john.doe@gmail.com")
      expect(output).to include("jane.smith@yahoo.com")
    end

    it 'returns duplicate emails' do
      output = `ruby cli.rb duplicates email full_name`
      expect(output).to include("john.doe@gmail.com")
      expect(output).not_to include("jane.smith@yahoo.com")
    end

  end
end
