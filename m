Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C83AC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AF6E6B0098; Wed, 16 Sep 2026 02:44:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339816B0099; Wed, 16 Sep 2026 02:44:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201746B009B; Wed, 16 Sep 2026 02:44:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E57B06B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:44:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DC101A061D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:03 +0000 (UTC)
X-FDA: 85218685566.08.60DED9B
Received: from mail-pj2-f25.google.com (mail-pj2-f25.google.com [74.125.227.153])
	by imf07.hostedemail.com (Postfix) with ESMTP id 914E940002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XxX7zLrI;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.153 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541041;
	b=wOwsc0SACDBYgN/XcYBE61qfjNpj3i4Mqw/6OZsxLQc8uwoyDopDISVm7I462/k8N3qMm6
	TleBIPIfxvMjogw6dxxRVdyfGNbeiz+v88RiBZPF/5wy2lJ6hRrX4eVX/kjHgfHX9anDvJ
	7hk8wkceiNeCft/uzLb6WXIMJ/gp+ro=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XxX7zLrI;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.153 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBBuOi4IklhpEQjilPGFjs1/1RKNgj5LsNpTgitcyy0=;
	b=wrJo8wxltEzAvTuE/l2wSv6nyktRy5pycyqubA3PYHijo1bS4HTTW9n4Entmw6rkU6EWl7
	Z3v7abYRYBHeJoG1Oqjd2rGuxo8tIHG5+flv+Um4H7JLjwBSDfNQfQ5HQiIedSKpM9rk7B
	Ur0wi5hXsi4Xxxeeum/YttIx7T1+u8U=
Received: by mail-pj2-f25.google.com with SMTP id d9443c01a7336-2dd4b43b20bso3749465ad.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541040; x=1790145840; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uBBuOi4IklhpEQjilPGFjs1/1RKNgj5LsNpTgitcyy0=;
        b=XxX7zLrIrRJ+OsFsDQ3WwpmXZU7Ywf4YsyziIHfQ56Kwikq69l1r5LBt6GJihfPJ32
         f3UdNfXJ3ZctY8IpLomBmIdkVDYD+WXICgbD8FMlZJlKv5qabI04om18PyWcX/dktta9
         xi4xV0EUYB9m7FBjQYswIz9AyGZm/PbwNRHCtnWLk+qUa3VZtpgcpNCsdPdAVXzwDrCT
         68pGzuqXD0ooqRFtRnqP3Ep/FyiyKqDrw3fAKPipG8DRwVYKhloC9a2eKKSAr7T/FLBm
         MUAptaxLda94OfrDTpoCx51uRu/FDZGl6CCmh2yTaSoMehOkrVGV9mFeO8d38m6u2Zo3
         O8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541040; x=1790145840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uBBuOi4IklhpEQjilPGFjs1/1RKNgj5LsNpTgitcyy0=;
        b=J5fehSB4FSiOBMYpsAO0s1S2ocJG+eCjneVq3i96OzRH4MuxX0Ka08/24Rk7LOXU7W
         qFsAwJWtWSOX+ScnjlLo23zTMTDPUUtL7inU9Li+uZbksNuf9rZe4e/C/mb7JNYgI334
         z9xdtV0LBfjzDKATqNBIH6HpfMMbTLUQ8uLqSKG56MW5yAlTQUA7bTQMjNIW6jr0wFek
         VZNsqErQ3uRO0jD7qPZ11mvR+GJYV4kaJ6kNwTDWGCEijDKyTq/ZjUJ8l3bVvIeo/QQ7
         rnUjcj2/tJAoY3gd4eRiSu3cHAL/IKoNeIRULq4SYsJspfQGLgHxDDrtKpFhltSGJ9i9
         co1g==
X-Gm-Message-State: AFuF++n4qT9EUABYZwGMuBQjv7mPsG06aiec5C5HSntnT2zM6lI/HUfv
	ym/WcQXQrL93Ii4Hn6GbXM36eCUN4j1WOeSv9AdGRgw7TsVI5LBfbJpJeV5UhBBhu1E=
X-Gm-Gg: AYBFou0xlrfc1Ap5b/M3PJKfT7L6vnCKLn9xTHWaJ2EF20tNc3/uN83+YtVlm/E7Mek
	sh8MAslYqOAule2G6s4b5r1mGyuDOT3XwDGEd2xOyCQsX1z8CQ+jW/K1iq7EscFLgdxKHzEmJ47
	2oCml2cYXkraXBcMmU4Zpkqn8wYE+UJe/Z9N3LN7x9pmchCvgaP/q4OIKtAwcOhlsk4tZOZ+yOd
	MjCjoFTYoWQFTL585n1XcamihBeEIZr9h7YcPrMZe3QKn86hbnj8bl2VLEJgGBIoD+kj3th48HA
	w2Jm57S0D5Owp0pp/FteaCV8j1CBhv1beOF/NE3TE7Wbo2eBB5dRuITkjEv2Qht1C1xeH/lh8nM
	n9CCF7FRUuCrjfxfuPWdTNlT1lz9X1AkPuFgpMix/nhFSdwAQTB0i8pPsPV79LsEq1hzTNTomBt
	pdQCQ8wCzMNvuBjz8GSDt3WSNScu26c56ZNGPorp81uzvVOCnqtzXELFhXW4BDrwyS0i+sr03ci
	yO0+xuXnthByE2li7qz
