Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2100CCA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E596B009E; Wed, 30 Sep 2026 10:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245546B009F; Wed, 30 Sep 2026 10:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15BA36B00A0; Wed, 30 Sep 2026 10:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0C816B009E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:08:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6123EA743B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:02 +0000 (UTC)
X-FDA: 85270607604.18.9CD27FA
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7477940002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=h1izJ5r8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfMxtfxa+3COrIjgzxsQNjSW0BqNRs0OC1S2RzR7Pys=;
	b=Fm+1/8dT1oJpbO4ra6MAkBSC7OUcs+FPuk7VNd4tV1JfkH32YfXpzoZfQ6KLCiqQUZG4mk
	bBrCS/HSCzxrp3m713e+vnN+XXIqfJ51900Dh6l0FGjf29X13r9Q+jn/FI3owHsEe5jPU5
	jiPLr/W8O03ymQfFxg7GcXLh9BwTPGY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=h1izJ5r8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777280;
	b=JtiEMiTzK7fXPVpedakY8uKSXF2eV2o4xHs8HPcQzulaIVu2N8aE2n67BlDZ+LTRSXT6GY
	GgdXcFjYkmvKv59/CyLu2iU5e9bnkjkkef2h4imlSfoS1XC4b0XMHTV1ZPnnqFFSi8lv/P
	zVfbz9W9G4a1PM1uh3jEnLTR3LBYv70=
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4c08393b0so2399290a12.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777279; x=1791382079; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SfMxtfxa+3COrIjgzxsQNjSW0BqNRs0OC1S2RzR7Pys=;
        b=h1izJ5r8jmsl9q65N/cqG9ISY9uEG8of1RBEZYpPLSMy/chlQLsXaqhgXmy0IPJ7Np
         e2sMLg46HdsDDAnIofhlBjIOznFiTZjQfobl/eO6iIUQDJflJ8SBu6x4in5R6snCZwKW
         su9HDICyhX0M2dt5RTDdfaybaeENJjOj63NNITD4h9ETvuCR/jlbGHKzXXpixpiHC/uP
         9Xdfze/HoeBRGotsUFH9dg3jBo6Fk5nxT0Yy7AtDjd1YeWOc7YHdQjgzuGAhMeOA/ytx
         67dX0un8bbFWYPouS7HHmAE2YdnbskQU5mUxODqOvH7qt7PHSIADqQ2rIwV3IGV4Dw1w
         zPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777279; x=1791382079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SfMxtfxa+3COrIjgzxsQNjSW0BqNRs0OC1S2RzR7Pys=;
        b=aCWt/YqYBAYVa8SDD1r2jbwwC+ldJZ8Qthbu4FBLk848KEMVtnIcS4uCZcCdO0qP7w
         KvPFynnlpg2S3GKuVXlC8iHQ+FH3JIrpX15abPhBi4yjQIdPNbCXV9mjL6OfgqUq7bKl
         NYp0ERTRXU6fqruKXFQdIL4AhR8fCrDyBCTPFMGruVNSk+8jJE3LjzBRpOzs16bBZHSg
         lfKvIL7+Yg2Ek/8jkmZ1BE8sFgAf7YRUp4D5RZkdRsHlhWMs0CgyMi+aaQK8DuYqgMIh
         4xr1JUY4Zuuz4/0dYBq5FbJc8NnsDe3waEwZs2dY1f0LfB8WDIYO63E2XTVTGTAUQ7U9
         Cz3Q==
X-Gm-Message-State: AFq9FYIKcSH6UOigI+3js411Uw1/OnVEOa5qUhdaT80C3qxkuYCNmACV
	ln2PlcD8vH0i8I1e5bda7+uoVvX5s7rR368Fb9z5yZw8Fy5BdvoAgbCcUlq+t+QCh3U=
X-Gm-Gg: AYBFou0mSTTm4KifR4LS48jb/97FrxzKn/Rx/7dkTKw1W+7aexMnZ/j9hT+AEQwqQJV
	e2BIYmAlcpPNo1O/7qhWhkZ0JPNfxC6e2EtoVIh40b/Yd6/hsjGVgxSahgs1n48L2Ch4XY4qk+5
	WZsVIn5lSMtqb41PAVBOqia1fwdRFbEtqG2ZkofFUFp1R1kzBzWtTTKaN0m8zedZlaElrRZSJrl
	uvM020QLRb4hbTI2QZb91IhXrMWoXyjQdQOS5kp2FzJh+NlMhkkuKg98apuur3YX9Zgz3jZWpQ5
	EEb9eq5RlvWvtHqwKSU5ca+m+v+hEscFkAUX/VjczrhH4Q8aQWoRu6ZbuQcIypkUQQp6guNFi3J
	dbCe8MY17yjzxq4lpv8whNPrw/euFGH3e7hDq942G/iMpqJzA3nFOIuf5J8WPYpUGvxkIkXkfJe
	kif9/VhS75x3uq8XMHFRUqD8eb/ekaNMjaXv1cr89wMh38MDsaYplsbMFhdQGsWYJDD/4wW2X6+
	sVER8JLByy1Ew==
