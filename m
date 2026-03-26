Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF42510A3D8E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28466B0099; Thu, 26 Mar 2026 08:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8786B00BE; Thu, 26 Mar 2026 08:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE106B00BF; Thu, 26 Mar 2026 08:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AEB3F6B0099
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:50:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2052EE1258
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:50:48 +0000 (UTC)
X-FDA: 84588198576.12.F2AC5D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 88DD640016
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:50:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWlmJ3NV;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774529446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0b2skFabs/4CtTsqIXgO/8OYtEkN0yf4qTcJPYv2xk=;
	b=5/ifZ2r2UD6I9U/q2N7xDj3mbVViobsXpeEG7RA8Mj5a2f/r8e6EckO/7/MIB1L/3OrqgE
	9fdvGswzLieN1eJKfGnCSMEWv449Y9KdqCXXgwld+i9pb7QpppRiXPRdx1csFnir81UIsJ
	ssDMo0ITz3SYSypiIFrTNAShyu7Ati4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774529446; a=rsa-sha256;
	cv=none;
	b=IH3/ftWcxOVvxj1lWD6F3QXVkOlJ6P9vKJbRp6jNhUvsaWkLdCqbKD+fJnR+/jXM9jqXGy
	AsWSRVrUM5SJKBNCVup3qZ9m3Egzuyf9Pf2Bf/apa267WGlHY1TQTmo6kvbqiNZ6SqLrK2
	yLlzaEQB1vxD4a1i+hSCbKXhukaoGnM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWlmJ3NV;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0818B60103;
	Thu, 26 Mar 2026 12:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDAAC116C6;
	Thu, 26 Mar 2026 12:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774529445;
	bh=fwAwjr3dXkS6nTcvpSDPT+VLAsOlThgKRLjNtbS1y6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tWlmJ3NVBYQN1DmR0SAmoowJKAPNPmktqBf6kIJYCdRCbtX3MfX1k7QXj22OQ/HJk
	 vVzblWh/h3n7xlVJ6p2mbbKC6dbkQgGeF/DPTYul8tv7bktrv5NwzHH70T10OZr10a
	 ub0W1yKFdXJN8JQKISAIsfVcZJQQ6rAiPDoglXx9qf9yUojaQbPifpPFTAKYKIKBfA
	 W7NOzfqJKi15oT/HGhj+0vAVAuDwjg1Nm2EHiYLbfYqXh0mutwktoXyrN0TEIWzJ7m
	 h354zUlFK2sVrxEzq/r2hmksfDzRBnQtKnb/nvb4cx0UMvHll7RdxI+JLMhr3pUbAH
	 7/NSKUjmVmbHA==
Date: Thu, 26 Mar 2026 12:50:40 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Josh Law <objecting@objecting.org>, Josh Law <hlcj1234567@gmail.com>, 
	SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
	Greg KH <gregkh@linuxfoundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
Message-ID: <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: pjojg7ze6pjwj4fad9w68n8cukuh9c1p
X-Rspamd-Queue-Id: 88DD640016
X-Rspam-User: 
X-HE-Tag: 1774529446-513491
X-HE-Meta: U2FsdGVkX18oSgUOZv/7ev6jlP4tfZSeoP3MIEwJJsxSwFeyN0cAVKkfAtBFGpAlxR4jZud2qYEqhF7AuxBAvDHByDMlFIIO/6hUtcLpcNedMGiIbslNLvSZ5QFJevwonJXvkhgFzM9+5joq5mbB/PDYQS2drsHdWsvEDxfsB8PhGOEDu1FWscFl6KaYDajsDO8Afyq049xFHyJ1+aggs+yoDBfy2AHmPDjobOu4GGUc9vtt5lRoVzv7DSTRlpYG15jDswy51cvixnh8rnxmrhQl+K0YfNMSSYokrxK+JJkC5xs92/zO79JFjwOpUXyTY18Y8PR1cZnUl3RWlyUAlfDvSObq9r+Q/efow+PdA8iJvOLsyROBNBTp0e/Gjh1T+/Qe0Q1Q0cU0lHQMfZp/DiQyypJnDNC4U77xrjEh8G3gXlerMOMrl3hwwHhUpWyvw0F0oRD1X90XKeAmn+ywhF/IKt9qeGxepewoR1pufX2qB9Ehb5VlVwPzR2DOeDxYAiDeUfEtyftr+r1SiwRzQ58KgRFIX0oaD0pa147Y13omO8hEmQ5JBLEsMkbobaVnCgaDXPCCMFLCkOE39x7/wK3iAwNKgyM8lR2vIM6BtD3XtjgKokEycryHz6rVtUuUd19heunS6s0hOsWhQxAXyGhypKnTlB8ml4k3d4igHDvRxOVKo8gNZyGllGH5z0lVLqmsNWHvDHEvQkTXdTro1TStKN7rHE9EzQMZ/XhG+wjpT7BnnxNsxh87wLBP6b5GTD1KkQOflc0tLZNu2SeVNbq9BmNE863G4haU7BhqNBnS7U7G9C2cgDE5/gjAw4bLshl6aLtOCFKuSqIV0v9KXf99ZuiNz7QSFhVOaLDiupe+juCUZ3R4rdQ56k/wDcA+mZvRY7JEnHAp2AXn397nzq3cdyPPJXfEB2sF1jQbtN0TxqEdggEwkGXARTQ1ThiMK9sej24uWMoKe5mW69s
 ygIbGKIu
 l56gzOqph51M3H6anJ9eh+2UIzRQfuKT0Tb8iBXZVETfn9tQzNsOBZ2VoDWPtVjYvZw+ef3R/YARky8/gdYmsEpnt8EVCR7jQdkkGkU6pcc8alvYPVc6cl29CYRYNKkPaa153npOTHUMK7rifZxrvl9yHUMl7r/QMlLhHz7ebUByp8xRdhU0Hlfnk7boCc+ib+u6jgHlR6Pzurpafi+Bfy+47Jeyk2Y76l6UfIajR02Q++6T7s/klFy4mPmlCeGxddgDpgzgIqHZjLCLjULK/fKKBZOcCOH0EHQLBs0FNEyeeKqha+bzwBUi37xpJwrDcSTS0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 01:40:19PM +0100, Krzysztof Kozlowski wrote:
> On 26/03/2026 13:29, Lorenzo Stoakes (Oracle) wrote:
> >>
> >> Answering to reviewers with whatever confirmation they look for is also
> >> a warning sign of non-trustworthy behavior. Or rather behavior trying to
> >> get trust.
> >>
> >> [1]
> >> https://lore.kernel.org/all/D47F8215-FD08-45ED-AB01-0A5C48CD41DD@objecting.org/
> >>
> >> [2]
> >> https://lore.kernel.org/all/2F84DD09-2880-45E0-AA98-204F10848F85@objecting.org/
> >>
> >> Best regards,
> >> Krzysztof
> >
> > Yeah this is really adding up to somebody abusing the kernel process. I think
> > 'Josh Law' or any other pseudonym that can be traced back to whoever's behind
> > this should be banned from the mailing list altogether.
> >
> > Also, as per Christian ([3]), it seems this guy was using the pseudonym
> > "techyguyperplexable".
>
> Yes, repos on that Github carry commits like:
>
> commit c04af501bacbef54cf97cdfb904ddf295f8327c1
> Author:     techyguyperplexable <objecting@objecting.org>
> AuthorDate: Sun Jan 11 04:21:53 2026 +0530
> Commit:     techyguyperplexable <objecting@objecting.org>
> CommitDate: Sun Jan 11 04:21:53 2026 +0530
>
>     ANDROID: sched/rt: reduce lock hold time in update_curr_rt
>
>     Move resched_curr and do_start_rt_bandwidth outside the spinlock
>     critical section to reduce lock contention
>
>     Change-Id: I8dfb4e33460ae4eeb0bb854cc2cb084ab5edf7e4
>     Signed-off-by: techyguyperplexable <objecting@objecting.org>
>

Thanks, it looks pretty clear cut then that 'Josh Law' is an openclaw bot.

To think he was scheduled to be added as a reviewer for literally all of lib/
recently (5) until various of us pushed back on it :/

[5]: https://lore.kernel.org/all/20260308202425.C9EE4C116C6@smtp.kernel.org/

Is it really that easy to game the system?...

I hate the asymmetry of this - we have to jump on these every time and they can
send WAY more mail than we can reasonably reply to.

I think we need a clear 'yeeting' mechanism to block these people on everything
once discovered.

Sadly the kernel has been historically very poor on getting rid of problem
people (The CoC is essentially a swear monitor at this stage).

In the face of this new kind of threat we probably need to do a lot better.

> >
> > There's a github with the same name ([4]), and that same user made a comment on an
> > openclaw issue relating to linking it to gemini ([5]).
> >
> > So it seems likely he/she is likely using openclaw to fully automate this 'Josh
> > Law' user and we're speaking to a bot here.
> >
> > (Screenshots have been taken for the (possibly inevitable) deleting that will
> > happen later.)
> >
> > [3]:https://lore.kernel.org/all/20260313-halskette-annahme-94e782eb4ae4@brauner/
> > [4]:https://github.com/techyguyperplexable
> > [5]:https://github.com/openclaw/openclaw/issues/44134#issuecomment-4106247302
>
>
>
> Best regards,
> Krzysztof

Thanks, Lorenzo

