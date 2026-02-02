Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E5E7E7DEF5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4BD6B00F5; Mon,  2 Feb 2026 10:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5BDB6B00F7; Mon,  2 Feb 2026 10:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B026B00F8; Mon,  2 Feb 2026 10:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 910476B00F5
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:57:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 312851AF4CD
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:57:06 +0000 (UTC)
X-FDA: 84399970452.05.BA7D6D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EAF68000D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:57:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WF69RSX9;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5e5iwTp+f3jWT7S32k9xFcVhvH57uT1HjF7k5BDo14=;
	b=I4sjK0otOuod3RosG40ZOYvwUw/NVHpY/fWZ+IJbmfHJH13gBQSs3byWSJoXEWQxmunGKQ
	QEflsHhgatzYqVO0rCFzm0TmDy6xbS7ywMehuYH6ZUlLk6/j0W1vZhNi+QvNBpCa175yW3
	FjVXzIBpv5ohnuzM+MLD5LkxAtU0VcU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WF69RSX9;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047824; a=rsa-sha256;
	cv=none;
	b=Rx8aL+/dZjIKN9lpRoPK/yIHuQy21fdRUe3ADKIB7lufWtWty+k15a3xmXoTLv0IO4GngP
	iXCYMBtbZnXqZl86CBqWwJolYL4I6W4m23Woc7vJI12upmJhc7nq1t6yM6Qk8eQT3oJsDX
	hzuO2omZtYoQHrwYlcYq+v5kY5Gx9F8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AEDB960010;
	Mon,  2 Feb 2026 15:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C81C116C6;
	Mon,  2 Feb 2026 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047823;
	bh=6ogOaGvnMTPbWSZ/3tAo/tMV4QN8NO6XYhjt/aFJtlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WF69RSX9f+mKWCabnqaYZF5sNHFC3uvixKlWuQFydyTQfTYpnLJRGuLALJe4g6SCy
	 Z7Bev3jJyKP5dkM3ePpm1j+cWEcQBQk7XNrosYUsOdBUZFMGDf8Gx5VdCmBl577KZA
	 H8+wByJDmnFL0dHkGkUofLeF5vv/qSzmwGhwAF4FKYncIaqSbTNyzh0yN8yd6OEcr0
	 aOJcDqCtAnfDSquMy6kiIisKQ4pYRhR646y+3V4VHKCOVx3pYmvm4L6C3etZAraJRw
	 mtpuy8MFqZMCl3NyXM8s9prA7E+yFcWlI4uy0mLwVyuuFKW/ZLmxoQ0l1oyHnT/UG1
	 918w+RG4bnXBw==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9F3C5F4006A;
	Mon,  2 Feb 2026 10:57:01 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Mon, 02 Feb 2026 10:57:01 -0500
X-ME-Sender: <xms:TcmAaYjOJrq73uxB93s_1BKc0eXQYx_nn7nFRgDmIi_RLU-icKTkBQ>
    <xme:TcmAaaMpJcV04hdcBqMV5JCrO0-4FS84Iyyan2CQIXCWAuNUojgJowCJ6F8CIs8Cc
    Ohz9aZVPmxiJjEPzrfmX9Uv0JDFynwCwIeMH_T4zyisAAHoNEkaEg>
