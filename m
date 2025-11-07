Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E2ACCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150458E0009; Fri,  7 Nov 2025 07:25:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127CD8E0002; Fri,  7 Nov 2025 07:25:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064C48E0009; Fri,  7 Nov 2025 07:25:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EAE338E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:25:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A47E01DFDE1
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:25:11 +0000 (UTC)
X-FDA: 84083730822.09.5FE0676
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9C43AA000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:25:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762518310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q8/bZZDo4uDY7fRqMbFc0hDuAZ8k3DxSFT/cCVihKUE=;
	b=xgPkZI+p2tF/tNuJBTo4ERIVynNj80cEh+/V9KukVw/lRO89hMedwCejmuOT11TqRUgkNz
	UgKgAjm8EfrTOt3F7WD6Xq46+oZoeo8X/Wzr2fb96Kb2V80y6T0WIsSiqE1kYrYVq/jPP0
	kDCJSqHMuI7poQWHgakT1MbwD+4/ia4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762518310; a=rsa-sha256;
	cv=none;
	b=1eVwkLYk9LRyMbgYVap2iV6iSbeY/zmLcClPRA95OuWye5fQvANnwlDZgMpCgDzANEikH9
	PWWEQfX9HnCzR3Asc24SCJxQU/4iugZ2Po3DSMKg8vPMg47X4XTAx40MU9v9ExSGaajf64
	pJswifKFbRBjfkBdvjnuuM6xopeSidM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6E851515;
	Fri,  7 Nov 2025 04:25:00 -0800 (PST)
Received: from [10.57.86.134] (unknown [10.57.86.134])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF63F3F66E;
	Fri,  7 Nov 2025 04:25:03 -0800 (PST)
Message-ID: <daa2025c-43da-4c16-9393-a90574d74f64@arm.com>
Date: Fri, 7 Nov 2025 12:25:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] powerpc/64s: Do not re-activate batched TLB
 flush
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
 <20251029100909.3381140-2-kevin.brodsky@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251029100909.3381140-2-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C43AA000F
X-Stat-Signature: exm6sg6416zdomudeswba1h89ox7jhd1
X-Rspam-User: 
X-HE-Tag: 1762518309-298072
X-HE-Meta: U2FsdGVkX190DNo/7mFshCZmWFQW4VKABQxGlTAvmcQBQlOIWR0/oMjvv1f8VnDS7A2Dl2yvc2cVWyiMoMX6stZWWcr9rltiZEnzXZI2gNuU9277EklYkCOgx3Gz1gahjaJ9tn84XRsVY3O/RrRdLgn+O9NGDicFexPre5XnQl7W6J7JCLZLcuFmU7ghOuwGtCqo+eZl4in7GquqO/151+Vw7F/r1cPzY7TCD0Umu9Zo6l6RPZNkaVrdYlK+2be9hNFVkGz52cx/UkbhfZYsXYWUIgNbxWygllx3KJIoGtBhKsClhdB3PSYRyHRwCPNHU6ApXseoQ9q0gGWfQd7IghWYYXUR6mpic30lNpx+ejb5nJgtXAqk4m2dRnG9fE7z2kD0wnTBeME6IykjTKMrhed2d6pifvgXIIJOhOxJZAT+MxWzB0Eu+XJgrGR9SkobWzMKSR45jPqBB3slW1+CD8a2E5Yet75lBPPur3jmZGllUEgl4KHV+el/TuB+kuGAJFcGn50yIIYSDuCWVlVnGO19BQ7/rB7xM6wJnn4NZDm9htwbdeNFyehSs6h84kIyK49YiMF85y1HzZWG6es95sjlch+gHXa2Nv1k8sx1LqqhhbjaKdeq+xoQTvVtFiU7MaAzQA3B5qXHP9PkN1Z90hxQQMI0bDnSSAXLsUqYj/AKzuClCqW7yYEBhxq5gGNeKcOFjqhM+mMTzu+ZcM46PpPJ3WKN0lkdV5RvMIlE9eZGdnGVJ3y3J6wOcHqh4DHuIMDePkPCC62yVhyPouWy76l5Fy656dqkjt5S6XpAdjmT6hA0elsJoqM32EnvlfPwN56meWfGlO+w8tgeuDyH7f+Qkq4JDjZmHruCFyFeb5prCVulA+g0G6nvuvHApSDo6wmSojn09m+RcISpt9fdKs76eeTdtKcN3iR4xOM/sj72vUmYcPYwDp4y1HT6GJFmyH9vtmgVVUG0GjVvc10
 0DFVUUb+
 5Md/UKWSffSQ75vvKYmJBXHE4ynJnhlmKNCYumXyV/OslErVeMhIgMy3JNvBCm+KQVCK2dthdvhXegQmlFbkWykLsm/FwTQpVZSKeK5dXrf3r8T9DqbBpNkO2B0dLf19RHcZsAbDF6IoOegNgM3GgIbhxdcy1h/NLmBO/5QZIE//K2VL45ZVZQaxBRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/10/2025 10:08, Kevin Brodsky wrote:
> From: Alexander Gordeev <agordeev@linux.ibm.com>
> 
> Since commit b9ef323ea168 ("powerpc/64s: Disable preemption in hash
> lazy mmu mode") a task can not be preempted while in lazy MMU mode.
> Therefore, the batch re-activation code is never called, so remove it.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/powerpc/include/asm/thread_info.h |  2 --
>  arch/powerpc/kernel/process.c          | 25 -------------------------
>  2 files changed, 27 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
> index b0f200aba2b3..97f35f9b1a96 100644
> --- a/arch/powerpc/include/asm/thread_info.h
> +++ b/arch/powerpc/include/asm/thread_info.h
> @@ -154,12 +154,10 @@ void arch_setup_new_exec(void);
>  /* Don't move TLF_NAPPING without adjusting the code in entry_32.S */
>  #define TLF_NAPPING		0	/* idle thread enabled NAP mode */
>  #define TLF_SLEEPING		1	/* suspend code enabled SLEEP mode */
> -#define TLF_LAZY_MMU		3	/* tlb_batch is active */
>  #define TLF_RUNLATCH		4	/* Is the runlatch enabled? */
>  
>  #define _TLF_NAPPING		(1 << TLF_NAPPING)
>  #define _TLF_SLEEPING		(1 << TLF_SLEEPING)
> -#define _TLF_LAZY_MMU		(1 << TLF_LAZY_MMU)
>  #define _TLF_RUNLATCH		(1 << TLF_RUNLATCH)
>  
>  #ifndef __ASSEMBLER__
> diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
> index eb23966ac0a9..9237dcbeee4a 100644
> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -1281,9 +1281,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
>  {
>  	struct thread_struct *new_thread, *old_thread;
>  	struct task_struct *last;
> -#ifdef CONFIG_PPC_64S_HASH_MMU
> -	struct ppc64_tlb_batch *batch;
> -#endif
>  
>  	new_thread = &new->thread;
>  	old_thread = &current->thread;
> @@ -1291,14 +1288,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
>  	WARN_ON(!irqs_disabled());
>  
>  #ifdef CONFIG_PPC_64S_HASH_MMU
> -	batch = this_cpu_ptr(&ppc64_tlb_batch);
> -	if (batch->active) {
> -		current_thread_info()->local_flags |= _TLF_LAZY_MMU;
> -		if (batch->index)
> -			__flush_tlb_pending(batch);
> -		batch->active = 0;
> -	}
> -
>  	/*
>  	 * On POWER9 the copy-paste buffer can only paste into
>  	 * foreign real addresses, so unprivileged processes can not
> @@ -1369,20 +1358,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
>  	 */
>  
>  #ifdef CONFIG_PPC_BOOK3S_64
> -#ifdef CONFIG_PPC_64S_HASH_MMU
> -	/*
> -	 * This applies to a process that was context switched while inside
> -	 * arch_enter_lazy_mmu_mode(), to re-activate the batch that was
> -	 * deactivated above, before _switch(). This will never be the case
> -	 * for new tasks.
> -	 */
> -	if (current_thread_info()->local_flags & _TLF_LAZY_MMU) {
> -		current_thread_info()->local_flags &= ~_TLF_LAZY_MMU;
> -		batch = this_cpu_ptr(&ppc64_tlb_batch);
> -		batch->active = 1;
> -	}
> -#endif
> -
>  	/*
>  	 * Math facilities are masked out of the child MSR in copy_thread.
>  	 * A new task does not need to restore_math because it will


