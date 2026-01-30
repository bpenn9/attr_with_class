# frozen_string_literal: true

# require_relative "./test_helper"

require "test/unit"

require_relative "../lib/attr_with_class"

class AttrHelperTest < Test::Unit::TestCase
  attr_writer_with_class Numeric, :must_be_numeric, :must_also_be_numeric
  attr_writer_with_handler :must_be_number_one do |x|
    raise(ArgumentError, "#{x} must be the number one") unless x == 1

    x
  end

  attr_accessor_with_class String, :string_that_can_be_accessed

  attr_accessor_with_non_negative_integer :non_negative_integer

  def test_numeric_setter_1
    self.must_be_numeric = 5
  end

  def test_numeric_setter_2
    self.must_also_be_numeric = 10
  end

  def test_numeric_setter_fails_for_string
    error = assert_raise(ArgumentError) do
      self.must_be_numeric = "abc"
    end
    assert(error.message.include?("abc"))
  end

  def test_number_one_setter
    self.must_be_number_one = 1
  end

  def test_number_one_setter_fails
    error = assert_raise(ArgumentError) do
      self.must_be_number_one = 2
    end
    assert_equal("2 must be the number one", error.message)
  end

  def test_string_access
    self.string_that_can_be_accessed = "xyz"
    assert_equal("xyz", string_that_can_be_accessed)
  end

  def test_non_negative_integer_accessor
    self.non_negative_integer = 5
    assert_equal(5, non_negative_integer)
  end

  def test_non_negative_integer_accessor_allows_zero
    self.non_negative_integer = 0
    assert_equal(0, non_negative_integer)
  end

  def test_non_negative_integer_accessor_fails_for_negative_integer
    assert_raise(ArgumentError) do
      self.non_negative_integer = -5
    end
  end
end
