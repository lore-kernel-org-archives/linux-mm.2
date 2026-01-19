Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E432CD2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5FC6B031A; Mon, 19 Jan 2026 18:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576AA6B031C; Mon, 19 Jan 2026 18:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458996B031D; Mon, 19 Jan 2026 18:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3571C6B031A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:02:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00A4DB81A6
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:46 +0000 (UTC)
X-FDA: 84350239974.20.5971CAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4635440018
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kL3yk/Nx";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863765; a=rsa-sha256;
	cv=none;
	b=mfkpGMXkCfq+p3bqfKNpVbpNV9uY+F9fJlwEVTJLTgcjxIfnEoM5VFtqVmRWpt8WmbZqQI
	+PIwsxd7kU4eSGt+eBkmT5S3RTkeA8sDFhQQU6Rl23O2fsAdrtkBTDou1EIdJXqfPqy31K
	LUX4bcQsemSrGeTm5zOChz3ykS79+cM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kL3yk/Nx";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CoaqyR9apc2HJjdnoIEC8yC+8IRwumyIxryXdK3cUs=;
	b=0JaI7/8AWp8SZ1bZes0mujLvosl7N9yEq8H1nTNVaG4V7OAE35GA7gc3wQN7+NCs5IUT7u
	AMwSApYlWcl5bMxt2BrmedKH0tI11mTDlYCyXVR6zpVC+9BI6BKq9MlhD/y8jQk1wB7XRt
	76DxT05GKGqqJeLiKYn7TBUjbevrk7k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 715AB40846;
	Mon, 19 Jan 2026 23:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F78C116C6;
	Mon, 19 Jan 2026 23:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863764;
	bh=Pf5BxzivrH4BXObSIgzNQrUk+URrkIatB5ImogUIjQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kL3yk/NxqLODZejr8sB3SxDlCN70szrILaWrvJJIW+HQIGg4P/+YP1wzydq+dc68t
	 KOpMP3LxEmZALZci/WwsQshv725k6uY1y/mzahpied33Xva4RzQCSQ7c4gSpPToObs
	 WHeu0YhuZVaaFIUCfvYl74JU71ePBkTm58aBxTYlZRKnfXc5lU+msYNmpB+z+wl4ru
	 JcO2lScUWd+bNcp6qpk53CQ1B0nr/RDBVW8prfZ3gs+4sNo4SQnqA1m8tfxPp79Ua+
	 lzYTwtGP4Zn+sr2Ljv3uykQLhJsQl+DNAIRP8yHOzwWGaK9v7HUiTIRQVUaiyoqSkK
	 2Zs3VMw3HZoWg==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 09/24] mm/balloon_compaction: remove dependency on page lock
Date: Tue, 20 Jan 2026 00:01:17 +0100
Message-ID: <20260119230133.3551867-10-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7zyejcujtuz878osadtsi5jpiu7p1iha
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4635440018
X-HE-Tag: 1768863765-191155
X-HE-Meta: U2FsdGVkX18V82rBWmhJxG3BIY3hOMhQ56CA5rtebIOddCw53Fkuc56xJIt0urcaid8kp6wcqydUQ2P8EXLUNvlaI3ttG7ChGOe59/MV4tc3DVZM9Atc3aUOB1/LyOdf9jw/+C1wQUSISqEsl/g2m4LVJ5rlSVwDW01aWBN+XxWE+WoWe1kv1PHCFlQHDSIdfMkJDQUwzyn4Kq7RbGNhFighka/HU6Ih/KPa4vBLbLO4LEaJ/v+kX/gpvevULkoh+xdlvj3UzslJtQqRIWl+ThqKPinlNCgG+KMYTkU1C6AyhtBbLzZ3z3cuu7E++ylZYXdMbT0pend48cEbMIEItvL3oY+GNJJdBvMoa/dyLiuZfbKNGNxifyLDQ0jZ/nPaSZrC5bCAVNSwtqQEq372BQhVYtzEHqkpXRdP71YffcGdm9xDho5LRC74rOr3QFoAcnrcOcb4POr0D1Itx94XKnUOGywJLOw5sO2WDyk8ItXvqpPTUylFGSWuBW2HlcBje7AM1y0Mo800U/D5WyCZ/kWYpHKykvU1/2uKI6NehT+wLjkfqycFqlvYW7jzCIP+FYvIv6lMzwR4xzOFN29tbaGoUSDu8fL/BcxYKKpJH6n45iuAZfOFv+QPbPXf5n9KRxZIyOq4hvvInMrM9DjjOXSANGrsZNuogqhhgfFYDWgtIyjDvgm6gMT178Yx/Ur9HY7hj9UAskoRF75DO3qdrLcmBWhpWFCkue4xqgyfKBi6QwmBKKOTc/cKKkBuyDZN22MbmNhuHKlc4JmsxpGCDME2doPhVOaMMrOh7g33+15VkD/hkbmHeWx8iYKBMcCtoOq4RfnKfBDfAbAhbiyJogR5w72jnKp8aWpyzFANznUlMTpz+W3CcdC87Hnzs9Fizz5d7qg3l+GncWCsNx2wkrG/1+ObwckkvkC4KTfLYTVTmuo1KqAS8HhGI7pT1uszR8q2nwg9/wgPmfHb9Qr
 /4MXSzKJ
 R2e+TG0/1TA6CeLUFUxU6sqtNkKTYgk2l1Gb0GHB7UGFkSrYP7mPWK+CbudRPwvqUOCnPS2BUauhmyahW6GttmIqMODqEyCKQJnfJyY30DQb+NohsHoWuUbtB0P7r5tkQL9JZahajxn8q29w6ga9j/3hrLYy+S/dGJ3Z163MG0SSNdsS3bcWsew0OFaOwL3IkKO8m0JuomdYk855KwrFuKg0AAQXqmVauu+ZkSGZwoMpXeJq1m1U3qNIW/8L8zs7+GrIUIxYGJ3ZiEbmtXMnIuyxQkHaYLn6FzGY/LUjYDZQuBghBSUKe70A8fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's stop using the page lock in balloon code and instead use only the
balloon_device_lock.

As soon as we set the PG_movable_ops flag, we might now get isolation
callbacks for that page as we are no longer holding the page lock. In
there, we'll simply synchronize using the balloon_device_lock.

So in balloon_page_isolate() lookup the balloon_dev_info through
page->private under balloon_device_lock.

It's crucial that we update page->private under the balloon_device_lock,
so the isolation callback can properly deal with concurrent deflation.

Consequently, make sure that balloon_page_finalize() is called under
balloon_device_lock as we remove a page from the list and clear
page->private. balloon_page_insert() is already called with the
balloon_device_lock held.

Note that the core will still lock the pages, for example in
isolate_movable_ops_page(). The lock is there still relevant for
handling the PageMovableOpsIsolated flag, but that can be later changed
to use an atomic test-and-set instead, or moved into the movable_ops
backends.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h | 25 ++++++++++----------
 mm/balloon_compaction.c            | 38 ++++++++++--------------------
 2 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 9a8568fcd477d..ad594af6ed100 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -12,25 +12,27 @@
  * is derived from the page type (PageOffline()) combined with the
  * PG_movable_ops flag (PageMovableOps()).
  *
+ * Once the page type and the PG_movable_ops are set, migration code
+ * can initiate page isolation by invoking the
+ * movable_operations()->isolate_page() callback
+ *
+ * As long as page->private is set, the page is either on the balloon list
+ * or isolated for migration. If page->private is not set, the page is
+ * either still getting inflated, or was deflated to be freed by the balloon
+ * driver soon. Isolation is impossible in both cases.
+ *
  * As the page isolation scanning step a compaction thread does is a lockless
  * procedure (from a page standpoint), it might bring some racy situations while
  * performing balloon page compaction. In order to sort out these racy scenarios
  * and safely perform balloon's page compaction and migration we must, always,
  * ensure following these simple rules:
  *
- *   i. Setting the PG_movable_ops flag and page->private with the following
- *	lock order
- *	    +-page_lock(page);
- *	      +--spin_lock_irq(&balloon_pages_lock);
+ *   i. Inflation/deflation must set/clear page->private under the
+ *      balloon_pages_lock
  *
  *  ii. isolation or dequeueing procedure must remove the page from balloon
  *      device page list under balloon_pages_lock
  *
