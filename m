Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD189C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F0D6B0088; Fri,  7 Aug 2026 03:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0126B0092; Fri,  7 Aug 2026 03:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABF4F6B0093; Fri,  7 Aug 2026 03:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 783C16B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:02:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0FB3A02E6
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:02:53 +0000 (UTC)
X-FDA: 85073581026.18.0CEB5C1
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id EFFE38000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:02:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cNegDMuz;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786086172;
	b=Wvp9v+PgGZ+JhL/SBw4oquqGZ3C6xOjHd8OGWlqD0niIqddgO5uAZ9a5/0BucxR/kXWbho
	99W2EjUUCnlRzNG7GKI/iK7gmoZRQbvP/az9k3v2hgPhUiW0b8tBUr4JClWxEN6JVPV1+8
	bpcrevcP/qkXBgu+hIMGuhsu9P6A1oA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cNegDMuz;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786086172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=smuGmk21K57soIDpX9xRt9BbzTPX01FIBsuhki3qxVU=;
	b=j9y1GGzMfIWePDq4jbgMsgbwmE+DTl09Uzo1E/g/nXSZSNkgnQTKqtAvbXiYkk7Ao4cI4t
	PUTiwXgKw1tPYRqEbiPm/YOIfG9eRPE+vIQ1V/yPSFfk0/UzQGWpG2Nz+o0/FfxaSXPLA9
	Mye4qebY9m22UDJgiRs/U54cfLgKKA8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786086166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=smuGmk21K57soIDpX9xRt9BbzTPX01FIBsuhki3qxVU=;
	b=cNegDMuzfa9tQvyToC72m0ArSkyHVD+RaagQzGD/nqOzWZp9fdoQEvmCuAPDDaArgiUcrS
	tBri5clUOgq5GZKRHqx5P8jsuV8XS5iJRyciRc5F1Ld9ynhPL11ucRX4HHZFIx/f1kK8CL
	vMtTZyhZ1z07gaXJo5/qsxGChKcFDM4=
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
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
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next 0/4] bpf: BPF-driven proactive memcg reclaim
Date: Fri,  7 Aug 2026 15:01:48 +0800
Message-ID: <cover.1786086076.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EFFE38000F
X-Stat-Signature: mtgfbs65fc3nr4s6ktjnzonycdoighhy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786086171-615191
X-HE-Meta: U2FsdGVkX19DgnO0JFlK/ppEV+bxFQ3+9LaGD/AIzDfRig1G0he1PNeT28af2QJDKudSBeoBhNtGFwMJjxyoSreN1raZLNCyCOGjX8+zqajiAp4elP0blX+IffG4B0VOGaMXZ8OacLWurQfQICxR2nCoNc0pnY2yKZvgSk/BJ3ZZJzXVZ9NE2MdzXUt/5kwi5bK2Os8tVMd1r4SX4GovvZaawCXZiUiKL7YgFFkPkWKk/j9wRcUl7UNVVwiKII0BKaLhwVkLiR8bx9fGu82pFUqztfu3SurX9Llfn2LKfxs0LBEHPRP7by87fapfjEHibV0GwnQLUShr6lpfl9cGrTR8Lde3l7WsGGzZHK434o53Psqo6MXdJmhjisdROTxt6gx9DrADfiewABk1FqbevaLCNsH+uOgaE/4g3YNjEEig0Gj8z7NNcuBUOY8Qna6T+gzDmB3rskqzUIf2+fwNADW2weei/1qbAqkZY3LN4HHjdITp5f6zGhkBMWtvwD8c58Shja9yw+20ycn12Jl6CmYTDvmjW/ozCqciRfRMajK3JFlYHBSYE9Ixs1WEl8ixTi1J1ExZSPJkj81mSXtzvbgPaoaY/gD3yt6YM55io6HVKO5ZCAfmh1GDrEnzVRtd26XFU6nNfv2LxEnFhXUheJwVJrZ+Wv8CH0wJ+AOVbfU3Jm/ArnYUQr8QL4dfZpkg5e7tU8kZflWsCr+Cw0h14WslPKi7BPCMiLtLaM/1Fmecf/0JzqCDIrKZl/d+GpPZ0hydz2nTMoF4E9NE5m8xAUVbPhz5XnQss4McqAP3jOSfzjKGNfxQatZqjgKeBmjb6EfqWVkkDVneQEllknB0D8fuKLmqtxqLJwIk+uv/ji/niWtnKdcJL6Z2QqF/NaJP9CBiKbTwAbfrQ3cVozHMuwOFtB2ARlGZqtENzLnVIjgLOraTVeK7ZuWxoOEzA8Lz32D2udDb1RpmqmF9zJs
 Smv2o1sG
 mVTw/xsz8aQqAykDONnW0Vx+XgGSAELG5THaitOPSK3MASCujdp3nxDt8lpwZbdHRYY/WUP1tqDyECxnco9Zh8n2E5hsjU5sN4eIoAMENdYjxzXxi+2p6+yZqBuSZCC/PYky049zasWFZhB+xQLMHPqZhhG4LWT/qBXKnvEYTcFvVYQnRgyWo4/qpilRybVMrRPhkBdQU7vdxQTTgHa4gZAPOrqVRy6HAmYF+G2oLiQXr9EmrilNRlc4S9BUBX9QyMxlMGqIMmdVgdC7qWi31LOb2f+OspjCGATvggSoMkPqVtlA=
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
cgroup's usage crosses a fixed threshold. The core idea is a new kfunc,
bpf_try_to_free_mem_cgroup_pages(), which gives BPF direct access to
the reclaim path so this decision can be made in BPF policy rather than
hard-coded threshold logic.

