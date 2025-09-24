Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D288CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6708E001B; Wed, 24 Sep 2025 08:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957C08E0001; Wed, 24 Sep 2025 08:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845FE8E001B; Wed, 24 Sep 2025 08:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 740B98E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2451DBB839
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:25 +0000 (UTC)
X-FDA: 83924001210.11.9913C56
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3C2921C0017
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aKeJLcm/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758715223; a=rsa-sha256;
	cv=none;
	b=wzToy9hwSdTFzvMsEmLUXHYcwAeoy66Vcp3nvC9RT49YH1h6eVCv4vAgJwqXCgwSPzt8VE
	VfRGgnqltkBnSdgonXdD7TyHSvRtAMrwpdiJrH8fLcCa5KliEMmPXnWNWP05PgdmVPrWhe
	LTN6AlS5ADPP3PuyE0drVwAFQpSnBr4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aKeJLcm/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758715223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h46VjKRHdkcMiEZAqaWzAvZEGNArMuVfKDzvSU/d6uw=;
	b=tXc3dsQxZPqOdZ/Zex/fyEUAh580tcv1w0n/jokDWIgMz2E2Heyp7SoOAOdssWkgP9z0XV
	cd3mcn7DYhdpXxUfYZCxpPnmJeNVPJmhQ7p92+E3eY5UDXqb6DErRN1Z62NztANwrRjyVY
	aTjFGvSycf2AYr5incEJDyg171TC2dU=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77f41086c11so2868996b3a.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758715222; x=1759320022; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h46VjKRHdkcMiEZAqaWzAvZEGNArMuVfKDzvSU/d6uw=;
        b=aKeJLcm/DY1z6sgB6aQ+bggfAz/ZfGQhWtnKre9bEdpCN/Bb5xgxfEFADQUxmm9zL3
         s4/bA0SfpNpfn96O6z9niIHSid4s/rBWQkf0dSdgbzhtB/XvL8WWtFVXq3rsg2fQYkzB
         pfeL0DJnJXLXnADTREnxf8On1dmh9vxM37SmlZx/EKoTMqrtteD2rRpdhMZINqG+o3n4
         SphviET9nHKiYtN1E5LezJqo/kpqABPsPQ9OW0klIvd6WOZsMeY55gnvK1tuvt/puHFt
         VJcxYIMobtPNx4O7tX74H9FFCegRLBZfpItUQLzIw3r4dFc2nheqVYrvOdAAFhKFKMjs
         r1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758715222; x=1759320022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h46VjKRHdkcMiEZAqaWzAvZEGNArMuVfKDzvSU/d6uw=;
        b=NiUIJKeBoaxRYORdVoMH57C/TsPCvSWuo/sK4f3byDyDtF5wOTwfjl/kASiJMvg0KR
         feNKCRYHlQWrstr2NXJ0ZPsecqEcT7wALrxLNDbBsw4o9Pebcqz4aIWLuhHgJ1b/TXv2
         giS4yW5RnTKZJ2TOVbEaPo6EEESKZDC5eDZvwKIhGDCx2gKocNolBzczJEZx3NOqMKnz
         jAIMsN5Bfg38tDnQ2KJvKeUz20SVxS2SZB/KwgnLMjn6NOnPiMHBneq5tpYF9CR8cVK4
         zs8Utv1ToD+0IHUR2Lt3hQ6295wO+aM+Wil6i0LbJzGpdvE3quHta4VUupkwjBhs8SCr
         uzqA==
X-Forwarded-Encrypted: i=1; AJvYcCWq9g4pe1GJp7YfvVszl5+ONSJU/Y8PVx9gK5T5feRimidnxgLRhQbMtbnb/YPhGF31AqV1O6DC6w==@kvack.org
X-Gm-Message-State: AOJu0YyJmdiKIk7psjpFKw+tDsuJmu2WOjC/Nxy+f5hlMElr/aqPeBm9
	6E7SuWxDOeRSDwyaneKyNw0FLAH5If6EkPuC/GXF3vJfC/gplEZVWJPz
X-Gm-Gg: ASbGncu6GXkrAT6LTMFSHyvbLsUUi/n3frO5R9jwFtOmeH98AiXxOD2EroaplhqQ+uo
	hvbZyfl5pip8QRf8p5t/1UgH7w955+E5YwI7t9mSNnqzfIynrFUPeELkFy4xHol1CrpUSFpds+w
	DBzqx6f0fMlEAplT/6IhPhB4VfGHLciRP5Ui5ZjfRYYuzPl/eAP4DUvlN8E+LppMZpOZEzqI0fS
	7o66/8gjiivYwkz4S/QwTMQQAW0jiWj6VtR7OBbc8rHXRm8ICUhyObx6k6gFqDbHWF8qRyuPC0U
	ckOhmJ7/E6H1lCVDcJNKAj6dDZm7wapZoqZMnRdzkdZhven7MBDlJh7PF4fZ8hTcoVwlTuPwIqq
	nUcxxOKpyy3hV0a+xIrbJ0h0=
