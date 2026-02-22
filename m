Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7D1C624A0
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 01:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE436B0088; Sat, 21 Feb 2026 20:16:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32466B0089; Sat, 21 Feb 2026 20:16:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E3A6B008A; Sat, 21 Feb 2026 20:16:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CEB96B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 20:16:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1AAE5C219E
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 01:16:11 +0000 (UTC)
X-FDA: 84470326542.17.890E877
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf27.hostedemail.com (Postfix) with ESMTP id E664840006
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 01:16:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771722969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W6ZaXBqLas+cqXB6WmjDSHTHtC/lVyfPX6AjeoXFa54=;
	b=EGx5hs8CMJmbia1VOU6v1henCqeZCb9rB+mNuV8Ne+6E+UQ/oAi7LZR/I5qFVMt8tBKRbk
	aVVUa9Ucuripy/lGFizf3Uq8juw7RNSntrv6OziVVC5ijn5AWtV7bLs926gd2z7X30C4/q
	toCpl2zG5JYLCIt75hIsDP7N8GvmKYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771722969; a=rsa-sha256;
	cv=none;
	b=AFRoioX/apF9aXG8Fn8ej5Bs1Edi3aIOePxPsFTZv5pbbSAEYkeXmCZ3cvKspYvsrB16Mb
	paqjaiabovR9RuziDk0mRVobboekv/WaP1/bEm1NW72RdGqtxJkTm2jZ6QexH/Jg+5OWHW
	7IcVtLPSBCfe6lPAQLm9du7eKeqD6Sk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 22 Feb 2026 10:16:04 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 22 Feb 2026 10:16:04 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com,
	taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aZpY1FIjYLtLdu5F@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
 <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
 <20260221163043.GA35350@shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260221163043.GA35350@shakeel.butt@linux.dev>
X-Rspam-User: 
X-Stat-Signature: n3i5fk5rmb9kwo8rdueqmtoqxeyud5a6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E664840006
X-HE-Tag: 1771722967-830003
X-HE-Meta: U2FsdGVkX1+pd75dz+1TAtNa6+CyF3CAQIpyHDL2OejkhDemDzhl4fvtAMWBZqbFAVvsiUu1sxMbNqViqu+DovhP3Bgf0zSwDETlyMaIr/mWIt0ipwKj8z3cMsDiqMVkiglOto+p8+78XhIg53hGlNgDrn89p0gcx+AXEuCEEDn7pVURM1kANzBpIUQOPPyJeB1bTjYliiv4mclGbi3tswd7WO+7o0Ahvm9Vjn7rOtpKWYoPsv//N50PXHAYqWudrFaeLecFOOD81wsYFopgypli+QhBXn8GwK9FDWmto7Hknt1ssTXQJg5MLGgC2UIeAf2FPX/wCEZXM2BWhJt+QXmT7zc5mWOuixwYDm+e1D0JBSqEiwodpZAwBAOqMotnlj5rFe83rZlccEcGSm0fFZ6hTm2eAH3Zth9BAkf65QtvQZ7IT9Vl3zls1oA869U5lImFG0T2grgk4IqgnV7+dRFQ2NRrvma/lPsOB9QoiQqwdoI1QPxJABsA4OJKM0pOXvWBZsY5OuR3FNnERwaUVkBUvK3DdUjs/vYKa0vgnGS55Iotsg95CL6c43rLgG3f31L4JXCsp5iUE84kFtv4cWSd7eiyDQrYTl8TcTDZ5IzaqL3dLNirGXFb3h6iR2bCzvPXDrPXN+0NPkSAtzdgy3cd+VAYzwbzMZBcuFa/evQ2auR+Ho87f0let3Pghm2uQfG/+HgLtiIjWyTx+uvU+JF2ydHKI/2cZoQqc2QZDOjCoL/UPjMfNOlPyynaw3CIXABlaMXocOaUvs6iMmrrow+pVYYHN+n9zsZcGc1sX3jV9hH0M7+oERO0ufjmsLbl6jXi5vTplwU3pgRxC/4dUPiNwwixRN2g32a03mQjVmW3iEdg1bPS7VOxhQGVxjbJbE8bIgPyKSmwzpzueuNlB79fDxvsaogIexVl1jLg2zMX6MzDXK2rWrLmo3hfsAdNwCesCr7Hy42HOKzU03w
 6iH7TuzD
 ElH5YVUGjwozGDgcc7CcPAQ+8cxleHhsBA1oMGd8Wt7aUzQ6nzjPa9QHReGIsYIWTBsd6TOFjt22wnl34DyH0eEfX/jxkwrY1P1OaQ9G+tgneCNp9QQGvP+O1gbZxmp02f9pSbpcyviFnFSsvfU/ZPDeKsB1VeRzBbFi/rl5cfXW7RMYJeW4qSia0C0uh6QX3njEVYf6eyKkA4uvAOUrH/aTnoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 09:44:01AM -0800, Shakeel Butt wrote:
> On Fri, Feb 20, 2026 at 10:07:44PM -0800, Chris Li wrote:
> > >
> [...]
> > > >
> > > > I agree that using BPF would provide greater flexibility, allowing control not
> > > > just at the memcg level, but also per-process or for complex workloads.
> > > > (As like orchestrator and node controller)
> > >
> > > Yes it provides the flexibility but that is not the main reason I am pushing for
> > > it. The reason I want you to first try the BPF approach without introducing any
> > > stable interfaces. Show how swap tiers will be used and configured in production
> > 
> > Is that your biggest concern?
> 
> No, that is secondary because I am not seeing the real use-case of
> controlling/partitioning swap devices among sub-workloads. Until that is
> figured out, adding a stable API is not good.
> 
> > Many different ways exist to solve that
> > problem. e.g. We can put a config option protecting it and mark it as
> > experimental. This will unblock the development allow experiment. We
> > can have more people to try it out and give feedback.
> > 
> > > environment and then we can talk if a stable interface is needed. I am still not
> > > convinced that swap tiers need to be controlled hierarchically and the non-root
> > > should be able to control it.
> > 
> > Yes, my company uses a different swap device at different cgroup
> > level. I did ask my coworker to confirm that usage. Control at the non
> > root level is a real need.
> 
> I am assuming you meant Google and particularly Prodkernel team and not
> Android or ChromeOS. Google's prodkernel used to have per-cgroup
> swapfiles exposed through memory.swapfiles (if I remember correctly
> Suleiman implemented this along with ghost swapfiles). Later this was
> deprecated (by Yu Zhao) and global (ghost) swapfiles were being used.
> The memory.swapfiles interface instead of supporting real swapfiles
> started having select options among default, ghost/zswap and real
> (something like that). However such interface was used to just disable
> or enable zswap for a workload and never about hierarchically
> controlling the swap devices (Google prodkernel only have zswap). Has
> something changed?
> 
> > 
> > >
> > > >
> > > > However, I am concerned that this level of freedom might introduce logical
> > > > contradictions, particularly regarding cgroup hierarchy semantics.
> > > >
> > > > For example, BPF might allow a topology that violates hierarchical constraints
> > > > (a concern that was also touched upon during LPC)
> > >
> > > Yes BPF provides more power but it is controlled by admin and admin can shoot
> > > their foot in multiple ways.
> > 
> > I think this swap device control is a very basic need.
> 
> Please explain that very basic need.
> 
> > All your
> > objections to swapping control in the group can equally apply to
> > zswap.writeback. Unlike zswap.writeback, which only control from the
> > zswap behavior. This is a more generic version control swap device
> > other than zswap as well. BTW, I raised that concern about
> > zswap.writeback was not generic enough as swap control was limited
> > when zswap was proposed. We did hold back zswap.writeback. The
> > consensers is interface can be improved as later iterations. So here
> > we are.
> 
> This just motivates me to pushback even harder on adding a new interface
> without a clear use-case.
> 
....

After reading the reply and re-think more of it.

I have a few questions regarding the BPF-first approach you
suggested, if you don't mind. Some of them I am re-asking
because I feel they have not been clearly addressed yet.

- We are in an embedded environment where enabling additional
  kernel compile options is costly. BPF is disabled by
  default in some of our production configurations. From a
  trade-off perspective, does it make sense to enable BPF
  just for swap device control?

- You suggest starting with BPF and discussing a stable
  interface later. I am genuinely curious, are there actual
  precedents where a BPF prototype graduated into a stable
  kernel interface? 

- You raised that stable interfaces are hard to remove. Would
  gating it behind a CONFIG option or marking it experimental
  be an acceptable compromise?

- You already acknowledged the use-case for assigning
  different swap devices to different workloads. Your
  objection is specifically about hierarchical parent-child
  partitioning. If the interface enforced uniform policy
  within a subtree, would that be acceptable?

- We already run a modified kernel with internal swap control
  in production and have real feedback from it. Requiring BPF
  as a prerequisite to gather production experience seems
  unnecessary when we are already doing that.

To be honest, I am having trouble understanding the motivation
behind the BPF-first validation approach. If the real point is
that BPF enables more flexible swap-out policies than any fixed
interface can, that would make much more sense to me. I would
appreciate it if you could share more on this.

Thanks,
Youngjun Park

