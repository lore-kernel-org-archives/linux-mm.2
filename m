Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82449CF6BE9
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 03:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F346B0092; Tue,  6 Jan 2026 22:50:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D3B6B0093; Tue,  6 Jan 2026 22:50:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19206B0095; Tue,  6 Jan 2026 22:50:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9096B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 22:50:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D41F4F9B7
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:50:15 +0000 (UTC)
X-FDA: 84303789990.17.667F7D0
Received: from r3-18.sinamail.sina.com.cn (r3-18.sinamail.sina.com.cn [202.108.3.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id C836C80008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:50:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=oDZrUJqa;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf02.hostedemail.com: domain of zhangdongdong925@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=zhangdongdong925@sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767757813; a=rsa-sha256;
	cv=none;
	b=7qD/+jpbMgQ0aQ67kWyOScKbdZarvAx/M1j8OMqs1pZy82UiTq9ZKK32jhWrrfRsvPd11w
	kwBwJ+QcuKq0b4yoU8J8S5AHe6C+K8Iuh4oGZUPxVdM6h/XY1xS1LqAWLHsa+pL1dwJ8q4
	WwfE4XkskmHbYgsm657MmqaNAscic0o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=oDZrUJqa;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf02.hostedemail.com: domain of zhangdongdong925@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=zhangdongdong925@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767757813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAfTRhIMR6MA/RGKf2sN9GCYjQmKTTSJUJWy2g0oOg0=;
	b=G4ez+hywkhE1z9sNOPU5UkoFr9ud7tH9/ePwvHHhug3OYK93aJTZKsPDNGS1lUGrHY5NZ5
	REuT4n5d7hvKgFptqJRJ6cUj+yTZGaSW4cx8NZKiWecn5oj9KLGCoZq3PAd0Jm7fVLRPzr
	RSFrB2e0NZfRM1HdIGib/tq/IlEww/o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1767757812;
	bh=EAfTRhIMR6MA/RGKf2sN9GCYjQmKTTSJUJWy2g0oOg0=;
	h=Message-ID:Date:Subject:From;
	b=oDZrUJqaRCMUdcUEaQgp9Wa0IlxH85i5PqdEYw8ktIm/Jnjm4faItVRaQIUuJte6F
	 KpNv1auho1Wa+CH7jdG65fR4n9v9ZuGZ6F1rn+3diA2WKDNx0ljNdwmyJtRaoEg5K0
	 3EfyU2xMqD/vasHwfyZLwIEr5B+x7yD+LLCqr2so=
X-SMAIL-HELO: [10.189.149.126]
Received: from unknown (HELO [10.189.149.126])([114.247.175.249])
	by sina.com (10.54.253.32) with ESMTP
	id 695DD7EC00001C09; Wed, 7 Jan 2026 11:50:06 +0800 (CST)
X-Sender: zhangdongdong925@sina.com
X-Auth-ID: zhangdongdong925@sina.com
X-SMAIL-MID: 6079074456895
X-SMAIL-UIID: B76B5308995B42AD8E20F2E5FD0EC548-20260107-115006-1
Message-ID: <40e38fa7-725b-407a-917a-59c5a76dedcb@sina.com>
Date: Wed, 7 Jan 2026 11:50:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 1/7] zram: introduce compressed data writeback
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Richard Chang <richardycc@google.com>, Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>, David Stevens <stevensd@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
 <20251201094754.4149975-2-senozhatsky@chromium.org>
Content-Language: en-US
From: zhangdongdong <zhangdongdong925@sina.com>
In-Reply-To: <20251201094754.4149975-2-senozhatsky@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C836C80008
X-Stat-Signature: s9cwxo4aesm5f8iu19g67mdnkos5nfkj
X-HE-Tag: 1767757811-340377
X-HE-Meta: U2FsdGVkX1/1Fphg8rtDJ80YadlZ+QL/Lyc1HeJiHTO7ar00DgGHKhkLCC2ykO5Aw/ca+qGpCtUv9I0C+X/dBHEwxjxgK38f9ynZzadA6PU1Ynp2ujC2rwM1T4vV1bEXwWsj810BPleaUJaMIB+I2J+9FTmGSVho44QisRxBXBNSG650FTzjIKdzJhykh3VYGRre5n7uQt/8iXC47rj5Oj6P8lIfGXDmRimPyWGQe4zHXALu2qF5jnWJ1rK4ujEAUyKIgA9Cvf8YFIew70m1I3QmDZjNk3B9+6bgm01Yw7lOn08PKuHynk05zBlzPI9wQuwLFpCgz8wdOtqNQfMviZbVCUF/gXp4dXF/O9xmjkvQpobDzzNe3IQ4lcPphluJJ33/VuzEC2SA81EEzojVjdYmRbBcilanvG+KInhYQBg1iQnAhXQYqH09ZTZw0Fu8ABNk5HoDHq1QZjwuJ+EorcWoiFGSAAibw5Oe61yT8IdiXDQo3rzEnO1NgA1WFtrzFtm3Qa5UFkZFx2yIrrtZ5QfyaelNPxn80B82RYmOgkzODlJslB8nZX+jBQn2gG5P73vg+SBgeMO9TQIWB5333jsS8TTZKRWQDRAG9yJHtc5dIZ9qg5SGMyOvJAGAu4I2D8Ql+0qfYxpiwYy3PWSH8zrHcGpvMt/37V1/JLTv73heOajGTktgnackb7lcHzcdU+G5ojDSOHdj6DOwGf1E28pn7HoPQ2pnC3ioFfNYUy7iPQo84CpJwUpzK3TojQXyLaZY64aQmkLAF0st06emuIx9EKgvtQbwAtoG1A/NpBi49zHKQwgVPpSn2R+AErRdeuNf4tSqlFnO3LzxkbPiSex/nDBmi36Fz+cOLLZuch6mhHSUFQycRzl6UqKEiOyeLUGkPMulk16j1HymP6pUH2mpK2PwRR1OlwOxqnK4ZqKviNRQbuU1WpiXD3gsJYNOsQuGZ0uIFm07yhxOZH4
 13wZXzEM
 j0kCVnISwPQP7QnkGBhmAhprjKEwmEEUrh2Da8lI8TMbqqZpr/YcOD4XFJN2rAeqzmiawiWyBenHkWZZifSP71V+w4WURCx3K9AYdP7goYin2Pmz+BetVuVeAiNbjzRfoZKdjgdBUZSB5e6JPxz55eU68ics3t7ryY+e8XIl3+by4S3nDuDuxSir7fQnW0ABuifrtSE8jPX7Aw9GCfNfmJtk7gFbv0BIbajYwTxGBWYJ9crNVXad0PoLgkxGDqFdlsn/HvIoWGUixvfJWe+a1X30UkVl7kcq8nkiBoOKp3j07/8v2KAkI1YE4qo2c3zz22Iv7DX7raSO8OAKmuBrx2hOIRDXQQoULIedjo1hzNq8BkyXUb/WiQ6Or9tLXdfjoVP7WWVO0HAAGrov6zG/WmLGsdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 17:47, Sergey Senozhatsky wrote:
> From: Richard Chang <richardycc@google.com>
> 
> zram stores all written back slots raw, which implies that
> during writeback zram first has to decompress slots (except
> for ZRAM_HUGE slots, which are raw already).  The problem
> with this approach is that not every written back page gets
> read back (either via read() or via page-fault), which means
> that zram basically wastes CPU cycles and battery decompressing
> such slots.  This changes with introduction of decompression
> on demand, in other words decompression on read()/page-fault.
> 
> One caveat of decompression on demand is that async read
> is completed in IRQ context, while zram decompression is
> sleepable.  To workaround this, read-back decompression
> is offloaded to a preemptible context - system high-prio
> work-queue.
> 
> At this point compressed writeback is still disabled,
> a follow up patch will introduce a new device attribute
> which will make it possible to toggle compressed writeback
> per-device.
> 
> [senozhatsky: rewrote original implementation]
> Signed-off-by: Richard Chang <richardycc@google.com>
> Co-developed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Suggested-by: Minchan Kim <minchan@google.com>
> Suggested-by: Brian Geffon <bgeffon@google.com>
> ---
>   drivers/block/zram/zram_drv.c | 279 +++++++++++++++++++++++++++-------
>   drivers/block/zram/zram_drv.h |   1 +
>   2 files changed, 227 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 5759823d6314..6263d300312e 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -57,9 +57,6 @@ static size_t huge_class_size;
>   static const struct block_device_operations zram_devops;
>   
>   static void zram_free_page(struct zram *zram, size_t index);
> -static int zram_read_from_zspool(struct zram *zram, struct page *page,
> -				 u32 index);
> -
>   #define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
>   
>   static void zram_slot_lock_init(struct zram *zram, u32 index)
> @@ -502,6 +499,10 @@ static ssize_t idle_store(struct device *dev,
>   #ifdef CONFIG_ZRAM_WRITEBACK
>   #define INVALID_BDEV_BLOCK		(~0UL)
>   
> +static int read_from_zspool_raw(struct zram *zram, struct page *page,
> +				u32 index);
> +static int read_from_zspool(struct zram *zram, struct page *page, u32 index);
> +
>   struct zram_wb_ctl {
>   	/* idle list is accessed only by the writeback task, no concurency */
>   	struct list_head idle_reqs;
> @@ -522,6 +523,22 @@ struct zram_wb_req {
>   	struct list_head entry;
>   };
>   
> +struct zram_rb_req {
> +	struct work_struct work;
> +	struct zram *zram;
> +	struct page *page;
> +	/* The read bio for backing device */
> +	struct bio *bio;
> +	unsigned long blk_idx;
> +	union {
> +		/* The original bio to complete (async read) */
> +		struct bio *parent;
> +		/* error status (sync read) */
> +		int error;
> +	};
> +	u32 index;
> +};
> +
>   static ssize_t writeback_limit_enable_store(struct device *dev,
>   					    struct device_attribute *attr,
>   					    const char *buf, size_t len)
> @@ -780,18 +797,6 @@ static void zram_release_bdev_block(struct zram *zram, unsigned long blk_idx)
>   	atomic64_dec(&zram->stats.bd_count);
>   }
>   
> -static void read_from_bdev_async(struct zram *zram, struct page *page,
> -			unsigned long entry, struct bio *parent)
> -{
> -	struct bio *bio;
> -
> -	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
> -	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
> -	__bio_add_page(bio, page, PAGE_SIZE, 0);
> -	bio_chain(bio, parent);
> -	submit_bio(bio);
> -}
> -
>   static void release_wb_req(struct zram_wb_req *req)
>   {
>   	__free_page(req->page);
> @@ -886,8 +891,9 @@ static void zram_account_writeback_submit(struct zram *zram)
>   
>   static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
>   {
> -	u32 index = req->pps->index;
> -	int err;
> +	u32 size, index = req->pps->index;
> +	int err, prio;
> +	bool huge;
>   
>   	err = blk_status_to_errno(req->bio.bi_status);
>   	if (err) {
> @@ -914,9 +920,27 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
>   		goto out;
>   	}
>   
> +	if (zram->wb_compressed) {
> +		/*
> +		 * ZRAM_WB slots get freed, we need to preserve data required
> +		 * for read decompression.
> +		 */
> +		size = zram_get_obj_size(zram, index);
> +		prio = zram_get_priority(zram, index);
> +		huge = zram_test_flag(zram, index, ZRAM_HUGE);
> +	}
> +
>   	zram_free_page(zram, index);
>   	zram_set_flag(zram, index, ZRAM_WB);
>   	zram_set_handle(zram, index, req->blk_idx);
> +
> +	if (zram->wb_compressed) {
> +		if (huge)
> +			zram_set_flag(zram, index, ZRAM_HUGE);
> +		zram_set_obj_size(zram, index, size);
> +		zram_set_priority(zram, index, prio);
> +	}
> +
>   	atomic64_inc(&zram->stats.pages_stored);
>   
>   out:
> @@ -1050,7 +1074,11 @@ static int zram_writeback_slots(struct zram *zram,
>   		 */
>   		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
>   			goto next;
> -		if (zram_read_from_zspool(zram, req->page, index))
> +		if (zram->wb_compressed)
> +			err = read_from_zspool_raw(zram, req->page, index);
> +		else
> +			err = read_from_zspool(zram, req->page, index);
> +		if (err)
>   			goto next;
>   		zram_slot_unlock(zram, index);
>   
> @@ -1313,24 +1341,140 @@ static ssize_t writeback_store(struct device *dev,
>   	return ret;
>   }
>   
> -struct zram_work {
> -	struct work_struct work;
> -	struct zram *zram;
> -	unsigned long entry;
> -	struct page *page;
> -	int error;
> -};
> +static int decompress_bdev_page(struct zram *zram, struct page *page, u32 index)
> +{
> +	struct zcomp_strm *zstrm;
> +	unsigned int size;
> +	int ret, prio;
> +	void *src;
> +
> +	zram_slot_lock(zram, index);
> +	/* Since slot was unlocked we need to make sure it's still ZRAM_WB */
> +	if (!zram_test_flag(zram, index, ZRAM_WB)) {
> +		zram_slot_unlock(zram, index);
> +		/* We read some stale data, zero it out */
> +		memset_page(page, 0, 0, PAGE_SIZE);
> +		return -EIO;
> +	}
> +
> +	if (zram_test_flag(zram, index, ZRAM_HUGE)) {
> +		zram_slot_unlock(zram, index);
> +		return 0;
> +	}
> +
> +	size = zram_get_obj_size(zram, index);
> +	prio = zram_get_priority(zram, index);
>   
> -static void zram_sync_read(struct work_struct *work)
> +	zstrm = zcomp_stream_get(zram->comps[prio]);
> +	src = kmap_local_page(page);
> +	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size,
> +			       zstrm->local_copy);
> +	if (!ret)
> +		copy_page(src, zstrm->local_copy);
> +	kunmap_local(src);
> +	zcomp_stream_put(zstrm);
> +	zram_slot_unlock(zram, index);
> +
> +	return ret;
> +}
> +
> +static void zram_deferred_decompress(struct work_struct *w)
>   {
> -	struct zram_work *zw = container_of(work, struct zram_work, work);
> +	struct zram_rb_req *req = container_of(w, struct zram_rb_req, work);
> +	struct page *page = bio_first_page_all(req->bio);
> +	struct zram *zram = req->zram;
> +	u32 index = req->index;
> +	int ret;
> +
> +	ret = decompress_bdev_page(zram, page, index);
> +	if (ret)
> +		req->parent->bi_status = BLK_STS_IOERR;
> +
> +	/* Decrement parent's ->remaining */
> +	bio_endio(req->parent);
> +	bio_put(req->bio);
> +	kfree(req);
> +}
> +
> +static void zram_async_read_endio(struct bio *bio)
> +{
> +	struct zram_rb_req *req = bio->bi_private;
> +	struct zram *zram = req->zram;
> +
> +	if (bio->bi_status) {
> +		req->parent->bi_status = bio->bi_status;
> +		bio_endio(req->parent);
> +		bio_put(bio);
> +		kfree(req);
> +		return;
> +	}
> +
> +	/*
> +	 * NOTE: zram_async_read_endio() is not exactly right place for this.
> +	 * Ideally, we need to do it after ZRAM_WB check, but this requires
> +	 * us to use wq path even on systems that don't enable compressed
> +	 * writeback, because we cannot take slot-lock in the current context.
> +	 *
> +	 * Keep the existing behavior for now.
> +	 */
> +	if (zram->wb_compressed == false) {
> +		/* No decompression needed, complete the parent IO */
> +		bio_endio(req->parent);
> +		bio_put(bio);
> +		kfree(req);
> +		return;
> +	}
> +
> +	/*
> +	 * zram decompression is sleepable, so we need to deffer it to
> +	 * a preemptible context.
> +	 */
> +	INIT_WORK(&req->work, zram_deferred_decompress);
> +	queue_work(system_highpri_wq, &req->work);
> +}
> +
> +static void read_from_bdev_async(struct zram *zram, struct page *page,
> +				 u32 index, unsigned long blk_idx,
> +				 struct bio *parent)
> +{
> +	struct zram_rb_req *req;
> +	struct bio *bio;
> +
> +	req = kmalloc(sizeof(*req), GFP_NOIO);
> +	if (!req)
> +		return;
> +
> +	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
> +	if (!bio) {
> +		kfree(req);
> +		return;
> +	}
> +
> +	req->zram = zram;
> +	req->index = index;
> +	req->blk_idx = blk_idx;
> +	req->bio = bio;
> +	req->parent = parent;
> +
> +	bio->bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
> +	bio->bi_private = req;
> +	bio->bi_end_io = zram_async_read_endio;
> +
> +	__bio_add_page(bio, page, PAGE_SIZE, 0);
> +	bio_inc_remaining(parent);
> +	submit_bio(bio);
> +}
> +
> +static void zram_sync_read(struct work_struct *w)
> +{
> +	struct zram_rb_req *req = container_of(w, struct zram_rb_req, work);
>   	struct bio_vec bv;
>   	struct bio bio;
>   
> -	bio_init(&bio, zw->zram->bdev, &bv, 1, REQ_OP_READ);
> -	bio.bi_iter.bi_sector = zw->entry * (PAGE_SIZE >> 9);
> -	__bio_add_page(&bio, zw->page, PAGE_SIZE, 0);
> -	zw->error = submit_bio_wait(&bio);
> +	bio_init(&bio, req->zram->bdev, &bv, 1, REQ_OP_READ);
> +	bio.bi_iter.bi_sector = req->blk_idx * (PAGE_SIZE >> 9);
> +	__bio_add_page(&bio, req->page, PAGE_SIZE, 0);
> +	req->error = submit_bio_wait(&bio);
>   }
>   
>   /*
> @@ -1338,39 +1482,42 @@ static void zram_sync_read(struct work_struct *work)
>    * chained IO with parent IO in same context, it's a deadlock. To avoid that,
>    * use a worker thread context.
>    */
> -static int read_from_bdev_sync(struct zram *zram, struct page *page,
> -				unsigned long entry)
> +static int read_from_bdev_sync(struct zram *zram, struct page *page, u32 index,
> +			       unsigned long blk_idx)
>   {
> -	struct zram_work work;
> +	struct zram_rb_req req;
>   
> -	work.page = page;
> -	work.zram = zram;
> -	work.entry = entry;
> +	req.page = page;
> +	req.zram = zram;
> +	req.blk_idx = blk_idx;
>   
> -	INIT_WORK_ONSTACK(&work.work, zram_sync_read);
> -	queue_work(system_dfl_wq, &work.work);
> -	flush_work(&work.work);
> -	destroy_work_on_stack(&work.work);
> +	INIT_WORK_ONSTACK(&req.work, zram_sync_read);
> +	queue_work(system_dfl_wq, &req.work);
> +	flush_work(&req.work);
> +	destroy_work_on_stack(&req.work);

Hi Sergey,

Thanks for the work on decompression-on-demand.

One concern I’d like to raise is the use of a workqueue for readback
decompression. In our measurements, deferring decompression to a worker
introduces non-trivial scheduling overhead, and under memory pressure
the added latency can be noticeable (tens of milliseconds in some cases).

This makes the swap-in read path more sensitive to scheduler behavior.
It may be worth considering whether the decompression can be placed in a
context that avoids this extra scheduling hop, for example by moving the
decompression closer to the swap layer.

Thanks,
dongdong

>   
> -	return work.error;
> +	if (req.error || zram->wb_compressed == false)
> +		return req.error;
> +
> +	return decompress_bdev_page(zram, page, index);
>   }
>   
> -static int read_from_bdev(struct zram *zram, struct page *page,
> -			unsigned long entry, struct bio *parent)
> +static int read_from_bdev(struct zram *zram, struct page *page, u32 index,
> +			  unsigned long blk_idx, struct bio *parent)
>   {
>   	atomic64_inc(&zram->stats.bd_reads);
>   	if (!parent) {
>   		if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
>   			return -EIO;
> -		return read_from_bdev_sync(zram, page, entry);
> +		return read_from_bdev_sync(zram, page, index, blk_idx);
>   	}
> -	read_from_bdev_async(zram, page, entry, parent);
> +	read_from_bdev_async(zram, page, index, blk_idx, parent);
>   	return 0;
>   }
>   #else
>   static inline void reset_bdev(struct zram *zram) {};
> -static int read_from_bdev(struct zram *zram, struct page *page,
> -			unsigned long entry, struct bio *parent)
> +static int read_from_bdev(struct zram *zram, struct page *page, u32 index,
> +			  unsigned long blk_idx, struct bio *parent)
>   {
>   	return -EIO;
>   }
> @@ -1977,12 +2124,37 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
>   	return ret;
>   }
>   
> +#if defined CONFIG_ZRAM_WRITEBACK
> +static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
> +{
> +	struct zcomp_strm *zstrm;
> +	unsigned long handle;
> +	unsigned int size;
> +	void *src;
> +
> +	handle = zram_get_handle(zram, index);
> +	size = zram_get_obj_size(zram, index);
> +
> +	/*
> +	 * We need to get stream just for ->local_copy buffer, in
> +	 * case if object spans two physical pages. No decompression
> +	 * takes place here, as we read raw compressed data.
> +	 */
> +	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
> +	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
> +	memcpy_to_page(page, 0, src, size);
> +	zs_obj_read_end(zram->mem_pool, handle, src);
> +	zcomp_stream_put(zstrm);
> +
> +	return 0;
> +}
> +#endif
> +
>   /*
>    * Reads (decompresses if needed) a page from zspool (zsmalloc).
>    * Corresponding ZRAM slot should be locked.
>    */
> -static int zram_read_from_zspool(struct zram *zram, struct page *page,
> -				 u32 index)
> +static int read_from_zspool(struct zram *zram, struct page *page, u32 index)
>   {
>   	if (zram_test_flag(zram, index, ZRAM_SAME) ||
>   	    !zram_get_handle(zram, index))
> @@ -2002,7 +2174,7 @@ static int zram_read_page(struct zram *zram, struct page *page, u32 index,
>   	zram_slot_lock(zram, index);
>   	if (!zram_test_flag(zram, index, ZRAM_WB)) {
>   		/* Slot should be locked through out the function call */
> -		ret = zram_read_from_zspool(zram, page, index);
> +		ret = read_from_zspool(zram, page, index);
>   		zram_slot_unlock(zram, index);
>   	} else {
>   		unsigned long blk_idx = zram_get_handle(zram, index);
> @@ -2012,7 +2184,7 @@ static int zram_read_page(struct zram *zram, struct page *page, u32 index,
>   		 * device.
>   		 */
>   		zram_slot_unlock(zram, index);
> -		ret = read_from_bdev(zram, page, blk_idx, parent);
> +		ret = read_from_bdev(zram, page, index, blk_idx, parent);
>   	}
>   
>   	/* Should NEVER happen. Return bio error if it does. */
> @@ -2273,7 +2445,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
>   	if (comp_len_old < threshold)
>   		return 0;
>   
> -	ret = zram_read_from_zspool(zram, page, index);
> +	ret = read_from_zspool(zram, page, index);
>   	if (ret)
>   		return ret;
>   
> @@ -2960,6 +3132,7 @@ static int zram_add(void)
>   	init_rwsem(&zram->init_lock);
>   #ifdef CONFIG_ZRAM_WRITEBACK
>   	zram->wb_batch_size = 32;
> +	zram->wb_compressed = false;
>   #endif
>   
>   	/* gendisk structure */
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index c6d94501376c..72fdf66c78ab 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -128,6 +128,7 @@ struct zram {
>   #ifdef CONFIG_ZRAM_WRITEBACK
>   	struct file *backing_dev;
>   	bool wb_limit_enable;
> +	bool wb_compressed;
>   	u32 wb_batch_size;
>   	u64 bd_wb_limit;
>   	struct block_device *bdev;


