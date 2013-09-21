class UsersController < ApplicationController
  def new
    @user =  User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
        render 'new'
     end
  end
  def show
    p params
    @user = User.find(params[:id])
  end
 private 
 def user_params
  params.required(:user).permit(:name, :email, :password,:password_confirmation)
end
end
