$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nepali_calendar'

# fy_start_date = NepaliCalendar::Calendar.new(nil, {year: 2077, month: 04, day: 1})

# p fy_start_date
# p fy_start_date.view_context
# p fy_start_date.year
# p fy_start_date.month

# p NepaliCalendar::AdCalendar.bs_to_ad(2079, 4, 1)

# p NepaliCalendar::BsCalendar.beginning_of_fiscal_year_in_ad("7778")
 #p NepaliCalendar::BsCalendar.beginning_of_fiscal_year_in_bs("7879").
 p NepaliCalendar::FiscalYear.fiscal_year_in_bs_for_ad_date(Date.today)
  #p NepaliCalendar::FiscalYear.new(79, 81).end_of_year
