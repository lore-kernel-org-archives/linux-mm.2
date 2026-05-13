Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E6ECD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0047E6B00D9; Wed, 13 May 2026 09:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7516B00DA; Wed, 13 May 2026 09:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D636B00DB; Wed, 13 May 2026 09:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D07F06B00D9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92CDB16010A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:59 +0000 (UTC)
X-FDA: 84762431838.22.E82FFC2
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id B447B40017
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="e/Gh+bCE";
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dToyrDGV72K3gHJcuzQsCSmu29LS3Njm8M96u525pzE=;
	b=TTgub3cYQ8ljBaOUlKfOjKvVbSkzwvgVzGKzITvWaOppgyDIJRpwFGpEnPvHLRqxC7POhx
	M4zBImm6BMna70bs5rvMjrdTG7gwcAkNNN0ggn/V9vWEWvZ7g95kmXuvqVWI4rj2kjl6Rv
	x+p/0XUfzp6eMWHBaOD0RWUWvDLY8sk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="e/Gh+bCE";
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677857; a=rsa-sha256;
	cv=none;
	b=XGzAxeqT7+hLQTXu534gobwAZzvCsGYIJ0aQxEXjR2Uok7Q3NfCm6IhyQ634S0Xx56Sbr8
	27L6lXT0LN65lgllwAg9X0xZnt0EFLuag0HokFk9660abUlEKqn79/HcdD00Wwt7MMdTDV
	V6wDjRKwlCBTtG66zyeosizJY/PxPW8=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b7d3ecc10dso65526415ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677857; x=1779282657; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dToyrDGV72K3gHJcuzQsCSmu29LS3Njm8M96u525pzE=;
        b=e/Gh+bCEOUHC9D9Zx2os6zYLYQZD1U7lJtsA7boMyhb1m4w28INLWL20qWOs388xTu
         J/VvmFrB0KbCYnNNwcyr5q2JV+ZufBG2OdzaDjP7MkiuzpeNhjQUpV7bnI4y1IYHqLPu
         LGBu4mHWGSY1lAwUrTp88vsSAVzB4XL4ivpXHWUbNw7M3WrR44in3Bojfnl1+aKa8UoT
         aa7iKJfGcvU9g+ybqyrIJ2UmuYubozoTaRVoYyRRc5EzT62fUYGVG2oi1U+qZlvdjtZX
         t+jQp86iFGikjnne153kCsg3ZevpUDEIxDlOOlXOkSIuEZ+GKsIoAnMYhKm3kaJ+Fkjq
         3T1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677857; x=1779282657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dToyrDGV72K3gHJcuzQsCSmu29LS3Njm8M96u525pzE=;
        b=Ds0NCxcOqlYsJW840DH8xc57vV02T6L04aKzsj3NU7XEoWbXcHDO8nZSxrpBd+7cCY
         NMXzYmJrE997TWmxU1KH9vo6UMkar76Engz721LhVo804+dSWQHqy+TPXZxirvg7WZkc
         KUm4x+uHI6OF5pYtfuS3d3gJ69uzU8lrwYGYMiiSxmw9e75DjTSL2VAqFfJSSFnxGZGg
         FI4lIzQta8yiE+R1Z32R0fYHKAVyCT57SD/s6ugBmXEf485jL+zBtKn9HxO3z4JcDxNS
         O/kntU0Mzv7GhUy+LOkr8TnmHkhNgE9iMjnaBy4xFXdl8CFnkc6xFA9EdGQNjOcrsSM2
         5umw==
X-Forwarded-Encrypted: i=1; AFNElJ97h66bXqJdX9CHEkKJQHIxodf3n016NFMhGmOWwRkI+Y//Pr/9eobmtkIYlgt4IkJHM5cXDSnCOA==@kvack.org
X-Gm-Message-State: AOJu0YwbuPk8PR97wg8i9x8sbVvF/hFFq+1X/7yS9sPHd3nGPKz8yAuK
	WGFEQ46ej11ahgUIvoAJXKzW9HkE10pOq0gCvJtGQgnal0wN0mNwOX/OouP84k/mPOw=
