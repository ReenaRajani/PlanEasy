module SessionsHelper
  def logged_in?
    !current_user.nil?
  end

  def current_user
    # @current_user ||= User.find_by(id: session[:user_id])
    if(user_id = session[:user_id])
        @current_user ||= User.find_by(id: user_id)
    elsif(user_id = cookies.signed[:user_id])
        user = User.find_by(id: user_id)
        if user && user.authenticated?(cookies[:remember_token])
          session[:user_id] = user.id
          @current_user = user
        end
    end
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

   # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

end
