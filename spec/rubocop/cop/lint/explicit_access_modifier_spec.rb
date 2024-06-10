# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Lint::ExplicitAccessModifier, :config do
  context 'when an access modifier used to change visibility level "up"' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class SomeClass
          def public_method
          end

          private

          def private_method
          end

          public
          ^^^^^^ Previous visibility level was lower (`private`).

          def another_public_method
          end
        end
      RUBY
    end
  end

  context 'when multiple access modifiers used to change visibility level "up"' do
    it 'registers all offenses' do
      expect_offense(<<~RUBY)
        class SomeClass
          def public_method
          end

          protected

          def protected_method
          end

          private

          def private_method
          end

          protected
          ^^^^^^^^^ Previous visibility level was lower (`private`).

          def another_public_method
          end

          public
          ^^^^^^ Previous visibility level was lower (`protected`).

          def another_protected_method
          end
        end
      RUBY
    end
  end

  context 'when inline access modifier used to change visibility level "up"' do
    it "registers an offense" do
      expect_no_offenses(<<~RUBY)
       class Foo
          private def private_method; end
          public def public_method; end
        end
      RUBY
    end
  end

  context 'when access modifier on symbols used to change visibility leve "up"' do
    it "registers an offense" do
      expect_no_offenses(<<~RUBY)
        class Foo
          private :private_method
          public :public_method

          def private_method; end

          def public_method; end
        end
      RUBY
    end
  end
end
