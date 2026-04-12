Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F5EBF3ED6D
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 06:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C7A6B0089; Sun, 12 Apr 2026 02:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED226B008A; Sun, 12 Apr 2026 02:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102C86B0092; Sun, 12 Apr 2026 02:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00B966B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 02:05:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E8715C240
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 06:05:02 +0000 (UTC)
X-FDA: 84648865644.06.271BB15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 705B720008
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 06:05:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u8t+hu4n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775973900; a=rsa-sha256;
	cv=none;
	b=E1MObMtkxQ3s7buHSsby/CkvlUpP1VoBJZZz78ii5rTAEIGB19pU9fVSnhLh9+wSKB/E81
	JdM34RbZ66/lrDD/FwLyzTNBOMOiAGpI6ZLcJhgTeixsSuthKtSYtVk3H5kLt7MC1C0kQJ
	RYItLFM+gXs1kx7P1Z0yObhapy6cjXI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u8t+hu4n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775973900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xchAm7qJtuVYU/toyqO2WkCM6PUpAgYKYl/x/R6dL0s=;
	b=3ntlMoG2aj+34sjS4qCRQgoRKgkphInCbelL/eaGTJ+pPIUISfvtKVAkSTDWUmA4J0CtEy
	Je4kBYzidK1rrpP8hHF78UNFOS6etBUN9k1K+bZwVykCxWnvJoqgTu2ig15OOmoQkN7EM7
	rVTl3f3t686IYwIcNbwXUBDmXb5D6oM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3491D4384E;
	Sun, 12 Apr 2026 06:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B2CC19424;
	Sun, 12 Apr 2026 06:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775973899;
	bh=Dz2ZpyaJE5N3ivs/LNJoNNsR0t6ba3qDLDroFxRApMI=;
	h=From:To:Cc:Subject:Date:From;
	b=u8t+hu4nKnIVEFMZRYk5CARvGYJWlNavZHWE009R+aAX4CiWkGrDKne7MHgA65VbX
	 LsIx/AnKdtxM0Ki/3LWXdSBACeNmRI2NlW6NDmgjX4gt+4yAlk4KY2zspyVA9ooEyn
	 vGg9g89ifYmiyYPAFWFgmSEdfnmBmFXUbxaSuJEnb2rs0GxHPcEFsgF0JezxKjg+6K
	 lB4CmvzJJGzUCCSCzedqIb07hrnXIJd9ENdd5sThzCCcy1S9SNJFF1YCw7jxsE4bDa
	 f7MAErGU71/sySW72+qa74IVES2fORh7ME2QuwAy7yynzBi9eVzln0/siaclSfz/D0
	 EgIzBZPnM3V/w==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: minchan@kernel.org,
	senozhatsky@chromium.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	chrisl@kernel.org,
	justinjiang@vivo.com,
	liulei.rjpt@vivo.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH] zram: support asynchronous GC for lazy slot freeing
