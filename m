Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 190A6108B8F3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6627B6B0005; Fri, 20 Mar 2026 06:51:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639376B0088; Fri, 20 Mar 2026 06:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576E06B0089; Fri, 20 Mar 2026 06:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48BB16B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:51:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A061086C87
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:51:48 +0000 (UTC)
X-FDA: 84566125896.13.1BE4DE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 209D7C0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:51:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h8lWr5Ch;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774003907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYUKOviUAwxwVwJXFL0uEJPMIB7vmMt8Hnpel4cyYoE=;
	b=lRP2V/hNd8bz3EXfgiWMLhYeSxdSk6mBjQY9N7jYlOZOjyT+yWnOTYfQBBxiqIhre9ies5
	RmNfkhdEySA2PnM+GD+oI5na73WavNqEyJ1EJOsFx61DTmGIQu9s8REzj4vrBLRFbxwTCw
	IJslVHEMpwsOyZrLpZO6v/aLJmLsTRw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774003907; a=rsa-sha256;
	cv=none;
	b=x5QN+b7m6eYkG+rpbmwxCNYXAfDcvm4yNKAE5Xkc3wOyA9crNhon9BK/RIH+y+jnjdXjaF
	GcxdSAc2RmgtADNmU+OFi2knwW/3MMCk41+r3ULg/2NMgwjkj3CddcsZ7iX35l2yrtBuvn
	tdH9/xNuR2qU45foOohZSKJnknZR3+o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h8lWr5Ch;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BF6460128;
	Fri, 20 Mar 2026 10:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3749C4CEF7;
	Fri, 20 Mar 2026 10:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774003906;
	bh=7vr5UCGBLAFQx6Nj85JgEeI98P0uanuFdK4bKUPwZR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h8lWr5ChFPmAdcamFIizKT1g4UA9F8E70hxGxe3BVFImPsEpE/V3S43JVaLua0v0n
	 KriXvZ0I5qKDX0jCtWMhgka+0v0v/g2xQHuTgnQt26kcLWFdQFjnaScxeAt8eTf/V9
	 Y4/J1gKRCTfKivMBl8VdkhZlSuOaH8owd/QmUidKWR/oh0W53VS6RDF/AtCIFoKdAN
	 KxecO+4sCMnMCrXDoiK/mM6tebYUPQbLFBmtw4uPZShbPysLr5wVsbZg1rL5br33kF
	 1IyXBhgXEKrfA2220AKsdbXVkDD17sNQEvKEJtYBv+GH+RCROx6XUo0qss9b0yYVjN
	 xEkBT1ldyvkLA==
Date: Fri, 20 Mar 2026 10:51:41 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
Message-ID: <9c5a3f7c-089c-4609-9577-cc111652b9f1@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
 <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
 <7rr3jgdcjiizwzfivhrcqdacq5bt6hschv2isnfsmrqpuhr4c7@vbmtp5qtbs7x>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7rr3jgdcjiizwzfivhrcqdacq5bt6hschv2isnfsmrqpuhr4c7@vbmtp5qtbs7x>
