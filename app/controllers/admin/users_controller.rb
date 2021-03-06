class Admin::UsersController < ApplicationController
  respond_to :html, :json

  def new
    @user = User.new
    render layout: 'admin'
  end

  def create
    if user_params["user_access"] == "student"
      @user = User.new(user_params)
      @user.password = "123456"
      if group_params[:groups].is_i?
        # if it is a number, that means it exists in the database already
        group_id = group_params[:groups]
      else
        # if not, add a new one in the group database
        group = Group.create(name: group_params[:groups])
        group_id = group.id
      end
      @user.group_ids = group_id  
      if @user.save
        @user.create_profile
        redirect_to edit_admin_profile_path(user_id: @user.id)
      else
        @user = User.new
        render 'new'
      end
    else
      @user = User.new(user_params)
      @user.password = "123456"
      if @user.save
        @user.create_profile
        redirect_to edit_admin_profile_path(user_id: @user.id)
      else
        render 'new'
      end
    end
  end

  def index
    @filterrific = initialize_filterrific(
      User,
      params[:filterrific],
      select_options: {
        with_user_access: User.options_for_select_user_access,
        with_year_level: User.options_for_year_level
      },
    ) or return
    @users = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    render layout: 'admin'
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    if @user.save
      redirect_to edit_admin_profile_path(@user)
    else 
      render 'edit'
    end
  end

  def select2_list_student
    @users = User.student
    render json: @users
  end

  private

  def user_params
    if params[:user][:user_access] == "student"
      params.require(:user).permit(:first_name,:last_name, :school, :year_level, :user_access, :wechat_account, :phone_number, :email)
    else
      params.require(:user).permit(:first_name,:last_name,:name, :user_access, :wechat_account, :phone_number, :email, :user_type)
    end
  end

  def group_params
    hash = {}
    hash[:groups] = params[:groups][0]
    hash
  end
end