X-Received: by 2002:a17:902:ffcb:b0:2bf:27b2:4b80 with SMTP id d9443c01a7336-2dd8e40607cmr31031175ad.14.1789541040200;
        Tue, 15 Sep 2026 23:44:00 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:43:59 -0700 (PDT)
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
Subject: [PATCH v4 02/11] mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
Date: Wed, 16 Sep 2026 14:43:32 +0800
Message-ID: <20260916064341.1825793-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 914E940002
X-Stat-Signature: qjrpakmaqwpmab8d356gh9ijdb5h6qsb
X-HE-Tag: 1789541041-773886
X-HE-Meta: U2FsdGVkX19vAdYjjzUkloF/XIUaHGCPgss2DBi/XA5roBN4EbB0gDMDuqU3/WezXXaQR/evPW8ZJbTg9dJ228SCLGVVSkpFUOj+33sWXiD9hsBl4LHkizAaDhK/lN+wOU+lpgHC3TJ6xZNM5DcsMlaIJANzU5Sm08aaQEyLuRX2dFbmevPddNtJiw6P6mY5SY1LDiQolGs/ld1+v7EfboTXRFmjlbtZP0qdKYPFJEMTk722KJyrT3UvQ2PFMc0rOHnXHwyw80lFfYBYeZ37nuXSWFtpIeP4MwOgwqSsvtJssjODEPVtrJb9q1OlzZ1PlYitJ08Sx3azQnXX66KgQqvfCRyCC8qS2vIvAz70b6ShWNmYJzMQ+IlZaNVsprChKiiF1c1Hq6HMwQqgXvwV0VPBIEDeX9hmtAuRtXXB6vQMfqkQkC4X8S/TavYAMPPixG+DyDl66fJsS+beqehZmfJYo7ZMK991roFvd3xSpnKVpHLr5zr7XPF6tiAi60OPBS52Qw6eT9sURoEIUYa4PKEevauKXy0u9q4FKP8h9SvK55+vmfQyRgEIgB8T2wdF3XY8zx0MYWLfJuWyzuitNre7/7KVRmDe82QYaj0LwoD9KPggOdI1xNYb+rjWgTI8p82B+aY8/eRpwb4GJEMiZq7VQZLt/S5bhonVzNtulMKB0CG3vTFY4l9vlmwqBHhkH4gp6ldNVS28Y006+Cs3I7C/6QWmg9NxSa5pbdAnria1d0tvO6Ww3yqbUHu6niqCv3ys7rrW5n3shL9+VQs0ZaigLWbgjlGQDal0fodNNmvxo/LSgSD9AU7jZGHvrucmbiXG78IpV+VA+CzYc3/6x+aufFldvXuBMmDHeuTBYZqgXstdwgosgF+nzzr/DEHppQdb2Y34JffmulVNu/73RT5NavdcGDPr8PZUzh7GPh0LA/3ghHngvR0hfIReetMgmH8LyNrddmiXzJ+5gNo
 MCjR0tMq
 EhaNDPsbQ72sPnqwlY/vH3FmxFdYYBx1FEOywH+jUaMRNlcb19Y9KLAdwuwpy7W8Cy9LItBYjSPSfiWN9hinIjpJILrcvyd5G4gaHyazxMB4yi3tHn5V1K5qf5ZzP7aQgKDhE4bpwPsU97AeZHrbtZEtpb23sMiINi5lgbl+9NqhVqZ3ci/Y+Y2ta6cF0Ll0/vXhZw8RBVq+t+7ZYJIead4zu2MDZNLO96ZQZd8OiL3kcSFeupFv3p5Fh8LwMmEANRb69WvIBgFmALYCjMlo+mb03LbOyPjKJ/dfz+rOD7VSWkvC0hADxcheTf3bLYXIlD2MP2OdtoBZAMHbBexmcBQBXyA==
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
!CONFIG_VMEMMAP_OPTIMIZATION stub; when optimization is disabled, the
array has no entries and the compiler folds away the unused paths, so no
storage or runtime overhead is added.

This removes duplicate allocation logic while still handling both the
early boot and runtime paths through the same helper.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v4:
- Update the commit message for the renamed VMEMMAP_OPTIMIZATION config
- Collect Acked-by from Mike Rapoport

v2:
- Collect Acked-by from Qi Zheng
---
 include/linux/mmzone.h |  2 +-
 mm/hugetlb_vmemmap.c   | 28 +---------------
 mm/sparse-vmemmap.c    | 74 +++++++++++++++++-------------------------
 mm/sparse.h            |  1 +
 4 files changed, 33 insertions(+), 72 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 56403841e887..97147c764658 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1156,7 +1156,7 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_VMEMMAP_OPTIMIZATION
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index f977d0a7e002..5ddf06b83c96 100644
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
index f22d815d7af0..7388a5b5cce3 100644
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
index d8c08a388e4e..8f6ef0b50b4f 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -142,6 +142,7 @@ static inline void sparse_sections_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 void sparse_init_subsection_map(void);
 int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-- 
2.54.0


