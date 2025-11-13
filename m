Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49364CD4F2F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 05:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7B38E000A; Thu, 13 Nov 2025 00:40:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858DD8E0003; Thu, 13 Nov 2025 00:40:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E008E000A; Thu, 13 Nov 2025 00:40:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6743C8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:40:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 127F214084A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:40:35 +0000 (UTC)
X-FDA: 84104484030.13.CFED442
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4BCE6100003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:40:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZoNjiu9;
	spf=pass (imf14.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763012433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exUfCIX9jRZ89akGu0d0ZLHOGWyAZrz04MaBSLQFa5o=;
	b=BkfAaRO891BS8e4qYE3qBZYJyq2KuKVrtvZ+myNQ47ndI+2J7tx3sl/YWe2z9ZVlV//cCq
	XaptFxHGXK9ELGH6fz9A/s3k4PCdGzCkIvx92yRNP+vwATVfCse8EDQP5N1DZ/1im7JyEX
	BIvpY0eQGbP+x9wlN+y1kshXxXkx/Sc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZoNjiu9;
	spf=pass (imf14.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763012433; a=rsa-sha256;
	cv=none;
	b=w44Wjv2Sel68hXsGVHkuVAfacy1qu4gmHlJBuTlZ5bl5tS0wA3Aj/8keIjliQEGFwLxxCl
	k8eD2GzSytn5W3pXp70L2wG91P6benu0GLl86AYTQwNmFr5Uq6xS2zW97Iq6P0ECRDKlz1
	NwrVWw0o+mjVrPp2AOvXAY+uMblFsRw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 00F9240900;
	Thu, 13 Nov 2025 05:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95759C4CEF5;
	Thu, 13 Nov 2025 05:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763012431;
	bh=a3h6BHX+oSOhZ34yChd9xpbZyosXGG/OAK6w+LJKvCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pZoNjiu90jdZjq+DpfkIFGNOZVjevmyqrbw4dp0xl8R+XiAfhO0prbegb5AlW16sz
	 5+Fh/FOK6EghZyyWDoNfbeldqcgJVZZjHwL0hgkt6SVhvzu4xdFEeN28fdQXlHdAnX
	 45P47uhJ2KcwgJ5LkOLChNqw6HraS3UujUnS6LILLr57CWXoU9/0j33aJggfpLdum2
	 mGAMNRdzD6Q5/U+C3a7j6LkaseNw7Lobvq6vW5uVXNEM2ra/wRig9MPcMCw6AoL+DO
	 E5fwpw3jATvm9ZVxV3ReW2VpgpEtNnDjwh4Qxa/DJqv6518G3NnRR/00ZkRYKfXlSw
	 QQPXm6aQQKb0g==
Date: Wed, 12 Nov 2025 21:40:28 -0800
From: Minchan Kim <minchan@kernel.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, bgeffon@google.com,
	licayy@outlook.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liumartin@google.com, richardycc@google.com,
	senozhatsky@chromium.org
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <aRVvTCCZSjPyAF_2@google.com>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
 <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4BCE6100003
X-Stat-Signature: 3whrw795k4hdor4cjxbrmixpjdbxhmjh
X-Rspam-User: 
X-HE-Tag: 1763012433-801468
X-HE-Meta: U2FsdGVkX1+W3+z4Yr2yn7/LUkzHrXBDSI3+6k6AZje3aF16ZeCGEE0p+gzBb85Sk3umV7vXgl+2JhBTk7jcPmrJs+ZSSLnkr9qxR7VJSFBuscyCU3YL1c5rl8KTkhuy11ZR1ox2zvtJDti17oMDCSpjEShFKCoaEzyW40mMOolU+/tTkacJgMDBkkOFvVMpdbyGWNax5WWvFpvhR7DmXSj2kMRkR9s+gnL5NLJPxFl8yjlBAr89r/Yu+XUpIFohI6cD580IxfA53P0bOITPYUy3Lp6tVkpKcc6HiZYR6OwV5P6JZZGd5QC6N9hifAEjyM+MmMIf/r5yjc6v+WUizVYCNwTQlx6x6xWz/lmMesaEG3aiNsL6izjpvotHxFc8GcZ+xFaAr7+6YyqpbjepD0d+8wUx+OfK7hkEuxTS0TdL3dTEpGt65vNnBDgMlIU+75mD27+Kx9ionZ7HmKWp3xFWbpr8NDe9dtT8VePPwFB1NjxdC8EcPtdaLfLe/dKsPI2NTdwE1Goi2aftggV54D2WJIKYxs7M9ooYNt6CwABVjkfdWwfMHMMkKCa5+o5oEoXIKY/EJhUxpVkqGIV26MSgRRHhMC6lKSHBWh9A5NUy6pLp/0UwB/+8GFN8l+3WGp05ZYqB5ELidYvSrQn4SqO2ePE1ihqK+lKU85C0eRZcv2pgrsL8XySBw0j8xSR0xIs5lKPD/EtUj8Klnzn8ARMTNyqSEgnqTj32BAoKlhiX8hVC12R6kWfN/4fLMviSVoPREHg6EoZgMHcJnDkVucpciWc7Zdnh4T1AuoHALXG0EJ9qEWdrxxFHfwL19zCu9sbPuwwf8HvqthNRHlasETMDPV9UrISO3GCqsSwFIQUKY3bRHDFr0bDoxgg0uYMADGwbA+rbRBltZ99LLJr7HH0HMPOIIHE3j8SvFUfAh+7UrFCktV4R3ByDPazZTp/ea2DVj8Cmv+yHLqe5PzW
 4GL8kQNv
 4rjdc7/Fg/RA3JPVVd3fwiMBqvzeUgOwrLswbYHrRN36mwcDgXVCYN4b67v2czREpxR0rRNcubWJHlz4Ypx7M46QptKUWF7aE+ZmSeBEphDUL1X5vxpMrTLQ6AUyib/mnJmAsK4j1SZnsHHgolYWCZr1dum7advozI9F8m/cM68cwF1fp/Bya2hpvQlBy6AIjndepKQNgJvbI8B2GoRRv12AdbwP3QVeUNI3sS3s5YtluFRZgDg1/lh+5uvyA2j8rZy0rq+oYl+OJQYzX2KwfhdNVLjJDeSLBt1p96VxJgxvyPGPG8XTBzBdDC1LUDdlfJLH1cvbs0FpN6bObw+B9yQYC6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Yuwen,

On Thu, Nov 06, 2025 at 09:49:01AM +0800, Yuwen Chen wrote:
> For block devices, sequential write performance is significantly
> better than random write. Currently, zram's write-back function
> only supports single-page operations, which fails to leverage
> the sequential write advantage and leads to suboptimal performance.
> 
> This patch implements multi-page batch write-back for zram to
> leverage sequential write performance of block devices.
> 
> After applying this patch, a large number of pages being merged
> into batch write operations can be observed via the following test
> code, which effectively improves write-back performance.
> 
> We used the following instructions to conduct a performance test
> on the write-back function of zram in the QEMU environment.
> $ echo "/dev/sdb" > /sys/block/zram0/backing_dev
> $ echo "1024000000" > /sys/block/zram0/disksize
> $ dd if=/dev/random of=/dev/zram0
> $ time echo "page_indexes=1-100000" > /sys/block/zram0/writeback
> 
> before modification:
> real	0m 16.62s
> user	0m 0.00s
> sys	0m 5.98s
> 
> real	0m 15.38s
> user	0m 0.00s
> sys	0m 5.31s
> 
> real	0m 15.58s
> user	0m 0.00s
> sys	0m 5.49s
> 
> after modification:
> real	0m 1.36s
> user	0m 0.00s
> sys	0m 1.13s
> 
> real	0m 1.36s
> user	0m 0.00s
> sys	0m 1.11s
> 
> real	0m 1.39s
> user	0m 0.00s
> sys	0m 1.16s

That's the great improvement. Thanks.

Have you check the other effort?
https://lore.kernel.org/lkml/20250731064949.1690732-3-richardycc@google.com/

In my opinion, it's much simpler and strightforward align with current zram
writeback utility functions.

Do you have any issue with that?

> 
> Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
> Reviewed-by: Fengyu Lian <licayy@outlook.com>
> ---
> Changes in v4:
>   - Add performance test data.
> Changes in v3:
>   - Postpone the page allocation.
> Changes in v2:
>   - Rename some data structures.
>   - Fix an exception caused by accessing a null pointer.
> ---
>  drivers/block/zram/zram_drv.c | 224 ++++++++++++++++++++++++++--------
>  1 file changed, 170 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 4f2824a..ce8fc3c 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -751,21 +751,131 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
>  	submit_bio(bio);
>  }
>  
> -static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
> -{
> -	unsigned long blk_idx = 0;
> -	struct page *page = NULL;
> +enum {
> +	/* Indicate that the request has been allocated */
> +	ZRAM_WB_REQUEST_ALLOCATED = 0,
> +
> +	/* the request has been processed by the block device layer */
> +	ZRAM_WB_REQUEST_COMPLETED,
> +};
> +
> +struct zram_wb_request {
> +	struct completion *done;
> +	unsigned long blk_idx;
> +	struct page *page;
>  	struct zram_pp_slot *pps;
>  	struct bio_vec bio_vec;
>  	struct bio bio;
> -	int ret = 0, err;
> -	u32 index;
> +	unsigned long flags;
> +};
>  
> -	page = alloc_page(GFP_KERNEL);
> -	if (!page)
> -		return -ENOMEM;
> +static int zram_writeback_complete(struct zram *zram, struct zram_wb_request *req)
> +{
> +	u32 index = 0;
> +	int err;
>  
> -	while ((pps = select_pp_slot(ctl))) {
> +	if (!test_and_clear_bit(ZRAM_WB_REQUEST_COMPLETED, &req->flags))
> +		return 0;
> +
> +	err = blk_status_to_errno(req->bio.bi_status);
> +	if (err)
> +		return err;
> +
> +	index = req->pps->index;
> +	atomic64_inc(&zram->stats.bd_writes);
> +	zram_slot_lock(zram, index);
> +	/*
> +	 * Same as above, we release slot lock during writeback so
> +	 * slot can change under us: slot_free() or slot_free() and
> +	 * reallocation (zram_write_page()). In both cases slot loses
> +	 * ZRAM_PP_SLOT flag. No concurrent post-processing can set
> +	 * ZRAM_PP_SLOT on such slots until current post-processing
> +	 * finishes.
> +	 */
> +	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
> +		goto next;
> +
> +	zram_free_page(zram, index);
> +	zram_set_flag(zram, index, ZRAM_WB);
> +	zram_set_handle(zram, index, req->blk_idx);
> +	req->blk_idx = 0;
> +	atomic64_inc(&zram->stats.pages_stored);
> +	spin_lock(&zram->wb_limit_lock);
> +	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
> +		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
> +	spin_unlock(&zram->wb_limit_lock);
> +
> +next:
> +	zram_slot_unlock(zram, index);
> +	release_pp_slot(zram, req->pps);
> +	req->pps = NULL;
> +	return 0;
> +}
> +
> +static void zram_writeback_endio(struct bio *bio)
> +{
> +	struct zram_wb_request *req = bio->bi_private;
> +
> +	set_bit(ZRAM_WB_REQUEST_COMPLETED, &req->flags);
> +	clear_bit(ZRAM_WB_REQUEST_ALLOCATED, &req->flags);
> +	complete(req->done);
> +}
> +
> +static struct zram_wb_request *zram_writeback_next_request(struct zram_wb_request *pool,
> +	int pool_cnt, int *cnt_off)
> +{
> +	struct zram_wb_request *req = NULL;
> +	int i = 0;
> +
> +	for (i = *cnt_off; i < pool_cnt + *cnt_off; i++) {
> +		req = &pool[i % pool_cnt];
> +		if (!req->page) {
> +			/* This memory should be freed by the caller. */
> +			req->page = alloc_page(GFP_KERNEL);
> +			if (!req->page)
> +				continue;
> +		}
> +
> +		if (!test_and_set_bit(ZRAM_WB_REQUEST_ALLOCATED, &req->flags)) {
> +			*cnt_off = (i + 1) % pool_cnt;
> +			return req;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +#define ZRAM_WB_REQ_CNT (32)
> +static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
> +{
> +	int ret = 0, err, i = 0, cnt_off = 0;
> +	int req_pool_cnt = 0;
> +	struct zram_wb_request req_prealloc[2] = {0};
> +	struct zram_wb_request *req = NULL, *req_pool = NULL;
> +	DECLARE_COMPLETION_ONSTACK(done);
> +	u32 index = 0;
> +	struct blk_plug plug;
> +
> +	/* allocate memory for req_pool */
> +	req_pool = kzalloc(sizeof(*req) * ZRAM_WB_REQ_CNT, GFP_KERNEL);
> +	if (req_pool) {
> +		req_pool_cnt = ZRAM_WB_REQ_CNT;
> +	} else {
> +		req_pool = req_prealloc;
> +		req_pool_cnt = ARRAY_SIZE(req_prealloc);
> +	}
> +
> +	for (i = 0; i < req_pool_cnt; i++) {
> +		req_pool[i].done = &done;
> +		req_pool[i].flags = 0;
> +	}
> +	req = zram_writeback_next_request(req_pool, req_pool_cnt, &cnt_off);
> +	if (!req) {
> +		ret = -ENOMEM;
> +		goto out_free_req_pool;
> +	}
> +
> +	blk_start_plug(&plug);
> +	while ((req->pps = select_pp_slot(ctl))) {
>  		spin_lock(&zram->wb_limit_lock);
>  		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
>  			spin_unlock(&zram->wb_limit_lock);
> @@ -774,15 +884,15 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
>  		}
>  		spin_unlock(&zram->wb_limit_lock);
>  
> -		if (!blk_idx) {
> -			blk_idx = alloc_block_bdev(zram);
> -			if (!blk_idx) {
> +		if (!req->blk_idx) {
> +			req->blk_idx = alloc_block_bdev(zram);
> +			if (!req->blk_idx) {
>  				ret = -ENOSPC;
>  				break;
>  			}
>  		}
>  
> -		index = pps->index;
> +		index = req->pps->index;
>  		zram_slot_lock(zram, index);
>  		/*
>  		 * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
> @@ -792,22 +902,32 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
>  		 */
>  		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
>  			goto next;
> -		if (zram_read_from_zspool(zram, page, index))
> +		if (zram_read_from_zspool(zram, req->page, index))
>  			goto next;
>  		zram_slot_unlock(zram, index);
>  
> -		bio_init(&bio, zram->bdev, &bio_vec, 1,
> +		bio_init(&req->bio, zram->bdev, &req->bio_vec, 1,
>  			 REQ_OP_WRITE | REQ_SYNC);
> -		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
> -		__bio_add_page(&bio, page, PAGE_SIZE, 0);
> -
> -		/*
> -		 * XXX: A single page IO would be inefficient for write
> -		 * but it would be not bad as starter.
> -		 */
> -		err = submit_bio_wait(&bio);
> +		req->bio.bi_iter.bi_sector = req->blk_idx * (PAGE_SIZE >> 9);
> +		req->bio.bi_end_io = zram_writeback_endio;
> +		req->bio.bi_private = req;
> +		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
> +
> +		list_del_init(&req->pps->entry);
> +		submit_bio(&req->bio);
> +
> +		do {
> +			req = zram_writeback_next_request(req_pool, req_pool_cnt, &cnt_off);
> +			if (!req) {
> +				blk_finish_plug(&plug);
> +				wait_for_completion_io(&done);
> +				blk_start_plug(&plug);
> +			}
> +		} while (!req);
> +		err = zram_writeback_complete(zram, req);
>  		if (err) {
> -			release_pp_slot(zram, pps);
> +			release_pp_slot(zram, req->pps);
> +			req->pps = NULL;
>  			/*
>  			 * BIO errors are not fatal, we continue and simply
>  			 * attempt to writeback the remaining objects (pages).
> @@ -817,43 +937,39 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
>  			 * the most recent BIO error.
>  			 */
>  			ret = err;
> -			continue;
>  		}
> +		cond_resched();
> +		continue;
>  
> -		atomic64_inc(&zram->stats.bd_writes);
> -		zram_slot_lock(zram, index);
> -		/*
> -		 * Same as above, we release slot lock during writeback so
> -		 * slot can change under us: slot_free() or slot_free() and
> -		 * reallocation (zram_write_page()). In both cases slot loses
> -		 * ZRAM_PP_SLOT flag. No concurrent post-processing can set
> -		 * ZRAM_PP_SLOT on such slots until current post-processing
> -		 * finishes.
> -		 */
> -		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
> -			goto next;
> -
> -		zram_free_page(zram, index);
> -		zram_set_flag(zram, index, ZRAM_WB);
> -		zram_set_handle(zram, index, blk_idx);
> -		blk_idx = 0;
> -		atomic64_inc(&zram->stats.pages_stored);
> -		spin_lock(&zram->wb_limit_lock);
> -		if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
> -			zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
> -		spin_unlock(&zram->wb_limit_lock);
>  next:
>  		zram_slot_unlock(zram, index);
> -		release_pp_slot(zram, pps);
> -
> +		release_pp_slot(zram, req->pps);
> +		req->pps = NULL;
>  		cond_resched();
>  	}
> +	blk_finish_plug(&plug);
>  
> -	if (blk_idx)
> -		free_block_bdev(zram, blk_idx);
> -	if (page)
> -		__free_page(page);
> +	if (req)
> +		clear_bit(ZRAM_WB_REQUEST_ALLOCATED, &req->flags);
> +	for (i = 0; i < req_pool_cnt; i++) {
> +		while (test_bit(ZRAM_WB_REQUEST_ALLOCATED, &req_pool[i].flags))
> +			wait_for_completion_io(&done);
> +		err = zram_writeback_complete(zram, &req_pool[i]);
> +		if (err) {
> +			release_pp_slot(zram, req_pool[i].pps);
> +			req->pps = NULL;
> +			ret = err;
> +		}
> +
> +		if (req_pool[i].blk_idx)
> +			free_block_bdev(zram, req_pool[i].blk_idx);
> +		if (req_pool[i].page)
> +			__free_page(req_pool[i].page);
> +	}
>  
> +out_free_req_pool:
> +	if (req_pool != req_prealloc)
> +		kfree(req_pool);
>  	return ret;
>  }
>  
> -- 
> 2.34.1
> 

