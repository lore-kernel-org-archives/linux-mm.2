Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C471BD2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C836B0330; Mon, 19 Jan 2026 18:04:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353D76B0332; Mon, 19 Jan 2026 18:04:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2601E6B0333; Mon, 19 Jan 2026 18:04:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1254C6B0330
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:04:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD25FC177C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:04:17 +0000 (UTC)
X-FDA: 84350243754.30.61CE059
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0BC71100009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:04:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oYhem+Ry;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgbObs8HDdumlKaDxCQZI2KxkSHb7dglw2VWFF79KHc=;
	b=7RqgoiILrevjisjL9idNKwcropuFh/GjpVFS1iQelttbeq1kN9iTNhje5HdSe5LAtZ5viE
	glT2f9DtarUy9nrzxmpdxEjCyWMum2gqvqHbIt038BUbQ8aNaJNGFlrFiErXtwhfefsWhF
	MnRApwqdKX8GwctojkTOzAacAUlHXyw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oYhem+Ry;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863856; a=rsa-sha256;
	cv=none;
	b=f5YhRFHvwHBdC4uLouwAHL03NCPWCzYekvS9eWj6rwTOY2Pnj3jTLdkGPUJmo6wKMAXhjI
	vZTYlci7s6nb7jj3wdc41kvtgr7FJvvboDeco9+H5+2TsiPAe1Keevod9DthFcUA1lU2kG
	x5lDSn4YYnzN26dxb8gH5jmsvf80T4M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16E8440210;
	Mon, 19 Jan 2026 23:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D026BC116C6;
	Mon, 19 Jan 2026 23:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863854;
	bh=rfLKWCy9vJo0cdwgW26hFt2Hmw6jpwEGhVTR8rbPNG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYhem+RyIfPYbRq/FfuQqbLgtWgy8BpIVjnZIFIo2pyBjNu0tkitvJixH2VAC5iwL
	 0udZb3Nwm9Nm9mnEfvtHLW9oTj17v3gePhwKqKsuwG2spWtGT7wrjMglu7Jk7xwwVL
	 qgc0gO5oasN5SIWAvQ+fmSdW5X/8qWWN/6b89nNhT8qBhxDZLcl0dhrwWMDIQKhrbL
	 4k0sEibe6agRVrTRCbUTDZod92Sk3LXFSBCuK4MfajLCooB3qJFV8miYoiSDHNq1rg
	 rRJf65xLWtvgrRdbaPTINUhuOO9OWGtADn303tSQQFRZaQP/O2FnwV9COpZS1oFNGo
	 4HRrRgQ99HmKA==
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
Subject: [PATCH v3 22/24] mm: rename CONFIG_BALLOON_COMPACTION to CONFIG_BALLOON_MIGRATION
Date: Tue, 20 Jan 2026 00:01:30 +0100
Message-ID: <20260119230133.3551867-23-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ac8itizj3qrrfinfpxd7fynxxukracrg
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BC71100009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768863855-151863
X-HE-Meta: U2FsdGVkX18VKhXTiVjxzAwPzOXyc4CLvOPFaYb48QE1Up4B8Sb/iX33cLvGO5DXpDJ/nL351Ubu+TZd9h8yMd8cQfr+n7ZJh6xl0AE7tQJDcm/1bMcm/liYhddptHid9HsO0gxF4Rc4KNv2s5xgbGDAmcogL7vdL1JFa56UXZ3QbKEGw3V5huPm/F/warBtVFL6Jao2OAjFhnthA+E0jEmM7T/29oVLqFCHSdHGDDqt8T7djKUBavvW6gxdeecltuB4UsRc8C2ndAaqt5Ka3Q21qKtMLYxeSe4vKbEgSQ8sD1u6nkETD5J8/SIbQqZqnK6iWD+7gqQNIYT0XTDoWmjkcTEMMuyqKeKaDhCmyGXe8XliGXWoyWFPJrUX550y8mAa4deC1Wd9h0urHoNxrGtQKEjKFTDa9WZdrdUVifugOiJF1wP556Z7dik87GEKl77pUgOlF7F5fqLEubRdgUoruyakb2r9MDVbnyZ+Q73/DwSAQZqciFi1x1yeir4nnhxcdzjK8Tsx1wAxNOpHg2G12mChpfAxDaZzgLvK55Sar/232hr1kCDs0VtNR1bL4NlTYzVFwBmZtr5QspqCLaKzCXthZrt9OxtYx3t0OzFI7PHd1PLDmWkIaTfwpr9YDMjgzwSW1cUJp+CsMzkot27ucNPMJqun10iKin2m2CSo8glAEGarbJ1Nxu8qZCI+oK4PLTjSahpbJjttkItQO3qQxcUumKMPx3M58Qn0pFuyQwHfbINg87qBrhBTGmC4zRTRauQubH1Uz34lE+W/VPiN2SPH1CIW+RBtW+FkqIZygo/g7XVJoJvVNVAGHtbC22ESFuF3MTWKNTqWB49v9HJ2JjK6P8v4YKAV7DpSVNGExmQxBuV+n7akZSBUkSbcaN4F8rzWOvPaZ19jiiy1F8qHqJ1RrcKmwXlOQgYXIyhwxnOjOlvUen3LoMGDsWJUfoBMp7MGkzjRW/qfSHK
 +36gei0X
 RNh5cm23pOPIGeXkRCyNd/pKA5k0RY5V24khYInMkLDu8l2c7Uv0BP3D/u5UfhOUy7yzF61IFkq+mgBPhBdmVa0Fto1m+/yLW79BEso7SEzRjwAP1Ujy0ns/dkxLdBcA71xCsa6KPiOZyZvynXcnyQ/8eH9N+C5Ap0XRcG/wtTgMw15Lt1G8cFHXL+ZJFUGvMnJHN46to2fPeN4/T9p7IsHcPXlHdaJ/QASOBx0acTib3Ykr3A5fy6T8CnI3sLDBoXGF3qimNZbFPssKtOrQ9vBKKu5UB9XeFbM0dmQTZLEE7f8LCraRz+UKCDeGq/Pusudd3ycfVYpP2JOk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While compaction depends on migration, the other direction is not the
