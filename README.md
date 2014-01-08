# OrderUp 

A queue agnostic interface for Rails. Currently only Resque is supported, but we'd like to add other implementations if you want to contribute one.

## Installation

Add this line to your application's Gemfile:

    gem 'order_up'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install order_up

## Usage

Create a config file: `config/resque.yml`

```yaml
  development: localhost:6379
  test: localhost:6379
  production: redis1.ae.github.com:6379
```

Then make an initializer that reads the yaml file and sets up Resque:

```ruby
  # config/initializers/resque.rb
  rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
  rails_env = ENV['RAILS_ENV'] || 'development'

  config = YAML::load_file(rails_root + '/config/resque.yml')
  Resque.redis = config[rails_env]

  Resque.inline = rails_env == 'test'
  Resque.redis.namespace = "myproject:#{rails_env}"
```

Now you can push jobs into the queue:
```ruby
class MyJob
  def initialize(file_id, message)
    @file_id = file_id
    @message = message
  end

  def run
    File.find(@file_id).deliver(@message)
  end
end

my_job = MyJob.new(123, "It works!")
OrderUp.push(my_job)
```

The initalizer will be called when the job is created, and the `run` method
will be invoked when the job is processed asynchronously.

### Running the background workers
First add to your `Rakefile`
```ruby
require 'resque/tasks'
```
Then you can invoke the rake task:

```bash
$ QUEUE=* rake environment resque:work
```

### See also
(https://github.com/resque/resque/tree/1-x-stable)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/order_up/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
