Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D733FDEE49
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05B26B0088; Thu, 23 Apr 2026 16:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB65E6B008A; Thu, 23 Apr 2026 16:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4D66B008C; Thu, 23 Apr 2026 16:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8930F6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:34:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BEC41B8155
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:50 +0000 (UTC)
X-FDA: 84690974340.24.F9EC40B
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 528462000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZkriWEwI;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BXK3Al982u4BKXd+kiLvJEIaSgsC+HHG+R3gKRNBiS4=;
	b=n/H6YedtmqlgmBta+uAvKDdPBuBZ2a4ha9tkdj0u02Dllw+RhX/Y5w2ANO2+xYRPjWOp4C
	+ClT6/ZXFcHzDEBmPBSymrEpkYuleP7JJEn8+52QjPWuhtK/oKY0lgpP7MWbSzfY2Nkx9L
	Blam3WdUBx0g7hdnsiMQ3WJsITAOxU4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZkriWEwI;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976488; a=rsa-sha256;
	cv=none;
	b=0vzmV4ev6fn1hw3nM8z7FDVKp8xUm7Yu0SYSwZu4028BQ+c/X2Z+k0M5t9kLMQyx6JrIYW
	mLcLKWIngqTiqta3zL6JRFZBA0YEyWZCE2QNoSxUlRvM+oCzwPgk0EgkH4Z52kHLM8EjVj
	IS19Itew9yf/5WVcTfTMFWiHkk+bWXg=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7dcdd1b492eso3027521a34.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776976487; x=1777581287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BXK3Al982u4BKXd+kiLvJEIaSgsC+HHG+R3gKRNBiS4=;
        b=ZkriWEwIjq0Q3Z80Ue5VD0TSnGkRDndRPfi0c2GXJojM7FmC4WSOhtmnEm2xCcOw59
         aNc6QTj0/NTgmhwnYgOEyXt3m/dcDRcNdbm92yJKWbVRB36uZi4on90PrrDc9V/8OIk6
         d3di3/rm9bKO8DXjdCT9k5rVgiCfKOR/DHpwQWWwpnbFqLUVaqdn7RgJnLT1jv3Oj+dK
         9iRz4SbRoVkfUPmk3R8GEpjJQgDAZDcOGcfioibHuLeKvlJlh9u7e2qJ/nBGMS0/fhOe
         BmdrFPTMeTJnFC0ppEWdCnQLoJUGR1Jn5b1ambeGNDidwISKPJq/vSXHA5vt3hmHsmC1
         RwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776976487; x=1777581287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXK3Al982u4BKXd+kiLvJEIaSgsC+HHG+R3gKRNBiS4=;
        b=W3njdEuZKlxwmDnUZG/VSoeQE2TqPncnp2OSXMvwX6NkxZ8jggys08iGkC5q+E2vhG
         W/Gr0XgOZDuJL1ZxM1YJnpEFKN+7gckkLeEVRMWDJIbkoTylaKbgbH9TNMPU/c7wXUJL
         EqnCwVX/p3PrLHbMbRRRUcCuFE5gN/EVXwKQ0D6CRd4yzS9u7g7YVbdjEZVaIu2Q2FDi
         xxWXuPpmGGlb48XtBNXKYKSz3ZxoMUC+gTtF9bVornEh5SwwUmEVJuvJk2rdI3wioIJA
         FpiSeG+r3JgObtvcLpsGlStYFQ50tYdtU1KhHcPThBC+V/Z5ZhgjKqmzMCRjfuUbV48Z
         rF+g==
X-Gm-Message-State: AOJu0YwifCUGx4Zxvd5+LvI0adul7jieH8LBdTmmeb2M6VNPbFA+BYPs
	f/TLVvOimURXZN7XoBrYTjXyyHYIAoelZrt1P7MtFgop6bQv+tS85yxSFsTEYQ==
