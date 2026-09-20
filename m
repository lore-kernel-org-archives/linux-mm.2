Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6078C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15E96B008C; Sun, 20 Sep 2026 03:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC946B0092; Sun, 20 Sep 2026 03:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A7B6B0093; Sun, 20 Sep 2026 03:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2446B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:21:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 190711203FF
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:02 +0000 (UTC)
X-FDA: 85233293964.29.7EB02FC
Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDEB8100004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:20:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888860;
	b=jrANEBznWYoaWby9anDOEQJlIjtgDD82ZgzRrT3lz/oSnx6R5NBXsaOoMjYxu2HywT+zCg
	we9CvDK441JsR9QuSJjE6UymflbH9t1O0onEEETPkwl7kwYntdNQUg0zr5Hjx/XiKGfdqb
	lDdEbQFzy4ivuBC3nUTJ/GZ9XmAOhaQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SL0P0v23Nbe4r5Ox426eYC69GWNt+uypchKVdVxv26g=;
	b=YoObzIE451tCVc5RpPFQnacDQXHTxuTRtsOY31w/GOJWK0fM5BkmuqgR7UiX1urmszJayy
	m83U5cMfz69dYg7+hwziA2yj/x/WJmyBTE/ECqNe+gBm0t89rp6RFhmCBZpuOBbngDSdPO
	JgcvjGZzAgnhdJRvl036I8AgW8aeQ4Q=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 56f5ed382b2eea4d;
	Sun, 20 Sep 2026 07:20:57 +0000
X-Mizu-Trace-ID: 56f5ed382b2eea4d
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 01/17] mm, swap: prepare the swap IO path for xswap backends
Date: Sun, 20 Sep 2026 15:20:27 +0800
Message-ID: <20260920072043.430390-2-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CDEB8100004
X-Rspam-User: 
X-Stat-Signature: dwcfymfq4nfoza3hrrpmtgxw3ktzxj3i
X-HE-Tag: 1789888859-318889
X-HE-Meta: U2FsdGVkX18TuTV71lGy4xsA7NkYGt/VS8uuiGYLsIh2LCmJsWdg8A95hefSgkaxV6Nm1tbElJpIAMFDHwCX08X75K+0YT50y2qlXvl4hIRDsCr2idtnIXIjV26MgSUxCzKf27vF32vNaOD3lj+hyXKPRO14n8lSg/K5WpFNyCG5K4+uklTtVKg4nVlKxjcmR28fmrHmmGwHKcVn470LJBslNrs6XKo52mgUJJqEbrqSDm9lzRPVjE9aFibqehrPDGRhrYoFm996GrMwf6vHJG2oHoyYr4H/8InHRQqRSYrPutdKO5y9OoNoixsN7sbUdzHk+Q1afMC0fn+MD4CcbJc4R1taoGIjg9tO/5Xw0G7Z4Mla1yI3UGJZGOeL+LEKoZt6ogawTvysN6G5bpFARoqSbohnbisa5D8Vmf2PgZa3F28tcoawRt4LL41eLs3Q2VUdTtvBgM4Ebh+pP9mxtSz5WrNUJgN8dSd4n/MiSYGwfMgLLuLKyj9XGjh0nqAOzhlrQgzt2eykkp4uazHbQEI5UKtFU2yoI1aJuR6KwNWQB290HD+HOSEdYH0BAlhNT7mR+V51uO+eGnfpb381viiScAxZfZGxk46sqoj3RhhLvWOU/3KHB5cyc/yn8mx1ra30/5sMOmfWOTzG65o2qVj+vzwuy5vhkwCO70qJJSVCv7bJQK5+b5dV2WXM1kmvgK7n4lPCMY1fi975v9BNN4YsFNooEdLyFef/xqs2VRdd06aZa7lTRLo0PNy5VFX+HdmtCkdtpspGiJ3nQZReCB/ayLaAEzjXvKHdSRcMvd9g9tJ9HvJ+p5s2uGGwLhah/oVya9D4teTVkGtwsae7N+lI3K2kThSBeYnRUVvpu9ZDoWoSXwbh5uclrC5fC+oZjltUusdqqWx1rMZxTtDqLokVubplYaOD7RLChYvkQFHKd5F7rt6S844gBQ7aF5bVRntWoUXc7/f9Jp/Pnbj
 trSaIsLY
 0wR9dIWHndcJ9v5cKOi5jgCvkoP5Saxpx8a4UItOMWDdB70Sy3qT+UnK91XrJxjpuxiLI1vTKdGHYtHJTAOcGTCSyo+C4HFGPyPbII2Ma6wOLNe799ZGHH7y/EPOuAV5aMgC54KMeiDj06xns2BIe8Gfn3DJqkZDzvsW0aTEJrRZoarTj/GnzFdCCZz5P8sAEuLHJxr5OhRxMrVcUCZRL8OUc1ls09zYsjdGzqwvPlvhbzaZwgrDQhjQgIh5vjB8eXiSddLciMi+ZTpHwvi/gHcoLAgQ96+Dl1Rbm6vpkNVvxRquAqvdMICv1IlrNVewNE9XQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

