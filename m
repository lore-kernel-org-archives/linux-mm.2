Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9251D374B7
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010626B0320; Fri,  5 Dec 2025 18:32:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29DE6B0321; Fri,  5 Dec 2025 18:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E669A6B0322; Fri,  5 Dec 2025 18:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1CC06B0320
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:32:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EF7D896EC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:32:21 +0000 (UTC)
X-FDA: 84187018482.10.2AFA15C
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id C78611A0005
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:32:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fZA/Ano6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764977539; a=rsa-sha256;
	cv=none;
	b=phPV+auuxpS81YY/smXmjf4m00BrsgJ6LQD1er2IrSLCSR6BaBkmGaen4emhYCK6b6VE2Z
	DijaLM0NY70tgRV/oequ6UOnSyF+0ixHz8FGxnLxrl0QcSlmu1Mj6oHbBA1pgo2mQaUD2f
	Knswi2i0hIhD0t6I1IuyusiL08P2m90=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fZA/Ano6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764977539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DjASHCs44SnDjJeYh3qYw2ycI6GE9TKZGAruEoGfPyQ=;
	b=tf6hQJZxbhaGGHFjOgZ1ZAIrlDkI6uLm/AeBKHGLzdbqWIyStQa7HMwjPTwllhETAdKXQI
	lqtyxof9mCQPWKC+uh56TBgwl9x66f16iRbgTgGc87e+ZwfcMU/GUJcZ29LCrk4ORxKHzi
	1l/5n/X+I+vEauUFxF8fbZ38GYS5/Rg=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-78c2e5745bdso8073717b3.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 15:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764977539; x=1765582339; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DjASHCs44SnDjJeYh3qYw2ycI6GE9TKZGAruEoGfPyQ=;
        b=fZA/Ano6ZE+c242nhda1OoZHMIvbM73ndypYmSbreismpT7vgyxcO30B9yWB4+zffW
         xR3mxROMQkbRPs3QJnuCi+HsZV+ps+esk5WgS/H0C3oH4UzEkgis+XAQZfXSVureu9jo
         emOG7APPqqfU/nqzc+UInCk9Qymxkrt9a2o+scRzic9MY1Q1XM430P2J/B0qAvcdBzCJ
         eag/zZawl76/yt+paqwHGDVHpX8jlC6V15bXvfcg7w4GIROtI4Hw+2ETP72wfc4IQpPY
         7c67nwmwMDRKJZJ0nvqQLSkh6UWFjlx2inshadxLQJjSGLbcSeK3KK6C8PhiCnemaEdM
         GWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764977539; x=1765582339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjASHCs44SnDjJeYh3qYw2ycI6GE9TKZGAruEoGfPyQ=;
        b=deIfXMS9xt0ZxWeuE7gBXTAMNIZnxj0LoYC468nqfuFVWUcwkTbsuWpIfICsDzMSYS
         nH1RFoqcB29Nwpf+TThkhQOVYnCjY05zB28a8DymzxqxLW1P36cy8+QJyPb/FgFZPemB
         mWtS7u0PJ8ZvEHVyn/F8LyNs3XspahVtmUnlM2aWfazivDMrhkJWy9Kn/atITjQ4ijWe
         WNSGD8r7AfT0XDBCgGc0Tsp4JUY+0dhQzeLqnpxXcexe6a9aLH1nFpBNyXMvjCENpuql
         nEeDKuis0IPbmDKuzMrHIf4XAZSZPxyI+JUMCBMJoU09QENmtIUfbZAGNCkgN+myrBl+
         aAYA==
X-Forwarded-Encrypted: i=1; AJvYcCUFneWItX15n5jkK6Ys/idN7+Z5TCKt4W4XGTtvCL5VQXK8dv2Vc0aoQFPAwJ4kgz51Bf9QNZpWEw==@kvack.org
X-Gm-Message-State: AOJu0Yx24dWEyoB0WauAz+9qKTNIuvTAdcsI8NS8DfB/FITu/yg/At11
	p2a6EO0ETYIIv4/PyVquzslCzGy1BBc8wt0WqfLfFTLDtX7p1vmJ7ZEl
