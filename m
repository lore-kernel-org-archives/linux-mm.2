Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 300A0D2ECF8
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A60E6B0318; Mon, 19 Jan 2026 18:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8763B6B031A; Mon, 19 Jan 2026 18:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA086B031B; Mon, 19 Jan 2026 18:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63D9E6B0318
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:02:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FF5CC178C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:40 +0000 (UTC)
X-FDA: 84350239680.07.3E676C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 640981C000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mdfux5vZ;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863758; a=rsa-sha256;
	cv=none;
	b=vvqPeBeMgUTjIttRHGobMCF0NhevujZGQJkl3x/S3a1dYmaTb/AHK2k+hUSqkh+2JfluN8
	I/bTnxj6qYu3S21/8YGC+4JkX02B8FIQrBO7xgPa9aIlrr+GHqoGZBvLBswXpLGMk3hfXi
	GTkZdZrg/4tgF1AGWSHAucUJ7RTchYE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mdfux5vZ;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kh1/3Ui1Xk68EaIrgSrRaHQVN+vta/qab0vV1kLWoJA=;
	b=NU5X9qvzP3+1G5cCt5uS41V3zyhjTIRCGSvZwrmbhczbl2IQKHtUE+Vx3NehglN1NvUsFW
	mqn9biT3q/RXojpQThY0IVe0KXAjBFMO8QAXKA4RYJgmRsv/kY/5r9cpEOlJALv2QmjJJn
	QdZofeJP4zT5oJj18nDMGnSspD+cMUo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DCD540846;
	Mon, 19 Jan 2026 23:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F4DC19423;
	Mon, 19 Jan 2026 23:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863757;
	bh=B4TNdno4jEZy7WvDrbla07FpWfPcmSGxCps73N2ttzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdfux5vZ5n1jk7Bajy/1xc69ZeTQqQnbFi2y1gt5UERRQfxL5CZMsGKqJTBXlAhOK
	 uwS0/uvJ0i0RuQRaRPbSQKJVqIJl5kCtqj0v7fV8X5883AvN1q6YK/w62hSb0OMWo/
	 geFefvkGbQXLvVddoTri0kLD7uuRfEijWUTBowE9kDpan3/Wq854GpwFVkfbb+rp3K
	 pXZUafSWF6kSJWt51UCzsnSwt7gNlPj4EjTjg0+Jr8VzBifR1e+hg2bKs+DFb/+R2y
	 5B7WhMN1s3OV75YhtLAU0a2oC0qAxjuuhbPYUH7IsPtXJV1v4Yjrp0WZcNelDBVdpI
	 eKqPibTCPYlXw==
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
Subject: [PATCH v3 08/24] mm/balloon_compaction: use a device-independent balloon (list) lock
Date: Tue, 20 Jan 2026 00:01:16 +0100
Message-ID: <20260119230133.3551867-9-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p9k4edbjwm7u8yqx6qd1rgatpbku1z1d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 640981C000B
X-Rspam-User: 
X-HE-Tag: 1768863758-427867
X-HE-Meta: U2FsdGVkX18IQwKgQEb6eWV3LoLb3gGC+hjIbv9F1iz1U4NJmusjyxhViS0vupf0EHwZ5TgtF5xcCoT5N6I4VAqSZytZf637gApiDPGi5zC6VzMRXpaBJyOUtdvMl9dGrpCMl7zJV0207p6aD2w8xncjwQnFrzON2gYY6U/30/UCRzPfN71gTMueUznK9z84SkblzAidsfa1bapZ5uX1+XCaSosfDcPd92ldMx7J3qZJ2kKMIBLJ//+sX/UBIAYgqhiFYh6E5e780ksvDFlitChjSPq7ESo9r3UxtA/f9r/9KHmdmKW44eATC2Lv0g4q+7giP29A7udETxnwgvjHUScVUFFCTP2ecYQu9jaHnHhq/IEAjwP6jrhZMJZb5U8e6AeIjgDeHn7r0enzxppuGJa/5X425QlCe2n7+yGyzSShl33By25lyMSPrLPBkolimCCMWJyHjjm3VucAcfFtjE/SkDXTWWvQO9nGnG72MqqAK9itZHeEh4PqfjxPWIy8J3A3i6BAKljf0NVY1BTQEJcFgJlmaG7oR7NUvPaV/Jwng99yl5zFjNeQM0XodMkP3Kq/otHnp/Eljl/bqDmVJYxfMRkNxZO73d6y/EozFps3HreQK0J0fAlcetVbyBCtufA4WoWtw1sAd3cQ+WSmw4NVh+FaDb1FXdN7m5dOmDvcLkMzE+nVh+M2zdIRNjjqQ6niMLdL9iBzuPFja6ESOeVMGLCpojh/s8PfAHcNChwFgZFNgHSDt8wgWY/U37nbMLCHWvSxW+cdTTtC5bFxwlDWVp1OeEkDjRshg6SiI8AawmPEJZFYrkIUatiLESGvEwtw+DJvskA/+vGFZ7bWuZ0O5/GPWHA2u1I5sx0UfnoqHQDn2xIZUsAvTc62bQqmPJQTEdZdIoY7X8vR9ypJCqyYBfgmL3Nb4W1lta9IMIiRtEYgyajBYv40fxP+TGLlBJXQWLfy8J1Z5uK5rFX
 ZPLyUPoc
 tXxScjfjDo42e1HZBLknalEBMLV6xx9nm7pzxGMlJ0QxkajeQTkpnRVjeZlvQJtyHRMRXevdyAJ/EkW/rq9DeyQVS7FYyJvNJsuV7IpSknGYubBay9ki9eE++cf/nAbod9JGwL+DR/ihzrfVM1hm0fEcJYzux/oRuBecfqiClIcCzFjmxAGGOO3pA3tYAhqcE/DXK2IQT4pCmrDs04wWYlWRvcxyB2TuGpu5oZXOo8IGqZqaIAx0N8vVJXwXlKtDYWiSh1GiLiQ+01jVlVbFBGahamJwWL9FU7uL1/dsDW8kdB8+42l9iiXb/KA==
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

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h |  6 ++----
 mm/balloon_compaction.c            | 34 ++++++++++++++++++------------
 2 files changed, 22 insertions(+), 18 deletions(-)

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
index 4fe2a0cff69ec..a0fd779bbd012 100644
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
@@ -234,10 +240,10 @@ static void balloon_page_putback(struct page *page)
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
@@ -262,7 +268,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	if (rc < 0 && rc != -ENOENT)
 		return rc;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	if (!rc) {
 		/* Insert the new page into the balloon list. */
 		get_page(newpage);
@@ -287,7 +293,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	}
 
 	b_dev_info->isolated_pages--;
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
 	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
 	balloon_page_finalize(page);
-- 
2.52.0


