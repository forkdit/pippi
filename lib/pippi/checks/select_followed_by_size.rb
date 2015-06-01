module Pippi::Checks
  class SelectFollowedBySize < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      check_descriptor = CheckDescriptor.new(self)
      check_descriptor.clazz_to_decorate = Array
      check_descriptor.method1 = "select"
      check_descriptor.method2 = "size"
      check_descriptor.first_method_arity_type = MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG
      check_descriptor.second_method_arity_type = MethodSequenceChecker::ARITY_TYPE_NONE
      @mycheck = MethodSequenceChecker.new(check_descriptor)
    end

    class Documentation
      def description
        "Don't use select followed by size; use count instead"
      end

      def sample
        '[1,2,3].select {|x| x > 1 }.size'
      end

      def instead_use
        '[1,2,3].count {|x| x > 1 }'
      end
    end
  end
end
