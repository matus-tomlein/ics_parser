require_relative 'event_parser'

class IcsParser
  def self.from_file(file)
    from_string(File.read(file))
  end

  def self.from_string(text)
    return IcsParser.new(text)
  end

  def initialize(calendar_content)
    @calendar_content = calendar_content
  end

  def events
    EventParser.new(@calendar_content).events
  end
end
