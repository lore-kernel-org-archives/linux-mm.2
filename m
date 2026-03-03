Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21268EC1434
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7433F6B0150; Tue,  3 Mar 2026 06:54:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3A56B0153; Tue,  3 Mar 2026 06:54:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC9E6B0156; Tue,  3 Mar 2026 06:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 472A46B0150
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:54:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 082B016014F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:54:06 +0000 (UTC)
X-FDA: 84504593292.29.BE374B4
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1AE0CC000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:54:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20230601.gappssmtp.com header.s=20230601 header.b="X4c/85UH"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772538844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUWT63/jg9iqgoqLOExCtkSXzsQ+kIFy2uXbPBqqyUY=;
	b=c74N92lpNL8HHxwUtKLw7LHYeM5Ek2GVc4BhC+bjRw0+I6KTbxsTg41+EViVcr3bwGfmr0
	NAUZl9d2aHgM1isFwa3AcsWv5Wf3SmOgAYOdYLpuEy/1BW8rczwWyWcfqekHCuaPxNdbvj
	ocuhfMDHBNvRP42PTzyqIOA1M5YAgPI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20230601.gappssmtp.com header.s=20230601 header.b="X4c/85UH";
	spf=none (imf10.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.45) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772538844; a=rsa-sha256;
	cv=none;
	b=lUb9m/OB+l2OHa0jgLnD+AA7apb0oJo7Clho+o5PUkYqWEJl42oS3suD+OiElthmeJCrVe
	/td1EZRwRGvrp5UJis/WvAHGExM+Qwb1F9SS/s6+5rAmh53NlJRpo18uIYuSU6JaQNSMpy
	wT8S/6m1/vT3Q+PX3nFv24LDxGaa2l4=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-483a2338616so34760715e9.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 03:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20230601.gappssmtp.com; s=20230601; t=1772538842; x=1773143642; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FUWT63/jg9iqgoqLOExCtkSXzsQ+kIFy2uXbPBqqyUY=;
        b=X4c/85UH/5vrJH3z7Ck//K6kAa3HHfGtWXaUHAS8pSDxsmepudC0eKr44IUGiUKvtd
         GKdAfccPRKdjgVxS+fTWrhY5XTF4TarG8s2yctx8uxqhudxfxmGW88oiu88qhY7jDoxC
         mplTNor63PwTp9/xsUupgYDrcydkJiVX16l8eWo5uUtv92Vw2ohWFJfb6bDyxGnHLAcX
         LBO0CqbPpMOjiTxupvT4rrbjIfPpcnQInAN8lz0D+2tgmrUDRhbP+8hhabLr4Eb0Ighz
         PClpzhP5dNif/WObjkVW7JjkcnQktftM0I2mBNiYGCpxDWkC0BTHAZmDThTd54gHALM7
         eTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772538842; x=1773143642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FUWT63/jg9iqgoqLOExCtkSXzsQ+kIFy2uXbPBqqyUY=;
        b=qmdhED4NY8SmsrczbSTspGH7Q/t1mFVxgWyYUGD6/asmN+s3K7ou1RWYrmT3y8v+HT
         rMweCcDq+1LhHR1wNcH4M4jeHcGHdpos+VDLFwLzJfyFi0MZW1ENkBjdKVSqHOeahLm1
         5+VZBeHTU8DGzX2i2mF+4SLCvl4Bkb7w+NQcz5DGstQi7Eaduo+glDQXkabhWyqsWv1R
         8Ia7XA7vH+S1IEoKQQqndtTyMfamitcfpyYY/RUN/IW13uA9VNTseN65FBux3tKLqNK8
         XwlR1RMcKghibQMohZpjMPqXCzR/AJJ7hrvqBHCvbLnQwZnNDUtDTkMNg0PaFPosj+Lf
         O+Yw==
X-Forwarded-Encrypted: i=1; AJvYcCX+lMWVzMjlcMnoNCj+0q5QBcBVXqbEFk0p/TlZQD1l7Hg2T21fYDtPWcpqmN1lR6rptiJ8VjmS2g==@kvack.org
X-Gm-Message-State: AOJu0Ywh0kzC4sKS7s47FoOS6q5+BIWqQtvFj63ZJ18H8o1+VR+/YfTL
	MhGKrWBo6U/ajzAY29HL9oRBiDC65AmnDYGvMEqTH8qtnCxsAACg0FdIKEKgVvbYuUI=
