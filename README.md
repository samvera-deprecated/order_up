# Hydra::Queue

A queue agnostic interface for Rails.

## Installation

Add this line to your application's Gemfile:

    gem 'hydra-queue'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hydra-queue

## Usage

Create a config file: `config/resque.yml`

```yaml
  development: localhost:6379
  test: localhost:6379
  production: redis1.ae.github.com:6379

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
Hydra::Queue.push(my_job)
```

The initalizer will be called when the job is created, and the `run` method
will be invoked, when the job is processed asynchronously.

### Running the jobs

```bash
$ QUEUE=* rake environment resque:work
```

### See also
(https://github.com/resque/resque/tree/1-x-stable)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/hydra-queue/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
