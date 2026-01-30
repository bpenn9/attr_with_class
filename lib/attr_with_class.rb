# frozen_string_literal: true

require "attr_with_class/version"

# references (for Dev Degree)
# https://stackoverflow.com/questions/900419/how-to-understand-the-difference-between-class-eval-and-instance-eval
# https://stackoverflow.com/questions/74885066/understanding-class-eval-and-instance-eval
# https://blog.appsignal.com/2023/07/26/an-introduction-to-metaprogramming-in-ruby.html
# https://medium.com/@camfeg/dynamic-method-definition-with-rubys-define-method-b3ffbbee8197

module AttrWithClass
  def self.verify_class_or_subclass(expected_class, value)
    raise(ArgumentError, "#{value} is not a #{expected_class}.") unless value.class <= expected_class
  end

  def self.verify_non_negative_integer(value)
    raise(ArgumentError, "#{value} is not a non-negative integer (must be >= 0).") \
      unless value.class <= Integer && value >= 0
  end
end

# pass writes to any of attr_symbols to the handler block

def attr_writer_with_handler(*attr_symbols, &handler)
  attr_symbols.each do |attr_symbol|
    attr_setter_symbol = :"#{attr_symbol}="
    instance_attr_symbol = :"@#{attr_symbol}"

    define_method(attr_setter_symbol) do |new_attr_value|
      new_attr_value = handler.call(new_attr_value)
      instance_variable_set(instance_attr_symbol, new_attr_value)
    end
  end
end

def attr_accessor_with_handler(*attr_symbols, &handler)
  attr_writer_with_handler(*attr_symbols, &handler)
  attr_reader(*attr_symbols)
end

# writed to any of attr_symbols are checked for class or subclass
# special case of attr_writer_with_handler / attr_accessor_with_handler

def attr_writer_with_class(expected_class, *attr_symbols)
  attr_writer_with_handler(*attr_symbols) do |new_attr_value|
    AttrWithClass.verify_class_or_subclass(expected_class, new_attr_value)
    new_attr_value
  end
end

def attr_accessor_with_class(expected_class, *attr_symbols)
  attr_accessor_with_handler(*attr_symbols) do |new_attr_value|
    AttrWithClass.verify_class_or_subclass(expected_class, new_attr_value)
    new_attr_value
  end
end

# enforces that all inputs are Integer and >= 0
# special case of attr_writer_with_handler / attr_accessor_with_handler

def attr_writer_with_non_negative_integer(*attr_symbols)
  attr_writer_with_handler(*attr_symbols) do |new_attr_value|
    AttrWithClass.verify_non_negative_integer(new_attr_value)
    new_attr_value
  end
end

def attr_accessor_with_non_negative_integer(*attr_symbols)
  attr_accessor_with_handler(*attr_symbols) do |new_attr_value|
    AttrWithClass.verify_non_negative_integer(new_attr_value)
    new_attr_value
  end
end
