Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF546C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B41A6B0088; Tue, 28 Jul 2026 11:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88AAB6B0095; Tue, 28 Jul 2026 11:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1166B009B; Tue, 28 Jul 2026 11:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDE36B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:42:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7896160444
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:42:17 +0000 (UTC)
X-FDA: 85038601914.11.BFC7B42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1FFB916000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:42:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hkk5d7pN;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785253336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cn9uuCu4petLDLZf1KwAZ2CPZvy55bypKnCMo9F9MKg=;
	b=4X1ZLau67NWBWuaCPP4AfCkaPSk9nLulZyeGerAh3B+xqqfRoL7hQgGGe3mY6H87ObQZ0B
	KwZqlKU57a8bFzizwu7xLfsaBI2Xyw2/ciYCIi7rXYCiiEECbnRNxqHKdcuIAXcxjBbqy7
	zOzg94qVX7bZNmA+j5Z6gtT6+RY+ZXA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785253336;
	b=02YlfDRSu6D3ZVToh3WzN3NfDxJyibX9Qv70NHqByV+DK5sbz/obHUxZFqlUYHbCS2PiKz
	lXPmtdeJT04owPannTr3UXP2lu22ZFc5iuTf9cDykEzlBqVJ8G3EbKTKhbCwHMURjHKofK
	VKrneYmPaxPSQk/FSa90gDMPxr0VpmI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hkk5d7pN;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E4466001A;
	Tue, 28 Jul 2026 15:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EB01F000E9;
	Tue, 28 Jul 2026 15:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785253335;
	bh=Cn9uuCu4petLDLZf1KwAZ2CPZvy55bypKnCMo9F9MKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hkk5d7pN/gnfZxZufQsrgEvXOwGoimyv1SzUPkDfmdUX26sYH6/DQ/mN+5P0HlkeX
	 tOIOPRy3Do+8x+vQm8v1HMz10TAXOPdbzB6NpS8GmnvmJqGWzBpBtZ2DZefeQGt9ge
	 +XBuURtLarQzfpzvFMjq5ELicbcvIMIwByC9yifSTw0EYPR6Jh68eQEEJjWX6pMpsl
	 MaqObdhhyXkv8zZoFr2B9l9ZAVpCZje0DQjVor7vkp+DLCKDP8fOv4IoBSzOIYbXAQ
	 XXC10noKxpZyWEoHhoeflHrnDCRW0hm3YgmivKj/BOG9kfQl7kG1HAPnWO3SviqvIj
	 HDUHaryZm53Bw==
Date: Tue, 28 Jul 2026 16:41:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, 
	Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, Yang Shi <shy828301@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hengbin Zhang <uqbarz@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes 1/2] mm/huge_memory: separate out
 CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic
Message-ID: <amjJM1Flp7bDN0NO@lucifer>
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
 <20260728-fix-refcounted-huge-zero-v1-1-3f261f5447b4@kernel.org>
 <amjD1MtOiXBRDxVi@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amjD1MtOiXBRDxVi@thinkstation>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1FFB916000B
