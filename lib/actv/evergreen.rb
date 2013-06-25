require 'delegate'

module ACTV
  class Evergreen < ::SimpleDelegator
    attr_accessor :asset, :current_event, :events

    def initialize asset
      super asset
      @asset = asset
      @events = []
      @current_event = {}
      asset.evergreenAssets.each do |sub_asset|
        @events << SubEvent.new(sub_asset)
        @current_event = sub_asset if Time.parse(sub_asset.fetch(:activityEndDate, "1970-01-01T00:00:01")) > Time.parse(@current_event.fetch(:activityEndDate, "1970-01-01T00:00:01"))
      end
      @current_event = ACTV.event @current_event[:assetGuid]

      self
    end

    def evergreen?
      true
    end

    def description_by_type type
      asset_description = @asset.description_by_type type rescue nil

      if asset_description.present?
        asset_description
      else
        @current_event.description_by_type type
      end
    end

    def method_missing method, *args, &block
      @current_event.send method, *args
    end
  end
end

