describe "JQuery#has_class?" do
  before do
    @div = Document.parse <<-HTML
      <div id="has-class-spec">
        <div id="foo" class="apples"></div>
        <div id="bar" class="lemons bananas"></div>

        <div id="buz" class="adam"></div>
        <div id="biz" class="tom"></div>
        <div id="boz" class="ben"></div>
        <div id="bez" class="tom arthur"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return true if the element has the given class" do
    Document.id('foo').has_class?("apples").should be_true
    Document.id('foo').has_class?("oranges").should be_false
    Document.id('bar').has_class?("lemons").should be_true
  end
end