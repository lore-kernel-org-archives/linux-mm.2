Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA191FD7F93
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17F196B00A4; Fri, 27 Feb 2026 14:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1572B6B00A7; Fri, 27 Feb 2026 14:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1DC36B00A4; Fri, 27 Feb 2026 14:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCDBC6B00A4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3714B1A0938
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:40 +0000 (UTC)
X-FDA: 84491228640.03.B1659A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42D10A0011
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sMA4m4oE;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=My64QiK+QR7LlZZWuthvPr0q2BZYC6h9PL9sbKVxwxA=;
	b=65e7K0TV2QAD56lISOC7UNU6/AQaya8/wBYmuBHGapm4G23/s1bz0phgP9C0RV7FMsqrIP
	tON4kWnkQ1V7utM2n+PeAuiZGB2OkZysj+TxIN/epRhN306OMbcSZltGalyQBvky4ZkWQN
	acQieQxv6hDPiOuwGA+XUIyp0c1Bnk4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sMA4m4oE;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220638; a=rsa-sha256;
	cv=none;
	b=BMthvZ85wfZYPFT2h1WWEfTwb3qs5SrR8P95MXDUSfc/KjYjTxTTakXX7+5/oo878/EbjD
	YW1d8X5oIBVZt6tnDSTpWIzv7Prdhxa9BwplvHo01PhsDN2cBS5+uSSKRtG+tPty76rfnq
	dM2xOVDimfKVWvnU/mWgX91HVozkp4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3F6860142;
	Fri, 27 Feb 2026 19:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28D1C4AF0B;
	Fri, 27 Feb 2026 19:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220637;
	bh=NuLprIvDmoFUiUq0+5noADBwgzQFyl8O/ZHxlfou6Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMA4m4oEQaTD5//pGhH1LtqLJ6RH/qS0w3h4wVxw4jrRrw4wCuG1f8rHupCaateqv
	 lsWxaNia/ULl/6iAFw+n1CHyRyeqZCkU5GUWdjdL5ZW6yPLqs1wzplXxn5DLDiNxOD
	 V8uKdhB8gzSyc45dYApnVD8yQW+IEEwvmkaOl8Vb2d6A5KrYZSKw9It8QoNGwMmUaA
	 HsanVMpKZcKIRgrqppXIef8X8TfR9zMPNmZY6+9FqrR9ZuTXIdDfsYiRcXM24SLSer
	 3t0MnU74cxRiwKMUZmIEMSiQeSXiCEvMiUI+V9FCDQrNGQ8BNuNjtPZ80ywChM7M/V
	 0qYVSTVh4T7lw==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 13503F40068;
	Fri, 27 Feb 2026 14:30:36 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 27 Feb 2026 14:30:36 -0500
X-ME-Sender: <xms:3PChaQ_n0wRDZ7O9XGG6LGY310RYnP-WMBPOam5qMKmMPabfwoDBBA>
    <xme:3PChaY27rOG75cbxwuOAt_iL2kR7C5bB3W4aoO1AbM1SpiuEMMJ9Dpamg_q6AAL0k
    le1_Ju1m4e-baRsaNcMkMaGf5eK_J9NV_92lCbBHvk-z3gfeigFXwQ>
X-ME-Received: <xmr:3PChaT3n3m1zQHHos3K9d4OVuA6LwHCL2sKtyIMDKft1ieH1QpBGynyJ1ZUe8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:3PChaUuC2rEQaE700z3q_Kdf3-EXaYL4Xfctm5zyrEjVoVK4XlDKnQ>
    <xmx:3PChaTaKVowfephzR5AlpVxDbiRBbFm9koKhGaMMs5IY20GKEFtA5w>
    <xmx:3PChaaJQU24bucC9BpZ81DsZmmehpz_PQtZXYfyFJg2llhoKGm5IPg>
    <xmx:3PChaUgHtYgvAeft8GSRmaZglEXBZUiExO0esBjIH2S7juueeeppKw>
    <xmx:3PChaT_LkflwfUYt3S1w9NY_lZYSwsku9ZP0DwEsVD1OWqZKdJWdHEjw>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:35 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (arm)" <david@kernel.org>
