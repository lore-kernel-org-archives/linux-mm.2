Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1BC1D6D230
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1056B0096; Thu, 18 Dec 2025 10:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF116B0098; Thu, 18 Dec 2025 10:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE0F6B0099; Thu, 18 Dec 2025 10:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 371686B0096
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE50B8886D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:09 +0000 (UTC)
X-FDA: 84232927338.08.FC3519B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id DCC0B120023
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DWdK5iaO;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCOa1dJf+GR47ntFrwB7eRd5Qbh9D828vKAYpNfloGs=;
	b=4PxyzVDYizGtcso0TFHSgyz6GJ7Pp+KdIGAbmvUm4/5MQ97eeRcFeVLbR8h5bgze8jocvM
	LcT0lLwAv3m+HgOo09dgmpi9sRgZGX9pqJqA+0PzhbZjZQ6sfjt2JJ7Lt7YX4ZjJ+7Gkkh
	+pH2vSeL5diTdkWjgi95etpvypmF0yA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DWdK5iaO;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070607; a=rsa-sha256;
	cv=none;
	b=Eofn5d+ANEvkdm0J7e8vn9hX1LzhI776ZWSCYPdB79tTCIO1LOoxS0/jF0d77nt9Da9m7p
	vwHGI9wwHATZ4MSJr0ufqOeUMvQMx5Yn+FuJLRsnrPpgLwh+lqC6GiRX9bQ6kMo6kSv30V
	eJFvpzfh69J2r3VWopF/DlihpYMtilU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 71A9A60134;
	Thu, 18 Dec 2025 15:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E36C116D0;
	Thu, 18 Dec 2025 15:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070607;
	bh=+7WRyw4knD3LetkMX1QgMbySbXtkvRUfDLhHaZjgz+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWdK5iaO+6SVbEI5IblDkxXfS2WGRCs8VBX93bO3Tofuy7WLWZBVRQu1mO++KQYFY
	 IP2Pgjum8QbmBSX6suiSPU0VDHZjL7pkMA6y8El1vuw7R80wrjAA62RDjV185MF8Tu
	 ejnGqBCrJDHFT10Fq3F7bDLCOX9m520p/mySYV4up+8A8B5nJ7SC6Ov9m86Rx36Xhh
	 3ijbpo4HscY+YykwIq8w73cab9rzjBSaxnU2FgaKxXmbXPu06TcJAMlLRuOuKBhiNK
	 UvIOPhcjYzej/E7BkOoKpFo5+Ns0h8n41YA9g+sYv6C4w05JQVRmUpmJr7+GYtwyL5
	 hjX61I3Jv664A==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id AFA91F40077;
	Thu, 18 Dec 2025 10:10:05 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 18 Dec 2025 10:10:05 -0500
X-ME-Sender: <xms:TRlEaSUburFKeiW9_TGAQpLYEaHO8nccH7e5rpIHI8QwqeP6RIgjiA>
    <xme:TRlEad0EcyHbet-mjVK4Zv08DKlyMw89yDpTx3dtefZWCjHRAcghB4s5DZjQ7WsqF
    DgZvCt5DkT2hiKpknEg6zFYGCDlDGYEBuYLwzEZMyx_0_8WIVUyDw>
