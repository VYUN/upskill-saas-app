class ContactsController < ApplicationController
    
    #GET request to /contact-us
    # Show new contact form
    def new
        @contact = Contact.new
    end
    
    # POST request /contacts
    def create 
        # Assignment of form fields into Contact object
        @contact = Contact.new(contact_params)
        #Save Contact object to database
        if @contact.save
            #Store form fields via params into vars
            name = params[:contact][:name]
            email = params[:contact][:email]
            body = params[:contact][:comments]
            #Plug variables into Contact Mailer email method and send
            ContactMailer.contact_email(name, email, body).deliver
            
            #store success msg in flash hash and redirect to new action
            flash[:success] = "Message sent."
            redirect_to new_contact_path
        else
            # if contact doesn't save, store errors
            flash[:danger] = @contact.errors.full_messages.join(", ")
            redirect_to new_contact_path
        end
    end
    
    private
        #To collect data from form, we need to use strong params
        # and whitelist the form fields
        def contact_params
            params.require(:contact).permit(:name, :email, :comments)
        end
end