Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8BB60A3813
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=I3YMzTa0
Received: by kanga.kvack.org (Postfix)
	id 0A1C26B0602; Wed, 21 Oct 2026 02:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C136B0604; Wed, 21 Oct 2026 02:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D346B0605; Wed, 21 Oct 2026 02:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B42596B0602
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:03:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EF7A1A02B0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:39 +0000 (UTC)
X-FDA: 85345591758.16.7C45DCA
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 77822C0004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I3YMzTa0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNeuvlXkDtmzEanbiS7+cKjYAzmaJIW02TKw/krsK3M=;
	b=QLgrvoZ8QxwfjpwoqY8A8wmZqFQVx3jKSOYF20L5IaNBoYNxvwQrcUHkbEubZYBdKf4eTJ
	8HdRuQ5UdHMPQlrA9Q5v0TvFAiQwD7aDvsGMI01kL2Yf5XtEuhVJ6eGRd0uvZW6/jbw7/w
	vNT1LzwWMxcXgvQcMohplS9hNeJDpmQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I3YMzTa0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562617;
	b=sz5aj4iQeEbR41QmqRESvyNmbaTkDLISVxce7srtbC6Q/Rsz1EL9yY/lD0eGJhrbCn5fWY
	lHq0wIDDw/SPr6jEQloZ8AtyW3nKo6PR3nJDluODTG6Yl3rSZdkbDih5BERGV78XOTHaye
	mgQY+NgzWRCT0BcLkajvUYKTqcn8XUY=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8ab432273c5so2976467b3.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562616; x=1793167416; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNeuvlXkDtmzEanbiS7+cKjYAzmaJIW02TKw/krsK3M=;
        b=I3YMzTa0zR2si26YgxnPC/AjmAPo17wlw66WuwiJyOGCXTTwjHZaSpubpkv/N2jD0r
         +m9CntFElo8zgP2LyIQYKbdSIysv0QKVwmRxbyqN8/zA5YEH66yxY4ZIhwQLzeFKXZGw
         Jkq49O36NzyqyzK92eOwYZZPM7Tztc1b8xBzy1wbipzoA+sJ3YhhN/4HQ3ZOWxNodC1E
         ypGoSosHSXR5dVapnVQN4B9dl5BOjjdYmHbDrkHG3ogV1RYcsoa7NV2JIWiVYWpEN1b2
         oKLjpXcTNBzVLpfXxOprfMlQXZ0N6tw8t6jn6bAT3yfF3zoCzjMD0fDpJw4ffCKJK4oF
         IhCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562616; x=1793167416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNeuvlXkDtmzEanbiS7+cKjYAzmaJIW02TKw/krsK3M=;
        b=Htl5g9TKZCXckLqp0SaFCJ8BxYVMnHtxmNrywCNg2nohFqwCFOYMZPDwWLILGQ5B/i
         2i7AiPqhbSf7d1hz+gcXSRB7sCBO645bqJQyTY3ZmujRhuZr4JMjjgR3drUvINqFRHaU
         5zsoy/sdWbAnjhWTFtFNP5LHlH6ylg12V2E7wyHv7m7AcXrBea16i55DjnuRuT1IEG3w
         AMenBHM+8zJYzLpusFprPL0uWDNHlXnrESXQu0SLstiEawzhiyWE2IfcftZRFrX2MCqk
         OcTlUIfvsLcJmt1ICMKWHzOd+x+VIXUupORDXrSV5ZYPTQuSC+g5HTlTdZaxLWcF/teK
         cqrA==
X-Forwarded-Encrypted: i=1; AKwUvBxOrBar8/2xd/JD6YIUUyyt6dAg5/7bFYzMwfry0BzVL8/NsS9XfKb58B2N8ywvWHBcLio/QOo95A==@kvack.org
X-Gm-Message-State: AFq9FYLnsR5HEEECpi4ep48mViLk9Iji9kV/w4Ujub45SEnObqddsIYT
	tPDDT7QtjFX1BvFuzztehHhWsHLjX4oOC9l+KNyXq1U2H3DUevk4gqrn
