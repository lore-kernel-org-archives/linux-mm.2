Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B50EC5AD2B
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 00:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87BF26B0088; Fri,  7 Aug 2026 20:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C936B008A; Fri,  7 Aug 2026 20:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742516B008C; Fri,  7 Aug 2026 20:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3709D6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:06:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4356A1C00DF
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:06:16 +0000 (UTC)
X-FDA: 85076159952.29.87135E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8647A180008
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:06:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eFNshECb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786147574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZ/aN6vyToVGmXA3tTMVZFaIHBlNtndD+9kXmr/e+RM=;
	b=DHG+Kl7gK05BfTB5cz9HikkEMiuvZVjyNlcZGdhFSRpHR7GjYIEEnCDc+7jXS/5UjH8ASU
	c4FYf/YZ7c0QnAkXkoOjlp+Q2CHhFmayxSWiw63q9ZhcIGvS2IYx8eJc6TgZynVUnDsVV6
	olqT2+Kaz/jWG4oKvFqZtYzdx97ny2M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eFNshECb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786147574;
	b=zk7NSAPv0p/AK6hMHsskUfYtTZuNqxoaDOfOh4D0AB7wun7Fn5+aFVAnqUT3FBxd2ecWeO
	SChzowQqM10N9waLq3GR1iisGwqgzqSBmQZcnRXQMoDtounZF3sl/RuGMYWT3yRVdTHZO4
	d7ZvIC1h9jTl0CqEf0lJ6V8hdGbLtvE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C351F42B26;
	Sat,  8 Aug 2026 00:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5C61F000E9;
	Sat,  8 Aug 2026 00:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786147573;
	bh=mZ/aN6vyToVGmXA3tTMVZFaIHBlNtndD+9kXmr/e+RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eFNshECbw+T7lP66Z04G4RqDBG+psxCqC57GlGo9krp2sio9nwL4ZIqEM0add7ctD
	 TuEKoRQi1q4yj0wOSYTNBJ56nhyNUMb2cVHUdhORDPQ0aCJU0FqaUiB30vXc4OP3Nt
	 g1F4l/XRMW6K3AIJ55TWXnyCUn8f7zgGDo+3TsfsZT8yDCc444EKDXLdC/GWmsDbwx
	 S8V/t+eptcXKaWeeXjrhOsVeJtXA0pWpCrSSohuZfVzWWo3g85OFwvs19FL/VHTUk6
	 nwz0dX3zv/t7f3zYrtb6jxAG5cAre0caSlfZHErJzofr0JZNIcMCIv37FhEoTar4cA
	 ioRNBk9yqYNqA==
Date: Sat, 8 Aug 2026 00:06:11 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 26/26] mm: add fast path for AS_NO_DIRECT_MAP
Message-ID: <anZvanGFM30TNnWc@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-26-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-26-6f5729aa9832@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8647A180008
X-Stat-Signature: j4b5117c3717wm5p6p87w8gmjk4cqnfy
X-Rspam-User: 
X-HE-Tag: 1786147574-538436
X-HE-Meta: U2FsdGVkX18weCy0uMQB776gpsDGbaw/3WoRowaUG+rRTlWcq5+Io9NMRKMkaZFV4h4i56z+9oY9BHRijmMzxugthXkS9oDornD/tuB+KRmDr38tT2BMP439JmmgRKhbfr4EO8NHYhluuAM5sSsvmTrzxzC/DL0aGX1rCKkhSyQPLe65RP5dICVDY6Gxqf/v5LV4ftHifiPmrdcWnNbvrp7Sa0CYyL1QTiSMavrBaNbJ3IxPyxBHHMBZM1qXdc7uLimAZs5V+LpycB3Seq4CpEif2e7FA/GEJLl1G5I7Ot5GnTzShaq/mu3O20dtKC6G2s9yk9W9SKH307JOFA9TpWSJSSeg5wREyylIX7gR31zNRMS85QnQI+WXNcyZ/v68wBqFfdP7Dhr/JkwE+k9/LLldaB9dzw6/O8AGrQ1a8/P2z9fRZQOwoVBiOt3/Z2alJP4EJRLikYioqRC93vBADqCB7bUDMQC8+R2cdwznBqoy+J+C1KwISYoB54GsemhOo8ATJnh7dJC/MM61NyESRy+wC8dJaToaMzVCZz0l4ZlLyA3zhi4qGO8kW9i46Wv2xqUV9QNnkrmPWTniiRoK9QrYlwMGy0f02utEWBpg26HJggcJpQp4LdHa0xYoEBxPWSYldq4JtwQvrMsacOHqWuBIJzzhXiSnIunq1DeZYknegDHG98M+kmgL5A8m39jQpHRV9KUk9WmzjOgLQOVmj1BjTPGaDIQbSCibaraYkcBa1qrsAI0ZsyHkImQobAPN9h3Dw8pg25u3hE7eIFmXWYPk9gLN2gh86frZvoj/FREAXaOSGO45CSAT96mBBdXu+dL1G7GHrwrolEqegk+OItdbb60WkDgDYwRaUdmaaO1f6OUKWU9AxpBc98ZtPifel5mwjE8sUE8TNbR49haoxsQt8MVBek7XES40fgwMAjl9aAssbzBgmw8UMkIV6jFT6mWlCcIYrbRpqYnhpzz
 3liK3k4Q
 u1pzpi75dWCZ4s6zbt2vwv5dcMj+047n5eiK0g24+QKw1hocLOLIJk2XPpSRcoZ21nHX8t8TC3RTz9kv8uNIq2YuLoUG48kLFeScXN5tb7/gEgouIPRtZSKK3CRxo0VfvMZdFAelXdiy7MG5x818+LZKKnL/oURu9gO4JBteoGjiqwDTvSibmS08+VbIPRs77RxXstgm/OHmE7kvxb5dPwEmgdeR+Fj51ARKaaAMicfE1HJVlVNQTfkyxP7AMqqNgvx5Mwal+JMvQNaNF/Fqhk+kNGtwwlQiBbvu0irYfSSWlpWnfigbVVThereT52eBDnRL0wg7eYlRweKywIgXjbVMLb99qQIwWeIevlIGB4JRIUvaq93y4ZVjM6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -389,6 +387,26 @@ static inline bool vma_has_no_direct_map(const struct vm_area_struct *vma)
