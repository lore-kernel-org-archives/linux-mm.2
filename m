Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B5D2FD7F93
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234146B00B0; Fri, 27 Feb 2026 14:30:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198326B00B1; Fri, 27 Feb 2026 14:30:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB096B00B2; Fri, 27 Feb 2026 14:30:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5EB66B00B0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A8D121CC0D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:57 +0000 (UTC)
X-FDA: 84491229354.17.2ECE894
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 98C22C000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ktrI3I35;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hz1fy1H32F2Ff8uhiLjChI2U+z6xJBFlnAOtSbXSFI0=;
	b=HUNQd851HfMaSbYeo1vAM7JIP7U+wqQePZVV+NXSnztqrrNZ6uDTxp/LNhTAhDBelFM2dI
	pTuXCjS3swju0x/Z5leeYtnH2401Hp71BKX6quwTCIe2IdUjI/MZMl5KxyLL08Q4c/wrXU
	pvzk8Duc1D0ogVUXiJaOpRcSmnWbTmk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220655; a=rsa-sha256;
	cv=none;
	b=8Kszs8CHOhgR+rC5Qit/koHiQ3KvxtF8USczdFubZ5yjpf+Yu1lpuzj563/rFj3cdyB26X
	ZU66vOKRqPzWIsPtfxlKmmGgL0tPUKCta+7kDWum8bL72aVULeEVuNp9iQzXQKlcg3yZSw
	+TxBy1kpUdsYjcv7zrwLzCyZYcKAp6k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ktrI3I35;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC36E42B90;
	Fri, 27 Feb 2026 19:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD89C19423;
	Fri, 27 Feb 2026 19:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220654;
	bh=TtTBjHeyxhGqdZ1CkWcmkv4w9nL6WGbMg0cd8jsgw08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktrI3I35sb9ir0+TUiUz3nOKk9lTEhnYi8/uJKaAHFDyEdTFxhluTlX3kwxjdxvCE
	 yXhF9ng7fV2fVVE1jwM3Q0mpCYBRF55qaZQpn5V4Xj7R5ax1EpkN/U2P+8l04rzFQV
	 BBXmXDNIfjPNa/fiZaAJCWlic2lCpoPaJbegqgzegHOJSpZMsB9VeAvWTVDD+0SVxi
	 dfr00NZ2AfPLH2FwNF0ngp9M7SGUBt3HlygDCrzqefNO/i+TX95vEKnx5DTMLBaAVt
	 OJ6bZm9QZAUjI15Kx3Jzeb/VfAXIpL034xT1o+C5QNRWGxTCk3tMGXF8ZnFyahOLBk
	 zR3lUCoGLasng==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 136BFF40068;
	Fri, 27 Feb 2026 14:30:53 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 14:30:53 -0500
X-ME-Sender: <xms:7fChaYQBs8hjOUv0A0_WwQ--YzWhz50t_DKgnF1EWYwJuFt5Ua47Hg>
    <xme:7fChaWibGiBxPhS4b5trAfx-QTdzwr9cVO33MLG1trte4mdsS2ILLc4GxnETRqC8F
    lI6UICz3r7TqBkDcRgbtY1E5n_9cKRmAuk2M_lE0jRuwMhQFz4jQ1Y>
X-ME-Received: <xmr:7fChaZrayJoJYdVU6h1_iBpsRxCeO0ukDyeOh3MMeOPqEVpAvNq_8JnzVEDCfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:7fChadkd_cdWRkvtrZWCgp1a9KH21rvc3hKduYtNeD969_ixBAB8Cg>
    <xmx:7fChaQmfKPGIXLnZYraJf01DM6Oq6i6eAWmNW74OnwT3NmaLtqjSPw>
    <xmx:7fChaSPz63qiwTwxpz0q6eXaMNpN76EPa2nyc-ZRqS1mCxOMOwstJA>
    <xmx:7fChaX75vspVmbY5S8_OEX6tz1qDisGHoyV7m_lUb6_x--kC1nxL8A>
    <xmx:7fChafsZYLexUVXvwNjXEC9OAWQJs8xRUj4dfCceC-7u0YqMw2ER3yLP>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:52 -0500 (EST)
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
Subject: [PATCHv7 13/18] mm: Drop fake head checks
Date: Fri, 27 Feb 2026 19:30:14 +0000
Message-ID: <20260227193030.272078-13-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98C22C000B
X-Stat-Signature: shorf1h6sjjfouwk47p7mdwdzp1fq4ns
X-Rspam-User: 
X-HE-Tag: 1772220655-684765
X-HE-Meta: U2FsdGVkX1/q2BDPmrU/KfrBwBD9zAkLGk0WOT3+pJJ0wZhrVhc3IrZYKMd0FU8Rxw3kB7kBCv/poM13bJD6wYm2JvdNNfv3KBe7OqaQR1e4jpkBfX1/7wVnZgmSh2IWiKm1ulRBYo3EP+DNDtYwXG0iT1cmJBHMPP3pZNoYWfjyreNcF+rRo8/znbdAsthJt8cPWg4DPs3DGDPrshC/o+H8RwBg8UyNlD/07vlTRb/3J4747SkbeTnyy2sp+8+UJXD4DCtnu0zCpiNHCbMhkAv7M0yFTr/gecbW9rJyp63KLL7684qXrlba6r8iV4gAu75gBJmGWLpCn49klJtQ7wxTEXeS0Ut3MlQcZvPAD/e02SCkFQhMSlWfUrf5K0bLHXW6RmKOHUaT0rWbqv8hclDKM4cWOB0U7gMh635zy/RTvRmQPG1Z0cVMedujNfVAXu6TsdKGizhuNMZxmy1nvM633Ylv71AvfbWvwiYBA3tteYN24gnPfXS0p1s6Ihrktszn1rCvvmTrStUU/g9Jaj5iByeRQQ2Qqc8CtC3z4EQIzK8oZO3qKtJ0fFmunYtRL4qDxOPldV3AfHSt/eQDRJizcigNWiDsufzfAUJzRiSy9qqshZkqfDfNk0MMYT92aPQnp+hLkpeIfKrPJUFK+4HmXezpYcXgXgte/Ak4SJ8sj85k9JWBWa9WAmjl5x+ur7mLCYwnqJWLrH5E8rLBNV9ZQBCOIBZVxIzEfH1DCIed/B13kikCH02RgWi1tfkVHPqpGOIGd0nPrCSS6C6sFXhtxcT7V/yWQULVLC5JrwYRK1xJJbH/uVBv3LfEgfGCoJzbAOkymt/m1w3pxV3aCfHNepP9OKLDGAt5amEKmOeWKzp2uREtveOYR7caxJVeFdRULEBLBNIs92SfDxxvIKwFO0exmoAUhmEhcwuS0ADGLCDN93Jt6rhZODA1GMn7VvIRqTUJePa8b34gD5T
 z4y7gtVC
 zYkoVcW45Hmf/RaTSlM3TM7xK9nbXi5wtE2g9yzww5OOgKX1RogoTpehV+9jDJwtBW7LFe/SUDosy5hnMoVN5ESnTdOkv7X8tN8/Wp9rT6IRcnN2FC3NrRA2D7ZuwiuVgYhPve+EssTwhhGtnDgzVcigE2tWNv+yQ8W+eQpc/TbZFQsLbJ34wwUmkJt2pC6I4HEE3TqC0I++3soJ3BPB6UOXEm1ozShXkyWcuJ/pyNbv3VzeZRlMPSz70J6jGFOmmOO23
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