case. So let's make it clearer that this is all about migration of
balloon pages.

Adjust all comments/docs in the core to talk about "migration" instead
of "compaction".

While at it add some "/* CONFIG_BALLOON_MIGRATION */".

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 Documentation/admin-guide/mm/memory-hotplug.rst |  8 ++++----
 arch/powerpc/platforms/pseries/cmm.c            |  8 ++++----
 drivers/misc/vmw_balloon.c                      |  8 ++++----
 drivers/virtio/virtio_balloon.c                 |  6 +++---
 include/linux/balloon.h                         | 12 ++++++------
 include/linux/vm_event_item.h                   |  4 ++--
 mm/Kconfig                                      |  4 ++--
 mm/balloon.c                                    | 10 +++++-----
 mm/memory_hotplug.c                             |  4 ++--
 mm/migrate.c                                    |  2 +-
 mm/vmstat.c                                     |  4 ++--
 11 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/Documentation/admin-guide/mm/memory-hotplug.rst b/Documentation/admin-guide/mm/memory-hotplug.rst
index 6581558fd0d7a..0207f87251421 100644
--- a/Documentation/admin-guide/mm/memory-hotplug.rst
+++ b/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -603,11 +603,11 @@ ZONE_MOVABLE, especially when fine-tuning zone ratios:
   memory for metadata and page tables in the direct map; having a lot of offline
   memory blocks is not a typical case, though.
 
-- Memory ballooning without balloon compaction is incompatible with
-  ZONE_MOVABLE. Only some implementations, such as virtio-balloon and
-  pseries CMM, fully support balloon compaction.
+- Memory ballooning without support for balloon memory migration is incompatible
+  with ZONE_MOVABLE. Only some implementations, such as virtio-balloon and
+  pseries CMM, fully support balloon memory migration.
 
-  Further, the CONFIG_BALLOON_COMPACTION kernel configuration option might be
+  Further, the CONFIG_BALLOON_MIGRATION kernel configuration option might be
   disabled. In that case, balloon inflation will only perform unmovable
   allocations and silently create a zone imbalance, usually triggered by
   inflation requests from the hypervisor.
diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 7a3c4922685ab..8d83df12430f2 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -494,7 +494,7 @@ static struct notifier_block cmm_mem_nb = {
 	.priority = CMM_MEM_HOTPLUG_PRI
 };
 
-#ifdef CONFIG_BALLOON_COMPACTION
+#ifdef CONFIG_BALLOON_MIGRATION
 static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 			   struct page *newpage, struct page *page,
 			   enum migrate_mode mode)
@@ -520,10 +520,10 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 	plpar_page_set_active(page);
 	return 0;
 }
-#else /* CONFIG_BALLOON_COMPACTION */
+#else /* CONFIG_BALLOON_MIGRATION */
 int cmm_migratepage(struct balloon_dev_info *b_dev_info, struct page *newpage,
 		    struct page *page, enum migrate_mode mode);
