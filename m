Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC96CAC5B3
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C529F8E000F; Wed, 24 Sep 2025 07:51:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01FD8E0001; Wed, 24 Sep 2025 07:51:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3278E000F; Wed, 24 Sep 2025 07:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 941988E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:51:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2207087865
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:52 +0000 (UTC)
X-FDA: 83923979664.01.323384D
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3FC89180005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NgFIPFrD;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1KSy0afhoo56zSKFToL0Rdd0rZ5LRpSk38GpQKE8pg=;
	b=gWzs87tUA1v9wHidcyR5ndeLMgfbwj45PQukRlu/lTCSY4bstCHjR/FeTTllbKwaaNukxZ
	W2QTU55tf70NRRBDbOfKp1KV2/QWmZbAUZY0I+hhFwejL7qgGutsQQbsa+OL59TsH8fgeu
	/mIF+eFT0izw8kHuGMmHvcJUwZd5RAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714710; a=rsa-sha256;
	cv=none;
	b=gnwGvUzwscLpr9pqL3Sr7HjwcS5AhZShLa2auxUh+cx4vzZOcEr4iJ/ShQwRJnSokqttqo
	vxsORt+wtU1IQMz5zOYOBSL17pv9Evr7DMSkQpl4KNdQhPSRJFMvaVfRjU2Rul4xTPeGlF
	KsQ9JyZYcuWeAhrs+H+/f2eY75Pgymw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NgFIPFrD;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77f3580ab80so3799853b3a.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714709; x=1759319509; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1KSy0afhoo56zSKFToL0Rdd0rZ5LRpSk38GpQKE8pg=;
        b=NgFIPFrDH2m3azpJRaMep5w5xOCWlFiyXTJEXuDuXivqi1GmsQRjQwen5LdOGh8yT2
         QwB8aSElLe6az5IQQV2f3yPmmHgWizU2R5LAu30zWzUdZD9s42EXuQ7Pt/FqRy67VE6A
         sNQzTnWLSYAmLpDPnekWn2ttNtlR72mkX5xxLd4gT7+DPAEHIw2rv8Z+74+oAHZHi5tY
         dSY7dxo28d1X+OHx+S0apLOyn1n7mlVhUR78tycEP10Rnc9JNORdl4yNEVrL79S1Eocu
         ulLezjQeIi2DcYlTjsRpkrFpVe7DoKzD8xJa/XJM1i682nkimiKN4FeTq/FLmukHU2Nk
         fCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714709; x=1759319509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R1KSy0afhoo56zSKFToL0Rdd0rZ5LRpSk38GpQKE8pg=;
        b=qaUm7uJIaApJ9QqdlnGzOS5/UW3+KvwHu8bIghgpatealXhj5lEr29eQqVq/zfZlMy
         kKOm3wPA3Yf9XbsWjkL0Sc+IEIsFlmpvNlzRok8t5xDw5qzzAy77HEj8Qy3ozQksPnw0
         1HStFbHpN6PJldrUSng+ALEXx4WRIGisJ59YU+AyntJZYldhgZqycyNe/cfpWdRseHYF
         SxWfkck4RtIT8IyexTvsL7zy9IoKXAvWdnkl/U7SBR7RwQL6bV1oqvyClUKKk6Yy1Gyj
         oSm6cBQhdacigzXkVPVC/2mJJzm7W8TaTmG7LBfVLDcuCSGA2dB+HzY0SQC8bwjiJ1uQ
         b+cg==
X-Forwarded-Encrypted: i=1; AJvYcCXBXv09E+4EtNCoPHV3fi6RRA+1dafgahhSzBWt4bH0TvLUeirZBMNkoMnYiEU14U9k8qP/BjOEWQ==@kvack.org
X-Gm-Message-State: AOJu0YwrTZRbk8e5UfQU7cvMWgVquseg1yCuRCParCOJkNfZCG4bngIp
	1cP9njZGxgPQy8oTqKgGECJO8klfgs1dJG0ZZJ9J2sT+WaY5yysCM50o
