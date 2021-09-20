# ForwardTo

ForwardTo provides a #forward_to method that can be used to forward methods to
a member object. It resembels the rails #delegate method but with a different
syntax

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'forward_to'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install forward_to

## Usage

You will typically include the ForwardTo module globally to have #forward_to
available everywhere:

    require 'forward_to'

    include ForwardTo

    class A
      forward_to :@implementation, :size, :[], :[]=
      def initialize() @implementation = [] end
    end

The first argument to #forward_to is the target object. It can be a member
method or an instance variable but in both cases it has to be specified as a
Symbol. The rest of the arguments are names of the member methods (Symbol) that
will be forwarded to the target. Using the definitions above it is possible to
do

    a = A.new
    puts a.size # => 0

    a[0] = 1
    puts a[0] # => 1

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/clrgit/forward_to.
