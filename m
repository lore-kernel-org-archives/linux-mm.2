Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E73FCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 854596B0113; Wed, 13 May 2026 09:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B3E6B0115; Wed, 13 May 2026 09:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741496B0116; Wed, 13 May 2026 09:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 626336B0113
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:22:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3044A160127
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:48 +0000 (UTC)
X-FDA: 84762461616.08.D4241F9
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 622A580005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DXaJyMKx;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flkX+tolfoJMepk6tCll9FGS1Em3GZPOVlthey3SFjQ=;
	b=75dcjx9HbteRUr3GnVt2rVa9P6giVBmDKqTWAhFdSBU5tMQg1NNsMfF5mOGOMj2A4IrPeL
	5kxzHALEZRMoYBO5sKOPpIW7Yn2xtYE83oLDDFLGHMZoMp4IOaw8J1a0lZdg1qDGniDxrQ
	A8GXG8DVR3RaibkM9I9oVWxx0id3N1o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DXaJyMKx;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678566; a=rsa-sha256;
	cv=none;
	b=23a1gYuQOO1La5rsEG5dHZd5lRF9SXehSTGMZJBo2TTWjydZVagEjCUxR/kVd7dViSdHuL
	RFq9uiW953KT5krW6a7xva5eSANODZby6qMBMYJwMkXsEL/697T3azwhQRMmHwYvwlgKPz
	m9hOznf52wDiqjta21fen6RMXZ5xuOQ=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-366375c43c2so3972350a91.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678565; x=1779283365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=flkX+tolfoJMepk6tCll9FGS1Em3GZPOVlthey3SFjQ=;
        b=DXaJyMKxYUHOyTOK7v8GOvfrD/Oe6a3wFbmf9QBNqanpwu85MbdFyVuNPAd3cCeaZ4
         XvEV2rrYZtc4sJF3h1VuQ4gkHeT2JHYHsAe2WiFISeE2rPL17J5YKI2mMpdnRyMjhFNf
         opOO5HJikQH4gwRh2pYHQhMx4NiLxAnH7bnVgy0Q+QjvM2htcejQdv6x8vfkqfOIngmi
         Jzw5m3B8xIBmToe04QuQUs1yMzL956H/SBH8i6TPSLj08dwcPHSB0RND4s30GzZlyyEy
         akehzhlzEXJTSQNF+tE1fSISjLFG6UZOPm7cE1TuYCGvHvDRmBI7OGpzT+eWe46KtYsr
         W8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678565; x=1779283365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=flkX+tolfoJMepk6tCll9FGS1Em3GZPOVlthey3SFjQ=;
        b=YgYXx9k3YNEWlCE7LIijgMVj14Ip0UOTLWK8NsZp0Jh0H+gEaDzEyE0PZ6baenY9bd
         yoLI9O4mNJwJx/pWyVyBjf/TX2vIpSkP5BlOjbWpGUPbBW3UnfXKjeNt1fdDQK3iMWI1
         bFt023b2xy81Zs2BlSniP++lzucAyB/5HcukpAta/TtN+rzHPy9rBK1RFGs0WDU6YBL7
         VcajaVBYx4Y0KgKC+5h0kwzXJ+eKPaMdXneB+GH/qJVakjLBtYk9eLY4F150KqF9b07h
         B3HlVFZzktcL1d0bVuggbQS5UHE0jPxCXxqRRd6cyqZNOnoE35YaJU7QO537Mis90klw
         JnJQ==
X-Forwarded-Encrypted: i=1; AFNElJ94ABNm62wu/3FQsqW8+NZ6DNcthVLXhkOT6JN2mYfFXN+ybbIARWr1Hhyu0unKy003CG4l0wf8zQ==@kvack.org
X-Gm-Message-State: AOJu0YwSZvP4cddACtRpjvwaG7TANcU9S/vZE/+wzOzpdfjqK6R4NVW7
	FqyQC8Kgd22n8W3Huq3dR4ew7wCrSy+fyiCKRAF80mRFOmU6wUM700F/n/Dd9Slufb8=
