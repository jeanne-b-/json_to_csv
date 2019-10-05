require "json_to_csv/version"
require 'json'
require 'csv'

class JsonToCsv
  attr_accessor :json, :separator, :json_separator

  def initialize(array_or_file, params = {})
    if array_or_file.is_a? String
      @json = JSON.parse(File.read(array_or_file))
    elsif array_or_file.is_a? Array and array_or_file.all? {|elem| elem.is_a? Hash}
      @json = array_or_file
    else
      raise ArgumentError, 'Argument should be a file or an array of hash'
    end

    @separator = params.fetch(:separator, ',')
    @json_separator = params.fetch(:json_separator, '.')
  end

  def csv
    return "" unless json.any?
    flattened_json = json.map { |hash| flatten_hash(hash) }
    csv_string = CSV.generate(col_sep: @separator) do |csv|
      csv << flattened_json.first.keys
      flattened_json.each do |elem|
        csv << elem.values
      end
    end
    csv_string
  end

  def export(file_name = './export.csv')
    File.open(file_name, 'w+') do |f|
      f.write(csv)
    end
  end

  private

  def flatten_hash(hash)
    hash.each_with_object({}) do |(key, value_or_hash), h|
      if value_or_hash.is_a? Hash
        flatten_hash(value_or_hash).map do |child_key, child_value_or_hash|
          h["#{key}#{json_separator}#{child_key}"] = child_value_or_hash
        end
      elsif value_or_hash.is_a? Array
        h[key.to_s] = value_or_hash.join(',')
      else
        h[key.to_s] = value_or_hash
      end
    end
  end

end
