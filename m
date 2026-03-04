Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C3E4EB7EAC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB856B0092; Wed,  4 Mar 2026 04:02:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783F46B0093; Wed,  4 Mar 2026 04:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68FF86B0095; Wed,  4 Mar 2026 04:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5356B6B0092
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:02:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16A521604D9
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:02:53 +0000 (UTC)
X-FDA: 84507790626.15.A472B8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6D8FC80004
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:02:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HhixUQ6H;
	spf=pass (imf30.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772614971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DHo8nnofvS0v9zWPBa2XQHrIeh/6sZBlfpPvEqhW5g=;
	b=t7FRfD2qKcggKJXV5mi+fEl+Wqh57XozfwEME0vFRAB86Brd8r+U/lqgMs6pMbg1WZeZIt
	nM2gj/rqn8rKlNRVMISigRGBKVqFT3NxAYoEn7TicSVFCAhvVDCNXG2d9Y/4AudLSr1+7I
	y4CLpPzPmmxFTnXspszsC7LVTu3eeoE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772614971; a=rsa-sha256;
	cv=none;
	b=Yki7TzbW7IZYuY6AUFCpe7EAsXWUEupU2z+RHyU3E8UW2Vjlxc8rq59kjDvIdmi8qjBrdr
	ZEWgzaRCaaOYG5fyvf9LSa7DFBnaV5VDEoAAC2nrxIsEJ+MFqXR+VlfvQOh8LepPEZzhNA
	5raic7mwkNHEb+LlLpo3/M0NrVMEW54=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HhixUQ6H;
	spf=pass (imf30.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB11F60097;
	Wed,  4 Mar 2026 09:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A82C19423;
	Wed,  4 Mar 2026 09:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772614970;
	bh=kxfIGChB2wC+nGHup8CVs7dyrylhcmHq5LK6PQjxQRc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HhixUQ6Hh4hoRpXlkVOmTId9s+P0IjU3EDdIeeT9+mpTbOUx+A28yRnTUnROHq7y7
	 JdwDgCknbvOQ8P4fwjeO82HZKw4HYFFSZqansP/wuuPBpm/b3ldEYMU5ieW8DmGakr
	 fJHL4DP0s8AddWHaYFgzv54RvRLx9oiN6ycuU0jK7mroppUgjLyzi8X5GhxYSKZ+u4
	 rfUEaoVOOZo0SQBMWziJ5uh94KT5cN2O7wwEDZRWpMav6EwASPxK8pST3CiQOUkJ3q
	 KTX+0X8FOUH+zchvZ7qlwozteoijtM7XLPnXqtCyYvoitu6x/Q6mVfWu3G1ho8y+k8
	 uRWnMQmllPnfA==
Message-ID: <9d07ed92-ca0d-4012-bbb9-b2dc37f17f44@kernel.org>
Date: Wed, 4 Mar 2026 10:02:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 06/10] powerpc/64s: Kill the unused argument of
 exit_lazy_flush_tlb
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
 <9385e4fbc4bb99ba47ea6070fd82233e6576c228.1772013273.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <9385e4fbc4bb99ba47ea6070fd82233e6576c228.1772013273.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6D8FC80004
X-Stat-Signature: cdctfx46ot3padky95jdbfpnd9xf633b
X-Rspam-User: 
X-HE-Tag: 1772614971-337490
X-HE-Meta: U2FsdGVkX18Ex90tM9unk5ZxtCzn2A4Il6P8KdDaYbSCigvsEtvtH4DGWee9F1ImXSo02RW+n3x9mIwkYBXLF1oFLHaROYf1pX2jTDf9bWgLggzqrbbn0Gch3QOW8zHQV02G+iFd8TmA1Oy1zkzmoJ1AFhePbbmqn+1ccgSJiRtYTHr79VTQQXQH5T9Da4Awa/1hoopZ03GLn4HLsore7++hm5fvUTn0lo8Y/tm0+ESYTWoe6PAmPHGuErajMj1W+WjAeBEQDnyICedqC69zVXVn7bpo2qSNXEKUGlV+l3Xj7szpmwd3NB+dkxMNbJ1NW6gxZdzvhgPOcf23PwMVoTJuZT6w0P8n68O2bbXg/CWnpCu6wArRrLZY8UtU8ERt4TniEasyjWY7bOtFQ+AzkGzXT7JsENsoAp8zHkO8Vuhe9+A1RzAivLEGK9tmdax677Av9NN97TNYB/WVfYFlX4tLoaHvWipX/zNTuIiDHUbwX1sUj/1xw8+3VSbzx/ssaSw+fyXxfw2lG6FCcr1Cr/ktadYTx3iiSoajLgcYsVf/jkUYURCYSQTa06xW4ppEC0GvbnTXWczOo0Y93QrR85P/IE/QuCJAKz9BR2eQ0AJZQfiWt/skaABmx1y92/XK6gOCjVkUUcl2RST4W8ZPJlsDINLTb7fNM9FBe0wueUnRhG2Ed8Kq9fGNDkig1bMprh//LtrDzJ/IElFln4meUq7eX1/7dRAZBLYq3v0IDpdbUjHK79FTxxneIFwh/FNDSSuU6dyEMd+bB5SEGjk0iHCsIUwKAcnBMTuH4vM3upaanRdE0w4/QLE4o4SFANrkmA8FrmGwaYd1CIAu33o14BAzW2cGd8SMWGcu7u86HTYuVfnd8kNQpCS9ZO82P0TxDK0VuYSKbd6pvwZcDWLlOTMBN4D8jeCU2eCS0YFjIcRCGR1SzkNh1GK3KpWxaqIg+xjG+9YIeh3YsJcWS6A
 mXHjVubo
 /VwAHVV52LthPaoAIVtKr35F5j2BG0hqlLX2YFzWKS4g4UnXvISbCuF+IZGg4++3dKh6K0X93sDa+TrpIzD1Lq+pcpuK4MG+0cJsQrOZRl+amp7pZSAsAL22Vxl7edhLaO8G3s7hM8jyRgHAV6GN+bIM8MBp0VzV6O6Jm9VgxrQBabWFNcP1kFqHM57wpAfXQcZNL6sr19PPO1qXwtYNIt3GlnbtCIojIfP5jQyni7YT72pghJf3eiiw9eAyD6kni4GjQqZaPm4AffsDinDc6mx6hpRcOSXgMWqf1fvmJCjidibn3prFzLqYcodwbXk/t8Zn1lOCKNgYE+OhDhHky2Fl54o9Sa6opvCyTAcFuZ2Z/B49jS0trtE23sgl21V89XeNbHKtebwndQ7HxuyyDvBxFl8OBzBSeir++HKHwrLE20SfqCWHmsB93rcCsYzQHapPdwlznhwk8t6tR0GLP15lUDacBgY6BIgAA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 25/02/2026 à 12:04, Ritesh Harjani (IBM) a écrit :
> In previous patch we removed the only caller of exit_lazy_flush_tlb()
> which was passing always_flush = false in it's second argument.
> 
> With that gone, all the callers of exit_lazy_flush_tlb() are local to
> radix_pgtable.c and there is no need of an additional argument.
> 
> This patch does the required cleanup. There should not be any
> functionality change in this patch.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/mm/book3s64/internal.h  |  2 --
>   arch/powerpc/mm/book3s64/pgtable.c   |  2 --
>   arch/powerpc/mm/book3s64/radix_tlb.c | 14 +++++---------
>   3 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/internal.h b/arch/powerpc/mm/book3s64/internal.h
> index cad08d83369c..f7055251c8b7 100644
> --- a/arch/powerpc/mm/book3s64/internal.h
> +++ b/arch/powerpc/mm/book3s64/internal.h
> @@ -31,6 +31,4 @@ static inline bool slb_preload_disabled(void)
>   
>   void hpt_do_stress(unsigned long ea, unsigned long hpte_group);
>   
> -void exit_lazy_flush_tlb(struct mm_struct *mm, bool always_flush);
> -
>   #endif /* ARCH_POWERPC_MM_BOOK3S64_INTERNAL_H */
> diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
> index 84284dff650a..52d3e0c4a030 100644
> --- a/arch/powerpc/mm/book3s64/pgtable.c
> +++ b/arch/powerpc/mm/book3s64/pgtable.c
> @@ -23,8 +23,6 @@
>   #include <mm/mmu_decl.h>
>   #include <trace/events/thp.h>
>   
> -#include "internal.h"
> -
>   struct mmu_psize_def mmu_psize_defs[MMU_PAGE_COUNT];
>   EXPORT_SYMBOL_GPL(mmu_psize_defs);
>   
> diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
> index 9e1f6558d026..339bd276840b 100644
> --- a/arch/powerpc/mm/book3s64/radix_tlb.c
> +++ b/arch/powerpc/mm/book3s64/radix_tlb.c
> @@ -19,8 +19,6 @@
>   #include <asm/cputhreads.h>
>   #include <asm/plpar_wrappers.h>
>   
> -#include "internal.h"
> -
>   /*
>    * tlbiel instruction for radix, set invalidation
>    * i.e., r=1 and is=01 or is=10 or is=11
> @@ -660,7 +658,7 @@ static bool mm_needs_flush_escalation(struct mm_struct *mm)
>    * If always_flush is true, then flush even if this CPU can't be removed
>    * from mm_cpumask.
>    */
> -void exit_lazy_flush_tlb(struct mm_struct *mm, bool always_flush)
> +static void exit_lazy_flush_tlb(struct mm_struct *mm)
>   {
>   	unsigned long pid = mm->context.id;
>   	int cpu = smp_processor_id();
> @@ -703,19 +701,17 @@ void exit_lazy_flush_tlb(struct mm_struct *mm, bool always_flush)
>   	if (cpumask_test_cpu(cpu, mm_cpumask(mm))) {
>   		dec_mm_active_cpus(mm);
>   		cpumask_clear_cpu(cpu, mm_cpumask(mm));
> -		always_flush = true;
>   	}
>   
>   out:
> -	if (always_flush)
> -		_tlbiel_pid(pid, RIC_FLUSH_ALL);
> +	_tlbiel_pid(pid, RIC_FLUSH_ALL);
>   }
>   
>   #ifdef CONFIG_SMP
>   static void do_exit_flush_lazy_tlb(void *arg)
>   {
>   	struct mm_struct *mm = arg;
> -	exit_lazy_flush_tlb(mm, true);
> +	exit_lazy_flush_tlb(mm);
>   }
>   
>   static void exit_flush_lazy_tlbs(struct mm_struct *mm)
> @@ -777,7 +773,7 @@ static enum tlb_flush_type flush_type_needed(struct mm_struct *mm, bool fullmm)
>   			 * to trim.
>   			 */
>   			if (tick_and_test_trim_clock()) {
> -				exit_lazy_flush_tlb(mm, true);
> +				exit_lazy_flush_tlb(mm);
>   				return FLUSH_TYPE_NONE;
>   			}
>   		}
> @@ -823,7 +819,7 @@ static enum tlb_flush_type flush_type_needed(struct mm_struct *mm, bool fullmm)
>   		if (current->mm == mm)
>   			return FLUSH_TYPE_LOCAL;
>   		if (cpumask_test_cpu(cpu, mm_cpumask(mm)))
> -			exit_lazy_flush_tlb(mm, true);
> +			exit_lazy_flush_tlb(mm);
>   		return FLUSH_TYPE_NONE;
>   	}
>   


