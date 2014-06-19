# Capistrano::Secret

A [Capistrano](http://capistranorb.com/) gem to isolate secret information.

When developing, it is imperative to keep secret information (server names, login, passwords,...) out of source control.
This usually leads to cumbersome and risky setups, especially when combined with a deployment tool (like Capistrano).

This tiny gem provides methods to **easily** do the **right thing**: conveniently tuck all secrets in a JSON file in a dedicated folder, and easily the information from the rest of the Capistrano tasks.


## Quick start

```bash
gem install capistrano-secret
echo "require 'capistrano/secret'" >> Capfile
mkdir config/secret
echo "config/secret" >> .gitignore
echo '{"secret":{"of": {"life": 42}}}' > config/secret/production.json
```

Then in Capistrano access any secret with:
```ruby
secret('secret.of.life');
```


## Features

Here are capistrano-secret's advantages over alternatives (like keeping whole config files out of repository)

* All secret information in one unique place: no duplication, easy to keep out of repository.
* Files contain only secret: no mixing with other, non-sensitive information (like configuration directives).
* Standard JSON syntax.
* Each stages has its own set of secrets.
* Method name makes it explicit to developer this is sensitive information (it's called `secret()`!).

Full power shows when used in conjunction with a templating library like [capistrano-template](https://github.com/xavierpriour/capistrano-template), to generate configuration files at deployment.

## Requirements

* [Capistrano 3](http://capistranorb.com/)

All dependencies are listed in the .gemspec file so if using `bundler` you just need to `bundle install` in your project directory.


## Installation

Add this line to your application's Gemfile:
```
gem 'capistrano-template'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install capistrano-template
```


## Usage

Include gem in your `Capfile`:
```ruby
require 'capistrano/secret'
```

Create directory where secret information will be stored.
Default is `config/secret`, to use a different one define `secret_dir` in `deploy.rb`:
```ruby
set :secret_dir, 'new/secret/dir'
```

Ensure the directory stays out of repository (for git, add it to `.gitignore`):
```bash
echo 'config/secret' >> .gitignore
```

Then in the directory, create one JSON file per stage (same name as the stage):
```bash
touch config/secret/production.json
```

In the files, define keys as needed, using JSON syntax. For example:
```JSON
{
    "db" : {
        "user" : "user_db",
        "password" : "srwhntseithenrsnrsnire",
        "host" : "sql.yourdomain.com",
        "name" : "yourDB"
    },
    "mail" : {
        "mode" : "smtp",
        "user" : "myapp@yourdomain.com",
        "password" : "rastenhrtrethernhtr",
        "host" : "ssl://smtp.yourdomain.com",
    }
}
```

Then in your Capistrano tasks you can access any value using `secret('path.to.key')`.
The call is safe and will just return `nil` if all or part of the path leads nowhere.
So you can test the return value of any part of the path to see if an option is present - for example:
```ruby
if secret('mail') then
    # do something with mail info, like send a msg after deploy
end
```

## Contributing
1. Fork it ( https://github.com/xavierpriour/capistrano-secret/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request