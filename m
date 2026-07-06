Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC57C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181596B00A1; Mon,  6 Jul 2026 09:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B436B00C7; Mon,  6 Jul 2026 09:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098926B00C8; Mon,  6 Jul 2026 09:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D22966B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:23:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57E72A03F0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:23:04 +0000 (UTC)
X-FDA: 84958417488.22.E6E1CEA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 47DDD2000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:23:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=xOdOZcGn;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf13.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783344182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zN02G99JNTm9pHnWNHPaR3ZvGKPUGfg3ofGB0irAKA=;
	b=VG0JzTMvw0SiGSYWXXCWgCc+OXKpQKGArB2AzWw3UrmxOEut2l+g/HmI7aiI+F+IpTUFL7
	xsSVZrsLiQRszmxYxd3isNSx4FsL0rIgRCy0AeKihpaKQ+ApIhaUQr1CO9NaCYAgRNtyeY
	diYi3cz3vuzkNS6O1db5Rw2yQR2B85k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=xOdOZcGn;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf13.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783344182;
	b=y+Ehg2kHmqvEvVIYMCnLx9ZPsKvrqUBGRUUC6JWlCeaxqhlq4PehVFa7sPbjAkb9sZCRrC
	/uNHLKv0LmTWWIlcxVTuF3olP51lVxroMwCxprbsu5JY5K0xlM7owDkl0Db/+HRoDXwnpY
	lvmI8TWOEIKYahskW3/9vE6aGKFV7Ko=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5zN02G99JNTm9pHnWNHPaR3ZvGKPUGfg3ofGB0irAKA=; b=xOdOZcGn+HlbYLSz6s0ftbU9aR
	LbhKhNDa7DTwCH2ws1FFJlIXhP6WH0viHNrC44P0w1HO9ddjR9tvHwkX0ptiMEc1nh1vvZR3HfbrQ
	Lkhw2uGGcXq8+0+OVwk2SWcuj/FIZU9IB1XTZx1wsCAM6BzPAaQaElFRTrVTvnplX5ZvnQRVFqGwG
	VvhfPM2UwuQPnVB0CJdE3rkN/Qea195o7IL8iOFvyJYeoIrcr32K5Y2x9injiO+ZrPsGtcnzBsvzE
	k9Yv+fejYJoasCLWcol49TIXAmXhKFIhPnqN2C7Uia+FXw7sF8qOKh09x8mmM/PtvJsbeUkfk1xaX
	S9XU5LeA==;