X-Gm-Gg: AYBFou2IW6Cu5SN+J1JydwY0lWyCl3aSfrkJ7LV1WJtNuUIZVpUpkHagn1F78eoSCx6
	e4uO6cx3F96aNIdmDHKxJtZKsZDKIKq8C3CTKAxIp6hPrv0WolkzxnkQb77zrU10cemrig8CtjY
	XABqrICaahLZd5W8K9Nb/cu4f9pQAmABiHzDuIb8TaqwmUNiL3hblP6qaeFiWQ+WnH8wzTbMbdF
	txa+UNFFWeycD4/iUkL2j3St8Fy3gbYJFm8w1L30Ih/c1363kNGJ4PP1Y3xa+iaROVgKJcwld6q
	5K0oW/BcPCO0MA8bm/J6tNzYYEALyJ3NL/4PeVqwfNebOoPeOBf5zKFfNzTOgI1JRDjHqpgH4u9
	XoQePC2dl2USXGmaR6BWuttNYN0NRAZBigsQJGFPcaSx1V7+j3LWtwdqBFJuPhJXC2OEWbEHtV2
	6tghUWRa9sFxGwkBowaZN1jd4+ZjjguYSp9I9h58LOilR7LIcgv7em7GOQ5OeoiXKND4WN4u5o/
	R24pgG/bmfUhkrBrR+I4gGxZwed8yiOaKNDB7X94u0YCn+GvCHDDlKnXTjqY/x42StKsCvXbRy3
	WwSQbEfG5ODwUdBXOTgXi7iOcETWeTnvkd9UiC3dpkvIbLv2hqdbq08Pnx9jbtLp
X-Received: by 2002:a05:690c:e3c3:b0:8af:1843:a9e5 with SMTP id 00721157ae682-8b133d0636bmr5788747b3.23.1792562616594;
        Tue, 20 Oct 2026 23:03:36 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300c85c9sm7295167b3.23.2026.10.20.23.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:03:34 -0700 (PDT)
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
	rdunlap@infradead.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 03/12] mm, swap: prepare the swap IO path for vswap
Date: Tue, 20 Oct 2026 23:03:14 -0700
Message-ID: <20261021060323.553433-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 77822C0004
X-Rspam-User: 
X-Stat-Signature: ogm73fdr1mdgjsde3s4octfowsg93ow5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792562617-386764
X-HE-Meta: U2FsdGVkX1/G7oh8utb0gBVocNvZRN+rk+kcKx0SoKheuCkndXian8JzYtCqrytKhEg5P430g+NUl5mKORspie86Z7drg7n9IUb4YTzbktLU6+mIZ8LA5mUxDSvm/glpArGwANQdYL/GEpt79MVAbnErXD/sdEQ9jNo2BmJB1clYLgAXWGJT04GmsUSFhrJVW8BYtfQYTEOjZwImx1YZZespJx+vdUvHj8GU2S6ZNrkFM8+g88WiPsXp+FYgICytpSKtAQoS/AbVROCcwGTFO/XNj2K1nRnM19PZVHWgXn4vOVYlM1JoMc0pwJheP06growXccmQ6SRdH+IMJll3TS7rU4fPxQYxqlHRtY84UERfKEHDT5FxwUHSsRt6bdVvwTfhAR8iWrbvFm1HGjUC4tYZXGEYwQuy+KscTZf8KzElN2NtyCVydTyVIOI5xF2XCjL2mxp8XM95oU21xdWpwh6/jZeKjq/4quLNElI88mB5mZapakiAhj7ajTtLRW1wAApdx7K1pGleFzQ7xyMacvZfevWYWRdIwvMhOAAwhvxygW9jlmsRJ5O9GokohLO4sO9/0DPgCxSF0eSpzlPxN/NQ+B3eAzPbCuxW6Ixca/TuatsCe/NN06hVwglojwvKTVYUiptYLZ/RmyDZgoEChEMHBkzdCgBhqXURO7hnAyg8vrXs/JY1eqThvwURcBr12xjpz0LRy61kB4scNwuI7jv40H3XmQmIdAcsLNKx6lyH9zdzSMIgWKhUCNj2ZriMWIWrvzb6jwDUgao50JhB3BaSkjioMAhUX46gG358Xa2356a+5YPdxdRp5ntz5xYsNue6YuQATABbnBVScBpmRM+ze+v+y2wQa3DabMiwyNZcl6mZ5vepplL7c0hxdhtKGtd0w0xeGs0G1N4pDhbn8MwW2CaHX/8qJBY70BSUKwgdCQTfTFFFaMMH/dEOpQGM1aAq6GtyMBaAjhxNyxR
 46bzOhua
 LCKY64YGaY+VVlii78eyYbHWT5QOz0f63qo7UMq34eDIfjVtsmqwl9HdASShIIn+NzaAQzEDlzi4V6Fvws1W9qo2BPsuXo1LEk9u/L/1A7oq5Z2MP7w8W3C0mPNWmEjARonn4xsZ2H7sHc7Dx7sr+LDVewKysnmywxLCsflmLrE9egFMM45jkhG8fic3llMG7Jz/Be/f4cdEyMTWg1gzzXFjX41ORMxsQgJdXlVksL2RKQ6L+NLovTmDxxtqhhctwVUDoKAYfcZ0jz0oezaDTWczHR5vyMB/SXuScYVA8aKfASdKpRG49nGepIorkBBJ496EGDECvOotlIaw4PHk4AUuTEb8pQ58RgSkf/rQdOkMId3PnceW3e22dNd1w4eSxntbNR2ygt+gVa+x0G6Bl26QZHU36BSHa5iI5sJE7lS1WbMgiBbq+OZY7lDkiCSDRhZjXPcd8LhrN5Y1cDuhDFXE1TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Carry reclaim's NOFS restriction in the I/O context. A subsequent patch
