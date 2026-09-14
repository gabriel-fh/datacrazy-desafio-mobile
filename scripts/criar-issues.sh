#!/usr/bin/env bash
# Cria os milestones, as labels e as issues do plano de execução
# do desafio mobile da Datacrazy, a partir das tarefas levantadas
# nos documentos da raiz do repositório.
#
# Requisitos: GitHub CLI autenticado (gh auth login) e repositório criado.
#
# Uso:
#   export REPO="gabriel-fh/datacrazy-desafio-mobile"
#   bash criar-issues.sh
#
# Se o Project estiver configurado para adicionar issues automaticamente,
# nada mais é necessário. Caso contrário, defina PROJETO com o nome exato
# do quadro antes de rodar, e garanta o escopo de projeto na autenticação:
#   gh auth refresh -s project,read:project

set -euo pipefail
: "${REPO:?defina REPO=usuario/repositorio}"
PROJETO="${PROJETO:-}"

echo "Criando milestones..."
gh api repos/$REPO/milestones -f title="Fase 1 - Estabilizacao" -f description="Esforco estimado: 4 a 6 semanas/dev." >/dev/null 2>&1 || echo "  ja existe: Fase 1 - Estabilizacao"
gh api repos/$REPO/milestones -f title="Fase 2 - Pipeline Kanban" -f description="Esforco estimado: 3 a 4 semanas/dev." >/dev/null 2>&1 || echo "  ja existe: Fase 2 - Pipeline Kanban"
gh api repos/$REPO/milestones -f title="Fase 3 - Multiatendimento offline-first" -f description="Esforco estimado: 8 a 10 semanas/dev." >/dev/null 2>&1 || echo "  ja existe: Fase 3 - Multiatendimento offline-first"
gh api repos/$REPO/milestones -f title="Fase 4 - Refinamento e recursos de dispositivo" -f description="Esforco estimado: 4 a 6 semanas/dev." >/dev/null 2>&1 || echo "  ja existe: Fase 4 - Refinamento e recursos de dispositivo"
gh api repos/$REPO/milestones -f title="Fase 5 - QA e publicacao" -f description="Esforco estimado: cerca de 2 semanas." >/dev/null 2>&1 || echo "  ja existe: Fase 5 - QA e publicacao"

echo "Criando labels..."
gh label create "bug" --repo $REPO --color d73a4a >/dev/null 2>&1 || true
gh label create "feature" --repo $REPO --color 0366d6 >/dev/null 2>&1 || true
gh label create "chore" --repo $REPO --color 595959 >/dev/null 2>&1 || true
gh label create "spike" --repo $REPO --color 7030a0 >/dev/null 2>&1 || true
gh label create "prioridade:alta" --repo $REPO --color d93f0b >/dev/null 2>&1 || true
gh label create "prioridade:media" --repo $REPO --color fbca04 >/dev/null 2>&1 || true
gh label create "prioridade:baixa" --repo $REPO --color 0e8a16 >/dev/null 2>&1 || true

echo "Criando issues..."
gh issue create --repo $REPO \
  --title "DC-01 Decidir adocao de Expo Modules e auditar dependencias" \
  --body "## Contexto
Investigacao com prazo fixo. O compartilhamento de contato previsto no roadmap nao tem alternativa bare em manutencao ativa, e o ecossistema Expo tambem reduz o custo de notificacao e persistencia local. Levantar tambem as versoes atuais de reanimated, gesture-handler e pager-view, ja que o Reanimated 4 exige react-native-worklets e nao convive com o 3.

## Criterio de aceite
Decisao registrada com justificativa, impacto no build e lista de bibliotecas definida para as fases seguintes.

**Bloco:** Fase 1 - Estabilizacao  
**Esforco do bloco:** 4 a 6 semanas/dev" \
  --label "spike,prioridade:alta" \
  --milestone "Fase 1 - Estabilizacao" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-02 Tratamento de erro de API e comportamento com plano expirado" \
  --body "## Contexto
Hoje cada tela trata erro de forma diferente, ou nao trata. Em alguns fluxos o usuario recebe o stack trace completo, com codigo, endpoint e payload. Em outros, a acao falha em silencio. O modal de criar negocio chega a ficar preso em carregamento sem timeout nem opcao de fechar. O caso do plano expirado concentra os dois comportamentos: criar negocio e trocar tag falham com erro cru, editar nota, perfil e endereco falham sem mensagem, e adicionar campo adicional funciona normalmente. O site ainda avisa que o plano esta proximo de expirar, enquanto o aplicativo nao avisa em lugar nenhum.

