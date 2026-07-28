Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72270C54F4D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B93E6B0088; Tue, 28 Jul 2026 10:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669906B008A; Tue, 28 Jul 2026 10:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5586E6B0096; Tue, 28 Jul 2026 10:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 229696B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:41:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B15CA1203DF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:41:09 +0000 (UTC)
X-FDA: 85038447858.23.B2E070D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 01BA8120008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:41:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8MWqqRU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785249668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KrTDtoyloyskkVI+2oRhY9vSvJbipl/205X3rPHxag=;
	b=kWhmxXoKpLgghAcJZaA6VAY1HIMFCV91fnkITE9sjcUJilUPaU6KtXOs5voONBLzzEQTLg
	drk/fzlAV2zHPLqoDeivBYL5sQvnQJcUDE9/HxHX/LhuT4iBPE0eaM6X5flV5BxrqlN8dJ
	VvRqzrJAFtaPNWEVO74Z+5XHOI7z2s4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8MWqqRU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785249668;
	b=i3+ewdL1hVUyjs69B1IlHi40MTO0ZOA1tLRCJUFDY+XmROA7fKisw05Mv5/T7BzzwIaBDP
	UAgQ/TYcfrQX14jWlLvJxcCKm7LGLMPt27nfd6bQVdpioSO+bByXN3S0+QhI22OoV8AdO5
	aGezqgixWAu1k41TPw8UagIrQENDrm8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D4E943EB1;
	Tue, 28 Jul 2026 14:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A9E1F000E9;
	Tue, 28 Jul 2026 14:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785249667;
	bh=8KrTDtoyloyskkVI+2oRhY9vSvJbipl/205X3rPHxag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W8MWqqRUHTYNMV8Js/mBgaRMVlls7u73CPL69WbPgLX2kv7TFvDIFL8rBh29XQEs2
	 NpKLqtj2BHE1Pw/BLQuSbK1YLR2bTQfmrqxJCVtfLQ3QlhQLIjHvzscRhOblln+OSQ
	 yiWeOTv4bIaeU9wgUEryjeyjeO2HVTLwxc4QuWmvtqJ1QWrWjEMNsV1XuJIuq2OmOW
	 0JxUjzBydkonKmfiAeV4RwFoe2Q7JMkEIr4sB6Olz1HKp0Zn/ivK0niPAwxt0jTTOx
	 0caV/Q0fSjmgsdR5U7HzDtKm7ww4YavkrWb3Hhd6d1aOMu4iEu4ubDMTk/j+MxF5dN
	 PFnMxKEF4tuqQ==
