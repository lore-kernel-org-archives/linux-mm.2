Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA9BCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4956B008C; Thu, 18 Jun 2026 08:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065696B009B; Thu, 18 Jun 2026 08:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBE1C6B009D; Thu, 18 Jun 2026 08:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B83FB6B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:16:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FE5E906C7
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:49:13 +0000 (UTC)
X-FDA: 84892560186.16.9E0C7AD
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4632018000C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:49:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lbn+zbJL;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776151;
	b=gVLIhqfg4A43TTsTlOUD4eT1FAM5/6DrjZ8OMFRokeAOXcegV+WnmD3BbH4ML/b1mJnx6u
	jCJd4ywnBiXFxmLAqU0YP/SdDI6/XuVr212Upzx2K/2uJcQ2cSp+eecKj4CZ6A8XjiFFFB
	GrDJHDqWxk71kGw6vE03lppXRihVqCg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lbn+zbJL;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZAtuUTHJDOiKLx4zrrhbntE6nPwfKSnV0j3f+6dKp0=;
	b=S7MKyTZkZZxxgTn8pYaqSUv6YbsntGhztt1LpVxfSzB2LZTJauz/Tc35p2ev1VE1Z375SF
	3BJqDl/IZbDarg1GZa3yn1J1Xi6ukZL4+5Oqhx6L5EZwNmiHe4Btzrv3J848ZZI6tjksL6
	4qsA/6e9TE04yNF/X7HDkbwtLgdoPxw=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-13809223fd4so825084c88.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781776150; x=1782380950; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZAtuUTHJDOiKLx4zrrhbntE6nPwfKSnV0j3f+6dKp0=;
        b=Lbn+zbJLUEkKBcW/DyUBz8/sQoWtd+E6W0dyZ9kFWvFrGxHSmqF0cpJvHTHe2XAHY0
         vwQ9MmuBL2RHzY1G0YQBt1WAGgKBp6v6kOfNo6+WnQSstvzhG3mv1N/oGYsDG+m6tW4D
         3MmN9SJ4O6dCu2YvTvjV8rStLk8SZ6wJJ+tB0y7ok274w97/qbX7cz0qpld1yUXZsLtT
         WAOMzhZB2hrNJ23bemHAV+xjWC6CCHwfFkxoIQN52tim57ig2Qg9bg9nHrny5NNp0bS3
         WcFG/zRmiXaRPilkQmnwis0Fzj5QCYJGtL6e69P9+AheHZ933/iDCyrHoo7GuFOQBQUG
         +6xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781776150; x=1782380950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eZAtuUTHJDOiKLx4zrrhbntE6nPwfKSnV0j3f+6dKp0=;
        b=lJJ2VDEoo2zMi4wa1pITFdJ/vOrFWrkylLep9DPPTOcnYAx/ZzIZroeM9cT5sK9g8t
         3C9jMkStxeQ/rc4wvAL03GtRnNeGjiQ+37sdVotvHbs8+EJBGYPBIGA2oi1RnYU5LSkP
         CKlh0vWYoXhr0kU89IprtB4lvteeTtOdH2Xa13v5ZLhxouPT+Joq/dqIPEB2jFM1o5bl
         VGDc38bE9bWopHyuyA+VJ665LyJ8AbPdTPB35lC93BnlzHG3iWUuIusDE7UdMfJre1Yc
         xEFtN4cu/oj7uSmLgqrvtFZa6G3Qq0Wvxuz8hn49T/Qe7r3GYutXDZw+9tEZTOQ8SBYk
         4E1w==
X-Forwarded-Encrypted: i=1; AFNElJ9jdR6Wwzl9OF6gnh4eTpA7n2GsQGTMAWG8zfRA8jzyp4ydDX44l6x0oMjbC8uo0JjjsDk5QVClXw==@kvack.org
X-Gm-Message-State: AOJu0YwL69/biL9ETcu+r5pKjfp0D/8QGoYGB19Jh2qK9uWtZ3nGTg55
	ZUpt5/JuQjDYJEMJPPcbz9GY9VbQgYhWtGNBAtjrYj580foNql3yy89N
