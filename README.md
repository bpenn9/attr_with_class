# AttrWithClass

Ruby metaprogramming helpers that create type-safe attribute accessors

```ruby
class SomeClass
  attr_accessor_with_class String, :some_string, :some_other_string
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attr_with_class'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attr_with_class

## Usage

```ruby
class Person
  attr_accessor_with_class String, :name, :email

  attr_accessor_with_non_negative_integer Integer, :age

  attr_accessor_with_handler :favourite_ice_cream do |val|
    raise ArgumentError, "must be a valid flavour" unless ["vanilla", "chocolate"].include(val)
    val
  end
end

person = Person.new

person.name = "Alice"    # works
person.name = 123        # raises ArgumentError: 123 is not a String

person.age = 30          # works
person.age = -1          # raises ArgumentError: -1 is not a non-negative integer

person.favourite_ice_cream = "vanilla"
person.favourite_ice_cream = "pistachio" #raises ArgumentError: must be a valid flavour
```

### Available Methods

`attr_writer / attr_accessor _with_handler(*attrs, &block)`
writer or accessor with custom validation/transformation block


`attr_writer / attr_accessor _with_class(klass, *attrs)`
writer or accessor that enforces class (or subclass) 


`attr_writer / attr_accessor _with_non_negative_integer(*attrs)`
writer or accessor that enforces non-negative integers 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bpenn9/attr_with_class.
