Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A70EFD41149
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FB86B009F; Thu, 15 Jan 2026 04:21:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14BC26B00A0; Thu, 15 Jan 2026 04:21:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C396B00A1; Thu, 15 Jan 2026 04:21:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E40606B009F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:21:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9204916018B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:15 +0000 (UTC)
X-FDA: 84333654510.05.CC5E979
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CF7AA20011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b74dktIU;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bfyUmKxsaaIybHvL6KFj0KJR/pg0dI6gbAgIin0FmU=;
	b=yehu90asXkVX1/M6I5TdOzAH5qjCn+Kq/MDCATvqCzQhSc3+zVqIWw4Ax2u8h8yrODfXDm
	e/bch5II25oBVXgNZ9bbDlYRo4tR18fUEXEeVO2HCNgGX7xWnIexF6jnYSqI83GLtw/neC
	K66ptRwrSmc6nbYkVdBghCVQ7xRG5LA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b74dktIU;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468874; a=rsa-sha256;
	cv=none;
	b=TdotvzA528xZlU9dJ8GjLlloikqbOG+tum43il18S6meWzgyxKPWwiDCwOpp6PsuXwr1ek
	xN/emRwMDkk1X7tyOvKSnp8otJNhS+n0a4b0YaqktX8XQ5mucc/e0UiofWGMvBHoHDGzB8
	/UPRAZpfbl2djClLtbEKqS7NrBfN5LU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D222040572;
	Thu, 15 Jan 2026 09:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9128BC19423;
	Thu, 15 Jan 2026 09:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468872;
	bh=8ti3mJv0LiaEwwkTaTPC1cxyUqgx/Jz/5UzObtQLdtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b74dktIU4BKKrC0Pn+Xqur68BVJP6BlafX0QNU8fZyTeKal5T7//ku1ZsvPcnRecR
	 6z1KsyRRJH42o2DkcOh5L5OZWNV1+pCFr8qq2LqFiaBLirtqHNnMarZiANcxgxldSv
	 yiUMRTtzpnR8vXxomAGxYsAaxmOUkdT3Dd5bxyhJyoi+gnGclqyvlrg5/74DfoMcY+
	 +svVNN1YJpBTbggGX0OnEStoIXVPQS+pHiIIa6YNnPkhCJC/Dc64SCW8WC5QVRJgkR
	 suL+zMFePEWvulaXtgcbZl6FZOClfVeoGduF0bnLMGCZiKOW68KSf/Y3TKq5c+nqa1
	 /72QY6YlMNeEA==
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
Subject: [PATCH v2 07/23] mm/balloon_compaction: use a device-independent balloon (list) lock
Date: Thu, 15 Jan 2026 10:19:57 +0100
Message-ID: <20260115092015.3928975-8-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 16e5idno9tnm1ra4omnmn79m465rbnnn
X-Rspam-User: 
X-Rspamd-Queue-Id: CF7AA20011
X-Rspamd-Server: rspam08
X-HE-Tag: 1768468873-568459
X-HE-Meta: U2FsdGVkX1/XFpPkC9CP5i1By5fgMUdMuADSKKJ5HmB2eniEfiPRa+V7QvtWhMZYqR9TGPA9Rt7bvI+8NFTWCgHAOPwKZ7s3OrB47wWQAEYcr4cZJniGJRAYesFI7EU5P1n5+RZjGclWEzph4ojmEKjve6Dbq4Gb+HpnAeZGahbsk+HnOqPK7IDTkFjUC0oX4TxRvcJt6pIUaieYVuiOty6B7dd8lpaveoQHOk0V8enKXijs0ST7TG2KzA68AbDHdJgKRspyPwjocxxrQVoOj5pgYngx33ZPabjI1kspxiQ7sZNT5o884Pkr+dVUpJ/FiYxfG/Kns3u8xp5SQtDyXWzTEk5MIg2+WcVJVMQHPd/63k7pbaqqmH9Tpp2THLlzGDmXyeDfYASFhhvJmOIBweWZ/EDLjURLg06HdV15TJ8b8wr9Jn6Z/x5T6MhzD/0abtWWdMONK1mBhFwtrp9BC33LCxse63RZqkSKuU/9TUVNTeZC5QClRpLUmHwDPQPnJwhpYypOKryxUmbGGIcIn5beIV3CZTfFnEyz4RbZhqYLlMWF2qeF7Ugm6LKB4w4MF9+bEGDf1RKcofAKMkdy53XMSZ4MFFx1Eiy/5NaE8xQhB4zTNgooEclTXDahi+iuXVTGpZQUV/Yiykgu0EFmp0vtMZEIccWBSoZVmhnKUiQ243QChGZiwOH3ycnXQM6RKFbco+auiubmbI594y3X0ut5mgMjuRdAHzWPvw6I7oPw7PHlSSJR95e+HPxpqGvzx4knHiFv06VheS+M42UPHlsFFNo+3FBcNdFi/HW7BiQ+Bh9ZTorJ0/buldxFQRYwcSIXcxi3BCuUgOw5bboTy9xMXTsP1DPJTacbxAfQTyQlyKkPY+h3SM4Eelouy7cRy3e+xCoTpaDycfDLrYVABPHDzLj1aUlb4ISmohMVnTZmmAM7pVVe1kjA3YOjgMjX1OtU3YtlmRPK32wgFs6
 IpL3/zvm
 md/Nw8RZLE3CIt3RWHy8xsBHOIA+sc9vfSIuJrscQvjsDwkgjD5BvtTVYuExqsIH8Au8hkYhokK0y1bMDA51tu8yoVntxHQZ/wZUPrWuJ/1Ja+8DMpUY0JzbKGFUzkDV5a88TWekm4KmwsUEpTv8kKQlxGLPcqQWVL0YmNObSCfcWt0Vkva/EuCcMA5Jkv9J+QXQ+2Hle9yyYqJZJ0J9jXfvgNYVQSt57A03chQvC2EsAGH3d88OpAi4PvASKR4hRq9EU6WgIXcJpI0yCe00iZ97pVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to remove the dependency on the page lock for balloon
