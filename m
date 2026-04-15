Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2BAF41997
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25F66B0092; Wed, 15 Apr 2026 08:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF9F6B0093; Wed, 15 Apr 2026 08:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F166B0095; Wed, 15 Apr 2026 08:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 941D26B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:11:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3ADD58B924
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:11:41 +0000 (UTC)
X-FDA: 84660676002.21.F4BC306
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 95B7A40003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:11:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=teikMa0k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776255099; a=rsa-sha256;
	cv=none;
	b=ILoMzNXBxZiJIc1SBNLwPP6XneTf0D4yHSSWIYiD5YkTUJgAq+/XldQIbptxkalQs276qc
	eze+PmnQZVTb557cqg134yn7O5bbXvsS/u9k3WaghixU6zhdoDY4SoFgfemKlarxWwGKP8
	RQk4WKi9cDIMVP06MD9Lr74RKjs69nE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=teikMa0k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776255099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gFjyfw6RNCzzbD/zWqHAP7soDGZoZ112c3Jb2oLED0=;
	b=dP50YBYUkj20PREBaEK9Frd2RtcURWQPcNMJsuICc/guaUdSR1i4rDZzp4Raxo4hwOqa2W
	E8/FNOotgWGcsMG6NYE/mW/AkarQO/E3e77EP6/TbOO/BfYrrnhELJI98FOw/8f/b78+LG
	HodCPrM2m6OB9gxKkHWdRy4IrPhz7XY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 827F9600CB;
	Wed, 15 Apr 2026 12:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C010EC19424;
	Wed, 15 Apr 2026 12:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776255098;
	bh=k03Tdk8RRR71VlIa0ih5umTwpkvGOoz5OFENuJkyvH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=teikMa0kuzlj73sAfHfIILLEXMER7mx0FWUhmvgWbuIuLjhFsK9Cblo0pBsVlTcng
	 Ymy88Pz9jFYPqhTNEn0FrnOratySSB80K0X0oZEF289p4/9SRolp4Vc9bs4Q71p2oW
	 4ZuszEJtZoSe7xoHBlqFwk8dCYtuBN0ElyuaPQWbREOLMb+yapnXjBHipnTKavAH//
	 wrxgmrbuqikVb5EYgBmsCl9X6WY9pwr4tQSZq7esnFj/CHhDgKhp8wDoGRFMUbfzBf
	 gbgQIVZRh9hw7omQhNn9X/KX1LDpg3Q4+WRc1g+ZcumpkM0iMNzR6ZqQxgLxiFwZFN
	 VDGDSGtNFNG6Q==
Date: Wed, 15 Apr 2026 14:11:35 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Nicolas Saenz Julienne <nsaenzju@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [RFC PATCH v8 09/10] context_tracking,x86: Defer kernel text
 patching IPIs when tracking CR3 switches
Message-ID: <ad-Ad44-IyU-yKJf@localhost.localdomain>
References: <20260324094801.3092968-1-vschneid@redhat.com>
 <20260324094801.3092968-10-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260324094801.3092968-10-vschneid@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 95B7A40003
