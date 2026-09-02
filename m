Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19925C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C691C6B00F0; Wed,  2 Sep 2026 07:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C199D6B00F2; Wed,  2 Sep 2026 07:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07A96B00F3; Wed,  2 Sep 2026 07:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 807396B00F0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:51:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFAE38019B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:51:47 +0000 (UTC)
X-FDA: 85168657854.06.D397AA5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id D684340002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:51:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=utU69Eaw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788349906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adsSQxYfF/J3n4w7pf0UDM1LQF011MuhCMak8/JCl2U=;
	b=aPxl3cWLtyHIz1lNufDhI+3m8KRQ2JveOeFWMBIRm1FZZJmoxyzenZjiWoquIUQ4O1bb5F
	TVneql2AlsOL2+irT5HfTvQcMULu787XqBsOY0ODOjvyuaXDsA79miDsJIzSD9ckrQFIMR
	23PtREvjTgQ9JhjA6WQSob1nbAATgu0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=utU69Eaw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788349906;
	b=wDafhBVL41IQK/J11M0mtCoPOnwMgxr6lP4wYjmvU8jvjDPy8PWG2tDohwwxvNKmg9l+LQ
	QZBbMSKOTZStOEZB2+BtJlBCgtqQZ35Ypx8EQX4C4yBaci2/gIJ6rITDMJKAaG+rpuXhJB
	s5Z9Os+nq539q2hjRTHs1Zi5E2UVT58=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E86A1596;
	Wed,  2 Sep 2026 04:51:41 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF1183F85F;
	Wed,  2 Sep 2026 04:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788349904; bh=OjkabxlGKBl4aBEOm+nXp42/GtJAc32K6YElqplzSCg=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=utU69EawSHaIa7SifqAKJTpR/T+bsUhLWBR5ZKDTTro4gizFsDJp84nnp/c6rT1g/
	 KXukxy0jCqxIlB9g/21gg997lnhA5oFhGl4LMkVGHiLaXosfvT49e6vfe9+RX91dW2
	 GBKKtOLaBMm9VvvsIRdmomZxT8uVg7leae7lIwQQ=
Message-ID: <afe6eac4-c8db-4ec7-98be-1c7cb0d3c1de@arm.com>
Date: Wed, 2 Sep 2026 12:51:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: Yang Shi <yang@os.amperecomputing.com>, cl@gentwo.org, dennis@kernel.org,
 tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, david@kernel.org, akpm@linux-foundation.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ue1ftyp4dit47ckjnh57tjcgs98iu36
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D684340002
X-Rspam-User: 
X-HE-Tag: 1788349905-186933
X-HE-Meta: U2FsdGVkX1+GjEyUqTmoRaFsldJODi1q6t0AaHxEyAwu5KaRBOy8q/a7k2dXk37jfTgD6liPMZ9Ztj0LffWOIetECOxXzpJ3LrfOMyM3r5OJZt6Y5hqh4TrEt3/sCciZhaitAfShkyvK+LHTvcS6ieJPgwgYmpMnQJQlb8G4tOjvOY5cTGz13X0lW/oaovNCzyE/YpryTbKU57Temsxm03iPZEKMlWAUOU1KjsaqE5PTmdqRWS4J3urVxCwIL2qseFyLRIE8PXfHW5Op5dXAjR0qcdpSAGV0xFSY7bAqwk8oBdr+umY3C4K7iE4i86NZ3OTcG9pYop5Vin26ghkTpOjEtNYRL3V6xVrIO4klbSLir+Rud5cgK+H7nDHQhHREek8QZNAZaHHRy6GY/SKzy4rqXjH83wBhvHYUCwym2WutgMbrzqEmtIdA9VuoFLqNqmFKtPppUc88Gv725hLXF6snw9Xpe7pAa6Dv0WdcWqkDTkLrxCBrXG4ybTQ+qvC6TBu+WkL3Hyssh+Zn7E4M0qnR+9Su0Yr+v47rCy69qFrskVvefSxfphW+NDf9U+DH2rjqsvM6gxExUtVopZfGAmJfDFgOulaa+Feyu9uO+AnvfBnn5eXt9Uiz92w9WUlBsl5hmNro0GLlDVnJM/894RfdZG/Zhf/8BYaShjhQTrndPKlsZQgmd501Hjfxuypc+FKlKQGhZzmlAsPRfdzd2r5TxRy0iuYN2FBfpQNrVH+mdr8aYUEsKUkOQ/9SGXNTa1Z/YNH2UU+1eiKt8cekj4PTNcj3uxZpOafBGOu89nYB9KJLnHf19Zz0SRqNpHjiMWD+90zhxGuoSfkxhRrADl6Bd55dlCzCav4FjeNCAQlfuLoO6ZV/06gz4fTbD7akSdW4dmWSBLcJc3kW8+s+N7Ox8gmXmPzmaAe7g6RI2A+pfwjXlCqpXmkPEY43JjpEPJqbAZ6OFsfXfcT5WuR
 37CGb7AS
 6tJJjM55FpJ2sb9CyLJqspgoxVoPagiM7EZ9+++tLkcuPuL5QnprKywqsbmGIiejrV4gm82RyWuz67zUYJ728Sk4igzKFDjVtVIqoYQba1Tynr5qt+O4l+4mQeO67WMr6HpIXLuIll7bpoO4HyzGOq7KjFLkDOXAaZYYH3rQOiO5XN62Rz9YAdlrY/Ui0u6v6mmVKmjIAuePVMMgRgS3OV0SyWROkxt7rx7qdWz2JbWD47eWL+H+WHDBboMeVtX35L2fSitaMjK70gLKB/9Tl21Ra/E1fl5n30CQYkzrUt+mD59luctbdseTfvqg3a+vIQB2PJm8Hkw8lch0wAY/be0dW2NuOoCpJw/nyoadIPND5NgSmKKpkJku5Sfie6b06wGYixkEvBVZQFBQ6xPQz4Ztwm3ehNfW3XERi9Acn2rk8JZVli+MqeAIEx17HKM5sZBSe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/07/2026 7:04 pm, Yang Shi wrote:
