Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9544C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30956B00EA; Wed,  2 Sep 2026 13:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0E46B00EF; Wed,  2 Sep 2026 13:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0AE6B00F1; Wed,  2 Sep 2026 13:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA5696B00EA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:13:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35655A02E6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:13:40 +0000 (UTC)
X-FDA: 85169469000.14.EDE263C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 934A11C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:13:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WeTJKXiE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788369218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3nwn87c4Lpe8vKpDrR7AuSrNKE1exH0c3AsnhQC674=;
	b=gHyzWuVv7RKH068MW6PFYPnr0rn1mPRttk4cEQlU/4QXM3XoSngTN3ptkPk6wYqrN5Sj1+
	Hqn+JUJAeWweGJUlKYlidemx+FuodejROsc8CFKXvQr7t0Wrg/fPgg+1b9dJySTogIm5jG
	92ooKWvSeiH3AyNp3WdawPUhj8roh1k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WeTJKXiE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788369218;
	b=0AYAM5Ch0pLQFjesrnbNPH8v6pMFoUeHI3iHCnkLS0NZdFIGbzQgHFSofmuPTBYXg6c5tj
	CXxlIH6tzlLcn/CVUXgqNRtF+TabXFuFq7QkmnKItfX0a9pEzQUb62HAG50PDNRy8zlxnj
	kcl+WSFVYlgTLYhu8zFV1ge1hSzuowI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27A0E600C8;
	Wed,  2 Sep 2026 17:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E581F000E9;
	Wed,  2 Sep 2026 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369217;
	bh=f3nwn87c4Lpe8vKpDrR7AuSrNKE1exH0c3AsnhQC674=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WeTJKXiEAAgVeCmFM7XaKiqi5fZ+Y3lNsfTK/Bq8aBKIC4WQ+3BTzNnia733l5ix6
	 AST44JtLrtspR3BPEwZ5Bs9PfINVL9AmYLP/HSiU9+RZy1JgVRHMQvOEaRMFdLPrTf
	 ak/FYGrNQeNNyVwzzjHkFmLsmvUD0Lny4efliBEe2ukoey4EtzOS34eWP47aPU6ttJ
	 MGulQsimJNVx0gyeVXTGMHN/D1V62hIvLy6t/Yq/GPvN9uf2q0tg1ehZLGTDsGclKz
	 /zFtjpyeeWtfr0RIf3emP1pU98Sf7OXPzmnXeY1tm9ZdBsb/QR0ZM6UEzAge0XPjub
	 Lqx26o60RmGqw==
Date: Wed, 2 Sep 2026 18:13:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>, Nimrod Oren <noren@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <aphWz3Ww41jIG7Bs@gremlin>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260901204449.GK3004@cmpxchg.org>
 <C8541A2F-D6A9-41B0-A3FE-52339A6601F0@nvidia.com>
 <20260901220917.GM3004@cmpxchg.org>
 <69C018F5-A1C8-47AD-9567-3497AA6808EC@nvidia.com>
 <20260902160417.GN3004@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902160417.GN3004@cmpxchg.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 934A11C0003
X-Stat-Signature: hqcixcbz6htbou4q1w8t3n5ky6x5u37q
X-Rspam-User: 
X-HE-Tag: 1788369218-182974
X-HE-Meta: U2FsdGVkX1+PlwhdVYIpUxaVGbjYFIeIdFzx8O4y079zzfYG6rdxchmu67pKLQ0nPvIJHLWUGsHk7kEZpjQGc25stYRjvUAauKnAyU0QxXX6nlJm5aNtclnmxnLve7j+zBO6B7raWzTHwwmFEG5GAa9e5wckWayQ2DFI7/cqy+dvA/aKxlLS9tE0vjR60dMPEx8ZjPr00v9mZ+cli00+CmRQCpPUX9YpbiJVCfv7DlspTug9HqoPlIitsTMXZfeqobrfA3mpozlIz+HRJLmvRKzsq44omYqjxQkN3Qj5P6t0trh4X2XcKmhsG/noxvmHWCLXpVXgcZDXfWBlidEE1rTAi6EVhyHk+f7aPrx69PaTUYrgWx3XwABeu548Zehe713KofYVkyBWGGt6vUe0n7zQDX2ORly7fEwHuahSYkKkPn9ms8MEdWgUzxyfICJOA96s+TfiutK513Hl4tUttzHI3fTMr3Fv9XAHpnNtgDczgoOmU0jQpcx2oSXVdUP/CVspc3te+BTrxdSXH/5fxLDNa2cZWtRb37uONkLaZIBqCMJFkpwpvJ+yoHWjpXyyVTIugPJ6y3xMtEz6iTlg5YbV5DpvnuEvcss9sSD+PE64xsn1zsdYPiYJIq8/WsZRSzOL71n+pUagokTGhcpYSYEnOTko+Hsf1Rx8abfh+wrsVQvfy+f4Mc7tmAyI4/s/+giEiOy5bl9JoWn4vkmD/MFkLb6QO/1ijSFTapPQcwbDGk0CtL2P3dMfGNrMK/okCumOLKazI477QUODn1HyY4w+Ch+wfcv73ENadjyypsBWuW0KoOiIKuYn1RLbcmv8omwbNDwbTIXRE9a7UVIUUBIvNuqCnv0h8IY212+cHeDnITR5qQb67zhnoMZkm0RC7tCYVgZu+fAbSQEa+XvjqIJjoQ20H57z6wlw3ebQFHbsggMt8miT/GXaoI/for/VtMnL/hmhVgT43Dsegnv
 MymR5jla
 1LKQatHPeARzdBdS5zMmBk/TogyTyibodYbO9A6a+RbuNakz1k06B8m6/BzyfCMtEx5nlENexOl+SO3t7v4mOc9ZAsmgeUZaxqVcK01YGt1UjM3+SjyNi5Hi/bek1OecS04oLXE4VF8UuqkiqOd6Mer3RlWP2KakHjoeMRpbWQm6up3yF8ralARjcYrbINmChHPwGwP5MutmHJhxb0QFsmGWkoNDNXz86mbZ83N/AN+x3SyvkiW5lk2lyMZlow4Nkyq9dtniYf8eyjgf2dV06Xu3odMHZpOcSrnuDJw77Jyc5afz/LrWWiX2/sEN40/aI+92vNpA+KMn67QmXGlrzfdLCDzf0B6h6KyYF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 12:04:17PM -0400, Johannes Weiner wrote:
> The idea is that the pageblock maintains contiguity for the largest
> size you routinely expect to allocate.
>
> The page allocator is very passive right now, and it doesn't work
> super reliably. But even in the current regime, smaller blocks have a
> better chance of containment.
>
> For example, when the ever-growing page cache runs out of movable
> block space, it spills into unmovable free space. When the next
> unmovable request finds no space, it runs LRU reclaim - which is more
> likely to free space in one of the many movable blocks. And so the
> next block is poisoned. Smaller blocks have a better chance of filling
> up natively, means less pressure to spill into incompatible ones.

It strikes me that a lot of THP problems are really compaction problems.

>
> And the higher min_free_kbytes, the more likely there are still native
> options when the zones are down to the watermarks. E.g. better odds
> there is still unmovable free space, you just need to reclaim some
> movable/reclaimable space elsewhere to satisfy the watermarks.

I mean in general, yes, but the question is how much. This isn't really an
argument for retaining what we have, and as you say below, it's not really
clear what how much is.

>
> I've been working on making this more robust with the huge page
> allocator / defrag_mode stuff: instead of falling back and poisoning a
> block, invoke reclaim/compaction to produce a neutral block that can
> be converted entirely.
>
> It's the same idea as the higher min_free_kbytes and watermark
> boosting, but it is more targeted at the end result: readily available
> space in compatible or convertible blocks.

I wonder whether compaction needs to be improved before we can do that
sanely?

>
> But with that active regime, oversized pageblocks are even
> worse. You'd pay ongoing compaction work to produce a level of
> contiguity that you don't actually need.

I agree having 512 MiB page blocks on 64-KiB arm64 is a bad idea, but I
feel like the entire mechanism needs some degree of rethinking before that
kind of change is done.

Like I said in my other reply, I see this problem as consisting of the
short term (resolving real world pain people experience now) vs. the long
term (reworking compaction, reclaim, and how page blocks function).

>
> > > Seems to me the excessive min_free_kbytes is just a symptom of a
> > > deeper problem.
> >
> > Yes, our anti-fragmentation mechanism does not work as we expected,
> > so that we need an excessive min_free_kbytes to get khugepaged working.
> > I wonder why reclaim cannot get the extra free memory instead of
> > reserving it via min_free_kbytes. Maybe we need a watermark boost
> > when some consecutive THP allocations are seen to achieve similar
> > effect of boosting min_free_kbytes?
>
> I'm just wondering what the easiest way forward is to fix the ARM 64k
> page problem.

I mean you're not alone :) we've had a whole host of proposals all of which
were rejected, and you just rejected another...

This is why I suggested the 'if you are concerned about reserves being >X
then cap them at X' proposal.

(v2 of this patch)

https://lore.kernel.org/linux-mm/20260831075635.2244437-1-noren@nvidia.com/

That way nobody is changed, and only really huge page size gets capped.

I mean that's still a possible short-term way forward given this approach
was rejected?

>
> Yes, optimally, reclaim would work to satisfy compaction space by
> itself. We've seen it fail at that before, though.
>
> How critical set_recommended_min_free_kbytes() is today is a question
> that neither of us has a clear answer to. It's from 2011 and a lot has
> changed. However, knowing Andrea, I'm willing to bet he added this
> based on seeing a need in testing data. And I would actually expect it
> to work better now with proactive compaction, since that has a better
> chance of turning low-order chunks of that volume into pageblocks that
> can be converted instead of needing a poisoning steal.
>
> It's a change of long-standing behavior for everybody. It has a
> regression risk and requires careful evaluation and testing.

See other mail for thoughts on this :) I mean I share your concerns, but I
worry that we continue to persist in doing things because 'that's how they
were always done'.

>
> Meanwhile, adjusting the pageblock size on 64k page arm configs has a
> much smaller blast radius, appears to be the right move ANYWAY given
> what pageblocks are for, and makes the min_free_kbytes a non-issue.

Well it doesn't make it a non-issue, it redefines the size of page blocks
while the rest of the THP code continues to treat PMDs as first class
citizens.

I wonder if Kiryl's work to make PMD _not_ be the 1st class citizen of THP
will make such a change more reasonable.

Perhaps he has thoughts?

--
Cheers, Lorenzo

