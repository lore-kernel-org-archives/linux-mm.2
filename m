Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB0A5D25B7E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511526B0092; Wed, 28 Jan 2026 08:55:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F26E6B0093; Wed, 28 Jan 2026 08:55:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2076B0095; Wed, 28 Jan 2026 08:55:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B80B6B0092
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:55:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B75B9140671
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:31 +0000 (UTC)
X-FDA: 84381520062.25.406A093
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C204D4000E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QGOv4l2c;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMRq5wMhVbpslAhyqI1bSmFWBPzOsf0JCt2RvbCfjrw=;
	b=qFPns06f0onsweUyS+mr9pYslYW4rIvOnL9TvesLgSbbjylaXrwlxbd9bcKMxQ5gApe0W6
	/osQQrO2+Nl1UrEt7itZeY4HwBApLySULaTn9hhbfWFru66T531Q2lLkai1JC/AgpChuFT
	gpdLLo4nSA0DL3kYXlOb2CgTLiguuaE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QGOv4l2c;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608529; a=rsa-sha256;
	cv=none;
	b=yR4rXczYwllKBuOjekV3Ql2Iv0bKVCEaq+Tmbup2syyIhPj9jxfE+islEpLMFB4FOdi6lI
	Gy2GAFLix5srlr032uDrTVt9L86G9oKLxePdbCnkFaGMX3Lrrbsn6KhqLKyBBx4WWcUrJU
	jRGIql44PmvEfO8xIigE68XPVgLH0dY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15DD4600AD;
	Wed, 28 Jan 2026 13:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D0EC4AF09;
	Wed, 28 Jan 2026 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608528;
	bh=fvKzR9y+Y1eBDZHK9QCNCGvHnfLe12zGhGoezC4hzvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGOv4l2cqU0kvMiq3Nr5imQn0K3yEJ/mkaLLn6ctZNwbLC0/bRK6DvYAjiYrkvIqZ
	 /7q6m2533lZntBhIy+n81nr3pTKUC4i71jWQMeczt7HGTNQE/FnKQbcmgpko2za6Z2
	 obNMrPEFa4ZHN/0akLlAD88u4tpJLasbfeEdo+8HvYbjrzrrib6Kna7RGmNtu0aCY7
	 zLU9Z/cqciO46wlMk5OTnPkREMOJLFjWqhWyBrXYaR4piCRc35Zogs77Qp5Wu3WHLW
	 m/wGGdnPP5T59lo6sPIzasDpaGpanRw1wDvRzxWOXVt/rTvlDYliT2fIC8JFUUrNw9
	 XmbljAsYMfeRQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id C77CAF40069;
	Wed, 28 Jan 2026 08:55:26 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 28 Jan 2026 08:55:26 -0500
X-ME-Sender: <xms:ThV6aZjirgVBh01eTIKUdNWgPzrEJ0gBLXO4Tw0VfGmFKAwExRjs5Q>
    <xme:ThV6aXMU3I5KpJFzBYIXZArJ-LuMuOuUc1e1VA5yKn2NugzPenUhSNz5FtLptH2I3
    Sdpt8WIssSU79pW81Ukfkc1vBTtkkpJH-dsdsVXIw6QNap3eJm->
