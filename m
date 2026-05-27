Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5529ECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8096B008C; Wed, 27 May 2026 05:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88D36B0092; Wed, 27 May 2026 05:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5366B0093; Wed, 27 May 2026 05:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE3E6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:34:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 590E11C1254
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:34:29 +0000 (UTC)
X-FDA: 84812689458.14.386D00D
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id DEBAC180006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:34:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ctM3oFHi;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779874466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2s2G0QinDuGL67s7x9e2FY4NTt/aPclUujSKaWaqvA=;
	b=wdVtFfyO6nLzniKmtsSHuzVzof9P8xMBtveZyM5A0JbXzoyoU8ik/RiOANS9DGYNJRYkVc
	GUQKvO2wUo1VxuA9PncMrK1TAbxGydBLjxbCDjJ7iCHIq2BmaBQ3UXzn6wAAM2n0w/Yzxc
	eB3t69UT4sojXo2yyL7cqCWL8RlfW/0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ctM3oFHi;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779874466; a=rsa-sha256;
	cv=none;
	b=riD8e8pI+XSzRoIDK12gfE/N6swWSEo3KqdL3eooiYWvwMMYXGyhVx+wk7fpmj506lNEg6
	aEo79WkvjEd6O+yrcmJSl02SiocvBW1N/fOxzOSTiX/WDQHGPVATvj7x/05z3s+ah3sF+6
	7lKM0gVCrQDTtUSEQZaR+XfmTKcRm8U=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779874460; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=s2s2G0QinDuGL67s7x9e2FY4NTt/aPclUujSKaWaqvA=;
	b=ctM3oFHi2bkwJNuz7fZ4f993Ofdp3LMF0QzFCENGzCWTU9L8HIiUyvc8ya3/zHwB6uP1mAwqZiNoORZc6JCAtHr6LxrAXrhuedNoiFg9+L1PNhOnjR5H1uBN3w/gOsCYTogMObFOdVS+a9A2BrJKPpz5pBs+h3StgTqASJ8pPTc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X3jCuQ6_1779874456;
Received: from 30.246.179.14(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0X3jCuQ6_1779874456 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 17:34:18 +0800
Message-ID: <c6ca8a87-c341-4368-9773-39c48ab9297d@linux.alibaba.com>
Date: Wed, 27 May 2026 17:34:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 2/8] ACPI: APEI: GHES: use exception context to gate
 SIGBUS on poison consumption
To: Ruidong Tian <tianruidong@linux.alibaba.com>, catalin.marinas@arm.com,
 will@kernel.org, rafael@kernel.org, tony.luck@intel.com,
 guohanjun@huawei.com, mchehab@kernel.org, tongtiangen@huawei.com,
 james.morse@arm.com, robin.murphy@arm.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
 christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
 naveen.n.rao@linux.ibm.com, tglx@linutronix.de, mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com
