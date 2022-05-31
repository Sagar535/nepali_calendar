$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nepali_calendar'


p NepaliCalendar::FiscalYear.current_fiscal_year