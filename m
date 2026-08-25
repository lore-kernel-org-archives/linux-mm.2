Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE06C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A456B00A6; Tue, 25 Aug 2026 04:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB426B00A7; Tue, 25 Aug 2026 04:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33016B00A9; Tue, 25 Aug 2026 04:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD4766B00A6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFE091C171A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:37 +0000 (UTC)
X-FDA: 85139168394.20.19222AC
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5759780003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VEVnkYb4;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHukc19Ma/AZahsqFHAmhIDbE4H1sWhtblWFu+eIVFE=;
	b=wL1SNKaCsGi8WFBu94cYB3zKRkMIpknK3wJwZusjMFRS8uOjgsRDLn0cvzguWZpC9OzeZv
	uDmnQ2fCxVLXzR4RJptnYm1vt5Pn15tedgJ4cuMFAhTf4m/rTbG57HHGuzRmwE2WTsmuFK
	6IMfnNfwr2ttAWARHd/EaddFrqnwyHU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647776;
	b=L2e4kYNMorviO2wA3wvGHhfOnHsBspd1nGbYyNZEkPg/5f14rUqb22toDtU4aySi+xxrl/
	ntHiFFWet6qHFCkpXj7UEJwbLEsNOpGMzoxNbENVHYiHK6gDAqpvmdFiouChx8KKyIZ11l
	joofeYxX3s1OA3WwwhXK1DGnGNNdaz8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VEVnkYb4;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38e58034d05so4013684a91.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647773; x=1788252573; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JHukc19Ma/AZahsqFHAmhIDbE4H1sWhtblWFu+eIVFE=;
        b=VEVnkYb4hNRVle3Ah+HcCi8XJDVV1EPQAwLYZqjTH3BSt3pxeDBjcRZ37DFtZ1k5y0
         A+nSZ1aYNVMPVCDB7LbnJea6UTCDixt+NOXO6TAEQ7gC4yMoWVodvBY81OFP8KbqP+C2
         NxED2y3FxRlIBB0ToKa5DMXIBHk3CNYeg5nczpKAbzpKW5UdFwT4J6t/ioDAV4m/yF1M
         frdLHxTDJotKwrPbqhmkOD2dUbz6+0mN/CrTzA8ECy06O6mXp8daavEiHvxRXKfOo/gv
         stMW1FKZ41gvWXvndDnz4x6I0EK4Nxtm/9do42DxfyScbBMjro6ID53IBX2LWETptWPE
         CwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647773; x=1788252573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JHukc19Ma/AZahsqFHAmhIDbE4H1sWhtblWFu+eIVFE=;
        b=Dc83wSaQ6pSigweTyoYQlTJC2b20yqHxAQmYf2o7Is7pLEgFx421xh+3khuC99dkE3
         aq9NHNSv06mesiyfAqw9LOao/ZU9gsgPAfkYGNV84R0QxGYnxXMLxLWpgNAGDSDoTUCF
         xDZnKNOXdC463kfMmo5vWKdOMVd4YQ9j1FHQ1dDZFiZbBzEbScjLkbuQmea4/IQt67AD
         Ht67dbaCLpS2ydFJCo6sJkyM24kg7p6PxD1kpypcyySJJIqhhzq5Dgimj3Pybb3k8WUz
         eaDOrozjIFWFJOupmCFIZCCaNwItd64eBlzMJBxT8K2Dbvx2agg1qlU0fSvHuTFXlJsJ
         SjuQ==
X-Forwarded-Encrypted: i=1; AHgh+RpLyQ70/A6R4tJkc2la2rZyFAjmSG4fF4ga9GzDvoV/iKwMUxTkvTguwPojzS2ouFgVwrIKxZghew==@kvack.org
X-Gm-Message-State: AFuF++kgmI3/apmcVnKJ+fssYcQ78s23SB4Y8Z75LXhrCR7y537mVdwU
	n5vPNOsjh9NcVy1O/nRWTzzIP/l1xlfq/ELVwl2sXCtwfixtGdgxz88nvFyo8qW7MXo=
