Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDADFEEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649EC6B00D6; Sun,  5 Apr 2026 08:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621476B00D8; Sun,  5 Apr 2026 08:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536BF6B00D9; Sun,  5 Apr 2026 08:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 450226B00D6
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:57:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 128F713BF98
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:13 +0000 (UTC)
X-FDA: 84624502746.07.779A56A
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4407A8000A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jeXsv6Ow;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jeXsv6Ow;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393831; a=rsa-sha256;
	cv=none;
	b=WSGpGIF9ESnvKWOP18qWNIlDEZc1Dgotpzj57qTMFZEVo3dFvaF/c6dz2XWPDDgEZviyZn
	1u+a1vdBv86dOrdjqeYzQNHABi66FVJ/SyxaPzyWM9Gm3NASjF6NNxtmbeWReyac6EIJKU
	8jMahceoWwkWz495gdUFsLl2LZI3Tfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wYLFkhjHZeMhg1MIWamwRyHzBSmpgXxo2vlP0IB+Kzg=;
	b=aJ0QA6dW8846nPN+YcFHARWYuz4E3HsEce8k3E3FFMJyiVbNeUmXIEF4l1oKnYVRRPXLY/
	1gKFGpqqKImyT4KGtASqpeSUaZhtZEeTQITthrLB2UtKO0X1uGZEWp0xrtl+l9TktBiKbN
	rBso9bfNXHWaVRO/x4lLwqU4qKYAsUw=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35d9c7bf9a1so2805504a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393830; x=1775998630; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYLFkhjHZeMhg1MIWamwRyHzBSmpgXxo2vlP0IB+Kzg=;
        b=jeXsv6OwhQJdXkrBQhRXxJA0se5ThD0o+Fn9pP9bHe212r402uJ4ccJhCzKhqqRBTd
         7euVQe4oqV+ULi3PN9+mYFoHzCM1nuhFbeWAirz8HWTgJG3JtjWHtfHDgqgXAzCfgxLR
         VeJZr+5G6zlVOHFJFb4nXHXnvl3ERRVhMKCuMtsqIuvWJbD0PzKM8jpthqKaG4TN7ENY
         sLG2PoL8c+XOqR9NqXOjTJsrGqU8UOkUjoaBL5WUiwlf3ilKWNZeT+E19Q8AGPVm6ptd
         zHKHXSG+EgnKTemAeDzPvvC3JH+A65VKDLnJ9aytIny8O6peBv/unyeC5rLYEJwOJrJj
         WQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393830; x=1775998630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wYLFkhjHZeMhg1MIWamwRyHzBSmpgXxo2vlP0IB+Kzg=;
        b=HxTqhtxcBfcqIiMTCwY3u0Ml6SFoqT4c/+lZpG9RGtRzMQmdJDBv18zEBVN6P6Uc0x
         uqHcmbVunbEDyLFPAcm1ymCAa75OuEAmVsUsv7Txsy3jAWUEYuFhneeRlMj6+G21GpZT
         Vi7C8bpPFu67QgN01hQi3AZkdbDtPX78OI9477OBxVoyqDZMY59X+S44ng4qmdhnNUB5
         q6sAPaY6JQsvfZMQAupTzPVC+VrsSDnTv0uHOe/xCr6U4m+F2sxP/GoZ81nJMrvw6WB9
         CPniuYY1Fww/hSHgC0dyK1kEN491g9juOqRvv+TYb/gKmHeuxWNXKvBOxlZIBmJPcq6L
         wVaA==
X-Forwarded-Encrypted: i=1; AJvYcCXe8jWtSqTV4DbB6pg3Z5GDeWhqIQm7ou8G5ZSolNvX6yBWSRgWds3bIjOugek/75FeSMvO6WwBsw==@kvack.org
X-Gm-Message-State: AOJu0YwAdhYSExnzWNAoMwREk+O63YB9b8MLO5KZ1Q9muIC9vW0I05dA
	bUnDfJ8+KkWQC1p+pHN7F6E3AiLQrCRC2T9KaZJYTrOSZ1j2LtC3quNYG7uXSnUUSdwwv/hnXwi
	EBmEK
X-Gm-Gg: AeBDiev+A8OdoXHb/P7uSbDnpBl+9XpLiu0XAcqB2jibx54LfQbR1nSMm9A0eIimPBr
	DGYXv9GgqykOHBcJg4h1lVc5Bt3vlhzd7T3R+tX3L/vZ4gYz+WeARuDDOLjC2l2PJkXBHNvGwJA
	L8/lnKIgveXMaVy6oknMhIvm7l82SS6zrnsFS9mfhxnorQL10h1R6dHfimCMjYbHGjXW8KDVods
	3kQWw4nv2vmIFwU0T5QJztNXeGQOU7/I78CkY/rmp4YZkORDvzPo7KeHcpL7LDILG+Yt7XeYE20
	duK2UIoMQhzVzwBoLxHhI3J45dqhpohfI8juk3M4RPoJIh5B0Gm1DQfFaOPl9XhlFoJWEN5PvV2
	nmrZR53Ud08OsZJmmt7BgqHKUBui0f3H094i+hh/u2I58RX77lgK7ys+QLltIQSIH+MAyIYZvoR
	SygeXWiMlF4l9lXfKGYaD5YM/Ijj0yC5GdtDsYo8JWk/A=
