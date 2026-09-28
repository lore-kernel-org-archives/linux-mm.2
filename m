Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA06ACA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 20:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EDFE6B0088; Mon, 28 Sep 2026 16:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79DA06B008A; Mon, 28 Sep 2026 16:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6902F6B008C; Mon, 28 Sep 2026 16:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 460656B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:37:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FC491202E3
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:37:43 +0000 (UTC)
X-FDA: 85264332006.30.1523D14
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4A7D1140007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:37:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wgwhPxy8;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790627861;
	b=u1+6La6QVgmJwpX7/9HLNzE3mBE5u6CXp2Dt1O+rF0G4NhboRXMFU8m8GzMG1r+GpYbMZ6
	WryHaoUaafvOCM7UEU1s7HdC37jS12LCwzxdgxFyTubxIw2uY1OoUvrU8OItzoqeOcWdQM
	eAa/PywLBtHykrtPUDA7cXaU8CSOhw0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wgwhPxy8;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790627861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tAW3SlP431F7bjWdI4ygJqmG7YuYjWhSnR8WVAPb5Q=;
	b=1HbR4zfNXXEnbnx+tU0d4q2B2W5K+aEiVYZ++5LS+5voHBJWAPITvaz7ZpvkNHWdL0uOe+
	l6zkhwKhjXz4ar0hajd+JMDaByX8nMjnWuHa+O+GsNq71m/xJdMwLB6Zb3byRrgVYFdbLP
	vYBbaE6aOLXob45dFh/PbtBHc9PpvFM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=4tAW3SlP431F7bjWdI4ygJqmG7YuYjWhSnR8WVAPb5Q=; b=wgwhPxy8Tk1YMJ1hy/Ypbhb4r1
	xWswkSfytQMmBcdva/7O7JMfMNnKn4BMxHBGxKnDVBVaN6inyuo4O8W9t7K/emQ3H4FVgQvx47BeK
	45m1cOLuYsZgllZRJogqRAsj1o8/kgw4f3p/kD/EkenWTlvSFbsEszvw8116pQrZbPpQUSto3TKzW
	3DI53KR9Qznor5mfThIGGEwofi/PY1e5r2cuf9fb3mnv+mB3a4cXwisUnbN6DzLGbdGJZ2wsEFKiR
	22UxwFKn/640pqKtmcR4GNZBvePNE78jqGV67ciq2cm/YHQY+80D2ZarNCPc1Inv+GEayJEt1La9H
	FMfMCs2g==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xBI6U-00000001aN3-2nto;
	Mon, 28 Sep 2026 20:37:38 +0000
Message-ID: <5c6edcfe-8332-4db6-b0fa-ca5d137a2075@infradead.org>
Date: Mon, 28 Sep 2026 13:37:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 12/15] sched/task_stack: Introduce
 ARCH_HAS_VARIABLE_STACK_SIZE
To: Mostafa Saleh <smostafa@google.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, akpm@linux-foundation.org,
 urezki@gmail.com, mingo@redhat.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org
