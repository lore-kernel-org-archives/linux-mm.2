Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF5D4F364A6
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3566B0005; Thu,  9 Apr 2026 14:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374266B0089; Thu,  9 Apr 2026 14:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28A9D6B008A; Thu,  9 Apr 2026 14:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 175806B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:09:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6B0F14014B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:09:38 +0000 (UTC)
X-FDA: 84639805236.22.4BA6E4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id F2B13180006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:09:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pJUDCn75;
	spf=pass (imf16.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775758177; a=rsa-sha256;
	cv=none;
	b=LMVNkFIYKEyINdxJrYsFvBr0Lo7k6Xt/Uq0RQs2jDKIfyuDxD07c/b32u/eb17UroRVsXE
	WKgAzDqN0sxJhUNzsbgRXEdMYaMN4YC+RTNWDzdL1t1Fk33hRegG2f9z4W/bR2bndF8elG
	b1a5nuFTzQLxLOR26V2VafhXae5uwHc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775758177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/oipjRn7L1x3WVlR/yQ16BlYXcWSXvkfWBZIMdtvnlI=;
	b=2hunoMRRvhlKOr2R92PgWD/DcAiFxP1Imha2xIO8/xCVzTBjdLWQxQ2fBOhXiwbXkbN33C
	nev1KBzHA1bDS706viwaySCU2Fe2p4M1KksSe1HTyws9HElz43pwFc5yQdTR3jcfNVqJLb
	E/UyFxejydyORJnZemBpsmMCQndS13o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pJUDCn75;
	spf=pass (imf16.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24926600CB;
	Thu,  9 Apr 2026 18:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C340C4CEF7;
	Thu,  9 Apr 2026 18:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775758175;
	bh=mOz3Q/H820xOIotefY92H7FBaOC39XWq57VpCvb4O2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pJUDCn75rPeKVvF2hqe/NiBTqF7b0W58jAq526EvJu4LN/ItjhHpcAJxsxy8vLHBe
	 TTUXgJ7Od8hwihbPfnJkJ/hYeb6ofM4PWi6LV/4JUvGgLgPisVEsBWQFgAOzWQ02DV
	 uZEQZoGz4nJrh1+aiJcIsTq8Dh2F4/bKD9RvSRk2sow7bPYkO5dkvqmHtDED8npK5n
	 q0Z3WTtQcJXKL1YQfn0eUQ4NrKCwmdSpj+apCHqhiY46T2xonW8tOT5CiiS5uRgSQG
	 lMY4oCZHIwnibg7IpyrSKB7Cr2XIbQ1dwvV2nXbpgfO7L5AQs015qs2an9sS0TmSRu
	 c5GGsAeWAG/dg==
Date: Thu, 9 Apr 2026 11:09:33 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: dennis@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org,
	dodam@google.com
Subject: Re: [PATCH] percpu: Fix hint invariant breakage
Message-ID: <adfrXdWJeuqDLWFM@palisades.local>
References: <ab7QClPFaFAWsxBh@palisades.local>
 <20260323140514.3487563-1-joonwonkang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323140514.3487563-1-joonwonkang@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2B13180006
X-Stat-Signature: zd4hpbdb7nema5b8zudq4hcfj1p64gn4
X-HE-Tag: 1775758176-654607
X-HE-Meta: U2FsdGVkX1/A9hokRCXwQb7FawkLSXC8UVQEJNdZXs8MmECEfoh7WZac2bR0Uv932AtJLqaS9wFpjtjRpklJ01/bmPpPqxfjaCYeGc1gmkmZBc85tWTOr9OWehfIK056sRmjZ6XwtkCFuSHhqZGE1+JY5AgvQgEAStv/jIEEe5atfOxdUiVYPAbNFfp5BoylB7jYAZMMgz094qSeTXOINZvtdSvy012mTRBXyeKN30vDpKZu9LzilWflrHVqKIjWq6YsWcdz9CIVQnLkbwS+LvqC22aL2jUjDTZhy5iPXuPVMm9I90J1XSD6TJQUA0RAkVle1i/PjRshvoiVbbAmGST/RLRhLPVu3wnKMDDcQpjpQGcC6RzTbF9NNL8FfAJfwt7T9VINFEcznP7sVdvuBPzhNTVrpFberIQVyRxj6I2V41BjgWc6ddMFMeme0f0bM1U7Tghz3aGyp6fy6TEXvgjc9c4GNHjKPp66zFQcIvs7HsEtFPs3yi2DGyTOz9Z89xzIhYkntxikT1TqO2eCLSem0Mo0a02IwyMWgQX7uPYZbCWBJQreC5Qypt/DUhV4/jKBSZwpsbbD7p7jNZ03y7UmdaUugnkm4U6hCUkbprZAAX+85C1CQvK90ImPD2AiIkanlN4z0CEwMYuFzLczx8CCljG3TWxv45qotkBgTHOLYC6VgHegAvbahlofFEjJVo9gMsjexr04BHPDX/xOWIt20KxBpPW9QfEJh1lj2AI3KAQWiwGwo3G5apv2sVNqKmTxEdigy/OGXxzvcRgN9aqQkY12bn8HKYYCTUBkjYzXRbxMPGSNAh3CskZPGLyaCb9U9s3fop6zQODVlJr4UDPiWIaBucxCEJFoKCih1ZNxIwk7LdMlQDFTc+oTHF5Y5lbv+XJ6YOKc9X6/xEug5UqPAjHBKs6Ii2Qaz7MoIZjE3Dm8vHzxdMCL7CLNpTvvEu1IHhtCbBEZGdeYMg0
 g97TjZdG
 J6zc9V47Bmzld9KyD2IXgwbsgSB4Z+4SYMsByXLo00E65PyyPkQPcnqC1ftc7j8rCqJ6x0OLKrK10vKQ2XkbgF0QnMz1taqAsOAiOaU6+QoVllx/YsHKi8bl/Y9G8b9pZQbsaFPB+KQ1w3Mo4ACqvWAXvSsKQQw/Z8+hVL4FYQyO94TdQUOo4KLq6eh65QjQQr8r8PspcPX3LZFSnkDBHc+ykmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Sorry for the delay, I've been a bit sick.

On Mon, Mar 23, 2026 at 02:05:14PM +0000, Joonwon Kang wrote:
> > Hello,
> > 
> > On Fri, Mar 20, 2026 at 11:52:14AM +0000, Joonwon Kang wrote:
> > > The invariant "scan_hint_start > contig_hint_start if and only if
> > > scan_hint == contig_hint" should be kept for hint management. However,
> > > it could be broken in some cases:
> > > 
> > 
> > First I'd just like to apologize. I spent an hour yesterday trying to
> > remember why the invariant exists and the reality is this code is more
> > clever than it needs to be.
> 
> Thanks for taking time for this and sharing more context. While you are at
> it, I have a fundamental question on the invariant. I had deliberation and
> discussion on what benefits the invariant gets to the percpu allocator by
> its existence. My understanding is that if we put contig_hint before
> scan_hint when they are the same, it is more likely that contig_hint is
> broken by a future allocation, which leads to a linear scan after the
> scan_hint for hints update, although we could save scanning upto scan_hint
> when contig_hint is not broken. On the other hand, if we put scan_hint
> before contig_hint instead, it is more likely that scan_hint is broken
> while keeping contig_hint, which does not lead to the linear scan for
> hints update, although we could not save the scanning that could be saved
> in the other case.
> 
> In other words, if contig_hint breaking allocations occur a lot in general
> with the current invariant, the performance may more suffer than without
> the invariant. I also think that there would be no strict reason of having
> the invariant.
> 

I think the original premise is that percpu memory is quite expensive, 1
allocation costs nr_cpus * sizeof(allocation). So we do our best to bin
pack at the cost of faster allocations. We could always just break the
contig_hint but then over time we could cause more fragmentation.

The case that triggered this was netdev needing 8 byte objects with 16
byte alignment [1].

> So, could you clarify the necessity of the invariant? If there is no must
> reason, then I could post another spin-off patch to remove the invariant
> at all so that we could simplify the code and experiment the result. How
> do you think?
> 

I can't really recall the exact reasoning for the invariant, but it was
probably along the lines of wanting to not lose information if possible.

Say an earlier area becomes free that is the same size as the
contig_hint but with better alignment, we ant to use that as the
contig_hint but then we either have to lose the scan_hint or keep it
with the invariant. Given the premise above, I believe we want to
continue bin packing, I think the general idea of scanning next time
around isn't the worst thing.

Sadly because it's already there, and has worked for quite some time,
it's kind of on us today to provide data / reasoning to delete it. I'd
wager that some upcoming work is going to change how percpu gives out
objects either through some sort of slab caching that we can revisit
this more in that context.

Thanks,
Dennis