## Criterio de aceite
Interceptor unico normalizando erro de rede, de negocio e inesperado, com timeout e caminho de recuperacao. Nenhuma tela exibe codigo bruto, e o log tecnico fica disponivel apenas por acao de reportar erro. Toda acao bloqueada por plano informa o motivo, e o aviso de expiracao aparece antes do bloqueio acontecer.

**Bloco:** Fase 1 - Estabilizacao  
**Esforco do bloco:** 4 a 6 semanas/dev" \
  --label "bug,prioridade:alta" \
  --milestone "Fase 1 - Estabilizacao" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-03 Corrigir invalidacao de sessao e logout automatico" \
  --body "## Contexto
Apos redefinir a senha, o app detecta a sessao expirada mas trava: home duplicada em abas, graficos vazios e mensagem solta no perfil. Nao desloga sozinho. Ha tambem relato publico de falha de login sem detalhes, que pode ser o mesmo problema visto de outro angulo.

## Criterio de aceite
Sessao invalida desloga automaticamente e limpa o estado, sem tela em estado inconsistente. Token de push invalidado junto.

**Bloco:** Fase 1 - Estabilizacao  
**Esforco do bloco:** 4 a 6 semanas/dev" \
  --label "bug,prioridade:alta" \
  --milestone "Fase 1 - Estabilizacao" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-04 Investigacao com backend: rotas, fuso horario e divergencia entre app e web" \
  --body "## Contexto
Tres sintomas possivelmente relacionados. O log mostra o app tentando uma sequencia de endpoints ate falhar em quase todos. O relogio esta adiantado entre uma e duas horas, com atividade criada as 22h registrada no dia seguinte. E ha dados que aparecem no web e nao no app para o mesmo periodo, como produtos com mais negocios, contador das abas de conversas e mensagens rapidas incompletas.

## Criterio de aceite
Causa raiz identificada para cada sintoma, com as correcoes abertas no lado correto. E pre-requisito do Kanban e do multiatendimento.

**Bloco:** Fase 1 - Estabilizacao  
**Esforco do bloco:** 4 a 6 semanas/dev" \
  --label "spike,prioridade:alta" \
  --milestone "Fase 1 - Estabilizacao" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-05 Correcoes de interface e revisao de i18n mapeadas na analise" \
  --body "## Contexto
Lote com os achados de menor esforco: bottom sheet do filtro de periodo que nao fecha ao tocar fora, tema que volta sozinho para claro ao retornar do background, tela Mais opcoes duplicada, alert bloqueante ao criar negocio, metricas do lead fechadas por padrao, empresa vinculada com seta sem navegacao, feedback ausente ao trocar atendente e ao salvar nota, links de termos e privacidade. Inclui tambem a revisao de i18n, com componentes de texto fixo e a camada de suporte, que nao acompanha o idioma do app.

## Criterio de aceite
Achados corrigidos e app sem trechos em portugues quando configurado em outro idioma.

**Bloco:** Fase 1 - Estabilizacao  
**Esforco do bloco:** 4 a 6 semanas/dev" \
  --label "bug,prioridade:media" \
  --milestone "Fase 1 - Estabilizacao" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-06 Tela de pipeline com navegacao por pager entre colunas" \
  --body "## Contexto
Uma coluna por vez ocupando a largura da tela, navegavel por swipe, com react-native-pager-view. Colunas renderizadas dinamicamente a partir da estrutura que a API ja entrega ao web, sem assumir numero fixo de etapas. Indicador no topo mostrando a etapa atual. O ponto de maior risco e o conflito entre o swipe horizontal do pager e o scroll vertical da lista, resolvido pelo eixo dominante do movimento.

## Criterio de aceite
Navegacao entre etapas validada em aparelho real Android e iOS, sem gesto ambiguo. Estados vazio e de erro visualmente distintos entre si.

**Bloco:** Fase 2 - Pipeline Kanban  
**Esforco do bloco:** 3 a 4 semanas/dev" \
  --label "feature,prioridade:alta" \
  --milestone "Fase 2 - Pipeline Kanban" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-07 Movimentacao de negocio entre etapas" \
  --body "## Contexto
