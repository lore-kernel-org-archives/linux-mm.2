Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C62E8C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C797B6B008A; Thu, 10 Sep 2026 11:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52016B008C; Thu, 10 Sep 2026 11:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68FB6B0092; Thu, 10 Sep 2026 11:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90B466B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:55:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38703140580
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:55:10 +0000 (UTC)
X-FDA: 85198301580.27.0AFAD03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 882AA100003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:55:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVMAbNdo;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789055708;
	b=2tc5xGGUNO+kLRpmw3HS3wpnxeDOE3veUepVbL24/B6XJC2WJvtxOPwnbOjxDG2DPoWeDw
	Adxdg6d7Jj4PUynSXTTMppc3AtwgGqSm8FVnazN9hnwNWXRnG9B4srDqxr9heth7oXxnBj
	Y2LRWkdjUziCQVI3o9EfBRk8VX1dDXc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVMAbNdo;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789055708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCQuPsQnnzWEfQqM8qoVptc5zhfCzwmt8mzzfIKqMeM=;
	b=TLVrvF+ZO3lZC7dcH9aXotx1MWWY6qBBHzkcrhufqGPpLcMywOThyKH9jvaKCLWeHejq0d
	dv/uX/0pDAhaZ1pGVeQHPChRlsN/7IRrK0ek5Hi1xxcjNRpUcEfpYgm4Mjuhtxt8zWCxmx
	jun+tNwxSNi5M3PDHCWY64mDz6sp+JQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F44541811;
	Thu, 10 Sep 2026 15:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558CA1F000FF;
	Thu, 10 Sep 2026 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789055707;
	bh=cCQuPsQnnzWEfQqM8qoVptc5zhfCzwmt8mzzfIKqMeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PVMAbNdo6ndFhaKlzN77NDHXZPrv+vd6y4nx1+MGaOXxACAoPKUHPnKPwSXQoiqx0
	 DjDEtoTeXwD25745NTh8ThVCvdtTTWKe59/wWEbjV65Gnq2Yw/gXqDMzSV1IMHthOW
	 zes7KPkTEznMFZ0ws0G9RfdbSz8jQvgbmajCj7a+fyrf+iRqZtdm6unx+Sk4DwA8fw
	 6o5K9XRghRJN2yTWFCXZoD9ULIbIPFqUVPI5Go0yrYwXVpIIkBqM5WIcWrLRaBMeMA
	 yklWF0PiNyvBqyrCBOw78AXla6+tpTENhVJP6K2cg7Ft9ShY9PIVKzvT451D6wfsqN
	 NwY0Am3M80uDg==
Date: Thu, 10 Sep 2026 16:55:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] proc/task_mmu: remove unnecessary inlines in
 function definitions
Message-ID: <aqLSjyKYEiXyFehF@gremlin>
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907063918.3432401-3-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 882AA100003
X-Stat-Signature: cahcdegdi7sxudd86uapneakh7xa6ox7
X-HE-Tag: 1789055708-76981
X-HE-Meta: U2FsdGVkX19IRlI6TM+ShC0V9y7TPsOmtiSfPA4IcVtHTc9KIjxCxMvexbfrs4p/IGqdCUupHTtQPsLYPDdagGjsGyEO0T8qGFcYZTN9tpEosaJyQJV4+M/0U3PRWwBpDEB8XrR4llYAQzgIuLWL7PHvGuBiAkQZCNudfya9RD2padRe506Rszh1oPCGiRmEL2P9K5EdQjWOW0UGSFPgMg9sFiYdtE68OCQ1mk8usqA5SLSYNgNMnCRLiRpQ3cCXW7j5LZ+WF0E+a9ZBESYijp1g12WV111j+YeAsPMjXUnX37OroofEfEoyckLFuM+YwCsN/8JawX40HXS21SBQwlBVuh6+IprdDQG3iSFlR84nUp6Tyhh8Qv9yRoAvHGC6JkjL8dP0/jR6ZPwf9fqvNX0adPD8m/Jd0Zo0+wg8Yn/rdur4SH3Hq6Oo2jaYaL5rLIgOCdlnftz2UVP36CDFqIwW4qaC2f09tOUPxn+RL0wW5Sz9x3agLP/eYZjfgljyleVy/epX9FRhmRERbKUzg/eyW3hNtRAZrHpJzvhNKZrVSMhTzCmJ69Gc9r7GkWh+0akCkbS29JaAkGWuQrHQ5dNOo0V2zMSISYHQlK3hcZeBRptnCaVk2K+XTFpo68Tb8M0kpGGKCEZ41xkO2YTGHDD0MOu9wL8e9VCCh7b8rURJXRWNQ9UWnPejg+XgnycdYA20Av2N2ngM9CIiaQ2XA2f4XMtGk0RDcnL30/VCQyYzKAsrM50Q6PiEmDiX/p8t23rR118XCNZYFbvJ8rdyifGbPTpip7lS27GBqULETaEqfjlLps6Tr7aCuU6i/bAxJnTgPg0pnh7qunxgnDHam4p6P+EmMflTPr9KckVcPNoA3bkpbX2ytudK9GvZ9Tdu4MFsIvTQvb0i3E53iF29mYKMPrm1sZeWArEfpwr0CQsnla4lLtehbi6w9EmF9N3E/YPzNdpZ1uBU1Y8nfPH
 +TruBXLG
 jWq8O+/hs+ydXornC/16iSbxVXkOGoHotWaonfCltGsA0waiJVmayHtBSByyQsCp013g+0yKmgiMTqypa4BzFfuK2Dn4xqDItMM3QU/yxwlepQg+C0Lp4mDArd6vHNfaOOuNz4gMRF30Y6+Hhv02gzYnEuOfsHQnGBFNePWby8QdT20tiFqRm39+/jn+89C1mJySTqr3swNDsfanawCVxNBMleKH14EBgLa9QRmpKiR8EkCg0Gc/ykJZqD6rLgbzz3O3S1pqKYP8Afm7dwSk08xYovcg2RhmskeprsRPW9nmEGI2fAh7ufnPVrana8ftMRKDytgj49EekaKnjSiJfHwwX2SRnZevmowEN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 06, 2026 at 11:39:15PM -0700, Suren Baghdasaryan wrote:
