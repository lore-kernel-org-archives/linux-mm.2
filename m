Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9864FCD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12376B0005; Thu,  4 Jun 2026 06:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2566B0088; Thu,  4 Jun 2026 06:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7F86B008A; Thu,  4 Jun 2026 06:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 898446B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:58:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3235BC1CCB
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:58:46 +0000 (UTC)
X-FDA: 84841932252.14.10F35A3
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf17.hostedemail.com (Postfix) with ESMTP id BFD8940006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:58:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CSuYcNiG;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780570724;
	b=6KhxVQuNW08r76iloBuBbdy9p81+YBcoKS+JwXdWfVOgOUic5/8V6zQ1l7Q2bhv1GVkZ28
	zCZ5xF7uJf+iA0iINWNYFC/+UUfNJOE4/Sju2B7gM/iLGV3dWVFLIXPF2OaHKsM7OhgIn+
	RV6mqqLSuN2WVSwHzKndZYmPmEjbm/w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CSuYcNiG;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780570724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KnxQtQDmdQPl0EAiTNqNrKLNzw+RHG4m8r1B4/O8hU=;
	b=LbNp75MuSuKvApeUKNcQQiOAAxFxnASR1VLSCcrH34OpgrWRp9VQp9ALXdEkDH1OkBDR4X
	GinoiNhzy2qFu/qi8uAMNd3TApdZCMltxZeGmb/yZyzKmDQ1//R8eB+CijxB7X7sumlKI7
	0kxWet8UmKZhmcCrm6RC/Fd7OzjdqOc=
Date: Thu, 4 Jun 2026 18:58:34 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780570721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9KnxQtQDmdQPl0EAiTNqNrKLNzw+RHG4m8r1B4/O8hU=;
	b=CSuYcNiGhes62ENUNK0L/PJyyfs38+occq4yq8re72Iu2Dy3iIlDBX1wPxA7ArtzK9Tho9
	2Zw3lL59MpkPnCN9pXQvmTgm9HeFMuqoSGwqTC09sabBpmsnQ03HKY1TNrzHmsYbvQc7XC
	oN/FjBtHn5VyrN1L1nbAIPcorxPMu7g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/8] mm/swap: introduce struct swap_io_ctx
Message-ID: <aiFaWmCWgEWAFj4W@MiWiFi-R3L-srv>
References: <20260601113449.3464734-1-hch@lst.de>
 <20260601113449.3464734-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260601113449.3464734-4-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BFD8940006
