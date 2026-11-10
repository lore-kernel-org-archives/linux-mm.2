Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87DB3606AA7A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=DH47ekOS
Received: by kanga.kvack.org (Postfix)
	id 9FE2B6B05B6; Tue, 10 Nov 2026 10:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6026B05BD; Tue, 10 Nov 2026 10:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC6C6B05BF; Tue, 10 Nov 2026 10:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 600D66B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:04:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D510E80800
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:04:53 +0000 (UTC)
X-FDA: 85419531666.09.B4549D3
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id E85851C0017
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:04:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DH47ekOS;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323092;
	b=DnThtDKRD4J+s4kXI0BRu4+3fQiAFUOCFF03A0/DJgkOjhSHmIv3O1oYHqSFffwvI8wTwv
	Rw/UJP6Cwxm0Y3FjTorujJUhy1jZlPxdaIDHiYCJz9Vs2oCOF0y2kaRESaNN6/62R88pT+
	EdMD5R7gYUUNiJrJTsKcGAIRuo+Nbx8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DH47ekOS;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9E7t2sZ9QvxPpSwYYvXGubn6m2BnFXDvGY+T7ZYguXY=;
	b=wt3Fly8MEttN0jzTze8JJTZYh5MXkh/UbeGCXaOiJM0hkq8BqMjPpKhGfckPxV43uv0Vnl
	wG1sGkMIpQeGouXVGGd13p1G9hejtyQw73WSYA+6DXur0txuv0feYlJASYq7whUdCEm1Pd
	HcdfjBLaMhH+A1sPP60gAcCtv+8GLcE=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91c6ce60697so26374756d6.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794323091; x=1794927891; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9E7t2sZ9QvxPpSwYYvXGubn6m2BnFXDvGY+T7ZYguXY=;
        b=DH47ekOSjDFgjHny+0OSwL6HVCl0Wpg+8g5ugEW8ITGJlyTjUD0DHqq+28nEq3Wq30
         FAzYUq3NR1qCS5LfxOJBkYZidCWD2WhhhpXfr8OdfVrp8B465BwZkz3YqfljIGt/qbwD
         /id42/EjVt0rImLVTTfTG1SJWoFi4X2n071VzHkjkMd0zOJAhu0mL0IXbOAyH/EwudIS
         eiA2jPCYedgMB2r93K9SfQ/iTraW1eHOWpSS6hM4za5xo4LdPGci0lBOMFyVN6qVVSoR
         fsfAX8/Yx3LwDHKR6kS8F8+me0YzfEf4IUWOYofEo/3Fu68mXW79SEITWmx/I3sPpcMU
         DEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323091; x=1794927891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9E7t2sZ9QvxPpSwYYvXGubn6m2BnFXDvGY+T7ZYguXY=;
        b=0H55v5jDqkHOOy5kyeh/TEGw7Yp9Vm2ITAmyd+XNVXSM7/gdwnYg1prUl5Jvi72qBn
         hMDgyb070hBBF/FAsiJ6UHuNLfEjnJGEgk2mleNxbUz5NuANZbUWbTWRojYAnzsP1y51
         HXs7s+cknoYEgNxx3b8ZRmJ9a0ebAKHvdxYEwNQTmAaIhh71F79gsIaOmHQuu5QjISKA
         6ZqWWjXsx1ZGx1238sK3o7mg9G1vQ0AWq2KAMO+cGAa4fBURk16X4Wjvsv1oAC8UzDdZ
         fm5c0k86trV8UXe5iy2ls4m+632PELxvlQCbtK+tjxaXtS7ldCsW+i3sMvaRwMGRSWh7
         iNwA==
X-Gm-Message-State: APuU4Z9dz6m9qlWcSNJQ7vKmBCE3ETw0v4cF+eEmsFVIlbhyMeAQ4WzZ
	SCttNHphR9PMhFird25+IUPF46SFlVAcKn5cGnlUO5SIYAF82y9vZzKy/qpTCtvLbeMVHnNZRaa
	fcqvm
