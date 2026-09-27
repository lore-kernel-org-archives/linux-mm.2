Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00827C9833F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C141B6B008A; Sat, 26 Sep 2026 22:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B014F6B008C; Sat, 26 Sep 2026 22:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F0636B0092; Sat, 26 Sep 2026 22:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 793746B008A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:54:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DED711206FB
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:54:58 +0000 (UTC)
X-FDA: 85258025076.19.65309CC
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F162C0002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:54:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UBlp+HBX;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4fFb5jWFZ2W8X/tUSizSdLW9y/fwSZ4mGTJ1PbgeB4=;
	b=WCdPvDrxXQKBYH10IuW1DmSe3Z1SVzRrhIhzAQNpPnot14x5qkDeKuaVvzd6lF8dlU4Lk8
	L6TOBWxl9MjoSUBomlnNmkTkouYf6c1wGXi7HTn1/zvQgLDqtMN9Z4PReiCTJOFseLo3tb
	77DEz0IlrT4rHZPPQYcEnHTGI7Vy6FU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UBlp+HBX;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477697;
	b=cgLO3Mf5nT+/bb4wdBr+8eKufozyzInOkMQ6mYs2g8TMSOtjTs3iFuAwDz4uR+abuNwKPD
	K9ouMT60mS+gqDkBdop6LZPtjLUVISTp8MfKETe8lYA2mczvMHtQ7KfV3mP/vb5ljxnG0C
	NcCFPeEK5qXoKbC8QZjdUTe3XEpRDrY=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd66bb4so891981a91.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477695; x=1791082495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P4fFb5jWFZ2W8X/tUSizSdLW9y/fwSZ4mGTJ1PbgeB4=;
        b=UBlp+HBXhiZle6D3uku7TUzig2rh26fwtA+PbGsdPtvF9b/eHq2vakPhxPnBvZ+IJ2
         5FgonDdxHpJaHFqdTMW0FgMPWLGieRDDd8meHUoVG+OLLy+KodnySLrDCFTGNx/wqqa+
         p/rlkoByG4ScqkN3zHN0XQ/1Yvaeta1aXgZFSWQwZhIoOdvMo1xEOtYilCuFYT2bTtlp
         S7hbIpWxPP1Z54Z8Pema29cwTlOZVJqiWhKZtQQunJiDHQahd33yQl2Uhd4TLoC8Yguh
         AecxWvT+XWCnn6iWpWWRJxFWXonEgVsv5mcpFD51QTPJkScZo4bIpOTutCH2Ml5seMoo
         WBPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477695; x=1791082495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P4fFb5jWFZ2W8X/tUSizSdLW9y/fwSZ4mGTJ1PbgeB4=;
        b=EQJNl2s9y2i5kQKp2XBJz8t32Z38YVDnrrKtjpzVDenQIP47LrfyQyqMjBkO+G1/dY
         zkImRqxmsNuZn7eu/nWVIlRQhoCYEwgi09+kdCmSwAaBnZVjxO6kc5YZ96LrWSYZc7KX
         smCEoXIxgCMgxgXfPX9pS47L1BcIn/6WZt69UJ+d8JpzMX9LhHaqW4CTrkRyuaxywXMl
         m2HJmNOXK1XLGTQiZO0sM41R/P1L/hBD/Vl68rV1p7EhcQahnRFrJArGrj5upGXf6MZ2
         +KlalrI5XJO8QY/leGXNgMsD4IKznTaYBISCyeJCpzl1zAXOvsO/hfXRWQY8oJTCP1lH
         SPyA==
X-Gm-Message-State: AFq9FYLfLK0tz+aWMCq+utlbNr66gl3CPd+9uJIsz69oM7phAtv1QMIP
	68brx3uFt5BnKSINxu4bxhCwuk4VuTqn55Hn/51tvXeno9SdHW4DMdXYsrIWZew0eYQ=
X-Gm-Gg: AYBFou2xZbeaDxmCiJWUQOZxkr0WmXTUZyphF9u1CfESE0pjTabgyVc4zdYcjAm5azA
	LiHg6Abm2WeVZEIF0DBl4ggsWOj56S50A4O0rXj7N6UblnJTcwB5KsMC/48gHuhaAzRr1FYxmeE
	nZRv66buSSpLEFm6GzlPU1ynnKqk8XM9MiTdd1XY7cT7QRX7SAQ/kwLTmjk8/TnSH/tD/CHKhn+
	CxUfxdaEAtgPbn0z756npzcJKrpMD9U0Auiqv8rVjN5If2xZiatzWqQjmOKiy+hur+j9PFLPNBU
	qvWNq2D/L6iqmQ5/ioFEN4Ri+lwsOeQoheYaw/rNH3/AWlwcl6gBXeSKOwwxIwNTtEybatQ/CcV
	SVKLQKERrqSpdufKB+3uMMmbXQA+pnj11Cb4EF4eHIzhu4wlsa6NOIqfE4sTPkt1rgfOfrI54Pl
	x67sLHBA1+3Vw/X0PN9QAFV+bp58UUmqqeXsMvAfJ96IX2sLpvc8VGOUslTKtTu3kTq0yfSrp24
	sMLYSFfKXVgzS+G7wP2
