# frozen_string_literal: true

require_relative "forward_to/version"

module ForwardTo
  # Forward methods to member object. The arguments should be strings or symbols
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
  #
  # The target of #forward_to can be an attribute or a member variable
  #
  def forward_to(target, *methods)
    for method in Array(methods).flatten
      case method
        when /\[\]=/
          class_eval("def #{method}(*args) #{target}&.#{method}(*args) end")
        when /=$/
          class_eval("def #{method}(args) #{target}&.#{method}(args) end")
        else
          class_eval("def #{method}(*args, &block) #{target}&.#{method}(*args, &block) end")
      end
    end
  end

  # List #forward_to but also an attr reader method for the member object:
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
end

