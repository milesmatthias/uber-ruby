require 'uber/arguments'
require 'uber/api_request'
require 'oauth2'

module Uber
  module API
    module OAuth

      BASE_AUTH_URL   = "https://login.uber.com/oauth/v2/authorize"
      BASE_TOKEN_URL  = "https://login.uber.com/oauth/v2/token"
      BASE_REVOKE_URL = "https://login.uber.com/oauth/revoke"

      OAUTH_URLS = {
        :site => "https://login.uber.com",
        :authorize_url => "/oauth/v2/authorize",
        :token_url => "/oauth/v2/token"
      }

      def oauth_url
        oauth_client = OAuth2::Client.new(client_id, client_secret, OAUTH_URLS)
        oauth_client.authorize_url(redirect_uri: redirect_uri)
      end

      def oauth_access_token(code)
        oauth_client = OAuth2::Client.new(client_id, client_secret, OAUTH_URLS)
        oauth_client.auth_code.get_token(code)
      end

      def refresh_oauth_token(opts)
        opts[:grant_type]    ||= "refresh_token"
        opts[:client_id]     ||= client_id
        opts[:client_secret] ||= client_secret
        opts[:redirect_uri]  ||= redirect_uri

        request = Uber::ApiRequest.new(self, :get, BASE_TOKEN_URL, opts)
        request.perform
      end

      def revoke_oauth_token(opts)
        opts[:client_id]     ||= client_id
        opts[:client_secret] ||= client_secret

        request = Uber::ApiRequest.new(self, :get, BASE_REVOKE_URL, opts)
        request.perform
      end
    end
  end
end