>  	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
>  }
>  
> +/*
> + * This is non-atomic.  Only to be used before the mapping is activated.
> + * Probably needs a barrier...
> + */
> +static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
> +{
> +	WARN_ON(mask & __GFP_ZERO && mapping_no_direct_map(m));
> +	m->gfp_mask = mask;
> +}
> +
> +static inline void mapping_set_mermap_stale(struct address_space *m)
> +{
> +	set_bit(AS_MERMAP_STALE, &m->flags);
> +}
> +
> +static inline bool mapping_grab_mermap_stale(struct address_space *m)

Should this just be mapping_mermap_stale() to be consistent with others?

> +{
> +	return test_and_clear_bit(AS_MERMAP_STALE, &m->flags);
> +}
> +
>  /*
>   * There are some parts of the kernel which assume that PMD entries
>   * are exactly HPAGE_PMD_ORDER.  Those should be fixed, but until then,
[..]
> diff --git a/mm/filemap.c b/mm/filemap.c
> index bf62fee570d8b..db66cd6466330 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -14,6 +14,7 @@
>  #include <linux/compiler.h>
>  #include <linux/dax.h>
>  #include <linux/fs.h>
> +#include <linux/mermap.h>
>  #include <linux/set_memory.h>
>  #include <linux/sched/signal.h>
>  #include <linux/uaccess.h>
> @@ -242,13 +243,56 @@ static void filemap_free_folio(const struct address_space *mapping,
>  	folio_put_refs(folio, folio_nr_pages(folio));
>  }
>  
> -#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
> +/* Fast version: pages are already unmapped, but need zeroing. */
> +#if defined(CONFIG_MERMAP)

Should this also check CONFIG_PAGE_ALLOC_UNMAPPED? IIUC, CONFIG_MERMAP
can be set without CONFIG_PAGE_ALLOC_UNMAPPED, but if
CONFIG_PAGE_ALLOC_UNMAPPED is not set then we are not actually
allocating unmapped pages to begin with and we need to zap them
explicitly?

I wonder if we should just make CONFIG_PAGE_ALLOC_UNMAPPED depend on
CONFIG_MERMAP since it's pretty much unusable without it, then we can
avoid checking both configs in multiple places.

