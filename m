Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E48D44C56
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2996B0096; Thu, 15 Jan 2026 09:46:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89296B0098; Thu, 15 Jan 2026 09:46:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DE56B0099; Thu, 15 Jan 2026 09:46:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF6586B0096
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 616CD1AE38F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:23 +0000 (UTC)
X-FDA: 84334473846.10.E262C3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 328061C0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eeuk/XSg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488381; a=rsa-sha256;
	cv=none;
	b=b+vLup3GUaOghY4c/7JXFmqLCRlv4DGyOzORHCiDPC1/cuZRlyfs5YbxwDSBds3WA06WwM
	EvryorrY0NZERVkKsqZ1iaIW5KPje6VWlYQTW7Reo3kA951iHQCNXj41/I8C8TvmV0/ndj
	k28wIrwXaLCbvAWIKKGO7sQ1TBd4QFk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eeuk/XSg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFI+FAtH7OX1GjvszbrTDeUvvA7yGZf/Qi/WIwfYtYo=;
	b=kQvFM/V2mUU3+uWGSfWblv2btl0RQIbb4/7qZOA4FeHV9CsramNCHYRE5hy7SJSiQevmON
	gD+sUxN+C9qvLXBYejVjgM0z2S7rsOls7bdsOG3qXXREYIsk/PSM8cv+6cWPICFfcYKlJV
	akkf3Cyb84xsktCupgBypdL4UA/pY7U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C9F044462;
	Thu, 15 Jan 2026 14:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF09DC19423;
	Thu, 15 Jan 2026 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488380;
	bh=jueaS1qYz8lwqJ6jPeGHTAmiWIc9uM56rJANRez3R/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeuk/XSg2IkrbpmoSRe9I13l+hXMFkbgB7BdibGmBByh8QHTrc1wP4GSkQ8x7nz8s
	 CmguYmU5Pnjv4W/3Tp/3NJjIMJlzz74/AbREC4hhcuE/OEymvgFn8Fst2ju2HT5f+E
	 phoArj4tkGCBZTy7TvRIZIiDUZgT0tazIXpI7GLYTyXhAXs0pS1vS+mthqAbIK64bg
	 slg43j6HRrZHvDm/EbB3sed6mZQ919/uy5hYDf1LkVqG/L8F2euGF3H4NS5425OI/D
	 ogjq2/pG5ugSpQkTZsJyH6CzbxLdGvy++uuee07vKFgH0VQRzIqvucBeqcDlu92ux2
	 8sXHNfqypd34g==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id DF9FEF40068;
	Thu, 15 Jan 2026 09:46:18 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 15 Jan 2026 09:46:18 -0500
X-ME-Sender: <xms:uv1oacVe5kpb7FbgdoAYSZxa9gTsMwGf1aoz3xUd8EE-G4HEtBDxWA>
    <xme:uv1oaVtMNiv2_y3mlPlMUB8xvvwfyx__0FCaaAyQcxQHEDeidVy9G5J1DPXizL-UO
    oyyXhwGHgn00S26q_i0_R5Q0MN0b5OejmtqeGXrDFDwqf2RRUQGHvM>
X-ME-Received: <xmr:uv1oaTUcbvmDn8asxtVp7ybgWzYsJUWUIA-MFrThcsDunxPtTAwJ_IZfJxkN2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeefucetufdoteggodetrf
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
X-ME-Proxy: <xmx:uv1oaRXpYUuJg5auIPQqvcUeG2YSerc2pKc697_HYlN6MAeJtA7mhA>
    <xmx:uv1oaddqeAGSlB6qPSBzKxT7J27SjWen2q9yFGLX_1BcwhYwNAIx1w>
    <xmx:uv1oaY6OisnF4HeGTcrch7q8aTbQTQmT9ZrFZC7vPJ1l0rzTdFGYIQ>
    <xmx:uv1oaYQwbS6uSesPOxH7D19a18qTngUxk8ES1ca87-z6VVcl3zoc3w>
    <xmx:uv1oaTf5L4tqG5DVM9hkR1mZN7sSLg3DncZcagTBWv5tsrxlphhErDsz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:18 -0500 (EST)
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
Subject: [PATCHv3 06/15] mm: Rework compound_head() for power-of-2 sizeof(struct page)
Date: Thu, 15 Jan 2026 14:45:52 +0000
Message-ID: <20260115144604.822702-7-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 328061C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: ij4ec7eqps4ing9ndf56c3jwerum8i8g
X-Rspam-User: 
X-HE-Tag: 1768488381-167869
X-HE-Meta: U2FsdGVkX18VH1l/ypJHqPV/LCK95szbGcdgexZoqOspNfrI+6MEKBhJIzKSSiSZKETZTWrNpBsPggjRJGi7EsyZOVy6dqJYouq0rJ72Btb1Rwh8KmFMB2qAUxwxGOVbOjCwnRewqSsPckDxxkY0OEO4ew4xIZTOiWV3+RZdSRir0Gj5WIxv/KD2uxZAbCSmvluHbNhA999KOpmwX8J5/nB+n2LH7R9Xt/L6UxsQ1iPe3epWL7MiSvfsrmnYazgb7tm4DLKqkNibJbJVoESanUExD+2vwRnqPKNQhpZltDItxd0kTHK0Vg3MPPj0i4VWkMhHfLVTia7QcZ+1UIA2gx1P351i3zTkz+NdmMdXe5mopuCgKGkyV/dKI3GuHJDwogGs9N8gW35zUVR3m9DLhPF6u8uL7u1L22u2RBFzn3TM/4ZezS5IJiFZXRb8PfP9spnwu5M+SmJ+7+HKWX0L/rpBX75B3P3P99qJ8Q5m0uuy2tK/qLSj1TRIFHbgVIYT1wPMuKdFBelSQIwt7/Y3s9m7/aPyCiDoS9tr2Ct0Shl9JwEn9sGiaHD6BX3BMzqSHezpIDiygK9F/oan9oO4hYn/KndxWPLOLDWEz77H4382SejeKryG7+qgopnoQlHEc5G5fUfdEdjD4tlqIHmSp/uZSnQKVdarzGJB4AIsD5Uum4x9qTe3evQvC93zVRibHh7TftGg9y+4GxxMclGpr6uCGy5v+XsBfMkJyrdBP5rfrWYWHpsf5Bmfuq/b8p/hFrwuoyrBoMhVfuN1FjBjhdRkWWprgTLRbGQfgDuFEj+o7pmO7W9sWCOmWqgczvUNgk5qiGAglY0NSzLsYN0oYWIja5Os0x+kxCsLxWhCEyCsi9QnB76SCdDa2I2EkWwmgtq8zFSFc7HkK/JmqB3vsDFX2uqYnMp7DgbQdmTS8+WuIk3+Ek/ZQ3hM0SwRDz1JtGnna0EW51hySYmAmtX
 /D1HqCcD
 B902GfJyxJdsRLCwhOCRz3lXNXs+dLkIWOkAwKtteQj/mraR+9Ojn4k/doIrSP9xtAgdorrCWoQnac6u9sX2Ae3KPJr12ttSn+XwYfEYq3Xe/EgNwh+OMIZXQ4Kks+ms2z8WnpnfovAHHwnNzSM8/CKIEF/rv722ufQ0JWswMB7T2PgDBJ6pmLP97HisrK8s+pxtPUE3iBBpbV0yDnMAT+t6sGYBpH39SG9A/q9dMm/bWCIlDs99yrldrSrI2K+b5eyA0xRNXFDecsr1rm42D1TlmYZrBPtJSr6Pbxg03hWfTew3HWJYEVrqviQ==
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


