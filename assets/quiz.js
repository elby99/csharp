document.querySelectorAll('[data-answer]').forEach((quiz) => {
  const expected = quiz.dataset.answer;
  const feedback = quiz.querySelector('.feedback');
  quiz.querySelectorAll('button[data-choice]').forEach((button) => {
    button.addEventListener('click', () => {
      const correct = button.dataset.choice === expected;
      quiz.querySelectorAll('button[data-choice]').forEach((candidate) => {
        candidate.classList.remove('correct', 'incorrect');
      });
      button.classList.add(correct ? 'correct' : 'incorrect');
      feedback.textContent = correct ? quiz.dataset.correct : quiz.dataset.incorrect;
      feedback.style.color = correct ? 'var(--good)' : 'var(--bad)';
    });
  });
});
