Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFBBCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B716B00C9; Wed, 13 May 2026 09:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32AA6B00CB; Wed, 13 May 2026 09:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48D26B00CC; Wed, 13 May 2026 09:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C28E06B00C9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 965CC4067C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:05 +0000 (UTC)
X-FDA: 84762429570.20.D267CA5
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id B8D2614001A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fTQ0MPlS;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTByyvfyvRQXp0QDzHJ+fbRqWZip61THGdhvQJfTIW8=;
	b=IvT8lT6OqeBiV7r06L+VRBkUpmZoFX8bkDHkY9eolB9MtEy4s89Zjy/rJIh+MOn/aiCyhi
	zSzRf/a+lUzmDaacjnCsGB22y+vSb1MUpNeOyfNz1IfrFn0gPMOlnMWS3bk67id24UgDTK
	8/Bn232gPE3pAEV1DfsN+8iFtPW1MEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677803; a=rsa-sha256;
	cv=none;
	b=wSYvPhY366ECWgcu/06brwgsaJuzPEWrw5nERFAB+YiRa+w1PXqo1lly2d5TnHe7D2AR4f
	mfGisPJQlpnTtFQMzMPdh/D0lHqE+f170/VDMYQKomcz9Fy8kdJTNfIrkuQF5RT7i2x5Kp
	r8910Zka6sawqznlx93ogOWywrc1tqs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fTQ0MPlS;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c8021c8c42fso2842827a12.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677803; x=1779282603; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTByyvfyvRQXp0QDzHJ+fbRqWZip61THGdhvQJfTIW8=;
        b=fTQ0MPlS0JvrL2fHDXZ9cgrtLpN8D/0wH0CDGr8nKwSbYPDe1jKNGdf4XfTzh6HgKB
         T8B/tBl1vKuYLSZd10Tyb6K4qSP5HNEazindhHwFYRUCfdQc4n+AGOeBxrgsayn/DZ2S
         0ZUfxjhAeA5D0/4KLD7aqkS24Yzv2w7XYEK4OSaSXF2WlqzQO28J3TiE8Lm6jV6dSuMk
         1V/BRRPBckGI3sy7lKGiXXJlyNW8ioy6lBC7TOuj5NKpSd4Bx7phS4EoLuCqh+OU4IY+
         tbwchvxeaiqfOv9hX9HSiZwXWNozHokR1JAp0P0hcqpFDNXiQo5TiF/rXh5jsCcDSKbG
         u0TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677803; x=1779282603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YTByyvfyvRQXp0QDzHJ+fbRqWZip61THGdhvQJfTIW8=;
        b=P/OSU/NnuLHgmlZQ/iC7A/UlIQCpk2Q9lt3+EsROylvkIdEu3F9Afdkh7T1GM8Xx8z
         gpuFVOzTEERCrHqsNJIP15+kAMcF/MrzVegqOd74sHvc7bIepX/UN8jBFO23AuNFmM3Z
         AWg8htRvgLRPmDT8KXqMuvJ7jTQCXpRFqHi7f2/llFHnRYFNPCmn4MkHnQJSy1r980F1
         QcWcDXxfttea/VdUULE7qEqGkMZN8n1Z3YV4V8SuxxMxE4W/2BcW3P378PK22O1uvQUd
         7bj/nE0vgUIY91QFI3hCu5AFm0whfawqxR4P8iatLhvAAjIsvVtXJkN9hBhYqlzmlCdO
         SBMA==
X-Forwarded-Encrypted: i=1; AFNElJ9OoS8kR10ugPnmiQLVf/3wwkymGP6UJ9HbeZDWqG8lO3o1dislOUFdW2QOdpxHEAzKNIIy9wViUg==@kvack.org
X-Gm-Message-State: AOJu0YyKUNUpayF/kC3GRdMacA7xl7bbPTElbdWF08mBnFLW3qOIh46Q
	pk/i0Ygy/6zSR2iGRapt6Kjx85wwV59IrA3jzPSNSiNyj7BaCEIW7jKzb2avImg1l90=
X-Gm-Gg: Acq92OEkgCbp7DR/0h93cbwZlFaBGoOgzJiooOe0FqgSS4rF7xb5ixZYkNL++8IY4zj
	sA/4KjzLlClJFc3oH+uoKHVIGDmA/Uu4ai/7IfbIDCaFuCXd4CXykfYjU9NfrwaB/ypxVKvS/PD
	YGz+35Q9w46GYbz6Z+BAjM6Tp6lqQ8pwps5q8UXBNpDbfLSKEd0REEsNhK+Bhj9feda+nZ+5MZn
	+0L4EpjD0rxP3hNEQPvAT/bwOASdG0rQImbI6DD9b4d5T71Dyl9wJLi5xupgkbOdrgNmmNU3DWT
	pEb6PBduR0tS0BQc/R41o4B/W8nt+miNcoDUJqnyMGvNtfjtPvMT8eEoHO88H9IMKst+FGOGeNY
	D3ecKw0wv9kk+GujCNUVb25cVmTfDl5vWtLOgFwIZbUoO7Z5qpn/NdvE+PAoUHH/Lmq6r482n2F
	/pZfBmXnBvrxSqBzogcR3dyqpnCmu9U/2+COI/tfM3MqqXaOfMpPZYYI9EVGzOnSX3jS31Mg==
