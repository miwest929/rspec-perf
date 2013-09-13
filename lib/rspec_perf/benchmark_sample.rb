require 'benchmark'

class BenchmarkSample
  def self.measure(sample_size)
    results = []
    while results.count < sample_size do
      r = Benchmark.realtime { yield }
      r_ms = (r * 1000).round(2)

      # If response time is zero then ignore run and continue.
      results << r_ms if r_ms > 0
    end

    results
  end
end
