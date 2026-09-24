Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ABA8C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742476B008A; Thu, 24 Sep 2026 09:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7190B6B008C; Thu, 24 Sep 2026 09:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E586B0092; Thu, 24 Sep 2026 09:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BB026B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:11:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56CF41A035B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:11:33 +0000 (UTC)
X-FDA: 85248692466.14.7771392
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5D50C180015
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:11:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rKLdvoPc;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790255491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zk6BFyE9cxH5FPvrROnekEIJtqJ8w6b+qQigEsLIV5E=;
	b=dtgZqBTl15rPjB15+nDriJfcrHmEBcMBO/wbpp9bLNxQwO8UPJfNXXb9abqmZ8LK5aSew3
	VelcWldc07pYY9/ppsoB8LjgEIHpyDcxrnSdWYrXfDcfW4jFs4Lfn6Dv1hbHM9Om4VU0v/
	GUBxxhqsYVyUYBtY8CIsdY70fP5iGRE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rKLdvoPc;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790255491;
	b=dYvevL6QWBenX8vndkH6tJQODWpipHe7ZLdy8CfDr9zu7kpX8qyAhWIwOhFqUs4x7qaecw
	RCgJzM2fw0VCXgN+cp55jf7p79m+cKzRRejXdhclEHowZI3jvKyvSwVHKEZL+/tAi1bpXz
	2GulySkKThSMHOMyBtLHWxerAQ/JeAg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9BEF1570;
	Thu, 24 Sep 2026 06:11:26 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4170C3F86F;
	Thu, 24 Sep 2026 06:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790255490; bh=GBTBAttj6YqnCR/uq6LNIwfyQljyiydrN9JFyuIuVt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKLdvoPcWH10UQwc6ZxfGlsPCWitBVRMqBo/pDpRBjg7890TBpz/IEflern/JSchq
	 scRdr+IQOwuoDOtEZqFEUZ9GnAjXanwvxbjOPI0RB+K9XXhHdGFqrI4ustGAy6toDR
	 hYJKQANAFQgq2qEgHl6lsXUoC0oztWYTDxsY/FhM=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	jgg@ziepe.ca,
	thuth@redhat.com,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 1/9] mm/swapfile: add batched version of folio_dup_swap
Date: Thu, 24 Sep 2026 13:09:29 +0000
Message-ID: <20260924131106.1730494-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924131106.1730494-1-dev.jain@arm.com>
References: <20260924131106.1730494-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5D50C180015
X-Stat-Signature: e8xdrxjpimhk4j1h31r6mwzm4w9bow8j
X-HE-Tag: 1790255491-967434
X-HE-Meta: U2FsdGVkX1856TV6oqfbbmqbljcxzAf0s3jfOelm8zfJZTFWo06TKBbemmxyECeJiRBgySWE6DOyq2djeqM9AgTXXoU4obXaRQhS4TAov10JEI7G/UifaPfouA9rCRTj0DOLUfJ8tMBakw5+ovoFPO8FxTGHtHQWl5eJUN0EiFyUjqKpIGDF9PcBs4Uxgh5UbKkISvD9LqZLwPv+sXqEdaLC1cEtyCiT9oJq1NvbkUhiAGf6Vby/EAa1YGklAL1plZ5rOIMA6vh1u5Em+bmwafWC4AAMIRQ0a+8+djPOzmslZ6ZMI1CBPSsdFM1hDQdWpxRtZ+M16rCskristDK/dtUXbdf7+D4rzSvAM6VbTgfRAYZb+d2bnokkiZ8eNsGXvufF0Yv32+BN63er9P1mO19lm86mdoGCbxDqnXmUyu5hnymUEzz/3Nrvo6s6G1tZjHMDL51B3zDKrm+w0YS1BeSbRfzkmR7wFyYaPiKQ9kw6cb6kHgDqoIew1KXmH/9MPjIIbO7J7+P6nSgEEDSnpvo12px8ZESegl+dJ8wG1bQAkiP/p45w/22P1DowDAygBStxHo/oW5CE3GSK4NvAK1BdYvEH1XsqeGLAAuywGva5zSQotPbruIpx37A+2cJBlFTCvDyI0zyIKA9oZfk9LuC3dQZSXaFPX+P2x33is8HLIu4KjL+1/2uVSYf5vuvLvVieHONg0Ee5S2TFQoQyuMU5dY7uzfTdFUzpSyF5oQa+uJxM5KEE64A4PrRM1rzoyzQ5h5Uf3rxKK7AMDjw3rNsKEVLNOBLmAYJRBGuHTN94oJlbXW1bVh2SmbOXhUKwBN3aNqO8ZD5vAFcBdQpH7bz/UscOgdf+diK/bLNVziHiZi891zltaENvdUFnVcLRuWg0CggTFeAc7KnzHzQ6vU1GuaoAArWUZve7dC7YfFnboD0TUTLzNeJw/JXWYoQJbpifJNIngAB5bGQzU5o
 Aixanxuj
 WnO21KXP08Datj1LlPoksqMt977JPPwB4KTEeDTUG19uWcfWZJ2586yk5hEoK4VvoBAOXw+Xi12z7ahlS7LU1QVz1Lt72kmgeomvbMmNNVecXdz8uLz05MFCo+hkOzWxOU96xm6oNdlJowF6giabha4/+DvRCvvq3WbPIxiqTawCWib0h+ODDRozaGMphnKdoLKvmp6hfhgEWlxDWGOsdcymTzz2OdnkZUZ1AureC8aNgIv4zRbELc1BVcVnjSrTgD2wL57dSaCPHPV/Yg979AtCBkkkGWSKMmw4/XYLRL/h4bWXD4nUWY68waFAyHWi+XUju
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
that folio_dup_swap already can handle a subset of this: nr_pages == 1 and
nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.

