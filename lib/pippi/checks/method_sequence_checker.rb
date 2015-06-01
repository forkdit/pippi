class MethodSequenceChecker

  ARITY_TYPE_BLOCK_ARG = 1
  ARITY_TYPE_NONE = 2

  attr_reader :check_descriptor

  def initialize(check_descriptor)
    @check_descriptor = check_descriptor
  end

  def decorate
    check_descriptor.clazz_to_decorate.class_exec(check_descriptor.check, self) do |my_check, method_sequence_check_instance|
      name = "@_pippi_check_#{my_check.class.name.split('::').last.downcase}"
      self.instance_variable_set(name, my_check)
      self.class.send(:define_method, name[1..-1]) do
        instance_variable_get(name)
      end

      # e.g., "size" in "select followed by size"
      second_method_decorator = if method_sequence_check_instance.check_descriptor.second_method_arity_type.kind_of?(Module)
        method_sequence_check_instance.check_descriptor.second_method_arity_type
      else
        Module.new do
          define_method(method_sequence_check_instance.check_descriptor.method2) do |*args, &blk|
            # Using "self.class" implies that the first method invocation returns the same type as the receiver
            # e.g., Array#select returns an Array.  Would need to further parameterize this to get
            # different behavior.
            self.class.instance_variable_get(name).add_problem
            if method_sequence_check_instance.check_descriptor.should_check_subsequent_calls && method_sequence_check_instance.check_descriptor.clazz_to_decorate == self.class
              problem_location = caller_locations.find { |c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
              self.class.instance_variable_get(name).method_names_that_indicate_this_is_being_used_as_a_collection.each do |this_means_its_ok_sym|
                define_singleton_method(this_means_its_ok_sym, self.class.instance_variable_get(name).clear_fault_proc(self.class.instance_variable_get(name), problem_location))
              end
            end
            if method_sequence_check_instance.check_descriptor.second_method_arity_type == ARITY_TYPE_BLOCK_ARG
              super(&blk)
            elsif method_sequence_check_instance.check_descriptor.second_method_arity_type == ARITY_TYPE_NONE
              super()
            end
          end
        end
      end

      # e.g., "select" in "select followed by size"
     first_method_decorator = Module.new do
        define_method(method_sequence_check_instance.check_descriptor.method1) do |*args, &blk|
          result = if method_sequence_check_instance.check_descriptor.first_method_arity_type == ARITY_TYPE_BLOCK_ARG
            super(&blk)
          elsif method_sequence_check_instance.check_descriptor.first_method_arity_type == ARITY_TYPE_NONE
            super()
          end
          if self.class.instance_variable_get(name)
            result.extend second_method_decorator
            self.class.instance_variable_get(name).mutator_methods(result.class).each do |this_means_its_ok_sym|
              result.define_singleton_method(this_means_its_ok_sym, self.class.instance_variable_get(name).its_ok_watcher_proc(second_method_decorator, method_sequence_check_instance.check_descriptor.method2))
            end
          end
          result
        end
      end
      prepend first_method_decorator
    end
  end

  def its_ok_watcher_proc(clazz, method_name)
    proc do |*args, &blk|
      begin
        singleton_class.ancestors.find { |x| x == clazz }.instance_eval { remove_method method_name }
      rescue NameError
        return super(*args, &blk)
      else
        return super(*args, &blk)
      end
    end
  end
end
