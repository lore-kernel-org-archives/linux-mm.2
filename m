Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 455F1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37C116B0093; Mon, 13 Jul 2026 05:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CEA6B0095; Mon, 13 Jul 2026 05:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3DA6B0096; Mon, 13 Jul 2026 05:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC5706B0093
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:34:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E42A1C9761
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:19 +0000 (UTC)
X-FDA: 84983242638.16.394ED14
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7C98720006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XQ0x1eku;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf31.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MImVgFskvxrnjd+qfpE7tU6ntisjFvSpJv3/FdvbgeY=;
	b=fptrBmcilJKgpOADqa+3B0eL6gTUGRRNBf3eof5QDhntUtQUZuTa/h6YwxWgqBjV37vhnW
	3F1Buw+mntREKX1+ebMtCUKBA7Kmh7DMhSx7Le7rrkZI3nKbtFcgwE7n/yDhZ/nQd0p6fb
	w5gM6nKa6/Yybj14L8gW5K9sfOkp9r0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XQ0x1eku;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf31.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935257;
	b=aOXIhKmr5yFkCGqwdJgXeNtFZyA3NVKh4P+FCkewfFFTcL5DbAJ8IDOAwqaYMg53+usM9z
	OVqr3IerHT/ZiCgU6dtyo1v2CRg6qwGrI8NDeqvWf9SgQwZZCDilJee4YGVszHglc7sTqB
	OZ4j1kyHjmmRAm/JxRq9fseawGs9VrE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MImVgFskvxrnjd+qfpE7tU6ntisjFvSpJv3/FdvbgeY=; b=XQ0x1ekuDdbDIjjN9vidp98hbK
	64UwfKXX7q3/2quEUhJ1HDsGOqvHja1OBhTOnz/vYUse2BTy6N5vUDDBS63+tN2dORc3H3p+tXaVD
	rjovjNfxHZeXZPA0p31rG+ANIYU/zvUBhw+mEuTJoeYSg3HTK5XE5MwOae+D7+ggCL1FrQkHSbnRJ
	VECwIpcAi08W4bz5++5zb6isDFJIvJc5XrlxDFX+uewLSx3QFyXiTMChttZ1OpfR1YJNs8Wd9yFBt
	FG0yFprAwkdK3I9d+v4sr/sl2unTmhpeBESg0qEr54NCU41IreZIrRfWikbMD93MyO5yf/qmQuUrS
	B+fdr2mg==;
