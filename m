Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23934F506D5
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6911F6B02B2; Mon, 16 Mar 2026 10:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672886B02B4; Mon, 16 Mar 2026 10:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F206B02B5; Mon, 16 Mar 2026 10:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4978E6B02B2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:16:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCDD58A78E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:16:25 +0000 (UTC)
X-FDA: 84552126330.05.1532446
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E833980013
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:16:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dv1o6m9N;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773670584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cilkpyBHTl8FoLZ6zf1SV8BbTFy7E3q8+hYxDhT77jo=;
	b=Us5XlXaqG9vkVTfpz2Y3y6WwWTyo8tA0vJFKJcf4SZTfqKXH5pa7Uzn+56CGIEIwA9LPmw
	AaU4XiNFq9a39OAZCbA2kWwbwiX8hdNoltrVllmz86/MpovIJY8txPcuUaZA78lcHifelJ
	zmmfb/u92wdkNpuVoFXeSZwcTZVWUHc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773670584; a=rsa-sha256;
	cv=none;
	b=AIM/0m/9V06KeUk4c8aKAe9MrgxOlS0GaFKEyqBYGPTOTRmZCX3quhtdXk3BP2qYFAr3RI
	OvYyjm0xwd3MygaIp0c5X1RkUGdyksRFkJaRLvdMj710e79CGjS71u9Bb0tRZ8TUVUwXgz
	GtKkE0xzfkSU2tJjxhsmNzNWc593xd0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dv1o6m9N;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 222DB44453;
	Mon, 16 Mar 2026 14:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C52C19425;
	Mon, 16 Mar 2026 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773670583;
	bh=cilkpyBHTl8FoLZ6zf1SV8BbTFy7E3q8+hYxDhT77jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dv1o6m9NWt1UNoSa/4Fp/YfDfexuelCFbQZtpueejINBiYZG7R29aXbA0zF4RSc1L
	 xXQkoo0g77KJvVh9veX7Q3cu6O4lRHQ4R4IAoscKIFHeS9puOoPduYIvwUzOfWbgxr
	 Xx1EmYKhMMLhDHVYgYp5JLt0M2QnkpUCxdUMgDF31VInCM098XXtwr5A8tze8TB8YO
	 nsekd3vpxKXxm/WAbcvsH+tN2NmQKGZxMgXFcahjK82guNXIp0ATw7Pr2kaHmLICvA
	 kUAOYtn/ajGvXMxjZBEIodSkGfwU+7GHCUmVbL7kGVxKxi07IdWbOxydOR99sOHAlr
	 4BP7eFDbFYjWA==
Date: Mon, 16 Mar 2026 14:16:19 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Kit Dallege <xaum.io@gmail.com>, akpm@linux-foundation.org, 
	david@kernel.org, corbet@lwn.net, linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm: document the OOM killer
Message-ID: <31744315-bf9e-4d9a-9c25-63eef0bd2f01@lucifer.local>
References: <20260314152518.100194-1-xaum.io@gmail.com>
 <fbee0ca1-4de6-4182-865b-a33d9ed32ee4@lucifer.local>
 <abeyD1ZngYhkAx6g@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abeyD1ZngYhkAx6g@tiehlicka>