X-Stat-Signature: ohnrf8nfghw3puzy7gskymejdw6metmy
X-Rspam-User: 
X-Rspamd-Queue-Id: 209D7C0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1774003906-361073
X-HE-Meta: U2FsdGVkX1/GWpD5r+amN8wP/HYpQPQ50xifYI/SzM9iFt9Yi07RVnzmqXKl3HEGcc6z2e4FCZaoBvpQj7RWTYAmtsoU+lIj0N9XqbnAuaH2Jpr5mq1G6udWdVczoXAkHSoUygHpVcjt0m+kRfofwlvJK6P3Xp4fF4EZHbZxHKl4euyDWE3kfzQ+KKSl/wmB3aERazV+PQJ3wejo/jZ5iR2FfI+LxTGTvclU6ruLSThFC+LAL9EZtt4VCb5qCjbjvonLDM6WCLL68BgPZlMQgPJGHBInZ9KOpaK+FwM0GRh3l3bN936+k+ONv9wbS1bhVulmPThBhg0SDK0NsBydRS3L5bJlun5YzgBAWM1I4zOSPQhHcMGN6SJ5DZvZSOSu6LndDQyMZp7bmCpy+m9lBpfltpN2cQ347bS0dVDDqnftRXcc57ogg3L4xscvBxzsuNM9+w+w/3BwJ1RiswLyb2Y3G9Y2KXYAVoOp1y8fPnBbFWTlVbBp+T3USMpAykw5NYwFO0Iq0YgxJtJbC7Gb13rRC4ZR6XXSwy8ZCdzfiEB9aB8+mOT0Cam/mB8I9KeR9w9po0UO7KBLsr42vWpn5TZN/6SlBI/mD6Mhv4Ksiezfjzxd+j44gsxG7lp+/lEuK+9K2TBunHL7e1PhtV3IE2oe9/xQhLZ0ymsOp46yfSZHf19zIqugy+WsoFjyjLKOioa8deVRMZT8HaXJeWi0g0bHcyRYIFFYnGdu+CquZtmsHHktP6Yh4a4j62aEx4dPiP1UTchodj5fGfgHJ7hnTBWXsQwr0zCossZsEX6Y2Qm4LuUVlei44NvRtY+f9iVEfEdSqzSireTUeNXwYBA7/7ml5Ie03fcL4uAi3EJBHJbqGqykfiTnXeQY2C5aWri+jYEmSOnncnHPY+u0nBHKWtvjvxgLKRnflL7fL+b5Q0pTGFO7A33fSx93MByWjTTX75AUt1RIKzhqanjCBph
 JI5PS1XD
 bf2h/1OV5WajJDFax7i+wxwe/wTvFfF7we9d7DlFmGF8j8mGjS959JrgGGToEU9TDjo3SGaHXY8vjCeiYMZokquluCFRgIUwFFhhRa+uE4k9FvNpHMvvD+IwoiyM3VBP0BQ737aVRO0JSfJrbNMWsh4kIW1E/gf0aNeVuhNqkCPIhxu3X0q989Pxx6JRTsPFM0xWC3e66/vvvZLHvXVqO4u+kpzAJiqe38xQACqPxDcfFSODLK83HMeOOnBqJpENpZa/r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 10:34:29AM +0000, Pedro Falcato wrote:
> On Thu, Mar 19, 2026 at 07:14:38PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Thu, Mar 19, 2026 at 06:31:07PM +0000, Pedro Falcato wrote:
> > > Hoist some previous, important to be inlined checks to the main loop
> > > and noinline the entirety of folio_pte_batch_flags(). The loop itself is
> > > quite large and whether it is inlined or not should not matter, as we
> > > are ideally dealing with larger orders.
> > >
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > > ---
> > >  mm/mprotect.c | 16 +++++++---------
> > >  1 file changed, 7 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > > index 8d4fa38a8a26..aa845f5bf14d 100644
> > > --- a/mm/mprotect.c
> > > +++ b/mm/mprotect.c
> > > @@ -103,16 +103,9 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
> > >  	return can_change_shared_pte_writable(vma, pte);
> > >  }
> > >
> > > -static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> > > +static noinline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> >
> > Hmm I'm iffy about noinline-ing a 1 line function now?
>
> Well, it's a 1 line function that itself (probably) has an inlined
> folio_pte_batch_flags() with a bunch of inlined functions, calls, etc. But yes, I
> see your point.

I mean again the weird thing is folio_pte_batch_flags() being inline in a header
file in the first place. It even says:

 * This function will be inlined to optimize based on the input parameters;
 * consider using folio_pte_batch() instead if applicable.

In the comment.

noinline'ing to not inline an inline function that explicitly says it's inline
for performance seems... silly.