X-ME-Received: <xmr:TcmAaaMNLQ6cUoLUPbsnxRut7Yuf8XTPl6gSVFX3WYZtom9LfBf2cdVkJ0mwFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:TcmAaaKT1qy77U44vFiWXE8gk1b0ceZszD7whfv03MucIMbGIJNyEQ>
    <xmx:TcmAaRtSE9qGIf1q5QseHThLiCvJ0RZb3JnQOGGWNUFLdVU1FlHYmQ>
    <xmx:TcmAaUG7Lc0mgm530I0Bo9Pyjy719LFOhnRcY1esid_-c2vfijYIdw>
    <xmx:TcmAaYOIBp0AIdUaK3Rtnn0Zs3kXq3uF9LacjMNexwXsakmoAAn5Gw>
    <xmx:TcmAafGxOZuXYbhcWnujikyIb9CCuSz6CHe6QSpg7yOBxcruif0N5p8L>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:56:59 -0500 (EST)
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
Subject: [PATCHv6 02/17] mm: Change the interface of prep_compound_tail()
Date: Mon,  2 Feb 2026 15:56:18 +0000
Message-ID: <20260202155634.650837-3-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: m8ishogzoobic863h5uwshp4643o5m1t
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EAF68000D
X-HE-Tag: 1770047824-956100
X-HE-Meta: U2FsdGVkX1+srVBYKGWEpFVX1evbfLl43qqml/Cj3snSlX8WVTV6/0YjfyoJy6QEUJ1nd95AvS/KlT2gkwQTAljMNkYtOErn8tJaUHJX5RXewwvFqMg37EzjgiKS18eGhSTMp90jIHfLNyPvgIkWzXQ0sl/ySjy4qaM4PY4j8sN7V4599Aa/nMYV6a0Or/+lBq1ouhaZzpR9E6RvRpJbk3mxxzUQawexftcxjD2u1TB7mePtEdwUhkquH2g8O1yqjJ33O33eYWSTR34z/LMKOsi6AJeKf7zulvWLGU/e46KR2428u9lDTTiKlOTXT9O/cfypw+EgJ373T9DO8E0j2QkZv/ta46opYVjzG3TgZ4zgX1+JME1V6uN7ss+hy8OIoK3vmmF+1zEE9+Lo6GOPjMUWY2cNyuYuPTTFSA+fD0KhWcbZm0D/06X6QzmFm3e1FLWbmLhGx4dbgoBVyDD7K00XvnoIkM0eQC0k1hWxy0fahuLxytgOs2HeFpq9f6DyJNVEA5wDnQxjCNvzFRVVqYAQDbaZmt9sZulmoCH5Q9pugmqZLESbVuk204WeD/BY06GcP5p4K9nP0Dfh5ZBU9BQHe9EAXJicXVXSM8WiDkXMCQqJf4OaA3m3Wal59pDGsD1tMV52sAy1o50wfr74grlPyeWRRf7/mWAo2ofDpyIDGoJijpyCReQTPUwUYwVL7a6eHeiB8CQeWvjUyaznoxNSVufP8Oy/wUN8rtjhuHEBzx36raMN+nQGU8sxQTdk6NsNPGzk+LL52aN6JilFn+F7oXEIFIGV3etUITsl4h/+dNnHhxGLSlOdQazjeHHj40O+ShWP1nmRTTqus61QwfU4c6wwFDYcULnk8v3vQdPDxiwyEJkJfARfj+mDEiWPJgH56zYEI8Dhuoe/M+Mss6AmlaFKBm4pCDuXYFIucGx0XCwaSrRSFWcGXDZsyd0sOuQK/4FmJDIAz7bwi4Y
 PX5U0Ahn
 UoTruzJQK7y/niQ2C7mFILDVl0vHTqHg2ZvrxfDUlHs/c416+XggPoYgHUnXhivzyKdz/OBJo5St0haFoT6HW7TCxVQBjTFgSgx87NMOiSiEZ9AbypmS8a5ctbmXpkZz3PSfNF13r66/UBlsWZ04DBng33YAVqxWrlEtqVbGW/dFhCykq4e3aMB5Tf354+VLUWYHhP7Jfs9tFHxRRVu7YRCsYYD9mDTqQ2EBrqq7XL2jg3y3Cu1uQWZPGIwonyT3i1hthaVKvg2EGEGVighN5qw2HfEOFNUeskwNezz3j+lTwSk9z6ylLCkIhhj+kNmZ3VED3jPunweIogiE=
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


