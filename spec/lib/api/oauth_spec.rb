require "spec_helper"
require "uber"
require "pry"

# https://developer.uber.com/docs/rides/authentication#oauth-20
describe Uber::API::OAuth do
  let!(:client) { setup_client }

  it "should generate an authorize URL" do
    url = ["https://login.uber.com/oauth/v2/authorize?client_id=",
           client.client_id,
          "&redirect_uri=UBER_REDIRECT_URI",
          "&response_type=code"].join

    expect(client.oauth_url).to eq url

    url = ["https://login.uber.com/oauth/v2/authorize?client_id=",
           client.client_id,
          "&redirect_uri=UBER_REDIRECT_URI",
          "&response_type=code",
          "&scope=read",
          "&state=foobar"].join

    expect(client.oauth_url({
      :scope => "read",
      :state => "foobar"
    })).to eq url
  end

# not a fan of these tests since they only really tests Faraday's mocking...
  it "should get an access token" do
    expected_response = {
      :access_token  => "EE1IDxytP04tJ767GbjH7ED9PpGmYvL",
      :token_type    => "Bearer",
      :expires_in    => 2592000,
      :refresh_token => "Zx8fJ8qdSRRseIVlsGgtgQ4wnZBehr",
      :scope         => "profile history"
    }

    response = stub_uber_request(:get, Uber::API::OAuth::BASE_TOKEN_URL, expected_response, {
      :code       => 'AUTHORIZATION_CODE_FROM_STEP_2',
      :grant_type => 'authorization_code',
      :client_id  => 'UBER_CLIENT_ID'
    }).response.body
    body = JSON.parse(response)

    expect(body["access_token"]).to eq expected_response[:access_token]
    expect(body["token_type"]).to eq expected_response[:token_type]
    expect(body["expires_in"]).to eq expected_response[:expires_in]
    expect(body["refresh_token"]).to eq expected_response[:refresh_token]
    expect(body["scope"]).to eq expected_response[:scope]
  end

  it "should be able to refresh tokens" do
    expected_response = {
      :access_token  => "EE1IDxytP04tJ767GbjH7ED9PpGmYvL",
      :token_type    => "Bearer",
      :expires_in    => 2592000,
      :refresh_token => "Zx8fJ8qdSRRseIVlsGgtgQ4wnZBehr",
      :scope         => "profile history"
    }

    response = stub_uber_request(:get, Uber::API::OAuth::BASE_TOKEN_URL, expected_response, {
      :code          => 'AUTHORIZATION_CODE_FROM_STEP_2',
      :grant_type    => 'refresh_token',
      :client_id     => 'UBER_CLIENT_ID',
      :client_secret => 'UBER_CLIENT_SECRET'
    }).response.body
    body = JSON.parse(response)

    expect(body["access_token"]).to eq expected_response[:access_token]
    expect(body["token_type"]).to eq expected_response[:token_type]
    expect(body["expires_in"]).to eq expected_response[:expires_in]
    expect(body["refresh_token"]).to eq expected_response[:refresh_token]
    expect(body["scope"]).to eq expected_response[:scope]
  end

  it "should be able to revoke tokens" do
    response = stub_uber_request(:get, Uber::API::OAuth::BASE_REVOKE_URL, {}, {
      :token => 'UBER_OAUTH_TOKEN'
    }).response

    expect(response.status).to eq [200, ""]
  end
end
