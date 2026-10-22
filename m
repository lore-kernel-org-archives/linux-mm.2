Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB722606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Q+4ivRAN
Received: by kanga.kvack.org (Postfix)
	id D8DF56B0832; Wed, 21 Oct 2026 22:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3C456B0834; Wed, 21 Oct 2026 22:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51BA6B0835; Wed, 21 Oct 2026 22:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92EC46B0832
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:01:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D79AA79A5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:01:09 +0000 (UTC)
X-FDA: 85348609458.09.22F5F55
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C3E918000F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:01:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Q+4ivRAN;
	spf=pass (imf16.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=loBgwUbLOnAAak0q9uGjIQKEwQ4a4j4TVh8P+20MXEg=;
	b=VvPFou5+/YIwsWVapXhF1Kk9NpcLEvu9rbvEHoY5sEI//+qU3uVC+hn7ce6y8XfYC7D2vK
	uMlAE5qSOBcHx1VRrRp+3NYtiP+SwuJZkxuuMrqJpL+HVZ5VWrHf8nRbYDg5h7M5gY9eWi
	DY0ez/YJBWG1bPHUMqxXhao3t3+C8ts=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634467;
	b=SPLWK+nWuchXqxNYmZMpVZytAS8/9b0T0KHOE8b9YhG0w9RGrsxRotTdyXJKw/xHTNAYtC
	DA5xF9Ustk2ftuOjAjzR6IEOpNC43wDf9yph+vxJwGlQTAOXyJbRo5ONKgjKDlWHJsadqW
	lN7uvnNX4TeSqZ602X/tbNfzGvxMvp0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Q+4ivRAN;
	spf=pass (imf16.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=loBgwUbLOnAAak0q9uGjIQKEwQ4a4j4TVh8P+20MXEg=;
	b=Q+4ivRANcgbbFZT+RuqnOmzfQRgx/LVfmZmJnBznw3aijzTfLqiAXmQFPpHZ4wQr5N/a+UnSk
	9QkwZygXGFsy6k2d0kw287r6cGCOPL2MK5xfPM3ACXVTWwq6O1+K0stbkZqxhIDb9q0MkhN+DRw
	UTGHL86gM/CDOpMtrrbG38U=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4j98WL5Vhfz1K972;
	Thu, 22 Oct 2026 10:00:46 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 2FEAB40563;
	Thu, 22 Oct 2026 10:00:51 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 22 Oct
 2026 10:00:49 +0800
Message-ID: <31d63208-3ef2-420f-a0c2-d9d6d49c5e21@huawei.com>
Date: Thu, 22 Oct 2026 10:00:49 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/8] crash_core: serialize crash header preparation
 against hotplug
To: Wandun <chenwandun1@gmail.com>, <robh@kernel.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <m.szyprowski@samsung.com>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<saravanak@kernel.org>, <akpm@linux-foundation.org>,
	<pasha.tatashin@soleen.com>, <pratyush@kernel.org>, <ruirui.yang@linux.dev>,
	<robin.murphy@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-riscv@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>, <iommu@lists.linux.dev>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <20261021083011.2170525-4-chenwandun1@gmail.com>
 <12e4e687-1ff0-41b2-bdf8-7f48b29e1f2f@huawei.com>
 <a1665f9e-3116-47bc-974e-98dce408fa37@gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <a1665f9e-3116-47bc-974e-98dce408fa37@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C3E918000F
X-Stat-Signature: ijorraqpxsyces4tj96bwnumaprc8dcj
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792634464-130782
X-HE-Meta: U2FsdGVkX19ykxZes2p3zvok4hO10AYEYgy74m3HGf3k4R9OJoieHBt62SOb4o2QZK4/ciZVfZhJrmrNCcKGd5hl466jslwAaSXOgEcUHNOkMhiJpY1crSXk2HOeW7AARx+Lu081wPJNNJvorZNedUbuSa27gVGibbuWv9XM1UE9X0zvI0yqqVnDjP4jr1jKkNiUzBw3FE2yASXH3f1wR4H7TUl+vEb76S8gYppJOlzlsEyUO9q9CYJN+Wbslc0pRNsL+Yjo6HfkbyAnRMcrxWhXH1aBWRLGdJvOzE2zs/VbmBdgKTc7TIrJeaMk3GYXHCd3iGXrRGCAICzlBMDmGya/0yOToXztWgMCJRJRXuGHIeGe2F2KdUh9k/phpTlrUytucUkAswLCAEG4r6jJxRzSNUYUXEUAusn2a10S/uiClaUfg7YQHLNoXwSAvQSAqWPv0tJ4nPvrepFP6qOiZpNDmVkaFw0mfkDZWsREO10B5hLKVgSXPCQBahcjZm7G/XcE50Y4P2p/f2agiyyEyfSRbDqSaYf1+3Ivu3BLQeaa8DC7b7pMFsI5I9eV7AlxfVeepQvkPCzcaXCO5NAl2hR55i/nJOQXW4Rr+KcNRrYtwumVQ1RuNtt8bStH7bFyjodLwaG10aZ+cQeP1PGE4z2bzMghigUfDoEI7ggORFiTDwhnD43urj//R0Zc6YCcBEOz67aJC/kJSZrT7CRE81v/5EbYURGIPScFS+hUzILY6aEeudbv9KfKRxJHiz20KOTAU6BogYdk/QIRH9crEPXRPOLFhnfjpp5SaNIERaoM8gdeNHoA1eJ9MwlAbqM82piw7BV1QdaMcp5b9L/amkhQFYHMzuuj5UB1/+V3SQf9iV+io72CgZ00jSxmEWLadt9THY0Iu8giETIywQGTS8TraLezPERWHmQElA2gBIDnyyjeL1ldJr2AUMrQCaUmTZZcmBhE64v9GpFAGt1
 OumusaEl
 ipLx89VWGd6/Y8MHRoahbj/E8ScvfeaWgCsHPh/gqbX+Xit03640B3cbcsec7iFL8wACVcZkfDRSQs03U93Tsx6q5mLgAYoUo87S2ZFXpNsRQqQWTUIOJ/WZ3irV9kOvXxBqwazGz4p+s1nLWQi9WuORCBop5wXM04R20qrW+/T5eIHGa4pkEPViFZdhZlGYVv8YqLhYRM5GIHy+nG3Ms/I+PpJ2+umW00qMO/tTC5abE2fTFBq26qX5hTmvOTKtwE36MhkOZ8lnKu+mJxaYxc4dfB59tzbMTHHj1wN+nVWZhu5Ytb/NQcPQEbDLj4Oxk9t4EKG82yM5tYUVNfB5aa4BkhvOiH3snJjb/BIE56K+8Hkdws+KMm6ers6Lpf+e9Kz+U/5wvXGsG5PWRjJNtB32n/53wirUpS2Ny/T4+ZCGfovFnHZOiWAC5exy7WIPTdSyAaE1vPPr6zbTqh1fbB1RE+7RLdNZdaDz1A7MiWHEQ1+vr1n1Y+wuDmYStXhhQGNO+Yp4ZMlkNJYBCFGur2vuhYquOqB2R0Z7TlAYSlWhzLF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/21 17:48, Wandun 写道:
> 
> 
> On 10/21/26 17:13, Jinjie Ruan wrote:
>>
>>
>> 在 2026/10/21 16:30, Wandun Chen 写道:
>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>
>>> crash_prepare_headers() counts memory ranges before populating the
>>> allocated crash_mem array. The weak implementation used by ARM64,
>>> RISC-V and LoongArch walks memblock.memory, while x86 performs the same
>>> two-pass operation over system RAM resources. Concurrent memory hotplug
>>> can change range source between the two walks and make the populate
>>> pass overflow cmem->ranges.
>>>
>>> Take device_hotplug_lock when preparing crash headers during
>>> kexec_file_load(). The x86/riscv memory hotplug path already takes
>>> device_hotplug_lock, so call __crash_prepare_headers() directly
>>> to avoid recursive locking.
>>>
>>> Sashiko reported this issue in [1].
>>>
>>> Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
>>> Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
>>> Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
>>> Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
>>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>>> Link: https://sashiko.dev/#/message/20260806101002.1F84E1F000E9@smtp.kernel.org [1]
>>> Acked-by: Baoquan He <baoquan.he@linux.dev>
>>> ---
>>>  arch/riscv/kernel/crash.c  |  2 +-
>>>  arch/x86/kernel/crash.c    |  2 +-
>>>  include/linux/crash_core.h |  2 ++
>>>  kernel/crash_core.c        | 17 +++++++++++++++--
>>>  4 files changed, 19 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/riscv/kernel/crash.c b/arch/riscv/kernel/crash.c
>>> index fe5a4b306aae..ac8df2edf2a7 100644
>>> --- a/arch/riscv/kernel/crash.c
>>> +++ b/arch/riscv/kernel/crash.c
>>> @@ -70,7 +70,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>>>  	 * Create the new elfcorehdr reflecting the changes to CPU and/or
>>>  	 * memory resources.
>>>  	 */
>>> -	if (crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
>>> +	if (__crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
>>>  		pr_err("unable to create new elfcorehdr");
>>>  		goto out;
>>>  	}
>>> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
>>> index e6f23933a6df..bef008a0cb22 100644
>>> --- a/arch/x86/kernel/crash.c
>>> +++ b/arch/x86/kernel/crash.c
>>> @@ -465,7 +465,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>>>  	 * Create the new elfcorehdr reflecting the changes to CPU and/or
>>>  	 * memory resources.
>>>  	 */
>>> -	if (crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
>>> +	if (__crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
>>>  		pr_err("unable to create new elfcorehdr");
>>>  		goto out;
>>>  	}
>>> diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
>>> index bc087124cd78..28e7a81cf263 100644
>>> --- a/include/linux/crash_core.h
>>> +++ b/include/linux/crash_core.h
>>> @@ -61,6 +61,8 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
>>>  				       void **addr, unsigned long *sz);
>>>  extern int crash_prepare_headers(int need_kernel_map, void **addr,
>>>  				 unsigned long *sz, unsigned long *nr_mem_ranges);
>>> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>> +			    unsigned long *nr_mem_ranges);
>>>  extern int crash_exclude_core_ranges(struct crash_mem **cmem);
>>>  
>>>  struct kimage;
>>> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
>>> index faa0f22dbb41..8a861a946e26 100644
>>> --- a/kernel/crash_core.c
>>> +++ b/kernel/crash_core.c
>>> @@ -16,6 +16,7 @@
>>>  #include <linux/mm.h>
>>>  #include <linux/cpuhotplug.h>
>>>  #include <linux/memblock.h>
>>> +#include <linux/device.h>
>>>  #include <linux/kmemleak.h>
>>>  #include <linux/crash_core.h>
>>>  #include <linux/reboot.h>
>>> @@ -344,8 +345,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
>>>  	return 0;
>>>  }
>>>  
>>> -int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>> -			  unsigned long *nr_mem_ranges)
>>> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>> +			    unsigned long *nr_mem_ranges)
>>>  {
>>>  	unsigned int max_nr_ranges;
>>>  	struct crash_mem *cmem;
>>> @@ -382,6 +383,18 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>>  	return ret;
>>>  }
>>>  
>>> +int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>> +			  unsigned long *nr_mem_ranges)
>>> +{
>>> +	int ret;
>>> +
>>> +	lock_device_hotplug();
>>> +	ret = __crash_prepare_headers(need_kernel_map, addr, sz, nr_mem_ranges);
>>> +	unlock_device_hotplug();
>>
>> I think this patch conflicts with my changes and would also conflict
>> with the implementation of arm64 crash hotplug.
>>
>> https://lore.kernel.org/all/20260921090450.807575-15-ruanjinjie@huawei.com/
>>
> Have these patches already been merged? My current work is based on the latest
> linux-next. If they have already been merged into the maintainer's branch,
> please let me know, I will update my tree and rebase/re-adapt my changes accordingly.
> 
> 
> Also, regarding the changes in kernel/crash_core.c: it looks like we modified
> the same spot, the change is not wrong, is that right?

Hi Wandun,

However, I think someone should have informed me in advance; otherwise,
doing duplicate fix work is pointless.

I see that part of your patch series modifies code I previously changed,
but I was not CC'd.

> 
>> arm64 crash hotplug:
>> https://lore.kernel.org/all/20260918100442.3841135-18-ruanjinjie@huawei.com/
> 
> In addition, if arm64 gains crash hotplug support, the code there would indeed
> need to be modified (to avoid a deadlock). As of now, arm64 crash hotplug
> support has not been merged yet either, has it? I just want to make sure I
> haven't missed anything.

Yes, you are right. If your patch series will be merged soon, I will
develop based on it.

> 
>>
>>> +
>>> +	return ret;
>>> +}
>>> +
>>>  /**
>>>   * crash_exclude_mem_range - exclude a mem range for existing ranges
>>>   * @mem: mem->range contains an array of ranges sorted in ascending order
>>
> 

-- 
Best regards,
Jinjie


