Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E531CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52AF8E0009; Fri, 22 Aug 2025 15:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02DC8E0003; Fri, 22 Aug 2025 15:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA9D8E0009; Fri, 22 Aug 2025 15:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71F6A8E0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:21:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42E08138175
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:05 +0000 (UTC)
X-FDA: 83805361290.09.B95D26B
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 913181C0002
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cw07gNbb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890463; a=rsa-sha256;
	cv=none;
	b=Dp1sedgjI1Gi7r9xuTH+aK5ET/dEDmgp4O6iARqt/sYOiGIr9KMVcaRX1jlSve3BzBgYhd
	7KtUrqYI8JcqKwey2n5eJdb0SiLdfL3w4iu4XjSSwSDhCndaJGzXJQxZa+IS2ntr6iwJ/k
	aJh+iSfII0b6NEL5XAdoJkc8s/FVV1I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cw07gNbb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890463;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+cJXYJn3gwcVQj/BHKK/PcHgDrCevOXhroXOkk9oEE=;
	b=8YYv2ZHUDu1gG77pRoLDObsAvDROOpB9sf6PSFPs1yCKtyThQ1cdl36qXT4IozDtXKmKVm
	VfoxossAf04G8hRrtTzjRRG3RriUM5fCqHfk4khau7x3/E9QkcBv+Xpu7+vkXstyvGMLV+
	ZIu03RIv1V8LV8fxUYzx6uK/FqmDmMc=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70a9f5625b7so21456726d6.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755890462; x=1756495262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z+cJXYJn3gwcVQj/BHKK/PcHgDrCevOXhroXOkk9oEE=;
        b=cw07gNbbaaaALJRveVNh5NHQZB0oPI1454Bq90eQpUL6J0hpgFdlO8fmTrWWVmA2ER
         L3TzXRa0JCcNcuYc9s/Z9qpFZ3lBSj/v6ndazcfCw/SJemV4qAwb31IxC40ebUA1eUhF
         JoX0tHRZyuiCxbcsMubqYGLizmTMEvCjTyYmRb6Ow3BgGvMaGPRV3smO1S1eSR4sW1vx
         G8IoJHh0VdCs9RTerSJdQhtr7atf+MxK2tduu3MEstB3b9w3urlLzrZLwfakNJhKtInS
         jgFMbi7PnX8qHjqY8WfLqHhxmCWAI5hAm+qOgjNHG4m4Omf+duX1o19FUky/kLy6wB7y
         jz3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890462; x=1756495262;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z+cJXYJn3gwcVQj/BHKK/PcHgDrCevOXhroXOkk9oEE=;
        b=NU/BgLMNIsZMtGO4R3rX/cuuE6HYtpWLvowmafduRXDp1SOECB2XlW30fU5C0SE0Qa
         dIFu5UGT9gZyQaHvGtQEVyIadImo7ZoxziEsh6VFB1KFIQNL8IVRyaV/6YrU61iPjBWg
         umEkT4HFYsT0CtIFlw2u0YFxicOSlXmuLlh6mGPh3kFAABJFW+lN2J4i0vUOs39GV/20
         xceD7K3XBmgJljs8wfxcrcKQA/N9plvgI03GpRghJgzKB/xlQdcYxAzhksW46GfcpOly
         AKq2Fl2rIekr+OSePDHJqvh+BjCIJqS5Nf7mwyAXXE4WtnwQGJwTIQLdynEGOsr9k0px
         cbKg==
X-Gm-Message-State: AOJu0Yzg3DZ8ZIx62ua8uUXbXL2/ftFViMZ5kq4RMOBDpiC4otQhW1uv
	UN/JVXa6pPDKAA6VFzpb+1i7qM4I7XVqvXjPVBUP0KsX8vS2qW3rlT55GMTwVUaFnIg=
