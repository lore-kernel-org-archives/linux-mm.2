Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED33EC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9DC6B008A; Fri, 25 Sep 2026 03:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1656B008C; Fri, 25 Sep 2026 03:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD68B6B0092; Fri, 25 Sep 2026 03:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9491A6B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:16:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20C8E140588
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:16:07 +0000 (UTC)
X-FDA: 85251425574.04.0E3267D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5FC8AC000B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:16:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FDf6YXQG;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790320565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d932yjix1Tn4l08d2x/Renb33cLb0uv6fwAZBrYQ3Uo=;
	b=kPWJWKuMolISRQqWVQPBi5i1tpvxJAr2oRQyhl8VcjErG3tdyGkYAb2/dr35f2R8CaUbsj
	nXKsUARkM624ZnBB8RyVJDfBS6rKHT9mHoG9d93uY6Uf1fiu8jBTw9g5irQPjPWgnH0TDh
	+RtryRmdZQGmsh7pu+FFm2yGbBGhrKk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FDf6YXQG;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790320565;
	b=MQ/7SlTh90mRCQhiB4j7hA8ZeKwbbXjxPPXXHeIf3oDPQPg1hEP5PtmC6kdSf16ZNB2HgB
	Og5DjsC3bvCZC2Boh4Eup/qe3cOLMDIBIJnQ3av/n1lF8GbdC0DY32YBa26Nr6lRGbwRwr
	yGb8wGtrJn43CxpoCFhv69xIc/8MBnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1810B6022F;
	Fri, 25 Sep 2026 07:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357501F000FF;
	Fri, 25 Sep 2026 07:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320563;
	bh=d932yjix1Tn4l08d2x/Renb33cLb0uv6fwAZBrYQ3Uo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FDf6YXQGPQ2Y7yog7yhM2jVPqJGoH0968+QQYkyCVOKvH38V73A6X/u2SN9+oOrDm
	 agf0RYHY1877oCucHhL43AS9RrXunzHpd2mVbwAaszX2prpEANtyRvop1WhuhwqWb2
	 TzF7vvktfAqHLob+ntiuuh1lp9QaSojZ3imP9CgT7l+oSUhoRfi0yNAbys0FGMbHF1
	 PxaCWqNNLXhm42sBvg55hj5RyNRv4/8jyn1ajCk/YQkwZMte3mbj+A7C8qVTQ7zLW3
	 iTYYnzx3Ru4Wk7ISuu1RNxqqNYvST/vbPuI/oYmBCQhxeMSoLkpuWvCvlXU7xYTAiY
	 t4h+M4mqliQuA==
Message-ID: <8244d5fd-e448-41c8-9f58-e87499ebac21@kernel.org>
Date: Fri, 25 Sep 2026 09:15:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: don't schedule deferred kernel page table freeing
 while booting
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>,
 x86@kernel.org, linux-mm@kvack.org, regressions@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260925050647.86913-1-mikhail.v.gavrilov@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260925050647.86913-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5FC8AC000B