pages, we need a lock that is independent of the page.

It's crucial that we can handle the scenario where balloon deflation
(clearing page->private) can race with page isolation (using
page->private to obtain the balloon_dev_info where the lock currently
resides).

The current lock in balloon_dev_info is therefore not suitable.

Fortunately, we never really have more than a single balloon device
per VM, so we can just keep it simple and use a static lock to protect
all balloon devices.

Based on this change we will remove the dependency on the page lock
next.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h |  6 ++---
 mm/balloon_compaction.c            | 36 +++++++++++++++++-------------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 3109d3c43d306..9a8568fcd477d 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -21,10 +21,10 @@
  *   i. Setting the PG_movable_ops flag and page->private with the following
  *	lock order
  *	    +-page_lock(page);
- *	      +--spin_lock_irq(&b_dev_info->pages_lock);
+ *	      +--spin_lock_irq(&balloon_pages_lock);
  *
  *  ii. isolation or dequeueing procedure must remove the page from balloon
- *      device page list under b_dev_info->pages_lock.
+ *      device page list under balloon_pages_lock
  *
  * The functions provided by this interface are placed to help on coping with
  * the aforementioned balloon page corner case, as well as to ensure the simple
@@ -52,7 +52,6 @@
  */
 struct balloon_dev_info {
 	unsigned long isolated_pages;	/* # of isolated pages for migration */
-	spinlock_t pages_lock;		/* Protection to pages list */
 	struct list_head pages;		/* Pages enqueued & handled to Host */
 	int (*migratepage)(struct balloon_dev_info *, struct page *newpage,
 			struct page *page, enum migrate_mode mode);
@@ -71,7 +70,6 @@ extern size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 {
 	balloon->isolated_pages = 0;
-	spin_lock_init(&balloon->pages_lock);
 	INIT_LIST_HEAD(&balloon->pages);
 	balloon->migratepage = NULL;
 	balloon->adjust_managed_page_count = false;
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index fd9ec47cf4670..97e838795354d 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -11,6 +11,12 @@
 #include <linux/export.h>
 #include <linux/balloon_compaction.h>
 
+/*
+ * Lock protecting the balloon_dev_info of all devices. We don't really
+ * expect more than one device.
+ */
+static DEFINE_SPINLOCK(balloon_pages_lock);
+
 static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
 				     struct page *page)
 {
@@ -47,13 +53,13 @@ size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
 	unsigned long flags;
 	size_t n_pages = 0;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	list_for_each_entry_safe(page, tmp, pages, lru) {
 		list_del(&page->lru);
 		balloon_page_enqueue_one(b_dev_info, page);
 		n_pages++;
 	}
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 	return n_pages;
 }
 EXPORT_SYMBOL_GPL(balloon_page_list_enqueue);
@@ -83,7 +89,7 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 	unsigned long flags;
 	size_t n_pages = 0;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	list_for_each_entry_safe(page, tmp, &b_dev_info->pages, lru) {
 		if (n_pages == n_req_pages)
 			break;
@@ -106,7 +112,7 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 		dec_node_page_state(page, NR_BALLOON_PAGES);
 		n_pages++;
 	}
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
 	return n_pages;
 }
@@ -149,9 +155,9 @@ void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	balloon_page_enqueue_one(b_dev_info, page);
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 }
 EXPORT_SYMBOL_GPL(balloon_page_enqueue);
 
@@ -191,11 +197,11 @@ struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info)
 		 * BUG() here, otherwise the balloon driver may get stuck in
 		 * an infinite loop while attempting to release all its pages.
 		 */
-		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+		spin_lock_irqsave(&balloon_pages_lock, flags);
 		if (unlikely(list_empty(&b_dev_info->pages) &&
 			     !b_dev_info->isolated_pages))
 			BUG();
-		spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+		spin_unlock_irqrestore(&balloon_pages_lock, flags);
 		return NULL;
 	}
 	return list_first_entry(&pages, struct page, lru);
@@ -213,10 +219,10 @@ static bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
 	if (!b_dev_info)
 		return false;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	list_del(&page->lru);
 	b_dev_info->isolated_pages++;
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
 	return true;
 }
@@ -230,10 +236,10 @@ static void balloon_page_putback(struct page *page)
 	if (WARN_ON_ONCE(!b_dev_info))
 		return;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	list_add(&page->lru, &b_dev_info->pages);
 	b_dev_info->isolated_pages--;
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 }
 
 static int balloon_page_migrate(struct page *newpage, struct page *page,
@@ -253,7 +259,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
 	switch (rc) {
 	case 0:
-		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+		spin_lock_irqsave(&balloon_pages_lock, flags);
 
 		/* Insert the new page into the balloon list. */
 		get_page(newpage);
@@ -272,7 +278,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 		}
 		break;
 	case -ENOENT:
-		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+		spin_lock_irqsave(&balloon_pages_lock, flags);
 
 		/* Old page was deflated but new page not inflated. */
 		__count_vm_event(BALLOON_DEFLATE);
@@ -285,7 +291,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	}
 
 	b_dev_info->isolated_pages--;
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
 	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
 	balloon_page_finalize(page);
-- 
2.52.0