> +static inline int prep_add_unmapped_folio(struct address_space *mapping,
> +					  struct folio *folio)
> +{
> +	int err;
> +
> +	if (!mapping_no_direct_map(mapping))
> +		return 0;
> +
> +	err = mermap_mm_prepare(current->mm);
> +	if (err)
> +		return err;
> +
> +	mermap_clear_folio(folio);
> +	mapping_set_mermap_stale(mapping);
> +	return 0;
> +}
> +
> +static inline void prep_remove_unmapped_folio(struct address_space *mapping,
> +					      struct folio *folio_ignored)
> +{
> +	if (!mapping_no_direct_map(mapping))
> +		return;
> +
> +	/* Folio is not going back in the direct map so no need to zero it here. */
> +
> +	mapping_check_flush_mermap(mapping);
> +}
> +
> +static inline void prep_remove_unmapped_batch(struct address_space *mapping,
> +					      struct folio_batch *fbatch)
> +{
> +	prep_remove_unmapped_folio(mapping, NULL);
> +}
> +/* Slow version: zap and flush direct map on-demand. */
> +#elif defined(CONFIG_ARCH_HAS_SET_DIRECT_MAP)
>  static inline int prep_add_unmapped_folio(struct address_space *mapping,
>  					  struct folio *folio)
>  {
>  	if (!mapping_no_direct_map(mapping))
>  		return 0;
>  
> +	/*
> +	 * Note under this configuration, we could have just allocated with
> +	 * __GFP_ZERO. But for consistency with the ALLOC_UNMAPPED version it's
> +	 * forbidden, so zero manually.
> +	 */
> +	folio_zero_segment(folio, 0, folio_size(folio));

Does the zeroing here (and below) belong in patch 3 when we stop zeroing
folios in secretmem_fault()?

> +
>  	return folio_zap_direct_map(folio);
>  }
>  
> @@ -259,6 +303,7 @@ static inline void prep_remove_unmapped_folio(struct address_space *mapping,
>  		return;
>  
>  	folio_restore_direct_map(folio);
> +	folio_zero_segment(folio, 0, folio_size(folio));
>  }
>  
>  static inline void prep_remove_unmapped_batch(struct address_space *mapping,
> @@ -267,26 +312,31 @@ static inline void prep_remove_unmapped_batch(struct address_space *mapping,
>  	if (!mapping_no_direct_map(mapping))
>  		return;
>  
> -	for (int i = 0; i < folio_batch_count(fbatch); i++)
> -		folio_restore_direct_map(fbatch->folios[i]);
> +	for (int i = 0; i < folio_batch_count(fbatch); i++) {
> +		struct folio *folio = fbatch->folios[i];
> +
> +		folio_restore_direct_map(folio);
> +		folio_zero_segment(folio, 0, folio_size(folio));
> +	}
>  }
> +/* AS_NO_DIRECT_MAP unsupported. */
>  #else
>  static inline int prep_add_unmapped_folio(struct address_space *mapping, struct folio *folio)
>  {
> -	VM_WARN_ON(mapping_no_direct_map(mapping));
> +	VM_WARN_ON(!IS_ENABLED(CONFIG_PAGE_ALLOC_UNMAPPED) && mapping_no_direct_map(mapping));

Why do we only WARN if CONFIG_PAGE_ALLOC_UNMAPPED is disabled? IIUC,
mapping_no_direct_map() should never be true if
!CONFIG_ARCH_HAS_SET_DIRECT_MAP, regardless of
CONFIG_PAGE_ALLOC_UNMAPPED.

>  	return 0;
>  }
>  
>  static inline void prep_remove_unmapped_folio(struct address_space *mapping,
>  					      struct folio *folio)
>  {
> -	VM_WARN_ON(mapping_no_direct_map(mapping));
> +	VM_WARN_ON(!IS_ENABLED(CONFIG_PAGE_ALLOC_UNMAPPED) && mapping_no_direct_map(mapping));
>  }
>  
>  static inline void prep_remove_unmapped_batch(struct address_space *mapping,
>  					      struct folio_batch *fbatch)
>  {
> -	VM_WARN_ON(mapping_no_direct_map(mapping));
> +	VM_WARN_ON(!IS_ENABLED(CONFIG_PAGE_ALLOC_UNMAPPED) && mapping_no_direct_map(mapping));
>  }
>  #endif
>  
> @@ -1055,31 +1105,53 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
>  EXPORT_SYMBOL_GPL(filemap_add_folio);
>  
>  #ifdef CONFIG_NUMA
> -struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
> -		struct mempolicy *policy)
> +static inline
> +struct folio *__filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
> +		struct mempolicy *policy, unsigned int alloc_flags)
>  {
>  	int n;
>  	struct folio *folio;
>  
>  	if (policy)
> -		return folio_alloc_mpol_noprof(gfp, order, policy,
> -				NO_INTERLEAVE_INDEX, numa_node_id());
> +		return __folio_alloc_mpol_noprof(gfp, order, policy,
> +				NO_INTERLEAVE_INDEX, numa_node_id(), alloc_flags);
>  
>  	if (cpuset_do_page_mem_spread()) {
>  		unsigned int cpuset_mems_cookie;
>  		do {
>  			cpuset_mems_cookie = read_mems_allowed_begin();
>  			n = cpuset_mem_spread_node();
> -			folio = folio_alloc_node_noprof(gfp, order, n);
> +			folio = __folio_alloc_node_noprof(gfp, order, n, alloc_flags);
>  		} while (!folio && read_mems_allowed_retry(cpuset_mems_cookie));
>  
>  		return folio;
>  	}
> -	return folio_alloc_noprof(gfp, order);
> +
> +	if ((gfp & __GFP_THISNODE))
> +		return __folio_alloc_noprof(gfp, order, numa_node_id(), NULL, alloc_flags);
> +
> +	return __folio_alloc_mpol_noprof(gfp, order, get_task_policy(current),
> +			NO_INTERLEAVE_INDEX, numa_node_id(), alloc_flags);
> +}

