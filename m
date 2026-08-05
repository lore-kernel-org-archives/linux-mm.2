Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90896C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436B16B0093; Wed,  5 Aug 2026 12:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E81A6B0095; Wed,  5 Aug 2026 12:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE356B0096; Wed,  5 Aug 2026 12:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10E1D6B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:26:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F3E316050A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:26:55 +0000 (UTC)
X-FDA: 85067744790.14.ADB827D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id CA4CAC000F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:26:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ii3HHFaP;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785947213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fV8b/4Y/yqMyoR8AxAiGFbcq1oDUETRU4WY12VjWgDc=;
	b=zu3iv+1ExGg1B1WwFOiLgHLYQAPm127M1S7hT/H0Slsj5nK24cQgBu+4Cr0LZQ5F1Z8Wbv
	P5/SmORBmZo3Ml7Buas26cfFGrV8cr5ltvP+KrUhLvDr4cbO/b0KKNuL3Ald0DKzHN/6jC
	ynr6WVDX9EgRchUvEWYQQde6lTPz1jE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785947213;
	b=uy4CM/eIqWjJmvQOxXjEEFHZGs7+cdfupiWVed4LNRJyqsjzaCm2Aj764Tr7IPPIyvQ2FT
	XnPj8uqKupnViz4DL+VD7u8iV16QYk/FUg53bL4c69KPc8j0kuRGFP+GbApv5KXjflyXWL
	WO1GLm6A5MifRQMqo+gdiqJeEZb+KUw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ii3HHFaP;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AA3843B10;
	Wed,  5 Aug 2026 16:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC2A1F000E9;
	Wed,  5 Aug 2026 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785947212;
	bh=fV8b/4Y/yqMyoR8AxAiGFbcq1oDUETRU4WY12VjWgDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ii3HHFaP+cLRY1G6nl+4ikP+j0AuPQEmO39D9OK2MX5r11FixTJJu4FZ3CBiNVeEZ
	 WVPF/ni06PFEfU+gLzl3vVmZ2j8E2/SncgOJ6iyKFabAVX+2L16QLJqsEw22X23u2f
	 2H6MDuPX3ALSchNr75SZhI7Zm82L+cTuuOb7wglYRCCi+FxQIG8Cw4GPEwIH9J5I9E
	 VIoxuWl5har0rDJMMs7FL+xXcNmxrP7B19vLmS0pOivktsBwidprZjqqDElhDxtaLC
	 AJBuEdqY7T+NjECJvRMG8eXMJqXPRd/K6RRUV3f/V9Ry0Pe1lS1d1FbZ+v8/61/CrA
	 vQvyiJrp7LRSg==
Date: Wed, 5 Aug 2026 17:26:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>, 
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
Message-ID: <anNjdDxP5-Oq5eXk@lucifer>
References: <20260805055544.1568534-1-clg@redhat.com>
 <anL-NZkNMSSxN0YN@lucifer>
 <4ddc95f2-8868-4be3-9839-e2d14cf35fef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ddc95f2-8868-4be3-9839-e2d14cf35fef@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA4CAC000F
