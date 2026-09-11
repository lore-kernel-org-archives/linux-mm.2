Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04614C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 02:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE0D6B008A; Thu, 10 Sep 2026 22:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9EE96B008C; Thu, 10 Sep 2026 22:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D536B0092; Thu, 10 Sep 2026 22:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 755276B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:21:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D542A55FB
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:21:11 +0000 (UTC)
X-FDA: 85199879142.05.006A0A0
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1081614000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:21:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vwn2jRiV;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789093269;
	b=t45ydg8I3HTGypxnuW3L54KHzJqY3wSFvi6T5k4dccIUxbe5mYDiZWbrudVmILVecuZgrP
	WsO2WjCaX9W/nzAuZdNPDODCrlBSmuOCeoyP4zNLwCEvXNEcZnof++si5DndevUf+RIdKW
	+9NyZy6Eo225uYF1qbMHfQFSG20Taso=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vwn2jRiV;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789093269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TJF0+qQ/JNMyjKn+t/3th+Ab+NXCRkE52fy+SB+MOlc=;
	b=R8vhLZCFXShn00yxmf3sIescpB3N0Q6qTTKCmrO83udqbrY8bWSVV61Bv+SxUOhalMusB7
	2D/st8VkpJmLERTxhzrPQiiKYHDNZT+uinT7dDfsQKuXng0yeSt5vR/YXRs97ZUNQ1cZ1c
	IGQzkfwHNYoyYgF6G6O6Dtem4tW0aqw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5/1w47pt+5M6oOZ6KogOUzOV3aVzd9z+Eh9KVmbPDK0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789093264; v=1; x=1789698064;
 b=Vwn2jRiVlNaVbpcOqQcQidYNNWL/S+iwEdLPSW+pZebShAYYNOaAjx7GhmdxHDXpHOsNU7U1
 gog9zhSwADXU9v7zTJkmv77A6zqHIwQ0NYa4igJ60kaC2xSDE5Xd7f4QmmKfMt7SxQfWpOg2hpr
 WO50PVWtUokaUgASermFONEc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e20d4b384e4f25b3;
	Fri, 11 Sep 2026 02:21:03 +0000
X-Mizu-Trace-ID: e20d4b384e4f25b3
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next v10 0/2] bpf: BPF-driven proactive memcg reclaim
Date: Fri, 11 Sep 2026 10:20:43 +0800
Message-ID: <cover.1789091855.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1081614000A
X-Stat-Signature: ngwte1zdcuamp5oj9pzxhnganmmuobsq
X-Rspam-User: 
X-HE-Tag: 1789093268-21418
X-HE-Meta: U2FsdGVkX1/87y7jz7Fpc/5rLGBbvbQtuFxQ9LDg7iwvc3TgWubpdR35N0Q3iwFS4uJmajhNizO7B3WCJh2PU/fH9ppVz473Ms9uXzHvtIskS/gQo50TsEQSb+jM8i7Vfb0T4qZkNCSLkDoeZmMjScV7GNcAXe2tx3v4CHNGoPFFsg3PIgNj4gXTtyq8E4hE70jHyVWJnmminK6K7c5k3ZhiwZ2W02SRl0sRKnLJDvGvo9DPoGcIasg5s7n+i80u2yDCd4pFLGAK1cMv5b2Kt2kUfOIDNDMMjtjlrivngG94MW6NqjLBCur+TYIkWuaaiHeHdWe872aqKTyu/gOXC4pdZvwIVH2EfKmvAGxFCuckJAq+txP90M7kB+OkkDkSuxcmVXC9jfBFs/7LqUsIP6NbW1pl6cdKTrfvZ17D1Q5rt6NZXtg93dmFhqeqcqdtk19MttoXYddRjyMnnMEiHb20yEjWHao0wYL8DCiz9JGZm8NrJbp7yFtW9IcR+KRYXhCZz9WuYJx6fc5IB2gEBZoWUpWgr9/kD5fhvc/CmtNQALri9MdFqxDIVm+9n3i2sVL3EIRF+w+3YbiAaFT4MFS17j2Ou93+qZgUuMhJ6QwVcdFTJQeRpsXLxDLsdxDPlTJYwPwzwVp/rBwQqsOcnjnfH7z5hyZemwgpOT7MwE/+w0ECTfjfsmbq5lC+Hvu0w1sqtB4FxB8Y7r37u5RXglpliNIwTJS3nE2GMzP032zdEzhxc6SKHjEUg+IHErbYv15MvM4UqsIKMU7g8DoepHTDRefGcONM5pxtpiKpYJrqtcNvyIwR2siWQH+VWqhts+jO2l46uEUtsOKIb70J+iZ4lL6V9TkaIYx6VJXgFMUceOwKy3ijgFrqEY70lfXpg+uIRqH2ULwtITCug0m1SSwYwlDvpSNhfSICRyvruKktGKTRpFKWMOljZrL4Z23qmp6QSdgtz+1hzkut/y1
 v0BZtJeX
 vlyIzlIkwWuFG/rzdmXX8ylpGd5jQ5EF/lRK1gLmgXmOD5DCV8QNB0xVepFTO9TWCcg9ccAY11BtzrcbgE/e1/i5Kikeq5EzAQIrFAdhN7U+uGzGRILPtkDraqDeZFsNVoQu0x+mazjpp2ovbfQmZ1ZaEuGCYM/i0ZMf2zX79Bv8Fjv294llOdXaIxUME68whCis9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

