require 'spec_helper'

valid_options = {
  domains: Dir.pwd + '/spec/mock_data/domains.csv',
  students: Dir.pwd + '/spec/mock_data/students.csv',
  output: Dir.pwd
}

invalid_options = {
  domains: Dir.pwd + '/spec/mock_data/students.csv'
}

describe InputValidator do
  context 'with valid input' do
    it 'sets the default output path' do
      InputValidator.validate(valid_options)

      expect(valid_options[:output]).to eq Dir.pwd
    end

    it 'sets the report directory to the correct one if the output option has been specified' do
      old_output_path = valid_options[:output]
      valid_options[:output] = Dir.pwd + '/spec'

      InputValidator.validate(valid_options)

      expect(valid_options[:output]).not_to eq old_output_path
    end
  end

  context 'with invalid input' do
    it 'gracefully exits the program if no students or domains files have been provided' do

      begin
        InputValidator.validate(invalid_options)
      rescue SystemExit => e
        expect(e.status).to eq 1
      end
    end
  end
end
