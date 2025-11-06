Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE6C8CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 01:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422DD8E000E; Wed,  5 Nov 2025 20:55:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3568E0002; Wed,  5 Nov 2025 20:55:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1A48E000E; Wed,  5 Nov 2025 20:55:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4338E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:55:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4A47160509
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:55:37 +0000 (UTC)
X-FDA: 84078515514.18.27360C6
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	by imf12.hostedemail.com (Postfix) with ESMTP id 021AB40005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:55:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=ut1tIyi+;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf12.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762394136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9xTFKxVmiCzUE0k6Wa2bkahS5/u9y+VmK1Cpk5lFts=;
	b=4QFIRC//FK0fQcXu+UYq5oJelYzcKCYG7mjcABb+GMkdNsOzXiltdSet5Y1RuB8Hdtx2T8
	CVQo4dz6SfxiRUnoyyM8r+erQ2TwKR8w5vVjmB22e8sIhnA3/b+YvJeyBJk3fcPFzmuD32
	C3bHxWpMFSQ1s/ksWxZjcR/HkYbayRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762394136; a=rsa-sha256;
	cv=none;
	b=8Oc1p03Ql6S3IE/HEPIwNz4IZEcbJCck9j69PeT7P6V1v0XwJzAQHxGS01UhqHVqfFDgNG
	t9rZg6h2aUuhnX4EhMXORwGfGk62KGBklvOg/hsk3skrIWomsBYTMdATLrtOhDWac41dpR
	gdHsRIseanLlelEkHHXx0tFpwsifCbY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=ut1tIyi+;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf12.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1762394126;
	bh=x9xTFKxVmiCzUE0k6Wa2bkahS5/u9y+VmK1Cpk5lFts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ut1tIyi+tmVUAW1P6rBM2f4gVYVUZBiRRi8k9Hw+3mBqDY/SG61Sa6qfNu0xakFEF
	 /nn9YBPsYgGV4jGZxje9MjJ18XqpUmbWWvpg8CeORB9prWvVuumHB53eDwNCzX1N+A
	 K1Ba6wetkLRzKLmvgcNy9lWU6l0m7pjJZ1MkA/ig=
Received: from meizu-Precision-3660.meizu.com ([112.91.84.72])
	by newxmesmtplogicsvrszc41-0.qq.com (NewEsmtp) with SMTP
	id C43858CF; Thu, 06 Nov 2025 09:49:03 +0800
X-QQ-mid: xmsmtpt1762393743tje9pfvyw
Message-ID: <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
X-QQ-XMAILINFO: NC4p7XQIBeahG+T2KxJcrOZlaNlD/vwskTkPl6zZT7forH4ZnSlukAICmwM0bM
	 LUjMk3DQeIHuoLTSmddcLUbdYzfeL4HhwSyJXeRJZC7EhHVz0aHVqYolPkzkrEAA0jlzBkl2LPOQ
	 SJqWsY44qhgJHEUlSiSaCRDXn4BAfhCf5vF5q/xhApAIaoazjZS4IvVHSpJvICv0h/WG/oWL5Kxf
	 URB7cpf6N52KT8CB72xxG4T6y0QtL9Mf3xVx+FnwFEBeueI8Pl5jXrjEEQly0Nr/waxX3h4RgQ+V
	 v3n58cWvqQK9unRkATc0kOGZfdbOJzm+IlmKpGn+lCkccqTi4k2wJMe/9YL5RAaPB5DN1488rIck
	 sLK3a5blnpTGH+z3XL5NxggrOGfXsouobIlEW4gAF+XSooJRx3KdoOkGruyfFA5uYDCllFw5k8Ei
	 K0G8p8F04DNNIBKXgmL/KxXkWikAYE2fHZLvPKQd+odZNjvhUy7h2MZ6c/2KgwB3xwjmYxrG8EAe
	 2Wp19yN+ZyrNzEnZk2SjlJhHdFwQ9BBxfF1dP0tZy7JfqErapMk0PIfw5/Zcpf38BhV+CEAo8p+8
	 cosRfJD5u1ZSuNAi3UYz6g2MW9D+NE3eynZzKtsXJwEeaMhGiBCsf7TwYaP0wPPN0xUbK6XO3Q5e
	 HTMjgxHGcbrlfOgVRAshyXDnp8eq7RW7v7GLUKEh6dEXjAyDYGSKeow+gPLDwBGEKB75T5K45mBU
	 85SsbMgSNjf7cHS4375KX7LRfw5elwwEy8AO+VOpIxz7Z8wT7shm/oGhnXcmgnsagkz8Bjgk4iga
	 lvSfgps5psV2UPVZ/JMlSBat66HyBnbNO811MbnVQLxVwUXA6V9UvJ+bMMbdORo5vVFqC26hzFVJ
	 wK35Q3dXpYWa86oYd1Q1lQr5gYRm5EBGlRBISofMnlPT0z46GH/rx3VUNQKgnZ+dWIYZZcFMZHNn
	 Aqji93bNJK0kBCrXbdnArKVnRhc4myhJLONQPQ0LxlHxIWw4HXl9fTP9IDdmFWeRx1Pv1g6cttOe
	 0hOhgRh44rWjv0b5uKuU28DPdDZDdZ07K4aEOQSE11o4264Uqy3kRRemJ1HkY=
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: axboe@kernel.dk
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liumartin@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	senozhatsky@chromium.org,
	ywen.chen@foxmail.com
