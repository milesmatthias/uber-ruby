require 'uber/arguments'
require 'uber/api_request'

module Uber
  module API
    module OAuth

      BASE_AUTH_URL   = "https://login.uber.com/oauth/v2/authorize"
      BASE_TOKEN_URL  = "https://login.uber.com/oauth/v2/token"
      BASE_REVOKE_URL = "https://login.uber.com/oauth/revoke"

      def oauth_url(opts={})
        opts[:client_id]     ||= client_id
        opts[:redirect_uri]  ||= redirect_uri
        opts[:response_type] ||= "code"

        [BASE_AUTH_URL, Faraday::FlatParamsEncoder.encode(opts)].join("?")
      end

      def oauth_access_token(opts)
        opts[:grant_type]   ||= "authorization_code"
        opts[:client_id]    ||= client_id
        opts[:redirect_uri] ||= redirect_uri

        request = Uber::ApiRequest.new(self, :get, BASE_TOKEN_URL, opts)
        request.perform
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

