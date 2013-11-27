module GitWiki

class RedirectList < TemplateTransformation
  def transform
    # set placeholder
    placeholder = 'Filter items...'
    tmp_pt = @nk.at_css('*')
    if tmp_pt.name == 'p'
      placeholder = tmp_pt.content
      tmp_pt.unlink
    end

    @nk.css('ul:first').each do |ul_nk|
      ul_nk['class'] = 'redirect-list'
      ul_nk['data-role'] = 'listview'
      ul_nk['data-inset'] = 'true'
      ul_nk['data-filter'] = 'true'
      ul_nk['data-filter-placeholder'] = placeholder
      ul_nk.css('li').each do |li_nk|
        a_nk = li_nk.css('a:first').first
        if a_nk && a_nk['href'] =~ /^tel:/
          li_nk['data-icon'] = 'phone'
        end
        if a_nk && (parts = a_nk.content.split('|', 2))
          span_nk = Nokogiri::XML::Node.new "span", @nk
          span_nk.content = parts[1]
          span_nk["class"] = "secondary"
          a_nk.content = parts[0]
          a_nk.add_child(Nokogiri::XML::Node.new "br", @nk)
          a_nk.add_child(span_nk)
        end
      end
    end
    custom_styled = @nk.to_html
  end
  
  md = <<-MD
Text at the top becomes the search prompt.

* [This is a link](/target)
MD

  example md, <<-HTML
      <ul data-role="listview" data-inset="true" data-filter="true" class="redirect-list"
        data-filter-placeholder="Text at the top becomes the search prompt.">
        <li><a href="/target">This is a link</a></li>
      </ul> 	
  HTML

  md = <<-MD
* [This link places a call | 
    to 877-372-4161](tel:+18773724161)
MD

  example md, <<-HTML
      <ul data-role="listview" data-inset="true" class="redirect-list">
        <li data-icon="phone"><a href="tel:+18773724161">This link places a call<br/>
          <span class="secondary">to 877-372-4161</span></a></li>
      </ul> 	
  HTML
  
  md = <<-MD
Putting it all together.

* [This is a link](/target)
* [This is a link | 
    with secondary text](/target2)
* [This link places a call | 
    to 877-372-4161](tel:+18773724161)
MD

  example md, <<-HTML
      <ul data-role="listview" data-inset="true" data-filter="true" class="redirect-list"
        data-filter-placeholder="Putting it all together.">
        <li><a href="/target">This is a link</a></li>
        <li><a href="/target2">This is a link<br/><span class="secondary">with secondary text</span></a></li>
        <li data-icon="phone"><a href="tel:+18773724161">This link places a call<br/>
          <span class="secondary">to 877-372-4161</span></a></li>
      </ul> 	
  HTML
 
end
end