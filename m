Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB12D1F9A8
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E346B0007; Thu,  4 Dec 2025 05:12:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025896B002A; Thu,  4 Dec 2025 05:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7DE66B002B; Thu,  4 Dec 2025 05:12:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D446A6B0007
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:12:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D3AEC096C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:12:13 +0000 (UTC)
X-FDA: 84181373346.25.74BF400
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 40B401C0015
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:12:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jnKsbMMZ;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764843131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFFyxdQNtfcbkzofKLOfEqd+21aIyZzm/3geuPQDS0g=;
	b=fS4HJ27ISlkH0JawUWjxFVrd4NdVZ0RBQC6IA78v6ghwq6LQYnKOsi69hncGKHImdYe3yJ
	0xabvLWF5K+zYht7hZWabVe4GRJ0P8RUwuEwd64yDyu3shRok21US/AsFPGPLOMaeoCwiY
	amt54i4+oyYQ2eE9a688Ve+OT6ZiZqU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764843131; a=rsa-sha256;
	cv=none;
	b=5LnVFF6r8yuxItuu/RQiIUPGziS7fEbRnfDnJAs1OMSAAx6KeYiQr5goEAIydXBFPNax2b
	nZa8iIiNZEVJsBJkLx4qvvgPLyiQ8J8TuXyMFO5VP+8mXGRbs0fEzs00H1CGD+V/gY0KjE
	/MOk8BgWeGGnR0FT9aKcEbpn0jOSHdI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jnKsbMMZ;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 434324446E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20514C113D0
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764843130;
	bh=/BaResuBjUKm2XOBwBzJm/qVH44kwOuI+A5uWZKAcII=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jnKsbMMZeA5S4zftdqOjPIL7VDR+p6sRk6vsaxkUQpUefbTFTBPmGJL68/voy04KX
	 YLJSpMZNLzgEuiRAsRSwKBLdNHjRYM92O7to6TjzCQxcrDuT8tjhoetFWT5NWC6zWr
	 FhXYrR56XwcYsdstWLr5/Y9xAr2fVPFkn0I+DcCEFblAtAuZaz1c5tCiJnGI3LLtH7
	 mPLwJoy4N4xeFFmQxsLtLsHctLMZsnyHavWIvzhr+BM6jbZtxZcS7tv2RMAQu6Ivaw
	 YYIPKXC62Php4ZMob3DboJT8fS2NjOLGfsboATVoLrRWkL7gKJHTskogglKg1whSrI
	 WAg1+vCMFfwBQ==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78665368a5cso6701857b3.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 02:12:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUJOFhQyRIh7mKSeI7tQeBiF0EUoTRhXu5BdpWz01Hc7PvYkxu+ChLOCTS4setyCARru4hbFZX4zw==@kvack.org
X-Gm-Message-State: AOJu0YztVxM+aRBqdT9U033hx7YI+Qakk15DnOhzR6T5eryMHWyG5kti
	Oi50E5Ccu2/MpfypuoUKkSqaHgsdhV/b3pBS7YLjmvLusnZcBrf+GnPW4x8mGLKLcr6EZ2Gy+OP
	YBLfmDoKU2CJqEfUBlQ3bYf2pAgXarTB2fhO0T4M/9w==
X-Google-Smtp-Source: AGHT+IEUGOPfMEUnl+T3gH6IucdUaf9NBV1TVVQEXEEICvEVNafd+HHHf3pwm+njJHHUu7JI4d+f95u7NQDatjbea0E=
X-Received: by 2002:a05:690c:fcc:b0:78a:75cf:aa82 with SMTP id
 00721157ae682-78c0bf3b412mr46885657b3.28.1764843129279; Thu, 04 Dec 2025
 02:12:09 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <gkbiqbml5ikvmqybklyzsff46gemhtczm374f4qx54y5glagru@elgd2tfmoezt>
 <CACePvbX=5m5VuXN2V2_DB1sbNw+tEu=BKBxnuEXmY0V+hQS2_w@mail.gmail.com> <cxxoqqalrna65kafcpig65kt5gziwe66cep3luf736lp3hmqtu@2yqkilusmmdj>
