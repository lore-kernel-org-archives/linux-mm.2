Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E09C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B2B6B014B; Thu, 16 Jul 2026 11:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDBCB6B014F; Thu, 16 Jul 2026 11:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19196B0150; Thu, 16 Jul 2026 11:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8282C6B014B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:49:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3040C8016E
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:23:40 +0000 (UTC)
X-FDA: 84994707000.23.49D6F35
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 57D4BA0015
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:23:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YmA+a8I8;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784208218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CrvuIFYY2f4D2HEiJ9xQ8WRFx52lb1g37g+jTqeDy40=;
	b=NGE7aX0i1U+zHHWk9l0fDI+f8a5Wul/bD2hCKnVcf4RM1dh84BayPsdekPYJl+pmX+WpLp
	eyx8R5w/K82HA+YOgZ3uhVXv4L82TYHc1QCudgvfeDm0o1QfQDKCXeWoD3A5vqc+8zdMjw
	wJXtStuS3cxfJvfGDWYwTYS/DPhrVTY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YmA+a8I8;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784208218;
	b=sD+K+1NiIvE3LR9j/wRu1MZrmfKmAHX3k5eCPRn32qAbjf0ZNF5wQRduDHJ16EtvRJLLlD
	YxcGwco6l8z9TlMU74cMA+k+BkXIvoam35mAPBWLBj4oOml/dcUOHmtFqW7SVkpTlllBQ1
	5U1bqLdIj8ApOqJ82skFX3Ve355JPm4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B4021476;
	Thu, 16 Jul 2026 06:23:33 -0700 (PDT)
Received: from [10.57.84.219] (unknown [10.57.84.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E0C13F905;
	Thu, 16 Jul 2026 06:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784208217; bh=RHa8B7+Au2MNq9YT4sMqtFQA1xDYfuoVtvK0/lpica8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YmA+a8I8JDrDfOgtVcZ5AUcyhiYuVhXaY9HD+zLLHsWXcEuDJoxNa4jUSaGV3N3EL
	 JRN50FhcyQBbnlVd2RNJeLH7TKRN89i3f+ZU5LcmQme7+xpSsnioux90mIp9N8IQ8P
	 yR13N0030qGl5SVkIshYmmiH0JjguX/WZ6m0T+9c=
Message-ID: <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
Date: Thu, 16 Jul 2026 14:23:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Content-Language: en-GB
To: Yang Shi <yang@os.amperecomputing.com>, cl@gentwo.org, dennis@kernel.org,
 tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 david@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57D4BA0015
X-Stat-Signature: 3qd85wo83qcktgaab6f8oio61ih553wm
X-HE-Tag: 1784208218-168162
X-HE-Meta: U2FsdGVkX19NqKOR83SD0WK6D5uf4Tamn47MBPOkjx+HZf+FawOZr/TZ8oRD/732I0Qirw/lHvfNx4dPD3BFhE74bHVmKUwVVsiyMfMZ8ASIhD9D2NwDxtdQ36vHUCPn5kaY5Y0ZXszGKswicu+pWgHew607r9CsRLp3W+onhKCUTNKAA/eLZRZOvdRcJkNk2w1QK5UYL3P0MJm6GezWrTKzCxKzPDHcbjHWQILHjdBtk0XPvWhKL3sx69/erZh7I805S99qpHBq6qNpwW+rgnO8ChoY9pr+5uBqTtejyzL8UWpiaVHaDSIS78zOzKkK+fSC/pzjVelI/Nu5uEFSTLUQRlOIAJAfUWmLUiC6bci8MjQEPXK/XR/w4nSqIA8x4fwtyWJIKM5Kxa+2xUtynXHODIgMKZO/fUDv0/oBR8EY2Zf3qVgs9RzhSjIqpITxm+f6sw7WYXrgpM2VQbAJqEZW2WcXS6NBBZn+KPDVVgQihnmK8Eke4mF1baHiRswL2YnV/OLw9a10TA6EVoCtQqgo3sy8M/1m5IPjPQ6/lN+66A/ZAk758UqmvRxizHm3QuZznTnfOkebDtZ5ZayeeNBFfXFf+XkrFYFK4gtfjOQFpMVz46ROuQ+VWV/sNo2KHBAI1vGLo/Hzy1LGmV+yEsdK1ou9APZk9Bk9pTSEHW66Ez5biEvaAtElUmFDxAWuXx+KEK+TCd9mlZ4Ko69quKiYzFcx4rUgVBPU+s0+inzQw9aY1OsioFfUbvOX4YcPMpDArmaA1uudLvj1gLCDkV3omwDQrc8MzH9Y2v4nXoBBO6aCa1b9GVDTdIOn2159UmT21JxKKKEAAMx69dc/qOaIna8TG2qkJHLQsm4w1MtWou4N3mZvlhvOeS08tPbtZQQV/rW7xscTgPEGRLCrWDI/q4heo+5QqqIKI3DjSktSiW7ZsFzSMKphUulOavGxZ4hDw4ulCUNcCCJS67S
 3iSBUoRS
 3nZx/c4pcLufIhp2kDSTCEYWs9JJCqmAObWeE4jZ9q2281tyJEPMLxvJVFUHdLW+AIlmlC9Bv5GFUkXw1CiHjqwyosWYFJfuxLWO70T+g4tM6ee/nadD7xe7fQaKRE9IErGq/UvrReyOCwolexCm6rLNsNBqXJ4omzwS9/ncQOo7/5iDyW1Hbf78MCEBNEQNy8dMByNJbU3Cr8acK/eyaeUShTPTevAdkIgtVQQVafoZnAuqBXeg2tzqPgd2T3XH60anwiM6ZPd8JUhkv+JRA8BhBJYX5oA2k/otK/8mqz7/aktZA8pGmTelEvF8R1O2t8Y3W+zJOfYBdPLziRalwwIdqzh7Olvs2hkG94h01dmvYkjm2RxG2QglOnGW6qXSdVLCqUkYv7Fi17MDiO+UpUkewiJedOAIroZwZggIA3DlmSPh1BblCdvxnoAnhl7BNkYQD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/07/2026 19:04, Yang Shi wrote:
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

Hi Yang,

When we spoke about this at LSFMM, I said I would take the series for a spin on
other hardware to see if the performance gains generalise. I did make a start on
that but the kernel wouldn't even boot and I never found time to debug. Sorry
that I didn't let you know sooner.

But I think that there are other issues with this concept that likely block it
from being accepted upstream; see below...

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

I think this approach is a bit of a sledge hammer to crack a nut. If the problem
is the cost this_cpu_* ops on arm64 due to the need to disable/enable
preemption, I think we can solve that much more simply with [1], which
introduces in-kernel restartable sequences. Using this, the operation no longer
needs to disable preemption but can instead just detect when it is preempted and
retry.

[1]
https://lore.kernel.org/all/20260223163843.GR1282955@noisy.programming.kicks-ass.net/

We have observed a few performance regressions recently, for which the root
cause is increased use of this_cpu_*. We have somebody at Arm about to start an
investigation into whether in-kernel rseq can solve the problem.

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

The architectural feature you're referring to here is FEAT_TTCNP (common not
private). There are many CPUs out there that use this feature (not just those
that support SMT).

FEAT_TTCNP is mandatory from Armv8.2 and the presence of the feature only tells
you whether you can legally set the CnP bit - it doesn't actually tell you if
the HW does any sharing - there is no way to detect this. So making per-cpu
pgtables mutually exclusive with CNP is a non-starter as all CPUs from v8.2
onwards advertise CNP.

Even ignoring the CNP problem, you'll end up installing the per-cpu TLB entries
tagged with whatever user ASID happens to be installed at the time. Which means
you could end up with lots of duplicated TLB entries all differing only by ASID.
It's probably not the end of the world, but it seems... inefficient.

The only way I can see to make this work fully is to rely on FEAT_ASID2, which
allows specifying separate ASIDs for TTBR0 and TTBR1. Then each CPU can have
it's own (permanently installed) ASID for local mappings in TTBR1. That would
solve the CNP issue. FEAT_ASID2 is optional from v9.4 and mandatory from v9.5.


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

If your proposal is to only support per-cpu pgtables for certain VA
combinations, I don't think that will fly. We'd have too much of a test burden
for these different configs.

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

These gains all look great but I expect we will see similar gains using the rseq
approach, which is simpler and can be applied universally.

Thanks,
Ryan

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


