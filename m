Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1FDC606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ZunCuudQ
Received: by kanga.kvack.org (Postfix)
	id BDED86B0339; Fri, 23 Oct 2026 02:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8FC56B033A; Fri, 23 Oct 2026 02:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5596B033B; Fri, 23 Oct 2026 02:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 861156B0339
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:32:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03C031A02D9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:32:54 +0000 (UTC)
X-FDA: 85352923110.27.5F9F96B
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C91040004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:32:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZunCuudQ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/KkeSW0iJwwqF3dTal22x/IVE71KQpeS559w4ryEuE=;
	b=xBZgfHX0vBH9LcrbjEWSdCf3FHaHHWLsGgwFT7wdpzGUQkPm4BiUNjYNHbec//vXGs7cJ4
	5SLAszQSErOflpzkVblIRshHK+9fRV1lbBR4FrFLPiNnFpG+f6ERt5LprEiConMRw4Qx+K
	20sr0cpk+sfl4hURy1cqxewy0FjlXuE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZunCuudQ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737173;
	b=lRvIoyp54SMcWvRvCq9hAcR9GxxGdmID+cT8a4nquqqzCKI5iEWZifIRy3IySw4IbkZsJc
	fcb3jV5epN3Q4jbHrntkUt0YnODKz41NVXB9skOOHJ0sETB/7lQRm87rVNQGGq9zT62F1C
	IYzZx5YLXdqasu8MjJGL3MlUoX2BEto=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792737158; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=A/KkeSW0iJwwqF3dTal22x/IVE71KQpeS559w4ryEuE=;
 b=ZunCuudQz4sc9UuX1ESe/ATn26vRhp++gXavBXjrKaHnJU56X9Rlw4VohHcBtmWcla3Hln
 3Y6ph4OaBoN2Kvv19x6ZuQIlcqiA91Ekf5U315QjVc0Jy8TFADK+rx42J4kh2/hE5IQ6hX
 cLQt+QIUK1/x8wfJEpCt7XApTdjGJGjbtnXBMLqs7nfoZ7DyHYpSIetABw2PR3OwO+Hmt3
 RqkGcDfCbcQW+SpelP/ZMADf4Kfh64E6uuJ9rG7nKMuCFTfsMUPJczP/biADXu1nAYpT/J
 Cm7MCVlga+ealsDvcK5JvolBOmGANKCnBoKiyfi3sYoiLs96LdRtVu6L64XaBQ==
User-Agent: Mozilla Thunderbird
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 bpf-next 0/5] BPF-based per-cgroup NUMA balancing mode selection
Date: Fri, 23 Oct 2026 14:32:08 +0800
References: <20261019064157.29885-1-laoar.shao@gmail.com>
To: "Yafang Shao" <laoar.shao@gmail.com>, <ast@kernel.org>, 
	<daniel@iogearbox.net>, <andrii@kernel.org>, <eddyz87@gmail.com>, 
	<memxor@gmail.com>, <mingo@redhat.com>, <peterz@infradead.org>, 
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>, 
	<shakeel.butt@linux.dev>, <roman.gushchin@linux.dev>, 
	<yu.c.chen@intel.com>, <zhao1.liu@intel.com>, 
	<tim.c.chen@linux.intel.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <f68e7f9e-6037-4087-b7cd-a17ea4dba279@bytedance.com>
