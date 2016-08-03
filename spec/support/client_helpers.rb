require 'uber'

module ClientHelpers
  def setup_client(opts = {})
    Uber::Client.new do |c|
      c.client_id     = 'UBER_CLIENT_ID'
      c.client_secret = 'UBER_CLIENT_SECRET'
      c.bearer_token  = 'UBER_BEARER_TOKEN'
      c.redirect_uri  = 'UBER_REDIRECT_URI'
      c.sandbox       = opts[:sandbox]
    end
  end

  def stub_uber_request(method, api_endpoint, response_hash, opts = {})
    with_opts = {headers: {'Authorization' => 'Bearer UBER_BEARER_TOKEN'}}
    with_opts[:body] = opts[:body] unless opts[:body].nil?
    status_code = opts[:status_code] || 200

    host = opts[:sandbox] ? Uber::Client::SANDBOX_ENDPOINT : Uber::Client::ENDPOINT

    response = response_hash.nil? ? "" : response_hash.to_json

    if api_endpoint.start_with?("http")
      url = api_endpoint
    else
      url = "#{host}/#{api_endpoint}"
    end

    stub_request(method, url).
      with(with_opts).
      to_return(status: status_code, body: response)
  end
end
