Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC6CCF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1EFB6B0006; Thu, 20 Nov 2025 10:22:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFB36B00A7; Thu, 20 Nov 2025 10:22:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E54A6B00B5; Thu, 20 Nov 2025 10:22:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4346B0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:22:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3905C139441
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:12 +0000 (UTC)
X-FDA: 84131351304.15.56E9070
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 38E46C000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=M5VO5jEP;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQMGDA1+u1LPAuL+BCiFc4Yo1PBFGHEJGqJGazuFeIc=;
	b=M+n3VRlm6DmVWdpdk4RmpZFnxUjJWXFgAKLvT2PfERx9Vdy7k/2ZnaAj8IKVlFNcv2il/F
	R/BkBu1M/h0P4WWI6A2+4LRIx9EcecrKhHJLz5tPTdb3m50K+On8t16rmKe4WTeVc0Ngo5
	pRb1A/G+N5wNhooLtcbb9WFu2PzG2Tw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652130; a=rsa-sha256;
	cv=none;
	b=2nWDm4yiqwvUoeQKUZlAQJLCFcXCLSG+xJoODKuV4Lbef42r9aGGUjnC1+GJ5PGKWXWScR
	9n9XTarGswn1traQxyvF7LJQvM2CREosN0NtV6PUNTQ137sKlNHg3/n/xxWqpsi21xG+Kr
	wni15jSD9t9KD2znlnirFhIX0dQQbuk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=M5VO5jEP;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7ba92341f83so1412252b3a.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763652129; x=1764256929; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQMGDA1+u1LPAuL+BCiFc4Yo1PBFGHEJGqJGazuFeIc=;
        b=M5VO5jEPXj10q9HjwCKjmiP9yjtx5d/F5zV1pZIPKfT+O/H8PnP0cmUK9UMgm+R19A
         dN2ytpq3y0XmpD+syQWU5a+Sv8qGecKTACBAl6TOOzTASGEZDa2nXXmKcBoPC6YGaiUZ
         gD75qqw8pymWMqzRP+0LezOylJu3FHBINpxds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652129; x=1764256929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DQMGDA1+u1LPAuL+BCiFc4Yo1PBFGHEJGqJGazuFeIc=;
        b=uH8Iip6imo6T+R13RMJ6/w8T5QNfKCYU4fXOZ9kuAc7FjkQuSbUG9DazaHbCxaRr8p
         FHbTJpjPIcrk+nggsLUSzEPfq/XrzP0r97SfZEhVB6+9B0TIIPptGDiX1RTaCc8f0Dnq
         HouIC2ZL9wmqPXsWghEmi5Qp3pLoxQFLCVu8jW8K2ZBPradOOiryiz1fEzG861T3NK2+
         iBo3XMpN8c1NU8cdPLpNWO5FV7Sg3kAY1PozXEpYPMMcTnvMIiz0ZsJuYcM30Z35OCly
         8D0OeRmZ4uFp9dep2Z6lOL9WHkzYpALINym/e+2JxERuM+5vOUCZe185/mDFhJXbes48
         Yeqw==
X-Forwarded-Encrypted: i=1; AJvYcCWFdR5jN3Fey24TA1LLZsSRicHLQ4IUOaPMmRTVyEo/P13F/ncRwhstSp2nIkAIXFheqwvagIiI+A==@kvack.org
X-Gm-Message-State: AOJu0YzbR+eUnN0Q/a/fzx4sxi3XfBZ3Lvsj3Zb8qrMk5fdCdwFFWpXF
	P8tq5MijUyTRN6B/MMkghE4PR1ESmm7uYawCwE6t8YWqPWOowvEwaefONvgOKGbrAQ==
X-Gm-Gg: ASbGncumnqCoDqXWY7+cGxujLH4qy4tMLqJRYI6zG4ocm3uhOREjvusr3pg/9SYiPNH
	9CiUVsQ0umTjMXzlKraW3OUz6BVrKzyGJQ5GuylsbYiIyJdOS+arDfj34n0+YNC0whiUNCpOKrb
	m7vB6ZLlS2lkkNzWjHCBa6rjGn5pjBDcawSV3JN4/xHmlMKochgjSvfEjQc6MhFrdr0BFTROvvq
	zaWOmtm+Pxpfvg0XP3gKhPt2NaCaYYskbYUpgsA4ckBTcC8uAFeO8ozEVivuD91wDcd/+zvg47B
	ty/gHcdOU62BAuZkoS7mI0MCF5aRc/e7c4FjAWOPZu7V36ylueDJZZSW4ndaVzJu+HqKGzuB+cA
	WUPHEyG+FDSjcb/5QP5fvHOoU4T6VOZ80XoBih+Xg+N5854gne8vBLJvprZut2WyNzH8pDU5h9B
	ZvZBWsyQoSgQGZe5baOCXg6Pk8mkEaXzPgeUFn5Q==
