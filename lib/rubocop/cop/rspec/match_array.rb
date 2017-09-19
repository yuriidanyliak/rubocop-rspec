module RuboCop
  module Cop
    module RSpec
      # Prefer `contain_exactly` when matching an array literal.
      #
      # @example
      #   # bad
      #   it { is_expected.to match_array([content1, content2]) }
      #
      #   # good
      #   it { is_expected.to contain_exactly(content1, content2) }
      #
      #   # good
      #   it { is_expected.to match_array([content] + array) }
      class MatchArray < Cop
        MSG = 'Prefer `contain_exactly` when matching an array literal.'.freeze

        def on_send(node)
          return unless node.method_name == :match_array
          return unless node.child_nodes.one?
          return unless node.child_nodes.first.array_type?

          add_offense node, :expression
        end

        def autocorrect(node)
          _receiver, _method_name, *args = *node

          lambda do |corrector|
            array_contents = args.flat_map(&:to_a)
            corrector.replace(
              node.source_range,
              "contain_exactly(#{array_contents.map(&:source).join(', ')})"
            )
          end
        end
      end
    end
  end
end