X-Gm-Gg: AeBDiet/Gi4eHA/AVNTrSZSWXFJt6u7hmF/m94Jj4WGv8DowyEmFUaLQPjiCKZzcKQJ
	rjeK+dspSkxGYxfYsEU7Tp3zbkQsQO7YzgEwPmYeWrdJNi0otegVPQyToxW76aclf1fALgUPbmp
	0zXIwO4gcd/7y0glPZAsD6kqOCGWpcdRi9hChNB8B34PYGMCVHJWoWpWBU3r5gr4n2BjYHjDMTf
	yEmW0vvL3GjU5dZ8Rt1g+2uJGtknLEPFVqmkI2Y1OWw8pddTP/qGykPVia7KPFSX0hYwi9iVBeM
	STZZEgO//oFIonS4CYLb/zSiIT1P2XH6MCpUTRdQIguHLwmlHA9Zmchi3eBLH+Zs431dvROxr6w
	lvZI6aZJnOb6+zLqheU0KSGk5PQUX2aoxfx44BkOJ4zLWDkTSb/p8BNoDipK4RExvDJ/f8HzxxY
	YEvQXaBwDvym5v20609wvXWJ9hwn8AMAFJ
X-Received: by 2002:a9d:4542:0:b0:7dc:9908:6cba with SMTP id 46e09a7af769-7dc990882f5mr10393540a34.6.1776976486682;
        Thu, 23 Apr 2026 13:34:46 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7de543a2d7asm911651a34.12.2026.04.23.13.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:34:46 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Michal Koutny" <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	David Rientjes <rientjes@google.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 0/9 v2] mm/memcontrol: Make memory cgroup limits tier-aware
Date: Thu, 23 Apr 2026 13:34:34 -0700
Message-ID: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: teebzyhxauntim4dw6y44wj9hooej3ej
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 528462000D
X-HE-Tag: 1776976488-193870
X-HE-Meta: U2FsdGVkX18dhCp22wKnaXh2wPt+UJzuu8AsKKUu2pFvwPC+drifGx/l1+E0oYQwH6QL8dN2HZ5SC7U9BfOZNn0dHst0l1mf0FAxi3WtEj+sa67vizjriP6T6BPinrpDMSBFOFrlkVa8iKWwHj9J7RrDX2iD/Zx5+bfa95+khMnWB4CpWp/9AKELJBazJBdtquHhAULx8fSiPvOCqnWH+7XtKeUU1NExNVM0nNLV0NBr6Dw5TVr0Sa9XI3tvQ5AmSusrPs1DrSw4wV/G0fA0QTefAovN/citm504NF7KoTezvaS52unJaebrP8ipgetzybuB2aOZ0p91Eu/el+RifU4KPuYp8ZjmVKuUN/iO/vpQU+z0aGxCkUYhoG8kmYV20jsYQuOiOmIYp4TDXy7vCHKc90ifh+Mp2zysf/OSdZVtfvn9wg7TK4MVMIEUICSV9AJdrEE5GoiKpZR//EGDej3YJ6+k/deUaujiMJI/21SKGB7f6Pi0BCLp8jQtqweCRY+85DmfJnG+RVCZ79dL1I/I67qYiZipnf+BcuSsXy7AUJqDaFuhvLRTuZZrFSQbfNuAKpJBrevjfFWbw2hSR8r4MWT1qy2l+G1Gm28IO0nB6IBKLOcV+DuxrhmNL2OFoxkA0SNv/FF+shNWwt/GsA0j4N80VX53iLNpG29VJQ4i7z+083Hx53M89G4qqL9Yc+aSgv7hDrJeMunfKXuYgEJufjrXQGr815I4eyetxA2g9KmQrLHDxNBNlijeZrRccfcGo3lomuz9VxvnCDb8EqqYrYGWXbT5aCi4mh8BtUHC4LZ3QS9ztVg9O3q08pWIBIsTJ4fuN0ejWcgZDqLRpPF7cIKmbLPmxwPVV+Wiocke6+OD08umQTB0u4KImeaIzeP4vLtmsX8bckCm0UrJ7MHy7ZsQeeRyqeBOFIx1t5Dwg6+0DtEY8Gj6UDigczuVF3zO49kihcodewnxo7T
 Srx8FSSo
 R6cX3UXtxtzdIx5p07H2MnH3+cNTCXGbhPZOz3rGfO5mEAq6PVCHq+c3i3E1InOARM8jYlvCOtLZhpu3r271XKy6kpkzIppyBrucDg/ugLE57Brhc34Bp5gxoHyD6ioAz5FXpghCuDdzlP7/q2Qtq7UNDs3k08UMu13ir8D+eRrZCM0/okFbsfo0rniU4F4QTnLcN7MtDGLilxf0RhflAtiGroiw7xmGux8G5xv+tW8VNkd5HXdRWZfvbkvbsM+d2b2BjkFApjgDBC1T/S3slPclLZ0RkGzTUDKA4ks1/AWa0nndTaLHP6lNDrJXjrMAupciCd9pZZpxDZ1RdDiV/0rHN0izcj/U7JgeoZ1JyidjY06zxupfWK8GxGUyl+gDgf+FgdSKCdwRNNz99PEUOmnqQaLV+FDd/wfkxAe8yYsaf7FZL+01xOvg0/jjYePJA9NVw4qPHrpIVFPhH+uHViLWjBnEVIWGFc9JIGp+ztTTmvqgUybYmdYjo6M7JLKTVchn73/JMcoqYVua1YB2hpInd0qHExJnIh9V7iRvNLpKr/jcJb5hFm5J390+48alPIS+98irFGKhtZ4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

