Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12EE7D25926
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781C56B008C; Wed, 28 Jan 2026 08:55:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72BCB6B0092; Wed, 28 Jan 2026 08:55:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CB56B0093; Wed, 28 Jan 2026 08:55:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 548766B008C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:55:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E30D3599EF
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:22 +0000 (UTC)
X-FDA: 84381519684.23.FD1FBA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6772180009
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MgiZN2PX;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5e5iwTp+f3jWT7S32k9xFcVhvH57uT1HjF7k5BDo14=;
	b=TLKtzVvSd8ROCXYM2yrfFW2F6BYUMfWxnXhPGKmBQam95NxMgpqO1y/qvmtek+oOTLxqsY
	LYF1MB0mt8uVHj32O/ByGuVZe2vR71MYDo6W38lPGbK4fqYFtEAzi3e/AGQ12Hr2hxaP8Q
	a2rWFglUJkVOw+62d8Y6VBddZc9i5ZY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MgiZN2PX;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608521; a=rsa-sha256;
	cv=none;
	b=O+VO7i16XBPGfpfEdeV44t7bYVPL4QjW8rz10gKdnKcK4YEIj2eMEok9FV5Lp54FgSGR/b
	ANW/3KKJymOHFY9/E0ZN4l6E8vzf/7mWnxVOm1jGnxcsjEOdTyC/klRj4ORP3sIvuHmvRJ
	My9alfUPPWwpP52Q3pdkyvbgfUmQak0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB90D4436C;
	Wed, 28 Jan 2026 13:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AF0C4CEF7;
	Wed, 28 Jan 2026 13:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608519;
	bh=6ogOaGvnMTPbWSZ/3tAo/tMV4QN8NO6XYhjt/aFJtlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgiZN2PXVOD1VqQrE3w3xFgulGWoE/aBTs2zWCtl+P1/5FHK3EUhJTe9god0fp371
	 7iRGFaPywSHYmzz4fJuw4OKNLfyg4SHhc6lnnnvgPQ3EmLsszU2b0ti4KIu8jRUZ9B
	 aWAVbUI1ggoeqD+0jr5LvNpUDu7qioGeFRU7JZ34LKATzaO3seb0SUsuBCS07EOTeP
	 gA74DB7exA3eswzsdb+Uf+j1HDBsH79JKbVjMlYfyLV0JeCFIEVn1nzrAEErnpvl0v
	 Cp1Q8pa+TiESIVmgUREu7mMVjBTHGITyFffdDD+pkT1BL0hJvUPRIEpVnGwRQcMOoN
	 WMK+N6hQVCXWg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 08A62F4006D;
	Wed, 28 Jan 2026 08:55:18 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 28 Jan 2026 08:55:18 -0500
X-ME-Sender: <xms:RRV6aTKN60KwR4a5Om8m_-CFDd5_MoSz273TD2SWY_WEJSDyzFXtIA>
    <xme:RRV6aQUU7_T-oR21BeT5_IatOMFBa2WNGyGy90onP5tM_kI3b9z69RY8WBi3e8_5n
    NC3qPUGoAjStnMfoamnwfa_6B208oh1MMQzhs7am-ddxHocLCJBT-g>
