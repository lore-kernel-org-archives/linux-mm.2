Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B503F30282
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813C16B00B6; Sun, 15 Mar 2026 16:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4476B00B7; Sun, 15 Mar 2026 16:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BFEC6B00B8; Sun, 15 Mar 2026 16:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 586BE6B00B6
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:03:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 006FB160C93
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:03:11 +0000 (UTC)
X-FDA: 84549371382.27.C62AC0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5C5CE1C000E
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:03:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OxYeWLLQ;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773604990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UTh9CFYTRvK+HLM7RD707ytFkh3DIqV6R3eeCGPkE0=;
	b=3M+hRzpRhaes99d93BA4JOqmjti6OBEzsrELE/WKD0iVr1sXyMSwRtV/K1u3JfpioT6eWS
	Z7AX7u6glW6/igWfty9sy+PbyuKGtNafzRl7GigVwCKzuSGlyKFctG7RWsdfqTV2Y3Bg+g
	LSiPtvBFCvUbaV0u8BiM7Kox0gKv9a8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OxYeWLLQ;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773604990; a=rsa-sha256;
	cv=none;
	b=1r1qoosXYe29WhiCqUq9n1reYepzzrmJKIE6AH+17AmuvQPsThEQJAQsvBbDOxEBl4MB2H
	ejAxsltwL9IPhh+MH2+Z7V9f2+KtyFA2EjyyXTqfNokPOQOqhQnpnPlfgkwi5FsFZ9SrwD
	bUU3a1mAi0HfYL0vy97HExLyU6Ex/x8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F1D142DA1;
	Sun, 15 Mar 2026 20:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CE1C4CEF7;
	Sun, 15 Mar 2026 20:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773604989;
	bh=5EoTqlA1WXTqcUjjWB3Eb61kCIejimTFL0AFLyVl9d8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OxYeWLLQl0LUpjvS1/O749K4IZdEisHErvtF7b4urHF+jMe1Esbsmc1nInxY/rrKj
	 7gyAnpCTONSsufuBgRY/jNjvSK4nJwtwnd6l7V6fnUcmMCePOazh7FHe8nHfECBDc3
	 990cyBMepSTDZT95/MPV77xeFsCe5WZtxLc2jEN8JNGdLauWb4YwQHqt6FUhDkK9zp
	 Qsha7FeTxwwwzdQjtSKnoUtNDZZNRT+bRNBZDzOuTKZt7WKKTRrETfIBGKpEJyKeFC
	 HyDCLqw4Gqi75OwpIRrICIMbYwhAz1lugRwB3BAITacoeOFmbilAWh8mLqAugsoFdv
	 7g2Q4MrBWHGyA==
Date: Sun, 15 Mar 2026 22:03:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kit Dallege <xaum.io@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
Message-ID: <abcQdr4UD4znorRN@kernel.org>
References: <20260314152538.100593-1-xaum.io@gmail.com>
 <87ms0ajtvy.fsf@trenco.lwn.net>
 <CAAZVx98Sz1MknCcMpQXxeGpUjXBDyz+0KyRuUiCXsM+3qzqpeA@mail.gmail.com>
 <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
 <09920346-0caf-466f-9c12-5f086d99411b@kernel.org>
 <abcPusHClDoCeE4Y@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abcPusHClDoCeE4Y@kernel.org>
