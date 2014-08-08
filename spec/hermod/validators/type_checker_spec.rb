require "minitest_helper"

module Hermod
  module Validators
    describe TypeChecker do
      it "uses a default block that checks the value is an instance of the given class" do
        checker = TypeChecker.new(Integer)
        checker.valid?(1, {}).must_equal true
        proc { checker.valid?(1.0, {}) }.must_raise InvalidInputError
      end

      it "allows you to give a block to be more discerning" do
        checker = TypeChecker.new(Date) {|val| val.respond_to? :strftime }
        dateish = Minitest::Mock.new
        dateish.expect :strftime, "today"
        checker.valid?(dateish, {}).must_equal true
        proc { checker.valid?(Minitest::Mock.new, {}) }.must_raise InvalidInputError
      end

      it "gives the correct message" do
        ex = proc { TypeChecker.new(Integer).valid?(1.0, {}) }.must_raise InvalidInputError
        ex.message.must_equal "must be an integer"

        ex = proc { TypeChecker.new(Float).valid?(1, {}) }.must_raise InvalidInputError
        ex.message.must_equal "must be a float"
      end
    end
  end
end
