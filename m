Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D478BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666AD6B009B; Fri, 10 Jul 2026 02:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E5C6B009D; Fri, 10 Jul 2026 02:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52DA96B009E; Fri, 10 Jul 2026 02:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 174CE6B009B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:40:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAFFE169377
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:40:06 +0000 (UTC)
X-FDA: 84971917212.10.B9DC946
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 59B2E40004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:40:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Vyr+8OB+;
	spf=none (imf17.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783665605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FiRF0hNdsCB6M2uhWIxGVsN9qKcBxsyPOmoJ/wPY+Ks=;
	b=uZ+BMPOAqkA5JkGkqqXkMZO7FiA3QgW6Wc3F41wsF1QCZDHHzcsFrs2gKICjttP79dPK1c
	VplLHc3HQpZ6Q1ItOxjnkJkhGIeTlNMYJB5z34x7kLK30O7a7zSUoai24LLLYnmTEvJ1ug
	KO3W6jH5+UM1MtX+irkEP/SiO8KotQQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783665605;
	b=wjAmPjhE6xIQ3NLpZdWWuGtuwxevG9ez8XRg+/xjmKaN83aVp3u8rEMvg4pRcMowZOWuWU
	lbV24gI8kruM3DAUNU3ATmaDxcl5HF6WJmupqELrGpINtWi0knVf4+wTUFsT+OO9rumXzl
	nzgzg35WszryuMfvKHOLOSa8/uvW97M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Vyr+8OB+;
	spf=none (imf17.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FiRF0hNdsCB6M2uhWIxGVsN9qKcBxsyPOmoJ/wPY+Ks=; b=Vyr+8OB+fq84TA1C4dxOI602X5
	kUNtFV3CSYk4JTI/qB8iu0pGnhes3SCso9lGpJWhrd+hu/QMB1Hx18T2nTBuzBJ0dy0RJnNO8r8+U
	8ThZs48lV7Owk2I1x8xylGdrLQYrH8as8ZAS+KBLcy6rv/TL11GEZT2DDn4LUdaGvn4fSmrvrQoVh
	LzweU8NfFwr6AZXK/plICALcjAuLkFaH1eBuS6rLEVtFMHU08DQ7xyqBKd48EwGJuMEidFeiydYrh
	N6vsmzjDX62YwqJFMY6NohdGrVwaA0/9J4fheasBNcjTJN/NF+IjOZMEEPkJJ6dsVEpbby731I94d
	UZmrtPJw==;
Received: from [2001:4bb8:2cc:d72d:4dff:292f:a943:a4b9] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi4ty-00000004HTM-3LBL;
	Fri, 10 Jul 2026 06:39:59 +0000
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
Date: Fri, 10 Jul 2026 08:39:16 +0200
Message-ID: <20260710063927.1891452-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260710063927.1891452-1-hch@lst.de>
References: <20260710063927.1891452-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 59B2E40004
X-Stat-Signature: wh5dbt8yp1yen4rhduayaz7onadmfdts
X-HE-Tag: 1783665605-281246
X-HE-Meta: U2FsdGVkX19EvrBbsBxXT8SlS1TPS/ymyefFO/56yZV3f4AfGy6GLn1n6lcmYxpoNdhkq/F2lno6avC45I1OWl+ATi85NJsDGKIWsed42qFVp6I8dJuVaUsTKN3YJA5p1A4JkjaYlHfM6Jbi8jsI6CC5LhzpOaKlMc9KeN7ggt6OXPSJiZXCF1Q8qheJb4G0JIx6Yao1czAmmEo7AQ8+k235lkfgktJ1sF+lEAFL7ax2JeyQyLcXY+pPHdOI4P1uep8Hc9K/G+d42JdTR/wbdDDoq5ULjtt2186OWzoGQq25JdcfSmj/hjKxX3lj++lUxciM/VP0Y/8DjTZB+YFaKOd83AQ3ZRnuxBPitTqYxN9oI8UnXf9dkEAKvN26cWKoIn1UBr4uBQ9o8I2gWVpmWeWNb2FY6xmOKBTUY9QxPALqn0Yvxwmlv6hSl+nM6hFWXqeCxj5WK1cRRTh7BZKMeN9Davoxu2bTAQodIb0ONm+cZlcG36a1C7uUmr29S2QygLPFB2Za3Fz2b9I5Rj39u/WS7+Uh0mDMNOmgFXeXZECuKvuI9/UCpZ5gJFP2Lq+/qef7d68iZ/YGbfmpYd95I2d+r6MkwowfqpRnAn+47W3x6P2peqsOMUL66zoAQt3y96tYbVjH5rM47YYoPjJIDibJlphmbze0EytjMmVrHSwqy74SEg/OLtz9CcQEWishVKnfwqoE78etGaZ/1HZrfC5p8yxMeNTT5YkfKe8BYL2kij3aJpZ79GKBoaD0vodVGx63kzN2l6tEbBQMahmE8whgk01Fdsx1NbH4GD2CJWC9e4zCvF5mMcHuQTEWBKduFpbP4Szx2HTrCM8rGjQgZcHmx+gg+RdqlU7fbMVjojlAGoiFplmhOWJxRSEQQMNQ84FjN3S7c8cEjpj2/e1MXa+3rNRkKF1l7qA5wgiBPbIxy7sR19L5QdlwaZBI0xjIabzz6qmQejeVKxYuE0K
 2/LefZW3
 yM3AM9gzk1bU5OUsnzmmnv84i/dMsERZrQaBFeMcnqNbLk1NWBCDdh6ZicUYz2CqgKJu4GAs2zFRJT3zRtnXQgHy9W6CJj/MMYstvDt0FX/layBCUnHD+fP3KVlspAxi6yMnSaibe0q2Bcph0aOgMKGY+mizAWN8LIdp1A8uMz0t/9tQX+jWFcS6xtc92DAZNqF6EVdnNg66DNPjDip4g/DCQ1LWxdKEQb/gO4Wrd2vOHFK+t8PGXVIGh5gNleaizJacTk4dY7GuvReK8EcI5XrEpSCQxoZmbi7VsNodAfLzS3aBRldvX36yeJ5PQTIbCmOFXo1MIiJatq1lLWT8rghmI539mApKz0Mwu4jkFMBkLKGsOkHZkoO6M6hDmKO1aZAtSiLt8d+NDhjDm3/XrkULDHHPx7PeZ0GO5Qi0T0/gUY46yyxkSAHs2A3AEmbG+eP89IDgUpUtNyOu3zTtRFUYnowZG3DHYUJgBYhBu4OASNyjbLTeEed/7UI3vy76jakylI5LdYmGayxeKIoP2vNL2CPGUGpFh5H2SfdwYHEQ2lW7DFeh7Dk0fmAPkSNBMObqAhm9gGYOSasnjaF64sE4dlwMtgW05DJHcAtr+onFDhnk9jL2f4B0EWM3d07PSe+fPJSHRJOHepDx2XCxKakjExAG+qUx3MY4tef1KUeZlNbk=
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
index 6c78aa641c86..449207b2b9b3 100644
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


