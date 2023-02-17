class MicropostsController < ApplicationController
  # before_action :set_micropost, only: %i[show edit update destroy]
  before_action :logged_in_user, only: %i[create destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

    # def set_micropost
    #   @micropost = Micropost.find(params[:id])
    # end

    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