X-Google-Smtp-Source: AGHT+IH4Kqb6jdeCprkIAeBP8l5L/2bdYTnDn0ERK7+4rx4S17p67ukAm1nlmWjmMsyD/cMn7l50fA==
X-Received: by 2002:a05:6a00:1248:b0:7ad:386e:3b6d with SMTP id d2e1a72fcca58-7c3f07656fbmr4373751b3a.21.1763652129027;
        Thu, 20 Nov 2025 07:22:09 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6762:7dba:8487:43a1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f023f968sm3179642b3a.38.2025.11.20.07.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:22:08 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@google.com>
Subject: [RFC PATCHv5 1/6] zram: introduce writeback bio batching
Date: Fri, 21 Nov 2025 00:21:21 +0900
Message-ID: <20251120152126.3126298-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251120152126.3126298-1-senozhatsky@chromium.org>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38E46C000E
X-Stat-Signature: 7khdxtqcnhj6qwburw8gyywh7wj35d4w
X-Rspam-User: 
X-HE-Tag: 1763652130-696218
X-HE-Meta: U2FsdGVkX19hQ1q7pTsEk8fEM8fNvgKLUdXXWegH//Ka8wFfMIXO+3YNEDA7oUXehy5/s9mi5dTQAOe8v41iKolTx1To/liOlHH7wzRCHVZBILTVF01fhSGeGvE+H9OHqZ76rgU8XyRppr6WCJN7FhjOfHGb39L6ZkYDyeBp/Y/rnEnfEHJi4rm+y72uuq0QKepFj7lgrGMjiWTXiVrS6GHog83syJFBOIYXNSAiIWraBJeaF5v+nwHtEvVik36AW/RMKLQ8Gq8ivfEdpeaqoxkjXGZzDnjKB1RNugC3ulVYQ9urmowzHZZasyNapUT2g27KeC2hy05Qr464Rl+4F4IXw6vUrtV/nCUQFSoBrdT1fZ+2PRlGiZkOMTfz7juPAQf1qb0ygfqhRVR7V4hvy/Bb2RMzebeXc/1KOQPtqhdH4aZjJZdFGax8M92NYjSJnYiL/d1++trW7dLeGlxs/sYhMgGWhsEAx8RNUrvoaloek0Pdm/pfFlVsbrRCS+3o1lbAW75egLDEgVrM2qwm+XVe0lavrm+P+zsfsQOCkCHCNJEjBZJl56efR3c0vSpfCJIs5nKWof3TYdyfoJut9qfhtcIo52K1mVAZVMj5DahqzTd73SkdqDg3T/Z1gFZHeVurXNV1sDDeTgiM4B59jcndplSwXfq9JONzOFd1sMT4m5wU7gc+lXyz3Q9LZVDfgJmx/52p825n56GhRcjUAC47ThuiP0c+ckP0cD6hX184M3VrrRFBv7SU3rvVNIBlxasguKolIisaQKDRwFFAWKtmJkOUr5KRv+JHSsrcOTxYr68O+k3dtVFucYesY9wi09kCDafx0FxUYMtLgd2hih1zs+sRNOYCGbYegILgbRRA1xgTtZF7rIDJrBaZgX1z3J6LoO5pc2mP0RvijcMN9O5BXfjmq6b1lB+dSoqFYh7iKiAoi/hrvAvVhASN1i2x0fF6spl/P1+nNbhUnw5
 yzbUJRCc
 ZcEAsvyN/FqdfRddXm3CqQhdpA/j0DTv5pjRNlNT8JvUg754WAbz2/ocGYvHyEdOIdYdQQ6IgdPSrCk7MqCt5I9gjAtfq978W5nbLnfff5oRawdkkGFGdVNdMpNQbU4/SfUQC5oVSjZHW8rq+TOQhf5ty6EdCkIQWwBWpltVLpRonGcOsIwoOY8viOdq/yzYvxTdKgHl1VYplno9uqlUqmgdBEs1k9vLLrdR/O6XnRVaTBroH64JtYe9oTdhh/92OEtsIH4/XFapjCP+spfak3fL8jmz8kEjkufcJpRh3ANl0viwfTx5LMjbrOgjy3IYPKyJgZsDlnJuERcIAGX3ayDkD2uFu/vAXtr25heJ+KNC93CrvKWXoDbHPPCjBCcMCUX2q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, zram writeback supports only a single bio writeback
