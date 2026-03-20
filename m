Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D211099B28
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1FD46B0108; Fri, 20 Mar 2026 14:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB686B010A; Fri, 20 Mar 2026 14:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22416B010C; Fri, 20 Mar 2026 14:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B774C6B0108
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 587C28B48E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:11 +0000 (UTC)
X-FDA: 84567265902.20.25F894E
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7ED9220009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CAo7kesD;
	spf=pass (imf13.hostedemail.com: domain of 3yJC9aQgKCDUaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3yJC9aQgKCDUaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmuhGhakzZFYu28HDdkVQ0mpwo8v3L3XufzB+0jvTvE=;
	b=IwqPdivCFho3Gp60eRzJpF/f3tu+o/whVFIYgqISKb7/H73GDeEbmbyIp+g5iP503SpDG0
	SwvgxQl2BMOcSs6AMrzvbRRY92KFsKBRQcm89x1UVDOUWtlBqZ3PWPVwgQ22jvr0te0AeA
	+/KoDnKm/TqAnyb6HYT5wQQKqpL//k8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031049; a=rsa-sha256;
	cv=none;
	b=JXUNEdOuFVY9O805U9+c8ymUHTqbuWoA7or/5Gn4n+/5pVjcQsMW8/jtbS34tx7HGQZUNh
	rayHHWR07F1WDJ44tgfKrYD2X4kQ7akI32WSfBo8t5ITI+cPldUW4LWKLjI9WNamxkGX2b
	qWfcPAmQXbTtqcopKyvoNqPjQpB3808=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CAo7kesD;
	spf=pass (imf13.hostedemail.com: domain of 3yJC9aQgKCDUaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3yJC9aQgKCDUaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853466655dso25090045e9.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031048; x=1774635848; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AmuhGhakzZFYu28HDdkVQ0mpwo8v3L3XufzB+0jvTvE=;
        b=CAo7kesDB19Eiluj466/MHvAaWFUuBHt3RMv5BdMH/q+jJb18CqlKmtW4yQYV0yAj0
         G13yDt1DU2OzJD9zNtGEyE78ET+XGwmiliLK5+uxJLq9e8GpUkkIoItRYWbYT8kp8yPp
         dOOsFbIy8hXg9vZP/kPrZeN+LJiUU2rHfsg7Q+gm+8jX7I4AYcaNXbkc9yncW11RPjUX
         w2VlHwhoqn6MbbjePWFtXDg4TcZeJ8pgig2J82YAUDvWOnhTaA790L5BQiAujW3cAhqT
         wbJ17x7j+QJ0vsOIps0uJzjCmMaa1/gzL+Cpq/OzIh/320UTqzVPKSpCq9oNgm5QTmEl
         CvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031048; x=1774635848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AmuhGhakzZFYu28HDdkVQ0mpwo8v3L3XufzB+0jvTvE=;
        b=Sjrcn8owzIfMZxLUSViJW4dSOUXx0AUHJFhwPI4njSBhN9zGNLepb94NhErg4QyEED
         sfAQGTk+4oVXMHgam3wj8bVFyxkHzQzYF2WAmUrnPo3vd1r92jMP1jVJCoNF+ZY/WCR5
         cujcIi5w4aNGFEZgcxDZFyG3SxFuzcjFFCX3hLdEA9gTeCGKzCrd9hCyui9z1lVTcut0
         Lj3Ydr3HRG6ttEf1D7PsNXqqdxHpdmMADRlfCAW5l9w+e9ftv7mcCEGsyTJ5cMn6152k
         5yTbcXQU3EKIZJjg9Gp07vxUf0vAhQrm0AgwvZ4g7DFaXSEPqX0kXLhQQ6es0l4OECw5
         A0Pg==
X-Gm-Message-State: AOJu0Yx6XM74L03D98aNENoJH3DwuZcYpjEzBl6xu2i1aDrJ+0oL/G3c
	s3JJ6hb4JD/5b+vY9ttBQogEnxVmTHIB/1RyT18Felq7tzWlL2FNtrg95IT27CSqzOX+UniPlg1
	NWZzbqo9LWHzTCQ==
X-Received: from wmov7.prod.google.com ([2002:a05:600c:4707:b0:485:e4e3:1273])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a69d:b0:487:288:1198 with SMTP id 5b1f17b1804b1-487028812b5mr20233625e9.22.1774031048066;
 Fri, 20 Mar 2026 11:24:08 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:43 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-19-28bf1bd54f41@google.com>
Subject: [PATCH v2 19/22] mm/page_alloc: implement __GFP_UNMAPPED allocations
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7ED9220009
X-Stat-Signature: ytc56jge7hr31acy4duqs7ce58xj9kqw
X-HE-Tag: 1774031049-191721
X-HE-Meta: U2FsdGVkX188liK0ELYMb0hFI0Y+znZX+mIshfmkmQh68A9DoEaFMmHOCyNifHk2TWcDDE5QLdTFgX08AwVzPwbUxP4li8UlS8plJm86azH+faZMz+zAPd8e+yFy+xA76rlI6ZMDkQE3M5bWepl1Ku8t6uBcDgYeTFWH66+IQf2QezrKjW4LogO9w1J+kZwVsncjNeDiEIJ/UIAMG71XEB3+MJE+jJqndiTqxZuqmuAedqrLHEcwhYe8EirjkytDf6AbJreVut3vg+lvxAYZwTl4KHxKm/GeZ1e3z5nHzk3iAZYj87dljAr1Zv60Oy3sUdlZimsHMLa8fGC1msD9Wc+g6Gi676EAX6WwAnqFuGLzIc8ImsdB1FUfKbeDvXEfKaY7jL6YCjrw5lb6XaUQiIOL30l7l1Gx1pJLCC+n0pM1oVxcuH/lBeXWAFV2H65Fa+VS5S6Gby/ZtogDZhFEPrUlzXLj8OlpMXxfJE+9SZlOALDt31wW3iO1CVL07En8GmDml93CbSJEdGLGd63uC2+8sD0RbhaQIzvWYe8n0lQS5jdAIPPOhaoGGh1JpWZLbYjgH5DyAPSuDxBcAG1/yS/4Q+9ZolF1TvqIwMI8OthELuSNPi05+Fd4QX93PKcCqtchTWF9Rzu7hstL9yCjM+/i9N2cTY954/3oJK3MzMucA4QZUkqT/X9jBiLYtk68zRtfxtPn3a8VXxrUZe1wHuDdfaXm+MHTD0dYByfUv1Zb7TBeYbHJGlcBGP3c/nk5TVeI1g+xt8p3r6vWvuBLhfCCgz7ZAK/ezlS/3gb0FlZdF3SX7EZ1KNskMYFeQYZu9xuwBwrzTLAzniXRO9SRdGmV1msem1PKlwTYaLtHXSvIiDGeL0TYOz9s7TEJ0esdCy10XYrzuPziESEt+3SMkXBcpIc/zyvQzWSmYEj9NUe4m/LJB2bajqdGb6ki+iyNV+kUb9v6abbY1w4uzzJ
 Hl0PA5Le
 /mazkLCugeNwnA9Bf5oKH6X/fPr/85gR3dIgFyz8luBA/xIsrh94CYf9sIMZFq7YD5Ut/aXMQYWqKDtxXUsAlOkUslFrgURPXs5AMYGnj8WhJZ/74sjzuA7d7K22YCUEGgE3B0IEWdkB4qiXcDWNxu7RQp2syPhZbzxajZVF0+RK0/zCcUQwhf6n3ZEoc0xaLEXdt/uq55plTop5LQgmdp4ULNcSb4Op09ZYG0zWse4mJhw/NBL7duIkPm0t4NTMNHINIju5W1vXUAcDNLvvFd2Wo97M3yH4BbFJcE8TEn3/7aSCPKVoGdImoHQc+FaA4eGkyBBFzoYNt7Hm5rvJFCjrROJ/qAoVp7DSrr5+oq01vM4ZK6xnrAFS1V0duhKVvKo3dce6rdXL5hMZxahvwJXac/BOiYdHbDen2UBuVVWtaY0Tz00VN7qr+o1VS6d7TJQo06r8r7UrcVUBK7RP3E+cxX8ktwXux2L0joBHWJvSWeVQ84c9+UEWPf5IzbSxflQS+x3MMDKkrutDZy56aTCI4orKSYNIe+vPIwihWlJ95433vDmdXXa6lZoZ4JAUmhclrgh5QYDNqgQLBPgGna7gAxy/On9KjT14JMj1afZTlWswdmZyZxLj2V4HwK2GdKqNbbtmRI6j0Tcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently __GFP_UNMAPPED allocs will always fail because, although the
lists exist to hold them, there is no way to actually create an unmapped
page block. This commit adds one, and also the logic to map it back
again when that's needed.

Doing this at pageblock granularity ensures that the pageblock flags can
be used to infer which freetype a page belongs to. It also provides nice
batching of TLB flushes, and also avoids creating too much unnecessary
TLB fragmentation in the physmap.

There are some functional requirements for flipping a block:

 - Unmapping requires a TLB shootdown, meaning IRQs must be enabled.

 - Because the main usecase of this feature is to protect against CPU
   exploits, when a block is mapped it needs to be zeroed to ensure no
   residual data is available to attackers. Zeroing a block with a
   spinlock held seems undesirable.

 - Updating the pagetables might require allocating a pagetable to break
   down a huge page. This would deadlock if the zone lock was held.

This makes allocations that need to change sensitivity _somewhat_
similar to those that need to fallback to a different migratetype. But,
the locking requirements mean that this can't just be squashed into the
existing "fallback" allocator logic, instead a new allocator path just
for this purpose is needed.

The new path is assumed to be much cheaper than the really heavyweight
stuff like compaction and reclaim. But at present it is treated as less
desirable than the mobility-related "fallback" and "stealing" logic.
This might turn out to need revision (in particular, maybe it's a
problem that __rmqueue_steal(), which causes fragmentation, happens
before __rmqueue_direct_map()), but that should be treated as a subsequent
optimisation project.

This currently forbids __GFP_ZERO, this is just to keep the patch from
getting too large, the next patch will remove this restriction.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h |  11 +++-
 mm/Kconfig          |   4 +-
 mm/page_alloc.c     | 171 ++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 170 insertions(+), 16 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 34a38c420e84a..2d8279c6300d3 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -24,6 +24,7 @@ struct mempolicy;
 static inline freetype_t gfp_freetype(const gfp_t gfp_flags)
 {
 	int migratetype;
+	unsigned int ft_flags = 0;
 
 	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
@@ -40,7 +41,15 @@ static inline freetype_t gfp_freetype(const gfp_t gfp_flags)
 			>> GFP_MOVABLE_SHIFT;
 	}
 
-	return migrate_to_freetype(migratetype, 0);
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+	if (gfp_flags & __GFP_UNMAPPED) {
+		if (WARN_ON_ONCE(migratetype != MIGRATE_UNMOVABLE))
+			migratetype = MIGRATE_UNMOVABLE;
+		ft_flags |= FREETYPE_UNMAPPED;
+	}
+#endif
+
+	return migrate_to_freetype(migratetype, ft_flags);
 }
 #undef GFP_MOVABLE_MASK
 #undef GFP_MOVABLE_SHIFT
diff --git a/mm/Kconfig b/mm/Kconfig
index b915af74d33cc..e4cb52149acad 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1505,8 +1505,8 @@ config MERMAP_KUNIT_TEST
 
 	  If unsure, say N.
 
-endmenu
-
 config PAGE_ALLOC_UNMAPPED
 	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST
 	default COMPILE_TEST
+
+endmenu
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 83d06a6db6433..710ee9f46d467 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -34,6 +34,7 @@
 #include <linux/folio_batch.h>
 #include <linux/memory_hotplug.h>
 #include <linux/nodemask.h>
+#include <linux/set_memory.h>
 #include <linux/vmstat.h>
 #include <linux/fault-inject.h>
 #include <linux/compaction.h>
@@ -1002,6 +1003,26 @@ static void change_pageblock_range(struct page *pageblock_page,
 	}
 }
 
