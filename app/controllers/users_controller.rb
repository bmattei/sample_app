class UsersController < ApplicationController
  before_action :signed_in_user, :only => [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   :only => [:edit, :update]
  before_action :admin_user,     :only =>:destroy
  before_action :no_create,      :only => [:new, :create]

  def new
    @user =  User.new
  end

  def destroy

    user = User.find(params[:id])
    if (current_user?(user))
      flash[:error] = 'You can not destroy yourself'
    else
      user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_url
  end

  def create
    @user = User.create(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
  end

  def index
    #
    # Paginate added by gem will_paginate
    #
    @users = User.paginate(:page => params[:page])

    # @users = User.all
  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  #############
  private

  def user_params
    params.required(:user).permit(:name, :email, :password,:password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def no_create
    redirect_to(root_url)  if current_user
  end

end
