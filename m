Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE0ACCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217DF8E007C; Thu,  9 Oct 2025 06:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF208E0002; Thu,  9 Oct 2025 06:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1052C8E007C; Thu,  9 Oct 2025 06:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F26808E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FE36C0822
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:34 +0000 (UTC)
X-FDA: 83978274828.10.C3B4F35
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 844842000D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AbRrrNsf;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tH9NPPXYzjzWmBeV5TNMSRB6I94mkI1pmHDAIM87ayY=;
	b=qN8bfgZQ9JCMfBZYkP+Ecpiag1eVNfeJgrjMzS+q8yiLKKQH1uGG8IBgK8rE2odMYFXw7B
	68Zk11t5abjzDFPjsW6mAWEbo0y0O5YDP6/ik9FToGXbN5vIz1j2TBrtxCHJ1/tN57qRYg
	5MWXAKH6rPfQSHGxLzIFipAnKl5nB84=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AbRrrNsf;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007452; a=rsa-sha256;
	cv=none;
	b=dD2eI81aCu6cxQ/+/64yWrydmrGLUmtDxU96VCgESw2ue3+r7neoVohLM9B9R8l+M9Mu9G
	qmaJqKKz3DRyLQHNOdRre1/XkPNIg1bz1GAWlR2OEPQ4WEKTaxnAn9Rc67lPYR3dpA03e0
	1X4CdwVJKGR3ftCrQKzndD7UaBu3LsQ=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7810289cd4bso802989b3a.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007451; x=1760612251; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tH9NPPXYzjzWmBeV5TNMSRB6I94mkI1pmHDAIM87ayY=;
        b=AbRrrNsfwVoKkdGTdyGQ4TpDHvltNFUkLGSYYru9GPjUzsNhCU6VaN7ZViZT4p6hhD
         gs1X243426vgAuvrybCzEbT4MJnomfqp31DnJ+yTyZKuE5rvXQ1cZWxfCxV+bxYKQSYa
         GVQdDFC1o29bVk10mC/XHQUo3piafii4e+ALGJB5Cn+JVEs99UATMWEMoszqtdQC7/Fz
         Loq3ilDfJcqLktsU68fJhzv2xPovB3GlaRRkg0vZk67vMFgEVryG96Zf4gmm30D8LJS0
         OmOA2e/9iRhygrSe9NjGBjnQKAviquECduIjvNwa5Rx2UY2HVQyRkUI2qQVOcvuP3b1s
         FreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007451; x=1760612251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tH9NPPXYzjzWmBeV5TNMSRB6I94mkI1pmHDAIM87ayY=;
        b=pKufVbDciOfcaCIOY7WlOUJz4wwr+B8p/HwDdo0Sd/WVyKZ29jiHobiKo9PRmozxCF
         /695H1PBgTPSN5CD5NE3YvIYQjg93Ylc2CU02flRqZTlTNvvgT/phDjb4iRNpGTXca2K
         vAumzrZuVFsKgQEnHjnggpGG4d17iF96JQ5A1qQqMtOqfDbtK5GgCpbTEPEI7vQ96YSF
         F+1m2cznZmjEmkrI40MoFIj3ibG7t30FHUZ80bye+/yvdWsNSbXbQj5JsFwO/Ul/g6WW
         N9MdD9FUOC9Dt0WsQVAWEEWIsza+htjJXywzesvv9pgN1nrdfkQ+GB8MVQ74XCTet32s
         XFWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnxPrlK4CflqCJM63aqnAPYix+9Uy6/xRZ4RumvJQ+XvEYxoHMdPyQfCLc9clWmlguXg2+flov8w==@kvack.org
X-Gm-Message-State: AOJu0YzEiHmWHy8ArancTqIfkJKbKynjVD4iUAuTZFvS2nDAy3CPK1sc
	9E1nbui+dRLtsRa/dGdAaNDTcon6+FkmN4BGW4ccC/sIBznxNWbEej+T
X-Gm-Gg: ASbGnctuomj4WHTgFcffmeBQCSzDQHA7mqvgDzOFZhEkSd7t8yQ2UKwn6OCAOMM2BlA
	3jqv3GkGAhnSTBtioeRnR5HxDwwtwJkki3bx3N/Z+Cyf0qVl1G9WvhoCxVg4bEqKqDomV5jyLoy
	hHnolm1dkcFJNhLs1twWOSFLUnw9wQztJukMazSBRBtSeSJW4CNXTFFOBjnp5Hf+tpB8Xk5/kwU
	WWKQNe505mv9hAZRNsGzwq0eUNqfAFnzbRTOhRtz9JCZfjQ7Ga5X+kkxzT6oy7roRzJkssXsluL
	fakDviH6Fj8J/wMA5rCJS4Yn1CcYUV9DSv/qDYYZ5X++iD6TC4yzPaJZ6RnM1SS8aI5Cg/lTd+s
	ozqVqHrxazOUNGuu+ZSt6LYAEQ9paR+77MjqppMM8fCUReiDra+RhPDu9h94e
