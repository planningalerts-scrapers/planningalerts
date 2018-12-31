# frozen_string_literal: true

class GeocodeService < ApplicationService
  # Default threshold of 100m
  def initialize(address, threshold = 100)
    @address = address
    @threshold = threshold
  end

  def call
    google_result = GoogleGeocodeService.call(address)
    mappify_result = MappifyGeocodeService.call(address)

    record_in_database(google_result, mappify_result) if results_are_different(google_result.top, mappify_result.top)
    google_result
  end

  private

  attr_reader :address, :threshold

  def results_are_different(loc1, loc2)
    return true if (loc1 && loc2.nil?) || (loc2 && loc1.nil?)

    loc1.distance_to(loc2) > threshold
  end

  def record_in_database(google_result, mappify_result)
    geocode_query = GeocodeQuery.create!(query: address)
    GeocodeResult.create!(
      [
        {
          geocoder: "google",
          lat: google_result.top&.lat,
          lng: google_result.top&.lng,
          geocode_query_id: geocode_query.id
        },
        {
          geocoder: "mappify",
          lat: mappify_result.top&.lat,
          lng: mappify_result.top&.lng,
          geocode_query_id: geocode_query.id
        }
      ]
    )
  end
end