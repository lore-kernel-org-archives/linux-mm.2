Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B710CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F02A8E004E; Mon, 10 Nov 2025 11:38:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7F28E0003; Mon, 10 Nov 2025 11:38:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B76E8E004E; Mon, 10 Nov 2025 11:38:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 364E28E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D95BD1601B6
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:17 +0000 (UTC)
X-FDA: 84095255034.21.79D6369
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id EA5CD180017
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XqmrY9Ot;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZgTPWUg6fgnNgIWmgc5f2sdICO+ed5Q8W3qiS9yQCY=;
	b=LBqUS/wN8ZaWxWd8F+O80hdAFX5i0HCplOfUFI0Olf3uICTpJ9MDtmWK4eUe1H/4BVUU9R
	j795HPYM1ZU/3HCsHT++mHINjjqejlQJu3P4Mq+eNcvgw1YO/f2YVh+FdHGMVG8ZuUFpyS
	fGEFVFBrlC3IMgusLGCYP1B0NMBISjE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XqmrY9Ot;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792696; a=rsa-sha256;
	cv=none;
	b=jKanoN56jzWG7DoJ47iMML0A1vkTW8LdW+LU8bEeo3X6y+UUasNpWS8qtE4Uk5MAYvJrW3
	FHDFGtR4SJU8qUqmULE/B77U4UAcp9CZM5cHnmzJ62K4AN499aN0jA1SXvNcJAW/3UH1Zr
	XBycxN0I/Cky1wzlSArFoR6hMYUikDo=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso2598765b3a.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792695; x=1763397495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZgTPWUg6fgnNgIWmgc5f2sdICO+ed5Q8W3qiS9yQCY=;
        b=XqmrY9OtDJTzWqiJU+4WycwirCZejpmYD6eEPnGSEAzUpwm4jbJjF+JdylRLcXOQ31
         JB9WTzevHVrAy9wEuED56v84/1+stvtcVoxHB84pYFyKUXpZo9P6Nm6JQqNipp6DdNQx
         lDDZgJzjOD/KtD05hoNsRMuRJOLLKFKCg73rXTsW/Dum3AamlBjvRSLS/7WfxbGJDYxC
         CZquXrYuizrzXPtRINs+V6p9EuYsPymNnVpmRyqVatq1OJOLllZ5aDEBJUN3A25nxAKw
         k9zKW35BYg+X23I3w9k8v7IoVfSL/XuhGveEJOLQkbFc234IYF9Srk4gKcnT17q4zCdK
         v60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792695; x=1763397495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LZgTPWUg6fgnNgIWmgc5f2sdICO+ed5Q8W3qiS9yQCY=;
        b=sbW+5dePBi/yE56w47JFcbIDEXZcaV8ODBlSBq1ejza6il2L2xhidBFu0FAhi1vgzc
         7JHeRccilJk+Yy/FqxxnbmiJtmQtNm/vDWcc/uF00NT718/IPbolOmWYclKEkFFULCF/
         +QO8QDshc25Lo/1yUtkcznjWMbCPPpEUjNP1GyzJFrgeX7MuU8bj/xIiYQ4lPk+aiiEZ
         uewgDUDPHa79qE0yaA4wWUSZrYb4sU224drZMQj/9U8TQrIbKRmTM1aGtkW7aNlWx/P6
         At0ca3ygMPbkGHeQVE/ELHrU1xJH+UuzUEERuZTAZdVnyw//tHPvfG6cOAVdvGrl5ZKy
         llJw==
X-Forwarded-Encrypted: i=1; AJvYcCV/A5+If7qGnzBA/H/rZb6eDElvzFnSAyK1iy2PT40J8M5RvfPkrZiJDA99L5ggA54pNp3jpObi5A==@kvack.org
X-Gm-Message-State: AOJu0YxiEtwWSXdB0hQ3xL/RdfTLBE1vUzUBvZSw7dE+p4JNjqKME2Vu
	PQmg5qOzaBdNNgzNMbIwCuTlaBtHyXi8cEkf6RJu4fFWpn7f+LjmFaD6
