Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51355CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 22:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326556B0005; Sat, 16 May 2026 18:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF9C6B0088; Sat, 16 May 2026 18:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177EC6B008C; Sat, 16 May 2026 18:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F22A66B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:34:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94DB21A042B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:46 +0000 (UTC)
X-FDA: 84774738972.17.D41602B
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	by imf10.hostedemail.com (Postfix) with ESMTP id D389DC0004
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X0sUF4I4;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778970884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xoDTElId9snFmrZZxli5uToWxxMW032UXdLJQhd0rGU=;
	b=N4jWg6pcH8v5ZVVd6lIKYVx17FdqWuGGy3y6s9L1UdCIqYB4UmgK/knNrbNoJj53GSYS7K
	uOo+pqP0I1Un3koQfoOKBKeq+CkvA1XZZqqAKiXki2a8euwZaNg2D3hWtP+U2Grc1WnVaO
	qWZAu+da5i/DF8XMGlbUTnexh64tKs4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X0sUF4I4;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778970884; a=rsa-sha256;
	cv=none;
	b=EUSY4kFQSiaBVbGerDdO4G91MGTfpDWSr920RhDSx34dNUeKxD/jtisKOJkByeqQ2Z8Hqk
	W2QejVwB1ujqmT2zKUp1pZQDe/PCc6+AjSZ2M1BeGuwfoweXFL7L1PTdPkDIVERznVLDAZ
	FlDVN4AWkOmS+7ryQPbciBfF5aFIg9M=
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-7bdf83185bbso5222737b3.2
        for <linux-mm@kvack.org>; Sat, 16 May 2026 15:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778970884; x=1779575684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xoDTElId9snFmrZZxli5uToWxxMW032UXdLJQhd0rGU=;
        b=X0sUF4I4ZHAD5NRjcwJAdsgLpKbLmhuZ5vvE9PP2ishZnC74V5kXrqLVriFlqq8sdN
         6D0xQU+1uPIIpdh+0lYgrKLcDxyx8GxMIPiIneG5YC03oCCNT9TDKtc/stiuiTVvepus
         1LENbPM/ojw3/rx66UejyMpXd8wFkcgGoOt6UJVCNysbRWOtllEPiqSvxb4HpoKZclPQ
         5zZIiwptKXvC+cTx6Nv8/V88bFWS5vjsoOmbAm4+Lwc9hyuhQU40T2sfOiVzw+jE17M+
         jZpMPwxh0R9cHO+n23/qGFTMzN5aiTD1RDxXTye4IjFimUwZK8cH3YXgWkrcunkd2km2
         BagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970884; x=1779575684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xoDTElId9snFmrZZxli5uToWxxMW032UXdLJQhd0rGU=;
        b=LDBjw7w2QiYb7vctTv6BIBu2q8jtemrXTdSF0Y9BI8rSZI65WUY7LeIgKCn0XBdztR
         b9oGqosXtmF8PdEQxg+32fVB0Fyita6bAJoQDQ7ycBcEE85i0ln28gN+pJ9LuS9MOqIC
         6Z+FMuDUYcNhS8hEeDnGCacxuEXAHGUBzD/GnEddpOwOwHN6YiE48eumA6TKCIJjhED8
         NFiO+fWJo2+b0stNlWCHth8vgzkgUHUiBJ80XcdeZk0EvRrfOUZG+l8XhgHevqdvLZ0O
         nazsUA5nwxey7R3j6Lu1WcCaKL8PbdyYaYC4FCmdHz2b5iCSvbUcdytHDz3HmM3rCyUv
         1wHA==
X-Forwarded-Encrypted: i=1; AFNElJ8PVlg/5BzrlfSE5im7Upjqn60pX3xPXG7jiBBGes8WhiYBWS76RFJpEBwIQoD0XjTE1FXYABCyaA==@kvack.org
X-Gm-Message-State: AOJu0YyzNY3nkT7QqgZ33fddBVHUFI4TtTv1jEPs8oaubvHeDtOns23s
	VKthI3Fr0Oe9UZWnFfbzkqY/QcErRuw4jN8XpZHEzjqz5Ju+1PoftRY=
