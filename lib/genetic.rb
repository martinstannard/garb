$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Genetic
  VERSION = '0.0.1'

  class Chromosome

    attr_reader :genes

    def initialize(options = {})
      @genes = options[:genes] || create(options[:length])
    end

    def create(length = 20)
      @genes = (0..length).collect { (rand > 0.5 ? ?1 : ?0)}.join
    end

    def replace(string)
      @genes = string
    end

    def cleave(position)
      [@genes[0...position], @genes[position..-1]]
    end

    def crossover(other, juncture = rand(@genes.length))
      genes_cleave = cleave juncture 
      other_cleave = other.cleave juncture 
      replace(genes_cleave[0] +  other_cleave[1])
      other.replace(other_cleave[0] + genes_cleave[1])
    end

    def mutate(hit = rand(@genes.length))
      @genes[hit] = (@genes[hit] == ?0 ? ?1 : ?0)
    end

  end
  
  class Population

    attr_reader :pop

    def initialize(count = 20, length = 20)
      @pop = Array.new(count) { Chromosome.new({:length => length}) }
    end

  end

end
