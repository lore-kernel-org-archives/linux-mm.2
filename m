Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672E9CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC89D8E0033; Mon, 29 Sep 2025 22:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78C68E0002; Mon, 29 Sep 2025 22:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40F78E0033; Mon, 29 Sep 2025 22:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF6E8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59508BA3E9
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:48 +0000 (UTC)
X-FDA: 83944376376.29.0D47CBD
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 605BCA000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WV2O6emx;
	spf=pass (imf25.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Zjn9o91E8eMF6fANpWy8yJadTo2vfyIghwnTsVomDQ=;
	b=mUS77iA1juKfkbDXrz1ExmnfdNhpY1ouB0RFcvliewaIDkxDn+dAD1rRDEPtaic1M7vb0Z
	S7ejqRbia3XeRKNQiU6MmDuwP/aPPJos+hsPzM8fpMSw/p52b1tYWlP/AVdb/KwL+j4Ole
	5Rkn7WcJE74SYTn124x5Lzbm5GbtyWY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200346; a=rsa-sha256;
	cv=none;
	b=B4npYsuW1hvkzNItDyf1C5+zLo2d2cemaZqU1dw9D1n8LVcQeuP0mgSf7rn2H4mcoPBneI
	E9wczEjadw676t2aMDhD8Vv4QlOV37FHVrU6ZE3vX7gdYLm1ytFN/EVkKqxAsNt2GORPgM
	EmvxA5xzsfgAa1QuAITKvR3p7fqhaa0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WV2O6emx;
	spf=pass (imf25.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-27eed7bdfeeso51704385ad.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200345; x=1759805145; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Zjn9o91E8eMF6fANpWy8yJadTo2vfyIghwnTsVomDQ=;
        b=WV2O6emxl/tPmxVA3l1xXGGyjnuHyf+upGdD0fxb0qIwVQFgWCXY0RPv2dMKPAv6mD
         MqIJPS+KTKGoT1WWPdwi9HHSzqSWBheIuStQVqLeRCV4zGM0hyKF057HKBckceKbgVvP
         rVP2TB5wdslRooDyOs+3bCJQxCbfL40PoUOsVnt/1aihbizaM4GHUbnbAo9uOiM/0ANv
         WC5lnOPYICKossP1dO7IXZlS5eb20O+kACTzc/kc4m4xyRYRX609sSzDzD03myZAI7NB
         esXZvD2oMjOp53bt7yTU3u1qpivBXiejBKfXE/CfLQ+Kr1QPr+vzXPmBti+qHxYjmx9l
         ZXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200345; x=1759805145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Zjn9o91E8eMF6fANpWy8yJadTo2vfyIghwnTsVomDQ=;
        b=lecrar+6RL0i3dv3HbeoVAK9zHUFhtks39ciTq+OZGqt59ci2+avp4FBzUy/fbLvxK
         amRG2LHI04lNTgBvlgwGpydhvdenK5nRQHV+50WAE5lkM7gUvwy4lWAMADzzRImLwYQd
         aOU7xENnZsrmXqFNmrI7xghEPF5Lu07fIEfXAJptyKusIxNsKAzwjhjyXUJ31WpWdigz
         DKMszJ7XzjXGBzDUU5eMRy788zdh8Y4qCouyMfFccTXSKlvZWPHNxSQIXIxKtt8ZhKSH
         ig8RYKieSPxjkavutCSoazN+o2234++pVqwx8tONmMdtLwzr0dEt+Ylvuro4lyUlfz4Y
         Pvrw==
X-Forwarded-Encrypted: i=1; AJvYcCWzRGqb7HHdSSP/UwE52lwBD7EQZ7OToD4zSgyR04/on1C7Oe4cIXQ9YEbZ5PgL+bp8LMyZst8D2A==@kvack.org
X-Gm-Message-State: AOJu0YxfwRKaa+HYXLz3pHHw1XI0N+cxhzTXpYMbNrc4GWoEbZwXMQGu
	7AdosWMwTmgobZstlinPwPJMAsNHTNh+/QTu0eyUy940/HJNNI0luIk3
X-Gm-Gg: ASbGncsOdfbI/y6fB2B8HeQppNL1CoztutLLDgl+8xhhOo2GprGqdh8ZS+XwhQX4cs6
	uqXDcTaa+Q1WM+2mc7GOUWAwTxVXU5vxNc8N3vsmLXQ6g5YwMIL+3kh4QV8nBeVtkRNIpCpUxCu
	J3/QLtkEScavBYzCkLjsL6+qFJa/tclfPo0D2ojCpav3l62fLV1Hm82SvVfnJoDQMp5qRhp1poV
	YMJsx4zicN/1XWbkp8Ic/cZ4IXxuj6ML6YJbs++Q20PojdFS/o5qTY/VPW+ouU/gUClfMFEqzT6
	GVdlX6KkCUHUW0YWk/niwJ8vtJt0zkkUayA0A5WFAAPBo9cdb/7JHmdOnbiOsCUbh87Iek0FhtE
	2+wWXG7lhMKjPOkT/LcAEl+YomxDLCykQuILVZzRizjPEEFIPuAFhWAdntrBrwQn35Pi3lRPPx+
	m5
X-Google-Smtp-Source: AGHT+IG/V+l4d2YJ6ds5JXx6iWxJNgpfbKQaTWJecBpgg+jS+5oh1BhPKfXY/R3RErss9TGYBDL6Iw==
X-Received: by 2002:a17:903:2f4e:b0:25d:510:622c with SMTP id d9443c01a7336-28d1718d306mr31185225ad.28.1759200345170;
        Mon, 29 Sep 2025 19:45:45 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27eea801b49sm118165465ad.23.2025.09.29.19.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:44 -0700 (PDT)
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
Subject: [PATCH v6 17/23] mm/ksw: add test module
Date: Tue, 30 Sep 2025 10:43:38 +0800
Message-ID: <20250930024402.1043776-18-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 605BCA000A
X-Stat-Signature: kjq8549459ihoajcfnpng5e1zhdj7zch
X-Rspam-User: 
X-HE-Tag: 1759200346-978233
X-HE-Meta: U2FsdGVkX1/ZClBu3+KZWdB8ZYrAYgDPvU7Ub5aeXwOwH+XtnQAGqXxeoDce4c6jqm5sM3cCpxKUQcyXSKvMjFG/WI/7lDjQws8ewaanqs3OHHzxkUIa5G4LK0rbrl+0sFbT7lNlqL/bCsyNPoynIQ6sktp7JRIM0etMdvPyZfapA/RhwAWk9YND7yb9KZIJ1z4R53aPlp5qHrlFV6U5zk5kt/h5hSr/Fqg2PYT9dlMbceRqpeaY609JbS0QXWOMgUD+DX87sVcjZ06jg21EmtqgdHQHZseqfrU2jz5l9q6oYepiu3L0ysNUpQi9SEVzj7MRUJUUZERBHgs1j3/FITQ/gdbT5g26yPxwhd+eDRNfGWg1NRoYzt+yYFNtFfhVuQTaGEg6zTBPXIOdivAsjBCnBqrt869x+ndZLJ5bRUnirTrGFZz3AzGQ/kLKe6Golx8Hfqn48kv0ZCFzvDImPJ3z1RnWuS78ZGniaPvdxjSDD5jWHQ7H0AcAEu0vSmKtvEMcJa5MoQpwGlPI0atZ65KO6Aw8haHXZBs2ZIIm83krDQqlvasEwf1m8FNoFLkC/nr16VEEDddAnzw+cHC/LYbQAJdXDmGvSPPBW70ewJoUnI7hlbCk853J7/o6FD/Y7AtkEO1SWqAFi6MrrSlm+IPiV5gpOZ1XfdustdYvMiZlurP4zgcFy+r4IdtJPU3rQ3j5MeOxHTvlrp80zvCiB36GdAmyaU+XrPVuu+7jxa9WlnnlReVyfm6mGFvWdckPVHRN5RyCdG08ljD/A8SLQAruOyryG4cwOjZN/x1jeUx4yit+pd8ZdAo7El6psXcQEFKGFeBihzEHQsbqDqv2idiMTwbLhhwKh2Cw0Ge+PYLlhBHuMMrwjkYARJ5cfiLd3yuIEeK0i1lbu6AF8PcphyAj7P5tE0wQ6g0aIyCzMO8mC49P7bQOTxD6LtWiHa5jSQwTGDW41opJkWkzBwV
 woCGIM/m
 TiHxMYL9PH8W8Rb+qabQFAAywt7VyxMD4PB959RxNvxIvLkWCm0GSJMAkkALqO+KJ/57v46mOo52MLx0MI6x4z+v5SCtG2HzIy0t11fkvLy94jNuQVHIdfiiAGTYaArZ0qH5bY1nZOmakpJ5H2ktMSC6tSOpBhC9KkcYppTGPJKzEjr9gj0yArhvvqbZBia4kWrb+qBepMS6PE0Qc+4DdqVLEcMbyEofrvqOoT+FxFedhA8tDM5VbaNyPLOj5vr4NzWxxEf2JaI6u1Zb9hIN8LYHTrY3qq5pPSpxxYpBz86cVK6gnAHTro53prUyd5sKBCmE+w9ncKdWRrmyE38w3A9mY/8hRW830w6BYZmFrq3UPFlzHjNsziEmkDBD7v5DBMSt6UYH144okklExMCiALZ5ybm4JKARyVFPQy4mYwmnyR5HF3YowPcrAAGaZEw+OirKy8vLGJ9xod5A6yDKrQxVh6Gn8N++6y2EE4Kd7mvrC3CCNEYwRJFIE9ycQ8zeNmQvO/KsI/8w31z2h21illxX8rlzSMQoIinzGTOaab19VQDtj4IYjQIokPaTITUaA187L98qEv54fwPHU8kZGZ78CNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a standalone test module for KStackWatch to validate functionality
in controlled scenarios.

The module exposes a simple interface via debugfs
(/sys/kernel/debug/kstackwatch/test), allowing specific test cases to
be triggered with commands such as:

  echo test0 > /sys/kernel/debug/kstackwatch/test

To ensure predictable behavior during testing, the module is built with
optimizations disabled.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/Kconfig.debug             |  10 +++
 mm/kstackwatch/Makefile      |   6 ++
 mm/kstackwatch/kernel.c      |   5 ++
 mm/kstackwatch/kstackwatch.h |   2 +
 mm/kstackwatch/test.c        | 121 +++++++++++++++++++++++++++++++++++
 5 files changed, 144 insertions(+)
 create mode 100644 mm/kstackwatch/test.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 24f4c4254f01..224bd561dcbb 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -317,3 +317,13 @@ config KSTACK_WATCH
 	  A lightweight real-time debugging tool to detect stack corruption.
 
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
diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 57628bace365..12b2f5ceb5d4 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -233,6 +233,11 @@ const struct ksw_config *ksw_get_config(void)
 	return ksw_config;
 }
 
+struct dentry *ksw_get_dbgdir(void)
+{
+	return dbgfs_dir;
+}
+
 static int __init kstackwatch_init(void)
 {
 	int ret = 0;
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 528001534047..b7361d5d071d 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -34,6 +34,8 @@ struct ksw_config {
 
 // singleton, only modified in kernel.c
 const struct ksw_config *ksw_get_config(void);
+struct dentry *ksw_get_dbgdir(void);
+
 
 /* stack management */
 int ksw_stack_init(void);
diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
new file mode 100644
index 000000000000..80fec9cf3243
--- /dev/null
+++ b/mm/kstackwatch/test.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/prandom.h>
+#include <linux/printk.h>
+#include <linux/random.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+
+#include "kstackwatch.h"
+
+static struct dentry *test_file;
+
+#define BUFFER_SIZE 32
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
+static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
+				size_t count, loff_t *pos)
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
+static ssize_t test_dbgfs_read(struct file *file, char __user *buffer,
+			       size_t count, loff_t *ppos)
+{
+	static const char usage[] =
+		"KStackWatch Simplified Test Module\n"
+		"============ usage ===============\n"
+		"Usage:\n"
+		"echo test{i} > /sys/kernel/debug/kstackwatch/test\n"
+		" test0 - test watch fire\n";
+
+	return simple_read_from_buffer(buffer, count, ppos, usage,
+				       strlen(usage));
+}
+
+static const struct file_operations test_dbgfs_fops = {
+	.owner = THIS_MODULE,
+	.read = test_dbgfs_read,
+	.write = test_dbgfs_write,
+	.llseek = noop_llseek,
+};
+
+static int __init kstackwatch_test_init(void)
+{
+	struct dentry *ksw_dir = ksw_get_dbgdir();
+
+	if (!ksw_dir) {
+		pr_err("kstackwatch must be loaded first\n");
+		return -ENODEV;
+	}
+
+	test_file = debugfs_create_file("test", 0600, ksw_dir, NULL,
+					&test_dbgfs_fops);
+	if (!test_file) {
+		pr_err("Failed to create debugfs test file\n");
+		return -ENOMEM;
+	}
+
+	pr_info("module loaded\n");
+	return 0;
+}
+
+static void __exit kstackwatch_test_exit(void)
+{
+	debugfs_remove(test_file);
+	pr_info("module unloaded\n");
+}
+
+module_init(kstackwatch_test_init);
+module_exit(kstackwatch_test_exit);
+
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("KStackWatch Test Module");
+MODULE_LICENSE("GPL");
-- 
2.43.0


