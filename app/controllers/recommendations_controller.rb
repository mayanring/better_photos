class RecommendationsController < ApplicationController
  def index
    user_id = photo_params

    # this is the query engine, not the event engine
    # client = PredictionIO::EngineClient.new(ENV['PIO_ENGINE_URL'])
    client = PredictionIO::EngineClient.new("http://localhost:8000")
    recommended_photos = client.send_query(user: user_id)

    photo_ids = recommended_photos["itemScores"].map { |item| item["item"] }

    @response = F00px.get("photos?ids=#{photo_ids.join(',')}")
  end

  private

  def photo_params
    params.require(:user_id)
  end
end