BPF programs can observe memory pressure on a cgroup (e.g. refault
stats via bpf_mem_cgroup_page_state()), but cannot act on it:
triggering reclaim on a chosen cgroup requires writing to
memory.reclaim, which BPF cannot do. This series adds
bpf_proactive_reclaim(), a sleepable kfunc performing one proactive
reclaim pass on a target memcg, so when and how hard to reclaim is
BPF policy rather than hard-coded thresholds.

The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
always runs in a clean process context: generic sleepable programs
may execute with filesystem locks held or in NOFS/NOIO contexts,
where the reclaim path could deadlock in filesystem shrinkers. The
bpf_wq and task_work callbacks of a SYSCALL program keep its program
type and run in process context, so reclaim work can still be queued
asynchronously through them, as the selftest does with bpf_wq.

The use case we are looking at is protecting high-priority workloads:
a BPF program monitors the state of a high-priority cgroup and, when
it degrades (e.g. PSI rises or refaults increase, as in the
selftest), asynchronously reclaims memory from low-priority cgroups
via bpf_wq and bpf_proactive_reclaim(), giving the pressured cgroup
more free pages.

Another use case: several vendor-maintained kernels carry private
implementations that trigger asynchronous reclaim when a memcg enters
a certain state. These exist for historical and partly psychological
reasons, but the underlying demand is real. We expect BPF-driven
proactive reclaim, combined with the BPF hooks for the memory
controller currently under discussion and development, to serve these
needs in mainline, reducing kernel fragmentation and improving kernel
maintainability.

Benchmark numbers from the selftest (TEST_MEMCG_ASYNC_RECLAIM_BENCH=1
runs the workload once without the BPF program and once with it; QEMU
VM with 8 GiB RAM and 10 vCPUs, 10 runs): the pressured workload
finishes in a median of 2.1s with BPF-driven async reclaim versus
12.0s without, a 51%-90% improvement per run. The harvested workload
shares the parent's memory.max with it and finishes in a median of
5.1s versus 9.7s, as it has the limit to itself once the pressured
workload finishes early.

Raw benchmark output of the 10 runs (one line per run, all passed):
memcg_async_reclaim: baseline high=4.081880 low=8.951780, reclaim high=2.000056 low=10.872397, high speedup=51.0%
memcg_async_reclaim: baseline high=15.803050 low=14.594268, reclaim high=1.567874 low=4.848877, high speedup=90.1%
memcg_async_reclaim: baseline high=5.222607 low=4.076494, reclaim high=2.188346 low=3.922446, high speedup=58.1%
memcg_async_reclaim: baseline high=11.556587 low=3.222517, reclaim high=2.325903 low=5.303031, high speedup=79.9%
memcg_async_reclaim: baseline high=14.481044 low=10.517298, reclaim high=2.309609 low=7.884620, high speedup=84.1%
memcg_async_reclaim: baseline high=9.737340 low=2.876915, reclaim high=1.815853 low=9.379357, high speedup=81.4%
memcg_async_reclaim: baseline high=16.290141 low=17.152739, reclaim high=1.649337 low=4.978743, high speedup=89.9%
memcg_async_reclaim: baseline high=5.176590 low=4.858071, reclaim high=2.356344 low=5.971522, high speedup=54.5%
memcg_async_reclaim: baseline high=12.444925 low=13.305078, reclaim high=1.973012 low=4.261413, high speedup=84.1%
memcg_async_reclaim: baseline high=16.213717 low=12.608334, reclaim high=2.207762 low=4.317123, high speedup=86.4%

