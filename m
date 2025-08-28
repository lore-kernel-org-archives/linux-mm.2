Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9068CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017D38E000C; Thu, 28 Aug 2025 03:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3618E0001; Thu, 28 Aug 2025 03:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2748E000C; Thu, 28 Aug 2025 03:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C5D188E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 567795C1F5
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:22 +0000 (UTC)
X-FDA: 83825353164.23.CA1FF6D
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 575E718000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m+btVr6F;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVjzrm6vJvhOYeF4QMjv0eGIgiL9m2bJu49WtrTbuMs=;
	b=VFjfacvMiXJZq377Ed0QEzMBliyXfuHY5BjpUPMrSuPqlLYOx3xcLmnLwlQPdH073aHSuG
	2NIXXM2HgWdTpadomd9Gf86TZpnHUEgscoaewHWoLj5Wfl+YLtPdwY7rMajlI5NJ8Zwv94
	E0mJD8BODLh7+Eudh5E5mw6ift9t820=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m+btVr6F;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366460; a=rsa-sha256;
	cv=none;
	b=bpEjmKf4uMlpYA5U8EKe+wzIq+kQVc6jkauCEDG1mrpReyRpfCd0LZHIfZnHUIVNO1ag7A
	kz4ww28w37mSAjMB449cC6d0IpQefSU+HkeUWTFns4aIzLzxr9bNInHY3q1dUr0RzGfaph
	cubPhXd5ha1rseRQdw8/Go8+5ax6g2s=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7704f3c46ceso563238b3a.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366459; x=1756971259; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVjzrm6vJvhOYeF4QMjv0eGIgiL9m2bJu49WtrTbuMs=;
        b=m+btVr6FHHT8uErJmxAGamWMprO1nxpmJC3hg9Cb5fWIePn3ZLuSccLh73sVMQ+kOj
         9CQW6tII4/VQ2yY0IS7LsXQb2Lp9ccWRWRWabJ3sJUjLUUKvwP1GLAvz5wUhkw/1Ncho
         8grBrhggGUsy8EEs3+b+o+oJbLXuBUF5OgF9cVeYP+e8lWt4XIm+JKsV/tLyRsU14VTG
         ppis2U3o0RcGJ96gL0p2NuRsPYERNRUgApw03ypirxMuwOxpKZp1PgnJc+eAipWUzCCy
         7xPHKM0P1a+H+CB693Aws/clnVW1RS2fx0QnhdcUpJyzSr3esoSPL0ioEvQo4GeSvjE6
         L3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366459; x=1756971259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVjzrm6vJvhOYeF4QMjv0eGIgiL9m2bJu49WtrTbuMs=;
        b=Msx4zFji+qsTxIXnCBm66c5jVjQHy2Lj3VabDt8yTMz5Hs9eub+ZMxrzhSgvQX+0YH
         JHzvvYHXTn3U+DPEPGJHkupcZs9K3nzCB0cDxdpfNO+2oym3/PrrUcQLhYk9xoIFc/6o
         5sbwbWRE2hF4icuj40v70UEuOsvcw08O2jzEnIm+rK8BYHbQy/AVlxf0gL2Etlkh7qRa
         2uxMWBqNE5/CWIcSiFqzEZ3axEvptHRGLwJycUVaBIUQUEp0D2xe6gZ9IkItCNpIDIWF
         G/XaZ6APb+X0hHqh1SQnqVJbrMH2DRAQtlLvA4GFVwyinIBXk2ztfTmVlXSjv4wrBTOL
         PfvA==
X-Forwarded-Encrypted: i=1; AJvYcCVGjoTNImI3lPibGyFNdVaX+LIe8OgXpDL6mX7dJ4+84djwKMoDPYBoWSf3FKmirrf1G1nzCDScZA==@kvack.org
X-Gm-Message-State: AOJu0YyYKX8CBFY+U+lTYuQ2ukugtfkeb/Ay0cVsuBUYvv5lKwMk6/jo
	HbiVlAh2UaDpt5Xm8wJfgEzvYjSeUX5HJuYbA5LpN+ZVCXL8Qh316NSnmze6r9ackd0=
