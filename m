Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CACB0C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3FA86B0099; Fri, 11 Sep 2026 01:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1D36B009B; Fri, 11 Sep 2026 01:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7256B009D; Fri, 11 Sep 2026 01:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98C286B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:04:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A51EC0703
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:59 +0000 (UTC)
X-FDA: 85200289398.10.22AD93A
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54ACAA0007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=huqixSbu;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6sM9zpfll+quDztLFFF0jfXeRCau4il9IJzrgeT16pM=;
	b=CmQjjJrg9vjvcYE6i1cFe+r55duJWOX2e4lSKKfylhbe54GzCSddK8eowR2zJbYQPHnsn0
	S7UHokMUMpyJ+VFxiRe5nn30PoXrF3mOXCpF5ECIWwNfvks4mRqUP19q/l/7E8AMB9LBnT
	zAcIn5HTOXGJSfxXZPa02T2AiQiPteE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=huqixSbu;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103037;
	b=dRrZ/opRximPhb/w/Vlapi0PXKR9QjovjUsS5nTMBparyc8wivqyUK/DRE2m9vwy7rgkJb
	2NKtdndMGTNNPcHURml0vyLVT3V8geDB9WFP4+b4GdgD5KrK9W6mtIeOSbZBu7/TEcYoxh
	gXdzcndmdbJ116rI7OL7ihx883ods8Y=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-398a5aad413so490454a91.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103036; x=1789707836; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6sM9zpfll+quDztLFFF0jfXeRCau4il9IJzrgeT16pM=;
        b=huqixSbuYXnFXFhD7O+3sVgPslRhQpM7GIOIpqhiQHyy1LgWsiSSizaBj8myrwPxZw
         Yk5K3JXow6UOkxzrLs+V56Sae3A/erb8QBi2bh6LcFPyAJt96+09lzRsOwSRuN+Yby65
         HZc0tfZlgi2TWzIbnN6XSF1iLDgAvlqXpuogAVn4GxpqAdoI0DgklBERbcIH99QmYPLN
         iu4KZkwJtTwX/xwOBWU4xkteTvk+AX4P32+1NmtOfG/8mPNMKYM1kCiZ4KRJPUHYwb2H
         ipc3yiwgEoadXuiAkBwb3A9jPPiOCh+/3jx/2YeHGaETKx/6qXQy9kl27oO3x9h92lQ/
         +dUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103036; x=1789707836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6sM9zpfll+quDztLFFF0jfXeRCau4il9IJzrgeT16pM=;
        b=MX1Ze4c+JnJOvcK/ob61QnjYkehq/9iQ81TA9wdt00G6qw/+F49IGznjBw22qBjqds
         uSYGsvKjqdOAF8ZJKtgiy77YmsqPU2LurKFcztVk5xxhZx3wPF1JWQJ/P5/orYjtjwZz
         VLsOxmK+PkjecdqctpJxCA5VRuA8smq6At+9/RNvAtVUcAqiotACknqM9skyaR1H8y8Y
         amFLlixmodSShBPWfsULk3dt6myu1NIP/LsHgl5pjxHAm5oYv//ozk2GIlQZ0w/j/Pfb
         Cd3dE+QFaD+1xcZNptVLj5+2p3kdhzfO4tktE1o2PcR5Q0xwjhg3yyJa2E2Cr47sb62N
         2pdg==
X-Gm-Message-State: AFuF++kW/WIWg2e//8WNowyrfclYjKLHPUH+aBsR6o3wRm81tTG3o3lQ
	mOODP38M2oW1bCZKV9uSXlpq8ZC3dGRXq4vQS1B1o/qVVluL7V3My2JOCFBiFsfT2FI=
