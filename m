Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC10ACEB2DD
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 15:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C1A8E0009; Sat, 15 Nov 2025 10:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D168E0005; Sat, 15 Nov 2025 10:14:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C588E0009; Sat, 15 Nov 2025 10:14:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6EE48E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 10:14:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AFFC12ECDB
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:14:03 +0000 (UTC)
X-FDA: 84113186766.21.278039C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A345EC000B
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:14:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZIRNEOYD;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763219641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBnQopvOT5mIxdgnnbTfateOZzhyTgq1DFwH42u5pe4=;
	b=kq08Yi1Md+GNEDm/vZi7eMTNEYbPU+zLMhxXNvHe0UveMfcnxkVFDgGERpc2AX3Yz0YJJD
	S5f/bsQkrPyrtrELvZaq10lifrx7Pl/KV7neRqz3tp4yMs143zVVVlIP51seU2g57N5B+K
	Px6XSULVPUyW7GRNth1ygCz2bZA/o3g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZIRNEOYD;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763219641; a=rsa-sha256;
	cv=none;
	b=AnpX4TCyXDqDmBcQ3vPuc3KqXE6mBjxZQnewi8MS3Y/8ejMjsxyvoqx2upz+lADPUFVQOC
	5m9rpPJsHMrUq6ozilYv0YNd10UESI9cgzb7acgLP8dFbkTSbFv0DuGpUQpzEqobAcWGnq
	byuHwJxIr6L5+ukGsv05i7xzlU7cK7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F15AC600AA
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942D1C113D0
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763219640;
	bh=/Po9rhXBcisyw1Z/KeQrWHbPXqjNgSyu9tnQaTBxNec=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZIRNEOYDlISacP3LRzj/bJSfFlw+UdHvbtM4kqx8z4Q0dl60KUY44cmihU4is8mYl
	 3XDj0vOX1F78A9NfmioA38+NAm+Ovvb/IXBWJA70kpq290PMPpKBvOnstbXf5I6GDy
	 sRFy34MsLjQWxi1y7ZA5ZqYYqqW9A5UkXkt8/2rNpHUnxtcMsQHNm3QJzk4V4PPi78
	 zMRjEhPhWGaQi+At5kKXY5uClp0WKsi1Dy4eBgErJ9j9N0BhEziXA2RP9PKdUkVlb2
	 6BWcpOtmAZwFFBgNztjWzSMD5Uc/21ls2uzP8VxqD9SROFH2ncwiiPi9nfOjixHI/G
	 vRiXMSu2Ii6Tg==
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-640daf41b19so3600913d50.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 07:14:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWRzyoaknW6D7NRAdtTyZgtNiTUb1Pi9dAe8ctAjZR1kC0requqUHLwwvweJlM6m03NJGeZwFhrTw==@kvack.org
X-Gm-Message-State: AOJu0Yw1P7ourgzhE2TblCXwkJRuFouNfcrqVxRlxRYzHYIEmdwqJ1em
	Z++jtWa0HAeKr9Jg/qXe19gkQHl0mc+6yiBqpmykBchueUaRBzQ5peFVafYuOKGlq/hyqQGeu8K
	eMTsrOpdLF+VDImiTQ/t7lTTpJonFwS38q1caZYdLIQ==
X-Google-Smtp-Source: AGHT+IH1JnpV5QKEs/WPjJU+XSrEnxlODjDSrdDJ/I+MeluASZGuG3v0xBn9frSM87UKfnLcK7THvuciP15/1mEzvps=
X-Received: by 2002:a05:690e:1289:b0:63f:b988:4a91 with SMTP id
 956f58d0204a3-6410d1387f1mr8288888d50.24.1763219639903; Sat, 15 Nov 2025
 07:13:59 -0800 (PST)
