Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B86DC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A266B00A0; Mon, 31 Aug 2026 03:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BA866B00A1; Mon, 31 Aug 2026 03:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9526B00A2; Mon, 31 Aug 2026 03:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2A76B00A0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:55:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D11D71A037D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:55:12 +0000 (UTC)
X-FDA: 85160804064.02.F2C308F
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BAB5C0008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:55:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Pn3h1dyq;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162911;
	b=W5z6a5NHIC2r06QM61qwz0cgcNOBa7Kcp1PepS8L/rVDvcf1+H7z6CGaueH/Su9xfcQUS5
	XB+tbkPgek6xnqXi1BF1X1PsaGbTUpIjaSaGt2xyB64IdFB4cWCGIFbv9S9+W/3M2fNxjH
	X7qCHFreNZXtmFUvFJF45EI1o93Ks2E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Pn3h1dyq;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tkr6D1mJkSgu6ygeW9vA9keYBBS8zHk8hkf8RCBkSI=;
	b=YYaTOEjsXW3CRStlIMidvZmRNlTrvLtBv7WHtKziXcEYq4u5go3B2nz+VdENywedNkr6sy
	9x0bVrbLenw4+Pii8/BaPjIpfDvVEFQ+LDi73kz8NAmw1jY+uOTBh6vBppDPrDUJ8vGA2j
	jv86nC+EJ2dHwTgeyWI7wRQpGxUonvI=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8485b358552so3095587b3a.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162910; x=1788767710; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0tkr6D1mJkSgu6ygeW9vA9keYBBS8zHk8hkf8RCBkSI=;
        b=Pn3h1dyqZyEB0XUB/jlF9XBgN1wyhHPMeY/EKuK115aB2YAoiZSY45SoUGJGLKlxET
         wbYdbmcCcH/qVEwtWC1BszlBEON6e3b8JbokrfNgLxEHTOFnu/xPlxsJjzcvCUChVl5u
         kMNrzO8YXp6+GKjULfefzxBs932knBkEtQ3wqys1vrjn5doDPcrrRjxbvTtn1n/foQjH
         nBHp91x/J4LCE6k653kVxD4KCSkb0DM81Xx4jxa2E/sbUOd47UjlH4OEke3lLiZsnJsa
         K91W2yT2kNIwV00CvzI7kUKu1SAVdFQFawIQJI9YlHgC0WRRSEmjzLYYEmq+iYfQO9qm
         IU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162910; x=1788767710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0tkr6D1mJkSgu6ygeW9vA9keYBBS8zHk8hkf8RCBkSI=;
        b=dTLzXyAoet56ml3J4WrmgE9mcJvhjeM6X+drDB4JCZ2v4H56zdzTQmK6lzKyi0jTZv
         Hbf02Se28JaUe5mIfDRRtdXxPenIDStf+b89ATGQYpVTGlq0+ZO56eLrEAq0LNyVrK7X
         ph5KXZUrNrbLbalejLRQIOkaY5NHBEljUFhIUC15sG1seTvd9kRV2h97BudlOJnHrG/O
         OWBe4HP8y7b/fFhUpv11rsmNkI0AL5/L+TrE9rgR/iclZCjmNOGB8Ignd2uuSTyUifpm
         1qQ99vzHXGqqGbApcJnCjd9CDZN2GHnGeCe4sgaBdCD5bOihIMdMBgHZ8qeJQUkEAEkV
         u2nA==
X-Gm-Message-State: AFuF++kFDgveORvjSYFNBx3bOW3g5YX6ZoCTiw/d97qJSBTSnlYU/3Ex
	ARRjOHX+YNC1jabOrkju5dp+gJKS5krCGEBrRn+7mMQgE3Ddjvyo2VgqNlZGKr58eUA=
