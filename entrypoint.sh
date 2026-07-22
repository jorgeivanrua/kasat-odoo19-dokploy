#!/bin/bash
# ==========================================
# FUNDACIÓN KASA T - Entrypoint Odoo 19
# Auto-instalación de módulos sociales
# ==========================================

set -e

# Módulos contables Colombia
L10N_CO="l10n_co_base,l10n_co_cei,l10n_co_dian,l10n_co_reports"

# Módulos sociales y de donaciones
SOCIAL="donation_base,donation_sale,donation_bank_statement"

# Módulos de gestión de beneficiarios (población vulnerable)
BENEFICIARIOS="partner_contact_birthdate,partner_contact_gender,partner_identification"

# Módulos de servicio de campo (visitas jurídicas)
CAMPO="fieldservice,fieldservice_stock,fieldservice_account,fieldservice_project"

# Módulos de proyectos sociales
PROYECTOS="project,project_task,project_milestone,project_stage"

# Módulos de talento humano y voluntarios
VOLUNTARIOS="hr,hr_attendance,hr_expense,hr_recruitment"

# Módulos de reportes e indicadores
REPORTES="mis_builder,mis_builder_budget,report_xlsx,report_qweb"

# Módulos de logística e inventario
LOGISTICA="stock,stock_account,product"

# Módulos de comunicaciones
COMUNICACIONES="mass_mailing,email_template"

# Módulos de conocimiento
CONOCIMIENTO="document_page,document_page_approval"

# Helpdesk para casos jurídicos
HELPDESK="helpdesk_mgmt,helpdesk_mgmt_timesheet"

# Módulos core de Odoo
CORE="crm,sale,purchase,account,analytic,event,website,website_mail"

# ===== UNIR TODO =====
MODULOS="$L10N_CO,$SOCIAL,$BENEFICIARIOS,$CAMPO,$PROYECTOS,$VOLUNTARIOS,$REPORTES,$LOGISTICA,$COMUNICACIONES,$CONOCIMIENTO,$HELPDESK,$CORE"

# Ruta unificada de add-ons
ADDONS_PATH="/mnt/oca/donation,/mnt/oca/partner-contact,/mnt/oca/field-service,/mnt/oca/project,/mnt/oca/hr,/mnt/oca/mis-builder,/mnt/oca/reporting-engine,/mnt/oca/stock-logistics-workflow,/mnt/oca/helpdesk,/mnt/oca/knowledge,/mnt/oca/l10n-colombia,/mnt/oca/account-financial-reporting,/mnt/oca/account-invoicing,/mnt/oca/account-payment,/mnt/oca/account-financial-tools,/mnt/oca/contract,/mnt/oca/product-attribute,/mnt/oca/e-commerce,/mnt/oca/web,/mnt/oca/server-tools,/mnt/oca/server-ux,/mnt/oca/queue,/mnt/extra-addons,/usr/lib/python3/dist-packages/odoo/addons"

# ===== DETECTAR SI ES PRIMER ARRANQUE =====
if [ ! -f /var/lib/odoo/.installed ]; then
    echo "=============================================="
    echo "🚀 FUNDACIÓN KASA T - Primer arranque en Dokploy"
    echo "⚙️  Instalando módulos automáticamente..."
    echo "=============================================="
    echo "📦 Módulos a instalar: $MODULOS"
    echo ""

    # Ejecutar Odoo con -i para instalar todos los módulos
    odoo \
        --db_host=${HOST:-db} \
        --db_user=${USER:-odoo} \
        --db_password=${PASSWORD:-odoo} \
        --database=${ODOO_DB:-fundacion_kasa} \
        --addons-path=$ADDONS_PATH \
        -i $MODULOS \
        --stop-after-init \
        --proxy-mode

    # Marcar como instalado
    touch /var/lib/odoo/.installed
    echo "✅ Módulos instalados correctamente para Fundación Kasa T"
    echo ""
fi

# ===== ARRANQUE NORMAL =====
echo "🚀 Iniciando servidor Odoo Fundación Kasa T..."
exec odoo \
    --db_host=${HOST:-db} \
    --db_user=${USER:-odoo} \
    --db_password=${PASSWORD:-odoo} \
    --database=${ODOO_DB:-fundacion_kasa} \
    --addons-path=$ADDONS_PATH \
    --proxy-mode