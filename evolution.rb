module RandomString

  def self.create_population(pop_size, word_size)
    population = []
    while population.size < pop_size
      population << create_string(word_size)
    end
    population
  end

  def self.create_string(size)
    letters = ('A'..'Z').to_a
    word = []

    while word.size < size
      word << letters.sample
    end
    word.join
  end

  def self.fitness(population, target_word)
    mating_pool = {}
    population.each do |word|
      value = word.downcase.split('').count {|l| target_word.include?(l)}
      mating_pool[word] = value.to_f
    end
    mating_pool
  end

  def self.normalize(pool)
    total_value = pool.values.reduce(:+)
    normalized_pool = pool.inject({}) {|h, (k,v)| h[k] = (v/total_value).to_f.round(3); h}
  end

  def self.random_element(normalized_pool)
    result = nil
    until result != nil
      r = rand
      result = normalized_pool.find{|e,w| r < w}
    end
    normalized_pool.delete(result[0])
    result
  end

  def self.combine(element1, element2)
    element1[0][0..1] + element2[0][2..3]
  end
end

if __FILE__ == $0
  pop = RandomString.create_population(30, 4)
  fitness_pool = RandomString.fitness(pop, "beat")
  normalized_pool = RandomString.normalize(fitness_pool)
  e1 = RandomString.random_element(normalized_pool)
  e2 = RandomString.random_element(normalized_pool)
  puts e1
  puts e2
  puts RandomString.combine(e1, e2)
end
