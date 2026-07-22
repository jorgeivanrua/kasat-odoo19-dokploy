# ==========================================
# FUNDACIÓN KASA T - Dockerfile Odoo 19 Community
# Descarga automatizada de repositorios OCA
# ==========================================
FROM odoo:18.0

USER root

# Instalación de dependencias del sistema y Python necesarias para módulos OCA Colombia y Social
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-pip \
    python3-dev \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    xmlsec1 \
    libffi-dev \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Clonado de repositorios OCA requeridos en /mnt/oca
WORKDIR /mnt/oca

RUN git clone --depth 1 --branch 18.0 https://github.com/OCA/donation.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/partner-contact.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/field-service.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/project.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/hr.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/mis-builder.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/reporting-engine.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/stock-logistics-workflow.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/helpdesk.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/knowledge.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/l10n-colombia.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/account-financial-reporting.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/account-invoicing.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/account-payment.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/account-financial-tools.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/contract.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/product-attribute.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/e-commerce.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/web.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/server-tools.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/server-ux.git && \
    git clone --depth 1 --branch 18.0 https://github.com/OCA/queue-workflow.git queue

# Instalación de librerías Python adicionales requeridas por reporte e integraciones
RUN pip install --no-cache-dir \
    pandas \
    openpyxl \
    num2words \
    pycryptodome \
    xmlsec \
    xlsxwriter

# Copiar configuración y entrypoint
COPY ./entrypoint.sh /entrypoint.sh
COPY ./odoo.conf /etc/odoo/odoo.conf

RUN chmod +x /entrypoint.sh && \
    chown -R odoo:odoo /mnt/oca /var/lib/odoo /etc/odoo

USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]