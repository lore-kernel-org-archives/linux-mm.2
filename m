Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A12F6CEB2E4
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 17:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE108E0009; Sat, 15 Nov 2025 12:24:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAEA78E0005; Sat, 15 Nov 2025 12:24:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D6A8E0009; Sat, 15 Nov 2025 12:24:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A542D8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 12:24:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41D651407D3
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:24:44 +0000 (UTC)
X-FDA: 84113516088.08.4FB352D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 823AA1C0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:24:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K0opQtSr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763227482; a=rsa-sha256;
	cv=none;
	b=e1YJUvdA6WjmoH2al6d8qmKb3JjpmDZN3rmYmBfZ+BypD03hgSnPDvbpyxNybkiaN+BlEw
	IA+Pdm18+DtWgpGSMgewXNkmwAJ1M2zfFkww2FjOLcPsIt6GooS92Di4sDufUcbeNMDfan
	oPOFJhZHla/8lcPVwPHzVds4J5p3XkM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K0opQtSr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763227482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpbA3l6MoFl1OLqXADjLzvqo5IJP1J87Cgsn4WSN3Qk=;
	b=0GQppoKCpvAeWJeS/xk7aIWwKHCJhCOrgDXtMqLI1HVitAj/V6HW6JsdfqrsT6jV0wEn71
	3Ihsv5WJz+f7M5Of3B9up1NbYovmJ1MgIQ7gtEWzRXZspYpqDJ8xI1XIbn6fMSw4riqoS4
	lwiqAyKi3zqbx1fD3kIb6NEklvCVXDM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 54C264418F;
	Sat, 15 Nov 2025 17:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D101C19423;
	Sat, 15 Nov 2025 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763227481;
	bh=qflNL+o4u7ZS4s+sN0dF13IvClzqLsiakctOn+2j+Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0opQtSrljGMEXfGx3lu0Ui88SpOIFxaCWiAHegbkZS0iZDgOekiHXFYy2u3SgAML
	 oEQVFHga+HUeR4ar0sKLoI97SlKHnbQUIst+vnpdXtKq0V/EqFyeBzpRXndaGMT2KC
	 7zsxcsY6hkXeacRjcYykl+MuHWB2DXTAp7jlXk9QTkeTPYCzQBlwg4gAgIF0BoeRqP
	 NvSd9hYdgqtf5bDIh/jqahGAVXcy43AjW/+/2ms1YHUcNilRZq0noU6Tr3+NpzJsW7
	 v/61/70aVkgMizF5dgia2uPp2GbvkrP1Nvcs0aY7RLs+w4g2u6wpmLwu2Q0/L1Ni5f
	 MPY8cdyVcKUww==
From: SeongJae Park <sj@kernel.org>
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com
Subject: Re: [RFC] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
Date: Sat, 15 Nov 2025 09:24:30 -0800
Message-ID: <20251115172431.83156-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CACePvbUBEQsgoei=ykeM6uX_GWaFywZEXY7dGt+T6Pt4zhiGsA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 823AA1C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: 8hcagiehzbnrdtryrx1taienyj39dfdu
X-Rspam-User: 
X-HE-Tag: 1763227482-179154
X-HE-Meta: U2FsdGVkX1+XuVvw26wF2oiXPPCBMlu9LJzlKPoibxr0Y5hd7z8Rn34rOTpS1W6KaKxPbzAkDFxpVr8LPgeB+UHHtLApv9iLyKdJVEt1BBu1TFXuX6a8ndWnwvY34zUx462SaPC8duWY+oRINNAjlar6f3xkAFnrBQ9qC3NbSemMAjMyL7ZagMCPVjja+BGmOis7fNi3iAzbIPZPnMAuUp+/PXE0wcYOeL1eJoEfNAuGLwRqrZkNMgqr+3TXVln0vaFAjfbvaB7ZtQ1C/R7yax8jIIhgusyhd974cbs6z4jeXAuALHYI+GkHdGvJqdsbkbklKucThXlJi7gLKs+S7U9Dhnk2MJK3x76skId9vIqmlH+x1hZT4atbwdITrYptk9/4NZCX+NleVl7DoYc403F6TV8oSWI3dSzlCv3YjunyyHSV2qfgsR8CQT4XwY2nH15oqhAiNosoGVq/GaMgCFnaFj1FFalB0rWZUeZGfMGEkkuSWoiA1P86q+Tgupm0rARAOHQ3eIVUG+x/Kb8LXEJMt719zR9dgTIn7Fh+avRlP6BAwNZsxRN3TZ3GboMgIXQrHj/mOvJh4WI4VzZJiY02faIBbfZ3CWlcI296NjgXRCBQcvuDDbxU5HXkoCIBCSDSE8AGpQoJPoEOTYBsRDUYoIydhFjfQ6e8/RnTmJxirA1GknAoRBvW4dvaU97NB2Xq9sfSldcdE3mtvqvugYEkWCkCJgJthy+yuTxLU0kxpL3BoYteP+sHgCu4b8627zX6E450rPdixE2yac20uV2+Xzl5K7ckIui2YsZJsUStl1yisTqiRrPcCHsVZklUbbqJ0tEV89PzPSbWcBk6MX8fib+L/pXBZfDXOUH+Euyftzxla+8L+id/nx31JXiaJb7STgw6nyWBjhT67wKRvbt0OG7m0Lc7KA/WF+eNMKdR0jmHFxAZP7cD+5iS9x6ATfrh6diE5y/tpCt0aVl
 9IK9tB1q
 bBHimbEYOD2C4j1900yYkrT4NrMO0BtPiOcHMPJ2gfuzH0T6SBwohpuEc6yV4saqpwm4Dd4gYs2Lpfpvqwk1GfshOQ3r7dd6YnM5pKwZM0osdemS2DiQjSquuKPALgiGClB0i0gTfY6tQDEKvBD+D6PRcmSTsiodWYn60COtnmolirVQWD6LC0UgpZ4moDnxJBlGO4xWoTVOqLY4cufA189inhswgurQFBegBASpWx2DnHq67Cg5Sg6ytVkx0bGaU/ExDV65kgGu9/9oTGagOE+Qf/xyUUvY2QmwCa/pDt3iosl5vyGWZTzPfCusnlPdR03EI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 15 Nov 2025 07:13:49 -0800 Chris Li <chrisl@kernel.org> wrote:

> On Fri, Nov 14, 2025 at 5:22 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Sun,  9 Nov 2025 21:49:44 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > > Hi all,
> > >
> > > In constrained environments, there is a need to improve workload
> > > performance by controlling swap device usage on a per-process or
> > > per-cgroup basis. For example, one might want to direct critical
> > > processes to faster swap devices (like SSDs) while relegating
> > > less critical ones to slower devices (like HDDs or Network Swap).
> > >
> > > Initial approach was to introduce a per-cgroup swap priority
> > > mechanism [1]. However, through review and discussion, several
> > > drawbacks were identified:
> > >
> > > a. There is a lack of concrete use cases for assigning a fine-grained,
> > >    unique swap priority to each cgroup.
> > > b. The implementation complexity was high relative to the desired
> > >    level of control.
> > > c. Differing swap priorities between cgroups could lead to LRU
> > >    inversion problems.
> > >
> > > To address these concerns, I propose the "swap tiers" concept,
> > > originally suggested by Chris Li [2] and further developed through
> > > collaborative discussions. I would like to thank Chris Li and
> > > He Baoquan for their invaluable contributions in refining this
> > > approach, and Kairui Song, Nhat Pham, and Michal Koutný for their
> > > insightful reviews of earlier RFC versions.
> >
> > I think the tiers concept is a nice abstraction.  I'm also interested in how
> > the in-kernel control mechanism will deal with tiers management, which is not
> > always simple.  I'll try to take a time to read this series thoroughly.  Thank
> > you for sharing this nice work!
> 
> Thank you for your interest. Please keep in mind that this patch
> series is RFC. I suspect the current series will go through a lot of
> overhaul before it gets merged in. I predict the end result will
> likely have less than half of the code resemble what it is in the
> series right  now.

Sure, I belive this work will greatly evolve :)

> 
> > Nevertheless, I'm curious if there is simpler and more flexible ways to achieve
> > the goal (control of swap device to use).  For example, extending existing
> Simplicity is one of my primary design principles. The current design
> is close to the simplest within the design constraints.

I agree the concept is very simple.  But, I was thinking there _could_ be
complexity for its implementation and required changes to existing code.
Especially I'm curious about how the control logic for tiers maangement would
be implemented in a simple but optimum and flexible way.  Hence I was lazily
thinking what if we just let users make the control.

I'm not saying tiers approach's control part implementation will, or is,
complex or suboptimum.  I didn't read this series thoroughly yet.

Even if it is at the moment, as you pointed out, I believe it will evolve to a
simple and optimum one.  That's why I am willing to try to get time for reading
this series and learn from it, and contribute back to the evolution if I find
something :)

> 
> > proactive pageout features, such as memory.reclaim, MADV_PAGEOUT or
> > DAMOS_PAGEOUT, to let users specify the swap device to use.  Doing such
> 
> In my mind that is a later phase. No, per VMA swapfile is not simpler
> to use, nor is the API simpler to code. There are much more VMA than
> memcg in the system, no even the same magnitude. It is a higher burden
> for both user space and kernel to maintain all the per VMA mapping.
> The VMA and mmap path is much more complex to hack. Doing it on the
> memcg level as the first step is the right approach.
> 
> > extension for MADV_PAGEOUT may be challenging, but it might be doable for
> > memory.reclaim and DAMOS_PAGEOUT.  Have you considered this kind of options?
> 
> Yes, as YoungJun points out, that has been considered here, but in a
> later phase. Borrow the link in his email here:
> https://lore.kernel.org/linux-mm/CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com/

Thank you for kindly sharing your opinion and previous discussion!  I
understand you believe sub-cgroup (e.g., vma level) control of swap tiers can
be useful, but there is no expected use case, and you concern about its
complexity in terms of implementation and interface.  That all makes sense to
me.

Nonetheless, I'm not saying about sub-cgroup control.  As I also replied [1] to
Youngjun, memory.reclaim and DAMOS_PAGEOUT based extension would work in cgroup
level.  And to my humble perspective, doing the extension could be doable, at
least for DAMOS_PAGEOUT.

Hmm, I feel like my mail might be read like I'm suggesting you to use
DAMOS_PAGEOUT.  The decision is yours and I will respect it, of course.  I'm
saying this though, because I am uncautiously but definitely biased as DAMON
maintainer. ;)  Again, the decision is yours and I will respect it.

[1] https://lore.kernel.org/20251115165637.82966-1-sj@kernel.org


Thanks,
SJ

[...]

