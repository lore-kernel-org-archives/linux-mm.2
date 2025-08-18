Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3480CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C308E0038; Mon, 18 Aug 2025 08:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643AD8E0003; Mon, 18 Aug 2025 08:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532B48E0038; Mon, 18 Aug 2025 08:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 412008E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C2AB1DDCB0
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:04 +0000 (UTC)
X-FDA: 83789805288.04.4B9C939
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 29709180006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vd1g96Np;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uV2EcOLOEi9NHEaGyWV+jW00E8CTJandeHN7WdmrP2U=;
	b=Qgybej+GKnxHBJFTgpvNmcSLnLJr20vGBL5gP1M5IQ8U+GZPxhOG0ZDzArD0P2MNJB2CkY
	HPo7TI44WiuTJHPHO2trEuOOi/7kUZ8FML4kyQ80P9i0YfhqtkoKD3q9vPy7iJ94ORB94Z
	e1ac+iBGmukeZU+3SzXGQy5WDm4nMeg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520081; a=rsa-sha256;
	cv=none;
	b=Syr2YGla0uH1yulSGB9FR99hTEIzaGt50Pqg+s7GQPj23iMtNQJ/EPRL3AEr3lttKwJ1zs
	tlGAD6li7mfcdkfcXBz95eXzVBYrJyjA1bH6LvHzoVzWIcYze1zlUoomlcCSDuks3cEQgp
	XX9H6+fLdbv91e72S9hwRitq0fu4ILs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vd1g96Np;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b4717330f9eso2838458a12.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520080; x=1756124880; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uV2EcOLOEi9NHEaGyWV+jW00E8CTJandeHN7WdmrP2U=;
        b=Vd1g96NpTRfw1q/zbNSf7GxVy81mQ/29bG0xPMvUvlvMMrBaaJwjV8kPUjMhkBdbOp
         gZbxb466c7q/+nxcWRKnm0hAuwRUJlMx53gTSzBlj//N9fbjcwMXmMpQ/2iUWFnjrRc7
         XOn55vOzDTR18nQuivPgn3vglps+yo9JjbVT+6R1ijMpv8FnVs6cKNZB17MjHKdA7ceM
         mO6ErHQJ3S5skHf/5wdhY8JVcDRrMMPjzlF6mHTC11qLi7/+lG7MOQpiDql8V/4XKkss
         BPx8EUUM+W22ZqtzG5A5xNasIWoMCtv/V2r35mtM17qW6k9XX0dNctU7Oz1IjjWJ3mt1
         O9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520080; x=1756124880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uV2EcOLOEi9NHEaGyWV+jW00E8CTJandeHN7WdmrP2U=;
        b=Ei8eefoBVqF7tfvr1Woo7MRJCt5YF5JbeaTZb2Qm2XzaG+lX2gFpWEeNna9qW9Dd+U
         ZvMJDAHMFvcmjHa652EGdDyenfFxAOIpjTdZn4d28eHbKL7NxmcTSWzVBA8W9F2f5bZB
         V0rzxfBcg4B9VVB5BZAtq0OkJxk2CMWFcraUd83OlBNdyK2Pn62x7z+u5u3Mw2ZtJnZZ
         ApvFyj0laJNqvBExaAWaxeRSHr+ukcDeVOwpOnDBBN+wokmVYqVESvz/rVlNcey174Xj
         ZOakpr8M+J/jC/scIpKVm7kxI5GQJoHQ3s/+EjGbqQOOUWgGTvT7LKFnNtT/SlQI/fJB
         LvDA==
X-Forwarded-Encrypted: i=1; AJvYcCUMbPVDmvksajid7S58KCsilpNFsZ2hALX9LA3/F3pEhM4ZkInaBdKCkt3C/5VvooMoJJ0zFDuyuw==@kvack.org
X-Gm-Message-State: AOJu0Yy6+EcjUByaaz18S2D+0TdAepl7HJm7I7XEqiXFSJb5s/1i+DJu
	xiN+LL+I+2TzX4aiv5q/Bx6Y/c5KCOl4pYLodK8ldXmerDbh4m0Amekh
