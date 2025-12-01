Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8233D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D1B6B008C; Mon,  1 Dec 2025 04:48:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD546B0092; Mon,  1 Dec 2025 04:48:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1AD6B0093; Mon,  1 Dec 2025 04:48:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D42FB6B008C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:48:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73CF859E26
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:12 +0000 (UTC)
X-FDA: 84170426424.10.BE0A38B
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 784EFC000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gBXVbaXY;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764582490; a=rsa-sha256;
	cv=none;
	b=IOy09zMDd6GV++X5UC5Ap0wWvKnI9HL172qBB3ado3z+JEaWif8/mHT+b6t4/6hCqD9Z8R
	XEfvzz/qblelcixhpAakmT8P4AW5Btnbjs5hsXunKxL6XqCbYdNEX1C8t2qhF9fIynNY9H
	4aN3w7E6EIjNvAtoKU/mB3IK9vbdQd0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gBXVbaXY;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764582490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnhNR+agQ932W+14bFvb5ZmmvFAQtUwOKUgk6jRlfpU=;
	b=Uu2dJKSLiyV8QYhj791SEWPZ4Vb69Yw+s5dQ0Di6pywjI0qQBFKEIXmISebcW9AZkI4k88
	7YuNlXYZTMhnqLMNAv9Z0xUD871Cqt5rNs0BDhUyQcEudxGsuYEvwHpp3E6VeaJg1lk2hT
	oosSerT8Gr/6D2JfjUqOV3D0zR+oykE=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so4853846b3a.2
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764582489; x=1765187289; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fnhNR+agQ932W+14bFvb5ZmmvFAQtUwOKUgk6jRlfpU=;
        b=gBXVbaXYndiHLZ46OUGeNF/w9bb6aZ28Sy07WDdTTogF7zu1WWMC3AluikFyRAhhi5
         3x+FdusrDT7D9s8F/k+vmGlhhDUdqND0GlgPS+hlovdREZo2BDK5ILZ5UjuSEdxWWdc1
         sTr1auVF8ERuAAb1Wz6su0eqo9nD/oTTKzqU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764582489; x=1765187289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fnhNR+agQ932W+14bFvb5ZmmvFAQtUwOKUgk6jRlfpU=;
        b=vrrxq3Zi47KgnZ1WR1QditD9UNelHhpvm+fEvDsrnBEeOQbQwehU5tS+LVvamDni85
         nddJI+pwgO0a4kgDAfiCF2j+w4FLWu1iv7InMmOBuNRhaUnY31sj576FGFI1zZVGTgjI
         7XEyBvEzQhDnJZq4i7TVBZIEo/X1ZyRMflbfYOzJXhedmGynIsTRYwi6MPHkJ1u7JLPM
         iUAqcYOQxzK6l1UBMS/8U1NY1NEpxOpDP4gv+dyJBhs6zwTtX4331A5DEIIqYu8q95ep
         djXvKJN6ShTy5J2dmlHcZq2DCP5RfzRkn5/3rCyzhsM7UsA7uNrfmg9yaxCQ8tEcK0QC
         C5JQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqeRX2GW7HPNCKbiSz1/lPvsrL5ZyQO7m6NuVWS/JYp6k2ClP3zxCCWgjYtIc5kmYOExdsWzjRHQ==@kvack.org
X-Gm-Message-State: AOJu0YydAFmicw6FMy2+K6RPTPhXP6dYtMh+SfGVlkoXB5Gh71KGFll5
	3/96HB3FTEczokVKvOzGaJAlx8YeIZh+i7M3J2I5+PZwrjqLA7KyuLu3o6vlgR6n1A==
