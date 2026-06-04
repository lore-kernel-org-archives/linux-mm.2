Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF07CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C6B6B0096; Thu,  4 Jun 2026 07:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6AA6B0098; Thu,  4 Jun 2026 07:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE456B0099; Thu,  4 Jun 2026 07:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 934926B0096
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:37:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FD69A0747
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:37:21 +0000 (UTC)
X-FDA: 84842029482.07.0064819
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf17.hostedemail.com (Postfix) with ESMTP id B852E40004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:37:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o1ZqolNX;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780573039;
	b=eH5a9zVGUBZx6W62lcaTS3Z/GqYRRyvEJ0t7uiBr9LY6CSknrkAI74G1LL1+0nmI0wQXHP
	twMUhoGm0daubZjihmzWu2n/XJft7+Apob0N4IhUU4QmsiGn6JYPmZZacyP9b+mWcolg1H
	kMlNlulsg6Mgn/dNbCbiwjq0O7A7pZI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o1ZqolNX;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780573039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSljbG1Z5/3jW/nBAEMNFTEuX5Q//7FxjvKuET9DeNY=;
	b=OLKRwetjE/sRik6gGh1NXp//jC5MHQPQnbOhTAP3wckGkrb8Bzl/vEs+2RSAjuieukrPdM
	bd5V5RHlK/9sDzTWRXHi7WC+kUoCMsWfKino/Vzt1qLwijIAiz+pNuERTUPEQl8QiJt7Pw
	mTSQksUql9CO97R8N2PzYB8tr/AWToA=
Date: Thu, 4 Jun 2026 19:37:09 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780573035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lSljbG1Z5/3jW/nBAEMNFTEuX5Q//7FxjvKuET9DeNY=;
	b=o1ZqolNXVmwQ96SqD1uj/7rmarIOMwsFxr1UtCc2ofCan+Bo5H8KdFt7PaFi43VqoLC/3A
	aDG9nBTMGzIVXyS9LNQ6K5dhOErVd96BWHY7xaOteu/gxMomky24/htaSOYNGlCVbu/8kK
	PN6nT+j/o4F/seig5HnmFxBMhaxJLNY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/swap: also use struct swap_iocb for block I/O
Message-ID: <aiFjZXQ73awVxUFd@MiWiFi-R3L-srv>
References: <20260601113449.3464734-1-hch@lst.de>
 <20260601113449.3464734-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-5-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B852E40004
