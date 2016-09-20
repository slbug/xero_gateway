Xero API wrapper [![Build Status](https://travis-ci.org/xero-gateway/xero_gateway.svg?branch=master)](https://travis-ci.org/xero-gateway/xero_gateway) [![Gem Version](https://badge.fury.io/rb/xero_gateway.svg)](https://badge.fury.io/rb/xero_gateway)
================

# Getting Started

This is a Ruby gem for communicating with the Xero API.
You can find more information about the Xero API at <https://developer.xero.com>.

## Installation

Just add the `xero_gateway` gem to your Gemfile, like so:

```ruby
  gem 'xero_gateway'
```

## Usage

```ruby
  gateway = XeroGateway::Gateway.new(YOUR_OAUTH_CONSUMER_KEY, YOUR_OAUTH_CONSUMER_SECRET)
```

### Authenticating with OAuth

The Xero Gateway uses [OAuth 1.0a](https://oauth.net/core/1.0a/) for authentication. Xero Gateway
implements OAuth in a very similar manner to the [Twitter gem by John Nunemaker](http://github.com/jnunemaker/twitter)
, so if you've used that before this will all seem familiar.

  1. **Get a Consumer Key & Secret**

    First off, you'll need to get a Consumer Key/Secret pair for your
    application from Xero.
    Head to <https://api.xero.com>, log in and then click My Applications
    &gt; Add Application.

    If you want to create a private application (that accesses your own Xero
    account rather than your users), you'll need to generate an RSA keypair
    and an X509 certificate. This can be done with OpenSSL as below:

    ```
      openssl genrsa –out privatekey.pem 1024
      openssl req –newkey rsa:1024 –x509 –key privatekey.pem –out publickey.cer –days 365
      openssl pkcs12 –export –out public_privatekey.pfx –inkey privatekey.pem –in publickey.cer
    ```

    On the right-hand-side of your application's page there's a box titled
    "OAuth Credentials". Use the Key and Secret from this box in order to
    set up a new Gateway instance.

    (If you're unsure about the Callback URL, specify nothing - it will
    become clear a bit later)

  2. **Create a Xero Gateway in your App**

    ```ruby
      gateway = XeroGateway::Gateway.new(YOUR_OAUTH_CONSUMER_KEY, YOUR_OAUTH_CONSUMER_SECRET)
    ```

    or for Private applications

    ```ruby
      require 'xero_gateway'
      gateway = XeroGateway::PrivateApp.new(YOUR_OAUTH_CONSUMER_KEY, YOUR_OAUTH_CONSUMER_SECRET, PATH_TO_YOUR_PRIVATE_KEY)
    ```

  3. **Creating a Request Token**

    You'll then need to get a Request Token from Xero.

    ```ruby
      request_token = gateway.request_token
    ```

    You should keep this around - you'll need it to exchange for an Access
    Token later. (If you're using Rails, this means storing it in the
    session or something similar)

    Next, you need to redirect your user to the authorization url for this
    request token. In Rails, that looks something like this:

    ```ruby
      redirect_to request_token.authorize_url
    ```

    You may also provide a callback parameter, which is the URL within your
    app the user will be redirected to. See next section for more
    information on what parameters Xero sends with this request.

    ```ruby
      request_token = request_token(oauth_callback: "https://yourapp.com/xero/callback")
      redirect_to request_token.authorize_url
    ```

  4. **Retrieving an Access Token**

    If you've specified a Callback URL when setting up your application or
    provided an oauth\_callback parameter on your request token, your user
    will be redirected to that URL with an OAuth Verifier as a GET
    parameter. You can then exchange your Request Token for an Access Token
    like this (assuming Rails, once again):

    ```ruby
      gateway.authorize_from_request(request_token.token, request_token.secret, oauth_verifier: params[:oauth_verifier])
    ```

    (If you haven't specified a Callback URL, the user will be presented
    with a numeric verifier which they must copy+paste into your
    application; see examples/oauth.rb for an example)

    Now you can access Xero API methods:

    ```ruby
      gateway.get_contacts
      # => #<XeroGateway::Response:0x007fd367181388 ...
    ```

### Storing Access Tokens

You can also store the Access Token/Secret pair so that you can access
the API without user intervention. Currently, these access tokens are
only valid for 30 minutes, and will raise a
`XeroGateway::OAuth::TokenExpired` exception if you attempt to access the
API beyond the token's expiry time.

```ruby
  access_token, access_secret = gateway.access_token
```

You can authorize a `Gateway` instance later on using the
`authorize_from_access` method:

```ruby
  gateway = XeroGateway::Gateway.new(XERO_CONSUMER_KEY, XERO_CONSUMER_SECRET)
  gateway.authorize_from_access(your_stored_token.access_token, your_stored_token.access_secret)
```

## Examples

Open examples/oauth.rb and change CONSUMER\_KEY and CONSUMER\_SECRET to
the values for a Test OAuth Application in order to see an example of
OAuth at work.

If you're working with Rails, a controller similar to this might come in
handy:

```ruby
  class XeroSessionsController < ApplicationController

    before_action :get_xero_gateway

    def new
      session[:request_token]  = @xero_gateway.request_token.token
      session[:request_secret] = @xero_gateway.request_token.secret

      redirect_to @xero_gateway.request_token.authorize_url
    end

    def create
      @xero_gateway.authorize_from_request(session[:request_token], session[:request_secret],
                                           oauth_verifier: params[:oauth_verifier])

      session[:xero_auth] = { access_token:   @xero_gateway.access_token.token,
                              access_secret:  @xero_gateway.access_token.secret }

      session.data.delete(:request_token)
      session.data.delete(:request_secret)
    end

    def destroy
      session.data.delete(:xero_auth)
    end

    private

      def get_xero_gateway
        @xero_gateway = XeroGateway::Gateway.new(YOUR_OAUTH_CONSUMER_KEY, YOUR_OAUTH_CONSUMER_SECRET)
      end

  end
```

Note that I'm just storing the Access Token + Secret in the session here
- you could equally store them in the database if you felt like
refreshing them every 30 minutes ;)

## API Methods

You can find a full listing of all implemented methods on [the wiki page](https://github.com/xero-gateway/xero_gateway/wiki/API-Methods).

## Logging

You can specify a logger to use (so you can track down those tricky
exceptions) by using:

```ruby
  gateway.logger = ActiveSupport::BufferedLogger.new("log_file_name.log")
```

Your logger simply needs to respond to `info`.

## Contributing

We welcome contributions, thanks for pitching in! :sparkles:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make sure you have some tests, and they pass! (`bundle exec rake`)
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