Date: Tue, 28 Jul 2026 15:40:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, Dave Airlie <airlied@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/3] mm/huge_memory: add folio_split_driver_managed()
Message-ID: <amiyPLdgHGK25X48@lucifer>
References: <20260722044220.1110278-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722044220.1110278-1-matthew.brost@intel.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01BA8120008
X-Rspam-User: 
X-Stat-Signature: ca8kdpy8wm6a38db4c14jmsebh4hd7de
X-HE-Tag: 1785249667-486862
X-HE-Meta: U2FsdGVkX1/pPQw7kqFvKOZRp5ikQSyHCJZlGF4dp6xz20KjalHDVl1Ps26zdy6HbJ+AvjsGhNOV061JGFGiA+lG2GRiiQWVVPp+m8kVM2w0Y5TurM17m1FCVxkVNvYeVradHwZ93wCjxKoBidyjAObtHo4WjKXU4LuP8WlPMl7ZsWsqoUo6q2d0Lih3iffhhSwlCy7p1kKo0KEDXpuxwes00Bu4RHg8KM0tFkGv8dY9BdlcBD0ZwkBv1XsIHPR5Wq/e+NvLIRFP0jZKZFijLxi6LJeaTkojdRI057FXOdwKq9CXj9hNQ0yUsc5HZlsUInKmJgbFvUjglCeUTR0mxRmI4jV1qPZubHHmFQtE5i9neQvesCM6iN4gkk60em2k6AI2FOKQ8lzWZ3IT95N5zOCjbt+t22bNNva+3QLoJROXBl7XQ+9RXsW/mAlRatVG6963Ym4R4dxlyFg75KyqteZ9AcblCuzrMLSq6l1+rp0Mzb/DJ6imX4Q8SQ6Fd52O6pirSspEutD3VTS3B6Op4xrgPGgiyJz9wE/CtnDe/kjFfrOfJZAs369RIL2B6BeHPkuEM2OjbLTTadHzwmBNAkYwCZnsP75mtmTK+xZFk7ayL2pQY9U+hblUKl456c6h3hIfhVl6TddmUTLoZfLsUcN/UCJobjXHuhBKFjauUO/Rxb5cuceT4hOzQGigstxzMZbP+m86Q19BZcF4uHvCBbTTuMqYtZK+YegKz8cloHlXiknnhcCs4J+hvh1lycISrtj17tZgL75RatFjY/zFiiEWyXmQzUJo1b3zFjG/tpI3lUiBsKuZXea2GZnhJezxTqGnWwt7jxNhWzC2oe8UBWNHTFJlYDnofSfAhJBtDkWPdy7VzsMa5THsrA7+OCXJxu6fUfCYQyRNm9dVU8yg0LeNkS+SavJyVO8noyUhGBkH1Lmh0QSPl6I5P15sHzKlWvv8vCzESl9K3HiJ7Y9
 WT2HVoAG
 6Xl6m06AqIaK4N2eQmCIMKVzfUquvpYs6mT9oBoBDtj5rfF9VanAkkmT4XFbpAT02gtkKxQ74aN+vDmV7kTqwdatXetSN6D3GwMbr1DZd7npacavZNWEOn2NIXlK9df63fY7StH8zpdByWS85XcqajDs7RfIXBVTNAGiQfU362eKYkiH8n+/fSpmXYy233j/P3GgemhByvZw/bicxOFlYae7JDAi9aunNLNS3unIirqyuRbHD9MW7bP385Q2zMqp+JZeQS1Zq35JSXIsRffGkMXBaJqwdSCgJIocHEJaIb526huOVGmCLi7DguyP6C7cjcrn7zGX7JORVTM4Z2sN2pf0GnycV+7oXi62M8HBWSMSMmG+vGD3geNXZSR5E4v6j57JW53s4MMFim6DIMlzVTAKNZ8EDl/nVSK8MR77xJ1S2Y9xG8CXNOQCW0Cx9ixPzTg9QtkvxcHE4OscmBKP44QSuDbeCatjx9J6CvqXXySA5wgE3PhtoJJrWB4JX27L+uzoPQ7EggOMmumqENgaGxVVfD3QffRe8aiUZV7TgvdV9AansvoschtT05dKSBt36Utj3WGl2FOtQC6b15MGpFnd9x4vAs6+ThrA0bJ7cUPOLPdhw6fVaOxUAvdlwfjOGODuBoX5IEIGYlhuQ4Gl5UQE+qu4lqfNkmwDQk1pC921KRP63+FU6wbeBaz1NGDCt4K1UJIjp/WjXhZBJZPN9GUA6hqXz/rEUMwcrp59a8juRf1sgaxmRo8Kgr+vZ5ic9rcmy8dhTHXqfyrTAL/XLWN0B/RuotYMlRjRE2YkEAqGoyNuAafHaeLNfQ8b3iWhzn4oG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I know different people have different approaches but PLEASE cc- everybody
on the whole series for context :)

You may annoy the odd few who want less mail > context but that's the best
way I think.

On Tue, Jul 21, 2026 at 09:42:18PM -0700, Matthew Brost wrote:
> Add a lightweight structural split primitive for large (compound) folios
> that a driver allocated with __GFP_COMP and manages entirely by itself,
> outside of the core mm's view.

I don't know why you are stuck on the driver thing here, 'compound page split'
(with a clarification it's not about folios) is clearer.

Maybe split_compound_page() :)

