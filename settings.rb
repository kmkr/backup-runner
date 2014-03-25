require 'yaml'

module Settings
  # again - it's a singleton, thus implemented as a self-extended module
  extend self

  @_settings = {}
  attr_reader :_settings

  def load!(filename, options = {})
    filepath = File.symlink?(__FILE__) ? File.dirname(File.readlink(__FILE__)) : File.dirname(__FILE__)
    raise "No config" unless File.exists? "#{filepath}/#{filename}"
    newsets = YAML::load_file("#{filepath}/#{filename}")
    @_settings = newsets
  end

  def method_missing(name, *args, &block)
    @_settings[name.to_s]
  end

end