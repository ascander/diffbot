require "set"
require "yajl"

module Diffbot
  # Representation of a collection of Articles
  class Corpus

    def initialize(articles)
      @articles = articles
    end

    attr_accessor :articles
    
    def self.from_path(path)
      parser   = Yajl::Parser.method(:parse)
      lines    = File.readlines(path)
      json     = lines.inject([]) { |arr,line| arr << parser.call(line.chomp) }
      articles = json.inject([]) { |arr,js| arr << Article.new(js) }
      new(articles)
    end
    
    def size
      @articles.size
    end

    def length
      size
    end

    def site_counts
      @articles.inject([]) { |arr,art| arr << art.site }.compact.counts
    end

    def urls
      @articles.inject([]) { |arr,art| arr << art.normalized_url }.compact.to_set
    end

    def labels
      @articles.group_by { |art| art.label.to_sym }.keys
    end

    def rate(&block)
      @articles.count(&block) / size.to_f
    end

    def by_label(&block)
      @articles.group_by { |art| art.label.to_sym }.inject({}) do |hsh,(lab,arts)|
        hsh[lab] = yield(arts)
        hsh
      end
    end

    def summary(&block)
      article_map(&block).summary
    end

    def quantiles(num=4,&block)
      article_map(&block).quantiles(num)
    end

    def sample(num)
      if block_given?
        article_map(&block).sample(num)
      else
        @articles.sample(num)
      end
    end

    def inspect
      "<Corpus: #{size} articles>"
    end

    protected

    def article_map(&block)
      @articles.inject([]) { |arr,art| arr << yield(art) }
    end
  end
end