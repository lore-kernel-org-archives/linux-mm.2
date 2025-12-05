Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1DED3748A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61A046B00A5; Fri,  5 Dec 2025 14:44:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1776B00A6; Fri,  5 Dec 2025 14:44:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4931F6B00A7; Fri,  5 Dec 2025 14:44:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 243406B00A5
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF0B288731
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:01 +0000 (UTC)
X-FDA: 84186443082.13.BA8C57E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DC3778000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:43:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B50gJJe+;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963839; a=rsa-sha256;
	cv=none;
	b=jtoACuJdliP+x/lPFPT48Kx3YePztd+2etLpEUDvreeg5DxZ3eBGt6GlHIzw2Lz/I47V50
	7CL29a6WNnMbqLQ3XPLrCsbhTnLK+Z8GMWf/9YmX6CiEzwMVKduuKjL9u+R4tihmSA3tgd
	sErAiPvrBqHF4RYjoe0CNSNjx8LL4yI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KN3k01qXdQF2epr2K802FQKSrDMrpnUVF4u+hivAXuA=;
	b=B2kVPPbAGTCyrUP+RcSgScWWrA574U9sOHxUbl9IMJF5zGWyO4IRvqdNFyGYZ2f8sydfJ/
	/C0W07x3upkctxhFTHeh2mWSacnD14k8IXNZ+qZI+VzkpEQFxDIOBk7E5MOhdpedniiBRa
	wCU5G0zQ530mKZ9d0grOJaS0hhAuU8w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B50gJJe+;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 50049600C4;
	Fri,  5 Dec 2025 19:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A7BC4AF09;
	Fri,  5 Dec 2025 19:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963839;
	bh=Ax0XJ3SLkb8eRcjcIlng0zDw88FzPQRgdgX0WIl+XlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B50gJJe+zy2CmyadOs9v2nJwfOBawMgzgYYaRwCkL0bWZb43RXMgGzz8YqndkhnlE
	 p0tlM5pPw9fjIeae5ef2AhgkMFqe8QVsJYZ3dOjUsfsYwapA7Tx9ReIV8kYLVmFfPH
	 FiYMGEsNTIBOBD4VJVMGQi1oe3221/RFrrDqb/AW0zQMr0D4OmZDBKRAcTr0zxpezx
	 jYnksKWelwvfB8Uscz2gMsfY5ix25fMgsjZUGEEiSJFa6chIFL8YWwUfiZIKERer3v
	 FuVIIW08rbCRtnzsZdz8J1CJwWKFJhbQ5jsOxWr3j3CDk7qHNGj2qXEGmF+h0pjlOv
	 Jhpfpam8jRUTw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id B4A18F40070;
	Fri,  5 Dec 2025 14:43:57 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 05 Dec 2025 14:43:57 -0500
X-ME-Sender: <xms:_TUzaQ2zRfgODJ8GiHU_OOOdDKkxPgb0kIB1EPbhADsaBFus6pm_2g>
    <xme:_TUzaceBoQwcqq-MXj6onckAP6UjVs8dDKO86h6sgSAFwmdwqsYWsQWa_Sorxxy76
    o-VyNnZawGvQYm7dvrcheEhVtjWVK_Vf6ZS7IrZJcyvzQxg5ZdpDls>