X-Gm-Gg: AR+sD12vLJ9Q7b9mjNZWjEKoRz3yYoNTgDH9G4vInHlx2Qt3FPRz6wEUUcI6Gk9u/hF
	4iCFxqSNv1UWRdVC+O4Fr00bPnCK12gmx7W34XKhVBQmfnrS6qfi1lPX+PNQFmDhGqAYfiPP8zk
	Y0aUnixYpyQsATJsDLLlznmsjz7H3NNQKY/l5QCvuipuJeCsn8VwBu3UZ9PLC5vGRqkn+CgTStl
	k697t+KhVelE7gcdZVbmu3rKSlHP6Ukg07CCyZBk+JhUMYolyUbJXRWZSD2omx7xLnnNZ4tX+F7
	gTt6wyCUfD2/cgLcRSo6wWqyTeRyeNaQck7BJb0CpeBu1qoMpk0wdZ9kZqCcQZ4bA3bHtxEhjCc
	1ExzQBBkJmE9OgO01f03eJT29rKMLVm3Y5pqN5n4IJbOMOXQYGi2i6m+iFn0lVLPQGUA/hPYbRy
	cpH9FPiKjI8R1w39zeKul6vhjueztuZ0U/pqXwY9CTFDZvT/DK3s6P8ZOPlkX1RwNZ+DRV+TqW2
	MBmEEoFzeBRarzYcSjhXys+
X-Received: by 2002:a05:6a00:1c9a:b0:84e:9257:d0c2 with SMTP id d2e1a72fcca58-8562a00149emr40654262b3a.9.1788162909920;
        Mon, 31 Aug 2026 00:55:09 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.55.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:55:09 -0700 (PDT)
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
Subject: [PATCH 09/11] mm/sparse-vmemmap: drop the extra tail page from device DAX reservation
Date: Mon, 31 Aug 2026 15:53:40 +0800
Message-ID: <20260831075342.57563-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1ke1we7tuedmhgm8g16py5tb3ouio6go
X-Rspamd-Queue-Id: 1BAB5C0008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788162910-50739
X-HE-Meta: U2FsdGVkX19tuH3cFKSEZMHyrcQyS0WPYNpGbbPxndKhS6g6X5Iky3PP1eydK+JMDKUT/uvANr4IB02TaWsQiB8VN4/ZdYkZ+vL+aJkJJvlgsbYXbEFz7SarbGJpCvUtTXuhlf2nqdIIrnjd90aqeBiDMpFcBCJmfh79EOMbH95FGZLyKunccW1Dn2ZP35uRU7+9xjXE86HEU+wPLAgHe5Ykh6dsJECfNHSQgNYz3hS9qjLEIYL5hM8T/QmRaZ2mENiYVnTbUBmxVXVAhIOxV0dokOlBux55E26/XyellECRVXNfWBqffUHGwS8xZsVXmoN0WcultQttohjdxb+xw8BsKPBxh4l412J5VMY1qVBBVZ2M6ZkQfiBHk6NkNROspi1HUoUiMLSQrp3mIi7ojxJW6p7yGxQmpRAKRP7Hx/OkLktum0R911mzvVmrnOkIJovRSqigdodORhbXzNWkJ6nzTVEZxh/yo1+I1LAWd83RmdpgDFCPNX82ftxIOVU9iIgYXgq7bXb3AYMDX05g2pGAyvYB4tQo8fdcwL8gBzOpOpKN7drdP93bWzDdOxjydVhcxacvNSPzivKrOzTbeWvLyCWCTpmrZmdUkrVaEQ8oXFJCLny8/iG5+e9jOaVOCsV+FOTIbMb63RpTtgXC3NmZZGRJ5Ku0plHvBixrusSFOE6saYs+S9OABlOFnYdQe+tD+1im3AYQ8Y3UaJvkH8JXAbHrz+SUqciID5CpM9hUbUJxVu2MpU8Q9EUnCO4kPueN6Ulq8IekAoAgQWCEvWCLHYzkwNK1p/uJp43zqbByiNzd2NhFcA1ERfLDne9ifpkiP/hKRhCVl7HVej6d32FjshMAc64eoF5iL/xfIl4cakHB8syz2nAkVZyHhr5SQRyOXSJHMuB5TFgnxUvu7He6yvZIMHv8F0hQjUZwo2YBHaGvHI7MQ+gdNkuUrerTZ2LMXOJTanlJwTWByYK
 RjuiJfbJ
 gvI4oP1TPCerMqmrQcmupswilxG3B9djZ+qhbZ1/HJekBckGKLyuxUgJ6dzhLIWWoL9UYKcArOnp0XfQqbLk2i/J/0vV1wEIVsNCVbftzdcM8cE8R32ImO3qsPvW4AT0AhQAp2R226U146HDBrNmbF+IeAMUMCMqpTfdYb0nM4a6igtZQCycr91xLXJL3BqsyvofHyj9quEnqy4wMYF/TxmTNIMVD6LN6q6D9DRRvd5j5kyY1EEItoKJh+HqSvAbpu2blonHxox8fWLXzeI62qf+Fq9HkEK1pKqTs07BLfok3trmvyNOatI9/fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The device DAX vmemmap population still reserves one extra tail vmemmap
