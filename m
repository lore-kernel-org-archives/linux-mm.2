Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B8FCCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 06:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3B68E0003; Wed,  5 Nov 2025 01:48:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7542E8E0002; Wed,  5 Nov 2025 01:48:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642318E0003; Wed,  5 Nov 2025 01:48:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEDF8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:48:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE0F6864DB
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:48:40 +0000 (UTC)
X-FDA: 84075625200.29.F5B9805
Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	by imf08.hostedemail.com (Postfix) with ESMTP id EFEF5160004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:48:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=fBwuo9Oo;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf08.hostedemail.com: domain of ywen.chen@foxmail.com designates 203.205.221.221 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762325318; a=rsa-sha256;
	cv=none;
	b=ZLIo1KY8JBnNNruXklh8Vp5/wvE1qt7piBK8isDnQpSbzQqee8Qfzc5PTbB5gDxALe5FQK
	cn1EFI/BTTb1cZaSuwx/MctU8OsW0MlFD3Il1g9EkZQ1LsRSBVeov+B8T6gAMRFjP2ohK3
	5BVdB8V0tX28Q5zuUcFCTgluhAv9H6Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=fBwuo9Oo;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf08.hostedemail.com: domain of ywen.chen@foxmail.com designates 203.205.221.221 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762325318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mq0JclBaKBy4TWJ/ryyvsbPzM+n7z5k9LWVUwRw09pg=;
	b=JtgWZg+qvUu7eJRf6YWJFhksbxupCnKnkuBFBs8bj7jBuXFAG2Va5BP0GnogLob7cjX1+7
	0qWKDU2pfEF7rPF9LdpCaEcbKPAVYrNwPFOe+hftavaBJxx631f4O8DGpyYsQsaijapLx7
	h/JPIptNevA4t0cQZKo423U6bYMYQGE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1762325312;
	bh=mq0JclBaKBy4TWJ/ryyvsbPzM+n7z5k9LWVUwRw09pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBwuo9Ooq62rV4AK4peYDAo7vU7VFLQYQPfFGe2OLvcegO8T2mBvfD0DhulwmXE8h
	 L8Hhx4meoz0cRWpb6RueI2BwHJ/FTSnMEO9jdD92/aWwhF2vajyqha1lexTU/8Q501
	 ZTlqksPpgot1oj1BbR6cpShNlrsLUF3gnYRl4AaQ=
Received: from meizu-Precision-3660.meizu.com ([112.91.84.72])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id C09020D0; Wed, 05 Nov 2025 14:48:09 +0800
X-QQ-mid: xmsmtpt1762325289tzwix3fmp
Message-ID: <tencent_25F89AABFE39535EF957519750D107B7D406@qq.com>
X-QQ-XMAILINFO: MfXlhb1xJpsOoWvb9KDTSsn7+G3+IQwE/kGDDi09Bd4UMOaaXP8X4IJ2J3rzLL
	 MUSe1cNV5v19tJRYJSI1BAfSvmtabJBs+6WgDlzlkoF+gHPYEhST8P4nqHjmYPH/4T4WmYE/Mo+t
	 vhBuU6tI8N93MJydEZzJ0lRHAY+SzpOWNmwUBnKNnH0EFVWOTA0gr3NKZFthWWW6U/SS8Ir0lQ5w
	 wPAgA7ae2V0Pyi9AjZ1thW55/Y1kl2qYAq3JKkfe2Xk+DjryxfG1r6QXnsQQF0BCxgNv8gdVb2k3
	 UzxujK5VlTdGzchyS0X9/gl16zOMCD9p1Pg1O3CTxmSgi2LXLIyJPigRYgBnSCln++4QLC24NiFG
	 K0t6XcfSLPlV/oR0Fob8WEsyj5BtUGPbm31/7+OPXUhYYbN9LKx2xaqBlgtKTz98Kri+twmPOJu8
	 QWLdrY/ytBNcccFM/3CVMwdrry0HFRZ1n0UBkN4hFwaUegUFPUOhz1G3A55zB1YaFzOEP3SLxVWe
	 7K39ikWXeLo0c3SrDQwkTH2Zrc7LWsOudZtvo0DqLzZMERVlN2iAGvKjnTSojfSj1Brx94nmiQja
	 75LklGflGKDx4uWMO/f/kCWgcE17vtXATgDD+SF4XNLRXI799yitsBW/BDxftGR361ST4iZSjMop
	 OMaOp+E1Mk22OmXEYPq6wGwoxuVIZU8yWFA92RkxLyVHUP+lb+g7XAzKtdAlsZJ2SiHlUXwWv2FY
	 FkWRbOMTxQWe4Z89PvBhDc3xPo4j20iIUMy5RKerO96GR05+LrobD/AfeJl1Q3Hh3C49wEJwUxfa
	 YVV6Njp5p+PQw/7IEU2CmDYFm197mj/5ODR0QET1DlBo6OSXQUTiBJcYulIK5/37D2veYz66KlcP
	 +GwashhllGX9/RvhWuik3w45JFZAGBmN3oVd0CTnjOe9v4tO8CCyC0JBDCLiz7wxo827vW7Kzq10
	 lXivwfbliMbVMiRiW4Kg3GpdSt8vwvizMgdfHczCWgyFiytVJ1xCepySpvTsFURs9XTF+bwFER3I
	 JVqqYU7w4/toK3h1Quvdaa4JnJRmcMMenNcS+o6SZhPHe+BQppI3TQYQtllTG8uTy0eVAvIGyL1N
	 nL7W5QN7j+4qdBdXE=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: ywen.chen@foxmail.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liumartin@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	senozhatsky@chromium.org
