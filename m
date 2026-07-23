Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC93DC531F5
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE416B00A7; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2C6B6B00AB; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909516B00A9; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D43E6B00A5
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5966A11E0
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:15 +0000 (UTC)
X-FDA: 85020278910.15.7FDA6FD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 54523100002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DLxTvzNj;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2SPT3MXbDM1jP3sj5ZSZX30ECFfsAUAa+GQfYoFtxLo=;
	b=NCOTg8z+Ukx5llZcCddbYpQFSfvHhqHFpc5z/tUOo7AueiKe3XZu2QqtsUIAu2iPX8ITHE
	9fidABWCzmUhfGoITpw23es0+gcRY5ZLMtnLpb4Ef5naNDZqlNSbFMUkolCPpDFc4MDO1k
	J02zBufgQqw3y0RtVmyzbyF9UqXeQTg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817074;
	b=XguKWcbNK7+6zeOuIbq6O67XZJaveBt7p3cRocZScO6NdBeolMgGQWIAcaRRAqmVh9n6eZ
	r+15t3R2P43labGX7uelwSGj/pyTJetQ/LAUNRn0zxkRULpI19uqrwmPX9h/S8OnCHHtOL
	3O5I40Ek4ci3TJw5LjZ6LXvV0aRrJgg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DLxTvzNj;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=2SPT3MXbDM1jP3sj5ZSZX30ECFfsAUAa+GQfYoFtxLo=; b=DLxTvzNj+O88TIlVYBut4qM66+
	Ogk0LZNay7eLUxNAl7nnZC2h6WiitVApkb1pbFaab6fhpulR9/D9wkAmi4lzwU94tnLYB1qhyuZFR
	1+JvB5iATzSNdbI5K9OzEGtY5FlLAqm2JiNmDFdEYvuzE49WIE8MGLHabV1DKSqtLFmlNfUqitGYG
	saK8IZ9wRXJyYMcL8KpyX/au+Ifs5L/lLDplp9VDbChr01t/iALBJ7r2M9eZVkBVcoUJQ+GaoOwi7
	0yjfDZr3EiMuloqQtENv3ew13rhfWK7yleultzFlrHMd+1dyz3Oaj7ykEp7KbWobBSHlowsXNSwcM
	y+zV91fQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRZ-00000000ji3-0uja;
	Thu, 23 Jul 2026 14:30:37 +0000
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
Subject: [PATCH v4 08/14] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
Date: Thu, 23 Jul 2026 15:30:25 +0100
Message-ID: <20260723143034.175661-9-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 54523100002
X-Stat-Signature: sk9z1mhow4t4ow3sqc1pqqzfiqumu64c
X-HE-Tag: 1784817074-615908
X-HE-Meta: U2FsdGVkX18R5v4VDhMnehHzX7UgD2vj803Wm4WFmzk6L+ExTrh9HYvgjuql+4inqNUacoH2yGMLkzL0mNb0o1rqDYo66qRzGNlxoO4b3QpERUR7wjXAnCGVbMkvoP07VxF2K7RMPFiVIB+gB0hXBMO5NlwKDLiHwifMBtcLKLyCNE3h60xU4Oqt7O8xByQKMu5wBo5bzFS38+YLVC1rVPcAMCYM2brMSD/20lVl0r8Siki2tHM6DMoFhA7yOhziMyJMld4rXgZeqoMhk0mBdq8U5AmOTA3JtKMfnIrzdF2o227PLTWinppA9Rg3DxoiyULPiALvpsoCx64aPi+yfJ+2riNlHJzVFreuw5w5MluWqe1Xb2HO+nB2WQ/f2tMtCN5ATWQp0IAf9T5Jm690LmmnS0xCFCNhdTszpzzVHsQCKJ16TAjxr+QiCUmvhaAXalrK/NIrWsbH0RN3ZKP17Nvox1TtliX6xD5En6LVRkcI7gLyoPcUyD8yKolTG1NJ5jiSrmNyf+WrE4UoHO450y4X4lwGEa4W3UQyDJPeDhNe977DOdYNqHjGIdudoh4JaMn8CAd09+pAfQk2KNgwXY5trTq38KIHu6qaOBNEGOj+39/M05TxZJ9VR4onAVokfktHqmuF5DvzXjb2py44NTBtDmB+It84K5aoVbL5LyBlny7ko0tNxohvWklNIUY6GR67Ge08EXQXQ3pte5NteqsO1Cou7KDJ8X/cYBdV7C+FDe26z2YopkeqIC4E7r/4Vs8x6aCazX5uOEr5QtPNGqxzESBOQfKocrgQYC5qwKNiEt8IZm394AiNZQwzgmAVnkHa9bjcPtZPgHYLRaKLwprXOSJkhq/eZ242MFgh/mVh6iSm1sFeeCqq1SN1oErESQ2pMpU4LX46PP8Fe6OhbXjKOujyzHa0Nw2tborqBAhS0bxYBafFdmAIQ4meyYgnBq5Sa7pJFt5gcu6aZhO
 1w2P678R
 NbT3RgItW9ODddyf9dSlw8xctCsWQbHoiHBgLO3+/P5MSCVLZrx4T9dMaasT+qviE8sPld229evvIF550sPhiT365LCwTiBxcneJ46M/LJkO5ZZy/zP2VENpb9ZpF6yGEp+WbJv016+T4p/VYEA5mUqnPgX0HImjI71JuHZSQd8NWb8+EhYU8nhuKk/NKvlwxg6VA6poSoNbOUG8eJGXMYHR8w6HPNMiF7S1pAjKYJtvU57reXQPMoylW/WbMB5mNL3lnZ+3heE6g1Bvy3rdAUPUrpYGkI7sdXe5NzdlanrvYx61sH9XtEHMUO70ValViA8Xp/+phfVtZfeVQw0B69LIr4L1oyOpZ8db4687+OnC1Yft7SHo0/jXH3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need the mutex to check the list, as long as we use READ_ONCE()
