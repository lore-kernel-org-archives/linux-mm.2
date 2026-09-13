Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E32B9C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 08:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27986B008C; Sun, 13 Sep 2026 04:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFFE96B0092; Sun, 13 Sep 2026 04:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16BD6B0093; Sun, 13 Sep 2026 04:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92CD96B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:40:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AE7F16061A
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:40:29 +0000 (UTC)
X-FDA: 85208092578.28.0A745AD
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id 27D6940002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:40:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CjItJOHn;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789288827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFsIa9cK+8+fehtCpbOiW01jVXax8X3u6/tt3T4Yifc=;
	b=4CfG65Pgaotmw8XgQeF0dxrntl2yYZDZQyuinm+PnVGBsi726ldE+w82mQ8DxMZFCGZ/Fe
	GpwR8gM4ZtklsIeT2csUdvxUq/mBgWPAGPFOuOvCDDnGWTobbBYCc4cAh4SQ6AqI0oocPg
	mbltuSMG46HQLxrir7jXmlcwwdNuqJw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CjItJOHn;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789288827;
	b=GblAkxNwQuH8iOl5hRriRxOsOsEwE7z87MuS5BkIvGQQjraObDVt/8my6qh5/BGlI5ztvA
	fVsSYr1ObzDzaR+p2I0Cp33fyMEO1zmi5COtDsw48TW2n3riiayjfr5hqoleV/nLSDpYKK
	wljdDxaM+IzzQaLKmBxW0+pD+Q8zbCw=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b2e1d5so1293392b3a.1
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 01:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789288826; x=1789893626; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eFsIa9cK+8+fehtCpbOiW01jVXax8X3u6/tt3T4Yifc=;
        b=CjItJOHnupu9sKKUWEt9rt5OSsSba/LWrEcH0YTPxrq8a1Ij5ipmFCBNZSXCEqwUps
         7mmTk7ye8vFJxJYIGyv3E4u8mQAoiO5rkuMS2HcLk2nEsmc5gZOEhCINJZ5AVgeGfmCQ
         OuwCgcXJkeYaSf7P508h3XfuV5FFlORvy2A6jiCVuwFC1jtvs2aGrlKAZjMmySrxcHiH
         RYVv883BnD4pgKzL0EyHfHJEqsf/WVyAquYbxNH36AnVYHVBNC7/mrFIOb4DW8tIbLGK
         WYABgdnXsME79IA4RPEltZMiFjz8WRnD2WntvqpYo3mremfDyy0cHRMHAtVR2sUC92BT
         ULng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789288826; x=1789893626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eFsIa9cK+8+fehtCpbOiW01jVXax8X3u6/tt3T4Yifc=;
        b=V0I1bcdAi+hltvAd7ZSMcG95vl8zLCWIAf3HOtERfrLv+hnnaLjjTKLkFlmQMUI+3g
         hRtHNdNhCFZEekX6ifqVE1UmQcvhc5nU2HmDaExtutAZQAMosAYEh5nKpfqpyYScEwzu
         0E75SZIwMdvnH5rWH2+ubINakIgCZ0NACFKzKc4eVWQ4IKKhK5OC56bdJMBFJmt+7dxu
         gHKJ6RvoAOnDzWXu/C9F8oicSMClXwU4//JRF0h755+bpufZpO+a1FIbLC8u/3tvDbzR
         5hRZ1NynE7j7wZKV6MH4RSD34kApuPQWHVI/qd0gGm1oOp5FiD71VN9P+wa7gCvKoork
         ltzQ==
X-Forwarded-Encrypted: i=1; AKwUvBzx6RRVLjQzswOkSHxuMfzHq9y6VhCcbq7kpDT6t+sN+7verSRTtTqQIYeUihvdkVQ4QO++ci8ppw==@kvack.org
X-Gm-Message-State: AFuF++m9umswz/DfvBXReElKFh8l0VMCq6E9udmWz1+qq6tTpAFrtwtn
	0ChnVjjbstFC1ofw3HIUpdVs2N9rqNjc22kn5bddfi4e+T2gWTcFF1hvTyaTypDOXfk=
