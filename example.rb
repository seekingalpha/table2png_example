# All this should be on initializers
require 'imgkit'
require 'chunky_png'
require 'table2png'
require 'nokogiri'

IMGKit.configure do |config|
  binary_path = 'wkhtmltoimage'
  config.wkhtmltoimage = File.join(File.dirname(__FILE__), binary_path)
end


# The classes you asked for

ContentParser = Struct.new(:content) do

  def parse!
    tables.each do |table|
      parse_table table
    end

    parsed_content.to_html
  end

  private

  def parse_table table
    converter = TableConverter.new(table.to_html)

    #TODO put real path here
    converter.image.save("./#{converter.file_name}.png")

    table.set_attribute("data-image-url", "REAL_URL/#{converter.file_name}.png")
    table.set_attribute("data-image-width", converter.image.width)
    table.set_attribute("data-image-height", converter.image.height)
  end

  def tables
    parsed_content.css("table")
  end

  def parsed_content
    @parsed_content ||= Nokogiri::HTML.fragment(content)
  end

  TableConverter = Struct.new(:html_table) do
    def image
      @image ||= Table2PNG::Converter.new(html_table).process
    end

    def file_name
      @file_name ||= Digest::MD5.new.hexdigest html_table
    end
  end

end
