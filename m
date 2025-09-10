Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 565F6CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68938E002B; Wed, 10 Sep 2025 12:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF25D8E0005; Wed, 10 Sep 2025 12:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9F58E002B; Wed, 10 Sep 2025 12:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8203F8E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47F95140135
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:19 +0000 (UTC)
X-FDA: 83873825238.13.CC519CB
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5D20F4000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hYCqVNhA;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520557;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5HcJVxJqYzxUZjEo3aLu6n8KHT0yS8P2J4twu7LXww=;
	b=PQyv817LpJG7hcrf++KqUR4EAwWpIXtEDrtY6zMBD+vduck4IW3ewumwJFEMBA5frAcb2v
	S3CSt3M3H27LeBAYNV4IvqaGwIO0l1ZnkkfEjYBCWN0CI8I4N1HUS0wef/BNjkrk3xidSB
	zU/4YfTHnsRZnvgxNMJXBX/N6cSpFYk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hYCqVNhA;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520557; a=rsa-sha256;
	cv=none;
	b=cCoPAoguJnqa8m1X564Ok7Pv+1yLorenThhUiUomTJ0XtgdxFNM6OaKrm3MEgmraXX4eln
	QKd4UKNsTSsdDxKO64qJ+QQufx+6KjxsZHX9kAYdKet8kT5RiaJhU945ZI0OvOE5NRxuxd
	3nILSCbcuDiUqYmyyIZzw8gcg0T0MD8=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-772627dd50aso944175b3a.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520556; x=1758125356; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s5HcJVxJqYzxUZjEo3aLu6n8KHT0yS8P2J4twu7LXww=;
        b=hYCqVNhAZ81pmXam+1x9idJIGowqVRW701KWGMbRAwyUUUvhuWquy1OKkS+1z+aM//
         TnBP2gsnPMj+DvGEdZpGt+3juZKH/PtJt0klgYKsJBshSkx74NpfGkPJIKXVqTTgDXSb
         GN/9yGgUmAsoFCcxxtgltqVTbjdK3vhboHNxrLPVDTwO6o4/oc9WKV9+86ojF5tRFs1r
         gxuWrBgAcLBjsX99/nZZENCqTx61+ZcqJ9b/f7SQBc23Hnr7gat+plc4ZxWNpyTxU68N
         z0Iz2MOHQXyEtIi4dGaV6ztqeiyOKDOWVtY4Mi8k2gFUSJk8h5yydhziwn+0DOP0mx3O
         Pljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520556; x=1758125356;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s5HcJVxJqYzxUZjEo3aLu6n8KHT0yS8P2J4twu7LXww=;
        b=iGqLKxDSV+KeZpePJMTIyoAMLYhB0OtHKWoCr1PexZISI6JeizUCprRCExlnUrEXra
         HptizLuIOCTvOvDxaDLKco6F0G+jtyHfmJzmVuRIhvU9IWzCxjRPg+Axw162iMmZaFlX
         TdTQUzg9svz/90hx65hX2x5HBjz8meVMD5vAIgEKFqnS7PCF77SSSZodz4Ap5lqWGjp6
         RVTRRzh1WO5dI7Li3gIkuAN9R7LT0lDbuaRh9ibuj2e36ksRvS+MDGxue/k9QrlYW7wX
         9Z9uFUS2adSDjEhHs42R6A4X2gIy77zwFSsPCVtEJOyBJFUVUddxEVe5teacyjrt7/Nr
         E2fw==
X-Gm-Message-State: AOJu0YykheMHKL6w8+ox1PbTc14cTuIxFnTYwCAqC2FvKFPO9ZJ7c6s8
	4m4m8x79N69VXe2PQK44Cmnk7Aicu4ovTCkOJFKcwyDodXvAQGvbaY5on0ujsOacslA=
X-Gm-Gg: ASbGncsTywz2Fvur/y5ItY0H4Xsqp141KrsxkOEfC2ZC/HX8a2wyV/jeZOr1FW3LIYT
	cteiq1+qNh4pd5LLMm62Rgqhcv5cNUrmnBx1Fe46w315YQ08Y8+TwYV/F80EW/8bbZrIkEwwXfN
	wVh/QKmdg2CEoz9Ew/XJxbnumTcySzxZD+nNXK+ldYWc7421zgSubnYWdTP00R69wtD/lKWPrxR
	VhpxHnibAYyxqVavE3NJI4bN/mNvAOA/suyFGSiq3Mk9xz0B9xosjAXZXmJtJk89yDq++F7N1WH
	S8EB4KsUwRfyo29t/geVzlcKO+ubOsH4PsfdFIgNmnoZzXywVI9I2p8StiDVciMo7vnm6WRBhsS
	X9zG/I3RngOj16368sa4Y46A7ktZXvqT6yG+ooAXHtTMPWAg=
