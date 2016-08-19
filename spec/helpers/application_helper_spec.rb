require 'spec_helper'

describe ApplicationHelper do

  describe "#meters_in_words" do
    it "should convert a distance in metres to simple concise text" do
      expect(helper.meters_in_words(2000)).to eq("2 km")
      expect(helper.meters_in_words(500)).to eq("500 m")
    end

    it "should round distances in km to the nearest 100m" do
      expect(helper.meters_in_words(2345)).to eq("2.3 km")
    end

    it "should round distances in metres to nearest 10m" do
      expect(helper.meters_in_words(923.45)).to eq("920 m")
    end

    it "should round distances less than 100 metres to nearest metre" do
      expect(helper.meters_in_words(84.23)).to eq("84 m")
    end
  end

  describe "#significant_figure" do
    it "should round to two significant figures" do
      expect(helper.significant_figure(0.164, 2)).to eq(0.16)
      expect(helper.significant_figure(1.64, 2)).to eq(1.6)
      expect(helper.significant_figure(16.4, 2)).to eq(16)
      expect(helper.significant_figure(164, 2)).to eq(160)
      expect(helper.significant_figure(1640, 2)).to eq(1600)
    end

    it "should round to one significant figure" do
      expect(helper.significant_figure(0.164, 1)).to eq(0.2)
      expect(helper.significant_figure(1.64, 1)).to eq(2)
      expect(helper.significant_figure(16.4, 1)).to eq(20)
      expect(helper.significant_figure(164, 1)).to eq(200)
      expect(helper.significant_figure(1640, 1)).to eq(2000)
    end

    it "should round zero without freaking out" do
      expect(helper.significant_figure(0, 1)).to eq(0)
    end

    it "should round negative numbers" do
      expect(helper.significant_figure(-2.34, 2)).to eq(-2.3)
    end
  end
end
