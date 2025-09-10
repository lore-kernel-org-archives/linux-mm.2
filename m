Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D840CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6188E000F; Wed, 10 Sep 2025 01:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD5B8E0001; Wed, 10 Sep 2025 01:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2928E000F; Wed, 10 Sep 2025 01:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CBCD08E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:25:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 997435AF64
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:25:24 +0000 (UTC)
X-FDA: 83872202568.13.1E9D720
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id BCC16180002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:25:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Axdwq9a7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481922; a=rsa-sha256;
	cv=none;
	b=GdRi6sVxEI9i/DEDz3ADCoyWX4QdMBLfzb2B1aTeZ7gIR7Q5Pk4qk9b0SEGTSFTQEBG6J/
	PiU3Gz2zFkmadQAD2YGEeIJdzjgthMk1SH4DEFd+fHzplm5LDf0mlQ5gFsl1IvmNh67ulF
	NNXToFc1F2wIdSZbWBadbneHSa5nM4w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Axdwq9a7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iH0uUA/mqRHCjkyWem4sk7YGmV7N6yemXibteoDcT8=;
	b=6w41vdvNtgI/piBn5QTqqdDQxfs2iJwUDgrGnrXvMm9hCKNb8YcynqW4nsEpJiT05Ow3EG
	VMs2973insMOhgiMqu21Ukyatg/vKC6KzMkbiO3Uxbwfc2Z1sNxAz7CYds0pgHHKpz12wM
	l8UIG/FTMCVyy5jXud0FD8vfQLzz46g=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2570bf6050bso21899985ad.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757481921; x=1758086721; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8iH0uUA/mqRHCjkyWem4sk7YGmV7N6yemXibteoDcT8=;
        b=Axdwq9a7GmlgmD/8g1WLfj7TJ5McwArY+wFg7UHXI/dFOGWlh/I9A5fg1P01Jb4Cs0
         xB84e1nxfpW6He0PpyPYYUqY8dtn7YFmU9KG3wpNXL+0BXQgloAM6tS4wP4h8tCLMcrm
         0Lh9Fz2yHKzFmIRbYx6XYA3B8HuerF942rlwQROmOixv8HTHrasaaqMhgEcVHMlEujUQ
         lngYvlifPzmKpB17+qiUBlANwh0Sc6Oqi+/ugAtLLBZ0cA9OUpJdAWtBmPbrZT1qRIn3
         Se9U4io9u2G5jphWaSu/IMQfa5HqP3oinAdQEs/h0wJCUwQGv1GXGYqly6DzpEFEeslb
         HEwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757481921; x=1758086721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8iH0uUA/mqRHCjkyWem4sk7YGmV7N6yemXibteoDcT8=;
        b=AIfRJqF9qN3fAFE2D27q0KqanPBwd6kF9ivycjxg/ZCk61EdmgbS7wjYdfouceTMCk
         bw17Z/8ZLf7YsithcjuINytFgtEjPuNXtJsaSlVLFUbc7cxr8Ikx4L6pd/4UWoW6nf24
         A0NcpRFH5KY79QjlVIS/QfUrGH9F5o4IRAa38nOYlOV+Wl6z2VM60VbYh9KzXYdn5RKM
         bapQkgfH8KvApWaGU4vyUIp94WcC0cxejp8gevjIfv+UuX3nDXP+F2ZPXxfrxZeTu+ub
         1djllL0GeSNLc2DL2q9FrHcdu92q3r0nLaWBVM8N2RMSI7D3vsSTw1pjscq0n4PbPi9g
         IPnw==
X-Forwarded-Encrypted: i=1; AJvYcCVKHuiqsLYzFwDS54sXAYd1EwWaLb/ncSTXI3dG3Qgd6TLEcluctUQ9nFMSk56WiKQbG/uweJet1A==@kvack.org
X-Gm-Message-State: AOJu0YyfsifxDhJFeeP2ss1w/yAEMR5XZvfUvS31zrkTm0sXECToNUvM
	apYKQa8STrEwfFO6YtBcuYBjVCWDDBZRcVnlTOHcRR71XX/DdPThhoyx
