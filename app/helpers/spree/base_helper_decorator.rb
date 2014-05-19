Spree::BaseHelper.module_eval do

  def taxons_tree(root_taxon, current_taxon, max_level = 1)
    return '' if max_level < 1 || root_taxon.children.empty?
    content_tag :ul, class: 'list-inline' do
      root_taxon.children.map do |taxon|
        content_tag :li do
          css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'list-group-item active' : 'list-group-item'
          link_to(taxon.name, seo_url(taxon), class: css_class) + taxons_tree(taxon, current_taxon, max_level - 1)
        end
      end.join("\n").html_safe
    end
  end

  def breadcrumbs(taxon, separator="&nbsp;")
   # return "" if current_page?("/") || taxon.nil?
    separator = raw(separator)
    crumbs = [content_tag(:li, link_to(Spree.t(:home), spree.root_path) + separator)]
    if taxon
      crumbs << content_tag(:li, link_to(Spree.t(:products), products_path) + separator)
      crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, link_to(ancestor.name , seo_url(ancestor)) + separator) } unless taxon.ancestors.empty?
      crumbs << content_tag(:li, content_tag(:span, link_to(taxon.name , seo_url(taxon))), class: 'active')
    else
      crumbs << content_tag(:li, content_tag(:span, Spree.t(:products)), class: 'active')
    end
    crumb_list = content_tag(:ol, raw(crumbs.flatten.map{|li| li.mb_chars}.join), class: 'breadcrumb')
    content_tag(:nav, crumb_list, id: 'breadcrumbs', class: 'col-md-12')
  end

end
