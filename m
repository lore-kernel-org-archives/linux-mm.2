Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C875E83EF4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 08:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0D86B008A; Wed,  4 Feb 2026 03:57:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30BC6B0092; Wed,  4 Feb 2026 03:57:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFF86B0093; Wed,  4 Feb 2026 03:57:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADBB76B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:57:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6888ABAE53
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:12 +0000 (UTC)
X-FDA: 84406169904.29.E74F441
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf18.hostedemail.com (Postfix) with ESMTP id 811F21C000E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ArjFXlFJ;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7R1aeSHBypva99D2Xvwe675IpOKqtjCqBlIFxb2GR7A=;
	b=MJ5R1aLp4SSyPw23XWuInzUs4pV4vT/93i8NaT7O79+l5YSTinB0obg//QSD97l5Uigj0W
	1NuD0HkH8xcFFOgueld9/O0i6NorVSJK+AzmDdW9zRJyDyM/dE3k6CHiFYz3e/+nwNLvtf
	KUqKyBxJQGQltCiA5L9P51xAYnD+LaA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ArjFXlFJ;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195430; a=rsa-sha256;
	cv=none;
	b=aGLDvPQngagz4hVsXLuxM6yFmrnSXWIrA//t2KsT9EGkjZ/ZoNs+YlOeLPu5b++d9Qv6TL
	E4Mrbbk7pC00O76KSn2l8cxWov7Gsc5SFwg8Bn7BvaGlYvZ0DowcZDos8kHFDwXYt9S0Mz
	++4zvtSN1ULOhRMQQaU09M+7Ozfv8jk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770195427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7R1aeSHBypva99D2Xvwe675IpOKqtjCqBlIFxb2GR7A=;
	b=ArjFXlFJzGCqR6prrobtx+MUQ2acN+dg/zVaIHBb5eQfMVLV2HpXm17wxiQMPemm60rUXa
	E8SXOT3Kjq9QjuziYWNvdizqMYMH6gmc7QqoUzNYGZtCXHbASnD38SIN8W2h3rMCJITsWD
	o0/upWppr+XK94IzxDPfsQE41nf0Zf4=
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
	JP Kobryn <inwardvessel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [RFC PATCH bpf-next v6 00/12] mm: memcontrol: Add BPF hooks for memory controller
Date: Wed,  4 Feb 2026 16:56:21 +0800
Message-ID: <cover.1770194182.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 811F21C000E
X-Stat-Signature: cwfjaa6kg8smo6tnews784gzxgsa49zd
X-Rspam-User: 
X-HE-Tag: 1770195430-669963
X-HE-Meta: U2FsdGVkX19r6M2SRnhz77c8IDCZ8g7W7ozHxVce6evQA248dZw+o0b1jSxBnIgYSRPaFwxGFNbRUaeRRecxHLcYFPCXro/6GgHsGIYG3D7UDnPieD1x2kLaE1Zzcz5Bad/PLinAt3EHVnFdW0nCuqQZ6iEWLIHEGcoYY7ZPttK9CwbSUHCl1piOLBbKqChIck/oOZw0HlBXdlwnjgmT5qWMagDWz6fadQGKtJRzRgpAnmec5niPjw4l7ny621RE2qaLWzohufPv7aIux0enPbk5/PHIs/SxxF8rRv0uf2nSFUdvv36fzqgNWjs7a3z8JhJNfMfUzoLh3d/vnEcIgyFKSdsBBZX+5kdUUGX0wi06asCJ+wxhRTbG3aQYKRmuj+lam7jdTTF4iVLZTtxsFBZC9R1Ai2efoqmKe1Tq14lXwmeDY8dR3YIuTRqkViw60B0yFcZk+M0dWjCB57NleIQOsbF1uK/aSvEfb2EI68LQmqYnQhr1ZTBR4rmQHLE+5Y+vCOdY0beAEWoTg29gHJIE0YRgmDuQFLC5ywm98BD7p2SZwjm4qKLeleZ0YSJfNdDSMxRRslG1VZtjrUd5nQtu8pob6CzGj3lSUGE6+/G2+ExYDJesUHdQdAY3og581B8OEaQEFIxHMNHO1ikPc4XYjYHpUKfZ/Xh0yL6QvMkRMWVNxJ3hNieG1RubtpjGxHgum/wcZ1BkVlArBh1ldgoR5DJdC1sK8bePy1G40TzQtEoUNcijgvYDTvzKkL3Xm5lg/KeLNppsMgctuoT9/R4RjFtsRCneAY6D5EFjhneZBERUI6ob4CSpA4rIoTSvmaQBpBQhg3RqFATMVBW57Ci+0oQ1cqIzl9MIn46hJaVJFleQk6Abw23FTM6h+eX9Zp15OJ2ysnv12Px0zs1e7X1yWgXtIZR2BnN5zNyuW0X6SzG+TRJKMjQBVmmeRy2sJHLHnqYW/O3tbPXgjjb
 v5OLSBwM
 ff5cNjf/TAIFl0ujgsCl42jpu4g/vThx1ZV8xHOGSTsWM7b/PEBYR132mliBNSmemXl3hKb2/p7TBHKXmxVYU62m1fIFWIYFJPlqh1lztyayMvg9C2MysMZX7y9Ath1m34bfIJb1iP83SfBP0DBnC2ktEW5kRrg0afVxG3RfWPC6UoM0WR6Avhjy6FunOUeiVON7qPb0jXYGI5cndf33Tb5bZB2SBDSdJ+Yucbw1nj5wUkoLtS+ox6GPl/vb46ZVntnRrZlYXMjNC750kEsmskNXf5XIQ2Jt2h/3L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Changelog:
v6:
Based on the bot+bof-ci comments, fixed the following issues.
Added fast-path check with unlikely() before SRCU lock acquisition to
optimize the no-BPF case in BPF_MEMCG_CALL.
Add missing newline in pr_warn message to bpf_memcontrol_init.
Added comprehensive child process exit status checking with WIFEXITED()
and WEXITSTATUS(), and added zombie process prevention in
real_test_memcg_ops.
Changed malloc() to calloc() for BSS data allocation in all test
functions and samples main function.
Change srcu_read_lock(&memcg_bpf_srcu) to
lockdep_assert_held(&cgroup_mutex) in function memcontrol_bpf_online
and memcontrol_bpf_offline.
v5:
Based on the bot+bof-ci comments, fixed the following issues.
Fixed issues in memcg_ops.c and memcg.bpf.c by moving variable
declaration to the beginning of need_threshold() function.
The 'u64 current_ts' variable must be declared before any
executable statements
Improved input validation in samples/bpf/memcg.c by adding a new
parse_u64() helper function. This function properly handles errors
from strtoull() and provides better error messages when parsing
threshold and over_high_ms command-line arguments.
Move check for prog->sleepable after validating member offsets in
mm/bpf_memcontrol.c bpf_memcg_ops_check_member.
Fixed sscanf return value checking in prog_tests/memcg_ops.c.
Changed the condition from 'sscanf() < 0' to 'sscanf() != 1' because
sscanf returns the number of successfully matched items, not a negative
value on error. This makes the test more reliable when reading timing
data from temporary files.
v4:
Fix the issues according to the comments from bot+bof-ci.
According to JP Kobryn's comments, move exit(0) from
real_test_memcg_ops_child_work to real_test_memcg_ops.
Fix issues in the bpf_memcg_ops_reg function.
v3:
According to the comments from Michal Koutný and Chen Ridong, update hooks
to get_high_delay_ms, below_low, below_min, handle_cgroup_online, and
handle_cgroup_offline.
According to Michal Koutný's comments, add BPF_F_ALLOW_OVERRIDE
support to memcg_bpf_ops.
v2:
According to Tejun Heo's comments, rebased on Roman Gushchin's BPF
OOM patch series [1] and added hierarchical delegation support.
According to the comments from Roman Gushchin and Michal Hocko, designed
concrete use case scenarios and provided test results.

