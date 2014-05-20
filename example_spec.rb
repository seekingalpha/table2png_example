require_relative 'example'

describe ContentParser do
  let(:content) do
    <<-CONTENT
      <div>
        <table>
          <tr>
            <td>HELLO</td>
          </tr>
        </table>
        <table>
          <tr>
            <td>HI</td>
          </tr>
        </table>
      </div>
    CONTENT
  end

  let(:parsed_content) do
    Nokogiri::HTML.fragment ContentParser.new(content).parse!
  end

  let(:first_table) do
    parsed_content.css('table').first
  end

  let(:second_table) do
    parsed_content.css('table').last
  end

  it "first table should have url" do
    expect(first_table.attribute("data-image-url").value).to eq("REAL_URL/44dc69c91b7c8741941ecf87d694a27b.png")
  end

  it "first table should have width" do
    expect(first_table.attribute("data-image-width").value).to eq("70")
  end

  it "first table should have height" do
    expect(first_table.attribute("data-image-height").value).to eq("37")
  end

  it "second table should have url" do
    expect(second_table.attribute("data-image-url").value).to eq("REAL_URL/03275c2a805fc2cb631dbb8d7ca27f4b.png")
  end

  it "second table should have width" do
    expect(second_table.attribute("data-image-width").value).to eq("34")
  end

  it "second table should have height" do
    expect(second_table.attribute("data-image-height").value).to eq("37")
  end

end