>
> >
> > And now yu're noinlining something that contains an inline (but not guaranteed
> > to be function, it's a bit strange overall?
> >
> > >  				    pte_t pte, int max_nr_ptes, fpb_t flags)
> > >  {
> > > -	/* No underlying folio, so cannot batch */
> > > -	if (!folio)
> > > -		return 1;
> > > -
> > > -	if (!folio_test_large(folio))
> > > -		return 1;
> > > -
> > >  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
> > >  }
> > >
> > > @@ -333,7 +326,12 @@ static long change_pte_range(struct mmu_gather *tlb,
> > >  				continue;
> > >  			}
> > >
> >
> > ^^^ up here is a mprotect_folio_pte_batch() invocation for the prot_numa case,
> > which now won't be doing:
>
> Yep, this is a bug (that sashiko also caught!)
>
> >
> > 	if (!folio)
> > 		return 1;
> >
> > 	if (!folio_test_large(folio))
> > 		return 1;
> >
> > At all, so isn't that potentially a pessimisation in itself?
> >
> >
> > > -			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
> > > +			/* No underlying folio (or not large), so cannot batch */
> > > +			if (likely(!folio || !folio_test_large(folio)))
> >
> > We actually sure of this likely()? Is there data to support it? Am not a fan of
> > using likely()/unlikey() without something to back it.
>
> I did a small little test yesterday with bpftrace + a kernel build +
> filemap_get_folio. I got a staggering majority of order-0 folios, with some
> smaller folios spread out across a bunch of orders (up to 8, iirc). Of course
> I'm on x86 so I don't have mTHP, etc enabled, so those will all be order-0 or
> PMD_ORDER folios (which we won't see here).
>
> >
> > > +				nr_ptes = 1;
> > > +			else
> > > +				nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte,
> > > +					  max_nr_ptes, flags);
> >
> > It's also pretty gross to throw this out into a massive function.
> >
> > >
> > >  			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
> > >  			ptent = pte_modify(oldpte, newprot);
> > > --
> > > 2.53.0
> > >
> >
> > This is all seems VERY delicate, and subject to somebody else coming along and
> > breaking it/causing some of these noinline/__always_inline invocations to make
> > things far worse.
>
> Who told you optimization isn't delicate?!

I don't want to accept changes that will randomly break in future, it's fairly
pointless, because I guarantee somebody will break things at some point if
they're fragile.

And we _really_ do not want or need to have functions where a bot will shout at
you and you spend X hours figuring out why you reduced the time on a
microbenchmark that does something nobody cares about.

BUT, if we can _abstract_ the bigger wins by rethinking batching somewhat then
we could achieve something here, and that'd definitely be worthwhile.

I think that really the batching implementation is a bit of a mess because it
was done without fixing any existing technical debt first.

We need to stop accepting series that pile more code on top of existing code
that is already a mess like that.

>
> >
> > I also reserve the right to seriously rework this pile of crap software.
> >
> > I'd rather we try to find less fragile ways to optimise!
>
> But yes, I understand your point. Hm. I'll need to think about this some more.
> There's nothing I would love more than to simply slap a
>
> if (pte_batch_hint(ptep, pte) == 1)
> 	nr_ptes = 1;
>
> on !contpte archs. I don't see where most of the wins for those architectures
> would exist, but apparently they do. Confusing :/
>
> >
> > Maybe there's some steps that are bigger wins than others?
>
> Definitely :) So yeah I'll probably be dropping this patch, or at least
> reworking this one a good bit.

Thanks, sorry to be negative - I appreciate the detailed perf analysis, but I
want to make sure we do this in such a way that future Lorenzo and future Pedro
and future David and future whoever can remember WHY we did X and NOT to do Y
that breaks it :)

So that means abstracting it in a way where that's made easy for us (abstraction
stays stable and handles the perf details for us which are documented in e.g. a
comment, callers call, everybody's happy-ish).

>
> --
> Pedro

Thanks, Lorenzo

