Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B72D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23516B002F; Fri, 28 Nov 2025 12:05:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3A26B0030; Fri, 28 Nov 2025 12:05:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9BA6B0031; Fri, 28 Nov 2025 12:05:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC9806B002F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:05:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 702491A0679
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:05:19 +0000 (UTC)
X-FDA: 84160641558.05.3E356CF
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5CAF8180022
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:05:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XxoJIuD7;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764349517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLXj0jbz9Wuo33iBrbj/6+Wb1xjJkFIW5VwB+h6O148=;
	b=lt2k1AB3PRECfyRMpYdr4MHyOqJoLPABTvpJCl0efAuPSgtfeiNMeOctcXag6LHiuYEcsJ
	OXudP8AyyTyx+99giMD7gczlSOfpK3eYaU7atvTtymxlswM33iK5i0ww9wY7nTJbBOQLn1
	Ut4RKAMj1wK4AJO6meodJ5jTXOO7zgw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XxoJIuD7;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764349517; a=rsa-sha256;
	cv=none;
	b=tEI1NZiqqgfVYVRLr62JFv5V44UjTyD0pAEwzw6Fa4FSTccpCsixDjK77tUWLztYgliXXf
	vUmwg0dxsDvT2BzrdjDlBtJm4ZlgTQe+9kx9NTbXQGKiq9BdtkDYzCL8AtyYMB5ehxY0VH
	zpytYpML9LyHn+2x3exsQx3PjnxaWj0=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7aace33b75bso2007957b3a.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764349516; x=1764954316; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wLXj0jbz9Wuo33iBrbj/6+Wb1xjJkFIW5VwB+h6O148=;
        b=XxoJIuD7woIAD+7LpQERfc+H/a28oV3VAjAwGEKRgrAW+6L49VceBz6gLsQKGWybpA
         Na4GRIREgqXgO2vysdfLxJlgPFKawvXOHcBbWJZTl46BHKTPXwmWSRglke7bEJvzTSlD
         jsrduItMp2a54940iKKJsGfw/f+t6dg9NeAAM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764349516; x=1764954316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wLXj0jbz9Wuo33iBrbj/6+Wb1xjJkFIW5VwB+h6O148=;
        b=syMyVv0XdoRSXKhnFBqHj+Uf0e8jprkKCGSZp+9Asmlxvz9H855jdKNEmSpQgV7Ywy
         RgUKY3EpdO9keOsfsrbxhEZTBd4JeRZ/LM2v1Sy0fHKgylZQ9gqpFeQcu55ievuGPFTa
         guD6KAIgqX5JLbrt/N6yEBuFvYxXOpUVkow7Iw67J+BeEFJJfJloeDvU8aClXiCVo+my
         GazkvSTUohEd1v4kreu1p79NpVDLF4LyUGx49nd0RnzYox/0AV1fvjugCJel2Ra6+Ia7
         eV+mmnFgfbA7GxaPjiKF80R0tEf++2W89rWac8IYzLDv3UTLdNMPbzamRaMKNsqU/DWB
         LbQw==
X-Forwarded-Encrypted: i=1; AJvYcCU8Gsf+iQF0PUz0yV+V/z8DGISe5be/oAhmmRXt4ud3Nx3QoQ7Xr0AczqI9CoFuDuS1E9WLc3WjCw==@kvack.org
X-Gm-Message-State: AOJu0YytkIXGle7cAEPlahPWqKPxfIqrY8aS5bNvOpi82iLJZEUqIfd2
	X4/3b03GEEpMKk9CIHcNmuPX32geEWQsm8SyN/KOGzzjFv1JshJlGIdW8Xq4ZDIQlA==
X-Gm-Gg: ASbGncu1bHny7L9NmJEC34Mc2UxpHgk9ovq8NdtWjveXxp1hDxiequaP10cOg0IO4D1
	vfTyiBKt/f1sY4MgJogIel8r0xUY4t1/4ip9ebYARMKqNTpIDU6yM57HoQ6k4VrOy3LiVhWtuSE
	n2AD3CX34f4Tetqr6bNimAjj9HUWLJzNSC+bBGHWWwIm3L004JF4V4EVEg80CGLG8bkNXVqCtQ4
	6bn+dP50eLnRxz2Albu7WQmWNLPWTL/4AAEdcwMjpHnOZk2eutRf7GOt/JjznhK1uomwDgyIroN
	veWu8mHo0ExVDpW4XF6VWN/TrF6gZWnHArlnCf9g6NvQhOCGOeGcsdhrdAHtVNpiK++LRgtv1RD
	sDYPQKCuqQjPW4fD0QU7M6RNlI+r1RuSoa8aiHy2dG0rGg0TpzmqI+GnKjx1qWNSzaCOi5yG/1Q
	LF0hUiOzJl8fo4f2tCnEeaLUFJfPpFOyZaPInklBFYPaQI21uFmaEgf9hU6GmZoCEBUa5fzptVY
	w==
