Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B11A6C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B256B0088; Wed, 16 Sep 2026 09:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53586B008C; Wed, 16 Sep 2026 09:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999C46B0092; Wed, 16 Sep 2026 09:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 746A76B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:18:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DAE81405DD
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:18:45 +0000 (UTC)
X-FDA: 85219680210.12.A41635C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 661D9100004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:18:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VJaqVsvr;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789564723;
	b=FoatpjOAqLqHZN8gwUB2RXS4H5fatUYpiZgpsVJXAJIEsGso8+Chlm/MCW/HpgoXW9lstT
	EN/FN9dzD/mXUCDM6h6br0vlP2H9PnWzHxa28i/QH9IyjcFwPI6AjbKhLr7EObPYjTueXb
	rBT9wNyN+KviBURMj8OObF2c/Dds97c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VJaqVsvr;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789564723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEhcki1FWir9Oh5eBIg+At1+YvFsWkSvwkm/yPub4nY=;
	b=R5SdYgtRJs4gF2b+twYprxIgUKMIfMfNhFMYvFyjRMJjrtAdQtGuGdo99/7r1xHiNFEAbQ
	z7f2edU9+IUlrZm6R/Jc26j7+bGwPO8LTELKAUp+m9B4Ep/QydIhFxcRDAxYa97F8EZo85
	XTIdMc9c5x3iJ1oc3uX9SYJjiUfA9Tg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5AE860234;
	Wed, 16 Sep 2026 13:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1CD1F000FF;
	Wed, 16 Sep 2026 13:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789564722;
	bh=DEhcki1FWir9Oh5eBIg+At1+YvFsWkSvwkm/yPub4nY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VJaqVsvrsk5KkE/cdHDLawuZ/0bUQ892OUWjj3oraqjRyD+GzzDAZGAS25s0UI/00
	 IQyw7b+SX/pSwjiG46K193E40Mo3RlNFqM+4ZsRrDW/2bspstiP7cDVTg7L3z5iu/t
	 GTvfL8Bcl/cBCmOshtjmSgJwY/bSV0d6jd+MCiXK21guK72klUVTr/uiuM4MOidf2c
	 ThGTZl55eN3W7yl5jNq1HyklXXe0OpgE6tOuIbKn4ald8+9gR0NxzDP8JT2ANpxRA/
	 IW0Og3+QGPbV+qHSl94PwJTe/Cgu5M26QdA2zoSRG2+nCk/aNxpkxt/dcUQ6vXmFRr
	 rjuvCWet4NYZA==
Date: Wed, 16 Sep 2026 14:18:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqqTtW3vjfzH8bcY@gremlin>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
 <aqlzzwLOVT79Ti_7@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqlzzwLOVT79Ti_7@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 661D9100004
X-Stat-Signature: g8o3tjkfyy4n9dqqbtztfn1tw36c397p
X-Rspam-User: 
X-HE-Tag: 1789564723-697142
X-HE-Meta: U2FsdGVkX1/huvlhgTcYD8JMgj+mHOGtH3gUqaC11vY6ZkpgEmyAzD26+6AVeTofLgcA5GpKP2RM2c1Xffft4pGnQt6XrRGQHC0wNzqwsQTBhZ0akTf8wkwUA7AhuLgkz6bLT8+W9sZQoK/qHMReXQzwnmsf39HkQYy1nyva0QHqDQRbaL1JdSHJgKDwiNi4he74/3qVlz467lZk6xg/I7tGgwR/q0B7yAMUa1NHUxPaYUsJWGSPWlr5JiUSVLDQjUR2eiVLxWJ9wFtHDpAL9X/w44420AXb07U91T4EFL0+lkSuA5w5KRNcu2zUwftDm8/pk5cvgdkI0jTreExGpDVrDOQLWm3fRExbYfux11HR7IWfZSdmHZjHX8xumdwH8p1wpsmIvZvhSc8ItOYs5DBD9WyR2CNagbtbFABdh4dJzS+pXmiIKexY7AxNx+5xBHFXl6qwWaYkwQJAnmW9O405oko1ox2cT6+QKabTP7pkM0atJTolvqQRLuTLVF5LRHZ0Q0tPhAkRSRTfpVM00/zh4kBuv+bZl/Xv8yVe0vI2usLUfk+UFjywI0MI1yvM80A9fQzztzPd4cycTwBQ5E4Ft0HYXuK3FCTbDxZBwc3MYizqIizfzUEOM7vUWehbmUfbhWrzAcSbEALrUEe+rcWCiOfuuAxWjtmuWSP+FmwqS6eSKQOKLlrG0tFX4F/+r2Qd9Hpw0f6b0KkdD6TJZAn70rSxStcvKGOHqOEnGct/wUi9GQlpWQwLsf4h57UAL9qdURnShuBh+n5q0pSfXLMrdCP8jqJON1MIj74+68dlLFlojvT/WTsh0Kuf5dwi5GrbAsu1bmFObb/OmbYQhZdZhz9jC+sIDPIWl/X29k2EFa3608f28u0RbZs2ApXmReCJVFKot2Q5T6QjI0DqG1aTtucDMfkVukUWEEclW8UexXVtj7B80mRZXhLWaHh0zz82EKm342PF9s8+I06
 q0uM0xKM
 NaBYNSin/2c62oxDvbYIGlwqGbwXCe2wWHE5CKhi6TaLwvah7j3y0uSTwRNK7UGPlseOgxpt6k1YdyroWZqI/P3H/IWjVdgyESXDJ2w8y7tI9tZSrqKWZXIJK8W8k2eD073lYhmbspOSgj8s7rtQA9JBEYEqdv5XvO+ZshT0cBe7fFv1XlcEXetCjAiuPX0uhkp+IUZqfG3JhULT5NFqi+qLgrDLVKs+1+9GpgFnKFUXG8zIsjc1XTX1E1ULiGJRWHvtAHvCtr6Z4Ao/NCTPS3ylTcFWSk1h4lRejUDFn8j1y/KOJ0WYNkTKxhEQlVEbA7bXKNlO04UmyiBOWxZjOaO3eU7W+z0QYlhraLXTqXzlCfyb8GCmfdDGB6WsjO0Y4sBwH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 01:00:31PM -0400, Gregory Price wrote:
> On Tue, Sep 15, 2026 at 04:55:47PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > diff --git a/mm/madvise.c b/mm/madvise.c
> > > index 574aa2bb7c7e..ba5a3d77241a 100644
> > > --- a/mm/madvise.c
> > > +++ b/mm/madvise.c
> > > @@ -464,7 +464,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >
> > This function is truly some of the absolute worst code I've read in
> > mm. Shocking.
> >
>
> relevant meme: https://i.imgur.com/W0N40BK.png

Content not viewable in my region :'( seems I do not have a loicense for
that!

>
> No argument here. This function in particular is really horrendous.
>
> I think i'm now 4 or 5 stacks deep on the "Thanks for fixing a bug, but
> while reviewing your fix sashiko found yet another CVE-worthy bug".

Yeah, I WISH it wouldn't do that.

I mean it's helpful to some degree and it finds real stuff.

But it's _where_ it does that and the workload++ aspect of it.

>
> I'm convinced (like you below) madvise needs some attention.
>
> > >  restart:
> > >  	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> > >  	if (!start_pte)
> > > -		return 0;
> > > +		goto out;
> > >  	flush_tlb_batched_pending(mm);
> > >  	lazy_mmu_mode_enable();
> > >  	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
> > > @@ -568,6 +568,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> > >  			folio_deactivate(folio);
> > >  	}
> > >
> > > +out:
> >
> > Seems odd to put this here for a condition that explicitly guarantees
> > !start_pte? It should be before the if (pageout) reclaim_pages(...);
> > surely?
> >
>
> I wanted to prevent any future use of the label from skipping the
> start_pte check.  The function is so bad I was err'ing on the side
> of being a bit defensive without making it worse.
>
> I suppose reasonable to say the goto is worse.

Yeah I know it's all a bit much of a muchness, and obviously my suggestion
_duplicates code_ which is also not wonderful.

But the control flow in the function I think is a bigger issue.

>
> > I honestly wonder whether, rather than adding yet another label/goto into this
> > absolute bloody mess, whether we should just live with a bit of duplication and do:
> >
> > 	if (!start_pte) {
> > 		if (pageout)
> > 			reclaim_pages(&folio_list);
> > 		return 0;
> > 	}
> >
> > I actually think that'd be clearer at this point than throwing in some more
> > indirection.
> >
>
> I'll spin a v2.

Thanks!

>
> > That's for the backport but somebody needs to rework this entire bloody
> > function going forwards...
>
> The longer I look at madvise, the more I think it is a wart on mm/
> as-written.  A userland-driven page table walker that requires all
> the special-casing of Yooj Pages, zone device, swap, soft leafs, a
> bunch of tlb flushing 5-tabs deep...
>
> Scary surface.
>
> I've been trying to think about how we might make this more reasonable,
> but generalizing the different walkers across mm is pretty hard.

I mean it's a vital interface, but it often feels the wrong one (it's meant
to be advice but several cases cannot actually be 'advisory'), and it's all
a bit of a mess.

I wouldn't be against a new interface (new system calls aren't a big deal)
but it'd have to be carefully thought through.

Like say, the complete diametric opposite of e.g. prctl :)

Anyway we have to keep supporting what's there indefinitely because users
and such and in any case we can certainly improve hellish code in
madvise.c.

>
> ~Gregory

--
Cheers, Lorenzo