X-Gm-Gg: ASbGncvnXX3fApiVzSYeqB+HSLQ5zzZ4/6GgVNf7qcSX9UGKsC075p42uDY8bVv9Un5
	f1pgBDBqYniSAchkBZQrlkVBPeRniZmHwAQdZb++27bklFOV7Gp1SmeVf8GV7UW0Xx/pIqOOLDa
	IDxJzMzXLhPn5zZMhAR21vmQJQPLrjChdpk0Gu8tcMNreiRxhVYMoXzjzJGRhIOtA1n72TR62hy
	RowU74fBP9v/2vqis8I64hbgr1HgYhf6H1q8mnkUB3b/kl/uMhSO42PgUj9ZcNHPYM4VI0hGCB9
	lJuo0plKSQ6WqvbZ2STAgZ06W7zkKsIe2RBHxV7RnhMzJIDRTumvDlfohlWHfEO8rykZxItd6Op
	zwILTC+nmfymS/v/ewYvhGPcY3bzf
X-Google-Smtp-Source: AGHT+IGu3kpiiSiL73cGsjPJgf9P00IwKBpnUK06c+y7atJn3vhldLPJGipG7+4Nhxv9ijUCYrxi2g==
X-Received: by 2002:a17:903:37c3:b0:240:a05:5b79 with SMTP id d9443c01a7336-2446d939f0cmr153301435ad.44.1755520079929;
        Mon, 18 Aug 2025 05:27:59 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:27:59 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 03/13] mm/kstackwatch: Add module core and configuration interface
Date: Mon, 18 Aug 2025 20:26:08 +0800
Message-ID: <20250818122720.434981-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-3-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29709180006
X-Stat-Signature: iui54f6whi851cbbtsnm5sropaqky6ed
X-HE-Tag: 1755520080-910872
X-HE-Meta: U2FsdGVkX1+9u+e6qBYqOAzCiDdy3MUs4F6npByvuGFgYZl1dIS4FIdpkxFkuwf9EubHgqsvQ2hCKLxzaRqMfJ8s3t2qeVN5b6+iuTQ8QuAZ4pMuzMeIUIFidUtdVxpFtHefmgmgBRaaekkOTq2X/djVvbFRYaOiH+n1mS18k5iPlq4NRw5s2c+W/vsB1PgEwrty7lpjztkjzbdFMsoMPwwPRp6Ktr01PiENeUGAloxZiMx/Xw+ni4rL9fJJT/slJrC8JEPE/NJzpQ8/I7ex+C3c+FAGTTW8kLX6YfOEs4GjGQGJghVgUCARc+9bcjo7E7CVfhIWAd3q2pUMT+GvL2SzVCnsThd0KWMOTEf6VgLQpdQPcB0LiMrAANHYXCykZg64qdiSZOyrtrnn5kr0lUu7Sg93LH+BAdFFvnN0WpcT4xQFOWgTeKS8IXHbZFRvTsDpuwAxpeo52/FGytztoI9INcYkh79EupTXu/j97PBo2rzYeUqgi8z39kVSIZBEiktIVpH1dT3W+B5A0k5POCkOBVYtdsZTqGlZPxQdzEypL//vAUOIDNS7o/hZO41JcAiNw051G5K5P8n4juyY0a4fic3nYEgcE2g+IB9ap8g+prWRLQv9CdY1ypJu2Xh5QvgrFFkrp1i3ihNiUHjZCB6DQ8cgaH2vGfjecx/0FxyzsSiXptB5o5Lj8G3ZmOMDrPXPNhnAEJSzC5hS+biSsiuK9bTkcP69MoFIQa2p5z0ApLx2MiXPNadGrU83QEyDJ1XbrZq13rInyKdaxJlxWofmIiuerQAmeJVNE5owjwGqYaBT5DKm9D3IMs01xUMf61WWzxjEd6AyjhUPHeNjgio473lPwCPc3Oz/sp1g4iqff0aOp1s5q77QEBHjYTk+poSsnYZxDpaLs1S+3qjf7uASBVMmz8ykOxf6Ndmdy2BHFzWTyMo9WQ5IyjO5C5Juz9dwRu8zEgH3hntcg+r
 9In4xC/i
 s/Oe1/dLUfVBubsz2X6tNXCC9o6GlIRCTJMwRdQ7E5lXyBZNl9mv+18w3oYn7i8FrEJv1sXI6OEWDS8xvmdf8beLWjPLPQrRtzgaQ/XgDkUNqnQqgmBiC0fhfaUqF6JyFlH7DiQGCpzekDiE+P+HhnK2aBVHF5Sesk9FQcnKWi7eXNuwRdBIAeMSVnGIDuUVvan5SzeckUx1dOxHoPgIeRpj/GHH8h6ybeW2F7LF4IMDBqpdIgSWAyeOaqN17JsQxw1lyKTFPxyIFFbPuy+bFSq8eRxg6tFJxUaFgxkL4ejzUg2T1CbmtcNYigLaXxKqlLcD5oNppuW7X4Id8hLftSFPaL92W+JWjYuXGUXzWAlFrNS3ukRRlccTeLTXVqMPdCndGwp5zVcV0QAHNSlBXiHNEKuDGCPBPz2YBNA93dfm+Fc+tr7ZWMRhkjWE4JejoT+q/2cpxAY3BGi3qIJseFazZUzqEQt3WIKUT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the main module infrastructure for kstackwatch, providing
