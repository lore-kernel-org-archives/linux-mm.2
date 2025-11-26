Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43ACCD11193
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 19:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87D176B00AE; Wed, 26 Nov 2025 14:44:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D8A6B00AF; Wed, 26 Nov 2025 14:44:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A7E6B00B1; Wed, 26 Nov 2025 14:44:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65AA36B00AE
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:44:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D81B213BACE
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:44:21 +0000 (UTC)
X-FDA: 84153784722.22.81AF812
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 46E1B1C0007
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:44:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Xu3w3RHg;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764186260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VELtu4C0F1KhilDJiGLLAACsIi66LgICbaVlCLrYVXA=;
	b=YMIF73cnarg4J3VfOFUvAJ3yMNewoRPZ6z8JzQkrhW5u8LIhg34RN1SFtyhJGcWyOLk7zj
	RDbRJoQx+lyhI/brwi7QQOyOu0sPJoRqGzMqu93+ax2ydC3MnWPHn1RzkLH/Cs09PvQKjI
	cJxTFBRMjO324nBlJZPQl1H9FqUcei8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Xu3w3RHg;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764186260; a=rsa-sha256;
	cv=none;
	b=Y4qPrkU01DL55mjTq/sb7n3GFiEg35fp0F+7Gc820lgAmWtL2tlkvE6K8WmnRwgUHpzg04
	5Ew3aMfbWbQarQlGa00sUu3LVFiPPpEfxv8Wm3eXbdk5+EUKl+LdkhzzGoDNmGroPSCyTL
	bv2c0lLIBGjrYg3aYkYB1TGutlfMa2w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VELtu4C0F1KhilDJiGLLAACsIi66LgICbaVlCLrYVXA=; b=Xu3w3RHgsMWbcfVv7rOfxjuZNj
	n2yIxYyJlHPIxnXFMCD7IoPgvTaitYEKrvltHzI9NogBvdpTQgw3z3LbkWFx0EqhRWnkeNFw8D+J3
	pOtqqo5znvPTbr2tR6K24x+fSuplEkIrRGlJZM5xoAA3JmmlUHegH8a3HyrXUd95iQBqYoDNUMWA3
	1m0odEKitVZKTCRBqY1fWb0rjjyblHHNIdVOkToOxy7p3ik51HPm60gZalAVLjRM2/Si3piXfXXoT
	FKxB1FQ3C84iCDaQ/L9uDKz8FLYda22tOrFeFuvwgLybNHgFVO62Guju4FmMuhpQy/Q4oC0cRSP41
	aD2+BXJQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOLR3-0000000AcsI-25qe;
	Wed, 26 Nov 2025 19:44:17 +0000
Date: Wed, 26 Nov 2025 19:44:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Message-ID: <aSdYkYYAuATwYqbD@casper.infradead.org>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
 <d70b3309-348c-4aa9-9b62-33b8191955fe@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d70b3309-348c-4aa9-9b62-33b8191955fe@lucifer.local>