X-Google-Smtp-Source: AGHT+IE3jdJ6BIGqZ/LrNySLI1gtSZu3kZ9H40LQzsOxlINAJwUkQtChjQ8P16I/r4Kq7vGDlsgVJw==
X-Received: by 2002:a05:6a21:3285:b0:35d:35a1:95d1 with SMTP id adf61e73a8af0-36150e27992mr26945189637.9.1764349515420;
        Fri, 28 Nov 2025 09:05:15 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:5b9f:6c7b:4d09:6126])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d150c5e611sm5568242b3a.6.2025.11.28.09.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 09:05:15 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@google.com>
Subject: [PATCH 1/2] zram: introduce compressed data writeback
Date: Sat, 29 Nov 2025 02:04:41 +0900
Message-ID: <20251128170442.2988502-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251128170442.2988502-1-senozhatsky@chromium.org>
References: <20251128170442.2988502-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5CAF8180022
X-Rspamd-Server: rspam02
X-Stat-Signature: m3ndtjdbw3q5pozemx7fke7fcyofxsw9
X-Rspam-User: 
X-HE-Tag: 1764349517-476983
X-HE-Meta: U2FsdGVkX19k7d9ryFW9VO2M+G6Wk+Zyolsi9ecXMW3XRiQSuMMGfDWx2aK3Iq8Y7x+hJIPXcPPjQnOirTsqN0Uk/LiGCv+N+4Sjey9xaw7hdJMPFgTj8uHvKsq9rJlDQRU5wxMQWQJu69lMUJSsld4NWNVrexemGx29gQX3SDiHN0pCUeQGhwyocqYAXIWRqY8laXgTSMs4n3rF/N0uBrPPAoQAv2Kz8VY7ZVJSxu8XhYbF5Om9N6aL8CjQ//4/I7nhztNPa+8Ps0318jAR323bKov66plP4uyAPCgqVjiMzF5zgbQNQuAEtbX4sSDt1UhTbRosGrJYSix6VJ5L5cFuqWAzzD5D+HYtix9z9QU9QUmC9Wq2pEBcb12fTWmIUmFOtGIsnuoWXaXnBmZDEcEhwYGeZtv29op1noYXjsYD3FCeyPcpxsKp4B7Zvk008ptOqUjPTwirjKYqNi7gElbr9tAyTiWwTbRwqclZVqNCkVdbaQBNxuxExci6aSTJv0/wgI1HfugL6E44cszbes3BEc6Q52QkyWFFAwJAVkrERX7r42CO4k12Cpbhxy07k7ioKRJR1EJhkLKX2t1E1j/Fm2MATCpYBUDh0l/H4ERCWmOjKBAdbEnjQEq4f3t7pNqDsYohSb69/czu7hsHoLBwIwt7xb5OJf6QYp2RqJ79sj1pREgj4BWzLu57QXB1So6GLJ+rkylDbV5N4N/dfc0Hedqy4Re7KIzBMcGQvR2CqrimDLfFpSfbSQzTwEWIAUZraLrH6ZTzMgu+Lnqge6HJEPcQ8H7TcjodHDNCZYv9Hy0cmfZB/S4lO78yqbzIrcprbU5Js5m2D2MLPwVrsKUdGqutIgDpndtLYqLDe3wUSITRJK9nmmkL3GZTlsnrTq1PaMncL+8Tz63UypPEKcDyuqki0+1D5b72vCkEl5DG1hVzbsKRqqPegAi7DBJGCXmhzjtSL3coYkkOjeX
 rzwESvwZ
 CZ0scrsNgQZM3cAksUD69CHDnf7c+WAIJlScdDK+d8KPMO4SLdCfi7Yb7nfzly700FUb3/QtiiRcfx1WGBmOuNIhQWaFnfQYkazv9JAnB02KRW4ANF6dV683QbraQCVLio707dgMTkJpkvaa7dQuL5kZo6kWVRe73pxSWYlPWhs+rVvVW+CNk8AnYq6Wx5svv2BRE/eSKwDc0K4ua+xzXhXIcyRsRnDGD3CiWgKzIva1+D0OY02eBa7OHvLf2TmzNAw2OppuDJL8Vjq9Hf2kbY1oMIhITWehthE3ROGVgin4ThP3OUmzXkv+2YYNMY7PU3tdIDRt+mABk0Gk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Richard Chang <richardycc@google.com>

