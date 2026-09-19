// DAWAM Data Pipeline - Core Architecture
// Version: 0.4 - Curriculum Integration Layer

import 'dart:collection';
import 'dart:math';

// ============================================================================
// ENUMS & CONSTANTS
// ============================================================================

enum SkillLevel { novice, developing, proficient, mastered }

enum ExerciseType { recognition, correction, classification, production, application }

enum AssessmentType { correction, production, paragraph, essay, argumentAnalysis, researchDesign }

enum PedagogicalStage { activate, explain, demonstrate, contrast, practice, apply, produce, retrieve }

enum Difficulty { level1, level2, level3, level4, level5, level6, level7, level8, level9, level10 }

enum Pillar { grammar, syntax, coherence, criticalThinking, academicTone, vocabulary, researchMethodology }

enum ErrorDiagnosis {
  nearestNounAttraction,
  wordClassConfusion,
  articleMisuse,
  tenseInconsistency,
  fragment,
  runOn,
  commaSplice,
  subjectVerbAgreement,
  pronounReference,
  modifierPlacement,
  parallelStructure,
  logicalFallacy,
  registerSlip,
  hedgingMissing,
  hedgingExcessive
}

// ============================================================================
// CORE DATA MODELS
// ============================================================================

/// Represents a concept in the knowledge graph
@immutable
class Concept {
  final String id;
  final String name;
  final String domain;
  final String? definition;
  final List<String> prerequisiteIds;
  final List<String> relatedIds;
  final String firstAppearsIn;

  const Concept({
    required this.id,
    required this.name,
    required this.domain,
    this.definition,
    this.prerequisiteIds = const [],
    this.relatedIds = const [],
    required this.firstAppearsIn,
  });

  Concept copyWith({
    String? definition,
    List<String>? prerequisiteIds,
    List<String>? relatedIds,
  }) {
    return Concept(
      id: id,
      name: name,
      domain: domain,
      definition: definition ?? this.definition,
      prerequisiteIds: prerequisiteIds ?? this.prerequisiteIds,
      relatedIds: relatedIds ?? this.relatedIds,
      firstAppearsIn: firstAppearsIn,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'domain': domain,
        'definition': definition,
        'prerequisiteIds': prerequisiteIds,
        'relatedIds': relatedIds,
        'firstAppearsIn': firstAppearsIn,
      };

  factory Concept.fromJson(Map<String, dynamic> json) => Concept(
        id: json['id'],
        name: json['name'],
        domain: json['domain'],
        definition: json['definition'],
        prerequisiteIds: List<String>.from(json['prerequisiteIds'] ?? []),
        relatedIds: List<String>.from(json['relatedIds'] ?? []),
        firstAppearsIn: json['firstAppearsIn'],
      );
}

/// Represents a skill (ability) a learner develops
@immutable
class Skill {
  final String id;
  final String abilityStatement;
  final List<String> prerequisiteSkillIds;
  final List<String> conceptIds;
  final String builtInMission;
  final List<String> reinforcedInMissions;
  final String status;

  const Skill({
    required this.id,
    required this.abilityStatement,
    this.prerequisiteSkillIds = const [],
    this.conceptIds = const [],
    required this.builtInMission,
    this.reinforcedInMissions = const [],
    this.status = 'Draft',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'abilityStatement': abilityStatement,
        'prerequisiteSkillIds': prerequisiteSkillIds,
        'conceptIds': conceptIds,
        'builtInMission': builtInMission,
        'reinforcedInMissions': reinforcedInMissions,
        'status': status,
      };

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        id: json['id'],
        abilityStatement: json['abilityStatement'],
        prerequisiteSkillIds: List<String>.from(json['prerequisiteSkillIds'] ?? []),
        conceptIds: List<String>.from(json['conceptIds'] ?? []),
        builtInMission: json['builtInMission'],
        reinforcedInMissions: List<String>.from(json['reinforcedInMissions'] ?? []),
        status: json['status'] ?? 'Draft',
      );
}

/// Mastery criteria for a skill
@immutable
class MasteryCriteria {
  final String skillId;
  final Map<SkillLevel, String> descriptors;
  final String minimumEvidence;
  final String retestTrigger;

  const MasteryCriteria({
    required this.skillId,
    required this.descriptors,
    required this.minimumEvidence,
    required this.retestTrigger,
  });

  Map<String, dynamic> toJson() => {
        'skillId': skillId,
        'descriptors': descriptors.map((k, v) => MapEntry(k.name, v)),
        'minimumEvidence': minimumEvidence,
        'retestTrigger': retestTrigger,
      };

  factory MasteryCriteria.fromJson(Map<String, dynamic> json) => MasteryCriteria(
        skillId: json['skillId'],
        descriptors: Map.fromEntries(
          (json['descriptors'] as Map).entries.map(
            (e) => MapEntry(SkillLevel.values.firstWhere((s) => s.name == e.key), e.value),
          ),
        ),
        minimumEvidence: json['minimumEvidence'],
        retestTrigger: json['retestTrigger'],
      );
}

/// Common misconception tied to a concept
@immutable
class Misconception {
  final String id;
  final String conceptId;
  final String description;
  final String example;
  final String correctUnderstanding;
  final ErrorDiagnosis? diagnosticValue;

  const Misconception({
    required this.id,
    required this.conceptId,
    required this.description,
    required this.example,
    required this.correctUnderstanding,
    this.diagnosticValue,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'conceptId': conceptId,
        'description': description,
        'example': example,
        'correctUnderstanding': correctUnderstanding,
        'diagnosticValue': diagnosticValue?.name,
      };

  factory Misconception.fromJson(Map<String, dynamic> json) => Misconception(
        id: json['id'],
        conceptId: json['conceptId'],
        description: json['description'],
        example: json['example'],
        correctUnderstanding: json['correctUnderstanding'],
        diagnosticValue: json['diagnosticValue'] != null
            ? ErrorDiagnosis.values.firstWhere((e) => e.name == json['diagnosticValue'])
            : null,
      );
}

/// Mission capability statement
@immutable
class Mission {
  final String id;
  final String stage;
  final int number;
  final String title;
  final String description;
  final List<String> prerequisiteMissionIds;
  final List<String> skillIds;
  final Pillar pillar;
  final Difficulty difficulty;
  final AssessmentType assessmentType;
  final String status;
  final List<String> lessonIds;

