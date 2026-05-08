Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70DD4CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6C956B0175; Fri,  8 May 2026 11:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44686B0177; Fri,  8 May 2026 11:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81886B0178; Fri,  8 May 2026 11:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B60A66B0175
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:02:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75A67A015C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:02:41 +0000 (UTC)
X-FDA: 84744569322.02.AE746BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B158D4000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:02:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b9HrlB1T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778252559; a=rsa-sha256;
	cv=none;
	b=LQTAWTwsiztZWpw2ko2neTSm+YXzWkiOH/y/WcCzriZDusY5b97mtkNkz945aRjfsRK5Yj
	Z/C95y3StXbsFE4qmWsSRwPbYNOmhIHQEwPBDt6wdolAo+fLijb0siyZq/zh6xqOC5c6ro
	wNoKTUwuhY0mPP6YuVSvEpGH8C9ET3o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b9HrlB1T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778252559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALZbSxEXAWvdudgGelHzqEY5m5ImEqHSiIuWbBYOeio=;
	b=ZAhbqm4V/23H1dsXWpLTUywCMYlkpyPx6oYCwszePS2fjKvDfCkJ9X9zUSm9noNBPTwtp2
	Va/8GawsqwPj8ovsGce7Z2ekSzbtTP4UUx5iw+4cywVifUrkbJ2vmeCT2osKIxQ5uUjOYj
	xGYbKUho62J4UVMqLYyrvcOvFZZm0ZM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A59E40514;
	Fri,  8 May 2026 15:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CCEC2BCB0;
	Fri,  8 May 2026 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778252558;
	bh=mphj7q9xvUeukrTjcJQdbgg/bdUNv7wggxgvnM+pxdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b9HrlB1TqPvXiGkKX53Q3c2fpsAAZUB9kEoCE1eVZjUykNyeQyTRSKw24cSGC1i53
	 skXSYIGQ0jQs7UdRBRHE3qAhKgWOGHWjtc37Z4u5Lx69Dg05MDoVkOeoT3FBwKb6Fz
	 YsHUseM6F1BmTUCSWLmaWWd0lHZ0xIyTOz+GQpDysIILxeiwcGSdVVWm/XCz9egBil
	 RtZNJkAd47UMLZuEI22XoZOSjj5Ovty3Xvaw2IyOe81Vk8Oy3AK4EhkTRbikSejZgO
	 +mxEtJ+mi3iqBrw/2dfQVX/dtSCJVcfQXkiHmUGOne+NdMxnfV9rJcsrN9T6YmYBKf
	 WwCQNI/z+Q/Bw==
Date: Fri, 8 May 2026 16:02:31 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Chen Wandun <chenwandun1@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, shuah@kernel.org, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/khugepaged: fix spurious -EINVAL from sub-PMD
 MADV_COLLAPSE range
Message-ID: <af30otSSGbPxHbxM@lucifer>
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
 <20260507070558.3064142-2-chenwandun@lixiang.com>
 <9eea2afb-8c35-47eb-b1de-6a08503c9679@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9eea2afb-8c35-47eb-b1de-6a08503c9679@kernel.org>
X-Stat-Signature: 7xahf9nrx4asg1hd5o4yrtfgzwqeb7p6
X-Rspam-User: 
X-Rspamd-Queue-Id: B158D4000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778252559-223236
X-HE-Meta: U2FsdGVkX1/acQCNK9hhlRUJdwCYic8t87tsCLXmbb4V5soHPjIHnOxAWovEwQx+pdHafTNZ7SDgzJHqEUfkfupEYll+ina6m+BnhcWhQIRfDPX7r3wDt0XMI4yljN9mIrXEj1GPALPPXK38PYno1AkAT39zhX4J/cyEtfcgnprWP/0fYmwSCi5OrvfpDUTBPzgJ+8T59+7XTi4WUPyU5ztWkkVReFtRhLGKypwROVfles6JAoOjL3zsO1Jy7gjE6gbFQNg4IQaBw2baCiHnUJzC9ZmJP/utFrJ1MCgbrix3fbA1xSKK+g3jEkIITq/l4EdKKb3uduHYqEMV8voOD25TpAxAM8g9M1qiTMx05+srP/CMk2jRbPI4j7xAqE2LObm3YdktGpKYThkRQl+lZwmDKLg7aBsJQzglrcTlrBu6YHRr9TzvOQLLJudENVCVZHygx1aEfc4yFv/x9tNe/9N4OYAK9SL3B4QEAplgM+xeWqERJfo8sPumnQrrU5gCO7ivV2EuXZTO0O0pDQEGl0dyDQmhKw1OhRx4S6nN3p33bEuuu3Rpq4UW2tkFiPofqGHVfF3dPa+fa9cSJJz+qCUXnAM0Tr4fBbR5qNpRvMZN3vdVAymw20qlPc3ez4SaigDjPwkYwP0vrZ/DRTJOkC3yagp8gGg9GC0GlzIV2lYGlRMkLysRHeWJTUoDWr1vZMuiwEBlbUhm78spJsCK3duNbb/VvTFrOuMjEqzCrSdmKb5400BqnuIJ3aqfvkx6vagQ9GruJpT/YHGX7kpx4RtD47EoTYTpo6okq4Iwm9xsZFyMTz2DuwQwN+2+LdK+mNYRrY1VxcriPzI0TPeduu2Zx6+YpxY0KGstrPU6PQYmqgEkAFwvsVK9M4NHW9f0QaphuW38+4RLsFQP81i4OHwNMKnqNpq233W7PiLMFKtc/lzOFq7KLpniCqfwNwXX0m7c5/utMoVr4cYTBc7
 Ia/VrXRl
 JN/Q+ws1cbE7C7EXuZ2uTh6QL27HrkdqmkbGluyN6IrJPlDlRZ15TfAIco41aSLZOQf4+Q0+o6F4kiOuL2p2JnD1fCRvoCtA1szHbQb/JXVIRuVeSWSCnOjEw2g7okzXgVUW/B16VkRxCOuJfYjSgJJfeXCr5NTM3A69fP5FMzFdNyXkLnn0e7I2UjpG04xcn4U7cAlYyonCmfB1oqlNlIqrobPddJuBzhJy3MQNCl0V7jkNqkpJpWgmejOznyIpfAsFa4p02TsOTxsTIuVjaQ6QpAs2c2A8Ek+hzWdZ3uaMiwwf0FzMCQ0dRzOmiQaia1V2Qhx9R9Kf/p1ZlWlk1Rnx79Lj1riJkTRFjiBlweyCkS6r5JyQnzQG5bRseu17cvNIc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 02:27:37PM +0200, David Hildenbrand (Arm) wrote:
> On 5/7/26 09:05, Chen Wandun wrote:
> > madvise_collapse() computes the THP-aligned window:
> >
> >   hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  /* round up  */
> >   hend   =  end   &  HPAGE_PMD_MASK                    /* round down */
> >
> > Previously this was done after kmalloc_obj(), so problem arose when
> > the range contained no complete PMD-aligned window (hstart >= hend).
> >
> > When hstart > hend, (hend - hstart) wraps unsigned to a huge value, the
> > final comparison fails and -EINVAL is returned instead of 0.  Consider

I think both should return -EINVAL.

> > two single-page calls on a 2 MiB-aligned address:
> >
> >     /* hstart == hend == aligned  ->  0 == 0  ->  returns 0 */
> >     madvise(aligned, PAGE_SIZE, MADV_COLLAPSE);

What's aligned? You're putting a random variable name in there? Presumably a PMD-aligned address?

> >
> >     /* hstart = aligned + 2MiB, hend = aligned
> >      * (hend - hstart) wraps unsigned  ->  returns -EINVAL */
> >     madvise(aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
> >
> > Both calls cover less than one THP and collapse nothing; both should
> > return 0.

Disagree.

>
> Okay, so we talk about a "userspace is being stupid" scenario.

Yes!

I feel that -EINVAL is correct for hend > hstart, and I think it might even be a
userland A[BP]I break to change it (maybe somebody, somewhere is being foolish
enough to use this to also validate input ranges).

The weirdness is when hstart == hend being 0 but that's sort of established
behaviour I guess.

>
> >
> > In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() were all
> > called before discovering there was nothing to do, only for the code
> > to kfree() and return immediately after.
>
> Just a comment as you motivate here why this is suboptimal: we do not care about
> a "userspace is being stupid" scenario being fast.

Yes, in general - so what? The user is doing stupid things, so the user wins
stupid prizes?

>
> >
> > Fix both by computing hstart/hend after thp_vma_allowable_order() but
> > before kmalloc_obj(), and returning 0 early when hstart >= hend.
> >
> > Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
>
> Fixes: is likely ok, but I don't think we want to treat this as a hotfix or CC
> stable.

I'm not sure I want a fixes here, this isn't really fixing anything. This isn't
a bug afaik, it's just us not handling this brilliantly, but (possibly by
mistake) getting the right output.

>
> > Signed-off-by: Chen Wandun <chenwandun@lixiang.com>

I put this patch through AI detection and it's telling me there's an 80% chance
this whole thing is LLM-generated, which is making me grumpy.

Can you confirm that this is, in fact, your own work? Plagiarism is not a nice
thing to do, and THP doesn't need more traffic, we're overloaded as it is.

> > ---
> >  mm/khugepaged.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index b8452dbdb043..92473d93e837 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2836,6 +2836,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >  	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
> >  		return -EINVAL;
> >
> > +	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
> > +	hend = end & HPAGE_PMD_MASK;

See below re: conflict.

> > +
> > +	if (hstart >= hend)
> > +		return 0;

	if (hstart > hend)
		return -EINVAL;
	/* For compatibility, users may rely on this. */
	if (hstart == hend)
		return 0;

Is probably better.

But I'm not sure what the point is if we're already doing this behaviour?

> > +
> >  	cc = kmalloc_obj(*cc);
> >  	if (!cc)
> >  		return -ENOMEM;
> > @@ -2845,9 +2851,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >  	mmgrab(mm);
> >  	lru_add_drain_all();
> >
> > -	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
> > -	hend = end & HPAGE_PMD_MASK;
> > -
> >  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
> >  		enum scan_result result = SCAN_FAIL;
> >
>
> In general, LGTM, but see for conflict:
> https://lore.kernel.org/all/20260409014323.2385982-1-ye.liu@linux.dev/

Please use mm-unstable as a basis for your mm work Chen, this is something you
need to fix, the patch above has been around for a while and is in
mm-unstable.

You have patches in mm already so you should know better by now.

But I'm really not sure I'm in favour of this anyway. I'll defer to David but
this feels useless to me.

>
>
> --
> Cheers,
>
> David

Thanks, Lorenzo

