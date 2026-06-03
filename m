Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E02BACD6E69
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 17:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1183B6B00B1; Wed,  3 Jun 2026 13:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF386B00B3; Wed,  3 Jun 2026 13:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BBB6B00B5; Wed,  3 Jun 2026 13:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E56736B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:53:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A30B28ED4A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:53:26 +0000 (UTC)
X-FDA: 84839348412.29.B41ED40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E94DF14000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:53:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HkVO97m0;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780509205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kmw2GG270O/WDwV9f+xAk26aPfN3D53RPt/2qsfOh+4=;
	b=PkZhRaKP5XaAirQA7mKrtAjQxcjIUaxfB3H++R2XYcMnc5F2yx2vu3ux68N/h5sgPfZsNg
	045zrCp8A8kwbeBd6d3Uz4poEMPuAwc1eMSHZje2aoB084jHTs0SheuUFNiIph3bSmWDe+
	/aHjl6h3BDGimp03gbxuH2PCt7Ag6Sk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780509205;
	b=T4ZHVHn3NwJDXdB4nrYT3w2CsnEtPIohyo2PNrw2/2bDvj0d68phmm0T6pKylMzQ69Htrz
	nfgl8NFdLLsFW+BCoWB9s/dusD32vYY7KI5CwLIe7rv8uAM713dAKoV6UBDlSa3KynjKIO
	eR5znHmOF6gZFhe1c7k+RSKic/ilgA0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HkVO97m0;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CAF76419E6;
	Wed,  3 Jun 2026 17:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F1B1F00893;
	Wed,  3 Jun 2026 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780509203;
	bh=Kmw2GG270O/WDwV9f+xAk26aPfN3D53RPt/2qsfOh+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HkVO97m0JsKg+Wm02hgp6BASGf3hGqiwuLrba0GeSiPaD3J7Aa4WBjEyu35tjFpz7
	 +ClWT+Gq2KkgPeVhp6NPeZS5XFRt8WPhUKT041BRbyZ0gwdfekfBr1NlRf7QspnF2Y
	 xATaeyWAFn94pFEFUsZx7/Rf9K7PWJpofAYTGnRV63L6cqsbrX+nqUBpH4U0L3psZP
	 7H+Rn0P85Cgo8HmdiRhxiBYG6R7r8qjpNLTwXM8V4dmVtogbw1f0LTM5bwxpLQ98qa
	 GiBl9/XsnrCropM9xKs1JBwV3ZPVv0jVj372YBuXtNKdEXF1/terVlR4zDgaXMhxOO
	 02t21aRkpBsdA==
Date: Wed, 3 Jun 2026 17:53:21 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
Message-ID: <aiBpibRNi0BcM1Zu@google.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
 <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com>
 <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com>
X-Rspamd-Queue-Id: E94DF14000A
X-Rspam-User: 
X-Stat-Signature: 35zr6znubjrkc5hjfw61kxejismj3pry
X-Rspamd-Server: rspam08
X-HE-Tag: 1780509204-578103
X-HE-Meta: U2FsdGVkX195Rbv/IgHlslWpPxIERVWUmIM/UT25GnEjjqwGAzJwTHcJFWiGvdN9dK+5l+ihQE22s//7Jq4M+0p8ZraSP4oQgIPap/dWsJxCsD4h9uCeKjDxiy32oqkhU4I5n4UGVigHyvinYtoWIRbriJTWdalLauKl4yzRj2m8Gb/FOphCNQAFLNSawj+AbXMMjIpfROPLYy2wlgAHDY80XdLrbhdzb/IZHLmUf61Wv9rB4DIOUlWgLzgiD1Se1Spl/siMQG49AeLii/cc0sJsEVevrCTtbYGjGgJRLwDRkxzDzeiXYqemCoaXHz2WcuXlleCfwWlWoeGzyGwyyQws7YxnUPpy4znDR5tn6rCIGgHJd2EsDmievVdMSLlJtKj3Q2CF26FQV7voGFV1kCba/MEdHEzGv1U/KezB4QLzOqZmNx+ozXw+4fzxYEx1nTas4AaNLEoVEpVnHinROb+0U+NaQH8xXSBgRFBXvT1iRDuPznarJtZYYMnPPm8e23w3k8dGqBj+mE0yBxnkVf/Yd/v2GNTAXtY7t4YGiwF5lut8p/WlCHWcBjjZ+wh7AmD9flD9ePTumhDxNXtZUciUQZAnAxpjyNrfH1+DOe0ihZiAy/i4CsPtw+rSD4gYpjqAbtMp/0gud0AG7OyaoT8ItH2Tv9iwqaTetLRwj9fETkAPk+f8wTeUcRt+baoeIZNL3LYPeCuO5QBRH791YnkePIWeh1GDDGcH2/tmqfnJ0/swIR0h0prp2atNYP0EbuEz5n70mCbbguBhUaLadkyiBY3LvqMIZNcj4+53IeucyaXR7Xcr2+PJLg7wfLUQxs4xpnlq23017JtfeOakEJYLZ/PQe3aIkZRQ+b8ekCOUvoHGJYLkhUOn6Yv1Z1tcuKaRmqIJlE845H9r9ayBZtUNmD0aHpll6fppWt4ipVfoimCUK6EnCQ9sdZCon9xT8PEfu8XeFfXuA3191tK
 SI4yebaz
 H1sXaNT+3PxezWFTu5sPjbPjt/5zQUuXHSuFMdGQLDE0L32xQs5Th47UiV/AE6GydI4NpfyMz4NfLkvDEUUcEDC6siFA8LOP4i5YAvchQhV88xkgFi6EnuK9sg37VpEXlsxAQoEfdlCCZjH7IZ3puPTNveeZ5Oj7TVEEQ3QP+eQvI7UmfVZHdLlNedXaOxX1s8uC+yESQOfuBrOzrg4Vd/sp9WYch58jLU3sn6i/pa18AmkpgBNojDK+hDrIqII+u9GEeUBQDx+dw+hEJmm86BAgHfi+RqoQmrmMx30JQYvfx3X0CkBSlq6xQnWVH7CRGdWGRSao8B4fk22+QSxpS3F5eI0/22RJlSWrIcAGPUFW2K1vHQFgYZsjCbqzHC+5hMdqDt91OJmWbbSzvQRnwzcEc4itaIKnNibLr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 11:02:54AM +0800, Hao Jia wrote:
> 
> 
> On 2026/6/3 07:19, Yosry Ahmed wrote:
> > > > > > > Proactive writeback also wants a similar per-memcg cursor that is
> > > > > > > scoped to the specified memcg, so that repeated invocations against
> > > > > > > the same memcg make forward progress across its descendant memcgs
> > > > > > > instead of restarting from the first child memcg each time.
> > > > > > 
> > > > > > Is this a problem in practice?
> > > > > > 
> > > > > > Is the concern the overhead of scanning memcgs repeatedly, or lack of
> > > > > > fairness? I wonder if we should just do writeback in batches from all
> > > > > > memcgs, similar to how reclaim does it, then evaluate at the end if we
> > > > > > need to start over?
> > > > > > 
> > > > > 
> > > > > Not using a per-cgroup cursor will cause issues for "repeated small-budget
> > > > > calls" cases. For example, repeatedly triggering a 2MB writeback might
> > > > > result in only writing back pages from the first few child memcgs every
> > > > > time. In the worst-case scenario (where the writeback amount is less than
> > > > > WB_BATCH), it might only ever write back from the first child memcg.
> > > > 
> > > > Right, so a fairness concern?
> > > > 
> > > > I wonder if we should just reclaim a batch from each memcg, then check
> > > > if we reached the goal, otherwise start over. If the batch size is small
> > > > enough that should work?
> > > 
> > > Even with a small batch size, for small writeback requests triggered by
> > > user-space (e.g., 2MB, which is batch size * N), it might still repeatedly
> > > write back from only the first N child memcgs.
> > 
> > Yes, I understand, I am asking if this is a problem in practice. For
> > this to be a problem we'd need to trigger small writeback requests and
> > have many memcgs.
> > 
> > > This could cause the user-space agent to prematurely give up on zswap
> > > writeback.
> > 
> > Why? The kernel should not return before trying to writeback from all
> > memcgs. If we scan the first N child memcgs and did not writeback
> > enough, we should keep going, right?
> > 
> 
> Yes, this issue is not caused by the kernel, but rather by our user-space
> agent itself.
> 
> For instance, suppose a parent memcg has two children, memcg1 and memcg2,
> each with 200MB of zswap (100MB inactive). Triggering proactive writeback on
> the parent memcg will exhaust memcg1's inactive zswap pages. After that,
> even though memcg2 still has plenty of inactive zswap pages, it will
> continue to write back memcg1's active zswap pages. Writing back active
> zswap pages causes the user-space agent to prematurely abort the writeback
> because it detects that certain memcg metrics have exceeded predefined
> thresholds.

This will only happen if the reclaim size is smaller than the batch
size, right? Otherwise the kernel should reclaim more or less equally
from both memcgs?

> Of course, real-world scenarios are much more complex, and this kind of case
> is extremely rare in our environment.
> 
> That being said, your suggestion of using the global lock for the per-memcg
> cursors makes the writeback fairer and would resolve these corner cases.

Right, but I'd rather not do per-memcg cursors at all if we can avoid
it. Will using batches help make reclaim fair over all memcgs without a
cursor?

We can always add the cursor later if needed.