  const Mission({
    required this.id,
    required this.stage,
    required this.number,
    required this.title,
    required this.description,
    this.prerequisiteMissionIds = const [],
    this.skillIds = const [],
    required this.pillar,
    required this.difficulty,
    required this.assessmentType,
    this.status = 'Planned',
    this.lessonIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'stage': stage,
        'number': number,
        'title': title,
        'description': description,
        'prerequisiteMissionIds': prerequisiteMissionIds,
        'skillIds': skillIds,
        'pillar': pillar.name,
        'difficulty': difficulty.name,
        'assessmentType': assessmentType.name,
        'status': status,
        'lessonIds': lessonIds,
      };

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        id: json['id'],
        stage: json['stage'],
        number: json['number'],
        title: json['title'],
        description: json['description'],
        prerequisiteMissionIds: List<String>.from(json['prerequisiteMissionIds'] ?? []),
        skillIds: List<String>.from(json['skillIds'] ?? []),
        pillar: Pillar.values.firstWhere((p) => p.name == json['pillar']),
        difficulty: Difficulty.values.firstWhere((d) => d.name == json['difficulty']),
        assessmentType: AssessmentType.values.firstWhere((a) => a.name == json['assessmentType']),
        status: json['status'] ?? 'Planned',
        lessonIds: List<String>.from(json['lessonIds'] ?? []),
      );
}

/// Lesson within a mission
@immutable
class Lesson {
  final String id;
  final String missionId;
  final int number;
  final String title;
  final PedagogicalStage stage;
  final String learningObjective;
  final String skillId;
  final String skillDescription;
  final List<String> conceptIds;
  final Difficulty difficulty;
  final int estimatedMinutes;
  final String status;
  final List<String> exerciseIds;

  const Lesson({
    required this.id,
    required this.missionId,
    required this.number,
    required this.title,
    required this.stage,
    required this.learningObjective,
    required this.skillId,
    required this.skillDescription,
    this.conceptIds = const [],
    required this.difficulty,
    required this.estimatedMinutes,
    this.status = 'Draft',
    this.exerciseIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'missionId': missionId,
        'number': number,
        'title': title,
        'stage': stage.name,
        'learningObjective': learningObjective,
        'skillId': skillId,
        'skillDescription': skillDescription,
        'conceptIds': conceptIds,
        'difficulty': difficulty.name,
        'estimatedMinutes': estimatedMinutes,
        'status': status,
        'exerciseIds': exerciseIds,
      };

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        missionId: json['missionId'],
        number: json['number'],
        title: json['title'],
        stage: PedagogicalStage.values.firstWhere((s) => s.name == json['stage']),
        learningObjective: json['learningObjective'],
        skillId: json['skillId'],
        skillDescription: json['skillDescription'],
        conceptIds: List<String>.from(json['conceptIds'] ?? []),
        difficulty: Difficulty.values.firstWhere((d) => d.name == json['difficulty']),
        estimatedMinutes: json['estimatedMinutes'],
        status: json['status'] ?? 'Draft',
        exerciseIds: List<String>.from(json['exerciseIds'] ?? []),
      };
}

/// Exercise for practice and assessment
@immutable
class Exercise {
  final String id;
  final String lessonId;
  final String skillId;
  final ExerciseType type;
  final String prompt;
  final List<String> conceptIds;
  final Difficulty difficulty;
  final String? expectedOutput;
  final List<String> hintIds;

  const Exercise({
    required this.id,
    required this.lessonId,
    required this.skillId,
    required this.type,
    required this.prompt,
    this.conceptIds = const [],
    required this.difficulty,
    this.expectedOutput,
    this.hintIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'lessonId': lessonId,
        'skillId': skillId,
        'type': type.name,
        'prompt': prompt,
        'conceptIds': conceptIds,
        'difficulty': difficulty.name,
        'expectedOutput': expectedOutput,
        'hintIds': hintIds,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'],
        lessonId: json['lessonId'],
        skillId: json['skillId'],
        type: ExerciseType.values.firstWhere((t) => t.name == json['type']),
        prompt: json['prompt'],
        conceptIds: List<String>.from(json['conceptIds'] ?? []),
        difficulty: Difficulty.values.firstWhere((d) => d.name == json['difficulty']),
        expectedOutput: json['expectedOutput'],
        hintIds: List<String>.from(json['hintIds'] ?? []),
      );
}

// ============================================================================
// LEARNER MODELS
// ============================================================================

/// Tracks a learner's progress on a specific skill
@immutable
class SkillProgress {
  final String skillId;
  final SkillLevel currentLevel;
  final DateTime lastAssessed;
  final List<EvidenceItem> evidence;
  final int practiceAttempts;
  final double currentAccuracy;
  final List<String> misconceptionIds;

  const SkillProgress({
    required this.skillId,
    this.currentLevel = SkillLevel.novice,
    required this.lastAssessed,
    this.evidence = const [],
    this.practiceAttempts = 0,
    this.currentAccuracy = 0.0,
    this.misconceptionIds = const [],
  });

  SkillProgress copyWith({
    SkillLevel? currentLevel,
    DateTime? lastAssessed,
    List<EvidenceItem>? evidence,
    int? practiceAttempts,
    double? currentAccuracy,
    List<String>? misconceptionIds,
  }) {
    return SkillProgress(
      skillId: skillId,
      currentLevel: currentLevel ?? this.currentLevel,
      lastAssessed: lastAssessed ?? this.lastAssessed,
      evidence: evidence ?? this.evidence,
      practiceAttempts: practiceAttempts ?? this.practiceAttempts,
      currentAccuracy: currentAccuracy ?? this.currentAccuracy,
      misconceptionIds: misconceptionIds ?? this.misconceptionIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'skillId': skillId,
        'currentLevel': currentLevel.name,
        'lastAssessed': lastAssessed.toIso8601String(),
        'evidence': evidence.map((e) => e.toJson()).toList(),
        'practiceAttempts': practiceAttempts,
        'currentAccuracy': currentAccuracy,
        'misconceptionIds': misconceptionIds,
      };

  factory SkillProgress.fromJson(Map<String, dynamic> json) => SkillProgress(
        skillId: json['skillId'],
        currentLevel: SkillLevel.values.firstWhere((l) => l.name == json['currentLevel']),
        lastAssessed: DateTime.parse(json['lastAssessed']),
        evidence: (json['evidence'] as List)
            .map((e) => EvidenceItem.fromJson(e))
            .toList(),
        practiceAttempts: json['practiceAttempts'],
        currentAccuracy: json['currentAccuracy'],
        misconceptionIds: List<String>.from(json['misconceptionIds'] ?? []),
      );
}

/// A piece of evidence for skill mastery
@immutable
class EvidenceItem {
  final String id;
  final String exerciseId;
  final DateTime timestamp;
  final double accuracy;
  final String? submission;
  final String? feedbackId;

  const EvidenceItem({
    required this.id,
    required this.exerciseId,
    required this.timestamp,
    required this.accuracy,
    this.submission,
    this.feedbackId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseId': exerciseId,
        'timestamp': timestamp.toIso8601String(),
        'accuracy': accuracy,
        'submission': submission,
        'feedbackId': feedbackId,
      };

  factory EvidenceItem.fromJson(Map<String, dynamic> json) => EvidenceItem(
        id: json['id'],
        exerciseId: json['exerciseId'],
        timestamp: DateTime.parse(json['timestamp']),
        accuracy: json['accuracy'],
        submission: json['submission'],
        feedbackId: json['feedbackId'],
      );
}

/// A learner's attempt at an exercise
@immutable
class ExerciseAttempt {
  final String id;
  final String exerciseId;
  final String userId;
  final String submission;
  final DateTime timestamp;
  final double? score;
  final List<ErrorAnnotation> errors;
  final String? feedbackId;
  final bool isComplete;

