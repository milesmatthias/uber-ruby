require "spec_helper"
require "uber"

describe Uber::API::OAuth do
  let!(:client) { setup_client }

  it "should generate an authorize URL" do
    url = ["https://login.uber.com/oauth/v2/authorize?client_id=",
           client.client_id,
          "&response_type=code"].join

    expect(client.oauth_url).to eq url

    url = ["https://login.uber.com/oauth/v2/authorize?client_id=",
           client.client_id,
          "&redirect_uri=https%3A%2F%2Fexample.com%2Fcallback",
          "&response_type=code",
          "&scope=read",
          "&state=foobar"].join

    expect(client.oauth_url({
      :scope        => "read",
      :state        => "foobar",
      :redirect_uri => "https://example.com/callback"
    })).to eq url
  end

  it "should get an access token" do
    pending
  end

  it "should be able to refresh tokens" do
    pending
  end

  it "should be able to revoke tokens" do
    pending
  end
end