X-Gm-Gg: AYBFou2Bdx91vwwmFQle+jCfnWzYMR5gac7zjv5k3SqV23LCifN6EYB3foHmA0hTqmZ
	DL3gQUWWUolO2+WUVisViWAqf3gLO4A8NOgPLQ2RIJY6o4GHF+mjqsgSegYN5l63WSB4yb5rqoA
	0nH0VjiSxjYVF5nr3Ra7R3q6oLTe8+nFXCJjksiEqY4uaXzJAZ5kCjHBnR7FrrcOH6SaOfUkBs4
	U9gWE/GwCyLzmaXOjlv1dD9T6QATEY9BkGck2B18y0F08cp0Zjgg9knrVf6Af7fCKUCaZjGKToe
	e/P2sVOdo+5ZxRvA2HALiRvmG5PYVNoTvvxLhzoCdeVXp38UEFXTb60omQ3zpsgMWFPBnxSGayD
	Jh2GjELrp+mykehQ6dXArkxm8oN3YeNNMm5+jQAT772g6w6AXNdXNE5zrbxHIJn6JI9nW2tKL2v
	BcCbg7yHdAZVGFdUZvPcxuLJjUtVzUsEgRkqWEQM9isNubwwILIlFxlnHiFpL/+SzcGyLtChHgc
	CPK6FQbRBm34NHV+/o/kB0F7+g=
X-Received: by 2002:a05:6a00:148d:b0:848:6c9c:4074 with SMTP id d2e1a72fcca58-86b30413328mr18406280b3a.1.1789288825870;
        Sun, 13 Sep 2026 01:40:25 -0700 (PDT)
