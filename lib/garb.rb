$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Garb
  VERSION = '0.0.1'

  class Chromosome

    attr_reader :genes
    attr_accessor :fitness
    attr_accessor :sum_fitness

    def initialize(options = {})
      @genes = options[:genes] || create(options[:length] || 20)
      @fitness = @sum_fitness = 0.0
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

    def mutate(prob)
      @genes.size.times do |i|
        @genes[i] = (@genes[i] == ?0 ? ?1 : ?0) if rand < prob
      end
    end

    def to_s
      "#{@genes} : Fitness #{fitness}\t : Sum Fitness #{sum_fitness}"
    end

  end

  class Population

    attr_reader :pop, :sum_fitness, :generation_count
    attr_accessor :mutation_rate

    def initialize(count = 20, length = 20)
      @pop = Array.new(count) { Chromosome.new({:length => length}) }
      @sum_fitness = 0.0
      @mutation_rate = 0.001
      @generation_count = 0
      simulate
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

    def fitness_sumation
      @sum_fitness = @pop.inject(0) do |sum, c| 
        sum += c.fitness
        # put the current sum_fitness in the chromosome
        c.sum_fitness = sum
      end 
    end

    def sort
      @pop.sort! { |a, b| a.fitness <=> b.fitness }.reverse
    end

    def select(sel = nil)
      selector =  sel || rand * sum_fitness
      @pop.detect { |c| c.sum_fitness >= selector }
    end

    def crossover
      new_pop = []
      (@pop.size/2).times do
        # select 2 candidate chomosomes
        p1 = select.dup
        p2 = select.dup
        # cross them
        p1.crossover p2
        # add them to the new population
        new_pop << p1
        new_pop << p2
      end
      @pop = new_pop
    end

    def simulate
      @pop.each do |chrom|
        chrom.fitness = chrom.genes.count('1').to_f * chrom.genes.count('1').to_f
      end
      fitness_sumation
    end

    def generations(count = 100)
      count.times { generation }
    end

    def generation
      crossover
      @pop[-1].mutate @mutation_rate
      @pop[-2].mutate @mutation_rate
      simulate
      @generation_count += 1
      inspect
    end

    def inspect(long = false)
      puts "Generations : #{@generation_count} Sum Fitness : #{sum_fitness} Avg. Fitness : #{sum_fitness.to_f/pop.size.to_f}"
      pop.each { |chrom| puts chrom.to_s } if long
    end

  end

end