X-ME-Received: <xmr:TRlEaZOUctAG16yboA_YVkTMx2wUHPwuxlCmRDByWAsBW_6j9vKKosfbPdOhAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhudefjeehhfektdeuvdefveejffdvhfevtddugfduffejfeeikeelhedvtedvveen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:TRlEaQ0sm6AsVEjbsQLZHVu8eXNiaG9iObFiiq86MYt-KBlcCspmtQ>
    <xmx:TRlEaQ247eAYjIwrvAY30zXH5H7ZHAJgXTGs7dG4IQpP_YQSPI5dpg>
    <xmx:TRlEaW9akiYb31bWAyFqT8CtkDMo7cKHb_qS9Ro2ymv2TdRte3hpjg>
    <xmx:TRlEaUYi-JIjA963kV371Fvg2amHTib4YHCptIqQSJLOx3E0qinbxA>
    <xmx:TRlEadxlbCLXi2cEGi3svqbf7W5da7Bra75OA71wQcbTeH3w6hu07f6n>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:10:04 -0500 (EST)
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
Subject: [PATCHv2 06/14] mm: Rework compound_head() for power-of-2 sizeof(struct page)
Date: Thu, 18 Dec 2025 15:09:37 +0000
Message-ID: <20251218150949.721480-7-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j3hb9zy5hewhbooyjx9tyzjj9y64ynu4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DCC0B120023
X-HE-Tag: 1766070607-579384
X-HE-Meta: U2FsdGVkX1/PkjL5z03/1+yJUedi3P15GO9MhXJjmyvbzS2M5lmxOu3d1Xxf3Jta8X4CyOG9h+2sLblT74gTbN8IGP6FrEGmvy2DMJ4kLZzv/8UpKZIL3ry6NfLszw0EnHg1SfhVa7LKoEjk+hAIdjwOUGeVccHh+E+kLnS3oaSKg1F+vQJRWDlP5IX2JN+VoWH6pFytrKfaS0LvRJMIkEYc/hCsOfTFUigM1kqrxgmeW1eCujrHXF5Dcj9r0iYU0/Bm1l4y3ip9ceh0Ahn7UmDUjnXUQoeBjvkQ2VJD3uHTrGvWrgyx+ucv0SaCgtCllsX5XGMg2XElczI1+7pJ8B0o57ttXC7SG/KeSaaxmaR/Zm+AU2kHY8GacSqGx1aapI4uT+QFyeb2FdTlM3pdH1bYWVgjlbILn2BSrUWWgPsl5ffEe0lmTb/ypWw0zbC8aNmwAniHc++G4EHNECbMi464PC4ufVPgqItjNM0aM5YaClj8iL/FnidfuxQYpIBm+SRjXKH/8VpVUkaDt1WN4qf4aE6ouf8vZHk9OV+SlIwIRZpU4xIK1xfrcDwS9XK/rAEUDQ0YuDEIt1fAS0VoXGl19VrX3hHcJE2db13wzEBbD/UUp8z1x341I6spGxYJ0MMbPR4AqckXWCwwQ8UzOh8jR2yVl6FkQxEg27wmnjEH5dePqwN4nJuBLU0YR4uHIl7loD6zo9apKJJoe7diSTwJjHvXADIlnPcvsc0IaX7vZ23r2usC+7MaF/rY1UPUKtvsTIBtXhHWUaNGpnVq8zlxIP1Z6Zne4fFe4wUlqFn/ytxNUULtgd1Ly747OV5Mb+OmPxSQp8GRkkMT/ftDRZfYyZuyja5ZpyLxUfew4dQPlr5YojxM1bCk//QEOPVO0S7BZhFrI6sYMNXteuQuVxnpUBy6OedZy5kCJXkNt8QXBbW0nD2GR9JLmy2DVhmaPzmBkGNdKVBs2Q6iTRO
 Li/URdDx
 gff+6yOwRMgH9JSXmCfCqFJqY5IQgpUzGiM93UxCViq1PTJzRVIf06S1LPCiegkvcqH/yCCEXgBX2T0vgiY9TEukqOMB+MvUlVc8y54iSOpP6v2Vzs73xhadxOi1lQUYbYK/7tH5OrsD+vszBoNUYJ0QXsFJ79j5U7T8Eqr2q4mt0ccIPtZXL+Hp6LotXjOdKdUrg/nawHVk4tUc8kcWWjAqxaRGOkbKNcZr3sIN84fANC3dLHxNtR6RfKZ9nQO9HHGfBl30jr6XVZZmrEOuzj5XyVtd5cxK7VhPK9YR2BS/KBCNMpBRlpArt2A==
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

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/page-flags.h | 62 +++++++++++++++++++++++++++++++++-----
 mm/util.c                  | 16 +++++++---
 2 files changed, 66 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0de7db7efb00..fac5f41b3b27 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -210,6 +210,13 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
 	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
 		return page;
 
+	/*
+	 * Fake heads only exists if size of struct page is power-of-2.
+	 * See hugetlb_vmemmap_optimizable_size().
+	 */
+	if (!is_power_of_2(sizeof(struct page)))
+		return page;
+
 	/*
 	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
 	 * struct page. The alignment check aims to avoid access the fields (
@@ -223,10 +230,14 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
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
@@ -281,11 +292,27 @@ static __always_inline int page_is_fake_head(const struct page *page)
 
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
+	 * If the size of struct page is not power-of-2, the rest of
+	 * compound_info is the pointer to the head page.
+	 */
+	if (!is_power_of_2(sizeof(struct page)))
+		return info - 1;
+
+	/*
+	 * If the size of struct page is power-of-2 the rest of the info
+	 * encodes the mask that converts the address of the tail page to
+	 * the head page.
+	 *
+	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 */
+	return (unsigned long)page & info;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
@@ -294,7 +321,26 @@ static __always_inline void set_compound_head(struct page *page,
 					      const struct page *head,
 					      unsigned int order)
 {
-	WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
+	unsigned int shift;
+	unsigned long mask;
+
+	if (!is_power_of_2(sizeof(struct page))) {
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
index cbf93cf3223a..3c00f6cec3f0 100644
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
+		if (is_power_of_2(sizeof(struct page))) {
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


