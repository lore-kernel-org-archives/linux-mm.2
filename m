Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B417F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18CD6B00C9; Sun,  5 Apr 2026 08:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0456B00CA; Sun,  5 Apr 2026 08:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9068C6B00CB; Sun,  5 Apr 2026 08:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF796B00C9
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:56:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51E461604D0
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:29 +0000 (UTC)
X-FDA: 84624500898.24.FFFB25C
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 99AF1160003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eDfTMDiD;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awaFXPFMYUbrBte65uesX1HHeaiEoqtP90DsGctc43A=;
	b=fcm7UmL81FuFNnKgF9ZBZpgmfsqYoULfviZ4wEhMfDBdeSb1mR/tUJkT7W6Awhl5pT0RhD
	5S0J9I/id/txI4WOnxCbQQoJwPCow4aUNj/KwlkrtbDqZqx8T1FJTK23XnzaemBtidZA8c
	BA1a9H4JeAwhz9aM91HnIdEcuq/tUdQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eDfTMDiD;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393787; a=rsa-sha256;
	cv=none;
	b=AxQHglc1+p7uCzBQn4cBF2qn2Hk/W3Lqv8uS7AeStR7kOkAB7p4BBtYX8Qy98ztugOCIOt
	hwtSfKx0FRAxI+LTmunTnW+ylzif4vO8nci2IYSOunMcPRbPCugT2lTthWteCD0zAlaOv5
	jzXr7+5e/dlqYoN/xACOsrI2HLzkLbg=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35d9c7bf9a1so2805201a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393786; x=1775998586; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awaFXPFMYUbrBte65uesX1HHeaiEoqtP90DsGctc43A=;
        b=eDfTMDiDM55GG/94a0YV4l0HGSQTa2Oyyq7L++/iriSFRGL0Sio7GfY7OKf2I/60wJ
         DVdmmFvsO+5SSvJz4k89RwMu4O7nboiiXtcKLy0PbRmKVNScj0y+dUb3u7yj3sXp27Nf
         H+Eh9DKNzjnapjhTVcHi43Vkv75vQcAkU2uG4rPSkTHzNQxlxlR5jzful2iUyN2xxuV7
         CUSkt52CFAYisGEm/MYq9s6+M5tqfRrXTnsr4k2YGl7gznDk4bhQ28AEyHv3/ptFifnD
         ipZPvqDM3Ob1aO1kHXFahTRArWesJzOgarpmQol4xw64yBOHV+9ojzNEjaTKvSOeOIj6
         ixLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393786; x=1775998586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=awaFXPFMYUbrBte65uesX1HHeaiEoqtP90DsGctc43A=;
        b=LF+gL00MrDkTqL72ofD+OgGGrVWBGKH5U4CCqQsH5mQS9FiWq4pR+FEhe8YoaNGWSj
         LoSZEQw/J4DeEjO6HLnG+Tmazczbe+rGdyJ7zZtpSIFiwcK3b0hSJ5Jlzi33MrcMvMv/
         ymvUq+o5B4AzX5KNSJhb7b9pB8vM65RHZa7CQNPs/8sSGkXUYaDrn82ldo+5/r7Nxf68
         STaH4awjE2QLJYKHePMUz+zh+qjuIsEYR/6SF/y6OpWFKLCLhrmAWfJ6MUjgMwclCNb/
         T1ABAqLZF+JA0a/j6euKN2YhC54eeXTnAz5eX3qTlQ4C2NhhYenl62lXvaDSpJYz7NEV
         B2Kw==
X-Forwarded-Encrypted: i=1; AJvYcCVLUlZ0h/aZXrx8idLxHG+kxgIfwriwlBS7a8SJak5SC64AbmluNql2ILMeZmYgz0w2g/AYTSDPkg==@kvack.org
X-Gm-Message-State: AOJu0YzuoMTaLwc3nDVcaMvmmxmXQqcF3dStYrKV+rrHnSXmSvAeWjj5
	Nuu455ZLjq6hJHRqQep2VYvyHHilyde5rC3IclEXuyHMqXSI13giUZLmlS7b75ltoHE=
