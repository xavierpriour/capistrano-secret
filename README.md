# capistrano-secret

A Capistrano gem to isolate secret information.

When developing, it is imperative to keep secret information (server names, login, passwords,...) out of source control.
This usually leads to cumbersome and risky setups, especially when combined with a deployment tool (like Capistrano).

This tiny gem provides methods to **easily** do the **right thing**: conveniently tuck all secrets in a JSON file in a dedicated folder, and easily the information from the rest of the Capistrano tasks.

## Quick start

Get the library:
```ruby
gem install capistrano-secret
```

Load it into your `Capfile`:
```ruby
require 'capistrano/secret'
```

Create secret directory and add it to `.gitignore`:
```
config/secret
```

Then in Capistrano access any secret with:

```ruby
secret('mail.user');
```

## Features

Here are capistrano-secret's advantages over alternatives (like keeping secret)

* All secret information in one unique place: no duplication, easy to keep out of repository.
* Files contain only secret: no mixing with other, non-sensitive information (like configuration directives).
* Standard JSON syntax.
* Each stages has its own set of secrets.
* Method name makes it explicit to developer this is sensitive information (it's called `secret()`!).

Full power shows when used in conjunction with a templating library like capistrano-template, to generate configuration files at deployment.

## Requirements

* Capistrano 3

## Usage

Get the gem, either manually:
```ruby
gem install capistrano-secret
```

Or using `bundler`, add the library to your `Gemfile`:
```ruby
gem 'capistrano-secret', require: false
```

Include gem in your `Capfile`:
```ruby
require 'capistrano/secret'
```

Create directory where secret information will be stored.
Default is `config/secret`, to change it update `deploy.rb`:
```ruby
set :secret_dir, '.secrets'
```

Ensure the directory stays out of repository.
For example, with git, add it to `.gitignore`:
```
config/secret
```

Then in the directory, create one JSON file per stage (same name as the stage):
```
config/secret/production.json
```

In the files, define keys as needed:
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
So you can test the return value to see if an option is present:
```ruby
if secret('mail') then
    # do something with mail info, like send a msg after deploy
end
```