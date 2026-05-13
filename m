Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDD1CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40F966B008A; Wed, 13 May 2026 09:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E69F6B0098; Wed, 13 May 2026 09:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FCAD6B011B; Wed, 13 May 2026 09:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EB896B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:23:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E789416012D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:23:12 +0000 (UTC)
X-FDA: 84762462624.08.04D30AB
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 30E5F40003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:23:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aYyo+AGo;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHqr9wHSnVyYVNoFiVSVd8oLdOOQgIPkLvJW4qLJj/0=;
	b=x5+d2tgC9ksI0/MKOWSckc3j7/ubc5waMjH2j32jPePiJIdvSV2zMYnGtywDXsrRCuPbuO
	LJsq0QFxyCCzcBXh3YzFar1IruxH0oznwrw2J7+uLTQzLUmuk4vsx5zuCxS9U0hSGYHzrR
	ur4jw2F9ZeG3HT7zKIjqNplPsWyKe8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678591; a=rsa-sha256;
	cv=none;
	b=T3MtQCppJeCt7pGHtdtUtHYtA4HF91qCb3768fxtGaMooKQGblbrhUOgESZ/pY2qGf+WKw
	0IgU/kQcKxlVGTRHvQW219QEFK3cNRL4Jx/0d08zpByyOokfztT7/3c+WHw5AhVwT8z9OB
	bbYjpOHtVSSs+QTXE46QLFIZTNFqiro=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aYyo+AGo;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-368f25ff4c4so671867a91.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678590; x=1779283390; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EHqr9wHSnVyYVNoFiVSVd8oLdOOQgIPkLvJW4qLJj/0=;
        b=aYyo+AGop6RyyrtjEc3rJMkNc6sSkpDegj3VcXdut3Asd21m7XJVCximtwgomeRXZ+
         h1HMJg5F/Arf7gd7jL4/90kRmBj6lKy5idBI5apNSpruF4G0ODQbOGxcPpfG5lEXbZMX
         l1CUruF+JeQtzjeeaSqhMUPO5ccvoLCBWALmzCXmB+8R8kefCGUngZso2jc1NKX34uSo
         S4sFK8O6JCFBdudImK+VpGFPEzMNIALUnQjsebBJZdc2jpW65dm3SckuJoOMfMemVaBC
         c389ugOMeFpZ0zGqJ1XIgKj7Gm5gnBNDET1A5bNAs5DFytkO+FCyfZCVfEMblGkIEUqi
         3IXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678590; x=1779283390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EHqr9wHSnVyYVNoFiVSVd8oLdOOQgIPkLvJW4qLJj/0=;
        b=OmHmDCyp8DaVOcekoYCdCn4HB9iq9NxiQhWpt+bvNx06eWPnNphhW+3WYpDGaYFLhG
         UP4bZjnqdLX7w5sYbLVedpik5r+2mgCWBSQ+gGouM2zDGjYbgjKj94YBnhK9AlmotrvX
         C7C5dBJJrGvDcZD0alLn8ELpNp4+VSNUubmod+xrD+Qfk1esX3sRdyxarGKR66/iW9BI
         zF4W8NQFBP/RNkYskodd5WLsU2EkUNCbKpv562IWrQJHoXwvPngKvp+otvqYjVOsgoyT
         SWyyb9DtiZnwOB4XQkgEfCMe55+5V5/DGfN413SPh5lv0OlOgcDmNKnk0g5G6hnVrEPn
         u3Qw==
X-Forwarded-Encrypted: i=1; AFNElJ+TqyC9M58pYIxu9Fd3+yGk/oezxbEJn1XC+Cw94ek+2h8mHCdxf7tshZpIDH8Z046GwKKo1uoCHA==@kvack.org
X-Gm-Message-State: AOJu0YyAXvJkubW6TK/uZ3pdDxwpNbLZsZPUEPf8esbXA1dis7hGukg9
	3VhttlBBG680C14KFP3cpeOQoQ2y+V2S0KQMlLqErfUd/7gPrXSJZbHVV3nMHjmanzo=