+/*
+ * Can pages of these two freetypes be combined into a single higher-order free
+ * page?
+ */
+static inline bool can_merge_freetypes(freetype_t a, freetype_t b)
+{
+	if (freetypes_equal(a, b))
+		return true;
+
+	if (!migratetype_is_mergeable(free_to_migratetype(a)) ||
+	    !migratetype_is_mergeable(free_to_migratetype(b)))
+		return false;
+
+	/*
+	 * Mustn't "just" merge pages with different freetype flags, changing
+	 * those requires updating pagetables.
+	 */
+	return freetype_flags(a) == freetype_flags(b);
+}
+
 /*
  * Freeing function for a buddy system allocator.
  *
@@ -1070,9 +1091,7 @@ static inline void __free_one_page(struct page *page,
 			buddy_ft = get_pfnblock_freetype(buddy, buddy_pfn);
 			buddy_mt = free_to_migratetype(buddy_ft);
 
-			if (migratetype != buddy_mt &&
-			    (!migratetype_is_mergeable(migratetype) ||
-			     !migratetype_is_mergeable(buddy_mt)))
+			if (!can_merge_freetypes(freetype, buddy_ft))
 				goto done_merging;
 		}
 
@@ -1089,7 +1108,9 @@ static inline void __free_one_page(struct page *page,
 			/*
 			 * Match buddy type. This ensures that an
 			 * expand() down the line puts the sub-blocks
-			 * on the right freelists.
+			 * on the right freelists. Freetype flags are
+			 * already set correctly because of
+			 * can_merge_freetypes().
 			 */
 			change_pageblock_range(buddy, order, migratetype);
 		}
