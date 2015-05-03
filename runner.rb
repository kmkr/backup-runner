class Runner
	def initialize(assets)
		@assets = assets
	end

	def run(options)
		mounts_found = []
		@assets.each do |asset|
			source = asset["source"]
			targets = asset["targets"]
			includes = asset["includes"]
			excludes = asset["excludes"]

			puts "======================================================="
			puts "#{source}"
			puts "======================================================="

			unless targets
				puts "WARN: No targets found for #{source}, skipping"
				next
			end

			targets.each do |target|
				unless File.directory? target
					puts "WARN: No such target directory #{target} found"
					next
				end
				mounts_found << target
				check_space target
				process_target source, target, includes, excludes, options
			end
		end

		if mounts_found.length
			puts "======================================================="
			puts " Remember to umount!"
			mounts_found.each_with_index do |target, index|
				puts "  #{index+1}) #{target}"
			end
			puts "======================================================="
		end
	end

	private

	def check_space (target)
		puts "Checking space for target #{target}"
		match = target.match(/([a-f1-9]+\-)+/)	
		if match
			puts `df -ah | grep #{match[1]}`
		else
			puts "Unable to check space"
		end
	end

	def process_target(source, target, includes, excludes, options)

		command = "rsync -r -v --progress -t"
		command = command + " --delete" if options[:delete]
		if includes
			includes.each do |include|
				command = command + " --include '#{include}'"
			end

			command = command + " --include '*/'"
			command = command + " --exclude '*'"
			command = command + " --prune-empty-dirs"
		elsif excludes
			excludes.each do |exclude|
				command = command + " --exclude '#{exclude}'"
			end

			command = command + " --include '*'"
			command = command + " --prune-empty-dirs"
		end
		command = command + " --size-only '#{source}' '#{target}'"
		command = command + " --dry-run" unless options[:real]

		unless command.match(/--dry-run/)
			puts "You have chosen not running this dry. Are you sure? y/[n]"
			inp = gets.chomp
			if inp != "y"
				puts "Exiting"
				exit
			end
		end

		puts "Will run:"
		puts command
		puts "Continue? y/[n]"
		inp = gets.chomp
		if inp == "y"
			IO.popen(command) { |f|
				until f.eof?
					puts f.gets
				end
			}
		end
	end
end