X-Gm-Gg: Acq92OGyJz9s9sajvJomtM/tWvWkiFAt0fwGwkyHJ0FiCVbsdGw8//cl2VerEJex93t
	oITNsv+BO5e7VJCDhElV6CHVcM6bK8+qbKyPMIPBif7ihCu6rrYKfXuEVvxlPckYbCb8ytdXSul
	v/m4ANLMtSBs/rcz8NRLYznWTj6/s6PYTrdDYlKQbjoU2uWA+LqIznl/HEQPU9gcanBpKQIDlq4
	qjvrMBrmSVKxrsx5LENfZ48unwGMBEmozWg+6+jHosl4yRfnmW8qmMsVEtCUy3Yk6k7exAxq5y5
	0c8K8JEYdacTqNC40X9V9z1M5noyDbTy1cXIyVz8ASuYSgDWguQJsX9fKT6tvqMpuNrzOTpS4/T
	4SBaBfq+7x2ZPSo02ux+olZM2xZdwAorZUxL9sOk68DoNw2HwB0nbl4sqUyonIaO7AoErXCdc6C
	S3p6h+LK8TrxR0COlWgKsAi4hMFx27IxTe1Qi0nURy881uyrh7NzuJiIIrxRxmUeBO692BkKI=
X-Received: by 2002:a17:90b:53cf:b0:35e:3103:d4d8 with SMTP id 98e67ed59e1d1-368f3ad4a1emr3575522a91.6.1778678565011;
        Wed, 13 May 2026 06:22:45 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.22.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:22:44 -0700 (PDT)
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
Subject: [PATCH v2 64/69] mm/mm_init: Factor out compound page initialization
Date: Wed, 13 May 2026 21:20:29 +0800
Message-ID: <20260513132044.41690-18-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 622A580005
X-Rspamd-Server: rspam06
X-Stat-Signature: 694yoftc5unt8n3qcy9m1q9z3rr49squ
X-HE-Tag: 1778678566-969319
X-HE-Meta: U2FsdGVkX1/tXj33W9iUuEydP++lBM+aOykwQHZW5dChZaqGhT2AiBm0cS6ufpG0fPSelZk/QfPUBlshMCQY+AC00ybcw7h/AhmPWV/kfJM4cTooKxaWRgDWKxirfjijDZeACapdgr42yAXKdl2Xapv+Geb2y7UBBMuGHULnhKZub1jrumi90UpiN5McQFpGJ2jtrOL5ehmvOUOgCcFmlXlyD9JnSTS5wqZVHJ7rFCxdueQdyjIO1ur2k2AiUoPixhK7xniHA6f/xZ0Kk5LHJVmOSCTYDkcLtx8L05gdNJRprCU+I/+rJoAYUAQ83ZolSTNo/S3u7Z4QFXooHeMRY+xks7xSLmQsx7kmC1yWP+LeNQMMB24JE3fmVs+pyei2412gqM+qQ0Z1kGOPeGZFmrOU+5/8SF6YSavUMbrwjlt5e2yj1y2NQcIc3q40dF6ieu/afvQnbgAEc3f8jLnPfD7R1ihzeJR+OXxN+Nt+nmgmE4PMZt4y9Of6E1x1+OVkUDINExRKJHH/15SWnIhMkIhz8eP1AvMpCXsFXl+N8otTikOsxOwxJMFDBt6lstlzxwMDhrQbRerqp17rpQgZjRAN99mOb1jBFZvDV2vM09K4bped8GCxZGJfM3VmDR8gObCCTS5CMRhOogxzO4yS2kW+B96/Uy6PGlG54+6RAJ3aV2SMzrJOCcOoDRO7HsTghVSx950zsaH4PKfINgwnMxYpwAB3e58nPQtsFTkYxmTqUy4/+6RRX7zlLIFN6w4vEFjliNGjiQWPldE7NodEko6DpRSXZh+YvdnIXMgVTR2YB+VCjtOHB6n5P/vhrMZmiJLtVhHQsx77hO1EIoHeNazwiszpxX32SQRuTT0gb5Wuh4eRC21PaKNTIao/ZNi832pyUCNvg0/11BXQ4I5CAJPVzXMjIeezYD6dh2NxM61s2xeIcPNQsby3HrcNc2I/GSlxC/I0LOimazMjOSk
 CHX4bNuE
 62PXFR0gO6u8T6s89gKGmO32sJQuNi4y9JpzNluiC5z/1iIRAPqm/UEBQtr0nBXUvk2YSJEPDUkkGmrpk3pu0z5c8d3D3+7Wz8lH95wQbQlAN/pBfrltX4J6e8RgD93k7aciUp9n9YP41xejbZYeKASNhg7U4JRlxnZld32suocJ4ccevfuwbBEzy9kn3px6X8qkFkvGxjsShlONrGgTyQJc1VSQwG0TdhtRzh0yaaIbskNcvYQgrRSxaQI3BKq1vbFm6BUDCcQBFQ9tt0QCNMPxcsHrigoWiBSPvht7YVes3JQwU+ajNNryrDBUwg0ofy0chluBpcTSQfNBO8Buu8onB3SNAk6F1ou+s0k5wHXpVt8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The compound struct page initialization needed by boot-time gigantic hugetlb
