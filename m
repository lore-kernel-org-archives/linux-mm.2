Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD5FCD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914036B00AA; Tue, 12 May 2026 01:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C53A6B00AC; Tue, 12 May 2026 01:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801B86B00AD; Tue, 12 May 2026 01:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7546B00AA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:38:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CB8840152
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:38:15 +0000 (UTC)
X-FDA: 84757662150.23.45AF570
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6C800100007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:38:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QqOqi+Vu;
	spf=none (imf05.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmg1/5AYnhQfPDVo7U8v9UEsn9gIbFRK+B6p/Lo/5oA=;
	b=H598a6AXXAJj2OPPi3PHfBUA+oJy9vMxLKdfmLn/mbknv2pp4IzM4LnfKchuEOOpKMRd8L
	hHmbY0g2t1dJ3Dwv9bSOxeKPoXFbu+sEwd16HcrIHKyPlALcPMPsADzRHZmAODCgtvTK+N
	0AzuE104QV0AT1Q82eAgXFeR60J9d7o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QqOqi+Vu;
	spf=none (imf05.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564293; a=rsa-sha256;
	cv=none;
	b=GLhpy07ywWuOODjAkoVpAp8g2U7GXphaTtkCk4d8Hqa6sICvQ9fasM22JLigmkzlGQwTUk
	F2bQs2uGpMx2oDjXpvTQ9RO0XfCiahPfSOy3u7eqLMl/i6n38Z1LJGcpj6XqgKtA2EKLHA
	336pPPXVNfpRaUFwDeExGxU+g7/O59A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jmg1/5AYnhQfPDVo7U8v9UEsn9gIbFRK+B6p/Lo/5oA=; b=QqOqi+Vu+e1lyd8X/LTzUvV1/s
	7nNzu+X/+UiipnmFD2UKvwRucWeks9YwyuibcySNp6WMvDeX4F1yrLmj6KlC1j/U0itxoREq7ty5j
	psvrVCvEVE+DGyltDxt2h7xbnHc2o21Dhshp4eRz7jXJmo5FP7/eNIyvbsR+we+lvpzS80HlOZuRL
	BtnTXIz7jT4ZN+GcEikcH8RCK3DW5D+Xs/Gyj3cUHsE6zHFR8tSGQ7eYtKmIGSQyp9kOpyNnIomyR
	LyJEvGDuooiyrdDlFLckwWnhjoGoOBRE7uRV1WGSBrGTTCxlFVT/UybEtrMcMglFTm5s3NOUdudR+
	Bvu6vXiw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfoh-0000000FfXA-48rG;
	Tue, 12 May 2026 05:38:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 12/12] swap: move swap_info_struct to mm/swap.h
Date: Tue, 12 May 2026 07:35:28 +0200
Message-ID: <20260512053625.2950900-13-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: x8csdk1wrasysxp196q6c4szauffznhb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6C800100007
X-Rspam-User: 
X-HE-Tag: 1778564293-688248
X-HE-Meta: U2FsdGVkX1+9hXPIQsjzrCAJtQnoq2jofu0aH2yJ+O7QIj2gpoaDo/QGYzgZtVLUoZHRRG4zouxCSPxmw1+NiYl+0SUku5Xm0dNqaMoO1SL4L7E4vjM28cUSMg5njFr9FcbQEwpkcjxKEUeK/2nOtukDQqFm3KWfE/Ux5wgUR3kRolovio9QlAOS0jg+wzx/kDZlRsaaqVX/BKdsP1M0TY68VZJsdQfLwzhXsSZ4diC/SpZQ54YDnW+nuMv3uxG8Z9tnarLNddkjGh6NkK6siwXOwXWya3mrbPsjwu6cUGSLfx2+0fEzmBZT2vLA5KWkAh4925xC+wQCdXQUwQL+KF2Bd9pjb+GFS5UWGJNuShXAXZ8dQhiOpaccttqLfJp/bp/EcB8nxiThMrB2UJMZOSZ8/P6YVQSouY8CqKetNoep41dAo2dkQc7+GQITuHaEfvV+SC3va7b8LphxBq2A5joky6PVp7fOQSUM7zUvyogqVDG4xBuHISH6XnoLKV1Y6WE6bRhR0bfS3ZtGEoQcNYbw8f58TMNojdRt8cW/NI24IQVPO2nqgOp94pRufECx0POnkKQaU4cyawq/5lryb5gjNRW76vZyiWqL9M7skEgvijkAKMmW+Za8yG/D9/lYoZ9e+sUcuqbGedJFwWv6sEghU9Imq8KK5dlGd82zXRwIMWhfd1Zn2NEa2g17W7sVazZ6jz7ctVJLk48N734Ng9Tn8B9E+oKvDxGnGkAT/k0q0DPX9EYFkBnrDkOu+HDbxzjWWJWAvI8O8d4Gf/vlH3P07kvt7c3Nl07uvSy1Hi4tzmSF09OLYZsP4UqJH12kr5JISQHGefFXdN4fQHAykruda9ruvFcZc9y+hLq4ZYg75PeGOfbVyAEJfaPPKvgsk/MaR7ujiTJo5l4LUOuvR1K+KMAtHJ0hr9i9KbEOsiq/GCjJEjmnTSwCOECD5peEyQT5qYFMWLIavT5j6x9
 wGZfuz0v
 sMWiSLXQ5zFIeP2aZf3zSNjniQmb1t6QyZed4xMRMMf534LFBvwdl0yjYvKH1yaUzeLheRPwy7z7QEk75CtqC17IQI9L5R3mwsP5aJuuhh+J2Y6hfJav9tl7T2AqA3D7w/zKDu8i2LF5SNL8X7mcT+dTEoz21h79sIj7PsAouhwjQHR0EtWGPXN+j55yiH2Z8s5tIHSSqvzTpYkKDLFGSlB53wppEGvvYviikmPBhyaPvxIBESpirEtaNVJRyWFpdU17zrR493K9dL9X8H8WSJy3dSEGEICajaGYC2rOCgnCoClP6raDLg0RsTornivngZx3SnT5/cMs2g2NW4+yI4bz56TsTh0xW/9wk07mwJyV1pux0gzKPK7JvjZ3y4OcjluzGiv0/L60DgGwnNqhaFyDNYywd5DzbmVyxlhhPqMwpm6ov/KR419HoBp7CbG9GQvLG0ioBbURu54Q5Z5GZe4eKWPbrrNoQOSEc6YZjI3aF5Gur4clwf0X+T5pnvW4Bxz4JmYeYjiaw13bT/WQQMd93oIb3lmPfR4MspURP5Mr5xCtvgQrgyQ8zswbgVoBYH9/YHIyde6o8kH8lhCqk1KGmKvNIvVJhc9sWysCtcbojuyYnAFMp49RDACJUl7bkE8osfVh6k/fg+mwFg0l1eB7mKHMfXPkeqxjOl6/mTTxws7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_info_struct is now internal to the MM subsystem, so remove it from
the public header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/swap.h | 98 +-------------------------------------------
 mm/swap.h            | 92 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+), 96 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 95237ee065c2..31eef9b74949 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -16,9 +16,9 @@
 #include <uapi/linux/mempolicy.h>
 #include <asm/page.h>
 
