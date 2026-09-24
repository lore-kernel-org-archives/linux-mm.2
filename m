Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1269DC982FD
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2B426B0088; Thu, 24 Sep 2026 01:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC356B008C; Thu, 24 Sep 2026 01:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB476B0093; Thu, 24 Sep 2026 01:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B22C86B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:52:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 323474022A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:52:00 +0000 (UTC)
X-FDA: 85247584800.10.037DF34
Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7E54BC0002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:51:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sP1vWwUl;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.210 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790229118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3jZjXbIir2mY+Q66YvPamSsdnovUnr3N3wG+lMQPPA=;
	b=CVZg91KmIt/DFoEmdp0uJHHr0Vbn9vxbLjlqoq83UwTsQwCDwcDZwM7k9ZI0NbqOZ+2H3K
	eRwHFNbQSu2Ue6ZxkZwuSJiouxHYbteMIX0mX6kVs136THRmcuc4680vvEwpQ3N+8qOtez
	exlHO9pDIRrfnCBpoZcXPmPhh5Rxlz8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790229118;
	b=R93WfI9prY40EBU2UISBlTLAD+q3aSWKUs3RsC/jGn57O2LM/ofsNdJGHLdlig+brg/RjX
	52N7evAjmNNG9lsPyQGmMq5iDssAwRVoR//19Mj7H0TrlU/F3t0V1zLmbj0lQNZbw8Xmxr
	NlU8AfAJQTQLKOrxaxwT6fL4BZmeaoU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sP1vWwUl;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.210 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Qh8p1Wq/6FENjB4kTXNkMpLip9RVFvwk/eduC06xJC4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790229113; v=1; x=1790833913;
 b=sP1vWwUltxM/z61RttITi1TTXJcaD5qmwVoAGCwAH6bUAhg+1oKaDYiP+Cx3RM9SgwVFvEmq
 TIATMENnAhTTqe9J34sC+epd7JmzmW6vzuTUnL8Eu+Bxz0qFhMcgSZOSoVAMBvJ5EL8Rr7seKSy
 nQtHO6IQ+KYN4R0qxzdZW+sc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f5f74063f00ab3a9;
	Thu, 24 Sep 2026 05:51:52 +0000
X-Mizu-Trace-ID: f5f74063f00ab3a9
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 13:51:50 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arS6dvzAI5XLHuG-@MiWiFi-R3L-srv>
References: <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
 <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
 <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E54BC0002
X-Stat-Signature: nexunbcx6np99xcsgjbninhqfuwu7rob
X-HE-Tag: 1790229116-858276
X-HE-Meta: U2FsdGVkX19J6JwOiDGF0LJuy50oUnJcOLpgs0wG+G4UdBrDrXTN/2XUgOXz1VlD+JiUf1dqGJ65y9KnwSBpKep59CirjCpGVu4iChfVQDkwbbYolwdkRYrQRYfG5+cDdyAm0rQVaf/+HjMd6RE11a6uDV17YKyjrAbN9I7C4yKJ6aY1g+5OibZmRxqKaCHg/Nxxt3EBhBBi8xGj22zOcsy6PmxoP91XBQ9xQty0zROJs8PFXTRvs066I+XKXibLZlkjil4Tv+2Qwp2UKtUrazXzigy5KtlJO+m39U9VikL2vF8a8xM+po3HevidwNBSKGmUtxhM3GoJLcXr5vEyEtvWRyev/WLHGJ9gbqPfZPTaw2eQLwDmWX7rfotvhmRE32yFCftkzn98NX3CBb7pQaC7Hv0JVZKqe5m3wFjV/shYNpVm5rATo3hCdu2O7VxLPBNvJBmtHkRMFDTcrsXYH+jmpS++IjL0qawBOmjiEBEWp59KRLuTw+8yhg5lWqabTCcDDhkVuJ2AkNmC+qIL5Q9uAQBcyGNs3y39+xQFweblL6LP/zuaxAbQFhHqh/5MKZirpAhk4A7/r97VheNWNnV+USyjzwETXIiamC95x5eOLoHBBkr6vkFQKBqNix+Ecs/Q3X/zfuDtNzqAe7yaRnAF7jvPlTPWnZcPXjwZx8XRYxnq84s0o1ZBqJOC+6QqTEe1vqt9OgwMAiTgZJ1cmaOZpc6kGUWHoGisLd4P5coA2BqxQ/ryA9Ah3/OXttzyIO4ViycPP4g9h/7cZtJZiF08PWBQdqmrHsqKRZ+NB+DixvkEuLOSmyTlcKJx0QIrCJuZfW3w7rCMgkNw/z1KPD4EeKg4I+EO0U7TbuX7w7kB3XVUATMxDcS5vavLoruAyZ6XSbJjFRTL6vZ5E1eYT8Ss6Azv1gkGPfSvc6732V+Bh9XoE2YmKiwg+RLvY/xK4UTm5dLilPjYAjfuFUg
 pL+4PjDH
 aptuao4AayshHTgfvE/x8es04wpR4Q5N5X4d5YdF2g7vTl+7SsBnFbG710/ymkIocWwGBQUo0uIrUcIAVTGPwTg8sS5NYKAhRcWwRXNAJtAB3+7/uNDUptsmcb86mMv9+AUSlGsofYk2xJ2/ye/i1JcH65E9v9gl0FhKviI1sHQZePEJmeGde6e9G3i77q5z01g5QheUKfMtqdlNngU11MgPb8zwguQGcnr9/b5kgdWhJd+ma6W5yNbF/rSRk95dE0EmkSs+GtiIqVc7mvRXPJR8wJEF1djigsYMnYiLkWR/nnKYEQft5k4ys6Ap2lFJfJeszbGc/b7YsUQGtJdFuBaLcSQ4ie0D5+32pIiwKb7zdymB/btwozCCKt9cem2NfMwdOCl6J7X1VE+E20l4Z7TF0LdxMKNesmoNK8HJSNu2OFckdlSKHwQunEyFbU9eFa5tH8FVFIb8e68zjDlvJI6AxR4kdbVenBkhkUJqh9928ZvqDaodvaA91kpB4yelcQAAkxLPHgfEGgmF8/UJ5/bJn3GQi4AV7DRh0q1D8iDFgL5RhnBZvrYi3QIdBshSWY0xY39uOA4OtNgEV9a5OHkjtVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/23/26 at 02:52pm, Klara Modin wrote:
