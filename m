Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9163ACAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38558E001E; Tue, 16 Sep 2025 12:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9798E0001; Tue, 16 Sep 2025 12:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF898E001E; Tue, 16 Sep 2025 12:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C961C8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:01:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FA9B57BF5
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:53 +0000 (UTC)
X-FDA: 83895579306.05.8250AD0
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86F7B18000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dVqRP/+9";
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038511;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5XE3hl6EvqOsTkZfhneog+5rlu5GEH6XiBbz2n6aJA=;
	b=im88N9LLel27VTybdvK/Oe2i35eFHEAQEtP6bJp2CZVZkTbqXTlcnjtLlXnOmGPsN7SNJO
	PFPBeq3ucIAXsXMWzU01DH9VFw8eqr0snpQB3/HGDbB1HEaPXnU1qsHmIsqQuJ4owJYG+D
	eN0pcRYkIyC+FQbJ6MxJ+ikwqbQJ4zI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dVqRP/+9";
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038511; a=rsa-sha256;
	cv=none;
	b=jDeUElKLkc35AUvrilARU5BmUO4v8/i4e0R/CQCkbzhD9ntbSRRgJAnkui2kmp/b8AMAmm
	8ACVfF9RaT/cbPvNJSJf8DP51aCxp9ooo5FsqbjIMVkBQMI36/llf9g6eNCqIMkiGAogZG
	yMEvGUHyQ9T1MPvqiNaUnWeas52Q8F0=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-82a334e379eso150817485a.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038510; x=1758643310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h5XE3hl6EvqOsTkZfhneog+5rlu5GEH6XiBbz2n6aJA=;
        b=dVqRP/+9y3u+orQ1tsSWrR3ALH5k76C0dQpwtuc34pZJnigK44PsFJ48gxUNsmLbJx
         w1pVCQBnjyUXBbNgej9VP+kXaFyie1CcZs4ePgw3+Mo3R46Bwa+pDeNA8tqSC1hvBRxk
         WQ/c3t7SLNbD/fkn0zN8JocJqTj2GDx4aM198IdmYlAhIH68ZYWmjQ80DmEv1kRg/1yq
         L/K+kizgB/WjiFaVdAmoO3TGRBuYiLdaE8OkDFPSu1t+EejMAaU8Ir+J8QJ8KwHxYN0j
         as+Ek4Em5FaMqdJBk/6mZkme5E8JQVoFikOEsdMq/qjpjHVRs2Kotf82A1UmjNjUnzyu
         9kQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038510; x=1758643310;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h5XE3hl6EvqOsTkZfhneog+5rlu5GEH6XiBbz2n6aJA=;
        b=CoQPozsNv70dEPlzyDIoGreaLjeK4p6tR5WBN6j6jpUeloPpLDieezuKHcFm0O67ba
         wf9zW2CqTjvHngRx9cHI8AD/A70Ow7dTEJNaESrK81jDlV2Qdfeuoa+l1v5GJ1QfIDwR
         jxov8hQD7Yld1jaOQsfFdFryOpsbFjT7TT3e/Tt0pZF+y6g3bF1WaAxjCcBCgi8zmEaU
         o5nik4nJl92wDkEugaEjgH/7IjXd+055OFjiO0ypYLKydGnsObkpF4p3J8asISoQjm5H
         ZcMz18Nhl+KYMhZEgZtqZDzcuNxMp4R61/z+j7ssNYsPckj8ScroQa6F945yDoDo6BgE
         O6/A==
X-Gm-Message-State: AOJu0YyGUwv7LWYIxeHu5aurkpkXxVstdpWCN3wPUKYMkhZAzDhZPfZL
	g1WIpozZurPTU3rOgBQNvQxxhqvMul0F5kggpPPcdbnbQ+8dNwp26p1+hFvwncXzAqg=
X-Gm-Gg: ASbGncsxyRDuzQdzH/8d5DlU5RQDztqpJoWt8q4vEjHnO0DCbuEzjsvb73+EQR3VHiP
	YCgPbdZghJXAhtYlha+w+27SkId2K300BwudzHyokq47P6oZRl/sYbJecrp7B2QMKgKAzaE2/ia
	WFoub4T+VA1u93SNwhr2mrnCUKN5aa+ZRvLMojA9Q4oM5HRipJsWJ1As6JJ65KwhywBQ9i8yZLe
	I/1MXy2KWBvNERkkH+5bCEBbI1N2T2ZtYjeEnv17rCQrb55PGH3O/9CKFcdXRMwSX0Kjkrvke3a
	xZlNk2J3XkLvA1Ci/UMZYum+I1RFDkKzXkpe1hPbIeUoxunNx9hTLO+r8s7/PJv/Hso+9723NCL
	T8pzhMEN8Tf0AokBJj97xn3ZWA5bDu9Zan3Jniv/XDZw7+cM=
