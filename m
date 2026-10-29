Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1FB606A320
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FBF76B05B1; Wed, 28 Oct 2026 22:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ACC26B05B3; Wed, 28 Oct 2026 22:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C256B05B4; Wed, 28 Oct 2026 22:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB7446B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:25:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D45E1201E4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:25:10 +0000 (UTC)
X-FDA: 85374071580.20.5BDB423
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf14.hostedemail.com (Postfix) with ESMTP id DB337100002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:25:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793240708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=59Lj9v7zWsymBbyhV8+zB+AHvLj/ADjVo5H7WhOhsVI=;
	b=lPomTvPfxnQTnAffhhC+8DPmpDMTqMU9Se3Pjjeu4DFu1rlVxg1CyUkGbtlq6IoPq3EV0F
	t01PfB3EIje/HNNleYELKtjFS8pEscChnsYPU8MlahDJcn6ZWkUbkn+MxQYFggR34MVqz0
	+cC4np18P6EWFSnmvdXaWN0P3h6LBSM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793240708;
	b=Ix1hcbx0Y7xV6R3XTb/muM1A5/Imo66Z2icCSk1zDUrjxKkQ0qtyIt0mbbn94geFMlLBhJ
	5bhXBku5oWBTweubT5cFyqaD4KnwdAskoETxgfs1TQg+Vo2v7fA0Q042s801MblP9+pKPe
	qbRYak+H16X7OJryhBmnLxLp19RkyEo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSk36sClz171YY;
	Thu, 29 Oct 2026 10:24:59 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSk30s5rz171YY;
	Thu, 29 Oct 2026 10:24:59 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 482415943;
	Thu, 29 Oct 2026 10:24:52 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:24:57 +0800
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
 Hildenbrand <david@kernel.org>, <maddy@linux.ibm.com>, Michael Ellerman
	<mpe@ellerman.id.au>, <ljs@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>
Subject: [RFC PATCH v3 00/17] sched: Scale cache-aware aggregation at LLC granularity
Date: Thu, 29 Oct 2026 10:20:18 +0800
Message-ID: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB337100002
X-Stat-Signature: imcid3er3otpo81a9ja8sokzkd589qwj
X-Rspam-User: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793240706-758277
X-HE-Meta: U2FsdGVkX18C19HZ9JCXadKBI45rOOriX8V3kX+B4Up6FhSPNe9Med/imiHgmqN6VRqHt6hbNmJR5yoI7gYGQDTeUoitbgO911ZMNs4h5GaXw9c+0nweRzacnqRcWDjuIyuMEwOpgRnC3tof/ARrbJTmcTGawuKPcfF3PYiwRE7yX2skO/+Fd35xosHgt49yE/FKWX3iIfOBzgZOTetXS1RyqPljatHhb9ilKdYpjuTZfD4fDuu/RIXJpGM9DLLSa6AOxzYtpIgXR+D63lu9Lye7WnTHiGDY3o/J80rjwsE1G8B5H65cNhyi4ph+u7k86esErQnNudCi0CKL+ehF/T/XRMxb9IyRxB71aFjU4KwvUhrvysPn9epd7wz0zlom4CqVMTGwpv2b7o2cDhhreKfUOvSa6fUWGcpkG22UdM/zinpJ6/nF0Lxlbm+ZWlCIQ2U77zZbNkQfHGUZ6B8dNJbMWGxguycJZaQ04PTAJifaua623u6rDR/9vYyWOGrtGpTOp6/03P2LLDp5yao27PnUlHx6ecNo6SBEPZSJlQRSTTiGUleoiM9SA2RLWKm2S3SXtS8sGwdhsKXw8bYaB5Q9SJ7dh12NeYZkrhaWYWRWmAeeE8EX0jLJ/Tk0WI4BWoGTzJfkfOR1YQW6g1t4RNX6mXKmoXtzrBNN8YZRy5S7ybDaL1sBN8tsKzB+2kmNqD7ibzBtaagAly5NwrhttSjm3+P4Z+4QC6bgILzjJ3Wgn0pSVlykzSN0g8aUxXbXz0m3xJtBnfqM/fjxJ8Y6yCxTi0H6aW7nt89QRB4XWxSEtMb4m6rQ4XMLhJ9DYMPUZemYNthDl/fIWAxuTKpHbkftQrm9aQ3t8q18n/23L01Hq1KXS99pVRq6f+mC7Lrh3aYAI5dEzql6A0+u4KB9FqzzWPXdruo481EgM8hvu0DeNXRtr6FSe6LF+PLcYo7k4tIUqZwbZieY1XyspnA
 8/vxZrDv
 UEy47v6ZobnppmTwfc+e94epy3aOGL4xIbGomFeddXJ8tGCHKiL88NzauH4Sc2NAbJcBgFtl6Riy/7ENVRxyvRt3QOHtraE/SA3Ybs0WpZ7uKGaLpsb8UEby6o6t4WoYH8A/Ooegx+D3vmpvn6ir0X3EUNJIbJDaRbMVtuTi8Rzu4fFxubXPY++k5RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[Problem Statement]
