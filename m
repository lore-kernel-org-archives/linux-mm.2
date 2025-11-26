Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA58D111B3
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 22:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5825C6B000A; Wed, 26 Nov 2025 17:09:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B336B000C; Wed, 26 Nov 2025 17:09:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498526B000D; Wed, 26 Nov 2025 17:09:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2536B000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:09:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE3AEC0802
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 22:09:41 +0000 (UTC)
X-FDA: 84154150962.19.8A072B5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id E84378001B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 22:09:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WncFbwmP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764194980; a=rsa-sha256;
	cv=none;
	b=fw3zuiOqx/DE8gZQHPVGTZYGYUbqNtTWYvYSmDMhfMIrHS6Qss+j7VaXxWnJp7gCfVLARM
	v6pk/EGAN5jhMHenkupq3vCd16btuRysu7JyzRnIGc53ySWt7ZJ/W/gKOZsfxEdzgOvgEh
	IZIdn+zL0LxwcEOXVuCNEuO0XCgbH3o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WncFbwmP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764194980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hl+j2BAO9cBtKvv2hnloUPly/5umwXGDH5dKYNOgKLY=;
	b=4lcS8+FyxjaEYYcmVjlRaROEzeVq21mS1SJw0YX5rSVeqWzIA9L/pLQfEogrmOHFsZ7elK
	pJYzeYN0tDVAVaYrpfDqVUAT/hjEeECUquVa6bjVZYBLTiKlIyiFL4I9IpQwzISTchqaQa
	td/VaprNy1G8kKI0AVFgAg6OxB8ANtY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Hl+j2BAO9cBtKvv2hnloUPly/5umwXGDH5dKYNOgKLY=; b=WncFbwmP29izLihMB0J51yygEP
	Khd6BLOTTlWjdXMFAeggqEowRB+iqu7DQGIhfBW9ww724OiXFcFY1R1UuACJPT+CWW35oK4aEEaTk
	Py0I2F1JveoSxAGqza1l+nVCCi3rhNapkF/ysQtNcHmkbcVkWwfFCV8SduY3twNastJVFtCwDwI/W
	yfxDIYFeTOpJqrFwuTcidhUaAk2cNleY2+TL/DF6iawgKUnkZ21BoPT0gd61CVnNUBwY5Z+Nx9/z7
	6ko1tHTxarKU9yJHrayQcYQbyiwzcP3HtBdKxRZ/bU/WCeoc6CZEZlY2MauiAhHPp0y7EuAzOslGL
	qBpu5dEw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vONhg-0000000Anh0-1rhq;
	Wed, 26 Nov 2025 22:09:36 +0000
Date: Wed, 26 Nov 2025 22:09:36 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Message-ID: <aSd6oH29iELxxU5o@casper.infradead.org>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
 <d70b3309-348c-4aa9-9b62-33b8191955fe@lucifer.local>
 <aSdYkYYAuATwYqbD@casper.infradead.org>
 <d8c2a266-fb2c-4374-ab14-4ac910db7ad2@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8c2a266-fb2c-4374-ab14-4ac910db7ad2@lucifer.local>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E84378001B
