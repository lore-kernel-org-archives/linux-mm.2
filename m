Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2B10D2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 568F06B0324; Mon, 19 Jan 2026 18:03:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A736B0327; Mon, 19 Jan 2026 18:03:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F206B0328; Mon, 19 Jan 2026 18:03:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4476B0324
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:03:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E62FC8B043
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:28 +0000 (UTC)
X-FDA: 84350241696.21.6B1D97C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 63817100007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LmwfS+Wr;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7aTMbYWfNQHLu1AMyAWpUifXZZtc+CG9rWyxw3p7js=;
	b=IRvICL6UuSdDSCXN2BdAL4U9FLzaThOEgvM2nEx+2zo4ZCwfh0e2VLBtGF7I8jNhPeNwaQ
	8pu8v7OlA+9hO8GeXzGd44RxBNDsZZLRN8+YsTfDiuDzUaEY4/AF2wbIB5bp5lsNj5TRcK
	ERwX8zDRbMaclsqE5eTlAasdJy1AIF4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LmwfS+Wr;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863807; a=rsa-sha256;
	cv=none;
	b=E6kFo9JOzx21jElvrzNES8jNZ0DZKTeoe/zCcBwBu+AMcuBdFndEj5hAQwfQidqHU3ZfVp
	+dylIYOwRZL9jxiJoZLc6C1NijEO/jS/ZAMJxGVpjWlH9MUICRJWrNTLzmUM4WeX08qpTv
	XTOCnwI1hsQuX5JnMMMHmKWjwxro3xw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0ECE60151;
	Mon, 19 Jan 2026 23:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0196C116C6;
	Mon, 19 Jan 2026 23:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863806;
	bh=8Lw1LCv6YJ97mwCYs+lybDIcRNkq6gN9hctm9VzKy2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmwfS+WrZI/buk9JY+CG7Jfxa+mafIdXePK6bEkhmIlnJ+IMvH2Y8ZDXMtul2RIKG
	 tAXnPAcwQ9mY6U9oV3qSMJOaVmCHgcjGnYuCxhCRZSwYTb+lL4rS8Qo84Phz8UcPUl
	 BUsP/xpxRW5qZyDTKZ+LFa3DIy30EW3PFsZhLLEH3SHgxaY+qs3OoEVegAzEK5T5sP
	 jnGj7Y/mfg3jJktddW1FJTE3RLD+7OGYSiYz42eQRca+mn/v8/pvZfZzxvTsu0fk68
	 nYoO4CGE6uAe3mWMicqWpFMVwdFxMeFFJzqGzfQzmNrDHTgvy1uUUUQP/KG6HfGtmu
	 P4cf1xckiw3vA==
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
Subject: [PATCH v3 15/24] mm/balloon_compaction: move internal helpers to balloon_compaction.c
Date: Tue, 20 Jan 2026 00:01:23 +0100
Message-ID: <20260119230133.3551867-16-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: aex1wbsse1uobbujihs8i7dcd4pmfy5r
X-Rspamd-Queue-Id: 63817100007
X-Rspamd-Server: rspam04
X-HE-Tag: 1768863807-937073
X-HE-Meta: U2FsdGVkX1/YgHWl3ry3rxJqozUM4hTKHaZX1qRhvYObDE8hekWOZDk2o43ras3YTbYo/rEAbbBVSzRtONClk5wNXXzV0j/VWy7QXXQcGafiHjmwYuitpNEwPgyIVko8AlwYmMSgM+SvF0FX5Zu2QMjJt5CczlE2thYPyog05XeWTqUikRCyQnIZJY36Sg1UOFzOUY0CyAb06el9LBrpvvSS7FFKh95gbrnrodUBodVknEC7AbISwAD7v5cBCgzoHxonfunh37mW3LhQT+P9GQuVPg8G1jgEQlGBo9HUyfhhCNL7QJEDKPCJAJs625u2fwIDbcb0CmFWl1j5Rn0EHr/C+XZAO0qMOZFP/hCHGdTXHD4fEG6Erp8+kDlL+agzWRFYFgMwXesUzJ2aJk2hIjc7oXFAjO9dP1b7Ue8d4C5ejRNK1iFmR6Apw1dl86C6N64YEzp0lo9DxXnBS9oIOtSoqIJaLXj1BIIcHVodF2Y43VXDzB0Z5h61bK28nuVTmEI8S0ggPDV1DNEGObLFljsslNQj3HSGvBQ0AK0NwrASzMYuOFzSDjyhd7Riw5jpLlrIzfgpOfthAcKhHuxwuvsfZuYiEmvGptnbflRoBEqs57aOI1smnpQsG/y99lcFzjw4aUKc5WLlCpUiOzE4sGpI/k5EJUibDVIdqJScJoTUXeOi/U390/r7laYrN9ZE7jRFiIS6xQgbbgfQ5MLyKBjPHUfMMCnrfDwpmjOeKHLKP8IGo9W21uzP+hEU0HWjozzftvfMjvj5NYN+DzX6lNdrDMRrOU2Te+A7oDHZmmwDBObpycaVFJ+IbZuqEFoOYKbdiVVAaHazPaJH8SgVO0dLuGJn+4zpkxHteUh41X7PgY9rs0dYWooMln4mRc7sXNBJOwTB4heDy51dU6QhNXmQ2llGwTu8BnXGv9iEC41a+TGgU7iiOAnuXbgoZ1BG1vHMaRzSfMS+auIcyh6
 AJlT/iTd
 O+v6y3DwXpMEurvEBnE2L5inf2ThdBPC3WF4Fob3VamsYtl5iaL43KbIUhEp+2+MQLi++8OHJ0vLVehA8McSZjG1nV31ZniqaTyrkd1DE5hLajAXmZVZVX3iHpYQVTFjv1kuLu1QelZAKK+PT03dSBOeoTHdvUNk0axlrGZ23hzPeThS+p+o4wENSKBzlaBODsT7IbJEATDbK55pkQgaCMP0Dr2la2UbvgihA1YSmaUEBpLQFF4IOJiPR3SlHLATC+aPYe2t4F8ETJlLNMWfIPzK3jbcTffCKaJXIFRIVz7813pNiLk8elxMC+iq+P1y7n9T2HPlSpHQJ7MU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's move the helpers that are not required by drivers anymore.

