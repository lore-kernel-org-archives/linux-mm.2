Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8388CEBF61
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 01:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384818E0019; Mon, 17 Nov 2025 20:11:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334D48E0002; Mon, 17 Nov 2025 20:11:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223A98E0019; Mon, 17 Nov 2025 20:11:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CCE08E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:11:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB7348859A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:11:22 +0000 (UTC)
X-FDA: 84121949604.02.19FBF90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 102C3180009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:11:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RhMV3shW;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763428281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iuk6o08voYkR6X4Dml0hHm/TL5zAAnXB4ABnHQZ5hKY=;
	b=kTTMdRDCcoOIX2mxjSWu7EMNtvrX9ZdioMhPFCr9N8mW6Y60P30moSqJmw8UN69ndaX8Kj
	w9XTV5QTJ76DrMAvqRt/55vmk8fJGL7WWhIasrUXC+vZ1mUQBMGiuxUZWA8O9MDV07YPkH
	nyr09JQBYw7OHIQw7vFuLb20hDjoQfI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RhMV3shW;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763428281; a=rsa-sha256;
	cv=none;
	b=fIfpCvAP3+BBpFZAJ6DcWaH39ihuuwwByupJ1Co629C22CysW1u623hDrbLIFfBc9jTydZ
	1TTd8Kv889D0BpLhKe7l8gu+aCFfjR5UPJe2U9hmTWUCfAib9E/1pZR0yNvU+P0dXblYR5
	8c+jk63PxxqLtAv13aP+ts86CMfJRPI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C47A605DF;
	Tue, 18 Nov 2025 01:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FE0C4CEF5;
	Tue, 18 Nov 2025 01:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763428279;
	bh=KR7lSvTBx1GYbntfD6LTgnw4OVTqKdduvephCIMgmDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhMV3shWof4q6bAoyPBHcglc8GPA7dKJogXivez6cVvJ1Ugisb1r9suEHgYKgPBTy
	 XU38ZzWxcUriNn9AxgRZorDzQY0MQDYLlcnBQVUTTJIivPg/wKKIrfeN/SnX5egH7Z
	 kvziTnRTNuTEfX1Sjam+VHzWvDAHMbr8A84rcJgEPqe0wdTY9DG7FqZ2tSQtVpm+jv
	 vBLhM/ABS4tNU5O3crtmkaeZ63tBKVZ3PdZX6PA4CRCcK6uBH9uQZBbDaf/LXckfQ9
	 lzRyp8gMVA5FoZbQ0zUsOd6PUW8mMNRe1tg8d5xiGOqog2lC66a8OmNrZBn64SDlW4
	 r+Qwnxbda+ZHg==
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
Date: Mon, 17 Nov 2025 17:11:07 -0800
Message-ID: <20251118011109.75484-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CACePvbVkBPJBaowW0tQrL0mPqSq5kM1hNx91BX_JroM8ruS7sQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 102C3180009
X-Stat-Signature: mehrr59qiwq14wh6r7fopgbyej579jgs
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763428280-9706
X-HE-Meta: U2FsdGVkX1+9WYiHiB2qfnF8Yd6EAMnzkATMpCDj244jtLbOhSmRgwaHmc2ksBiGJKwuOVSgDUJ/xrTo68OdQqeOWlDNQv2YBvkp5g9Lv/IKwIqip5yE2xrA/W7+3yetkDk3D6ZWucoTVgoHg7T/xij4GLjF8qPeNn6JWE7an+aGfnET7J8GiFsEHVG52o9XJW3KmeIgwdSULBdPW3ylHi2czjWy3EJDGPwyYdZ5YcMs9xPwaQQvG4tTYwQK1CzNQCzEbH8kOgZZ0Tf/3euctkyDYyEwMhCnauD8Vs3Ju/xMSDwe9fxcuDm0FpUT2+YWBnyGKNCZeZvj/IGmB2imPZH+DppWB4c9rCrYUK+5vmuMYB4P3Qc939U9ijHPVN3Gi4goTjCu/4Ia81spJ6Hjln/8U54ReozPhKYF5nom9yYFbzTa9Xwxa8aOXSLAZeZnuB4l21ikgsDwNfcQ1uaw5BjXEEDZxGXYxZsSYKPFTtYydWbu9ge/zWJZdJhXW/vdILjtbRnPTRlemQxkGc/iTIKNcXeP8tV8ZxEI3LCsL59mKXfjLCj3q4J0fWjTybwXuwieoXYGU8nCADPk+1SY7EXKgC0lm3ALjfxDT6GP1aNSVO1TFunCF8LqP78wUfUkRxagmLQceMzaDRthFe4q29C5h4eqk60bKlHemAsOSEiUsmZ+3gZHlXrnncHeESK0sEwUANrDOJlFZBprHhVYt/Wj5uDhzmr7Au+TeNH2kiCGIjXGHFV4uGeowN6O8LrvcW3HyMjeM7iHKMaZN4OiXLdpq+HrlqoBNUesjTbKlex5kyxWfwLFh/dI8ALISZywNj+YJvZJfWKCfMP/+m4cUPkosgJKjL6Oi6/7Wk8wxj1N9DEnKRR8HKmNX1AurshsStz/74S5wpM41cU+JViilEqcyYBTQar1I8qsxZHEFt9X3NVpC1hRWXwW/bXrovXboW/EXhAoqde0kAFiGWc
 pDhAQ/hZ
 OJPnLPa0muMRBNzHttmpq6SNQvepIsrElmeGF5BoBbBkG1V+2jwYoOy4ayMIBlIflq/sAbCzn2vCBqHzOosUX7ssjkVdK84qfecOakhu0K3WY/vP6EChzul50prhWd3rzF7m/tgOCabkLxQd1Ie2yzVbhKNTbagyAbdp0bYVQL79F/8qMGQ1SppU6iOwX51vLkOXQb/KgQnrSDAYy8dO8Wv+7lhtve3ocOfbxMz3RdPZN1kr8NCQ3Ke4SjylKGjlGofpb7VVdCAOZUJiPQfUn9h/G3n6T1RWJwuJ86pmkovsJYQQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 14:17:43 -0800 Chris Li <chrisl@kernel.org> wrote:

