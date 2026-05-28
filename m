Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E38EECD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548796B00A1; Thu, 28 May 2026 08:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520886B00A2; Thu, 28 May 2026 08:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D906B00A3; Thu, 28 May 2026 08:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3460D6B00A1
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:46:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3A46161F5E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:52 +0000 (UTC)
X-FDA: 84816803064.10.1369E36
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 64A6C40005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3ls+WRfT;
	spf=none (imf27.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnFpCfWtNBmp0xQCfXEwNqltsuhf50Vy49KtpIfZqxU=;
	b=8izHAccMHF/zkDvIIBa4KHcmqg8+SYDm0pk4mrZxwSDvBAS7Bug78uS7zhHrMGbxyLfo1M
	rS/Rj+KVthN0QruGyOPrXn2l2/C8dxU+iXDDBG00NK5OgsMi/vX3RbxNhm+eiRxxbmWLC4
	/Q5d2J+vTnMuz1Uk5QH2wy5d6yWwEOo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3ls+WRfT;
	spf=none (imf27.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972411; a=rsa-sha256;
	cv=none;
	b=aNu7nO4tqC3xP3e5MD4pNmfMBBDzz3cj6l1fciwT2vGLCMX/iPveo8ZbKLoZlAXOaPbgbE
	HdG87lYff2Q5l7GOO5oA/lGIjMrM62Dyy4xQIeJCisaBbKuV30+m820Wg6jtHfdM5NkPVL
	DlD2uXuddHkaPAvFWNqqs7M7R4CJAuc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YnFpCfWtNBmp0xQCfXEwNqltsuhf50Vy49KtpIfZqxU=; b=3ls+WRfT04Kn4W6R497mKJAzr4
	Jwo2VLYjGMIW+84jp6EmuLN8hTfAQLgw1TEEJhYAQqvsuLg/1fwUYuoDfDuvNbOnwJVdIZW1Dw5xh
	TdN5hKi5tVaYBZqPEqInHlVLccObvLSFKAXuVUM7RgFWamYY6DomvqYpE4JRpejjfq+ZAvpmlaLaX
	LKZ6oUx3AwYHkZ/K6Nl8dciuL5hKiIM9ehVVF6gbsML2W5y7YDUujEbkmWFn7BIQ9PM2bcaeGDNUg
	tKacHb50K1EVRqtzURw0FpuVe6cctu4Ji+3o2V2uP5KQF2LoGMGYdFKzpbY1EoJGd7HSWSjuRwYVQ
	BLyQl9RQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa8J-00000005jhZ-0NTU;
	Thu, 28 May 2026 12:46:43 +0000
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
Subject: [PATCH 08/10] mm/swap: use swap_ops to register swap device's methods
Date: Thu, 28 May 2026 14:45:24 +0200
Message-ID: <20260528124559.2566481-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528124559.2566481-1-hch@lst.de>
References: <20260528124559.2566481-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64A6C40005
X-Stat-Signature: 6z9g8yxajw5pita5qdi1w7mng8ps9tgg
X-HE-Tag: 1779972411-564158
X-HE-Meta: U2FsdGVkX1/OMFbS6BQ/WpWMxnZizcwIFpiO/Pm1CUn1xUSBqsnEsEXz9ZUOxRqNPuVrANSvmendi+a+qQspSqBKZRGLqcn8JKat9aFG0e9bWvMHuEi2E3cBWRgmbuQvOYDunLw3qQMmE3facIyqI/Vns48gS2/Si3frQm4TyK2291kL94BdFDyurwL9ogGSnk0vRnHRIZknBT4cfZ6dLDFsnxD/74cZxVgSXLRsJ0i/5EFLbDKaAm6IPJYVHN/a0ljke8x6S2SIVxFVjFSXO5zj3pbOnstYks2WgN1Yno4xEnEP99fYG5JhOXKwRi3JM0KGY/KQA7CyE3UT0btda67ZE5Qg1zkyqJfx9SuawOMVIDov5ylJkEpQCXTFh94+KMBF74tvJD4JJDP1RtoIpYzhOAZLTX0/3BSZNjfSVKjf3uT/3ZNQirJ9mFPgSY0zLjxym2eJxAx9n9edCARt1UIz/aoLQVAyvUSFPTW2ahR2W05FdPxDl0cfr2JkqlMkfYZK05tUyh4D5CeXAHoin3NIgSkSjVu8PFbX+z43M06aujaZcT4QhW10gnc9ZxeyDoL7nuaV6R3lm0CYpEHvcQciDtabj2Ax52ZFCXdiOItdGkNKfr/LjaUsAqrD8xNVUVdqYM9YIpiqk/poY0ohL5RrZjqaCfIgK2sKxrzVQ0JmpcPK+uv5w6BziKsxRNbplWnja4IgwTTKemzWIf3EV2SToJWLRlMjOW0Si6+Rsb5FkIiETW/vrv/+GXY4jE4tFsO7O51sCRYcYSOZpCPUTrsQmO+yMhpUNW60/Z8hfNvMWgkB59qxSIVoaF1UqSw43DCtpEyVEZr+B28UeI6gGfGoENrEwm67tZvk4f9Wxh/oSkSFK/G0adVNrFGd5oAhs3e75papY+NCMVe6MZsEXa3MqDKPhtQ+QOz5Qn0+KvStm/oJiLNK3Vm36X9F7bhPn4Ce279zT8cFdP+mPIF
 75jCL8Sk
 kWKji7V7OHuAisq5bSUqQZPR6T06qPul61IozQsCOd9DbamB9a5Ii+wyhFiAQrh5PHVQdaLWzducYUJB9Tm9VqDSlxbZJ6jAcdOIEiH6utYRRpD6+tLNuWztJUW16uiLe0UaoMYqy3wuILzkyBbIpsyigEpkX+4/TZ5ifxHdOJ2AKEv2ZnyAS5fHQIQwYrOGmIkBrKQbGnyT1WBihtbG0YlwcsZUxG/FUwcAH2OA1fgRKCAOrXofJJM720v3mOJO1VulTgyUGORuCxkY6FLKPBUekUWpiJGm14zGlVHLqGAqMp94QazaFi0ppHyfwvkPOyIouIdxBx+bEJRGFM+ez3thQSJcVqhgpnLRi108Rpnxoj1sIx77n1zfbcCpozDf1LX0wwNkHtB7UaM9LuQH+Kw8S6xHgdo8cT9rBdO1V2x/9CKWyW6m4ZSCXTEtRoLtFA5w7CIf00HYIh6X6C06odPBo4PhSgCqX2xXEfDI+YQwpPiO3nvUbtekObJKtP5zo+RncBC5Nshv3fp0ymLRX/YkY3SN3+mVz72kpMHYPZgR30/ytGWK58sreYWgyDOI/X3h50NeA8hCTRJ8Heoyjw6hBDXm6twT96mur6ihz2JxHmwtVPsIotXac6g==
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
 mm/page_io.c         | 62 ++++++++++++++++++++++++++++----------------
 mm/swap.h            | 10 +++++++
 mm/swapfile.c        |  4 +++
 4 files changed, 55 insertions(+), 22 deletions(-)

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
index d5f69c1566bf..1d5b891dee97 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -312,18 +312,7 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
 		rcu_read_unlock();
 	}
 
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
@@ -621,6 +610,20 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
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
@@ -641,15 +644,34 @@ static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
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
@@ -658,11 +680,7 @@ void swap_read_submit(struct swap_io_ctx *ctx)
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
index 63d2dc41b213..908ac0e0d021 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -84,6 +84,13 @@ struct swap_io_ctx {
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
@@ -476,6 +483,9 @@ static inline unsigned int swp_cluster_offset(swp_entry_t entry)
 
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