X-Gm-Gg: Acq92OHcYVQqScQkzfbI0dh4BMQJFbBd/1n26y7JVrIoF75A5yRIw8HAmJJ+ZHycuE5
	26kSSMbBGBBWJ6gqG5o+W+dYesicL6QWXA1/IEosKwlNn2D/gd2GwekOMx3MrjbdRj8SuswRKzk
	mrZgdq4D/o5kEqjCwKi0ZRARhwE9owmWUgaLCLTuSrKT6Wz9p20EItt34VK19EErirATzzKjQeB
	cEiodSxY7eG4YKpmOMEV938TAFU9VXugdzhSJ5r85+5/I7q8QM1a3gB6oE2Bx0+T+GB810E62Zl
	shq7oUPzelP8o/ckn6T6ABz8n2eSP+jn6S2XxkK1JdDEihrVDXNqybiS1E7mblEMwk7/3Kzeyir
	q3S5p3O0+2s5F3rzvGTlRk/qfECJ2MBzDoWBjJ7Qo8DpaZ7SNIKvE9Wglw8d0G8IalsGoe5a9qa
	JtZ382MGKw7/u9oWGEz6Uj5X573a1SvhyZykBDooAIJB91Mka1J8pgoH6bhfY=
X-Received: by 2002:a17:903:1b28:b0:2bc:d026:eeff with SMTP id d9443c01a7336-2bd27188006mr39565445ad.8.1778677856477;
        Wed, 13 May 2026 06:10:56 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:56 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 37/69] mm/sparse-vmemmap: Factor out shared vmemmap page allocation
Date: Wed, 13 May 2026 21:05:05 +0800
Message-ID: <20260513130542.35604-38-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jwnxutjbfngtunx1hyy5shrfnw5hubmi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B447B40017
X-Rspam-User: 
X-HE-Tag: 1778677857-25531
X-HE-Meta: U2FsdGVkX182k80MtQq8ZwYan8+Xok5zREiM0iybWH+RiKD8zQxbB85BYZqfZFyv3YeHa8ApiAKDSEGh+lkICxkhqZFQaACV42SY01MiToKx3GnxvqgZ87Zt55SxjUy2hYa/NYn51RpF+8Qfu0Ew0Jl//nm36/IKwcH5gh8ORPpTN0ktgqsDpfYtFkIGoFtSgcQ4AAXV6mXwylBuBKEJ8sdEZjwSmXtYvnDlDDMNBEk27MjHeRn5FmVFiqXG4kv+LTD/V1LBG1keozF+E+K4Lg9HyP/5djrRrz2gCa5MhuRsglS+fhDCzDmFH18ugB9pUYdO5lecNueWl34pARwvw/l5BSry0tpcLbatZIQ/SacX/uFd7Bf8I8t8gpciQ/txU2nnwmappFyKI9RPo+eYkBEQEmt0erw3ljkv2742Q2tvYIRDCpk3eo/yFnL5KmEsv3b1JaKmOajwEqvNszLy5KbSeRVfJVSVkT0w2fbBuec0dNgGv+vFR5vWEw+qYKmz5pKH9dHLCwpire6eTr/GZ5YhFCxF+s3sq5Ukf1ow8iaDzEWpFg73sDWz3LO5qGgfCqh4uAAkDIvjPk/tJfg4Ipv33NLk3mr4OqnT7RK1EnSh6ivigLuR9V9gGQ/GLUTr1WpJomJg528dKY0ZHydcA6ymTqF2YHR5MxEDSYKn1DevHMPTsOhK498zHA/VpbcYi+C+HtyzWu+h8Lv3DeoYWcaCmn5E7VbsdszHndNubVNhcz32c4Pp84SPrIJmMJxdsYGyP3GSgEf2F+H3Bc5IP0EHWtmnQjVjKOH2CkM96dK5qMZlM64d+w4TML6dx9d2QMiqc8xReGgEiJwrrDW5bB9vqFTwTA1PtFYIHaSVPUGmBSxqQW89JUqmwFZsneyxJ3EWKg1Uo0lLEVGicn8OhOpPENnoU5WT/85mTQZdAYgVcFzxgjEgNbg6yYCbET5L2H42/CqYsmUClbesKGk
 WeSzW9tc
 jazgptomX7fSM8K0QKJ5j3WaE54FIMNpHmI8MyAaymyLJiwhww8fzdZpdfIicCvL7mf3Yjo8fGzNu50LUkVQmL5gsnauOxWwSEErezORTPO8dLjVn8CE1NFz5/GbjzYSMr3hfIQZKeGCMuyc/7u8D/85IogY5MpuyrI8mAR03OwIQgTWumNkhbs9rK+02+ZpPtoaO4hWkiUc2Nn+ky9+tnZRXzUkKkKMyajCLi6jXpNJuJ7ULsTUSfPIR2nUv6RDCwE5RO8KAhsxpGjQpgF29KAU+wO0U2yitZY+bVeZs6hN+UCp/ZJwNenQckQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB and sparse-vmemmap each have their own helper to allocate the
