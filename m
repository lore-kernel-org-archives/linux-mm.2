Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 373C4C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0E86B00A5; Wed,  2 Sep 2026 06:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0720A6B00A6; Wed,  2 Sep 2026 06:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA206B00A7; Wed,  2 Sep 2026 06:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C98546B00A5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:01:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73023A139E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:01:28 +0000 (UTC)
X-FDA: 85168379856.26.D44052A
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf24.hostedemail.com (Postfix) with ESMTP id A5B73180016
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:01:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1OKXC1Wl;
	spf=pass (imf24.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788343286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5muCGImxQEXCs9mgbU84wjK603R7oDB3KGXYhDYZoIc=;
	b=a89IbkwUlSrU+eeTCGfCyIX4+e/FWABa2L4mmGAx/bdNjLxV+ILuCkcD6xznjR3i9dKh3I
	JIR+5FecKB0tp1WKlm1RUzVfMljwwtNMiJ+DTFvEfTF27TyN7XHZOay3bA87RcL4936LEH
	LQFGTlTIqlgYtxjo66e7Uq9kge6AY7Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788343286;
	b=tqT6lVbg3edqu1rMKEKQ9hEqZbk57+tyPkHvBPV0AZshuH6+RCarPsLny3QRf0XegdKCfS
	5mNDKKv0VG/RSzCRB8fwZe6uEw+Ct4nozO52FQfb/vSbYKDJsdO3WSYjLoyv8o2XvRnOLc
	UElEf/VVU9rzPetwMrbBpqnr+y5qftE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1OKXC1Wl;
	spf=pass (imf24.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5muCGImxQEXCs9mgbU84wjK603R7oDB3KGXYhDYZoIc=;
	b=1OKXC1WlAcuXvATuYy9843J+ts23aqDRPtEBmymokcm2wcDFN7n+VLXs5YlFtuuOI17YRGOle
	AE1kaDyBL8Psb6qsvqP6GD+2KaR9IZFlJSaA9VKKZKh4vJ8pLjxN4lSw5BvQVM6ddEVaTK1WC49
	5AuTsqZ1V1GNz92YBNN1IQA=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hZdHw4T64znTwN;
	Wed,  2 Sep 2026 17:50:04 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id C74E54057A;
	Wed,  2 Sep 2026 18:01:17 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 2 Sep 2026 18:01:15 +0800
Message-ID: <d12302b0-f0b3-4df6-963c-bf25b6e720c7@huawei.com>
Date: Wed, 2 Sep 2026 18:01:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/17] x86/crash: Use num_possible_cpus() for
 elfcorehdr size
To: Sourabh Jain <sourabhjain@linux.ibm.com>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <chenhuacai@kernel.org>,
	<kernel@xen0n.name>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<gshan@redhat.com>, <jic23@kernel.org>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<coxu@redhat.com>, <tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>,
	<adityag@linux.ibm.com>, <ionut.nechita@windriver.com>,
	<liaoyuanhong@vivo.com>, <seanjc@google.com>, <fuqiang.wang@easystack.cn>,
	<makb@juniper.net>, <piliu@redhat.com>, <ebiggers@kernel.org>,
	<jbouron@amazon.com>, <mclapinski@google.com>, <me@linux.beauty>,
	<graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-13-ruanjinjie@huawei.com>
 <99b1121d-4277-4764-8c3a-b3f6d9a47ab0@linux.ibm.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <99b1121d-4277-4764-8c3a-b3f6d9a47ab0@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A5B73180016
X-Stat-Signature: wikorj5dpegxoci4c7fepq7qoy4kbod4
X-HE-Tag: 1788343284-252691
X-HE-Meta: U2FsdGVkX18BRQZVIz3AkKYaAJ6HsmM6OUPWpxjX2ZvFSEFLNWbiIyGkY8sqGhLfau/XE9Pn8L4JQXlUV4U7BsreoubYQmXlECaGaJfoiPukC4WWFn2EprRXuyN8KGvO8DtxzDlrq+hvlLla3LLK0q9XuyMvy8USlepu7EXgfBD7oXj04l/R3PTmzK/79ef/j5r0WIX+VwPYj/Ctvm4SaR8QnWHZ6dMiIllreIG70dXhlFN1gkVZoH3SzJ/uBf/sYJ+kQ2Zf/kBhhiJwCghjAC5hgeNsJ4uk/5LJtv7UXCZ9ieBbJ2hiNyRWAafdK+yUjrCRO2pNVeAZ0IDpvObOSUFmn+uxi+Dzv5uL/OGuaC7DvytGx8qTrsL5d2A/UGkWOjbgbgssS8n+d3VVBPMtXG4+DwMyZB5hY+DVX22ZzPh7EEmnrEcOYakQKlAqBc+6ftG25sLBW8MpSUbfx6hB4SVIC961Ov/fNl+unYmbRrWGN2nX4Eil6qmKI5sl+QX967HAHlD+R4C41O2HMo6Th4bR+PXZD0LSurfcoKzPgg9HKYSlEt6TCcWZ9qmLxa4jskVesZ4b/QKE0AF7akAFqIpt3k9oeCq7SCHa5Wu5myhYadjolMLUE3Ml0OC+Ao2QV2IrQPIDO4hGAQFaGYEiNNzeh2JnCEX9Aakc+mhwzwoRQLlXI6Ez0Rk6Dv61Q12ZIxvUPeJfoDF4fu9E0pFpioC5H1YrD2HsbvoWHzxLi2cNGpqqBJ66lc0alfgxcYlJO/CibiGfMsNtnis5vp7tSkxyq21uWGmstkIgwy0yVtVSkEs/ZN27mMg/7e1IrHTePhPibvLL6RGo1H/Koev64ehx01FfM2jQUcyTfYqsM0Zwr+yRMKnfJCvUlVFbR3eQRki2JN0YxbItLmAkGUoxuOtsgMBA5tBA3lepzeUbxjRhy6LgfFYAdszEKbk71od58iG55Orma0WvE+OCbAk
 3VUU3mCC
 Sx1Qk2fZ3lgL3Cd87BiiNV9t9i2fCyCJW3ACbEdFonQGRShfGqElaCJVAcrDeXDWXNMsG7G2xlDH38enTzjf3Zr9GfRdVIu7z9aiEDQ/1dQiAxb5thjKXBHP172rY9AoxuAhJIIo65qWf0QSDxibXHdHxk0VkzsUXIdaiib6R8iTl7OalxhOudbjqlrbbKFxHi2zRjS5PbJ67JAcYlmAe+jSUDOZh2K2KdH4A6tjGlKZdtFO84qjMvQwRJmIgO0epubDeOD5SwNN/Q2h3NIe2RTH4D6lm1eskOEHRzBeF0JVoXKqZGZ1M663w1NT3m0FOhtIPtyGsJ4llQrFAPlXc6Yck2IDaUR83WUTcHefz3X0omxYO0uAHaTgBcfsLMRsErFJCSPHzzusRRqPMIdxr7gdPPREW3ycontPKic+Nx8+GvzblVf3iU+3nA1pW/IYSz8ujWOYsEovsaU2omeNU0+GXlxO+Unb8OCXrTZHLvZVCrEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/2 14:14, Sourabh Jain 写道:
> Hello Jinjie,
> 
> This patch makes the below patch redundant..
> https://lore.kernel.org/all/20260826073527.21487-2-
> ionut.nechita@windriver.com/
> 
> I suggest dropping the first patch from the above series and including
> the second patch from that series in this patch series with the updated
> comment.

Agreed. This approach makes sense to me.

I will update it in v4.

> 
> - Sourabh Jain
> 
> 
> On 26/08/26 14:55, Jinjie Ruan wrote:
>> Use num_possible_cpus() instead of CONFIG_NR_CPUS to calculate the
>> elfcorehdr buffer size, matching what crash_prepare_elf64_headers()
>> already uses for the actual header content.
>>
>> This avoids over-allocation when the system has fewer possible CPUs
>> than the compile-time limit, and aligns x86 with PowerPC.
>>
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>> ---
>>   arch/x86/kernel/crash.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
>> index a3bf786286d4..afe2aea19f47 100644
>> --- a/arch/x86/kernel/crash.c
>> +++ b/arch/x86/kernel/crash.c
>> @@ -369,9 +369,9 @@ int crash_load_segments(struct kimage *image)
>>        * maximum CPUs and maximum memory ranges.
>>        */
>>       if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
>> -        pnum = 2 + CONFIG_NR_CPUS + CONFIG_CRASH_MAX_MEMORY_RANGES;
>> +        pnum = 2 + num_possible_cpus() + CONFIG_CRASH_MAX_MEMORY_RANGES;
>>       else
>> -        pnum += 2 + CONFIG_NR_CPUS;
>> +        pnum += 2 + num_possible_cpus();
>>         if (pnum < (unsigned long)PN_XNUM) {
>>           kbuf.memsz = elf64_phdr_size(pnum);
>> @@ -429,7 +429,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
>>       unsigned int sz;
>>         /* kernel_map, VMCOREINFO and maximum CPUs */
>> -    sz = 2 + CONFIG_NR_CPUS;
>> +    sz = 2 + num_possible_cpus();
>>       if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
>>           sz += CONFIG_CRASH_MAX_MEMORY_RANGES;
>>       sz *= sizeof(Elf64_Phdr);
> 


