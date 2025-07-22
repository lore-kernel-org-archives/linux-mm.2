Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E84AC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7816B00A1; Tue, 22 Jul 2025 14:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97F76B00A2; Tue, 22 Jul 2025 14:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE876B00A3; Tue, 22 Jul 2025 14:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 96DCB6B00A1
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:30:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27453804F8
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:30:40 +0000 (UTC)
X-FDA: 83692741440.07.1CEE887
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf23.hostedemail.com (Postfix) with ESMTP id 570B814000A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:30:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753209038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lanL6/okGV0P+0sYrvy/8OAkXLITTs0GlmmU3wcNF6o=;
	b=SDG0D+ho04+vCyd4YUuS+ef2cEGKqHUQxbr8SLaF5C/HZ3ewePKbveGIjbv4qgGiHVSQW7
	7gp1x3izH6DD4cLeAOq/R3W7e9pNaliQYt58Yv/elFxvkOKY0KtKoqD4CgcTXoGetZxTsZ
	l8+9v+Q0wUgAxoNybL9BCThOowpZxb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753209038; a=rsa-sha256;
	cv=none;
	b=0dslPcN1OU7D8N+0zfHCNEnoRVXnM3FbS+zrGJf2N6KLRlaFWUzreYE7I8QLqW/7GHN3GR
	jeqeZ4GMJPj0AvUSl/HU+6Yj1Wn5pMRAWo/xFNDHSQmRvSi0dDbjuPbmzxU6zzswg9ZhmJ
	PS7m3dFSSrApx2uI9+QlvPseVSf/Hik=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 23 Jul 2025 03:30:33 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 23 Jul 2025 03:30:33 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com
Subject: Re: [PATCH 4/4] mm: swap: Per-cgroup per-CPU swap device cache with
 shared clusters
Message-ID: <aH/YyRs+UFBAtkza@yjaykim-PowerEdge-T330>
References: <20250716202006.3640584-1-youngjun.park@lge.com>
 <20250716202006.3640584-5-youngjun.park@lge.com>
 <CAMgjq7COLbfGwd4CYxNBaLTi4UaPDkKQzkLhsV-caoA-xq1V-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7COLbfGwd4CYxNBaLTi4UaPDkKQzkLhsV-caoA-xq1V-g@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 570B814000A
X-Stat-Signature: 63am1xoe9owse97mqg5yi1tia859mfuf
X-Rspam-User: 
X-HE-Tag: 1753209037-322184
X-HE-Meta: U2FsdGVkX19m+Iv4CJeo9oXxxGIogObLTq0ot7dydcxHb2kFKeuoK8nm3IIJ7KDSrJIxsN8nWhzWj933wWdMZ/0gtJYncZTpNv/guLihB3s62azbQ/0Ns0pFejSeTxAqch4rNhWJpRiVuocuGsnsjHkEd6H0QLQn05P359N6xQoxClJJW69QztrosLW/kcuAxEcployl4o7+n3ttpJf0fVKbtGgXOsQOrLJUduEK8dca+G7RjX6/C8pd9rOZBMKs5JoK/9qA12tZx9bbJRRMvrVzeUPlA/jvoXaQjG2dq28kStd5c0e0hURfUNEPfbo6waOQodpeMuOAUT4I7A5VTrNOR4z1SHZ1JRNBzrro1YzBkDHl91C4YFHHvFrw4zb6XgVN5eVqZ89NaVa7F69VRjJ9FLaYe24mNA+dWGN12YKKz5PjwvyaAZU1jT+CdFmBpbtDUJyyyOxv07XypPI6+NEP4DY5dy3kKxISPuZXIq6jjGbzA4JOU/xUDc1JVGqJK1Y7a8aNNF8Ktk6vNSbPTD4G5OgCkZfIfFAH//N92Y2DKRADYSv4RDSIPP4ltstgbMxCD4XfNfs9gEwp3nAFqQ5LPgAbWFvCPTtMQVy2mtOdwaLt+hirG4fH+AU8jhj9V95fP+K+sVy1oXhV6B9GymzejGXcxsbT0lM4JyRU0iw0VtYDdrm7WJvx6QxczHxx/4LID5u2iTSUnDbJtXK6TQ4o+DISPQQK92beB3Uy9fY6McbMXuVg3EPFZnhDBazJt7fX8N4CKQAYgGr4sUdPQoRwVDsWdu79CnYS6qCyrXVrRGQNCtkKYmqEPkRxxELu90wHLdB4PU4sUoajAZAVoprIt8VV5J/DdT9RYnuzos5p8HjQGj7miXp7AvHADJiAYgAB5V/tquzQ4JMnC0Rqk1lYf9BQjpfAOp4ZwFg8MVTl1cF9ySJdg/eGxXBylh6Svijt6AsfkDvsPaqh7Ua
 pr2kXXjp
 4rK4MYtdteLtibzz//e9oj6IBwtRdgjglvxq6a91rcT9pL46ZBWnermXNPMDVaNrXmIr81Ix6fW9Yn+/0MoifAy5eB8qJ1gSllxwdCwX37DteAC/l/b3UG1EXitTh/CASWC5QqZSHTiSRtT3SpNy4eg3DVUBVDOMpVjhWsYqmd8wM6DpqF3qiluM7+comJ7GHFyTaJN6508OdXwwEbN1ZDHMRdGzE/E74eiDIahDWbpyOAliQofunFEGWRmqiSkIIAAPfCZKJVLWsHnQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 01:44:49AM +0800, Kairui Song wrote:
> On Thu, Jul 17, 2025 at 4:21 AM Youngjun Park <youngjun.park@lge.com> wrote:
> 
> Hi Youngjun
> 
> One thing I noticed after a quick glance is that this
> swap_alloc_cgroup_priority is bloated and it is doing similar things
> as folio_alloc_swap.
> 
> I imagined that we can just have a struct (eg. let's call it struct
> swap_percpu_info / pi) as a closure of what the allocator needs, it
> contains the plist and fast path device.
> 
> With slight changes to folio_alloc_swap, it can respect either the
> cgroup's pi or global pi. (might be a horrible name though, feel free
> to change it)
> 
> For example first thing swap_alloc_fast do will be:
> 
> `struct swap_percpu_info *pi = folio_swap_percpu_info(folio);`
> 
> folio_swap_percpu_info returns the cgroup's swap_percpu_info or the global one.
> 
> swap_alloc_slow can do a similar thing, it then can just use pi->plist
> and pi->pcpu_swapdev, (cluster info will be in si) ignoring all the
> cgroup differences.

I was also considering whether the priority handling (like `plist`) could be  
abstracted to unify the allocation logic across paths.  

At the time, I leaned toward keeping the existing allocator logic intact as    
much as possible, which is why I avoided introducing a new struct and instead  
duplicated some logic.  

Your suggestion with `swap_percpu_info` makes the design clearer and aligns    
well with what I had in mind — I’ll review this direction more closely. If my  
thoughts change during the process, I’ll make sure to share the update on the  
mailing list.  

Thanks again for the helpful input!

> Also it is better to check your patches with ./scripts/checkpatch.pl,
> I'm seeing some styling issues.

I should have paid more attention to this.  
I’ll be sure to run `./scripts/checkpatch.pl` more carefully and address those 
issues in the next version of the patch. Thanks for the reminder!

> I'll check your other patches too later this week, thanks for the
> update on this idea.

Thanks again for the great idea, and I really appreciate you taking the time to
review this in the middle of your busy schedule.

> 
> Why not just remove the `percpu_swap_cluster.offset` and just share
> si->percpu_cluster among all cgroups (including root cgroup)?
> 
> Otherwise, eg. if rootcg's pcpu cluster and one cgroup's pcpu
> cluster are pointing to one same cluster, they might be in
> contention on allocation of different order, or even in the same order
> the performance might not be good as multiple CPUs will race
> with each other.
> 
> It will be easier to implement too.

I originally kept `percpu_swap_cluster.offset` around to
preserve compatibility when swap cgroup priority is not enabled, and to        
minimize disruption to the existing fast path.  

But after reviewing your suggestion, I agree it makes more sense to unify this 
path and always rely on `si->percpu_cluster`, even for the root cgroup.  

This simplifies the implementation, and as you pointed out, avoids potential   
contention and complexity that could arise from sharing per-cgroup clusters    
across CPUs.  

Thanks again for the clear and helpful insight.