X-Gm-Gg: AYBFou3+/0SNMcfbkcWdY5SFGJ++DBuP84Y7OH5qEHeUehxCm57jvCKtPC9/4nAc199
	g3gsT703TkXc+kQ9iWsY+9vfXUnuDDl2HnIue8eYdMo0A3c6lT0FSSOJPfNg8uwNKZTCH0tTmX/
	lfhKE9Bty80NExlnUJ57oYRZvsfA9jTNFnH1s8Qs609ojImcO86IAmv8+mKmhiyIn2B6OT7VBm+
	SEi9QuvivuIkaDOCN13L3sN1K4J0536UXH6QFLrUA7y/7PPN2fHn/rJXLgvh/9QCSWWGp9CPhSL
	TGBd6JY5tYWdE3SxuQjgBj5BvstCDLp+eXu7HQxUKwM+X8A14qsueJQC8IJRVSj3SOqyQgQOZVA
	m5NiPSMzJhuiXO1qPndd12nMvhq0U44L2OLDuaA+9LoXHYLZyn1DKvvn9gqKmEyj4tu5Ppqi1//
	WC5Ub3dwf3l8ihEpLMvpDkvydPgg6sTxCmLhpCm75tGaDxe+uYzTgzLcHiF2zmsiJyEXq4CsRx1
	dOyPWK8nOPUXxd5gGV+LDz+X/vcxD42qX58
X-Received: by 2002:a17:90b:2b43:b0:398:a2a3:b631 with SMTP id 98e67ed59e1d1-39d9c21f8c9mr4085781a91.19.1789103031225;
        Thu, 10 Sep 2026 22:03:51 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.03.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:03:50 -0700 (PDT)
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
Subject: [PATCH v3 05/11] mm/sparse-vmemmap: set compound page order for device DAX
Date: Fri, 11 Sep 2026 13:02:22 +0800
Message-ID: <20260911050228.58884-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zkx3sxed846n6w56s7j3mbcb7uasu3k3
X-Rspamd-Queue-Id: 54ACAA0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789103037-219044
X-HE-Meta: U2FsdGVkX192n+nFpqwitk8pgYvUigzZAb0KPjwE4xR9z/svkjjyT2IyzTncVdp7aHb7YS/L1UvgFuaeAeDJDyGnGUqa2V3SDA4owP5YwG4HHi0hHxqvNE5dY3NZ0PdkbnznHgi5LH7jXwl2F8C2aJBnYTGkrBp3uaGNiIuPsiIL6w3nQcbcoJU88AUxKM8RUTdU2Jk3U26a8HwNzVTMUJ0lCoVWFY2bKp5NsBwDlIN6n1icobXDZnXQ5Ybwb3plGo/gNretUQlHYVt0Fo66xsUTmkYcJQZ19MqjSJdHClgedDZ4ekwWI7Xe8jJ6Axr3H8vluPXfLWjWQpxBmgkSOZhestR1hdKo9PQxEBJfU1lHkk8CR8k3Ys37ujPrLzmDHe9EubHjz1gwfco1TgSuDD3qsq0FJxhYjWTHHRIDehriRFKqBKiLa0d62ynYLfqwSMhiDXARHJD3l5YXhsly67cTX62GIAJsLQGnf+u6WXHLz6u55Yk+H4/9gADvppwvfqzVn+ohP9NfmwcwNuDPu/suAMjFt3CPPazNRkNwcwPE0CSxgYE0uO0oke/zZUGlARZx2t1HIbuvplfYgJsqdVX428gzglfdNEDo9opFDgUtrb3k5MF7lQeHNj10cUokpmtl6HV9RIBXAuIu9xaeJOg8YtjKtQ+xKs2Zt/MeirVDct/b+zF4sdcC07o4IgQ2kg/fNaiGQm30wensgv5BJwHLg7wQK+zIRRAvxZNxKpN0cgnRF++2c0NID0kbe38tAsN/mbxdHlYzg9Q2SmYO52e5OCMaXqVpwiWc+Em2ua9v8O9JFjOZnfgxDvCfp1b9bQsontoHp6omQzpB2FjvECZBusYuV1iMqYueagJB9b37phfAluQ4U1h/n/4cCe/ap1JxkE3ffwIhVqPi43bjb51BDCc+CSmayIW2qxKmCqr6gHXBj1oTkhJGccRzgZh3izL4CbsY0g4Qtygj0ho
 ZlNbckUv
 qWTvm6CMSfZsBLejYrRGD5/KFNLMOe3zFCTi5dSh3n/oEzpIxlgBKhVRVz6tSurR9rqFbj+ndHO3L6DiDTXwfJtdArxwmpmZqilxYIUZKRd6UcQkHpQM5Wv2vB8sHW0l/4PBl2bBHbeTwL6AYwzx5AYMnzO/vs9ZKS14jsn9YHBCoLA67ovuteBBdZlg16/2txs//oLMEm2a8/GttNYp9b8D++hlAdAB/OdblQG79GeD20ZQR960+Ybnx6inVuUqwgcEym8YQ7ClWX7SrIkmzHp0rtnYQ28xMMzbVBZ+S7o7MMXNM5HcoIvwbgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device DAX can use vmemmap optimization only when a full section is
