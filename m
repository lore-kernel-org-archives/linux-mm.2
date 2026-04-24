Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A474FED3E2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB2B6B00AB; Fri, 24 Apr 2026 11:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054D36B00AF; Fri, 24 Apr 2026 11:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E866D6B00B0; Fri, 24 Apr 2026 11:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D42F36B00AB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:13:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93DCB1B705E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:13:04 +0000 (UTC)
X-FDA: 84693792288.25.CC6C3D4
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 603AB140010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:13:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ZhhchdJF;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777043583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=baIpBz6aXOlLb2F6BEUohnTvCndCw/3+ATrc+ipc7oU=;
	b=OQTw5fw963h4hsadbhni38gd6G4cFenL77Gxd4QOZ1ogbLbxMUJMyKSpzzfrNZpXUo5l9e
	orbbT+ZBOIhQBSPn9lEj/ygNbehc/sP6yLFJjJASz8nmnDamDln8+idM/XmtnkocsgFgfZ
	36D28WJQYnaGEapkAcijHQIlI/ch1Zs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777043583; a=rsa-sha256;
	cv=none;
	b=g7fuOX0k6sSMAopfPa2ctMDt1d7caqR+abXEAjtyjhwASkdfzJiTeMhlVy0mIbKUEqtMdy
	BPkR44qIgQYaVIZh3H0g+tQT5C4hl86qFCe+SgyruU15x6GK5fsQ+P8cJSKSqpNlzG0BqZ
	jqB0Z2T3NQs/Cotxlm3YcBsW3O1P/9Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ZhhchdJF;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=baIpBz6aXOlLb2F6BEUohnTvCndCw/3+ATrc+ipc7oU=; b=ZhhchdJFtym8U+LIXCoVLeR2gB
	/csyHZe3SikhGJKPPECkv/IGwNAFB49pA/VgwWs+vJ3q/bThmE33AO9boC7HohP1U5av3e9kSTeOH
	AWLbUnRwoeRUGOHsRMzxe8X/1v7l2IMCLy6h91V0RFCrlcho/8nHHyk8AoPldjdmP9HtOjRKUCxt2
	aQCkricJncWE0f/vLN2+1gicbZAskJsVAVwRIsTu8vBEX+BoQz5/jRVr9KL2m/YH/z2jx9QW5kp5o
	qiRUYnvW3KAOCdw5y/068LZpESHso9/GpHfOBSSafH7EumBrbLlgaxIIMIId9Z4WpUIJywsNo1744
	3zsbr63A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGID3-0000000F1yt-04pa;
	Fri, 24 Apr 2026 15:12:50 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B1ED130301B; Fri, 24 Apr 2026 17:12:47 +0200 (CEST)
Date: Fri, 24 Apr 2026 17:12:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
	jannh@google.com, jgross@suse.com, seanjc@google.com,
	pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH 7.2 v10 2/2] x86/tlb: skip redundant sync IPIs for native
 TLB flush