to access the list head.  Updates only add to the head of the list, so
we can miss new entries, but not old ones.  It's perfectly acceptable
to miss new entries as callers cannot tell which order the add and check
executed in anyway.

Rename is_raw_hwpoison_page_in_hugepage() to hugetlb_page_hwpoison()
and make it take the folio (since the callers naturally have the folio).
Also remove the handling of non-hugetlb folios and make the arguments
const.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/hugetlbfs/inode.c    |  4 ++--
 include/linux/hugetlb.h |  5 +----
 mm/memory-failure.c     | 31 ++++++++++++-------------------
 3 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index fbac554886c3..dbca3f713bbf 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -198,7 +198,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 	struct page *page = folio_page(folio, offset / PAGE_SIZE);
 	size_t safe_bytes;
 
-	if (is_raw_hwpoison_page_in_hugepage(page))
+	if (hugetlb_page_hwpoison(folio, page))
 		return 0;
 	/* Safe to read the remaining bytes in this page. */
 	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
@@ -206,7 +206,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 
 	/* Check each remaining page as long as we are not done yet. */
 	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
-		if (is_raw_hwpoison_page_in_hugepage(page))
+		if (hugetlb_page_hwpoison(folio, page))
 			break;
 
 	return min(safe_bytes, bytes);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 18661a7cdb37..325f0404a7eb 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1069,10 +1069,7 @@ void hugetlb_register_node(struct node *node);
 void hugetlb_unregister_node(struct node *node);
 #endif
 
-/*
- * Check if a given raw @page in a hugepage is HWPOISON.
- */
-bool is_raw_hwpoison_page_in_hugepage(struct page *page);
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
 
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 4200deab2c3c..5076ee5d4788 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1817,37 +1817,30 @@ struct raw_hwp_page {
 	struct page *page;
 };
 
-bool is_raw_hwpoison_page_in_hugepage(struct page *page)
+/*
+ * Check if a given @page in a hugetlb folio is HWPOISON.
+ */
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
 {
-	struct raw_hwp_page *p;
-	struct folio *folio = page_folio(page);
-	bool ret = false;
+	const struct llist_head *list = &folio->hugetlb_hwpoison;
+	const struct raw_hwp_page *p;
 
 	if (!folio_test_has_hwpoisoned(folio))
 		return false;
 
-	if (!folio_test_hugetlb(folio))
-		return PageHWPoison(page);
-
 	/*
-	 * When RawHwpUnreliable is set, kernel lost track of which subpages
-	 * are HWPOISON. So return as if ALL subpages are HWPOISONed.
+	 * When RawHwpUnreliable is set, kernel lost track of which pages
+	 * are HWPOISON. So return as if ALL pages are HWPOISONed.
 	 */
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return true;
 
-	mutex_lock(&mf_mutex);
-
-	llist_for_each_entry(p, folio->hugetlb_hwpoison.first, node) {
-		if (page == p->page) {
-			ret = true;
-			break;
-		}
+	llist_for_each_entry(p, READ_ONCE(list->first), node) {
+		if (page == p->page)
+			return true;
 	}
 
-	mutex_unlock(&mf_mutex);
-
-	return ret;
+	return false;
 }
 
 static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
-- 
2.47.3