> 
> Hi,
> 
> This is v2 RFC. In v2 a lot problems found out by Sashiko were fixed and more
> feature gaps were closed (please see the below changelog for the details).
> Although there are still some open issues, for example, it just can support
> 48 bits VA (for 4K and 64K) and 47 bits VA (for 16K), KPTI support has not
> been solved yet, etc, but I think the delta should be big enough and worth
> a new RFC to gather comments in order to make sure I'm on the right track.
> 
> Some more benchmarks were done, for example, some latency related benchmarks
> that I mentioned at LSFMM because I thought responsiveness should be improved
> due to the removal of preempt_disable. Collected more PMU counters as well.
> Please refer to the benchmark section for more details. 
> 
> Look forward to comments.
> 
> 
> Changelog
> v2: * Added 3-level and 2-level page table support.
>     * Tested with 16K and 64K page size. But we just support 48 bits VA (4K
>       and 64K) and 47 bits VA with 16K for now.  Please refer to the below
>       "known issue" section for the detail reason.
>     * Added support for memory hotplug.
>     * Added support for KASAN (generic).
>     * Treated percpu and local percpu area address as vmalloc address.
>     * Fixed build failure for x86.
>     * Fixed build failure for !CONFIG_NUMA.
>     * Added KASAN support for local percpu area.
>     * Some other misc bug fixes found out by Sashiko.
>     * More code refactor and cleanup.
>     * Regorganized the patches.
>     * More benchmarks, refer to benchmark section for more details.
>     * Rebased to v7.2-rc1.
> 
> 
> Introduction
> ============
> This patch series implemented the LSFMM 2026 proposal for optimizing
> this_cpu_*() ops on ARM64. For the details of the proposal, Please refer to:
> https://lore.kernel.org/linux-mm/CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com/
> I didn't repeat it in the cover letter because there is no change to the
> proposal.
> 
> The series is based on 7.1-rc1. It is basically minimum viable patches.
> There are still a few hacks in this series and it may break something,
> for example, KPTI, SMT machines which shared TLB, etc. But it shoule be
> good enough for now to demonstrate the core idea. The main purpose of the
> RFC is to gather feedback, figure out missing parts and risks, and make sure
> we are on the right track, as well as hopefully it can help the discussion
> for the upcoming LSFMM.
> 
> I broke the patches down to arch-dependent and arch-independent parts so that
> hopefully the interested persons can do experiments on other architectures,
> for example, S390, easier.
> 
> A new kernel config is introduced, HAVE_LOCAL_PER_CPU_MAP. The architectures
> which can support this feature will select it. Allocating and freeing percpu
> local mapping is protected by this config so that others won't pay the cost.
> 
>  
> Known Issues
> ============
> 1. KPTI
> -------
> We need determine what CPU we are on, then switch to the right page table.
> Currently arm64 kernel fetches tramp_pg_dir via swapper_pg_dir - fixed_offset,
> and fetches swapper_pg_dir from ttbr1. But ttbr1 may not hold swapper_pg_dir
> anymore except CPU #0. So we need to figure out the other way to handle it.
> Switching to tramp_pg_dir should be easy, but the reverse seems harder because
> tramp_pg_dir just maps the trampoline vectors.
> Maybe we can do two steps switch. Switch to swapper_pg_dir at the first step,
> then switch to per cpu page table (for entry) or tramp page table (for exit).
> Nobody should call this_cpu_*() at either userspace -> kernel entry stage or
> kernel -> userspace exit stage.
> 
> 2. SW PAN
> ---------
> Has the similar issue as KPTI. It installs reserved_pg_dir to TTBR0 when running
> in kernel space, but fetching reserved_pg_dir via swapper_pg_dir - fixed_offset.
> Maybe we can save the physical address of swapper_pg_dir in a variable, then load
> it from that variable instead of ttbr1.
> 
> 3. Shared TLB machines
> ----------------------
> Some machines may share TLB between CPUs, for example, SMT machines may share
> TLB between the two hardware threads in one core.
> The per cpu page table just can't work with it. Maybe we need a new
> cpufeature to indicate whether per cpu page table is allowed or not. Then
> just enable it for not-shared-TLB machines.
> 
> 4. Don't support all VA bits
> ----------------------------
> We just support 48 bits VA (4K and 64K) and 47 bits VA (16K) for now. For 4K
> and 64K, supporting other VA bits is not hard, we just need to determine the
> size for percpu and local percpu area.
> But it is harder for supporting 48 bits VA + 16K page size. We just have two
> top level kernel page table entries with this configuration, but we assume we
> just need to sync up kernel page table at the top level for now. We need to
> sync up kernel page table at the second level in order to support it. I'm not
> sure whether it is worth it or not.
> 
> 
> Benchmark
> =========
> The benchmarks are done on 160 core AmpereOne machine. The baseline is
> v7.2-rc1 kernel.
> 
> 1. Reduction of kernel text size
> --------------------------------
> The patchset can reduce at least 11 instructions for this_cpu_*() ops. Both
> preempt_disable() and preempt_enable() need 4 instructions to manipulate
> the preempt count, and preempt_enable() needs more instructions (compare +
> READ + compare) to determine whether reschedule is needed or not.
> Because this_cpu_*() ops are inlined and called in a lot of places so we
> can save a lot of instructions.
> 
> The size of kernel text is reduced by ~184KB with default Fedora kernel
> config. This also helps reduce kernel icache miss rate and stalled frontend
> cycles as kernel build benchmark result showed.
> 
> 2. Kernel Build
> ---------------
> Run kernel build (make -j160) with the default Fedora kernel config in a
> memcg.
> 13% - 18% sys time improvment
> 3% - 7% wall time improvement
> 
> 5% fewer kernel icache miss, 5% fewer executed kernel instructions and
> 15% fewer stalled frontend cycles for kernel.
> 
> 3. stress-ng vm ops
> -------------------
> stress-ng --vm 160 --vm-bytes 128M --vm-ops 100000000
> 8.5% improvement
> 
> 4. stress-ng vm ops + fork
> --------------------------
> stress-ng --mmapfork 160 --mmapfork-bytes 128M --mmapfork-ops 500
> 15% improvement
> 
> 5. Specjbb
> ----------
> The specjbb test latency curves showed the patched kernel has consistently
> lower p99 latency (the lower the better) than the baseline.
> 
> 2.5% improvement on max-jOPS and 4% - 5% improvement on critical-jOPS.
> The specjbb benchmark is quite sensitive to latency and responsiveness, 
> particularly critical-jOPS result. The patches are supposed to improve the
> responsiveness due to the reduction of preempt-disabled critical sections.
> 
> 6. MySQL
> --------
> 1% - 2% gains on read-only test, 2% - 4% gains on write-only test. Also see
> 15% decrease on frontend cache stall.


