Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 175D3C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 06:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71BB6B008C; Thu, 20 Aug 2026 02:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A5A6B0092; Thu, 20 Aug 2026 02:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60A46B0095; Thu, 20 Aug 2026 02:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B66D6B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:12:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A8E54055B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:12:56 +0000 (UTC)
X-FDA: 85120629552.20.B62E259
Received: from mta1.migadu.com (out-247.mta1.migadu.com [95.215.58.247])
	by imf09.hostedemail.com (Postfix) with ESMTP id 72140140008
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:12:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KvjRkhf6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.247 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787206374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Bo1yu9hdR4RdTevpz4ckTrk31GyQqkewIsKO99hjcSY=;
	b=du2hcNivEIWqfadmeywsqjIyZnQEZT/LW0Rk1RMb4Tn3zbEv0lldWXmm+XQ8P1/YC1xy5Z
	QUA1XFIf9IOix4IlrgAl/SPQenSvi6yp0zy2WxS/oiWqXpHluasbKdt4DE6YvMRzzBh1mI
	zGu7VQncMga0XkSU0+0Ssb/r+A6vcVo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KvjRkhf6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.247 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787206374;
	b=wkwrAQBQ3jZGtdcSLuKNBzNQ/q+gHrULlG4CudpQHUPSal3mq5S7I6AkauqxNYkgvQEb+4
	q2Uiuj0TGdxN9OVPMYjbB3kKF59N7AgCIR4G3WArQlH6o0pq9cVWU8whufFrFsmV5ZFwat
	IrxNnZFq5uxI46JthZlf9GKH1KwVwcM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=J3As6mLmBqXoLEZhAfPKlRCMlDdzNNR6LV3rcJ1y4vk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787206369; v=1; x=1787811169;
 b=KvjRkhf63VLvI9p0thnW5KrSmoNym7K4ZHsBi7TXaDp6s1dxCcDI0uXiKtTvdRlAL8T/CWYJ
 Otp0PAlh/DrKIr3cEDJNQsWHSpvQ91gt8CzUjARdXEx1uxBKQY0O0WD5mzxvksiHOwgNLJrpVSW
 Ogn9OQjoPthNNoAdguHhixhE=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id 8044d5bea338e0fc;
	Thu, 20 Aug 2026 06:12:48 +0000