X-Gm-Gg: ASbGncv5v9j+PPUPmjFquiw3TWuu8TMa2qh6zhmVk+hBOxHJzgUWZ9FcfNXS2oXh98X
	CBg0oR0GNWFKpagT4vH8loI64nLEOUxTGKToWRhVsTiipwGLLOBJIhI7s+MgcCiqn0fFkKsrjxE
	gizjRVjquO4EWq5kOySqDgU0utiAUxCertCJk8HaFwZOCdTLx6pdicjELQNpmKvwPW9L3G+vUkB
	L+G5bGqDqDmLgKlPCqzmSg6HnRth3ICpYvgKgsR6lLtjme5y3Y8GdW2IkX6gyAk4MPuMgRUbOBQ
	z87w+KNVaBLg1EhwGQZZ5QfLBv7dyM4H4aUItvIWDkawZ7gVtOY72OOlL5IVTaGinIT0jgDzBz4
	LOLZHC/hSNwaYxESC0hx0DkuTQ2IR4rf/zV6a3ZO0D+s=
X-Google-Smtp-Source: AGHT+IFM2ncLXTYrGE2bUfptgzHCzj01g0lOJ0Db/heWPpGQ7X3jSS+7KVadsNxpoXIo9BdWLidvfQ==
X-Received: by 2002:a05:6214:27c2:b0:70d:6df4:1b21 with SMTP id 6a1803df08f44-70d972431camr51145956d6.62.1755890462185;
        Fri, 22 Aug 2025 12:21:02 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da72b04a6sm3843656d6.52.2025.08.22.12.20.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 22 Aug 2025 12:21:01 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 3/9] mm, swap: rename and move some swap cluster definition and helpers
Date: Sat, 23 Aug 2025 03:20:17 +0800
Message-ID: <20250822192023.13477-4-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250822192023.13477-1-ryncsn@gmail.com>
References: <20250822192023.13477-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 913181C0002
X-Stat-Signature: q7n6te6h5bpnto3iyxtnihhbs9zoooqc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755890463-39506
X-HE-Meta: U2FsdGVkX1+gFkTGo6ALGsvv6DcD9n3Lig/CXQhbo4HJlbqNd3vaE5Hx6Q2rfoD1dtc7suqMX9Mm2+aRi+0OBFapDX6X7cCIBzq+EyGzl9mP3G56VLobvKXfBL7DlVlp//GU79oZnFWTvNKJYslsZyiDAZ05VMio8CtBy9fi9F+UcKVHyEnaSUtitPMyE1pHu9Q9nRIpDbMXZTDyyEexkds7SneBzh9nlGIkwSc9dvyZv9F3JDnW07H8nLibuY6EzgMxUp792Vc9NaiUlTnYIv7BhY30LavBtEk4C8iDT/ZmukHPIe+HrL/+mkC8PLPBeZqX34FY6ToHHKarDavxeROt688mmGP+e7PAxYH7uFyoklxM0FBIRNHPVtU5AFpbh39e8AF/FMKLuJ/tEI+1ozocwI2+H0qQ0ovGn6dtHDX356Y8CvH8sycxlSC8zxQfoW8TgQGuml+Hqc0dRGfviKpgDjnlugu42SFoccL0A9PufRe4RL7UwpuTZ9bojWl0O27/A6hrAH0/SLno6xP7VwLj7qGfeTbqMUp1bHUUwbgRtgRN7nMpkn/dIr4Lmh0WF/eiGBygid1qo2H0Wjpc1bE+JN2JHI5YbaQO9wbjGSvqOuJ1c/UxFvwThsOy48o8XhZlgGRbMaV95T/6KTHCZc6+V1vgcR+Lu8CSUnk2y8qjZ/zCNqCm0GEFUZDR5ICcuikGQhJ6lmHkxZfuqsiZb0NjsjsZGkGIb9md2kjlklbV/6r6sgRjCpfgbAC73PBY5mAj0rNwGpBGUKwrYD7hzhuFeOAVxmAVZGWRO9nDo+jfH8O0/l+Dr6pj1by43AZoH3lIQIUTlTCxWO0hcha3TfBaMEXrm/La6iGN/nSLqtLZGO3I0nbbGJ92PzPBLl2ZCJQRGfFlC8wR4UzEWT69E3GTrvFjbZ8xHO4Da6D1TfQCrExNj5kiBASPpA3WyxOLr8kmRERxtc6IP6b+SSD
 2JaeVoIk
 4bhKTYq4AsjlgCt6C4qBmoJgv7oOGQwFk+uY5dbpvRB3CTPglqkI4MIt6Jb9LDf0ZZ+Q067tkfJiqqNunXB1DOrEl5GWMbSzRg47XNL6y+fZ4qeWhX1kElY8FNsm4VYX+l1bwL+iEqTmeoyDw6o2cLOgUXNvOlzNlf0v0SIH8AYAqi/OarA3e8Ab+aAJPsGeBG18G2jJHYVta2gQlmIS2vK5CYhlXVtLXBILphORW9XTB8zPb21SA7LohJbZ3KSXW21Lt8744wltcAvYbv6CEwbNVA+MTflIfHixd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, move cluster related definitions and helpers to
