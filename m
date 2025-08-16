Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07431CA0EE9
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 17:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9CA8E002B; Sat, 16 Aug 2025 13:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815EC8E000A; Sat, 16 Aug 2025 13:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706DC8E002B; Sat, 16 Aug 2025 13:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58CF58E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 13:21:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDFEB1404A0
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:21:26 +0000 (UTC)
X-FDA: 83783286972.03.A588AF1
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3D89D140009
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:21:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755364885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uHMw85qGQOaHO+wJumWTzsT1jjB+PbnjSgvXvtbWF9o=;
	b=QQLCQbc5KF0uyjbRBogH8O/Jev/1byHp4Zvn53vTOyV+CGFPjQFiZAVR14+AFmdNr/tlrz
	weLPqhG0gPANpqk4SHgatTRQFv8v6nj+Fqp7sFWT+NAlmMPQo9LEEKSZUXeOkLTCz+uOUX
	krwrcwhDE+a93t/LXlFuljR7/eZ49CA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755364885; a=rsa-sha256;
	cv=none;
	b=UCxDQihJNLBufevx6e/gyRYiKVgVWx/KMyHGKtxuzDG5neZPQsf8thA8AKJBMW0TFfmEP7
	cqQz16FlbTgVfWhl+hUqLotSgS0BwRwIHRD8piLyz1Y9GgEYJzwv/2j+6ULiM0wGwjGUGW
	GAcBssnRPARL7zLJs7tvrp1WmR2hLtY=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 17 Aug 2025 02:21:21 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 17 Aug 2025 02:21:21 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aKC+EU3I/qm6TcjG@yjaykim-PowerEdge-T330>
References: <20250716202006.3640584-1-youngjun.park@lge.com>
 <20250716202006.3640584-2-youngjun.park@lge.com>
 <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
 <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330>
 <aH/baxIgrBI3Z1Hl@yjaykim-PowerEdge-T330>
 <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
 <CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D89D140009
X-Stat-Signature: at7ot8i4xr6goymtgj6zs4shnjrbkkj7
X-Rspam-User: 
X-HE-Tag: 1755364883-601596
X-HE-Meta: U2FsdGVkX19y6jBNg5i26cr29S9kqy70zwKBk3Dl+RUZrO7JumkckwQ0WtCIi+2NZWtGQsRDjvcEJuI7EGYz3UE0Mz/8DrnFBf6xQI1tRji3VAZj8Pmd95lXk4aJ264wTI4SPR1WX3XvbN0i1VdOq0vuFuVaKsHmdhZgJV3NxT3xeHp0PCv4Abx1THAtZAq3KjrtSI6Sh4yFuIX2a76va4eZanfrVaL0NqFOIeoh02CqVP6FQUbcuhmA7A06MiwQd++ESCQ60U69Yb1DxOwcXpztnsohNFuc7kDmvIPGhjTOY2vJqoRUWt14tEu4ag5Y5sdtEQYpUXkiNXvRzyJEwtdvtBRaP+JgvkeCI/Ta7oKaKsPDD7GQuvPD5OCpFgssvSF9WuIfKL2CQPWlvTLKQWciJsxfz4j3YgC3KZeFaGnowIn7nIKxmDMnrqtKgFoxaKNYmS3cOHnmpqQxkArRyFmqGNpNcyZC9yhKKL63GvCYWBH00W/xLIlIHvk6jsThUJA3O4Zgo241wxx4LgRXr6vOdfmzKRuqow2Bhpop/P9qQH2z7bvYjlq8/IgtOgVHW6aiV+7O/8CS3su5WCt00riaB+4tKQmrCPzcRoHq4trnrnWlD6JHi6SOuT3rnPU3whbmLr1zCQKDq9sgUPob4JoxtWPYb5HpPnzAHTFWBPvqrSQcVh1ZMNN7LLhKd/IERZQ3kHykX/Ffq3MFtpwMY6NPTYwfJBCs1PtDOJV/hEsp6kW4iDO2bMdE9uT+YDWtK2wZuil+Jps8/SLeZX+XSVqM4xQsoAFYMVe5FQK5BwiablyX5hUPgBxTddarqxAPYepwRKFPyIgQH8fi+3sGQ5ZFTKSv/oNEhhiDVAbsdzA7F3KrnBc70TgiA1HWaN7hW4N/ZQLhPxJALZasmU/G4COfY/vPumuWqUyyyljeMx6JnJ5CM2WQwI+HhDxue4DgoLISObOeKooSF6YClMl
 wde/gI6Q
 TJVxqy7Qp20Ur9yN78AC+ve8fsmZgRarS4JqDjYuwm2vzBFioU8659n75PCwLXR6OhMSeeXbtHQy8wvMdQwC2W9J7aRYBNb0QfWdx43daikIfG5pqlfCtTE6t8EJU3xx/Vy7y2NSuAoR0smvLgI/r314IihwaXx3SeBhVXfS+cGEOSePB0bnJ30NGH4Yu1SkqRzoccPW1FWz5s60VGzqX58nWrzipJ2mJFw+7Qkx6Dq6BRBqEjtnu9I7NZawZzG9an14TRWKxAoABldk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:10:09AM -0700, Chris Li wrote:
> Hi Michal and YoungJun,

