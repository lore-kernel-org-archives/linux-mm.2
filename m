Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BCCF4198B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31DCD6B009D; Wed, 15 Apr 2026 07:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7466B009E; Wed, 15 Apr 2026 07:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BCF06B009F; Wed, 15 Apr 2026 07:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9086B009D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:14:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E8FD58A3C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:55 +0000 (UTC)
X-FDA: 84660532950.13.0501ED6
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF81B4000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XKe30rnE;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776251693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUwLFe4sJwTmvK33kSzO0AkxCRTRozJKSvcgK9DIV10=;
	b=zpdfS6fFmcva962uFHjxjAStcf2XaCajSklJ2de3TazmprtBsR/mAPjMHeXTwmTqqbuWke
	GFn5SM3y/gbAhDWDrlykI7En4d+X4hID14WRIiPa/6j6768OWSfVjMCKAE5jFvDVTVx0wX
	6PeNPRO0VaIcjeMhhySCIpsT7kLsiOk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XKe30rnE;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776251693; a=rsa-sha256;
	cv=none;
	b=vjlVEQMSK8Bp0g+ahHmGMtov5ftEztTOW+W5MFm6BTIwD1kimTrURtVRcRe3vMcVJCdFVd
	zg0imq45irmEio2kTqBlMI2Nec+kDlui/r28kAG7nqys9Ubh/vLY46Yp35Q8KvN28ZzreM
	atA2I7LbUNMXNbNuF/2DLTDu1GUiwso=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ad9f316d68so29576225ad.2
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776251693; x=1776856493; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUwLFe4sJwTmvK33kSzO0AkxCRTRozJKSvcgK9DIV10=;
        b=XKe30rnER86N/XFMi5s0MHViFpSPlNC1wHTX8cMUq2MRGZFncjYsipJDmVNC1M68Mx
         +w1zQCm+G3bsEm5YaImq93gOUj/HSuqKnBmdcN/pZn+DKEtrl3b8QB2T1yefpNBDhJVA
         tk/uF4WvFADVeFdgNOSoY2/VE0R9nD8rExNzQq+vpOoOeBGByBtqpACaRVDEHo5XwVoP
         GDC0lyyPRCPnANYJxw45U9PgI47o+e165zQ76P7sJ235Lgcmu+9LQ48JUi9YgftCPKka
         blVyzwZnWPPdlmEPT653Lbrkyods6ZPwH9Y0bXl8Nh1oOekseTvXaY7kYa5tvOJchSao
         P4aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776251693; x=1776856493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UUwLFe4sJwTmvK33kSzO0AkxCRTRozJKSvcgK9DIV10=;
        b=c+0GVxG+tjP3c5XfO0Kizl19TpZiYPoh/0i7gR89B1A+7jFEdqp0lMdGDr4BntjLw8
         sxG8gcsc9BhiC3GYGWeLlKbUDKrO5wGzF8fXCEJXFv5oCz9qfhi8AkuXE9mOVefwa5ny
         NKCWGegwtxeiDskt1KXD3Sdz4+shcKg+VM90MZKgsW/FZG5WFxTMzZ98swsYtESFEu4u
         a6ICkTOUyMQBcGA6uByuhfuyo1YF81MqEn+q+yC+0/CGSa09rqbj39QR4wp5q9qdzacM
         JtP8rPPioCC32rbaciCc/ClGe2wuYmiOJa4Xx3HRV4TuS5uODTOLVxmZyBqCYTi7D9GE
         TELA==
X-Forwarded-Encrypted: i=1; AFNElJ/bp/CLwvq6Z2RyMKc7DYisCqkc8xYrL3ZL6+rav6RttSf9Bi9kb+Nf9ExjmflfGTLM5FpC2I3hEA==@kvack.org
X-Gm-Message-State: AOJu0Yz6K3WI2iiK8URA7o6TmiZH2kJkzrAG5BUWCOnB56N6BPSjkKFO
	2n5JciSSahRNVAXaMyg6/q8simlLj1ey1i4pLqVrIYlG/GxngDJkEao9ZEb4zxzTrdI=
