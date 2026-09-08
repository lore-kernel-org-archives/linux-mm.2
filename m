Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64085C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB546B00BD; Mon,  7 Sep 2026 23:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC446B00BE; Mon,  7 Sep 2026 23:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2406B00BF; Mon,  7 Sep 2026 23:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 300B36B00BD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAA2F140344
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:42 +0000 (UTC)
X-FDA: 85189102404.25.E553A47
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0AB8F100004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="aSDF/Wox";
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836681;
	b=n7xzboIEx2wJGguZLOP8YzykQ+7h1Fyy279/TCltlesT3992gF7jqE5sVneX3+TSc5K8TP
	ysIKT36KO363A6cPzpK0y1gJLEi+sv5WJd5lsNL0gQK8ymVahfDV/L7p0GNw65XN0C/ZZu
	V6ygpRy9TiFN0S12Pe5QPWVwq22XESE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfKr3rCUX839N8PLHteC+GkG6En7LO38FWq77XHuH2Y=;
	b=qK1Kl2ZHXtHu/BfHQyida3+BUDC/QzGBKOVZuzmxyUqwB6EaEJNZRHcx7rzbCBk0j/yZqq
	8c9Uad4kixabNWhlZ6qCOZ1961s7ARKq6T+hBILjTefsvXUdq8VkFvPn5nLDrnHUJesoD6
	qu1WhfSZRmqgPI6JwKSX1iNJas4u1bA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="aSDF/Wox";
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-85339ed040aso3211992b3a.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836680; x=1789441480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wfKr3rCUX839N8PLHteC+GkG6En7LO38FWq77XHuH2Y=;
        b=aSDF/WoxBxCnZm5HsOJseosWXcEFKBE2MV2WxdfAXLtIOC8lJbqqpx6QYDfexHuarD
         UeuBTY5snUWuZkW/6sHxTcUuDDBOGutcELHuSQBAYpr540sNlUOvvbjj0IDEWh9jmwaE
         36ECXoP/Ah2ZbXwTLX8kXyx0R4Thbfb0lAOJhzG+xHORHOwn8SNQIvEi9mtnrd3LWIbJ
         N8MILnxUlH2mM93ZJMp8UDI/WNkKOQuxUaKUVrUKsymYiE0O/vPcIYHGrvgRo5IJtPfJ
         4Y8gcG4vdFCozyaKDS8kZSK6Y9iVt94dKWtZmfj+Od9ueSYRG1hwyWuaRIx4eqMY5y7d
         C1hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836680; x=1789441480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wfKr3rCUX839N8PLHteC+GkG6En7LO38FWq77XHuH2Y=;
        b=rVkQlwZ98AKx1LYGPtyWFlde8nYXda7wb3UMlVj9I/kLNdHNx4W55ny0M98gkmHtXw
         GbyWnTMqnZmrCQoTndWZOHKn0nCsvcXLSMkydwrkmKaiAqyXxv9ZMVdwOH/vZwOh1kSc
         QPIDb45WOLI8x6+TIo+fCzH6UgU0k8fY0Ii4fa6bMDRBLgFG3z0dFtKK3uL9/P2fci06
         3ds1Nirf4YHy26CIGD91Og6G2CyRQ74pDrmSCf1PCrNZHMxnc26ew3y1zgdLcbe7YXDU
         neuFNqlQR8yRyjuDRDeUqyEH46QosL9Ij+r1C+zF/oQ9IUJLdGP2eqPMtJH5ZYHHNXts
         nR2w==
X-Gm-Message-State: AFuF++n2ddUhjWtVEi5Q/CL3PKIRkaDHTxeVTNh6a2dd3KR5YHRnrFV+
	9UMfXpy3w8QGHbYtVrM3dylgf6vHEA9qyDXvE1w6Y1pzSFQZt8Tz1+fhp7BeMQoUUFg=
X-Gm-Gg: AYBFou0md1hFMK37Xv9SqoOW1RG4ojWX4wJeCK3DjkpJTrsOATSCvdKeWpG3NF+7lJf
	fA2xdYJYgu8Sv7DuEHnjrcoTKPurkhC553YU4591lm7KGJn6VZ62ZV4QtB9FwisZ9CsjSBpXC//
	EmMtZrLMF2Qtr4hrZseZJ0oDKWeVOIbU6C6c1IAev8C5aUofCCdpCsRv81XYNcXWR0+HE0z8j+U
	V6buVtpjNPbvbFWFcnZrxsBxK9w7jEgq0WpZvcmwklcWT+RLNz4bzC3Kc3jtCnqQTR7pIPLMUPn
	tB4rEg2+GK7WGHHsvGdjG0NG22BQ+r+z4rRrN1DdjYtFAlzMBnc+tT2yFA8kK4TkTlKGbjfgZAF
	xVVAae4gr+d3O5Y28843MrwTuKpG1bVE29/CIcCrrqPw7XWXr87pXDNn7VRCfYT7Gtb7wnob37Z
	1dd1ux0QKw8mIb9sBe08OvmiOjk1n/1PavdUjAeCuWuh6smpZ7HQTOqXLJxAGUBM2U6mBcnbIPe
	LuQ5mcjMGZ6slYg5QHE+mmR
