Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA43C5AC7C
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816106B0093; Thu,  6 Aug 2026 14:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EDFD6B0095; Thu,  6 Aug 2026 14:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBD56B0096; Thu,  6 Aug 2026 14:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1756B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:43:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 834CB14017E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:08 +0000 (UTC)
X-FDA: 85071716856.27.271D6B4
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id AC7A240011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y2GcHpJw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786041786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uMnAqaoMp1MP/2YeQ3uTyWm7ZJYM3hk0so38h+N6NA=;
	b=I1MFg43SsuqsKwGze4rIQqqUl+TTvH/qr3GI3cFV7hBzCFzn8MogBw5tccrwsTrPu25Nlk
	xboCXUXg13deUy2CmICN8zzrWxiHCcfpQ8z9Dlpkjalbvlt+RsM0jBQf3bCsjpUok4Qniu
	pbLzxov6fnYjZQ9iiYbMcaSxVGSKTVE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y2GcHpJw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786041786;
	b=6URbXWTKXZRezzs1Cn1u/5dNfLiVX5dyxdEY1DunLH5vr8eQwj+OSlbD6wY0cVqL2pNg/N
	m0GqVwTROFvxSiTtT2JvtyGmsWCsvIqTT4SkEPT3b3DFrLroOYPvquQPsddRN/ULqY9Y01
	QgrkSFTYMbwrRSxPnainiNuoXqS7xuE=
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6b01abe5cdbso511276eaf.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 11:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041786; x=1786646586; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7uMnAqaoMp1MP/2YeQ3uTyWm7ZJYM3hk0so38h+N6NA=;
        b=Y2GcHpJwQj5lHLHyeEOAKSenOXu5iucz+BnW63fe4vl29v4PE+c39s2bo9jKLdXZli
         iycwFuTvsgzZsFwh+q7yx5JjvlIVkABCtlj7L4OmxSLaCewvfqmWgFQs2/5gUdGjMSl3
         6Ozm42GrZbn8/g7tcewU2qXQokUzhRIf8PnHYbSfUVhCM1wHj/tArtKYNV3prQ/TbsnD
         ciD4HQKmHxiHsELpKYPsx7wrS0kTjgWqMXfOyRCQ7zFl5dbBLg0CbJOyW38LviX6IvJw
         7ICWEWPbM/H643jPAaieMRhwwLOtuGTa3aPbrDUW52yzhmHB/OPaakXXCRbTVM1oTNw5
         jEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041786; x=1786646586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7uMnAqaoMp1MP/2YeQ3uTyWm7ZJYM3hk0so38h+N6NA=;
        b=tKr2kbzDEvgJrogEj4E/lWOCBEuxK6uP25hiiF3euZpY5qQx4sslO2wCI4ex5a62l/
         4vieXZq4lvZYlChi2b19gZxSs5r2PtEkELM5CCZjCck9h/ylDIIhM5QoTSiAUfXEqGCC
         Ugtg7wQ1lVT/OmoQkoKrGEtcoCz7FkWH8Ygr1YfLb2FsesVnfW/eP2qq+c1hWwvXsFRp
         YoN5HHlGNsF2BmqRfuQHWX8ac0244jzsOXqsV6UVo65zDOwLPHuTLOLr4tgYVKoRFmU7
         unIJZEgX3Z9ITTrO/ZtxNdfbu+A/sKHk7+OKDeXv9Bfk3nZb7E7fm57TFHLJpdFWq4jl
         y91w==
X-Forwarded-Encrypted: i=1; AHgh+Rqnj7pgAEdpYdGzsZuNQL52eqSLP1Ym4gz77EkeXWqK33EHviCj7DQxSKPoJJ4A6D/svBBYSmE3GQ==@kvack.org
X-Gm-Message-State: AOJu0YysSiUZoKuqg9Vesi/oFIZAAuMJfiw6vujMUw1LghFiuZpmU1oj
	UUNxx6k5fSfu2YmlSHmOPHzi2a9PcIvo6F5oiwtQiiTqZV2Lk49NcQt+
