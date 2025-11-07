Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E099CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 021298E000B; Fri,  7 Nov 2025 07:28:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B718E0002; Fri,  7 Nov 2025 07:28:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77678E000B; Fri,  7 Nov 2025 07:28:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D62F18E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:28:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E5011A0456
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:28:55 +0000 (UTC)
X-FDA: 84083740230.14.ECB93A3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id C15D8140013
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:28:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762518533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lOyMRvVEdYsSiyjXfNUQ69pLJd1+OzPJbucd0Fcmtds=;
	b=GOJKKULDQGoI8x/VjEofE4TSWNDZ+SGtewL2lTfuPJi5hF8T3KSAZEDisI1wpZpjEPV7TD
	UAFK50wqSchncqd8bKLBFTmP/CZHtwqU3TNIBrYzW9Kh1hes5VscOLHh88zeAaEjOO0hh0
	kqp6W7CVo6mql0ZJs+AEXS0R3sqPJ74=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762518533; a=rsa-sha256;
	cv=none;
	b=JR1CIb3gJtwRrBkxYIv+AVH6D/xgdmI5s/A6tOxO1o5LDxyDnRMc+QnFy2N5g6gU5+p2Ez
	99g4i159o0b5WlMC4j9L8JNRgtUE0AiF/HIYeYCKwwt0h/M0ltAT0ia9b1SLh+reJwtusC
	JUdrvCKb4KIsVFHFX5i6qX9Va4zGjpk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F191B1516;
	Fri,  7 Nov 2025 04:28:44 -0800 (PST)
Received: from [10.57.86.134] (unknown [10.57.86.134])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EEB03F66E;
	Fri,  7 Nov 2025 04:28:47 -0800 (PST)
Message-ID: <2205a5de-de14-4718-a7b8-e49accb06f03@arm.com>
Date: Fri, 7 Nov 2025 12:28:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] powerpc/64s: Do not re-activate batched TLB
 flush
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
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
 <daa2025c-43da-4c16-9393-a90574d74f64@arm.com>
In-Reply-To: <daa2025c-43da-4c16-9393-a90574d74f64@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C15D8140013
X-Stat-Signature: ee18q894hpcb1ikc9hqjje4gu51aqo9m
X-Rspam-User: 
X-HE-Tag: 1762518533-681376
X-HE-Meta: U2FsdGVkX19RbK4VZ1Hhr4CrSLS6Rkrh8qY/E96QvVuFUGlmASwhe0a7hM73uKzS7NcRwrX7Z6ddbR5oVcVwmCZj9MTYNMAGNlPWQFrPI/Ll8WtMBPqo+WKOJQRuM0uPv+kjmlMiaEe25rRAVEg+aJSI5dLsxvyiYq86thKApoRv2bWlUG5rsG+ZR2WjLfJFQtlSYsxDR3UFNlbFJkflZ1psalv/i/++UmI/R3Bd/BH+0q/SvFwGrZACCqUWlj6r5EAInbyxTEUwhkN+e9MOdlyn81HrsARw4B9q9olyA41TAA8AuIJK7zTPNiS8M28BxJfud4leYbgP+tjmnq/i1sau+vdMPkTOLA73paODwjnd1z1WSB/yXvrIZRnUQytdrS9scBSJjNmqqDQCDh4MmIdJsRoqW4kOA0HSL7Pz63uZq9QI/qWefYs6MaMYnoDVRGg7HIt5cW3xMqOQ4Cgu5uN1fsc8jUqGDeSPyjvrMe+NYuaHuczv7lv1qGFROYCZRWlyPs+ZpXsvooJpyRohDkHlfr7mRsKGWXp+GHw4PKkbeTi3LONoB+/CV96ECZj8qBDNndvyjRcpW6+zowOM77vX0wkpPF/fM5WiB757iJgOMVLVvfOGERbw/lMdd+qAg9n/w7Jju/vV4vH+v99BDlxpvNsOW5kzxF1nqakJ+z22KyT8nRE1Ff6ii4/xkSrLOTkCY4lHr8Q8YwrN1MkEbRnViWYwO00GLDTeRAvQl6m7gsYRkk6xsRHLC7pbL+lTiIYQsDKx7lX9fwEf/i2XBF9FY7u9xg6IKkgP9s66hvLQA5UPCDAw3xKPYeOjFHXdWtGq+6mYyQ6l0MT03Z9mlbK8RD2MJf/cOVVOBTbGYg83LoBtU2oIaUs3yZvJncRchbVXRUkJHpySA2aEqK/5HbPdQfFdR5FzQaXs7YF4WDxou/PvCNoRfrS1bWJyXzGOLaSRBTNl0jFLqlPDpnd
 Ytq59ftP
 SXOZUx14eOxacxQQabhH6ES2JUdknIlusyMGMIVMDsI5aU2AODlewpo3fpwizATgPJDLHzuE0D9XtaxY/RKDdMKYrRHq++A68DAXWrO/DOWNsvyB4ECiYVg3AwfaMGuCUPbcew7YzSEgdec1EoPT/65bR6xKEofNRspNU3iEzMRLxqRgxPLPH3gP41w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/11/2025 12:25, Ryan Roberts wrote:
> On 29/10/2025 10:08, Kevin Brodsky wrote:
>> From: Alexander Gordeev <agordeev@linux.ibm.com>
>>
>> Since commit b9ef323ea168 ("powerpc/64s: Disable preemption in hash
>> lazy mmu mode") a task can not be preempted while in lazy MMU mode.
>> Therefore, the batch re-activation code is never called, so remove it.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

I should also add, that as far as I can tell, this was dead code because the
powerpc implementation disables preemption in a lazy mmu region. It would
probably be preferable to understand why the preemption disabling approach was
added in the first place. Perhaps it would be better to remove that and keep
this code. But given you are not changing any current behaviour and this is
removing dead code, that's probably something for the ppc folks to look into
another day.

Thanks,
Ryan

> 
>> ---
>>  arch/powerpc/include/asm/thread_info.h |  2 --
>>  arch/powerpc/kernel/process.c          | 25 -------------------------
>>  2 files changed, 27 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
>> index b0f200aba2b3..97f35f9b1a96 100644
>> --- a/arch/powerpc/include/asm/thread_info.h
>> +++ b/arch/powerpc/include/asm/thread_info.h
>> @@ -154,12 +154,10 @@ void arch_setup_new_exec(void);
>>  /* Don't move TLF_NAPPING without adjusting the code in entry_32.S */
>>  #define TLF_NAPPING		0	/* idle thread enabled NAP mode */
>>  #define TLF_SLEEPING		1	/* suspend code enabled SLEEP mode */
>> -#define TLF_LAZY_MMU		3	/* tlb_batch is active */
>>  #define TLF_RUNLATCH		4	/* Is the runlatch enabled? */
>>  
>>  #define _TLF_NAPPING		(1 << TLF_NAPPING)
>>  #define _TLF_SLEEPING		(1 << TLF_SLEEPING)
>> -#define _TLF_LAZY_MMU		(1 << TLF_LAZY_MMU)
>>  #define _TLF_RUNLATCH		(1 << TLF_RUNLATCH)
>>  
>>  #ifndef __ASSEMBLER__
>> diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
>> index eb23966ac0a9..9237dcbeee4a 100644
>> --- a/arch/powerpc/kernel/process.c
>> +++ b/arch/powerpc/kernel/process.c
>> @@ -1281,9 +1281,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
>>  {
>>  	struct thread_struct *new_thread, *old_thread;
>>  	struct task_struct *last;
>> -#ifdef CONFIG_PPC_64S_HASH_MMU
>> -	struct ppc64_tlb_batch *batch;
>> -#endif
>>  
>>  	new_thread = &new->thread;
>>  	old_thread = &current->thread;
>> @@ -1291,14 +1288,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
>>  	WARN_ON(!irqs_disabled());
>>  
>>  #ifdef CONFIG_PPC_64S_HASH_MMU
>> -	batch = this_cpu_ptr(&ppc64_tlb_batch);
>> -	if (batch->active) {
>> -		current_thread_info()->local_flags |= _TLF_LAZY_MMU;
>> -		if (batch->index)
>> -			__flush_tlb_pending(batch);
>> -		batch->active = 0;
>> -	}
>> -
>>  	/*
>>  	 * On POWER9 the copy-paste buffer can only paste into
>>  	 * foreign real addresses, so unprivileged processes can not
>> @@ -1369,20 +1358,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
>>  	 */
>>  
>>  #ifdef CONFIG_PPC_BOOK3S_64
>> -#ifdef CONFIG_PPC_64S_HASH_MMU
>> -	/*
>> -	 * This applies to a process that was context switched while inside
>> -	 * arch_enter_lazy_mmu_mode(), to re-activate the batch that was
>> -	 * deactivated above, before _switch(). This will never be the case
>> -	 * for new tasks.
>> -	 */
>> -	if (current_thread_info()->local_flags & _TLF_LAZY_MMU) {
>> -		current_thread_info()->local_flags &= ~_TLF_LAZY_MMU;
>> -		batch = this_cpu_ptr(&ppc64_tlb_batch);
>> -		batch->active = 1;
>> -	}
>> -#endif
>> -
>>  	/*
>>  	 * Math facilities are masked out of the child MSR in copy_thread.
>>  	 * A new task does not need to restore_math because it will
> 


