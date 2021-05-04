class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user = User.find_by[email: params[:email]]
    
    if user.authenticate(params[:password])
      payload = { user_id: user.id }
      session = JWTSessions.session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      response.set_cookie(JWTSessions.access_cookie,
        value: token[:access],
        httponly: true,
        secure: Rails.env.production?)

      render json: { csrf: tokens[:csrf]}
    else
      not_found
    end
  end

  def destroy
    session = JWTSessions.session.new(payload: payload)
    session.flush_by_access_payload
    render json: :ok
  end


  private
    def not_found
      render json: "Can't find email/password combination" , status: :unauthorized
    end
end