Card com nome do lead, valor e atendente, memoizado e com props estaveis; produto e tags ficam na tela de detalhe. A acao de mover tem duas formas de acesso, botao de menu visivel no card e toque longo como atalho, ambos abrindo um bottom sheet com as etapas da pipeline. A analise encontrou acoes uteis escondidas atras de gestos sem indicacao visual, e o kanban nao deve repetir esse padrao. A atualizacao e otimista: o card muda de coluna imediatamente e a requisicao segue em paralelo; em caso de falha volta a posicao original com aviso legivel. Identificador unico por tentativa evita que uma retentativa em conexao instavel gere uma segunda movimentacao.

## Criterio de aceite
Acao de mover descobrivel sem depender de gesto escondido. Falha exibe motivo em linguagem de usuario, nunca codigo bruto, e retentativa nao duplica movimentacao.

**Bloco:** Fase 2 - Pipeline Kanban  
**Esforco do bloco:** 3 a 4 semanas/dev" \
  --label "feature,prioridade:alta" \
  --milestone "Fase 2 - Pipeline Kanban" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-08 Reordenacao de cards dentro da coluna" \
  --body "## Contexto
Gesto contido na area visivel, entao arrastar e soltar cabe na primeira versao. A escolha de biblioteca exige validacao: react-native-draggable-flatlist esta ha cerca de dois anos sem publicacao e tem historico de quebrar a cada major do Reanimated, hoje na 4.x. A avaliacao recai sobre react-native-reanimated-dnd, com react-native-draglist como alternativa sem dependencia de Reanimated.

## Criterio de aceite
Biblioteca validada na versao atual do projeto antes de fechar a dependencia. Reordenacao persiste e nao conflita com o gesto do pager.

**Bloco:** Fase 2 - Pipeline Kanban  
**Esforco do bloco:** 3 a 4 semanas/dev" \
  --label "feature,prioridade:media" \
  --milestone "Fase 2 - Pipeline Kanban" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-09 Validacoes antes de iniciar a arquitetura offline" \
  --body "## Contexto
Duas verificacoes com prazo fixo, antes de comprometer a camada mais cara da proposta. A primeira e o WatermelonDB, que resolve observabilidade reativa, carregamento preguicoso e protocolo de sincronizacao, mas esta ha cerca de um ano sem publicacao e tem relatos de atrito com a Nova Arquitetura em versoes recentes do React Native. A segunda e o contrato de sincronizacao: a arquitetura pressupoe que a API saiba responder o equivalente a o que mudou desde X, com numero de sequencia incremental por conversa, e se hoje o backend so devolve listagem completa paginada isso precisa ser negociado. E o maior risco de bloqueio externo da fase.

## Criterio de aceite
POC de dois a tres dias com esquema criado, milhares de registros gravados e lidos, observabilidade funcionando com Fabric e ciclo de sincronizacao simulado. Se falhar, plano B e SQLite direto com repositorio proprio, com custo adicional de uma a duas semanas. Contrato de sincronizacao acordado e documentado com o time de backend.

**Bloco:** Fase 3 - Multiatendimento offline-first  
**Esforco do bloco:** 8 a 10 semanas/dev" \
  --label "spike,prioridade:alta" \
  --milestone "Fase 3 - Multiatendimento offline-first" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-10 Banco local: esquema e camada de repositorio" \
  --body "## Contexto
Conversas, mensagens, fila de envio pendente, catalogo de mensagens rapidas e estado de automacao por conversa, em SQLite. Todo acesso passa por um repositorio proprio, para que uma troca futura de mecanismo de persistencia nao se espalhe pelo codigo. E o que torna a decisao do spike reversivel.

## Criterio de aceite
Esquema versionado com migracao testada. Nenhum componente de tela importa a biblioteca de banco diretamente.

**Bloco:** Fase 3 - Multiatendimento offline-first  
**Esforco do bloco:** 8 a 10 semanas/dev" \
  --label "feature,prioridade:alta" \
  --milestone "Fase 3 - Multiatendimento offline-first" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-11 Tela de conversa em tela cheia com renderizacao reativa" \
  --body "## Contexto
A conversa ocupa a tela inteira, no padrao de apps de mensagem, e o cabecalho leva a tela de detalhe do lead que ja existe. A interface renderiza a partir do banco local, nunca diretamente de evento de rede. Badge de negocios vinculados no cabecalho e identificacao visual distinta para mensagem de automacao.

## Criterio de aceite
Mensagem gravada no banco aparece na tela sem recarregamento explicito. Atendente distingue mensagem humana de automatizada.