X-Gm-Gg: AYBFou20Iof/UAgBz1Gtzg8jeJne4K4jiBe66/amTIKLIaiUfQBSu6t5FROZfvzGC+x
	1W1cQmFOVK2Af94dfD0J+CptXzd/yx7TZdDO5D3Gr5Vct8eXVawmroru4d/iSvnXk7M2A0WGghA
	SlctRgKSe/L2h5E64beU7aFpiPDFFFnZbaLQMtX62LmfxY/GfmgM2bfmfVJWr7d0kL2i+uodufq
	Xn4HhqruVygoqyPesV8lq92aO4+p9Aw71VKWDnvQiln9Rm62jS/vcfWGLsFU0RH6g/lA7F02r4a
	Uvf3Dqj/Uhhi+YqGMd0jbir45E9GS3DZtGGL9S+9u1Eo2++RqhiMx0MdwPwL8EHwuDDEF5jbc8X
	Pe+pTmPGJT3rPeWC/u5Na30rkFpBKefZaBB/yK5FCN3b/d6b3GF5cct0mNl5Mpf0yIQgg7cOcqD
	47Qe9/J9IJqlR9h1bpDBiRlSJp3Im0RLxAkv9bijF6pSm8IDB3VRHkn6O7VXhVjqiAwC2Hahs87
	WoqRTQXtkWDDEl+P/dRny+WgOiUbT5lSM4bllPsJQgzwqQpLhmA3D1rgiUrW8JbCJyr3eFYaAfr
	zKNZryGpcLAfzZiWiLVGMYcQqoLCAR4wt3mw4uFhzcKTLW3+vx2tnydFEikBmNn5PPdD9CG1PRQ
	z5lwxAWGGqwbpHuo=
X-Received: by 2002:a05:6214:4015:b0:91e:f4ab:4aed with SMTP id 6a1803df08f44-91ef4ab4dadmr24082126d6.48.1794323090635;
        Tue, 10 Nov 2026 07:04:50 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031c7dasm22902406d6.1.2026.11.10.07.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:04:49 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@techsingularity.net,
	mingo@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	osalvador@suse.de,
	raghavendra.kt@amd.com
Subject: [PATCH v5 0/7] sched/numa: stop VMA scan filters from gating promotion
Date: Tue, 10 Nov 2026 10:04:39 -0500
Message-ID: <20261110150446.2452975-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u3orhiob65yjrybdukbt9weo9schwkbc
X-Rspamd-Queue-Id: E85851C0017
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794323091-817562
X-HE-Meta: U2FsdGVkX1/UZmkConQbj3g7Ce8DBIzw/uRroYthgucZGW+hUsO1KTv0OakO3ymImFpajQ7JkxnJybPnVFa37qQigOtVr3EHKEkmcitBLzS1DmhM4agtunaEgWMclWGVq2/bHMD0ud3yJlMasTDWg6OCCT7IoqDk4GEVs8LauRT6bqr/mcyDbIPX42OMD00XiOKFkpniblmmpi7F6LzhkbptWDAREfKzo+3w3kf49iisugvkZS1HHvxFOg8fZ10yE/L6E0GlS1Ms9BXiZT+9M0d0v2AuNLLnvmJdBTGpLPEbd/tsmzTv3VYIIdNGVdZuaJujIbepjPjk6PX96X6b6T6wOUp8Fx1VV6Xlt5RBaTD6rE9/H7ocWK5cqSd9JOyZYBnXAhwN3XNgnYoIpFQHcbpNeYixcSh6MYkipvzYzuyKqq+XIBIeF5QWX5m2CfwCQNAZN5+yXHiIDPyOr7rg6whm3BT6hT5dW2j7uGsgoV+c/1bbhztJRly7D87iySgDkC4FtTMpoOJf0M0RECYrEblg//TcZCpiUHYs2+qzlTQJvhTiQNW8e5zA7saRdLKumfe72lf+lQlTIYwYf3+IcUYms0h/qBivxGeFLlWQeDkGwdZ/YmtQIx4H5Vc4HMzCmkeh72FSj8sH/DVP0viaKnPn5m7I5UZfCFqcYkzAac8CFul/XiForJ7otlsYRZld5O3NFsgWxRl/ziehKwqByuvyGftvsFcDKD9S0ZgiGtm9Qbew5qT2M52GF3KLHxK2Y2MGc9HzVnYGdLH2cL3vP88CkvOXWUGsf1lIRq0/L34Wl4Xhm59aK8wG7LEgUEdRUSWENDDwvjeuwZ9rc+aNUM/fvVghHcp2HmVtwxy3EhhaIleLzFWiSHD5yjFzqylDfQ4IBB9dFvwuErC7j9bulFnDgaeiO6lFuQ1Hi6wqBPCioGlmSjx3w6+YBotRgxzWu0qW2UfkuGGVMiCxZO0
 04bf+m+E
 zaVi6dewORRr861uFdn47IAYSuL2ICm9iTd6YA9a1QreIvfD3v/i8FcrDb/xAhKoy3O8TthZvXl2Uqc7o2kWU/KCNPlPc+owM5OJe8zVSU+bRbmmOZ0TqbcA8H1aGmBDAyspmFbs/UyDVSSs4CG5mhioPZH7RsH7nYsG734G4n2vlkEpGlhgUXvMvM7MFhK4Huw/45KSDO+RXsqeClqm0KSkJWWeGOLaWU3EsKOC1dEa/ht2H8IH95RbmC2G+jOR/n0naJeMhjS91vMjvKchkY3mvsdCJxu7B8Tt9fP7jVfYlw2XJ8PuWmtU3+Ht7w+qG9ExvQRh86f2sFip8umndfjRWCZDEfmZi4ObYhRpQuhS1qpO9w6akG/rmy4t5W8e5IrnVuNM7vvCX+stmsrdrBKcKwgUmA1y82Bf0EgGww71fu2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NUMA balancing uses hinting faults for both task placement and
