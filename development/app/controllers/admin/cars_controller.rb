class Admin::CarsController < ApplicationController

  def index
    render json: Car.paginate(page: params[:page], per_page: params[:per_page]).order('id desc')
  end

  def destroy
    Car.find_by_id(params[:id]).try(:destroy)
    render status: 204, nothing: true
  end

  def show
    render json: Car.find(params[:id])
  end

  def create
    car = Car.create!(permit_params)
    render json: car
  end

  def update
    car = Car.find(params[:id])
    car.update_attributes(permit_params)
    render json: car
  end

  private
  def permit_params
    params.require(:car).permit(:title, :color, :description)
  end
end