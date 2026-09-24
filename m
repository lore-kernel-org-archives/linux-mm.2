Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F507C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6066B6B0099; Thu, 24 Sep 2026 03:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6E16B009B; Thu, 24 Sep 2026 03:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE286B009D; Thu, 24 Sep 2026 03:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2174C6B0099
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:56:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87586A02B6
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:56:40 +0000 (UTC)
X-FDA: 85247898960.04.E92356B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EEF9A40009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:56:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odmVQ7Dt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMvc3Z//XYqelk8JnFtLHUgeDJdTu8PnHAzgmjTWd/c=;
	b=jFITbrMXjJuFRSKggxu2WcDdcIwkqYClckN5UUicOBAuidqdRRuZSaWLcuyXCHsig8hi/l
	fAryPvyGcILeRLJ2DG31f29bCZHfkm4Vo+e1sjNWq1d58Knp8kx4CcqHuzHAAXwTVzm8v/
	EYGZcXnM4fyVbwF+x4I/0hIoTS1srFg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odmVQ7Dt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236599;
	b=I+9KMt2Q6dEHy47dS5stRsUSClIT+vYzzaXb+7I1/6WtvQ+bw111A/oGyQ+lXvAhlQJrXf
	4v2D+iIeRuslm8jHKSHraNoZIlkHKJ46dAYI1sdU3eE0AkJWH+GVZm2ZGjj4sm7NYBYno6
	t1+yGLrulHA86+IIQUWDlHpvIrcVWYI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B60E601FF;
	Thu, 24 Sep 2026 07:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14CE1F00893;
	Thu, 24 Sep 2026 07:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790236598;
	bh=AMvc3Z//XYqelk8JnFtLHUgeDJdTu8PnHAzgmjTWd/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=odmVQ7DtmdRtAwA/YGAps0oiLrwR0LA/kI1F1X+zml5UI3/3DHB+da17YrzTVC0qV
	 yH+LFPuJtIOZ1e3d0k0n/QxBncDgj2d5slyT9T8+axmeNtQu9cm4aJ3VOXKKfbIJN/
	 Jxxs/Utmeh371xIq0ZBHMAJSqKNfjoBC6GKLYGpuvhME/fL4bP8NC7+9X8KLskQu7z
	 EWUlYS/Dq1VaR0i9DlgE1AorfAS4rbTCvdUFUbG49vzFiClOLSO8fcSbWDxusmNaek
	 YQg3ejgRGzP+Vhtl/h12snOugfWYh9d8Z25MU6NXX8mHKc6NtiDSOvf+QiZcdyN/Um
	 zLnGpAu0IZzGQ==
Date: Thu, 24 Sep 2026 08:56:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: predicate setting mmap_prepare VMA fields on new
 vma alloc
Message-ID: <arTT5RfK4gjW_f0d@gremlin>
References: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
 <a4bf1f96-787d-4c1e-9bef-52ab2be570ae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4bf1f96-787d-4c1e-9bef-52ab2be570ae@kernel.org>
