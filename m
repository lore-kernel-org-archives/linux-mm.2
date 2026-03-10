Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51479FCC9D4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8A56B0099; Tue, 10 Mar 2026 03:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56186B009B; Tue, 10 Mar 2026 03:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974926B009D; Tue, 10 Mar 2026 03:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86D476B0099
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:31:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3200B140142
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:45 +0000 (UTC)
X-FDA: 84529333770.20.54CBEFF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A727140004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a1Ozqm1qw6jiW1eHZN/FwV4cNjxaj3LsQKAfxpkEI7w=;
	b=rP+/VPx/5AoV4qUUvcd2g8P/jL3Bo+tkYj/G1vsmTfA+YPHRV5070Tqw3sY95c2XH2bBj0
	Ik5N7CXzukr5Wz4Ya4/i+KD6Y66O7ox9MFJqTpKQvC1TpJTIw2z6qOYT73McjVl+GE9heZ
	SWVXc/3ARoLyoYp9BOS3TXmJ2vd8S94=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773127903; a=rsa-sha256;
	cv=none;
	b=MSb/t0tVigf0sCNvz/10nsFfsiCbMn+Yn63KJF10uyabYocDQ/K1BDytu2X53ZAXScBmze
	aF8ExG65RKrYFdT5Jtp42oYyJ6BaJi4Gm1h9vayklgMEgO3IBBykUvhykjFy32kpoCmwqy
	Ef8edLJxihdYez/Ivgef+QTMXQnrSig=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 646211BA8;
	Tue, 10 Mar 2026 00:31:36 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BC8C73F73B;
	Tue, 10 Mar 2026 00:31:33 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: weixugc@google.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	ziy@nvidia.com,
	kas@kernel.org,
	willy@infradead.org,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 6/9] mm/swapfile: Make folio_dup_swap batchable
Date: Tue, 10 Mar 2026 13:00:10 +0530
Message-Id: <20260310073013.4069309-7-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A727140004
X-Rspamd-Server: rspam08
X-Stat-Signature: dhq6xkk68u3nwgg38i34heaop8p38kq9
X-HE-Tag: 1773127903-139399
X-HE-Meta: U2FsdGVkX18jByBc0S/gEsMG/r4aX1Jz1h3S6wsLAOe7MZQfqsbHfiHLmewfuqxRIKSNwU0eu8hApf+Zfh8a5aqlwkZi0tl60R60YSEYbl9IC1bsnFUmKqOcunfOzoJvQe6ygQc8EOPtVghp1G3dtuoiYzpxzumQBPxX++apo7AHcHeBC4RUBNtQttZTYDMEcK//YLBsJS1dk0oYx81jzISYV0rX3PprZiU2PPoyrmoTlu7ylbFVOQ00iGcp3as6FkWpk1xJAKlfRITp7pJylW6tpe/fLnycsiYFM4cPZ5T8Pum9wRvyNMr5rW40TWd3L3LrRyOEkXrp1FMwENq9Vevx1wbShLx+eSFgzBSphylXuDIIBuCwvRfBgjpcdk3SteuQS8yCDfoqV7ezwxS1NaTKPY+lVIvldf1ct1CSWMlVao/I5qfT91lDXzb2/k9fIFLo5+2MurcODOtuoKafpASr+DWQHOqjDCq0xqs1Fygi4bGHBDOECsL5o3nqZckisJMA7f3YN99C8OiIHFDdJfTush81GcjOmDxlIaexRIIR4hqjHs5D19bIvI7m8POmQaVS7S2tpYKqQUi6m3s7Is/0YoYlAEMvOWqe6YB1+dTlOfDtVbrJaGm+7hUDx6eCKOmwZfJjoE77m8REfy9e4KDbSd7vJ/9l7CknWQLxqIG/p+ACnnpnpKDZNjB2OsnrMRQn1+hQBDvHvFmPIzkG9ioo1fugOvGm73J+aUDHZp3tgugUVECw2Bhyw9S/L2BTl5gtSnddOeny8CBCuxFGmbdWlnNQ4+NIREzHSWnakf8Kyiksan5jsJoIJXk/FWUKN/PUpi96P8Di3Pcm8eBSk2Vb0ptbkAs9L7l++wTLU7jYKj36bZeOAJtf8FjEGfv0tBHCfhMjo5MJBLQJFCvUlRrxjdTvYIb2aHhRPF/K9Jnac+HzVGFUGCEBOAPeNlFljglJ9ogorn3tpkpyqJ8
 rt/YCIY9
 6RU65TKxJxPE2tizjBOFPPlFLwQVlPGgXD3hNG02jOgZqpomElizqA6BkO3jqSsFyHZEULWXJZm+xO13dy/xfC+RXrYvsaCKvesfSGRTwEtEvrSFW0J6kztOi+wqSWgH5nHP0Pj21WftR+vp2nxDWLSfIQ53a0nOSBdJbTNgPhGFlTXvKQDpEGWTe+7IATE8xkW1rlO5KTjtx9DM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach folio_dup_swap to handle a batch of consecutive pages. Note that
folio_dup_swap already can handle a subset of this: nr_pages == 1 and
nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.

Currently we have a not-so-nice logic of passing in subpage == NULL if
we mean to exercise the logic on the entire folio, and subpage != NULL if
we want to exercise the logic on only that subpage. Remove this
indirection, and explicitly pass subpage != NULL, and the number of
pages required.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c     |  2 +-
 mm/shmem.c    |  2 +-
 mm/swap.h     |  5 +++--
 mm/swapfile.c | 12 +++++-------
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index dd638429c963e..f6d5b187cf09b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2282,7 +2282,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto discard;
 			}
 
-			if (folio_dup_swap(folio, subpage) < 0) {
+			if (folio_dup_swap(folio, subpage, 1) < 0) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
diff --git a/mm/shmem.c b/mm/shmem.c
index 5e7dcf5bc5d3c..86ee34c9b40b3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1695,7 +1695,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		folio_dup_swap(folio, NULL);
+		folio_dup_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swap.h b/mm/swap.h
index a77016f2423b9..d9cb58ebbddd1 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -206,7 +206,7 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *subpage);
+int folio_dup_swap(struct folio *folio, struct page *subpage, unsigned int nr_pages);
 void folio_put_swap(struct folio *folio, struct page *subpage);
 
 /* For internal use */
@@ -390,7 +390,8 @@ static inline int folio_alloc_swap(struct folio *folio)
 	return -EINVAL;
 }
 
-static inline int folio_dup_swap(struct folio *folio, struct page *page)
+static inline int folio_dup_swap(struct folio *folio, struct page *page,
+				 unsigned int nr_pages)
 {
 	return -EINVAL;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 915bc93964dbd..eaf61ae6c3817 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1738,7 +1738,8 @@ int folio_alloc_swap(struct folio *folio)
 /**
  * folio_dup_swap() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
- * @subpage: if not NULL, only increase the swap count of this subpage.
+ * @subpage: Increase the swap count of this subpage till nr number of
+ * pages forward.
  *
  * Typically called when the folio is unmapped and have its swap entry to
  * take its place: Swap entries allocated to a folio has count == 0 and pinned
@@ -1752,18 +1753,15 @@ int folio_alloc_swap(struct folio *folio)
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *subpage)
+int folio_dup_swap(struct folio *folio, struct page *subpage,
+		   unsigned int nr_pages)
 {
 	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
-		nr_pages = 1;
-	}
+	entry.val += folio_page_idx(folio, subpage);
 
 	return swap_dup_entries_cluster(swap_entry_to_info(entry),
 					swp_offset(entry), nr_pages);
-- 
2.34.1


