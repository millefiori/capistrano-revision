require "capistrano/revision/version"

module Capistrano
  module Revision
    extend self

    def latest?
      current == deployed
    end

    def current
      File.read('REVISION').chomp rescue nil
    end

    def deployed
      if File.exist? revision_log
        tail(revision_log) =~ %r"Branch .+ \(at (\w+)\)"
        $1
      end
    end

    def tail filename
      File.open filename do |file|
        file.seek -[line_length, File.size(filename)].min, IO::SEEK_END
        body = file.read
        body.lines.map(&:chomp).last
      end
    end

    def revision_log
      '../../revisions.log'
    end

    def line_length
      70 + 32 + 40 + 14 + 16 # revision_log_message.size + branch + sha1 + release + user
    end
  end
end
