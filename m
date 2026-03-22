Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E0CD58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 22:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7CF6B0005; Sun, 22 Mar 2026 18:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498DD6B0088; Sun, 22 Mar 2026 18:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5756B0089; Sun, 22 Mar 2026 18:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2ADD46B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:28:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9EBA16090E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:28:56 +0000 (UTC)
X-FDA: 84575140272.16.B2A9D70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4341120003
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:28:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6n5jTaf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774218535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WswD/WIsXZfQsrZ2iW4BbSGqYO3Sa1sCQ0cSkbEeNBA=;
	b=IM2DkGHZrmoVktwlAAo/C7lTzkQGKihHqMnOeX/s63INPZ1DZX+7Sy7peuAHu0tmOFJQa/
	kaOgmE05FhUzY2L1/1mmqfBZlnM/UEbxx9pnAgX1qSWdDSrhqakqtjfNTpj7g0+DvGb/Vr
	MN66O42acPNjSfZeURpBfF6jizNl6BI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6n5jTaf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774218535; a=rsa-sha256;
	cv=none;
	b=TLoiTZNZZcOkCVDUess7etrSIHem3IJVt7ukyuT7RixlN/gv/ZJc1McfWreX/IB+pKryNl
	579Mp2peGoGUVWkg7UT8n1mYHvofy/6pDU7ir0TuYITgjktC6lc7T+NAPgUIXNrTD0xgaN
	1xcvAev/VKUXHFWrIt5Z1AqY7jekoKk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97CA560008;
	Sun, 22 Mar 2026 22:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F152C19424;
	Sun, 22 Mar 2026 22:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774218534;
	bh=kzW9ex6Pn6zhGRYRBf0VzvojUC0+Ma6yBVZIRqEFZgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6n5jTafHSgCE/WZyy9MLx2HnUUkhFROw6fw3aG4gXqsajLr9q14Oz1zvL+bwDdWX
	 cTFzWywbkrHGXuwKGCq9rlxskr5ZZ0Uw4r4Nm/TBmvfpPqNFCTTuC7pFVk5uSAzp3A
	 Opcdadiyw271v1LSD8WETHlUd8wZZuc8ZuAlQT7pUs4qhpjaTmT5FMqxMdr0QYemDt
	 AZ7ZtLeRp3NuC9RvCHFlgK00WQPvKV4yyr3M1V9QjYpMpOd5sRGsSaTebAj7K1TgOu
	 l0Q8v8aw6Dzh5zLvRPAjjXm74eaZ/93jlv6GQoCP/SGTB5XPtgdeElQS2ZUkLvA1TN
	 aWZuaEp8pLpgw==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: optimize kdamond_ap =?US-ASCII?Q?ply=5Fschemes=28=29_by_inverting_scheme_and_region_loops?=
Date: Sun, 22 Mar 2026 15:28:44 -0700
Message-ID: <20260322222845.89757-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <C9B59023-161D-405F-8941-1B0E0B8E1D6B@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4341120003
X-Stat-Signature: 94zmbmoumj4cexgn4dezdidxxf5xnfk5
X-Rspam-User: 
X-HE-Tag: 1774218535-188647
X-HE-Meta: U2FsdGVkX1+SUB04UvDTpnluYiRuNBbUHkgp78GQAejOEVx129+E6zp3aik4jw5S/d7y9Y7Zr0LHl1vQqxdlNvr7eS3kJ/cIqBHifz2xUjYFescB5vGHxWPjGjHlmZfHcg2N0s7098Jm8mfXAy/dpn652NHC2VoCJr8b14AQOGfIDt39xvmzxUUC1pEv79QWIgBgF20S+nYazyp7JjEuh7oMDIZ70Nt4P53ZRxDobKMmQY8F6wm++M7FK12cLMko0rTYbGikSwq6REE8C53C6U72ZaDGoQwHqAt6dwzaii+gjKyFajOwfLsStgpIcCH42FgbKiVLbSLk1V9HJPxPtCLKWEl2nF7IxTYa66zJXdf+I8Upwa9cwyQ0axCCZQGoYUbSzxGOWqMUyQdT47w6T9gqrAMyb2icMxdS5VOmbaxENDbFN35zVGfopcgFcsAM0t1mCaR3h9s9Jvdz9anQG+8Fv/xLihz1GeWQWjuO3RQTuzFE8+04NSGyPKVmQEONOCtFbHXXx6q8kSUQzwBrG/UcEuGlpcJCK3rJxnokFPhub3OIV2jlshLGfBEOpX97RDnkqPtthrcE3nmE/U+4JQe863KcW0W+IqjCJ9PIxRPH5pAeZLB28d5AJz2pOTmlR9Il4GhU8Io6kIjzss+ghzR+sDjtra03ltJ2yB7iZTkHEFx2lkQE9NVcm2cawoDjTD1Ddb+CQ0eLoCP+OeoDt42b6DmngW2W/NMplp977Tp0RUlSyWmsMzzBDk3w9h8tiLHRfHp0aWzcJ5D59C2QsFT5HNuBykfeOIJmy4ay8hFsyNz5rRZhwg7fvOuYUuDkIX7mu0NoUIVhSd5dJZ3//34PrWq6jY21s3W3/hfMT+uk9PJv2raL9wAjpdOQzbtDaUjv6jUhnoBkpnjYfAWwoBOrEwhjJ5HdQJnEMEh7+OrGIZywPvuUXL4EUWzCjzwPUiJChdo3zX+rwhQ+lJZ
 pJyg8LeG
 z5EVI3T/2otMzZPZPxOT80pIwuUtnpBQGfqQt68qqlxVv+zVXhBVRTuPoHZZj+h+XAD0P1Eh4/ALrABhKhAm275pBytqgD+nrppXkkoXWpBDJP5GTqJhyuPl0GfosiIuw538UyfhfwwhoOy5ZKGxIKLNRGVPg/an7TvP0KxzgrS1j72jZ0K+dZmas3gfo9Walt3nJYsk4ObQDy6QVSHXkbaTaDB+ewUJlvLBSC0nqRj1iBjw5TFEGWJHL4YPT06VI0VCPvkcliI/vEXwtUY44m8nlPnO8rvVsXQfAXr5d9DcIw9L4of9LWCthaGvXSg3g90x17zESLSNVnO5DzW9moVtV9FTC1upv+tqxANR2xGwgDuPkkuGsRU0AaQEiKjagJoAkF8Mzk/j6qAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 21:59:45 +0000 Josh Law <objecting@objecting.org> wrote:

> 
> 
> On 22 March 2026 21:44:18 GMT, SeongJae Park <sj@kernel.org> wrote:
> >Hello Josh,
> >
> >On Sun, 22 Mar 2026 18:46:40 +0000 Josh Law <objecting@objecting.org> wrote:
> >
> >> Currently, kdamond_apply_schemes() iterates over all targets, then over all
> >> regions, and finally calls damon_do_apply_schemes() which iterates over
> >> all schemes. This nested structure causes scheme-level invariants (such as
> >> time intervals, activation status, and quota limits) to be evaluated inside
> >> the innermost loop for every single region.
> >> 
> >> If a scheme is inactive, has not reached its apply interval, or has already
> >> fulfilled its quota (quota->charged_sz >= quota->esz), the kernel still
> >> needlessly iterates through thousands of regions only to repeatedly
> >> evaluate these same scheme-level conditions and continue.
> >> 
> >> This patch inlines damon_do_apply_schemes() into kdamond_apply_schemes()
> >> and inverts the loop ordering. It now iterates over schemes on the outside,
> >> and targets/regions on the inside.
> >> 
> >> This allows the code to evaluate scheme-level limits once per scheme.
> >> If a scheme's quota is met or it is inactive, we completely bypass the
> >> O(Targets * Regions) inner loop for that scheme. This drastically reduces
> >> unnecessary branching, cache thrashing, and CPU overhead in the kdamond
> >> hot path.
> >
> >That makes sense in high level.  But, this will make a kind of behavioral
> >difference that could be user-visible.  I am failing at finding a clear use
> >case that really depends on the old behavior.  But, still it feels like not a
> >small change to me.
> >
> >So, I'd like to be conservative to this change, unless there are good evidences
> >showing very clear and impactful real world benefits.  Can you share such
> >evidences if you have?
> >
> >
> >Thanks,
> >SJ
> >
> >[...]
> 
> 
> My last email:
> 
> Hi SeongJae,
> 
> I've looked into this further and ran some extra benchmarks on the kdamond hot path to see if the gains were actually meaningful.
> 
> The main issue right now is that kdamond spends a lot of time "spinning" through regions even when there's no work to do. For example, if a user has 10,000 regions and a few schemes that have already hit their quotas or are disabled by watermarks, the current code still iterates through every single region just to check those same flags 10,000 times.
> 
> In my tests:
> 
> Typical setup (10 schemes, 2k regions): ~3.4x faster.
> 
> Large scale (10k regions, hitting quotas): ~7x faster.
> 
> Idle schemes (watermarks off): ~7x faster.

Thank you for sharing these.  This seems like not a real world workload test
but some micro-benchmarks for only the code path, though.

In real world DAMOS usages, I think most of time will be spent on applying
DAMOS action.  Compared to that, I think the time spent for the unnecessary
iteration will be quite small.

> 
> 
> It's also a cache locality win. Right now the CPU has to bounce between different scheme metadata inside the innermost loop for every region. Inverting the loops lets us process one scheme completely, which keeps the hot data in L1/L2 and gives about a 10% gain even when everything is active.
> 
> The goal isn't just to shave cycles, but to make DAMON scale better on high-memory systems (512GB+) where the region count is high. This keeps the background "CPU floor" much lower when DAMON is supposed to be idle or throttled.

DAMON does adaptive regions adjustment for such large memory system
scalability.  I understand some users might dislike the adaptive mechanism and
stick to a fixed granular monitoring, though.

So I'm not yet convinced to this change as is.

Meanwhile, I'm thinking about a way to make similar optimization without
changing the behavior.

We already have the first loop of kdamond_apply_schemes() to minimize some of
the inefficiency that this patch is aiming to optimize out.  Maybe we can
further optimize the first loop.  For example, modifying the first loop to
build a list or array that contains schemes that passed the next_apply_sis and
wmarks.activated test, and make damon_do_apply_schemes() to use the test-passed
schemes instead of the all schemes in the context.

This will keep the behavior but have a performance gain that similar to what
this patch is aiming to.  If this can be done with a fairly simple way that can
justify the maintenance burden, I think that's a way path forward.  But, from
this point, I realize I want it to be *very* simple, and I have no idea about
the simple way.

So I wanted to help making this be merged.  But I fail at finding a good path
forward on my own.

In my humble and frank opinion, finding other place to work on insted of this
specific code path optimization might be a better use of the time.


Thanks,
SJ

[...]