X-Google-Smtp-Source: AGHT+IEM10v/FCpwSByPTcQQCQruIaaZ/dQUoecHoJXZkW1C8XFmuMoS45q6htThdb8fGXYqplzC8Q==
X-Received: by 2002:a05:620a:a909:b0:80a:3092:b271 with SMTP id af79cd13be357-823fbdeaca5mr1938600585a.3.1758038509561;
        Tue, 16 Sep 2025 09:01:49 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.01.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:01:49 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v4 06/15] mm, swap: rename and move some swap cluster definition and helpers
Date: Wed, 17 Sep 2025 00:00:51 +0800
Message-ID: <20250916160100.31545-7-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dgqtx7otw5usch33e7qsb1k94eoto9ph
X-Rspam-User: 
X-Rspamd-Queue-Id: 86F7B18000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758038511-987725
X-HE-Meta: U2FsdGVkX19dGdIrZhMy4RvjQv8KKrJhRC6DUA8aC2IFfaIfjGL5aY55ZkUMvcVDWyL0M5rh5Qad7MbRFdrwVR5w1cR3iGayVvL/N6zqpFQQBf1ELFaXSrB5vcH0cxT5sm/m1GBfqazClqazK2j+IWQo3sX06j97cXZ66b8DsW6XBwkyqdkHS/6nWgA/cUKRaHH1e4/7RH3aJseuuZgdWzdMmb/e7TX+XwcRabzii4AeBMI+moExisrZwwAOiCbFLeFTJ0pf6U1tiWM15vjuh9OFtoeP85G6KjmueCeNRbRiZjHQiUuXIa7V4N8MC3BhcjQrlXlOSTy5Gl3kG3wiSobBju7sli0sjkkVsV8k2/JoZwOtWiYtAM2bu76qRvDhUxTaHg9QFwvtfRpLl9pteVZhU+At9ajC1ETpHeWq+7IT+NSY4bCB6cyoq7lrkAR/X1fkBlqRoHHsCajolUvyJ8J1/Kz2kjRaR7fjE3R9HRfqP/xk2ZiautHVADnrdwK9mG9/qQ2hED7lUc5jCuwlydUU60v0g5CIQYqlq/i+xyShJmPJWHlOCYqMJEZKrF9Dt3BXwgT7wXbSLSpCpQMO6nf5F4Xt4FkcVPqUpkfQWGQPABm/kvr3rgi9HGVBykmp+B3dAIcF3oZAESizMV0v6v6YQGNGaDNGzMdl5cl6fDm0x1HIES8LpjT3BPsBA9meual+7bWjIfexsPtufOQtmVq+brLZbdmEGxW1gqZDFYRv+gSiqQJ+yJLLXrUWPgc7QWn0W8anfpKIFJO3SsJilenxz/sB04kW8GJkWoU36HUaAME2tt8I6UnsK1RMBEOyB1KipJv5qWLTq2w4dQBNz0YwiOqfPyKTgov0B0LXq6Pie9L7bt+vakrk/XmbhPuq2bBA1qKQABLAorZXL2LuTkL0Dk8wyiQIEkacZ2GgKd8lVFuCH+QKHs879dqKJTlDfs87E2TxjbXpk801ASC
 WY7+SYy1
 vIr+auSUTX3GfkppzD2xIQQEqB86O/UPm7FgRleXZEx46TkIggIB3jUxbTChKWCXhS0LLUFz6ZNSwkwLjlMqQG/YWScm+TAnFvLAq/XhKXBo2BWLiUHSgJgB1tkMTMcHbadpw2BOO+GRusw6WRJ1rKusTOYfkng+RZ6qF8bBmO5GfMzTBbWEgG5Z1sd7+0FUEowoubfJ5J8mMfPPDfuNQ9gdcMfhw4SQ03Ee4oLd26yKjczbop5B6hGOknrnExf7PtjVyaU115GVJzD2TAYijLBJ0iTjEJY8Qqd1gvqPnyFp9jLQH8iXBYkmuhlXha/rvjFnmcJ3fHRsL+g0J9VK03rWUy5eEt5n1j5ag9lw9ybR08e5A73UOWwB8B/uIu2RcxWFGk/P/QIau5rltdbXV5gSwcCR+Bb58OwuchD5UnGXuhAA1Iu9JC7YzlD/ZKwzlQUMndoPuwaueAlbDEU7bAXPaR9oaW0YpRZvMAoSSUAGCRpAXJ/RWc1wxD7YhEjrHu1qUakHiFdBsMnM7uPT2RHH9UYH0vgANP2ldXK2Te8Ic/iTb7yvZ+0gCIKOXo2qQa80yYdcQdJr7l9IhQ4d9UUI2YA==
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
helpers, so they can be used outside of swap files. And while at it, add
kerneldoc.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/swap.h | 34 ----------------
 mm/swap.h            | 70 ++++++++++++++++++++++++++++++++
 mm/swapfile.c        | 97 +++++++++++++-------------------------------
 3 files changed, 99 insertions(+), 102 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a2bb20841616..78cc48a65512 100644
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
index 7d868f8de696..138b5197c35e 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -7,10 +7,80 @@ struct swap_iocb;
 
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
+/**
+ * swap_cluster_lock - Lock and return the swap cluster of given offset.
+ * @si: swap device the cluster belongs to.
+ * @offset: the swap entry offset, pointing to a valid slot.
+ *
+ * Context: The caller must ensure the offset is in the valid range and
+ * protect the swap device with reference count or locks.
+ */
+static inline struct swap_cluster_info *swap_cluster_lock(
+		struct swap_info_struct *si, unsigned long offset)
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
index c3c3364cb42e..700e07cb1cbd 100644
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
@@ -258,9 +255,9 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
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
 
