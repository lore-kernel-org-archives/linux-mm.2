Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9ABDD44C5B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A5F6B009F; Thu, 15 Jan 2026 09:46:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CE66B00A1; Thu, 15 Jan 2026 09:46:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5736B00A0; Thu, 15 Jan 2026 09:46:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5456B009E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4676A1A0388
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:30 +0000 (UTC)
X-FDA: 84334474140.11.C7E1E51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2E380160009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rWv4qe+s;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUsXHrF9fRxejjatTIZt8js5k+vl/YhSQ8XrZtcQANQ=;
	b=P7Exvybo+zLEZvPQLdESuNN9P7SOltc4JD0mTa/5U41ojlRpxcZrSOz4ddh5NmGEYsBS1R
	JMwODjFgKQlHxogrcbKESa/5QGYw4z90M+mSbGfwGBek+FFECY24G1EBpkIXwRg42jfncX
	GtF8NwuqkoSyLvsf24BPmk4OYfLeGgQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rWv4qe+s;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488388; a=rsa-sha256;
	cv=none;
	b=FaF1XEyGnS/T1uUZoMwqhajI+Q9I//iN+9LmX/MtiH+mcdRlKydTCqtjiOm9yiXMebtC/r
	tLmW7oEHzGoD1JtHKWMgGwFgR+W+ktfrjcF+kpFLkHiIXCQHAv+rUiOVH+B+XF7yNR5FM8
	HtlvqydJpGJU2qQPgi7RZqvHXTlXvBs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3E5D404D5;
	Thu, 15 Jan 2026 14:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46468C4AF09;
	Thu, 15 Jan 2026 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488387;
	bh=YqZnPHtWAbhYe/dyoR0Wa8mgCurb8e3E4uC+0tBgKL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWv4qe+sJ+/hFsRhoutKxYJ8CJi+1CusM17y46kUQBOMKSUm/MhDuVzP0DGfLPF9H
	 oZfOrBpfbuI8nzW1nVm6hJL0+mUtSghpqW30SE18xSuxgpvAZLxASGNT+42YLhLiLz
	 cAO6rBFlP6v7XJs1p2Q9p3NABva9NV/JHSHpYfhS8HcSWO2wTuYxE4JGYSUxK+w0lJ
	 sIbPo7vZis0AK28ZdJv7ZP1HiZqnegbrWVFQLH9eqiN0u+JM4oNZKojNPxTfGTN9FF
	 8JGgAvudtokffov/+XeYX08WHKIybpy7+PEL74ChIlqjjES6rlSg4MRUPm0BR6FSGg
	 mDCHI+SdCpQUA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 73FE6F4006B;
	Thu, 15 Jan 2026 09:46:26 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 15 Jan 2026 09:46:26 -0500
X-ME-Sender: <xms:wv1oaS1z5ezH30TvmE-SJ_Jen6bY48S_36QKXYiz_s1PuLaokgX5sw>
    <xme:wv1oaaNsB1ELgKbe9kj2ODF2qTpdrQS8aqNIHf52QYq0_3K20lTCrdTSUTKifl7CB
    6jkm9J9VSvgIqNz4RfVI3TMmYx9ueK9yvVvXJnHGihyYyn51sBCabE>
