Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51498CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02AB8E0021; Mon, 29 Sep 2025 22:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9EF8E0002; Mon, 29 Sep 2025 22:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B9B8E0021; Mon, 29 Sep 2025 22:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80E5A8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:44:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41CE613B454
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:38 +0000 (UTC)
X-FDA: 83944373436.24.9C1801D
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 584AF140007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xkm7udR1;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLL9szq8LgdVljgQmrpuYN0dKjRbhwJ4oBDbEm6eF/Y=;
	b=0whuA23PwUUPdZCJRCDzBBvv/EwjBkH35pwNizuutw3nvmQ59rW0QctVKyqoAc0xFRVvcr
	ySjkl0sgPYSxQg/Mor20m+9ACmZ/mlWrqA4nFGl4Bs/xGRIZ3B48q++bZ17MTCidBdrq4S
	3S4nl71kEjRnQzwnouf5NOY14T2G1mw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xkm7udR1;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200276; a=rsa-sha256;
	cv=none;
	b=t8WL7tBv1kNIGgIFsen564o8RmOEYymvnA78R/yjMPOQAZ8jarCZ717LnUbuUbYKHy2p96
	2XL8WLYL06MAYHvFLwGmdhOaWU+8U2XuehcT9sdDpUJdXRZQhx1VafRCtyi95kT84cn8WI
	5LNmHaqAqMh18l5M5NVYLDVor0KPTjE=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-782bfd0a977so1880789b3a.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200275; x=1759805075; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DLL9szq8LgdVljgQmrpuYN0dKjRbhwJ4oBDbEm6eF/Y=;
        b=Xkm7udR1WR1RsfCF1YTBqfbBo+8fkB1RnqG7te2nhkmV4R7HysN1HMq64B4knrC8bi
         yeiPDfxTCdBQsaaYnZnhG6M88b6M67NSry/4wXYJPPSynBCJN3PPWMWyuO2ZmlHjRNRQ
         qytE+5ARrm5qFv3E7LCGuo/gkbWbORlbSX8ewdjWeFm3blhtnHad3T9PT6SJnvDPhh1u
         AE4OLUUjijlsfQceUBKqg5jAwvJwYiUI+2krwblvEqwIRvmzKhdo+QNg3zW9vZtYfV0J
         vCl2dlzc0Rg+/x22G/CRrC377XlzTJlbTHfcKDDI6UJVx1A8L6WkAUX9+9X1yIr/JXcI
         dI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200275; x=1759805075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DLL9szq8LgdVljgQmrpuYN0dKjRbhwJ4oBDbEm6eF/Y=;
        b=Leb05yU9hN68PDYCLrx49Jkza1MKTbQ/iEdu0RLiC2nDsBOSayvDtLJkDqvybnPGDN
         U6ED70/ka9jSK4OGKsaSY/Z3tedHMVdVGNu4LKNLqZ2HrHwvQQg9VjIwaVxYZq50UR/7
         MkfwhbcMIFqPOW8KTuYOWsKBgUVqf54WDfbprGUPx5n93cG/TgdaQXxIcFfInGB1CyLV
         l3jqqfcM0FcXmggslkPM7wx5VjF7IJN0EO3urJBv/7WFRMV1jLEy6mp1Z8V/ZR1vRbfv
         Z4R351DJwehyQMCX6iIQ7698Lz8UOEfS8tohxOEA+r/13d8sDP+/jzw0B8ZFayp6p8da
         CDRA==
X-Forwarded-Encrypted: i=1; AJvYcCV+8pVIVqRY0bQXx6x33dClXcgkx6uuL4nnNVvzLCdo+cZ8N9zGx8rpSm2aR3Z8LNRIJ2OZ++xmuQ==@kvack.org
X-Gm-Message-State: AOJu0YwRm0jR6CFPvSNJxbWXA7UHI20zC6rT9bGlmejX1DUQ6pEbWmzg
	xnF4HmEP5A1g25Iyda2ygIaE4M8usyxVZOHjUrjZlZQr5MaLfauP5/R1
X-Gm-Gg: ASbGnculq0sAHjx8Yi/gplisXU4THhNqOEVnphL/7FIBexuvR6e7Oy5+P1oVN07qdZ8
	Pj0gztyC0CuWlKE05Dhpa7hSg5LmT5zSIZv4+hSyxJGvIzcs+T/VwIoi39RqqZaqYUwISDMv0qZ
	tCcc343rEBNzGEfu689VvmWE0tP7ObAWCMnuyBY6D+bAVOJT6U9hbdyjmK1SsN0y3Hlev6UHGeX
	ctsYmYhhcorkSSTbin01RMhTA3LkKWub+xNDCyyDdGTn4JQu9IyFO1mSBRBZuPots3QZm5/a0MO
	eY9tOL1H3f1MFa+LWAAmHZfpA9AIPbKviVtLiLlIUssSOGWh2gRDogvDOoTG5Ys4+L4dOlGPkSJ
	K0gWEq/fU2NZG78n9iq2uYdtdFNCPgrADifGQ6i8WJ+i9Wy/9exJM0dhGfAlkjv2Y/9hNPOhQuz
	/c
X-Google-Smtp-Source: AGHT+IFKAUJd50skyQZezOIyRCzitP2KYWlsYqho8uHybu50MFOQdhfyrcEbVkIiLwip8Qb7gZ0ySg==
X-Received: by 2002:a05:6a00:4b46:b0:77f:416e:de8e with SMTP id d2e1a72fcca58-780fceb5040mr19851033b3a.26.1759200274983;
        Mon, 29 Sep 2025 19:44:34 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7810238f11esm12449091b3a.19.2025.09.29.19.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:44:34 -0700 (PDT)
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
Subject: [PATCH v6 04/23] mm/ksw: add build system support
Date: Tue, 30 Sep 2025 10:43:25 +0800
Message-ID: <20250930024402.1043776-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 584AF140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i1r75k5uen3p9pa5pgwdtoc19zejammd
X-HE-Tag: 1759200276-118583
X-HE-Meta: U2FsdGVkX1+swWkeBJHJ74P3zCRczPehP0TPSnxnunkl+YvtwaoFT013lnOIQq64PbTBnya7LWlZtL3TQ8HXp/DRKRpZ63PSPyPTrhB/HoIiXfoy8mX7pTTqK3rCIdMuJHS2w9c8qIwLS99W4Us1CgIOumO1IFc9h9TkaYcz5W3k9jhPkM+DZcl20RXMRVrjzz8ei16/on94fcR+T+NtTS6zUjOTxthG+TEZQE+l9cNeJtwCE8VzcitHg4D3ZHOoupGOA39R6P8B/PBlw5HuWFBqxhKiWybRM316CeU1J/3GCUsqkIyGjrzkJibv9Jho8B8qzcShIMa0/7t547NhiKrlN3IeGInUvJ9K0p7W84ppL4bJrQXy6HE1LhKy49JKlsGzYazpjv6bNgieprhSoN+LR/g77020lMMpHPrFANQoswI5UZgZAAHzu/HJ2lxLzEdvCWbw8kUwI9YK1oYMDyHxqwn1ywUrNiUXtVcTLyDCyJ577tqsbTSrETBrtIl+zEmrbA3Thgu1asgJ8Sb35qY/IdmUep88duqRN8YlbcrpfnEuvfstG9U1jlrEZCfoYBTis4kxmBQ3+uFIPl+6Q9UUTpdrtobIFrCRO8ZqsPhQPY4ohKg1XwOiiqibHaNCQiUManFbzunT5Wvd6FSGo3YV607o/5nU3jyKc9zJNqgfOup/wm7TkVcK3ouXPFNCOJOEz5m6UmXklneuLEVK2CGUKZN0iYlUt7ZfPfrV2UJ6QmJhUzsMEWrdY10oAIFbSVDo7Te7hEDLF7t/Syuehy+HmSPH2GB3bu63Sv+KoerEtz9jyUZSRKVA9lIzrGJpe8G42rlqvd4H4h+nff+c0U+QU8LFaPpAR6tYRger0AhUdLJOsR2aUfrfluXrAFyZechDMKdg7V1kD1a3L+8uAOMSXgRAd9xlh0kjm9eR9f44wupjVpQFaPvnDMHKMxTW5sVYL+NIam7QtWEvNKg
 Al6AFm0L
 KOk4Acje5SmQMBzUrnhQa2lc3ye+k0xeUhfnz6BH09NAHADda+jGRodbh5bPltorSTykRbowsi+y5zudpcgrNzul+TTsrwKdwZ5ACUYr4HlSi4FZ/VbK9E/VZMg3ci97Pcgj+TmyKpPjg4OGTB0nRJp1qGXFWypb9n+wY5n/gpbc/I/ylw3hsoyuLv15zBijWolrdbWg10IVcFX4uq58JNihGeuY6YB04uqoB5xvc6Z28UVuuJtJNnoRprrdBAd5bLrGzayopAV4cYXCsQKD82HhR2wC3TwDbg8Ld5lIcD0bMupXhR+kJ21qd13hTn7ngABB/Z0aXzIeJ59bZKb0wE1HSg/nE7rYg3cOlCG2HmujlOucKF0AST8Otozz3SlUCpDUntyzwVlJvnOm5pyirmrW42bHAs3V/PANaeKBE+Pg9j8/1NW9+2PDj0drEFl89nFMq1Igfvv2PI5Wir042BzzERgXakb/et6a1CuA4B7R+19nakRgxnfud1foqSfOKdWWuoMv4gdnX8Jpb/40SqdODxCYBqL8JkEpWAzikPt1TgZovyZTpAFazbNg7yHM/HyYpKJ2MyTe8H3lueIUDyVSd8A==
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
index 32b65073d0cc..24f4c4254f01 100644
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
+	  A lightweight real-time debugging tool to detect stack corruption.
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


