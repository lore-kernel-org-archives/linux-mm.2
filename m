Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D050CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2328E0088; Thu,  9 Oct 2025 06:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991BA8E0002; Thu,  9 Oct 2025 06:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8328A8E0088; Thu,  9 Oct 2025 06:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8838E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36E951A07CF
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:18 +0000 (UTC)
X-FDA: 83978276676.07.FAC167F
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5DC55C0009
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xba4BTbv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Zjn9o91E8eMF6fANpWy8yJadTo2vfyIghwnTsVomDQ=;
	b=hS6XTIuPRLHbkU1P00xAZ20QMsdcpI6F3gZMoV2qWVAbxbHV4l0+ojZsFsw9MFJRe492PE
	xwp+8257P+qrz/SQ4EXgECoqcWHuqxZ0Dz0FaS+T5flkMw4qNmiFLrPR77O4xFrTSbajUq
	iealJYh8NW5h8fdroWg8Hfm/xJWCDxE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xba4BTbv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007496; a=rsa-sha256;
	cv=none;
	b=p/U5GWulbFEyWswPCGpk3NdvIyj/rQPdgjzUEGcWABkYBtO2iyq4dcTwp9MJyfj7BcaANC
	qrweHkGWi9ezw1uJx1d5xqTlr/hB7smTqH04dMwIXSxirfA2oIvzid1TO9SKTJZgnIXoR/
	arCRhHiR1Bv3gSne1rg4pARn6P2AJ8M=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3305c08d9f6so687978a91.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007495; x=1760612295; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Zjn9o91E8eMF6fANpWy8yJadTo2vfyIghwnTsVomDQ=;
        b=Xba4BTbvlJ4QPvqLPlfFFChPmDWSwhtuXWr+96SBxRTXhz5LA0QrazcfGEePuRGgrc
         C0tssh1+ISYxmIwDgkm75fNyOaOgJ3RXuo1vB6k7EGpg/iNQldNo6K7C8+iSx8Ju15XC
         ruIW/D560vhlbFA6oysD7Tv5HQXspA/rHW94LpGyOPjpZc0DhGoTl+VvH3m5Iw3KQUnO
         vIRrOyTdfv5UBo7Az4dl2G2xAj95344TQAOJVyyWdwf+4NFpc593KKl7YnZQ6YMZ0ebA
         J++xbgdD2n6Bf7/1CJwhGd7T8Xxcxf+r3UqDvPLPAYGMi88i+n3Zptd0cHURN/j+riOS
         O3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007495; x=1760612295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Zjn9o91E8eMF6fANpWy8yJadTo2vfyIghwnTsVomDQ=;
        b=hq6i0jkSC10njrLua2DRrUQlQHbgI0Si36zFPCI0MvnUU75gobRLt17+OIM+YMkE3U
         Uje+wqladpD5cuogotir/bk9zLZ/N+CmRfxs6QDZ0RbGHnwUluzjPjyNfvkyRjkcKvW2
         9F6AS/rkzh3J6jFAFcobmqULJUvAU4+jLmnZc9AEXtnFL8tue2clU/DNXSyX0Lo8zz3b
         8cHKkfGEMyd4DyoWnpivzrkZARBMmXpNf7Lkj3seDEhWDlWqqMG14k8Hhrkh6TKDqY2j
         c1L/sJnmA/L5wYn6EJvGPXDSfjmi+buOjU1lVcnRMzHiTTXRXe1KLSiZ0Nl6veMa3/UC
         sVHA==
X-Forwarded-Encrypted: i=1; AJvYcCVCMhijzbguPjZn5wceIQj8pnEzOTUbOBKbpp6JfBem/IHWrulgIiVuIL4InQJQch2VPwB0Q1kWzg==@kvack.org
X-Gm-Message-State: AOJu0Yy+Jv0VDsEJFyMWVeBb4Aq5gIOplBlWgyB2NPw86xg5e39pQYps
	u//tsD+ataUrPYTR+2rm/X3yIJdx6Owz82YigXGQzhvXhYzWnR8NS/Ce
X-Gm-Gg: ASbGncsPbX1Eac0f5uwJc3jm5PTnbVpegDVTXfEZKpBpmy61dSuxnQfaiCweU6PlrFU
	e5pMPp+S/t2rU/cAsXChO4WaVNuI5ZGM8f8b4QUYkAcP2Im1Cmo8Zqph58YMZRBRoVEsBARDKgD
	6lChOcpHJfqSdUCRqvjzVF1l5idrPpFaAqfP06JxPs4H1ySEUHc10y1JcBtZ5VTEnHB+N4a9+Sl
	dhaHfH2tp52xVYrLMcCrD4GmsyRH3J5g/XqEcVRgVah7WV2EGUrQ3Dl70cAp5i+JO6Tb1wBmGeO
	C3rMJ3xqkvmG95wHX05fz8V+527jnKcR8qiscDcCG/fGCigoyODQWdc8I35YWVwa50XcBp/l8zs
	xaqAd32/OESa+37hYJwaKa+w90dsVgsVaXVSGCrRC6hEKRjEi5GLCwHcKFPcS4f3oHtQuR9I=