X-Lms-Return-Path: <lba+26adaff84+f8ede6+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <20261019064157.29885-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C91040004
X-Stat-Signature: fupq9rtcmnobc145so938tr8tewrtqa6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792737172-639576
X-HE-Meta: U2FsdGVkX1/pOruAxlrLOvyfPQYs2qdvxhbZv1GFjc13/90RPUBsCuR8HDZwuCjy7axsn3BU/U7jDTzIFhpTXEJNO1i1oOkCWbuZfw4vokNtzK+Ci65kkbqHyvY1r3QEEa1GcBjpVCF+Tdfcu8f+60hNxDGbHXNErmmm54pp/UOQcRxJCVLCAGPk4DaxuEE6liSptf6yoAdBLKp01ELEivvgD6T7GGYQaRNa51iJ9JOMPUxbcIicy/lpSwphDLRfEYq+GYmeOk60RS6A4uCMPBZEeCueV3bl4zKP0TQeaNbmtokmW1WenrhAfzSAIT74YS8b766HVWz7fIGcn4w9Xk1UuS4YXD6ktdfbjAnjB9rXsEfO9A1ERQXuszBI5gblZ4HswUw0guSJ3noZGFKlylsgNvCnopT09zcORwrlEUvBiM85EJAkIPZGbs/bBjXTSbxR7xzhmpVvyfHKyoB/t/iispCv9VbW1wST4ECz8vAvcKzeIPayK2KX/G+vJnq0vyP9FvIhTyBwfy5yQoNa1Pw7eBdAPHs1jFWs2VFcwZN9dArzOFntUAeiEkgCknsuwjgma+xHx4XxUKLuZPanq2hFXLuy0YS3z7xOAQYDHfQjU69wfgRNaov421bElw6Vc3P4dhnUh/vtarmSfggHye32GlACGuG2iDf6CXEq7vQxaIQnoSv2Ns3B1F+o/6vb2O2c3Dlv/pdM2TjQ7rpR2YCxHkap0frMyJi1DwUZbrR8DgPx0fM9fpY+7weR9mgVCKO/nY7wxk5pRVndG7yWkyDJz6y6AWPyxW35SuFRNm4rfljCZxdUj2kR+QQaLEnav0loEpnqzTY9AmmkxuDqr+CM3GeWViwWbBIiyqNjkdCK/R5FGaBp3nwEf50XuAlOVu8EVBbr9Pq1RgrJ10OLS+IEfFAllGuy9u8/+Wvvccoi4DcyJoAREe2zrSw0CyKJH6RfzDZCViwOexfSHpi
 6hcLf4rf
 Q6QDldJBvcz/g/hwQqW9Sg83vznreVFfbhUBHOKETozUHXootPDHZlAmLhJY1GZIEAbHx9c1tmdjzewuV6AUSBcvuniLRskkPjBZuv+HeB/hW79rmn/2kfnzv6Fx94+lAbjT6h27aQaKB71cgzRFyqMH+0z/SRseufahUlbLuT5NbDkL10X8g4UHizBXQjzUD+OtCzmxKw4AhlVtyjdwQkoC5vV5El9cJgS8OUEuQNatSl2O024zmYGtWL8yY7QL0KnWj0jDTba4D6wTZaf5O1D0PF05VyrvovxrYtnSnfxvN9uOye5zP44yDpclrSh/jhO/0ytAiBdKnUa2BXc7WA1emwRfaG9GYe911Xh0MtUoFSSb5MPDA7elGuZYAIXwqW8psFqJNOBOFobTH/wc0718mf+GQTXBMIGLM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 2:41 PM, Yafang Shao wrote:
> The Problem
> ===========
>
> In our large fleet of Kubernetes-managed servers, NUMA balancing has
> been historically disabled globally on each server. With the increasing
> deployment of multi-socket AMD EPYC servers, cross-NUMA access has
> become a critical performance issue, which made us reconsider enabling NUMA
> balancing to address it.
>
> Enabling NUMA balancing globally is still not acceptable since it can
> introduce latency spikes for latency-sensitive workloads. What we need is
> to choose per workload whether NUMA balancing runs at all, and which mode
> it runs in. A latency-sensitive service wants NUMA balancing disabled,
> while a batch service wants its PMEM-resident memory promoted when hot
> without paying for scheduler-driven migration. No single global setting
> serves both.
>
> The Design
> ==========
>
> This series introduces the fine-grained per-cgroup NUMA balancing
> control. It grows out of Tejun's suggestion to store the existing
> NUMA_BALANCING_* bitmask per cgroup and expose it through BPF kfuncs.
> cgroup::numab_mode holds the request: NUMAB_FOLLOW_SYSTEM (-1) defers
> to the global sysctl state, anything else is a bitmask.
> bpf_numab_set_mode() writes a request, bpf_numab_get_mode() reads the
> combined request of the cgroup and of every ancestor back. The hot
> paths walk the same chain at read time behind a static key, so while no
> cgroup makes a request the overhead is one patched-out branch.
>
> An opt-out wins and binds the subtree: a DISABLED request anywhere in
> the chain opts the cgroup's tasks out entirely. Otherwise the requested
> bits OR together and the kernel reads them independently, the way
> kernel.numa_balancing reads them, so a combined NORMAL|TIERING engages
> both modes. A DISABLED request only speaks for the cgroup's tasks,
> never for its memory, which follows the remaining requests of its
> ancestors.
>
> The cost of the additive combination is that an ancestor cannot cap
> tiering short of a full opt-out: a descendant's TIERING request
> re-engages promotion for its own memory, and promotion is the mode that
> consumes the shared fast tier.


