Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F26FEFB7C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD486B00A9; Fri, 27 Feb 2026 14:30:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85FD6B00AB; Fri, 27 Feb 2026 14:30:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B709A6B00AC; Fri, 27 Feb 2026 14:30:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 999E86B00A9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EFD313BD41
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:47 +0000 (UTC)
X-FDA: 84491228934.01.0D27D81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4DD8C18000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TckYyla5;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTwyNaPDLJCyC2RCm3Rtg30ru9t4znqiJ0NQjLPs3Pw=;
	b=rRirwz/cqGo98blDxlxVSDd/pnoQsm/7rwvAlEq+WZfj74XzjorRp3bKJgTkaHChdZ3nKo
	kBJMWIzI66c5FswwAcCO8Z8CKC9xcIUZa6tROUvsRbAwfFbGplqhX2Cbw0JWYkS+KhOd5f
	tESConl3KAYPLDt4uymBuFo9ybgFSSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220645; a=rsa-sha256;
	cv=none;
	b=617DuB88iFZl2ng3neDKfCotLEzT8SqTLVexg6CTZfWM6epn5i1fwcHab7KH/1bRaIVpe8
	xA4TwXZnWUMgU0jFL+RL421xTgE9j8bSaUJG65Hcmq/J2pPVVtrZsD60/kgtev8eCF+ZfG
	XKQfCTlBqX1TUirWvKl4sy1/Mfz9tz0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TckYyla5;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A04F66111B;
	Fri, 27 Feb 2026 19:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCE4C4AF09;
	Fri, 27 Feb 2026 19:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220644;
	bh=op4sRtUfkPTkGQoMOy4067b1J6icXmPW9c6oduSGytg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TckYyla5DkRWIJKiPr7QQBOdMImKKfUke1x+EbNv9iw5f3k/G559d+V2RvJBVU9zA
	 cyrZnOjGvjzG0nRVkUlQGS5p248hr+jipD6NiORojLBJgMXoaSENt5qS1kMaMdiXvk
	 h77Pm6FAxkkdLGwk2JBOrgBP92UMTLualaigFY5K3jmPhCzrs/879AAsg27n3Cdq2y
	 3R1TNo+MJipeaDsVY6YyvqOBr/0/ta+HolgyiJpGOMvli7MXpaM/KJeTUS9vZBbmxy
	 HassELbh8OvzhDL+5iFBnPnVi37kBCcIJbRlQUy5CC9rMeaLgABly/IKteVjuvzs+6
	 XUUDGmivFBiyw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id C53CDF40068;
	Fri, 27 Feb 2026 14:30:42 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 27 Feb 2026 14:30:42 -0500
X-ME-Sender: <xms:4vChac6asAddTX1Lud8kzc4j5RcCi6ZNT1Km-6B4KgiOtq40BFkS_w>
    <xme:4vChaepbBUZwS4HIKkYnvsFCAELkVIIsV3-ppSA4JsKTjvsavVIaqgQ4AqNxlhDjK
    ROFWrtTgXnmaEZBjhtt4ztvzB4FgiSAdt2SMgaUniCA0UxMit8k63ec>
X-ME-Received: <xmr:4vChafSdidxFmEQjYFSvI5zdpTiNjXVIaVz7HKxLt7kVJ7hcYSmiPzQcSyZ0xQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
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
X-ME-Proxy: <xmx:4vChaSsnixln_HzCGnf-FWE5RSOwtgg5xUErKPAIn0Vde93XiNxQgg>
    <xmx:4vChafNCmvquFSUFjjKwPzbCnY8Okjgzdn8lfrfWE4_pr235AvKSYw>
    <xmx:4vChacX5SqEmNYQuXSpYEzvUpyFqnVInHRGMR0tnYeV0gdN6DDW-Sg>
    <xmx:4vChaXhYghqHjUJrTILFxjA65XX_1WAc65TrPfwGz3tD0zq76wmD3g>
    <xmx:4vChaW0mXI_b_P0NlomTYe_Ss57MdiOhD5_gH9t1XlCZwI3hGOt57j3H>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:42 -0500 (EST)
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
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCHv7 07/18] mm: Rework compound_head() for power-of-2 sizeof(struct page)
Date: Fri, 27 Feb 2026 19:30:08 +0000
Message-ID: <20260227193030.272078-7-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4DD8C18000D
X-Stat-Signature: b3xayztyzee8rg4m5n83jifk7p6a5znt
X-HE-Tag: 1772220645-455731
X-HE-Meta: U2FsdGVkX18illeDeMZdbZ+Uqmx/zTNylpWiTj4413lPqKpikquQ3Yv8chzPdfMrFxzGfHjs+rGQVEHZ9bsENeV1oZ1X39P5ezBtYZd/oU/eVBoCtNvbxIQfXIUQ7itxVNZoJBgbxTt42ov+PneIjTjfCJfxR0/NcbyLJLGlVou7vuNI09iFpxH4ha5bujbO9fDkU/1yhr3tZq2ovYqIQ2WXdb4Fq1A4mW0KRRx7qkL7ozEJ6cnkxj6Asv6HTm3V6wsPXlcwbiy2D/UhpME0EUDmHWBTw4wcTUwKB/WXx8FrroGssQsB01amk5K/sFKnyugXgmApBrNku0N7vdnbs5wSbsG8j3f7YNt4njSV6im4xrpSR7JQIjbBuM6A2re+a5agXmfmbx587dFEa3pdj9ykRq+WmAifJgo+M4HPef3cY5G0aTTUxsBz6ZO9iCEjJbvCt22CIcYM4lq9QEExfaCFWH1LeKC5+reWK3YNs1bwvL0Gft/ud7AmCSnR8bVq0osoBKYdk7wVlMWme1mKMqqhkKtSe8y6Gv0Wufsg3ZSwkrRulRsuzxX+LS+6GVydjIXjaD4U6ZNIxibVVG4hZCAfiGiN8QYWMUQR4+Z8uINJplBZBx2OxlrfLSCnunID8NXwQvhheJW/0LyyKytIe1z/Ins3I8KbXe5Zwz2OoF2FevoE5IKOtjRCa+c3KTPNX7xrXCKTZq7M1XXRa+MAvDNY2FiJ8FJplwblsw6L/dRtDTs/Y8Pp94c5e0ASB3IbFwdPavv04je9RrvwtktyJJE+JvLo3+uAakNWOz7HnYTsW9iC+nlmDSYE81vJ7392W+avja0iuis0LSp5pKQu+yatjjREzCWss0UEogwc428cs5kwj23fBhewATcKlhulDK/saXKnQrFm9dquWDAxQiSTBNRQFV+DIFn5wNJk5q4wdSaebyss24gSRu+vEzw8AxJoWDgYNhrFN+duWll
 9Zs+twUz
 49tbplKxdqIsQ5TDVtAYURz/rWmCPgQ8VSOKZoeTDAJyPUki3AE3FoRIS9yOSHJzxdn5ArloajhSNtMn9Dvxbo4LG4cqwr7JGfAZvCU1rk8r+ASjcgZbqZXHHzLxDsdiqtsVBtSxK3EJnGDBs14nPo/qU4xA3iye2gVfrjzGQ9MY24VnbctMz5gAYDjlqxWo7YlLp9hsWaWysUG4Lg9Jr8L2FGM5XWrXkVJ3ePge1r6JekP0jj/WNSe4qB+Kc/4VamDtUzMovV/QQcBmN7wPj7304FP87inBmn0XlAoOdqYRidN8A6SEd9lf6ftmvqyWpVGIXq0eZjX2gEBi0pEeOvkaKn4xhbmg1nHkD
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


