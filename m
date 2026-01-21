Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 260FAC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B166B0092; Wed, 21 Jan 2026 11:23:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DA46B0093; Wed, 21 Jan 2026 11:23:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3FC6B0095; Wed, 21 Jan 2026 11:23:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F02186B0092
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EB69D34C0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:06 +0000 (UTC)
X-FDA: 84356490372.09.7873C68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AA7C2A0014
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RdexS5rs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012584; a=rsa-sha256;
	cv=none;
	b=p8AeDylOkMnN9XuHJ2ieYSwHIwzqNB9aHojzw0hyCPp5/tKHmCsCGUB0sen+JSbKmWq1gk
	FE13x8rykcMDWBznZRcPNFjQQ+0FLCHnQXOMdXY2kdQ9jZP4BO2yk0+yKpqyYu98M9IrlX
	jLGsmJHz+IHYFmfou8YMMSOKu9H7Lfg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RdexS5rs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WF5g/Bs31inOpspSZ7gzcrBpaSpUOPLoOk1klCf4MKs=;
	b=Zzd52/qT5HNdanLO8mSAzd482Yj0ZV1+SG7XyXbAoVM7PEY0JYPnLZ+o9abHe69EjnQZZB
	AADK91IJVRuNdYmu/aXhiMiTBQaiuuSYpUr+8EMxtdr3dGszMptHQ9JQhdD9vh8H2V/xpN
	gJzUqIvboadHDQEvhB5hErQWiTtRZ6I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15BFB60130;
	Wed, 21 Jan 2026 16:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C51C19424;
	Wed, 21 Jan 2026 16:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012583;
	bh=i+BbGSx7w1/9QRLZPjCHH351V3zfwSVDU5fmUf6X6P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdexS5rsfcLxy/cvXtSXN40RD+dELfB25QQ1FMqKNGCKBUKuI5VOV4gAkcfE04lKv
	 9r8A4WZfPykR35PsHDFqE25R/U4FrudaQolGqh7bJOwuVty1GqWMTV9yLaAkDkTqts
	 dgzV+RrL9K6Lp80o3f8z+SyXJ/HY8arhW0SBoLDWyVHaTLgEOWJU7HHvn0mAarAXIf
	 YHdCpUzKxz515Z3sfz8Yrl1LnWsoRCV9n16fEL6zKNv+3cwL7tK01jMI55IP9hzm0J
	 GX3IcykDyhiqoRswoQeZwieJt43bWia3B0zEJEVynY5Cq68P+EMu1j1sERCbLQSYt1
	 0MNCVArmvUyhA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 66849F4006B;
	Wed, 21 Jan 2026 11:23:02 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 21 Jan 2026 11:23:02 -0500
X-ME-Sender: <xms:Zv1waZ0OVXgBqoyGgKodCh6MeROCaBl8e9vi2WS4n7gaYXsMZ1ejMA>
    <xme:Zv1wafV-ymru27eVwtqyFITzNMwjM5v12s-HjtVWXzLkZwJiQ3ab3XlnlKXBuFVJD
    eLD7b_Qr9NwYr3SK70BkIP5DpKQjd2po0KZpEZIDa-xL5aoQRnclA>
