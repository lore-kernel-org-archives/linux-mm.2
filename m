Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A58D25926
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB25B6B009F; Wed, 28 Jan 2026 08:56:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E877F6B00A1; Wed, 28 Jan 2026 08:56:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48376B00A2; Wed, 28 Jan 2026 08:56:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C2B086B009F
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:56:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84B3313ACF2
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:08 +0000 (UTC)
X-FDA: 84381521616.16.2E83C30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5F854A0006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aeTbquYU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608566; a=rsa-sha256;
	cv=none;
	b=DQaH4E1PbhX/G2ie0uB5rS1uWMTYcNGICmbJDisrnZKMtSmlfPZIsG82y8dXc47VK5yXld
	eYtgoDEoCbB5w2a9kbUvIvm6564QdNxbgQdJwSllV2XtBzUFyL7btg/nh4BYXMpxWd8mDS
	ZXQvpmkY2dWvNC2nwh/xhTYhW1lyW6Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aeTbquYU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpFgSVsQtP6mOaIf7miK4dNUKGVZvKXE8jtoUXKaOJM=;
	b=c5N+qlScjC6XYrDhexl24+AB6ss+ACZer+HUKazUBZ5edHZqWqVwimRTtPreYnDbuPvVOd
	E/TxeV5rni72b6pAjXCAibkq2eSyZwXwmkGwS8BW6/BbYfeNjmzDPswzxv8s4uTJbRxXW5
	ny2YD0XDVQqXPDEEWbgh3YMp/VB0V2A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8899944331;
	Wed, 28 Jan 2026 13:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D37C4AF09;
	Wed, 28 Jan 2026 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608565;
	bh=tEvq02HqTGhVbwvuqPMQOCqNdmF5urkjY+a3mR1Nbe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeTbquYUpbBvXgcn+nCLRd30N7kj0HLzpvLxDW5A9YB06CXqxDquhlGU/DUwBnCJ4
	 9BqYsssvsTQ1X/JVYtwpoAzofFrTCz5DwalTfDvtZs0zxsxT1PtF7J1opmJPuAZr0M
	 P7laqQA4a++A18xQFluFhXX88iUR5oCf8gY7inOMsZRXUCfT03PXpTWPVoHFmayesC
	 B9seaV9C1YfjsS+bEuVrnnOm7WFmrwzm4Oiz1z1YfLc2LQ4lj7f1szS1sTCgWqCUu+
	 MaFeOtb81DCtEObzJjhskbv7P7qdAaQRCK+adXNSe6C8qxcMRpHn41p3zcb9cueiRh
	 tNYMQzNwRf3mQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id DFA50F4006D;
	Wed, 28 Jan 2026 08:56:03 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 28 Jan 2026 08:56:03 -0500
X-ME-Sender: <xms:cxV6aX5A2Q5KqCBdij7zGGch7b0WV1m22Hre5ZwiKy2KC_4V4rPZ0A>
    <xme:cxV6aWGzSorVpMBFg8Dul3UA4KD71FNhKW64cguH7cFmT_Tn377MjjwTTvbFssX1E
    LBxUtLd8Wt8lefbzebhL_sVURnTdmB7DpvsLjXVsznyDKKr5sCDIGM>