X-ME-Received: <xmr:ThV6aTPoxR9vHuW53T056huwG8nlsUVQhHnbpzjfs2lH28M-Uf8SpemVVUQnDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:ThV6afICCdzG0iZgPYKntIcisR2yIdaFJ8akDuyVFJe-wiuIQ6oV9g>
    <xmx:ThV6aSuXTkCzkBA49UL-2J23Mmn03efPMYhItXz4uGCjAQBhKaEPew>
    <xmx:ThV6aRGDNh8TxO_5bhbrS8qBqCmTo9mdJ19rh1LHZ3EOttUNutaTAg>
    <xmx:ThV6aRN8CALXmsWaprTTg7zOrpOUXyXNACikjVGFVaCY3byPdkIHBQ>
    <xmx:ThV6aUHGocZO9mIRLwsfV0stOummGf-SnM1Lp82MWX_I95TLPKOqGq-l>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:55:25 -0500 (EST)
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
Subject: [PATCHv5 03/17] mm: Rename the 'compound_head' field in the 'struct page' to 'compound_info'
Date: Wed, 28 Jan 2026 13:54:44 +0000
Message-ID: <20260128135500.22121-4-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C204D4000E
X-Stat-Signature: uhuskdj5ozjmqbrxq5uxyuzerzdbzqpu
X-Rspam-User: 
X-HE-Tag: 1769608529-574575
X-HE-Meta: U2FsdGVkX1+IenEP1PygPaIkQMgRKhpDR0iTv02sVaHO/jrPtr/1PWjomES9UObazpY25JOkt4D3Gs2bciiSXTGB2O32b30iPM3frqGkSIB7jIg2s5/cLPnw6uyAM5EIafmevwwjmS4vvAFE8Gki/SsriLEDqeNktheh5nM5TosFiCxHrJ3te144xP51gkDTn0Mq1QrYpvQqYJo28wKqWoI3JNI/RadywKDICCmImjYoFtGDoxaOow1blsiyiHGbG9XMv2W3PIJOHbMtfM2f9GhFSUQ5k+x/K7krpCHWgH8zb8nTFmvwUklKIdp4HjanXYeSVsy1IduoxbzZkL/jsuGQ8zXxn50WzmVoPKOv9xJ3mAl7rwzQPxdrduNDswoFHZRILMvSJH9zYS/jWKX7cHO24FuoRgdYXH0eNe7Lf9LkvXO1CpD0zibwjmLIicLZhyPTnrgSxoU1XOVFXmNExJMo9+3tm3UcMDM0i4AIjhOkum/pze5dv75XxZE2xGFj8QCP1l+diNLerL081c/XikLVy5C5rl41yS5Sz8dYwhoozpTQpyoz3OjPJfplSCK8TOCsFK7vwimdSgLx3JqZdlGG42qjdwAhppO/r1+xxKAaHRkbjdEmD1czCuVxErcIMwF2FgEVloBriBpK8FylQySkcV/ybaSHGLC1w81gvPdXYNUMcj7RxhB4M93vC0k7xHD54tltUMObYOSuImzwzltvo+BimdA8oQWYB43vfEx3AfGmKLhN07RtHmk89OSB0PwC2O9ExcCsPg8Xig270KdSDw2MkA5RtIEjEg5ZQ+1/PYzS/Dv1GybI7mE5BMim4IPitdZvZa4+1IdGASE5O6QIMA4kWiSRKk1IWHEjNc09PzDGzOnmWbMvfNhhPnFInn28IevhaUbHFREpy/94dOHtKJN0WHMBHHtXVX1Fq+NazGbD1et6BEIuDPwK053BICMejXBxYrwCmd4ICiD
 8w9aSpb4
 DrILp/lvbl2KZlV/pm7483zDMjECtaAgCdM3IwMchEwqOb9YAcrWxEYTgJMwHbNQsFW1XJc1VgMk5EcKYOigdye9Omm0c+2MPSsOob3J6q4qzXY2npOFWusYvgvGu1k+WM/IWpIXxx8OvOkNxTlofovscTwhsY/7S7VhF7VpQ0QCwhkXfY7Ybqs2ZvcS31DX8PCuybjvB+y2ikC2QY2gf42aFg6LLFSnfcqsSciV2vyydNiRJIeD4+luImJfI12bpYR/Ue5OnzlLS7qMKM0BczXmhkK0fDpZuOiwkfuRMJlKdqplrmlcDaZwcbTPv+RtfTmnz7G+mqGRU2dI=
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
Reviewed-by: Zi Yan <ziy@nvidia.com>
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
index 3cc8ae722886..7bc82a2b889f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -126,14 +126,14 @@ struct page {
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
@@ -409,7 +409,7 @@ struct folio {
 	/* private: avoid cluttering the output */
 				/* For the Unevictable "LRU list" slot */
 				struct {
-					/* Avoid compound_head */
+					/* Avoid compound_info */
 					void *__filler;
 	/* public: */
 					unsigned int mlock_count;
@@ -510,7 +510,7 @@ struct folio {
 FOLIO_MATCH(flags, flags);
 FOLIO_MATCH(lru, lru);
 FOLIO_MATCH(mapping, mapping);
-FOLIO_MATCH(compound_head, lru);
+FOLIO_MATCH(compound_info, lru);
 FOLIO_MATCH(__folio_index, index);
 FOLIO_MATCH(private, private);
 FOLIO_MATCH(_mapcount, _mapcount);
@@ -529,7 +529,7 @@ FOLIO_MATCH(_last_cpupid, _last_cpupid);
 	static_assert(offsetof(struct folio, fl) ==			\
 			offsetof(struct page, pg) + sizeof(struct page))
 FOLIO_MATCH(flags, _flags_1);
-FOLIO_MATCH(compound_head, _head_1);
+FOLIO_MATCH(compound_info, _head_1);
 FOLIO_MATCH(_mapcount, _mapcount_1);
 FOLIO_MATCH(_refcount, _refcount_1);
 #undef FOLIO_MATCH
@@ -537,13 +537,13 @@ FOLIO_MATCH(_refcount, _refcount_1);
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
@@ -609,8 +609,8 @@ struct ptdesc {
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
index 8a3694369e15..aa46d49e82f7 100644
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
index f69be881369f..604697abf151 100644
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
index 46198580373a..0a46df3e3db9 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -198,7 +198,7 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
 	VMCOREINFO_OFFSET(page, private);
-	VMCOREINFO_OFFSET(page, compound_head);
+	VMCOREINFO_OFFSET(page, compound_info);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
 #ifdef CONFIG_FLATMEM
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 00c7ea958767..cb7375eb1713 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -731,7 +731,7 @@ static inline bool pcp_allowed_order(unsigned int order)
  * The first PAGE_SIZE page is called the "head page" and have PG_head set.
  *
  * The remaining PAGE_SIZE pages are called "tail pages". PageTail() is encoded
- * in bit 0 of page->compound_head. The rest of bits is pointer to head page.
+ * in bit 0 of page->compound_info. The rest of bits is pointer to head page.
  *
  * The first tail page's ->compound_order holds the order of allocation.
  * This usage means that zero-order pages may not be compound.
diff --git a/mm/slab.h b/mm/slab.h
index e767aa7e91b0..8a2a9c6c697b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -100,7 +100,7 @@ struct slab {
 #define SLAB_MATCH(pg, sl)						\
 	static_assert(offsetof(struct page, pg) == offsetof(struct slab, sl))
 SLAB_MATCH(flags, flags);
-SLAB_MATCH(compound_head, slab_cache);	/* Ensure bit 0 is clear */
+SLAB_MATCH(compound_info, slab_cache);	/* Ensure bit 0 is clear */
 SLAB_MATCH(_refcount, __page_refcount);
 #ifdef CONFIG_MEMCG
 SLAB_MATCH(memcg_data, obj_exts);
diff --git a/mm/util.c b/mm/util.c
index b05ab6f97e11..3ebcb9e6035c 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1247,7 +1247,7 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
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


