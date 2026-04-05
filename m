Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4846FF3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C026B00DA; Sun,  5 Apr 2026 08:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03E46B00DC; Sun,  5 Apr 2026 08:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2996B00DD; Sun,  5 Apr 2026 08:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0086B00DA
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:57:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56EBD1609F6
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:27 +0000 (UTC)
X-FDA: 84624503334.07.7D4EC4A
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8C11CC000A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OVyGql8K;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un8QJIOHiLQFUGTVr1x/7L06qAEVN23h4FxFsc9SMV0=;
	b=PrEfMQx5H5pg/h+Rx2O9HpFac6B14SxLUSFiP0pJclhUWtv3BFjxghJdjFBK7flTknp6SD
	6sZM89XLsCv2Nn8lgBxIN8UKYJMg61rykTzmpDMWkGfpmK4flXdL+kq9E2BZjZy1jVF+dd
	HESVNUYSC2BaIyVO/KFd05ClhtT0eQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393845; a=rsa-sha256;
	cv=none;
	b=KAYXSF6MiwUkUolJcXQMDTfCy0dqYzZbVyfKjRRfH99NBZwwXJelJRUqjNO9GGHUlPbWte
	HY5eGPy3+M1d7Fdca5E7u1EPf+CWzOMXqEjezUEL188obRxVfn6m1PFcNyr6+xJgbkX3Ei
	ixmZBS/kZVJniMf30aELNm3cfE8LFXc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OVyGql8K;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35dac556bb2so2064593a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393844; x=1775998644; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Un8QJIOHiLQFUGTVr1x/7L06qAEVN23h4FxFsc9SMV0=;
        b=OVyGql8KrBSg8onAGEhL7wCCjovMm8KYaYJKRhqBl2E16KYS6IINF9CyQ9xn2/t3Ge
         MDXLoIbChrj8z5vJ16NF7fS7IK2SH4JOi9WfttIlXRs6ad//JYahzHyHmEFCH7KSWvnH
         LdccQj7jbc/MaYi8ROR1Y25q+A6pjAVeklsRhmoikY4Eqku7h9u/VcFwk2GSqnPhA426
         ags5LgdmiXuQgemMkHyKfzPRcxSrCJXNaHRrY/ScOF7zmiZeFOjpK3dy8z8+Xvna6Orx
         q6zVLR8SGn5EvV7HvH1A3nc2NDSwCFkiBqCRkTdeLNb8xvu03GtWqbvCNT8MvVqAy3DL
         o78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393844; x=1775998644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Un8QJIOHiLQFUGTVr1x/7L06qAEVN23h4FxFsc9SMV0=;
        b=J34tRGTs2YlgtL2totW4oZf5gc1isMs3SFzsg72nm7mSlOxJsH9GtTmOSBEJyjEK1b
         JIFjtVqxhrsMimk/udcV1NZutGaj6wl+zd12QbEgLJrCzF/sRG81Sk8DTRl+SITh+4pe
         e1CRw01YGLPVs4y9hb2qXIaFhtbpzXITRGF9EcquivfnMG8qZoAyEbJCp2V/Desm7xsx
         ozgdyO7yTA+3YEVX8k5aQZ1NFyjs+AgoGWPnaVjLi9HjunW2tpwxMCnVymJ1WooTlSYV
         PeQdOWfMauvpsnYDpMzokvYNZbB8vwTC2AOCMLLO6SNMu6XuwDD/q26LbU8J5vgyuc02
         hk+A==
X-Forwarded-Encrypted: i=1; AJvYcCXTmf4M/M4l62WOnAKvXfcuzpyWdyV8SfSvuIQy6bAICPUV/B17tBqfjHSszrG7VIlqD1cE+K1FeA==@kvack.org
X-Gm-Message-State: AOJu0Yw/If4eiuvsst/hBM2FsgPX6Hs2IbChDjgHl0RSRhg/NliOzP43
	IFhTStscAs+Pf73McS0VscfETTB41a9xZm58P+teFLErlaE9S10Wdi9HW2auCigP84Y=