> Hi,
> 
> On 2026-09-22 21:10:53 -1000, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 5:53 AM Rik van Riel <riel@surriel.com> wrote:
> > >
> > > On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> > > > On Tue, Sep 22, 2026 at 5:20 AM Gregory Price <gourry@gourry.net>
> > > > wrote:
> > > > >
> > > > > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > > > > Right now it has 64GB of memory.
> > > > > >
> > > > > > That is exactly my point. You are running 1/8 = 12.5% system ram.
> > > > > >
> > > > >
> > > > > Chris you are missing the point
> > > > >
> > > > > Zswap:           8812236 kB
> > > > > Zswapped:       24927876 kB
> > > >
> > > > I am well aware of the point. The 7%-10% data I provided is before
> > > > compression. After compression, the real saving is about 1.5% - 2%.
> > > >
> > > Here I'm at 28% without any issues, with room for
> > > more.
> > 
> > 28% is one thing, 100% is a difference beast completely. If you
> > haven't tried it, don't assume 100% will behave the same as 28%. There
> > is a point where too much zswap makes the system unusable. It is hard
> > to pinpoint the exact upper boundary. However, figuring out the upper
> > bound larger than that exact boundary is not hard at all. I haven't
> > seen any one can use 100% system RAM sized memory swap out to zswap.
> > If you have a data point showing what that system with 100% swap to
> > zswap looks like, please share it.
> > 
> 
> Chiming in as more of a user perspective.
> 
> On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
> zswap during some parts when building GCC 17 snapshots. E.g:
> 
> MemTotal:        3966864 kB
> SwapCached:        31872 kB
> SwapTotal:      16777212 kB
> SwapFree:       16638128 kB
> Zswap:            280140 kB
> Zswapped:        2859840 kB
> AnonPages:       2927376 kB
> AnonHugePages:   1409024 kB
> 
> While this is 72 % rather than the 100 % you asked for, I think this
> shows that what size a potential limit on the uncompressed size of zswap
> is suitable heavily depends on the workload.
> 
> I have been using vswap consistently on all my machines since about
> August, and I have also tried one or two versions of xswap (but the
> current lack of writeback makes it inconvenient for me). I really

Thanks for testing xswap and reporting issue on xswap rfc v3.

xswap has writeback now. I only built foundation for xswap, while
writeback part was left to other people for collaboration. Finally
I added it.

[RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
https://lore.kernel.org/all/20260920072043.430390-1-hebaoquan@kylinos.cn/T/#u


> appreciate the work being put in to decouple zswap from needing a
> physical swap device to work.
> 
> > >
> > > > You are not listening. The boundary was set due to feedback from the
> > > > application SLO. Those are real deployments not imaginary usage.
> > > > Please respect the user.
> > > >
> > > Different users need different things.
> > >
> > > The kernel needs to be able to accommodate all of them.
> > >
> > > The kernel default should accommodate the people who
> > > are least capable of configuring their systems.
> > >
> > > Hyperscalers can set their own defaults across their
> > > fleets. They know how to adjust settings.
> > 
> > They can use a safe value, e.g., 100% of RAM. Let the people who know
> > exactly what they want to swap configure the boundary they want.
> 
> My personal preference would be for a default uncapped (or very high,
> and I don't think 100 % of RAM is high) limit on the uncompressed data
> which is backed by zswap, since that would mean one less knob to tune.
> 
> > 
> > Chris
> 
> Regards,
> Klara Modin