>
> The existing split paths - split_folio() and folio_split_unmapped() -
> are built for folios that the mm owns: they perform a refcount freeze,
> walk and remap the rmap, and take the anon_vma / i_mmap locks, and
> folio_split_unmapped() further assumes an anon, pagecache-style refcount
> model (nr_pages + 1). None of that applies to a folio that is:
>
>   - singly referenced (the caller holds the only reference),
>   - not mapped through the rmap (folio_mapped() == 0),
>   - not in the page cache or swap cache (folio->mapping == NULL),
>   - not on any LRU or the deferred-split list.
>
> For such a folio the split is purely structural: because nothing else in
> the kernel can reach it, there is no need to freeze the refcount or touch
> any mapping. folio_split_driver_managed() therefore performs only the
> compound and split-accounting teardown via __split_unmapped_folio() and
> then hands each resulting order-@new_order folio its own reference,
> mirroring split_page() for compound folios. The caller keeps the original
> reference on the first resulting folio and is responsible for freeing all
> of them individually.

Can we human-ify this wall of text please :) It's very dense.

Clarity and succinctness matter.

I see a wall of text like this (very common now in the LLM era) and I just
don't want to read it, honestly.

>
> The immediate user is TTM's GPU page pool, which allocates higher-order
> compound pages, maps them into userspace via VM_PFNMAP (never through the
> rmap), and needs to split them into order-0 folios under memory pressure
> so pages can be backed up to shmem and freed one at a time.

OK so a user of the large pfnmap stuff?

>
> A CONFIG_TRANSPARENT_HUGEPAGE=n stub is provided so callers can build
> without the split machinery; it warns and returns -EINVAL.

Can build without the split machinery but get a kernel warning? Huh?

>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Christian Koenig <christian.koenig@amd.com>
> Cc: Huang Rui <ray.huang@amd.com>
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Assisted-by: GitHub-Copilot:claude-opus-4.8

<an aside>

Both? :)

Hopefully Brauner's patch lands and you could just put 'LLM' here honestly.

And ideally something like:

Assisted-by: LLM # Made me breakfast and wrote 1/2 the code

Or whatever the contribution was after the # :P

>
> ---
>
> The patch is based on drm-tip rather than the core MM branches to
> facilitate Intel CI testing and initial review. It can be rebased onto
> the core MM branches in a subsequent revision.

This should have been sent as an RFC overall very clearly, but definitely
if you're going to play around with bases like that even more so.

I wouldn't imagine making a core change to DRM and basing it on an mm tree
:)

> ---
>  include/linux/huge_mm.h |  8 ++++++
>  mm/huge_memory.c        | 63 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 71 insertions(+)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index ad20f7f8c179..35661d82d54a 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -402,6 +402,7 @@ enum split_type {
>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>  		unsigned int new_order);
>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
> +int folio_split_driver_managed(struct folio *folio, unsigned int new_order);
>  unsigned int min_order_for_split(struct folio *folio);
>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
> @@ -656,6 +657,13 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
>  	return -EINVAL;
>  }
>
> +static inline int folio_split_driver_managed(struct folio *folio,
> +					     unsigned int new_order)
> +{
> +	VM_WARN_ON_ONCE_FOLIO(1, folio);
> +	return -EINVAL;

Going to fire a warning every call? You were saying that your own use case
involves !CONFIG_THP builds?

And since this is being touched by drivers, drop the VM_ on the warnings.

> +}
> +
>  static inline int folio_split(struct folio *folio, unsigned int new_order,
>  		struct page *page, struct list_head *list)
>  {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..06f9a5f35df8 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4185,6 +4185,69 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>  	return ret;
>  }
>
> +/**
> + * folio_split_driver_managed() - split an exclusively-owned, off-LRU folio
> + * @folio: folio to split. Must be a large (compound) folio that is owned
> + *         exclusively by the caller and is invisible to the core mm.

Yeah I find this 'invisible to core mm' aspect really sketchy.

In what way is this invisible to core mm? You mean !rmappable fundamentally
right?

But it's reference counted?

It's clearly not invisible to mm except in specific ways?

> + * @new_order: the order of the folios after the split.
> + *
> + * This is a lightweight structural split for folios that a driver allocated
> + * and manages itself (for example TTM's GPU page pool, which allocates

Again no, please no. Maybe 'non-mm owned' but not 'driver managed'...

> + * higher-order compound pages with __GFP_COMP and maps them into userspace
> + * via VM_PFNMAP rather than through the rmap). Such folios are:

We don't need this example in the comment thanks.

> + *
> + *   - singly referenced (the caller holds the only reference),

Again seems really super specific to your use case. We can't add a general
mm feature for drm alone.

> + *   - not mapped through the rmap (folio_mapcount() == 0),

The parens bit is pointless and you're writing here what's in the code.

> + *   - not in the page cache or swap cache (folio->mapping == NULL),

Err what? folio->mapping is literally the link to the rmap (anon or
file-backed).

Again the parens bit is useless.

> + *   - not on any LRU or the deferred-split list.

Thi sseems like a specific use case though? You're using PFN map presumably
because in this case you have pages whose refcount you don't want touched
by core mm but here you do want touched :)

I mean we need this to make sense for general classes of allocated memory.

> + *
> + * Because nothing else in the kernel can reach the folio, this helper does
> + * not perform the refcount freeze / remap / anon_vma & i_mmap locking dance
> + * that split_folio() and folio_split_unmapped() require. It performs only
> + * the compound and split-accounting teardown and then hands each resulting
> + * folio its own reference, mirroring split_page() for compound folios.
> + *
> + * The caller is responsible for freeing the resulting folios individually.

Overall this comment is a wall of LLM-ish dense text, please human-ify. Use
paragraphs, try to be succinct clear etc.

> + *
> + * Context: caller holds the only reference and excludes concurrent access.
> + * Does not sleep.
> + *
> + * Return: 0 on success, negative errno on failure.

Nitty but 'error on failure' suffices I thnk :)

> + */
> +int folio_split_driver_managed(struct folio *folio, unsigned int new_order)

