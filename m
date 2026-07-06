Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A50B2C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D42A6B00BF; Mon,  6 Jul 2026 09:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884A86B00C1; Mon,  6 Jul 2026 09:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B986B00C2; Mon,  6 Jul 2026 09:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 493826B00BF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:22:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1D4C1A01CC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:22:52 +0000 (UTC)
X-FDA: 84958416984.17.63DAF7A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id CF21CC000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:22:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=doqCK+Mt;
	spf=none (imf28.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783344170;
	b=hTrXxTQEy8NYpMrhSuCUHaYakgln6VrWaLaGSl30g4eav8D+Oqg5XlKPe1kr27CSQW8tRP
	0xHY0CLryX+s34wDVoBLEUTYWOTCoB3bx/ElXOl1fmui7GIvEuxrKMU/lXwjSuh4JR6pKl
	UlbvVCQ72SrwTsf6gYbZS/gdnGTT1LM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=doqCK+Mt;
	spf=none (imf28.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783344170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YlNIl3qXu8ZCiV2XgzqKVV0MDhavbhDwA9LpYmRmVvo=;
	b=pydKmF9JTP4k84v/NkyQ2k76Et7AN4gwg/jgJlGX5/dV9cq7uAa4/aZ0WQqS5veQzvMKc5
	gH1Fsgap4iy2zwjjCKIBDGEH0+vJsbCoUVI52e/fwIOIAtu6N0gzxLVethh80HyESI7SZp
	10sbQrMp08RW91dXW5ljcsFxpmGsDAw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YlNIl3qXu8ZCiV2XgzqKVV0MDhavbhDwA9LpYmRmVvo=; b=doqCK+MtjnWOs29OGHYJLvFwmI
	1H0ng6mOx9vcx0Zxn41a/GRINbMXWwP1VW+K52FAqX+wqqcNmQxcEEjDOVSnSvdQrnkPJwGd3Fi17
	RFRnDu4vhyYcOkq/KJ86ubTUUDLjm2gggTLQFLlUJjtzgNR21Vrk6zCoN6L8zZeUbqC23K+xTJX9d
	t87QavNzZxpAkn0T+ny9Z0oXjRkS1vInZpDLYQ+v8q/QvkoXh5iXI1vQ9J9wJ2+IX/EUMLzVdwnSF
	PmEPydMgX2bxMBWbkUdKyVz7B7BTCw/udbCQluMBQuLeu4BETdvUqKHMk9yRJK/BKL7qqZmWYp2X+
	X6f1pGFQ==;
Received: from [89.144.223.34] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgjHV-0000000CaaM-34Wj;
	Mon, 06 Jul 2026 13:22:44 +0000
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
Subject: [PATCH 3/7] mm/swap: also use struct swap_iocb for block I/O
Date: Mon,  6 Jul 2026 15:21:55 +0200
Message-ID: <20260706132206.935272-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706132206.935272-1-hch@lst.de>
References: <20260706132206.935272-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF21CC000C
X-Stat-Signature: pgie1js35bcp3wtzo645ocsmsnc5twnt
X-HE-Tag: 1783344170-225997
X-HE-Meta: U2FsdGVkX195Z6Y132QV4/2O8X1iukXMQshqJ+vL+uozvdgTiHLJOBkh5SQl1MwHqT+EKJhUQztBxe//XiKAvUQ9NvuyKvh2VDGyspayGLm9JuQcgLZAdpD0BpQTx4ADGWNTK4QM7pwFBqae5/mYnB49oPkcnxeMtZPTZIznM66EMTAb/Vq9bLFgOuKD8+Uy2o+X1w/aeOi1otUGdsvhWjTi50PILd2rZAhvVA3EVCL8lHJSEXZ79CwCrBJuvCN1hgrhlQoxaQI+V6CTNfUa3XWfy2rOBDO4lYtR1aJooOX3MeyIciNoSO/rTmN2KwcjfalPAPQS8JwrwiWTWD+8HTiYfDpZihVeNMGhnOxHMHagCeUS4oHYUrfrp7mWGHVzVgyCj5QReNFZMzQPjrOO1L0Gk1JS8bLlgrrSu8kxqcVvhSsDOWqQJDN2RQ2eEWzBfcMxuNXjEIEy4U15BmOEGIYYJeMqVp2XPTpQQzpWxNpdC1HpyqCWQmHys2LZyKCPzvEnaDSnOVd7Mik7/wn5ROqDYBkndk5tKWG+foIKb1PQ6pfWe43WyQfIkMKecX/VbEwJbQcbJtP+M6+kuhzpnkRvYOYVn49dt1gxqWaFRjaqlwbrjPm5YiYuTJuTpancPjlfwN5EVTZJmncd8P1ehls9ibHY0xl3zItO/jNhiFTv/eFAbU4f8WpdlDkmYdNMGiyuF/b2xnJBX/hxg5s/KDYBj2u9uxI6SLxqD0Y5zsfTSq/71bmzC9SSDjKUg8koqkEBW+SuzRwvEOq35nFrC0DEoocGkKtlwOUgS6pRqqpkuET86avNTg9yx5jyUC9bfo9wYIxYzacv+bG1KtYfTg7EIInisSpJ24J0IGO3mjVyy6ds6CzldpaLD6pcsPudoJnoI6XURM80tCBXzQLewaLM7zX++xiied2Y3sqUXuFde4w9PkrqIxFUb5FUn+a79d2GthsIbQo17e6OjAj
 Njwj1b2S
 SLttaoV0X7aBePtZOvhaNsUj+7xCFhBrBuhTn72hsk030g4ypgYap2lX2+ktUZ1w12PDJ5GqmJ5DS/J1t2FKH/WCeTwUwE3yBTuIOe9n2la67ivYuoO5aoTsiALWCUFqh+2s6TAz0h6X5iZaENhGX6hqb0dWrIm3yJYB/fSgynlIm8vjK9bipE3uqBGr4DugoxHrt7Zoz+zis2rLy8HUHc4Zm0r/FnHrHC5NDD+i43tWF03azPl4ypRc3m8DVm0+SdMwmIl/JAw61VFm27QndVoP1mBnvsaJpoYRBjbCI/oPoXvSv09P5zdU/EIyzWCY56tvibjyNl3+LvLrwW9LmmXtiLXQAfy6L45r5a3J0DY3qu32LrRt7lAQ+9RaPZHplx6z9in3O0U+iMWjQKQsejFf1NgwK2xwE/CdqlOFgRtoruTRUDIciqWnTZaPaCm79aTRkpqCol4jsYrj95GLAool6b/ca6Ipkxae4RtRvC8LjVyG6FieTyCE8kT8NEBxm1+xRY9GgoCoe1+sDOPWY6FaqI4lhmDx6YFrw15GYRLpcjQjyVKC2Vs2V015Pc58TdpSAPyhWJWoL6KRke0r4WQxm81lYwX/cQXIDkF0rcxBPQNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Block I/O benefits from batching just as much as remote file systems.
Extend struct swap_iocb to support building a bio on the fly as well,
and rewrite the block based swap code for it.  This especially benefits
submit_bio based drivers that do not have the block plugging available,
but also saves allocating extra bios for blk-mq drivers.

Add a pre-allocated bio to struct swap_iocb in a union with kiocb
used for file system based swap so that struct swap_iocb can be used
for all swap I/O, and initialize the pool for it unconditionally.

Various low-level bdev and fs functions are now replaced with a unified
can_merge/add/submit scheme.

Note that the block based swap code now uses the same memcg-based
check previously added for file system based swap as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c  | 525 ++++++++++++++++++++++++--------------------------
 mm/swap.h     |   1 +
 mm/swapfile.c |   9 +-
 3 files changed, 253 insertions(+), 282 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index fe24a49e034c..f49e667c2b3a 100644
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
@@ -316,18 +268,35 @@ static inline void count_swpout_vm_event(struct folio *folio)
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
+static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
+{
+	return cgroup_e_css(folio_memcg(folio)->css.cgroup, &io_cgrp_subsys);
+}
+
+static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+{
+	if (!folio_memcg_charged(folio) || !folio_memcg_charged(prev_folio))
+		return true;
+
+	rcu_read_lock();
+	if (folio_memcg_blkg_css(folio) != folio_memcg_blkg_css(prev_folio)) {
+		rcu_read_unlock();
+		return false;
+	}
+	rcu_read_unlock();
+
+	return true;
+}
+
 static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
-	struct mem_cgroup *memcg;
 
 	if (!folio_memcg_charged(folio))
 		return;
-
 	rcu_read_lock();
-	memcg = folio_memcg(folio);
-	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
-	if (!css || !css_tryget(css))
+	css = folio_memcg_blkg_css(folio);
+	if (css && !css_tryget(css))
 		css = NULL;
 	rcu_read_unlock();
 
@@ -336,11 +305,18 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 		css_put(css);
 }
 #else
+static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+{
+	return true;
+}
 #define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
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
@@ -360,171 +336,70 @@ int sio_pool_init(void)
 	return 0;
 }
 