X-ME-Received: <xmr:Zv1wacsggwBiWTXjB4snX8Hp1eJqvtVn2Y2jQdKpPzLauMSezBLiim-78YrAaQ>
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
X-ME-Proxy: <xmx:Zv1waeUvQclO2wRcG4Sv_unLnGaguOyPhx_CECOnwAe8UDC8_LLipQ>
    <xmx:Zv1waQVrMTIp2drx1ItyIbb63a2VbZyyTy9sboiodaoIpUT16CerIw>
    <xmx:Zv1waQde0J_Y-UcGKACz9NipxlALfe2Un91mZigOFtDN4Or9p6-t9Q>
    <xmx:Zv1waf45ugnygeqAt6EMLv-wuVvgHaMyPynk0UXvn5wS3dpRulfTOA>
    <xmx:Zv1waTTP_4GoNWdVt5IRYTWO-GAQ0yVkONEQFlLFKDRUWHbjWH10p2Jo>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:01 -0500 (EST)
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
Subject: [PATCHv4 03/14] mm: Rename the 'compound_head' field in the 'struct page' to 'compound_info'
Date: Wed, 21 Jan 2026 16:22:40 +0000
Message-ID: <20260121162253.2216580-4-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA7C2A0014
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ff39bwma8h8wjntjo815qbanpr4w8duo
X-HE-Tag: 1769012584-440441
X-HE-Meta: U2FsdGVkX1+ly0wv+FyL26i8cnyq7nUG6cbqQ6m6wb8R1pEIfpmS8+Dxo1i8GeJe88cytP6pLmsC83fwJ3t+eNq1CTOBMMCPrtnxuGx1AHm6vIVfn4JPimD2Sp8ffffUB+QVtXuKUfd4yz0gpcT0LMR3s8bIgOBJz9o10N0KLEsaTAkoBmlTwhC0XfeCczl3KHs25d45UAgzJ/0J8y3c+gCsOjKweEzscs18tKOMFDXjdaT+Ar+k05AaSBkuAeg/5OLvdtqLNqostR8b8B/KxPv9A/PyOrPFZHMKuuWtMRtIK9efa/rdEHIKveiDx5PVVtluC98AzhSEZzBFnnb+8Sl+KZOAzTcXhuP1eZbh+p799zVmIDPmQE4miYIptNjKKEj+PVSHCnWQUOywlihJfN1PJQ4XpGKAayRiVKPNvgDr4iey4o4QojradtWHk4DudY1y1L5RSxa+FksfEZU9kUlECKVSrRSlt5BJsG//WzccxZDZc43sTTwafU8iKTg2NfTyrtb9UopfZbtnHIrzOJN4ZgcJudIbEmgvcAbBJU5e+2maNU7Mb95vkPY3ZogZS4oAILZpuBnhPSr/bf22EdwcknUc7HxJwdHvMTwzm2cbGG1TIf4qVxQvB7W8rzYmlUGsxnvGRRLF/qyJEJn+fQ3lp2wjFfHPCogVLtIN5D2HCDohSlPgLOIWmpQZI3nHWYKOeGtne+e6+Wc7r/RtbCwHp12eqMoLBXpDkXrQdyzpRuIwCkJWIUI8GO0OCm0p2ODjcPFZHgdXoo+yvpjBW7fPp7Sex8MM5gjVvr6UGVCdWpep1DC6r1OFDqbPZg3mbGOK0FHZcVoULifVc8o+bvHrXlUztiQ3KNtNdztQyLm6gF7nsmrleDJw6+Yc2nkABwU6eDRTSop0Q97H6xsFbNY7UL2kSDTrF4Gj3/+Mxfi0JQbDvIQMmzQXDdIXcgYEI6uhk5y9BOkj/da6Hbb
 33QCno3g
 kuJv3r3iC6dkSaGYqU9ykOpBsXbxf2iuWCGooAqXKomlosO0zjfDZiCK9aIy2v/43KU/3GfzN/MrUtO86H+fgv3ov2o96mloxRFlN5GIqi1K756KnFCpind4GueKmRIBmZZQh/4IxqQ+ybBdcuZVJwJWd0PY9BHoh6iSVlnhoOZr2bWjnt/7gABt96JgVpZu+DKL4PBjOUTvWBMaCsuQtZq2wbJ4bETI6+e0nftYBDflg8V2cmxBvxFW2GUiw15Y/gyrC1K+f7Bn3J+uHWgxtYNz2V/1lifEVrwcxuTAD7q8CyqXTyjTYE1gbPA==
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
Reviewed-by: Muchun Song <muchun.song@linux.dev>
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
index d4952573a4af..72c933a43b6a 100644
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
 					      const struct page *head,
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