X-Gm-Gg: ASbGncupiBv4gnteOWvTeFf++O+u8fSL8+5z2w6FyCapKkfn2EAE/H1PkVgTJNFRsV3
	Jg6Tu/TZSAmA8XNpc+laRyEjxsiN1pRgEF4MhAgiMGmwzY/cTOqg2SdnogAUFldVaVxi/dDgvkG
	N7UqlGwWmksTrR0FVDE6mWDynsYrl5xigIr2JyJ+SBkXFjbyeasAAs19D7gRevI6ZEYmDq8G0ti
	pMGc3VN26I31QtwHckJidKDD0NW6UK8zrxim5g0Evhw956FBabB21NEwnL8Nqb8TluoBkVkhNcF
	j973Fic3nzdvLT9tTszIzrp9gwNgGE0ynIldA2FvtHoX6f9CqpFqlWkrKSXVRru+QYObXZ/J4bl
	8+pg3L1teCP+xlY3dHD1s03dQZNmK+FqPBOwH
X-Google-Smtp-Source: AGHT+IFQ5u0/9s5WpxjOT+F0EeKSWL8MVQatB4w+7WUjpnJ2Ax15auMJ/gX34AgvPJn/yfLcWN7oSA==
X-Received: by 2002:a05:6a21:3286:b0:2df:8271:f08d with SMTP id adf61e73a8af0-2df8271fb8dmr2764157637.2.1758714708983;
        Wed, 24 Sep 2025 04:51:48 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f5f9a45dfsm3248137b3a.7.2025.09.24.04.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:51:48 -0700 (PDT)
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
Subject: [PATCH v5 04/23] mm/ksw: add build system support
Date: Wed, 24 Sep 2025 19:50:47 +0800
Message-ID: <20250924115124.194940-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3FC89180005
X-Stat-Signature: s91gi9c97x5tqpkh9pxdcu57r4drs4ox
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758714710-25327
X-HE-Meta: U2FsdGVkX1/tcEb8exQ2Dm63AMNq5cc+NBzRaTeda5k3fJhp/dZZEPPLT2Jklkgz53ywK1Iklhxb25R4A7RTdsZhgSUUyMaY35v6gDYJIBGu3FalN32qiyU1c3jQIpbzVNkatk6l8JgmxtsBn7B+7qiOgeQkwNPu5IxLGyyAsJ+Z+R7d2n1ot4UHqAqaKsip15EQ3lqSrK/kHxnRgnPLPljVynfKe0iY9vzw94ItE9mNTdsYP/TAs6Zsr7ZfqirnQZvNvyuPUX5gfftBkRqgH83cEMXp6Gr+Zpne+OJS9IRdP79i5wjxu6DTMf1QTdeqzysqKx8Lge5NZJjib52mUYKT3wMWkro1iZMmmFWS4cFDqCCjZlZnWwAWdRYVYyrT8EbV5a5/RpVOTrf1mtIUqR6hKJyX0d5LZtNElsW7nDdSNZ65p6fcVij5iAfvB38DZbG/VB3xYpObCsipEC9iquAIMuVLzBVWbVgun2NSU+2IMUohR5mW0CMyuKvzaMenxl1QdzhNdVh2ixrsVivuGVMSQGxXYVW1jSItdn0aX0mIwNb9HRPB2jo4dfobjVTj9TikPsJcnByE+uRrcpiVudYNIAmh23UEtl7HD5UvBRIfp7/CaUFUdciSKQxUXjbk66I4XVGWFUD8Kf8vClwGPtqXr3VJVCc/8jeQ8nhoX/ZXqaijhioTQkM2prGGxzCNN7kBNXFRPH6iFTCEZpaa7BeISrTJc+9ZjoKxv2ayDopqw//wgA6wUTY0aY6TI6inP/i/jgA4IcrNPj7U7laq7F7Ow7ZKQV2QHuMEDc5uMKQz6MEII3xNrxE9ZSd7Cmxh2xcw6rk79dnSXIcf7eENafkYYDz8pPgKgc4kPjpt9xYmRiPx7onDaEI1a3EpMH3m0VznEK1/HdBlTquURhchyTnJUEiL5g8CaL6HilrWu3eq7UTpKjq7vLONLe/sH3DX8fdOwtyv6v3WzKwJQ0y
 x0hPIzYH
 AAJw3OyRJxYvjIJL7zdmAZ7J6ws8mRnvmnJ7GNjYOvyEPdMHTxENCay5j1ubtWagj45Xf2y7SXOOqqsgMHqWr+UidVf3NYKigwzr1gtGwwMvdcb3Qx/1kz/nFbFFbzuCuWZYuTiOyy/aCvkcuzRT0DxXcOiPq3hq0QoN1sqJVAm9HeU50mbGxlRNWtGk98E3CB02iDf4ZsB80hfB75CoU3VOmzjvHzq36XOD0JvXGljZbIMOrJ39edfETSQKDktAb+iQC0GqkA+6BThWJWC8f0XUjK+dsW+ZEzjHkE2Dxqs5wzs+RmIjqbHlsh0Ot/iCbNeCeMDXGeurk7PE6wJgnGUsuSb/+Jk+exzuEOlvkWs5t3XDCN/TJqPvulOgySrFseJAF3c6nQKlIBzdrIMjeei26saK0P+6WIcR9SC7inZXZy/Tvb6/LbncMp9mqehpeEFdhRbG63oHKv5O0rNeDMUHdOhqsPZZwx54Z4+/ucDEGtoH6EEPNnOcJnmneEdSAkAqfnfYT09y4DcCHGpACzuWOvrlKHul/G3G5Jt7vQEXPFNf+YtyogtBxfjD+OsxtdPoycc2kk36NMD1KcfTFte1BeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Kconfig and Makefile infrastructure.

