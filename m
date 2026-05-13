Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15682CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4B96B00E8; Wed, 13 May 2026 09:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC7D6B00EA; Wed, 13 May 2026 09:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E30C6B00EB; Wed, 13 May 2026 09:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4916B00E8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 275CA1C0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:32 +0000 (UTC)
X-FDA: 84762433224.02.10A6928
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5423DA000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="a/fjblx0";
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puCoZmQRDxwpateuYAk/P74OaRyzUWBl0IwVomJ8OUY=;
	b=ikPri0Y2kAJjBc1OOIEBnILbX6NnwjwnPSa4vKoTKTq9KADy2XKc+nHvJuoXX+wfySptvX
	djDmu2xdzwHqUcorv5OChjx/simrBPb/Rv1njMZLhnjl8uTpclriPBY3NbW9s6VrB1yOIL
	qmViHMssWZTGvpEGU4Hfjw2ZZKpmllg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="a/fjblx0";
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677890; a=rsa-sha256;
	cv=none;
	b=zhjaX1P1wKVl2Gk81lNwy9YnL69d+OvTN3y7SmO/TOWdESWeTO9h5kLyBFwQm2G1mDD78I
	plrokL+sS9AjTrs3ytIop+YpLrxPBnAwlIDxZiLvt3F2VVpJTegzxzk0XsoCkLWF1BVULl
	EK1Sfl6EAcSphT1VZ9vJ+VAR7FR/GYA=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ba4a1a0325so46803615ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677889; x=1779282689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=puCoZmQRDxwpateuYAk/P74OaRyzUWBl0IwVomJ8OUY=;
        b=a/fjblx0f+dXFCsYnFOJZgazFwOcD9F+pfxTLkWWAvQUsc/flPAkibCUNuImW/Ax13
         mnlePnIFPscyJHf1QW/kpMeg2xo5gLWg/zmFAqM6Gq/prso2JMngdSIdJS3pgBUGcy3w
         psK8NbIDRSBoQ4Rs2esDnz5brs4g0XxrJx27VLUOYSWM52/3mo4TXBq9OXp9sQfAa/fq
         qTNGzJrZOV/EPmAMxqK7JqcTupHbFyj6B2a52WFUFMRWGELmiaSApgciq5jbmUsl1AuN
         emaTLmFpJyJWAgughSDmYHPpOi/2sIO6hNhJzEsPfPwxrlf1YGfEKy9Umj0i2rB4J/uC
         fJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677889; x=1779282689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=puCoZmQRDxwpateuYAk/P74OaRyzUWBl0IwVomJ8OUY=;
        b=PVaozllxolF8vRp40AhKVPnwOK+QlD+viPVv9MyzrE8ujaXjnsVgvoPqeAPCwOZP5p
         GrMtrP1OITUdhyE8sH3HAHW2atVwZmqU43vxCQRLjBPeXQVjEmHJ+DPGHdYJnYjRYqki
         jD7F/Bj1I9JjZE0Fnbq8w9BEQhROoCAYtKoxsKNbrq6vLLo30C4arhS0NZeG6N6NrY50
         Va4uz4iE/MWOsENtRFixRcT9dijypzSH+vzaHKoSZYYPzokRvvRnfKNj5UrDVY+SGH4u
         jf9XjPtG+7JjyJI/jB+L+3IZk5A4jDWmApuzFMNeWv3mxhXpRPh97FSZGmp7I2nEoj3Q
         Bsyg==
X-Forwarded-Encrypted: i=1; AFNElJ/SOh03BicrRncUV74Pc21E/X/uXU0nUm7w40t2q9DPdv7gg4G9AQU2aGqty3Bw6w0YZoWwsQhAeg==@kvack.org
X-Gm-Message-State: AOJu0YwLY3ekopSWXuDTXvzxRxqDUwR5+kXcb0a3KsBmngZVHwlZr8jJ
	72c6T9kwdlwCFkJtGT9FHFViMuuVcPnqyJn25xs4pXSqsg4mJremd6wC+qRbWoaofM4=
X-Gm-Gg: Acq92OEGNE4s6HhorVNh1IuZZsp2BPYp06fBmkP0t2qWtlpZfCgQOk4mPRZ95JDt/zT
	oEAnBCFmkvIPkd5to9Pvc4nYCvWQm9XcFPDXdR7yk9hEBHCdsDRUfv2mrvg/Bi/9sMKZJ5ua8wj
	uFOaOV8G7rnIzDX/g6IQpvL7hSGOhirAsGh/DnFZKlbxNuwED8BgybuXGzML+55PsMwWOE8+Uqr
	jPbUL9TjFnf8fE7iF4JRt34Ca/GQpMKjoB0/K8OewcfGd/9HpwI/3dCfPRdpwDGOknjWc1ksUyk
	3j5oAptDCl/h5vwCvaZnmhy2QeTuqX2NCdBpgbkMxHGAwhknO67Q1YKz2HaNOLY24Fhi7Nvr40U
	77AbrtHh3qu8/g3fa4hEZUmer8HH854LLCKXJ3W3NPVATmO6muCPUj2yTNRzxxjbl0NftRDSl0n
	vjMCR+STIuSPke2pyJoush3ZEas/0RWXzZxXlGhd+taamjYWxdPYQKeO07Ijc=