X-Stat-Signature: qjhegi3ab3ymrttf3afs35i3umd5sj8z
X-HE-Tag: 1785947213-979573
X-HE-Meta: U2FsdGVkX1/Eid3+c7zE+qNcN4emY3IhCQBYS2ijdjcuUQh18N7fIdUHCGWVUYms+Pmam52Ant/ohpWXET/H6lJjm4TwvZFpzid6aP0bZqYnpNR4Gg9RQRruj/ygb6ym8SKM6US7okGPxtiD4vav5DTbRBejXfC5R/exJndG+EkmX8ypI7yxfAxWgdPFL7ImV0V6V8I9agZDLSOPSazMFe63yzhZjRc7w0Gs20nfwxHUOviGbpRpvIeXGF3lfT7eFhu6vrYJG1EdpN+M6dvITRpeDQH8SM5BJj0fBi4U7se9ZmXcXzOnmcZVRwMrUctR8IzRu/NO7q5MFQNPenYjnR2lVHvFJGp7K7C+ca+Qpcw5053sz7EmF+47v6Yvl7OfXdsUrviYX2WLZpgCnFy9K5IbDxKeRy2zbhG2CaIaD0UiND7/SaNw4tB2KHlHh4v2EJKOjmjPooNsdD7x8tkNa9pWuI3DRRVdbtly+k7uIQZ5TZNLdz3shPdIDRVO/I93HAScLw/41sfssktnDOCS9/fu7FZEy5/xTuWhYMOzGhw98cZu3SM/HRNpB8+nR9DJ1uw40woYX6Zp9yBusISHj2F5gHFfovoq95H6lzOLXZ4CplQ2/eZzsw5oS+EM9qQBPKxm5xmZ+HhgtfiN9bwuxUtjajQtsDjYArSvdCZGOW0x7ciPtPQ9mSlASu87LQ1Bkg1YEUeRMmvKkRGDI/zyFLOpSXJDCTVqXCaUnjOEkCiXYrHK8VMHWWBZ5dU2Lxw6dTfZdcM/lXQ9RUS2PslWghadysZfhxXyy2lLtkRSMPbmVw8YXn4q+JFU8Npt9IzZz6crGmNUwxOR11HUK3HZ8JehpvBR28kUAb3O7KGf++aAET8ZQocEXQ1jwvAV2aEBO/48QGs7EHWJsc1DXxgniZKqGInydBHnnuP+1od67ikONdZIqstXgydwJdGXHE28aO3IgsmaC+eUgsftQhS
 K+zL5eYV
 gMclNjIDem6+lHqEet1fBao9CG+QtKPjbmQcGWtsJH38vTUWSdFymM7wAdGxlt1FLk0RBox+cpjk3wcoXGGJBRuqnOWLdL9g1nbV7lSNoJvhZhZjOlPFiDWfrSg5y8Zlb5+EwwY6cypTZadlMhuABOImkMb/B/rta139fMkU66J7I7FLdXg/RpMe9p8Ee8DGSNQ079yMfq7cW3Y3vE4LBbVTDPeX6rRlznnbVIcWsk76XblUAkrkujcqeJPe7LI7DSQEbk+Vlj8PgRjnyMq3YgvOJTD33tuk1LdpO/03uaLc+1yvF6M7bnuXBAw+uZLI1nqjnWMqI5oKY3j3r6ax99MB1pEar7J1/1m1q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 06:21:30PM +0200, Cédric Le Goater wrote:
> Thanks for the quick feedback Lorenzo !
> > So I think it should be something more like the attached.
> >
> > That way all the handling remains the same and the override is applied in
> > the right place plus smaps keeps working.
>
> LGTM, do you want me to respin a v2 with what's below ? or you'd rather
> send it yourself.

Thanks, I think as it's somewhat divergent maybe better if I send it with
Reported-by/Closes if that makes sense to you?

I'd like to get David's input on it first however!

>
> C.
>
>
>
> > ----8<----
> >  From d6537260722c8741586e6295c8eea68d06087efa Mon Sep 17 00:00:00 2001
> > From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> > Date: Wed, 5 Aug 2026 11:35:13 +0100
> > Subject: [PATCH] ideas
> >
> > ---
> >   mm/huge_memory.c | 32 +++++++++++++++++++++++++++++---
> >   1 file changed, 29 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index abc65d608c23..5fa01364f089 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -111,6 +111,34 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
> >   	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> >   }
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
> >   unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >   					 vm_flags_t vm_flags,
> >   					 enum tva_type type,
> > @@ -188,9 +216,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >   		 * Enforce THP collapse requirements as necessary. Anonymous vmas
> >   		 * were already handled in thp_vma_allowable_orders().
> >   		 */
> > -		if (!forced_collapse &&
> > -		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
> > -						    !hugepage_global_always())))
> > +		if (!can_thp_collapse_file(vma, vm_flags, forced_collapse))
> >   			return 0;
> >
> >   		/*
> > --
> > 2.55.0
> >
>

--
Cheers, Lorenzo

