Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 093C4C5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD43C6B0157; Tue, 18 Aug 2026 04:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A858A6B0158; Tue, 18 Aug 2026 04:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A4A6B015A; Tue, 18 Aug 2026 04:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7420A6B0157
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:12:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E74E160ADE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:12:24 +0000 (UTC)
X-FDA: 85113673008.29.445B2A0
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8D0D680005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:12:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Dsgha4GZ;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787040742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ut+xbTDj7ZhkvGJB+feKg7bYPoIX3tceZd+RikWwvEg=;
	b=gEdDyINVnLeMvKOvD2HIdPM2qsCWrIO86YabUMGpsWZGh5rhJGpLTRqBH1MQ2uriagCXR5
	ljTHLL+/UkeUgQYm8R34obZ5Eo6swi9Udji9OEuIkSYrQlMtvnzbIGNq8BQXeS+Sd7YJ+4
	0sQ//WSIaDU2YUFeRgIciUj4i3a01Qk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Dsgha4GZ;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787040742;
	b=cSHe1pleqhBIAqft4VJpUvu7QgBZPJe9uL31nL5svWqkr95DqnJ3DXsIYOEOyOiNkqBDVr
	V5QHX5yUIs2zmVzuhwn4OxYBGlDFf670lYpyb1Kq3W84WScCim7cIF0GBfX6knXwPOKbdk
	/7y2W1c4lgpPK4RRA0ofZu2kR1pqCc8=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-481412f1828so1430946f8f.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787040741; x=1787645541; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ut+xbTDj7ZhkvGJB+feKg7bYPoIX3tceZd+RikWwvEg=;
        b=Dsgha4GZpi3XW+2havcNRzcOiOahMBozsIzD1M9qnaqCEsMdLKrVivvV5TpKYHTB9i
         sO+JMj8XCYth+LBJzL9GlkJyC6SunSdeGMU7OTIGNVDD7VPlkOj4FAy+kSKIspjphbvA
         lwi35G47CRichnrM9CWGxgxuUd9+ROtcSsm9b9mrKjJ+ldV4w73a9MQzm2hg5KmLW9hX
         8c14cbOP8C6skahUjNqQzPAAxPeIA/UeLNVTojUEiL74CwMyPJbDQCdSCyUYFKSac5sj
         g1vjsBhTkoxxAiHLOfyIPqUvxvq9qX68AiZP3fDkt+uCS7xnEYa5iqbUCo5eBj3qNGKJ
         /KyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787040741; x=1787645541;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ut+xbTDj7ZhkvGJB+feKg7bYPoIX3tceZd+RikWwvEg=;
        b=R2MuHAnqfcUfUHRJWsDhEsSNbhUka2TGWHVd+tgvG/eQ+Pfa1nSQ6LmiI2ldY8jOv4
         6XqU5iqZk9qhtqn/MCo9XoGCGdus2ISU6T4mwIh0xrVexe2V4E2uTTaaxZ1fYVm8+djC
         IV0IapQ42gsLyC8iy9yPn517YOOKmD1rnHb3gMyksRKYbXLVPVyD26I6QeDo/oYJdCWx
         TDxzAid1gJQdlUecBFAlV8cB4HgJs907tJgerb8SAx6JnC65ejEMw1BThc6O0pYe9cn1
         VEcQFQqjgJxVl0OriW6D7eL5qckJV79okHauGou5kfEGf8vAlwA3JWUijq70/hVeLmyD
         tCNg==
X-Gm-Message-State: AOJu0Yxb0gVEI8R+kNsNO3/0cQNdt+LqR5KNnw9IY1D6COKV2B+nMqp1
	UhsFqNmnah1QfEJocc0Mw6KjRiWg6pzeOlq9WYGL3ntbhA3R+iF5zg+RYQ+KQ2ZHa/w=