-static void sio_write_complete(struct kiocb *iocb, long ret)
+static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
+		int rw)
 {
-	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	struct page *page = sio->bvecs[0].bv_page;
-	int p;
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
+	struct folio *prev_folio = bvec_folio(last_bv);
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
-		for (p = 0; p < sio->nr_bvecs; p++) {
-			page = sio->bvecs[p].bv_page;
-			set_page_dirty(page);
-			ClearPageReclaim(page);
-		}
-	}
+	if (ctx->sis != sis)
+		return false;
 
-	for (p = 0; p < sio->nr_bvecs; p++)
-		end_page_writeback(sio->bvecs[p].bv_page);
+	if (sis->flags & SWP_FS_OPS) {
+		if (swap_dev_pos(folio->swap) !=
+		    swap_dev_pos(prev_folio->swap) + prev_folio_size)
+			return false;
+	} else {
+		if (swap_folio_sector(folio) !=
+		    swap_folio_sector(prev_folio) +
+		    (prev_folio_size >> SECTOR_SHIFT))
+			return false;
+		if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
+			return false;
+	}
 
-	mempool_free(sio, sio_pool);
+	return true;
 }
 
-static void swap_writepage_fs(struct swap_io_ctx *ctx, struct folio *folio)
+static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
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
-}
-
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
 }
 
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
-			struct folio *folio = bvec_folio(&sio->bvecs[p]);
-
-			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
-			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
-			folio_mark_uptodate(folio);
-			folio_unlock(folio);
-		}
-		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
-	} else {
-		for (p = 0; p < sio->nr_bvecs; p++) {
-			struct folio *folio = bvec_folio(&sio->bvecs[p]);
-
-			folio_unlock(folio);
-		}
-		pr_alert_ratelimited("Read-error on swap-device\n");
-	}
-	mempool_free(sio, sio_pool);
+	swap_add_folio(ctx, folio, WRITE);
 }
 
 /*
@@ -590,74 +465,6 @@ static bool swap_read_folio_zeromap(struct folio *folio)
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
@@ -691,14 +498,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
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
+	swap_add_folio(ctx, folio, READ);
 
 finish:
 	if (workingset) {
@@ -708,18 +508,189 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
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
+		struct folio *folio = bvec_folio(&sio->bvecs[p]);
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
+	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
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
index 79d66272dfd4..b6ba80c2afb0 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -81,6 +81,7 @@ enum swap_cluster_flags {
 
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
+	struct swap_info_struct	*sis;
 };
 
 #ifdef CONFIG_SWAP
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 78b49b0658ad..1887df22bd1e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2941,6 +2941,10 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	struct inode *inode = mapping->host;
 	int ret;
 
+	ret = sio_pool_init();
+	if (ret)
+		return ret;
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2952,11 +2956,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
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


