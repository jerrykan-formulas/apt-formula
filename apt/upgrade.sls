apt-get-upgrade:
  cmd.wait:
    - name: apt-get upgrade
    - watch:
      - file: /etc/apt/sources.list
      - file: /etc/apt/sources.list.d
