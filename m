Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53496CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D8E6B009B; Thu, 28 May 2026 08:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966696B009D; Thu, 28 May 2026 08:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87BD46B009E; Thu, 28 May 2026 08:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70E686B009B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:46:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37AC11C2035
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:42 +0000 (UTC)
X-FDA: 84816802644.18.9BA88FC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8A9331C0003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1CGjzNMj;
	spf=none (imf20.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7pJIbCGbSQoMUCFGh9NwmZkPk8nEby5TU84WHXUFgA=;
	b=xcZsaOH9eNJaVUqwlNBiLsT2zvEoqfSbcs4RBBpQ+UmAkKgIAgzaM/q2m2hPTpesi2f1rN
	SPnxFPKwZfZvVst5GYlhniC4mV5j87ITPDkKZXrpYoAocQ35mvvYPH2Lb4lbJKrAdY+cwN
	fByP0bpJwYOdxvww+HPvizg9vx4BPXo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1CGjzNMj;
	spf=none (imf20.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972400; a=rsa-sha256;
	cv=none;
	b=0gA6lXH2peKTRfNMN7rgwmnF6sZ4uEW+Sq4cbi0LYKrbZwfvoZUDogsy/VJdduFWnwA/y5
	JfUoYfWLqZK7TUQHpDWsHbhqJH1C6qbh982jzAfM+6o0JW1/fvWjC5lMjaSOcTSa2j85SM
	J4Xi/zGjMZCnO77TUDZV2NZpZ4J0pZY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=z7pJIbCGbSQoMUCFGh9NwmZkPk8nEby5TU84WHXUFgA=; b=1CGjzNMjY2e6St4ZDqjc2cq0Js
	tfbzYYhTJm6ek5qYOoKqXWeTdytzpOWeoZPeQgQ39nsb8QLsNfRrkIxKba2FHi1hkNN+TDY8dAZuy
	yRBioucoM8AtpWRK02dNjOt6+AILDttJE2h8hXloB97MbHonZh5EDGZjQiFs1U0TQMjnbGRkBHDwz
	bJP1wuyVb21uhxX8D09aulwpfB4BmGPjdN60iAct137ucN/lSzbiwi+gW1FAsm71chWSOZVLfhSGP
	u9m2alDtGLeyIP51gOi59Vd0CdN/7ZLIX+g9xAfp0/FDi7mwu38lUGzsttlfJFS44310k9uZNMkQv
	57qP5b/w==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa88-00000005jff-0NRR;
	Thu, 28 May 2026 12:46:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 06/10] mm/swap: also use struct swap_iocb for block I/O
Date: Thu, 28 May 2026 14:45:22 +0200
Message-ID: <20260528124559.2566481-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528124559.2566481-1-hch@lst.de>
References: <20260528124559.2566481-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 593ukrnzf9owo65ik4y6g8seot8yyx9d
X-Rspamd-Queue-Id: 8A9331C0003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779972400-618021
X-HE-Meta: U2FsdGVkX19VrgRIFtXcUXLONzm0A2aRoWkjBiNSp5zulKxw/rtwqtN1Ju4hlzL5QIVxukeTelaOZr32PKaD2kEtSMbqoz4GKfKo0cfCdFfcLp4VT0QXL9G0VPL43EyfjbfQJFNPs0f+a3Qhsfl1UrE5bDV9KDE7LMhlXMA7RYrqhEPSVDP3F9gHJeQZ/f0/3hzVGhMlThvFSwzhpAgnEzOe2MdpxrIAb6ozHVu5G1Gz42RgUGEA/cPOIb2/wL7lFAIz1T2VisNkBwTB2dD3j9nsICIr7Fu3k366+pNVoyTyZGxcU3UUTIL1ENHPbmZBWN8fU3yGLZ/BUjLwWdun2VQBWSYcxfB/Tnk1aAeQgNB8xjTXfm3RtqRxOtK+nCDoi7Q5nbOsK/Ijw4SCZRvFQmgcjS79mHuDmRv9FMR6PBbc9dwq/Sw5Egf7C2O+hgN6lSFSho/x/1+Hd5wcs4a7QMAlENZ/9P/X8V+GnJt9RzvS2tByA+bo6lUqYaFU0xi3o5BYf1f8pmLEJGAwTFHuU9JBk9oSGLO3KvR6a5yQRn4KrQpj865kaETCotEQvsUuHiacB/dfI6CnRgpKGl58KDzG/Kd1RnFxIxCMqquAI1rhn/+DnDwBb7Dc+eT3sO8h/wUilMq+q9DbrIq8FOu10NSm29rkitTe1ea2njp23oEuXx2JsVDYu24qb+30Qiy07PYiMzw2q+j9URMFo8RZS7s/EsJUREKz30JfdprQmeMwIPKnGuZZkzpseBO5lYVMCCrnxOyAOgetNcpKtMOy3f0mNRUqBmXAE+W/Dmfl6xhV112Q5mvZmgQIedy14Qs5Uj2otryuw5/U9tyEGucK97BHy3h2sogsUcX2ZWg9jRFgic/AQ0CtSy1LAjmOM9Q/ZWPQUL7LSj+X7a4Dnw1TK52Vjifu4/SbExY+5sFA1d8dPV6x0cXdz0pFxWQ1Lvg0Ctw+5JtanbSejim3pV1
 7jKvY+LE
 sSvAjCCCVe1cvf1rpATAQxxsyGrdPni58U8ogoxNvcstzHEf6PAwQ1+/MChkmeuA4lV4tkFjmwII7MFhvceCdKSqNApljYfs27LzvJ+N4MBH5bKYrY5xEAnTuOghktni84p9+G0wgdYZPjvjR9ywWmoF95HDMdGCMWf6fi3cfJKwzzWpYxd+LSDtKEWNONoUVCQdBvLZso0Kgy0nUN84KJMpxfN8H4iN255W2NCWV0EZ51oFVG4NcB08uWuuQbsODsxWw+hmcNlBZAD2FjW+LR047nF5CzUvtOwhjS96R+Ng7wClanNw0Elchwq34phAAkwhcVa4BwCbXhSZ2uRNuoY3RrqE8uwiepCJTtgL/1zSNilEYRb3lkQTqsmXqhxuihJn0CwvetW9OLPXFIRTQ9uGZrmOQsHdqX2lnCqn4sQQgvk+Gf6ag/thHu+nFbaHiLCIJ02GUk1QP4Y5E30JE65zkVS8c/rImgsAR83EGz7OotdeSE30w03Hmd0yjXx5BCdFbjOTpcEveYKr3jw9aZAdrl3fXnOt3WZOckcPelUa6OvK+M1UllVY8LmsBXsx/r5OlWpCXrT0lh1x4kvb+Ip1ay7ZCf6sQ4uYa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Block I/O benefits from batching just as much as remote file systems.
Extent struct swap_iocb to support building a bio on the fly as well,
and rewrite the block based swap code for it.  This especially benefits
submit_bio based drivers that do not have the block plugging available,
but also saves allocating extra bios for blk-mq drivers.

Note that the block based swap code now uses the same memcg-based
check previously added for file system based swap as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c  | 503 ++++++++++++++++++++++----------------------------
 mm/swap.h     |   1 +
 mm/swapfile.c |   9 +-
 3 files changed, 226 insertions(+), 287 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 925263190ce1..deb902398919 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -28,54 +28,6 @@
 #include "swap.h"
 #include "swap_table.h"
 
-static void __end_swap_bio_write(struct bio *bio)
-{
-	struct folio *folio = bio_first_folio_all(bio);
-
-	if (bio->bi_status) {
-		/*
-		 * We failed to write the page out to swap-space.
-		 * Re-dirty the page in order to avoid it being reclaimed.
-		 * Also print a dire warning that things will go BAD (tm)
-		 * very quickly.
-		 *
-		 * Also clear PG_reclaim to avoid folio_rotate_reclaimable()
-		 */
-		folio_mark_dirty(folio);
-		pr_alert_ratelimited("Write-error on swap-device (%u:%u:%llu)\n",
-				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
-				     (unsigned long long)bio->bi_iter.bi_sector);
-		folio_clear_reclaim(folio);
-	}
-	folio_end_writeback(folio);
-}
-
-static void end_swap_bio_write(struct bio *bio)
-{
-	__end_swap_bio_write(bio);
-	bio_put(bio);
-}
-
-static void __end_swap_bio_read(struct bio *bio)
-{
-	struct folio *folio = bio_first_folio_all(bio);
-
-	if (bio->bi_status) {
-		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
-				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
-				     (unsigned long long)bio->bi_iter.bi_sector);
-	} else {
-		folio_mark_uptodate(folio);
-	}
-	folio_unlock(folio);
-}
-
-static void end_swap_bio_read(struct bio *bio)
-{
-	__end_swap_bio_read(bio);
-	bio_put(bio);
-}
-
 int generic_swapfile_activate(struct swap_info_struct *sis,
 				struct file *swap_file,
 				sector_t *span)
