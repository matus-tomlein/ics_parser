require 'ostruct'
require 'time'

class EventParser
  def initialize(calendar_content)
    @calendar_content = calendar_content
  end

  def events
    events = []

    get_events_in_calendar.each do |event|
      summary = parse_summary event
      starts_at = parse_starts_at event
      ends_at = parse_ends_at event

      if recurring_event? event
        recurring_dates = parse_recurring_dates(event)

        recurring_dates.each do |recurring_starts_at, recurring_ends_at|
          events << new_event(summary,
                              recurring_starts_at,
                              recurring_ends_at)
        end
      else
        events << new_event(summary,
                            starts_at,
                            ends_at)
      end
    end

    events
  end

  private

  def new_event(summary, starts_at, ends_at)
    OpenStruct.new(summary: summary,
                   starts_at: starts_at,
                   ends_at: ends_at)
  end

  def get_events_in_calendar
    beginnings = @calendar_content.split('BEGIN:VEVENT')
    events = []

    beginnings.each do |event_beginning|
      next unless event_beginning.include? 'END:VEVENT'

      events << event_beginning.split('END:VEVENT').first
    end

    events
  end

  def parse_summary(event)
    /SUMMARY:(.*)/.match(event)[1].strip
  end

  def parse_starts_at(event)
    Time.parse(/DTSTART[\w\/=;]*:(\d+T\d+)/.match(event)[1])
  end

  def parse_ends_at(event)
    Time.parse(/DTEND[\w\/=;]*:(\d+T\d+)/.match(event)[1])
  end

  def recurring_event?(event)
    event.include? 'RRULE:FREQ=WEEKLY;'
  end

  def parse_recurring_dates(event)
    recurring_dates = {}
    starts_at = parse_starts_at event
    ends_at = parse_ends_at event
    summary = parse_summary event

    if event.include? 'RRULE:FREQ=WEEKLY;COUNT='
      count = /RRULE:FREQ=WEEKLY;COUNT=(\d+)/.match(event)[1].to_i

      count.times do |i|
        recurring_starts_at = add_days_to_time(starts_at, i * 7)
        recurring_ends_at = add_days_to_time(ends_at, i * 7)

        unless is_date_excluded?(recurring_starts_at, event)
          recurring_dates[recurring_starts_at] = recurring_ends_at
        end
      end

    elsif event.include? 'RRULE:FREQ=WEEKLY;UNTIL='
      until_time = Time.parse(/RRULE:FREQ=WEEKLY;UNTIL=(\d+T\d+)/.match(event)[1])

      last_starts_at = starts_at
      last_ends_at = ends_at

      while last_starts_at <= until_time
        unless is_date_excluded?(last_starts_at, event)
          recurring_dates[last_starts_at] = last_ends_at
        end

        last_starts_at = add_days_to_time(last_starts_at, 7)
        last_ends_at = add_days_to_time(last_ends_at, 7)
      end

    else
      raise "Unsupported recurring event type: #{summary}"
    end

    recurring_dates
  end

  def is_date_excluded?(date, event)
    date_str = date.strftime '%Y%m%dT%I%M%S'
    not_excluded = /EXDATE[\w\/=;]*:#{date_str}/.match(event).nil?
    !not_excluded
  end

  def add_days_to_time(time, days)
    time + (days * 24 * 60 * 60)
  end
end
