Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A24C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA336B00A5; Thu, 24 Sep 2026 03:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1EF6B00A7; Thu, 24 Sep 2026 03:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7EA6B00A9; Thu, 24 Sep 2026 03:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6291E6B00A5
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:58:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0A6D80258
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:21 +0000 (UTC)
X-FDA: 85247903202.15.3E74BD4
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf19.hostedemail.com (Postfix) with ESMTP id E86ED1A0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SqPnIDNj;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mwg8qfU0YRGSE8UK0HBy9iZTs3Sk7OFpk3Nxuz+XYco=;
	b=ZO1eJwolG6ocIHykCS1OWmzh7s/Q5GD7ijIfPxIe0HUfjNN0lRTtibk7quaO094UEHgSGj
	A0NrlckoGuKvVr7lOx19apHdKANdPp+mIEYPzo6HedSdbHpijRIO4HWGGDg8MivXyZqawT
	UkBCF3Cb0xr6fJtSsPdY/j45zYsdxHo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236700;
	b=VdaMDab61hUIvnJc62/bmUQhPuWWwLI3eCQHv4QLf4ikftmJjfa5UZpw1TgnvW0jA6QEIN
	e6itSh36xQ/kxiU1zsVnWuNE+Cxd3XuxDRKUledZrZjE7hy/AwYkFUS6Kv96aOWAOM7NW1
	50FAYJDrjEmUTe8NHQtAjRovYWkJ36s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SqPnIDNj;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd5cf03so1281728a91.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790236698; x=1790841498; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mwg8qfU0YRGSE8UK0HBy9iZTs3Sk7OFpk3Nxuz+XYco=;
        b=SqPnIDNjhYtPsmWTRSf8UZ56uplriNp34oWVL1YYWrygqWzSUqG7Mxq//46KgynDJT
         MYH3f66EAsCZ3KPpqLsYR3r/bL1kGY//GsoBKaOA3qew/31+BTxPseKfXukt1CpThcaF
         9TovFmk7C/NQfzU0AYH/VIr1zYBD/SMoPmzPQPSiwBQ5lPfgKKk2kCIpgmMqsSmVBxY8
         p5AMISvvIJmfDmEp4H5Z5k0pOyuFH5Y3bjWMtGxrIdaaoZd3gNxn3R/Mn3ivIy6/WAbm
         v0ypulGuFZqn7yv0LI6lezQZ+RP3k+KTaDkCD3io19vA+YWNrBf7XhQYyaD0N4xXSsWk
         0NeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236698; x=1790841498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mwg8qfU0YRGSE8UK0HBy9iZTs3Sk7OFpk3Nxuz+XYco=;
        b=M/IssBJrtj2CtjyJViPepXNXNvAhBV9kYMCYhonzXEoqYCFh24GWGxPSBb/C8gxEPx
         SL/VfBKr9ZJDUtp0GwjpoB0MK7AVNEIDbqP+kEevJi+qIZ5ya2HpPcbK/GiRUnlm3D0v
         ivzXYEbabmut3vCQg3Czdms9FUN/L2E+XJtMQdKt8Zw0zhgLix5pw6Ji1ZI46IFMZ+6u
         GpRIwYjkaeQkG1I04VxNMkz1uSem8Q03Tv00uwEBXXi26cTO3mA/QvVS0H0g1dg+xJBv
         rQ6iw3ZpGSfXsaWgrZj0Jv9H8DnBvxzbhLnZ8E76sIEKy9weJI/bERtL5Cwnr1WWV7uG
         sFhA==
X-Forwarded-Encrypted: i=1; AKwUvBz1xrreffUzcuZwjgsfwQTccboTfdjjnKiAf3AMvxL12+yn/4DdCUw9MsIKxYUZ2r4fDiZnffsTbg==@kvack.org
X-Gm-Message-State: AFuF++lO0eMputSTlF06CP38MYwYivHA4D7aQJghslAmL5FW/XP+FY75
	F4lfKcMh7ZD3H2VsR+Th/SS2Eaz+sf76zM+0uf9ZG8bPHD4y5dcOGjeAAAOmiDa4seE=
