class PinsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    render json: Pin.all.order('created_at DESC')
  end


  def create
    pin = Pin.new(pin_params)
    pin.user = current_user
    if pin.save
      redirect_to root_path, notice: "El pin fue creado exitosamente"
    else
      render :new
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end

    def authenticate_api!
      email = request.headers['HTTP_X_USER_EMAIL']
      token = request.headers['HTTP_X_API_TOKEN']
      @current_user = User.where(email: email).take
      unless @current_user && @current_user.api_token == token
        head 401
      end
    end
end
