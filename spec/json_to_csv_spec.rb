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

  it 'makes a CSV' do
    expect(@converter.csv).to be_a_kind_of(String)
  end

  it 'users.json is correctly made as a csv string' do
    expect(@converter.csv).to eq File.read('./spec/files/users.csv')
  end 

  it 'users.json is exported as a csv file' do
    export_path = './spec/files/export.csv'
    @converter.export(export_path)
    expect(File.exists?(export_path)).to be true
    expect(File.read(export_path)).to eq File.read('./spec/files/users.csv')
  end

  it 'stringifies the value if it contains a column separator' do
    @converter.json = [{'a': "lorem,ipsum"}]
    expect(@converter.csv).to eq "a\n\"lorem,ipsum\"\n"
  end

  context('flatten_hash') do
    it 'flattens deeply nested hash' do
      expect(@converter.send(:flatten_hash, {z: 0, a: {b: {c: 1}}})).to eq({'z' => 0, 'a.b.c' => 1})
    end

    it 'flattens arrays' do
      expect(@converter.send(:flatten_hash, {z: [1,2,3]})).to eq({'z' => "1,2,3"})
    end
  end

  context('handles errors') do
    it 'handles an empty json' do
      converter = JsonToCsv.new([])
      expect(converter.csv).to eq ""
    end

    it 'throws an error if the file does not exist' do
      expect { JsonToCsv.new('./dsakjkdsjakdlsa.json') }.to raise_error(Errno::ENOENT)
    end

    it 'throws an error if the argument is not valid' do
      expect { JsonToCsv.new(123) }.to raise_error(ArgumentError)
    end
  end

  context('has options') do
    it 'changes column separator' do
      converter = JsonToCsv.new([a: 1, b: 2], separator: ';')
      expect(converter.csv).to eq "a;b\n1;2\n"
    end

    it 'changes json separator' do
      converter = JsonToCsv.new([{a: {b: 2}}], json_separator: ';')
      expect(converter.csv).to eq "a;b\n2\n"
    end
  end
end
