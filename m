Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59402C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFAF6B008C; Wed, 21 Jan 2026 11:23:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D23D6B0092; Wed, 21 Jan 2026 11:23:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DDF26B0093; Wed, 21 Jan 2026 11:23:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EAE86B008C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 013F68BDDB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:04 +0000 (UTC)
X-FDA: 84356490330.25.B9C1D4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DB5AD40010
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ck2j0KXc;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDh3YOC6eYeQyqydHIILE6IJ6ncZjyAJYijiByFrg54=;
	b=19tp5rhrba2Zq0TTLeLK6Te8ddz/eu8r46xTj34uFfJD4qlfelTP74FErp8J9WT4ziCppl
	updIlN5cKHUPpmSzJWTnOD38IgYnyVVT1M8/o4zxADIzKq/GE8IV/QSr3NTpDcdKRciech
	CF+2bConQ2gEkzXzcuZh5Oae+Smovic=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ck2j0KXc;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012583; a=rsa-sha256;
	cv=none;
	b=d8UJpM6dEXuMQL/lerMT5zB0QHMRJLTGaGVD/Lvh9NJ2sc71e8V294Nx9jQ8WDB+RNIKWM
	YFKYwQBhQKVz1MxbVMSokQi5wvubxv2T3kR0tO8uQjUxTFlUIraKli1X+nW1zRwAiWJO/g
	pNPwDuVz56p+2f1EvK4SPzr9Aq38n9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10DF044363;
	Wed, 21 Jan 2026 16:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB47C4CEF1;
	Wed, 21 Jan 2026 16:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012581;
	bh=ft4QB+pe2zfMyyeRxFmvFGapI2DJYfjteZFz/aCazm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ck2j0KXcnwacJRC4eFLVwtjLSWcXiu+Zomh5kqlAofTIiT8lPAWZW76Y/v0bqYQfs
	 RWkONbBzHTaMAXbDdK1K82D0nB/9/jLACh36JcxN9j+RVyv+j4B9FSRQ92l+mHuMvk
	 NjcFTHSkuHFzPUz7MGkWQfX1mQQxIw/+LlLatRcLZ7au8+u5V7nR4J8kvjHVec4q20
	 +OPOSRm7fOJQzviLLygAqDN0c1A9XemLb5B5WBbbkGOQqNOYZ5Jh17b/cF/sv0gB+1
	 DV46Gpnpro0zyXInCdfb+wjS5EVGXLZf5ALqCzueiyxUzEZWVW+eaHbONxsfL551HM
	 xFue4HQaXdsYg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6F0AEF4006B;
	Wed, 21 Jan 2026 11:23:00 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 21 Jan 2026 11:23:00 -0500
X-ME-Sender: <xms:ZP1wadD4fS-HJDQ6tHIvZo4RkLadBqjj7a4PkqdEh6JsDOG38ekiYg>
    <xme:ZP1waawIpEqqD5A6tCfq3z-7E59MRVO3yh-MGWAQT1fMhRlwgBQ5HYhE1qN7J7GWS
    fTdVdLhkkuOXc7GrpRgJ0YLA_vn5dCnTfsz8bm8V61q1yFFSMJcGA>
X-ME-Received: <xmr:ZP1wabYtkWhYlkvZn7_8lw_79HB0Dw2lrn-3j0VlsbiOZKm555thjx8Di-dKQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeefjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:ZP1wafTRe2mgQ7l1h4_QEJLXiMLKQYpfs2cphmv7OTl3ovk8vZsAQw>
    <xmx:ZP1waWjllYBn9BRTDzaaIAlHQKSgdBThIDKx9e-sQ0F-xU9qiJXsbw>
    <xmx:ZP1waS5s0fOkRlT9rCHbzV_zz1a9GX5Zv7HlpHl8V8WQctuA4BfgwQ>
    <xmx:ZP1waZlK2J416Z5muu2o8XUgk5QDgIelGJMMazw6R9VT7prMZgCfUQ>
    <xmx:ZP1waTMjnLstguNp9a0fde2_lMleM8TbGk2bacG9qNVl20kE498NHNrQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:22:59 -0500 (EST)
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
Subject: [PATCHv4 02/14] mm: Change the interface of prep_compound_tail()
Date: Wed, 21 Jan 2026 16:22:39 +0000
Message-ID: <20260121162253.2216580-3-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yktu1km93ny4s8dozh17uc4yo7dzbdfz
X-Rspam-User: 
X-Rspamd-Queue-Id: DB5AD40010
X-Rspamd-Server: rspam10
X-HE-Tag: 1769012582-449980
X-HE-Meta: U2FsdGVkX18stg5f3mzB1AQf4uGYnanG3XqD6kaN49SGgWqwTeyFW6xaCBXHSFE1/a7VPwRjvKFeJ87+KQHDn+//9F7gN+Vh3Bslvg0omI5QzCla2/MWOL58N4tjLPsaQQMQi3YQ8yi1RCJuuYoE/Cndr9N22keImtqj19XdwPleebfGYkq0zt7/bZoNi/wMGJlOsuXxKDP6ma0BkTUJYGuaFnPFrMJOqJuspDbjnrrqZmaZNwtxH3yd+8QzwAzJt/or0MLEIH+Nlk9RQ28hKR2Br8Ah30MLMB2mYXg60n6h5PS879AlO7FPQa3/6EleiSiS/lbrn1Fn27fyA3rhUuJzkNVo9F8oi5QQfcJ2bkMhvwYPAfdFsdAfdEosw2QCISvtJFyKVI2xRPsQSee44fcZs5be7+BKWH3HfqTgQXY6V2Sx8WYggK0xxxDxp08+DBoNFloYKhSwao/LgsJMH2vlCuxwscNdaMUp/ZKfHuBGA+rOKlsczfYOT8QsPKxIxRgIEfgvN35gd/UJS8M5qNfKkgcnDX1tuQUcj9//M/gE032kj1hVi3EUxmVOURaZOquS37rFo02N7CKhe+GI3pcWt+ebLGyczuRjM+bkOEqBRMmXKDhw7KscFnXwIdkaYoQL+MQwTHBM9zn6J+t/iUFS/L8SY0YLY/UPrTN4Lc64bjCbqzO8eOGNRm/aK5w8ptJwsnVi9w6JvmzSvY1tOGI0xQTovOqGGQi38A6H/h3G3jN1acYrQshu48yZZ0ga7w8osEnZwVCksy6YwUarbb2LLwjMKOCOqM4gR6yPxndi84aIMbQ3jIA7reVFyXHr7cu8BHKmXCfPCA+1VH7QnX7hb8Q6O8yPhzne9ZxvosdzUWjecQflJEYSazD+Dr5V5pLxOXm1pSvfMRwlUdpc7FmmgElRCXvEivwDjkWPhqf96v9fVU9i8z/+oVYddhoM5zruTSET+4eG70qYN7O
 o23pOdMJ
 OFTV9/iRoDVRWY4/FRqZI4eygKEZK0/Bmc691BQ9bf7vKEKK0k2ql36be3zoWqGt4sjkTpgbQzX/36lGsI4aqtqIIkzcz2IlFI7Qi8Gws5+3+zv0xsTRoanghk04Vge7JrLyfLYy2HFNJUmR037QQG1+WgxdtmaLbIWg8OF0iBxahLbL3XHM9gac4PwfxON78iy9kjUo574guCXNa8ZoYa+J99Q3OwvhyAtrOYwB8fBhB33iiBDt//K8ZHP9V+MI9b+8DDo019bK4riG+LaoNtyarXuOjUt7l9pGQiEhkDAA9YSLMkU1fPry4Rg==
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