X-Gm-Gg: AR+sD12zS/Ys3J0i0DIjPY4f+5X6v95uYPWdP0nJyxUKAL1eCZd+xgKQzeq5dZ0QK+W
	jZ9Qn3Z4+2LenEvnq9A0rNdFtOxWLR+Hk5ITc3Bm0N0FagS/hH6C4hYeTEwy0KeRKSdx9ASAcrS
	SXCVuzxldIph5cPk3RH3C8m/cjCug0R9dAHTXkgtZ+zwUqs7B0xUj8sFRECPmzh0lDXcNFqg3do
	Up4YVMIOe2SAyNw/ZcQnU0PTLRaI5KMFc81Wt9w1eJNMlt3cPBTz+FLNVv1hq1UlthboHiWL1Hv
	hKZLZTmF+BRM1eVTDc3SB6+kpqSXFw+YEevfUcYpy7Gz2eDMMTHeym7P1/UUiVglTchPVpAgo5D
	MFJr6rfN4J7t5Q+9021aVII7Nptb8dLoBXp1GfGDzP7hkYJgPGs4Rvyt9V5Pnh2MxlYJZwMpYs7
	EjcjlzF7vPfdWy/N6fWzapfpkaQ/fqTYhcdqhXE3umtbsI7rHwlVF1DN27EsLta2HrHG3fK1ZT/
	DPi0Gl98zs=
X-Received: by 2002:a05:6820:4b8b:b0:6ac:b3b1:a5a4 with SMTP id 006d021491bc7-6ae968c1761mr9319789eaf.0.1786041781003;
        Thu, 06 Aug 2026 11:43:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bc7f3d1sm191834eaf.8.2026.08.06.11.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:00 -0700 (PDT)
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
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
Date: Thu,  6 Aug 2026 11:42:46 -0700
Message-ID: <20260806184254.3790858-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC7A240011
X-Stat-Signature: 8jtqu1q74eycsrha8zpqd6xnzwicidfh
X-Rspam-User: 
X-HE-Tag: 1786041786-221336
X-HE-Meta: U2FsdGVkX18InRjaSuiMX70oVAe9G/OT2d24Mi1sJQcfeydtcmjOWJwFwC3BQOwsnusnt++lABiGWOoTLQfKtWyOCp61zPKenMKqPR7oLzpWdRYsKsRY3QEcoyFB/UQTHA4S+/9vuiE/NCkPxgpSXBgIuyOCh3MyTDbtEq15XviRuJoYPStoDJT3uT/NhmtlYwrub/x73DdLu9ncP2Ar8XqbWyZKU+bBwTgYR1Bjpmio0Xh0HYfV7mRJSdoaBV2V5UO3XaSJDMlyf1a8F+7nbYzzlj+gJMvTBxRjrTpdhZQukmuWc1DNVwhHBuo3PGPORIROafM1UZP1y6i7yKsvIOOdz/92P32/CDnqXbEJdX4adBYliof77Mdn0ZMridHwzsn8ufzShzkchqqmD9ah5p3zenIhr71gf3GQo9cIUtlcpHa06GVdDCH47ef4jgpb8tqwPr15Y8POKivm4qQRPcxfnz62837otRMSvW2dV7Hqvlx1NHp8sBw6TS4/Vj9a18jXjTKC0GC48iSqyeUA1kdu24bdDHSDvfq6e6WfosIZiF+ipFK+p+MktJfpwY7DOrSmTiYEJQ6sOkH77bbltKVPh+lG9298uOh34KY0hijpFN5tcq3dkuyR1CBfftv0wvR6y1NcNRYvS6+AAaiipiS0sfEnFnKYxJG5Uk5aTEQn4y2Nm7EpEEwtHPY8ooQf8FJVP5InMIcuG656MPI3MmPcDlSUj7QIB+a65gsCr6ikhAn5cjweCaGewvPi+AVsMTdFv3uRttgmI66LZNZzgNC3JjBgzVVwP7/aeKPIoG+Ww7fLz/a+kxu/je+tVk+dmK0n1heRPCGrplu8hyqpFH6jB2r4vyQMxZljx1LNQ1KOCVxWxGMDtBjZTJrzal6/uWms2qneyfrelfI3hj02TfqG+ppZoLJuU+Bbk9vdqOLcTcMRS1AV9hFETrmxOh/nTtf8svJZVKnnPRhub7B
 rRGfxpij
 W7o1ggOvKM0C8dvBCGxtywsVfPwqUpUVyoy0bDerdiRXWDf2llfKeLb5cHeDVRfMJhRgkYH+Yelm9E1WRi5IKigq3T8qnwsdMMdgBtMZQSG7WXrvUtQ0V38Ja4LarM2Irdz1YCO7kqoEv9asTITn8LI4ju7JznmtjfiMeMfBdwmb6dm1EUHUrZzrmN62t+w4nx1ZixqueWutysZJCLY6M5SnlD0U6uo7SPD/z/U9KA0B0Z1UYRpSmip3gqEjJcPNksg442xTzbZRdRMgiI7PyNIIRogFmsz7oI47RVOrdAxm+BDK8+lXaszZOd1sTaugDnB5mpXrrSeAOk3yYjywd93OemUu4DhF5QVNrJrKqUuhgxDlcWPUqTfXm3N2H0iL9aaMZsbrlD1yzQ7uk2qCKf3+o4M/1Eb0xoUnR9fYzpxEc3G1IDRxSLjrYDPtaXisD0r0CqOkxLKv4juCjfFakoGUqRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for adding a physical swap backend for vswap, make the
