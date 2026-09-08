Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46010C79F9F
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C22F6B00B6; Mon,  7 Sep 2026 23:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572B06B00B7; Mon,  7 Sep 2026 23:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4618C6B00B8; Mon,  7 Sep 2026 23:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 179916B00B6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A37F3C035C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:20 +0000 (UTC)
X-FDA: 85189101480.21.D297413
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id B96B020003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=T2lZxIyC;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUXKrxViB50EGCJ21IU1wh3SHWR1crLUNz3m8pEDEC8=;
	b=TrYFFWzyta0Qf2avJOfUASWs1E22WoYWedIrb47tWHsmUHPQ4cl5/1j0p/sLKX739OR/zE
	SreSO7vdvYfSstXlUWWbnsgVmL6Kaj7wLYUb7WZ0Lltw83XBCscBnlgOMKAutdljHl3lUk
	QRC2wzSW5YoW6aHZPo1zZYZQoXSGJF0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=T2lZxIyC;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836658;
	b=NH3mu3SmU0CbRHN733Mti4veDZ56+BFkY/ciX+XIRniyoNHM11ln9ujZ+Kkn1NDdsugcRs
	5MRyPJWmQys16mEVDS0sDMZs6HzNEsQKDj3wbJE2lm4Cwvl22puzPtbCZKk0R0a5WTqIKY
	X5VqkcCQmdzSQ8WPexuLiwer1JPQip8=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469e2254dso66639b3a.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836658; x=1789441458; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IUXKrxViB50EGCJ21IU1wh3SHWR1crLUNz3m8pEDEC8=;
        b=T2lZxIyCOVjp/f65GmTzo5n2JszwfQwI9z+jAYqwKUSd1Hc1RogXZKJLdkNm7LrBCN
         F9d6lSmRi5i79TIvmfFugw6McEGjnNGcrk+a3Iu1GUWrCyRtgSFinn3thp2eTcY9ztpY
         Q0v9PR5Rg5YwA65/aG/YLvtRJiILDGkbt0x+1Ghp7Anp+Ti6JV9LGc+9LA3MfBnMC1ry
         sKBdrbJ2NSgjjgejnS6CzJd31K4eZ7E7j+KkhzdSBj/PfWDjChiCd3fWaPTolrKaLmIu
         d9hnoViAhTITOmssEFHeoRNMNiPkbEun7q1cib7B42lKdulql2FDXl0gu2ZYSoGVPEDV
         KlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836658; x=1789441458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IUXKrxViB50EGCJ21IU1wh3SHWR1crLUNz3m8pEDEC8=;
        b=CBLL1quoFQzRFNLe3jqhTOeldZqGHYIYHWNXzgo6FmoV4q0AF67rTlXPQdiVNf5Yoj
         uF6Njq5FmtJRiiDyc4DKoSl9kGs6yMu2xFPNUsbTy8H958wiT2BdBO/VFuegpFV9pz58
         IoOqo0j/tvQhmY5/EvWpE1cOr9IvBpTivwdSh9g/BX/S2ugBoDX+UuGwNsdktxVS34p9
         6rAk+Bqc02FX/KN5tYrZikj+zR4UEoLBZKHeC97OOHlMQhm4Oc5FPM8BGKMZQ2eiymPk
         J+8j02vahN7h1ZLRToeo613nc32yBFyLZzhRUIucGYCzd005CGmuJuImp7ea772DTE/J
         v1BQ==
X-Gm-Message-State: AFuF++mMUCWkjtaj4KhCTpF8ixL+4Ng9vWN3ltzTJmSKlLcwvNuwS19D
	LNr5Eqa9PSBSsajnMSqbz7uNOwfwMXW5f4nqnvuloP0rXvszlJWhvaIMjZfS3k3urC0=
X-Gm-Gg: AYBFou3UZItwgOyeZE2vu2syvdji4HItGLJvgrSheV6KEgz7Yaab2muo6/xDiZiO+rw
	E62k6sF2LnAbbsEJHA0ZedeCWpUVma5NWJNGYzZrU7NpIZGXKhUkceE7vuiP9Zh6mRPiiI5iGwe
	kg0jsMwd2qXW9ALfmoM6gnpwVGO/ywDQ/AWjKyXcLT8yTbknMGRgK9Cfv3jQYJSAgOdjMijU9k6
	+xwAp9r8+068yDIJxgGYbN4rdZp8nEad2FsNqowr+FpMLNabbkrkMptHtE9ZcJhF+EyfgVq+Wh7
	CuuVeuEtAXkm/h75wzE0e9HLPDKvIR+ENq78K8ykajhHr7P2M95OvwN2wv5g+wbyCEdGC/Aaneu
	KAr1aNae8/sGcKnWKZ0o20b/EpGNFOD8ef1biYTpWYBjR2BcBAID51hR/QdeRXEQj3U7jYMGpdL
	0VdhfEYAAjTv2If2oSY09PSk9+tn8T8hUqITSG0uZ5fqwfFeSq+/aP3iNjH86MxwKQ+SQneGxdu
	16lvhVVxegC0wTX/6SL1Vcg
