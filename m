Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F2AFC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 18:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043D76B0092; Tue,  8 Sep 2026 14:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33486B0095; Tue,  8 Sep 2026 14:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21E36B0096; Tue,  8 Sep 2026 14:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A83696B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:01:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B3C516072B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:01:34 +0000 (UTC)
X-FDA: 85191362508.13.36C5393
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1944216000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:01:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Va7qD+HD;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788890492;
	b=7gQXkDRxxCitcPYy7l0B4XH9g0u4XqPwWEGhsa5JbnoSAWVH5+2gQ0ErD2MyL3oRYjR2N5
	0pPHwf2W/3KL8l+bXWRTseI2MPMpNK6tzr8ZQnrFg8dQUKMFo+bVKAA0+rzp4yk9RUq4KZ
	sCICUNgsW4E2wb8e5X8pfjGXeOJly78=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Va7qD+HD;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788890492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQMndwLikicf9hMmUikVbvPjGR5uBr5nZgfo2OLpEtE=;
	b=JYhh0BiO8ovXFAyon9bn1yALOHdvrebZecNWASRtj+RYrnkJZJ4qoALFcMT4edVh7jlMFm
	5Zm3YFfeI95YcwFsBdhAg58XgtoKrPGjgWW2QaZBO1GvTEYVyN1yyLfsuVCfL889nPQjSH
	5FvfeZoYBPlCB9sQOxoj4iHFn4EQc0c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EQMndwLikicf9hMmUikVbvPjGR5uBr5nZgfo2OLpEtE=; b=Va7qD+HDw3S4h9aSPyQgnAlWnU
	N1idi8rRpV89fjRp3sDqjI9VStixM0V1+4mBocGHspRDoVGeIXfmU3Y/VwdfFm0MuqRSdUTsUuJe0
	buTdYA5WIPNZ4Or8P4nnZCWBV+UL1bYy6GNzeB+CK2ocU89druwaY3XSUaYa/RBF3M4DBiVyy6ACZ
	KQVemV0z3nmOqBkKuga0vVSO5WDCF5+GmCSr9WpU++vDRhCM7R7pThpe2uxKfqIir//U98OaXYpTo
	K3bhM9kKfYHIWUWu22Yfr5FaHdh2MVTdLYAE4I5DYkuBqOERsBalvGWSgCJODbQskviWhTpTXYofD
	xroXNtWw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x408L-00000009vMt-2T8F;
	Tue, 08 Sep 2026 18:01:26 +0000
Date: Tue, 8 Sep 2026 14:01:23 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] proc/task_mmu: remove unnecessary inlines in
 function definitions
Message-ID: <ow26rkswn72mwjcdo65sv5nahsnas3csgntapnavqiwtqhoosu@oswbvxqcglu5>
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907063918.3432401-3-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1944216000E
X-Stat-Signature: r3f5iq5npkdhndfrua5rmezmgroc8bxq
X-HE-Tag: 1788890491-687643
X-HE-Meta: U2FsdGVkX1+vnxxLst3uvRJcapvFKcYzckXA5PLrVlN+gTqEp8QgwrJd4wGnH7Fb58QwezQxhC67NR8IMi62r+Ww8doYiDsXp56eYwR7Svc6ZClThsKEq8wvQSLXfz7dM59GUwwVCXi97ZLYc5mpAk6UBb/74h5iyxl1nFp8sZE0cI3Ohkky1FmaLxrRSr9oddTRog7x5nmapaiLBGbFxNDGInlpnop9brJY046N/f/jxG/WnGiqEbQ0H5JPsBz0cwUp4r5ZBhV3kClDtNQ/le/iEd8YGcYUqf8Yqzz3fhm36kZIdLA+k8WX6u6UJRbhmHqogQxifqd1JonMk60zwF1r4odgsfSvsjA++yMVYq4sYk793KIceC1aoIUIR81xgLNlUryrmOVpUfgfEjPMkUHJIdAh0u6qbk7ItoieDYa4TGe11Q3rAavzv52STTo7os5/9qLbVMR6vXMBN/sFG3KM/wA3H7znMU7kiaYvzLttdXtNhiZETc69j56J+2lhvKax6R6l9ItitsDH7LEt9SFIbJq+V1uKjuvswUCLZXgOURR8CrNvHtm9BrwkEb69FN+kOKy3nIP1AJt6w1xccuZwsriocduc+MLck2/vB8ErBSo7eTQPS28GfkGZIHiUDNKBNUO6BOziON8AVsbNzYmpdBYmWtPw03O305U/yiIrDYybu/6Ot7YFbxbzRHMkd10HLFC/V5w6uyWE+IMKdjEkjzwsGHRH4eJOW2xn05ctXmCljYskHAoXaQOIhw1jonL72+jaSRR1HIxPwU9uJNA9i1wY/cmG2mraL7A9tX0cSWzHfq0xNxixmmWrNH7b4+hF6nOfAVBIDOLdFrFqrFDLu2j29hd6B8qKKkoYq38OSYCsZHp7nf0/v9GcdP8mzCYpMROKqBfi74Jjd4shH295JzU5FYcEac1TAC4jLqsndSPGxR3nDIQQmTftq8m2fKBk7Slucvoq7MC8eQR
 AXKJmOvx
 Ch2iLc6X4NfK/XOe27pr+KrY9mqIo9FtEjR2vXFWNug6NeUbmKl6hnALAe2wG8wjvEGVZm7IulNJ5nGtvWmaIHbjziDH+5muUgUoQAHFflhQOujkExQm8XITrjVpUyf0LUCMYsfnUQP3HrVM/AsaAit6TlTSe3+NFJrrKFPqQ5vUs6GexOU1kSg6kormUbUEWiSOnvrrLm8II+WcnXQaCerUhEe/l9r1An/wYYqHOEK7kJjTAOMNpJBkpOcbqVA+bbbelfRR9osstpXs0miDOEeA+bNo+LyIOno2AfV8zqspo6/Gd4sgf4JTGaAmZesMk3OxvlVU2xwT0VJg9xbq6PcHPqdFcpqBhwkpfeRL73qZCDx0JUu29xeRsZ2exX3JBVtlQxpb58U2vb1P4w1T33drZ8PA6SKwoFyII
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/06 11:39PM, Suren Baghdasaryan wrote:
> It was pointed out in the previous reviews of this code that many
> functions are specified as inline, which is unnecessary as the compile
> can make that decision by itself. Cleanup these definitions.
> 
> No functional change intended.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

I'd rather two tabs for the multiple lines of arguments to a function,
but it's fine either way.

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>


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

