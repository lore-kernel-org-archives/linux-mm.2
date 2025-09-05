Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15EDFCA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6928E001E; Fri,  5 Sep 2025 15:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6804A8E0001; Fri,  5 Sep 2025 15:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA358E001E; Fri,  5 Sep 2025 15:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32F408E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:14:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F07F2B7A41
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:45 +0000 (UTC)
X-FDA: 83856148530.15.FEEC497
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id EE6EDA0010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TuDMWdPz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099684; a=rsa-sha256;
	cv=none;
	b=nNaTqmS3AhTdaOJtjQ9k6xy/hrhlpuJ6r8I5i3tbhXHbj3+YjAsBIymFRFP2w3vh09hpu8
	FCSymvZIOGXb0t3/u6IYxNHS0m7AlG/U5SKYidA6skxF3opfUyVE9lfBI9yxxz9tOQ4EkJ
	IIQRVYgyb5CuqDwpihMSjGEFITA0+Vg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TuDMWdPz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099684;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXCjnErSqW7lrOTzOAfqkITRvdAoHNXzorUyab5yxLY=;
	b=Y6RyFwZ5DvmA4MnkPFxodYlgZCr9WSI3h6cARNM2MmuDluwsUoRqkktqzQilY9WBJ2PZLL
	VEew88+CxQfqsJn5ON38vyZT7HWiMwKW+to+rIRbNvliPUxe54tLeN2KZwiGwjsXp71uj2
	3smRJjOjo0v2NxdZRpl/suhxcON9e5c=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-77238cb3cbbso2678846b3a.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099682; x=1757704482; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZXCjnErSqW7lrOTzOAfqkITRvdAoHNXzorUyab5yxLY=;
        b=TuDMWdPzlhEnbfqHxv5WSbLqdp22f5nue7Lbn7l3CrXhcQbXon9abfXaqj5WUYxM7s
         WMy3nUL8T1Z68QPWhGdXJI7vj+YpmOxdej19MCbyfPhtAUFlf6Z2cB1KAJVAMmVj+g2J
         mxC138vqNjIlUELAvzyfEEJEyDkWeMTgof7rGuqm9Ag3Hqa39nphf6LF4CFDVgdlBP5E
         zIAaoN6lUS1e0M6Nx2GQe/XoIB1skeoXfb1b8Xvbg0nElSvPLfXKkCQWzwowpoI/q3gM
         CUATfwhteTDoqlv+dPUeFFbaEqpEkgjX5bEKTnPlG9B750nPS9W/qcTW3RA59R3lWJvq
         rDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099682; x=1757704482;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZXCjnErSqW7lrOTzOAfqkITRvdAoHNXzorUyab5yxLY=;
        b=V0MmCW8hw0QHH8GxruisrTIqHPZjzlRMiVRADYpk/ICg/VixY/isJgMry7X/0R0ULO
         bUjdqVjafmkY0JQqhMxNf4FPVumXDo4dnzcjlUp0dIUoCbks9c+A4rZvMWq6D4OAC8B3
         Z2DcqZ68Wybmms2z144luKQN3AmrlLoRvxhIfchenUJKoPly3BoEfwJWxIj9ioeFbBK+
         7Xm+m7rJON5PmmioPRDVolEb5PdADyU+NYfeeqDVFpOGL3gsLbostEkVS++RkWQna/2D
         pyfEif+ct5hCeBHCZ03lZIVyUQTIB9aIWFEnw3eDcpVODDxOukvlr6N2ihfE+RAEh7DV
         X1wQ==
X-Gm-Message-State: AOJu0YzW+I46OB0a30X+sOgvPLDqjMVpCOlI/mhcWz/asXgzRI3M4k8r
	aq1MrDGhrr6r09vyGpu0E9DK//esfVH4xPDfOBAzuGtcp3NFpGT5mVSPEhATeZ/PN18=
X-Gm-Gg: ASbGnctFLtqgxscont/kd4QAzC9nD3w1UigZJULHjGdrcOHPHn7v4HQC+cfUdbjJJGq
	ZLfw1r6KxmO1KRcbvc/7cqYU3jYyZKPRgerj8Y/0W94R3TY3LCt5e99l6ojw7J4ImPL/T4MRBCd
	2w68rYrYyBuVpJbvPRD6aVfQL5HFL4qNjMGbbXjKQv3nTRaiCR/0tm/EKlW51KqdsQjY1eJNm44
	FQCRifb/+5LqygZuuzk4+2BtITaBQWlE0dwdD886a6aseiSE5qLGlfpqFEYaIw+xbK3rpCuu0Qh
	0Gi4c64Pbbuch2riuRCymPQzBoYR3ZAX+V9sUNzWb4oXoyyl/ekdvPqA7whku3AP4n4DxxCbIbH
	TkMOIwMYFbcVAT4wbgDpES6MDdg3T8eUHP4dILPYdlHkylQjySbQV4UBrcg==