MIME-Version: 1.0
References: <20251109124947.1101520-1-youngjun.park@lge.com> <20251115012247.78999-1-sj@kernel.org>
In-Reply-To: <20251115012247.78999-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 15 Nov 2025 07:13:49 -0800
X-Gmail-Original-Message-ID: <CACePvbUBEQsgoei=ykeM6uX_GWaFywZEXY7dGt+T6Pt4zhiGsA@mail.gmail.com>
X-Gm-Features: AWmQ_bmkrQnsLWN6zZqLHzRrez2-Aopu9cRG6qIT8b5U9CsZP5z3d3-jlWOzyqQ
Message-ID: <CACePvbUBEQsgoei=ykeM6uX_GWaFywZEXY7dGt+T6Pt4zhiGsA@mail.gmail.com>
Subject: Re: [RFC] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
To: SeongJae Park <sj@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A345EC000B
X-Stat-Signature: kn4y6sjq18wp86yzq6kzxk6gzzyn8okh
X-Rspam-User: 
X-HE-Tag: 1763219641-650585
X-HE-Meta: U2FsdGVkX18kDioN9SqDWaoORCPcrLQcYKWd/kr0G01GQHB5y6abTZL3M6ztB2H1xPCBf63iQoD9HqcPPWxR4bHcs+sGIzg06uZnwGD7GEBuedJuT+c367BbF9MfuKioFLVuLaYTdtlY+plfyIXMuotVjgbCOnae7+kc8GZPfXstxb4fE97JB65pLtO5+0GboYU2eg22HDDADV/9pARSDS0JXDK9xWob1UR8mMZrBQHHuCmHUASX5T0lvXrtl7rTK+DO6ndE0g4mm155VzupRJpLmHu5MxwrHTB3LBhc3yxJmeIBuNqZfzDVT5lNjC1+Z1xRHvW7wdWRG9Hizxwa9p57exx+bWw1/IAemK1Wp+Rp5sBrQK/bjRseZDezs2tuSxxStJPn65ZDTYfJNROG3HGKia56R3/l8rAOLovOpVOurFiYAUkZKhKMJUhP0f1zahKfklbJLuQqJeEFmpNYHNo9RVErFwxDpt3+h9B3MtvtKmyJ/zCcdW3JRGSndBpyPv7JjjH3x73UStMuGp7E0/HMPQLHnzSBtBUt3SleOGOBTjyPg637FFui7ddv/al3cHMLLZ5RcVoK/bkCe/n6w44ifAbcVoKy5hfboJ90ttZYrv7cZ3uJiJWulRYrtDiLy0Q06mSnVVAv6F7CasYXG09YCG1/To/v5CRjZaz2bK4i3ECX3BKL9MQjR7Ms6dh/Q6v2HeUypKGwV3bz6AV5wxKEFo5HtnOUoFp5atV1uZ9H5tbIefXRCGRHR2/6KT3CciR6GjsDjJ+o2Y1uwmrxzF/gYRHxYXk4fcXcSEMqr7wvGk3KorAp+FEYI7F+rWfvjy0k0Hui/IWfw4Ihz5tojbpT/r4e6FPp4vBAt/jzP/NRVyTwG4PEN8dD3xcrUsDWd9qZJc1P+foIOb9mpiOcCeIXMyHT4B0yMAcwAThzNfcn4ByTTD826iU6kPUjrwqm/0mvfg21jPFKNugZlbh
 gBuzkZoT
 rjN6sirnqFBYwh84ZJbKHVDfqhJlq0w2xLPk26S6aRV1KIf//Jk+VQMlAgiNe9uXP9MCNKlGkd8L272I+76j5PnDQpTH9u9d8V5Xbo0XxHDfoMwvMVvc2cfsD+mdiu3TG9+yPTXHdqYeDeAOw/xxbC//kH55l0/gRyvcTYYgWVOcTs9wH0wOLjI/jjnxS5cP8Sbh2fVhv56EnzrhDqRQc8+ALz+K8yaPSATgjRXOZQAnrCd0/1yCT2Lq5zc6iLzqRGe4/1IJAunH9uutphqp+oN1vhmtrIZw/Ra21YWvYOU0OCV1rEFXjv1iX7y3xhnLT/2wb8b9umk5yvqK7P5QG8sPcPVEes1LLx6oR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 5:22=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Sun,  9 Nov 2025 21:49:44 +0900 Youngjun Park <youngjun.park@lge.com> =
wrote:
>
> > Hi all,
> >
> > In constrained environments, there is a need to improve workload
> > performance by controlling swap device usage on a per-process or
> > per-cgroup basis. For example, one might want to direct critical
> > processes to faster swap devices (like SSDs) while relegating
> > less critical ones to slower devices (like HDDs or Network Swap).
> >
> > Initial approach was to introduce a per-cgroup swap priority
> > mechanism [1]. However, through review and discussion, several
> > drawbacks were identified:
> >
> > a. There is a lack of concrete use cases for assigning a fine-grained,
> >    unique swap priority to each cgroup.
> > b. The implementation complexity was high relative to the desired
> >    level of control.
> > c. Differing swap priorities between cgroups could lead to LRU
> >    inversion problems.
> >
> > To address these concerns, I propose the "swap tiers" concept,
> > originally suggested by Chris Li [2] and further developed through
> > collaborative discussions. I would like to thank Chris Li and
> > He Baoquan for their invaluable contributions in refining this
> > approach, and Kairui Song, Nhat Pham, and Michal Koutn=C3=BD for their
> > insightful reviews of earlier RFC versions.
>
> I think the tiers concept is a nice abstraction.  I'm also interested in =
how
> the in-kernel control mechanism will deal with tiers management, which is=
 not
> always simple.  I'll try to take a time to read this series thoroughly.  =
Thank
> you for sharing this nice work!

Thank you for your interest. Please keep in mind that this patch
series is RFC. I suspect the current series will go through a lot of
overhaul before it gets merged in. I predict the end result will
likely have less than half of the code resemble what it is in the
series right  now.

> Nevertheless, I'm curious if there is simpler and more flexible ways to a=
chieve
> the goal (control of swap device to use).  For example, extending existin=
g
Simplicity is one of my primary design principles. The current design
is close to the simplest within the design constraints.

> proactive pageout features, such as memory.reclaim, MADV_PAGEOUT or
> DAMOS_PAGEOUT, to let users specify the swap device to use.  Doing such

In my mind that is a later phase. No, per VMA swapfile is not simpler
to use, nor is the API simpler to code. There are much more VMA than
memcg in the system, no even the same magnitude. It is a higher burden
for both user space and kernel to maintain all the per VMA mapping.
The VMA and mmap path is much more complex to hack. Doing it on the
memcg level as the first step is the right approach.

> extension for MADV_PAGEOUT may be challenging, but it might be doable for
> memory.reclaim and DAMOS_PAGEOUT.  Have you considered this kind of optio=
ns?

Yes, as YoungJun points out, that has been considered here, but in a
later phase. Borrow the link in his email here:
https://lore.kernel.org/linux-mm/CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFs=
m9VDr2e_g@mail.gmail.com/

Chris

