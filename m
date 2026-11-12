Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0707606A332
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZoZIiH6H
Received: by kanga.kvack.org (Postfix)
	id 25E156B05D1; Thu, 12 Nov 2026 07:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235606B05D3; Thu, 12 Nov 2026 07:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172276B05D8; Thu, 12 Nov 2026 07:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E752A6B05D1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:30:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E4D01C3DAA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:30:58 +0000 (UTC)
X-FDA: 85426401396.10.0DE9B77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E193D14000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:30:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoZIiH6H;
	spf=pass (imf26.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuB4RVeq47mAjcl8ywAJJuIZDoqz1GrNEVj9QlG7uxw=;
	b=q1YTuLcXribrHpT8DgNJKfhuS9716j+y5eZLozBC4VnGUbwHIdaEo2kdpKIz9RsCGkCPnI
	Uj52v8d5xyIo4Lf4ZiqjM2IYhd3i2sOQn7gRyA5yqP8OFnj2PgpDJtdUjz7rYclWxJ6ULw
	1irxaPSMi1WJIXm6n2BdmUFaUARH4n4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794486657;
	b=SHeFHmzEgV4vvt5ZEXdCSBowiuL8T5WU4qD+mX14F3I25emNLM2PMTXh+3P+RIMlkiSraT
	Sjfmb6ZBbYYirhKz+ZHeot2C3j2anbPGy7T/3Mp5uitMhbFnlmwGyffIjW6qUhbAyLqjGI
	h9xvLnGmoaooQaOFdHHC88Xcncy8PhQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoZIiH6H;
	spf=pass (imf26.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5901260CFA;
	Thu, 12 Nov 2026 12:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554231F00A05;
	Thu, 12 Nov 2026 12:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794486656;
	bh=HuB4RVeq47mAjcl8ywAJJuIZDoqz1GrNEVj9QlG7uxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZoZIiH6HBScetwa2i+/gfRsMRzPNjlnFzRYqX614RkGLYaIh7eisZ0UhSXVmOzNkq
	 iiX272073T1ij5rPy8CibUmRnV1euz0tpzgcXVIx3eDcITIHhL8T66yZ1MsaEHAhaK
	 a6D6I9NwEaJtBwtFhozHjPzWWHNkBYwBOyqqHH2TWyhLsNN85OQdDlNcrEplKV/JIi
	 QmRjxma+0DfCvJ+JIiYdEw8hVEyHxRtOCm3IIz+MLH5ddk/lEvVakgRBdVH/KEoXWL
	 iDBeL+N7Ky7AyH4Ra0Lx20gvqYfQ/7PjHolDfUdoDHRcRVE0t8wq3FuDEDN0EFeo8G
	 8DktUMMfP136w==
Date: Thu, 12 Nov 2026 20:10:33 +0800
From: Jisheng Zhang <jszhang@kernel.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
	oleg@redhat.com, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
	martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev,
	jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
	bjorn@kernel.org, pulehui@huawei.com, puranjay@kernel.org,
	broonie@kernel.org, dave@stgolabs.net, david.laight.linux@gmail.com,
	tglx@kernel.org, conor.dooley@microchip.com, thuth@redhat.com,
	ajones@ventanamicro.com, ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com, samuel.holland@sifive.com,
	zong.li@sifive.com, debug@rivosinc.com, seanwascoding@gmail.com,
	andybnac@gmail.com, menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn,
	atishp@rivosinc.com, apatel@ventanamicro.com, arnd@arndb.de,
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
	morbo@google.com, justinstitt@google.com,
	qingfang.deng@siflower.com.cn, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-arch@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v10 0/9] riscv: optimize percpu access
Message-ID: <avWsuYF7R5Qiowp_@xhacker>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E193D14000D
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 57z4reciz68mkfe1hjfq8cp9kjt61qbn
X-Rspam-User: 
X-HE-Tag: 1794486656-549208
X-HE-Meta: U2FsdGVkX1/O8bmSY0dFraMmQjzfHcfsFHQpyc07scf5FmpL/2oDA6p408yKT6zf2w5LzjUEapUmLzr+SVCj0IE2L3ZwWGLp1KfDec8gtqc2icsTD4mKYkh5TNIuSgHUblNZhoiivYeGqY9/HWCgLc9XzeWJluf0Ah3f++Wl3nflPYZ2Ro6EtbjNzKbDzpaSzAHs+NMDmBBval5AzRlM5mEtstKmBkzoTuldfC7o5t2pc1N9Mjlysq5Y+7cbiwl83gaB8x/6dI9D9goK76xjySXPk/tsOrsGa2BoEWt9OI5pSTE5PeKrpDugNEnh5X39lay8p3f38x9aMFGisRmRKLyxnZCoLMTXK93mbXgzDQONLlULmMfEzxAqXiC916cqVm1B2nfhu7Kfl3+HM6OV7ft1aufe4cTfkUVwmoEUy1W2Ck0pRIDe9PvRqBmqB7KG0dMNnmzvPsVnn0zBakDmmP/1C4eowzWU1BqRapmFOqQBK5kLBWgR72AtqweIprgacDbIUozrC1TE2AVLQSX83n+FdA5W2YHYwk6c0aszOhrZW6y+bDdF927Sb/HprQ3a1LUw8MxUeRuBwW8DI6+ZW5/k0HGvShwO0fq0rRRJoiNDwtN433HDeUNrgzSHDkcnxYBJB1VPBY8a6I6Tw4YN41tTzRgIWd/hHoGcFVGFyUdLvt1/q8vvjBs2xsCxVaxMejNR20zdXuqb++etyIQ/r6+kE9ONsi5qpXXttbNrVYvMqVNtNAtqTUOWBtvQG+tVZScMcApmbd4kP8+svvKFAYc4b0W8eFaUdo5RIdedrBkLJhdGGIz5Ud5snEHrvWG9JP9QPqapPPyQ+KH8aOAhi7Pd51I1Lo3bNtVddErVKbuI1sSVpsIjcltHs0K5l7G8XDmxhuEXjaWASEKC5gne3MtCyaZz+rrF8jjzer9IqMelro2GYhiHE8Il+UWfVXkEO3g+1Lu8h/HFX6QMaTW
 nlTHHo9A
 rJBTKGcvgZcrQNuAC2ABMwisjB2gGP9PVMiIT0kCYWAuYLAVuCpyQg7JLTD4y9ko9S/8XHtheytA8hEKI3pOeRLE6DPiG9tUKllqP9Fd4UYPKBhQVCTc6n+SLwN1Hgxai4J8FtNGV6hA1a82zAyPgYlE/LqtLx7bnBElrXtkrbV7kbxTBe0+i37/YUcUrrdWtMOeiYkXWcpgrJJnNvKNPzNbRXQUv7w2ca/jbMeJ4cdtJHnguaij+/GvlwdptK/SuUF+rdgDWIYA89yM8LzNqn9bwSPkW843outfQGGwXqMRnLmw/ddwd25L3N1jpncmetj5THdQ07gunAGKwer/b3YEKE0BHAOkM6Na7Ox2n6kZboBGczdSBaQnSeelzNr16QEbC3lew60sgeAgPvpnVfBIZBK00Iup9kTvOZ9a+EljB3iOtroZFLVfJrhzvyVdtnGaT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 06:41:40PM +0800, Yunhui Cui wrote:
> RISC-V has no asm/percpu.h, so this_cpu_*() read-modify-write
> operations use generic fallbacks that disable local interrupts. Per-CPU
> addressing also derives the current offset from the CPU number and
> __per_cpu_offset[].
> 
> Cache the per-CPU offset in thread_info and implement preemptible this_cpu
> operations using recoverable GPR critical sections. Each operation records
> the registers used to form its per-CPU address so exception return can
> repair them if the task resumes on a different CPU. Use AMOs for
> native-width operations. Use Zabha for 8-bit and 16-bit operations when
> available, or a 32-bit LR/SC fallback otherwise. Finally, select
> HAVE_CMPXCHG_LOCAL so common per-CPU counter users can use
> this_cpu_try_cmpxchg().
> 
> The recoverable-GPR scheme follows the arm64 design. Only the protocol is
> common, however: RISC-V uses a cached offset in thread_info, its own GPR
> encoding and exception entry code, and AMO/LR/SC operation sequences.
> Factoring these pieces into generic code would share little beyond the
> field layout while coupling architecture entry paths, so keep the
> implementation under arch/riscv.
> 
> As with arm64's SDEI path, independent NMI-like entry paths must
> participate in the entry-state protocol directly. Keep the save, clear and
> restore operations in common RISC-V assembly macros so SBI Supervisor
> Software Events (SSE) can preserve an interrupted per-CPU operation. SBI
> SSE support is developed separately and is not a dependency of this
> series.
> 
> With CONFIG_PREEMPT_LAZY=y, GCC 15, the same linux-next base and
> configuration, an in-kernel microbenchmark pinned to one CPU ran each
> operation 2,000,000 times for 15 rounds. The table reports the median
> empty-loop-adjusted time; lower is better.
> 
>   operation                 v9 (ns/op)   v10 (ns/op)   change
>   this_cpu_read(u64)            5.668         0.333     -94.1%
>   this_cpu_write(u64)           5.668         0.395     -93.0%
>   this_cpu_add(u64)             8.002         8.004      +0.0%
>   this_cpu_add_return(u64)      8.335         8.004      -4.0%
>   this_cpu_xchg(u64)            8.278         8.004      -3.3%
>   this_cpu_cmpxchg(u64)        18.713        16.133     -13.8%

Hi Yunhui,

Thanks for this series. Could you plz run some benchmark to compare the
performance between v9 and v10? We can use some benchmarks used in arm64
version:
https://lore.kernel.org/linux-arm-kernel/28978498-348e-4cfd-af72-1146a106e96b@arm.com/

Something in my mind: hackbench, kernbench, sysbench-cpu, sysbench-mutex,
sysbench-thread, perf/futex , perf/sched and perf/syscall.

I will read the code during this weekend.

Thanks

> 
> With the same configuration, vmlinux .text decreased from 14,369,618 to
> 14,212,882 bytes (-156,736 bytes, -1.09%). percpu_counter_add_batch()
> decreased from 330 to 228 bytes.
> 
> Changes since v9:
> 
> - Rework the this_cpu operations to remain preemptible using recoverable
>   GPR critical sections, as suggested by David Laight and Jisheng Zhang.
> - Put the cached per-CPU offset first, then split the exception/fixup
>   infrastructure and operation classes into independently reviewable
>   patches.
> - Keep GPR-state save and restore in reusable assembly macros for NMI-like
>   entry paths such as SBI SSE.
> - Keep masked LR/SC cmpxchg operands XLEN-wide so RV64 high-byte and
>   high-halfword comparisons are not affected by LR.W sign extension.
> - Force both halves of the AMOCAS.Q new value into fixed registers so the
>   implicit register pair remains valid when either half is zero.
> - Use TYPEOF_UNQUAL() in wrappers and fully parenthesize this_cpu_write()
>   values.
> 
> Changes since v8:
> 
> - Drop the PIO helper patch, which has already been merged.
> - Rename the first patch and update its changelog as suggested by
>   Davidlohr Bueso.
> - Use value-returning AMOs instead of rd=x0 for CPU-local operations.
> - Remove unnecessary memory clobbers from the new relaxed AMO and LR/SC
>   code.
> - Use .option arch,+zabha for the Zabha inline asm, matching the
>   existing RISC-V cmpxchg implementation.
> - Isolate arch_cmpxchg_relaxed() behind typed always-inline helpers to
>   avoid macro variable capture while preserving atomic instrumentation.
> - Make the cmpxchg128 fallback use the already resolved per-CPU pointer,
>   avoiding the same macro variable capture.
> - Copy the cached per-CPU offset from prev to next during context switch,
>   as suggested by Thomas Gleixner.
> - Initialize secondary idle tasks in the common startup path, covering
>   parallel bringup and CPU hotplug, and remove the duplicate initialization
>   from smp_callin(), as reported by Sashiko.
> - Select HAVE_CMPXCHG_LOCAL in a separate patch.
> 
> Yunhui Cui (9):
>   riscv: store percpu offset into thread_info
>   riscv: add infrastructure for preemptible this_cpu operations
>   riscv: implement preemptible this_cpu read and write operations
>   riscv: implement preemptible this_cpu void RMW operations
>   riscv: implement preemptible this_cpu add_return operations
>   riscv: implement preemptible this_cpu xchg operations
>   riscv: implement preemptible this_cpu cmpxchg operations
>   riscv: implement preemptible this_cpu cmpxchg128
>   riscv: select HAVE_CMPXCHG_LOCAL
> 
>  arch/riscv/Kconfig                   |   1 +
>  arch/riscv/include/asm/asm.h         |  25 +-
>  arch/riscv/include/asm/percpu.h      | 701 +++++++++++++++++++++++++++
>  arch/riscv/include/asm/ptrace.h      |  15 +
>  arch/riscv/include/asm/switch_to.h   |   9 +
>  arch/riscv/include/asm/thread_info.h |   4 +-
>  arch/riscv/kernel/Makefile           |   1 +
>  arch/riscv/kernel/asm-offsets.c      |   4 +-
>  arch/riscv/kernel/entry-common.c     |  32 ++
>  arch/riscv/kernel/entry.S            |  10 +
>  arch/riscv/kernel/smpboot.c          |  10 +-
>  arch/riscv/net/bpf_jit_comp64.c      |   9 +-
>  12 files changed, 805 insertions(+), 16 deletions(-)
>  create mode 100644 arch/riscv/include/asm/percpu.h
>  create mode 100644 arch/riscv/kernel/entry-common.c
> 
> 
> base-commit: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
> -- 
> 2.39.5
> 