Received: from [2001:4bb8:2c2:7dc3:4a7a:b4de:3d88:bc44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjD3D-00000008kgd-0Urw;
	Mon, 13 Jul 2026 09:34:11 +0000
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
Subject: [PATCH 2/7] mm/swap: introduce struct swap_io_ctx
Date: Mon, 13 Jul 2026 11:33:39 +0200
Message-ID: <20260713093350.2154226-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260713093350.2154226-1-hch@lst.de>
References: <20260713093350.2154226-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7C98720006
X-Stat-Signature: 8ydg6td1rq4dyagf3um8b34u8kmct7w3
X-HE-Tag: 1783935257-583660
X-HE-Meta: U2FsdGVkX1/KpXgH18wfvy8ur6+iqglm+CFF4wVoaSZ1d0n3kAWz0gAnmIxiVaUFFwKy8QcRARxJhVKwzPPDSfC1h//JtGZvd6r0p5deCCf9rLXEiHvfY+ffnoQhDmbY017NwgxZb2LeHwlHJah/MGUzTOn3Uga/VWk3jLuegWtSJ3h6VxnWwSjAcj7yFEuF1vDvm8+mI9jVckTa4t5nLuMr9AnH6H5yghvYjAcxDP4ZFODGhhAl1BoAda0wOJ5tjwNrvI1VD7sEs5ZMEZUKg1HLNAVlY2RhhWUsOCwteglecCosAhKA/Uw5LsvIBd0VU1oL0UL5ggOREzPb5OzLuWEkfWealBagfgBjqtgNh3sl23FZ+Xa3oN4cv6HLzE+MxvRndODicHi5WUOFdk+b1u9v6rLkfyXv30aB7hBJv7dCOcA7iqz98K3X4VXhbahFRUkttlTyafTVMdYeCIuDb7yFr1s8XxdXHYHdUZhJ5POsXWuOaOz+11nm7tYc8Ce/s61zH3V/6ZpnrGqEsywoT9W3GediWJCSSJCNs5SHZ0A6Ncu+xRLCdTGfShY2SnXngndXbkm44Gs4FdPvxmckB2XF/xa2bMAeINb4peyqCnQ358YlZSIQDuQ4XEXfS0gsouPuK/x5L2NaXjBFk1UwiO5eIfq07+xL+Dph/d1zwENnMFncxqJV89L/N6/SOErnc8ys4PId4kCT+3T7dIKNfONmNuHPyzSwRsOX9D6WKUt8i9P6lHb+s1LATHf4b7fhrpR5lieUsOhuEGUN25x60qQGADenQgliNHgp/Y8gmXxoznF7womu+ti+Yoit3wBLY+WkvacrUqpuB2IcTjCy4vMQpOmTXuPTkk8sD2lwj39oQZwMF95VBbkRXSb2udKh6xsowCVSdQY9cmzP+IXnFd1mfgakL1lXtnUYDETIZXlHnH0u402XCzWa8GnzoVWtOc8Tpu2XK5NbhoihrHh
 2x1YnDY1
 gFL2o9abzXK5tZqU7bH1oCGX8ukSb5wTEG8iZqUb+WnhDdKTA1ZnBAhcvbrg/uXcvc3h+BqN/7jP7RL2BBX9Lr3HzQDKA+ao5k39xXg6d0KcYzk823zZmk9x2yLuF3LXAZyYRseHfbktUtvYs3uqpBQZJB5mmm36GtSOeCHTe6r3HyieZUePLsLBLDm4sZ4NqqHftxHWUI4xgidCTQ+PjEF4IbxLGTKxJHMvxKLZd+wH/WhtB4jGZ5xShWMu/p7aSo2WM3ID+IaVIH0rDpbVpRK8sSxsZK7+26SYU7+mXUUO28nGSJOxZu/AWKaEYuceN3BzIV3WGYRAhJAyngjfbB+hb77lLxaEJM1QaekRVULC+yVOc0s6WHmWgd7pyPv3DkL6ZAVGrs2RaJEZCUEFIqPGyDKqT4MY6xin2e8Ut9EC1IvCqGHotwv0M8E/f5Dnm1x4ZLj03Y+JLjw2DF1cSruQq14Ssup2xX/yBvzM+kOQxCU/5dR0fbNDdokdA2zM/r1oefUOMgzJNaS9FXwCr9kWVSiRM4pa6sUUP2a1XsRFtFBAuHiPGCBonk/9Fl+7APdHJLyYseQi0AEP4LFovnq/+1DLV/W/UVcTD25piMpuGNp8F0VJWUH+ktyqHoxAjilQXQm4XAbLWip3gTgff6qfIhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generalize the context currently provided by double pointers to struct
swap_iocb to an on-stack context.  This cleans up the code and prepares
for adding more fields and supporting batching multiple folios into a
single bio for block-based swap as well.

This new swap_io_ctx is required for all functions using it, the old
way of allowing a NULL iocb for some callers is removed to keep the
interface consistent.  To reduce code duplication caused by this, a
new swap_cache_read_folio_sync helper is added to consolidate the
code to call swap_cache_read_folio with a local swap_io_ctx.

The unpug helpers are renamed to use the submit wording as they
are generalized.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/madvise.c    | 16 ++++++-------
 mm/page_io.c    | 60 ++++++++++++++++++++++++++-----------------------
 mm/shmem.c      | 13 +++++++----
 mm/swap.h       | 36 +++++++++++++----------------
 mm/swap_state.c | 53 +++++++++++++++++++++++++------------------
 mm/vmscan.c     | 15 ++++++-------
 mm/zswap.c      |  4 +++-
 7 files changed, 106 insertions(+), 91 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 9292f60b19aa..18abb9f29063 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -188,7 +188,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 		unsigned long end, struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->private;
-	struct swap_iocb *splug = NULL;
+	struct swap_io_ctx ctx = {};
 	pte_t *ptep = NULL;
 	spinlock_t *ptl;
 	unsigned long addr;
@@ -212,15 +212,15 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 		pte_unmap_unlock(ptep, ptl);
 		ptep = NULL;
 
-		folio = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
-					     vma, addr, &splug);
+		folio = read_swap_cache_async(&ctx, entry, GFP_HIGHUSER_MOVABLE,
+					vma, addr);
 		if (folio)
 			folio_put(folio);
 	}
 
 	if (ptep)
 		pte_unmap_unlock(ptep, ptl);