X-Received: by 2002:a17:902:c209:b0:2bc:f1da:4bfb with SMTP id d9443c01a7336-2bd275a75b1mr25305165ad.34.1778677802375;
        Wed, 13 May 2026 06:10:02 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:02 -0700 (PDT)
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
Subject: [PATCH v2 27/69] mm/sparse-vmemmap: Support section-based vmemmap optimization
Date: Wed, 13 May 2026 21:04:55 +0800
Message-ID: <20260513130542.35604-28-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B8D2614001A
X-Stat-Signature: 8megc1fjybwwcp818s3rjqdbeuih7kez
X-Rspam-User: 
X-HE-Tag: 1778677803-487276
X-HE-Meta: U2FsdGVkX185+WNQoSYRuk6ahbaQsrF7jye/paoobgkEGst+tOZOHDghy2PGNdu1w/7lWmCpszbVqVQdgAKE8xJHr0G1ZHpJOeDPRmYyeERSiiRZ74Z7JKlAO2fe10oFsLo4+iF7VmU3r/DMAWBmF2kCqlWxfX4po/YErmyX8iZBlF+ySJ5e5nh510lADTJezeqTyGbEmbKSUIMEqf7Ifc+SUSOscx3XauOjjbs1lhQhK87F3HOmSuf5mWBhI8nI1OneOU11ScHrQPC0NU3uGLU3DdBlejphHHk6SBPnbJH5NdyNuLG1KnLxdFp1jS3MdAIbnhblSSucGdOKUyNYNo1uTtRkoZvpZpoNSCti5hstFa7Uo/Gym0pTzk66YXutjZk1cioJgz9VLS2dtY6LvPd770pQtiIgyQjwdT57aROtZKpZEHtD29eqEmS4D0p+F3SUDm4UoSQYtTvUJ6w91uBX/cKNSn+yMcLGsxInzbvN8Ml5T8JGP/tLGofTqHTwTtD5iOCQxdXKbU6w3U1quqZjoObWFZfXBtnKXffYLJP9B9tSxSYwNWBT4jqPUYLiOZPNFyPVAXAwGORCctnukaLAPxD8u9qp+cKxdJWp0rOcQT7lHIgtSbLN5WJBCbJfF2uRTV+kO15b4P/qORj0HUv1CJnCTZYCNQ6E9cilf2OOR2oSrDowhHjW4a7HzzT2ofUB8vq0gNema7S4dgnD3VKnb9NscOnIfD/YGYvudOoIkdeAC1KzzE8ZmTcaleo9j5fZdBgB+cJ8AZqB45D+MEDwbUbfeERtAGc/LsrnAD9E4H7BgnkmMYWNNKM9aITQJl6kkplL8JxAHS+CEs53uuKGebNDUhR1FpZaO/y3T2dfLVueo1CRXYC7nQnL97JnrGmmCiXMM/2JmVryML0TNDypcHbWFgad3TS7lOScO37t4lpQrwWxDqp4rk0vwr2YPbUUVJPdfMb2/iqIedU
 z3kbwvUw
 TNL3zoZjLDYBGIkRVUnBB4I8G7EMmNw+STXe/91FZpZqJ9v0CjIir5bq78PdVB/F+fhG/4ErwB/qPs57M0ix0H0dVXT2/slw5pbIjQZOJqndpn+bCdoXUbjOIszf+Mef37omaHJfQTwFeatY5xA+C8pxWAlksAGG3yo05vxLaCMIGF8G7UFi5e7OJKylnKa68HzbCJSYOtcZHF7xmDi693M0NqNL1ufPV3oC1QAExxbbmfVBnUo44JC9YMraoppyY117v81bW6jKhAuAd2WBE6dehJmHhkf/zG+0BqH8xhTHIYpJbbgEBt2y/a0B9QAtVVzfc
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
on HugeTLB/DAX-specific handling.