X-Stat-Signature: bx4rakthhfg384x1kkek7h6u41ms3bqt
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780573037-900919
X-HE-Meta: U2FsdGVkX1+lTdeBaE5OMsoMaetiNhtpwUjAiQuKfYPzxGA142nB7/yLOw1UYtpa+aG/ggnFbpSO3sMwGZDg+yUWCK9Ogc2bA0ULgqwMb9syBmy0ITJOCQ8+Q3odEU+6WqHlCwbV7RJ5W/vkmFduSjS/sVDsOCvqS4Dj6TXCMB6dCXgN884vZ824oLTTHrgG5RsMUS5wiIzYO53895xR8jfXYmmzHVUqn8Xbyk9uN8/3S4pTXxwpa+SJef3Jnbhs58YUwIkP60JfkOH4aVCTp2C3shUoz9pQAfj3+ag9LTx9Y6rH0dg3ARrwLOtDGKjQXYQZLpVx08j8fQXqNWlUtiXhhsyDVAVvpbtwS93R0RTITx0OCB0v9V6EQYhUUhwqVKsCM1GvJvTRWTlQ/+1/lbvEZXY1PioAgpF8oKOuKxrwrnQvPigMFfX8Oq2hbNPFoVx6j4+I954HU/51JNLMTeKh+baxciW72JFXtau3JfpVSYBg6fjqfZwe7mLzLwq58UZLy06N5dvMO58SOCIpfmb9uo10UJlm/+iGntHCPGiUbiS4eEjLZKq1abdr7aRhgRWCqAwf5LqyEvADRI4ZlUuTqK7bRLnKAHvUvoTeRGnUzrtnj7DyynY1bx+en3MB3kDtt6VXORDpWb4N0GT7ts1or5bAQSl4/eAli801JWzW7orMhbo/CpY5S9pLlGREGGDUmdFPc/JIAb0qw/dQkRnG1WPS0p4fJ7o8lC8L+JxxtLcEvfkV5KwCpxc8vOMd2mSkx96m7KyEb9s7vxE3TTnlfGjFA46Q5nBer+B1NVoI1PtJa8M0/kHlKJOPdBXvGuTU6HNvXnhn9myaI7tnIbLIsnl7l+FH+8MlCBawsZzxI1J0reuWP8TZ+prwDcHEJsmIZgTHm/abvIMBgWcZtc8bbamliQZDydNlvtWS0m8nTAA2plJOmmfvUvm1WGNiKUDR+nnSb1mBtWLc4gG
 NVcpNZpj
 Ef4uBxzq+84XGDBjbUlZ2j5S2oF2OvlNGV7w1Dug785QL4z9FgFo+1sEIi6YSOEK6tdVXbQEcrJ6cenHTZj6IDCt+Ak9FzgaVPOLI8itIF9WEmjY+nydFqdBd9NABoPtJTLUylWdmDn6wA/QayzAC0LTOGuFhO79F60CLwlqg0kPP9nJhLR9K3W1IgadPuKanKHGYGdifyxf8BqdWAkGKW8UwcRSWPTGHOyn8LryHHlfiPC9JPv59Mg4SWwuwuYBg0u7Q230xgJ/wTdaY3aj/u/xyGlQKMBzkFwiXvalRLyaMzdo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/26 at 01:34pm, Christoph Hellwig wrote:
> Block I/O benefits from batching just as much as remote file systems.
> Extent struct swap_iocb to support building a bio on the fly as well,
> and rewrite the block based swap code for it.  This especially benefits
> submit_bio based drivers that do not have the block plugging available,
> but also saves allocating extra bios for blk-mq drivers.
> 
> Note that the block based swap code now uses the same memcg-based
> check previously added for file system based swap as well.


I would add below words in log to ease patch reviewing/studying, while
it could be personal style.

What it does:
- Adds bio to a union with kiocb in struct swap_iocb, so the same sio
  can drive either FS or block I/O;
- Removes 6 functions (swap_writepage_bdev_sync, swap_writepage_bdev_async,
  swap_read_folio_bdev_sync, swap_read_folio_bdev_async, swap_writepage_fs,
  swap_read_folio_fs) and replaces them with a unified
  (swap_add_page + swap_can_merge + submit path);
- Adds sis pointer to swap_io_ctx for direct access in the submit path
- sio_pool_init() is now called unconditionally (not just for FS swap),
  which is necessary since bdev swap now also allocates from the sio pool;