In-Reply-To: <cxxoqqalrna65kafcpig65kt5gziwe66cep3luf736lp3hmqtu@2yqkilusmmdj>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 4 Dec 2025 14:11:57 +0400
X-Gmail-Original-Message-ID: <CACePvbVGdx4YN=TCKuLF9TzCQg95OW8rnWLRrKENS42xc6q9cA@mail.gmail.com>
X-Gm-Features: AWmQ_bkZFvZqDt0_ych7WjNDI00l1XxAZBwKGHu1ZxH0Cks9LM2K-oBGDYbWF0I
Message-ID: <CACePvbVGdx4YN=TCKuLF9TzCQg95OW8rnWLRrKENS42xc6q9cA@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40B401C0015
X-Stat-Signature: jsck7jw9wfc8o1kj8kcidnau7auys3dc
X-HE-Tag: 1764843131-127630
X-HE-Meta: U2FsdGVkX19aG2dyQXKw6hw4byHL6+sDkoPUmE3bR9xPKpQnSmj8MqPQHmqptNlmk9nxqTxakKbWKhXdlqiWE5Vx66VDUibbsO4xthTk8mzzGopEcLiQRB0WPDQPmPfkcILct1LPMi0kgfjvvr8HzcsXHbKXy/hc93ySaqdwfEuSpjOPYr6WKstUropFtqONdZihaExrnMsuJvIT6uDXW3TIqXdkCaCMyO+xEf5D2Z/0EcF6rMDg2R2EH1SbqxJXasldkMhUWx7SY8CvgfgYYHaqQybI4qkOrKtHDcKzVxzTkuusEPD+u4ZSfT/2Kepwo9n+jW+fBIy6fgw+t1k30BwoMFEH3M07YtKMlruTynBowQuYGYuWdnQVuEtargZ6A3ptpnQGJoT7PeLqlrJiAguJ3gI3vGM3kbeQDC7P++jOkMgoJp/P8qVTMA7IpcJ/YKVaSk88Cf2uOX/gH5jCZoriOoJoLYeSQLXh0zQM5qHRVubny8FUGdd2mXihox2KG8gfiyg56vUxdk4HtYAdW6wT2PGmpUjjUQz5Cs39fXHs7YC8JV8Ytp1VJeHvl0Db3PLNq9m40Fte3JqGXpn9bBkqn8vX0Hco8amM2pwtde74vYWwupcaZwpmtqINFN7F1YiVHlq9sp7LsTq/jI6XOUL5IDZNGmBqiEbwzwEIsFSNWRJi7UWBOgbDNxWu7fGy0kfoOxANfIbk799PbeKzApePmdzCAULFajpZBHfVKZMCUkz9envRrlfR11ltSvLO9Mf5BKAi960D217/Fj9BKQR4kPpjSDZrxDMmPhJsprqAIWIF7Nus1/NFX2EX01ukDUUGyn7zcxNJ9q8EegBTLkmh5roW4fyu+Qbh0uGZtMGOSmVRuCrAMiWzcpWbaFsg4a8xzBINnt49JlvOjfIglp3akMSL7f0C1VxfB3SovAUie9RDHQ4UdLT51Lzfky/99yFWGxNLKzjYjKUmM7j
 olJq5HOS
 XBQnLyOWCmKuw6RYdJyURuNRTV5q6aH7y9RYB7cz7s/XDyfGsvPnAeLTwwzfXFVbLA9XX2YPBjiTVwzqnn0I90lZGewJI7alrH7W0wMM3CthaeUDy1qSbvXY9cAzqttvhLc4xnKhVLJa+11UNaZjXuh+zbqMZv/SnLIeXtBRjaitVJhoETdwnb1vp6FmbKP7y9ke1/3YtB6rDXK4vj0oxFv37kRsvz1Ie1m3M44FsYLqCXd3f/XI9R5tMZZCNpiYIH5Yh+RU/NKP8bVG6U1dy/kQAisuKAtODwMPzNk/TCGia20rli8LhVSYu7sdJ7A82tNZgnHL3Gcz7SjYdZmydbeWRb/OnfkB5fhpzPkNfkgPhQZQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