X-Mizu-Trace-ID: 8044d5bea338e0fc
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
Subject: [PATCH bpf-next v4 0/2] bpf: BPF-driven proactive memcg reclaim
Date: Thu, 20 Aug 2026 14:12:25 +0800
Message-ID: <cover.1787205002.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72140140008
X-Stat-Signature: 8i4to9ktu3tzrdcfhgmfwc9qseb8x3dz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787206372-788971
X-HE-Meta: U2FsdGVkX185Q7I7ou6+++QmuS+IWD9LfhE5LCo12Eyk1SLUfYvBSLjpq5kZsLpP1y7it5Y0Efrqqkq0rJFu9xmWbfpE5Cwc9B1OuO1zdd9x6UbCWTtVTQ0tYpf14aYa7OHwUCUM37OJ5+CcozYlm2DbVyOGfHkz8xtxqHsGJ7kFGzpdl3ppNhMzz73gYQAHU0MBzS2yZ6Nr9uYRNB9ym22dGb/xmuxIN6yNyNBfFkp4PJxeMwwFjIlHysCXf2wXiYpDv+WRd6OqalQpRwCpIaxQFN/YV9ZhKY5u7bMeoW4hTjt16P+BSstTHGfyPBkgjV6Xa5EOgNhJb8VcuMXRVBaBvbce+XZ3vDszIKORd3C4wxmtXHkRd+pTkn4rOamjc3qvxh+GGN+HNfvGtTsko4FDVZC7dyo8FBpgT2SaLS7VCsMJsfm43oMmBLIVkaSER49OItJo7Dhxipw9gINLTRVOi15cP9E1/FR3UhUGlMs1HTiSsjZu9BMS/qQS+Hb0yqJaJW5pgFEXBryk9oFJBT/FpF7dgccb+WUOHEdv9OgUVC0x0WVdgsV1kOMxahvFQwigNuA+l48vO/tprGSUy6yfcqqdKaA+fb7eLw1wOKNSrVbz3khUpGHHTQwbrsKook4frRsXOVfsUqsuMxm02jKSANluv67NKtKFkTo7aCsj3QG9lPD73GkvOqZBNVQCTFqBZc6Rk7wBxeB3G2aJjaDb3LiymmC9E9C7W1OylECRxMgpzoKzkinPPomp4rbcFmY48RzMU5ZAggJYcRLe2U6VSKrsQXiZcDG8lTuCXK9MbPBzh5pzikm/UVh8EOu+4liYQdLIlVTjiLy10QqILYanWMERGbp63YvUTgNwpJsTcepKmMBCe+kE4VNji67jbXxsIQ3aCdJg4HEc6jRroLKO7Qn+AOjy4dN1OHhLmN/Fe4JFiJLd2Mn/ZNEDXLEyl8rku03/nH4zPKsQBbW
 aSvlMf4H
 7z7cph1ilDNfMKypJi2ItmoFFXoxXlTWJqrpj5IjkK2kw7LC5k+tEzXaingykfy23CoUzD+kikCpeP0ibmVDT6Lpt7IhFasy5TWeQEs19COcoecqdbZtVUEkzJFObEbvwaE6hAp2NCaiEvNA8Z0gEca5E86ibaziXIIw9b6N1XjSBwYNhSFeTdlpiRATIg6Uw9l/UU5qYF3jsHPLncs8qjyX+Vj+yU05Lne8HbuS5F27O1ILyZAPJ1c3IHQ1Yu141ZoCnjiq/U9vn9RMJM7egsaW9lw==
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
SWAPPINESS_ANON_ONLY. Both go through a shared helper,
bpf_proactive_reclaim_pages(), which guards against reclaim recursion
and calls try_to_free_mem_cgroup_pages() with GFP_KERNEL and
MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE, the same parameters
user_proactive_reclaim() uses, and unlike memory.reclaim they do not
retry until the requested size is reached. Both refuse to run when
the caller already holds PF_MEMALLOC or has a non-NULL
current->reclaim_state, since a nested try_to_free_mem_cgroup_pages()
would clobber the outer reclaim's current->reclaim_state (e.g. MGLRU
dereferences current->reclaim_state->mm_walk); the reclaim_state
check also closes the window where try_to_free_mem_cgroup_pages() has
installed it but not yet set PF_MEMALLOC, reachable by a sleepable
program attaching fentry to the generated trace iterator function.
The size argument and the return value are both in bytes, matching
the byte-based unit of bpf_mem_cgroup_usage() and
bpf_mem_cgroup_page_state() so callers can mix them without manual
page/byte conversions. An out-of-range swappiness is reported with
(unsigned long)-1 rather than 0, since 0 cannot be told apart from a
pass that reclaimed nothing.

Patch 2 (selftests/bpf: add memcg async reclaim test) ties the kfuncs
into a worked example: it watches the WORKINGSET_REFAULT_FILE counter
of a high-priority cgroup as a proxy for memory-pressure impact, and
once it starts climbing, proactively reclaims memory from a
low-priority cgroup via bpf_proactive_reclaim(), with the reclaim
work queued asynchronously through bpf_wq. The test asserts that the
monitored cgroup's workload finishes faster once async reclaim kicks
in, and -- as timing alone cannot distinguish a working reclaim from
a no-op one -- that the BPF program actually made reclaim calls and
reclaimed bytes, via counters it exports through its .bss. This
demonstrates the end-to-end use case: BPF observes pressure on the
cgroup it wants to protect, and reclaims from the cgroup it wants to
reclaim from, in one self-contained mechanism. Note that, without
bpf_thread_wq, the CPU cost of the reclaim work is not yet attributed
to a chosen cgroup; that part waits for the async primitives work
mentioned above.

Changelog:
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

[1] https://sashiko.dev/#/message/cover.1779760876.git.zhuhui%40kylinos.cn
[2] https://sashiko.dev/#/message/1b58d56976202f26818d31dbd0da2ecb2e2460f5%40linux.dev
[3] https://sashiko.dev/#/message/DKNHV09PBQZP.IRQL20BY574I%40gmail.com

Hui Zhu (2):
  mm/bpf: Add bpf_proactive_reclaim kfuncs
  selftests/bpf: add memcg async reclaim test

 mm/bpf_memcontrol.c                           | 118 +++++
 .../bpf/prog_tests/memcg_async_reclaim.c      | 480 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 181 +++++++
 3 files changed, 779 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

-- 
2.53.0


