Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E81E5C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BAFC6B009D; Wed, 21 Jan 2026 11:23:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BEC06B009E; Wed, 21 Jan 2026 11:23:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4556B009F; Wed, 21 Jan 2026 11:23:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5386B009D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6962BAEF4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:20 +0000 (UTC)
X-FDA: 84356490960.09.2EB089C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2C266180008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGL3yPfi;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUsXHrF9fRxejjatTIZt8js5k+vl/YhSQ8XrZtcQANQ=;
	b=bm92kFdxij3Z68sUW0o/bBjQQ4JCc3wgTyuVmauHkC9ZoM/e7qirewaYzBmAAN8GFzqK7g
	qn1DmKz1dQ4wCSZuTIM1NmXGBB0evigAvv8CB1pxQSJbbOO21awPB8lPzTwDdfB+S/heeL
	Eppf/1rwoYv58FTv+dbVFQxIDxaFVfI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGL3yPfi;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012599; a=rsa-sha256;
	cv=none;
	b=UaYfJ9+0WdAc4l1Gx7reL7J81bniurgEsI+/XWzqoxeNjQ+FZIsm7GERuAHZSzrdMoLVpb
	uPGH8YXHUVOl5qOsL4RQPAjiuZtHBQPn9J/uV7E5OebUiRmxT9PNvMuwfzLlUgT4GrmIXJ
	XnUAtELZvS34VxbQh+QRw9SfklhWO8k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB8BE60159;
	Wed, 21 Jan 2026 16:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E40C116D0;
	Wed, 21 Jan 2026 16:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012598;
	bh=YqZnPHtWAbhYe/dyoR0Wa8mgCurb8e3E4uC+0tBgKL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGL3yPfiIcbfbTvUNEi4ex3PAmuVnhkNMn/87JRfe0jSAE/e4ii7Vd5Gzyo7HbeOT
	 jYVTwj9z6M+HTAouly1hc6V/yuyt34YCigDwCxHbI6Itq8cyaSjdY7EjnGfwwyPpG5
	 62Z4Ji9nne0/9tvBSY54PKbkAVu1HrQpfbMRbCEarfcdglHhYhPDPVcRQtal397Q7w
	 CIgTd6nJdwVJfelj8JEswMaz5BfWR0VNm+85PLKnXQKOmKMtv5b415F2tkMgQKiJbI
	 2cunXhzqNpv4b68wlQ9yGu8cSPSjStXUKmFZorRreCqXiK9hqnA971IVz/4EJ860pV
	 5F51iXqeCVPYg==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2AE40F4006B;
	Wed, 21 Jan 2026 11:23:17 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 21 Jan 2026 11:23:17 -0500
X-ME-Sender: <xms:df1waRSCUKUUTSoWe6hMc8HtCM5OxtCxudhSViYC-602lWjJzfFrtQ>
    <xme:df1waaCSSx8i3rKOLG0JvY48BKfKRgL_OA-iQm7EpycH4vVjAdKET58x510i2vmmz
    acxb-tPJqiIlf7bzdr7D0CpTQ4Jh1fj-1PjlEGtDo-FKJaRbvQBOWU>
X-ME-Received: <xmr:df1waZoiyD4lI6csIMFe36N7EM1mRdxrtp4e_m1XxreN0P5GS55kaKLbsS6JDQ>
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
X-ME-Proxy: <xmx:df1waQjvFnn38Ha0d2QoTlxTyqyrBxpb9cNBJLCHjv3tGOFYttq5oQ>
    <xmx:df1waew-MahKw1XlWQYGm7u0sMM_Nn_aP_-_WmNFX2Hb-kEM343tBQ>
    <xmx:df1waWIhE2HHA3iCLt5GSZMXR6-trccGz18iWmF5PxVluzZF507CtQ>
    <xmx:df1wab0pj1B_dzSe2o0Cm1LAOOgdfuYMHSLp93yppKA1MUxZTmKOkw>
    <xmx:df1waYd9I6DpL-hGKd-jgwLhLy500yPP293jIWgS7TaPuTmb-aNNaRJM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:16 -0500 (EST)
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
Subject: [PATCHv4 10/14] mm: Drop fake head checks
Date: Wed, 21 Jan 2026 16:22:47 +0000
Message-ID: <20260121162253.2216580-11-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ui7tnh1c8xi5ycemntdppbxgcxy6iw6e
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C266180008
X-Rspamd-Server: rspam10
X-HE-Tag: 1769012598-63740
X-HE-Meta: U2FsdGVkX1+/yqtMdI/F+xB3epE9b9qNV5mh95GHKlfkXaQgoD49XJFaqon99Bsr5k+C5xSt9gYyu9iEn26OzEAfWznd3plCJEIqkoQfqU1AgPtLm02At+lahGggxcWgIXAlVifdkLqj0jGsViSo8ryaz6ovy+J6wX8yCRhpn8BZkJbKIVTZOVHkUHhoyf24M3A0lJFMYznzGtTbDnbjBYR2xj3wGYLGR/nRiVL9qriaG5cajVJJh2ANqH0YmbqbvcKrpbVCUVhGUWoJj+gCZ23dYavsWwQuIhgrhJK1ZeVP6zxHVRcGF0RP+We5DfDytGj5JNkG24z4xXxAj/a3P8yGsU5RftAF5mXZuN9ysFf3/UgrVaa54oKmtSwPv0qAJyi9mv+gDLqz1xCnA2sfWOWPrnLTjAn6vlOotpaPsxp9EMnxg3eMC1ppVo3PA4WlRdioviJDEhIuCWBFrvjeNozjPxVKZGQ5nQ5epXZBHmr4OlS9EiPQ9jNHhD6dSjBHa/bXhrBYP+z0j/frDIA2NEHB6cPHQX1GYKkPxo1xpFcKRH2A5xF/+S1OX1ZMURCU6MICChfYjKhvD/tWIe/l23S8vYcAxJkHGTrrEgjvTVO4YIvgBqAguImRYmZvKELG5FwQNThNmZwn4rcUpkjNRYhtyrfw7Gj8P3BWIxshXEA9PU4Z8SYtZWYSqxvYJ6kyLAfG6jCFkgc+DaDyv7f88Gg/IHSzhFaM/k6qxYToK6RK+f15m8cSGHVPGFCi+idnytMgxRNYq25bZyrZSMZeTEFk8kFK0UKDBzp+mdgkzdJte6ffBfai07FbZuwKtXv2K13stiPYG6qm24y82L2IWitJPS4vjW52hccgEG1eHyzIR5mQwAdNmPYNa4pE+nSfJr448CQiwxU/m2lRukiLtXTRuYfSEl56rbB3AUtXe/PQmwtt6004CQ==
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