  const ExerciseAttempt({
    required this.id,
    required this.exerciseId,
    required this.userId,
    required this.submission,
    required this.timestamp,
    this.score,
    this.errors = const [],
    this.feedbackId,
    this.isComplete = false,
  });

  ExerciseAttempt copyWith({
    double? score,
    List<ErrorAnnotation>? errors,
    String? feedbackId,
    bool? isComplete,
  }) {
    return ExerciseAttempt(
      id: id,
      exerciseId: exerciseId,
      userId: userId,
      submission: submission,
      timestamp: timestamp,
      score: score ?? this.score,
      errors: errors ?? this.errors,
      feedbackId: feedbackId ?? this.feedbackId,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseId': exerciseId,
        'userId': userId,
        'submission': submission,
        'timestamp': timestamp.toIso8601String(),
        'score': score,
        'errors': errors.map((e) => e.toJson()).toList(),
        'feedbackId': feedbackId,
        'isComplete': isComplete,
      };

  factory ExerciseAttempt.fromJson(Map<String, dynamic> json) => ExerciseAttempt(
        id: json['id'],
        exerciseId: json['exerciseId'],
        userId: json['userId'],
        submission: json['submission'],
        timestamp: DateTime.parse(json['timestamp']),
        score: json['score'],
        errors: (json['errors'] as List)
            .map((e) => ErrorAnnotation.fromJson(e))
            .toList(),
        feedbackId: json['feedbackId'],
        isComplete: json['isComplete'] ?? false,
      );
}

/// Annotated error in a learner's submission
@immutable
class ErrorAnnotation {
  final String id;
  final int startIndex;
  final int endIndex;
  final String errorText;
  final String correction;
  final ErrorDiagnosis diagnosis;
  final String conceptId;
  final String explanation;
  final String? misconceptionId;

  const ErrorAnnotation({
    required this.id,
    required this.startIndex,
    required this.endIndex,
    required this.errorText,
    required this.correction,
    required this.diagnosis,
    required this.conceptId,
    required this.explanation,
    this.misconceptionId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'startIndex': startIndex,
        'endIndex': endIndex,
        'errorText': errorText,
        'correction': correction,
        'diagnosis': diagnosis.name,
        'conceptId': conceptId,
        'explanation': explanation,
        'misconceptionId': misconceptionId,
      };

  factory ErrorAnnotation.fromJson(Map<String, dynamic> json) => ErrorAnnotation(
        id: json['id'],
        startIndex: json['startIndex'],
        endIndex: json['endIndex'],
        errorText: json['errorText'],
        correction: json['correction'],
        diagnosis: ErrorDiagnosis.values.firstWhere((d) => d.name == json['diagnosis']),
        conceptId: json['conceptId'],
        explanation: json['explanation'],
        misconceptionId: json['misconceptionId'],
      );
}

/// Detailed feedback from the AI
@immutable
class Feedback {
  final String id;
  final String attemptId;
  final DateTime timestamp;
  final double overallScore;
  final Map<String, double> dimensionScores;
  final List<ErrorAnnotation> errors;
  final List<String> strengths;
  final List<String> improvementAreas;
  final String summary;
  final String? nextLessonSuggestion;
  final List<String> recommendedExercises;

  const Feedback({
    required this.id,
    required this.attemptId,
    required this.timestamp,
    required this.overallScore,
    this.dimensionScores = const {},
    this.errors = const [],
    this.strengths = const [],
    this.improvementAreas = const [],
    required this.summary,
    this.nextLessonSuggestion,
    this.recommendedExercises = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'attemptId': attemptId,
        'timestamp': timestamp.toIso8601String(),
        'overallScore': overallScore,
        'dimensionScores': dimensionScores,
        'errors': errors.map((e) => e.toJson()).toList(),
        'strengths': strengths,
        'improvementAreas': improvementAreas,
        'summary': summary,
        'nextLessonSuggestion': nextLessonSuggestion,
        'recommendedExercises': recommendedExercises,
      };

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
        id: json['id'],
        attemptId: json['attemptId'],
        timestamp: DateTime.parse(json['timestamp']),
        overallScore: json['overallScore'],
        dimensionScores: Map<String, double>.from(json['dimensionScores'] ?? {}),
        errors: (json['errors'] as List)
            .map((e) => ErrorAnnotation.fromJson(e))
            .toList(),
        strengths: List<String>.from(json['strengths'] ?? []),
        improvementAreas: List<String>.from(json['improvementAreas'] ?? []),
        summary: json['summary'],
        nextLessonSuggestion: json['nextLessonSuggestion'],
        recommendedExercises: List<String>.from(json['recommendedExercises'] ?? []),
      );
}

// ============================================================================
// REPOSITORY / DATA ACCESS LAYER
// ============================================================================

/// Base repository interface for DAWAM data
abstract class DAWAMRepository {
  // Concepts
  Future<Concept?> getConcept(String id);
  Future<List<Concept>> getConceptsByDomain(String domain);
  Future<List<Concept>> getConceptsForMission(String missionId);
  Future<void> saveConcept(Concept concept);

  // Skills
  Future<Skill?> getSkill(String id);
  Future<List<Skill>> getSkillsForMission(String missionId);
  Future<List<Skill>> getPrerequisiteSkills(String skillId);
  Future<void> saveSkill(Skill skill);

  // Mastery
  Future<MasteryCriteria?> getMasteryCriteria(String skillId);
  Future<void> saveMasteryCriteria(MasteryCriteria criteria);

  // Misconceptions
  Future<Misconception?> getMisconception(String id);
  Future<List<Misconception>> getMisconceptionsForConcept(String conceptId);
  Future<void> saveMisconception(Misconception misconception);

  // Missions
  Future<Mission?> getMission(String id);
  Future<List<Mission>> getMissionsByStage(String stage);
  Future<List<Mission>> getAvailableMissions(String userId);
  Future<void> saveMission(Mission mission);

  // Lessons
  Future<Lesson?> getLesson(String id);
  Future<List<Lesson>> getLessonsForMission(String missionId);
  Future<void> saveLesson(Lesson lesson);

  // Exercises
  Future<Exercise?> getExercise(String id);
  Future<List<Exercise>> getExercisesForLesson(String lessonId);
  Future<Exercise?> getExerciseByType(String lessonId, ExerciseType type);
  Future<void> saveExercise(Exercise exercise);

  // Learner Progress
  Future<SkillProgress?> getSkillProgress(String userId, String skillId);
  Future<List<SkillProgress>> getAllSkillProgress(String userId);
  Future<void> saveSkillProgress(SkillProgress progress);

  // Attempts
  Future<ExerciseAttempt?> getAttempt(String id);
  Future<List<ExerciseAttempt>> getAttemptsForUser(String userId);
  Future<List<ExerciseAttempt>> getAttemptsForExercise(String exerciseId);
  Future<void> saveAttempt(ExerciseAttempt attempt);

