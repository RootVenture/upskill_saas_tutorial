class ProfilesController < ApplicationController
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
      redirect_to user_path( params[:user_id] )
    else 
      #if save failed, go display the form again
      render action: :new
    end
  end
  
  #whitelisting form fields to be submitted.  New fields cant be added for submission.
  #private section because this function is only permitted for use within this profile controller file
  private
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :avatar, :job_title, :phone_number, :contact_email, :description)
    end
end