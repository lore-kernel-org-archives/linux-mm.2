Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53737C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB106B0190; Tue, 18 Aug 2026 10:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2776B0195; Tue, 18 Aug 2026 10:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C92F6B0197; Tue, 18 Aug 2026 10:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 044EE6B0190
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:34:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72D23120139
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:34:08 +0000 (UTC)
X-FDA: 85114634976.27.0F2B91D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B7B67100012
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:34:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhGeoaoh;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787063646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5o59A+iUFyU+31kYkokmEB51xD/MimpJJEfveQW/Usw=;
	b=fpS4av+1JWvXceeYFWLj8Xanz+DADQKffNagmTz/ntiHuAdoMGZAjtw6Kuo8xzXlCLIWqT
	JCo9msknNzQQquVSXccOc1Y4CI5Dc2PYRQwErrdjcwGTl78s4vN447f2GboNkgXCP45RIC
	cBe7wmnbCBb+8vkTH9clkmeRfFfxc6E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787063646;
	b=E6U6WizQ/bsGaNKAPbxsgBax9z8k2mSPLE4UwXn5vR1+vo1331iDD2Gn82/VcfmuyC0vdx
	IaaYTV9vW4pD0DDI3tctTQ9du/XpuIrS4fAql+nohgOOoADT4AcKbTQQMnznbAe1Psh9CU
	QtePBG1FBpAz25rUQ+rge+lPO5jhSf0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhGeoaoh;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC6E7419D6;
	Tue, 18 Aug 2026 14:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA871F000E9;
	Tue, 18 Aug 2026 14:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787063645;
	bh=5o59A+iUFyU+31kYkokmEB51xD/MimpJJEfveQW/Usw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JhGeoaohI/G+QkNhEO8WhJsLjSEb99kxRI07DwXVljsOzC8bWSYW+Un3eLGngrkOE
	 yuagroV1ZxBYVVEjDdhsft0MTk4GKGkD+1qshw8yoRmCnzhHfRF2cUbC0ImoDZJR2n
	 ydvSNeckFrVeepxoEWrG9GF8PzFUlIHPc1exetk0wJHXVctTR9oYJPbQUcHBTQNPp2
	 HzGfG6l6k5c3wzOhjh+NlaTiALRN/PSEo9QUicLT+u3ycoiQkdYCicTyBgaJ8WURdb
	 xfUec6UMt094VaNCpDCBIzPgXSE0GiVWPM2G5pnIXECz/zCO/q5mio3oY0PDA9BMOK
	 cN/keMp8JTxjA==
Date: Tue, 18 Aug 2026 15:33:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, 
	usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoRqByutFcW61Vag@lucifer>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
 <aoLkMUtmzRVuv2Hx@thinkstation>
 <aoQ77EcD3M2kjeya@lucifer>
 <0153303d-f9d6-45ea-a276-fbf2e5625ef9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0153303d-f9d6-45ea-a276-fbf2e5625ef9@kernel.org>
X-Rspam-User: 
X-Stat-Signature: of4xu7s31jaco9ym4hsg7sj3wnjykq6g
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B7B67100012
X-HE-Tag: 1787063646-940662
X-HE-Meta: U2FsdGVkX1/AQgnYxG4qm7LBHS0LsrNNlzRmVLSY5RLUAWXWPwYhfY+iYOVtzWinIcS31WK7vWrFjhBgKC8Bf+fjT1ZbiRTY+aW7FqULZTzIEPflNeY9b0+RuD0tP1IUTB7GcZSQUMcYg+lpWgY3yBLX3hucnhGwrHZHT0e14jmMGqGCuFvkKDP5Aa47kw1ggV9IMBgRcH4U+o+1xBbypIrCgQSEsytkqm5SFYxPsr6QK2mWKAcoAYl4YmGdZOnmAu8bfiP2WnVPqB0fasEI1wQeFtADpU69+lPdIn+d+XTiwY08xIq6uwH52Wk2Ao7hlzS5mNXjCSmaNRdR3vcQKHHhNAzCO09PylIhYPzQUGFQhly+4WivpTMIxajWtAPsMS1BC4/sBwsLzB+zrukSoPYqdUYAnupQyLrk3JZS0TbysGEF9xveXPXdI/AI1Q1atTW5zkpeZllxr/56D8JLfAcXxDRDXN/Yvhwrve7RmACJP2kIapCuwfAUkqk3paiw23natmFqKR6eIgZKvnFtgu8We4VQKZFpeqs6AuuUUV2wfoWJ6uZ/fwTsNGOXiAJLQuUYsbhXQPHiFef/aJujHqC9GmqWYjJ0pXkd4ldH1kLmAIGlDSsGOtC17E3h6ffipXwaDoE7cEDHtQJyjn2E6v9OYG9+N9a6liOqZP9qEB5qFMcSIvgUWtYivsG4fq3KacRl/e0A8OzUdtWcIExtEHSemgg3SlUs1JL7EPkkrGKOfKbgyjhskMS2xyRPP3cG9H3a3RK5LVXoGlt5c8ca8svLEwxuISCiYdy5HVetuAtJ75L/LLT79GfdJapaZou7xCcCVlTQX6nbEZEJyXjk+CKViHTofsAB2DwAzfBMZLkCXAaT0sMCNQla1gB9f5lsi9MuTZgwfZDeL+WhIPy8hqvPy0KjRiHLgc+eCzPq9PyUAELi2McYCna9Y7m9CkDPz6l/0fayT/znSqcZ1xy
 J7PcbI3T
 ebUIp2gQeFLEPrszNnoz8Qf0Su/YncHDMIfd93b0wVi4Xpa16Y0UyTxP9HI85jhAzIAwUuN2cbcpdxaiGXV+9IeDWUqFwiEqQlPofbDhPe0Ps0muJLJSrBXFPNBoJd456dxpEzqSa0IzHdX1WeDghChWr0IEK4vVPqvJ/ysLrOE/rMO/8kwJ/LwWKJexOCiSd99i842DpOiYHDoUzHqgyTApdIGhjnVGGuF4HE6bOmX99bNwo9JP+XRVsMZcGL5Wdc3qM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 04:12:17PM +0200, David Hildenbrand (Arm) wrote:
> On 8/18/26 15:06, Lorenzo Stoakes (ARM) wrote:
> > (I'll reply to the rest of this later)
> >
> > On Mon, Aug 17, 2026 at 02:38:44PM +0100, Kiryl Shutsemau wrote:
> >> David and I talked about this at LSF/MM.  I can give it a try if it fits
> >> your idea of "feature freeze" -- and if it doesn't collide with the series
> >> you have in flight, in which case I'd rather go after yours than around it.
> >
> > Whether intended or not you sound rather like you are trying to override me
> > in favour of my co-maintainer here and it's... not helpful.
>
> I think Kiryl tried to say that we discussed at LSF/MM which areas of MM scream
> for an improvement, and we discussed that khugepaged is just horrible code.

Yes, and obviously I agree with that very much!

>
> I think we all agree that there is a lot of room for improvement, but the big
> question is:
>
> (a) When does it stop being a cleanup and is a new feature in disguise that
>     makes the code more complicated and even harder to maintain.
>
> (b) Can it just naturally be made looking like a cleanup.

Right and point (a) is exactly my pushback here.

And it's not always so easy to separate.

>
> Ideally, we'd get b), in small, nice-to-review chunks that incrementally improve
> the code without inflating it heavily or moving everything around.

Yep.

>
> The current locking is nasty, so anything that moves us one step closer into
> something that is not only simpler but also more scalable is nice. I am a bit
> concerned with the churn in the series as is.

Yes.

What I'm saying is, essentially, go read the code. Go see how coupled things
are. Go read the functions that require you to keep a giant stack of
state to even know what's going on.

Look at the bug rate, and how subtle the bugs are - essentially - 'behold the
horrors' :)

And rather than being opposed to fundamental reworks (actually - it's the exact
opposite - I think THP needs changing from top-to-bottom):

Based on experience of seeing work done in THP - we are _making it worse_ when
we add features without paying down this debt.

I think it's nuanced, because as part of reworking things (you say this below
too), patterns and approaches can fall out.

And you can naturally lead things towards a sensible rework.

>
> After this series, mm/collapse.c itself is way larger than just mm/khugepaged.c
> originally, which raises some eyebrows.

Yeah exactly.

>
> We should also be aware that people are proposing file/shmem mTHP collapse, so
> ideally what we refactor would naturally unify some of these code paths.

Right yes. There's no harm in _laying the foundations_ for future changes.

In fact a lot of reworks are about doing exactly that - you can often go one of
2 paths:

	a. push the feature in as some tacked-on thing that works but adds
	   complexity/maintainership overhhead/etc. or

	b. Change the architecture to suit the feature you intend.

So my opposition is to a, not b.

>
> I am wondering whether shmem mTHP collapse should come first. (I'm hoping that
> shmem mTHP collapse can unify some of the anon+file collapse code in a nice way,
> to similarly just look like a cleanup while enabling a new scenario. Which is
> really what I am hoping for because the current code is A MESS with weirdly
> named functions all over the place. I hope it can be unified somehow ... and
> that needs some proper thought)

Yes.

And to be clear and I am going to say this in my (proper) reply to Kiryl - I do
think moving away from the presumption of PMD collapse is _key_ to a more
general rework.

But it's about how we get there, how the rest of the code looks, what other work
we do around it.

>
> >
> > David and I co-maintain THP together, are in constant communication, and
> > have a great working relationship :)
>
> Yes! :)

:)

>
> >
> > IOW - if one of us states a position on the sub(sub?)system - then take
> > that to be the actual position.
> >
> > I have poured what must be hundreds of hours now into THP maintainership -
> > it's by far my biggest workload on the maintenance front, by far the most
> > painful and by far the most thankless.
> >
> > I do it because I care about mm a great deal and am, frankly, driven by a
> > desire to see THP turn from a flaming trash pile of a code base with
> > confusing semantics and many, many broken parts into something that serves
> > the community's needs with far less maintenance burden.
> >
> > Looking over your series it seems some of the patches works in this
> > direction (great!), but much else of it fundamentally changes key
> > behaviour.
>
> Agreed, I think we really should unify+cleanup the existing code first before
> doing more drastic changes.
>
> Having a series that throws all of khugepaged.c into a mixer and pours something
> new into collapse.c is ... concerning :)
>
> But I am sure there is a way to incrementally improve the code? At least that's
> what I hope.

Yes. And it does look like a lot of the early patches are along the right road.

I do plan to do some proper feedback on this series along the lines of figuring
out how we move this forwards.

>
> >
> > So it's just a question of deferring the latter until we get to a sane
> > point with the former.
> Thanks Lorenzo.
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

