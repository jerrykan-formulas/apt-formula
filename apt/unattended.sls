# This is the main state file for configuring unattended upgrades with apt
{% from "apt/map.jinja" import apt as apt_map with context %}

{%- set distro_release = salt['grains.get']('osmajorrelease')|string -%}
{%- set default_unattended_config_template = {
    '8': 'salt://apt/templates/unattended_config.jinja',
    '9': 'salt://apt/templates/unattended_config.jinja',
    '10': 'salt://apt/templates/debian10/unattended_config.jinja',
}.get(distro_release, '10') -%}

{% set apt = pillar.get('apt:unattended', {}) -%}
{% set unattended_config_template = apt.get('unattended_config_template', default_unattended_config_template) -%}
{% set periodic_config_template = apt.get('periodic_config_template', 'salt://apt/templates/periodic_config.jinja') -%}

apt_unattended_pkgs:
  pkg.installed:
    - pkgs:
      {% for pkg in apt_map.pkgs %}
      - {{ pkg }}
      {% endfor %}

{{ apt_map.confd_dir }}/{{ apt_map.unattended_config }}:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: {{ unattended_config_template }}

{{ apt_map.confd_dir }}/{{ apt_map.periodic_config }}:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: {{ periodic_config_template }}
