class RecommendationsController < ApplicationController
  def index
    user_id = photo_params

    # this is the query engine, not the event engine
    # client = PredictionIO::EngineClient.new(ENV['PIO_ENGINE_URL'])
    # client.send_query({user: user_id})

    # replace this shit with photo_ids from recommendation service
    @pretend_photo_ids = [126214549, 125769075, 125416183, 125366857, 124674227]
    @response = F00px.get("photos?ids=#{@pretend_photo_ids.join(',')}")
  end

  private

  def photo_params
    params.require(:user_id)
  end
end
