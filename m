Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BD7C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BF4A6B009F; Fri, 11 Sep 2026 01:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5491C6B00A0; Fri, 11 Sep 2026 01:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E616B00A2; Fri, 11 Sep 2026 01:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3C456B009F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:04:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DECE40702
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:14 +0000 (UTC)
X-FDA: 85200290028.27.D78ACE8
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4DB5E40003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=X0GKjGus;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103052;
	b=u0S7ySo8CLDvMFJhKQ5LlsyKaApeJab++7FbwgNyBIdNtIK0zBhVcutGq7BLYRpjDTCXKQ
	ZnVo/3Cwdg5JHvWhxj4DKAZhs+V7VCMD2wCnRbN1WkP1p7S9ZBN3MhbmK5x1dmZU1ROqHx
	oYjMHrHRKPnsX2PK6pCviGkH8/IAtrU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=X0GKjGus;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZbZ6WC7vZbHjIhgnid+8T29mCn5dRvITTk6eMnH6Vk=;
	b=71fRCL7mpq+SuuRi5/DfNt+P8aHJMgfZQoN7IBsGpTEIa2hp12/2kIHqcuDivMLNtu5Qp6
	wHlQmCgrcIfu7KyOG1ajRDuWlQS/2pkMS3Swlsxbvq5fUkW1tsDKdj/vIulI84M0ZLb75V
	m03N469ephAG8+Kn55FIjxQLdhc1z3E=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2dd020a2e44so4696445ad.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103050; x=1789707850; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TZbZ6WC7vZbHjIhgnid+8T29mCn5dRvITTk6eMnH6Vk=;
        b=X0GKjGus0ZXr8qjKY1K5a9j1b9Rlqmgi5Y7i0dif5/o0pYnpXv+VMQOrNRwRN69iOr
         BAGuRfgWg+p41Mw7wg5SkvAC8jWPZ7075iD2qboTiwYl/G2HWXrCQKYTrS3fe3RhV3UX
         aMuMjUAR0B+6WCI6TlcrgQSckGrRhlCVLh+Ud+PnV2LeNsmbltg1Yy8dbJpRznu2YDAy
         ZoGZfMJjIApGlT73JF+X73jKKcO1yC37xFBGkNVVBLCXiYzx5hg/mjH1dc6HDRwvoQFM
         l+hoZ0LX9JZSWeu55970X2qglzbDMd66hv+D5eeJosM5WYrqGC9et5DOLHT2uYhMKKXk
         JdpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103050; x=1789707850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TZbZ6WC7vZbHjIhgnid+8T29mCn5dRvITTk6eMnH6Vk=;
        b=pVAwmA2aU/DwqDgfHehqLyiUL6y2hTJFTm8ugfw/26pTDOE9o1LU28uVp78+uJEtuj
         sqxQq1YomMmHDDDWqXEvyBaPD6Lp8dnKO3qzWbUjcS7f9pu5DLwu0lL+Kfzq5942b/BB
         vPWmiKOac5cU5E/jeqHAzQ7uDFgmhM6IX8od03ldrHDQIl+P4EWHiNreWm8A5kUMBJ0h
         v93ZngPF5Gtb7ozCXQGbeUYHYSzOiQBQg/QxavhqFm63hfAdYylTgXpkdO3ML9MF6N7t
         RUJ2GFRad+cBafLY6lgztkT02zYYL4STkZy4XBwl2D1CjVczaAn1UiRxAzoK/Z1IgEgg
         dKOA==
X-Gm-Message-State: AFuF++lzrjfj+2GdX38D3Bzydadi9fo4e9CuC6HBhH4ToyEEOKo4UF56
	J9WVKRcG9LDxyrdqi7Z69MbQDadlap2mK+w6lnV2IxaxSIDj148de99unYGqmIYJm/8=
