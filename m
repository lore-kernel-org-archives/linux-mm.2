Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D037E73165
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 19:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE81A6B0088; Mon,  2 Feb 2026 14:41:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C196B0089; Mon,  2 Feb 2026 14:41:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88AE16B008A; Mon,  2 Feb 2026 14:41:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79C816B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:41:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F619160147
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:41:34 +0000 (UTC)
X-FDA: 84400536108.24.12827CF
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D86B180014
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:41:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="W4p3/FLi";
	spf=pass (imf24.hostedemail.com: domain of 36_2AaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=36_2AaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770061292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZShtbIIWDK79DIJSdgH4MCTg+L7wrJtfNmBeLFqVIo=;
	b=I+IP2p2Ztu+XaVaacY4sMIsPO3TeNiJFogY5Pdc246ZpTMkXw0ABQomBckfGn0fZysgf20
	12OLc1LRUeoSUNmD2FnYD5HPn05Xd9sfGT9eDMQx0Z4qSsS5fpXeejuWRNzXYHgYNuTzwY
	Nr8dbkrFnn9HzqPfzQekjYl1mOG6nzY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="W4p3/FLi";
	spf=pass (imf24.hostedemail.com: domain of 36_2AaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=36_2AaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770061292; a=rsa-sha256;
	cv=none;
	b=7jdTzK8nmjJIKaMPx3dR6pqdfJ9WDhHGivU6GmGuBTBM01hdB//sbGa8tezYUezbRsQthZ
	SECRY/G32kx/WUIQxRTrkcxtR1Mmz1WBqlL/AZkhJLBaifmedPeZAciUW5Cp9UWImE/uiT
	v+J+cHYR0xbhfEe/lg2Bqa2CUPSdW+U=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c68b97c0adeso48107a12.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 11:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770061291; x=1770666091; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zZShtbIIWDK79DIJSdgH4MCTg+L7wrJtfNmBeLFqVIo=;
        b=W4p3/FLitn1uYZXlTLEpQLRcZPxgkZ4hu7SijFTsQtGNiTBDWVit8CCOz/3Zb4JAMy
         iEvYj5vmMN8G4s3AC6hj8TELlklIL3lQg0TlBS6uL+/rQJMAZELvEK/K+L74Z+0vQqD2
         C9cwUh3APBApa2SieJjF2dNaZ+JXkw7FxkSr/jgwAwkhwpCmNGRIzJZNQ637blFN8TOg
         xJ+oxRorQcfNBuZz+Tl5uD9QlIr8mPiow0S6oQld94cPQ8IFWBj3Kwe4grFJhhM5i2mm
         Fzloog88KMFvrYlXE5Ic7grP7PmMO5BA45J0jRGNrsww1k5kaQ4XF/URik+uCkZ8m6+D
         dWkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770061291; x=1770666091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZShtbIIWDK79DIJSdgH4MCTg+L7wrJtfNmBeLFqVIo=;
        b=nshGbejcuqnaCQ3q4FUlWo+BtlSVMflOjwZqQKseqbuHrUbqcTvaIwgAbN+UOfcp0v
         URXOZFJYRxC6C8H3Or1vqpRqay1FAOsIWFzaTch6T4zHsYDs+nyPeYA9T0V8y1A0fcD5
         gC/aexTV3E8Z0tWkdwFlSgOHZwgin37k+8b6om4TlIDeq4+Uz9L2hQyJ0+OMZ0G0B6Xp
         q44gmlFpryVNvIMwxcX8K7FSwYNhg4QJT8GWywieczqCvA4wtpW3jWnLSFt9PitXPkwL
         hTfqeLfXJravtnC7tm6T8Zrw+5DVdMdpB7G3OV9AYCuSxetiQrKe+oMrWqAJlD94Ax85
         WyKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSL+WUtSzy6+1S8oSzs0/iRtZzX2zjR2WtfN271aj0gODv2rHr84fr+S1YPuafyDkjxAbYo08bLA==@kvack.org
X-Gm-Message-State: AOJu0YzXy3fcqHxUyCQbtDNp72E56kTVqj059T1q/vaDcjywxydvvPZH
	fE2obWejVk3gkjok9MOYLxO+Rg2Rz37RVRtaWAvxQjCObmQYwG2k9hZoGM+a2GvHimybB8mBZZK
	EUpCmLnb04c98mQ==
X-Received: from pgbfm9.prod.google.com ([2002:a05:6a02:4989:b0:c63:555e:ebf4])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3a41:b0:364:14f3:a5b with SMTP id adf61e73a8af0-39355ee41f2mr482485637.2.1770061291047;
 Mon, 02 Feb 2026 11:41:31 -0800 (PST)
Date: Mon,  2 Feb 2026 19:41:23 +0000
In-Reply-To: <20260202194125.2191216-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260202194125.2191216-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202194125.2191216-2-jiaqiyan@google.com>
Subject: [PATCH v4 1/3] mm/page_alloc: only free healthy pages in high-order
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
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5D86B180014
X-Stat-Signature: me3gro464tf7cpgegmom48ujgbo1xoi4
X-Rspam-User: 
X-HE-Tag: 1770061292-266457
X-HE-Meta: U2FsdGVkX1/7EwwPXEDHkCmkzDmCjiqvJOMYSrkqL41txNpz9VvZS+3qJOIQxL4GJUneHpbzU9jTkE12rocTRouawJsv2jJnJFILOXps/4OuO4o8+H2aO+0ZzMRpTMMGCBiBN+K8dzRETZJ19+NimvHLL2KmVKE5B7hsyq2Xlna+MTb+VJ2fRjgYPb4q0TB6aDxmm7VsRIndDL8tk34fBlFwXpxiOPo2qPKtlvZRJNsChJQfhTGMFt/54BTsnzQxst4OcqQhKE9Myr54WnTBj78x+ES7Pd6CGjNO3q6I/TXOeCU8BjIAZBF+s8Z++VfsHasj7UcBdrL1rzlHA12D2lRZJ/fnktMiaLDA9MFw+g6NQj5hLgeQYpO67ADfUwpGZ2EHbYQ2ccHdyzejiKnZ2/5qbZdV6zB7ZqXOW3CNyz7VITHtiNt86O90PRrJS5fLegaLSuCNyabuy4YtFiIyzxAs/2wS62+/Ir3qIfY6INYk+Y5XkK3NGSVLADlqxicP9a9jm95Nd2wLXoYAn69WseI4Rj/cibFaagXu09uRg0FE1iqxiy256jlCIIQ7zc/nJsYfnTWr9WFWXKVKi4aHCHIpSdFMIr7m8+xlWF44JUI+ckBwh8El3XRsdDSXTbDAuDVgx5Gm8nYj2PmjlyL9Sz0M7/ykEXifJy9Ltt1up491eMiGxpFdHgXyNFYwa1tSkla8TepbCeV2lctkmVILmUhe04Q5DoRpkBlEfPJsYlF3w3ZQBWBqRR0oEYhQMHGMHJnWvwGYU1nkI4Vt7uc4YEw0pboUDOtvoCycsVXsBdMZAd4Mz9uqaWxIuMWcKVUii9ZTTvgaYMDaAlDv+ytXq6GrgTrwngc2JhmC+Jh9lXHWnJ+hmiqsel/e0jsycOUWUfuPb9RQImHnfqUlF0UT3su6DLwqvRdFSbZIoDMI1HZcd6gPqy5uM6UJnYQdvyvhnJ9uJl9rgNXTjnKqqKZ
 6RMdWNqp
 UNpTNLsuut5kc0/FsqIVcUMaNzmiI5H0ORfpb3/O+OoDbEaaxnbzTbRCireBxP+62/pAYzWb2sCNkx6KV6cWOxTypqfyQIAEKes8EXV5QiFjcwnxD09qSBxG37Ic3NxxvDeF00TCxkLEwoiVwBiuKF4YaxUmXibp4++a6lRGZ/HkBGNaBxuuu5Cy2IH+3Yr3kcEKsUNMJzgGbcd0Ass0bqFVYpgzWXva5tyblwfT//cL/66K7b3A3PJE3cRkwcrJHGlDLBXMtgIrEUxmUHodRZX/SUzs4WOJFPcLMG5JttxSeP9IC6TwM7bSOKTD6p3k3pmsMhim7QB38QzlqHA3GuTCv7FXUYPCeWNGlrvwq8pI6sOgf0lN+nwIkzGaY9nNAwHvVu9BFqTXwQK+Zdj+9aEUo4wqgaEKLVMNK3uav1EBUsDLXlXD+meeE/zdQrehj77+wZEUQPrxGiziXGRFCKHvypDYKZWjxr0Ae+ufQNzuthUHOOQXxSGKaVkvLvId2T81qATo92xgGDOf/zueOwpj4SS9CSzdFF4ALrtpq6wT5JdufOW9JIFbyRV5IsIZk4M01YlM3I9zCn8hcq7OCxYrw6Vrc5QNI5nHXdCoc82InLrdsS8gH9KNQHWqAXk/yNj72N0GGh+6cglE7D/LJ5evoa6gJCxQgxYp+U80rFNzXZIGbiLRsZvzKiXicQB6Dimr0sqYegfL5MLKL0tujfHwQEobmbsc8NNqBsPtqPytRMZ/bSS7SNutIupFBZjWt4cCe
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
added to free_pages_prepare() as a shortcut and is only done
if PG_has_hwpoisoned indicates HWPoison page exists and
after checks and preparations all succeeded.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/page_alloc.c | 133 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 131 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cbf758e27aa2c..d6883f1b17d95 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -242,6 +242,7 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 unsigned int pageblock_order __read_mostly;
 #endif
 
+static void free_has_hwpoisoned(struct page *page, unsigned int order);
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
 
@@ -1340,14 +1341,30 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
-__always_inline bool free_pages_prepare(struct page *page,
-			unsigned int order)
+/*
+ * Returns
+ * - true: checks and preparations all good, caller can proceed freeing.
+ * - false: do not proceed freeing for one of the two reasons:
+ *   1. Some check failed so it is not safe to proceed freeing.
+ *   2. A compound page having some HWPoison pages. The healthy pages
+ *      are already safely freed, and HWPoison ones isolated.
+ */
+__always_inline bool free_pages_prepare(struct page *page, unsigned int order)
 {
 	int bad = 0;
 	bool skip_kasan_poison = should_skip_kasan_poison(page);
 	bool init = want_init_on_free();
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
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
@@ -1470,6 +1487,16 @@ __always_inline bool free_pages_prepare(struct page *page,
 
 	debug_pagealloc_unmap_pages(page, 1 << order);
 
+	/*
+	 * After breaking down compound page and dealing with page metadata
+	 * (e.g. page owner and page alloc tags), take a shortcut if this
+	 * was a compound page containing certain HWPoison subpages.
+	 */
+	if (should_fhh) {
+		free_has_hwpoisoned(page, order);
+		return false;
+	}
+
 	return true;
 }
 
@@ -2953,6 +2980,108 @@ static bool free_frozen_page_commit(struct zone *zone,
 	return ret;
 }
 
+/*
+ * Given a range of physically contiguous pages, efficiently free them
+ * block by block. Block order is chosen to meet the PFN alignment
+ * requirement in __free_one_page().
+ */
+static void free_contiguous_pages(struct page *curr,
+				  unsigned long nr_pages)
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
+		free_one_page(zone, curr, pfn, order, FPI_NONE);
+		curr += (1UL << order);
+		pfn += (1UL << order);
+	}
+
+	VM_WARN_ON(pfn != end_pfn);
+}
+
+/*
+ * Given a high-order compound page containing certain number of HWPoison
+ * pages, free only the healthy ones assuming FPI_NONE.
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
+static void free_has_hwpoisoned(struct page *page, unsigned int order)
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
+			/*
+			 * Avoid accounting error when the page is freed
+			 * by unpoison_memory().
+			 */
+			clear_page_tag_ref(next);
+			++total_hwp;
+		}
+
+		free_contiguous_pages(curr, nr_pages);
+		total_freed += nr_pages;
+
+		if (next == end)
+			break;
+
+		VM_WARN_ON(!PageHWPoison(next));
+		curr = next + 1;
+	}
+
+	VM_WARN_ON(total_freed + total_hwp != (1 << order));
+	pr_info("Freed %#lx pages, excluded %lu hwpoison pages\n",
+		total_freed, total_hwp);
+}
+
 /*
  * Free a pcp page
  */
-- 
2.53.0.rc2.204.g2597b5adb4-goog


