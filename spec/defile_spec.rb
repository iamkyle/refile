require "defile"

RSpec.describe Defile do
  let(:io) { StringIO.new("hello") }

  describe ".verify_uploadable" do
    it "works if it conforms to required API" do
      expect(Defile.verify_uploadable(double(size: 444, read: io, eof?: true, close: nil))).to be_truthy
    end

    it "raises ArgumentError if argument does not respond to `size`" do
      expect { Defile.verify_uploadable(double(read: io, eof?: true, close: nil)) }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError if argument does not respond to `read`" do
      expect { Defile.verify_uploadable(double(size: 444, eof?: true, close: nil)) }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError if argument does not respond to `eof?`" do
      expect { Defile.verify_uploadable(double(size: 444, read: true, close: nil)) }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError if argument does not respond to `close`" do
      expect { Defile.verify_uploadable(double(size: 444, read: true, eof?: true)) }.to raise_error(ArgumentError)
    end
  end

  describe ".extract_filename" do
    it "extracts filename from original_filename" do
      name = Defile.extract_filename(double(original_filename: "/foo/bar/baz.png"))
      expect(name).to eq("baz.png")
    end

    it "extracts filename from path" do
      name = Defile.extract_filename(double(path: "/foo/bar/baz.png"))
      expect(name).to eq("baz.png")
    end

    it "returns nil if it can't determine filename" do
      name = Defile.extract_filename(double)
      expect(name).to be_nil
    end
  end
end