X-Gm-Gg: Acq92OF6kj22a7UvZO3jKCUJYXv8gDJQ15h614MLHphwF/GVU9EqWMTr1iolcsCMCYp
	q2ipiSnPUKVNJHEoTh5PKlmU+JJfmNbMDc8L5qIpeB8DImx+CNM9LIUGfHts/L6UG0RR186zJxM
	bCLrdXPjhM2LWjz86BKSbKeByzhdeg3peVHpjGUJUYlk7NTm3FNTl05aZPIH3us8YbXad6JWka1
	htxIrzFssxOED9iLwmigO42uJc1dnZAg41RiDWgS2lRiTyiRg6bqj/GHGxdjcxzIToa8FD6BIRH
	BaGQrZ3VkZF1/wdnuaC2EhqyoHNvD/2x4/Pc3LIo/BWaW+pYgwQJ55q1nXigRV0ouy5anbkDAIa
	G6Og82JkHR9/IacJ8MbNxDqwG2ZqAhLatrZePfZwsRv2AaVAw+aKVQtgNn6W9JXavFYh/juLOg2
	ESYlocIsAe8b9r4LqEm3DeGSLTRqVpQfJ12KSxxCL2fguNpgS2mcjsHG8Ybz5Ago2MGmopWV4Iq
	+YOCJ05nEP2
X-Received: by 2002:a05:690c:10d:b0:7b2:513b:34d7 with SMTP id 00721157ae682-7c95b828730mr106431887b3.29.1778970883609;
        Sat, 16 May 2026 15:34:43 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9d18b056sm637927b3.46.2026.05.16.15.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 15:34:43 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	bharata@amd.com
Subject: [RFC PATCH 0/7] mm/damon: hardware-sampled access reports + AMD IBS Op example
Date: Sat, 16 May 2026 15:34:25 -0700
Message-ID: <20260516223439.4033-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D389DC0004
X-Stat-Signature: ygqr6w8nzapfkg8fsp5x56pxauur5ttn
X-HE-Tag: 1778970884-803871
X-HE-Meta: U2FsdGVkX1/iQUt/DeI7CNZMQewpCipwXz4K/tUeOiWOmg4RHzSm0fbRZSmphxs0K3a5B+O4ztjytY/GirAFZGOmnj2KDACIjiHJNFPJXQrYNIfXE7Wp9MZ14ALHoPr2RhNL6gOnA5knjbM+O4WipjXaWDOQxrUXxYjYHiMhFyCRkqjiIl+y9bCNEGvRvgaa+RXdtARtncDhIiwCmw8Z97dZhXDhWXcshf1EyR1/MLCurePxeUI7lUVmIqSMVewokieOT71YVLzvCZ3R7OaZISrGknH8CKRIXcE5tNYNJyuB7SLajAyGCIYKSaHYaGJOF5VyY+U3xP3ZaCN08dop+qSJ9v80qSTxNavZt+PpBiKjcomyQZ0Uo1Eo9Mu+hvumCd9qtHqqCqZaWYcDUxCVPb4akJgv7+bzITmPTTZODfBRCaffYwxxBjhz5Y1W7GCfV7/O244MfbJdNCS2fm+yaqopGU+rtglmvbbNE/FVXTKlz+9FBa9NupDIxLlK67Nq645O+fx6wOeuHuRnot3dWAW7xi0xYcULRVrS01RtvEX8Bzu0VtpzfabitOkanP64NFEydjh3z1vMgI9sMpnA5hgBhu0kvvnWrHj+vtyJzT2bQx9k6FWBUkF1fa/tu7OZsa/6ui4kmceMPv9/VcuN8jCHjZCUMUUnzxdfR+7d/Jzim1g5uOT8k6HitAp14ADT4IsJ6s3oh8GvEiA02rEfE8/hNodYHB4t/pezNj5xxwJpyUh7qtv+25lWpclaVeCIH8NA2o59N7IY4Gh0tJWTsXK417CTCc90KRWIc33nQVr53fwbWhGJg7PWtI1rq/8Trux7FMndr29tBq3oYLhKSOAHiEkA0vXBIDKkwfKyRKx/O6hmntEpqlnlRojy/ZJ3ymjm+TTApNxYBg2NUO7rjiN+qKVhWwGqoXu+Nj+UgKCXWtpvu9viUmAvz2/2zxf5JLDXbQ1p2sahYidktw4
 UwqCuJ6g
 vdLzZfVu3GbQ8RA1atwmFQJqSPrfwLszyIhJfTzY/k6om0QMaoBtdSnlgKJeWtM4LY8Odtcwy0Mb2uU5gsiy5yexIYK8//ETTLesNKFSWkAz/NaKDDdMHdMDCYgVMF13+j/B4tm7mKruKWverQMbxTloU5fPOQy498noB7EIGziho3qo4Kn5BxGh3SInRLwrgLlJVHccTdklnd7jKzEHGLmR7I0QVvMuRPk4f/wZF/zD2EUnrre5rjPHqLmdSTBvPBXQ/Yxfbj1X20HstsENyq2rpPg/kb6Cm2BNcVUK8ulq4RwJ11eozfh2R/vPJl3riVEfW2xYroOyC3ByNHJAYrFpvQVqGSKDD/LgZeJH4TK+z6dXi8VYTmP59MoXBr2Wmt5jKqkg3q5HoT88sDcyg/NRzcyOri3jrc5R/fKhbwNs5JaWQHw/LESDs9cD2QgNaSMWiPr/CQFS/zfUGgLEQuMPl3RItl7ixlsKJf0BAKOEzBoN0hASrDj83402S0dBrhZBBSBeuquYidpAjQNjAf6j+Jq4RggvPpz3MAlpw8JJAL74ZT3pZT7+DH1DigNS5stjsF/EI/TFWm+jGxZWrt6N0mKPFQF+rHjKQ3tBEWkFSY/QoZ+vzt1CR6kbcnRgvttW9dhZRsOBOFvOMEctL7EDNqLhpGWad170wScEUFrqtV/GmlzpKBaK2rNRy3iaZ6SkZM6iUO0O7Bss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This is an RFC, not for merge.  The series exercises and validates
