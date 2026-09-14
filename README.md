# Datacrazy - Desafio Técnico Mobile

## Sobre a proposta

Este projeto apresenta a análise e a proposta técnica para evolução
do aplicativo mobile da Datacrazy.

A análise parte do aplicativo atual e, a partir dos problemas e
oportunidades encontrados, propõe uma estratégia de evolução
mantendo React Native como base.

Análise realizada na versão 1.0.95 do aplicativo Android, incluindo o
CRM web e as avaliações públicas nas lojas.

## Documentos

### 1. Análise do aplicativo
[Ver análise](./01-analise-do-aplicativo.pdf)

Análise das principais telas, problemas encontrados, pontos positivos
e oportunidades de melhoria.

### 2. React Native vs Kotlin/Swift
[Ver proposta](./02-proposta-migracao-react-native-nativo.pdf)

Decisão sobre manter React Native, comparação com uma eventual
migração para nativo, riscos, custos e estratégia de execução.

### 3. Kanban mobile
[Ver proposta](./03-kanban-mobile.pdf)

Proposta de adaptação do pipeline Kanban para o contexto mobile,
incluindo interação, movimentação de negócios e performance.

### 4. Multiatendimento
[Ver proposta](./04-multiatendimento.pdf)

Proposta para tornar o multiatendimento mais fluido, com foco em
offline-first, sincronização, fila de envio e notificações.

### 5. Experiências mobile complementares
[Ver proposta](./05-experiencias-mobile.pdf)

Funcionalidades que fazem sentido especificamente no celular,
sem simplesmente reproduzir a experiência web.

### 6. Tarefas e estimativas

[Ver quadro no GitHub Projects](https://github.com/users/gabriel-fh/projects/2)
· [Ver issues](https://github.com/gabriel-fh/datacrazy-desafio-mobile/issues)

Plano de execução dividido em cinco blocos, cada um como um milestone
com o esforço estimado. As issues detalham o conteúdo de cada bloco,
com contexto e critério de aceite.

A granularidade é deliberada. Correções pontuais mapeadas na análise
foram agrupadas em issues de lote, e a estimativa é por bloco e não
por tarefa individual, porque o que sustenta um prazo é o escopo do
conjunto, não a soma de itens pequenos.

As issues foram criadas pelo script em
[`scripts/criar-issues.sh`](./scripts/criar-issues.sh), usando o
GitHub CLI, a partir das tarefas levantadas nos documentos acima.