Subject: [PATCHv7 03/18] mm: Rename the 'compound_head' field in the 'struct page' to 'compound_info'
Date: Fri, 27 Feb 2026 19:30:04 +0000
Message-ID: <20260227193030.272078-3-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 42D10A0011
X-Rspamd-Server: rspam07
X-Stat-Signature: y6n5ik3wi647q39khxuwpnk8a78hjkeb
X-Rspam-User: 
X-HE-Tag: 1772220638-957215
X-HE-Meta: U2FsdGVkX1/avOGK+MDoZ4j5gG/WcnNTMiBZbX7eW1ZaHJzrlin1yT40bJ6C1LLDW2VD0uPrgK3OhINuJtCjSXM8FAEBdWupUlDvWmc1nqijO+iOVeKvvX/CtMAFqKX5Lk/P+y9lSWvIwHh9v9gzJZyjICyi9ul56nEMJTuAMEFFwszhYZyWV8L2beaR9Xzsx8wEGQhOc1xhoEPM9hXRQaXSEl78NRsN5/d3JFoZklAfEs74E8W7jHbq2QxQHS0uwA4Cj16g8xVVnDE0GaZx6OugKhYSAlV7UY0TsfvrI8pFtJZ/XkQ6pds/eHNOQgU6WKWGhXm48+WkYXfJb+586ePgKgpx6v5OFPKZ4mcwWPAMnzrYdtoTlKdnuCV3Y6KjPiHnJ30sz6yTivPBQ1IDbiNhHuheMbXaIDsUVhmPudx+LXKBbruQr5egrj9Fh+othm6PR/7ow4zqqAste1Csg+INlMeOuf1FTvBOCIIeomYr7DMC1PK6n9luvq++Fm9mwQVVV+lxm3+EEPaUyjdH7hLMs+edE0q+oPcll83YdKvYfnqycrl1oAJmQBzd5dlbJzgecxP6esnMLckUrgJ8vummwSeCuYEpm+vx89pBtrfx/3UJcHFpl4zNJu/8W6S0SCUTaNIoHZ6y8lR24SjAi7tzGs60TAjimCYqnnCT7h5o7dWqzcxL5nMU3SEvMhKWydGI80V8RS+KsUe1ejugBPrOFlzcGQvm3X02S2+xEg84BMgK2tpOCSu4xOeMm85hYQS0balcqr+JI5W0R8zMtDFElqLa0D7heLTJsJTFmJpqtUgiGCe1vD+j2wu33DZx/eIvGk++CBCASwcVSuZWC2ASGwRo2+l8JROW8ljg/nWYvc4fl8uzxXcEuy4j0Z+Ts+WjsabQUnt4dvLGOaJ+M2Zqnww5AluRWNX9uQQ7xgFKqqWGnGlL4RlrHy5ynCQe+K9K76owXqf8Bab2wkX
 OasUt8d4
 SecvXM5YqjkiMHfTQSYf/PrgUTj/1HF6Oyd4dY/tBnOwSXbrO3cH4+W+sKApF5iBvwfzSIAWPjNxI4aqamaPpz7fOTDD38JYIs3nbaFu+lm9qwxWH1uCEiqMD1vuI7R2CLtcj1+FPBU2HtidTXhFwImAgboq7+ELF6xpnmut642J4EuoCPIFDaozqXkGyOvFmrgTJ0XixdH2dAWNdCCpi+4hxCjB4SGRvQzT/V57bVsRgr+rGagGTVDB2CxkFBTPo9VGBnoUdY5kRVN4v14wEabDL3OYhpiq1HR75VaL6xMuCTUc9hj19Tr57wPT5+z3ADeccZr0DKdC8oh0=
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