mm/swap.h, also tidy up and add a "swap_" prefix for cluster lock/unlock
helpers, so they can be used outside of swap files.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h | 34 ---------------
 mm/swap.h            | 63 ++++++++++++++++++++++++++++
 mm/swapfile.c        | 99 ++++++++++++++------------------------------
 3 files changed, 93 insertions(+), 103 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index c2da85cb7fe7..20efd9a34034 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -235,40 +235,6 @@ enum {
 /* Special value in each swap_map continuation */
 #define SWAP_CONT_MAX	0x7f	/* Max count */
 
-/*
- * We use this to track usage of a cluster. A cluster is a block of swap disk
- * space with SWAPFILE_CLUSTER pages long and naturally aligns in disk. All
- * free clusters are organized into a list. We fetch an entry from the list to
- * get a free cluster.
- *
- * The flags field determines if a cluster is free. This is
- * protected by cluster lock.
- */
-struct swap_cluster_info {
-	spinlock_t lock;	/*
-				 * Protect swap_cluster_info fields
-				 * other than list, and swap_info_struct->swap_map
-				 * elements corresponding to the swap cluster.
-				 */
-	u16 count;
-	u8 flags;
-	u8 order;
-	struct list_head list;
-};
-
-/* All on-list cluster must have a non-zero flag. */
-enum swap_cluster_flags {
-	CLUSTER_FLAG_NONE = 0, /* For temporary off-list cluster */
-	CLUSTER_FLAG_FREE,
-	CLUSTER_FLAG_NONFULL,
-	CLUSTER_FLAG_FRAG,
-	/* Clusters with flags above are allocatable */
-	CLUSTER_FLAG_USABLE = CLUSTER_FLAG_FRAG,
-	CLUSTER_FLAG_FULL,
-	CLUSTER_FLAG_DISCARD,
-	CLUSTER_FLAG_MAX,
-};
-
 /*
  * The first page in the swap file is the swap header, which is always marked
  * bad to prevent it from being allocated as an entry. This also prevents the
diff --git a/mm/swap.h b/mm/swap.h
index bb2adbfd64a9..223b40f2d37e 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -7,10 +7,73 @@ struct swap_iocb;
 
 extern int page_cluster;
 
+#ifdef CONFIG_THP_SWAP
+#define SWAPFILE_CLUSTER	HPAGE_PMD_NR
+#define swap_entry_order(order)	(order)
+#else
+#define SWAPFILE_CLUSTER	256
+#define swap_entry_order(order)	0
+#endif
+
+/*
+ * We use this to track usage of a cluster. A cluster is a block of swap disk
+ * space with SWAPFILE_CLUSTER pages long and naturally aligns in disk. All
+ * free clusters are organized into a list. We fetch an entry from the list to
+ * get a free cluster.
+ *
+ * The flags field determines if a cluster is free. This is
+ * protected by cluster lock.
+ */
+struct swap_cluster_info {
+	spinlock_t lock;	/*
+				 * Protect swap_cluster_info fields
+				 * other than list, and swap_info_struct->swap_map
+				 * elements corresponding to the swap cluster.
+				 */
+	u16 count;
+	u8 flags;
+	u8 order;
+	struct list_head list;
+};
+
+/* All on-list cluster must have a non-zero flag. */
+enum swap_cluster_flags {
+	CLUSTER_FLAG_NONE = 0, /* For temporary off-list cluster */
+	CLUSTER_FLAG_FREE,
+	CLUSTER_FLAG_NONFULL,
+	CLUSTER_FLAG_FRAG,
+	/* Clusters with flags above are allocatable */
+	CLUSTER_FLAG_USABLE = CLUSTER_FLAG_FRAG,
+	CLUSTER_FLAG_FULL,
+	CLUSTER_FLAG_DISCARD,
+	CLUSTER_FLAG_MAX,
+};
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
+static inline struct swap_cluster_info *swp_offset_cluster(
+		struct swap_info_struct *si, pgoff_t offset)
+{
+	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
+}
+
+static inline struct swap_cluster_info *swap_cluster_lock(
+		struct swap_info_struct *si,
+		unsigned long offset)
+{
+	struct swap_cluster_info *ci = swp_offset_cluster(si, offset);
+
+	spin_lock(&ci->lock);
+	return ci;
+}
+
+static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
+{
+	spin_unlock(&ci->lock);
+}
+
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 12f2580ebe8d..618cf4333a3d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -58,9 +58,6 @@ static void swap_entries_free(struct swap_info_struct *si,
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
-static struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
-					      unsigned long offset);
-static inline void unlock_cluster(struct swap_cluster_info *ci);
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
@@ -259,9 +256,9 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	 * swap_map is HAS_CACHE only, which means the slots have no page table
 	 * reference or pending writeback, and can't be allocated to others.
 	 */
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	need_reclaim = swap_only_has_cache(si, offset, nr_pages);
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	if (!need_reclaim)
 		goto out_unlock;
 
@@ -386,20 +383,7 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 	}
 }
 