eBPF infrastructure provides rich visibility into system performance
metrics through various tracepoints and statistics.
This patch series introduces BPF struct_ops for the memory controller.
Then the eBPF program can help the system control the memory controller
based on system performance metrics, thereby improving the utilization
of system memory resources while ensuring memory limits are respected.

The following example illustrates how memcg eBPF can improve memory
utilization in some scenarios.
The example running on x86_64 QEMU (10 CPUs, 4GB RAM), using a
file in tmpfs on the host as a swap device to reduce I/O impact.
root@ubuntu:~# cat /proc/sys/vm/swappiness
60
This the high priority memcg.
root@ubuntu:~# mkdir /sys/fs/cgroup/high
This the low priority memcg.
root@ubuntu:~# mkdir /sys/fs/cgroup/low
root@ubuntu:~# free
               total        used        free      shared  buff/cache   available
Mem:         4007276      392320     3684940         908      101476     3614956
Swap:       10485756           0    10485756

First, The following test uses memory.low to reduce the likelihood of tasks in
high-priority memory cgroups being reclaimed.
root@ubuntu:~# echo $((3 * 1024 * 1024 * 1024)) > /sys/fs/cgroup/high/memory.low
root@ubuntu:~# cgexec -g memory:low stress-ng --vm 4 --vm-keep \
--vm-bytes $((3 * 1024 * 1024 * 1024)) \
--vm-method all --seed 2025 --metrics -t 60 \
& cgexec -g memory:high stress-ng --vm 4 --vm-keep \
--vm-bytes $((3 * 1024 * 1024 * 1024)) \
--vm-method all --seed 2025 --metrics -t 60
[1] 1176
stress-ng: info:  [1177] setting to a 1 min, 0 secs run per stressor
stress-ng: info:  [1176] setting to a 1 min, 0 secs run per stressor
stress-ng: info:  [1177] dispatching hogs: 4 vm
stress-ng: info:  [1176] dispatching hogs: 4 vm
stress-ng: metrc: [1177] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [1177]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [1177] vm             27047770     60.07    217.79      8.87    450289.91      119330.63        94.34        886936
stress-ng: info:  [1177] skipped: 0
stress-ng: info:  [1177] passed: 4: vm (4)
stress-ng: info:  [1177] failed: 0
stress-ng: info:  [1177] metrics untrustworthy: 0
stress-ng: info:  [1177] successful run completed in 1 min, 0.07 secs
stress-ng: metrc: [1176] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [1176]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [1176] vm               679754     60.12     11.82     72.78     11307.18        8034.42        35.18        469884
stress-ng: info:  [1176] skipped: 0
stress-ng: info:  [1176] passed: 4: vm (4)
stress-ng: info:  [1176] failed: 0
stress-ng: info:  [1176] metrics untrustworthy: 0
stress-ng: info:  [1176] successful run completed in 1 min, 0.13 secs
[1]+  Done                    cgexec -g memory:low stress-ng --vm 4 --vm-keep --vm-bytes $((3 * 1024 * 1024 * 1024)) --vm-method all --seed 2025 --metrics -t 60


The following test continues to use memory.low to reduce the likelihood
of tasks in high-priority memory cgroups (memcg) being reclaimed.
In this scenario, a Python script within the high-priority memcg simulates
a low-load task.
As a result, the Python script's performance is not affected by memory
reclamation (as it sleeps after allocating memory).
However, the performance of stress-ng is still impacted due to
the memory.low setting.

root@ubuntu:~# cgexec -g memory:low stress-ng --vm 4 --vm-keep \
--vm-bytes $((3 * 1024 * 1024 * 1024)) \
--vm-method all --seed 2025 --metrics -t 60 \
& cgexec -g memory:high python3 -c \
"import time; a = bytearray(3*1024*1024*1024); time.sleep(62)"
[1] 1196
stress-ng: info:  [1196] setting to a 1 min, 0 secs run per stressor
stress-ng: info:  [1196] dispatching hogs: 4 vm
stress-ng: metrc: [1196] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [1196]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [1196] vm               886893     60.10     17.76     56.61     14756.92       11925.69        30.94        788676
stress-ng: info:  [1196] skipped: 0
stress-ng: info:  [1196] passed: 4: vm (4)
stress-ng: info:  [1196] failed: 0
stress-ng: info:  [1196] metrics untrustworthy: 0
stress-ng: info:  [1196] successful run completed in 1 min, 0.10 secs
[1]+  Done                    cgexec -g memory:low stress-ng --vm 4 --vm-keep --vm-bytes $((3 * 1024 * 1024 * 1024)) --vm-method all --seed 2025 --metrics -t 60
root@ubuntu:~# echo 0 > /sys/fs/cgroup/high/memory.low