-	swap_read_unplug(splug);
+	swap_read_submit(&ctx);
 	cond_resched();
 
 	return 0;
@@ -238,7 +238,7 @@ static void shmem_swapin_range(struct vm_area_struct *vma,
 	XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
 	pgoff_t end_index = linear_page_index(vma, end) - 1;
 	struct folio *folio;
-	struct swap_iocb *splug = NULL;
+	struct swap_io_ctx ctx = {};
 
 	rcu_read_lock();
 	xas_for_each(&xas, folio, end_index) {
@@ -257,15 +257,15 @@ static void shmem_swapin_range(struct vm_area_struct *vma,
 		xas_pause(&xas);
 		rcu_read_unlock();
 
-		folio = read_swap_cache_async(entry, mapping_gfp_mask(mapping),
-					     vma, addr, &splug);
+		folio = read_swap_cache_async(&ctx, entry,
+				mapping_gfp_mask(mapping), vma, addr);
 		if (folio)
 			folio_put(folio);
 
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-	swap_read_unplug(splug);
+	swap_read_submit(&ctx);
 }
 #endif		/* CONFIG_SWAP */
 
diff --git a/mm/page_io.c b/mm/page_io.c
index b23f494fcc83..fe24a49e034c 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -248,7 +248,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
  */
-int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
+int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	int ret = 0;
 
@@ -295,7 +295,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	}
 	rcu_read_unlock();
 
-	__swap_writepage(folio, swap_plug);
+	__swap_writepage(ctx, folio);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -390,9 +390,9 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
+static void swap_writepage_fs(struct swap_io_ctx *ctx, struct folio *folio)
 {
-	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
+	struct swap_iocb *sio = ctx->sio;
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = swap_dev_pos(folio->swap);
@@ -403,7 +403,7 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 	if (sio) {
 		if (sio->iocb.ki_filp != swap_file ||
 		    sio->iocb.ki_pos + sio->len != pos) {
-			swap_write_unplug(sio);
+			swap_write_submit(ctx);
 			sio = NULL;
 		}
 	}
@@ -418,12 +418,11 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
 	sio->nr_bvecs += 1;
-	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) || !swap_plug) {
-		swap_write_unplug(sio);
+	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
+		swap_write_submit(ctx);
 		sio = NULL;
 	}