@@ -330,7 +282,10 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
 struct swap_iocb {
-	struct kiocb		iocb;
+	union {
+		struct kiocb	iocb;
+		struct bio	bio;
+	};
 	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
 	int			nr_bvecs;
 	int			len;
@@ -350,12 +305,18 @@ int sio_pool_init(void)
 	return 0;
 }
 
-static bool swap_can_merge_memcg(struct swap_iocb *sio, struct folio *folio)
+static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
+		int rw)
 {
-	struct folio *prev_folio =
-		page_folio(sio->bvecs[sio->nr_bvecs - 1].bv_page);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
+	struct folio *prev_folio = page_folio(last_bv->bv_page);
+	size_t prev_folio_size = folio_size(prev_folio);
+
+	if (ctx->sis != sis)
+		return false;
 
-	if (folio_memcg_charged(folio)) {
+	if (rw == WRITE && folio_memcg_charged(folio)) {
 		rcu_read_lock();
 		if (folio_memcg_css(folio) != folio_memcg_css(prev_folio)) {
 			rcu_read_unlock();
@@ -364,175 +325,57 @@ static bool swap_can_merge_memcg(struct swap_iocb *sio, struct folio *folio)
 		rcu_read_unlock();
 	}
 
-	return true;
-}
-
-static void sio_write_complete(struct kiocb *iocb, long ret)
-{
-	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	struct page *page = sio->bvecs[0].bv_page;
-	int p;
-
-	if (ret != sio->len) {
-		/*
-		 * In the case of swap-over-nfs, this can be a
-		 * temporary failure if the system has limited
-		 * memory for allocating transmit buffers.
-		 * Mark the page dirty and avoid
-		 * folio_rotate_reclaimable but rate-limit the
-		 * messages.
-		 */
-		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(page_swap_entry(page)));
-		for (p = 0; p < sio->nr_bvecs; p++) {
-			page = sio->bvecs[p].bv_page;
-			set_page_dirty(page);
-			ClearPageReclaim(page);
-		}
+	if (sis->flags & SWP_FS_OPS) {
+		if (swap_dev_pos(folio->swap) !=
+		    swap_dev_pos(prev_folio->swap) + prev_folio_size)
+			return false;
+	} else {
+		if (swap_folio_sector(folio) !=
+		    swap_folio_sector(prev_folio) +
+		    (prev_folio_size >> SECTOR_SHIFT))
+			return false;
 	}
 
-	for (p = 0; p < sio->nr_bvecs; p++)
-		end_page_writeback(sio->bvecs[p].bv_page);
-
-	mempool_free(sio, sio_pool);
+	return true;
 }
 
-static void swap_writepage_fs(struct swap_io_ctx *ctx, struct folio *folio)
+static void swap_add_page(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 {
-	struct swap_iocb *sio = ctx->sio;
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-	struct file *swap_file = sis->swap_file;
-	loff_t pos = swap_dev_pos(folio->swap);
+	struct swap_iocb *sio = ctx->sio;
 
-	count_swpout_vm_event(folio);
-	folio_start_writeback(folio);
-	folio_unlock(folio);
-	if (sio) {
-		if (sio->iocb.ki_filp != swap_file ||
-		    sio->iocb.ki_pos + sio->len != pos ||
-		    !swap_can_merge_memcg(sio, folio)) {
+	if (sio && !swap_can_merge(ctx, folio, rw)) {
+		if (rw == WRITE)
 			swap_write_submit(ctx);
-			sio = NULL;
-		}
+		else
+			swap_read_submit(ctx);
+		sio = ctx->sio;
 	}
+
 	if (!sio) {
-		sio = mempool_alloc(sio_pool, GFP_NOIO);
-		init_sync_kiocb(&sio->iocb, swap_file);
-		sio->iocb.ki_complete = sio_write_complete;
-		sio->iocb.ki_pos = pos;
+		ctx->sis = sis;
+		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	sio->nr_bvecs += 1;
-	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
-		swap_write_submit(ctx);
-		sio = NULL;
+	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
+		if (rw == WRITE)
+			swap_write_submit(ctx);
+		else
+			swap_read_submit(ctx);
 	}
-	ctx->sio = sio;
 }
 
-static void swap_writepage_bdev_sync(struct folio *folio,
-		struct swap_info_struct *sis)
-{
-	struct bio_vec bv;
-	struct bio bio;
-
-	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_WRITE | REQ_SWAP);
-	bio.bi_iter.bi_sector = swap_folio_sector(folio);
-	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
-
-	bio_associate_blkg_from_page(&bio, folio);
-	count_swpout_vm_event(folio);
-
-	folio_start_writeback(folio);
-	folio_unlock(folio);
-
-	submit_bio_wait(&bio);
-	__end_swap_bio_write(&bio);
-}
-
-static void swap_writepage_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 {
-	struct bio *bio;
-
-	bio = bio_alloc(sis->bdev, 1, REQ_OP_WRITE | REQ_SWAP, GFP_NOIO);
-	bio->bi_iter.bi_sector = swap_folio_sector(folio);
-	bio->bi_end_io = end_swap_bio_write;
-	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	bio_associate_blkg_from_page(bio, folio);
 	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	submit_bio(bio);
-}
-
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
-{
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-
-	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
-	/*
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_FS_OPS, so the data_race
-	 * is safe.
-	 */
-	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(ctx, folio);
-	/*
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
-	 * is safe.
-	 */
-	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
-		swap_writepage_bdev_sync(folio, sis);
-	else
-		swap_writepage_bdev_async(folio, sis);
-}
-
-void swap_write_submit(struct swap_io_ctx *ctx)
-{
-	struct swap_iocb *sio = ctx->sio;
-	struct iov_iter from;
-	int ret;
-
-	if (!sio)
-		return;
-
-	iov_iter_bvec(&from, ITER_SOURCE, sio->bvecs, sio->nr_bvecs, sio->len);
-	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &from);
-	if (ret != -EIOCBQUEUED)
-		sio_write_complete(&sio->iocb, ret);
-	ctx->sio = NULL;
-}
-
-static void sio_read_complete(struct kiocb *iocb, long ret)
-{
-	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	int p;
-
-	if (ret == sio->len) {
-		for (p = 0; p < sio->nr_bvecs; p++) {
-			struct folio *folio = page_folio(sio->bvecs[p].bv_page);
-
-			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
-			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
-			folio_mark_uptodate(folio);
-			folio_unlock(folio);
-		}
-		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
-	} else {
-		for (p = 0; p < sio->nr_bvecs; p++) {
-			struct folio *folio = page_folio(sio->bvecs[p].bv_page);
-
-			folio_unlock(folio);
-		}
-		pr_alert_ratelimited("Read-error on swap-device\n");
-	}
-	mempool_free(sio, sio_pool);
+	swap_add_page(ctx, folio, WRITE);
 }
 
 /*
@@ -598,74 +441,6 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 	return true;
 }
 
-static void swap_read_folio_fs(struct swap_io_ctx *ctx, struct folio *folio)
-{
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-	struct swap_iocb *sio = ctx->sio;
-	loff_t pos = swap_dev_pos(folio->swap);
-
-	if (sio) {
-		if (sio->iocb.ki_filp != sis->swap_file ||
-		    sio->iocb.ki_pos + sio->len != pos) {
-			swap_read_submit(ctx);
-			sio = NULL;
-		}
-	}
-	if (!sio) {
-		sio = mempool_alloc(sio_pool, GFP_KERNEL);
-		init_sync_kiocb(&sio->iocb, sis->swap_file);
-		sio->iocb.ki_pos = pos;
-		sio->iocb.ki_complete = sio_read_complete;
-		sio->nr_bvecs = 0;
-		sio->len = 0;
-	}
-	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
-	sio->len += folio_size(folio);
-	sio->nr_bvecs += 1;
-	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
-		swap_read_submit(ctx);
-		sio = NULL;
-	}
-	ctx->sio = sio;
-}
-
-static void swap_read_folio_bdev_sync(struct folio *folio,
-		struct swap_info_struct *sis)
-{
-	struct bio_vec bv;
-	struct bio bio;
-
-	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_READ);
-	bio.bi_iter.bi_sector = swap_folio_sector(folio);
-	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
-	/*
-	 * Keep this task valid during swap readpage because the oom killer may
-	 * attempt to access it in the page fault retry time check.
-	 */
-	get_task_struct(current);
-	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
-	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
-	count_vm_events(PSWPIN, folio_nr_pages(folio));
-	submit_bio_wait(&bio);
-	__end_swap_bio_read(&bio);
-	put_task_struct(current);
-}
-
-static void swap_read_folio_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
-{
-	struct bio *bio;
-
-	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
-	bio->bi_iter.bi_sector = swap_folio_sector(folio);
-	bio->bi_end_io = end_swap_bio_read;
-	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
-	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
-	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
-	count_vm_events(PSWPIN, folio_nr_pages(folio));
-	submit_bio(bio);
-}
-
 void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
@@ -699,14 +474,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-
-	if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_read_folio_fs(ctx, folio);
-	} else if (synchronous) {
-		swap_read_folio_bdev_sync(folio, sis);
-	} else {
-		swap_read_folio_bdev_async(folio, sis);
-	}
+	swap_add_page(ctx, folio, READ);
 
 finish:
 	if (workingset) {
@@ -716,18 +484,189 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	delayacct_swapin_end();
 }
 