X-Gm-Gg: ASbGncsGF/t04xvR8uQ5yoOhj6s0sXDSAMnnb6g8hmbfL7wMsH+hCF0hKt9+j6WQvxT
	tlS4L1w5hXB9rFu8iwvieB36HtYt7B4cEJGMl0TT+MMeAw6kxZU3kNeD6fPk7iKuQx21i8ucgkZ
	MlgpGOQ40/BD9WdvbUcqPJW00JWiaMdvV8WbX92ot1zA7b2SapN88E6boXtfouYPE049MSPuWKe
	icOvrUkBk4ZmznB9LEe0DfW39+v5rQskJ29GkHtuWovHN3y4kTBd912nI5yL4KEVNJZSLEd/CC2
	X9P1eO/dlLaULQ5RUWOz1jn/kKhBDMFU9/ObIIcnCnh9108dlNGpmRjaUEcPZ/8WY3RUPxie/nz
	okj5BQZIERwDy/aihIazNxFXCqfbbjXRfKZtWRm7+sM1Szj9lWYFj8I35Wa3x
X-Google-Smtp-Source: AGHT+IFYhlbFCeQPuAaCUEgKiUrGtQ+7l2i/ih6peCZQtuclDB1MWqRTOOZ5F985pI8fDDhetrxXsg==
X-Received: by 2002:a05:6a20:6a1c:b0:243:9587:a743 with SMTP id adf61e73a8af0-2439587a912mr9614332637.23.1756366459180;
        Thu, 28 Aug 2025 00:34:19 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:18 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 03/17] mm/ksw: add /proc/kstackwatch interface
Date: Thu, 28 Aug 2025 15:32:36 +0800
Message-ID: <20250828073311.1116593-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 575E718000C
X-Stat-Signature: 1o8mdy48czzj1jjaeqsbx7oew7enpsoi
X-Rspam-User: 
X-HE-Tag: 1756366460-902978
X-HE-Meta: U2FsdGVkX1+A4OHazv8wthnD8b0566P5ns/3shBVAShz6DRgqbJ2seEYJtchpOfmgZSszqj6G6KS9eGOpi1CFXDk4lsvf2sQXrxj6/7ysS87NJxXwIDemtmzVwD6IW4spgho8N89+X7nGh+Wx9Mm2W5sYBaxJ4b9IvVNB19sjZqn5shgErMmiYFQLWZKWfCwJVIvNJrQyp9ec3OkIvljTBPdbOtJ84ySroQV40vyFGpOBVrKk/zhfqZxAHXaRUX6pOALsd80Df5K3IwFvfKzKEzmj6NTCH5Qa4OKxtrNhzwrnXOs7y0c8ET6lKZVjjjgNN/s/7n9jXLCltYk6WFWOYuEa+dULImCzqcAKu2QzzDEAwDEEFvl12UBRHaD37gX720PCBF/U4o2gKk6M4y343VcBCb+SsEC2g0/R/aAl5GZc7uwAvyjbrPrEesYSN4PmoH3t/QB81NTlm2fzjOaXusG5Dh5+qaifE9e0TKKQ8B/xV8mr7o1dadMBz1c/gNzt6/crTRKbc5+1Qc2c4Y3gy9AK0o1dqUD3XygHGF9ku0/e1UBO60ZvacyrOny148xfSJKThzEnI5/3Nirw3CCzIQ9yISGJE8LsDvy5wXKYjRyytU/B3v+jVGtxgbAP/UZo4Yp+0se8u9O6b6YYu0RWZeud2hiYf3ogA+O7kOlXJMdzMPOSNSVNpoJ8EwIWQLFF2M3xJ1kMiUhwG3zRwv2Fl/fFdHI0XnrHN/veAqEwbKapNCPFsewW/BnDP8VZ2FBiyoZVByif91SK0kc0wg0vXi2CciB6ao+vC2SlIsQHml/fzABiGehHbodrvB7r/ek227bsZ778wme+NjKU7mHEUAY+eVZA5A1vO9//OhWdCbUkez6tNhWMSXO8ZnW9hkeENfCrKvEcftH4ZVmr61XVdZRV7ONaloCUX5SnfRZRp1g4uZSYwNKFwd0+sOrnZ3RDvoyDp2dnTvcFmYdvU7
 tCa5FiZo
 CMmdC1MXDoT94H9JQECaFta082Zuz3l5Z9otF6ou+NB2RDifV3237/+80M+unSH55RFMuy9alSpyvyjvQ1dyStr+uow6EvkyMW/e6+BxWD8o09Lq2xT0tAYzLj/HRn3xdUrAGk3I6e6/AT4htEPhkj4wE+huUDHfmdLOHGWpNyuELR9SA7cJfNpkaZWPeR7o0bt5U8RNze1ebcNQ9YNXPR92iqaJzOoUxTSnPerfkAoyeJP487hybUAkRAyw9f3Q0/VOQmu4GODQpH7IbNLEw+FAPQsu3aApY4o8qrh69rRuroHLd9Z/16aX8YN32CpgAxUrzYfB/Vsmie6aAV9JXmrKYzJDCj9ztO1DrNk2MS8j2NKqP3NqDmYx6uv0FCXXi5njU2lE6U8QyHliqqbJgdFN1Kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide the /proc/kstackwatch file to read or update the KSW configuration.