X-Google-Smtp-Source: AGHT+IEmLuap8ugWBv16A9DJeROmcKQpeqK89dicn1ex7O52mvV1jyxIgbB9ToaVJaHbTj90CsCHAA==
X-Received: by 2002:a17:90b:35d1:b0:327:c583:add with SMTP id 98e67ed59e1d1-339eda5cf24mr16255407a91.6.1760007495079;
        Thu, 09 Oct 2025 03:58:15 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b513ad555sm6898776a91.22.2025.10.09.03.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:58:14 -0700 (PDT)
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
Subject: [PATCH v7 17/23] mm/ksw: add test module
Date: Thu,  9 Oct 2025 18:55:53 +0800
Message-ID: <20251009105650.168917-18-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DC55C0009
X-Rspamd-Server: rspam03
X-Stat-Signature: 6zcjm4mmkw6bmsxukicyz4iittxfqjaj
X-HE-Tag: 1760007496-817498
X-HE-Meta: U2FsdGVkX18A1ugKv+RPEY9HnUYg3cfErMSW+Yd5iYby9ZrdA+6akIse8YvOQNDpTvJ35rcqyZj83//O7QqJbdTFGEy5QSyemm6p3xyTHiaPDD2/zkOpRR7bhLgHqSs1H1B9q/8dsCu4tjGrWGjgDlyaH6RY/NH41+PCUT8l+f+Onopw3K0xHhPw+yLhRb3ySNg59kaJp+7DuMwFwj+VYIqCD91WtllTQ+74M3ygHhaBTaGrzbg5l9h+ru6gDJfkYJxiCmhOq7yYm60b8fUeid0h9YVfhK9/MtlTBqbjVMM41LcRjzIr24ip36jXTjIbuhpV36D5kRPnDH8toUtuZNbrLV0wtXPrPOs5a2iF7SWPWnao3eCzbI6Pf2Wc0q4wAu0SFKIIsL1hmscjsCk4ptClIH1n752tgodkQbU+dt0r21qqCR3NKMevYZXvCiTsJ/6ZvaiTpm5aI9V4t06LShOOvG86tkeymMTFRyZ9qScry9OpPp9Jh4H3UD+1sfXSnun9ZMMrjesA2oww6i5Xfe9736AK5edjVBoMdz8grZmW93svOW+hw+s/o1DbMQ/0H3BfGXWbyGDHyDkNPp0WozEIDtDXwOmFgCcJVAtnedq7Z+r4aOx7l+86YIe47ZxEVzxDlJoaa0Oahg/z96qzZq57L5NB02qVUUXBFxAOHH29NBkRoFl+Ef0mXfIq+hD4nxg8BPBoGRNeWKBEcoWKEFdYE+D7o92/Ce+4Q6m80+39ehWFtK6pYB3BrRcvjPt1kpVPEdfF/HIx75JYl0iXhQeMmHmttqLOIYTRp4G+EX5/pLDiEkRnpBdVHucAe8NzRxtGwe5J7UAtcjfTMKjtCnyRx4+Oibo1jb7YgKQlNZFKRz8y1yMYo/ks6iLQvVEOTcAciz+pFVvC4/AgJOngPgQt8bpEd9es4SeYg1S4UIwIUZFeLjRrQnNLCGwprSZg7I/4zRdEDD+shIvXrF6
 +d6Lk1XV
 vr2NqEORo0UTZPJ4Zbva9CrSmNIeAmAxRZKqO712jn6l+9swKRY6YLZkNrClimC83SCVhE0rc06Pq1Wtx6xsTfPzUUhCaVfAriQZum6UOagb4ZnwOrj6UqVbTjbwo8buRFhnIVJRS5744AAAnSJ5iEU9scQaP9k2KziOds3MCRp0R0pSb+Vxiy1/pmEJ6f7x2w+mnsBYZLWyVsvTXJ04bbcI+/yYH6VOB/dh//nTjk0Rl+AB6C40TYM78xD5yh27b0wLYkM0u0qfJc/YtvVQmlU/i93GsCPyNdl+1nHe3Svjxywuv0sWuf9B8769FmE56iFk7t2fRyKATe+amQbjQDo3QEzUgpSkjSOjnJP3LoAjQ+ZQBdxpOPR14iDEk2jppnHNNg7qKZr5R5wpszwf27CejjSTvf/jm+lzf3mUm1JNQW5wpIZza8LVVcngRCQwn0Gh7XLNKKyC2CD86k3Prw55VJaMzc7U31DJCImiYgIN37GSw369hn7wdJQd7Gp1im9V4u6iW1+5QSiONhPAi1uAz7n/V9w7WnzjuUjSEUHDNBrb3pDYiICCJUBCobWbx9g0ioiFZFcCjv20EMgaTyJMV5A==
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


