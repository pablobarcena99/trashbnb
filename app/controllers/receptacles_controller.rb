class ReceptaclesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @tag_list = ["Tiny","Small","Medium","A lot","Infinite"]
    @user = current_user
    if params[:query].present?
      @receptacles = policy_scope(Receptacle).global_search(params[:query])
    else
      if params[:tag].present?
        @receptacles = policy_scope(Receptacle).tagged_with(params[:tag])
        @message = "No Results" unless @receptacles.present?
      else
        @receptacles = policy_scope(Receptacle)
      end
    end
    @markers = @receptacles.geocoded.map do |receptacle|
      {
        lat: receptacle.latitude,
        lng: receptacle.longitude,
        info_window: render_to_string(partial: "info_window", locals: { receptacle: receptacle }),
        image_url: helpers.asset_url("red trash.png")
      }
    end
  end


  def show
    @receptacle = Receptacle.find(params[:id])
    @booking = Booking.new

    authorize @receptacle
    @markers =
    [{
        lat: @receptacle.latitude,
        lng: @receptacle.longitude,
        info_window: render_to_string(partial: "info_window", locals: { receptacle: @receptacle }),
        image_url: helpers.asset_url("red trash.png")
      }]
  end

  def new
    @receptacle = Receptacle.new
    authorize @receptacle
  end

  def create
    @user = current_user
    @receptacle = Receptacle.new(receptacle_params)
    authorize @receptacle

    @receptacle.user = @user
    if @receptacle.save
      redirect_to receptacle_path(@receptacle), notice: "Thanks for creating your receptacle!"
    else
      render :new, alert: "A problem has occurred while creating your receptacle"
    end

  end

  def edit
    @receptacle = Receptacle.find(params[:id])
    authorize @receptacle
  end

  def update
    @receptacle = Receptacle.find(params[:id])
    authorize @receptacle
    @receptacle.update(receptacle_params)
    redirect_to receptacle_path(@receptacle)
  end

  def destroy
    @receptacle = Receptacle.find(params[:id])
    authorize @receptacle

    @receptacle.destroy
    redirect_to receptacles_path
  end

  private

  def receptacle_params
    params.require(:receptacle).permit(:name, :picture, :capacity, :price_per_day, :address, :description, :tag_list)
  end
end
