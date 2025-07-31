Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EEAC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 06:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A86D6B0092; Thu, 31 Jul 2025 02:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A7B6B0093; Thu, 31 Jul 2025 02:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3296B0095; Thu, 31 Jul 2025 02:51:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 113346B0092
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:51:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5BF3160615
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:51:04 +0000 (UTC)
X-FDA: 83723637648.17.412BFD1
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1208E180002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:51:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xVDHxDHQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3VRKLaAoKCPAjaUZSjVqUUYggYdW.Ugedafmp-eecnSUc.gjY@flex--richardycc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3VRKLaAoKCPAjaUZSjVqUUYggYdW.Ugedafmp-eecnSUc.gjY@flex--richardycc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753944663; a=rsa-sha256;
	cv=none;
	b=d7s/UiZdRc8C57Aw5IlzvcmZZo62oQ7ebWNeZR0n3Tfq841nlfrnKC0EXdVueRXYV5io9T
	qc3KkTiBEpFPnRrJBd05NQ/ThoFQvuT5A8OqXuBgn7GF8Yxv9L1OkoSCZ5glUNd3AmSRp6
	jik1VCAIqaruVCmNM9eOJZ75JsL7tzo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xVDHxDHQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3VRKLaAoKCPAjaUZSjVqUUYggYdW.Ugedafmp-eecnSUc.gjY@flex--richardycc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3VRKLaAoKCPAjaUZSjVqUUYggYdW.Ugedafmp-eecnSUc.gjY@flex--richardycc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753944663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9HBBhNz4JX/02iQNqHxMkOYIhfKJVrRepRJjtX/gUI=;
	b=ElzgW1wJd5i0JmXLXaYx6cQGpejPjDyt4YNhT7A/NKy4rxmganGzR9G3Jca8fefiykDumD
	R+5EzX7AWHE9YH3uFasQ8YlfFnwKRHDdAXaQp88hmvmEjoL3L7Y054Nds3q8+0WIPpce9d
	jLtYpWhBGu1167YB9aBP8xhTvhu3slY=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b421b51c478so478658a12.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 23:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753944662; x=1754549462; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J9HBBhNz4JX/02iQNqHxMkOYIhfKJVrRepRJjtX/gUI=;
        b=xVDHxDHQK9AeUAZFQJXllLAsWmL4FykmCIivT0Ym5em0DvC82ToDUCDPLV5lm8CSNL
         kHpQtSbRnvlk+uwOtCZ7XD7XirXG2bEn7eQlb3Ch+GK/Dku+A7dato+jXEaUPxnXthl6
         ei15yBFbE7ArBLKcBxfbIr9slWD2SQnGZn0B1ms/T7njxYESWBqc0t2UKPcHD53AtKBl
         RMB/QqYjXuJICh1LeEsgcvpIt/E9Tmfx69R4R7B3QLuw1fN0nrwnCVzMbSXYIFBOCfIO
         wOCIOllELIUAJAKBw6l4Cvgs7rTGRaAekzXQA0A+bgki6S/LBLDl0MVOL7Z3Pgf0xYcl
         maXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753944662; x=1754549462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J9HBBhNz4JX/02iQNqHxMkOYIhfKJVrRepRJjtX/gUI=;
        b=mlpbTadopIBY+GqOQOxBq9kHe/KNUhz+AEJs9IKtsb8yCSh3k9HVjnT8g37ITTpVdM
         aPm7oS74h3brYH/p3v/7y+CjxZWjKrJAQbyOKwvTTyDrpt89miZMP9w9HDNfg90436mM
         UkDHCxkTo4sW6XzrjmX0VBk2PVNo7VN+w0lWwfVu/liXN92GHgsOVbEpp4OW0zzLKDmE
         7oE2/CJxy/najdEPvq35aYVAB5l8740l4aCAqZPuO8G5nabnfyudDKE1fibxVNMJ/Sli
         OCLwUbpxCbzWNXCvg8tnFdIkVhrOdMhAu/RNMaNYgecdsZOZhdooqtsKBgdCNYuaj3ak
         AXug==
