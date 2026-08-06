Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA4AEC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 06:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C765E6B008A; Thu,  6 Aug 2026 02:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26116B0092; Thu,  6 Aug 2026 02:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E446B0093; Thu,  6 Aug 2026 02:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93D1D6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:29:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 275B6A1BF2
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:29:35 +0000 (UTC)
X-FDA: 85069868310.08.FA53457
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9161340002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:29:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0TdJHLp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785997773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTUsBX7WtmPH4wCrVl7CPUs1HMuRqiZHQH/yykCv0ts=;
	b=uWJPEadp8b4w3dcKzJx+UXTHoBoOEAOwfAZ1YviKBLCBLYUv8mVp0YyHH3712ZvO6MlIlf
	50MT0EAeNUlwGl7cZ084msE0cI1sSzyXj2cpdeIpNYrR4iGfJgIQHOHc7U4jwMvsMcp3c3
	5W+F5OmPZrbU37OOw8RxrHIKLQ2z9aQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0TdJHLp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785997773;
	b=xOBe+gZ6tP/nwfjtmUbbLQ7SVSxWUgPfbR+3u6pluw+E86xEGcV2XxI+qf4OjB+6jCG08R
	KtxCGFFpWSbLvj2G+Drlka5izSyCqOQIKQzTze4kQhEEKHfZKIk6wdGm2652p92LxvtEqR
	/NmONW2iQffk/i61jF/PpdoDlqjYiKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F51060A8C;
	Thu,  6 Aug 2026 06:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B571F000E9;
	Thu,  6 Aug 2026 06:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785997772;
	bh=uTUsBX7WtmPH4wCrVl7CPUs1HMuRqiZHQH/yykCv0ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i0TdJHLpfRIyVrazRatHbTvOQTLs2FrDrmZdevwhXrlB70kdbMutIMO4Q5tF3VWRj
	 mveH6kM7aX//q/uH/xGjp4JakUszPnnIo/x9yqTOXr4nLFyAZTr2QIrdbp8PPrAaS7
	 FSt0pfJJn6Gua8r5CHpaoeK9bVAmFVgjs//34NwJp02r1rt3DpHVAxhT7QL3BQMiP6
	 Alzo7gSekvASdiGktAbF2Ryg9I10oCS8N5oOjFYE2H1tMM1bNXE7yxXNRLDDRcaPuB
	 PTO9jX9BPQgavUJl98HIXkYtvOfOI00bMn5RvpJsvVqqa4mg6LLo+fzBxhW6cYrL65
	 dls2OcjdeF3tQ==
Date: Thu, 6 Aug 2026 07:29:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>, stable@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
Message-ID: <anQpWs6fapNVZSdt@lucifer>
References: <20260805055544.1568534-1-clg@redhat.com>
 <anL-NZkNMSSxN0YN@lucifer>
 <anPm6vGNeDxLFIkJ@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anPm6vGNeDxLFIkJ@casper.infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9161340002