memory-tier promotion. Several filters designed to avoid unproductive
socket-placement faults also prevent promotion.

When testing testing fairness controls [1] we observed unexpected
bandwidth utilization between tiers. We found that numa balancing
was completely broken - starting with a recent shmem fix [2].

No other numa controls are used on these workloads.
  - no numactl / mbind / mempolicy
  - no cpuset.mems

These fixes impact the fault-injecting side (spraying PROT_NONE),
not the fault-handling side. So mempolicy and cpuset doesn't really
come into the picture.

The core issue is that the global balancing mode says which mechanisms
are enabled, but it does not describe the intent of an individual
VMA/PTE walk (placement vs promotion).

This series plumbs the scan reasoning into the prot_none injection
while retaining the placement-scan filtering.

Testing
===
We tested on an AMD Zen5 platform with 768GB of DRAM and 256GB of CXL.

We use kernel.numa_balancing=2 in production, but there are subtle
interactions with numa_balancing=3 that are also handled by this set.

Workload: two ~430 GB databases with large (separate) shmem VMAs.

Before patch series:
  - 150-200 GB/s DRAM bandwidth
  - 40-45 GB/s CXL bandwidth, saturating the device
  - request latency above 5 ms with longer tails
  - Large portions of hot memory permanently stuck on CXL tier.

After patch series:
  - 250+ GB/s sustained DRAM bandwidth
  - approximately 5-10 GB/s sustained CXL bandwidth
  - request latency between 800 us and 2 ms
  - Hot memory now gets correctly migrated to the local node.

Stable Backporting
===
Patches 1-5 form the backportable fix set:

  1. Add promotion-only NUMA protection walks and derive private VMA
     state in the folio eligibility check.
  2. Permit eligible shared folios to be promoted to a fast tier and
     rename the promotion predicate to folio_numab_promotable().
  3. Scan mappings covered by the legacy file placement filter using
     promotion-only scans.
  4. Separate VMA placement eligibility from partial-scan continuation.
  5. Scan PID-inactive VMAs for promotion and account for placement scans
     separately.

Patches 4 and 5 are technically part of the same fix, but are separated
to make it easier to review - they must be backported together.

Patches 6-7 are independently requested cleanups.

  6. Use BIT() for the change_protection() flags.
  7. Use the VMA flag API in the touched NUMA-balancing code.

Changes in v5:
 - Patch 4: small formatting change (David)
 - Patch 4: changelog comment for sashiko east-west false positive issue

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/all/20260629163337.1264881-1-hannes@cmpxchg.org/

Gregory Price (Meta) (7):
  mm: support promotion-only NUMA hinting scans
  mm: allow shared folios to be promoted to a fast tier
  sched/numa: scan read-only file mappings in tiering mode
  sched/numa: separate VMA placement from scan continuation
  sched/numa: scan PID-inactive VMAs for promotion
  mm: use BIT() for change_protection() flags
  mm: use VMA flag helpers in NUMA balancing

 include/linux/mm.h       |  23 +++++----
 include/linux/mm_types.h |  13 +++++
 kernel/sched/fair.c      | 100 ++++++++++++++++++++++++++++-----------
 mm/huge_memory.c         |   3 +-
 mm/internal.h            |   6 +--
 mm/memory-tiers.c        |   9 ++--
 mm/memory.c              |   2 +-
 mm/mempolicy.c           |  37 ++++++++-------
 mm/migrate.c             |  13 +++--
 mm/mprotect.c            |   7 +--
 10 files changed, 140 insertions(+), 73 deletions(-)

-- 
2.53.0-Meta


