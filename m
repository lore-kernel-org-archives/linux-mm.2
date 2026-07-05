Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C93CFC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 18:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892AD6B00A3; Sun,  5 Jul 2026 14:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843E66B00A5; Sun,  5 Jul 2026 14:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3DE6B00A3; Sun,  5 Jul 2026 14:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25F3E6B00A3
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:07:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E9681A018D
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:21 +0000 (UTC)
X-FDA: 84955505082.13.0F75A5D
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id E0CD31C0003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jN9dsy60;
	spf=pass (imf18.hostedemail.com: domain of 3Vp1KaggKCBU43vB3Jv819916z.x97638FI-775Gvx5.9C1@flex--jiaqiyan.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Vp1KaggKCBU43vB3Jv819916z.x97638FI-775Gvx5.9C1@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783274839;
	b=EESqa6OKTXIuxaMH3EI/WI4IxJkoXXI9bzMjoSEDel+kMlUg4krWd0rM2TUizk1HrgAcoR
	uFqVXYXLu3sDrurR5v2rItSX5Pj73BJQ+YszHAqsWkNU2cjkqPK2ESGo76jewZbDtqAYwi
	fU2nWAqdW+BfhhrjZxVUDEeQocS94ok=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jN9dsy60;
	spf=pass (imf18.hostedemail.com: domain of 3Vp1KaggKCBU43vB3Jv819916z.x97638FI-775Gvx5.9C1@flex--jiaqiyan.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Vp1KaggKCBU43vB3Jv819916z.x97638FI-775Gvx5.9C1@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783274839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upjdyuafeoM/p5Q7ncoyynDvXfyTU3KBZKf2d2jqt/E=;
	b=8hYEe+rm42LtaN+5BvTMNnue9q6DKK2X8yJ7CLSHxSdPtBTihjZQXEbAhpFUAgvrpK9qaJ
	8xAzue2KOhW9XxWZj4qbBoXZm4nLaNOpyKx2QXNILFy52kOmOntKi9ZAeQfa6U2tm0sfV1
	PQm4lsFgGggTkrkDa6Y6sBx7xsZRmv0=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8894570b58so1549222a12.3
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 11:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783274839; x=1783879639; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=upjdyuafeoM/p5Q7ncoyynDvXfyTU3KBZKf2d2jqt/E=;
        b=jN9dsy60lUJ+6jjRQ4bI7Jn1EVrreUjT8fmuqNsTd45TjCOzGF+kUSca1rQulx8jVH
         gR1MgT3D9S1xuYEY6gkzd8MWEvFQbMKBVIlX4S2Exbe2A13xc0fiqHo9C9PSyySgRGQS
         qkkdCHXwXTUpdyHp+V3f1W/bEkrjSHLZiftpTBZDkMJtBu9+4Lct/MBFcNtAQlbLrAEI
         brKxXBZUKP3nNi3jgXM3NYxmsZ0ZWD8a1taMqPdv0TyhkJLIzUwCy70JHhbe8pYy3ajk
         1sLIzIaClqvMjIQpHJ61Qe9hbvGxNsrrU/PWrVL8b27ascbUatYsPZQzMA57I8VwCUgE
         kfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783274839; x=1783879639;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=upjdyuafeoM/p5Q7ncoyynDvXfyTU3KBZKf2d2jqt/E=;
        b=huL2k44bATUiWPwUml5/KR56/VG9sVzv8a3Ua6szcIbQcH/kF76vFIrtwSZ0Q3kigk
         TOkDc34ZAXhkvFWfGeUBBjfShYhnrsSwEAqZneLf3tpWkGCMcQ6dl/MT0sIu140Gj6rz
         gDlD7JpwSX6/7rVKd2lR9PTnnVEH4k1dGUeZpSY1uYPjwKvIlz2qxaa+dySt+MTtuLN5
         fLaMa4AdGk7Chk+/pGGECgSoE7CzUDxcIrg/Gdvt/9Nm1GscocdCpnuLEAKEHon57RN6
         oMdv4NSKqylmwBlQybTlbxIjJvizIjgoGelOgMQwqgODFYVRnttsaByBEVhs+3MS3pSs
         m/vw==
X-Forwarded-Encrypted: i=1; AHgh+RouptQZG/ErrF9NY+OGQwkFEMG2rIoagS1IehGXp+zwozRKR00sGFmxUPrqdDqA2iWaZOx9EgbGPQ==@kvack.org
X-Gm-Message-State: AOJu0Yxyd6I25Kt30FB6mEXNx+DquxDEz2SpAYFFp/yofHYGqHgSRNi0
	KdlUzLtScluTLHad0knlZIb43S0SPIGvYYlC0fZIwiPE34L73KwqKD/efVgr3WYOrtph+tFtLtS
	bGUTBsxLexUxUdA==
X-Received: from plbma12.prod.google.com ([2002:a17:903:94c:b0:2cc:9503:aa95])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2f8f:b0:2ca:5ced:6385 with SMTP id d9443c01a7336-2cbb9eba657mr66084895ad.23.1783274838575;
 Sun, 05 Jul 2026 11:07:18 -0700 (PDT)
Date: Sun,  5 Jul 2026 18:07:11 +0000
In-Reply-To: <20260705180714.3708947-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260705180714.3708947-3-jiaqiyan@google.com>
Subject: [PATCH v6 2/5] mm/page_alloc: only free healthy pages in high-order
 has_hwpoisoned folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org, 
	osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz, 
	rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0CD31C0003
X-Stat-Signature: 35en5zo7tknoj8j66gbngq4u8uwjisyu
X-HE-Tag: 1783274839-310814
X-HE-Meta: U2FsdGVkX1/KmaBYI9cs01FKEW5MBEXkeWg9gbWCkLLj6MrSPx10kWq9RHvHPAaWdGU1g83lk9LIc/mY02+YIrvslWVUc94NNJRxmlepxDtD7H0L3UueJZfkbvVCBF04dCADXriD4/+ckTBtrGuv+fOT5gyaw3a8iwcAndXXrbkpFDEnNQckMnyz13PTmDJTDsuFRCsJTxctQArxDJ1LLrrG9FasgciB7Pl3Ld/pUUqFwu4HgB3/kTI0HR0lf/zlgDyjju+5nbM8WljYCZT7VGUWX43LS38FXptLNRz0YqQuJXUFxBYcQxMoWzXhcb/Ncc2yzzBKBozfD2m7zDVyyFLwcDpQ7j/6dq18jc/O96FHFnbfwJIn/tKRtz2hU3h3NJQ8O8pQQTogXMdFgGpFOyQffkgrnxfVEigQrWMlmecYYYPektB6e6T9SVJGA3lpmg0nBTgfYbFpZAsum9DDvtR9iBJHeFmrxAB59usFbUUp0EQWGVmaZGthUA2uLhj5MPnBRM9MokE+6m7hEgVbLLwtVQK4IImeUyz3ak83+/DMT18AWCbm0WbParTNYMDhkK6lF0C9bphB9OVz4ukvuUk9ri1vuRjGrQiO7Yeex6JIbTaD5nrAR9NBECJfxmZ9/I2LptqWuYtSlGD9KQGy7WWWjmcn9VSnYTlfWsh526wBRjf5rbTnOi8f1QBrFQqaNLkVFhsvDadq1MDXdLFv2Uq4NzZ9UeSEWz/NNOCWHeh5ldBdgo5VIOEV0eKLLc+Pl4oSfHU7Z7E9r0AGunpmj/PiJVhYd+vHm1zvBpPJFslHpmhODlWSoQa0Bc2wwm7HfhygAQaZK6ZcP1wujF6AG7+pGBWB2u7dZtwlrCgwLGE/v4i8Riu7tmyB8+yVLO9bX31k7OalWWuTZFzgRGgRvgiO1KsuLOqP5qY8xpYHPRfcu8yn+4qcEJk3ITKtpX5I6TqYSR/v6+iMA9x6OTl
 mMNclaCD
 BwWX9ixu+cALXdPmz+flxqj1gXrZ2F8nNhc5UWYP03DHgYWK72l6HeeBO+AWR+6+THEjglJ/6k9NXurQb24zZDynIL2c5FFM9AyO4y9HgERvhPbFKYXc5hiOH/gPzJCVyz2Z3+1GxOCB4mCTD8ev+w3g3TyNoVGmN4qEGhPw89fyqIVIZev42qeOUaMNfaEfSWLpA+jXa2VY0FeY++vG+SirrcvQhYKwRIHNdZG6yxJmr5mwz7eiel7RDA/kMR9NC02UVQKPjJP5hWXDRxqkgnaN2Eednf29nhciVPZB3z5oYPhUP+cLHakf6oZ5izCOcP+ZEKdB3l9XjZnakRXcUfczLTV111UernGmUqOH8NhsBazhZardTEzmYTvHIF8QbIVgNum49luFJFmP0aAZBQjquLq7qsdXmfjEvf6FwrdaJ8ixz/E6BnBGfRtu7Rag9+Dpr0H7NRfepPSW0fJkoBuW6716PMAktVBZ1pxpEY+Nx9/8qjJqfv6hi9JWodZawjAbne5/EYy/eUxXBwLRu3MmFAuezxUQkgleu8a3ydqfgaL2inKWWjDW3LM2EsntSf8Xclp9esj44UZOwKN38f2xeZE8j4qg6cZoJz7WbbtWmAU5+0AOdhQ7hdOFEiKr2BZDPfBCu6hrMgyM+JTkZ45Xp85P707Mai0qg/8Hd8cyUy8/RsYlpADxX1bSYFGB927NuGBUey6cIiIWgS/JZCzZgwbUVnf7qZ0Bio9Ti1LO/T++JQmnIuhhgqWN/nKcVRfQH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
becomes non-HugeTLB, and it is released to buddy allocator
as a high-order folio, e.g. a folio that contains 262144 pages
if the folio was a 1G HugeTLB hugepage.

This is problematic if the HugeTLB hugepage contained HWPoison
subpages. In that case, since buddy allocator does not check
HWPoison for non-zero-order folio, the raw HWPoison page can
be given out with its buddy page and be re-used by either
kernel or userspace.

Memory failure recovery (MFR) in kernel does attempt to take
raw HWPoison page off buddy allocator after
dissolve_free_hugetlb_folio(). However, there is always a time
window between dissolve_free_hugetlb_folio() frees a HWPoison
high-order folio to buddy allocator and MFR takes HWPoison
raw page off buddy allocator.

Another similar situation is when a transparent huge page (THP)
runs into memory failure but splitting failed. Such THP will
eventually be released to buddy allocator when owning userspace
processes are gone, but with certain subpages having HWPoison.

One obvious way to avoid both problems is to add page sanity
checks in page allocate or free path. However, it is against
the past efforts to reduce sanity check overhead [1,2,3].

Introduce free_has_hwpoisoned() to only free the healthy pages
and to exclude the HWPoison ones in the high-order folio.
The idea is to iterate through the sub-pages of the folio to
identify contiguous ranges of healthy pages.

free_has_hwpoisoned() is added at the end of __free_pages_prepare()
as a shortcut and only if PG_has_hwpoisoned indicates HWPoison page
exists and after checks and preparations in __free_pages_prepare()
all succeeded. It then use __free_prepared_contig_range() to
decompose healthy range into the largest possible chunks of
different orders, then freed via __free_frozen_pages().

free_has_hwpoisoned() has linear time complexity wrt the number
of pages in the folio. While the power-of-two decomposition
ensures that the number of calls to the buddy allocator is
logarithmic for each contiguous healthy range, the mandatory
linear scan of pages to identify PageHWPoison() defines the
overall time complexity. For a 1G hugepage having 8 HWPoison
pages, free_has_hwpoisoned() takes around 1ms on average on
a system having 56 Intel Skylake physical cores. This is
15x to the case of freeing no HWPoison page. The cost is far
from triggering soft lockup, and fair for handling exceptional
hardware memory errors.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/page_alloc.c | 165 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 140 insertions(+), 25 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7d27aff48b15..6418896c9df6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -93,6 +93,13 @@ typedef int __bitwise fpi_t;
 /* free_pages_prepare() has already been called for page(s) being freed. */
 #define FPI_PREPARED		((__force fpi_t)BIT(3))
 
+/*
+ * Page(s) needs to go through free_pages_sanitize(), for example, because
+ * free_pages_prepare() cannot sanitize a high-order page block due to
+ * hardware error in some page(s).
+ */
+#define FPI_SANITIZE		((__force fpi_t)BIT(4))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -210,6 +217,8 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 unsigned int pageblock_order __read_mostly;
 #endif
 
+static void free_has_hwpoisoned(struct page *page, unsigned int order,
+				fpi_t fpi_flags);
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
 static void reserve_highatomic_pageblock(struct page *page, int order,
@@ -1311,14 +1320,73 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
+/*
+ * Sanitize, which requires writing, a block of pages at the last moment of
+ * preparing to freeing them, i.e. __free_pages_prepare().
+ */
+static void free_pages_sanitize(struct page *page, unsigned int order)
+{
+	bool init = want_init_on_free();
+	/*
+	 * __kasan_unpoison_pages() sets kasan tag on every tail page, so
+	 * it is fine to use should_skip_kasan_poison() when pages here
+	 * were a set of tail pages from a compound folio.
+	 */
+	bool skip_kasan_poison = should_skip_kasan_poison(page);
+
+	kernel_poison_pages(page, 1 << order);
+
+	/*
+	 * As memory initialization might be integrated into KASAN,
+	 * KASAN poisoning and memory initialization code must be
+	 * kept together to avoid discrepancies in behavior.
+	 *
+	 * With hardware tag-based KASAN, memory tags must be set before the
+	 * page becomes unavailable via debug_pagealloc or arch_free_page.
+	 */
+	if (!skip_kasan_poison) {
+		kasan_poison_pages(page, order, init);
+
+		/* Memory is already initialized if KASAN did it internally. */
+		if (kasan_has_integrated_init())
+			init = false;
+	}
+	if (init)
+		clear_highpages_kasan_tagged(page, 1 << order);
+
+	/*
+	 * arch_free_page() can make the page's contents inaccessible.  s390
+	 * does this.  So nothing which can access the page's contents should
+	 * happen after this.
+	 */
+	arch_free_page(page, order);
+
+	debug_pagealloc_unmap_pages(page, 1 << order);
+}
+
+/*
+ * Returns
+ * - true: checks and preparations all good, caller can proceed freeing.
+ * - false: do not proceed freeing for one of the following reasons:
+ *   1. Some check failed so it is not safe to proceed freeing.
+ *   2. A compound page has some HWPoison pages. The healthy pages
+ *      are already safely freed, and the HWPoison ones isolated.
+ */
 static __always_inline bool __free_pages_prepare(struct page *page,
 		unsigned int order, fpi_t fpi_flags)
 {
 	int bad = 0;
-	bool skip_kasan_poison = should_skip_kasan_poison(page);
-	bool init = want_init_on_free();
 	bool compound = PageCompound(page);
 	struct folio *folio = page_folio(page);
+	/*
+	 * When dealing with compound page, PG_has_hwpoisoned is cleared
+	 * with PAGE_FLAGS_SECOND. So the check must be done first.
+	 *
+	 * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SECOND.
+	 * Because PG_has_hwpoisoned == PG_active, free_page_is_bad() will
+	 * confuse and complaint that the first tail page is still active.
+	 */
+	bool should_fhh = compound && folio_test_has_hwpoisoned(folio);
 
 	if (fpi_flags & FPI_PREPARED)
 		return true;
@@ -1416,34 +1484,19 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 					   PAGE_SIZE << order);
 	}
 
-	kernel_poison_pages(page, 1 << order);
-
 	/*
-	 * As memory initialization might be integrated into KASAN,
-	 * KASAN poisoning and memory initialization code must be
-	 * kept together to avoid discrepancies in behavior.
+	 * After breaking down compound page and dealing with page metadata
+	 * (e.g. page owner and page alloc tags), take a shortcut if this
+	 * was a compound page containing certain HWPoison subpages.
 	 *
-	 * With hardware tag-based KASAN, memory tags must be set before the
-	 * page becomes unavailable via debug_pagealloc or arch_free_page.
+	 * FPI_SANITIZE to remember free_pages_sanitize() healthy pages.
 	 */
-	if (!skip_kasan_poison) {
-		kasan_poison_pages(page, order, init);
-
-		/* Memory is already initialized if KASAN did it internally. */
-		if (kasan_has_integrated_init())
-			init = false;
+	if (should_fhh) {
+		free_has_hwpoisoned(page, order, fpi_flags | FPI_SANITIZE);
+		return false;
 	}
-	if (init)
-		clear_highpages_kasan_tagged(page, 1 << order);
-
-	/*
-	 * arch_free_page() can make the page's contents inaccessible.  s390
-	 * does this.  So nothing which can access the page's contents should
-	 * happen after this.
-	 */
-	arch_free_page(page, order);
 
-	debug_pagealloc_unmap_pages(page, 1 << order);
+	free_pages_sanitize(page, order);
 
 	return true;
 }
@@ -6869,7 +6922,14 @@ static void __free_prepared_contig_range(struct page *page,
 		/*
 		 * Free the chunk as a single block. Our caller has already
 		 * called free_pages_prepare() for each order-0 page.
+		 *
+		 * If the original compound page has HWPoison page,
+		 * free_pages_prepare() has to skip sanitize at that time,
+		 * but now it is good time to do that.
 		 */
+		if (fpi_flags & FPI_SANITIZE)
+			free_pages_sanitize(page, order);
+
 		__free_frozen_pages(page, order, fpi_flags | FPI_PREPARED);
 
 		pfn += 1UL << order;
@@ -6956,6 +7016,61 @@ void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ false);
 }
 
+/*
+ * Given some contiguous pages that have certain number of HWPoison page(s),
+ * free only the healthy ones.
+ *
+ * Used at the end of __free_pages_prepare(). Even if having HWPoison pages,
+ * breaking down compound page and clearing metadata (e.g. page owner, alloc
+ * tag) can be done together during __free_pages_prepare(), which simplifies
+ * the splitting here: unlike __split_unmapped_folio(), there is no need to
+ * turn split pages into a compound page or to carry metadata.
+ *
+ * It scans every raw page of the compound page and causes nontrivial overhead.
+ * So only use this when the compound page contains HWPoison page(s).
+ *
+ * It also works when order == 0, regardless of PageHWPoison() or not.
+ *
+ * This implementation needs rework in memdesc world.
+ */
+static void free_has_hwpoisoned(struct page *page, unsigned int order,
+				fpi_t fpi_flags)
+{
+	unsigned long curr = page_to_pfn(page);
+	unsigned long end_pfn = curr + (1 << order);
+	unsigned long next;
+	unsigned long total_freed = 0;
+	unsigned long total_hwp = 0;
+
+	while (curr < end_pfn) {
+		next = curr;
+
+		while (next < end_pfn && !PageHWPoison(pfn_to_page(next)))
+			++next;
+
+		if (next != end_pfn) {
+			/*
+			 * Avoid accounting error when the page is freed
+			 * by unpoison_memory().
+			 */
+			clear_page_tag_ref(pfn_to_page(next));
+			++total_hwp;
+		}
+
+		__free_prepared_contig_range(pfn_to_page(curr), next - curr,
+					     fpi_flags);
+		total_freed += next - curr;
+
+		if (next == end_pfn)
+			break;
+
+		curr = next + 1;
+	}
+
+	pr_info("Freed %#lx pages, excluded %#lx HWPoison pages\n",
+		total_freed, total_hwp);
+}
+
 #ifdef CONFIG_CONTIG_ALLOC
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
-- 
2.55.0.rc0.799.gd6f94ed593-goog


