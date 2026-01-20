require "attr_with_class/version"

# frozen_string_literal: true

# https://stackoverflow.com/questions/900419/how-to-understand-the-difference-between-class-eval-and-instance-eval
# https://stackoverflow.com/questions/74885066/understanding-class-eval-and-instance-eval
# https://blog.appsignal.com/2023/07/26/an-introduction-to-metaprogramming-in-ruby.html
# https://medium.com/@camfeg/dynamic-method-definition-with-rubys-define-method-b3ffbbee8197

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

# special cases of attr_setter/accessor_with_handler

def verify_class_or_subclass(expected_class, value)
  raise(ArgumentError, "#{value} is not a #{expected_class}.") unless value.class <= expected_class
end

def attr_setter_with_class(expected_class, *attr_symbols)
  attr_writer_with_handler(*attr_symbols) do |new_attr_value|
    verify_class_or_subclass(expected_class, new_attr_value)

    new_attr_value
  end
end

def attr_accessor_with_class(expected_class, *attr_symbols)
  attr_accessor_with_handler(*attr_symbols) do |new_attr_value|
    verify_class_or_subclass(expected_class, new_attr_value)

    new_attr_value
  end
end

def verify_positive_integer(value)
  raise(ArgumentError, "#{value} is not a positive integer and must be greater than zero.") \
    unless value.class <= Integer && value >= 0
end

def attr_writer_with_positive_integer(*attr_symbols)
  attr_writer_with_handler(*attr_symbols) do |new_attr_value|
    verify_positive_integer(new_attr_value)

    new_attr_value
  end
end

def attr_accessor_with_positive_integer(*attr_symbols)
  attr_accessor_with_handler(*attr_symbols) do |new_attr_value|
    verify_positive_integer(new_attr_value)

    new_attr_value
  end
end

