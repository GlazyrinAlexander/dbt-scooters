# dbt_scooters

## Описание проекта

Проект на базе dbt, предназначенный для управления и трансформации данных,
связанных с использованием скутеров кикшеринга.
Позволяет выстроить аналитику данных о передвижениях и использовании скутеров.

## Стек

- **Python** 3.12, **uv** (менеджер зависимостей и окружений)
- **dbt-core** 1.10 + **dbt-postgres**
- **PostgreSQL** 16 (в Docker-контейнере)

## Быстрый старт

```bash
# 1. Клонировать репозиторий
git clone https://github.com/GlazyrinAlexander/dbt-scooters.git
cd dbt-scooters

# 2. Установить uv (если ещё нет)
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

# 3. Поднять окружение из lock-файла
uv sync

# 4. Настроить подключение (копировать и заполнить)
cp profiles.yml.example ~/.dbt/profiles.yml

# 5. Проверить соединение
uv run dbt debug

# 6. Построить модели
uv run dbt build
```

## Структура

```
dbt_scooters/
├── models/
│   ├── staging/      # очистка и приведение типов из raw
│   └── marts/        # бизнес-витрины (факты + измерения)
├── macros/           # переиспользуемые SQL-макросы
├── seeds/            # справочники (CSV → таблицы)
├── tests/            # кастомные SQL-тесты
├── snapshots/        # SCD Type 2 (история изменений)
├── pyproject.toml    # зависимости Python
├── uv.lock           # зафиксированные версии
└── .venv/            # виртуальное окружение (в gitignore)
```

## Шпаргалка команд dbt

Все команды запускаются через `uv run dbt`:

| Команда | Назначение |
|---|---|
| `dbt debug` | Проверить подключение к БД и конфигурацию |
| `dbt run` | Построить модели (создать таблицы/вьюхи) |
| `dbt build` | Полный цикл: seed + run + test + snapshot |
| `dbt test` | Запустить проверки целостности данных |
| `dbt seed` | Загрузить CSV из `seeds/` в БД |
| `dbt compile` | Скомпилировать модели без выполнения |
| `dbt show --inline "select 1"` | Выполнить SQL и показать результат |
| `dbt snapshot` | Обновить исторические снапшоты |
| `dbt docs generate` | Сгенерировать документацию |
| `dbt docs serve` | Открыть документацию в браузере |
| `dbt clean` | Удалить `target/` и `dbt_packages/` |

## Селекторы моделей

```bash
uv run dbt run --select my_model              # одна модель
uv run dbt run --select +my_model             # модель и её upstream (родители)
uv run dbt run --select my_model+             # модель и её downstream (дети)
uv run dbt run --select +my_model+            # вся цепочка
uv run dbt run --select tag:daily             # по тегу
uv run dbt run --select staging.marts         # вся папка staging
uv run dbt run --exclude tag:deprecated       # исключить
uv run dbt run --select state:modified+       # только изменённые (+ downstream)
```

## Работа с окружением

```bash
uv add dbt-bigquery         # добавить адаптер
uv lock --upgrade-package dbt-core   # обновить пакет
uv sync                      # синхронизировать окружение по uv.lock
uv tree                        # дерево зависимостей
uv pip list                    # установленные пакеты
```

## Схемы PostgreSQL

| Схема | Назначение | Кто пишет |
|---|---|---|
| `raw` | Сырые данные из источников | загрузчик (Python) |
| `staging` | Очищенные данные, приведение типов | dbt (view) |
| `marts` | Бизнес-витрины | dbt (table) |

## Подключение к БД

Контейнер: `dbt-course-postgres`  
Host: `localhost`, Port: `4001`, User: `postgres`, DB: `scooters`

## Полезные ссылки

- [dbt Docs](https://docs.getdbt.com)
- [dbt Postgres adapter](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)
- [uv Docs](https://docs.astral.sh/uv/)

---

*Воспроизводимость: `uv.lock` фиксирует все транзитивные зависимости. На любой машине `uv sync` даёт идентичное окружение.*