populated with a compound-page geometry. Record that geometry as the
compound page order in section metadata before populating the section, so
later vmemmap accounting and population decisions can use the section state
directly.

Clear the compound page order when the section becomes empty again. Also
reject partial additions to a section that already has optimized vmemmap
mappings. compound_nr_pages() determines how many struct pages to
initialize with a section as the smallest granularity. A section therefore
cannot safely mix optimized and ordinary vmemmap layouts.

Partial additions continue to use ordinary vmemmap population, so they do
not save vmemmap memory. Such additions are uncommon, and the lost saving
is negligible.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Update the subject and commit message to use compound page order
  terminology
- Use EOPNOTSUPP instead of ENOTSUPP

v2:
- Explain why optimized and ordinary layouts cannot share a section
  (suggested by Qi Zheng)
- Collect Acked-by from Qi Zheng
---
 mm/mm_init.c        | 15 +++++----------
 mm/sparse-vmemmap.c | 16 ++++++++++++----
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 97e0158d2aca..efffa8609b85 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1049,16 +1049,11 @@ static void zone_device_page_init_from_template(struct page *page,
  * of an altmap. See vmemmap_populate_compound_pages().
  */
 static inline unsigned long compound_nr_pages(unsigned long pfn,
-					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	/*
-	 * If DAX memory is hot-plugged into an unoccupied subsection
-	 * of an early section, the unoptimized boot memmap is reused.
-	 * See section_activate().
-	 */
-	if (early_section(__pfn_to_section(pfn)) ||
-	    !vmemmap_can_optimize(altmap, pgmap))
+	const struct mem_section *ms = __pfn_to_section(pfn);
+
+	if (!section_vmemmap_optimizable(ms))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1144,7 +1139,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	memcpy(&template, page, sizeof(*page));
 	if (pfns_per_compound != 1)
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, pgmap));
 	pfn += pfns_per_compound;
 
 	/* Initialize the remaining head pages from template. */
@@ -1160,7 +1155,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index aa89c16f7fc7..02da1321197d 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -135,14 +135,14 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
-	const int order = pgmap ? pgmap->vmemmap_shift : section_compound_order(ms);
+	const int order = section_compound_order(ms);
 	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+	if (!section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
@@ -573,7 +573,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_can_optimize(altmap, pgmap))
+	if (pgmap && section_vmemmap_optimizable(__pfn_to_section(pfn)))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
 		r = vmemmap_populate(start, end, nid, altmap);
@@ -792,8 +792,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	else if (memmap)
 		free_map_bootmem(memmap);
 
-	if (empty)
+	if (empty) {
 		ms->section_mem_map = (unsigned long)NULL;
+		section_set_compound_order(ms, 0);
+	}
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
@@ -803,8 +805,13 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
+	unsigned int order;
 	int rc;
 
+	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
+	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!ms->usage) {
 		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
 		if (!usage)
@@ -830,6 +837,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
+	section_set_compound_order_range(pfn, nr_pages, order);
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap, pgmap);
-- 
2.54.0