, t

On Thu, Dec 4, 2025 at 10:16=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
> > On one hand I wish there was someone representing  the group as the
> > main speaker, that would make the discussion feel more equal, more
> > inclusive. On the other hand, any perspective is important, it is hard
> > to require the voice to route through the main speaker. It is hard to
> > execute in practice. So I give up suggesting that.  I am open for
> > suggestions on how to make the discussion more inclusive for newcomers
> > to the existing established group.
>
> Every person is expressing their own opinion, I don't think there's a
> way to change that or have a "representative" of each opinion. In fact,
> changing that would be the opposite of inclusive.

Ack, that is why I did not suggest a main speaker token approach. On
the other hand, there are still some considerations that can be taken
care of from the group side that do not overwhelm the single person if
a similar opinion has been expressed and is waiting for response. N vs
1 arguing does put the single person in unfair dis-advantage and
alienates the single person. We should consider the effect of that.
OK. Enough said on this and let's move on.

> > > Now with all of that out of the way, I want to try to salvage the
> > > technical discussion here. Taking several steps back, and
> >
> > Thank you for driving the discussion back to the technical side. I
> > really appreciate it.
> >
> > > oversimplifying a bit: Chris mentioned having a frontend and backend =
and
> > > an optional redirection when a page is moved between swap backends. T=
his
> > > is conceptually the same as the virtual swap proposal.
> >
> > In my perspective, it is not the same as a virtual swap proposal.
> > There is some overlap, they both can do redirection.
> >
> > But they originally aim to solve two different problems. One of the
> > important goals of the swap table is  to allow continuing mTHP swap
> > entry when all the space left is not continues. For the rest of the
> > discusion we call it "continuous mTHP allocator". It allocate
> > continuous swap entry out of non continues file location.
> >
> > Let's say you have a 1G swapfile, all full not available slots.
> > 1) free 4 pages at swap offset 1, 3, 5, 7. All discontiguous spaces
> > add up to 16K.
> > 2) Now allocate one mTHP order 2, 16K in size.
> > Previous allocator can not be satisfied with this requirement. Because
> > the 4 empty slots are not contiguous.
> > Here the redirection and growth of the front swap entry comes in, it
> > is all part of the consideration all alone, not an afterthought.
> > This following step will allow allocating 16K continuous swap entries
> > out of offset [1,3,5,7]
> > 3) We grow the front end part of the swapfile, effectively bump up the
> > max size and add a new cluster of order 2, with a swap table.
> > That is where the front end of the swap and back end file store comes i=
n.
>
> There's no reason why we cannot do the same with virtual swap, even if
> it wasn't the main motivaiton, I don't see why we can't achieve the same
> result.

Yes, they can. By largely copying the swap table approach to achieve
the same result. Before I point out the importance of the memory
overhead of per swap slot entry, the 48 bytes is not production
quality. VS hasn't really made good progress toward shrinking down the
per slot memory usage at a similar level. Not even close. That is
until you propose using the earlier stage of the swap table to compete
with the later stage of the swap table, by using the exact same
approach of the later stage of the swap table. Please don't use swap
table ideas to do a knockoff clone of swap table and take the final
credit. That is very not decent, I don't think that matches the
upstream spirit either. Please respect the originality of the idea and
give credit where it is due, after all, that is how the academic
system is built on.

> > BTW, Please don't accuse me copy cat the name "virtual swapfile". I
> > introduce it here 1/8/2025 before Nhat does:
>
> I don't think anyone cares about the actual names, or accused anyone of
> copycatting anything.

There are repeat projections cast on me as the "after thought", I want
the people who call me "after thought" acknowledge that I am the
"leading thought", the "original thought". Just joking.