This centralizes vmemmap optimization logic in the sparse-vmemmap code,
based on section metadata, and prepares for sharing the same mechanism
across different users of vmemmap optimization, including HugeTLB and
DAX.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h |  2 +-
 mm/internal.h          |  3 ++
 mm/sparse-vmemmap.c    | 89 +++++++++++++++++++++++++-----------------
 mm/sparse.c            | 34 +++++++++++++++-
 4 files changed, 89 insertions(+), 39 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0974205abd3d..bf4c40818b63 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1147,7 +1147,7 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 	struct page *vmemmap_tails[NR_OPTIMIZABLE_FOLIO_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
diff --git a/mm/internal.h b/mm/internal.h
index 1f1c07eb70e2..2defdef1aedf 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -995,6 +995,9 @@ static inline void __section_mark_present(struct mem_section *ms,
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
+
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 94964363d95c..69ae40692e41 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -139,17 +139,49 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
+static struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+
+	for (enum zone_type zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		struct zone *zone = &pgdat->node_zones[zone_type];
+
+		if (zone_spans_pfn(zone, pfn))
+			return zone;
+	}
+
+	return NULL;
+}
+
+static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone);
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
 					      unsigned long ptpfn)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
+
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
-		void *p;
+
+		if (vmemmap_page_optimizable((struct page *)addr) &&
+		    ptpfn == (unsigned long)-1) {
+			struct page *page;
+			unsigned long pfn = page_to_pfn((struct page *)addr);
+			const struct mem_section *ms = __pfn_to_section(pfn);
+			struct zone *zone = pfn_to_zone(pfn, node);
+
+			if (WARN_ON_ONCE(!zone))
+				return NULL;
+			page = vmemmap_get_tail(section_order(ms), zone);
+			if (!page)
+				return NULL;
+			ptpfn = page_to_pfn(page);
+		}
 
 		if (ptpfn == (unsigned long)-1) {
-			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+			void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+
 			if (!p)
 				return NULL;
 			ptpfn = PHYS_PFN(__pa(p));
@@ -168,7 +200,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
-	}
+	} else if (WARN_ON_ONCE(vmemmap_page_optimizable((struct page *)addr)))
+		return NULL;
 	return pte;
 }
 
@@ -311,7 +344,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 	}
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
 {
 	struct page *p, *tail;
@@ -340,6 +372,7 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	return tail;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 				       unsigned int order, struct zone *zone,
 				       unsigned long headsize)
@@ -388,6 +421,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	pmd_t *pmd;
 
 	for (addr = start; addr < end; addr = next) {
+		unsigned long pfn = page_to_pfn((struct page *)addr);
+		struct mem_section *ms = __pfn_to_section(pfn);
+
 		next = pmd_addr_end(addr, end);
 
 		pgd = vmemmap_pgd_populate(addr, node);
@@ -403,7 +439,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(pmdp_get(pmd))) {
+		if (pmd_none(pmdp_get(pmd)) && !section_vmemmap_optimizable(ms)) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
@@ -421,8 +457,19 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 				 */
 				return -ENOMEM;
 			}
-		} else if (vmemmap_check_pmd(pmd, node, addr, next))
+		} else if (vmemmap_check_pmd(pmd, node, addr, next)) {
+			const struct mem_section *start_ms;
+			unsigned long align = max(1UL << section_order(ms), PAGES_PER_SECTION);
+
+			/* HVO-covered sections must not use PMD mappings. */
+			start_ms = __pfn_to_section(ALIGN_DOWN(pfn, align));
+			if (!IS_ALIGNED(pfn, align) && section_vmemmap_optimizable(start_ms))
+				return -ENOTSUPP;
+
+			/* PMD mappings end HVO coverage for this section. */
+			section_set_order(ms, 0);
 			continue;
+		}
 		if (vmemmap_populate_basepages(addr, next, node, altmap))
 			return -ENOMEM;
 	}
@@ -626,36 +673,6 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
-static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
-{
-	const struct mem_section *ms = __pfn_to_section(pfn);
-	const unsigned int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
-	const unsigned long pages_per_compound = 1UL << order;
-	unsigned int vmemmap_pages = OPTIMIZED_FOLIO_VMEMMAP_PAGES;
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
-	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
-
-	if (vmemmap_can_optimize(altmap, pgmap))
-		vmemmap_pages = VMEMMAP_RESERVE_NR;
-
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
-		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
-
-	if (order < PFN_SECTION_SHIFT) {
-		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return vmemmap_pages * nr_pages / pages_per_compound;
-	}
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
-
-	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
-
-	return 0;
-}
-
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
diff --git a/mm/sparse.c b/mm/sparse.c
index 9457a4d6a6fc..3e96478a63e0 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -284,6 +284,36 @@ static void __init sparse_usage_fini(void)
 	sparse_usagebuf = sparse_usagebuf_end = NULL;
 }
 
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const unsigned int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	const unsigned long pages_per_compound = 1UL << order;
+	unsigned int vmemmap_pages = OPTIMIZED_FOLIO_VMEMMAP_PAGES;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
+	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
+
+	if (vmemmap_can_optimize(altmap, pgmap))
+		vmemmap_pages = VMEMMAP_RESERVE_NR;
+
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
+		return vmemmap_pages * nr_pages / pages_per_compound;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return vmemmap_pages;
+
+	return 0;
+}
+
 /*
  * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
  * And number of present sections in this node is map_count.
@@ -314,8 +344,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
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
-- 
2.54.0


