Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5CBC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3A76B00A1; Mon, 27 Jul 2026 14:13:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0565F6B00A2; Mon, 27 Jul 2026 14:13:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE2A6B00A3; Mon, 27 Jul 2026 14:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8FE66B00A1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A49C80174
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:31 +0000 (UTC)
X-FDA: 85035354222.09.0771F13
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id EAC9740009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aEWhsY09;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BLb28xcNVq7ejs1N0evQYAtnxGvoFOq0CBWGcdPFjMQ=;
	b=kCb8jH8ewGOczz6yjxWAHnjmvbzNvg/2Ni+E+vZa3CAwkbL3QknNaIElG9cRLRLOM5YUga
	GiFDjF8HbOs3xhwivqPSmWa+O9QxFcBzVmjrTkFH4ky9NU0a0kOBqj2tfBXrKNL0Da8+B5
	ymuJlwXUpbR4Dor9Ui06qtCC3GYBRLM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aEWhsY09;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176009;
	b=A7q8QGbVrTvNmlnewYZK/ri64sXHsivHACz8WGkVreXTe9PfL3N9fxMLVbTwsLA2N/UeOr
	DtBuotQor4zakB2sgwYIIMaqOLB7jm3kqA/ji0u5fhLRLFHp5QqPJPlT9xKDf6kXBBtCEV
	KwnhQ77UmyHg7JKqvcjoe/CPW37uEEA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=BLb28xcNVq7ejs1N0evQYAtnxGvoFOq0CBWGcdPFjMQ=; b=aEWhsY09vBt4mmFdDYd7baCymq
	EFIDxuvAdpXPGK2qO70j8w7RItxF32UhuKBeikDMkZeUfk8OpmtBMvCf7YP6kmIb3AD9SG1ImgaSK
	lsJ7trrVnnKUVSiq43cSWuoAT/6WJr+cW/9+XOasYBsQnaA2tZL9rKlzJQsAmtBkyq8okAi3wih8y
	j/bFsuTGqcOanDsSHn6t8RqNwWHezFGsbaAoaL/aGssIWne8o3Y6BKFu+AeOaFcv0/cNi1U6iYwtz
	TZzZWmYv4npngFcp4akboFKZkaMqOgNsZ15FbMtv1Jn3tyDp3kn32ciyV8uba2aV2tRkaZlX6rnrT
	TyJD4ycQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPp9-0000000BD7M-39v1;
	Mon, 27 Jul 2026 18:13:11 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v6 00/12] Use generic_file_read_iter() in hugetlbfs
Date: Mon, 27 Jul 2026 19:12:56 +0100
Message-ID: <20260727181310.2671972-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EAC9740009
X-Stat-Signature: qxn8d9kgkdrzz4737wkdy3wyim3phi33
X-HE-Tag: 1785176009-13466
X-HE-Meta: U2FsdGVkX1+RDStjD9kkT1xRLDH2QthqdC6oZ/j1Wt9b1QFkNfDG1l91/BPfaaUTYfxNfpX80hWtpjRh3g00n3eYZP8LGrmZgEvUGld4nNXHo1vAkwQ+g6kZFDbgrObQ/mlnSR+7X5TR5stQl5SgNHVw7Pbz5qyzVmS26IwEMO9XP5dtORUquiNudjlmjfRytW3P68fH44JpubPMijoYL4sYkGwiUD+QJEdR7FLOBmGMFwnEmlyku3JIfowpw0XitIo4rbnntkZ1rJBhUFPcWHl+6sQruzHpivfUo9EhHxYNEW3+kUCLKg31kTFnalR42O8sKmSaRzEK/5gmydLETTmXSyma7ELwkI8k46qOp5uCUbUZ3AykzeA2yyRqgPzRMS58eHhS+/4074L1b9YsS/y093VzkHsScU+OZXPLD81pxw3Y1mzZmmXc8gFhVnYxkZQYX5EQv/Y0yhRe4QVHgO5MnCWqvG9Au1ni6gpLJ1FZU/pS3uSQCcCnOE/AGxWCnJsrogeG9wsYo7itkJXJ9Vic6jD47gKnQ12bl5wWWLVquJWDLHFZ8E4VsBfbCkLDjX77rshCEgUkK5qvU+6sg5ykGsy8uNuRMikv6+h7DLot+EoA5iXy5QFOIWlPOdDRdFyIYikauqI8t8EG0pNDSXN9VXkGmxlBH707EeqPy2AYsGQvH7wpyPqWp/KqeU24TuhGNbr6R4s823skva+8V9evQH5eKnEaa0Wuas4Yrj6+44xAkGOGcBwT1gpl8sRRCjBeD9irBnEdyw04y1KIfLWnnZ1bOMSl2z8nNFgVkj/rFvsWgQJdkCay66mUytngwTvK2OpmBW0uozSPAAca/sCRv5poyTG7ILuxeNbao28TTbH9/hDLsBaqonVvKCIiiMCPWJWQIglvfzK74EIpCqZXbS9ayuKSHxOgszWJAoE9P1k4Y9XJygph1W0Q+fmxrcJD1GM5nSSU3XZQljS
 EySMxGtx
 DV72Ng+M5PDXic+YkRmex4X9Xm2BI4eG6lIiHm/DsjyxMKXbFOF6W5sRAjXJQSbFwQZkurzQDTkge+Wt/4l6eRauAmFGwwxSmkhbgcE3Rb00jcuAUPHK9cPcoNdlcFP6k/an9gqeaiwGoQ8KyYAU3pWjwEzMhQNQ3bcvyP51d9EXBg84zTRu2RkRy78EX4LXioNCRJvRohwBTK2b/4csmoPo520Vf9FRgq7V7iMC1++f89J01Q777l8GLCJXCvoFJ7jjhguYTaaAhO9zv/s55GqCHfl603EENmjmKG0Q/zP3l/IdrjWuEdVOeeH+JGUPQ+9OQ77zwZzMDILbq2wrqcohq2WcYy3g987IqLbh4K4T6/XS4aXffG2+wH5y96s1roJV4Q1eOs3EwKLKA14UAi1hSm0+8zc3CSP+s9uPtfb3K4ec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This set of patches are separated out from Jane's earlier series.
