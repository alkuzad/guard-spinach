module Guard
  class Spinach
    class Runner
      attr_reader :paths, :options

      def initialize(paths, opts = nil)
        @paths = paths
        @options = opts || {}
      end

      def run
        puts "Running #{paths.empty? ? "all Spinach features" : paths.join(" ")}"
        system(run_command)
        notify($? == 0)
      end

      def run_command
        cmd = []
        cmd << @options[:command_prefix] if @options[:command_prefix]
        if @options[:binstubs]
          cmd << 'bin/spinach'
        else
          if @options[:cmd] && @options[:cmd].present?
            cmd << @options[:cmd]
          else
            cmd << 'spinach'
          end
        end
        cmd << paths.join(" ")
        cmd << '-g' if @options[:generate]
        cmd << "-t #{@options[:tags].join(',')}" if @options[:tags] && @options[:tags].any?
        cmd << '-b' if @options[:backtrace]
        cmd << "-r #{@options[:reporter]}" if @options[:reporter] && options[:reporter].present?
        cmd << "-f #{@options[:features_path]}" if @options[:features_path] && @options[:features_path].present?
        cmd << "--fail-fast" if @options[:fail_fast]
        cmd << "-c #{@options[:config_path]}" if @options[:config_path] && @options[:config_path].present?
        cmd.join(" ")
      end

      def notify(passed)
        opts = {title: 'Spinach results', priority: 2}

        if passed
          status = 'Passed'
          image = :success
        else
          status = 'Failed'
          image = :failed
        end

        Guard::Compat::UI.notify(status, opts.merge(image: image))
      end
    end
  end
end