X-Stat-Signature: nx6d9ousncgfc8p76fqdo4wjm98hq1du
X-HE-Tag: 1790320565-46158
X-HE-Meta: U2FsdGVkX19JZgR1nHQzA50GRCtIDtBypqRbHkvTvFunosyqPqayaXuAEecbEHeACATCVldWW3AuX1AAvwc95TmQCE76OLPoISFITJuqOLzwqhSkitJ0jw91eAgU/2W4VH51oLnEhuKUlgPDpChLMi6OJ5EjUsXPn37fSot0ZKSetnX+FenV1+Ah3RncwRUG/6IBvWl02m+I1g4xqWF12uLDA+wN5pOvjjY6G0iozF/CEeBlSAqq5VvCRhs8Jf2Dvcf/rvXeaHSiaf6sQEwKNwS8NATUjd1qQgAvSecOYdJ+lGq60UCXLiGJJreeeaRGMUlM4D5VGhH6YjplppuBZLnbhSBAX1o9h0fkjPRj/X4AZsGYYLP4XkDy12N4/FskFnDVOI1hOBpINEKXs7QxGbe5qcmBjt+ncq/3xu4Is1QpOtpsIjdI2XF7czRqkiiWjkymFv/MrbaXoBAiRXXUEbsJEeS1+bz7WzBQRKZe6poHgVZsrOE+GlFishX+qdpAxGu2CaOZvRzeEI7QmZRRbOTRJ/NGXFwIOx2+iDfUKkfzWokHEV4IoUm0271E8d38t6itFHz9bVVvsmbujKWxl+Pw2emYxiC8yH/toV4aBIMlxvADPWBx8kuuvQv/y+CcoahH/+buUNeO8+nLowF2MBfA1PTCSEr3kheiS6tiFt4qCytJtGAlkn2tLf0wd+MiHl+4o9AYfaihSRG2LmmuLcoHIjjJQduJGWcSyNMQ4oofxMBbf5FmR0wY+FvHvULy1WSZ7N3bgmDDPQfqP9Zo4WFGoftH2XiPexliXOmjde3oTgJ/GVLkTaiq233+RNanGpc/6L7y9szcvEuxas2cMWiwR24IV0qeznKZ1CYemjQae1in5/jlWCsc6jyj66i8YGt7euyiD4Euz+YPTlK/tx0NHQdss7A9NPDuIoXUr3H4+8AkIGGoEZetA04p0yOS7jXWG/quDi1gfQPCzLj
 yybMw2lt
 wc6Jiz05Kx30I2FCck8PhcZVHIjjY6eNsVMHeSlmtgkAhOId+w8J/3yN1Fymx2UcfB0VcuEzcIEFx9RTiXkMsBQ1hcGpbNQnfxwDFPIDeJK67gMg6nAF6clDrUfbNzhAPwg3kpmeKZtlQkVUL9uxA3BpOIout8xOINCJYq4WKcr+bPAdRG6vqw45dqwExHmxslLvxD6BOr0lODLBd2RgWQpncqKCE0So+KKy+Bt0aVKZi7C8U7PmqKup/kp4HCHj9OE0r71zcukMEyx+R/Fl+tDq+nkUiTjPz7fSglebfXAyo3Ryph71ezSvDADjp2VJE8jnhm1bnVa3+8fpzGCkkYetJM7LY/jqqkXAoNBDufU+MoxdOCw2HcLRgshdjsbOnvAur
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 07:06, Mikhail Gavrilov wrote:
> Booting with a boot-time function tracer and a filter, for example
> 
>   ftrace=function ftrace_filter=pud_free_pmd_page
> 
> panics on 7.3-rc4 as soon as the tracer starts:
> 
>   [   23.531178] Starting tracer 'function'
>   [   23.675800] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN NOPTI
>   [   23.819917] KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
>   [   23.964025] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.3.0-rc4-fe2ec83746e5-with-fixes-v2+ #195 PREEMPT(undef)
>   [   24.252248] RIP: 0010:__queue_work+0xab/0xf00
>   [   25.981629] Call Trace:
>   [   26.125727]  <TASK>
>   [   26.413912]  ? pagetable_free_kernel+0x20/0x120
>   [   26.990283]  queue_work_on+0x97/0xf0
>   [   27.134382]  __cpa_collapse_large_pages+0x501/0x6f0
>   [   27.566662]  cpa_flush+0x394/0x620
>   [   27.998953]  change_page_attr_set_clr+0x321/0x4a0
>   [   29.151729]  set_memory_rox+0xa2/0xf0
>   [   29.584018]  create_trampoline+0x431/0x6f0
>   ...
>   [   44.343347] Kernel panic - not syncing: Attempted to kill the idle task!
> 
> The boot-time tracer is started from early_trace_init(), which runs
> before workqueue_init_early().  Making its trampoline read-only splits a
> large page, and CPA collapses it again right away.  The split table has
> been a kernel page table since commit 9e4a3ec3411b
> ("x86/mm/pat: Allocate split page tables as kernel page tables"), so the
> collapse frees it through pagetable_free_kernel(), which queues work on
> system_percpu_wq - still NULL at that point.  That commit is correct in
> itself; it only lets CPA reach pagetable_free_kernel() before the
> workqueue that function relies on exists.
> 
> Keep putting the table on the list, but don't schedule the work while
> the system is still booting.  A core_initcall schedules it once to free
> whatever was queued by then.
> 
> Fixes: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> Link: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
> ---
> v3:
>  - Schedule the work once from a core_initcall to free whatever was
>    queued during boot (Lorenzo Stoakes, Dave Hansen, David Hildenbrand).
>    late_initcall would work just as well; workqueues exist from
>    workqueue_init() on.
>  - Keep the fix in pagetable_free_kernel() rather than skipping the
>    collapse during boot (Mike Rapoport): that would only avoid this
>    caller, and any other early free would still need a workqueue.
> v2: https://lore.kernel.org/20260924092307.22813-1-mikhail.v.gavrilov@gmail.com
> v1: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
> 
> Tested on a Ryzen 9 7950X with a Radeon RX 7900 XTX (lockdep, KASAN),
> 7.3-rc4 plus unrelated local changes, by booting with
> 
>   ftrace=function ftrace_filter=pud_free_pmd_page,pagetable_free_kernel,kernel_pgtable_work_func,kernel_pgtable_drain_early
> 
> The boot that panicked without the fix completes, and the trace shows
> kernel_pgtable_drain_early() and then kernel_pgtable_work_func() before
> any other kernel page table is freed.
> 
>  mm/pgtable-generic.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index b91b1a98029c..cd227fc05d2d 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -438,12 +438,30 @@ static void kernel_pgtable_work_func(struct work_struct *work)
>  		__pagetable_free(pt);
>  }
>  
> +static void schedule_kernel_pgtable_free(void)
> +{
> +	schedule_work(&kernel_pgtable_work.work);
> +}
> +
>  void pagetable_free_kernel(struct ptdesc *pt)
>  {
>  	spin_lock(&kernel_pgtable_work.lock);
>  	list_add(&pt->pt_list, &kernel_pgtable_work.list);
>  	spin_unlock(&kernel_pgtable_work.lock);
>  
> -	schedule_work(&kernel_pgtable_work.work);
> +	/*
> +	 * The workqueue may not exist yet while the system is booting.
> +	 * kernel_pgtable_drain_early() schedules the work once it does.
> +	 */
> +	if (system_state != SYSTEM_BOOTING)
> +		schedule_kernel_pgtable_free();
> +}
> +
> +static int __init kernel_pgtable_drain_early(void)
> +{
> +	/* Free the kernel page tables queued while booting. */
> +	schedule_kernel_pgtable_free();
> +	return 0;
>  }
> +core_initcall(kernel_pgtable_drain_early);
>  #endif

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