shared tail page used by vmemmap optimization.

Factor that logic into a common vmemmap_shared_tail_page() helper in
sparse-vmemmap.c.  It allocates the page through
vmemmap_alloc_block_zero(), initializes the tail struct pages, and uses
cmpxchg() to install the per-zone shared page.

This removes duplicate allocation logic while still handling both the
early boot and runtime paths through the same helper.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h   |  1 +
 mm/hugetlb_vmemmap.c | 28 +-----------------
 mm/sparse-vmemmap.c  | 67 ++++++++++++++++++--------------------------
 3 files changed, 29 insertions(+), 67 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fef39be8acd2..5281f073230c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4866,6 +4866,7 @@ int vmemmap_populate(unsigned long start, unsigned long end, int node,
 void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
 			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 #ifdef CONFIG_MEMORY_HOTPLUG
 void vmemmap_free(unsigned long start, unsigned long end,
 		struct vmem_altmap *altmap);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 66362e553870..d24143dd6051 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -499,32 +499,6 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return vmemmap_should_optimize(h);
 }
 
-static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	const unsigned int idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
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
@@ -541,7 +515,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_get_tail(h->order, folio_zone(folio));
+	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index dde4486195ad..53a341fcde74 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -34,27 +34,13 @@
 
 #include "internal.h"
 
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
@@ -68,8 +54,7 @@ void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 		}
 		return NULL;
 	} else
-		return __earlyonly_bootmem_alloc(node, size, size,
-				__pa(MAX_DMA_ADDRESS));
+		return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node, false);
 }
 
 static void * __meminit altmap_alloc_block_buf(unsigned long size,
@@ -138,8 +123,6 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone);
-
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
 					      unsigned long ptpfn)
@@ -158,7 +141,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 
 			if (WARN_ON_ONCE(!zone))
 				return NULL;
-			page = vmemmap_get_tail(section_order(ms), zone);
+			page = vmemmap_shared_tail_page(section_order(ms), zone);
 			if (!page)
 				return NULL;
 			ptpfn = page_to_pfn(page);
@@ -190,7 +173,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 	return pte;
 }
 
-static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+static void *vmemmap_alloc_block_zero(unsigned long size, int node)
 {
 	void *p = vmemmap_alloc_block(size, node);
 
@@ -329,32 +312,36 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 	}
 }
 
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
-	struct page *p, *tail;
-	unsigned int idx;
-	int node = zone_to_nid(zone);
+	void *addr;
+	struct page *page;
+	const unsigned int idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
 
-	if (WARN_ON_ONCE(order < OPTIMIZABLE_FOLIO_MIN_ORDER))
-		return NULL;
-	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(zone->vmemmap_tails)))
 		return NULL;
 
-	idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
-	tail = zone->vmemmap_tails[idx];
-	if (tail)
-		return tail;
+	page = READ_ONCE(zone->vmemmap_tails[idx]);
+	if (likely(page))
+		return page;
 
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-	if (!p)
+	addr = vmemmap_alloc_block_zero(PAGE_SIZE, zone_to_nid(zone));
+	if (!addr)
 		return NULL;
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
 
-	tail = virt_to_page(p);
-	zone->vmemmap_tails[idx] = tail;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail((struct page *)addr + i, NULL, order, zone);
+
+	page = virt_to_page(addr);
+	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, page) != NULL) {
+		if (slab_is_available())
+			__free_page(page);
+		else
+			memblock_free(page_to_virt(page), PAGE_SIZE);
+		page = READ_ONCE(zone->vmemmap_tails[idx]);
+	}
 
-	return tail;
+	return page;
 }
 
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
-- 
2.54.0


