Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF486CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375748E001E; Wed, 10 Sep 2025 01:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3270A8E0001; Wed, 10 Sep 2025 01:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7668E001E; Wed, 10 Sep 2025 01:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 041D88E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:33:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8E4C86E67
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:33:09 +0000 (UTC)
X-FDA: 83872222098.29.6106C8C
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id DEBD31C0007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:33:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJEw+Aev;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482387; a=rsa-sha256;
	cv=none;
	b=Q9s31ElZdR0e5FJAUgMcwPSZdN+YVL9y7BvO2FNLi1b5VcpFUlVfEMtWRH0olYNeRm0TDJ
	53NvC1c2tfMOBmk+IIngIUYLhh5vfZXo/Q7SvsRe3Q4v+jLJGRYz7InQ/+WdYIoKc2+aqY
	I7i1LpsQPXS6w0spWQGcSjTIpLKpQbE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJEw+Aev;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hza3KqRNKGSLYWfBSKXFsxDeH0DXXBXA3429C+Yqz2A=;
	b=VuunZtXtj3L/mDBkhYW17WwrWOfNhCzfIH9RChlPg2INHj4OBoVS2uIUH7CVlUAOeZxBvQ
	ieSguqLTBoBrsvMRjSe/EhDnfGFV05gWt+9QjBus6PBniDYX3UgA0TxEMlIFQJrqgwRWrR
	MudsTbZe2hlbZuV7Wl+49knJNzcruVg=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-32b92d75eaeso239790a91.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482387; x=1758087187; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hza3KqRNKGSLYWfBSKXFsxDeH0DXXBXA3429C+Yqz2A=;
        b=gJEw+Aev0TH5/lY92naFHYFCX2ror9UUhQg75azXPGJ/k2TbHVsY9sLOIrY1jYDbkq
         9Swx2/2c0pjcjgAiFnC9IN+ONscYf4VwGrovNfRWPBCWQUQYR8/avBrXlzh0uUw563ro
         bVQ33gl4uT0mw7Kwy/fwDBwS+dt4ygnmtwsasEZHkqC49TjAIpADcH30oDntgBilg4RP
         AGoHZ0SIDLdYfjjDtNlgM4Se1P07j/3xdNeIUXxGtEagG+oCoCORaeS+IruhDSKiG5u6
         PVmrB9YaFLn6jKBzP4Q9X3NyFPBRRgYr2Slb6R6BviuHRSrHeBHBthFuZcDx3NaWxDzQ
         RDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482387; x=1758087187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hza3KqRNKGSLYWfBSKXFsxDeH0DXXBXA3429C+Yqz2A=;
        b=DlrW/igLyk+Rgj1l6VjR8RHhJxOL1KK+qA+uKJTpWzJoH5VO3CcnYizcQf56cjJLO1
         MHH7MNzP5yjOPcdObbgpADio3StNFjjVWt1su0VU9xu6Q1oj1s1c62VsHWj18GJ253Lx
         NYPibB9MAnoyaQi5XjmeWxN6RtIx7NynIVmFGn2Rc2KMowRz7j2ITcthzR4fytxVY3kk
         THZ/ocrJbMpb8PGLGhhJu21D4m9P63SGd0Ny7iylAk6QQEKe8ZtKIdEW6cn00Nclj9Oh
         48BFEynT7FfHgPLh3EkUT5rybE33wkqOeamu5cn6ndPTuaMJzJ++hvO49/M7ZUex4jA/
         SE/g==
X-Forwarded-Encrypted: i=1; AJvYcCVfvOS+lgXl7w8Da+eT4x+USe4p6UyRpSQ+RSYAZWCcWdilORJcgj20GbKvt5/2BUV972ZU+NxArg==@kvack.org
X-Gm-Message-State: AOJu0YyYsdo9PWdz1g8zi/bWNWd2wKU7uB49gI2T56CE9k7TAB0sPW1f
	NyNJ9ycoLoER5PEvfUm7CXU41NxSqUbjm4YIfeR8oQROe7IOjj2X6o+q9sXKtGnhYuMM/g==
