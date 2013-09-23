class UsersController < ApplicationController
  before_action :signed_in_user, :only => [:index, :edit, :update]
  before_action :correct_user,   :only => [:edit, :update]
  before_action :admin_user,     :only =>:destroy

  def new
    @user =  User.new
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
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
  private

  def user_params
    params.required(:user).permit(:name, :email, :password,:password_confirmation)
  end

  def signed_in_user
    # Store loaction user was attempting to get to so when they sign in we
    # Direct them there
    store_location()
    #
    #  Short cut for assigning to flash.  Equivilent to:
    #  unless signed_in?
    #    flash[:notice] = "Please sign in."
    #    redirect_to signin_url
    #  end
    #
    redirect_to signin_url, :notice => "Please sign in." unless signed_in?

  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
