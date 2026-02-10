Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C791EB271F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497366B0088; Tue, 10 Feb 2026 16:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444E56B0089; Tue, 10 Feb 2026 16:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326826B008A; Tue, 10 Feb 2026 16:58:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABEA6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:58:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B525AC0155
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:58:25 +0000 (UTC)
X-FDA: 84429911370.29.FA8D84F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A13E64000E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:58:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G3i2aU7F;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770760703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsQ2Y4jj/ZYGY63uInSkjnlKeVJPCakbybyuCuAXMCs=;
	b=eRHMUli0a96jhQBAKsvhQgs28YNr5T5B4eyQRUrcfSwYtFNBaX4iGSwexgdMEycKgUrpDk
	T/4RIO52F5NYGk9pTUcCH00C68/2xRBX0SkrwtWPZXdzjVHRR82GW/PszXMWCHN6a6gU7Q
	tyEKqUnVaoYETFgZVSjhbetDm6RVmwM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G3i2aU7F;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770760703; a=rsa-sha256;
	cv=none;
	b=qdn2Z35Bf2LgvJkJMJtxbWPYyj4ejD1lLmFB6zlztPlN0lSoW7KQg8wK+MSm486Lpb/Cem
	AcYQntBZnsQSGV29yczTsovoyz+kjN66gbpfoheVtNWweicazYYYIRR4ndlAhssp2CsN1f
	ruNE53dhULCkD1zuz6Yb7p48i21As3o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A22D244541
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83879C2BCB2
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770760702;
	bh=kVJ6XcSUnONVU4r8iohiHnKpwX95hZhZLfY6S9oR5xs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=G3i2aU7FI8NNF5RHybxam+ogLLyV02NodIv7ib+AWDQaDvfRzP+KfMi78YxcdJ7TW
	 PVxHFiIotQN3IZu3Yvh6EnfDAyOjiK7LcSGL3JkBeD9dCg7vZ3SWodyqbyem84fWga
	 DFgzyvEAs8oI3jJSEnOmPraU7EUcQgwGXEXEHHZ1yogq0bJE/k+gW84ORuwtfSICpF
	 as0zNw9T2QWlM9pqzJcBrPqieXx5HPEUZRec8oivys6HttthsDUqLmkcsYsKX/DNHc
	 5srL+l4tSrLDusgXPiALbqhSR1XF/6QtG1cK9Av7rRW5J7ZFTL9oLHmrk+5yRP0rCd
	 /E3R3jSQ0s0yQ==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-794fe16d032so12628687b3.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:58:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV+i787QCcJTVyGaEBCIqPToHIpmtyPS7cvosN6NMmQJ83/F3v59y7yvJvsyqmIhnQGjZmIBW5UnA==@kvack.org
X-Gm-Message-State: AOJu0YxLMfHy8LEgokPEeHA9A7GSg7NYUfkjyQ/vksM2ieY2K6b1096u
	5MraRbld7IBSwxoMzNrsUmZPKtGZczD3AzYRr7luUpWaj3XmfUI/iOFGzfiy2TiC/3rUk1eUnYk
	lvZqBU+6jRAMRDvqsUHwICZirsFdwmSZq1vbuey7b5g==
X-Received: by 2002:a05:690c:ed3:b0:796:6784:82b4 with SMTP id
 00721157ae682-796678495b2mr18676517b3.34.1770760701457; Tue, 10 Feb 2026
 13:58:21 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-2-nphamcs@gmail.com> <20260208222652.328284-1-nphamcs@gmail.com>
 <CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com>
In-Reply-To: <CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 10 Feb 2026 13:58:10 -0800
X-Gmail-Original-Message-ID: <CACePvbVvzh8PcF47hz+MfFu3tta5vh3oD+WpGxEL_-NrzYZG3Q@mail.gmail.com>
X-Gm-Features: AZwV_QjzZlZPdFukwQ_AOOUFYaZQ7FMxvqqOugUDpx3sUwElLkc_lztl4KQkhkM
Message-ID: <CACePvbVvzh8PcF47hz+MfFu3tta5vh3oD+WpGxEL_-NrzYZG3Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, hughd@google.com, yosry.ahmed@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, len.brown@intel.com, chengming.zhou@linux.dev, 
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com, shikemeng@huaweicloud.com, 
	viro@zeniv.linux.org.uk, baohua@kernel.org, bhe@redhat.com, osalvador@suse.de, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 33ajeqoyhwoyco6884b4ynh1z4t771tz
