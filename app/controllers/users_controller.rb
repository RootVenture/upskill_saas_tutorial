class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.includes(:profile)
  end
  # GET to /users/:id
  def show
    #item within params needs to match our URL
    @user = User.find( params[:id] )
  end
end