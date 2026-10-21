Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FB7606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BUHJKZWy
Received: by kanga.kvack.org (Postfix)
	id EF51B6B0696; Wed, 21 Oct 2026 05:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC386B0698; Wed, 21 Oct 2026 05:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1F66B0699; Wed, 21 Oct 2026 05:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBCB86B0696
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:49:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C624C04FF
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:49:00 +0000 (UTC)
X-FDA: 85346159640.25.EC0F570
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5BD15180008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:48:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BUHJKZWy;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792576138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qb8CCyZKDo3DU8wu9akhVT7quX2USeXAOK8NbuiE3KM=;
	b=MRDEsSlemRl5C49klqsDE0yT3/QEQxkk6RxTHOAjlqRCxM7CYGtqW6oA4mRWPrkHmTh+Ps
	bum5J+OgTfd/cnpszS0SHOkHuADnqfZLGYSD8+MMD+QHDk2JuK6/zxtIrRbu0Mv2tHdOtP
	ZNZ2v+l4PfzaIKf/WRiqNZY1l9JxdfU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BUHJKZWy;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792576138;
	b=W7cwwdZKELjx/tH3cDgHoCezfbsvhESrMe5MWOeZIfOsEkdMrExHeyOV29QhrFYgrJzbkF
	KeO5z/qKgBXJyJkLxpirq5P7iRz/c3Sy/wr0NkXlAylxFmQsBToceXNl+oWqqTzaKiUwFS
	bAdDRH3T9GuU3QzqiolFmGoE+f3c2xE=
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2e831901331so3017315ad.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792576137; x=1793180937; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qb8CCyZKDo3DU8wu9akhVT7quX2USeXAOK8NbuiE3KM=;
        b=BUHJKZWycxc0ax1xGgipQ+kkcx7UrhocsGNNMYWVKh0SwdH//nYT8j/EXEP+GBXtPz
         EjXkGMw/n9jEGVTSqx0VelMjhuLLqoooFeeLN+yXXAMP+5ub4xUGoelubj/HkdsZBT5s
         y0hQRatWFeqYDWLPTqPaJ2soaTqr3cDf2pDCaQxYCLF6r+u+jC4lJ0AicEWBXPNAyiiu
         esYkjrkK/Hns88KvMYkfJX2FAyNsLTS9QB9EQ+WAD4hRsHC9tVQojDWR37Hb4He7wbTD
         nig2i1p/FlmQPvrATSQAhIUUP0dWbPR0WWX7HfQILfjg78O4eGmj+mca6aHDOr+20W03
         SwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792576137; x=1793180937;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qb8CCyZKDo3DU8wu9akhVT7quX2USeXAOK8NbuiE3KM=;
        b=MvwZ+T8tjX8rJ6Jl7HcRBUOStKjZz4JgN0vOLKpPWX4hS9ypBgAq+8mqd4qbgMGtds
         9Ojr8vswcLhEkNnELEkroyXMBTNnByohG/vrfo2mJf9vi/I0Hi+zAbZpArtWruX/ZK9X
         3FQ8zURbvo28g9HnPPxPtFs22k1cLn2mc28X+/aGxkfM8ZxLT8nLxUBBYTNyOSIG3AZN
         VCEWgpK7trqQqx6HpKmiIGlu3ijmSCE6LX9Zq+2sexpXOB6T4cCAP0Pl9kDX+5KtW8ce
         WDI0SmiaFCmvFlhCW4vazX7wHI6LC5AixjnqgR1IlYzawDnleo+bBVNhEIj0hAxcBH36
         5UBg==
X-Forwarded-Encrypted: i=1; AKwUvBw7FIcXj0gg3kAlkvlSFiERMtEHeoKf8sNCo+E9RU5YDGUS/YP+hTxvcIdqpk+r3nZqPRlpswqo6w==@kvack.org
X-Gm-Message-State: AFq9FYLlrX9jZMNrKWhJxMbn2LtwmSIc6C848+/to9okwLofEtadZA3i
	rfKDoonYU2UH+yzoy/xJ97taN+CcelJQA0tlkcewQDAAd9Ul3kuqvcLx