X-Received: by 2002:a17:90a:d005:b0:35d:9d28:e897 with SMTP id 98e67ed59e1d1-35de699f483mr8495535a91.28.1775393830042;
        Sun, 05 Apr 2026 05:57:10 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:57:09 -0700 (PDT)
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
Subject: [PATCH 35/49] mm/sparse-vmemmap: introduce section zone to struct mem_section
Date: Sun,  5 Apr 2026 20:52:26 +0800
Message-Id: <20260405125240.2558577-36-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4407A8000A
X-Stat-Signature: a3zx1g9tnduyb3htwc544qqbenriqk1n
X-Rspam-User: 
X-HE-Tag: 1775393831-894464
X-HE-Meta: U2FsdGVkX18xzLRG4HSAfiHAPpA69M3ZZvDAH0KGf/IVdu0Hvq2wU+yXKtWAJN5JLCBklUiNMBxbFQiE7qYo/se5/NrOx0omJ5YHQjcEZxF4RDPykyL6tBNKzQgDmkXa4bI3IrFiGu94dH9fJNtlNRlqBWvuIGLs/A9CJ/YCZ5dR7AkhhK/ytJO7tQHAekA9obejXQgUQKAoDR5RctveH7cwFi+PIHwbU5MlkAGljgNJOw99aA4Yvt4wvoCkvaZYMrAbZ3N9N9hfe+8NHv6y1CY/DqCa4Nxv0XHiKJW2+hwS7Y/XGV/gOcGAsClE4aTF1w7sjBZBT/9yWh82xBLwl8E/fp1XM2jyWKiDCzcXLFyI6c16tMdlBODJi63KnbCIYJYoeDGMAgUtHsMyYH5zdKYShAEUck/128+vgMhmnfbZ1tknBHAzlUGpEG9qBqfm1PomyYY4D61VWDiC7hYDb3MAPhSPe8FTmZBkMudo43t+fEcNt9r1PRkijtAxGlRGlvfwW8NvW6sXI/KYgaBT9IXcdbbHqMxAeOzfhcXdk2B9CM+mg2IsDcRGXdCXR/ZaJDJey8aWaSI35NhIs/S3ybW4d8cqYH1Lwya5Psggn4XDJaw4hEnfdnAX0t6HWgUn0pWPu2AcH/wGmBF9cI/o+78dcAabxogrpmluuiWunqNGZFT9MHudc8AKDjSc7z+ZtwIcbxAseLq0EoK/PCk9GzxwL3/T0Cbvp07qypydV2s4JXJE7vjvq4iSnyTiWTUqmGCs+uKDXSP4JtPfHgE+aTt8g6UYl2Mf3asMYj5hlfW+9/nuZ9wh+h1NFtvp4fWCMwaAlIUauZeDLzalMZeNkabq2mkTjkqpsftfeTUZFnD4TEyWxgYqlERIcuqn/LCLDoUJ+Y5ZnSkl7SKAkn9ISvWzMKEBJye6RqJ0jAzVucYLyU0xebqNdsGv2eqD4e3UGs7kUyPCJG+ZqWgrqXz
 O09yrrlC
 dd+dOLFgEITKAa2Dr+KZ0/X7bkPraDj8OiejzeJj3CnSzlXeF9pSnQNPsvWLXEOPV0oQXYbZS+YYqzHZ796RXjgy4IrYf0ZG4gCFXO9T81gWVzcbdeygwEUrOnOjQsgK/QPjO49giNbIv6eseLVmMAigMeOz+xyZCYxyIK/zctDcPxQLBBJKuKLSJPGogujS1+tQiQQ7WroeaXrb1F5Qeh3lcGelFVcqSOKsadQq0+mm2AWGBEC0u5Gmh+lLHop7MBReTId5/9jCDXHMZ+cH4teouhBDoYexo15oQMgU6qPAx0ot8K8hMP4n4fYIn8bhrICAPfWr1S7gvyPsREePc4EE+hD5/K9R09eEhbZ8ZBzc2Vww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, HugeTLB obtains zone information for vmemmap optimization
through early pfn_to_zone(). However, ZONE_DEVICE cannot utilize this
approach because its zone information is updated after vmemmap population.

To pave the way for unifying DAX and HugeTLB vmemmap optimization,
this patch introduces the 'zone' member to struct mem_section. This
allows both DAX and HugeTLB to reliably obtain zone information
directly from the memory section.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h | 31 +++++++++++++++++++++++++++----
 mm/hugetlb.c           |  2 +-
 mm/hugetlb_vmemmap.c   |  4 +++-
 mm/sparse-vmemmap.c    | 19 +++++++++++++------
 4 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6edcb0cc46c4..846a7ee1334f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2022,6 +2022,7 @@ struct mem_section {
 	 * multiple sections.
 	 */
 	unsigned int order;
+	enum zone_type zone;
 #endif
 };
 
