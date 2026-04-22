Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38830F94CA2
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 00:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B77D6B0005; Tue, 21 Apr 2026 20:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F276B0088; Tue, 21 Apr 2026 20:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC736B0089; Tue, 21 Apr 2026 20:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1726B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:13:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15C4DE688C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:13:01 +0000 (UTC)
X-FDA: 84684266562.20.6B286FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6BEAE100016
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:12:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XbMcuJpX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776816779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lIupYyi8/UC4fLKV0VPuNnShMonTveGg9Q4SBniVJw=;
	b=F9zwCyFotZPyFmAix7yRvhVY8t11t2qrYUYVomNmExDRBxur7rI5nhJMzmZIDMjcgY6Fex
	kJiirfqsqS9heTpOOn0cLAuFqZokjrzCBKgbPQPXNOMUa6O0ZIRQ2xZn4tg9FWT8HtuOux
	e3KU4WHBvMh/audxjz5fBtUsy1Uu7KY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XbMcuJpX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776816779; a=rsa-sha256;
	cv=none;
	b=TN7goqGMfdJS9V9Y9+YWuUJeLf+ptqgGJRm4eab6145BDJJdWCKt1ugVcLBIlTieK2FuQ6
	EBiUMK3PC8yyc5U2gncV2xDwGRUdEQfqxSL12TRSbJFpAMkSQ0g6Rvy0Gtxhdp6x/6RxzR
	UwuGHbSSatXIFtwGdA2RM++vfxMOxXg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F1F56001A;
	Wed, 22 Apr 2026 00:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C33C2BCB0;
	Wed, 22 Apr 2026 00:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776816778;
	bh=G+o7PWS0hDV5gt4XP8uuA8DpSUV7cX3QjnvzK1fc9eA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XbMcuJpX46z3bURXgChoSekGUf8tZwFqZu7PlxlXXBk+EBmlO2C91KVu+1RX3a5mo
	 +/goL/S5o1X9GBboeF+FlijdHmirR+id1hs88XzGwfJsTKmXKxFOaAhwUIg3YmjsS3
	 Eq7+YpR1m/Ea5E+CWFFBb75hsmwxqrj7I3vNJ3rZnroUIgnp/JIJzbPVloLloXQD1F
	 VMN3VngqvPy1anVZ0DRPMJONyKc0dLaU4mfqIFnhKMtep6eoNTgvsrttznZZjcYlkq
	 5Vgx9nl0dy5Rzrr3yeH1IzOgoz0hod+F6oRafKbjSxa1rysFwbCexQTBI/OgJAG6ic
	 4cBJc3Q6wGcyw==
Date: Tue, 21 Apr 2026 17:12:55 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: akpm@linux-foundation.org, cl@gentwo.org, dodam@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org
Subject: Re: [PATCH] percpu: Fix hint invariant breakage
Message-ID: <aegSh_pKFkkG3gqh@palisades.local>
References: <adfrXdWJeuqDLWFM@palisades.local>
 <20260420123548.2116177-1-joonwonkang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420123548.2116177-1-joonwonkang@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6BEAE100016
