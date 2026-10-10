Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7248CCA9EC0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 07:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F20F6B008C; Sat, 10 Oct 2026 03:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3526B0095; Sat, 10 Oct 2026 03:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392E66B0096; Sat, 10 Oct 2026 03:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09DC26B008C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:58:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C5E5A0613
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:58:37 +0000 (UTC)
X-FDA: 85305964674.04.F22B15A
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id C41D3140007
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:58:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DkaTKilu;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791619115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mkGffN6L6o3olbDL65GC0/HySqZZtRBE5Le50XaNNq4=;
	b=ZdYatdH0mPJMM16fPgKTXSGb/VsLRzbe4FH0Vexe93VX7s1JsELlP4SaaAS3oF6TdEqQ+R
	ikYKNKQGM2VUbHTIR5uz3MUBXG2HS75vawMLtFrVLMWxTC3RcALXikz0Tc48JxbqaXXQ6B
	nfhNqu2XubWKPEVRR4CJT4AfthoKJXk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DkaTKilu;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791619115;
	b=xVKfmN99hednQ9/ktdk7Xgd3g51EuOnksc1Gj8y20A0TJi/EeQeRndrqVbzoka4xMuwXpS
	fdLXG536OST0ceaACIQa7XLyu4D7puCVPGimyiMbRI79P0V3O+XZmWhMJQYAPFbL4QHb7i
	gwGu2Nax2/ALmqcfURvo5RANhr8N62k=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-ccc7a6070b4so160787a12.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791619112; x=1792223912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mkGffN6L6o3olbDL65GC0/HySqZZtRBE5Le50XaNNq4=;
        b=DkaTKiluCLyL5AsfLVCEq72CFZqtkNBhPiJT+PqE/3hQji1BjiV0ZFtzPLH2tHtoxE
         ya0ZlLKZPNzelGmNpSl80bQhoPyOsNQ17K08HNW2zPf5Um1lOrmtc9e47RoXo9/1pHSK
         L4CYTYSQBuh+EO7AXSSUbjdUmWctV06v5is2nbNZagBMsx+qctMYJUk633iDICGdaiGd
         IqLdS6Sk+woOuTiZ9rKHmAOBCNpP39IDGQuRaVfYAjdbcn/pdtz9pNpENTYxDRrrmLkb
         hzgunO9tYkHpFMEILco/s08adz9AGIDb2/isEofAyX0NMiEnOzBe6uUbnwRBP9zo6qpj
         22lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791619112; x=1792223912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mkGffN6L6o3olbDL65GC0/HySqZZtRBE5Le50XaNNq4=;
        b=LNWvCRLMuqhwSLZ7nqPU22sDwSCVUEBjKF5f9as88sP9gM4LYyB0tKqZ7ZZ8lR6jv4
         05uY57N0EP+xT7ljQNrxUicJCgxwKTuuWff30+2qbqpyoVp7etN7OeYfnyh9St9ObyTk
         KdkVzo13dlYjrpEpYEatnCLH150NsMKmg5yizRYePkHrd7QeO7zNK1tHvtW+KcatMvm5
         bVnTIak1+8BVMLRHuOsKT7MvJyUwQ66U6gduNSBIWU3OntZWqGCCLi+mWX5gyDv73xGA
         KX512pL0aCi+Ypce0CpW5EH7zH4N/P6YjYZZkw6C4LdUWtCsBe+rBHf3fq2/R6YVk05J
         27+g==
X-Forwarded-Encrypted: i=1; AKwUvBwVeLURaU32uAD9TXthpHxSp2pXereAYPzZ+bzx2lPwSQd9++k1dhWm4OHNnhKMq1Zugt/H/dsHCw==@kvack.org
X-Gm-Message-State: AFq9FYKgwBWuIEKEHSjpwrrqDMTH1gMOedaxSNHFn/6LcAH71Xode1RM
	3zhcmiSkpep8qNAXMrDxNckQGiT9b11ZdnllIWCM+5uWs5XDIILKy4+314dbc1Kkd3E=