X-Received: by 2002:a05:6a00:4f81:b0:845:3033:6cb7 with SMTP id d2e1a72fcca58-86166bc01c9mr34022528b3a.9.1788836679806;
        Mon, 07 Sep 2026 20:04:39 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.04.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:39 -0700 (PDT)
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
Subject: [PATCH v2 09/11] mm/sparse-vmemmap: drop the extra tail page from device DAX reservation
Date: Tue,  8 Sep 2026 11:03:33 +0800
Message-ID: <20260908030335.96549-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0AB8F100004
X-Stat-Signature: t9381jqd5itdhm5exjqny5ijkci4cp3c
X-HE-Tag: 1788836680-449487
X-HE-Meta: U2FsdGVkX197fvjSwVjEpMBk3vx28hx1hzVFlPcBn4ppmCp9dT04TH6iwLMDkQO3BlD6jduftzHeFt0K8p/gOKfF58Fy6s7yia5iT4OIm7wAv8jlVhlFoMxQ2S6j3SLB81h3bxbAw/yn+jzuPwi3R21WzFwIT5ADbrSpUWfHTt8FvWMZUaiZQVtt790trIqFbowAWqfXM7M/jnTmHNHF98wFlnpdR8jTRs/WPF19Dag1wv/F3lknfKG1K/cLr7GojjEu60WU+SzcrbduHYtl//fwGASm/8Z3Th8WP/7V8WOibAl0PpnQT9bbsLkGx4Jvwj0Ly8XclQkoLV8Ihglu1zJ0ZwnACTcZyHQ4uxG8A2X9OxAxwtuEDXI2iUywzwnaDhccOXWuZSSyiSU1laL/RAw3Geeulx6/B1vlb/f+lssgV+BbBcCDQVPKWJ53OVNyC+Lg0Nbo6nQOJ1S9XDnJDrIpsNZ95ZZd1RkwT+86caxLPNOH2gAGgITLyi7xvMb0A1jSFGkh5yD5BoJwFB9i7X6axvEzPVLcMfMqTcKDF9Oi5WEZEx4RWnpCeTsIEGPs3hw1XMbr8RGnkXH3Euo9wxoHG1dDmDizmf6iO/WbqgHusgdk4INK7hLDTa+ivjE7uoXg7y3A711Wbt03t6j8D15+0ftqlSynZ9hyfRINTKtxYiK2u6WqC7CGj9aoQnsYGC6JUGgYHnXGnY9th/bkO2BZKNeg9wUEBQEljdv00ArKerXLZxht5jBfUoKlVqx1SIP/CkDXJf9osZwucrKoIIE/jn4tI6ujtkJGYJcwev48dXDZujVnC6spnLqsv59gQCcnDba6ZBWkHBAxFFUXDiADQUJyREbacQnzpmKljuHmJWKNk65Mbk2G69RQuuSF+UerEf7xq7gTu/fIvXpBXYHIJevnwOzXm/bLk8UYMLWmo/83RuYHoH1ic3sIhneHdQiBlUbUjx2LKWUROfB
 ++hMU3tD
 Dt4/bNpag9gPj7QCywpJ6jekJjbEdRqttpCBkz0tqIJHipzPNzI+BU30IdCiRxlcpIGNn2AtLwGcvYQ0rJKh8FD46W3zUrpCnmZhaLQQrzRdoc6XT+5N7OScPBa3h5XnmNGFbZZBR0iremoCUOxrZMz1LK4yd8uWG89IM+QjVPGWhwF3wjYL9wvpukMSB3KkNBY2nPXEDc/DsTh0MlMiGWahmOrlnqOVgWeDMy0YxSPai8LxI3ojR7CWFVfA976tvSK8th/BBFDsuPQuM+h6fi4mkUrxJ1sIgJdpyCbK/wTEaNp5l6Ip0zAvPxZF5+UbTRIWX
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
index a2ebe87e7654..969594074fd2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5167,7 +5167,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#define VMEMMAP_RESERVE_NR	2
 #ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 					  struct dev_pagemap *pgmap)
@@ -5187,7 +5186,7 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
 	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
 	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_RESERVE_NR);
+	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
 }
 /*
  * If we don't have an architecture override, use the generic rule
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7a2e58d631c2..629420a83891 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1056,7 +1056,7 @@ static inline unsigned long compound_nr_pages(unsigned long pfn,
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