Subject: [PATCH v4] zram: Implement multi-page write-back
Date: Thu,  6 Nov 2025 09:49:01 +0800
X-OQ-MSGID: <20251106014901.2728074-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i5rrs33ky7kqrh781kgw78b1kmkp9dop
X-Rspam-User: 
X-Rspamd-Queue-Id: 021AB40005
X-Rspamd-Server: rspam10
X-HE-Tag: 1762394134-600699
X-HE-Meta: U2FsdGVkX19P79IPQqING1M8GF4Zfuh8c5hgPEL13zp+aluhXO5W48/TW2jEQRAKzmCHi4U0IAWSK6rHIRCmdjpmYFyclyeC7UlWxeay897TAynb9qmx4ss0tYHQ8WZcexghsPsK1Twr3Ryt/FJSUPaRIUzLE3UcagpfA75nmAzS6IVz7oFw05OSBoH6IAz8Ad8YgWMcysP1D1NZFpUmPA/OVU83BDwPrtxWJ3TppLQI+aqD0gePxx2iTLgmW4u1NLgCKPIIUFpw+ss9CwLjfLFJ1ODvO/uzk5Z/EVA+1gcibxhAvlpM1MUV5SjhSfYPjDy9Vi976mDIi2TRyi4MHh/89Cr9I6r/BY8El+gImU3ITohQMtsm1ZbRLU6HeoBrCgyu4uHPiqzEUUGWQQs37wg2X9+qwko6ghVUxpMR8cyoADhmAbHX4pXSmBhix1LBU9VHCrOzbhFaV6j0PycgBVUFQzwc8CG/tfebfBnWip6Jwc4PdsEHHq7/ykFLciHv3cmNnQvIH8N6sBy76hF30ONgQWDjVKjB2I433C1oZRVBEx10PcLdOkr01aYJba4Z3CfJxETnIRXJDetOtO9c3hFuOCSpYdvrYYba+nXEp6SC2TsMy/D8hvDlgk0I0/7XDuJvsNmG0MyRkU0PPlfrfW03F2xnWY54x/NgSAO6rhjHoBOPRnAIO3raPp7XxtWtEaC018EWs5QcLXaJALM9W5ymYS1G0ycQN2pt669pJEDe+MyBqOS7ZD350iUdaXem9l0hjiqsKvrMB5OdtETAK/1GQ1Skmc+8mspO3izTiYIMZtfCoiKHiReBPCsDhCpOHmzcVsZl2Dve4u5Ap1VdDj69JBoVvqu9AQHWY9JYajMdnxUYFlvUDlD4VMxhO9NZciE0DDvdttspuV6l0jw5YJd9cnh0TXDr2dE9+a72NeZRoEwWpa42cudJ/xsyFtojg3JRj+kukj/LXcZPfMJ
 2WzgcPZO
 hRfEJ4MPeaRBEu4EomyQhfNSy+71Bfq9zD6P5eFNAn0hzhZTZFDTNc+jAq/M8tbV8DUwpMr2o6DTUc7fSR/DsMsu1UBPK4++8ELIpbmccFI2B8hTpp9HorMuWCz16A+Z5I+OOeuxYYyyGS7ZmRqP+rshTK31S+fhXC8r9krn4yBQK58h8d3JexUL0G5ga/fCGov//UOcgYS2givqJpIs7atUM4kWx1BCRTKHhJAFb2j2k8vn36Ifr9JGh34KbXENKUlIWeScrzixaUn6I5BfY+Jxk3d3Y2nEBcQbd
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

We used the following instructions to conduct a performance test
on the write-back function of zram in the QEMU environment.
$ echo "/dev/sdb" > /sys/block/zram0/backing_dev
$ echo "1024000000" > /sys/block/zram0/disksize
$ dd if=/dev/random of=/dev/zram0
$ time echo "page_indexes=1-100000" > /sys/block/zram0/writeback

before modification:
real	0m 16.62s
user	0m 0.00s
sys	0m 5.98s

real	0m 15.38s
user	0m 0.00s
sys	0m 5.31s

real	0m 15.58s
user	0m 0.00s
sys	0m 5.49s

after modification:
real	0m 1.36s
user	0m 0.00s
sys	0m 1.13s

real	0m 1.36s
user	0m 0.00s
sys	0m 1.11s

real	0m 1.39s
user	0m 0.00s
sys	0m 1.16s

Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
Reviewed-by: Fengyu Lian <licayy@outlook.com>
---
Changes in v4:
  - Add performance test data.
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


