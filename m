Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C63CC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E176B0095; Wed, 21 Jan 2026 11:23:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912B16B0096; Wed, 21 Jan 2026 11:23:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDBC6B0098; Wed, 21 Jan 2026 11:23:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 572326B0095
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A064A8C481
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:10 +0000 (UTC)
X-FDA: 84356490540.03.DAFF2D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 82B1C14000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLMZN8bx;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFI+FAtH7OX1GjvszbrTDeUvvA7yGZf/Qi/WIwfYtYo=;
	b=aB4DaWxw74GvjTe4HQDlJXZ4/0qYAuYTUCWz+rVk7fj4gI/AmVZMauiml0GrNT6O3NN4Tg
	0VXIUJ9keYPcbiRTJFGv+hdBlHFj19f6V6p29LdizVA0SxDsdfPnJecBEwmAgcMtZN9q4V
	Kw2KfkEgy0OIYoKrYAGkomUCwE96sv8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLMZN8bx;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012588; a=rsa-sha256;
	cv=none;
	b=5aXFbCmyUTVwpMTJvR24aIZLVZxh7xI5z83MA6wRGc/OvSGRn9gFidrv6yRnWMB7c4lBPL
	+SXbmIKY+ayJXIV2HZz/tw/5vJlBerhxtRStbtR6lEOLnC3CBpcoUWjuNbMP1sR24EtL2o
	nh7aTLgwlGK91tYzuhoZm+LYfLYrRZg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9052044352;
	Wed, 21 Jan 2026 16:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058D6C4CEF1;
	Wed, 21 Jan 2026 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012587;
	bh=jueaS1qYz8lwqJ6jPeGHTAmiWIc9uM56rJANRez3R/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLMZN8bxH2Udd40MxjPH1NFLQAkzv4wR98Ds4WOBgiGYvOtJj2AetQA9fD1dWVUY7
	 37AAnnjpJNsPrTBZ80Yi85t1Fp1KpL8U3+siq6sxk/oEZcJxD+2U2VeG/DIkBms/0d
	 WkioLmF+peQKNuyDs9NIgCXGfk/I3hRTJ3Yw3WviYsuCzYEtWgMx2sUiEUjruXfpgr
	 laVyjknwUV5LJrzVcCJcfrUGh93UVxElqG+cy/l8vsMpbYf5bpuUmAhpEtv3zFuFVp
	 ZuHroXNuE9gaQ8ND/JczgER4bBmYsdlxa5JyXUh79KQjqE5QA6Lhx9gy4u7EYSn+lu
	 W0LXIOe7xLbAA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 35839F4006C;
	Wed, 21 Jan 2026 11:23:06 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 21 Jan 2026 11:23:06 -0500
X-ME-Sender: <xms:av1waYaz4zFSYizTd6aBKiknUPJTShmK93jihVstO0YoN9SXpknf1g>
    <xme:av1waSoMfKkwipaSorRVP_x_XFu8fvdCPgVttM3g1Ety4UL6LIWcWSML1mGWVK6ZI
    XTJ3cBvo-82KLoVlOLuHtL6FqaLjLISrWMPFqqgZqrnGNubKRsqSDE>
