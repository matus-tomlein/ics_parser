IcsParser
=========

Reads an ICalendar file and returns the events in an array.

Also supports recurring events with excluded dates (using EXDATE).

It is not complete and I have only tested it on my feed (exported from Apple iCloud)
so do not rely on it.

# Example

```
require 'ics_parser'

parser = IcsParser.from_file('path/to/file')
# or parser = IcsParser.from_string(calendar)
events = parser.events

events.each do |event|
  puts event.summary # string
  puts event.starts_at # Time
  puts event.ends_at # Time
end
```

# Installation

```
gem install ics_parser
```