X-ME-Received: <xmr:RRV6aV3lEd7IDWT1kf-YU7GyvXs2aqdU1LCbTdchSKXfF6jj2V75IuuYCE3XgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:RRV6adSJj_bowMzw2TOMqRvO3a5tuBs3qVeyqZdrRRI_0X_y8iqwpw>
    <xmx:RhV6aWURHb1dCPZk2vtjB-eQSoIKWPVVYX6B0X_nlT06ighxuVEVwg>
    <xmx:RhV6acOpaL7aBpI3ajq1PdXo2C3HuW85zcNDaWhWsz3ca9oXKvtLXw>
    <xmx:RhV6ad3hPuG9yml4JQ8v-N506dXl0nIAlOrmav_lTe5Uim92w4iYwQ>
    <xmx:RhV6aUOZdrK9whzUIhX2eyuXOqWs4vuVP-54uPM1JNE0cnJQxhccMYz9>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:55:15 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
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
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv5 02/17] mm: Change the interface of prep_compound_tail()
Date: Wed, 28 Jan 2026 13:54:43 +0000
Message-ID: <20260128135500.22121-3-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D6772180009
X-Stat-Signature: hfii5bn8x5ymwuhgyhcocc8g5syh65oh
X-Rspam-User: 
X-HE-Tag: 1769608520-631170
X-HE-Meta: U2FsdGVkX19e14jVobBFhDbIEvYk6iF2UYwrMJi+Tk/cVUJY9cRlhp14o0oG83XMV1UDeloHZ7cf3r6ixL5VHSi9azS1YLRCHpXI3+xbnwE5czNzk/XPS0jO6nucR6F+MBFftneFvHoHWG1XFpzaiAV9zV1QPZEDHqKvCNraVha7nUxG3quZd62L2HQlXk/96v9xjpdp+QYPmnXGzeFs2nbpnOy9DQCzNFQY/JkjzECNmOIl98Htr+LWY0uRAPb8KjcMph9Flv9CqxwjvTYi+W2WME8+QXHWcI/O1tooEYc4YiJnhZlmlvka6/p8eRJestqvXf1Cy4mEyqryQEH23B22Swi4N4++CEI/on6Ry9o8gIzM+sfD2VFIz3y4P63VPsIt72Lx9qTB8HKlFgcSvmdmV7HKai1/H4ii/ra6Bjb1hCrPyoWsaovMLE8iAptqmAuG8kBJcFvg0EbpCbeDQhqr56jpzLLIzgT6g3POMqR4mV/w56dMvkZssCy6LskgZtYUP0V33KRIfuXccWKabO0/v1zSeNL8JomnjVo6byrGgKF0KFNcWcyPDOG+CGM2evtFTL0MpVS2Q/tGVy/LbcakjS28bOBJtbC+TLV/mk70rarHNnKfNgtj/ZNlPfGCqsqXyUP0hJsAkGLJ1qwQVBL2JmshKKxOfJfOIasO35SBox6fJf7qB5QvXq0AIpE7iI/93Cx8AM7IyoTKdRXGw5aNjKG77XmEtBM3aWPC5VxNG/rKVpmKKateccMvfyWv7/GptVS0+RNBkfahJAtKTnacekIe+7M2tZUJUlVA87n2MZqj6ExXsJqZQnHS/XjGejb/AEDncTK5Nor8SrfzCxPilYtxlo53wogpVcbuQkNcDiXsxxiGSyiXmSiGKMs+x2HLfpJp+Yam/XkLabjxWcdAJVEoYJLAd4qOQUErFaY9R/QSsc+lYbUfpdc5lTS8g4NtPaYCC4E01US7vJP
 zKCEkpbd
 /4GYTg6wwH+hkBZ08nQWIJzWmax4LTkak3HmYmDHOWL176ZdvLsMFWJdr8v0RueaOyqzmdsH/l3vDFU0/TVpkmgpcHMpxSp0z03R+scauWLZiErAe6y6zvBRTZqrclu4OA9fYrbGbJCHiEyIFm7q6I1ITA6ZqmUrLRrWvjcD3u7NFYUow7Rn9Fcc0Ijjs9EvfCxWbgJMwhuxHcy6P6SLyG+LkqoWDvku3XvnGGCApzzJaeXREz7IHYJZ/j5bXfhcQvhx+tGF/0/prk7APrRgAKO9Yy3yOUWhAMw6KcCGsR1TA5SzwtQe/hi+WlNfvou0tVf2iTvjK+YKXhrQ=
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
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/page-flags.h |  4 +++-
 mm/hugetlb.c               |  8 +++++---
 mm/internal.h              | 12 ++++++------
 mm/mm_init.c               |  2 +-
 mm/page_alloc.c            |  2 +-
 5 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..8a3694369e15 100644
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
index 6e855a32de3d..54ba7cd05a86 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3168,6 +3168,7 @@ int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
 static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
+					struct hstate *h,
 					unsigned long start_page_number,
 					unsigned long end_page_number)
 {
@@ -3176,6 +3177,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
+	unsigned int order = huge_page_order(h);
 
 	/*
 	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
@@ -3183,7 +3185,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	 */
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail((struct page *)folio, pfn - head_pfn);
+		prep_compound_tail(page, &folio->page, order);
 		set_page_count(page, 0);
 	}
 }
@@ -3203,7 +3205,7 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	__folio_set_head(folio);
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
-	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
+	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
@@ -3260,7 +3262,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 			 * time as this is early in boot and there should
 			 * be no contention.
 			 */
-			hugetlb_folio_init_tail_vmemmap(folio,
+			hugetlb_folio_init_tail_vmemmap(folio, h,
 					HUGETLB_VMEMMAP_RESERVE_PAGES,
 					pages_per_huge_page(h));
 		}
diff --git a/mm/internal.h b/mm/internal.h
index d67e8bb75734..037ddcda25ff 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -879,13 +879,13 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
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
index 1a29a719af58..ba50f4c4337b 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1099,7 +1099,7 @@ static void __ref memmap_init_compound(struct page *head,
 		struct page *page = pfn_to_page(pfn);
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(head, pfn - head_pfn);
+		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
 	prep_compound_head(head, order);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4104973e22f..00c7ea958767 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -744,7 +744,7 @@ void prep_compound_page(struct page *page, unsigned int order)
 
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++)
-		prep_compound_tail(page, i);
+		prep_compound_tail(page + i, page, order);
 
 	prep_compound_head(page, order);
 }
-- 
2.51.2


