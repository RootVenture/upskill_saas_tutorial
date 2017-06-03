class UsersController < ApplicationController
  # GET to /users/:id
  def show
    #item within params needs to match our URL
    @user = User.find( params[:id] )
  end
end