damon_report_access() -- the consumer API SeongJae introduced in [1]
-- as a substrate for ingesting access reports from hardware-sampling
sources.  The series includes one worked-example backend, an AMD IBS
Op module (damon_ibs.ko), that runs on Zen 3+ silicon via the
existing perf event subsystem.

Combined with node_eligible_mem_bp [2], the recently-merged DAMOS goal
metric, the same DAMON interface composes naturally for two
operational regimes from one set of primitives:

  1. Traditional tiering -- promote hot pages to DRAM up to a target
     cap.
  2. System-wide bandwidth interleaving -- split hot pages between
     DRAM and CXL at an operator-chosen ratio, for workloads where
     placing some hot pages on CXL improves aggregate throughput.

Either regime composes with a separately-configured migrate_cold
scheme to pair bandwidth shaping with capacity expansion: the
hot-page schemes drive placement to meet the bandwidth target while
migrate_cold reclaims DRAM by demoting cold pages.

The demonstration in this RFC exercises different
target ratios of the same PULL+PUSH setup.


Why a hardware-source primitive complements existing primitives
===============================================================

DAMON's existing access-check primitives observe access through
software paths:

  - PTE-Accessed bit scanning samples Accessed bits and clears them
    periodically.  The hardware sets PTE-A on TLB miss, so already-
    resident TLB entries do not re-set the bit until they're evicted.
    For pages whose translations stay TLB-resident across DAMON's
    aggregation interval, nr_accesses reflects fewer accesses than
    the page actually serviced.  This is correct behaviour for the
    primitive -- it observes what the TLB-miss path observes.

  - Page-fault sampling (NUMA hint faults) requires unmapping pages
    to provoke the fault, then samples access on the fault path.
    For closed-loop schemes that drive migrate_hot from the same
    observations, the unmap and the migrate action interact.

Both primitives produce a view of hotness that converges to the
true distribution over the aggregation interval.  For systems where
the address space is small relative to the aggregation rate, this is
the right tool.  On large heterogeneous-memory systems with goal-
driven schemes asking the closed-loop tuner to converge on a target
distribution, a complementary lower-latency view of accesses can
tighten the loop -- reducing the time DAMON's nr_accesses takes to
reflect the workload's actual access distribution, which in turn
reduces ramp duration and oscillation amplitude during convergence
of goal-driven schemes.

A hardware-sampling primitive provides this complementary view:
hardware retirement records each access at its natural event rate,
with a physical address per sample, independent of TLB state and
independent of the unmap/fault path.

This RFC adds the substrate (damon_report_access) so any hardware
sampler -- IBS, PEBS, future CXL hotness monitoring units --
can feed access reports into the kdamond drain path and existing
DAMOS schemes.  The substrate is the contribution; the IBS backend
is one worked example proving it on broadly-available silicon today.


Demonstration
=============

