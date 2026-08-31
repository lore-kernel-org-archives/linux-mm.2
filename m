Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D830FC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A876B008C; Mon, 31 Aug 2026 03:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1826B0092; Mon, 31 Aug 2026 03:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0156B0095; Mon, 31 Aug 2026 03:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE8E6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:54:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5FF880324
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:40 +0000 (UTC)
X-FDA: 85160802720.08.EB2002F
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65AE7180003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XVj0RMWf;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162879;
	b=5r7dJQ4RLrMOVrAqL9jXn5GtIo+xfsGCs8D8TZb5Bijmlnb5bCBUnbZ14X7QEORaIsJRFB
	bMtZJoe4v/JNX7q2XpLi/s7az0w81npATJ6DWPziMgxbJxqUfbD6wVaoMwR2fDW7D/KeA9
	Q0+0hmdRC6VymnlrDfQ5G/7GSditnSs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4jDvtv3kIRHCHEO8kcmf2tbgWKyzjUPm6N9KUwqqy5o=;
	b=7u2vE1euelYvH+/rNk7C4TEg/rhMzxNXR5DlEDSLpo3QgYFwLAIexaXO3beM2jQ6D8AqN8
	MTXU2+eFd2aP5hYScsFZCZ1fZMWPk91cfe1KrwDNTtKeI7l/r72BGaZvo3KFfJ/aviS/dd
	yTXlTL3bTHfP+tNCRILfs2kdBXHLj64=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XVj0RMWf;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc1cb472b76so2777468a12.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162877; x=1788767677; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4jDvtv3kIRHCHEO8kcmf2tbgWKyzjUPm6N9KUwqqy5o=;
        b=XVj0RMWfIpjJP3Vd7PFeE60PgO+YpCysNnQZ+/2qyeZohkcbLRZMsPxxDurbGDhEGs
         06t1hHBAYRhtt6q5s4y67LhyjySfp35W/Tqr6hDJtrgkehbwcuUuMaCbO5Ao4xvh1UiD
         uiQ4LtIOjMfVklgaOm6mA8UQvsy4d/6vHJzivA/uHrQP7LvZ+usL50viB+QOc/NSkMfr
         B5zn940e2WuMJ58rQ7c2sqC1n+cklv5os7dGziWllkBPK7b/PKhtMnnP5rnoSpUMbkKs
         MJ8nF7483z23vq6LPrPaiKrAtzlhPD7mZRhuYblDuFY5A7mMb9OYhfUl+YwJMALDECjx
         UJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162877; x=1788767677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4jDvtv3kIRHCHEO8kcmf2tbgWKyzjUPm6N9KUwqqy5o=;
        b=Q6nIA5kD8KbRj/HZkbA5KarvfxFua/cHHzvC4GSI44NBGPi0d6Sbn7GFbRqPmAlbvX
         r1DtrdyG0hs9xOMbD0fSgiKHUkj5+r/KU0DrvmBKRs0hQJN9KcZusM9YQFyZjDOkIxlV
         xNkkwpP4sGH3v2UHJ8Mr2okZGR92E9OsaivWXVjFTolnm6XAUjau3yuqgUwvoyXBi/VL
         VOjWdSxtcxnya9LWTFp4TfSKrlgkq6jYA1bb28OBm5XD02pCa0G1EhiwXF8ztCT0wQ6K
         2ZAVc7bh4Hlqo6jWHCb0QrvVdkl62TcSXR2AymBzfhBQjBPIBAfNlQaKIKtExc0VdgYj
         3OOA==
X-Gm-Message-State: AFuF++mobBrusmM3qG8aCL27uDapESoOF8YLIfFcu2AL9tOJc3VJUnJA
	K9nD4dv7pPHi+ZtPEohuP2obebla072n/O0OtTRVODdXR0wV1GpSUt/KVfNPCJ+LNm8=
X-Gm-Gg: AR+sD10Zwv0kAetqcR3ms5vx1oC8MFOcBq8sk2WQEuyagEW4ss8IgpA7YZ5P0jTIzov
	jSGEx1kyRhw+MB9yPTrwdR9jo0KEw/Tj+N4DHgnMTO49kLBgy2Z4tBe6/4HPTDdZvO8fE9pYUN7
	3BJfKM5rMRbstla0cie+5S/4PLqZlhYS3gGgxTcmapnNZWVqEqMp92HjQZ5APsbQNw/oTuLhIaQ
	O4KuHiI8aPiiw3DTV+O3zAAGxRvmZ+EIb9v2sW8KNjd593bOEWQCCpbEGePp4MDz7dIAFB4Z/w5
	1SV+yl3FMrEqQTuspoQscuFcksQNxwCtBh1nmoX4iWtRUGsGHP1l6RqSV1YmJWUoE8oPu8AJueg
	hRN2rx0KdAXUQPoT1fPFT8JrUHhKHjNqyTI/uAVGnCv1XjkgWKz7WxqOrILsYrV0VUms45qXkGK
	jlVqISV90SwQKqsKbYFVGKyAdmvW0n0eYKbBkqZZNQ4BNphL8eaAdrun3lAHR9Gze0GRY72DvBd
	Esfscxvg5k+IKJ9Sb2zVgqP
X-Received: by 2002:a05:6a20:6a15:b0:3c4:4272:b400 with SMTP id adf61e73a8af0-3d2688bd9c8mr37731922637.18.1788162876874;
        Mon, 31 Aug 2026 00:54:36 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.54.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:54:36 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 02/11] mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
