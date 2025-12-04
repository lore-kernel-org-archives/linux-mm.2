Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E863FD2A532
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78136B00B3; Thu,  4 Dec 2025 15:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50216B00CA; Thu,  4 Dec 2025 15:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C536B00CC; Thu,  4 Dec 2025 15:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 96DC56B00B3
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:55:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4089EB8310
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:55:40 +0000 (UTC)
X-FDA: 84182994840.14.D237452
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4956B40012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:55:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H1MXqtLv;
	spf=pass (imf27.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764881738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWhlLkcwPRD4j1x3/KKjln1MfaQplzhsjUGQiv1dU8s=;
	b=v9g5GeJiLrClFXKVnAMGhmXLlAqRlQ4ekFwq/TRRt3VdrxA2UvApJ3YECeti0hjtRH9+13
	0eyadezeS5mm38K/wSrmi4cKqU6bOLut0WoZXTKSuQS9A0V27cvVRoEsHz43eGJDcwv5u8
	nS8qo1JnGXM/0VrdvuN9JbYbTc1Cn00=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H1MXqtLv;
	spf=pass (imf27.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764881738; a=rsa-sha256;
	cv=none;
	b=EzBkhPR4oc4Yphrqi34ZuUFmW4kF7xPtaOmOA9cWE8JsVp+5/I67IUJSCJ+vRyFOAZYQvD
	UDvmuzZax7k1iSte/9wj+oIc0BgWi28YdO6iSBXU/REZ0CcDihnnzMtw9f5Nt6DYGU+lPi
	n8nmOVNRL3I172PgRBpPzx2XYvNv4BM=
Date: Thu, 4 Dec 2025 20:55:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764881736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XWhlLkcwPRD4j1x3/KKjln1MfaQplzhsjUGQiv1dU8s=;
	b=H1MXqtLvs1fw/oPGSXcqgJK57glDB0rEqNHVXVtKxIfKcQ44StL6I42xXfgvaa2NWTKf9A
	yiPCDgsnAWQpxRFj8Gzb+UuPSnQk0UkNqlAz8udw6NPG59RXeNxilUeA0Nwe5dg/e2Szpg
	+2mAC+kmLzRU7T+/r/fcetrnWiswBvY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <gmwsdhkokyhchjucnwjw2j7nxps77lgc37lafxpjdecfjqnvic@j5d7maxz34zk>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
 <gkbiqbml5ikvmqybklyzsff46gemhtczm374f4qx54y5glagru@elgd2tfmoezt>
 <CACePvbX=5m5VuXN2V2_DB1sbNw+tEu=BKBxnuEXmY0V+hQS2_w@mail.gmail.com>
 <cxxoqqalrna65kafcpig65kt5gziwe66cep3luf736lp3hmqtu@2yqkilusmmdj>
 <CACePvbVGdx4YN=TCKuLF9TzCQg95OW8rnWLRrKENS42xc6q9cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbVGdx4YN=TCKuLF9TzCQg95OW8rnWLRrKENS42xc6q9cA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4956B40012
X-Rspamd-Server: rspam02
X-Stat-Signature: axfo6p63r53g96cozypsb6h9msyhq9ni
X-Rspam-User: 
X-HE-Tag: 1764881738-714440
X-HE-Meta: U2FsdGVkX1+dA2CkVDslqz4qHyvooI3MMOU3lBGdftOPs7m2TgJ1pxeSpbYezB2YUm10Et+gqpRTpjOVhztDMtTcPYwr+9FQIbtYVrGL8foTaW8GKJnv2m3NkvIWKafBv/2cbRxEFuPgLZspL1Y/7C7kBoBRlfGtno02tz9BdbfgvhEEbX3JTi3afoBsIBZnIlLfumA+7rHY6p8MgJuN1lnbPJpn9ed7Gp8X1Y5bj84ee+JMhOVGTQdFijpuu61Sd7UK+hv0B6W/wIwmsS6inmjdEX3L+HCxLAjJUFR5h76HkctHl68dh9OOrzjIwbtbzqY10spK90Q61RlFYWZGePeu9NGZUMMhpeNAYkir6A4/8DmJkNOibAEJ+1dH8jIxmJcwtrkdCaWgHkiLpTjq+GEyQ3XkdTrlhnPkxrg1hDtgVGnvRfUktVcpBFUvfQF0x1BziXI1D5W4HwPD5QEtwEEaYHTLQVpUHiBXwqkFHA/MwJpXl9tEc2jfNQJOGnlEUxA95hQuHOVfM85Pd33RrE15loG1NZLLxzF8nYV6KrvTWVVrNrz2aR+LK9TeabMatZ6QqNWiRIQOXDhg9TCQEv6aC8n6UnXVXJFWjwfjbyc9PsXEMAnmt2edd3Q5z5E+At/50mFhTUHtJsOUUF/e0OYMbgM41d0y1bg/vrmYNppeWIs7SKCp5n+Sh8f0deefUyy7TDOlmUKiEdtbnRd200D1FoeBYV6ZeKU0Ieu8HZWV8JhU7Kma8hzt1bb9thIH34ElBHp2beBLjxJ0BoYD6XX6kqDhrzWpBAXvSFLHMervKBvFpWPEpgnz96RCktuEvYL+dkT/e9s0DM2VD5wv5x3LLUBzfEfbIsiqpElP9D68UCRZIcUqiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 02:11:57PM +0400, Chris Li wrote:
[..]
> > >
> > > > oversimplifying a bit: Chris mentioned having a frontend and backend and
> > > > an optional redirection when a page is moved between swap backends. This
> > > > is conceptually the same as the virtual swap proposal.
> > >
> > > In my perspective, it is not the same as a virtual swap proposal.
> > > There is some overlap, they both can do redirection.
> > >
> > > But they originally aim to solve two different problems. One of the
> > > important goals of the swap table is  to allow continuing mTHP swap
> > > entry when all the space left is not continues. For the rest of the
> > > discusion we call it "continuous mTHP allocator". It allocate
> > > continuous swap entry out of non continues file location.
> > >
> > > Let's say you have a 1G swapfile, all full not available slots.
> > > 1) free 4 pages at swap offset 1, 3, 5, 7. All discontiguous spaces
> > > add up to 16K.
> > > 2) Now allocate one mTHP order 2, 16K in size.
> > > Previous allocator can not be satisfied with this requirement. Because
> > > the 4 empty slots are not contiguous.
> > > Here the redirection and growth of the front swap entry comes in, it
> > > is all part of the consideration all alone, not an afterthought.
> > > This following step will allow allocating 16K continuous swap entries
> > > out of offset [1,3,5,7]
> > > 3) We grow the front end part of the swapfile, effectively bump up the
> > > max size and add a new cluster of order 2, with a swap table.
> > > That is where the front end of the swap and back end file store comes in.
> >
> > There's no reason why we cannot do the same with virtual swap, even if
> > it wasn't the main motivaiton, I don't see why we can't achieve the same
> > result.
> 
> Yes, they can. By largely copying the swap table approach to achieve
> the same result.