-struct notifier_block;
-
 struct bio;
+struct notifier_block;
+struct swap_info_struct;
 
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
@@ -178,29 +178,6 @@ struct sysinfo;
 struct writeback_control;
 struct zone;
 
-/*
- * Max bad pages in the new format..
- */
-#define MAX_SWAP_BADPAGES \
-	((offsetof(union swap_header, magic.magic) - \
-	  offsetof(union swap_header, info.badpages)) / sizeof(int))
-
-enum {
-	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
-	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
-	SWP_DISCARDABLE = (1 << 2),	/* blkdev support discard */
-	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
-	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
-	SWP_BLKDEV	= (1 << 6),	/* its a block device */
-	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
-	SWP_FS_OPS	= (1 << 8),	/* swapfile operations go through fs */
-	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
-	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
-	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
-	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
-					/* add others here before... */
-};
-
 #define SWAP_CLUSTER_MAX 32UL
 #define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
@@ -219,56 +196,6 @@ enum {
 #define SWAP_NR_ORDERS		1
 #endif
 
-/*
- * We keep using same cluster for rotational device so IO will be sequential.
- * The purpose is to optimize SWAP throughput on these device.
- */
-struct swap_sequential_cluster {
-	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
-};
-
-/*
- * The in-memory structure used to track swap areas.
- */
-struct swap_info_struct {
-	struct percpu_ref users;	/* indicate and keep swap device valid. */
-	unsigned long	flags;		/* SWP_USED etc: see above */
-	signed short	prio;		/* swap priority of this type */
-	struct plist_node list;		/* entry in swap_active_head */
-	signed char	type;		/* strange name for an index */
-	unsigned int	max;		/* size of this swap device */
-	unsigned long *zeromap;		/* kvmalloc'ed bitmap to track zero pages */
-	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
-	struct list_head free_clusters; /* free clusters list */
-	struct list_head full_clusters; /* full clusters list */
-	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
-					/* list of cluster that contains at least one free slot */
-	struct list_head frag_clusters[SWAP_NR_ORDERS];
-					/* list of cluster that are fragmented or contented */
-	unsigned int pages;		/* total of usable pages of swap */
-	atomic_long_t inuse_pages;	/* number of those currently in use */
-	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
-	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
-	struct rb_root swap_extent_root;/* root of the swap extent rbtree */
-	struct block_device *bdev;	/* swap device or bdev of swap file */
-	struct file *swap_file;		/* seldom referenced */
-	struct completion comp;		/* seldom referenced */
-	spinlock_t lock;		/*
-					 * protect map scan related fields like
-					 * inuse_pages and all cluster lists.
-					 * Other fields are only changed
-					 * at swapon/swapoff, so are protected
-					 * by swap_lock. changing flags need
-					 * hold this lock and swap_lock. If
-					 * both locks need hold, hold swap_lock
-					 * first.
-					 */
-	struct work_struct discard_work; /* discard worker */
-	struct work_struct reclaim_work; /* reclaim worker */
-	struct list_head discard_clusters; /* discard clusters list */
-	struct plist_node avail_list;   /* entry in swap_avail_head */
-};
-
 static inline swp_entry_t page_swap_entry(struct page *page)
 {
 	struct folio *folio = page_folio(page);
@@ -423,10 +350,7 @@ int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
-extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
-struct backing_dev_info;
-extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);
 
 /*
@@ -452,20 +376,7 @@ bool folio_free_swap(struct folio *folio);
 swp_entry_t swap_alloc_hibernation_slot(int type);
 void swap_free_hibernation_slot(swp_entry_t entry);
 
-static inline void put_swap_device(struct swap_info_struct *si)
-{
-	percpu_ref_put(&si->users);
-}
-
 #else /* CONFIG_SWAP */
-static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
-{
-	return NULL;
-}
-
-static inline void put_swap_device(struct swap_info_struct *si)
-{
-}
 
 #define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
@@ -497,11 +408,6 @@ static inline int __swap_count(swp_entry_t entry)
 	return 0;
 }
 
