var fightersArray = List.generate(10, (fighterId) {
  return {
    'id': fighterId + 1,
    'name': 'Fighter ${fighterId + 1}',
  };
});

get bracketData => List.generate(4, (stage) {
      // Calculate number of fights by halving each time
      var fightsCount = 8 ~/ (1 << stage); // 8 divided by 2^stage
      var fights = List.generate(fightsCount, (i) {
        return {
          'name': 'Fight ${i + 1}',
          'fighters': [],
        };
      });

      return {
        'name': 'Stage ${stage + 1}',
        'fights': fights,
      };
    });
