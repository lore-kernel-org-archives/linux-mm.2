Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF27C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9598E6B00B1; Tue, 21 Jul 2026 05:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931216B00B5; Tue, 21 Jul 2026 05:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849E76B00B6; Tue, 21 Jul 2026 05:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDFD6B00B1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:23:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6750160401
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:23:50 +0000 (UTC)
X-FDA: 85012246620.25.6D9C746
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf04.hostedemail.com (Postfix) with ESMTP id D023B4000B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:23:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="3yo5xc/m";
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784625829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XzIw7gZRttLMSyjjTDa5uCrHYP0E7vjE31XbWW5ny4=;
	b=V4LyGA5cICie/wjeohoaJ56ResJXOCHV3ureZjNIX7IdgARD2Zh4wJqxaepvYSK/9Kgf2t
	22q1qmp3zpcZj+lkgYXENxJNFp+//4VhTUcUy7TBAGSOsGDR0a6CbMKwRj0M+al/ST+44e
	4gZweTGx/jFc1efhR1YVQYhWHnSW56k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784625829;
	b=Kla/JBKqM07Oi0dcmi4TzH8gOf7xIn5ADojJiFtTuQB6QT+Qi6a49tK5GS8Zf5syDGUCOB
	vdU8muiQGS4c8wtpYNxivQ9ioNdhIYl8+VKg4gBz/iykOB7X6u8Orm2PqtWQ55ZtwwCbno
	/WoT4U4IBYXw6XnfMY6FSwzs+bGP3Gk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="3yo5xc/m";
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8XzIw7gZRttLMSyjjTDa5uCrHYP0E7vjE31XbWW5ny4=;
	b=3yo5xc/mSw5KaZCHUE1kDcQbJK/3R42b0Z5+IWLerLM5ObcWveJLPHtuAKwL1gRM/QBHGa5Bs
	q0aYE4MqVHufVJ50Mf0FP8QC7yoeuz0c/TA9pguWMSY4eKbHqlIg9ZrwNL9wSRgR8IQPflktVXv
	ahhzzZ0UJNxQ4aFdvHeeYKo=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h4BXM26S6znTbk;
	Tue, 21 Jul 2026 17:14:11 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 2569A4055B;
	Tue, 21 Jul 2026 17:23:43 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Jul 2026 17:23:41 +0800
Message-ID: <8a1c8c38-e89b-4e22-9b46-aa53b0ed30f8@huawei.com>
Date: Tue, 21 Jul 2026 17:23:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 15/15] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <kees@kernel.org>,
	<oleg@redhat.com>, <luto@amacapital.net>, <wad@chromium.org>,
	<thuth@redhat.com>, <peterz@infradead.org>, <mark.rutland@arm.com>,
	<linusw@kernel.org>, <ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>,
	<yeoreum.yun@arm.com>, <anshuman.khandual@arm.com>, <james.morse@arm.com>,
	<tglx@kernel.org>, <broonie@kernel.org>, <pengcan@kylinos.cn>,
	<ryan.roberts@arm.com>, <liqiang01@kylinos.cn>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
 <20260721081858.1169276-16-ruanjinjie@huawei.com>
 <20260721104810-0a8ab042-2705-43e8-90d2-74e221f3fab5@linutronix.de>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20260721104810-0a8ab042-2705-43e8-90d2-74e221f3fab5@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D023B4000B
