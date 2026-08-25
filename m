Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86FF7C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155366B0098; Tue, 25 Aug 2026 11:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132BF6B0099; Tue, 25 Aug 2026 11:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F37EC6B009B; Tue, 25 Aug 2026 11:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB6CF6B0098
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:32:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C96C8045A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:49 +0000 (UTC)
X-FDA: 85140184458.11.E4CEA9F
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63F5116000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cLmFpt3d;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787671967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhSwWX2E/V88OSmZiCSHWiUU/JQeVGndYgjPiEldJdU=;
	b=V1gUXR4FOR5ao4hMpZlV2/AX6P9oYbUiwXvMI84itFGep+yo+l7QwTocATzNtAaQ/sp0vl
	VzuUTkwsXsEoGHo3ft5Q4B+8aJXUvTjTcu2eHeV7TreAve4LJbkMKihW3lQJvrMvX5Sncz
	sv7dDF6WQNqB0l3lf0OEodn8BK84Feo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cLmFpt3d;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787671967;
	b=HiZ9H8/8l3Vv+G49tA4JAs6FBse6W64jGJ/fYikoKcQvYpEChpioP9FPk9u7tZ5A1fU0PP
	tCADG2Y/MD8lRtlFeYGGMrTcwOFMTowzATcUqIx7CpDgLNdNwBYBmzDP9Sh0LZF0vMTkpZ
	oMpDkA8HdFiX2qIXtZOEW/yABXbE9tM=
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-4b28db06775so3395500b6e.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671966; x=1788276766; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QhSwWX2E/V88OSmZiCSHWiUU/JQeVGndYgjPiEldJdU=;
        b=cLmFpt3dqXgKT2esd3MrduwYElAc/dPVaoGMBVQVCUe5ke1JrqO3rlGkoeJx2WM+QO
         i4teFQwl5GI0akJIiEBzfHSXnPXwPUbgdJX418xvqTEpQYiFIcwHnBB5EhNBNxrHxlWq
         nsZGrUo3enuq/D6r9YlC8zookPGlZ1DX966EaT+x1eiCBeFvp1oGxEDArSzf5OPMmq0g
         o31fGFNA0yHM+0yRJxJyp15LtM2xIDyvmSKbC85IP40OfdaUYIg36XoqXuBEZHLZnVpX
         Lo0vf8VC6xdyTu/nb3zIS9soI63gJotJx+GhlqJjY8x08a0cGRVho7m8qxD2qj9WQg+E
         YBvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671966; x=1788276766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QhSwWX2E/V88OSmZiCSHWiUU/JQeVGndYgjPiEldJdU=;
        b=GQuwSHuSSi81H0EuF3Wyq/gQVxAmPxdu3AM1gKAtsSVfkokCARyd13ZQZS+tf+NqsP
         5oEwrAHVzI3LgUzDpqkn8SbEu6iBMubElyliBW82FgSbMtsp6+VpUkXRXOYp9F3thryy
         745IwS371TGXTpvbzbNGCSxoaX2Kzsa8e84uMb0+ift7Ujnp83xuyJ1ySzNI60mjYVpU
         03GIKUGgWL7w8wnGwxrM2ObvP+B383gG6TexW00aqZ1OS1DNzykPaFgrqt+rRLMD2NDy
         O3VdssNx8wGn2949E5Vc04To+2zQmTc+k1o5kFIRGr02QonzDjZ8HSsQoXFRoga+de7Q
         r5DQ==
X-Forwarded-Encrypted: i=1; AHgh+RqfsQwGPXG9+yKmik2RQPHeku+rvRGxhypSsCSQdtrf2wHlKQMcTfJKbTasFx1Lq9LEIxpSKhzMWg==@kvack.org
X-Gm-Message-State: AFuF++mrH+7/qkFacGkXUlJG/0ZQi48d92486PzFzoVhp792lpafz9J2
	CccXFfFw3cozaio6yU7Fc+Vmde09E49yRQkQgHbIOu0+aZ1+QAYTixIM
