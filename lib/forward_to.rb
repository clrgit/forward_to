# frozen_string_literal: true

require_relative "forward_to/version"

module ForwardTo
  class Error < StandardError; end

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
  #     def initialize()
  #       @implementation = []
  #     end
  #   end
  #
  #   a = MyArray.new
  #   a.size # -> 0
  #
  # The target of #forward_to can be a method or a member (@variable) but has
  # to be a symbol
  #
  def forward_to(target, *methods)
    for method in Array(methods).flatten
      if method =~ /=$/
        class_eval("def #{method}(*args) #{target}&.#{method}(*args) end")
      else
        class_eval("def #{method}(*args, &block) #{target}&.#{method}(*args, &block) end")
      end
    end
  end
end
