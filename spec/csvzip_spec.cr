require "./spec_helper"
require "file_utils"

describe Csvzip do
  describe Csvzip::Compressor do
    it "compresses the provided columns" do
      input_file = "spec/fixtures/trains.csv"
      output_file = "out.csv"
      dictionary_file = "dictionary.json"
      dictionary_key = "csvzip_test"
      separator = ','
      quote_char = '"'

      # Ensure output files are removed
      FileUtils.rm(output_file) if File.exists?(output_file)
      FileUtils.rm(dictionary_file) if File.exists?(dictionary_file)

      c = Csvzip::Compressor.new input_file, output_file,
        ["origin", "destination", "train_type", "train_class", "fare"],
        dictionary_file, dictionary_key,
        separator, quote_char
      c.compress

      File.exists?(output_file).should eq true
      File.exists?(dictionary_file).should eq true

      dictionary = File.open(dictionary_file) do |file|
        JSON.parse(file)
      end

      File.open(output_file) do |infile|
        reader = CSV.new(infile, header = true, strip = true)
        reader.next
        row = reader.row.to_h
        dictionary[dictionary_key]["origin"][row["origin"]].should eq "MADRID"
        dictionary[dictionary_key]["destination"][row["destination"]].should eq "BARCELONA"
      end

      # Ensure output files are removed
      FileUtils.rm(output_file)
      FileUtils.rm(dictionary_file)
    end
  end
end