-	if (swap_plug)
-		*swap_plug = sio;
+	ctx->sio = sio;
 }
 
 static void swap_writepage_bdev_sync(struct folio *folio,
@@ -463,7 +462,7 @@ static void swap_writepage_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 
@@ -474,7 +473,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(folio, swap_plug);
+		swap_writepage_fs(ctx, folio);
 	/*
 	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
@@ -486,16 +485,20 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 		swap_writepage_bdev_async(folio, sis);
 }
 
-void swap_write_unplug(struct swap_iocb *sio)
+void swap_write_submit(struct swap_io_ctx *ctx)
 {
+	struct swap_iocb *sio = ctx->sio;
 	struct iov_iter from;
-	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
+	if (!sio)
+		return;
+
 	iov_iter_bvec(&from, ITER_SOURCE, sio->bvecs, sio->nr_bvecs, sio->len);
-	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
+	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_write_complete(&sio->iocb, ret);
+	ctx->sio = NULL;
 }
 
 static void sio_read_complete(struct kiocb *iocb, long ret)
@@ -587,18 +590,16 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 	return true;
 }
 
-static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
+static void swap_read_folio_fs(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-	struct swap_iocb *sio = NULL;
+	struct swap_iocb *sio = ctx->sio;
 	loff_t pos = swap_dev_pos(folio->swap);
 
-	if (plug)
-		sio = *plug;
 	if (sio) {
 		if (sio->iocb.ki_filp != sis->swap_file ||
 		    sio->iocb.ki_pos + sio->len != pos) {
-			swap_read_unplug(sio);
+			swap_read_submit(ctx);
 			sio = NULL;
 		}
 	}
@@ -613,12 +614,11 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
 	sio->nr_bvecs += 1;
-	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) || !plug) {
-		swap_read_unplug(sio);
+	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
+		swap_read_submit(ctx);
 		sio = NULL;
 	}
-	if (plug)
-		*plug = sio;
+	ctx->sio = sio;
 }
 
 static void swap_read_folio_bdev_sync(struct folio *folio,
@@ -658,7 +658,7 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
+void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
@@ -693,7 +693,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	zswap_folio_swapin(folio);
 
 	if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_read_folio_fs(folio, plug);
+		swap_read_folio_fs(ctx, folio);
 	} else if (synchronous) {
 		swap_read_folio_bdev_sync(folio, sis);
 	} else {
@@ -708,14 +708,18 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	delayacct_swapin_end();
 }
 
-void __swap_read_unplug(struct swap_iocb *sio)
+void swap_read_submit(struct swap_io_ctx *ctx)
 {
+	struct swap_iocb *sio = ctx->sio;
 	struct iov_iter from;
-	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
+	if (!sio)
+		return;
+
 	iov_iter_bvec(&from, ITER_DEST, sio->bvecs, sio->nr_bvecs, sio->len);
-	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
+	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_read_complete(&sio->iocb, ret);
+	ctx->sio = NULL;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 39521a364376..51e0c5834914 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1583,13 +1583,13 @@ int shmem_unuse(unsigned int type)
 
 /**
  * shmem_writeout - Write the folio to swap
+ * @ctx: swap I/O context
  * @folio: The folio to write
- * @plug: swap plug
  * @folio_list: list to put back folios on split
  *
  * Move the folio from the page cache to the swap cache.
  */
-int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list)
 {
 	struct address_space *mapping = folio->mapping;
@@ -1701,7 +1701,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
-		error = swap_writeout(folio, plug);
+		error = swap_writeout(ctx, folio);
 		if (error != AOP_WRITEPAGE_ACTIVATE) {
 			/* folio has been unlocked */
 			return error;
@@ -1740,7 +1740,12 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 
 int shmem_write_folio(struct folio *folio)
 {
-	return shmem_writeout(folio, NULL, NULL);
+	struct swap_io_ctx ctx = {};
+	int err;
+
+	err = shmem_writeout(&ctx, folio, NULL);
+	swap_write_submit(&ctx);
+	return err;
 }
 EXPORT_SYMBOL_GPL(shmem_write_folio);
 
diff --git a/mm/swap.h b/mm/swap.h
index fe0b694a324d..e4b6ff3eeacc 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -4,6 +4,7 @@
 
 #include <linux/atomic.h> /* for atomic_long_t */
 #include <linux/mm.h> /* for PAGE_SHIFT */
+
 struct mempolicy;
 struct swap_iocb;
 struct swap_memcg_table;
@@ -76,6 +77,10 @@ enum swap_cluster_flags {
 	CLUSTER_FLAG_MAX,
 };
 
+struct swap_io_ctx {
+	struct swap_iocb	*sio;
+};
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
@@ -238,17 +243,11 @@ extern void __swap_cluster_free_entries(struct swap_info_struct *si,
 
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
-struct swap_iocb;
-void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
-void __swap_read_unplug(struct swap_iocb *plug);
-static inline void swap_read_unplug(struct swap_iocb *plug)
-{
-	if (unlikely(plug))
-		__swap_read_unplug(plug);
-}
-void swap_write_unplug(struct swap_iocb *sio);
-int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
+void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
+void swap_read_submit(struct swap_io_ctx *ctx);
+void swap_write_submit(struct swap_io_ctx *ctx);
+int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
@@ -315,9 +314,8 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 
 void show_swap_cache_info(void);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
-struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-		struct vm_area_struct *vma, unsigned long addr,
-		struct swap_iocb **plug);
+struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
+		gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long addr);
 struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
@@ -333,7 +331,6 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 }
 
 #else /* CONFIG_SWAP */
-struct swap_iocb;
 static inline struct swap_cluster_info *swap_cluster_lock(
 	struct swap_info_struct *si, pgoff_t offset, bool irq)
 {
@@ -379,11 +376,11 @@ static inline void folio_put_swap(struct folio *folio, struct page *page)
 {
 }
 
-static inline void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
+static inline void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 {
 }
 
-static inline void swap_write_unplug(struct swap_iocb *sio)
+static inline void swap_write_submit(struct swap_io_ctx *ctx)
 {
 }
 
@@ -425,8 +422,7 @@ static inline void swap_update_readahead(struct folio *folio,
 {
 }
 
-static inline int swap_writeout(struct folio *folio,
-		struct swap_iocb **swap_plug)
+static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	return 0;
 }
@@ -472,7 +468,7 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 
 #endif /* CONFIG_SWAP */
 
-int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
 
 #endif /* _MM_SWAP_H */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 1444d20a40e9..5be825911e64 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -638,9 +638,9 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 	}
 }
 
-static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
-					   struct mempolicy *mpol, pgoff_t ilx,
-					   struct swap_iocb **plug, bool readahead)
+static struct folio *swap_cache_read_folio(struct swap_io_ctx *ctx,
+		swp_entry_t entry, gfp_t gfp, struct mempolicy *mpol,
+		pgoff_t ilx, bool readahead)
 {
 	struct folio *folio;
 
@@ -654,7 +654,7 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
-	swap_read_folio(folio, plug);
+	swap_read_folio(ctx, folio);
 	if (readahead) {
 		folio_set_readahead(folio);
 		count_vm_event(SWAP_RA);
@@ -682,6 +682,7 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
 {
+	struct swap_io_ctx ctx = {};
 	struct folio *folio;
 
 	do {
@@ -694,7 +695,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 	if (IS_ERR(folio))
 		return folio;
 
-	swap_read_folio(folio, NULL);
+	swap_read_folio(&ctx, folio);
+	swap_read_submit(&ctx);
 	return folio;
 }
 
@@ -704,9 +706,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
  * A failure return means that either the page allocation failed or that
  * the swap entry is no longer in use.
  */
-struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-		struct vm_area_struct *vma, unsigned long addr,
-		struct swap_iocb **plug)
+struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
+		gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long addr)
 {
 	struct swap_info_struct *si;
 	struct mempolicy *mpol;
@@ -718,13 +719,24 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
-	folio = swap_cache_read_folio(entry, gfp_mask, mpol, ilx, plug, false);
+	folio = swap_cache_read_folio(ctx, entry, gfp_mask, mpol, ilx, false);
 	mpol_cond_put(mpol);
 
 	put_swap_device(si);
 	return folio;
 }
 
+static struct folio *swap_cache_read_folio_sync(swp_entry_t entry, gfp_t gfp,
+		struct mempolicy *mpol, pgoff_t ilx)
+{
+	struct swap_io_ctx ctx = {};
+	struct folio *folio;
+
+	folio = swap_cache_read_folio(&ctx, entry, gfp, mpol, ilx, false);
+	swap_read_submit(&ctx);
+	return folio;
+}
+
 static unsigned int __swapin_nr_pages(unsigned long prev_offset,
 				      unsigned long offset,
 				      int hits,
@@ -813,8 +825,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	unsigned long start_offset, end_offset;
 	unsigned long mask;
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	struct swap_io_ctx ctx = {};
 	struct blk_plug plug;
-	struct swap_iocb *splug = NULL;
 	swp_entry_t ra_entry;
 
 	mask = swapin_nr_pages(offset) - 1;
@@ -833,17 +845,16 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	for (offset = start_offset; offset <= end_offset ; offset++) {
 		/* Ok, do the async read-ahead now */
 		ra_entry = swp_entry(swp_type(entry), offset);
-		folio = swap_cache_read_folio(ra_entry, gfp_mask, mpol, ilx,
-					      &splug, offset != entry_offset);
+		folio = swap_cache_read_folio(&ctx, ra_entry, gfp_mask, mpol,
+				ilx, offset != entry_offset);
 		if (!folio)
 			continue;
 		folio_put(folio);
 	}
 	blk_finish_plug(&plug);
-	swap_read_unplug(splug);
+	swap_read_submit(&ctx);
 skip:
-	/* The page was likely read above, so no need for plugging here */
-	return swap_cache_read_folio(entry, gfp_mask, mpol, ilx, NULL, false);
+	return swap_cache_read_folio_sync(entry, gfp_mask, mpol, ilx);
 }
 
 static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
@@ -903,8 +914,8 @@ static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
 static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		struct mempolicy *mpol, pgoff_t targ_ilx, struct vm_fault *vmf)
 {
+	struct swap_io_ctx ctx = {};
 	struct blk_plug plug;
-	struct swap_iocb *splug = NULL;
 	struct folio *folio;
 	pte_t *pte = NULL, pentry;
 	int win;
@@ -943,8 +954,8 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 			if (!si)
 				continue;
 		}
