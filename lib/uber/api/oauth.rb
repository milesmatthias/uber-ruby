require 'uber/arguments'
require 'uber/api_request'

module Uber
  module API
    module OAuth

      BASE_AUTH_URL = "https://login.uber.com/oauth/v2/authorize"

      def oauth_url(opts={})
        opts[:client_id]     = client_id
        opts[:response_type] = "code"

        [BASE_AUTH_URL, Faraday::FlatParamsEncoder.encode(opts)].join("?")
      end
    end
  end
end