-void swap_read_submit(struct swap_io_ctx *ctx)
+static void swap_write_end(struct swap_iocb *sio, bool failed)
+{
+	int p;
+
+	for (p = 0; p < sio->nr_bvecs; p++) {
+		struct page *page = sio->bvecs[p].bv_page;
+
+		if (failed) {
+			set_page_dirty(page);
+			ClearPageReclaim(page);
+		}
+		end_page_writeback(page);
+	}
+	mempool_free(sio, sio_pool);
+}
+
+static void swap_fs_write_complete(struct kiocb *iocb, long ret)
+{
+	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
+	bool failed = ret != sio->len;
+
+	if (failed) {
+		struct page *page = sio->bvecs[0].bv_page;
+
+		/*
+		 * In the case of swap-over-nfs, this can be a temporary failure
+		 * if the system has limited memory for allocating transmit
+		 * buffers.  Mark the page dirty and avoid
+		 * folio_rotate_reclaimable but rate-limit the messages.
+		 */
+		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
+				   ret, swap_dev_pos(page_swap_entry(page)));
+	}
+
+	swap_write_end(sio, failed);
+}
+
+static void end_swap_bio_write(struct bio *bio)
+{
+	struct swap_iocb *sio = container_of(bio, struct swap_iocb, bio);
+	bool failed = !!bio->bi_status;
+
+	if (failed)
+		pr_alert_ratelimited("Write-error on swap-device (%u:%u:%llu)\n",
+				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
+				     (unsigned long long)bio->bi_iter.bi_sector);
+	bio_uninit(bio);
+	swap_write_end(sio, failed);
+}
+
+static void swap_read_end(struct swap_iocb *sio, bool failed)
+{
+	int p;
+
+	for (p = 0; p < sio->nr_bvecs; p++) {
+		struct folio *folio = page_folio(sio->bvecs[p].bv_page);
+
+		if (!failed) {
+			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
+			count_memcg_folio_events(folio, PSWPIN,
+					folio_nr_pages(folio));
+			folio_mark_uptodate(folio);
+		}
+		folio_unlock(folio);
+	}
+
+	if (!failed)
+		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
+
+	mempool_free(sio, sio_pool);
+}
+
+static void swap_fs_read_complete(struct kiocb *iocb, long ret)
+{
+	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
+	bool failed = ret != sio->len;
+
+	if (failed)
+		pr_alert_ratelimited("Read-error on swap-device\n");
+	swap_read_end(sio, failed);
+}
+
+static void swap_bio_read_end_io(struct bio *bio)
+{
+	struct swap_iocb *sio = container_of(bio, struct swap_iocb, bio);
+	bool failed = !!bio->bi_status;
+
+	if (failed)
+		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
+				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
+				     (unsigned long long)bio->bi_iter.bi_sector);
+	bio_uninit(bio);
+	swap_read_end(sio, failed);
+}
+
+static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 {
 	struct swap_iocb *sio = ctx->sio;
-	struct iov_iter from;
+	struct bio *bio = &sio->bio;
+
+	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
+			REQ_OP_WRITE | REQ_SWAP);
+	bio->bi_iter.bi_size = sio->len;
+	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
+
+	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
+		submit_bio_wait(bio);
+		end_swap_bio_write(bio);
+	} else {
+		bio->bi_end_io = end_swap_bio_write;
+		submit_bio(bio);
+	}
+}
+
+static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct bio *bio = &sio->bio;
+
+	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
+			REQ_OP_READ);
+	bio->bi_iter.bi_size = sio->len;
+	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+
+	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
+		/*
+		 * Keep this task valid during swap readpage because the oom
+		 * killer may attempt to access it in the page fault retry
+		 * time check.
+		 */
+		get_task_struct(current);
+		submit_bio_wait(bio);
+		swap_bio_read_end_io(bio);
+		put_task_struct(current);
+	} else {
+		bio->bi_end_io = swap_bio_read_end_io;
+		submit_bio(bio);
+	}
+}
+
+static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct iov_iter iter;
 	int ret;
 