While at it, drop the doc of balloon_page_device() as it is trivial.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h | 44 ------------------------------
 mm/balloon_compaction.c            | 38 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 44 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index d1d4739398978..eec8994056a44 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -75,48 +75,4 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 	balloon->migratepage = NULL;
 	balloon->adjust_managed_page_count = false;
 }
-
-#ifdef CONFIG_BALLOON_COMPACTION
-/*
- * balloon_page_device - get the b_dev_info descriptor for the balloon device
- *			 that enqueues the given page.
- */
-static inline struct balloon_dev_info *balloon_page_device(struct page *page)
-{
-	return (struct balloon_dev_info *)page_private(page);
-}
-#endif /* CONFIG_BALLOON_COMPACTION */
-
-/*
- * balloon_page_insert - insert a page into the balloon's page list and make
- *			 the page->private assignment accordingly.
- * @balloon : pointer to balloon device
- * @page    : page to be assigned as a 'balloon page'
- *
- * Caller must ensure the balloon_pages_lock is held.
- */
-static inline void balloon_page_insert(struct balloon_dev_info *balloon,
-				       struct page *page)
-{
-	__SetPageOffline(page);
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
-		SetPageMovableOps(page);
-		set_page_private(page, (unsigned long)balloon);
-	}
-	list_add(&page->lru, &balloon->pages);
-}
-
-/*
- * balloon_page_finalize - prepare a balloon page that was removed from the
- *			   balloon list for release to the page allocator
- * @page: page to be released to the page allocator
- *
- * Caller must ensure the balloon_pages_lock is held.
- */
-static inline void balloon_page_finalize(struct page *page)
-{
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
-		set_page_private(page, 0);
-	/* PageOffline is sticky until the page is freed to the buddy. */
-}
 #endif /* _LINUX_BALLOON_COMPACTION_H */
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 1843e168db3ca..e0a4b481c3eda 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -17,6 +17,44 @@
  */
 static DEFINE_SPINLOCK(balloon_pages_lock);
 
+static struct balloon_dev_info *balloon_page_device(struct page *page)
+{
+	return (struct balloon_dev_info *)page_private(page);
+}
+
+/*
+ * balloon_page_insert - insert a page into the balloon's page list and make
+ *			 the page->private assignment accordingly.
+ * @balloon : pointer to balloon device
+ * @page    : page to be assigned as a 'balloon page'
+ *
+ * Caller must ensure the balloon_pages_lock is held.
+ */
+static void balloon_page_insert(struct balloon_dev_info *balloon,
+				       struct page *page)
+{
+	__SetPageOffline(page);
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
+		SetPageMovableOps(page);
+		set_page_private(page, (unsigned long)balloon);
+	}
+	list_add(&page->lru, &balloon->pages);
+}
+
+/*
+ * balloon_page_finalize - prepare a balloon page that was removed from the
+ *			   balloon list for release to the page allocator
+ * @page: page to be released to the page allocator
+ *
+ * Caller must ensure the balloon_pages_lock is held.
+ */
+static void balloon_page_finalize(struct page *page)
+{
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		set_page_private(page, 0);
+	/* PageOffline is sticky until the page is freed to the buddy. */
+}
+
 static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
 				     struct page *page)
 {
-- 
2.52.0


