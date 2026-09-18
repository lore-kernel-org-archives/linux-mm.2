Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F45EC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38E56B0093; Fri, 18 Sep 2026 14:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11DE6B0095; Fri, 18 Sep 2026 14:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFFB76B0096; Fri, 18 Sep 2026 14:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B56496B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:02:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F3561A072E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:51 +0000 (UTC)
X-FDA: 85227653742.09.281C345
Received: from mail-oo2-f39.google.com (mail-oo2-f39.google.com [74.125.231.167])
	by imf30.hostedemail.com (Postfix) with ESMTP id CCBC880007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RZd7G2kL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.167 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789754569;
	b=j6eLLDsHPu6dlH+tfjvIjNJU27bPgrIc7arRaXBis2hGqhKl+fnkS1yP1nqNgXM6wQogAN
	SjAFRFfqj1RIuBE6z23U2BOe54vdes/fjIrt6HiyGVwUjVnDZHoSKuPyeZgRAcl7HHHVEY
	D/BK+URIaUI7WKqw/B6Y4F21cPiRA20=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RZd7G2kL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.167 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789754569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ku1DiWNPMjUzjw3oBYfS28zIvxt+bdOecf2pjvKy8dE=;
	b=aFS5mRmDOeUHhznxwZthLDrDoqWicDF46hOc6yHYtdhDaXvRlMVIGLpk/7bwjJnqpPEjF3
	kzPk2hAL/N9uJ88eUClwhl9Nacf6n3jjGTSHMlP2JxKG5xYcudlvoSC7Kh5Fp/0f+nVwLN
	8iRhYrL0q8mQUhuAqf+U21AMMat48ew=
Received: by mail-oo2-f39.google.com with SMTP id 006d021491bc7-6c72bd8a017so662089eaf.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754569; x=1790359369; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ku1DiWNPMjUzjw3oBYfS28zIvxt+bdOecf2pjvKy8dE=;
        b=RZd7G2kLBRkjdI1cX8vXhE4sY3kCKIuorydTCGSOj7INU3lorqaQzDHm5GetyU6Dny
         CgUVczhVOxVTQVAXqmg1L5LM0uWgFL5lWEgZpyYRITH7OZ2gxS74OW9ok6Y6Gv1JdVhH
         m3Bkif1GlFqtJMH8CEE7p9/WaP/JEq0zCdf8hrV9Xg3oTyTuYiiKKbmV3TNwraVG4LsR
         818GPb07oC+2ybdjbkP9adXg1b55M5cU+lRrn1rn9qpYDWdnzDOTEffgcoyARA+ddaMR
         1lCA64Cl3WA/GZBhhWRP5mRVmneSsOna54QKOD8RZSUTXWbBogM6do/uxEvBf9Vhryf9
         z6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754569; x=1790359369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ku1DiWNPMjUzjw3oBYfS28zIvxt+bdOecf2pjvKy8dE=;
        b=sFGdgGkQVVNhRj/F6MwTQ5FyhEcAD+oXZRiqwMbvdepJI4EonvTL+z3F1R2X+UKXNM
         yylZCAOkiRTc3KN3/iKcVhEjvPbY55h7qN3ercZo5qzHS0/Nd941BiCIbr9ikomVT9oG
         WH8qE65huHyPZYvgGLNOWhId3rFpRaE+MwzNMFoJsQGT6oXp+ER+cYsMQCcA8fBep+X1
         gNpJas29tmrt5H00v9A6og7I5GuAOdG9OCzzEN0OxUGdct18tUucSdnH+jG2UbXdcVyA
         hImWfoqFBbzE7l2JnHzyGdnBHU2X+28nUwZxR/D6Bazcp4dY4tjiR49FSAkkAUll/FmS
         ckSw==
X-Forwarded-Encrypted: i=1; AKwUvByHBGAMQzVmyu2+Xe0V00WlvoFQdYXPdxlOifb9uFWsbGrv4a/m7/hnKlx0RsVOpkigXDN+Zicl6A==@kvack.org
X-Gm-Message-State: AFuF++njVcv8torgbI6D/BIlluzcoXhPaq+3fFWFvur2aNgCUNKQ6Q1v
	b38chQHBLeRp06gIhtblamhXeJiTdy5rLpS63YLqlcNbckjX7zHic/By
