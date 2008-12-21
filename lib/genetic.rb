$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Genetic
  VERSION = '0.0.1'

  class Chromosome

    attr_reader :genes
    attr_accessor :fitness

    def initialize(options = {})
      @genes = options[:genes] || create(options[:length] || 20)
      @fitness = 0
    end

    def create(length = 20)
      @genes = (0...length).collect { (rand > 0.5 ? '1' : '0')}.join
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

    def size
      @pop.size
    end

    def each
      @pop.each { |p| yield p }
    end

    def calculate_fitness
      @pop.each do |p|
        yield p
      end
    end

    def sum_fitness
      @pop.inject(0) { |sum, p| sum += p.fitness } 
    end

    def sort
      @pop.sort! { |a, b| b.fitness <=> a.fitness }
    end

    def select(sel = nil)
      selector =  sel || rand * sum_fitness
      puts @pop.detect { |c| c.fitness <= selector }
    end

  end

end
