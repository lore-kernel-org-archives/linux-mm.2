Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64BEDCCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8CCE8E007A; Thu,  9 Oct 2025 06:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CE08E0002; Thu,  9 Oct 2025 06:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05938E007A; Thu,  9 Oct 2025 06:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE6E8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46B2F1A07D7
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:26 +0000 (UTC)
X-FDA: 83978274492.14.9FF003A
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 756C9100013
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BLCFjVUj;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIQpLOg8aMQquhlHBEOSk3mXNexjDr9DRSMTRRGj0hA=;
	b=2Q50B0MCSYs6DDZ6DNczsTZ1dN5bLkgBsgjxlrJoUn8TaLhY3SCJBPKb3+DZxWaE7yvzx9
	ro9llsFnUFkhtSq0IB6mAnLCNZuvF1VEzrGU3LJlmK1Sae4IOut6kBY+Fa9/wKGZFqHn1T
	8IxDn2NPXbROQXVv9lWwJeyDYJiSXYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007444; a=rsa-sha256;
	cv=none;
	b=d+6xGI04tw6Y7GM29DztfT2POHSpT2RUs/GwClaKHb6GNgx/0u8Vsa+6A7Ot3tNX7hxram
	xBIhxTgfmOVV+Nc9txiUjKxbuporBBqsfwWGufAWo4C8JIeBQkx4yaJHfhZ6gXor7IZkob
	gCzQuaGKt4kRCcQz7WxslmiJdGYlsKI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BLCFjVUj;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-28832ad6f64so9171735ad.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007443; x=1760612243; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GIQpLOg8aMQquhlHBEOSk3mXNexjDr9DRSMTRRGj0hA=;
        b=BLCFjVUjGmYXs+2/drjxflM2ZPVabCKGHrIRFEXcxhAVBIeNA8e/dtIXT2Hjdujsgt
         Wr1TMb/J2ybmMDpfe7ajGePhFrngVlztjOLS+3EhLWMiM85m/RUWpVrwQXPUAzno8PaZ
         dFy4s/jPzfl2YqFVaOfssSYh2wbwjgrs/M/kOUxsd2q/VCQnXwhJSY9CIxiOgUiGLlvM
         xuXDv/xtIRotPYUnjZi4yBgc7DrD+7+za1Cjz/vUqZ2ReZ7LYnf2nALmBC22wyie395k
         EDXNA8eoqm4fXffzUpsjMRzIMStC+Q+Bc+I+nzb9MkIlSvkdSvSvwPdtwSFU0id/FywM
         6Y2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007443; x=1760612243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GIQpLOg8aMQquhlHBEOSk3mXNexjDr9DRSMTRRGj0hA=;
        b=goBcbvruZhti9XLo8UGhFp6sNy6C5ZYF7REfuFODtEgcSMRUUkuz9N98HNwRNqHfnM
         HjqJYVKRzwiL7JDq/jvaWw62y4i5fz8jfFXI6UzYQ4fNfM3FjRgnnoEVUEBZmA0A77mN
         5NPcqRQneIEplxczihcbLZdJ+Xz8QREAeHyss6KsFwvpBvkIkL3BAJ1vMJrPlal7rlbR
         FI3o0v2ZsscrHdGIyW1KeCNFO6KFHVmOPFnNBOLu88pr1Q+urhsYVBKbqaA04zA2p7Zw
         evbsVK/cMZOqIHp26QyLwD7g/DSibFzmezodT/jDdQqNAJNY0p8yxmO4bYv4XgUzRGH9
         h+VA==
X-Forwarded-Encrypted: i=1; AJvYcCVqKfHtyfysQaVFKsJfUsLRmTDrK4LjMbWPoFL00y/WrRjqWF1hy3X7uvMOIaZjmPlrJbBWlWI5Wg==@kvack.org
X-Gm-Message-State: AOJu0Yx/JTtBRosnLFJbuwXZAa9Yv+cMqg2CmKrB9/tNMHi35poIt56X
	6j0aazE/x5FwNM1IfKEyA67zXDebXlLbzdwJUPVt7CKaDPe/XUKhTRAV
X-Gm-Gg: ASbGncv3HfFmb/e8BJzJWQ6yXdfTad5aPyU2Ai5d4i7O5Ue7dnTEFWxuDd9iRkjJzmb
	MDzc3OO0aCbYA/qZAlDSec33/qe/LfppKxhO8d82K3aAOFilvyQcjBijiHWSV9V0KZjbNMBLG9K
	QqgJZJSvzLruh6Wf+36DCF25lRp3mHkYvjtD78WYphLkK5M+u87zIWRfmEybmrGFVKq0SHBjvuN
	aZwre44lF1aDa2xi3ftkctoPTvjbzV+fwC7tU6Hd+vHrC4ZQdpmGqER9uPezjAINg8CW/tBkZI9
	h1ctu/mXBaDMqUGsDi68+GaDdL+2jkiLpZ7SqapwWPNjGq4yL9bd4CEc56wXITq6ZyvetoFKijx
	3dhnyre/1B29cPdc9gWy7FRd+RERUt39bH7h6QJ/ki3f27L3B30CoMd1lixdC
