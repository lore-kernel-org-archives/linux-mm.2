Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B85C5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 16:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AC826B0095; Fri, 21 Aug 2026 12:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035DD6B009B; Fri, 21 Aug 2026 12:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69DA6B009D; Fri, 21 Aug 2026 12:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B45D26B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:53:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AA011601FA
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:53:38 +0000 (UTC)
X-FDA: 85125872916.28.E12E27C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7CB5980002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:53:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FkXHbN2C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787331216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oo7PIGyyBJzzL+aXqmoxOMbS4o7tVVs0naaBSJhOIDI=;
	b=qfe4B1UWr7iF/oMSAHz4Uh2RUb5pnhrcP8XTXUpl8Bm4PQ4x2wVNo4uQnTeauX8vxNE/Gn
	nzXG+Ks0J41trX7M6kV6myiqV3EbIrVYEBpZXAp6Sqx0Ypf9TXqsAPiSICNdRtXwgcpARG
	8rxQbuu2nzw13rs76AKeJIl4DbsIKbo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FkXHbN2C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787331216;
	b=Mf9swSJV1jHyAd7TgnH9sGKrxdMB7iwLsKPWqoOqOig13SFUqO3yCCOXd8pCQ2X26ywNAh
	zt3YE5RKixa13GodqTjn3DFWeSZjDMpgyS3o4CE/1c0JPLo7+0Sikap7STYk3mkN6kheFP
	HrvAWY12M9+QwrkqrE2Pj9Ub6+iz8AM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFDDE61126;
	Fri, 21 Aug 2026 16:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF9A1F00ADE;
	Fri, 21 Aug 2026 16:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787331215;
	bh=oo7PIGyyBJzzL+aXqmoxOMbS4o7tVVs0naaBSJhOIDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FkXHbN2ClFbDdtrDXo2ivUD8W/tTJnzfs0/XqMoxNIjt3UMcm/XO75cSPaxsiB45m
	 LnYhYy/iyGVtZvl6re2TGNCbbqVq6sU3QpVIpaTOCPcYN+6HveBlpkR3EPNPSgEtej
	 AqhG3iHz8sbD1wU1IzzXoXF74UQKoMsNCinq1ShHGBkCQR70gPiiNESVA0cB0frMqX
	 XUUnJZ4isYF5/ClqtgW+TSR+ZPVWImcGonCyX0Bj/aR/+YxFCAFaqfTG284/N2CqU9
	 /LiE/+yINR+IrK47B0gymORv93ZQusDOktlcXnzvvpmYdumZw1yX6fgEHgeGMx1NWr
	 nilQX1mYNH8XQ==
Date: Fri, 21 Aug 2026 17:53:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ferran Duarri <ferran.duarri@me.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: thp: default defrag mode to defer+madvise
Message-ID: <aoh_40ku6lQMOUQb@gremlin>
References: <20260820190825.221308-1-ferran.duarri@me.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820190825.221308-1-ferran.duarri@me.com>
X-Stat-Signature: agq4z41cod9ajfanfc7azgxgir3zf5ez
X-Rspamd-Queue-Id: 7CB5980002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787331216-783944
X-HE-Meta: U2FsdGVkX184DOHClOLuvUgF+Z16n5uf38Fx+Gd6P2ib3aN+Q7bveWYRFr9VSRE/pEQnJMxbHhu8GKYaTGOpymqKl5Vm374pNq6O/6t+yrUYjNf/VGV5RUOVHzvtc2SEf5HuvOWWf0iXt7gWmM4AwSQJKmd3icqceLw04a+S6b9Nh7jxNRBmtqvrbNSqa7DvyjtuAaaZ3PQTX9E6ROFPCmxF0+Uv73jAEvatyvHgCpbuHwlvba01ShCmj7oeULwFqcR/Qy3ILvmQyjgea3Va+0GlDk4NnN84Zn+8lUSLbhsiBhbInv6VtMesh3wNZ9kANaWXH83jeEqT8e3ms3jV3uUfU+5DkHGVK4cbmlP8lYkJnN4KTzIXwOiPfLEWw+BqfrMx/boOdCoOZYsxfboKCOo16Di76iCb8TWtjwVWhpjFei0mvI0JJ0eq+ooSbcloYs2YAsuPR1tD7uhOfsrLI12twWUjjtAVn+6OV4GQf3VuzHbNfy1mnhAs+r3IlRN4qKbSOdae49A8CYCD1NeSifYMt1GmC8dD/6X2Z+/P6n405NZqk1F1XHyk7xRtrpGuOIL/Zna4NjG5L27wgyYMGhu0K5+x/xvRPBL5W2vtQu2KYNcWK7Ty6MwCQEar0+R4ATV4Yzwkr5bbxy71yAL541ILWwryEuJzwy/vSzjVI+vUt9sOeCny5rJXyhk+zgkrMpoVq1Zqy95KSb8kag8PUWnP3X81OOXJtKu7Dvugq9Rl47k6WKs/BiaSM6iIBy6yfdcLZrHoh7kIeL6Ewm9h2ekGxW6sQRFI+hC+ukhxUCQZgXC8dG2Ir13F+zsq/dABLdsmUY1TY8nTyRuLLO6zRdlKqsWaVIZCmnZ9h0iOMX9Hedw7WCs+e1XXGQnC//RTn+QadEV1Cz8jjqG6rFocdwYbWvCSJQf7i/qKHJWmoM4Us43RRX4FApLO/Z0v13udy/9JfI/ypzLodBoRHzQ
 zItzqhb+
 yevLYzwMUuBtl5/xGO5dhFh0P+CWMK/bGNfcQmfRtziEl98jWqWtQzJhEWQmxrBbdEXRUe+tCr4pClpZ8iqcQ8uQ7n4vp0HpU/+nGTvj0P6OGOjGIK/u1gkjNik5AdUiKTovrE+0EdpOtdwW2NE5HaRfs5j1C1W3uJWsepyguuPkz93yyhCuUGlfD/nnik/2hjp+nUJkOqiG9WYiEl1IFAkY5rWfNika30uiNg6bk9jiSgkgeSL264t7wpvQySGrKrGckEgNdFIm1nGP9vXnFUG4ObXVyR8a2kKYePCIuTA1SVP9MFyTTomCTpIc17yuQ867bw25KiyS7T3vow9ovBZszvr1xLkBCQXy3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No. We don't randomly change core mm defaults like this especially not on the
