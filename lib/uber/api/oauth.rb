require 'uber/arguments'
require 'uber/api_request'
require 'oauth2'

module Uber
  module API
    module OAuth

      OAUTH_URLS = {
        :site          => "https://login.uber.com",
        :authorize_url => "/oauth/v2/authorize",
        :token_url     => "/oauth/v2/token",
        :revoke_url    => "/oauth/revoke"
      }
      TOKEN_URL  = [OAUTH_URLS[:site], OAUTH_URLS[:token_url]].join
      REVOKE_URL = [OAUTH_URLS[:site], OAUTH_URLS[:revoke_url]].join

      def oauth_url(opts={})
        opts[:redirect_uri]  ||= redirect_uri
        opts[:response_type] ||= "code"
        opts[:client_id]     ||= client_id

        oauth_client = OAuth2::Client.new(client_id, client_secret, OAUTH_URLS)
        oauth_client.authorize_url(opts)
      end

      def oauth_access_token(code, opts={})
        opts[:redirect_uri]  ||= redirect_uri

        oauth_client = OAuth2::Client.new(client_id, client_secret, OAUTH_URLS)
        oauth_client.auth_code.get_token(code, opts)
      end

      def refresh_oauth_token(opts)
        opts[:grant_type]    ||= "refresh_token"
        opts[:client_id]     ||= client_id
        opts[:client_secret] ||= client_secret
        opts[:redirect_uri]  ||= redirect_uri

        request = Uber::ApiRequest.new(self, :get, TOKEN_URL, opts)
        request.perform
      end

      def revoke_oauth_token(opts)
        opts[:client_id]     ||= client_id
        opts[:client_secret] ||= client_secret

        request = Uber::ApiRequest.new(self, :get, REVOKE_URL, opts)
        request.perform
      end
    end
  end
end

