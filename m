Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A287BC53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E17D96B00AF; Sun, 26 Jul 2026 18:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8B36B00B0; Sun, 26 Jul 2026 18:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDECD6B00B1; Sun, 26 Jul 2026 18:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 987AD6B00AF
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10FB51A05C8
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:59 +0000 (UTC)
X-FDA: 85032356598.13.0A8CF3B
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5A9C71C000A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tnMt1R7b;
	spf=pass (imf20.hostedemail.com: domain of 3-4hmaggKCAIlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3-4hmaggKCAIlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104637;
	b=PWX2MizQI3IcQqgbjqPs4MXaOqBjpDMguUHvYEXOUEoOYh8hL6si3TmlvrVptQN89fCLCJ
	TgLN+lBFpab0dwt3M34jukbdk/55q1L8zB6CPKkOYSpYOPqBzSO9LAD+f/CfGx8sNMn6vY
	wMCGBtzwUAbVFxaf5Ggpm1U+WQD1kh4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tnMt1R7b;
	spf=pass (imf20.hostedemail.com: domain of 3-4hmaggKCAIlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3-4hmaggKCAIlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xd3JgApfCvRDv7qicdFEsm7ichMoDmXLKaQkBNLpibM=;
	b=6iUfvlREv2D9gMIfv4r6QXYtLPQIb3JJC+giNU4G7RI2nFl7wzyEusxp0XxwNREaK6DaBo
	K539Ps3wx35C1c59GIButDeGizaiiNBxEW5WSbCdtxy1rMS4Mp8c1nRAKPCk2yXLz6fV9m
	Z0vpV2HixuiVbgx+34UxWXEb6w9ccsI=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49544a639e9so10570775e9.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104636; x=1785709436; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xd3JgApfCvRDv7qicdFEsm7ichMoDmXLKaQkBNLpibM=;
        b=tnMt1R7bC2L0LFzGc1nXfc+qcED2RBkmaynJPPxYcM0qpBa1aZW9R9r0juAch+yuR8
         9PwFkK1mWCpi1WPxIRCw0UewiK0HVtXc7UQlDPV8SUjOG87yIzpGLxqBFtke+64wrxSu
         kh+1cZaLAtffip5N4oh20cTWp9WpsTSpHQA46vtgj9XFD3gwIKlypP4LfsoZKauoKWnZ
         5GHPCvdkd0oCOWW6ZHtNjFRGWvBXTm6dCoIMkRFwtUvobtsCuXWlob3+RMacGu2+XQJP
         tSSzlNPR0OFwqxwDzVQOB4/RS7i9YZrvHPuL2hR0wofCCNX0c4A8Fu8xM4yfVjBUtkO/
         xctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104636; x=1785709436;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xd3JgApfCvRDv7qicdFEsm7ichMoDmXLKaQkBNLpibM=;
        b=AvFKs7mpo1eZjdOSvBLjoLPcsrZNUcxg3kQzu41+Mj8isPnA8u81J2Swl03Y5YuQrj
         wUJ2YUAJ7lPj5cAySLj4EZz2ccmEPk5Tc+8hiD8xPmMyoFO3nDLhupFX5TuIVFU8QsXs
         e73lFWVhwSkNIzqXSIQr/Oge69p789JRvHCU3QxwA0/QGfXly4AnOzUoMAPxk8oncEJs
         6WyxbItqJXDm+S2rWMrpEqWmv3VxcUmWFqw9ghgOL0Wvm1KzKhd+B7Ec4X2yMjDQnmz3
         JsqA9bZDKK3ymogKrAtubFw519JGdMEKHg4ZEUAeWxhGd5OXZUO+Uzopln16x5kAWYxj
         WEew==
X-Gm-Message-State: AOJu0YwKJnnwpqDzGIeczN09rKLhINkCA9w0Ib2laJ4+yfx/qwxFGz1i
	pamsTo6sqqt1ObdHygrGJ7WwKH5d0YTx7ZmimXyQ0ggUz2ALDhE/StgOMtgP0UnOS42m4GvWHTe
	VHeg+vE7+NccFWg==
X-Received: from wmfx22.prod.google.com ([2002:a05:600c:2d16:b0:493:d884:f722])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a49:b0:495:4e12:6ae5 with SMTP id 5b1f17b1804b1-496b5754379mr81953355e9.26.1785104635734;
 Sun, 26 Jul 2026 15:23:55 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:55 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-22-6f5729aa9832@google.com>
Subject: [PATCH v3 22/26] mm: Minimal KUnit tests for some new page_alloc logic
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5A9C71C000A
X-Stat-Signature: obn11fgqzf9rd11jxushjscjqra5qgsz
X-Rspam-User: 
X-HE-Tag: 1785104637-849965
X-HE-Meta: U2FsdGVkX18jS8KInQsxyw4luc0P0LzGC2ScCe4K+3gcOVCuobnejPYZYB68H4tfUk+Tv2HQdxa+z6rzc9L4sbzRLAYo00rEHpgr3HicZ7Dt7h2I+etaWRmuTKyVd+nNPPgcIPmLzZkLKNGoBBtg17f+xnCo/v0LU/Kkt9qBi7j1qV7Qcuc0d1F1XBT5OkoWmiaFhizdWTS9CfjmIh2sh0tGFGW0san1g0pu8qPUvVIJnmx8eSn/TWtCKLFxNtBBcw2Iex/MO+zRtVlDPb6Mezh0TlOHgHYJT+Yx4xdMzI54Dfns/NLeFJxqVMu/zuXtLqoeOFTALjpPNFvtoEaOzVwBn7E20MyOLWzzHqi2rTvgw62+nWyqt9KZUmlKN1AuKu6tOzXZyvcSECTAwuaDrqmpWx7VY52gfy1BPeKr3jGkvH3gLljUJM2EsbgFTFoh0aI2IKfubmMswPaJ5cVKth5yT+XPVs+swWoOVZQ6CkU1xf+atfrELEYy9ZO8orXoMZJHHIIfE86n8c0dXck6NJxHVTkvFFJAYBmtcoNp/M/dwFRkIQiV3PXBDOriz4YeJ+aW+lqDejA4zAw9PG0f6Zx/JhNhywZL/xzPJvKUyUbmSmgKAdjUB/JaGCxglXl7XDMnuz9L0HxerqeNy6n4NyK5/Vv0DT6u7nY0gGXgUIZSyX6FGIkMZKGPB7+BYrpQAn3h/VEgQKoJhdeDllAFDFgHcAVQTWDCmkChdbWSQpEMTINEroLlrP2kAEadM7+Zi4yu9pWo7/+5GwRG2dgWCkT3OTzpg1rDK97ylpNVUyBEckEk8qyTvTbcZMqT+VVHtyVITX5jz3otBbPPwzhiOUS0mCsnHFnWmyLDIRtxf7JB83Bi2uh708yABZ8lXtaK74M4+5M1FRFCFEghOv/kQ2Gb0TP1+hFoQpDG4J2aTl9tyH0MR4hLTPa+RluuDtijX5RFDuSjXbNY546YAds
 M0cawY3d
 HFajWsPODveaAdDmcZBJSTIy8YSX9TKOWcNtzKcHjbBDy/aH14QXPn17oEWMgaD//lLTMiC+QpDqe+gtbim80vNXaeDL8bpOmXqwVcanxJfdE+l0ylkxOKN/sO/KqMiKzOQcH3eX4WbCGq39LvC/u6++zMwxbv7lRGtT3RGH9F8VhsCWma6x7d9nRJPmLZWPvMqCXWP3qd8cHUmz5pdmnMfxcO8WaHOvFF8xFC6dlWDMA3OIRSIqitGHIDzEjV6PXEkyqwd6zkxeBrcj3gjx7kCJY5wng0HCf+Q96r6BDrvthfcOk3WOiMSGuoga9Q/OReqPSbfMtP4eaawHInZr+jdzEF3R8+kzt5p31aHZ0R61NnHtZufcpoSsfMKompNJ8mPJJrgmEYITkwTQmcGycuEfDEpzU+S3xlAWAVqf+KiMsGw3mW8qzI3x6nO5ZgGdyOgHOqqwJRYTEkYT9wIEKjvDzpZDJnGpiqh5lfx5iL6yaU/B+Qgu9WArPZ2NS3T0ftMRwcg/lrzccqzuMd0ctMVbJDL6eZndbhEShquiVHWTgo/oMchMaNPu6HWmID7NQjg6XydT7kKpEIu99BdOUpV2E6eD+o/RR4tAA6OqbqtB4CiDtYHxVz0/9qxWUVx8KWOk2+e4ZVzFtK4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple smoke test for ALLOC_UNMAPPED that tries to exercise
flipping pageblocks between mapped/unmapped state.

Also add some basic tests for some freelist-indexing helpers.

Simplest way to run these on x86:

tools/testing/kunit/kunit.py run --arch=x86_64 "page_alloc.*" \
	--kconfig_add CONFIG_MERMAP=y --kconfig_add CONFIG_PAGE_ALLOC_UNMAPPED=y

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/Kconfig                  |   7 ++
 mm/Makefile                 |   1 +
 mm/internal.h               |   6 ++
 mm/page_alloc.c             |  11 +-
 mm/tests/page_alloc_kunit.c | 243 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 265 insertions(+), 3 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 6a89cbf8e8c6e..bdd3e083520c0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1531,6 +1531,13 @@ config PAGE_ALLOC_UNMAPPED
 	bool
 	depends on !HIGHMEM
 
+config PAGE_ALLOC_KUNIT_TEST
+	tristate "KUnit tests for the page allocator" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Builds KUnit tests for the page allocator.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 3507cb7ed6a9a..12366f8c0f537 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -149,3 +149,4 @@ obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
 obj-$(CONFIG_MERMAP) += mermap.o
 obj-$(CONFIG_MERMAP_KUNIT_TEST) += tests/mermap_kunit.o
+obj-$(CONFIG_PAGE_ALLOC_KUNIT_TEST) += tests/page_alloc_kunit.o
diff --git a/mm/internal.h b/mm/internal.h
index fada318d13541..089c53bf9a336 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1695,4 +1695,10 @@ int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			  unsigned long size, pte_fn_t fn,
 			  void *data, unsigned int flags);
 
+#if IS_ENABLED(CONFIG_KUNIT)
+unsigned int order_to_pindex(freetype_t freetype, int order);
+int pindex_to_order(unsigned int pindex);
+bool pcp_allowed_order(unsigned int order);
+#endif /* IS_ENABLED(CONFIG_KUNIT) */
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ce06ed0d65d8d..ac2f6190117ae 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -56,6 +56,7 @@
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
+#include <kunit/visibility.h>
 #include "internal.h"
 #include "mm_init.h"
 #include "page_alloc.h"
@@ -465,6 +466,7 @@ freetype_t get_pfnblock_freetype(const struct page *page, unsigned long pfn)
 {
 	return __get_pfnblock_freetype(page, pfn, false);
 }
+EXPORT_SYMBOL_IF_KUNIT(get_pfnblock_freetype);
 
 
 /**
@@ -691,7 +693,7 @@ static void bad_page(struct page *page, const char *reason)
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
-static inline unsigned int order_to_pindex(freetype_t freetype, int order)
+VISIBLE_IF_KUNIT inline unsigned int order_to_pindex(freetype_t freetype, int order)
 {
 	int migratetype = free_to_migratetype(freetype);
 
@@ -719,8 +721,9 @@ static inline unsigned int order_to_pindex(freetype_t freetype, int order)
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
+EXPORT_SYMBOL_IF_KUNIT(order_to_pindex);
 
-static inline int pindex_to_order(unsigned int pindex)
+VISIBLE_IF_KUNIT int pindex_to_order(unsigned int pindex)
 {
 	unsigned int unmapped_base = NR_LOWORDER_PCP_LISTS + NR_PCP_THP;
 	int order;
@@ -741,8 +744,9 @@ static inline int pindex_to_order(unsigned int pindex)
 
 	return order;
 }
+EXPORT_SYMBOL_IF_KUNIT(pindex_to_order);
 
-static inline bool pcp_allowed_order(unsigned int order)
+VISIBLE_IF_KUNIT inline bool pcp_allowed_order(unsigned int order)
 {
 	if (order <= PAGE_ALLOC_COSTLY_ORDER)
 		return true;
@@ -752,6 +756,7 @@ static inline bool pcp_allowed_order(unsigned int order)
 #endif
 	return false;
 }
+EXPORT_SYMBOL_IF_KUNIT(pcp_allowed_order);
 
 /*
  * Higher-order pages are called "compound pages".  They are structured thusly:
diff --git a/mm/tests/page_alloc_kunit.c b/mm/tests/page_alloc_kunit.c
new file mode 100644
index 0000000000000..b7f900a93cbcf
--- /dev/null
+++ b/mm/tests/page_alloc_kunit.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/mermap.h>
+#include <linux/mm_types.h>
+#include <linux/mm.h>
+#include <linux/pgtable.h>
+#include <linux/set_memory.h>
+#include <linux/sched/mm.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+#include <kunit/resource.h>
+#include <kunit/test.h>
+
+#include "internal.h"
+#include "page_alloc.h"
+
+struct free_pages_ctx {
+	unsigned int order;
+	struct list_head pages;
+};
+
+static inline void action_many__free_pages(void *context)
+{
+	struct free_pages_ctx *ctx = context;
+	struct page *page, *tmp;
+
+	list_for_each_entry_safe(page, tmp, &ctx->pages, lru)
+		__free_pages(page, ctx->order);
+}
+
+/*
+ * Allocate a bunch of pages with the same order and GFP/alloc_flags,
+ * transparently take care of error handling and cleanup. Does this all via a
+ * single KUnit resource, i.e. has a fixed memory overhead.
+ */
+static inline struct free_pages_ctx *
+do_many_alloc_pages(struct kunit *test, unsigned int alloc_flags,
+		    unsigned int order, unsigned int count)
+{
+	struct free_pages_ctx *ctx = kunit_kzalloc(
+		test, sizeof(struct free_pages_ctx), GFP_KERNEL);
+	gfp_t gfp = GFP_KERNEL | __GFP_THISNODE;
+
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+	INIT_LIST_HEAD(&ctx->pages);
+	ctx->order = order;
+
+	for (int i = 0; i < count; i++) {
+		struct page *page = __alloc_pages(gfp, order, numa_node_id(),
+			NULL, alloc_flags);
+
+		if (!page) {
+			struct page *page, *tmp;
+
+			list_for_each_entry_safe(page, tmp, &ctx->pages, lru)
+				__free_pages(page, order);
+
+			KUNIT_FAIL_AND_ABORT(test,
+				"Failed to alloc order %d page (GFP *%pG) iter %d",
+				order, &gfp, i);
+		}
+		list_add(&page->lru, &ctx->pages);
+	}
+
+	KUNIT_ASSERT_EQ(test,
+		kunit_add_action_or_reset(test, action_many__free_pages, ctx), 0);
+	return ctx;
+}
+
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+
+/* Do some allocations that force the allocator to map/unmap some blocks.  */
+static void test_alloc_map_unmap(struct kunit *test)
+{
+	unsigned long page_majority;
+	struct free_pages_ctx *ctx;
+	struct page *page;
+
+	kunit_attach_mm();
+	mermap_mm_prepare(current->mm);
+
+	/* No cleanup here - assuming kthread "belongs" to this test. */
+	set_cpus_allowed_ptr(current, cpumask_of_node(numa_mem_id()));
+
+	/*
+	 * First allocate more than half of the memory in the node as
+	 * unmapped. Assuming the memory starts out mapped, this should
+	 * exercise the unmap.
+	 */
+	page_majority = (node_present_pages(numa_mem_id()) / 2) + 1;
+	ctx = do_many_alloc_pages(test, ALLOC_UNMAPPED, 0, page_majority);
+
+	/* Check pages are unmapped */
+	list_for_each_entry(page, &ctx->pages, lru) {
+		freetype_t ft = get_pfnblock_freetype(page, page_to_pfn(page));
+
+		/*
+		 * Logically it should be an EXPECT, but that would
+		 * cause heavy log spam on failure so use ASSERT for
+		 * concision.
+		 */
+		KUNIT_ASSERT_FALSE(test, kernel_page_present(page));
+		KUNIT_ASSERT_TRUE(test, freetype_flags(ft) & FREETYPE_UNMAPPED);
+
+		cond_resched();
+	}
+
+	/*
+	 * Now free them again and allocate the same amount without
+	 * ALLOC_UNMAPPED. This will exercise the mapping logic.
+	 */
+	kunit_release_action(test, action_many__free_pages, ctx);
+	ctx = do_many_alloc_pages(test, ALLOC_DEFAULT, 0, page_majority);
+
+	/* Check pages are mapped. */
+	list_for_each_entry(page, &ctx->pages, lru) {
+		KUNIT_ASSERT_TRUE(test, kernel_page_present(page));
+		cond_resched();
+	}
+}
+
+#endif /* CONFIG_PAGE_ALLOC_UNMAPPED */
+
+static void __test_pindex_helpers(struct kunit *test, unsigned long *bitmap,
+				  int mt, unsigned int ftflags, unsigned int order)
+{
+	freetype_t ft = migrate_to_freetype(mt, ftflags);
+	unsigned int pindex;
+	int got_order;
+
+	if (!pcp_allowed_order(order))
+		return;
+
+	if (mt >= MIGRATE_PCPTYPES)
+		return;
+
+	if (freetype_idx(ft) < 0)
+		return;
+
+	pindex = order_to_pindex(ft, order);
+
+	KUNIT_ASSERT_LT_MSG(test, pindex, NR_PCP_LISTS,
+		"invalid pindex %d (order %d mt %d flags %#x)",
+		pindex, order, mt, ftflags);
+	KUNIT_EXPECT_TRUE_MSG(test, test_bit(pindex, bitmap),
+		"pindex %d reused (order %d mt %d flags %#x)",
+		pindex, order, mt, ftflags);
+
+	/*
+	 * For THP, two migratetypes map to the same pindex,
+	 * just manually exclude one of those cases.
+	 */
+	if (!(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		order == HPAGE_PMD_ORDER &&
+		mt == min(MIGRATE_UNMOVABLE, MIGRATE_RECLAIMABLE)))
+		clear_bit(pindex, bitmap);
+
+	got_order = pindex_to_order(pindex);
+	KUNIT_EXPECT_EQ_MSG(test, order, got_order,
+		"roundtrip failed, got %d want %d (pindex %d mt %d flags %#x)",
+		got_order, order, pindex, mt, ftflags);
+}
+
+/* This just checks for basic arithmetic errors. */
+static void test_pindex_helpers(struct kunit *test)
+{
+	DECLARE_BITMAP(bitmap, NR_PCP_LISTS);
+
+	/* Bit means "pindex not yet used". */
+	bitmap_fill(bitmap, NR_PCP_LISTS);
+
+	for (unsigned int order = 0; order < NR_PAGE_ORDERS; order++) {
+		for (int mt = 0; mt < MIGRATE_TYPES; mt++) {
+			__test_pindex_helpers(test, bitmap, mt, 0, order);
+			if (FREETYPE_UNMAPPED)
+				__test_pindex_helpers(test, bitmap, mt,
+						      FREETYPE_UNMAPPED, order);
+		}
+	}
+
+	KUNIT_EXPECT_TRUE_MSG(test, bitmap_empty(bitmap, NR_PCP_LISTS),
+		"unused pindices: %*pbl", NR_PCP_LISTS, bitmap);
+}
+
+static void __test_freetype_idx(struct kunit *test, unsigned int order,
+				int migratetype, unsigned int ftflags,
+				unsigned long *bitmap)
+{
+	freetype_t ft = migrate_to_freetype(migratetype, ftflags);
+	int idx = freetype_idx(ft);
+
+	if (idx == -1)
+		return;
+	KUNIT_ASSERT_GE(test, idx, 0);
+	KUNIT_ASSERT_LT(test, idx, NR_FREETYPE_IDXS);
+
+	KUNIT_EXPECT_LT_MSG(test, idx, NR_PCP_LISTS,
+		"invalid idx %d (order %d mt %d flags %#x)",
+		idx, order, migratetype, ftflags);
+	KUNIT_EXPECT_TRUE(test, freetypes_equal(freetype_from_idx(idx), ft));
+	clear_bit(idx, bitmap);
+}
+
+static void test_freetype_idx(struct kunit *test)
+{
+	unsigned long bitmap[bitmap_size(NR_FREETYPE_IDXS)];
+
+	/* Bit means "pindex not yet used". */
+	bitmap_fill(bitmap, NR_FREETYPE_IDXS);
+
+	for (unsigned int order = 0; order < NR_PAGE_ORDERS; order++) {
+		for (int mt = 0; mt < MIGRATE_TYPES; mt++) {
+			__test_freetype_idx(test, order, mt, 0, bitmap);
+			if (FREETYPE_UNMAPPED)
+				__test_freetype_idx(test, order, mt,
+						    FREETYPE_UNMAPPED, bitmap);
+		}
+	}
+
+	KUNIT_EXPECT_TRUE_MSG(test, bitmap_empty(bitmap, NR_FREETYPE_IDXS),
+		"unused idxs: %*pbl", NR_FREETYPE_IDXS, bitmap);
+}
+
+static struct kunit_case test_cases[] = {
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+	KUNIT_CASE(test_alloc_map_unmap),
+#endif
+	KUNIT_CASE(test_pindex_helpers),
+	KUNIT_CASE(test_freetype_idx),
+	{}
+};
+
+static struct kunit_suite test_suite = {
+	.name = "page_alloc",
+	.test_cases = test_cases,
+};
+
+kunit_test_suite(test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");

-- 
2.54.0