X-Gm-Gg: AR+sD13t5kGVRysDNqQmGCzQd3ZA9vmYloPJhuRRzjCgqsXKL5nGP3h0gMdrxemP63q
	VYXetn71LYUcUxQWzB/dc7ijJ3qW1WPREtfAa62G+Basn9DB/SbGnv0n06UWhzO4csWQ567KE9U
	WzpEhV0qpVr8/iTjfqu89CqtZO94ZI+4xu2B38m6h+GtRMpSoAansDPNPb5r3cFNEAXeV/gIgoM
	WgbwGm2OVs7tq1V3zGjAQKu8lLMMxgLmkNOPb+HBOW3ddmyM/+rhtQarXuaQ0Gpe07Ofvx9BB+s
	Ik4R/5581oqBCVvttrYZotmDf8U6mp7hQZU+z9zz8rH3MP4w8fJlyjLlb+YsN+nMZ00S+HkZOjR
	DfZil57hdAd5byzyNnvxHOx8wOBS9fGslvGFeIKTb6/GfepxKjlfaxBPSxmeyNrKiwqrjeRQUej
	S6zISo+wrabOESofGWHYWk9BhvBuXtPra+vEb61tD5GfUtflT1yHzW94FFl69vITPiHx214/4=
X-Received: by 2002:adf:f708:0:b0:47f:aead:f81b with SMTP id ffacd0b85a97d-48160756569mr38056944f8f.21.1787040740958;
        Tue, 18 Aug 2026 01:12:20 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5b77fa3sm9726073f8f.26.2026.08.18.01.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 01:12:20 -0700 (PDT)
Date: Tue, 18 Aug 2026 10:12:19 +0200
From: Michal Hocko <mhocko@suse.com>
To: liuqiqi@kylinos.cn, Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory
 accounting and control
Message-ID: <aoQT45_Vu8KZ9rjk@tiehlicka>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8D0D680005
X-Stat-Signature: ayonpzj7w8eyhwcrw5grkwcajrauskak
X-Rspam-User: 
X-HE-Tag: 1787040742-573293
X-HE-Meta: U2FsdGVkX1/JfWnsq3RmixBBU0liuLZvDQqHiVYmZKHGalhQVjNHtgqLepbHVqB/iwuY5BzyCapemt2Tb5A7FHquowUOJ9C1kOcJAyUnTizOmKUfivuLqri/f2gaKAjBTnkO31O1+arh54QZPjUmCkdqcMoBocB4xwqH8tqyp4lwn/sHGvEcnBLbqRPE59vlUALaX47a1jKTX5Kdk6vf8KU87Eu2mty1vNXyoneh3/A2cIrR2uI/RjzJ5bHc9SOMj756L+rlGmHO8TGMZiSltWHWPMTi93tgZRggOrPOesc/Djx7Y+7ErPDtLokXQkihfc5v2w5nCyCYCPAfUsnmfRIhSKByWaJVJn/wjjU3WAsUVQPmsbGKH2wVfwgm16it5UeM6d1AX5ChdxfEGfGr5zwKt0onrhIHShd5RS5omBAopwgJJwF4YuDhG8NZqCEL2Rh+B4WXgAMlOaHkCm7477C4bpNpFoPbp/QTErxhtHvBZRTy+hEW6MUQEB1mQOWUkbIMGGxAHfrxU2njKVOfDJCJyL5/2nAl3IGwyYnZ7olHQ0Vbay6LhoqA0XWkR9ZH244TACTOHq8HaqmlC69H6DCfTaUiTrltkhD5EkIUBkd6D+ncfK+lmQ2Y3xdukdTANk1AfYi0I2bSn4kxSoRAsPLdIU30Akaq/8E/lhQfAU9PpSWWYQGC9I/ojyKmkTkSObuQSpL7KEIo6+XeNWrgHrmBJzgKF3Fd2lzESj03bGXSckGohcNCB6Tgw2yvY467XvkgYR8fHP1BjnMEWpfw4AulNdvcQ1DyJK0zyK1TxdEbk4R6e/gDhiDLqMW1CfZxbpuRIJZRVLZ52k9cYNADpAixguVNZUl66q4qL186GJdsZ52bvIbSzc00oUukh2USOpRTYkrNY8vwe9QsbUWIGhXFo4LA0AecKg2QfN5SDKnvcXA6WAWffHlTtbliA01JPbfVeOH1ISKugoKGozY
 cvIKBEQL
 9BxqFOZxjSrWhVkQ7msGGVRi/KClCXJeZ3fzNd3zkEXUJHeJJmje/vPy/ILMYyuT/ZuL/kxs7y8rkSbxwFGgX7+AITLbl02hVvoqMKUBFEjF9e8pIuSlojhCwufjuo09982NxY7NtwNS2fzAPi5OVnJc6uGlhGK9M5hYfv15ThasyGRezopcMn/xHxhN81YS72/0CMD+hjqYPl1T3htGMoAN/ZmkRnFCXpb3UhLag+CdMQfVjOQX2CBTPS18rwD5OYzx0OROTeHKBh+OhZES6W7bHAxQQf3xtT9WpVC7S7HLPy8nJJF4CF3kebKvmEvBQ9awSTswFo99ougJ3RjddLfhekmf3l5i3xh6AicJl9b6527VRF+IjKxiE6kUPWuMEVd2svvUj8SiuQsQys9hK1kELkYXGApjoyTOqsCt+17NsChEEprQN+VLmLDIcbCfS5227NYra8N71UE88k4Syarkr4Rh5UUaE+pPR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Are you aware of a similar work in this area by Joshua