X-Rspam-User: 
X-Rspamd-Queue-Id: A13E64000E
X-HE-Tag: 1770760703-281660
X-HE-Meta: U2FsdGVkX18ZG3p+uCT1YqyhQ2B2WfwZWSaaQW88fi+p56XV9Y7tGU51LlohhUbz1iK3UqTA8yabx5vbMVemBEO5YcNvMbGp4w/+0YlKxw5CxUgIvvMzKEbSEvU83YLLyWuPWJHiQzJWnopmXSzGHpfajT8L4QI6c1Cbs9SVbeL9iTsNAJSGcBG2PDG9tvx0wmZJTxj3qn0LsDrMal/z56TqHuNYKlNN6tCZ6R8YE7CuBuNEpTMqWZOBcF1x6QMYvKEW4o9n0lMYIxFzokotFW6ACRpJMc6/0NjKznBR7tlxscLycPp4IMjMApS3prMH63iV4dSnFp2PBuCj0NxPV6a3gZaOVrlViLz9qgN8Vn9PmkXdWzMZWoHHFy06xd/5LaU+DDakRH/U5dcLC4+oMne8Bz4mm9ukxrJbGhpddoRA8RA1+EXztDyjk+uxSBWn3EzWtmsxDC6KWin5iSbKfkYkDEKCWt+snvHyI0nmrKTX36Kye7bZOmnl2CBVqL9gklWnCg45VI8rljNRTDVTFd/RdlQ435KcnGbp+r8jMtzA+70Z5O0OBCWHc1P7NQe3KdwPEUsFK68I56IfwhVomji6QvT04R07EQ9VlvGMzmk/s42X1idikH67iIPiPCfq/Oqln1rOMz1jkwErKL66phF+EZLxVW4oKdKMmTOoObGVxaLM01fFLeiN8eADdYbsS63Q1mWXRIVIbqCB1ZfJ6lWQPXYYPFYE6JuyvfwrTdPOFF8fJD70zv+G5a5+En+MkoWhZmKfGHCgYgIXD9oVoW3uXjfiM6aLctVfqxfgcT1qs0pP6ooDnFpi0A1mSMD/HPNr7U7L05Yc4wnmTPxE6pyMN6aL1ZFNLoFzNiGnBwVPMvyYHT8EiV8w2sbT+UZ1121x6mTTsDzMnagxZmddBB8D3scNhA2/tj7wtvixys242CImiqcC7G/A6h5KyZKIDNPKgQYOnpEkAbN1EBe
 jsE7HWBF
 cxoBk0s+HtOToTQw63q1GNlQk8C/bOmZaT0YCtBWz4Kmdq0cVT8wEWYLQv+NdEh7U+rYBKKvpcZZOE0aj89KmDSooGqAGz70dgGLSC6pgCV/6XfKnPBuyDVBXwDfrUgtP0pz3bAIkkIkqg49A1Z8CC8hgQKzNY8+tog2J7ood+1guUToZAHH67Vu689RqEMjEy8lYTJec/WTR2B5ESdmhKvrX0DP/qTVCl3HoiAJFGgFvU3ztFji3RmwjmiB99WU7BEUT+zQYCIxYae2tqm2a3Kc3nMSmd1Crk80BVSKi4a1zDPp907dhV+Xrm5Lr9qUvFqxb8DVR9YqimgW1YTBNzbdDmT12dekIgqI3R/luY5ntmG+u24NQuY836FcZfKLd3zeAft7FqEDjkl768lCz7XM44qKMDDU5av7LJLPZO57lsoBadQbPz/VQAlJF5faNDJ366QSsKLZyfNav66RE1ced+qSmsPqUTQs6HAit6gtDhyI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

Thank you so much for the performance test.

I will only comment on the performance number in this sub email thread.

