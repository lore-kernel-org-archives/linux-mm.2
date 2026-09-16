Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92137C982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95F546B0093; Wed, 16 Sep 2026 10:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936C36B0095; Wed, 16 Sep 2026 10:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C026B0096; Wed, 16 Sep 2026 10:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6380E6B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:13:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98454C0754
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:13:01 +0000 (UTC)
X-FDA: 85219816962.20.D028D8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0583B40004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:12:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNbqf9U+;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789567980;
	b=gyxctFgH6Yqv6Lr3evekuvZclEIT7x5fwqn8mwiruPtlhpnUXfx3TyoDd9wOgr9KHaIqbt
	PMIAdGLZAA5G4s6eA3a8uMUyjY9dw6Tm5yqJXjddgl0Vcnoa3tgG/kxmjNItaYVzTcQoEw
	F/zPk7/7WQVHU/TzLomTKEIifDlINns=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNbqf9U+;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789567980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9BvKqoMA2UwcJ0p6bue8Tv/N7Zz0zZu76H109sCcw0=;
	b=8Jf7w0Si/lWdx/Og4MbqsuOP6AJXitYlRt3ijIo28S7aOcX3aTOsO5KKwdR5VXGvb2fRXH
	6ADWh8q8lU6MX/UEgezKWKmUFg7DN8lEpZZ0M4p5jxa8lYQwoMWrZQN2zS7H4qdX5PRIor
	AQ5EaSznshdq7atdujPrtsQE3Xvuyic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96D4560234;
	Wed, 16 Sep 2026 14:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222021F000FF;
	Wed, 16 Sep 2026 14:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789567979;
	bh=V9BvKqoMA2UwcJ0p6bue8Tv/N7Zz0zZu76H109sCcw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BNbqf9U+xd8eNMek3w+m7W2aF6pGr2mM9pbehi4DYkeN5VFbz4RQIYK8fUqx2s2sE
	 G9twMG102Bf+0PhP/gvNWqXQ0aumAMk0RA3b4IPVBZhpVgpJdAWis5SDpuHjKq9gt3
	 4OR9r793/aLxM5Fkixycul6E3yfKLZ1Iq9hVvBX+ejNZklHC4GfyXT3Gdv1G5JtCa2
	 oHZcSzM2RxqDxKSGhX1hSWGhQt2oPBqoiS87ylpDSOOkj5qSu56zo5eK+j88BdWWzv
	 fKN3+qtZ9bpaE/ruSk1gKdvfHlLSmO7GzLw67qHtoioFaqVkE7uLExXCEld0Bp8xFD
	 6hd1xpAE9km1w==
Date: Wed, 16 Sep 2026 15:12:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqqjW5dpyznijYLh@gremlin>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
 <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
 <aqqTbGMJL86TzDrf@gremlin>
 <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0583B40004
X-Stat-Signature: t1k47swf1oganyjqwsmpzui4z3hebqmr
X-HE-Tag: 1789567979-953093
X-HE-Meta: U2FsdGVkX18MgziY3dkuZ2xbcfY8MmnXqwASm6aSqfy5rSVLTBp6uS+oikY3KXeVDxn/9SoQwt+owOtPZlrcKpqhJxJKxpdmAG30BupjvQ6x5/5n8C7o+zvgZLSwYUYzB2nF5lBdl8EVX5IZOf+eL7WM92Kk97oIsQeASihrTT/d4Jr6Bd7zrhRT74txqJ5paKMtTEcmuXzxr19ZXgqRxmphyE+54SXYMUC4mMWgJb6IBIYsYgSwk90/VchOPIGN018XqgzkClO58aDQpJFYNIj3xuH4O1BvUHqX4K+suMvJOsfUTnb17LAZZ4rBwSCKuU7hpnYfxy4gViFjDtPy9r4NIdN8OR05hqyS2UrIdWA8L1LR21xKvoBMB4RcMToEDKFQAtDHRep2MYb6UF5PM3bnO+zBSpLaUPwNR5qNahrHxdHzXoVNPiGvumP/Q55DkTtjEagJaIjKMQsIAG5B6J0PK8x9MjSIkSAKAW7wp6w4+YCuzBHKy2ndHv+0al5sibReokjupVWHflMQpthcKvUX2Wbg81NOR6L1TYpXDsZMXb1UYIqM0l1JD0h9Iuzg3qKo/7J6M9VfVksfQJIHbIgixIGu6RA9vq8Zg7PdSnG5ksbidVaFDlNCytXpkc/rkb14B6mQq7zVCRCs3ji6Xpjg20HhEX1m7Y9lJOTNvV1Q4sS62eX+AEsNpsGS1pY/fX3RBwm+4A+TiHUbuQ2QqYLTFsc6ngsIUCWVBnVvbTqXUSPD3+NGWhZhHHE+uQ665W1Zl/E/9QCLIsErXlSVcn6onYQZY8BjJUA1gxfpMi4uA9uHYzRwzNGTu0YwlLfxw50YMOXNy+OFZHTqAJ+Jqlsnw8EY8yp5AHkGJL6bQc1IZuwVZnwI2J4Iuy1w0uUmrM3TwXOfuZJ0HUDS9AKY8l+Rt78jxQ/+mhyMI5lmLnNTjgKALDM328UKDW/9QsXrEEjo+DaU/vw1zrMqlIy
 pCsJ7RF7
 aeA+FruvVC/919nPKO5Ir3Y+0e81marRME6n/oKqeo6KkFT+uMZhO5b0xsaYIfeI+tfldLG79XdgQw7rx7KYavqyp55cyR8FzOpiXWRPJlLHr2QlZH9/TC9jRVZV3btU6Lw9PgZ3Z8S7QF+SHxgvHZnnTcEBQRK3yC7Co9Cu3YLoaFHpSiCuJWoCPq315duqPUbKhdgFiJ4J3GYSGGgKlbznVoSyY/nrI+4LVMsdmhMwFJ268GKUgtXkIP2gm3Exi+HhoImP7gBm+guAv3Jy65TvZpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 09:57:44AM -0400, Gregory Price wrote:
> On Wed, Sep 16, 2026 at 02:03:29PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Sep 15, 2026 at 01:12:03PM -0400, Gregory Price wrote:
> > > On Tue, Sep 15, 2026 at 04:55:47PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > On Sat, Sep 12, 2026 at 07:08:32AM -0400, Gregory Price wrote:
> > > > > MADV_PAGEOUT collects isolated folios on a local list before reclaiming
> > > > > them after the PTE walk.  The reschedule path drops the PTE lock and then
> > > > > restarts the mapping with pte_offset_map_lock().
> > > >
> > > > Is this reschedule path even necessary? It's pretty bloody sketchy.
> > > >
> > > > I thought the modern approach (TM) was to not do cond_resched() and friends so
> > > > can we actually look at removing this?
> > > >
> > >
> > > Sorry - meant to reply to this.
> > >
> > > Honestly there's so much jammed into this function i can't give you a
> > > straight answer. I can take a short detour to figure out if we can
> > > rework this as a whole.
> >
> > s/short detour/long journey through hell/ perhaps? :P ;)
> >
>
> Not as much as you'd think.
>
> I did it yesterday and left an agent to validate it overnight with
> existing in-tree tests, LTP tests, and added some new tests.
>
> The naming could use some work (cold_or_pageout -> lru_op, bleh),
> but new call graph / pseudo-code:
>
> • walk_page_range_vma()
>   └── madvise_lru_op_pmd()              [PMD callback]
>       │
>       ├── PMD is a huge mapping
>       │   └── madvise_lru_op_huge_pmd()
>       │       ├── acquire PMD lock
>       │       ├── madvise_lru_op_huge_pmd_locked()
>       │       │   ├── process whole folio, or
>       │       │   └── return locked+referenced split candidate
>       │       ├── release PMD lock
>       │       └── split folio / reclaim isolated folios
>       │
>       └── PMD points to a PTE table
>           └── madvise_lru_op_ptes()
>               ├── map PTE table and acquire PTL
>               ├── madvise_lru_op_pte_range_locked()
>               │   └── madvise_lru_op_pte_batch_locked()
>               │       ├── process one folio/PTE batch, or
>               │       └── return locked+referenced split candidate
>               ├── leave lazy-MMU mode
>               ├── unmap PTE table and release PTL
>               ├── split candidate if necessary
>               ├── reclaim isolated folios
>               └── reschedule and restart from current address if necessary
>
> Looks like a normal table walk now.  Significantly easier to review and
> doesn't make my eyes vomit. (there's still an ifdef wart, but it's not
> mid-function anymore... so that's nice).

OK nice, I will have to see the code to comment intelligently though I
think :)

>
> Going to spend a little more time testing and tweaking before I post it.
>
> I've been working on a making more extensive unit tests for certain
> parts of mm/ and this might be a good time to look at whether I can
> introduce a piece of it.

Nice, curious as to how?

Have you tried the userland VMA tests btw? Not tooting my own horn so to
speak :P but it's nice, though it comes at a bit of a cost in how the files
have to be set up...

I always feel like I should do more with it but don't have the time
atm. May set the LLM on it though...

>
> ~Gregory

--
Cheers, Lorenzo