X-Received: by 2002:a17:90b:28c3:b0:3a0:d18f:4be4 with SMTP id 98e67ed59e1d1-3a0d18f8399mr3416950a91.33.1790477695213;
        Sat, 26 Sep 2026 19:54:55 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:54:54 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 01/12] mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
Date: Sun, 27 Sep 2026 10:54:30 +0800
Message-ID: <20260927025441.741633-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F162C0002
X-Stat-Signature: iwwbipmznudxfaefxyh659p4izy36cqn
X-Rspam-User: 
X-HE-Tag: 1790477696-959879
X-HE-Meta: U2FsdGVkX1+3ZUuDklW+icxAnSr8TMQCy1jd/RZIQ5nUHDhoYUoHs9XSJSRLw5hqoSHiKIgkfR3dv/6/H5QdbK0iaGEOreqZ4LX7VUU1PeNLQhWaL2vvMll6mMgw5A47Izttk+1HYEmgQKUlUc6uNxtqatTG1/SVBBixpbWIkGgqNCQv9ck7MuC56iTRz/T3qGgqrDqR0ujgNgfqKeDg5yxJO5vsdSf8qhte+PioTNXXQ5nUuVeNaYCJ6LWdPV4RSPFXYiYI6wbQbo5EzqtKYtr8BO7RbFQcZXzhUl2XhPDmhifKywKVd5s5nxG6LYybikLDlYCDHVbWxh64foIFb7i/S3jPDIC/10p+RegmTAMS6jq0o/AUOpV1Fmw2YPdaEkiyFvrHrfwLoH2EYIQqZ+oBCD5QLKhUFqj5QE4dxBQ04TzKt2ySNPGfqbgeRtLQ7Pr0yL7aQLWXtMzg/po26ZsHryeqT6GdGG5uFCm0QaJmanhaCluhmuKX9lzR1edzQ7LBl2QoiHPsrSFZRSQeGzraI/nCxM9jY2TSbONcDtzwb0Ange4Y7dE2UTZ0TYCg248A/yHMUvFcYqkQ2tSjo3akWERJtNaNtYvITELoNhQgtkox96IUjAzJm5uor3EZshSGwRnUOATfzS0LbUueOL7RQSpkMLrf9PZswhTW1Je0Ny/J8waIP56AzNCk5H0+JWc5RbrNvRZ8s3qIinYY1Fyhc9iasDRNn1Mx+0VRmABy14eIpfy0Vch3DAeySUvU++2q5UqA/pvqwE/GtPLTvVqLLF+UOgMGKq9MbPKaIyqtLOc9EDh2fGmOUjsOe+JLwSZ+PTRTNl/4HYvPBk4/1O1qoJKlvZ7PmU6UAo2pPqXuJ4Uc1dXo8CYGYVrb6QGLL3Y+e3KaDX17QQSoNuMJlYggejfPliZWGplXgWFiUIZkYreIEv/0I9b8uZy8i41glNQERlfAu8rc9rIexjG
 8MhHLb2J
 sFXIvFd7QxHr5b56jvjJlQF5beBPUM2qqCgGa2DP3w/BYGUkxwhoYkuC1fSE0nrYuai77lov4PCpo9g/wPn+nLCblYYGZ1rYFyIJvnTwe0LY4UWSKss+5JjXSucmvVwkAMOcaICLMRURB5IjclNOPn2skdjhypHhTssG6ozfdEpPG4jlGAOioXVkgeP554EtCLfZMOtX/GwCWG2ihArG4DZhMk7YmDIDAQQV2ouS6fwP4aaK6/mvAKC9o8mVVsp+PGO6RpOio9ewU7NGvyzKjRVROD0VjpRF6hnEzQsK4n9txh3LkuI/9OdCKgbvPX525SCvCiupIWaBkOME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB and sparse-vmemmap each have their own helper to allocate the
shared vmemmap tail page used by vmemmap optimization.

Factor that logic into a common vmemmap_shared_tail_page() helper. It
allocates the page through vmemmap_alloc_block(), initializes the tail
struct pages, and uses cmpxchg() to install the per-zone shared page.

This removes duplicate allocation logic while handling both early boot
and runtime allocation through the same helper.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v5:
- Move this patch before CONFIG_VMEMMAP_OPTIMIZATION is introduced

