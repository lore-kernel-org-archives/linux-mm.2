Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E119EC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A436B0096; Fri, 11 Sep 2026 01:03:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DBF96B0098; Fri, 11 Sep 2026 01:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017DF6B0099; Fri, 11 Sep 2026 01:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDFF76B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:03:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DFB611406DA
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:49 +0000 (UTC)
X-FDA: 85200288978.10.7C2507D
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9389680004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S9pW5joh;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103028;
	b=ZKgUZ1yHZcmPMKT6Jf30FirehZU9avRoh5M1U+jI5VvZLl9juhDAcldyRjwMnKYHjy90Do
	K8tQNTJC+6+FdAuV8mKe7bNNZ42RZCbF69Or9TDXGKtgGtBZxVV1qMXpLB5oYSKs1qEKnp
	bbcAnVSSAVwdw5aHC1NW48vxok0oDTc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S9pW5joh;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrSUwqa7xtL2ZBs1WlB04Z11tmz781BnHoaaNOznkvI=;
	b=XP1HwSxmq5B1LJ2UOkqsXuxdufTmLbrCX7lapoVRdU6yMDYHzhxsu5WpnNPYqM/OrHLMwK
	jqjzsvsUKTSDmOMSRdmU1SH705iwpYZM7sJ7fz7IaIbbCLbJ77ct5ZERE71g8p4vvsvG+e
	3bWGaHD9QDm9R44YF9PLT+mS0WqDnPw=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea4bfb6so272894a12.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103026; x=1789707826; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jrSUwqa7xtL2ZBs1WlB04Z11tmz781BnHoaaNOznkvI=;
        b=S9pW5johgGZxzpi0tPg2GPjfUoullt75ZmBTofxCf6xPIRhyOXmrT6gIpEb/QUjy0V
         Oa02mnYHIqFamqaAZIDFpQiCcJf3hIz1lkjXNMOSNNhpyChn1ufiKr4nsWJ3hegYD0Lr
         6ovxSJkr8w8WdQararWW+tAMxozlD7unjlHLev5tkLmXSjcCxd7ncVXy8j7ljIYtT8V4
         J4UodDU+fPsTW6alSCOI9469TyvKVqAZt2ZPbYSnn7jKGyC6Cieljzmn9CuBItgjQFTQ
         oXUCIGIAz9tOvZJLvuMaDNEcgealrxMisv9QyH9qS1T4kWewPZK4Z/CeS+uo/h54dOq7
         eXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103026; x=1789707826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jrSUwqa7xtL2ZBs1WlB04Z11tmz781BnHoaaNOznkvI=;
        b=Fk78i+t9czESa4p4DfZqSSS3XugFnjBlP1UDrmyTRQFjwR8MIZbhpmEhrcCvF1kQCO
         q9DEZ+f1iIZ4ce6+v9MVBttZusQqG6ttn33JCWBe8RZ9AhtNpwpzuKouv8kqRgS365lW
         VI3iTEsxZ55ib83zCIZ3+sx7tFLnEPDEz2Op4+HMYgtRCOOgIiflxkoJns6eol+LQF6A
         GXw6TELtOtv+sqGcp2D626+tq8eYeclnzL5/NTMNVwgmYnKnFh+LqalX2e9I/YDlFny4
         oIFgKfhwDMYl0wLaq/8v+9u4NTN0gK7ayguym0wBQkVfaSypklkd8IvkqCSiJHBM31b4
         2wkA==
X-Gm-Message-State: AFuF++mUuWyrX4z7BYie8ukZB8XIDida4rQ3yPlDgpv5wP4qPsCmnJSL
	7uT6SP95VQCsrKtHsZkg3fSeE3faJuUJhQxTKZsUW8bdx4v5HQUcLAazsYnOS/b1zZY=
