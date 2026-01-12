Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA81DD2502E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 00:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269206B008A; Sun, 11 Jan 2026 19:49:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230DC6B008C; Sun, 11 Jan 2026 19:49:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B956B0092; Sun, 11 Jan 2026 19:49:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E2B816B008A
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:49:33 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 723E61AF18E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:49:33 +0000 (UTC)
X-FDA: 84321478626.30.251C7F8
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id D2173100003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:49:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Jzvlm9e+;
	spf=pass (imf14.hostedemail.com: domain of 3GkVkaQgKCIcutl1t9lyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3GkVkaQgKCIcutl1t9lyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768178971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwmWF2Bg3a4xbvi54Ji/t7adbofzJTtZzLagbDRk3qs=;
	b=PYn0ct5mbfkxkGaS4MFbZ/Q/7F16GLk4e9rAGGVWosFKHHmda7LuAc6/m7Fl6Te7s3LGVt
	CeDM5pNKsZIRSZo2WvmrpBRZ8XfyRdnXNmXmMpZ/FpoI4UZoz00AhQykL5WRwUkkdY20eo
	pXb3P0Gr4m6mhWLb6LLk01ir9B7blLo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768178971; a=rsa-sha256;
	cv=none;
	b=SSEdFA4trhiKSYY5K7Huke+NJUCJk98YECOfDbjzWygWxM1uLY/f+SPPu7rLL5zTFWuc+K
	tQvgk/5Exq6ac3UeRh02rgeXmIu6eOnKL/IQ5/9uMP5xxJYWs/3og6EFMqXbBja2sxbe5C
	UQFE0jZSGtT1hCFW/H/T8IQVGqdT1nw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Jzvlm9e+;
	spf=pass (imf14.hostedemail.com: domain of 3GkVkaQgKCIcutl1t9lyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3GkVkaQgKCIcutl1t9lyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a13cd9a784so52203575ad.2
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 16:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768178971; x=1768783771; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uwmWF2Bg3a4xbvi54Ji/t7adbofzJTtZzLagbDRk3qs=;
        b=Jzvlm9e+A5GW6tgg+PubxecuMYaoAbVnVbEQgTYJFZ1tSxKRwrWr3h0DkT1IBcLbFs
         pKQn3QXxxh3G/xcLu20ix8PSilZIl0BEOaVTcUcPlh4/+fbFKkiPU+BNEmF6fZKZKu8r
         CqJNjeWrLxXXJyNUEY0nIYhbMSYVIB1mMYOFE5BnI7ZaeSCsKuGWc7WXJyZkqGBlGtYC
         sVZ111MptVOoteE+iRELUDrW8/wGRlFW6S5tZumkXDMqfggX7LwIu6LUsJf2P45baFPd
         KQTG3kDB++KBojp6m2WcazrA4RgB6HOMNWKNJMSmMfe9AVhsdLRfne6Sf6Ork37o8KAO
         +qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768178971; x=1768783771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uwmWF2Bg3a4xbvi54Ji/t7adbofzJTtZzLagbDRk3qs=;
        b=hND7jedzH9sTUVjh6VVTJ4A7KvnVTNfPX0ZjRPjmaBH38UF2ixXaZoLUjubWEfa0EK
         MWp6cJHLTVUhfJdEbhGLwadNTyFikLYyJZYLhTFwTeI8322453Qyb3nR2jo6mygBh0Vc
         M0BnT0EU/Punhc3q7krMmjY55zsIraH8heZqZ+pBgokxb9pC+fMYJnU+kXAVrqytDMXp
         6XUI4WHnfBetL9+xlaW6KeUqr18t+GKWqgBcGbfIiJEfHjrq1MgxsazHK/+VzfU8S1vA
         mE3NjIQGLlLgIUaU28FUO3RT+WK+baYxp8b3M+B7QuIrlgiapXnQ+wNjAOKG6J/Bs23o
         FQ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXZBh7hQV9dXC9aGiBumdrUcf/rZx5P0S59dhrmn2ZhdbEeK+JUBo8bMHIirKgnQi6ApkBWTFKatQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7X4U53SULSaeNrEfMuZ2CeNxK+Exr7nUbsvtyhox8sxtyx4Ye
	yhuAYfmRVYPHE2ocDBPRrEY1Ya2UmrBPDZ9vXldK6GjAMnHvuqpW9SRKYdQ80YQrR4wVp6ViK0C
	cJxK+Tew+kze+0g==
X-Google-Smtp-Source: AGHT+IFL3OjBX45+6Y4kyGYmIkZajwGcoQAeVv1gmRs2jlg58e65eo6WLqHWTKXBSZfAGu8Fskh2r/bvzC2oFA==
X-Received: from plde19.prod.google.com ([2002:a17:902:d393:b0:29e:fb92:99f6])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef49:b0:2a0:c1f5:c695 with SMTP id d9443c01a7336-2a3ee434048mr164800025ad.16.1768178970528;
 Sun, 11 Jan 2026 16:49:30 -0800 (PST)
Date: Mon, 12 Jan 2026 00:49:22 +0000
In-Reply-To: <20260112004923.888429-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260112004923.888429-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112004923.888429-3-jiaqiyan@google.com>
Subject: [PATCH v3 2/3] mm/page_alloc: only free healthy pages in high-order
 has_hwpoisoned folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2173100003
X-Rspam-User: 
X-Stat-Signature: omg9xpog7ou7xog95hu7ydsc4c1wira5
X-HE-Tag: 1768178971-362831
X-HE-Meta: U2FsdGVkX19fxRZqRR0+P5+qfk5WZGBq+bb9KP1uyKC2HNYLFv2DqjfJMBk9T0s8LsunNoFA9dEg3UawbbI5QD8Q/v5RwkvEx0iu/JiEAMdvSDldTRsJ8tij+Tr9gK+sg/civlzWh5T6SL04hdCrTfZiLO2lMmBbdJQBj/2JKzFJnZrJDkvbYMuBSddF+YGQhPr8bNN57ZrnDDPQgDteXTEGncJCV3uBTXEThGaWCIrp6Udc4P7mUUPf9wnHEe4BFo+cXIZLzdoNhwREvnXvH9/IkcLq+mGqiq1s0yAzr1/0tVOD+1V3Wgujm8c6Roy+m1XVnkbbhyeBaGpnNL+tyLoJkbLwxvur5jLcBUq6IzGE+SWFJbeoz3oAaIG4b/jKhQCoGs5xxdHwph58Y1fl7EZ7e3Hck1RWV4boHOA7BlNQuxbdV8azqVR8TPAMKsDxWiKwnwVQqy8B7S38KSr/+ZMd0f9W/WfHkl+J3BppqYWgHj+B1HuMvx/UgPg14DUphSW3SIwH3LAfIytPi3JMcnB6mLl4NtyP/xUDsVs+BGA8TaadBsl8qgW6Xhk4aRh/1vuf87/Vnxd5p3us7LlI9enhLPj4P8unfBQiqEsdXLTidiGHFKvqmvUTU2D6jQKZiesPxBA2Up66c3QFAc4lz19GT9s/c1QSnuQbriv83VI0rPYUtO7dVN3Zz9JqAKIAqszH2xxoddCpApSek8XbGqvJgGDUASSbTEkgQImnmI5Lgn+kICk6iSVbl+jBRXcD+mZIhJu8Zaj5T79Ps3OvXP98myrxTOTgLGovMGFeAd0fUKfK16Q8UdhHJf+a8QqYRxI6bNASWL69rtVyAO+6T5mSbXwddsnGZzlrWpLZYZAnBGoObt3R1nXuVKECTqfwlMqjnlvxE8s4gUHB11hsoN9mrFXdI/V6M2KpbEfYQFLsTaQZLePB22V5roj6iAhxC54pTU4yszRJ81pmj3W
 zx2HtOmj
 rkZ1XfpbupD5ygBvkAgWNitMz+DJ+m78Nf3UxialpcYQXqJBFDVCKVO5qNvvTjlLolCq/uLL6bLXIy8WFG8dVym1KoDroiVsy7gWh1Bzk0dymyZcxzfwfxpaj6SsWHtxqmCPBiqdY3muN+UfB5ieCOBDu8zlh5xK9q/Q90U/ZeR9yulICblT4eauCXKyUarWcyI2eK2CjfGXjXoF0NPm1MTQOfZbAdOCph/LiYFO9dCcJCGVkeRKXvZJL/GOtDc3ZvXLLaaZqFD7Zf9b/yK/VquYiRVuSknNa7vgsjLr7Lb9aGF4lidwM1GjyxOtws2EOn//jImmt5rgVzf/Qk8Elqqz2bzrJWdBmBpU55cbpX4OFHDHLJ5ust+gwk8sbxRKbrCrvgdouKT18AQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

One obvious way to avoid this problem is to add page sanity
checks in page allocate or free path. However, it is against
the past efforts to reduce sanity check overhead [1,2,3].

Introduce free_has_hwpoisoned() to only free the healthy pages
and to exclude the HWPoison ones in the high-order folio.
The idea is to iterate through the sub-pages of the folio to
identify contiguous ranges of healthy pages. Instead of freeing
pages one by one, decompose healthy ranges into the largest
possible blocks having different orders. Every block meets the
requirements to be freed via __free_one_page().

free_has_hwpoisoned() has linear time complexity wrt the number
of pages in the folio. While the power-of-two decomposition
ensures that the number of calls to the buddy allocator is
logarithmic for each contiguous healthy range, the mandatory
linear scan of pages to identify PageHWPoison() defines the
overall time complexity. For a 1G hugepage having several
HWPoison pages, free_has_hwpoisoned() takes around 2ms on
average.

Since free_has_hwpoisoned() has nontrivial overhead, it is
wrapped inside free_pages_prepare_has_hwpoisoned() and done
only PG_has_hwpoisoned indicates HWPoison page exists and
after free_pages_prepare() succeeded.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/page_alloc.c | 157 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a9646..9393589118604 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -215,6 +215,9 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 unsigned int pageblock_order __read_mostly;
 #endif
 
+static bool free_pages_prepare_has_hwpoisoned(struct page *page,
+					      unsigned int order,
+					      fpi_t fpi_flags);
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
 
@@ -1568,8 +1571,10 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (free_pages_prepare(page, order))
-		free_one_page(zone, page, pfn, order, fpi_flags);
+	if (!free_pages_prepare_has_hwpoisoned(page, order, fpi_flags))
+		return;
+
+	free_one_page(zone, page, pfn, order, fpi_flags);
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -2923,6 +2928,152 @@ static bool free_frozen_page_commit(struct zone *zone,
 	return ret;
 }
 
+/*
+ * Given a range of physically contiguous pages, efficiently free them
+ * block by block. Block order is chosen to meet the PFN alignment
+ * requirement in __free_one_page().
+ */
+static void free_contiguous_pages(struct page *curr, unsigned long nr_pages,
+				  fpi_t fpi_flags)
+{
+	unsigned int order;
+	unsigned int align_order;
+	unsigned int size_order;
+	unsigned long remaining;
+	unsigned long pfn = page_to_pfn(curr);
+	const unsigned long end_pfn = pfn + nr_pages;
+	struct zone *zone = page_zone(curr);
+
+	/*
+	 * This decomposition algorithm at every iteration chooses the
+	 * order to be the minimum of two constraints:
+	 * - Alignment: the largest power-of-two that divides current pfn.
+	 * - Size: the largest power-of-two that fits in the current
+	 *   remaining number of pages.
+	 */
+	while (pfn < end_pfn) {
+		remaining = end_pfn - pfn;
+		align_order = ffs(pfn) - 1;
+		size_order = fls_long(remaining) - 1;
+		order = min(align_order, size_order);
+
+		free_one_page(zone, curr, pfn, order, fpi_flags);
+		curr += (1UL << order);
+		pfn += (1UL << order);
+	}
+
+	VM_WARN_ON(pfn != end_pfn);
+}
+
+/*
+ * Given a high-order compound page containing certain number of HWPoison
+ * pages, free only the healthy ones to buddy allocator.
+ *
+ * Pages must have passed free_pages_prepare(). Even if having HWPoison
+ * pages, breaking down compound page and updating metadata (e.g. page
+ * owner, alloc tag) can be done together during free_pages_prepare(),
+ * which simplifies the splitting here: unlike __split_unmapped_folio(),
+ * there is no need to turn split pages into a compound page or to carry
+ * metadata.
+ *
+ * It calls free_one_page O(2^order) times and cause nontrivial overhead.
+ * So only use this when the compound page really contains HWPoison.
+ *
+ * This implementation doesn't work in memdesc world.
+ */
+static void free_has_hwpoisoned(struct page *page, unsigned int order,
+				fpi_t fpi_flags)
+{
+	struct page *curr = page;
+	struct page *next;
+	unsigned long nr_pages;
+	/*
+	 * Don't assume end points to a valid page. It is only used
+	 * here for pointer arithmetic.
+	 */
+	struct page *end = page + (1 << order);
+	unsigned long total_freed = 0;
+	unsigned long total_hwp = 0;
+
+	VM_WARN_ON(order == 0);
+	VM_WARN_ON(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP);
+
+	while (curr < end) {
+		next = curr;
+		nr_pages = 0;
+
+		while (next < end && !PageHWPoison(next)) {
+			++next;
+			++nr_pages;
+		}
+
+		if (next != end && PageHWPoison(next)) {
+			clear_page_tag_ref(next);
+			++total_hwp;
+		}
+
+		free_contiguous_pages(curr, nr_pages, fpi_flags);
+		total_freed += nr_pages;
+		if (next == end)
+			break;
+
+		curr = PageHWPoison(next) ? next + 1 : next;
+	}
+
+	VM_WARN_ON(total_freed + total_hwp != (1 << order));
+	pr_info("Freed %#lx pages, excluded %lu hwpoison pages\n",
+		total_freed, total_hwp);
+}
+
+static bool compound_has_hwpoisoned(struct page *page, unsigned int order)
+{
+	if (order == 0 || !PageCompound(page))
+		return false;
+
+	return folio_test_has_hwpoisoned(page_folio(page));
+}
+
+/*
+ * Do free_has_hwpoisoned() when needed after free_pages_prepare().
+ * Returns
+ * - true: free_pages_prepare() is good and caller can proceed freeing.
+ * - false: caller should not free pages for one of the two reasons:
+ *   1. free_pages_prepare() failed so it is not safe to proceed freeing.
+ *   2. this is a compound page having some HWPoison pages, and healthy
+ *      pages are already safely freed.
+ */
+static bool free_pages_prepare_has_hwpoisoned(struct page *page,
+					      unsigned int order,
+					      fpi_t fpi_flags)
+{
+	/*
+	 * free_pages_prepare() clears PAGE_FLAGS_SECOND flags on the
+	 * first tail page of a compound page, which clears PG_has_hwpoisoned.
+	 * So this call must be before free_pages_prepare().
+	 *
+	 * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SECOND.
+	 * Because PG_has_hwpoisoned == PG_active, free_page_is_bad() will
+	 * confuse and complaint that the first tail page is still active.
+	 */
+	bool should_fhh = compound_has_hwpoisoned(page, order);
+
+	if (!free_pages_prepare(page, order))
+		return false;
+
+	/*
+	 * After free_pages_prepare() breaks down compound page and deals
+	 * with page metadata (e.g. page owner and page alloc tags),
+	 * free_has_hwpoisoned() can directly use free_one_page() whenever
+	 * it knows the appropriate orders of page blocks to free.
+	 */
+	if (should_fhh) {
+		free_has_hwpoisoned(page, order, fpi_flags);
+		return false;
+	}
+
+	return true;
+}
+
 /*
  * Free a pcp page
  */
@@ -2940,7 +3091,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		return;
 	}
 
-	if (!free_pages_prepare(page, order))
+	if (!free_pages_prepare_has_hwpoisoned(page, order, fpi_flags))
 		return;
 
 	/*
-- 
2.52.0.457.g6b5491de43-goog