What copying? Using virtual swap IDs inherently means that we are not
tied to coniguous swapfile slots to swap out large folio.

> Before I point out the importance of the memory
> overhead of per swap slot entry, the 48 bytes is not production
> quality. VS hasn't really made good progress toward shrinking down the
> per slot memory usage at a similar level. Not even close.

Nhat said repeatedly that what he sent was a PoC and that the overhead
can be optimized. Completely disregarding Nhat's implementation, I
described how conceptually the overhead can be lower, probably down to
16 bytes on x86_64.

> That is until you propose using the earlier stage of the swap table to
> compete with the later stage of the swap table, by using the exact
> same approach of the later stage of the swap table. Please don't use
> swap table ideas to do a knockoff clone of swap table and take the
> final credit. That is very not decent, I don't think that matches the
> upstream spirit either. Please respect the originality of the idea and
> give credit where it is due, after all, that is how the academic
> system is built on.

Ugh..what?

All virtual swap propasal made it clear that they are PoCs and that the
memory overhead can be shrunk. Compacting fields in the swap descriptor
(or whatever it's called) to save memory is not "an original idea". What
I said is that any memory optimizations that you apply to swap table can
equally apply to the virtual swap because they are conceptually storing
the same data (aside from the actual swap slot or zswap entry).

The other part is allocating and freeing in batches instead of
per-entry. This is an implementation detail, and Nhat mentioned early on
that we can do this to save memory (specifically for the locking, but it
applies for other things). This is not a novel approach either.

The comparison to swap table was to clarify things, not "knocking off"
anything.

[..] 
> > > https://lore.kernel.org/linux-mm/CACePvbX76veOLK82X-_dhOAa52n0OXA1GsFf3uv9asuArpoYLw@mail.gmail.com/
> > > ==============quote==============
> > > I think we need to have a separation of the swap cache and the backing
> > > of IO of the swap file. I call it the "virtual swapfile".
> > > It is virtual in two aspect:
> > > 1) There is an up front size at swap on, but no up front allocation of
> > > the vmalloc array. The array grows as needed.
> > > 2) There is a virtual to physical swap entry mapping. The cost is 4
> > > bytes per swap entry. But it will solve a lot of problems all
> > > together.
> > > ==============quote ends =========
> 
> The above prior write up nicely sums up the main idea behind VS, would
> you agree?
> 
> I want to give Nhat the benefit of the doubt that he did not commit
> plagiarism. Since now VS has changed strategy to clone swap tables
> against swap tables. I would add the points that, please be decent and
> be collaborative. Respect the originality of the ideas. If this is in
> the academic context, the email sent to the list considers paper
> submission, the VS paper would definitely get ding on not properly
> citing priory paper of "virtual swapfile" above.

