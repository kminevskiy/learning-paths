class CsvParser
  attr_reader :domains_file, :students_file,
              :domain_mappings, :student_mappings,
              :learning_paths, :test_domains,
              :resulting_file

  def initialize(opts = {})
    @domains_file = parse_domains_file(opts[:domains])
    @students_file = parse_tests_file(opts[:students])
    @domain_mappings = []
    @student_mappings = {}
    @learning_paths = []
    @resulting_file = opts[:output]
  end

  def create_resulting_report
    create_domain_mappings
    create_student_mappings
    create_learning_paths
    create_report
  end

  def create_report
    report_file = resulting_file + 'report.csv'

    CSV.open(report_file, 'w') do |csv|
      csv << generate_report_header
      learning_paths.each do |learning_path|
        csv << learning_path
      end
    end
  end

  def create_domain_mappings
    domains_file.each do |level_paths|
      level, paths = split_first_last(level_paths)
      paths.each { |path| domain_mappings << level + '.' + path }
    end
  end

  def create_student_mappings
    students_file.each do |student|
      student_name, scores = split_first_last(student)
      student_mapping = {}

      0.upto(scores.size - 1) do |i|
        student_mapping[test_domains[i]] = scores[i]
      end

      student_mappings[student_name] = student_mapping
    end
  end

  def create_learning_paths
    student_mappings.each do |name, _|
      learning_paths << create_path_for_student(name)
    end
  end

  def create_path_for_student(student_name)
    learning_path = [student_name]

    domain_mappings.each do |level_domain|
      next if learning_path.size == 6
      level, domain = level_domain.split(/\./)
      student_level = student_mappings[student_name][domain]

      level = convert_edge_level(level)
      student_level = convert_edge_level(student_level)

      level_incomplete = determine_level(level, student_level)
      learning_path << level_domain if level_incomplete
    end

    learning_path
  end

  private

  def convert_edge_level(level)
    level == 'K' ? '0' : level
  end

  def determine_level(level, other_level)
    level >= other_level
  end

  def split_first_last(mapping)
    [mapping[0], mapping[1..-1]]
  end

  def parse_domains_file(path)
    CSV.read(path)
  end

  def parse_tests_file(path)
    parsed_file = CSV.read(path)
    @test_domains = parsed_file.first[1..-1]
    @student_scores = parsed_file[1..-1]
  end

  def generate_report_header
    ['Student Name', 'Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5']
  end
end
