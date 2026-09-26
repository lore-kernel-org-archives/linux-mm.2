Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 415E3C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4966C6B009B; Sat, 26 Sep 2026 05:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E7E6B009D; Sat, 26 Sep 2026 05:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383E86B009E; Sat, 26 Sep 2026 05:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DBFA6B009B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:27:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 818E21A0748
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:27:04 +0000 (UTC)
X-FDA: 85255384368.18.12B4872
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B5E3D140004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:27:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFGtdbcN;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790414822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUyFr1OfmXhgoSo4gzdF2ZgZigwrnK/l9YAOSrtW0JE=;
	b=ldi+b/CCbuL3hAgQdDu+js0RF8zI9MX5cnEx8nesmUmpEI3F8jCrOW1fA6v7myR9USGcYY
	LRiTo8dEHCgv/Luih1yhDyymuyWkwhwMyq0sU91pv2JG/mI9aEEzUDcyMjdQOUmZ87V91J
	ExtluZKRJnmsoA1KqFR/6g3ygGNw4I0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFGtdbcN;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790414822;
	b=e6tqr2DqfJozo3NyULygaHM5YuLWJJ2jeem1XTYMhfBuLL9rdvmZFyWloFDPw8hFQEYVgt
	B4yQ3MTuqG/iOxVq5KduaH93DUbPu2tI4b4XVe6b6qiENV5f/EEaUL+H3NRkWWecD3t1wr
	D0vGcdXzIg3KnyHqsOeoANljnvED9rw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15BC344782;
	Sat, 26 Sep 2026 09:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264D21F00893;
	Sat, 26 Sep 2026 09:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790414822;
	bh=gUyFr1OfmXhgoSo4gzdF2ZgZigwrnK/l9YAOSrtW0JE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oFGtdbcNSF/K7qXEKcO5Vwg393hxMt+J2c1yPvzMX5wj6v5k4XPJlv5WqhJuYOFLF
	 7UA82vQwg3lchbTjWvGhKqWXAfPSaFsKNB9OTA9w2rf4FocMdMUAT6CYOoNPyuD9sT
	 u/QdNImpqhTZKgzlfmnfwMO3QT1D5wlnHS+XhnZ2RzdobSeXpKMtv7u2WoFRMunAJ3
	 V+9UzPOnXWKSDM0My9Zw0Rsam6Ir1MRwWn+iaiqA39yYXT1gBzeBhBaiJnFpbdZqW8
	 h9eSbLpgl5rI8gk//bkiXhnz74HRHX6H3IVhxkE2IqSaZa4YzQAo7bMI+cfqr57spY
	 dXuDkCzF06GBA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 26 Sep 2026 12:26:32 +0300
Subject: [PATCH v2 3/5] hibernate: handle potential errors in
 hibernate_{map,unmap}_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-hibernation-v2-3-235f69f3ab2a@kernel.org>
References: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
In-Reply-To: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5E3D140004
X-Rspam-User: 
X-Stat-Signature: pbjbgjefrcpigzuqmq8rdwuf7kcxtza9
X-HE-Tag: 1790414822-32206
X-HE-Meta: U2FsdGVkX1/cypxrGJIYrtNdx5rVMj2vpchk2hQt0/qWKQ+B5wK5XTE6JYaM6cq9A9DPWmXpPqSpqXcfBpaU9yOWqSGFv7cP/mQqefKJzVCm2lMJ4NcqVmL/Sg37hgvoPo1nPr9riQtQMvD4hb30n4yixtVQkMSZF5phIbv5Cm7t69GC3ATrJwtbEmUccW+8XMGphHslwlU15NdpEczcKXyZe39uSvxhL9gdgbe2ic+OVXaV1WSMtIKz+1tzmmU4gqiiBMyRGEXdI95WjWFb20bs4qZDAfrYJILsv3pks3Z52BwfKwC+oEbM+VILMIPE6Dp9+Zx5f+eha3hC8yV3kjXKUsyL9Odeyu3V5OQMIwTyMWbpv8eUfF5ou0lTuPpacZTLM7mQr3q0snIGdswlwOcxsG34UvNUAl1LJHKRMBLCOs2qmXg7yKHMwOsBdvLMznJwIY1QwF9MUz+4oCGLihNrGQwhAfEi+fzbwJC+gv6QZAaNqV6e7fh55LrBYe8/vauRaxeDC14IsURsjncj/9JVKIMYs6KKjyv+22rUhfkHT/2bYqxJtgBk+MA0UzFQ84/dD8H6XRHzFmfTiEBZ5LzNBmDA6stXpHzuZMpHbd0JJLpF4ztxJA6I6rFKyTbddsWdPigJDjEPwxj8dg1rp+gkThXQgyZfQU+Xgh24psafOb0y4U0kLPSozNf/ht1ShVl4g9QZU4CBuHB/Mi+1E27Zn3kjKl1zdVKKOAQu8iXPD/WyA7uS/TBNUmy5ZyOq+ublA944ICF34qKej2QADvgzfNabyRLUiujh/R9y/kL2CwQ20VHYKo5kaUJHqXyjucA0N2NEAOdJnTMmSH+nUb9pVlOPisEXdzee4F54QM2K01gF6mxI2PuuJwzTD4tHsMGUMJe4J83AJBwAFn4QFa57mnBfu45Oxl//Igx8Xcz5bn6U1h26vJRZZC+ye/jiYZ+QRuMK4K2+cNMGXD3
 jSJPaQBI
 QehyspBwMWlmQFjiYPXPTbaxyH7x+AnamI/+t2C+zCx0U6b9c7NzbFXBhyKmNoHl+OZGqs9p+d1aASuKmJo/ieCRHVWmI+799OPIXALOzhRUa9a6kSQKyn0VNTS99hdi3+m8vf9YwDNKzDBRQJyljFCpVxyyuB76QdY7KYzDtfJoq0AdeXKqXlAtrj0vJ9hatrnflGAql5V3xobzMiugvuF/T2+2U4vpD0VaZn5+X6O3HmC9x7ZSHJ4At850UiNhtZquNxYsR005eHfwZWovU29f8kwWtS5PjJq/JOB/qwyBlh+g=
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
index e732bf6389e4..52ef0599c207 100644
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