Now, we switch to using the memcg eBPF program for memory priority control.
memcg is a test program added to samples/bpf in this patch series.
It loads memcg.bpf.c into the kernel.
memcg.bpf.c monitors PGFAULT events in the high-priority memory cgroup.
When the number of events triggered within one second exceeds a predefined
threshold, the eBPF hook for the memory cgroup activates its control for
one second.

The following command configures the high-priority memory cgroup to
return below_min during memory reclamation if the number of PGFAULT
events per second exceeds one.
root@ubuntu:~# ./memcg --low_path=/sys/fs/cgroup/low \
     --high_path=/sys/fs/cgroup/high \
     --threshold=1 --use_below_min
Successfully attached!

root@ubuntu:~# cgexec -g memory:low stress-ng --vm 4 --vm-keep \
--vm-bytes $((3 * 1024 * 1024 * 1024)) \
--vm-method all --seed 2025 --metrics -t 60 \
& cgexec -g memory:high stress-ng --vm 4 --vm-keep \
--vm-bytes $((3 * 1024 * 1024 * 1024)) \
--vm-method all --seed 2025 --metrics -t 60
[1] 1220
stress-ng: info:  [1220] setting to a 1 min, 0 secs run per stressor
stress-ng: info:  [1221] setting to a 1 min, 0 secs run per stressor
stress-ng: info:  [1220] dispatching hogs: 4 vm
stress-ng: info:  [1221] dispatching hogs: 4 vm
stress-ng: metrc: [1221] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [1221]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [1221] vm             24295240     60.08    221.36      7.64    404392.49      106095.60        95.29        886684
stress-ng: info:  [1221] skipped: 0
stress-ng: info:  [1221] passed: 4: vm (4)
stress-ng: info:  [1221] failed: 0
stress-ng: info:  [1221] metrics untrustworthy: 0
stress-ng: info:  [1221] successful run completed in 1 min, 0.11 secs
stress-ng: metrc: [1220] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [1220]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [1220] vm               685732     60.13     11.69     75.98     11403.88        7822.30        36.45        496496
stress-ng: info:  [1220] skipped: 0
stress-ng: info:  [1220] passed: 4: vm (4)
stress-ng: info:  [1220] failed: 0
stress-ng: info:  [1220] metrics untrustworthy: 0
stress-ng: info:  [1220] successful run completed in 1 min, 0.14 secs
[1]+  Done                    cgexec -g memory:low stress-ng --vm 4 --vm-keep --vm-bytes $((3 * 1024 * 1024 * 1024)) --vm-method all --seed 2025 --metrics -t 60

This test demonstrates that because the Python process within the
high-priority memory cgroup is sleeping after memory allocation, 
no page fault events occur.
As a result, the stress-ng process in the low-priority memory cgroup
achieves normal memory performance.
root@ubuntu:~# cgexec -g memory:low stress-ng --vm 4 --vm-keep \
--vm-bytes $((3 * 1024 * 1024 * 1024)) \
--vm-method all --seed 2025 --metrics -t 60 \
& cgexec -g memory:high python3 -c \
"import time; a = bytearray(3*1024*1024*1024); time.sleep(62)"
[1] 1238
stress-ng: info:  [1238] setting to a 1 min, 0 secs run per stressor
stress-ng: info:  [1238] dispatching hogs: 4 vm
stress-ng: metrc: [1238] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [1238]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [1238] vm             33107485     60.08    205.41     13.19    551082.91      151448.44        90.97        886064
stress-ng: info:  [1238] skipped: 0
stress-ng: info:  [1238] passed: 4: vm (4)
stress-ng: info:  [1238] failed: 0
stress-ng: info:  [1238] metrics untrustworthy: 0
stress-ng: info:  [1238] successful run completed in 1 min, 0.09 secs

