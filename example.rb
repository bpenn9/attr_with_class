require "attr_with_class"

class A 
  attr_accessor_with_class String, :must_be_a_string
end
a = A.new

a.must_be_a_string = "abcd"

# error!
a.must_be_a_string = 5
