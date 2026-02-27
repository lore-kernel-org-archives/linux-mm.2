Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 199CCFD8FFD
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F606B00D7; Fri, 27 Feb 2026 14:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D7F6B00D9; Fri, 27 Feb 2026 14:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F566B00DA; Fri, 27 Feb 2026 14:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 235626B00D7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2890140880
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:34 +0000 (UTC)
X-FDA: 84491261148.20.F596434
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id EACAC20010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k0M1Ly6c;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hz1fy1H32F2Ff8uhiLjChI2U+z6xJBFlnAOtSbXSFI0=;
	b=cCiCD/i5x3zxvXZjIJBlL39SCSmETm7Ua2F5ytkqFdxoaLcvbggnHplJ2tH6nBd3CwWHJv
	lYwwn8/qG7J/Ani7fCdsRgVu8qWVf1rYPSF0XWR5DWHVWGL2mTpEU3skv/rbcrl6VQPLiG
	hRLwWB3em4vRKPu32pkA+Q2F7F3MeMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221412; a=rsa-sha256;
	cv=none;
	b=TvRUKQoYpBxJvMCTN9Zw6LfRj5MOJbmD4iaDxB1mSwdy9EdE4JW8iEJXAgQg8s5taqiPVv
	K8l4ph+OAQxBEcEuSce517GhSDxI31EapROwScm7hRoDZ1ki7xEbdTY1NSaZOA/0ZG1mFK
	qBp1inXnNSjWWUI+mFj6f+46WGGL8DY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k0M1Ly6c;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7501560126;
	Fri, 27 Feb 2026 19:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994EAC4AF09;
	Fri, 27 Feb 2026 19:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221412;
	bh=TtTBjHeyxhGqdZ1CkWcmkv4w9nL6WGbMg0cd8jsgw08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0M1Ly6cKPu0RIage8jMCteBV69mwxszdQd1MVvptiJqScirOfeNEnm/qJWnzBm38
	 +89SjwEQDZWfw6CRnX5hAcdtFAlDj1NZ6et0UB+vn1bOwNbmXQvjJBexzgTZvg6IN1
	 EOpIfrvTSlt72AW1c1yEfBkH2KJiOniG5TbeXm8Rn4CfoL9otGuDsj2jz3g78qPDxu
	 e6Tv8cu9UFCrizTIZL9A9IO8HDePpBXiSFaoICJrIhJNPC/eBhvbeH6Nmt/li44By+
	 l88s7vBUp2w/ZHCiXSfTAandGPfdTx94k/WAjlb3Wp49tVt88Megdw8eBhmSeJyfWO
	 fgDK0a8A7ajGw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C0FFFF40069;
	Fri, 27 Feb 2026 14:43:30 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 14:43:30 -0500
X-ME-Sender: <xms:4vOhaTHt3DW9QRfv5dLsSWnzpZecptBrk2Kno8jrbbUGst6jQcMPaA>
    <xme:4vOhaZgNCOMfg-icOL6clAWH0jxPiSxHF7QPuC7n1ZefpMwpcOPNOz6SG2tkJepxP
    0QGEycY-CHHQZQ3R2M3Ob4KsJVLpGDRrCZpJ-P4iNrWP0RvFUw2KeU>