-#ifdef CONFIG_THP_SWAP
-#define SWAPFILE_CLUSTER	HPAGE_PMD_NR
-
-#define swap_entry_order(order)	(order)
-#else
-#define SWAPFILE_CLUSTER	256
-
-/*
- * Define swap_entry_order() as constant to let compiler to optimize
- * out some code if !CONFIG_THP_SWAP
- */
-#define swap_entry_order(order)	0
-#endif
-#define LATENCY_LIMIT		256
+#define LATENCY_LIMIT 256
 
 static inline bool cluster_is_empty(struct swap_cluster_info *info)
 {
@@ -426,34 +410,12 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
 	return ci - si->cluster_info;
 }
 
-static inline struct swap_cluster_info *offset_to_cluster(struct swap_info_struct *si,
-							  unsigned long offset)
-{
-	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
-}
-
 static inline unsigned int cluster_offset(struct swap_info_struct *si,
 					  struct swap_cluster_info *ci)
 {
 	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
-static inline struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
-						     unsigned long offset)
-{
-	struct swap_cluster_info *ci;
-
-	ci = offset_to_cluster(si, offset);
-	spin_lock(&ci->lock);
-
-	return ci;
-}
-
-static inline void unlock_cluster(struct swap_cluster_info *ci)
-{
-	spin_unlock(&ci->lock);
-}
-
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
 			 enum swap_cluster_flags new_flags)
@@ -809,7 +771,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	}
 out:
 	relocate_cluster(si, ci);
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);
 		this_cpu_write(percpu_swap_cluster.si[order], si);
@@ -876,7 +838,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		if (ci->flags == CLUSTER_FLAG_NONE)
 			relocate_cluster(si, ci);
 
-		unlock_cluster(ci);
+		swap_cluster_unlock(ci);
 		if (to_scan <= 0)
 			break;
 	}
@@ -915,7 +877,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		if (offset == SWAP_ENTRY_INVALID)
 			goto new_cluster;
 
-		ci = lock_cluster(si, offset);
+		ci = swap_cluster_lock(si, offset);
 		/* Cluster could have been used by another order */
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
@@ -923,7 +885,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 			found = alloc_swap_scan_cluster(si, ci, offset,
 							order, usage);
 		} else {
-			unlock_cluster(ci);
+			swap_cluster_unlock(ci);
 		}
 		if (found)
 			goto done;
@@ -1204,7 +1166,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 	if (!si || !offset || !get_swap_device_info(si))
 		return false;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
