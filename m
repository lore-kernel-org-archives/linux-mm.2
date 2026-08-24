Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 757B2C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD5C6B0099; Mon, 24 Aug 2026 16:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4D56B009B; Mon, 24 Aug 2026 16:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB1B6B009D; Mon, 24 Aug 2026 16:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25F346B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:15:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A38B9160261
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:15:50 +0000 (UTC)
X-FDA: 85137268860.30.6BAA1CE
Received: from mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7DE0C40007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:15:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JkRXcuAV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.26 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787602549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qT38V6Fyi/oYYJ4d+n8fx4SQuOseTyBW50h7Hf4I/BQ=;
	b=qOHYYm0zH7lilmRNLx3Ue69L9QM4G5svrrOFQQr1p4/YCukeG4Vx2oATlVECQlkrU9jDOS
	MgJE5bIfX09xvp2PK6hOk56ZoWBT+YpGTEnUOlyYQznCRoXGZ3WRcGNxOSWCzv0lzfiqS1
	cYvErRnVLXZg/Dx78lVlXwDmLuVcOqI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JkRXcuAV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.26 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787602549;
	b=lqlCD/yBOHq3YBKLp7Q9YwP16jYrfJ+rQmFO8LrMHjLOrAw98StJeNCJRQLEgPstnpyX3u
	kcjR/d9RFvtdw61dStmRjNUHDUVYPh9N9axfp79S9xe2Kjq8BQinQXEr6gskI0ohEjNYhv
	rjkmURg1HU15+2jUmpyLMrutKRo8OLk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nLzdm/qCP+HJMriRMsBX2NapVlTGsrYyj+a9BUlHHi0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787602547; v=1; x=1788207347;
 b=JkRXcuAV7eH9fS9NjOutkiyCjEus98SYFLEZEHYx3Mh3T2oCfMUKsWBvxZP5J3kTmFwJiDc6
 u2Ey5dOKKyqPluUZX6HwlJSo7obEc4whhAAY2e5FWWRQL4w55FswPR9BCPcGaL21B8vfsd1Utik
 sndRQtWsmFo9pe6rKawzi/0o=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:5::)
	by smtp.migadu.com with ESMTPS id d3cffa5edf59e1e6;
	Mon, 24 Aug 2026 20:15:46 +0000
