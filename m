Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4856EE9410A
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 03:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853386B0088; Mon, 29 Dec 2025 22:02:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF696B0089; Mon, 29 Dec 2025 22:02:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1C06B008A; Mon, 29 Dec 2025 22:02:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3DE6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 22:02:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8FE1C5E9B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 03:02:50 +0000 (UTC)
X-FDA: 84274640100.01.97B3052
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3BB62120008
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 03:02:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MdVuWYHU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767063769; a=rsa-sha256;
	cv=none;
	b=IQNcp3nntp7RRH7fAv/KaOfO1DB4R3I21gCmBJEoZa/ulajhxEkbO9KueuN1OAQykjyZKr
	gTELu10hc+2olsFKJDNPjDt1c2I/0+AQglQpPbn39nyOXYUv5BEyya3mLwAat7Awaz2/y9
	bmt/KcYbIbCNGfaBXNMZuHspTth4xEE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MdVuWYHU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767063769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pqmSOMk9I68wh+LqBe0FNnFTYilwTyQt9JRYBSNWNew=;
	b=0joiCpEhv32B3QwtwIpiRpW0FESefutcYftSs4UZcMUe2BoIUcczKxZrjuW/QDfWNYHgYQ
	zQdND7EN68SzoNLEuCrIoxk1F5ENexkumFEw300wkromT7Mz3qu11gpXSXGaVwXA4ptvcG
	pTS68sa1DTEZPQlWWj8gNawhbaBJFrs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767063766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pqmSOMk9I68wh+LqBe0FNnFTYilwTyQt9JRYBSNWNew=;
	b=MdVuWYHUfUZCtXsZAm8CRBrdIlaKOT4mDyDHc51JD6524QDnJeyfeqkA3Zf2SZG1UtScCq
	Bxxm34bHC5rkGc6V2irbKX8oxW37xLEQx/2Dm5juxHCbnGCgnSsflj/kfmthSa/qCCZ0KC
	kikuQG26m+J2OfUehSfDfBIp3vOEGuI=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [RFC PATCH v2 0/3] Memory Controller eBPF support
Date: Tue, 30 Dec 2025 11:01:58 +0800
Message-ID: <cover.1767012332.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3BB62120008
X-Rspamd-Server: rspam03
X-Stat-Signature: phg4nkba8c5fatcwg5ttd3qp89wj9ugo
X-Rspam-User: 
X-HE-Tag: 1767063768-386867
X-HE-Meta: U2FsdGVkX1/o/kDeXJAAadPI5vXd86kLtht/l+2cUGk882PKzsO7kLR4fPmp9rkBGrFYUhOa6oHVGqz++nAtGeR5tnnZkZcaBpt/Asd8jzvcZJ7mm4cXAodRi+UxF4sQ4bEBu40QgxmFJ1RbybEwAKUR6KeGiwb+tEASCBHmz9k/SoDbtKhbcT3gtfYSdCjED7Ixz3qi64otul1qZZuMsYo1Did8WdTN0tRh0h/qL6EuvqTzMv6rg1/LAxjMQISwQqoT2z6QDVvxMVh0VNOQ8pX8go9CWYgu/Z59/2gGOmqE3qundu0yCTawQoFb23kWwbxhV0Goss+TC/uqCtBZvX58nY2Kc1q67iVR09F+6kt+mmQ35JSSgvWErjbjnwqTtiqXGJMIGQy8DtKb1h92fafEeJIqE7/ehLIn0gXeEFZAOX41uZcQWQ2C83FBZ+/DYBd8JDxeNBXbQ87NUKZuNPgZ1SVlmO5mLtQkZskrBrwU9miEgs0eNfnDG+7wZqx4SmGnNtNz3Pkbxwr/yXkOowvA/I2dMl8hAR0o1FFOBkcDHhZuI7eJ1Md0tE5aXU1JSsdhjQ80JLnzg8uoGmSSd1PjMfJVIKdVpymkLMVyD8z0kq8P89W/ed1bjq6v5chpjXFa7+4LInf3koomPuWRkxxGq/dR/E/oyXiXB2Tw3wHdvnTKqAZqliqof4dlFhGHw1eEvEWs/n2WtR/GSMoN7aljTFq/ScHCErr50oq/VH7PH6E1gW+kb3XXnFAxAIMm3FDWY2lHWST6Wl2uCyr5I2WbZYkrtPP8RlexU98eH9Q8RkDbCBKh8XS7yw9/hYvgTGArJ7rl1RtQGOH8//L1Sz64VsWf3BN5glJMm97F45gbS0XaRCl69bu+fVtpAZyoxpW2NNR1Qxo+ZJVOyfqV9niLnCA2boK/Ye9iGKfy1KNJTFxMQTR57ReJ/tpy8gWH6HAjI5rIrOwEkISktWk
 bkCHwvcQ
 F3SoiLNMgMPJNzKaLhG4p6TVpZTmX2Lu72tOFddE1HC01gYSWp/EmJHkfMU9tsjhEsxnHCZkPpNhPHMBll9W1Wu8PiHu85eWzWilOHJGcovzviOt6FbnsDmy26uBji7nYxhyEoBDApIhPjZRV+nfTl3QTfJkXsTKhrd6t0mssvcXXxufl3a37ruECtLiP90uhDrcmkUo9fimMoExd/aE4/bUpvhxA+YnI2y2sHLy+aqkGm1Eazi0AfcLkjtbdQsqqP/vP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

This series adds BPF struct_ops support to the memory controller,
enabling dynamic control over memory pressure through the
memcg_nr_pages_over_high mechanism. This allows administrators to
suppress low-priority cgroups' memory usage based on custom
policies implemented in BPF programs.

Background and Motivation

