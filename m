Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD29CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E4F6B008C; Fri, 15 May 2026 08:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956616B0092; Fri, 15 May 2026 08:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EFF66B0095; Fri, 15 May 2026 08:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6905D6B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:00:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CF071C07B4
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:51 +0000 (UTC)
X-FDA: 84769512702.30.8071477
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 344721C0012
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tI2fsu95;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf21.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778846449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N18lekaUABbrZ2I3sFbP1U6HpIC6yHYM16wBqrGFsTU=;
	b=d3G8EaowUS6PAdckyteprnhBsRW8peB/YqzZ41rGZNf1INyNY9PmKUWiLdG8WT4SMA4b2s
	zXV8Bk28urDDSQQ81/I7NM8P7Qb+k9kqS9d3H3XtlHpno6hM24kjXnmkavznFAOOEhKqOv
	W4PPU+twzpCYlKrrhyUA61xUcFNOEMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778846449; a=rsa-sha256;
	cv=none;
	b=Fvh+AOAk6aPPXMoiH9qw2ZYTJy6qIN9dBDgqXhmn4QovuR+3N57oFVGo3YgaliwPYNYBbk
	eSClKu23/kU/bqnEEfReO7rzvsvP3T3B1HUM78l/pyY7MToRIUHs1LTJqG+S5XONeZw3xp
	3SlY9J7+HkizY8GBijOJXIJL0ge2+mc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tI2fsu95;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf21.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=N18lekaUABbrZ2I3sFbP1U6HpIC6yHYM16wBqrGFsTU=; b=tI2fsu95d6+a43nBUA3cLfGh+7
	evI4CXYubDxWNxgiDWowQywjcq10wUNzPZ6F94lQCC7CZs7UNVF3/F6R0glNaGGC1KpaEpR8kvlSV
	Z+f91cRfZOyo2K+GX/NOpsM+BapLSbu7aRdpqs3xQ2+95SfaDjpOAyViT3nYmHA5ANRpptyr4dhPW
	Y+Uu70FJ/+lFiZxY2PsgCZhRRwy40dbzPFoamCUX0q3p6DoEuREz2K6MfmrBpaaUhLezxSgMNHl6p
	+1uXQlsiWpGiefvbzX8zwz5mLz0KR5SFRorV1qm30YMRZRqcUoDvsdmgYaNP4rEE8Yc6nCCaB6V97
	3rfLlQwQ==;