Okay let me make something very clear. This idea to introduce an
redirection layer for swap, call it virtual swap or swap table or mTHP
swap allocator or whatever is NOT new. It's NOT your idea, or my idea,
or Nhat's. I first heard about it from Johannes in 2022, and it was
floated around by Rik in 2011 based on discussions with others:
https://lore.kernel.org/linux-mm/4DA25039.3020700@redhat.com/

So no one here is trying to take credit for the idea, except you. No one
here is plagiarising anything. We are discussing different design and
implementations of the same idea. Sure, people have different ideas
about how to implement it, whether it's using an xarray or a swap table,
or what exactly to point at in the backend.

But these things are usually hashed out during discussions and code
reviews, and the better approach is taken by the community. You are the
one being very defensive about his "ideas", making it about personal
credit, and creating a problem where there was none. No one is trying to
steal any credit. Kairui's patches introducing the swap table are there
under his name. If we extend his work for the redirection layer, no
matter the direction we take it in, it's not taking away from his work,
it's adding to it.

> 
> So far team VS haven't participated much on swap table development.
> There are a few ack from Nhat, but there is not really any discussion
> showing insight of understanding the swap table. Now VS wants to clone
> the swap table against the swap table. Why not just join the team swap
> table. Really take part of the review of swap table phase N, not just
> rubber stamping. Please be collaborative, be decent, do it the proper
> upstream way.

There are no "teams" here, you're the only who's consistently making
this into an argument between companies or teams or whatever. You keep
saying you want to have a technical discussion yet most of your response
is about hypotheticals around teams and stealing credit.

> > > > Disregarding any specific implementation, any space optimizations that
> > > > can be applied to the swap table (e.g. combining swap count and
> > > > swapcache in an 8 byte field) can also be applied to virtual swap. The
> > > > only *real* difference is that with virtual swap we need to store the
> > > > swap slot (or zswap entry), while for the current swap table proposal it
> > > > is implied by the index of the entry. That's an additional 8 bytes.
> > >
> > > No, the VS has a smaller design scope. VS does not enable "continous
> > > mTHP allocation" . At least that is not mention in any previous VS
> > > material.
> >
> > Why not? Even if it wasn't specifically called out as part of the
> > motivation, it still achieves that. What we need for the mTHP swap is to
> > have a redirection layer. Both virtual swap or the front-end/back-end
> > design achieve that.
> 
> Using your magic against you, that is what I call an "after thought"
> of the century. Just joking.
> 
> Yes, you can do that, by cloning swap tables against swpa tables. It
> is just not considered decent in my book. Please be collaborative. Now
> I have demonstrated the swap table side is the one with most of the
> original ideas and advanced technical designs. Please let the team
> swap table finish up what they originally planned, not steal the
> thunder at the final glory. If team VS wants to help speed up the
> process, since priority is one of VS main considerations, now the
> design has been converging to swap tables. Please help reviewing the
> swap table landing phases submission. Crew, walk, run. Even if you
> want to use the swap table against the swap table. Reviewing landing
> swap table code is a good way to understand swap tables. Let the team
> swap tables to finish up the original goal. Once swpa tables have the
> continue mTHP allocator, we can example any other VS feature can be
> added on top of that.

