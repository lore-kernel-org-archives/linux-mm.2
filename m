Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41DEC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A48E6B0092; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806746B008C; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE966B008C; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 385126B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C423B80407
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:16 +0000 (UTC)
X-FDA: 85146989592.11.5E3E760
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf21.hostedemail.com (Postfix) with ESMTP id 35F151C0002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf21.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787833995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=87eHxU3ugtHXsKXKypzvprZlOBW3MHmaLfNCexZbS3Y=;
	b=WKnd5W+LvGTh+LBm0npaI5aEPk2MmD9bBaFW9pDag36vKzxqK1BSyPqzI6w5jJ/BTNSedG
	O6k87hWypbK7NsodjVXpfVuTAboSYPWbos0Zr+4+/uGf/dvfHq4Lc9BI7zAGsJw0Aqqlo3
	T/Wwo87Tvh6q4OttP0dVpK4Ml+ZbD/E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf21.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787833995;
	b=EJT5OUAR3M9iRuaRhf0PYmbkOj9oAQPQP+JWZnkidzRD40OX31ba2hCVTe/3IBwfTl6ew2
	gxj2YT/tm/1/vyeTdDonr0X2Yv6hp0UimXF+qH0EfVS3vquph4F4ZFj6CIeW7JWAOJ9Ktx
	aybipzEJoywF0/+VTBDOGrtldJ6T0Gc=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1Bm0Vvcz34Dg;
	Thu, 27 Aug 2026 20:33:04 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1Bj6Zngz34Dg;
	Thu, 27 Aug 2026 20:33:01 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id AFDF736F1F84;
	Thu, 27 Aug 2026 20:29:19 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:00 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
	<vincent.guittot@linaro.org>, Chen Yu <yu.c.chen@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>
CC: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Phil Auld
	<pauld@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>, <justin.he@arm.com>
Subject: [RFC PATCH v2 00/23] sched: Scale cache-aware aggregation at LLC granularity
Date: Thu, 27 Aug 2026 20:27:53 +0800
Message-ID: <20260827122816.756234-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Stat-Signature: dd5ogmgerawtsg36gm83b9ogs5f8zcak
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35F151C0002
X-Rspam-User: 
X-HE-Tag: 1787833993-379040
X-HE-Meta: U2FsdGVkX1/vHoZ1h3T/lNdhauCryTLU7YuPS3hg6qqt9AVnPz7GHD5TRPc+xI2VWl0QqgnHw2ZzrhAm2MDrRjJPgcbSp+zqrKaxXMiGUO2Qc3772hc0XaVm4WyIdmBiv7MqUDNadAQuplN7JK9v+d6UgCoPMCDnBlhUrlE1yzGJRemR7ueQ7HBjdBfthpZsnylJLtixL5b4snCzmW/gTFvm+hCBaWx+Pc57+RwGc/zkSqg+7x1B9REUoUrkNHoXHkZIqayasaahxih8EnuGYSOuIpbuAyxvZukbGee3PlYks79Eb1ZlaU7lVYOWeCCTMIVr0fAChnYvyat4Pcu7xZhANCuIYLw0a86IkV0t5CY02bQndo7s0LOS4OXbOO9z9AEU8mimy0fonoACD7Lz8cxeDZQ/8xVJHTSB/dMRmlkYXztiSE+xsavN/efI8y3zpsYd+dU0c7AT8BJvfiqEaia9k8pI6w+T0II9FwD0+hs/APaU3MqBboBovxKeHfEvk6nFhXT40kIOmDzJbQi/lZXI6NYE+OvvSjI4CWtYyD5JMiKpbN9b06DfQkCKbZMcnAXa/nYvjwTu7rlG5jwdHCVbYjUnNX5lnWaK6LIsVaa3SD+Ecv4gJtAdkMKO+fui6byzz9ckKGMvHWlYUWIznGu01qORWGyde3bGUED0atcxbWaflfmnfE/Koiq7gPKRaozR/pn6qYG7vA+RtMHkG8y4fJ6+m2JPZP1pt/0whYF6WbdvHUTwQ4hB6uMOBeYThfPtK7yFf+nlK680gHhWtxFuhzfbdilb3/14cMi0YVDVSJ63WKg6Huv6ACWCFzQ0t/BJTmxUh0WmyKLiu+MHZO0Lw3L1KRGHRzI0BEHoxSsIMRZPsL7pPFMnhFT5a1Ln4ehV4xwsimMcP5IvhRlk6qiGC8jY5dhqLwl2swxnJuC2EhY3AnQY3fd3Ou8ZZd2pyJ4MSTh5X2kPAquhGq1
 sSLcOZHM
 e+T1AWzlLoM+OdyBV5YAqgeERMKG134eoqRBMoKyulXEbURUrSxbxu6UPIIAx9kiVvwxoJT9gnK9qWEUqCNolgj0qLicm/9bUXg64uT4mucQ3mJkNIjjbM5T3LeIDmHrqMkx5UCwf3jEpmnbtbmBOnWBAEPOuqhRzNnC2z2698ptylGkWbEWyKIvC/UpWsjAlEbKaDah89T8Q0po/YCFpA4wDQp9yaulBPmec13+ckaWaDtvAY6AtnrDHxWixtPDFxzRJG+OOy/3ts0leJoJmYiZDV3LzAY9ilXfQ+Hx6LCw9RHkkM4cO3ERbc/mnmjuvE50udP7Uzi5c4edQeINzkl5Jbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Problem Statement]