X-Received: by 2002:a17:90b:4acf:b0:39e:4c7f:8b1b with SMTP id 98e67ed59e1d1-3a4d19d23e4mr1306484a91.32.1790777279220;
        Wed, 30 Sep 2026 07:07:59 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.07.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:07:58 -0700 (PDT)
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
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 05/12] mm/sparse-vmemmap: prepare DAX vmemmap population for compound page orders
Date: Wed, 30 Sep 2026 22:06:20 +0800
Message-ID: <20260930140627.57431-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9t655qs9qejna8eqhgukgadtzzj4pa1o
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7477940002
X-HE-Tag: 1790777280-453310
X-HE-Meta: U2FsdGVkX18A9E+PAC4+eeTEPqYQt8y8bmqbu1PnQtkSfSigeBthJWC56V1k6Sf0DeIdpZNelu5vbl815oUxMAamfinf6sSkTT1YBbFlcz1uOZWFcv1jD9ljUUFjcH9sHK/AnnIaP9O9d4htzAi8bZqEWOjGeGT1WuaBwu1i9w0tpHFiG8fFzfsftsoH/5C8LCYtUbf/uW0LPfuQUWHQhTSFrQ/ImNlLcRCNAitKaetBEY5KHAwGtUJ8i78m+xJwxZ2pq/zdqrnHxfxRHmzEMfuOCuYSbL/TFLhQaJHW9GqyRchNnyipWoEPWFMNlDRsa4cy9GVgaogw61tG01sT+wVBWHTMcHG5+luQ5PVtee2/+kyczHMI0ZhDe6Nnl5TpXbiESBwYUCvaxs3Np/igKBJpUHtGN9Db8AGfRRZ5Xm7ajljyqceg9Wew2Oi1YuxQaP+0ZmUwJ+ytzy0kfI8UOElS4h1jEDJFq8LD/ns3LqD2U+uqBvpOqp8GFHU8Dxft/EpcqLwHV+XrlPe4U9hQfIXjix1N+I2DyO2z2aX0fI2s/AHV+XGS4m76GnG36ZbSamqHaRnWv27jq5VbpArnzN6N1GRmUHTmqrcGae8jUHQ7qFnO/ji82AD7ql9ryj41vWmj27NGeW/PW+Gin2nolNTZ5FCR7X+TW7IGZCaRT8RXLL8m5xwaDm1iwjaIlbvxyUeVuiAToPK3E+zO/2CPpYF7+jtPdafQyQ2J/V8kQ0tWEE5GK9uoBaZGloy3nFVCUftkJCi4B1eT86dxkLtd8w3EzATsQiwXbTPVzU6R/D0ioRFL+5Fs4dM1+YNJG8fKTmDDNj/agSkpacYaXEnCzLTMANgNFdkTgCME9aIlQ5jZtlFgTlw+L5xBXursFXMywwLMyjiiEgTrnseNteCsX8vYK00ISIbJCP3SDRH0ltrI3LPtZJYzXipSCu8aNgkQ9JlildvO3wmT2CNeC0+
 QcaHZ/H6
 vau+iD8BegSAPr7f7e6d420h0SSMkuwMoObyw3S5O6Bo1Xp0gmQ30LjQH07JYtZlgBr0sRxlESk8MXFrKPQ2umXfOe0ZajG1hTDOX73lSMWo7BQkVd5iehS8PYJdx3eazq8MXYmSMfMTV6OQAwGwxthUCsSGwX4alfpZYKwrWMDs4a9LV2dZIrVskPhHRAz4WdPXuoerra7obvVATthwkzdvObl+sDQM6IkNWag/IclnJxDfo3dX8mDgMo4EG4t9Zx4kJwSP27vS/l181zTiGUJtf57/XChyAOlHw9a6CB3E5BspSzTOtINV4Ziy3DUHfpm88H6K5UMGmCfpZ+MsFnPd1LrxBUf9oZC56ydMePxZeDo1kEVieKyNEs/KCam0QwZUCaD7B9EMi/sqiiHOsRq7ZruhHw66zZUmJ
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

Rename the existing VMEMMAP_POPULATE_PAGEREF flag to
VMEMMAP_POPULATE_DAX and pass it through all paths in
vmemmap_populate_compound_pages() during this transition. This keeps DAX
head/first-tail allocations on the normal vmemmap allocation path, while
preserving the existing page reference for reused DAX tail mappings.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Clarify that the DAX flag is renamed and used on additional paths
  (suggested by David Hildenbrand)
- Make flags const and move it to the top of the function (suggested by
  David Hildenbrand)

v3:
- Update the subject and commit message to use compound page order
  terminology

v2:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index f77e6e1e5a8b..b4b72f233bf6 100644
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
@@ -247,13 +247,17 @@ static inline struct page *vmemmap_shared_tail_page(unsigned int order,
 #endif
 
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
@@ -275,7 +279,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
 
 			if (!p)
 				return NULL;
@@ -290,7 +294,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_PAGEREF)
+			if (flags & VMEMMAP_POPULATE_DAX)
 				get_page(pfn_to_page(ptpfn));
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
@@ -547,6 +551,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
 {
+	const unsigned long flags = VMEMMAP_POPULATE_DAX;
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
@@ -561,8 +566,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 * with just tail struct pages.
 		 */
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)),
-					      VMEMMAP_POPULATE_PAGEREF);
+					      pte_pfn(ptep_get(pte)), flags);
 	}
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
@@ -570,13 +574,13 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
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
 
@@ -586,8 +590,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
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


