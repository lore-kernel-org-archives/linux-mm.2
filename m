Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2749DCD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA0A6B0092; Fri, 15 May 2026 08:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A603C6B0096; Fri, 15 May 2026 08:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864EB6B0093; Fri, 15 May 2026 08:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 695FC6B0092
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:00:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04F088B74B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:50 +0000 (UTC)
X-FDA: 84769512702.02.4547FBD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3CA1710001C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cRlXXlTf;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf14.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778846449; a=rsa-sha256;
	cv=none;
	b=BDKdHmr3GxLLNiHgQcrPdp6z0Gr82RH+n8h4Eepqf7KrPcKQiAjAUlzg1SsqtHSFQt0Ls8
	POTfZ+XcOAjgqCnfdSV8KCnLhh5PGP7S3unTB22Bv05TGCjrsuMH7DisThKaWS4Hm2I0nG
	Yxmhc42fXtrt1BBy+s7CHjQboNwLPVw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cRlXXlTf;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf14.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778846449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I10ZfjT6zNJJ9PX9idEOlaYf6Mlpzlcyz5XwKGefzdI=;
	b=gy0eJLRQjEL67xrH4dU1a4oo7+eDQvEf8+BwMTPrAAtMwZP2jIIPj58M7k0pAUnKthVZbR
	EwBxsbTR+adJTybER/4IPpb6s8iWXmkRGXbOmjPne/+RpQfOlPSpS0IMejMKB+K2UL8WP4
	ug5CWfO4tPh96v6afeiRS3M8m+IrdLU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I10ZfjT6zNJJ9PX9idEOlaYf6Mlpzlcyz5XwKGefzdI=; b=cRlXXlTfxxNP8qO066P4I5yzSL
	CS84r4dcLxKcYCAyzbyiWqLh5DfOUzK9olFqcY4Syjq2KK4aXlvit5WZx+EGnFKvMt9tHlhFKZ6i6
	nR6R80QYuvxBjZHD6BFXfj87bgzH/5rNdck3ijPlc6HGhY/Y5JvffSxIWtV7umi/a/aXM7ESIXfdg
	Yo0OI3C7Xxo1RuAgsBcb9qO7coKBdB5S6YnJuH5md24/bYxYryrA3knb6PyiVDaeFiRr9lE5k5IPW
	BruRbM/7D8/TlOVoLVmD1PVP/MownSJnNhLihXuz/axEMSGhUjqmvUqP8xY/Dj+leSjzu5NahochO
	Nx1qNBEQ==;