On Tue, Feb 10, 2026 at 10:00=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
> Actually this worst case is a very common case... see below.
>
> > 0% usage, or 0 entries: 0.00 MB
> > * Old design total overhead: 25.00 MB
> > * Vswap total overhead: 2.00 MB
> >
> > 25% usage, or 2,097,152 entries:
> > * Old design total overhead: 41.00 MB
> > * Vswap total overhead: 66.25 MB
> >
> > 50% usage, or 4,194,304 entries:
> > * Old design total overhead: 57.00 MB
> > * Vswap total overhead: 130.50 MB
> >
> > 75% usage, or 6,291,456 entries:
> > * Old design total overhead: 73.00 MB
> > * Vswap total overhead: 194.75 MB
> >
> > 100% usage, or 8,388,608 entries:
> > * Old design total overhead: 89.00 MB
> > * Vswap total overhead: 259.00 MB
> >
> > The added overhead is 170MB, which is 0.5% of the total swapfile size,
> > again in the worst case when we have a sizing oracle.
>
> Hmm.. With the swap table we will have a stable 8 bytes per slot in
> all cases, in current mm-stable we use 11 bytes (8 bytes dyn and 3
> bytes static), and in the posted p3 we already get 10 bytes (8 bytes
> dyn and 2 bytes static). P4 or follow up was already demonstrated
> last year with working code, and it makes everything dynamic
> (8 bytes fully dyn, I'll rebase and send that once p3 is merged).
>
> So with mm-stable and follow up, for 32G swap device:
>
> 0% usage, or 0/8,388,608 entries: 0.00 MB
> * mm-stable total overhead: 25.50 MB (which is swap table p2)
> * swap-table p3 overhead: 17.50 MB
> * swap-table p4 overhead: 0.50 MB
> * Vswap total overhead: 2.00 MB
>
> 100% usage, or 8,388,608/8,388,608 entries:
> * mm-stable total overhead: 89.5 MB (which is swap table p2)
> * swap-table p3 overhead: 81.5 MB
> * swap-table p4 overhead: 64.5 MB
> * Vswap total overhead: 259.00 MB
>
> That 3 - 4 times more memory usage, quite a trade off. With a

Agree. That has been my main complaint about VS is the per swap entry
metadata overhead. This VS series reverted the swap table, but memory
and CPU performance is worse than swap table.

> 128G device, which is not something rare, it would be 1G of memory.
> Swap table p3 / p4 is about 320M / 256M, and we do have a way to cut
> that down close to be <1 byte or 3 byte per page with swap table
> compaction, which was discussed in LSFMM last year, or even 1 bit
> which was once suggested by Baolin, that would make it much smaller
> down to <24MB (This is just an idea for now, but the compaction is
> very doable as we already have "LRU"s for swap clusters in swap
> allocator).
>
> I don't think it looks good as a mandatory overhead. We do have a huge
> user base of swap over many different kinds of devices, it was not
> long ago two new kernel bugzilla issue  or bug reported was sent to
> the maillist about swap over disk, and I'm still trying to investigate
> one of them which seems to be actually a page LRU issue and not swap
> problem..  OK a little off topic, anyway, I'm not saying that we don't
> want more features, as I mentioned above, it would be better if this
> can be optional and minimal. See more test info below.
>
> > We actually see a slight improvement in systime (by 1.5%) :) This is
> > likely because we no longer have to perform swap charging for zswap
> > entries, and virtual swap allocator is simpler than that of physical
> > swap.
>
> Congrats! Yeah, I guess that's because vswap has a smaller lock scope
> than zswap with a reduced callpath?

Whole series is too much zswap centric and punishes other swaps.