X-Forwarded-Encrypted: i=1; AJvYcCV22tcAmbbSLMnIn4HxuiztigDqIqRbOgSM4XT8f2koeli0sjSWKBBGB4lIu9NOkGXZ23tUgtA3UQ==@kvack.org
X-Gm-Message-State: AOJu0Yyh9pMtr0fc+Aq5CEvLi+7kne7s5TRsV10yKdDCHtxA2iIJkpsD
	/FEcwFCle53JLjpJwq6hNq3LST2TscCFE5MRu9wIV7VO3wxcRcJY13WQ2hsY8NzxlqsVARePaT7
	8bNJhXxuf605mWcASwIXd
X-Google-Smtp-Source: AGHT+IHwD0DQee4gELDZbn1uwpxGmpeIotkHWXAUCxbVBgG5s7/AREeRYCR5fiI/9tCEtbg+9OUAskPwVsXk7or5
X-Received: from pgbfq19.prod.google.com ([2002:a05:6a02:2993:b0:b1f:fd39:8314])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:4322:b0:231:e2e:95e4 with SMTP id adf61e73a8af0-23dc0d57f48mr10285018637.16.1753944661925;
 Wed, 30 Jul 2025 23:51:01 -0700 (PDT)
Date: Thu, 31 Jul 2025 06:49:49 +0000
In-Reply-To: <20250731064949.1690732-1-richardycc@google.com>
Mime-Version: 1.0
References: <20250731064949.1690732-1-richardycc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731064949.1690732-4-richardycc@google.com>
Subject: [PATCH v2 3/3] zram: enable asynchronous writeback
From: Richard Chang <richardycc@google.com>
To: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Cc: bgeffon@google.com, liumartin@google.com, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Richard Chang <richardycc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1208E180002
X-Stat-Signature: 73tdp7sfzhxwum3kt7ah7k43jgzg1oa7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753944662-610547
X-HE-Meta: U2FsdGVkX18WTfZwoUA+ajD0SnUwUQBFK7DbHrdS2T86YM2EBwpeZUXgZ3sCrCC+J+Au7iZUHMb8iQZjyqPK97EAajz9hVnr16BvEPLl6Z8iUoBeSzbnYVwPjsYdCVDt6e2Fk4I9J6TS9xVIWK3aRNc4tmCOYs09WtnAvboa/y6hPKNxj7h+KbkOeQ8YHgkktxgFd0JwIXNeE4j0apOjh0YOzNknvxj4zR23R8udAbwJEsRAt+wbkV5R+2GoVXzPnuY358g/LR0tx6glXAiu92Y/FsXdiNYC9KhjN9rpJvUFHnA8TS7nFhnH+2PCeqUwOOhz7sL5fk+l/JXbdUbxZLXG7SjK4JnCJ2EEt9soKAvnSruj54pHvwStyYanFzpA4qOiCIYm07aRJmPEQz/z+RP5RbYGC83LIiPs4lGRoNvGIMLtKGONzGGg2aC3NCZ9i2sOLKv6jx/T+jGBLEhloVXjMu+ByY2oowcTk8ZuvXhz+eJl0Cw/uhHFPIC1EEBZd2Ri25AOKfVVQUaPvJU+SuVtX8hoiqm9/YIULFe+yElH/4PVmqXTZoacuHo1XMGkbyd/Qm7XbmUb3YeXvJ7P1vp4orqiz6u1x9S5iEVY093gV+m+xhdD3lZ8nK9rqE+DKWYjsABN36oLcZzLICdP9UIBCX4TFyQypMywmuxZiYSze+YRkRBwhlstjsbT6zqLwCk2IABBxfROCWQkncCl868H1euydFUK6g92hyXczaShpPSC8ZYn/bIOZdnHTI4S1epcowNmfC+5dKi72rjQH3v0n5gexzI/p/nOAXmHQQMRn+BYhcmwvpQZvchMREK68gk6uA/l3JOjSgl+VBqrkTr1eizv7Hbum9trsJ4CxkOqksoOFnoOJlU9lMBjhxzsRX1wpqT3+vMURq5IhWwwhhUZ3geLYxg0IO9bUELchC9GmspsY930mHgR323Nw2rf1jAOnoPa1x7GkiF2MBm
 +KmaJmgR
 ATCEV7dmVpeQ0JMKPchX6l7hAAUsuW2+khcEzAUQWt55fxmstvWsQAzOwF6tgeswq36n/ce0fEyHF9nXuoRw5CI9YNapGwKgwMrWRHSy76L/+yY/MLVmloSGme8q69Oww4811SoF94HTuUK9pBi8iYXh7RSchyJAWu/nTfv41lZdLPrANxMHT+1d1slt4SGBWPHrKWyldnHFXZihMCDih4yf2/o6LVPpVQngFBZ/WTe5Zjf71kjWqe2JztL2r6oj9wRVE89c9pHNHRwFv73Va+Xp3ZBhDvH+oGrst20meXys737+Crz1qr/IViDbH60/Ecdf/5yzrvmTtT2UHp81W9ASF8FkLWINZlStob9M43EHqwqDtJa+kdPgcZSc8gBeoZpOyv+22SaVAQY3+kfOwHtuhatoZTIzgEzOnv/qMkifWN+i8pZgGhGo5YJyzM/utAzNAg3yZSHZZ3A/cEKKkhqPDOrqAkPO8cBF5vJJ1c/eqoDdS1nS6/zwI7OQKYaluMt3FY4Z5Ym2cOQCKq3er6qvUfoZPovHmFr/l/XJJivWc9PDqkBuMhnhLSaDSjawVb+d8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the synchronous `submit_bio_wait()` with the non-blocking