INTRODUCTION
============
Memory cgroups provide an interface that allow multiple works on a host to
co-exist via weak and strong memory isolation guarantees. This works, because
for the most part, all memory has equal utility. Isolating a cgroup’s memory
footprint restricts how much it can hurt other workloads competing for memory,
or protects it from other cgroups looking for more memory.

However, on systems with tiered memory (e.g. CXL), memory utility is no longer
homogeneous; toptier and lowtier memory provide different performance
characteristics and have different scarcity, meaning memory footprint no longer
serves as an accurate representation of a cgroup’s consumption of the system’s
limited resources. As an extreme example, a cgroup with 10G of toptier
(e.g. DRAM) memory and a cgroup with 10G of lowtier (e.g. CXL) memory both
appear to be consuming the same amount of system resources from memcg’s
perspective, despite the performance asymmetry between the two workloads.

Therefore on tiered systems, memory isolation cannot currently happen, as
workloads that are well-behaved within their memcg limits may still hurt the
performance of other well-behaving workloads by hogging more than its
“fair share” of toptier memory.

Introduce tier-aware memcg limits, which establish independent toptier limits
that scale with the memory limits and the ratio of toptier:total memory
available on the system.

INTERFACE
=========
This series introduces only one adjustable knob to userspace; a new cgroup mount
option “memory_tiered_limits” which toggles whether the cgroup mount will scale
toptier limits. It also introduces 4 new read-only sysfs entries per-cgroup:
memory.toptier_{min, low, high, max}.

The new toptier memory limits are scaled according to the amount of toptier
memory and total memory available on the system as such:

memory.toptier_high = (toptier_mem / total_mem) * memory.high

For instance, on a host with 100GB memory, with 75G toptier and 25G CXL, the
“toptier ratio” would be 75 / 100 = 0.75. A cgroup with the following memcg
limits {min: 8G, low: 12G, high: 20G, max: 24G} might see toptier limits scaled
at {min: 6G, low: 9G, high: 15G, max: 18G}.

