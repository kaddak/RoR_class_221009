module SessionsHelper
  def logged_in?  #ruby convention telling it'll return boolean
    !session[:user_id].nil?     #!=not
  end
  
end
