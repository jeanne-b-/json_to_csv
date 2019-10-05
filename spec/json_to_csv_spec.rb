require 'spec_helper'

RSpec.describe JsonToCsv do
  before(:example) do
    @converter = JsonToCsv.new('./spec/files/users.json')
  end
  
  it "has a version number" do
    expect(JsonToCsv::VERSION).not_to be nil
  end

  it 'imports the file as an array of hash' do
    expect(@converter.json).to be_a_kind_of(Array)
    expect(@converter.json.all? {|elem| elem.is_a?(Hash) }).to be true
  end

  it 'contains the expected keys' do
    expect(@converter.json.all? {|elem| elem.has_key?("id")}).to be true
    expect(@converter.json.all? {|elem| elem.has_key?("email")}).to be true
  end
end