Received: from [89.144.223.34] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgjHi-0000000Cad6-2jGl;
	Mon, 06 Jul 2026 13:22:56 +0000
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
Subject: [PATCH 5/7] mm/swap: use swap_ops to register swap device's methods
Date: Mon,  6 Jul 2026 15:21:57 +0200
Message-ID: <20260706132206.935272-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706132206.935272-1-hch@lst.de>
References: <20260706132206.935272-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: tzfebrsz5hfiopff9hxeki5ezzd46wpq
X-Rspamd-Queue-Id: 47DDD2000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783344182-850837
X-HE-Meta: U2FsdGVkX18rEUC6RbdjLEq0TI5IAIcP8JmylM+djOpqMEF7I01kiHwwoaFPZRJ/YzffEppJRPpyZEGEnJRfa4bHJLUx7v4ikIa33BoN7WURbjxRzI6EVwTxQHyMv62/fH+d/hyoFjEHVHcf9vKJPb/zSswcJIy9GhvnaW9/XkF9gij5jMqj+VWNfeuVKbbp8yP15QERXHnyvPKTRwtP9jem553b0nn5XL3BcZRTjq0gvojyA7+h7wGxf+YFKMPBWVBexVHYnvifFyYGXVdNyyUpwCg71522AnGiTwgCNP/JCNWU/H+r1G17XZWoR0ZgwMO3E6xaMMHUw3/Q+v2DDfnaf8u4Alo6pxQLllXvo2atwxII+Pf57VmQwdAw5NQ6+BAQ9qRZsuPkHpYD+lZzHQiJQ5dHZVgNzvE77WdPQfkwa4ImWqXVpWc0OaTpE09qK0hGLo7WjknqWIXCfEooJZks2TfAc4f5xwBRM7A+0t6Ix2ShUJO1/BQ8x+pJXMvmpwDuDWNDPMz1Hm9SrJO0xKezybGs8ZKeX/KeV4sXMwvKMYF3kh0hr5VcCkBhZlHFEAQVbPMKnDdreKJFVmXEJu6zEDZ0Ys51uKnpsvByZvMg50vjoAGmXkoSLS4EMZk9Ik0JV8m/g6inyI9fiI/gnUwkdAbKsHtJCExH1uVcsTbzDJVBvCttWlEy/fM+jcU1LaujwwQPwdByU2RVclT4nulqyjunswJmu0O6WmXoIkbXYf2C8InBx9QkM7o5+A5SgeMRukWFubBjac77yiNsfa8EcvMJXBZ+IqkeiyEh2KX1fXDfGxAgBDRxXnRAdf2MalkAjpp/+B88kOM0l+mProIBSSaO/y+Uvp80qsFeM0BVIZEZBJD1sRDgkqiE/rKlYLmL51CIJS8E2gyjxJAXdOy3O1Kli8zAvFFKzvK5sQAvFLphtVYknPkvcDOBvYhmWH3KZYzJ7vtYqbi0RXT
 KkReVE64
 jQc8UCKN8TXRo3Ahe8HrejMCMECsqDJNPcOVfimruM6qojcG/BP7/Kt0CchZ5D1WyEvmRikqEDo/atMP7ukEVyRjtCFaHAR6ezQZ+jrP5umPFtKN+zDLTTtkzXYgQvv/NCkXwxT8O7XRQK6KJxliV1V2xEGWLRJs5m8oEUMM4g2M8J4KU17Qc5DZtd91+1T8R/J6QTLoCrUxkYp0IRNc8ig6m0NAbMtrAih3G33HgawQ+ewKLaAwgOhVmm20dqmMIyJMk1WCGtq5yj8L89ItQoXBd2ITh+GsReTZhcJME222utgPwmqQl+o8M9kXc/rIY+O5R/lXVF5UbC/NuqaczzjTsLq4VIkDwDF46b41A9MYJnl8aRYvCSNBobzyYfoJofRflwkPzod4SJrl4xbH0exHRHGW0mOOdUzf9zP0C5LD6p0FExpL5P9wKF5UIDzjhd1FlB8BetCgBQVanuo2B5qo0rGg3vMKgsLmbSqjtK+XrHc0/Z+M5I/LMy8wlciSPFUrfd/lJcVm/iRLVCSDtf6hJRlEFD6ZVDjxgLZ7GhSTCPE8AJDABRdgkgPAJqboM364kbdb90bF7ewEJa7dwJE0sBhTr8srVlbhFrWIwe3cdeMOQwq50YuaQVCOmQrjeIfGy+C9jF1ZmayFC1/NhTASnDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This simplifies codes and makes logic clearer. And also makes later any
new swap device type being added easier to handle.

Currently there are two types of swap devices: fs and bdev.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
[hch: updated for the new submit and can_merge abstraction]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  1 +
 mm/page_io.c         | 68 ++++++++++++++++++++++++++++----------------
 mm/swap.h            | 10 +++++++
 mm/swapfile.c        |  4 +++
 4 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245ba..74ceb7a88fd5 100644
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
index 6009f6991b73..d2b11db1a57f 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -333,21 +333,7 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
 
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
-		if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
-			return false;
-	}
-
-	return true;
+	return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
 }
 
 static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
@@ -645,6 +631,23 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	}
 }
 
+static bool swap_bdev_can_merge(struct folio *folio, struct folio *prev_folio,
+		size_t prev_folio_size, int rw)
+{
+	if (swap_folio_sector(folio) !=
+	    swap_folio_sector(prev_folio) + (prev_folio_size >> SECTOR_SHIFT))
+		return false;
+	if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
+		return false;
+	return true;
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
@@ -665,15 +668,34 @@ static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
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
+		size_t prev_folio_size, int rw)
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
@@ -682,11 +704,7 @@ void swap_read_submit(struct swap_io_ctx *ctx)
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
index b6ba80c2afb0..5119feff0e93 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -84,6 +84,13 @@ struct swap_io_ctx {
 	struct swap_info_struct	*sis;
 };
 
+struct swap_ops {
+	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
+			size_t prev_folio_size, int rw);
+	void (*submit_write)(struct swap_io_ctx *ctx);
+	void (*submit_read)(struct swap_io_ctx *ctx);
+};
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
@@ -471,6 +478,9 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 
 #endif /* CONFIG_SWAP */
 
+extern const struct swap_ops swap_bdev_ops;
+extern const struct swap_ops swap_fs_ops;
+
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1887df22bd1e..b291510813a6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2945,6 +2945,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	if (ret)
 		return ret;
 
+	sis->ops = &swap_bdev_ops;
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2955,6 +2957,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
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