X-Gm-Gg: AYBFou1dhUeoWqQdLAS1UU+PUPFrvUXLyMv0kGyJraIEXd3FvGawLGLei7pnodEbsQR
	g8ZmvhBNF6tUxoWh3FsSoN3rm6buqLE8/6rs8sctUcb6D3JoPHJqFV5I5SzAKiBuvlS00WpEoKP
	tKdmwjiHXkln7++I8R3t4UMuN8OyyE2+OFolFkJuILB7ZzJdin44db7JXn2i0Ipj9ubtyoL81sz
	vj3CoLP7d6y0GUow69T0CCNI6tad0//tVih/lI7LeVG2MFxQ9SVwV7AwynoWOr3xxH1liwdDLpV
	LX4cSls/L/eqCHUbj21+MjwXAJ3UD/fq7J2lH66AFY7CS89BTnYE3ihwvWvSu0kH+iM5wn26ejT
	gQcickWKrrAcVVPOkzqidmQJyeI/TS+hkm6jacZIFOkwwGHIIjZG/FMp1qQpIE1TIlBffpq0sVK
	l/bftGPsgNahsXPSNri6kO6NiKeLJv6o11A+ayJmOOa2zy1iL3x5vQ8XjE8R4pSr9IlcgXEswl2
	jzgH+Mky0TBOZCtUtEpTbpXciYUPZpfxral
X-Received: by 2002:a17:90b:390f:b0:38e:bbf1:de3f with SMTP id 98e67ed59e1d1-39d9c0b7047mr3845524a91.12.1789103026376;
        Thu, 10 Sep 2026 22:03:46 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.03.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:03:46 -0700 (PDT)
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
Subject: [PATCH v3 04/11] mm/sparse-vmemmap: prepare DAX vmemmap population for compound page orders
Date: Fri, 11 Sep 2026 13:02:21 +0800
Message-ID: <20260911050228.58884-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9389680004
X-Stat-Signature: 5s335figrjzmmi1wjeapzre9cge98uzt
X-Rspam-User: 
X-HE-Tag: 1789103027-958668
X-HE-Meta: U2FsdGVkX1+/c5e2H0D9t5vEPcIQ/hpjRe4lHzCwhiO6FDOALUMi8m0ik0lJeXJZCNiDnwAFwEjj0YotQ5TC5mZu/kE3b7A0ruBAJbs8RyhSAFieF0QQe0yx/+DA1eF79LdIuVrcG453dKhYrWBD8xAPIwSdEOrJ0/5ajZk5rRh6HRjGlVYtKEJyJZwp5zqeAlcv75iawaboadBJ1UI52firGmGgb46sKb1iM4gFWW2iMVkGvacyx5Emz0gD04QnlkbRSEUEzfQlsks5tmW7vX5JTOQrT5sNpcDkGk7izwKKNH16TE6lgn6P7+Pfbnq4UWPE/tG2cPu4eLFbeOkcxRIq/dqMWcXZLiTjsrTGwjady0nUX3tgLp8W+J5v57ZuNwx8G+vja2vVrBRvZgHjzX1EQr6URfG2mDJV4OE8ozl/Dq1mKsecQlFnLK8wTjtWIdf3hxUKlkIsD/nrsbSL9KaO8wDwjsUjVa1MWt+dYc55RHyGQc5miocjmCz1kidJs5Y2NmhuPqG/mZ6S4vHojpFGZ1YFLDmWA/vOE7UHvMydtNbR6S7/ioiewFuR4/6sWKWBGWNrTqmL8zF5bZ6TqVdZPIpeDb8o5zjY2JNIb8oZLbUgO3Lj9vU92nFKcGD5MJYse0vB+SSSOiuP2fiq7dWjUz9R2fx6neevr+57X3Q4uDM2PFgrWZsMBSNkzbVt5H7jpLZD1FkJOouStn4ljVl2A1/WDJG8MDJyPpksvPD6TSVkhrmJJmM9zTsSQkSkIj3+7AAvH5bpqRvcfn3XyBxCdyDTATNzzaajV8mlsri78DbuoUs7X62uim6fFOP+6Nv3QWYj+vyPboZKn2uFicrqrI3RRPO2SIrSDqVODlx4aHjG8LhZplVHWjEW4kdPOcSNBjXUkbhJ8efXGDEzPGlint/JO/kOe49YLyEGGr8GCncldGlSzJMVCtEgK7XF0JJ5ZhVvdgqra4H+XxX
 Tb8O2/YA
 /yp9ov3WUTfidW3QHSzB6IyQLGpWjsiGLD1SLhkDfIgHhpGIc+sH8sq2t4IqoTWx/c8Xb3jF374DZK2HKYQ0RkMailuPNFuwtMzThwr5PSTka7CGSO6NpUJsyRaNiB9HDJVHlsGozOvKSD7y6da1KQwrA4l8TptW3x5UKtBY6t/1xxx1nQUX7yhieC+Zgqiqj1C/JyBtgHV9yzxLarLERwh5LnEBwzI3sG07ednlNdcWEJ9Cnfs+yxeEIUlS2VPEojHujTvMJOwK2lBglvYvYjs66Bdf5KI77OSODFfJlEm/PcPqxgOzNm+kOcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device DAX still uses vmemmap_populate_compound_pages() to populate its
