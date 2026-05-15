Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238F7CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B49B6B0095; Fri, 15 May 2026 08:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C436B0096; Fri, 15 May 2026 08:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2866B0098; Fri, 15 May 2026 08:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69B706B0095
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:01:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F52C160FBD
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:01:00 +0000 (UTC)
X-FDA: 84769513080.01.A9C0491
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8B32340008
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=P0dVjOow;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf11.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778846458; a=rsa-sha256;
	cv=none;
	b=hWOzBM5RhdTDyB6BOj9kwoO0NFRjjof2va6Qj5EuwExM+3OddpwxfhprpBVhS7eSHbeon9
	iP4daWgkZ4YGw2hi6QusrxGDHsmTNMPJD/fPQcA0S44VVEywp3NRinu5oCIRQGlFcvQbzi
	D7tVcjSQ/UrY3wi9Btptt58CS0RqYFQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=P0dVjOow;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf11.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778846458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9j/jGP4BxD0U6zr1I+hE6EXXQOvj1+PDpAibyOdO4A=;
	b=O3dpaVZI50KyRHgaS6Ycd2/jqu2+8pyS1JW/ZD6QvAFbPng/8u7OvqW7FF4TRl3Ey+TODi
	HPxRU45tFN7cL+sDQEyiRMHrS8w0VWRz08B55sNg45jMU/6Twl58XWin8cyETgoq/kFkiZ
	5lSQlry34Q50/1iKs3deagupndyY2vY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=s9j/jGP4BxD0U6zr1I+hE6EXXQOvj1+PDpAibyOdO4A=; b=P0dVjOow1IqTasjfRmxQmdN0Cz
	XK1iWxYf7jqj28NqIFnxjJhTJVuI1bRq1qhTX+soEK5fNWCD1GlXFI9EBsMJ9r+uOOqjDa1WgQMaV
	qvGfV5M3Vrgr1kpzh3LEuNClgQt4JfeW9lq13mfzJ76kqrz9/3o9L79r0VwlozBnEzjMXDOflMdsH
	flWWEPuM3HWK3vqlRhuzW4LqcZguyCLplB4EVnQVBWK4EdhnAtHstOOaKl3WIXs7afewmGarJjk0x
	rPaZ+7dH2iC6TaoVrMrxiDGWOWFZ85bPEP8G834ZhTos+AX79aQfh76zFclsxkmZeRjhyLALa5DFe
	ZQEm8pTA==;
Received: from [2001:4bb8:2d2:300a:b132:4044:9ee9:7f18] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNrDl-00000008Gb1-3j8a;
	Fri, 15 May 2026 12:00:50 +0000
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
Subject: [PATCH 5/6] mm/swap: use swap_ops to register swap device's methods
Date: Fri, 15 May 2026 14:00:10 +0200
Message-ID: <20260515120019.4015143-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515120019.4015143-1-hch@lst.de>
References: <20260515120019.4015143-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: sdnqeugnfoern34rs9qk573uzmwwz4wc
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B32340008
X-Rspamd-Server: rspam07
X-HE-Tag: 1778846458-837474
X-HE-Meta: U2FsdGVkX19XV6aC+lWpCmcd45un/P6EkBmIBXhks6pZpYIRErJ+2/Hmfozmayi8h4r0SdtlAA1LIf3PfSxhQGeg3l3Y8TOHWUnpP8DEPcODgu/RMtNK5mGGDbynX8GyBVUgp5o0VNNUYo0YOrgHxR4+SFhZkYvdkLXuf2/1QMTgqtXBzFm9f8styjD3rMQxOHRuwL2pyiLQiq337Fy/5QrjNofjcB8jSRNZN8tJqR1H/4kN6qfLltGlsvzdh5FsmvMk1yAs0WNwfcMDz5G71nQJZ6bpDVLpmbffeANiKGKlHrdxpudTYkykmot4OX7f2Js9+f8MaAeonMJYeeHq2THzX5Lp7AVUS2zWejDmFykQWNsK9KXnHlwcMLx6CBy7nsdoxBJmZOVHHdDDcCpjNTM771ipz1pMXgAqW4tckqgXEZyAJIwQcAFN267RBsxbRHeGi7HvuATs6PgeUbY8VHYVmf+mTZ9oQYxuWPp8z+Qr2bte/Yk6uoNzMeBG+xbTih+T4AJCxCTKtt8K6k8+m68Yavtq1DAq8onOsYarI+P61EGogzLByUdojLzBeQNwc5TE5y2zG8Uw2okvbMv7pwbwaVxmV0FlqBQAW2SdurHV6rkDhv5YE9LF7PcZoH5RdFydKKl0BV2YryNnKOCmQF6+nI7hjgvmEU+W/NuiFoftxwhD1TGKYRr+qiG7fjMF3GGkIIjL2YWg1R0ySq5rLfZAZJanY6aeVhItJdmFMATZ0WEhzmvRW5yjcharYJBXh25Go7yACC/7+fYfZFQMvL6Q14p2F50Ns77tzjgFCFn8TU6oivS1CpP51+PzhmG54/cQQbMT74594utm1ioTO13hw+R9vxyQ+DX+DRO55u5MgQjxgHD/nnitiCuYNzQWL+O4TFHz9amaObGJ/xWqgmljR42h0uE/76PrHilEM7v8kgwrXbPKDC9+NLJdG3aPB6ZwZK0Ca27MMoKNMKF
 iE5xqMuy
 k4WTzQ2zaCB7WROTPvuY0cHdopgETY+ik9d3A7sBrSGb+kLeE7rWEC8oRwj9FSGf42GrqcMV6sJU82PbThj5vmF8uDA2IQbgsggHu3dLfILEBHuWbrdHSHyOlowUDMLCQGEooq+W+VfPEPNO6qqBr1yV1w4tuZoz3sU3LL35OSUU4K4llFuki1B/PghuzHJW9q0ozQCojE1psSBDiaST3Ix/G7pshw2WzkP94J8EUdPdgkgTrDAiR/DQurFpHLKre2lEsm7eiD48EQTJrV/5YCi7uxGmStaQ2+J/5i365rhhMP4YAIuNi+othyeH7/zrsZm+jS0aPHPbYbJrn6IEft33oq2UzhxbBLM169oD8WTlbEORHeUHHzwhiJNnV5u1AKHedyEMDif0xsQYaMUdukUeA9Qt9A2VTLFknPmYPt6EODgZLNp8dK0WI40e8K9mOUZ28HU2GcnbOfeSDaZskKzJDaUhpAdza0KzEk0+Jp0sKyrplNuVIV/NX44qTqj2ZhLaccDPqKPtQvDVf2SdbVCfW/zYwkosCxLTQyaaPqJGGYcg+uEsvRUMo1ys8b4Mg/A1d/CqwI+Y9SMjbIu0muckqk82XGslQk1x6syQNbupT/IvHsOsLcintjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baoquan He <baoquan.he@linux.dev>

