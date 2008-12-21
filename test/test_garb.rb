require File.dirname(__FILE__) + '/test_helper.rb'

class TestChromosome < Test::Unit::TestCase

  def setup
    @chromosome = Garb::Chromosome.new({:genes => '1' * 20})
    @other = Garb::Chromosome.new({:genes => '0' * 20})
  end

  def test_create
    chrom = Garb::Chromosome.new
    assert chrom.genes.size == 20
  end

  def test_cleave_size
    assert @chromosome.cleave(10).size == 2
  end

  def test_cleave_lengths
    assert @chromosome.cleave(10)[0].size == 10
    assert @chromosome.cleave(10)[1].size == 10
  end

  def test_replace
    assert @chromosome.replace('0' * 20) == '0' * 20
  end

  def test_middle_crossover
    @chromosome.crossover(@other, 10)
    assert @chromosome.genes == '1' * 10 + '0' * 10
    assert @other.genes == '0' * 10 + '1' * 10
  end

  def test_start_crossover
    @chromosome.crossover(@other, 0)
    assert @chromosome.genes == '0' * 20
    assert @other.genes == '1' * 20
  end

  def test_end_crossover
    @chromosome.crossover(@other, @chromosome.genes.length)
    assert @chromosome.genes == '1' * 20
    assert @other.genes == '0' * 20
  end

  def test_five_crossover
    @chromosome.crossover(@other, 5)
    assert @chromosome.genes == '1' * 5 + '0' * 15
    assert @other.genes == '0' * 5 + '1' * 15
  end

  def test_mutate
    @chromosome.mutate(1.0)
    assert @chromosome.genes.count('0') == 20
    @chromosome.mutate(1.0)
    assert @chromosome.genes.count('1') == 20
    @chromosome.mutate(0.0)
    assert @chromosome.genes.count('1') == 20
  end

end

class TestPopulation < Test::Unit::TestCase

  def setup
    @population = Garb::Population.new(20)
    @population.each {|p| p.fitness = 1 }
  end

  def test_population_size
    assert @population.pop.size == 20
  end

  def test_fitness_sumation
    @population.fitness_sumation
    assert @population.sum_fitness == 20
    20.times { |t| assert @population.pop[t].sum_fitness == t + 1 }
  end

  def test_sort
    @population.each {|p| p.fitness = rand(100) }
    @population.sort
    (0..@population.size-2).each do |index|
      assert @population.pop[index].fitness <= @population.pop[index+1].fitness
    end
  end

  def test_select
    @population.fitness_sumation
    assert @population.select(0.0) == @population.pop[0]
    assert @population.select(@population.sum_fitness) == @population.pop[-1]
  end

end