X-Gm-Gg: AYBFou0db78DrelLvRMFZXO8ia12v/xYpscZJFbtl40JSLeRK/sa8pXFSJ+AHY4yQkF
	XQIVJk4ZyHXQ2Fruk/6qGJgDsDRvGefOqsvsfgQ0hOAsl/9oRm/GdgaFmqdCmsC0/4U9p5hZWyI
	C5FEf7JLoredib8keg8mWxNVKPPvXPmRYGoHWgnO5G0MdtGe6LfjBrHiI5m4iPXY08gD8ml4RHP
	uQ0EeLoAblGB6F8hTdXkdnvkuqXz7f1oyoMonOYjXd6n9iQmCsoq0v97k5aPcFHvP3tNHt0R9kN
	zhOA0ya13kBJFzEWj1xHZ2xGCg91kmbQ7SdpNxCX9mYCdL2Q1hbqyBrpkpYYAris1UHGmyLsAdf
	5A3iGe86Xo5HLicIv1A9FVrBpBTBu0xNWpghuQEMCCU60wUBky+63EX/rTAC6Ws3MYQ5LFCTcHS
	hg3DCD7PhZNOdR/xoeIJNhyJityMjJdHZiOcnglLgRgRepoKP4r7JirLRRkMgC9yiEdqzSUirT/
	wsfeE+FJ6sisNAfVERHWWPhhEThOPkOs1Bw
X-Received: by 2002:a17:90a:fc48:b0:39a:e983:d4bd with SMTP id 98e67ed59e1d1-39d9c3527b5mr3643408a91.24.1789103045863;
        Thu, 10 Sep 2026 22:04:05 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.04.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:04:05 -0700 (PDT)
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
Subject: [PATCH v3 08/11] powerpc/mm: switch device DAX to shared tail vmemmap pages
Date: Fri, 11 Sep 2026 13:02:25 +0800
Message-ID: <20260911050228.58884-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4DB5E40003
X-Stat-Signature: iofy5c7xho8hnz5jkp63ckdshio1gj49
X-Rspam-User: 
X-HE-Tag: 1789103052-256660
X-HE-Meta: U2FsdGVkX183RFrNqF8yYFQH9jA2Zhh0JAmaqCTR9vLGGplit3vNoHlTWPNOWov0/yPJsuYLn6GzxyTk9m0yWw4Y2Jt1mxCaJsSWxItWw+KNf5me/71pfW1vJjoCLktNLzRhrGcl/cdI/lVdHYIzsO8SM0tIc90d5ZB4lBcgjmQeEB6cAIvFAqbvUbsLPiyIw0xsB+XTFw1gee9efersYoqcRCFSv6qaB4sBb2zefGHO1s6p8G1Co3vSO0ufogBYW9DZjX94oNuVJktl07rHdViaOmtBQUeYvdgZh5MPgYNUnXU5+FKiD+daDm3LQLCFTikUG/BvCjh8fyq4tftt2tS6tq//x/kHE21HHfOWUiKP/ysjBGA8yPwdsiGJ+mbZzBhHrw7Tsl6vEfOdX8w0SGOnX2akKh8mTVFHmZY9ydK4RfQhWDROijLaumPxG9+W7ud8xfpPSSZBjoxxlEUVn2qlldd+D97UUQYLoPqnpAetY1bcJPlwkAZlwmuib1e3H4UgAo5eQgcP0FuFSx9A4MdH7iFlKzftmQZ69gtiyyK1Idm40lome5X9MI2Ow8sab7FDaw+IcaUlXMuotASj2C8T7LqTKYTQZL5UhpM3vGiEjDK/RZEymuVd/wagJ8dqO5MNfo67OjRDJptNETx6B/r3U7spZWFEBwkMUeD7C+Gg3XSiNGZz5UtGcW68L6CUL2y3kbBGdvaaGW1AHAkp0zMS0xJWljCS4/JEqZm/6OV8yTfbCSSPvXc56L5Ef229MmyeLbNcrF2G/K5c2j33gIvjzGHuTTgSPRcnhUg2/WTbKKy3HlXboUWG3/jrz3gftLnZuf2rq2r4YQI0GtnejCok1dr4UA3zfYGW3hrpg3bZIiLkv0I63zla3j9SQJzu4LbG2NZ+KsRnRfph+F4G+2tqDEy5mcB9ZYEd0OrKzrjb2JZ3DfFlJR0Pml5NLT4PFTKNNekUR68Xic89jEv
 BItHEO2f
 48TdQJ/pytIqoxJYTcAvlb/6CedwOIBUPnH65lAMuPiGaaZj/iqVIvlY6jVTnsJvbxsuzgT+mMMjxZxjAnWtsFWkcH4EOpQWbOFrApLWElmLCc3hyJa9OKDlhsYA4LM/7bZ++m2ThNuRu7ueazdpifmxwZ/LbxwQk5SW+5posOnOoYDeMbdiPbz+n7ly3zzerpLcjJaqkUpSFAA0XVpLFEXxoELFQymSWa9D6haZO/sT7V8DezBpwpREqGykY+PY509e4grpAgaXICwmVMV/pqLb8f4hiv/iuTHVPYHGRZdYg7GQm2sDF5v1UJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The powerpc radix compound vmemmap population path still finds a reusable