I am not sure that this matches the usual cgroup hierarchy semantics.
If promotion consumes the shared fast tier, why is a descendant allowed
to re-enable TIERING when an ancestor cannot cap it short of a full
opt-out?

Thanks,
Zhe

>
> The readback contract is worth spelling out: bpf_numab_get_mode()
> returns the combined request of the cgroup and its ancestors, and the
> kernel reads it the same way it reads a single request, each bit
> independently as kernel.numa_balancing does, so a combined
> NORMAL|TIERING engages both modes. When any cgroup in the chain makes a
> request, the value read back is the mode in effect for the cgroup's tasks;
> when none does, the readback is NUMAB_FOLLOW_SYSTEM (-1) and the sysctl
> decides. The answer speaks for the cgroup's tasks only: its memory follows
> the remaining requests of its chain when it opts out, and that folio-side
> view is not exposed by the kfuncs. These are deliberate simplifications;
> both can be revisited if callers turn out to need them.
>
> The sysctl's own documentation is untouched; the override is documented
> where it lives, in the CONFIG_BPF_NUMAB Kconfig help and the kfunc docs.
>
> The override was measured with schbench, 384 workers, on a two-node
> 384-core machine. Whatever kernel.numa_balancing is set to, a cgroup
> request puts the cgroup at the throughput of the equivalent
> system-wide setting, within a fraction of a percent: the override
> itself costs nothing measurable, performance follows the effective
> state alone. The two states themselves differ by less than a percent
> under this load.
>
> Changes
> =======
>
> RFC v2->RFC v3:
> - The struct_ops interface is replaced by two kfuncs, following
>    Tejun's suggestion.
> - Improve on the function naming and simplify the code (David)
>
> RFC v2: https://lwn.net/Articles/1099962/
>
> RFC v1->RFC v2:
> v1 keyed the hook on the memory cgroup and temporarily embedded the cgroup
> id into the struct-ops value, because the cgroup struct_ops integration was
> still under development. v2 attaches through the cgroup struct_ops support
> that has since landed in bpf-next, keys the task surface on the task's
> cgroup and the memory surface on the folio's memcg, and adds the
> memory-tiering mode alongside enable and disable.
>
> RFC v1: https://lwn.net/Articles/1054030/
>
> Yafang Shao (5):
>    sched: fix stale get_pref_llc() stub for !CONFIG_SCHED_CACHE
>    sched: use static_branch_likely() for the NUMA balancing tick check
>    sched: add helpers for numa balancing
>    sched: add BPF-based per-cgroup NUMA balancing mode selection
>    selftests/bpf: add tests for the numab kfuncs
>
>   include/linux/cgroup-defs.h                   |  10 +
>   include/linux/sched/numa_balancing.h          | 149 ++++++++++++
>   init/Kconfig                                  |  20 ++
>   kernel/cgroup/cgroup.c                        |  14 ++
>   kernel/sched/bpf_numab.c                      | 195 +++++++++++++++
>   kernel/sched/build_policy.c                   |   4 +
>   kernel/sched/fair.c                           |  33 +--
>   kernel/sched/sched.h                          |   1 -
>   mm/memory-tiers.c                             |   9 +-
>   mm/mempolicy.c                                |   3 +-
>   mm/migrate.c                                  |   7 +-
>   mm/vmscan.c                                   |   6 +-
>   .../selftests/bpf/prog_tests/bpf_numab.c      | 227 ++++++++++++++++++
>   tools/testing/selftests/bpf/progs/bpf_numab.c |  32 +++
>   14 files changed, 681 insertions(+), 29 deletions(-)
>   create mode 100644 kernel/sched/bpf_numab.c
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab.c
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab.c