`submit_bio()` to perform writeback operations asynchronously. This
leverages the infrastructure added in the previous commit to handle
the completion of I/O operations in a dedicated kthread.

This change shows 27% speed improvement of idle writeback on Android
platform.

Test Flow:
- mkfs on the zram device, mount it
- cp three linux-6.16-rc2.tar.gz tarball files as the data
- do idle writeback
- check bd_stat writes 185072 pages

Test Result:
idle writeback for 185072 4k-pages (~723 MiB)
$ echo all > /sys/block/zram0/idle
$ time echo idle > /sys/block/zram0/writeback

Async writeback:
0m02.49s real     0m00.00s user     0m01.19s system
0m02.32s real     0m00.00s user     0m00.89s system
0m02.35s real     0m00.00s user     0m00.93s system
0m02.29s real     0m00.00s user     0m00.88s system

Sync writeback:
0m03.09s real     0m00.00s user     0m01.07s system
0m03.18s real     0m00.00s user     0m01.12s system
0m03.47s real     0m00.00s user     0m01.16s system
0m03.36s real     0m00.00s user     0m01.27s system

Signed-off-by: Richard Chang <richardycc@google.com>
---
 drivers/block/zram/zram_drv.c | 109 ++++++++++++++--------------------
 drivers/block/zram/zram_drv.h |  11 ++++
 drivers/block/zram/zram_wb.c  | 103 +++++++++++++++++++++++++++++++-
 drivers/block/zram/zram_wb.h  |   6 +-
 4 files changed, 161 insertions(+), 68 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 6098c0bb773c..f459d889fa44 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -57,7 +57,6 @@ static size_t huge_class_size;
 
 static const struct block_device_operations zram_devops;
 
-static void zram_free_page(struct zram *zram, size_t index);
 static int zram_read_from_zspool(struct zram *zram, struct page *page,
 				 u32 index);
 
@@ -96,7 +95,7 @@ static __must_check bool zram_slot_trylock(struct zram *zram, u32 index)
 	return false;
 }
 
-static void zram_slot_lock(struct zram *zram, u32 index)
+void zram_slot_lock(struct zram *zram, u32 index)
 {
 	unsigned long *lock = &zram->table[index].flags;
 
@@ -105,7 +104,7 @@ static void zram_slot_lock(struct zram *zram, u32 index)
 	lock_acquired(slot_dep_map(zram, index), _RET_IP_);
 }
 
-static void zram_slot_unlock(struct zram *zram, u32 index)
+void zram_slot_unlock(struct zram *zram, u32 index)
 {
 	unsigned long *lock = &zram->table[index].flags;
 
@@ -128,19 +127,17 @@ static unsigned long zram_get_handle(struct zram *zram, u32 index)
 	return zram->table[index].handle;
 }
 
-static void zram_set_handle(struct zram *zram, u32 index, unsigned long handle)
+void zram_set_handle(struct zram *zram, u32 index, unsigned long handle)
 {
 	zram->table[index].handle = handle;
 }
 
-static bool zram_test_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
+bool zram_test_flag(struct zram *zram, u32 index, enum zram_pageflags flag)
 {
 	return zram->table[index].flags & BIT(flag);
 }
 