X-Google-Smtp-Source: AGHT+IE6fNdjuLZN8PpezUYZCjv0+nCNqLy4/cUMk8Ck5LuFvTMHEe5sGc7ej/DiBYiLC24FQ7Snbw==
X-Received: by 2002:a05:6a20:12ca:b0:24e:c235:d7ea with SMTP id adf61e73a8af0-2cffdb6b8a3mr8370045637.47.1758715221706;
        Wed, 24 Sep 2025 05:00:21 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f335995cbsm9451657b3a.63.2025.09.24.05.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 05:00:21 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH v5 17/23] mm/ksw: add test module
Date: Wed, 24 Sep 2025 19:59:23 +0800
Message-ID: <20250924115931.197077-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115931.197077-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115931.197077-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C2921C0017
X-Stat-Signature: owz9o7s9zqbtdmija3w4ar4wuyo48gss
X-Rspam-User: 
X-HE-Tag: 1758715223-267014
X-HE-Meta: U2FsdGVkX1+YIKMC9yjH9V9ybj1RzE3ceWl5ve7uH9/WtEeSLIf7iTyKzQu7ARL/ZuQavX7lnnf+XyhO0j5oVXU3siYknkyz8QpX4/G1lT7Omg05S6FaN0i+IzmJ8nLFwODO3zXAS9IetEuQGV3c5jxwmIV/LdzApCYV2UmlphmHRScG6YvPYi3qGMPhss4GVjzYwE0HbUzY9hYuBHYt82oOsPN2G1DvXbnsBJxO589aoNppncjs+rgtzwmE+WaXXRudvMc+hgXtiDDGqJgQf1jYf8ngIq4Y2sSYUd6OnGu7TU4OU3Y0ZdXMe/7U/KKGjeMFDsYS7dDMuhUR3/qCvRG8LS3FVoZXE9VkOnL2pEQEl1JB6Qu0nDF0s6JvKabMTxMcGtYfvFuXJm+qs5Zpm6Epx9CJkx4ebh02GZ146G6nq9ts9EfXXH5YIssKmGjOG+hCjDqlgasQ/PjOM7xJTWNKB+qY/C20RaztG6Aa+pFieke+eYGm5D1ELdh/nirtNjdlsf8z5K1zcQNrqRHdFsCSYKwxWkqfgcHMo++nhmozjDAU8eT6NlB9jI39oynhW0Wo5kbr9jEBx+0oe+g3jUudm6sNy90iIvy0ostfo4/9r5mtcgFk79pviPoV5UaMShoo5++7dNoTr4WQ8RBYrplEoML9lL1qJESlgnC8mqL0d6s+SKq5BFL0d3XN0TeDt+EmMbLetU8WlcIoBEOI5gW1S2xApAcSnMDLlTCd4RurjjWwRlYU5MAzhruoC92lfThNEdABL3E5sDA+RJuz6+92iR3eQc4woswezg/5MnmwZRy83HrJ2VE0JixWs8bQ04Gvdtw7taEOGQm8jigbqY9ra1VZ/d+LfKJxS4lYCRe6Pk7KqAT8+BDxdOcoFFEj8rEzBuTg1nVaVHd2Cs/5UrkQzQigPkz/Ihxipe4GUeeJ+PodDuwhffKIWxFxlSbHiSHkDdoQgvvDHnhkGHO
 TkT/l7jo
 9iD5Mvh+2o3tanZTmhJvVBSJxamLFosFFDA1ukH+pcb+ZrnVEmN+hpoAQt0wHVVFRGbSWmNEMTgFtYpPM4qo6aFo3k8GmMnMotk4YtM/fQfYZmPDR7c8hcZo1W2qu0XiLHBTkc4oUTO8BOweRfMGo7Dw+3GsOKXZxBh8TV46LTGs49jMgqa9P1ME6RxbxIuQqx1Jrjp2fqHFS08OLXlyKaZKS7dk8mK0IdeHHwn68PmIt/NpVsjFXywKAeoB6qCC+PLKE2KrlEGT8Fe1DYPyfc/O1ov8jUr5oPsNS6S5YrTqHBWkWhcWEFviWAnAe5FxRUt/yp8qi79hXN3d0GUYx87ivsld4+7N68DRWR1E4ArXfKWt3xuR02lb6UxBmKnk/0QMMpFtCY60hj5QuacBRyQqqQrj07n1e7OQOLHuHRLKKcjywO7bGOeoBQrI8P/V2JwP/x5fmz2r6N/x8nDyYI1Ul5b+USlolINd49G+p/41q9r0+cnNee0Je4UmScOU0IYyR/wUL1MiiIJv+cpZnqtZ26isP+LvU3XXQwQ79ZLmYKEQoeuAY4UiBgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a separate test module to validate functionality in controlled