The current cache-aware scheduling implementation adopts an
LLC-centric task aggregation model. While effective for workloads
that fit within a single LLC domain, this design is fundamentally
limited by its fixed aggregation scope and cannot scale across LLCs. This
is especially important for systems with a large number of NUMA nodes and
LLCs. On such systems an LLC can be small, e.g. only 4 cores, so
aggregating threads into a single LLC does not help much.

Aggregating threads across LLCs and NUMA nodes can reduce cache-to-cache
communication latency. If memory placement follows the threads, it can
also reduce remote memory access latency and improve effective bandwidth.

[Proposal]
There are several ways to scale the load, e.g. along sched domain
boundaries, NUMA nodes or LLCs. Peter Zijlstra suggested scaling resources
at LLC granularity, and this patch set implements this idea.

To achieve this goal, the first question is: once the preferred LLC is
saturated, which LLC should take the extra load? For a system with more
than one NUMA node, the node distance can give us a rough answer. Once the
NUMA node that contains the preferred LLC, which we can call the
cache-preferred node, is saturated, choose the node with the least node
distance as the next node to aggregate threads on. The open question is
how to break the tie when more than one NUMA node shares the same node
distance, and the same question arises for intra-node LLCs.

This patchset uses triangular numbers to break the tie at the node level
and the LLC level; patch 2 gives the details. We can build the LLC
affinity sequence in two levels: the node level, which follows the node
distance and also uses triangular numbers to break the tie, and the LLC
level, which uses triangular numbers only for the cache-preferred node and
uses just the LLC ID for LLCs across nodes. The sequence for each LLC is
fixed as long as the CPU topology is unchanged and is prepared at system
initialization time.

Based on this LLC affinity sequence, we can aggregate threads in the load
balance part. It can be split into two steps:
1. find the right source group or rq to give the most affinity
   improvement. An affinity gain is calculated here as the criterion,
   since we are not only concerned about the single preferred LLC;
2. replace can_migrate_llc() with can_migrate_llcs() to support the
   migration check for migration across LLCs.

Working with NUMA Balancing is the hard part. This patchset changes the
way to select the preferred LLC among all the effective preferred NUMA
nodes of all threads inside the group, to reduce contention and make the
preferred LLC stable. It also relieves some migration limitations that
were tied to the preferred NUMA node. However, it's not enough and the
issue is not completely resolved yet. For example, a task with a preferred
NUMA node that is not in the range of the thread aggregation may wander
around, as it respects NUMA Balancing prior to cache-aware scheduling.

Changes since v2:
(1) Drop the artificial node distance and LLC distance and use
    triangular numbers to build the LLC affinity sequence instead. The
    affinity gain calculation is changed accordingly to use only the raw
    node distance as the weight; otherwise the weight is 1.
(2) Simplify the thread migration decision policy.
(3) Drop the load utilization estimation as the aggregation range for
    simplicity.
(4) No longer limit the task migration functionality of NUMA Balancing,
    and drop the tunable added in v2 for it.
(5) Address other review comments on v2.

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

v2: https://lore.kernel.org/all/20260827122816.756234-1-wujianyong@hygon.cn/
v1: https://lore.kernel.org/all/20260625030759.25928-1-wujianyong@hygon.cn/

[Testing]

The baseline kernel is 0f23d56f17fd. On each machine, the baseline and
llc_gran kernels used the same boot command line. NUMA balancing was
disabled.

Testing was done on both Hygon and Intel systems.

Test on Hygon machine:

Hygon machine with the following topology:
* 2 sockets
* 4 NUMA nodes per socket
* 4 LLCs per NUMA node
* 4 cores per LLC domain
* 2 SMT threads per core

Functional test:
aggr_tolerance=90

Ran a busy loop test program with 4, 8, 12, 16, 20, 24, 28, 32, 64, 96,
128 threads. The scheduler is able to scale resources at LLC granularity.

Performance test:
aggr_tolerance=30. With this setting, cache-aware scheduling detects
workloads whose load exceeds about 100 CPUs and gives up aggregating
them, leaving their placement to the generic load balancer.