X-Gm-Gg: ASbGncvA7KOXAt1zYuKosHUaQsvzw/5W2+8stL2TTGuYIyJBktNq0QwPBUdPgY0k7Ua
	cRCJoFwrn6tHY+itEi7/4iydGbKKDW3EtcwbvIBoc+RhN21mrg3n8dRzOhQ0vtOc0sS/8GS8o6O
	BuT9vyYZo2dtvRV356C2LaqT0zb3E09Rt+tNZIU2y2y4r8b/lwdoLgB1fdm6QM946lMuFAaPja2
	WXsoMwoibkLzA/lgfh4Hcsfacrp8c5SLc+/D1UT8c2DT0wYpO/XXaFp1Gws32PrVRn4gNBlUf3f
	jzOKruE6o3flJhgqxsBXJkNE6c1ZKNtsQmvVs+X7QfuvHeomex7jAg0jfukLJ5sdxVxTAiPfSak
	PIlXb5dPUv2/bfEbb159w0piJhgxmo0dWQA==
X-Google-Smtp-Source: AGHT+IHyIbPI5OFJBCaoz7jKF8b2NXtZuc8li31LzuXXg8oHgdT4/pVFw9hECNltJyQIAJVvWWbD5g==
X-Received: by 2002:a17:902:ce12:b0:248:79d4:93c0 with SMTP id d9443c01a7336-25175f75c60mr198301765ad.56.1757481921566;
        Tue, 09 Sep 2025 22:25:21 -0700 (PDT)
Received: from localhost.localdomain ([2403:2c80:17::10:4007])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422ebcsm14815125ad.29.2025.09.09.22.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:25:21 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v3 05/19] mm/ksw: add /proc/kstackwatch interface
Date: Wed, 10 Sep 2025 13:23:14 +0800
Message-ID: <20250910052335.1151048-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910052335.1151048-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCC16180002
X-Stat-Signature: n6qtz9m5o3pryxfusjo8djcwyz6fbhsm
X-Rspam-User: 
X-HE-Tag: 1757481922-90922
X-HE-Meta: U2FsdGVkX191ecyJIL22kJVd4s1XVrPh7785xiKPqf4Tycg1MmFSCu9rDivrjRqGULgsPh1f5YC1rLduFaYMVLbpZQ0E+scKCwmfITCuyg5WLQYDnQNLNnbmwxEyBIyrY9lUkTJmY8XFXiQ7oYmSTYCQtU/nFHkk9JAttCLZ19iwBmqEXcfXVGoW88+lkYaYfuYc0gBR8lAZnD3Qsknv2bn0do9YBtul0I7S86BJsCvbdHeZIh3+WlguY+K/tqAmomanDWpfDbngrVsvnOSwiJ84/FkWo/2QyjFb9R97G3l7I861f5NjEZav58jnEelyWxFTzKtJ3Vxhl79EG8Q9nyixgLZouL+K0+vMzRowGwR4/a8XP0ArK7rVu0uefTpFkpGK0fOjycoFUcD8KT1dx9KA454Uq/goG9vw/9icgJBh4Jk9dsJOaOlWoFvb67b1asq8p4KrzSdn655mlCUqib13xKeBsWZnN1/sIHAsJECvUSl7qLe6D9fwkQFrOGI758aofuWVTPII1ys+vI074RL0XlIYy8RzzEImL3Uk7vrZxXtKsOYXYxjkpV/Fm3aH4u3A439RIVuer5WsO8bg7apnSLUfrZ2g3Oltc+OprPxcd75jMCrdQ8cvz3uNUAyWon7nlSKoDY5NTaPlijVDAnu0GL/ADdQEuN8c+xYIbEQolsbKW7t8/K+vdT4UK2zWSXd2U5v/X2eFot7OYsgWf6cwwI/dNXXs9Dco7Qhg2e+dXGwuSnfP62KXPup9q3LmAiJoJA4z9/7V06OjwDTgS9ZOaxjs5uG0AHC8XCHOHDgoTMo7kH7KJPTBDvTjk/hNwvdGEcwM/4ZxLrkrEtT0TSRxnyljHfVHkZsEPO18rd9AAC6J3whx2x67SIzGN0sy6J6kbmlnvO8F/sBbhsjYmc50T6od9CzNTNDq2v14tKQw5Nmvjh00u8tRZMWKVGNKngVclJAY192LqAuNzJC
 2HI3f1en
 dSrcnkT98D2waSTDdH/cVuHv6POmAD0abBjf2+8/53TDP7aRe0yK6gT+bpbsL9x8nJcTvgRQJ8Q8pkT+XKXyU+Pe6OcBRDVKIXZtJYoJ3IrWwIJoiqh+TXvJ9PXQceGFaaaG/z4dRg9pf0yRen5BxTY3T2+UXreR0wDNPZe4njAQTvRBpkxzcwCk9NTu3pvbqhUIr953OqBqibhtn24glIcFpXsHmE3/x9LTb1A+QgGiORdVGW04g6LAvnPkWhOPS3SJgT9/XMIkN7ivmi6PNA/fH0/y79e6uKsbPqb0qaxgqT+QYZrsZXLO2PAGbCZ8Ybjc8j3ZZTxJk19BPFVFqjMqSfR1vQzoTCEpvycdz4ERpw+TemYUw4N9iPDJOBJFgNqz588fCQ7TCgLxKFstceC2X8RSBkgKisNZTRUah2F+u90Dongx4vG8hYBW66E2kkVk6B/4rtS0PMmRiSsuJVjPTNDqOaWyx4CiN4grckX6Redx7aJvAaUS3jGzkP/Z7byY6oi4nyU7RIG/1M5TJaaq8CoWCgJhYXV92hxgjkLgfVNuYw81Xn0owo2A2TifXu448Nq2yYEM6oRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide the /proc/kstackwatch file to read or update the configuration.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c      | 75 +++++++++++++++++++++++++++++++++++-
 mm/kstackwatch/kstackwatch.h |  3 ++
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 1502795e02af..8e1dca45003e 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -3,7 +3,10 @@
 
 #include <linux/kstrtox.h>
 #include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 
 #include "kstackwatch.h"
 