X-Gm-Gg: AYBFou1EQMhcf+Yp9m5xDLLhRJaYxwT6j/2sZND9YiWTab2Iz/VKWoKs48kQa/KlNOm
	3RF/GLxsSVGZpKOFFXniCn0utqpdPRd+K606w19V2Wn0Zp7CBGEWf8r9s4AXNhoHmH2gpO+ttEd
	8X5C5EZ+cbCCTe2V6NXNdmKGZmY0iuiyLf6T7KMVgwOZd/x/SNQp4QLQOPIqRnvIjQaq1ygbFSr
	uKAp0wBqY7ffTkIMfsAv+gAm3C8hAxqs8Qm809C78p0VDeR/m7v2HAL1EOBu0g5oxahpAg8zHVE
	EdGjOy3VVbYJfA4tJ4enwx5V2sSRijygjxuBu3xC83/xsKrw9SnUgOl8o0UJyu8q8tPT08NDD/m
	zR1t4HCcJdHu2XhlOiRQH6q+xw9H86CJDjV5hwvsTzbPU8FIhmWG1jfSUl57rVARhJisIBbxd3f
	8CHjCD/MVoNzy+GFLhjRfVdMfwd5AWlslR7htbtOVJTqi3K2azJPQD8GKAVr/VVMkGJ2sS0rlUi
	qYOIBYItstq78IZNq39rLHG7IWmsFZGBZgCQrhnCCfKP5tgJzP2yoSsEaR/wAU=
X-Received: by 2002:a17:902:f60e:b0:2ea:192a:13b8 with SMTP id d9443c01a7336-2ea43a13e4fmr10496695ad.20.1792576137131;
        Wed, 21 Oct 2026 02:48:57 -0700 (PDT)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b486970sm8858055ad.62.2026.10.21.02.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 02:48:56 -0700 (PDT)
Message-ID: <a1665f9e-3116-47bc-974e-98dce408fa37@gmail.com>
Date: Wed, 21 Oct 2026 17:48:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/8] crash_core: serialize crash header preparation
 against hotplug
