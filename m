Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74AF2CFD2F3
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 21:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DAF06B000D; Sat, 22 Nov 2025 16:54:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1CF6B0023; Sat, 22 Nov 2025 16:54:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0556B0024; Sat, 22 Nov 2025 16:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A37F6B000D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 16:54:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7809140A48
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:54:09 +0000 (UTC)
X-FDA: 84139596618.10.6A01A61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 18DEB120005
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:54:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EnKfKq4E;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763848448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ar/tsmPZsMNL06hNZAMrHp3Essa84D5liQ/5iUwjfw=;
	b=GarmXuXZcD+fITe7XwkevdQ4ZsXfpB7K9pDRXaB4Fa0npEYBrXX0qCHeaguSbadv1yYrLV
	9Winxs77bPUgcgeOKRpILfZB5jaJmoNutb+fTvD50syhv4q0PHnnMkk8MOXNBKSEcCjXnE
	BqflxHHxNV7k66jqeP3WZagRCWscbOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763848448; a=rsa-sha256;
	cv=none;
	b=j0vVUxrY6Wg7RgWEGRR+J8oleLWYoRBcslZV0Sr+erxvQ2y9ST3byJBoZ7SMc+jjgeYmMT
	fupkeH/ONmwMBOnhVbDWkxln4KfsLS3scaxmHhoKPk2sI/2AFcqet4OgVz0227F4uUNzku
	UPSLCDu/fTWVC4VC2zYRRpGMbUtWPRc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EnKfKq4E;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 71C206013C;
	Sat, 22 Nov 2025 21:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D408AC4CEF5;
	Sat, 22 Nov 2025 21:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763848447;
	bh=+KRHwAAUW4XO1yKTU+0wVlPm95HxskzXxng6AxzbgQY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EnKfKq4EYsbTTCoSd98l+D10UA8GVAzzirZRMQ9H0NOr9w2S8lQXCH4mAwe9fqYOe
	 Uw4EZ6WCYYdIABl02YZ/vL29wizET8kLev0xacnVLkAUi0u9BirB9TwKkBcWOyNN5u
	 5ID9/Fp1W/I+ikiZCJ175IpsGDIiEAnNRhntAG6g=
Date: Sat, 22 Nov 2025 13:54:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>, Yuwen Chen <ywen.chen@foxmail.com>,
 Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>,
 Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org
Subject: Re: [PATCHv6 0/6] zram: introduce writeback bio batching
Message-Id: <20251122135406.dd38efa8bad778bce0daa046@linux-foundation.org>
In-Reply-To: <20251122074029.3948921-1-senozhatsky@chromium.org>
References: <20251122074029.3948921-1-senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w4g9rnbaw8tfsiayy691jnb6m5sxs9kx
X-Rspam-User: 
X-Rspamd-Queue-Id: 18DEB120005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763848447-58324
X-HE-Meta: U2FsdGVkX19q3HhBUiwuxnWTavgDq7h8TxnxlBa6+0wPyihm20iRe3U18zGVO5PQM5Mh/Z3DA6/cxZ7yoIqTylCEHLjsaMIcYpM0AxNEslSKZsrYpSnhbJcVe3PjPPZjJCL0O3gZI8ayI/g/pjDxWT1ulgJYagDPZWt8yDKl47YREwDVdfLg6AVc9wqq4a4Ni9pNoXyr91D8m/p+AFSd1ts+rGDLUSWHUmretMtD6n0uLnp6wz/EcyO3PCQl0iLocscXCDw8sSyKQEEtRI1w1APgQG+6fJzf4z/ikJJe+xPFNJsLuRqKQIpnasBPs9MCZeJhx7kTlv+oXD6RRjss91H2fIxWjF7QP+PFNkP4e8iLgJhpn3enZYS0724oA1jNw1OljCEdWiQBzuXu91bj1P6qOXr03MpCBcI2YRaB2JfhwJVHxx/++Hg64hxNgNJ1wgz93bb4lk9t8cyGdJp285rvesvUvUpOgnks4tVvhfCRfEuCgbBoSfSH2J9el3Hq+sP4ic7tudnNptK8ci/KamweEg/+IsqYgBn87OQgaqpcxFH069f4AnitebnDR3v6CD47a9aZ0TIVs2x6p48cxas0SDaSXJYdWwgg4ILF5KKB6/bIX/d6k61frWdEPLQFeW9JBZWU65ZmlkZrdkh/tresy38th0cmFqpIDL+z5tnwfSOKopEW9S3coQrlVGhIyT1ocJisJHxUfQcMbC1+H9oIxqTE892pfDk7E6lTnV4iG8vyLbmBsT5fCU3yGMAliTPGMeTmt7CtS6dFuNUHvkiTz4uonjTM2tz/E3M76Ram5/AnigdNLbm5F1maQZPpzexseRIRD1AXz8fYMk3cYxAhNuj3OKrHisKcx5YxO5ZnkOD12RM3kdTQxJNCVWp/RdSv0m7CwBDQ6glORBkomh4e9t991Pc20q09emBi+FuqCodHG2pXhYbh4sTZ6tFRzZYh7AMBzDuKwTTjhUj
 GLmVYzeT
 QuALo2vIZyYKpgHYYVdribqAB2KYVeFD9tHshHLuG/DtYijR4s5TmdSNtjESHdYKJTRJ5uIhQAbsHz6qyCyoJpvxtFntM26CZU1KeKczKnBce/UFKEXWNoOfqdbmad9vPVJg8RiyGkwmbrJIL4FcFw2FvbDMpF7i3Z9Y1Wia7R23xo2bgnfr6BkOAaX5hmCK5GaO10KeShYnm6iEzH2zRC9iMNV+JJ6wrgAWZvRDGHafUPHGoCgYzIZJjxbLiKTFMtrLCQzLqCyj3ECk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 22 Nov 2025 16:40:23 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> As writeback is becoming more and more common the longstanding
