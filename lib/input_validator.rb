module InputValidator
  def self.validate(options)
    validate_domains_file(options[:domains])
    validate_students_file(options[:students])
    set_default_output_file(options)
  end

  private

  def self.set_default_output_file(options)
    unless options[:output]
      options[:output] = Dir.pwd + '/'
    end

    options
  end

  def self.validate_domains_file(option)
    unless option && file_exists(option)
      puts 'Please provide the correct path to the domains file.'
      exit 1
    end
  end

  def self.validate_students_file(option)
    unless option && file_exists(option)
      puts 'Please provide the correct path to the students file.'
      exit 1
    end
  end

  def self.file_exists(path)
    File.exist? path
  end
end
