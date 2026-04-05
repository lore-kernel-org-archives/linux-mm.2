Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97D0F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA506B00D4; Sun,  5 Apr 2026 08:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1B26B00D6; Sun,  5 Apr 2026 08:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B00E6B00D7; Sun,  5 Apr 2026 08:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B77F6B00D4
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:57:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F30D413BFA4
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:06 +0000 (UTC)
X-FDA: 84624502494.22.4985859
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4A970180006
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VKdQtv2q;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvO4goCvgbIDjzyl1a4aazkWRerXOYwkBjCejKe9WH8=;
	b=N00kl2oRIfiJBEGgMnzZdzP704cj1gAn+8+gt3YlPnvqPidT3v5K4lfJu7IBioeX5AwpN2
	M11FyEgRpf7NXyxB3VBFhgE3QsjU6/uxOMfcyXKu/ymbR4pWUoQVSywHIUCfgTLZcemEFm
	jw7PyAJGw2VFzeE+Fj3fUpk69GjTxeA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393825; a=rsa-sha256;
	cv=none;
	b=qwPq6SW55u4XbG09jYR6VvBdLLCNpFr3+kFaCe4/XT0X0fE1RQNblw0mNORvqYuT5l9+XT
	yhcHDwp1lSNEzAIoTRNEtzIHTOKwDpe8VS/sATj42VWLP8nzg2LrkzzQOIgIiLSz9rsMV0
	if8ldD0oX+GgdYZ5RgTQKBoM07d5Lgg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VKdQtv2q;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-358d80f60ccso1933991a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393824; x=1775998624; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvO4goCvgbIDjzyl1a4aazkWRerXOYwkBjCejKe9WH8=;
        b=VKdQtv2qB0XDO/IT5Orobg/Vatj45o+t+wS3jKvPC9CbtuqPHZEGwDBA6xbHFSeadv
         0v4YbIwo6pzcAsFnzu1hzQOCSBPOP70kjjJljZ4L2t6UTuwb5wo/RHa8lTz+EIebJV54
         5sfJCUc28FbXWMeElLmdjGcz5xhL6n2bbmfgFY0cSe1SLbRRK0TxcHHB0WROxsmwrwR/
         on4Yo/fzEzGG7OowpNOinkbhjGCxlqYAspTn9UiPtwTrzSdE8Ydx4zRYM2G7AhWJZ63z
         ztTKBQfHuose9G5KLPbwUlciZ0xFU49bvNDBM1Dcmz/mKHq6kk65nB9mKewnsdQKZT/V
         3rXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393824; x=1775998624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dvO4goCvgbIDjzyl1a4aazkWRerXOYwkBjCejKe9WH8=;
        b=GUhQTBUkty+1MWU/crRbPu035WboJ9m9dKA5B4gLv6djVL21sIfgkRwQJcyvRXJHOf
         UbiwF0viKl2SSz+Nln1S2Ex6iQVZvT974PBqL3yN2ARd0me6/tja1S7F1E/7f1dRRU4v
         UunN9aTpwao3vvLddYXcVyfWwoZTGgaOxUMN1+7wEJZJDmvQmnmBtTJJcl96pLsNr5ic
         oNNOyBBo/fx4NEpaj6eDgRxpEDydX9bGf0EHUyWQpgoOu+uD5It/2/QPSZKOobbNORxk
         GE5d9FdhipY2QuRKAJ5bZZpkwncYZ0rOyugTvCz3bELWU2R0myvYu5qxpxd6DZecp5pm
         WeuA==
X-Forwarded-Encrypted: i=1; AJvYcCVMf5mn1iCtqfjNJVneoWH0Aj9ALkl3a2jpovt6Q7o6X56XzXjPMUI30C9C6l2NX+l9iIZyBTs2Wg==@kvack.org
X-Gm-Message-State: AOJu0YxB82Qqovwtprx1Mi2BIcNaHzOlVEeN3dFyreRInykwTp4zidb3
	uTX/pqSyi/477yRx3PajZfaWjLFU1vceG94WEM94yAwWNTJ6MFTxg/tf+N0ZuHg0bbs=
X-Gm-Gg: AeBDieu1cDDSxhB9Ui0nH/zGLOiNQ1EP6Ohiu9k+aqIvpcPfGm+NXFlxX7qPnYl13hF
	HfXThcLy/VNvbtPZ4RhxCg41w77h7mrAZLCuZ0URPUdyNZFnk4Qkmlri2XMUydh3si40tDtRyxR
	iNRL9Iua3vnslq2m8F6foSDMo8IOhmPF+okLIHKgl4IICs9++SyByoYpS3W5aBuQkzJWOIgDkHY
	UYHIPexc5WD0F3Jkf/dh1i/UWglo84hp2BlSjRYoqBqduOuByaGGPzDLFZXjkrzXlwCiebwbh1s
	lH7SntocfMU9LZywZVpOzS4IInPqGAiN90rw3bbU48naY/4PEa5JqHo1N8xc36myRXM5O4Mc2e8
	4lJkuit+yCVxTPeOsLrzvHMud8R0ME8e6hHdCW0j7pLqMAWyyqr5vmQitVguHLYQR+TJE8urpPl
	OQtSxNEiMaxmfEOeh+cxxmk/Om4TnA+rO08K68nEw/GDM=
