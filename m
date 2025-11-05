Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E02CCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 03:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA368E0005; Tue,  4 Nov 2025 22:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1E98E0002; Tue,  4 Nov 2025 22:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7E78E0005; Tue,  4 Nov 2025 22:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDB3F8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 22:34:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 783C485E28
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:34:27 +0000 (UTC)
X-FDA: 84075135774.08.BDE5727
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id D2081180002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:34:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=uCiNOlm8;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf24.hostedemail.com: domain of ywen.chen@foxmail.com designates 43.163.128.44 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762313665; a=rsa-sha256;
	cv=none;
	b=jTz4bFvvVRxxqbUiSS7SkhDVI+5j4IbRMABoFfh3zn0292k4G6dYDjivfR14VtaGXXdhZ1
	Fy0hRRfblkTEO4minP1YOe1gwPGJU4WNLsUjpSFY3WbO2SqgIhCBFGvFBxXoBvh7nhA7Tr
	gt/XcSWgjyO3Ab8dCSyJs6cAThIwN9c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=uCiNOlm8;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf24.hostedemail.com: domain of ywen.chen@foxmail.com designates 43.163.128.44 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762313665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCZd4BWtWwDfl8jPRQWP6rxG9i/adWQOFxkaWuBxQ80=;
	b=PskXeWFYHqYnJDxk5A4+sYJuj2lup3pq1OU/9iWPT+q7siXSoQKpOSJlQngUHeQcKemBth
	dAoGzIOysLz2ieZ+DsbtEU6Pe5+WYjiidWmEZMuTqLeDMMi5u5x0Tvm9R8DmDF+c3e5Ykk
	dShNHyPsZ9sSl6AXFg9/1AFHHXiEOzg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1762313661;
	bh=cCZd4BWtWwDfl8jPRQWP6rxG9i/adWQOFxkaWuBxQ80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uCiNOlm8H5zBRKhnzETUok+8nIzaR86r5ELxo2FYWHDBoowjBtdrehGgTx+62ADA+
	 18X3LzbIdtBsbHHBgIbyWEDemhvtkgd5rAPb30YvFEJqeeU8A6gUBtdf1QNX6s8C4z
	 8yhgQ1Z5GxgPNjbSqPwiO17aBeMnmaImMMFHTY84=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id 87A08658; Wed, 05 Nov 2025 11:33:58 +0800
X-QQ-mid: xmsmtpt1762313638tn1vfqyw8
Message-ID: <tencent_85F14CD7BA73843CA32FF7AEB6A21A6EC907@qq.com>
X-QQ-XMAILINFO: MBHEkxMsYPCYTvJTZVsRQ0l7cF1jmGmoPlPY6CdIxHI55vQxpPE6YJ8jycAyKl
	 /vbrYNpvnzpz4ClZbCoCg4CZfwM81XGPvmJ03wj6srDnWSfQKHQfF2fU7HRjAnIoHePjrWjpG8LO
	 zdR5RMV0CAXduPwW+PHmlHUKhmzoSx+qxeWQxHBGWALlmxYMMDV2T3iNEL0NsN9mDDllbKqHHbvZ
	 dHix8jdK1nT1oEApErew9iW9QpxqUrLPq4fh5iaoP1A1XFX50p6/DPtuOkxjyK4awxRCdesi00Wc
	 yRWIWuWrqruxi6tGJo61VaX8bKbX3Z6k2LqXtZqav6vWwzU/Lf5Zkbrg+fxu21iYPsvlwN1//bHb
	 eyrRx+4cywi6IijkmUgWF1mV1ANTCGygQtacOqxiAt1NMqUNtP4mgcV7My1CGhfsbAFl0PJNOtrs
	 5dSxLgsTimsCg8QQuOvpBUxrKw5OEH32Rd2bg1ihKdEw/cA2dDNSxSSyt4w9QyXIEDS6nIZ8ggHt
	 jtxd5JN204gFiqdlPgzRkrtcKiwwY2lf/Ta72bdsqjsUHFqvSNl+ceyxVAn2jlpqlUXjMmBioH9g
	 KVGeq+NclBPdco8Go+NO0qFwxNCKHqIv6VSjuKVC1oXCFPtljamV/jgHIyVwvRtUfNKA9/ptnf9Y
	 cPJi9g9Teu541XDd0YXaVsKOD8X+yh5DbVdcM86aKyhrqLGom1+L6QJwmIa+1E5tznHL8fSi5Uc0
	 4Ic8/iZlJrNT5F4mvCwBrdI+Dk8EFgc5LE2ehhVg9zBFD4jS39/8+IalqELR3SPLazXeov6CATmu
	 VsLKuYjy6Wm7GqJjT/LRdzmWPobgGxExYdliiVBab6LS+MfzqDpuRXfJTfJY6f9fjWsU2UEQtjIO
	 EDjf5kFdpS9EFDVwmGiSnUJ8CFxpSI1qioceCMAlGUohxBp9hYeTmQpDZxdIhAfkxMpiZCf0YsvW
	 mAp7Y+QNz2cQK2VM3utH4QBl7Lj/NDPeSMhtjvp9RDJzSrWTQhYI6lefbFoBLHMCYu9Y1ZyjI9gU
	 TYZi4ZclddkNz9ZvlYtXXx6h+65cfY34K9Il47gOdGuLwwDte0jVO3vu6JBLMkwY0gIHkhhw==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: ywen.chen@foxmail.com
