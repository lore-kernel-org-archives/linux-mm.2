Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF02CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4956B0179; Fri,  8 May 2026 11:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 495106B017B; Fri,  8 May 2026 11:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D25F6B017C; Fri,  8 May 2026 11:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9196B0179
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:05:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA6EA120162
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:05:03 +0000 (UTC)
X-FDA: 84744575286.13.6E73868
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3EE5D180009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:05:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jJ7xyntZ;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778252702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymk1F2CjJOyaL45uejPzO6xFm+pjZ5Em1rn94UZAMJ8=;
	b=D4o931K7VEZeCWzwOVkwrGJ5AFMP3WWX8OIbSOCTxHUk3UEQGQWzqTDX6Z4PSWVGlFNnaM
	rFZ6D4czz9vxy155RkigkDysZkLa3aWr5DnhadNuUPl/cA52EsSZ2HMw5tVZqM9QoefFqw
	b6LblatHRBHPeMS+J+tU8zh2AQzyQdk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jJ7xyntZ;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778252702; a=rsa-sha256;
	cv=none;
	b=7S6x4sNgjkM92z3QOJEoyuLITyi1MorPbPjHzYVoq9LtRiJ64ksM1gbqRb3eYD64po2KX+
	33x3iT8+usrZ+twEnry55eODwqMff1hD2yFNI6HGeoCvzMVqbVc+pUNH7UpkdLRQidBZ3P
	GzPE67WVgDzV4s4GdgUPjFfr7/NMWPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0826240E29;
	Fri,  8 May 2026 15:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81ACC2BCB0;
	Fri,  8 May 2026 15:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778252700;
	bh=pHhXaYIL6lMr7VyVYgXjxrjXvNYn0pBdbl82D6nEY1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jJ7xyntZWU58Of0vyAiLFFEf2zOU9qg0NMn1RaF/ZqBdWkU7NlK9DAHDMGeFngvHw
	 /R0rPd+GiRT2CWWIGMgC+yZEEkyOW5pY/IiltvtesqkM6o0ilZO9jN7bEoICq/nXE1
	 4HqiK5RaOl0sPiL9zam1U6Q8wxNIbsrISWt0qJjSW9VmCM0F2idhPWcguh4bNyrVYa
	 LAjlAYDCSVTCjQU6PomeHgbxLi5rhvQWuzkNrGVzs8iR35InVb4gcCMgR9Kb5ZWQsP
	 R1zsdv19/yGy6/CQOyTq+sWjy1I34AfHCwL6nxWuUtobpDP5A6zvtml82i4AGaCSzL
	 Qp7JX4tFckgkg==
Date: Fri, 8 May 2026 16:04:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Chen Wandun <chenwandun1@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, shuah@kernel.org, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/khugepaged: fix spurious -EINVAL from sub-PMD
 MADV_COLLAPSE range
Message-ID: <af37aPMyMV8JSIPH@lucifer>
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
 <20260507070558.3064142-2-chenwandun@lixiang.com>
 <9eea2afb-8c35-47eb-b1de-6a08503c9679@kernel.org>
 <af30otSSGbPxHbxM@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af30otSSGbPxHbxM@lucifer>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3EE5D180009
X-Rspam-User: 
X-Stat-Signature: top3yxygb99k91tm71fdje9z6prtbekw
X-HE-Tag: 1778252701-107845
X-HE-Meta: U2FsdGVkX1+xoDpzuwW9HACGljdQLPUDqpeyk6HxLvtkq04j3VcgD2d4kEub92hFEbG4aaaK7m6u0whYarXP7l9xHFh3fFhB0xgg/BiXpR94XqthRlHjKKzgd3kDm1GhOyF0ZcymXvxTlzJBBvtm6GeaZ80ZDWbCj+h83gPby/vV6QFiJZ0o22rSzzWWI0EJDR9vI3LVbPBxaGqKS/HqCNjdco3ZR3UUxVXsaq962w41PsoGlWEI8rqjfIV18L5Lwab90/h4unwpDFRKSG4/HnT94b04m42YrmAHGhiTdGOFYKWynRFcz46oodoaMzV1K3ANYUkNsbcD/F9xTfxEqpG2/g2NTTCILknJQ0ruTpvROIr8t98ZIvMD64IwgJ1nH3gzSZNLCSUCj9nCfRvHHGQB+sqk2zu4SrArTeq6e7Akj4FvpY0aDdChxht3GmmSy6LkXzcTqCO8LRLIJu+JKLaeCBWL8VDbh4RxEbsQNYCVg+7WVFjtTLCqA3OdcTNhcMNiNuqaSXDTOQjm7FC8knU9K5TJl35cKWdtLH0I0NhUy2V9fAsaOH35HFlDg85SG0pUOY/7w0TkMytPlWNkmosZdROSrIo3wXB2FeBIIkT9w6KTZ4bdVjGtpikB012qfIcHmvPMr3UXhDwuuKP0bMqEHjq98U+ug/H4caMpcm2jqPuIqQcAg3/dbqJkw+qkgXYhBMj2ouYSHu7DhzaWJnmmnta04xLE8dAZuDLvy2sjeaJi2OgHWoygJ6I3nLADlzi/13koxWFDVofGOQ3Sc/B0amfCCHtvRhExntjM+Rh6RWpHFz5wY7z/Y6BSs/LS0gF3rDWDza/apWIM3gLI6yhc5WMG1YzdIzZ1IsG6CucjC+LKISu4s7NeM+GuCm3da8SDDONLTTLnDP3H9OBniggHvCRoBkJwNBLrnn6UwcdA2PE4QqBqdUQLye3GEx9EKirczUY1wPq2i6Dm8rZ
 iE0USn1k
 ztkim9mnc3jgemJLD6e90+W3Cg9at5bOp/hK9vkRmDAz/39eVqa9RBysPwrZf5nUdV7yXIk6N7N3zbLSvBdCfqtjUVnHyARG204b4wa3g3KrHxJxhf/h2iddb+B1Xg2rk8LrPcB6ckY1IoOMeujVnWP8KUT9FlKtiaMI3Smt8Qt5iz6MLwBUvoQeJLaHXl7za4peYrckZod4aKPpkaKbu5mv4wNp8ZSvznmx7wFsd0E+v479mPGhBeShF1xsz/XjDNP40y70s8qUzYT/M+HwhpKZr/TjTkwgDwjiDfGyCL7Q0urq3zUaXiAmXU5SmynkbrbfKpvqgTMXFc78z6ptOfsina9nSI1jcfUa+Cq/tqULV3BNMdj0P9IiMoWBl3Xm1OaN7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:02:37PM +0100, Lorenzo Stoakes wrote:
> On Fri, May 08, 2026 at 02:27:37PM +0200, David Hildenbrand (Arm) wrote:
> > On 5/7/26 09:05, Chen Wandun wrote:
> > > madvise_collapse() computes the THP-aligned window:
> > >
> > >   hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  /* round up  */
> > >   hend   =  end   &  HPAGE_PMD_MASK                    /* round down */
> > >
> > > Previously this was done after kmalloc_obj(), so problem arose when
> > > the range contained no complete PMD-aligned window (hstart >= hend).
> > >
> > > When hstart > hend, (hend - hstart) wraps unsigned to a huge value, the
> > > final comparison fails and -EINVAL is returned instead of 0.  Consider
>
> I think both should return -EINVAL.

Correction: I changed my mind (see below), and think == should return 0 simply
for compatibility reasons. Though honestly both really should have been -EINVAL
from the start...

>
> > > two single-page calls on a 2 MiB-aligned address:
> > >
> > >     /* hstart == hend == aligned  ->  0 == 0  ->  returns 0 */
> > >     madvise(aligned, PAGE_SIZE, MADV_COLLAPSE);
>
> What's aligned? You're putting a random variable name in there? Presumably a PMD-aligned address?
>
> > >
> > >     /* hstart = aligned + 2MiB, hend = aligned
> > >      * (hend - hstart) wraps unsigned  ->  returns -EINVAL */
> > >     madvise(aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
> > >
> > > Both calls cover less than one THP and collapse nothing; both should
> > > return 0.
>
> Disagree.
>
> >
> > Okay, so we talk about a "userspace is being stupid" scenario.
>
> Yes!
>
> I feel that -EINVAL is correct for hend > hstart, and I think it might even be a
> userland A[BP]I break to change it (maybe somebody, somewhere is being foolish
> enough to use this to also validate input ranges).
>
> The weirdness is when hstart == hend being 0 but that's sort of established
> behaviour I guess.
>
> >
> > >
> > > In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() were all
> > > called before discovering there was nothing to do, only for the code
> > > to kfree() and return immediately after.
> >
> > Just a comment as you motivate here why this is suboptimal: we do not care about
> > a "userspace is being stupid" scenario being fast.
>
> Yes, in general - so what? The user is doing stupid things, so the user wins
> stupid prizes?
>
> >
> > >
> > > Fix both by computing hstart/hend after thp_vma_allowable_order() but
> > > before kmalloc_obj(), and returning 0 early when hstart >= hend.
> > >
> > > Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
> >
> > Fixes: is likely ok, but I don't think we want to treat this as a hotfix or CC
> > stable.
>
> I'm not sure I want a fixes here, this isn't really fixing anything. This isn't
> a bug afaik, it's just us not handling this brilliantly, but (possibly by
> mistake) getting the right output.
>
> >
> > > Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
>
> I put this patch through AI detection and it's telling me there's an 80% chance
> this whole thing is LLM-generated, which is making me grumpy.
>
> Can you confirm that this is, in fact, your own work? Plagiarism is not a nice
> thing to do, and THP doesn't need more traffic, we're overloaded as it is.
>
> > > ---
> > >  mm/khugepaged.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index b8452dbdb043..92473d93e837 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -2836,6 +2836,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> > >  	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
> > >  		return -EINVAL;
> > >
> > > +	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
> > > +	hend = end & HPAGE_PMD_MASK;
>
> See below re: conflict.
>
> > > +
> > > +	if (hstart >= hend)
> > > +		return 0;
>
> 	if (hstart > hend)
> 		return -EINVAL;
> 	/* For compatibility, users may rely on this. */
> 	if (hstart == hend)
> 		return 0;
>
> Is probably better.
>
> But I'm not sure what the point is if we're already doing this behaviour?
>
> > > +
> > >  	cc = kmalloc_obj(*cc);
> > >  	if (!cc)
> > >  		return -ENOMEM;
> > > @@ -2845,9 +2851,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> > >  	mmgrab(mm);
> > >  	lru_add_drain_all();
> > >
> > > -	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
> > > -	hend = end & HPAGE_PMD_MASK;
> > > -
> > >  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
> > >  		enum scan_result result = SCAN_FAIL;
> > >
> >
> > In general, LGTM, but see for conflict:
> > https://lore.kernel.org/all/20260409014323.2385982-1-ye.liu@linux.dev/
>
> Please use mm-unstable as a basis for your mm work Chen, this is something you
> need to fix, the patch above has been around for a while and is in
> mm-unstable.
>
> You have patches in mm already so you should know better by now.
>
> But I'm really not sure I'm in favour of this anyway. I'll defer to David but
> this feels useless to me.
>
> >
> >
> > --
> > Cheers,
> >
> > David
>
> Thanks, Lorenzo

