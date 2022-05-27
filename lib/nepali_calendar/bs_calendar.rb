module NepaliCalendar
  class BsCalendar < NepaliCalendar::Calendar

    MONTHNAMES = %w{nil Baisakh Jestha Ashad Shrawn Bhadra Ashwin Kartik Mangshir Poush Magh Falgun Chaitra}
    DAYNAMES = %w{nil Aitabar Sombar Mangalbar Budhbar Bihibar Sukrabar Sanibar}
    class << self

      def ad_to_bs(year, month, day)
        raise NepaliCalendar::Calendar::NilDateFieldsException unless valid_date_input?(year, month, day)
        raise NepaliCalendar::Calendar::InvalidADDateException unless valid_ad_date?(year, month, day)

        ref_day_eng = get_ref_day_eng # 1994/1/1
        date_ad = Date.parse("#{year}/#{month}/#{day}")
        return unless date_in_range?(date_ad, ref_day_eng)

        days = total_days(date_ad, ref_day_eng)
        get_bs_date(days, ref_date['ad_to_bs']['bs']) # days = 10372 when '2022-05-26', ref_date = '2009/9/17'
      end

      def get_bs_date(days, ref_day_nep)

        wday = 7
        year, month, day = ref_day_nep.split('/').map(&:to_i)
        travel days, year: year, month: month, day: day, wday: wday
      end

      def today
        date = Date.today
        ad_to_bs(date.year, date.month, date.day)
      end
    end

    def beginning_of_week
      date = {year: year, month: month, day: day, wday: wday}
      days = (wday > 1) ? -(wday - 1) : 0
      NepaliCalendar::BsCalendar.travel days, date
    end

    def end_of_week
      date = {year: year, month: month, day: day, wday: wday}
      days = (wday < 7) ? (7 - wday) : 0
      NepaliCalendar::BsCalendar.travel days, date
    end

    def beginning_of_month
      date = {year: year, month: month, day: day, wday: wday}
      days = -(day - 1)
      NepaliCalendar::BsCalendar.travel days, date
    end

    def end_of_month
      date = {year: year, month: month, day: day, wday: wday}
      days = NepaliCalendar::BS[year][month] - day
      NepaliCalendar::BsCalendar.travel days, date
    end

      # Returns the bs date that is the beginning of the provided fiscal_year.
      def self.beginning_of_fiscal_year_in_bs(fiscal_year)
        start_year = fiscal_year.to_s.slice(0, 2).prepend('20')
        start_date = NepaliCalendar::Calendar.new(nil, {year: start_year, month: 4, day: 1}) #start date of fiscal year
      end


      # Returns the bs date that is the end of the provided fiscal_year.
      def self.end_of_fiscal_year_in_bs(fiscal_year)
        end_year = fiscal_year.to_s.slice(2, 2).prepend('20')
        end_date =  NepaliCalendar::Calendar.new(nil, {year: end_year, month: 3, day: NepaliCalendar::BS[end_year.to_i][2]}) #end date of fiscal year
      end


      # Returns the ad date that is the beginning of the provided fiscal_year.
      def self.beginning_of_fiscal_year_in_ad(fiscal_year)
        bs_start_date= beginning_of_fiscal_year_in_bs(fiscal_year)
        NepaliCalendar::AdCalendar.bs_to_ad(bs_start_date.year, bs_start_date.month, bs_start_date.day) #stard date in AD of the corresponding nepali date
      end

      # Returns the ad date that is the end of the provided fiscal_year.
      def self.end_of_fiscal_year_in_ad(fiscal_year)
        ad_end_date = end_of_fiscal_year_in_bs(fiscal_year)
        NepaliCalendar::AdCalendar.bs_to_ad(ad_end_date.year, ad_end_date.month, ad_end_date.day)  #end date in AD of the fiscal year
      end

      # Returns the fiscal year represented as a string in the form of 7778.
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
        bs_date = BsCalendar.ad_to_bs(date.year.to_s, date.month.to_s, date.day.to_s)
        if bs_date.month < 4
          fiscal_year = ((bs_date.year - 1).to_s.slice(2,2)).to_s + bs_date.year.to_s.slice(2,2).to_s
        else
          fiscal_year =bs_date.year.to_s.slice(2,2).to_s + ((bs_date.year + 1).to_s.slice(2,2)).to_s
        end

      end

      # Returns the current fiscal year represented as a string in the form of 7778.
      def self.current_fiscal_year
        current_year = NepaliCalendar::BsCalendar.ad_to_bs(Date.today.year, Date.today.month, Date.today.day)
        if current_year.month < 4
          fiscal_year = (current_year.year-1).to_s.slice(2,2) + current_year.year.to_s.slice(2,2)
        else
          fiscal_year = current_year.year.to_s.slice(2,2) + (current_year.year+1).to_s.slice(2,2)
        end
      end

    private

      def self.travel days, option = {}
        return if days.nil? && days.zero?

        if days < 0
          option = travel_backward(days, option)
        else
          option = travel_forward(days, option)
        end
        NepaliCalendar::BsCalendar.date_object(option)
      end

      def self.travel_forward days, option = {}
        year = option[:year]
        month = option[:month]
        day = option[:day]
        wday = option[:wday]

        while days != 0
          bs_month_days = NepaliCalendar::BS[year][month]
          day += 1
          wday += 1
          wday = 1 if wday > 7

          if day > bs_month_days
            month += 1
            day = 1
          end

          if month > 12
            year += 1
            month = 1
          end

          days -= 1
        end
        option = {year: year, month: month, day: day, wday: wday}
      end

      def self.travel_backward days, option = {}
        year = option[:year]
        month = option[:month]
        day = option[:day]
        wday = option[:wday]

        while days != 0
          day -= 1
          wday -= 1
          wday = 7 if wday < 1

          if day < 1
            month -= 1
            if month < 1
              year -= 1
              month = 12
            end
            day = NepaliCalendar::BS[year][month]
          end

          days += 1
        end
        option = {year: year, month: month, day: day, wday: wday}
      end

      def self.date_object date
        month_name = MONTHNAMES[date[:month]]
        wday_name = DAYNAMES[date[:wday]]
        option = { year: date[:year], month: date[:month], day: date[:day],
          wday: date[:wday], month_name: month_name, wday_name: wday_name }
        new('', option)
      end

      def self.get_ref_day_eng
         Date.parse(ref_date['ad_to_bs']['ad'])
      end

      def start_date
        date = view_context.params.fetch(:start_date, '')
        date.blank? ? NepaliCalendar::BsCalendar.today : to_bs_date(date)
      end

      def to_bs_date(date)
        d = date.split('-').map(&:to_i)
        d = NepaliCalendar::AdCalendar.bs_to_ad(d[0], d[1], d[2])
        NepaliCalendar::BsCalendar.ad_to_bs(d.year, d.month, d.day)
      end

      def date_range
        [
          start_date.beginning_of_month.beginning_of_week,
          start_date.end_of_month.end_of_week
        ]
      end


      
  end
end
