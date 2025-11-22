Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B612ECF64B1
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 07:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693526B0007; Sat, 22 Nov 2025 02:40:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3196B0008; Sat, 22 Nov 2025 02:40:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2FE6B000C; Sat, 22 Nov 2025 02:40:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 251FF6B0007
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:40:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7CBC13BB14
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:40:53 +0000 (UTC)
X-FDA: 84137446386.26.96CD252
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id E62BD20002
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:40:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="g/veclAt";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763797252; a=rsa-sha256;
	cv=none;
	b=WCuMvQIvL3M8OEJTu5LkQM7EPyPu75pQwoERzwdb/KCx6Y2IggtWTgQav18zhMIb4DTiLG
	sHkL2BbBHDyFkW0q0LSVPHTwO2B1b31I4Ntshu+MjoTiAb6pXECWugM2oBcGEl5yilzgBY
	FgeVZjKQDetjobmMyQ5BnZ/bUIJu6b8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="g/veclAt";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763797252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CcYw/MVsIvV8b2h3Sq9n03D/rQEvwWc9LbzmpgrKxs=;
	b=u8QRgniXNzdq8dstpZWnCigXC/9VP9jk/CAqnm8kmXXPPnMrkAO/Ac06udSRkg5JW+Ow9S
	Awj0/6pW50ofwTv04Ah4ZKnkG1JM+pK7qkCLip2rn1ayxxNTeMr/qX16XUUvzfRYJ/cuT9
	MiBD5UewrTBYwEm8pxlvM5IvRgN4t10=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29568d93e87so25397935ad.2
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763797251; x=1764402051; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CcYw/MVsIvV8b2h3Sq9n03D/rQEvwWc9LbzmpgrKxs=;
        b=g/veclAtAzm7qojzgbevd8de0KIM+V3bTb3a0lVghtP6i5tDANVgBXUfLKu18sv9oh
         dkb265J0GzX0ZyGp/sT7bvAChVAV5gIv5rW3JapJRIcASRE5LSMw9YD0YDc+texC1lLs
         NLX1q24FjlPUwrjtAIfTCpJQUj25AFdKSPp/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763797251; x=1764402051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+CcYw/MVsIvV8b2h3Sq9n03D/rQEvwWc9LbzmpgrKxs=;
        b=G+Pbvu1USzWEiK0hIPBqdFOaHiWHMR15pDyBn1n6H3T3IMcoGiZjGh2g+PqS9nvSAa
         fS8p3idKFOFZeSDWrmscdY2wpwgpIUo61j5b7drUekqaUsc4TsKUcm5V+/hVkzLc0XH7
         85Y5gHIMiNU/pr3Y7FDeUP3pDPfgf86mRDU90vxvUEM+854Ucq9z+PJb+jtxpQYAIiiV
         JWVx1+YxjwSLeZWjXFLDjHRAJ9lvix65egwQzcaQXIBgRN9nhSbxlLxCLaZzMigTyzdf
         Qp165xdmX/sYBv8UpjExRiL7aggOBomCMbX6zKFa8rjlxaYG0Mnr9rohG4TMRM9YjLKN
         aMqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHJVwANRIyGpEmW+n8Skbmk8JwlkS9/0uuLQmSCsJpS7wohhgSyyb4y0j9IVsZL6GJNOfXcv0mUQ==@kvack.org
X-Gm-Message-State: AOJu0Yx64/q8crzj3vAptpwFVl6qO0nrvCxz+DTeHV6td4jP0hX+nW7M
	YclVcaXJmNnTJEJl4u/Hp0EXeqj5gnr7FHetF/5M+Ly/6GD+tnqQAJyW/S2Iv/uStA==
X-Gm-Gg: ASbGncvKXGMovab+AIZGW0a/b44zA0wrhs9Si3vpf2+z9bdgdYqfOWlOnexyHpj/BjE
	Hlygcb1PIp/+FekL27ialAi0gDbsjFH4BCTrZlfeWA4Wx/nasQLa6Jtw0E484TstchTCYsUJl8S
	qrl6YjJmQgrNa113GlOa/xBeSoy4WSonR3/+9mRKsjZfvZrSul+CwwHoYOSIV4ESSWk6yIwW1xr
	F4y0DOa7jm8y2bUUeuP93QEpxjI3JWN+rR8d7CNUfnC4Y0u3tfckxEImDopCVUwvvuRN8h5yMRe
	6pVagmthzZr62emZw6Kas4Z2BWGF223yUUO+TeOMlEbDZ76At9r03eWgaMMr3RWenueVDxSTWlh
	c7gOdGJLroyzbjPxMRSqX8bPSmUDt6O7tmF7aO9QE0SKrfaXMYqzrYeSun9mqtT5K0XmBfbWoQv
	ytD0Pp+P6HsGsnRKgimO2iq6dviLcTzyCSYanoXofb1IsXQGriSyBtSChdIckm6JW+UHp0mJ4jl
	A==
