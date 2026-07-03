# CLAUDE.md

Guia para o Claude Code trabalhar neste repositório.

## O que é

**The Ladyhawkes — Content Factory**: app local de arquivo único que gera todo o
conteúdo textual de músicas/clipes de uma banda fictícia de hard rock/AOR anos 80.
Fluxo: **app gera textos → Suno (música) → Flow (imagens/vídeo) → CapCut (edição, manual)**.

## Como rodar

Dois cliques em `INICIAR-APP.bat` (ou `python -m http.server 8081` na pasta).
Abre em `http://localhost:8081/`. Precisa de uma chave da API Anthropic colada na UI
(fica só no `localStorage`). Não há build, testes nem dependências.

## Estrutura

- `index.html` — TODO o app (HTML + CSS + JS puro, ~1000 linhas). Sem framework.
- `config/band-members.json` — 5 integrantes (Roxy, Valerie, Jade, Nikki): descrição
  visual, `flow_portrait`, `stage_behavior`.
- `config/track-types.json` — 3 tipos de faixa (Power Ballad, Arena Anthem, Sleaze Rock):
  `suno_style`, `scene_suffix`, `negative_prompt`, `lyric_themes`, `bpm_range`, `mood`.
- `INICIAR-APP.bat` — sobe o servidor local e abre o navegador.

Cada JSON tem um **fallback embutido** no JS (`BAND_FALLBACK`, `TRACK_TYPES_FALLBACK`),
então o app funciona mesmo se o fetch falhar. Ao mudar um JSON, atualize também o fallback.

## Arquitetura do JS (dentro de index.html)

- `GENERATORS` (~linha 352): array de geradores `{id,label,sub,dependsOn,system,user,clean,
  compute,memberInject}`. Para adicionar um gerador, inclua um objeto aqui e mapeie a aba
  em `TAB_OF` (~345).
- `TABS` / `TAB_OF` (~339): abas SUNO / LETRA PT / YOUTUBE / FLOW.
- `generateAll` (~705): roda os geradores como **DAG** respeitando `dependsOn`.
- `runOne` (~671): executa um gerador; injeta `GUARDRAILS` e (se `memberInject`) `BAND_REFS`.
- `callAnthropic` (~641): fetch direto para a API (`claude-sonnet-5`, `max_tokens:8192`).
- `regenOne` (~730): regenera um card isolado.
- Cards: `cardMarkup`/`buildCards`/`renderCard` (~802–853); ações por `data-action`
  ("regen"/"copy"/"retry").
- Fila (`queue`, ~892), Archive (localStorage), `exportTxt` (~868).

## Convenções

- **Guardrails** (`GUARDRAILS`, ~317) valem para toda saída: inglês apenas, sem nudez,
  sem tecnologia moderna (mantém estética anos 80), sem citar artistas reais, sem Markdown.
  Exceção: geradores que precisam de PT-BR (ex.: `lyricsPt`) sobrescrevem no próprio `system`.
- Prompts de imagem do Flow usam refs `[Roxy]/[Valerie]/[Jade]/[Nikki]` (ações, nunca
  redescrever aparência; máx 3 por linha) e terminam com o `scene_suffix` do tipo de faixa.
- JS em estilo ES5 (var, sem arrow onde o arquivo não usa). Mantenha o padrão do arquivo.
- Sem processo de build: edite `index.html` e recarregue o navegador.

## Repositório GitHub / versionamento

Este projeto é versionado num repositório **privado** na conta GitHub do dono
(`alimafm7212@gmail.com`). O repo é privado de propósito: mesmo sem chaves no código,
o app não deve ser hospedado publicamente (ver Notas/cuidados).

**Regra: a cada atualização do projeto, atualize o repositório.** Depois de qualquer
mudança em arquivos versionados (`index.html`, `config/*.json`, `CLAUDE.md`,
`INICIAR-APP.bat`, etc.), faça commit e push:

```bash
git add -A
git commit -m "<descrição curta e clara da mudança>"
git push
```

Convenções de commit:
- Mensagem no imperativo, curta, descrevendo o **quê** e o **porquê** (ex.:
  `Adiciona gerador de thumbnail do YouTube`, `Ajusta scene_suffix da Power Ballad`).
- Um commit por mudança lógica; não acumule alterações não relacionadas.
- Nunca versione a chave da API nem arquivos `.env`/`*.key` (já cobertos pelo `.gitignore`).

Se o push falhar por falta de autenticação, o dono precisa rodar `gh auth login`
(ou configurar um token) — a autenticação é interativa e não pode ser feita pelo Claude.

## Notas / cuidados

- A chave da API fica exposta no navegador (`anthropic-dangerous-direct-browser-access`).
  Uso local pessoal apenas — nunca hospedar este HTML publicamente.
- O Archive vive só no `localStorage`: limpar o cache apaga o histórico (sem backup).
- A etapa do CapCut é manual e está fora de escopo do app.