Writing a valid config string starts watching; empty input stops watching.
Invalid input stops watching and reports an error.

Allocate a ksw_config struct on module init and free it on exit.
Manage watching state with ksw_start_watching() and ksw_stop_watching().

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c | 140 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 4a6dc49449fe..95ade95abde1 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,7 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/kstrtox.h>
 #include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 
 #include "kstackwatch.h"
 
@@ -9,6 +12,29 @@ MODULE_AUTHOR("Jinchao Wang");
 MODULE_DESCRIPTION("Kernel Stack Watch");
 MODULE_LICENSE("GPL");
 
+struct ksw_config *ksw_config;
+bool watching_active;
+
+bool panic_on_catch;
+module_param(panic_on_catch, bool, 0644);
+MODULE_PARM_DESC(panic_on_catch,
+		 "Trigger a kernel panic immediately on corruption catch");
+
+static int ksw_start_watching(void)
+{
+	watching_active = true;
+
+	pr_info("KSW: start watching %s\n", ksw_config->config_str);
+	return 0;
+}
+
+static void ksw_stop_watching(void)
+{
+	watching_active = false;
+
+	pr_info("KSW: stop watching %s\n", ksw_config->config_str);
+}
+
 /*
  * Format of the configuration string:
  *    function+ip_offset[+depth] [local_var_offset:local_var_len]
@@ -74,8 +100,114 @@ static int ksw_parse_config(char *buf, struct ksw_config *config)
 	return 0;
 }
 
+/**
+ * kstackwatch_proc_write - Handle writes to the /proc/kstackwatch file
+ * @file: file struct for the proc entry
+ * @buffer: user-space buffer containing the command string
+ * @count: the number of bytes from the user-space buffer
+ * @pos: file offset
+ *
+ * This function processes user input to control the kernel stack watcher
+ * Before attempting to process any new configuration. It handles three
+ * cases based on the input string, In all three cases, the system will
+ * clear its state first, with subsequent actions determined by the input:
+ *
+ * 1. An empty or whitespace-only string
+ *    Return a success code
+ *
+ * 2. An invalid configuration string
+ *    Return a error code
+ *
+ * 3. A valid configuration string
+ *    Start a new stack watch, return a success code
+ *
+ * Return: The number of bytes successfully processed on success,
+ * or a negative error code on failure.
+ */
+static ssize_t kstackwatch_proc_write(struct file *file,
+				      const char __user *buffer, size_t count,
+				      loff_t *pos)
+{
+	char input[MAX_CONFIG_STR_LEN];
+	int ret;
+
+	if (count == 0 || count >= sizeof(input))
+		return -EINVAL;
+
+	if (copy_from_user(input, buffer, count))
+		return -EFAULT;
+
+	if (watching_active)
+		ksw_stop_watching();
+	memset(ksw_config, 0, sizeof(*ksw_config));
+
+	input[count] = '\0';
+	strim(input);
+
+	/* case 1 */
+	if (!strlen(input)) {
+		pr_info("KSW: config cleared\n");
+		return count;
+	}
+
+	ret = ksw_parse_config(input, ksw_config);
+	if (ret) {
+		/* case 2 */
+		pr_err("KSW: Failed to parse config %d\n", ret);
+		return ret;
+	}
+
+	/* case 3 */
+	ret = ksw_start_watching();
+	if (ret) {
+		pr_err("KSW: Failed to start watching with %d\n", ret);
+		return ret;
+	}
+
+	return count;
+}
+
+static int kstackwatch_proc_show(struct seq_file *m, void *v)
+{
+	if (watching_active) {
+		seq_printf(m, "%s\n", ksw_config->config_str);
+	} else {
+		seq_puts(m, "not watching\n");
+		seq_puts(m, "\nusage:\n");
+		seq_puts(
+			m,
+			" echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");
+		seq_puts(m, "  Watch the canary without the local var part.");
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
 static int __init kstackwatch_init(void)
 {
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
 	pr_info("KSW: module loaded\n");
 	pr_info("KSW: usage:\n");
 	pr_info("KSW: echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");
@@ -85,6 +217,14 @@ static int __init kstackwatch_init(void)
 
 static void __exit kstackwatch_exit(void)
 {
+	/* Cleanup active watching */
+	if (watching_active)
+		ksw_stop_watching();
+
+	/* Remove proc interface */
+	remove_proc_entry("kstackwatch", NULL);
+	kfree(ksw_config);
+
 	pr_info("KSW: Module unloaded\n");
 }
 
-- 
2.43.0


