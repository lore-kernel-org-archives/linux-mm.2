Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9EBDCD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7006B0005; Tue,  9 Jun 2026 04:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EBE6B0088; Tue,  9 Jun 2026 04:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB716B008A; Tue,  9 Jun 2026 04:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B97616B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:55:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EE3F1A04AC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:55:41 +0000 (UTC)
X-FDA: 84859766082.15.E0C9925
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf03.hostedemail.com (Postfix) with ESMTP id BDB0420003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:55:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780995340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2tjwDspJyqxIZbPzhNKnXOTDGxB8MR5yAiRSOB3fXk=;
	b=GPaKGxGdyLQZ25+uxprB9g+m0xl38MmcFBseyq69n0rZ6tlQZ5ZQNeY4q1OPzNjVCKpDaw
	GyliFLmC8Uw3AAG0KGqzhqCOaHPV83CNGQVkvqAnyWVE/XM11G1o8SvKPCg9iU5ZujCxmd
	8idYHIaRo8cNbw/Xx/dcngum7hGDyuE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780995340;
	b=aUBPjGS/N++voWDwCNsOVzvyLNjEA/DhL3e+tAiih2EpnuXta7++iQyKU/fALnMfA6TLkG
	hVFJ9cw3g75Ei/I/X21YCsppVej7llk281NP8yz7BSlKJuLh30obCpwdmThcnXMwvPt1P1
	rjIE5JIwRvrp0nzoGalOWunoZWkhZN0=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3E29468BEB; Tue,  9 Jun 2026 10:55:35 +0200 (CEST)
Date: Tue, 9 Jun 2026 10:55:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org, Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: better shmem writeback interface for drm, was: Re: [PATCH 1/8]
 shmem: provide a shmem_write_folio wrapper
Message-ID: <20260609085534.GA12980@lst.de>
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-2-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: BDB0420003
X-Rspam-User: 
X-Stat-Signature: m91jkqw1xc77fkdtg66ojodw9bgnd7w5
X-Rspamd-Server: rspam09
X-HE-Tag: 1780995339-353965
X-HE-Meta: U2FsdGVkX19mTcv/ajgDgOBtiyxk6SnPe5+rwOvof4NEuaX/Cg70ccpnmaj/O0cAg/E4d2sftjGtS/quTQwfblOvdX+clgqtcdJbnbz3FIT3KKfdJ/lU3ofrdsNO7XsqGXaXP8G0FDqAOaBhSUzCZGwPTOO/SQcRe7pdQt/dQrTtpi7xPGp1YRYhxnIoUYsyON78KynocbxCNh7DsSo1sXHSM2TgpglJRoV3er/rb0Dzpu6l0TnlZQ5iwCC19hxpB0kKPqcm2FcQWaO6JgbRPQamY4Bj1VL/B8RIniNKyzlmgbwH4AComfTFpXLJJB3gWWQilbg3Ik5l1XfuVdl4FDJoq1jh71/Ox7NKIRwacDIcRaYqYZygo5dmrGMDY669aY4eptD4ka37it8n60Tm5vZozANYU2/9KVMZh3sb1Vq12smJKI9FfV+F3elZQbpszyD45hUe+y/Z53mMl8Uek60Nvo2Ti4tr4kG+vt+DWrpt2ywG/n5G9bq1Rk7rkmBhAzLowWpDtSioqBk2VgOE9vlnf3fMtXGwtsnKfaMv6DfX2VYrJAHfWetXm0lUrtUeaXCPXl/eEjW895s8iXYSKiEKyt8qVn5sH9++eB3UbgtVUTXOjsBr1M03wUKhu8dwjCF1g5P71tidKNgxk0yhK9reONc74CajIZcwAVhgKeGdj8OFlM/w0ZeEFvgLLz1BxORMI9RjIs+Hhkqg0CvGykyaYoqeg/Pma8uqf+8djPH9M4kq8ml62H8I7Exemn2p+aLd+FjOYOjndfQtWD1XohOp0un9l96Br59cMLRQYIPEz3lVFbvH3VJpM+IOq9/7E594QZTn8u0DqLjXIPjpbaVdss0Fsn0S+c54SvBAvPvApZKzbRLgrNPTgrUN4Ejhv7onENFWZjTU2uTVONG4K2YVaacXe/DmoetoM5w3vBGcbL8T0f57DXOFqdyxkSjLvPwvuBV8/uo1D3HdCy8
 Qb0hR3vJ
 GN6KmO04Rj9cXdzBvIjfKTUSutoMQ79AHfYrVszZY9/s/uixsXxALN1z1bfjH6YyDoX9fk+cBdZthYq7M4sV5WA+dXQG15X9jYkD9Ciq3rG6Yap7h6BVDVn0lMsGjxSn2GCYyBeRjoy08F2C4TLRkaVKbO1GS97CLyiUahUw7QSABo+ehZvqGl0dPoIvV4TtzN3vgE62aedKodGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko complains about a lot of pre-existing issues in i915/ttm here:

https://sashiko.dev/#/patchset/20260601113449.3464734-1-hch%40lst.de

This might be a good time to fix these, and as part of it provide
saner interfaces for drm.  The i915 case look like a plain writeback
range, which looks somewhat easy.  I don't really get what the ttm
code is trying to do.

Any takers to get drm out of messing with these lowlevel shmemfs
internals?

On Mon, Jun 01, 2026 at 01:34:27PM +0200, Christoph Hellwig wrote:
> Provide a wrapper for the shmem abuses in drm to preparare for swap I/O
> refactoring by keepin swap_iocb handling entirely contained in mm/.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 2 +-
>  drivers/gpu/drm/ttm/ttm_backup.c          | 2 +-
>  include/linux/shmem_fs.h                  | 5 +----
>  mm/shmem.c                                | 7 ++++++-
>  mm/swap.h                                 | 4 ++++
>  5 files changed, 13 insertions(+), 7 deletions(-)
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
---end quoted text---

