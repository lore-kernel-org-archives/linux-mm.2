Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA9C1039880
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C880A6B00C2; Fri, 27 Feb 2026 14:43:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A636B00C5; Fri, 27 Feb 2026 14:43:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7FB66B00C6; Fri, 27 Feb 2026 14:43:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFBC6B00C2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 50D7E1CC1D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:19 +0000 (UTC)
X-FDA: 84491260518.20.2DB0401
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2F3DCA000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fRUxV3gT;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=My64QiK+QR7LlZZWuthvPr0q2BZYC6h9PL9sbKVxwxA=;
	b=KVeT4xQyb7oS4/zjrOQQoIfbez8JX+T8/rXbl59zrtBghZPieC+2BZ+BY9/PzCeUtYuRI/
	/JCv0FxN1R2XiFdCllCpJ8Dua9Y/vs45JN/SLeQ8yq773aoXw5ZA0NrDtkPo7qsl2sl8hs
	aokOkeE757g9JtOnYQQNN9S8hqi45Ok=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fRUxV3gT;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221397; a=rsa-sha256;
	cv=none;
	b=PdUvUfcZylt23//E7pwzGc+6gT1sctaxzZTe8Aw0hwMeyal4lox5DEEX0yeD9RpaGvhPjI
	GOwJkuOYWKIiBoQV1j0VigqqgP4cIFSzRtokUYSdZEvxXerK4L4Yo5zDwdYdukW6GdHBdX
	JJKC5DZ8KtbdpGTVZr1Vz+QwT1amQJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5535B44361;
	Fri, 27 Feb 2026 19:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83432C4AF09;
	Fri, 27 Feb 2026 19:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221396;
	bh=NuLprIvDmoFUiUq0+5noADBwgzQFyl8O/ZHxlfou6Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRUxV3gTyqk0Mk9vzjkkOW4ucW9YSlJek76FvQNqvr6usUTCVescT29kjBX7PS2k9
	 N/6pvdeXBRssw9MKTrIlen3Xro0x9O2Jul3+FxIzXLaGtPu9on8QrOX59j15qtPCGp
	 CIr4BMyj0zABaccpir+EbTbGE7JSl2a/qwk/Eh30R2F+lNty9svE8mIZEcg9mekN11
	 3nBmGd2IfCYOH46zV4vAL4pQjwWI4KasCe4DHLaUOoTnTJ94lnlkw42/VyPx+SJYLH
	 ZUSj5R5CRakOShfei//kL1Q9NY60eVqO3rxAqNB9lb1HYljSy6ZzMSJcsKL++QyOBR
	 jDMCuy8kstUYA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id A9DECF40069;
	Fri, 27 Feb 2026 14:43:14 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 14:43:14 -0500
X-ME-Sender: <xms:0vOhaf4h4bdy05lkY57DgUXt9ENIzv_o1f-Btm05GjtgWQUri5zIkw>
    <xme:0vOhaeG2Pnl5eTS8-y8ous420Eu_J-D-i0O8TZmmAVQj5rxVxj7UxwBalNi0uCFa2
    U81I5yLoFtQW0eMqGiBAmOVaStHiM1annh7Yfk3KkG7uXPD79PzQeA>
X-ME-Received: <xmr:0vOhaQnlG6smwdUOwcOtdntUJ-XoyfJOW8vurYXru4zbv1Maa7Dr8wzpypi6VQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:0vOhaRDuFRo0HwbcVgC5Cs_syKxn4votPkk4zdKHURvps3i3wX-bYg>
    <xmx:0vOhafGmswpPHSmZVlWvQIl_csuTbD-2_rl54v4FdRVXtdxPEUOpPw>
    <xmx:0vOhaV8e8lYeq2sgjy8OLYWNDbFiDimXr0KT7zmt-vupa_1Yh1xHaw>
    <xmx:0vOhaUmwWRotGqDh7iyElyKaoPxVLO4_WJuI-5jvxAIJa8AeGBup4Q>
    <xmx:0vOhaT-F5QsXffJ2k4rvPReQkyIIBvHPFfQoiQ6U-KGIVzoWjDJeF-3e>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:14 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
