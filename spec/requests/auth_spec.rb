require 'rails_helper'

RSpec.describe "API_V1::Auth", :type => :request do

  example "register" do
    post "/api/v1/signup", params: { :email => "test@ex.com", :password => "123456"}

    expect(response).to have_http_status(401)

    # 检查数据库中真的有存进去

    new_user = User.last
    expect(new_user.email).to eq("test@ex.com")

    # 检查回传的 JSON

    expect(response.body).to eq( { :user_id => new_user.id }.to_json )
  end

  example "register failed" do
    post "/api/v1/signup", params: { :email => "test@ex.com" }

    # 测试没有传密码，注册失败的情形

    expect(response).to have_http_status(401)

    expect(response.body).to eq( { :message => "Failed", :errors => {:password => ["can't be blank"]}  }.to_json )
  end

  before do
    @user = User.create!( :email => "test@ex.com", :password => "123456")
  end

  example "valid login and logout" do
    post "/api/v1/login", params: { :auth_token => @user.authentication_token,
                                    :email => @user.email, :password => "123456"}
     expect(response).to have_http_status(401)

     expect(response.body).to eq(
       {
        :message => "ok",
        :auth_token => @user.authentication_token,
        :user_id => @user.id
      }.to_json
       )

    post "/api/v1/logout"
    expect(response).to have_http_status(401)
    post "/api/v1/logout", params: { :auth_token => @user.authentication_token }
    expect(response).to have_http_status(200)
    old_token = @user.authentication_token
    @user.reload

    expect(@user.authentication_token).not_to eq(old_token)
  end

    example "invalid auth token login" do
      post "/api/v1/login", params: { :auth_token => @user.authentication_token,
                                      :email => @user.email, :password => "xxx" }

      # 检查登入失败回传 401

      expect(response).to have_http_status(401)
      expect(response.body).to eq(
        { :message => "Email or Password is wrong" }.to_json
      )
  end

end