Date: Sun, 12 Apr 2026 14:04:50 +0800
Message-Id: <20260412060450.15813-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 705B720008
X-Stat-Signature: eqbacxyjr8b3cfbmmy8jukibdkrrboxx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775973900-362472
X-HE-Meta: U2FsdGVkX195ZhXVu59yz9pwEpdlGmU3/BeL1Law5njqyRa9rAGuWgAYgTMAej4hllM1z62NzqZ6prvSGDDuiODRnCScPjftac+Z4cy1rhAtBYXyX1U+pxu0NRJdlPdj1xsYleVe9N5JBNnhMidMwHozd4nOn45NIfDG0o228+WIeW7K6ShwxaX5xSrRIKBdY6LH6z5zjC7CFlJTopFDZMnRHrkEkQ1ULsLZAc2e6ohrOcSMbA6WCMlmU/4AdgzIyCHp6hGp0VdR8+oynXlPZEsS5+mNd0MEKNqfhYnQuoFTYu3p0A8QEJ4XpvOvb9xe3SsYSJm03DhSbbPRnoUqZT051SXPxXqm3JQXa+3H6fBptKhH3kmKG5A9KsF6joXX7o2hmPrnuVo8oYtCIW+mwAbBxq/A4o6j6OmnJNQZe6Gfgmb/V9N5PpPkS8ISCN87rYkOoJ9aIHQ3lFbwWYzB8MPQQS/VgNo6L03wu5wqewP8tgRWmJj9LCo3QTTj7NlEm/WFFL/BB7jq0DpLhXzVpY8cBcQpNtIwxInyAH78ph1Lrjh85m+gD4vhfA4UeRmKTdoozhdGnbmNokkCWP6aWHC7L4WEI+zb+GdDhhOvJdt2KeoTW8oDzScRJLMtySC7CHpdKtv8XL1+Vc17OQP0xxILBWI5jBMQDq3EV6/mcWOKmKsDXuscGoj3oHwTHcFhrCaXq6vdGLY0ZWzY5Qaa8g7Nsxsf+V9c7Vhro1FRLNcUSCx0hnjZChe5OsR8Xv/K2AMQX9TMNtNMOWeYC+uWwSnnyxiOJ3guvHqXiUKUAVA0dQ1Y79olOhzxbCTI84myw+64dRKsipeZ5UxBQZOec7mu94xyp2Sk3nH8WbSQ0GXabudJDhEgiN3RSzOIKzTdaNmdw2f8FX/jqja4NXM195ru7JsOtBvuFThCWC7zAlxpb3D8TpQsGkvMYFtPNQXA8/Efa5BNsQKc0LLAbYL
 H5AxYIgT
 7ut031kE9JPqLEmCLtAm7JWLKaGr3pxUa83UDm7qfztat47DbF6RgptJaZKAEu1uWBgRvLcdnz0JsSFzk4k721JeopEFE1QSGSX5rY+/1WlJ0P3Jln/DF3U6Bzp6riNKv9564K+NkNpVHJ2Ld99irX2y5xllg4m9mYXN03vfI29rvyKLIaKuNauer+T8xieGVgcYaZrs2JaEXO5XFQfDfybVSSIbLC5aUr5mBYQ56FPow7sXAKDMhkl+q3fyaZ5YTs9X095Pqy7sxhoTSp+mmYeVEZmlTkB9KdBSo+bwleN9U5qByJ6uMRj0ZkoG2Wsjw+o3IJyJyYqbaJAg0o70n87IatsRPqunlmVCbVcV5EYb9+ltkQo+eQjOxC46awDcimJmq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap freeing can be expensive when unmapping a VMA containing
many swap entries. This has been reported to significantly
delay memory reclamation during Android’s low-memory killing,
especially when multiple processes are terminated to free
memory, with slot_free() accounting for more than 80% of
the total cost of freeing swap entries.

Two earlier attempts by Lei and Zhiguo added a new thread in the mm core
to asynchronously collect and free swap entries [1][2], but the
design itself is fairly complex.

When anon folios and swap entries are mixed within a
process, reclaiming anon folios from killed processes
helps return memory to the system as quickly as possible,
so that newly launched applications can satisfy their
memory demands. It is not ideal for swap freeing to block
anon folio freeing. On the other hand, swap freeing can
still return memory to the system, although at a slower
rate due to memory compression.

Therefore, in zram, we introduce a GC worker to allow anon
folio freeing and slot_free to run in parallel, since
slot_free is performed asynchronously, maximizing the rate at
which memory is returned to the system.

Xueyuan’s test on RK3588 shows that unmapping a 256MB swap-filled
VMA becomes 3.4× faster when pinning tasks to CPU2, reducing the
execution time from 63,102,982 ns to 18,570,726 ns.

A positive side effect is that async GC also slightly improves
do_swap_page() performance, as it no longer has to wait for
slot_free() to complete.

Xueyuan’s test shows that swapping in 256MB of data (each page
filled with repeating patterns such as “1024 one”, “1024 two”,
“1024 three”, and “1024 four”) reduces execution time from
1,358,133,886 ns to 1,104,315,986 ns, achieving a 1.22× speedup.

[1] https://lore.kernel.org/all/20240805153639.1057-1-justinjiang@vivo.com/
[2] https://lore.kernel.org/all/20250909065349.574894-1-liulei.rjpt@vivo.com/

Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 drivers/block/zram/zram_drv.c | 56 ++++++++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.h |  3 ++
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index c2afd1c34f4a..f5c07eb997a8 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1958,6 +1958,23 @@ static ssize_t debug_stat_show(struct device *dev,
 	return ret;
 }
 
