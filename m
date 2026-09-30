Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9045ACA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504716B0095; Wed, 30 Sep 2026 10:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC196B0096; Wed, 30 Sep 2026 10:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1866B0098; Wed, 30 Sep 2026 10:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 157CB6B0095
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:07:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5B32A07B4
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:07:27 +0000 (UTC)
X-FDA: 85270606134.14.2DC9201
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf12.hostedemail.com (Postfix) with ESMTP id 132554000B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:07:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NpEFsCaF;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/Fb5g8MDUieQ0AsGZlC/m2n+LM+/+hXUoXNvWx5za0=;
	b=IVR7fwAtltKAa6TyzeeQO68FXqf3p400SH1Y+EU50Aq8hY2y6b1c+F+npu/64CpSkuRnOi
	QpJySjIfQg5Yk3rq7pFBd2ipsAV2eedRv4XMMW0obspzFyVvCIxXMNqwWMdyuLENE4mR+I
	Q7OD0VNOTOF6TMzfcDDlygM6ZqU+r7M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NpEFsCaF;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777245;
	b=oGFbS5eXCs/jmxTEcAKgU6x65GQAKKJUXKCqB4pim//7GL0qToYvOJDITFzDdFYQWpVowk
	DJ0foF8nTImnFVNjdqgRMjc3weU6eg2iZadZCiFAjtVWhWqYhVWKWf+Zh5Np71Vg1bPMC3
	4Nd2fOJbnzud5ELpvsYjo8nh3Oyr8xQ=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb1a98dso3068256a91.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777244; x=1791382044; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9/Fb5g8MDUieQ0AsGZlC/m2n+LM+/+hXUoXNvWx5za0=;
        b=NpEFsCaFab5UBIcjcB15EPOt/Sloe92EibCUKFQ7J3hx8ILP2UGGIgArCcsx4I5q6W
         er0MpRvrFdC+3Z9yjj4MZm8w0ML1Y88GZGiIrTzvRYFxGzX7UipNKt/AcC3xpalaPBbk
         tI29r7g8tpKT45Xnvo5bwIzB7q5Gd50Gb0lltmOtDVzTWFkdmlBhfV5T0R2LBI+ALAzq
         yADuLqS5FYp+KeogIJ6vbYJtLkdtG6OUn5Xel7GCWzlFuveNG9eTWbWGX0lMM+QLnadp
         bggOmfur2PH4faqPXp1WSlfwJhzkeHMkbwngffcE4bD2+0rLSylnqQ+V4F6WYE+iw4fn
         5yDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777244; x=1791382044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9/Fb5g8MDUieQ0AsGZlC/m2n+LM+/+hXUoXNvWx5za0=;
        b=27SvjSqVNmJtHlW3NR3lLgvtlG+fXNuHOwhw8BPG7IB6AifLCaIii7A0EoFsfrz+la
         DjAeXZv6b3tR20cYZvWfJ5jROF/5g5a9TW+LTBHZhx3lmU8HbXnD1kUBf31e7U5+o3/o
         lE1LbwsNmDR7n3eeF430N38pksMXTY9LQPueytRhWio4wQ7RvQv62fcdmAlkxMhzHa/Z
         U0EhcI1FaG/JpAfyfbbLC29znnDC8rA7W/tQ03mwqoXpVmcrM0plvkF6fAC1ZSKKFJkm
         bTwdPJ91VSeIBmqZqt0JOSjWF1Zct9BU/LAWhCCnP5Zb1WhkZlRu/I18FXxxUlXk9qfb
         clgA==
X-Gm-Message-State: AFq9FYLd3f3/UOSxC40ZdE6FqlcviyR5UlMjpIzj1d6P33B3Gb8nkZ1G
	ewKb5sl4z+vztFN1lMDZvIWAkusCAG4sGZ2hP5GvPn8N1mScOU7K+5FoVYtoChzmNdE=
X-Gm-Gg: AYBFou3vrSlrtS9UoIRXgTtNzrrGbdYDh57YCOESBn5jPIgMZCRJdRB8EmRQSvjGCtS
	TvRZPu/MAyl/kfaLFRb+/Dswhil42Q3BjcJYQrHdtYdAqfVa1pqoLtoBd9BQPWXFWuPO6ukboPy
	dWQx4J+doLDQcWvWhnQW0GGSobcjTsw/4UlmDnnlaegeUzoc1Ro4HNY2wTVqeBWmKEWlJxjtSXe
	zE5MKLgQnmyDARvK07TZE4efxUDU9bHepNanfqgstw6cKWHiZSdZGZN5X6wGDqtBfUO6kwbQCM7
	CaBdd9hglUa7G+IK8IWKzKkBD0nOMOtWwKB8dygnu/8VoYx6SwzgWEYN88aGKD9lo3PbGiD36ef
	AAr09DA2nlxb/1hP8TUoeYU+6v4OCjopJPZqdwM6sKZFzNBogKN+axbt/45SxIa15I/+fGEnHr7
	uahqBhl+CMkfBzao/Reh/zf7AZ4XiLrpYz+vRhMuzpvVwBgS/3lrK6Bf6C8uhrGFKk4EVgM1E7r
	HpE1DABH9WfMg==