X-Gm-Gg: AYBFou3pQvs1+diXy7wDghf6gemO8zVjcOkCbOPoOBD5xeH2PhUP2Q7/miNVJb8JuaR
	LnGppgJD6uP2RphWoGcLQBFrOc7O6YOZf/a9vVJT5Fkajjd3mG4x3zLI5F61bKbp9CWwCToqnUO
	wYkFhEyxQcvj6SOM0o6u54DJ2z7W7SjbV16qQp08hZoE5TwA+6SNmLVrUP3hyQKxgSilhcKqMLR
	mMrnXPTGUben1mCsgD2EIMo6El16pXjUgzg6Mo5aByIKWGTkM6v36UENnee0XNxNkcl6xGkIPV6
	Bt/tZtMC+hAMM9jQme/s6c0U1VP5QzG1iQZ/im58CersgwGFT9ZzKR8EAx4OKISMzOgo0VE/rjc
	doVAyLTrfC9j7JoGR+WjP912LvyhjUrF7jwO+m25ARLrvfTQ8U8Kr0rylxLUuYpztCMwBC2f5cj
	8UcmRCXw/k0wHcVUp0ozdWKvh+j0D7wLb0ZGqZXGeHLI4HZyo2pu9Yujs+zR3ra28OPLLdc/uiz
	m4P60nHujWYMoEdSbO7sA==
X-Received: by 2002:a05:6820:f007:b0:6b7:83d6:292a with SMTP id 006d021491bc7-6ca9cb53b30mr3234729eaf.45.1789754568673;
        Fri, 18 Sep 2026 11:02:48 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:11::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6cd3591d0b6sm565054eaf.12.2026.09.18.11.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:47 -0700 (PDT)
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
Subject: [PATCH v5 03/11] mm, swap: prepare the swap IO path for vswap
Date: Fri, 18 Sep 2026 11:02:33 -0700
Message-ID: <20260918180241.3424851-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CCBC880007
X-Stat-Signature: pmwjt7z8f4tbbwpxzxmd41thj3ymhigo
X-HE-Tag: 1789754569-480534
X-HE-Meta: U2FsdGVkX18H++YQBLXcHw5+DAs4onu3RCvlqaL4GKiYM0t3kXeXRiYlFsfQrMgCmMW460TUU7Uumo0t0dM5qOEDBIxOtrw0HCKd5N1Zo3yjNQ96hF3kErp/k5XSh67tS9deYwR5jDTkXf24kEG3rOiXBdRV/hqtMDORvy3F27irZCWAvWqmtsMNQmhr7HVExm2LC+lCTrDErPuG5AfEmqYEkNqqNCHIY+Q9VPkjFAPa+K9L+4XlZw3ku2tEkxK/AKlsZSG8B+NZhUlYruyB4Y5pDjgLc8cW72gLMZwvOqocQ7D87XQzuyl9v8I2fQiCnQncGeY8XnWkI3faqjtAppmIH8erAlcmr4hAeEdEYPAcWkDMTyoHavJ+d0NOntk5OuLcWZbUOMVpqeV7g/E/sz38GFM83P3xooXaGxtH/9s/u0q295uBuwoXyTutoYcjSv58LlAE+BP1cGuKa9/Bgnr/S+RVISog9tpeXZbQ3xd6RSP0t9QHs5CtON1ESLVSfPj8KwKaK718rwsqguof26z/WVcP5IHMUZ5UKdf68gkLj9l8MYnJROvaaBL6Vml0lZ70kpDnIEZVwzJLWdJeMiEWUJsm6zauXdU9CoW9mXSRHRUfG5bRkTjI40D43L8Kocv7OidhC+sjHi9sZBrvgwqv3wjmH2ArkWSqeY0TgB06YZO9C1eVCqGh9GfWcuHrfThgTO00s4ZB/BZ59JNT8OSm1sHHYbw5q2mLWfwf2UsC3j/HCeHlw7ggQlSOdbRJ7up8zkgHZmSHfMEE1qKQWJr/tct2L2Z7om8vL9MXXJqqWW7vrvaKax75/gcKriZl5SCK64p0ijx5SLw5Oe0ZFjPAPfvwy8YXdnfd8Th86974GH2nlgVX76sZYBaieHmLyUE+ogPhLR3bqXkBd8E6We89nVkTKkDL0egDKlQWvmF+hH4Idt0PcwhW3J+9sBA7CnzbkDkGk9res9bxU40
 SIUFUNuR
 zGo+kCMhzq75N/RhqInMQb0w25AOpbeKuhgcfN3iLP5qAowyfYoVImNzcyk/hwX9+Vf1l6dE/0snlcOnA9El9qOaAsKq/9rLdecfcGbqu2PIfjOUGYkFjy5Dq4/+OtqyL9jvOUsSS9eRC7w+Cggynyya0agH/Hzj9an0xcOsNFAEMoWCMeEDovlMpQ0ds24FSTzP9bazd/CfqujtVQbZxwq9k0g4rnsMKREOZsVIQmiX1oeroWMEZ6BwRBm3znv68vaheKiV2YPJBqO/lySLq+oSneTBPXFlMPpzXjpGHgPkpLf2pKKU39wC+c5VoaH7VuLW1qClxw8bHoL6A/Hc3D5vb4I7ccvpo+tVBkRc0K6PKKOW+d3XSRs8gSF4UuF1zopZuoSQb/rhcnQ12s9naWvdkstUe7jnLKVE77+Ot+rDXdqKJWQqouqbkg1ouo8SE5uZAco0GH37Wd6rZAR0D0nCO2g==
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
__swap_writeout and ops->can_merge, and stash it in swap_iocb so the
submit and completion paths address the IO from it rather than from
folio->swap.

