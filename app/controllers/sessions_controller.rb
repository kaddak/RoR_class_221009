class SessionsController < ApplicationController
  def new
  end
  # empty but has to be here so rails knows theres a view with the same name

  def create
    email = params[:session]["email"] # both will work ->: will use less memory
    password = params[:session][:password]
    user = User.authenticate(email, password)
    
    if user # if auth is successful
      session[:user_id] = user.id     # this is a session
      flash[:notice] = "You are logged in."
      redirect_to session[:referrer] ||  :root   # to whatever is the root of your webserver ()
      #:referrer -> send to page that started from (if tried to edit if not logged in)
    else # if wrong credentials
      flash[:error] = "add to your FAIL blog and Please try again!"
      render :action => "new" # just shows def new end (at the beginning again)
    end
  end
  
  #Log out
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "You are logged out"
    redirect_to :root
  end
  
end