**Bloco:** Fase 3 - Multiatendimento offline-first  
**Esforco do bloco:** 8 a 10 semanas/dev" \
  --label "feature,prioridade:alta" \
  --milestone "Fase 3 - Multiatendimento offline-first" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-12 Fila de envio com idempotencia e falha visivel" \
  --body "## Contexto
Outbox transacional no banco, nao em store em memoria, para sobreviver a fechamento abrupto no meio de um envio. Cada mensagem recebe identificador gerado no dispositivo, enviado ao servidor, para que retentativa nao gere duplicata. Estados pendente, enviado, entregue e falha.

## Criterio de aceite
App fechado a forca durante envio retoma a fila ao reabrir sem perder nem duplicar mensagem. Mensagem que esgota tentativas aparece como falha no balao, com acao de tentar novamente.

**Bloco:** Fase 3 - Multiatendimento offline-first  
**Esforco do bloco:** 8 a 10 semanas/dev" \
  --label "feature,prioridade:alta" \
  --milestone "Fase 3 - Multiatendimento offline-first" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-13 Sincronizacao incremental e canal de tempo real" \
  --body "## Contexto
Ao abrir, a tela exibe o que esta salvo localmente e busca em paralelo so o que mudou desde a ultima sincronizacao, usando o numero de sequencia como referencia. netinfo aciona a mesma rotina quando a conexao volta. Com o app aberto, o canal de tempo real mantem as mensagens chegando sem polling. Ordenacao pela sequencia do servidor, nao pelo timestamp, que e afetado pelo problema de fuso ja documentado.

## Criterio de aceite
App abre instantaneo sem rede. Volta de conexao sincroniza sem acao manual. Ordem correta com mensagens quase simultaneas.

**Bloco:** Fase 3 - Multiatendimento offline-first  
**Esforco do bloco:** 8 a 10 semanas/dev" \
  --label "feature,prioridade:alta" \
  --milestone "Fase 3 - Multiatendimento offline-first" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-14 Notificacao push de mensagem com abertura na conversa" \
  --body "## Contexto
Hoje as preferencias do app mostram notificacoes como recurso ainda nao ativo, ou seja, a funcionalidade que mais justifica a existencia do aplicativo nao esta no ar. Recebimento por @react-native-firebase/messaging integrado ao FCM, com exibicao por react-native-notify-kit na base bare ou expo-notifications no cenario com Expo Modules.

## Criterio de aceite
Push recebido com app fechado, e o toque abre a conversa correta via deep link. Permissao tratada no Android 13 ou superior e no iOS. Token registrado por usuario e invalidado no logout.

**Bloco:** Fase 3 - Multiatendimento offline-first  
**Esforco do bloco:** 8 a 10 semanas/dev" \
  --label "feature,prioridade:alta" \
  --milestone "Fase 3 - Multiatendimento offline-first" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-15 Anexos, mensagens rapidas e automacao como extensoes da mesma arquitetura" \
  --body "## Contexto
Tres recursos que se apoiam no banco local e na fila ja construidos. Anexo quebra premissas da fila de texto: o outbox guarda o caminho local, o arquivo precisa ser copiado para um diretorio proprio do app porque o caminho da galeria pode deixar de existir, o upload falha no meio com mais frequencia e precisa de progresso visivel e politica de consumo em rede movel. O catalogo de mensagens rapidas vive no banco local, com busca local e insercao no campo de digitacao em vez de envio direto, funcionando offline. O controle de automacao fica deliberadamente enxuto: disparar uma automacao existente, ver que esta em curso e interrompe-la, enquanto criar e editar continuam na web.

## Criterio de aceite
Upload exibe progresso, sobrevive a fechamento do app e nao duplica anexo em retentativa, com arquivos temporarios removidos apos confirmacao. Catalogo de mensagens rapidas disponivel offline. Atendente consegue assumir manualmente uma conversa em automacao pelo celular.

**Bloco:** Fase 3 - Multiatendimento offline-first  
**Esforco do bloco:** 8 a 10 semanas/dev" \
  --label "feature,prioridade:media" \
  --milestone "Fase 3 - Multiatendimento offline-first" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-16 Reduzir sobrecarga do dashboard e do detalhe do lead" \
  --body "## Contexto
No dashboard, trocar o grafico de linha por indicador compacto de tendencia, padronizar quantidade junto com valor em reais e adicionar contador de atividades pendentes no icone da agenda. No detalhe do lead, mover perfil, endereco, negocios vinculados e historico para telas proprias, em vez de expandir inline na mesma rolagem. A tela de dados pessoais do perfil ja serve de referencia do padrao desejado.