First of all, thank you for sharing your thoughts. I really appreciate the
detailed feedback. I have many points I would like to think through and
discuss as well. For now, let me give some quick feedback, and I will follow
up with more detailed responses after I have had more time to reflect.

> I am sorry for the late reply. I have briefly read through the patches
> series the overall impression:
> 1)  Priority is not the best way to select which swap file to use per cgroup.
> The priority is assigned to one device, it is a per swap file local
> change. The effect you want to see is actually a global one, how this
> swap device compares to other devices. You actually want  a list at
> the end result. Adjusting per swap file priority is backwards. A lot
> of unnecessary usage complexity and code complexity come from that.
> 2)  This series is too complicated for what it does.

You mentioned that the series is overly complex and does more than what is
really needed. I understand your concern. I have spent quite a lot of time
thinking about this topic, and the reason I chose the priority approach is
that it gives more flexibility and extensibility by reusing an existing
concept.

Where you see unnecessary functionality, I tend to view it as providing more
degrees of freedom and flexibility. In my view, the swap tier concept can be
expressed as a subset of the per-cgroup priority model.

> I have a similar idea, "swap.tiers," first mentioned earlier here:
> https://lore.kernel.org/linux-mm/CAF8kJuNFtejEtjQHg5UBGduvFNn3AaGn4ffyoOrEnXfHpx6Ubg@mail.gmail.com/
> 
> I will outline the line in more detail in the last part of my reply.
> 
> BTW, YoungJun and Michal, do you have the per cgroup swap file control
> proposal for this year's LPC? If you want to, I am happy to work with
> you on the swap tiers topic as a secondary. I probably don't have the
> time to do it as a primary.

I have not submitted an LPC proposal. If it turns out to be necessary,
I agree it could be a good idea, and I truly appreciate your offer to
work together on it. From my understanding, though, the community has
so far received this patchset positively, so I hope the discussion can
continue within this context and eventually be accepted there.
 
> OK. I want to abandon the weight-adjustment approach. Here I outline
> the swap tiers idea as follows. I can probably start a new thread for
> that later.
> 
> 1) No per cgroup swap priority adjustment. The swap file priority is
> global to the system.
> Per cgroup swap file ordering adjustment is bad from the LRU point of
> view. We should make the swap file ordering matching to the swap
> device service performance. Fast swap tier zram, zswap store hotter
> data, slower tier hard drive store colder data.  SSD in between. It is
> important to maintain the fast slow tier match to the hot cold LRU
> ordering.

Regarding your first point about swap tiers: I would like to study this part
a bit more carefully. If you could share some additional explanation, that
would be very helpful for me.
 
> 2) There is a simple mapping of global swap tier names into priority range
> The name itself is customizable.
> e.g. 100+ is the "compress_ram" tier. 50-99 is the "SSD" tier, 0-55 is
> the "hdd" tier.
> The detailed mechanization and API is TBD.
> The end result is a simple tier name lookup will get the priority range.
> By default all swap tiers are available for global usage without
> cgroup. That matches the current global swap on behavior.
> 
> 3) Each cgroup will have "swap.tiers" (name TBD) to opt in/out of the tier.
> It is a list of tiers including the default tier who shall not be named.
> 
> Here are a few examples:
> e.g. consider the following cgroup hierarchy a/b/c/d, a as the first
> level cgroup.
> a/swap.tiers: "- +compress_ram"
> it means who shall not be named is set to opt out,  optin in
> compress_ram only, no ssd, no hard.
> Who shall not be named, if specified, has to be the first one listed
> in the "swap.tiers".
> 
> a/b/swap.tiers: "+ssd"
> For b cgroup, who shall not be named is not specified, the tier is
> appended to the parent "a/swap.tiers". The effective "a/b/swap.tiers"
> become "- +compress_ram +ssd"
> a/b can use both zswap and ssd.
> 
> Every time the who shall not be named is changed, it can drop the
> parent swap.tiers chain, starting from scratch.
> 
> a/b/c/swap.tiers: "-"
> 
> For c, it turns off all swap. The effective "a/b/c/swap.tiers" become
> "- +compress_ram +ssd -" which simplify as "-", because the second "-"
> overwrites all previous optin/optout results.
> In other words, if the current cgroup does not specify the who shall
> not be named, it will walk the parent chain until it does. The global
> "/" for non cgroup is on.
> 
> a/b/c/d/swap.tiers: "- +hdd"
> For d, only hdd swap, nothing else.
> 
> More example:
>  "- +ssd +hdd -ssd" will simplify to: "- +hdd", which means hdd only.
>  "+ -hdd": No hdd for you! Use everything else.
> 
> Let me know what you think about the above "swap.tiers"(name TBD) proposal.

Thank you very much for the detailed description of the "swap.tiers" idea.
As I understand it, the main idea is to separate swap devices by speed,
assign a suitable priority range for each, and then make it easy for users to
include or exclude tiers. I believe I have understood the concept clearly.

I agree that operating with tiers is important. At the same time, as I
mentioned earlier, I believe that managing priorities in a way that reflects
tiers can also achieve the intended effect.

I have also been thinking about a possible compromise. If the interface is
intended to make tiers visible to users in the way you describe, then mapping
priority ranges to tiers (as you propose) makes sense. Users would still have
the flexibility to define ordering, while internally we could maintain the
priority list model I suggested. I wonder what you think about such a hybrid
approach. 

Thank you as always for your valuable insights.

Best regards,
Youngjun Park