X-Gm-Gg: ATEYQzzeEGSUhFYk5738eEbJKXz/x/wvxT2QmvgnTqGmP4Wj5IcnYIf3BORpwrP59+W
	VHq9fc0rSPz4Iln2swGVmYZuL/65cPuSKFONixCZ9DV2Xgi2zZuDXu/4OLa4EBzyAVsJV7CdAke
	G/XLLsL1M7HIjDOvqZXImExhVAzzXqxak6NYYJA7oOOetQsdQPA4An/FoYNQOcD14yHMzD2PIZP
	q5BrENXbnE3odPf7XpDUXnBYhhBuzpvaOGOc8/op2hGMX9bnhO+aeGmE4CDWH0viwBY7piowJo5
	aoqs7q7QAcSuLAYcnms+qxPQE68aA05WtN90MNFLzpQRxfTzr0qLc98NnsFXqzupjdByTD6JvmR
	kA36MPzCeQqPuqkE4JT1yTmoPbSas6TzZLVg00NeA7PIb/BWSbcWIdnMI2m7yrfCfzf/YUGLQg6
	aO9pWG8hv55g6kwtWWcOIWUT4=
X-Received: by 2002:a05:600c:45d5:b0:480:6c75:ddce with SMTP id 5b1f17b1804b1-483c9c11ef1mr271279875e9.33.1772538842224;
        Tue, 03 Mar 2026 03:54:02 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac1:2880:f0::15:430])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b3cc2e65sm18598717f8f.2.2026.03.03.03.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 03:54:01 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [RFC PATCH 1/1] mm: Reduce direct reclaim stalls with RAM-backed swap
Date: Tue,  3 Mar 2026 11:53:58 +0000
Message-ID: <20260303115358.1323188-2-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260303115358.1323188-1-matt@readmodwrite.com>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kxbdf8uxiyt9hrqktyqrr3ca4c8g33j9
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AE0CC000A
X-HE-Tag: 1772538843-517913
X-HE-Meta: U2FsdGVkX18XbGLWorIv7yrmyKWyC/NJQjoB6AVNuTXYRcNk/u64KDQlRar+bJ/7dkEaxNlYjVv9QS6W3mYa6b0y3wuMmWryTqRkmlcx/HFnquDV64CqmpCnEyHgOumPGvsSX80vwpLd+fAOI8GxPNQ2lFBjHw2AqL9jaQp1TnGojuqnKVDhxgUOgB9O+g0u90H7uFLbIP1UhGD1HrgCRgYmFdgkRqSA0jgzrha25nSFwhR8ETz6C2iA/s7Ge5/fWg/OtewHfz986rcsn8sKUHsRDpNWPLDo210S1OtWJX1lLzvM/DerHTzMlJnrhub6pP2WhX/GzcXyDxDnSUwVJXuyQdMZCJpNaJ11fxmK5YAUXX2+KjI+uFcuvqWRXcFqeoE6i/A9jfpG0Kju9fgKftMyma3lpy5eBWukyRkhmDaeE/B4CPLWNogpgh6/oE6i/8AgvNaMqkOTXhRWhYPoMDdZEvkcHx2YZaV2b2WgosaBxfYgkFvj942Ymk8ChoW8vxh+Jl0wn2S/f0pZ6wE/rHuuyDSVpqVMsjVzi7DaALHctdxTmGgJoztEtSEksSDkdGLDggIP1d8SZMtH19PIjzLtxgUpoODxgeTyLqftt/3cBZd6LQJ0me1a+v1wWSdN2apgDGAU0pV7Fj6az5XwUYO6fEhwwuAXql+rS+H1IRf8llTUUI6FMa1Jgf2tyqUjhy0fspX6/2zggCGujrAdP3mqS53KkpO5UOLPrJ4CM99kvup+dRr9QYAs9gYVh95YbPPumV0K+6RpmK2r9VydujjDdjkkkj/pEJViuLE46YuHSppnZGipEPjAkkPWnIpS0tvgXlYwwKDEzvuPn6XTCexKZqM2ai/0HlV5KJ5mZ0R4MBZVBXSMb7YMY25QZ5HzdJeEbCR93CLrsymJKPwBajdPv6Y1lsXoq/chECV6frM955CXrRZHYdVvz0r0k1HIH52HHGXqF49SjT2pYi1
 h+/7RkQ3
 lRtaoEppaY9WRorxBS8fza0VHgLHLja2DN7xCy3mkC7GFdIBIRX+MfTKB7FwWJKvzTyy9PB60QNxib2LzCkNCbvyylw7wMQxNqLmce34a1YMER48Diw/6vFIdjtVJH3C2lq5h+wFlpf5AfT4O22OYKYczOmiQRVzGGUplPBc+JmxWitSMKzhvvdGSLcdvhae50a1bO+zL8XQdZgdyACLKt26sAp5yTK87l99UYjsKHvGfMiKfFQgFetxOP7oyH2oeaNZCAK/mKepSDGs0em0ZRE2S7CAdllPSKdJlu6Pd4vTveWyThGM86PLNGj+MLpaVxOJFePnrvkppk9YBtKbxrAScFpKC4VfcsIqjACWLugNtWjlbmgQMFpwsufm8EUV190IuqWVqZ5t6Zsz6d4Yg6xUbck2CLuoYu/U2ruZsn1PwVZYvy1uxGIjZpihJ989UuiHMT+POFJ38rx3W2cie0G8WMuhbYwViTp86jw6uBo4jAgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matt Fleming <mfleming@cloudflare.com>