zram stores all written back slots raw, which implies that
during writeback zram first has to decompress slots (except
for ZRAM_HUGE slots, which are raw already).  The problem
with this approach is that not every written back page gets
read back (either via read() or via page-fault), which means
that zram basically wastes CPU cycles and battery decompressing
such slots.  This changes with introduction of decompression
on demand, in other words decompression on read()/page-fault.

One caveat of decompression on demand is that async read
is completed in IRQ context, while zram decompression is
sleepable.  To workaround this, read-back decompression
is offloaded to a preemptible context - system high-prio
work-queue.

Signed-off-by: Richard Chang <richardycc@google.com>
Co-developed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@google.com>
Suggested-by: Brian Geffon <bgeffon@google.com>
---
 drivers/block/zram/zram_drv.c | 240 +++++++++++++++++++++++++++-------
 1 file changed, 192 insertions(+), 48 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 5759823d6314..eef6c0a675b5 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -57,8 +57,8 @@ static size_t huge_class_size;
 static const struct block_device_operations zram_devops;
 
 static void zram_free_page(struct zram *zram, size_t index);
-static int zram_read_from_zspool(struct zram *zram, struct page *page,
-				 u32 index);
+static int zram_read_from_zspool_raw(struct zram *zram, struct page *page,
+				     u32 index);
 
 #define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
 
@@ -522,6 +522,22 @@ struct zram_wb_req {
 	struct list_head entry;
 };
 
+struct zram_rb_req {
+	struct work_struct work;
+	struct zram *zram;
+	struct page *page;
+	/* The read bio for backing device */
+	struct bio *bio;
+	unsigned long blk_idx;
+	union {
+		/* The original bio to complete (async read) */
+		struct bio *parent;
+		/* error status (sync read) */
+		int error;
+	};
+	u32 index;
+};
+
 static ssize_t writeback_limit_enable_store(struct device *dev,
 					    struct device_attribute *attr,
 					    const char *buf, size_t len)
@@ -780,18 +796,6 @@ static void zram_release_bdev_block(struct zram *zram, unsigned long blk_idx)
 	atomic64_dec(&zram->stats.bd_count);
 }
 