USE CASES
=========
There are workloads that benefit from tiered memory limits, and those that do
not. Explicitly, hosts containing multiple workloads with the goal of maximizing
host-level throughput may see a regression because fairness is not free; it comes
at the cost of underutilized toptier memory, overhead to manage memory
migrations, and host-level memory hotness inversion.

On the other hand, fairness can prove to be a valuable resource for a number of
configurations, especially with workloads that want to raise the lower bound on
performance, rather than optimize for raw throughput:
- VM hosting services that must provide the maximal performance guarantee 
  (i.e. supremum) for any workload present on a host.
- Database workloads that want to minimize the maximum latency (i.e. infimum)
  for queries hosted on the host.
- Hosts running memory-isolated sharded workloads that blocks progress until the
  last shard terminates.
- Any workload that wants to minimize variance, as a means to gather measurable
  gains in performance over time.

TESTING
=======
To demonstrate the fairness and minimum performance guarantee increases, I
performed some performance tests across three data access patterns. All tests
were done on a 1T host with 750G DRAM and 250G CXL, spawning 4 220G workloads
{memory.high == memory.max == 220G}. 3 of those workloads are “memory hogs”,
who get to run on the host and pre-allocate all of their memory. The last
workload is the “victim”, who only gets to run once the other 3 workloads have
already allocated their memory. Once the victim allocates its memory as well,
we begin measuring read times for the following setups:
1. random memory access in the 220G anon region
2. hot / cold memory access, where the hot region (100G) gets 90% of the reads,
and the cold region (120G) gets 10% of the reads

First, let’s look at what the results look like with NUMAB=2:

Per-cgroup throughput (Mops/s):
Cgroup     Baseline   Tier-Aware
------     --------   ----------
hog          21.457       17.733
hog          22.773       16.329
hog          22.630       16.549
victim       12.315       16.950

DRAM / CXL distribution (GB):
Cgroup          Baseline              Tier-Aware
------          --------              ----------
hog      220.0 DRAM / 0.0 CXL    181.6 DRAM / 38.4 CXL
hog      220.0 DRAM / 0.0 CXL    181.6 DRAM / 38.4 CXL
hog      220.0 DRAM / 0.0 CXL    181.6 DRAM / 38.4 CXL
victim   69.3 DRAM  / 150.7 CXL  186.7 DRAM / 33.3 CXL

Experiment 2 (hot / cold access)

Per-cgroup throughput (Mops/s):
Cgroup     Baseline   Tier-Aware
------     --------   ----------
wl0          24.280       17.815
wl1          23.929       15.019
wl2          23.645       15.605
wl3          11.624       15.998

DRAM / CXL distribution (GB):
Cgroup          Baseline               Tier-Aware
------          --------               ----------
wl0      220.0 DRAM / 0.0 CXL    181.6 DRAM / 38.4 CXL
wl1      220.0 DRAM / 0.0 CXL    181.6 DRAM / 38.4 CXL
wl2      220.0 DRAM / 0.0 CXL    181.6 DRAM / 38.4 CXL
wl3      70.4 DRAM  / 149.6 CXL  186.7 DRAM / 33.3 CXL

With NUMAB=0, the pattern remains the same, but overall, throughput seems
increased, and variance seems decreased.
I believe there is a negative interaction here between NUMA balancing’s
host-level hotness tracking, and the tier-aware memcg limit’s push to make
memcg-aware migration decisions (see open questions below).

The results above demonstrate the desired effect of fairly distributing CXL
usage across the workloads regardless of when they were launched, and minimizing
performance variance.

OPEN QUESTIONS (for mailing list & for LSFMMBPF)
================================================
1. Should memory.toptier_max be enforced? And if so, what should it look like?
   In my testing, I have found that enforcing memory.toptier_max in the same way
   as memory.max leads to significant throttling, as each allocation above the
   toptier limit causes a loop of allocate on toptier --> scan toptier LRU for
   victim --> demote victim page --> allocate on toptier...
   Thus, in my test above, I ran with the last patch (memory.toptier_max
   enforcement) disabled. Are there use-cases for enforcing memory.toptier_max?
   For this RFC, I’ve included it for review, but I feel that it makes sense to
   drop toptier enforcement.
