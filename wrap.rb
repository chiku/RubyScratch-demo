module Intercept
  # code goes in here

  def self.included(base)
    base.instance_eval do

      @methods = []

      def method_added(name)
        if !name.to_s.start_with?("pristine") && !@methods.include?(name)
          @methods << name
          new_name = "pristine #{name}"

          alias_method new_name, name

          define_method(name) do
            puts "Trace: enter #{name}"
            send(new_name)
            puts "Trace: end #{name}"
          end
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

# Final output =>
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
