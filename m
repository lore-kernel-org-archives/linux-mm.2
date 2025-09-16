Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A33CAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 19:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE93A8E0002; Tue, 16 Sep 2025 15:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99F58E0001; Tue, 16 Sep 2025 15:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6AB8E0002; Tue, 16 Sep 2025 15:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A801B8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:45:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B21B56CF2
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:45:58 +0000 (UTC)
X-FDA: 83896143996.26.7F89FB9
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4B6F140009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:45:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=d6X+iPLA;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758051956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXM3OherOxXkqWIyrsQ9zL8fL1brdbQvLSDZy9IQvPI=;
	b=f24BPLw4psfRy3r0wLAQ1Vfg6JBRP7mjREh28l1w+f0XU6d+kDbGNFPE/uLNmC5gQ8zs4u
	7PsVbLg/g6tEdRdVeEwsGhiZFrmJW38pw4nkUOioHSAL4khV+Bl6u5KfNP5ehegIrn6Vym
	JmSWFhFJAU6QL5zWGpx9Wi4uzA485ic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758051956; a=rsa-sha256;
	cv=none;
	b=guupfBs1xPmHyFdumlW65RkLzyk8jFCaPN/q1IJlYnUJRUNRK5J+At25L/iSeFspXVzuRj
	fJ41E6+jjB4My1eLyuC+F5kvaec+klnYedHaWhJIMHtXKUj6hZSvN+jJ22FRdOYGN7zgZI
	/gm9mbcdlq0JXM+2cH/mJwCn2RzNzkY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=d6X+iPLA;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-265f460ae7bso38515ad.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758051955; x=1758656755; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WXM3OherOxXkqWIyrsQ9zL8fL1brdbQvLSDZy9IQvPI=;
        b=d6X+iPLAvaXZdD7CgIZ0GOC5mg7gJhOZ0vnpZ3qS+49AlFTaE70BpOeH8y9KtWTCFA
         ENYKk6Veb1sHzl0mc5mbkiMQjasfQiXm0xDzyihfX305sAbrj0K9Z4JHMcGFnci8ZE4s
         AQ4DL2CA/SCA5R0a+JB2bz5T6S6VjGiwcLChToh/ct8ErCvJTt4PSavSqZDZ405Y5s++
         /RDVRbEEX0nmvptD+8cA8kW7guVaOgnddrP3iaMHVf9aGaDlDptBTJdEQWl9b0VWvBx+
         mKDmb3dtAl6K88VoA0JJYN4Qkt7j2UCrbxC/CTO+h9dxwIp80lnJqwNul083KIk1X48D
         ykiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758051955; x=1758656755;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WXM3OherOxXkqWIyrsQ9zL8fL1brdbQvLSDZy9IQvPI=;
        b=ADNq8Nw/CsJriScDyrKjb0wKsMeJsAH+lFtj54T7fc8tEcGVDOBhUQ35SjC0qxqvz6
         oicyxtouhbZWDgPOJP6YZe18h26r6OwT5kfG0gckGCCFxpKAYeZQUgZEvsENgR2wmTAG
         pc6QkEywc9c983qe/znoU/4fP1nqJmMl/8rRkQs8kGOGLrkCSdJYZ+rI4yoesTll6gpq
         Ed/VVJfWCywPU55NRO/cYJ/Z+azBn54USco4UBa7gRVHVPa4YC/lRvppFZfQPjD0v8wd
         7EcGtyMnONVjr+RcAjCPPGsFo3FXCRJUFQr1y8N5PDuadLjdTBYjuz823ev6ji1Gydxm
         YjhA==
X-Forwarded-Encrypted: i=1; AJvYcCWx26f8kMAVS/GWtcQ0fcZrRnm+yg/UNzrx3evlzQ87JIRzmFqVD8vI7ifbS0Qqx2kilEErwz6gRQ==@kvack.org
X-Gm-Message-State: AOJu0YyVLt12wK++UvDzJfIjSG44IgdfXJmz6HZ5jmXX/ktM+oaGELA4
	Hhxf9mIlpwRqcXRpzy09fWNcDmgJc4Aiw5Cd+irsIRcTzs3q+y2u8cOlKhGLtMl58Q==
X-Gm-Gg: ASbGncu1uj2MtM9tCbNIpkRL+PDxKN+a2nV2YRLnzqw1SeVS8dMmr+GR3sZ5IKpiQJ3
	/T+aS4aayC34iOe2mkjRDTkgoJAId9wM+5N+W7Gb2iJCna2RxYE5ZCLXiTiCq1prB2GqLJBxXaN
	CULZrM8wEFWLcPruBKs1N+cFtqlgLgi9cbAxdG40uUJk3LfWnpFZiss14wOtq7uot8eRIG01HNV
	No2F3ffEeC/ThMd2yhkIMSDGcfNRbaZC440T78lwC0M2MLCkbkM12fDVeEDXYyBz6of40las450
	A5MLxBLqHZ5l3/Fgb7Ay1uFKBREhQi0/Gd/0CXNN/yPEpKqhGmA8s7kWNPeLyNDD2ELXY4nMo5b
	cbfLtuFYBnkKzyRGYv6Rlu3N+QX9NscwWi9jvrR+S3h22EB0O5hmB50jUajwwpgm12P3u9ijAT6
	VstX1YbBNvKIyY/2HMh1FMCwLsJjkuiv9OJBCx+DEVTl0Eal+29TO9EnU=