Date: Mon, 31 Aug 2026 15:53:33 +0800
Message-ID: <20260831075342.57563-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 65AE7180003
X-Stat-Signature: yw8u1g9u7yndufm9pd3uwzg8qjmifsgr
X-HE-Tag: 1788162878-196871
X-HE-Meta: U2FsdGVkX1+X7SntGTVb2WEDSSpYkyYOfbA6NdTRzKGniDdSFNQN3bL15ZYgUc/7ZmecPii2GSu/OdMbc/6v+ul9wrE3HK53SpsSDwCzZMAN/ovwfEASeiuknAH+SV2pMS1V+S6qIs4D98Y4ArhB5nb0+vXuCto7hM5WwlDWL+4FJO+BPms7kwmvbpExlXy/7Ef+HLJG3vmXgHa4VwOGaO3Uy3jKix3YacqghBNG91Up0Ne0o5y5+MBwJQykkj7HTnyIO6hoPSGQpr+4S2PwGAt9HWNrIa0Q8vpyPgg/8WFfCFpQ4iZDRiiCoETXr/Jd+nJjZ8OGFHrptZgxiE3AxaPQVlLWqT+P2OIQSQa2LzIUMMCbrHAHNmjr9CrG5nGuzHhbf20t/mVZGw8juYIG1EsPrVoAi8zZ6oynUybKLrGlh6wuTFrDmvQwqGaTwY4Noc0sg19IRK4PapAXIK27jJkERHl6P9TwmlRPRA1S9kQML6mq8MrULSF9/z/rCR35O4wGnZ9OeUKo8ulJWuVEaQE6zh6dncnKCJA/h22j11/xOBzKSop/xss5FsR8geZvM65WwPAI3KVQcVz4RWYMx+dx/UIF/zAeKMRSzcJM7OPs8djAiafWDlGX0cnc/H/QCmfypmsHSBk2AdJgahVTXRqbDKHmt1C/Wb3BznAnsxvNwVGi2PazHEmjPYkuZ9oeU4Zwr3xtrfSjv5pqBhImsFIAl1LxSbX2ESO2aSYCv1U9nx/yOEVueIvCp0yk4B1d2NXWUBp/T1Wnq9UXg3Z8QuJ37ZN9oS5HjcS2GfmFkB/art4AZOs3ioCk1QvIExzzv41d71FriAsoOR9WDBFuvWhnV+Ex/j4pCchCiTi7qCSxA3BgB88ObQULaPZUWVPV+Eac3kTB4X46uJ7rMcfvsDVMQv5hSRLV8fHf4vsCkyPlXNKLmIGYssuW7TuSoTyI55rx9vGLR/yvFti9Zyu
 Vx9XEZJ4
 +ugkGGFHzOvan1dmushPaHEAoGb6ThOscR3oXLvguNrldIqJvvSnlxxdcYmpxBwIw9+tdMAvHVkDvUvwIzXhOJiAfaUjup83GvDyRGZ22usYW+tGimj4z69L+Ja2Lofn7hSa7/RT3U9YC289Zy2nR8CYQre0W95g3ua9avBmnLmmPHr9xRLZ9e1P0uh8ILcnvawZvRoDeeOxPGBFSbKNjcyAuQUdYk19oNgANogfpcYYriJMYOI1G5csmOJz5hSCi0KNHdbbwzgD88ADQlSDy3mGJ78X2O1i+x1zxDLiF0wqUCvkAF5GRZuh98Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB and sparse-vmemmap each have their own helper to allocate the
shared vmemmap tail page used by vmemmap optimization.

Factor that logic into a common vmemmap_shared_tail_page() helper. It
allocates the page through vmemmap_alloc_block(), and uses cmpxchg()
to install the per-zone shared page.

Expose zone->vmemmap_tails under CONFIG_SPARSEMEM_VMEMMAP to match the
shared helper's build condition. This avoids a
!CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION stub; when optimization is
disabled, the array has no entries and the compiler folds away the unused
paths, so no storage or runtime overhead is added.

This removes duplicate allocation logic while still handling both the
early boot and runtime paths through the same helper.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h |  2 +-
 mm/hugetlb_vmemmap.c   | 28 +---------------
 mm/sparse-vmemmap.c    | 74 +++++++++++++++++-------------------------
 mm/sparse.h            |  1 +
 4 files changed, 33 insertions(+), 72 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e9b54ea0eff0..d3778ba976a5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1156,7 +1156,7 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index eb339c4a71f4..4a57e6c3352c 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -493,32 +493,6 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
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
@@ -535,7 +509,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_get_tail(h->order, folio_zone(folio));
+	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e62e6aa07f12..70143dd8b579 100644
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
@@ -184,39 +169,40 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 	return p;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
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
+	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(zone->vmemmap_tails)))
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
-}
-#else
-static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	return NULL;
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
-#endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 					 struct vmem_altmap *altmap)
@@ -229,7 +215,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
-	page = vmemmap_get_tail(order, zone);
+	page = vmemmap_shared_tail_page(order, zone);
 	if (!page)
 		return NULL;
 
diff --git a/mm/sparse.h b/mm/sparse.h
index b408d15baf7b..59b825df83b9 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -139,6 +139,7 @@ static inline void sparse_sections_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 void sparse_init_subsection_map(void);
 int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-- 
2.54.0