Received: from [2001:4bb8:2d2:300a:b132:4044:9ee9:7f18] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNrDg-00000008GZB-3oHT;
	Fri, 15 May 2026 12:00:45 +0000
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
Subject: [PATCH 4/6] mm/swap: also use struct swap_iocb for block I/O
Date: Fri, 15 May 2026 14:00:09 +0200
Message-ID: <20260515120019.4015143-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515120019.4015143-1-hch@lst.de>
References: <20260515120019.4015143-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 344721C0012
X-Stat-Signature: tz7w5nxfh5e9a8obhdwktuir11mghh7m
X-Rspam-User: 
X-HE-Tag: 1778846448-365752
X-HE-Meta: U2FsdGVkX1/E5zKdwvexaTG+fThLVXlMYBo/9HkrlBjZ+KBrrXReZcsPdbeTmoAdiRZ4558uB5WCCRfIkLcnoON+HiEm6Bfl9WSi7PvB+wveDDcQdwzbKwOCGU4GqE6Mph8SEmeEHWTKBAZseXmJCHs/MZZL0MKLE9Z1dXq/8e0tyJ8ph0K37+zIIz5/qIwDe0Tgsoc4epfvaz9Wmt35TCGX8kfFvN0qJW3vqX641Wxhb1KuZOMmUDIl03pWefS5I4Mqf9pAu7wyRHM7zVMiW5iHIIhJeQOeMOUF/YrIuHCD1ySPmZKs89vt0U7PeRvQBAKrCCXIYJYvIErBzxOv4u4o/3UcEvgmrzAL6dBsQmnjY2LTKOSp72At+iHUBq2lc2zk0RQra8nG+o0kUePbBXlFGhI+DbROeervrAKHX5OlUDojl+rlCHL6z8mdIrT8GwHRf7kOEYhetsMCOLbLfax+nDBIvYRIGnCkopVkWFV6bUe/xcLIPa/tHAeRV79j9PHijNBn1PtQ9iIsBHF/FreVaHIivZCtIarXceSM/MUGCsNDAas8IRfPfQrZeU6xV40tLKtGPrAvgHwFCHrlNzw/A+njVLXA3HgzEpd7BStHxr2HNRzetYJ3/l+MtexMHX6ddITwND9aE7zMXZbsipRcWMWG8DvnArDZkt7rvAzIsTm9tNMeygOttIJBX/zxgFUjbL1o74HzcskF0dQToRvolmy2OFuG7RNcN4thSphG4ZkFqc4idPZSH7O143Cx6uUZavzTA7AQstpQw7Gf1Xpi2jDqC8Vd0FqGux/SX8tU80m+MXAGOf2njlWBSkM7JQ9tUCoeKlc7dfBe+SVAOpRr2BcjJ+gvqueMSbAO6YlYpDZFMATI+qXFJGiYPlGDbPzTx0W/qphL8ECCeZ8i/Moo0TM5aGph8ecEKw5Ekx0haxe2aXDupjo7AgBpA69HSI6o6L7q53Dd3DVdNg7
 Yi0lkURJ
 qsdS62XB4+yb9ldxhf9qWscq0Rh2NamIESDl9LcY4sdDtSm2gJcJMxAQvwN2sj+NXH/85/wZdiXcUx6eHurJ7AQ/83vCt9yQN5fzxpwTwV3C5YRIulTvXWrDngqna4u3E6x7AYCaILgilszMMltlxr9rqt/DM4lj/V0BKYSflBWzjFEJdledRdrjahi6f4B+2F5tYpyJGomGb2DhUanCx8qNvUigABl19JgxNw+v1U5VUMwA5opFKtQbRXtJthHrrBbqjrah5vMT11JOX/KFN/v5Frlnga7nha5xMOS0Oixa4TnBKn2nZykvzhUWwUqVTBiMmDNUiNJLlXdzMPu4WGvE9zmNb/uonGigHORIr3tatfp9cDamy/PdnK4tvBnY3cz+OZgNItv81Xtf44MynU5DD5Ii59wcft6VyDc+J0UPCTBJQkkPqhKcsThzlLfQvu6lgHJYs4Ijk98Pkb/iw8YptX3p6enMZV95On7ybjznIHNd79RGl4FPJKoN3LFJziWHfe/6x2DGH0Ayw/G4l4LMd5cT06Edsq5CVkXZQZ1SOprUUaKk0Vx5pHy+duGhaWF1y5uOND5YK2om6V2W/tKQwId0qbDqymznW
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c  | 506 +++++++++++++++++++++++---------------------------
 mm/swap.h     |   1 +
 mm/swapfile.c |   9 +-
 3 files changed, 235 insertions(+), 281 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index a78efc9909c8..bbd8cf47d20d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -27,54 +27,6 @@
 #include <linux/zswap.h>
 #include "swap.h"
 
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
@@ -325,9 +277,12 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
 struct swap_iocb {
-	struct kiocb		iocb;
+	union {
+		struct kiocb	iocb;
+		struct bio	bio;
+	};
 	struct bio_vec		bvec[SWAP_CLUSTER_MAX];
-	int			pages;
+	int			nr_vecs;
 	int			len;
 };
 static mempool_t *sio_pool;
@@ -345,172 +300,68 @@ int sio_pool_init(void)
 	return 0;
 }
 
-static void sio_write_complete(struct kiocb *iocb, long ret)
+static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio)
 {
-	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	struct page *page = sio->bvec[0].bv_page;
-	int p;
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct bio_vec *last_bv = &ctx->sio->bvec[ctx->sio->nr_vecs - 1];
+	struct folio *prev_folio = page_folio(last_bv->bv_page);
+	size_t prev_folio_size = folio_size(prev_folio);
 
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
-		for (p = 0; p < sio->pages; p++) {
-			page = sio->bvec[p].bv_page;
-			set_page_dirty(page);
-			ClearPageReclaim(page);
-		}
-	}
+	if (ctx->sis != sis)
+		return false;
 
-	for (p = 0; p < sio->pages; p++)
-		end_page_writeback(sio->bvec[p].bv_page);
+	if (sis->flags & SWP_FS_OPS) {
+		if (swap_dev_pos(folio->swap) !=
+		    swap_dev_pos(prev_folio->swap) + prev_folio_size)
+			return false;
+	} else {
+		if (swap_folio_sector(folio) !=
+		    swap_folio_sector(prev_folio) +
+		    (prev_folio_size >> SECTOR_SHIFT))
+			return false;
+	}
 
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
-		    sio->iocb.ki_pos + sio->len != pos) {
+	if (sio && !swap_can_merge(ctx, folio)) {
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
-		sio->pages = 0;
+		ctx->sis = sis;
+		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
+		sio->nr_vecs = 0;
 		sio->len = 0;
 	}
-	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
+	bvec_set_folio(&sio->bvec[sio->nr_vecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec)) {
-		swap_write_submit(ctx);
-		sio = NULL;
+	sio->nr_vecs += 1;
+	if (sio->nr_vecs == ARRAY_SIZE(sio->bvec)) {
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
-	struct iov_iter from;
-	struct swap_iocb *sio = ctx->sio;
-	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
-	int ret;
-
-	if (!ctx)
-		return;
-
-	iov_iter_bvec(&from, ITER_SOURCE, sio->bvec, sio->pages, sio->len);
-	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
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
-		for (p = 0; p < sio->pages; p++) {
-			struct folio *folio = page_folio(sio->bvec[p].bv_page);
-
-			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
-			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
-			folio_mark_uptodate(folio);
-			folio_unlock(folio);
-		}
-		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
-	} else {
-		for (p = 0; p < sio->pages; p++) {
-			struct folio *folio = page_folio(sio->bvec[p].bv_page);
-
-			folio_unlock(folio);
-		}
-		pr_alert_ratelimited("Read-error on swap-device\n");
-	}
-	mempool_free(sio, sio_pool);
+	swap_add_page(ctx, folio, WRITE);
 }
 
 static bool swap_read_folio_zeromap(struct folio *folio)
@@ -543,74 +394,6 @@ static bool swap_read_folio_zeromap(struct folio *folio)
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
-		sio->pages = 0;
-		sio->len = 0;
-	}
-	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
-	sio->len += folio_size(folio);
-	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec)) {
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
@@ -644,14 +427,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
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
@@ -661,19 +437,197 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	delayacct_swapin_end();
 }
 
