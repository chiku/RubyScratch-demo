module Intercept
  # code goes in here

  def self.included(base)
    base.instance_eval do
      def method_added(name)
        class_eval do
          puts "#{self.name} : #{name}"
        end
      end
    end
  end
end

class Test

  include Intercept

  def initialize
    puts "start initialize"
    puts "end initialize"
  end

  def foo
    puts "start foo"
    bar
    puts "end foo"
  end

  def bar
    puts "start bar"
    baz
    puts "end bar"
  end

  def baz
    puts "start baz"
    puts "end baz"
  end

end

Test.new.foo
# Current output =>
# start initialize
# end initialize
# start foo
# start bar
# start baz
# end baz
# end bar
# end foo

# Intended output =>
# Trace: enter initialize
# start initialize
# end initialize
# Trace: leave initialize
# Trace: enter foo
# start foo
# Trace: enter bar
# start bar
# Trace: enter baz
# start baz
# end baz
# Trace: leave baz
# end bar
# Trace: leave bar
# end foo
# Trace: leave foo