@@ -1982,6 +2003,9 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	struct free_area *area;
 	struct page *page;
 
+	if (freetype_idx(freetype) < 0)
+		return NULL;
+
 	/* Find a page of the appropriate size in the preferred list */
 	for (current_order = order; current_order < NR_PAGE_ORDERS; ++current_order) {
 		enum migratetype migratetype = free_to_migratetype(freetype);
@@ -3324,6 +3348,119 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 #endif
 }
 
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+/* Try to allocate a page by mapping/unmapping a block from the direct map. */
+static inline struct page *
+__rmqueue_direct_map(struct zone *zone, unsigned int request_order,
+		     unsigned int alloc_flags, freetype_t freetype)
+{
+	unsigned int ft_flags_other = freetype_flags(freetype) ^ FREETYPE_UNMAPPED;
+	freetype_t ft_other = migrate_to_freetype(free_to_migratetype(freetype),
+						  ft_flags_other);
+	bool want_mapped = !(freetype_flags(freetype) & FREETYPE_UNMAPPED);
+	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
+	unsigned long irq_flags;
+	int nr_pageblocks;
+	struct page *page;
+	int alloc_order;
+	int err;
+
+	if (freetype_idx(ft_other) < 0)
+		return NULL;
+
+	/*
+	 * Might need a TLB shootdown. Even if IRQs are on this isn't
+	 * safe if the caller holds a lock (in case the other CPUs need that
+	 * lock to handle the shootdown IPI).
+	 */
+	if (alloc_flags & ALLOC_NOBLOCK)
+		return NULL;
+
+	if (!can_set_direct_map())
+		return NULL;
+
+	lockdep_assert(!irqs_disabled() || unlikely(early_boot_irqs_disabled));
+
+	/*
+	 * Need to [un]map a whole pageblock (otherwise it might require
+	 * allocating pagetables). First allocate it.
+	 */
+	alloc_order = max(request_order, pageblock_order);
+	nr_pageblocks = 1 << (alloc_order - pageblock_order);
+	zone_lock_irqsave(zone, irq_flags);
+	page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
+	zone_unlock_irqrestore(zone, irq_flags);
+	if (!page)
+		return NULL;
+
+	/*
+	 * Now that IRQs are on it's safe to do a TLB shootdown, and now that we
+	 * released the zone lock it's possible to allocate a pagetable if
+	 * needed to split up a huge page.
+	 *
+	 * Note that modifying the direct map may need to allocate pagetables.
+	 * What about unbounded recursion? Here are the assumptions that make it
+	 * safe:
+	 *
+	 * - The direct map starts out fully mapped at boot. (This is not really
+	 *   an assumption" as its in direct control of page_alloc.c).
+	 *
+	 * - Once pages in the direct map are broken down, they are not
+	 *   re-aggregated into larger pages again.
+	 *
+	 * - Pagetables are never allocated with __GFP_UNMAPPED.
+	 *
+	 * Under these assumptions, a pagetable might need to be allocated while
+	 * _unmapping_ stuff from the direct map during a __GFP_UNMAPPED
+	 * allocation. But, the allocation of that pagetable never requires
+	 * allocating a further pagetable.
+	 */
+	err = set_direct_map_valid_noflush(page,
+				nr_pageblocks << pageblock_order, want_mapped);
+	if (err == -ENOMEM || WARN_ONCE(err, "err=%d\n", err)) {
+		zone_lock_irqsave(zone, irq_flags);
+		__free_one_page(page, page_to_pfn(page), zone,
+				alloc_order, freetype, FPI_SKIP_REPORT_NOTIFY);
+		zone_unlock_irqrestore(zone, irq_flags);
+		return NULL;
+	}
+
+	if (!want_mapped) {
+		unsigned long start = (unsigned long)page_address(page);
+		unsigned long end = start + (nr_pageblocks << (pageblock_order + PAGE_SHIFT));
+
+		flush_tlb_kernel_range(start, end);
+	}
+
+	for (int i = 0; i < nr_pageblocks; i++) {
+		struct page *block_page = page + (pageblock_nr_pages * i);
+
+		set_pageblock_freetype_flags(block_page, freetype_flags(freetype));
+	}
+
+	if (request_order >= alloc_order)
+		return page;
+
+	/* Free any remaining pages in the block. */
+	zone_lock_irqsave(zone, irq_flags);
+	for (unsigned int i = request_order; i < alloc_order; i++) {
+		struct page *page_to_free = page + (1 << i);
+
+		__free_one_page(page_to_free, page_to_pfn(page_to_free), zone,
+			i, freetype, FPI_SKIP_REPORT_NOTIFY);
+	}
+	zone_unlock_irqrestore(zone, irq_flags);
+
+	return page;
+}
+#else /* CONFIG_PAGE_ALLOC_UNMAPPED */
+static inline struct page *__rmqueue_direct_map(struct zone *zone, unsigned int request_order,
+				unsigned int alloc_flags, freetype_t freetype)
+{
+	return NULL;
+}
+#endif /* CONFIG_PAGE_ALLOC_UNMAPPED */
+
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
@@ -3331,8 +3468,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 {
 	struct page *page;
 	unsigned long flags;
-	freetype_t ft_high = freetype_with_migrate(freetype,
-						       MIGRATE_HIGHATOMIC);
+	freetype_t ft_high = freetype_with_migrate(freetype, MIGRATE_HIGHATOMIC);
 
 	do {
 		page = NULL;
@@ -3357,13 +3493,15 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 */
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
 				page = __rmqueue_smallest(zone, order, ft_high);
-
-			if (!page) {
-				zone_unlock_irqrestore(zone, flags);
-				return NULL;
-			}
 		}
 		zone_unlock_irqrestore(zone, flags);
+
+		/* Try changing direct map, now we've released the zone lock */
+		if (!page)
+			page = __rmqueue_direct_map(zone, order, alloc_flags, freetype);
+		if (!page)
+			return NULL;
+
 	} while (check_new_pages(page, order));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3587,6 +3725,8 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 						bool force)
 {
+	freetype_t ft_high = freetype_with_migrate(ac->freetype,
+					MIGRATE_HIGHATOMIC);
 	struct zonelist *zonelist = ac->zonelist;
 	unsigned long flags;
 	struct zoneref *z;
@@ -3595,6 +3735,9 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 	int order;
 	int ret;
 
+	if (freetype_idx(ft_high) < 0)
+		return false;
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->highest_zoneidx,
 								ac->nodemask) {
 		/*
@@ -3608,8 +3751,6 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 		zone_lock_irqsave(zone, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
-			freetype_t ft_high = freetype_with_migrate(ac->freetype,
-							MIGRATE_HIGHATOMIC);
 			unsigned long size;
 
 			page = get_page_from_free_area(area, ft_high);
@@ -5109,6 +5250,10 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	ac->nodemask = nodemask;
 	ac->freetype = gfp_freetype(gfp_mask);
 
+	/* Not implemented yet. */
+	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED && gfp_mask & __GFP_ZERO)
+		return false;
+
 	if (cpusets_enabled()) {
 		*alloc_gfp |= __GFP_HARDWALL;
 		/*

-- 
2.51.2


