# capistrano-secret

A Capistrano gem to isolate secret information.

When using Capistrano, it is imperative to keep secret information (server names, login, passwords,...) out of source control yet accessible to the tool.
This tiny gem provides methods to conveniently tuck this info in JSON files in a dedicated folder, and explicitly access this as secret information.

## Quick start
Add the library to your `Gemfile`:

```ruby
gem 'capistrano-secret', require: false
```

Load it into your deployment script `config/deploy.rb`:

```ruby
require 'capistrano-secret'
```

Add your secret directory to `.gitignore`:
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

No external dependencies.

## Usage

Include gem

Require in `deploy.rb`

Create directory where secret information will be stored.
Default is `config/secret`, to change it update `deploy.rb`:

```ruby
set :secret_dir, '.secrets'
```

Ensure the directory stays out of repository.
With git, add it to `.gitignore`:
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