X-Stat-Signature: r7b77wcushhzyx6ktjfihqj6penh1wo9
X-Rspam-User: 
X-HE-Tag: 1785997773-551202
X-HE-Meta: U2FsdGVkX1+oopOJ12Gr2xqjpg415Qbidqys1mM6rFJ2vBVoX/KSj6nrET80qQl7NLeaCrsKg2vFHZPv+XMx6zmA3TeiqwXQmJw3rU9lp4Q+r+gP9zxf9rxAqgeiT67JhNzleMzlAHeZXS8/lZiJXqf1tn7vD0mSLpH103k2IyinWbyz/2hBaCG7dtPymHkaGfyqGykm6Zwii+CgSK0yJiEX5A8UaFiE5emGhdT2+0rR00CEbBHMoyTQ9Z2e1MGRgOZw/by2fj55l9S4Sw5bvinTsnGzYt945dFBkxohXliMk5xeo4Cvreq61FM/vWhERd68sieTv8IhdYlI9oBAsAqSjlKmitvimmemZCEkoRyZtsscgBnIpfrWkwNnweXK7Opm/2sYpkkgFg0ej2/vKs2mOaT+9xjc4yCXQPrZXaMq7+nwjaIWCrSy3Vtwhpk8kEkx5T3dbfQcEJGdzkk7nII0jwIu718vMHnEZnX6H098+mmkVWM3Ar8bPUO2ERSFPB/vvpiiomRO7+LtUAKTKQKqlp5hFNEvvZmzfGhGLuvZaf4bMFETdN1cQMGF+B5I0O78iKmQ2aQbrkmoGvpc19WhC2ARAggV2WoAKFU1T0fgELHazDhyrqiAR8aJLdb2oEmHize8AIpmcUYrQcL2kXFYwan9Z+hOxKnCAVBbtSpnHWeXV/xifilnmnX2jCE4lsjcvTjykp1N+GiHIAkp5gXfcynz4WyT3nwC6WfOKeeWvMOlbagzhrGq2b7nYECg1d7s7b9Dlm+/Bfb5mw2BXCxChQBqVc3ZVMRCO5UsGtWW1ffQZ4dk21UUDGFlqFnF5uK0JsRD6NH2+PU7P86o1yuuMtVf8UyMxqsGJrB4mqjbJAWEMh0fJVLY3m1ebq9D2YOaqXzC+xv0191Y02FLEifzDDkgmcCDPS09rwHwft1vFO5CgNcF8yfmydT4NBd7+l+eHg4vkoijz3skKGz
 gA0Se+mD
 VilyIhxRZS46fHSce66nnhE78J1+Yw+Hr07vlkp/3orwgSBKGuz4CNl/uL+uYRVuc00bccHlLbf9fihUj+3p8KiR4JYJRRIfnIItkK+QH6YkIE9jnPwPWdnC+K3Jl70q7KgzmctJbdAzGJ96qJ0Pl/Xft+dj78fhkG+ql9ANfl2+gvIhTcu6i2d2f7FUlupydmO6GN+0+REu+cLaNucwYUdkiqYTNv0GY01M50T//MM+pclgYIc8yGPgL1ZX3BMQggDO1uyobLxceD3t4oZ4NTe6puSIMPYuaH54jz6cSV+EdoUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 02:44:10AM +0100, Matthew Wilcox wrote:
> On Wed, Aug 05, 2026 at 11:41:46AM +0100, Lorenzo Stoakes (ARM) wrote:
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index abc65d608c23..5fa01364f089 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -111,6 +111,34 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
> >  	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> >  }
> >
> > +static bool should_obey_thp_file_tunables(const struct vm_area_struct *vma,
> > +					  bool forced_collapse)
> > +{
> > +	if (forced_collapse)
> > +		return false;
> > +	VM_WARN_ON_ONCE(vma_is_anonymous(vma));
> > +	/* Huge PFN mappings allocate no folios so the policy doesn't apply. */
> > +	if (vma_test(vma, VMA_PFNMAP_BIT) && vma->vm_ops->huge_fault)
> > +		return false;
> > +	return true;
> > +}
> > +
> > +static bool can_thp_collapse_file(const struct vm_area_struct *vma,
> > +		vm_flags_t vm_flags, bool forced_collapse)
> > +{
> > +	/* Override THP tunables? */
> > +	if (!should_obey_thp_file_tunables(vma, forced_collapse))
> > +		return true;
> > +	/* THP=always? */
> > +	if (hugepage_global_always())
> > +		return true;
> > +	/* THP=madvise? */
> > +	if (!hugepage_global_enabled())
> > +		return false;
> > +	/* Has VMA had madvise(..., MADV_HUGEPAGE) applied to it? */
> > +	return vm_flags & VM_HUGEPAGE;
> > +}
> > +
> >  unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >  					 vm_flags_t vm_flags,
> >  					 enum tva_type type,
> > @@ -188,9 +216,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >  		 * Enforce THP collapse requirements as necessary. Anonymous vmas
> >  		 * were already handled in thp_vma_allowable_orders().
> >  		 */
> > -		if (!forced_collapse &&
> > -		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
> > -						    !hugepage_global_always())))
> > +		if (!can_thp_collapse_file(vma, vm_flags, forced_collapse))
> >  			return 0;
> >
> >  		/*
>
> I think 'thp_' in all of this is confusing.  DAX isn't THPs.  PFNMAPs
> aren't THPa.  There's other reasons to implement huge_fault that aren't
> THPs.  Can we rename all of this to drop the 'thp_' string, starting
> with thp_vma_allowable_order()?

Matthew, are you baiting the churnmeister 3000 into a refactor here? :)

I despise this function and agree with you entirely.

So maybe I could add a few other patches first before the change to improve
the horror show that is this function and its auxiliaries also :)

--
Cheers, Lorenzo