2. This version of the code does its best to generalize the memcg stock system
   as much as possible, but still only makes a distinction between toptier /
   lowtier. Does it make sense to support 3+ tiers? Are there currently real
   systems / hardware out there that desires to enforce fairness at that scale?
2-1. Should swap be considered its own tier?
3. Should users be able to tune anything? Currently, the only choice is for
   users to enable the limits or not. Options for userspace tuning include:
   setting cgroup-wide toptier limits; system-wide toptier:lowtier ratios;
   cgroup-level toptier:lowtier ratios.
4. Tiered memcg limits interfere with existing promotion mechanisms like NUMA
   balancing (NUMAB2), that promote memory on a systemwide basis, ignoring
   process and memcg contexts. What kinds of promotion mechanisms should be used
   to work in memcg-aware contexts?

DEPENDENCIES
============
This work is built upon my recent RFC [1] to move stocks from the memcg level to
the page_counter level, to make the toptier charging path cheaper. In addition,
this patch is limited to working on LRU folios; kmem memory and memory that is
otherwise not charged on an lruvec-basis (i.e. has both physical node & memcg
information; aka enum memcg_stat_item) is not accounted for. There are landed &
ongoing efforts to introduce per-lruvec accounting for these as well:
- vmalloc (from Johannes): mm-stable [2]
- zswap / zswapped / zswap_incompressible [3]
- percpu: in progress [4]

CHANGELOG V1 --> V2
===================
- The toptier:total ratio calculation has been simplified to ignore cpusets and
  now exist as a system-wide ratio. This came from the realization that having
  cgroups that opt-in and opt-out of CXL co-existing on the system leads to a
  question on how the limits should be enforced, and whether such a configuration
  is even desirable.
- The simplification above means struct page_counter can be per-memcg, not
  mem_cgroup_per_node.
- Independent memcg stock management for toptier
- Included min / max enforcement (for max, see questions above)
- Exported toptier limits as read-only sysfs files
- Turned the build config into a mount option, as suggested by Michal Hocko

Thank you for reading this long cover letter. Have a great day everyone!

[1] https://lore.kernel.org/all/20260410210742.550489-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/all/20260220191035.3703800-1-hannes@cmpxchg.org/
[3] https://lore.kernel.org/all/20260226192936.3190275-1-joshua.hahnjy@gmail.com/
[4] https://lore.kernel.org/all/20260404033844.1892595-1-joshua.hahnjy@gmail.com/


Joshua Hahn (9):
  cgroup: Introduce memory_tiered_limits cgroup mount option
  mm/memory-tiers: Introduce toptier utility functions
  mm/memcontrol: Refactor page_counter charging in try_charge_memcg
  mm/memcontrol: charge/uncharge toptier memory to mem_cgroup
  mm/memcontrol: Set toptier limits proportional to memory limits
  mm/vmscan, memcontrol: Add nodemask to try_to_free_mem_cgroup_pages
  mm/memcontrol: Make memory.low and memory.min tier-aware
  mm/memcontrol: Make memory.high tier-aware
  mm/memcontrol: Make memory.max tier-aware

 include/linux/cgroup-defs.h  |   5 +
 include/linux/memcontrol.h   |  35 ++++
 include/linux/memory-tiers.h |  17 ++
 include/linux/swap.h         |   3 +-
 kernel/cgroup/cgroup.c       |  12 ++
 mm/memcontrol-v1.c           |   6 +-
 mm/memcontrol.c              | 306 +++++++++++++++++++++++++++++++++++++----
 mm/memory-tiers.c            |  46 +++++-
 mm/vmscan.c                  |  11 +-
 9 files changed, 402 insertions(+), 39 deletions(-)

-- 
2.52.0


