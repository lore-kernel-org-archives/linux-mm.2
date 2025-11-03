Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D10CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EDAB8E00A1; Mon,  3 Nov 2025 11:15:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5478E0057; Mon,  3 Nov 2025 11:15:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901F08E00A1; Mon,  3 Nov 2025 11:15:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9598E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:15:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4879F1401DD
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:15:32 +0000 (UTC)
X-FDA: 84069796104.06.6BECA27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6430A8001A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:15:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pMmG9L/w";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762186530; a=rsa-sha256;
	cv=none;
	b=E7vkIwtzwsDuo/I9JrxN/jyyN0AlmR+BD9FsFDf0B5XmmJMctYIsuOgoYvVrXK14lDML1I
	klwpOfgFlIcCg6BktT76bfcYSAQnVgQDLqpzWb3SRobEItypO6oYfJ81MErCEFrJQDWS9m
	9XoFPXrO5A369P0wQ7waBK2qaHpi2jY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pMmG9L/w";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762186530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwOqk6r952fnoq6kqx5JJLxmDxQO3I/qHQLZzHd75RQ=;
	b=wQ9Dzas2xG/v4JGSY/rQbHQdYYgtaSLF8poQJo6AXbI4a++L1+ON5MFnH8ja35LNl/wQrF
	EUkqBD2D8yibGl/fcyIYDv1Sg2XSkBhEohuKr9mkg9/f8zyXhaoT9rzLYjgYzyI6RK7CdB
	LSNLHP89hqlDHGSRH3EUhCpZplmbqsg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D68643BB2;
	Mon,  3 Nov 2025 16:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BE5C4CEE7;
	Mon,  3 Nov 2025 16:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762186529;
	bh=S0YKJr0SoBmysmz8IMr3QugNjlhYpJzfR41WjPWBUB4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pMmG9L/wSj8xOcK/DzcO7x+pUKpbN+kaGWRhPKGT/hFa2p/Ay8Nl1Mzz1ZWUyScDa
	 vucJ0XbF6T0spIoI3AD/0qxqWiVKMh+Mmks24qxQFDpKZf3Zexx64cDs61lCh6Efy6
	 od0TqupiK1VEnDg7glIHKRlBc357kZIMtV/jM6SD3qxje1H7u2r4taFzH3oyOWmxWM
	 hHnL2j3jQ8KEJexQD4wpbJBjPfYdQst+gwFFqah20VMhXD96dyPMbnm/scOYZnijeO
	 WcP/Ww9iS8dXs6EdOUxwooqxO/I0VbjvAaMNzv31ZZN/WtGdcK9zJR5blHKdrg4t/9
	 0WafEdG9rsGng==
Message-ID: <c7c8a233-2103-4b48-b65e-ec81666d20e4@kernel.org>
Date: Mon, 3 Nov 2025 17:15:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/12] x86/xen: use lazy_mmu_state when
 context-switching
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
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-12-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251029100909.3381140-12-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6430A8001A
X-Stat-Signature: 8bdyybqqbiwbo3k8i1a63oah45oe38io
X-Rspam-User: 
X-HE-Tag: 1762186530-1159
X-HE-Meta: U2FsdGVkX1+WknSajRgI0UN19mucJMQx7UNq0y/4nzrN5wvuNTiObvTn8EmXrAh5lw7bitKQKeu+4GqyH8JUs1+4XY/eTNPGJ+SaBvKQduu5rCF5eNh51o5cB0PoQoSVfiyqw1yGikWRW5O8xij0IKfqk72f0xwYu1r7CaODE8E92gW1E5DMA23bpH3Y8PIbd3v40imbJbwQgxk62KwWW1ORAU76+cCbodj4omqYwIVPm/Gd79saHsIL04Qq3Yse8Wa8UgvS5bJnYwgj0TJgAtrnqATicN5xNkkeDUqkk8lq+yemIigz3GmO/J+dtVv9TzKh5qaWviBI+mwcw8SAK65AmSGRnGfZfrj5l9QEiDvbiPHH8xEsG+h7bv9BC9uERkeW3PFchNAeOIZs7I57cDqMNAhHV5Z7x/uwQPUwhddmP6I9zQfpc2TUKNUn5kH8BNcXUc8fYFOvHCiggKq41gv5Kyj7XtKWfR+qxq720woNGi94F3H/E06F5GhiSAkd3XqJHTdJ8wJ5mW2iN+W8/ptwFEQ3av+rkZCt6FXNB4OHLJVoHYYJ8F6F5y+RRMo85nzaVfer0112lj2qiYccQK4y157U6U0q+3c97EI2atuDC8/toAl9wH4nuO+mIUXJjEFL7ShJjYq7PpcWgh4DxeK1jU/bDqHoFjuyDGadR0C79PDEpwpwklMWIwZ4coYG7Zgn1z7b0d2lJaJjKb1H3y+W8GKN/FMZRuB0kaGZwqH9cxCoSC6KuzRGDrubLu1HNPWVOSn3jjsa+ThMwPjIyKz4USBSqiMT1+f9bQk9YY3v1Qdb5xX+3w7i6UXp8t1GV76cASDlSYbWDV8QePCri1llezvuGZ4fvh1hjyeXVKa3WCJ80+E6oXFIMWxCJGu87WaB9w3xpIZ6an70IUT9Q/CUw5qlaKxLEVzYD7hofk8qmBfDjqDNq7b+m/ARbCxwnPoXygplFe3/oc2u6A1
 BEGieXoJ
 sM1zL0BYzwDTPANNUQ8SAvcYXMaXtoWYgHLVBoVgYWn2I0ruWsS/U9Q+INIjykMBTCtCZjEjFLz1qsQX4LReW3hwel0tXReRPXRv+TYbkUSRdKquyb28qTeUel2G0aViAOZzcsZafNgqwZJjutLT5T2jK/J+pTgUKEBP3/o25+4s4bOfhb3yIDKRLhScecZ1i2Idu8A+VkcKD08QruQyb8UaYx8XND1aPs6SPYNge/XtddJreDgnqw6+1QcsaUwoaLpq51sRzjTzY2wBjXc41/DEIDGuss+OdC5fDnGuK4Hy8PUE2FdeUMrV79XfDY76qNZXSbyN5/ZqDO6e0WOGO2uiKfD/3ptdRPSHK9lM1pz5zta8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:09, Kevin Brodsky wrote:
> We currently set a TIF flag when scheduling out a task that is in
> lazy MMU mode, in order to restore it when the task is scheduled
> again.
> 
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode in task_struct::lazy_mmu_state. We can therefore check that
> state when switching to the new task, instead of using a separate
> TIF flag.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   arch/x86/include/asm/thread_info.h | 4 +---
>   arch/x86/xen/enlighten_pv.c        | 3 +--
>   2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> index e71e0e8362ed..0067684afb5b 100644
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -100,8 +100,7 @@ struct thread_info {
>   #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
>   #define TIF_SINGLESTEP		25	/* reenable singlestep on user return*/
>   #define TIF_BLOCKSTEP		26	/* set when we want DEBUGCTLMSR_BTF */
> -#define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
> -#define TIF_ADDR32		28	/* 32-bit address space on 64 bits */
> +#define TIF_ADDR32		27	/* 32-bit address space on 64 bits */
>   
>   #define _TIF_SSBD		BIT(TIF_SSBD)
>   #define _TIF_SPEC_IB		BIT(TIF_SPEC_IB)
> @@ -114,7 +113,6 @@ struct thread_info {
>   #define _TIF_FORCED_TF		BIT(TIF_FORCED_TF)
>   #define _TIF_BLOCKSTEP		BIT(TIF_BLOCKSTEP)
>   #define _TIF_SINGLESTEP		BIT(TIF_SINGLESTEP)
> -#define _TIF_LAZY_MMU_UPDATES	BIT(TIF_LAZY_MMU_UPDATES)
>   #define _TIF_ADDR32		BIT(TIF_ADDR32)
>   
>   /* flags to check in __switch_to() */
> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
> index 4806cc28d7ca..f40f5999352e 100644
> --- a/arch/x86/xen/enlighten_pv.c
> +++ b/arch/x86/xen/enlighten_pv.c
> @@ -426,7 +426,6 @@ static void xen_start_context_switch(struct task_struct *prev)
>   
>   	if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU) {
>   		arch_leave_lazy_mmu_mode();
> -		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
>   	}
>   	enter_lazy(XEN_LAZY_CPU);
>   }
> @@ -437,7 +436,7 @@ static void xen_end_context_switch(struct task_struct *next)
>   
>   	xen_mc_flush();
>   	leave_lazy(XEN_LAZY_CPU);
> -	if (test_and_clear_ti_thread_flag(task_thread_info(next), TIF_LAZY_MMU_UPDATES))
> +	if (next->lazy_mmu_state.active)

This is nasty. If in_lazy_mmu_mode() is not sufficient, we will want to 
have a separate helper that makes it clear what the difference between 
both variants is.


-- 
Cheers

David