folios is currently open-coded in hugetlb code, while ZONE_DEVICE has its own
separate initialization path in mm_init.c.

Factor the common compound memmap setup into memmap_init_compound_page_frozen()
so both paths can share the same frozen page initialization logic. This removes
duplicated open-coded compound page setup and keeps the initialization rules
in one place.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c  |  25 +-----------
 mm/internal.h |   2 +
 mm/mm_init.c  | 111 +++++++++++++++++++-------------------------------
 3 files changed, 45 insertions(+), 93 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 10f04fa95d43..7e9f49882395 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3118,28 +3118,6 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	return true;
 }
 
-static void __init hugetlb_folio_init_vmemmap(struct page *head, unsigned long pfn,
-		enum zone_type zone, int nid, unsigned int order, unsigned int nr_pages)
-{
-	/*
-	 * This is an open-coded prep_compound_page() whereby we avoid
-	 * walking pages twice by initializing/preparing+freezing them in the
-	 * same go.
-	 */
-	__init_single_page(head, pfn, zone, nid);
-	set_page_count(head, 0);
-
-	__SetPageHead(head);
-	for (int i = 1; i < nr_pages; i++) {
-		struct page *page = head + i;
-
-		__init_single_page(page, pfn + i, zone, nid);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
-	}
-	prep_compound_head(head, order);
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3210,8 +3188,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
 
-		hugetlb_folio_init_vmemmap(page, pfn, zone, nid, huge_page_order(h),
-					   vmemmap_nr_struct_pages(pfn, nr_pages));
+		memmap_init_compound_page_frozen(page, pfn, zone, nid, huge_page_order(h));
 		init_new_hugetlb_folio(folio);
 
 		if (order_vmemmap_optimizable(pfn_to_section_order(pfn))) {
diff --git a/mm/internal.h b/mm/internal.h
index 416afdf7b2ec..2c67ae25124b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1793,6 +1793,8 @@ static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
+void __meminit memmap_init_compound_page_frozen(struct page *head, unsigned long pfn,
+		enum zone_type zone, int nid, unsigned int order);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 95422e92ede8..9b23c31db8c6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1018,79 +1018,46 @@ static void __init memmap_init(void)
 		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
 }
 
-#ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
-					  unsigned long zone_idx, int nid,
-					  struct dev_pagemap *pgmap)
+static void __meminit init_single_page_frozen(struct page *page, unsigned long pfn,
+		enum zone_type zone, int nid)
 {
+	__init_single_page(page, pfn, zone, nid);
+	if (zone_is_zone_device(&NODE_DATA(nid)->node_zones[zone])) {
+		/*
+		 * ZONE_DEVICE pages are not managed by the page allocator, mark
+		 * them reserved to prevent them from being touched elsewhere.
+		 *
+		 * We can use the non-atomic __set_bit operation for setting
+		 * the flag as we are still initializing the pages.
+		 */
+		__SetPageReserved(page);
 
-	__init_single_page(page, pfn, zone_idx, nid);
-
-	/*
-	 * Mark page reserved as it will need to wait for onlining
-	 * phase for it to be fully associated with a zone.
-	 *
-	 * We can use the non-atomic __set_bit operation for setting
-	 * the flag as we are still initializing the pages.
-	 */
-	__SetPageReserved(page);
-
-	/*
-	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
-	 * and zone_device_data.  It is a bug if a ZONE_DEVICE page is
-	 * ever freed or placed on a driver-private list.
-	 */
-	page_folio(page)->pgmap = pgmap;
-	page->zone_device_data = NULL;
-
-	/*
-	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
-	 * directly to the driver page allocator which will set the page count
-	 * to 1 when allocating the page.
-	 *
-	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
-	 * their refcount reset to one whenever they are freed (ie. after
-	 * their refcount drops to 0).
-	 */
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_FS_DAX:
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-	case MEMORY_DEVICE_PCI_P2PDMA:
-		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
+		/*
+		 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
+		 * and zone_device_data.  It is a bug if a ZONE_DEVICE page is
+		 * ever freed or placed on a driver-private list.
+		 */
+		page->zone_device_data = NULL;
 	}
+	set_page_count(page, 0);
 }
 