-#endif /* CONFIG_BALLOON_COMPACTION */
+#endif /* CONFIG_BALLOON_MIGRATION */
 
 /**
  * cmm_init - Module initialization
@@ -540,7 +540,7 @@ static int cmm_init(void)
 
 	balloon_devinfo_init(&b_dev_info);
 	b_dev_info.adjust_managed_page_count = true;
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
 		b_dev_info.migratepage = cmm_migratepage;
 
 	rc = register_oom_notifier(&cmm_oom_nb);
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 7fd3f709108c2..216a163959684 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1719,7 +1719,7 @@ static inline void vmballoon_debugfs_exit(struct vmballoon *b)
 #endif	/* CONFIG_DEBUG_FS */
 
 
-#ifdef CONFIG_BALLOON_COMPACTION
+#ifdef CONFIG_BALLOON_MIGRATION
 /**
  * vmballoon_migratepage() - migrates a balloon page.
  * @b_dev_info: balloon device information descriptor.
@@ -1803,11 +1803,11 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 	up_read(&b->conf_sem);
 	return ret;
 }
-#else /* CONFIG_BALLOON_COMPACTION */
+#else /* CONFIG_BALLOON_MIGRATION */
 int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 			  struct page *newpage, struct page *page,
 			  enum migrate_mode mode);
-#endif /* CONFIG_BALLOON_COMPACTION */
+#endif /* CONFIG_BALLOON_MIGRATION */
 
 static int __init vmballoon_init(void)
 {
@@ -1827,7 +1827,7 @@ static int __init vmballoon_init(void)
 		return error;
 
 	balloon_devinfo_init(&balloon.b_dev_info);
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
 		balloon.b_dev_info.migratepage = vmballoon_migratepage;
 
 	INIT_LIST_HEAD(&balloon.huge_pages);
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index de8041c3285a1..4e549abe59ff1 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -802,7 +802,7 @@ static void report_free_page_func(struct work_struct *work)
 	}
 }
 
-#ifdef CONFIG_BALLOON_COMPACTION
+#ifdef CONFIG_BALLOON_MIGRATION
 /*
  * virtballoon_migratepage - perform the balloon page migration on behalf of
  *			     a compaction thread.     (called under page lock)
@@ -851,7 +851,7 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	mutex_unlock(&vb->balloon_lock);
 	return 0;
 }
-#endif /* CONFIG_BALLOON_COMPACTION */
+#endif /* CONFIG_BALLOON_MIGRATION */
 
 static unsigned long shrink_free_pages(struct virtio_balloon *vb,
 				       unsigned long pages_to_free)
@@ -948,7 +948,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 
 	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
 		vb->vb_dev_info.adjust_managed_page_count = true;
-#ifdef CONFIG_BALLOON_COMPACTION
+#ifdef CONFIG_BALLOON_MIGRATION
 	vb->vb_dev_info.migratepage = virtballoon_migratepage;
 #endif
 	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
diff --git a/include/linux/balloon.h b/include/linux/balloon.h
index 82585542300d6..ca5b15150f425 100644
--- a/include/linux/balloon.h
+++ b/include/linux/balloon.h
@@ -22,9 +22,9 @@
  *
  * As the page isolation scanning step a compaction thread does is a lockless
  * procedure (from a page standpoint), it might bring some racy situations while
- * performing balloon page compaction. In order to sort out these racy scenarios
- * and safely perform balloon's page compaction and migration we must, always,
- * ensure following these simple rules:
+ * performing balloon page migration. In order to sort out these racy scenarios
+ * and safely perform balloon's page migration we must, always, ensure following
+ * these simple rules:
  *
  *   i. Inflation/deflation must set/clear page->private under the
  *      balloon_pages_lock
