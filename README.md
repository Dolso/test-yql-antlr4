Чтобы сгенерировать файлы для парсера, нужно выполнить команду make. Для этого должен быть установлен java jdk

Проблемы:
1. Скорее всего работает только на mac
2. Логика экранирования и заменые подстрок в файле может быть неочевидна
3. Не был учтен https://github.com/OrlovPavel/ydb/blob/70e6c9cd4284bcb65946a8a24c5beeed658b021f/ydb/library/yql/parser/proto_ast/gen/v1_proto_split_antlr4/epilogue.cmake
4. т.д.