-		folio = swap_cache_read_folio(entry, gfp_mask, mpol, ilx,
-					      &splug, addr != vmf->address);
+		folio = swap_cache_read_folio(&ctx, entry, gfp_mask, mpol, ilx,
+					      addr != vmf->address);
 		if (si)
 			put_swap_device(si);
 		if (!folio)
@@ -954,12 +965,10 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	if (pte)
 		pte_unmap(pte);
 	blk_finish_plug(&plug);
-	swap_read_unplug(splug);
+	swap_read_submit(&ctx);
 skip:
 	/* The folio was likely read above, so no need for plugging here */
-	folio = swap_cache_read_folio(targ_entry, gfp_mask, mpol, targ_ilx,
-				      NULL, false);
-	return folio;
+	return swap_cache_read_folio_sync(targ_entry, gfp_mask, mpol, targ_ilx);
 }
 
 /**
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 986dde8e7429..1c42c925add2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -616,8 +616,8 @@ typedef enum {
 /*
  * pageout is called by shrink_folio_list() for each dirty folio.
  */
-static pageout_t pageout(struct folio *folio, struct address_space *mapping,
-			 struct swap_iocb **plug, struct list_head *folio_list)
+static pageout_t pageout(struct swap_io_ctx *ctx, struct address_space *mapping,
+		struct folio *folio, struct list_head *folio_list)
 {
 	int res;
 
@@ -653,9 +653,9 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 	 * the split out folios get added back to folio_list.
 	 */
 	if (shmem_mapping(mapping))
-		res = shmem_writeout(folio, plug, folio_list);
+		res = shmem_writeout(ctx, folio, folio_list);
 	else
-		res = swap_writeout(folio, plug);
+		res = swap_writeout(ctx, folio);
 
 	if (res < 0)
 		handle_write_error(mapping, folio, res);
@@ -1059,7 +1059,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
-	struct swap_iocb *plug = NULL;
+	struct swap_io_ctx ctx = {};
 
 	folio_batch_init(&free_folios);
 	memset(stat, 0, sizeof(*stat));
@@ -1387,7 +1387,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
-			switch (pageout(folio, mapping, &plug, folio_list)) {
+			switch (pageout(&ctx, mapping, folio, folio_list)) {
 			case PAGE_KEEP:
 				goto keep_locked;
 			case PAGE_ACTIVATE:
@@ -1577,8 +1577,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	list_splice(&ret_folios, folio_list);
 	count_vm_events(PGACTIVATE, pgactivate);
 
-	if (plug)
-		swap_write_unplug(plug);
+	swap_write_submit(&ctx);
 	return nr_reclaimed;
 }
 
diff --git a/mm/zswap.c b/mm/zswap.c
index b5a17ea20237..4e76a4a87cdc 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -992,6 +992,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
+	struct swap_io_ctx ctx = {};
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1049,7 +1050,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(folio, NULL);
+	__swap_writepage(&ctx, folio);
+	swap_write_submit(&ctx);
 
 out:
 	if (ret) {
-- 
2.53.0


