Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9314D6D22E
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3399A6B0092; Thu, 18 Dec 2025 10:10:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225246B0093; Thu, 18 Dec 2025 10:10:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7726B0095; Thu, 18 Dec 2025 10:10:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F1BA06B0092
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ABB1D57266
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:02 +0000 (UTC)
X-FDA: 84232927044.17.5F1A0C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9CCE01C0017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kia1AatV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070600; a=rsa-sha256;
	cv=none;
	b=oDOX4xydFNjUy+Mc9ZlMrrYgQ52dNwDh3NlsgzEjUvN8tPqOF6pWrZ4U6zcXYbI4MCxUIW
	Vtx9zFOqps3dVU8nC+Vz+JRHdCIYQSZapQm4xqiiC9BcWvYiIKKzWBLmSfHIA0xt9eZAgn
	8RwwUfGkkFeltP567Bnp8Xn3lOrHVBM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kia1AatV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5BMU5JfOd/dxQa9GdFoeWfvFs+DIey1AjebsWl/P3o=;
	b=OfI5+hZb2fOzr/O55jpDbGeKfgybiU70jlBhD2FAt2uDFm1IqFlNGeb0x0km2xNtD8562p
	VpTo1yZJD/gung0roMpvz1fYKDNU/6KxtwKHuw6RR2qvYyjvEUGh04uNqDSwjQiS6Wnmsr
	VvA870NVKYCwVjOzaPh7QAhWjGRxeI0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BF5B4455F;
	Thu, 18 Dec 2025 15:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD208C116C6;
	Thu, 18 Dec 2025 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070599;
	bh=K9GBlBtYpSZXuseHmhW2j1ffiV/Lm8i046/4kaLeIKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kia1AatVxZOsB20/SxEWErcPFd9EHhiAYUqqkkoAh0P9S8BdqkFQi5nGpKlkgwpnV
	 VzF6uMsQ+Am22gEnOMKBrlWqbjdQIyBzQoXyr/T4M3IUctQcaUvqOoJ/Ik/NqG9ZG8
	 HpQqszWX9JArH7DKIcLR5mEpkn0CnRlGOf6BcfM02rA0EQYjc5ijFwKeUMHap2bYQY
	 Ej/+1w7EG1fPAslfD5bYxRztYAzsTg4YiGoj/ReiR6yFdh9Tb2TWgLSQ1OSIAguaCf
	 dz+9mkj4Jx3zEpvmnKVqugyZIcxqYv/+ORsw4uFKlIVBHIlG+vqD6oxoRcgVlLkTfm
	 g2VgC+ZHLc1RA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 14C63F40072;
	Thu, 18 Dec 2025 10:09:58 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 18 Dec 2025 10:09:58 -0500
X-ME-Sender: <xms:RhlEadXExsBizzWcFUrmGmbiK65pUlI8j1H0ax2s_sor-Pq7jsdyNg>
    <xme:RhlEac1ki_iuIXQJLBO_RyBu8KAKjkDvVx80E1t9rJMjgkxExS-TFFaaveh_VBaGt
    wEtjMX9iiWz_yWc15batORPEg5w4NNL58hHw98l4u-XaOpI9VNAv3s>
X-ME-Received: <xmr:RhlEacMNRd2fWU-zo6voeYRwclawpgMci7fjMT5iVdcMT5F60A33gsGSnBmOcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhudefjeehhfektdeuvdefveejffdvhfevtddugfduffejfeeikeelhedvtedvveen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:RhlEaX3lWYefVWdllp2u7kf0qywXu1ub1n3M8wHNlyw5RcIsFLN-SQ>
    <xmx:RhlEab1M_Y1rn8ZJJKVzHRDHLaDaVytHNYUYevHW-HnRDM2j156lHQ>
    <xmx:RhlEaV_JCojPiW5CrfUG1DnXo0GLWgGymrjqovQyde8y44qDgHW95g>
    <xmx:RhlEaXb-KqwfgHcoE8pPXMqPy6e-i0uCLGbtIDp0ZEaUnf_eMCrNdg>
    <xmx:RhlEaUxGJyvz34X5R1IuRQAQN3CBNrwkhrBny2PZyp8OVqvAnopnkrAq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:09:57 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 03/14] mm: Change the interface of prep_compound_tail()