swap IO path able to submit IO for a swap entry other than folio->swap.

swap_add_folio() and __swap_writepage() derive the target device and
sector from folio->swap. For a vswap folio backed by a physical slot
that entry is virtual, so it identifies neither the backing device nor
the sector to submit IO against.

Compute the sector from an explicit entry (swap_folio_sector becomes
swap_entry_sector), thread that entry through swap_add_folio,
__swap_writepage and ops->can_merge, and stash it in swap_iocb so the
submit path addresses the IO from it rather than from folio->swap.

This lets the batching path serve both vswap entries (backed by a
physical slot) and physical entries mapped directly into PTEs.

All callers pass folio->swap for now, so there is no functional change.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  2 +-
 mm/page_io.c         | 51 ++++++++++++++++++++++----------------------
 mm/swap.h            |  7 +++---
 mm/swapfile.c        |  6 +++---
 mm/zswap.c           |  2 +-
 5 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a955bd60dd58..8359134d08cb 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -389,7 +389,7 @@ extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
-sector_t swap_folio_sector(struct folio *folio);
+sector_t swap_entry_sector(swp_entry_t entry);
 
 /*
  * If there is an existing swap slot reference (swap entry) and the caller
diff --git a/mm/page_io.c b/mm/page_io.c
index b1894cd014b3..5c780bda92bb 100644
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
@@ -326,6 +326,7 @@ struct swap_iocb {
 	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
 	int			nr_bvecs;
 	int			len;
+	swp_entry_t		entry;	/* first slot in the batch; addresses the IO */
 };
 static mempool_t *sio_pool;
 
@@ -343,24 +344,22 @@ int sio_pool_init(void)
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
@@ -373,6 +372,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
+		sio->entry = phys;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
@@ -384,7 +384,8 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
@@ -400,7 +401,7 @@ void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	swap_add_folio(ctx, folio, WRITE);
+	swap_add_folio(ctx, folio, phys, WRITE);
 }
 
 /*
@@ -504,7 +505,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, READ);
+	swap_add_folio(ctx, folio, folio->swap, READ);
 
 finish:
 	if (workingset) {
@@ -617,7 +618,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
@@ -637,7 +638,7 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_READ);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		/*
@@ -655,13 +656,14 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
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
@@ -679,7 +681,7 @@ static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
 	int ret;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
-	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	sio->iocb.ki_pos = swap_dev_pos(sio->entry);
 	if (rw == WRITE)
 		sio->iocb.ki_complete = swap_fs_write_complete;
 	else
@@ -702,11 +704,10 @@ static void swap_fs_submit_read(struct swap_io_ctx *ctx)
 	swap_fs_submit(ctx, READ);
 }
 
-static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw)
+static bool swap_fs_can_merge(struct folio *folio, swp_entry_t phys,
+		struct swap_iocb *sio, int rw)
 {
-	return swap_dev_pos(folio->swap) ==
-		swap_dev_pos(prev_folio->swap) + prev_folio_size;
+	return swap_dev_pos(phys) == swap_dev_pos(sio->entry) + sio->len;
 }
 
 static const struct swap_ops swap_fs_ops = {
diff --git a/mm/swap.h b/mm/swap.h
index d241e81e967e..88ca9be71b7e 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -103,8 +103,8 @@ struct swap_io_ctx {
 struct swap_ops {
 	unsigned int		flags;
 
-	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
-			size_t prev_folio_size, int rw);
+	bool (*can_merge)(struct folio *folio, swp_entry_t phys,
+			struct swap_iocb *sio, int rw);
 	void (*submit_write)(struct swap_io_ctx *ctx);
 	void (*submit_read)(struct swap_io_ctx *ctx);
 };
@@ -313,7 +313,8 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a26cfe5751c8..b8fdb426514c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -355,14 +355,14 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
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
index e19bde9df722..789079c3945b 100644
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