X-Gm-Gg: AeBDieu14fy3inWMmV+CnMdADeuNu8QLGNxXQ7Tf9EarxElo0Ny+TiYhG+kIbY8s21P
	ZNlesBk2itxrOqwLKshX65lQyNiuMQrNBxicahseNtKyg4QLtmyFwqWe2QxPhdqmDoXebV0a4BS
	4z+7kND1KxKNDAnz7QFbJuBBCsWgzGaJtCC22dLqbGYgpq7Y7gB4fs7tlv1YYNgQfN7LU/xIxLu
	djExZziihdu2IXmEWpnIO72lR4ejYBxZ8qGIt+hv8dm7I6k67A7AqbhtSNVnQkDTe5CaQ067Dy7
	LKlStku61EYSIX2j5lsd71PFxVdd3G/pxB4NM6dFpfpzaylDQKGmI8qHVU/6952ZKYhAIgTd4YP
	btvosWwTkm/KzVMpeXUx+x3M2z6kfXy+K0J80dSray1HYk0bP9MWs9gmj4mWZhp+9baqbG/Bf4D
	Xfrp/JTUK/nVwb0LSpl+nWfv0FD95ugdMwJ1PWbWATlqAfAroGPlss7w==
X-Received: by 2002:a17:90b:3811:b0:359:1130:1047 with SMTP id 98e67ed59e1d1-35de68ebf53mr9391600a91.17.1775393786359;
        Sun, 05 Apr 2026 05:56:26 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:56:26 -0700 (PDT)
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
Subject: [PATCH 28/49] mm/hugetlb: switch HugeTLB to use generic vmemmap optimization
Date: Sun,  5 Apr 2026 20:52:19 +0800
Message-Id: <20260405125240.2558577-29-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 99AF1160003
X-Stat-Signature: f19mfpte3nrwqshx76me3m6c3w3eej8z
X-Rspamd-Server: rspam06
X-HE-Tag: 1775393787-842883
X-HE-Meta: U2FsdGVkX18warja49urDvY0bpUPS4lsmMThcnedvYhoL9bs3VnQQp4YZG+MZUcq4dtf5iMUKprtXPaNsJ765fNBBZh+u37NN0cbiALySWotBuW3TqNAOG9z8uFRTcKNmPjwBTX4XWMmN87YPSHhcU9wMAJw71EaaTSBIq+2CvE9j/NJoCz5gFkEtkTRCOKuD51y227r65nGnl+uEYxqZS1qMIpQ3x8oOkPjsLnnCBxbhi06d7IDDt14/d/PcC9ekTENUDJgtL6BxfwCjIdM0SyVEUGaEOwbKSOkLDSPE9/yA7cA3euUmR3pdi7g0BJMyQmaIwcQP0T3gTEkFjjgAmmTtCnCbZI0P7ehAzWWKUXmJo4NzuxIipSA0kVkXRJIlDPJsfYxwBMGn5YezfMBUvKf/Oy7rtUCGixm2qUEu/lhp/b9tAsCM4FDUbmSgz9hPpzWku2vEb2nD8FeYWbbh/2GvaA4MwiKfA1Cm3ngjrdtrrfmIbMp/hr6rOoPVlVoUmMjq4G3PAeFag5HjmvazyM1iKvUzIxhTYRorje2hyBawe7EOMAXuAWUavFkEZ+6PhjNzXyr3WIQc55lGW7rDDqYHXm3SQrnPGiMdvzrJcheQu8ICMKRyi4WLJg+rf7yfQd/k+NmQGYYou9h3GiEIsdCiSjOsr0470PL8bfN8nSgqzAtjoGY8cDhNCY3VySmdt+Q7nXU8/NHaEzhL5aTiQWHdFuT918+WsKugPHm7ODd7auUa5CXIo8NYaddiVe030zQfTSKaC2O2H7v9CSKcCJyTnKixgM9dulz9Sfr3NXet2Z8qCRsU8wwpNAWIGiMhxnegn52j0XX3S2g4BLNx0JWRGQHtbl3UKR/+QbkpzsFSTkAR7O87Nx/kEMVkyp70Pt4Os4t30Zim7YJJLcMbznPBxK4f6cFwTbZERFadckGIvB6IFikDl9Vkq16+DpvdKC8MznMxGX/OSh1WWB
 uvlOQXPA
 JRo/1zZVgAjJIcPcTJtlBU4ooa/8ZXjgvn19MnfkRNsENdlGXWMLUdbIu/jN9pAr4dy4TfNLCOP1nDrs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch the HugeTLB vmemmap optimization to use the new infrastructure
introduced in the previous patches (specifically, the compound page
support in sparse-vmemmap).

Previously, optimizing bootmem HugeTLB pages required dedicated and
complex pre-initialization logic, such as hugetlb_vmemmap_init_early()
and vmemmap_populate_hvo(). This approach manually handled page mapping
and initialization at a very early stage.

This patch removes all those special-cased functions and simply calls
hugetlb_vmemmap_optimize_bootmem_page() directly from alloc_bootmem().
By explicitly setting the compound page order in the mem_section
(via section_set_order), the generic sparse-vmemmap initialization code
will now automatically handle the shared tail page mapping for these
bootmem pages.