Subject: [PATCH v3] zram: Implement multi-page write-back
Date: Wed,  5 Nov 2025 14:48:06 +0800
X-OQ-MSGID: <20251105064806.2693018-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_85F14CD7BA73843CA32FF7AEB6A21A6EC907@qq.com>
References: <tencent_85F14CD7BA73843CA32FF7AEB6A21A6EC907@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EFEF5160004
X-Rspamd-Server: rspam07
X-Stat-Signature: teczcxz11g7ygme4pbw6pdigri95exne
X-Rspam-User: 
X-HE-Tag: 1762325317-304777
X-HE-Meta: U2FsdGVkX1+srTYZ3sG8qCxiAwsISqWhP6W4DG6shjwoPTyMaQd35i2FfsyXVTyrbSN55hDx7kv2OW/Gie7UHCA63qaz+y9OxXUPoiXs/PKm5JI6xB3y8DG8xRacrBU2lvIo3XUc8K3CiysTdHjRh6g/WSwwxGOLWCC9EoERdoHFbQIU6yzURV3IVO7FiBglQO4R6EE5giNGqji/tlu8ODMCWbJ3TmU+mtNNkr7tIvAN4xory5HtjcCWrMiIdCV/SHXbitjz1TQSThOcciBsRXnX9mqndOc4E5lZg1LNMDdc7oEfBwnb2XLmfdMtyRgCE8Tu9tHDNIoxZeBaca2ZYPKxSDTAlzFvDrWN/faqURZKKxOQ+NLhPV6j5jDYT/D2KbbI9iO2AB8P1XTn5YAegv7Fnl4w3RLho4MNua5fRXFM+Uk6Fxe32oD9Tnev6gOWP0PXhSjeE9dFATIiGGBBOeJdyZj5bMxHcs9PdktORzX7L8Z8fTIjQx3Gy/Qp/y6+zDfkPWLAwP07IPUF3xn3XfJ21qJ2aSKtFE24ATOuHEFbAsKqTeujeBuK9/9iIw1Az6289fpQ+UgQu6XdY88Hc2lc0XlBAvULKIbusHDLALqlG0q4WIPq16urNmeKzQmHTc7kFSAWjpIPCssJV44puhtKFxeHAhLIvd9douN5C7ZmtvMFIIMKmQZoim0943reGUBChONI0CLIIRHb0+gYpd8XAOYlYnMlNLKjKwaqqkB+xoH2P0IpZcdHuugL7AVl7N/weqglLiEZebMu48mDp1hoBz2gXw2YJd0SsrmxiM0go8cYRsH5JtvRAbPlBH778WfyQu29M5E7TWZxz7LVy7x15pp6lMOviBn9R1x0XC6+OEBTLVCnj/c/DAiO59vCLlngkLMBxHKRSabsJc10IL9+xuMPtrIBaVoRux5385ycm6Tj7s7sKqYrSpvnlPA3MdivITTDnVddVRsZxYe
 xUZ/eAX7
 R9X/bsCoD+ovPknNumymFhGXgwCOgFzg4O/lG2jUHYMpeqUwO4GYQC23ib/7QJRnkoezQGco+IqkRGAMy0/nVn1izxCdVpzcN1dP5fgEpAnfXcGcZoK7aB5oQTYN3RYuSxqHrGqbnoIfKA5KDG3gs3bv65m7SkeYaEyHSKwnJGk/osldXyHeYk1BSS5zjL5vu4x4QKhFngPaHOW/J7Ausx3XsCeUvr2y8yxrWQMkFmL+l3uVERxYn8/r5+Zdt1WmX5XvJWAbQbQ31rFNoa7AEfh8NkilSMRfCWR9jzeLU3NBbR3k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For block devices, sequential write performance is significantly
better than random write. Currently, zram's write-back function
only supports single-page operations, which fails to leverage
the sequential write advantage and leads to suboptimal performance.
This patch implements multi-page batch write-back for zram to
leverage sequential write performance of block devices.
After applying this patch, a large number of pages being merged
into batch write operations can be observed via the following test
code, which effectively improves write-back performance.

