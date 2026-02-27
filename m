Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9299FD8FFD
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532686B00CB; Fri, 27 Feb 2026 14:43:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482A16B00CD; Fri, 27 Feb 2026 14:43:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327E16B00CE; Fri, 27 Feb 2026 14:43:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D64F6B00CB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9CBCBBBCC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:25 +0000 (UTC)
X-FDA: 84491260770.20.715FEC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B959EA000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N99mJ1+F;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTwyNaPDLJCyC2RCm3Rtg30ru9t4znqiJ0NQjLPs3Pw=;
	b=trg0i26AhlYS18JcFd6VYmquZJ/QudStkEfKokD2+wSQ99cBf7LcqimlTQYHVhxD/bjb9k
	hWzhR96TIrjyDKY4M9i7EfoxFOJnB2Xy29yKQg84MmRrDJxwMe+VDQluOiyilKNd2q4IgT
	/9Csq/wYLZIyjzrjib5yMfTfSQltl7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221403; a=rsa-sha256;
	cv=none;
	b=zn87etOoIPxMnoVSuZSGdqZQUb3YVZ9lBVfUf6x8ohOBZZ+hjSOUpDaULCXDJEmi5OsZ6u
	UITkGmNP+IXlqFzehuk/5eoZNvdH0wD9jqwyAgCoptGiz6mUGqhs4Ppf+PgHQkZE3V1frz
	J+Y13WfwLQnY9shnFA8ozPwb18Z5+Gg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N99mJ1+F;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7736442EA;
	Fri, 27 Feb 2026 19:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22724C116C6;
	Fri, 27 Feb 2026 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221402;
	bh=op4sRtUfkPTkGQoMOy4067b1J6icXmPW9c6oduSGytg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N99mJ1+FQjLCzjOGVupWJ032vDuW6bUL8Mx2bS8Qktq+luTJesvmE8D+X7nmIJw2M
	 1a4lQXQ03nKInMT+ELEpVjqZngjmopA+z9uF0H2f5ZHy8EaKQLfiIN0BI2d/ZFpwKE
	 oa/y3Zfu3hIYTJ0Gce/hCTlX5PjydK3cvEacHzViZnLWf93l3ZEvPoPuQi+RLkJ2n+
	 xZibO7M0K23+mjRq4UTmNlqlpT9RZFDtp5G7gz6t1LJmPATbaCDq0hjhjpATHG01rh
	 3ZjTAXmE3QdNRWt36w70Oip7kHQYq8Eot2ezJYOVQxsAQPpzhQ6N1D7DpWG55qerL/
	 SdaVmAmBzoGxw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4D197F40069;
	Fri, 27 Feb 2026 14:43:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 14:43:21 -0500
X-ME-Sender: <xms:2fOhaeqKGRRIH1VXLgXVQbWQ_LaRkFfx1qDTw9rlutLp3ibgbvWiUw>
    <xme:2fOhaV1rF82URTV0TkbeynvbfrljHayoNzbQdE_GeWx3B7QZkJWbXk0F1hWv_lWk4
    R4YNwRddrNWr5ZwQAva_PNSDzgdPVRQ27zRDX2DPWVTkN8n0X59dwgF>