X-Rspam-User: 
X-Stat-Signature: fhqfccx1qcqz8ehdbuoxeg8xif8oo77r
X-Rspamd-Queue-Id: E833980013
X-Rspamd-Server: rspam03
X-HE-Tag: 1773670583-470801
X-HE-Meta: U2FsdGVkX1/92UFXzcuaUyw9WtH9OBTjmgKhox84zhHZPt6eKgsmnJnT/N63WCf44RqTn/9HJUjEsaoNbupy2WEiKFlk0b7/Ef5ylsxV9VrnSXJ5K8QJLKOk6jwqDpPiJPiqN2oexsl+20xzmilH0puTFaKrvRX25J1SnNaGmdIH4DCNcC8DG7Df5ERxPzOLaBOArP3v0ouPkEkVaYUsNXMd/HIp/BweOrSPcuVoCIvmF+Mi3Dn0F7RwX5i9a1CM6xq9xzquhecUQSdrJZqxA44MzjXmj2RUVgWeTC3Z67GVySGDly2HOVEO2W5fqzggYitCfJakXkiCQWqonf2x89r0Mn9xNSrVJmQQ43w+pOSIzdCl+Kfx+f2aHex6vz/vuKL+xgcYP4nQUk4J4UcPyrAYQ8FWZBGf7HBdO9zTzH3XncoI3QDVFKYI63T6JtmXZKhmQOoqFhlD++TB8FSKGrIyIIpbwh0klHOLtWsXqAwrY5560t7DIEcfVRLvmVDn5/g8Yv/FcCwS9Y9/eEhYHPCeUC8FW/jz8t3hz4A57I5g8Bz1SP2H/JQOeqV2LhQjfzvgmmWm+QLVCvsCRidYuzVNXDgTjdI/a6X8fAGJ07T7QtdmdLLF3NCyN4yebLdgIQjydT5/K8tdLVCMuAONRPLR+xzkUg2tgbNpJXmDmojVZY3CTMswwWkCAr4s+zPu0mAcu/cMmxrN3wjhwyi3xk7J9ixdc0WmkkFtfMWE+KkEc+efEpzTURyrFChspxHY3qnZUqvt+Zm8IrMq2+xlBg13s0CIDOnPB2g4qjpN26gWOOb50QdK6sgj5RAVJmPgdXg91nuzcXr/mr7qi2nCLNQ2qKM6Z40a8Ut49qErKfSYgQbEdjYLDTBxMBpXB/Gh/dg6x5t/r4E7ox8e92hZQJCZXqQ+ZFoqVdbvzNvv7tZO5nEtFgzs57oNKv5lUm8FVz9J6IoEyRyXgDwjsQ5
 SUwWd2yy
 cWTtsojz4euYiFIoV/vrqtEIHB2LTlTPImtHfPhkg1w6kHR+QxejzpVqNQYrhKwg52yoF5tNo2z7+zD2MPo8WqkVOAyE7SK2kSmnQNCWmAy/E5Bsf5Xd3SQ1viDbAKkbUChJZzBzxisbsnRWUgUuK3aMWYCVj+77DFVHOaau1Q4N5q4S0zuL3UazsxVoIZy1mvNNHyx193RHLGfAiW6+f3LGM+h2u1S6iP8PAV+GxgExqmuUFZtgsyJ//k46bG2FpUWjF1NnCWhUNRIk4aL/0RNuBYMRczD+8e3rK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 08:32:31AM +0100, Michal Hocko wrote:
> On Sun 15-03-26 20:48:22, Lorenzo Stoakes (Oracle) wrote:
> > NAK for being AI slop again, obviously.
> >
> > Again, +cc the OOM maintainer you failed to bother to look up.
>
> Thanks!

No problem!

>
> > Reasons, as the rest:
> > - Worthless documentation
> > - Everything about patch screams 'zero effort, Claude did it all'
> > - Bad etiquette
> >
> > As with all the rest it'd need to be totally rewritten and it's not worth the
> > maintainer time.
> >
> > On Sat, Mar 14, 2026 at 04:25:18PM +0100, Kit Dallege wrote:
> > > Fill in the oom.rst stub that was created in commit 481cc97349d6
> > > ("mm,doc: Add new documentation structure") as part of the structured
> > > memory management documentation following Mel Gorman's book outline.
> >
> > I mean the more I see it the more annoying it is.
> >
> > >
> > > Cover the scoring heuristic, allocation constraints, OOM reaper,
> > > process_mrelease syscall, and sysctl knobs.
> >
> > This sentence contains almost as much content as the patch.
>
> The real question is who is the expected audience of this documentation?
> Administrators, kernel developers?
> Reading through this proposal this doesn't really seem to fit neither
> well. For kernel developers who try to wrap their heads around the code
> it is barely scratches the surface. For admins it doesn't really explain
> more than an existing documentation for tunables.
>
> So if there is a serious interest to make this useful kernel developers
> oriented documentation I am more than willing to help. The code is not
> really easy to follow as it is scattered. There are many subtle
> expectations spread out and it is quite easy to break a delicate balance
> tuned for through years. So there is a big documentatin gap I never got
> around to fill up.

I mean, we definitely could do with better documentation :) Obviously I
somewhat document it from a 'learning the code in depth' perspective in my
book, but that's tied to v6.0, effectively paywalled (sorry!) and not the
same as the kind of documentation we'd ideally like the kernel to expose,
which would be less specific I thik but also up-to-date with newer kernels.

The point WRT this patch however is that really, it needs to come from
somebody who has some experience/understanding, and generating it via an
LLM is just not useful - any kernel developer with understanding could do
so.

Otherwise we end up with:

1. generated LLM documentation sent without understanding
2. maintainers have to essentially rewrite the whole documentation ourselves

And thus we essentially have the work dictated to us, but credited
elsewhere (not that credit matters all that much in the end, but it's the
principle of the thing).

So while we want documentation, we don't want _any_ documentation :P

Speaking about docs more broadly - as usual we're all so busy it's a bit of
a catch-22, though once we have something in place, iterating it won't be
so hard.

I wonder if some of us (I realise this sounds like self volunteering)
should just write up some bare bones and patch it in, then we can get the
iterating part of things moving?

>
> --
> Michal Hocko
> SUSE Labs

Cheers, Lorenzo