X-Mizu-Trace-ID: d3cffa5edf59e1e6
X-Migadu-Flow: FLOW_OUT
Date: Mon, 24 Aug 2026 13:15:41 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v4 0/2] bpf: BPF-driven proactive memcg reclaim
Message-ID: <aoyl4IrvfUl8swv_@linux.dev>
References: <cover.1787205002.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1787205002.git.zhuhui@kylinos.cn>
X-Stat-Signature: p9stqakdum3ckq7tjiqjdoare3e3qoq8
X-Rspamd-Queue-Id: 7DE0C40007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787602548-214222
X-HE-Meta: U2FsdGVkX1/zksli2x7eGCGm7dN3VrWJANOIAnwEj7KxxlTm4Ocs1M0+8IK5hIdFRKWoCoaTfn8hMIe/cvmkbCZMhNzj3T5BXjf1HsOwobKtVxS6VV2m+bfOUHGLykhClmCw2FYw0XAzo2X5HZbxahdx1mu4RgLwztjiwqJ/Sn12DPP6SSOL+8ybKtmBu/huJOjcV/v1lIq7/X3WqmKkdyHUP+l0IJbkx9CXFGnA3I3yjd+Gso41Zip2SNrHrh58u2XxcDOU1Wq74JXNEDfdhJLdJIJP0vv7ADWPB79I44Q20DFdYlt1cMzoPQ+j4WT9aqVYxMzLW0Hikzit7B8V18fCXpKs1+7VBaSmyB1AK/sWzGnkPBy0V1KJ/aRzw0tqConcs9NcG+VyKWxU+mNnRpIiOk2L7f4cwNDTAGE2bd9CS1UrkzvTXYWH6opIVjm1CGiQ7l78ZTWPaNdmTCUTrbRsApeD2PVFTfiH63tQheTXinPqWS7ZSFLdDYmIzZ1zDkNv00iPDT1oTyagkPfQtuuw2MEUsVpdFJD+LYc8DKtkI8Zr0rSlW2E7vGw+ClMSMoN+rz0rLJzHubNu/2AOj+yz6T4ojSRJBOyKxV0w+xMlRPmSB3v9W/OjYKHQX5De8jSZ5n1CzVZ0IZUhT52cAiDYP+/koUsEUCpTE7bnTlX4RdfHeagvZgiAZoR2Lmklly3rLBogKt5n4t229CsAU5O/N42xKnlMXwqhV5ch1I3VJM24IiZKNxDjPKu1w+lUTSG6qRBHJVwYyFwSOOLGilTlLq0Azqg11fZ6iyCaRHqBbI/ile6daYwW5nGrqXB5QbsxypACQnrmhNExbpO71BQev83nnlfXKIbvymrUtaA9ZhrwQAXVKswk1uo9yOTnPvCX1unl4rm2JTy3zJqAxzBrFpcJU1IrPi5JKEqGVPp9+w8G/zdSjF4jtwjWSSGF3rZm7UFf4Py0VnLsKr5
 WijShmxh
 vFLKX9LoKNp+j2uLhaw9yi3k4YlalLjH+IXgQQdy3g2MtJUIxb1LCjDX4Q58S13fc3BCj4anWQCDp2nfsSAf3LGOu2rtBwSbQeLjhuWNGnWXwEQlMUSfjWYYaL5jYbGF30QmaO/AnnVQi4ikOEwbd3yn7a2No7W1vD5YOSBFKncbSMjba1a2h1UrqxlDzwjrnKRFkYBesTbQygpyZSTdkwMC84wo86WTe2e8DbgLJE6PZ7foEVIkB2ka/2xV+jK0g8QF3yCTI4aoLYmSorV/r/jJ8bNxwBnlFc30i7ywAGIxvupZxvJU3af9wjAU+xJWo1K29
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 02:12:25PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> This series lets a BPF program decide when to trigger memcg reclaim
> and how aggressively to do it, based on whatever runtime signal it
> chooses to observe -- rather than reclaim only being triggered once a
> cgroup's usage crosses a fixed threshold. The core idea is a pair of
> new kfuncs, bpf_proactive_reclaim() and
> bpf_proactive_reclaim_swappiness(), which give BPF direct access to
> the proactive reclaim path so this decision can be made in BPF policy
> rather than hard-coded threshold logic.
> 
> This was originally part of a larger series posted here [1].
> That series also adds a memcg BPF struct_ops (memcg_charged,
> memcg_uncharged, below_low, below_min) for synchronous, in-line memory
> protection decisions. That mechanism and this one solve different
> problems -- struct_ops hooks run inline on the charge/reclaim path,
> while the kfuncs here are for asynchronous, out-of-band reclaim
> decided independently by a BPF program -- so they are reviewed as
> separate series. This series carries only the async reclaim piece.
> 
> Compared to v1, the kfunc interface has been reworked based on review
> feedback: instead of a thin wrapper around
> try_to_free_mem_cgroup_pages() exposing raw gfp/reclaim-option knobs,
> the series now provides use-case-driven kfuncs that perform one
> proactive reclaim pass with the same parameters memory.reclaim uses.
> The bpf_thread_wq patches from v1 (old patches 2-3) are dropped from
> this series: following the discussion in [2], the cgroup-aware
> workqueue is being superseded by a disaggregated set of async
> primitives (bpf_kthread/bpf_waitq) that will be developed separately
> (discussion in [3]), and the selftest now queues its reclaim work
> through bpf_wq.
> 
> Patch 1 adds bpf_proactive_reclaim() and
> bpf_proactive_reclaim_swappiness(), sleepable kfuncs that perform one
> reclaim pass on a target memcg, like a write to memory.reclaim: swap
> is allowed, and the anon/file balance follows the cgroup's swappiness
> or an explicit override in [MIN_SWAPPINESS, MAX_SWAPPINESS] plus
> SWAPPINESS_ANON_ONLY. Both go through a shared helper,
> bpf_proactive_reclaim_pages(), which guards against reclaim recursion
> and calls try_to_free_mem_cgroup_pages() with GFP_KERNEL and
> MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE, the same parameters
> user_proactive_reclaim() uses, and unlike memory.reclaim they do not
> retry until the requested size is reached. Both refuse to run when
> the caller already holds PF_MEMALLOC or has a non-NULL
> current->reclaim_state, since a nested try_to_free_mem_cgroup_pages()
> would clobber the outer reclaim's current->reclaim_state (e.g. MGLRU
> dereferences current->reclaim_state->mm_walk); the reclaim_state
> check also closes the window where try_to_free_mem_cgroup_pages() has
> installed it but not yet set PF_MEMALLOC, reachable by a sleepable
> program attaching fentry to the generated trace iterator function.
> The size argument and the return value are both in bytes, matching
> the byte-based unit of bpf_mem_cgroup_usage() and
> bpf_mem_cgroup_page_state() so callers can mix them without manual
> page/byte conversions. An out-of-range swappiness is reported with
> (unsigned long)-1 rather than 0, since 0 cannot be told apart from a
> pass that reclaimed nothing.
> 
> Patch 2 (selftests/bpf: add memcg async reclaim test) ties the kfuncs
> into a worked example: it watches the WORKINGSET_REFAULT_FILE counter
> of a high-priority cgroup as a proxy for memory-pressure impact, and
> once it starts climbing, proactively reclaims memory from a
> low-priority cgroup via bpf_proactive_reclaim(), with the reclaim
> work queued asynchronously through bpf_wq. The test asserts that the
> monitored cgroup's workload finishes faster once async reclaim kicks
> in, and -- as timing alone cannot distinguish a working reclaim from
> a no-op one -- that the BPF program actually made reclaim calls and
> reclaimed bytes, via counters it exports through its .bss. This
> demonstrates the end-to-end use case: BPF observes pressure on the
> cgroup it wants to protect, and reclaims from the cgroup it wants to
> reclaim from, in one self-contained mechanism. Note that, without
> bpf_thread_wq, the CPU cost of the reclaim work is not yet attributed
> to a chosen cgroup; that part waits for the async primitives work
> mentioned above.

All of this is unnecessary text. You don't need to explain the patches here and
then again in their commit messages. Please remove this explanation.

Also don't need to give history. Just explain why you want to add memcg reclaim
kfunc and what use-cases you are looking into. (Ask your AI to be very concise
and precise).