X-Gm-Gg: ASbGncvMe+6V5EcK+SsjGQWu9rzl3u6T3zkMZAmlUpXvgNEMJ2KUoWdYRbOtMZ3cutA
	VuntEcTeJPCTnItgGhUWvH0EsdnoDONjuveRoeoblbqp4Q4i+eN5h9kOYiPhN9uODe7Mo8e6ylF
	vYhJT7MPChLIeWwJ1r2ExxcVqYmiX3p5OlfLaZOnPYqhhAKYihi/Q94mLxlb6rGNGGe7s46vUla
	Wm3mxE2h4bqrIltCAYPjwtV7Kx0COLwWyPhBlyhAzL3WA1G0PJtXyg98rCPfd86wUDju72iq1x0
	RdvjeztqlqNWijjfUWs4/TfX/3sskgyXswXblj2ZFvEpPzjdKpMyhiMXfxXQvOtEwRuWQMM+maK
	lg/EOxdKU/8CSgHTrObIqsS4yR0np77fRPu7hEW5YQhqD8WZHN4WdtzEuE6L/PFpWxQlGGjmokJ
	qO8t0OvhDhFt1WjEUZ9pJFZDREicbyVkhNDOezmlmRsP/lvStdrwgLTjBH16ACh0k3tyVBo90bM
	w==
X-Google-Smtp-Source: AGHT+IHKSmALbuKSgE06X0oPsRvPSiRabvdVpp7WYRIWzuOcPk/FALFSBZoiw65yQsKAfcJNqwyM2A==
X-Received: by 2002:aa7:989d:0:b0:7aa:ac12:2c33 with SMTP id d2e1a72fcca58-7c58c2a7354mr29267009b3a.1.1764582489249;
        Mon, 01 Dec 2025 01:48:09 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e7db577sm12882074b3a.31.2025.12.01.01.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:48:08 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>,
	Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@google.com>
Subject: [PATCHv2 1/7] zram: introduce compressed data writeback
Date: Mon,  1 Dec 2025 18:47:48 +0900
Message-ID: <20251201094754.4149975-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251201094754.4149975-1-senozhatsky@chromium.org>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 784EFC000B
X-Stat-Signature: wn4jzystm41sbaw53byfodqaj1ei7xzi
X-Rspam-User: 
X-HE-Tag: 1764582490-559443
X-HE-Meta: U2FsdGVkX19TcxFLER+JxUsIndczdiuioYLFyKLBJ45buvx0VnrNGhDsRZii+eDeWZKPBBZ9gOG9mzsPIQoeeDGyoAygg2Cwn0f1XRkom2cY26YUc5JyWiNJsDvnPvUP12QpHLbdRq7jj5UJMXk4qqElJm916bH5+jaTxc6O7fsv/DSPbR4Auf5m7/LnTBVF84MF9M2GWVlEZokxXmWQNQ1f/qQriUdrz/Zn7NYls8t65NOTHrNBw9nTtsApNTBZ5bwtb90R+6zkXyTl8DAK7cIuw6pyY7ZtKlaZfZ8KtFam2lzCs40iutbWQswSa1k/k8fB7EySpmkOkAxjVakSJ2Y9epUgNjsiW2K0K1pzqGXK0yxSAVtomqLN2WsiR3nHg1eGD81h3t5oIsP/S3FZ6yoOZAN0tevrxEDSfV14uVKyrBW3yLIGqgEppeZhCdoDdQgW60UBMPh69U8kTe2AASeXkdRhOgidJw/wFmIiDeh7uFpCi8WdY1ZMGq9CoSO9F72YqG3d9wxIlGq5WmOflxGx7xBtfud3bZtQNUosIj0lgdBr/9zfV2ZHawHpGguZVunvGY9d3ONECepv83cLYJohIJnJrdH04N0SjuQIuDo5Vp+ZRjXHohHTRkzTINLPi7jQee+tYOTMu6zZCIgvVC3EeJlhYeQXsEPEDeZWoytMKTZIuzEb+tKg1mlCornFv+YjGc/g92bTxwrDipdMgDIPX8mr7eObx6HWJ37qLdrv8O4XZx2t3UUIi+qlo/AV+h778yOw1pS7VkcPDRisKIqhBN9i8JSCbChPNrs7hvW7++573Y5JDNkPPid3szwHkA8KwxdCxfFe/F4DBeB57kQcR21+z+9Obmu3mqByqa6++QghgmdyqH6iMFerM8Eb4oyCO4ADevBVCNSuL3nBlnDnTZolQnkNx986ZKFzt6qkCWNSq+T2kfdQH9YLtXHU2Ss7MIghPVFD+L7jA2t
 ihxYpHR1
 CzRzj+O7DeSaj9s4g/XkpGbGkOm000pSEkQHHXO6ELi6nmG2hnelPNHTUzDxQ+nJmPI3DIP96qSBe4cb8sdIxvlKACof3O0p4VmYdL/Z9mTEygO+uMXB4pze1FrK7kXhoNOU6p2lzHikuv+3sL371UmjSpPEYaMD25lMC97VaSfKwfznjUb10FKgvqLlYt6aXVFXtb6OOy7+wARyCO8iNJi4fbYh/duKdppbHyewhjvQ38V/2D58QoVvkEL9FmD+9ee5Pwxw+Xd3tCtkzCS1tAZY1G2qHEsiwJE6vD7CeuA1O1UTdDGvP5kUtKqoDFEM8A00LBEkhJyz3PZM=
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

