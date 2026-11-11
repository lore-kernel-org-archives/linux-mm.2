Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7B7606A8AA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bjvfla5w
Received: by kanga.kvack.org (Postfix)
	id BE28F6B00EF; Wed, 11 Nov 2026 05:38:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA3C6B05B0; Wed, 11 Nov 2026 05:38:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACFA96B05B4; Wed, 11 Nov 2026 05:38:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8326F6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:38:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E8CD80269
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:38:52 +0000 (UTC)
X-FDA: 85422490104.04.27673C9
Received: from mta1.migadu.com (out-224.mta1.migadu.com [95.215.58.224])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB07D120004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:38:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bjvfla5w;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794393530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xDU+VUQuiVqA+errFgpqHKql5l47PsMQESWCLQkI4gc=;
	b=2RaJYyWIvP60gZMKBfgc3mBZsiM8RMwJTAL1mda0dxA3smSz6cVNghXYEeLe2VgglH+FAm
	gZ9xKC3c3GrY82i5nzUc4X8b8x8TJeMPVcRwvmoH/z/25z7EGfHLwF0SldnQwprk5StUJ3
	x8NX4iCu0+kEG8+J96FBDI7RTiW6fQQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794393530;
	b=SkP9fJxfR/gK2dyToLMmOwKy25gjaAawbSxLZr/jvlhUgi5CMWZDHy01KJeqqV4wL/z6M5
	p43NXk/FOzt3RrM3aNf2O3H6CDgRz1SNeFGUg1JqnrWReUDE6tFap+XUedKHDu5sDc5QFa
	no3JAc8moiKmxd9BrYPco0VvQU0Gsp4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bjvfla5w;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Pgs9Rl2H9Mrm9v98ZZj54dqFp+ymM4kJacjilJCmcW0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794393528; v=1; x=1794998328;
 b=bjvfla5wO8wtHYY4gSPf478Ha6EcgBkojYdgSSSWnEhPH2JZVAQ33yT1o3xNJVDqUw7YvvH0
 3EFHYlF/woFlHpDarnibVMC3p+oYEJxF6nosE0wGj9PNePOfrbD+l/9/tfEvKHC0UVKE/X/jmiB
 gJmazx4HcncKYSXjLw154HKc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 272d3a1a2ff3a6d3;
	Wed, 11 Nov 2026 10:38:46 +0000
