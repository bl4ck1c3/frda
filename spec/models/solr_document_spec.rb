require "spec_helper"

describe SolrDocument do
  it "should behave like a SolrDocument" do
    doc = SolrDocument.new(:id => "12345")
    doc.should be_a SolrDocument
    doc[:id].should == "12345"
    doc.should respond_to :export_formats
  end
  
  describe "catalog_heading" do
    it "should get the correct field based on the locale passed in" do
      doc = SolrDocument.new(:id => "12345", :catalog_heading_etsimv => ["Something -- Something English"], :catalog_heading_ftsimv => ["Something -- Something French"])
      en_heading = doc.catalog_heading(:en)
      fr_heading = doc.catalog_heading(:fr)
      en_heading.length.should == 1 
      fr_heading.length.should == 1
      en_heading.first.should include "Something English" and en_heading.first.should_not include "Something French"
      fr_heading.first.should include "Something French" and fr_heading.first.should_not include "Something English"
    end
    it "should split the catalog heading field on double dashes" do
      doc = SolrDocument.new(:id => "12345", :catalog_heading_etsimv => ["Something -- Something Else -- Yet Another thing"])
      heading = doc.catalog_heading(:en)
      heading.length.should == 1
      heading.first.length.should == 3
      ["Something", "Something Else", "Yet Another thing"].each do |phrase|
        heading.first.should include phrase
      end
    end
  end
  
  describe "images" do
    before(:all) do
      @images = SolrDocument.new({:image_id_ssm => ["abc123", "cba321"]}).images
    end
    it "should point to the test URL" do
      @images.each do |image|
        image.should include Frda::Application.config.stacks_url
      end
    end
    it "should link to the image identifier field " do
      @images.each do |image|
        image.should =~ /abc123|cba321/
      end
    end
    it "should have the proper default image dimension when no size is specified" do
      @images.each do |image|
        image.should =~ /#{SolrDocument.image_dimensions[:default]}/
      end
    end
    it "should return the requested dimentsion when one is specified" do
      SolrDocument.new({:image_id_ssm => ["abc123", "cba321"]}).images(:size=>:large).each do |image|
        image.should =~ /#{SolrDocument.image_dimensions[:large]}/
      end
    end
    it "should return [] when the document does not have an image identifier field" do
      SolrDocument.new(:id => "12345").images.should eq([])
    end
    describe "image dimensions" do
      it "should be a hash of configurations" do
        SolrDocument.image_dimensions.should be_a Hash
        SolrDocument.image_dimensions.should have_key :default
      end
    end
  end
  
end