uses it when zswap_store() fails and writeout falls back to physical swap.

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
 include/linux/swap_ops.h | 10 +++++---
 mm/page_io.c             | 54 +++++++++++++++++++---------------------
 mm/swap.h                |  3 ++-
 mm/swapfile.c            |  6 ++---
 mm/vmscan.c              |  4 ++-
 mm/zswap.c               |  2 +-
 7 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1479914d545d..4066d99f896e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -414,7 +414,7 @@ extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
-sector_t swap_folio_sector(struct folio *folio);
+sector_t swap_entry_sector(swp_entry_t entry);
 
 /*
  * If there is an existing swap slot reference (swap entry) and the caller
diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 57ac6c703f68..1c65e346e127 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -12,11 +12,13 @@ struct swap_iocb {
 	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
 	int			nr_bvecs;
 	int			len;
+	swp_entry_t		entry;	/* first slot in the batch; addresses the IO */
 };
 
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
 	struct swap_info_struct	*sis;
+	bool			nofs;
 };
 
 /*
@@ -30,15 +32,15 @@ struct swap_io_ctx {
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
index f849c285ba22..61bb5c6e9759 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -263,7 +263,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writeout(ctx, folio);
+	__swap_writeout(ctx, folio, folio->swap);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -338,24 +338,22 @@ int sio_pool_init(void)
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
@@ -368,6 +366,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
+		sio->entry = phys;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
@@ -388,7 +387,8 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
@@ -404,7 +404,7 @@ void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	swap_add_folio(ctx, folio, WRITE);
+	swap_add_folio(ctx, folio, phys, WRITE);
 }
 
 /*
@@ -508,7 +508,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, READ);
+	swap_add_folio(ctx, folio, folio->swap, READ);
 
 finish:
 	if (workingset) {
@@ -540,8 +540,6 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct folio *folio = bvec_folio(&sio->bvecs[0]);
-
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
@@ -549,7 +547,7 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(folio->swap));
+				   ret, swap_dev_pos(sio->entry));
 	}
 
 	swap_write_end(sio, failed);
@@ -621,7 +619,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
@@ -650,7 +648,7 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_READ);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		/*
@@ -668,13 +666,14 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
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
@@ -690,7 +689,7 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 	struct swap_iocb *sio = ctx->sio;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
-	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	sio->iocb.ki_pos = swap_dev_pos(sio->entry);
 	if (rw == WRITE)
 		sio->iocb.ki_complete = swap_fs_write_complete;
 	else
@@ -701,11 +700,10 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
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
index d0e7c991a4c0..b0a092b47fce 100644
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
index 81ac45b4856e..69fac2d905a4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -341,14 +341,14 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
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
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4c5f0f97c1c7..b9c5e92757f3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1172,7 +1172,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
-	struct swap_io_ctx ctx = {};
+	struct swap_io_ctx ctx = {
+		.nofs = !(sc->gfp_mask & __GFP_FS),
+	};
 
 	folio_batch_init(&free_folios);
 	memset(stat, 0, sizeof(*stat));
diff --git a/mm/zswap.c b/mm/zswap.c
index 1ba191cbc26f..73c6b82aa593 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1159,7 +1159,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_put(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio);
+	__swap_writeout(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 	return 0;
-- 
2.53.0-Meta