More rants about hypothetical cloning, knocking off, etc.

> 
> > > With the continues mTHP allocator mention above, it already has the
> > > all things VS needed.
> > > I am not sure we still need VS if we have "continues mTHP allocator",
> > > that is TBD.
> >
> > As I mentioned above, I think the front-end/back-end swap tables and
> > virtual swap are conceptually very similar. The more we discuss this the
> 
> Of course very similar, for all we know it is possible they come from
> the same source.
> https://lore.kernel.org/linux-mm/CACePvbX76veOLK82X-_dhOAa52n0OXA1GsFf3uv9asuArpoYLw@mail.gmail.com/

Your lack of self-awareness is impressive.

> 
> > more I am convinced about this tbh. In both cases we provide an
> > indirection layer such that we can change the backend or backing
> > swapfile without updating the page tables, and allow thing like mTHP
> > swap without having contiguous slots in the swapfile.
> >
> > >
> > > Yes, VS can reuse the physical location pointer by "continues mTHP allocator".
> > >
> > > The overhead is for above swap table of redirection is 12 bytes not 16 bytes.
> >
> > Honeslty if it boils down to 4 bytes per page, I think that's a really
> > small difference.
> 
> 4 bytes per slot entry difference is leaving free memory on the table.
> Why not grab it?
> Do you know that all those swap phase II..IV just to save 3 bytes per
> slot (and clean up the code in the process)?
> 4 bytes out of total 8 or 12 bytes that is 33% - 50% difference on the
> per solt usage.

Cleaning up the swap code and the performace optimizations in Kairui's
work are a lot more important that saving 3 bytes per slot, especially
if it's only for actively used slots. That's less than 0.1% of the
memory saved by swapping out a page to disk.

> 
> > Especially that it doesn't apply to all cases (e.g.
> > not the zswap-only case that Google currently uses).
> 
> I want to ask a clarifying question here. My understanding is that VS
> is always on.
> If we are doing zswap-only, does VS still have the 8+4 = 12 bytes overhead?
> 
> I want to make sure if we are not using the redirection, in the zswap
> only case, we shouldn't pay the price for it.
> Again that is another free money on the table.

IIUC the extra memory used for the virtual swap can be offset by
reduction in zswap_entry, so for the zswap-only case I don't believe
there will be any additional overhead.

> 
> > > > batches). In fact, I think we can use the swap table as the allocator in
> > > > the virtual swap space, reusing all the locking and allocation
> 
> Yes, you can. Is there a technical difference to do so? If not, why
> steal the thunder at finial glory? Why not let swap tables finish up
> its course?
> 
> > >  In the "continous mTHP allocator" it is just physical location pointer,
> > >
> > > > Another important aspect here, in the simple case the swap table does
> > > > have lower overhead than virtual swap (8 bytes vs 16 bytes). Although
> > > > the difference isn't large to begin with, I don't think it's always the
> > > > case. I think this is only true for the simple case of having a swapped
> > > > out page on a disk swapfile or in a zswap (ghost) swapfile.
> > >
> > > Please redo your evaluation after reading the above "continuous mTHP alloctor".
> >
> > I did, and if anything I am more convinced that the designs are
> > conceptually close. The main difference is that the virtual swap
> > approach is more flexible in my opinion because the backend doesn't have
> > to be a swapfile, and we don't need "ghost" to use zswap and manage it
> > like a swapfile.
> 
> It seems the design has converged to the swap table side. Even the
> "virtual swapfile" concept could have come from the swap table side.
> I'm flattered, copying is the best compliment from the competitor.
> 
> Now we settle on the big design, the rest of the design difference is
> very small.

No, the design hasn't settled or converged on any "side". I am also not
going to respond to the rest of this email, and potentially other
emails. You keep twisting my words, making delusional claims, and
proving how difficult it is to have a technical conversation with you.

You kept mentioning that you want to keep the conversation on the
technical side, but when I tried to have a technical disucssion you
quickly drove it away from that.  Half of your email is basically
"everyone is trying to steal my cool ideas".

I tried salvaging the discussion but this is hopeless.

