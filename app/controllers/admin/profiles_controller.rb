class Admin::ProfilesController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(strong_params)
    if @profile.save
      redirect_to admin_user_path(params[:profile][:user_id])
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @profile = @user.profile
    if @profile == nil
      @profile = @user.build_profile
    else
      @profile
    end
  end

  def update
  end

  def strong_params
    params.require(:profile).permit(:text_response, :comparative_1, :comparative_2, :user_id)
  end
end
