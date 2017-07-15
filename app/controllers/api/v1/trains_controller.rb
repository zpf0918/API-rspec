class Api::V1::TrainsController < ApiController
  def index
    @trains = Train.all
  end

  def show
    @train = Train.find_by_number!(params[:number])
  end
end