X-Google-Smtp-Source: AGHT+IGH4gi7IyV/95U3LFCHhW1okK8q/O9STR4M1KwOMk1ioCbsGLzlOVyMoaTZn7dFGHmQS+afqg==
X-Received: by 2002:a05:6a20:4327:b0:243:b965:1bb7 with SMTP id adf61e73a8af0-25d0a5cd9c0mr198373637.19.1757520555556;
        Wed, 10 Sep 2025 09:09:15 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:14 -0700 (PDT)
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
Subject: [PATCH v3 06/15] mm, swap: rename and move some swap cluster definition and helpers
Date: Thu, 11 Sep 2025 00:08:24 +0800
Message-ID: <20250910160833.3464-7-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5D20F4000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i7ud1a8krr47j8h9yip957k3we9wre45
X-HE-Tag: 1757520557-597550
X-HE-Meta: U2FsdGVkX1/+JIQQxsciqLeOInq57iCXHw6V/ADKzzyHf/Hdle1MW465BEAs/iZPOe49yN2aewR7wGAGKrKGzCfUO8q2gOFjOjFczyjuOKxEU7vDE9IED41sgxhaZZqPyOE0kN70PR1Bqxj6S3LMx2mNbqmGR9EpvohRlkHkRH614TwOQ8w6SAKiv3z++nw2yK6DN+ghEBxnJJ+ksDwapWAwbYhvG3c2nNS6rBuAJ2Gbd2a105MqR2yF5TjVoXb41HYQevAZ2t0RNGm960tYF+cNPvwJJ0cpKyzxWOl0cJ38PFBiz6EZ+9t58zGobpP+xcmbdngsWmWIFcQ5vNUwSy9i4Ddh/rKNX9cVYahh3RugrM0uEGPIo40GXn476TEdMzdUBM72V+/eaF3pTEGPDeiN1Om5+nOBHtzMnwWD90jfmGUT2j+rOOBKtEO74dcja4Zf6mB/nvh8kxEYn3kw06LfwyMtb2oCgPsdZRNS8oWKTfWA9FtnDMaKSySgE0Nu5XAMXUkZnfeyzQ8JI4Msz6twmh68agjgk6Env00YVIoXkCp9msY+RySRVT4MilMpp9nzNuN3T3ITfrxkgnzde3+AJlMBFNF3IhlWeNFMPcBJ+555+omIVKHjDcd/otv28IDe/QGWykI78cs3HH7u8cPPAcC3//r3R8OlVahCu+h9stAGWR7y5IcKsZvdYKsrcXI/eGSQqXtB5N8Go64T3pfv2LIE9fH8rjJM6rvgPoqOUuXwuHhlmuSHZ+pm/CY5mKttsRLHBqtlh/L8t5GmAjZdmLgzoNB0jmJAE3+Uu4okv6M8wozByYfYvYCtz6vbbfW1WnJt60pknQuj6BmWW8oVNzdf4nSrajIOF2XT2KrSmRkGM8NBCWZQx5ujdqaAuHaDE7GODaABAKBLJq+K3YKSrPlN4m53lAGZagFS6YDBAZGsvy3Xnwtccut9/e4mquFUqMxDiQbvqyL07+A
 BWcmAWuh
 d7BCWVRoHt35zy7jDkCzerrhMrHieKww30TiHJbT5j+W90qbhzOD8hn1JTsJtsmh8f9Y367M6wubv4SI72EGZYLSmHInZGXhkxscO7V8OoHZxkHkob1NEKha2uEdpn0CCTF58IpTBq5biaUkk+3D93acXqUC6Vk7W96Sawi3PkAHJH0weYV/rQbLpLUJ6njhKksTNiKuQIviWxeM4y2GkGbz1m92G2wtK0cA3vg9hY/r80uDaqBf+DWEdr1WwA9IpwxFOoT4rHMxRN/lc2rBNVAcJmTbszMawGtOHuDEAQuGqiVa7HTnlY5wMCATMZq78T5OKfzgsqn5/UyzsQghiDOyvAzFCAWeIL6SxGRG45xmA/jOPD+IcrLFC7KXEGJBm6T0gJ4XnfRSAOlpq/3Z2M7bNFc85FJKlEihQi7/Dn35CbfmX3X9tBeYnkR2CdPxtIAQqrVq7AxvhbjsuP2Xto2Bs38TwNedwbkYj8wrIxBFDfJ9dcOydo1cHqwyxra8NJ/H4iZ6LvaKmaNmf+McF+N4x0xdrR8fi/WUVXnEM9lLqzqzu47ZqV8GDNpzSgRf8Kr3iIisglAaJ3Coe7/hfNSPyCQ3y7jSCHJxqyZLNhA2dhOLA8mqP3sJ9/Et2KzZdY2pG
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
index f1a4d381d719..3bfe9cf06fd2 100644
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
@@ -257,9 +254,9 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
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
 