v4:
- Update the commit message for the renamed VMEMMAP_OPTIMIZATION config
- Collect Acked-by from Mike Rapoport

v2:
- Collect Acked-by from Qi Zheng
---
 mm/hugetlb_vmemmap.c | 29 +-----------------
 mm/sparse-vmemmap.c  | 70 ++++++++++++++++++++------------------------
 mm/sparse.h          |  3 ++
 3 files changed, 36 insertions(+), 66 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index f977d0a7e002..76765c97ff68 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -19,7 +19,6 @@
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 #include "sparse.h"
-#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -493,32 +492,6 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return true;
 }
 
-static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	struct page *tail, *p;
-	int node = zone_to_nid(zone);
-
-	tail = READ_ONCE(zone->vmemmap_tails[idx]);
-	if (likely(tail))
-		return tail;
-
-	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
-	if (!tail)
-		return NULL;
-
-	p = page_to_virt(tail);
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
-
-	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, tail)) {
-		__free_page(tail);
-		tail = READ_ONCE(zone->vmemmap_tails[idx]);
-	}
-
-	return tail;
-}
-
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct folio *folio,
 					    struct list_head *vmemmap_pages,
@@ -535,7 +508,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_get_tail(h->order, folio_zone(folio));
+	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index f22d815d7af0..9b00085122b2 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -42,27 +42,13 @@
 #include "mm_init.h"
 #include "sparse.h"
 
-/*
- * Allocate a block of memory to be used to back the virtual memory map
- * or to back the page tables that are used to create the mapping.
- * Uses the main allocators if they are available, else bootmem.
- */
-
-static void * __ref __earlyonly_bootmem_alloc(int node,
-				unsigned long size,
-				unsigned long align,
-				unsigned long goal)
-{
-	return memmap_alloc(size, align, goal, node, false);
-}
-
-void * __meminit vmemmap_alloc_block(unsigned long size, int node)
+void __ref *vmemmap_alloc_block(unsigned long size, int node)
 {
 	/* If the main allocator is up use that, fallback to bootmem. */
 	if (slab_is_available()) {
 		gfp_t gfp_mask = GFP_KERNEL|__GFP_RETRY_MAYFAIL|__GFP_NOWARN;
 		int order = get_order(size);
-		static bool warned __meminitdata;
+		static bool warned;
 		struct page *page;
 
 		page = alloc_pages_node(node, gfp_mask, order);
@@ -76,8 +62,7 @@ void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 		}
 		return NULL;
 	} else
-		return __earlyonly_bootmem_alloc(node, size, size,
-				__pa(MAX_DMA_ADDRESS));
+		return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node, false);
 }
 
 static void * __meminit altmap_alloc_block_buf(unsigned long size,
@@ -185,34 +170,43 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 }
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
-	struct page *p, *tail;
-	unsigned int idx;
-	int node = zone_to_nid(zone);
+	void *addr;
+	struct page *page;
+	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 
-	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
-		return NULL;
-	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+	if (WARN_ON_ONCE(idx >= VMEMMAP_OPTIMIZATION_NR_ORDERS))
 		return NULL;
 
-	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	tail = zone->vmemmap_tails[idx];
-	if (tail)
-		return tail;
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-	if (!p)
+	page = READ_ONCE(zone->vmemmap_tails[idx]);
+	if (likely(page))
+		return page;
+
+	addr = vmemmap_alloc_block(PAGE_SIZE, zone_to_nid(zone));
+	if (!addr)
 		return NULL;
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
 
-	tail = virt_to_page(p);
-	zone->vmemmap_tails[idx] = tail;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
+		page = (struct page *)addr + i;
+		mm_zero_struct_page(page);
+		init_compound_tail(page, NULL, order, zone);
+	}
 
-	return tail;
+	page = virt_to_page(addr);
+	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, page) != NULL) {
+		if (slab_is_available())
+			__free_page(page);
+		else
+			memblock_free(addr, PAGE_SIZE);
+		page = READ_ONCE(zone->vmemmap_tails[idx]);
+	}
+
+	return page;
 }
 #else
-static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+static inline struct page *vmemmap_shared_tail_page(unsigned int order,
+						    struct zone *zone)
 {
 	return NULL;
 }
@@ -229,7 +223,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
-	page = vmemmap_get_tail(order, zone);
+	page = vmemmap_shared_tail_page(order, zone);
 	if (!page)
 		return NULL;
 
diff --git a/mm/sparse.h b/mm/sparse.h
index d3a71ef4fad0..6e7aaeaa5594 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -142,6 +142,9 @@ static inline void sparse_sections_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
+#endif
 void sparse_init_subsection_map(void);
 int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-- 
2.54.0


