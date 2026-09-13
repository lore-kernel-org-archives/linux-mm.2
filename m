Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CB7C88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 08:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9BF6B0093; Sun, 13 Sep 2026 04:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2D86B0095; Sun, 13 Sep 2026 04:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BEB6B0096; Sun, 13 Sep 2026 04:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B86B6B0093
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:40:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09F53C05CD
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:40:48 +0000 (UTC)
X-FDA: 85208093376.10.BF19CDA
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id EFB7220002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:40:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Sh4XGoZp;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789288846;
	b=h47LUC/LOhYuBB9bSIRjsQIcIgt7G0Kl2IPtfg5ZaqO3CH9skoCWre0fshre6YKOGn1n6G
	4OYfEkhz/qjDuWrxTqJV3myuKBZPC4s7uhgE1uVY7V1baqUhngkkTlTiXw0s8P4rSh87jR
	CZisSJSXSuWPtZh1I8XYO9Sf3EmEjRA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Sh4XGoZp;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789288846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ML0t01Bj4qeBUEzdqhHtr19Sc8eC1B+HcCN0p8hsXSo=;
	b=lxqRuRilZhOegLb3CXuUptcsWQ6Vl0X4zi5K7P1j8AZgAq2g3SG0nERuQWz6sLnePQg4qZ
	oRKU5Jxt/McYui9L2TwGzwgFGvGuxrCn9xPfA9vHwge0pF4e2a4o8wN2t6goFV3nhROrr1
	/tTFT6PkVh7JXbEbtex8W3DVpcOq/ew=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-86b90133ae8so851415b3a.1
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 01:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789288844; x=1789893644; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ML0t01Bj4qeBUEzdqhHtr19Sc8eC1B+HcCN0p8hsXSo=;
        b=Sh4XGoZpLMTMocZC9p8q39wGlkAIjykNTxpHgPsuvfrg87mPOMaBLPfdGzCK1DrqHO
         3XIcfmCfgqGbX5Tab3qks89b39S+/8QWUsxbFwas3uu5L4qABtG8xKKU5cU/c/pBnWK3
         n8TbNHfVjEOv3basOjWkWmZnL4XxeTqgFO6aKT3jR9yHuXn73RQRIj1Nw5N2nmYjGeji
         +dtblPZ1GCPqVEWbP7XESeVqh7QF/aj+aNvwp2jHPI1aaJDMwdle3eozKJOu2prbUilz
         rBjlhmeLNKGKvDjGT2emTopNlJfSxYTMJWX0lLCl8PjUS6vtlPwAYBtDSsRRzTK9xvVB
         bq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789288844; x=1789893644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ML0t01Bj4qeBUEzdqhHtr19Sc8eC1B+HcCN0p8hsXSo=;
        b=Q0QinpoyHnAaaRfW8KdNzZLhF2gTE7sxsoMZNZ0xpnsK0vz1STv41bBJ4p9d1zxPeF
         j+7DDbHsYa10u5blqUGsqxbxTa9FlmNb5lPxZtth8ZCciDJasxTaVlb+EtoEdkhWSBUz
         0dx+naZzwGYxvYVy8iI0S2WyPylao1XSOPqJsDmd8ZxhqiCxKOdB2kpFBU+6kUC20zda
         EV8pP2SJJjeQoIxzb0WX4Jv8Bl9gl43pBfoDd2QZVp6JAcK1SZhI0YwgeAu0/xUABntA
         YWYkbt77EKa6DFvfpE5hKPnsU1NQkW2ax92uIVsonJo4SLeOyfO0ffhyuJlL77FFSPvP
         KzMA==
X-Forwarded-Encrypted: i=1; AKwUvBzUcil4kFyNwo96WVxCedY07MLU3FAeSLAJBViy0/Z4Wzzv5eMcrDCW7XgmAzN0etrSz0mMfPaprA==@kvack.org
X-Gm-Message-State: AFuF++m+4XWcpLNG8UgHAkcK8qXdWwu4ap94jO6Vg2O7iyozXGJIArOp
	jMqE+YRcTZeF9LmpxdWXcp78xvd9TvDwkMIk7FquI6dPf+lrAY/odSLlTL4vAJ9DOqY=