X-Gm-Gg: AYBFou2K9BVg9nxxvTB1LA9ntx3CiozTRsefQLYCCniIR+KxmTi2w6QXLbVf0FpTSKZ
	4MDjViU6Skuov4HH3E+ahO4V0+ryOvty0f5OVRjYKSBoqeeaIAUPqGcN4W/gP8eFiVFFXlf2p1D
	/T65xNFCfRPknOUml2Ks8g/5N7pdLtCqa5lfLKkoW0QjlvjnBnUxpMOLQoOgDgvF2m3Y1SJosGt
	24jOvsJM2xiSRwm/bacHM2pJHTJq92PNu5Y/ir3FStlHzUDQgJC7QvZtIRjr8wrNnHAhLjPKNv4
	0O4RNn9haLGIn1OK4ZBmGG2QxWwRkAEVZsX/pr6yY1x/61cZQN7EpFI4KpIqPUHlD1FYqD5mu9d
	tmFpan9sfpO9yXUkciIkUsiOqMlnUZuJzbgtHaFg7TTI68py5G6HhpL708E6pSgUXNEfUZm8m9y
	wqCya2IggjKr/wCqT96Et/MQtMj5guV6Gr25rjS7L1iW+PhYIlU2fcm4tQtowlXPe8CksfoqMlP
	NOyW0X9y/H3IZTSz//WvHpDqhiIbOH2dsK6DA==
X-Received: by 2002:a17:90b:2e4b:b0:3a8:195f:186 with SMTP id 98e67ed59e1d1-3ab3a9fc457mr3160126a91.42.1791619111478;
        Sat, 10 Oct 2026 00:58:31 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab57c05724sm3473569a91.4.2026.10.10.00.58.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 00:58:31 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v4 1/6] mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
Date: Sat, 10 Oct 2026 15:57:50 +0800
Message-ID: <20261010075755.83339-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010075755.83339-1-songmuchun@bytedance.com>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C41D3140007
X-Stat-Signature: 7w9g9cnb9phxqijhzzhhezdncqi5u6nk
X-HE-Tag: 1791619113-715176
X-HE-Meta: U2FsdGVkX199Pauv/b33nbJF+QsqPmEoXL8U97bYmeXErGn2+/G1milKv6w+gT0b9NQ0nAQJKekqLQal6S8ocwgFVn0ograpP340zZKaaYoNcOx/wukmSfaEZxoezQWbg9LP3bGEziArM8CDBlsPNx+7mD1tXzgsGhyG+QiDSLD3ZKJgrA9w/rkfbVT8slGiytMrEUpUEBORV8A61K6nf5XhM0FoE+u3c5Bqbeo6xR1gCmKmdpn7B9W4iaLSOqlsZkQEjNkBDBXs9sz7CccbSZHYzvzSdWsvMdHP3AL5F+ctdLuewMncgfV/JjrngXtQzt4hF39OgMo+NC4nrBcjc0ccylL4c6TjlTH760USm0hlciMgPYw7k2hBWaBn5hs6wR5uABL1mAbZBPf06Lj4i+f4O480TLcZ2XeQXiQ8vJoAyLXOWLupWCR0/vTgGpz6Z5OMZkd5ogF1lQpIQb8yHoIvFwb0QHzFmT4cjJ95eeiXapzNgl821cznz9NxjW4ejg1Yf1vWfIwR5yN15x7mxohM/PDyR6tE3/AlT5KsfHTDHRXBt4rAq/c09vVJXK1vEa2t7EOv2qxnQRY8fSxD5cQyr92QPm1A2ZxZvOlL9mODOrr6oMuopbspy5k9sALbgf5z8oVwoBxjnwWBF8l9iMurMXVs+vS7hNsaxN0Z9qwwH7H4iOdgclYL4N0VW/KBxSc2SuFUmHobdI82l8ca2E9w0xBWSvVBBv13Haj07++wMXnqDpSw5OnRdd4PZYbFmo3+HN8fEWDKWKFW6GNYQVgldC95b2KqrwY91aLPV421kFdouvXOWOIBZA0Oy1bDr1a4Xozsr/Wx3NU+FKLQq8TzuP+KI1xE/jmw3/a84XLHpntbuF5MFBnGhF/KTZoS/SZWanLjx3egMvIA1/Y9PCTFzGsgunken4n2thAI8OOVuTPIZGIDLIbVW/+pyZC5XWIZLE3vLoxTtDJ0D+9
 CdbTAC6C
 CWGMFEA4UCaWM9WpWkcRV55lvnBqwVXUr7F0YnaMyGCWFRN9OF85iPqAkHsCh/Ty4x/nwqDnuSaGnX5UDlk51Ko5wWyf0wNEIYkOaJlzgHwJgAFhjfzP6B4dgDiARR4sS5oLODXIPPUO9A0M0UJcAzW/90zXA2aeVPEGm+Bo4wPZ4G0q+Os69X+vQMNYe2Fqa2WJlVTCLzR/ebtXW8Oubfh8yC8Z+YDjpIA518Hs8AsQxT7zV+KwyPQkdhBGEEVocMPu2kVfx2s/8YY6TMlJxWTbg6HVozoj2oidbi3Od6doND7TKNQ7b5szhSp4pLdBtJ8EvtuFuUuHxST5r+SvbdThJXPNd+m6DIFxYFBaHtpnfkp9Z2RIR+9ukuk3Kyjnf0y1nfDLhTIrUd4dvrkwuuKqj5vfUQ++p8uDonkgyxS42JsqEakN7NrqX9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VMEMMAP_POPULATE_DAX currently distinguishes DAX vmemmap population in