X-Gm-Gg: AeBDieuJi9Zp0UougGdbQo8DvYSic072JaE1ie+O/naX57h9cvObZgzo0yFwgckXAh+
	/IksXmfPEA+5e/C7ylKrJAbT4IrdxJrh+XUcVr7jX/d/nqRTvJvychUEujcaQfln5dDmSwiDmL4
	g9aKIrec6JOG0a4Vqg5nRf+lCLnJQiz/Zgg2U80O1OeUXqHFPIUlr4o8Wd3K5GkOURIkyNeknMP
	7mGtEDTapccV434rDlAfNvjs2jhWZM9BJUjnw3PBWe8tNU17LItRMEy5UAjDl1qoxcIaz0fFEPs
	S4bwrp/YwjzbEp+yLbsxT1b1YDfc2KesI7vg9pqKNWyw4UR33pZIORLyTcW/a6Bqv/+PmyXkDhX
	W6m8SxwQ0LogEphc0MbVoKqWuPGe9gVGdMfalAyoaVdWQaP95y1fTYmp+640dyh4YO59MBkBQd9
	hgI0GNHvIJHVc5TLXWMVSUv+nbHCccq2uAJ/sU3rYLip8=
X-Received: by 2002:a17:903:37c6:b0:2b2:49a7:a5bc with SMTP id d9443c01a7336-2b2d5a60603mr217754215ad.39.1776251692524;
        Wed, 15 Apr 2026 04:14:52 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b477fd3724sm19509485ad.0.2026.04.15.04.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 04:14:52 -0700 (PDT)
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
Subject: [PATCH v2 5/6] mm/sparse-vmemmap: Fix missing architecture-specific page table sync
Date: Wed, 15 Apr 2026 19:14:11 +0800
Message-Id: <20260415111412.1003526-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260415111412.1003526-1-songmuchun@bytedance.com>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dbhsrujndshiysppbczwwgt3fdak544i
X-Rspamd-Queue-Id: BF81B4000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776251693-674045
X-HE-Meta: U2FsdGVkX1/iZqYYErboHVMDHc80iMmcmGjmz9lOpjLaE2OABrqezsaAL63QUIjUP37OY7k23JsLwNrRG6YPYmI2fDjVj4A0iE2GprHVxuMuxk6ANmC3rvzmf3S3ibt+bBlGy3Ls8xUIKWLNgkBvEPmt0ve8YQRgyCpCoAgQ5tp0SGS5ZPt2TnOzxNjiGzzDE8GylSooSRwniT8bdGpr12vJ9ps3J7nzJZ65XxrPfeXXtsEpUH9xmJ/Ih7jmSRWKAlhIoDR7epkQmwY6amYjLixUoKcmAFBNavSCVZ1ticoqZTO7F6TTWE6f6awH7QekJZ89N07ohWBuuA6zK5uUjLPt8xpszTd5YnQyFI3UOAah53kmuIIgvc21MgPI4uspWj88I1K+QUvXNhdEQNG83Qm5fe4VJ76ICxJC2URNbeI3MRoRBSaP2ln1erS0zLbcZ4KBJcgKdrzdqvqMOqK7tWeNPPQg7wT3VoyhEFT5KHWvnxAn5qLR2daJFL904eF6oF+NwfrJuuMftYvK3xHzB3RfvLtgI1Uc1XV3/1HsgN+PnkFzrHSn36Tzipi3QTAMFhHxIq/TKrONCm0wdJuht0jfJrPqpT81slFZryVCwo0XnXRaDPv2OVReyYWms/KNGJf8hF4HfhYgBxDx1pxcJrqkLgvSOuP1/fMeAujHJX4MULYBjLRWPh4MooQBuHhyoJj9nXvHDhgtW1rZRD0TwjhzSQpPwpTKWDxCsj+A6+NPxFIESa7GpOFOOmpDozg9n1DlkUSf7WEB7Jgtms/MVnMC2eReFmece6N4NLpfttibVe8bMg5qoQq3U/uL5mX8OM7+1LGAqT+QluTSQPFdew08w7217zMeMhavU9SQ66ZP3ljgZU8HoVwYE3UvwqrdqjmsyRn6aurItcbq+9DdF4ZSHBtQKBGH+FfqhTIs4L396CNv342A1oIiCZr4bcai96tAebQJhYY6WHiGxU9
 S4zOhy80
 cqpoMMpWd59ot9ynReXHiuZIpmma5BKBu0LiJrx/eltVOvHnVloA0WKEy5oqRwG1ze0k5txSbSh4W3EuDAyofRhzYQ7p816Ay1yQ/RcjImJDHAZx8ygtQ3QiGG4oTDC+bGFeH3uxSgnsFWtcthTBm3jTJSAOOugt1wORH/DIwx/6Ef6Rk3mLMQGJB0Jm1i1m7TqZlEhOl4DxBi5Y04Jn8ATVJOttGx0sHugi0s7NT3yEP74C47GNabttehBtBs5dJMQx9UqH1uyfOsCjhtJQwPaE9pBRX1uPrQVI4DhvU6HjPgla2ohSBoTXscw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On x86-64, vmemmap_populate() normally calls sync_global_pgds() to