X-Stat-Signature: 47hu76d4tnoq7zfcd47ycnxwd1fhpqoa
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780570723-888849
X-HE-Meta: U2FsdGVkX1+UjhzcZQ20Cn2xYtMUlMDaiTGkRqDu3piFEiRSGhmyjWtnm9kz8Bj4cOyToX5Zo+mCfYXN6Qg6vjrhbRwS6d0pZW4AFdoYbxaYEsHh16Jn6O9XFrcinsWsmXxsGxey6s2C+vMHSLBYDuT9LCcHzw5HvSp29EJ9LP3GoXWb29KamsTIsJd3wwp1/nKQQQ5chIjs3ik0+7y7y+2JVAKU3fR+hONMmCGw85uIt4WnUfxTDY1xfJxlARG25CPLSKjtHlUokCPJghhAyHj0nacgorKtHOY+Vmyqghk9IL3y87cyFZg/etAb8aEX2WDRvmN6gLpYOLIPWaM2gFzYT3NuQW1MJNwjEAnO7WVk2SpaoDH1IZ2OT4p6+D8VLxAnTvbDKzzYpsjc7NRBj7N2JKhz9JwRUrcRn+0mkV2sbezPCZLe2+3cv+AJs6F6B4enOXzq1wVGQedaT8A6XciDLCt9vaKMYWQfDkE+jND28oGXL6hkj4a316HgsPfZ0R0fHqG+VHiPUCMUqJc/boPLjXi5TjQ0drA1RH7yWuJx9cfaiSgj7GrnVXzSOp/WfyyImoInIjXxqPl/uvprp+Qln6TblwQpKmSPkUxeuXgLvXYpLnuWessCHibmDdUUP7+nNgR19ZsPnujBoteGsEs0J7AzH1cYi1Qec7DCEpauCOAVTNUA650QTBt75BZacHCqkCeDDCozJ9539V4qzcYeCn28k/U2eUWjdwkGaJP3FYXNMiW+qTYnZ/RfvbnwgLU5VYHgYH+fFbmx7q0zss0CV76hj4f8Vt2i+vYmL2U7HcO5WJ3kb7wjEOgtUdXudMm5fZG1PQilFYn1xriCRWHUL3s0Q2yGoasfv1AUo8IM2dyKli9J2wpdfTLQx5qwccbC0Zq1QNfMsr2tX9QLUN/El6P9wFaeeOZeW94neyr1Yd0LM3Vv7hAKOHudo0nFOJqdQAb9y5plgQkEPY+
 rH97yo92
 1yVCL6QjvLBL5hvf1CbUlCaDxmfgQTI9ZYNSe6Uadd5rsVT870WQCQhgRmM5U+usBVxhCTE+yVfGmTaa0mt2AfAnSUrGnnDF6lT3Dl/nLU8h0vRDTFE1Fct2yAm6VEkeJQeU5x3NQJbSPTK8CKULuVJDzBCdQvLJ2S4TYMysfmsDpDY2sqJ9xwj/CY3vG+PCcfqd992yM1puPL8OErtpEhRmEKHFdlUK92cgcuhe1kOhkSaPHLvmMNFy6GhMF2bS1rwdlHSS/ImTlWiKqdElqnvASjiQEwNcky74z2bsRkrwj55v7NlzMyAe26IaMTaNURc/7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/26 at 01:34pm, Christoph Hellwig wrote:
> Generalize the context currently provided by double pointers to struct
> swap_iocb to an on-stack context.  This cleans up the code and prepares
> for adding more fields and supporting batching multiple folios into a
> single bio for block-based swap as well.
> 
> This new swap_io_ctx is required for all functions using it, the old
> way of allowing a NULL iocb for some callers is removed to keep the
> interface consistent.

In this patch, except of introducng struct swap_io_ctx, it also does:
- swap_cache_read_folio_sync() helper introduced for the two readahead
  "skip" paths where the target page was already read
- swap_write_unplug → swap_write_submit,
  __swap_read_unplug → swap_read_submit;
  the NULL-checking inline swap_read_unplug() wrapper is removed

It would be better if these are mentioned in log too, or should be split
into a separate patch. Otherwise it doesn't match the subject.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/madvise.c    | 16 ++++++-------
>  mm/page_io.c    | 60 ++++++++++++++++++++++++++-----------------------
>  mm/shmem.c      | 13 +++++++----
>  mm/swap.h       | 36 +++++++++++++----------------
>  mm/swap_state.c | 53 +++++++++++++++++++++++++------------------
>  mm/vmscan.c     | 15 ++++++-------
>  mm/zswap.c      |  4 +++-
>  7 files changed, 106 insertions(+), 91 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index cd9bb077072c..cd84e993190a 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -188,7 +188,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
>  		unsigned long end, struct mm_walk *walk)
>  {
>  	struct vm_area_struct *vma = walk->private;
> -	struct swap_iocb *splug = NULL;
> +	struct swap_io_ctx ctx = {};
>  	pte_t *ptep = NULL;
>  	spinlock_t *ptl;
>  	unsigned long addr;
> @@ -212,15 +212,15 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
>  		pte_unmap_unlock(ptep, ptl);
>  		ptep = NULL;
>  
> -		folio = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
> -					     vma, addr, &splug);
> +		folio = read_swap_cache_async(&ctx, entry, GFP_HIGHUSER_MOVABLE,
> +					vma, addr);