page after the head page.

Drop that extra reservation and let the shared tail page cover all tail
vmemmap pages after the head page, so DAX follows the same reservation
model as HugeTLB.

This reduces the reserved vmemmap pages for optimized DAX mappings to
one and removes the now-unneeded first-tail population from the generic
and powerpc paths to simplify the code as well.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 46 ++----------------------
 include/linux/mm.h                       |  3 +-
 mm/mm_init.c                             |  2 +-
 mm/sparse-vmemmap.c                      | 13 ++-----
 4 files changed, 7 insertions(+), 57 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 831c231a4a18..e7e751c48dd2 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1218,39 +1218,6 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	return 0;
 }
 
-static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int node,
-							 struct vmem_altmap *altmap,
-							 struct page *reuse)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	pgd = pgd_offset_k(addr);
-	p4d = p4d_offset(pgd, addr);
-	pud = vmemmap_pud_alloc(p4d, node, addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, addr);
-	if (!pte)
-		return NULL;
-	radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1297,7 +1264,7 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		if (!pte_none(*pte)) {
 			/*
 			 * This could be because we already have a compound
-			 * page whose VMEMMAP_RESERVE_NR pages were mapped and
+			 * page whose retained vmemmap page was mapped and
 			 * this request fall in those pages.
 			 */
 			next = addr + PAGE_SIZE;
@@ -1318,16 +1285,7 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					return -ENOMEM;
 				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-				/*
-				 * Populate the tail pages vmemmap page
-				 * It can fall in different pmd, hence
-				 * vmemmap_populate_address()
-				 */
-				pte = radix__vmemmap_populate_address(addr + PAGE_SIZE, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-
-				next = addr + 2 * PAGE_SIZE;
+				next = addr + PAGE_SIZE;
 				continue;
 			}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index edadd7549b72..edc7b9ce9e79 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5180,7 +5180,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#define VMEMMAP_RESERVE_NR	2
 #ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 					  struct dev_pagemap *pgmap)
@@ -5200,7 +5199,7 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
 	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
 	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_RESERVE_NR);
+	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
 }
 /*
  * If we don't have an architecture override, use the generic rule
diff --git a/mm/mm_init.c b/mm/mm_init.c
index c4cd61978ce8..d520fd8de0df 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1049,7 +1049,7 @@ static inline unsigned long compound_nr_pages(unsigned long pfn,
 	if (!section_vmemmap_optimizable(ms))
 		return pgmap_vmemmap_nr(pgmap);
 
-	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
+	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
 }
 
 static void __ref memmap_init_compound(struct page *head,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 0201877a7f80..e655d9d1348f 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -136,7 +136,6 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_order(ms);
-	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
@@ -147,13 +146,13 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return vmemmap_pages * nr_pages / pages_per_compound;
+		return VMEMMAP_OPTIMIZATION_PAGES * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
+		return VMEMMAP_OPTIMIZATION_PAGES;
 
 	return 0;
 }
@@ -521,17 +520,11 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		if (!pte)
 			return -ENOMEM;
 
-		/* Populate the tail pages vmemmap page */
-		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
-		if (!pte)
-			return -ENOMEM;
-
 		/*
 		 * Reuse the shared page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
-		next += PAGE_SIZE;
+		next = addr + PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
 					    page_to_pfn(page), flags);
 		if (rc)
-- 
2.54.0