X-Mizu-Trace-ID: 272d3a1a2ff3a6d3
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
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
	JP Kobryn <jp.kobryn@linux.dev>,
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
Subject: [RFC PATCH v2 0/2] memcg_ext: dynamic memory.low protection requests
Date: Wed, 11 Nov 2026 18:38:14 +0800
Message-ID: <cover.1794393349.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gjt9mszonrw73gp5e7aa36xn515c55zh
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB07D120004
X-HE-Tag: 1794393529-829007
X-HE-Meta: U2FsdGVkX1+hDtTAu/nK3pk6v34oOlnO8iN34BVUxSVwK4r2MYTdKPEYju7CtQiD+IJsFX1WwGoo4SXmEMKrFCmPRIdG6e7N7H/qdao1EIfgQy4PtoBeB7rwNZemlnmb9cNtTu1QzmD3ZgjgYOw4Wr2k0cp2mDMJ/pvGvjhYBjg9fmGGQsfCcryuboeJJCe+XZS6Wbb5N8IkfCH/EEQ2gRkxfayY7ZolDfzMdDtHA5tfoeNjz3p623Ytyu9EtwiLctAw00pQrFIs1Sb0PPjVzBHEUx5cu3Yn5KnyS3GQPdbCpxBPKKbwO93/+ac5os6m3wr/YPskrqNf8t2GVoPow3r7cuYxksUpanHnXqGK8XGe4D28J9uLFwmXUN2Xj/WYKWz56Y677sY8YmcwqeZTybPyYT/kLiWIjdqRstWn1W3LjVBdQTKHAl9KBRcBmMTp7xN5kaz2iRJjE4QAppK7d9GGC6ToUHpVDEQdvN/QBeyEq6Le13mxGL+jtPwfjiDP8jp+rJ698BNx9oySvlgz+81xn1g/a/Robu5qxb8vhsaxlyvQUNZVjl2a6btznmo2L6VgVbRy7gYaVKuaqn/I5qOFHyRGiTJOnTXal2CC3FImhLkmiI9EDn6ySEnrE0tr8AoDXo+BicFz0ZRCBNjb4FbkimNPbV2B9g4GEvMLznECCULDMS7wWOuyOyQ4ETgbCxq5SAr+wek6Xgdzo/UuGx8DF9FXYzoBWuXywdEW4cFZGDrv3KNWgKTpwWXNziFdrYLuxbgd9tG4pwOcLb6lRNozfyAgNTHpm4qd8H9Dp/UrteAlkz+zf5FU3MtMjtVr4M9mPYauTbP4eeiNI2lnwachoU+s3BnprTbT/ccXPe0LJ2IEKt09mspbTRLJJsaywBTwybK2Yb4525SwxjN+oUFhDiPlb8juFKS2zAX3KQCqqAnpsIyQTgNlextyxwtzko/sZnk9qXpDS1e0z+E
 VSg7gXEP
 vDpVhbfJLM8GK+ArGg5RdLMOQrh5P+E/8C5XH1ZUvx+mDnLWHD5antNbhIrkpHWiP2lBsYq7WOtpCWo2tDhLJRhqXKKYZsptJgK1IFjbiGskgAjNxXxS6eUg43ZIKnh693VT6RbwTtpXWX60S9RvIO7WtQHTIfM2dlrskODOHZtC7iwywSfJ9+/wMfwUqYPgKEmAi7RehstrEUCUrJK1JdAFTe0PGIJjPpThseaK5MeHsgsXCWCO2veFU7FeyPr3o3pKXTlm4M5i9OfAY80b6K0P4+YOxALg/gaJJRsJmthqyPjNhNol5cmqRANvbWZ7WTHAQqa3x4zVRAIoZtcSiUIeabrLmgQjCZc4+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

This is v2 of the RFC "memcg_ext: dynamic memory.low and memory.min
protection" [1].  It sits on the memcg_ext base [2], which adds
bpf_memcg_ops - a struct_ops type attaching memory controller policy to
a cgroup - and lets a BPF policy take part in memory.low protection:
not by deciding whether reclaim skips the cgroup, which is what the RFC
did and what the review correctly rejected, but by requesting
protection and going through the same arbitration as a write to
memory.low.

Two things changed since the RFC, and both are answers to the review.

THE CEILING

As posted, a policy could make reclaim skip a cgroup whose usage was
above what its parent affords.  That defeats the cap
effective_protection() applies at subsequent levels precisely to keep
delegation safe: a delegated tenant can attach a policy to its own
cgroup, so it could grant itself protection its parent never gave.
That was a defect in the interface, not a property to defend.

In v2 the hook no longer decides anything; it requests.  The request is
collected before the effective value is derived, and what a cgroup
claims becomes the larger of its memory.low and the request - capped by
the parent's effective protection and shared out with the siblings by
the same code, on the same inputs, as a declared value.  A request can
move protection around inside the parent's budget; it cannot lift the
subtree above what the parent affords.  Anything a policy can request,
a write to memory.low can request too.  What is left to the policy is
when and on what evidence the request is made: every pass, at the point
where the effective value is about to be derived, rather than between
passes.

min_policy is dropped rather than converted: this round concentrates on
memory.low, and the interface goes from two members to one.  A
memory.min counterpart can be revisited later.

The rework also removes the memcontrol.h change entirely:
mem_cgroup_below_low() and mem_cgroup_below_min() keep their signatures
and the series no longer touches the protection checks.