X-ME-Received: <xmr:2fOhadUl2Ppw8-2ChPPLJTFxOAa_XjCuZtul2FVkqrvG12E1yz3YpZYCD7k2DA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
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
X-ME-Proxy: <xmx:2fOhaezMhNPYRIIh7I6pIsAkAEf9fYdengLDKyp7Ow88YAPwDRLe1A>
    <xmx:2fOhaZ0y8tXkLPTnSPCbCrhWiATS9kXu0bVNT5QgaWBgpXkdLXH_dA>
    <xmx:2fOhaZseoPzwjQWmYWTDSR5I9s6y6CQWvhhF8NNRsbGtXfuyskm4Zg>
    <xmx:2fOhadWx9TiqSlashH7DNrmLvnpQLFieA6A5ngkfXtq2TIyIy7DVTw>
    <xmx:2fOhadv1xRIvKyWR4OHHNwCHYg8OkDazisF5wv3m4XfBU2aJCCUMcD_O>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:20 -0500 (EST)
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
Subject: [PATCHv7 07/18] mm: Rework compound_head() for power-of-2 sizeof(struct page)
Date: Fri, 27 Feb 2026 19:42:45 +0000
Message-ID: <20260227194302.274384-8-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b3xayztyzee8rg4m5n83jifk7p6a5znt
X-Rspam-User: 
X-Rspamd-Queue-Id: B959EA000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1772221403-63972
X-HE-Meta: U2FsdGVkX1+a40lgLAOgst2PxMk9bumwuOwdCsn/ngtNWTFXYwzUd3oqJUx7bgaq5/WavAhIZlEfTqxmxT0xW9tnEz0NCHumuqAuHF8HgAEtNu6M/JZqtvNP0iVnvY5FanrtMrLzMJcUZdHk8PvIpGAxYj2ykX/wZBGzcLX0Bnt2zy4aStA9VS/elmlLeOYgP96xayCTbFJZXGuYtTIUiIY09ogvkW5bZ5rBF/sxO1BlEhJyGzp73f7j+XDc56Eops2ZMdNKlJLlcpanhQNqxuV5XeWRMeEZzBLGXQZcRv+4hBptKPNDNM1/kHgpiXiYHb3MFX/tWonOfmvGfTC2cJPZf+AKXPqQZbeMyeIfhFi0uqtq5Vmxlr2IvjvuMiSphEn1RaKuzgL4vD7yAjddLQdsRlL6Cpxv2Ep6LAW+65sSc7ttiW/0+JS9t1J4XWYj4tAt4m9zFP22x1VpGY2H5TnGBC0l7hvafi2xu/76+/xe4Wo/slrZhKZgjRDp2r4zkNbBsCN++dCuuD+T9rpkNBy9+hZYgeMVbV8DyA6bOZ2kiO4UXI3PNKVZFShIP1HU2tGo2kVo+rsNii0rGiv3A/paWEv64JXcS5jFdqUS61n6YKHq+FOu2Uf5VP8P6b+pm2agJg/r2bIpvDvR1yxMC4aFAgEGPUw5bCE2VMRfavh9IbH5XQ6gxTxx4H9+G+i2Bh5hKTzGebhC4oC7G0//wbfzCF20+hat99cSjADOkyVGsDWiC2MY/cPfXATkdS56KwofdErFT+dLZAw4zJa1N2KvyJgNDgpA5hxO+MIb0EViVnzo5I2XupBMZ1Zvl2PZ2D79D5qXOlckGAga88dA0qbpSVqyxcJ9Ejc5Taef5OXGOXdtN3n1u8h0BRiwDt+bIN2D1fVC3tzGMfGNr4rcQ9lD6jQyyc4hI1c1ZlU2aiJRv5w88cZfFFBN+tbMpyKc8BhtjHAkxI7MLIzXCTP
 e+HWHzMq
 b93qiqIr9rZMc3ADUjcBe0v5L3mMad6Py9WxeLq8QdI39hwYzCmpnSdGyg9L6lx6JovQ0DWl7LcxqwHzddGgSLphdCIc0Hjinjs1HsxssZv2WMA/QKUNIAkzzZc2CWSqp7gnTGh9EOMK7NEUlpQ4V7RzHx77sIW/cEyWr+KXU/CmXul7MxcUdy/Q2NcyVChxSrNZ2uSNmrYdJsZlaVY1GfYC5y6dkJTVVu02bU8M0bZliA+WzNPbqWpRJPnDjVvWrh8lJ+7aMQ8xWVJVGge+jn4jEPIokil875k2+VxdGY5OorXu4QCJvoecs7dKhb9Q/xU43AMzZBimQ9mrxUJbfu4DlIae+sSf2PGQk/r2RGlw6SzA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

For tail pages, the kernel uses the 'compound_info' field to get to the
head page. The bit 0 of the field indicates whether the page is a
tail page, and if set, the remaining bits represent a pointer to the
head page.

For cases when size of struct page is power-of-2, change the encoding of
compound_info to store a mask that can be applied to the virtual address
of the tail page in order to access the head page. It is possible
because struct page of the head page is naturally aligned with regards
to order of the page.

The significant impact of this modification is that all tail pages of
the same order will now have identical 'compound_info', regardless of
the compound page they are associated with. This paves the way for
eliminating fake heads.

The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is only
applied when the sizeof(struct page) is power-of-2. Having identical
tail pages allows the same page to be mapped into the vmemmap of all
pages, maintaining memory savings without fake heads.

If sizeof(struct page) is not power-of-2, there is no functional
changes.

Limit mask usage to HugeTLB vmemmap optimization (HVO) where it makes
a difference. The approach with mask would work in the wider set of
conditions, but it requires validating that struct pages are naturally
aligned for all orders up to the MAX_FOLIO_ORDER, which can be tricky.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/page-flags.h | 81 ++++++++++++++++++++++++++++++++++----
 mm/slab.h                  | 16 ++++++--
 mm/util.c                  | 16 ++++++--
 3 files changed, 97 insertions(+), 16 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 42bf8ed02a29..01970bd38bff 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -198,6 +198,29 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
+/*
+ * For tail pages, if the size of struct page is power-of-2 ->compound_info
+ * encodes the mask that converts the address of the tail page address to
+ * the head page address.
+ *
+ * Otherwise, ->compound_info has direct pointer to head pages.
+ */
+static __always_inline bool compound_info_has_mask(void)
+{
+	/*
+	 * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it
+	 * makes a difference.
+	 *
+	 * The approach with mask would work in the wider set of conditions,
+	 * but it requires validating that struct pages are naturally aligned
+	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
+	 */
+	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+		return false;
+
+	return is_power_of_2(sizeof(struct page));
+}
+
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
 