-static inline bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
-{
-	return false;
-}
-
 static inline int swp_swapcount(swp_entry_t entry)
 {
 	return 0;
diff --git a/mm/swap.h b/mm/swap.h
index a77016f2423b..70974495bf15 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -8,6 +8,79 @@ struct swap_iocb;
 
 extern int page_cluster;
 
+/*
+ * We keep using same cluster for rotational device so IO will be sequential.
+ * The purpose is to optimize SWAP throughput on these device.
+ */
+struct swap_sequential_cluster {
+	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
+};
+
+/*
+ * The in-memory structure used to track swap areas.
+ */
+struct swap_info_struct {
+	struct percpu_ref users;	/* indicate and keep swap device valid. */
+	unsigned long	flags;		/* SWP_USED etc: see above */
+	signed short	prio;		/* swap priority of this type */
+	struct plist_node list;		/* entry in swap_active_head */
+	signed char	type;		/* strange name for an index */
+	unsigned int	max;		/* size of this swap device */
+	unsigned long *zeromap;		/* kvmalloc'ed bitmap to track zero pages */
+	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
+	struct list_head free_clusters; /* free clusters list */
+	struct list_head full_clusters; /* full clusters list */
+	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
+					/* list of cluster that contains at least one free slot */
+	struct list_head frag_clusters[SWAP_NR_ORDERS];
+					/* list of cluster that are fragmented or contented */
+	unsigned int pages;		/* total of usable pages of swap */
+	atomic_long_t inuse_pages;	/* number of those currently in use */
+	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
+	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
+	struct rb_root swap_extent_root;/* root of the swap extent rbtree */
+	struct block_device *bdev;	/* swap device or bdev of swap file */
+	struct file *swap_file;		/* seldom referenced */
+	struct completion comp;		/* seldom referenced */
+	spinlock_t lock;		/*
+					 * protect map scan related fields like
+					 * inuse_pages and all cluster lists.
+					 * Other fields are only changed
+					 * at swapon/swapoff, so are protected
+					 * by swap_lock. changing flags need
+					 * hold this lock and swap_lock. If
+					 * both locks need hold, hold swap_lock
+					 * first.
+					 */
+	struct work_struct discard_work; /* discard worker */
+	struct work_struct reclaim_work; /* reclaim worker */
+	struct list_head discard_clusters; /* discard clusters list */
+	struct plist_node avail_list;   /* entry in swap_avail_head */
+};
+
+/*
+ * Max bad pages in the new format..
+ */
+#define MAX_SWAP_BADPAGES \
+	((offsetof(union swap_header, magic.magic) - \
+	  offsetof(union swap_header, info.badpages)) / sizeof(int))
+
+enum {
+	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
+	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
+	SWP_DISCARDABLE = (1 << 2),	/* blkdev support discard */
+	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
+	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
+	SWP_BLKDEV	= (1 << 6),	/* its a block device */
+	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
+	SWP_FS_OPS	= (1 << 8),	/* swapfile operations go through fs */
+	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
+	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
+	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
+	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
+					/* add others here before... */
+};
+
 #ifdef CONFIG_THP_SWAP
 #define SWAPFILE_CLUSTER	HPAGE_PMD_NR
 #define swap_entry_order(order)	(order)
@@ -352,6 +425,13 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 	return i;
 }
 
+bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
+struct swap_info_struct *get_swap_device(swp_entry_t entry);
+static inline void put_swap_device(struct swap_info_struct *si)
+{
+	percpu_ref_put(&si->users);
+}
+
 #else /* CONFIG_SWAP */
 struct swap_iocb;
 static inline struct swap_cluster_info *swap_cluster_lock(
@@ -498,5 +578,17 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 {
 	return 0;
 }
+static inline bool swap_entry_swapped(struct swap_info_struct *si,
+		swp_entry_t entry)
+{
+	return false;
+}
+static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
+{
+	return NULL;
+}
+static inline void put_swap_device(struct swap_info_struct *si)
+{
+}
 #endif /* CONFIG_SWAP */
 #endif /* _MM_SWAP_H */
-- 
2.53.0