> > https://lore.kernel.org/linux-mm/CACePvbX76veOLK82X-_dhOAa52n0OXA1GsFf3=
uv9asuArpoYLw@mail.gmail.com/
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dquote=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > I think we need to have a separation of the swap cache and the backing
> > of IO of the swap file. I call it the "virtual swapfile".
> > It is virtual in two aspect:
> > 1) There is an up front size at swap on, but no up front allocation of
> > the vmalloc array. The array grows as needed.
> > 2) There is a virtual to physical swap entry mapping. The cost is 4
> > bytes per swap entry. But it will solve a lot of problems all
> > together.
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dquote ends =3D=3D=3D=3D=3D=3D=
=3D=3D=3D

The above prior write up nicely sums up the main idea behind VS, would
you agree?

I want to give Nhat the benefit of the doubt that he did not commit
plagiarism. Since now VS has changed strategy to clone swap tables
against swap tables. I would add the points that, please be decent and
be collaborative. Respect the originality of the ideas. If this is in
the academic context, the email sent to the list considers paper
submission, the VS paper would definitely get ding on not properly
citing priory paper of "virtual swapfile" above.

So far team VS haven't participated much on swap table development.
There are a few ack from Nhat, but there is not really any discussion
showing insight of understanding the swap table. Now VS wants to clone
the swap table against the swap table. Why not just join the team swap
table. Really take part of the review of swap table phase N, not just
rubber stamping. Please be collaborative, be decent, do it the proper
upstream way.


> > Correction. Instead of swapfile B, Backend location in swapfile B. in
> > step 5). It only 4 byte. The back end does not have swap cache. The
> > swap cache belong to front end A (8 bytes).
>
> Ack.

Thanks for the Ack.

> > Again, in my description swap slot A has a file backend location
> > pointer points to swapfile B.
> > It is only the bottom half the swap slot B, not the full swap slot. It
> > does not have 8 byte swap entry overhead of B.
>
> Ack.

Thanks for the Ack.

> > Point to another swapfile location backend, not swap entry.(4 bytes)
>
> Ack.

Thanks for the Ack.

> > > Disregarding any specific implementation, any space optimizations tha=
t
> > > can be applied to the swap table (e.g. combining swap count and
> > > swapcache in an 8 byte field) can also be applied to virtual swap. Th=
e
> > > only *real* difference is that with virtual swap we need to store the
> > > swap slot (or zswap entry), while for the current swap table proposal=
 it
> > > is implied by the index of the entry. That's an additional 8 bytes.
> >
> > No, the VS has a smaller design scope. VS does not enable "continous
> > mTHP allocation" . At least that is not mention in any previous VS
> > material.
>
> Why not? Even if it wasn't specifically called out as part of the
> motivation, it still achieves that. What we need for the mTHP swap is to
> have a redirection layer. Both virtual swap or the front-end/back-end
> design achieve that.

Using your magic against you, that is what I call an "after thought"
of the century. Just joking.

Yes, you can do that, by cloning swap tables against swpa tables. It
is just not considered decent in my book. Please be collaborative. Now
I have demonstrated the swap table side is the one with most of the
original ideas and advanced technical designs. Please let the team
swap table finish up what they originally planned, not steal the
thunder at the final glory. If team VS wants to help speed up the
process, since priority is one of VS main considerations, now the
design has been converging to swap tables. Please help reviewing the
swap table landing phases submission. Crew, walk, run. Even if you
want to use the swap table against the swap table. Reviewing landing
swap table code is a good way to understand swap tables. Let the team
swap tables to finish up the original goal. Once swpa tables have the
continue mTHP allocator, we can example any other VS feature can be
added on top of that.

> > With the continues mTHP allocator mention above, it already has the
> > all things VS needed.
> > I am not sure we still need VS if we have "continues mTHP allocator",
> > that is TBD.
>
> As I mentioned above, I think the front-end/back-end swap tables and
> virtual swap are conceptually very similar. The more we discuss this the