X-Received: by 2002:a17:902:9a0c:b0:2bc:810b:5c0c with SMTP id d9443c01a7336-2bd2770eddfmr29915325ad.34.1778677888928;
        Wed, 13 May 2026 06:11:28 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.11.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:11:28 -0700 (PDT)
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
Subject: [PATCH v2 43/69] mm/sparse-vmemmap: Unify DAX and HugeTLB population paths
Date: Wed, 13 May 2026 21:05:11 +0800
Message-ID: <20260513130542.35604-44-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5423DA000B
X-Rspam-User: 
X-Stat-Signature: 39pg8dtigz7hcnbfr7g68yjwxy8tqac9
X-HE-Tag: 1778677890-363549
X-HE-Meta: U2FsdGVkX1/dczWhWw2VS5IcHsxxoAtIryU6Zjy9o+/gqglKun3zZpACr3G7MmP6vpZWjH+z8kDR/ZKGpV/Ur9JfheBQNU1MCJEeshvrpNH4UvxKPEMaMQXJWCJscDXwdktpa34rSOoWSDUulI1C304YwbyKUZ54wIA9UiSSsre98kUJZisSTz6uPa4+x3jeg4SDhxUh2GZ12IrPWhxU+bDbIHDAvTNjKRh6+0hUYRm0IL7Y3/z30KsLpOrE790DP8IW8yYAZLi9aAI0YOD3YGs0A8DPHj2c9nfTyLUsGRz9HS2+Kf12pWICJbkFffkQpo4Qecqh75wNAixuvk1ScNVs7zpp8JFUaiqmXVOYNIgRkvHXOnNZstg5py4xgWC3DrG9f6Ah8TdWdkdzW677GcMkfm6n3Yfvbwk3QlgFhioiW8sP67HSvhIa7Ep+oAPRHDJUqX08Vce6waVm2S03nxubDZDOVY3mghXuKwSBWUJQDwuitFz45ftzLziKzcG88N9cnE60nb6ztC43yB3pMfhlA83/rd04tTXSk3WrngjYvV7AYZjIEUxxoXwVDB54FIHGwY98IQXbhWa5E/dtDBamYGs7Q8Hzmggg9s7BgXeYpzx1reJxwiTEbneB4VvoX/llMf53SXaEu0cMrE/ruF1+Ls9QYcdJ2FHIsNF18n29Vao1Yt1hXrruSWW5DbrZ68q8oF/vbjMEwvpdeJWixnTKfVLtntsO24PuSTalmH8Om+Xa9gLapZC0Y0CLFVp6PPSXbcNxAma7t/EXNwhFo2hpyVEcHsFjAvK4f0UxnN9n2PBTnGv2Pbt8XOsGfdhLucCZBIm1t84QX6SK5H54BNKvt9VJPHWI3yl2ywfoMlfe8mRfHTK6tAToYbi10CAnPbnfBCVku1r7OCTorI52dWCHei/Vgkdn1xhLnkmPpAuZvqJEuTpD5a6nW9JfMaQwasWWHsHXUOHp3RAprL0
 uM7afLzM
 bid2DgxJvmZYaiWo2+pIE7MUPf7KO5bkD0Im9lvL7KNJzBmB8b/X6jO+ntzZ+eOGq2r/PmJ3rGDYdoHQ63AJaEzEJcIx4r5ojpJmZ7i+ZlGbJP7vRfC0bORBMnNx1lCf7DyynfIpg7/uIvfb/K69oskeRj6m3yd9lXJQ8WaeqmwCR6c+SUw8+XD8oywRLFgZlZ/QkjZOrhsrXFJHk/JaAg9Q5A+ztIN8+y8Lefnm/EYR5DqBJSZEr8TLEasRWMvXW2TvAw2QASrt1tz31vYK8gfcEnp1hb9u4cr5zY9nydc06BcZnyAgMDH1ew9z2WAbuomza
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that DAX and HugeTLB use the same optimized vmemmap layout, they no
longer need separate population flows.

Move the shared-tail-page handling into vmemmap_pte_populate() so both
users can go through the normal basepage population path.  This removes
the compound-page-specific population helper and leaves the optimized
mapping decisions in one place.

At runtime, the optimized users are limited to ZONE_DEVICE memory, so
use device_zone() for shared-tail-page allocation instead of relying on
pfn_to_zone() before zone spans are available.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c |   3 +
 mm/mm_init.c                             |   2 +-
 mm/sparse-vmemmap.c                      | 183 ++++++-----------------
 3 files changed, 50 insertions(+), 138 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index f0043c57694e..c7f2327681cc 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1121,7 +1121,10 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	unsigned long pfn = page_to_pfn((struct page *)start);
 
