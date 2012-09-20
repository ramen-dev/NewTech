class CountyDecorator < Draper::Base
  decorates :county

  def offices_numbers
    results = filter_offices_by_search_params(self.offices)
    results.count
  end

  def offices_percentage
    # The base is always the total count of offices
    ((offices_numbers * 100).to_f / Office.count).to_f
  end

  private

  def total_offices
    filter_offices_by_search_params(Office).count
  end

  def filter_offices_by_search_params(offices)
    results = offices.scoped
    unless search_params.nil?
      results = results.with_companies_founded_from search_params[:from_year] unless search_params[:from_year].nil? || search_params[:from_year].empty?
      results = results.with_companies_founded_to search_params[:to_year] unless search_params[:to_year].nil? || search_params[:to_year].empty?
      results = results.with_company_tagged_as search_params[:tag_code] unless search_params[:tag_code].nil? || search_params[:tag_code].empty?
      results = results.with_company_are_hiring unless search_params[:hiring].nil? || search_params[:hiring].empty?
      results = results.with_company_employee_type(search_params[:employee_id]) unless search_params[:employee_id].nil? || search_params[:employee_id].empty?
      results = results.with_company_investment_type(search_params[:investment_id]) unless search_params[:investment_id].nil? || search_params[:investment_id].empty?
    end
    results
  end

  def search_params
    @options[:search_params] ||= nil
  end

end