Does this plumping belong in the previous patch?

> +
> +struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
> +		struct mempolicy *policy)
> +{
> +	return __filemap_alloc_folio_noprof(gfp, order, policy, ALLOC_DEFAULT);
>  }
>  EXPORT_SYMBOL(filemap_alloc_folio_noprof);
> +#else
> +static inline
> +struct folio *__filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
> +		struct mempolicy *policy, unsigned int alloc_flags)
> +{
> +	return __folio_alloc_noprof(gfp, order, numa_node_id(), NULL, alloc_flags);
> +}
>  #endif
>  
> +#define __filemap_alloc_folio(...)				\
> +	alloc_hooks(__filemap_alloc_folio_noprof(__VA_ARGS__))
> +
>  /*
>   * filemap_invalidate_lock_two - lock invalidate_lock for two mappings
>   *
> @@ -1986,6 +2058,15 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
>  	return folio;
>  }
>  
> +static inline unsigned int mapping_alloc_flags(struct address_space *mapping)
> +{
> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> +	if (IS_ENABLED(CONFIG_MERMAP) && mapping_no_direct_map(mapping))
> +		return ALLOC_UNMAPPED;
> +#endif
> +	return ALLOC_DEFAULT;
> +}
> +
>  /**
>   * __filemap_get_folio_mpol - Find and get a reference to a folio.
>   * @mapping: The address_space to search.
> @@ -2074,7 +2155,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  			err = -ENOMEM;
>  			if (order > min_order)
>  				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
> -			folio = filemap_alloc_folio(alloc_gfp, order, policy);
> +			folio = __filemap_alloc_folio(alloc_gfp, order, policy,
> +						mapping_alloc_flags(mapping));

Why only this callsite? I see a couple of other calls to
filemap_alloc_folio(). Shouldn't they also use mapping_alloc_flags()?

Or perhaps better, maybe drop __filemap_alloc_folio() and just make
filemap_alloc_folio() always use mapping_alloc_flags()?

>  			if (!folio)
>  				continue;
>  
> diff --git a/mm/internal.h b/mm/internal.h
> index 089c53bf9a336..eea26ee57f765 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -255,6 +255,43 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
>  	return err;
>  }
>  
> +#ifdef CONFIG_MERMAP
> +static inline void mapping_check_flush_mermap(struct address_space *mapping)
> +{
> +	/*
> +	 * Note this flush is hugely over-aggressive: only the mermap region
> +	 * needs flushing, but assume that flushing the whole address space is
> +	 * faster. Also only certain mm's (most of the time, just current->mm)
> +	 * actually have stale entries, but assume the benefit of tracking that
> +	 * would be minimal.
> +	 *
> +	 * Probably more important: the TLB has likely already been flushed
> +	 * anyway for unrelated reasons since the mermap got used. If/when this
> +	 * is shown to matter, the simplistic address space flag will need to be
> +	 * replaced with something more deeply integrated into other TLB
> +	 * flushing logic to enable proper amortisation.
> +	 */
> +	if (mapping_grab_mermap_stale(mapping))
> +		flush_tlb_all();

As mentioned earlier, I think this should be a mermap provided API so
that we can implement optimizations and the caller doesn't have to think
about choosing the correct function.

Perhaps we can do this in a followup when we do have suhc optimizations.