References: <20260928174122.3380703-1-smostafa@google.com>
 <20260928174122.3380703-13-smostafa@google.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260928174122.3380703-13-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: cer5ya9pqfx5hd3qzryqy1beuxqfsjai
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A7D1140007
X-HE-Tag: 1790627861-902030
X-HE-Meta: U2FsdGVkX18l7m0sTgkg/VNisPMlZ5pElITm2XAHDIgbHWPCrbMBm2W2U1Vbp0u65RjSxHqQGwsIuIFqzWPbYDftjbc0nyzeUOcrTqG7BSpN2Et5J5EIX0lSWXqJa+qPhy1cDPvzqD7reGScrZFaBdlaB2IVR4O/5WO67tTKrtsK0jQ08f3cn2GwjbhlxKeoBZVpNikC86laU3sgyWUp3Pv17Ew5BU3m2ndCBbV1GMJTVbHUfOWkBJLgx09J59l6tuLanLVxDyD8qeRuSOKQsg4Ppf01aDWK/pc1WWarZLNVWPclv/yiuScH8nW/fb4VOZ3spgAodnr+48+KoOgq7yghUX3hsMIGT9iQoAymLML7bLy7Ur4geXt0f8V6yUL7KiUzQjyzeon9VPuTMNnejfr8kUAp/t8OxKJWEgVdcXRMnpOrfvKd+JuspVTRWdAvwI1VJcWilBc0XVYjCjRnkXRKWjTKWV1ELVuJZc6FW7WO6Dgdjs5CZeW2STkYmyD/8EBLZV9BD/XtIEPCVM1b5Fsitm0Lfw3EQWoOmnChk/liP+NkOP4U/lR5MApzMPgQbKmyDalyt+6XcLLFH1rjBWPr15JcKXEFxIAONIhT9/iCbf3yR4lUHxU4UHdkbVp5MwIjXkKOG/tBR0zO/FZ0kDuMPMYjWy0b7K/iZU9E8QIADIcXCiWyBSGkY4MDPhFM2Zb7i5hRAxWE7e0qs2283o7M1wGtf4N7atmIOuqBqN3DMDMNl01oSu/oKac65yIro8OMgWHHI1ws4vXGq5VmHxqxPfMVs5pFX2J376ryzoqUNTg8h/tEwJw5Pa++hjW/DjMDOZ8jbGzWMyCxI30RiPpj98UHjZ4B5YRIBeU5ARK8/cS4bgKu+s72P1lxCr+OuB7Y75eOC7yKEpGFqBWbC1TkW5q3SejFurPWErWjEXPkU7e+kH4KfQUADbpi2H1KZG/l29dWCrlJ2yy1jE6
 xzs4oGAo
 xAgos6e7jKgS90GTTb8czthut/vVRov/S3ziqRh23HQFUyo5EnR6jSTTi4YD84/bVXlui4X92dUHT99WUoK4Qk22LGAHkWuyomFT34kJMXj9tQa/fWHGg7AuaTvbEmfyRLhFdGwd3VqeqqmjvI3R/Mwp1udHGbaYHjUUeSElya7R6iVkQ/ydSjdWG9SntXTOMFBmp6ehUw9k4eaaGoN6bLK/nVhLRDXpwlzt5qS5lWd0sNXVgIWFv7QP8c4K4PEU63PJ1b/OcQXsNKsww207aQPgnmmpx6P++F20cNMaoQfWzbiotrSgtZPoVdnYOOnnzD6kPtHE87iUJJrkXjpGhmOQiMunBHj3rDntB/cYBcUYhLpK9ws2uJdQXDoBTZ4eWajlQkXvzZ5jTTXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/28/26 10:41 AM, Mostafa Saleh wrote:
> When CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE is enabled, the kernel stack
> may not be fully populated with the THREAD_SIZE virtual area.
> 
> Teach task_stack_size() to return the size of the vm area and not a
> fixed size.
> 
> This propagates to end_of_stack() which makes functions like
> stack_not_used() and set_task_stack_end_magic() to use the lowest
> valid stack address instead of THREAD_SIZE which would cause data
> aborts.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/Kconfig                     | 10 ++++++++++
>  include/linux/sched/task_stack.h |  5 +++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 45c657772362..d6fa2ccb0599 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -431,6 +431,16 @@ config HAVE_ASM_MODVERSIONS
>  	  <asm/asm-prototypes.h> to support the module versioning for symbols
>  	  exported from assembly code.
>  
> +config ARCH_HAS_VARIABLE_STACK_SIZE
> +	bool
> +	depends on VMAP_STACK
> +	depends on !STACK_GROWSUP
> +	depends on THREAD_INFO_IN_TASK
> +	help
> +	  An arch should select this if it supports dynamically configuring the
> +	  kernel stack size.
> +	  For example the kernel stack size can be from the command line.

	                                    can be set from the command line.
?

> +
>  config HAVE_REGS_AND_STACK_ACCESS_API
>  	bool
>  	help
> diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
> index 4a808f9c4631..07d73adaecd1 100644
> --- a/include/linux/sched/task_stack.h
> +++ b/include/linux/sched/task_stack.h
> @@ -10,6 +10,7 @@
>  #include <linux/magic.h>
>  #include <linux/refcount.h>
>  #include <linux/kasan.h>
> +#include <linux/vmalloc.h>
>  
>  #ifdef CONFIG_THREAD_INFO_IN_TASK
>  
> @@ -96,6 +97,10 @@ static inline unsigned long *end_of_stack(const struct task_struct *p)
>   */
>  static __always_inline unsigned long task_stack_size(const struct task_struct *task)
>  {
> +#ifdef CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE
> +	if (task->stack_vm_area)
> +		return task->stack_vm_area->nr_pages * PAGE_SIZE;
> +#endif
>  	return THREAD_SIZE;
>  }
>  

-- 
~Randy