Currently we have a not-so-nice logic of passing in subpage == NULL if
we mean to exercise the logic on the entire folio, and subpage != NULL if
we want to exercise the logic on only that subpage. Remove this
indirection: the caller invokes folio_dup_swap_pages() if it wants to
operate on a range of pages in the folio (i.e nr_pages may be anything
between 1 and folio_nr_pages()), and invokes folio_dup_swap() if it
wants to operate on the entire folio.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c     |  2 +-
 mm/shmem.c    |  2 +-
 mm/swap.h     | 18 ++++++++++++++++--
 mm/swapfile.c | 18 ++++++++----------
 4 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 6661bc11ce658..a70dbc8d544e1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2150,7 +2150,7 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	swp_entry_t entry = folio_page_swap_entry(folio, page);
 	struct mm_struct *mm = vma->vm_mm;
 
-	if (folio_dup_swap(folio, page) < 0)
+	if (folio_dup_swap_pages(folio, page, 1) < 0)
 		return false;
 
 	/*
diff --git a/mm/shmem.c b/mm/shmem.c
index b572c60f2af85..d5bd9506ce500 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1914,7 +1914,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		folio_dup_swap(folio, NULL);
+		folio_dup_swap(folio);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swap.h b/mm/swap.h
index b3b54c28929a1..47290510de264 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -244,7 +244,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *page);
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages);
 void folio_put_swap(struct folio *folio, struct page *page);
 
 /* For internal use */
@@ -368,7 +369,8 @@ static inline int folio_alloc_swap(struct folio *folio)
 	return -EINVAL;
 }
 
-static inline int folio_dup_swap(struct folio *folio, struct page *page)
+static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	return -EINVAL;
 }
@@ -464,6 +466,18 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 }
 #endif /* CONFIG_SWAP */
 
+/**
+ * folio_dup_swap() - Increase swap count of all swap entries of a folio.
+ * @folio: folio with swap entries bound.
+ *
+ * See folio_dup_swap_pages() for more information.
+ */
+static inline int folio_dup_swap(struct folio *folio)
+{
+	return folio_dup_swap_pages(folio, folio_page(folio, 0),
+				    folio_nr_pages(folio));
+}
+
 extern const struct swap_ops swap_bdev_ops;
 
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c1c5fbb3c909d..75167b8580cc0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1799,9 +1799,10 @@ int folio_alloc_swap(struct folio *folio)
 }
 
 /**
- * folio_dup_swap() - Increase swap count of swap entries of a folio.
+ * folio_dup_swap_pages() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
- * @page: if not NULL, only increase the swap count of this page.
+ * @page: the first page in the folio to increase the swap count for.
+ * @nr_pages: the number of pages in the folio to increase the swap count for.
  *
  * Typically called when the folio is unmapped and have its swap entry to
  * take its place: Swap entries allocated to a folio has count == 0 and pinned
@@ -1815,18 +1816,15 @@ int folio_alloc_swap(struct folio *folio)
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *page)
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
-	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
+	swp_entry_t entry = folio_page_swap_entry(folio, page);
+	unsigned long idx = folio_page_idx(folio, page);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
-
-	if (page) {
-		entry = folio_page_swap_entry(folio, page);
-		nr_pages = 1;
-	}
+	VM_WARN_ON_FOLIO(idx + nr_pages > folio_nr_pages(folio), folio);
 
 	return swap_dup_entries_cluster(swap_entry_to_info(entry),
 					swp_offset(entry), nr_pages);
-- 
2.43.0


