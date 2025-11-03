Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A1FACCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96EB88E009F; Mon,  3 Nov 2025 11:11:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946828E0057; Mon,  3 Nov 2025 11:11:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884688E009F; Mon,  3 Nov 2025 11:11:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73C478E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:11:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18BFE57775
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:11:20 +0000 (UTC)
X-FDA: 84069785520.14.D616BEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 38C9340012
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:11:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=npyBUuqj;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762186278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCjTDwFj2KWNd1jCDA9nTD0PkDT+GyDs4rwXMlsXX4Y=;
	b=utLzmC9mNz5xw+VZZF2XxER2WMEEH5txERHNbY2SEfAjvfuLtMveo9OWgy4zecC39jf1fj
	wqrcQJ3lp3xeh5zrRJ3xBJ+mUyNra4XxHVcgwvDBMDZ2yYeiQBhuMaIsPxXMmFfhwR4X5N
	z0hzl6mCXU1EQM5ViVfv8+5Ep5HDjbk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=npyBUuqj;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762186278; a=rsa-sha256;
	cv=none;
	b=Yv99V0REgi+zEWmWRTimi0jwftBEXQe8SzliFeEt3S/eOkVUqTZqCmC/fSR/HsuujE4NjJ
	f+Dtu5OFJXHagDxV2RL0eTHDJgvB6cdQ8kvWSHBonbf1bQApxrEu+zQJxSYz9AoaLZqDwj
	hO62MqoN0iI+EzY2tHG9mh8IJmlXLYk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF01A43237;
	Mon,  3 Nov 2025 16:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A46CC4CEE7;
	Mon,  3 Nov 2025 16:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762186276;
	bh=V1CU9ZdjaPBn/WuqIoDgCoBVzQIejoJ47+/3Iu7JZPI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=npyBUuqjUIKg4InV+qpRD6OtpMB4/GHdS8B1NFF+Q9yYKiP+sb3TgKsbqJH8Sa1rZ
	 IjmKf10sHhPZ9tJBExNMfKK9yT/VFR2YIZ9V/xn9DQdnHw+celZDegZhXdLQrF/SN5
	 lUex3DQHMkchog6zMIgVbKEfsJTbKokiYZLXNK0+peJ+RcXLboT6AnCcS4v+iq0vdd
	 UNq+DePKElJQaoqkKpkF65sYRbAzqC1oOL9GKK49eQoY+wljWRBdmHyv0D0R45C04e
	 nEuXWJ5n/3CnJfkZVAWRCYTclKE+cKq52lFKq1tbquYMBGM5LejdtS3JnqVMyuKIJJ
	 wBZRvG6pryrXw==
Message-ID: <15381b5c-726f-4eda-8ffd-c95c0acd7635@kernel.org>
Date: Mon, 3 Nov 2025 17:11:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/12] sparc/mm: replace batch->active with
 in_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
 <20251029100909.3381140-11-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251029100909.3381140-11-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38C9340012
