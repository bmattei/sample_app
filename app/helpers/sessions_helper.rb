module SessionsHelper
  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(:remember_token => remember_token)
  end

  def signed_in_user
    unless signed_in?
      store_location()
      redirect_to signin_url, :notice => "Please sign in." unless signed_in?
    end

  end
  def sign_in(user)
    remember_token = User.new_remember_token
    # same as cookies[:remember_token] = {value:   remember_token,
    # expires: 20.years.from_now.utc}
    # permanent was added because setting tokens that expired in 20 years
    # wa so common
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out(user)
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  # We use this routine to direct the user back stored url
  #
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  #
  #  We use this  methods to save a URL a user attempted to get to - but failed
  #  because they were not signed in. 
  def store_location
    session[:return_to] = request.url if request.get?
  end
end
