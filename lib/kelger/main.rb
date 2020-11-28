# frozen_string_literal: true

require 'json'
require 'kelger/readme'
require 'kelger/version'
require 'optparse'

module Kelger
  # Main class
  class Main
    @input = nil
    @output = nil
    @version = nil
    def start
      opt = OptionParser.new
      opt.on('-i VAL') do |v|
        @input = v
      end
      opt.on('-o VAL') do |v|
        @output = v
      end
      opt.on('-v') do |_v|
        @version = true
      end
      opt.parse!(ARGV)
      if @version
        puts "Kelger #{Kelger::VERSION}"
        exit
      end
      raise ArgumentError, '-i with value' if @input.nil?
      raise ArgumentError, '-o with value' if @output.nil?
      raise ArgumentError, 'input must be directory' unless Dir.exist?(@input)

      run(@input, @output)
    end

    def run(input, output)
      object = {
        repository_name: 'YACP',
        num_packages: 0
      }
      packages = []
      Dir.open(input).sort.each do |package_name|
        next if package_name.start_with?('.') # skip '.', '..', '.git'
        next if package_name.end_with?('.md') # skip markdown

        packagedir = Dir.open(File.join(input, package_name))
        package = {}
        Dir.chdir(packagedir) do
          cygport = Dir.glob('*.cygport')
          next if cygport.empty?

          cygport = cygport[0]
          pnv = cygport.gsub(/-[0-9]+bl[0-9]+\.cygport$/, '').gsub(/\+(hg|git|svn).+$/, '').gsub(/-((alpha|beta|pre|p|r|rc)[0-9.]*)$/, '\1')
          matched = /(.*)-(.*)/.match(pnv)
          name = matched[1]
          version = matched[2]
          category = nil
          summary = nil
          File.open(cygport).each do |line|
            matched = /CATEGORY="([^"$]+)"/.match(line)
            category = matched[1] unless matched.nil?
            matched = /SUMMARY="([^"$]+)"/.match(line)
            summary = matched[1] unless matched.nil?
          end
          name.gsub!(/^ros-/, 'ros:')
          package[:name] = name
          package[:version] = version
          package[:category] = category.nil? ? [] : category.split(' ')
          package[:summary] = summary.nil? ? '' : summary
          readme = Dir.glob('README')
          next if readme.empty?

          info = Readme.parse(File.read(readme[0]))
          package[:homepage] = info[:homepage]
          package[:subpackages] = info[:subpackages].map do |subname|
            { name: subname, category: package[:category] }
          end
          package[:maintainers] = ['Daisuke Fujimura']
        end
        packages << package unless package.empty?
        object[:num_packages] += 1 # count packages
      end
      object[:timestamp] = Time.now.to_i
      object[:packages] = packages
      File.open(output, 'w') do |f|
        f.write(JSON.dump(object))
      end
    end
  end
end