> It was pointed out in the previous reviews of this code that many
> functions are specified as inline, which is unnecessary as the compile
> can make that decision by itself. Cleanup these definitions.
>
> No functional change intended.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Yes :) Nice, thanks!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 2f500d639db5..9908ba32f180 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -130,7 +130,7 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
>  }
>  #endif
>
> -static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> +static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	int ret = mmap_read_lock_killable(lock_ctx->mm);
>
> @@ -140,7 +140,7 @@ static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  	return ret;
>  }
>
> -static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> +static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	mmap_read_unlock(lock_ctx->mm);
>  	lock_ctx->mmap_locked = false;
> @@ -177,7 +177,7 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
>  	return vma;
>  }
>
> -static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> +static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
>  					 loff_t pos)
>  {
>  	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
> @@ -194,7 +194,7 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
>  	return true;
>  }
>
> -static inline void drop_rcu(struct proc_maps_private *priv)
> +static void drop_rcu(struct proc_maps_private *priv)
>  {
>  	if (priv->lock_ctx.mmap_locked)
>  		return;
> @@ -202,7 +202,7 @@ static inline void drop_rcu(struct proc_maps_private *priv)
>  	rcu_read_unlock();
>  }
>
> -static inline void reacquire_rcu(struct proc_maps_private *priv)
> +static void reacquire_rcu(struct proc_maps_private *priv)
>  {
>  	if (priv->lock_ctx.mmap_locked)
>  		return;
> @@ -1230,7 +1230,7 @@ static const struct mm_walk_ops smaps_shmem_walk_vma_lock_ops = {
>  	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
>  };
>
> -static inline const struct mm_walk_ops *
> +static const struct mm_walk_ops *
>  get_smaps_walk_ops(struct proc_maps_private *priv)
>  {
>  	if (priv->lock_ctx.mmap_locked)
> @@ -1238,7 +1238,7 @@ get_smaps_walk_ops(struct proc_maps_private *priv)
>  	return &smaps_walk_vma_lock_ops;
>  }
>
> -static inline const struct mm_walk_ops *
> +static const struct mm_walk_ops *
>  get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
>  {
>  	if (priv->lock_ctx.mmap_locked)
> @@ -1572,7 +1572,7 @@ struct clear_refs_private {
>  	enum clear_refs_types type;
>  };
>
> -static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
> +static bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
>  {
>  	struct folio *folio;
>
> @@ -1588,8 +1588,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
>  	return folio_maybe_dma_pinned(folio);
>  }
>
> -static inline void clear_soft_dirty(struct vm_area_struct *vma,
> -		unsigned long addr, pte_t *pte)
> +static void clear_soft_dirty(struct vm_area_struct *vma, unsigned long addr,
> +			     pte_t *pte)
>  {
>  	if (!pgtable_supports_soft_dirty())
>  		return;
> @@ -1620,8 +1620,8 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
>  }
>
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
> -static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> -		unsigned long addr, pmd_t *pmdp)
> +static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> +				 unsigned long addr, pmd_t *pmdp)
>  {
>  	pmd_t old, pmd = *pmdp;
>
> @@ -1646,8 +1646,8 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
>  	}
>  }
>  #else
> -static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> -		unsigned long addr, pmd_t *pmdp)
> +static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> +				 unsigned long addr, pmd_t *pmdp)
>  {
>  }
>  #endif
> @@ -1846,7 +1846,7 @@ struct pagemapread {
>
>  #define PM_END_OF_BUFFER    1
>
> -static inline pagemap_entry_t make_pme(u64 frame, u64 flags)
> +static pagemap_entry_t make_pme(u64 frame, u64 flags)
>  {
>  	return (pagemap_entry_t) { .pme = (frame & PM_PFRAME_MASK) | flags };
>  }
> @@ -3388,7 +3388,7 @@ static const struct mm_walk_ops show_numa_vma_lock_ops = {
>  	.walk_lock = PGWALK_VMA_RDLOCK_VERIFY,
>  };
>
> -static inline const struct mm_walk_ops *
> +static const struct mm_walk_ops *
>  get_show_numa_ops(struct proc_maps_private *priv)
>  {
>  	if (priv->lock_ctx.mmap_locked)
> --
> 2.55.0.979.g7e5102b832-goog
>

--
Cheers, Lorenzo

