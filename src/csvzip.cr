require "csv"
require "json"

module Csvzip
  VERSION = "0.2.0"

  class Compressor
    def initialize(
      @input_file : String,
      @output_file : String,
      @columns : Array(String),
      @dictionary_file : String,
      @dictionary_key : String,
      @separator : Char,
      @quote_char : Char
    )
      @dictionary = {} of String => Hash(String, Hash(String, String))
      @dictionary[@dictionary_key] = {} of String => Hash(String, String)
    end

    def compress
      File.open(@input_file) do |infile|
        reader = CSV.new(infile, header = true, strip = true, separator = @separator, quote_char = @quote_char)

        File.open(@output_file, "w") do |outfile|
          CSV.build(outfile) do |writer|
            # Add output headers
            writer.row reader.headers

            while reader.next
              row = reader.row.to_h
              @columns.each do |column|
                key = row[column].strip

                # Initialize the dictionary column
                @dictionary[@dictionary_key][column] ||= {} of String => String

                # Setup a encoded value for the key if it doesn't exist
                @dictionary[@dictionary_key][column][key] ||= @dictionary[@dictionary_key][column].keys.size.to_s

                # Update row with the encoded value
                row[column] = @dictionary[@dictionary_key][column][key]
              end
              writer.row row.values
            end
          end
        end
      end

      @columns.each do |column|
        @dictionary[@dictionary_key][column] = @dictionary[@dictionary_key][column].invert
      end

      File.open(@dictionary_file, "w") do |file|
        @dictionary.to_json(file)
      end
    end
  end
end