TLDR: my idea was only for proactive reclaim use cases, while you want to cover
reactive swap use cases.  I agree my idea cannot work for that.

I added more detailed comments below.

> On Sat, Nov 15, 2025 at 9:24 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Sat, 15 Nov 2025 07:13:49 -0800 Chris Li <chrisl@kernel.org> wrote:
> > > Thank you for your interest. Please keep in mind that this patch
> > > series is RFC. I suspect the current series will go through a lot of
> > > overhaul before it gets merged in. I predict the end result will
> > > likely have less than half of the code resemble what it is in the
> > > series right  now.
> >
> > Sure, I belive this work will greatly evolve :)
> 
> Yes, we can use any eyes that can help to review or spot bugs.
> 
> > > > Nevertheless, I'm curious if there is simpler and more flexible ways to achieve
> > > > the goal (control of swap device to use).  For example, extending existing
> > > Simplicity is one of my primary design principles. The current design
> > > is close to the simplest within the design constraints.
> >
> > I agree the concept is very simple.  But, I was thinking there _could_ be
> > complexity for its implementation and required changes to existing code.
> > Especially I'm curious about how the control logic for tiers maangement would
> > be implemented in a simple but optimum and flexible way.  Hence I was lazily
> > thinking what if we just let users make the control.
> 
> The selection of the swap device will be at the swap allocator. The
> good news is that we just rewrite the whole swap allocator so it is an
> easier code base to work with for us than the previous swap allocator.
> I haven't imagined how to implement swap file selection on the
> previous allocator, I am just glad that I don't need to worry about
> it.
> 
> Some feedback on the madvise API that selects one specific device.
> That might sound simple, because you only need to remember one swap
> file. However, the less than ideal part is that, you are pinned to one
> swap file, if that swap file is full, you are stuck. If that swap file
> has been swapoff, you are stuck.

I agree about the problem.

My idea was, however, letting each madvise() call to decide which swap device
to use.  In the case, if a swap device is full, the user may try other swap
device, so no such stuck would happen.

And because of the madivse() interface, I was saying doing such extension for
madvise() could be challenging, while such extensions for memory.reclaim or
DAMOS_PAGEOUT may be much more doable.

> 
> I believe that allowing selection of a tier class, e.g. a QoS aspect
> of the swap latency expectation, is better fit what the user really
> wants to do. So I see selecting swapfile vs swap tier is a separate
> issue of how to select the swap device (madvise vs memory.swap.tiers).
> Your argument is that selecting a tier is more complex than selecting
> a swap file directly. I agree from an implementation point of view.
> However the tiers offer better flexibility and free users from the
> swapfile pinning. e.g. round robin on a few swap files of the same
> tier is better than pinning to one swap file. That has been proven
> from Baoquan's test benchmark.

I agree the problem of pinning.  Nonetheless my idea was not pinning, but just
letting users select the swap device whenever they want to swap.  That is, the
user may be able to do the round robin selection.  And in a case, they might
want and be able to do an advanced selection that optimized for their special
case.

