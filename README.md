# PE Accounting Ruby Client

A simple low-level wrapper for PE Accounting's public API.
It's publicly available at https://my.accounting.pe/api/v1/doc
 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pe_accounting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pe_accounting

## Usage

```ruby
require 'pe_accounting'

# Initialize the API
api = PeAccounting::Client.new('your-api-token')

# Fetch a list of all the given company's clients. Returns a ruby Array or Hash, depending on the ressource's specifications
clients = api.get(company_id: 123, request: 'client')

puts clients

##
# [
# {"id"=>12345, "foreign-id"=>"", "name"=>"fdsmfkls", "contact"=>"fslmdkfsdmlkf", "address"=>{"address1"=>"sdfmsdlmfksdm", "address2"=>"", "zip-code"=>"12345", "state"=>"msdlfkdsmlk", "country"=>"sdflkdslkfj"}, "email"=>"sdflkjsfs@fdsd.fr", "country-code"=>"FR", "accountnr"=>0, "payment-days"=>14, "orgno"=>"123456-1234", "phone"=>"+33123456789", "user"=>{"id"=>12345}, "delivery-type"=>"Email", "vat-nr"=>"", "template"=>{"id"=>1234}, "active"=>true},
# {"id"=>9876, "foreign-id"=>"", "name"=>"fdsmfkls", "contact"=>"fslmdkfsdmlkf", "address"=>{"address1"=>"sdfmsdlmfksdm", "address2"=>"", "zip-code"=>"12345", "state"=>"msdlfkdsmlk", "country"=>"sdflkdslkfj"}, "email"=>"sdflkjsfs@fdsd.fr", "country-code"=>"FR", "accountnr"=>0, "payment-days"=>14, "orgno"=>"123456-1235", "phone"=>"+33123456789", "user"=>{"id"=>9875}, "delivery-type"=>"Email", "vat-nr"=>"", "template"=>{"id"=>1234}, "active"=>true}
# ]
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ridem/pe-accounting-ruby-client.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