References: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
 <20260518084956.2538442-3-tianruidong@linux.alibaba.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260518084956.2538442-3-tianruidong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kzbmaskxfggfr61mwsd9adac89tpk3u4
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DEBAC180006
X-Rspam-User: 
X-HE-Tag: 1779874464-342001
X-HE-Meta: U2FsdGVkX1+likyG841UkZ8PJG2JmvbdyVwdJ7y1EZFJrxSZmfdlcSxELEfl2FwJ8pPukdfuwB18q62fPC18wv9XjWFzXUQjLTDHAcY/ZBquNL6NoQ7Hq1chqx7qxEQUzhriJJDkeul/z6jIr2d+Qou6fPwDjsnIbNkJU2omr2rWH9Odg2txwEqY+25YcPISfBmh/EB1WNc7blGUDnDZG1BNGmPjr1YwhP1uI7fzMT9kzO558DIZBSghGVqTLxUkcmYi8hpFbOwhYdQRyA969bp2cYT5BNKb78aKrO39DyIJ2+b6sRrhBqtAuPZjKpCHO7FGTEAW/3nn0fbRcHk6ArTv3RAFch0o/lsGyX3S2hNAbnbARWNQQ3FjzV+dGXdmEV8vwba3PlvBXP6qniVuT+855P2pgcjX8DsWMZTNm5OY8icA0UdvRc+S3HHnFMDnMZa0izsVC+3Elz9EW7VjLBmejDb53lu3+1riLwA4kKMz3AOFrtv3PltJBx1Rol0Szbump6NRK4SXKOuxc/1x7OqNHX2fe3bJZZjxBGIDsYPS7XHvlrh12iwUI2fdqyQKyeax6drC6Ab9mb3k5vgo77p/W/FVAcMKoOaGt1ptt2cM/hvJqTwpL1vQ/vY+nX6HdsJAAJ4n63gkPaBjqQRW0ylu+JgjQpBYLyZ7yKZ10j1l1KDw39obURsyZTMJPoR07BTJNW5ROXDMYWDc+lNoldEY5kkDV2FUEgKr7vusQdTRJ+t8i7pZMhG76LPG+i1ugi1gF3Kpc3ExjIucPnN4FhLWQxtMw+DZwxlzsWDdUuh7AsqZU6gJJMBhFEXNqxCO1QEm8cxAcOk7SBe+417w7jiw9tijRAWm6NZLRU3POEMOf7MIP169wrLutEZI/uMbcm3T5H4+NnP+SwRag2S5VWEX0LUxctPSZcYv8pJbRsw+LlNujqznyPAW8fl3tNuns6bTbFkh46IWw/bSQue
 7tp33K84
 W8TvCaPNquhY6YA07KUyXj5sbICn4+wMCWDQOAos7z4XfhJx1PVHyQEzg0Mx8f21ndCne8JbnX/8Q8sueNfKfehN4kaY9wc+ComcetLzGB17cShDtzHdJMEvf04L3VComzQ8ghQlcTuFrs0sC4xDw0pVEOXiLaTUwSEEvHcDfTeuMsXHLC2T9p/fPk0/WBFnnQwcIyalG0zkXg+NbU/TSmHGEQfqlbYlU8mxcRu9Du97S0Kdx9vL0IqYZWhY2xt3IgnefeORcJDGToGaC0n5kb+vHA6y1ChNQlfVpfzAbbeSwyV07/Yy4SQoBZjhlU/BVUYSanYKPcy9s7ggJV4ecLJgBKPb01hD3CK02dDt2oaDoUD7COcX/byBANw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 4:49 PM, Ruidong Tian wrote:
> When a GHES SEA (Synchronous External Abort) fires while the CPU
> was executing in kernel mode, it typically means that kernel code
> itself consumed a poisoned memory location -- e.g. copy_from_user()
> / copy_to_user() invoked from a ioctl() or write() syscall touched
> a poisoned user page or page-cache page on behalf of the task.
> 
> The expected behaviour in that case is that the faulting kernel
> helper returns via its extable fixup and the syscall returns an
> error (e.g. -EFAULT) to user space. It is NOT appropriate to deliver
> SIGBUS to the current task: the task did not directly dereference
> the poisoned address, the kernel did on its behalf, and the kernel
> is able to recover.
> 
> Up to now ghes_handle_memory_failure() unconditionally promoted any
> synchronous recoverable memory error to MF_ACTION_REQUIRED, which
> ends up SIGBUS on current -- regardless of whether the poison was
> consumed from user space or from inside the kernel on the task's
> behalf. That kills tasks that should instead have seen a plain
> syscall error.
> 
> To fix this, the execution mode in which the exception was taken
> must be captured at the arch-level entry point, where pt_regs (and
> hence user_mode(regs)) are still available. The estatus node that
> later drains the error in IRQ / process context no longer has
> access to the original regs.
> 
> Introduce:
> 
>      enum context { NO_USE = -1, IN_KERNEL = 0, IN_USER = 1 };
> 
> and plumb the value all the way down to the queued estatus node:
> 
>   * Add an 'enum context context' field to struct ghes_estatus_node
>     and record it in ghes_in_nmi_queue_one_entry().
>   * Extend ghes_notify_sea() and the internal
>     ghes_in_nmi_spool_from_list() with an enum context parameter.
> 
> Then consume the recorded context in ghes_handle_memory_failure()
> for the GHES_SEV_RECOVERABLE / sync path:
> 
>      flags = sync && context == IN_USER ? MF_ACTION_REQUIRED : 0;
> 
> i.e. MF_ACTION_REQUIRED (and thus SIGBUS via the task_work path) is
> only raised for user-mode poison consumption. Synchronous errors
> taken in kernel mode fall back to memory_failure_queue() with
> flags=0, asynchronously isolating the poisoned page while letting
> the faulting kernel helper's extable fixup return -EFAULT
> to user space.
> 
> Paths that pass NO_USE are unaffected:
> sync is false for them, so flags stays 0 as before.
> 
> Signed-off-by: Ruidong Tian  <tianruidong@linux.alibaba.com>
> ---
>   arch/arm64/kernel/acpi.c |  2 +-
>   drivers/acpi/apei/ghes.c | 36 ++++++++++++++++++++----------------
>   include/acpi/ghes.h      |  6 ++++--
>   3 files changed, 25 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index 5891f92c2035..40d4a2913d51 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -409,7 +409,7 @@ int apei_claim_sea(struct pt_regs *regs)
>   	 */
>   	local_daif_restore(DAIF_ERRCTX);
>   	nmi_enter();
> -	err = ghes_notify_sea();
> +	err = ghes_notify_sea(user_mode(regs));