Of course very similar, for all we know it is possible they come from
the same source.
https://lore.kernel.org/linux-mm/CACePvbX76veOLK82X-_dhOAa52n0OXA1GsFf3uv9a=
suArpoYLw@mail.gmail.com/

> more I am convinced about this tbh. In both cases we provide an
> indirection layer such that we can change the backend or backing
> swapfile without updating the page tables, and allow thing like mTHP
> swap without having contiguous slots in the swapfile.
>
> >
> > Yes, VS can reuse the physical location pointer by "continues mTHP allo=
cator".
> >
> > The overhead is for above swap table of redirection is 12 bytes not 16 =
bytes.
>
> Honeslty if it boils down to 4 bytes per page, I think that's a really
> small difference.

4 bytes per slot entry difference is leaving free memory on the table.
Why not grab it?
Do you know that all those swap phase II..IV just to save 3 bytes per
slot (and clean up the code in the process)?
4 bytes out of total 8 or 12 bytes that is 33% - 50% difference on the
per solt usage.

> Especially that it doesn't apply to all cases (e.g.
> not the zswap-only case that Google currently uses).

I want to ask a clarifying question here. My understanding is that VS
is always on.
If we are doing zswap-only, does VS still have the 8+4 =3D 12 bytes overhea=
d?

I want to make sure if we are not using the redirection, in the zswap
only case, we shouldn't pay the price for it.
Again that is another free money on the table.

> > > batches). In fact, I think we can use the swap table as the allocator=
 in
> > > the virtual swap space, reusing all the locking and allocation

Yes, you can. Is there a technical difference to do so? If not, why
steal the thunder at finial glory? Why not let swap tables finish up
its course?

> >  In the "continous mTHP allocator" it is just physical location pointer=
,
> >
> > > Another important aspect here, in the simple case the swap table does
> > > have lower overhead than virtual swap (8 bytes vs 16 bytes). Although
> > > the difference isn't large to begin with, I don't think it's always t=
he
> > > case. I think this is only true for the simple case of having a swapp=
ed
> > > out page on a disk swapfile or in a zswap (ghost) swapfile.
> >
> > Please redo your evaluation after reading the above "continuous mTHP al=
loctor".
>
> I did, and if anything I am more convinced that the designs are
> conceptually close. The main difference is that the virtual swap
> approach is more flexible in my opinion because the backend doesn't have
> to be a swapfile, and we don't need "ghost" to use zswap and manage it
> like a swapfile.

It seems the design has converged to the swap table side. Even the
"virtual swapfile" concept could have come from the swap table side.
I'm flattered, copying is the best compliment from the competitor.

Now we settle on the big design, the rest of the design difference is
very small.

Let's discuss the VS virtual swap interface without actual swapfile.

One question:
Does VS virtual swap file expose any swap file interface be referenced
by swap on/off? I assume no, please correct me if you do.

I think it could have downsides.

1) It is not compatible with normal /etc/fstab design. Now you need
seperate init script to enable disable VS.
2) It does not go through swap on/off path. That creates
complications. As we know we have a lot of bugs exposed in the swap
on/off. It is a very tricky business to get it right. I would
recommend staying away from cloning a separate path for the
swapon/off. The VS introduces a new kernel interface that also needs
to be maintained.
3) The customer can't swap files round robin. As we know some
companies are using multiple swap files to reduce the si->lock
contention. If I recall correctly 8 swapfiles. Forcing one virtual
swapfile will force go through the same si->locks has performance
penalties.
4) Having an overall virtual swap file imposes a design challenge in
swap.tiers world. Because it does not have a swapfile, the swapfile
priority does not apply.
5) Keep it simple. Using your magic against you, the ghost swapfile
conceptually can do whatever VS conceptually can do as well. You can
consider the ghost swapfile header is just a config file of the VS to
setup the swapfile. It saves the extra init script posted on users.

BTW, the "ghost swapfile" I will properly rename it back to "virtual
swapfile" in the code, as I earn that term's priority date. And you
don't mind what it is really called.