@@ -207,6 +230,10 @@ DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
  */
 static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
 {
+	/* Fake heads only exists if compound_info_has_mask() is true */
+	if (!compound_info_has_mask())
+		return page;
+
 	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
 		return page;
 
@@ -223,10 +250,14 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
 		 * because the @page is a compound page composed with at least
 		 * two contiguous pages.
 		 */
-		unsigned long head = READ_ONCE(page[1].compound_info);
+		unsigned long info = READ_ONCE(page[1].compound_info);
 
-		if (likely(head & 1))
-			return (const struct page *)(head - 1);
+		/* See set_compound_head() */
+		if (likely(info & 1)) {
+			unsigned long p = (unsigned long)page;
+
+			return (const struct page *)(p & info);
+		}
 	}
 	return page;
 }
@@ -281,11 +312,26 @@ static __always_inline int page_is_fake_head(const struct page *page)
 
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
-	unsigned long head = READ_ONCE(page->compound_info);
+	unsigned long info = READ_ONCE(page->compound_info);
 
-	if (unlikely(head & 1))
-		return head - 1;
-	return (unsigned long)page_fixed_fake_head(page);
+	/* Bit 0 encodes PageTail() */
+	if (!(info & 1))
+		return (unsigned long)page_fixed_fake_head(page);
+
+	/*
+	 * If compound_info_has_mask() is false, the rest of compound_info is
+	 * the pointer to the head page.
+	 */
+	if (!compound_info_has_mask())
+		return info - 1;
+
+	/*
+	 * If compound_info_has_mask() is true the rest of the info encodes
+	 * the mask that converts the address of the tail page to the head page.
+	 *
+	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 */
+	return (unsigned long)page & info;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
@@ -293,7 +339,26 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 static __always_inline void set_compound_head(struct page *tail,
 		const struct page *head, unsigned int order)
 {
-	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
+	unsigned int shift;
+	unsigned long mask;
+
+	if (!compound_info_has_mask()) {
+		WRITE_ONCE(tail->compound_info, (unsigned long)head | 1);
+		return;
+	}
+
+	/*
+	 * If the size of struct page is power-of-2, bits [shift:0] of the
+	 * virtual address of compound head are zero.
+	 *
+	 * Calculate mask that can be applied to the virtual address of
+	 * the tail page to get address of the head page.
+	 */
+	shift = order + order_base_2(sizeof(struct page));
+	mask = GENMASK(BITS_PER_LONG - 1, shift);
+
+	/* Bit 0 encodes PageTail() */
+	WRITE_ONCE(tail->compound_info, mask | 1);
 }
 
 static __always_inline void clear_compound_head(struct page *page)
diff --git a/mm/slab.h b/mm/slab.h
index 62dfa50c1f01..1a1b3758df05 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -131,11 +131,19 @@ static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(struct freelist
  */
 static inline struct slab *page_slab(const struct page *page)
 {
-	unsigned long head;
+	unsigned long info;
+
+	info = READ_ONCE(page->compound_info);
+	if (info & 1) {
+		/* See compound_head() */
+		if (compound_info_has_mask()) {
+			unsigned long p = (unsigned long)page;
+			page = (struct page *)(p & info);
+		} else {
+			page = (struct page *)(info - 1);
+		}
+	}
 
-	head = READ_ONCE(page->compound_head);
-	if (head & 1)
-		page = (struct page *)(head - 1);
 	if (data_race(page->page_type >> 24) != PGTY_slab)
 		page = NULL;
 
diff --git a/mm/util.c b/mm/util.c
index 3ebcb9e6035c..20dccf2881d7 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1237,7 +1237,7 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
  */
 void snapshot_page(struct page_snapshot *ps, const struct page *page)
 {
-	unsigned long head, nr_pages = 1;
+	unsigned long info, nr_pages = 1;
 	struct folio *foliop;
 	int loops = 5;
 
@@ -1247,8 +1247,8 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 again:
 	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
 	memcpy(&ps->page_snapshot, page, sizeof(*page));
-	head = ps->page_snapshot.compound_info;
-	if ((head & 1) == 0) {
+	info = ps->page_snapshot.compound_info;
+	if (!(info & 1)) {
 		ps->idx = 0;
 		foliop = (struct folio *)&ps->page_snapshot;
 		if (!folio_test_large(foliop)) {
@@ -1259,7 +1259,15 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 		}
 		foliop = (struct folio *)page;
 	} else {
-		foliop = (struct folio *)(head - 1);
+		/* See compound_head() */
+		if (compound_info_has_mask()) {
+			unsigned long p = (unsigned long)page;
+
+			foliop = (struct folio *)(p & info);
+		} else {
+			foliop = (struct folio *)(info - 1);
+		}
+
 		ps->idx = folio_page_idx(foliop, page);
 	}
 
-- 
2.51.2


