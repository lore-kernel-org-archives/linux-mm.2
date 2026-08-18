Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBA3C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:36:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E89B6B015C; Tue, 18 Aug 2026 04:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2056B015D; Tue, 18 Aug 2026 04:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D71F6B015F; Tue, 18 Aug 2026 04:36:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EDD66B015C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:36:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C118A37A4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:36:50 +0000 (UTC)
X-FDA: 85113734580.15.5006489
Received: from mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9373C100003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:36:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sLQI6aE0;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787042209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i/wy3CaIB8OLl7dom4EY144fiw3K3rKFYy6pZJCsIgM=;
	b=HFpmbK0fX/L4983f9SzkO36IyMnNNHZq83Iy6OCtgHRzPptboTGDnNHqwm0uNBuMNJUwau
	vA4bhAixB/pnyb09Q927F9H2CkzKh99kQAF5R72JyYdttMMNIA6yzkmeoKTnwI+FHbdmzn
	D7eHg8wVLYy3ruJ0UFWEFdA0uag+zqg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sLQI6aE0;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787042209;
	b=R2xKA6s1Z2NmmfLzm30WNksA3l79elD2ADr7tueiL4Ur1//mCB4NEDmn+NtU0CuqyvtPXq
	l92fyRE+VJhMxW4TuC4anREwE12NhMREk6Vg3uxXX8aGV8HOqMpofdlRZ5q2ZfQGeRSzHV
	+W1KYy/CWqmldWyPO4V9uE3822UomTA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HPHzCQscpPNT0QBxW0BqZAv2GHNpNMRHwv8jkG96UoA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787042206; v=1; x=1787647006;
 b=sLQI6aE0piWRIxqdVw8jynybjee27SP7FE2q2qTk6MTY749kqOL6QnImNyjitay3GG9AcwAq
 /xavDA5xLHYrYgIGqH1UxvHFVWF5HZvBOvKRnrq2GEcqZGs89ptOK7a6+X5Z1CjAkWu25QGSBhw
 t94ICyRcj867NNSzJW6LFs9Y=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id b78de815968a6bde;
	Tue, 18 Aug 2026 08:36:36 +0000
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
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
Subject: [PATCH bpf-next v2 0/2] bpf: BPF-driven proactive memcg reclaim
Date: Tue, 18 Aug 2026 16:36:08 +0800
Message-ID: <cover.1787040082.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nznbnng3jj8ggwzjigxi4a4imuxtgszh
X-Rspamd-Queue-Id: 9373C100003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787042208-320470
X-HE-Meta: U2FsdGVkX18V8AxjFSh/xVmS6Ndr9F/qt4Cnm3WotaQSKw3N6mNjEv1G3sHOSMKBYNpSBGLCj7haY0FTy1XpEuivrR71mzOfEa89RVcleO+Wm4BgWYUMkG8Xs5tY900ZOTgCBbYFjCpttRcCfScUoWW1LE/7GCGQcW6B4n4f920KXq0kwX3QSLg4MtSxjCuL8un1tkcUDk+K/k/WeiF7N8GtHobzEKAbGLR8VZ3Ma8c2G1P5yMU5o4BkwSxSWyOjNS6Vap3fq0gGf4OuepULBjEhSEMJ6VwusdX2gDjcamLYWBvLdAxX5+KOp30LuG1vWr6wnG3FcoJKFdeAGh/8iu3d8ADq9iHIi4RBePhgIoCWXsnk9t2h9NB6EXkbdx3hdpp8EL/cSZHfcvWnqSFTov/rXetK1Bs8s9bGeeWbCyRRlChNXz56K2sCU7xUC+Dl63Jd6U62bn02D0JSWazv/N65oUmE1t53sI2ClTPKT5eWdQyMGCHSzWtXVlNvmifNuUtC0ypuZtY6P5Td9nyrVNTSkI0TOpomhjS+sFGOgGGyfUilA6XLJZUlaekJ1cEkgckpN7M8fv7c0s+wqgWLZjXIosJ3eI/e3RH1ETBK2STqAaHEBMQw4yywAICd6ZQOsQU7i0E4777zPRYoLmQJuGDUGFS3vlGYwkU0d2XXoC3o3uyUuuU77la37qyTImZ2K1R6E8ql41NpLq/LREweIyZ3X1F34ZH3EHBsH9TufNp9FfyFjT3pRPYgYXXHg2t3BZolYo/rMPTq7XzFb8mHKyBypgURDfWwLph4o95JELEPptYQWzNcuycJw8Ri3L2lO9kx6RfdD27hueuo1LhZl6MrCCG1Baa+ArhXJJup9yZK4aIAsIUASxsD4qqXYRds4UGEeqQbYSiudhKHGqLruk2lW4sf9AUzF+1aSM6FELGOC/h2flM6Vm2FBbefKl0X0qCk5OsbjjaXzyyhGJf
 hG4r236k
 gbyUBilwf8Hwr3SMqv7bmFriSYIetLUEaiQIU/4eq+5lYGFUxnHPUqY1WcW2HQ5o1qASG3a7l3xXqetLYcca2lbc3dFz7O3W51jDeDEH3iosZIjXDgxql++hSMEnlibR8HVAcYMkwouEgXpbH8qTSbmzQCLMbbUQ0e2OsGPvPNHzJXPSV7i0kZvBFToNcLvlxdMZx+Huji8iPXiarUAPml7Ti4Re/0g/2h84R1WOCRy+X8/JxSAWxpsBAM8XT0PopmpzOZIQiPrsUa9doferJ8ynkgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

