FILE_URL = https://raw.githubusercontent.com/ydb-platform/ydb/refs/heads/main/ydb/library/yql/sql/v1/SQLv1Antlr4.g.in

STEP1_FILE = SQLv1Antlr4_step_1.g4
FINAL_FILE = SQLv1Antlr4.g4

all: download_file replacement generate_parser

download_file:
	@echo "Downloading grammar file..."
	@curl -L $(FILE_URL) -o $(STEP1_FILE)

# # https://github.com/OrlovPavel/ydb/blob/70e6c9cd4284bcb65946a8a24c5beeed658b021f/ydb/library/yql/parser/proto_ast/gen/v1_antlr4/epilogue.cmake
replacement_default:
	@echo "Replacement is in progress.."
	@cp $(STEP1_FILE) $(FINAL_FILE)
	@sed -i '' "s/@GRAMMAR_STRING_CORE_SINGLE@/~(['\\\\\\\]) | (BACKSLASH .)/g" $(FINAL_FILE)
	@sed -i '' "s/@GRAMMAR_STRING_CORE_DOUBLE@/~([\\\"\\\\\\\]) | (BACKSLASH .)/g" $(FINAL_FILE)
	@sed -i '' "s/@GRAMMAR_MULTILINE_COMMENT_CORE@/./g" $(FINAL_FILE)

# https://github.com/OrlovPavel/ydb/blob/70e6c9cd4284bcb65946a8a24c5beeed658b021f/ydb/library/yql/parser/proto_ast/gen/v1_ansi_antlr4/epilogue.cmake
replacement_ansii:
	@echo "Replacement is in progress.."
	@cp $(STEP1_FILE) $(FINAL_FILE)
	@sed -i '' "s/@GRAMMAR_STRING_CORE_SINGLE@/~(['\\]) | (BACKSLASH .)/g" $(FINAL_FILE)
	@sed -i '' "s/@GRAMMAR_STRING_CORE_DOUBLE@/~([\\\"\]) | (BACKSLASH .)/g" $(FINAL_FILE)
	@sed -i '' "s/@GRAMMAR_MULTILINE_COMMENT_CORE@/MULTILINE_COMMENT | ./g" $(FINAL_FILE)


replacement:
	@if [ "$(SCENARIO)" = "ansii" ]; then \
		$(MAKE) replacement_ansii; \
	else \
		$(MAKE) replacement_default; \
	fi

generate_parser:
	@echo "Downloading antlr4 jar file..."
	@curl -O https://www.antlr.org/download/antlr-4.13.2-complete.jar
	@echo "Generating parser..."
	@java -jar antlr-4.13.2-complete.jar -Dlanguage=Go -o ./parser SQLv1Antlr4.g4