operation, waiting for bio completion before post-processing
next pp-slot.  This works, in general, but has certain throughput
limitations.  Introduce batched (multiple) bio writeback support
to take advantage of parallel requests processing and better
requests scheduling.

For the time being the writeback batch size (maximum number of
in-flight bio requests) is set to 32 for all devices.  A follow
up patch adds a writeback_batch_size device attribute, so the
batch size becomes run-time configurable.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Co-developed-by: Yuwen Chen <ywen.chen@foxmail.com>
Co-developed-by: Richard Chang <richardycc@google.com>
Suggested-by: Minchan Kim <minchan@google.com>
---
 drivers/block/zram/zram_drv.c | 366 +++++++++++++++++++++++++++-------
 1 file changed, 298 insertions(+), 68 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a43074657531..37c1416ac902 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -500,6 +500,24 @@ static ssize_t idle_store(struct device *dev,
 }
 
 #ifdef CONFIG_ZRAM_WRITEBACK
+struct zram_wb_ctl {
+	struct list_head idle_reqs;
+	struct list_head done_reqs;
+	wait_queue_head_t done_wait;
+	spinlock_t done_lock;
+	atomic_t num_inflight;
+};
+
+struct zram_wb_req {
+	unsigned long blk_idx;
+	struct page *page;
+	struct zram_pp_slot *pps;
+	struct bio_vec bio_vec;
+	struct bio bio;
+
+	struct list_head entry;
+};
+
 static ssize_t writeback_limit_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -734,19 +752,220 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 	submit_bio(bio);
 }
 