mount -t debugfs none /sys/kernel/debug/
echo "block:block_bio_frontmerge" >> /sys/kernel/debug/tracing/set_event
echo "block:block_bio_backmerge" >> /sys/kernel/debug/tracing/set_event
cat /sys/kernel/debug/tracing/trace_pipe &
echo "page_indexes=1-10000" > /sys/block/zram0/writeback

Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
Reviewed-by: Fengyu Lian <licayy@outlook.com>
---
Changes in v3:
  - Postpone the page allocation.
Changes in v2:
  - Rename some data structures.
  - Fix an exception caused by accessing a null pointer.
---
 drivers/block/zram/zram_drv.c | 224 ++++++++++++++++++++++++++--------
 1 file changed, 170 insertions(+), 54 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 4f2824a..ce8fc3c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -751,21 +751,131 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 	submit_bio(bio);
 }
 
-static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
-{
-	unsigned long blk_idx = 0;
-	struct page *page = NULL;
+enum {
+	/* Indicate that the request has been allocated */
+	ZRAM_WB_REQUEST_ALLOCATED = 0,
+
+	/* the request has been processed by the block device layer */
+	ZRAM_WB_REQUEST_COMPLETED,
+};
+
+struct zram_wb_request {
+	struct completion *done;
+	unsigned long blk_idx;
+	struct page *page;
 	struct zram_pp_slot *pps;
 	struct bio_vec bio_vec;
 	struct bio bio;
-	int ret = 0, err;
-	u32 index;
+	unsigned long flags;
+};
 
-	page = alloc_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
+static int zram_writeback_complete(struct zram *zram, struct zram_wb_request *req)
+{
+	u32 index = 0;
+	int err;
 
-	while ((pps = select_pp_slot(ctl))) {
+	if (!test_and_clear_bit(ZRAM_WB_REQUEST_COMPLETED, &req->flags))
+		return 0;
+
+	err = blk_status_to_errno(req->bio.bi_status);
+	if (err)
+		return err;
+
+	index = req->pps->index;
+	atomic64_inc(&zram->stats.bd_writes);
+	zram_slot_lock(zram, index);
+	/*
+	 * Same as above, we release slot lock during writeback so
+	 * slot can change under us: slot_free() or slot_free() and
+	 * reallocation (zram_write_page()). In both cases slot loses
+	 * ZRAM_PP_SLOT flag. No concurrent post-processing can set
+	 * ZRAM_PP_SLOT on such slots until current post-processing
+	 * finishes.
+	 */
+	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
+		goto next;
+
+	zram_free_page(zram, index);
+	zram_set_flag(zram, index, ZRAM_WB);
+	zram_set_handle(zram, index, req->blk_idx);
+	req->blk_idx = 0;
+	atomic64_inc(&zram->stats.pages_stored);
+	spin_lock(&zram->wb_limit_lock);
+	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
+		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
+	spin_unlock(&zram->wb_limit_lock);
+
+next:
+	zram_slot_unlock(zram, index);
+	release_pp_slot(zram, req->pps);
+	req->pps = NULL;
+	return 0;
+}
+
+static void zram_writeback_endio(struct bio *bio)
+{
+	struct zram_wb_request *req = bio->bi_private;
+
+	set_bit(ZRAM_WB_REQUEST_COMPLETED, &req->flags);
+	clear_bit(ZRAM_WB_REQUEST_ALLOCATED, &req->flags);
+	complete(req->done);
+}
+
+static struct zram_wb_request *zram_writeback_next_request(struct zram_wb_request *pool,
+	int pool_cnt, int *cnt_off)
+{
+	struct zram_wb_request *req = NULL;
+	int i = 0;
+
+	for (i = *cnt_off; i < pool_cnt + *cnt_off; i++) {
+		req = &pool[i % pool_cnt];
+		if (!req->page) {
+			/* This memory should be freed by the caller. */
+			req->page = alloc_page(GFP_KERNEL);
+			if (!req->page)
+				continue;
+		}
+
+		if (!test_and_set_bit(ZRAM_WB_REQUEST_ALLOCATED, &req->flags)) {
+			*cnt_off = (i + 1) % pool_cnt;
+			return req;
+		}
+	}
+	return NULL;
+}
+
+#define ZRAM_WB_REQ_CNT (32)
+static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
+{
+	int ret = 0, err, i = 0, cnt_off = 0;
+	int req_pool_cnt = 0;
+	struct zram_wb_request req_prealloc[2] = {0};
+	struct zram_wb_request *req = NULL, *req_pool = NULL;
+	DECLARE_COMPLETION_ONSTACK(done);
+	u32 index = 0;
+	struct blk_plug plug;
+
+	/* allocate memory for req_pool */
+	req_pool = kzalloc(sizeof(*req) * ZRAM_WB_REQ_CNT, GFP_KERNEL);
+	if (req_pool) {
+		req_pool_cnt = ZRAM_WB_REQ_CNT;
+	} else {
+		req_pool = req_prealloc;
+		req_pool_cnt = ARRAY_SIZE(req_prealloc);
+	}
+
+	for (i = 0; i < req_pool_cnt; i++) {
+		req_pool[i].done = &done;
+		req_pool[i].flags = 0;
+	}
+	req = zram_writeback_next_request(req_pool, req_pool_cnt, &cnt_off);
+	if (!req) {
+		ret = -ENOMEM;
+		goto out_free_req_pool;
+	}
+
+	blk_start_plug(&plug);
+	while ((req->pps = select_pp_slot(ctl))) {
 		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
 			spin_unlock(&zram->wb_limit_lock);
@@ -774,15 +884,15 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 		}
 		spin_unlock(&zram->wb_limit_lock);
 
-		if (!blk_idx) {
-			blk_idx = alloc_block_bdev(zram);
-			if (!blk_idx) {
+		if (!req->blk_idx) {
+			req->blk_idx = alloc_block_bdev(zram);
+			if (!req->blk_idx) {
 				ret = -ENOSPC;
 				break;
 			}
 		}
 
-		index = pps->index;
+		index = req->pps->index;
 		zram_slot_lock(zram, index);
 		/*
 		 * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
@@ -792,22 +902,32 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 		 */
 		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
-		if (zram_read_from_zspool(zram, page, index))
+		if (zram_read_from_zspool(zram, req->page, index))
 			goto next;
 		zram_slot_unlock(zram, index);
 
-		bio_init(&bio, zram->bdev, &bio_vec, 1,
+		bio_init(&req->bio, zram->bdev, &req->bio_vec, 1,
 			 REQ_OP_WRITE | REQ_SYNC);
-		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
-		__bio_add_page(&bio, page, PAGE_SIZE, 0);
-
-		/*
-		 * XXX: A single page IO would be inefficient for write
-		 * but it would be not bad as starter.
-		 */
-		err = submit_bio_wait(&bio);
+		req->bio.bi_iter.bi_sector = req->blk_idx * (PAGE_SIZE >> 9);
+		req->bio.bi_end_io = zram_writeback_endio;
+		req->bio.bi_private = req;
+		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
+
+		list_del_init(&req->pps->entry);
+		submit_bio(&req->bio);
+
+		do {
+			req = zram_writeback_next_request(req_pool, req_pool_cnt, &cnt_off);
+			if (!req) {
+				blk_finish_plug(&plug);
+				wait_for_completion_io(&done);
+				blk_start_plug(&plug);
+			}
+		} while (!req);
+		err = zram_writeback_complete(zram, req);
 		if (err) {
-			release_pp_slot(zram, pps);
+			release_pp_slot(zram, req->pps);
+			req->pps = NULL;
 			/*
 			 * BIO errors are not fatal, we continue and simply
 			 * attempt to writeback the remaining objects (pages).
@@ -817,43 +937,39 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 			 * the most recent BIO error.
 			 */
 			ret = err;
-			continue;
 		}
+		cond_resched();
+		continue;
 
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
-		blk_idx = 0;
-		atomic64_inc(&zram->stats.pages_stored);
-		spin_lock(&zram->wb_limit_lock);
-		if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
-			zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
-		spin_unlock(&zram->wb_limit_lock);
 next:
 		zram_slot_unlock(zram, index);
-		release_pp_slot(zram, pps);
-
+		release_pp_slot(zram, req->pps);
+		req->pps = NULL;
 		cond_resched();
 	}
+	blk_finish_plug(&plug);
 
-	if (blk_idx)
-		free_block_bdev(zram, blk_idx);
-	if (page)
-		__free_page(page);
+	if (req)
+		clear_bit(ZRAM_WB_REQUEST_ALLOCATED, &req->flags);
+	for (i = 0; i < req_pool_cnt; i++) {
+		while (test_bit(ZRAM_WB_REQUEST_ALLOCATED, &req_pool[i].flags))
+			wait_for_completion_io(&done);
+		err = zram_writeback_complete(zram, &req_pool[i]);
+		if (err) {
+			release_pp_slot(zram, req_pool[i].pps);
+			req->pps = NULL;
+			ret = err;
+		}
+
+		if (req_pool[i].blk_idx)
+			free_block_bdev(zram, req_pool[i].blk_idx);
+		if (req_pool[i].page)
+			__free_page(req_pool[i].page);
+	}
 
+out_free_req_pool:
+	if (req_pool != req_prealloc)
+		kfree(req_pool);
 	return ret;
 }
 
-- 
2.34.1