The current should_reclaim_retry() code does not account for the fact
the number of logical swap pages available for RAM-backed swap (zram,
brd) is dependent on having enough free physical pages, and simply
always assumes that enough pages are reclaimable to satisfy the
allocation.

For instance, given a system with a 200GiB zram device (10% used) and
100MB of free physical pages, should_reclaim_retry() incorrectly
concludes that it can swap 180GiB worth of anon pages to swap.

Because it appears to be always possible to write to swap, the OOM
killer is delayed and the system retries in direct reclaim for
prolonged periods (20-30 minutes observed in production).

Fix this by excluding anon pages from the reclaimable estimate when all
active swap devices are RAM-backed. Once file-backed pages are exhausted
the watermark check fails and the kernel falls through to OOM as
expected.

To identify RAM-backed swap devices at swapon time, introduce
BLK_FEAT_RAM_BACKED (set by zram and brd) and SWP_RAM_BACKED
(swapfile.c). A cached bool swap_all_ram_backed is maintained under
swap_lock by swap_update_all_ram_backed() during swapon/swapoff, which
is locklessly accessed in should_reclaim_retry().

Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 drivers/block/brd.c           |  3 ++-
 drivers/block/zram/zram_drv.c |  3 ++-
 include/linux/blkdev.h        |  8 ++++++
 include/linux/swap.h          |  9 +++++++
 mm/page_alloc.c               | 23 ++++++++++++++++-
 mm/swapfile.c                 | 47 ++++++++++++++++++++++++++++++++++-
 6 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 00cc8122068f..c021dd51ff0a 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -310,7 +310,8 @@ static int brd_alloc(int i)
 		.max_discard_segments	= 1,
 		.discard_granularity	= PAGE_SIZE,
 		.features		= BLK_FEAT_SYNCHRONOUS |
-					  BLK_FEAT_NOWAIT,
+					  BLK_FEAT_NOWAIT |
+					  BLK_FEAT_RAM_BACKED,
 	};
 
 	brd = brd_find_or_alloc_device(i);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index bca33403fc8b..8075bab39e62 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3074,7 +3074,8 @@ static int zram_add(void)
 		.max_write_zeroes_sectors	= UINT_MAX,
 #endif
 		.features			= BLK_FEAT_STABLE_WRITES |
-						  BLK_FEAT_SYNCHRONOUS,
+						  BLK_FEAT_SYNCHRONOUS |
+						  BLK_FEAT_RAM_BACKED,
 	};
 	struct zram *zram;
 	int ret, device_id;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d463b9b5a0a5..3666837e8774 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -334,6 +334,9 @@ typedef unsigned int __bitwise blk_features_t;
 /* is a zoned device */
 #define BLK_FEAT_ZONED			((__force blk_features_t)(1u << 10))
 
+/* storage is backed by system RAM (e.g. zram, brd) */
+#define BLK_FEAT_RAM_BACKED		((__force blk_features_t)(1u << 11))
+
 /* supports PCI(e) p2p requests */
 #define BLK_FEAT_PCI_P2PDMA		((__force blk_features_t)(1u << 12))
 
@@ -1477,6 +1480,11 @@ static inline bool bdev_synchronous(struct block_device *bdev)
 	return bdev->bd_disk->queue->limits.features & BLK_FEAT_SYNCHRONOUS;
 }
 
+static inline bool bdev_ram_backed(struct block_device *bdev)
+{
+	return bdev->bd_disk->queue->limits.features & BLK_FEAT_RAM_BACKED;
+}
+
 static inline bool bdev_stable_writes(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 62fc7499b408..844727fe929c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -216,6 +216,7 @@ enum {
 	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
+	SWP_RAM_BACKED	= (1 << 13),	/* swap device uses main memory (e.g. zram) */
 					/* add others here before... */
 };
 
@@ -451,6 +452,11 @@ static inline long get_nr_swap_pages(void)
 }
 
 extern void si_swapinfo(struct sysinfo *);