-	if (!sio)
-		return;
+	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
+	sio->iocb.ki_pos = swap_dev_pos(page_folio(sio->bvecs[0].bv_page)->swap);
+	if (rw == WRITE)
+		sio->iocb.ki_complete = swap_fs_write_complete;
+	else
+		sio->iocb.ki_complete = swap_fs_read_complete;
 
-	iov_iter_bvec(&from, ITER_DEST, sio->bvecs, sio->nr_bvecs, sio->len);
-	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &from);
+	iov_iter_bvec(&iter, rw == WRITE ? ITER_SOURCE : ITER_DEST,
+			sio->bvecs, sio->nr_bvecs, sio->len);
+	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &iter);
 	if (ret != -EIOCBQUEUED)
-		sio_read_complete(&sio->iocb, ret);
+		sio->iocb.ki_complete(&sio->iocb, ret);
+}
+
+void swap_write_submit(struct swap_io_ctx *ctx)
+{
+	if (!ctx->sio)
+		return;
+
+	if (ctx->sis->flags & SWP_FS_OPS)
+		swap_fs_submit(ctx, WRITE);
+	else
+		swap_bdev_submit_write(ctx);
+	ctx->sio = NULL;
+	ctx->sis = NULL;
+}
+
+void swap_read_submit(struct swap_io_ctx *ctx)
+{
+	if (!ctx->sio)
+		return;
+
+	if (ctx->sis->flags & SWP_FS_OPS)
+		swap_fs_submit(ctx, READ);
+	else
+		swap_bdev_submit_read(ctx);
 	ctx->sio = NULL;
+	ctx->sis = NULL;
 }
diff --git a/mm/swap.h b/mm/swap.h
index a20694268cb7..63d2dc41b213 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -81,6 +81,7 @@ enum swap_cluster_flags {
 
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
+	struct swap_info_struct	*sis;
 };
 
 #ifdef CONFIG_SWAP
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 615d90867111..2372f7cc4653 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2842,6 +2842,10 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	struct inode *inode = mapping->host;
 	int ret;
 
+	ret = sio_pool_init();
+	if (ret)
+		return ret;
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2853,11 +2857,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 		if (ret < 0)
 			return ret;
 		sis->flags |= SWP_ACTIVATED;
-		if ((sis->flags & SWP_FS_OPS) &&
-		    sio_pool_init() != 0) {
-			destroy_swap_extents(sis, swap_file);
-			return -ENOMEM;
-		}
 		return ret;
 	}
 
-- 
2.53.0