Subject: [PATCHv7 03/18] mm: Rename the 'compound_head' field in the 'struct page' to 'compound_info'
Date: Fri, 27 Feb 2026 19:42:41 +0000
Message-ID: <20260227194302.274384-4-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y6n5ik3wi647q39khxuwpnk8a78hjkeb
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F3DCA000A
X-HE-Tag: 1772221396-700588
X-HE-Meta: U2FsdGVkX1//8QwQ2d24gP3GN5TtveJSubrTv3B1oNQUJ3qPKOvZ+VHuvD1v2sdLCHE5qAKcdswWuFXiUH0ew98Gl7K2GIBM029dofAE83Xd3omgIPpF4TXz35f9h1h6oJkNM3oS6/0ngCFdNOQ9tlB4XXvfUH4lNYInxZl1AdoG23mpu5oEtiBOJAv7N8XuXrBGy9cq3gFelhPeP0f28teqtzD4MuJV3jxDArHV8kjK/f9/3lFEh1/8E/Q0/x1b28EwDfkvXv4jlsXGDuyGGmycMQ/xL1/hvzOboRtjqRnf/3m5mvWgcZ16O95FkdIvCWQK6acBzWUhqKaELNH4LuznYqWB9RlUSe9Pm7vqLXuFDRrlS/SFWjq1hMKsezEAX9kEeXKvKAp91iK8VgV4hrECJFRJYYJKq3vsCEDVMEEn7R6s5iu4gWSxzsUutVCLIpHi1NdzxaIEH4HDmPzaE1dd6je6zz/v6h9kEUyvgJMaxBx7DrP+AGV+PeoV9OFibRujQMfvqhEN6OhNC+jpWNQWosvnb64xMpxiOltL9+vbwjc1/bQmOSiXDvphf73wTtrqco3kfbMRIU8RdNiyrft2dlSXetifi1FKq1fuypzR0YnRA/RQ8ZtDGxtdlPPiG+bkafuas3CQnUTx0WnNugbuECTSPys9CB3TpTrQacNKxmpAhN9B1YdzsFW5aTQkK/2NxPkxjlPE0bRUhyAJkGBUIqSzPTLyL5/TH2yxOpjDALNBNOcay/YEuKKaR6mCqiwbHfscrTd5pQ7839FtqmQxUSO3gqz5t+crTfnewzR3ClA926tLqE9vjRmL0QlgSZGc45pu+GU1wrC6Lzp9Gy8qyWWVV9YsplulH4o+kZZioHDaeP+/Nn6zDZpgN6B9lo9MqYhIq1ubD3BXQBGOtWpYcsYTuvmyYNhiWj1eFtyczdJOg7oXd98l062qe9T7Ev9VwodL2Rpmk+ME5xm
 T1h8esfz
 btxWIV/HGPMwYkaHS1xAXP7d/O+exdLRzByhG3wiHo+MYW757Expuryt7Y6FiK+mzvHSjz589sbBZqr8SBXoBr/rzh6vJAjVcSnuzkbhhN/fRJjRSLXQ7FjHAFi7PbkInxiIrQFtf4jY2IesIu+blQEZ1wMHwYTU8zkQ52MN+qRdMU8fguJRQkddMFN28/BefLB3MM4CzeQ+lmQFu9PauDTkdGWFfPt604TWrjGxQLPQUXXEkcgC7qqJRuYApyVIVcgLIy0q3OO0dpjNTIGn7vJc+Bib4w6svgFbZCpdhHsQ0rFUOwIuIbdsYe8VWwCiWl7pv5Ww+ygVDMe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The 'compound_head' field in the 'struct page' encodes whether the page
is a tail and where to locate the head page. Bit 0 is set if the page is
a tail, and the remaining bits in the field point to the head page.

As preparation for changing how the field encodes information about the
head page, rename the field to 'compound_info'.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
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
index 5e7687ccccf8..70c4e43f2d9a 100644
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
@@ -868,12 +868,12 @@ static inline bool folio_test_large(const struct folio *folio)
 static __always_inline void set_compound_head(struct page *tail,
 		const struct page *head, unsigned int order)
 {
-	WRITE_ONCE(tail->compound_head, (unsigned long)head + 1);
+	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
 }
 
 static __always_inline void clear_compound_head(struct page *page)
 {
-	WRITE_ONCE(page->compound_head, 0);
+	WRITE_ONCE(page->compound_info, 0);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/include/linux/types.h b/include/linux/types.h
index 7e71d260763c..608050dbca6a 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -239,7 +239,7 @@ struct ustat {
  *
  * This guarantee is important for few reasons:
  *  - future call_rcu_lazy() will make use of lower bits in the pointer;
- *  - the structure shares storage space in struct page with @compound_head,
+ *  - the structure shares storage space in struct page with @compound_info,
  *    which encode PageTail() in bit 0. The guarantee is needed to avoid
  *    false-positive PageTail().
  */
diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 8d82913223a1..94e4ef75b1b2 100644
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
index aa657e4a99e8..e83f67fbbf07 100644
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
index 71c7261bf822..62dfa50c1f01 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -94,7 +94,7 @@ struct slab {
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


