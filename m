Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1651CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 02:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D7B8E0007; Tue,  4 Nov 2025 21:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CEC8E0002; Tue,  4 Nov 2025 21:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1056D8E0007; Tue,  4 Nov 2025 21:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECF5D8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 21:55:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78AF955F38
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:55:20 +0000 (UTC)
X-FDA: 84075037200.20.FDEAE86
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9A87A140004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:55:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QTy4BSXV;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762311318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzRgxKaFFDli8ftuhQFfyH2ObKCMh7+2PDYIIzQvueg=;
	b=vt8mTJoqBS4Sm+P2L25/ACFdi5lCQYRWc26bsDHQ6MH6Kzmm0VxfA++dTO1FMhWo5R38rr
	HS5AfhT8YL4ZZ2tDmYlmZ3KHDQmFrFeumtjLD/1pmY7YPXw0NtHvcKhqaUY5/Oo3v8PSYb
	/l29HLNzjdivwhh2rD1o2ZZM4P6fFN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762311318; a=rsa-sha256;
	cv=none;
	b=ax0CzGl0DT/BX/RONYqpw6EwZpW3SIYqn8iBgNrkiDrWMvaKV4HsELeK4G6F/jcL9kI2l9
	63oq3rO2r/xZL3dpK9YBBOk+TMq1rwiz11IDwfxZKB/yjWYtSHyQPmUxTHr4pyRGA0Z3SF
	ao8VpnFwuMepuSVVs1L2KZ4cmEVA+v8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QTy4BSXV;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-295247a814bso68681415ad.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 18:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762311317; x=1762916117; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=RzRgxKaFFDli8ftuhQFfyH2ObKCMh7+2PDYIIzQvueg=;
        b=QTy4BSXVwhs8W3OHCPGZ0pZJds3hZ5OPt5rPDMikmqJ7pxS/3p4gNONfvHXYGzVlxU
         kqRKejz0ScDhHEqJW2enzr7Dnve+ZQX6Dxx2g0PvRGza3b4NSrQUskD25WXdi6CMDJVZ
         rjqiHg9xes+9j4kGbComnT8pzejFxX8ZcGfi2L2VXldBoxdDTQvWKy5JBDwivXDjDZFH
         AWHFITxfJdNQtyXPG/YAwzdwOc5POr2/z64sqCUGByCLOTA7o9X6zEIRYL3pvVKO9ujt
         pOEVbyJJRIGOFiL3dnYov+arJZsm04TQPoyUYSJ0T1Go+cYw0UeEum5zcnAKbn5suYAn
         z74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762311317; x=1762916117;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RzRgxKaFFDli8ftuhQFfyH2ObKCMh7+2PDYIIzQvueg=;
        b=QWVbkX/P5F27YTtBp5E+mp3NVExCfzhAuqTyl6CGqFvvNbwHia67tcg7aMcWxHg8e/
         m5tED8Z/29YVYTSIc+VOA4sEwjHbl4tmZJqfIaryIAdEC780PPahmtqs1rm+euIxzsmN
         v5kPIJ61DTm6TOIvihmtqLUTqSe9g3MsAe8YZdo86QVyl93RpBcgY0bhy7DBJAP7Xe6j
         GPqe1yAgrotXbvZAnJqzVGKBG9ZRCINk/N/pPmI0uVZ1kqNaWh997Edbq+hEMpQi21fv
         o1D5ExNBCHl6/pGVF8cse2mW8xfFGKdJ2hMyXVQmw8G4U38pI/2r5VCeXdGxfVB/EnRx
         gAIg==
X-Forwarded-Encrypted: i=1; AJvYcCXw9wJQ8+ikqxvX9+kA7T/b7LhQ+DJeCNlQesKCA9we3XFFhnd+tf6yO+lDmYBlLIdrHUjWaMBjuA==@kvack.org
X-Gm-Message-State: AOJu0YySU5KbLKlkGLCsaxYsp9O0ATQ+8c3JHA/bZTiIeKw6EvRouOyc
	5S5ymRTboo0cjp1kXeVPlvbuRcgJ5Sb7SNIBV4vXmue8RzTOCnLj3stT
X-Gm-Gg: ASbGncvKwZT2N/fRl6ivP1hIhBX8s9KNgnPRYkf+guhcp8WN546KwxdgZmWLlW00g73
	+tMCWqoPh81OJPBEP1pHKqAQp265Fi0HkTFrO7Vp8I/7xgV9p2hcAEnXo+jBb3P1JfHfTfR7PW6
	5KY+0dz62RpYgAxyd/5CLbA5XbrLbkrx2fvCtNF+LbJLdvKHoU3UMliKKykVz27vlhfPb+3jvmf
	ibSYhd72ZRNDS22LIHi+a9AO8ovRAE18k7S3YjmTFH75Dh0BYB4gCzGbsLU4/3a594txQbmsAPR
	rBHSVlgJAESVAc8O2HRfvFhW+1qVck1mwjadGWtYbJdk6QoSc6kOelFU9lt4wBzn9/ZGeEzmcdz
	epFLtevHebBieeR7ve4EMZr2gilWwDuxhSVBa1UjoC4pcF10JEKq4EctmQkl7mMu6o6Ylkg==