X-Gm-Gg: AYBFou0vFybhqopRSTSqlU0za2lpOplI8Bcm7/dfoOGBDmaIiouLyL7P+9yGHQoHUUG
	WAisJrxIA+im6bE5HR+1RLSJWcrP4il0tGEHKUzcxxX2sZzXPiqNmJYP1rUnFzl0Ilkqg6rn0WD
	zZ7/1X4I2xUe8KPNYaOzAWjGvGOsc8WonH0aapLZiEP7JSbSvSQZHZnk7aH+SLe2LDf0nZPe8Rr
	M/xsukCPGiB/NDD0MdVU+2WS805SAytETxj6lhyb1p5nKab/QiS35vPZTdwcJU+JtVllQHLbiK9
	efKvSQTZHFk9CCef+B4yUQuBfLsQQxlkxzZ6axgvoDRMOpO44Wpz6okcRVLJnfCO3cgWIcUyMfD
	KlJ08HCQkgaHn53mjGVCCNxoAzJ0B8pe69m8RTWOYErSBQq5woALMLWktqsMpjN2f+q5zLKr/en
	wli6KryuCKzVCZVANOsOjzsOidIUJPgnYdkyciUqVz0H4uqjfN6l40RxPVmKoz5MRzoIYI8OAKY
	mgBodNpc/eWP5vQl6krTHiFz9I=
X-Received: by 2002:a05:6a00:8c6:b0:845:e440:d0ca with SMTP id d2e1a72fcca58-86b2fe25315mr17990526b3a.8.1789288844473;
        Sun, 13 Sep 2026 01:40:44 -0700 (PDT)