X-ME-Received: <xmr:_TUzaSLLh0xxlkg2mI4VTkFqNlB9o6SV6PJfxtCHOzQYrR3WIOM2C26ycEckgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdegucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:_TUzaSHAoFk4AU4laEnfnnusDl9OaiK8H_75DEfZRXgkE365mRwJKg>
    <xmx:_TUzaZ59IWgSGeDipfDQffzuYB_eVFJ_NPvhYg_x1BTJU2FsNC_yWQ>
    <xmx:_TUzad3NqVN-BAfSzs9p5lfRSalpgVUpgz_s9R4iIf5by7LX-Wz0Ow>
    <xmx:_TUzaViH7E22QzLY3Z1ngcP-2Zc7FFj3JkmCBFgQjaQPNURR7NBZrg>
    <xmx:_TUzaZToJOl_fvZlwmX5en7a_AhITgyPBo8C9pIeRjWto-ZQeiKG93-s>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:43:57 -0500 (EST)
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
Subject: [PATCH 02/11] mm: Rename the 'compound_head' field in the 'struct page' to 'compound_info'
Date: Fri,  5 Dec 2025 19:43:38 +0000
Message-ID: <20251205194351.1646318-3-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC3778000D
X-Stat-Signature: db37xrmmh995bf7qxn4wgbuxudprugca
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764963839-993982
X-HE-Meta: U2FsdGVkX1/G3TD1jzJkDVWA5eKZGPvQFbSf2gTZAAUhbQnrru6ape1TbNf6zE05Hm5oI1K7q2UExqkpOhqZ/l7rDpiY9RJmkth4aXV+MBa7M5b/vGLpKmaqqDiuGb964bEuSPMfKsg+TY7KAjFLokv3t2lDmBgPQHQKP0Pi6rV9sKNeyU35/ILtzli4ixX0FF3UJisc1Cy/QmRMYD0VdYZ6sgS/cOrQA+npxx1FHN86a81Rq//0z3CnfYDnCSI/dWCREvVBePcD7OkyjjPLn9hl9Mf5nEbJU0GnLHa2hC7pvCZhBruAUowvdhJhuwDDjppsa8MptgjeSUyfapjOICXZ/9VjU6JoLkYBAhGfMY5TKkKFCJLPmBEUDZ4WakEwHSQtdx/9Gd4fi+9yT3oY/E1cF2Qybg5ln9HobPh3MoyUGdioHBnccnJ75vQkddgMyMQup0MtFcrvkUi//R5vIIkE8AdYlr5uwTVYKkfSRtoTQxRC494zTF/gRIE2Df0IUheaz6C1vhPjPnGRNm/VWn122Td7Azr/iBikOWwY/xIzBjGj3q/Y6JkiXj8GSlwjJt2c1NOb8WkoOFwDSUZy9O93gdnYBYQVrtoxQj6UyQr1znhuzSmuej7NBSJBtc1oiHNQIDay4f+4yjYl3B7zJNXdUpzshpX1MsIe1cUgxD6B3VjSLcWbgBIxbfMnzsQPEKSdiiogfgb7JCq6t34Q7Wx/UHHVTI2spEKVzdqSQd8K9oILsW6+03IA7tdZXavRZKzAyTHYANfNAEA6Lyu/GIU/tSEN3/ZIYMto0p3OaUGApGbuatfOm19r+yK4Hhs0M+XUW/hXn5Y6pkq6cD+JjNvPDspZFALdokQpxzFCZ/FS2P6nLik6OQXvwJvUkZXi23CtEziXZV5AifT/Hbjyg0Ro+KY2ri8nyEr3ACrhwI4bVXhVZePyfmOBwOeak/JW+fA3RHeL05nGc1f4ILK
 4H03RCdW
 EQuq/hGLACbrf45q9DoCDyA0vnQQ5V0p1IZkWZRIxafoFzS4R6LCRA4YDMCNyVwySBiuOaWFrYRIVQf3oW1urjlwpnHVLHhh2AGJ6cl7erDEsOpSCnFuGYPcrB77anrKBM1yGbCb1A7oZ0A1bg4U5g3PFDSSFkqpd8Ect69+P1Pok3jtX5uobGuvRGA+IVoSn2I9bnLJaq6AR5D9DbU/WJrzZwGI037HTcCVb2QeNwgosNNPIjmM03Q4GFXg4O521gjITK/O1w2uqGMQHk0iEHCnYS+tc0i6oJjsNLE55lcWefbXHP2jX5oDBCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 'compound_head' field in the 'struct page' encodes whether the page
is a tail and where to locate the head page. Bit 0 is set if the page is
a tail, and the remaining bits in the field point to the head page.

As preparation for changing how the field encodes information about the
head page, rename the field to 'compound_info'.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 .../admin-guide/kdump/vmcoreinfo.rst          |  2 +-
 Documentation/mm/vmemmap_dedup.rst            |  6 +++---
 include/linux/mm_types.h                      | 20 +++++++++----------
 include/linux/page-flags.h                    | 18 ++++++++---------
 include/linux/types.h                         |  2 +-
 kernel/vmcore_info.c                          |  2 +-
 mm/page_alloc.c                               |  2 +-
 mm/slab.h                                     |  2 +-
 mm/util.c                                     |  2 +-
 9 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
index 404a15f6782c..7663c610fe90 100644
--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
+++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -141,7 +141,7 @@ nodemask_t
 The size of a nodemask_t type. Used to compute the number of online
 nodes.
 
-(page, flags|_refcount|mapping|lru|_mapcount|private|compound_order|compound_head)
+(page, flags|_refcount|mapping|lru|_mapcount|private|compound_order|compound_info)
 ----------------------------------------------------------------------------------
 
 User-space tools compute their values based on the offset of these
diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index b4a55b6569fa..1863d88d2dcb 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -24,7 +24,7 @@ For each base page, there is a corresponding ``struct page``.
 Within the HugeTLB subsystem, only the first 4 ``struct page`` are used to
 contain unique information about a HugeTLB page. ``__NR_USED_SUBPAGE`` provides
 this upper limit. The only 'useful' information in the remaining ``struct page``
-is the compound_head field, and this field is the same for all tail pages.
+is the compound_info field, and this field is the same for all tail pages.
 
 By removing redundant ``struct page`` for HugeTLB pages, memory can be returned
 to the buddy allocator for other uses.
