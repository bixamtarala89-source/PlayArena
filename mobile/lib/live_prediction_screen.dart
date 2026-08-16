import 'package:flutter/material.dart';

const _bg = Color(0xFF06131F), _surface = Color(0xFF102B3D), _teal = Color(0xFF18D6B0), _amber = Color(0xFFFFB547);

class Question {
  final String title;
  final String question;
  final List<String> options;
  final String answer;
  final int unlockStage;
  const Question(this.title, this.question, this.options, this.answer, this.unlockStage);
}

class LivePredictionScreen extends StatefulWidget {
  const LivePredictionScreen({super.key});
  @override
  State<LivePredictionScreen> createState() => _LivePredictionScreenState();
}

class _LivePredictionScreenState extends State<LivePredictionScreen> {
  final Map<String, String> picks = {};
  final Set<String> locked = {};
  final Map<String, bool> results = {};
  int stage = 0, xp = 0, rewardChips = 0;

  final questions = const <Question>[
    Question('Powerplay Score', 'India score after 6 overs?', ['0–39', '40–49', '50–59', '60+'], '50–59', 1),
    Question('Powerplay Wickets', 'India wickets after 6 overs?', ['0', '1', '2', '3+'], '1', 1),
    Question('10 Over Score', 'India score after 10 overs?', ['0–49', '50–69', '70–89', '90+'], '70–89', 2),
    Question('Top Scorer', 'Who will be top scorer (India)?', ['Batter A', 'Batter B', 'Batter C', 'Other'], 'Batter A', 2),
    Question('15 Over Score', 'India score after 15 overs?', ['<120', '120-139', '140-159', '160+'], '140-159', 3),
    Question('Bowling Change', 'Will a spinner bowl in over 7?', ['Yes', 'No'], 'Yes', 3),
    Question('20 Over Score', 'India final T20 score?', ['<160', '160-179', '180-199', '200+'], '188/6', 4),
    Question('Match Result', 'Will India win the match?', ['Yes', 'No', 'Tie', 'No result'], 'Yes', 5),
  ];

  String get score => switch (stage) {0 => '48/1', 1 => '56/1', 2 => '84/2', 3 => '137/3', 4 => '188/6', _ => '188/6'};
  String get overs => switch (stage) {0 => '5.2 OV', 1 => '6.0 OV', 2 => '10.0 OV', 3 => '15.0 OV', 4 => '20.0 OV', _ => '20.0 OV'};

  void choose(String key, String value) {
    if (locked.contains(key)) return;
    setState(() => picks[key] = value);
  }

  void advance() {
    if (stage >= 5) return;
    setState(() {
      stage++;
      for (final q in questions) {
        if (q.unlockStage <= stage) {
          locked.add(q.title);
          if (picks.containsKey(q.title) && !results.containsKey(q.title)) {
            final ok = picks[q.title] == q.answer;
            results[q.title] = ok;
            if (ok) {
              xp += 10;
              rewardChips += 5;
            }
          }
        }
      }
    });
  }

  void reset() {
    setState(() {
      stage = 0;
      xp = 0;
      rewardChips = 0;
      picks.clear();
      locked.clear();
      results.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          title: const Text('Live Predictions'),
          backgroundColor: _surface,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Center(child: Text('XP: $xp', style: const TextStyle(fontWeight: FontWeight.w600))),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF073A3C), _surface]),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('LIVE SCORE', style: TextStyle(color: Colors.white60, fontSize: 12)),
                              const SizedBox(height: 6),
                              Text(score, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('OVERS', style: TextStyle(color: Colors.white60, fontSize: 12)),
                              const SizedBox(height: 6),
                              Text(overs, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(children: [Expanded(child: _Stat('PICKS', '${picks.length}/8')), const SizedBox(width: 7), Expanded(child: _Stat('CORRECT', '${results.values.where((v) => v).length}'))]),
                      const SizedBox(height: 12),
                      Row(children: [ElevatedButton(onPressed: advance, child: const Text('Advance')), const SizedBox(width: 8), ElevatedButton(onPressed: reset, child: const Text('Reset'))]),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('PREDICTION LOBBY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: _teal, letterSpacing: 1)),
                const SizedBox(height: 8),
                Column(children: questions.map((q) => _PredictionCard(title: q.title, question: q.question, options: q.options, selected: picks[q.title], locked: locked.contains(q.title), result: results[q.title], answer: locked.contains(q.title) ? q.answer : null, onSelect: (v) => choose(q.title, v))).toList()),
                const SizedBox(height: 12),
                const Text('MATCH LEADERBOARD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: _teal, letterSpacing: 1)),
                const SizedBox(height: 8),
                _Leader(rank: '1', name: 'CricketFan', xp: '240', you: true),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(14)),
                  child: const Column(
                    children: [
                      Icon(Icons.verified_user_outlined, color: _teal),
                      SizedBox(height: 6),
                      Text('FREE-PLAY SIMULATION', style: TextStyle(fontWeight: FontWeight.w900)),
                      SizedBox(height: 4),
                      Text('100 XP + 25 virtual reward chips per correct prediction. No cash value, withdrawal, or redemption.', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.white54))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Team extends StatelessWidget {
  final String name, score, overs;
  const _Team({required this.name, required this.score, required this.overs, super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
      const SizedBox(height: 4),
      Text(score, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _amber)),
      Text(overs, style: const TextStyle(fontSize: 9, color: Colors.white54))
    ],
  );
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat(this.label, this.value, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)), const SizedBox(height: 4), Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))]),
      );
}

class _PredictionCard extends StatelessWidget {
  final String title, question;
  final List<String> options;
  final String? selected, answer;
  final bool locked;
  final bool? result;
  final ValueChanged<String> onSelect;

  const _PredictionCard({required this.title, required this.question, required this.options, required this.selected, required this.locked, required this.result, required this.answer, required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), if (locked) const Icon(Icons.lock, color: Colors.white30)]),
          const SizedBox(height: 6),
          Text(question, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: options.map((o) => ChoiceChip(label: Text(o), selected: selected == o, onSelected: locked ? null : (_) => onSelect(o))).toList()),
          if (locked && answer != null) ...[
            const SizedBox(height: 6),
            Text('Answer: $answer', style: const TextStyle(color: _teal)),
            if (result != null) Text(result! ? 'Correct' : 'Incorrect', style: TextStyle(color: result! ? Colors.greenAccent : Colors.redAccent)),
          ]
        ]),
      );
}

class _Leader extends StatelessWidget {
  final String rank, name, xp;
  final bool you;
  const _Leader({required this.rank, required this.name, required this.xp, this.you = false, super.key});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('#$rank $name', style: const TextStyle(color: Colors.white)), Text('$xp XP', style: const TextStyle(color: Colors.white60))]),
      );
}