X-Gm-Gg: ASbGnctn4pgpOMKtVqdfYiAC8viRpcSSup7DbFI0UJ7axCuCXvCemsKanETIAOeRsgy
	/szeHKGsO3mtj4l1wdV9m8YpwONU0sS6rnxaz+9l1zrruQaVcXU0hIonszAO3dBn9HX9ZiStDKg
	XR80u7MaXkKC4U73CzgwZ1WVSQI3FUZiMpafO+Bh0ZssxEfmYRz5GLwFK16x3uqbvoGbQIXm+qj
	EZ5jldlubCAOTofsLLpeplnUstD3X1preeVzzcqfP3rL+koWxVJtlsMR7I6H+fhpQ3Nyf1AwA/f
	E46ur8ZaRsbuVwLyBSWoW9i6G+s3stALhURX6DVQhDVwRs7/a7/wS6zi0EecKXg/Tl1POadIAr8
	6SuypzlKPRYPzArdYRHIWKnaYVqAvOUwV5i4/Z40ye0V2KjUROwv8ALW0dhqsvI3/93YvWVfYNw
	8fAW8hsC7Z7hOidyTam4UUyg==
X-Google-Smtp-Source: AGHT+IEM5Su6Hnp4ru+i7ZTcc23vkwmNQiSNdXgOr/mmO6C717GoWpmDkvA/Iw9C6gak0AA7kGqiVQ==
X-Received: by 2002:a17:903:244a:b0:295:59ef:809e with SMTP id d9443c01a7336-297e564e380mr115227515ad.24.1762792694655;
        Mon, 10 Nov 2025 08:38:14 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c953d0a6sm12288816b3a.12.2025.11.10.08.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:38:14 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v8 21/27] mm/ksw: add test module
Date: Tue, 11 Nov 2025 00:36:16 +0800
Message-ID: <20251110163634.3686676-22-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EA5CD180017
X-Stat-Signature: ujh9e8fiuxfzckqrnxgimykyzx8bumxd
X-Rspam-User: 
X-HE-Tag: 1762792695-389161
X-HE-Meta: U2FsdGVkX19CdsXTHu5oGVQ35eLP7jtrpvdkipRnPIzk+Vnym2O/ZdVGCueX5HHxW9vtrc+Nz8SYbpUa1lldDs5PV8IRnPZEezbd54Ztvd+RAwyjmKKdsruRD5rgSMYGjQzSn/WMQIGkD+/dDb6yF/oZc4k3YLWhxMIsE+fwICZznrJm4pjfs1y/UXNIOzuS2esNzCOU6d++vV3C+TpBSG1rrCAGkm+IkqOvfc5zejRGG61Vend0ROQbkGtoT8aVcik1StRfWpbamw3tNJ3FpulHArNwGli7NN5hyGz4mLqAiC3KnN5WZQwEsuvbN72i7scK3vnZlb7keHszrOVD6PHK3utDXjI+NxvaiZwsA+dtTDCC7pLvmD3CRw1muSajk5QY28LNlGgpVrl73IaCcOIXJYbpGmtS0bQMUk5zT1eTbypWRCgrWF9iQXqpYd67ohfVsKhrmSAfTvjRa9CqoJUW7mxRioIONmtnuoGWNL6UNyzPTMxqaA06AD0NhC34dpla19wbz55nUQRaAmz/WrAePevgzQmwQJ3bZCEdsuq1cgMPdSj8Bx02IR1Go+Vr1PRyKLTwqByJlBhD42LMfon+xrl/1vdgUdi+CxqSmJegqOF8XxbAGZKKMCdFcck0RD1gRQ3UUA1RnPyfDBs3trt9hgFrbovwBuNOdf5gMhMWo48USIX4zTnN+XVPvt1m6WslY2s56EtzQrYmr57oScCHXG22eC41j+wDHQ/8hvoK5jLR3QivNtKZhB60VtECcjHiJyvS+xsnNfr4X5OTsHF4Kt8zgWcV0SlLBzhHUSfTHAmV3BJWn77Onni9AW3sIN2gGlcMHyqCccNq7GJt5ZxFsExo8Eeyme7fUfcmj1LQJWrl1KaQoOdn/1GyQg4LJEtOanlvXNYAEX/MRBZlu5LKtFjNMbVxl9pgimwU7a1sMz7E5tedWimf8kHf8jMZ2KotwR44X3htWgE3YaC
 xPdPg3mF
 eA8kFjSInkKErUcROoQqna10yM63wXmhxzcyV+q2sn+ckxoXvdTI71BVeuiklaB1kTbY0NfMaBI1pGSZces/LU/d7ac5n5j3JBI8PbtWc8YjJX3kEaNLe4ZXzirCMGS+dZCMgUbMHxIpojZkT95eJiW8eb2DdJH+vcZ7hpCnZY6q2Fosiwu1WpMbN9IbEdTzNojDS2B9RZiTWOIL6Ao6+Kb87JyEq6UET+1tx+6Ja7SuwMTlN+GNQ8BOS/xuUnlVeFN6LnWDkqQZVum55aegDT7ED/7WR9VoLGvadQHz4I82TeJvC1lgyQNMkR4vkXGe5jih6XreDQIyYSoWeGjgt2bQi+hxbecM5XvIvWnzqv2+WTFmASCQnbPDql5YiXAccUxua7RjyfcROX2GkCoGmcecI6epgbEDz3HRtZ/yV2gePBhKPf0X3Q+G1BIEnCekEAQmuT34VRR51wTABs8H9PUVyruufmCHXv/eWIAdgkdYkzf61R3ioSyLOdFtj4sO3dhJZj+Bl4meOSWM=
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