@@ -124,10 +124,10 @@ Here is how things look before optimization::
  |           |
  +-----------+
 
-The value of page->compound_head is the same for all tail pages. The first
+The value of page->compound_info is the same for all tail pages. The first
 page of ``struct page`` (page 0) associated with the HugeTLB page contains the 4
 ``struct page`` necessary to describe the HugeTLB. The only use of the remaining
-pages of ``struct page`` (page 1 to page 7) is to point to page->compound_head.
+pages of ``struct page`` (page 1 to page 7) is to point to page->compound_info.
 Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of ``struct page``
 will be used for each HugeTLB page. This will allow us to free the remaining
 7 pages to the buddy allocator.
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 90e5790c318f..a94683272869 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -125,14 +125,14 @@ struct page {
 			atomic_long_t pp_ref_count;
 		};
 		struct {	/* Tail pages of compound page */
-			unsigned long compound_head;	/* Bit zero is set */
+			unsigned long compound_info;	/* Bit zero is set */
 		};
 		struct {	/* ZONE_DEVICE pages */
 			/*
-			 * The first word is used for compound_head or folio
+			 * The first word is used for compound_info or folio
 			 * pgmap
 			 */
-			void *_unused_pgmap_compound_head;
+			void *_unused_pgmap_compound_info;
 			void *zone_device_data;
 			/*
 			 * ZONE_DEVICE private pages are counted as being
@@ -383,7 +383,7 @@ struct folio {
 	/* private: avoid cluttering the output */
 				/* For the Unevictable "LRU list" slot */
 				struct {
-					/* Avoid compound_head */
+					/* Avoid compound_info */
 					void *__filler;
 	/* public: */
 					unsigned int mlock_count;
@@ -484,7 +484,7 @@ struct folio {
 FOLIO_MATCH(flags, flags);
 FOLIO_MATCH(lru, lru);
 FOLIO_MATCH(mapping, mapping);
-FOLIO_MATCH(compound_head, lru);
+FOLIO_MATCH(compound_info, lru);
 FOLIO_MATCH(__folio_index, index);
 FOLIO_MATCH(private, private);
 FOLIO_MATCH(_mapcount, _mapcount);
@@ -503,7 +503,7 @@ FOLIO_MATCH(_last_cpupid, _last_cpupid);
 	static_assert(offsetof(struct folio, fl) ==			\
 			offsetof(struct page, pg) + sizeof(struct page))
 FOLIO_MATCH(flags, _flags_1);
-FOLIO_MATCH(compound_head, _head_1);
+FOLIO_MATCH(compound_info, _head_1);
 FOLIO_MATCH(_mapcount, _mapcount_1);
 FOLIO_MATCH(_refcount, _refcount_1);
 #undef FOLIO_MATCH
@@ -511,13 +511,13 @@ FOLIO_MATCH(_refcount, _refcount_1);
 	static_assert(offsetof(struct folio, fl) ==			\
 			offsetof(struct page, pg) + 2 * sizeof(struct page))
 FOLIO_MATCH(flags, _flags_2);
-FOLIO_MATCH(compound_head, _head_2);
+FOLIO_MATCH(compound_info, _head_2);
 #undef FOLIO_MATCH
 #define FOLIO_MATCH(pg, fl)						\
 	static_assert(offsetof(struct folio, fl) ==			\
 			offsetof(struct page, pg) + 3 * sizeof(struct page))
 FOLIO_MATCH(flags, _flags_3);
-FOLIO_MATCH(compound_head, _head_3);
+FOLIO_MATCH(compound_info, _head_3);
 #undef FOLIO_MATCH
 
 /**
@@ -583,8 +583,8 @@ struct ptdesc {
 #define TABLE_MATCH(pg, pt)						\
 	static_assert(offsetof(struct page, pg) == offsetof(struct ptdesc, pt))
 TABLE_MATCH(flags, pt_flags);
-TABLE_MATCH(compound_head, pt_list);
-TABLE_MATCH(compound_head, _pt_pad_1);
+TABLE_MATCH(compound_info, pt_list);
+TABLE_MATCH(compound_info, _pt_pad_1);
 TABLE_MATCH(mapping, __page_mapping);
 TABLE_MATCH(__folio_index, pt_index);
 TABLE_MATCH(rcu_head, pt_rcu_head);
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 2c1153dd7e0e..446f89c01a4c 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -213,7 +213,7 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
 	/*
 	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
 	 * struct page. The alignment check aims to avoid access the fields (
-	 * e.g. compound_head) of the @page[1]. It can avoid touch a (possibly)
+	 * e.g. compound_info) of the @page[1]. It can avoid touch a (possibly)
 	 * cold cacheline in some cases.
 	 */
 	if (IS_ALIGNED((unsigned long)page, PAGE_SIZE) &&
@@ -223,7 +223,7 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
 		 * because the @page is a compound page composed with at least
 		 * two contiguous pages.
 		 */
-		unsigned long head = READ_ONCE(page[1].compound_head);
+		unsigned long head = READ_ONCE(page[1].compound_info);
 
 		if (likely(head & 1))
 			return (const struct page *)(head - 1);
@@ -281,7 +281,7 @@ static __always_inline int page_is_fake_head(const struct page *page)
 
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
-	unsigned long head = READ_ONCE(page->compound_head);
+	unsigned long head = READ_ONCE(page->compound_info);
 
 	if (unlikely(head & 1))
 		return head - 1;
@@ -320,13 +320,13 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 
 static __always_inline int PageTail(const struct page *page)
 {
-	return READ_ONCE(page->compound_head) & 1 || page_is_fake_head(page);
+	return READ_ONCE(page->compound_info) & 1 || page_is_fake_head(page);
 }
 
 static __always_inline int PageCompound(const struct page *page)
 {
 	return test_bit(PG_head, &page->flags.f) ||
-	       READ_ONCE(page->compound_head) & 1;
+	       READ_ONCE(page->compound_info) & 1;
 }
 
 #define	PAGE_POISON_PATTERN	-1l
@@ -348,7 +348,7 @@ static const unsigned long *const_folio_flags(const struct folio *folio,
 {
 	const struct page *page = &folio->page;
 
-	VM_BUG_ON_PGFLAGS(page->compound_head & 1, page);
+	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
 	return &page[n].flags.f;
 }
@@ -357,7 +357,7 @@ static unsigned long *folio_flags(struct folio *folio, unsigned n)
 {
 	struct page *page = &folio->page;
 
-	VM_BUG_ON_PGFLAGS(page->compound_head & 1, page);
+	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
 	return &page[n].flags.f;
 }
@@ -869,12 +869,12 @@ static __always_inline void set_compound_head(struct page *page,
 					      struct page *head,
 					      unsigned int order)
 {
-	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
+	WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
 }
 
 static __always_inline void clear_compound_head(struct page *page)
 {
-	WRITE_ONCE(page->compound_head, 0);
+	WRITE_ONCE(page->compound_info, 0);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/include/linux/types.h b/include/linux/types.h
index 6dfdb8e8e4c3..3a65f0ef4a73 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -234,7 +234,7 @@ struct ustat {
  *
  * This guarantee is important for few reasons:
  *  - future call_rcu_lazy() will make use of lower bits in the pointer;
- *  - the structure shares storage space in struct page with @compound_head,
+ *  - the structure shares storage space in struct page with @compound_info,
  *    which encode PageTail() in bit 0. The guarantee is needed to avoid
  *    false-positive PageTail().
  */
diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index e066d31d08f8..782bc2050a40 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -175,7 +175,7 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
 	VMCOREINFO_OFFSET(page, private);
-	VMCOREINFO_OFFSET(page, compound_head);
+	VMCOREINFO_OFFSET(page, compound_info);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
 #ifdef CONFIG_FLATMEM
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fe77c00c99df..cecd6d89ff60 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -704,7 +704,7 @@ static inline bool pcp_allowed_order(unsigned int order)
  * The first PAGE_SIZE page is called the "head page" and have PG_head set.
  *
  * The remaining PAGE_SIZE pages are called "tail pages". PageTail() is encoded
- * in bit 0 of page->compound_head. The rest of bits is pointer to head page.
+ * in bit 0 of page->compound_info. The rest of bits is pointer to head page.
  *
  * The first tail page's ->compound_order holds the order of allocation.
  * This usage means that zero-order pages may not be compound.
diff --git a/mm/slab.h b/mm/slab.h
index 078daecc7cf5..b471877af296 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -104,7 +104,7 @@ struct slab {
 #define SLAB_MATCH(pg, sl)						\
 	static_assert(offsetof(struct page, pg) == offsetof(struct slab, sl))
 SLAB_MATCH(flags, flags);
-SLAB_MATCH(compound_head, slab_cache);	/* Ensure bit 0 is clear */
+SLAB_MATCH(compound_info, slab_cache);	/* Ensure bit 0 is clear */
 SLAB_MATCH(_refcount, __page_refcount);
 #ifdef CONFIG_MEMCG
 SLAB_MATCH(memcg_data, obj_exts);
diff --git a/mm/util.c b/mm/util.c
index 8989d5767528..cbf93cf3223a 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1244,7 +1244,7 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 again:
 	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
 	memcpy(&ps->page_snapshot, page, sizeof(*page));
-	head = ps->page_snapshot.compound_head;
+	head = ps->page_snapshot.compound_info;
 	if ((head & 1) == 0) {
 		ps->idx = 0;
 		foliop = (struct folio *)&ps->page_snapshot;
-- 
2.51.2