X-Gm-Gg: AR+sD107EuwSIJLtqJU9bZypZ3ToLJ3+d28n6FAt4N0Hj+G2I/3HQzTQg4AA3zWK6nh
	4a1EgoaPu+whD2ufsvNPKOVwM9QAU0qiystQHhlA0u+Gk5jCLn7oIz5nTvlX2HI0arAzN/x2QTg
	7XJTYfn93mzb+mc2ZAh5Tf6VQF2BxXHC/jTki3gDIKzIen3P9C4xTlaB3bS2whqzVDf1yCzkn+I
	PuHXsdq1ZAftdOtel3ZbX59jPJqmNpgXLgJbc9X7cQXRynYzpVpGLwXkJ6hKWUyywDaoaVX668X
	xRfvsDWN4FzlnbpyniZ1J8fTNpiXF/WyNjdwUjXmrvorD0ZPykKBNt0T5IGeXnRgOykvHtPaDUg
	AbOS3J4m9is4BZS7Gr/4K1c4KJeSr43klSHQT40Do7SPFH76/1qpJ2wAp1+2XzSL6RhmALwe2gY
	twkpa7uYNr2Tkr1ldTaw0896MCcvuvLtX8+m+bWc/ucli1qjKIx//+LAGBIYQqFbN2cn42CD1f5
	IOOyfrlroI=
X-Received: by 2002:a05:6808:448d:b0:4b3:3e1:4a25 with SMTP id 5614622812f47-4b350513b86mr7973433b6e.11.1787671966152;
        Tue, 25 Aug 2026 08:32:46 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5b::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c690a5asm6225953b6e.8.2026.08.25.08.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:45 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 03/11] mm, swap: prepare the swap IO path for vswap
Date: Tue, 25 Aug 2026 08:32:29 -0700
Message-ID: <20260825153238.2695446-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kgjbxbcjsdpo4yq1gsqcsmoh5sn3mboi
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 63F5116000B
X-Rspam-User: 
X-HE-Tag: 1787671967-906947
X-HE-Meta: U2FsdGVkX1+crMXbvbgSVc11IzQ2qCYYd8ckiTXtxrLOR3HwvjGCy5R/bGzTCSgshTPddPZ2tUEVBnjhLnrAp7FvB8h++wgPBJ8AWgFM3EYpx98Fz0EL9JBJw1QTCUTDYBmWRC3TqDAYZZ/NpwQGF+sUADuSceQ1rtS5/I5CnodDuwqutYtUUwHIylNMZZT5YVJIeKi4UYu3WvRpJqlcAWizSM/cW7ScMytO77RvT7PCUTvXxLq3Ko9YHAF+kcUvZYpK/jzZe0CJmJ9JU0f3FLFRJ3xObmyX99XhwcVxyTIekmiO/RKykFX8lV+TE4Uheexoq/mVs/20lGtb2I8SsVpEPq6l8i0sQvkjZZ8QAI+qSsPqyCWP1S9eDF2+zVdxYQFsxVHOjHhwRCdkcCYRrbZ3ZTZvEzARCZNiZgedKEQf9ojLebsSlcpDrHX7YVISFEqPpWmzj5v11B3Q/dYlDdcHKRYph7XPtwdJaMg+kr5mlaU/0kmClEhBIPY24RRArDMPCzhXxa/B8EdYPIOXWxoQDOQ8bl9pOyRLoNi57NnUN3KkH6nVp/LqJEjGHSiw0L7hBJfrbIIeMX3h1h6iBLOFyP16f5eg3n1xyJVspYrCS+q68ld7OwsjocqlLfZj633DlB6pI/ttraWDV9EOVeQfxOU6e9NuuhxR8C+Ygm8vMv+tlwCZpAKUtTw7s4KSLcQWAIqlOdcd2sbMRjOSj28/5lOjjBBOK8OoI5H3X+LJM73tgbTYgjYHLzkVdAufkW9l75VBuupc7AStR67grGkhqL5cVS1P/2az5y+RwK/i0U8BMwpIrimSv7nfK1xOnF7Escep1DmBCn772nwaYCKRrClSeDnoWLjBBuLBUo4nbYrgCrh4dklHku69M0ws/FxSaDL5N3ggYHfKwFTzqSj2Rtc4py6JilW1VKLzWx1UJCthBCgClI2l7gx3ii0SsQXlGno3mH9blKIqArn
 N3kSW1fs
 ATAsY5KTOrMvwtL4VqFU5RbKkPTOP4jRI09pFDq7+F5GtwL1oKdnp/NDzqdv53sCDRm4l/q6mRMZs+kkSrAt+qwYpry+IvwUpqCfsV99ZLXnlaEXpeTiuwb4Fnku6/uITKPAmeC1hUc+Rpu1PAq1pR8obp2AZvUgiHDZrXOl6R2f88NpLGxPO9tAIX6NRRZiEmoF06XqhOpk1jlIy+OrPkl1eFHiV9G+ENW71Kfito96U/XrFYqU0JYJpq9zi++0eaHK9IElihv18eVTQl7SCSJ6qKGc7b2Pxm/qeEKF8fJO8vBdHt4Nepo7dIkUPk54i7ucOG+wC+Wc/PWY4XUvG73971GdCAGhOt5kkUZiX7vVLAl1Dpw5RsIurWdDbtaBZ1we8KeTMAAOctvLdq9I5Oo2ReZoQk8MNfpjOx84m2HcqfYZ6tbs+ALX8oIF09E5Jev0sbepJZYNt0MOgts4h0gUD6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for adding a physical swap backend for vswap, make the
