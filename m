Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEE5C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2896B009B; Thu, 17 Sep 2026 02:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B156B009D; Thu, 17 Sep 2026 02:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493156B009E; Thu, 17 Sep 2026 02:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AEB96B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:07:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89CB0A025B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:28 +0000 (UTC)
X-FDA: 85222222176.13.18EB613
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C04E2C0005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hfwRWZ5n;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789625246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdeE4ROmDNb4ihV9MLQcmwZeFwDitWjg3f1f4fxRfv8=;
	b=NDflMeFeEJCu2z8L/pLxTgKeHt33wMwklPYeh+pO78BXKrMGkyxE8SLRG49l1s05TMg2qd
	eaWuHSUB36m77h7G19HeTt8eGfciFQ0ohNN4nxtm6R56ualbrMDhJh4R513m7qaqf5RBh3
	s8ZMNPPkbOh16pI2MajUgQjrxQxkqJs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hfwRWZ5n;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789625246;
	b=YJmB/bs8F8XvV0LucBSAuUdi8hmQba3sC2pZPEsALTJVYQMNIDOYDLTZUcuohJ64OlUJ+u
	bPk1eAfZqFJYD7Qndd4PD2GJyTG2VZo+QC1+7Kme62bQKeMhOL//LrlTfaiQlbiYR2nlhP
	svW++xMHJjLXFGDDJfInWVMA1YsGCuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62D1560A55;
	Thu, 17 Sep 2026 06:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4FF1F00893;
	Thu, 17 Sep 2026 06:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789625246;
	bh=mdeE4ROmDNb4ihV9MLQcmwZeFwDitWjg3f1f4fxRfv8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hfwRWZ5n23bWhuT0S3T+MfKJw84apNiXIo3e+imvPYjhjNSd5qf64NMcc9+ylF6cM
	 6TdeYdyyvkRrVB+Y4B5ed4bBEZ/krm3nyE8VIXclOfJiglJBPVMi030KSv6mbGRlQb
	 cQFYDckmhlBl33SrWh0j2AWgSF+IYTVxsLJus5aWQgsAzWYRWiL7JPNN31fqLDNlDE
	 xNyUpCMJAq9SUR/sv4HSaukYHEHAa2ixZPW8KNbkXSOrYS19nLmrYrCnIbQe3lJoF0
	 /pwOYnGnPzEyfIPFN1TazbfBPFScShsSVcaYWU/Jy/1nqLLQPHFF598MBHoKlAHRfT
	 NiXJGh9WsmaYg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 17 Sep 2026 09:07:05 +0300
Subject: [PATCH 3/5] hibernate: handle potential errors in
 hibernate_{map,unmap}_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-hibernation-v1-3-7f7dfae3dbe0@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
In-Reply-To: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C04E2C0005
X-Stat-Signature: ydm6jnr6cjewtotitpr9m8mm8sydaoe5
X-Rspam-User: 
X-HE-Tag: 1789625246-598391
X-HE-Meta: U2FsdGVkX19uef9EcWl7u4WYjwERm01a+HGwnh0XlFtuEwXnoteRWra4YqBS4DSSgc5p4BI7aTOPbnYED3xoKTbg5bkEevkdKNhDui6SVTmUz7O1eOR+xQ9SrKbWMZCrOhQEb8GQz+W02hqbSBI/jxCm7S1lVytMsMDK2B4XaC67h40A/ZQrrlGWJrY45JecAtidlFqUti02N24CJabl48aTvg+8Vog1GhYqrLvK6+4zSY7jslOZgBkGw5EwY/dJ3J4U1fsviMt20UB1QhSlmf+W+9/AMU8vWBvL9ynny+mYmbclT3/7l6Ke00p2l7MxeesrA+w/vgbNFxQoUlSYSB8DRDd9VfRKcll/uzFIyx0RHWtYksy62HRBp4LbbyLOtu0YpLhRCCGwzWLj9+qM+hpPpb3jn6+y2XgppdSsqyieC/f8rkFXlbEj3Pp5vYe7ccq2QAFxarhjc1yfbtRLJX3peaeOUiRp936MzFLdWzxwKMZRzXoKf3EAbCkVzjW78dflCYW561Co6DevEvK2uwqBYZiDWbC3f6Op4BL4bMPiCWErZkgUDoqchaMKmQaWd9H5dcf6btuuzH05W+gt1SATIOd5r85ZmHZkm/Xjerf6FmJzvnTQ98mWNT/Kx40Ckx6fUdgIknQCe2yewmY/Mmdj4qYpi9przVbGj5k3o+TbTw3uLGq+AtBnIdHKgr17d6462v3TmDTrYeP7Y6BxvFHWthYR/vrHN/DejvIwwrUC/fhMwx8guNhbZrMZxjWXIfSRUmhrui/coKqBvQntmK8ujz3df0OlM5NDsgrxchgdag7cJERjkzABY6LHdgV7cNE9R6c0EWmh/kTzF4eEmJyFmjSHTAanHD1CCx9eLb2siGwLMJEqApB35eNmsOHxR+upakVQT8T9Q2H4re47hM1D21NCRfO0JwxSQA+KTDpznJXeMZ5Q0O/c/XYPRpiYRZPUC9VcBy/GTdU/4WR
 cCPsK/J6
 0FyRIw0KF9/gYmzkqlTD3n9Gaaclir3cSLhb3VBE+Ta5XEQmDmewLRa5cMAJ4MGQRjw7+0unUqQ7TRPp4jN1Luysz/qq+B4rNxJPLfDjTyr4ZHMNtVP3zSYHE4OP6iY24ChzOatmvLVTCBtmH0f0EV3iF50WFwU9RjJyWmLcvVt4wGejv34WYFgm0yX61khVAbd+gSL9yCz1a9LrkRdYfUlsY3q6SlZPg9xIJRNhytGAsL9rMI7rVp2j7RpJlUo7IN7CVncrvJ3wx2DE6aVOCpATJsrsQ0LgXHFKY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When safe_copy_page() had to map/unmap pages only because of
