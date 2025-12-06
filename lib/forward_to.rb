# frozen_string_literal: true

require_relative "forward_to/version"

module ForwardTo
  # Forward methods to member object, arguments can be strings or symbols
  #
  # Forward to takes the first argument and creates methods for the rest of the
  # arguments that forward their call to the first argument. Example
  #
  #   include ForwardTo
  #
  #   class MyArray
  #     forward_to :@implementation, :empty?, :size, :[]
  #
  #     def initialize(a = [])
  #       @implementation = a
  #     end
  #   end
  #
  #   a = MyArray.new
  #   a.size # -> 0
  #   a.empty? # -> true
  #   a[0] = 1
  #   a[0] # -> 1
  #   a.implementation # Error - see attr_forward
  #
  # The target of #forward_to can be an attribute or a member variable
  #
  def forward_to(target, *methods) = impl_forward_to(target, methods, class_method: false)

  # :call-seq:
  #   forward_to_class(class, *methods)
  #   forward_to_class(class-method, *methods)
  #
  # Create class methods that forwards to class or to the given class method:
  #
  #   module Mod
  #     def self.module_method() = "other"
  #   end
  #
  #   class Klass
  #     def self.class_method() = "string"
  #     forward_to_class :class_method, :size
  #     forward_to_class Mod, :module_method
  #   end
  #
  #   Klass.size # -> 5
  #   Klass.module_method # -> "other"
  #
  def forward_to_class(target, *methods) = impl_forward_to(target.to_s, methods, class_method: true)


  # Like #forward_to but also add an attr reader method for the member object:
  #
  #   include ForwardTo
  #
  #   class MyArray
  #     attr_forward :implementation, :empty?, :size, :[]
  #
  #     def initialize(a = [])
  #       @implementation = a
  #     end
  #   end
  #
  #   a = MyArray.new([1, 2, 3])
  #   a.implementation # -> [1, 2, 3]
  #
  # The target of #attr_reader should be an attribute
  #
  def attr_forward(target, *methods)
    class_eval("attr_reader :#{target}")
    forward_to(target, *methods)
  end

private
  def impl_forward_to(target, *methods, class_method: false)
    qual = class_method ? "self." : ""
    for method in Array(methods).flatten
      case method
        when /\[\]=/
          class_eval("def #{qual}#{method}(*args) #{target}&.#{method}(*args) end")
        when /=$/
          class_eval("def #{qual}#{method}(args) #{target}&.#{method}(args) end")
        else
          class_eval("def #{qual}#{method}(*args, &block) #{target}&.#{method}(*args, &block) end")
      end
    end
  end
end