swap IO path able to submit IO for a swap entry other than folio->swap.

The swap IO path derives the target device and sector from folio->swap.
For a vswap folio backed by a physical slot that entry is virtual, so it
identifies neither the backing device nor the sector to submit IO
against.

Compute the sector from an explicit entry (swap_folio_sector becomes
swap_entry_sector), thread that entry through swap_add_folio,
__swap_writepage and ops->can_merge, and stash it in swap_iocb so the
submit and completion paths address the IO from it rather than from
folio->swap.

This lets the batching path serve both vswap entries (backed by a
physical slot) and physical entries mapped directly into PTEs.

All callers pass folio->swap for now, so there is no functional change.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h     |  2 +-
 include/linux/swap_ops.h |  9 ++++---
 mm/page_io.c             | 54 +++++++++++++++++++---------------------
 mm/swap.h                |  3 ++-
 mm/swapfile.c            |  6 ++---
 mm/zswap.c               |  2 +-
 6 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5339323486d5..f57f4aeeb822 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -388,7 +388,7 @@ extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
-sector_t swap_folio_sector(struct folio *folio);
+sector_t swap_entry_sector(swp_entry_t entry);
 
 /*
  * If there is an existing swap slot reference (swap entry) and the caller
diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 57ac6c703f68..223c84548bde 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -12,6 +12,7 @@ struct swap_iocb {
 	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
 	int			nr_bvecs;
 	int			len;
+	swp_entry_t		entry;	/* first slot in the batch; addresses the IO */
 };
 
 struct swap_io_ctx {
@@ -30,15 +31,15 @@ struct swap_io_ctx {
 struct swap_ops {
 	unsigned int		flags;
 
-	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
-			size_t prev_folio_size, int rw);
+	bool (*can_merge)(struct folio *folio, swp_entry_t phys,
+			struct swap_iocb *sio, int rw);
 	void (*submit_write)(struct swap_io_ctx *ctx);
 	void (*submit_read)(struct swap_io_ctx *ctx);
 };
 
 void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter);
-bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw);
+bool swap_fs_can_merge(struct folio *folio, swp_entry_t phys,
+		struct swap_iocb *sio, int rw);
 int swap_fs_activate(struct swap_info_struct *sis, const struct swap_ops *ops);
 
 #endif /* _MM_SWAP_OPS_H */
diff --git a/mm/page_io.c b/mm/page_io.c
index 3bc69c2dbe4d..a3aaa61d6c79 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -265,7 +265,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(ctx, folio);
+	__swap_writepage(ctx, folio, folio->swap);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -334,24 +334,22 @@ int sio_pool_init(void)
 }
 
 static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
