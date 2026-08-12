Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A56C0C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 21:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE916B0328; Wed, 12 Aug 2026 17:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78FCC6B0329; Wed, 12 Aug 2026 17:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A58B6B032A; Wed, 12 Aug 2026 17:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3AD6B0328
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:38:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B0B41403A9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:38:41 +0000 (UTC)
X-FDA: 85093932042.02.B6A112C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C620540004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:38:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mipp/Tam";
	spf=pass (imf17.hostedemail.com: domain of "SRS0=I2fA=GF=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=I2fA=GF=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786570719;
	b=RoSNScIN6r3lydmLx3tALC7IvpspusjebwBHj4QA1ZMtJJQyj6mqA8WorZMBYCkxhuXaE5
	V1JGX53nyyqqO3oNZBHnDuHwKugcbWTPeRdEZpDfrpZ6uBRvrm2IgjjZqVJldutIvlqLF+
	GWg7M/AnzjTdizcCOKbgqdxqBqMk+hk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mipp/Tam";
	spf=pass (imf17.hostedemail.com: domain of "SRS0=I2fA=GF=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=I2fA=GF=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786570719;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cp8VKR+mPn5OPJBFC9VfSl1Nu9BWx9Sa1qFuiOfB2n8=;
	b=ibttTKdZpMk3ZNDqNilhsM9dc3mtbro/+DrOSLoJ66PIcU12KR9ix5xxE3kcCIRR21UgGh
	CjGLWFRu/XSehgCR8QRlm7/EAioG8RBbNzIRUdtMVooHyw4LgQcFxYmF2pfV4zux+ngYUz
	/7PczE9nPuyJ9s24uFldthJaK1xxSvE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01A964039F;
	Wed, 12 Aug 2026 21:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0081F000E9;
	Wed, 12 Aug 2026 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786570718;
	bh=Cp8VKR+mPn5OPJBFC9VfSl1Nu9BWx9Sa1qFuiOfB2n8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=Mipp/TamjMFifPGmGfcl3Aa7QIIOnIoUyxP5D2zaiECAy4CT+kswN3I69AAIXMqj1
	 TIfrfHGeiC3EyvRqGYWBT6/CZW6A2ZFdyWIZyFrs2+4a882RT1BgAu6RV4wGrZuCQ0
	 Uf5bIPpg66u1BEdyUQ62PQGF0lttJQWukYKr7OChDw8pMrAz8qXzu7zt2YT1gUTLFz
	 5EPpBLTRA46qUC3Vk5MIMkwQaDOlvKgL59FWWAhne9iGmRq79LhrYcyfGwuQlkr7V0
	 z5fb08Jf9qTh9XGB3p00AiEd+p1M+Z241W6YMJaDiNYb39skY3A+A5kRlfr9OTPQEy
	 O0FoyCy9nblUw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 519DECE0EBE; Wed, 12 Aug 2026 14:38:38 -0700 (PDT)
Date: Wed, 12 Aug 2026 14:38:38 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <b736237c-64ee-4eb2-8201-5685a3853844@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
 <20260812122759.GA662699@ziepe.ca>
 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
 <20260812134934.GC662699@ziepe.ca>
 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
 <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
 <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org>
 <d0692500893f303906fba1d7d596eb59a07a806a.camel@infradead.org>
 <anydY25Cl78l1HfU@google.com>
 <932DB129-1794-4855-A61E-F4C2B54B1EE6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <932DB129-1794-4855-A61E-F4C2B54B1EE6@infradead.org>
X-Rspamd-Queue-Id: C620540004
X-Rspam-User: 
X-Stat-Signature: wrbhzhgjg1i4s9cjbx8sbjaqonoqwbe7
X-Rspamd-Server: rspam06
X-HE-Tag: 1786570719-225625
X-HE-Meta: U2FsdGVkX1/BtSdcSGx6Jo7de7cAWg6ERvnjS0VG9BmA4xkWqEbGtQ9dD6NBW9LT59znpL2iHTl8lLgD+lGAr0Hdrz+GbPbuOaAvxEIF5Tga9rU9qcw7G4ulnvH+R2ljUXMtClax9E5i85mXDcQbXs6AuudIq5MpCFMB431+HnkyoE3uSj9JWrHq5ewfLuGJc21RjCeVaYIMIr+NKsM/38egiRK1Rn2qKnW6/o+l1lsnr1ttuOebMXmDTYaesnf0pMZFi4AP+mfqJ1t9VK88TBFNzuE7oq/Lsw72rgSYgJ2yEEYPD5AdGsnrtouBaOrDFOUPnrMxHTLb7mpy7qIZ2CZovLJUyDmjFVKnBKkN0tO2FYqJ8MIvL3/4yB4dNbjIc0gWZjVJUQ11512PnMErPTuVSAb5sgkrsEMYg01ayweE+Xi59nOnkWQdJheuJL8lIiL35LqVeMjM7tlPfO3VSDa19lzycQLS1uoD2NfjiRfNjRsSp1hX2pViZe2XDbWpZkrMr6WE2P5c0N2WVlClncnqXG4uySivqGnp7/4FXaRjtBpqz/V2xGl4ERjn3rzYeR055gvrUGT2a/WF4FM/lx8ruCj1YiYjV6yi/hQXoDqR1bli79ZwnOFA3FFuhdQtEzH816We2NywfN6WRMHVET3NBN1L9t5jvCXUeAS17DST62yYV/CAewmWt8DpwYoV2R4r1lS3cC45kZOW//wRyU2GVT5E6/FJMMAbonUYCZuY/SSnDqcrCWiPkCVVN6KMzf/wcBAZA1aIFzKPz0rpaJta6QL1yiElI2PGeWDvd3stBw/B7sEJMCiywgXjNPtmwoQ9rnJPrm7Fvz09LYXZ4K8uXy1gzTmIHQP+xBTv5ZBnwyVEgfqH+jhcFHudAbz4v5T59OP6j3zHyrfbMscy03wAzcnv9wxJq4g6udBqvuimhNJgJQ4fkONTZqCzcUaU6kEfrdvaN2lnxRkBzuo
 97yRvM+4
 w9HFywsRtGjBPYxvHksxc7vH6PYgWz3WihRBVeWuCYy8FeOWK6/KNaoo0nJCnR1HTfnhPg64owjO6i10Wv+gZNqi0p3Tuwdqe1lkDVvrRujPcXI+XfhcdUdi2agSnc4SmIc8DzOG44FHoyJtJk7JlMYPXSo/5tEvZisUm2BxrlWh9awMlGSkWV7m0M6VvDCZ9XaWAQGKuvm+bBBavABPz4cLLL6TJ6CxPGMH/FDmOp4+uWkJEJgJ10pSOKt52jfyQmAIOdjhhuoYb0tidU9YbZjByrQg7LMxqS5nzLmovPffAC+N+DbpMYGR03jBFuiCs6B9y/Dk+9UG8bHjf/m0OSPlVDvUifkS/jDQS4fsrAeHT3zIxxTRQCZHLKWk+cAn87pME5RWGJU4MhSuzr/hdySpmvrb9lpHY5hd4MoVXHlHoUvyyOYD+LqdxsHNsToRWU/Bkj86O0WxP+Ssbex6GEAmdYzaLAHqRqYLthR4x+RKY+kQGX7/LX6Ls/WiwNZ23NbMpIEyTZ+rCQf2Wjbk1V2hBdpddUJMFYW7FLgCiFcHcAM2cPJ+J9Lnsbhh5yXAQCQBZbMAFAfDO5QP3TiycLo9IAc+v2eg9QzowBl5ppivKlRgc4ToRSBvzu7lvslfWyheU2GJsmM4TjMhPlKnpcR9Cnw8+TIYMs8CHuUznkZ5gB2ADD/jciN0nr9t9adS4DWNpJ4yDtF4ks0HHewCz1KgtO44gIQRt6MaLrwBxPNXXOOS+86+KxEaEN2aUXyEgTVgmdLwjAl+fQSNAGxhggmqTfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 06:17:50PM +0100, David Woodhouse wrote:
> On 12 August 2026 17:20:51 BST, Sean Christopherson <seanjc@google.com> wrote:
> >On Wed, Aug 12, 2026, David Woodhouse wrote:
> >> On Wed, 2026-08-12 at 16:03 +0100, David Woodhouse wrote:
> >> > On Wed, 2026-08-12 at 15:34 +0100, David Woodhouse wrote:
> >> > > On Wed, 2026-08-12 at 15:05 +0100, David Woodhouse wrote:
> >> > > > I'll rephrase that for my own understanding:
> >> > > > 
> >> > > > *If* we go all the way to building a whole SRCU flavour for this *and*
> >> > > > implementing a spin-only variant of srcu_synchronize() which is
> >> > > > tailored to the atomic-reader use case, *then* we don't need to remove
> >> > > > the non_block_{start,end} guards around the MMU notifiers, which are
> >> > > > basically never being called anyway and don't actually seem to protect
> >> > > > against any real bugs.
> >> > > > 
> >> > > > Yes?
> >> > > 
> >> > > FWIW it looks something like this. I'll throw it into my torture and
> >> > > latency tests, and we can see what Paul thinks of it. I'm still utterly
> >> > > unconvinced it's needed, but I concede it has its good points.
> >> > 
> >> > This slightly refactored version is the one that's actually going into
> >> > my torture tests...
> >> 
> >> Well, it survived first contact, and it's doing the soak testing now.
> >> 
> >> The average is basically no better than the try_synchronize_srcu()
> >> case, unsurprisingly — as *both* of them just observe that there are no
> >> readers and proceed immediately, in at least 99% of cases.
> >> 
> >> Like the existing rwlock case, it still manages double-digit p100
> >> latency even when though *doesn't* actually sleep.
> >> 
> >> I don't *hate* it, but I do question the benefit of it over try-first.
> >
> >FWIW, the max latency and >8ms numbers are very appealing to me, as my concerns
> >with using SRCU are all about the tail latencies.
> >
> >But I'm obviously not the one who'd be saddled with maintaining the code, so I'm
> >more than a little biased towards choosing the more complex version.
> 
> Ack. Well, it isn't even *that* bad in terms of complexity. It's mostly just a while loop around the core of the try_synchronize_srcu() I posted before, and some syntactic sugar and safeguards.
> 
> Let's see what Paul thinks.

A single call to try_synchronize_srcu() that, upon failure, invokes
synchronize_srcu_expedited() would work fine.  And a limited loop on
try_synchronize_srcu() that invokes synchronize_srcu_expedited() upon
repeated failure return would also work fine.

But if you had a large system, an unlimited loop on try_synchronize_srcu()
could wait forever on a system that was large enough that there was at
least one reader at all times.  To guarantee loop termination, it is
necessary to flip the index.  That way, new readers would use the index
that was already seen to be clear, and old readers would eventually
drain from the old index.

So is your use case adddressed by the single call to
try_synchronize_srcu() that, upon failure, invokes
synchronize_srcu_expedited()?  If so, we have a solution!

If not, please let me know, and I will put together that does the job.

							Thanx, Paul

> >> Again, I'll defer to Paul, but personally I'd want to see a more
> >> compelling use case for it.
> >> 
> >>   ┌───────────────┬─────────────────────┬───────────────────┬─────────────────────┐
> >>   │               │      expedited      │     try-first     │       atomic        │
> >>   ├───────────────┼─────────────────────┼───────────────────┼─────────────────────┤
> >>   │ median drain  │ 32-128µs            │ 4-16µs            │ 4-16µs              │
> >>   ├───────────────┼─────────────────────┼───────────────────┼─────────────────────┤
> >>   │ avg           │ 118µs               │ 13.8µs            │ 12.3µs              │
> >>   ├───────────────┼─────────────────────┼───────────────────┼─────────────────────┤
> >>   │ >1ms          │ ~950ppm             │ ~990ppm           │ 838ppm              │
> >>   ├───────────────┼─────────────────────┼───────────────────┼─────────────────────┤
> >>   │ >8ms          │ 42ppm               │ 4.4ppm            │ 0.10ppm             │
> >>   ├───────────────┼─────────────────────┼───────────────────┼─────────────────────┤
> >>   │ max           │ 33.6ms              │ 17.6ms            │ 10.25ms             │
> >>   ├───────────────┼─────────────────────┼───────────────────┼─────────────────────┤
> >>   │ fallback rate │ —                   │ 1.2%              │ 0%                  │
> >>   ├───────────────┼─────────────────────┼───────────────────┼─────────────────────┤
> >>   │ sample        │ 32.6M drains, 10min │ 41M drains, 10min │ 40.5M drains, 10min │
> >>   └───────────────┴─────────────────────┴───────────────────┴─────────────────────┘
> 

