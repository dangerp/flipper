require 'helper'

RSpec.describe Flipper::UI::Actions::PercentageOfActorsGate do
  describe "POST /features/:feature/percentage_of_actors" do
    context "with valid value" do
      before do
        post "features/search/percentage_of_actors",
          {"value" => "24", "authenticity_token" => "a"},
          "rack.session" => {:csrf => "a"}
      end

      it "enables the feature" do
        expect(flipper[:search].percentage_of_actors_value).to be(24)
      end

      it "redirects back to feature" do
        expect(last_response.status).to be(302)
        expect(last_response.headers["Location"]).to eq("/features/search")
      end
    end

    context "with invalid value" do
      before do
        post "features/search/percentage_of_actors",
          {"value" => "555", "authenticity_token" => "a"},
          "rack.session" => {:csrf => "a"}
      end

      it "does not change value" do
        expect(flipper[:search].percentage_of_actors_value).to be(0)
      end

      it "redirects back to feature" do
        expect(last_response.status).to be(302)
        expect(last_response.headers["Location"]).to eq("/features/search?error=Invalid+percentage+of+actors+value%3A+value+must+be+a+positive+number+less+than+or+equal+to+100%2C+but+was+555")
      end
    end
  end
end