>
> >
> > Using SSD swap as the backend:
> >
> > Baseline:
> > real: mean: 200.3s, stdev: 2.33s
> > sys: mean: 489.88s, stdev: 9.62s
> >
> > Vswap:
> > real: mean: 201.47s, stdev: 2.98s
> > sys: mean: 487.36s, stdev: 5.53s
> >
> > The performance is neck-to-neck.
>
> Thanks for the bench, but please also test with global pressure too.
> One mistake I made when working on the prototype of swap tables was
> only focusing on cgroup memory pressure, which is really not how
> everyone uses Linux, and that's why I reworked it for a long time to
> tweak the RCU allocation / freeing of swap table pages so there won't
> be any regression even for lowend and global pressure. That's kind of
> critical for devices like Android.
>
> I did an overnight bench on this with global pressure, comparing to
> mainline 6.19 and swap table p3 (I do include such test for each swap
> table serie, p2 / p3 is close so I just rebase and latest p3 on top of
> your base commit just to be fair and that's easier for me too) and it
> doesn't look that good.
>
> Test machine setup for vm-scalability:
> # lscpu | grep "Model name"
> Model name:          AMD EPYC 7K62 48-Core Processor
>
> # free -m
>               total        used        free      shared  buff/cache   ava=
ilable
> Mem:          31582         909       26388           8        4284      =
 29989
> Swap:         40959          41       40918
>
> The swap setup follows the recommendation from Huang
> (https://lore.kernel.org/linux-mm/87ed474kvx.fsf@yhuang6-desk2.ccr.corp.i=
ntel.com/).
>
> Test (average of 18 test run):
> vm-scalability/usemem --init-time -O -y -x -n 1 56G
>
> 6.19:
> Throughput: 618.49 MB/s (stdev 31.3)
> Free latency: 5754780.50us (stdev 69542.7)
>
> swap-table-p3 (3.8%, 0.5% better):
> Throughput: 642.02 MB/s (stdev 25.1)
> Free latency: 5728544.16us (stdev 48592.51)
>
> vswap (3.2%, 244% worse):

Now that is a deal breaker for me. Not the similar performance with
baseline or swap table P3.

> Throughput: 598.67 MB/s (stdev 25.1)
> Free latency: 13987175.66us (stdev 125148.57)
>
> That's a huge regression with freeing. I have a vm-scatiliby test
> matrix, not every setup has such significant >200% regression, but on
> average the freeing time is about at least 15 - 50% slower (for
> example /data/vm-scalability/usemem --init-time -O -y -x -n 32 1536M
> the regression is about 2583221.62us vs 2153735.59us). Throughput is
> all lower too.
>
> Freeing is important as it was causing many problems before, it's the
> reason why we had a swap slot freeing cache years ago (and later we
> removed that since the freeing cache causes more problems and swap
> allocator already improved it better than having the cache). People
> even tried to optimize that:
> https://lore.kernel.org/linux-mm/20250909065349.574894-1-liulei.rjpt@vivo=
.com/
> (This seems a already fixed downstream issue, solved by swap allocator
> or swap table). Some workloads might amplify the free latency greatly
> and cause serious lags as shown above.
>
> Another thing I personally cares about is how swap works on my daily
> laptop :), building the kernel in a 2G test VM using NVME as swap,
> which is a very practical workload I do everyday, the result is also
> not good (average of 8 test run, make -j12):
> #free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1465         216        1026           0         300     =
   1248
> Swap:           4095          36        4059
>
> 6.19 systime:
> 109.6s
> swap-table p3:
> 108.9s
> vswap systime:
> 118.7s
>
> On a build server, it's also slower (make -j48 with 4G memory VM and
> NVME swap, average of 10 testrun):
> # free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            3877        1444        2019         737        1376     =
   2432
> Swap:          32767        1886       30881
>
> # lscpu | grep "Model name"
> Model name:                              Intel(R) Xeon(R) Platinum
> 8255C CPU @ 2.50GHz
>
> 6.19 systime:
> 435.601s
> swap-table p3:
> 432.793s
> vswap systime:
> 455.652s
>
> In conclusion it's about 4.3 - 8.3% slower for common workloads under

At 4-8% I would consider it a statically significant performance
regression to favor swap table implementations.

> global pressure, and there is a up to 200% regression on freeing. ZRAM
> shows an even larger workload regression but I'll skip that part since
> your series is focusing on zswap now. Redis is also ~20% slower
> compared to mm-stable (327515.00 RPS vs 405827.81 RPS), that's mostly
> due to swap-table-p2 in mm-stable so I didn't do further comparisons.
>
> So if that's not a bug with this series, I think the double free or
> decoupling of swap / underlying slots might be the problem with the
> freeing regression shown above. That's really a serious issue, and the
> global pressure might be a critical issue too as the metadata is much
> larger, and is already causing regressions for very common workloads.
> Low end users could hit the min watermark easily and could have
> serious jitters or allocation failures.
>
> That's part of the issue I've found, so I really do think we need a
> flexible way to implementa that and not have a mandatory layer. After
> swap table P4 we should be able to figure out a way to fit all needs,
> with a clean defined set of swap API, metadata and layers, as was
> discussed at LSFMM last year.

Agree. That matches my view, get the fundamental infrastructure for
swap right first (swap table), then do those fancier feature
enhancement like online growing the size of swapfile.

Chris