https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/

We need three things to use filemap_read_iter() instead of a hugetlbfs
specific read_iter: hwpoison handling, treating gaps in the pagecache as
holes, and having hugetlb set the folio size in the mapping.  hwopison
handling turned out to need a lot of prep work; the other two things
are fairly straightforward.

Sashiko complains that the implementation of AS_AUTHORITATIVE is
incomplete, but hugetlbfs doesn't use any of that functionality.
We'll add it when we need it, either when hugetlbfs uses it, or when we
convert shmem to use filemap.

v5 here:
https://lore.kernel.org/linux-mm/20260725160042.1557264-1-willy@infradead.org/

Changes from v5:
 - Move hugetlb_clear_poison() before folio_put() to fix a race that
   Sashiko pointed out.
 - Wrap failed get_hwpoison_page() path in hugetlb_lock to fix a race
   that Sashiko pointed out.
 - Reinstate handling of unpoisoning buddy pages that Sashiko pointed out.
 - Check the unreliable flag under the spinlock to fully fix the race
   that I was intending to fix.

Entire diff vs v5:
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 32f91935b210..6ca7e1df7f73 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1826,14 +1826,17 @@ static bool precise_page_poisoned(const struct folio *folio,
 	const struct hwp_page *p;
 	unsigned long flags;
 
+	spin_lock_irqsave(&hwp_page_lock, flags);
+
 	/*
 	 * When RawHwpUnreliable is set, kernel lost track of which pages
 	 * are HWPOISON. So return as if ALL pages are HWPOISONed.
 	 */
-	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio)) {
+		spin_unlock_irqrestore(&hwp_page_lock, flags);
 		return true;
+	}
 
-	spin_lock_irqsave(&hwp_page_lock, flags);
 	for (p = folio->hugetlb_hwpoison; p; p = p->next) {
 		if (page == p->page)
 			break;
@@ -2785,13 +2788,17 @@ int unpoison_memory(unsigned long pfn)
 
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
+		spin_lock_irq(&hugetlb_lock);
 		if (folio_test_hugetlb(folio)) {
 			huge = true;
 			count = folio_free_raw_hwp(folio, false);
 			if (count == 0)
 				goto unlock_mutex;
 			ret = hugetlb_clear_poison(folio);
+		} else {
+			ret = TestClearPageHWPoison(p) ? 0 : -EBUSY;
 		}
+		spin_unlock_irq(&hugetlb_lock);
 	} else if (ghp < 0) {
 		if (ghp == -EHWPOISON) {
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
@@ -2807,8 +2814,8 @@ int unpoison_memory(unsigned long pfn)
 			folio_put(folio);
 			goto unlock_mutex;
 		}
-		folio_put(folio);
 		ret = hugetlb_clear_poison(folio);
+		folio_put(folio);
 		if (!ret)
 			folio_put(folio);
 	} else {

Jane Chu (2):
  filemap: Add hwpoison handling to filemap_read()
  hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

Matthew Wilcox (Oracle) (10):
  memory-failure: Fix hardware poison check in unpoison_memory() again
  mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
  hugetlb: Mark some function arguments as const
  guest_memfd: Use folio_has_hwpoisoned_page()
  hugetlb: Use the has_hwpoisoned flag
  mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
  mm: Check individual hugetlb pages for poison
  filemap: Remove checks in mapping_set_folio_order_range()
  hugetlb: Set mapping folio order
  filemap: Add support for authoritative mappings

 fs/Kconfig                 |   2 +-
 fs/hugetlbfs/inode.c       | 123 +++--------------------
 include/linux/hugetlb.h    |  24 ++---
 include/linux/mm_types.h   |   4 +-
 include/linux/page-flags.h |  63 ++++++++++--
 include/linux/pagemap.h    |  45 +++++----
 mm/Kconfig                 |   6 +-
 mm/filemap.c               |  51 +++++++++-
 mm/huge_memory.c           |   2 +-
 mm/hugetlb.c               |  16 +--
 mm/memory-failure.c        | 193 +++++++++++++++++++++++++------------
 mm/memory_hotplug.c        |   2 +-
 mm/rmap.c                  |  43 ++++++---
 mm/shmem.c                 |   2 +-
 mm/vmscan.c                |   2 +-
 virt/kvm/guest_memfd.c     |   2 +-
 16 files changed, 328 insertions(+), 252 deletions(-)

-- 
2.47.3