To: Jinjie Ruan <ruanjinjie@huawei.com>, robh@kernel.org,
 baoquan.he@linux.dev, rppt@kernel.org, m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 chenhuacai@kernel.org, kernel@xen0n.name, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, saravanak@kernel.org, akpm@linux-foundation.org,
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev,
 robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, iommu@lists.linux.dev
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <20261021083011.2170525-4-chenwandun1@gmail.com>
 <12e4e687-1ff0-41b2-bdf8-7f48b29e1f2f@huawei.com>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <12e4e687-1ff0-41b2-bdf8-7f48b29e1f2f@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5BD15180008
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: nd8hoiujy6hw4tzk5mrrthmw4gzz7xqi
X-HE-Tag: 1792576138-753947
X-HE-Meta: U2FsdGVkX18xloSib82MM/rRntM7Uufvp/L1SWnzL1vaUG19w5okESlzlLzi2WVfDfYiT6nMP3vXPhE+hvuG8PF/uFeHqiI2k/9q2fLRm55+/4mny4lMB4tDdPAfyYDnSdLUA7+Z3OTX5h6IP798T2VZfCMYXL52ocGvP1OoNVPCEcIirRtZ6slXpG37q0WDW2IetHmhrTcIlb2VS8JXgUI1ltgRxussHDeiFXascbyn0zOlpJwGev/qA2/iYyUj+7kysspYa4MhjNiAko8ihK7c0pZ0lJZ6GvSpCeJegJF9dygLP+ei2RG55f9jMpoNjAkyMHc2K1BRnoE/X1wmI9OvXGHNjAk+PwaKO/2X9uSzZ2dPzg8NqEpZXME8J45f86yoLRx9RyBeST+dSZRdXnIFBsDbd6pGGIANUxrudqP9fABnFIlRdypwrFwV781dkK0EKlGGy+vJY7PfG1ot2IeXy5VNucVb4Ww0hu2yzUE9OHOFXq9l2ebRQcAaH88XsIaGLDKPHEcSH0JHnIIL33sg/JRDxO8mMQC3YQi3cnfJogCLprrPN7UErac8hnLEV2VgkAGaMBCUb6+QO4PMVVu8rcqcLuFBfn+ezQ/934xWRRBFZfcHIx1BmrrLFs16Pr2VMsiMlVsq9ehArOJpgAfUt3L6DHxPBZ6ytUYvA2PnamCOPbgYVMZAmBjV+JriKNxk5odJ44Qk+KhKjKyjAzNH51zQIHGwhehMt8QNp+B3VzwP49EphdM+B1H8TLpBlq7ChyRTvWmy/Yn/T3gJnf8XCSl5AyNww2MjDLPnhRPKSBtOAAkRstdZRqaEqIDedA45e6wOI8FpOmFFjipVPyXaaWoHFeMQLVdOWYlO2/lK758zqpQMXHvgKJwQabZVQykMNgccEgySBLgQeE4fDXJWSxss10iccDtZKUAMkKTHNvcGPpAv1RLWz4Q8LmcLI5BGUAH9OHB0xTFCoFc
 a0GXFQuN
 gqB46A6XwV6aw2PHxjtuaTwupNxDYBm4x8YpYvYWmXp/ZwJ4uoz21Kq15T51o2TdYa5EuyWXZ+dgF4EnZRLaGgfahC8SAae/uscfdVXy7a4Hs3MxifxWLtm3DyH7sTU0AgdS9kqoticrSJDqJf1P/5yF3JJHaBp/ebfbejC505vAXy4Kjvb/JXpnDwACj4TzuE6KLiHpr9WCRPi8mYY583+lLTUc2Hc5ypmXy3//TnLPVTO/2R+gGArjpFczDOMs+FS3MNVzHdw7NBL6TtzTplfIMmFgCrziInkKchmooaXONmDU7ZjWs4HK2oMXj1rhT5gIpXAeu4keSh+zDG854AvuGLCBg/k1MyaS3v9PTlAOMKmySeoE4DaMyUpy0MJwGKwACfJXsSDESwaIRu8HYjPrO5Gr58K4C6EEx364+/RbtisP0HICO8um25zvhRP99pHOe4NvUrXepx5YG3ehaDq1avKMxCrHG3j77mhfkRTFh6NPSlwj4C3jGvOnY7syllhr7qjsmFA2eGFBCoayIqfRW1iTTU3EDBSlP/TyJ3I+GZFGkTRrscpBdL7oEaj9mbgqWQ6cyci8qyyTI5yCu3p/y8GFX2epefzcgMQdNc+BELZabCxbHtzfb0rrbNZOD5658
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/21/26 17:13, Jinjie Ruan wrote:
> 
> 
> 在 2026/10/21 16:30, Wandun Chen 写道:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> crash_prepare_headers() counts memory ranges before populating the
>> allocated crash_mem array. The weak implementation used by ARM64,
>> RISC-V and LoongArch walks memblock.memory, while x86 performs the same
>> two-pass operation over system RAM resources. Concurrent memory hotplug
>> can change range source between the two walks and make the populate
>> pass overflow cmem->ranges.
>>
>> Take device_hotplug_lock when preparing crash headers during
>> kexec_file_load(). The x86/riscv memory hotplug path already takes
>> device_hotplug_lock, so call __crash_prepare_headers() directly
>> to avoid recursive locking.
>>
>> Sashiko reported this issue in [1].
>>
>> Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
>> Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
>> Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
>> Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> Link: https://sashiko.dev/#/message/20260806101002.1F84E1F000E9@smtp.kernel.org [1]
>> Acked-by: Baoquan He <baoquan.he@linux.dev>
>> ---
>>  arch/riscv/kernel/crash.c  |  2 +-
>>  arch/x86/kernel/crash.c    |  2 +-
>>  include/linux/crash_core.h |  2 ++
>>  kernel/crash_core.c        | 17 +++++++++++++++--
>>  4 files changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/riscv/kernel/crash.c b/arch/riscv/kernel/crash.c
>> index fe5a4b306aae..ac8df2edf2a7 100644
>> --- a/arch/riscv/kernel/crash.c
>> +++ b/arch/riscv/kernel/crash.c
>> @@ -70,7 +70,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>>  	 * Create the new elfcorehdr reflecting the changes to CPU and/or
>>  	 * memory resources.
>>  	 */
>> -	if (crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
>> +	if (__crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
>>  		pr_err("unable to create new elfcorehdr");
>>  		goto out;
>>  	}
>> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
>> index e6f23933a6df..bef008a0cb22 100644
>> --- a/arch/x86/kernel/crash.c
>> +++ b/arch/x86/kernel/crash.c
>> @@ -465,7 +465,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>>  	 * Create the new elfcorehdr reflecting the changes to CPU and/or
>>  	 * memory resources.
>>  	 */
>> -	if (crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
>> +	if (__crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
>>  		pr_err("unable to create new elfcorehdr");
>>  		goto out;
>>  	}
>> diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
>> index bc087124cd78..28e7a81cf263 100644
>> --- a/include/linux/crash_core.h
>> +++ b/include/linux/crash_core.h
>> @@ -61,6 +61,8 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
>>  				       void **addr, unsigned long *sz);
>>  extern int crash_prepare_headers(int need_kernel_map, void **addr,
>>  				 unsigned long *sz, unsigned long *nr_mem_ranges);
>> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>> +			    unsigned long *nr_mem_ranges);
>>  extern int crash_exclude_core_ranges(struct crash_mem **cmem);
>>  
>>  struct kimage;
>> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
>> index faa0f22dbb41..8a861a946e26 100644
>> --- a/kernel/crash_core.c
>> +++ b/kernel/crash_core.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/mm.h>
>>  #include <linux/cpuhotplug.h>
>>  #include <linux/memblock.h>
>> +#include <linux/device.h>
>>  #include <linux/kmemleak.h>
>>  #include <linux/crash_core.h>
>>  #include <linux/reboot.h>
>> @@ -344,8 +345,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
>>  	return 0;
>>  }
>>  
>> -int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>> -			  unsigned long *nr_mem_ranges)
>> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>> +			    unsigned long *nr_mem_ranges)
>>  {
>>  	unsigned int max_nr_ranges;
>>  	struct crash_mem *cmem;
>> @@ -382,6 +383,18 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>  	return ret;
>>  }
>>  
>> +int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>> +			  unsigned long *nr_mem_ranges)
>> +{
>> +	int ret;
>> +
>> +	lock_device_hotplug();
>> +	ret = __crash_prepare_headers(need_kernel_map, addr, sz, nr_mem_ranges);
>> +	unlock_device_hotplug();
> 
> I think this patch conflicts with my changes and would also conflict
> with the implementation of arm64 crash hotplug.
> 
> https://lore.kernel.org/all/20260921090450.807575-15-ruanjinjie@huawei.com/
> 
Have these patches already been merged? My current work is based on the latest
linux-next. If they have already been merged into the maintainer's branch,
please let me know, I will update my tree and rebase/re-adapt my changes accordingly.


Also, regarding the changes in kernel/crash_core.c: it looks like we modified
the same spot, the change is not wrong, is that right?

> arm64 crash hotplug:
> https://lore.kernel.org/all/20260918100442.3841135-18-ruanjinjie@huawei.com/

In addition, if arm64 gains crash hotplug support, the code there would indeed
need to be modified (to avoid a deadlock). As of now, arm64 crash hotplug
support has not been merged yet either, has it? I just want to make sure I
haven't missed anything.

> 
>> +
>> +	return ret;
>> +}
>> +
>>  /**
>>   * crash_exclude_mem_range - exclude a mem range for existing ranges
>>   * @mem: mem->range contains an array of ranges sorted in ascending order
> 


