Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C38D2C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0486B008A; Thu, 27 Aug 2026 07:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C715F6B009B; Thu, 27 Aug 2026 07:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F666B009D; Thu, 27 Aug 2026 07:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD736B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:29:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F9FCC03CB
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:29:50 +0000 (UTC)
X-FDA: 85146829740.15.83F1BAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 883A240002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:29:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="afD/2Br+";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787830188;
	b=fusZj/lBaHseD/xEnE2dw2T/SEZ/pyefgvbydotClLPyWvLLoy7y0bCCiAT1nWG+xodq+b
	AWpDMTf30jCb1R7Om8ir5xzEHsTqF62Eg1uMfaR6QilaSZqkCMqIcUyavMwGZfwA/w1OIW
	8NameqEcm+01gY/gRqZu/LQvH+TqD+A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787830188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1y2tOmwASyfw2PTeAqcz8xYEBJBZ7KYSO7CTUxpPkJM=;
	b=YCpfcfjnYgjdUx+I8sjcyMiVpMlIX7u0iMsgbIKz4OErWRz1GmsblKesCMpp0GAt8rnOUe
	c/7DyAgUroA+fCC/G64Uz7Hibn4e3ucMi5guQa+ZfufdT6FeLL3tApK7Mzqo/G7g78xG/b
	oJJoXpm2uZ0Dgnxi7JPSGD7/7w+YzDw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="afD/2Br+";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00349600D2;
	Thu, 27 Aug 2026 11:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD83B1F000E9;
	Thu, 27 Aug 2026 11:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787830187;
	bh=1y2tOmwASyfw2PTeAqcz8xYEBJBZ7KYSO7CTUxpPkJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=afD/2Br+WbOEN1fBUqTISQXUJgjaTyXQwMzBCHt6fJoEXnAMCJ5VWRlhUqoz70ncF
	 DAyj6dWtyugehMEFf1ytgne/oSPJPBHDNWb6d2euBJuOTwMateF0NHli29Njxzrbw7
	 MuFZeGJ54N+xw1LgijsanJHl0gYmyd7gB1MMev4mVKno2ERXqzZPtSVGuORtB+OJBH
	 WIUMfdOy5vwFS3las9n14WI8uRXveRnroSJcLP8LKxX3UMtYsZJEZ13YW0y7SQi4WA
	 u+4aSUzHiQECKXGOwvKWLUOq/zq+3cclu8v+RgbPGFX5iG+NdhIuWtC/9Nep12LEcs
	 0mEXPVFLEjU4A==
Date: Thu, 27 Aug 2026 12:29:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
Message-ID: <apAdUOa2OfxSmSEP@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
 <aoxm4jUrmL1eQlCJ@gremlin>
 <ao1waln1lklfk8th@kernel.org>
 <ao2Qk87AKnMKuNvg@gremlin>
 <ao_qWEcoaIcm1WhE@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao_qWEcoaIcm1WhE@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 883A240002
X-Stat-Signature: 1inq948q3p7f5swk57m156bbjtsg7sas
X-HE-Tag: 1787830188-736012
X-HE-Meta: U2FsdGVkX18n4WY71rjVjvFiZu26EObgUr0QBKrnIVXl3eA7CtbZIwUTiUKXhAO+lZLH9hU8Ipc6ip9BDcb3cltSX0n9N+e3x0O1ChPcTAaRH+WKBQnD6LrJbYOyW5YGA47M8P1ZbCKhyfzqbx+FjaLUwk4whnM1vnDmOJ3n1qfllV+pO4wL7zOb11/U2H4Tn0grZ+TdxutHr44AgJHJOQdKSawfJY6JuqDzYXUaiugsMOne9FcTmYTLCRiK1O6knFUC2GCzICpJO6TFRUg74Vi6XCry3sZAu8G5RIujRk2NQK8XDlLapSf60M7KZ8iigB2puvjOwHWvQNe/w/Zzti5oTlGap5lVpEE2caSfPEo1PaFda63LXUFQcvrLo2ypOs1Spy9MKPOf1z3RfHeeomrcAA+XIQLldVCCq1cQNX1LiZy0lFEoe55CtlM0rwRHTHIV9NJilv8w3sze4F55nOU4g6ni+k0Iw/ksnU/q1ctqB3dHA3LbORyY4FWJQ0V2Oa9suUYDV//RFijTS1/Wwi4Mdkq9BLf/wAN9dj/RzBqguvlp3EKlt6IW0UEx2FlGetCXXpwcplCdTVKJMBHh7zmboQCPoTra1x/X9jxnfPx1RLEjNWzTMpTng5WS+EpNiC7Pm4fOAC5FVDbeeKXYXsaoVceXxPZ3HFRF6twC7EbB9uHtHMTu+D7eqztNzvpfNNEGD8ojJMINtlUKBF368lveVyboWN0qzAPvWYep4xntPaDhdKbLgYtbSptk8y+mT8+sT7fjCElZsytijLPs22xGBbYWQAc3bpGHKldBJWn5FYuqmosxG2iWFFQ7FzQ6sMFyDg2U0ETi3QnNFLql8HN6WFEQQj9o/szXDtIxs7SkEbepsWXd2RXNNOk19rRpDozsnWQaWhBrsajYabkRbr7t86/pyvoWeqT1cbmamt4+Ol8pKmD1fug+kcnIJzr9spjElYZDpizWdDhYlxo
 YQfnFTF0
 RhA+u1rNzPRw3NmnY6ywprfDNekK9+4gXF1OwLGm2lODGKObuhdA6B840+1pg8BJrPxP6iWqbPjDJiwIJXfVlAwtK5hQZLLTEUdV04rQ/akf/G+bmBHwZUB9ffhXhJYGw4HKHEwqy7gk56i3dda0Vx1RGrpWKuS17yc0slUjrySqOPyWCZzuZzvaYlU2b3YuB3lKpg2yT9/pk1xH+36cOUko21VZZbhLdqvlaY2dnuq3QOYsGnHACovQ6eY0zfQXoE++/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:42:16AM +0300, Mike Rapoport wrote:
> On Tue, Aug 25, 2026 at 02:00:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> > I mean you then introduce the same flags again seemingly with different
> > names as #define's in the next patch... having several sets of flags with
> > subtly different names seems unwise.
>
> The names are important, the values are not.
>
> There are two cases that currently use the same VMA_UFFD_* flags:
> * the way VMA is registered with uffd, i.e. the 'mode' part
> * the type of the user fault that the generic #PF handler passes to
>   handle_userfault()
>
> They are related, a fault in a VMA that was registered as MISSING will
> never pass MINOR to handle_userfault(), but I think it'll be actually
> clearer to separate them semantically, so that when you read a call site of
> handle_userfault() it is clear what type of the fault it is and when you
> parse userfaultfd code you see what modes user wanted for a VMA.

OK, thanks for that explanation.

I think summing that up in a comment and definitely the commit message would be
useful.

Also potentially gathering all this kind of state and putting it in mm.h or
mm_types.h would be nice too.

I say this elsewhere but I do think userfaultfd_k.h is a bit of a confused
mess and we shouldn't make things more confusing by wanting to keep state
explicitly there.

>
> > > > Anything that is parameterised by enum uffd_reason that combines flags will
> > > > break any switch statement in there and yada yada.
> > > >
> > > > I wonder if better just as #define's + unsigned long or something?
> > > >
> > > > Or you could do (and this leads to nicer stuff later):
> > > >
> > > > 	enum uffd_reason {
> > > > 	     USERFAULT_MISSING_BIT = 0,
> > > > 	     USERFAULT_MINOR_BIT = 1,
> > > > 	     USERFAULT_RWP_BIT = 2,
> > > > 	     USERFAULT_WP_BIT = 3,
> > > > 	};
> > > >
> > > > 	#define USERFAULT_MISSING BIT(USERFAULT_MISSING_BIT)
> > > > etc.
> > >
> > > Looks over-engineered to me tbh, if we drop an enum, I'd just
> > >
> > > #define FLAG (1 << SHIFT)
> > >
> > > and call it a day.
> > >
> > > Also see below about aligning with uABI flags.
> >
> > See review on 6/6, I'm confused actually why we have several sets of these
> > flags...
>
> I can see that ;-)

Right, I do think in general if experienced(-ish ;) kernel maintainers find
things confusing, this is _usually_ a signal that things could be made more
clear in the series.

Of course not excluding the possibility that I am simply not bright enough
to figure it out :)

>
> > But in general it seems like these flags (in one form or another) are being
> > repeatedly referenced, so it's not really over-engineering I don't think to
> > abstract some of that.
>
> Again, the bit numbers do not matter, they are the same because it's easy
> to count from 0. I can make one of those count backwards if it helps :)

I think you're missing the point, but I go into detail with examples in 6/6
that hopefully clarifies things.

The enum/bit number/keeping equality stuff was just me thinking out loud,
the point here is about abstraction and keeping things clear.

I mean, and give me some rope, by your argument, why have
vma_is_anonymous()? Just check for !vma->vm_ops everywhere right?

Well I'd argue that it is _far_ clearer, self-documents, abstracts the
_means_ by which a VMA is anonymous (no vm_ops) from the semantics of 'is
this VMA anonymous'.

Equally so here.

I actually think it'd not be unreasonable, given how few flags there are to
have e.g.:

	vma_handles_uffd_missing()
	vma_handles_uffd_minor()
	vma_handles_uffd_wp()
	vma_handles_uffd_rwp()

Or something like this?

And, as I say in 6/6, you are checking vma_test(vma, VMA_UFFD_BIT) each
time (or perhaps context != NULL? Not sure if equivalent) now you can
abstract that and remove duplication.