This significantly simplifies the code, eliminates duplicate logic, and
seamlessly integrates bootmem vmemmap optimization with the generic
vmemmap optimization flow.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h     |   3 -
 include/linux/mmzone.h |  13 +++++
 mm/bootmem_info.c      |   5 +-
 mm/hugetlb.c           |   8 ++-
 mm/hugetlb_vmemmap.c   | 121 +++--------------------------------------
 mm/hugetlb_vmemmap.h   |  11 ++--
 mm/sparse-vmemmap.c    |  29 ----------
 7 files changed, 32 insertions(+), 158 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index aa8c05de7585..93e447468131 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4877,9 +4877,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			       struct dev_pagemap *pgmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-int vmemmap_populate_hvo(unsigned long start, unsigned long end,
-			 unsigned int order, struct zone *zone,
-			 unsigned long headsize);
 void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
 			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e4d37492ca63..0bd20efac427 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2250,6 +2250,19 @@ static inline unsigned int section_order(const struct mem_section *section)
 }
 #endif
 
+static inline void section_set_order_pfn_range(unsigned long pfn,
+					       unsigned long nr_pages,
+					       unsigned int order)
+{
+	unsigned long section_nr = pfn_to_section_nr(pfn);
+
+	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
+		return;
+
+	for (int i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
+		section_set_order(__nr_to_section(section_nr + i), order);
+}
+
 static inline bool section_vmemmap_optimizable(const struct mem_section *section)
 {
 	return is_power_of_2(sizeof(struct page)) &&
diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index 3d7675a3ae04..24f45d86ffb3 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -51,9 +51,8 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 	section_nr = pfn_to_section_nr(start_pfn);
 	ms = __nr_to_section(section_nr);
 
-	if (!preinited_vmemmap_section(ms))
-		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
-					     PAGES_PER_SECTION);
+	register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
+				     PAGES_PER_SECTION);
 
 	usage = ms->usage;
 	page = virt_to_page(usage);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a7e0599802cb..dff94ab7040a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3096,6 +3096,7 @@ static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 		 * is not up yet.
 		 */
 		INIT_LIST_HEAD(&m->list);
+		m->hstate = h;
 		if (pfn_range_intersects_zones(listnode, PHYS_PFN(virt_to_phys(m)),
 					       pages_per_huge_page(h))) {
 			VM_BUG_ON(hugetlb_bootmem_page_earlycma(m));
@@ -3103,8 +3104,8 @@ static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 		} else {
 			list_add_tail(&m->list, &huge_boot_pages[listnode]);
 			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+			hugetlb_vmemmap_optimize_bootmem_page(m);
 		}
-		m->hstate = h;
 	}
 
 	return m;
@@ -3283,13 +3284,16 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 					   OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
+		if (hugetlb_bootmem_page_prehvo(m)) {
 			/*
 			 * If pre-HVO was done, just set the
 			 * flag, the HVO code will then skip
 			 * this folio.
 			 */
 			folio_set_hugetlb_vmemmap_optimized(folio);
+			section_set_order_pfn_range(folio_pfn(folio),
+						    pages_per_huge_page(h), 0);
+		}
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 0af528c0e229..8c567b8c67cc 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -638,9 +638,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			epfn = spfn + pages_per_huge_page(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
 					OPTIMIZED_FOLIO_VMEMMAP_SIZE);
-			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
-					&folio->page,
-					OPTIMIZED_FOLIO_VMEMMAP_SIZE);
 			continue;
 		}
 
@@ -706,108 +703,21 @@ void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head
 	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-