The two-scheme PULL+PUSH setup from the node_eligible_mem_bp
introduction holds a target hot-memory ratio across DRAM and CXL.
With damon_ibs.ko feeding damon_report_access, we observe two
operational regimes:

Cold-start convergence -- workload starts at an even DRAM/CXL
distribution (numactl --interleave=DRAM,CXL), DAMON context starts
with the target ratio set at kdamond launch, schemes converge from
the initial distribution to the target distribution.

  +-----------+--------+----------+---------+
  | Target    | Mean   | Offset   | Stddev  |
  +-----------+--------+----------+---------+
  | 70% DRAM  | 69.73% |  -0.27pp |  0.70pp |
  | 30% DRAM  | 31.00% |  +1.00pp |  1.28pp |
  +-----------+--------+----------+---------+

Live target changes from a converged state -- kdamond context runs
continuously, target ratio updated via DAMOS commit_schemes_quota_goals
without kdamond teardown.

  +-----------+--------+----------+---------+
  | Target    | Mean   | Offset   | Stddev  |
  +-----------+--------+----------+---------+
  | 90% DRAM  | 89.74% |  -0.26pp |  0.64pp |
  | 85% DRAM  | 84.61% |  -0.39pp |  0.60pp |
  +-----------+--------+----------+---------+

In both regimes, convergence to target is quick, and the workload's
measured DRAM share then holds within 1.3 percentage points of
target with standard deviation under 1.3 percentage points, sustained
over runs of 15-30 minutes per target.

Hardware envelope: AMD EPYC dual-socket, CXL.mem on a separate NUMA
node, 32GB hot working set, two migrate_hot schemes with complementary
address filters, temporal quota tuner, 256-entry per-CPU report ring,
512 MiB per-scheme quota, 1s reset interval.


What's in this series
=====================

  Patch 1.  mm/damon/core: refcount ops owner module to prevent
            rmmod UAF
  Patch 2.  mm/damon/paddr: export damon_pa_* ops for IBS module
  Patch 3.  mm/damon/core: replace mutex-protected report buffer
            with per-CPU lockless ring
  Patch 4.  mm/damon/core: flat-array snapshot + bsearch in ring-
            drain loop
  Patch 5.  mm/damon: add sysfs binding and dispatch hookup for
            paddr_ibs operations
  Patch 6.  mm/damon/core: accept paddr_ibs in node_eligible_mem_bp
            ops check
  Patch 7.  mm/damon/damon_ibs: add AMD IBS-based access sampling
            backend

Patches 1, 3, and 4 are general infrastructure that benefits any
consumer of damon_report_access().  Patches 2, 5, 6, and 7 are the
worked-example backend (paddr_ibs ops, sysfs binding, IBS module).


Patches worth folding into damon/next
=====================================

Patches 1, 3, and 4 are not specific to IBS or to this RFC's
backend.  Each is preparatory infrastructure that any consumer of
damon_report_access() will need:

  - Patch 1 (refcount ops owner) -- any modular ops set, including
    out-of-tree backends, needs clean module unload to avoid UAF
    on damon_unregister_ops.
  - Patch 3 (per-CPU lockless ring) -- damon_report_access() cannot
    be called from NMI context with the current mutex-protected
    buffer.  Hardware samplers all need NMI-safe submission.
  - Patch 4 (flat-array snapshot + bsearch drain) -- the linear-
    scan drain is O(reports x regions) and exceeds the sample
    interval at high-CPU x large-region products.  Bsearch brings
    it to O(reports x log regions).

If these belong directly on damon/next as preparatory patches for
damon_report_access() rather than living inside an IBS-specific
track, we are happy to rebase and resend them that way.


Relation to prior and ongoing work
==================================

The IBS sampling pattern in patch 7 -- attr.config=0 to use IBS Op
default config, dc_phy_addr_valid filter, NMI-safe sample submission
-- is derived from concepts in Bharata B Rao's pghot RFC v5 [3].
The attribution header is in mm/damon/damon_ibs.c and the patch
carries a Suggested-by: trailer.

Bharata's pghot v7 [4] introduces a different IBS driver targeting
the new IBS Memory Profiler (IBS-MProf) facility, which Bharata
describes as a facility "that will be present in future AMD
processors" -- a separate IBS instance from the one this RFC's
backend uses. This version of driver based out of v5 [3] is an
example of how DAMON can be benefited from AMD IBS Hardware
source and validates importance of IBS information indepedently.
It is not meant to be merged in the current form.
@Bharata if you see a path where IBS samples can be consumed
by DAMON at some point, will be happy to collaborate.
 