And _then_ the weird 'WP but not uffd' case can be self-documented and
called out like:

	vma_was_uffd_wp()

Or whatever naming would make sense.

Hopefully that clarifies my point.

>
> > Maybe can be in wrappers that make it nicer. But really the issue is the
> > duplication in modes/reasons/flags...
> >
> > >
> > > > > @@ -168,9 +168,9 @@ struct uffd_msg {
> > > > >
> > > > >  /* flags for UFFD_EVENT_PAGEFAULT */
> > > > >  #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
> > > > > -#define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is VM_UFFD_WP */
> > > > > -#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is VM_UFFD_MINOR */
> > > > > -#define UFFD_PAGEFAULT_FLAG_RWP		(1<<3)	/* If reason is VM_UFFD_RWP */
> > > > > +#define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is uffd-wp */
> > > > > +#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is uffd-minor */
> > > > > +#define UFFD_PAGEFAULT_FLAG_RWP		(1<<3)	/* If reason is uffd-rwp */
> > > >
> > > > Is it worth retaining the same bit indexes as the reasons?
> > > >
> > > > Reasons:
> > > >
> > > > 	Bit number
> > > > MINOR	0
> > > > RWP	1
> > > > WP	2
> > > >
> > > > Page fault flags:
> > > >
> > > > 	Bit number
> > > > MINOR	2
> > > > RWP	3
> > > > WP	1
> > >
> > > If we go this way, than it must be
> > >
> > > #define USERFAULT_MINOR UFFD_PAGEFAULT_FLAG_MINOR
> > >
> > > so we won't need to keep them in sync explicitly.
> > >
> > > With a caveat of USERFAULT_MISSING that is expressed as "no flags in
> > > uffd_msg" :)
> >
> > Ugh.
>
> Yeah, and the PAGEFAULT_FLAG numbers are set in stone because it's uABI.

Ack.

>
> > > >
> > > > With matching flags and unsigned long you could do
> > > >
> > > > 	msg.arg.pagefault.flags |= reason;
> > > >
> > > > I think?
> > >
> > > Almost:
> > >
> > > 	msg.arg.pagefault.flags |= (reason & ~USERFAULT_MISSING);
> > >
> > > And define USERFAULT_MISSING as (1 << 0) with a comment why it's fine.
> > >
> > > I don't feel strongly about it, but my preference is to define reason flags
> > > independently of UFFD_PAGEFAULT_FLAGs and keep the ifs here.
> >
> > And also modes... Again I think fixing that mess somehow is the better way forward.
>
> Can you elaborate?

I'm talking about the 'mode' naming, which I think we have reached
agreement upon in 6/6.

>
> > > > > @@ -2793,14 +2793,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
> > > > >  	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
> > > > >  	 * resolve the fault.
> > > > >  	 */
> > > > > -	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
> > > > > +	if (!pte_write(ptent) && (reason & USERFAULT_WP))
> > > >
> > > > I wonder if you could actually
> > > >
> > > > You do this quite a lot and they read a bit horribly with the && and & on the
> > > > same sight-line. With the changes to the enum proposed above you could do:
> > > >
> > > > 	if (!pte_write(ptent) && test_bit(reason, USERFAULT_WP_BIT))
> > >
> > > I find && and & perfectly readable and adding _BIT defines looks really
> > > excessive to me.
> >
> > Discussed in sub-thread. We'll agree to disagree I suppose.
>
> Yes, we will :)

See elsewhere.

>
> > > > > @@ -2835,7 +2835,7 @@ static inline unsigned int userfaultfd_get_blocking_state(unsigned int flags)
> > > > >   * fatal_signal_pending()s, and the mmap_lock must be released before
> > > > >   * returning it.
> > > > >   */
> > > > > -vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
> > > > > +vm_fault_t handle_userfault(struct vm_fault *vmf, enum uf_reason reason)
> > > >
> > > > Hmm what was the 'reason' here before? The flags? Maybe more reason (no pun
> > > > intended) to keep the values the same?
> > >
> > > The 'reason' before was a VM_UFFD_SOMETHING, we really can't keep the
> > > values the same, but we surely can keep it unsigned long.
> >
> > I notice the 'mode' which is not the same as the 'reason' is an unsigned
> > int in 6/6...
>
> Didn't you suggest to make 'reason' an unsigned int as well?

unsigned long :) but I think unsigned int is fine.

>
> 'mode' in 6/6 is an unsigned int because if it were an enum it'd require
> #include <linux/userfaultfd_k.h> in mm_types.h, see the commit message
> there.

Or we could just move flags out of that horrible header :)

I hate how C headers can force us into difficult decisions that make life
harder...

>
> > --
> > Cheers, Lorenzo
> >
>
> --
> Sincerely yours,
> Mike.

--
Cheers, Lorenzo