X-Gm-Gg: Acq92OGwteovT5C+O8LLpbwtnMX1rLl/7tJLKnfv2H9O3+gyPRMvpLo5wHZyEBXu2/2
	LOpCpGD9cCcvJ6NYSD/RME46SqWX1Xt2frKrjUPZ5cXPO6HtxEB/d5Mo916rD0wchz2QHDJR8d1
	LA8haxvSW0fKbg6CKlM3GkqYPPPu2VXN2l8v84j0f4raLKPxMfJayrQYHZe64c8vuB189Ygxbz8
	PxDCneHuMyuFqtw3tCwJP2+crWynP+oBGQoLnO8B5QzeYonJuQOSJ7ceoLpc7m23T8zGrV/ibjx
	0lgUELj4lS1flrsRkfue9cEsdEYw31jxoD0StT0hwvdgRYBk8/yVJiWOOsD1vWvanKXUrTATxtq
	7lIzPwMwNu5JksAdzpObctx/tTjoTssew/3pT8TZ6kv/NHxlO35ytpJUBPzgSnSsjleqe5siNVK
	GNduk7N2YLebgznef4FtBGI+Qd
X-Received: by 2002:a05:7022:1b18:b0:136:ff02:d00b with SMTP id a92af1059eb24-1398f6de2c7mr3533585c88.25.1781776149844;
        Thu, 18 Jun 2026 02:49:09 -0700 (PDT)
Received: from localhost.localdomain ([104.28.158.224])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b91a4c7sm18069971c88.8.2026.06.18.02.49.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 02:49:09 -0700 (PDT)
From: Wang Lian <lianux.mm@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: npache@redhat.com,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com
Subject: [RFC PATCH 6/6] mm/damon: add SPE feedback for sub-THP split decisions
Date: Thu, 18 Jun 2026 17:48:38 +0800
Message-ID: <20260618094838.32805-7-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260618094838.32805-1-lianux.mm@gmail.com>
References: <20260618094838.32805-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4632018000C
X-Rspam-User: 
X-Stat-Signature: pxetzcs1usqdkajoj4qx6wxsk7e8xphe
X-HE-Tag: 1781776151-914616
X-HE-Meta: U2FsdGVkX19OlVs8lTc8WJbnPI/XmRDTm1HckwgeoXBgkfgj5aBPZfHGqf4aQQsonJ2qHu4Gh8rQ4paWFU4VbzllENcOowsKU4D/x5C0Bx2nM5PoGSWh+mddH0beh/LI2LSI73/hEtZ3skcMoY5Gv2IHQpSKInffTlrqum7TlwobvXrzGOOmt58PtxdDGRyITGQ3K7iYnZu3jpOrMVAh1R/dNk8cPA2A/h1xcf28HeZ2Y+Ol7AKSCWoBw+CznekbEWflBHC3VP0H/x3vDj6dRdt9GHBO+LI+J7nYr9ypR4G88qAjw7PItWosJcB7FLqqGcg9ivrjpy/6uRldn07YNvJvm9eWxsIF0LIf09Gg7u8UtFh7RKER+62IuC+oiHKgzSYibJFQEjPDLENgcj7KqYtZHFmq7Lme7B7UwNJUU1xnw5mcxnT+pcbsyCHOyx0UbF/T+FYJcG28a5V0jPsSaYgdrdxCRJse+9thZAAyeP8VzvtySjJjSYxQvSPIdvAdzp1+giOlZWwDPwEqDQZF0iOoN9KUOenJyAYJGXxSiA9CMzAXjHjcLxBNflT0+TlrMlsdmhCiDEF2XtzgL1gCFvcK6anhnMbRmIFuc0vZsbre9/lb/I0CKn9rQhWIkjTneFknmw73NKqkV5WjszR4ZhhzwooFbE7PsbSzBRpN7PGnQMa5q3Z5nKAXBkTe+ib1PD57tyYMvN/ftIQlmVeLmV/WTYLYY2j4cRuUOIGfrhN0Sra5bz3WW8Yvu07QLnoObPri0elg26HUJwKnD8sAWs4L0yYU9wo0bF5gFV4BRwkJOzbmYSq4GkQ2YDzBCUDTI2kMBq8qGNcKzwuh2CNPrfkqs/IsLe/zKxX2AH8mfCcxnwRaXXOZVo1I8/IgK6HAy5wHnTHJ6pALvwWbXdlpEoCgSaTEjQsMn+uV8npn/nlG/HjFIXSmr/0pE/KAOutyzbTUlCpoaoEXvyBKiNT
 rBSEkb9j
 0PeludZHrkqqrInKVdg6m37rPg7AeMvQ95igMvFKq3glGC55CY7mGY2D8tl1GqT/Ti5ktMXzyz6IhbBkRSvP3GJ2nrwX2aFVe6Hp6mprOR+82460GEdXRN3aM51FgkDu1yhSipDXsg2zLDnSSpTikiedMUPVlCylExvzRdxjX5PfGH2RrvLfcfD8wCdbrMFXJcjcOFfl9jeFCq/fXDIu1c0QPsgz0aNN2WuOtFrpHnGLbHWUJLD8SbNfBfglXExASut+Shi8+p9Q5KL5onGvIibZgrHs2fLy1hisiasM4dNS0XMGSJATF9YFZWzTP1Szqdo1TxnjeFvVYmnmZh1OQcvYwGEljRL9uzcA0eaty1WlJ8T+bEFOsvmr4COPgs1iVJrkqrFbggvb+/RJjUNVbymhbP43yvK+oNN+IpaLqYtb6IvsZ2GFkTg8O+UWEODmTg1Dcgil4H2Fs+/d1sOynJIlWBkBZ9IhQTV/5nSQ1D2hyBNN2qjII/+uZ/b4y5R8D3IuIWDXISgLMeaLv6KuIVUO3U3bSJOpfEuMbL61eUTaWkoy78BjSXpfh11qV+kYt1y7u9s35VXfLA6810rf4QYhdrntuxvlFyDZH2SuNnOpkEnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sub-THP access heatmap that enables data-driven split decisions