X-ME-Received: <xmr:wv1oad2K2Sh-RIxX6i0iM6CmS8yFqug6tmJrE2U4hCwyHU8vg_v1zYuquoC1_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:wv1oaZ32arSRVcCzlHT-5fW4LgZ0X8YL9CUuyHXVq-FBqCXjtRttcw>
    <xmx:wv1oab9d20UFqkuC4crTZvbgYawUJAY-p69Le0SHACDoUUY0a7Df2A>
    <xmx:wv1oaVZryOure6KdcBuMzCkA1l8SltTg6oyshwaqezXdWdadAgMFXA>
    <xmx:wv1oaazhf08s3Zg6pjJ3-6lqEg5zdLwKiDoTn3ItM7jJV-4qQkAHew>
    <xmx:wv1oaT9XL2yCNOqSoQhzsUDX_jF17ufufw6wcg4th_JY5Yctw5HO9t6w>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:26 -0500 (EST)
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
Subject: [PATCHv3 11/15] mm: Drop fake head checks
Date: Thu, 15 Jan 2026 14:45:57 +0000
Message-ID: <20260115144604.822702-12-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rsjkgfbtd64xfb4aw5mt9tqahsxqomxw
X-Rspamd-Queue-Id: 2E380160009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768488388-247810
X-HE-Meta: U2FsdGVkX1+ZfBDzHDtw4aMGzq/Wp/wzhPr9dlIa3/VIMT49RwqtYHGD0z2Y7qlFfdR8fxetrjp0vdhxmJCDxX8+iDfl4dcNMmuF0WvxZPl7wJ58X2XhX1EGNWX7X59tS7aKReccDBhbpJzoq10B9izzRQ4/dADh/2SDBLyIO+OKcASfusPyqj51aZ8vBDz54BD9jD45NkOMk+LXmfbteQ+vbL5MOsveaig2yjIkfxlO+nWdsWBmU/+jVaJli8MgbyTsJboUlVeGKnk+eF3mw5Ll1rQI9p+SpeMlEdmE21XXIdJM6gbxkHKOPzFlnJZ8+qdocIEDP78fRZbj7fBqzksKx3xZhvFw3uhJAnuxkY+lK8nbDG99XXMVF7SIvtxbDMiYDiO+u62BSxWujmWKItIVVOEAVR0VDxt6LiiZdGY7vlJtc03mz6dYY0RGt/kduB86CVYtQy3G0K/eJnceUqpSmZLZIg1ky4sk8kXM3p78X35yAnfXsVxmia9tIb+E1I4eIiHsGcnuXbFkROravx4HrV1TqbEVauFeIX9SoMTNDOxrjiKtibnbMoYi0Jf7nD7yAyweiYKJcJpMgoQoFnF9Z5S8VYR/LzdXGjX36YonZoqn9Iewda8pvOGn3gVzhncJ46kctDL4yOJNkdpzj07Bt6tNW2BFbCDkQmKke6ix14lXRHlp+BmDbc2sWc9G8rBAD6NylQhDzJPI2bxU0vdAcN1kPcrytezzVkDtraQ/TRzrDCnCBhHaFnKkqW42MwxZtKW8CbcjYWi6+hWuntYdIkJn/q4zKFxTkI/mLMOlsrAi/6uvV/fTv2Lde2QvUUE9Sn1kjXZNuVYMLHtBLoGDyhcHixqyq7EvrJwIPo1nqZg13jwdkZqQZ3Wwlf3G7fxhQpZwROirrQ25Zeopp9zUpcmi9WNr71sya6FG9s37btO/KoaKBAPyadVTb62E2BI6EdeJcnFiTEYUQbJ
 JGhSZaaF
 cpbKU11f2q+O2A6naull0f0N6foFGabZreZZhrc1vUeeO/7SowA+3zm4yS2VyRD+GwjuEDbH2DEiZPrPENdKNmMDGVf2ICpmWhWjDtDhwZ78PqYVFlp8Sknf+aORsL0lVaviVhd1EZ3hdkXiV4CXdGvM9etWoiQVAQg1nXf3sutHESBUAHCH7iKcP8gimBwpss4WLPFzEc39bTyCR3tUGDP4Hz9qlGnE2vWFa0lKkBV2FjC/0NHMN9Oybs1yj1pQnE7odi3I6YxVv7TU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With fake head pages eliminated in the previous commit, remove the
supporting infrastructure:

  - page_fixed_fake_head(): no longer needed to detect fake heads;
  - page_is_fake_head(): no longer needed;
  - page_count_writable(): no longer needed for RCU protection;
  - RCU read_lock in page_ref_add_unless(): no longer needed;

This substantially simplifies compound_head() and page_ref_add_unless(),
removing both branches and RCU overhead from these hot paths.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/page-flags.h | 93 ++------------------------------------
 include/linux/page_ref.h   |  8 +---
 2 files changed, 4 insertions(+), 97 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e16a4bc82856..660f9154a211 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -221,102 +221,15 @@ static __always_inline bool compound_info_has_mask(void)
 	return is_power_of_2(sizeof(struct page));
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
 