X-Gm-Gg: Acq92OGyLnq/3Q1C6jjLdXKy485lidKdvux7C5lqLLFUoIsBCfvVga8rUGQ9ZDAKVED
	DIgi4i7E+VcmbjXALSz1S/aYUKBF5TT0E2qcEU5LZeloEjJDo5te3qkxxj756VsC1HYX6tP/aIO
	vnJU3rIcPCqMw4R68nqVk/Kfg7uCS3r8O4wPIx+cagfLiYbGS13uex3B4l1wE0nDF50UFhoAv+A
	YIzkI43kQfzysTB1u6OL0+/43vbc/2rFKPSvnHXrymTiObzB4+8kJEsCweRBlYN4KIYNy2r67iq
	ZBZB62nXeRTzrp3lnWEHQDktbCT932YHCbRRDLJGqf9NPxWK8ZGm7ZCgS2ITqKhaz3mgsh4AYeD
	Can7SYTcb3MZcJazxXgSYEQbZ/IsH6Q9OCpij4VLl0msCRZwCzzsKtCtiPpBxj2XBOJZmP6lYLO
	+OK+F5XtKwHAqtGENCrB+EQAK5ejTPmCy6uLW+mgGF4V3sH3VVowF5EZNH+CDX
X-Received: by 2002:a17:90a:d610:b0:35d:a3b4:2f0d with SMTP id 98e67ed59e1d1-368f3bd73f7mr3554267a91.6.1778678589854;
        Wed, 13 May 2026 06:23:09 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.23.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:23:09 -0700 (PDT)
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
Subject: [PATCH v2 68/69] mm/mm_init: Initialize pageblock migratetype in memmap init helpers
Date: Wed, 13 May 2026 21:20:33 +0800
Message-ID: <20260513132044.41690-22-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30E5F40003
X-Stat-Signature: yggbwifjsbrh51tfie5et9kndgq1ekjt
X-Rspam-User: 
X-HE-Tag: 1778678590-941884
X-HE-Meta: U2FsdGVkX1+Hij9Zy5gyusm8GY44qseGi1AESn0oHdBqqINOozeQbR0J+6xtU1j/LqmxRE/No9lZj1JTXUnTy8PW5GoS6RCS1fJs9ssgEmLiZOCmHQsB0qdXspejEvs8I9M0KbSag94sdPXnNeODuaSoyrzy76sBlosmk2Sx2kuDKKWisTrQNC0RuyKu4xPy368l8kYa+cXBMLMIhvO2NBywt1uQR2pXToR7GgycONBIjRgBrseroykAyZ2NxO8cO+GFzXePenFh0bPMZssQzC4L61NwYX5rgRBYdn5+ubrFoklKXBxsU55XTFGrD10CFGgvOYvnYB3Bf9283NSsF4HjkT2T9H8xJrqK9uh6WcjfFeQL0ONgoTrvquKhD8D4nwHkCy63+K8ziZvBQCN0x0qsWJuxRQpFfJt16lKFDsf2cfBQ14bhl6zJBfAnBC+o54XIx2323wI3H61C2TMIpCTZmhnT47jDgJxNDRHC5fBe93TaAagPU2NXqOYDjYnGKRmffON0mvUbmCxTPwwFQDzhQAEZY3PVPvHlx/yiWTh4Z88OVdlQYhGRfw36TgvMhDEN2qVWZUhtBPytJ+8TaGJo6JUIMRCfe9Uz439HvLUf23xxfJtfOGLEp1phA9l0gUeb/+56d433A2XZSNcrmmvJrgpVuuoaYO/j9xNrFv0Idsqu0pN/trKO5ozDL4SI6JFymZ3MY2iKCzoAUUi29YJxLYF2lb7qxHOi9+SQIZZl8M7CmxTWuzQRLqZkEcH0RVMthzCd8t2IaPoNeqEWt9RrrATXGJmPZjoGIYJM9+KaAmi5eRfB5d9hq8OjwzeGXWl/igUP073IR9JLK2pMfmZlERovj8/jGOYfC43AV8UWrYJfuaio3aJHxWCYabn7QbNObUZrrnBSM8BJu/bF6B9Zu7f47c4/Ibz7yWs73RF/hbVJRPQE4Qw16RUTQksQCooX9LriaOglVs1pzvZ
 3MmxM5hn
 xKsx7aGEJV3NfdPNc1X3RZawDWp9TY1c7Ky1gBUaaNFgIy3CaMTTYTdKIAsKhH4rJkkdKZWldlwiwvNoTv6fSqKLtCENpOhPV53uty2ee6PRVz8416uGpaZeNm+iWLwCIli31WK9L2puMNhj8hiigyOOWiIWcXPlQxtsH9N3aZicP1CPcwoMKHmgaaaMyqGcFDBgn5JhB+wsbP5KHlPOkXWwCRcLaNKkHZSBOoNoXlz98wkhX9zGeDwfWIW6t8LbvR+3mNSr0r7IGbaCc7pkIfONzgMD9KWF1N4LxyOihOMX6Olj0pLBsCzPt8KdXvSCRMTBxmJSMeeNLcn+7M2c3OEGA1XHUm2yjsfb4tSq2bhB/Zog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move MIGRATE_MOVABLE pageblock initialization into the memmap init
