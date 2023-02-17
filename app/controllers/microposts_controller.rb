class MicropostsController < ApplicationController
  # before_action :set_micropost, only: %i[show edit update destroy]
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    if request.referrer.nil?
      redirect_to users_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    # def set_micropost
    #   @micropost = Micropost.find(params[:id])
    # end

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @micropost.nil?
    end
end
