Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49BFFC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 13:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13436B0093; Mon, 20 Jul 2026 09:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4F36B0095; Mon, 20 Jul 2026 09:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA3A6B0098; Mon, 20 Jul 2026 09:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B79E76B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:04:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36E1E80182
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:04:08 +0000 (UTC)
X-FDA: 85009172976.27.292BF66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 801DF1C0002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:04:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBjnSe1d;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784552646;
	b=OqqywPJbHJ3GFj4f23xO7LcjIQDeGPzbQ74pfjZLnxkoqZMDfwYC0m0cH1yGDkZmzGbdyo
	Aqb5Nq7dhez3BzqpKK9vg5GGKrEFbDREylEY2D5bbQbgLCuAF+wdcbv4HRAT+/g2QmFg0h
	DJvvQ/03uorNRHSEWkKRYXxoZOwW68I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBjnSe1d;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784552646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SICMuK0Og2SbVQNzjOkqW0F8oWy8F1pFz/0ehxr0IRE=;
	b=D2113TT94Tc9o81G88dROnlhSRNz2nZ8XZKArX+t8FdkhtYm0kuCKOcbCmhsfLXDM1tYHx
	s7bzPsvEVhZSAAPeBpsMmfk5DqQA7grOc4xMxhKo6DR9HBkBE84y9+WXIEWlq5KwYVmGPH
	ESxuCgQN1vc0LLXn/kcBBr6vlnQfntc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEF2B60A84;
	Mon, 20 Jul 2026 13:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B0B1F00A3A;
	Mon, 20 Jul 2026 13:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784552645;
	bh=SICMuK0Og2SbVQNzjOkqW0F8oWy8F1pFz/0ehxr0IRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aBjnSe1d7umy7QyWgAaGrXFQYwN+UFq/JRRmb36ntmzZ5yvuVWJPOdP7rj4h3k/6d
	 f4vQwoNK1jS1fLdrwfZaOue1WqOy2LCGptMViuqNddcrm5Jc+wV6llXACBr5d7pWof
	 NLospFh1vtxjjQjNxLL8RP33G/ECbWN+lv46Cw8cUCLXNTQFb0BVoKe+SWcmf3CvHJ
	 ttJSmx3PPDjCNejLV1REAmWJPZ3XpdCovWMdtMZwkGtAgrwzsicTFrxkTmrVUKnr8b
	 QJJf0jR6d7pTRXCanwVL+nvaZ5SepqsbizFbuWWGiHC4tWGcQVBNW2DTYBUBgQTgdx
	 QAnVUOQn7XXVw==
Date: Mon, 20 Jul 2026 14:03:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Subject: [ANNOUNCE/CFP] LPC 2026 Kernel Memory Management Microconference
 (reminder)
