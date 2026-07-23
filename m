Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DA7C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5AE56B00DC; Thu, 23 Jul 2026 03:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A8E6B00DD; Thu, 23 Jul 2026 03:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46FC6B00DE; Thu, 23 Jul 2026 03:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83A1A6B00DC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:09:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E46551C0877
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:29 +0000 (UTC)
X-FDA: 85019165658.28.41B9F03
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1B60340009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dZYbH0sY;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784790568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04CpOWE1Z9fO0eW/UZFLUjGrv86zJIj7jpVk+YUmoBQ=;
	b=fSOLp8TiO5TllmPpTkBJI6BuK2FbEnGOySI9eFH68iUXF0BAPOU6mZxWE0PPwmTrV8PzM+
	C0XzzH3Ghj6WmkHeAS8QbUiw6cCtI1YoiJMuAw1AZfJKydsC4o+mrxrGyoy5tqocRSpVTS
	w6BL7AYkqyqySyEF4pl8kp+gERhrHTc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784790568;
	b=kWt4vtru2lOzlUFK6whX+jEZJ5VOTXRODa5RBzIwk9zalWrtPHYPxCJ7aJUJTMBJN5ds65
	KdDrqJTA131iMAol+zPoN17OPGtQ8E+Q2OK3PWjthQ5WDpF62Akulk+EICv0+fXp07If4U
	2x6RprjhZZjU/gcDJD3GY36QzA9sLfQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dZYbH0sY;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C91251477;
	Thu, 23 Jul 2026 00:09:22 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1A6A03F66F;
	Thu, 23 Jul 2026 00:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784790567; bh=tDN5tu+oBractnjHZpB5YigDPChpchVDV6AVieAZKf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZYbH0sYmLklBeRi1wZluPY5iB0EU9QWe8P/nYRI8oP0+uaKu4Kw6MsKYc6nR/Amr
	 HCs77DiyIm+NqqZ1/g63b6DiHXyUHWl8L2qLYcX3uwIwb+mLHj0T4tvrBGbg+tMDw6
	 QavgdV+80EpAxxo2xRSTI8wYVVh4Fi54cBMwvoEE=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
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
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 1/8] mm/swapfile: add batched version of folio_dup_swap
Date: Thu, 23 Jul 2026 07:08:57 +0000
Message-ID: <20260723070905.3422276-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723070905.3422276-1-dev.jain@arm.com>
References: <20260723070905.3422276-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1B60340009
X-Stat-Signature: y33aed9w1urfpp5o655br49sz9k4ubom
X-Rspam-User: 
X-HE-Tag: 1784790567-53202
X-HE-Meta: U2FsdGVkX1/iGf6WxoxbCMvIj1/doGjACG+Ku0jfDfPaprDwO+QFqK+3vp9L0FDkgIsiAlyUxuMCCltYCqGPpmXDlrqVcU4SKd+TMLa987toAHiuw4afG7m6oMjCpr8ekFSA4JhmPLq83zayPnVLRp0nx1sN1sK4//tibmiPVLgsiQHNDttglGdhWpxeBsWmnIIrwyBW8iBZeCL8w2xLlN7dqms/8Lb+yqbJddzXOBoNHba5XCoS5jJyrlf2ckFvxvyBp3tP2/2sphMzyNkLksSxZybBhCGo5fm5RY2J0xWMGKpkF17i5bMbdJPBFO7JCfNN4HWfulRlJ49OTiW71iQHSMajJOxYvb4v8EgY2MCyfGX+b9TrzU/46JTv23zUK1/ofc4NDpxB+Jxn7rvevvB2HstJPcuFxQuSScUPCqM8h+dZI7rsLI9h7rPpZ3Pi6PdZPrVbxWet8FWdyYjDXnKAM0/5mIUGYnCDhnTYZWTjRxeDIdw9OOCkUsliWzM4INlUFk+HJR6GHZTvOiasYRdP796dv9IXv7wt937A72FtTiOYNTM4t45TrhFaq7mMpgouckeIpQVFNZv4a9y8H9uRIC6jDAEPhBEr0JFnCtrMgdx8ZqDxjuHBwNPL1s+J6QvbcHEEJx+cLVx1noQm9Ok3mbCHxesRgIwue+GG3nrHWfbBpJHDr007BZw1fIcNt/CdV2O6Q2DUerbIBP7nCDErvdDLyWShxTk+xfQ0PFxFsosZh8yZyud2l0fpb816cPghgZsjILS/UvJ6QQDD1Cmj8WEJzi6R2yQicTzVKJuU3Y58Za9I0ZCPmPWUuV+DC7bsbai4f9Qi5AgjpZes0VDTj0b6JFtm3+n864iemZ29f6ABi3WIrFLV5Edx4vmpRj9n3zOpWcWbfOVh6KXqXvsd7uYIWRl2EoEeGhzV2/qAzm7h4IXL0m3MMQ2STL5pzWJg6T0eoXVc76+0Y+C
 Urfz5b0P
 Lx2vKcjG4j7Qq6Yj5nYvX6zLJvxhMN5rAtQ1ybPMvni8eqnPLp1RkFSFwmpWBD7B3Ls0veYHyYXKarD/Jj+Qk3uiJB25dKec1BXP62BR6cPfrbc9Rthni44FzIrpeHPbJKksAvE0ZtzD6sJhyxeAKjN5a6GAA9m1eeZc08kBrQOiP1S/fSmlwOBt+l/SulxFEzCqoe8U1nmRiJwsPe76YNIZer0dFaoUdgk7vt8HFMMP6zmRjvolPnJosoJSR44Q8eO67LG4Unp/rN19Mj98sOMnXbyOqntVvlqE7MaewmWiiQTBJWh9f+TIJpgjCOz59CZr/
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
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c     |  2 +-
 mm/shmem.c    |  2 +-
 mm/swap.h     | 18 ++++++++++++++++--
 mm/swapfile.c | 14 ++++++--------
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index b7ead3e9f0641..4ca809a596dfe 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2148,7 +2148,7 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	swp_entry_t entry = page_swap_entry(page);
 	struct mm_struct *mm = vma->vm_mm;
 
-	if (folio_dup_swap(folio, page) < 0)
+	if (folio_dup_swap_pages(folio, page, 1) < 0)
 		return false;
 
 	/*
diff --git a/mm/shmem.c b/mm/shmem.c
index 5071177059a96..501365158f8d8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1698,7 +1698,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		folio_dup_swap(folio, NULL);
+		folio_dup_swap(folio);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swap.h b/mm/swap.h
index abd26588abd22..bbf665a33014b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -251,7 +251,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *page);
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages);
 void folio_put_swap(struct folio *folio, struct page *page);
 
 /* For internal use */
@@ -375,7 +376,8 @@ static inline int folio_alloc_swap(struct folio *folio)
 	return -EINVAL;
 }
 
-static inline int folio_dup_swap(struct folio *folio, struct page *page)
+static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	return -EINVAL;
 }
@@ -470,6 +472,18 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
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
index 5d15913dcf863..0709a6266cf1f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1785,9 +1785,10 @@ int folio_alloc_swap(struct folio *folio)
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
@@ -1801,18 +1802,15 @@ int folio_alloc_swap(struct folio *folio)
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *page)
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (page) {
-		entry.val += folio_page_idx(folio, page);
-		nr_pages = 1;
-	}
+	entry.val += folio_page_idx(folio, page);
 
 	return swap_dup_entries_cluster(swap_entry_to_info(entry),
 					swp_offset(entry), nr_pages);
-- 
2.43.0