two places: it keeps allocations on the normal path and takes a reference
when a backing page is supplied for reuse.

After Device DAX switched to the common per-zone shared tail page, both
conditions can be determined locally. DAX supplies ptpfn for every shared
tail mapping and requests an allocation only for compound head mappings,
whose PFNs are not optimizable. Therefore, vmemmap_optimizable_pfn() alone
selects the correct allocation path.

When ptpfn is supplied, the caller is reusing an existing backing page.
Once the slab allocator is available, take a reference for each reused
mapping to balance the release performed by vmemmap_free(). Although the
buddy allocator is available before slab, no vmemmap population occurs in
that interval. Earlier mappings are backed by memblock/reserved memory and
do not need page reference accounting.

Remove VMEMMAP_POPULATE_DAX and the flags argument from the vmemmap
population helpers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v4:
- Collect Reviewed-by from Lance Yang

v2:
- Explain why the buddy-to-slab initialization gap is safe (suggested by
  Qi Zheng)
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 098975861523..b23efff80137 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -32,12 +32,6 @@
 #include <asm/dma.h>
 #include <asm/tlbflush.h>
 
-/*
- * Flags for vmemmap_populate_range and friends.
- */
-/* Vmemmap population for ZONE_DEVICE compound pages */
-#define VMEMMAP_POPULATE_DAX		0x0001
-
 #include "internal.h"
 #include "mm_init.h"
 #include "sparse.h"
@@ -241,7 +235,7 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 #endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-		struct vmem_altmap *altmap, unsigned long flags)
+		struct vmem_altmap *altmap)
 {
 	struct zone *zone;
 	struct page *page;
@@ -251,7 +245,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	 * Device DAX still relies on vmemmap_populate_compound_pages() for
 	 * head/first-tail allocation and tail-page reuse.
 	 */
-	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
+	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
@@ -263,8 +257,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap,
-				       unsigned long ptpfn, unsigned long flags)
+		struct vmem_altmap *altmap, unsigned long ptpfn)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -273,7 +266,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
 			if (!p)
 				return NULL;
@@ -291,7 +284,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * Use try_get_page() to prevent the shared page refcount
 			 * from overflowing.
 			 */
-			if ((flags & VMEMMAP_POPULATE_DAX) &&
+			if (slab_is_available() &&
 			    !try_get_page(pfn_to_page(ptpfn)))
 				return NULL;
 		}
@@ -355,8 +348,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn,
-					      unsigned long flags)
+					      unsigned long ptpfn)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -376,7 +368,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn, flags);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -387,15 +379,14 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
 					    struct vmem_altmap *altmap,
-					    unsigned long ptpfn,
-					    unsigned long flags)
+					    unsigned long ptpfn)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
 		pte = vmemmap_populate_address(addr, node, altmap,
-					       ptpfn, flags);
+					       ptpfn);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -406,7 +397,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
+	return vmemmap_populate_range(start, end, node, altmap, -1);
 }
 
 /*
@@ -532,7 +523,6 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
 {
-	const unsigned long flags = VMEMMAP_POPULATE_DAX;
 	const unsigned int order = pfn_to_section_compound_order(start_pfn);
 	unsigned long size, addr;
 	pte_t *pte;
@@ -545,14 +535,14 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 
 	if (reuse_compound_section(start_pfn, pgmap))
 		return vmemmap_populate_range(start, end, node, NULL,
-					      page_to_pfn(page), flags);
+					      page_to_pfn(page));
 
 	size = min(end - start, (1UL << order) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
 		unsigned long next, last = addr + size;
 
 		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1, flags);
+		pte = vmemmap_populate_address(addr, node, NULL, -1);
 		if (!pte)
 			return -ENOMEM;
 
@@ -562,7 +552,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 */
 		next = addr + PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    page_to_pfn(page), flags);
+					    page_to_pfn(page));
 		if (rc)
 			return -ENOMEM;
 	}
-- 
2.54.0