X-Received: by 2002:a17:90a:d2c7:b0:35c:cba:344f with SMTP id 98e67ed59e1d1-35de68414eemr9240766a91.13.1775393824055;
        Sun, 05 Apr 2026 05:57:04 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:57:03 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 34/49] mm/sparse-vmemmap: switch DAX to use generic vmemmap optimization
Date: Sun,  5 Apr 2026 20:52:25 +0800
Message-Id: <20260405125240.2558577-35-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A970180006
X-Stat-Signature: 4zx74eaygkbcgj8zybf4e9rgntja6uy3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775393825-574904
X-HE-Meta: U2FsdGVkX1+LYHzbHsoKgMv7oo7WE5JS/haWOiYh+t7Etv/rDA1sWi3CPTbOkYX+6wbqykEjkwMm6YRlUoaFqNwkGqlBgEHcYme81yqF41rvqkc+jCSs9MatcyHhEeiSjFJKaKcf7jOOmpUlW3bAaw8bt1U9UJcZQIB/aHriCwusP07KlN7hyrMzriWG10LfCjoLQUKSeWC+skS/GQpiOHtOleXEw1hN/+Jh2eO90i4jERwOFu4WMjREhK4TlI1x+2Ury7XlONMv5fzGqylr90bRfb/E7lh7g5aoj+r9q1leqw8xXJ44+CVtCVzhFNd38BV9vC5WvxcszGq/VvqGQYsNc8/tJtnbrnyL7DyZZp/wsLmWX1GS8oGImAu41X8tpAfvhjMFrrOo/lP9xIn+FOp+4t5K5vqoXcOoOzQlk4+/3CbDdXV/EoVGllTXHSaZ5YZ86IbBY6HXYssrWPiXO3FBbvMwK2keMcOovcHMJxfYsFy0/It5NJGQEZMBsiURA+igMuhXyjmxRfKNfiY56HqSoUnROIOwAe+FpEmDBmp3wCDLBUWwEmJkv59zrIYPd4QEWR4UpaBR992nz1eu7pa5cJh/4cu3A8m/f2AAufSoDQ2WwPLuZD+3BPP+zlgHvqiNp+qA0TZOrsZ4OWnJ4QoF406NBKGlZhfqOrBR8AU9cFfWaUjSSs9vXbRTpqVducPiwwif5AjE9soXVJEzP1Me6WV0XR/7rLvhx5Hv9lX6FnA4bL3dtJ53AuxGcIn5Ve2x45MZInj+jAd/8mpEQjjjfjwHKoiWoO8rCtuQGGHp0nlLo4X9dXIuZ9W6VNiJxeabqSXNvNyJpZAZRcb6Bm+2N06Zk2p98F0urv8K8yA+UJ1sMxmcMt6HgMgiD5Gj2LWELolMtn9x7wBJp58oZNcS1HXC02+HcOYUbYd7FXD6BndUvKPoE18cU3qtC2tKJomOzHqqvkbQavlrgMx
 CcZzeT13
 bd1h6Yp1LVSmA4fRrGtujcMKgmXtJNF2dRrVh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recent refactoring introduced common vmemmap optimization logic via
CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION. While HugeTLB already uses it,
DAX requires slightly different handling because it needs to preserve
2 vmemmap pages, instead of the 1 page HugeTLB preserves.

This patch updates DAX vmemmap optimization to manually allocate the
second vmemmap page, and integrates DAX memory setup to correctly set
the compound order and allocate/reuse the shared vmemmap tail page.

Note that manually allocating the vmemmap page is a temporary solution
and will be unified with the logic that HugeTLB relies on in the future.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c |  5 +-
 mm/memory_hotplug.c                      |  5 +-
 mm/mm_init.c                             |  8 ++-
 mm/sparse-vmemmap.c                      | 82 ++++++++++++++----------
 4 files changed, 58 insertions(+), 42 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index dfa2f7dc7e15..ad44883b1030 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1124,9 +1124,10 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	unsigned long pfn = page_to_pfn((struct page *)start);
 
-	if (vmemmap_can_optimize(altmap, pgmap))
-		return vmemmap_populate_compound_pages(page_to_pfn((struct page *)start), start, end, node, pgmap);
+	if (vmemmap_can_optimize(altmap, pgmap) && section_vmemmap_optimizable(__pfn_to_section(pfn)))
+		return vmemmap_populate_compound_pages(pfn, start, end, node, pgmap);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 05f5df12d843..28306196c0fe 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -551,8 +551,9 @@ void remove_pfn_range_from_zone(struct zone *zone,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages =
 			min(end_pfn - pfn, SECTION_ALIGN_UP(pfn + 1) - pfn);
-		page_init_poison(pfn_to_page(pfn),
-				 sizeof(struct page) * cur_nr_pages);
+		if (!section_vmemmap_optimizable(__pfn_to_section(pfn)))
+			page_init_poison(pfn_to_page(pfn),
+					 sizeof(struct page) * cur_nr_pages);
 	}
 
 	/*
diff --git a/mm/mm_init.c b/mm/mm_init.c
index e47d08b63154..636a0f9644f6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1069,9 +1069,10 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
  * of an altmap. See vmemmap_populate_compound_pages().
  */
 static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