X-Stat-Signature: xiswtw3putm9n5zztwod5x4iu86iitpj
X-HE-Tag: 1776255099-892108
X-HE-Meta: U2FsdGVkX1+3jBfIOQPP0x4PS/tIPAQip0kLF0FeZzhjy7tgrPME5z3dfRo+oao//3UnLAevMTNIzrgS27r38E8nJNydthWQUka9FhstrhzU1Ni4SvbiHsDZbPOQvcFijgVkdWwGGyS85y1hQ6UF13qpt2nSS93vX8Yfl55Nf2GBVDoF8JdHDtx5puSrN9M6w/cnSS44SFxaTI4W2QnkK3/qH4U3vEFBupfJTxkd7aE0GhbLC8OiWWPkfkXYc+7hJvZJ7ARLteGjFqgy2FrBJ6MMj9g50vr1u252GYq7RDMfGm8Leh9qE2NtMG//NvxIZGeOJZIuroHisW8Ksoxogyi8vWWQ125yMZbPdvR0Ml6CPpFPaTX1ydUSmaSlLmNqiR2pK5B267xDtjG5nWs5TQilAsnPvpkw1Y364m8fMeFIWXUxjYAzlxkDcGXPsE4SBf9+p4RZqESAfPUe3N1/JoEn5Y2vcblZAsfc7AQBFrI/tHkVcj16kcYlx6bFRanydNUol9e5AtPKSCUhr8jSFPoqE2bFtfV9xuj06aFjFnvALX1NxZaWO+aY13+/VUTWXKbIbUfriNaglHVULixC+iqwMxXJ1QY2QOUQqGS0siJH4IlWnNCcWe+cn12AZ3SKg2WhM7OcxBQkHhk9N5qdUJ2rNZMB4cq6GDm4JXY8gOSK4xDQOWR60nq4v+hMx8la3QwGY3vQtiq9/aQq4a30Lj6D9Biz32P3AQtgHqdS8b5t5VmczWzaXBIYIVvN6xz4Cpt38SRFx5dAUga19XLXd5dFyv3lxEd1PGTL/pDBjZZJjrmmxKU4AFRp3FNLWsgjV8KtkVHYJ/IO0/KxJ/SVn+Rfu9L6Kqe/1iPbRf4Lh3ejwMrZ8Y9fK4YUZcUMau39eM4NqpwZo7W17HpBX8pB3b0IqTVutR6asnVCeh0Ol2zWBhW38pi//BbTXMiYVfp2M7LWivzfHKn5LA6aGE5
 YkNiJk2z
 NvEGOkaBZ4SjqKPVHA/el87/g5xWFjarzw8x1Tog2ycJLtjyLNosyxLux2CHpFQm1QjeuNzJY1Y4lO075ZKpImy6WperVoGWL+68RGUxcN8kchjfq1rs0DAFsim4b9xkUkNOp4UjUOakB8Jm4bxTxUrMCYVRHBEtKC/dTrrKukb/2JGI85BlsF8XA0zDngaYQTeYWG3sVVwcrvcP5AH/JQPSEFRiraBopxszUHhOUN1/xrley8d0eEn72o4ZTU0FiNoBmKpPHkBUU0+fkvwhANp27fFgsMcv4Nc7e0Zx8cN2YH0wqh4LFWIuLBzFTKa3xvX5r5Zbbe9c//Z0yOP+/szdz1rGBcPbDy0DwUJnu8Nh3YxQSAQMH/LRxBq98mcN2UCHjgXLCt5coJDjlX8Xk5NpoCLkZBWzmrP4snZYkWpTVARZO0V3I+jiOYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Mar 24, 2026 at 10:48:00AM +0100, Valentin Schneider a écrit :