X-Received: by 2002:a05:6a00:1807:b0:862:bb07:2ba1 with SMTP id d2e1a72fcca58-866988d9942mr4431251b3a.4.1788836657402;
        Mon, 07 Sep 2026 20:04:17 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.04.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:16 -0700 (PDT)
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
Subject: [PATCH v2 04/11] mm/sparse-vmemmap: prepare DAX vmemmap population for section orders
Date: Tue,  8 Sep 2026 11:03:28 +0800
Message-ID: <20260908030335.96549-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B96B020003
X-Stat-Signature: xkpo8q8dwgdpniiu9k8mwsdp9ia8c7id
X-Rspam-User: 
X-HE-Tag: 1788836658-998396
X-HE-Meta: U2FsdGVkX1/gvSFIRpW2RdrHEp0o3lZnmwEOf8tRZNxVcyWgx/JmJrRhnHF7ULmd8MqSrA0/gMf9mR8vFKFwZNw9smelwRNJpvnUQzY3qpkeEc8+zczHbphGNURUoZ98clOIx4tbFwYLA2px3hnpL2nhy9YPDd2BPTL+5EFvYxqgkdQtLVhLuhqFTWylvreFlkXG7qvpB8HtlDo2AuknatOYVjZUYBazs/6imvSBME6/f4rEWeskGY2yXsPsk0eXLs8V0RuzidcC8xIy2uw7VI314WHVMncousVIxZlpvoOMLP9fD9WKhTvqTmjc/oqeD4v2qO7SPH0HajFGj/mgemdAiYHoj72eI1CLlSTBqGlGK8pRJmkn1Hq6Fb+UpzuqXKYq6vvI+DDkcKtIrrG87l7L2PJFkSaSvrdUdjFwi3aaO9oYB5fyvLTQnhH9rCuoRoaZ1iWETo1Sd7z+ArkKpza+ajr3IUmiMfi78rT4/y6B2Q/U/6G1tABsSNMV7u+BFY7NsiABUIbXQhXI9hd5Ul8Bwnb+1QHKzjJiHOjPL2xwu8h7eGmCC/E5vAr86lkfoE31OC33jWwkv8Wi+pQhrYRX7YEodzW9tBZr7Qbl3U54YjY08ZtEeYhiKsv1wTGmR0Hel1TMW6JShK9TCek+cLREa9qCAo5zxZ6gPlQZadx7Ag2Ku+GuJhhF6fhGmDU8BmzbDjLchgwPBRYf75T76GGiZEzxth1Opq8sGpNFCgdWJ6AEejpsGAGTryfW5gWjzh4dHp82JS12Gov+5P05OA2Q/JI6xaR8KtUxFd1CR10UQ1KW0+xsry6JrH52xCv172/47OZ7y873zVlPl8+rkJxSaZcdLt37q5RL86U7bsVwoxT5o4VSKhPTEhla+n1VfGqi1lCbltAduP9Vkl89LU8NklU/fcUwj+pFbqJEM9dmXUp5LOlecp9sfgZr9ScQAmwy694RHyFD0Jo4iV5
 mmYNJpVL
 oNUF5KXpmXZvzTGyrBmhXyHYhSMjHChUBfnxmqzwHiaPA20X9quNmWq1wzIkZy74CxRF0iy3OdaVpepRuQV9VsSmw6UbHLtS7WEeAvGWhGj+jXIVhdnWcST00VomIF3z73l4p+ifz5dDjXB1k2HndqVypKabm4nljz8ErGuv9harMoHJ8gA8ymB9T5bdn6htKpGoq9FO8rziNsamrjsSd28cOZm2I5GoCF+y2FPPtI1oVQaHmeUPNVHEFjXH/2QLTcpO/bsNzhYtELpoZr4sdkImgfgTWSEiHZ7xrQ8aOjUHCHT3yps12dwPdRQ==
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
population path yet. Once a later patch records the DAX compound-page
geometry in the section order, DAX head and first-tail PFNs can look
optimizable to the generic helpers as well.

Add a DAX-specific population flag for this transition. It keeps DAX
head/first-tail allocations on the normal vmemmap allocation path, while
preserving the existing page reference for reused DAX tail mappings.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e453ce4675a0..54ae8c284324 100644
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
 	const unsigned int order = pfn_to_section_order(pfn);
 
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