X-Gm-Gg: AeBDieuKcbNfbBlnRs1a0hZDJJvjhfArIflgmrtfJQ9JySUJats+YaS1UfIB0sNVZk3
	e4Pf7C6yfuE0cH+RTk1r54pZm6bWW2Ah1ZI9FdH3NqXScNVR7CQzb+LsOMQcV9Wyc6VhtRFKla3
	EUNKMKPSLHx4bsC+ErXf5lSo1DJDWKNBaOUrG6RjHJa2D0vx1Tt4vEwejgQeY+zyveQLhruN9OW
	gQGAUlWqrLPjw2IvlBtWG+CMgmiVR+FW254EVpJ/xAVzfdptY0wUmZDftH9CGx/7E/cJRn6fdY1
	gim44nGcmy2bN3d3PFcGlDlaFmOhak+KB2umOKCYRr3l29abFcKEi82/EskxYtqhYJoFw+/DWMX
	sQUKeVM8EkEC/0aKXa8gZex0XEcHzN0lB6Ghfii0hZJo3Rxfhh47EoKZ8rulieMvgKza8wKd+Fn
	d/SH64N8oyHShvSU32UJpCRc+dL8i/qqA/odl8rIgjDiU=
X-Received: by 2002:a17:90b:4fc4:b0:35d:a374:b385 with SMTP id 98e67ed59e1d1-35de6a1951bmr7999215a91.29.1775393844264;
        Sun, 05 Apr 2026 05:57:24 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:57:23 -0700 (PDT)
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
Subject: [PATCH 37/49] mm/sparse-vmemmap: unify DAX and HugeTLB vmemmap optimization
Date: Sun,  5 Apr 2026 20:52:28 +0800
Message-Id: <20260405125240.2558577-38-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C11CC000A
X-Stat-Signature: d8r3nnyhjbb91f8o7gcorjrmaq1gc9ct
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775393845-895386
X-HE-Meta: U2FsdGVkX1+YYyXlaheOjET3c7fhb3mqcy3Kptv1bdNPMHn91xFZcbzSNA6BEZiNzvQAP/3lkZJRk8iEIkjDz+DuUQXEH0zWF0jtj8TvAE7V4ju01Br0fuUhggMZ2LEViD/IwZRnOw8G/LA9gczgctAcEZnCNgPh/zcPvbF//eH1MlL1oQK/LkN66nQwClAjHU5j4nPaW8GkNXQ3z+RRfSZXa7gnldImVq62F5WjrBc+/hjBItWSoQJj2ih6FweCq/tpB4hLLXIcbhcTA5YVTAE7eAqy6T45uk3E42iQ6i35b094CoGPZyl8EBDRZX9NUPCfBBzSaa1fUPlOCnf8imLKB4NzijyXVFu2jVNy8/aRnV8ffqQu0lAl/1061q49qfk1jE+21dsmND/VFEdejeKAQ3fDI4ry/nbhQvOZo9IT3aVx9OM3k9Us/WE1S6tZO4YmgH5TQ8IGhHHK9GagQFXuLhmPbwXr4gzkMEBO6jp7kpBf7WDeNs5+qD9Ug/MjE8xr4lYcA7EWyhug4GnLQsfaeNYbR3+faGb81049IVMRBN9qJDrOGLQl+aw1P/ZXVCWR9sJTwJWDAK6qf7mLp+Ww3ApnN9W67Hkc0VC+SIPc7x1nws4wfmeftgV74meSgv1wjmzXRQW8j6QS4qSAxgL1t3eYgY/yvQf9jhO5BiwF8JHGveC3SI7Fz0qhJjBu8NaVqHuyARmkVaAS1n921B1WQAY8TuBNxSjgMNHxEjvOo33keJVKYB+ctzBmn9cH81ZW4LwN4H8mXkm2Bqa5+UhkkUgsKZzU7KhiM+A/Q0LYIBfO+5HjblhUZ8dfylx5eTC6bvq3Fh7yy2KPj/LpejShIjEB7naDgsDaZ2g/VTKpj5/qxOcsiqu8x4zBlnlC+NwzwJRp/E99nxYCm+WFTGdsz6x88rz9OxVr75Zyfoi5sN6pMq4Rrgn9Zr/AJRrHBmD0MER7cdOTECxanrB
 TCInpm2Q
 cqcZabm5lHadocWgYMX0O6ZJu7Uw93Yt7lmFw0WB8RMU6909ayr9XbVeq3zvg0ZPZlsQKT4hvZrJHRjkJRmXbIFTTUjivBudomixW5sCtmHrR+9iZQE7DuHKT5nCsmxvb+FjtwkvPy5d3wYuVTfSBvwMnIDf35yGK2tSxA+kfBBis3J8o3blGiCZa7FiJdWuIedvuK6v+zqm7Xxsy+GBg5g4ygUyxSeNXFBSAtYlEB6l5ka13T5cNdnwODMSfMSaZsxV/VbNYccHvzK6EEDhd6VLdvFVs5VfobJq3vvL0OfvLA2NOclgH1pXMMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ultimate goal of the recent refactoring series is to unify the vmemmap
