class ContactsController < ApplicationController
  
  #GET request to /contact-us
  #show new contact form
  def new
    @contact = Contact.new
  end
  
  #POST request to /contacts
  def create
    #Mass assignment of form fields into Contact object
    @contact = Contact.new(contact_params)
    #Save the contact object to the db
    if @contact.save
      #Store form fields via parameters, into local variables 
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      #Plug variables into ContactMailer 
      # email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      # display success banner and message in flash hash
      flash[:success] = "Message Sent."
      #redirect back to the new action
      redirect_to new_contact_path
    else
      #display danger hash flash banner if save fails
      flash[:danger] = @contact.errors.full_messages.join(", ")
      #redirect back to the new action
      redirect_to new_contact_path
    end
  end
  
  private
    #to collect data from form, we need to use
    #strong parameters and whitelist the form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end