X-Rspamd-Queue-Id: 5C5CE1C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: mdgwzjht6iiqmgc6p9gz99tic7jqocdz
X-Rspam-User: 
X-HE-Tag: 1773604990-117411
X-HE-Meta: U2FsdGVkX1/OXHsdpswSeYQHaWmWHG5eWlVv+pWWxaACL3hRtF5zm7wQT4w6anRcFv0wxIjTYdfMwkzclrJ9TvWZEQ3vTIafRYPPDXnNs3RY3LOTm78wmhN9nUCUxFoe/dLjayV2/n18v+pbmQLHMHuIOKjRQc/MVPd0KPYN+A/nAQ6HJgL07pbmtuAlwtU5fSmvOofEBEjNaYiA1Uc/6UqIrwuPzJxY+cOWWNHo6AP8F+nl8BWnFy5Aqe6ykvBIiAYkefwAEZ5xVvkjHF6sSUxyENoAKroo1NZ5U2HSHC7iaeNvdjWg7UzftuOzuRMcMvPbcrCrJcQwHvlX8hLnAQWmeroUEX8RUm0U1U9qKMOrdLs0i6kpE69wae03uO/vlvEOTelSigCY+lh9zccRkFPb0JdiNJvfT7kXcyxCTW8KN5xqowtQQAIYeDHKkLQJ2bhMYGmEC7FMUmUOerTs1FMwzCOgLLZ4wX2eO8e5rYUgMVwensbjICWhNDgLLC0ZluMflZEyE8vk/4OtyAB5GM1oKo2nlwIMBn1ottnvHFpA9UWFzRdsLkOi1kjex/LkoeXBfViMduq5naepJ1CEk9rqf7KFJQKkAyVtEHZYxVKex1eHUSWW/pUlmLNN7W3YPBtUkr2heFKPccaTHy38Uw+f130nKUsAMW41eVzX7hIRyBz6lRxLsue9sqHR6XivpJGv5uZABD1vXvi5wuPvyzqt2GVxHDDYWOPJf4c7gnff9w1HBJAPlpgMwGtzAvybEB9HxLSQCdgC5q+U8TDams81EFbDIetfEJwEbGiAisiBf1vAnvYeLCsnqj914LpBqSW5mWDP8U8ylQmaY4W+qzQxcKo0uB/mltilnfnv22C25UTMTUIqVnpZ6AZ9BpUUEBR/pzIXnymCUhzN84umLiSWTpqLwXJKAZZXL6/9VHxJuWXPnDcDcVicq4eN1G1QAWDj3AmU/euuCl0LSQy
 280XyTbS
 KQt9k2brmWp4hA6y+f5iNpQQnRf3EqcS32aHZWXi7z/39ui3R/y9ClHU9Y+28UM29EyGJ9qzBcJxceV7IG7/MHnkKySbgxo8LjJ5GIQcqCyOD1x82TssJaSFJRGrGJDCFIm6ROyNBTF4xDjjIQA1sUg6paxTwhR87ovnjZhMZwYbelRhKTttriGhJKzIpvspv0UD//VMuj1aOIQXAKjva+3W9ZLhFfWuVTekJfUXlbf0h2CRt9N9KcPs84S0AiXeKH88LPMLE3J/Nh9qUn6mNwmMOqKKeqjR+iT7lkuruDIBdZKKV+zf5DaPs/U9iaDD68MbO/rVG8E3GmRLLlNDvOYs3FswrXFwiykNyOK5DeC7agD4KyXHmAh7WdAehMRoSqv8xNGz1vXaq2ITHlIv8+FvoBXMAVRVslZVn8zmZi197bCQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 10:00:00PM +0200, Mike Rapoport wrote:
> On Sun, Mar 15, 2026 at 08:50:04PM +0100, David Hildenbrand (arm) wrote:
> > On 3/14/26 19:17, Andrew Morton wrote:
> > > On Sat, 14 Mar 2026 17:02:47 +0100 Kit Dallege <xaum.io@gmail.com> wrote:
> > > 
> > > > Hi Jon,
> > > > 
> > > > The material was written with AI assistance (Claude) and then verified
> > > > against the source code in mm/shmem.c. I read through the implementation,
> > > > the existing comments, and Mel Gorman's book outline to identify what
> > > > should be covered, then used AI to help draft the prose, which I reviewed
> > > > and edited.
> > > 
> > > OK, so you're saying that you created the content and used an LLM to
> > > assist in finishing it off?
> > > 
> > > > I'm happy to rework anything that's inaccurate or doesn't meet the bar.
> > > > Should I add an Assisted-by tag to the commit?
> > > 
> > > Yes, Assisted-by: is appropriate and useful here.
> > > 
> > >  From a quick scan, this material appears to be helpful and I think it
> > > would be good for us to get this into the tree in some fashion.  Which
> > > will involve asking the relevant MM developers to review each change.
> > 
> > So, someone with an LLM but no proven experience with the code produced some
> > doc, and maintainers/developers should dedicate their precious time to do
> > the hard work of checking everything?
> 
> > I'm all for documenting stuff, especially if newcomers start exploring that
> > space by contributing small, carefully crafted documentation updates.
> > 
> > It's then a good learning experience for someone that wants to work on the
> > code to really have to understand the code in detail, and what is actually
> > worth documenting (and what's an implementation detail).
> > 
> > I see 7 doc updates for 7 different MM subsystems in my inbox, including
> 
> Heh, it's wider:
> https://lore.kernel.org/all/?q=Kit+Dallege
> 
> > So naturally, I get skeptical when it comes to "I read through the
> > implementation, the existing comments".

And another LLM says there are mistakes:
https://sashiko.dev/#/patchset/20260314152538.100593-1-xaum.io%40gmail.com

-- 
Sincerely yours,
Mike.

