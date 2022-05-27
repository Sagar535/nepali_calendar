class NepaliCalendar::FiscalYear < NepaliCalendar::Calendar

    attr_accessor :start_year, :end_year

    def initialize(start_year, end_year)
        @start_year = start_year
        @end_year = end_year
    end
        
        # Should return_the_date in bs
    def beginning_of_year
    end
        
        # Should return the date in bs
    def end_of_year
    end
        
        # Should return the '7879' form of string.
    def to_s
    end

end