X-Stat-Signature: 76mxqxuexcjrk57uxgyumm1kp3sbdc8e
X-Rspam-User: 
X-HE-Tag: 1776816779-303621
X-HE-Meta: U2FsdGVkX18RTagul4NOnocMT0ffGwR+2F+qp6TpZ9WRPb4CTEQ4fUgJJQ8+XdSqgqSh0KzFGV33VXwlTo9BT28sCYsOoGYsPVxzcRg/oY0d0HsyDH4Xrnoh12T7xZp2F6woW0ErI3bG8OLZpZFOtsK5oFsCXRCj3fjIeMi+gtIKxc79iTlVuf5rYVH3WUXyGy2n+HI3yIAPj15SD8huuQ6rM7ltr0HlJwe070YVRjpzO3lpl1y0BAVQmxquc50kl0bqkKVlQe7Ov/kW64aewq8VZUB57D1diOzWUKxBnFAL9ArocWuHTAHbnNS/fxK2B8x4hVqRLMxabaJcU0AKWRyu90mLBUZZjIfkSjkck2IMebFC9xIuF1P2PQ1j/+u/wYsmmWVPoGMA2tq/TEmiD6q3G5fugmuYsu4OQ7IJaRhZjBp1B6Q0dHd4V7zdfPbjttoSw7TepadVRGTA3L17uoo7vsLliU9LZjxvqLY3CgneZP6MchQDXlGqcuUHqkZHyAvv+Z+JtWbmeRQDD8e5775wQpAU4VNFLQcxcr4zvf7YYPrBwswlSNlXlwRJt9cW7HdIiLGjBdVEzBNmxqk2dFuCVPDb11A4XU8hxlN0XslokmyopKe4QdN0epau4yLEUW695E7iGM87sDuG0WtMasI4d2AF8g8ByWP15NSXSpByTRGOufEmQn4wAtvn62Ga6/+x8sR1KXJKPeNik7TaD6Xxl4HIQYdPcG2Hh45cPoz1C1BS1b1nCJ4eMnf6r+vHKTFuA7muQbQS4IsogddhPT8eBSsAHVLcW654jKT8X7HOfhHCrXOfVtvZvNQj/pbjVpc8egJewEuT/dTbGeD+W70VIKTCJ3IlLIZovEyc1fgzLFYP6NlDpwSi5OkoRM157GHZhFZCqg61mnw2ErHgloZi0XIAfl/+Y9pAgBticucXjWgjAHx51boASvTYMPrqNl3nB492AZUnFTkkdYL
 rmuSWHIM
 FLLtdTXNgM9ju2jSTJJ7nj0D1v3Jo23z37vXAiVAWSraMViqeuh8lk0l6jxK6GwgYHq8rM8bh33NoICPaJV7vyL4UkiEXFMcb39VFnKkB/FSv9KZ1ZlVPZO3jkjx2cc1xVtMabUN1m2I83xRysrLzVCtIV8jFSrvmloACCJOzXgCIe7TNq44Tg7WIzN6ddFTgafk4DP5xQkuB+2xVa3UcDGnJ1W7ZKCFnsVlipOtyFzFdp3/nB7aoR3hcyEyxNM/V+A++
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 12:35:48PM +0000, Joonwon Kang wrote:
> > Hello,
> > 
> > Sorry for the delay, I've been a bit sick.
> > 
> > On Mon, Mar 23, 2026 at 02:05:14PM +0000, Joonwon Kang wrote:
> > > > Hello,
> > > > 
> > > > On Fri, Mar 20, 2026 at 11:52:14AM +0000, Joonwon Kang wrote:
> > > > > The invariant "scan_hint_start > contig_hint_start if and only if
> > > > > scan_hint == contig_hint" should be kept for hint management. However,
> > > > > it could be broken in some cases:
> > > > > 
> > > > 
> > > > First I'd just like to apologize. I spent an hour yesterday trying to
> > > > remember why the invariant exists and the reality is this code is more
> > > > clever than it needs to be.
> > > 
> > > Thanks for taking time for this and sharing more context. While you are at
> > > it, I have a fundamental question on the invariant. I had deliberation and
> > > discussion on what benefits the invariant gets to the percpu allocator by
> > > its existence. My understanding is that if we put contig_hint before
> > > scan_hint when they are the same, it is more likely that contig_hint is
> > > broken by a future allocation, which leads to a linear scan after the
> > > scan_hint for hints update, although we could save scanning upto scan_hint
> > > when contig_hint is not broken. On the other hand, if we put scan_hint
> > > before contig_hint instead, it is more likely that scan_hint is broken
> > > while keeping contig_hint, which does not lead to the linear scan for
> > > hints update, although we could not save the scanning that could be saved
> > > in the other case.
> > > 
> > > In other words, if contig_hint breaking allocations occur a lot in general
> > > with the current invariant, the performance may more suffer than without
> > > the invariant. I also think that there would be no strict reason of having
> > > the invariant.
> > > 
> > 
> > I think the original premise is that percpu memory is quite expensive, 1
> > allocation costs nr_cpus * sizeof(allocation). So we do our best to bin
> > pack at the cost of faster allocations. We could always just break the
> > contig_hint but then over time we could cause more fragmentation.
> > 
> > The case that triggered this was netdev needing 8 byte objects with 16
> > byte alignment [1].
> > 
> 
> Thank you for sharing the points about the bin packing. Although I did not
> fully understand the relationship between breakage of the contig_hint and the
> fragmentation trend, it may be helpful to reference the case you referred to.
> I guess you may have missed the link for the reference [1]? Could you help to
> provide the link, if you intended to leave it?
> 

Ah sorry that's my bad.

My intention behind the scan_hint wasn't to use the scan_hint as an
earlier contig_hint, but to prevent us from scanning if we need to break
the contig_hint.

[1] https://lore.kernel.org/netdev/CANn89iKb_vW+LA-91RV=zuAqbNycPFUYW54w_S=KZ3HdcWPw6Q@mail.gmail.com/

> > > So, could you clarify the necessity of the invariant? If there is no must
> > > reason, then I could post another spin-off patch to remove the invariant
> > > at all so that we could simplify the code and experiment the result. How
> > > do you think?
> > > 
> > 
> > I can't really recall the exact reasoning for the invariant, but it was
> > probably along the lines of wanting to not lose information if possible.
> > 
> > Say an earlier area becomes free that is the same size as the
> > contig_hint but with better alignment, we ant to use that as the
> > contig_hint but then we either have to lose the scan_hint or keep it
> > with the invariant. Given the premise above, I believe we want to
> > continue bin packing, I think the general idea of scanning next time
> > around isn't the worst thing.
> > 
> > Sadly because it's already there, and has worked for quite some time,
> > it's kind of on us today to provide data / reasoning to delete it. I'd
> > wager that some upcoming work is going to change how percpu gives out
> > objects either through some sort of slab caching that we can revisit
> > this more in that context.
> > 
> 
> Understood and thanks for your detailed explanation. I will keep the invariant
> as-is unless I have a clear data point to reverse it. I sent the new patch set
> v3 recently with this in mind. Please help to review it ;)
> 

Sorry for the delay. Provided a bit of feedback just now. Let me know if
you want to discuss more about what we want v4 to look like before
spending too much time.

Thanks,
Dennis

