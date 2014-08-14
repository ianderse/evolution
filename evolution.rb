

module RandomString

  def self.create_population(pop_size, word_size)
    population = []
    while population.size < pop_size
      population << create_string(word_size)
    end
    population
  end

  def self.create_string(size)
    letters = ('a'..'z').to_a
    word = []

    while word.size < size
      word << letters.sample
    end
    word.join
  end

  def self.fitness(population, target_word)
    mating_pool = []
    population.each do |word|
      value = (check(word, target_word)/target_word.size).to_f#(word.split('').count {|l| target_word.include?(l)})
      mating_pool << [word,value.to_f]
    end
    mating_pool
  end

  def self.check(word, target_word)
    target_word.split('').zip(word.split('')).map { |x, y| x == y }.count {|x| x}.to_f
  end

  def self.normalize(pool)
    #need to get an array of all the values and then reduce it
    total_value = 0
    pool.each do |array|
      total_value += array[1]
    end
    #total_value = pool.values.reduce(:+)
    #normalized_pool = pool.inject([]) {|(k,v)| [k, (v/total_value).to_f.round(3)] }
    normalize_pool= pool.map do |array|
      [array[0], (array[1]/total_value.to_f).round(3)]
    end
  end

  def self.random_element(normalized_pool)
    result = nil
    until result != nil
      r = rand
      #normalized_pool.delete_if {|e,w| result = e if r < w}
      result = normalized_pool.find{|e,w| r < w}
    end
    #normalized_pool.delete_at(normalized_pool.index(result)) #this is breaking it
    result[0]
  end

  def self.combine(element1, element2)
    index = rand(1..element1.size-1)
    rand_num = rand
    returned_array = []
    # if rand_num < 0.25
    #   (element1[index..element1.size] + element2[index..element2.size])[0..3]
    # elsif rand_num > 0.25 && rand_num < 0.5
    #   (element2[index..element2.size] + element1[index..element1.size])[0..3]
    # elsif rand_num > 0.5 && rand_num < 0.75
    #   (element1[index..element1.size] + element2[index..element2.size])[0..3]
    # else
    #   (element1[0..index] + element2[index+1..element2.size])[0..3]
    # end

    if rand_num < 0.25
      element1[0..1] + element2[2..3]
    elsif rand_num > 0.25 && rand_num < 0.5
      element2[0..1] + element1[0..1]
    elsif rand_num > 0.5 && rand_num < 0.75
      element2[2..3] + element1[2..3]
    else
      element1[2..3] + element2[2..3]
    end

    # while returned_array.size < element1.size
    #   returned_array << element1.split('').sample #delete the sample
    #   returned_array << element2.split('').sample
    # end
    # returned_array.join
  end

  def self.mutate(element)
    mutation_chance = 0.05

    if rand < mutation_chance
      element[rand(0..element[0].size)] = ('a'..'z').to_a.sample
    end
    element
  end

end

if __FILE__ == $0
  target_word = "beat"
  i = 0

  pop = RandomString.create_population(30, 4)
  #  fitness_pool = RandomString.fitness(pop, target_word)
  #  normalized_pool = RandomString.normalize(fitness_pool)
  # p parent1 = RandomString.random_element(normalized_pool)
  # p parent2 = RandomString.random_element(normalized_pool)
  #  child = RandomString.combine(parent1, parent2)
  # p final_child = RandomString.mutate(child)

   while !pop.include?(target_word)
      fitness_pool = RandomString.fitness(pop, target_word)
      normalized_pool = RandomString.normalize(fitness_pool)
      #do this until pool is full of new children
      pop.each do |item|
        parent1 = RandomString.random_element(normalized_pool)
        parent2 = RandomString.random_element(normalized_pool)
        child = RandomString.combine(parent1, parent2)
        p final_child = RandomString.mutate(child)
        pop[pop.index(item)] = final_child
      end
      i += 1
   end

puts "final sorted population: "
pop.sort.each do |word|
  print word + ", "
end

puts "\ntotal generations: " + i.to_s


end
