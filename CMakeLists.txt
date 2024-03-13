# Указываем минимальную версию CMake
cmake_minimum_required(VERSION 3.16)

# Название проекта
project(dv_big_int)

option(DV_BIG_INT_BUILD_TESTER "Компилировать Тестер" OFF)
option(DV_BIG_INT_UB_SANITIZER "Детектировать undefined behavior" OFF)

# Версия стандарта C++
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Если используется одноконфигурационный генератор и конфигурация не указана
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
    # то конфигурацией по умолчанию будет Release
    set(CMAKE_BUILD_TYPE Release)
    # Нельзя оставлять переменную CMAKE_BUILD_TYPE пустой (подробности в Dviglo2D)
endif()

# Указываем Студии на то, что исходники в кодировке UTF-8.
# Это позволяет писать U'🍌'. У других компиляторов, похоже, нет с этим проблем
# https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2022/p2295r6.pdf
if(MSVC)
    add_compile_options(/utf-8)
endif()

# Статически линкуем библиотеки, чтобы не копировать dll-ки
if(MINGW)
    add_link_options(-static)
endif()

# Включаем поддержку папок в IDE
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# ============================================== Библиотека ==============================================

# Название таргета
set(target_name dv_big_int)

# Создаём список файлов
file(GLOB source_files lib/*)

# Создаём статическую библиотеку
add_library(${target_name} STATIC ${source_files})

# Делаем заголовочные файлы доступными библиотеке и приложениям
target_include_directories(${target_name} PUBLIC lib)

# Выводим больше предупреждений
if(MSVC)
    target_compile_options(${target_name} PRIVATE /W4)
else() # GCC, Clang или MinGW
    target_compile_options(${target_name} PRIVATE -Wall -Wextra -Wpedantic)

    if(NOT MINGW AND DV_BIG_INT_UB_SANITIZER)
        target_compile_options(${target_name} PRIVATE -fsanitize=undefined)
        # PUBLIC, чтобы не было ошибок при линковке к приложению без опции
        target_link_options(${target_name} PUBLIC -fsanitize=undefined)
    endif()
endif()

# Заставляем VS отображать дерево каталогов
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${source_files})

# ============================================== Тестер ==============================================

if(DV_BIG_INT_BUILD_TESTER)
    # Название таргета
    set(target_name tester)

    # Создаём список файлов
    file(GLOB source_files tester/*)

    # Создаём приложение
    add_executable(${target_name} ${source_files})

    # Подключаем библиотеку
    target_link_libraries(${target_name} PRIVATE dv_big_int)

    # Выводим больше предупреждений
    if(MSVC)
        target_compile_options(${target_name} PRIVATE /W4)
    else() # GCC, Clang или MinGW
        target_compile_options(${target_name} PRIVATE -Wall -Wextra -Wpedantic)

        if(NOT MINGW AND DV_BIG_INT_UB_SANITIZER)
            target_compile_options(${target_name} PRIVATE -fsanitize=undefined)
        endif()
    endif()

    # Отладочная версия приложения будет иметь суффикс _d
    set_property(TARGET ${target_name} PROPERTY DEBUG_POSTFIX _d)

    # Заставляем VS отображать дерево каталогов
    source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${source_files})

    # Включаем тестирование
    enable_testing()

    # Добавляем приложение в список тестируемых
    add_test(NAME ${target_name} COMMAND ${target_name})

    # В Visual Studio таргет будет назначен стартовым вместо ALL_BUILD,
    # чтобы потом не делать это вручную при отладке приложения
    set_property(DIRECTORY ${CMAKE_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${target_name})
endif()