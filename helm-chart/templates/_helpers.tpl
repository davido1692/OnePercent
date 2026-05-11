{{- define "hello-app.name" -}}
hello-app
{{- end }}

{{- define "hello-app.blue.fullname" -}}
hello-app-blue
{{- end }}

{{- define "hello-app.green.fullname" -}}
hello-app-green
{{- end }}

{{- define "hello-app.labels" -}}
app: hello-app
managed-by: helm
{{- end }}
