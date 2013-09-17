require 'spec_helper'

describe Authorities::Lcsh do

  before :all do
    @terms = Authorities::Lcsh.new "ABBA"
  end

  # TODO: These test the reponse from LOC's server and should be moved to
  # integration later once we can mock the response here
  describe "the response from LOC" do

    it "should have the query term for its first element" do
      @terms.response[0].should be_kind_of String
      @terms.response[0].should == "ABBA"
    end

    it "should have an array of results that match the query" do
      @terms.response[1].should be_kind_of Array
      @terms.response[1].should include "ABBA (Musical group)"
      @terms.response[1].length.should == 10
    end

    it "should have an array of strings that appear to have no use" do
      @terms.response[2].should be_kind_of Array
      @terms.response[2].collect { |v| v.should == "1 result" }
      @terms.response[2].length.should == 10
    end

    it "should have an array of the urls for each term" do
      @terms.response[3].should be_kind_of Array
      @terms.response[3].should include "http://id.loc.gov/authorities/names/n98029154"
      @terms.response[3].length.should == 10
    end

  end

  describe "presenting the results from LOC" do

    it "should give us the query term" do
      @terms.query.should == "ABBA"
    end

    it "should give us an array of suggestions" do
      @terms.suggestions.should be_kind_of Array
      @terms.suggestions.should include "ABBA (Musical group)"
    end

    it "should give us an array of urls for each suggestion" do
      @terms.urls_for_suggestions.should be_kind_of Array
      @terms.urls_for_suggestions.should include "http://id.loc.gov/authorities/names/n98029154"
    end
  end

  describe "#results" do
    it "should include ids for the terms" do
      @terms.results.first[:id].should be_kind_of String
    end

    it "should be an array of hashes" do
      @terms.results.should be_kind_of Array
      @terms.results.first.should be_kind_of Hash
    end
  end

 end  