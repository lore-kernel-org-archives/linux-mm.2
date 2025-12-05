Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B0D2D3748F
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D676B00A4; Fri,  5 Dec 2025 14:44:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4CF6B00A5; Fri,  5 Dec 2025 14:44:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9AB6B00A6; Fri,  5 Dec 2025 14:44:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7EB6B00A4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55F6713A83F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:00 +0000 (UTC)
X-FDA: 84186443040.01.4488ACA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7020D180013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:43:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bG8r4+TG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963838; a=rsa-sha256;
	cv=none;
	b=IxWp5rkCR8z453FiJK7NWz5GOzVRqx6G1R7hrNbtbKX4dmYug3r3HhXx8quDRJau1LsPcR
	lLJlq2W8TnD8ak4NILM263SqeC2lQrocrAtoqOnIFVuAZrwjvo499JSGEjq4A5GEftvrr7
	gkpJENrQygtNxmOWYNvipuGPqZ8cBac=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bG8r4+TG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28/8tfMC75pQinTBeHNvG9yzM1hZ7BX7uOwwgytA2G8=;
	b=Qo2gBk+pIyR4C9xt+4JlbtT573yvRkjCQHZ4Tbe5IS+igDqZjTtaqYWcKaRuOBfjjPoy2l
	h+3wivyIfaBRlftMULjeXv0SeonqOzdYlGv7giO2mZJIFj2At+AsvIK62D5qxf5+1h2Gsp
	Tz3dYHGRdWiQ2vXIJwqLliUIzId2xrU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB6B660122;
	Fri,  5 Dec 2025 19:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC54C19423;
	Fri,  5 Dec 2025 19:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963837;
	bh=rsAZCC1GicmUXlKf4H8XnwfDPh7I06Agv/cIdYL5d/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bG8r4+TGPBq8JdMI99CGKczNdBPbwqnDzkM39pqwwWU/vnFzi6Bag5ZEpW+u0Jirx
	 zboqNziGq/19qyAZZUCMcYrN7T8E1rAUj3RQXjzLOEAaFuXIu0Wo9tMXlv6/IC6QR8
	 1dwpal2sBw2psuWprfn6rWoV7sqlLfW8CWBpk3JhCuHrLUBI9DJI6CWljrVG93Rf8i
	 OEjJYUoEWxse11M5YQy9mxktK7KpO2f9t6myotcMwsR+CzA1wqdrrUI0qalyhREykG
	 o2d752teuo5arDTstYv7hdM0VB6i6CWZjwlbhbs/YQH7aE8tIvn8zUDvQ683FZMMj4
	 jirSfQpBGmKJQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3A859F40070;
	Fri,  5 Dec 2025 14:43:56 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 05 Dec 2025 14:43:56 -0500
X-ME-Sender: <xms:_DUzafFcBaG4jPg4D8sbFMOWcqGX8o3my6R4h3xSbt71_PkDbMYL4A>
    <xme:_DUzaduvD2_2xIv1NNnxVlzlkFOmiHLzLY1NnWW2yQD-AxchrgIlakMWkFV3oq2dL
    IclhOjoqBe82OpC06-7FmFgGR3hu7NmcibVgVBkwSkHIwrFDSq5D94>
X-ME-Received: <xmr:_DUzaaZhRwWxCdA19CEbtsX6gwweRvFWjlTExz8NEu1DoJaCmeWVXAvLHhGfAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdevnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmh
    hutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpd
    hrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghk
    rgesshhushgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorh
    grtghlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:_DUzaVVuHl4NNy7AwcqTu9la-Qmhnw29Y4OuvUp3IahUpwgV5kwYhg>
    <xmx:_DUzacJhF-z7yibzS-YmPhdHp_VfBz6JmXtOpdJm-N_P7AlP79AnOQ>
    <xmx:_DUzaTFJhPf_gFQuVYGTsSidI5GTgHIXZigLo0rCYa0qvNihyBBuTw>
    <xmx:_DUzaRyCMOY1iKosHXX8lJdigAshRIR9QQ-XRbsbyE4Lu38MbtWr8w>
    <xmx:_DUzaQjGEvZq3ITBE7g0TO9w70jezsrMDU-zzQq8pTQ1x74XbKLKeYbX>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:43:55 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Usama Arif <usamaarif642@gmail.com>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 01/11] mm: Change the interface of prep_compound_tail()