Message-ID: <20260424151247.GG3126523@noisy.programming.kicks-ass.net>
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424062528.71951-3-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424062528.71951-3-lance.yang@linux.dev>
X-Rspamd-Queue-Id: 603AB140010
X-Rspamd-Server: rspam07
X-Stat-Signature: dfyw6t9tqrrj5q5ncxdqajb6zrqf1cuj
X-Rspam-User: 
X-HE-Tag: 1777043582-228292
X-HE-Meta: U2FsdGVkX19lBxuyzphcPESYvyHWOOuMltY79QuQoWwpjI5VKFRBvzrkWKUtumUcVbK6KbF2UtfUrdXh0Ts+8oZ9/AN9Z4Et3cMI1Q8jlQ7RQzfQ4zE6DQIUEchwzffNv+dRFockynZN68HXJa5DaWhrnsQ6GIYfIiO+dZILGBDsZhfhPrq7IGJG66IVR0/JFC5QSbGSHN9kPB9DLoJmenSrgRsfAmcmiAMDlpBRxtpDowZLOQmm10umKNvowpp8MsZyjxyUFG0NcxGG4V9DJqc92ixOYmph3lsG/cduAZMTW4l/VrKvX6KVyCUFRWO5hrBixEvU9s2w23qxg27OjcyNG8p4guR99igD/x/+aAStPaDkz793ZVV9do451LOYbluUqH6L1VShgVri2rAD4U5qn3Jpusz0MvVKN3aaXACCu3o91LlnGajKPmwqzOsuiXli8IrawPUDWWpzRsS3F5KvgwAuLAU1cQRUA/FxvXwy0EMQtqLluUsWMI0pEkbJuScoZnOh1UXFV4/W4YflApHycvnOxTHd2uB2eXfXygjRWLxD32uhA+DIfnkmD0IHep+KYIiRid8sJdJPVo4Wq1wcvQXulPb6RNOwjO7jWP9lrRsfQWxiHF3HfTGR+9bNHGOME4T+rWKtoXHG+QZWYdAs9wjIbUwo5XGNEU6cjZITJLes3HMymaeLlM+QyyuxXOZw0IvL+1Dnz7EqBfb8LfqaBjezLzu881l0yjdEYL9gciFnH0tTEz0f+CefloskGFY3b2jOTqnz186JnxojcrLHFznF0Dahy7WvTEPVrdE5gkhtGR5o5eVSEP8FUBsw0xD4H3v1lp2f1R4GgS7DHbi+n5lXFPWxz3/J5PAEpfQcYBll3YaNh4eCpcuGemny1MqrNNSRGkDvKx9uqoSc/TVHrOONwa0/7/Fy5hqs3q8Vtce52kb5HwGzCsS0bqsfqYToxfKqETmicumctvo
 T3zmnO4g
 O4H1ZfYvJNROp8NTLRSzAQIR1TLc1kP04//T1WKewPwav6+KMz1eorhlTzvDiN1/UcNFY6lw0NmkAc0lheNh1lG1htOvtAEKLnAXvdx+vIMA6VMguaYKzU02Qxb8NEfJENQcsFuuyyogw8gltWsZK4jeyoii++3Ba6dByC/tfyBzOjFrQ0zpVsASWVTrV0QhHMqpd4FhrlwYOWYFIC5UaqPKj7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 02:25:28PM +0800, Lance Yang wrote:
> diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
> index cfcb60468b01..2cf1eeaffd6f 100644
> --- a/arch/x86/hyperv/mmu.c
> +++ b/arch/x86/hyperv/mmu.c
> @@ -63,7 +63,7 @@ static void hyperv_flush_tlb_multi(const struct cpumask *cpus,
>  	struct hv_tlb_flush *flush;
>  	u64 status;
>  	unsigned long flags;
> -	bool do_lazy = !info->freed_tables;
> +	bool do_lazy = !info->wake_lazy_cpus;
>  
>  	trace_hyperv_mmu_flush_tlb_multi(cpus, info);
>  
> @@ -198,7 +198,7 @@ static u64 hyperv_flush_tlb_others_ex(const struct cpumask *cpus,
>  
>  	flush->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
>  	nr_bank = cpumask_to_vpset_skip(&flush->hv_vp_set, cpus,
> -			info->freed_tables ? NULL : cpu_is_lazy);
> +			info->wake_lazy_cpus ? NULL : cpu_is_lazy);
>  	if (nr_bank < 0)
>  		return HV_STATUS_INVALID_PARAMETER;
>  
> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
> index 866ea78ba156..fb256fd95f95 100644
> --- a/arch/x86/include/asm/tlb.h
> +++ b/arch/x86/include/asm/tlb.h

>  static inline void tlb_flush(struct mmu_gather *tlb)
>  {
>  	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
>  	unsigned int stride_shift = tlb_get_unmap_shift(tlb);
>  
> +	/*
> +	 * Both freed_tables and unshared_tables must wake lazy-TLB CPUs, so
> +	 * they receive IPIs before reusing or freeing page tables, allowing
> +	 * us to safely implement tlb_table_flush_implies_ipi_broadcast().
> +	 */
> +	bool wake_lazy_cpus = tlb->freed_tables || tlb->unshared_tables;
> +
>  	if (!tlb->fullmm && !tlb->need_flush_all) {
>  		start = tlb->start;
>  		end = tlb->end;
>  	}
>  
> -	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
> +	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, wake_lazy_cpus);
>  }
>  
>  static inline void invlpg(unsigned long addr)
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index 5a3cdc439e38..39b9454781c3 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -225,7 +227,7 @@ struct flush_tlb_info {
>  	u64			new_tlb_gen;
>  	unsigned int		initiating_cpu;
>  	u8			stride_shift;
> -	u8			freed_tables;
> +	u8			wake_lazy_cpus;
>  	u8			trim_cpumask;
>  };
>  
> @@ -315,7 +317,7 @@ static inline bool mm_in_asid_transition(struct mm_struct *mm) { return false; }
>  extern void flush_tlb_all(void);
>  extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
>  				unsigned long end, unsigned int stride_shift,
> -				bool freed_tables);
> +				bool wake_lazy_cpus);
>  extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
>  
>  static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)

> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 621e09d049cb..3ce254a3982c 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -1360,16 +1362,16 @@ STATIC_NOPV void native_flush_tlb_multi(const struct cpumask *cpumask,
>  				(info->end - info->start) >> PAGE_SHIFT);
>  
>  	/*
> -	 * If no page tables were freed, we can skip sending IPIs to
> -	 * CPUs in lazy TLB mode. They will flush the CPU themselves
> -	 * at the next context switch.
> +	 * If lazy-TLB CPUs do not need to be woken, we can skip sending
> +	 * IPIs to them. They will flush themselves at the next context
> +	 * switch.
>  	 *
> -	 * However, if page tables are getting freed, we need to send the
> -	 * IPI everywhere, to prevent CPUs in lazy TLB mode from tripping
> -	 * up on the new contents of what used to be page tables, while
> -	 * doing a speculative memory access.
> +	 * However, if page tables are getting freed or unshared, we need
> +	 * to send the IPI everywhere, to prevent CPUs in lazy TLB mode
> +	 * from tripping up on the new contents of what used to be page
> +	 * tables, while doing a speculative memory access.
>  	 */
> -	if (info->freed_tables || mm_in_asid_transition(info->mm))
> +	if (info->wake_lazy_cpus || mm_in_asid_transition(info->mm))
>  		on_each_cpu_mask(cpumask, flush_tlb_func, (void *)info, true);
>  	else
>  		on_each_cpu_cond_mask(should_flush_tlb, flush_tlb_func,
> @@ -1402,7 +1404,7 @@ static DEFINE_PER_CPU(unsigned int, flush_tlb_info_idx);
>  
>  static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
>  			unsigned long start, unsigned long end,
> -			unsigned int stride_shift, bool freed_tables,
> +			unsigned int stride_shift, bool wake_lazy_cpus,
>  			u64 new_tlb_gen)
>  {
>  	struct flush_tlb_info *info = this_cpu_ptr(&flush_tlb_info);
> @@ -1429,7 +1431,7 @@ static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
>  	info->end		= end;
>  	info->mm		= mm;
>  	info->stride_shift	= stride_shift;
> -	info->freed_tables	= freed_tables;
> +	info->wake_lazy_cpus	= wake_lazy_cpus;
>  	info->new_tlb_gen	= new_tlb_gen;
>  	info->initiating_cpu	= smp_processor_id();
>  	info->trim_cpumask	= 0;
> @@ -1448,7 +1450,7 @@ static void put_flush_tlb_info(void)
>  
>  void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
>  				unsigned long end, unsigned int stride_shift,
> -				bool freed_tables)
> +				bool wake_lazy_cpus)
>  {
>  	struct flush_tlb_info *info;
>  	int cpu = get_cpu();
> @@ -1457,7 +1459,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
>  	/* This is also a barrier that synchronizes with switch_mm(). */
>  	new_tlb_gen = inc_mm_tlb_gen(mm);
>  
> -	info = get_flush_tlb_info(mm, start, end, stride_shift, freed_tables,
> +	info = get_flush_tlb_info(mm, start, end, stride_shift, wake_lazy_cpus,
>  				  new_tlb_gen);
>  
>  	/*

This whole s/freed_tables/wake_lazy_cpus/ rename should probably be its
own patch, as should that include unshare_tables thing be.

That seems like unrelated changes.