-static void zram_set_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
+void zram_set_flag(struct zram *zram, u32 index, enum zram_pageflags flag)
 {
 	zram->table[index].flags |= BIT(flag);
 }
@@ -243,15 +240,20 @@ static struct zram_pp_ctl *init_pp_ctl(void)
 	if (!ctl)
 		return NULL;
 
+	init_completion(&ctl->all_done);
+	atomic_set(&ctl->num_pp_slots, 0);
 	for (idx = 0; idx < NUM_PP_BUCKETS; idx++)
 		INIT_LIST_HEAD(&ctl->pp_buckets[idx]);
 	return ctl;
 }
 
-static void release_pp_slot(struct zram *zram, struct zram_pp_slot *pps)
+static void remove_pp_slot_from_ctl(struct zram_pp_slot *pps)
 {
 	list_del_init(&pps->entry);
+}
 
+void free_pp_slot(struct zram *zram, struct zram_pp_slot *pps)
+{
 	zram_slot_lock(zram, pps->index);
 	zram_clear_flag(zram, pps->index, ZRAM_PP_SLOT);
 	zram_slot_unlock(zram, pps->index);
@@ -259,6 +261,12 @@ static void release_pp_slot(struct zram *zram, struct zram_pp_slot *pps)
 	kfree(pps);
 }
 
+static void release_pp_slot(struct zram *zram, struct zram_pp_slot *pps)
+{
+	remove_pp_slot_from_ctl(pps);
+	free_pp_slot(zram, pps);
+}
+
 static void release_pp_ctl(struct zram *zram, struct zram_pp_ctl *ctl)
 {
 	u32 idx;
@@ -297,6 +305,7 @@ static bool place_pp_slot(struct zram *zram, struct zram_pp_ctl *ctl,
 	list_add(&pps->entry, &ctl->pp_buckets[bid]);
 
 	zram_set_flag(zram, pps->index, ZRAM_PP_SLOT);
+	atomic_inc(&ctl->num_pp_slots);
 	return true;
 }
 
@@ -697,18 +706,18 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 {
 	unsigned long blk_idx = 0;
-	struct page *page = NULL;
 	struct zram_pp_slot *pps;
-	struct bio_vec bio_vec;
-	struct bio bio;
-	int ret = 0, err;
+	int ret = 0;
 	u32 index;
+	int nr_pps = atomic_read(&ctl->num_pp_slots);
 
-	page = alloc_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
+	if (!nr_pps)
+		return 0;
 
 	while ((pps = select_pp_slot(ctl))) {
+		struct zram_wb_request *req;
+		struct page *page;
+
 		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
 			spin_unlock(&zram->wb_limit_lock);
@@ -725,6 +734,13 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 			}
 		}
 
+		req = alloc_wb_request(zram, pps, ctl, blk_idx);
+		if (IS_ERR(req)) {
+			ret = PTR_ERR(req);
+			break;
+		}
+		page = bio_first_page_all(req->bio);
+
 		index = pps->index;
 		zram_slot_lock(zram, index);
 		/*
@@ -739,63 +755,28 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 			goto next;
 		zram_slot_unlock(zram, index);
 
-		bio_init(&bio, zram->bdev, &bio_vec, 1,
-			 REQ_OP_WRITE | REQ_SYNC);
-		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
-		__bio_add_page(&bio, page, PAGE_SIZE, 0);
-
-		/*
-		 * XXX: A single page IO would be inefficient for write
-		 * but it would be not bad as starter.
-		 */
-		err = submit_bio_wait(&bio);
-		if (err) {
-			release_pp_slot(zram, pps);
-			/*
-			 * BIO errors are not fatal, we continue and simply
-			 * attempt to writeback the remaining objects (pages).
-			 * At the same time we need to signal user-space that
-			 * some writes (at least one, but also could be all of
-			 * them) were not successful and we do so by returning
-			 * the most recent BIO error.
-			 */
-			ret = err;
-			continue;
-		}
-
-		atomic64_inc(&zram->stats.bd_writes);
-		zram_slot_lock(zram, index);
-		/*
-		 * Same as above, we release slot lock during writeback so
-		 * slot can change under us: slot_free() or slot_free() and
-		 * reallocation (zram_write_page()). In both cases slot loses
-		 * ZRAM_PP_SLOT flag. No concurrent post-processing can set
-		 * ZRAM_PP_SLOT on such slots until current post-processing
-		 * finishes.
-		 */
-		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
-			goto next;
-
-		zram_free_page(zram, index);
-		zram_set_flag(zram, index, ZRAM_WB);
-		zram_set_handle(zram, index, blk_idx);
+		nr_pps--;
+		remove_pp_slot_from_ctl(pps);
 		blk_idx = 0;
-		atomic64_inc(&zram->stats.pages_stored);
-		spin_lock(&zram->wb_limit_lock);
-		if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
-			zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
-		spin_unlock(&zram->wb_limit_lock);
+		submit_bio(req->bio);
+		continue;
+
 next:
 		zram_slot_unlock(zram, index);
 		release_pp_slot(zram, pps);
+		free_wb_request(req);
 
 		cond_resched();
 	}
 
 	if (blk_idx)
 		free_block_bdev(zram, blk_idx);