in DAMOS_MTHP_SPLIT.  The split handler queries damon_spe_hot_fraction()
and compares against the scheme's configurable hot_threshold (default
30%, set in patch 4) to preserve genuinely hot THPs while splitting
cold ones.

Key data-driven design decisions from Kunpeng 920 SPE profiling:

  1. Signal vs noise threshold (this patch):
     Raw SPE data shows most THPs have scattered 1-2 sample hits across
     many subpages — noise, not genuine access patterns.  The heatmap
     now uses a two-pass signal threshold: a subpage chunk must have
     >= 1/10 of the peak chunk's access count to be considered hot.
     This reduces false hot classification from ~50% to <5% of subpages.

  2. hot_threshold 30% (patch 4, sysfs-configurable):
     With the signal filter applied, 97% of THPs have <10% hot
     subpages (clearly cold), 1-2% have 10-30% (borderline), and
     <1% have >30% (genuinely hot).  The 30% default catches hot THPs
     while allowing the vast majority to be split.

Architecture (three-phase):

  Phase 2a (current fallback):
    Walk PTE access bits via folio_walk for THPs already split to PTEs.
    For PMD-mapped THPs (the common case), return -EOPNOTSUPP, which
    causes the split handler to split unconditionally.

  Phase 2b (userspace daemon -> kernel, ready for validation):
    Userspace SPE daemon decodes ARM SPE records, feeds PFNs via debugfs
    (/sys/kernel/debug/damon/spe_feed).  The kernel aggregates accesses
    into a per-folio rbtree keyed by THP-aligned PFN.

  Phase 2c (kernel-native, future):
    perf_event_create_kernel_counter for ARM SPE.  Overflow handler
    calls damon_spe_record_access() directly.

Data structure (mm/damon/spe.c):
  - Per-folio rbtree keyed by PFN, storing access_count[512] (one
    counter per 4KB subpage)
  - Max 1024 entries, entries older than 30s are pruned periodically
  - Global spinlock-protected rbtree with GFP_ATOMIC allocation

Debugfs interface:
  - /sys/kernel/debug/damon/spe_feed  (write): accept one PFN per line
  - /sys/kernel/debug/damon/spe_stats (read):  rbtree stats + top entries

When CONFIG_DAMON_SPE is disabled, all SPE functions are empty stubs
returning -EOPNOTSUPP, making the split unconditional.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
---
 mm/damon/Kconfig  |  12 ++
 mm/damon/Makefile |   1 +
 mm/damon/core.c   |   3 +
 mm/damon/spe.c    | 505 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/damon/spe.h    |  62 ++++++
 mm/damon/vaddr.c  |  16 +-
 6 files changed, 597 insertions(+), 2 deletions(-)
 create mode 100644 mm/damon/spe.c
 create mode 100644 mm/damon/spe.h

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 34631a44cdec..ea75a8dab989 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -121,4 +121,16 @@ config DAMON_STAT_ENABLED_DEFAULT
 	  Whether to enable DAMON_STAT by default.  Users can disable it in
 	  boot or runtime using its 'enabled' parameter.
 