debug_pagealloc() there could be no errors in the kernel page table
updates.

However, with the increasing desire to remove pages from the direct map
this assumption becomes a real stretch.

Properly handle errors in hibernate_map_page() and hibernate_unmap_page()
and propagate that error along the page copying path.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/power/snapshot.c | 102 +++++++++++++++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 40 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index e732bf6389e4c..52ef0599c2076 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -79,37 +79,30 @@ static inline int hibernate_restore_unprotect_page(void *page_address) {return 0
 #endif /* CONFIG_STRICT_KERNEL_RWX  && CONFIG_ARCH_HAS_SET_MEMORY */
 
 
-/*
- * The calls to set_direct_map_*() should not fail because remapping a page
- * here means that we only update protection bits in an existing PTE.
- * It is still worth to have a warning here if something changes and this
- * will no longer be the case.
- */
-static inline void hibernate_map_page(struct page *page)
+static inline int hibernate_map_page(struct page *page)
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		int ret = set_direct_map_default_noflush(page, 1);
-
-		if (ret)
-			pr_warn_once("Failed to remap page\n");
+		return set_direct_map_default_noflush(page, 1);
 	} else {
 		debug_pagealloc_map_pages(page, 1);
+		return 0;
 	}
 }
 
-static inline void hibernate_unmap_page(struct page *page)
+static inline int hibernate_unmap_page(struct page *page)
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
 		unsigned long addr = (unsigned long)page_address(page);
 		int ret  = set_direct_map_invalid_noflush(page, 1);
 
 		if (ret)
-			pr_warn_once("Failed to remap page\n");
+			return ret;
 
 		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 	} else {
 		debug_pagealloc_unmap_pages(page, 1);
 	}
+	return 0;
 }
 
 static int swsusp_page_is_free(struct page *page);
@@ -1449,21 +1442,25 @@ static inline bool do_copy_page(long *dst, long *src)
  * Check if the page we are going to copy is marked as present in the kernel
  * page tables. This always is the case if CONFIG_DEBUG_PAGEALLOC or
  * CONFIG_ARCH_HAS_SET_DIRECT_MAP is not set. In that case kernel_page_present()
- * always returns 'true'. Returns true if the page was entirely composed of
- * zeros, otherwise it will return false.
+ * always returns 'true'.
+ * Sets @zeros_only to true if the page was entirely composed of zeros.
+ *
+ * Returns 0 on success, a negative error code on failure.
  */
-static bool safe_copy_page(void *dst, struct page *s_page)
+static int safe_copy_page(void *dst, struct page *s_page, bool *zeros_only)
 {
-	bool zeros_only;
+	int err;
 
 	if (kernel_page_present(s_page)) {
-		zeros_only = do_copy_page(dst, page_address(s_page));
-	} else {
-		hibernate_map_page(s_page);
-		zeros_only = do_copy_page(dst, page_address(s_page));
-		hibernate_unmap_page(s_page);
+		*zeros_only = do_copy_page(dst, page_address(s_page));
+		return 0;
 	}
-	return zeros_only;
+
+	err = hibernate_map_page(s_page);
+	if (err)
+		return err;
+	*zeros_only = do_copy_page(dst, page_address(s_page));
+	return hibernate_unmap_page(s_page);
 }
 
 #ifdef CONFIG_HIGHMEM
@@ -1473,18 +1470,19 @@ static inline struct page *page_is_saveable(struct zone *zone, unsigned long pfn
 		saveable_highmem_page(zone, pfn) : saveable_page(zone, pfn);
 }
 