X-Gm-Gg: AR+sD1149/RVcZ2GpTPSnMwvpxcc/r026ClW2zQLTYtBmSNTZgt3DmHRB8Z49382tH2
	ipirwEFDHadv0w2jmNUzEdZK7vKb76625NCQ6mvliCVpg+Mny9OvW16nLAbGTdnCDxW/ePsBuxw
	PF1ITt8Y8NI4RB6FnF6HanB9kt3JrkDlhf10wUsbA1BYdzRruv4uxjVkZlLkUk0ypOxQ8E0gt/r
	TwiIyL2D8aafH5LFOBIo0VY7qW6o/8zmKbfskGUvcokXO0Qmrmxf8kMSiys48yFl/V4zPvyRxDK
	3laAuz+Z4DFRSOGLWqt0ds2f9RUHqEFGNyydrg0oM71BSpj8PZk9cP+7UUXN0TFyOSNZL4M711C
	gkcpiJdI5TAF+AaBgiSwU6ke3HRXuQlV48oD5cyjCnRtasV5kWRrPgl+6Q1YPuNd+7tdkoJROyj
	oc+IY703KgTy4mxqzPHQyRJFOmFi1WyJ4OdXXfJQSSlDM7pKc1g7TfIIkP2lNrQPx2+wxKeRYnM
	HROY+8IaIdtuipGvo/8+wnigg==
X-Received: by 2002:a17:90b:558b:b0:37f:fdc8:71b4 with SMTP id 98e67ed59e1d1-395c33371a9mr62072248a91.2.1787647773077;
        Tue, 25 Aug 2026 01:49:33 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:32 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 08/17] mm/sparse-vmemmap: support section-based vmemmap optimization
Date: Tue, 25 Aug 2026 16:45:59 +0800
Message-ID: <20260825084608.47437-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: w8urohosejpquur933jq151658idtxeq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5759780003
X-HE-Tag: 1787647774-372453
X-HE-Meta: U2FsdGVkX18jw8zec8jmh7gS4lLTbLhFpVZY4f1VT393f85ZHymUQ1esHKQ0/lWpZ/iy+WJ+Oa45f1q2aRxsMLtgkTiwqFurmVp/33qBCd4jLW3pg9fVmBJpHcFDT0d86WtRPf+uMDTutBncPJNFy+9M5Noi2cTClYpytjbRbxCBL15Y0Y18KA7KDwq2h1nMLpS3PclWf2WLBajWWkYVbbHPIia0Boj5LZElR9dpBl0i4jdDM2Ve3jay2cvcquaAIuGETiwSxsSevoiF4ZPjyuu6IEH7EuSdW5ZklTtvtH/27YKpSXXCCkXXaSEz4RjesPGVVxHTucNPHc8RzKSdVc/3lPJ2dOS+D5Khk7B29eMRikX4t+69yKvgQeug+yHUETdUBmifIN5vXKe49zyoq4mwy3E27RZG4jovjI2BJhzFVI+zbj5Fgn+cT7eknEE/ppQEYdpnaarFk60k8BPARtqYIPmuRJkxFCYzcbHPiEm4VP9XEaEYDt1YMIa1W3OjJXKiCMDsfam6m97nsx2mG4umKZEnWrqXtTfHi2i31HT5ylLHpx8D8z+D4LZJqSSYweF48bdzbgmynzuCf8PBQm829OKI2bnRcwKEkbh+imHMmWh3ZC0+SHeYs9R64TN8Z3FuGFhbg0WKq6UGd7zdGAYICxHB8UxY33rCxFslbc1Hj+tTbz+cyFKZh5rP/EVrR9DGFP0Fq1sX6YHYNMNjqSd7qf7WKnyXhtSLSbpyruw5VuztV9ahDcsNRkvxwAB8fgnc+yU6yRs6WGAElb74I7KdgtUejAGLNnQK7GyVEyQc1FFr0ND8r1+LVrc7pJJzCX2wkfUBrbdn4oS4pmo6GNAEoIvlanFjytlXetM9YOowD5wId4J8jpMa/a2VA3b2GFZvTazJKgU/WiWbny3d7CdiVc/3yirrq0JNoh8D83iBBv6pTb8Ythfi7deGbJ1zsSrEciwKEvHP+wOnsdU
 Pyjv7Nh9
 0h4fgnYYqZHBMSWdbp9dsSrOs6mjkyz80IjQlPym7yCmRKJt8R9VyCK24H2gvDXT6E4vDsgsNX3ExXznqmMI8o+CVG/qUiN1Ax0F59jOtxUbb1EcFA/R1STM2t3r1SJ/sTFkuH0D4h4NWNUaEQ1e+fx/kzRffhTP19Sh3+Nk1H7/qfSsPpOrP2YDsS051vwa+Sc+5UTpsSWV/fr4Q7D1kCAYv8qRL5uuJ9k6IvGBh/HVC1v/g/p+GxexbtwxKPGp7MmsuTDLG//Ao0aj0SaDwGP0H2pEvRhTonCWSE/Hua57xVChPYIvlxnZsEUy1w/QjrkHc125SzfjXsBS/+Htsbs3U0BzaeSktCBsRWYDbWsCDaEfynNyYsw6hn+nj9it++o92kHJ5UnNf2vg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach sparse-vmemmap population code to use the compound page order
