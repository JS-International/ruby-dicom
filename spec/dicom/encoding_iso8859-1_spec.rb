# encoding: UTF-8

require 'spec_helper'


module DICOM

  describe DObject do

    before :example do
      @dcm = DObject.read(DCM_ISO8859_1)
    end

    describe "::read" do

      it "should set the encoding of the data element values as UTF-8" do
        expect(@dcm.value('0008,1010').encoding).to eql Encoding::UTF_8
      end

      it "should properly load the UTF8 string value from the DICOM file" do
        expect(@dcm.value('0008,1090')).to eql 'Õncêntrå MæstørPlàñ'
      end

    end


    describe "#write" do

      it "should properly write the ASCII-8BIT and UTF-8 string values to the DICOM file" do
        @dcm['0008,1010'].value = 'Õncêntrå MæstørPlàñ'
        @dcm['0008,1090'].value = 'TEST'.force_encoding('ASCII-8BIT')
        @dcm.write(TMPDIR + 'iso8859-1/iso8859-1.dcm')
        reloaded_dcm = DObject.read(TMPDIR + 'iso8859-1/iso8859-1.dcm')
        expect(reloaded_dcm.value('0008,1090')).to eql 'TEST'
        expect(reloaded_dcm.value('0008,1010')).to eql 'Õncêntrå MæstørPlàñ'
      end

    end

  end


  describe Element do

    before :example do
      @dcm = DObject.new
      Element.new('0008,0005', 'ISO_IR 192', :parent => @dcm)
    end

    describe "::new" do

      it "should transfer the UTF8 encoded string to the data element" do
        e = Element.new('0008,1010', 'Õncêntrå MæstørPlàñ', :parent => @dcm)
        expect(e.value).to eql 'Õncêntrå MæstørPlàñ'
      end

      it "should return the value originally encoded with UTF-8 as a string with UTF-8 encoding" do
        e = Element.new('0008,1010', 'Õncêntrå MæstørPlàñ', :parent => @dcm)
        expect(e.value.encoding.name).to eql 'UTF-8'
      end

      it "should transfer the ASCII-8BIT encoded string to the data element" do
        e = Element.new('0008,1010', 'TEST'.force_encoding('ASCII-8BIT'), :parent => @dcm)
        expect(e.value).to eql 'TEST'
      end

      it "should return the value originally encoded with ASCII-8BIT as a string with UTF-8 encoding" do
        e = Element.new('0008,1010', 'TEST'.force_encoding('ASCII-8BIT'), :parent => @dcm)
        expect(e.value.encoding.name).to eql 'UTF-8'
      end

    end


    describe "#value=" do

      it "should transfer the UTF8 encoded string to the data element" do
        e = Element.new('0008,1010', 'asdf', :parent => @dcm)
        e.value = 'Õncêntrå MæstørPlàñ'
        expect(e.value).to eql 'Õncêntrå MæstørPlàñ'
      end

      it "should return the value originally encoded with UTF-8 as a string with UTF-8 encoding" do
        e = Element.new('0008,1010', 'asdf', :parent => @dcm)
        e.value = 'Õncêntrå MæstørPlàñ'
        expect(e.value.encoding.name).to eql 'UTF-8'
      end

      it "should set the correct (bytesize) length for the data element receiving a (ASCII-8BIT) string" do
        e = Element.new('0008,1010', '', :parent => @dcm)
        e.value = 'Õncêntrå MæstørPlàñ'
        expect(e.length).to eql e.bin.bytesize
      end

      it "should transfer the ASCII-8BIT encoded string to the data element" do
        e = Element.new('0008,1010', 'asdf', :parent => @dcm)
        e.value = 'TEST'.force_encoding('ASCII-8BIT')
        expect(e.value).to eql 'TEST'
      end

      it "should return the value originally encoded with ASCII-8BIT as a string with UTF-8 encoding" do
        e = Element.new('0008,1010', 'asdf', :parent => @dcm)
        e.value = 'TEST'.force_encoding('ASCII-8BIT')
        expect(e.value.encoding.name).to eql 'UTF-8'
      end

      it "should set the correct (bytesize) length for the data element receiving a (ASCII-8BIT) string" do
        e = Element.new('0008,1010', '', :parent => @dcm)
        e.value = 'TEST'.force_encoding('ASCII-8BIT')
        expect(e.length).to eql e.bin.bytesize
      end

    end

  end


  describe Anonymizer do

    before :example do
      @a = Anonymizer.new(:audit_trail => TMPDIR + 'audit_trail_iso8859-1.json')
      @a.write_path = TMPDIR + 'anon/iso8859-1/'
      @a.enumeration = true
      @a.set_tag("0008,1090", :value => "Manufacturer", :enum => true)
      @a.anonymize_path(TMPDIR + 'iso8859-1/')
    end

    describe "#value=" do

      it "should create an audit file containing the expected utf8 and ascii values" do
        at = AuditTrail.new
        at.load(TMPDIR + 'audit_trail_iso8859-1.json')
        expect(at.dictionary['0008,1090'].keys.first).to eql 'TEST'
        expect(at.dictionary['0008,1010'].keys.first).to eql 'Õncêntrå MæstørPlàñ'
      end

    end

  end

end