> text_poke_bp_batch() sends IPIs to all online CPUs to synchronize
> them vs the newly patched instruction. CPUs that are executing in userspace
> do not need this synchronization to happen immediately, and this is
> actually harmful interference for NOHZ_FULL CPUs.
> 
> As the synchronization IPIs are sent using a blocking call, returning from
> text_poke_bp_batch() implies all CPUs will observe the patched
> instruction(s), and this should be preserved even if the IPI is deferred.
> In other words, to safely defer this synchronization, any kernel
> instruction leading to the execution of the deferred instruction
> sync must *not* be mutable (patchable) at runtime.
> 
> This means we must pay attention to mutable instructions in the early entry
> code:
> - alternatives
> - static keys
> - static calls
> - all sorts of probes (kprobes/ftrace/bpf/???)
> 
> The early entry code is noinstr, which gets rid of the probes.
> 
> Alternatives are safe, because it's boot-time patching (before SMP is
> even brought up) which is before any IPI deferral can happen.
> 
> This leaves us with static keys and static calls. Any static key used in
> early entry code should be only forever-enabled at boot time, IOW
> __ro_after_init (pretty much like alternatives). Exceptions to that will
> now be caught by objtool.
> 
> The deferred instruction sync is the CR3 RMW done as part of
> kPTI when switching to the kernel page table:
> 
>   SDM vol2 chapter 4.3 - Move to/from control registers:
>   ```
>   MOV CR* instructions, except for MOV CR8, are serializing instructions.
>   ```
> 
> Leverage the new kernel_cr3_loaded signal and the kPTI CR3 RMW to defer
> sync_core() IPIs targeting NOHZ_FULL CPUs.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>  arch/x86/include/asm/text-patching.h |  5 ++++
>  arch/x86/kernel/alternative.c        | 34 +++++++++++++++++++++++-----
>  arch/x86/kernel/kprobes/core.c       |  4 ++--
>  arch/x86/kernel/kprobes/opt.c        |  4 ++--
>  arch/x86/kernel/module.c             |  2 +-
>  5 files changed, 38 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
> index f2d142a0a862e..628e80f8318cd 100644
> --- a/arch/x86/include/asm/text-patching.h
> +++ b/arch/x86/include/asm/text-patching.h
> @@ -33,6 +33,11 @@ extern void text_poke_apply_relocation(u8 *buf, const u8 * const instr, size_t i
>   */
>  extern void *text_poke(void *addr, const void *opcode, size_t len);
>  extern void smp_text_poke_sync_each_cpu(void);
> +#ifdef CONFIG_TRACK_CR3
> +extern void smp_text_poke_sync_each_cpu_deferrable(void);
> +#else
> +#define smp_text_poke_sync_each_cpu_deferrable smp_text_poke_sync_each_cpu
> +#endif
>  extern void *text_poke_kgdb(void *addr, const void *opcode, size_t len);
>  extern void *text_poke_copy(void *addr, const void *opcode, size_t len);
>  #define text_poke_copy text_poke_copy
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 28518371d8bf3..f3af77d7c533c 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -6,6 +6,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/memory.h>
>  #include <linux/execmem.h>
> +#include <linux/sched/isolation.h>
>  
>  #include <asm/text-patching.h>
>  #include <asm/insn.h>
> @@ -13,6 +14,7 @@
>  #include <asm/ibt.h>
>  #include <asm/set_memory.h>
>  #include <asm/nmi.h>
> +#include <asm/tlbflush.h>
>  
>  int __read_mostly alternatives_patched;
>  
> @@ -2706,11 +2708,29 @@ static void do_sync_core(void *info)
>  	sync_core();
>  }
>  
> +static void __smp_text_poke_sync_each_cpu(smp_cond_func_t cond_func)
> +{
> +	on_each_cpu_cond(cond_func, do_sync_core, NULL, 1);
> +}
> +
>  void smp_text_poke_sync_each_cpu(void)
>  {
> -	on_each_cpu(do_sync_core, NULL, 1);
> +	__smp_text_poke_sync_each_cpu(NULL);
> +}
> +
> +#ifdef CONFIG_TRACK_CR3
> +static bool do_sync_core_defer_cond(int cpu, void *info)
> +{
> +	return housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE) ||
> +	       per_cpu(kernel_cr3_loaded, cpu);

|| should be && ?

Also I would again expect full ordering here with an smp_mb() before the
check. So that:

CPU 0                            CPU 1
-----                            -----
//enter_kernel                   //do_sync_core_defer_cond
kernel_cr3_loaded = 1            WRITE page table
smp_mb()                         smp_mb()
WRITE cr3                        READ kernel_cr3_loaded

But I'm not sure if that ordering is enough to imply that if CPU 1 observes
kernel_cr3_loaded == 0, then subsequent CPU 0 entering the kernel is guaranteed
to flush the TLB with the latest page table write.

Thoughts?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

