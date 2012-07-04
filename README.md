# RSpec matchers and examples for your Chef recipes

Test your Chef cookbooks nicely.

This project is heavily inspired by RSpec-puppet.

## Installation

```
gem install rspec-chef
```

## Example groups

### Recipes

Follow this structure to organize your recipes:

```
library
  |
  +-- cookbooks
  |
  +-- specs
        |
        +-- recipes
        |     |
        |     +-- <recipe_name>_spec.rb
        |
        +-- providers
              |
              +-- <lwrp_name>_spec.rb
```

Or force the example group into the spec:

```ruby

describe 'cookbook::recipe', :type => :recipe do
  ...
end
```

or, for an LWRP test:

```ruby

describe 'cookbook_provider', :type => :provider do
  ...
end
```

## Matchers

All of the standard RSpec matchers are available for you to use when testing Chef recipes.

*Checking if a recipe contains a resource*

Use the matcher `contain_<resource_type>` matcher:

```ruby
  it { should contain_remote_file }
```

It can take the name of the resource as a parameter:

```ruby
  it { should contain_remote_file('/etc/chef/dna.json') }
```

It can take the parameters that the resource takes:

```ruby
  it { should contain_remote_file('/etc/chef/dna.json', {:action => :nothing}) }
```

Use the chained method `with` to test the further attributes that the resource gets:

```ruby
  it { should contain_remote_file('/etc/chef/dna.json').with(:source, 'dna.json.erb') }
```

Use the chained method `without` to the the resource doesn't get further unexpected attributes:

```ruby
  it { should contain_remote_file('/etc/chef/dna.json').without(:owner, :group) }
```

## Settings

*Log level*

The Chef log level can be specified using `let` for each group:

```ruby
describe 'foo::bar' do
  let(:log_level) { :debug }
end
```

Or it can be set as a global RSpec setting:

```ruby
RSpec.configure do |c|
  c.log_level = :debug
end
```

*Cookbooks path*

The path to the cookbooks can be specified using `let` for each group:

```ruby
describe 'foo::bar' do
  let(:cookbook_path) { File.expand_path('../cookbooks', __FILE__) }
end
```

Or it can be set as a global RSpec setting:

```ruby
RSpec.configure do |c|
  c.cookbook_path = File.expand_path('../cookbooks', __FILE__)
end
```

where it can also be set as an array of paths, which will be searched in turn:

```ruby
RSpec.configure do |c|
  c.cookbook_path = [
    File.expand_path('../site-cookbooks', __FILE__),
    File.expand_path('../cookbooks', __FILE__)
  ]
end
```

*JSON attributes*

Each recipe includes a node. This node can be feeded with a hash using `let` in the description group:

```ruby
describe 'foo::bar' do
  let(:json_attributes) { {:foo => :bar} }
end
```

With a file in our file system:

```ruby
describe 'foo::bar' do
  let(:json_attributes) { '/etc/chef/dna.json' }
end
```

Or with plain JSON:

```ruby
describe 'foo::bar' do
  let(:json_attributes) { '{"foo": "bar"}' }
end
```

The JSON attributes can also be set as a global RSpec setting:

```ruby
RSpec.configure do |c|
  c.json_attributes = {:foo => :bar}
end
```

Default attributes may also be specified, to which the json_attributes will be added:

```ruby
RSpec.configure do |c|
  c.default_attributes = {:foo => :bar}
end
```

*LWRP Resource Specification*

When testing LWRP providers, the corresponding resource may be defined using let:

```ruby
describe 'foo::bar' do
  let(:resource) {
    { :foo => 'bar' }
  }
end
```
