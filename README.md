# Encookie

`encookie` is a Ruby gem that provides a Rack session middleware implementation.
This implementation stores all data in the HTTP cookies - like `Rack::Session::Cookie`,
but also encrypts the contents of the cookies so it cannot be read by the user.

Encryption **and** authentication is provided by OpenSSL's `aes-128-gcm` cipher.
This means that there is no need for a separate MAC step or a second key.

## Usage

```ruby
# Gemfile
gem 'encookie'

# config.ru
require 'encookie'
key = ['7881e46e1e40484756485019038703c2'].pack 'H*'
use Rack::Session::Encookie, key: key

# app.rb
get '/' do
  session[:yourdata] = 'super secret persistent data'
end
````

Bug reports and pull requests are welcome on GitHub at https://github.com/glassechidna/encookie.

