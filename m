Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C534CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B670B6B008C; Tue, 26 May 2026 02:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16E56B009B; Tue, 26 May 2026 02:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D576B009D; Tue, 26 May 2026 02:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92DBB6B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:38:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5852F1202BD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:08 +0000 (UTC)
X-FDA: 84808616256.16.7FC6FDF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id A556F180005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fz9CyHtr;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5VOXAT8PEoJhtxx4sD7W+lsLJwu1dWiO4uXMO8Yp+U=;
	b=B+qyJj7f9ZjKN+WJ7nSrDw0Nz1tfnjTXdMPIuzMMbPMR8ZIM8mCv+4yKz9MnxWbZF1+Bcx
	4bfQ9sGqG/OUhtqLUgZgkSLTQiTMku7mMdwdCg6czwIJ0aNEZo6XcXfNB6VkRdhpyndXyl
	Ulroxz/AChADadkTdfx67Hp6sjuLThE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fz9CyHtr;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777486; a=rsa-sha256;
	cv=none;
	b=pqiR6FT7Tly+HvLhHFZdWg1FxST/FDsSa9RNGUfGuk2svvY8lOCNg+VRxy8+n3DI+WomPj
	1kj39Kj5zfNm0wu1qfSVY6ZiLiADVMEgcK2JJVcdOKwqAS9soNFcQDnvFmDmCDLKLi5y5R
	IDytO+8I31MX2Z534VJaAf0N7nA1mEg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CCF8F22FC;
	Mon, 25 May 2026 23:38:00 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 38C433F7D8;
	Mon, 25 May 2026 23:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777485; bh=i69KgY0c/7JMLUqhAYh69rZB7YphEFgzbWRlmksFiYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fz9CyHtr1K86YZlMU/vjNoP9r8nvBMXXk6V/LvmvCaR75piia1lfxUKV1+My5sifh
	 MRsqqCc6mVAMDAfnudynTzgsRDyUHKgBPJtQq5i1Dz3/wE5g2t66mLFULPeRGIZzUZ
	 ocXHA3T3JFQQ4rUHB0LbvaPrpKG3z5cwg9gScXDk=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 07/12] mm/swapfile: Add batched version of folio_dup_swap
Date: Tue, 26 May 2026 12:06:30 +0530
Message-Id: <20260526063635.61721-8-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cup1ru7kaqxhw9hs4t4u1wxbsg3jgp3e
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A556F180005
X-HE-Tag: 1779777486-426619
X-HE-Meta: U2FsdGVkX19aA/PyrsNtzArdtsA6JEuHDlDLDq1yAbUluqe7Hoavfy8//Li77W7Q3T3c8tdfa/F4s/7c5MHLYqZb+0bsPTJF4VTJAafHyraKIQOw/DyOjlbXkezhCYspXKEbDK/G+UpMlbKV/v+sR2r2OSDmMCTo5RVPzbsVmkhqpoc4In+p5h0wR9YCmJPI7AwcKhfKq17b9hiEUCmEK4yy94LnEPysnM0OHkUInpP72k6lTVPraSvVMn5Vcc13veUkX1uJQo+3PpIyec9UoJ2XPkfyM5Vy+kChLx73xWtuKTMKPj9Q805A9Bg8hg/NLHYFnT0GNFM77ZWFcUzUHbVSRzUbB/k56NBskurHP2vFMTikzu0fsbiCUf0L6Qw8zLgnfE1Ka5mcRa3v1HKalvQ7Rn5K+suPgB2vTeZJrq0kT4CHkEoqdjq/l9DHNImDGe+MQ2LnkQzGiyqYFAu+K9unv0xzPacCIid3OA8mpgkYH5XEk0FusxYCzTHF8cPrabiT8wgvhK+hIUrfU8SrX3rsZKe20VwemAYXP0NNKGnBJK9lvg0/xbj8SgeKkaBzP0cC+iiwdiBzZEPtQGMNP1DbWXCakEJyb/T2LpaHCY4+QIKE7Ikrsl5I0q2ur9azPKmWmCoMguejtY15FM7wSoY8UWQIVcLGMWPeKvmkcEi3HG4g2OVmBJP4VT2mR1aFqtT4zlqiwyHgoAujcTTDId3GiVIt3UJ/Z/jMDFcMA2Oq8aqpa8VXvs77SADgsdS50hchEM4tFn4p56WkH59KJGyIyV63yoIBe+8OcjpZvNWs5hlOZ7DBswwHxQw8JLH5KOtt7KgBkwUn8z/6em6rrr0+D0LVMu/38TL7I1Zssshu7HiPTv6oQDA8o9fJUQUoWlwYzeS4KrF83HWaMc5HXb8qTIES/0wS6teKtn24H2/2CeJO0u/ZCa3E38Evyg71F1oHUs5TnJBBJYmTGD6
 TyPuCAen
 4HGryHxJnDfykysRVjkGnmRyGwR6HmFs2xVuXzDLtjMbI7p+hsP541OEZMjU7X4+ZmzIZCehgjGeqvZXyW59JVZVbkX1hQwJNCiAL2yGvVAMTZXhKLUXl/Etivmi0GcZLqRDGV0sux3RDdphKPpB6lxkhje+LaNj2SnE10utyb6WlvXYOuIm/2EILPkn57GpkL5exv1eZXxW5zX7CK1KMsP9KgW0pC79Z731jpAzUCDztSP+yZ63UwQX2YHmhfDYQpe0G5/d/JoQuQ0OhHTAI5bOIor4i5Htg0iKc
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
between 1 till folio_nr_pages()), and invokes folio_dup_swap() if it
wants to operate on the entire folio.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c     |  2 +-
 mm/shmem.c    |  2 +-
 mm/swap.h     | 19 +++++++++++++++++--
 mm/swapfile.c | 14 ++++++--------
 4 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index ead031361bc61..3065d384cadf8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2331,7 +2331,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto finish_unmap;
 			}
 
-			if (folio_dup_swap(folio, subpage) < 0) {
+			if (folio_dup_swap_pages(folio, subpage, 1) < 0) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
diff --git a/mm/shmem.c b/mm/shmem.c
index bab3529af23c5..5e4f521399847 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1698,7 +1698,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		folio_dup_swap(folio, NULL);
+		folio_dup_swap(folio);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swap.h b/mm/swap.h
index b57547c25ffc9..36c69b2788c77 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -206,7 +206,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *page);
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+			 unsigned long nr_pages);
 void folio_put_swap(struct folio *folio, struct page *page);
 
 /* For internal use */
@@ -390,7 +391,8 @@ static inline int folio_alloc_swap(struct folio *folio)
 	return -EINVAL;
 }
 
-static inline int folio_dup_swap(struct folio *folio, struct page *page)
+static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	return -EINVAL;
 }
@@ -499,4 +501,17 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 	return 0;
 }
 #endif /* CONFIG_SWAP */
+
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
 #endif /* _MM_SWAP_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 62f083cff75eb..c91957149ecce 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1741,9 +1741,10 @@ int folio_alloc_swap(struct folio *folio)
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
@@ -1757,18 +1758,15 @@ int folio_alloc_swap(struct folio *folio)
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
2.34.1