X-Stat-Signature: thf4q9n8tynqisnipqh7yqe645y64uxf
X-Rspam-User: 
X-HE-Tag: 1762186278-864191
X-HE-Meta: U2FsdGVkX1/zH40VR6EwJq/yABdmeQKanPWrFlw8K+VlXoJ9TFBVORjxHZp24Ly9CdANdCUFXev4jdehSRFmpnVRYZfRG7H8zf80ZhK2Mf9MjZBfGRmD36qEjnmmvo3UCnqxY33++hQjkWZm4XpUeCRYmLbBapsEnC2/Tsjm+F6bqbBwmUDmn2CXiWZ0iOA8b3DjAKDbWtmVMBwcrdvsi03LwC1hRLwQiG6vI9Sjklcf7z+4rovDTQISDFtEiETXlaXvlts9BuQTIr4QVTCyQY812BnnhgWdjMYxNsmcBPS5wLx0cTwQPxNVFeW5sTYBv9eYs6MqNAUdraZAbAZi4cbLXp1VLJ/zrabU6NNgu+4YdRBoV/FxTIgOXSYuhtFQoxheLO6piX5/xAitL9eg6QG8WsIswwNcYe4KahBO2W20ZieJ2fLDvPhPJ3PLqD98yX4ON9m73Ngxd6dCqo3Fuybg5H/5p7nH/N7nc10jxu2chJXDt/joPSU3bzfy0JOgbCN7w0GB3I+iTIcGTiqMItWv4h8i8D7vJ9FfzqXDNfT2kTOlHn6sw5EwJZlDwAIbMIv0qifaHsaHgzS9ex9DPyWZvEVa/Y4+tPDYBfFc80q97j6h5xXEx7y4AsyLVf09EAirO2dkS/jIIBfCQVTniCxnI1qGwlpNhLL2rEk6WAcdgwIAt+N6K+lpxLyr/z1bGEDcolxOJmq1cUNlA6oXnZY/lKlO3Z9C6X+bOjo/ZBSFF6BRsAGQ53uMS610WH02ILdVURcF0mTgWTisvp0pTxXewCyT/Si4nj60rmWtzT011Go/iWsee0iRfuTur1gQ2iGA4Ej6/p3zGyh85UI1CW0A+l4nmgcR17GkBd9Q6jQZvlgTvlWDoNxEDzabJZALcWDxA6zEpnL5dPzbwKHuWqKiDhMoOGj6PJwMHkfenBCad5HkKW41jODX1RquVjPG3KbmRYIuH6knvB+zmRu
 iaAga4mj
 E1A2+/pDm4FsGVWTjy6uTvV1njRdND5FJfgWZRC7m8fjx3TLXx/i6tvLJ/KW9U0Hwf7Ei2Ghfmy6CWLjA/UgAXpYNXHl81IpL3PAagZeli09U+c0VXtN5IDgyfACjvlEyEMlhpo5HCyBCal9Fwd+vb3diEGXDzvOHzqUoBzFtNZnM0SLnnpE1Whhk+c0Daq+VJby16nXxsymZ1BCx7ac4BNaM2rUrflmTMR2xeUgQaC5RsK1jE9GHsyLx8ZsjLvVuCALSIguTzfzfkTJNDNpT0uTjne40OdPeVH6z+FjaiRKicFxGOR46JEm/vZ7gghPm9o8rzpzQ9Dvck2ld96q4/hYdNruGg8C7iI8j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:09, Kevin Brodsky wrote:
> A per-CPU batch struct is activated when entering lazy MMU mode; its
> lifetime is the same as the lazy MMU section (it is deactivated when
> leaving the mode). Preemption is disabled in that interval to ensure
> that the per-CPU reference remains valid.
> 
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode. We can therefore use the generic helper in_lazy_mmu_mode()
> to tell whether a batch struct is active instead of tracking it
> explicitly.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   arch/sparc/include/asm/tlbflush_64.h | 1 -
>   arch/sparc/mm/tlb.c                  | 9 +--------
>   2 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
> index 4e1036728e2f..6133306ba59a 100644
> --- a/arch/sparc/include/asm/tlbflush_64.h
> +++ b/arch/sparc/include/asm/tlbflush_64.h
> @@ -12,7 +12,6 @@ struct tlb_batch {
>   	unsigned int hugepage_shift;
>   	struct mm_struct *mm;
>   	unsigned long tlb_nr;
> -	unsigned long active;
>   	unsigned long vaddrs[TLB_BATCH_NR];
>   };
>   
> diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
> index 7b5dfcdb1243..879e22c86e5c 100644
> --- a/arch/sparc/mm/tlb.c
> +++ b/arch/sparc/mm/tlb.c
> @@ -52,11 +52,7 @@ void flush_tlb_pending(void)
>   
>   void arch_enter_lazy_mmu_mode(void)
>   {
> -	struct tlb_batch *tb;
> -
>   	preempt_disable();
> -	tb = this_cpu_ptr(&tlb_batch);
> -	tb->active = 1;
>   }
>   
>   void arch_flush_lazy_mmu_mode(void)
> @@ -69,10 +65,7 @@ void arch_flush_lazy_mmu_mode(void)
>   
>   void arch_leave_lazy_mmu_mode(void)
>   {
> -	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
> -
>   	arch_flush_lazy_mmu_mode();
> -	tb->active = 0;
>   	preempt_enable();
>   }
>   
> @@ -93,7 +86,7 @@ static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
>   		nr = 0;
>   	}
>   
> -	if (!tb->active) {
> +	if (!in_lazy_mmu_mode()) {
>   		flush_tsb_user_page(mm, vaddr, hugepage_shift);
>   		global_flush_tlb_page(mm, vaddr);
>   		goto out;

(messing up my transition to the email address as Thunderbird defaults 
to my old one still on mails received through RH servers)

Did we get this tested with some help from sparc64 folks?

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David