Akinobu Mita's perf-event-based access-check RFC [5] explores a
configurable perf-event-driven access source for DAMON.  IBS has
vendor-specific MSR setup beyond what perf_event_attr alone
expresses (e.g. dc_phy_addr_valid filtering on the produced sample,
not on the perf attr), so the IBS path here appears complementary
to [5] -- operators choose based on whether their hardware sampler
fits stock perf or needs additional kernel-side setup.


Specific asks
=============

To SeongJae:

  1. Patches 1, 3, and 4 are infrastructure that benefits any consumer
     of damon_report_access(), not just the IBS backend in this RFC.
     Would these belong directly on damon/next as preparatory patches
     for damon_report_access(), rather than living inside an
     IBS-specific track?  Happy to rebase and resend them that way if
     you'd prefer that shape.  Tested-by: tags can come along.


Future work
===========

  - Longer-duration stability and broader workload coverage.


Test branch
===========

A single fetch reproduces the cover-letter measurements on top of
both this RFC and the companion DAMOS quota controller and paddr
migration walk fixes posted separately at [6]:

    git fetch https://github.com/ravis-opensrc/linux.git \
        damon/hw-hotness-rfc-v1-testing

The companion fixes are not required for this RFC to function, but
the closed-loop measurements above were collected on the testing
branch which has both applied.  The standalone series-only branches
are also available:

    git fetch https://github.com/ravis-opensrc/linux.git \
        damon/hw-hotness-rfc-v1
    git fetch https://github.com/ravis-opensrc/linux.git \
        damon/closed-loop-fixes-v1


Links
=====

  [1] [RFC PATCH v3 00/37] mm/damon: introduce per-CPUs/threads/
      write/read monitoring (SeongJae Park)
      https://lore.kernel.org/linux-mm/20251208062943.68824-1-sj@kernel.org/
      Patch 01 introduces damon_report_access(), the consumer API
      this RFC builds on.
  [2] mm/damon: add node_eligible_mem_bp goal metric
      https://lore.kernel.org/linux-mm/20260428030520.701-1-ravis.opensrc@gmail.com/
  [3] [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
      infrastructure (Bharata B Rao)
      https://lore.kernel.org/linux-mm/20260129144043.231636-1-bharata@amd.com/
  [4] [PATCH v7 0/7] mm: Hot page tracking and promotion
      infrastructure (Bharata B Rao)
      https://lore.kernel.org/linux-mm/20260504060924.344313-1-bharata@amd.com/
  [5] [RFC PATCH v3 0/4] mm/damon: introduce perf event based access
      check (Akinobu Mita)
      https://lore.kernel.org/linux-mm/20260423004211.7037-1-akinobu.mita@gmail.com/
  [6] [PATCH 0/5] mm/damon: DAMOS quota controller and paddr
      migration walk fixes (Ravi Jonnalagadda)
      https://lore.kernel.org/linux-mm/20260516210357.2247-1-ravis.opensrc@gmail.com/

Ravi Jonnalagadda (7):
  mm/damon/core: refcount ops owner module to prevent rmmod UAF
  mm/damon/paddr: export damon_pa_* ops for IBS module
  mm/damon/core: replace mutex-protected report buffer with per-CPU
    lockless ring
  mm/damon/core: flat-array snapshot + bsearch in ring-drain loop
  mm/damon: add sysfs binding and dispatch hookup for paddr_ibs
    operations
  mm/damon/core: accept paddr_ibs in node_eligible_mem_bp ops check
  mm/damon/damon_ibs: add AMD IBS-based access sampling backend

 include/linux/damon.h       |  13 ++
 mm/damon/Kconfig            |  10 +
 mm/damon/Makefile           |   1 +
 mm/damon/core.c             | 341 +++++++++++++++++++++++++++------
 mm/damon/damon_ibs.c        | 369 ++++++++++++++++++++++++++++++++++++
 mm/damon/ops-common.h       |  13 ++
 mm/damon/paddr.c            |  15 +-
 mm/damon/sysfs.c            |  12 +-
 mm/damon/tests/core-kunit.h |   2 +-
 9 files changed, 707 insertions(+), 69 deletions(-)
 create mode 100644 mm/damon/damon_ibs.c


base-commit: 606bfbf72120df4f406ef46971d48053706f6f75
-- 
2.43.0