X-Rspam-User: 
X-Stat-Signature: xh65ern3t84xa18bdktchhmshz1u1hpm
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EEF9A40009
X-HE-Tag: 1790236598-640082
X-HE-Meta: U2FsdGVkX18X6FGAHg5Xaf8GOmfT63PKjlgBHFHfx/MNucI5K21ZhVvBUUL78vXYg+PxDsozcyQchaUMS+wvutAuhl9BA6/dnXxtmQERDWEiACROEgtz28J9TvaR4ERd/WtByZvBbkVGqIMyRjxR0ZvCODkJ3PMNKjccuFpRymWr+YXUOVZUSq57SMvpZFGfG5/pPzDi0Z4zvBchvMXdMYW9AmQXLLSE0uRKK8iDNQ2AKHI2Y16uIZO0ghKfCdnAZyjBGV195O+/PYqQFLbXDUoBFv/xPNAC94kZIkT5LNT3caX7y/1SQhxWgGPBfpNQRYRRvaCZlqBcPFx5ypdmZ2iDJxO+E2hAWmWrGtidBwEZbcUvm2H6Y2aH0dqIaMr58tPIrE2eAe4FqNUCp0g9SHV/WYMGrCzdqWFRATIVadkhaaFA4AxHKuzRA2Y+mp+NRV2ux4mdLUuCCK+4fndykcWnoNnPl1+jvUpYrm780Ueq3wL6hwS6gXH8FzK2X2C5cM4Mo5oDUtp/lpJRI/cJWkjnwU7hEVprvdQ/CwMoKB84rVDg2PLddGrIRo5K7g3skiGXQwdSSdVGzSeAzFgb1ValbWVpqKCbh2A8pVsEVEz3JzoRjmr5/k51aqFa342NB0Pjur0QTAmEyZ9on+VpAwdTkx0ACRX0UuDXXXNoyTLcBWp5j35K4j5R813flt2I3SHWWxL8hxtXRHOfMPvwehxIjWtSJ5g45e26J+CsTnWlSvpF8yCd0UVzA0Jm1DmiTUbo6mI4ryn2yTEFTWRqGdF8Wd3D2FVvQGz2Zb4rTpHEwy08KKKIc84s1RFkNgwxMP9+PWMbzlOZ5sUHQcyAZ9B59Jv9oEHvrPuTY6Vp/fvBaCtZBzzU3s8xUyYO69kQVlfsBvEWXq/AdSQRHTtdgwhT/smtxrfSO4Fd2FFxbOl9KDPVTFShjcwgyFJR1e2A3bf5sAYr+Uq71Of1X9H
 hAoomwCh
 c1blKpuViZDsn1h9PDbsfEMe/6bHFX+zJsDAINKIM5/9c/TNrbKOCqEc9NB8jCDl7GXdZMEp1uDL2fzB+s9dM3M3o2j11WAYdzvj5gjD1mrH+nrxXbYYuk4QVwfyDngZcGorvNfUxe8JKlo4RNl8jcKLVGB602GgLyksmANAGNMjhUIfJ8EbLngwLYN7PfYlQBe+xkbHH/PmrnttggORRoi8yjsgg2tlr3hlGkpKy6gybyXN9eH50QW1zN+DQaYJV6i8locv0KNLH6HBUwdrQ8Gkhp20LgPOg3C00vCcTXmScDWTysgg7ccRZrN8t9K4VXkG9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 09:19:26AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/23/26 19:45, Lorenzo Stoakes (ARM) wrote:
> > It only makes sense to manipulate VMA fields if a new VMA was allocated,
> > rather than merged.
> >
> > VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> > keeps its own, which is also what the legacy f_op->mmap path does since it
> > never touches an existing VMA.
> >
> > Currently, these fields will get overwritten by whatever state is
> > established in the mmap_prepare hook, and if the VMA was merged,
> > vm_ops->mapped will not have been called, so this could destructively clear
> > existing state without replacing it with anything valid.
> >
> > There is an implicit requirement that vm_private_data and vm_ops are
> > fungible across VMAs which means that losing the 'new' state is
> > fine.
> >
> > However in this case the 'old' state is being overwritten by potentially
> > invalid 'new' state, so this must be rectified.
> >
> > Additionally constify have_mmap_prepare while here.
> >
> > All existing in-tree users either derive state for the tree or are
> > unmergeable due to VMA flags, so this has no direct impact.
> >
> > Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> > Note that this is cc: stable to account for any possible back-ports that could
> > break it (unlikely)
>
> Does it mean that patches are on the way to mainline that will break it, but
> it's unlikely they will be backported? Or there are no such patches yet?

Nope it's highly unlikely. You'd have to introduce a brand new mmap_prepare
etc. etc.

> Just curious... if it's the first case then with the amount of random stuff
> that goes to stable these days, I'd rather assume they could be backported
> at some point :)

Suren insisted on it being a fix and I didn't really want to argue.

I thought perhaps it hit something real but when writing the patch I asked
the LLM to actually check and it seems not, which is exactly what I thought
initially and why this wasn't a fix.

Anyway it's a small change so I think it's fine for stable.

>
> or out-of-tree modules which might be affected.
>
> That is never a concern, and even suggesting it can bring hch's wrath ;)

Yeah that's what I assumed.

>
> Anyway,
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks

>
>
> > ---
> >  mm/vma.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 9f0a0acf694a..6cde67883fb0 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2849,7 +2849,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >  {
> >  	struct mm_struct *mm = current->mm;
> >  	struct vm_area_struct *vma = NULL;
> > -	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
> > +	const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
> >  	VMA_ITERATOR(vmi, mm, addr);
> >  	const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
> >  	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
> > @@ -2892,7 +2892,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >  		allocated_new = true;
> >  	}
> >
> > -	if (have_mmap_prepare)
> > +	if (have_mmap_prepare && allocated_new)
> >  		set_vma_user_defined_fields(vma, &map);
> >
> >  	__mmap_complete(&map, vma);
> >
> > ---
> > base-commit: fe2ec83746e501645709761605c2464a44fd2929
> > change-id: 20260923-fix-mmap-prepare-overwrite-6304d112a4c7
> >
> > Best regards,
>

--
Cheers, Lorenzo