+static void gc_slots_free(struct zram *zram)
+{
+	size_t num_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long index;
+
+	index = find_next_bit(zram->gc_map, num_pages, 0);
+	while (index < num_pages) {
+		if (slot_trylock(zram, index)) {
+			if (test_bit(index, zram->gc_map))
+				slot_free(zram, index);
+			slot_unlock(zram, index);
+			cond_resched();
+		}
+		index = find_next_bit(zram->gc_map, num_pages, index + 1);
+	}
+}
+
 static void zram_meta_free(struct zram *zram, u64 disksize)
 {
 	size_t num_pages = disksize >> PAGE_SHIFT;
@@ -1966,6 +1983,9 @@ static void zram_meta_free(struct zram *zram, u64 disksize)
 	if (!zram->table)
 		return;
 
+	flush_work(&zram->gc_work);
+	gc_slots_free(zram);
+
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++)
 		slot_free(zram, index);
@@ -1973,6 +1993,14 @@ static void zram_meta_free(struct zram *zram, u64 disksize)
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
 	zram->table = NULL;
+	bitmap_free(zram->gc_map);
+}
+
+static void zram_gc_work(struct work_struct *work)
+{
+	struct zram *zram = container_of(work, struct zram, gc_work);
+
+	gc_slots_free(zram);
 }
 
 static bool zram_meta_alloc(struct zram *zram, u64 disksize)
@@ -1991,12 +2019,22 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 		return false;
 	}
 
+	zram->gc_map = bitmap_zalloc(num_pages, GFP_KERNEL);
+	if (!zram->gc_map) {
+		zs_destroy_pool(zram->mem_pool);
+		vfree(zram->table);
+		zram->table = NULL;
+		return false;
+	}
+
 	if (!huge_class_size)
 		huge_class_size = zs_huge_class_size(zram->mem_pool);
 
 	for (index = 0; index < num_pages; index++)
 		slot_lock_init(zram, index);
 
+	INIT_WORK(&zram->gc_work, zram_gc_work);
+
 	return true;
 }
 
@@ -2008,6 +2046,8 @@ static void slot_free(struct zram *zram, u32 index)
 	zram->table[index].attr.ac_time = 0;
 #endif
 
+	if (test_and_clear_bit(index, zram->gc_map))
+		atomic64_dec(&zram->stats.gc_slots);
 	clear_slot_flag(zram, index, ZRAM_IDLE);
 	clear_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
@@ -2781,6 +2821,19 @@ static void zram_submit_bio(struct bio *bio)
 	}
 }
 
+static bool try_slot_lazy_free(struct zram *zram, unsigned long index)
+{
+	/* too many lazy-free slots, perform direct free */
+	if (atomic64_read(&zram->stats.gc_slots) > 30000)
+		return false;
+	if (test_and_set_bit(index, zram->gc_map))
+		return false;
+	/* accumulated lazy-free slots, wake up GC worker */
+	if (atomic64_inc_return(&zram->stats.gc_slots) > 200)
+		queue_work(system_dfl_wq, &zram->gc_work);
+	return true;
+}
+
 static void zram_slot_free_notify(struct block_device *bdev,
 				unsigned long index)
 {
@@ -2794,7 +2847,8 @@ static void zram_slot_free_notify(struct block_device *bdev,
 		return;
 	}
 
-	slot_free(zram, index);
+	if (!try_slot_lazy_free(zram, index))
+		slot_free(zram, index);
 	slot_unlock(zram, index);
 }
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 08d1774c15db..1f3ffd79fcb1 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -88,6 +88,7 @@ struct zram_stats {
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
 	atomic64_t miss_free;		/* no. of missed free */
+	atomic64_t gc_slots;		/* no. of queued for lazy free by gc */
 #ifdef	CONFIG_ZRAM_WRITEBACK
 	atomic64_t bd_count;		/* no. of pages in backing device */
 	atomic64_t bd_reads;		/* no. of reads from backing device */
@@ -142,5 +143,7 @@ struct zram {
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
 	struct dentry *debugfs_dir;
 #endif
+	unsigned long *gc_map;
+	struct work_struct gc_work;
 };
 #endif
-- 
2.39.3 (Apple Git-146)