@@ -385,19 +382,6 @@ static void discard_swap_cluster(struct swap_info_struct *si,
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
 #define LATENCY_LIMIT		256
 
 static inline bool cluster_is_empty(struct swap_cluster_info *info)
@@ -425,34 +409,12 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
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
@@ -808,7 +770,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	}
 out:
 	relocate_cluster(si, ci);
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);
 		this_cpu_write(percpu_swap_cluster.si[order], si);
@@ -875,7 +837,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		if (ci->flags == CLUSTER_FLAG_NONE)
 			relocate_cluster(si, ci);
 
-		unlock_cluster(ci);
+		swap_cluster_unlock(ci);
 		if (to_scan <= 0)
 			break;
 	}
@@ -914,7 +876,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		if (offset == SWAP_ENTRY_INVALID)
 			goto new_cluster;
 
-		ci = lock_cluster(si, offset);
+		ci = swap_cluster_lock(si, offset);
 		/* Cluster could have been used by another order */
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
@@ -922,7 +884,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 			found = alloc_swap_scan_cluster(si, ci, offset,
 							order, usage);
 		} else {
-			unlock_cluster(ci);
+			swap_cluster_unlock(ci);
 		}
 		if (found)
 			goto done;
@@ -1203,7 +1165,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 	if (!si || !offset || !get_swap_device_info(si))
 		return false;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
@@ -1211,7 +1173,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 		if (found)
 			*entry = swp_entry(si->type, found);
 	} else {
-		unlock_cluster(ci);
+		swap_cluster_unlock(ci);
 	}
 
 	put_swap_device(si);
@@ -1479,14 +1441,14 @@ static void swap_entries_put_cache(struct swap_info_struct *si,
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
@@ -1504,7 +1466,7 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
 	if (count != 1 && count != SWAP_MAP_SHMEM)
 		goto fallback;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	if (!swap_is_last_map(si, offset, nr, &has_cache)) {
 		goto locked_fallback;
 	}
@@ -1513,21 +1475,20 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
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
@@ -1577,7 +1538,7 @@ static void swap_entries_free(struct swap_info_struct *si,
 	unsigned char *map_end = map + nr_pages;
 
 	/* It should never free entries across different clusters */
-	VM_BUG_ON(ci != offset_to_cluster(si, offset + nr_pages - 1));
+	VM_BUG_ON(ci != swp_offset_cluster(si, offset + nr_pages - 1));
 	VM_BUG_ON(cluster_is_empty(ci));
 	VM_BUG_ON(ci->count < nr_pages);
 
@@ -1652,9 +1613,9 @@ bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 	struct swap_cluster_info *ci;
 	int count;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	count = swap_count(si->swap_map[offset]);
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return !!count;
 }
 
@@ -1677,7 +1638,7 @@ int swp_swapcount(swp_entry_t entry)
 
 	offset = swp_offset(entry);
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 
 	count = swap_count(si->swap_map[offset]);
 	if (!(count & COUNT_CONTINUED))
@@ -1700,7 +1661,7 @@ int swp_swapcount(swp_entry_t entry)
 		n *= (SWAP_CONT_MAX + 1);
 	} while (tmp_count & COUNT_CONTINUED);
 out:
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return count;
 }
 
@@ -1715,7 +1676,7 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 	int i;
 	bool ret = false;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	if (nr_pages == 1) {
 		if (swap_count(map[roffset]))
 			ret = true;
@@ -1728,7 +1689,7 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
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