Date: Thu, 18 Dec 2025 15:09:34 +0000
Message-ID: <20251218150949.721480-4-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9CCE01C0017
X-Rspamd-Server: rspam03
X-Stat-Signature: tmgmod4z3ayd9xi5ydtjyj79xwz85wjz
X-Rspam-User: 
X-HE-Tag: 1766070600-686553
X-HE-Meta: U2FsdGVkX18ruylanQAlWwEmvdPJXPFw7XCyW9A/PmDBn/uQo7n6A5MmHQ8N+n48B1B5zUJlKoyzJfFqwbmUh7fbv82gpPp2vI6xqXQ5pbDy1gMCbmwkcVLBO/2jBXHTpW/40fZIf99NPA9sqwFY96ZSQ4XnNV8NT4BdU4YsRslDtqvRcJxNzXRbDSiDlcT9mlK1wsE6Ypo2ApEKg3gS/i8t1zO+a6Dpn24Af6+hueNDVC2Cl6dLr/mxedlcoexDKoHV6lSnh2NgQ87NWxdUw6fShMSO50cqYijacxRl6RnyFw0cLe+zTCCL5pvp9hvarctf8a0iOzF7sCdacVRuGDi1Dg8G6XiGUtaiVl5oFarwoejKgiOUC++CtD0NTDIxyd1O6v6MF3NgZvKhaZUryJG8zXTFXaVZyq9yp/y/GooFFVG9fQHRtHnERTfi8mU/RXhkPfylZ9qTasOjNJgFHEy32+S7JGSXCSx30t+MyWcZJ05wxEEUWUScK+NjW4rLlGECZwME4A69vwOw0D6tOP4Edt8O4NdEFstp1Y/mGZ/kybkpgXjl1hVgkgSPemsUSVhQ0EauaRSx/R1RmtCqMt8qp5E053ZdUV+aqNF9ogyBeTfDedLCqVqtHOCWIQlQDgGHtaYfP/OdOKn2/c1iq/dvqqTAl0d3RVRXCbEnqcZfDSQ+KRXucYkHccaoTgcv4emLaF5C1Zs/y2LVcP7geMPq4w9sFVr+FSvsXG7LDZZv0KJz+Mpy10zAOzEYDoUxi7/mbpOeFmf9PIfUwT7FbwcDGXTA/RVtlNt00O9eFXKJnLpcvRp0ZNTaDhKTPXaDbKeE3NK1Clt+CNF/7htt8VVPJs2sUSdNh2Pr6HER52JWVx0j8yhGzywsEPLFAw9Hg91E2OatBU0KNcgVtmdg8DwLHuSLm59lsWYRUb/6pOCYIkF7N9g4vYkr+vQY1IJe+YZjCJ+L029dvkus3Jl
 PAKFe5kT
 hXnU4EW0qcS5l3OqGlHLbNhxbkneHYpyvIOOc47vQZhK/X2tPqCar43rLacKwhB2zBoAPthVBlgcxDaaX7VykNstQFRKjdmLiwEaogfvoobTRIbQj4Je41FtDB8MRNP45SRAW7Ogwwej1xuZXhD3755Qz2VseXgqZJ3aFVmaSwF6G5bCTkVKXs3jKFbp9Fq0V3aI27OgTcvWKgeSZ+l5MJbIl1xiSRUxeVrvj3YLsMz/RA5xInWtcv1+JiYvQ1yT5R0Oa92YeXgXzOHFtOqf9+QPPnA89aAzzn1+/yFaMx63Cexf2PIqGEjrXEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of passing down the head page and tail page index, pass the tail
and head pages directly, as well as the order of the compound page.

This is a preparation for changing how the head position is encoded in
the tail page.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/page-flags.h |  4 +++-
 mm/hugetlb.c               |  8 +++++---
 mm/internal.h              | 12 ++++++------
 mm/mm_init.c               |  2 +-
 mm/page_alloc.c            |  2 +-
 5 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0091ad1986bf..d4952573a4af 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -865,7 +865,9 @@ static inline bool folio_test_large(const struct folio *folio)
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *page, struct page *head)
+static __always_inline void set_compound_head(struct page *page,
+					      const struct page *head,
+					      unsigned int order)
 {
 	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0455119716ec..a55d638975bd 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3212,6 +3212,7 @@ int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
 static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
+					struct hstate *h,
 					unsigned long start_page_number,
 					unsigned long end_page_number)
 {
@@ -3220,6 +3221,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
+	unsigned int order = huge_page_order(h);
 
 	/*
 	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
@@ -3227,7 +3229,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	 */
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail((struct page *)folio, pfn - head_pfn);
+		prep_compound_tail(page, &folio->page, order);
 		set_page_count(page, 0);
 	}
 }
@@ -3247,7 +3249,7 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	__folio_set_head(folio);
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
-	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
+	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
 
@@ -3304,7 +3306,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 			 * time as this is early in boot and there should
 			 * be no contention.
 			 */
-			hugetlb_folio_init_tail_vmemmap(folio,
+			hugetlb_folio_init_tail_vmemmap(folio, h,
 					HUGETLB_VMEMMAP_RESERVE_PAGES,
 					pages_per_huge_page(h));
 		}
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..f385370256b9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -810,13 +810,13 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
 		INIT_LIST_HEAD(&folio->_deferred_list);
 }
 
-static inline void prep_compound_tail(struct page *head, int tail_idx)
+static inline void prep_compound_tail(struct page *tail,
+				      const struct page *head,
+				      unsigned int order)
 {
-	struct page *p = head + tail_idx;
-
-	p->mapping = TAIL_MAPPING;
-	set_compound_head(p, head);
-	set_page_private(p, 0);
+	tail->mapping = TAIL_MAPPING;
+	set_compound_head(tail, head, order);
+	set_page_private(tail, 0);
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7712d887b696..87d1e0277318 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1102,7 +1102,7 @@ static void __ref memmap_init_compound(struct page *head,
 		struct page *page = pfn_to_page(pfn);
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(head, pfn - head_pfn);
+		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
 	prep_compound_head(head, order);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ed82ee55e66a..fe77c00c99df 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -717,7 +717,7 @@ void prep_compound_page(struct page *page, unsigned int order)
 
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++)
-		prep_compound_tail(page, i);
+		prep_compound_tail(page + i, page, order);
 
 	prep_compound_head(page, order);
 }
-- 
2.51.2


