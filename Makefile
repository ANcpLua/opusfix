SHELL := /bin/bash
.DEFAULT_GOAL := check
.NOTPARALLEL:
UNION_SOURCE ?= ../nami/.agents/skills/csharp-union-types
UNION_CHECKOUT ?= ../csharp-union-types
UNION := plugins/nami/skills/csharp-union-types
MSTEST := plugins/nami/skills/mstest
.PHONY: check test verify verify-assertions verify-fixtures verify-union update-mstest-api check-mstest-api check-union-sync sync-union

check:
	uv run --frozen python -B scripts/validate.py

test:
	uv run --frozen python -B -m unittest discover -s tests -v
	uv run --frozen python -B -m unittest discover -s $(UNION)/scripts/tests -v

verify: check test verify-assertions verify-fixtures verify-union

verify-assertions:
	uv run --frozen python -B plugins/nami/skills/mstest-assertions/scripts/verify_examples.py

verify-fixtures:
	uv run --frozen python -B scripts/verify.py fixtures

verify-union:
	uv run --frozen python -B scripts/verify.py union

update-mstest-api:
	uv run --frozen python -B $(MSTEST)/scripts/generate_api.py

check-mstest-api:
	uv run --frozen python -B $(MSTEST)/scripts/generate_api.py --check

check-union-sync:
	python3 -B $(UNION_SOURCE)/scripts/sync.py --target $(CURDIR)/$(UNION) --target $(UNION_CHECKOUT)

sync-union:
	python3 -B $(UNION_SOURCE)/scripts/sync.py --target $(CURDIR)/$(UNION) --target $(UNION_CHECKOUT) --apply