-static bool copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
+static int copy_data_page(unsigned long dst_pfn, unsigned long src_pfn,
+			  bool *zeros_only)
 {
 	struct page *s_page, *d_page;
 	void *src, *dst;
-	bool zeros_only;
+	int err = 0;
 
 	s_page = pfn_to_page(src_pfn);
 	d_page = pfn_to_page(dst_pfn);
 	if (PageHighMem(s_page)) {
 		src = kmap_local_page(s_page);
 		dst = kmap_local_page(d_page);
-		zeros_only = do_copy_page(dst, src);
+		*zeros_only = do_copy_page(dst, src);
 		kunmap_local(dst);
 		kunmap_local(src);
 	} else {
@@ -1493,23 +1491,29 @@ static bool copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
 			 * The page pointed to by src may contain some kernel
 			 * data modified by kmap_atomic()
 			 */
-			zeros_only = safe_copy_page(buffer, s_page);
+			err = safe_copy_page(buffer, s_page, zeros_only);
+			if (err)
+				goto out;
 			dst = kmap_local_page(d_page);
 			copy_page(dst, buffer);
 			kunmap_local(dst);
 		} else {
-			zeros_only = safe_copy_page(page_address(d_page), s_page);
+			err = safe_copy_page(page_address(d_page), s_page,
+					     zeros_only);
 		}
 	}
-	return zeros_only;
+out:
+	return err;
+
 }
 #else
 #define page_is_saveable(zone, pfn)	saveable_page(zone, pfn)
 
-static inline int copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
+static inline int copy_data_page(unsigned long dst_pfn, unsigned long src_pfn,
+				 bool *zeros_only)
 {
 	return safe_copy_page(page_address(pfn_to_page(dst_pfn)),
-				pfn_to_page(src_pfn));
+				pfn_to_page(src_pfn), zeros_only);
 }
 #endif /* CONFIG_HIGHMEM */
 
@@ -1517,15 +1521,20 @@ static inline int copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
  * Copy data pages will copy all pages into pages pulled from the copy_bm.
  * If a page was entirely filled with zeros it will be marked in the zero_bm.
  *
- * Returns the number of pages copied.
+ * Sets @copied_pages to the number of pages copied.
+ *
+ * Returns 0 on success, a negative error code on failure.
  */
-static unsigned long copy_data_pages(struct memory_bitmap *copy_bm,
-			    struct memory_bitmap *orig_bm,
-			    struct memory_bitmap *zero_bm)
+static int copy_data_pages(struct memory_bitmap *copy_bm,
+			   struct memory_bitmap *orig_bm,
+			   struct memory_bitmap *zero_bm,
+			   unsigned int *copied_pages)
 {
-	unsigned long copied_pages = 0;
+	unsigned long nr_pages = 0;
 	struct zone *zone;
 	unsigned long pfn, copy_pfn;
+	bool zeros_only;
+	int err;
 
 	for_each_populated_zone(zone) {
 		unsigned long max_zone_pfn;
@@ -1543,15 +1552,21 @@ static unsigned long copy_data_pages(struct memory_bitmap *copy_bm,
 		pfn = memory_bm_next_pfn(orig_bm);
 		if (unlikely(pfn == BM_END_OF_MAP))
 			break;
-		if (copy_data_page(copy_pfn, pfn)) {
+		err = copy_data_page(copy_pfn, pfn, &zeros_only);
+		if (err)
+			return err;
+
+		if (zeros_only) {
 			memory_bm_set_bit(zero_bm, pfn);
 			/* Use this copy_pfn for a page that is not full of zeros */
 			continue;
 		}
-		copied_pages++;
+		nr_pages++;
 		copy_pfn = memory_bm_next_pfn(copy_bm);
 	}
-	return copied_pages;
+
+	*copied_pages = nr_pages;
+	return 0;
 }
 
 /* Total number of image pages */
@@ -2112,6 +2127,7 @@ static int swsusp_alloc(struct memory_bitmap *copy_bm,
 asmlinkage __visible int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
+	int err;
 
 	pm_deferred_pr_dbg("Creating image\n");
 
@@ -2133,7 +2149,9 @@ asmlinkage __visible int swsusp_save(void)
 	 * Kill them.
 	 */
 	drain_local_pages(NULL);
-	nr_copy_pages = copy_data_pages(&copy_bm, &orig_bm, &zero_bm);
+	err = copy_data_pages(&copy_bm, &orig_bm, &zero_bm, &nr_copy_pages);
+	if (err)
+		goto err_swsusp_free;
 
 	/*
 	 * End of critical section. From now on, we can write to memory,
@@ -2149,6 +2167,10 @@ asmlinkage __visible int swsusp_save(void)
 			   nr_copy_pages, nr_zero_pages);
 
 	return 0;
+
+err_swsusp_free:
+	swsusp_free();
+	return err;
 }
 
 #ifndef CONFIG_ARCH_HIBERNATION_HEADER

-- 
2.53.0