This lets the batching path serve both vswap entries (backed by a
physical slot) and physical entries mapped directly into PTEs.

ops->can_merge changes anchor with it: swap_bdev_can_merge() compares
sectors and swap_fs_can_merge() byte offsets, and both now measure from the
batch head plus the accumulated length instead of from the previous folio
plus its size. The two agree at every step, since a batch only grows
through merges that passed the same test. The blkg comparison is unchanged
and still anchors on the last folio in the batch.

All callers pass folio->swap, so there is no functional change.

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
index abf658f7861f..5ab050b2457c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -409,7 +409,7 @@ extern int __swap_count(swp_entry_t entry);
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
index 2e7fb335eb01..632683232622 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -265,7 +265,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writeout(ctx, folio);
+	__swap_writeout(ctx, folio, folio->swap);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -336,24 +336,22 @@ int sio_pool_init(void)
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
@@ -366,6 +364,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
+		sio->entry = phys;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
@@ -386,7 +385,8 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
@@ -402,7 +402,7 @@ void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	swap_add_folio(ctx, folio, WRITE);
+	swap_add_folio(ctx, folio, phys, WRITE);
 }
 
 /*
@@ -506,7 +506,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, READ);
+	swap_add_folio(ctx, folio, folio->swap, READ);
 
 finish:
 	if (workingset) {
@@ -538,8 +538,6 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct folio *folio = bvec_folio(&sio->bvecs[0]);
-
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
@@ -547,7 +545,7 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(folio->swap));
+				   ret, swap_dev_pos(sio->entry));
 	}
 
 	swap_write_end(sio, failed);
@@ -619,7 +617,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
@@ -639,7 +637,7 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_READ);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		/*
@@ -657,13 +655,14 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
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
@@ -679,7 +678,7 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 	struct swap_iocb *sio = ctx->sio;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
-	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	sio->iocb.ki_pos = swap_dev_pos(sio->entry);
 	if (rw == WRITE)
 		sio->iocb.ki_complete = swap_fs_write_complete;
 	else
@@ -690,11 +689,10 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
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
index 81e47dc36a02..df323d5e8da8 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -320,7 +320,8 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 67a2399cf1ae..af6a162c4450 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -342,14 +342,14 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
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
index 3466c80ac188..c2430dbfc653 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1094,7 +1094,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio);
+	__swap_writeout(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 out:
-- 
2.53.0-Meta


