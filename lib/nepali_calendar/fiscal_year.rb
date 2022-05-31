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
        NepaliCalendar::Calendar.new(nil, {year: end_date, month: 3, day: NepaliCalendar::BS[end_date.to_i][3]})
    end

      # Returns the bs date that is the beginning of the provided fiscal_year.
    # def beginning_of_fiscal_year_in_bs
    #     beginning_of_year #start date of fiscal year
    # end


      # Returns the bs date that is the end of the provided fiscal_year.
    # def self.end_of_fiscal_year_in_bs(fiscal_year)
    #     start_year = fiscal_year.to_s.slice(0, 2)
    #     end_year = fiscal_year.to_s.slice(2,2)
    #     FiscalYear.new(start_year, end_year).end_of_year
    # end

    def self.get_fiscal_year_from_ad(ad_date)
        bs_date = NepaliCalendar::BsCalendar.ad_to_bs(ad_date.year.to_s, ad_date.month.to_s, ad_date.day.to_s)
        if bs_date.month < 4
          fiscal_year = ((ad_date.year - 1).to_s.slice(2,2)).to_s + ad_date.year.to_s.slice(2,2).to_s
        else
          fiscal_year =ad_date.year.to_s.slice(2,2).to_s + ((ad_date.year + 1).to_s.slice(2,2)).to_s
        end
    end

    def self.fiscal_year_for_bs_date(bs_year, bs_month, bs_day) # (2079, 2, 12) ==> 7879
        if bs_month < 4  #compare with start date of nepali fiscal year to determine the fiscal year
          fiscal_year = (bs_year - 1).to_s.slice(2,2).to_s + bs_year.to_s.slice(2,2).to_s
        else
          fiscal_year = bs_year.to_s.slice(2,2).to_s + (bs_year + 1).to_s.slice(2,2).to_s
        end
    end

    # [date] -> This is a Date object (and obviously represents AD date)
    # Returns the fiscal year represented as a string in the form of 7778.
    def self.fiscal_year_for_ad_date(date)
        bs_date = NepaliCalendar::BsCalendar.ad_to_bs(date.year.to_s, date.month.to_s, date.day.to_s)
        if bs_date.month < 4
          fiscal_year = ((bs_date.year - 1).to_s.slice(2,2)).to_s + bs_date.year.to_s.slice(2,2).to_s
        else
          fiscal_year =bs_date.year.to_s.slice(2,2).to_s + ((bs_date.year + 1).to_s.slice(2,2)).to_s
        end
    end

    def self.get_fiscal_year_from_bs(bs_date) # "20790218" represents 18th Jestha 2079
        year = bs_date.slice(0,4).to_i
        month = bs_date.slice(4, 2).to_i
        day = bs_date.slice(6, 2).to_i
        if month < 4  #compare with start date of nepali fiscal year to determine the fiscal year
          fiscal_year = (year - 1).to_s.slice(2,2).to_s + year.to_s.slice(2,2).to_s
        else
          fiscal_year = year.to_s.slice(2,2) + (year + 1).to_s.slice(2,2)
        end
    end

    def self.current_fiscal_year
      current_year = NepaliCalendar::BsCalendar.ad_to_bs(Date.today.year, Date.today.month, Date.today.day)
      if current_year.month < 4
        fiscal_year = (current_year.year-1).to_s.slice(2,2) + current_year.year.to_s.slice(2,2)
      else
        fiscal_year = current_year.year.to_s.slice(2,2) + (current_year.year+1).to_s.slice(2,2)
      end

      NepaliCalendar::FiscalYear.new(fiscal_year.to_s.slice(0,2), fiscal_year.to_s.slice(2,2))
    end
        
        # Should return the '7879' form of string.
    def to_s
        start_year.to_s + end_year.to_s
    end

end