Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24070CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 15:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7998E0005; Fri,  7 Nov 2025 10:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598058E0002; Fri,  7 Nov 2025 10:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4875D8E0005; Fri,  7 Nov 2025 10:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 324438E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:42:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCE2F1A0523
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:42:42 +0000 (UTC)
X-FDA: 84084228564.30.01939AE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0199FC0014
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:42:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762530161; a=rsa-sha256;
	cv=none;
	b=iH+CetnEY5yCk26FRzum3tQYpU8bVNTpNG4dbzU+O3cr+e8D6UJnQl+EAe3Qz5q6oU35zP
	P33RQC1t+WbyQHgq2IjYZpbmwm/2MbqUQreDyMgr7mdSomudnmywzt+zRDW9DxUNkLAHx8
	AD+MTrRcV1zBpfc3ebLi0gitfOTNNuM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762530161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ghfktYDx18TuQuyOns9ayrK6wncJqISxd3WyfDEr83M=;
	b=xb5z/ACHgZKbH5kS/XwLOsw4FEcbYoF3jXi+EjOjK9Vv2cTdm+1gW/rEmqSbKCwii8nKns
	VI1erO+VezcR95WifdKneaw0OpYFa1WzeTnV9An+oFKJZr4a8GEhqSnJ4d35sqAPJ8uA4g
	pVIsn83NFNb8CQsk4r8cPiH8UyVcDJo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B6271515;
	Fri,  7 Nov 2025 07:42:32 -0800 (PST)
Received: from [10.57.86.134] (unknown [10.57.86.134])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F2A33F694;
	Fri,  7 Nov 2025 07:42:35 -0800 (PST)
Message-ID: <8a38db66-4d1a-4296-a2dc-e0276c6cdde8@arm.com>
Date: Fri, 7 Nov 2025 15:42:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/12] mm: bail out of lazy_mmu_mode_* in interrupt
 context
Content-Language: en-GB
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-13-kevin.brodsky@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251029100909.3381140-13-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0199FC0014
X-Stat-Signature: 6yjdozrswuxo98uka56eep1rtruffi7j
X-HE-Tag: 1762530160-119075
X-HE-Meta: U2FsdGVkX1/P8VwIS5RlEqQMe3XLoSllNa6K0u590fI22h+nJBvGsN190a7qnngzSC54CX2CLfmT2ClK+eiu/4sc/cdQY6ACNwTnXWV4IQVs08Gfkt5WZwXqxlBgNTncIovPv3gVdOWaHMwxMCLjXnBbM1yKFd7j32MS6pYzgkV+WfRGvdx5XMixobt/plNxTBvjCFhu9iO9bM+/wUEFXhrekeB+tuAAvx+2VFrV0vc07wlgzPsj7ggVQE8Z4076ZcHYfPIWp6TlLb5YpXoDgyrX4+c7iRFSlQXeXX7Od/XTZ/kUKbbhDx92AUY2SWqAYn+iX7QmlBZc4EY81bU41al2YzVvPkfPAmu4iI9+1F4SeUSXhJLkHysYS8wYe+KgYslmQP63QQ9vbp7lqAMyOvPTP8z6n12iwX8OYiwDWdThvoam27glYu/0+WdQONd5Qjihbi5QIjP16fqbVEthwtVqmGZukHEWhTZLdxpH0AAq9ukFrISlfaclfhV/smscRHRr4Tb2bv09RTPjAW0wI8PAWhuGFXJB9iqgQ7RElreaW9J0CCJLKRimCxrft0yRtzGhfokbwhXVM5AmCaEV2WNcgnHB1uzmP/IMoW4lpVVgmmtNjehBz461yZOAij6bSoQaFhM0GPRsS8Uwy99pI1DdPFvUqDNcfdmnqk/IomhaE19fi5GMkAdwjok1fZMPWCAJyLK2Tub8Xkjh5uti9NOceYLv5YCaCfBYOyAGp316b6sCJcxkIe75DYtZt53uJ4+BhyRdgB6hEa80azESn/tFc3aFSez6Pbt2bR7lPIr8haEfycl/XppBz7fw/3RrUWO1mVPeZMaqtIUn5db4p58D7cDGLtV4URcao3xC77Kv/JRnrUruQxPOP1vfjvKlwpi97FzP75nS7ar8v5P6gRyfjw48k+mVP8T8bPW+dqzCGYisT5A5pMK3N/rb70tBN7okdw69nHZA/zx1mTg
 DiAmhouT
 wz1YIHmS3r0Df4FZo2fQgAqZ4M1dvvGnKpxU6Qh1vhMyDECitETMOxhpJaDQHVSV98T/35WjyAZlbybrLk/OaCr9Tv4gh8nF/84wLrGoOq2C6We2a1KrXxbNHrMOQlrejLwB7LJMmkj0/DOmLcMC150tQFsglQXNH4KltKCsaVUjIr2RPYeQJ+uTfxjXWJL5HNR0/G/vmhDDODPltcwkppgTQ5DMCzaJz8wVSjB/2K6lqkHWbj0o16uV3/QOdD1ZmlSUnyl5hkItLwLpsiQzMz/+SkpyXjYuonJs5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/10/2025 10:09, Kevin Brodsky wrote:
> The lazy MMU mode cannot be used in interrupt context. This is
> documented in <linux/pgtable.h>, but isn't consistently handled
> across architectures.
> 
> arm64 ensures that calls to lazy_mmu_mode_* have no effect in
> interrupt context, because such calls do occur in certain
> configurations - see commit b81c688426a9 ("arm64/mm: Disable barrier
> batching in interrupt contexts"). Other architectures do not check
> this situation, most likely because it hasn't occurred so far.
> 
> Both arm64 and x86/Xen also ensure that any lazy MMU optimisation is
> disabled while in interrupt mode (see queue_pte_barriers() and
> xen_get_lazy_mode() respectively).
> 
> Let's handle this in the new generic lazy_mmu layer, in the same
> fashion as arm64: bail out of lazy_mmu_mode_* if in_interrupt(), and
> have in_lazy_mmu_mode() return false to disable any optimisation.
> Also remove the arm64 handling that is now redundant; x86/Xen has
> its own internal tracking so it is left unchanged.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 17 +----------------
>  include/linux/pgtable.h          | 16 ++++++++++++++--
>  include/linux/sched.h            |  3 +++
>  3 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 61ca88f94551..96987a49e83b 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -62,37 +62,22 @@ static inline void emit_pte_barriers(void)
>  
>  static inline void queue_pte_barriers(void)
>  {
> -	if (in_interrupt()) {
> -		emit_pte_barriers();
> -		return;
> -	}
> -
>  	if (in_lazy_mmu_mode())
>  		test_and_set_thread_flag(TIF_LAZY_MMU_PENDING);
>  	else
>  		emit_pte_barriers();
>  }
>  
> -static inline void arch_enter_lazy_mmu_mode(void)
> -{
> -	if (in_interrupt())
> -		return;
> -}
> +static inline void arch_enter_lazy_mmu_mode(void) {}
>  
>  static inline void arch_flush_lazy_mmu_mode(void)
>  {
> -	if (in_interrupt())
> -		return;
> -
>  	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
>  		emit_pte_barriers();
>  }
>  
>  static inline void arch_leave_lazy_mmu_mode(void)
>  {
> -	if (in_interrupt())
> -		return;
> -
>  	arch_flush_lazy_mmu_mode();
>  }

Ahh ok, by the time you get to the final state, I think a most of my
comments/concerns are solved. Certainly this now looks safe for the interrupt
case, whereas I think the intermediate state when you initially introduce
nesting is broken. So perhaps you want to look at how to rework it to prevent that.

Thanks,
Ryan


>  
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index e6064e00b22d..e6069ce4ec83 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -228,8 +228,8 @@ static inline int pmd_dirty(pmd_t pmd)
>   * of the lazy mode. So the implementation must assume preemption may be enabled
>   * and cpu migration is possible; it must take steps to be robust against this.
>   * (In practice, for user PTE updates, the appropriate page table lock(s) are
> - * held, but for kernel PTE updates, no lock is held). The mode cannot be used
> - * in interrupt context.
> + * held, but for kernel PTE updates, no lock is held). The mode is disabled
> + * in interrupt context and calls to the lazy_mmu API have no effect.
>   *
>   * The lazy MMU mode is enabled for a given block of code using:
>   *
> @@ -265,6 +265,9 @@ static inline void lazy_mmu_mode_enable(void)
>  {
>  	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>  
> +	if (in_interrupt())
> +		return;
> +
>  	VM_WARN_ON_ONCE(state->nesting_level == U8_MAX);
>  	/* enable() must not be called while paused */
>  	VM_WARN_ON(state->nesting_level > 0 && !state->active);
> @@ -279,6 +282,9 @@ static inline void lazy_mmu_mode_disable(void)
>  {
>  	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>  
> +	if (in_interrupt())
> +		return;
> +
>  	VM_WARN_ON_ONCE(state->nesting_level == 0);
>  	VM_WARN_ON(!state->active);
>  
> @@ -295,6 +301,9 @@ static inline void lazy_mmu_mode_pause(void)
>  {
>  	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>  
> +	if (in_interrupt())
> +		return;
> +
>  	VM_WARN_ON(state->nesting_level == 0 || !state->active);
>  
>  	state->active = false;
> @@ -305,6 +314,9 @@ static inline void lazy_mmu_mode_resume(void)
>  {
>  	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>  
> +	if (in_interrupt())
> +		return;
> +
>  	VM_WARN_ON(state->nesting_level == 0 || state->active);
>  
>  	state->active = true;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 11566d973f42..bb873016ffcf 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1731,6 +1731,9 @@ static inline char task_state_to_char(struct task_struct *tsk)
>  #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>  static inline bool in_lazy_mmu_mode(void)
>  {
> +	if (in_interrupt())
> +		return false;
> +
>  	return current->lazy_mmu_state.active;
>  }
>  #else


