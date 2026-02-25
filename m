Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E424DFD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0A46B00D7; Wed, 25 Feb 2026 11:35:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0820F6B00D8; Wed, 25 Feb 2026 11:35:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6CB6B00D9; Wed, 25 Feb 2026 11:35:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6CD76B00D7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:35:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B2931C1A7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:35:02 +0000 (UTC)
X-FDA: 84483528444.10.CB22096
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id C5AB618000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:35:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2FBxtAZT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3sySfaQgKCMw1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3sySfaQgKCMw1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037300; a=rsa-sha256;
	cv=none;
	b=BPbxmUpsYW7Xg8JIG0jhZ/VYxXvXCR/nHbxKePkwiYfvImsxZCFxhY33tnXhEXXgZMFpwj
	2u0dGNRy3uKUQbMkqAN0C8H4mF+Y9GnUvXVAnagB2QwSmC+2YYqlZTEHysTPi5oN36iNaP
	NMaBZAJu3FzmdK0NuyiAlYKzyXDWSUQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2FBxtAZT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3sySfaQgKCMw1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3sySfaQgKCMw1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/nafNPyke0FSiG9yz/rspM9/pGf7x0iSrG2uzWUqdI=;
	b=DfAWxJd1HSowxc4uKZC2tTMUYYPeghL785IjOB8Bsoe1zgpfEvOJ7DcavgBkDSedz+Cyne
	TrZ8+ngPuOB5QusmmGIIEbEqSRFtr68rzD+PJZpYTN+YtlFg+I3dVX4QGLnY5bVM1G1ijz
	zjfefpKyK9Bnv/J4+ZIoOuq5M/E0Sgs=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-483bcfdaf7dso18353895e9.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037299; x=1772642099; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k/nafNPyke0FSiG9yz/rspM9/pGf7x0iSrG2uzWUqdI=;
        b=2FBxtAZTka9JNLSjhbu9FCJRv70BzrLhKK+EzzcMLJydmrrN1qdu+1EcM0YR+pyYSQ
         /qm/7zKJqq95VOa37FM2acDDxmTD5BD9pRtPeRbMLbSB0lGat/zhLgNbynAntbGERlBf
         1gTFtGY8qBaMjVYRbZI0kN0fz3gq8pIKL/5DzJJ/9WFjeL5AfQ+reBD5Ir0gIuAOW7gB
         jqohE6Pdw+2JBjtUCcUpXyh2rWLXXMBG59+/9ud+Qb9QiQ/SYRCjFPlEzd/jUyp6/jTY
         zVVY5F9GQKxDv5dGiTSbCTey4Q2dC9lwl9Vyu6Qhz7Ridv8OkzYArEBXYFtrlEBgVjya
         DI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037299; x=1772642099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k/nafNPyke0FSiG9yz/rspM9/pGf7x0iSrG2uzWUqdI=;
        b=im24xzm4j4XLY5y87qXJ1oflWdtrt9PNjTdkGhj2dlBFEsGe2IOMca6cRwipl5u7X3
         FOISV6s7bFvNvQ6YiggNPdIfrmWHZqk8S2jx0GNBrRWdBoWNEvc4e47/u2+AePPbRbDV
         cESpZK1HWbIUxn2nMR3QJpxLYsrd/VjOgPcsyO5gi1zHLR8a0VIMfZefJaAnmVqwgQIk
         Y94TMoZovWwZoupU2/EAgUK1D+PoFvB6mfPCljPUWo4+wVCbQF+j73W7N8wWht0KzIrY
         shsufYOqAzYLjll65HZGE3xksLc3ZvnV/MyvkBHHVzwJF02E0geQSYshKdc6ilnYVZDa
         umVA==
X-Gm-Message-State: AOJu0Yy2bpWVccI5Ywhsbigh59h/Auo8Ia3PDwaaTxMkhDWh1zftLZ5R
	izNsv0SZ+Pyfy0A1DA8CGfgJutts7Zr9jns80bUdsjXgFUCPH+svjiApJw5fiXay2TtnrbxT+OG
	pbfy4GAIQXP+1jA==
X-Received: from wmhk20.prod.google.com ([2002:a05:600c:4094:b0:483:6a60:3501])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d0a:b0:483:9139:4c29 with SMTP id 5b1f17b1804b1-483a95b58e6mr296400295e9.2.1772037299176;
 Wed, 25 Feb 2026 08:34:59 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:42 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-17-e8808a03cd66@google.com>
