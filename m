Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899EDC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812936B009E; Mon, 13 Jul 2026 05:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C33B6B009F; Mon, 13 Jul 2026 05:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1476B00A0; Mon, 13 Jul 2026 05:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF496B009E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:34:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BAFE140A8A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:39 +0000 (UTC)
X-FDA: 84983243478.30.3AFBBFC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2FC712000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CH4JxXDE;
	spf=none (imf03.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935278;
	b=S4j8qj3k4G4mBTzvSCEN2MJ+vo5t2djGwDjYkyqI80MiEYbiV81FBAe/nfPTj3GJkG7bGP
	kFaYbjmgG4WPOnKemDshhQA+s/v2G2MNFqgi8uO+GeRoPgaEbDtHvKDfX0lM8Y0M/sCYF7
	OUQITaOw6i/py1jdnhxWw8NNvDZWtR4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CH4JxXDE;
	spf=none (imf03.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88u9WXhIp3bQx/HiJ3WvBlExgjDVfNL/4o7C34bvgwY=;
	b=r/0R4UpC5zmbKbwAF/5boyNSRegMEE1EEh2cK/bKk4puFRTdJNiJld2v7XwCcj1CnU0YBo
	32DCtGUH9+TfMJX9imLSDo3vLcchwJDVNantFmTFNmkVm4RiPFSnQBR/v5AOfGHCf2hjRB
	FbmV5X0fG028LLCd8DYFTq2UetosRtk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=88u9WXhIp3bQx/HiJ3WvBlExgjDVfNL/4o7C34bvgwY=; b=CH4JxXDE2/p5RiJg08xxrcu3Td
	USkBrZ7Un7UovQ1HuzTQkeSDx1XFz9lwbuJHFhzd+H6nZMOnTozwf5hAUZE6zf6vtY23I3QxPGpGL
	T6LSuvLKyC31d7xgtrcVbBRGkptx+IfbtJoTldHwlmJZEXldM5vXr9FsIs5cGd6u7iPf9FPdssVL2
	LaWEj6IOyp3l1NlXHW4FvpQTvvp34b8TLFAcpiCcTz1N2hpavaMikGDMV9qwhKbJcBbvrDeiaxA54
	F1RZzzItt6TB9nT32C8jp+tXaHyyCwr1ZeqQFgq5kOoKkJTVgyoNs9vhsPeFa22Xdi4FAnrkDNzB6
	7T0kQqIg==;
Received: from [2001:4bb8:2c2:7dc3:4a7a:b4de:3d88:bc44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjD3X-00000008kli-1D10;
	Mon, 13 Jul 2026 09:34:31 +0000
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
Date: Mon, 13 Jul 2026 11:33:42 +0200
Message-ID: <20260713093350.2154226-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260713093350.2154226-1-hch@lst.de>
References: <20260713093350.2154226-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2FC712000A
X-Stat-Signature: 1rojdtnzhamngfogxsc8ygokf5ujm9fb
X-HE-Tag: 1783935278-848282
X-HE-Meta: U2FsdGVkX18jcP9ZBnIPS1jzTG5hogL+bcKaOpdV9QbZMma4rF5X836ayV01B6EKJFgkkGbTbzdgfWHC/Kd+UafkGN/6UnB2EH319teNdi4hoaNwbxHWqD7i1GrCp2xIKGzbckzQNkW7sXClbAgLbAX+2DKFUCD2/L0Wiw9JfAt3QoHbbSqXTsxVVEq/5A4n0laFZfa23O2DJv3GfzMfswhR8Pklo/Q3NFLo4v92+rBLC6xTqOmnbrYCmw6pYmPP9dECw+4+gjWfGr/0+tuDTs83YY+HR5ao8CvCpKRW9iaRj+8VssH9opPGBM/b7vLbZ3+NgdYPjmxhDyky8fWzIWjOiIFTAhJ0hg3JUqwjP9kzoqde+hx0FrpklhOKVEpt8JMfsj069VvDqibBtDLMAKvJJF65eXEAJ/ciykXM2pvsFogPJMALLKEWR/rdj9Yw5FVpPlF7stozL6CMOSBWAB4A15SM80v+uDZ123O5nOsjYd0c0CChcVqD23kpcpJhnKoCFW+/CIljTIZ+xxXtc/Px6ZDeGU+izNrPw+cm4imc377pcARokf8YVqq+aiO9aP95bRIL4IoiE30jhpUTjob5qT81rRWGBSlqhBZgBRXnfGxLim+FdGM9uA/K9NwxXBBwHeYmzqsmQU3YuDY1N01tcf9dgCFdrpuqGzNaItr4MHSksDTLw+5vNL21r/YmTgWcg8SwjKArTwEHTfZytpkJvKcXFoIa+vQhGSpWErxfCCnrBrzCiEp+Exs+nelhz+wA47DLzaC4n6u++KsKWH+WAYUjmOJegWsoxMcIBT4y6/JcuaMXhMFzEf1zTMakAP2VF1Xwzuq21vrAXuWM/OmtjqGGSlKIlL6xxql4CCGdroRb2k1bYOOi9xIpbRLQ0KpybsoV8RW/+NKoQcZhEEwNfyeaC1LW9kTxNcFrA6X/HZoHv7jf9TTT8E6tZqQBXMmNw4lxaBDbhhgZORy
 jRF/6RBu
 56RqrIG6fb0dB/5cWj0XSm7H+lMgJ0xElPZrcSJbxLHJcbP0H0zAjDAPPX4sMsCExmGNUmuqm74DDsc8awQ0AqgxamYzs2vzartPLJfnTMTyYENT7P+w8OxuJbjmsLMxISy+OP7zUdezdYDxMoLGEI5wIugXOtzAAGhwBpGmGIJ9sEN07VqbHy16dWmqDvtNtxV5m/4yMLKYxmnqEPayj8+rbILXx53ywyXrj13y/V30C+rN9CBxIaWeNMzQ9DHfVOXqNHgWaZ/Xw4635arF9dPgZjpc/d9tnMyf90Qx84sIgiTz9sxSq8y6IWDaiBKTN/ec3TV3bEbyqRRz6VAZpZeA1l1cCbbAPPPn5NRPUOM7tGY9UCnh+IiM38U6mjmX2JD5I1mIUq1wdd0sZg/AxNfHAlOc4nv2lpVozU3g10Wo4WIgXrwS8O+HjNPlqzOiBpQ2keNPBfOtWrwLwuf0BMdL/Ch1XhV1DNMooUiT5d6L1hawlvjnDVYqghlXvGFc523lAaar/RBrpREreePjMgkVXNsgKLoRbL60BnWezHM+USZ42ai5w7zRmN6bnlRg4kgLVln57EKGcGlUgsNysIqT2c5ut91gbWxQmu1jxsoO8n/8j3GwZjpow4BCOdnfmgJrgmkVvXDAwfkw/MoWIvIH67Ta2hGChjo1kY5623WQAXgA=
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
index 696ed01709c2..ee84d4cc8457 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -276,6 +276,7 @@ struct swap_info_struct {
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
+	const struct swap_ops *ops;
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/page_io.c b/mm/page_io.c
index 56f21e49572e..c36b44ffe947 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -334,21 +334,7 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
 
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
@@ -646,6 +632,23 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
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
@@ -666,15 +669,34 @@ static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
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
@@ -683,11 +705,7 @@ void swap_read_submit(struct swap_io_ctx *ctx)
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
index 1d169bf96d1d..33a258c77064 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -82,6 +82,13 @@ struct swap_io_ctx {
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
@@ -469,6 +476,9 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 
 #endif /* CONFIG_SWAP */
 
+extern const struct swap_ops swap_bdev_ops;
+extern const struct swap_ops swap_fs_ops;
+
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 881511fb7a46..c6b3e4278045 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2950,6 +2950,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	if (ret)
 		return ret;
 
+	sis->ops = &swap_bdev_ops;
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2960,6 +2962,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
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