@@ -45,10 +45,10 @@
 
 /*
  * Balloon device information descriptor.
- * This struct is used to allow the common balloon compaction interface
+ * This struct is used to allow the common balloon page migration interface
  * procedures to find the proper balloon device holding memory pages they'll
- * have to cope for page compaction / migration, as well as it serves the
- * balloon driver as a page book-keeper for its registered balloon devices.
+ * have to cope for page migration, as well as it serves the balloon driver as
+ * a page book-keeper for its registered balloon devices.
  */
 struct balloon_dev_info {
 	unsigned long isolated_pages;	/* # of isolated pages for migration */
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 92f80b4d69a6d..fca34d3473b6b 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -125,9 +125,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 #ifdef CONFIG_MEMORY_BALLOON
 		BALLOON_INFLATE,
 		BALLOON_DEFLATE,
-#ifdef CONFIG_BALLOON_COMPACTION
+#ifdef CONFIG_BALLOON_MIGRATION
 		BALLOON_MIGRATE,
-#endif
+#endif /* CONFIG_BALLOON_MIGRATION */
 #endif
 #ifdef CONFIG_DEBUG_TLBFLUSH
 		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
diff --git a/mm/Kconfig b/mm/Kconfig
index 0d13c1b36e1c1..460a148d5b71a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -597,8 +597,8 @@ config MEMORY_BALLOON
 	bool
 
 #
-# support for memory balloon compaction
-config BALLOON_COMPACTION
+# support for memory balloon page migration
+config BALLOON_MIGRATION
 	bool "Allow for balloon memory migration"
 	default y
 	depends on MIGRATION && MEMORY_BALLOON
diff --git a/mm/balloon.c b/mm/balloon.c
index 25e2a1e71eba9..834f86c3c116d 100644
--- a/mm/balloon.c
+++ b/mm/balloon.c
@@ -34,7 +34,7 @@ static void balloon_page_insert(struct balloon_dev_info *balloon,
 {
 	lockdep_assert_held(&balloon_pages_lock);
 	__SetPageOffline(page);
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION)) {
 		SetPageMovableOps(page);
 		set_page_private(page, (unsigned long)balloon);
 	}
@@ -51,7 +51,7 @@ static void balloon_page_insert(struct balloon_dev_info *balloon,
 static void balloon_page_finalize(struct page *page)
 {
 	lockdep_assert_held(&balloon_pages_lock);
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
 		set_page_private(page, 0);
 	/* PageOffline is sticky until the page is freed to the buddy. */
 }
@@ -153,7 +153,7 @@ struct page *balloon_page_alloc(void)
 {
 	gfp_t gfp_flags = __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
 
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
 		gfp_flags |= GFP_HIGHUSER_MOVABLE;
 	else
 		gfp_flags |= GFP_HIGHUSER;
@@ -232,7 +232,7 @@ struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info)
 }
 EXPORT_SYMBOL_GPL(balloon_page_dequeue);
 
-#ifdef CONFIG_BALLOON_COMPACTION
+#ifdef CONFIG_BALLOON_MIGRATION
 
 static bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
 
@@ -342,4 +342,4 @@ static int __init balloon_init(void)
 }
 core_initcall(balloon_init);
 
-#endif /* CONFIG_BALLOON_COMPACTION */
+#endif /* CONFIG_BALLOON_MIGRATION */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 389989a28abe0..bc805029da517 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -946,8 +946,8 @@ static struct zone *default_kernel_zone_for_pfn(int nid, unsigned long start_pfn
  * We rely on "present pages" instead of "managed pages", as the latter is
  * highly unreliable and dynamic in virtualized environments, and does not
  * consider boot time allocations. For example, memory ballooning adjusts the
- * managed pages when inflating/deflating the balloon, and balloon compaction
- * can even migrate inflated pages between zones.
+ * managed pages when inflating/deflating the balloon, and balloon page
+ * migration can even migrate inflated pages between zones.
  *
  * Using "present pages" is better but some things to keep in mind are:
  *
diff --git a/mm/migrate.c b/mm/migrate.c
index 4750a2ba15fef..1bf2cf8c44dd4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -88,7 +88,7 @@ static const struct movable_operations *page_movable_ops(struct page *page)
 	 * back to the buddy.
 	 */
 	if (PageOffline(page))
-		/* Only balloon compaction sets PageOffline pages movable. */
+		/* Only balloon page migration sets PageOffline pages movable. */
 		return offline_movable_ops;
 	if (PageZsmalloc(page))
 		return zsmalloc_movable_ops;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 6ae8891c9693e..e96a344ab5974 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1422,9 +1422,9 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_MEMORY_BALLOON
 	[I(BALLOON_INFLATE)]			= "balloon_inflate",
 	[I(BALLOON_DEFLATE)]			= "balloon_deflate",
-#ifdef CONFIG_BALLOON_COMPACTION
+#ifdef CONFIG_BALLOON_MIGRATION
 	[I(BALLOON_MIGRATE)]			= "balloon_migrate",
-#endif
+#endif /* CONFIG_BALLOON_MIGRATION */
 #endif /* CONFIG_MEMORY_BALLOON */
 #ifdef CONFIG_DEBUG_TLBFLUSH
 	[I(NR_TLB_REMOTE_FLUSH)]		= "nr_tlb_remote_flush",
-- 
2.52.0