X-Gm-Gg: ASbGnct3ehYooG4vNoE5yA+DHHLnz+0GYtUL68HsuBMbYZ1lcFqAcNJjr6rlR68oeXW
	KiXmM4wUgXUBoIAM5zeZZU+bebSXdyWycAF30DoiDv7B/P94sX4EtTUJegiBLVOrWhhWZZpaCei
	T+OSODjxscuvjlCBgeRBlfuA+YNdEUnX4zmw3sX2UydrX0mBj7B/WmHsyArqMfVVcPZm9qV0BMo
	f5ops6wpjtxs7fYaQA5SDZYLkmsmiXUwCTTO2RConfrzcHOYkdTvbrfnt1vijzKTe/f7TBpJt/u
	twOC+BNUeo03qgEVgaXvcVgnpjFGqwr1usDzkObzyXD7tzo/cnnpnX2VcIynuz6bx1USR723oRX
	2wRwCS8plmoeQJmuW4M2HqXONTBuc/PbqYsx4fUqySf6dQioyEwZB81qZ6T/so++XTC5jq6ftsF
	4jkOickdd1ZMIR42xyN9h0AA==
X-Google-Smtp-Source: AGHT+IHM12t6gDjzVKLcRmx1gB6wbrzIhaFWpatYaAHdWKPgKCT1195aVWoslNVYKST9kzwC9iOyBA==
X-Received: by 2002:a05:690c:7002:b0:786:4f8a:39b5 with SMTP id 00721157ae682-78c33c9797amr14147897b3.59.1764977538563;
        Fri, 05 Dec 2025 15:32:18 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78c1b4d66fesm22045327b3.23.2025.12.05.15.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 15:32:18 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: willy@infradead.org,
	david@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kernel-team@meta.com
Subject: [RFC LPC2025 PATCH 0/4] Deprecate zone_reclaim_mode
Date: Fri,  5 Dec 2025 15:32:11 -0800
Message-ID: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4oaj4q5m8txwpsgj6nx1sh8k85nmidag
X-Rspam-User: 
X-Rspamd-Queue-Id: C78611A0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1764977539-625819
X-HE-Meta: U2FsdGVkX1+APw7rQCqBC0iDzP/7iu53FdQ4Lo0N8bIpOpCyayA0kNqhofM6f8blr5GMm/iAx7iuaoNXyP0kZbdfA8YoWxtqr/6j+cX8UrucGJb5oQo5Y8FxmMBdLmxTMhmUE3nWXcJcfk2oM/QqPjAhb95TMtp/rUjyErmjoC7UnTmJm+4b4ST9x0XlmTntJs1DPhNxz/+txbYtM367OqtGdaXNLigvboH5y58QtcmkTRtfRa52/kcBUs2SZy6+t82D82bbSq9A2TKTE8sNuSuM4e6PjE224ke72VhRwh5c2JVr3lxwDjg8LWZJJJGE6leN8/XF8o2SPB5CH5BeuA8S3Om4U32oHY5+ObwRh7ktvaWbXtpBWEg8dZiSCvIMcJnUwnCOf2zM3Vrk9nPBMfWMYeHL50BUOW4vxupn98Is1XtOOg0o9y23KsT1C/X8dq7tNoA74cWkO7JnO+Z/EN3Kpc6VWJuM++QfMuBMtQP0RVxvWmTt7yWmq/6C6ZqV9hL6ZNL5m5EvLw6Y9PwS1Rv/tFXuceEtc/3zzrM6T6nYiEntnWOVUtQPKjLmVkXisHBEkRdXrtljcc61yd+Oub14ChbVJEp5318ssKczil+6L6CvUy+AELPKvIKqYG6GZSVhPzrkKILT0smsCjnskzPXWBZ6coHSJYTsQCDRvIUaNFM9mFDPxTSEZv7VRwpn0TYs+C+wSwDxkaw+2zuDr0CrWGH3b6K7EagTXiRKkovp2RAlHNojISsMj3WWO61j7tuhH4w8GtlcCVbYh5W7Wq2cXYEdzJdWrMz81nrW5t06+1H86emanjmHToczqECHqETu9WBGdqGElDSjOhqDYaR/+K+KGXCJN2ko7dHPsjay9KZAkzmOEZ1o0OKGrnxdsViq+RAhUxycVgCZk/hO5S0ZR19xmlWv3Ewd2/ropq9ptUIHO+2Dn4Z+d0icqqkoGWZoGhBgmNvbjFqJk1J
 wJee9xNb
 RmI5TDEheUQPpuNQttTslI7hhiLqhco57EraqztUUyNqZpAxLSFNgX4wC+4GIgIGPbaz2x6XxKbywujraVDxj3jPTEWny1m/4L/rIvPK78wK1syijXSoXM44aETDY8lC7l+yfBdYzPVtbkDoQ1oxlMpvojU6XvO8+zoTpssqMyoEqXVV9u5dh+Ksbb8C1K+0lRB6POBPqlo7V7qJzqHzfK+KoTnXypKL57tL68lYZCto0NgrSGkHwrMXrPvTalOMMm+h51MbTJbQyJzfij0d02CeZVWcaL/Yisz0AZms2QcTpN6Ta47vW94fsfzW7MS9t8mOfTyrWOev0Nb9iGlHGTE0sWz3pLxs6qtNt/Lw5c5dRFmsH22HDMZ8aPf+BM3Mb88jAq82DBcljxWcCp0+zsVBB0L/KZV28bAvJMb52I+ZuwFE3/93e7aSCccQpYtYSmLYD2O9U222X8O8njKUikoiswaPayiWJke5vDBalqKPR+BtB6/xsulyg/P5uVJJfjuEwiHqBJWHl0gjW1u3MDHr4BXEShqcc+xNPiYr9qczAzv6Uk6rTZ4MEycLw5VEKktH+jl6i+NHI3/YAyWwbdhCZRtMZXTaEqNeM/fVN+GeV4sNpIV2iB2/lLik3MvcjJXoK1FpeYN3yiU+eASoro8EghNmKLmDtDsx5DFxXfVldEHM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello folks, 