Received: from G6L4RL2QG9 ([2409:8a00:1832:cf0:5137:990:100e:cc7e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29cbb0d3sm3070531b3a.42.2026.09.13.01.40.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 01:40:25 -0700 (PDT)
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
Subject: [PATCH 1/6] mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
Date: Sun, 13 Sep 2026 16:37:29 +0800
Message-ID: <20260913083734.86802-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913083734.86802-1-songmuchun@bytedance.com>
References: <20260913083734.86802-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27D6940002
X-Stat-Signature: 1fbxaopsximb1y8amobb3jr1oq4w5z7w
X-Rspam-User: 
X-HE-Tag: 1789288826-516937
X-HE-Meta: U2FsdGVkX18PIFkxD8RVhk9h/mWcrQqcsJTiyIigwQa/sZMLd/yedH2EozGRa4co3hTlaw6IeYmGydQv3EUO3trN/V7MpXf9ar3DVYy9qdwdAYqhE9pSZAR1cGXeMluIXVPKlXxNRluNlt8zCt0atdg1qic+IoNfoPVTPHvkumbf8QPaH3nod1F5tOvhe6jylp6/3RJ19Wm9bNE47EVM4M6jX49xhRQtsKKcIz0zAFIvnaJKwuHTuBz+Vee6tG5pZZezSLKXHttcH2rTL2PNbWfRqgKmyN1mdv/Y9SHZaU+0YKxYFLh5SQ9tG8zbCj4xU9+4i5fBhGzQF62nOO9kWeUOQzgdZl9CREmSMP7apmk4RRM3oXFIGNKpwb/1dfssrGiu5nGryKTT4zgDKzcnN0rkzX0Jy9a+466fKnAtps7Fk5iuuMNKhEWTCECLE1J27KxBa8h++wvBnTB71FT0884RzFCyc6mYD3W1vk7LhX8navdaNmYsHaINYqJFw/1paeCsT1JrgEH6gSWPJBYBn6KUso2PXDTgNKLWiLL+OCviC230GXqGQChGI9ebKs10Zvz+7hTBe+3F7E8C/cAARrMqrmeY/Tv67sZ1FpaFxsR2M6KPG/VQpxemFz2a2zMNmMbVPdpzHQdZbG3rAaX5+swSR4lC7Yyh7hxReMBcSsJzUkZiD/BCqjzNQqZeuZGrExohYGbsKSkVf/ExSYe7gaDEhacQHwBS8MK4MsYTfXksontY6nncWWUhj8PmkChm6K9bmRHIX8CPEEKqlrOhJNxcv3OBUvLSi8tf1n/JRkWVnpklaFzL4U2U7p1KaWo/WR+DjtB8jCnZI+pAIVp0grKnwhCbNzcAJeT6N6BeJtZiol/Iv8dsbF4E9/z3ahd7aykgKDS98W+gMwq+DqV2Fh1DqXc2Tm3SufqKo3j1L7Y5E0m7VmIFiEZkV8UPAyURf2jen0wa5GEzIosLrYL
 nrumqKZi
 EwPFN7M6Hl++F77Z1G09A6IC6pfm5NfwPYdz3BE+VZ0tJTw05A4QssTBeyqd4/+wdvzji/345dLdnLRCu+UiYlttHgPV5j1BPGDeA6E8R//+y1OtErOmuG+2qKL/0jMGSvrCydLYvkemSsqanZxuXxZzbYd1lFtj5ERxgH1vVAkWy3EYbOE20LcpCL4VUWUqvH/VlOmdILvU4V6ZeTmsyEfVuL0GRPWLlxdlcduhjm0E+EtHGCpHvT5npBrqcmS7dTyHV8+Ae6f6c4GMjK8kVUlf0O07hZrYN8YN+cj43SHJCQwRjvOzu9apR7eQ4haVAxMTyQPbE3E9qxg5IIjKGL4Ppk0Y0+5oJrPndK/acNDH+Iyk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VMEMMAP_POPULATE_DAX currently distinguishes DAX vmemmap population in two
places: it keeps allocations on the normal path and takes a reference when
a backing page is supplied for reuse.

After Device DAX switched to the common per-zone shared tail page, both
conditions can be determined locally. DAX supplies ptpfn for every shared
tail mapping and requests an allocation only for compound head mappings,
whose PFNs are not optimizable. Therefore, vmemmap_optimizable_pfn() alone
selects the correct allocation path.

When ptpfn is supplied, the caller is reusing an existing backing page.
Once the slab allocator is available, take a reference for each reused
mapping to balance the release performed by vmemmap_free(). Early mappings
are backed by memblock/reserved memory and do not need page reference
accounting.

Remove VMEMMAP_POPULATE_DAX and the flags argument from the vmemmap
population helpers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 96506f594924..878d29a4e862 100644
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
@@ -208,7 +202,7 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 }
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-		struct vmem_altmap *altmap, unsigned long flags)
+		struct vmem_altmap *altmap)
 {
 	struct zone *zone;
 	struct page *page;
@@ -218,7 +212,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	 * Device DAX still relies on vmemmap_populate_compound_pages() for
 	 * head/first-tail allocation and tail-page reuse.
 	 */
-	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
+	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
@@ -230,8 +224,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap,
-				       unsigned long ptpfn, unsigned long flags)
+		struct vmem_altmap *altmap, unsigned long ptpfn)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -240,7 +233,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
 			if (!p)
 				return NULL;
@@ -255,7 +248,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_DAX)
+			if (slab_is_available())
 				get_page(pfn_to_page(ptpfn));
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
@@ -318,8 +311,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn,
-					      unsigned long flags)
+					      unsigned long ptpfn)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -339,7 +331,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn, flags);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -350,15 +342,14 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
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
@@ -369,7 +360,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
+	return vmemmap_populate_range(start, end, node, altmap, -1);
 }
 
 /*
@@ -498,7 +489,6 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
-	unsigned long flags = VMEMMAP_POPULATE_DAX;
 	struct page *page;
 	unsigned int order = pfn_to_section_compound_order(start_pfn);
 
@@ -508,14 +498,14 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 
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
 
@@ -525,7 +515,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
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


