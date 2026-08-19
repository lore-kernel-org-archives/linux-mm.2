Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3768DC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9DD6B0092; Wed, 19 Aug 2026 02:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB046B0093; Wed, 19 Aug 2026 02:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC236B0095; Wed, 19 Aug 2026 02:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB6926B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:36:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22E0F120447
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:36:00 +0000 (UTC)
X-FDA: 85117058880.28.A24719A
Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12A14A0008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:35:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tCGKGeUZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787121358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8PsSx6hQzSiT5cL9+JpGHkvuX46gNbXnLp1hfTbxxzE=;
	b=Et+lnd7MC1rQChacYQ90ZsyLwoSWyi0tlOAk2WaDuReHW1XX4cAhoQ7PNpSRrixT7sJF2C
	BRmZgKYoAqWwyBDNW57RGT2mZPmsJsMgD/b7NzFooEY6GmWgd27RK/ON8512XSaZMYek8W
	wej8VHwApF0IUE3makbXW72VWvFRHgA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tCGKGeUZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787121358;
	b=RU2ZrZGoMcUIE5LI5PuP+/iPR9j7GuZNqu7vX9UJvfhhQLXuBNBeMuZq/rtC/t3Q2dqePk
	IKVhFP0YgfixhM5Ycm+8fSCAFs3CYV60y5cqUJD6Tu48vmoL40vov9H4k8sgOlyhRpJ0Cy
	pUrVfM3G3kaNIiWzH2yDAvfzs5R5ups=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ru/OP1lG0ST1wZXA7RhW3VLfH8WpvYmZ6YLYeLoQvMo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787121356; v=1; x=1787726156;
 b=tCGKGeUZAIc9/dTmIsJSO3St8/r/1zzT+lXdqKSujyXo5txJx13fAMmOkehJPQG1BRm73N3r
 fh55Ks+td0A4fcW/nsp2UQk64kPVCeDf5cIUWNmBL+SOyAvxh74ONb6Vq1npM0KMFTLX77ZDiRM
 RVp+MifnSRgSpha3HUZ3RLMw=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id 6237c860b5f0182a;
	Wed, 19 Aug 2026 06:35:55 +0000
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
Subject: [PATCH bpf-next v3 0/2] bpf: BPF-driven proactive memcg reclaim
Date: Wed, 19 Aug 2026 14:35:42 +0800
Message-ID: <cover.1787120833.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 12A14A0008
X-Rspamd-Server: rspam07
X-Stat-Signature: zz5jwhfpwp5zbn1p9o7zcs4bchha714d
X-HE-Tag: 1787121357-299987
X-HE-Meta: U2FsdGVkX1+kR52r2ZHbzdeYF74xCpKJPeqp9Nl26eBVSM20wFrQj/F1jxdGPph9XBnW8WAm7Ez+VU010KyhG8D44QBiuHiFaU2jl3YfJGZ6A+ZZK1IXaw6UTp+19tgGRBdr7pAc85Mnqjvf50FynRSn3znPGck/rMzV8H1jNTVaiz7d4Zd9s5GtNmIFborzSg3agjUGcmDpWDXlXoA/MzUqHkNGXuoY2OKIHAplKlcbKpOyQt60h28djFd0zpVbTppeicxxD8UPfStdiabC+bW+UuIuUWlCRVC173Um8j0aCuqhYyH8e7Vh6f5gZi5kQCjgRkxO6y2kE/heHTF138uh1WUWXdTc3v9hLz3ymidsCEtLLObDb+vpw62lOX0MTk0J1/x+LmSy16/Y28xIYPkjJs2RYpvQaZyDtYXxzfzedfolcCpRL5qUXZJUd+QdqK4gL5j0/KN10RROuCrGvofizCIumqEh18ZCWuQFtD3RcMVxBxOKvwhn9Ge8u19Egz/0azDKubReZBR69605rfUeB8JMYDXGqIjDX8UcxIerGqjG7vFTfipI3L/6aAZnKSLE0NO0nvw/8vVU4HMfYtrxLY3V7lHG5sgUqDD9Aj00ubS5dM5EtC990xLSBMI8zRPB1xNAPREEi5l1st+iq82jr5pFyn/il/2/UsZ2ahC/AP6I7nxdMQYCr5BRP2in5G1LX8THGY0Ql/g451n5fBJniU3kMkWBo/y5ZzgrDpLVGAth5+P3L4bg9Cuo3BFJq+G9s3eAEhCLEPz4Gg5eGzHukwr6oSesQ/8gptdGA6fD+BJr0KgcoH++wjHiinnw7ihNwYdOMr45xGCbvcR1AaF/0U6dTJ5qyQdJMOCEa3tkfEOBGSnq/7cywY1e34UbKWaCHhNRQNgtSgqM3WPf5TZsgRYUtafvjkSirlCWk9qIF3aQ+GH0JTJ9LPhd//BE6rKkRWgRtTOwg0u7kgv
 vxDSuPtW
 9gGwjA8bBQb6QyU4QTXDq3a4VswfmpxsvC9fW8rp/+L6m6mNmb73E2baqFSwhKHRoLtCV0hbhtn/KhtobUegr1jQzjGFot0VI4OOr2J2HaeVTJK02aE88pn75YmB6wfyWpWYNv6xWdZXv2VI0NVmsxMnjaFAm2+qyBZA0JYxzOoGc6fcRMyxC8VhPnDnPVcBvz60DKCjIAe4OA2hyyDhzJsuQvLrWEimFrDCXqvqdFg68OeDfn52j77oq+3xRdSJ3B/F3fmmR4h5B6vtbaU+zRNd8FQ==
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

 mm/bpf_memcontrol.c                           | 101 ++++
 .../bpf/prog_tests/memcg_async_reclaim.c      | 479 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 180 +++++++
 3 files changed, 760 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

-- 
2.53.0