split_compound_page() still my preference :)

> +{
> +	unsigned int old_order = folio_order(folio);
> +	unsigned int split_nr = 1U << new_order;
> +	unsigned int nr = 1U << old_order;

nitty but could be folio_nr_pages(folio). Not a big deal.

> +	unsigned int i;
> +
> +	if (new_order >= old_order)
> +		return -EINVAL;
> +
> +	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio) != 1, folio);

This is meant to be a general accessor, what if an owner of a folio happens
to set the refcount > 1? You'd probably rather just return an error no?

This one doesn't seem to be in the same class of 'programmatic error' as
the rest.

> +	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(folio->mapping, folio);
> +	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);

Firstly, I think you should bail if any of these are not true, rather than
just warning if CONFIG_DEBUG_VM and carrying on.

ESPECIALLY since drivers are involved.

Also some comments here would help! It's like too much above, not enough
here :)

And I think these should be actual warnings, drivers might not ever enable
CONFIG_DEBUG_VM, and in any case these VM_xxx() warnings are for internal
mm stuff, not stuff controllable from a caller who might do crazy things
(TM).

I think often for this kind of thing it makes sense to have a separate
'check_split_compound_folio_sane()' or something like that for this.

> +
> +	/*
> +	 * Structural + split-accounting teardown only. No mapping/xarray, no
> +	 * refcount freeze: the folio is frozen-by-ownership already.
> +	 */
> +	__split_unmapped_folio(folio, new_order, &folio->page, NULL, NULL,
> +			       SPLIT_TYPE_UNIFORM);

__split_unmapped_folio() -> __split_folio_to_order() ->

	for (i = new_nr_pages; i < nr_pages; i += new_nr_pages) {
		...
		clear_compound_head(new_head);
		if (new_order) {
			prep_compound_page(new_head, new_order);
			folio_set_large_rmappable(new_folio); <--- oops it's rmappable now
		}

So this is a problem.

Maybe you want to split to order-0 always? Otherwise this needs a real
rethink.

> +
> +	/*
> +	 * Give every resulting head folio its own reference. The original
> +	 * reference stays on the first one, exactly like split_page().

Again, split_compound_page() :)

I'm not sure this reference to split_page() is useful.

How about:

    /* Retain reference on first folio, set on new head folios. */

?

> +	 */
> +	for (i = split_nr; i < nr; i += split_nr)
> +		set_page_refcounted(folio_page(folio, i));

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(folio_split_driver_managed);

Presumably you absolutely require this for module-built DRM driver?

> +
>  /*
>   * This function splits a large folio into smaller folios of order @new_order.
>   * @page can point to any page of the large folio to split. The split operation
> --
> 2.34.

Cheers, Lorenzo