X-Google-Smtp-Source: AGHT+IGwTm7URkxWPNS/uaQT82VrA80foZj+Jgsm9GWgCIbhw60EG5vfai2y+vo+uSLgfxHG3bwlGg==
X-Received: by 2002:a17:903:3c4b:b0:293:33b:a9b0 with SMTP id d9443c01a7336-2962ae10998mr22075795ad.32.1762311317247;
        Tue, 04 Nov 2025 18:55:17 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29601b8f28esm43621645ad.5.2025.11.04.18.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 18:55:16 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, 
	Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH v4 01/12] powerpc/64s: Do not re-activate batched TLB flush
In-Reply-To: <20251029100909.3381140-2-kevin.brodsky@arm.com>
Date: Wed, 05 Nov 2025 08:16:58 +0530
Message-ID: <87qzud42n1.ritesh.list@gmail.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com> <20251029100909.3381140-2-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A87A140004
X-Stat-Signature: zege5wk9b6bfm4j75b8o9kf546y7fojq
X-Rspam-User: 
X-HE-Tag: 1762311318-162773
X-HE-Meta: U2FsdGVkX18cqUTA3qZSrJQ+fK2uAftRd8MOO/qoHR757XBJsthb8UdFHm6j1AMMkHfMjwyBuNh0/xaMiYwE/l4sWsPnrnmeWAhMVRypAt9ViddRLbaxuBzqO5MGbnVyCAlWRrNkAiCYYI4z3ho+nLpDuV6Aa89moPfX75OvEV5BsGBT4vJDPD/2rzlAyDjXI64Cl1VFYTp3FekkmbROmuFnsMjnhn2RpwN+ZSX/jjJJDLEKllTvv9z39vKQEcGH13nPDxq7K8MiiQ1b9Xb9mHDutP6UCihEb8fCsQ3GReQna2RyNf9LdGPXlhyyqbkqpaOWhIYxiGAVzWPZNly8g3C1DOvDAsycxTOQ3fbNYZIWqhH4ApDCkcEHzlhB80oxEB+8nS9ODT8HKHcubr1d8AgQVmsf2Mrw8oo3SpfG+Kja56DQ3/NV1Zo5VQhfKsdI2o74dEdJHZK+20uBl+6LCtvwgu2vEpzWNe04w+tN1ZZ+stzeQzcw+hg+caSDiqCqFXimWezWUgzILdqUbitfxWTCMfEB9Dmtb31pC86LlAjSXCMavs0BvGkzSmFTaAxRG4ArmAOxvxqeqWhgG8vf7zqfgysGiiUWYulUEa7KYXjO7gqaG5fjnnOnbYbyUphCxpDhdzuyIsbjBWwtQ3cdFpDZgvhDGQ8tJP8fLEnBZ/c1Tt0EZkP04LYI6h8wZYLIKAX5FBCGIu2RamRG5RBlc/rFfI5MesFW8ze8GsvV0PiEx9uaTYp8GAJkVL+zTF41g4NL+D+Zp0JLyuS2NCyygHoo5tHZBkC4ThXgH4t2xbT5xNNmJzomh1e/AHSTce6DhyH8IYG25jRPryXX+O+m27bU9kolhkMhIE9gq3oh3kBLD23+pnz8Y4fwLSpENqTDG2PC7Zj9dyM8JmjVCPpqLh2n9so21s8xmSwfyKu6egqfn6/c0pl7WUIiKm5xqtOWgtSX/iZFXZKfhTUqTzn
 C0+bhx9h
 of83gpcRdn/M0nshWz8gv19ZlS4r9TQKy3BeomtoRQrtEIacQuh90mgmbmO8oPJHfqETj2e3izZ0Ji6wCHJcKchT9OL/QLhLgMBy7pIiR8o64h8FBy4r7yZKqxSCq8+nfHNqRXQixw9xGrHZloUGJyPGb3J6Uuv38NQ3QL9Su2WGElnphOHhnCS9ePQlHLR0kQb1n+hlkTdgQdff5y7U6KboHXW67u+5lPMzgks1oc8oQRYu6ZsvRKxjNT1JNYljgfAIGWVgKXk6+NqNbphIhkN/jCmNBJBmn4OKGz1drBpkCKwMgpkUY2AuXDQ+6bflLbIgvprArzfsxcwTi6aZbzjXIRQC9fzUz4PNi7it9zBnTERHiVGNKKCaHVGVN4vpNBkNUTEkpnqVUresjmQSUoAI336l/WG7sEMK+T+0BI2LX6ZAAqeONXBZeExx3MoyfQ5wGdEiskFaYkFxT4GxrzgXv6LoRcEx7RyxcKjftw3x2MU0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin Brodsky <kevin.brodsky@arm.com> writes:

> From: Alexander Gordeev <agordeev@linux.ibm.com>
>
> Since commit b9ef323ea168 ("powerpc/64s: Disable preemption in hash
> lazy mmu mode") a task can not be preempted while in lazy MMU mode.
> Therefore, the batch re-activation code is never called, so remove it.
>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/powerpc/include/asm/thread_info.h |  2 --
>  arch/powerpc/kernel/process.c          | 25 -------------------------
>  2 files changed, 27 deletions(-)
>

Since the commit referenced in above disables the preemption in
arch_enter_lazy_mmu(), so the expectation is that we will never be
context switched while in lazy_mmu, hence the code changes in
switch_to() around __flush_tlb_pending() should ideally never be called.

With this analysis - the patch looks good to me. I will give this entire
patch series a try on Power HW with Hash mmu too (which uses lazy mmu and
let you know the results of that)!

For this patch please feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


CC: Venkat who also runs CI on linux Power HW for upstream testing :)

-ritesh


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
> -- 
> 2.47.0