+	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
+		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2b94115e6dd5..9ff118e35641 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1068,7 +1068,7 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
  * initialize is a lot smaller that the total amount of struct pages being
  * mapped. This is a paired / mild layering violation with explicit knowledge
  * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap. See vmemmap_populate_compound_pages().
+ * of an altmap.
  */
 static inline unsigned long compound_nr_pages(unsigned long pfn,
 					      struct dev_pagemap *pgmap)
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index ad3e5b54abf7..4833a2295abb 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -127,49 +127,48 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
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
-			struct zone *zone = pfn_to_zone(pfn, node);
-
-			if (WARN_ON_ONCE(!zone))
-				return NULL;
-			page = vmemmap_shared_tail_page(section_order(ms), zone);
-			if (!page)
-				return NULL;
-			ptpfn = page_to_pfn(page);
-		}
+	pte_t entry, *pte = pte_offset_kernel(pmd, addr);
+	struct page *page = (struct page *)addr;
+
+	if (!pte_none(ptep_get(pte)))
+		return WARN_ON_ONCE(vmemmap_page_optimizable(page)) ? NULL : pte;
+
+	/* See layout diagram in Documentation/mm/vmemmap_dedup.rst. */
+	if (vmemmap_page_optimizable(page)) {
+		struct zone *zone;
+		unsigned long pfn = page_to_pfn(page);
+
+		/*
+		 * At runtime (slab available), only ZONE_DEVICE pages (DAX)
+		 * trigger vmemmap optimization, so device_zone() suffices.
+		 * Note: pfn_to_zone() cannot be used at runtime because the
+		 * zone span is not set up now.
+		 */
+		zone = slab_is_available() ? device_zone(node) : pfn_to_zone(pfn, node);
+		if (WARN_ON_ONCE(!zone))
+			return NULL;
+		page = vmemmap_shared_tail_page(pfn_to_section_order(pfn), zone);
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
+		void *vaddr = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+
+		if (!vaddr)
+			return NULL;
+		ptpfn = PHYS_PFN(__pa(vaddr));
+	}
+	entry = pfn_pte(ptpfn, PAGE_KERNEL);
+	set_pte_at(&init_mm, addr, pte, entry);
 
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
-	} else if (WARN_ON_ONCE(vmemmap_page_optimizable((struct page *)addr)))
-		return NULL;
 	return pte;
 }
 
@@ -265,30 +264,16 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	return pte;
 }
 
-static int __meminit vmemmap_populate_range(unsigned long start,
-					    unsigned long end, int node,
-					    struct vmem_altmap *altmap,
-					    unsigned long ptpfn)
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
 {
-	unsigned long addr = start;
-	pte_t *pte;
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap,
-					       ptpfn);
-		if (!pte)
+	for (; start < end; start += PAGE_SIZE)
+		if (!vmemmap_populate_address(start, node, altmap, -1))
 			return -ENOMEM;
-	}
 
 	return 0;
 }
 
-int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
-{
-	return vmemmap_populate_range(start, end, node, altmap, -1);
-}
-
 /*
  * Write protect the mirrored tail page structs for HVO. This will be
  * called from the hugetlb code when gathering and initializing the
@@ -425,94 +410,18 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	return 0;
 }
 
-#ifndef vmemmap_populate_compound_pages
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
-static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-						     unsigned long start,
-						     unsigned long end, int node,
-						     struct dev_pagemap *pgmap)
-{
-	unsigned long size, addr;
-	pte_t *pte;
-	int rc;
-	struct page *page;
-	const struct mem_section *ms = __pfn_to_section(start_pfn);
-
-	page = vmemmap_shared_tail_page(section_order(ms), device_zone(node));
-	if (!page)
-		return -ENOMEM;
-
-	if (reuse_compound_section(start_pfn, pgmap))
-		return vmemmap_populate_range(start, end, node, NULL,
-					      page_to_pfn(page));
-
-	size = min(end - start, (1UL << section_order(ms)) * sizeof(struct page));
-	for (addr = start; addr < end; addr += size) {
-		unsigned long next, last = addr + size;
-
-		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1);
-		if (!pte)
-			return -ENOMEM;
-
-		/*
-		 * Reuse the shared page for the rest of tail pages
-		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
-		 */
-		next = addr + PAGE_SIZE;
-		rc = vmemmap_populate_range(next, last, node, NULL,
-					    page_to_pfn(page));
-		if (rc)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
-#endif
-
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
-	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	/* This may occur in sub-section scenarios. */
-	if (vmemmap_can_optimize(altmap, pgmap) &&
-	    section_vmemmap_optimizable(__pfn_to_section(pfn)))
-		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
-	else
-		r = vmemmap_populate(start, end, nid, altmap);
-
-	if (r < 0)
-		return NULL;
-
-	return pfn_to_page(pfn);
+	return vmemmap_populate(start, end, nid, altmap) ? NULL : (void *)start;
 }
 
 static void subsection_mask_set(unsigned long *map, unsigned long pfn,
-- 
2.54.0


