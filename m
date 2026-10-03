Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48086CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251C96B0093; Fri,  2 Oct 2026 20:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB7F6B0095; Fri,  2 Oct 2026 20:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F20F6B0096; Fri,  2 Oct 2026 20:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3D116B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:59:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 343A9C08B5
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:27 +0000 (UTC)
X-FDA: 85279506774.21.7EFDD7E
Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	by imf10.hostedemail.com (Postfix) with ESMTP id 86CB5C0009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0B5lRIfkRgQkQ+r9ObsfslAmHHBfDhBXObfWofKu2go=;
	b=vyxxKJQ39SKNUxBA9sRpz1ZHjKGBwkDdkNA1wVEovClN7R1wLwEH2/CTUqlI9zRsofNGHd
	HMMQi6PIWUn4upglM5jpFp6BNvaS2GBjMqqc32jC2OXFb/4+fFZ8rjiFMGLc01ALHRnDrq
	UG/GNhmN3CF3vxqjx/3Z7jL/T+5mO08=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989165;
	b=3fO7Tvmc9gg3Za9xLJORy7kAfdQHox8Jps9sbeK6cy88hbFb7B4vKG8u/rpMAaiLp6vjsW
	eFIVp1es3BrXUnPhQ51YYMWcquDyIEwkXeLDnZtpajsw+akXgPfD2V9IRQ5pobph6BzNbF
	GpLH8IHhp4mVvO2VPnepqKdGTPu/LZ4=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id eec46b8538ecd08a;
	Sat, 03 Oct 2026 00:59:20 +0000
X-Mizu-Trace-ID: eec46b8538ecd08a
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
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 01/12] mm, swap: prepare the swap IO path for xswap backends
Date: Sat,  3 Oct 2026 08:58:49 +0800
Message-ID: <20261003005900.909710-2-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ypgi6hrxiqafyymh55qx9sw3811sj1x8
X-Rspamd-Queue-Id: 86CB5C0009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790989163-260412
X-HE-Meta: U2FsdGVkX19441Et7jzpRunF2ZxHhf5Wn5wau3Oc5kuGBDnZbPpDqVU/gDctVhhhXHFRLxxpLB9aygyK1i0T5DBx4Y6SIz+5rw5omOZ1+JRjo9qHHxVy+hSUoX7zud1PiqsEhlxsKHgKlB+phJWloMyF4vxSl7i5G5UdYeT4Bs/8YncCCk5vH+f8nehYEi6SYfTz86zpHHbCaB9elUv82hCumQ//rED4tNPugMyYUfrH+nZuC9PB6qIUelwYCeECWDN02IX7xx9sJKUZmpBeAiQL1jaoDMN00B6iIAve5nJFL6zzTq8aYeMyXiOEYWHku3sm8mwROz3MTuZ1c5GefkLcyUm0UB+Pmy+yAFiEtGsOrsjNaZfGWwnYuUBE+i2YvshjDXYMr6rGjfR3av8+OYFtndbMud1EZtdWQu9FZJmrmOuzzV+GMp96VWnTzciMmiXsNfGY4LquGHV/3HOEqRs5yts8zOeiek2S/aCRx/dMbVuwMspDeUyHfPBLE7u2+mWQlxKFRfyJwMkj+Ay3KSRlpgbr6BYa1vdjm6b1lu3gHckFcsF0HN2nwDXGtPYqnzEZ8kfolXdcQ0sBgLvLGB8b8HOtevY6sfIul3x7eGRBVgSuY5Neu/0UglgbgjO2Pd6PExMG3dz54znrYRcH66nixOcPL328EnTqPGtNtsTPEGQYk1LJB9FkJWhUnsBI5QPEYF9I48LAIYqD5X6y2YhC221LuAqYs+YELXsTL2QooNyW2D6KxafUyeMXT2iKkgwVRlSZ+Rm1VIcVTUZF1fQ7RR1u7v3YvEK4odjAc3kHeUokpWeXs01wkwREdNETSyrdoY3q0HY3iFVqRwloV/RmK1ESe2/Re7PGVOZ8CAkJx2NH0JzBJjGkSHOTu/0zNPg6VaS/GL/SohJ7PMTfp8WnQV/NNjfEYk0IQKXdCQ/BOarr2U8S+GvuB7ZX41u4O0ZrmSoZ6mUnZkhKMYf
 mtdwLRd5
 gi/jeTxxdtqLe89iFEH8+UcKB0Uu7WzfyzDZ39pB+f7gjZiAisIVmOm9h95Blye+If05j8g5IWV/rrfRgrZmSqKxvEicrbYEmQo0WvHmbhbN10lJ3+zaJhwCDWBTyJpY8IFgVlgU8XrEq/yNu6xtjIk4ys18/+H6hWGulZ8aeQKKfLkTYf1PLAVSOKDPFoSnwD6z4RzJQEsrxxr8XzzPz8TpsGLRFM4cEU/v5elkQU6ZzASjm5pePFvFj3nql7hwryoor8qQznyDV/J0gt120SB01kETiVQwd4MNYz80o8EI/5/W2Pa8S5chmoco+3uggp4oe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

An xswap folio is written to a physical device, but stays in the swap
cache of its own xswap entry, so folio->swap no longer says where the IO
goes.

The batched swap IO path takes the bio sector from folio->swap, which for
such a folio resolves the xswap device. That device has no bdev and no
extents, so the IO is set up wrong.

Pass the entry explicitly instead: __swap_writeout(), swap_add_folio()
and swap_ops->can_merge() take it as a parameter, and swap_iocb records
the first entry of each batch. The merge check, the bio sector and the
completion path all use it.

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
index ae2e49386443..2080540c6e39 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -418,6 +418,7 @@ extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
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
index 25fa9b82ed46..16ae84e6b785 100644
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
@@ -332,24 +332,22 @@ int sio_pool_init(void)
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
@@ -362,6 +360,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
+		sio->entry = entry;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
@@ -382,7 +381,8 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio,
+		     swp_entry_t entry)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
@@ -398,7 +398,7 @@ void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	swap_add_folio(ctx, folio, WRITE);
+	swap_add_folio(ctx, folio, entry, WRITE);
 }
 
 /*
@@ -507,7 +507,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, READ);
+	swap_add_folio(ctx, folio, folio->swap, READ);
 
 finish:
 	if (workingset) {
@@ -539,8 +539,6 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct folio *folio = bvec_folio(&sio->bvecs[0]);
-
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
@@ -548,7 +546,7 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(folio->swap));
+				   ret, swap_dev_pos(sio->entry));
 	}
 
 	swap_write_end(sio, failed);
@@ -620,7 +618,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
@@ -649,7 +647,7 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_READ);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		/*
@@ -667,13 +665,15 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
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
@@ -689,7 +689,7 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 	struct swap_iocb *sio = ctx->sio;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
-	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	sio->iocb.ki_pos = swap_dev_pos(sio->entry);
 	if (rw == WRITE)
 		sio->iocb.ki_complete = swap_fs_write_complete;
 	else
@@ -700,11 +700,10 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
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
index d5bf21f517dc..fcde284b16b4 100644
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
index bf95663c2593..0d1288d36452 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -540,6 +540,19 @@ sector_t swap_folio_sector(struct folio *folio)
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
index 7fe25f0b157c..cdba35e0fb5a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1087,7 +1087,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_put(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio);
+	__swap_writeout(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 	return 0;
-- 
2.54.0