> > Again 12 bytes using "continues mTHP allocator" frame work.
>
> Ack.

Thanks for the Ack.

>
> >
> > > Now imagine a scenario where we have zswap, SSD, and HDD swapfiles wi=
th
> > > tiering. If a page goes to zswap, then SSD, then HDD, we'll end up wi=
th
> > > 3 swap table entries for a single swapped out page. That's 24 bytes. =
So
> > > the memory overhead is not really constant, it scales with the number=
 of
> > > tiers (as opposed to virtual swap).
> >
> > Nope, Only one front swap entry remain the same, every time it write
> > to a different tier, it only update the back end physical location
> > pointer.
> > It always points to the finial physical location. Only 12 bytes total.
>
> Ack.

Thanks for the Ack. That confirms the swap table side is actually
having the more advanced technical design all alone.

> > Please read the above description regarding the front end and back end
> > split then ask your question again. The "continuous mTHP allocator"
> > above should answer your question.
>
> Yeah, the 8 bytes front-end and 4-bytes backend answer this.

Ack

> > > We can workaround this by having different types of clusters and swap
> > > tables, where "virtual" clusters have 16 bytes instead of 8 bytes per
> > > entry for that, sure.. but at that point we're at significantly more
> > > complexity to end up where virtual swap would have put us.
> >
> > No, that further complicating things. Please don't go there. The front
> > end and back end location split is design to simplify situation like
> > this. It is conceptual much cleaner as well.
>
> Yeah that was mostly hypothetical.

Ack.

>
> >
> > >
> > > Chris, Johannes, Nhat -- please correct me if I am wrong here or if I
> > > missed something. I think the current swap table work by Kairui is
> >
> > Yes, see the above explanation of the "continuous mTHP allocator".
> >
> > > great, and we can reuse it for virtual swap (as I mentioned above). B=
ut
> > > I don't think forcing everything to use a swapfile and extending swap
> > > tables to support indirections and frontend/backend split is the way =
to
> > > go (for the reasons described above).
> >
> > IMHO, it is the way to go if consider mTHP allocating. You have
> > different assumption than mine in my design, I correct your
> > description as much as I can above. I am interested in your opinion
> > after read the above description of "continuous mTHP allocator", which
> > is match the 2024 LSF talk slide regarding swap cache redirecting
> > physical locations.
>
> As I mentioned, I am still very much convinced the designs are
> conceptually very similar and the main difference is whether the
> "backend" is 4 bytes and points at a slot in a swapfile, or a generic
> 8-byte pointer.

Thanks, as I said earlier, I am flattered.

It is of course conceptually it is very close after you copy all the
internal design elements of the swap table approach.

> FWIW, we can use 4 bytes in virtual swap as well if we leave the xarray
> in zswap. 4 bytes is plenty of space for an index into the zswap xarray
> if we no longer use the swap offset. But if we use 8 bytes we can
> actually get rid of the zswap xarray, by merging it with the virtual
> swap xarray, or even stop using xarrays completely if we adopt the
> current swap table allocator for the virtual swap indexes.
>
> As Nhat mentioned earlier, I suspect we'll end up not using any extra
> overhead at all for the zswap-only case, or even reducing the current
> overhead.

In my design there is no extra xarray for zswap, you just have to take
my word for it now. That is very late in the game, finish the swap
table glory first.

Yosry, thank you for driving a good technical discussion. I really enjoy it=
.

I wish the beginning of the discussion went through this path instead.
The multi NACK first ask questions later and the condescending tone at
the beginning of the discussion really upsets me. The me alone facing
four round robin intense arguing doesn't help either. It makes me feel
I am not welcomed. I am short tempered and easily get triggered. I am
sorry for my behavior as well. Just give me a few moments and I will
come to my senses.

The ironic part of the discussion is that the "dead end" is the one
being converging to. The "afterthought" turns out to be "leading
thought". Let that be a lesson for everyone, me included. Be nice to
the people who hold different ideas than yourself.

Looking forward to more discussion like this.

Chris