An xswap folio can be written to a physical device. The folio stays in
the swap cache of its own xswap entry. The IO goes to a slot on that
physical device. So folio->swap no longer describes where the IO goes.

The batched swap IO path takes the bio sector from folio->swap. For
such a folio it resolves the xswap device, not the physical one. An
xswap device has no bdev and owns no extents, so both the device and
the sector come out wrong.

Carry the entry explicitly instead. __swap_writepage(), swap_add_folio()
and the swap_ops->can_merge() all take it as parameter. swap_iocb records
the first entry of each batch. The merge check, the bio sector and the
completion path all address the IO from it.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h     |  1 +
 include/linux/swap_ops.h |  9 ++++---
 mm/page_io.c             | 55 ++++++++++++++++++++--------------------
 mm/swap.h                |  3 ++-
 mm/swapfile.c            | 13 ++++++++++
 mm/zswap.c               |  2 +-
 6 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 804189b4b4eb..b9a9a02007cf 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -419,6 +419,7 @@ extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);
+sector_t swap_entry_sector(swp_entry_t entry);
 
 /*
  * If there is an existing swap slot reference (swap entry) and the caller
diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 57ac6c703f68..198c5738c3c7 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -10,6 +10,7 @@ struct swap_iocb {
 		struct bio	bio;
 	};
 	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
+	swp_entry_t		entry;	/* First entry of the batch */
 	int			nr_bvecs;
 	int			len;
 };
@@ -30,15 +31,15 @@ struct swap_io_ctx {
 struct swap_ops {
 	unsigned int		flags;
 
-	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
-			size_t prev_folio_size, int rw);
+	bool (*can_merge)(struct folio *folio, swp_entry_t entry,
+			  struct swap_iocb *sio, int rw);
 	void (*submit_write)(struct swap_io_ctx *ctx);
 	void (*submit_read)(struct swap_io_ctx *ctx);
 };
 
 void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter);
-bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw);
+bool swap_fs_can_merge(struct folio *folio, swp_entry_t entry,
+		       struct swap_iocb *sio, int rw);
 int swap_fs_activate(struct swap_info_struct *sis, const struct swap_ops *ops);
 
 #endif /* _MM_SWAP_OPS_H */
diff --git a/mm/page_io.c b/mm/page_io.c
index d685c2e2429a..2b1387c87e51 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -257,7 +257,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writeout(ctx, folio);
+	__swap_writeout(ctx, folio, folio->swap);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -328,24 +328,22 @@ int sio_pool_init(void)
 }
 
 static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
-		int rw)
+		swp_entry_t entry, int rw)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
-	struct folio *prev_folio = bvec_folio(last_bv);
-	size_t prev_folio_size = folio_size(prev_folio);
+	struct swap_info_struct *sis = __swap_entry_to_info(entry);
 
 	if (ctx->sis != sis)
 		return false;
-	return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
+	return sis->ops->can_merge(folio, entry, ctx->sio, rw);
 }
 