-static void __ref memmap_init_compound(struct page *head,
-				       unsigned long head_pfn,
-				       unsigned long zone_idx, int nid,
-				       struct dev_pagemap *pgmap,
-				       unsigned long nr_pages)
+void __meminit memmap_init_compound_page_frozen(struct page *head, unsigned long pfn,
+		enum zone_type zone, int nid, unsigned int order)
 {
-	unsigned long pfn, end_pfn = head_pfn + nr_pages;
-	unsigned int order = pgmap->vmemmap_shift;
+	int nr_pages = vmemmap_nr_struct_pages(pfn, 1UL << order);
 
-	/*
-	 * We have to initialize the pages, including setting up page links.
-	 * prep_compound_page() does not take care of that, so instead we
-	 * open-code prep_compound_page() so we can take care of initializing
-	 * the pages in the same go.
-	 */
-	__SetPageHead(head);
-	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
-		struct page *page = pfn_to_page(pfn);
+	init_single_page_frozen(head, pfn, zone, nid);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+	__SetPageHead(head);
+	for (int i = 1; i < nr_pages; i++) {
+		init_single_page_frozen(head + i, pfn + i, zone, nid);
+		prep_compound_tail(head + i, head, order);
 	}
 	prep_compound_head(head, order);
 }
 
+#ifdef CONFIG_ZONE_DEVICE
 void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long start_pfn,
 				   unsigned long nr_pages,
@@ -1118,18 +1085,24 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	}
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
-		struct page *page = pfn_to_page(pfn);
-
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		struct page *head = pfn_to_page(pfn);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 
-		if (pfns_per_compound == 1)
-			continue;
-
-		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     vmemmap_nr_struct_pages(pfn, pfns_per_compound));
+		if (pgmap->vmemmap_shift)
+			memmap_init_compound_page_frozen(head, pfn, zone_idx, nid,
+							 pgmap->vmemmap_shift);
+		else
+			init_single_page_frozen(head, pfn, zone_idx, nid);
+		/*
+		 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
+		 * directly to the driver page allocator which will set the page
+		 * count to 1 when allocating the page.
+		 */
+		if (pgmap->type == MEMORY_DEVICE_GENERIC)
+			init_page_count(head);
+		((struct folio *)head)->pgmap = pgmap;
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false, false);
-- 
2.54.0