One cost is stated here rather than left to be found: the callback now
runs for every memcg on every pass - with MGLRU that includes
lru_gen_age_node() walking every memcg on the node - where the RFC
asked only about the cgroups reclaim had found unprotected.  With
nothing attached, a call is a page counter read, a static key check and
a comparison against the stored request.  Measured under the reclaim
storm of the demonstration below: ~56k hook calls in a 30s window, 52ns
average per call, 2.9ms of in-hook CPU in total - 0.01% of one core.

THE MEASUREMENT

The review asked why the same cannot be achieved by changing
memory.low from userspace - the same question Michal asked on the v7
thread [3] in May.  This time the answer is a measurement rather than
an argument.

The claim under test is a window, not a throughput.  Direct reclaim
runs in the allocating task's own context, and shrink_node_memcgs()
examines memcgs one at a time, calling mem_cgroup_calculate_protection()
per memcg.  An agent cannot do anything for the memcgs a pass has
already examined, and for the ones it has not reached, a concurrent
write to memory.low is picked up only once the agent has been woken,
scheduled, read memory.stat or memory.pressure, decided and written -
in a burst that window holds at least one full pass, which is where the
working set goes.  After the rework the hook sits at the point where
the request is collected, so it is asked on that pass.

Method.  Three implementations run the same integer policy on the same
evidence and differ only in where the decision runs:

  U   userspace agent: preads the victim's memory.current on a 5ms
      timer and pwrites the sample to memory.low.  Made as strong as
      I can: pre-opened fds, no allocation in the loop, and its own
      cgroup with memory.min so it survives the pressure (disclosed).
      A PSI-poll trigger variant exists and was measured too.
  B1  a bpf_wq callback on a 5ms timer reads the same counter through
      bpf_mem_cgroup_usage() and stores the verdict; the low_request
      hook executes it.  The control for "the action runs in the
      kernel".
  B2  the low_request hook decides from ctx->usage - the value the
      kernel read for this very pass - on every protection pass.  The
      only arm that claims something userspace cannot do.

The shared evidence is the fall rate of the victim's memory.current:
reclaim uncharges it synchronously in-pass, so a falling usage means
"the victim is being stolen from" with no statistics-flush dependency.
The textbook channels were tried and measured blind: workingset
refaults need the shadow entry to survive eviction (96M stolen from the
victim counted as 2 refault pages under the filler's shrinker churn),
and pgsteal is only readable from flushed counters (a whole burst
window passed with the in-hook arm seeing zero movement while the
victim lost 19k pages).  The threshold is a rate - pages per second,
not a per-sample fall - so the ~10x spread in sampling frequency
between the arms does not bias the comparison.

Workload.  Under T (memory.max=160M, memory.low=64M, swap off): a
victim A (32M file working set re-read on a 500ms pace, hooks
attached), a filler B (112M of file cache rewritten continuously - a
renewable flow of cold pages that keeps satisfying T's reclaim while A
is protected), and a one-shot 64M anonymous burst C that is
unreclaimable without swap and raises A's share of the scan.  Metric:
A's pgsteal over a 30s window.  Protocol: 15 rounds, arms in rotating
order, a sanity gate every round that verifies the protection chain
before any round counts, cache dropped between runs, every knob
identical across arms and rounds; then a sweep of U's trigger interval
(1/5/20/100ms timer and PSI poll, five repetitions per point, reported
as medians).  QEMU VM, 8 GiB, no swap, booted with psi=1.

Results (medians [IQR], 15 rounds per arm):

  stolen from A    B2 452 [339-755]    U 3723 [2825-4730]    B1 3960 [3211-4853]

  - B2's median is 8.2x below U's and 8.8x below B1's, and the IQRs do
    not overlap (Mann-Whitney p < 1e-4).  In 14 of 15 rounds B2's
    worst (968 pages) stayed below both other arms' best round
    (2051 / 2615).
  - The tails overlap only where the kernel itself broke protection:
    B2's outlier round logged 920 MEMCG_LOW overrides, and B1's own
    outlier - 9303 pages, the worst single round in the dataset -
    logged 352.  That is memory.low's documented soft ceiling: reclaim
    legally overrides it when T's max cannot be satisfied from
    unprotected supply.  It applies to every arm and to any policy
    alike; memory.min is the hard guarantee and is out of scope here.
  - Overhead: B2's entire in-hook cost is 2.9ms per 30s window (~56k
    calls at 52ns average, 0.01% of one core); U's agent costs 140ms
    for ~6.7k decisions and 187 memory.low writes; B1's hook is 1.7ms
    plus ~7k wq timer callbacks whose CPU is not in that figure.
  - U and B1 are statistically indistinguishable.  Moving the action
    into the kernel buys nothing by itself; what makes the difference
    is deciding at the collection point.
  - The sweep answers "poll faster".  U at 1ms leaks a median 1308
    pages at 374ms of agent CPU per window; at 5ms, 5330 at 138ms; at
    20ms, 7746 at 34ms; at 100ms it engages in only 2 of 5 windows and
    by then the drain has happened.  B2 beats U's best point (452 vs
    1308) at 1/129 of that point's CPU.
  - The PSI-poll trigger never fired in any window - a publishable
    negative result, not a bug: the victim stalls 0.3-0.6 ms/s, an
    order of magnitude below the 10 ms/s trigger, while the filler
    stalls 39-44 ms/s.  The cgroup being stolen from is the last place
    PSI-on-the-victim can see it.
  - Time to first protection is statistically identical across the
    arms (medians 2.1-2.8s): under this pacing it measures when a
    drain episode happens, not how fast an arm reacts inside one, so
    I do not rank arms by it.