X-Stat-Signature: jm4gdwdfhrygjuc4tsxnaws8je7bqfqo
X-Rspam-User: 
X-HE-Tag: 1785253336-936828
X-HE-Meta: U2FsdGVkX19ylUJAXDYD26VJ70Up6Z50d/NkbnuiJB0wVSg6Uvs+C3hsN27jZ2lYxFqJIOP/tsMP0EMDug639YMcne4Cjh2AapcfGqG61fze6liWBfxA5X4kSdcnkAD5bTuVOxvC73OtS8pHn2MiRrXfQ76JitOMWPGQT8fBq42waj55OpZbyC+gZvDmv7tixnM6zNwUg3Vgd52IIwMP3+Ka7v4F4FwaIdSTvsI8ReEE4mnrsa4A0/j4wOZqOWWcKkSjfx92tdhy9Szfl2lf19jLQYmXpY897WRSWU/t9C8vmjgGWdzO3j8zV4zWxD0tUfmk265wjNVE6mSGDHamg3ZwCUtZGPtWdCBJiXjIId0ZcvDWDYiRGk7+sYxML4clidlFJyqBpMMRm8DaiKJviF49BVcKYay05kuzAWRH18NzNgVeBd0sokBaHEmO50I09c2UvLhlcMFBlSr1EVoWxMnbvycxsM1jfrYHUNQTaWAqqk1ilBnmz8ierFpe53LG800DebE8cCix7eBf6fXT7Q2MxiGQThy0E+g+aUcVgZzGLGniIOSKMcCaW+WOIh5R7uDp0zUrX9J9caGfOJorvfxQqOD/4qFL9i5V9kuDRsuOpSHfBq/XxDg/dwIFogXV8Y4sSkpq80DkAvwcV6i8wxUFIPvmUfR5QU32wZnt4pBE3uXMvRpCnxMf5Zwr483fuyhR043Wg5SoIfYTKsZAYP5yA2Mu3CuOXQMF325rRwz/MrK+FjBhePK8ZQRo6to25FSiDAbF1wb0KuzHDkaqT/8xhI3eJbWteCKcjoq+nZMzbXVJcffulvOf3UUMwAYGqTh4BBeV+BSN33kPGq60n6IvN0AVXdqM3NO9Iz1jbp7cpgvQSCanJyzM9xw1H+390rb/CNh8zeVYF5d8c8DgjgORxscnqiY+fdQIaHjId1bAIy5HRbwF2TwhcKbetCiGYaj7LCxOaEWpX/EWEBN
 hv0T9WTT
 e2DZ1XZ1GWb6pCGp92kjEJTVCeEknE0E7fQyRbLVgEHe14BpehtEigLQroQFE1DLIKfX6g4V425tJllfubBqVniLtZq5DNGUebfQamMgfLI+BkLZqv16j/FX3WwgbJbBhvvKDxOMg+IHKIkJfna6eQY2EqtvBWj6pqUeI5+O5JEXf8ZhlYLfKK6O5S0j3sjoRXkGPVUCxniyUOMR7zM3Y+usKghnL+GlAEgl7+KSAxSUMsIjpy/HL3ndBOpGJ7yqlXWF+P1lRuaVE2rtlovJa611KEnZ4Ha3SEf/gRt6Db8U+pcwkT7PfRpSIwevkiZbzef5cITz2yWhQNpu5WnCXOyr4f+FHGnJNl6z2BoTvPzV1Ud4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 04:08:35PM +0100, Kiryl Shutsemau wrote:
> On Tue, Jul 28, 2026 at 01:05:44PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Rather than mixing the refcounted and non-refcounted
> > CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic, separate the two out cleanly
> > so it is clear what happens when this configuration option is set and what
> > happens when it is not.
> >
> > Introduce HUGE_ZERO_UNSET_PFN to abstract the ~0UL assignment, only
> > introduce the refcount and shrinker if !CONFIG_PERSISTENT_HUGE_ZERO_FOLIO,
> > abstract initialisation and teardown, abstract the huge zero folio
> > allocation from refcounting.
> >
> > Also change a BUG_ON() to WARN_ON_ONCE() while we're at it.
> >
> > Without this change, the subsequent fix for a subtle race is harder to
> > understand thus this is a dependency of it.
> >
> > Cc: stable@vger.kernel.org # 6.18.x: dependency of subsequent fix
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/huge_memory.c | 159 ++++++++++++++++++++++++++++++++-----------------------
> >  1 file changed, 94 insertions(+), 65 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 032702a4637b..0f60bc82e87a 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -77,9 +77,14 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> >  					 struct shrink_control *sc);
> >  static bool split_underused_thp = true;
> >
> > -static atomic_t huge_zero_refcount;
> > +#define HUGE_ZERO_UNSET_PFN (~0UL)
> >  struct folio *huge_zero_folio __read_mostly;
> > -unsigned long huge_zero_pfn __read_mostly = ~0UL;
> > +unsigned long huge_zero_pfn __read_mostly = HUGE_ZERO_UNSET_PFN;
> > +#ifndef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
> > +static atomic_t huge_zero_refcount;
> > +static struct shrinker *huge_zero_folio_shrinker;
> > +#endif
> > +
> >  unsigned long huge_anon_orders_always __read_mostly;
> >  unsigned long huge_anon_orders_madvise __read_mostly;
> >  unsigned long huge_anon_orders_inherit __read_mostly;
> > @@ -221,22 +226,58 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >  	return orders;
> >  }
> >
> > -static bool get_huge_zero_folio(void)
> > +static struct folio *alloc_huge_zero_folio(void)
> >  {
> >  	struct folio *zero_folio;
> > -retry:
> > -	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
> > -		return true;
> >
> >  	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
> >  				 ~__GFP_MOVABLE,
> >  			HPAGE_PMD_ORDER);
> >  	if (!zero_folio) {
> >  		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
> > -		return false;
> > +		return NULL;
> > +	}
> > +	folio_clear_large_rmappable(zero_folio); /* Explicitly not rmappable. */
> > +	return zero_folio;
> > +}
> > +
> > +#ifdef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
> > +static int __init huge_zero_init(void)
> > +{
> > +	huge_zero_folio = alloc_huge_zero_folio();
> > +	if (!huge_zero_folio) {
> > +		pr_warn("Allocating persistent huge zero folio failed\n");
>
> I am not sure the warn is enough. mm_get_huge_zero_folio() will produce
> NULL pointer now without any attempts to allocate again.

Well firstly this was existing behaviour :) and is to be backported also, so
anything changing that would need to be a separate change.

Secondly this failure really shouldn't happen in reality, it's very early in the
boot (see my RFC...) and the config has to set CONFIG_THP too.

And finally, more importantly perhaps, everywhere deals with it - anon read
fault in do_huge_pmd_anonymous_page() for e.g.

	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
			!mm_forbids_zeropage(vma->vm_mm) &&
			transparent_hugepage_use_zero_page()) {
		...
		zero_folio = mm_get_huge_zero_folio(vma->vm_mm); <- returns NULL
		if (unlikely(!zero_folio)) {
			pte_free(vma->vm_mm, pgtable);
			count_vm_event(THP_FAULT_FALLBACK);
			return VM_FAULT_FALLBACK;
		}
		...
	}

