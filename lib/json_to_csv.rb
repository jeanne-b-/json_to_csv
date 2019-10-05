# require "json_to_csv/version"
require 'json'
require 'csv'

class JsonToCsv
  attr_accessor :json, :separator

  def initialize(json_file, params = {})
    @json = JSON.parse(File.read(json_file))
    @separator = params.fetch(:separator, ',')
  end
end