  // Feedback
  Future<Feedback?> getFeedback(String id);
  Future<List<Feedback>> getFeedbackForAttempt(String attemptId);
  Future<List<Feedback>> getFeedbackForUser(String userId);
  Future<void> saveFeedback(Feedback feedback);
}

// ============================================================================
// IN-MEMORY REPOSITORY IMPLEMENTATION (FOR TESTING)
// ============================================================================

class InMemoryDAWAMRepository implements DAWAMRepository {
  final Map<String, Concept> _concepts = {};
  final Map<String, Skill> _skills = {};
  final Map<String, MasteryCriteria> _masteryCriteria = {};
  final Map<String, Misconception> _misconceptions = {};
  final Map<String, Mission> _missions = {};
  final Map<String, Lesson> _lessons = {};
  final Map<String, Exercise> _exercises = {};
  final Map<String, SkillProgress> _skillProgress = {};
  final Map<String, ExerciseAttempt> _attempts = {};
  final Map<String, Feedback> _feedback = {};

  // ID generation
  String _generateId() => DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(10000).toString();

  @override
  Future<Concept?> getConcept(String id) async => _concepts[id];

  @override
  Future<List<Concept>> getConceptsByDomain(String domain) async {
    return _concepts.values.where((c) => c.domain == domain).toList();
  }

  @override
  Future<List<Concept>> getConceptsForMission(String missionId) async {
    // Concepts are linked indirectly through lessons and skills
    final missionLessons = await getLessonsForMission(missionId);
    final conceptIds = <String>{};
    for (final lesson in missionLessons) {
      conceptIds.addAll(lesson.conceptIds);
    }
    return conceptIds.map((id) => _concepts[id]!).whereType<Concept>().toList();
  }

  @override
  Future<void> saveConcept(Concept concept) async {
    _concepts[concept.id] = concept;
  }

  @override
  Future<Skill?> getSkill(String id) async => _skills[id];

  @override
  Future<List<Skill>> getSkillsForMission(String missionId) async {
    final mission = await getMission(missionId);
    if (mission == null) return [];
    return mission.skillIds.map((id) => _skills[id]!).whereType<Skill>().toList();
  }

  @override
  Future<List<Skill>> getPrerequisiteSkills(String skillId) async {
    final skill = await getSkill(skillId);
    if (skill == null) return [];
    return skill.prerequisiteSkillIds.map((id) => _skills[id]!).whereType<Skill>().toList();
  }

  @override
  Future<void> saveSkill(Skill skill) async {
    _skills[skill.id] = skill;
  }

  @override
  Future<MasteryCriteria?> getMasteryCriteria(String skillId) async =>
      _masteryCriteria[skillId];

  @override
  Future<void> saveMasteryCriteria(MasteryCriteria criteria) async {
    _masteryCriteria[criteria.skillId] = criteria;
  }

  @override
  Future<Misconception?> getMisconception(String id) async => _misconceptions[id];

  @override
  Future<List<Misconception>> getMisconceptionsForConcept(String conceptId) async {
    return _misconceptions.values.where((m) => m.conceptId == conceptId).toList();
  }

  @override
  Future<void> saveMisconception(Misconception misconception) async {
    _misconceptions[misconception.id] = misconception;
  }

  @override
  Future<Mission?> getMission(String id) async => _missions[id];

  @override
  Future<List<Mission>> getMissionsByStage(String stage) async {
    return _missions.values.where((m) => m.stage == stage).toList();
  }

  @override
  Future<List<Mission>> getAvailableMissions(String userId) async {
    // Get all missions where prerequisites are met
    final allMissions = _missions.values.toList();
    final available = <Mission>[];
    
    for (final mission in allMissions) {
      final allPrereqsMet = await _checkPrerequisites(userId, mission.prerequisiteMissionIds);
      if (allPrereqsMet) {
        available.add(mission);
      }
    }
    return available;
  }

  Future<bool> _checkPrerequisites(String userId, List<String> prerequisiteIds) async {
    for (final prereqId in prerequisiteIds) {
      // Check if the user has completed the prerequisite mission
      // For now, we check if they have any attempts for exercises in that mission
      final mission = await getMission(prereqId);
      if (mission == null) return false;
      
      final hasCompleted = await _hasCompletedMission(userId, prereqId);
      if (!hasCompleted) return false;
    }
    return true;
  }

  Future<bool> _hasCompletedMission(String userId, String missionId) async {
    // Check if user has completed at least 70% of exercises in the mission
    final lessons = await getLessonsForMission(missionId);
    final allExercises = <String>[];
    for (final lesson in lessons) {
      allExercises.addAll(lesson.exerciseIds);
    }
    
    if (allExercises.isEmpty) return false;
    
    final attempts = await getAttemptsForUser(userId);
    final completedExercises = attempts
        .where((a) => allExercises.contains(a.exerciseId) && a.isComplete)
        .map((a) => a.exerciseId)
        .toSet();
    
    return completedExercises.length >= allExercises.length * 0.7;
  }

  @override
  Future<void> saveMission(Mission mission) async {
    _missions[mission.id] = mission;
  }

  @override
  Future<Lesson?> getLesson(String id) async => _lessons[id];

  @override
  Future<List<Lesson>> getLessonsForMission(String missionId) async {
    return _lessons.values.where((l) => l.missionId == missionId).toList();
  }

  @override
  Future<void> saveLesson(Lesson lesson) async {
    _lessons[lesson.id] = lesson;
  }

  @override
  Future<Exercise?> getExercise(String id) async => _exercises[id];

  @override
  Future<List<Exercise>> getExercisesForLesson(String lessonId) async {
    return _exercises.values.where((e) => e.lessonId == lessonId).toList();
  }