In short: the same policy, decided at the collection point instead of
out of band, cut the victim's losses ~8x at 2% of the userspace
agent's CPU, and beat even the agent's most aggressive polling point
while costing 129x less CPU.  The scripts and the protocol description
are in [4]; the raw CSV rows and per-run logs behind the numbers above
are at [5].

THE PATCHES

1/2 memcg_ext: arbitrate low protection requests like memory.low
    struct page_counter grows low_req; low_setting() becomes
    max(low, low_req) everywhere protection is derived; and the
    bpf_memcg_ops callback moves from mem_cgroup_below_low() to
    mem_cgroup_calculate_protection(), so the request is collected
    before elow is computed.  The request is recomputed every pass and
    reported as none whenever no program can run, so detaching the
    last program drops what it asked for on the next pass - nothing to
    clean up.

2/2 selftests/bpf: Add bpf_memcg_ops protection test
    A three-level tree, a policy on the grandchild requesting its
    current usage, memory.low on the middle cgroup as the budget, and
    reclaim from the top.  Three budgets, same request: with 0 the
    effective value stays 0; with 2M an 8M request comes back capped
    to 2M and reclaim still goes into the victim; with 16M it is
    granted in full, reclaim skips the victim and memory.events low
    moves.  The ctx contents are checked along the way.

[1] https://lore.kernel.org/all/cover.1793086858.git.zhuhui@kylinos.cn/
[2] https://lore.kernel.org/all/20260921192559.2619635-1-shakeel.butt@linux.dev/
[3] https://lore.kernel.org/all/cover.1779760876.git.zhuhui@kylinos.cn/
[4] https://github.com/teawater/memcg-async-reclaim/tree/memcg_ext_20261109
[5] https://github.com/teawater/memcg-async-reclaim/tree/memcg_ext_20261109/log/run-20261111-071332

Hui Zhu (2):
  memcg_ext: arbitrate low protection requests like memory.low
  selftests/bpf: Add bpf_memcg_ops protection test

 include/linux/bpf_memcontrol.h                |  97 +++++-
 include/linux/page_counter.h                  |   8 +
 mm/bpf_memcontrol.c                           | 155 ++++++---
 mm/memcontrol.c                               |  30 ++
 mm/page_counter.c                             |  51 ++-
 .../bpf/prog_tests/memcg_ops_protection.c     | 297 ++++++++++++++++++
 .../bpf/progs/memcg_ops_protection.c          |  82 +++++
 7 files changed, 678 insertions(+), 42 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_protection.c

-- 
2.43.0