The current cache-aware scheduling implementation adopts an
LLC-centric task aggregation model. While effective for workloads
that fit within a single LLC domain, this design is fundamentally
limited by its fixed aggregation scope and cannot scale across LLCs.

[Proposal]
Peter Zijlstra suggested scaling resources at LLC granularity instead,
and this patch set implements that idea.

To achieve this goal, we need to answer two questions: in which order
should LLCs be considered, and how far along that order does a thread
group need to spread? The scheduler aggregates threads near the
preferred LLC first, then expands through the ordered LLCs as the
thread group's aggregate demand requires.

For each preferred LLC, the topology-based affinity model defines a
fixed order in which LLCs should be used. The scheduler estimates the
thread group's total utilization and selects the smallest leading
portion of that order whose allowed capacity can accommodate the
group. A task may migrate to an LLC in that portion only if the
destination can also accommodate the task.

For example, in a simplified system, there are 4 NUMA nodes, each
node with 4 LLCs. The node distance matrix is:
        NODE0    NODE1    NODE2    NODE3
NODE0   10       20       30       40
NODE1   20       10       25       30
NODE2   30       25       10       20
NODE3   40       30       20       10

Given a preferred LLC, its node's distance row ranks the other NUMA
nodes. For example, if the preferred LLC is in NODE0, NODE1 is ranked
before NODE2, so LLCs in NODE1 precede LLCs in NODE2 in the resulting
affinity sequence.

To rank LLCs inside the node containing the preferred LLC, there is no
existing LLC distance matrix to use. So, we construct one which has no
real physical meaning and is only a hint for constructing the affinity
sequence. For example, consider this LLC distance matrix:

        LLC0    LLC1    LLC2    LLC3
LLC0    0       2       3       4
LLC1    2       0       4       1
LLC2    3       4       0       2
LLC3    4       1       2       0

Each row ranks the other LLCs relative to the LLC represented by that
row. With LLC0 as the preferred LLC, its row ranks LLC1 before LLC2 and
LLC2 before LLC3. A different preferred LLC selects a different row and
may therefore produce a different order.

Combining the node ranking, the selected preferred-LLC row, and the
ascending LLC-ID order used inside other nodes produces one affinity
sequence for a given preferred LLC. It does not define a global order
between arbitrary LLC pairs.

Note that there may be identical numbers inside a row of a real
node distance. So, we should build a new node distance matrix in
which the distance values within each row are unique. This node
distance matrix is only used for migration decisions in the
cache-aware scheduling (CAS) extension.

Once a preferred LLC affinity sequence is constructed, the scheduler
uses it as an input to migration decisions. For example, assume LLC0
is the preferred LLC and its affinity sequence is as follows:
LLC0->LLC1->LLC2->LLC3...->LLC15. (Note that this is a simple example.
Generally, for the node containing the preferred LLC, the sequence is
decided by the LLC distance matrix inside the node. For other nodes,
LLCs are ordered by ascending LLC ID within each node,
while the node sequence is decided by the node distance matrix.)