@@ -384,19 +381,6 @@ static void discard_swap_cluster(struct swap_info_struct *si,
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
@@ -424,34 +408,12 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
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
@@ -807,7 +769,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	}
 out:
 	relocate_cluster(si, ci);
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);
 		this_cpu_write(percpu_swap_cluster.si[order], si);
@@ -874,7 +836,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		if (ci->flags == CLUSTER_FLAG_NONE)
 			relocate_cluster(si, ci);
 
-		unlock_cluster(ci);
+		swap_cluster_unlock(ci);
 		if (to_scan <= 0)
 			break;
 	}
@@ -913,7 +875,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		if (offset == SWAP_ENTRY_INVALID)
 			goto new_cluster;
 
-		ci = lock_cluster(si, offset);
+		ci = swap_cluster_lock(si, offset);
 		/* Cluster could have been used by another order */
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
@@ -921,7 +883,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 			found = alloc_swap_scan_cluster(si, ci, offset,
 							order, usage);
 		} else {
-			unlock_cluster(ci);
+			swap_cluster_unlock(ci);
 		}
 		if (found)
 			goto done;
@@ -1202,7 +1164,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 	if (!si || !offset || !get_swap_device_info(si))
 		return false;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
@@ -1210,7 +1172,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 		if (found)
 			*entry = swp_entry(si->type, found);
 	} else {
-		unlock_cluster(ci);
+		swap_cluster_unlock(ci);
 	}
 
 	put_swap_device(si);
@@ -1478,14 +1440,14 @@ static void swap_entries_put_cache(struct swap_info_struct *si,
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
@@ -1503,7 +1465,7 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
 	if (count != 1 && count != SWAP_MAP_SHMEM)
 		goto fallback;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	if (!swap_is_last_map(si, offset, nr, &has_cache)) {
 		goto locked_fallback;
 	}
@@ -1512,21 +1474,20 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
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
@@ -1576,7 +1537,7 @@ static void swap_entries_free(struct swap_info_struct *si,
 	unsigned char *map_end = map + nr_pages;
 
 	/* It should never free entries across different clusters */
-	VM_BUG_ON(ci != offset_to_cluster(si, offset + nr_pages - 1));
+	VM_BUG_ON(ci != swp_offset_cluster(si, offset + nr_pages - 1));
 	VM_BUG_ON(cluster_is_empty(ci));
 	VM_BUG_ON(ci->count < nr_pages);
 
@@ -1651,9 +1612,9 @@ bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 	struct swap_cluster_info *ci;
 	int count;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	count = swap_count(si->swap_map[offset]);
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return !!count;
 }
 
@@ -1676,7 +1637,7 @@ int swp_swapcount(swp_entry_t entry)
 
 	offset = swp_offset(entry);
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 
 	count = swap_count(si->swap_map[offset]);
 	if (!(count & COUNT_CONTINUED))
@@ -1699,7 +1660,7 @@ int swp_swapcount(swp_entry_t entry)
 		n *= (SWAP_CONT_MAX + 1);
 	} while (tmp_count & COUNT_CONTINUED);
 out:
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return count;
 }
 
@@ -1714,7 +1675,7 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 	int i;
 	bool ret = false;
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 	if (nr_pages == 1) {
 		if (swap_count(map[roffset]))
 			ret = true;
@@ -1727,7 +1688,7 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 		}
 	}
 unlock_out:
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return ret;
 }
 
@@ -2661,8 +2622,8 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	BUG_ON(si->flags & SWP_WRITEOK);
 
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
-		ci = lock_cluster(si, offset);
-		unlock_cluster(ci);
+		ci = swap_cluster_lock(si, offset);
+		swap_cluster_unlock(ci);
 	}
 }
 
@@ -3578,7 +3539,7 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
 	VM_WARN_ON(usage == 1 && nr > 1);
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 
 	err = 0;
 	for (i = 0; i < nr; i++) {
@@ -3633,7 +3594,7 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	}
 
 unlock_out:
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return err;
 }
 
@@ -3732,7 +3693,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 
 	offset = swp_offset(entry);
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 
 	count = swap_count(si->swap_map[offset]);
 
@@ -3792,7 +3753,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
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