X-ME-Received: <xmr:av1waVze1VlIGhJbcpLHVZoEDRuyuTt0H0zhnYnm16q8g01Fn7edpWGTUBvdSw>
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
X-ME-Proxy: <xmx:av1waaIseKeNx-WhenFN4MgWtK6e-5MDRiDS8faPibTHuLr50a7ZRQ>
    <xmx:av1waX7V6Bq8B9Tuu77yB7cIj7ar0Td6TqFMmtGVTJH7vDPWPquqGQ>
    <xmx:av1waYxpHZVy-28kND70REPanzbJ8tS-V4zwrDxIJQznk1_wfjH-JA>
    <xmx:av1waZ-ffah9k58iThyfFLiMiXZy4YpVE7sD6YWv7_BfNv4OzB_DrA>
    <xmx:av1wacG67Pb49bjNPFRF_AfpmfW7FGBXZYE0y9ON691ERa062XGAkeS3>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:05 -0500 (EST)
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
Subject: [PATCHv4 05/14] mm: Rework compound_head() for power-of-2 sizeof(struct page)
Date: Wed, 21 Jan 2026 16:22:42 +0000
Message-ID: <20260121162253.2216580-6-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 82B1C14000C
X-Stat-Signature: w7msba9emfgsxyznipbki19k6a4nfy8r
X-Rspamd-Server: rspam01
X-HE-Tag: 1769012588-784010
X-HE-Meta: U2FsdGVkX1+r9YEBY8I3FxBGctqS/z7Xp8JV6tDBgpazdmXu2/YdkObtScwk3YuJbMmuogMWgVT4j64wWhE8wGOf+lhAtq+zPo1ZFtCyDTo8y5a1TIIXM21dydKEyE2j7m2BXXKDfISSyrWgUNg/U9uWcl+TqBcHSKAyycQUvgwWO0tE+YdbvHg4RteyvVQtSR4D6gDUNVJ/AbdzuVjegMT5pSjDXUB3/X8oWlvX2mgoTeGdLVS5ObPEE+2sMuHRj5jZGxnmqYxh3jPAbhIjOcqRn3Ta/6w0veikh6RsqC2tNf1bYPAO4HoZF3rZfLIY7I2SJp+ZvhJUaEmbyp0ycSM7Bd/hAGC/N/iUlKUblb3C5d9Ehir1Er0zmClnuvbgeYSL9cyapeW8j6n86AtQRJDwJ9/t/7medwJ1Jw062JfQG+Bl5KX95UETb77uwoON2Otz1qDll+VI6KILTsHzd+JK7cwyq2/QmJeOHiSGWd/uyGh/if5eUl5OuhZVpOoHnmhpUbrgNS+e9MB7h6yAx0R3EhS7TBqxWs46tk70Otsi40XItXYkNE5BLFZgFHPPPWF8aUsV1MFfZbPxAJRB19CSvssN9Tw3cjzFqkqjkmA62jWhDEd1VKuxc8vSVj7x7xDLb6y+o8NUDqPlhUJ4ugpwU3Yp2SveyjaZJWM1NNfQQsmOtQ/DZHF08SKw+PkpbZ+fn4QtKk+pAbAZbtdx/dcxuRX0zU1Kn9+Xoa2KVUv7/iu6eovaf1mKuUiiR+1EWKF2VATRnwUzgfpauj0rNbWb14u18yZ4oli3olvEqgRzlA9ET74pWaaUDlWH36B5abtfiI97g5pHa6HkuyegUXaCkORfZoq0AmjRLIYdT4e50fZ3n1SCsiH7gCNKFZYzb80njLIyVLk9raI+Cusiif8PIRYSAq63GCJ8mzBwMEZ2N+a5fF6uLWOUAaQ05vXFT0kHtNAmwAwdXQ9CrIO
 DoTPimNH
 rDCEZi1zvPyrkmZUe3U3cxlhbPaW1f9sZgl8VpnNol2pfeQfukx3Z4QYpxNoMuWqvmRDIUtQuGtF3UZZmn5K8XvPMMrRTtK6SNxV+Wx57NFcWlFo76wyr9JZdg3J6GqMQp7BWEZX+Are+iLZk+gBJp8xQc6CGivg/fx+n5tEFpuP1j8YJTsUAz3nOssNYKJtdIQwKFEBZ9f6HrVUTGD/TiZU4RaWw6gjTddk3vUlyDdNQ6lUyhqJNrSmSMQhIsYRZXBuH/XT8+PP6kjVBIM9ViGpQsnP3oa5cAG+uhNhom5Dghjr5dIg8sYnLxg==
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

Limit mask usage to SPARSEMEM_VMEMMAP where it makes a difference
because HVO. The approach with mask would work for any memory model,
but it requires validating that struct pages are naturally aligned for
all orders up to the MAX_FOLIO order, which can be tricky.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/page-flags.h | 81 ++++++++++++++++++++++++++++++++++----
 mm/util.c                  | 16 ++++++--
 2 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0de7db7efb00..e16a4bc82856 100644
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
+	 * Limit mask usage to SPARSEMEM_VMEMMAP where it makes a difference
+	 * because of the HugeTLB vmemmap optimization (HVO).
+	 *
+	 * The approach with mask would work for any memory model, but it
+	 * requires validating that struct pages are naturally aligned for
+	 * all orders up to the MAX_FOLIO order, which can be tricky.
+	 */
+	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP))
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
diff --git a/mm/util.c b/mm/util.c
index cbf93cf3223a..f01a9655067f 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1234,7 +1234,7 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
  */
 void snapshot_page(struct page_snapshot *ps, const struct page *page)
 {
-	unsigned long head, nr_pages = 1;
+	unsigned long info, nr_pages = 1;
 	struct folio *foliop;
 	int loops = 5;
 
@@ -1244,8 +1244,8 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 again:
 	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
 	memcpy(&ps->page_snapshot, page, sizeof(*page));
-	head = ps->page_snapshot.compound_info;
-	if ((head & 1) == 0) {
+	info = ps->page_snapshot.compound_info;
+	if ((info & 1) == 0) {
 		ps->idx = 0;
 		foliop = (struct folio *)&ps->page_snapshot;
 		if (!folio_test_large(foliop)) {
@@ -1256,7 +1256,15 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
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


