require 'guard'
require 'guard/guard'
require 'json'
require 'yaml'

module Guard
  class I18next < Guard
    
    DEFAULT_OPTIONS = {
        :output         => Pathname.pwd.join('app', 'assets', 'javascripts', 'i18n'),
    }

    # Initialize Guard::i18next
    #
    # @param [Array<Guard::Watcher>] watchers the watchers in the Guard block
    # @param [Hash] options the options for the Guard
    # @option options [String] :output the output directory
    #
    def initialize(watchers = [], options = {})
      watchers = [] if !watchers
      defaults = DEFAULT_OPTIONS.clone

      super(watchers, defaults.merge(options))
    end
    
    # Gets called when watched paths and files have changes.
    #
    # @param [Array<String>] paths the changed paths and files
    # @raise [:task_has_failed] when stop has failed
    #
    def run_on_change(paths)
      Dir::mkdir(options[:output]) unless File.directory?(options[:output])

      paths.each do |locale_path|
        filename = File.basename(locale_path, ".yml")
        input = File.new(locale_path, 'r')
        locale = YAML.load(input.read)
        input.close

        locale.keys.each do |locale_key|
          locale_filename = (filename.end_with? locale_key) ? filename : "#{filename}.#{locale_key}"
          File.open(options[:output] + "/#{locale_filename}.json", "w") do |f|
              f.puts locale[locale_key].to_json
          end
        end
      end
    end

  end
end