helpers in mm/mm_init.c.

Let init_single_page_frozen() initialize the pageblock migratetype for
single-page folios, and let memmap_init_compound_page_frozen() handle
the whole range for compound pages. With pageblock initialization
centralized there, drop the duplicate hugetlb bootmem-specific
initialization in mm/hugetlb.c.

The old hugetlb_bootmem_init_migratetype() skipped CMA folios (via
folio_test_hugetlb_cma()), but the new helpers always set
MIGRATE_MOVABLE. This is safe because cma_activate_area() will later
override the migratetype for CMA pageblocks, so the initial
MIGRATE_MOVABLE setting does not matter for CMA pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 25 -------------------------
 mm/mm_init.c | 20 ++++++++++++--------
 2 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index df798f9386d6..fa269560f657 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3118,30 +3118,6 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	return true;
 }
 
-/*
- * memblock-allocated pageblocks might not have the migrate type set
- * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
- * here, or MIGRATE_CMA if this was a page allocated through an early CMA
- * reservation.
- *
- * In case of vmemmap optimized folios, the tail vmemmap pages are mapped
- * read-only, but that's ok - for sparse vmemmap this does not write to
- * the page structure.
- */
-static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
-							  struct hstate *h)
-{
-	unsigned long nr_pages = pages_per_huge_page(h), i;
-
-	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
-
-	for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
-		if (!folio_test_hugetlb_cma(folio))
-			init_pageblock_migratetype(folio_page(folio, i),
-					  MIGRATE_MOVABLE, false);
-	}
-}
-
 static void __init prep_and_add_bootmem_folios(struct hstate *h,
 					struct list_head *folio_list)
 {
@@ -3149,7 +3125,6 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	struct folio *folio, *tmp_f;
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
 		account_new_hugetlb_folio(h, folio);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index ff6e9fb468bd..17ae0eb1ccfb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1018,7 +1018,7 @@ static void __init memmap_init(void)
 		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
 }
 
-static void __meminit init_single_page_frozen(struct page *page, unsigned long pfn,
+static void __meminit __init_single_page_frozen(struct page *page, unsigned long pfn,
 		enum zone_type zone, int nid)
 {
 	__init_single_page(page, pfn, zone, nid);
@@ -1042,19 +1042,28 @@ static void __meminit init_single_page_frozen(struct page *page, unsigned long p
 	set_page_count(page, 0);
 }
 
+static void __meminit init_single_page_frozen(struct page *page, unsigned long pfn,
+		enum zone_type zone, int nid)
+{
+	__init_single_page_frozen(page, pfn, zone, nid);
+	pageblock_migratetype_init_range(pfn, 1, MIGRATE_MOVABLE, false, false);
+}
+
 void __meminit memmap_init_compound_page_frozen(struct page *head, unsigned long pfn,
 		enum zone_type zone, int nid, unsigned int order)
 {
 	int nr_pages = vmemmap_nr_struct_pages(pfn, 1UL << order);
 
-	init_single_page_frozen(head, pfn, zone, nid);
+	__init_single_page_frozen(head, pfn, zone, nid);
 
 	__SetPageHead(head);
 	for (int i = 1; i < nr_pages; i++) {
-		init_single_page_frozen(head + i, pfn + i, zone, nid);
+		__init_single_page_frozen(head + i, pfn + i, zone, nid);
 		prep_compound_tail(head + i, head, order);
 	}
 	prep_compound_head(head, order);
+
+	pageblock_migratetype_init_range(pfn, 1UL << order, MIGRATE_MOVABLE, false, false);
 }
 
 #ifdef CONFIG_ZONE_DEVICE
@@ -1087,9 +1096,6 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *head = pfn_to_page(pfn);
 
-		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
-			cond_resched();
-
 		if (pgmap->vmemmap_shift)
 			memmap_init_compound_page_frozen(head, pfn, zone_idx, nid,
 							 pgmap->vmemmap_shift);
@@ -1105,8 +1111,6 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		((struct folio *)head)->pgmap = pgmap;
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false, false);
-
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
-- 
2.54.0