## Criterio de aceite
Dashboard legivel em uma passada de olho. Tela de detalhe do lead sem empilhar edicao, negocios e historico na mesma rolagem.

**Bloco:** Fase 4 - Refinamento e recursos de dispositivo  
**Esforco do bloco:** 4 a 6 semanas/dev" \
  --label "chore,prioridade:media" \
  --milestone "Fase 4 - Refinamento e recursos de dispositivo" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-17 Tela de visibilidade de plano, somente leitura" \
  --body "## Contexto
Plano atual, status, data de renovacao ou expiracao e limites de uso. Somente leitura: contratacao e upgrade seguem na web, por causa da diretriz 3.1.1 da Apple sobre compra dentro do aplicativo. Exibir informacao de plano nao entra nessa discussao, porque e dado e nao transacao.

## Criterio de aceite
Usuario consulta a situacao do plano pelo app. Nenhum fluxo de pagamento dentro do aplicativo.

**Bloco:** Fase 4 - Refinamento e recursos de dispositivo  
**Esforco do bloco:** 4 a 6 semanas/dev" \
  --label "feature,prioridade:alta" \
  --milestone "Fase 4 - Refinamento e recursos de dispositivo" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-18 Recursos exclusivos do dispositivo no fluxo de lead" \
  --body "## Contexto
Tres capacidades que a web nao substitui. Na tela de detalhe do lead, transformar telefone e email em acoes diretas de ligar, abrir WhatsApp e enviar email com o Linking do core, mantendo copiar como opcao secundaria e preservando abrir chat como acao primaria, ja que ele registra o atendimento no CRM. Agendar notificacao local para atividades com horario definido, que dispara sem rede e com o app fechado. E criar lead a partir do compartilhamento de contato do sistema, com intent-filter aceitando ACTION_SEND no Android e Share Extension com App Group no iOS, unico ponto de trabalho nativo relevante do roadmap. O escopo do compartilhamento e estreito de proposito: apenas contato, nao conversa nem texto solto.

## Criterio de aceite
Numero normalizado antes de montar o link do WhatsApp. Lembrete cancelado e recriado ao remarcar, removido ao concluir, respeitando o limite de 64 notificacoes pendentes do iOS. Datacrazy aparece na folha de compartilhamento das duas plataformas, com formulario pre-preenchido a partir do vCard e aviso de telefone ja cadastrado.

**Bloco:** Fase 4 - Refinamento e recursos de dispositivo  
**Esforco do bloco:** 4 a 6 semanas/dev" \
  --label "feature,prioridade:media" \
  --milestone "Fase 4 - Refinamento e recursos de dispositivo" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-19 QA em aparelhos reais, incluindo cenarios offline" \
  --body "## Contexto
Teste em aparelho Android de entrada e em fabricantes com otimizacao agressiva de bateria, que pode atrasar a entrega de push. No iOS, validar Share Extension, permissoes e comportamento em background. Cenarios de rede: modo aviao durante envio, fechamento abrupto com fila pendente, periodo longo offline seguido de sincronizacao e anexo interrompido. Medir rolagem do kanban e da conversa com volume realista antes de decidir sobre FlashList.

## Criterio de aceite
Roteiro executado nas duas plataformas, sem mensagem perdida ou duplicada nos cenarios de rede. Decisao sobre FlashList tomada com base em medicao.

**Bloco:** Fase 5 - QA e publicacao  
**Esforco do bloco:** cerca de 2 semanas" \
  --label "chore,prioridade:alta" \
  --milestone "Fase 5 - QA e publicacao" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1
gh issue create --repo $REPO \
  --title "DC-20 Build de producao e submissao nas lojas" \
  --body "## Contexto
Assinatura, variaveis de ambiente e verificacao de que nenhum log tecnico e exposto ao usuario final em producao. Preparar ficha, capturas e notas de versao. Atencao a revisao da Apple no ponto de plano, garantindo que nao ha fluxo de pagamento dentro do aplicativo.

## Criterio de aceite
Versao publicada nas duas lojas.

**Bloco:** Fase 5 - QA e publicacao  
**Esforco do bloco:** cerca de 2 semanas" \
  --label "chore,prioridade:alta" \
  --milestone "Fase 5 - QA e publicacao" $( [ -n "$PROJETO" ] && echo --project "$PROJETO" )
sleep 1

echo "Concluido."
