Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B269CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F372A8E00BD; Thu,  9 Oct 2025 21:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7C38E0002; Thu,  9 Oct 2025 21:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF988E00BD; Thu,  9 Oct 2025 21:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF5038E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E22C1166F3
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:14 +0000 (UTC)
X-FDA: 83980448748.11.51F26F3
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6EE012000C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=D6dd1GRH;
	spf=pass (imf29.hostedemail.com: domain of 3S1_oaAYKCPgxzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3S1_oaAYKCPgxzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMspCuJAq7oIjVtiLnvMgH+BOK3foud4K2myRpZR2Ss=;
	b=38H4C4/62T9HR3LOh3V50wpJWri3dAbbmyo0Q08y1rG5EtHCKf3Q/MD2wfInGyZIIsv4Mf
	CIbzyL6IHB67Ziv5m4WE3G8/Qzo4lUilRQnIk4AyIfvY7R6gYGCV4ACQ8Wvyt99JnUauJY
	OpmmDaDNoKtJxTub2PwQP118kop1j/I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=D6dd1GRH;
	spf=pass (imf29.hostedemail.com: domain of 3S1_oaAYKCPgxzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3S1_oaAYKCPgxzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059212; a=rsa-sha256;
	cv=none;
	b=eOz6+DAZFwr0GtFqFRaEuBjkfg6YtvtfDxpDBn4DSzB4WyLTSakkZ0x9C+8pwjmMcTmZ/4
	OK7bNnpgR2eGQGMvovriQFNvB9DLxJft46AuCNE444aHsaGTI10rg3BnVusTZyAxdKIOBY
	BIj7j1p2wadKWyAvSaOnTyhj8V92TNU=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-277f0ea6fbaso35616975ad.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760059211; x=1760664011; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BMspCuJAq7oIjVtiLnvMgH+BOK3foud4K2myRpZR2Ss=;
        b=D6dd1GRHJr0FP484yuCRBdt9N9rHcho//s6QJw+fzP3HS9l9MjD8eTreqdP+Yvq3SO
         QkwyV1HMKE24wqkMSrZH1YGZzAMmvuaa6VnXCN+ISjAX63nxV2KWx5yncfhppNlrEQ+y
         JaMewXfgn88/DAXp4/n8DB0EfMwlwp4G/VZapoa4LGPG9uW6dxaVbO6mV4xMyobBj5IL
         m5wlye5A9mxAcB3eWpf3BPo26PzyvXMujkh3EXwmPU0bVCzllzghdnCrVPOdnfEU3TjA
         avzSTnIfDIQ0xF6EF2R+OERl5gC1YjXmxjf8cX1oPLuQGn6Du8a1rQq0rKFKPvVQjln0
         tu1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760059211; x=1760664011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BMspCuJAq7oIjVtiLnvMgH+BOK3foud4K2myRpZR2Ss=;
        b=JbzbFYwMAfNJKEayyecod1pJj7VPY0bef4hxowrLlZpCct6oLtat8VlwaAZNWqjSl9
         lzOImVIQ3KRCjccwYXi2zB+rphkIn1RonlV7hYo1bXkFttGtx71e6DvHCtA+nG1IGnDK
         OMsHh5JwFz9BziaUz2Y4FBaWvTnqDS0X6OXjqZE4WQwbgEOk1eOjLWhqJkPy4T6qfFLk
         GbketILwZd6j7YLn4/4zouu9xjpkwuQXoSvUJEBF8hwUBvA6DmeQU0w8VkGCGqYDn1jg
         Yfl4OVuTozd14A9CfWFil6FXkWHGsSqzgNGZmQHzwSgNCg6TGhcxnLALjUJPANyxbp9W
         3TkA==
X-Forwarded-Encrypted: i=1; AJvYcCWFg5kPx/Y5zY4dwRmZ/QyE8tumA4QthMQMoQ/SKV2Z0MZ7Wso8ED5ghXPiskZF3E+LtBCpAaq96w==@kvack.org
X-Gm-Message-State: AOJu0YyIv+MiRcJWp0rID/KIg4kl5wKTuqIkHkBciBIrf4U7dtyQO9m/
	zYnwPmsfqGG/viFa7ayrs4ZQUqGR0ZOnxUlcb+mCPTCYHWoQF45BNJoudDkk0KA7ZDqjHcmk0TD
	oODcg0w==
X-Google-Smtp-Source: AGHT+IEWKkEivo5xkxXtogAKm07PhNF4ozYnoXCJEzQk/zOL2Y/TNZ+SlYrB9tiZy0+b63lcurI0GuhAwZk=
X-Received: from plas15.prod.google.com ([2002:a17:903:200f:b0:25f:48ba:97e1])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2d0:b0:25e:78db:4a0d
 with SMTP id d9443c01a7336-290273eddd5mr117013065ad.36.1760059211496; Thu, 09
 Oct 2025 18:20:11 -0700 (PDT)
Date: Thu,  9 Oct 2025 18:19:50 -0700
In-Reply-To: <20251010011951.2136980-1-surenb@google.com>
Mime-Version: 1.0
References: <20251010011951.2136980-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010011951.2136980-8-surenb@google.com>
Subject: [PATCH 7/8] mm: introduce GCMA
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org, jack@suse.cz, 
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com, 
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	minchan@kernel.org, surenb@google.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B6EE012000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: feomxakcoitgps17eeopf8q6kr8ti97e
X-HE-Tag: 1760059212-416591
X-HE-Meta: U2FsdGVkX19fh+u0EH+dMCmKBVRr3SF+IlmL9q0jCiZpBj4/VS8WvazreU9T6wXcYTaHgDPIMAmxERj9HlFR8ZdZIdda9SAdyslKm6ysEB47ReO4ZLyDCGsW1ZRUW/Udw0bPEzPNBZZLKEATA3h2FXEdPQbiDp4Svlc0zcDT6TXH7ojZVC0r8QZKGTDYjVSTNY5oLojRK2xAEilDtnFjypowqPWw5ihUM1GjONEoIiB7YupwtkCuWdEtLs1l9rrSpqraXGRvAJ7aao0cDjpJeN3jgETqP5LPQDBSXDUohB9uaWtSWni2Tjq9ijlcYEY/Kdz34pPNQqCSbuebWxZ5Zug0M4IG1FzaKTttN4ql3r46Cqy+PMlGpF1spqQiw1rAyRrt6UdVJrRL8rgx/EQGyZTZF4dVYE8YqHMCFtva3jE7HHdlwt4QK5MbwR9w/Ge8XM4MnnvM/6+fDlwUHKjCwjik8G3fjtF5OtBXGpQlvaPLKsBVz6R9xe+jgKMhcw0XSqOzlsKa+nSsbLIGloIdBTJ30PcFSZ7Pgv5apWuiLJoyKs73H6hoR+wanM6spfoI62hQO34YWGDAwRLQorJAWH5Z/DCPEC9wqPcsR6SkFfhlfx4HbWeCuyUpbVYti/7iY5KcHQR/u6/4jzeW19kV43ECr3eLyG5Mm+MBvcnGQhRW3Tdrwoh+MfqzFH/OJT9Y2aVfN04CgPCTjNlvjnU51rcHKM3GFFbojhfgj5eDe38E4ZElKVf59o45e8U9MaEVtexRFaK2kc6p5qqJptkIWgpeSTGhq6lo4D2UCCIQBPiuEq4d1LsghA2VRxbfnUJV2ZsKhfr9/E0JOF7jN/HxnzZu0VH6DVn1noVBO0koeYlc/35YqMy0K3NQJYV0pH44i++2PNN7m+mrGBA1B0F2vI/C6sDbRJLEAVNy8ylV400zofh0ecYkF85eg33Yh2gMKclQ9+iwPMChR0FyajH
 8aL27/YQ
 Er6h3Rf1V3I8BEL449ygv+EajmEJ9ux9XKHpGF8XetkaxovKa22MWDvoYWub+dMY4J2EfQJxRvGXkX3VJxe3ZfPITkGSCPn4n0jONem17tMqcItDoPjzerwV8CqILbc9+uvTK+EcqPDiFMHKyQLZFhI7tTLvkFaNe890sRzqy9DSJ6n2OVSuGtBJ0J+C4urozC0ARJ2t3G1kZflki3Jn3nDuLxV0/aRJk0ve1nGIPRtvAm1MfWMH3KUznVa31HaL4P8zM20uGi8wvJfqbtnDM+nbEUJKy7VLdopLS37toOH8g4yLcpI+tYlHcP4mD1Eb9tBSeo2DjPC1wYFvthScKQx1MfuXnNSr+98ROuZNDq3DjjLSwHF+BKIMWhmZuB5TC1slKVrNAPWyHl8W5lGXibU5DOh0hI4nwR+OJeVbJLJGEEi2xhDDWQXN9tvvedQJxZr782NrT7W2OrdwX8i7hCRMMxrMIUtcnobK5z4+VzPpGrq3IGxrLSYwZT40c1jcHXXcC1sROS1133H7RORVbV4QAn0MN1Gm6fY02NtSm+ANQ0gB5kRx5bDEJbBehmT+eU5dcxmZ2ts0iiKAxIEUY9LhYok0uILK7ZfQWfqN0K+J3t7ikia+pQKahPjhKh8rVyLs4l5BJM0pCxeLMW4YR6CP+HQcHQA5i5jxxeaWgeitqv91zKlBRTcTCI+BRDp614fAI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Minchan Kim <minchan@google.com>

This patch introduces GCMA (Guaranteed Contiguous Memory Allocator)
cleacache backend which reserves some amount of memory at the boot
and then donates it to store clean file-backed pages in the cleancache.
GCMA aims to guarantee contiguous memory allocation success as well as
low and deterministic allocation latency.

Notes:
Originally, the idea was posted by SeongJae Park and Minchan Kim [1].
Later Minchan reworked it to be used in Android as a reference for
Android vendors to use [2].

[1] https://lwn.net/Articles/619865/
[2] https://android-review.googlesource.com/q/topic:%22gcma_6.12%22

Signed-off-by: Minchan Kim <minchan@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 MAINTAINERS          |   2 +
 include/linux/gcma.h |  36 +++++++
 mm/Kconfig           |  15 +++
 mm/Makefile          |   1 +
 mm/gcma.c            | 231 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 285 insertions(+)
 create mode 100644 include/linux/gcma.h
 create mode 100644 mm/gcma.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 441e68c94177..95b5ad26ec11 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16361,6 +16361,7 @@ F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
+F:	include/linux/gcma.h
 F:	include/linux/ioremap.h
 F:	include/linux/memory-tiers.h
 F:	include/linux/page_idle.h
@@ -16372,6 +16373,7 @@ F:	mm/dmapool.c
 F:	mm/dmapool_test.c
 F:	mm/early_ioremap.c
 F:	mm/fadvise.c
+F:	mm/gcma.c
 F:	mm/ioremap.c
 F:	mm/mapping_dirty_helpers.c
 F:	mm/memory-tiers.c
diff --git a/include/linux/gcma.h b/include/linux/gcma.h
new file mode 100644
index 000000000000..20b2c85de87b
--- /dev/null
+++ b/include/linux/gcma.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __GCMA_H__
+#define __GCMA_H__
+
+#include <linux/types.h>
+
+#ifdef CONFIG_GCMA
+
+int gcma_register_area(const char *name,
+		       unsigned long start_pfn, unsigned long count);
+
+/*
+ * NOTE: allocated pages are still marked reserved and when freeing them
+ * the caller should ensure they are isolated and not referenced by anyone
+ * other than the caller.
+ */
+int gcma_alloc_range(unsigned long start_pfn, unsigned long count, gfp_t gfp);
+int gcma_free_range(unsigned long start_pfn, unsigned long count);
+
+#else /* CONFIG_GCMA */
+
+static inline int gcma_register_area(const char *name,
+				     unsigned long start_pfn,
+				     unsigned long count)
+		{ return -EOPNOTSUPP; }
+static inline int gcma_alloc_range(unsigned long start_pfn,
+				   unsigned long count, gfp_t gfp)
+		{ return -EOPNOTSUPP; }
+
+static inline int gcma_free_range(unsigned long start_pfn,
+				   unsigned long count)
+		{ return -EOPNOTSUPP; }
+
+#endif /* CONFIG_GCMA */
+
+#endif /* __GCMA_H__ */
diff --git a/mm/Kconfig b/mm/Kconfig
index 9f4da8a848f4..41ce5ef8db55 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1013,6 +1013,21 @@ config CMA_AREAS
 
 	  If unsure, leave the default value "8" in UMA and "20" in NUMA.
 
+config GCMA
+       bool "GCMA (Guaranteed Contiguous Memory Allocator)"
+       depends on CLEANCACHE
+	help
+	  This enables the Guaranteed Contiguous Memory Allocator to allow
+	  low latency guaranteed contiguous memory allocations. Memory
+	  reserved by GCMA is donated to cleancache to be used as pagecache
+	  extension. Once GCMA allocation is requested, necessary pages are
+	  taken back from the cleancache and used to satisfy the request.
+	  Cleancache guarantees low latency successful allocation as long
+	  as the total size of GCMA allocations does not exceed the size of
+	  the memory donated to the cleancache.
+
+	  If unsure, say "N".
+
 #
 # Select this config option from the architecture Kconfig, if available, to set
 # the max page order for physically contiguous allocations.
diff --git a/mm/Makefile b/mm/Makefile
index 845841a140e3..05aee66a8b07 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -149,3 +149,4 @@ obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
 obj-$(CONFIG_CLEANCACHE_SYSFS)	+= cleancache_sysfs.o
+obj-$(CONFIG_GCMA)	+= gcma.o
diff --git a/mm/gcma.c b/mm/gcma.c
new file mode 100644
index 000000000000..3ee0e1340db3
--- /dev/null
+++ b/mm/gcma.c
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * GCMA (Guaranteed Contiguous Memory Allocator)
+ *
+ */
+
+#define pr_fmt(fmt) "gcma: " fmt
+
+#include <linux/cleancache.h>
+#include <linux/gcma.h>
+#include <linux/hashtable.h>
+#include <linux/highmem.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include <linux/xarray.h>
+#include "internal.h"
+
+#define MAX_GCMA_AREAS		64
+#define GCMA_AREA_NAME_MAX_LEN	32
+
+struct gcma_area {
+	int pool_id;
+	unsigned long start_pfn;
+	unsigned long end_pfn;
+	char name[GCMA_AREA_NAME_MAX_LEN];
+};
+
+static struct gcma_area areas[MAX_GCMA_AREAS];
+static atomic_t nr_gcma_area = ATOMIC_INIT(0);
+static DEFINE_SPINLOCK(gcma_area_lock);
+
+static int free_folio_range(struct gcma_area *area,
+			     unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long scanned = 0;
+	struct folio *folio;
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+		int err;
+
+		if (!(++scanned % XA_CHECK_SCHED))
+			cond_resched();
+
+		folio = pfn_folio(pfn);
+		err = cleancache_backend_put_folio(area->pool_id, folio);
+		if (WARN(err, "PFN %lu: folio is still in use\n", pfn))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int alloc_folio_range(struct gcma_area *area,
+			      unsigned long start_pfn, unsigned long end_pfn,
+			      gfp_t gfp)
+{
+	unsigned long scanned = 0;
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+		int err;
+
+		if (!(++scanned % XA_CHECK_SCHED))
+			cond_resched();
+
+		err = cleancache_backend_get_folio(area->pool_id, pfn_folio(pfn));
+		if (err) {
+			free_folio_range(area, start_pfn, pfn);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static struct gcma_area *find_area(unsigned long start_pfn, unsigned long end_pfn)
+{
+	int nr_area = atomic_read_acquire(&nr_gcma_area);
+	int i;
+
+	for (i = 0; i < nr_area; i++) {
+		struct gcma_area *area = &areas[i];
+
+		if (area->end_pfn <= start_pfn)
+			continue;
+
+		if (area->start_pfn > end_pfn)
+			continue;
+
+		/* The entire range should belong to a single area */
+		if (start_pfn < area->start_pfn || end_pfn > area->end_pfn)
+			break;
+
+		/* Found the area containing the entire range */
+		return area;
+	}
+
+	return NULL;
+}
+
+int gcma_register_area(const char *name,
+		       unsigned long start_pfn, unsigned long count)
+{
+	LIST_HEAD(folios);
+	int i, pool_id;
+	int nr_area;
+	int ret = 0;
+
+	pool_id = cleancache_backend_register_pool(name);
+	if (pool_id < 0)
+		return pool_id;
+
+	for (i = 0; i < count; i++) {
+		struct folio *folio;
+
+		folio = pfn_folio(start_pfn + i);
+		folio_clear_reserved(folio);
+		folio_set_count(folio, 0);
+		list_add(&folio->lru, &folios);
+	}
+
+	cleancache_backend_put_folios(pool_id, &folios);
+
+	spin_lock(&gcma_area_lock);
+
+	nr_area = atomic_read(&nr_gcma_area);
+	if (nr_area < MAX_GCMA_AREAS) {
+		struct gcma_area *area = &areas[nr_area];
+
+		area->pool_id = pool_id;
+		area->start_pfn = start_pfn;
+		area->end_pfn = start_pfn + count;
+		strscpy(area->name, name);
+		/* Ensure above stores complete before we increase the count */
+		atomic_set_release(&nr_gcma_area, nr_area + 1);
+	} else {
+		ret = -ENOMEM;
+	}
+
+	spin_unlock(&gcma_area_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gcma_register_area);
+
+int gcma_alloc_range(unsigned long start_pfn, unsigned long count, gfp_t gfp)
+{
+	unsigned long end_pfn = start_pfn + count;
+	struct gcma_area *area;
+	struct folio *folio;
+	int err, order = 0;
+
+	gfp = current_gfp_context(gfp);
+	if (gfp & __GFP_COMP) {
+		if (!is_power_of_2(count))
+			return -EINVAL;
+
+		order = ilog2(count);
+		if (order >= MAX_PAGE_ORDER)
+			return -EINVAL;
+	}
+
+	area = find_area(start_pfn, end_pfn);
+	if (!area)
+		return -EINVAL;
+
+	err = alloc_folio_range(area, start_pfn, end_pfn, gfp);
+	if (err)
+		return err;
+
+	/*
+	 * GCMA returns pages with refcount 1 and expects them to have
+	 * the same refcount 1 when they are freed.
+	 */
+	if (order) {
+		folio = pfn_folio(start_pfn);
+		set_page_count(&folio->page, 1);
+		prep_compound_page(&folio->page, order);
+	} else {
+		for (unsigned long pfn = start_pfn; pfn < end_pfn; pfn++) {
+			folio = pfn_folio(pfn);
+			set_page_count(&folio->page, 1);
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gcma_alloc_range);
+
+int gcma_free_range(unsigned long start_pfn, unsigned long count)
+{
+	unsigned long end_pfn = start_pfn + count;
+	struct gcma_area *area;
+	struct folio *folio;
+
+	area = find_area(start_pfn, end_pfn);
+	if (!area)
+		return -EINVAL;
+
+	folio = pfn_folio(start_pfn);
+	if (folio_test_large(folio)) {
+		int expected = folio_nr_pages(folio);
+
+		if (WARN(count != expected, "PFN %lu: count %lu != expected %d\n",
+			  start_pfn, count, expected))
+			return -EINVAL;
+
+		if (WARN(!folio_ref_dec_and_test(folio),
+			 "PFN %lu: invalid folio refcount when freeing\n", start_pfn))
+			return -EINVAL;
+
+		free_pages_prepare(&folio->page, folio_order(folio));
+	} else {
+		for (unsigned long pfn = start_pfn; pfn < end_pfn; pfn++) {
+			folio = pfn_folio(pfn);
+			if (folio_nr_pages(folio) == 1)
+				count--;
+
+			if (WARN(!folio_ref_dec_and_test(folio),
+				 "PFN %lu: invalid folio refcount when freeing\n", pfn))
+				return -EINVAL;
+
+			free_pages_prepare(&folio->page, 0);
+		}
+		WARN(count != 0, "%lu pages are still in use!\n", count);
+	}
+
+	return free_folio_range(area, start_pfn, end_pfn);
+}
+EXPORT_SYMBOL_GPL(gcma_free_range);
-- 
2.51.0.740.g6adb054d12-goog


