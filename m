Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A1A1FD3777
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2936B00DB; Wed, 25 Feb 2026 11:35:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01AA66B00DC; Wed, 25 Feb 2026 11:35:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3436B00DD; Wed, 25 Feb 2026 11:35:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B47F26B00DB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:35:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 747C31606BE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:35:05 +0000 (UTC)
X-FDA: 84483528570.27.84878E2
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8C3B31C0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:35:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Z5IKuCoq;
	spf=pass (imf21.hostedemail.com: domain of 3tSSfaQgKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3tSSfaQgKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONJbbWNmB3g9j0UlyPhep4oJzEzZ23P3tEKa2pmUkxk=;
	b=y5ki1ExharlNb+5Ds0IAjyud7SkaHBe7KxPqXVIGwQexbeRlP6hsID7Dya3Fxgd+7XPOFG
	wD/uf76okH7shmjc0aV6oUXTHriICUdOgy0QnzUhRNzBVfs1RrmyWz4xveZJ5Ug9IDctQ+
	e65uId+F5byb6Jtw02kT5RarQifhyKw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Z5IKuCoq;
	spf=pass (imf21.hostedemail.com: domain of 3tSSfaQgKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3tSSfaQgKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037303; a=rsa-sha256;
	cv=none;
	b=sgFqwecwFq07rQwDeppdA/eAMuBuDTy08lB0MCWffDB/dLKhXgsRXCLwq56QpqwKZWHoxP
	4AIDy0oTtxGRpYPdHciqTy3NhnS+iQfRQz2y7vy8ZKk2bl/P7eeWhC8PxNTEH390HI+W6W
	NjyegVNus4cy1Pxi2ZFLntYL259dHFA=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso77219385e9.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037302; x=1772642102; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ONJbbWNmB3g9j0UlyPhep4oJzEzZ23P3tEKa2pmUkxk=;
        b=Z5IKuCoqQu/tB46l9swFe1eMJhGLmNMnSi5CavHHtfKPs539oV07KpvE6rTRxX+sVT
         33MEy0pt8EPWx8tthPuxFWILHbR2ZxvdlQUds9pnM7b7NN72ek235y9goitweiHrwRMY
         RTmqg/hhJ8HP7ms9/gbgBBtwdCipMIB1obnvb6mbKlSkrY1aqwtxVReDQZvfwcEZylcS
         rNJK7fysDMLOIpz3Qt/BbYwCVGN32HSso25Y2QhREml7olSG8SizeiX4pyj9IzCw/4Ph
         eL0NO43kmWrj0gyshhYidHrHRN32kY09FCWcu+64JoNxRt3aHaRMZVFGIzR2M6LjMGxI
         IfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037302; x=1772642102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ONJbbWNmB3g9j0UlyPhep4oJzEzZ23P3tEKa2pmUkxk=;
        b=SQl4MJV0x6zKa5cYsCdJtMK4RKfO//tMrD82otxUt1oq7F6TrMdXLDK7apIH1lF2RY
         oUEO74c9iYgMIPPYpVZEjKiAQqizqFlCS80YEr93nQxgArrvG8DHct6yqX+BCD+Yf3zg
         Jo4MkD8NhzR4a5vVbhgneCzz3vKRIKccob9hfJXbQo3aO6a6VnSwfSosR+JIAQkGPg/J
         mTOwQTmaX3mbvsq3gznPoJ0IHXFo+4gOdTtfkrdXs0qSV1cjZ8uVBmYulog65b6xGK3w
         p7AeD5TaDey3hIMkr1v8vl/miawKDq/8u2y0Vd4W1GO7xqbWjHQqkTe/Fw11N6l+aGaw
         KJmw==
X-Gm-Message-State: AOJu0YzlJiOhfsQyDk1wltB1qTjc5pIGHm15Z+xO1TajKrmkPKCQHLq8
	sJtkpjwds8BYgpO+a6yCUvPz+Upc5tmZQwMZLsYX/5dlQCoRzWhDUT+6Z1XAKF8BfcuYwOOkZYS
	Km8YgyOtF7JEScg==
X-Received: from wmap23.prod.google.com ([2002:a7b:cc97:0:b0:480:6ccb:80fd])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:348b:b0:483:612d:7a5c with SMTP id 5b1f17b1804b1-483c21a117cmr15454305e9.25.1772037301990;
 Wed, 25 Feb 2026 08:35:01 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:44 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-19-e8808a03cd66@google.com>
Subject: [PATCH RFC 19/19] mm: Minimal KUnit tests for some new page_alloc logic
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C3B31C0005
X-Stat-Signature: 953amaacwp9an8nofu9ka5ihp91taokn
X-Rspam-User: 
X-HE-Tag: 1772037303-151654
X-HE-Meta: U2FsdGVkX19rz+vyY17mgCC5dwNlCOBoiWhXYON5+O3ctCP9Nt2OyP+4yS4RPoT22X9SDLOTLPU7dTXwTiwXwzTFJyGuqjIP/QTO5nI5gMQGSVCVZbCfsMaVSnMgqt9TC16Sc4jnMrQFKH4DK6e2WZglFdiO9RbodZpr5GQkt/1KW7HCQNB/BN6eyWOt6W33efn0vJQ45/LxBeKcpPY6YwkPHZhyuuj2NUMpj6hiNMJzgh1cvJsSQN2/iv/2iJ/iAJfPkV+a0CAqG6ch2jjMthtLRIBqpO11a01VOgoJZJfdoVFMN3TcJ07L96Ryle/jlWLs5pnHAC0mbINUxgfjfxyZL45IlESC8KMlhicRxKvWcVEt+5lOb4JnHAQl8Gy4jI0y3nRxHO/cC9ldUtWV3jF7+imCz7Qy8bTy59XnanI29/2GeXShJFYFdDdmfVO0yCVgbOOcXf7DXXHyMBoU49N5vC8ZxaXUl55Jv/InQ8gPdBKQmLBZ3WFn6FtJV+UjvB+jfw+jNt1/QBGDNX2YTgPHUyfx1oMeWMKc5LXGbNCE6v60O7WS/4fW2CuzdXNP7V/smv/E9vDGZ5ZxuvVSsWpz0gsNXojgSFWS9MZVUT5jwOV3rz3KocRyPKSGwrUnHpVRkvQX756J5STMQ3Cfjivb+AqK7Oqu7SKUBF8GcYMsJJnsg0E+vvXlc6yoiGgVIOnhsCSfyPg8w6kJfLAtZWOB3EwsUZ6NTVAM+6YR6UPFPqOtTJjRzUf2Zo07OLKHDZcM3qdiQWyTO3vn3m1Tj8N3dMFEUKtpb/1C0UoxLNqJTieAOaJ0tUn234gvXZ8W1Froh2DCBFPfFt1hjOUNryhKdJk9MzV9xLRgtEamNxT8euFQItomejsO7PjgtKL0ahdX9yBLc5XKJfjtwJeteDzuBM6SAME7QsTPejxjNfUSy2AcTaWlKv7At2otzOiC5L5J8tMqSlLv8U3loCh
 FESLFNrF
 b1CZjefjRtGqwO83lzitgLyk4FxOq/gMQh16SQp5pzVaIvS2aPCJTnpp+zFpriTKyAILk8gA68yCZ1qOnm/fsqknehbHpl5JmeXbH3Wa/Ke2jaRCl3n9cl3i4DoE6sg7TgLZeIeYPrqcUWkP9BI+ebqP80zWtTyHM9I8vw5cbdEc2yC1RAixBfhe/nZWhWJi7Izh2KZeD+mbdXFWJLi4qI6tx6zwJRt4fmRIAMyaGlW7pYc1AlbhvkrSIlgzGfpbQngo27PNnkS01Tbyex4jR214hjQVZA0oywgu5KSJBPIsqvykn0ZEf8nZtdp8KsFddOlEQPsb1dlhzfB1RzTZGckhB6jpqA90MJ3XBF7BJpV8m59Nxeq4ybTii/qmUoYMqhu7oUO61y6toZYQq9wf+nDwfqt7Ms2n3kzYoa2XYfy1HKJuaUTD2MMjx8pR4QvL2vDiKJ/rFtnpFiKOaScbbaD2heVG1zl0aGlKky8LemMt4WvzX5l1YOp7uLVpNBYNZvg4iKV6G41HEd0d2QH5EU655YovqHd3D+TC0KzaSu6zdaNy/Pz9HILb/yGG/J1uvnpgeNxOzLCI6TZ/ZqPAp4cXfhiPBTdpVr3ViKglxlrXb/4xCVf+LThrvB4gi7f7GbV2YMWb2iHsh+7eC9qqpuagoTg9B2ridAS+/u0HrRf377eqRprx95FGyoLV5xxu1mlmk
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
index c78600212b6c1..1a170d907eab1 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -39,6 +39,7 @@
 #include <linux/sys_info.h>
 #include <trace/events/error_report.h>
 #include <asm/sections.h>
+#include <kunit/visibility.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -900,6 +901,7 @@ unsigned long get_taint(void)
 {
 	return tainted_mask;
 }
+EXPORT_SYMBOL_IF_KUNIT(get_taint);
 
 /**
  * add_taint: add a taint flag if not already set.
diff --git a/mm/Kconfig b/mm/Kconfig
index 134c6aab6fc50..27ce037cf82f5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1507,7 +1507,7 @@ config PAGE_ALLOC_UNMAPPED
 	default COMPILE_TEST || KUNIT
 	depends on MERMAP
 
-config PAGE_ALLOC_KUNIT_TESTS
+config PAGE_ALLOC_KUNIT_TEST
 	tristate "KUnit tests for the page allocator" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
diff --git a/mm/Makefile b/mm/Makefile
index 42c8ca32359ae..073a93b83acee 100644
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
index 6f2eacf3d8f2c..e37cb6cb8a9a2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1781,4 +1781,10 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
 	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
 }
 
+#if IS_ENABLED(CONFIG_KUNIT)
+unsigned int order_to_pindex(freetype_t freetype, int order);
+int pindex_to_order(unsigned int pindex);
+bool pcp_allowed_order(unsigned int order);
+#endif /* IS_ENABLED(CONFIG_KUNIT) */
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9b35e91dadeb5..7f930eb454501 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -57,6 +57,7 @@
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
+#include <kunit/visibility.h>
 #include "internal.h"
 #include "shuffle.h"
 #include "page_reporting.h"
@@ -496,6 +497,7 @@ get_pfnblock_freetype(const struct page *page, unsigned long pfn)
 {
 	return __get_pfnblock_freetype(page, pfn, 0);
 }
+EXPORT_SYMBOL_IF_KUNIT(get_pfnblock_freetype);
 
 
 /**
@@ -731,7 +733,7 @@ static void bad_page(struct page *page, const char *reason)
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
-static inline unsigned int order_to_pindex(freetype_t freetype, int order)
+VISIBLE_IF_KUNIT inline unsigned int order_to_pindex(freetype_t freetype, int order)
 {
 	int migratetype = free_to_migratetype(freetype);
 
@@ -759,8 +761,9 @@ static inline unsigned int order_to_pindex(freetype_t freetype, int order)
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
+EXPORT_SYMBOL_IF_KUNIT(order_to_pindex);
 
-static inline int pindex_to_order(unsigned int pindex)
+VISIBLE_IF_KUNIT int pindex_to_order(unsigned int pindex)
 {
 	unsigned int unmapped_base = NR_LOWORDER_PCP_LISTS + NR_PCP_THP;
 	int order;
@@ -783,8 +786,9 @@ static inline int pindex_to_order(unsigned int pindex)
 
 	return order;
 }
+EXPORT_SYMBOL_IF_KUNIT(pindex_to_order);
 
-static inline bool pcp_allowed_order(unsigned int order)
+VISIBLE_IF_KUNIT inline bool pcp_allowed_order(unsigned int order)
 {
 	if (order <= PAGE_ALLOC_COSTLY_ORDER)
 		return true;
@@ -794,6 +798,7 @@ static inline bool pcp_allowed_order(unsigned int order)
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


