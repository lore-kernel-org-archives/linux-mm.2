Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE78C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 01:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED596B008C; Tue,  1 Sep 2026 21:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76DC6B0096; Tue,  1 Sep 2026 21:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EFA6B0098; Tue,  1 Sep 2026 21:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83DD76B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 21:19:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 031741605C9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:19:39 +0000 (UTC)
X-FDA: 85167064920.18.4E260DD
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf13.hostedemail.com (Postfix) with ESMTP id EBA3420003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:19:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="JSc/QrUE";
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788311978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9UK13JKhSsPM/Vc9steoJSl+OnutIzRnlZukeamK+o=;
	b=aKUX+CJFNLtsbayF8UZ4dOriOHzDFvCWM6oubs/C4MNZ5BU6WTltyKNHA+xwR1JlcJM00c
	ChKTCjKYokFYmTkNXTg03uUo506CDM2lncBDPuhiB8EpJFXLBP1sFWZZ9e75kNm5kkDF52
	S/scxUI1M9a+PyN/6hGtvQSWAxTQmXs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="JSc/QrUE";
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788311978;
	b=75CoqYOOCvBsmgv9rePe/Djdy29lOwAS1AvFqnGjAIRHL/8dIvlpEwijySwamOexxaq1X5
	bexEcmAMH0e1P8ck9Q561pRZx4oyyITMwyUuGigAgApofPgSU/uBP3Uf18Yh8+LfHl+3d8
	Mc78cL8gpR3/Zn5LDl/6yBgDwTfT+F8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=t9UK13JKhSsPM/Vc9steoJSl+OnutIzRnlZukeamK+o=;
	b=JSc/QrUEAnbPE7s6EK6aHXX4FMrI/ak+7N46GxWAYjo+hv4+e8IRFqw3R57vf10ZXvwgmTnw1
	5LsKKvi+A3v/zJR4bWOVaYI3bbjz5k4AHVvkI67n+bm/COW12+QwJBDOanQFb2mbBv/tq3BctvX
	qaDBA0HnMSM+ut7AmVDhzas=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hZPjt2PDTznTVd;
	Wed,  2 Sep 2026 09:08:18 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id B4C9C40565;
	Wed,  2 Sep 2026 09:19:31 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 2 Sep 2026 09:19:29 +0800
Message-ID: <96ba8924-b857-4dbc-9161-4c464901f974@huawei.com>
Date: Wed, 2 Sep 2026 09:19:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/17] crash: Simplify CRASH_MAX_MEMORY_RANGES handling
To: Mike Rapoport <rppt@kernel.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<gshan@redhat.com>, <jic23@kernel.org>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <coxu@redhat.com>, <tangyouling@kylinos.cn>,
	<hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<ionut.nechita@windriver.com>, <liaoyuanhong@vivo.com>, <seanjc@google.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-16-ruanjinjie@huawei.com>
 <178829364021.3691424.12328056849597833403.b4-review@b4>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <178829364021.3691424.12328056849597833403.b4-review@b4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: ga4978it647dgp1o8dr9y6jcyi9mdpds
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EBA3420003
X-Rspam-User: 
X-HE-Tag: 1788311975-385102
X-HE-Meta: U2FsdGVkX18q1OPu2x8vL7JhnHk0gOruLdrgw1DOd0gKKeUitbKgyyJED+3CTauO+zB+gEtClcsfXtEG71Pbv/uo3kxucRkXxugxr4cznhQy+dK364vcAnzoJNiqCv81gpIgjrHXGxRrzlvIsBTqT09pxvLmPhwiM0ruXYonWJaY8H5m7SHUkZTofzVr1YVt36rfaQWKvxiClKpnJ/2A2FTkBIpsyVcLLoOQsqWrPp7UOtXLGNUecFkjaupi6eCkc2T7rsZgKbDMHex3Tt+0QZWw/KMLXp2WaP+Ne+EF9F5qqOZPZ+RlaWCVFOdLAWBFZY1pK8JUG4eahQt67xg5HGRCo3TJcIMKyT9TzBhyqbcgAvU5K9gKq3Ew7nmG1ail2zn51yK8e9DWSe7ycdk/LOFJtDBdAKEAyldQfTmHdCgbywrXRQU9VHp4diVtYFNVTiOCV2G+XQWmtyGYbmgVsoxl3pUudIEZlWM+iI4sbPT/xQmJLfn8whSyEb8na5RWc9VKhRQvmmhnb6J/6gT83vjgqReYyqfiz+86ONUdv/COpdXuSRBxYek+ZPqzGijRAUPuQWbkCg5l9Anlr4NzlRzdUiGCvli3Ox5PTsYU8od40g9KnLWLQ5L5/gOLSuDcEZhWvgV/piY6GvLLiBKVQGs9Pcm2Is4rPffJ+eclaHejTJW0uXo5XShfhbEca4Js+vSvmbdluhsTg/4f6EzulSvlhKbGHhlCZ7sekySYxGZek9lKBAeqLHc0lAeirkXsSmxLDmsDdeY5dW1C4f+gBnD3BYTXenJLnC+krScESQ18eO3d6DBnCYVT3/GtLEKOSD2gHpNMDp53rtdDOEjBDKmzV+1IUb08xHYDP/YWrE/BVf9g4NcxqmB5yAlhJ/82iJ8J5E7xPWTKpcB7OBhC8lG3DJb4gbxgdxio4CbgOZ9WwTJs9hZqlKPC8AGb2jKCJSymzbi2UmXlWL4C/pa
 2nlgwH+X
 5KKBYaHiaOHBnsPZGlg1yp+BgG/pofhHJ4lT4GuntwKT1NrPcprb32sQ6UlopGWfYxHoK4Vp4MB7CjjJGxN/K7W4Q26fwrMqRGJfYCU8TIXhh/qbkvYf5TR/5N9RhYaxyEgD7rSW1ATd6QWBRkZ6FwhnrHLm12fxd6Nj27oXS6MPrsoVfaEnFa537ij1haSmv/tNLttvDQQjbcKXzOj23vNM/nCz5QU8iOvn4Ed4IKypB6r+9mFWaWpthmfu9OMr3epjt83L1QzOVt+HliBhAiVRnbF1hI9I2CVvwdj5FhImvcz3hBbuSTJkdKztacK5ZkfRFwPJKdUsjyGHi0e6j/jklSMUi1qDIDX60z24W1t6Fl4cIWONrxbAJL5lBcdVZev2B993nBoSu13wU6FhSBfZgGGg/8Hpumfa8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/2 4:14, Mike Rapoport 写道:
> Hi,
> 
>> Set CRASH_MAX_MEMORY_RANGES to 0 when MEMORY_HOTPLUG is disabled, then
>> remove the now unnecessary IS_ENABLED(CONFIG_MEMORY_HOTPLUG) checks in
>> powerpc and x86 arch_crash_get_elfcorehdr_size().
>>
>> No functional change intended.
>>
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>>
>> diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
>> index fc0105c7af4c3..c47e3f867ea1f 100644
>> --- a/arch/powerpc/kexec/crash.c
>> +++ b/arch/powerpc/kexec/crash.c
>> @@ -474,9 +474,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
>>  	unsigned long phdr_cnt;
>>  
>>  	/* A program header for possible CPUs + vmcoreinfo */
>> -	phdr_cnt = num_possible_cpus() + 1;
>> -	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
>> -		phdr_cnt += CONFIG_CRASH_MAX_MEMORY_RANGES;
>> +	phdr_cnt = num_possible_cpus() + 1 + CONFIG_CRASH_MAX_MEMORY_RANGES;
>>  
>>  	return elf64_phdr_size(phdr_cnt);
>>  }
>> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
>> index 99eb8583d9321..116410ac90fb4 100644
>> --- a/arch/x86/kernel/crash.c
>> +++ b/arch/x86/kernel/crash.c
>> @@ -407,9 +407,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
>>  	unsigned int sz;
>>  
>>  	/* kernel_map, VMCOREINFO and maximum CPUs */
>> -	sz = 2 + num_possible_cpus();
>> -	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
>> -		sz += CONFIG_CRASH_MAX_MEMORY_RANGES;
>> +	sz = 2 + num_possible_cpus() + CONFIG_CRASH_MAX_MEMORY_RANGES;
>>  	sz *= sizeof(Elf64_Phdr);
>>  	return sz;
>>  }
>> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
>> index a97ed9605602f..e6251dfe451a8 100644
>> --- a/kernel/Kconfig.kexec
>> +++ b/kernel/Kconfig.kexec
>> @@ -160,7 +160,8 @@ config CRASH_HOTPLUG
>>  
>>  config CRASH_MAX_MEMORY_RANGES
>>  	int "Specify the maximum number of memory regions for the elfcorehdr"
>> -	default 8192
>> +	default 8192 if MEMORY_HOTPLUG
>> +	default 0 if !MEMORY_HOTPLUG
> 
> This only sets the default, but a user can change the value explicitly.

You're right. Let me drop this patch for now. Thanks for the review!

> 


