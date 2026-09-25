Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5541C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD6A6B0088; Fri, 25 Sep 2026 03:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D296B008A; Fri, 25 Sep 2026 03:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C776B008C; Fri, 25 Sep 2026 03:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91BF16B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:24:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 101FCA05B1
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:24:57 +0000 (UTC)
X-FDA: 85251447834.14.0E4C878
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5BD5E180006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:24:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T51PMqdt;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790321095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXRP/1wipC9J8UX4qDqGkgwn+tmzgWEzq4b5o6Ax+9I=;
	b=AUNZqLWBsZvqyCYuu/anQxmGZKMUcn90Mxc7ur3M9n7gMbzxZfebdbMMCwy5kgJ0c7+WBe
	AlFX7GE4IlMyC3S0tNCXUDfixJijMD6x2KqiRLmCAnVkmNjsPUGuGSNnWWRYPClqhS8oCZ
	rJlkNB7iQdTVqQMghKbVD6w6zcyVPzg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790321095;
	b=GTtx9ysB7EOCcbyvFwVC2uSXn4ZutIoCxWPZpT2BLl2lnyr/Aho47/AfFksBKY55NfY2jc
	YTfcvaMdYPaz+6OevbXDnd4x3rxu45AzUrhEOzzZ1BK4EXh591YKFu2x9bGYO1itaQ3QQv
	aO5oNFfeIndJa9Uia06CBr0gD+RDVHI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T51PMqdt;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AC0440DA3;
	Fri, 25 Sep 2026 07:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27C41F000FF;
	Fri, 25 Sep 2026 07:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790321094;
	bh=LXRP/1wipC9J8UX4qDqGkgwn+tmzgWEzq4b5o6Ax+9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T51PMqdtftu+im81DJxP4CPkokLbkFS53m9mcYvmL3K+t5ROMTQfep6P85iiVzFTP
	 Tv5Gk1D9fgKhMg0irB7CeOYqC6CbbMKLhDpoWtPTfbdhKClF/ZEMZp5xbUTZwucyov
	 LHIvzNBAwCCv8DA5u8bsMxabWRLCRLmDyWZ5VZej+6kJJiNSWcnVTZ6DuAjvwSV+cy
	 85gyATs9AMckS1R/ZsJqY7aLzbNXWAFc7zf8E6/lZGQ2/AJWAjpVfSV+TXA27bcJCw
	 ImxTZG6nmhATEQkHCStlEFASUI92lCS/ERcrJu4JiZZXDCzpccuFNZCXtN+DRCSfIA
	 KQbcugiYY/WGg==
Date: Fri, 25 Sep 2026 08:24:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org, 
	linux-mm@kvack.org, regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: don't schedule deferred kernel page table freeing
 while booting
Message-ID: <arYhsEGuCVatW7ZY@gremlin>
References: <20260925050647.86913-1-mikhail.v.gavrilov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925050647.86913-1-mikhail.v.gavrilov@gmail.com>
X-Rspam-User: 
X-Stat-Signature: f4xgw3anqfb47or1rprincyyu37dxqw3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5BD5E180006
X-HE-Tag: 1790321095-979384
X-HE-Meta: U2FsdGVkX1+wxY6ngB3/QXoSRJlZDtFMMUjz9MSmaQeOq4SApHIqrEw9gbd5xD7qqTIPfJovnOrsYf5XZBU/fIANh7OKfaDIIQzivdhe4oJLA6AJrMMyBAq/f48Vaa+DXUNcPeZiay9EVzMUN3JGHJp6MJnc7kXl9zgOfpNufFsKkROt57AkDaIbOOuNDB39hmx7111cvBxgVexYc4OYWZAlu76Q7o9cpurLcEM/Irp3LBfrLdrQwJRcQnCbN2hJQrWPmD1zJspByXuLkLwq5DOKIT8pMycbEzP419BNG9/lPrsTebWDyjjY20lMQ+etytj8CyEuzgFkCqHqXClzBzZiAXjOPQXYxUAWiwgi/Sj/ZKW4Tzn+GLRUnf+/g7YiKoAbCjSmMKAiUT5dtowsSeU75oad/ldf/W46HI3wlXrfGq6KrPdi1nsSpuKvOVTUpk0/TGxRV1vfNp47/62XrlYi39COATRUd0fkIDTku0S0b/C3drDGD65R3YWY86PjkdBT5d0zJ8Bv8pspLxGCRI3qUh308xE/8lWH4TZjHr9idxgFonW816ELPAYstvhzH8adqioqoEchA/yKb2s2fepmXBZnvD7MeXvhrZSWbkz1pFg0kNTVBA4v/yna8tTU8F0WkZuOwJcSZwnNRZYflPqtmdEofKeWHxxakesobrk715OuSZcvMpQdTkHMyNktw0eoXZQnOiTI94165tqwLx12ZcUKhokQdgDWkTUpHy4n84IbS7jC7LPBuJDgEt9s+TRswFDt2FETUvBYDtDn9l49V4Pk1rXhBPzendPVRaI7S1ocxkejUKF/IIu5xFKWnZI8nYZIrZ1Y4XOOQMU10IjvswATzCVUaahZHOgMLLlYuvsQl9pQSIpGLUHdaw/TDVn4s9nX3zdLY7d/5k16hRjEYI/5qbuzNbk/+piHWjUwt9ZVlPb9HWXmL+DKIhwQlbESVZkzn5AsBzUC8Lr
 ujOPbQoa
 timdrF+u6Pti7/Adtk2MI/BlL8GE3hXQ6tesYVSsXjCY+Cqhk0MYwm+OCCb/h2YtoD98WM1AG0hKAL8Xm7Ox+RawbM/YrvJENPa8MGuJ7ei1XXnZ45BCyJzqgkh/NPuK/3O7q/HBXnlIb0gpxiJNFpqK2+jfU+vMvWBSGWLzNpco9tIx0nRzsADreWjjiscVkcScOiFq+mAN77jWMLp1jFyIuthDw53xe3YYZ3dxcmIYJUy2Oo0H14MBPJDBjtT3KhwUoEifMyb24RQEAL88EAE5s9vkalimOUTDDZi3AAqGMan+OkoNUG+Wk7IT+E7uXu0ZjfHacIe1uiA6/AYHJUHrda0hdyUiMCZxDvpBqlHQOXME47uQhuHVxBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 10:06:47AM +0500, Mikhail Gavrilov wrote:
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

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

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
> --
> 2.55.0
>

--
Cheers, Lorenzo