-static void read_from_bdev_async(struct zram *zram, struct page *page,
-			unsigned long entry, struct bio *parent)
-{
-	struct bio *bio;
-
-	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
-	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
-	__bio_add_page(bio, page, PAGE_SIZE, 0);
-	bio_chain(bio, parent);
-	submit_bio(bio);
-}
-
 static void release_wb_req(struct zram_wb_req *req)
 {
 	__free_page(req->page);
@@ -886,8 +890,9 @@ static void zram_account_writeback_submit(struct zram *zram)
 
 static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 {
-	u32 index = req->pps->index;
-	int err;
+	u32 size, index = req->pps->index;
+	int err, prio;
+	bool huge;
 
 	err = blk_status_to_errno(req->bio.bi_status);
 	if (err) {
@@ -914,9 +919,22 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 		goto out;
 	}
 
+	/*
+	 * ZRAM_WB slots get freed, we need to preserve data required for
+	 * read decompression.
+	 */
+	size = zram_get_obj_size(zram, index);
+	prio = zram_get_priority(zram, index);
+	huge = zram_test_flag(zram, index, ZRAM_HUGE);
+
 	zram_free_page(zram, index);
 	zram_set_flag(zram, index, ZRAM_WB);
+	if (huge)
+		zram_set_flag(zram, index, ZRAM_HUGE);
 	zram_set_handle(zram, index, req->blk_idx);
+	zram_set_obj_size(zram, index, size);
+	zram_set_priority(zram, index, prio);
+
 	atomic64_inc(&zram->stats.pages_stored);
 
 out:
@@ -1050,7 +1068,7 @@ static int zram_writeback_slots(struct zram *zram,
 		 */
 		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
-		if (zram_read_from_zspool(zram, req->page, index))
+		if (zram_read_from_zspool_raw(zram, req->page, index))
 			goto next;
 		zram_slot_unlock(zram, index);
 
@@ -1313,24 +1331,123 @@ static ssize_t writeback_store(struct device *dev,
 	return ret;
 }
 
-struct zram_work {
-	struct work_struct work;
-	struct zram *zram;
-	unsigned long entry;
-	struct page *page;
-	int error;
-};
+static int decompress_bdev_page(struct zram *zram, struct page *page, u32 index)
+{
+	struct zcomp_strm *zstrm;
+	unsigned int size;
+	int ret, prio;
+	void *src;
+
+	zram_slot_lock(zram, index);
+	/* Since slot was unlocked we need to make sure it's still ZRAM_WB */
+	if (!zram_test_flag(zram, index, ZRAM_WB)) {
+		zram_slot_unlock(zram, index);
+		/* We read some stale data, zero it out */
+		memset_page(page, 0, 0, PAGE_SIZE);
+		return -EIO;
+	}
+
+	if (zram_test_flag(zram, index, ZRAM_HUGE)) {
+		zram_slot_unlock(zram, index);
+		return 0;
+	}
+
+	size = zram_get_obj_size(zram, index);
+	prio = zram_get_priority(zram, index);
+
+	zstrm = zcomp_stream_get(zram->comps[prio]);
+	src = kmap_local_page(page);
+	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size,
+			       zstrm->local_copy);
+	if (!ret)
+		copy_page(src, zstrm->local_copy);
+	kunmap_local(src);
+	zcomp_stream_put(zstrm);
+	zram_slot_unlock(zram, index);
+
+	return ret;
+}
+
+static void zram_deferred_decompress(struct work_struct *w)
+{
+	struct zram_rb_req *req = container_of(w, struct zram_rb_req, work);
+	struct page *page = bio_first_page_all(req->bio);
+	struct zram *zram = req->zram;
+	u32 index = req->index;
+	int ret;
+
+	ret = decompress_bdev_page(zram, page, index);
+	if (ret)
+		req->parent->bi_status = BLK_STS_IOERR;
+
+	/* Decrement parent's ->remaining */
+	bio_endio(req->parent);
+	bio_put(req->bio);
+	kfree(req);
+}
+
+static void zram_async_read_endio(struct bio *bio)
+{
+	struct zram_rb_req *req = bio->bi_private;
+
+	if (bio->bi_status) {
+		req->parent->bi_status = bio->bi_status;
+		bio_endio(req->parent);
+		bio_put(bio);
+		kfree(req);
+		return;
+	}
 
-static void zram_sync_read(struct work_struct *work)
+	/*
+	 * zram decompression is sleepable, so we need to deffer it to
+	 * a preemptible context.
+	 */
+	INIT_WORK(&req->work, zram_deferred_decompress);
+	queue_work(system_highpri_wq, &req->work);
+}
+
+static void read_from_bdev_async(struct zram *zram, struct page *page,
+				 u32 index, unsigned long blk_idx,
+				 struct bio *parent)
 {
-	struct zram_work *zw = container_of(work, struct zram_work, work);
+	struct zram_rb_req *req;
+	struct bio *bio;
+
+	req = kmalloc(sizeof(*req), GFP_NOIO);
+	if (!req)
+		return;
+
+	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
+	if (!bio) {
+		kfree(req);
+		return;
+	}
+
+	req->zram = zram;
+	req->index = index;
+	req->blk_idx = blk_idx;
+	req->bio = bio;
+	req->parent = parent;
+
+	bio->bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
+	bio->bi_private = req;
+	bio->bi_end_io = zram_async_read_endio;
+
+	__bio_add_page(bio, page, PAGE_SIZE, 0);
+	bio_inc_remaining(parent);
+	submit_bio(bio);
+}
+
+static void zram_sync_read(struct work_struct *w)
+{
+	struct zram_rb_req *req = container_of(w, struct zram_rb_req, work);
 	struct bio_vec bv;
 	struct bio bio;
 
-	bio_init(&bio, zw->zram->bdev, &bv, 1, REQ_OP_READ);
-	bio.bi_iter.bi_sector = zw->entry * (PAGE_SIZE >> 9);
-	__bio_add_page(&bio, zw->page, PAGE_SIZE, 0);
-	zw->error = submit_bio_wait(&bio);
+	bio_init(&bio, req->zram->bdev, &bv, 1, REQ_OP_READ);
+	bio.bi_iter.bi_sector = req->blk_idx * (PAGE_SIZE >> 9);
+	__bio_add_page(&bio, req->page, PAGE_SIZE, 0);
+	req->error = submit_bio_wait(&bio);
 }
 
 /*
@@ -1338,39 +1455,41 @@ static void zram_sync_read(struct work_struct *work)
  * chained IO with parent IO in same context, it's a deadlock. To avoid that,
  * use a worker thread context.
  */
-static int read_from_bdev_sync(struct zram *zram, struct page *page,
-				unsigned long entry)
+static int read_from_bdev_sync(struct zram *zram, struct page *page, u32 index,
+			       unsigned long blk_idx)
 {
-	struct zram_work work;
+	struct zram_rb_req req;
 
-	work.page = page;
-	work.zram = zram;
-	work.entry = entry;
+	req.page = page;
+	req.zram = zram;
+	req.blk_idx = blk_idx;
 
-	INIT_WORK_ONSTACK(&work.work, zram_sync_read);
-	queue_work(system_dfl_wq, &work.work);
-	flush_work(&work.work);
-	destroy_work_on_stack(&work.work);
+	INIT_WORK_ONSTACK(&req.work, zram_sync_read);
+	queue_work(system_dfl_wq, &req.work);
+	flush_work(&req.work);
+	destroy_work_on_stack(&req.work);
 
-	return work.error;
+	if (!req.error)
+		return decompress_bdev_page(zram, page, index);
+	return req.error;
 }
 
-static int read_from_bdev(struct zram *zram, struct page *page,
-			unsigned long entry, struct bio *parent)
+static int read_from_bdev(struct zram *zram, struct page *page, u32 index,
+			  unsigned long blk_idx, struct bio *parent)
 {
 	atomic64_inc(&zram->stats.bd_reads);
 	if (!parent) {
 		if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
 			return -EIO;
-		return read_from_bdev_sync(zram, page, entry);
+		return read_from_bdev_sync(zram, page, index, blk_idx);
 	}
-	read_from_bdev_async(zram, page, entry, parent);
+	read_from_bdev_async(zram, page, index, blk_idx, parent);
 	return 0;
 }
 #else
 static inline void reset_bdev(struct zram *zram) {};
-static int read_from_bdev(struct zram *zram, struct page *page,
-			unsigned long entry, struct bio *parent)
+static int read_from_bdev(struct zram *zram, struct page *page, u32 index,
+			  unsigned long blk_idx, struct bio *parent)
 {
 	return -EIO;
 }
@@ -1977,6 +2096,31 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
 	return ret;
 }
 
+static int zram_read_from_zspool_raw(struct zram *zram, struct page *page,
+				     u32 index)
+{
+	struct zcomp_strm *zstrm;
+	unsigned long handle;
+	unsigned int size;
+	void *src;
+
+	handle = zram_get_handle(zram, index);
+	size = zram_get_obj_size(zram, index);
+
+	/*
+	 * We need to get stream just for ->local_copy buffer, in
+	 * case if object spans two physical pages. No decompression
+	 * takes place here, as we read raw compressed data.
+	 */
+	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
+	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
+	memcpy_to_page(page, 0, src, size);
+	zs_obj_read_end(zram->mem_pool, handle, src);
+	zcomp_stream_put(zstrm);
+
+	return 0;
+}
+
 /*
  * Reads (decompresses if needed) a page from zspool (zsmalloc).
  * Corresponding ZRAM slot should be locked.
@@ -2012,7 +2156,7 @@ static int zram_read_page(struct zram *zram, struct page *page, u32 index,
 		 * device.
 		 */
 		zram_slot_unlock(zram, index);
-		ret = read_from_bdev(zram, page, blk_idx, parent);
+		ret = read_from_bdev(zram, page, index, blk_idx, parent);
 	}
 
 	/* Should NEVER happen. Return bio error if it does. */
-- 
2.52.0.487.g5c8c507ade-goog