show addr of buf and watch_addr of test case
---
 include/linux/kstackwatch.h |   2 +
 mm/kstackwatch/Kconfig      |  10 +++
 mm/kstackwatch/Makefile     |   6 ++
 mm/kstackwatch/kernel.c     |   5 ++
 mm/kstackwatch/test.c       | 121 ++++++++++++++++++++++++++++++++++++
 5 files changed, 144 insertions(+)
 create mode 100644 mm/kstackwatch/test.c

diff --git a/include/linux/kstackwatch.h b/include/linux/kstackwatch.h
index 6daded932ba6..7711efe85240 100644
--- a/include/linux/kstackwatch.h
+++ b/include/linux/kstackwatch.h
@@ -40,6 +40,8 @@ struct ksw_config {
 
 // singleton, only modified in kernel.c
 const struct ksw_config *ksw_get_config(void);
+struct dentry *ksw_get_dbgdir(void);
+
 
 /* stack management */
 int ksw_stack_init(void);
diff --git a/mm/kstackwatch/Kconfig b/mm/kstackwatch/Kconfig
index 3c9385a15c33..343b492ddbd3 100644
--- a/mm/kstackwatch/Kconfig
+++ b/mm/kstackwatch/Kconfig
@@ -22,3 +22,13 @@ config KSTACKWATCH_PROFILING
 	  stopping. Useful for performance tuning, not for production use.
 
 	  If unsure, say N.
+
+config KSTACKWATCH_TEST
+	tristate "KStackWatch Test Module"
+	depends on KSTACKWATCH
+	help
+	  This module provides controlled stack corruption scenarios to verify
+	  the functionality of KStackWatch. It is useful for development and
+	  validation of KStackWatch mechanism.
+
+	  If unsure, say N.
diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
index c99c621eac02..a2c7cd647f69 100644
--- a/mm/kstackwatch/Makefile
+++ b/mm/kstackwatch/Makefile
@@ -1,2 +1,8 @@
 obj-$(CONFIG_KSTACKWATCH)	+= kstackwatch.o
 kstackwatch-y := kernel.o stack.o watch.o
+
+obj-$(CONFIG_KSTACKWATCH_TEST)	+= kstackwatch_test.o
+kstackwatch_test-y := test.o
+CFLAGS_test.o := -fno-inline \
+		-fno-optimize-sibling-calls \
+		-fno-pic -fno-pie -O0 -Og
diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index a0e676e60692..b25cf6830b15 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -235,6 +235,11 @@ const struct ksw_config *ksw_get_config(void)
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
diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
new file mode 100644
index 000000000000..2969564b1a00
--- /dev/null
+++ b/mm/kstackwatch/test.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/kstackwatch.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/prandom.h>
+#include <linux/printk.h>
+#include <linux/random.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
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
+	pr_info("buf: 0x%px\n", buffer);
+
+	ksw_watch_fire();
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


