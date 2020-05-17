require "option_parser"
require "./csvzip"

input_file = ""
output_file = ""
dictionary_file = ""
dictionary_key = ""
columns = ""
separator = ""
quote_char = ""

OptionParser.parse do |parser|
  parser.banner = "csvzip is a standalone CLI tool to reduce CSVs size by converting categorical columns in a list of unique integers\n" \
                  "The execution produces two files: a CSV with the compressed values and a JSON dictionary with the mappings.\n\n" \
                  "‼️ Current limitations in input CSV file:‼️ \n" \
                  " - the CSV has to have a headers row\n" \
                  "More information, usage examples and candies at:\n" \
                  "https://github.com/PopulateTools/csvzip\n\n" \
                  "Usage: csvzip"
  parser.on("-i INPUT", "--input=INPUT", "Input CSV file (required)") { |value| input_file = value }
  parser.on("-o OUTPUT", "--output=OUTPUT", "Output CSV file (required)") { |value| output_file = value }
  parser.on("-c COLUMNS", "--columns=COLUMNS", "Columns to compress, in a comma separated format. Example: \"col1, col2, col5\" (required)") { |value| columns = value }
  parser.on("-d DICTIONARY", "--dictionary=DICTIONARY", "Output dictionary file, in JSON format. Default: dictionary.json") { |value| dictionary_file = value }
  parser.on("-k KEY", "--dictionary-key=KEY", "First level key in dictionary. Default: csvzip") { |value| dictionary_key = value }
  parser.on("-s SEPARATOR", "--separator=SEPARATOR", "CSV column separator. Default: comma") { |value| separator = value }
  parser.on("-q QUOTE_CHAR", "--quote-char=QUOTE_CHAR", "CSV quote character. Default: double quotes") { |value| quote_char = value }
  parser.on("--version", "Print version") { puts "csvzip version #{Csvzip::VERSION}"; exit(0) }
  parser.on("-h", "--help", "Show this help") { puts parser; exit(0) }

  parser.unknown_args do |args|
    # filter out unknown options
    unk_args = args.find { |s| !s.starts_with?("-") }
    if !unk_args.nil?
      STDERR.puts "ERROR: this program does not need arguments!"
      STDERR.puts parser
      exit(1)
    end
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
  parser.missing_option do |flag|
    STDERR.puts "ERROR: incomplete or missing option '#{flag}'."
    STDERR.puts parser
    exit(1)
  end
end

# Arguments checks
# Input file
if input_file == ""
  STDERR.puts "ERROR: input file is required"
  exit(1)
end

# Output file
if output_file == ""
  STDERR.puts "ERROR: output file is required"
  exit(1)
end

# Columns
if columns == ""
  STDERR.puts "ERROR: columns list is required"
  exit(1)
end

# Dictionary
if dictionary_file == ""
  dictionary_file = "dictionary.json"
end

# Dictionary key
if dictionary_key == ""
  dictionary_key = "csvzip"
end

if separator == ""
  separator = ","
end

if quote_char == ""
  quote_char = "\""
end

columns_list = columns.split(",").map { |v| v.strip }

begin
  c = Csvzip::Compressor.new(input_file, output_file, columns_list, dictionary_file, dictionary_key, separator.chars.first, quote_char.chars.first)
  c.compress
  exit(0)
rescue ex
  STDERR.puts "ERROR: #{ex.message}"
  exit(1)
end
