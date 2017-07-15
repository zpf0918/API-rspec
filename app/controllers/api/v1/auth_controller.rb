class Api::V1::AuthController < ApiController
  before_action :authenticate_user!, only: [:logout]

  def signup
    user = User.new( :email => params[:email],
                     :password => params[:password]
                     )
    if user.save
      render :json => {
        :user_id => user.id,
        :email => user.email,
        :auth_token => user.authentication_token
      }
    else
      render :json => { :message => "注册失败", :errors => user.errors}, :status => 401
    end
  end

  def login
    if params[:email] && params[:password]
      user = User.find_by_email(params[:email])
    end

    if user && user.valid_password?(params[:password])
      render :json => {
        :message => "ok",
        :auth_token => user.authentication_token,
        :user_id => user.id
      }
    else
      render :json => { :message => "登录失败"}, :status => 401
    end
  end

  def logout
    current_user.generate_authentication_token
    current_user.save！
    render :json => { :message => "ok"}
  end
end