The affinity sequence gives an ordered expansion preference, rather
than an unconditional per-LLC saturation gate. The scheduler estimates
the aggregate utilization of a thread group and derives the furthest
LLC-distance tier required for that demand. A destination LLC within
the resulting range is eligible when it has capacity for the task,
even if an earlier LLC in the sequence is not yet saturated. For
example, LLC3 may be selected when the estimated range reaches LLC3
and LLC3 has capacity. A destination outside that range still uses
the ordered saturation check to preserve aggregation.

Thus, for a given preferred LLC, the affinity sequence is fixed, while
the scheduler dynamically determines how many LLCs from the beginning
of that sequence the thread group may use, based on its estimated total
utilization.

Before this implementation, we tried to maintain an LLC mask for each
process's thread group to record its current resource scope. However,
this approach proved to be difficult to maintain. The mask is updated in
task_cache_work() but consulted during load balancing, so rapid
workload changes can leave the mask temporarily out of date. As a
result, it may no longer accurately represent the thread group's
actual resource usage, making migration decisions unreliable.

The LLC mask is also insufficient for guiding source group
selection during load balancing. The mask is associated with a
specific thread group, but when load balancing searches for a
source sched_group or runqueue, there is no available task context
to retrieve the corresponding LLC mask. We need a task-independent
mechanism that can provide such information during load balancing.

This patch set also tries to address NUMA balancing-related impacts.
With NUMA balancing enabled, the preferred LLC fails to stay stable
since the scan range is limited to the current task's preferred node.
We fix this by adding all preferred nodes of active tasks in the thread
group to the scan range.

We also seek to suppress task-migration conflicts between CAS and
NUMA balancing, including splitting NUMA balancing into task and page
migration paths (suggested by Chen Yu <yu.c.chen@intel.com>) and removing
unnecessary preferred node checks in load balancing code. These parts
are unfinished and open for further discussion.

[Patch organization]
The series is organized as follows:

  Patches 1-6 build the topology infrastructure: LLC-to-node mapping,
  unique node-distance values, node/LLC traversal helpers, and an sd_node
  scheduling domain.

  Patches 7-10 collect preferred-NUMA-node information for tasks and CPUs,
  and add the per-sched-domain state needed by load balancing.

  Patches 11-16 implement LLC-granular migration decisions. They calculate
  affinity gain, select source runqueues and groups, decide migration
  eligibility, and allow active balancing to expand to another LLC.

  Patches 17-19 handle the interaction with NUMA balancing: they make its
  decisions LLC-granular, scan all preferred nodes of a thread group, and
  remove no-longer-needed preferred LLC/node restrictions.

  Patches 20-22 estimate whole-thread-group utilization, derive the LLC
  range needed for that utilization, allow migration within that range, and
  walk the preferred node starting from the preferred LLC.

  Patch 23 exposes a task's preferred LLC for scheduler debugging.

This patch set is far from perfect and still contains some unresolved
issues. Before proceeding further, I would like to confirm whether I am
heading in the right direction. Therefore, I am sending these patches
out to gather early feedback.

v1: https://lore.kernel.org/all/20260625030759.25928-1-wujianyong@hygon.cn/

Changes since v1:
(1) No longer scale resources based on sched domain boundaries.
(2) Add a new node distance matrix with no duplicate values within a row.
(3) Add an intra-node LLC distance matrix to rank candidate LLCs
    relative to a given preferred LLC within a node.
(4) Change the way affinity gain is calculated.
(5) Change the way migration permission is decided.
(6) Fix saturation issues in some tests like schbench.
(7) Include all preferred nodes related to the thread group into the scan
    range.
(8) Add a tunable to enable/disable task/page migration for NUMA balancing
    independently. (Suggested by Chen Yu)
(9) Estimate whole thread-group utilization to derive its LLC capacity
    range.
(10) Permit migration to an LLC within that estimated range, even when an
     earlier LLC in the affinity sequence is not saturated.
