class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  def admin_required
    if !current_user.admin?
      redirect_to "/",alert:"非管理员无法登陆"
    end
  end
  
  helper_method :current_cart
  
  def current_cart
    @current_cart ||= find_cart
  end
  
  private
  
  def find_cart
    cart = Cart.find_by(id: session[:cart_id])
    if cart.blank?
      cart = Cart.create
    end
    session[:cart_id] = cart.id
    return cart
  end
end