> +}
> +
> +/*
> + * VMA is being closed, i.e. mm might be losing logical access to the contents.
> + * For AS_NO_DIRECT_MAP, the folios were mermapped so stale TLB entries need to
> + * be removed to prevent CPU sidechannel leaks.
> + */
> +static inline void vma_check_flush_mermap(struct vm_area_struct *vma)
> +{
> +	if (!vma->vm_file || !vma->vm_file->f_mapping ||
> +	    !mapping_no_direct_map(vma->vm_file->f_mapping))
> +		return;
> +
> +	mapping_check_flush_mermap(vma->vm_file->f_mapping);
> +}
> +#else
> +static inline void vma_check_flush_mermap(struct vm_area_struct *vma) { }
> +#endif
> +
>  /*
>   * If the VMA has a close hook then close it, and since closing it might leave
>   * it in an inconsistent state which makes the use of any hooks suspect, clear
> @@ -262,6 +299,8 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
>   */
>  static inline void vma_close(struct vm_area_struct *vma)
>  {
> +	vma_check_flush_mermap(vma);
> +

I suppose we also want to flush any stale mermap mappings on file close
as you mentioned previously. Perhaps it's not needed for secretmem if
the files are always accessed via mappings. But it can easily be missed
later?

>  	if (vma->vm_ops && vma->vm_ops->close) {
>  		vma->vm_ops->close(vma);
>  
> diff --git a/mm/mermap.c b/mm/mermap.c
> index 2bead38eadfe8..2ac1d59c1b1cd 100644
> --- a/mm/mermap.c
> +++ b/mm/mermap.c
> @@ -336,3 +336,40 @@ void mermap_mm_teardown(struct mm_struct *mm)
>  
>  	free_percpu(mm->mermap.cpu);
>  }
> +
> +/*
> + * Zero a folio via the mermap.
> + *
> + * This should be decoupled from the mermap implementation; it could be moved
> + * outside mermap.c if a better place arises to put it.
> + */
> +void mermap_clear_folio(struct folio *folio)
> +{
> +	unsigned int numpages = folio_nr_pages(folio);
> +	struct page *page = folio_page(folio, 0);
> +	void *mermap;
> +
> +	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHMEM));

Why? Is it because we are not using the highpage clearing functions?

Realistically, can we just make MERMAP depend on 64-bit?

> +
> +	/* Fast path: single mapping (may fail under preemption). */
> +	scoped_guard(migrate) {
> +		mermap = mermap_get(page, numpages << PAGE_SHIFT, PAGE_KERNEL_NOGLOBAL);
> +		if (mermap) {
> +			void *buf = kasan_reset_tag(mermap_addr(mermap));
> +
> +			for (int i = 0; i < numpages; i++)
> +				clear_page(buf + (i << PAGE_SHIFT));
> +			mermap_put(mermap);
> +			return;
> +		}
> +	}
> +
> +	/* Slow path, map each page individually (always succeeds). */
> +	for (int i = 0; i < numpages; i++) {
> +		scoped_guard(preempt) {
> +			mermap = mermap_get_reserved(page + i, PAGE_KERNEL_NOGLOBAL);
> +			clear_page(kasan_reset_tag(mermap_addr(mermap)));
> +			mermap_put(mermap);
> +		}
> +	}
> +}
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f39b6af3a6b73..4f923a7a18459 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5902,6 +5902,12 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
>  	return page_rmappable_folio(page);
>  }
>  
> +struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid,
> +					unsigned int alloc_flags)
> +{
> +	return __folio_alloc_noprof(gfp, order, nid, NULL, alloc_flags);
> +}
> +
>  struct folio *folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
>  {
>  	return __folio_alloc_noprof(gfp, order, nid, NULL, ALLOC_DEFAULT);
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index be83a974edc2b..c4bf3a83c68d5 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -282,6 +282,9 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
>  		nodemask_t *nodemask, unsigned int alloc_flags);
>  #define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
>  
> +struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid,
> +					unsigned int alloc_flags);
> +
>  extern void zone_pcp_reset(struct zone *zone);
>  extern void zone_pcp_disable(struct zone *zone);
>  extern void zone_pcp_enable(struct zone *zone);
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index c043c53687d95..798f1766bdc27 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -111,14 +111,8 @@ static int secretmem_migrate_folio(struct address_space *mapping,
>  	return -EBUSY;
>  }
>  
> -static void secretmem_free_folio(struct folio *folio)
> -{
> -	folio_zero_segment(folio, 0, folio_size(folio));
> -}

Is it okay to drop this?

With ALLOC_UNMAPPED, pages won't be zeroed when freed, but they will be
zeroed before they are mapped again into the direct map, or when they
are re-allocated as unmapped pages (e.g. for a different secretmem
file). So it seems like it's fine.

Being paranoid, I wonder if there could be a case where the folio is
re-allocated by a different user of unmapped pages that doesn't zero the
allocated folios, but there isn't such a user as of now.

> -
>  static const struct address_space_operations secretmem_aops = {
>  	.dirty_folio	= noop_dirty_folio,
> -	.free_folio	= secretmem_free_folio,
>  	.migrate_folio	= secretmem_migrate_folio,
>  };
>  
> 
> -- 
> 2.54.0
> 