> limitations of zram writeback throughput are becoming more
> visible.  Introduce writeback bio batching so that multiple
> writeback bio-s can be processed simultaneously.

Thanks, I updated mm.git's mm-unstable branch to this version.

> v5 -> v6:
> - added some comments to make code clearer
> - use write lock for batch size limit store (Andrew)
> - err on 0 batch size (Brian)
> - pickup reviewed-by tags (Brian)

Here's how this v6 series altered mm-unstable:

 drivers/block/zram/zram_drv.c |  112 +++++++++++++++++---------------
 1 file changed, 62 insertions(+), 50 deletions(-)

--- a/drivers/block/zram/zram_drv.c~b
+++ a/drivers/block/zram/zram_drv.c
@@ -503,11 +503,13 @@ out:
 #define INVALID_BDEV_BLOCK		(~0UL)
 
 struct zram_wb_ctl {
+	/* idle list is accessed only by the writeback task, no concurency */
 	struct list_head idle_reqs;
-	struct list_head inflight_reqs;
-
+	/* done list is accessed concurrently, protect by done_lock */
+	struct list_head done_reqs;
+	wait_queue_head_t done_wait;
+	spinlock_t done_lock;
 	atomic_t num_inflight;
-	struct completion done;
 };
 
 struct zram_wb_req {
@@ -591,20 +593,18 @@ static ssize_t writeback_batch_size_stor
 {
 	struct zram *zram = dev_to_zram(dev);
 	u32 val;
-	ssize_t ret = -EINVAL;
 
 	if (kstrtouint(buf, 10, &val))
-		return ret;
+		return -EINVAL;
 
 	if (!val)
-		val = 1;
+		return -EINVAL;
 
 	down_write(&zram->init_lock);
 	zram->wb_batch_size = val;
 	up_write(&zram->init_lock);
-	ret = len;
 
-	return ret;
+	return len;
 }
 
 static ssize_t writeback_batch_size_show(struct device *dev,
@@ -794,7 +794,8 @@ static void release_wb_ctl(struct zram_w
 		return;
 
 	/* We should never have inflight requests at this point */
-	WARN_ON(!list_empty(&wb_ctl->inflight_reqs));
+	WARN_ON(atomic_read(&wb_ctl->num_inflight));
+	WARN_ON(!list_empty(&wb_ctl->done_reqs));
 
 	while (!list_empty(&wb_ctl->idle_reqs)) {
 		struct zram_wb_req *req;
@@ -818,9 +819,10 @@ static struct zram_wb_ctl *init_wb_ctl(s
 		return NULL;
 
 	INIT_LIST_HEAD(&wb_ctl->idle_reqs);
-	INIT_LIST_HEAD(&wb_ctl->inflight_reqs);
+	INIT_LIST_HEAD(&wb_ctl->done_reqs);
 	atomic_set(&wb_ctl->num_inflight, 0);
-	init_completion(&wb_ctl->done);
+	init_waitqueue_head(&wb_ctl->done_wait);
+	spin_lock_init(&wb_ctl->done_lock);
 
 	for (i = 0; i < zram->wb_batch_size; i++) {
 		struct zram_wb_req *req;
@@ -914,10 +916,15 @@ out:
 
 static void zram_writeback_endio(struct bio *bio)
 {
+	struct zram_wb_req *req = container_of(bio, struct zram_wb_req, bio);
 	struct zram_wb_ctl *wb_ctl = bio->bi_private;
+	unsigned long flags;
 
-	if (atomic_dec_return(&wb_ctl->num_inflight) == 0)
-		complete(&wb_ctl->done);
+	spin_lock_irqsave(&wb_ctl->done_lock, flags);
+	list_add(&req->entry, &wb_ctl->done_reqs);
+	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
+
+	wake_up(&wb_ctl->done_wait);
 }
 
 static void zram_submit_wb_request(struct zram *zram,
@@ -930,49 +937,54 @@ static void zram_submit_wb_request(struc
 	 */
 	zram_account_writeback_submit(zram);
 	atomic_inc(&wb_ctl->num_inflight);
-	list_add_tail(&req->entry, &wb_ctl->inflight_reqs);
+	req->bio.bi_private = wb_ctl;
 	submit_bio(&req->bio);
 }
 
-static struct zram_wb_req *select_idle_req(struct zram_wb_ctl *wb_ctl)
+static int zram_complete_done_reqs(struct zram *zram,
+				   struct zram_wb_ctl *wb_ctl)
 {
 	struct zram_wb_req *req;
+	unsigned long flags;
+	int ret = 0, err;
 
-	req = list_first_entry_or_null(&wb_ctl->idle_reqs,
-				       struct zram_wb_req, entry);
-	if (req)
-		list_del(&req->entry);
-	return req;
-}
-
-static int zram_wb_wait_for_completion(struct zram *zram,
-				       struct zram_wb_ctl *wb_ctl)
-{
-	int ret = 0;
-
-	if (atomic_read(&wb_ctl->num_inflight))
-		wait_for_completion_io(&wb_ctl->done);
-
-	reinit_completion(&wb_ctl->done);
-	while (!list_empty(&wb_ctl->inflight_reqs)) {
-		struct zram_wb_req *req;
-		int err;
+	while (atomic_read(&wb_ctl->num_inflight) > 0) {
+		spin_lock_irqsave(&wb_ctl->done_lock, flags);
+		req = list_first_entry_or_null(&wb_ctl->done_reqs,
+					       struct zram_wb_req, entry);
+		if (req)
+			list_del(&req->entry);
+		spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
 
-		req = list_first_entry(&wb_ctl->inflight_reqs,
-				       struct zram_wb_req, entry);
-		list_move(&req->entry, &wb_ctl->idle_reqs);
+		/* ->num_inflight > 0 doesn't mean we have done requests */
+		if (!req)
+			break;
 
 		err = zram_writeback_complete(zram, req);
 		if (err)
 			ret = err;
 
+		atomic_dec(&wb_ctl->num_inflight);
 		release_pp_slot(zram, req->pps);
 		req->pps = NULL;
+
+		list_add(&req->entry, &wb_ctl->idle_reqs);
 	}
 
 	return ret;
 }
 
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
 static int zram_writeback_slots(struct zram *zram,
 				struct zram_pp_ctl *ctl,
 				struct zram_wb_ctl *wb_ctl)
@@ -980,11 +992,9 @@ static int zram_writeback_slots(struct z
 	unsigned long blk_idx = INVALID_BDEV_BLOCK;
 	struct zram_wb_req *req = NULL;
 	struct zram_pp_slot *pps;
-	struct blk_plug io_plug;
-	int ret = 0, err;
+	int ret = 0, err = 0;
 	u32 index = 0;
 
-	blk_start_plug(&io_plug);
 	while ((pps = select_pp_slot(ctl))) {
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
 			ret = -EIO;
@@ -992,13 +1002,14 @@ static int zram_writeback_slots(struct z
 		}
 
 		while (!req) {
-			req = select_idle_req(wb_ctl);
+			req = zram_select_idle_req(wb_ctl);
 			if (req)
 				break;
 
-			blk_finish_plug(&io_plug);
-			err = zram_wb_wait_for_completion(zram, wb_ctl);
-			blk_start_plug(&io_plug);
+			wait_event(wb_ctl->done_wait,
+				   !list_empty(&wb_ctl->done_reqs));
+
+			err = zram_complete_done_reqs(zram, wb_ctl);
 			/*
 			 * BIO errors are not fatal, we continue and simply
 			 * attempt to writeback the remaining objects (pages).
@@ -1044,18 +1055,17 @@ static int zram_writeback_slots(struct z
 		bio_init(&req->bio, zram->bdev, &req->bio_vec, 1, REQ_OP_WRITE);
 		req->bio.bi_iter.bi_sector = req->blk_idx * (PAGE_SIZE >> 9);
 		req->bio.bi_end_io = zram_writeback_endio;
-		req->bio.bi_private = wb_ctl;
 		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
 
 		zram_submit_wb_request(zram, wb_ctl, req);
 		blk_idx = INVALID_BDEV_BLOCK;
 		req = NULL;
+		cond_resched();
 		continue;
 
 next:
 		zram_slot_unlock(zram, index);
 		release_pp_slot(zram, pps);
-		cond_resched();
 	}
 
 	/*
@@ -1065,10 +1075,12 @@ next:
 	if (req)
 		release_wb_req(req);
 
-	blk_finish_plug(&io_plug);
-	err = zram_wb_wait_for_completion(zram, wb_ctl);
-	if (err)
-		ret = err;
+	while (atomic_read(&wb_ctl->num_inflight) > 0) {
+		wait_event(wb_ctl->done_wait, !list_empty(&wb_ctl->done_reqs));
+		err = zram_complete_done_reqs(zram, wb_ctl);
+		if (err)
+			ret = err;
+	}
 
 	return ret;
 }
_