X-Google-Smtp-Source: AGHT+IEBYA0uesip3wIKaccDeR63V4mHmwyoEjZ2FLF3Pja8XPH7B2M+y/xcl5swlQp/VY6U0RNV9A==
X-Received: by 2002:a05:6a00:2e2a:b0:772:5fad:e6d7 with SMTP id d2e1a72fcca58-7725fadf0a9mr29719836b3a.32.1757099682203;
        Fri, 05 Sep 2025 12:14:42 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:14:41 -0700 (PDT)
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
Subject: [PATCH v2 06/15] mm, swap: rename and move some swap cluster definition and helpers
Date: Sat,  6 Sep 2025 03:13:48 +0800
Message-ID: <20250905191357.78298-7-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EE6EDA0010
X-Stat-Signature: 6rnxbacehuocjpdjwhcoi41tm9sc7x7e
X-HE-Tag: 1757099683-413250
X-HE-Meta: U2FsdGVkX18waLdYpXBdKstbWUM+v2S3n1JV2Y7nCR9B4/l8F5NtFEmdLbJ/GfaQ2enSkncZhI0+DVQcTbSzOaYdvAVKHy19jxUDMIlV/SXWBJ4sN6v2tXjLI5BHG9ZgC3WH2YMOTlwjIvZ3cSOXRYl4vK0VedR4XC3KKPG3VIL/9DYbObg0S+yTvpS8sxI8+ZIzWvElvk5CqbkzMbUFReLB7M/75Uy8LqhJ9d2uA6QQ6F+GNcZK9eQu30Vs1F2FqQ26PN+87vaab9EzAxy9DIYLc0wQ1HzUjueeofwZdGCbXt4xX4V/bKhXbuXaozX+r6ro1R+rU0iNMVnUvCvz4R81Wut01mVUCLuqGjSevGg9aPrM+9PxsYTFH8LzbNBVEYPMkIZHWdr1D5CQ6ZyKuxSAtvq4vAR0pRZ0dLNIS1NsT2UBoSi0/0WhB5iTkEz8fxgcNiPwXghLJzq04Lyhj6E0GK3zdXh728o4fBGlCF1XRBNjOZNevNSO18g81a4j8VR51w1bOI+su64oy0RWSBaRh6ZybuO3C+mIWDZ3VjrEcITpJl/fTPhh65ZR3VWx7zdNdLO0oSSMkL3FvMR4JqfX9CEzorcZbSvvn9kx5MY5KJ2SP/+QViz7nWLDN/GGOyNT8dfLQMgRkBLRmdcCWFMyR1I+rfYF4oNIfVaiFwEU0Xa965t2QJUWl4KOyIixzuKypMXDgpRWY1i9U0mcZTDGiHPRkfi0uWHZS5umvX04VlHTkhbdFn5yxgVH7AtAFDkY8QWrsAVSiIDol9eusUkr97fwRPlDWUuPfX5yc1a/kKyKSaLJeSqJCbliL7r5hRtK8K0yuQ2FI/F0yonti5+jvrmcYBNunguIsiyB0XsXmo1HqtAkHGduDIkQVkLhsa5C0GhLX5qY/INGmIT8w5y5XYpdlNhnwqNG0Nef05uUrhH9T4joc7Z7RVX5S5oAV1M7mUlpIIcohCwMZNT
 Tco+1Rc5
 4m9EwbaiLK91qSaDUoCFCymmBe1aqI0msHtqRKaQai/j23WErm695KbvBo07szwKLvzNnxMccJa8NcUN60jy1hB1+u6I6ZamBCvjm6JBZPbW1VSswP3gN8B3iLDrsCOrfqufhia0T6l7gRo3k2ok5UtmKcF5psOXMk+NqN0xLO5qInYQJeEPsc3rad55iuB9+VzdFyWglF4VZXJbO94c3R6KK4DGicWw8g1kD1TZz+mZ9hwlL7HgnbjMrsOeumTwEpBrcTarH5PkcByZp4sMChPfdtW7CIbhZ7rfaS8eG24n0XbN8pU7HbHVMpl+/vWNKMKFZsk8x+LndKJTEVPO6MW8hUhb06msf5CPAVrBbRDJyMWSv8Q713DpMoFiLDwOmdZZB9MaMyeWX61Ic9KJJAhkn1vvWZnQi7PSwNNP9RZymi8C9a3kS6uRCqzSW9CXKjK7TzkiZZanF+/RO2NTRCasoD9KVC9MRRMgJVOcveiVMAmioh20Dlhv0Cb+GuJOsxMZ4ijN4VmQG70LELzvdhfCDVzoTKXI+WQPkaTEx/A18VllXWTiw7Z8a4gR5wlpWcsDg2r7htosS0I6R7CKMItedQrKCd81muF6iWCACJCvKE6o=
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
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/swap.h | 34 ----------------
 mm/swap.h            | 70 ++++++++++++++++++++++++++++++++
 mm/swapfile.c        | 97 +++++++++++++-------------------------------
 3 files changed, 99 insertions(+), 102 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 23452f014ca1..7e1fe4ff3d30 100644
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
index a69e18b12b45..39b27337bc0a 100644
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
index 1bd90f17440f..547ad4bfe1d8 100644
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
 
@@ -2660,8 +2621,8 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	BUG_ON(si->flags & SWP_WRITEOK);
 
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
-		ci = lock_cluster(si, offset);
-		unlock_cluster(ci);
+		ci = swap_cluster_lock(si, offset);
+		swap_cluster_unlock(ci);
 	}
 }
 
@@ -3577,7 +3538,7 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
 	VM_WARN_ON(usage == 1 && nr > 1);
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 
 	err = 0;
 	for (i = 0; i < nr; i++) {
@@ -3632,7 +3593,7 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	}
 
 unlock_out:
-	unlock_cluster(ci);
+	swap_cluster_unlock(ci);
 	return err;
 }
 
@@ -3731,7 +3692,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 
 	offset = swp_offset(entry);
 
-	ci = lock_cluster(si, offset);
+	ci = swap_cluster_lock(si, offset);
 
 	count = swap_count(si->swap_map[offset]);
 
@@ -3791,7 +3752,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
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


