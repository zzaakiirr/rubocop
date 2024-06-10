# frozen_string_literal: true

module RuboCop
  module Cop
    module Lint
      # Checks for the explicit usage of access modifier
      #
      # @example
      #
      #   # bad
      #   class Foo
      #     def public_method
      #     end
      #
      #     private
      #
      #     def private_method
      #     end
      #
      #     public
      #
      #     def another_public_method
      #     end
      #   end
      #
      #   # good
      #   class Foo
      #     def public_method
      #     end
      #
      #     def another_public_method
      #     end
      #
      #     private
      #
      #     def private_method
      #     end
      #   end
      class ExplicitAccessModifier < Base
        MSG = 'Previous visibility level was lower (`%<previous>s`).'

        ACCESS_MODIFIER_LEVELS = { public: 2, protected: 1, private: 0 }.freeze

        def initialize(config = nil, options = nil)
          super

          @prev_vis_lvl = ACCESS_MODIFIER_LEVELS[:public]
        end

        def on_send(node)
          return unless node.bare_access_modifier?

          cur_vis_lvl = ACCESS_MODIFIER_LEVELS[node.method_name]
          return if cur_vis_lvl == @prev_vis_lvl

          if cur_vis_lvl > @prev_vis_lvl
            add_offense(
              node,
              message: format(MSG, previous: ACCESS_MODIFIER_LEVELS.key(@prev_vis_lvl))
            )
          end

          @prev_vis_lvl = cur_vis_lvl
        end
      end
    end
  end
end