And I am wondering why &ctx has to be put as the 1st para, is there a
rule of C language or linux kernel? It obviously adds a lot of
unnecessary code churn. I will read swap cache, of course swap entry is
the main subject I will operate on, why bother moving &ctx which is
associated date at first.

>  		if (folio)
>  			folio_put(folio);
>  	}
>  
>  	if (ptep)
>  		pte_unmap_unlock(ptep, ptl);
> -	swap_read_unplug(splug);
> +	swap_read_submit(&ctx);
>  	cond_resched();
>  
>  	return 0;
> @@ -238,7 +238,7 @@ static void shmem_swapin_range(struct vm_area_struct *vma,
>  	XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
>  	pgoff_t end_index = linear_page_index(vma, end) - 1;
>  	struct folio *folio;
> -	struct swap_iocb *splug = NULL;
> +	struct swap_io_ctx ctx = {};
>  
>  	rcu_read_lock();
>  	xas_for_each(&xas, folio, end_index) {
> @@ -257,15 +257,15 @@ static void shmem_swapin_range(struct vm_area_struct *vma,
>  		xas_pause(&xas);
>  		rcu_read_unlock();
>  
> -		folio = read_swap_cache_async(entry, mapping_gfp_mask(mapping),
> -					     vma, addr, &splug);
> +		folio = read_swap_cache_async(&ctx, entry,
> +				mapping_gfp_mask(mapping), vma, addr);
>  		if (folio)
>  			folio_put(folio);
>  
>  		rcu_read_lock();
>  	}
>  	rcu_read_unlock();
> -	swap_read_unplug(splug);
> +	swap_read_submit(&ctx);
>  }
>  #endif		/* CONFIG_SWAP */
>  
> diff --git a/mm/page_io.c b/mm/page_io.c
> index f2d8fe7fd057..0bf035dc1170 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -248,7 +248,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
>   * We may have stale swap cache pages in memory: notice
>   * them here and get rid of the unnecessary final write.
>   */
> -int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
> +int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>  	int ret = 0;
>  
> @@ -295,7 +295,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
>  	}
>  	rcu_read_unlock();
>  
> -	__swap_writepage(folio, swap_plug);
> +	__swap_writepage(ctx, folio);
>  	return 0;
>  out_unlock:
>  	folio_unlock(folio);
> @@ -385,9 +385,9 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
>  	mempool_free(sio, sio_pool);
>  }
>  
> -static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
> +static void swap_writepage_fs(struct swap_io_ctx *ctx, struct folio *folio)
>  {
> -	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
> +	struct swap_iocb *sio = ctx->sio;
>  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
>  	struct file *swap_file = sis->swap_file;
>  	loff_t pos = swap_dev_pos(folio->swap);
> @@ -398,7 +398,7 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
>  	if (sio) {
>  		if (sio->iocb.ki_filp != swap_file ||
>  		    sio->iocb.ki_pos + sio->len != pos) {
> -			swap_write_unplug(sio);
> +			swap_write_submit(ctx);
>  			sio = NULL;
>  		}
>  	}
> @@ -413,12 +413,11 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
>  	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
>  	sio->len += folio_size(folio);
>  	sio->nr_bvecs += 1;
> -	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) || !swap_plug) {
> -		swap_write_unplug(sio);
> +	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
> +		swap_write_submit(ctx);
>  		sio = NULL;
>  	}
> -	if (swap_plug)
> -		*swap_plug = sio;
> +	ctx->sio = sio;
>  }
>  
>  static void swap_writepage_bdev_sync(struct folio *folio,
> @@ -458,7 +457,7 @@ static void swap_writepage_bdev_async(struct folio *folio,
>  	submit_bio(bio);
>  }
>  
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> +void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
>  
> @@ -469,7 +468,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
>  	 * is safe.
>  	 */
>  	if (data_race(sis->flags & SWP_FS_OPS))
> -		swap_writepage_fs(folio, swap_plug);
> +		swap_writepage_fs(ctx, folio);
>  	/*
>  	 * ->flags can be updated non-atomically,
>  	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
> @@ -481,16 +480,20 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
>  		swap_writepage_bdev_async(folio, sis);
>  }
>  
> -void swap_write_unplug(struct swap_iocb *sio)
> +void swap_write_submit(struct swap_io_ctx *ctx)
>  {
> +	struct swap_iocb *sio = ctx->sio;
>  	struct iov_iter from;
> -	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
>  	int ret;
>  
> +	if (!sio)
> +		return;
> +
>  	iov_iter_bvec(&from, ITER_SOURCE, sio->bvecs, sio->nr_bvecs, sio->len);
> -	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
> +	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &from);
>  	if (ret != -EIOCBQUEUED)
>  		sio_write_complete(&sio->iocb, ret);
> +	ctx->sio = NULL;
>  }
>  
>  static void sio_read_complete(struct kiocb *iocb, long ret)
> @@ -582,18 +585,16 @@ static bool swap_read_folio_zeromap(struct folio *folio)
>  	return true;
>  }
>  
> -static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
> +static void swap_read_folio_fs(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> -	struct swap_iocb *sio = NULL;
> +	struct swap_iocb *sio = ctx->sio;
>  	loff_t pos = swap_dev_pos(folio->swap);
>  
> -	if (plug)
> -		sio = *plug;
>  	if (sio) {
>  		if (sio->iocb.ki_filp != sis->swap_file ||
>  		    sio->iocb.ki_pos + sio->len != pos) {
> -			swap_read_unplug(sio);
> +			swap_read_submit(ctx);
>  			sio = NULL;
>  		}
>  	}
> @@ -608,12 +609,11 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
>  	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
>  	sio->len += folio_size(folio);
>  	sio->nr_bvecs += 1;
> -	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) || !plug) {
> -		swap_read_unplug(sio);
> +	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
> +		swap_read_submit(ctx);
>  		sio = NULL;
>  	}
> -	if (plug)
> -		*plug = sio;
> +	ctx->sio = sio;
>  }
>  
>  static void swap_read_folio_bdev_sync(struct folio *folio,
> @@ -653,7 +653,7 @@ static void swap_read_folio_bdev_async(struct folio *folio,
>  	submit_bio(bio);
>  }
>  
> -void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> +void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
>  	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
> @@ -688,7 +688,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  	zswap_folio_swapin(folio);
>  
>  	if (data_race(sis->flags & SWP_FS_OPS)) {
> -		swap_read_folio_fs(folio, plug);
> +		swap_read_folio_fs(ctx, folio);
>  	} else if (synchronous) {
>  		swap_read_folio_bdev_sync(folio, sis);
>  	} else {
> @@ -703,14 +703,18 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  	delayacct_swapin_end();
>  }
>  
> -void __swap_read_unplug(struct swap_iocb *sio)
> +void swap_read_submit(struct swap_io_ctx *ctx)
>  {
> +	struct swap_iocb *sio = ctx->sio;
>  	struct iov_iter from;
> -	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
>  	int ret;
>  
> +	if (!sio)
> +		return;
> +
>  	iov_iter_bvec(&from, ITER_DEST, sio->bvecs, sio->nr_bvecs, sio->len);
> -	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
> +	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &from);
>  	if (ret != -EIOCBQUEUED)
>  		sio_read_complete(&sio->iocb, ret);
> +	ctx->sio = NULL;
>  }
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d10735e49b25..17eb16dbfaa9 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1584,13 +1584,13 @@ int shmem_unuse(unsigned int type)
>  
>  /**
>   * shmem_writeout - Write the folio to swap
> + * @ctx: swap I/O context
>   * @folio: The folio to write
> - * @plug: swap plug
>   * @folio_list: list to put back folios on split
>   *
>   * Move the folio from the page cache to the swap cache.
>   */
> -int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> +int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>  		struct list_head *folio_list)
>  {
>  	struct address_space *mapping = folio->mapping;
> @@ -1702,7 +1702,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
>  
>  		BUG_ON(folio_mapped(folio));
> -		error = swap_writeout(folio, plug);
> +		error = swap_writeout(ctx, folio);
>  		if (error != AOP_WRITEPAGE_ACTIVATE) {
>  			/* folio has been unlocked */
>  			return error;
> @@ -1741,7 +1741,12 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  
>  int shmem_write_folio(struct folio *folio)
>  {
> -	return shmem_writeout(folio, NULL, NULL);
> +	struct swap_io_ctx ctx = {};
> +	int err;
> +
> +	err = shmem_writeout(&ctx, folio, NULL);
> +	swap_write_submit(&ctx);
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(shmem_write_folio);
>  
> diff --git a/mm/swap.h b/mm/swap.h
> index 4f86ef338a60..79d66272dfd4 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/atomic.h> /* for atomic_long_t */
>  #include <linux/mm.h> /* for PAGE_SHIFT */
> +
>  struct mempolicy;
>  struct swap_iocb;
>  struct swap_memcg_table;
> @@ -78,6 +79,10 @@ enum swap_cluster_flags {
>  	CLUSTER_FLAG_MAX,
>  };
>  
> +struct swap_io_ctx {
> +	struct swap_iocb	*sio;
> +};
> +
>  #ifdef CONFIG_SWAP
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
> @@ -240,17 +245,11 @@ extern void __swap_cluster_free_entries(struct swap_info_struct *si,
>  
>  /* linux/mm/page_io.c */
>  int sio_pool_init(void);
> -struct swap_iocb;
> -void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
> -void __swap_read_unplug(struct swap_iocb *plug);
> -static inline void swap_read_unplug(struct swap_iocb *plug)
> -{
> -	if (unlikely(plug))
> -		__swap_read_unplug(plug);
> -}
> -void swap_write_unplug(struct swap_iocb *sio);
> -int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
> +void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
> +void swap_read_submit(struct swap_io_ctx *ctx);
> +void swap_write_submit(struct swap_io_ctx *ctx);
> +int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
> +void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
>  
>  /* linux/mm/swap_state.c */
>  extern struct address_space swap_space __read_mostly;
> @@ -317,9 +316,8 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
>  
>  void show_swap_cache_info(void);
>  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
> -struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> -		struct vm_area_struct *vma, unsigned long addr,
> -		struct swap_iocb **plug);
> +struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
> +		gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long addr);
>  struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
>  		struct mempolicy *mpol, pgoff_t ilx);
>  struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
> @@ -335,7 +333,6 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
>  }
>  
>  #else /* CONFIG_SWAP */
> -struct swap_iocb;
>  static inline struct swap_cluster_info *swap_cluster_lock(
>  	struct swap_info_struct *si, pgoff_t offset, bool irq)
>  {
> @@ -381,11 +378,11 @@ static inline void folio_put_swap(struct folio *folio, struct page *page)
>  {
>  }
>  
> -static inline void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> +static inline void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>  }
>  
> -static inline void swap_write_unplug(struct swap_iocb *sio)
> +static inline void swap_write_submit(struct swap_io_ctx *ctx)
>  {
>  }
>  
> @@ -427,8 +424,7 @@ static inline void swap_update_readahead(struct folio *folio,
>  {
>  }
>  
> -static inline int swap_writeout(struct folio *folio,
> -		struct swap_iocb **swap_plug)
> +static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>  	return 0;
>  }
> @@ -474,7 +470,7 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
>  
>  #endif /* CONFIG_SWAP */
>  
> -int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> +int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>  		struct list_head *folio_list);
>  
>  #endif /* _MM_SWAP_H */
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 04f5ce992401..b9613026950e 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -623,9 +623,9 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
>  	}
>  }
>  
> -static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
> -					   struct mempolicy *mpol, pgoff_t ilx,
> -					   struct swap_iocb **plug, bool readahead)
> +static struct folio *swap_cache_read_folio(struct swap_io_ctx *ctx,
> +		swp_entry_t entry, gfp_t gfp, struct mempolicy *mpol,
> +		pgoff_t ilx, bool readahead)
>  {
>  	struct folio *folio;
>  
> @@ -639,7 +639,7 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
>  	if (IS_ERR_OR_NULL(folio))
>  		return NULL;
>  
> -	swap_read_folio(folio, plug);
> +	swap_read_folio(ctx, folio);
>  	if (readahead) {
>  		folio_set_readahead(folio);
>  		count_vm_event(SWAP_RA);
> @@ -667,6 +667,7 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
>  struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
>  			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
>  {
> +	struct swap_io_ctx ctx = {};
>  	struct folio *folio;
>  
>  	do {
> @@ -679,7 +680,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
>  	if (IS_ERR(folio))
>  		return folio;
>  
> -	swap_read_folio(folio, NULL);
> +	swap_read_folio(&ctx, folio);
> +	swap_read_submit(&ctx);
>  	return folio;
>  }
>  
> @@ -689,9 +691,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
>   * A failure return means that either the page allocation failed or that
>   * the swap entry is no longer in use.
>   */
> -struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> -		struct vm_area_struct *vma, unsigned long addr,
> -		struct swap_iocb **plug)
> +struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
> +		gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long addr)
>  {
>  	struct swap_info_struct *si;
>  	struct mempolicy *mpol;
> @@ -703,13 +704,24 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		return NULL;
>  
>  	mpol = get_vma_policy(vma, addr, 0, &ilx);
> -	folio = swap_cache_read_folio(entry, gfp_mask, mpol, ilx, plug, false);
> +	folio = swap_cache_read_folio(ctx, entry, gfp_mask, mpol, ilx, false);
>  	mpol_cond_put(mpol);
>  
>  	put_swap_device(si);
>  	return folio;
>  }
>  
> +static struct folio *swap_cache_read_folio_sync(swp_entry_t entry, gfp_t gfp,
> +		struct mempolicy *mpol, pgoff_t ilx)
> +{
> +	struct swap_io_ctx ctx = {};
> +	struct folio *folio;
> +
> +	folio = swap_cache_read_folio(&ctx, entry, gfp, mpol, ilx, false);
> +	swap_read_submit(&ctx);
> +	return folio;
> +}
> +
>  static unsigned int __swapin_nr_pages(unsigned long prev_offset,
>  				      unsigned long offset,
>  				      int hits,
> @@ -798,8 +810,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  	unsigned long start_offset, end_offset;
>  	unsigned long mask;
>  	struct swap_info_struct *si = __swap_entry_to_info(entry);
> +	struct swap_io_ctx ctx = {};
>  	struct blk_plug plug;
> -	struct swap_iocb *splug = NULL;
>  	swp_entry_t ra_entry;
>  
>  	mask = swapin_nr_pages(offset) - 1;
> @@ -818,18 +830,17 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  	for (offset = start_offset; offset <= end_offset ; offset++) {
>  		/* Ok, do the async read-ahead now */
>  		ra_entry = swp_entry(swp_type(entry), offset);
> -		folio = swap_cache_read_folio(ra_entry, gfp_mask, mpol, ilx,
> -					      &splug, offset != entry_offset);
> +		folio = swap_cache_read_folio(&ctx, ra_entry, gfp_mask, mpol,
> +				ilx, offset != entry_offset);
>  		if (!folio)
>  			continue;
>  		folio_put(folio);
>  	}
>  	blk_finish_plug(&plug);
> -	swap_read_unplug(splug);
> +	swap_read_submit(&ctx);
>  	lru_add_drain();	/* Push any new pages onto the LRU now */
>  skip:
> -	/* The page was likely read above, so no need for plugging here */
> -	return swap_cache_read_folio(entry, gfp_mask, mpol, ilx, NULL, false);
> +	return swap_cache_read_folio_sync(entry, gfp_mask, mpol, ilx);
>  }
>  
>  static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
> @@ -889,8 +900,8 @@ static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
>  static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  		struct mempolicy *mpol, pgoff_t targ_ilx, struct vm_fault *vmf)
>  {
> +	struct swap_io_ctx ctx = {};
>  	struct blk_plug plug;
> -	struct swap_iocb *splug = NULL;
>  	struct folio *folio;
>  	pte_t *pte = NULL, pentry;
>  	int win;
> @@ -929,8 +940,8 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  			if (!si)
>  				continue;
>  		}
> -		folio = swap_cache_read_folio(entry, gfp_mask, mpol, ilx,
> -					      &splug, addr != vmf->address);
> +		folio = swap_cache_read_folio(&ctx, entry, gfp_mask, mpol, ilx,
> +					      addr != vmf->address);
>  		if (si)
>  			put_swap_device(si);
>  		if (!folio)
> @@ -940,13 +951,11 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  	if (pte)
>  		pte_unmap(pte);
>  	blk_finish_plug(&plug);
> -	swap_read_unplug(splug);
> +	swap_read_submit(&ctx);
>  	lru_add_drain();
>  skip:
>  	/* The folio was likely read above, so no need for plugging here */
> -	folio = swap_cache_read_folio(targ_entry, gfp_mask, mpol, targ_ilx,
> -				      NULL, false);
> -	return folio;
> +	return swap_cache_read_folio_sync(targ_entry, gfp_mask, mpol, targ_ilx);
>  }
>  
>  /**
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d7303eea1265..c43177a8e4dd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -615,8 +615,8 @@ typedef enum {
>  /*
>   * pageout is called by shrink_folio_list() for each dirty folio.
>   */
> -static pageout_t pageout(struct folio *folio, struct address_space *mapping,
> -			 struct swap_iocb **plug, struct list_head *folio_list)
> +static pageout_t pageout(struct swap_io_ctx *ctx, struct address_space *mapping,
> +		struct folio *folio, struct list_head *folio_list)
>  {
>  	int res;
>  
> @@ -652,9 +652,9 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>  	 * the split out folios get added back to folio_list.
>  	 */
>  	if (shmem_mapping(mapping))
> -		res = shmem_writeout(folio, plug, folio_list);
> +		res = shmem_writeout(ctx, folio, folio_list);
>  	else
> -		res = swap_writeout(folio, plug);
> +		res = swap_writeout(ctx, folio);
>  
>  	if (res < 0)
>  		handle_write_error(mapping, folio, res);
> @@ -1063,7 +1063,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  	unsigned int nr_reclaimed = 0, nr_demoted = 0;
>  	unsigned int pgactivate = 0;
>  	bool do_demote_pass;
> -	struct swap_iocb *plug = NULL;
> +	struct swap_io_ctx ctx = {};
>  
>  	folio_batch_init(&free_folios);
>  	memset(stat, 0, sizeof(*stat));
> @@ -1394,7 +1394,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  			 * starts and then write it out here.
>  			 */
>  			try_to_unmap_flush_dirty();
> -			switch (pageout(folio, mapping, &plug, folio_list)) {
> +			switch (pageout(&ctx, mapping, folio, folio_list)) {
>  			case PAGE_KEEP:
>  				goto keep_locked;
>  			case PAGE_ACTIVATE:
> @@ -1584,8 +1584,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  	list_splice(&ret_folios, folio_list);
>  	count_vm_events(PGACTIVATE, pgactivate);
>  
> -	if (plug)
> -		swap_write_unplug(plug);
> +	swap_write_submit(&ctx);
>  	return nr_reclaimed;
>  }
>  
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..feed2557f6ed 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -992,6 +992,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	struct folio *folio;
>  	struct mempolicy *mpol;
>  	struct swap_info_struct *si;
> +	struct swap_io_ctx ctx = {};
>  	int ret = 0;
>  
>  	/* try to allocate swap cache folio */
> @@ -1049,7 +1050,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	folio_set_reclaim(folio);
>  
>  	/* start writeback */
> -	__swap_writepage(folio, NULL);
> +	__swap_writepage(&ctx, folio);
> +	swap_write_submit(&ctx);
>  
>  out:
>  	if (ret) {
> -- 
> 2.53.0
> 

