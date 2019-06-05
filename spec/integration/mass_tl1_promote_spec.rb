require "rails_helper"

describe ::MassTl1Promote::PromoController do
  let(:tl_0) { Fabricate(:user, trust_level: 0) }
  let(:tl_2) { Fabricate(:user, trust_level: 2) }

  describe "when enabled" do
    before do
      SiteSetting.mass_tl1_promote_enabled = true
    end

    describe "when logged in" do
      before do
        sign_in(Fabricate(:admin))
      end

      it "should promote a list of users" do
        post "/admin/plugins/mass-tl1-promote.json", params: {
          usernames: [tl_0.username, tl_2.username, "TheDogeGamerYT2008"]
        }

        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body["success"]).to eq([tl_0.username])
        expect(body["deny"]).to eq([
          { "username" => tl_2.username, "why" => "already_tl1" },
          { "username" => "TheDogeGamerYT2008", "why" => "doesnt_exist" },
        ])

        expect(tl_0.reload.trust_level).to eq(1)
        expect(tl_2.reload.trust_level).to eq(2) # don't demote
      end
    end

    describe "when logged out" do
      it "should not let you access the page" do
        post "/admin/plugins/mass-tl1-promote.json", params: {
          usernames: []
        }

        expect(response.status).to eq(404)
      end
    end
  end

  describe "when disabled" do
    before do
      SiteSetting.mass_tl1_promote_enabled = false
    end

    it "should fail even if you're an admin" do
      sign_in(Fabricate(:admin))

      post "/admin/plugins/mass-tl1-promote.json", params: {
        usernames: []
      }

      expect(response.status).to eq(404)
    end
  end
end