X-Google-Smtp-Source: AGHT+IGjPGu9s+AIR2l3SAAz572RtyzuJretv9YBUb86Qie1/rNMrtg4jD6x3++QZ4cS6ZRI4s1Hjg==
X-Received: by 2002:a17:902:d4c2:b0:248:a039:b6e3 with SMTP id d9443c01a7336-26800f661e8mr985795ad.10.1758051954838;
        Tue, 16 Sep 2025 12:45:54 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:3226:ed0a:4c73:99d2] ([2a00:79e0:2eb0:8:3226:ed0a:4c73:99d2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2651ca217d2sm79165505ad.43.2025.09.16.12.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 12:45:53 -0700 (PDT)
Date: Tue, 16 Sep 2025 12:45:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Gregory Price <gourry@gourry.net>
cc: Matthew Wilcox <willy@infradead.org>, Bharata B Rao <bharata@amd.com>, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    Jonathan.Cameron@huawei.com, dave.hansen@intel.com, hannes@cmpxchg.org, 
    mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org, 
    raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org, 
    weixugc@google.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
    dave@stgolabs.net, nifan.cxl@gmail.com, xuezhengchu@huawei.com, 
    yiannis@zptcorp.com, akpm@linux-foundation.org, david@redhat.com, 
    byungchul@sk.com, kinseyho@google.com, joshua.hahnjy@gmail.com, 
    yuanchu@google.com, balbirs@nvidia.com, alok.rathore@samsung.com
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
In-Reply-To: <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
Message-ID: <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
References: <20250910144653.212066-1-bharata@amd.com> <aMGbpDJhOx7wHqpo@casper.infradead.org> <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 8d6atqxgoq84xtbw8wntsxnrbynyp3gx
X-Rspamd-Queue-Id: 4B6F140009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758051956-425775
X-HE-Meta: U2FsdGVkX1+s+ZInBYLznRbgvlbMFphXqtgHfaI9OjCpeZKaki+l9aUL5E5zmedo9EGmUp7FYJZ5mQD85pohd2LAMEi4jlj+ArTn2iXAExqfy7m9savjISv++4dSN5cCA3UnbHt8NJUKkQSndrKpd/Arbqcb9sSustsU4Go1RhNGXmfUDtdbmyfnvoYy28c+qMWrAUnIJCQwtum6rAmQ0+18VQDKoDmgL5yUsN/aG/JJyj1Zw0tXiPEbolG2qdl9DfmCuHrTit2tFTevACFJslWrAp+DuRegaxaBmsuixbu6P3TM4B9UGiMk9SjBsL+tpLs6KvoNJLaVPJmwqGOENq0UB3XcSmpCXAWyFNSrvTesusX32Oq6ZIzdP4y6qt4RH/CuccF7NECGHulSvuErPO0MX62o7ZOE8DOPE3EDfDTqJhqtFc/m7AIRq9w9xV6VBinoBG0XZvC9/SJI+D/wWOeJF3gGMk872NdRWHN8+avSSSyU4gjOAO+vQ6NdMjdNO/YDUWKzO+uPqsT/clOYDUdL7EdydpaGieV/SXNZ6hKygabwwrJVLfG7ilSmGKlJE0XEUk4juwdUburNtdrnuCB/Mjo+J/s1CcuNSmjroKjPfR6terGvOrh/8YCzZEzVANDJwMTdsVRnR1RVvsB8lI5V5c0durMQ6F8O0jw68hNmKnAFO6SGWaAq/fdM5Ns6bcWPJPkUeWNgjFZsTEpD+wPPlomngcJBcg2ljAlJ9qO6PQSImtoApRE9O1pWTl6Wqjpd9L0pA3WPPCbhl2namhyISAbCE0DIXwEBu0utkSb5wpEU3ibyleUNgLJqAJNv4Sm5R8p56Y+CLkDva9Kw60hDwY7ChUVMBuTTMKtPZdMCquHAaqoKNMgnDPfOhFpzG9DlhbhWpAd7w/icdvIWyUXzKCjn8PzB4leQbXdhebMRcZPNGhUouegDl6tJWm0y0mGJ2IzHsinlWZsCUTj
 T0zzMlVo
 7nQP0yTWRjACHp85L/t5YNoYMzG9NoYTD3oJ6V6u7CiezdQwbMLy+uMIEZYT0d+G0+xBHXDn03qyxL4kMCfYiWDAzah7yXQT1jGa57V5TKxMh50AGn6kxylhYUjRnX7Mwglh0/wdXwkUtngPUdKIrJ+aBBlf6FZjuZU3oOEnSk3NUGpdk0PflJAhNZPr1dsWa/j6A0AbnwqV6GWSmgufUvEzMZPzkjZaDP+oW1sejg+vvEU2KOwkx0K6QYvOG0HEYZagvrB+HZhM6WrLV6Xko74j9+Sy9Dyqz3a6B4N6DQouIL4d6EZCW3Mcl4Lru+81cvd88FD2s9iQiDaGhhLCMDwf/15S1T7Y3ajWkt4O7fzseWTUAPbsj8C93HA2Df8839LMURfIsxjk5dicvNc5ARTqmXGOmO72tIGEvtCOdXEHY9uqMVn0lexnKBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025, Gregory Price wrote:

> On Wed, Sep 10, 2025 at 04:39:16PM +0100, Matthew Wilcox wrote:
> > On Wed, Sep 10, 2025 at 08:16:45PM +0530, Bharata B Rao wrote:
> > > This patchset introduces a new subsystem for hot page tracking
> > > and promotion (pghot) that consolidates memory access information
> > > from various sources and enables centralized promotion of hot
> > > pages across memory tiers.
> > 
> > Just to be clear, I continue to believe this is a terrible idea and we
> > should not do this.  If systems will be built with CXL (and given the
> > horrendous performance, I cannot see why they would be), the kernel
> > should not be migrating memory around like this.
> 
> I've been considered this problem from the opposite approach since LSFMM.
> 
> Rather than decide how to move stuff around, what if instead we just
> decide not to ever put certain classes of memory on CXL.  Right now, so
> long as CXL is in the page allocator, it's the wild west - any page can
> end up anywhere.
> 
> I have enough data now from ZONE_MOVABLE-only CXL deployments on real
> workloads to show local CXL expansion is valuable and performant enough
> to be worth deploying - but the key piece for me is that ZONE_MOVABLE
> disallows GFP_KERNEL.  For example: this keeps SLAB meta-data out of 
> CXL, but allows any given user-driven page allocation (including page
> cache, file, and anon mappings) to land there.
> 

This is similar to our use case, although the direct allocation can be 
controlled by cpusets or mempolicies as needed depending on the memory 
access latency required for the workload; nothing new there, though, it's 
the same argument as NUMA in general and the abstraction of these far 
memory nodes as separate NUMA nodes makes this very straightforward.

> I'm hoping to share some of this data in the coming months.
> 
> I've yet to see any strong indication that a complex hotness/movement
> system is warranted (yet) - but that may simply be because we have
> local cards with no switching involved. So far LRU-based promotion and
> demotion has been sufficient.
> 

To me, this is a key point.  As we've discussed in meetings, we're in the 
early days here.  The CHMU does provide a lot of flexibility, both to 
create very good and very bad hotness trackers.  But I think the key point 
is that we have multiple sources of hotness information depending on the 
platform and some of these sources only make sense for the kernel (or a 
BPF offload) to maintain as the source of truth.  Some of these sources 
will be clear-on-read so only one entity would be possible to have as the 
source of truth of page hotness.

I've been pretty focused on the promotion story here rather than demotion 
because of how responsive it needs to be.  Harvesting the page table 
accessed bits or waiting on a sliding window through NUMA Balancing (even 
NUMAB=2) is not as responsive as needed for very fast promotion to top 
tier memory, hence things like the CHMU (or PEBS or IBS etc).

A few things that I think we need to discuss and align on:

 - the kernel as the source of truth for all memory hotness information,
   which can then be abstracted and used for multiple downstream purposes,
   memory tiering only being one of them

 - the long-term plan for NUMAB=2 and memory tiering support in the kernel
   in general, are we planning on supporting this through NUMA hint faults
   forever despite their drawbacks (too slow, too much overhead for KVM)

 - the role of the kernel vs userspace in driving the memory migration;
   lots of discussion on hardware assists that can be leveraged for memory
   migration but today the balancing is driven in process context.  The
   kthread as the driver of migration is yet to be a sold argument, but 
   are where a number of companies are currently looking

There's also some feature support that is possible with these CXL memory 
expansion devices that have started to pop up in labs that can also 
drastically reduce overall TCO.  Perhaps Wei Xu, cc'd, will be able to 
chime in as well.

This topic seems due for an alignment session as well, so will look to get 
that scheduled in the coming weeks if people are up for it.

> It seems the closer to random-access the access pattern, the less
> valuable ANY movement is. Which should be intuitive.  But, having
> CXL beats touching disk every day of the week.
> 
> So I've become conflicted on this work - but only because I haven't seen
> the data to suggest such complexity is warranted.
> 
> ~Gregory
> 