- * The functions provided by this interface are placed to help on coping with
- * the aforementioned balloon page corner case, as well as to ensure the simple
- * set of exposed rules are satisfied while we are dealing with balloon pages
- * compaction / migration.
- *
  * Copyright (C) 2012, Red Hat, Inc.  Rafael Aquini <aquini@redhat.com>
  */
 #ifndef _LINUX_BALLOON_COMPACTION_H
@@ -93,8 +95,7 @@ static inline struct balloon_dev_info *balloon_page_device(struct page *page)
  * @balloon : pointer to balloon device
  * @page    : page to be assigned as a 'balloon page'
  *
- * Caller must ensure the page is locked and the spin_lock protecting balloon
- * pages list is held before inserting a page into the balloon device.
+ * Caller must ensure the balloon_pages_lock is held.
  */
 static inline void balloon_page_insert(struct balloon_dev_info *balloon,
 				       struct page *page)
@@ -119,7 +120,7 @@ static inline gfp_t balloon_mapping_gfp_mask(void)
  *			   balloon list for release to the page allocator
  * @page: page to be released to the page allocator
  *
- * Caller must ensure that the page is locked.
+ * Caller must ensure the balloon_pages_lock is held.
  */
 static inline void balloon_page_finalize(struct page *page)
 {
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index a0fd779bbd012..75763c73dbd52 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -20,15 +20,7 @@ static DEFINE_SPINLOCK(balloon_pages_lock);
 static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
 				     struct page *page)
 {
-	/*
-	 * Block others from accessing the 'page' when we get around to
-	 * establishing additional references. We should be the only one
-	 * holding a reference to the 'page' at this point. If we are not, then
-	 * memory corruption is possible and we should stop execution.
-	 */
-	BUG_ON(!trylock_page(page));
 	balloon_page_insert(b_dev_info, page);
-	unlock_page(page);
 	if (b_dev_info->adjust_managed_page_count)
 		adjust_managed_page_count(page, -1);
 	__count_vm_event(BALLOON_INFLATE);
@@ -93,22 +85,12 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 	list_for_each_entry_safe(page, tmp, &b_dev_info->pages, lru) {
 		if (n_pages == n_req_pages)
 			break;
-
-		/*
-		 * Block others from accessing the 'page' while we get around to
-		 * establishing additional references and preparing the 'page'
-		 * to be released by the balloon driver.
-		 */
-		if (!trylock_page(page))
-			continue;
-
 		list_del(&page->lru);
 		if (b_dev_info->adjust_managed_page_count)
 			adjust_managed_page_count(page, 1);
 		balloon_page_finalize(page);
 		__count_vm_event(BALLOON_DEFLATE);
 		list_add(&page->lru, pages);
-		unlock_page(page);
 		dec_node_page_state(page, NR_BALLOON_PAGES);
 		n_pages++;
 	}
@@ -213,13 +195,19 @@ EXPORT_SYMBOL_GPL(balloon_page_dequeue);
 static bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
 
 {
-	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
+	struct balloon_dev_info *b_dev_info;
 	unsigned long flags;
 
-	if (!b_dev_info)
-		return false;
-
 	spin_lock_irqsave(&balloon_pages_lock, flags);
+	b_dev_info = balloon_page_device(page);
+	if (!b_dev_info) {
+		/*
+		 * The page already got deflated and removed from the
+		 * balloon list.
+		 */
+		spin_unlock_irqrestore(&balloon_pages_lock, flags);
+		return false;
+	}
 	list_del(&page->lru);
 	b_dev_info->isolated_pages++;
 	spin_unlock_irqrestore(&balloon_pages_lock, flags);
@@ -253,9 +241,6 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	unsigned long flags;
 	int rc;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
-
 	/*
 	 * When we isolated the page, the page was still inflated in a balloon
 	 * device. As isolated balloon pages cannot get deflated, we still have
@@ -293,10 +278,11 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	}
 
 	b_dev_info->isolated_pages--;
-	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
 	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
 	balloon_page_finalize(page);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
+
 	put_page(page);
 
 	return 0;
-- 
2.52.0