X-Gm-Gg: ASbGnctEfXvoAHoIer/Stxv5YiAf5Hk+TntvTHma7XTZqnxg6XNxhpwhWz9xo5yH6+E
	cz0AFWAmtCnawPuxac0TLt+F2U9vM60Zarch9oBCkummLdzKKMEgtKgufVSTfbRs3FnkAsK+Dbq
	mnsnt9R0Vi5515W4nMzhCgvbm8Vsop4k5qrqBU6YfMukp1ZEbuaTtczbwvYqL/D2Kx1yJyGmNqP
	kXh5tBCkCw02+J/1O+4vfAMJ5lUiGyV/W5Fm7T2wU6byfAwzZguoMCOjx+cfdqy7/o1adPn5dG7
	mAgJyaoJTAksZp09U9m0KeNTEzrenGZu320RYgvLBhvHLSVONfUiNFgexItS4118zm1p7+KvC4R
	oehxtX8hsJHNT9Pbmz7b0cj+Zu/4WZuzo/mkgnfIfx4srd+1F8w==
X-Google-Smtp-Source: AGHT+IGhIbrZfnqfbfJB3+5EAqaGoHeuKueESgd0Xq2xxOkj6PyWasntgL70p+IZyUYcH6qZd5vW4w==
X-Received: by 2002:a17:90b:2396:b0:32b:b514:3936 with SMTP id 98e67ed59e1d1-32bbe214925mr16978278a91.13.1757482386624;
        Tue, 09 Sep 2025 22:33:06 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:33:06 -0700 (PDT)
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
Subject: [PATCH v3 14/19] mm/ksw: add test module
Date: Wed, 10 Sep 2025 13:31:12 +0800
Message-ID: <20250910053147.1152253-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910053147.1152253-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910053147.1152253-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DEBD31C0007
X-Stat-Signature: 8ktwe6ys4eh6e9t1he47uob9rcfy95u4
X-Rspam-User: 
X-HE-Tag: 1757482387-13983
X-HE-Meta: U2FsdGVkX19QUbB+StMwU8ug76VbQNehmVIVTMHTGnwNpQPFke15jm+XhU+T25sS+UGbqFngUGQSsOSY7JDyWxlYE9/ZBogP7KbGl6m1NE8LOKQVDKq657NKAIwRDI0GzIuCBgL7N2OPbKlfJ6OH9Ur5y/6Z983gqzxDwxMPXbwDPL1caV+RZvoT3vP9jaqu5UqtN6DimpJrI4kyQJsKBzovuQ9SZzFq7Wm/hFwxI6NN4shZ5XvIQRUbRajA+ydmm7x+F6ZAIzSteapWNmqAi0HhaDKx/8+Qz1Bj74EhY6tv12J7PwuvCzwIytDpkKRsLSWGJyD1ucOjA7+Ki6PKo4N0u4wofMoCYuUHds717Y1ToGYEFVsCpL76au6DfJMvSIPsVmZi0+w22lOScCncrryKVGwkKUmcaJw33YK/xbAetFyMFxQ/ve+ADo76/4syN2t5Do0FkcFNVIBBE/YgHwC/9EWO6181XUNxgOKDAvAw2ibdhoSDV7O1wJZex1H7JdIQM8AXu9M+lIOMMu6kCSCWBzncqED7rEK5ajhpGdQ/rHvtkhZysNmTXQjW/xnB+t3b+gjIj2p5HP5AIX4b7TWXBZmxlK3s8DVRicBWxwC258xlASxf9VF1M5uyA8b8qPzvMFwSvHOZvC/RlelOvtWWO+cDTRqOOgmRxqsIhjJpX/ILcGCNB1vRE0rrhZDdrna9ntfDAYaK8wcJnh18KWAYfvXaJhweeSmYuQmhOfZRKNiIvoxCcYARKaG6WysK2PYqo9iDlnCzSU3jOhLvvyMg5oc/UtlX13oGuxzRAKuZNLDpZxTltbAGp3XWa42txBUxLYdnxq4HqeqIIkuOFX3rpOduVkoj85fbDKDI2V747SuXUQOESYhbKLIu9yvTe04HdmFiKDTHzG+gNXxZl8UzGmuaKSKdilMTlEKxANSEBKg3g5yJOmS+vNZaCpuNt5Hm2zXCtE3Mi7NoY1U
 L3Ef0CvK
 mZipFHds7Rx3ifZwbMxpOYKjJ2TvmWzAJCl57zAD7LNRb/pEXruc0VygousxXiXPJXpUOK5gXSfF7w46biJc0QS4Zy0qt4BVTJgz2JmLWf8DsTn8w9usnjN7TxS7FV3LSId4digDUzGukXu0Bnzf6SbYQW1iuNuF8UsP63Gt4wY08jY9cdVe31+pWKvrS8ZHnrjQnZM5Vw6tgzc4BazX5sZ/2Br+u76hYtOJa72/WvTwpoAlE8sEi2sFrzbtr97dYUY/G7aijvjs8G2KFtlMKuyG3+ejKnBdj6Q53sIllOBAjWUm5wDKr+UPSgYmCekQJbQOt6KqBrbGP9OpONRcmsscI22g0BYHSDgGax5KEsbRL9Hw/eGsBb7cUqA0ab234Oe4UlbqUEbSmUmUsYSiyjdhOAE6/fxbT+pR30xtO0GjME0JwkqwJA/Dqa+mPTJuQzyp8Z+dZ/Hmw7dLTBdX3Dpib2NvY4qmK73EdTq2C8mWCPGWvZnh6YaqIlKlj/fFMSwnP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a separate test module to validate functionality in controlled
