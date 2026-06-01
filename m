Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21FF3CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876526B040B; Mon,  1 Jun 2026 11:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827E86B040D; Mon,  1 Jun 2026 11:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716436B040E; Mon,  1 Jun 2026 11:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7096B040B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:11:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 255131C0C5E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:11:11 +0000 (UTC)
X-FDA: 84831681942.15.8EDA6F4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4B379A0011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:11:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=esQGmcbi;
	spf=none (imf15.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qaMUmLegFKPPFQDE21i/LYnZDsCIB3wg9TGa3ADKhTM=;
	b=JL/4MTELvFYxvPWZK7jcmXZOmsQuJHLKDmByPZ20ooFDKYsQ2q/PDadLf73OEx9mebj4Eo
	EKUCqj6z2AMoETNuBiIiEU6X9su9e//wzcZ5oZexKkTVqi+YvW1p5HfSRCQUWJXrYGIyEz
	VZaBnywSLHPHnDq+tN6oZsvVwtVBoVE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=esQGmcbi;
	spf=none (imf15.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780326669;
	b=mDWnDOU8C6aACYMSKmx0OBLP7dU9aVzJzlFu4V+MvQDq3mODFjKNMc86T890NOUXqifs9L
	QXWHeO9u0ZVIADaMORzJMqYxrRQbdA4WrpBbnmKSirh7AxLNWZ95STpgDHg42Y3K5Yt/zk
	HngMQBocb7iIF+IrrpmqZG31d3ipYU8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qaMUmLegFKPPFQDE21i/LYnZDsCIB3wg9TGa3ADKhTM=; b=esQGmcbi31lZeSoITWtnD+Nmem
	AvLF4qy64SsIYIugJI10J670dOTtf6T75JRXepQX92FryDcWvo7fwj9JKq52JMdImYsDDMWqFjYcl
	4B8KinDJidGcoP+QzSrNJsSV6/9Tp64C+Sv2ZQ2DIa1BjH5PKk0ABvotJvCl2bbs/LKz6+Jv0QfZd
	NpcsMXTiKeSdVMunvBbZ1RYNClTq/yl/nVXTEXyHRGPw95wfSs+6tpMtHKf87lH/kPMEJswyiawMn
	aBMQqGztLnF4eplGzKb0KtoSgwMnWdzOhIEvx4yEnhXFzOcY+TVcu72LwZvu+3ghJ88I7cyuE5Req
	wmj8w+uQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU0vM-0000000Akcz-3Mcf;
	Mon, 01 Jun 2026 11:35:17 +0000
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
Subject: [PATCH 6/8] mm/swap: use swap_ops to register swap device's methods
Date: Mon,  1 Jun 2026 13:34:32 +0200
Message-ID: <20260601113449.3464734-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601113449.3464734-1-hch@lst.de>
References: <20260601113449.3464734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B379A0011
X-Stat-Signature: cj8a6dri4sxr1odfx3xxmcprxqcrhgtz
X-Rspam-User: 
X-HE-Tag: 1780326668-794862
X-HE-Meta: U2FsdGVkX19LvbYE7g3WpD08sZdc1N7ZGGsGWVH8D26gCG48Iw6usJMuW1bQ9XX73oFJTM9MKgap5xjtvyqXnXd6EgJ5CxOw2P1xfEOjz3YAn/1Dow75HHfzcHspgNTdNgDc9BB9+8Cw4kmBmcs3NzhOc8BYldl+C4RDBsuivvVkoKiQjTtFlSsPovOVaHvw+SXetUKH6Ljqvaru0nbYIPDOv7+iZyk5nNd2O/OIOpgAohqBw6BmtcGNqIsMEKQHfcWTXc5V6XdQQNRDBfDH1TSDm+zKH5SvDLxX7PeCx3ObwjgKDDoY0MyYYkNLV2Rs5HP1s/uftxbjFJvqdwqIaY+zC9jOcPWZTT4de00rH5mz42MV+YHUqFCoDQp43W1rDrlBpuMOrJBimY/tQpH8Zk0skPioopwBGPDXd4H9lwP+TptwTw9d+IkvW2u5sFxUj5BJg9CPAjt2b/tFHDkCFvr6VaZLZ+N0/moq0Y1qk22/GTGGwWSy1KjzZr3IYIfUeJ7e5nv9oM3I+i2+eVBBeMZAvu1vRQuFkoj4uTy5LGN1g9bkxosvAVbBEsr5FNu4RKmmzlNvVXJgt3SI4hiq8yyGLJiyuAy2vO1Hi7Zw7T2o8ntmMIMG5tgZ7Wu4YmI5pvfe1ndqXAU2X8UUL1hi/SkgxPJzufCgpFRjDMfus9NTAcjSJPAPQKnokO/qD+lk6rN9FeRfOxkFG/ci3IXPaarmjbEaKLiMJwRHslncnolq5O3+/ZewR+WP4C8+huE1m/xdYzJb9OPzp1WTVDLNa1DaJ8BwNw/WpsutqxgQgo8wYac/Ro9PDfj6M9T0NPGniqeLED7TPLUui2wAnZbe5YHPwIeNwqZTKP7tfBnxnBCvFkRwIMks1vd6RdOqQbyOU+GDFr5cf9pPC/aSWeCiXKwCmCvaIx95re7B2PPqgLqNK2ZTxHwTZVUwkoTaocUzXXSgGDj4dEbulaX/iVK
 JO9RnhBO
 bighca1fdfxIf8wT8vxqjq6JFbdIemNRzn0ySXLG6auM0kaQKNm9P4DEE+CzmhWC2kd0UCLFYxrD4xbLvufApkZy4WuH+so3tCUZuObo/rF5H80yDgb5HGSpnyyemjRnZgnhRomzRdqHAFYBdS0resx0JZg3gbOz1n/+iMxHEMT0QYvFc7r8WAt1vWq0I7U5qaPsGDSceXgYM23ZixKsshvrJTByzPOxP2aOPgJdKcR/nW9aS4ZPEU4BOYdAtdutP3Zffqi0uK97u9tS0WdZq/0nVqkuoDTTd6VTI18evDzRYE9N83dpmA4HpR+wPqEXgQC6OTar6i56ZI2WMjGi86tQQPueto/AR6vdb6gUPC/CmNDuGiLZDnu6I9eznPN97HwVRIzqLyShr8oAlUTxhKsIQ3m+Qmw/I2d0Fr4S/q2Vn2LvdAyWDUiG3/UXPQNmlNx1sVPmEbDahro+SzsoKxot1qO/efjNs/sKHySK2snkbnnxmjjTEeoIO9gXEQ6daf0GHJwaG3Rm7NYWLGXyHRWRPDsXwGW2abDCzSgTVMwdjmWfZ8wdI7efLU1fuk13s2cfddPUqeziL99/FHo1N5gkKIR3UeGZXwxpinnXq6F4SMfSv+HrLHxOSug==
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
---
 include/linux/swap.h |  1 +
 mm/page_io.c         | 68 ++++++++++++++++++++++++++++----------------
 mm/swap.h            | 10 +++++++
 mm/swapfile.c        |  4 +++
 4 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8c43bc3055c9..2d6fe268c82a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -281,6 +281,7 @@ struct swap_info_struct {
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
+	const struct swap_ops *ops;
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/page_io.c b/mm/page_io.c
index 0e2aabe635c8..218d8fd23dda 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -325,21 +325,7 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
 
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
 
 static void swap_add_page(struct swap_io_ctx *ctx, struct folio *folio, int rw)
@@ -637,6 +623,23 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
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
@@ -657,15 +660,34 @@ static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
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
@@ -674,11 +696,7 @@ void swap_read_submit(struct swap_io_ctx *ctx)
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
index 2372f7cc4653..a670635e0fbe 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2846,6 +2846,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	if (ret)
 		return ret;
 
+	sis->ops = &swap_bdev_ops;
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2856,6 +2858,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
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