-					      struct dev_pagemap *pgmap)
+					      struct dev_pagemap *pgmap,
+					      const struct mem_section *ms)
 {
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	if (!section_vmemmap_optimizable(ms))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1140,7 +1141,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(altmap, pgmap,
+						       __pfn_to_section(pfn)));
 	}
 
 	/*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 309d935fb05e..6f959a999d5b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -353,8 +353,12 @@ struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 	if (!addr)
 		return NULL;
 
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail((struct page *)addr + i, NULL, order, zone);
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
+		page = (struct page *)addr + i;
+		if (zone_is_zone_device(zone))
+			__SetPageReserved(page);
+		init_compound_tail(page, NULL, order, zone);
+	}
 
 	page = virt_to_page(addr);
 	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, page) != NULL) {
@@ -458,23 +462,6 @@ static bool __meminit reuse_compound_section(unsigned long start_pfn,
 	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
 }
 
-static pte_t * __meminit compound_section_tail_page(unsigned long addr)
-{
-	pte_t *pte;
-
-	addr -= PAGE_SIZE;
-
-	/*
-	 * Assuming sections are populated sequentially, the previous section's
-	 * page data can be reused.
-	 */
-	pte = pte_offset_kernel(pmd_off_k(addr), addr);
-	if (!pte)
-		return NULL;
-
-	return pte;
-}
-
 static int __meminit vmemmap_populate_compound_pages(unsigned long start,
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
@@ -483,42 +470,62 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start,
 	pte_t *pte;
 	int rc;
 	unsigned long start_pfn = page_to_pfn((struct page *)start);
+	const struct mem_section *ms = __pfn_to_section(start_pfn);
+	struct page *tail = NULL;
 
-	if (reuse_compound_section(start_pfn, pgmap)) {
-		pte = compound_section_tail_page(start);
-		if (!pte)
-			return -ENOMEM;
+	/* This may occur in sub-section scenarios. */
+	if (!section_vmemmap_optimizable(ms))
+		return vmemmap_populate_range(start, end, node, NULL, -1);
 
-		/*
-		 * Reuse the page that was populated in the prior iteration
-		 * with just tail struct pages.
-		 */
+#ifdef CONFIG_ZONE_DEVICE
+	tail = vmemmap_shared_tail_page(section_order(ms),
+					&NODE_DATA(node)->node_zones[ZONE_DEVICE]);
+#endif
+	if (!tail)
+		return -ENOMEM;
+
+	if (reuse_compound_section(start_pfn, pgmap))
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)));
-	}
+					      page_to_pfn(tail));
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
 		unsigned long next, last = addr + size;
+		void *p;
 
 		/* Populate the head page vmemmap page */
 		pte = vmemmap_populate_address(addr, node, NULL, -1);
 		if (!pte)
 			return -ENOMEM;
 
+		/*
+		 * Allocate manually since vmemmap_populate_address() will assume DAX
+		 * only needs 1 vmemmap page to be reserved, however DAX now needs 2
+		 * vmemmap pages. This is a temporary solution and will be unified
+		 * with HugeTLB in the future.
+		 */
+		p = vmemmap_alloc_block_buf(PAGE_SIZE, node, NULL);
+		if (!p)
+			return -ENOMEM;
+
 		/* Populate the tail pages vmemmap page */
 		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1);
+		pte = vmemmap_populate_address(next, node, NULL, PHYS_PFN(__pa(p)));
+		/*
+		 * get_page() is called above. Since we are not actually
+		 * reusing it, to avoid a memory leak, we call put_page() here.
+		 */
+		put_page(virt_to_page(p));
 		if (!pte)
 			return -ENOMEM;
 
 		/*
-		 * Reuse the previous page for the rest of tail pages
+		 * Reuse the shared vmemmap page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)));
+					    page_to_pfn(tail));
 		if (rc)
 			return -ENOMEM;
 	}
@@ -744,8 +751,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 		free_map_bootmem(memmap);
 	}
 
-	if (empty)
+	if (empty) {
 		ms->section_mem_map = (unsigned long)NULL;
+		section_set_order(ms, 0);
+	}
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
@@ -824,6 +833,9 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (ret < 0)
 		return ret;
 
+	ms = __nr_to_section(section_nr);
+	if (vmemmap_can_optimize(altmap, pgmap) && nr_pages == PAGES_PER_SECTION)
+		section_set_order(ms, pgmap->vmemmap_shift);
 	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
@@ -832,9 +844,9 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	page_init_poison(memmap, sizeof(struct page) * nr_pages);
+	if (!section_vmemmap_optimizable(ms))
+		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
-	ms = __nr_to_section(section_nr);
 	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
-- 
2.20.1