-static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
+static void release_wb_req(struct zram_wb_req *req)
 {
-	unsigned long blk_idx = 0;
-	struct page *page = NULL;
-	struct zram_pp_slot *pps;
-	struct bio_vec bio_vec;
-	struct bio bio;
+	__free_page(req->page);
+	kfree(req);
+}
+
+static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
+{
+	if (!wb_ctl)
+		return;
+
+	/* We should never have inflight requests at this point */
+	WARN_ON(atomic_read(&wb_ctl->num_inflight));
+	WARN_ON(!list_empty(&wb_ctl->done_reqs));
+
+	while (!list_empty(&wb_ctl->idle_reqs)) {
+		struct zram_wb_req *req;
+
+		req = list_first_entry(&wb_ctl->idle_reqs,
+				       struct zram_wb_req, entry);
+		list_del(&req->entry);
+		release_wb_req(req);
+	}
+
+	kfree(wb_ctl);
+}
+
+/* XXX: should be a per-device sysfs attr */
+#define ZRAM_WB_REQ_CNT 32
+
+static struct zram_wb_ctl *init_wb_ctl(void)
+{
+	struct zram_wb_ctl *wb_ctl;
+	int i;
+
+	wb_ctl = kmalloc(sizeof(*wb_ctl), GFP_KERNEL);
+	if (!wb_ctl)
+		return NULL;
+
+	INIT_LIST_HEAD(&wb_ctl->idle_reqs);
+	INIT_LIST_HEAD(&wb_ctl->done_reqs);
+	atomic_set(&wb_ctl->num_inflight, 0);
+	init_waitqueue_head(&wb_ctl->done_wait);
+	spin_lock_init(&wb_ctl->done_lock);
+
+	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
+		struct zram_wb_req *req;
+
+		/*
+		 * This is fatal condition only if we couldn't allocate
+		 * any requests at all.  Otherwise we just work with the
+		 * requests that we have successfully allocated, so that
+		 * writeback can still proceed, even if there is only one
+		 * request on the idle list.
+		 */
+		req = kzalloc(sizeof(*req), GFP_KERNEL | __GFP_NOWARN);
+		if (!req)
+			break;
+
+		req->page = alloc_page(GFP_KERNEL | __GFP_NOWARN);
+		if (!req->page) {
+			kfree(req);
+			break;
+		}
+
+		list_add(&req->entry, &wb_ctl->idle_reqs);
+	}
+
+	/* We couldn't allocate any requests, so writeabck is not possible */
+	if (list_empty(&wb_ctl->idle_reqs))
+		goto release_wb_ctl;
+
+	return wb_ctl;
+
+release_wb_ctl:
+	release_wb_ctl(wb_ctl);
+	return NULL;
+}
+
+static void zram_account_writeback_rollback(struct zram *zram)
+{
+	spin_lock(&zram->wb_limit_lock);
+	if (zram->wb_limit_enable)
+		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
+	spin_unlock(&zram->wb_limit_lock);
+}
+
+static void zram_account_writeback_submit(struct zram *zram)
+{
+	spin_lock(&zram->wb_limit_lock);
+	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
+		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
+	spin_unlock(&zram->wb_limit_lock);
+}
+
+static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
+{
+	u32 index = req->pps->index;
+	int err;
+
+	err = blk_status_to_errno(req->bio.bi_status);
+	if (err) {
+		/*
+		 * Failed wb requests should not be accounted in wb_limit
+		 * (if enabled).
+		 */
+		zram_account_writeback_rollback(zram);
+		free_block_bdev(zram, req->blk_idx);
+		return err;
+	}
+
+	atomic64_inc(&zram->stats.bd_writes);
+	zram_slot_lock(zram, index);
+	/*
+	 * We release slot lock during writeback so slot can change under us:
+	 * slot_free() or slot_free() and zram_write_page(). In both cases
+	 * slot loses ZRAM_PP_SLOT flag. No concurrent post-processing can
+	 * set ZRAM_PP_SLOT on such slots until current post-processing
+	 * finishes.
+	 */
+	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
+		free_block_bdev(zram, req->blk_idx);
+		goto out;
+	}
+
+	zram_free_page(zram, index);
+	zram_set_flag(zram, index, ZRAM_WB);
+	zram_set_handle(zram, index, req->blk_idx);
+	atomic64_inc(&zram->stats.pages_stored);
+
+out:
+	zram_slot_unlock(zram, index);
+	return 0;
+}
+
+static void zram_writeback_endio(struct bio *bio)
+{
+	struct zram_wb_req *req = container_of(bio, struct zram_wb_req, bio);
+	struct zram_wb_ctl *wb_ctl = bio->bi_private;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wb_ctl->done_lock, flags);
+	list_add(&req->entry, &wb_ctl->done_reqs);
+	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
+
+	wake_up(&wb_ctl->done_wait);
+}
+
+static void zram_submit_wb_request(struct zram *zram,
+				   struct zram_wb_ctl *wb_ctl,
+				   struct zram_wb_req *req)
+{
+	/*
+	 * wb_limit (if enabled) should be adjusted before submission,
+	 * so that we don't over-submit.
+	 */
+	zram_account_writeback_submit(zram);
+	atomic_inc(&wb_ctl->num_inflight);
+	req->bio.bi_private = wb_ctl;
+	submit_bio(&req->bio);
+}
+
+static int zram_complete_done_reqs(struct zram *zram,
+				   struct zram_wb_ctl *wb_ctl)
+{
+	struct zram_wb_req *req;
+	unsigned long flags;
 	int ret = 0, err;
-	u32 index;
 
-	page = alloc_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
+	while (1) {
+		spin_lock_irqsave(&wb_ctl->done_lock, flags);
+		req = list_first_entry_or_null(&wb_ctl->done_reqs,
+					       struct zram_wb_req, entry);
+		if (req)
+			list_del(&req->entry);
+		spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
+
+		if (!req)
+			break;
+
+		err = zram_writeback_complete(zram, req);
+		if (err)
+			ret = err;
+
+		atomic_dec(&wb_ctl->num_inflight);
+		release_pp_slot(zram, req->pps);
+		req->pps = NULL;
+
+		list_add(&req->entry, &wb_ctl->idle_reqs);
+	}
+
+	return ret;
+}
+
+static struct zram_wb_req *zram_select_idle_req(struct zram_wb_ctl *wb_ctl)
+{
+	struct zram_wb_req *req;
+
+	req = list_first_entry_or_null(&wb_ctl->idle_reqs,
+				       struct zram_wb_req, entry);
+	if (req)
+		list_del(&req->entry);
+	return req;
+}
+
+static int zram_writeback_slots(struct zram *zram,
+				struct zram_pp_ctl *ctl,
+				struct zram_wb_ctl *wb_ctl)
+{
+	struct zram_wb_req *req = NULL;
+	unsigned long blk_idx = 0;
+	struct zram_pp_slot *pps;
+	int ret = 0, err = 0;
+	u32 index = 0;
 
 	while ((pps = select_pp_slot(ctl))) {
 		spin_lock(&zram->wb_limit_lock);
@@ -757,6 +976,27 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 		}
 		spin_unlock(&zram->wb_limit_lock);
 
+		while (!req) {
+			req = zram_select_idle_req(wb_ctl);
+			if (req)
+				break;
+
+			wait_event(wb_ctl->done_wait,
+				   !list_empty(&wb_ctl->done_reqs));
+
+			err = zram_complete_done_reqs(zram, wb_ctl);
+			/*
+			 * BIO errors are not fatal, we continue and simply
+			 * attempt to writeback the remaining objects (pages).
+			 * At the same time we need to signal user-space that
+			 * some writes (at least one, but also could be all of
+			 * them) were not successful and we do so by returning
+			 * the most recent BIO error.
+			 */
+			if (err)
+				ret = err;
+		}
+
 		if (!blk_idx) {
 			blk_idx = alloc_block_bdev(zram);
 			if (!blk_idx) {
@@ -775,67 +1015,47 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 		 */
 		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
-		if (zram_read_from_zspool(zram, page, index))
+		if (zram_read_from_zspool(zram, req->page, index))
 			goto next;
 		zram_slot_unlock(zram, index);
 
-		bio_init(&bio, zram->bdev, &bio_vec, 1,
-			 REQ_OP_WRITE | REQ_SYNC);
-		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
-		__bio_add_page(&bio, page, PAGE_SIZE, 0);
-
 		/*
-		 * XXX: A single page IO would be inefficient for write
-		 * but it would be not bad as starter.
+		 * From now on pp-slot is owned by the req, remove it from
+		 * its pp bucket.
 		 */
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
+		list_del_init(&pps->entry);
 
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
+		req->blk_idx = blk_idx;
+		req->pps = pps;
+		bio_init(&req->bio, zram->bdev, &req->bio_vec, 1, REQ_OP_WRITE);
+		req->bio.bi_iter.bi_sector = req->blk_idx * (PAGE_SIZE >> 9);
+		req->bio.bi_end_io = zram_writeback_endio;
+		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
 
-		zram_free_page(zram, index);
-		zram_set_flag(zram, index, ZRAM_WB);
-		zram_set_handle(zram, index, blk_idx);
+		zram_submit_wb_request(zram, wb_ctl, req);
 		blk_idx = 0;
-		atomic64_inc(&zram->stats.pages_stored);
-		spin_lock(&zram->wb_limit_lock);
-		if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
-			zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
-		spin_unlock(&zram->wb_limit_lock);
+		req = NULL;
+		cond_resched();
+		continue;
+
 next:
 		zram_slot_unlock(zram, index);
 		release_pp_slot(zram, pps);
-
-		cond_resched();
 	}
 
-	if (blk_idx)
-		free_block_bdev(zram, blk_idx);
-	if (page)
-		__free_page(page);
+	/*
+	 * Selected idle req, but never submitted it due to some error or
+	 * wb limit.
+	 */
+	if (req)
+		release_wb_req(req);
+
+	while (atomic_read(&wb_ctl->num_inflight) > 0) {
+		wait_event(wb_ctl->done_wait, !list_empty(&wb_ctl->done_reqs));
+		err = zram_complete_done_reqs(zram, wb_ctl);
+		if (err)
+			ret = err;
+	}
 
 	return ret;
 }
@@ -948,7 +1168,8 @@ static ssize_t writeback_store(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 	u64 nr_pages = zram->disksize >> PAGE_SHIFT;
 	unsigned long lo = 0, hi = nr_pages;
-	struct zram_pp_ctl *ctl = NULL;
+	struct zram_pp_ctl *pp_ctl = NULL;
+	struct zram_wb_ctl *wb_ctl = NULL;
 	char *args, *param, *val;
 	ssize_t ret = len;
 	int err, mode = 0;
@@ -970,8 +1191,14 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
-	ctl = init_pp_ctl();
-	if (!ctl) {
+	pp_ctl = init_pp_ctl();
+	if (!pp_ctl) {
+		ret = -ENOMEM;
+		goto release_init_lock;
+	}
+
+	wb_ctl = init_wb_ctl();
+	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
 	}
@@ -1000,7 +1227,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			break;
 		}
 
@@ -1011,7 +1238,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			break;
 		}
 
@@ -1022,7 +1249,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			continue;
 		}
 
@@ -1033,17 +1260,18 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			continue;
 		}
 	}
 
-	err = zram_writeback_slots(zram, ctl);
+	err = zram_writeback_slots(zram, pp_ctl, wb_ctl);
 	if (err)
 		ret = err;
 
 release_init_lock:
-	release_pp_ctl(zram, ctl);
+	release_pp_ctl(zram, pp_ctl);
+	release_wb_ctl(wb_ctl);
 	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
 
@@ -1112,7 +1340,9 @@ static int read_from_bdev(struct zram *zram, struct page *page,
 	return -EIO;
 }
 
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx) {};
+static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+{
+}
 #endif
 
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
-- 
2.52.0.rc1.455.g30608eb744-goog