Date: Fri,  5 Dec 2025 19:43:37 +0000
Message-ID: <20251205194351.1646318-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7020D180013
X-Rspamd-Server: rspam10
X-Stat-Signature: e19wmgkgphdmiyqjwpz8bmruc3f7yjyd
X-HE-Tag: 1764963838-281709
X-HE-Meta: U2FsdGVkX18nnGPVNIvB0f9YrPp/aicDefQmtrDFMRsJ0//9lXIJzwjbWJ+v5vkP293/TGP71ZRhCgHkSTn+bE7Rd6qvIASKdFkgygvsxt9+yKTqZspW68TWjd4Gyh0wK/+XgMCjIbifvN0LnXZsz3kMtD93f4M+GvMII+ti3zVRwDE0gObbUJH/4QK/2nlKIh+0szczmYyHiXO8/nZj8eXKP977adJYjHggF0N4R2WaWOSlfI7fCDqrWp4eiLocbc3YSBXxHeuJ93DREYFTdAoeZ3zpPFA18X9b0v4ocmTGIx/R3utv0mRZjw6m0+XzefZ6sUyE6n03/l5NmWPCPa4ZSLu74D0QEaxcf53AmWD1Q7sS+CEppeA900NBSn/tezmH+Fv8kVnGUPU/Rgl7ihZ4wZaKd1EYoP4k/Wbk7Hfgl2w17dtO1mvsTNvP+G5S39CNlbtAKhZnJ7aW9RLIFVrxWNFw6YHSvUccSwA4bNYTOE4meOZ2UUrDt47Ie+9ThmKPv/jd2VYZJpLEOxr6v7piddKhn0quHX8UaEmYs6Jw5+ZfYorGyijGImO85r7IXT6laRFGxyLIi7KRqFYYI/azl8CkOSRy+CzuH+zP52BJHxggVqybsaqBRV8sbdLDgj42G6FpITq6HuFecWqUazUvvZAsa2VNpH6Be8KHjCuVany5ucGkTNgGB4E6FnVTibN7RD7fthAK5XAi0SkEj5GU5slNO9NZFkot0jatdEcBNSWWCdufGJUJbZ/+WVv2NBL6ssJ74LSiE6+csAg6VZcEbN8FpJIovhpXVUvRYasdQ8RnJ6LFfkBWktwx3jjZzLvFI/BVYrya34xXbpKwseFQkVTLR4lNJL1ps3P+biUNJnYl+1yoCo2eQP4/fUjAZeOmgrIflCLZ5RNqjoX4hszQlxPngYykHshx+ufcugdjSb/1jPbiVL/ZqVJzlDmXebWSNnnbZumIdcQ09H2
 +pgvPlgG
 KbZMC4Lciw0teZx9YwUa93jn13e0dU7cNppnbT3th+uc+U1kmmXHSzHTvA94WqGIUuMMU/CEd61kYsyl3ZLP29Aoql5oCt3U5Z+SFVoroVerRVJVKhHlVNp9X9p+SxKEiMXAn1yk4sKlmTjZt2b9dO0ah789Ufz3VW7WNMwCDXjlALEEnKPEDnoUj1+mQvIdhp6p1s0x/mxLhrklT8XSGSiOeqLgElCaBDyTnwtJf7lqvitqiFOC0bgQIl3F8NAHr0aY5O4/fmkgzlSpk5qrrLhicT0xNsTWgWFT8AQ8aRZ/6uv2fkjoD277HnQ==
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
 mm/internal.h              | 11 +++++------
 mm/mm_init.c               |  2 +-
 mm/page_alloc.c            |  2 +-
 5 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0091ad1986bf..2c1153dd7e0e 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -865,7 +865,9 @@ static inline bool folio_test_large(const struct folio *folio)
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *page, struct page *head)
+static __always_inline void set_compound_head(struct page *page,
+					      struct page *head,
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
index 1561fc2ff5b8..0355da7cb6df 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -810,13 +810,12 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
 		INIT_LIST_HEAD(&folio->_deferred_list);
 }
 
-static inline void prep_compound_tail(struct page *head, int tail_idx)
+static inline void prep_compound_tail(struct page *tail,
+				      struct page *head, unsigned int order)
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