@@ -1212,7 +1174,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 		if (found)
 			*entry = swp_entry(si->type, found);
 	} else {
-		unlock_cluster(ci);
+		swap_cluster_unlock(ci);
 	}
 
 	put_swap_device(si);
@@ -1480,14 +1442,14 @@ static void swap_entries_put_cache(struct swap_info_struct *si,
 	unsigned long offset = swp_offset(entry);
 	struct swap_cluster_info *ci;
 
-	ci = lock_cluster(si, offset);
-	if (swap_only_has_cache(si, offset, nr))
+	ci = swap_cluster_lock(si, offset);
+	if (swap_only_has_cache(si, offset, nr)) {
 		swap_entries_free(si, ci, entry, nr);
-	else {
+	} else {
 		for (int i = 0; i < nr; i++, entry.val++)
 			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
 	}
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 }
 
 static bool swap_entries_put_map(struct swap_info_struct *si,
@@ -1505,7 +1467,7 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
 	if (count != 1 && count != SWAP_MAP_SHMEM)
 		goto fallback;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	if (!swap_is_last_map(si, offset, nr, &has_cache)) {
 		goto locked_fallback;
 	}
@@ -1514,21 +1476,20 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
 	else
 		for (i = 0; i < nr; i++)
 			WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 
 	return has_cache;
 
 fallback:
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 locked_fallback:
 	for (i = 0; i < nr; i++, entry.val++) {
 		count = swap_entry_put_locked(si, ci, entry, 1);
 		if (count == SWAP_HAS_CACHE)
 			has_cache = true;
 	}
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return has_cache;
-
 }
 
 /*
@@ -1578,7 +1539,7 @@ static void swap_entries_free(struct swap_info_struct *si,
 	unsigned char *map_end = map + nr_pages;
 
 	/* It should never free entries across different clusters */
-	VM_BUG_ON(ci != offset_to_cluster(si, offset + nr_pages - 1));
+	VM_BUG_ON(ci != swp_offset_cluster(si, offset + nr_pages - 1));
 	VM_BUG_ON(cluster_is_empty(ci));
 	VM_BUG_ON(ci->count < nr_pages);
 
@@ -1653,9 +1614,9 @@ bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 	struct swap_cluster_info *ci;
 	int count;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	count = swap_count(si->swap_map[offset]);
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return !!count;
 }
 
@@ -1678,7 +1639,7 @@ int swp_swapcount(swp_entry_t entry)
 
 	offset = swp_offset(entry);
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 
 	count = swap_count(si->swap_map[offset]);
 	if (!(count & COUNT_CONTINUED))
@@ -1701,7 +1662,7 @@ int swp_swapcount(swp_entry_t entry)
 		n *= (SWAP_CONT_MAX + 1);
 	} while (tmp_count & COUNT_CONTINUED);
 out:
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return count;
 }
 
@@ -1716,7 +1677,7 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 	int i;
 	bool ret = false;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	if (nr_pages == 1) {
 		if (swap_count(map[roffset]))
 			ret = true;
@@ -1729,7 +1690,7 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 		}
 	}
 unlock_out:
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return ret;
 }
 
@@ -2662,8 +2623,8 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	BUG_ON(si->flags & SWP_WRITEOK);
 
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
-		ci = lock_cluster(si, offset);
-		unlock_cluster(ci);
+		ci = swap_cluster_lock(si, offset);
+		swap_cluster_unlock(ci);
 	}
 }
 
@@ -3579,7 +3540,7 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
 	VM_WARN_ON(usage == 1 && nr > 1);
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 
 	err = 0;
 	for (i = 0; i < nr; i++) {
@@ -3634,7 +3595,7 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	}
 
 unlock_out:
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return err;
 }
 
@@ -3733,7 +3694,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 
 	offset = swp_offset(entry);
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 
 	count = swap_count(si->swap_map[offset]);
 
@@ -3793,7 +3754,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 out_unlock_cont:
 	spin_unlock(&si->cont_lock);
 out:
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	put_swap_device(si);
 outer:
 	if (page)
-- 
2.51.0