keep the page tables in sync. However, when vmemmap optimization for
compound devmaps is enabled, vmemmap_populate_compound_pages() is called
directly from __populate_section_memmap(), bypassing the architecture-
specific vmemmap_populate() entirely. This skips the sync on x86-64
and can later trigger vmemmap-access faults.

Fix this by moving the vmemmap_can_optimize() dispatch from
__populate_section_memmap() into the generic helpers --
vmemmap_populate_basepages() and vmemmap_populate_hugepages(). This way,
the architecture vmemmap_populate() is always invoked first, ensuring
any arch-specific post-population steps (e.g. sync_global_pgds()) are
executed before returning.

Architectures that override vmemmap_populate() (e.g. powerpc) handle
the optimization dispatch in their own implementation instead.

Fixes: 4917f55b4ef9 ("mm/sparse-vmemmap: improve memory savings for compound devmaps")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/include/asm/book3s/64/radix.h |  6 ------
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 16 ++++++++++-----
 mm/sparse-vmemmap.c                        | 24 +++++++++++-----------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index bde07c6f900f..2600defa2dc2 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -357,11 +357,5 @@ int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #define vmemmap_can_optimize vmemmap_can_optimize
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #endif
-
-#define vmemmap_populate_compound_pages vmemmap_populate_compound_pages
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap);
 #endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 568500343e5f..21fece355fbb 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1109,7 +1109,10 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 	return pte_offset_kernel(pmdp, address);
 }
 
-
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						    unsigned long start,
+						    unsigned long end, int node,
+						    struct dev_pagemap *pgmap);
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
 				      struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
@@ -1122,6 +1125,9 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	pmd_t *pmd;
 	pte_t *pte;
 
+	if (vmemmap_can_optimize(altmap, pgmap))
+		return vmemmap_populate_compound_pages(page_to_pfn((struct page *)start),
+						       start, end, node, pgmap);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
@@ -1303,10 +1309,10 @@ static pte_t * __meminit vmemmap_compound_tail_page(unsigned long addr,
 	return pte;
 }
 
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap)
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap)
 {
 	/*
 	 * we want to map things as base page size mapping so that
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index f5245647afee..7f684ed3479e 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -296,10 +296,16 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 	return 0;
 }
 
+static int __meminit vmemmap_populate_compound_pages(unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap);
+
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap,
 					 struct dev_pagemap *pgmap)
 {
+	if (vmemmap_can_optimize(altmap, pgmap))
+		return vmemmap_populate_compound_pages(start, end, node, pgmap);
 	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
 }
 
@@ -411,6 +417,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	pud_t *pud;
 	pmd_t *pmd;
 
+	if (vmemmap_can_optimize(altmap, pgmap))
+		return vmemmap_populate_compound_pages(start, end, node, pgmap);
+
 	for (addr = start; addr < end; addr = next) {
 		next = pmd_addr_end(addr, end);
 
@@ -453,7 +462,6 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	return 0;
 }
 
-#ifndef vmemmap_populate_compound_pages
 /*
  * For compound pages bigger than section size (e.g. x86 1G compound
  * pages with 2M subsection size) fill the rest of sections as tail
@@ -491,14 +499,14 @@ static pte_t * __meminit compound_section_tail_page(unsigned long addr)
 	return pte;
 }
 
-static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-						     unsigned long start,
+static int __meminit vmemmap_populate_compound_pages(unsigned long start,
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
 {
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
+	unsigned long start_pfn = page_to_pfn((struct page *)start);
 
 	if (reuse_compound_section(start_pfn, pgmap)) {
 		pte = compound_section_tail_page(start);
@@ -544,26 +552,18 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	return 0;
 }
 
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
 
-	if (vmemmap_can_optimize(altmap, pgmap))
-		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
-	else
-		r = vmemmap_populate(start, end, nid, altmap, pgmap);
-
-	if (r < 0)
+	if (vmemmap_populate(start, end, nid, altmap, pgmap))
 		return NULL;
 
 	return pfn_to_page(pfn);
-- 
2.20.1