compound-page vmemmap mappings. That helper allocates the head and first
tail vmemmap pages explicitly, then reuses the first tail page for the
remaining tail page mappings.

Device DAX is being moved to the section-based vmemmap optimization
infrastructure, but it cannot switch to the generic section-based
population path yet. Once a later patch records the DAX compound page
order in section metadata, DAX head and first-tail PFNs can look
optimizable to the generic helpers as well.

Add a DAX-specific population flag for this transition. It keeps DAX
head/first-tail allocations on the normal vmemmap allocation path, while
preserving the existing page reference for reused DAX tail mappings.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Update the subject and commit message to use compound page order
  terminology

v2:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 861e09b2b096..aa89c16f7fc7 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -35,8 +35,8 @@
 /*
  * Flags for vmemmap_populate_range and friends.
  */
-/* Get a ref on the head page struct page, for ZONE_DEVICE compound pages */
-#define VMEMMAP_POPULATE_PAGEREF	0x0001
+/* Vmemmap population for ZONE_DEVICE compound pages */
+#define VMEMMAP_POPULATE_DAX		0x0001
 
 #include "internal.h"
 #include "mm_init.h"
@@ -208,13 +208,17 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 }
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-					 struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, unsigned long flags)
 {
 	struct zone *zone;
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	if (!vmemmap_optimizable_pfn(pfn))
+	/*
+	 * Device DAX still relies on vmemmap_populate_compound_pages() for
+	 * head/first-tail allocation and tail-page reuse.
+	 */
+	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
@@ -236,7 +240,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
 
 			if (!p)
 				return NULL;
@@ -251,7 +255,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_PAGEREF)
+			if (flags & VMEMMAP_POPULATE_DAX)
 				get_page(pfn_to_page(ptpfn));
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
@@ -511,6 +515,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
+	unsigned long flags = VMEMMAP_POPULATE_DAX;
 
 	if (reuse_compound_section(start_pfn, pgmap)) {
 		pte = compound_section_tail_page(start);
@@ -522,8 +527,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 * with just tail struct pages.
 		 */
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)),
-					      VMEMMAP_POPULATE_PAGEREF);
+					      pte_pfn(ptep_get(pte)), flags);
 	}
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
@@ -531,13 +535,13 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		unsigned long next, last = addr + size;
 
 		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(addr, node, NULL, -1, flags);
 		if (!pte)
 			return -ENOMEM;
 
 		/* Populate the tail pages vmemmap page */
 		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
 		if (!pte)
 			return -ENOMEM;
 
@@ -547,8 +551,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)),
-					    VMEMMAP_POPULATE_PAGEREF);
+					    pte_pfn(ptep_get(pte)), flags);
 		if (rc)
 			return -ENOMEM;
 	}
-- 
2.54.0