(11) Walk LLCs in the preferred node from the preferred LLC.
(12) Fix a bug in the debug print patch. (Suggested by XIAO WU)

Tested on a Hygon machine with the following topology:
* 2 sockets
* 4 NUMA nodes per socket
* 4 LLCs per NUMA node
* 4 cores per LLC domain
* 2 SMT threads per core

The scheduler changes apply cleanly on Linus' tree at 0f23d56f17fd
("Merge tag 'linux_kselftest-next-7.3-rc1' of ...kselftest") and build
there.

Functional test:
Ran a busy loop test program with 4, 8, 12, 16, 20, 24, 28, 32, and
64 threads. The scheduler is able to roughly scale resources at LLC
granularity.

Performance test:
* llc_gran refers to this patch set.
* The baseline is the same tree without this series, that is Linus' tree at
  0f23d56f17fd. Note that the baseline already carries CONFIG_SCHED_CACHE,
  so these numbers compare the existing single-LLC aggregation against the
  LLC-granular expansion this series adds, not against a kernel without
  cache-aware scheduling.
* Both kernels run with NUMA balancing disabled and with 'aggr_tolerance'
  set to 90, so the two aggregate under the same threshold and the
  difference reflects the code rather than the tunable.
* Each test is repeated at least 20 times; results take the average value.

To reproduce:

  # baseline
  git checkout 0f23d56f17fd
  make olddefconfig && make -j$(nproc) && install and boot it

  # llc_gran
  git am v2-00*.patch     # the 23 patches of this series
  make olddefconfig && make -j$(nproc) && install and boot it

  # on each kernel, before measuring
  echo 0  > /proc/sys/kernel/numa_balancing
  echo 90 > /sys/kernel/debug/sched/llc_balancing/aggr_tolerance

  # then
  for f in 2 4 8 12 16 20 24 32 48; do
      for g in 1 2; do
          hackbench -T -p -f $f -g $g -l 100000
      done
  done
  for t in 2 4 6 8 12 16 32 48 64 96 128; do
      schbench -m 1 -t $t -r 30
  done

The reported schbench figure is the 99.0th percentile of the Wakeup
Latencies block from the final cumulative report.

[hackbench]
(lower is better, normalized to baseline; the figure in parentheses is the
standard deviation, as a percentage of the mean)
test cmd: hackbench -T -p -f $f -g $g -l 100000

pipe   groups  baseline          llc_gran          lg improve
============================================================
2      1       1.000 (47.90%)    0.919 (3.73%)     8.094%
2      2       1.000 (58.79%)    0.799 (11.97%)    20.126%
4      1       1.000 (42.69%)    0.930 (26.53%)    6.966%
4      2       1.000 (29.86%)    0.717 (8.96%)     28.312%
8      1       1.000 (20.44%)    0.654 (7.32%)     34.613%
8      2       1.000 (11.39%)    0.711 (12.57%)    28.928%
12     1       1.000 (13.72%)    0.646 (9.45%)     35.399%
12     2       1.000 (10.97%)    0.701 (6.73%)     29.907%
16     1       1.000 (12.48%)    0.703 (7.51%)     29.711%
16     2       1.000 (5.28%)     0.728 (6.41%)     27.171%
20     1       1.000 (5.89%)     0.663 (3.76%)     33.651%
20     2       1.000 (5.47%)     0.861 (4.25%)     13.894%
24     1       1.000 (6.18%)     0.678 (2.88%)     32.167%
24     2       1.000 (6.23%)     0.942 (6.78%)     5.776%
32     1       1.000 (4.64%)     0.690 (3.70%)     31.023%
32     2       1.000 (1.51%)     1.002 (4.86%)     -0.151%
48     1       1.000 (2.08%)     0.942 (2.45%)     5.847%
48     2       1.000 (1.51%)     1.041 (2.49%)     -4.060%

llc_gran is faster at 16 of the 18 configurations, by a median of 27.7%.
The largest gains occur in the middle of the range, especially for one group
from 8 to 32 pipes; gains taper off at both ends and vary with group count.

