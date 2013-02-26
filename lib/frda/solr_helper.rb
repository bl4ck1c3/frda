require 'frda/grouped_solr_response'
module Frda::SolrHelper
    
  def get_grouped_search_results(user_params = params || {}, extra_controller_params = {})
    merged_params = self.solr_search_params(user_params).merge(extra_controller_params.merge(group_results_params))
    rows = params.dup.delete(:per_page) # will we need rows later?
    
    response = blacklight_solr.paginate(params[:page] || 1, rows, blacklight_config.solr_path, :params=>merged_params)
    solr_response = Frda::GroupedSolrResponse.new(force_to_utf8(response), merged_params)
    
    return [solr_response, solr_response.groups]
  end
  
  
  def blacklight_solr
    Blacklight.solr
  end
  
  def group_results_params
    {:group => true, :"group.field" => group_result_field, :"group.limit" => 10, :"group.ngroups" => true}
  end
  
  def group_result_field
    "vol_title_ssi"
  end
  
end