X-ME-Received: <xmr:4vOhafQ6cjzGMN3eO_P8oTifOKcAVDjxpO4efXbYQvhFm0dp3pYQY4iuLL2dNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrih
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
X-ME-Proxy: <xmx:4vOhaR-lrYtaFNh2v5a-qD6QkUUOMdKsXvCR4LVi7lKi8uhGdoj2HQ>
    <xmx:4vOhaVQSmHr7lzq0wQ67chPXayOijeobm3QhaQeYPPaf4P0eByWb6A>
    <xmx:4vOhaYbJ8gyKIGlbdSfl17VTFdzHFeA2k0QOaiRs5FPml4n_9VyKxA>
    <xmx:4vOhaeSZW8yXc1yxCy1obpPgsemxNGz91ALhLgrV_7Q9ZP71YDglyA>
    <xmx:4vOhaT4-e1NwRGbjjQ_SrqHaEWn03brxsYkgr-MxVYIKlb-WXoc73nSS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:30 -0500 (EST)
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
Subject: [PATCHv7 13/18] mm: Drop fake head checks
Date: Fri, 27 Feb 2026 19:42:51 +0000
Message-ID: <20260227194302.274384-14-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EACAC20010
X-Stat-Signature: shorf1h6sjjfouwk47p7mdwdzp1fq4ns
X-HE-Tag: 1772221412-659666
X-HE-Meta: U2FsdGVkX1+TzK/SES/hP1UjxA6Yx8O7oyZYSOl8DxStMFGZ7Gk/IalDoKwSqz6zFKTyEYF85M87Rolk1olkxaq9bvhHZU6FM/xiLdMGZbG1CqJDXKUF+oyt6mzDfs1mPgCWqb2tp6B7IZLnycrQwIKMoa+jQoHxIutJjbNwZY/+H4kVW+0TGhkVxnCznZ6pwF4pRyvjVWQN4TCRhd7SSTase7nBpmFPmoSbSV8vFif2HmJS5axtIddi3X191F4Hw6pfSqcquDUs+Od6tBkg3jBprHBn9jkmrYv2lEJ2L4v1QQsY5v8Lb72zK39Bj//VHJYZyBOFF3u8BcyhbMStnrXmPXTvZuWFY43OupbvQricY/ypC7QZzvrdV5sNVSVF/9nWFnx3k/qWH/yhp/y4opo6Lkfx15hKoz+8GeelK90Xo/deLE+fIbcrKBg+tTGoudXST730VAnbn64nTpuXQN2UgshKnl2sBLJGULjczQincf91VABQhWT/qFiKZaPfRPoMbE8UILOYlPPsXnQtBV8zFEDZcbMcrfVrW3gUuSYM4XzKXGvpzcwxp+CDIrDljeo7Bljds+VytzwAhq6uUs6bBcyakYDJ/sgG1lr7OdABq7qKqvUlh3l9mXz2htCy+j8dRwmHxKjVO/C6GRehduqn4bPWh8CButjpXhNdVj8qo3XTR7IZYIP4eeyJ4Er4Mi5kk+uOEtni6fpVYdZ5NjEYtwJnxSWur4Npy5bR//BUZSl4PqtBhD3J8/nI/rI131bQo7ESkYFMWWTv66Op1dXH/wTSpqXvWys3K/UPF8IjxukOc3LQ8A54wg77BrbP3/8nK3Ta2/2okSyLLQs0Tx/yyzmEGcKPZ/we55+IHiSDd//9/lXeuhvXYP+Y17JNKaM3FKE6ffUb7DOrXR325s0eC5D6DQJ4RLefmYeNY7ddVnvHqShkxbVHymgrW4CVweUgkxJ8YEwy5XUL6R8
 cz8gJO3p
 f2SKRUlSJmqyDrXHOo5112sqpcG4OoXQ8VRXTOPwBCRQtT83Zju+DdVZ0sl0YTFpE8QyPXSs3AK1Q/Ld+eOPXC0CfoVIJvQIvRuxkSq22Xxr7AoLy34sDSNNdh2tdCuQQUmmEOfWVhTd64FHXOo1+MhzRs3oJ2onGHWXWOJps2v5kYaO9hvAC5z48BelOAgta0C86a3oaWzI3wWXjSp3icyrrllde3/mRQGvR8/sh5SvcyNkxtypCLDXSb6Xvh6Usd7vj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

With fake head pages eliminated in the previous commit, remove the
supporting infrastructure:

  - page_fixed_fake_head(): no longer needed to detect fake heads;
  - page_is_fake_head(): no longer needed;
  - page_count_writable(): no longer needed for RCU protection;
  - RCU read_lock in page_ref_add_unless(): no longer needed;

This substantially simplifies compound_head() and page_ref_add_unless(),
removing both branches and RCU overhead from these hot paths.

RCU was required to serialize allocation of hugetlb page against
get_page_unless_zero() and prevent writing to read-only fake head.
It is redundant without fake heads.

See bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN
walkers") for more details.

synchronize_rcu() in mm/hugetlb_vmemmap.c will be removed by a separate
patch.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/page-flags.h | 93 ++------------------------------------
 include/linux/page_ref.h   |  8 +---
 2 files changed, 4 insertions(+), 97 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 01970bd38bff..9f22e4f4ef9f 100644
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
-	/* Fake heads only exists if compound_info_has_mask() is true */
-	if (!compound_info_has_mask())
-		return page;
-
-	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
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
@@ -396,7 +309,7 @@ static __always_inline void clear_compound_head(struct page *page)
 
 static __always_inline int PageTail(const struct page *page)
 {
-	return READ_ONCE(page->compound_info) & 1 || page_is_fake_head(page);
+	return READ_ONCE(page->compound_info) & 1;
 }
 
 static __always_inline int PageCompound(const struct page *page)
@@ -923,7 +836,7 @@ static __always_inline bool folio_test_head(const struct folio *folio)
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