Received: from G6L4RL2QG9 ([2409:8a00:1832:cf0:5137:990:100e:cc7e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29cbb0d3sm3070531b3a.42.2026.09.13.01.40.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 01:40:44 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 3/6] mm/sparse-vmemmap: drop Device DAX-specific population path
Date: Sun, 13 Sep 2026 16:37:31 +0800
Message-ID: <20260913083734.86802-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913083734.86802-1-songmuchun@bytedance.com>
References: <20260913083734.86802-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EFB7220002
X-Stat-Signature: r8339zu6j6m1ke1rtk9w5zrm1khk9ef4
X-HE-Tag: 1789288845-792931
X-HE-Meta: U2FsdGVkX18DgVdVRCw0HxBJEkro9q7cKq8+UZo8nrEbgec1Z2qXW0Qp85oGS5U010swXZarX0+3ckObcM/gcBcLftI765P50DhXjJWDHQFJqadSi3ra1vIdzwzQHTs4h7iVjqVRHYW9WG63SsqYEjGKbkIPKfPUXkeYRUIWjfL4Hnj9fLnyTutBUE5lOvyLsEq1LWFpjD/SNYQ6lyh9qhxOK2c4wixbYHDs28UHoVMGlSlPEeLeDTM2rGC1djVe9rCsDCOH+Ql75JjrSC06PHEusG2TdpD4ElEVQCCz+CHmayK5E2NNdID0I9na8Pn0BJh5WsavOPrPJmcSSNtEp9ba0QXN9r6woXc47EllTvoGE0b20mB+LwVwFfZg1Y38ocvCb74jf81sUmw3c1mdYF5HODbJikDAWXga7gRlaPlTwOGhHj/WBnMH8iBf5ofMQ8v3Zoqzm2cHQcZcFc/nEVIxOMAS2B2LL+zIuj3wv5rnwyCbHgskFdteiYq8JEUad3wa+fFKAAmrfu2Wb5oGLsrmbeGxIobVAO0tOQNhiCtJB+6f7jcpK9Z+aYsw9f2jsar+Bu7kSSAySooHS/5WTMzAes4Ini9sxHvZinjPVZTBk90WyqJWcf3p8YrYl84aVF8SDVSRK57H1u0H8NWz94kGDlOtT5bCDWFhuFZ+b0N2XoYHXDOhVvy3NhIecEdqF2AXq2Qb/B5PhrDGY+fCb7GitfpcExLWsMQ5jz9j9rNF1SdQx3LmOVMvvqKY1tws1HgVnSLUqj/i2mp/tvNB/qxY1wwP5qCzhqatReoGJ4yZfMioWnF3c6N0JqSSfGDsW6OKcCqwONahYlIeBDTgOjrAuZL037pNq32cCf0m7Rk5IieYBYAwB2PPGTFx6FeFF3s51py/XhQfKzqsOVL8OH9emVkfkD96s7/TTJbtq2R4jggXaQL1KEyhD+R8W1jOvHajWbs4DRyb02BxdiL
 yrw5nSty
 2UOTeu6SyqLk6CR3b/oErjuO0Gg9azboJPVv1sBIH0YUlx6HDChKOnAgvChliRjvc3wpwMbz0IyQBVUlUfjwonfOlVW+aX5703J1WVc2DYmyNgTB6e3xk8+Bz83o1nysHbi/1be2e9ET0++4UJyVdkW8nA/YSyng8TJQOSaDsKDf7hPS2kgfksWTOpUhGK2VDLEkzg4I0CtX2u7PUA62OFg/xAEloAxzFyigv3Vmk7Nezw7fKZ62RXPQVVUtTAiFdRM2+vK62/E74bYiN8flsehX/Hep8WTvM/Rezq7K8V7ogg/d900mW/nxHADsG2YAqfTnI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The common vmemmap path selects the shared page for optimized mappings
itself, so Device DAX no longer needs vmemmap_populate_compound_pages()
to find a shared tail page and pass its backing PFN through the generic
population helpers.

Remove the Device DAX-specific population path and let section memmap
population always use vmemmap_populate(). The powerpc retains an
architecture-specific compound-page implementation, so select it directly
from radix__vmemmap_populate() for optimizable sections.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c |  3 +
 mm/mm_init.c                             |  2 +-
 mm/sparse-vmemmap.c                      | 71 +-----------------------
 3 files changed, 5 insertions(+), 71 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 9ca28e4a610a..cb72d9ccf747 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1122,7 +1122,10 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	unsigned long pfn = page_to_pfn((struct page *)start);
 
+	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
+		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 56bb4567a494..1650d6bc1211 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1046,7 +1046,7 @@ static void zone_device_page_init_from_template(struct page *page,
  * initialize is a lot smaller that the total amount of struct pages being
  * mapped. This is a paired / mild layering violation with explicit knowledge
  * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap. See vmemmap_populate_compound_pages().
+ * of an altmap.
  */
 static inline unsigned long compound_nr_pages(unsigned long pfn,
 					      struct dev_pagemap *pgmap)
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e83821768c12..028f844c90f5 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -454,71 +454,6 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	return 0;
 }
 
-#ifndef vmemmap_populate_compound_pages
-/*
- * For compound pages bigger than section size (e.g. x86 1G compound
- * pages with 2M subsection size) fill the rest of sections as tail
- * pages.
- *
- * Note that memremap_pages() resets @nr_range value and will increment
- * it after each range successful onlining. Thus the value or @nr_range
- * at section memmap populate corresponds to the in-progress range
- * being onlined here.
- */
-static bool __meminit reuse_compound_section(unsigned long start_pfn,
-					     struct dev_pagemap *pgmap)
-{
-	unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
-	unsigned long offset = start_pfn -
-		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
-
-	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
-}
-
-static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-						     unsigned long start,
-						     unsigned long end, int node,
-						     struct dev_pagemap *pgmap)
-{
-	unsigned long size, addr;
-	pte_t *pte;
-	int rc;
-	struct page *page;
-	unsigned int order = pfn_to_section_compound_order(start_pfn);
-
-	page = vmemmap_shared_tail_page(order, device_zone(node));
-	if (!page)
-		return -ENOMEM;
-
-	if (reuse_compound_section(start_pfn, pgmap))
-		return vmemmap_populate_range(start, end, node, NULL,
-					      page_to_pfn(page));
-
-	size = min(end - start, (1UL << order) * sizeof(struct page));
-	for (addr = start; addr < end; addr += size) {
-		unsigned long next, last = addr + size;
-
-		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1);
-		if (!pte)
-			return -ENOMEM;
-
-		/*
-		 * Reuse the shared page for the rest of tail pages
-		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
-		 */
-		next = addr + PAGE_SIZE;
-		rc = vmemmap_populate_range(next, last, node, NULL,
-					    page_to_pfn(page));
-		if (rc)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
-#endif
-
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -531,11 +466,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (pgmap && section_vmemmap_optimizable(__pfn_to_section(pfn)))
-		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
-	else
-		r = vmemmap_populate(start, end, nid, altmap);
-
+	r = vmemmap_populate(start, end, nid, altmap);
 	if (r < 0)
 		return NULL;
 
-- 
2.54.0