X-Stat-Signature: tdpa8r8xkm7zxsey9ckfpu7seutjnrju
X-Rspam-User: 
X-HE-Tag: 1764194979-406158
X-HE-Meta: U2FsdGVkX1+VQj6ox+Guh15+fpMGPVjnqjxm6GMz89IAGTe5wBZ+YqulZF15Cp70FQT/y8WCuV8gfPQidtyO5zfrjxeDZbNmCjrNUuB4pAR/zDt0oT7iun5aWpUSoF54zJtB3FcpAECk7iVaTUpPVQj2n1+FzInf8auzjzYRAxLWx5H+cELcHouVYeiPBADcNtMQepy3APdYPai1i4V/kDy/Sapm0bNyaN2mP8nCgm0s434X8dcHn3UHpLN/t7YJpG+9OMHOg9kZiqxZSkVqhlhV5nBAq0/6G8KQj+g0IIedvIRLPELJfAif3fPdWpfKJkwhZU6ea89P3cimIuEdOCg7kq4dwewwY74+N6cxNgrMnoMLDS0ep/0To/B8afF4Q6N+nKnfpkggYQuPB3KeoEE9K+LABjdktfZZy5U+zKAhP+GFA/Itnwf0SUyRUY6MuSqi/q7YVCG3ID4yOMRrpqLfVMhNBnoVyVgWusImD0/zPIkzIXfE4+odes0M8HO3qF7iVBI6lvfJ4Jgg9oGgLxaiRA1XmFvWoCXMlEcjGRPQlwnzzmrZD4foOg4kDm3E8FkdspDQerHJykd2PKIHoV1tc4l37gxixzy5u1/GQlwO2qHZp8Iuc5xfKE0HP2q6eCkIKjVerFIK4HH1QhypCBLkH4s6X0HkoJvZL2S37ZwQwd74qL7BkoqGCC5NKM6AyErhl/DXxTBW9HhgSYmNFjfsywTmCucGIUGbX8I8KRAKMsrUuVa7dSIUBKeXnGIZkNjcPm5JhZ8dcFeyaioPFVWfIV60fULVwT1DiSGdXO6spivFFDutC2+Gawn7XvjtcgrdpznzSkmFeHU9aGJs9slVbrhHDnY+z2YBrhGdCfn4GNMFAarTl9aYbBiyQG96fbXm0jx9+wKYWE0D+xWWGhOAP1oM5CFmRwPQmin9wxOt8qxtgYFgLLO+qoFNrAmq4rxUQ1YaVTP8UAoB9Oc
 4rUTgjDQ
 gOrnWxe+yqGiSl6s3djXdCPntmOcRsTWwfq8P+TBXqBV5/V0VVdX4BhLEI/suOzOBCE8yd7zT/KYHSyHRRUsTwTcp67A4ANXKAjGXX3J5SWGqwU/9etd6GeLfyqa17vt6it1oIPh8EHAYGd/kDwMYurg9nARrqgpYrULXDo526iO64VCsA2eV0073p5HJprvRtbrp4QoOWtOIz8a/LlAwIpWctoQ1O0pG/tPGgIr/lYeFQ2CcE97w5KmbFmNOtcVGLYS/j3A1ZkWo6Fei5dpltJxOqwZYPybtlJj7Xg8ncjwPqUfmlRx2OVIdH4qeVhmJSOTTBPzvyxwFdN9OgI8pSCsd1DR92bsfeHS483HuCGLow5g9RRqu9qyCywVJullSFS1NMM8RHv4bMHViz7142LP9tw2bWFWCWUXU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 08:33:47PM +0000, Lorenzo Stoakes wrote:
> On Wed, Nov 26, 2025 at 07:44:17PM +0000, Matthew Wilcox wrote:
> > On Wed, Nov 26, 2025 at 06:55:52PM +0000, Lorenzo Stoakes wrote:
> > > > It's only "impossible" currently due to some fairly esoteric reasoning.
> > > > As far as _this_ function is concerned, it's entirely possible.
> > > > I don't want to leave this trap for the next person who calls
> > > > __vma_enter_locked(TASK_KILLABLE).
> > >
> > > Calls __vma_enter_locked(TASK_KILLABLE) _when detaching_, otherwise
> > > refcount will always be >0.
> > >
> > > So we're only looking at us changing vma_mark_detached() to use
> > > TASK_KILLABLE.
> > >
> > > As this is such a subtle corner case I still think it warrants a
> > > warning. Or at least a VM_WARN_ON_ONCE(1).
> > >
> > > A killable detacher is, as Vlasta points out, kind of an unwise thing to do
> > > anyway right?
> >
> > I missed where that was said?
> 
> "Yeah I guess it's for the best to keep vma_mark_detached() use the
> TASK_UNINTERRUPTIBLE variant, maybe document why. Aborting the detaching
> would be counter productive."
> 
> https://lore.kernel.org/all/058f5858-f508-40f8-adfe-e5de78621d64@suse.cz/

I'm not entirely clear on why aborting a detach is always a bad idea,
but that's part of the MM I don't really understand.

> - A fatal signal arose (assuming nobody ever goes and changes
>   rcuwait_wait_event() to add more errors - very likely, not entirely certain
>   though, so perhaps 'an error that meant we couldn't wait'.)

It actually doesn't matter why we got an error.  We got an error.
But also the last reader went away.  So we're now in a state where we
would not have needed to sleep had we got here half a nanosecond later
than we did.

> Since you're concerned about the urgency, let me suggest a compromise:
> 
> 	/*
> 	 * We tried waiting on readers, but failed, likely due to a fatal
>          * signal arising. Unlock the VMA and check whether the VMA is
> 	 * detached.
> 	 */

I think the 'if (err)' is enough to tell the reader that we failed!

> 	if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> 		/*
> 		 * If the VMA is now detached which means we lost a race.
> 		 * Let the caller know the VMA is detached.
> 		 */
> 		err = 0;
> 	}
> 
> That gives a _lot_ more information, keeps it relatively top-level, doesn't
> make undue assumptions etc.

Here's what I now have:

        if (err) {
                if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
                        /*
                         * The wait failed, but the last reader went away
                         * as well.  Tell the caller the VMA is detached.
                         */
                        WARN_ON_ONCE(!detaching);
                        err = 0;
                }

> > Are you satisfied with the WARN_ON(!detaching)?
> >
> 
> It'd be super weird to reach that code when not detaching so sure, think it
> should be VM_WARN_ON() though since the code would be horribly broken if
> that was not the case already no?

The other places in this file are WARN_ON_ONCE rather than VM_WARN*, so
keep it consistent.