The implementation is located under `mm/kstackwatch/`.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/Kconfig.debug             |  8 ++++++++
 mm/Makefile                  |  1 +
 mm/kstackwatch/Makefile      |  2 ++
 mm/kstackwatch/kernel.c      | 23 +++++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h |  5 +++++
 mm/kstackwatch/stack.c       |  1 +
 mm/kstackwatch/watch.c       |  1 +
 7 files changed, 41 insertions(+)
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/kstackwatch.h
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/watch.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 32b65073d0cc..89be351c0be5 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -309,3 +309,11 @@ config PER_VMA_LOCK_STATS
 	  overhead in the page fault path.
 
 	  If in doubt, say N.
+
+config KSTACK_WATCH
+	bool "Kernel Stack Watch"
+	depends on HAVE_HW_BREAKPOINT && KPROBES && FPROBE && STACKTRACE
+	help
+	  A lightweight real-time debugging tool to detect stack corrupting.
+
+	  If unsure, say N.
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..665c9f2bf987 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_PAGE_POISONING) += page_poison.o
 obj-$(CONFIG_KASAN)	+= kasan/
 obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_KMSAN)	+= kmsan/
+obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch/
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
new file mode 100644
index 000000000000..84a46cb9a766
--- /dev/null
+++ b/mm/kstackwatch/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
+kstackwatch-y := kernel.o stack.o watch.o
diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
new file mode 100644
index 000000000000..78f1d019225f
--- /dev/null
+++ b/mm/kstackwatch/kernel.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+
+static int __init kstackwatch_init(void)
+{
+	pr_info("module loaded\n");
+	return 0;
+}
+
+static void __exit kstackwatch_exit(void)
+{
+	pr_info("module unloaded\n");
+}
+
+module_init(kstackwatch_init);
+module_exit(kstackwatch_exit);
+
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("Kernel Stack Watch");
+MODULE_LICENSE("GPL");
+
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
new file mode 100644
index 000000000000..0273ef478a26
--- /dev/null
+++ b/mm/kstackwatch/kstackwatch.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _KSTACKWATCH_H
+#define _KSTACKWATCH_H
+
+#endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
new file mode 100644
index 000000000000..cec594032515
--- /dev/null
+++ b/mm/kstackwatch/stack.c
@@ -0,0 +1 @@
+// SPDX-License-Identifier: GPL-2.0
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
new file mode 100644
index 000000000000..cec594032515
--- /dev/null
+++ b/mm/kstackwatch/watch.c
@@ -0,0 +1 @@
+// SPDX-License-Identifier: GPL-2.0
-- 
2.43.0