-/* Return true of a bootmem allocated HugeTLB page should be pre-HVO-ed */
-static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
-{
-	unsigned long section_size, psize, pmd_vmemmap_size;
-	phys_addr_t paddr;
-
-	if (!READ_ONCE(vmemmap_optimize_enabled))
-		return false;
-
-	if (!hugetlb_vmemmap_optimizable(m->hstate))
-		return false;
-
-	psize = huge_page_size(m->hstate);
-	paddr = virt_to_phys(m);
-
-	/*
-	 * Pre-HVO only works if the bootmem huge page
-	 * is aligned to the section size.
-	 */
-	section_size = (1UL << PA_SECTION_SHIFT);
-	if (!IS_ALIGNED(paddr, section_size) ||
-	    !IS_ALIGNED(psize, section_size))
-		return false;
-
-	/*
-	 * The pre-HVO code does not deal with splitting PMDS,
-	 * so the bootmem page must be aligned to the number
-	 * of base pages that can be mapped with one vmemmap PMD.
-	 */
-	pmd_vmemmap_size = (PMD_SIZE / (sizeof(struct page))) << PAGE_SHIFT;
-	if (!IS_ALIGNED(paddr, pmd_vmemmap_size) ||
-	    !IS_ALIGNED(psize, pmd_vmemmap_size))
-		return false;
-
-	return true;
-}
-
-static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
+void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
-	struct zone *zone;
-	enum zone_type zone_type;
-
-	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-		zone = &NODE_DATA(nid)->node_zones[zone_type];
-		if (zone_spans_pfn(zone, pfn))
-			return zone;
-	}
-
-	return NULL;
-}
-
-/*
- * Initialize memmap section for a gigantic page, HVO-style.
- */
-void __init hugetlb_vmemmap_init_early(int nid)
-{
-	unsigned long psize, paddr, section_size;
-	unsigned long ns, i, pnum, pfn, nr_pages;
-	unsigned long start, end;
-	struct huge_bootmem_page *m = NULL;
-	void *map;
+	struct hstate *h = m->hstate;
+	unsigned long pfn = PHYS_PFN(virt_to_phys(m));
 
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
-	section_size = (1UL << PA_SECTION_SHIFT);
-
-	list_for_each_entry(m, &huge_boot_pages[nid], list) {
-		struct zone *zone;
-
-		if (!vmemmap_should_optimize_bootmem_page(m))
-			continue;
-
-		nr_pages = pages_per_huge_page(m->hstate);
-		psize = nr_pages << PAGE_SHIFT;
-		paddr = virt_to_phys(m);
-		pfn = PHYS_PFN(paddr);
-		map = pfn_to_page(pfn);
-		start = (unsigned long)map;
-		end = start + nr_pages * sizeof(struct page);
-		zone = pfn_to_zone(nid, pfn);
-
-		BUG_ON(vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
-					    zone, OPTIMIZED_FOLIO_VMEMMAP_SIZE));
-		memmap_boot_pages_add(OPTIMIZED_FOLIO_VMEMMAP_PAGES);
-
-		pnum = pfn_to_section_nr(pfn);
-		ns = psize / section_size;
-
-		for (i = 0; i < ns; i++) {
-			sparse_init_early_section(nid, map, pnum,
-					SECTION_IS_VMEMMAP_PREINIT);
-			map += section_map_size();
-			pnum++;
-		}
+	if (!hugetlb_vmemmap_optimizable(h))
+		return;
 
+	section_set_order_pfn_range(pfn, pages_per_huge_page(h), huge_page_order(h));
+	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
 		m->flags |= HUGE_BOOTMEM_HVO;
-	}
 }
-#endif
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	{
@@ -822,27 +732,10 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
-	struct zone *zone;
 
 	/* OPTIMIZED_FOLIO_VMEMMAP_SIZE should cover all used struct pages */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE > OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS);
 
-	for_each_zone(zone) {
-		for (int i = 0; i < NR_OPTIMIZABLE_FOLIO_SIZES; i++) {
-			struct page *tail, *p;
-			unsigned int order;
-
-			tail = zone->vmemmap_tails[i];
-			if (!tail)
-				continue;
-
-			order = i + OPTIMIZABLE_FOLIO_MIN_ORDER;
-			p = page_to_virt(tail);
-			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
-				init_compound_tail(p + j, NULL, order, zone);
-		}
-	}
-
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
 			register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 66e11893d076..ff8e4c6e9833 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -20,10 +20,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-void hugetlb_vmemmap_init_early(int nid);
-#endif
-
+void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
@@ -69,13 +66,13 @@ static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
 {
 }
 
-static inline void hugetlb_vmemmap_init_early(int nid)
+static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
+	return 0;
 }
 
-static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
+static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
-	return 0;
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6522c36aac20..d266bcf45b5c 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -32,7 +32,6 @@
 #include <asm/dma.h>
 #include <asm/tlbflush.h>
 
-#include "hugetlb_vmemmap.h"
 #include "internal.h"
 
 /*
@@ -381,33 +380,6 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	return tail;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
-				       unsigned int order, struct zone *zone,
-				       unsigned long headsize)
-{
-	unsigned long maddr;
-	struct page *tail;
-	pte_t *pte;
-	int node = zone_to_nid(zone);
-
-	tail = vmemmap_get_tail(order, zone);
-	if (!tail)
-		return -ENOMEM;
-
-	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(maddr, node, NULL, -1);
-		if (!pte)
-			return -ENOMEM;
-	}
-
-	/*
-	 * Reuse the last page struct page mapped above for the rest.
-	 */
-	return vmemmap_populate_range(maddr, end, node, NULL, page_to_pfn(tail));
-}
-#endif
-
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
 {
@@ -595,7 +567,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
  */
 void __init sparse_vmemmap_init_nid_early(int nid)
 {
-	hugetlb_vmemmap_init_early(nid);
 }
 #endif
 
-- 
2.20.1


