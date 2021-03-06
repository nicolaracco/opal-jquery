describe "JQuery#[]=" do
  before do
    @div = Document.parse <<-HTML
      <div id="attr-set-spec">
        <div id="foo" title="Apples"></div>
        <div id="bar"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should set the attr value on the element" do
    bar = Document.id 'bar'
    bar[:title].should == ""

    bar[:title] = "Oranges"
    bar[:title].should == "Oranges"
  end

  it "should replace the old value for the attribute" do
    foo = Document.id 'foo'
    foo[:title].should == "Apples"

    foo[:title] = "Pineapple"
    foo[:title].should == "Pineapple"
  end
end