swap_add_page() should be rename to swap_add_folio();

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_io.c  | 526 ++++++++++++++++++++++++--------------------------
>  mm/swap.h     |   1 +
>  mm/swapfile.c |   9 +-
>  3 files changed, 252 insertions(+), 284 deletions(-)
> 
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 0bf035dc1170..22c751fe03c0 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -28,54 +28,6 @@
>  #include "swap.h"
>  #include "swap_table.h"
>  
> -static void __end_swap_bio_write(struct bio *bio)
> -{
> -	struct folio *folio = bio_first_folio_all(bio);
> -
> -	if (bio->bi_status) {
> -		/*
> -		 * We failed to write the page out to swap-space.
> -		 * Re-dirty the page in order to avoid it being reclaimed.
> -		 * Also print a dire warning that things will go BAD (tm)
> -		 * very quickly.
> -		 *
> -		 * Also clear PG_reclaim to avoid folio_rotate_reclaimable()
> -		 */
> -		folio_mark_dirty(folio);
> -		pr_alert_ratelimited("Write-error on swap-device (%u:%u:%llu)\n",
> -				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
> -				     (unsigned long long)bio->bi_iter.bi_sector);
> -		folio_clear_reclaim(folio);
> -	}
> -	folio_end_writeback(folio);
> -}
> -
> -static void end_swap_bio_write(struct bio *bio)
> -{
> -	__end_swap_bio_write(bio);
> -	bio_put(bio);
> -}
> -
> -static void __end_swap_bio_read(struct bio *bio)
> -{
> -	struct folio *folio = bio_first_folio_all(bio);
> -
> -	if (bio->bi_status) {
> -		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
> -				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
> -				     (unsigned long long)bio->bi_iter.bi_sector);
> -	} else {
> -		folio_mark_uptodate(folio);
> -	}
> -	folio_unlock(folio);
> -}
> -
> -static void end_swap_bio_read(struct bio *bio)
> -{
> -	__end_swap_bio_read(bio);
> -	bio_put(bio);
> -}
> -
>  int generic_swapfile_activate(struct swap_info_struct *sis,
>  				struct file *swap_file,
>  				sector_t *span)
> @@ -316,26 +268,47 @@ static inline void count_swpout_vm_event(struct folio *folio)
>  }
>  
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
> -static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
> +static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
> +{
> +	return cgroup_e_css(folio_memcg(folio)->css.cgroup, &io_cgrp_subsys);
> +}
> +
> +static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
>  {
> -	struct cgroup_subsys_state *css;
> -	struct mem_cgroup *memcg;
> +	if (!folio_memcg_charged(folio) || !folio_memcg_charged(prev_folio))
> +		return true;
> +
> +	rcu_read_lock();
> +	if (folio_memcg_blkg_css(folio) != folio_memcg_blkg_css(prev_folio)) {
> +		rcu_read_unlock();
> +		return false;
> +	}
> +	rcu_read_unlock();
> +
> +	return true;
> +}
>  
> +static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
> +{
>  	if (!folio_memcg_charged(folio))
>  		return;
> -
>  	rcu_read_lock();
> -	memcg = folio_memcg(folio);
> -	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
> -	bio_associate_blkg_from_css(bio, css);
> +	bio_associate_blkg_from_css(bio, folio_memcg_blkg_css(folio));
>  	rcu_read_unlock();
>  }
>  #else
> +static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
> +{
> +	return true;
> +}
>  #define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
>  #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
>  
>  struct swap_iocb {
> -	struct kiocb		iocb;
> +	union {
> +		struct kiocb	iocb;
> +		struct bio	bio;
> +	};
>  	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
>  	int			nr_bvecs;
>  	int			len;
> @@ -355,171 +328,70 @@ int sio_pool_init(void)
>  	return 0;
>  }
>  
> -static void sio_write_complete(struct kiocb *iocb, long ret)
> +static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
> +		int rw)
>  {
> -	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
> -	struct page *page = sio->bvecs[0].bv_page;
> -	int p;
> +	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> +	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
> +	struct folio *prev_folio = page_folio(last_bv->bv_page);
> +	size_t prev_folio_size = folio_size(prev_folio);
>  
> -	if (ret != sio->len) {
> -		/*
> -		 * In the case of swap-over-nfs, this can be a
> -		 * temporary failure if the system has limited
> -		 * memory for allocating transmit buffers.
> -		 * Mark the page dirty and avoid
> -		 * folio_rotate_reclaimable but rate-limit the
> -		 * messages.
> -		 */
> -		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
> -				   ret, swap_dev_pos(page_swap_entry(page)));
> -		for (p = 0; p < sio->nr_bvecs; p++) {
> -			page = sio->bvecs[p].bv_page;
> -			set_page_dirty(page);
> -			ClearPageReclaim(page);
> -		}
> -	}
> +	if (ctx->sis != sis)
> +		return false;
>  
> -	for (p = 0; p < sio->nr_bvecs; p++)
> -		end_page_writeback(sio->bvecs[p].bv_page);
> +	if (sis->flags & SWP_FS_OPS) {
> +		if (swap_dev_pos(folio->swap) !=
> +		    swap_dev_pos(prev_folio->swap) + prev_folio_size)
> +			return false;
> +	} else {
> +		if (swap_folio_sector(folio) !=
> +		    swap_folio_sector(prev_folio) +
> +		    (prev_folio_size >> SECTOR_SHIFT))
> +			return false;
> +		if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
> +			return false;
> +	}
>  
> -	mempool_free(sio, sio_pool);
> +	return true;
>  }
>  
> -static void swap_writepage_fs(struct swap_io_ctx *ctx, struct folio *folio)
> +static void swap_add_page(struct swap_io_ctx *ctx, struct folio *folio, int rw)
>  {
> -	struct swap_iocb *sio = ctx->sio;
>  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> -	struct file *swap_file = sis->swap_file;
> -	loff_t pos = swap_dev_pos(folio->swap);
> +	struct swap_iocb *sio = ctx->sio;
>  
> -	count_swpout_vm_event(folio);
> -	folio_start_writeback(folio);
> -	folio_unlock(folio);
> -	if (sio) {
> -		if (sio->iocb.ki_filp != swap_file ||
> -		    sio->iocb.ki_pos + sio->len != pos) {
> +	if (sio && !swap_can_merge(ctx, folio, rw)) {
> +		if (rw == WRITE)
>  			swap_write_submit(ctx);
> -			sio = NULL;
> -		}
> +		else
> +			swap_read_submit(ctx);
> +		sio = ctx->sio;
>  	}
> +
>  	if (!sio) {
> -		sio = mempool_alloc(sio_pool, GFP_NOIO);
> -		init_sync_kiocb(&sio->iocb, swap_file);
> -		sio->iocb.ki_complete = sio_write_complete;
> -		sio->iocb.ki_pos = pos;
> +		ctx->sis = sis;
> +		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
>  		sio->nr_bvecs = 0;
>  		sio->len = 0;
>  	}
>  	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
>  	sio->len += folio_size(folio);
> -	sio->nr_bvecs += 1;
> -	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
> -		swap_write_submit(ctx);
> -		sio = NULL;
> +	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
> +		if (rw == WRITE)
> +			swap_write_submit(ctx);
> +		else
> +			swap_read_submit(ctx);
>  	}
> -	ctx->sio = sio;
> -}
> -
> -static void swap_writepage_bdev_sync(struct folio *folio,
> -		struct swap_info_struct *sis)
> -{
> -	struct bio_vec bv;
> -	struct bio bio;
> -
> -	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_WRITE | REQ_SWAP);
> -	bio.bi_iter.bi_sector = swap_folio_sector(folio);
> -	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
> -
> -	bio_associate_blkg_from_page(&bio, folio);
> -	count_swpout_vm_event(folio);
> -
> -	folio_start_writeback(folio);
> -	folio_unlock(folio);
> -
> -	submit_bio_wait(&bio);
> -	__end_swap_bio_write(&bio);
>  }
>  
> -static void swap_writepage_bdev_async(struct folio *folio,
> -		struct swap_info_struct *sis)
> +void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
>  {
> -	struct bio *bio;
> -
> -	bio = bio_alloc(sis->bdev, 1, REQ_OP_WRITE | REQ_SWAP, GFP_NOIO);
> -	bio->bi_iter.bi_sector = swap_folio_sector(folio);
> -	bio->bi_end_io = end_swap_bio_write;
> -	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
> +	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
>  
> -	bio_associate_blkg_from_page(bio, folio);
>  	count_swpout_vm_event(folio);
>  	folio_start_writeback(folio);
>  	folio_unlock(folio);
> -	submit_bio(bio);
> -}
> -
> -void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
> -{
> -	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> -
> -	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> -	/*
> -	 * ->flags can be updated non-atomically,
> -	 * but that will never affect SWP_FS_OPS, so the data_race
> -	 * is safe.
> -	 */
> -	if (data_race(sis->flags & SWP_FS_OPS))
> -		swap_writepage_fs(ctx, folio);
> -	/*
> -	 * ->flags can be updated non-atomically,
> -	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
> -	 * is safe.
> -	 */
> -	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> -		swap_writepage_bdev_sync(folio, sis);
> -	else
> -		swap_writepage_bdev_async(folio, sis);
> -}
> -
> -void swap_write_submit(struct swap_io_ctx *ctx)
> -{
> -	struct swap_iocb *sio = ctx->sio;
> -	struct iov_iter from;
> -	int ret;
> -
> -	if (!sio)
> -		return;
> -
> -	iov_iter_bvec(&from, ITER_SOURCE, sio->bvecs, sio->nr_bvecs, sio->len);
> -	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &from);
> -	if (ret != -EIOCBQUEUED)
> -		sio_write_complete(&sio->iocb, ret);
> -	ctx->sio = NULL;
> -}
> -
> -static void sio_read_complete(struct kiocb *iocb, long ret)
> -{
> -	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
> -	int p;
> -
> -	if (ret == sio->len) {
> -		for (p = 0; p < sio->nr_bvecs; p++) {
> -			struct folio *folio = page_folio(sio->bvecs[p].bv_page);
> -
> -			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
> -			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
> -			folio_mark_uptodate(folio);
> -			folio_unlock(folio);
> -		}
> -		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
> -	} else {
> -		for (p = 0; p < sio->nr_bvecs; p++) {
> -			struct folio *folio = page_folio(sio->bvecs[p].bv_page);
> -
> -			folio_unlock(folio);
> -		}
> -		pr_alert_ratelimited("Read-error on swap-device\n");
> -	}
> -	mempool_free(sio, sio_pool);
> +	swap_add_page(ctx, folio, WRITE);
>  }
>  
>  /*
> @@ -585,74 +457,6 @@ static bool swap_read_folio_zeromap(struct folio *folio)
>  	return true;
>  }
>  
> -static void swap_read_folio_fs(struct swap_io_ctx *ctx, struct folio *folio)
> -{
> -	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> -	struct swap_iocb *sio = ctx->sio;
> -	loff_t pos = swap_dev_pos(folio->swap);
> -
> -	if (sio) {
> -		if (sio->iocb.ki_filp != sis->swap_file ||
> -		    sio->iocb.ki_pos + sio->len != pos) {
> -			swap_read_submit(ctx);
> -			sio = NULL;
> -		}
> -	}
> -	if (!sio) {
> -		sio = mempool_alloc(sio_pool, GFP_KERNEL);
> -		init_sync_kiocb(&sio->iocb, sis->swap_file);
> -		sio->iocb.ki_pos = pos;
> -		sio->iocb.ki_complete = sio_read_complete;
> -		sio->nr_bvecs = 0;
> -		sio->len = 0;
> -	}
> -	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
> -	sio->len += folio_size(folio);
> -	sio->nr_bvecs += 1;
> -	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
> -		swap_read_submit(ctx);
> -		sio = NULL;
> -	}
> -	ctx->sio = sio;
> -}
> -
> -static void swap_read_folio_bdev_sync(struct folio *folio,
> -		struct swap_info_struct *sis)
> -{
> -	struct bio_vec bv;
> -	struct bio bio;
> -
> -	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_READ);
> -	bio.bi_iter.bi_sector = swap_folio_sector(folio);
> -	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
> -	/*
> -	 * Keep this task valid during swap readpage because the oom killer may
> -	 * attempt to access it in the page fault retry time check.
> -	 */
> -	get_task_struct(current);
> -	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
> -	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
> -	count_vm_events(PSWPIN, folio_nr_pages(folio));
> -	submit_bio_wait(&bio);
> -	__end_swap_bio_read(&bio);
> -	put_task_struct(current);
> -}
> -
> -static void swap_read_folio_bdev_async(struct folio *folio,
> -		struct swap_info_struct *sis)
> -{
> -	struct bio *bio;
> -
> -	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
> -	bio->bi_iter.bi_sector = swap_folio_sector(folio);
> -	bio->bi_end_io = end_swap_bio_read;
> -	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
> -	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
> -	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
> -	count_vm_events(PSWPIN, folio_nr_pages(folio));
> -	submit_bio(bio);
> -}
> -
>  void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> @@ -686,14 +490,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
>  
>  	/* We have to read from slower devices. Increase zswap protection. */
>  	zswap_folio_swapin(folio);
> -
> -	if (data_race(sis->flags & SWP_FS_OPS)) {
> -		swap_read_folio_fs(ctx, folio);
> -	} else if (synchronous) {
> -		swap_read_folio_bdev_sync(folio, sis);
> -	} else {
> -		swap_read_folio_bdev_async(folio, sis);
> -	}
> +	swap_add_page(ctx, folio, READ);
>  
>  finish:
>  	if (workingset) {
> @@ -703,18 +500,189 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
>  	delayacct_swapin_end();
>  }
>  
> -void swap_read_submit(struct swap_io_ctx *ctx)
> +static void swap_write_end(struct swap_iocb *sio, bool failed)
> +{
> +	int p;
> +
> +	for (p = 0; p < sio->nr_bvecs; p++) {
> +		struct page *page = sio->bvecs[p].bv_page;
> +
> +		if (failed) {
> +			set_page_dirty(page);
> +			ClearPageReclaim(page);
> +		}
> +		end_page_writeback(page);
> +	}
> +	mempool_free(sio, sio_pool);
> +}
> +
> +static void swap_fs_write_complete(struct kiocb *iocb, long ret)
> +{
> +	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
> +	bool failed = ret != sio->len;
> +
> +	if (failed) {
> +		struct page *page = sio->bvecs[0].bv_page;
> +
> +		/*
> +		 * In the case of swap-over-nfs, this can be a temporary failure
> +		 * if the system has limited memory for allocating transmit
> +		 * buffers.  Mark the page dirty and avoid
> +		 * folio_rotate_reclaimable but rate-limit the messages.
> +		 */
> +		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
> +				   ret, swap_dev_pos(page_swap_entry(page)));
> +	}
> +
> +	swap_write_end(sio, failed);
> +}
> +
> +static void end_swap_bio_write(struct bio *bio)
> +{
> +	struct swap_iocb *sio = container_of(bio, struct swap_iocb, bio);
> +	bool failed = !!bio->bi_status;
> +
> +	if (failed)
> +		pr_alert_ratelimited("Write-error on swap-device (%u:%u:%llu)\n",
> +				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
> +				     (unsigned long long)bio->bi_iter.bi_sector);
> +	bio_uninit(bio);
> +	swap_write_end(sio, failed);
> +}
> +
> +static void swap_read_end(struct swap_iocb *sio, bool failed)
> +{
> +	int p;
> +
> +	for (p = 0; p < sio->nr_bvecs; p++) {
> +		struct folio *folio = page_folio(sio->bvecs[p].bv_page);
> +
> +		if (!failed) {
> +			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
> +			count_memcg_folio_events(folio, PSWPIN,
> +					folio_nr_pages(folio));
> +			folio_mark_uptodate(folio);
> +		}
> +		folio_unlock(folio);
> +	}
> +
> +	if (!failed)
> +		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
> +
> +	mempool_free(sio, sio_pool);
> +}
> +
> +static void swap_fs_read_complete(struct kiocb *iocb, long ret)
> +{
> +	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
> +	bool failed = ret != sio->len;
> +
> +	if (failed)
> +		pr_alert_ratelimited("Read-error on swap-device\n");
> +	swap_read_end(sio, failed);
> +}
> +
> +static void swap_bio_read_end_io(struct bio *bio)
> +{
> +	struct swap_iocb *sio = container_of(bio, struct swap_iocb, bio);
> +	bool failed = !!bio->bi_status;
> +
> +	if (failed)
> +		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
> +				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
> +				     (unsigned long long)bio->bi_iter.bi_sector);
> +	bio_uninit(bio);
> +	swap_read_end(sio, failed);
> +}
> +
> +static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
>  {
>  	struct swap_iocb *sio = ctx->sio;
> -	struct iov_iter from;
> +	struct bio *bio = &sio->bio;
> +
> +	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
> +			REQ_OP_WRITE | REQ_SWAP);
> +	bio->bi_iter.bi_size = sio->len;
> +	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
> +	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
> +
> +	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
> +		submit_bio_wait(bio);
> +		end_swap_bio_write(bio);
> +	} else {
> +		bio->bi_end_io = end_swap_bio_write;
> +		submit_bio(bio);
> +	}
> +}
> +
> +static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
> +{
> +	struct swap_iocb *sio = ctx->sio;
> +	struct bio *bio = &sio->bio;
> +
> +	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
> +			REQ_OP_READ);
> +	bio->bi_iter.bi_size = sio->len;
> +	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
> +
> +	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
> +		/*
> +		 * Keep this task valid during swap readpage because the oom
> +		 * killer may attempt to access it in the page fault retry
> +		 * time check.
> +		 */
> +		get_task_struct(current);
> +		submit_bio_wait(bio);
> +		swap_bio_read_end_io(bio);
> +		put_task_struct(current);
> +	} else {
> +		bio->bi_end_io = swap_bio_read_end_io;
> +		submit_bio(bio);
> +	}
> +}
> +
> +static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
> +{
> +	struct swap_iocb *sio = ctx->sio;
> +	struct iov_iter iter;
>  	int ret;
>  
> -	if (!sio)
> -		return;
> +	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
> +	sio->iocb.ki_pos = swap_dev_pos(page_folio(sio->bvecs[0].bv_page)->swap);
> +	if (rw == WRITE)
> +		sio->iocb.ki_complete = swap_fs_write_complete;
> +	else
> +		sio->iocb.ki_complete = swap_fs_read_complete;
>  
> -	iov_iter_bvec(&from, ITER_DEST, sio->bvecs, sio->nr_bvecs, sio->len);
> -	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &from);
> +	iov_iter_bvec(&iter, rw == WRITE ? ITER_SOURCE : ITER_DEST,
> +			sio->bvecs, sio->nr_bvecs, sio->len);
> +	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &iter);
>  	if (ret != -EIOCBQUEUED)
> -		sio_read_complete(&sio->iocb, ret);
> +		sio->iocb.ki_complete(&sio->iocb, ret);
> +}
> +
> +void swap_write_submit(struct swap_io_ctx *ctx)
> +{
> +	if (!ctx->sio)
> +		return;
> +
> +	if (ctx->sis->flags & SWP_FS_OPS)
> +		swap_fs_submit(ctx, WRITE);
> +	else
> +		swap_bdev_submit_write(ctx);
> +	ctx->sio = NULL;
> +	ctx->sis = NULL;
> +}
> +
> +void swap_read_submit(struct swap_io_ctx *ctx)
> +{
> +	if (!ctx->sio)
> +		return;
> +
> +	if (ctx->sis->flags & SWP_FS_OPS)
> +		swap_fs_submit(ctx, READ);
> +	else
> +		swap_bdev_submit_read(ctx);
>  	ctx->sio = NULL;
> +	ctx->sis = NULL;
>  }
> diff --git a/mm/swap.h b/mm/swap.h
> index 79d66272dfd4..b6ba80c2afb0 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -81,6 +81,7 @@ enum swap_cluster_flags {
>  
>  struct swap_io_ctx {
>  	struct swap_iocb	*sio;
> +	struct swap_info_struct	*sis;
>  };
>  
>  #ifdef CONFIG_SWAP
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 615d90867111..2372f7cc4653 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2842,6 +2842,10 @@ static int setup_swap_extents(struct swap_info_struct *sis,
>  	struct inode *inode = mapping->host;
>  	int ret;
>  
> +	ret = sio_pool_init();
> +	if (ret)
> +		return ret;
> +
>  	if (S_ISBLK(inode->i_mode)) {
>  		ret = add_swap_extent(sis, 0, sis->max, 0);
>  		*span = sis->pages;
> @@ -2853,11 +2857,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
>  		if (ret < 0)
>  			return ret;
>  		sis->flags |= SWP_ACTIVATED;
> -		if ((sis->flags & SWP_FS_OPS) &&
> -		    sio_pool_init() != 0) {
> -			destroy_swap_extents(sis, swap_file);
> -			return -ENOMEM;
> -		}
>  		return ret;
>  	}
>  
> -- 
> 2.53.0
> 