This series lets a BPF program decide when to trigger memcg reclaim
and how aggressively to do it, based on whatever runtime signal it
chooses to observe -- rather than reclaim only being triggered once a
cgroup's usage crosses a fixed threshold. The core idea is a pair of
new kfuncs, bpf_proactive_reclaim() and
bpf_proactive_reclaim_swappiness(), which give BPF direct access to
the proactive reclaim path so this decision can be made in BPF policy
rather than hard-coded threshold logic.

This was originally part of a larger series posted here [1].
That series also adds a memcg BPF struct_ops (memcg_charged,
memcg_uncharged, below_low, below_min) for synchronous, in-line memory
protection decisions. That mechanism and this one solve different
problems -- struct_ops hooks run inline on the charge/reclaim path,
while the kfuncs here are for asynchronous, out-of-band reclaim
decided independently by a BPF program -- so they are reviewed as
separate series. This series carries only the async reclaim piece.

Compared to v1, the kfunc interface has been reworked based on review
feedback: instead of a thin wrapper around
try_to_free_mem_cgroup_pages() exposing raw gfp/reclaim-option knobs,
the series now provides use-case-driven kfuncs that perform one
proactive reclaim pass with the same parameters memory.reclaim uses.
The bpf_thread_wq patches from v1 (old patches 2-3) are dropped from
this series: following the discussion in [2], the cgroup-aware
workqueue is being superseded by a disaggregated set of async
primitives (bpf_kthread/bpf_waitq) that will be developed separately
(discussion in [3]), and the selftest now queues its reclaim work
through bpf_wq.

Patch 1 adds bpf_proactive_reclaim() and
bpf_proactive_reclaim_swappiness(), sleepable kfuncs that perform one
reclaim pass on a target memcg, like a write to memory.reclaim: swap
is allowed, and the anon/file balance follows the cgroup's swappiness
or an explicit override in [MIN_SWAPPINESS, MAX_SWAPPINESS] plus
SWAPPINESS_ANON_ONLY. Both delegate to try_to_free_mem_cgroup_pages()
with GFP_KERNEL and MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE,
the same parameters user_proactive_reclaim() uses, and unlike
memory.reclaim they do not retry until the requested size is reached.
Both refuse to run when the caller already holds PF_MEMALLOC, since a
nested try_to_free_mem_cgroup_pages() would clobber the outer
reclaim's current->reclaim_state (e.g. MGLRU dereferences
current->reclaim_state->mm_walk).

Patch 2 (selftests/bpf: add memcg async reclaim test) ties the kfuncs
into a worked example: it watches the WORKINGSET_REFAULT_FILE counter
of a high-priority cgroup as a proxy for memory-pressure impact, and
once it starts climbing, proactively reclaims pages from a
low-priority cgroup via bpf_proactive_reclaim(), with the reclaim
work queued asynchronously through bpf_wq. The test asserts that the
monitored cgroup's workload finishes faster once async reclaim kicks
in. This demonstrates the end-to-end use case: BPF observes pressure
on the cgroup it wants to protect, and reclaims from the cgroup it
wants to reclaim from, in one self-contained mechanism. Note that,
without bpf_thread_wq, the CPU cost of the reclaim work is not yet
attributed to a chosen cgroup; that part waits for the async
primitives work mentioned above.

Changelog:
v2:
According to the comments of Shakeel Butt, replace
bpf_try_to_free_mem_cgroup_pages() with
bpf_proactive_reclaim(memcg, size) and
bpf_proactive_reclaim_swappiness(memcg, size, swappiness).
According to the comments of Kumar Kartikeya Dwivedi, drop patch 2
and patch 3.
Remove bpf_thread_wq code in patch 4.
According to the comments of sashiko-bot, fix the issues of selftests.

[1] https://sashiko.dev/#/message/cover.1779760876.git.zhuhui%40kylinos.cn
[2] https://sashiko.dev/#/message/1b58d56976202f26818d31dbd0da2ecb2e2460f5%40linux.dev
[3] https://sashiko.dev/#/message/DKNHV09PBQZP.IRQL20BY574I%40gmail.com

Hui Zhu (2):
  mm/bpf: Add bpf_proactive_reclaim kfuncs
  selftests/bpf: add memcg async reclaim test

 mm/bpf_memcontrol.c                           |  95 +++++
 .../bpf/prog_tests/memcg_async_reclaim.c      | 382 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 167 ++++++++
 3 files changed, 644 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

-- 
2.53.0