X-Google-Smtp-Source: AGHT+IFaSB7EbqaBfaqnc96XqHJ3nI/Cc67lkuc7fRADR0xDZSv+4CDROktulCgD73hI6bhlKxOYWg==
X-Received: by 2002:a17:902:e809:b0:295:738f:73fe with SMTP id d9443c01a7336-29b6bf385e6mr72914675ad.30.1763797250758;
        Fri, 21 Nov 2025 23:40:50 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:948e:149d:963b:f660])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b138628sm77771555ad.31.2025.11.21.23.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 23:40:50 -0800 (PST)
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
Subject: [PATCHv6 1/6] zram: introduce writeback bio batching
Date: Sat, 22 Nov 2025 16:40:24 +0900
Message-ID: <20251122074029.3948921-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251122074029.3948921-1-senozhatsky@chromium.org>
References: <20251122074029.3948921-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E62BD20002
X-Stat-Signature: xuondddug9eh7zw8wrjjw54e719pyim7
X-Rspam-User: 
X-HE-Tag: 1763797251-794115
X-HE-Meta: U2FsdGVkX18VNFKJLy7VJhvmO03fSBPgwPKR6z7f/DpqsSsavYNAv4cK1sjvURCV/YXz99axXjn0h6/LAKb0vK0QRvjE/gv1a2BbzqRDxbQEN32q0OsddQwajybEzYoCyJb5CM9tE/8vk1tw4uYQH6MctJvv9lPHStM5B/6wba5ln9IIIGMcmhocksQ5XpertR92SZhaOKXrAMDwavh4aW6cQPIhQnzcphtREoxoD8E7FY2auE2Xb62GaQ7cWTD2dmnUmv05zyUNiZUgrHMzJ03yfFm/6Jz1j8rXpb1iJe6iBjG8UbHowf4hwP7INadVQjkxOq1cc5Fwd/P9kZ6+mwSKjGZwM6i4tFVzE6MHA/RgLmv/y5fHd3f7f4KyY0XSVE0nU1ubCRFh5vPgC+23IbFVnzYez4cX1/uZ0Lln448KlV2Wew97aJrK40DNYkRFwnOP7mae59ibMXP21cKmgDG0RuLpED+IqSd1yZ6YdhklAV+VUDKNAElEotdR93fUhJoOO6BJ13FVjN1ovb0fb7HyPT+7qRjkXefxNLy5LA4qVvtSg9vCEelIVm7qnxmotQbdCdi866LvPaqYkFlHBWFn+hoN141eQuOAzxQEJ4sHPMrZjFfWJ8KZZq6wUetCiaftBmriL8OFPnv+fbQcHYGrcPwHf2J1KyWHV+gq2sH8Cw98k8TeF9Ndc8Gt9ujl19M3EJrgdwaKpuzVUOAu9Y/DbtV8M+Lg60xVahqfox4K9U5iAxlB2qJ7mxHOTXpItMfL2Nefw58r3biQMVnIZCNXgNdD3poA0PxN0tsS7QJE1fTFtk68EW3JWZirZz+r6BVO9dwk1rDWDClWEurYE0mfwhs1X2Jc0epjS6+EaUbzmRh1mr45ZnKG9LvMw4f23PHZrBpekRvyME+ggUCqbLzJYe9YWc79r6Zzdzvu/GvkyaAhwISIvbem9Cg+y6xtkKqVzAmKs2NyOv9q0Ds
 WkK3KzaP
 2wka/SQQykFUp2t/QfePuyYqGBjZskqYwtnW78WTsTSCdBcxyK0vUilna76jWUjf7SjL5+aQPZ1w9b4sSRvMmzI0Sjsza68FTX1kvVxE+P9mmjF5qBEst/TrV94du8zWYWW57t48Lh2jOe8mR5xicnP50ozOHY9q14dsESCixUNvQeahoG1FsAy1o0aURsd86btETjy2iohBck6WPBWZM6hvtXdKtLdZ87dbWYLjHe4LiNdI8siK8hHRqRZ283zwqFDsPuPXw761ixIo12/uCvIq9/tEvFjVP2yv0vrKdEKZy6de3ngzcAX1n1glVtlm7mW2X8tPuGPjI7dc6e2RVbMW4f5O69ZWpS4nmLzFp0zPuQBsaiVSAqb5GZWxwHc/aDgnA/2aqdGcwYHLYXlNCZUZL8QyMK8HmnrGs6TtCh5t3rL3VBoXNlpzCtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As was stated in a comment [1] a single page writeback IO
