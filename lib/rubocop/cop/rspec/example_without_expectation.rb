# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Checks for examples without expectations.
      #
      # @example
      #
      #   # bad
      #   describe UserCreator do
      #     it 'builds a user' do
      #       build(:user)
      #     end
      #   end
      #
      #   # good
      #   describe UserCreator do
      #     it 'builds a user' do
      #       expect(build(:user)).to be_valid
      #     end
      #   end
      #
      class ExampleWithoutExpectation < Cop
        MSG = 'Example does not have at least one expectation.'.freeze

        def_node_matcher :expect?, Expectations::ALL.send_pattern

        def on_block(node)
          return unless example?(node)

          expectations_count = to_enum(:find_expectation, node).count

          return if expectations_count >= 1

          flag_example(node)
        end

        private

        def find_expectation(node, &block)
          yield if expect?(node)

          node.each_child_node do |child|
            find_expectation(child, &block)
          end
        end

        def flag_example(node)
          method, = *node

          add_offense(
            method,
            location: :expression,
            message: format(MSG)
          )
        end
      end
    end
  end
end