scenarios.

The module provides a proc interface (/proc/kstackwatch_test) that allows
triggering specific test cases via simple commands:

  echo test0 > /proc/kstackwatch_test

Test module is built with optimizations disabled to ensure predictable
behavior.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/Kconfig.debug        |  10 ++++
 mm/kstackwatch/Makefile |   6 ++
 mm/kstackwatch/test.c   | 122 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 138 insertions(+)
 create mode 100644 mm/kstackwatch/test.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 89be351c0be5..291dd8a78b98 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -317,3 +317,13 @@ config KSTACK_WATCH
 	  A lightweight real-time debugging tool to detect stack corrupting.
 
 	  If unsure, say N.
+
+config KSTACK_WATCH_TEST
+	tristate "KStackWatch Test Module"
+	depends on KSTACK_WATCH
+	help
+	  This module provides controlled stack corruption scenarios to verify
+	  the functionality of KStackWatch. It is useful for development and
+	  validation of KStackWatch mechanism.
+
+	  If unsure, say N.
diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
index 84a46cb9a766..d007b8dcd1c6 100644
--- a/mm/kstackwatch/Makefile
+++ b/mm/kstackwatch/Makefile
@@ -1,2 +1,8 @@
 obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
 kstackwatch-y := kernel.o stack.o watch.o
+
+obj-$(CONFIG_KSTACK_WATCH_TEST)	+= kstackwatch_test.o
+kstackwatch_test-y := test.o
+CFLAGS_test.o := -fno-inline \
+		-fno-optimize-sibling-calls \
+		-fno-pic -fno-pie -O0 -Og
diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
new file mode 100644
index 000000000000..1ed98931cc51
--- /dev/null
+++ b/mm/kstackwatch/test.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/prandom.h>
+#include <linux/printk.h>
+#include <linux/proc_fs.h>
+#include <linux/random.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+
+#include "kstackwatch.h"
+
+static struct proc_dir_entry *test_proc;
+
+#define BUFFER_SIZE 16
+#define MAX_DEPTH 6
+
+struct work_node {
+	ulong *ptr;
+	struct completion done;
+	struct list_head list;
+};
+
+static DECLARE_COMPLETION(work_res);
+static DEFINE_MUTEX(work_mutex);
+static LIST_HEAD(work_list);
+
+static void test_watch_fire(void)
+{
+	u64 buffer[BUFFER_SIZE] = { 0 };
+
+	pr_info("entry of %s\n", __func__);
+	ksw_watch_show();
+	ksw_watch_fire();
+	pr_info("buf[0]:%lld\n", buffer[0]);
+
+	barrier_data(buffer);
+	pr_info("exit of %s\n", __func__);
+}
+
+
+static ssize_t test_proc_write(struct file *file, const char __user *buffer,
+			       size_t count, loff_t *pos)
+{
+	char cmd[256];
+	int test_num;
+
+	if (count >= sizeof(cmd))
+		return -EINVAL;
+
+	if (copy_from_user(cmd, buffer, count))
+		return -EFAULT;
+
+	cmd[count] = '\0';
+	strim(cmd);
+
+	pr_info("received command: %s\n", cmd);
+
+	if (sscanf(cmd, "test%d", &test_num) == 1) {
+		switch (test_num) {
+		case 0:
+			test_watch_fire();
+			break;
+		default:
+			pr_err("Unknown test number %d\n", test_num);
+			return -EINVAL;
+		}
+	} else {
+		pr_err("invalid command format. Use 'testN'.\n");
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t test_proc_read(struct file *file, char __user *buffer,
+			      size_t count, loff_t *pos)
+{
+	static const char usage[] = "KStackWatch Simplified Test Module\n"
+				    "============ usage ==============\n"
+				    "Usage:\n"
+				    "echo test{i} > /proc/kstackwatch_test\n"
+				    " test0 - test watch fire\n";
+
+	return simple_read_from_buffer(buffer, count, pos, usage,
+				       strlen(usage));
+}
+
+static const struct proc_ops test_proc_ops = {
+	.proc_read = test_proc_read,
+	.proc_write = test_proc_write,
+};
+
+static int __init kstackwatch_test_init(void)
+{
+	test_proc = proc_create("kstackwatch_test", 0600, NULL, &test_proc_ops);
+	if (!test_proc) {
+		pr_err("Failed to create proc entry\n");
+		return -ENOMEM;
+	}
+	pr_info("module loaded\n");
+	return 0;
+}
+
+static void __exit kstackwatch_test_exit(void)
+{
+	if (test_proc)
+		remove_proc_entry("kstackwatch_test", NULL);
+	pr_info("module unloaded\n");
+}
+
+module_init(kstackwatch_test_init);
+module_exit(kstackwatch_test_exit);
+
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("Simple KStackWatch Test Module");
+MODULE_LICENSE("GPL");
-- 
2.43.0