X-ME-Received: <xmr:cxV6aYlnEXhBtGQPepkVeL1fXzxQmqlml3LFlPaf71ubQUTw8EJu5lhSJywU-w>
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
X-ME-Proxy: <xmx:cxV6aZB-3T8aSs_haJIQ_EaFhVRqKnYLzsBU7tStkI4IjHTBEVXOCg>
    <xmx:cxV6aXEtf6KiLwA8ZIhWeXLU9fkKDAs_NK6dUx3k3AOJDEDUNcCZ9Q>
    <xmx:cxV6ad9icdE7sKSBfQe1YP4Tv-39pyRSXHblLpD-wDS4AbO1pnN4jg>
    <xmx:cxV6acnaFMD-wsA2-W1-932dIfJw5oT6foIpHRgVUaplfByDNCwtSQ>
    <xmx:cxV6ab-dxfJD8dZaOGC7ut3jO_STcHoUQOdb1r432HaIWEtXAQdGa6_s>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:56:02 -0500 (EST)
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
Subject: [PATCHv5 07/17] mm: Rework compound_head() for power-of-2 sizeof(struct page)
Date: Wed, 28 Jan 2026 13:54:48 +0000
Message-ID: <20260128135500.22121-8-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5F854A0006
X-Stat-Signature: fb7azjhhhth76suqhy1sq9r3tq4yk88r
X-HE-Tag: 1769608566-377487
X-HE-Meta: U2FsdGVkX1+ZAU6xwlQG8NUNfNWiIquc6Ajo/5KLuYX8MCYnm5KT5PZ90T02fnC1tDymi4u9dYw6UwMhc3PqDmREfzbRy40aN2scj2vspRrqzF9mnQhIV70x+ya+FS4p/QwRLHu6W+IKZq/3Ts8r72jiu4ew0EmzWi7zY9FzUGd0E5FwtyNDX3IhIDR6+7YNuKGzXCjUC9xvfOC2PnKfdhN41XsnBFsskG48EVedO70B21cUF21IQ+cqaGAxB7jfRkFYU2Ca7X+G0VCicZeYS9SYUm0AfitAHl5EIyOmPZZJVeOztDo5RabS3Jdu2w0fxFUpx+H9LzPlazBBFVLtLP+H3dBpX1/8dEnV32Bf6OeLiAOYHCjcjfeXRDP2tgG0a8oIIT53mdeJn32/sS0PlIi1dCPMDmH32cOMIVaTB2BTRNjKzIe8lwBcWXrUeD3AOe+g0lwf5Ka9yEBSM4XnjTilIj/klJ9LAUcnUSVDetPYJxaqt9/vvHYmcgNBLCeAaSW71De0yKJCy9FOKLES7lSK9EzeK5uQZ/KdZsVlE+7daBqn2B/ZIeLmH86UCk9djX6vIsBgfpJGrDKj3xTZEF8ds0oepXggcWB0wKcVKvYMQ8EVcrTzmPfbtmPrRifo82UGxY1fGbFBcNman+RWABEDHu9Nd/HsRMNoKpU/+llrhDvqyhRfvkn7Ke1uZXqrk6oigW9TvwlW5bwk/rAZZoKEF/SirEchM/U/k/e6qlhbBnMuwy4h5AZQwqc/P7u0ixkwCZAmv4ROmLsD7hlZ9E4HA5jU40QGbCpIIYXOnb++5fmiGH9XcFc2yf/BwMjf1hYMijeaS/+RBM9sX8puDUmxxutTyNC+S+DzPuwFfahQPmHwuV/OAnzvsN7IxCEkOcaDlUXdBMQDY8ph7esVg8W1R8bN2VQgpo+wSux0ALvP7by5pMftZTvaw9paI6Zw7kN7QrVx5EeXE5QgMCL
 X9CB/CYW
 2OVfpvg4sgl6pQci7HbDUTwwcblxE2QftHPJad3gjL0C3qykU2QURKE3+KNSNLxcvEMbORwWJnRMjCoeHRNWd0eoIE1oqwRfrmZJtKubVIWiE5XFeaNS+L8mki1ZDnS4r6DW+GAOxJSN6lfqkk+z9CoJmjqoSmyb3qoBO1gLSfInJZ972zV48JMgUihix8QdWEJdCOqFNSpbnlZ1WjmhgbOFfivavBBtFszRzN9iQ+EgblbiHAsQIXHR62Iau7taXsZ8y0q1c8GOxyRRl71iH/1hveRq79ZQkt6uKIdlKZUP0CfIH6ZMB/R3tz+Qn3aSLNf4opt20sl+z98U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 include/linux/page-flags.h | 81 ++++++++++++++++++++++++++++++++++----
 mm/slab.h                  | 16 ++++++--
 mm/util.c                  | 16 ++++++--
 3 files changed, 97 insertions(+), 16 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index d14a17ffb55b..8f2c7fbc739b 100644
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
 
@@ -210,6 +233,10 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
 	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
 		return page;
 
+	/* Fake heads only exists if compound_info_has_mask() is true */
+	if (!compound_info_has_mask())
+		return page;
+
 	/*
 	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
 	 * struct page. The alignment check aims to avoid access the fields (
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
+	 * If compoun_info_has_mask() is true the rest of the info encodes
+	 * the mask that converts the address of the tail page to the head page.
+	 *
+	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 */
+	return (unsigned long)page & info;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
@@ -294,7 +340,26 @@ static __always_inline void set_compound_head(struct page *page,
 					      const struct page *head,
 					      unsigned int order)
 {
-	WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
+	unsigned int shift;
+	unsigned long mask;
+
+	if (!compound_info_has_mask()) {
+		WRITE_ONCE(page->compound_info, (unsigned long)head | 1);
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
+	WRITE_ONCE(page->compound_info, mask | 1);
 }
 
 static __always_inline void clear_compound_head(struct page *page)
diff --git a/mm/slab.h b/mm/slab.h
index 8a2a9c6c697b..f68c3ac8126f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -137,11 +137,19 @@ static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(struct freelist
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