X-Google-Smtp-Source: AGHT+IHPDBs2nQEEtOyd+SrR9P+qllZOyEoDd+ZmfNYqYrv5SYPcJPc74F2vXkjnYFPY0AXGIsqkQg==
X-Received: by 2002:a17:903:9cb:b0:267:c984:8d9f with SMTP id d9443c01a7336-29027266982mr95235515ad.24.1760007443143;
        Thu, 09 Oct 2025 03:57:23 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b511135a3sm6722720a91.11.2025.10.09.03.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:22 -0700 (PDT)
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
Subject: [PATCH v7 04/23] mm/ksw: add build system support
Date: Thu,  9 Oct 2025 18:55:40 +0800
Message-ID: <20251009105650.168917-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: wko8hmsjcrbipjexy4k9ccytxgqszkyh
X-Rspam-User: 
X-Rspamd-Queue-Id: 756C9100013
X-HE-Tag: 1760007444-987876
X-HE-Meta: U2FsdGVkX1/Wl7eoLOh83hY/iiBizzyB2uTJ7rdXiCYvI7nZwVCMfvtmCPz3zRWIco7tpWX01KBS7DRgNh1kPiDAHZ6eav8A24Xux3wGye6rC/vJb9Ccs7ClKQXhV+lxtviADf6Iia8aaZ5ashDTDJ5fU1haWaOQWhuvgxZD3/yJ2cl8uzXZSz5HrIY7H9e2Fkt8nxw7mrmtkjYgV4EvCA2MfN07F6kpwtah6UFJyTCMCRYri9Qt1ef4ZooOH+tL45vE1IhHyEl1PXxXQznIi2X4MeFMl5SYZGnxE+LCGMr+zXpuXAbdWuwrRmL8pklKRdd7dHZQAqjWIBcl3KtSARN8/ZD/22q1kmF6PKuD4Vw1BJJiK2sJW16r3OhaWiiZ4SP293swFFCtnv9lZ8g7uprTzeglBkbn2kPecAQXp3jz3YrqtxzcuXnrD0a8aG+9lXjViaFf/M4oMph5vL4MxPJihdu5IKcJkTHu4zbXCw/fxpEJXrBZoGsL3YkcxnHVqAPqRUkw2K0P42AxCNThSsNfpHfwxQ+7nZYtZ4T1fAPp+IjmujEfDDQ8IoBALZHM5Kw2nKXkzYAS2xUNsdrH5ZWEahB/LHekFaqQVFqrNAf6YehJDP4ALatZ52MLqlIOPy9Mkca0XIx8Hh5uyCr6YNnS+K3BkOWtOruSMFBURrnEEI+oYm2kNHRQmLAwl7ZPXmwSWOtKlmGdeQsmB1y9RvYT6dxd/eYpu4osoOmBK1PElQw1PoixQH6hT00uiWel//XLaeSQVo//YW5gIrdLcGXM4pSxUzAAQCZHfDLDtocwjfxWqCHWz5Z+v1f6iHoOy1psJDgjhz5YJspHCc8oYOgmWeoZC1F8/k/5f9gNfhGvcFV1UzJht6x9+wga5cY/DFaUXd/Ib1sX/D1s7ufZ9MRCff1j4XPdvx4OCqRVcaajncwbC9o7NrnsURvh1GIOXqf1gUp4QvY4X+lsrNp
 bxjV1MX4
 g5pxd5xZrjj13q88GIhAJCRz+4vXvewwW0hEST59geTegZzHheWNFmP9VYN05uw1xExcqBtzouOwrNgmyxIzqFsJf03bF8Wb0mS1F2qzmaJECy5sNbuYKEoeFGmX1BzDUwEH/RqksU9/Gy65HAGbOS9GxAGieNwxEdeI5/8zs0FvcNVnIp1undkPbxYT7A1f0zh22c0up3kwk5mM55zUp97Q4zdtKYJNYkOQ9LOuP/V/cHEMNxd30r+zcs90X924vWtl+nWPVXjeY+86zF7IrPtIoqKYmDwfYqPEQiPnPQXjrsZttqdDdfXySanCjg5oT5+edim7nA+rCnAjilH5Dj0AF5OfX06GAD1nHK7mooYh0v/2eAhH11LfKQ/AYRfOzgJIHM/NPy0TD/rk32YHGwne6NV3Xc382c+xMvZcT30wGK5D9w2qcl3ubGk/Ybpv7KpjOnNrTD5/VSSDCwXqfxsjMsAhOqKgN7C034Ji9OzreJSPj5HVB2Bae7fgNrKYhpXi/nbqgG4tY9LipzDr+SY8EKi73ZXJ+g5/SC9c2Ii/wdWwKWzC04/RsopdKDFo6eO4hrZcgeDfFZyQlH3YdIwG0EA==
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
index 21abb3353550..4d45fb69116c 100644
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


