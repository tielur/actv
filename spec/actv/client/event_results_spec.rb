require 'spec_helper'

describe ACTV::Client do

  before do
    @client = ACTV::Client.new
  end

  describe "#event_results" do
    context "performs a search with results" do
      before do
        stub_get("/api/v1/events/286F5731-9800-4C6E-ADD5-0E3B72392CA7/3BF82BBE-CF88-4E8C-A56F-78F5CE87E4C6.json").
        to_return(body: fixture("valid_event_results.json"), headers: { content_type: "application/json; charset=utf-8" })
      end

      it 'returns an an event result' do
        search_results = @client.event_results("286F5731-9800-4C6E-ADD5-0E3B72392CA7", "3BF82BBE-CF88-4E8C-A56F-78F5CE87E4C6",{})
        search_results.title.should eql "2013 IRONMAN 70.3 Hawaii"
      end
    end

    context "performs a search with no results" do
      before do
        stub_get("/v2/events/popular?topic=asdf").
        to_return(body: fixture("valid_search_no_event_results.json"), headers: { content_type: "application/json; charset=utf-8" })        
      end

      it 'returns nil' do
        search_results = @client.event_results("asdf", "asdf",{})       
        search_results.should eql nil
      end
    end
  end

end