At this point compressed writeback is still disabled,
a follow up patch will introduce a new device attribute
which will make it possible to toggle compressed writeback
per-device.

[senozhatsky: rewrote original implementation]
Signed-off-by: Richard Chang <richardycc@google.com>
Co-developed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@google.com>
Suggested-by: Brian Geffon <bgeffon@google.com>
---
 drivers/block/zram/zram_drv.c | 279 +++++++++++++++++++++++++++-------
 drivers/block/zram/zram_drv.h |   1 +
 2 files changed, 227 insertions(+), 53 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 5759823d6314..6263d300312e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -57,9 +57,6 @@ static size_t huge_class_size;
 static const struct block_device_operations zram_devops;
 
 static void zram_free_page(struct zram *zram, size_t index);
-static int zram_read_from_zspool(struct zram *zram, struct page *page,
-				 u32 index);
-
 #define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
 
 static void zram_slot_lock_init(struct zram *zram, u32 index)
@@ -502,6 +499,10 @@ static ssize_t idle_store(struct device *dev,
 #ifdef CONFIG_ZRAM_WRITEBACK
 #define INVALID_BDEV_BLOCK		(~0UL)
 
+static int read_from_zspool_raw(struct zram *zram, struct page *page,
+				u32 index);
+static int read_from_zspool(struct zram *zram, struct page *page, u32 index);
+
 struct zram_wb_ctl {
 	/* idle list is accessed only by the writeback task, no concurency */
 	struct list_head idle_reqs;
@@ -522,6 +523,22 @@ struct zram_wb_req {
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
@@ -780,18 +797,6 @@ static void zram_release_bdev_block(struct zram *zram, unsigned long blk_idx)
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
@@ -886,8 +891,9 @@ static void zram_account_writeback_submit(struct zram *zram)
 
 static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 {
-	u32 index = req->pps->index;
-	int err;
+	u32 size, index = req->pps->index;
+	int err, prio;
+	bool huge;
 
 	err = blk_status_to_errno(req->bio.bi_status);
 	if (err) {
@@ -914,9 +920,27 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 		goto out;
 	}
 
+	if (zram->wb_compressed) {
+		/*
+		 * ZRAM_WB slots get freed, we need to preserve data required
+		 * for read decompression.
+		 */
+		size = zram_get_obj_size(zram, index);
+		prio = zram_get_priority(zram, index);
+		huge = zram_test_flag(zram, index, ZRAM_HUGE);
+	}
+
 	zram_free_page(zram, index);
 	zram_set_flag(zram, index, ZRAM_WB);
 	zram_set_handle(zram, index, req->blk_idx);
+
+	if (zram->wb_compressed) {
+		if (huge)
+			zram_set_flag(zram, index, ZRAM_HUGE);
+		zram_set_obj_size(zram, index, size);
+		zram_set_priority(zram, index, prio);
+	}
+
 	atomic64_inc(&zram->stats.pages_stored);
 
 out:
@@ -1050,7 +1074,11 @@ static int zram_writeback_slots(struct zram *zram,
 		 */
 		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
-		if (zram_read_from_zspool(zram, req->page, index))
+		if (zram->wb_compressed)
+			err = read_from_zspool_raw(zram, req->page, index);
+		else
+			err = read_from_zspool(zram, req->page, index);
+		if (err)
 			goto next;
 		zram_slot_unlock(zram, index);
 
@@ -1313,24 +1341,140 @@ static ssize_t writeback_store(struct device *dev,
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
 
-static void zram_sync_read(struct work_struct *work)
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
 {
-	struct zram_work *zw = container_of(work, struct zram_work, work);
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
+	struct zram *zram = req->zram;
+
+	if (bio->bi_status) {
+		req->parent->bi_status = bio->bi_status;
+		bio_endio(req->parent);
+		bio_put(bio);
+		kfree(req);
+		return;
+	}
+
+	/*
+	 * NOTE: zram_async_read_endio() is not exactly right place for this.
+	 * Ideally, we need to do it after ZRAM_WB check, but this requires
+	 * us to use wq path even on systems that don't enable compressed
+	 * writeback, because we cannot take slot-lock in the current context.
+	 *
+	 * Keep the existing behavior for now.
+	 */
+	if (zram->wb_compressed == false) {
+		/* No decompression needed, complete the parent IO */
+		bio_endio(req->parent);
+		bio_put(bio);
+		kfree(req);
+		return;
+	}
+
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
+{
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
@@ -1338,39 +1482,42 @@ static void zram_sync_read(struct work_struct *work)
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
+	if (req.error || zram->wb_compressed == false)
+		return req.error;
+
+	return decompress_bdev_page(zram, page, index);
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
@@ -1977,12 +2124,37 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
 	return ret;
 }
 
+#if defined CONFIG_ZRAM_WRITEBACK
+static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
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
+#endif
+
 /*
  * Reads (decompresses if needed) a page from zspool (zsmalloc).
  * Corresponding ZRAM slot should be locked.
  */
-static int zram_read_from_zspool(struct zram *zram, struct page *page,
-				 u32 index)
+static int read_from_zspool(struct zram *zram, struct page *page, u32 index)
 {
 	if (zram_test_flag(zram, index, ZRAM_SAME) ||
 	    !zram_get_handle(zram, index))
@@ -2002,7 +2174,7 @@ static int zram_read_page(struct zram *zram, struct page *page, u32 index,
 	zram_slot_lock(zram, index);
 	if (!zram_test_flag(zram, index, ZRAM_WB)) {
 		/* Slot should be locked through out the function call */
-		ret = zram_read_from_zspool(zram, page, index);
+		ret = read_from_zspool(zram, page, index);
 		zram_slot_unlock(zram, index);
 	} else {
 		unsigned long blk_idx = zram_get_handle(zram, index);
@@ -2012,7 +2184,7 @@ static int zram_read_page(struct zram *zram, struct page *page, u32 index,
 		 * device.
 		 */
 		zram_slot_unlock(zram, index);
-		ret = read_from_bdev(zram, page, blk_idx, parent);
+		ret = read_from_bdev(zram, page, index, blk_idx, parent);
 	}
 
 	/* Should NEVER happen. Return bio error if it does. */
@@ -2273,7 +2445,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	if (comp_len_old < threshold)
 		return 0;
 
-	ret = zram_read_from_zspool(zram, page, index);
+	ret = read_from_zspool(zram, page, index);
 	if (ret)
 		return ret;
 
@@ -2960,6 +3132,7 @@ static int zram_add(void)
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_batch_size = 32;
+	zram->wb_compressed = false;
 #endif
 
 	/* gendisk structure */
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index c6d94501376c..72fdf66c78ab 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -128,6 +128,7 @@ struct zram {
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
 	bool wb_limit_enable;
+	bool wb_compressed;
 	u32 wb_batch_size;
 	u64 bd_wb_limit;
 	struct block_device *bdev;
-- 
2.52.0.487.g5c8c507ade-goog


