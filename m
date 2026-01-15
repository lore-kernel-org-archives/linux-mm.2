Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D9CD4114C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143906B00AB; Thu, 15 Jan 2026 04:22:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1048A6B00AD; Thu, 15 Jan 2026 04:22:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0117D6B00AE; Thu, 15 Jan 2026 04:22:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFE046B00AB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:22:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55EF6B76CF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:03 +0000 (UTC)
X-FDA: 84333656526.28.005C306
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 39949C0004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKaVkpLY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468921; a=rsa-sha256;
	cv=none;
	b=yuxsfncpB78bchrsPd+C+rhYzNLiA9o2b4tEOcox8TuC+TWrVoQTO89sSUvm5uYzoodUWK
	b/Ys1Vrxlpc7EDUOpL++camndrkm15U1LgmYKFAHS76apxrXwfkAxCXxhd4DKwCvPAVaiC
	KQ09Peq58O53Ae9Vxb9jdFPQgiVQruU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKaVkpLY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sf+38j4R5idOxt7NidpE6VdbC4a+MWvCfPDsI7M70HI=;
	b=qHmYyL8xdjUhx9d/dbdXS3aLJphqdM/lTZPAuElqyHsAhDvNFCzFEjfTLoofpd2fueDztj
	ah8fuGWBmSHd5LJvJdtc1FWgRkHfGhuNLsw7OnjcIjySCNbxPOr/zESK01yRYnmN8y/6EJ
	PeDo5uZjpXM9WC5MNIHYoNOAThoGrbo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63FAC4174F;
	Thu, 15 Jan 2026 09:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B265C19421;
	Thu, 15 Jan 2026 09:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468920;
	bh=qmPDA1ZKr0A977KNkEekwqrp6nf+Yo9xCkHHCXnhQZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKaVkpLYZ1a3BYGxfunPbIaVDY5pndtciPfSgAB/BhePVlAEfUrr6CiA5UIpqjHcr
	 kmNI7JUUl2rx4o9yjBHv4f8JAFQL27syiZ8kWqFd6rmmPgWA3RbIWxDfgOo+IkiD5o
	 pK1OJDf4An6gvFYEhr+GGr813wDfvbUy5FT0lfYcuKh4VDnOReppbSlvfiyuDOCYGp
	 L3NMhWKaw4b8FOM7iH/zTWS3t09K1rrQEXi5LG3OaQz8/P9lLQezpgeneCARWf88bl
	 EhtgSv7g7Io1ggc38r4OVzZboge+AOmiBCrMZnFqTM3LPlv3OsAsivXiZkI1xnUGte
	 pfrHvuy9E6z5g==
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
Subject: [PATCH v2 14/23] mm/balloon_compaction: move internal helpers to balloon_compaction.c
Date: Thu, 15 Jan 2026 10:20:04 +0100
Message-ID: <20260115092015.3928975-15-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 39949C0004
X-Stat-Signature: oimhd7skfb38r9w8a5sgwdcs3duhezci
X-Rspam-User: 
X-HE-Tag: 1768468921-242179
X-HE-Meta: U2FsdGVkX1/tkTggiGSf37GUPO/oaOHkBH9ANvegGa2kCZbQ5XSSd/IvI1sg3E/5RL/fvJlJAm0cR244VJdYOJPTlZQlf7HU9W9wS/aMRjyeRsABLr4/OSzUFFNK7NWTmvnY5tDCqgusoiMD9rQMK2bGUKJHnOt93AECxzNAZivV6YjmVXVep2quSDMxwzJInkQwPR9GW9ctNE9AxqBFt623ZMexDhtBuA6EdK7HvWtYzwU7cuekjUWHo4YFEUGZ6mmSQb1UMPBZ9ihmA9TasQoQqQnvTFXsHmqiwdf7LeeIhhbo/dlsTnPoqoXFvzuZpUi/Y0BnejNR0DXwTGxQSZu7gWyUosyHbJg6shcNsRcrXWR62b/dhqjhUr7bP/vfJ/5IIrTe18+HKoc10JRr86Qxuh6Qrt/RqmtbCgeMqlFGk74AkUxA8YEhROd/jVO+TBFZc8g2dDreNpv+NntO0M6KPWX7BiWYVnTIkGmYE6R8+jmv7zX/M3scxuAtlpDUVcM80FYS9wmoKiQL3VnF/G2Y15KXd0UM4lD4N8NBBlpEFbRtVZmvsEqIConqbTviZig+EvcvGvixna6Y4HRTRB/QCUplnvSBipaf+7auTLvjvFBL+M4aLY1NAJs8y1Fn1BD9v13XCZsBbjKU3hd5wY5O1W994uzR/FaImGhedOYAY77hu0o6lGnTmLjk/jY2mNmY1SxDD6tqNp+gGUcou2HrciU0bdzKyNFidK5dsCFv8NXDR5ZzYhHePoXxvuwY1CltxIVlDH9b1ApNv4E5Iz+uKmxQaCVWV0Y6eJOSpYr0MU/pWL3hM439MIbeckAzRG1NnTYAqZ4nNggXYyVJaX/FPIaYOu8mzQwi6kHTeEHzkiPHmhSi8gOq69HXooVcNCwnLJf5Ti6+6yyoWSqKpIYQ46akgtOqO/Pv9Fv3KltJ6SMwY3kaIa6vtS2aZUH4wrWLSph+jpjGbWE7FRY
 hLgdVy9J
 g7Js65x9feSAiy5PH4biwQIHzQOXyYCMqoP8MoR32LxKY9evLWKEmG+YSfDnMNnr1YcKAQ8dhU/oqf37ueThv1XGzlp8/Z+SrE1W4ESDCDDj0iodQ3Dr1ZFD80lZ80OkoSi/YB4DDN6ChFptMQImpaNDThGeW2qsAKRc51IP4zCyXjkFYDHdG/Y4rivdeoY2FNJYeQE93ZLb60diFlK63Gy5AKHODd2V9jkmNKtpm5vnAH6pHSYXlzXYytcF857nj1OLbcHE6lYqi6i6A8l76CUpYwUeVCN5J/sz/jh5vOG8RYowh/GiPHP7Iu89yTCGqqY50
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's move the helpers that are not required by drivers anymore.

While at it, drop the doc of balloon_page_device() as it is trivial.

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
index 709c57c00b481..717bc43732d09 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -17,6 +17,44 @@
  */
 static DEFINE_SPINLOCK(balloon_pages_lock);
 
+static inline struct balloon_dev_info *balloon_page_device(struct page *page)
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
+static inline void balloon_page_insert(struct balloon_dev_info *balloon,
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
+static inline void balloon_page_finalize(struct page *page)
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