This is a code RFC for my upcoming discussion at LPC 2025 in Tokyo [1].

<preface>
You might notice that the RFC that I'm sending out is different from the
proposed abstract. Initially when I submitted my proposal, I was interested
in addressing how fallback allocations work under pressure for
NUMA-restricted allocations. Soon after, Johannes proposed a patch [2] which
addressed the problem I was investigating, so I wanted to explore a different
direction in the same area of fallback allocations.

At the same time, I was also thinking about zone_reclaim_mode [3]. I thought
that LPC would be a good opportunity to discuss deprecating zone_reclaim_mode,
so I hope to discuss this topic at LPC during my presentation slot.

Sorry for the patch submission so close to the conference as well. I thought
it would still be better to send this RFC out late, instead of just presenting
the topic at the conference without giving folks some time to think about it.
</preface>

zone_reclaim_mode was introduced in 2005 to prevent the kernel from facing
the high remote access latency associated with NUMA systems. With it enabled,
when the kernel sees that the local node is full, it will stall allocations and
trigger direct reclaim locally, instead of making a remote allocation, even
when there may still be free memory. Thsi is the preferred way to consume memory
if remote memory access is more expensive than performing direct reclaim.
The choice is made on a system-wide basis, but can be toggled at runtime.

This series deprecates the zone_reclaim_mode sysctl in favor of other NUMA
aware mechanisms, such as NUMA balancing, memory.reclaim, membind, and
tiering / promotion / demotion. Let's break down what differences there are
in these mechanisms, based on workload characteristics.

Scenario 1) Workload fits in a single NUMA node
In this case, if the rest of the NUMA node is unused, the zone_reclaim_mode
does nothing. On the other hand, if there are several workloads competing
for memory in the same NUMA node, with sum(workload_mem) > mem_capacity(node),
then zone_reclaim_mode is actively harmful. Direct reclaim is aggressively
triggered whenever one workload makes an allocation that goes over the limit,
and there is no fairness mechanism to prevent one workload from completely
blocking the other workload from making progress.

Scenario 2) Workload does not fit in a single NUMA node
Again, in this case, zone_reclaim_mode is actively harmful. Direct reclaim
will constantly be triggered whenever memory goes above the limit, leading
to memory thrashing. Moreover, even if the user really wants avoid remote
allocations, membind is a better alternative in this case; zone_reclaim_mode
forces the user to make the decision for all workloads on the system, whereas
membind gives per-process granularity.

Scenario 3) Workload size is approximately the same as the NUMA capacity
This is probably the case for most workloads. When it is uncertain whether
memory consumption will exceed the capacity, it doesn't really make a lot
of sense to make a system-wide bet on whether direct reclaim is better or
worse than remote allocations. In other words, it might make more sense to
allow memory to spill over to remote nodes, and let the kernel handle the
NUMA balancing depending on how cold or hot the newly allocated memory is.

These examples might make it seem like zone_reclaim_mode is harmful for
all scenarios. But that is not the case:

Scenario 4) Newly allocated memory is going to be hot
This is probably the scenario that makes zone_reclaim_mode shine the most.
If the newly allocated memory is going to be hot, then it makes much more
sense to try and reclaim locally, which would kick out cold(er) memory and
prevent eating any remote memory access latency frequently.

Scenario 5) Tiered NUMA system makes remote access latency higher
In some tiered memory scenarios, remote access latency can be higher for
lower memory tiers. In these scenarios, the cost of direct reclaim may be
cheaper, relative to placing hot memory on a remote node with high access
latency.