This was originally part of a larger series posted here [1].
That series also adds a memcg BPF struct_ops (memcg_charged,
memcg_uncharged, below_low, below_min) for synchronous, in-line memory
protection decisions. That mechanism and this one solve different
problems -- struct_ops hooks run inline on the charge/reclaim path,
while the kfunc here is for asynchronous, out-of-band reclaim decided
independently by a BPF program -- so I think they're better reviewed
as separate series rather than bundled together. This series carries
only the async reclaim piece: the bpf_try_to_free_mem_cgroup_pages
kfunc (patch 1), plus a new bpf_thread_wq mechanism (patch 2) that
grew out of discussion here [2].

Patch 1 adds bpf_try_to_free_mem_cgroup_pages(), a sleepable kfunc
wrapping try_to_free_mem_cgroup_pages(). With it, a BPF program can
reclaim from a given cgroup on its own terms -- any condition it can
observe at runtime -- instead of being limited to "usage hit
threshold X".

Patch 2 adds bpf_thread_wq, a bpf_wq-like map field backed by a
dedicated kthread_worker rather than the system workqueue, which can
be attached to a specific cgroup at init time. The motivation is
accounting: reclaim work triggered from BPF still costs CPU (and can
itself touch memory), and running it via a plain irq_work/system
workqueue callback would charge that cost to whatever context happens
to run it, not to the cgroup the policy cares about. bpf_thread_wq
lets that cost be attributed to a chosen cgroup instead -- e.g. the
low-priority cgroup being reclaimed from.

Patch 3 is a selftest that exercises bpf_thread_wq's cgroup attachment
in isolation: verifying the callback observes the target cgroup when
one is given, and does not when it isn't.

Patch 4 (selftests/bpf: add memcg async reclaim test for
bpf_wq/bpf_thread_wq) ties patches 1 and 2 together as a worked
example: it watches the WORKINGSET_REFAULT_FILE counter of a
high-priority cgroup as a proxy for memory-pressure impact, and once
it starts climbing, proactively reclaims pages from a low-priority
cgroup via bpf_try_to_free_mem_cgroup_pages, running that reclaim
inside a bpf_thread_wq attached to the low-priority cgroup so the
reclaim cost lands on it rather than leaking into an unrelated
context. This demonstrates the end-to-end use case: BPF observes
pressure on the cgroup it wants to protect, and reclaims from the
cgroup it wants to charge, in one self-contained mechanism.

[1] https://sashiko.dev/#/message/cover.1779760876.git.zhuhui%40kylinos.cn
[2] https://sashiko.dev/#/message/1b58d56976202f26818d31dbd0da2ecb2e2460f5%40linux.dev

Hui Zhu (4):
  mm/bpf: Add bpf_try_to_free_mem_cgroup_pages kfunc
  bpf: add bpf_thread_wq kthread-backed workqueue with cgroup placement
  selftests/bpf: add thread_wq cgroup test
  selftests/bpf: add memcg async reclaim test for bpf_wq/bpf_thread_wq

 include/linux/bpf.h                           |  15 +-
 include/linux/cgroup.h                        |   2 +
 include/uapi/linux/bpf.h                      |   4 +
 kernel/bpf/btf.c                              |   7 +
 kernel/bpf/helpers.c                          | 418 +++++++++++++++
 kernel/bpf/syscall.c                          |  15 +-
 kernel/bpf/verifier.c                         |  44 +-
 kernel/cgroup/cgroup.c                        |  13 +
 mm/bpf_memcontrol.c                           |  58 +++
 .../testing/selftests/bpf/bpf_experimental.h  |   7 +
 .../bpf/prog_tests/memcg_async_reclaim.c      | 479 ++++++++++++++++++
 .../bpf/prog_tests/thread_wq_cgroup.c         |  87 ++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 255 ++++++++++
 .../selftests/bpf/progs/thread_wq_cgroup.c    |  56 ++
 14 files changed, 1455 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thread_wq_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/thread_wq_cgroup.c

-- 
2.53.0