X-Google-Smtp-Source: AGHT+IFHk/BtBSKimaKQm5uYl91w8zgkVCHa9z7abhTtJzmBXj1LTCWyaE902ZK//m0NEMBKQHd4Bw==
X-Received: by 2002:a05:6a00:4fd0:b0:783:7de9:d3ca with SMTP id d2e1a72fcca58-79387c1a74bmr8499688b3a.31.1760007451210;
        Thu, 09 Oct 2025 03:57:31 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-794d4b3d866sm2531315b3a.11.2025.10.09.03.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:30 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v7 06/23] mm/ksw: add singleton debugfs interface
Date: Thu,  9 Oct 2025 18:55:42 +0800
Message-ID: <20251009105650.168917-7-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 844842000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: q1htrpzmau18waubnimyimh8n1hd4abx
X-HE-Tag: 1760007452-40324
X-HE-Meta: U2FsdGVkX185p0GKkyi1SBhIhvtcRQ6lNzJCE8OiNUvYukeWJ5zYQpw3/3pD/5E07ddoizNw00q+wEE+P2ZIV6JUVvKgipQ1jfFLtiaG5hQRozz2FJ577qAVtheQMZlw9ZLyUQT86kWGkvFx8C3Mq87ag9ie2inpErZS6UBZrblKk0KiPl9DAMxUND+agSzFZ7GZ92TxaLmTjitAjcAxqSMAhpdedq+Q6HqFCrTHMpFVj03+njT24/kvYmBljvY5vF9IL936SGAeidSqh/qOQAmvd57J94sZ5I9tlDuFkzBpA/Uey+aSEVJ37tWgtZKC++W6X/7jVGiLl98cMFSJ1g0rGC+yYBgFoDFEbAUswoqIFBxp5BFN258lnauXeak1GgreNnGfmHo/VsoOhhQbVfjJ3sj13Saz5sy4qkVIC2KYkkav3C0O37a3YBrnc2HDdkkGtr8uSuBB9y1Y3nNPRebKpYyZTi3KZy0Ztjvwu8I/0hrY0W+mEXIQV8ZPONnd3v//ETjPlGfWl5JC9l4L4L4GY86KZ4ASqVQoIK/hQgC1crFFb//7UbJtx31qo1TnBEE73PLIBpsEOlKlz3SLo9lqIz2O21+ch8PqQwz1HITwGlRsrAfVVcMTVa5dHBSVaqnkWy2uxul8PgSe7rRYfOXnfHbV0GsVONowxiL7JJkeoOdCQEqBCc/eazVi/3iM1MpvuJjY4beeJDZxC75bwKyDLZ5H3pinCnQKsjRXkDpaSU9B4NPFunEvJATbkzXKoNgQSFzBlEKFLu/xGdjOf29GPH1azZaId8xbN5I3kX1UiTWwdvaDiISg2HBZ5ycrokdKRMFdkDvAYOhKzh3iG/7CcGvuOmP77SWhLKfULRPag8Lu1+adMGttTtCbFajOTRaBI1I5ffQeT7T0Yb5dE3+1GkefhnK6kFhOtxiN/7vC8duVzI8ZXxYGZu7I1wVhyFxpwK+yZ9Z/cabnyhW
 I0yozqm9
 ZlqRVbgyT/FHdri0ocWBTWqqrUUUQAwYVUeIB/un24YxeMOy/uiIpMBKANeIpmqKDsWusD7MjevoL/8GYJ7RgkLFlmNRLXrF7eTf/lEVcUo8YAoTJhId7mkg3SeQwvFueErT8JhRUsa5R8FRSPp7CVEN1Xs5cPK2NlFdKBh04r2SS+qPZmOWjIgnOMbjhruEhJ7Im/mNY7RtuTL9QFI4250t8Ol+80FTI8s5uMGbgQJTiB2qiumixsQsybQ/0PObNyyB7+Eapx/YtxE7BFJE8UhSghObjmWu/LRuhKbD6EIBVBQtYi4OhJdmc4rkDFmbjCYuRnRjtgqjT5BHds26IncuCuWgSBY8z0VRXxpLI90WgVRXCnxxKDdwgUGkLWXwzaxxQExE8PFchFqYRVqiWkIW4TCWaanoOSwsnEA5tWmX4AoChrvsKkPlZ5xkSx92RcbGi0AKQgghb6cnZYE/Ou3j4vPRl5NkKQrPh+4DVuFrCexPTPYbTsehgj/Zt7S32wRzEUKcMeKGHxwsxOCE1V4IBFZGI5ZYo54i7QWYlGAhw98nDcBEh/4adud+zJwI/VYoXk4htmGmQTmznfx8fV9qS0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide the debugfs config file to read or update the configuration.