hackbench:
(lower is better, normalized to baseline; the figure in parentheses
is the standard deviation, as a percentage of the mean)
test cmd: hackbench -T -p -f $f -g $g -l 100000
Each configuration was run 10 times.

fds    groups  baseline          llc_gran          lg improve
=============================================================
2      1       1.000 (22.88%)    0.961 (6.80%)          3.92%
2      2       1.000 (58.74%)    1.018 (16.30%)        -1.79%
4      1       1.000 (56.23%)    0.732 (15.58%)        26.79%
4      2       1.000 (19.70%)    0.611 (13.99%)        38.92%
8      1       1.000 (20.86%)    0.581 (7.84%)         41.87%
8      2       1.000 (8.65%)     0.662 (9.03%)         33.82%
12     1       1.000 (13.33%)    0.658 (8.98%)         34.24%
12     2       1.000 (8.03%)     0.726 (3.47%)         27.42%
16     1       1.000 (10.21%)    0.684 (5.55%)         31.64%
16     2       1.000 (5.60%)     0.800 (2.80%)         20.02%
20     1       1.000 (7.44%)     0.719 (4.88%)         28.07%
20     2       1.000 (2.72%)     0.890 (3.72%)         10.99%
24     1       1.000 (6.05%)     0.759 (6.27%)         24.07%
24     2       1.000 (5.07%)     0.935 (4.41%)          6.54%
32     1       1.000 (2.61%)     0.813 (7.51%)         18.71%
32     2       1.000 (2.95%)     0.990 (5.07%)          0.97%
48     1       1.000 (3.33%)     1.020 (1.73%)         -2.01%
48     2       1.000 (3.65%)     1.069 (3.50%)         -6.90%

schbench:
p99 wakeup latency (lower is better, normalized to baseline; the figure
in parentheses is the standard deviation, as a percentage of the mean)
test cmd: schbench -m 1 -t $threads -r 30 -w 5 -i 100
Each thread count was run 10 times.

threads   baseline          llc_gran          lg improve
========================================================
2         1.000 (4.60%)     0.888 (8.11%)         11.18%
4         1.000 (50.00%)    0.538 (6.43%)         46.15%
6         1.000 (59.38%)    0.676 (25.71%)        32.37%
8         1.000 (15.89%)    0.332 (31.26%)        66.81%
12        1.000 (25.56%)    0.375 (19.52%)        62.50%
16        1.000 (33.80%)    0.326 (14.20%)        67.41%
32        1.000 (33.04%)    0.198 (5.48%)         80.23%
48        1.000 (59.48%)    0.199 (2.47%)         80.15%
64        1.000 (44.07%)    0.525 (6.82%)         47.52%
96        1.000 (2.43%)     0.665 (4.78%)         33.53%
128       1.000 (9.60%)     0.709 (15.49%)        29.07%

The baseline sometimes spreads threads across sockets, which may
contribute to its high p99 latency. Across the ten runs, llc_gran has
lower run-to-run variation of the reported p99 in 7 of the 11 cases.

llc_gran improves the p99 wakeup latency at all 11 thread counts. The
largest reductions are at 32 and 48 threads, both around 80%.

hackbench improves in most configurations, with regressions at 48
fds for both group counts.

Test on Intel machine:

Intel Xeon Platinum 8592+ machine with the following topology:
* 2 sockets
* 2 sub-NUMA nodes per socket
* 1 LLC per socket, shared by its 2 sub-NUMA nodes
* 32 cores per sub-NUMA node
* 2 SMT threads per core

Functional test:
aggr_tolerance=90

Ran a busy loop test program with 4, 8, 12, 16, 20, 24, 28, 32, 64, 96,
128 threads. The scheduler is able to scale resources at sub-NUMA
granularity.

Performance test:
aggr_tolerance=4. With this setting, cache-aware scheduling detects
workloads whose load exceeds about 100 CPUs and gives up aggregating
them, leaving their placement to the generic load balancer.

hackbench:
(lower is better, normalized to baseline; the figure in parentheses
is the standard deviation, as a percentage of the mean)
test cmd: hackbench -T -p -f $f -g $g -l 100000
Each configuration was run 10 times.