Changelog:
v10:
According to the comments of JP, drop redundant swap.h include, turn
swappiness macros into a BTF-visible enum, and clarify the -1 swappiness
semantics in docs and code in code patch.
report each reclaim outcome via ringbuf and wait for events with timeout
instead of sleep-polling, log workload timings instead of failing on
them, drop a debug printf, and add a TEST_MEMCG_ASYNC_RECLAIM_BENCH
baseline-comparison mode in the selftests patch.
Include the benchmark numbers in the cover letter.
v9:
According to the comments of JP, copy the motivation from the cover
letter to the commit message, restructure the kfunc documentation
to separate the direct and asynchronous calling contexts, fold the
fs-lock warning into the SYSCALL-only rationale, soften the "bounded
unit of work" wording (only the reclaim target is capped), and drop
the redundant comment above the reclaim kfunc set registration.
v8:
According to the comments of Andrew, Kumar and Shakeel, drop the
bpf_in_reclaim_context() check because the SYSCALL-only restriction
already rules out reentrancy.
According to the comments of Kumar, Add the swappiness argument to
bpf_proactive_reclaim().
v7:
According to the comments of JP, clamp the reclaim target of one
bpf_proactive_reclaim() call to MEMCG_CHARGE_BATCH so each call is
a bounded unit of work, and document the batching policy in the kfunc.
selftest: check the target cgroup for dying state before reclaiming
from it, and add the memcg_async_reclaim_dying test covering target
removal while reclaim is running.
v6:
According to the comments of Kumar and Shakeel, Restrict
bpf_proactive_reclaim() to BPF_PROG_TYPE_SYSCALL by moving it
to a dedicated kfunc set registered for that program type only, and
document the clean-process-context requirement in its kerneldoc.
v5:
According to the comments of Andrii, Kumar and Shakeel, remove
bpf_proactive_reclaim_swappiness.
v4:
According to the comments of bot+bpf-ci and sashiko, also check
current->reclaim_state to close the fentry-on-trace-iter recursion
window in bpf_in_reclaim_context.
Return bytes instead of pages ( nr * PAGE_SIZE ) in
bpf_proactive_reclaim_pages and bpf_proactive_reclaim_swappiness.
Return (unsigned long)-1 on out-of-range swappiness (was 0).
Kdoc of both kfuncs: updated Return descriptions; added FS-lock deadlock
warning to bpf_proactive_reclaim.
Fix potential child process leak in selftests.
Use _exit() instead of exit() in forked children in selftests.
Rename reclaimed_pages to reclaimed_bytes in selftests.
Fix comments issues in selftests.
v3:
According to the comments of bot+bpf-ci, add a shared helper
bpf_proactive_reclaim_pages() that is called by bpf_proactive_reclaim
and bpf_proactive_reclaim_swappiness.
According to the comments of sashiko and bot+bpf-ci, fix the issues of
selftests.
v2:
According to the comments of Shakeel Butt, replace
bpf_try_to_free_mem_cgroup_pages() with
bpf_proactive_reclaim(memcg, size) and
bpf_proactive_reclaim_swappiness(memcg, size, swappiness).
According to the comments of Kumar Kartikeya Dwivedi, drop patch 2
and patch 3.
Remove bpf_thread_wq code in patch 4.
According to the comments of sashiko-bot, fix the issues of selftests.

Hui Zhu (2):
  mm/bpf: Add bpf_proactive_reclaim kfunc
  selftests/bpf: Add memcg async reclaim test

 mm/bpf_memcontrol.c                           |  88 +-
 mm/internal.h                                 |  10 +-
 .../bpf/prog_tests/memcg_async_reclaim.c      | 779 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 288 +++++++
 4 files changed, 1160 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

-- 
2.43.0


