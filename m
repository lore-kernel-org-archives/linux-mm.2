Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D062ACFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2DE76B0088; Thu, 27 Nov 2025 09:49:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEF96B008C; Thu, 27 Nov 2025 09:49:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BBA6B0093; Thu, 27 Nov 2025 09:49:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4C906B0088
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:49:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BFF81401A4
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:49:19 +0000 (UTC)
X-FDA: 84156670038.28.21AD551
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id A12D480020
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:49:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="Pliw/Hg2";
	dkim=pass header.d=linutronix.de header.s=2020e header.b="tk/qR6wX";
	spf=pass (imf02.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764254958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NGhO3m20hNBLQgRoRe5aCNIWN6lSYGzFhhL4/I6i0M=;
	b=g6NGRUDRQS+zk1BL6vS5opehoD7vMn9XsWAhAZilasjU1QmjMgWnInxe0GMVyAnswXshKD
	rA0RJirCz3ZZON2EbxYkoePnGWyaz0kOBJ8UFInANoj0+TbED+ZPhgy3EEDp29EcKrQWNA
	mElVesfAyHMhH0ub3gzatzhlSXU8YGQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="Pliw/Hg2";
	dkim=pass header.d=linutronix.de header.s=2020e header.b="tk/qR6wX";
	spf=pass (imf02.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764254958; a=rsa-sha256;
	cv=none;
	b=OIPZf/VaEr+KRxJC1OOZ9BgNGiLCpHNWUeqPrhqeklM3MVQkZtRiVn4+NVebIi050uNGHC
	YPOlGxgjwftWzO+7uDo+Y8DGfC9v3Gpv7HQ8Db0VMM98W5pauK76t5iH/uN/C2FmCuqicL
	qqYbYxqEutWQRMJhxiJU98Y+2d3R3cI=
Date: Thu, 27 Nov 2025 15:49:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1764254955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7NGhO3m20hNBLQgRoRe5aCNIWN6lSYGzFhhL4/I6i0M=;
	b=Pliw/Hg2CT43fdJgplojXUFqZWA2AK9IGFihMdPAPz54Y8g0mjc85DdYd2Uo6AllcFjoiT
	9VFWW866CG15H8AZg/JOkeXYUoDhKfKcxkPBufmmf31b+Tni2xhvwJ6vE14mXJrqCOEcP0
	d+Jt8lZF5hv5n1mjHJ0kkReygCl30hEonK/PRRaU104CqK4tSZLtYY/ytzUKnDDAFYM56t
	nSDG11BcPSSmZC+LG4P3Ucp1u/pEVab4lb9MPVaD/bferdR2FOke+brgUytotq5Sev6xIe
	1uaZtYHsYuGKahn5mbDONskt7U1CBXWwRR4AMWm1Cw9C0rCqvWuWOYljP/axIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1764254955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7NGhO3m20hNBLQgRoRe5aCNIWN6lSYGzFhhL4/I6i0M=;
	b=tk/qR6wXFEg1BUpfHcBHWK5zjR3/ybtkL+SBbbbMbUDbtuwWcXISYr74nD3EOKGwFa5B+2
	Kr1OcIdXS+VWX2CQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: viro@zeniv.linux.org.uk, will@kernel.org, nico@fluxnic.net,
	rmk+kernel@armlinux.org.uk, linux@armlinux.org.uk,
	david.laight@runbox.com, rppt@kernel.org, vbabka@suse.cz,
	pfalcato@suse.de, brauner@kernel.org, lorenzo.stoakes@oracle.com,
	kuninori.morimoto.gx@renesas.com, tony@atomide.com, arnd@arndb.de,
	akpm@linux-foundation.org, punitagrawal@gmail.com, hch@lst.de,
	jack@suse.com, rjw@rjwysocki.net, marc.zyngier@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	wozizhi@huaweicloud.com, liaohua4@huawei.com, lilinjie8@huawei.com,
	pangliyuan1@huawei.com, wangkefeng.wang@huawei.com
Subject: Re: [RFC PATCH v2 2/2] ARM/mm/fault: Enable interrupts before
 sending signal
Message-ID: <20251127144913.arc7keYZ@linutronix.de>
References: <20251127140109.191657-1-xieyuanbin1@huawei.com>
 <20251127140109.191657-2-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251127140109.191657-2-xieyuanbin1@huawei.com>
X-Stat-Signature: igd84ix76z9suybtepsd1zgiicq3zan8
X-Rspam-User: 
X-Rspamd-Queue-Id: A12D480020
X-Rspamd-Server: rspam09
X-HE-Tag: 1764254957-353531
X-HE-Meta: U2FsdGVkX1/tAVUaHpuoBJC/w5eFmfsge1h+CqLFbeoMzTI5qurtkNFs2xPuCig22bILJiZDm+2/50EoWH8eHH5+aOYtEhDymqLH2vHhlvl5y/38tGY0c5VbDXyPlV+LqK9/g4WfiSng1k/kimXZxv/s0/4VAT0JSBuor8wLK4eIg11fre3J3D7KpY4JKwAnXulwfxAp/w5MLFA+xzF8t1bym0IFSotGG4Dy9UnlMNMSl8IIMKJOwg5Pa2HJnC0lJzXAtBxAKvrhEGlfT9ZD+JMSTzMAfEFJEwO9CtFDTC3KR35FRuiOK380+cZF2jj3ZoTb++VoWF+f6qIUji79jkW5pflIJEpXmkJNgfncVZGsCaqpm1G27Y65Y+EkisjTFyJtFsgB+M/HP5Q5xhIFdwME6NDXJjm1lOyr+F/d6koYkxAcMrrMw+hDj6KwoDnhL9VOZfmELTU+KuOQ2h4lfTMt8iocN50uyfweVNu4kJkxH1aSzZOtoqdPLU1jAkl2QM9/BCDKnSE3SxzAz3Ht9GlrVk2z0G4V1w2XOsRZTQNHu0J5xRhND3Gz+bo9RdxhfiHjc/6Mr7N0QXOs5vXdgmc7uXoJl3v0v9BR4M7jL7T+HVY6daGjnaXPVjiMoeNQXzepEjoBEXoKF+ACk9AcvARse6AV8VA6eBs5Gkf7B8aK7tY4SvL+nDMlCL/uFth4wE3bwin4b2zd2Wbretflm8T1jB/Uf3+S7VD1f2vsgOp9veKIg2rptdh/ua1DfAgodWMetTQ8L5JUGAozdYSAUKp9BVQ/4OjOwYCUgupINmUbA6TPSyI2q1dSpWgKZPHpolhNhHwpqLLJg+c9adQrqjohP+47RsH1N96tDvxsXpfdVaTiIYAsrGVtlqK+jQCQhwxvapgKEz/DUMTE9b2RN+Olwv3riQLZJMxklRTaYO30TnGZ58Qrmre1sIdxn/q2zeLSdqsrhunmzTClWMh
 EStvsYSM
 eyMzWR3iYkVXlfas0aiRY5PSvzHQ5gBK+lAyx/z2uI82vlgu363+U8OaUTIkvxGLR1h4j+SlQdYWqzyT/b37uln1umTFt7v5KCEAVLVcLUyUSVmf0Zec+UgLo/31uU7UzKaurMNn388CxySqHF4mWKvvJpXnzMrFHIweExJ6CF26t6L+mlTfwrOE5GUoaHfIc0LqBfDZRGNd9U/SoD8yysnZFWwTonVhY7lHQxsObJBKgpPGiGgd3tVQIMiDoyM7UpJPRZigKRubr1mTGCX7umGAdpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-27 22:01:09 [+0800], Xie Yuanbin wrote:
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -184,10 +184,13 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
>  	struct task_struct *tsk = current;
>  
>  	if (addr > TASK_SIZE)
>  		harden_branch_predictor();
>  
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		local_irq_enable();

This shouldn't be limited to CONFIG_PREEMPT_RT. There is nothing wrong
with enabling it unconditionally.

>  #ifdef CONFIG_DEBUG_USER
>  	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
>  	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
>  		pr_err("8<--- cut here ---\n");
>  		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",

Sebastian