optimization logic for both DAX and HugeTLB under a common framework
(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION).

A key breakthrough in this unification is that DAX now only requires 1
vmemmap page to be preserved (the head page), aligning its requirements
exactly with HugeTLB. Previously, DAX optimization relied on a dedicated
upper-level function, vmemmap_populate_compound_pages, which handled the
manual allocation of the head page AND the first tail page before reusing
the shared tail page for the rest.

Because DAX and HugeTLB are now perfectly aligned in their optimization
requirements (1 reserved page + reused shared tail pages), this patch
eliminates the dedicated compound page mapping loop entirely. Instead, it
pushes the optimization decision down to the lowest level in
vmemmap_pte_populate. Now, all mapping requests flow through the standard
vmemmap_populate_basepages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c |  13 +-
 include/linux/mm.h                       |   2 +-
 mm/mm_init.c                             |   2 +-
 mm/sparse-vmemmap.c                      | 185 +++++------------------
 4 files changed, 40 insertions(+), 162 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 5ce3deb464d5..714d5cdc10ec 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1326,17 +1326,8 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
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
-				addr_pfn += 2;
-				next = addr + 2 * PAGE_SIZE;
+				addr_pfn += 1;
+				next = addr + PAGE_SIZE;
 				continue;
 			}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15841829b7eb..bceef0dc578b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4912,7 +4912,7 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#define VMEMMAP_RESERVE_NR	2
+#define VMEMMAP_RESERVE_NR	OPTIMIZED_FOLIO_VMEMMAP_PAGES
 #ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 					  struct dev_pagemap *pgmap)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 636a0f9644f6..6b23b5f02544 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1066,7 +1066,7 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
  * initialize is a lot smaller that the total amount of struct pages being
  * mapped. This is a paired / mild layering violation with explicit knowledge
  * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap. See vmemmap_populate_compound_pages().
+ * of an altmap.
  */
 static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 1867b5dcc73c..fd7b0e1e5aba 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -152,46 +152,40 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 					      struct vmem_altmap *altmap,
 					      unsigned long ptpfn)
 {
-	pte_t *pte = pte_offset_kernel(pmd, addr);
-
-	if (pte_none(ptep_get(pte))) {
-		pte_t entry;
-
-		if (vmemmap_page_optimizable((struct page *)addr) &&
-		    ptpfn == (unsigned long)-1) {
-			struct page *page;
-			unsigned long pfn = page_to_pfn((struct page *)addr);
-			const struct mem_section *ms = __pfn_to_section(pfn);
-
-			page = vmemmap_shared_tail_page(section_order(ms),
-							section_to_zone(ms, node));
-			if (!page)
-				return NULL;
-			ptpfn = page_to_pfn(page);
-		}
+	pte_t entry, *pte = pte_offset_kernel(pmd, addr);
 
-		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
-
-			if (!p)
-				return NULL;
-			ptpfn = PHYS_PFN(__pa(p));
-		} else {
-			/*
-			 * When a PTE/PMD entry is freed from the init_mm
-			 * there's a free_pages() call to this page allocated
-			 * above. Thus this get_page() is paired with the
-			 * put_page_testzero() on the freeing path.
-			 * This can only called by certain ZONE_DEVICE path,
-			 * and through vmemmap_populate_compound_pages() when
-			 * slab is available.
-			 */
-			if (slab_is_available())
-				get_page(pfn_to_page(ptpfn));
-		}
-		entry = pfn_pte(ptpfn, PAGE_KERNEL);
-		set_pte_at(&init_mm, addr, pte, entry);
+	if (!pte_none(ptep_get(pte)))
+		return pte;
+
+	/* See layout diagram in Documentation/mm/vmemmap_dedup.rst. */
+	if (vmemmap_page_optimizable((struct page *)addr)) {
+		struct page *page;
+		unsigned long pfn = page_to_pfn((struct page *)addr);
+		const struct mem_section *ms = __pfn_to_section(pfn);
+
+		page = vmemmap_shared_tail_page(section_order(ms),
+						section_to_zone(ms, node));
+		if (!page)
+			return NULL;
+
+		/*
+		 * When a PTE entry is freed, a free_pages() call occurs. This
+		 * get_page() pairs with put_page_testzero() on the freeing
+		 * path. This can only occur when slab is available.
+		 */
+		if (slab_is_available())
+			get_page(page);
+		ptpfn = page_to_pfn(page);
+	} else {
+		void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+
+		if (!p)
+			return NULL;
+		ptpfn = PHYS_PFN(__pa(p));
 	}
+	entry = pfn_pte(ptpfn, PAGE_KERNEL);
+	set_pte_at(&init_mm, addr, pte, entry);
+
 	return pte;
 }
 
