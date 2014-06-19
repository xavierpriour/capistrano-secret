require "capistrano/secret/version"

module Capistrano
  module Secret
    # Your code goes here...
  end
end

load File.expand_path('../secret/tasks/secret.cap', __FILE__)