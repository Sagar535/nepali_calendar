class NepaliCalendar::FiscalYear

    attr_accessor :start_year, :end_year

    def initialize(start_year, end_year)
        @start_year = start_year
        @end_year = end_year
    end
        
        # Should return_the_date in bs
    def beginning_of_year
        start_date = start_year.to_s.prepend('20')
        NepaliCalendar::Calendar.new(nil, {year: start_date, month: 4, day: 1})
    end
        
        # Should return the date in bs
    def end_of_year
        end_date = end_year.to_s.prepend('20')
        NepaliCalendar::Calendar.new(nil, {year: end_year, month: 3, day: NepaliCalendar::BS[end_year.to_i][3]})
    end

    def self.current_fiscal_year
      current_year = NepaliCalendar::BsCalendar.ad_to_bs(Date.today.year, Date.today.month, Date.today.day)
      if current_year.month < 4
        fiscal_year = (current_year.year-1).to_s.slice(2,2) + current_year.year.to_s.slice(2,2)
      else
        fiscal_year = current_year.year.to_s.slice(2,2) + (current_year.year+1).to_s.slice(2,2)
      end
    end
        
        # Should return the '7879' form of string.
    def to_s
        start_year.to_s + end_year.to_s
    end

end