-static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
+static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio,
+			   swp_entry_t entry, int rw)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(entry);
 	struct swap_iocb *sio = ctx->sio;
 
-	if (sio && !swap_can_merge(ctx, folio, rw)) {
+	if (sio && !swap_can_merge(ctx, folio, entry, rw)) {
 		if (rw == WRITE)
 			swap_write_submit(ctx);
 		else
@@ -358,6 +356,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
+		sio->entry = entry;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
@@ -378,7 +377,8 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio,
+		     swp_entry_t entry)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
@@ -394,7 +394,7 @@ void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	swap_add_folio(ctx, folio, WRITE);
+	swap_add_folio(ctx, folio, entry, WRITE);
 }
 
 /*
@@ -503,7 +503,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, READ);
+	swap_add_folio(ctx, folio, folio->swap, READ);
 
 finish:
 	if (workingset) {
@@ -535,8 +535,6 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct folio *folio = bvec_folio(&sio->bvecs[0]);
-
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
@@ -544,7 +542,7 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(folio->swap));
+				   ret, swap_dev_pos(sio->entry));
 	}
 
 	swap_write_end(sio, failed);
@@ -616,7 +614,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
@@ -636,7 +634,7 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_READ);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		/*
@@ -654,13 +652,15 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	}
 }
 
-static bool swap_bdev_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw)
+static bool swap_bdev_can_merge(struct folio *folio, swp_entry_t entry,
+				struct swap_iocb *sio, int rw)
 {
-	if (swap_folio_sector(folio) !=
-	    swap_folio_sector(prev_folio) + (prev_folio_size >> SECTOR_SHIFT))
+	if (swap_entry_sector(entry) !=
+	    swap_entry_sector(sio->entry) + (sio->len >> SECTOR_SHIFT))
 		return false;
-	if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
+	if (rw == WRITE &&
+	    !folio_blkg_can_merge(folio,
+				  bvec_folio(&sio->bvecs[sio->nr_bvecs - 1])))
 		return false;
 	return true;
 }
@@ -676,7 +676,7 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 	struct swap_iocb *sio = ctx->sio;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
-	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	sio->iocb.ki_pos = swap_dev_pos(sio->entry);
 	if (rw == WRITE)
 		sio->iocb.ki_complete = swap_fs_write_complete;
 	else
@@ -687,11 +687,10 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 }
 EXPORT_SYMBOL_GPL(swap_fs_prepare_rw);
 
-bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw)
+bool swap_fs_can_merge(struct folio *folio, swp_entry_t entry,
+		       struct swap_iocb *sio, int rw)
 {
-	return swap_dev_pos(folio->swap) ==
-		swap_dev_pos(prev_folio->swap) + prev_folio_size;
+	return swap_dev_pos(entry) == swap_dev_pos(sio->entry) + sio->len;
 }
 EXPORT_SYMBOL_GPL(swap_fs_can_merge);
 
diff --git a/mm/swap.h b/mm/swap.h
index b3b54c28929a..14b8c6b9d468 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -258,7 +258,8 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio,
+		     swp_entry_t entry);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ab64bfc4e0f7..29118082cd7a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -452,6 +452,19 @@ sector_t swap_folio_sector(struct folio *folio)
 	return sector << (PAGE_SHIFT - 9);
 }
 
+sector_t swap_entry_sector(swp_entry_t entry)
+{
+	struct swap_info_struct *sis = __swap_entry_to_info(entry);
+	struct swap_extent *se;
+	sector_t sector;
+	pgoff_t offset;
+
+	offset = swp_offset(entry);
+	se = offset_to_swap_extent(sis, offset);
+	sector = se->start_block + (offset - se->start_page);
+	return sector << (PAGE_SHIFT - 9);
+}
+
 /*
  * swap allocation tell device that a cluster of swap can now be discarded,
  * to allow the swap device to optimize its wear-levelling.
diff --git a/mm/zswap.c b/mm/zswap.c
index 96fb993d18cb..b4ffd6fb83eb 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1073,7 +1073,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio);
+	__swap_writeout(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 out:
-- 
2.54.0


