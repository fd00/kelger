# frozen_string_literal: true

module Kelger
  # Extract values from README
  class Readme
    def self.parse(str = '')
      mode = nil
      homepage = nil
      subpackages = []
      str.each_line do |line|
        line.rstrip!
        if line == 'Canonical website:'
          mode = :homepage
          next
        end
        if line == 'Files included in the binary package:'
          mode = :subpackages
          next
        end

        if mode == :homepage
          homepage = line.lstrip
          mode = nil
        end
        next unless mode == :subpackages

        matched = line.match(/^\((.*)\)$/)
        subpackages << matched[1] unless matched.nil?
      end
      { homepage: homepage.gsub(/\P{ASCII}/, ''), subpackages: subpackages }
    end
  end
end