a proc-based configuration interface and basic module lifecycle
management.

This patch introduces:

1. Module initialization and cleanup with proper resource management
2. Configuration parsing for the flexible watch specification format:
   "function+ip_offset[+depth] [local_var_offset:local_var_len]"
3. Proc interface (/proc/kstackwatch) for runtime configuration
4. Support for both watch types through unified configuration syntax

The configuration parser handles:
- Function name and instruction pointer offset (mandatory)
- Optional recursion depth filtering
- Optional local variable specification (offset:length)
- Automatic detection of watch type based on presence of stack parameters

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c      | 205 +++++++++++++++++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h |  39 +++++++
 2 files changed, 244 insertions(+)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index e69de29bb2d1..726cf3f25888 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -0,0 +1,205 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kern_levels.h>
+#include <linux/kstrtox.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <linux/uaccess.h>
+#include <linux/string.h>
+#include <linux/utsname.h>
+#include <linux/seq_file.h>
+
+#include "kstackwatch.h"
+
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("Kernel Stack Watch");
+MODULE_LICENSE("GPL");
+
+struct ksw_config *ksw_config;
+bool watching_active;
+
+/* Module parameters */
+bool panic_on_catch;
+module_param(panic_on_catch, bool, 0644);
+MODULE_PARM_DESC(panic_on_catch,
+		 "Trigger a kernel panic immediately on corruption catch");
+
+static int start_watching(void)
+{
+	if (strlen(ksw_config->function) == 0) {
+		pr_err("KSW: No target function specified\n");
+		return -EINVAL;
+	}
+
+	watching_active = true;
+
+	pr_info("KSW: start watching %s\n", ksw_config->config_str);
+	return 0;
+}
+
+static void stop_watching(void)
+{
+	watching_active = false;
+
+	pr_info("KSW: stop watching %s\n", ksw_config->config_str);
+}
+
+/* Parse watch configuration:
+ *    function+ip_offset[+depth] [local_var_offset:local_var_len]
+ */
+static int parse_config(char *buf, struct ksw_config *config)
+{
+	char *func_part, *stack_part = NULL;
+	char *token;
+
+	/* Initialize with default values */
+	memset(config, 0, sizeof(*config));
+	config->type = WATCH_CANARY;
+
+	/* strim() removes leading/trailing whitespace */
+	func_part = strim(buf);
+	strscpy(config->config_str, func_part, MAX_CONFIG_STR_LEN);
+
+	stack_part = strchr(func_part, ' ');
+	if (stack_part) {
+		*stack_part = '\0'; // Terminate the function part
+		stack_part = strim(stack_part + 1);
+	}
+
+	/* 1. Parse the function part: function+ip_offset[+depth] */
+	token = strsep(&func_part, "+");
+	if (!token)
+		return -EINVAL;
+
+	strscpy(config->function, token, MAX_FUNC_NAME_LEN - 1);
+
+	token = strsep(&func_part, "+");
+	if (!token || kstrtou16(token, 0, &config->ip_offset)) {
+		pr_err("KSW: Failed to parse instruction offset\n");
+		return -EINVAL;
+	}
+
+	token = strsep(&func_part, "+");
+	if (token && kstrtou16(token, 0, &config->depth)) {
+		pr_err("KSW: Failed to parse depth\n");
+		return -EINVAL;
+	}
+	if (!stack_part || !(*stack_part))
+		return 0;
+
+	/* 2. Parse the optional stack part: offset:len */
+	config->type = WATCH_LOCAL_VAR;
+	token = strsep(&stack_part, ":");
+	if (!token || kstrtou16(token, 0, &config->local_var_offset)) {
+		pr_err("KSW: Failed to parse stack variable offset\n");
+		return -EINVAL;
+	}
+
+	if (!stack_part || kstrtou16(stack_part, 0, &config->local_var_len)) {
+		pr_err("KSW: Failed to parse stack variable length\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Proc interface for configuration */
+static ssize_t kstackwatch_proc_write(struct file *file,
+				      const char __user *buffer, size_t count,
+				      loff_t *pos)
+{
+	char input[256];
+	int ret;
+
+	if (count == 0 || count >= sizeof(input))
+		return -EINVAL;
+
+	if (copy_from_user(input, buffer, count))
+		return -EFAULT;
+
+	input[count] = '\0';
+	strim(input);
+
+	/* Stop current watching */
+	if (watching_active)
+		stop_watching();
+
+	ret = parse_config(input, ksw_config);
+	if (ret)
+		return ret;
+
+	/* Start watching */
+	ret = start_watching();
+	if (ret < 0) {
+		pr_err("KSW: Failed to start watching with %d\n", ret);
+		return ret;
+	}
+
+	return count;
+}
+
+static int kstackwatch_proc_show(struct seq_file *m, void *v)
+{
+	struct ksw_config *config = ksw_config;
+
+	if (watching_active) {
+		seq_printf(m, "KSW: watch config %s\n", config->config_str);
+	} else {
+		seq_puts(m, "Not watching\n");
+		seq_puts(m, "\nUsage:\n");
+		seq_puts(
+			m,
+			"  echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");
+		seq_puts(m, "  if ignore the stack part, watch the canary");
+	}
+
+	return 0;
+}
+
+static int kstackwatch_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, kstackwatch_proc_show, NULL);
+}
+
+static const struct proc_ops kstackwatch_proc_ops = {
+	.proc_open = kstackwatch_proc_open,
+	.proc_read = seq_read,
+	.proc_write = kstackwatch_proc_write,
+	.proc_lseek = seq_lseek,
+	.proc_release = single_release,
+};
+
+static int __init kstackwatch_init(void)
+{
+	ksw_config = kmalloc(sizeof(*ksw_config), GFP_KERNEL);
+	if (!ksw_config)
+		return -ENOMEM;
+
+	/* Create proc interface */
+	if (!proc_create("kstackwatch", 0644, NULL, &kstackwatch_proc_ops)) {
+		pr_err("KSW: create proc kstackwatch fail");
+		return -ENOMEM;
+	}
+
+	pr_info("KSW: Module loaded\n");
+	pr_info("KSW: Usage:\n");
+	pr_info("KSW: echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");
+
+	return 0;
+}
+
+static void __exit kstackwatch_exit(void)
+{
+	/* Cleanup active watching */
+	if (watching_active)
+		stop_watching();
+
+	/* Remove proc interface */
+	remove_proc_entry("kstackwatch", NULL);
+	kfree(ksw_config);
+
+	pr_info("KSW: Module unloaded\n");
+}
+
+module_init(kstackwatch_init);
+module_exit(kstackwatch_exit);
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index e69de29bb2d1..f58af36e64a7 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _KSTACKWATCH_H
+#define _KSTACKWATCH_H
+
+#include <linux/types.h>
+
+#define MAX_FUNC_NAME_LEN 64
+#define MAX_CONFIG_STR_LEN 128
+
+/* Watch target types */
+enum watch_type {
+	WATCH_CANARY = 0, /* canary placed by compiler */
+	WATCH_LOCAL_VAR, /* local var defined by code */
+};
+
+struct ksw_config {
+	/* function part */
+	char function[MAX_FUNC_NAME_LEN];
+	u16 ip_offset;
+	u16 depth;
+
+	/* stack part, useless for canary watch */
+	/* offset from rsp at function+ip_offset */
+	u16 local_var_offset;
+
+	/*
+	 * local var size (1,2,4,8 bytes)
+	 * it will be the watching len
+	 */
+	u16 local_var_len;
+
+	/* easy for understand*/
+	enum watch_type type;
+
+	/* save to show */
+	char config_str[MAX_CONFIG_STR_LEN];
+};
+
+#endif /* _KSTACKWATCH_H */
-- 
2.43.0


