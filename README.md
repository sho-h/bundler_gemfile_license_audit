# BundlerGemfileLicenseAudit

Audit Gemfile's license dependency violations.

## Installation

Add this line to your application's Gemfile:

```ruby
$ gem 'bundler_gemfile_license_audit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bundler_gemfile_license_audit

## Usage

To make bundler to use this gem as well, you need to load the rubygems_plugin before. The easiest way is to make an alias in your ~/.bashrc or so:

```
$ alias bundle='RUBYOPT="-rbundler_gemfile_license_audit" bundle'
```

Check license on bundle install.

```
$ bundle install
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bundler_gemfile_license_audit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
