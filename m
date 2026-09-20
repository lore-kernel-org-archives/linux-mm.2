Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB080C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 03:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736116B008A; Sat, 19 Sep 2026 23:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DC86B008C; Sat, 19 Sep 2026 23:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64A1F6B0092; Sat, 19 Sep 2026 23:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3ABD56B008A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 23:53:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B024AA58ED
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:53:24 +0000 (UTC)
X-FDA: 85232770728.26.E4368F9
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf05.hostedemail.com (Postfix) with ESMTP id 96E44100009
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:53:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rF0Ks1OV;
	spf=pass (imf05.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789876402;
	b=SKWCzyrobMnh8W+yBQpENNX5v91NQc+W5BG7ZPxvABOdhXq/2rzMlxyTeyrekTOAk8IbAz
	crMSl1g14OvtNqBFP5lDxc62NVMV7pcQgGsjkBUFt9t638nyNF7lbLhHgRggcxpXx3XYzQ
	bGJ3C8Ixx4uo1KR1nmN+JIlSdjBnF+E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rF0Ks1OV;
	spf=pass (imf05.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789876402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tlRuK8oy4p5tnkX98fUn+MG7+GepzpfRQqepp1VDdiI=;
	b=Os2ZCzKjGipKkdIFgO1NYwVwH4X+f6UyPiWQUcyA3qyMDltK5nwHMcto88Ug8zJPbBMwBU
	B45lKw0o6b1GRAVY1NslOCjQ2oq0v0NPQlRNnZzlpnQYraw2vy/ekMwZymTq0LIox9lMid
	4fDkanpMwXw/PX7appsdhlc2pfvPpbg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tlRuK8oy4p5tnkX98fUn+MG7+GepzpfRQqepp1VDdiI=;
	b=rF0Ks1OVp5HjgPVdwO3vQJK5rTKW6B2t+TaIafWOspsRr/x2OEimEnA3Y1/krDlFP7+YZPvyG
	wJIUAx17deeeASsWoW/3sf4A4bz6SS6FzoZgdnjTbEsn+xbijr4z/yaIvZIjme1/WUcWKbfgM22
	Tv7akItYW11zMpSyr8HODo4=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hnXHF4FgQzLlSh;
	Sun, 20 Sep 2026 11:42:17 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B33A40565;
	Sun, 20 Sep 2026 11:53:18 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemk200008.china.huawei.com (7.202.194.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 20 Sep 2026 11:53:16 +0800
Message-ID: <a6772b15-0229-40f3-be55-0d9ed229c0a1@huawei.com>
Date: Sun, 20 Sep 2026 11:53:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/17] arm64: crash: Add crash hotplug support
To: <sashiko-reviews@lists.linux.dev>, <tglx@kernel.org>,
	<ritesh.list@gmail.com>, <mark.rutland@arm.com>, <chao.gao@intel.com>,
	<kas@kernel.org>, <linuxppc-dev@lists.ozlabs.org>, <yeoreum.yun@arm.com>,
	<x86@kernel.org>, <baoquan.he@linux.dev>, <hbathini@linux.ibm.com>,
	<sourabhjain@linux.ibm.com>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <jbouron@amazon.com>,
	<dave.hansen@linux.intel.com>, <rafael@kernel.org>, <coxu@redhat.com>,
	<akpm@linux-foundation.org>, <gshan@redhat.com>, <vishal.l.verma@intel.com>,
	<ruirui.yang@linux.dev>, <seanjc@google.com>, <bgwin@google.com>,
	<chenhuacai@kernel.org>, <pasha.tatashin@soleen.com>, <kees@kernel.org>,
	<me@linux.beauty>, <npiggin@gmail.com>, <maddy@linux.ibm.com>,
	<thuth@redhat.com>, <graf@amazon.com>, <palmer@rivosinc.com>,
	<chleroy@kernel.org>, <guodongtai@kylinos.cn>, <zhangtianyang@loongson.cn>,
	<eric.devolder@oracle.com>, <catalin.marinas@arm.com>, <leitao@debian.org>,
	<driver-core@lists.linux.dev>, <piliu@redhat.com>, <kernel@xen0n.name>,
	<dakr@kernel.org>, <pratyush@kernel.org>, <sshegde@linux.ibm.com>,
	<tangyouling@kylinos.cn>, <adityag@linux.ibm.com>, <rppt@kernel.org>,
	<mclapinski@google.com>, <takahiro.akashi@linaro.org>,
	<linux-arm-kernel@lists.infradead.org>, <will@kernel.org>, <ardb@kernel.org>,
	<gregkh@linuxfoundation.org>, <lizhengyu3@huawei.com>, <linux-mm@kvack.org>,
	<james.morse@arm.com>, <linux-fsdevel@vger.kernel.org>, <mpe@ellerman.id.au>,
	<mingo@redhat.com>, <bp@alien8.de>, <blum@kernel.org>, <robh@kernel.org>,
	<hpa@zytor.com>, <liukexin@kylinos.cn>, <maqianga@uniontech.com>
CC: <kexec@lists.infradead.org>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-18-ruanjinjie@huawei.com>
 <20260918103657.0CC341F000FF@smtp.kernel.org>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20260918103657.0CC341F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 96E44100009
X-Rspam-User: 
X-Stat-Signature: 9qxasynjnaq8wiqsbxtfb5g4kj3nw9ic
X-HE-Tag: 1789876401-393542
X-HE-Meta: U2FsdGVkX1+D42DzO1GY91c0yg41BwTp0yKsd/9TGMBcTKF1jiQKH0tHPgkfkm18b5FOjSwSyVCRBBMAg5WrthfykNHUpFkLecIEDsLn5aMo4/N/S7f5PyJCPQfKxM30bt6+CtUg66u0WpCQWi8wE9/bXPpmF5SPnlzuOUbTb2lRK6dQzhUsukskTV6ee71NautqFG1+20NJk8sVohh3vnWu5oyOyd2hYoJ/Xz4O0ih0SlgvtBFcqoPAXdQB0QHtdQybXhrLt5ETTOiYwG1btaV3DR4t01zyF2ALBKw0EDM2PvL2J+OpLNLv22ZPNeBc07DFZwWnXJeaSmvFqX0pMcDE4V/WJwzylXV9rjymLyF97p7Ga/gKvvqdbVHi5WEJJJYSKUYy8OX1Pg25Sm3aLcVsTOXFVaoO2d4v/cnd+FJ2JyIiDVnzpVQOxFdCNF2Tq2zTJG6f21aZnPgsq7+IhiM69LHQ8kKNA5ksNi4cIT8nyxmwMLsWFjZK7o2LeoF4CRw+ljyjWk5fWnooj6qYZ12nNUPKqYTmnhwZGj53JicweE+nnMaAQ5WLZMgGdFNSOKStBrOjPi6+8whwE/81ojabpVOrQ2fIaIoevqcwvqXh627K8Ah6LFK3zbMvVZxcHaqFNIKaqFfY4bMJiVBvOJxbHC95MtC64NqvlSobHQ0qsPG7+bqOx4Y9LCkGJpTKQdGewnB8QlJoOnYA7khrgO/YnaQdKolwldasRJ7t1u2p3tk6gUJ5QwQBmq+puEuBrsqq+3BY+wUSOrfRX+OzChj816AcnnVGfjGPMCn66elVfr13KxugRVG0GT9gukZrf9/0nLBJcIOUqS/K+S2+pklE+l8AJbZNwZXONmW3SqaIMrRZzNZGmgGsoxpYKfWo2QPSSkZspU7dj7i/bLTs5exkeggbLsLbwRPGZRHvk0DPUGPwZ7lxT3XGcyn5voh4xcwQWLkQdYWrhQ3WIko
 GM0W3o87
 UBzaIVJm1oggXlfW9ZWQxEuqitQzy7foDajRc33mxxIcZmOIskWifkWVnd3MOFMIk6HxbLiMVK9rNDQYWFdw+/vsWeyXcx0xaWxJkO6giq+YEdB9PnpnO7cjU97tfWsWd1UMczryn/AeBunh6ihgM7ymI7rDyQ9TrnKH4r71et6T7Y0K2ZWg4kqhH3ukGzPrYhFq6boVyjhtWt4cL4SL8vDgQNN/OddzA1jxnqU0HcGEYZSjb+KR4Al5ULQUx5NJDY7fXrCuf3jGQTzMOB4Ty8ZSotUJaY7/dQXeJbPFnhCo6RYxqlGLl6R/1S2aTr7QzwUPGtDIPbG8zYFAfL6NOGL1snvI2m/GUq4ih9cVDKWRCVJgnPF8piRhgxdpV65+k0hGA4X+dbRNl3VoXF4g4l3L+gqDiJZpttCiACqz0puSkeqGSmd1lVW3ksGOM6gB2lL7YxOdAWI/AiF8O4sHN1KzoHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/18 18:36, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] kexec: arch_crash_get_elfcorehdr_size() exports undersized buffer when MEMORY_HOTPLUG is disabled
> --
> 
> commit fd293f9cfd1a12554d9352f4ad58fc9f85721fa3
> Author: Jinjie Ruan <ruanjinjie@huawei.com>
> arm64: crash: Add crash hotplug support
> 
> This commit introduces kernel mechanisms to update only the elfcorehdr
> on memory hotplug events for arm64. It adds ARCH_SUPPORTS_CRASH_HOTPLUG 
> and implements arch-specific functions to handle memory hotplug, avoiding
> full kdump image reloads from userspace.
> 
> Link: https://lore.kernel.org/all/20240529133446.28446-1-Jonathan.Cameron@huawei.com/
> 
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index b5a51b0ef9440..96de2660b1cbb 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -1720,6 +1720,9 @@ config ARCH_DEFAULT_CRASH_DUMP
>>  config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
>>  	def_bool CRASH_RESERVE
>>  
>> +config ARCH_SUPPORTS_CRASH_HOTPLUG
>> +	def_bool y
>> +
> 
> [Severity: High]
> Does unconditionally enabling ARCH_SUPPORTS_CRASH_HOTPLUG here expose an
> undersized buffer to userspace when CONFIG_MEMORY_HOTPLUG is disabled?
> 
> Since CONFIG_HOTPLUG_CPU natively selects CONFIG_CRASH_HOTPLUG on
> architectures that support it, having this default to 'y' allows
> CRASH_HOTPLUG to be active even without MEMORY_HOTPLUG. This leads to the
> size calculation issue below.
> 
> [ ... ]
>> diff --git a/arch/arm64/kernel/crash.c b/arch/arm64/kernel/crash.c
>> new file mode 100644
>> index 0000000000000..08dc9b952498e
>> --- /dev/null
>> +++ b/arch/arm64/kernel/crash.c
> [ ... ]
>> +unsigned int arch_crash_get_elfcorehdr_size(void)
>> +{
>> +	unsigned long phdr_cnt;
>> +
>> +	/* A program header for possible CPUs, vmcoreinfo and kernel_map */
>> +	phdr_cnt = 2 + num_possible_cpus();
>> +	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
>> +		phdr_cnt += CONFIG_CRASH_MAX_MEMORY_RANGES;
>> +
> 
> [Severity: High]
> Is this calculation missing the static memory ranges when
> CONFIG_MEMORY_HOTPLUG is disabled?
> 
> If compiled with CONFIG_HOTPLUG_CPU=y (which natively selects
> CONFIG_CRASH_HOTPLUG) and CONFIG_MEMORY_HOTPLUG=n, phdr_cnt is computed as
> exactly 2 + num_possible_cpus(). This does not account for the mandatory
> memblock ranges from arch_get_system_nr_ranges(). 

Will fix it in v6.

> 
> Unlike x86 or powerpc which might survive this due to heavily padded
> CONFIG_NR_CPUS_DEFAULT values, arm64's precise num_possible_cpus() leaves
> zero headroom. As a result, the exported maximum elfcorehdr size is strictly
> smaller than the required size to hold static memory ranges, and any attempt
> to arm kdump (kexec -p) will fail because kexec-tools cannot load the crash
> kernel into the undersized segment.
> 

-- 
Best regards,
Jinjie