  @override
  Future<Exercise?> getExerciseByType(String lessonId, ExerciseType type) async {
    try {
      return _exercises.values.firstWhere((e) => e.lessonId == lessonId && e.type == type);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveExercise(Exercise exercise) async {
    _exercises[exercise.id] = exercise;
  }

  @override
  Future<SkillProgress?> getSkillProgress(String userId, String skillId) async {
    final key = '$userId:$skillId';
    return _skillProgress[key];
  }

  @override
  Future<List<SkillProgress>> getAllSkillProgress(String userId) async {
    return _skillProgress.values.where((p) => p.skillId.startsWith(userId)).toList();
  }

  @override
  Future<void> saveSkillProgress(SkillProgress progress) async {
    final key = '${progress.skillId.split(':').first}:${progress.skillId.split(':').last}';
    _skillProgress[key] = progress;
  }

  @override
  Future<ExerciseAttempt?> getAttempt(String id) async => _attempts[id];

  @override
  Future<List<ExerciseAttempt>> getAttemptsForUser(String userId) async {
    return _attempts.values.where((a) => a.userId == userId).toList();
  }

  @override
  Future<List<ExerciseAttempt>> getAttemptsForExercise(String exerciseId) async {
    return _attempts.values.where((a) => a.exerciseId == exerciseId).toList();
  }

  @override
  Future<void> saveAttempt(ExerciseAttempt attempt) async {
    _attempts[attempt.id] = attempt;
  }

  @override
  Future<Feedback?> getFeedback(String id) async => _feedback[id];

  @override
  Future<List<Feedback>> getFeedbackForAttempt(String attemptId) async {
    return _feedback.values.where((f) => f.attemptId == attemptId).toList();
  }

  @override
  Future<List<Feedback>> getFeedbackForUser(String userId) async {
    // Get all attempts for user, then find feedback
    final attempts = await getAttemptsForUser(userId);
    final attemptIds = attempts.map((a) => a.id).toSet();
    return _feedback.values.where((f) => attemptIds.contains(f.attemptId)).toList();
  }

  @override
  Future<void> saveFeedback(Feedback feedback) async {
    _feedback[feedback.id] = feedback;
  }
}

// ============================================================================
// SERVICE / BUSINESS LOGIC LAYER
// ============================================================================

/// Main service for DAWAM educational pipeline
class DAWAMService {
  final DAWAMRepository repository;

  DAWAMService(this.repository);

  // ==========================================================================
  // CURRICULUM NAVIGATION
  // ==========================================================================

  /// Get the next recommended mission for a user
  Future<Mission?> getNextRecommendedMission(String userId) async {
    final available = await repository.getAvailableMissions(userId);
    if (available.isEmpty) return null;
    
    // Sort by difficulty and stage order
    available.sort((a, b) {
      // Sort by difficulty first (easier first)
      final diffCompare = a.difficulty.index.compareTo(b.difficulty.index);
      if (diffCompare != 0) return diffCompare;
      
      // Then by stage order
      return a.number.compareTo(b.number);
    });
    
    return available.first;
  }

  /// Get all missions in a stage with completion status
  Future<List<MapEntry<Mission, bool>>> getStageMissionsWithStatus(
    String userId,
    String stage,
  ) async {
    final missions = await repository.getMissionsByStage(stage);
    final result = <MapEntry<Mission, bool>>[];
    
    for (final mission in missions) {
      final isComplete = await _isMissionComplete(userId, mission.id);
      result.add(MapEntry(mission, isComplete));
    }
    
    return result;
  }

  Future<bool> _isMissionComplete(String userId, String missionId) async {
    final lessons = await repository.getLessonsForMission(missionId);
    final allExercises = <String>[];
    for (final lesson in lessons) {
      allExercises.addAll(lesson.exerciseIds);
    }
    
    if (allExercises.isEmpty) return false;
    
    final attempts = await repository.getAttemptsForUser(userId);
    final completedExercises = attempts
        .where((a) => allExercises.contains(a.exerciseId) && a.isComplete)
        .map((a) => a.exerciseId)
        .toSet();
    
    return completedExercises.length >= allExercises.length * 0.7;
  }

  // ==========================================================================
  // EXERCISE PIPELINE
  // ==========================================================================

  /// Submit an exercise attempt for evaluation
  Future<Feedback> submitExerciseAttempt({
    required String userId,
    required String exerciseId,
    required String submission,
  }) async {
    final exercise = await repository.getExercise(exerciseId);
    if (exercise == null) {
      throw Exception('Exercise not found: $exerciseId');
    }

    // Create attempt
    final attempt = ExerciseAttempt(
      id: 'attempt_${DateTime.now().millisecondsSinceEpoch}',
      exerciseId: exerciseId,
      userId: userId,
      submission: submission,
      timestamp: DateTime.now(),
    );

    await repository.saveAttempt(attempt);

    // Evaluate the attempt
    final feedback = await _evaluateAttempt(attempt, exercise);
    await repository.saveFeedback(feedback);

    // Update attempt with feedback
    final updatedAttempt = attempt.copyWith(
      score: feedback.overallScore,
      errors: feedback.errors,
      feedbackId: feedback.id,
      isComplete: true,
    );
    await repository.saveAttempt(updatedAttempt);

    // Update skill progress
    await _updateSkillProgress(userId, exercise.skillId, feedback);

    return feedback;
  }

  /// Evaluate an exercise attempt
  Future<Feedback> _evaluateAttempt(ExerciseAttempt attempt, Exercise exercise) async {
    // This would integrate with AI evaluation in production
    // For now, we simulate evaluation based on exercise type
    
    final errors = <ErrorAnnotation>[];
    var score = 0.0;
    final strengths = <String>[];
    final improvements = <String>[];
    
    // Simulate evaluation based on exercise type
    switch (exercise.type) {
      case ExerciseType.recognition:
        score = _simulateRecognitionScore(attempt.submission);
        if (score < 0.7) {
          errors.add(_createErrorAnnotation('recognition_error', attempt.submission));
        }
        break;
      case ExerciseType.correction:
        score = _simulateCorrectionScore(attempt.submission);
        if (score < 0.6) {
          errors.add(_createErrorAnnotation('correction_error', attempt.submission));
        }
        break;
      case ExerciseType.classification:
        score = _simulateClassificationScore(attempt.submission);
        if (score < 0.6) {
          errors.add(_createErrorAnnotation('classification_error', attempt.submission));
        }
        break;
      case ExerciseType.production:
        score = _simulateProductionScore(attempt.submission);
        if (score < 0.5) {
          errors.add(_createErrorAnnotation('production_error', attempt.submission));
        }
        break;
      case ExerciseType.application:
        score = _simulateApplicationScore(attempt.submission);
        if (score < 0.5) {
          errors.add(_createErrorAnnotation('application_error', attempt.submission));
        }
        break;
    }

    // Determine strengths and improvements
    if (score >= 0.7) {
      strengths.add('Good understanding of the concept');
    }
    if (score >= 0.8) {
      strengths.add('Clear and accurate response');
    }
    if (score < 0.6) {
      improvements.add('Review the underlying concepts');
    }
    if (score < 0.4) {
      improvements.add('Consider revisiting prerequisite material');
    }

    return Feedback(
      id: 'fb_${DateTime.now().millisecondsSinceEpoch}',
      attemptId: attempt.id,
      timestamp: DateTime.now(),
      overallScore: score,
      errors: errors,
      strengths: strengths,
      improvementAreas: improvements,
      summary: _generateFeedbackSummary(score, errors.length),
      nextLessonSuggestion: score < 0.6 ? 'Review prerequisite concepts' : null,
      recommendedExercises: score < 0.6 ? [exercise.id] : [],
    );
  }

  // Simulated scoring functions (would be replaced by AI in production)
  double _simulateRecognitionScore(String submission) {
    // Simulate: check for correct classification keywords
    final correct = ['noun', 'verb', 'adjective', 'adverb', 'pronoun'];
    final found = correct.where((w) => submission.toLowerCase().contains(w)).length;
    return found / correct.length;
  }

  double _simulateCorrectionScore(String submission) {
    // Simulate: check for correction indicators
    final correctionIndicators = ['correct', 'should be', 'instead of', 'replace'];
    final found = correctionIndicators.where((w) => submission.toLowerCase().contains(w)).length;
    return 0.5 + (found * 0.1).clamp(0.0, 0.5);
  }

  double _simulateClassificationScore(String submission) {
    // Simulate: check for classification markers
    final markers = ['labeled', 'classified as', 'category', 'class'];
    final found = markers.where((w) => submission.toLowerCase().contains(w)).length;
    return 0.5 + (found * 0.1).clamp(0.0, 0.5);
  }

  double _simulateProductionScore(String submission) {
    // Simulate: check for sentence completeness
    final words = submission.split(' ');
    if (words.length < 5) return 0.3;
    if (words.length < 10) return 0.6;
    return 0.8;
  }

  double _simulateApplicationScore(String submission) {
    // Simulate: check for application evidence
    final applications = ['applied', 'used', 'applied the concept', 'in practice'];
    final found = applications.where((w) => submission.toLowerCase().contains(w)).length;
    return 0.4 + (found * 0.15).clamp(0.0, 0.6);
  }

  ErrorAnnotation _createErrorAnnotation(String type, String text) {
    return ErrorAnnotation(
      id: 'err_${DateTime.now().millisecondsSinceEpoch}',
      startIndex: 0,
      endIndex: text.length.clamp(0, 10),
      errorText: text.substring(0, text.length.clamp(0, 20)),
      correction: 'Corrected version',
      diagnosis: ErrorDiagnosis.wordClassConfusion,
      conceptId: 'C002',
      explanation: 'This error suggests confusion about word classes.',
    );
  }

  String _generateFeedbackSummary(double score, int errorCount) {
    if (score >= 0.9) return 'Excellent work! You demonstrated strong understanding.';
    if (score >= 0.7) return 'Good effort. You have a solid grasp with some areas to improve.';
    if (score >= 0.5) return 'You\'re on the right track. Review the concepts and try again.';
    return 'This needs more practice. Focus on understanding the core concepts first.';
  }

  // ==========================================================================
  // SKILL PROGRESSION
  // ==========================================================================

  /// Update skill progress based on feedback
  Future<void> _updateSkillProgress(String userId, String skillId, Feedback feedback) async {
    var progress = await repository.getSkillProgress(userId, skillId);
    
    if (progress == null) {
      progress = SkillProgress(
        skillId: '$userId:$skillId',
        lastAssessed: DateTime.now(),
      );
    }

    // Calculate new accuracy based on recent feedback
    final attempts = await repository.getAttemptsForUser(userId);
    final skillAttempts = attempts.where((a) => {
      // Get all exercises for this skill
      final exercises = await repository.getExercisesForLesson(/* need lessonId */);
      return exercises.any((e) => e.skillId == skillId && a.exerciseId == e.id);
    }).toList();

    final avgAccuracy = skillAttempts.isNotEmpty
        ? skillAttempts.map((a) => a.score ?? 0.0).reduce((a, b) => a + b) / skillAttempts.length
        : feedback.overallScore;

    // Determine level based on accuracy
    SkillLevel newLevel;
    if (avgAccuracy >= 0.95) {
      newLevel = SkillLevel.mastered;
    } else if (avgAccuracy >= 0.85) {
      newLevel = SkillLevel.proficient;
    } else if (avgAccuracy >= 0.70) {
      newLevel = SkillLevel.developing;
    } else {
      newLevel = SkillLevel.novice;
    }

    final updatedProgress = progress.copyWith(
      currentLevel: newLevel,
      lastAssessed: DateTime.now(),
      currentAccuracy: avgAccuracy,
      practiceAttempts: progress.practiceAttempts + 1,
    );

    await repository.saveSkillProgress(updatedProgress);
  }

  /// Get a learner's skill profile
  Future<Map<SkillLevel, List<SkillProgress>>> getSkillProfile(String userId) async {
    final allProgress = await repository.getAllSkillProgress(userId);
    final profile = <SkillLevel, List<SkillProgress>>{
      for (final level in SkillLevel.values) level: [],
    };
    
    for (final progress in allProgress) {
      profile[progress.currentLevel]?.add(progress);
    }
    
    return profile;
  }

  // ==========================================================================
  // ERROR DIAGNOSIS
  // ==========================================================================

  /// Diagnose an error based on pattern matching
  Future<ErrorDiagnosis?> diagnoseError(String text, String conceptId) async {
    // In production, this would use more sophisticated analysis
    // For now, simple pattern matching
    
    final lowerText = text.toLowerCase();
    
    // Check for common error patterns
    if (lowerText.contains('group of') && lowerText.contains('are')) {
      return ErrorDiagnosis.nearestNounAttraction;
    }
    if (lowerText.contains('good') && (lowerText.contains('speak') || lowerText.contains('write'))) {
      return ErrorDiagnosis.wordClassConfusion;
    }
    if (lowerText.contains('a') && lowerText.contains('university')) {
      return ErrorDiagnosis.articleMisuse;
    }
    if (lowerText.contains('was') && lowerText.contains('now')) {
      return ErrorDiagnosis.tenseInconsistency;
    }
    if (lowerText.contains('.') && !lowerText.contains(' ')) {
      return ErrorDiagnosis.fragment;
    }
    if (lowerText.split('.').any((s) => s.length > 100 && s.contains(','))) {
      return ErrorDiagnosis.runOn;
    }
    
    return null;
  }

  /// Get relevant misconceptions for an error
  Future<List<Misconception>> getMisconceptionsForError(ErrorDiagnosis diagnosis) async {
    // Map diagnosis to likely concepts
    final conceptMap = {
      ErrorDiagnosis.nearestNounAttraction: 'C009',
      ErrorDiagnosis.wordClassConfusion: 'C002',
      ErrorDiagnosis.articleMisuse: 'C016',
      ErrorDiagnosis.tenseInconsistency: 'C010',
      ErrorDiagnosis.fragment: 'C021',
      ErrorDiagnosis.runOn: 'C022',
      ErrorDiagnosis.commaSplice: 'C020',
      ErrorDiagnosis.subjectVerbAgreement: 'C009',
    };
    
    final conceptId = conceptMap[diagnosis];
    if (conceptId == null) return [];
    
    return await repository.getMisconceptionsForConcept(conceptId);
  }

  // ==========================================================================
  // LEARNING PATH RECOMMENDATION
  // ==========================================================================

  /// Generate a personalized learning path
  Future<List<String>> generateLearningPath(String userId, String targetMissionId) async {
    final path = <String>[];
    final visited = <String>{};
    
    // Get target mission
    final target = await repository.getMission(targetMissionId);
    if (target == null) return path;
    
    // Get all missions and skills needed
    final allMissions = await repository.getMissionsByStage(target.stage);
    final missionMap = {for (var m in allMissions) m.id: m};
    
    // BFS to find prerequisites
    final queue = Queue<String>();
    queue.add(targetMissionId);
    
    while (queue.isNotEmpty) {
      final currentId = queue.removeFirst();
      if (visited.contains(currentId)) continue;
      visited.add(currentId);
      
      final current = missionMap[currentId];
      if (current == null) continue;
      
      // Add to path if not already
      if (!path.contains(currentId) && currentId != targetMissionId) {
        path.insert(0, currentId);
      }
      
      // Add prerequisites
      for (final prereqId in current.prerequisiteMissionIds) {
        if (!visited.contains(prereqId)) {
          queue.add(prereqId);
        }
      }
    }
    
    // Add target mission at the end
    path.add(targetMissionId);
    
    return path;
  }

  // ==========================================================================
  // RABBIT HOLE DISCOVERY
  // ==========================================================================

  /// Discover related concepts for deep learning
  Future<List<Concept>> discoverRelatedConcepts(String conceptId, int depth) async {
    final concept = await repository.getConcept(conceptId);
    if (concept == null) return [];
    
    final related = <Concept>[];
    final visited = <String>{conceptId};
    final queue = Queue<String>();
    queue.addAll(concept.relatedIds);
    
    var currentDepth = 0;
    while (queue.isNotEmpty && currentDepth < depth) {
      final currentId = queue.removeFirst();
      if (visited.contains(currentId)) continue;
      visited.add(currentId);
      
      final current = await repository.getConcept(currentId);
      if (current != null) {
        related.add(current);
        queue.addAll(current.relatedIds);
      }
      currentDepth++;
    }
    
    return related;
  }
}

// ============================================================================
// USAGE EXAMPLE
// ============================================================================

void main() async {
  // Initialize repository and service
  final repository = InMemoryDAWAMRepository();
  final service = DAWAMService(repository);

  // Seed sample data
  await _seedSampleData(repository);

  // Example: Get available missions for a user
  print('=== Available Missions ===');
  final available = await service.getNextRecommendedMission('user1');
  print('Next recommended mission: ${available?.title ?? 'None'}');

  // Example: Submit an exercise attempt
  print('\n=== Submitting Exercise ===');
  final feedback = await service.submitExerciseAttempt(
    userId: 'user1',
    exerciseId: 'E001',
    submission: 'The cat runs quickly through the garden.',
  );
  
  print('Score: ${feedback.overallScore}');
  print('Summary: ${feedback.summary}');
  if (feedback.errors.isNotEmpty) {
    print('Errors found: ${feedback.errors.length}');
    for (final error in feedback.errors) {
      print('  - ${error.diagnosis.name}: ${error.explanation}');
    }
  }

  // Example: Get skill profile
  print('\n=== Skill Profile ===');
  final profile = await service.getSkillProfile('user1');
  for (final level in SkillLevel.values) {
    final skills = profile[level] ?? [];
    print('$level: ${skills.length} skills');
  }

  // Example: Diagnose an error
  print('\n=== Error Diagnosis ===');
  final diagnosis = await service.diagnoseError('The group of students are learning.', 'C009');
  print('Diagnosis: ${diagnosis?.name ?? 'Not found'}');
  
  if (diagnosis != null) {
    final misconceptions = await service.getMisconceptionsForError(diagnosis);
    for (final m in misconceptions) {
      print('  - ${m.description}');
      print('    Example: ${m.example}');
    }
  }

  // Example: Generate learning path
  print('\n=== Learning Path ===');
  final path = await service.generateLearningPath('user1', 'M30');
  print('Path: ${path.join(' -> ')}');
}

Future<void> _seedSampleData(DAWAMRepository repository) async {
  // Seed concepts
  final concepts = [
    Concept(
      id: 'C001',
      name: 'Word',
      domain: 'Syntax',
      definition: 'The smallest unit of language that can stand alone as a complete utterance.',
      firstAppearsIn: 'M01',
    ),
    Concept(
      id: 'C002',
      name: 'Part of Speech',
      domain: 'Syntax',
      definition: 'A category of words with similar grammatical properties.',
      prerequisiteIds: ['C001'],
      firstAppearsIn: 'M01',
    ),
    Concept(
      id: 'C003',
      name: 'Noun',
      domain: 'Syntax',
      definition: 'A word used to name a person, place, thing, or idea.',
      prerequisiteIds: ['C002'],
      firstAppearsIn: 'M01',
    ),
    Concept(
      id: 'C004',
      name: 'Verb',
      domain: 'Syntax',
      definition: 'A word used to describe an action, occurrence, or state of being.',
      prerequisiteIds: ['C002'],
      firstAppearsIn: 'M01',
    ),
    Concept(
      id: 'C005',
      name: 'Subject',
      domain: 'Syntax',
      definition: 'The part of a sentence that indicates who or what is performing the action.',
      prerequisiteIds: ['C003', 'C004'],
      firstAppearsIn: 'M02',
    ),
    Concept(
      id: 'C006',
      name: 'Predicate',
      domain: 'Syntax',
      definition: 'The part of a sentence that tells something about the subject.',
      prerequisiteIds: ['C004'],
      firstAppearsIn: 'M02',
    ),
    Concept(
      id: 'C009',
      name: 'Subject-Verb Agreement',
      domain: 'Grammar',
      definition: 'The grammatical rule that a subject must agree with its verb in number.',
      prerequisiteIds: ['C005', 'C006'],
      firstAppearsIn: 'M02',
    ),
  ];
  
  for (final concept in concepts) {
    await repository.saveConcept(concept);
  }

  // Seed skills
  final skills = [
    Skill(
      id: 'S001',
      abilityStatement: 'Classify a word by its part of speech in isolation.',
      conceptIds: ['C002', 'C003', 'C004'],
      builtInMission: 'M01',
      status: 'Draft',
    ),
    Skill(
      id: 'S002',
      abilityStatement: 'Classify a word by its part of speech as it functions in a specific sentence.',
      prerequisiteSkillIds: ['S001'],
      conceptIds: ['C002', 'C003', 'C004'],
      builtInMission: 'M01',
      status: 'Draft',
    ),
    Skill(
      id: 'S003',
      abilityStatement: 'Compose an original sentence that correctly deploys multiple word classes.',
      prerequisiteSkillIds: ['S002'],
      conceptIds: ['C001', 'C002', 'C003', 'C004', 'C005', 'C006'],
      builtInMission: 'M01',
      status: 'Draft',
    ),
  ];
  
  for (final skill in skills) {
    await repository.saveSkill(skill);
  }

  // Seed mastery criteria
  final mastery = [
    MasteryCriteria(
      skillId: 'S001',
      descriptors: {
        SkillLevel.novice: 'Cannot reliably distinguish word classes even in isolation.',
        SkillLevel.developing: 'Correctly classifies nouns and verbs but struggles with adjectives, adverbs, or pronouns.',
        SkillLevel.proficient: 'Classifies all five target word classes in isolation with ≥90% accuracy.',
        SkillLevel.mastered: 'Instant, error-free classification in isolation across varied/unfamiliar vocabulary.',
      },
      minimumEvidence: '≥90% accuracy across 2 separate exercise attempts (E001, E002).',
      retestTrigger: 'If accuracy drops below 80% on a later mission\'s warm-up, resurface an S001 review exercise.',
    ),
    MasteryCriteria(
      skillId: 'S002',
      descriptors: {
        SkillLevel.novice: 'Misidentifies word class whenever context changes a word\'s role.',
        SkillLevel.developing: 'Correct on unambiguous cases; still errs on context-shifted or multi-function words.',
        SkillLevel.proficient: '≥85% accuracy classifying words within full sentences, including context-shifted cases.',
        SkillLevel.mastered: 'Consistent accuracy across unfamiliar sentences and paragraph-length text.',
      },
      minimumEvidence: '≥85% accuracy across 2 attempts on different sentence sets (E003, E004).',
      retestTrigger: 'If a later mission\'s grading flags word-class confusion, resurface an S002 review exercise.',
    ),
    MasteryCriteria(
      skillId: 'S003',
      descriptors: {
        SkillLevel.novice: 'Sentences show word-class misuse, or required classes are missing/avoided entirely.',
        SkillLevel.developing: 'Produces grammatically valid sentences but avoids certain word classes.',
        SkillLevel.proficient: 'Independently produces sentences that correctly use all five target word classes.',
        SkillLevel.mastered: 'Uses word classes correctly and fluently inside free paragraph writing, unprompted.',
      },
      minimumEvidence: '1 dedicated production exercise (E005) + confirmed correct in ≥1 later paragraph-task submission.',
      retestTrigger: 'If a later paragraph task shows word-class errors, mark S003 as regressed to Developing.',
    ),
  ];
  
  for (final criteria in mastery) {
    await repository.saveMasteryCriteria(criteria);
  }

  // Seed misconceptions
  final misconceptions = [
    Misconception(
      id: 'ERR001',
      conceptId: 'C004',
      description: 'Treating any action-sounding word as a verb regardless of its actual grammatical role.',
      example: '"Running is good exercise" — student labels \'Running\' a verb because of its form.',
      correctUnderstanding: 'Word class depends on grammatical function in the specific clause.',
      diagnosticValue: ErrorDiagnosis.wordClassConfusion,
    ),
    Misconception(
      id: 'ERR002',
      conceptId: 'C002',
      description: 'Confusing adjectives and adverbs because both feel like they "describe" something.',
      example: '"She speaks good English" — \'good\' used where \'well\' is required.',
      correctUnderstanding: 'Adjectives modify nouns; adverbs modify verbs, adjectives, or other adverbs.',
      diagnosticValue: ErrorDiagnosis.wordClassConfusion,
    ),
    Misconception(
      id: 'ERR003',
      conceptId: 'C003',
      description: 'Assuming nouns must be physical/concrete objects, so abstract nouns go unrecognized.',
      example: 'Student fails to identify "happiness" or "freedom" as nouns.',
      correctUnderstanding: 'Nouns include abstract concepts and ideas, not only physical objects.',
    ),
  ];
  
  for (final misconception in misconceptions) {
    await repository.saveMisconception(misconception);
  }

  // Seed mission
  final mission = Mission(
    id: 'M01',
    stage: 'I — Foundation',
    number: 1,
    title: 'I Can Identify the Building Blocks of a Sentence',
    description: 'Recognize and use nouns, verbs, adjectives, adverbs, and pronouns as the raw material of a sentence.',
    skillIds: ['S001', 'S002', 'S003'],
    pillar: Pillar.grammar,
    difficulty: Difficulty.level1,
    assessmentType: AssessmentType.correction,
    status: 'Draft',
    lessonIds: ['L001', 'L002', 'L003'],
  );
  await repository.saveMission(mission);

  // Seed lessons
  final lessons = [
    Lesson(
      id: 'L001',
      missionId: 'M01',
      number: 1,
      title: 'What Is a Word Class?',
      stage: PedagogicalStage.activate,
      learningObjective: 'Recognize that words fall into classes that behave differently in a sentence.',
      skillId: 'S001',
      skillDescription: 'Word-class recognition (knowledge level)',
      conceptIds: ['C001', 'C002', 'C003', 'C004'],
      difficulty: Difficulty.level1,
      estimatedMinutes: 10,
      status: 'Draft',
      exerciseIds: ['E001', 'E002'],
    ),
    Lesson(
      id: 'L002',
      missionId: 'M01',
      number: 2,
      title: 'Recognizing Word Classes in Context',
      stage: PedagogicalStage.demonstrate,
      learningObjective: 'Correctly identify the part of speech of a word as used in a specific sentence.',
      skillId: 'S002',
      skillDescription: 'Word-class recognition in context (application level)',
      conceptIds: ['C002', 'C003', 'C004'],
      difficulty: Difficulty.level2,
      estimatedMinutes: 12,
      status: 'Draft',
      exerciseIds: ['E003', 'E004'],
    ),
    Lesson(
      id: 'L003',
      missionId: 'M01',
      number: 3,
      title: 'Building Sentences from Word Classes',
      stage: PedagogicalStage.apply,
      learningObjective: 'Independently compose sentences that correctly deploy each word class to build meaning.',
      skillId: 'S003',
      skillDescription: 'Word-class production (production/transfer level)',
      conceptIds: ['C001', 'C002', 'C003', 'C004', 'C005', 'C006'],
      difficulty: Difficulty.level2,
      estimatedMinutes: 15,
      status: 'Draft',
      exerciseIds: ['E005', 'E006'],
    ),
  ];
  
  for (final lesson in lessons) {
    await repository.saveLesson(lesson);
  }

  // Seed exercises
  final exercises = [
    Exercise(
      id: 'E001',
      lessonId: 'L001',
      skillId: 'S001',
      type: ExerciseType.recognition,
      prompt: 'Given a short sentence, identify which word is the verb.',
      conceptIds: ['C004'],
      difficulty: Difficulty.level1,
    ),
    Exercise(
      id: 'E002',
      lessonId: 'L001',
      skillId: 'S001',
      type: ExerciseType.recognition,
      prompt: 'Given a list of 8 words, sort each into noun / verb / adjective / adverb.',
      conceptIds: ['C002', 'C003', 'C004'],
      difficulty: Difficulty.level1,
    ),
    Exercise(
      id: 'E003',
      lessonId: 'L002',
      skillId: 'S002',
      type: ExerciseType.correction,
      prompt: 'This sentence misuses a word\'s part of speech. Correct it.',
      conceptIds: ['C002', 'C004'],
      difficulty: Difficulty.level2,
    ),
    Exercise(
      id: 'E004',
      lessonId: 'L002',
      skillId: 'S002',
      type: ExerciseType.classification,
      prompt: 'Label the part of speech of every word in a given sentence.',
      conceptIds: ['C001', 'C002'],
      difficulty: Difficulty.level2,
    ),
    Exercise(
      id: 'E005',
      lessonId: 'L003',
      skillId: 'S003',
      type: ExerciseType.production,
      prompt: 'Write one original sentence that correctly uses a noun, a verb, an adjective, and an adverb.',
      conceptIds: ['C001', 'C002', 'C003', 'C004'],
      difficulty: Difficulty.level2,
    ),
    Exercise(
      id: 'E006',
      lessonId: 'L003',
      skillId: 'S003',
      type: ExerciseType.application,
      prompt: 'Identify and label the parts of speech in a short paragraph the student writes themselves.',
      conceptIds: ['C001', 'C002', 'C003', 'C004', 'C005', 'C006'],
      difficulty: Difficulty.level3,
    ),
  ];
  
  for (final exercise in exercises) {
    await repository.saveExercise(exercise);
  }
}