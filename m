Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7224C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388A36B0099; Fri, 31 Jul 2026 13:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339ED6B009B; Fri, 31 Jul 2026 13:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228CB6B009D; Fri, 31 Jul 2026 13:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB0816B0099
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:32:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81F461A0507
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:15:34 +0000 (UTC)
X-FDA: 85049572188.26.9058EF5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 936A8100016
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:15:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D5ysb3m8;
	spf=pass (imf05.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785514532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEoQV27iS4e8ivu4L89IUt/qpH7+G69Fwk5z3rja0hE=;
	b=SPLi96wNAHa0v4kB4lN7Th1ZNEqi2jo/oaxf4V8sAG81MSCxXG0d+5P6tzmLglrRxuzIr+
	jvpCCgp+z5fz1hRnSUhls+oJBwxKD+ip04srT1ErJINrt4AxQgNU7JwS1FOYZuI7e+vKJa
	zUEZ9D54+0bmcFR7JxP1j0d0FOgNwDA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785514532;
	b=AjlyRvHZIUOc11lXvd4zPoE45SQa55+nMkqaFwkO1fi9QVixuqjGHvDdjcXDQ/KCqR6Nuv
	TSQio5ehEpY+kAhqXzrIf/aXr3OpTeFLj5tgCjIXINvTPHdYhxhx13DH3OxpNEAOUbArjz
	quPi/l2m+xS7Pzxm6/LxnRoWbkA9O5g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D5ysb3m8;
	spf=pass (imf05.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FC70204C;
	Fri, 31 Jul 2026 09:15:27 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 419BA3F86F;
	Fri, 31 Jul 2026 09:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785514531; bh=EC4Qldz0I8//eu8X9qUqICG1s0ODDvI3gx2a299M5Cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D5ysb3m8w0oV0jAuBPN2EE+x7/QiB3HmzsLsl9Of48PCq8y3Avccb+Y8RjUcWjGAw
	 rOgeZKxweIvJrVq0r88o419dcChgko7LZGWsupv8c7SKqE0dJYqqxK/kbRxbJNaEn6
	 KdEEXCxRq4MU5tuCGf1pHIl25TaKJf1Xf9FZlbJ8=
Date: Fri, 31 Jul 2026 17:15:25 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Hongyan Xia <hongyan.xia@transsion.com>
Cc: Will Deacon <will@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
	Naveen N Rao <naveen@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jiazi Li <jiazi.li@transsion.com>, Pu Hu <hupu@transsion.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>
Subject: Re: [RFC PATCH 9/9] arm64/debug: Mark debug exception helpers
 __always_inline
Message-ID: <amzKHV5fBeRFhwlJ@J2N7QTR9R3>
References: <cover.1785153469.git.hongyan.xia@transsion.com>
 <eb38b41ae1b3216ec69fb45555ef5df57efd7b8d.1785153469.git.hongyan.xia@transsion.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb38b41ae1b3216ec69fb45555ef5df57efd7b8d.1785153469.git.hongyan.xia@transsion.com>
X-Rspamd-Queue-Id: 936A8100016
X-Stat-Signature: qedrxm5oehgu1aencmtt337km8jsfx5h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785514532-173213
X-HE-Meta: U2FsdGVkX1+SeC+ciabY2vqL2fxZ/4i9oWqPnN9rn/4bqSrj4CJ/KukYd1ZsDK1w62BMhrwxne47rF9vAKIckoqyjEpw1NsPju+2KTJCkWoMdQ4vqOfzyscipMKgHUKcDno+FW1tvF2Axz7nFTqZEObMLjHQPuh39pHYUocmNAvF8+YuGHXtBA7l9QfTnk2ULScaeLEWqvyQmcXoM/hTMVTHgDO0bk319z+b1SWB6/McCuO9tbUZWnCpxHUWQNzLLULDfTI+0mnhLRfx17f8exHzygfpOZ04JGtN5JUPqAX9SPgoba9fy/eETHp/o4YBTgmD7PcpoBm5S5Oi4C5Zr4X0Lz8FTt4VFWbXL4VwpHIrRBkxV4tWVjX3C+EfbXPMDNP6xiH42Sdz/tilLauCrfHnFX+cmdqw85mKwBW6/g1tUT+DRcq6zmnCEhK6+20BP0wpWLeexz7InfQPUv3q8Bh682ymc9Bg3JaPCpGisFeTisH/PQW5mUoJbXI4eYXzYa0XLeZtvIu1/q82CaQNxIu33e+OoQ6F7jCkJn2abOSTeBNFOfi/P0F7tBnlqu9W5YZUx4J6VwR+5fKKTgzj9pO38RmKI+IOmnHhPxTzv8XoHLwzgcfM1dKebFUzMobIn+oefY4lTy/fr4vSYWHgcoTmwZSVeTA2g6FtqhoS8I9Hnf1lzy350dwLzSHIrb4EFQr/+RUI+KPfO/Bifx6bAe8hxi9X+qPcxFYci/HVs2j44pQNjwNc6yoyJXVASVZZEKBo0ZSfKsWv73cl7qs84nyUtSOR1qf+2JVZog290FEIdV2xRnQEpkNYIrY2WX9IHtraCKWLkC68yNPlb19L+00uI4ZVb8Cno102OCjRKZG+skt/UEmgjEDxf80NM2UgTyjrqpYNCSkW5EP2T9cGV3IuxqaDSYyDnGRqFu0+LPhcEkur4tbN6VV/7OY5VjoVVoc3uXbGzf6GQUp7FV5
 PV5Hg3wp
 cqzw96JxHJrFO0kMmfmQYSm5MTEbu3J2bY9Nuc5NdYZDW1a46VFJuu4r0P7cz0TOyHUfddBmxAuhUx1bUcEE61mzAmEAI/K0tFhruxYXoTROqS41ZssJDuy6qYQV/9mzbQQyJOHGEqN/1OsKW2snhWOCSVfka5Djcv2zydbKeD0EOsrfj7xyXyIOQUcaR8a7Q0lNa/Gkee1PhY/x3gTNREtmNWL4njYvEIynK/yBD3suzuaBdzriurlw/WNLsdu35KrOfyHKoq/R5zDQLThGff+Y49INsi2ha5oec5QUgrw+Tg+g3z5QDMls5P9Mn17A8cJSMufVNm81yBBuqUiWSftSbCSbU/aB8StCKYAAafxUoQje7sqeJJELgQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 12:25:48PM +0000, Hongyan Xia wrote:
> From: Hongyan Xia <hongyan.xia@transsion.com>
> 
> Static inline should be enough to actually inline functions for most
> compilers, but my Clang-19 somehow thinks it's better to outline them.
> These tiny helpers then live in normal .text sections instead of
> .noinstr sections, violating noinstr.
> 
> Mark them __always_inline so the compiler can never outline them.
> 
> Signed-off-by: Hongyan Xia <hongyan.xia@transsion.com>
> ---
>  arch/arm64/include/asm/esr.h       | 2 +-
>  arch/arm64/include/asm/percpu.h    | 2 +-
>  arch/arm64/include/asm/preempt.h   | 4 ++--
>  arch/arm64/include/asm/ptrace.h    | 4 ++--
>  arch/arm64/kernel/debug-monitors.c | 2 +-
>  include/linux/kprobes.h            | 8 ++++----
>  6 files changed, 11 insertions(+), 11 deletions(-)

I think this should be split into separate patches. In particular, the
preempt count helpers are used in mane other places than debug
exceptions, and if those are used in noinstr code today, we need to
backport those as fixes.

Mark.

> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index f816f5d77f1a..a75bfdb7e5fe 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -437,7 +437,7 @@
>  #ifndef __ASSEMBLER__
>  #include <asm/types.h>
>  
> -static inline unsigned long esr_brk_comment(unsigned long esr)
> +static __always_inline unsigned long esr_brk_comment(unsigned long esr)
>  {
>  	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
>  }
> diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
> index b57b2bb00967..d4cae47fde8c 100644
> --- a/arch/arm64/include/asm/percpu.h
> +++ b/arch/arm64/include/asm/percpu.h
> @@ -29,7 +29,7 @@ static inline unsigned long __hyp_my_cpu_offset(void)
>  	return read_sysreg(tpidr_el2);
>  }
>  
> -static inline unsigned long __kern_my_cpu_offset(void)
> +static __always_inline unsigned long __kern_my_cpu_offset(void)
>  {
>  	unsigned long off;
>  
> diff --git a/arch/arm64/include/asm/preempt.h b/arch/arm64/include/asm/preempt.h
> index 932ea4b62042..326f221c3f56 100644
> --- a/arch/arm64/include/asm/preempt.h
> +++ b/arch/arm64/include/asm/preempt.h
> @@ -41,14 +41,14 @@ static inline bool test_preempt_need_resched(void)
>  	return !current_thread_info()->preempt.need_resched;
>  }
>  
> -static inline void __preempt_count_add(int val)
> +static __always_inline void __preempt_count_add(int val)
>  {
>  	u32 pc = READ_ONCE(current_thread_info()->preempt.count);
>  	pc += val;
>  	WRITE_ONCE(current_thread_info()->preempt.count, pc);
>  }
>  
> -static inline void __preempt_count_sub(int val)
> +static __always_inline void __preempt_count_sub(int val)
>  {
>  	u32 pc = READ_ONCE(current_thread_info()->preempt.count);
>  	pc -= val;
> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index 39582511ad72..460726224299 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -336,11 +336,11 @@ static inline unsigned long regs_get_kernel_argument(struct pt_regs *regs,
>  struct task_struct;
>  int valid_user_regs(struct user_pt_regs *regs, struct task_struct *task);
>  
> -static inline unsigned long instruction_pointer(struct pt_regs *regs)
> +static __always_inline unsigned long instruction_pointer(struct pt_regs *regs)
>  {
>  	return regs->pc;
>  }
> -static inline void instruction_pointer_set(struct pt_regs *regs,
> +static __always_inline void instruction_pointer_set(struct pt_regs *regs,
>  		unsigned long val)
>  {
>  	regs->pc = val;
> diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
> index a970ab6327cd..66cb8151f5df 100644
> --- a/arch/arm64/kernel/debug-monitors.c
> +++ b/arch/arm64/kernel/debug-monitors.c
> @@ -146,7 +146,7 @@ postcore_initcall(debug_monitors_init);
>  /*
>   * Single step API and exception handling.
>   */
> -static void set_user_regs_spsr_ss(struct user_pt_regs *regs)
> +static __always_inline void set_user_regs_spsr_ss(struct user_pt_regs *regs)
>  {
>  	regs->pstate |= DBG_SPSR_SS;
>  }
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 8c4f3bb24429..5880445ed0f0 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -384,17 +384,17 @@ static inline void kprobe_ftrace_kill(void) {}
>  struct kprobe *get_kprobe(void *addr);
>  
>  /* kprobe_running() will just return the current_kprobe on this CPU */
> -static inline struct kprobe *kprobe_running(void)
> +static __always_inline struct kprobe *kprobe_running(void)
>  {
>  	return __this_cpu_read(current_kprobe);
>  }
>  
> -static inline void reset_current_kprobe(void)
> +static __always_inline void reset_current_kprobe(void)
>  {
>  	__this_cpu_write(current_kprobe, NULL);
>  }
>  
> -static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
> +static __always_inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
>  {
>  	return this_cpu_ptr(&kprobe_ctlblk);
>  }
> @@ -449,7 +449,7 @@ static inline struct kprobe *get_kprobe(void *addr)
>  {
>  	return NULL;
>  }
> -static inline struct kprobe *kprobe_running(void)
> +static __always_inline struct kprobe *kprobe_running(void)
>  {
>  	return NULL;
>  }
> -- 
> 2.47.3
> 

