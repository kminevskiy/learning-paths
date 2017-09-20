require 'spec_helper'

options = {
  domains: Dir.pwd + '/spec/mock_data/domains.csv',
  students: Dir.pwd + '/spec/mock_data/students.csv',
  output: Dir.pwd + '/spec/mock_data/'
}

InputValidator.validate(options)

describe CsvParser do
  let!(:parser) { CsvParser.new(options) }

  after do
    file_to_delete = options[:output] + 'report.csv'
    File.delete file_to_delete if File.exist? file_to_delete
  end

  it 'creates domain paths mappings' do
    parser.create_domain_mappings

    expect(parser.domain_mappings).not_to be_empty
    expect(parser.domain_mappings).to include("K.RI")
  end

  it 'creates domain/score mappings for students' do
    random_student = parser.students_file.sample
    student_name = random_student.first

    parser.create_student_mappings

    expect(parser.student_mappings).not_to be_empty
    expect(parser.student_mappings).to include(student_name)
  end

  it 'constructs new learning paths for students' do
    parser.create_domain_mappings
    parser.create_student_mappings
    parser.create_learning_paths

    expect(parser.learning_paths).not_to be_empty
    expect(parser.learning_paths.first.length).to eq 6
  end

  it 'saves learning paths results in a file' do
    parser.create_resulting_report

    expect(File.exist? options[:output]).to be_truthy
  end
end
