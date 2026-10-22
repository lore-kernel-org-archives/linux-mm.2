Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A0AC606A337
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 07:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PIlxxGHv
Received: by kanga.kvack.org (Postfix)
	id 0F3E26B02AF; Thu, 22 Oct 2026 03:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DAC6B02B4; Thu, 22 Oct 2026 03:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67226B02B7; Thu, 22 Oct 2026 03:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B65FB6B02AF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:45:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 311611C3B54
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:45:11 +0000 (UTC)
X-FDA: 85349476422.11.B56DB39
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf09.hostedemail.com (Postfix) with ESMTP id 40BDC14000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:45:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PIlxxGHv;
	spf=pass (imf09.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792655109;
	b=4uA2y/tSrCGkQmMH04g3oaZkIS8mlnHQVHEosZS/aVZIrta2qzuvmqAaTIYn2jfHFwFbho
	m19c+Q/LocJOkSlWh8mJBAbNYySrwS6DP2ncIDIhobnsSp1KdhlEIyjI7QdIpqftXP2IyP
	/cPYXwAXy0jYKA/bp3Djt519J8e3d+w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PIlxxGHv;
	spf=pass (imf09.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792655109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HDXHwat4zLpbZennBEg7uZauJYVMECCPqpPno/TLnRE=;
	b=TfosYm8toYybVzgcskiW7eoof/flyT/4cj6XDnO1RwiDQe2LBT5aFGmvziHUtvuFFp3tVq
	fK3+DjIA6s+qaZcMy6WeRhwCECEkODZr6im0q1dWCztVSTETjPLVh4iP0CYabqB6v8Ri8G
	oSR3ISbsoE0PTI0zYUyDRYpiPbHYY5U=
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-3ac144119e4so751860a91.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792655108; x=1793259908; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HDXHwat4zLpbZennBEg7uZauJYVMECCPqpPno/TLnRE=;
        b=PIlxxGHvSV2xdr9pCTz6s6fcLgAC1p1GMjur2TLN3gW7KfbFvG8qD3r1OPid7oS0sa
         B3jYqPWqylkns7oe9uPbUe4FvfbANZBjs2/Qf4UzrhKrrYph54RXNbGEGOEx3b9P1ds7
         2wPheZFZJYJMBerlSoHJ557iNvmqr0i18HmHR+rjYAwPndxvhie3Rnj9ouXUO+U/+rke
         uzAFRiqdYLg0uuiG3R1G4GiRFRLqZS7DDg8D4pZOdnitxYne3hmwQ69z3udwewxHLGQ5
         v4BG5mK5gUDhWi8li6bYtVbU6kb+XJ8CbaNmzKcbhN3Bmcjiipw7awJF28QmmL3f+WSe
         tIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792655108; x=1793259908;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HDXHwat4zLpbZennBEg7uZauJYVMECCPqpPno/TLnRE=;
        b=ziiQvrrQcXttWQv7oRrNlr7eo/kUlV88lDdOs9PEArdYpNowEV6E/KSnJznIKUuzNB
         LxddRiB9dDuPb3SYYVR7kmMCy5Bw2XO1aSGYs8PpNQZ0g+y1pHLQbae+bVdgPOTwDfL1
         KrY4hp5mB0XabptA9+0c8/7lc5iIVVROoY5herxchhVeITL5/eZ+Bhh/4mP/AfrW2EVy
         kjREc2TvuAujTFPcTK7tIPlDIbaoaqm5gYPiFkZBSDp56XQkrcde3ol8KhBd1OCiQMOF
         WdwCK+2AAQHNdklw9crQS9cBgAxjGkl/rvogCr/+5awqq2UW1ZvrG3IXAMYhE8L4sSY+
         oq/w==
X-Forwarded-Encrypted: i=1; AKwUvBzJz1+ioxwZWkz1Qa2H2DzeYvTyvnDRkNtZJt4UnQuaToDJteivQDxw/nXpoQ2/LUV8qlOe1JgQFA==@kvack.org
X-Gm-Message-State: AFq9FYIJd0yXLRwMO5GBQ9FetyKb+PnRJtlXPA4NwDPYrLidVbyDw241
	GapU+D4ZpHfldC1KwSpC5X04nrIQyc1Nd71lqo0EhJZgX8dkQQU7254C
X-Gm-Gg: AYBFou1ILJH4zhm40QFIw9pfl8NZqzLfVTwE9KaSEYvn2IrKM9Jzg0DNZH3ZM2xmjea
	4klXtCl3S6h1tpxd8e78O+/UKi4OVhokAHI8/tPvSlJJ5t9uOvh8wwafiD2at28yWMU4tA/89dy
	Ceime8q4eka5Ulq2NQWXQ2lqfvqBKjt1uUu3qIlgQmwEzqNwjOfxpPXv2vywtjVRIcfqejCOnu5
	9Yep7nDMXagoovJR6xqkNjvxhaxP5/tMq8DIOTjac52a7PMFtz3Gam1mB3tdqvSbbpnIpbfkcre
	aAo99wjAX/YUBrlG8sOmrl9VZWdb6v2jlM96N+NWXTPKtLZcDHbngim3ZYXY9xull+lZOweslCr
	LoCaaoOCKgi1jJ8Ow3WJHEKfvnOiBVmiM9T3CJp4tAuuFY/ej8pB8dn1Njsz+If5N2rDRW387l0
	hVB/ZZuMHJmW9NNnJuYzXki4SX8VWzgXVuvqERm9RJF/aieTUwmRHYKX16iPJSikdIFqCMmOclX
	Jw1ep07I84Dg9dDwS4aIxUQw2BuXYPaABTRLI3eeSStgbdiNN1r7Axtnr+67f4=
X-Received: by 2002:a17:90b:5870:b0:3ab:5758:3766 with SMTP id 98e67ed59e1d1-3ad8707700dmr3724932a91.51.1792655107849;
        Thu, 22 Oct 2026 00:45:07 -0700 (PDT)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada49366fdsm2945920a91.14.2026.10.22.00.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 00:45:06 -0700 (PDT)
Message-ID: <098ff899-81b9-4ccc-a143-1e324446258f@gmail.com>
Date: Thu, 22 Oct 2026 15:44:48 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/8] crash_core: serialize crash header preparation
 against hotplug
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 chenhuacai@kernel.org, kernel@xen0n.name, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, saravanak@kernel.org, akpm@linux-foundation.org,
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev,
 robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, iommu@lists.linux.dev,
 robh@kernel.org, baoquan.he@linux.dev, rppt@kernel.org,
 m.szyprowski@samsung.com
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <20261021083011.2170525-4-chenwandun1@gmail.com>
 <12e4e687-1ff0-41b2-bdf8-7f48b29e1f2f@huawei.com>
 <a1665f9e-3116-47bc-974e-98dce408fa37@gmail.com>
 <31d63208-3ef2-420f-a0c2-d9d6d49c5e21@huawei.com>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <31d63208-3ef2-420f-a0c2-d9d6d49c5e21@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ygkw3jeru83gqju5wizh7pn3zhpqmuk7
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40BDC14000C
X-Rspam-User: 
X-HE-Tag: 1792655109-327400
X-HE-Meta: U2FsdGVkX1/T9I7FQz6f2s293KLqksF3trwd1ZKeN0pbAnH9dxRpmz50WMmaY696XZZ2DsEWyYCgWC7njuEDzWOGOJHbfeg8MdttjV3G6PXEqwlFXOwONb+4YdUAoFwmiIFCMtjhdAeyPRUsN/sMcNaC/5QJDYMTIk3uP3BRSw19QuuYff4I2HA/YdN8d2H6oqtEgZaRpa6dnGv3Z8SEZ/T8BhqqcCSnWfWLjGL03hBfYZPhP8WDYI+tij1Qy1AJqLCtGpoAwZvBI6dGY1WQF0nGYOeG6c6rk6vhWE5hjpS7N+wgZtwfsj7KBViGiycm7kgppZNm4aIdiJpr82WGx4L5djlDB4PBsu88QuxTJ2azFCybS5tXW7y44V6MB2lGFHRxbY9fYzlOIfEhpc2r1PosA+HcnmZzcfl4tuT/bPqFObvFqugmJlP+gwnXxAqm5/Fqg408+82QIsc9hfmLaldulG2TrjmMnueNrZpuaLchgLkMk6sXvsiIDUoztzukNKyFt7UPxeOykfUQK6EIOxtWkLj0BIbbePIONrmzMVg/dzm/uP1XxhTOU2O9eiaXIrM8EhI/GcIOjG27CS2xxasrbyDEfueC7YtrncrupcT9/hpf9u6pGwlvMAtYVOAohVEWjOe+T9DdAtK8ZqDfPznSo73lB4yNXf75/2YiNSto60PGUYl5VX0xmBU816paOCD+tDEVGhbq9eUEAJ7s74TGfZihKml3qq+cIaOuwNCHNMFu3ozMZxXCrhVE3B89PeQezcmMd2IGJCq1Qd0IxicjDKO8AGWUbU8jeSB8TJOTylO/HIwk+saOp5XeaOWNPZrc2BR+v56Yd4ApTaIGDRfDRu5VjPT/l9vlsU6pVsRnRqdoSrHNl+KFJOYGDeHJDUGk/rrE+K6AMgIhg4If86dKPwYgyBcXbFHHHG67fM4Mw2T/2CeQ/RagXjCRaqrpssMNQkG477yAN0M/GWd
 ND83C6oG
 YZUSZvcsTx6S7TWU8jFortceDVRAe2jNbPto621EyCEAhsxACqUKMghQdM5RI87IRexmKAen0pwGMd8CiEGzNW5A8ySoqI2yf3QGfm8UUG6CUJnUgGiPWVvsdX9L61KDtVE1CEifRKVaFUXHtufsJjk15FTHZbQisVcuZeeGzeiSkHEqNNVmiqeipIwCyyqU+0ekJHlnRiziRF1p9QOrvmgxbzBxfHfP64ZERogfpvMVXSLyKr/S3grD7hMuDGJ3O5tAtXeOljeq9pxbejEvNHmxozehbhGzqhmIr3NR9wImH1tjObBcraU+hlEAqFc6WbU1m/yDz8sx2zGpZWEK4HAMeyQiDvVETquQpWh+S8XkmrHeuuE/GBqX3XuzxoF/gLc0HAu1e6uP17LVEKpYbKLuv/iFmIsLYKBdpm0oZ63z0s6Hgd2WQwjcELfGLbZ9V4rQM7UebsQemhH5y5QE6IruccDs5WGw+q/DuCfKooG1LltS3Og48uWL9M2mWCYLqae6jSKXNR/ecM6MfIdzzUKjbER7PKUmpZFR++Kcl3fT2BJ1UyPH3jWCHO38eDcVzGd5n+q6tmVAWFk+QzVrOOBnaiDYN3YsV+QJSoqjIAVXlW2YOyjU4WjwiHv3ZJmUD1V8H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/22/26 10:00, Jinjie Ruan wrote:
> 
> 
> 在 2026/10/21 17:48, Wandun 写道:
>>
>>
>> On 10/21/26 17:13, Jinjie Ruan wrote:
>>>
>>>
>>> 在 2026/10/21 16:30, Wandun Chen 写道:
>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>
>>>> crash_prepare_headers() counts memory ranges before populating the
>>>> allocated crash_mem array. The weak implementation used by ARM64,
>>>> RISC-V and LoongArch walks memblock.memory, while x86 performs the same
>>>> two-pass operation over system RAM resources. Concurrent memory hotplug
>>>> can change range source between the two walks and make the populate
>>>> pass overflow cmem->ranges.
>>>>
>>>> Take device_hotplug_lock when preparing crash headers during
>>>> kexec_file_load(). The x86/riscv memory hotplug path already takes
>>>> device_hotplug_lock, so call __crash_prepare_headers() directly
>>>> to avoid recursive locking.
>>>>
>>>> Sashiko reported this issue in [1].
>>>>
>>>> Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
>>>> Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
>>>> Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
>>>> Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
>>>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>>>> Link: https://sashiko.dev/#/message/20260806101002.1F84E1F000E9@smtp.kernel.org [1]
>>>> Acked-by: Baoquan He <baoquan.he@linux.dev>
>>>> ---
>>>>  arch/riscv/kernel/crash.c  |  2 +-
>>>>  arch/x86/kernel/crash.c    |  2 +-
>>>>  include/linux/crash_core.h |  2 ++
>>>>  kernel/crash_core.c        | 17 +++++++++++++++--
>>>>  4 files changed, 19 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/riscv/kernel/crash.c b/arch/riscv/kernel/crash.c
>>>> index fe5a4b306aae..ac8df2edf2a7 100644
>>>> --- a/arch/riscv/kernel/crash.c
>>>> +++ b/arch/riscv/kernel/crash.c
>>>> @@ -70,7 +70,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>>>>  	 * Create the new elfcorehdr reflecting the changes to CPU and/or
>>>>  	 * memory resources.
>>>>  	 */
>>>> -	if (crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
>>>> +	if (__crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
>>>>  		pr_err("unable to create new elfcorehdr");
>>>>  		goto out;
>>>>  	}
>>>> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
>>>> index e6f23933a6df..bef008a0cb22 100644
>>>> --- a/arch/x86/kernel/crash.c
>>>> +++ b/arch/x86/kernel/crash.c
>>>> @@ -465,7 +465,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>>>>  	 * Create the new elfcorehdr reflecting the changes to CPU and/or
>>>>  	 * memory resources.
>>>>  	 */
>>>> -	if (crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
>>>> +	if (__crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
>>>>  		pr_err("unable to create new elfcorehdr");
>>>>  		goto out;
>>>>  	}
>>>> diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
>>>> index bc087124cd78..28e7a81cf263 100644
>>>> --- a/include/linux/crash_core.h
>>>> +++ b/include/linux/crash_core.h
>>>> @@ -61,6 +61,8 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
>>>>  				       void **addr, unsigned long *sz);
>>>>  extern int crash_prepare_headers(int need_kernel_map, void **addr,
>>>>  				 unsigned long *sz, unsigned long *nr_mem_ranges);
>>>> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>>> +			    unsigned long *nr_mem_ranges);
>>>>  extern int crash_exclude_core_ranges(struct crash_mem **cmem);
>>>>  
>>>>  struct kimage;
>>>> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
>>>> index faa0f22dbb41..8a861a946e26 100644
>>>> --- a/kernel/crash_core.c
>>>> +++ b/kernel/crash_core.c
>>>> @@ -16,6 +16,7 @@
>>>>  #include <linux/mm.h>
>>>>  #include <linux/cpuhotplug.h>
>>>>  #include <linux/memblock.h>
>>>> +#include <linux/device.h>
>>>>  #include <linux/kmemleak.h>
>>>>  #include <linux/crash_core.h>
>>>>  #include <linux/reboot.h>
>>>> @@ -344,8 +345,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
>>>>  	return 0;
>>>>  }
>>>>  
>>>> -int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>>> -			  unsigned long *nr_mem_ranges)
>>>> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>>> +			    unsigned long *nr_mem_ranges)
>>>>  {
>>>>  	unsigned int max_nr_ranges;
>>>>  	struct crash_mem *cmem;
>>>> @@ -382,6 +383,18 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>>>  	return ret;
>>>>  }
>>>>  
>>>> +int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>>>> +			  unsigned long *nr_mem_ranges)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	lock_device_hotplug();
>>>> +	ret = __crash_prepare_headers(need_kernel_map, addr, sz, nr_mem_ranges);
>>>> +	unlock_device_hotplug();
>>>
>>> I think this patch conflicts with my changes and would also conflict
>>> with the implementation of arm64 crash hotplug.
>>>
>>> https://lore.kernel.org/all/20260921090450.807575-15-ruanjinjie@huawei.com/
>>>
>> Have these patches already been merged? My current work is based on the latest
>> linux-next. If they have already been merged into the maintainer's branch,
>> please let me know, I will update my tree and rebase/re-adapt my changes accordingly.
>>
>>
>> Also, regarding the changes in kernel/crash_core.c: it looks like we modified
>> the same spot, the change is not wrong, is that right?
> 
> Hi Wandun,
> 
> However, I think someone should have informed me in advance; otherwise,
> doing duplicate fix work is pointless.
> 
> I see that part of your patch series modifies code I previously changed,
> but I was not CC'd.

Hi Jinjie,

Sorry for not CC'ing you. I keep the per-patch Cc lists short because
large recipient sets have caused my sends to be cut off midway before,
(I'm still trying to track down exactly where the problem is) you should
have been on the list that's my miss. You'll be on the Cc of every future
version.
> 
>>
>>> arm64 crash hotplug:
>>> https://lore.kernel.org/all/20260918100442.3841135-18-ruanjinjie@huawei.com/
>>
>> In addition, if arm64 gains crash hotplug support, the code there would indeed
>> need to be modified (to avoid a deadlock). As of now, arm64 crash hotplug
>> support has not been merged yet either, has it? I just want to make sure I
>> haven't missed anything.
> 
> Yes, you are right. If your patch series will be merged soon, I will
> develop based on it.

Also thanks for your reminder, otherwise I might later overlook the case
where arm64 has already gained crash hotplug support, and introduce bugs
as a result.


Best regards,
Wandun>
>>
>>>
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>>  /**
>>>>   * crash_exclude_mem_range - exclude a mem range for existing ranges
>>>>   * @mem: mem->range contains an array of ranges sorted in ascending order
>>>
>>
> 