-		int rw)
+		swp_entry_t phys, int rw)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
-	struct folio *prev_folio = bvec_folio(last_bv);
-	size_t prev_folio_size = folio_size(prev_folio);
+	struct swap_info_struct *sis = __swap_entry_to_info(phys);
 
 	if (ctx->sis != sis)
 		return false;
-	return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
+	return sis->ops->can_merge(folio, phys, ctx->sio, rw);
 }
 
-static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
+static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys, int rw)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(phys);
 	struct swap_iocb *sio = ctx->sio;
 
-	if (sio && !swap_can_merge(ctx, folio, rw)) {
+	if (sio && !swap_can_merge(ctx, folio, phys, rw)) {
 		if (rw == WRITE)
 			swap_write_submit(ctx);
 		else
@@ -364,6 +362,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
+		sio->entry = phys;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
@@ -384,7 +383,8 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
@@ -400,7 +400,7 @@ void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	swap_add_folio(ctx, folio, WRITE);
+	swap_add_folio(ctx, folio, phys, WRITE);
 }
 
 /*
@@ -504,7 +504,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, READ);
+	swap_add_folio(ctx, folio, folio->swap, READ);
 
 finish:
 	if (workingset) {
@@ -536,8 +536,6 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct page *page = sio->bvecs[0].bv_page;
-
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
@@ -545,7 +543,7 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(page_swap_entry(page)));
+				   ret, swap_dev_pos(sio->entry));
 	}
 
 	swap_write_end(sio, failed);
@@ -617,7 +615,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
@@ -637,7 +635,7 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_READ);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		/*
@@ -655,13 +653,14 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	}
 }
 
-static bool swap_bdev_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw)
+static bool swap_bdev_can_merge(struct folio *folio, swp_entry_t phys,
+		struct swap_iocb *sio, int rw)
 {
-	if (swap_folio_sector(folio) !=
-	    swap_folio_sector(prev_folio) + (prev_folio_size >> SECTOR_SHIFT))
+	if (swap_entry_sector(phys) !=
+	    swap_entry_sector(sio->entry) + (sio->len >> SECTOR_SHIFT))
 		return false;
-	if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
+	if (rw == WRITE && !folio_blkg_can_merge(folio,
+			bvec_folio(&sio->bvecs[sio->nr_bvecs - 1])))
 		return false;
 	return true;
 }
@@ -677,7 +676,7 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 	struct swap_iocb *sio = ctx->sio;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
-	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	sio->iocb.ki_pos = swap_dev_pos(sio->entry);
 	if (rw == WRITE)
 		sio->iocb.ki_complete = swap_fs_write_complete;
 	else
@@ -688,11 +687,10 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 }
 EXPORT_SYMBOL_GPL(swap_fs_prepare_rw);
 
-bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw)
+bool swap_fs_can_merge(struct folio *folio, swp_entry_t phys,
+		struct swap_iocb *sio, int rw)
 {
-	return swap_dev_pos(folio->swap) ==
-		swap_dev_pos(prev_folio->swap) + prev_folio_size;
+	return swap_dev_pos(phys) == swap_dev_pos(sio->entry) + sio->len;
 }
 EXPORT_SYMBOL_GPL(swap_fs_can_merge);
 
diff --git a/mm/swap.h b/mm/swap.h
index 1cc9f3f5105e..f2b64920ae5b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -320,7 +320,8 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index e0b603a247c0..f5fd01307a67 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -343,14 +343,14 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
 	BUG();
 }
 
-sector_t swap_folio_sector(struct folio *folio)
+sector_t swap_entry_sector(swp_entry_t entry)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(entry);
 	struct swap_extent *se;
 	sector_t sector;
 	pgoff_t offset;
 
-	offset = swp_offset(folio->swap);
+	offset = swp_offset(entry);
 	se = offset_to_swap_extent(sis, offset);
 	sector = se->start_block + (offset - se->start_page);
 	return sector << (PAGE_SHIFT - 9);
diff --git a/mm/zswap.c b/mm/zswap.c
index e5a9922b951a..54506935ceba 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1076,7 +1076,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(&ctx, folio);
+	__swap_writepage(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 out:
-- 
2.53.0-Meta