apei_claim_sea() explicitly documents that @regs may be NULL when
called from process context, and arch/arm64/kvm/mmu.c does exactly
that:

     if (apei_claim_sea(NULL) == 0)
             return 1;

user_mode(regs) dereferences regs->pstate, so any SEA taken on a
KVM-enabled arm64 host with this patch applied will oops immediately.

This also relies on bool 1 == IN_USER == 1 and bool 0 == IN_KERNEL == 0
purely by coincidence. The day someone reorders the enumerators or
adds a new value before IN_USER, the policy silently flips (kernel-
mode poison would start raising SIGBUS again) with no warning from
the compiler. Please convert explicitly with a ternary as shown
above; problem #1 then falls out for free.

Please handle the NULL case explicitly, e.g.:

     err = ghes_notify_sea(regs ? (user_mode(regs) ? GHES_CTX_USER
                                                   : GHES_CTX_KERNEL)
                               : GHES_CTX_NA);



>   	nmi_exit();
>   
>   	/*
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 3236a3ce79d6..6f265893cddf 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -529,7 +529,7 @@ static bool ghes_do_memory_failure(u64 physical_addr, int flags)
>   }
>   
>   static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
> -				       int sev, bool sync)
> +				       int sev, bool sync, enum context context)
>   {
>   	int flags = -1;
>   	int sec_sev = ghes_severity(gdata->error_severity);
> @@ -543,7 +543,7 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
>   	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
>   		flags = MF_SOFT_OFFLINE;
>   	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
> -		flags = sync ? MF_ACTION_REQUIRED : 0;
> +		flags = sync && context == IN_USER ? MF_ACTION_REQUIRED : 0;
>   
>   	if (flags != -1)
>   		return ghes_do_memory_failure(mem_err->physical_addr, flags);
> @@ -552,10 +552,10 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
>   }
>   
>   static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
> -				     int sev, bool sync)
> +				     int sev, bool sync, enum context context)
>   {
>   	struct cper_sec_proc_arm *err = acpi_hest_get_payload(gdata);
> -	int flags = sync ? MF_ACTION_REQUIRED : 0;
> +	int flags = sync && context == IN_USER ? MF_ACTION_REQUIRED : 0;
>   	int length = gdata->error_data_length;
>   	char error_type[120];
>   	bool queued = false;
> @@ -910,7 +910,8 @@ static void ghes_log_hwerr(int sev, guid_t *sec_type)
>   }
>   
>   static void ghes_do_proc(struct ghes *ghes,
> -			 const struct acpi_hest_generic_status *estatus)
> +			 const struct acpi_hest_generic_status *estatus,
> +			 enum context context)
>   {
>   	int sev, sec_sev;
>   	struct acpi_hest_generic_data *gdata;
> @@ -937,11 +938,11 @@ static void ghes_do_proc(struct ghes *ghes,
>   			atomic_notifier_call_chain(&ghes_report_chain, sev, mem_err);
>   
>   			arch_apei_report_mem_error(sev, mem_err);
> -			queued = ghes_handle_memory_failure(gdata, sev, sync);
> +			queued = ghes_handle_memory_failure(gdata, sev, sync, context);
>   		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
>   			ghes_handle_aer(gdata);
>   		} else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
> -			queued = ghes_handle_arm_hw_error(gdata, sev, sync);
> +			queued = ghes_handle_arm_hw_error(gdata, sev, sync, context);
>   		} else if (guid_equal(sec_type, &CPER_SEC_CXL_PROT_ERR)) {
>   			struct cxl_cper_sec_prot_err *prot_err = acpi_hest_get_payload(gdata);
>   
> @@ -1190,7 +1191,7 @@ static int ghes_proc(struct ghes *ghes)
>   		if (ghes_print_estatus(NULL, ghes->generic, estatus))
>   			ghes_estatus_cache_add(ghes->generic, estatus);
>   	}
> -	ghes_do_proc(ghes, estatus);
> +	ghes_do_proc(ghes, estatus, NO_USE);
>   
>   out:
>   	ghes_clear_estatus(ghes, estatus, buf_paddr, FIX_APEI_GHES_IRQ);
> @@ -1297,7 +1298,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
>   		len = cper_estatus_len(estatus);
>   		node_len = GHES_ESTATUS_NODE_LEN(len);
>   
> -		ghes_do_proc(estatus_node->ghes, estatus);
> +		ghes_do_proc(estatus_node->ghes, estatus, estatus_node->context);
>   
>   		if (!ghes_estatus_cached(estatus)) {
>   			generic = estatus_node->generic;
> @@ -1335,7 +1336,8 @@ static void ghes_print_queued_estatus(void)
>   }
>   
>   static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
> -				       enum fixed_addresses fixmap_idx)
> +				       enum fixed_addresses fixmap_idx,
> +				       enum context context)
>   {
>   	struct acpi_hest_generic_status *estatus, tmp_header;
>   	struct ghes_estatus_node *estatus_node;
> @@ -1364,6 +1366,7 @@ static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
>   	if (!estatus_node)
>   		return -ENOMEM;
>   
> +	estatus_node->context = context;
>   	estatus_node->ghes = ghes;
>   	estatus_node->generic = ghes->generic;
>   	estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
> @@ -1398,14 +1401,15 @@ static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
>   }
>   
>   static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list,
> -				       enum fixed_addresses fixmap_idx)
> +				       enum fixed_addresses fixmap_idx,
> +				       enum context context)
>   {
>   	int ret = -ENOENT;
>   	struct ghes *ghes;
>   
>   	rcu_read_lock();
>   	list_for_each_entry_rcu(ghes, rcu_list, list) {
> -		if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx))
> +		if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx, context))
>   			ret = 0;
>   	}
>   	rcu_read_unlock();
> @@ -1488,7 +1492,7 @@ static LIST_HEAD(ghes_sea);
>    * Return 0 only if one of the SEA error sources successfully reported an error
>    * record sent from the firmware.
>    */
> -int ghes_notify_sea(void)
> +int ghes_notify_sea(enum context context)
>   {
>   	static DEFINE_RAW_SPINLOCK(ghes_notify_lock_sea);
>   	int rv;
> @@ -1497,7 +1501,7 @@ int ghes_notify_sea(void)
>   		return -ENOENT;
>   
>   	raw_spin_lock(&ghes_notify_lock_sea);
> -	rv = ghes_in_nmi_spool_from_list(&ghes_sea, FIX_APEI_GHES_SEA);
> +	rv = ghes_in_nmi_spool_from_list(&ghes_sea, FIX_APEI_GHES_SEA, context);
>   	raw_spin_unlock(&ghes_notify_lock_sea);
>   
>   	return rv;
> @@ -1552,7 +1556,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
>   		return ret;
>   
>   	raw_spin_lock(&ghes_notify_lock_nmi);
> -	if (!ghes_in_nmi_spool_from_list(&ghes_nmi, FIX_APEI_GHES_NMI))
> +	if (!ghes_in_nmi_spool_from_list(&ghes_nmi, FIX_APEI_GHES_NMI, NO_USE))
>   		ret = NMI_HANDLED;
>   	raw_spin_unlock(&ghes_notify_lock_nmi);
>   
> @@ -1606,7 +1610,7 @@ static void ghes_nmi_init_cxt(void)
>   static int __ghes_sdei_callback(struct ghes *ghes,
>   				enum fixed_addresses fixmap_idx)
>   {
> -	if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx)) {
> +	if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx, NO_USE)) {
>   		irq_work_queue(&ghes_proc_irq_work);
>   
>   		return 0;
> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
> index 8d7e5caef3f1..646cd5c3c0ca 100644
> --- a/include/acpi/ghes.h
> +++ b/include/acpi/ghes.h
> @@ -33,10 +33,12 @@ struct ghes {
>   	void __iomem *error_status_vaddr;
>   };
>   
> +enum context {NO_USE = -1, IN_KERNEL = 0, IN_USER = 1};

This goes into include/acpi/ghes.h, which is included widely. The
type name and all three enumerators are far too generic; "IN_USER"
and "IN_KERNEL" in particular are likely to collide with driver-local
enums in the future, and once this is merged the names are hard to
change.

Please prefix:

     enum ghes_exec_ctx {
             GHES_CTX_NA     = -1,
             GHES_CTX_KERNEL = 0,
             GHES_CTX_USER   = 1,
     };


Thanks.
Shuai


