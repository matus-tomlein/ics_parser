require_relative 'spec_helper'

describe EventParser do
  let(:sample_data) { File.read 'spec/sample.ics' }
  let(:parser) { EventParser.new(sample_data) }

  context 'one time event' do
    let(:event) do
      parser.events.find {|event| event.summary == 'one time event' }
    end

    it 'has the right start time' do
      expect(event.starts_at).to eq Time.new(2015, 2, 24, 12, 30)
    end

    it 'has the right end time' do
      expect(event.ends_at).to eq Time.new(2015, 2, 24, 13, 15)
    end
  end

  context 'recurring weekly event' do
    let(:events) do
      parser.events.find_all {|event| event.summary == 'recurring weekly event' }
    end

    it 'found 7 events' do
      expect(events.size).to eq 7
    end

    it 'have the right start times' do
      expected_times = [
        Time.new(2015, 4, 15, 14, 0),
        Time.new(2015, 4, 22, 14, 0),
        Time.new(2015, 4, 29, 14, 0),
        Time.new(2015, 5, 6, 14, 0),
        Time.new(2015, 5, 13, 14, 0),
        Time.new(2015, 5, 20, 14, 0),
        Time.new(2015, 5, 27, 14, 0)
      ]
      times = events.map {|event| event.starts_at }
      expect(times).to eq expected_times
    end

    it 'have the right end times' do
      expected_times = [
        Time.new(2015, 4, 15, 16, 0),
        Time.new(2015, 4, 22, 16, 0),
        Time.new(2015, 4, 29, 16, 0),
        Time.new(2015, 5, 6, 16, 0),
        Time.new(2015, 5, 13, 16, 0),
        Time.new(2015, 5, 20, 16, 0),
        Time.new(2015, 5, 27, 16, 0)
      ]
      times = events.map {|event| event.ends_at }
      expect(times).to eq expected_times
    end
  end

  context 'recurring event with exdates' do
    let(:events) do
      parser.events.find_all {|event| event.summary == 'recurring event with exdates' }
    end

    it 'found some events' do
      expect(events.size).to be > 1
    end

    it 'contains the correct dates' do
      times = events.map {|event| event.starts_at }

      expect(times).to include Time.new(2014, 11, 19, 9, 0)
      expect(times).to include Time.new(2014, 11, 26, 9, 0)
    end

    it 'didn\'t find the excluded events' do
      times = events.map {|event| event.starts_at }

      excluded_times = [
        Time.new(2015, 4, 8, 9, 0),
        Time.new(2015, 6, 10, 9, 0),
        Time.new(2015, 4, 15, 9, 0),
        Time.new(2015, 5, 20, 9, 0),
        Time.new(2015, 3, 25, 9, 0),
        Time.new(2015, 6, 3, 9, 0),
        Time.new(2014, 12, 3, 9, 0),
        Time.new(2015, 3, 11, 9, 0),
        Time.new(2015, 7, 8, 9, 0),
        Time.new(2014, 12, 24, 9, 0),
        Time.new(2014, 12, 31, 9, 0),
        Time.new(2015, 7, 1, 9, 0),
        Time.new(2015, 6, 24, 9, 0),
        Time.new(2015, 4, 1, 9, 0),
      ]

      excluded_times.each do |excluded_time|
        expect(times).not_to include excluded_time
      end
    end
  end
end
