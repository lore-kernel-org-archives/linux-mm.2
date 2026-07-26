Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96543C53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9396B00AD; Sun, 26 Jul 2026 18:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47B456B00AF; Sun, 26 Jul 2026 18:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396156B00AD; Sun, 26 Jul 2026 18:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED80B6B00AD
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6133EC057D
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:57 +0000 (UTC)
X-FDA: 85032356514.20.4B05AD3
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf05.hostedemail.com (Postfix) with ESMTP id C7736100006
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Unyfvk/p";
	spf=pass (imf05.hostedemail.com: domain of 3-ohmaggKCAEkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3-ohmaggKCAEkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6hRRnJQqZXa1O28Chntp/zzM0bY91KHiD/wCw7TAk0=;
	b=1o+ZEgZzpQzjvo0cKkE9xHPF68sK5WgGc69kf2CnnQ5eKdYr5PEV5WvBPH1nTnVjd2IRec
	3z45c7L6bfxFqrdTJQeHXSDI5W2M7P0zbHURbs7hEQj7hcFb1WRFJaQ7exUgGsWErwxfFt
	QcsRoRbUZkQ8R5JmzkjkEvU5dFU3Zs0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Unyfvk/p";
	spf=pass (imf05.hostedemail.com: domain of 3-ohmaggKCAEkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3-ohmaggKCAEkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104635;
	b=3ZJvcecyEdQVuoRBKNmyyzBCrfoGyd7Lpi3EcamHSwOEs9bVtHUzz38hWU5uQGt9gPCpAI
	2zVOUmXgCq156rF4duPj8y0hUZu4YVqIPddX2OCNxHSYg6QkSbbsFZBJ1dwXYWc9S6yZJB
	cNXvJ1ukYWvVF2nXfON9tOBmI871lrs=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4955fd77c18so13908225e9.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104634; x=1785709434; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O6hRRnJQqZXa1O28Chntp/zzM0bY91KHiD/wCw7TAk0=;
        b=Unyfvk/pFHEZgKWnGDLiTS3h0+Hci/8NsGPbSmumrlvk4mWJ7gwLXgAqfQTwFlLV/L
         4IlCnyhWWMfgqhA0Eu0td4EMiJ41yGcj63lCIYpgWN1cExlLDwnSF12zUn846hjJQqPx
         umMD4Z1cEFg03CbshYFLXNtP8ODVOWYDcXs9GkBHgxtX60sbdu5F7hCP0YuVOHHMlOjW
         W/E7xrYmwrCHkfPml8Lc4fQSUsB+W5WOW8ivZaamgvbwpYNzFAJLOYgQmdVXY6hwIYmX
         OYgki1JNmM/kAGrHLw/m6loR3kry/BZ1gbHkKPbXAVbOdpEzkX5fJDyBXFARMoGFfwZm
         xKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104634; x=1785709434;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O6hRRnJQqZXa1O28Chntp/zzM0bY91KHiD/wCw7TAk0=;
        b=UKg4uCyoczftF5RbPmm956EOh/dKd2q0BSi0jCa0zohJwxkDOe9JuZMXEMXvdmZ8Bl
         ipfk7KEgmLBQekYDahYwHXic5VsC4RYK69sC0rEMRx8IWmsQ+b3vZwATNogK0lmtpQCs
         3uMQyh25MCrheoUs/CfZhRBjZkTqYOiiU6ESoPCymzDVFM1KR3md5zp7pYwSqHWj1vqv
         ZWXNTL8N1p5Ctjh2Pr1r6x3yQepvfWpwZOzWpvbPLU67dFiWQf6Si1G7gDULrwr7Wi0L
         N4ePSUL6ozWRnKIMLGTdNikDWVFmKI+lZF16Mt6xn+NQ/J7BzFRN/adPb5+w0M8DKEHC
         IpoQ==
X-Gm-Message-State: AOJu0YyNr6aE22IUrnu+kXBw+u4IDpKaOEe7RfXuAwEuOMdAizE1mAI/
	8L6oug38ZlCgFz/wKVAb3p/We7oWNBs2jfndsq6JnCr9C0fS7fJGDXusKlm+eztNnexdp7uaV29
	hOFNeosyh9fHyJg==
X-Received: from wmdd28.prod.google.com ([2002:a05:600c:a21c:b0:492:4e77:8950])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6986:b0:495:3e08:ad24 with SMTP id 5b1f17b1804b1-496b5726c49mr91895035e9.33.1785104634433;
 Sun, 26 Jul 2026 15:23:54 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:54 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
Subject: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED allocations
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: C7736100006
X-Rspam-User: 
X-Stat-Signature: xkkwxaqmwx48eoqb46gmsiac37tiiabz
X-Rspamd-Server: rspam04
X-HE-Tag: 1785104635-729090
X-HE-Meta: U2FsdGVkX18vUFKZs2/8ZCG9g0UipZB6vY7qUZkFWgAyfmVzilLech/VIwqU88tr+s/5yO38NAuXrhpMYZzVm07GFUhPUQowPBjXdrpDK2KVytHdkSNeSMij2Dp+i9/bRwSA0zdv5obs848pgTB24qB9x3HxfsRTBCmt63MJjHGlWnZVLU5aJ5k9j4BfiWpheEflVr0hR0QsMP5nI7SHh3/2h5BTVgpbC46ZoQ2rVJjF3WVYOINlzffpFk1YxC7TCZCM5blsBpeMtPk5FYKcXA7ujLbV+40f93ZwoVdxVs7pjRTguVqD2FQ2cujDBtgtVgE8vxJMn+yNt8t6ComH+PQOMiB4lBBf3GSyRrFXEKH8oC/VbJhyB1wcpUsKKbLnXQF5NytUtjVC3qxTeU8gOkAoPywVPmaOMxcg6mBvGXBdHhxACH5jhVjfs+6zINhwFXC9LtYp2hRAYaCK6LNYRUHhzdOr78zketkJimECw+1V+ZhcAyPONVP1CriTl6Eqw9vaxDQj5nBNyBukmKCpIDDp8uTiCJoDD+wqKFVL98/Ltp35AJocNfe7mTMpQdJN+dF41e2agG79cU0xaYxGr88KVpeSYWaTNaQTm3kolVVsxdAr9h/h8E8FPk21doDjXIiCcBftZWIaSn89g9Piy821cPN3+26PZ2ETpA8Op1eNJPNy6ga6RWQlgscBgqKO3xuQwOqWl3WuFmHqWHc5Y6B3C+H7OUegUWuxP7/FU6gWlNmDEFG1ppHarGC16SU2c6AIO/cPo5GzHHFjneQCPaQimliXdlHxPyRkDsjWyWdg2VU1MtX1YY6aqpRypL8/YbThWr8McSOfppjXFEwe3D2t+Oei4nqQ663TOwTbB3vK6Bqw3NK22RSkpU50Lba3W64f3eKMwgKcZJ9ev5fquwoTBRX3lap5koxtkZCSnSV4BxQoOM5sIVlmORUD7QUNNhXctrqLBWj/vdoVoFY
 SgMJuXWI
 OUm8WBFif+wFryl5pFV9cfmasK+aj+qSF0gygrF5C1Y0PfxzK1W1WjszOfMWf/0EtTcG/VUE+fp+lySwh+wQCcnE9g4P+/Cew7Ml3vvAiTiGi35Hl3maa/mklkqmQ+TOpMXOpXzwwWtImI96xhN2+GxSKa4TyFLwMCrrPuhpRTcQXGf0cQbWnKaIk+E3c9iU0t7Qbc4w7mhk9X+mnlKi2n7VEtOOJRg20tmFv0bZd9FhItI/wvoskIowj+DehUViFmirI7Rx5TLb49IC3p7PJcTcoBMq+yXz6Bjr3wQxmOh3RxPK5AqECH8RT1Fpru8aZMK9uzh7hIBBeJ8OabdD7YjiDKVi3zc5vpRqS2SUNE3kSQ7lEh8ANQyNQptMeb5JflRNDzQaopNwN9HIPkVCcMzD4WmT/9F/FL8vJNy3rjCUVxG8voxaO5Ez6gDhO8+bo1qCt/NnxUoZEubQ6Xi2K9aICpsbeoULt9atYP0plOT7EDZJZQAbUxTc4XV0xT4W89iF0VfjD+4TnrJ6Zm1Vm750T+2AgVITthu/iHhsEmm9DOzy0YTJcgU3yS905B5rXuoPBqC4c0fX1xxG1MLtFRKkndGMUHvpfa0TjkrMiytISGqWRTynDfH2wtjpw3woTwNCF2iVMye3axDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently FREETYPE_UNMAPPED allocs will always fail because, although the
lists exist to hold them, there is no way to actually create an unmapped
page block. This commit adds one, and also the logic to map it back
again when that's needed.

Doing this at pageblock granularity ensures that the pageblock flags can
be used to infer which freetype a page belongs to. It also provides nice
batching of TLB flushes, and also avoids creating too much unnecessary
TLB fragmentation in the physmap.

There are some functional requirements for flipping a block:

 - Unmapping requires a TLB shootdown, meaning IRQs must be enabled.

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

Adding alloc_flags to gfp_freetype() requires moving it to
mm/page_alloc.h so it can refer to ALLOC_UNMAPPED. It was already only
used in internal mm code.

Now that unmapped pageblocks actually exist, exclude them from
migration. Migrating unmapped pages via the mermap should be possible
but that's something to be added later when needed.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/Kconfig      |   7 +-
 mm/compaction.c |   8 ++-
 mm/page_alloc.c | 214 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 mm/page_alloc.h |  13 +++-
 mm/page_owner.c |   6 +-
 5 files changed, 215 insertions(+), 33 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index aa5f041ce1a67..6a89cbf8e8c6e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1527,9 +1527,10 @@ config MERMAP_KUNIT_TEST
 
 	  If unsure, say N.
 
+config PAGE_ALLOC_UNMAPPED
+	bool
+	depends on !HIGHMEM
+
 source "mm/damon/Kconfig"
 
 endmenu
-
-config PAGE_ALLOC_UNMAPPED
-	bool
diff --git a/mm/compaction.c b/mm/compaction.c
index 67b01af024e17..c9eb3947ffc79 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1393,6 +1393,9 @@ static bool suitable_migration_source(struct compact_control *cc,
 	block_ft = get_pageblock_freetype(page);
 	block_mt = free_to_migratetype(block_ft);
 
+	if (freetype_unmapped(get_pageblock_freetype(page)))
+		return false;
+
 	/*
 	 * CMA pages can only be taken by ALLOC_CMA requests. For anybody
 	 * else, vacating a CMA block consumes free pages the caller
@@ -1444,6 +1447,9 @@ static bool suitable_migration_target(struct compact_control *cc,
 			return false;
 	}
 
+	if (freetype_unmapped(get_pageblock_freetype(page)))
+		return false;
+
 	if (cc->ignore_block_suitable)
 		return true;
 
@@ -2588,7 +2594,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 		INIT_LIST_HEAD(&cc->freepages[order]);
 	INIT_LIST_HEAD(&cc->migratepages);
 
-	cc->freetype = gfp_freetype(cc->gfp_mask);
+	cc->freetype = gfp_freetype(cc->gfp_mask, cc->alloc_flags);
 
 	if (!is_via_compact_memory(cc->order)) {
 		ret = compaction_suit_allocation_order(cc->zone, cc->order,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ecdd3780192e8..ce06ed0d65d8d 100644
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
@@ -1001,6 +1002,26 @@ static void change_pageblock_range(struct page *pageblock_page,
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
@@ -1069,9 +1090,7 @@ static inline void __free_one_page(struct page *page,
 			buddy_ft = get_pfnblock_freetype(buddy, buddy_pfn);
 			buddy_mt = free_to_migratetype(buddy_ft);
 
-			if (migratetype != buddy_mt &&
-			    (!migratetype_is_mergeable(migratetype) ||
-			     !migratetype_is_mergeable(buddy_mt)))
+			if (!can_merge_freetypes(freetype, buddy_ft))
 				goto done_merging;
 		}
 
@@ -1088,7 +1107,9 @@ static inline void __free_one_page(struct page *page,
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
@@ -1409,7 +1430,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 {
 	int bad = 0;
 	bool skip_kasan_poison = should_skip_kasan_poison(page);
-	bool init = want_init_on_free();
+	bool init = want_init_on_free() && !freetype_unmapped(get_pageblock_freetype(page));
 	bool compound = PageCompound(page);
 	struct folio *folio = page_folio(page);
 
@@ -1900,14 +1921,19 @@ static inline bool should_skip_kasan_unpoison(gfp_t flags)
 	return flags & __GFP_SKIP_KASAN;
 }
 
-static inline bool should_skip_init(gfp_t flags)
+static inline bool should_skip_init(gfp_t gfp, unsigned int alloc_flags)
 {
 	/* Don't skip, if hardware tag-based KASAN is not enabled. */
 	if (!kasan_hw_tags_enabled())
 		return false;
 
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+	if (alloc_flags & ALLOC_UNMAPPED)
+		return true;
+#endif
+
 	/* For hardware tag-based KASAN, skip if requested. */
-	return (flags & __GFP_SKIP_ZERO);
+	return (gfp & __GFP_SKIP_ZERO);
 }
 
 inline void post_alloc_hook(struct page *page, unsigned int order,
@@ -1915,7 +1941,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 {
 	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
-			!should_skip_init(gfp_flags);
+			!should_skip_init(gfp_flags, alloc_flags);
 	int i;
 
 	set_page_private(page, 0);
@@ -3344,7 +3370,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 			 * Only change normal pageblocks (i.e., they can merge
 			 * with others)
 			 */
-			if (migratetype_is_mergeable(free_to_migratetype(ft)))
+			if (can_merge_freetypes(old_ft, new_ft))
 				move_freepages_block(zone, page, old_ft, new_ft);
 		}
 	}
@@ -3400,6 +3426,127 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
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
+	int nr_pageblocks, nr_freed;
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
+	if (!can_set_direct_map() || alloc_flags & ALLOC_NOLOCK)
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
+	/* First try a block that already has the right migratetype. */
+	page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
+	if (!page) {
+		/* Fallback to changing a block's migratetype. */
+		rmqm = RMQUEUE_CLAIM;
+		page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
+	}
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
+	 *   an "assumption" as it's in direct control of page_alloc.c).
+	 *
+	 * - Once pages in the direct map are broken down, they are not
+	 *   re-aggregated into larger pages again.
+	 *
+	 * - Pagetables are never allocated with ALLOC_UNMAPPED.
+	 *
+	 * Under these assumptions, a pagetable might need to be allocated while
+	 * _unmapping_ stuff from the direct map during an ALLOC_UNMAPPED
+	 * allocation. But, the allocation of that pagetable never requires
+	 * allocating a further pagetable.
+	 */
+	err = set_direct_map_valid_noflush(page,
+				nr_pageblocks << pageblock_order, want_mapped);
+	if (err == -ENOMEM || WARN_ONCE(err, "err=%d\n", err)) {
+		set_direct_map_valid_noflush(page,
+				nr_pageblocks << pageblock_order, !want_mapped);
+		spin_lock_irqsave(&zone->lock, irq_flags);
+		/* Important: free using _old_ freetype. */
+		__free_one_page(page, page_to_pfn(page), zone,
+				alloc_order, ft_other, FPI_SKIP_REPORT_NOTIFY);
+		spin_unlock_irqrestore(&zone->lock, irq_flags);
+		return NULL;
+	}
+
+	if (want_mapped) {
+		/* Exposing formerly-protected data; scrub it. */
+		clear_highpages_kasan_tagged(page, nr_pageblocks << pageblock_order);
+	} else {
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
+	nr_freed = expand(zone, page, request_order, alloc_order, freetype);
+	account_freepages(zone, nr_freed, free_to_migratetype(freetype));
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
@@ -3433,13 +3580,15 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
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
 
 	/*
@@ -3660,6 +3809,8 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 		return;
 
 	ft_high = freetype_with_migrate(ft, MIGRATE_HIGHATOMIC);
+	if (freetype_idx(ft_high) < 0)
+		return;
 	if (order < pageblock_order) {
 		if (move_freepages_block(zone, page, ft, ft_high) == -1)
 			return;
@@ -3975,13 +4126,15 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 }
 
 /* Must be called after current_gfp_context() which can change gfp_mask */
-static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
+static inline unsigned int alloc_flags_cma(gfp_t gfp_mask, unsigned int alloc_flags)
 {
 #ifdef CONFIG_CMA
-	if (free_to_migratetype(gfp_freetype(gfp_mask)) == MIGRATE_MOVABLE)
-		return ALLOC_CMA;
+	if (free_to_migratetype(gfp_freetype(gfp_mask, alloc_flags)) == MIGRATE_MOVABLE)
+		alloc_flags |= ALLOC_CMA;
 #endif
-	return ALLOC_DEFAULT;
+	alloc_flags |= ALLOC_DEFAULT;
+
+	return alloc_flags;
 }
 
 /*
@@ -4770,7 +4923,7 @@ alloc_flags_slowpath(gfp_t gfp_mask, unsigned int order)
 	} else if (unlikely(rt_or_dl_task(current)) && in_task())
 		alloc_flags |= ALLOC_MIN_RESERVE;
 
-	alloc_flags |= alloc_flags_cma(gfp_mask);
+	alloc_flags = alloc_flags_cma(gfp_mask, alloc_flags);
 
 	if (defrag_mode)
 		alloc_flags |= ALLOC_NOFRAGMENT;
@@ -5085,7 +5238,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = alloc_flags_cma(gfp_mask) | reserve_flags |
+		alloc_flags = alloc_flags_cma(gfp_mask, alloc_flags) | reserve_flags |
 				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
 
 	/*
@@ -5307,7 +5460,11 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
 	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
 	ac->nodemask = nodemask;
-	ac->freetype = gfp_freetype(gfp_mask);
+	ac->freetype = gfp_freetype(gfp_mask, *alloc_flags);
+
+	/* Not implemented yet. */
+	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED && gfp_mask & __GFP_ZERO)
+		return false;
 
 	if (cpusets_enabled()) {
 		*alloc_gfp |= __GFP_HARDWALL;
@@ -5331,7 +5488,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	*alloc_flags |= alloc_flags_cma(gfp_mask);
+	*alloc_flags = alloc_flags_cma(gfp_mask, *alloc_flags);
 
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
@@ -5590,6 +5747,16 @@ static inline bool alloc_nolock_allowed(void)
 static const gfp_t gfp_nolock = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC |
 				__GFP_COMP;
 
+/*
+ * ALLOC_ flags other mm callers are allowed to set. More could be trivially
+ * added here if needed.
+ */
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+#define SUPPORTED_INPUT_ALLOC_FLAGS ALLOC_NOLOCK | ALLOC_NO_CODETAG | ALLOC_UNMAPPED
+#else
+#define SUPPORTED_INPUT_ALLOC_FLAGS ALLOC_NOLOCK | ALLOC_NO_CODETAG
+#endif
+
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
@@ -5603,8 +5770,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	};
 	unsigned int fastpath_alloc_flags = ac.alloc_flags;
 
-	/* Other flags could be supported later if needed. */
-	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
+	if (WARN_ON(alloc_flags & ~(SUPPORTED_INPUT_ALLOC_FLAGS)))
 		return NULL;
 
 	if (!alloc_order_allowed(gfp, order, alloc_flags))
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 02db12c9a1dc2..5fa8fc527347c 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -308,9 +308,10 @@ static inline bool free_area_empty(struct free_area *area, freetype_t freetype)
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
 #define GFP_MOVABLE_SHIFT 3
 
-static inline freetype_t gfp_freetype(const gfp_t gfp_flags)
+static inline freetype_t gfp_freetype(const gfp_t gfp_flags, unsigned int alloc_flags)
 {
 	unsigned int migratetype;
+	unsigned int ft_flags = 0;
 
 	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
@@ -327,7 +328,15 @@ static inline freetype_t gfp_freetype(const gfp_t gfp_flags)
 			>> GFP_MOVABLE_SHIFT;
 	}
 
-	return migrate_to_freetype(migratetype, 0);
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+	if (alloc_flags & ALLOC_UNMAPPED) {
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
diff --git a/mm/page_owner.c b/mm/page_owner.c
index ed7fcc0d70f3f..e86d2028d26c6 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -527,7 +527,7 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 
 			page_owner = get_page_owner(page_ext);
 			page_mt = free_to_migratetype(
-					gfp_freetype(page_owner->gfp_mask));
+				gfp_freetype(page_owner->gfp_mask, ALLOC_DEFAULT));
 			if (pageblock_mt != page_mt) {
 				if (is_migrate_cma(pageblock_mt))
 					count[MIGRATE_MOVABLE]++;
@@ -626,7 +626,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
-	page_mt  = free_to_migratetype(gfp_freetype(page_owner->gfp_mask));
+	page_mt  = free_to_migratetype(gfp_freetype(page_owner->gfp_mask, ALLOC_DEFAULT));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"PFN 0x%lx type %s Block %lu type %s Flags %pGp\n",
 			pfn,
@@ -686,7 +686,7 @@ void __dump_page_owner(const struct page *page)
 
 	page_owner = get_page_owner(page_ext);
 	gfp_mask = page_owner->gfp_mask;
-	mt = free_to_migratetype(gfp_freetype(gfp_mask));
+	mt = free_to_migratetype(gfp_freetype(gfp_mask, ALLOC_DEFAULT));
 
 	if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags)) {
 		pr_alert("page_owner info is not present (never set?)\n");

-- 
2.54.0


