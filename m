Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD4B1099B34
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3936B010D; Fri, 20 Mar 2026 14:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4BA6B010F; Fri, 20 Mar 2026 14:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6BE6B0110; Fri, 20 Mar 2026 14:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45BA16B010D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1539DC1281
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:14 +0000 (UTC)
X-FDA: 84567266028.06.B8BF944
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 42B7D120012
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bI48o80Z;
	spf=pass (imf29.hostedemail.com: domain of 3ypC9aQgKCDccTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ypC9aQgKCDccTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLbn0EHSGtWY5aefUcemJOfT2K5sa2B4hdTOFu3TqVI=;
	b=8laL457Kz/t+7IbUdFa2c/Bi5MYHZYZiFA3CCUVxPalo7PYiGNW1F/SUqJ6gj6W1U/neko
	vd8+yTS8/fRzbZzIxCnQm9zKvYOJRCqyx0lDzScaZQDecuVNI40AZrVNC7R8WvyIjvBdGm
	ktW89H8FkBRUsUY65TVTG43XWJtqvOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031052; a=rsa-sha256;
	cv=none;
	b=5n2ZkVw+VGJUxS7tjRxxiZZ9HRhz4yPW0Pd2Qd40rnM1OGYsRDnR2MlnwESTLMeQV3QqkC
	kJvc10Sa/RPIsO+d4ODxyLFORKsDm9wiBw5cau+Y88Gy0GdEeLnvODuol5TEIZ+/ReNJRb
	+0Fx2DJrgkdZsz/+topJ162kOrBjhcM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bI48o80Z;
	spf=pass (imf29.hostedemail.com: domain of 3ypC9aQgKCDccTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ypC9aQgKCDccTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fe3b9441so8245475e9.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031051; x=1774635851; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kLbn0EHSGtWY5aefUcemJOfT2K5sa2B4hdTOFu3TqVI=;
        b=bI48o80ZoZYO6OTb72c9T6KclhQsMSHfg+J1dicctAEgdKwIMrSuAJ25+7KlXGww6E
         Yq1oW2pTRyXa4GheFF2fD0n9v5Fc/EqGj0FEooCqux5B5SVvHKG3sgp9XeTwEMxneaCk
         Pz/ifHCRC+gXj4cJITHUIOc792zKgEwfFMxtMFXWqCObhGTxY4kybMz7I51Epjbnxdh8
         8pEMAj6lWZQZUOQQi2WdMbVhykyXIoPpOMMZIbPynzg+wsjCw70eDV79sQgGJfeArSF/
         QwjR71j0dvDuW6EgNbSUohL/GvR5YWXbm8G9rRmKxkZKI6H2kNVbLkcDsqP/48mimLOG
         2qiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031051; x=1774635851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kLbn0EHSGtWY5aefUcemJOfT2K5sa2B4hdTOFu3TqVI=;
        b=sIhk2KjXVPDxthW9FkiI9EysIgKHIf+jdpYbFHcgTMPE/DpTW3WJbBukw1n+PginTA
         NWdqQj5KNzfTpPrMgwzPLKjjOyWOH2iG4yHBpuqpnhdXYfO7qR2GuialK1SXxWEAvFsb
         PPpxvxIgR/jhvQ5CxritSFb4W2ja9nC9smlIjydhoEawrPCi7yqxU90yrQjKMpmV2dBk
         a2xTTF1kKE+8O2/0tEctUL+IQsvsI+ztgqiElyQM2R9gRuvT4ECclZapfhwBDOyPkH7S
         IRXvRWWPBVEqBzcUBddHj+BrovKY/BilvGueRMP5B5IVGbH+Gjms0qn9I9htMDWScHMw
         V3Zg==
X-Gm-Message-State: AOJu0Yw/V/PG0YbxmVvIwkqyx4UMgzto7cl7Weyr2t5kAtX3n50RJQBV
	28qbP3MCZVFHHkzEhOf8uAExg+8Scx3Y5O/gAJRPFCiiubLxoxFzt4ig8qa1gSk3kBvkkstMv81
	IgLEvY9d6rnnC1w==
X-Received: from wmbhi3.prod.google.com ([2002:a05:600c:5343:b0:47f:941a:613d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8710:b0:485:49c5:8eb7 with SMTP id 5b1f17b1804b1-486fee049b8mr57421845e9.22.1774031050575;
 Fri, 20 Mar 2026 11:24:10 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:45 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-21-28bf1bd54f41@google.com>
Subject: [PATCH v2 21/22] mm: Minimal KUnit tests for some new page_alloc logic
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
X-Stat-Signature: n6a9qc93ijjoggk8fc1b89668xywasia
X-Rspam-User: 
X-Rspamd-Queue-Id: 42B7D120012
X-Rspamd-Server: rspam12
X-HE-Tag: 1774031052-878637
X-HE-Meta: U2FsdGVkX18Fvu5Gu5C9vEwizSOTzB4qFRciRP8xRyneUQa5cBcMn6M6nsBOPR8BMJXvpvTB1A972IeV4FJrTsHkLvKsXEfoDOomSxaBLeTR0t3MTAT9PMq+IA8TOKg8GjmHgI34TiUSpcACN4XS7zS9ZRuu5ACte3A43QHjG/WooEcN7QH6cwWIgjFu8wAIj8ZSWk5SF9J9Gj4C5r1MWxp3+eaSOD185tjhnzRDvCCf2YL3I0kI2HgkIl2e3Hwhk+2uG4misOlYid2ofFfwR3We804srP1mBLHB2GD1Dghm+axGHRlk34w8Defj8G1YC9pm6vU3NK547HN6ruvDefcfrs7yRsSOz8Xftw1TNIvLWW9yYcfP9gXWQzkj985MajgAPzuFxn4CzDBUdY0zKodqlYnWfamYPSaa8FSu2jk0HPb0aEVr+fUFQVOv8XiHpoJw91yNfxAMqWE8La2lfDzem14/EBlU1cy0iZRUkvq1kYzKR4iBO7Bt5SKB33yYARPTG3ysQp9NcPXuJJi3ebs8kvG2fURODpJ/1OqteF7VdGVaqRbpztEORsiPVGf1tcIc+mvxD+H8gCZa9DUItmmohJhimwfwr76IbAwWL+ao/EJkPfPlBSAr3GUGST4kfVj/NMqTmvKK3BWl6Uo1K7DC4I0N8qkh53lPr4h+qycgO4pk69xdJEcgcJyNvpfNpmraBe0mbquFzkyFOV+sUoYPq3AH1zV9anyOePhjtMrSEMO2fO0X17xGijnn09jvDlB+DR/fg7euu/9RpMsOP9TpA7LiIU6yR51lsn38b4BRarUx2olB4xPVXX/wRiY+rwitlnoDMLhsl6IGxFgO+Rv/p5GAZpQIRcMm6sDc3YQVNHX6BbXX8V9mvDcjBjke0mcyNVIMrGjrAJyHSRgYYzLyGuAW5FSdQHRmGLRC/MtZn8OJ3NDdEn3K9JDQaRd/YJzErZ+8JCE9grzImWv
 X+1T6m2h
 O6jDFg3VgSpm9FJlB9FJvcTsWhs8sXSHfjFPpOCRRxRSCXSHnUe28wy+Em1+jywHd08PfLeneQ8WPPn75AKdFYbUGk+e5Ag/XIXS7A8MUsdgU8s4SUM/+MdS94pEJP859/K3DUGwVPPHL3T5MMGaPMxN/lLTEK+8fYmiTyjrS7uMxQB7pleH4HdzG7UdayH7ujeKNWT6AunGdb3K4hex5uNcWHp241eugkAAm4RX+x/nzikjuYDJjRiM69dm0HvhP+b8EZDQ6uXcXWLD83i/FUgTka+MoSZtmFiG0L4ZWv93jSCt6rfjJsg4nmXnefnwEFILT6vffDD/l6Z1uWLMmIaBhK41oxe0N8sY9CTNO4KHyuT0B4ES9q0uvTddR8KgNFLhKKvKQuVqkuRtFjyrsozPPuDJsNotieEyn7ppVWothWa3SvU/9mxNN90HC7YASR3Xu3VlORr+39PFdlFWI+70y+KYuFkaMzFsoZhJdzJxLGFQTN75DGSQuA1GrJGrRBnaDyZ5Bv5s1cduqNgUFIxW7wpAnXTSlTy1OJLDJcoE/mYhtp1A4pB7yXxHC48YX04Tu8fNsatRrQzji17z+PmtX9BYO2Vkl7zbKcWT1ry0Pdzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple smoke test for __GFP_UNMAPPED that tries to exercise
flipping pageblocks between mapped/unmapped state.

Also add some basic tests for some freelist-indexing helpers.

Simplest way to run these on x86:

tools/testing/kunit/kunit.py run --arch=x86_64 "page_alloc.*" \
	--kconfig_add CONFIG_MERMAP=y --kconfig_add CONFIG_PAGE_ALLOC_UNMAPPED=y

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 kernel/panic.c              |   2 +
 mm/Kconfig                  |   2 +-
 mm/Makefile                 |   1 +
 mm/init-mm.c                |   3 +
 mm/internal.h               |   6 ++
 mm/page_alloc.c             |  11 +-
 mm/tests/page_alloc_kunit.c | 250 ++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 271 insertions(+), 4 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 20feada5319d4..1301444a0447a 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -39,6 +39,7 @@
 #include <linux/sys_info.h>
 #include <trace/events/error_report.h>
 #include <asm/sections.h>
+#include <kunit/visibility.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -941,6 +942,7 @@ unsigned long get_taint(void)
 {
 	return tainted_mask;
 }
+EXPORT_SYMBOL_IF_KUNIT(get_taint);
 
 /**
  * add_taint: add a taint flag if not already set.
diff --git a/mm/Kconfig b/mm/Kconfig
index 05b2bb841d0e0..2021f52a0c422 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1509,7 +1509,7 @@ config PAGE_ALLOC_UNMAPPED
 	bool "Support allocating pages that aren't in the direct map"
 	depends on MERMAP
 
-config PAGE_ALLOC_KUNIT_TESTS
+config PAGE_ALLOC_KUNIT_TEST
 	tristate "KUnit tests for the page allocator" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
diff --git a/mm/Makefile b/mm/Makefile
index 93a1756303cf9..11849162b6f5a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -152,3 +152,4 @@ obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_MERMAP) += mermap.o
 obj-$(CONFIG_MERMAP_KUNIT_TEST) += tests/mermap_kunit.o
+obj-$(CONFIG_PAGE_ALLOC_KUNIT_TEST) += tests/page_alloc_kunit.o
diff --git a/mm/init-mm.c b/mm/init-mm.c
index c5556bb9d5f01..31103356da654 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -13,6 +13,8 @@
 #include <linux/iommu.h>
 #include <asm/mmu.h>
 
+#include <kunit/visibility.h>
+
 #ifndef INIT_MM_CONTEXT
 #define INIT_MM_CONTEXT(name)
 #endif
@@ -50,6 +52,7 @@ struct mm_struct init_mm = {
 	.flexible_array	= MM_STRUCT_FLEXIBLE_ARRAY_INIT,
 	INIT_MM_CONTEXT(init_mm)
 };
+EXPORT_SYMBOL_IF_KUNIT(init_mm);
 
 void setup_initial_init_mm(void *start_code, void *end_code,
 			   void *end_data, void *brk)
diff --git a/mm/internal.h b/mm/internal.h
index 865991aca06ea..6c652148bc906 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1908,4 +1908,10 @@ int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
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
index 7c91dcbe32576..291ba32f1f1ad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -58,6 +58,7 @@
 #include <linux/pgalloc_tag.h>
 #include <linux/mmzone_lock.h>
 #include <asm/div64.h>
+#include <kunit/visibility.h>
 #include "internal.h"
 #include "shuffle.h"
 #include "page_reporting.h"
@@ -461,6 +462,7 @@ get_pfnblock_freetype(const struct page *page, unsigned long pfn)
 {
 	return __get_pfnblock_freetype(page, pfn, 0);
 }
+EXPORT_SYMBOL_IF_KUNIT(get_pfnblock_freetype);
 
 
 /**
@@ -696,7 +698,7 @@ static void bad_page(struct page *page, const char *reason)
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
-static inline unsigned int order_to_pindex(freetype_t freetype, int order)
+VISIBLE_IF_KUNIT inline unsigned int order_to_pindex(freetype_t freetype, int order)
 {
 	int migratetype = free_to_migratetype(freetype);
 
@@ -724,8 +726,9 @@ static inline unsigned int order_to_pindex(freetype_t freetype, int order)
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
+EXPORT_SYMBOL_IF_KUNIT(order_to_pindex);
 
-static inline int pindex_to_order(unsigned int pindex)
+VISIBLE_IF_KUNIT int pindex_to_order(unsigned int pindex)
 {
 	unsigned int unmapped_base = NR_LOWORDER_PCP_LISTS + NR_PCP_THP;
 	int order;
@@ -748,8 +751,9 @@ static inline int pindex_to_order(unsigned int pindex)
 
 	return order;
 }
+EXPORT_SYMBOL_IF_KUNIT(pindex_to_order);
 
-static inline bool pcp_allowed_order(unsigned int order)
+VISIBLE_IF_KUNIT inline bool pcp_allowed_order(unsigned int order)
 {
 	if (order <= PAGE_ALLOC_COSTLY_ORDER)
 		return true;
@@ -759,6 +763,7 @@ static inline bool pcp_allowed_order(unsigned int order)
 #endif
 	return false;
 }
+EXPORT_SYMBOL_IF_KUNIT(pcp_allowed_order);
 
 /*
  * Higher-order pages are called "compound pages".  They are structured thusly:
diff --git a/mm/tests/page_alloc_kunit.c b/mm/tests/page_alloc_kunit.c
new file mode 100644
index 0000000000000..bd55d0bc35ac9
--- /dev/null
+++ b/mm/tests/page_alloc_kunit.c
@@ -0,0 +1,250 @@
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
+ * Allocate a bunch of pages with the same order and GFP flags, transparently
+ * take care of error handling and cleanup. Does this all via a single KUnit
+ * resource, i.e. has a fixed memory overhead.
+ */
+static inline struct free_pages_ctx *
+do_many_alloc_pages(struct kunit *test, gfp_t gfp,
+		    unsigned int order, unsigned int count)
+{
+	struct free_pages_ctx *ctx = kunit_kzalloc(
+		test, sizeof(struct free_pages_ctx), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+	INIT_LIST_HEAD(&ctx->pages);
+	ctx->order = order;
+
+	for (int i = 0; i < count; i++) {
+		struct page *page = alloc_pages(gfp, order);
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
+static const gfp_t gfp_params_array[] = {
+	0,
+	__GFP_ZERO,
+};
+
+static void gfp_param_get_desc(const gfp_t *gfp, char *desc)
+{
+	snprintf(desc, KUNIT_PARAM_DESC_SIZE, "%pGg", gfp);
+}
+
+KUNIT_ARRAY_PARAM(gfp, gfp_params_array, gfp_param_get_desc);
+
+/* Do some allocations that force the allocator to map/unmap some blocks.  */
+static void test_alloc_map_unmap(struct kunit *test)
+{
+	unsigned long page_majority;
+	struct free_pages_ctx *ctx;
+	const gfp_t *gfp_extra = test->param_value;
+	gfp_t gfp = GFP_KERNEL | __GFP_THISNODE | __GFP_UNMAPPED | *gfp_extra;
+	struct page *page;
+
+	kunit_attach_mm();
+	mermap_mm_prepare(current->mm);
+
+	/* No cleanup here - assuming kthread "belongs" to this test. */
+	set_cpus_allowed_ptr(current, cpumask_of_node(numa_node_id()));
+
+	/*
+	 * First allocate more than half of the memory in the node as
+	 * unmapped. Assuming the memory starts out mapped, this should
+	 * exercise the unmap.
+	 */
+	page_majority = (node_present_pages(numa_node_id()) / 2) + 1;
+	ctx = do_many_alloc_pages(test, gfp, 0, page_majority);
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
+	}
+
+	/*
+	 * Now free them again and allocate the same amount without
+	 * __GFP_UNMAPPED. This will exercise the mapping logic.
+	 */
+	kunit_release_action(test, action_many__free_pages, ctx);
+	gfp &= ~__GFP_UNMAPPED;
+	ctx = do_many_alloc_pages(test, gfp, 0, page_majority);
+
+	/* Check pages are mapped. */
+	list_for_each_entry(page, &ctx->pages, lru)
+		KUNIT_ASSERT_TRUE(test, kernel_page_present(page));
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
+	unsigned long bitmap[bitmap_size(NR_PCP_LISTS)];
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
+		"unused idxs: %*pbl", NR_PCP_LISTS, bitmap);
+}
+
+static struct kunit_case test_cases[] = {
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+	KUNIT_CASE_PARAM(test_alloc_map_unmap, gfp_gen_params),
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
2.51.2


