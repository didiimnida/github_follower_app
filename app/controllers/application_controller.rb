require 'github_api'

class ApplicationController < ActionController::Base

    protect_from_forgery with: :exception

    # This allows us to invoke the current_user() method in views!
    helper_method :current_user, :logged_in?, :github_connected?

    # This runs the setup_github_api method before every action
    # for every controller.
    before_action :setup_github_api

    def setup_github_api
        @github = GitHub.new github_code_url

        if logged_in?
            @github.token = current_user.github_token
        
        end
    end

    def current_user
        if @current_user
            return @current_user
        end

        if session[:current_user_id]
            @current_user = User.find session[:current_user_id]
        else
            @current_user = nil
        end

        return @current_user
    end

    def logged_in?
        current_user != nil
    end

    def github_connected?
        @github.token != nil
    end

end
