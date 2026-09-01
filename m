Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04443C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E356B00C6; Tue,  1 Sep 2026 01:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35DA6B00C8; Tue,  1 Sep 2026 01:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B5E6B00C9; Tue,  1 Sep 2026 01:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 663A06B00C6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:44:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB195802EC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:20 +0000 (UTC)
X-FDA: 85164103080.16.469CFDD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 02BC8C0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="TbN/jnTt";
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788241459;
	b=vntCeb8Vy3m068u0jxJ6XcVwnt+yGAVepDi4/28gRVS6RU9OTzTZz855UxmXuiPosPzLAP
	fOiKhvMBEhSzb9J2H09hlKR+MbRjfJ4VH9g0Ospg2yTAl0XTYSSER+z7PlqY3mvX22yUU4
	H/cQBtd5b7gWnCFnQD3s33hpIllO4Y0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="TbN/jnTt";
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788241459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpRcw1kQaskK1HqZT9ut57KqVa+GVd0Lqs5ZUj7SpQc=;
	b=hV5AYgNhkywnfWzGMnc+KOtG+irqSTPocuxOMUdGzvPaEHHqNkWH4KNqwsb8E8hXhRK46u
	gPzzN7ucQo57yyx3wAuM4CIKTcQdmV6zYA3V4NMbUpI1d5tYUDAgkYH7V84eRMAJXiCSa3
	118UTgt4d+hYPU/GWrrfPkWSc5qzv1g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75DBD1AED;
	Mon, 31 Aug 2026 22:44:14 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5E0893F85F;
	Mon, 31 Aug 2026 22:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788241458; bh=ig7ZTYrfkjo7NzncPTcndZj/uDDh9JipwJASpm9qtRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbN/jnTt+Z5QixddOBXum3DzI2tgmG3n2627m9V+ny+gH5A+Z5kyLNEv8Llz7pZcA
	 yYdms0gvFemF812GEqlwPInMFKiYyzF/9LfCQRigWvwhJRupHqMs6BPyu7Z3zkdyI5
	 XZnGhxgAubUd2LSoxxhUIREqTa3einEik3lSeLjA=
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
Subject: [PATCH v2 1/8] mm/swapfile: add batched version of folio_dup_swap
Date: Tue,  1 Sep 2026 05:43:48 +0000
Message-ID: <20260901054358.4049095-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901054358.4049095-1-dev.jain@arm.com>
References: <20260901054358.4049095-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 02BC8C0008
X-Stat-Signature: 5jajwhsq39ha4zbxniyrrw9iihscixgy
X-Rspam-User: 
X-HE-Tag: 1788241458-277474
X-HE-Meta: U2FsdGVkX19PkHmJZGEjNUCiFtqJ82phD1s7rxGppEI0pYxT8SrI/C5T4W+wV2tGRykWOJ5eyoTTAmNqtF/uh1LvAhnJIiEJVtXV39ZZTE2P9aDNGKMDYPdK4+7gj9sUhuuOkgy/3RFSXeje1wsZjduMR6f8fqgZenD/nHOAbS/nE+9/PLpC6x7AdBkbzk7I02Qi4I3vgKhB2ALHbH+2rI+mPL0caJZzJ4bfcAfL/icvQ3drnSSTF108VVNhzO5px7yiS/Z5mKlCjvj5fVwXbW+65JfVLghHcwQE8+yVVUppwZilDLfWnrIUmfsmMgZctd+q76MYo0Oe06J2P6dsKvRiZLM8uFlnpcrcwDs78P3vwd2fnnD8k+xpiibo6iGTxM3caO01NgqgTQIs4LvXfvFg3nwgQS2gJ4kPIKe/QR6rBeJTROPyOVvnWctzwm9buCyP2KmbH6T83qvVZX0qTDDj9r9IDZgUpTAFgvxN0rSdygP8yKpzg8MHvYAo0V9rVwKtpTD899yBoJjWuJfOmqyVwcmzgQNOgb9AF8/DxT0Vg5cIJ2M2++frFj1osLFLArGs1qZB2IcPqqzLz34r4zkcItIugX8T60XnquReJyU5wX7gQR1+3o2aMKXsXAQ/jfJuT+I/30v1TJp3TfPAHkqYUuhXC5no6Ye4KVexldy4UcXHTf0ohKNBin23nXbZlXCA6sSjVORwyGR5O/tpYiKGbCR+QtvzndPwUjZvXZ/cYCr4m/hu4DQPT7l0qbbCnNspPXYdne97pEe3bP5dTxzLohP6rlQjuMQOb/SA+zo9xhRmfnejjZPapZxihTNW+3d9/d9X3FMK+/wjxovyY91ehNpkjozEpZ7rUtw2CwZUB8sIAav7kbhzKnV81dtF7ExzCmVXGDjDXLkq0rQGMWu9BC3SvKeHXf/5pS/n3OpVC/fsSYNsLqhQbkp51BQVDUdRj8FtFX/rkOfksiX
 MiKIcS3t
 GOnyqCYuLl0y3m9GEonc3B6+1Hll25NFHNtHzEWQlQv149mZDcBl99UTtkjHXxFxbG8zfu39/yFm1isc0JLVD6nnW8W2il98bhOxLD3NYinVu0xyFgFBOgKtL2UUiyliVIYBFB8oGAYmJ5QSwFHkTFI/3ZWDhNucXQo0Cra0OfQe9lBIotRpCxenUCVGBOh59Yx9qsuNQSnXbufyJxYWWL7ningC3uN7I29oMZDXy/2HyjfRYjepq294rxH/AGKUtKiBTTRhHk6MdUr4rNjGRHeQIbiSo2m32zZOWwfHlwErDvDZFVtvJarum8VV+CnpE5/cS
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
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/rmap.c     |  2 +-
 mm/shmem.c    |  2 +-
 mm/swap.h     | 18 ++++++++++++++++--
 mm/swapfile.c | 16 ++++++++--------
 4 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 606c8ecf31302..0a4aa06b66de6 100644
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
index 897fa2b61346f..6cea018d69f04 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1712,7 +1712,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		folio_dup_swap(folio, NULL);
+		folio_dup_swap(folio);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swap.h b/mm/swap.h
index 90a551a88df63..f52ecbedae8b8 100644
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
@@ -463,6 +465,18 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
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
index 53bf01d5f7f11..25bb6fc562c57 100644
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
@@ -1801,18 +1802,17 @@ int folio_alloc_swap(struct folio *folio)
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *page)
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
+	unsigned long idx = folio_page_idx(folio, page);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON_FOLIO(idx + nr_pages > folio_nr_pages(folio), folio);
 
-	if (page) {
-		entry.val += folio_page_idx(folio, page);
-		nr_pages = 1;
-	}
+	entry.val += idx;
 
 	return swap_dup_entries_cluster(swap_entry_to_info(entry),
 					swp_offset(entry), nr_pages);
-- 
2.43.0