@@ -12,6 +15,7 @@ MODULE_DESCRIPTION("Kernel Stack Watch");
 MODULE_LICENSE("GPL");
 
 static struct ksw_config *ksw_config;
+static atomic_t config_file_busy = ATOMIC_INIT(0);
 
 /*
  * Format of the configuration string:
@@ -23,7 +27,7 @@ static struct ksw_config *ksw_config;
  * - local_var_offset : offset from the stack pointer at function+ip_offset
  * - local_var_len    : length of the local variable(1,2,4,8)
  */
-static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
+static int ksw_parse_config(char *buf, struct ksw_config *config)
 {
 	char *func_part, *local_var_part = NULL;
 	char *token;
@@ -92,18 +96,87 @@ static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
 	return -EINVAL;
 }
 
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
+	input[count] = '\0';
+	strim(input);
+
+	if (!strlen(input)) {
+		pr_info("config cleared\n");
+		return count;
+	}
+
+	ret = ksw_parse_config(input, ksw_config);
+	if (ret) {
+		pr_err("Failed to parse config %d\n", ret);
+		return ret;
+	}
+
+	return count;
+}
+
+static int kstackwatch_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%s\n", ksw_config->config_str);
+	return 0;
+}
+
+static int kstackwatch_proc_open(struct inode *inode, struct file *file)
+{
+	if (atomic_cmpxchg(&config_file_busy, 0, 1))
+		return -EBUSY;
+
+	return single_open(file, kstackwatch_proc_show, NULL);
+}
+
+static int kstackwatch_proc_release(struct inode *inode, struct file *file)
+{
+	atomic_set(&config_file_busy, 0);
+	return single_release(inode, file);
+}
+
+static const struct proc_ops kstackwatch_proc_ops = {
+	.proc_open = kstackwatch_proc_open,
+	.proc_read = seq_read,
+	.proc_write = kstackwatch_proc_write,
+	.proc_lseek = seq_lseek,
+	.proc_release = kstackwatch_proc_release,
+};
+
+const struct ksw_config *ksw_get_config(void)
+{
+	return ksw_config;
+}
 static int __init kstackwatch_init(void)
 {
 	ksw_config = kzalloc(sizeof(*ksw_config), GFP_KERNEL);
 	if (!ksw_config)
 		return -ENOMEM;
 
+	if (!proc_create("kstackwatch", 0600, NULL, &kstackwatch_proc_ops)) {
+		pr_err("create proc kstackwatch fail");
+		kfree(ksw_config);
+		return -ENOMEM;
+	}
+
 	pr_info("module loaded\n");
 	return 0;
 }
 
 static void __exit kstackwatch_exit(void)
 {
+	remove_proc_entry("kstackwatch", NULL);
 	kfree(ksw_config);
 
 	pr_info("module unloaded\n");
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 7c595c5c24d1..277b192f80fa 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -35,4 +35,7 @@ struct ksw_config {
 	char config_str[MAX_CONFIG_STR_LEN];
 };
 
+// singleton, only modified in kernel.c
+const struct ksw_config *ksw_get_config(void);
+
 #endif /* _KSTACKWATCH_H */
-- 
2.43.0