Two configurations are slower. Only 48 pipes with 2 groups exceeds
run-to-run noise, at -4.1%; 32 pipes with 2 groups is within it.

Run-to-run variance improves at 12 of the 18 configurations, most clearly
at the small end, where the baseline reaches 30-59% against 4-27% for
llc_gran.

[schbench]
p99 wakeup latency (lower is better, normalized to baseline; the figure in
parentheses is the standard deviation, as a percentage of the mean)
test cmd: schbench -m 1 -t $threads -r 30

threads   baseline          llc_gran          lg improve
=========================================================
2         1.000 (33.11%)    0.801 (6.27%)     19.86%
4         1.000 (31.09%)    0.787 (11.43%)    21.32%
6         1.000 (21.89%)    0.832 (11.11%)    16.79%
8         1.000 (15.20%)    0.863 (14.70%)    13.72%
12        1.000 (14.23%)    0.883 (1.97%)     11.68%
16        1.000 (11.30%)    0.919 (1.21%)     8.14%
32        1.000 (12.81%)    0.784 (2.97%)     21.55%
48        1.000 (6.79%)     0.670 (3.67%)     33.02%
64        1.000 (3.04%)     0.647 (3.28%)     35.33%
96        1.000 (3.18%)     0.863 (18.11%)    13.72%
128       1.000 (4.66%)     0.952 (15.24%)    4.79%

llc_gran improves the p99 wakeup latency at all 11 thread counts, by a
median of 16.8%, and 10 of the 11 exceed run-to-run noise. The gain is
largest at 48 and 64 threads (+33.0% and +35.3%). Only 128 threads, at
+4.8%, stays within noise.

Variance improves at 8 of the 11 thread counts. It remains higher than the
baseline at 96 and 128 threads, where llc_gran runs at 15-18% against
3-5%.

The root cause of the hackbench regression at 48 pipes, and of the wider
spread in wakeup latency at high thread counts, will be investigated in
future work.

Further testing across a wider range of workloads and hardware platforms
is needed.

Jianyong Wu (23):
  sched/topology: Add llc_to_node() to translate LLC id to NUMA node
  sched/topology: Introduce a NUMA distance matrix with unique distance
    values
  sched/topology: Introduce a macro to traverse node
  sched/topology: Introduce a method to calculate the llc distance
  sched/topology: Introduce a macro to traverse LLC inside node
  sched/topology: Add sd_node for the NODE sched domain
  sched/cache: Prioritize preferred NUMA node selection over LLC
    selection
  sched/topology: Introduce a per-CPU tasks NUMA preferred counter
  sched/cache: Account percpu sd task NUMA preference
  sched/topology: Add per-sd scratch for the load balance affinity score
  sched/cache: Introduce helpers for task migration decisions
  sched/cache: Introduce rq affinity gain calculation
  sched/cache: Pick optimal src rq/group using affinity promotion metric
  sched/cache: Drop prefer_sibling restriction for llc_balance
  sched/cache: Judge migration eligibility in LLC granularity
  sched/cache: Allow un-throttled active balance to spread out of a full
    LLC
  sched/fair: Fine-granularity NUMA balancing
  sched/cache: Scan all prefer nodes in thread group
  sched/cache: Remove preferred LLC/node check no longer needed
  sched/cache: Estimate utilization of the whole thread group
  sched/cache: Spread workloads within an estimated LLC range
  sched/cache: Walk the preferred node from the preferred LLC
  sched/debug: Print task preferred LLC for scheduler debugging

 include/linux/mm_types.h       |    6 +-
 include/linux/sched.h          |    5 +
 include/linux/sched/sysctl.h   |   12 +
 include/linux/sched/topology.h |    7 +
 include/linux/topology.h       |    6 +
 kernel/sched/core.c            |   87 +++
 kernel/sched/debug.c           |   28 +-
 kernel/sched/fair.c            | 1112 +++++++++++++++++++++++++++-----
 kernel/sched/sched.h           |   49 ++
 kernel/sched/topology.c        |  873 ++++++++++++++++++++++++-
 mm/memory.c                    |    3 +
 11 files changed, 2007 insertions(+), 181 deletions(-)

-- 
2.34.1