-	if (page)
-		__free_page(page);
+
+	if (nr_pps && atomic_sub_and_test(nr_pps, &ctl->num_pp_slots))
+		complete(&ctl->all_done);
+
+	/* wait until all async bios completed */
+	wait_for_completion(&ctl->all_done);
 
 	return ret;
 }
@@ -1579,7 +1560,7 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 	return true;
 }
 
-static void zram_free_page(struct zram *zram, size_t index)
+void zram_free_page(struct zram *zram, size_t index)
 {
 	unsigned long handle;
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 2c7bc05fb186..ab5ceecc8ed8 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -140,6 +140,13 @@ struct zram {
 	atomic_t pp_in_progress;
 };
 
+void zram_slot_lock(struct zram *zram, u32 index);
+void zram_slot_unlock(struct zram *zram, u32 index);
+void zram_set_handle(struct zram *zram, u32 index, unsigned long handle);
+bool zram_test_flag(struct zram *zram, u32 index, enum zram_pageflags flag);
+void zram_set_flag(struct zram *zram, u32 index, enum zram_pageflags flag);
+void zram_free_page(struct zram *zram, size_t index);
+
 #if defined CONFIG_ZRAM_WRITEBACK || defined CONFIG_ZRAM_MULTI_COMP
 struct zram_pp_slot {
 	unsigned long		index;
@@ -155,7 +162,11 @@ struct zram_pp_slot {
 
 struct zram_pp_ctl {
 	struct list_head	pp_buckets[NUM_PP_BUCKETS];
+	struct completion	all_done;
+	atomic_t		num_pp_slots;
 };
+
+void free_pp_slot(struct zram *zram, struct zram_pp_slot *pps);
 #endif
 
 #endif
diff --git a/drivers/block/zram/zram_wb.c b/drivers/block/zram/zram_wb.c
index 63a16dae5796..3b8edd048dcb 100644
--- a/drivers/block/zram/zram_wb.c
+++ b/drivers/block/zram/zram_wb.c
@@ -43,15 +43,60 @@ void free_block_bdev(struct zram *zram, unsigned long blk_idx)
 static void complete_wb_request(struct zram_wb_request *req)
 {
 	struct zram *zram = req->zram;
+	struct zram_pp_slot *pps = req->pps;
+	struct zram_pp_ctl *ctl = req->ppctl;
+	unsigned long index = pps->index;
 	unsigned long blk_idx = req->blk_idx;
+	struct bio *bio = req->bio;
+
+	if (bio->bi_status)
+		goto out_err;
+
+	atomic64_inc(&zram->stats.bd_writes);
+	zram_slot_lock(zram, index);
+
+	/*
+	 * We release slot lock during writeback so slot can change
+	 * under us: slot_free() or slot_free() and reallocation
+	 * (zram_write_page()). In both cases slot loses
+	 * ZRAM_PP_SLOT flag. No concurrent post-processing can set
+	 * ZRAM_PP_SLOT on such slots until current post-processing
+	 * finishes.
+	 */
+	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
+		zram_slot_unlock(zram, index);
+		goto out_err;
+	}
 
+	zram_free_page(zram, index);
+	zram_set_flag(zram, index, ZRAM_WB);
+	zram_set_handle(zram, index, blk_idx);
+	atomic64_inc(&zram->stats.pages_stored);
+	spin_lock(&zram->wb_limit_lock);
+	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
+		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
+	spin_unlock(&zram->wb_limit_lock);
+	zram_slot_unlock(zram, index);
+	goto end;
+
+out_err:
 	free_block_bdev(zram, blk_idx);
+end:
+	free_pp_slot(zram, pps);
 	free_wb_request(req);
+
+	if (atomic_dec_and_test(&ctl->num_pp_slots))
+		complete(&ctl->all_done);
 }
 
-void enqueue_wb_request(struct zram_wb_request_list *req_list,
-			struct zram_wb_request *req)
+static void enqueue_wb_request(struct zram_wb_request_list *req_list,
+			       struct zram_wb_request *req)
 {
+	/*
+	 * The enqueue path comes from softirq context:
+	 * blk_done_softirq -> bio_endio -> zram_writeback_end_io
+	 * Use spin_lock_bh for locking.
+	 */
 	spin_lock_bh(&req_list->lock);
 	list_add_tail(&req->node, &req_list->head);
 	req_list->count++;
@@ -83,6 +128,7 @@ static void destroy_wb_request_list(struct zram_wb_request_list *req_list)
 	while (!list_empty(&req_list->head)) {
 		req = dequeue_wb_request(req_list);
 		free_block_bdev(req->zram, req->blk_idx);
+		free_pp_slot(req->zram, req->pps);
 		free_wb_request(req);
 	}
 }
@@ -117,6 +163,59 @@ static int wb_thread_func(void *data)
 	return 0;
 }
 
+static void zram_writeback_end_io(struct bio *bio)
+{
+	struct zram_wb_request *req =
+		(struct zram_wb_request *)bio->bi_private;
+
+	enqueue_wb_request(&wb_req_list, req);
+	wake_up(&wb_wq);
+}
+
+struct zram_wb_request *alloc_wb_request(struct zram *zram,
+					 struct zram_pp_slot *pps,
+					 struct zram_pp_ctl *ppctl,
+					 unsigned long blk_idx)
+{
+	struct zram_wb_request *req;
+	struct page *page;
+	struct bio *bio;
+	int err = 0;
+
+	page = alloc_page(GFP_NOIO | __GFP_NOWARN);
+	if (!page)
+		return ERR_PTR(-ENOMEM);
+
+	bio = bio_alloc(zram->bdev, 1, REQ_OP_WRITE, GFP_NOIO | __GFP_NOWARN);
+	if (!bio) {
+		err = -ENOMEM;
+		goto out_free_page;
+	}
+
+	req = kmalloc(sizeof(struct zram_wb_request), GFP_NOIO | __GFP_NOWARN);
+	if (!req) {
+		err = -ENOMEM;
+		goto out_free_bio;
+	}
+	req->zram = zram;
+	req->pps = pps;
+	req->ppctl = ppctl;
+	req->blk_idx = blk_idx;
+	req->bio = bio;
+
+	bio->bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
+	__bio_add_page(bio, page, PAGE_SIZE, 0);
+	bio->bi_private = req;
+	bio->bi_end_io = zram_writeback_end_io;
+	return req;
+
+out_free_bio:
+	bio_put(bio);
+out_free_page:
+	__free_page(page);
+	return ERR_PTR(err);
+}
+
 void free_wb_request(struct zram_wb_request *req)
 {
 	struct bio *bio = req->bio;
diff --git a/drivers/block/zram/zram_wb.h b/drivers/block/zram/zram_wb.h
index b86de0398346..f6fe7c51d496 100644
--- a/drivers/block/zram/zram_wb.h
+++ b/drivers/block/zram/zram_wb.h
@@ -26,9 +26,11 @@ unsigned long alloc_block_bdev(struct zram *zram);
 void free_block_bdev(struct zram *zram, unsigned long blk_idx);
 int setup_zram_writeback(void);
 void destroy_zram_writeback(void);
+struct zram_wb_request *alloc_wb_request(struct zram *zram,
+					 struct zram_pp_slot *pps,
+					 struct zram_pp_ctl *ppctl,
+					 unsigned long blk_idx);
 void free_wb_request(struct zram_wb_request *req);
-void enqueue_wb_request(struct zram_wb_request_list *req_list,
-			struct zram_wb_request *req);
 #else
 inline unsigned long alloc_block_bdev(struct zram *zram) { return 0; }
 inline void free_block_bdev(struct zram *zram, unsigned long blk_idx) {};
-- 
2.50.1.565.gc32cd1483b-goog


