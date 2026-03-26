Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10EA710A62CB
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C27F6B0005; Thu, 26 Mar 2026 09:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C9A6B0088; Thu, 26 Mar 2026 09:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114926B0089; Thu, 26 Mar 2026 09:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF5516B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:13:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61C041B93E6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:13:44 +0000 (UTC)
X-FDA: 84588256368.29.8776E50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9A67740011
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:13:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tiC58gz+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774530822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryA8TK5XxONxK0fS+I8EXaf02G4wxIszdifpgZVGWTw=;
	b=wuGEh0UBqafIcKxI433sGvF5VvXJ/WIFFAFwOgt1TysUuX4VMzX3/hS88kgEn06cAgGezP
	SPlWQC5QGoInLNaT+4PCHiirdLx9er1HfW8immJ7gq78P94kYgM51Iai0LSeJ/1Cesiypo
	v0hZs74vobCA0YOhvptkKColzM9llwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774530822; a=rsa-sha256;
	cv=none;
	b=O4WiApcqHJLy0SxIrLaYeAfYa60J9zippX4MEOGzV7cyhXgABbHdOjmtup+eQaXbwSZ30Q
	L3gok3/IMITEt1/JeWE3jebRq2zo/UyaX+Y2GYSg8PQ74yY0kw8HBjOMZtE8uX+G/STaoC
	TeD46oMvD5Igioh7nHeu9c94sWmwL9g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tiC58gz+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E1B460103;
	Thu, 26 Mar 2026 13:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F88C19424;
	Thu, 26 Mar 2026 13:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774530821;
	bh=RppesdMGtLvcCeXRbqBSvK537/hNj9FmRtkPlUC+DG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tiC58gz+NaUzy0dkhSAVFvJ0rieCKXkEj83kW8t5GOW4pYIMWHPH/bmZB5udX3CDn
	 dhNHc7sPEWPELCAcZy1WbT2gnXyr1kzwNHf9I/CbMHk3qgOXJGwstWU//+3XnxYg3l
	 VX4MSeLsUl21Ek1NQkrcozZPsMaJyRjNuqXorN7nTATkCVnHTSaV+nJr7aHVKfimFt
	 EYWCM01LbEN42OeWXfNTwNiuEFe7z3vUHuoP5Edf2tchpJ3wttooo15PIYMOPt76qE
	 Cqp9YfoAzYyiMwB3+8jDtE84GbrC46FbS6WeRVSd1iOtjJTHjz6h8VG1pa2fXjujRT
	 TZjhROjZ5reSA==
Date: Thu, 26 Mar 2026 13:13:33 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	lsf-pc@lists.linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <67f1588e-a094-413c-9746-9c28bdf6cc56@lucifer.local>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAMgjq7B_twv3xhd5VmMJxngAknf9YaLAiwGYpdi6H2n1cXD3-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7B_twv3xhd5VmMJxngAknf9YaLAiwGYpdi6H2n1cXD3-A@mail.gmail.com>
X-Rspamd-Queue-Id: 9A67740011
X-Stat-Signature: op5phmxomggmdd8gw79sr5kn7obmgkc1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774530822-587791
X-HE-Meta: U2FsdGVkX1879iRq40UNetPEEEZunzTcyHTPLEC7BU+AWCYf0x2qioH86nJlgLnDtj1I5nMVtUh026yUZz46CD2xMqD7awqDjXKBuESPVt/MACwSX6yT6lriNtDsHo5E5KaPD80WcPljgULjWRXkhGD0Jse/VLzUVJvDtgTENpvBGijPQUfxqu9LD9h1BSv2XSfKrVZTzaZGxJmbErtNyb6YWu4FAV6IZsRauj2VxmaOsua9AO9PrBkeZCZGv1q/LR+VexFXqKlpAkiwlcPHdZ+432/niOyFECsoid1neaD2ITa/YObGb7C51m2/UttzTyvTdY4N+TUBWDtY973LM9Pox9u2X6HXkkeemH6ls/XaLI4+WKX1bfyDnU+/M2vo4Gkawp1j24js3hR2WXrWMB6NAZLbmnOZu6N0DCZKtArto5nCPMvIU2TuIzWjSSBmTkIWjo7Zyy4aPeZwMYhrIUIPc/kAOi9sX8SsLY6uQ9jkZX5RgoWf7KfxC/XzBwogTk3bFI3gLrOXifj973g1ljukab0TTHUO7Cvj7DAVxyMreX+KItcVsI54wOMcz/wMplZK+9prLKCRtK7NlHEvCdUEKd5E6SYd8Dl8ylye2/DS5VTbeHA/QAi+kG2rblM1E+t9KSDXv+bTjHnoFsZ9KZ9Akqw4+cILVO9SAKC87nLv452Un5mMnPMGRvT9Xl/ZidJz8xlVWcagXm+j1yd9FhwiXgmSBOdoYQvYr6UePNhkKn4s9tHDd/+FhzXVj5PoQvU6tSFINqPzUwV/hpoAOjrQcDnswKtdNW+jlXqNp3WtuUDzWA7+xQN27gEEHutOID6CNfZFdU9dnpmEpwpfqggLbQ8LkkTdXGLASy1Ew0IdBgNKxuXaYJa9p2h/17bPjF4m8k27Jw7TCXYuyNlFZ7ErwmrOWPEQ3GosaXp3P3T7pSsaAa4fsBcANKN3IkZP6oNRnQ9Yi3lfb5xh34P
 EzWHxPTI
 mFx+EFqnJrlQkCiymdfi6/9dRhVO8nmiuawFGIg/2J8m58hfDZPjmkNiVFXPOi18zAjk9ookptyb+VVSF5hA3jvcZG2A9FA82vpLYMcSGIfFXywGXalloW374cE2VpGyP3/j4hqS5/4LE5/1SRebvoHytuSeym1qX2vVFJyvZ/yJmgS8YN4oxGlw7DScR6Lb1gvW6ZK0Wai3Eapr2HeGE9MTtSsGtymTipsDocYsk7hmbepjasWffCLp3A/96Yqgx53jkwaz5Ibe5M9TlAmgNurro1/XW/OE0skr90AD8fK7OlRqSQeKXGOW5nB2Maugyji0gjCODk23Na5fMCnCnIdhZGsFsJGAJ+xt1b2GUoaPof8gX1IvnOcmcunmvaara0yVZVLuFbexx7iQjUjTKgEV3gvo0M0tD7Hs9clNaaAGYfIqCqe0UX+ApMUlUa2mA+B66jdKYV8eKvUiuP2ogZRLUGRtTyQ8YGHCkVOnwzAAE/Jho0JKv4pRmiBBPtniFKsv2sbxb+zDS7VkIrecTCU82Flp9bBEwu9bwmwv2XTUxzDr7risMMPc70Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 08:37:06PM +0800, Kairui Song wrote:
> On Thu, Mar 26, 2026 at 4:02 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > On Thu, Mar 26, 2026 at 08:03:34AM +0100, Michal Hocko wrote:
> > > On Wed 25-03-26 19:05:47, Andrew Morton wrote:
> > > > On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > > > We should unify both algorithms into a single code path.
> > > >
> > > > I'm here to ask the questions which others fear will sound dumb.
> > >
> > > Not dumb at all and recently discussed here https://lore.kernel.org/all/CAMgjq7AkYOtUL2HuZjBu5dJw=RTL7W2L1+zVv=SCOyHKYwc3AA@mail.gmail.com/T/#u
> > >
> > > > Is it indeed the plan to maintain both implementations?  I thought the
> > > > long-term ambition was to knock MGLRU into shape and to drop the legacy LRU?
> > >
> > > Yes, but MGLRU is not there yet and with development pace last year or
> > > so we are not much closer than at the time MGLRU has been merged
> > > unfortunatelly.
> >
> > I'm quite concerned about maintainership, as it seems the MGLRU maintainers have
> > not been all that active, and the MGLRU to me at least is currently a black box.
> >
> > I'm not the only one who's raised this (see [0]).
> >
> > That'd very much have to be resolved and the community reassured that MGLRU is
> > _actively_ maintained before we could even contemplate it replacing the
> > 'classic' reclaim approach IMO.
> >
> > I hope that Kairu, Barry, Zicheng and others who are interested int it resolve
> > this, however!
>
> Hi everyone,
>
> Right, I think we are starting to make good progress on improving
> MGLRU recently. For the last few years we already have some commits
> stashed downstream to enable that on our fleet, most of my effort in
> upstream is spent on other parts like SWAP, really looking forward to
> making MGLRU better upstreamly.
>
> Yesterday I was still discussing with CachyOS folks about their usage
> while working on that series for MGLRU cleanup and dirty flush
> optimization, and got some nice feedback later from their chat server
> that MGLRU's TTL resolved their thrashing issue very well. With
> classic LRU they needed a le9 patch downtreamly.
>
> For many other typical workloads under stress, MGLRU performs
> significantly better too (e.g. database, build kernel could be more
> than twice as fast), it would be a huge loss to leave it unmaintained.
>
> Barry also provided some really helpful ideas about MGLRU like
> readahead handling. We are also seeing other vendors and people
> contributing to MGLRU like Leno and Baolin recently. Things are
> looking promising.

Guys, can I please make a plea then for you guys to AT LEAST become
reviewers in MAINTAINERS please:

MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
M:	Andrew Morton <akpm@linux-foundation.org>

Well Andrew is Andrew :)

M:	Axel Rasmussen <axelrasmussen@google.com>

git log mm/vmscan.c has 0 results.

Axel has however engaged in discussion on
https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/
recently for example, but not much in 2025 afaict.

M:	Yuanchu Xie <yuanchu@google.com>

git log mm/vmscan.c shows 1 result from August 13th 2024.

Yuanchu has engaged in some MGLRU discussion also recently, here and there.

R:	Wei Xu <weixugc@google.com>

git log mm/vmscan.c shows 2 results from October 2024.

Wei doesn't look to have engaged in discussion on MGLRU recently.

L:	linux-mm@kvack.org
S:	Maintained
W:	http://www.linux-mm.org
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
F:	Documentation/admin-guide/mm/multigen_lru.rst
F:	Documentation/mm/multigen_lru.rst
F:	include/linux/mm_inline.h
F:	include/linux/mmzone.h
F:	mm/swap.c
F:	mm/vmscan.c
F:	mm/workingset.c

It doesn't really feel like MGLRU is currently maintained at all, quite
honestly.

So I think we need people to step up here.

Thanks, Lorenzo

