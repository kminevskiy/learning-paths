#!/usr/bin/env ruby

require 'optparse'
require 'csv'

require_relative './lib/input_validator'
require_relative './lib/csv_parser'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on '-d [STRING]', '--domains-file [STRING]', 'Path to domains file.' do |domains|
    options[:domains] = domains
  end

  opts.on '-s [STRING]', '--students-file [STRING]', 'Path to students test file.' do |students|
    options[:students] = students
  end

  opts.on '-o [STRING]', '--output-file [STRING]', 'Path to resulting report file.' do |path|
    options[:output] = path
  end

  opts.on("-h", "--help", "show this help") do
    puts opts
    exit
  end
end.parse!

opts = InputValidator.validate(options)
parser = CsvParser.new(opts)
parser.create_resulting_report

