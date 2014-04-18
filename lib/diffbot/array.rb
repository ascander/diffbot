class Array
  include Diffbot::Stats

  # Wrap an object as an Array
  #
  #   Array.wrap(nil)              => []
  #   Array.wrap("herp")           => ["herp"]
  #   Array.wrap(["herp", "derp"]) => ["herp", "derp"]
  #
  def self.wrap(obj)
    if obj.nil?
      []
    elsif obj.respond_to?(:to_ary)
      obj.to_ary || [obj]
    else
      [obj]
    end
  end
end  