Only a single process can open this file at a time, enforced using atomic
config_file_busy, to prevent concurrent access.

ksw_get_config() exposes the configuration pointer as const.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c      | 104 +++++++++++++++++++++++++++++++++--
 mm/kstackwatch/kstackwatch.h |   3 +
 2 files changed, 103 insertions(+), 4 deletions(-)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 3b7009033dd4..898ebb2966fe 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,13 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/debugfs.h>
 #include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 
 #include "kstackwatch.h"
 
+static atomic_t dbgfs_config_busy = ATOMIC_INIT(0);
 static struct ksw_config *ksw_config;
+static struct dentry *dbgfs_config;
+static struct dentry *dbgfs_dir;
 
 struct param_map {
 	const char *name;       /* long name */
@@ -74,7 +79,7 @@ static int ksw_parse_param(struct ksw_config *config, const char *key,
  * - sp_offset  |so (u16) : offset from stack pointer at func_offset
  * - watch_len  |wl (u16) : watch length (1,2,4,8)
  */
-static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
+static int ksw_parse_config(char *buf, struct ksw_config *config)
 {
 	char *part, *key, *val;
 	int ret;
@@ -109,20 +114,111 @@ static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
 	return 0;
 }
 
+static ssize_t ksw_dbgfs_read(struct file *file, char __user *buf, size_t count,
+			      loff_t *ppos)
+{
+	return simple_read_from_buffer(buf, count, ppos, ksw_config->user_input,
+		ksw_config->user_input ? strlen(ksw_config->user_input) : 0);
+}
+
+static ssize_t ksw_dbgfs_write(struct file *file, const char __user *buffer,
+			       size_t count, loff_t *ppos)
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
+static int ksw_dbgfs_open(struct inode *inode, struct file *file)
+{
+	if (atomic_cmpxchg(&dbgfs_config_busy, 0, 1))
+		return -EBUSY;
+	return 0;
+}
+
+static int ksw_dbgfs_release(struct inode *inode, struct file *file)
+{
+	atomic_set(&dbgfs_config_busy, 0);
+	return 0;
+}
+
+static const struct file_operations kstackwatch_fops = {
+	.owner = THIS_MODULE,
+	.open = ksw_dbgfs_open,
+	.read = ksw_dbgfs_read,
+	.write = ksw_dbgfs_write,
+	.release = ksw_dbgfs_release,
+	.llseek = default_llseek,
+};
+
+const struct ksw_config *ksw_get_config(void)
+{
+	return ksw_config;
+}
+
 static int __init kstackwatch_init(void)
 {
+	int ret = 0;
+
 	ksw_config = kzalloc(sizeof(*ksw_config), GFP_KERNEL);
-	if (!ksw_config)
-		return -ENOMEM;
+	if (!ksw_config) {
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	dbgfs_dir = debugfs_create_dir("kstackwatch", NULL);
+	if (!dbgfs_dir) {
+		ret = -ENOMEM;
+		goto err_dir;
+	}
+
+	dbgfs_config = debugfs_create_file("config", 0600, dbgfs_dir, NULL,
+				       &kstackwatch_fops);
+	if (!dbgfs_config) {
+		ret = -ENOMEM;
+		goto err_file;
+	}
 
 	pr_info("module loaded\n");
 	return 0;
+
+err_file:
+	debugfs_remove_recursive(dbgfs_dir);
+	dbgfs_dir = NULL;
+err_dir:
+	kfree(ksw_config);
+	ksw_config = NULL;
+err_alloc:
+	return ret;
 }
 
 static void __exit kstackwatch_exit(void)
 {
+	debugfs_remove_recursive(dbgfs_dir);
+	kfree(ksw_config->func_name);
+	kfree(ksw_config->user_input);
 	kfree(ksw_config);
-
 	pr_info("module unloaded\n");
 }
 
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index a7bad207f863..983125d5cf18 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -29,4 +29,7 @@ struct ksw_config {
 	char *user_input;
 };
 
+// singleton, only modified in kernel.c
+const struct ksw_config *ksw_get_config(void);
+
 #endif /* _KSTACKWATCH_H */
-- 
2.43.0


