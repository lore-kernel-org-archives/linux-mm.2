Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A620C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1FB16B0095; Wed, 19 Aug 2026 03:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACEE26B0098; Wed, 19 Aug 2026 03:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4EF6B009D; Wed, 19 Aug 2026 03:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7099B6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:05:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECABD80451
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:05:45 +0000 (UTC)
X-FDA: 85117133850.30.75A8029
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf17.hostedemail.com (Postfix) with ESMTP id 478CA40002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:05:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mcp69lZs;
	spf=pass (imf17.hostedemail.com: domain of 3xlWFaggKCOEMDVRQPLXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jasonmiu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3xlWFaggKCOEMDVRQPLXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787123144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/5Ut30PM1D32BzO4CJAfeJOZxs3sCO17fFGXnkufLgM=;
	b=BIePjjfXm4j3bMrorc7bRzNgGhiI3GvdxC8phBKQzX4zG/CXwjyhodoZb2chVq/kfvYG2X
	CWCEsUAhIRRR/Ec5DKB/z8Hu/tMFagzBi+3J9B8ejkreBUuC10IjwV48Wiqug/cpRoMBsB
	LwAFC/zA/8cI5FPP9jhshUv2H//33HA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787123144;
	b=YSi39e5q2bzVrwyomgU1vevmGd6mAHAyUKqXvg1lSDQcgRR5cOMjhZB9quLAmys3mOFnkJ
	KU445zSZGrAVkmahV8cKswrf85Vt/F8nM7eez/gHNZyn/yeX5GwHOIrcTHriYoB3BxJO6Z
	8qABj/Oygc/OR9XPYMMGYls1QVn7ILY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mcp69lZs;
	spf=pass (imf17.hostedemail.com: domain of 3xlWFaggKCOEMDVRQPLXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jasonmiu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3xlWFaggKCOEMDVRQPLXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso1010396a91.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787123143; x=1787727943; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/5Ut30PM1D32BzO4CJAfeJOZxs3sCO17fFGXnkufLgM=;
        b=Mcp69lZs9GMmkhaqUiRLNcA1zq0FyarcNMZau9Y1IraNhe6xpYWolKyknk+oBHFw2l
         PVEExtkajhSIMt1Ik/Pfo6wX/YNbDm6axw3hOeOkQe7arvNHX0Z7oPPyQd/7nOtZXn2Y
         KTLi+KJKn2/ZglK3tLd0XROo3PmZy+FImUBw/dAhUpXVBypqFaRVsnfh+njhvDXjEVyT
         mECTao4PKn7U6PveARt3rohwFcg0UBfpcZxprcKHJf5Sh4oL407zeyodVaNIFmUXevRh
         oOGhc3DvrLXd9z2N0jgLQvehWgUe9bOME0uIABlZzheDkWSpWlwqKiYmXchOVoGRvBat
         tSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787123143; x=1787727943;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/5Ut30PM1D32BzO4CJAfeJOZxs3sCO17fFGXnkufLgM=;
        b=e+MQRlEeussWKzTWOVex8HL0ccmWXQYlZD+OPs2itZBR91xUYudCfBCqeOuEZxA9KJ
         vpy0IjXGwol8xly8ecytvHghj3Q99mZU2681trZQW1W8EAxATHtyQFk/ltHnrhB9R9ZV
         dPMc+PzQgXLC6p+CoX5Gax8JjGYYDjKtvqpTBsR18R6+3VrHNTkx9DVSNdIfgN1aEjme
         6aF+9Uqy+imr1fZbF62PeEhTPfLBX/mmz/Z1HHfAe0m3dmPM7uY9uVnrN7It1zwmdOv1
         ev2gLItM5yE2OTTmy58vhOJTK5wXbrb1s0Fbhm4lMK+0wsenmxo9Jg/1JojLB/nm/c0h
         sX8w==
X-Forwarded-Encrypted: i=1; AHgh+RrPEBEYDqMFvDjAI5tqf/8zkFR0rQaEc6KdizECHrdyUApE7mi+xww+Eqc1xBmFsheAiU4f94Nd1A==@kvack.org
X-Gm-Message-State: AOJu0Yzd6yuTQToRi75VWP+rM20Uw4tGEpkEVFQHmhWq2tXOtHG59tgO
	EEdCA3r9x17nNfbDPDCVLHC7akLslrhoXMkiDs1PDI/00issf38eYJsZ3kYy93T7E8NovxsQ6kM
	r3A2eYcYY75YhVg==
X-Received: from dleg1.prod.google.com ([2002:a05:701b:4301:b0:13d:2ef5:67be])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d85:b0:385:393e:7124 with SMTP id 98e67ed59e1d1-3958127ae44mr4871724a91.14.1787123142847;
 Wed, 19 Aug 2026 00:05:42 -0700 (PDT)
Date: Wed, 19 Aug 2026 00:05:35 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.737.g08866a6d13-goog
Message-ID: <20260819070538.2404983-1-jasonmiu@google.com>
Subject: [RFC PATCH 0/3] selftests: mm: introduce page allocation stall reproducer
From: Jason Miu <jasonmiu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Greg Thelen <gthelen@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, Jason Miu <jasonmiu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: r1qjqi8ds4b87jbhf5tgp3xp93dft946
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 478CA40002
X-HE-Tag: 1787123144-745496
X-HE-Meta: U2FsdGVkX19tCUEZ3uAK8Z3LmbLMhbEZTy4FsykoZhwVWuPVg9lbNT24VsmAS6Oq8AvsHEznN1aArWfj9tUJxMrp8PQ+Fh2NFWQjaxGS5RuprnOUex6D8QJpDDAqJjlv/ldsMl4rapkGViMUpcNrmDSu8+XnpbKYL8WVt2/dz2gGZvI5tlgZlkYBiMsIi7SsJNr7af3bdbenndFkQ5mhmIxPF2e/kTvNHkm/5/0jjXVZxl80RicTB6JPQVOWVyNy4Gyzlsno26q0kdy6/riA4JYawOwqp3ni03UcSnSO4jThhGeerkME6QY64w7kdG7U9BI+bF42/jeQGVRqro8b9S5vR3OmZL10jtO7Gd6JUu8BNTMwQDzi61UUzeWtdq1MUXZaeyeeYb+qlIc+V3JpwcvyAG9rwmKJJ1tGQXwhi+ta9LedqujN5ruNwMjTGrDnjp++kBLUkwg4UtLWs9UVlRsM0OAcWaoKjb+TuhRnH6SHLRK1FcrGVOULfdFfCgKonP8oa3K7kEstsxpS73Jz4UxlgMAmCdh8J0lI5c3dnlTCRfd9vXcR7By180RT5bECIIJVnT8mCKzI9XB2vcJ8LHjPJwWUaO1HLizJijNzuAuM1yntdooF14GOXYBWzLvISMuCHhMxgu3OoE9so7I7Cuk0NHc50jOZ0iFqV3lqLerYcwTIIaJXB3KxZDb21cTf6sbVOiWltLtGnM5hgp0oF9GBKgCyjZqkrv4RmDsNmfJA1/YXiYzeS372AbE25kvuo5WdNkZkMBtsGj5rZ3yX+E+CQOoCwZXEfdCV8jXIB5+4Yk+SPJbRo1ZkBRQgi5HYdeIIp7NtHImQ+ScRRbE7MUM2fLy7G5t7UvuNLNFL27c8ITTzZDsU4ZLRzbQjn0BqHi4rJJUe4/g2K0bZ40yVZmBWFhI+5dJPWOyhud72AGh3DYsYhmXd0qqK1S8T8Ec/NbyYnSr5P4l8awErPzP
 KoAWG9Jv
 dC3BfDnxKH9Vn0zjIhWsXPf35atnqQPBYbTgY8eJGsNsTzs8B6cMSuzjTOKHWtaeB8/xqV5Cpoa8q6EJV37d8Iz4YZRGJj4EpMkH2goSeqgg14Q6XWNlQMChNaphMRiGpw0OZovt37zpn4nNU3G4I1tQE7V6Sc5ljYjqZjawygsxi5DQk7zE0PeG9zZ9gbtEvR6EuUQnrcvtDGArqos2tF9ktKmEJMa5WiJug4HyfuuwF1o9f9PHkp7Ve0TbPxpetrCkIW6/77Nxzj1vtQMHsuP3sMnHC6sUiW5yrlMEpuhz+BoPpuAejrquBxIaHhALwAn5Tv5/wDy8zyW4e5OAcxT7QntBB9qmRWfMl3Bw6CIrRRANM3DGNbZRw3bhPfoUbEunt7qYF1A7fZgwnEeU3i0zyJRpIHbDfpq1CXoyDjA6Dd4LEfa432slN4v/WJ9cv4i3uSRZX31oQASjxLIT57NS1JnEgrx+YcuTZMEQwELOzb2I3znghCksnhHZJa46d+BHOoIdmyXBVFIwOEAobxftSSF5e09eOPBWSqHH7MGiPPWJaCSiEZkBWNb1hP5JDczcZwY/iCJovfc5p9je9xFrJETp/7Ns0qmsEaN+wccmJpZVa0H4oARjR3fknvgcrajaS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Background
==========
Under severe system memory pressure, system unresponsiveness often 
occurs due to page allocation stalls. In commit 94e0bcde055e ("mm, 
page_alloc: reintroduce page allocation stall warning"), David Rientjes 
introduced a warning mechanism to emit a kernel log when a page 
allocation takes longer than 10 seconds. This log is used to correlate
a frozen system with the system memory state at the time of failure.

To further debug and analyze these allocation stalls, we need a 
reproducible test case. This patch series introduces a new selftest 
designed to artificially mimic the severe memory pressure scenarios 
seen in production, allowing us to observe the resulting allocation 
stalls.

Patch Series Architecture
=========================
This selftest creates memory contention by saturating both userspace 
and kernelspace:

1. Kernelspace: A generic kernel module (test_mempress_timer.ko) binds
   timers to every online CPU, continuously executing atomic page 
   allocations (GFP_ATOMIC | __GFP_NOWARN) from a timer. This behavior
   simulates a massive influx of networking allocations. However, such
   stalls can be triggered by any mechanism that allocates below the 
   per-zone min watermarks, which forces the page allocator to 
   continuously loop when servicing user allocations.
2. Userspace: A Python script creates a memory pressure scenario by 
   spawning a primary memory hogger process to lock a percentage of 
   system memory, driving the system to a low-watermark state. It 
   simultaneously spawns concurrent worker processes that intentionally 
   overcommit the remaining memory to churn anonymous pages.
3. Orchestration: A Bash script constructs a loopback zswap device and
   coordinates the execution of both workloads. The memory pressure 
   situation is designed to last for 15 minutes by default.

Experimental Results
====================
We executed this test on a bare-metal node with the following 
specifications:
- CPU: 224-core Intel(R) Xeon(R) Platinum 8481C (2 Sockets, 2 NUMA)
- Memory: 503 GiB RAM

Test parameters used in the orchestrator script:
  ./page_alloc_stall.sh 80 64 2.5 50 memtoy/memtoy
  
- 80: Primary memory hogger limits memory by locking 80% of RAM.
- 64: Spawns 64 concurrent memory worker processes.
- 2.5: Workers overcommit the remaining freely available memory by 2.5x.
- 50: Allocates 50 GiB for the synthetic loopback zswap device.
- memtoy/memtoy: Path to the external binary used to allocate memory.

During execution, we mimicked the memory pressure scenario observed on
production systems. Under these conditions, we observed page allocation
stalls occurring across various processes, highlighting the resulting 
system unresponsiveness:

  [ 7467.002149] watchdog: BUG: soft lockup - CPU#156 stuck for 21s!
  ...
  [ 7561.805279] cron: page allocation stall for 566 secs...
  [ 7668.275609] systemd: page allocation stall for 673 secs...

Test Execution
==============
This is submitted as an RFC. We are actively seeking feedback from the 
community on this testing methodology and integration.

The primary objective of this selftest is to establish a measurable 
baseline for page allocator responsiveness. This baseline will be used 
to validate upcoming improvements to the allocator, and will serve as 
a permanent framework to prevent future regressions.

To run the selftest:
1. Compile the kernel with CONFIG_TEST_MEMPRESS_TIMER=m, 
   CONFIG_MEMCG=y, and CONFIG_ZSWAP=y.
2. Execute with default parameter values:
   ./tools/testing/selftests/mm/page_alloc_stall.sh

WARNING: This selftest is explicitly designed to exhaust system 
resources and heavily saturate the CPU. The machine will become highly 
unresponsive. If executed remotely, active SSH/network connections are 
expected to drop.

Credits and Dependencies
========================
This test depends on an external memory allocation tool, memtoy, 
written by KOSAKI Motohiro (https://github.com/kosaki/memtoy), which we 
utilize for handling the underlying anonymous mappings.

We would like to extend our thankfulness to Shakeel Butt 
<shakeel.butt@linux.dev> for graciously allowing us to reuse some of 
his original ideas and module implementations in this test.

---

Jason Miu (3):
  lib/test_mempress_timer: add module to generate kernel allocation
    pressure
  selftests: mm: add script to induce userspace memory contention
  selftests: mm: add script for memory allocation stall test

 lib/Kconfig.debug                             |  11 +
 lib/Makefile                                  |   1 +
 lib/test_mempress_timer.c                     | 140 +++++++++++
 .../testing/selftests/mm/page_alloc_stall.sh  |  80 ++++++
 .../selftests/mm/page_alloc_stall_pressure.py | 235 ++++++++++++++++++
 5 files changed, 467 insertions(+)
 create mode 100644 lib/test_mempress_timer.c
 create mode 100644 tools/testing/selftests/mm/page_alloc_stall.sh
 create mode 100644 tools/testing/selftests/mm/page_alloc_stall_pressure.py

-- 
2.55.0.691.gc56d675ccc-goog