This simplifies codes and makes logic clearer. And also makes later any
new swap device type being added easier to handle.

Currently there are two types of swap devices: fs and bdev.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
[hch: updated for the new submit and can_merge abstraction]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/swap.h |  1 +
 mm/page_io.c         | 63 ++++++++++++++++++++++++++++----------------
 mm/swap.h            | 10 +++++++
 mm/swapfile.c        |  4 +++
 4 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..0da33b803348 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -282,6 +282,7 @@ struct swap_info_struct {
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
+	const struct swap_ops *ops;
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/page_io.c b/mm/page_io.c
index bbd8cf47d20d..4678a8af9f96 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -309,19 +309,7 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio)
 
 	if (ctx->sis != sis)
 		return false;
-
-	if (sis->flags & SWP_FS_OPS) {
-		if (swap_dev_pos(folio->swap) !=
-		    swap_dev_pos(prev_folio->swap) + prev_folio_size)
-			return false;
-	} else {
-		if (swap_folio_sector(folio) !=
-		    swap_folio_sector(prev_folio) +
-		    (prev_folio_size >> SECTOR_SHIFT))
-			return false;
-	}
-
-	return true;
+	return sis->ops->can_merge(folio, prev_folio, prev_folio_size);
 }
 
 static void swap_add_page(struct swap_io_ctx *ctx, struct folio *folio, int rw)
@@ -585,6 +573,20 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	}
 }
 
+static bool swap_bdev_can_merge(struct folio *folio, struct folio *prev_folio,
+		size_t prev_folio_size)
+{
+	return swap_folio_sector(folio) ==
+		swap_folio_sector(prev_folio) +
+			(prev_folio_size >> SECTOR_SHIFT);
+}
+
+const struct swap_ops swap_bdev_ops = {
+	.submit_write		= swap_bdev_submit_write,
+	.submit_read		= swap_bdev_submit_read,
+	.can_merge		= swap_bdev_can_merge,
+};
+
 static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
 {
 	struct swap_iocb *sio = ctx->sio;
@@ -606,15 +608,34 @@ static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
 		sio->iocb.ki_complete(&sio->iocb, ret);
 }
 
+static void swap_fs_submit_write(struct swap_io_ctx *ctx)
+{
+	swap_fs_submit(ctx, WRITE);
+}
+
+static void swap_fs_submit_read(struct swap_io_ctx *ctx)
+{
+	swap_fs_submit(ctx, READ);
+}
+
+static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
+		size_t prev_folio_size)
+{
+	return swap_dev_pos(folio->swap) ==
+		swap_dev_pos(prev_folio->swap) + prev_folio_size;
+}
+
+const struct swap_ops swap_fs_ops = {
+	.submit_write		= swap_fs_submit_write,
+	.submit_read		= swap_fs_submit_read,
+	.can_merge		= swap_fs_can_merge,
+};
+
 void swap_write_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
 		return;
-
-	if (ctx->sis->flags & SWP_FS_OPS)
-		swap_fs_submit(ctx, WRITE);
-	else
-		swap_bdev_submit_write(ctx);
+	ctx->sis->ops->submit_write(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
 }
@@ -623,11 +644,7 @@ void swap_read_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
 		return;
-
-	if (ctx->sis->flags & SWP_FS_OPS)
-		swap_fs_submit(ctx, READ);
-	else
-		swap_bdev_submit_read(ctx);
+	ctx->sis->ops->submit_read(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
 }
diff --git a/mm/swap.h b/mm/swap.h
index b359735be3c5..aaf774fd03b4 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -58,6 +58,13 @@ struct swap_io_ctx {
 	struct swap_info_struct	*sis;
 };
 
+struct swap_ops {
+	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
+			size_t prev_folio_size);
+	void (*submit_write)(struct swap_io_ctx *ctx);
+	void (*submit_read)(struct swap_io_ctx *ctx);
+};
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
@@ -495,6 +502,9 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 }
 #endif /* CONFIG_SWAP */
 
+extern const struct swap_ops swap_bdev_ops;
+extern const struct swap_ops swap_fs_ops;
+
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 27dbce0d1e1e..fce69a91e7b4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2785,6 +2785,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	if (ret)
 		return ret;
 
+	sis->ops = &swap_bdev_ops;
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2795,6 +2797,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
 		if (ret < 0)
 			return ret;
+		if (sis->flags & SWP_FS_OPS)
+			sis->ops = &swap_fs_ops;
 		sis->flags |= SWP_ACTIVATED;
 		return ret;
 	}
-- 
2.53.0