X-Received: by 2002:a17:90b:2687:b0:3a4:a270:23f1 with SMTP id 98e67ed59e1d1-3a4d103d004mr1307962a91.4.1790777243537;
        Wed, 30 Sep 2026 07:07:23 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.07.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:07:22 -0700 (PDT)
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
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 01/12] mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
Date: Wed, 30 Sep 2026 22:06:16 +0800
Message-ID: <20260930140627.57431-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9fc5dq63fd34x6ag9rsyrb8e4ss45wyj
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 132554000B
X-HE-Tag: 1790777244-778164
X-HE-Meta: U2FsdGVkX1/AE8FJuxjTYWCz7lZed27Z3i1ZAina33c0iQzYtalWbUZHgao88q4w1T/qIOcuvCYvZqiPLWAnCc8V12fe8LMpzHp1omZW32rCCiLz5sF77P2Xz9IjpgcasL6lJZSxC8EXZ4saTK3xFq3DNLL6Us0Year5ockGcadRpqQ/Vkp8QAwsaze6MD0nljXXSgN9AxA1LvebfbHdXhxH+DuF/ttNUgBscgHkDJkyuYBTiiIrZVSZFXpxNRiRYFJJ0Z/4B63fiCPi9pIs61togso9qVUho8Gm9cYe0FJ/uwl2zvYq8uggewJM5xXPRylpjMejC0Gj6Xuw/l4Ioy6v0hf4inbK/eOG6z8k2qbjVSnh3+dz4uSMZQIGcSa9WikTUp0LryRL4f0r5bNGrlFrsX1QHwa3vtc2oY3u4l0lqOAA8YdgrRECMLkCR+06FyJa4WSV7oOtQW4cRJ1RyPOQhYeJ8UqGeI7ZS3jOqvN8R4abaqSql7+e08l3U3IHeQ7Dwd0pXxRiAJmDszzBY/TJuXUWYX7hk+5vZWiE7uVeFMK+FraFQB7nX/Mk0rqH/Bmu4W36rXlap0Rjo0o139+uhHMOkZcHSUvV0UXARg//t3gj4J4u49/BnE5CDsZ8whg3VDkV5oml3Qi1sPjj1wou9q68bvp9IN4TAtYxaYkCA+1PGfKTiXQqZridYVyrkJhdbx87kkrXH70p8NC5ohhc3t9mPm+DdotwU5G20YwYAqD86OrB4GP654GEqiaMHPVwAk84XBCHYaCK+EWwHSy43UlGaAT/yI2Ga1CERVGIFw+np4A8h4LzydrEfvIlhfkW+wcDFxUJdPscINe6UMKNfxCLOWCleuWGD9oZNbm6YMqtdBlOTTvzxBIJATcNBnmthWeH3WhKCxrwi5sb2MRl+zN4pJhWblzcr7j6lk1dQ90yv6o7jASxyZbC//XPW68Fy8skG+uXiII0jQb
 Eiu1lodi
 A2x1bXKfY3eqWiGrAVwOt7S+IFN6bQ0/DtaN3i21yLIGt4yu9MuClxl+2fU8siWTNsU20FXRx4WN61a9rIenDEieHFxhQhokcZwZkBCVP/tMwivT02Nab8U53hDYYxHwpmJl9jOaSGeqUbjUILzNhK1kjeR5nZLsH1rZXNOXJcLm3gQobdxIYhPuMr++wLJGCpfr39A28OoqBxWBlCNHQWVqLDY7z6RWliloJLT9SkX3u7UPUnNrFDIYzNGEPk0j7o9bhWXXWLxtfiO9fGQMNqbyxiivX+cd5kwmLtbnw19dNoQG2lyjfo97bIyHJ5UmodMkiLKwqhrqrOrXyK/qeajvnISQGr6yzwg12C0KHJpQNDdk18M73MTy+ANgowzyEOU0mahjjRthlnQVX3e5J0URno5ogjBWXMTnrHwrTlVvMXGd0JINeW4YNhw==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Move the constant declaration to the top of the function (suggested by
  David Hildenbrand)
- Collect Acked-by from David Hildenbrand

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
index f22d815d7af0..9af349581fbd 100644
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
+	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
+	struct page *page;
+	void *addr;
 
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
+	if (page)
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


