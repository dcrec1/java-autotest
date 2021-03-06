class AutoTest
	attr_accessor :run_at, :files

	def initialize
		@run_at = Time.new
		@files = File.find_java_files
	end	
	
	def listen
		@files.each do |file|
			if (File.atime(file).to_i > @run_at.to_i)
				run(file) 
				break
			end
		end
		true
	end
	
	def run(file)
		test_class = find_test_class file
		puts "Running test to #{test_class}."
		green = TestRunner.run_test(test_class)
		TestRunner.run_all_tests if green
		reset 
	end
	
	def find_test_class(file)
		return file.split("/").last.split(".java").last.concat("Test.java") unless file.include? "Test.java"
		return file.split("/").last if file.include? "Test.java"
	end
	
	def reset
		@run_at = Time.new
	end
end