Now, let me try and present a case for deprecating zone_reclaim_mode, despite
these two scenarios where it performs as intended.
In scenario 4, the catch is that the system is not an oracle that can predict
that newly allocated memory is going to be hot. In fact, a lot of the kernel
assumes that newly allocated memory is cold, and it has to "prove" that it
is hot through accesses. In a perfect world, the kernel would be able to
selectively trigger direct reclaim or allocate remotely, based on whehter the
current allocation will be cold or hot in the future.

But without these insights, it is difficult to make a system-wide bet and
always trigger direct reclaim locally, when we might be reclaiming or
evicting relatively hotter memory from the local node in order to make room.

In scenario 5, remote access latency is higher, which means the cost of
placing hot memory in remote nodes is higher. But today, we have many
strategies that can help us overcome the higher cost of placing hot memory in
remote nodes. If the system has tiered memory with different memory
access characteristics per-node, then the user is probably already enabling
promotion and demotion mechanisms that can quickly correct the placement of
hot pages in lower tiers. In these systems, it might make more sense to allow
the kernel to naturally consume all of the memory it can (whether it is local
or on a lower tier remote node), then allow the kernel to then take corrective
action based on what it finds as hot or cold memory.

Of course, demonstrating that there are alternatives is not enough to warrant
a deprecation. I think that the real benefit of this patch comes in reduced
sysctl maintenance and what I think is much easier code to read.

This series which has 466 deletions and 9 insertions:
- Deprecates the zone_reclaim_mode sysctl (patch 4)
- Deprecates the min_slab_ratio sysctl (patch 3)
- Deprecates the min_unmapped_ratio sysctl (patch 3)
- Removes the node_reclaim() function and simplifies the get_page_from_freelist
  watermark checks (which is already a very large function) (patch 2)
- Simplifies hpage_collapse_scan_{pmd, file} (patch 1).
- There are also more opportunities for future cleanup, like removing
  __node_reclaim and converting its last caller to use try_to_free_pages
  (suggested by Johannes Weiner)

Here are some discussion points that I hope to discuss at LPC:
- For workloads that are assumed to fit in a NUMA node, is membind really
  enough to achieve the same effect?
- Is NUMA balancing good enough to correct action when memory spills over to
  remote nodes, and end up being accessed frequently?
- How widely is zone_reclaim_mode currently being used?
- Are there usecases for zone_reclaim_mode that cannot be replaced by any
  of the mentioned alternatives?
- Now that node_reclaim() is deprecated in patch 2, patch 3 deprecates
  min_slab_ratio and min_unmapped_ratio. Does this change make sense?
  IOW, should proactive reclaim via memory.reclaim still care about
  these thresholds before making a decision to reclaim?
- If we agree that there are better alternatives to zone_reclaim_mode, how
  should we make the transition to deprecate it, along with the other
  sysctls that are deprecated in this series (min_{slab, unmapped}_ratio)?

Please also note that I've excluded all individual email addresses for the
Cc list. It was ~30 addresses, as I just wanted to avoid spamming
maintainers and reviewers, so I've just left the mailing list targets.
The individuals are Cc-ed in the relevant patches, though.

Thank you everyone. I'm looking forward to discussing this idea with you all!
Joshua

[1] https://lpc.events/event/19/contributions/2142/
[2] https://lore.kernel.org/linux-mm/20250919162134.1098208-1-hannes@cmpxchg.org/
[3] https://lore.kernel.org/all/20250805205048.1518453-1-joshua.hahnjy@gmail.com/

Joshua Hahn (4):
  mm/khugepaged: Remove hpage_collapse_scan_abort
  mm/vmscan/page_alloc: Remove node_reclaim
  mm/vmscan/page_alloc: Deprecate min_{slab, unmapped}_ratio
  mm/vmscan: Deprecate zone_reclaim_mode

 Documentation/admin-guide/sysctl/vm.rst       |  78 ---------
 Documentation/mm/physical_memory.rst          |   9 -
 .../translations/zh_CN/mm/physical_memory.rst |   8 -
 arch/powerpc/include/asm/topology.h           |   4 -
 include/linux/mmzone.h                        |   8 -
 include/linux/swap.h                          |   5 -
 include/linux/topology.h                      |   6 -
 include/linux/vm_event_item.h                 |   4 -
 include/trace/events/huge_memory.h            |   1 -
 include/uapi/linux/mempolicy.h                |  14 --
 mm/internal.h                                 |  22 ---
 mm/khugepaged.c                               |  34 ----
 mm/page_alloc.c                               | 120 +------------
 mm/vmscan.c                                   | 158 +-----------------
 mm/vmstat.c                                   |   4 -
 15 files changed, 9 insertions(+), 466 deletions(-)


base-commit: e4c4d9892021888be6d874ec1be307e80382f431
-- 
2.47.3

