Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E41C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD66B6B009E; Wed, 16 Sep 2026 02:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60B26B00A0; Wed, 16 Sep 2026 02:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00F06B009F; Wed, 16 Sep 2026 02:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 805CA6B009D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:44:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 897DAA062F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:19 +0000 (UTC)
X-FDA: 85218686238.13.23AF8C4
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F96C1A0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FGA6jYzQ;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6sM9zpfll+quDztLFFF0jfXeRCau4il9IJzrgeT16pM=;
	b=8IaJPCsjfSwp1BfG1BQfEcBo2qJYOLRUG6f5/TrTuePs643TGZPB2gWtWD6jdqhcc/Alu+
	2TXtlf3pENFxq8lqxmsXHbiFL4qJfOOBM2RL0FDNg/oidE+r+Pu42KGzmjNySZ83TTkezI
	GbOLP8jHulV6zaMGYd2ZTCBLxuI1WnQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541057;
	b=iVem6V6BznIDc0tD5l7MIRw7ZREdhVoazm4SXlLEdRRTE2fZZvfG6F+6+IxUeE3Xnk+dAS
	iM/Q3NiwRIutIgGZXoKFNoVmzqBOeDFxPd2qCk4JjQ9IaEXmOBpyWr5PNfBuFQFi2r5zHX
	brvyUUNhPCpmkVuViJyRx97AywbEhPA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FGA6jYzQ;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2db22383fe8so3847825ad.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541055; x=1790145855; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6sM9zpfll+quDztLFFF0jfXeRCau4il9IJzrgeT16pM=;
        b=FGA6jYzQ2NurWMoEmCsyCl6CWtIKZB2qtw7cjFdEMPPQf/xbMTIPF2F8Rlr1iAPhCw
         MwRyrwlhaDK6eSqmAevyrC9qAcJtVTUryisqXF0ZilwODSMCayEpL5Uw5Eiz4BKGxpAL
         qG+cxngadcrhQ+/rzwNnjhPLDj38VarIp9u80DLKEBeUoLPtrowMjxopf5J5Ph9YUJ12
         4w4SbwtWnRq/IG+d6ceTt2eMTGVnj2QfGD9PuNBfV3kHuuDk/HtsXAqWXk52aQB9cNnA
         wT/FFjXCR85qzfMUYT7Gz9cghi/V+YE9p2fJY7S20UiqWKFRqzIhHcbz3Bx7+I9zt+qL
         CW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541055; x=1790145855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6sM9zpfll+quDztLFFF0jfXeRCau4il9IJzrgeT16pM=;
        b=K2pK7fiTtXTI+eVX4GEUUHHaHDfSJ1S3gdSfQHEsVM1QT6pne0/AinDWiiMAHBULn0
         szxBnUWmuDjTsyv/kAK5eMMx7o/2H6ssJejZBsidf5BrTUGoUvdPwriZwdzT9j7Rd0y8
         SH3IxgEvY0gSspjLScRnkp8e8LsBgg82tJrzZcvY9LGyuBIr5RouCqQ0k3UrbhNjmKgQ
         6CHMFMma4KUjucGOhWxKefuUqceIyVOP5K1FlsWz3fZSrFNHN4j3HXFPNg86jHormvo5
         vZD3sDQhG9fXRS0XMyy6KPKdWnZatxptVP7AjGO99xdaBMGPap0mcSwkVy3bGBXfuTMD
         gGWw==
X-Gm-Message-State: AFuF++k6mhuDxN4Rr3ZdeCLhSZW8VS+06Bo0KQ3rprvlIVSOz9vqgYmM
	3bfGHN4RQiP42e5EMITO3K57HnJI7W1LogzS4DvPDmb/1VGeP8sa3OixELohR//wBNw=
X-Gm-Gg: AYBFou3aLGXrya60LpxDSVasKcjNv261SMBBImsIcCVJgerydO5Ax+YSMEOQEcaZ0pB
	6YE26hCogjy+9hU6XGrsT46cTRU5//V+Dw+zLMzmDO43GVdpS8F6MLtIH13Q+RwAlGLGL5LG/sy
	EDwUpYXCtCR9xc/2fvJOLjuKvOXLugpWjMOBJCFZxxZ497Inr+I/krmTShVEjOWkQpM/ATin/Bi
	GWSQCHZWNY2l80lKxRE6PQ3P4Z6mR/Beczs9VU7l0ajyWGPo/j2i/1tD/d0miOn37FVv8Bqgioy
	IYskwo0sis/60R6pggHS6B1lw5mJFrrcC0BDNfI/mScPsiYiY6yX3oDkmiUhHe5y2+mn1tn0Pw8
	j+NDXTWHVrb+wWYa2C5quOOG7KRwJcb9vcsRQp4KVqNA42krS4Ro2zL4Qrl4Bj0MlLTYluV/KC6
	OnbZEuBvL2JKlEjzKlJhxL+7Z1b1vKDC+EymZa8F1ZrQ9zAXFcGHaS7edo9anY5mgWB9wneooQO
	CmiN7oLO9o8I2LTSq9T
X-Received: by 2002:a17:903:1b2f:b0:2d5:2f49:b3f4 with SMTP id d9443c01a7336-2dd8dbf6ed0mr31915195ad.2.1789541055247;
        Tue, 15 Sep 2026 23:44:15 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:44:14 -0700 (PDT)
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
Subject: [PATCH v4 05/11] mm/sparse-vmemmap: set compound page order for device DAX
Date: Wed, 16 Sep 2026 14:43:35 +0800
Message-ID: <20260916064341.1825793-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F96C1A0004
X-Stat-Signature: b5pzawn7rpwkt1dtte7ua5344at4z8uc
X-Rspam-User: 
X-HE-Tag: 1789541056-137489
X-HE-Meta: U2FsdGVkX18uGkYVZthMu3i1Dv5NTrAS4ty48h0j3PPNE2OGMlzeesCXQWcZbcm6Rur+zdggZ35VrcxlgS1t1DeCLotoneukcql5UIGTysuAzBh8M3A6zp5dzMB0T8s3zUHF8O5B6LvbhBSVhGv/TXi8YobXXGQxYyfwor+YUgbyWPoXcYMLJIdpfu62RXflcdYSx1gRlA/2XXqkuDEJCGRmFGabJBvCXjZk56G6RVvuc/Pk26IBYOUyalpT53k4RF3TZaQkydPCPmHrtkap7801rF5omejm18CB4Vagmm4wZmNHktov2bXNKps/K2TJOoX0qlvhDGel9Qb9IJjpobLscuCj3LxdUnstBtO+qd3U9jeygdFGqv879y/Bodizv94G6RvqE8yBF5YeeGVqghj6IwNhIL1LUpbkzK/Pi6c+lFJYFEVantZeHg6dpG8EoGUEIAJfCDecGPe9BFwh+vAZdAmtrrVDfmrZsmjWvFldXNjc6Tg6ALhClw+vMooR3jeZfJlUeE8ROPikPx1Ld2l2Uz4gB5FMedMtIebEjXGnoLNDRiq1CcMlT6saYHFaKt/rYjS11j/gw08nNWYqBzRPHovLTXqGlTiQUdTJPOpCXgPvsxTRaYtd2D9XUt8CODEQMw4JLFX+a8HCDX6VsMxCif9JQzuL69rJvOpgy34gBpki9AVGV6NNuGg3mxr2H3t0RxpTKmomJDB8DB+/IQB6H+Ia5M2FeBUlFc9uwY3JQ3Ur9hvYlEwnCB/aigktTS3ZBvrEDTIKcSCT+N+M6PoNO1xLGQziCyJ8Q5qXK7SvzM5q1l5rz7hyxgsWFgXkpbRov8FsvYS3Q1F8ymjSSD6YHmtHAMIXElgRszcKNeS85+2sir8o8DPc7p5xK0aodpyJ0RORZ1K6ekz+BQOmRaJ+/uI1+dYC77mOkfpF70flqvoJ15QVofHP4RxluJxYEFgpuuD+Kxz3hqqNTdF
 6o8f94v7
 LYwRDkH7Vi1OmsBSNkPkr8n9KnuwNcWr8kujqXtF+UyRxPs1slfwn2K43lJBacwRuzU0C13X0exCZ3lnFwoED/Y3MsPxV5vrAo3E+nweCwZxBUVpoDEuBrrh6v9Bd17gfPP4TRMtVr5Tu7u1maI1fWi/f6+MUUQkevGqKjeeaPg2UP1eQsOpCwXY94Q+RI/bp/CX+RdPdPtfgGHwCP5qpvbCmyYNOsNDVcxsx2hDdXvgktpy27h1ZNGRnJ5EXO73LtZMoVhXom+3BHhy907dAGZNTqW93ayYAqd3ZLi71N1vaUWEbtRMIaKGT2A==
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