Cc: richardycc@google.com,
	axboe@kernel.dk,
	licayy@outlook.com,
	linux-kernel@vger.kernel.org,
	minchan@kernel.org,
	senozhatsky@chromium.org,
	akpm@linux-foundation.org,
	bgeffon@google.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	liumartin@google.com
Subject: [PATCH v2] zram: Implement multi-page write-back
Date: Wed,  5 Nov 2025 11:33:56 +0800
X-OQ-MSGID: <20251105033356.2682072-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_78FC2C4FE16BA1EBAF0897DB60FCD675ED05@qq.com>
References: <tencent_78FC2C4FE16BA1EBAF0897DB60FCD675ED05@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D2081180002
X-Stat-Signature: 7wtmqqb5e7id3ogsfssdi6owhhqo9mf3
X-Rspam-User: 
X-HE-Tag: 1762313664-225708
X-HE-Meta: U2FsdGVkX1/0ANhq5z3dlBnPtm7gapu0+1mrEwahswo4hO6n46H2j2Xs0GOuDvxAQxpw+XFyBTn9tenoGOoLpIXja9JVTmqezWULOJulWtX4EDGt9soz1ZFwZGdQ+QKMLiyr1la2jrJ1btUZ+hA/twM+KrH4KDwuzdEW6XmPZttDPSExTtsTW7PVcsqEg8iVQLfQN5wbumeF5rXNI0VVgaELvyvFmN1dPfhEu+fUJOlq8jwiXcHZ6T4DbQu9b5E0ImNXVGvj1J3orXtbDFhM+XX2oby3vAeMtw8T9e2gKHJg3HKPKORnpgaKqBhowmGEhJKpNuDPQQ6pWtUEl30Dj0zd43Ga04byR2mbul2Sodi2l4reyGrRY2n5znGwLI7jxmoKlA6nLyU+b7kdSu976U37MbOZl3aPWzIWkDoHj0TCQfT2/FPYimvlXT6V0wBymu2mRaQoWRj0I3/8TYwhuK0EgJ9yw45MI2GGue37zGqIfa2YGBrNSWttqsog8BOl+OLFWhioS7R8BHL8ZEy9xBP6j3WPW6u93q8nFS/evceHieP5IpDPl7uvpygnXXDJ1bMyblgn46or3rcmApYkbMRlAky54KHBtD163sd2cISlBOxrHyfCTO628PM62nfTSpsawhaCqMi0a39TXC/g7BNcCH0SfM/pztteSwmbP9ui8FzHa3BWEHeez54M6OiE9XUeZihrWwc12RWyGxNs/QXSPz6GZdnzLpNgRe+yaIfn9le/6FFZn0gjSM/YLPHGeGpSt95AXaq6Cygd4t2LCQ5kX9afI45x6+uB4oamYpXjVgavH8A+1ye0I2nBUpRzVlAHEW2hN3vx491LggqMCVam0Mm8vYQsPAOwEhIlkuuR9XZdXtUO6ZEA1gK1MWQI9+8o0fCcewjvkVhqnMctF2rx0rjuENUtbaARcepbTKGNoY7TTddMmfXWd0hoHXLzg94ZfvKE/uaJcX6dHbq
 5OHh0WOS
 PsP6NYwWqDzkTFx+aqokWkKXL3aC6yuuCNnXjieMHIRT1jQfV/osAfqBxK0HGb6C77unVmWU2b56+Sew3VJSmGq9ay85bvNBHKwELsqJ5vW9aq9Qw8C2qe1DC1U+fbYf6f9CrB/8H/9h/8g9e+Wvj96SOCc9axNZZ5cHhKEiP/NpqSZqybiFq/DgSUlJuChvgFQZqRtFLT6K7HFIFGseqX27v1oV2//qxlSZW42dCD8+SZ4vM0z3eBA8BfI/2bbLdFSPoZna+SgV2/CqsQgLMxGTwmgti9wgN02lMyRIw63rLoiE=
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
Changes in v2:
  - Rename some data structures.
  - Fix an exception caused by accessing a null pointer.
---
 drivers/block/zram/zram_drv.c | 223 ++++++++++++++++++++++++++--------
 1 file changed, 169 insertions(+), 54 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 4f2824a..d2bd091 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -751,21 +751,130 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
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
+		if (!req->page)
+			continue;
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
+	int ret = 0, err, i = 0, off = 0;
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
+		req_pool[i].page = alloc_page(GFP_KERNEL);
+		if (req_pool[i].page)
+			req = &req_pool[i];
+	}
+	if (!req) {
+		ret = -ENOMEM;
+		goto out_free_req_pool;
+	}
+	set_bit(ZRAM_WB_REQUEST_ALLOCATED, &req->flags);
+
+	blk_start_plug(&plug);
+	while ((req->pps = select_pp_slot(ctl))) {
 		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
 			spin_unlock(&zram->wb_limit_lock);
@@ -774,15 +883,15 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
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
@@ -792,22 +901,32 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
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
+			req = zram_writeback_next_request(req_pool, req_pool_cnt, &off);
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
@@ -817,43 +936,39 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
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


