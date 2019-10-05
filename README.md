# JsonToCsv
Convert and export JSON as CSV.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_to_csv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_to_csv

## Usage

The most basic usage is to convert an array of hash into a CSV string:
```rb
JsonToCsv.new([{a: 1, b: 2}]).csv
#=> "a,b\n1,2\n"
```

You can import JSON from a file or an array of hash:
```rb
JsonToCsv.new([{a: 1, b: 2}])
JsonToCsv.new('./data.json')
```

You can then either export it as a file or a string:
```rb
converter = JsonToCsv.new([{a: 1, b: 2}]) # import the array
converter.csv
 #=> "a,b\n1,2\n"
converter.export('./out.csv') # writes the csv to ./out.csv, if no argument if given to #export it will use ./export.csv
```

By defaults it uses `,` as a column separator for the csv. But it can be changed with the `separator` option:
```rb
JsonToCsv.new('./data.json', separator: ';')
```

If there is a nested hash in the json data, keys will be merged with a `.`, it can be changed with the `json_separator` option:
```rb
JsonToCsv.new('./data.json', json_separator: '_')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Tests

All tests are located in the `spec/` directory.

You can run tests with `rspec` (or `rspec -f d --color --dry-run` for more information)