when deciding whether a vmemmap page can be optimized.

With this information, the common sparse-vmemmap population path can
allocate or reuse shared tail vmemmap pages directly instead of relying
on HugeTLB-specific handling.

This centralizes vmemmap optimization logic in the sparse-vmemmap code,
based on section metadata, and prepares for sharing the same mechanism
across different users of vmemmap optimization, including HugeTLB and
DAX.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v5:
- Add vmemmap_alloc_pte() to keep PTE allocation handling clearer
  (suggested by Mike Rapoport)
- Move preparatory section_nr_vmemmap_pages() changes to the previous
  patch (suggested by Mike Rapoport)

v4:
- Move section_nr_vmemmap_pages() outside CONFIG_MEMORY_HOTPLUG to
  fix CONFIG_MEMORY_HOTPLUG=n builds (reported by kernel test robot)

v2:
- Keep vmemmap accounting and population logic in sparse-vmemmap.c
  (suggested by Mike Rapoport)
- Move vmemmap_get_tail() before its first use instead of adding only a
  forward declaration in the previous patch (suggested by Mike Rapoport)
- Simplify the PMD path handling for HVO-covered sections
---
 mm/sparse-vmemmap.c | 46 +++++++++++++++++++++++++++++++++++++--------
 mm/sparse.c         |  4 ++--
 mm/sparse.h         |  7 +++++++
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index ea3cacec0a79..8d39196f6d93 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -148,8 +148,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
@@ -175,7 +174,6 @@ static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long n
 
 	return 0;
 }
-#endif
 
 static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 {
@@ -215,19 +213,44 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 
 	return tail;
 }
+#else
+static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	return NULL;
+}
 #endif
 
+static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
+					 struct vmem_altmap *altmap)
+{
+	struct zone *zone;
+	struct page *page;
+	const unsigned int order = pfn_to_section_order(pfn);
+
+	if (!vmemmap_optimizable_pfn(pfn))
+		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+
+	zone = pfn_to_zone(pfn, node);
+	page = vmemmap_get_tail(order, zone);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
+	unsigned long pfn = page_to_pfn((struct page *)addr);
+
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
-		void *p;
 
 		if (ptpfn == (unsigned long)-1) {
-			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+
 			if (!p)
 				return NULL;
 			ptpfn = PHYS_PFN(__pa(p));
@@ -246,7 +269,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
-	}
+	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
+		return NULL;
 	return pte;
 }
 
@@ -435,6 +459,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	pmd_t *pmd;
 
 	for (addr = start; addr < end; addr = next) {
+		unsigned long pfn = page_to_pfn((struct page *)addr);
+		const struct mem_section *ms = __pfn_to_section(pfn);
+
 		next = pmd_addr_end(addr, end);
 
 		pgd = vmemmap_pgd_populate(addr, node);
@@ -450,7 +477,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(pmdp_get(pmd))) {
+		if (pmd_none(pmdp_get(pmd)) && !section_vmemmap_optimizable(ms)) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
@@ -468,8 +495,11 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 				 */
 				return -ENOMEM;
 			}
-		} else if (vmemmap_check_pmd(pmd, node, addr, next))
+		} else if (vmemmap_check_pmd(pmd, node, addr, next)) {
+			if (WARN_ON_ONCE(section_vmemmap_optimizable(ms)))
+				return -EOPNOTSUPP;
 			continue;
+		}
 		if (vmemmap_populate_basepages(addr, next, node, altmap))
 			return -ENOMEM;
 	}
diff --git a/mm/sparse.c b/mm/sparse.c
index c84b4c7b8c70..e6cb67ca9c8d 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -305,8 +305,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 							nid, NULL, NULL);
 			if (!map)
 				panic("Failed to allocate memmap for section %lu\n", pnum);
-			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-							   PAGE_SIZE));
+			memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+								       NULL, NULL));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
diff --git a/mm/sparse.h b/mm/sparse.h
index 02ed0f34eac8..e427d72e9c2d 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -111,8 +111,15 @@ static inline void sparse_init(void) {}
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #else
 static inline void sparse_init_subsection_map(void) {}
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 #endif /* __MM_SPARSE_H */
-- 
2.54.0


