Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EEF1C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66CE86B0124; Thu, 16 Jul 2026 11:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643D66B0126; Thu, 16 Jul 2026 11:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B036B0125; Thu, 16 Jul 2026 11:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28A276B0122
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:04:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E3EAC017E
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:47:41 +0000 (UTC)
X-FDA: 84994767522.30.23051B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E8C894000B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:47:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VaAqh2FV;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209659;
	b=xhssHfbnGuwTPkaLVf9Gp1tj9fh0YShLTE9cF2SJcOZxyJEuYWxPgzPA+RUkuBH5mf3XNS
	Eiw5mxmHpk2BNyw4gzj7z95wgVaSZhTupcIuM0Yci1vGoKENeO/2bWgRXBhRyrJmlguzLD
	EmK7vmBOYnszICgVFIzopprBejSdVmo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VaAqh2FV;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqxxc5A53OKhz48FL6b7XXdZbwD1IyUVhQ5mJc6kbbQ=;
	b=j54/A/kVavYJRrfjZB+k7I9djvWysnjbgvccPi1NKK/urjGYiz4HS4iicAf6z68sWGQz/f
	HKPH2EMNvLu1/TXZa/Y+jFgW8u4rGOnBhu9al6IAiR3J8++4b0DagU6QkyLrtF4zrN0XLS
	EomAAGHZN6SGxdZ7xoU8PS2icE+gD2Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D25B61385;
	Thu, 16 Jul 2026 13:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4621F00A3F;
	Thu, 16 Jul 2026 13:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784209659;
	bh=vqxxc5A53OKhz48FL6b7XXdZbwD1IyUVhQ5mJc6kbbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VaAqh2FVMX4C//uMyZqUF9Rj9Pn3qi94kohEi3Arw4kg7GN6F2fJPrpj1eJdfSC3G
	 R17ih9bnYM/9KKogFZD6ZIb4OAuJsTDeBVgYWCktZcHll6rPJUod5v4ppNFyJ6ZUE1
	 UVQ/VJXEaIjcv+0ga6ZlIMZ/hbsz7ysNZGD07me2ZNXQ0m0RC8UgnUHxj5vgRoTn/4
	 H949GtI8PqIZq636TkqbSGvNzW3TPeEKu5ZPt1U0qvAyyknBN0XzVyIL/hiWffJ4UW
	 r/9RtgGsy8KRHtbODcBXel3R2k/68W2AMj/VnaKyKma8WzVtHzEzbuzcqx9yf3RnWb
	 enbdap06JhsFA==
Date: Thu, 16 Jul 2026 14:47:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: linux@armlinux.org.uk, akpm@linux-foundation.org, xiqi2@huawei.com, 
	david@kernel.org, linusw@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	liaohua4@huawei.com, lilinjie8@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH v4] ARM: mm: acquire mmap write lock around show_pte()
 for user faults
Message-ID: <aljg0sddPohJC5ij@lucifer>
References: <20260716014022.2823-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716014022.2823-1-xieyuanbin1@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8C894000B
X-Stat-Signature: 5btdh8k55k7cw1brgr1tisn7c7xonzwp
X-HE-Tag: 1784209659-754446
X-HE-Meta: U2FsdGVkX18PrPELI3CvA9tvAZBIKRNZgj6Oy0bZPXjJsxDr2gsMtHfTJpRdLIzRdL1nPyjc54jkirzeDpbltE18D3aUQKV2ulK+aQJ264OBYaDl2krKVBWx5+xxd7Fbg3OCac2925fpil4mdj5xG++WDcIwpJJG4I1hrs1wjajk0w3tLaYBdwfefX965OqA+YMOW7FYyF3xyBBdiXCZDfKXEmH/+UFfAjJTW5401pFUOFaHbe0MOQXGnBSeSESOZDOqDWtachAPUysE/0hTAZVOil3s7YD3Lvmc6V0veZrlZ/No4GPMNINNWg57TXbLVRhiKDrZ6qV9/6+4N8u6yk2P4iATWccXz7owIdmyYLV10x52IEuZMIGvFwk2bJ7jDFpYWngxIK6rywwK2F4uX8tiPm0IOozjMifo/8oxVpZfcY3BfoD0iRbTcXl0XOH71zFPrnIWs6OR+y1cMPoR1shSMrSbOZHl89gIBXzvf+h12THPoXVcCNoNlWPotMfexz3Dqpx6yRwI+FFjsHmTbzURz0lrYjUQz6U6gEhSxgXfZ+lFpQgIG2i86bINKBVT3tpci8RcgKXVQvrZgbyfUgLHNPl+ajXLTyWX6JWpyhyAUG39L0EBhNNhiuAyNoVp3Z4hmyzHDoQduVgtPq1TC3QTAy8S86ZTeszMrn72R2vjqM3PONXiDuNuA6rfnu2YcpI9EgINyCwTgxs10vgrVajbv9d/e3+jS2TH7EMGWUa+u2eUejBkFoMBuJAXamGoePJdClxZv1vFRfg909uUTYIvUX5bPqudNiuhvIkqtoDBSRBsx14Qqk3yu7GGh79mclc9CmoQs9Y4hfBxEMiPeIi3kcu0AkvxV7HgriyhTeXxEMyb/NEYG0ELoqJiIpx5B+fNmBs1N3B8G9KcV+rb1cgJVkM1Z5iZaxG2yE7DzUo4VIJc8ySwmgNPiwzrYb/NkezDxfq8ryxhiWOB+2j
 p/Pc7Gdn
 SH7UM4rfVTXG7A/yhp5sGGtA+9f047RrzFDU/99WQ7ePZdKFylwF4S5YCQEVlPEpF24pioEgbaHp9hTH/EBiQaxUFS/uqN6Xa/kidZDCB0thzo4YaWNLHOh+fyPzgNHT44/yrMlOJ/TiPMxzscDpibCkE8F/VgPDv1NZ5ihTlCSOID85VzIVUYrDBSZMKk12AzrIg7yvc5AlUm9k2IOYNhc/kXKiYeRTrKbpknyvdZIJ8oiBtfIUOKS1aOVuVLScWWIMyzKmuaAqyJ5qyaMGA6jzslqLSTUb0betfuTWwlP3UbW7e9BNy0keKFr0mP76kAt9R3A+gxfuNTb3tR8pR0GHH5gXY4JX681/Q5FfaAp9f3EOGqm0dRTSSx4bjHXLYd61b0YBCN2tHGemK7Sqz3hAuTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 09:40:22AM +0800, Xie Yuanbin wrote:
> When CONFIG_DEBUG_USER=y, and cmdline "user_debug=31" is set,
> a user fault may trigger show_pte() without any lock.
> If another thread in the same process concurrently calls munmap(),
> the page table pages may be freed while show_pte() is still traversing
> them, causing a use-after-free in show_pte().
>
> If CONFIG_ARM_LPAE=y, this may cause a kernel panic if the pages table
> of PMD are freed when show_pte() is running.
>
> Acquire mmap_write_lock() around show_pte() for user faults to fix the
> contention.
>
> For user faults, additionally restrict that show_pte() is called only
> when the addr is a user-space address (addr < TASK_SIZE). This is because
> the lock of tsk->mm only protects the virtual memory of user address space,
> furthermore, dumping the page tables of a kernel-space address for user
> faults is unnecessary and may have security implications.
>
> Keep everything unchanged for kernel faults, because the kernel is
> already in the "oops" state, acquiring a lock may risk a deadlock.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: 6d021b724481 ("ARM: dump pgd, pmd and pte states on unhandled data abort faults")
> Depends-on: <20260629123349.134224-1-xieyuanbin1@huawei.com>
> Depends-on: 59e4f3b45b96 ("ARM: ensure interrupts are enabled in __do_user_fault()")
>
> Cc: Russell King <linux@armlinux.org.uk>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Co-developed-by: Qi Xi <xiqi2@huawei.com>
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> For __do_user_fault(), it must be a user fault, so the
> judgement of user_mode(regs) can be omitted.
>
> For do_DataAbort(), it may be a user fault or a kernel fault. If it is
> a kernel fault, it must be a kernel oops, the kernel will die soon.
> Also, a user program may be constructed to trigger
> do_DataAbort()->show_pte(), as described in this mail:
> Link: https://lore.kernel.org/20260625100031.25088-1-xieyuanbin1@huawei.com
>
> For user faults, it is safe to acquire mmap_write_lock(), because
> we never return to user with mmap lock held or pagefault disabled.
>
> Note that, due to the lack of ARMv4T for testing, this patch does not
> fix the issue in baddataabort()->show_pte().
>
> V3->V4:
>   - Keep nothing change for kernel faults.
>   - Change mmap read lock to write lock.
>   - Restrict that show_pte() is called only when the addr
>     is a user-space address (addr < TASK_SIZE).
>
>  arch/arm/mm/fault.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index c68677503532..0a09d4ff7718 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -174,21 +174,25 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
>  	struct task_struct *tsk = current;
>
>  	local_irq_enable();
>
>  #ifdef CONFIG_DEBUG_USER
>  	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
>  	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
>  		pr_err("8<--- cut here ---\n");
>  		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
>  		       tsk->comm, sig, addr, fsr);
> -		show_pte(KERN_ERR, tsk->mm, addr);
> +		if (likely(addr < TASK_SIZE)) {
> +			mmap_write_lock(tsk->mm);
> +			show_pte(KERN_ERR, tsk->mm, addr);
> +			mmap_write_unlock(tsk->mm);
> +		}
>  		show_regs(regs);
>  	}
>  #endif
>  #ifndef CONFIG_KUSER_HELPERS
>  	if ((sig == SIGSEGV) && ((addr & PAGE_MASK) == 0xffff0000))
>  		printk_ratelimited(KERN_DEBUG
>  				   "%s: CONFIG_KUSER_HELPERS disabled at 0x%08lx\n",
>  				   tsk->comm, addr);
>  #endif
>
> @@ -632,21 +636,29 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>
>  	if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
>  		return;
>
>  	if (likely(user_mode(regs)))
>  		local_irq_enable();
>
>  	pr_alert("8<--- cut here ---\n");
>  	pr_alert("Unhandled fault: %s (0x%03x) at 0x%08lx\n",
>  		inf->name, fsr, addr);
> -	show_pte(KERN_ALERT, current->mm, addr);
> +	if (likely(user_mode(regs))) {
> +		if (addr < TASK_SIZE) {
> +			mmap_write_lock(current->mm);
> +			show_pte(KERN_ALERT, current->mm, addr);
> +			mmap_write_unlock(current->mm);
> +		}
> +	} else {
> +		show_pte(KERN_ALERT, current->mm, addr);
> +	}
>
>  	arm_notify_die("", regs, inf->sig, inf->code, (void __user *)addr,
>  		       fsr, 0);
>  }
>
>  void __init
>  hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int, struct pt_regs *),
>  		 int sig, int code, const char *name)
>  {
>  	if (nr < 0 || nr >= ARRAY_SIZE(ifsr_info))
> --
> 2.53.0
>

Cheers, Lorenzo

