# encoding: UTF-8
require 'statsample'

# The matcher below checks whether the means of two arrays of numbers are statistically significantly
# larger from one another.
#
# TODO:  This code might eventually be gemified.  When/if it is gemified, it can be validated independently with
# the following rspec:
#
# describe AuditsController do
#  it 'works' do
#    a = [30.02, 29.99, 30.11, 29.97, 30.01, 29.99]
#    b = [29.89, 29.93, 29.72, 29.98, 30.02, 29.98]
#    a.should_not be_significantly_larger_in_mean_than(b)
#    a.should be_significantly_larger_in_mean_than([50]*6)
#  end
#end
module CustomMatcher

  top_level_rspec = if defined?(Spec) then 'Spec'  # For rspec v1.x
                    elsif defined?(RSpec) then 'RSpec' # For rspec v2.x
                    else raise "Error: Can't define custom rspec matcher because rspec gem is not available!"
                    end
  class_eval(%Q(
    ::#{top_level_rspec}::Matchers.define :be_significantly_larger_in_mean_than do |expected|
      def assert_array_of_numerics(arr)
        unless arr.is_a?(Array) && arr.all?{ |e| e.is_a?(Numeric) }
          raise(ArgumentError, "values must be array of numbers")
        end
      end

      match do |actual|
        assert_array_of_numerics(expected)
        assert_array_of_numerics(actual)

        actual_vector = actual.to_scale
        expected_vector = expected.to_scale

        # code from https://en.wikipedia.org/wiki/Student's_t-test#Unpaired_and_paired_two-sample_t-tests
        # Example:
        # actual = [30.02, 29.99, 30.11, 29.97, 30.01, 29.99]
        # expected = [29.89, 29.93, 29.72, 29.98, 30.02, 29.98]
        # xA - xE = 0.095
        # Math.sqrt(unbiased_estimator_of_variance) = 0.049
        # t = 1.959
        # degrees_of_freedom = 7.03
        # two-tailed test p-value = 0.091
        # For a two-sided test, find the column corresponding to 1-alpha/2 and
        # reject the null hypothesis if the absolute value of the test
        # statistic is greater than the value of t1-alpha/2,ν in the table below.
        t_test = ::Statsample::Test::T::TwoSamplesIndependent.new(actual_vector, expected_vector)
        t_test.compute
        t = t_test.t_not_equal_variance
        degrees_of_freedom = t_test.df_not_equal_variance

        # null hypothesis is that the means of two populations are equal
        # > means reject null hypo.
        # If t-value is negative than current result is faster than last result
        actual_vector.mean > expected_vector.mean && t > ::StatsHelper.point_o_five(degrees_of_freedom)
      end

      failure_message_for_should_not do |actual|
        actual_mean = actual.to_scale.mean
        expected_mean = expected.to_scale.mean
        percent_slower = (actual_mean - expected_mean) / expected_mean * 100
        "Current response time is \#\{actual_mean\} while previous run was \#\{expected_mean\}. It's \#\{percent_slower.round(2)\}% slower!"
      end
    end
  ))
end
