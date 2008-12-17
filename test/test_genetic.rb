require File.dirname(__FILE__) + '/test_helper.rb'

class TestChromosome < Test::Unit::TestCase

  def setup
    @chromosome = Genetic::Chromosome.new({:genes => '1' * 20})
    @other = Genetic::Chromosome.new({:genes => '0' * 20})
  end

  def test_create
    chrom = Genetic::Chromosome.new
    asset chrom.genes.size == 20
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
    @chromosome.mutate(0)
    assert @chromosome.genes.count('0') == 1
    assert @chromosome.genes == '0' + '1' * 19
    @chromosome.mutate(1)
    assert @chromosome.genes.count('0') == 2
    assert @chromosome.genes == '00' + '1' * 18
  end

end

class TestPopulation < Test::Unit::TestCase

  def setup
    @population = Genetic::Population.new(20)
  end

  def test_population_size
    assert @population.pop.size == 20
  end

end