is not efficient, but it works.  It's time to address this
throughput limitation as writeback becomes used more often.
Introduce batched (multiple) bio writeback support to take
advantage of parallel requests processing and better requests
scheduling.

Approach used in this patch doesn't use a dedicated kthread
like in [2], or blk-plug like in [3].  Dedicated kthread adds
complexity, which can be avoided.  Apart from that not all
zram setups use writeback, so having numerous per-device
kthreads (on systems that create multiple zram devices)
hanging around is not the most optimal thing to do.  blk-plug,
on the other hand, works best when request are sequential,
which doesn't particularly fit zram writebck IO patterns: zram
writeback IO patterns are expected to be random, due to how
bdev block reservation/release are handled.  blk-plug approach
also works in cycles: idle IO, when zram sets up requests in
a batch, is followed by bursts of IO, when zram submits the
entire batch.

Instead we use a batch of requests and submit new bio as soon
as one of the in-flight requests completes.

For the time being the writeback batch size (maximum number of
in-flight bio requests) is set to 32 for all devices.  A follow
up patch adds a writeback_batch_size device attribute, so the
batch size becomes run-time configurable.

[1] https://lore.kernel.org/all/20181203024045.153534-6-minchan@kernel.org/
[2] https://lore.kernel.org/all/20250731064949.1690732-1-richardycc@google.com/
[3] https://lore.kernel.org/all/tencent_78FC2C4FE16BA1EBAF0897DB60FCD675ED05@qq.com/

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Co-developed-by: Yuwen Chen <ywen.chen@foxmail.com>
Co-developed-by: Richard Chang <richardycc@google.com>
Suggested-by: Minchan Kim <minchan@google.com>
---
 drivers/block/zram/zram_drv.c | 369 +++++++++++++++++++++++++++-------
 1 file changed, 301 insertions(+), 68 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a43074657531..06ea56f0a00f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -500,6 +500,26 @@ static ssize_t idle_store(struct device *dev,
 }
 
 #ifdef CONFIG_ZRAM_WRITEBACK
+struct zram_wb_ctl {
+	/* idle list is accessed only by the writeback task, no concurency */
+	struct list_head idle_reqs;
+	/* done list is accessed concurrently, protect by done_lock */
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
@@ -734,19 +754,221 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
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
+	while (atomic_read(&wb_ctl->num_inflight) > 0) {
+		spin_lock_irqsave(&wb_ctl->done_lock, flags);
+		req = list_first_entry_or_null(&wb_ctl->done_reqs,
+					       struct zram_wb_req, entry);
+		if (req)
+			list_del(&req->entry);
+		spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
+
+		/* ->num_inflight > 0 doesn't mean we have done requests */
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
@@ -757,6 +979,27 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
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
@@ -775,67 +1018,47 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
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
@@ -948,7 +1171,8 @@ static ssize_t writeback_store(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 	u64 nr_pages = zram->disksize >> PAGE_SHIFT;
 	unsigned long lo = 0, hi = nr_pages;
-	struct zram_pp_ctl *ctl = NULL;
+	struct zram_pp_ctl *pp_ctl = NULL;
+	struct zram_wb_ctl *wb_ctl = NULL;
 	char *args, *param, *val;
 	ssize_t ret = len;
 	int err, mode = 0;
@@ -970,8 +1194,14 @@ static ssize_t writeback_store(struct device *dev,
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
@@ -1000,7 +1230,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			break;
 		}
 
@@ -1011,7 +1241,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			break;
 		}
 
@@ -1022,7 +1252,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			continue;
 		}
 
@@ -1033,17 +1263,18 @@ static ssize_t writeback_store(struct device *dev,
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
 
@@ -1112,7 +1343,9 @@ static int read_from_bdev(struct zram *zram, struct page *page,
 	return -EIO;
 }
 
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx) {};
+static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+{
+}
 #endif
 
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
-- 
2.52.0.460.gd25c4c69ec-goog