https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/T/#u?
We owe Joshua review feedback for quite some time but if I have to be
honest the most impeding factor on my end is that I am not really
convinced tier aware controlling is the right direction. I have
expressed some concerns on one of the earlier proposal by Joshua
https://lore.kernel.org/all/aZ2LC0KPF0xsAwAL@tiehlicka/T/#u

In any way it would be great to talk and compare your approaches see
where they align and the discuss further.

On Tue 18-08-26 10:31:13, liuqiqi@kylinos.cn wrote:
> From: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> This RFC introduces per-tier memory cgroup accounting. Each cgroup
> tracks its memory usage per memory tier (e.g. DRAM, CXL), exposed
> through a new memory.tier control file that reports per-tier usage
> and accepts independent high (soft) and max (hard) limits per tier.
> By default these limits are auto-derived from memory.high / memory.max
> based on per-tier capacity ratios, and can be manually overridden.
> 
> The implementation integrates with the existing memory tiering and
> demotion infrastructure. Per-tier usage (anonymous and file) is tracked
> via dedicated page counters, and cross-tier migrations (e.g. demotion
> from DRAM to CXL) correctly re-account charges. When a tier hits its
> high limit, async reclaim is triggered within that tier's NUMA nodes;
> exceeding max enforces reclaim scoped to the tier's own nodes, or OOM.
> 
> The feature is fully opt-in. When disabled, no extra counters or
> charge/uncharge paths are created, memory.tier reads empty, and there
> is no measurable overhead.
> 
> Why per-tier limits?
> -------------------
> 
> On tiered memory systems, memory.max constrains total usage but cannot
> express "keep fast-tier usage under X". Without per-tier limits, a
> workload can monopolise DRAM, pushing other cgroups onto slower tiers.
> This series gives each cgroup independent high (soft) and max (hard)
> limits per tier, exposed and set through a new memory.tier file.
> 
> By default those limits auto-derive from memory.high / memory.max by
> capacity ratio; writing memory.tier pins a tier.
> 
> This series takes a different approach from Joshua Hahn's toptier RFC [1],
> tracking a separate page_counter per (memcg, tier) for N-tier support and
> exposing writable per-tier limits under a cgroup mount option.
> 
> Patch structure
> ---------------
> 
>   1/8  mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
>   2/8  mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
>   3/8  mm/memcontrol: add per-tier page counter infrastructure and lifecycle
>   4/8  mm/memcontrol: add per-tier charge and uncharge
>   5/8  mm/memcontrol: add per-cpu stock for tier charge/uncharge
>   6/8  mm/memcontrol: add memory.tier control file
>   7/8  mm/memcontrol: auto-derive tier high/max from memory.high/max
>   8/8  cgroup: add memory_tiered_limits cgroup mount option
> 
> Patches 1-2 are infrastructure (helpers in memory-tiers and vmscan).
> Patches 3-5 add the core accounting: counter lifecycle (3),
> per-page charge/uncharge (4), and stock batching (5).
> Patch 6 adds the userspace file. Patch 7 adds auto-derivation. Patch 8
> gates everything behind a mount option + kernel cmdline, so the feature
> adds no measurable overhead when not opted in.
> 
> Usage
> -----
> 
> Boot with:
> 
>   cgroup_memory_tiered_limits=1
> 
> Or remount at runtime (affects newly created cgroups only):
> 
>   mount -o remount,memory_tiered_limits /sys/fs/cgroup
> 
> Per-tier limits and usage can then be read from and written to
> memory.tier.
> 
> Scope and limitations
> ---------------------
> 
> - Only LRU folios (anonymous and file pages) are tier-accounted. Kernel
>   memory and socket buffers are not yet accounted per tier; support for
>   these is planned as follow-up work.
> - Per-tier memory.min and memory.low protections are not implemented.
>   These can be added later by extending the per-tier interface to
>   expose and enforce min/low protection.
> - The command-line parameter mirrors cgroup_favordynmods; automatic
>   enablement via the cgroup mount path is left to userspace.
> 
> Testing
> -------
> 
> Tested on QEMU with fake NUMA (DRAM tier 4 + CXL tier 22), with
> cgroup_memory_tiered_limits=1 on the kernel command line and demotion
> enabled.
> 
> Set up a cgroup, apply per-tier limits, and run a memory-intensive
> workload:
> 
>   $ mkdir /sys/fs/cgroup/mycgroup
>   $ cd /sys/fs/cgroup/mycgroup
>   $ echo "tier4.high=200000000" > memory.tier
>   $ echo "tier4.max=300000000" > memory.tier
>   $ echo 1 > /sys/kernel/mm/numa/demotion_enabled
>   $ cgexec -g memory:/mycgroup ~/stream --ntimes 5 --malloc &
>   $ cat memory.tier
>   tier4.current=296488960
>   tier4.high=199999488
>   tier4.max=299999232
>   tier22.current=1625464832
>   tier22.high=max
>   tier22.max=max
> 
> DRAM (tier4) usage stays under tier4.max (hard limit, no OOM) but exceeds
> tier4.high (soft limit, suggesting that async reclaim is in progress);
> CXL (tier22) absorbs the overflow via demotion.
> 
> Also verified:
>   - tierN.current tracks per-tier usage (anon + file).
>   - Cross-tier migration (demotion) correctly re-accounts.
>   - memory.high / memory.max auto-derives tierN.high / tierN.max.
>   - Manual override (writing a number to memory.tier) pins the limit.
>   - Tier max enforcement triggers reclaim scoped to the tier's nodes.
>   - Feature fully off (no mount option): no counters, no charge/uncharge,
>     memory.tier exists but reads empty.
> 
> Open questions
> --------------
> 
> - Should kmem/slab tier accounting be included in this series or deferred
>   to a follow-up?
> - Should per-tier memory.min and memory.low protection be part of this
>   series or left for later?
> 
> [1] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/
> 
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> Qiqi Liu (8):
>   mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
>   mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
>   mm/memcontrol: add per-tier page counter infrastructure and lifecycle
>   mm/memcontrol: add per-tier charge and uncharge
>   mm/memcontrol: add per-cpu stock for tier charge/uncharge
>   mm/memcontrol: add memory.tier control file
>   mm/memcontrol: auto-derive tier high/max from memory.high/max
>   cgroup: add memory_tiered_limits cgroup mount option
> 
>  include/linux/cgroup-defs.h  |   5 +
>  include/linux/memcontrol.h   |  26 ++
>  include/linux/memory-tiers.h |  12 +
>  include/linux/swap.h         |   6 +
>  kernel/cgroup/cgroup.c       |  21 +
>  mm/memcontrol.c              | 786 ++++++++++++++++++++++++++++++++++-
>  mm/memory-tiers.c            |  58 +++
>  mm/vmscan.c                  |  26 +-
>  8 files changed, 936 insertions(+), 4 deletions(-)
> 
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs

