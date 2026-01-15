Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D91D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647A96B00A0; Thu, 15 Jan 2026 04:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BD26B00A2; Thu, 15 Jan 2026 04:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528026B00A3; Thu, 15 Jan 2026 04:21:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4136B6B00A0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:21:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A68416018B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:22 +0000 (UTC)
X-FDA: 84333654804.09.0C2FA61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78564120002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y80rnCdR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468880; a=rsa-sha256;
	cv=none;
	b=8mJjr8SKurvS0MAWrLye6qq3efEKu4YrHlBih3+k7OsN+6A95KoOX/nplB7Ae4cFCS9ry0
	ZAv6/JlOwIP2vhUrCrIyyeZDXZXjG34nggT5xS21HzLllcf/JmRY8NZmw58gDxGASooVkD
	WfkKSiFFmqDFkFrQZrs/jKdeHFVkG7Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y80rnCdR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJziUzGzHf4QWNPduhl02b2b/9RHNUokTHG7NwHEsoE=;
	b=scokkh/yz2wxbi5bd3AQm6wxDY7w9HGzEsngir7yekqII3LLnr0VdMn3Ckhu608cF5yJhb
	AmvojrIRk4aHF6SgFH7QfVpZi0D+2+ooxDew9wjqCGsHxakWGt/8WhJn02fgWcpL4cBDlv
	nEbVWzsiVguWzx29xFBckRCxHZt05EY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB48C601B4;
	Thu, 15 Jan 2026 09:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38841C19424;
	Thu, 15 Jan 2026 09:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468879;
	bh=veUhuhby/6KA1wTGAfzOWG6HhKwBm4jTGxQAtB2JN04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y80rnCdR8i6QTBR4X0ercdmfP5fWPB/ngV2MfzPjAt7B4m60e7IbTK3/Ma6HEAuq+
	 QUt/zdaQlg8x9WbmdCyE1sH3CDUE0uvYEcknpWrgTAZozhHGsoLJPDpb7oJPVDvNYm
	 cTSTxYTkjE5k+V5e4y/uZBGp+CjbFhs2BoZrQGsyMt0JRiwN3JYXaAgGRy9AbkpsRO
	 fvOg3qiwVop/b+rEqyMGRAQwYYQxQJ0C2j4H9vtBT0KX4WqgnY1Z3UUawCkbnIEm7d
	 l6M4kuVPU6Qv2aD32llalJ8A6qICE4gMEFFcRL1cZWM2qAfD7F1hy9tMSg6ctz2fWC
	 UFh+UyNyfdFkA==
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
Subject: [PATCH v2 08/23] mm/balloon_compaction: remove dependency on page lock
Date: Thu, 15 Jan 2026 10:19:58 +0100
Message-ID: <20260115092015.3928975-9-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 78564120002
X-Stat-Signature: u3cpkebpjkkiwp6atrdp16bo4z69wi4g
X-Rspam-User: 
X-HE-Tag: 1768468880-441092
X-HE-Meta: U2FsdGVkX1/LV2Sqb6QDjs+1wQlGiK1ABtBF8P392/0PDw38vONLXk+wmemplmRQ6sYRUFe8RGMfg5Sp8cJtKv/2ASO/vpYlymMT7tB0g8D9e5L59Veq2fYBHVqdQCqEzCDDmzh7erlx1dHNqZnFGCSpkVLdmYfp/ZPkzleP5I0xhLLXXIyU/j9v8n2K70V5wloKmE2V/AS4XusMpRVY6rldCtNIXvIMziUgluvusTQLn5hY7WaANR30hnY21+in4jzzC2vYVFbR6FnscYy99Zb4g8YXE5wkzxeUdvrx0fkpgCKTJW2N3MgL7bQsVJaXn7KFWpSXBPi/jVov187HFkJMPDb4YaGSWPGlnkdGNLbmenUDn7IOplaGUR70Fe5SWyvhz7hZCHYpDwiEZ5tu9K/vXP7R/Y+wqD5h0pnYuIZzIvOGg54tfVZQuDadwWoIezDobO2s6rDJDxJXl4z3VI9QY/rMRDpv41QsMBwxAtElEnII43fw8a502EI07FKFQL44tJUbQlqRljqE4Jnb95k0YE4vgs1Cqklp/fOaKp0YQbp6NP91W2RQSqfGwN1QFZmSZDRY6LflEEdOlyWKW6uoCaA0I/TU0ZV6KEXI5h8LdycSRutKKN4MWoivrstWZmRluZA2A9YHZlLrZvW6fh49eOeJNWjFBMshweSuXyAk02V5N8719+LTNva9aelA4BmfBeXcsYUwk9c6bjFZI/IkWM7UNRfRjYigeKPUcs54UneQC0Q8/lAiyHQqAf7/wIzICogJx9eR8I7Q+xEEgdQ3Hre8JvfPHG3QPgkrfu1iLgSHWXRl5VOTk0Y8pL2CRRXLGGsjmVIbUrYCxivWIHMKV37/40lQu9sR7h5Xcouz/U7+JiKI4n3GLvL2OnBowFKXGwq7mmyVo0Jpux/AuCieAO2OtCqj6ZoOtpbM5osy33RKTJ2wmGg0dDfWnELXaFvaSQvqMzEUSwZRXjp
 Zfcl5wGE
 cMNXjysqaInkux5Q3YfG0mcTQ+ttjrdqkQDtAvHUxn9iQSQygageeGIRkcmv2WrXZ0CwPTjUVJLbcu7xEJNz3o4FZraxiIBzEpyUgWjP0s17JneOb/OBBGpZFgb7G2bzUeRJgGeXMwlaEf1PQMvFP1EQBWgQryaHNF3CMTw5FEdyDTspc8lJJVMZDlaZdx/kv8yLD39wIcp/0dscT73aRrgMD2qj9vdJ4BEjhCS6jIScVAUASW3V2thvNBOmiQ3RzI8KNjsZvtxRukFLLQDcdGUegtm1KjppcM/9xX4tGDviTldk=
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
index 97e838795354d..28ef0cb6b3bbc 100644
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
@@ -249,9 +237,6 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	unsigned long flags;
 	int rc;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
-
 	/* Isolated balloon pages cannot get deflated. */
 	if (WARN_ON_ONCE(!b_dev_info))
 		return -EAGAIN;
@@ -291,10 +276,11 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
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


