class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user
  
  # GET to /users/:user_id/profile/new
  def new
    # render blank profile details form
    @profile = Profile.new
  end

  # POST to /users/:user_id/profile
  def create
    #get user from the params
    @user = User.find( params[:user_id] )
    #this profile will only be linked to the user that is logged in
    @profile = @user.build_profile( profile_params )
    #if save successful, display success flash and redirect to homepage
    if @profile.save
      flash[:success] = "Profile Updated!"
      redirect_to user_path(id: params[:user_id] )
    else 
      #if save failed, go display the form again
      render action: :new
    end
  end
  
  # GET to /users/:user_id/profile/edit
  def edit 
    @user = User.find( params[:user_id] )
    @profile = @user.profile
  end
  
  #PUT or PATCH to /users/:user_id/profile
  def update
    #retrieve user from the db
    @user = User.find( params[:user_id] )
    #retrieve that users profile
    @profile = @user.profile
    # mass assign updated attributes to profile and save
    if @profile.update_attributes( profile_params )
      flash[:success] = "Profile Updated!"
      #Redirect user to their profile page
      redirect_to user_path(id: params[:user_id] )
    else 
      render action :edit
    end
  end
  
  #whitelisting form fields to be submitted.  New fields cant be added for submission.
  #private section because this function is only permitted for use within this profile controller file
  private
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :avatar, :job_title, :phone_number, :contact_email, :description)
    end
    
    def only_current_user
      @user = User.find( params[:user_id] )
      redirect_to(root_path) unless @user == current_user
    end
end