Received: from [2001:4bb8:2d2:300a:b132:4044:9ee9:7f18] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNrDc-00000008GXc-0M3A;
	Fri, 15 May 2026 12:00:40 +0000
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
Subject: [PATCH 3/6] mm/swap: intoduce struct swap_io_ctx
Date: Fri, 15 May 2026 14:00:08 +0200
Message-ID: <20260515120019.4015143-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515120019.4015143-1-hch@lst.de>
References: <20260515120019.4015143-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: o9f468ow11nfrg8apq4rdjaxzxdfzkaw
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CA1710001C
X-Rspamd-Server: rspam07
X-HE-Tag: 1778846449-594142
X-HE-Meta: U2FsdGVkX19hiv+xFiBn/qiPUesNKfVDyE737m1xtd9kdxnCYNraBVzumrjMarZSXTiWuEyXhqS/SKA3SgfwxNTsTjnMQjoxIcUhYVUNd1Uo0x4JnsuMnZA0kJUnyN5erljN+N82iS+nVC/O+ls9LyqhjZat1U0mtxN5HB7Z3ffN8WEp/R/tWjC4W7ukPPyzWnMzacsS9kKh45WtbnFiLdFD1WFOIcmBRc8EJCu+tOzLucjL+cfpWhx0oV2RKywZQbhad3hgB/Ac86vIZUvtuBq7S95y4VZL3zKzRmd7xrbFU0QNu6Ia4wkU1zWJlRY9GqkRZLk3yAwrKPcxJ/hzkX3yq6asaqSUAFYW959a9krzzay2n0V5E/JAAw2+EXLp4dhxUPc9COsyLqL35kHiU6or01lzCZHz+FlXQKplirUQ+BZS26LE2wQIDqfTD7ezB7z6LjqgX3ll/HZaPV5ItM7LGouVWTaJ/Fi/x43rkYWAXSjPQgTORPyiQ+HaOk2qPJW17ru3m5k+8CCrtQA91DQ5P/a9JFQ5kb7SBpkGQOKXaJj54OvCV/vNb1aC4vTU+SxLXrlnVSkfozTcj6VxH8Dgc3LOovY5amVk/J2pNzokEejIALSk38gVbB9Lvc4vRwMGtLQLTwQ1lit9FoMUxQPXZMKqUAKCKWSzNMPSyBDgnq/DOCSvlYsUTSw0gKxRQKZgVfdXyDev1VWXU+OJirSSP6VpECn1Vo1DuUImWQfoZfLiI22xPWS+gKzFXwvuOnk4pTWa689+klIP+LmMosnXgnoEhiz0SN0NccDZz9BmZW6/Jv76GHh8t+hf0JpRlvEzytB0CF9J/zfIkHzNzezRKkKa02MWxnkAZTrvLKTKHF/XOBW+wdoTYkkV4pD8InNklBcAIw2p8soY86mIHUe+u/Vq0nL4ZJ39M0SnLfmciJ2wykcny6iqhItczDUVosfU4fkvcIg1621PJqY
 PDOiragM
 Hfb1yi3AhZZg/Xka11SlVkbbsyQbLcqCj2K1Tgz4Cob66cL0xnIap1ieEaKTlK9pNM5RGawrxYvt4b0CIxxJ6G48r01KA72mp+JqxQb4Dh7g25CJMX9HMGnVkjyLvftXfy8CBCyiEApWU0Z15yZWS/IE3G8O2EYc/2Gkn8dFNngGQBJd5O7KPIriYiEApMObpGu7+CW428LmVjamwuVVIhqsTB69UDNdA0bqJSbFnoRq8jhTFsKsC0fhLN8NXJzBCACZnhh2muu1ZtFgdmnmUTHLUv8QBqT5cGjJAfa49AJKSv9fLbN5JZrBxzLk7g6jSBHPhSVF4RDaaGeNE07B/i02Fv94FZK+EloeY8GRdc6rjK/iC6BViu0m3r05UGIRgl0pf0Gq28cIQqs7s8ReRoKKwN9qcDBYVydI4HpFzGs9mA/I/jWoLNnU3sz9QiCTG3rho31MNY3mwmV9x6nG5wJAvO7W1ZC1hYsarUz2vGXTg1weyQzsqgf+WNCT0j9ATFCnxRr8ehwbuMBliQvqJZz+Lu8icvzAkSQNoLRQyq5lRUxi2MSwie3BurC6RrGMJoFOXD87/kwSC6kxv0l+bWjoecMo2Hzo/OM0n
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/madvise.c    | 16 +++++++--------
 mm/page_io.c    | 54 +++++++++++++++++++++++++++----------------------
 mm/shmem.c      | 13 ++++++++----
 mm/swap.h       | 36 ++++++++++++++-------------------
 mm/swap_state.c | 40 +++++++++++++++++++-----------------
 mm/vmscan.c     | 15 +++++++-------
 6 files changed, 91 insertions(+), 83 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf5..9ca82af8799a 100644
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
index 70cea9e24d2f..a78efc9909c8 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -237,7 +237,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
  */
-int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
+int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	int ret = 0;
 
@@ -285,7 +285,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	}
 	rcu_read_unlock();
 
-	__swap_writepage(folio, swap_plug);
+	__swap_writepage(ctx, folio);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -375,9 +375,9 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
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
@@ -388,7 +388,7 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 	if (sio) {
 		if (sio->iocb.ki_filp != swap_file ||
 		    sio->iocb.ki_pos + sio->len != pos) {
-			swap_write_unplug(sio);
+			swap_write_submit(ctx);
 			sio = NULL;
 		}
 	}
@@ -403,12 +403,11 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
 	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec) || !swap_plug) {
-		swap_write_unplug(sio);
+	if (sio->pages == ARRAY_SIZE(sio->bvec)) {
+		swap_write_submit(ctx);
 		sio = NULL;
 	}
-	if (swap_plug)
-		*swap_plug = sio;
+	ctx->sio = sio;
 }
 
 static void swap_writepage_bdev_sync(struct folio *folio,
@@ -448,7 +447,7 @@ static void swap_writepage_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 
@@ -459,7 +458,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(folio, swap_plug);
+		swap_writepage_fs(ctx, folio);
 	/*
 	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
@@ -471,16 +470,21 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 		swap_writepage_bdev_async(folio, sis);
 }
 
-void swap_write_unplug(struct swap_iocb *sio)
+void swap_write_submit(struct swap_io_ctx *ctx)
 {
 	struct iov_iter from;
+	struct swap_iocb *sio = ctx->sio;
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
+	if (!ctx)
+		return;
+
 	iov_iter_bvec(&from, ITER_SOURCE, sio->bvec, sio->pages, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_write_complete(&sio->iocb, ret);
+	ctx->sio = NULL;
 }
 
 static void sio_read_complete(struct kiocb *iocb, long ret)
@@ -539,18 +543,16 @@ static bool swap_read_folio_zeromap(struct folio *folio)
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
@@ -565,12 +567,11 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
 	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec) || !plug) {
-		swap_read_unplug(sio);
+	if (sio->pages == ARRAY_SIZE(sio->bvec)) {
+		swap_read_submit(ctx);
 		sio = NULL;
 	}
-	if (plug)
-		*plug = sio;
+	ctx->sio = sio;
 }
 
 static void swap_read_folio_bdev_sync(struct folio *folio,
@@ -610,7 +611,7 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
+void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
@@ -645,7 +646,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	zswap_folio_swapin(folio);
 
 	if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_read_folio_fs(folio, plug);
+		swap_read_folio_fs(ctx, folio);
 	} else if (synchronous) {
 		swap_read_folio_bdev_sync(folio, sis);
 	} else {
@@ -660,14 +661,19 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	delayacct_swapin_end();
 }
 
-void __swap_read_unplug(struct swap_iocb *sio)
+void swap_read_submit(struct swap_io_ctx *ctx)
 {
 	struct iov_iter from;
+	struct swap_iocb *sio = ctx->sio;
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
+	if (!sio)
+		return;
+
 	iov_iter_bvec(&from, ITER_DEST, sio->bvec, sio->pages, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_read_complete(&sio->iocb, ret);
+	ctx->sio = NULL;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index b8becbd4beaf..a9c1694d2755 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1584,13 +1584,13 @@ int shmem_unuse(unsigned int type)
 
 /**
  * shmem_writeout - Write the folio to swap
+ * @plug: swap I/O context
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
@@ -1702,7 +1702,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
-		error = swap_writeout(folio, plug);
+		error = swap_writeout(ctx, folio);
 		if (error != AOP_WRITEPAGE_ACTIVATE) {
 			/* folio has been unlocked */
 			return error;
@@ -1741,7 +1741,12 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 
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
index b6db72fb9879..3ec35b6d629f 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -4,7 +4,6 @@
 
 #include <linux/atomic.h> /* for atomic_long_t */
 struct mempolicy;
-struct swap_iocb;
 
 extern int page_cluster;
 
@@ -54,6 +53,10 @@ enum swap_cluster_flags {
 	CLUSTER_FLAG_MAX,
 };
 
+struct swap_io_ctx {
+	struct swap_iocb	*sio;
+};
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
@@ -216,17 +219,11 @@ extern void __swap_cluster_free_entries(struct swap_info_struct *si,
 
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
@@ -293,9 +290,8 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 
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
@@ -353,7 +349,6 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 }
 
 #else /* CONFIG_SWAP */
-struct swap_iocb;
 static inline struct swap_cluster_info *swap_cluster_lock(
 	struct swap_info_struct *si, pgoff_t offset, bool irq)
 {
@@ -399,11 +394,11 @@ static inline void folio_put_swap(struct folio *folio, struct page *page)
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
 
@@ -443,8 +438,7 @@ static inline void swap_update_readahead(struct folio *folio,
 {
 }
 
-static inline int swap_writeout(struct folio *folio,
-		struct swap_iocb **swap_plug)
+static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	return 0;
 }
@@ -500,7 +494,7 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 }
 #endif /* CONFIG_SWAP */
 
-int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
 
 #endif /* _MM_SWAP_H */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 1415a5c54a43..abc26414368d 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -573,14 +573,17 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
  */
 struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
 {
+	struct swap_io_ctx ctx = {};
 	struct folio *swapcache;
 	pgoff_t offset = swp_offset(entry);
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
 	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true);
-	if (swapcache == folio)
-		swap_read_folio(folio, NULL);
+	if (swapcache == folio) {
+		swap_read_folio(&ctx, folio);
+		swap_read_submit(&ctx);
+	}
 	return swapcache;
 }
 
@@ -590,9 +593,8 @@ struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
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
 	bool page_allocated;
@@ -610,7 +612,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	mpol_cond_put(mpol);
 
 	if (page_allocated)
-		swap_read_folio(folio, plug);
+		swap_read_folio(ctx, folio);
 
 	put_swap_device(si);
 	return folio;
@@ -704,8 +706,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	unsigned long start_offset, end_offset;
 	unsigned long mask;
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	struct swap_io_ctx ctx = {};
 	struct blk_plug plug;
-	struct swap_iocb *splug = NULL;
 	bool page_allocated;
 
 	mask = swapin_nr_pages(offset) - 1;
@@ -729,7 +731,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 		if (!folio)
 			continue;
 		if (page_allocated) {
-			swap_read_folio(folio, &splug);
+			swap_read_folio(&ctx, folio);
 			if (offset != entry_offset) {
 				folio_set_readahead(folio);
 				count_vm_event(SWAP_RA);
@@ -738,14 +740,15 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 		folio_put(folio);
 	}
 	blk_finish_plug(&plug);
-	swap_read_unplug(splug);
+	swap_read_submit(&ctx);
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
-	/* The page was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 				       &page_allocated);
-	if (unlikely(page_allocated))
-		swap_read_folio(folio, NULL);
+	if (unlikely(page_allocated)) {
+		swap_read_folio(&ctx, folio);
+		swap_read_submit(&ctx);
+	}
 	return folio;
 }
 
@@ -806,8 +809,8 @@ static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
 static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		struct mempolicy *mpol, pgoff_t targ_ilx, struct vm_fault *vmf)
 {
+	struct swap_io_ctx ctx = {};
 	struct blk_plug plug;
-	struct swap_iocb *splug = NULL;
 	struct folio *folio;
 	pte_t *pte = NULL, pentry;
 	int win;
@@ -854,7 +857,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		if (!folio)
 			continue;
 		if (page_allocated) {
-			swap_read_folio(folio, &splug);
+			swap_read_folio(&ctx, folio);
 			if (addr != vmf->address) {
 				folio_set_readahead(folio);
 				count_vm_event(SWAP_RA);
@@ -865,14 +868,15 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	if (pte)
 		pte_unmap(pte);
 	blk_finish_plug(&plug);
-	swap_read_unplug(splug);
+	swap_read_submit(&ctx);
 	lru_add_drain();
 skip:
-	/* The folio was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
 				       &page_allocated);
-	if (unlikely(page_allocated))
-		swap_read_folio(folio, NULL);
+	if (unlikely(page_allocated)) {
+		swap_read_folio(&ctx, folio);
+		swap_read_submit(&ctx);
+	}
 	return folio;
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index dc0d4312ac6c..56cd59e27447 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -617,8 +617,8 @@ typedef enum {
 /*
  * pageout is called by shrink_folio_list() for each dirty folio.
  */
-static pageout_t pageout(struct folio *folio, struct address_space *mapping,
-			 struct swap_iocb **plug, struct list_head *folio_list)
+static pageout_t pageout(struct swap_io_ctx *ctx, struct address_space *mapping,
+		struct folio *folio, struct list_head *folio_list)
 {
 	int res;
 
@@ -654,9 +654,9 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
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
@@ -1061,7 +1061,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
-	struct swap_iocb *plug = NULL;
+	struct swap_io_ctx ctx = {};
 
 	folio_batch_init(&free_folios);
 	memset(stat, 0, sizeof(*stat));
@@ -1392,7 +1392,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
-			switch (pageout(folio, mapping, &plug, folio_list)) {
+			switch (pageout(&ctx, mapping, folio, folio_list)) {
 			case PAGE_KEEP:
 				goto keep_locked;
 			case PAGE_ACTIVATE:
@@ -1582,8 +1582,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	list_splice(&ret_folios, folio_list);
 	count_vm_events(PGACTIVATE, pgactivate);
 
-	if (plug)
-		swap_write_unplug(plug);
+	swap_write_submit(&ctx);
 	return nr_reclaimed;
 }
 
-- 
2.53.0