tail page by walking the vmemmap page tables.

Switch it to the common vmemmap_shared_tail_page() helper instead, so it
can use the shared vmemmap page directly to simplify the code.

This removes the powerpc-specific tail-page lookup and its fallback path
and aligns the device DAX vmemmap optimization path with HugeTLB.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 80 +++---------------------
 1 file changed, 9 insertions(+), 71 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index cf692b2b5f7b..ee068f24a79f 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -19,6 +19,7 @@
 #include <linux/string_helpers.h>
 #include <linux/memory.h>
 #include <linux/kfence.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
@@ -1250,59 +1251,6 @@ static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int
 	return pte;
 }
 
-static pte_t * __meminit vmemmap_compound_tail_page(unsigned long addr,
-						    unsigned long pfn_offset, int node)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	unsigned long map_addr;
-
-	/* the second vmemmap page which we use for duplication */
-	map_addr = addr - pfn_offset * sizeof(struct page) + PAGE_SIZE;
-	pgd = pgd_offset_k(map_addr);
-	p4d = p4d_offset(pgd, map_addr);
-	pud = vmemmap_pud_alloc(p4d, node, map_addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, map_addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, map_addr);
-	if (!pte)
-		return NULL;
-	/*
-	 * Check if there exist a mapping to the left
-	 */
-	if (pte_none(*pte)) {
-		/*
-		 * Populate the head page vmemmap page.
-		 * It can fall in different pmd, hence
-		 * vmemmap_populate_address()
-		 */
-		pte = radix__vmemmap_populate_address(map_addr - PAGE_SIZE, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		/*
-		 * Populate the tail pages vmemmap page
-		 */
-		pte = radix__vmemmap_pte_populate(pmd, map_addr, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		vmemmap_verify(pte, node, map_addr, map_addr + PAGE_SIZE);
-		return pte;
-	}
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1320,6 +1268,12 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	struct page *tail_page;
+	unsigned int order = pfn_to_section_compound_order(start_pfn);
+
+	tail_page = vmemmap_shared_tail_page(order, device_zone(node));
+	if (!tail_page)
+		return -ENOMEM;
 
 	for (addr = start; addr < end; addr = next) {
 
@@ -1349,10 +1303,9 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			next = addr + PAGE_SIZE;
 			continue;
 		} else {
-			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+			unsigned long nr_pages = 1UL << order;
 			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
-			pte_t *tail_page_pte;
 
 			/*
 			 * if the address is aligned to huge page size it is the
@@ -1377,23 +1330,8 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 				next = addr + 2 * PAGE_SIZE;
 				continue;
 			}
-			/*
-			 * get the 2nd mapping details
-			 * Also create it if that doesn't exist
-			 */
-			tail_page_pte = vmemmap_compound_tail_page(addr, pfn_offset, node);
-			if (!tail_page_pte) {
-
-				pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-				next = addr + PAGE_SIZE;
-				continue;
-			}
 
-			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, pte_page(*tail_page_pte));
+			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, tail_page);
 			if (!pte)
 				return -ENOMEM;
 			vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-- 
2.54.0


