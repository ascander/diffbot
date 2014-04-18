module Diffbot
  module Stats
    
    # Compute the sum of items
    def sum
      reduce(0,:+)
    end

    # Compute the arithmetic mean of items
    def mean
      sum / size.to_f
    end

    # Compute the median of items
    def median
      s = sort
      n = (s.size - 1) / 2

      s.size % 2 == 0 ? s.slice(n,2).mean : s[n]
    end

    # Compute the variance of a collection of items
    def var
      mu = mean
      inject([]) { |a,x| a << (x - mu)**2 }.mean
    end

    # Compute the standard deviation for a collection of items
    def stdev
      Math.sqrt(var)
    end

    # Compute frequency counts for a collection of items
    def counts
      inject(Hash.new { |h,k| h[k] = 0 }) { |hsh,obj| hsh[obj] += 1 ; hsh }
    end

    # Compute some nice summary statistics for a collection of items
    def summary
      Hash[:min, min, :max, max, :mean, mean, :median, median, :stdev, stdev]
    end

    # Compute quantiles for a collection of items; see http://en.wikipedia.org/wiki/Quantile
    def quantiles(q=4)
      s = sort
      (1..q).to_a.inject([]) do |a,k|
        p = k / q.to_f
        i = (size * p).ceil
        v = p == 0.5 ? median : s[i - 1]
        a << v
      end
    end
  end
end