fds    groups  baseline          llc_gran          lg improve
=============================================================
2      1       1.000 (1.22%)     1.006 (1.10%)         -0.56%
2      2       1.000 (2.84%)     0.989 (1.17%)          1.09%
4      1       1.000 (1.17%)     1.000 (1.33%)          0.03%
4      2       1.000 (3.40%)     0.985 (1.92%)          1.53%
8      1       1.000 (2.75%)     0.988 (0.74%)          1.23%
8      2       1.000 (2.48%)     0.954 (0.66%)          4.56%
12     1       1.000 (3.88%)     0.907 (0.39%)          9.26%
12     2       1.000 (5.99%)     0.964 (2.31%)          3.62%
16     1       1.000 (0.34%)     0.981 (0.31%)          1.90%
16     2       1.000 (13.26%)    0.891 (3.06%)         10.92%
20     1       1.000 (12.67%)    0.873 (0.68%)         12.65%
20     2       1.000 (14.32%)    0.739 (1.71%)         26.12%
24     1       1.000 (4.02%)     1.079 (1.88%)         -7.94%
24     2       1.000 (20.92%)    0.861 (5.47%)         13.95%
32     1       1.000 (15.59%)    0.934 (8.75%)          6.65%
32     2       1.000 (7.64%)     0.905 (6.66%)          9.54%
48     1       1.000 (22.96%)    0.846 (3.41%)         15.45%
48     2       1.000 (4.26%)     1.026 (3.49%)         -2.62%

schbench:
p99 wakeup latency (lower is better, normalized to baseline; the figure
in parentheses is the standard deviation, as a percentage of the mean)
test cmd: schbench -m 1 -t $threads -w 5 -i 100 -r 30
Each thread count was run 10 times.

threads   baseline          llc_gran          lg improve
========================================================
4         1.000 (20.56%)    0.882 (0.00%)         11.76%
8         1.000 (28.63%)    0.811 (0.00%)         18.92%
16        1.000 (28.63%)    0.811 (0.00%)         18.92%
32        1.000 (19.76%)    0.938 (0.00%)          6.25%
48        1.000 (15.70%)    0.930 (0.00%)          6.98%
64        1.000 (23.42%)    0.625 (11.71%)        37.50%
96        1.000 (12.80%)    0.893 (7.03%)         10.71%
128       1.000 (23.37%)    1.185 (30.09%)       -18.48%

For 4, 8, 16, 32 and 48 threads, all 10 runs reported the same rounded
p99 within each case. This shows stable p99 across repeated runs at
microsecond resolution.
Overall, llc_gran reduces run-to-run p99 variation in 7 of the 8 cases.

In schbench, 128 threads show an 18.48% regression and larger run-to-run
p99 variation.

hackbench improves in 15 of the 18 configurations, by up to 26.12% at
fds=20, groups=2. With 2 to 8 fds, the results stay within about 1.5% of
the baseline, except for a 4.56% improvement at fds=8, groups=2. The
regressions are at fds=24, groups=1 (7.94%), fds=48, groups=2 (2.62%)
and fds=2, groups=1 (0.56%). llc_gran also has lower run-to-run
variation in 17 of the 18 configurations.

The regressions in both tests need further investigation.

The baseline did not consistently aggregate threads within a single LLC
in these tests. This may have contributed to its higher latency; the
cause needs further investigation.

Jianyong Wu (17):
  sched/topology: Add llc_to_node() to translate LLC ID to NUMA node
  sched/topology: Build NUMA node affinity sequences
  sched/topology: Add an iterator for cached NUMA node affinity rows
  sched/topology: Build triangular affinity orders for LLCs in a node
  sched/topology: Walk LLCs in NUMA node
  sched/cache: Prioritize cache-preferred node selection over LLC
    selection
  sched/topology: Add per-sd scratch for cache-aware load balancing
  sched/cache: Introduce helpers for task migration decisions
  sched/cache: Introduce rq affinity gain calculation
  sched/cache: Pick the source rq/group with the highest affinity gain
  sched/cache: Drop prefer_sibling restriction for llc_balance
  sched/cache: Apply multi-LLC aggregation policy to task migration
  sched/cache: Allow active balance to spread load from a full LLC
  sched/cache: Consider LLC load when selecting a single-task source rq
  sched/cache: Include recently used preferred nodes in LLC scans
  sched/cache: Drop stale preferred LLC checks
  sched/debug: Show cache placement and preferred LLC in
    /proc/<pid>/sched

 arch/powerpc/mm/numa.c         |   4 +
 include/linux/mm_types.h       |   6 +-
 include/linux/sched.h          |   1 +
 include/linux/sched/topology.h |   7 +
 include/linux/topology.h       |  11 +
 kernel/sched/core.c            |   1 +
 kernel/sched/debug.c           |  28 +-
 kernel/sched/fair.c            | 883 ++++++++++++++++++++++++++-------
 kernel/sched/sched.h           |  97 ++++
 kernel/sched/topology.c        | 538 +++++++++++++++++++-
 10 files changed, 1400 insertions(+), 176 deletions(-)


base-commit: 0f23d56f17fdfc7db69d51f64c8b91bbab947aa9
-- 
2.34.1