tl;dr
Comparing GPR approach [1] with this series gives 8 improvements and 3 regressions.

Fastpath is a Linux kernel performance benchmarking service. The table
compares the both patched kernels: positive values are faster, negative
values are slower, and (I)/(R) indicate statistically significant
improvements/regressions. Unmarked differences are not significant after
accounting for confidence and noise thresholds.

+---------------------------------+--------------------+-----------------+-----------------------+
| Benchmark                       | percpu-pgtable [2] |   gpr-fixup [3] |         gpr-fixup [3] |
|                                 |    vs baseline [1] | vs baseline [1] | vs percpu-pgtable [2] |
+=================================+====================+=================+=======================+
| lmbench/lat-mem-rd              |             -0.26% |       (I) 1.24% |             (I) 1.50% |
| micromm/fork                    |          (I) 1.10% |       (I) 2.46% |             (I) 1.35% |
| micromm/munmap                  |         (I) 18.10% |      (I) 19.78% |             (I) 1.43% |
| micromm/vmalloc                 |         (I) 11.92% |      (I) 14.68% |             (I) 2.47% |
| mmtests/hackbench               |              0.27% |       (I) 1.09% |                 0.81% |
| mmtests/kernbench               |          (I) 1.19% |       (I) 1.18% |                -0.01% |
| mmtests/sysbench-cpu            |              0.01% |           0.06% |                 0.05% |
| mmtests/sysbench-mutex          |             -0.85% |          -0.14% |                 0.72% |
| mmtests/sysbench-thread         |         (R) -4.49% |       (I) 3.02% |             (I) 7.86% |
| perf/futex                      |              0.55% |      (R) -2.80% |            (R) -3.34% |
| perf/sched                      |          (I) 1.61% |          -0.39% |            (R) -1.97% |
| perf/syscall                    |          (I) 1.54% |           0.98% |                -0.55% |
| pts/memtier-benchmark           |          (I) 2.37% |       (I) 2.51% |                 0.14% |
| pts/nginx                       |              0.42% |           0.96% |                 0.54% |
| pts/perl-benchmark              |          (I) 1.83% |       (I) 1.63% |                -0.20% |
| pts/pgbench                     |             -0.09% |           0.55% |                 0.65% |
| pts/pybench                     |             -0.05% |          -0.07% |                -0.02% |
| pts/redis                       |             -0.00% |          -0.04% |                -0.04% |
| pts/sqlite-speedtest            |              0.15% |           0.44% |                 0.28% |
| repro-collection/mysql-workload |              0.73% |           0.25% |                -0.48% |
| schbench/thread-contention      |              0.42% |       (I) 1.04% |                 0.61% |
| sockperf/echo-lat-tcp           |          (I) 2.88% |       (I) 1.69% |            (R) -1.16% |
| sockperf/echo-lat-udp           |          (I) 3.93% |       (I) 5.11% |             (I) 1.14% |
| sockperf/packet-tp-tcp          |             -0.41% |       (I) 1.37% |             (I) 1.79% |
| sockperf/packet-tp-udp          |          (I) 1.45% |       (I) 1.49% |                 0.04% |
| specjbb/composite               |          (I) 1.39% |       (I) 1.65% |                 0.26% |
| speedometer/v2.0                |         (R) -1.04% |      (R) -1.04% |                 0.00% |
| speedometer/v2.1                |             -0.10% |           0.10% |                 0.20% |
| syscall/getpid                  |             -0.98% |           0.52% |             (I) 1.51% |
| syscall/getppid                 |             -0.43% |           0.14% |                 0.57% |
| syscall/invalid                 |          (I) 3.06% |       (I) 3.56% |                 0.48% |
+---------------------------------+--------------------+-----------------+-----------------------+

[1] v7.2
[2] v7.2-percpu-pgtable (this series)
[3] v7.2-percpu-gpr [1] (Based on email review, we fixed SDEI to restore x26
    instead of corrupting x22, and adjusted this_cpu_write() helpers to
    avoid GCC overflow warnings.)

The constraints/workarounds for the per-CPU page-table series were supplied as
this Kconfig fragment for all the different runs.

CONFIG_EXPERT=y
CONFIG_ARM64_4K_PAGES=y
CONFIG_ARM64_VA_BITS_48=y
CONFIG_ARM64_VA_BITS_39=n
CONFIG_ARM64_VA_BITS_52=n
CONFIG_ARM64_PA_BITS_48=y
CONFIG_ARM64_PA_BITS_52=n
CONFIG_UNMAP_KERNEL_AT_EL0=n
CONFIG_ARM64_SW_TTBR0_PAN=n
CONFIG_KASAN=n

[1] https://lore.kernel.org/all/20260804170503.3513916-19-mark.rutland@arm.com/

> 
> 
> Regression test
> ===============
> 1. memcg creation
> -----------------
> Create 10K memcgs. Each memcg creation needs to allocate multiple percpu
> variables, for example, percpu refcnt, rstat and objcg percpu refcnt.
> 
> Consumed 2112K more virtual memory for percpu “local mapping” and a few
> more mega bytes consumed by per cpu page tables.
> No noticeable regression was found for elapsed time.
> 
> 2. fork test
> ------------
> stress-ng --fork 160 --fork-ops 10000000
> fork() needs to allocate multiple percpu variables, for example, rss
> counters and mm_cid_cpu.
> 
> Roughly 1% regression was found. However stress-ng fork test has quites
> small address space, the real life workloads typically have much larger
> address space and do more complicated works. The stress-ng mmapfork
> benchmark saw 15% improvement.
> 
> 
> The organization of patches
> ===========================
> The refactor and prepatory patches (patch 1 - patch 4)
> Percpu page table support patches (patch 5 - patch 8)
> Local percpu area support patches (patch 7 - patch 15)
> Use local percpu area for this_cpu ops (patch 16)
> 
> 
> Yang Shi (16):
>       drivers: arch_numa: move percpu set up code to arch
>       arm64: kconfig: make percpu related configs not depend on NUMA
>       mm: pgalloc: introduce {pud|pmd}_populate_sync()
>       vmalloc: pass in pgd pointer for vmap{__vunmap}_range_noflush()
>       arm64: mm: enable percpu kernel page table
>       arm64: mm: defined {pud|pmd}_populate_sync()
>       arm64: mm: sync percpu page table for memory hotplug/unplug
>       arm64: kasan: sync up kasan shadow area page table
>       arm64: mm: define percpu virtual space area
>       mm: percpu: prepare to use dedicated percpu area
>       arm64: mm: map local percpu first chunk
>       mm: percpu: set up first chunk and reserve chunk
>       arm64: mm: introduce __per_cpu_local_off
>       mm: percpu: allocate and free local percpu vm area
>       arm64: kconfig: select HAVE_LOCAL_PER_CPU_MAP
>       arm64: percpu: use local percpu for this_cpu_*() APIs
> 
>  arch/arm64/Kconfig                   |  12 +++++++---
>  arch/arm64/include/asm/mmu.h         |   5 ++++
>  arch/arm64/include/asm/mmu_context.h |   9 +++++++-
>  arch/arm64/include/asm/percpu.h      |  37 ++++++++++++++++++++++++++++-
>  arch/arm64/include/asm/pgalloc.h     |  24 +++++++++++++++++++
>  arch/arm64/include/asm/pgtable.h     |  37 ++++++++++++++++++++++++++---
>  arch/arm64/kernel/setup.c            |   3 +++
>  arch/arm64/kernel/smp.c              |  44 +++++++++++++++++++++++++++++++++++
>  arch/arm64/mm/kasan_init.c           |  47 +++++++++++++++++++++++--------------
>  arch/arm64/mm/mmu.c                  | 165 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
>  arch/arm64/mm/ptdump.c               |   4 ++++
>  arch/riscv/kernel/smp.c              |  51 ++++++++++++++++++++++++++++++++++++++++
>  drivers/base/arch_numa.c             |  51 +---------------------------------------
>  include/linux/mm.h                   |  11 +++++++++
>  include/linux/percpu.h               |   4 +++-
>  include/linux/pgalloc.h              |  13 +++++++++++
>  include/linux/vmalloc.h              |   3 +++
>  mm/Kconfig                           |   9 ++++++++
>  mm/internal.h                        |   5 +++-
>  mm/kmsan/hooks.c                     |  14 +++++------
>  mm/percpu-internal.h                 |  14 +++++++++++
>  mm/percpu-vm.c                       |  94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/percpu.c                          |  58 +++++++++++++++++++++++++++++++++++++---------
>  mm/sparse-vmemmap.c                  |   4 ++--
>  mm/vmalloc.c                         | 138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
>  25 files changed, 712 insertions(+), 144 deletions(-)
> 
> 
> Thanks,
> Yang
> 
> 