+config DAMON_SPE
+	bool "DAMON SPE feedback for sub-THP access monitoring (prototype)"
+	depends on DAMON_VADDR
+	help
+	  Enable sub-THP access heatmap feedback for DAMOS_MTHP_SPLIT.
+	  Currently a prototype: uses PTE access bits for THPs that have
+	  been split to PTEs, returns "no data" for PMD-mapped THPs.
+
+	  On hardware with ARM SPE (e.g. Kunpeng 920), this will be
+	  extended to provide per-subpage access data without needing to
+	  split the PMD first, enabling precise mTHP split decisions.
+
 endmenu
diff --git a/mm/damon/Makefile b/mm/damon/Makefile
index d8d6bf5f8bff..507b43a9f009 100644
--- a/mm/damon/Makefile
+++ b/mm/damon/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
 obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
 obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
 obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
+obj-$(CONFIG_DAMON_SPE)		+= spe.o
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 265d51ade25b..0805e71a90d8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -20,6 +20,7 @@
 
 /* for damon_get_folio() used by node eligible memory metrics */
 #include "ops-common.h"
+#include "spe.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
@@ -2987,6 +2988,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	if (!has_schemes_to_apply)
 		return;
 
+	damon_spe_prune();
+
 	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
diff --git a/mm/damon/spe.c b/mm/damon/spe.c
new file mode 100644
index 000000000000..98f8d32053e4
--- /dev/null
+++ b/mm/damon/spe.c
@@ -0,0 +1,505 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON SPE (Statistical Profiling Extension) feedback
+ *
+ * Provides sub-THP access heatmap for intelligent split decisions.
+ *
+ * Architecture:
+ *   Phase 2a (current): PTE access bits via folio_walk.
+ *     Works only when a THP has been previously split to PTEs.
+ *     Returns -EOPNOTSUPP for PMD-mapped THPs.
+ *
+ *   Phase 2b (userspace): spe_hist daemon decodes SPE in userspace,
+ *     feeds {pfn, subpage_idx} via debugfs/sysfs into the rbtree below.
+ *
+ *   Phase 2c (kernel): perf_event_create_kernel_counter for ARM SPE,
+ *     overflow handler aggregates into rbtree.  Requires SPE hardware.
+ *
+ * Data structure:
+ *   Per-folio rbtree keyed by PFN, storing per-subpage access counts.
+ *   Entries are aged and pruned periodically.
+ *
+ * Copyright (C) 2026 Wang Lian <lianux.mm@gmail.com>
+ */
+
+#define pr_fmt(fmt) "damon-spe: " fmt
+
+#include <linux/mm.h>
+#include <linux/pagewalk.h>
+#include <linux/huge_mm.h>
+#include <linux/bitmap.h>
+#include <linux/rbtree.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+#include <linux/sched.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/init.h>
+#include "spe.h"
+
+/* Max sub-pages when querying at order 0 */
+#define DAMON_SPE_MAX_CHUNKS	512
+
+/* Max folio entries in the rbtree (per-mm or global) */
+#define DAMON_SPE_MAX_ENTRIES	1024
+
+/* Entry considered stale after this many jiffies (default: 30s) */
+#define DAMON_SPE_ENTRY_TTL	(30 * HZ)
+
+/*
+ * Per-folio access histogram entry.
+ * Keyed by pfn in an rbtree.  Each entry tracks access count per subpage.
+ * The access_count array is sized for PMD-order / 0 = 512 4KB subpages.
+ */
+struct damon_spe_entry {
+	struct rb_node		node;
+	unsigned long		pfn;		/* THP-aligned PFN */
+	pid_t			pid;		/* owner process */
+	unsigned long		access_count[DAMON_SPE_MAX_CHUNKS];
+	unsigned long		total_accesses;
+	unsigned long		last_access;	/* jiffies of last update */
+};
+
+static struct rb_root spe_tree = RB_ROOT;
+static DEFINE_SPINLOCK(spe_lock);
+static unsigned int spe_nr_entries;
+
+/* Forward declarations */
+static void __spe_prune(void);
+
+/*
+ * Find an entry by PFN.  Must be called with spe_lock held.
+ */
+static struct damon_spe_entry *spe_find(unsigned long pfn)
+{
+	struct rb_node *node = spe_tree.rb_node;
+
+	while (node) {
+		struct damon_spe_entry *e =
+			rb_entry(node, struct damon_spe_entry, node);
+
+		if (pfn < e->pfn)
+			node = node->rb_left;
+		else if (pfn > e->pfn)
+			node = node->rb_right;
+		else
+			return e;
+	}
+	return NULL;
+}
+
+/*
+ * Insert a new entry.  Must be called with spe_lock held.
+ * Returns the new entry, or NULL if the tree is full.
+ */
+static struct damon_spe_entry *spe_insert(unsigned long pfn, pid_t pid)
+{
+	struct rb_node **new = &spe_tree.rb_node, *parent = NULL;
+	struct damon_spe_entry *e;
+
+	if (spe_nr_entries >= DAMON_SPE_MAX_ENTRIES) {
+		__spe_prune();
+		if (spe_nr_entries >= DAMON_SPE_MAX_ENTRIES)
+			return NULL;
+	}
+
+	e = kzalloc(sizeof(*e), GFP_ATOMIC);
+	if (!e)
+		return NULL;
+
+	e->pfn = pfn;
+	e->pid = pid;
+	e->last_access = jiffies;
+
+	while (*new) {
+		struct damon_spe_entry *this =
+			rb_entry(*new, struct damon_spe_entry, node);
+
+		parent = *new;
+		if (pfn < this->pfn)
+			new = &((*new)->rb_left);
+		else if (pfn > this->pfn)
+			new = &((*new)->rb_right);
+		else {
+			/* Race: another CPU inserted the same PFN */
+			kfree(e);
+			return this;
+		}
+	}
+
+	rb_link_node(&e->node, parent, new);
+	rb_insert_color(&e->node, &spe_tree);
+	spe_nr_entries++;
+	return e;
+}
+
+/*
+ * Prune entries that haven't been updated for DAMON_SPE_ENTRY_TTL.
+ * Must be called with spe_lock held.
+ */
+static void __spe_prune(void)
+{
+	struct rb_node *node, *next;
+	unsigned long deadline = jiffies - DAMON_SPE_ENTRY_TTL;
+
+	node = rb_first(&spe_tree);
+	while (node) {
+		struct damon_spe_entry *e =
+			rb_entry(node, struct damon_spe_entry, node);
+
+		next = rb_next(node);
+
+		if (time_before(e->last_access, deadline)) {
+			rb_erase(&e->node, &spe_tree);
+			spe_nr_entries--;
+			kfree(e);
+		}
+		node = next;
+	}
+}
+
+/**
+ * damon_spe_record_access() - Record a single subpage access
+ * @pfn: Physical page frame number (any page within a THP)
+ * @pid: Process ID that performed the access
+ *
+ * The PFN is automatically aligned to the THP base.  The subpage index
+ * within the THP is derived from the low bits of the PFN.
+ *
+ * Context: Can be called from IRQ context.
+ */
+void damon_spe_record_access(unsigned long pfn, pid_t pid)
+{
+	unsigned long thp_pfn = pfn & ~(unsigned long)(DAMON_SPE_MAX_CHUNKS - 1);
+	unsigned int idx = pfn & (DAMON_SPE_MAX_CHUNKS - 1);
+	struct damon_spe_entry *e;
+	unsigned long flags;
+
+	spin_lock_irqsave(&spe_lock, flags);
+
+	e = spe_find(thp_pfn);
+	if (!e)
+		e = spe_insert(thp_pfn, pid);
+
+	if (e) {
+		e->access_count[idx]++;
+		e->total_accesses++;
+		e->last_access = jiffies;
+	}
+
+	spin_unlock_irqrestore(&spe_lock, flags);
+}
+EXPORT_SYMBOL_GPL(damon_spe_record_access);
+
+/**
+ * damon_spe_folio_heatmap() - Get sub-THP access bitmap for a folio
+ * @folio: The folio to query
+ * @vma: VMA containing the folio
+ * @addr: Virtual address of the folio start
+ * @target_order: Page order for each chunk in the bitmap
+ * @hot_bitmap: Output bitmap with one bit per chunk
+ *
+ * Queries the SPE rbtree first.  Falls back to PTE access bits if no
+ * SPE data is available (requires the THP to be split to PTEs).
+ *
+ * Return: Number of chunks on success, negative error on failure.
+ */
+int damon_spe_folio_heatmap(struct folio *folio, struct vm_area_struct *vma,
+			    unsigned long addr, unsigned int target_order,
+			    unsigned long *hot_bitmap)
+{
+	unsigned long num_chunks = folio_nr_pages(folio) >> target_order;
+	unsigned long chunk_sz = PAGE_SIZE << target_order;
+	unsigned long pfn;
+	unsigned long flags;
+	struct damon_spe_entry *e;
+	struct folio_walk fw;
+	struct folio *sub_folio;
+	int i;
+
+	if (!folio || !vma || !hot_bitmap)
+		return -EINVAL;
+	if (target_order >= folio_order(folio))
+		return -EINVAL;
+
+	pfn = folio_pfn(folio);
+
+	/*
+	 * Phase 2b/2c path: query the SPE rbtree.
+	 * If we have aggregated SPE data for this folio, use it.
+	 */
+	spin_lock_irqsave(&spe_lock, flags);
+	e = spe_find(pfn);
+	if (e && e->total_accesses > 0) {
+		unsigned long max_sum = 0;
+		unsigned long sig_thresh;
+		unsigned int spp = chunk_sz >> PAGE_SHIFT;
+
+		/* First pass: find peak chunk access count */
+		for (i = 0; i < num_chunks; i++) {
+			unsigned long sum = 0;
+			int j;
+
+			for (j = 0; j < spp; j++) {
+				unsigned int idx = i * spp + j;
+
+				if (idx < DAMON_SPE_MAX_CHUNKS)
+					sum += e->access_count[idx];
+			}
+			if (sum > max_sum)
+				max_sum = sum;
+		}
+
+		/*
+		 * Signal threshold: a chunk needs >= 1/10 of peak access
+		 * count to be considered hot.  This filters SPE noise —
+		 * Kunpeng 920 data shows most THPs have scattered 1-2
+		 * sample hits across many subpages that don't represent
+		 * genuine hot access patterns.
+		 */
+		sig_thresh = max(max_sum / 10, 1UL);
+
+		/* Second pass: build hot bitmap using signal threshold */
+		bitmap_zero(hot_bitmap, num_chunks);
+		for (i = 0; i < num_chunks; i++) {
+			unsigned long sum = 0;
+			int j;
+
+			for (j = 0; j < spp; j++) {
+				unsigned int idx = i * spp + j;
+
+				if (idx < DAMON_SPE_MAX_CHUNKS)
+					sum += e->access_count[idx];
+			}
+			if (sum >= sig_thresh)
+				__set_bit(i, hot_bitmap);
+		}
+
+		spin_unlock_irqrestore(&spe_lock, flags);
+		return (int)num_chunks;
+	}
+	spin_unlock_irqrestore(&spe_lock, flags);
+
+	/*
+	 * Phase 2a fallback: walk PTEs to check access bits.
+	 * Only works when the THP has been split to PTEs.
+	 */
+	bitmap_zero(hot_bitmap, num_chunks);
+
+	for (i = 0; i < num_chunks; i++) {
+		unsigned long chunk_addr = addr + i * chunk_sz;
+
+		sub_folio = folio_walk_start(&fw, vma, chunk_addr, 0);
+		if (!sub_folio)
+			return -EOPNOTSUPP;
+
+		if (fw.level == FW_LEVEL_PMD) {
+			folio_walk_end(&fw, vma);
+			return -EOPNOTSUPP;
+		}
+
+		if (fw.level == FW_LEVEL_PTE && pte_young(fw.pte))
+			__set_bit(i, hot_bitmap);
+
+		folio_walk_end(&fw, vma);
+	}
+
+	return (int)num_chunks;
+}
+EXPORT_SYMBOL_GPL(damon_spe_folio_heatmap);
+
+/**
+ * damon_spe_hot_fraction() - Return hot chunk percentage of a folio
+ * @folio: The folio to query
+ * @vma: VMA containing the folio
+ * @addr: Virtual address of the folio start
+ * @target_order: Page order for each chunk
+ *
+ * Return: Percentage (0-100) on success, negative error on failure.
+ */
+int damon_spe_hot_fraction(struct folio *folio, struct vm_area_struct *vma,
+			   unsigned long addr, unsigned int target_order)
+{
+	unsigned long num_chunks = folio_nr_pages(folio) >> target_order;
+	DECLARE_BITMAP(hot_bitmap, DAMON_SPE_MAX_CHUNKS);
+	int ret, hot;
+
+	if (num_chunks > DAMON_SPE_MAX_CHUNKS)
+		return -ERANGE;
+
+	ret = damon_spe_folio_heatmap(folio, vma, addr, target_order,
+				      hot_bitmap);
+	if (ret < 0)
+		return ret;
+
+	hot = bitmap_weight(hot_bitmap, num_chunks);
+	return (hot * 100) / (int)num_chunks;
+}
+EXPORT_SYMBOL_GPL(damon_spe_hot_fraction);
+
+/**
+ * damon_spe_prune() - Remove stale entries from the SPE rbtree
+ *
+ * Called from DAMON's aggregation cycle.  Removes entries not updated
+ * within DAMON_SPE_ENTRY_TTL jiffies.
+ */
+void damon_spe_prune(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&spe_lock, flags);
+	__spe_prune();
+	spin_unlock_irqrestore(&spe_lock, flags);
+}
+
+/**
+ * damon_spe_stats() - Return current SPE rbtree statistics
+ * @nr_entries: Output for number of entries, may be NULL
+ * @total_accesses: Output for total accumulated accesses, may be NULL
+ */
+void damon_spe_stats(unsigned int *nr_entries, unsigned long *total_accesses)
+{
+	struct rb_node *node;
+	unsigned long flags;
+	unsigned int count = 0;
+	unsigned long total = 0;
+
+	spin_lock_irqsave(&spe_lock, flags);
+	for (node = rb_first(&spe_tree); node; node = rb_next(node)) {
+		struct damon_spe_entry *e =
+			rb_entry(node, struct damon_spe_entry, node);
+		count++;
+		total += e->total_accesses;
+	}
+	spin_unlock_irqrestore(&spe_lock, flags);
+
+	if (nr_entries)
+		*nr_entries = count;
+	if (total_accesses)
+		*total_accesses = total;
+}
+EXPORT_SYMBOL_GPL(damon_spe_stats);
+
+/* ---- debugfs interface for Phase 2b (userspace daemon → kernel rbtree) ---- */
+
+static struct dentry *damon_spe_dentry;
+
+/*
+ * spe_feed write: accept one PFN per line (hex or decimal).
+ * The PFN is recorded as an access via damon_spe_record_access().
+ *
+ * Usage from userspace:
+ *   echo 0x12345678 > /sys/kernel/debug/damon/spe_feed
+ *
+ * For bulk feed from SPE daemon:
+ *   cat spe_pfns.txt > /sys/kernel/debug/damon/spe_feed
+ */
+static ssize_t spe_feed_write(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	char line[32];
+	size_t len = min(count, sizeof(line) - 1);
+	unsigned long pfn;
+
+	if (copy_from_user(line, buf, len))
+		return -EFAULT;
+	line[len] = '\0';
+
+	/* Strip trailing newline */
+	if (len > 0 && line[len - 1] == '\n')
+		line[len - 1] = '\0';
+
+	if (kstrtoul(line, 0, &pfn) == 0 && pfn != 0)
+		damon_spe_record_access(pfn, 0);
+
+	return count;
+}
+
+/*
+ * spe_stats read: show current SPE rbtree statistics.
+ *
+ * Usage:
+ *   cat /sys/kernel/debug/damon/spe_stats
+ */
+static int spe_stats_show(struct seq_file *m, void *v)
+{
+	struct rb_node *node;
+	unsigned long flags;
+	unsigned int count = 0;
+	unsigned long total = 0;
+
+	spin_lock_irqsave(&spe_lock, flags);
+	for (node = rb_first(&spe_tree); node; node = rb_next(node)) {
+		struct damon_spe_entry *e =
+			rb_entry(node, struct damon_spe_entry, node);
+		count++;
+		total += e->total_accesses;
+	}
+	spin_unlock_irqrestore(&spe_lock, flags);
+
+	seq_printf(m, "nr_entries=%u total_accesses=%lu\n", count, total);
+
+	/* Show top entries (limit output) */
+	spin_lock_irqsave(&spe_lock, flags);
+	count = 0;
+	for (node = rb_first(&spe_tree); node; node = rb_next(node)) {
+		struct damon_spe_entry *e =
+			rb_entry(node, struct damon_spe_entry, node);
+		unsigned int hot_pages = 0;
+		int i;
+
+		for (i = 0; i < DAMON_SPE_MAX_CHUNKS; i++)
+			if (e->access_count[i])
+				hot_pages++;
+
+		seq_printf(m, "  pfn=0x%lx pid=%d total=%lu hot_pages=%u/%d\n",
+			   e->pfn, e->pid, e->total_accesses,
+			   hot_pages, DAMON_SPE_MAX_CHUNKS);
+		if (++count >= 10)
+			break;
+	}
+	spin_unlock_irqrestore(&spe_lock, flags);
+
+	return 0;
+}
+
+static int spe_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, spe_stats_show, inode->i_private);
+}
+
+static const struct file_operations spe_feed_fops = {
+	.write = spe_feed_write,
+};
+
+static const struct file_operations spe_stats_fops = {
+	.open = spe_stats_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int __init damon_spe_dbgfs_init(void)
+{
+	struct dentry *d;
+
+	d = debugfs_lookup("damon", NULL);
+	if (!d) {
+		d = debugfs_create_dir("damon", NULL);
+		if (IS_ERR(d))
+			return PTR_ERR(d);
+	}
+	damon_spe_dentry = d;
+
+	debugfs_create_file("spe_feed", 0200, damon_spe_dentry,
+			    NULL, &spe_feed_fops);
+	debugfs_create_file("spe_stats", 0400, damon_spe_dentry,
+			    NULL, &spe_stats_fops);
+
+	pr_info("debugfs interface ready: /sys/kernel/debug/damon/spe_{feed,stats}\n");
+	return 0;
+}
+
+late_initcall(damon_spe_dbgfs_init);
diff --git a/mm/damon/spe.h b/mm/damon/spe.h
new file mode 100644
index 000000000000..38799688b5af
--- /dev/null
+++ b/mm/damon/spe.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * DAMON SPE (Statistical Profiling Extension) feedback
+ *
+ * Provides sub-THP access heatmap for intelligent split decisions.
+ *
+ * Three-phase architecture:
+ *   Phase 2a: PTE access bits via folio_walk (current fallback)
+ *   Phase 2b: Userspace SPE daemon feeds {pfn, subpage} via debugfs
+ *   Phase 2c: Kernel perf_event_create_kernel_counter for ARM SPE
+ *
+ * Copyright (C) 2026 Wang Lian <lianux.mm@gmail.com>
+ */
+
+#ifndef _DAMON_SPE_H
+#define _DAMON_SPE_H
+
+#include <linux/mm_types.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_DAMON_SPE
+
+/* ---- Sub-page heatmap query ---- */
+
+int damon_spe_folio_heatmap(struct folio *folio, struct vm_area_struct *vma,
+			    unsigned long addr, unsigned int target_order,
+			    unsigned long *hot_bitmap);
+
+int damon_spe_hot_fraction(struct folio *folio, struct vm_area_struct *vma,
+			   unsigned long addr, unsigned int target_order);
+
+/* ---- Recording (called from SPE event handler or userspace daemon) ---- */
+
+void damon_spe_record_access(unsigned long pfn, pid_t pid);
+
+/* ---- Maintenance ---- */
+
+void damon_spe_prune(void);
+void damon_spe_stats(unsigned int *nr_entries, unsigned long *total_accesses);
+
+#else /* !CONFIG_DAMON_SPE */
+
+static inline int damon_spe_folio_heatmap(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr,
+		unsigned int target_order, unsigned long *hot_bitmap)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int damon_spe_hot_fraction(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr,
+		unsigned int target_order)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void damon_spe_record_access(unsigned long pfn, pid_t pid) {}
+static inline void damon_spe_prune(void) {}
+static inline void damon_spe_stats(unsigned int *nr, unsigned long *total) {}
+
+#endif /* CONFIG_DAMON_SPE */
+#endif /* _DAMON_SPE_H */
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 1957e390a277..cb3ea2766b9e 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -18,6 +18,7 @@
 
 #include "../internal.h"
 #include "ops-common.h"
+#include "spe.h"
 
 #ifdef CONFIG_DAMON_VADDR_KUNIT_TEST
 #undef DAMON_MIN_REGION_SZ
@@ -945,6 +946,7 @@ static unsigned long damos_va_mthp_split(struct damon_target *target,
 	struct vm_area_struct *vma;
 	struct folio *folio;
 	struct folio_walk fw;
+	int hot_pct;
 
 	mm = damon_get_mm(target);
 	if (!mm)
@@ -979,8 +981,18 @@ static unsigned long damos_va_mthp_split(struct damon_target *target,
 			folio_get(folio);
 			folio_walk_end(&fw, vma);
 
-			if (!split_folio_to_order(folio, target_order))
-				applied += chunk_sz;
+			hot_pct = damon_spe_hot_fraction(folio, vma, addr,
+						 target_order);
+			/*
+			 * hot_pct < 0: no heatmap data (no SPE, PMD-mapped),
+			 * split unconditionally — DAMON access pattern already
+			 * identified this region as cold.
+			 */
+			if (hot_pct < 0 ||
+			    (unsigned int)hot_pct < s->hot_threshold) {
+				if (!split_folio_to_order(folio, target_order))
+					applied += chunk_sz;
+			}
 
 			folio_unlock(folio);
 			folio_put(folio);
-- 
2.50.1 (Apple Git-155)