-void swap_read_submit(struct swap_io_ctx *ctx)
+static void sio_write_end(struct swap_iocb *sio, bool failed)
+{
+	int p;
+
+	for (p = 0; p < sio->nr_vecs; p++) {
+		struct page *page = sio->bvec[p].bv_page;
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
+static void sio_write_complete(struct kiocb *iocb, long ret)
+{
+	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
+	bool failed = ret != sio->len;
+
+	if (failed) {
+		struct page *page = sio->bvec[0].bv_page;
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
+	sio_write_end(sio, failed);
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
+	sio_write_end(sio, failed);
+}
+
+static void sio_read_end(struct swap_iocb *sio)
+{
+	int p;
+
+	for (p = 0; p < sio->nr_vecs; p++) {
+		struct folio *folio = page_folio(sio->bvec[p].bv_page);
+
+		count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
+		count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
+		folio_mark_uptodate(folio);
+		folio_unlock(folio);
+	}
+	count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
+	mempool_free(sio, sio_pool);
+}
+
+static void sio_read_fail(struct swap_iocb *sio)
+{
+	int p;
+
+	for (p = 0; p < sio->nr_vecs; p++)
+		folio_unlock(page_folio(sio->bvec[p].bv_page));
+	mempool_free(sio, sio_pool);
+}
+
+static void sio_read_complete(struct kiocb *iocb, long ret)
+{
+	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
+
+	if (ret != sio->len) {
+		pr_alert_ratelimited("Read-error on swap-device\n");
+		sio_read_fail(sio);
+		return;
+	}
+
+	sio_read_end(sio);
+}
+
+static void end_swap_bio_read(struct bio *bio)
+{
+	struct swap_iocb *sio = container_of(bio, struct swap_iocb, bio);
+
+	if (bio->bi_status) {
+		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
+				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
+				     (unsigned long long)bio->bi_iter.bi_sector);
+		sio_read_fail(sio);
+		return;
+	}
+
+	sio_read_end(sio);
+}
+
+static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct bio *bio = &sio->bio;
+
+	bio_init(bio, ctx->sis->bdev, sio->bvec, ARRAY_SIZE(sio->bvec),
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
+	bio_init(bio, ctx->sis->bdev, sio->bvec, ARRAY_SIZE(sio->bvec),
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
+		end_swap_bio_read(bio);
+		put_task_struct(current);
+	} else {
+		bio->bi_end_io = end_swap_bio_read;
+		submit_bio(bio);
+	}
+}
+
+static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
 {
-	struct iov_iter from;
 	struct swap_iocb *sio = ctx->sio;
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
+	struct iov_iter iter;
 	int ret;
 
-	if (!sio)
-		return;
+	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
+	sio->iocb.ki_pos = swap_dev_pos(page_folio(sio->bvec[0].bv_page)->swap);
+	if (rw == WRITE)
+		sio->iocb.ki_complete = sio_write_complete;
+	else
+		sio->iocb.ki_complete = sio_read_complete;
 
-	iov_iter_bvec(&from, ITER_DEST, sio->bvec, sio->pages, sio->len);
-	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
+	iov_iter_bvec(&iter, rw == WRITE ? ITER_SOURCE : ITER_DEST,
+			sio->bvec, sio->nr_vecs, sio->len);
+	ret = mapping->a_ops->swap_rw(&sio->iocb, &iter);
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
index 3ec35b6d629f..b359735be3c5 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -55,6 +55,7 @@ enum swap_cluster_flags {
 
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
+	struct swap_info_struct	*sis;
 };
 
 #ifdef CONFIG_SWAP
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9174f1eeffb0..27dbce0d1e1e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2781,6 +2781,10 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	struct inode *inode = mapping->host;
 	int ret;
 
+	ret = sio_pool_init();
+	if (ret)
+		return ret;
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2792,11 +2796,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
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


