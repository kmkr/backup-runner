#!/usr/bin/ruby

require "optparse"
require_relative 'settings'
require_relative 'runner'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: backup-runner.rb [options]"

  opts.on("-d", "--delete", "Delete files on targets that are removed from source") do |v|
    options[:delete] = true
  end

  opts.on("--real", "Active real mode (deactivate dry run)") do |v|
  	options[:real] = true
  end
end.parse!

Settings.load!("config.yml")

Runner.new(Settings.assets).run(options)
