BEGIN;
--
-- Create model QuestionChoice
--
CREATE TABLE "calla_survey_questionchoice" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "choice_text" varchar(100) NOT NULL);
--
-- Create model QuestionDomain
--
CREATE TABLE "calla_survey_questiondomain" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "domain_description" varchar(100) NOT NULL);
--
-- Create model QuestionType
--
CREATE TABLE "calla_survey_questiontype" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "type_description" varchar(100) NOT NULL);
--
-- Create model SurveyAnswer
--
CREATE TABLE "calla_survey_surveyanswer" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "answer_text" varchar(300) NOT NULL, "answer_note" varchar(300) NOT NULL, "answer_link" varchar(100) NOT NULL, "answer_score" integer NOT NULL, "answer_choice_id" integer NOT NULL REFERENCES "calla_survey_questionchoice" ("id"));
--
-- Create model SurveyQuestion
--
CREATE TABLE "calla_survey_surveyquestion" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "question_essence" varchar(100) NOT NULL, "question_text" varchar(300) NOT NULL, "question_note" varchar(300) NOT NULL, "question_domain_id" integer NOT NULL REFERENCES "calla_survey_questiondomain" ("id"));
--
-- Create model SurveySet
--
CREATE TABLE "calla_survey_surveyset" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "survey_name" varchar(50) NOT NULL, "survey_description" varchar(300) NOT NULL, "survey_total_questions" integer NOT NULL, "survey_is_active" bool NOT NULL, "survey_note" varchar(300) NOT NULL, "survey_creator_id" integer NOT NULL REFERENCES "auth_user" ("id"));
--
-- Create model SurveySetType
--
CREATE TABLE "calla_survey_surveysettype" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "type_description" varchar(50) NOT NULL);
--
-- Create model SurveyUser
--
CREATE TABLE "calla_survey_surveyuser" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "user_surname" varchar(25) NOT NULL, "user_forename" varchar(25) NOT NULL, "user_password" varchar(12) NOT NULL, "user_note" varchar(200) NOT NULL, "user_identifier" integer NOT NULL, "user_identifier_type" varchar(100) NOT NULL, "user_bonus" integer NOT NULL, "user_creator_id" integer NOT NULL REFERENCES "auth_user" ("id"));
--
-- Create model SurveyUserType
--
CREATE TABLE "calla_survey_surveyusertype" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "usertype_description" varchar(50) NOT NULL);
--
-- Add field user_role to surveyuser
--
ALTER TABLE "calla_survey_surveyuser" RENAME TO "calla_survey_surveyuser__old";
CREATE TABLE "calla_survey_surveyuser" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "user_surname" varchar(25) NOT NULL, "user_forename" varchar(25) NOT NULL, "user_password" varchar(12) NOT NULL, "user_note" varchar(200) NOT NULL, "user_identifier" integer NOT NULL, "user_identifier_type" varchar(100) NOT NULL, "user_bonus" integer NOT NULL, "user_creator_id" integer NOT NULL REFERENCES "auth_user" ("id"), "user_role_id" integer NOT NULL REFERENCES "calla_survey_surveyusertype" ("id"));
INSERT INTO "calla_survey_surveyuser" ("user_identifier", "user_role_id", "user_note", "id", "user_password", "user_forename", "user_bonus", "user_identifier_type", "user_creator_id", "user_surname") SELECT "user_identifier", NULL, "user_note", "id", "user_password", "user_forename", "user_bonus", "user_identifier_type", "user_creator_id", "user_surname" FROM "calla_survey_surveyuser__old";
DROP TABLE "calla_survey_surveyuser__old";
CREATE INDEX "calla_survey_surveyanswer_05b527ab" ON "calla_survey_surveyanswer" ("answer_choice_id");
CREATE INDEX "calla_survey_surveyquestion_b2a4de1e" ON "calla_survey_surveyquestion" ("question_domain_id");
CREATE INDEX "calla_survey_surveyset_fe7ff1e3" ON "calla_survey_surveyset" ("survey_creator_id");
CREATE INDEX "calla_survey_surveyuser_7e55a74e" ON "calla_survey_surveyuser" ("user_creator_id");
CREATE INDEX "calla_survey_surveyuser_1728abaf" ON "calla_survey_surveyuser" ("user_role_id");
--
-- Add field survey_report_back to surveyset
--
ALTER TABLE "calla_survey_surveyset" RENAME TO "calla_survey_surveyset__old";
CREATE TABLE "calla_survey_surveyset" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "survey_name" varchar(50) NOT NULL, "survey_description" varchar(300) NOT NULL, "survey_total_questions" integer NOT NULL, "survey_is_active" bool NOT NULL, "survey_note" varchar(300) NOT NULL, "survey_creator_id" integer NOT NULL REFERENCES "auth_user" ("id"), "survey_report_back_id" integer NOT NULL REFERENCES "calla_survey_surveyuser" ("id"));
INSERT INTO "calla_survey_surveyset" ("survey_name", "survey_is_active", "survey_total_questions", "survey_creator_id", "survey_note", "survey_report_back_id", "survey_description", "id") SELECT "survey_name", "survey_is_active", "survey_total_questions", "survey_creator_id", "survey_note", NULL, "survey_description", "id" FROM "calla_survey_surveyset__old";
DROP TABLE "calla_survey_surveyset__old";
CREATE INDEX "calla_survey_surveyset_fe7ff1e3" ON "calla_survey_surveyset" ("survey_creator_id");
CREATE INDEX "calla_survey_surveyset_b8fc46c2" ON "calla_survey_surveyset" ("survey_report_back_id");
--
-- Add field survey_type to surveyset
--
ALTER TABLE "calla_survey_surveyset" RENAME TO "calla_survey_surveyset__old";
CREATE TABLE "calla_survey_surveyset" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "survey_name" varchar(50) NOT NULL, "survey_description" varchar(300) NOT NULL, "survey_total_questions" integer NOT NULL, "survey_is_active" bool NOT NULL, "survey_note" varchar(300) NOT NULL, "survey_creator_id" integer NOT NULL REFERENCES "auth_user" ("id"), "survey_report_back_id" integer NOT NULL REFERENCES "calla_survey_surveyuser" ("id"), "survey_type_id" integer NOT NULL REFERENCES "calla_survey_surveysettype" ("id"));
INSERT INTO "calla_survey_surveyset" ("survey_name", "survey_is_active", "survey_type_id", "survey_total_questions", "survey_creator_id", "survey_note", "survey_report_back_id", "survey_description", "id") SELECT "survey_name", "survey_is_active", NULL, "survey_total_questions", "survey_creator_id", "survey_note", "survey_report_back_id", "survey_description", "id" FROM "calla_survey_surveyset__old";
DROP TABLE "calla_survey_surveyset__old";
CREATE INDEX "calla_survey_surveyset_fe7ff1e3" ON "calla_survey_surveyset" ("survey_creator_id");
CREATE INDEX "calla_survey_surveyset_b8fc46c2" ON "calla_survey_surveyset" ("survey_report_back_id");
CREATE INDEX "calla_survey_surveyset_30a137a8" ON "calla_survey_surveyset" ("survey_type_id");
--
-- Add field question_survey_id to surveyquestion
--
ALTER TABLE "calla_survey_surveyquestion" RENAME TO "calla_survey_surveyquestion__old";
CREATE TABLE "calla_survey_surveyquestion" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "question_essence" varchar(100) NOT NULL, "question_text" varchar(300) NOT NULL, "question_note" varchar(300) NOT NULL, "question_domain_id" integer NOT NULL REFERENCES "calla_survey_questiondomain" ("id"), "question_survey_id_id" integer NOT NULL REFERENCES "calla_survey_surveyset" ("id"));
INSERT INTO "calla_survey_surveyquestion" ("question_essence", "question_survey_id_id", "question_text", "question_note", "id", "question_domain_id") SELECT "question_essence", NULL, "question_text", "question_note", "id", "question_domain_id" FROM "calla_survey_surveyquestion__old";
DROP TABLE "calla_survey_surveyquestion__old";
CREATE INDEX "calla_survey_surveyquestion_b2a4de1e" ON "calla_survey_surveyquestion" ("question_domain_id");
CREATE INDEX "calla_survey_surveyquestion_7ef5aa93" ON "calla_survey_surveyquestion" ("question_survey_id_id");
--
-- Add field question_type to surveyquestion
--
ALTER TABLE "calla_survey_surveyquestion" RENAME TO "calla_survey_surveyquestion__old";
CREATE TABLE "calla_survey_surveyquestion" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "question_essence" varchar(100) NOT NULL, "question_text" varchar(300) NOT NULL, "question_note" varchar(300) NOT NULL, "question_domain_id" integer NOT NULL REFERENCES "calla_survey_questiondomain" ("id"), "question_survey_id_id" integer NOT NULL REFERENCES "calla_survey_surveyset" ("id"), "question_type_id" integer NOT NULL REFERENCES "calla_survey_questiontype" ("id"));
INSERT INTO "calla_survey_surveyquestion" ("question_essence", "question_type_id", "question_survey_id_id", "question_text", "question_note", "id", "question_domain_id") SELECT "question_essence", NULL, "question_survey_id_id", "question_text", "question_note", "id", "question_domain_id" FROM "calla_survey_surveyquestion__old";
DROP TABLE "calla_survey_surveyquestion__old";
CREATE INDEX "calla_survey_surveyquestion_b2a4de1e" ON "calla_survey_surveyquestion" ("question_domain_id");
CREATE INDEX "calla_survey_surveyquestion_7ef5aa93" ON "calla_survey_surveyquestion" ("question_survey_id_id");
CREATE INDEX "calla_survey_surveyquestion_dacd6056" ON "calla_survey_surveyquestion" ("question_type_id");
--
-- Add field answer_question_id to surveyanswer
--
ALTER TABLE "calla_survey_surveyanswer" RENAME TO "calla_survey_surveyanswer__old";
CREATE TABLE "calla_survey_surveyanswer" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "answer_text" varchar(300) NOT NULL, "answer_note" varchar(300) NOT NULL, "answer_link" varchar(100) NOT NULL, "answer_score" integer NOT NULL, "answer_choice_id" integer NOT NULL REFERENCES "calla_survey_questionchoice" ("id"), "answer_question_id_id" integer NOT NULL REFERENCES "calla_survey_surveyquestion" ("id"));
INSERT INTO "calla_survey_surveyanswer" ("answer_link", "id", "answer_choice_id", "answer_note", "answer_score", "answer_text", "answer_question_id_id") SELECT "answer_link", "id", "answer_choice_id", "answer_note", "answer_score", "answer_text", NULL FROM "calla_survey_surveyanswer__old";
DROP TABLE "calla_survey_surveyanswer__old";
CREATE INDEX "calla_survey_surveyanswer_05b527ab" ON "calla_survey_surveyanswer" ("answer_choice_id");
CREATE INDEX "calla_survey_surveyanswer_11bb8f97" ON "calla_survey_surveyanswer" ("answer_question_id_id");
--
-- Add field choice_domain_id to questionchoice
--
ALTER TABLE "calla_survey_questionchoice" RENAME TO "calla_survey_questionchoice__old";
CREATE TABLE "calla_survey_questionchoice" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "choice_text" varchar(100) NOT NULL, "choice_domain_id_id" integer NOT NULL REFERENCES "calla_survey_questiondomain" ("id"));
INSERT INTO "calla_survey_questionchoice" ("choice_domain_id_id", "choice_text", "id") SELECT NULL, "choice_text", "id" FROM "calla_survey_questionchoice__old";
DROP TABLE "calla_survey_questionchoice__old";
CREATE INDEX "calla_survey_questionchoice_b8710419" ON "calla_survey_questionchoice" ("choice_domain_id_id");

COMMIT;
