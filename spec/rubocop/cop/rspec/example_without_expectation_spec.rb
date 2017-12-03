# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::ExampleWithoutExpectation do
  subject(:cop) { described_class.new }

  context 'without configuration' do
    it 'flags example without expectation' do
      expect_offense(<<-RUBY)
        describe Foo do
          it 'builds an user with name' do
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Example does not have at least one expectation.
            user = build(:user)
            user.name.present?
          end
        end
      RUBY
    end

    it 'approves of one expectation per example' do
      expect_no_offenses(<<-RUBY)
        describe Foo do
          it 'does something neat' do
            expect(neat).to be(true)
          end

          it 'does something cool' do
            expect(cool).to be(true)
          end
        end
      RUBY
    end

    it 'works also with is_expected' do
      expect_no_offenses(<<-RUBY)
        describe Foo do
          it { is_expected.to be_valid }
        end
      RUBY
    end
  end
end