The memory controller provides memory.high limits to throttle
cgroups exceeding their soft limit. However, the current
implementation applies the same policy across all cgroups
without considering priority or workload characteristics.

This series introduces a BPF hook that allows reporting
additional "pages over high" for specific cgroups, effectively
increasing memory pressure and throttling for lower-priority
workloads when higher-priority cgroups need resources.

Use Case: Priority-Based Memory Management

Consider a system running both latency-sensitive services and
batch processing workloads. When the high-priority service
experiences memory pressure (detected via page scan events),
the BPF program can artificially inflate the "over high" count
for low-priority cgroups, causing them to be throttled more
aggressively and freeing up memory for the critical workload.

Implementation

This series builds upon Roman Gushchin's BPF OOM patch series in [1].

The implementation adds:
1. A memcg_bpf_ops struct_ops type with memcg_nr_pages_over_high
   hook
2. Integration into memory pressure calculation paths
3. Cgroup hierarchy management (inheritance during online/offline)
4. SRCU protection for safe concurrent access

Why Not PSI?

This implementation does not use PSI for triggering, as discussed
in [2].
Instead, the sample code monitors PGSCAN events via tracepoints,
which provides more direct feedback on memory pressure.

Example Results

Testing on x86_64 QEMU (10 CPU, 4GB RAM, cache=none swap):
root@ubuntu:~# cat /proc/sys/vm/swappiness
60
root@ubuntu:~# mkdir /sys/fs/cgroup/high
root@ubuntu:~# mkdir /sys/fs/cgroup/low
root@ubuntu:~# ./memcg /sys/fs/cgroup/low /sys/fs/cgroup/high 100 1024
Successfully attached!
root@ubuntu:~# cgexec -g memory:low stress-ng --vm 4 --vm-keep --vm-bytes 80% \
--vm-method all --seed 2025 --metrics -t 60 \
& cgexec -g memory:high stress-ng --vm 4 --vm-keep --vm-bytes 80% \
--vm-method all --seed 2025 --metrics -t 60
[1] 1075
stress-ng: info:  [1075] setting to a 1 min, 0 secs run per stressor
stress-ng: info:  [1076] setting to a 1 min, 0 secs run per stressor
stress-ng: info:  [1075] dispatching hogs: 4 vm
stress-ng: info:  [1076] dispatching hogs: 4 vm
stress-ng: metrc: [1076] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [1076]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [1076] vm             21033377     60.47    158.04      3.66    347825.55      130076.67        66.85        834836
stress-ng: info:  [1076] skipped: 0
stress-ng: info:  [1076] passed: 4: vm (4)
stress-ng: info:  [1076] failed: 0
stress-ng: info:  [1076] metrics untrustworthy: 0
stress-ng: info:  [1076] successful run completed in 1 min, 0.72 secs
root@ubuntu:~# stress-ng: metrc: [1075] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [1075]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [1075] vm                11568     65.05      0.00      0.21       177.83       56123.74         0.08          3200
stress-ng: info:  [1075] skipped: 0
stress-ng: info:  [1075] passed: 4: vm (4)
stress-ng: info:  [1075] failed: 0
stress-ng: info:  [1075] metrics untrustworthy: 0
stress-ng: info:  [1075] successful run completed in 1 min, 5.06 secs

Results show the low-priority cgroup (/sys/fs/cgroup/low) was
significantly throttled:
- High-priority cgroup: 21,033,377 bogo ops at 347,825 ops/s
- Low-priority cgroup: 11,568 bogo ops at 177 ops/s

The stress-ng process in the low-priority cgroup experienced a
~99.9% slowdown in memory operations compared to the
high-priority cgroup, demonstrating effective priority
enforcement through BPF-controlled memory pressure.

Patch Overview

PATCH 1/3: Core kernel implementation
  - Adds memcg_bpf_ops struct_ops support
  - Implements cgroup lifecycle management
  - Integrates hook into pressure calculation

PATCH 2/3: Selftest suite
  - Validates attach/detach behavior
  - Tests hierarchy inheritance
  - Verifies throttling effectiveness

PATCH 3/3: Sample programs
  - Demonstrates PGSCAN-based triggering
  - Shows priority-based throttling
  - Provides reference implementation

Changelog:
v2:
According to the comments of Tejun Heo, rebased on Roman Gushchin's BPF
OOM patch series [1] and added hierarchical delegation support.
According to the comments of Roman Gushchin and Michal Hocko, Designed
concrete use case scenarios and provided test results.

[1] https://lore.kernel.org/lkml/20251027231727.472628-1-roman.gushchin@linux.dev/
[2] https://lore.kernel.org/lkml/1d9a162605a3f32ac215430131f7745488deaa34@linux.dev/

Hui Zhu (3):
  mm: memcontrol: Add BPF struct_ops for memory  pressure control
  selftests/bpf: Add tests for memcg_bpf_ops
  samples/bpf: Add memcg priority control example

 MAINTAINERS                                   |   5 +
 include/linux/memcontrol.h                    |   2 +
 mm/bpf_memcontrol.c                           | 241 ++++++++++++-
 mm/bpf_memcontrol.h                           |  73 ++++
 mm/memcontrol.c                               |  27 +-
 samples/bpf/.gitignore                        |   1 +
 samples/bpf/Makefile                          |   9 +-
 samples/bpf/memcg.bpf.c                       |  95 +++++
 samples/bpf/memcg.c                           | 204 +++++++++++
 .../selftests/bpf/prog_tests/memcg_ops.c      | 340 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_ops_over_high.c |  95 +++++
 11 files changed, 1082 insertions(+), 10 deletions(-)
 create mode 100644 mm/bpf_memcontrol.h
 create mode 100644 samples/bpf/memcg.bpf.c
 create mode 100644 samples/bpf/memcg.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_over_high.c

-- 
2.43.0


