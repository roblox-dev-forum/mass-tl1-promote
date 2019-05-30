# name: mass-tl1-promote
# version: 1.0.0
# authors: boyned/Kampfkarren

enabled_site_setting :mass_tl1_promote_enabled

after_initialize do
  module ::MassTl1Promote
    class Engine < ::Rails::Engine
      engine_name "mass_tl1_promote"
      isolate_namespace MassTl1Promote
    end

    def self.plugin_name
      "mass-tl1-promote".freeze
    end
  end

  require_dependency 'application_controller'
  class MassTl1Promote::PromoController < ::ApplicationController
    requires_plugin MassTl1Promote.plugin_name

    before_action :check_enabled
    before_action :ensure_admin

    def check_enabled
      raise Discourse::NotFound unless SiteSetting.mass_tl1_promote_enabled?
    end

    def action
      response = {
        success: [],
        deny: [],
      }

      (params["usernames"] || []).each do |username|
        user = User.find_by_username(username)
        if user
          if user.trust_level >= 1
            response[:deny].push({
              username: username,
              why: "already_tl1",
            })
          else
            user.change_trust_level!(1)
            response[:success].push(username)
          end
        else
          response[:deny].push({
            username: username,
            why: "doesnt_exist",
          })
        end
      end

      render json: response
    end

    def index
      render json: success_json
    end
  end

  MassTl1Promote::Engine.routes.draw do
    get "/admin/plugins/mass-tl1-promote" => "promo#index"
    post "/admin/plugins/mass-tl1-promote" => "promo#action"
  end

  Discourse::Application.routes.append do
    mount ::MassTl1Promote::Engine, at: "/", constraints: AdminConstraint.new
  end

  add_admin_route "mass_tl1_promote.title", "mass-tl1-promote"
end