X-Stat-Signature: mhgc7qk1krfn86sxyxccx7qqhaaj11pt
X-Rspam-User: 
X-HE-Tag: 1784625827-214179
X-HE-Meta: U2FsdGVkX1/PZ+NxiA/cR+zGk/NUC25laOKYgZIlz4ZKU05zhs7UQcly1hHyF5TqgtevrPU2P8rL+w/Pm0bbq0dE4yeorxKBaseooYKHhvJLJrHk2jRlpzP9SPa5JSlzDkyPG7q2d7k141J9i1epgM2eoyTiLCKLGwOkp6c+QWbKLb0cqhy4NfdYpvq1rVfi4ZgekxJQEAKT2KCzTdR7u2J/RVgwgHXbuXJj+wRj3bAFI3O0LJ99ZffRQWDwGcv+eB8wFo6BwkFqjaLZp/POD5f6ChJiyt9XxawhxTjzYgaWm0l5zo9O81Rds2ljMYVNgzhtGNCM10WMxNhw4Wzc8OQKcuHnUXIXSj93FokPBQyczbLpBv4Z74nxDex/bbi42oBFhiokhCw+xDf8aiA9nhYlO1zF9tkZeO9GKyVc+C5n29EJgFi16NKfUiGieIz1dPf5CGnIqGWBM6y/jHG/BPxiQTYe0+qdJpLcow5yROr9tpkwfpesCxQRI86AC0WFerIf/5CqNKol8fu/5iddnauqAdNyFP9PvBfNhzBnnzRx3+rjgtPtAWYp/7dnJ2ToHXXO4Z2jt/IrouxbiTGwGgnVUbKFBzsvPSjO0MfJuBcd+kMTuj/uTLD6Gz1QwI5t6fyUmsSerUIAQkfQZ1Vr/gXhLEx4z6gYLs0XYAXiFHdYswO/ZoHz8VkqrOc7u2WkA8oSVvFKSeRPNQK0M3DdZlnsyI2wWJK7qNBlgxBLYFScAOZPiqIlH/y5kLXO6sgNvBUAF5LLM03Qg9kQfNiOPrgnZbmwUaYvVHB7l32AX/qVJlkItoFvivcg3iQ6/hlTJpOzFq8LKqQZZvgxDYA8LyX5KQRVWiSZn4+p88ArPbLnME7HVA6GimVx4YSF06hTjJ5SgOgqw6wiTdsWPl6q8VMK4geiGEq28SoeraKT0TouQR0zQMx4Ji6h5BGBQMiGHU9QsRmVU/hIOTFBZsf
 RDexgThu
 GdXhK6aUrHAK+XFdI7+UpPD9H3XirUvfBbfMdg/soGLH+K2C5Sh+77eT8j0UrzLBCwPsXCIABcA4OvyvmeQKFoPUp/+WMXZ6NOKheABMa6myzThfSI7Dzsu/d7HQn3CmpDdOF9O/zEbBqsh8zYDwp3zF3ap3XRc9ny5IrVM8lg9cK7gRhT6WEgcFdhMar8SlvZ0YaKVFdpgMdVH/DtNhOEQjcinXD04G0GPSNc4YpOIZUf272V+QAe41xqIl9E+aUEBcq/92T+6tn3szNQWVtGPbGTIjC1YpbXA++gjAFMWySmF6zb9hwyCJvtylnx3pGur9tKiTG6EyO1lwf5WCg6ijSh3SZ2gnfAF5TiCmTmg1SSoKUjBl8Vqvrzpjb1Z3OgxSB4VPk6bmjgHkFyJZHoq9Y5Q9Bw/BYv8ZcS/HkecOyyVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/21/2026 4:51 PM, Thomas Weißschuh wrote:
> On Tue, Jul 21, 2026 at 04:18:58PM +0800, Jinjie Ruan wrote:
>> Syscall User Dispatch (SUD) must not intercept the signal trampoline
>> code, otherwise returning from a signal with a locked selector may
>> cause infinite recursion into the signal handler.
>>
>> Provide an arm64 implementation of arch_syscall_is_vdso_sigreturn()
>> to exclude these sigreturn syscalls from dispatch.
>>
>> For native 64-bit tasks, check whether the current PC matches the 'svc #0'
>> instruction inside the vDSO sigreturn trampoline (defined in
>> arch/arm64/kernel/vdso/sigreturn.S as below).
>>
>> 	SYM_CODE_START(__kernel_rt_sigreturn)
>> 		mov     x8, #__NR_rt_sigreturn
>> 		svc     #0
>> 	SYM_CODE_END(__kernel_rt_sigreturn)
> 
> With the new label this code snippet here shouldnt be needed anymore.

You're right, the code itself is already clear.

> 
>> For COMPAT tasks, verify that the instruction falls within the dedicated
>> 'sigpage' range, since compat signal handlers use this architecture-
>> specific page (not the vDSO) for their return trampoline. This prevents
>> SUD from incorrectly dispatching syscalls issued during signal return.
>>
>> Suggested-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
>> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> Suggested-by: kemal <kmal@cock.li>
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>> ---
>>  arch/arm64/Kconfig                 |  1 +
>>  arch/arm64/include/asm/elf.h       |  1 +
>>  arch/arm64/kernel/vdso.c           | 16 ++++++++++++++++
>>  arch/arm64/kernel/vdso/sigreturn.S |  1 +
>>  arch/arm64/kernel/vdso/vdso.lds.S  |  1 +
>>  5 files changed, 20 insertions(+)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index aea686dce3d5..a41d2b593899 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -86,6 +86,7 @@ config ARM64
>>  	select ARCH_SUPPORTS_SCHED_SMT
>>  	select ARCH_SUPPORTS_SCHED_CLUSTER
>>  	select ARCH_SUPPORTS_SCHED_MC
>> +	select ARCH_SUPPORTS_SYSCALL_USER_DISPATCH
> 
> From the subject and description I would not have expected this to be in here.
> Split into its own patch?

If ARCH_SUPPORTS_SYSCALL_USER_DISPATCH is not implemented, then it seems
pointless to implement arch_syscall_is_vdso_sigreturn() separately, or
perhaps we should revise the title to indicate support for SUD on arm64?

> 
>>  	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
>>  	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
>>  	select ARCH_WANT_DEFAULT_BPF_JIT
> 
> (...)
> 
> For the rest:
> 
> Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

Thanks for the review.

> 
> 
> Thomas