-/*
- * Return the real head page struct iff the @page is a fake head page, otherwise
- * return the @page itself. See Documentation/mm/vmemmap_dedup.rst.
- */
-static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
-{
-	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
-		return page;
-
-	/* Fake heads only exists if compound_info_has_mask() is true */
-	if (!compound_info_has_mask())
-		return page;
-
-	/*
-	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
-	 * struct page. The alignment check aims to avoid access the fields (
-	 * e.g. compound_info) of the @page[1]. It can avoid touch a (possibly)
-	 * cold cacheline in some cases.
-	 */
-	if (IS_ALIGNED((unsigned long)page, PAGE_SIZE) &&
-	    test_bit(PG_head, &page->flags.f)) {
-		/*
-		 * We can safely access the field of the @page[1] with PG_head
-		 * because the @page is a compound page composed with at least
-		 * two contiguous pages.
-		 */
-		unsigned long info = READ_ONCE(page[1].compound_info);
-
-		/* See set_compound_head() */
-		if (likely(info & 1)) {
-			unsigned long p = (unsigned long)page;
-
-			return (const struct page *)(p & info);
-		}
-	}
-	return page;
-}
-
-static __always_inline bool page_count_writable(const struct page *page, int u)
-{
-	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
-		return true;
-
-	/*
-	 * The refcount check is ordered before the fake-head check to prevent
-	 * the following race:
-	 *   CPU 1 (HVO)                     CPU 2 (speculative PFN walker)
-	 *
-	 *   page_ref_freeze()
-	 *   synchronize_rcu()
-	 *                                   rcu_read_lock()
-	 *                                   page_is_fake_head() is false
-	 *   vmemmap_remap_pte()
-	 *   XXX: struct page[] becomes r/o
-	 *
-	 *   page_ref_unfreeze()
-	 *                                   page_ref_count() is not zero
-	 *
-	 *                                   atomic_add_unless(&page->_refcount)
-	 *                                   XXX: try to modify r/o struct page[]
-	 *
-	 * The refcount check also prevents modification attempts to other (r/o)
-	 * tail pages that are not fake heads.
-	 */
-	if (atomic_read_acquire(&page->_refcount) == u)
-		return false;
-
-	return page_fixed_fake_head(page) == page;
-}
-#else
-static inline const struct page *page_fixed_fake_head(const struct page *page)
-{
-	return page;
-}
-
-static inline bool page_count_writable(const struct page *page, int u)
-{
-	return true;
-}
-#endif
-
-static __always_inline int page_is_fake_head(const struct page *page)
-{
-	return page_fixed_fake_head(page) != page;
-}
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
 
 	/* Bit 0 encodes PageTail() */
 	if (!(info & 1))
-		return (unsigned long)page_fixed_fake_head(page);
+		return (unsigned long)page;
 
 	/*
 	 * If compound_info_has_mask() is false, the rest of compound_info is
@@ -397,7 +310,7 @@ static __always_inline void clear_compound_head(struct page *page)
 
 static __always_inline int PageTail(const struct page *page)
 {
-	return READ_ONCE(page->compound_info) & 1 || page_is_fake_head(page);
+	return READ_ONCE(page->compound_info) & 1;
 }
 
 static __always_inline int PageCompound(const struct page *page)
@@ -924,7 +837,7 @@ static __always_inline bool folio_test_head(const struct folio *folio)
 static __always_inline int PageHead(const struct page *page)
 {
 	PF_POISONED_CHECK(page);
-	return test_bit(PG_head, &page->flags.f) && !page_is_fake_head(page);
+	return test_bit(PG_head, &page->flags.f);
 }
 
 __SETPAGEFLAG(Head, head, PF_ANY)
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 544150d1d5fd..490d0ad6e56d 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -230,13 +230,7 @@ static inline int folio_ref_dec_return(struct folio *folio)
 
 static inline bool page_ref_add_unless(struct page *page, int nr, int u)
 {
-	bool ret = false;
-
-	rcu_read_lock();
-	/* avoid writing to the vmemmap area being remapped */
-	if (page_count_writable(page, u))
-		ret = atomic_add_unless(&page->_refcount, nr, u);
-	rcu_read_unlock();
+	bool ret = atomic_add_unless(&page->_refcount, nr, u);
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
-- 
2.51.2