behest of AI schlop...

On Thu, Aug 20, 2026 at 09:08:23PM +0200, Ferran Duarri wrote:
> transparent_hugepage_flags unconditionally sets
> TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, so the built-in defrag mode
> is always "madvise" regardless of which of CONFIG_TRANSPARENT_HUGEPAGE_
> ALWAYS or _MADVISE was selected. Those Kconfig options choose whether
> THP is applied by default; they do not express a preference about how
> hard the allocator should work to produce a huge page, yet the defrag
> default is pinned as if they did.

It's not pinned. Distros change these as they please.

That's where any such change should be.

>
> In "madvise" mode a fault on a MADV_HUGEPAGE region performs direct
> compaction in the fault path. Paired with transparent_hugepage=madvise
> that is a bounded cost, since only regions that asked for it are

Not really that bounded in practice.

> affected. Paired with transparent_hugepage=always every anonymous fault
> becomes eligible, and under memory pressure the faulting thread can
> stall in compaction.

What? No?

>
> "defer+madvise" keeps the same set of regions eligible for huge pages
> and the same allocation attempt, but on failure it wakes kswapd and
> khugepaged to compact in the background instead of doing it inline. The

If we felt it was right to set this a default we would have...

> fault proceeds with small pages and the region is collapsed later. This
> is the configuration long recommended to users running THP=always with
> large anonymous working sets, and it is a strictly weaker stall
> guarantee to make the default.
>
> This changes only the compiled-in default;
> /sys/kernel/mm/transparent_hugepage/defrag continues to accept every
> existing mode, including the current "madvise" behaviour.

None of this judstifies anything.

>
> No stall measurement is offered with this patch. On the machine that
> prompted it the fault path never reaches direct compaction at all:
> thp_fault_alloc is 60682 against thp_fault_fallback 0, and compact_stall
> is 0, because memory has stayed abundant enough that no huge-page
> allocation has had to fall back. That makes the box unable to testify
> either way, and a number gathered under those conditions would measure
> nothing. The argument above is a correctness one about which knob the
> Kconfig choice is entitled to set, and it should be judged on that.

This sentence is truly ludicrious...!

Made me laugh a bit though which is something at least.

>
> Signed-off-by: Ferran Duarri <ferran.duarri@me.com>

You:

- Only started posting patches yesterday
- Have posted patches all over the kernel
- Post walls of text that read exactly like they are AI-generated
- Are trying to change a fundamental default, not as an RFC, not citing any
  actual workloads

Go away and read:

https://docs.kernel.org/process/coding-assistants.html
https://docs.kernel.org/process/generated-content.html

Then ideally just go away.

We don't want AI slop patches from people who have no understanding of what
they're changing, thanks!

> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b118bcd392cb..749f669cca56 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -63,7 +63,7 @@ unsigned long transparent_hugepage_flags __read_mostly =
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
>  	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
>  #endif
> -	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG)|
> +	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG)|
>  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
>  	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
>

--
Cheers, Lorenzo

