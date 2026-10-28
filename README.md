# tentacle_bind

**One capability bit from GBT V8, packaged standalone.** No. 284 of 341,
`system` domain (System).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 资产↔触手穿透式绑定（主人令 2026-09-26）：每个资产绑定到产生/维护它的触手；bind/unbind/auto/sweep 增删绑定，scan 全量体检（红点只剩「触手断连」一种：资产缺失或触手不在注册表），coverage 报穿透率，一切动作追加写 state/asset_bindings.jsonl 台账（只增不删）

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-tentacle-bind.git
cd gbt-tentacle-bind
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_tentacle_bind info                  # capability card
python -m gbt_tentacle_bind spec --json           # machine-readable contract
python -m gbt_tentacle_bind check --payload '{}'
python -m gbt_tentacle_bind run   --payload '{}'
```

Real `info` output from this machine:

```text
tentacle_bind  (system)  v1.0.0
----------------------------------------
资产↔触手穿透式绑定（主人令 2026-09-26）：每个资产绑定到产生/维护它的触手；bind/unbind/auto/sweep 增删绑定，scan 全量体检（红点只剩「触手断连」一种：资产缺失或触手不在注册表），coverage 报穿透率，一切动作追加写 state/asset_bindings.jsonl 台账（只增不删）

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : bind, unbind, auto, sweep
```

Wire a real implementation:

```python
from gbt_tentacle_bind import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（4 个）**：`bind`、`unbind`、`auto`、`sweep`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `tentacle_bind` |
| domain | `system` |
| handler | `tentacle_bind` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [system/tentacle_bind](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/system/tentacle_bind.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