@@ -287,17 +281,15 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	return pte;
 }
 
-static int __meminit vmemmap_populate_range(unsigned long start,
-					    unsigned long end, int node,
-					    struct vmem_altmap *altmap,
-					    unsigned long ptpfn)
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap,
+					 struct dev_pagemap *pgmap)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap,
-					       ptpfn);
+		pte = vmemmap_populate_address(addr, node, altmap, -1);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -305,19 +297,6 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 	return 0;
 }
 
-static int __meminit vmemmap_populate_compound_pages(unsigned long start,
-						     unsigned long end, int node,
-						     struct dev_pagemap *pgmap);
-
-int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap,
-					 struct dev_pagemap *pgmap)
-{
-	if (vmemmap_can_optimize(altmap, pgmap))
-		return vmemmap_populate_compound_pages(start, end, node, pgmap);
-	return vmemmap_populate_range(start, end, node, altmap, -1);
-}
-
 /*
  * Write protect the mirrored tail page structs for HVO. This will be
  * called from the hugetlb code when gathering and initializing the
@@ -397,9 +376,6 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	pud_t *pud;
 	pmd_t *pmd;
 
-	if (vmemmap_can_optimize(altmap, pgmap))
-		return vmemmap_populate_compound_pages(start, end, node, pgmap);
-
 	for (addr = start; addr < end; addr = next) {
 		unsigned long pfn = page_to_pfn((struct page *)addr);
 		const struct mem_section *ms = __pfn_to_section(pfn);
@@ -447,95 +423,6 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	return 0;
 }
 
-/*
- * For compound pages bigger than section size (e.g. x86 1G compound
- * pages with 2M subsection size) fill the rest of sections as tail
- * pages.
- *
- * Note that memremap_pages() resets @nr_range value and will increment
- * it after each range successful onlining. Thus the value or @nr_range
- * at section memmap populate corresponds to the in-progress range
- * being onlined here.
- */
-static bool __meminit reuse_compound_section(unsigned long start_pfn,
-					     struct dev_pagemap *pgmap)
-{
-	unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
-	unsigned long offset = start_pfn -
-		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
-
-	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
-}
-
-static int __meminit vmemmap_populate_compound_pages(unsigned long start,
-						     unsigned long end, int node,
-						     struct dev_pagemap *pgmap)
-{
-	unsigned long size, addr;
-	pte_t *pte;
-	int rc;
-	unsigned long start_pfn = page_to_pfn((struct page *)start);
-	const struct mem_section *ms = __pfn_to_section(start_pfn);
-	struct page *tail;
-
-	/* This may occur in sub-section scenarios. */
-	if (!section_vmemmap_optimizable(ms))
-		return vmemmap_populate_range(start, end, node, NULL, -1);
-
-	tail = vmemmap_shared_tail_page(section_order(ms),
-					section_to_zone(ms, node));
-	if (!tail)
-		return -ENOMEM;
-
-	if (reuse_compound_section(start_pfn, pgmap))
-		return vmemmap_populate_range(start, end, node, NULL,
-					      page_to_pfn(tail));
-
-	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
-	for (addr = start; addr < end; addr += size) {
-		unsigned long next, last = addr + size;
-		void *p;
-
-		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1);
-		if (!pte)
-			return -ENOMEM;
-
-		/*
-		 * Allocate manually since vmemmap_populate_address() will assume DAX
-		 * only needs 1 vmemmap page to be reserved, however DAX now needs 2
-		 * vmemmap pages. This is a temporary solution and will be unified
-		 * with HugeTLB in the future.
-		 */
-		p = vmemmap_alloc_block_buf(PAGE_SIZE, node, NULL);
-		if (!p)
-			return -ENOMEM;
-
-		/* Populate the tail pages vmemmap page */
-		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, PHYS_PFN(__pa(p)));
-		/*
-		 * get_page() is called above. Since we are not actually
-		 * reusing it, to avoid a memory leak, we call put_page() here.
-		 */
-		put_page(virt_to_page(p));
-		if (!pte)
-			return -ENOMEM;
-
-		/*
-		 * Reuse the shared vmemmap page for the rest of tail pages
-		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
-		 */
-		next += PAGE_SIZE;
-		rc = vmemmap_populate_range(next, last, node, NULL,
-					    page_to_pfn(tail));
-		if (rc)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
-- 
2.20.1