X-Gm-Gg: AYBFou0o32XtBvFt6m83jhX56Jco681LjKeslMnYv+vLojrwD3on4wE2YSk7NGJEwvS
	rpX5BfW7mYjeOHEXrPJXg05unZBpVdxev6Rmcp9KxzJgmU7qWWIubIs/TxBEeFM8mJI9d0v3k+h
	bHhJz2XHvZ+MXxsY4B43jdQZYB9LSgN0jxMDaiHFJ/tdexvEdWvRG8FvrKsHrIcZxgWC2mjT3+j
	5yB1kdwZQH9a+kY8BKiICeOUvlUGG+R354KnzAfvFKyopBLghbgrYS5LzFtxMfrA447dPXJjgH7
	FQWVTqWS/OTo05+Ho/rpnA/09NZG5XR7MHDAHTSI3PEBE6N31edJVtAs7AGedxQtW9y3BmcSJTX
	k0+YJlwbnpxwjUs9PNp5LBETrIHK+TfcvltkAnJivq0Y3AoAk02d9N482DxzwQ8hpkwurhKEGou
	22jrvEzzkdQ/wbrZWI8mrHCFsiy/VRL0gpR2y5KNLd0j5spDP3EtY91Ush+HevatVgo/+VyoY5H
	3UHPN5XMxcXhBXgQfgv
X-Received: by 2002:a17:90b:4e8f:b0:39e:4c80:f67c with SMTP id 98e67ed59e1d1-3a09875f8f6mr1584809a91.27.1790236698392;
        Thu, 24 Sep 2026 00:58:18 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0972eec92sm3575622a91.7.2026.09.24.00.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:58:17 -0700 (PDT)
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
Subject: [PATCH v2 3/6] mm/sparse-vmemmap: drop Device DAX-specific population path
Date: Thu, 24 Sep 2026 15:52:56 +0800
Message-ID: <20260924075259.2013039-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260924075259.2013039-1-songmuchun@bytedance.com>
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 14m1mnkzipuwopowqgc76cpak9isbaj5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E86ED1A0003
X-HE-Tag: 1790236699-147810
X-HE-Meta: U2FsdGVkX1/UQaCzvEdRBzwUfWbSWGD0J0UHOt641P5i0Nnj+KzgKIulxVQKA3chQoZCxwuLo5aT87YZycKH+qRptvPDgHgDcNXjasctN4lHA/034yF3x51LRCPmjJd4ffTb0VwGCojTSEBUS22esXtSOB1a91ds8CG1gnbuYZldG8YmGWfJUujNRVu0+6EUB3btgR4plwe1EMDbKdZGzjeK4ZBppG1MndsJK0rAJLk0BFSCZ04CJFZ5590i3p2/pKDGXbyzzJmZ2yDlj9h39GK9cC9V+nFdYFFWlbN/MNdFStno9efIE/9VVfG9tnpuxaIAuvKKxXh6baQRFIgsNcILNjOoRjFTKdM5keC8vJ31xoV0casZzKticHWWFu92EC96zrw8CFcJLZLDoz37vhnYLIAT+vG/WbVCG+ijavcDoA4Fx1X5tgetxdohU1xKqrtiaUxNnLeqkbhCwgXva4EKczHA1fkG432RzZH7HAk9rxacxAqOGxgHI8uKNjEjjk3onr+7VKyQbdqHbVADOe9/7aqzFPEtEy9+2N9Irml+0Ro57RU1ay5ZiyZcOzwig35Pgv4qpmuUBLtL6LPy6IY1tkUHxIb+Pmw96rFkZNuDjfw7yM9Isu9p8INC7Kn+hreF/mcNCH+eiLCho/JyYrcyep1Uw9cL2PTJmW9io7qcdlNUjS4yFicXx0rYwaYYZzb6kzH5sLYjSDm0ES6FiNb12LFJROei01e/5g6c138QJEGSpWrecm/Nww8SgfmDYohUowj0Pq4OA8I4YOX0XhCkWgTjDnyrvo0gg0mUtSLKb9/kCShVi2toM0f3PsF+lkFYhQLM1zW13QlvHaIIAl+CvFja/XLU+Zixn7EgnxFhTzw2BVyghfElPi1HWFBYQv0hz5eocgWmQkGlK8N/BPMjNot5TPMh6+bXWAG3LbbrKYlR+ixBpSssPxZE9EyfUVzAtROO0wIgvON9+zY
 zEBW0G8y
 /Ur4+4TLBTBfuTd68YAbNvcEWwHyQfNfITdrkAkuYXndTG4KA0atrTNM1ARrUPRH5ajf9mlbBwslxT7ueMiH20FvMjVManc6N14FToDOdTkHFf96rhNLWnZSTCYjts5WV4HMQvOiKEDVMK8+5yFBOy4b7xT4XlHtvTQRvo7uJNeHbesaC1NDZkF6CgGtCD4Gr0cowMgNHbnUlUzEFA5kDVtbkh9vS1cqLhfWnzOtbnPtztTUDCmj1I1N2iVMNu9OUYHETM2lSbQOrNFEsPW0HHVeEEwJMv0hpdyvZeNabonRRINnALpX9E8BKHQ==
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
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Acked-by from Qi Zheng
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
index cdcc93714a9a..4aae22beca21 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -466,71 +466,6 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
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
@@ -543,11 +478,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
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