In this patch series, I've incorporated a portion of Roman's patch in
[1] to ensure the entire series can be compiled cleanly with bpf-next.
I made some modifications to bpf_struct_ops_link_create
in "bpf: Pass flags in bpf_link_create for struct_ops" and
"libbpf: Support passing user-defined flags for struct_ops" to allow
the flags parameter to be passed into the kernel.
With this change, patch "mm/bpf: Add BPF_F_ALLOW_OVERRIDE support for
memcg_bpf_ops" enables BPF_F_ALLOW_OVERRIDE support for memcg_bpf_ops.

Patch "mm: memcontrol: Add BPF struct_ops for memory controller"
introduces BPF struct_ops support to the memory controller, enabling
custom and dynamic control over memory pressure. This is achieved
through a new struct_ops type, `memcg_bpf_ops`.
The `memcg_bpf_ops` struct provides the following hooks:
- `get_high_delay_ms`: Returns a custom throttling delay in
  milliseconds for a cgroup that has breached its `memory.high`
  limit. This is the primary mechanism for BPF-driven throttling.
- `below_low`: Overrides the `memory.low` protection check. If this
  hook returns true, the cgroup is considered to be protected by its
  `memory.low` setting, regardless of its actual usage.
- `below_min`: Similar to `below_low`, this overrides the `memory.min`
  protection check.
- `handle_cgroup_online`/`offline`: Callbacks invoked when a cgroup
  with an attached program comes online or goes offline, allowing for
  state management.

Patch "samples/bpf: Add memcg priority control example" introduces
the programs memcg.c and memcg.bpf.c that were used in the previous
examples.

[1] https://lore.kernel.org/lkml/20251027231727.472628-1-roman.gushchin@linux.dev/

Hui Zhu (7):
  bpf: Pass flags in bpf_link_create for struct_ops
  libbpf: Support passing user-defined flags for struct_ops
  mm: memcontrol: Add BPF struct_ops for memory controller
  selftests/bpf: Add tests for memcg_bpf_ops
  mm/bpf: Add BPF_F_ALLOW_OVERRIDE support for memcg_bpf_ops
  selftests/bpf: Add test for memcg_bpf_ops hierarchies
  samples/bpf: Add memcg priority control example

Roman Gushchin (5):
  bpf: move bpf_struct_ops_link into bpf.h
  bpf: initial support for attaching struct ops to cgroups
  bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
  mm: define mem_cgroup_get_from_ino() outside of CONFIG_SHRINKER_DEBUG
  libbpf: introduce bpf_map__attach_struct_ops_opts()

 MAINTAINERS                                   |   4 +
 include/linux/bpf.h                           |   8 +
 include/linux/memcontrol.h                    | 122 +++-
 kernel/bpf/bpf_struct_ops.c                   |  22 +-
 kernel/bpf/verifier.c                         |   5 +
 mm/bpf_memcontrol.c                           | 281 +++++++-
 mm/memcontrol.c                               |  35 +-
 samples/bpf/.gitignore                        |   1 +
 samples/bpf/Makefile                          |   8 +-
 samples/bpf/memcg.bpf.c                       | 130 ++++
 samples/bpf/memcg.c                           | 343 ++++++++++
 tools/include/uapi/linux/bpf.h                |   2 +-
 tools/lib/bpf/bpf.c                           |   8 +
 tools/lib/bpf/libbpf.c                        |  19 +-
 tools/lib/bpf/libbpf.h                        |  14 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/memcg_ops.c      | 626 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/memcg_ops.c | 130 ++++
 18 files changed, 1732 insertions(+), 27 deletions(-)
 create mode 100644 samples/bpf/memcg.bpf.c
 create mode 100644 samples/bpf/memcg.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops.c

-- 
2.43.0


