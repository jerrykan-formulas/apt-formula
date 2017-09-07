apt-get-update:
  cmd.wait:
    - name: apt-get update
    - watch:
      - file: /etc/apt/sources.list
      - file: /etc/apt/sources.list.d