Message-ID: <al4HTMtzpDHykhbI@lucifer>
References: <e3dc73df-0032-4e71-ab80-21b29c6efb46@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3dc73df-0032-4e71-ab80-21b29c6efb46@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 801DF1C0002
X-Stat-Signature: q4ffsqp1jmeph4kcnjw4afxo33o9m3sz
X-Rspam-User: 
X-HE-Tag: 1784552646-446634
X-HE-Meta: U2FsdGVkX1/zfKkNOUdQzJIAhhDw/FkWtMRPxN3LOmXkk/Cm9D6qu51XcYwvNtNeZ6onUBup+jdSLkYdx+2FUucq3H/kl+yrveZ8hHdVScsfzUyfgzjU6TYdMpNSIzsHh5BISOeWKcv5wCa00IFp25+Yzw5wYXGbTtb3aMHcwh6sKnSi6AxzSpXdm5egLhW6DRDIJT/sSeOVd8OjKiVY+PwKoExINFyGu/+fLpyqJyIzqt7ML6Jy1a5tc3uaP3a9hOafLSGRUrtf2BOfxGPAs+ILEw+5ruRQiBU4qoWYCjtoOPz10uNwYVV44TkMAerompK88BK7qqBeSqIhlp2BJWtmxBylEAvO9psz4HW4oiN6ASCP72Gcv5Zo46tUYfF7qkn9NpmFRPYOuKjekDtmlSf32pTPjnF6D5DJohUf+J7dlv6o1laucjWFfTFddMcOtfDFhuyjbsPw3B0muLDyiBsyAAvyWX+vzjVcp/m86mHBAy3djVeS1oCTT3NUkR6mQZhbv7A8vpq/NSs1oaQBX6nV1Vst5Be2e4k6hmrG0f64KWHCBYalhg5SVNhJCHxgfsPyJfY6ccNq5dVg+mpIgtOGSm8M9SBcKXWQFWBkYc1geH9ONfmNsJWG79bwZCb+GUrbVS3EmLDkIf9Jp28duJRqtvwEPAM+GaWju6a+eiZ3Uzt4w0Ye8Slnco5vM7D6aokF9X0RWrukCO7ryA1y7MDrF/j4uCuilzgsezXgKqT9nkoS/HFK3mE46jZlKlCspGv10jOVyxddiW6vElJeVjCD3ZBM01OmEmLs2AG00iJsxVjiFdRS21x4wWfCa7F3ERCPMd5aKs2qypzJak5iZTXebvO+wTEX2L11Md0ToXCjSXu4B6nbvB0EOnOl8mVcCWhPl0ic7X/bFuYwTrTblE8ytN8cUbpdmGIPRgcP9C/qNoUA1QAi1pDaJb3Ba8Yw9xuPNZ58q79znn/XqIX
 f57uf17R
 vDwWEXU91AwFRdpbhQH6sAA9y96v/+mewxeubLqR5UyZKUqdS5u9SbK5hbJaCEt5KQiFW5po+WEdKNm7cVL+HukEHaA1m5NgRd5uRZ6vIxrOe7ZI+ufVP8NljRJIraL0SXdMRtcxcoThp2dMNr7RbdbvgyXLR51BqiIBey3rnZK4sq4aiNKW3ukrLPaLir778llTIMMyTnBgoYHSvAgJlWVu7omybtiii3S1em0vVi14QXHmK+Xu4E7cGs/WOWGUtyaUEv4sIj0yZtuj3KSFshoL7CI65U0Imj7zhCyw4hzltX2wTFyHgZfhNL8Jcwvw/N04q/ZR5tw5BwDkXMDhP9jJT25N0miUR3mVaydmFP8lL7RGpOxnQfPEypA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just a reminder for everybody to send their proposals in before the deadline on
July 24th! :)

See below for guidelines.

Cheers, Lorenzo

On Mon, May 18, 2026 at 11:26:21PM +0200, David Hildenbrand (Arm) wrote:
> Hi,
>
> We are happy to announce yet another instance of the
>
> 	Kernel Memory Management Microconference [1]
>
> Co-lead by Lorenzo Stoakes and myself at the Linux Plumbers Conference
> (LPC), October 5-7, Prague, Czechia [2].
>
> Due to our past experience with remote presentations, we will only
> accept in-person talks, unfortunately.
>
> We are looking for topics that would be of interest to the kernel
> memory-management community.
>
> We are also interested in topic suggestion from outside the core kernel
> community - if you have something interesting to present related to memory
> management in userspace, driver code, architectural code or anywhere else that
> touches kernel memory management we'd love to hear from you!
>
> Examples of topics that might be worth discussing this year include:
>
>  * Making (m)THP/large folios first-class citizens
>  * Supporting gigabyte THPs: allocators, compaction, policies
>  * Better policies: applying eBPF and friends sensibly in MM
>  * Polishing memory reclaim: making MGLRU less special
>  * Ongoing challenges with memdescs conversion
>  * Can we make device memory less special?
>  * Letting the kernel manage special-purpose memory
>  * Improving page promotion/demotion for memory tiering
>  * Challenges with hypervisor live-update integration
>  * Towards deprecating hugetlb: mshare, memory reserves
>  * The future of swap: missing pieces, cleanups, and do we still need zram?
>  * The future of memcg: new resources, optimizations, and cleanups
>  * Doing more with less memory (RAM is getting expensive ...)
>
> Please submit your proposals at:
>
> 	https://lpc.events/event/20/abstracts/
>
> and select "Kernel Memory Management MC" as the track.
>
> Please submit your proposals by July 24th to give us time to schedule talks in
> advance of the conference.
>
> We greatly value interaction - talks are meant to be dialogues between the
> speaker and the audience. Therefore, plan to leave AT LEAST 1/3 of your slot
> (likely 30min, tbd) open for discussion. We intend to be strict about enforcing
> this :)
>
> Please ensure your slides aren't too dense - people take away more when you use
> fewer words, and that also helps the discussion!
>
> We are looking forward to your proposals and seeing you in Prague!
>
>
> Note: make sure to register early, ideally before the announcement of topics.
> Usually the conference organizers ensure that all speakers are able to
> register, but the conference is very popular and it's been a close run thing in
> the past, so registering early is the safest option.
>
> [1] https://lpc.events/event/20/contributions/2337/
> [2] https://lpc.events/
>
> --
> Cheers,
>
> David
>