Subject: [PATCH RFC 17/19] mm/page_alloc: implement __GFP_UNMAPPED allocations
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C5AB618000A
X-Stat-Signature: j9zxxebbk5rg8xqrnrn4j5rm5t5qemnw
X-HE-Tag: 1772037300-851784
X-HE-Meta: U2FsdGVkX19FS0blkC4QFvuO/qeesk0ejYoMlRC6DlY2RS+FuNTlfX54qejEvgHLumMWwtqhPK4avQeLoXuKu0Pm3WQN87WTTRD6kjVAdiopSINUnRTXWfg8GmXZqH4HDgAKBScxlwhYu4TmtBoRCoh79YR5vlzC3TUSyDBiHxLkR08YmpyROtYlZq15zSm52ng8BHf1x4tmn6iUXW0zW0ZEe2Mv6/HGFIHG/XGSa2VnHVzf277SspuMEW3L56AhkJBBjm8p6Fw+gz+lUDw0PPWkAQQE0kobJBbFSRT9u/HVRVM8APxotX/UCXoDfWwm2JYeuzJVvDI4cESWlNoI5HFnB1WZzyG8rKpq2BUlQFyrBHX+eUsE/1GD9GplLkrpg74OiliIjqhVpqbYBeSbzH+AD3atbxWt7eswe/UECbAQoegSIzQ+9KoZ9pN6EhfEUqiYB3pRuhC6zJ/YB2sjmrwUUZVe7i+lyB8jYwccPFFEESFhsBVb4gPOTkqqpgKOF8DtwIy4q7SHZrorW3EV9lC7QT34gPsgmHUEDKLXPbyNC0aDW2Uoi3muNlDz6VJ/eoPcEjhoLJfGfLqlGrOxWOdwFM8pRg3zVIU70t+seJDhQOMfDirwA2rLDgPS03tkuwA+o+BXubIj3Gc76KeHjOyPpvS6cwL1HN0Lg2kavPNw9NIHgA9gkmVkC7Emg0QZRdQ5gigBvl2xGivYAOsFtcvV5e991fS1vIyl0iAbSoXHzv5f5PSP5C+UbiAXzpzHmBr4TV7+k2jTLqypgCbxTyp/weyXKLcTFD3pW4EEwezS2bpZAkUYnusgTUVfq2xCfkY93erKF1RaXoxrlmdxni3xl0Q2Isx8Qq3NNKoy6qcQD3nR9RZtcdm1VkiLxMAUBcnaJfKPLxHRKdaZJA5XKa8yaQnz7v3BrJtRioF+BJgYNO/yDN6JxULXFxqnTft+CXgr5Ia1NTrrfAjSSKv
 WnSEeTyT
 CdO60fMNwAyTXUlsWVpRrwIhw3uwNWbnUqInRIpOMXOrSmZ8JxF8O7ltsDRqZKVVJa237W/Ur1eGvdnZIhX5jcogd50ZFZVVOUfRrNXghJaS/bf1T0flpHE4vSZoQdyJoksyyphTtzroi4lqKU69iTFc1j2pqFVckuXRz9TWuU3ZYrJnRyc+EXC+lT9PItS2tb+qB9W1PKJhzvQU6Yx2CpTmla6fiO3YARslvMmmhy0/yWlzmFgOlRnE6F9OAKoESKRausv8rQ6PnffCLgOeAyHwLozFDVKalyrLyc8bvHpoIGYIJX0iMDSroLKGidZGGw2ZG6f+wtIMjXMI2YLHLBqLWj9zvRFWwzEF+UCDZFBCRNuPXszi7/+Fdc00mt0mzA/7dMFF1pW/56vJCljxlJib46m8yBDF6y4lnjHueP+gRjRPp5/i17y6MBwUQwfJWFtPeou3T/vUPN9ayXQouKn9YMzkEP6vfrUXCT+Eiy4wYT7WsMcZv2zNPe9fjk/0W3f4PDBFQOSYvTCyRbrz9IPvSaSjYOXUQ8yp1QIv7+Doh/j49X1J6je7EUSvWXhpz9ExJHXVZPUz82hejTSepggRd7cE6k2+33RBszVdV4gwQyCRLhtZiLoBPiH02uFAg9U3K4cN6u8g4p5zZAyQfYCEqXvun5CVWpn6z6IooBMajUQ3jzBJ2f560sciQJJ1ygdwH
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
 mm/page_alloc.c     | 163 ++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 164 insertions(+), 14 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index f189bee7a974c..8abc9f4b1e7e6 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -20,6 +20,7 @@ struct mempolicy;
 static inline freetype_t gfp_freetype(const gfp_t gfp_flags)
 {
 	int migratetype;
+	unsigned int ft_flags = 0;
 
 	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
@@ -36,7 +37,15 @@ static inline freetype_t gfp_freetype(const gfp_t gfp_flags)
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
index ccf1cda90cf4a..3200ea8836432 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1502,8 +1502,8 @@ config MERMAP_KUNIT_TEST
 
 	  If unsure, say N.
 
-endmenu
-
 config PAGE_ALLOC_UNMAPPED
 	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST
 	default COMPILE_TEST
+
+endmenu
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5576bd6a26b7b..f7754080dd25b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -34,6 +34,7 @@
 #include <linux/pagevec.h>
 #include <linux/memory_hotplug.h>
 #include <linux/nodemask.h>
+#include <linux/set_memory.h>
 #include <linux/vmstat.h>
 #include <linux/fault-inject.h>
 #include <linux/compaction.h>
@@ -1037,6 +1038,26 @@ static void change_pageblock_range(struct page *pageblock_page,
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
@@ -1105,9 +1126,7 @@ static inline void __free_one_page(struct page *page,
 			buddy_ft = get_pfnblock_freetype(buddy, buddy_pfn);
 			buddy_mt = free_to_migratetype(buddy_ft);
 
-			if (migratetype != buddy_mt &&
-			    (!migratetype_is_mergeable(migratetype) ||
-			     !migratetype_is_mergeable(buddy_mt)))
+			if (!can_merge_freetypes(freetype, buddy_ft))
 				goto done_merging;
 		}
 
@@ -1124,7 +1143,9 @@ static inline void __free_one_page(struct page *page,
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
@@ -3361,6 +3382,117 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
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
+	spin_lock_irqsave(&zone->lock, irq_flags);
+	page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
+	spin_unlock_irqrestore(&zone->lock, irq_flags);
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
+		__free_one_page(page, page_to_pfn(page), zone,
+				alloc_order, freetype, FPI_SKIP_REPORT_NOTIFY);
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
+	spin_lock_irqsave(&zone->lock, irq_flags);
+	for (unsigned int i = request_order; i < alloc_order; i++) {
+		struct page *page_to_free = page + (1 << i);
+
+		__free_one_page(page_to_free, page_to_pfn(page_to_free), zone,
+			i, freetype, FPI_SKIP_REPORT_NOTIFY);
+	}
+	spin_unlock_irqrestore(&zone->lock, irq_flags);
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
@@ -3394,13 +3526,15 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 */
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
 				page = __rmqueue_smallest(zone, order, ft_high);
-
-			if (!page) {
-				spin_unlock_irqrestore(&zone->lock, flags);
-				return NULL;
-			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+
+		/* Try changing direct map, now we've released the zone lock */
+		if (!page)
+			page = __rmqueue_direct_map(zone, order, alloc_flags, freetype);
+		if (!page)
+			return NULL;
+
 	} while (check_new_pages(page, order));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3625,6 +3759,8 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 						bool force)
 {
+	freetype_t ft_high = freetype_with_migrate(ac->freetype,
+					MIGRATE_HIGHATOMIC);
 	struct zonelist *zonelist = ac->zonelist;
 	unsigned long flags;
 	struct zoneref *z;
@@ -3633,6 +3769,9 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 	int order;
 	int ret;
 
+	if (freetype_idx(ft_high) < 0)
+		return false;
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->highest_zoneidx,
 								ac->nodemask) {
 		/*
@@ -3646,8 +3785,6 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
-			freetype_t ft_high = freetype_with_migrate(ac->freetype,
-							MIGRATE_HIGHATOMIC);
 			unsigned long size;
 
 			page = get_page_from_free_area(area, ft_high);
@@ -5147,6 +5284,10 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
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