X-Stat-Signature: 8r8x9xoxzhox7kdou3cu86k1smtukiwc
X-Rspam-User: 
X-Rspamd-Queue-Id: 46E1B1C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1764186260-342120
X-HE-Meta: U2FsdGVkX1+3f61a5uY6BuUKx6Kr+Rs2KNCecO20ygq+RjKLR5S/vu4ABre5QolJIKuenxgyxhcmgaSKIX1JUp8zc1t3a+wTy3KQ8TWLfcEzSI4WU9CTBTm0Tw4vqL1OGW1HfHWsJYgS35q3y1Q9n0WN1uthI2b6/MHIBmAC3pCnupDe/Q9QSWGBGHSw0hdjHy5D8NDz1PojqahhgjzpLBV2iM9ZjKxvAbnT93XbcQrvKgEKGIKNsP0tZmQYwWu++ATKimNNkcp2ILPMHscWSVfS9wWeyqpDT983dwMQYJyxNGY1bhE1oks1l2SvsTMAv2hFbvmvYMJ8PhelmS5mlvxAH6PiA6su9sPJvBmxmQsmbjpmj6K683HH16HlMf8L2Kg0ExLeDq2HySPBd3mxyPE/jTIR0VckrAaBi39d3+AswlCTzFf5feLJMpaXK0cbMBcfplv0V2OQaK+It5UBnivZN5SlfnPfgF95IzvPDhBW8G04OjSuavNYEo4MrhdArQfDHqDSgxBEbQZCbQwElJ1mHGv0qbl//435UxNBpTqxRk5rN7fEefYepcE8i2XnamNYp0c/D5AcmShbm4/2u7v/9DpeJhLgT2RoV0rep8gzmgQ7xhLEjPop1W9ipMnq8dSu1vCdMYnrGYdnwMx4EkA6S6Wr3l/PN7LhgQa19yFd2aeabUGkDEH2Su5iI6UqVWPBKK+XX98Q749SJ7+xRuyChnLwiMpCfQfYWNyg8kmb+rHqOIzUNhyYjl5HLnV9D4kwm2AJGc4bw6zbEyKwuvw4I78slVxVw2sd4R8I/YbYsrzMvMf+y0a5d6zzcH6xDpSqRyBniQmli01YZncGrLL0Zz3cbeyIKVlstG1KWiqcpTvGEjKrEdUWcRejgZ54tOpV7ZUdBohnRPEVKnAqOMRMj1Zu9xm8zlAVpGBLrAc6xNuPpRYSSUfB3Nqkt6jSDSK7yHMmZECB5xG1cGT
 5K9W4+Hd
 2U1OQCqWVSaHep3vio9Ck7/Wn+E18OwvuYcqwQkbYMva1tiy8sAWwB/+/lGz31iH9w4lPQMzRExEUUN0Rgn82ed6D1OkSIeJjVJG2Gz6Q4tBSeCg2bK5ML6nA+R4uR/HVyAmyVtDgpb6JF55VBeAsnlE+AS7HHb8AV0msubHUnBGK3Vg2kaPDO5aQ6XpmSNisrf6PcY69RzW06sr931nvohwfSP22kDsuhjTEoFHrbKjOnmUJ19r1iOBfdomEO3jcBlh52wZClnBr8qHrhfkhcY3Vb8dJnfL95E99WQm32EL5h24p4rxiQVBQqjAr9clwOCepz/k6joubIZ43gAbaCPD9Tt22U3UkMwW8tc1uQ/ZjOZxr7zkUcdULVZujj4osqO6M/zjAwI4WgbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 06:55:52PM +0000, Lorenzo Stoakes wrote:
> > It's only "impossible" currently due to some fairly esoteric reasoning.
> > As far as _this_ function is concerned, it's entirely possible.
> > I don't want to leave this trap for the next person who calls
> > __vma_enter_locked(TASK_KILLABLE).
> 
> Calls __vma_enter_locked(TASK_KILLABLE) _when detaching_, otherwise
> refcount will always be >0.
> 
> So we're only looking at us changing vma_mark_detached() to use
> TASK_KILLABLE.
> 
> As this is such a subtle corner case I still think it warrants a
> warning. Or at least a VM_WARN_ON_ONCE(1).
> 
> A killable detacher is, as Vlasta points out, kind of an unwise thing to do
> anyway right?

I missed where that was said?

> >
> > > > +			/*
> > > > +			 * We got a fatal signal, but the last reader went
> > > > +			 * away as well.  Resolve the race in favour of
> > >
> > > This is very subtle, I don't think this really explains this clearly
> > > enough.
> > >
> > > Maybe put something like:
> > >
> > > 	/* Couldn't wait on readers probably due to a fatal signal, so unlock. */
> > >
> > > Before the refcount_sub_and_test()
> >
> > I think this falls into the "saying what you're doing, not why
> > you're doing it" trap.  Whereas my comment is at a higher level --
> > there's a race where both exit conditions are true at the same time.
> > The rcuwait_wait_event() picked one option, but we would rather resolve
> > the race in the opposite direction.
> 
> I find your comment unclear, and I think it's too succinct. I was trying to
> provide the most succinct-yet-still-clear example, but if you prefer higher
> level you're going to need more detail here.
> 
> It assumes you 'just know' that:
> 
> - refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt) means unlock

Actually, I don't know that.  All I know is local to this function --
that's the value we added earlier before waiting; now we need to
subtract it since we're no longer waiting.

> - err can only be set due to a fatal signal in a non-uninterruptible task
>   mode

The comment says that in the first five words!

> - spurious readers can cause an incremented reference count

I don't know what a "spurious reader" is.  There was a reader when we
started waiting.  Now there isn't one.

> - that a race can exist between a spuriously raised reference count and the
>   previous reference count check between read above and refcount subtract here
> 
> - a reference count of 0 means detached
> 
> - err = 0 means we are treating this VMA as detached resolving this race
>   'in favour of' the VMA being detached.
> 
> Let's get some of this information in here please.

I don't think that here is the place to document these things!  And
certainly not in a patch that we're trying to get applied five days
before the merge window opens.  There's plenty of time to get the
comments and the variable names sorted out; can we focus on the right
way to fix this bug?

> Again I think we'd be better off with at least a VM_WARN_ON_ONCE() given
> this is a rather obscure corner case.

Are you satisfied with the WARN_ON(!detaching)?