+extern bool swap_all_ram_backed;
+static inline bool swap_is_all_ram_backed(void)
+{
+	return READ_ONCE(swap_all_ram_backed);
+}
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 int swap_type_of(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
@@ -508,6 +514,9 @@ static inline void put_swap_device(struct swap_info_struct *si)
 
 #define si_swapinfo(val) \
 	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
+
+static inline bool swap_is_all_ram_backed(void) { return false; }
+
 #define free_folio_and_swap_cache(folio) \
 	folio_put(folio)
 #define free_pages_and_swap_cache(pages, nr) \
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..c1a8f4620baa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -37,6 +37,7 @@
 #include <linux/vmstat.h>
 #include <linux/fault-inject.h>
 #include <linux/compaction.h>
+#include <linux/swap.h>
 #include <trace/events/kmem.h>
 #include <trace/events/oom.h>
 #include <linux/prefetch.h>
@@ -4604,6 +4605,7 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 	struct zone *zone;
 	struct zoneref *z;
 	bool ret = false;
+	bool ram_backed_swap = swap_is_all_ram_backed();
 
 	/*
 	 * Costly allocations might have made a progress but this doesn't mean
@@ -4637,7 +4639,26 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 			!__cpuset_zone_allowed(zone, gfp_mask))
 				continue;
 
-		available = reclaimable = zone_reclaimable_pages(zone);
+		if (ram_backed_swap) {
+			/*
+			 * Exclude anon pages when all swap is RAM-backed.
+			 * The reclaimable estimate assumes anon can be
+			 * reclaimed using free swap slots, but those slots
+			 * are only logical accounting for zram: storing the
+			 * swapped data still consumes physical pages. Free
+			 * RAM is the real limit, so counting anon inflates
+			 * 'available', keeps the watermark check passing,
+			 * and delays falling through to OOM.
+			 */
+			reclaimable =
+				zone_page_state_snapshot(zone,
+							 NR_ZONE_INACTIVE_FILE) +
+				zone_page_state_snapshot(zone,
+							 NR_ZONE_ACTIVE_FILE);
+		} else {
+			reclaimable = zone_reclaimable_pages(zone);
+		}
+		available = reclaimable;
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 
 		/*
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 94af29d1de88..18713618f35c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -64,6 +64,7 @@ static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
 			 enum swap_cluster_flags new_flags);
+static void swap_update_all_ram_backed(void);
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
@@ -74,8 +75,15 @@ atomic_long_t nr_swap_pages;
  * check to see if any swap space is available.
  */
 EXPORT_SYMBOL_GPL(nr_swap_pages);
-/* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
+
+/*
+ * Updates to these globals are serialized by swap_lock.
+ * Read locklessly in vm_swap_full() (total_swap_pages) and
+ * should_reclaim_retry() (swap_all_ram_backed).
+ */
 long total_swap_pages;
+bool swap_all_ram_backed;
+
 #define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
@@ -2670,6 +2678,8 @@ static void _enable_swap_info(struct swap_info_struct *si)
 
 	plist_add(&si->list, &swap_active_head);
 
+	swap_update_all_ram_backed();
+
 	/* Add back to available list */
 	add_to_avail_list(si, true);
 }
@@ -2813,6 +2823,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_lock(&p->lock);
 	del_from_avail_list(p, true);
 	plist_del(&p->list, &swap_active_head);
+	swap_update_all_ram_backed();
 	atomic_long_sub(p->pages, &nr_swap_pages);
 	total_swap_pages -= p->pages;
 	spin_unlock(&p->lock);
@@ -3460,6 +3471,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (si->bdev && bdev_synchronous(si->bdev))
 		si->flags |= SWP_SYNCHRONOUS_IO;
 
+	if (si->bdev && bdev_ram_backed(si->bdev))
+		si->flags |= SWP_RAM_BACKED;
+
 	if (si->bdev && bdev_nonrot(si->bdev)) {
 		si->flags |= SWP_SOLIDSTATE;
 	} else {
@@ -3587,6 +3601,37 @@ void si_swapinfo(struct sysinfo *val)
 	spin_unlock(&swap_lock);
 }
 
+/*
+ * Recompute swap_all_ram_backed. Must be called with swap_lock held
+ * whenever a swap device is added to or removed from swap_active_head.
+ *
+ * swap_all_ram_backed is true when every active swap device is backed
+ * by main memory (e.g. zram, brd). False if there are no swap devices
+ * configured or at least one of them is backed by disk.
+ *
+ * With RAM-backed swap, swapping out an anonymous page does not yield
+ * net free pages because the driver must allocate physical RAM to
+ * store the compressed data.
+ *
+ * See should_reclaim_retry().
+ */
+static void swap_update_all_ram_backed(void)
+{
+	struct swap_info_struct *si;
+	bool all_ram = !plist_head_empty(&swap_active_head);
+
+	assert_spin_locked(&swap_lock);
+
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if (!(si->flags & SWP_RAM_BACKED)) {
+			all_ram = false;
+			break;
+		}
+	}
+
+	WRITE_ONCE(swap_all_ram_backed, all_ram);
+}
+
 /*
  * Verify that nr swap entries are valid and increment their swap map counts.
  *
-- 
2.43.0


