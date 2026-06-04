Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9343DCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 09:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37E06B008A; Thu,  4 Jun 2026 05:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F466B008C; Thu,  4 Jun 2026 05:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4CB96B0092; Thu,  4 Jun 2026 05:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B63A76B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:43:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 596A9A06CF
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:43:42 +0000 (UTC)
X-FDA: 84841743084.07.D4E321C
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf21.hostedemail.com (Postfix) with ESMTP id C0E351C000A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:43:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=STSb+Wg4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780566220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YS0Z6L8sw7twjsBLJ97HnWjbk7ygAypl5FjNfpEGmnE=;
	b=PGFbzQtA75hcW4Dot4/I7lk/VwrHKd9hYg0DfhWjF47jkVp+/k1CQcyjMPI1uXngEvqbHD
	JrbyOt6afdA7D/UiCtohzZRMpJl0t4PaAuHZwiMV8vg1SbflOzD7OrPC+UhtZfzmhzCcGJ
	qP7dtW1kKChWfELgtKSozLb+M0uWap4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=STSb+Wg4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780566220;
	b=YkSrLF5By1gSe4waP964XAoKvRQJq1ld67pmRaYXNTuqw8FZJhWzlB76cMkPjKeeMyveTq
	gqaSeXC1kR/yv+7Dhf/1P6AtM1AG/W6t07WrUoaK1y+SnTu/A8obi24TJqgYjo/GzpcSKS
	2uwiaJblKWM4949pX36izRl2i6V8KWY=
Date: Thu, 4 Jun 2026 17:43:31 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780566216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YS0Z6L8sw7twjsBLJ97HnWjbk7ygAypl5FjNfpEGmnE=;
	b=STSb+Wg4Z3gyWc+T7aubXKqzt/1VfckcH6XqXClv0cacVEvy9p9H4/oRBAJn/uZLdBGUm1
	/la0+ppAZ1mDzICJv0exjXZ51tkZ4GqJyMH+usrnER7FyXsw3rIQYEIiMxnCOKNTbtbN2R
	++UAweW/pHP1jAZnW4LNDXk7sS3hLwA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 1/8] shmem: provide a shmem_write_folio wrapper
Message-ID: <aiFIwwTTnjq1ATiH@MiWiFi-R3L-srv>
References: <20260601113449.3464734-1-hch@lst.de>
 <20260601113449.3464734-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-2-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C0E351C000A
X-Stat-Signature: 5ui7ek16y4agtdcwwdjzfo1bcazig35g
X-Rspam-User: 
X-HE-Tag: 1780566218-197151
X-HE-Meta: U2FsdGVkX195b6tpE3pP4W7MeQRmO75EZYdZAoS3q5RimaYxyzDM9S/3lNNze09viR/mHao4FUija6f5Vdvb4AznZ88nZMBpl5aVWxmtb6gicv325BjolURCCyGaF2NnKtEn26NfV2WAyi2O+xJ9raE05ttOV4CFfbYa0cYKBTK6M4/InCO3L6M4dZQjpynzhk8cvypveKW1VX0Y/7NVsulWzcHGR+xKk5D7UQjn9N0WdsA25SsTczQswrcZy5JxKbIOFnhoflKJQTxVguv16RGNf7IVhdUdz7Do0oSd7wt+5FJhta9yqbEYxpt0Ts5PmhtlQuH12bbm+3tP3VbTKq4XU7HgBnjTs1ZA+0fYxuwsisrSjGpcShGWBG+9lMjbKneOtoDhS54zwM3Ko+mWegkjnx88yil4/l5HX/1Km0kZ7GY1QtBZ8MxKm3ik/wL1e6w9NDCLgykEsuHf+IjPwZ/Tx97TuExXTOSpj9Dyo87vncde4Jjol9pjwxcwJa18D6pEZMbUN4zTN66vXkoYDYVqZaObuRhcvnPvsO4FvuCL+ZTtIEcGBwUcMj3xSi6LcwC/ErAeq/LKs4ZLDJ/r2fcO1L+W7Eykd6oGgy89RtnfXvnkm3+/PAyIQAZlQJj62ggisRD2mZWQNqitHX56SA22dEyh5DfP4Cl3lh2sw41ERYSR6Jp5sbSBvGFIzBkjtBBPQ08npxCzwoOjDjOEm30rptfU6873YzcQjhxxZ49a42j5RxXCwTuyj9cRb3jrnzIHj3Gp8rbJsZHQNgvyME6nbAAFZelkLi+ZKn4oZzVp5wwAKuAMwUA6o/0AF1cZ12k0ahORbXuNEzes0g34AIctEzPduVs16SyjSyuIsHxNCS8W8KL88AMNWCvQ0F84pLqGjgQw0cVIg5CZFknX9TdZ24Daf5ytUzvE6yDmav5b6Vs2hLaxOJYYpzEi+qa9hYAROqaQmMs0nRBHW3o
 vQz6y17w
 Lwgqu20qCUIOMxcCpULLF0Oni709XSmkoNAE5qIo5QP21V8u0q38idiJ9NzE+CmVGlKyLL9sd2QVM6eTe6Ml0CWc7eRnQ2t3TtY8kR0siG9H4XkImrS8jZo615eTloqwe6jE0QXMck45KTfwytHEr2JGKehYZnxaC0cI8nxjDSK8GktqMeG5pbfQnjliEztCo/wqo3P9j23fZ3R7fcVbU1jXqSb0+c46jEnPCne3PV1DntnC3Cx8omnHqcU0ABHMrTbapmYrI4gQx6nrXlw0gH21c8GEJ+0vmhavFGqrucfb7TqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/26 at 01:34pm, Christoph Hellwig wrote:
> Provide a wrapper for the shmem abuses in drm to preparare for swap I/O
                                                   ~~~~~ prepare, typo
> refactoring by keepin swap_iocb handling entirely contained in mm/.
                 ~~~~~ keeping, typo
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 2 +-
>  drivers/gpu/drm/ttm/ttm_backup.c          | 2 +-
>  include/linux/shmem_fs.h                  | 5 +----
>  mm/shmem.c                                | 7 ++++++-
>  mm/swap.h                                 | 4 ++++
>  5 files changed, 13 insertions(+), 7 deletions(-)

Other then typos, LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> index 06543ae60706..ef9440166295 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -325,7 +325,7 @@ void __shmem_writeback(size_t size, struct address_space *mapping)
>  		if (folio_mapped(folio))
>  			folio_redirty_for_writepage(&wbc, folio);
>  		else
> -			error = shmem_writeout(folio, NULL, NULL);
> +			error = shmem_write_folio(folio);
>  	}
>  }
>  
> diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
> index 81df4cb5606b..c5b813a563e7 100644
> --- a/drivers/gpu/drm/ttm/ttm_backup.c
> +++ b/drivers/gpu/drm/ttm/ttm_backup.c
> @@ -117,7 +117,7 @@ ttm_backup_backup_page(struct file *backup, struct page *page,
>  	if (writeback && !folio_mapped(to_folio) &&
>  	    folio_clear_dirty_for_io(to_folio)) {
>  		folio_set_reclaim(to_folio);
> -		ret = shmem_writeout(to_folio, NULL, NULL);
> +		ret = shmem_write_folio(to_folio);
>  		if (!folio_test_writeback(to_folio))
>  			folio_clear_reclaim(to_folio);
>  		/*
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index acb8dd961b45..f35c752f27af 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -12,8 +12,6 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/bits.h>
>  
> -struct swap_iocb;
> -
>  /* inode in-kernel data */
>  
>  #ifdef CONFIG_TMPFS_QUOTA
> @@ -122,8 +120,7 @@ static inline bool shmem_mapping(const struct address_space *mapping)
>  void shmem_unlock_mapping(struct address_space *mapping);
>  struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
>  					pgoff_t index, gfp_t gfp_mask);
> -int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> -		struct list_head *folio_list);
> +int shmem_write_folio(struct folio *folio);
>  void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
>  int shmem_unuse(unsigned int type);
>  
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 56c23a7b15c7..d10735e49b25 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1738,7 +1738,12 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  	folio_mark_dirty(folio);
>  	return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
>  }
> -EXPORT_SYMBOL_GPL(shmem_writeout);
> +
> +int shmem_write_folio(struct folio *folio)
> +{
> +	return shmem_writeout(folio, NULL, NULL);
> +}
> +EXPORT_SYMBOL_GPL(shmem_write_folio);
>  
>  #if defined(CONFIG_NUMA) && defined(CONFIG_TMPFS)
>  static void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
> diff --git a/mm/swap.h b/mm/swap.h
> index 77d2d14eda42..4f86ef338a60 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -473,4 +473,8 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
>  }
>  
>  #endif /* CONFIG_SWAP */
> +
> +int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> +		struct list_head *folio_list);
> +
>  #endif /* _MM_SWAP_H */
> -- 
> 2.53.0
> 