DAX:

static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
		const struct iomap_iter *iter, void **entry)
{
	...
	zero_folio = mm_get_huge_zero_folio(vmf->vma->vm_mm);

	if (unlikely(!zero_folio)) {
		trace_dax_pmd_load_hole_fallback(inode, vmf, zero_folio, *entry);
		return VM_FAULT_FALLBACK;
	}

	...
}

etc. etc.

Where:

struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
{
	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
		return huge_zero_folio; <-- returns NULL
}

So it's all fine.

>
> Have you considered moving huge_zero_folio to BSS for
> CONFIG_PERSISTENT_HUGE_ZERO_FOLIO=y?

Interesting :)

That'd be huge for larger page size and why would we expect a failure at init
like this I guess I'd say?

It'd be nice to guarantee it though.

IN general you have to have CONFIG_THP enabled to get this at all, and surely
the micro embedded systems will never set that... (see my RFC to just make the
persistent huge zero folio permanently how we do this and remove the damn
refcounted nonsense altogether).

But one for a follow up anyway!

>
> > @@ -308,7 +323,46 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
> >  	return 0;
> >  }
> >
> > -static struct shrinker *huge_zero_folio_shrinker;
> > +static int __init huge_zero_init(void)
> > +{
> > +	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
> > +	if (!huge_zero_folio_shrinker) {
> > +		shrinker_free(deferred_split_shrinker);
> > +		list_lru_destroy(&deferred_split_lru);
>
> Hm. What? Why does huge_zero_init() touches deferred_*?
> That's caller business.

Again existing code :)

But yeah that's really broken as subsys_initcall() apparently discards the
error...

I guess the thinking was because I think because it's doing stuff after the
deferred stuff is initialised and bailling.

In practice it's probably an impossibly small allocation to fail. But should do
something about this, if only oops-ing on failure.

But that's for a follow up :) existing code, backported fix etc. etc.

This patch is rearranging stuff so the code is much clearer for the race stuff
taking into account CONFIG_PERSISTENT_HUGE_ZERO_FOLIO.

>
> >  static void __init thp_shrinker_exit(void)
> >  {
> > -	shrinker_free(huge_zero_folio_shrinker);
> >  	shrinker_free(deferred_split_shrinker);
> >  	list_lru_destroy(&deferred_split_lru);
> > +	huge_zero_shrinker_exit();
>
> Any reason behind the reorder?

Well 'do everything else first then call the external function' but really no
solid reason. It makes no difference though.

Can re-reorder if a respin required :)

>
> >  }
>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

Cheers, Lorenzo