> 
> Another feedback is that user space isn't the primary one to perform
> swap out by madivse PAGEOUT. A lot of swap happens due to the cgroup
> memory usage hitting the memory cgroup limit, which triggers the swap
> out from the memory cgroup that hit the limit. That is an existing
> usage case and we have a need to select which swap file anyway. If we
> extend the madvise for per swapfile selection, that is a question that
> must have an answer for native swap out (by the kernel not madvise)
> anyway.  I can see  the user space wants to set the POLICY about a VMA
> if it ever gets swapped out, what speed of swap file it goes to. That
> is a follow up after we have the swapfile selection at the memory
> cgroup level.

I fully agreed.  My idea is basically extending proactive reclamation features.
It cannot cover this reactive reclaim cases.

I think this perfectly answers my question!

> 
> > I'm not saying tiers approach's control part implementation will, or is,
> > complex or suboptimum.  I didn't read this series thoroughly yet.
> >
> > Even if it is at the moment, as you pointed out, I believe it will evolve to a
> > simple and optimum one.  That's why I am willing to try to get time for reading
> > this series and learn from it, and contribute back to the evolution if I find
> > something :)
> >
> > >
> > > > proactive pageout features, such as memory.reclaim, MADV_PAGEOUT or
> > > > DAMOS_PAGEOUT, to let users specify the swap device to use.  Doing such
> > >
> > > In my mind that is a later phase. No, per VMA swapfile is not simpler
> > > to use, nor is the API simpler to code. There are much more VMA than
> > > memcg in the system, no even the same magnitude. It is a higher burden
> > > for both user space and kernel to maintain all the per VMA mapping.
> > > The VMA and mmap path is much more complex to hack. Doing it on the
> > > memcg level as the first step is the right approach.
> > >
> > > > extension for MADV_PAGEOUT may be challenging, but it might be doable for
> > > > memory.reclaim and DAMOS_PAGEOUT.  Have you considered this kind of options?
> > >
> > > Yes, as YoungJun points out, that has been considered here, but in a
> > > later phase. Borrow the link in his email here:
> > > https://lore.kernel.org/linux-mm/CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com/
> >
> > Thank you for kindly sharing your opinion and previous discussion!  I
> > understand you believe sub-cgroup (e.g., vma level) control of swap tiers can
> > be useful, but there is no expected use case, and you concern about its
> > complexity in terms of implementation and interface.  That all makes sense to
> > me.
> 
> There is some usage request from Android wanting to protect some VMA
> never getting swapped into slower tiers. Otherwise it can cause
> jankiness. Still I consider the cgroup swap file selection is a more
> common one.

Thank you for sharing this interesting usage request!  And I agree cgroup level
requirements would be more common.

> 
> > Nonetheless, I'm not saying about sub-cgroup control.  As I also replied [1] to
> > Youngjun, memory.reclaim and DAMOS_PAGEOUT based extension would work in cgroup
> > level.  And to my humble perspective, doing the extension could be doable, at
> > least for DAMOS_PAGEOUT.
> 
> I would do it one thing at a time and start from the mem cgroup level
> swap file selection e.g. "memory.swap.tiers".

Makes sense, please proceed on your schedule :)

> However, if you are
> passionate about VMA level swap file selection, please feel free to
> submit patches for it.

I have no plan to do that at the moment.  I just wanted to hear your opinion on
my naive ideas :)  Thank you for sharing the opinions!

> 
> > Hmm, I feel like my mail might be read like I'm suggesting you to use
> > DAMOS_PAGEOUT.  The decision is yours and I will respect it, of course.  I'm
> > saying this though, because I am uncautiously but definitely biased as DAMON
> > maintainer. ;)  Again, the decision is yours and I will respect it.
> >
> > [1] https://lore.kernel.org/20251115165637.82966-1-sj@kernel.org
> 
> Sorry I haven't read much about the DAMOS_PAGEOUT yet. After reading
> the above thread, I still don't feel I have a good sense of
> DAMOS_PAGEOUT. Who is the actual user that requested that feature and
> what is the typical usage work flow and life cycle?

In short, DAMOS_PAGEOUT is a proactive reclaim mechanism.  Users can ask a
kernel thread (called kdamond) to monitor the access pattern of the system and
reclaim pages of specific access pattern (e.g., not accessed for >=2 minutes)
as soon as found.  Some users including AWS are using it as a proactive
reclamation mechanism.

As I mentioned above, since it is a sort of proactive method, it wouldn't cover
the reactive reclamation use case and cannot be an alternative of your swap
tiers work.

> BTW, I am still
> considering the per VMA swap policy should happen after the
> memory.swap.tiers given my current understanding.

I have no strong opinion, and that also makes sense to me :)


Thanks,
SJ

[...]