@@ -2214,32 +2215,54 @@ static inline void section_set_order(struct mem_section *section, unsigned int o
 	section->order = order;
 }
 
+static inline void section_set_zone(struct mem_section *section, enum zone_type zone)
+{
+	section->zone = zone;
+}
+
 static inline unsigned int section_order(const struct mem_section *section)
 {
 	return section->order;
 }
+
+static inline enum zone_type section_zone(const struct mem_section *section)
+{
+	return section->zone;
+}
 #else
 static inline void section_set_order(struct mem_section *section, unsigned int order)
 {
 }
 
+static inline void section_set_zone(struct mem_section *section, enum zone_type zone)
+{
+}
+
 static inline unsigned int section_order(const struct mem_section *section)
 {
 	return 0;
 }
+
+static inline enum zone_type section_zone(const struct mem_section *section)
+{
+	return 0;
+}
 #endif
 
-static inline void section_set_order_pfn_range(unsigned long pfn,
-					       unsigned long nr_pages,
-					       unsigned int order)
+static inline void section_set_compound_range(unsigned long pfn,
+					      unsigned long nr_pages,
+					      unsigned int order,
+					      enum zone_type zone)
 {
 	unsigned long section_nr = pfn_to_section_nr(pfn);
 
 	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
 		return;
 
-	for (int i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
+	for (int i = 0; i < nr_pages / PAGES_PER_SECTION; i++) {
 		section_set_order(__nr_to_section(section_nr + i), order);
+		section_set_zone(__nr_to_section(section_nr + i), zone);
+	}
 }
 
 static inline bool section_vmemmap_optimizable(const struct mem_section *section)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 59728e942384..ce5a58aab5c3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3281,7 +3281,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 
 		if (section_vmemmap_optimizable(__pfn_to_section(folio_pfn(folio))))
 			folio_set_hugetlb_vmemmap_optimized(folio);
-		section_set_order_pfn_range(folio_pfn(folio), folio_nr_pages(folio), 0);
+		section_set_compound_range(folio_pfn(folio), folio_nr_pages(folio), 0, 0);
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a7ea98fcc18e..92c95ebdbb9a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -681,11 +681,13 @@ void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
 	struct hstate *h = m->hstate;
 	unsigned long pfn = PHYS_PFN(virt_to_phys(m));
+	int nid = early_pfn_to_nid(PHYS_PFN(__pa(m)));
 
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
-	section_set_order_pfn_range(pfn, pages_per_huge_page(h), huge_page_order(h));
+	section_set_compound_range(pfn, pages_per_huge_page(h), huge_page_order(h),
+				   zone_idx(pfn_to_zone(pfn, nid)));
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6f959a999d5b..1867b5dcc73c 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -143,6 +143,11 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
+static inline struct zone *section_to_zone(const struct mem_section *ms, int nid)
+{
+	return &NODE_DATA(nid)->node_zones[section_zone(ms)];
+}
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
 					      unsigned long ptpfn)
@@ -159,7 +164,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			const struct mem_section *ms = __pfn_to_section(pfn);
 
 			page = vmemmap_shared_tail_page(section_order(ms),
-							pfn_to_zone(pfn, node));
+							section_to_zone(ms, node));
 			if (!page)
 				return NULL;
 			ptpfn = page_to_pfn(page);
@@ -471,16 +476,14 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start,
 	int rc;
 	unsigned long start_pfn = page_to_pfn((struct page *)start);
 	const struct mem_section *ms = __pfn_to_section(start_pfn);
-	struct page *tail = NULL;
+	struct page *tail;
 
 	/* This may occur in sub-section scenarios. */
 	if (!section_vmemmap_optimizable(ms))
 		return vmemmap_populate_range(start, end, node, NULL, -1);
 
-#ifdef CONFIG_ZONE_DEVICE
 	tail = vmemmap_shared_tail_page(section_order(ms),
-					&NODE_DATA(node)->node_zones[ZONE_DEVICE]);
-#endif
+					section_to_zone(ms, node));
 	if (!tail)
 		return -ENOMEM;
 
@@ -834,8 +837,12 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 		return ret;
 
 	ms = __nr_to_section(section_nr);
-	if (vmemmap_can_optimize(altmap, pgmap) && nr_pages == PAGES_PER_SECTION)
+	if (vmemmap_can_optimize(altmap, pgmap) && nr_pages == PAGES_PER_SECTION) {
 		section_set_order(ms, pgmap->vmemmap_shift);
+#ifdef CONFIG_ZONE_DEVICE
+		section_set_zone(ms, ZONE_DEVICE);
+#endif
+	}
 	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
-- 
2.20.1