scenarios, such as stack canary writes and simulated corruption.

The module provides a proc interface (/proc/kstackwatch_test) that allows
triggering specific test cases via simple commands:

 - test0: directly corrupt the canary to verify watch/fire behavior

Test module is built with optimizations disabled to ensure predictable
behavior.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/Kconfig.debug        |  10 ++++
 mm/kstackwatch/Makefile |   6 +++
 mm/kstackwatch/test.c   | 115 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+)
 create mode 100644 mm/kstackwatch/test.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index fdfc6e6d0dec..46c280280980 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -320,3 +320,13 @@ config KSTACK_WATCH
 	  the recursive depth of the monitored function.
 
 	  If unsure, say N.
+
+config KSTACK_WATCH_TEST
+	tristate "KStackWatch Test Module"
+	depends on KSTACK_WATCH
+	help
+	  This module provides controlled stack exhaustion and overflow scenarios
+	  to verify the functionality of KStackWatch. It is particularly useful
+	  for development and validation of the KStachWatch mechanism.
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
index 000000000000..76dbfb042067
--- /dev/null
+++ b/mm/kstackwatch/test.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/prandom.h>
+#include <linux/printk.h>
+#include <linux/proc_fs.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+
+#include "kstackwatch.h"
+
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("Simple KStackWatch Test Module");
+MODULE_LICENSE("GPL");
+
+static struct proc_dir_entry *test_proc;
+#define BUFFER_SIZE 4
+#define MAX_DEPTH 6
+
+/*
+ * Test Case 0: Write to the canary position directly (Canary Test)
+ * use a u64 buffer array to ensure the canary will be placed
+ * corrupt the stack canary using the debug function
+ */
+static void canary_test_write(void)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("starting %s\n", __func__);
+	ksw_watch_show();
+	ksw_watch_fire();
+
+	buffer[0] = 0;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+	pr_info("canary write test completed\n");
+}
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
+			pr_info("triggering canary write test\n");
+			canary_test_write();
+			break;
+		default:
+			pr_err("Unknown test number %d\n", test_num);
+			return -EINVAL;
+		}
+	} else {
+		pr_err("invalid command format. Use 'test1', 'test2', or 'test3'.\n");
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t test_proc_read(struct file *file, char __user *buffer,
+			      size_t count, loff_t *pos)
+{
+	static const char usage[] =
+		"KStackWatch Simplified Test Module\n"
+		"==================================\n"
+		"Usage:\n"
+		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n";
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
-- 
2.43.0


