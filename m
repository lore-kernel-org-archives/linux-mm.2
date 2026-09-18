Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA18C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0526B0092; Fri, 18 Sep 2026 04:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EF06B0093; Fri, 18 Sep 2026 04:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4CD26B0096; Fri, 18 Sep 2026 04:46:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A494C6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:46:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2D054061D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:46:11 +0000 (UTC)
X-FDA: 85226250942.19.B27CF28
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf23.hostedemail.com (Postfix) with ESMTP id 00FF1140007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:46:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Eoe3uXs0;
	spf=pass (imf23.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789721170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0JHVWPEX+y53lIHPhD5/BSPnjVOTml/jp7Miw8vUP8=;
	b=s2RlcX0Yegx6O7e0BjQbIUhD8stP0/9v4RQvM8p2vLhFGLAW8r6AXJWl5LpfEZpLTbFDso
	/awWlUEvSJpMYS0rszK1AXFc34uU8k0razNT0LOXKfZMlnm7fs5yB3cozGFOfDFqsMmj6r
	7j5EX/oDL4Y1tTZqXCKiw73gf8ublcI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789721170;
	b=l61sE57IgUwVStzMnzq3DVbQGNA59k78PNIfGSIUbys93oMARVdQz9PdjQ43W2jwTOVKpn
	Vf0mOc0LPD3mJ4+I+nwBRgsttvbccDx8yUuiWrqAhMt6YmdBL3er5HDma+RUVwUXxA0JHZ
	33MePH4Iu6JntaSfC8RgOi1gsYIHzok=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Eoe3uXs0;
	spf=pass (imf23.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-39e4b1e7d12so689739a91.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789721169; x=1790325969; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T0JHVWPEX+y53lIHPhD5/BSPnjVOTml/jp7Miw8vUP8=;
        b=Eoe3uXs0nw1eq9bFNfz7YS8tBUhABZmfZETTov3b7i7+bOkuGwx8UGPdpTUSxjyevS
         VJ7pG0chTlVYSze0iR82i7n0iSL+4n3DfSHGzMotH/hXnHBtzjXvH3lwTIqp0mczdETJ
         BuuNd+7r0tIZtEzwNggOlqX5W9Qo3hetVKAiwmcBSDPzjgnGo4AISTo6xhCSRviklBsC
         PRdMEd8d2Z3b8YMj7axbYpd4VXN6Xi0KNdyZkaKHlxl5Q29ittEGTfFXTdz6hJ8HbY1m
         yZFOQoZ+Xkli4nbjPa2jQWOtcuxMYgJNehBUCleWzIUSn3Xnfv6BvZkSaQZ13FH3hbSW
         q1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789721169; x=1790325969;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T0JHVWPEX+y53lIHPhD5/BSPnjVOTml/jp7Miw8vUP8=;
        b=I26s2jxScgrjBTLJ+52/yfC800JuhjT0S5ITp/bAY9r2Mjwxot0iaidpPQNM0GX+7i
         Yb0WAlmAAXjEUf1DWRD67a0HrcRw7vpZ9ozFI+F+VoFXcITZrOjF0CIxXxdaF2QBe/Z2
         vLf/7Te2JlH8x4eH7vAY8zVKzmB7a7HszW3SwqAaNRGGEdPwsdCbmvhP2OkVPZwih+6V
         GLgumFZse+/VpVY8JmETSXjyfvRpFMm89nGhNQBCPLvj0R4ph+EpI0D0in3cdcD6boUb
         gmwCv+4gFe+/TY69VCA8Hl5Fi9ovZmdrkOd8DPMuUyUgAC3M3ItBZ0PLKnrRbFy+TrBg
         FHEQ==
X-Forwarded-Encrypted: i=1; AKwUvByE1K6/sdPV2dYYJ82Rc0sJRk4NGxkGLMZ2/8yPgStg6+TN5NjkuVi1gQH+BGmzBeacnx7V2L5qwA==@kvack.org
X-Gm-Message-State: AFuF++n0HwO0LFdMtTszwWFa3z+dBF/PslVzAp5FEGONl06MfOKqc/Qc
	6YFu5sAkxreDOi9bnjX7azj1Oin0Hah5ZJV37DRwNhZyq3ylzm8IDno9
X-Gm-Gg: AYBFou11ANmYckHAvDSShcYhLyY0DqXZ/uy5c/8Zdz60rq5B8qtZLuOvbIyfCad5GNs
	0DEi3rb1c4Nx4Ey59gTMsVcvvC3cmtf+MhFb4iSG3B6YQFMg+F4KzNq6MzmKWz9iwrsjcZoA/9B
	ZfDGucPcev0mmWZ/lCVBBKynk4Rk0uJCxZjI4a3cZxrNL1GIh3mv0to0sADYIBKnoWxro0Lm9/G
	iUgzBLGqEcRErlvR91u8ugTIcCVQ9wS3RyJG5d/nzJjKX1kdU94Gp2ZGHssWo+3B528c/ilf6Tf
	0eY6nwvUCiVqjP4n3TCtDYGvc94lz5kpoKlGKH7bv0SwqM20mNb3Kq30ErEmjiS1vZd5xM7ffzi
	OmDbb5cD8/ItMKC/PBO+FpOhEnwE2BzcrdPrXwR2Dhy7sQ32dd1YWZtkldenZuDBG4hqS9HJBkf
	P+GBk4WofQBfrWN244dbqq8PfmPlDNAbNlvYVppnCixBPRf5/QnS0+aGTPj+iy5ltsNKsg0yhfr
	QWXGw==
X-Received: by 2002:a17:90b:5784:b0:39d:f5b1:e365 with SMTP id 98e67ed59e1d1-39e54f35b9cmr3920258a91.25.1789721168773;
        Fri, 18 Sep 2026 01:46:08 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e59e4a508sm2264153a91.0.2026.09.18.01.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 01:46:08 -0700 (PDT)
Message-ID: <c58e9b6a-e421-4265-aa77-48c07a4fb8e4@gmail.com>
Date: Fri, 18 Sep 2026 16:45:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/10] crash_core: fold duplicated memblock arch hooks
 into the weak default
To: Baoquan He <baoquan.he@linux.dev>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 robh@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org,
 rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org,
 m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
 alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev, robin.murphy@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org,
 iommu@lists.linux.dev
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-4-chenwandun1@gmail.com> <aqzolBceoRchBdbx@fedora>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <aqzolBceoRchBdbx@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00FF1140007
X-Stat-Signature: t7kpinouehimwzij1y548jaj6ga55puf
X-Rspam-User: 
X-HE-Tag: 1789721169-658472
X-HE-Meta: U2FsdGVkX1+ht9FXDXN6lK3nD3Zkm7NRDNQcaoHOJXm1AId9ErPsRfLmjjxhAp2J92Ao8qCDUCymDe7uWmwvPrjKJyTqILQ7bh35Hh8GGY6grEzkW2Mh4g48CWoykH4J/6E0CQ03nArb3+Vc1NWQuzpc9HHTF5Q9Gl7Ll24jFoAbobnL1sYFiz2VahPjAySVnfVHOPmBi5MC8Sr6vrMqS/C2u5/MDKzHx4QFJ1JSIRMKNMdriRTY3IAA6xhbyU/BASoXQTEuURD4uVsoEc1C/+vnkbB+mejRGg+WWc+LsSI7fUI0RoRxUOuaTS/AQNV5Ark6YMnu7T7BdPE2vPi4tSJeLQSS7ahVpFLfYe4V+Fx2oJMviE8mPAske8NJ2nLFVmC7mT5MdZfuD4kWP9BMa21dOr96d0elhQ9gm9acZIIQBNZPc9aHOyC0iqACre+rD+uXrwOroVEr9/tJcuVAAMtLj8c99jBmdto7MCsAE+fRYa+Mbfvbt9nnMBgnLjMg0QannIZMCcXeY9Qyw9QWjeENMCGxEoG6U1qSpK0E+HF7RBFfQctFBqJmKx9htLPEp1j5TKRF8VkzgBau3yvfJKlwOr6gMjxRyeoB8HIaRLlaMlftX5brUiHg+XoMwqVA6oWnmlM5yoV+fRGqRXgVyxQD+jbVZ7g957sWup7QGJY54KKTNEc7I6A9sdt7xTaDIfJ8ejcQJ+gPIWDQllXYvZAtXuhheTkcgFM6Mav5ysPLI0eNvfa/1JqgW+f5Q5916BW1pWvXKtZJXdJDYv6t58O1fX5xYqjU4jfho05NGR4CKmRGroQ4nC/u5wuXPJHOyoQc9n0NFYUFyuMkfNk0VZFOOkLr/1gIyeoywIqOAeLMXBfntYfGXbuc0bKKzPTYQNel/hjz33PnLLbEfPEw5gBzmhXDSrUs4nesFYSH9AZZBJvG9MxUUIBpnKHSKsElSEjNSW6Xx+lLqea1Byg
 JQEgIkPv
 bEQvbYcxPlHKjVSeEUHoktdbn7R9s/24eVGHitmYimgNI/nCyzmUHoiFNNjXn6WOsHkNNQg/KfG0BeR/Be6lmfTLuP2QwUxxSz64QOleRPaY1RM34+3hDLDLWfK6fNkNwKXBfOywcg6NXTmvO1DNj2Kqi1JUr93DGbaEMQ5UXnRDBkeDfSIm/UouMg1OtuYTYtuQ2s1kwmDdGoKhgwoz13Cn+7z/72d2WOYrqlV2UCEbn+PgmdwRYZW6AdVJP1Wj+Jq/DxovWHOtg5K8gxwhbcW1ZacxCeTM5Rvu0c6XkXpwELFggcCbP+v17M1fPk0PKurjXZp+v+eMGx2KeiE0thNUDietSrdh9XblZK6Zj/kHJrIMGxdOFM3FwPYWnj5jeMcKmyMukAIwvJ7b/8kA2oRfLhAbzTNy3B2iw530SzHyqqWhEX+W/sqqZDnN+ATSdiWqYkFMZEijLGKs+U+Jiq9aUDDgacbiH4TiO/jSuNHpyBPkAksri05qjOD4npZ4WHkbACl3LdaaA2FfhJlLcGKnSpCqaCRkk0+JE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/26 15:30, Baoquan He wrote:
> On 09/02/26 at 03:31pm, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> arm64, loongarch and riscv open-code the same memblock walk in
>> arch_get_system_nr_ranges() and arch_crash_populate_cmem(). Move it into
>> the __weak defaults in kernel/crash_core.c and delete the arch copies.
>>
>> No functional change.
> 
> In one version, you also tried to remove these functions on x86, I could
> remember it wrong. 

Yes, the x86 implementation can also remove these functions and use the same
approach as arm64, RISC-V, and LoongArch. However since this change would not
reduce the vmcore size on x86 at all, I did not include it in the current series.

I plan to refactor this part on x86 after this series.

Best regards,
Wandun


> 
> Anyway, this looks good to me.
> 
> Acked-by: Baoquan He <baoquan.he@linux.dev>
> 
>>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
>> ---
>>  arch/arm64/kernel/machine_kexec_file.c     | 29 ----------------------
>>  arch/loongarch/kernel/machine_kexec_file.c | 27 --------------------
>>  arch/riscv/kernel/machine_kexec_file.c     | 26 -------------------
>>  kernel/crash_core.c                        | 25 +++++++++++++++++--
>>  4 files changed, 23 insertions(+), 84 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
>> index 854d872dfd0f..34d944d3f22f 100644
>> --- a/arch/arm64/kernel/machine_kexec_file.c
>> +++ b/arch/arm64/kernel/machine_kexec_file.c
>> @@ -14,7 +14,6 @@
>>  #include <linux/kernel.h>
>>  #include <linux/kexec.h>
>>  #include <linux/libfdt.h>
>> -#include <linux/memblock.h>
>>  #include <linux/of.h>
>>  #include <linux/of_fdt.h>
>>  #include <linux/slab.h>
>> @@ -39,34 +38,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
>>  	return kexec_image_post_load_cleanup_default(image);
>>  }
>>  
>> -#ifdef CONFIG_CRASH_DUMP
>> -unsigned int arch_get_system_nr_ranges(void)
>> -{
>> -	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* for exclusion of crashkernel region */
>> -	phys_addr_t start, end;
>> -	u64 i;
>> -
>> -	for_each_mem_range(i, &start, &end)
>> -		nr_ranges++;
>> -
>> -	return nr_ranges;
>> -}
>> -
>> -int arch_crash_populate_cmem(struct crash_mem *cmem)
>> -{
>> -	phys_addr_t start, end;
>> -	u64 i;
>> -
>> -	for_each_mem_range(i, &start, &end) {
>> -		cmem->ranges[cmem->nr_ranges].start = start;
>> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
>> -		cmem->nr_ranges++;
>> -	}
>> -
>> -	return 0;
>> -}
>> -#endif
>> -
>>  /*
>>   * Tries to add the initrd and DTB to the image. If it is not possible to find
>>   * valid locations, this function will undo changes to the image and return non
>> diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
>> index 5412aa9f3568..481b8f906a56 100644
>> --- a/arch/loongarch/kernel/machine_kexec_file.c
>> +++ b/arch/loongarch/kernel/machine_kexec_file.c
>> @@ -13,7 +13,6 @@
>>  #include <linux/ioport.h>
>>  #include <linux/kernel.h>
>>  #include <linux/kexec.h>
>> -#include <linux/memblock.h>
>>  #include <linux/slab.h>
>>  #include <linux/string.h>
>>  #include <linux/types.h>
>> @@ -56,32 +55,6 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
>>  }
>>  
>>  #ifdef CONFIG_CRASH_DUMP
>> -unsigned int arch_get_system_nr_ranges(void)
>> -{
>> -	int nr_ranges = 2; /* for exclusion of crashkernel region */
>> -	phys_addr_t start, end;
>> -	uint64_t i;
>> -
>> -	for_each_mem_range(i, &start, &end)
>> -		nr_ranges++;
>> -
>> -	return nr_ranges;
>> -}
>> -
>> -int arch_crash_populate_cmem(struct crash_mem *cmem)
>> -{
>> -	phys_addr_t start, end;
>> -	uint64_t i;
>> -
>> -	for_each_mem_range(i, &start, &end) {
>> -		cmem->ranges[cmem->nr_ranges].start = start;
>> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
>> -		cmem->nr_ranges++;
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>>  /*
>>   * Add the "mem=size@start" command line parameter to command line, indicating the
>>   * memory region the new kernel can use to boot into.
>> diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
>> index 808e872f4063..fdc6695e8588 100644
>> --- a/arch/riscv/kernel/machine_kexec_file.c
>> +++ b/arch/riscv/kernel/machine_kexec_file.c
>> @@ -37,32 +37,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
>>  }
>>  
>>  #ifdef CONFIG_CRASH_DUMP
>> -unsigned int arch_get_system_nr_ranges(void)
>> -{
>> -	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
>> -	u64 i;
>> -	phys_addr_t start, end;
>> -
>> -	for_each_mem_range(i, &start, &end)
>> -		nr_ranges++;
>> -
>> -	return nr_ranges;
>> -}
>> -
>> -int arch_crash_populate_cmem(struct crash_mem *cmem)
>> -{
>> -	u64 i;
>> -	phys_addr_t start, end;
>> -
>> -	for_each_mem_range(i, &start, &end) {
>> -		cmem->ranges[cmem->nr_ranges].start = start;
>> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
>> -		cmem->nr_ranges++;
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>>  static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
>>  				 unsigned long cmdline_len)
>>  {
>> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
>> index 2b36aa9fade0..77285ae3ce60 100644
>> --- a/kernel/crash_core.c
>> +++ b/kernel/crash_core.c
>> @@ -281,8 +281,29 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
>>  	return cmem;
>>  }
>>  
>> -unsigned int __weak arch_get_system_nr_ranges(void) { return 0; }
>> -int __weak arch_crash_populate_cmem(struct crash_mem *cmem) { return -1; }
>> +unsigned int __weak arch_get_system_nr_ranges(void)
>> +{
>> +	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
>> +	phys_addr_t start, end;
>> +	u64 i;
>> +
>> +	for_each_mem_range(i, &start, &end)
>> +		nr_ranges++;
>> +	return nr_ranges;
>> +}
>> +
>> +int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
>> +{
>> +	phys_addr_t start, end;
>> +	u64 i;
>> +
>> +	for_each_mem_range(i, &start, &end) {
>> +		cmem->ranges[cmem->nr_ranges].start = start;
>> +		cmem->ranges[cmem->nr_ranges].end = end - 1;
>> +		cmem->nr_ranges++;
>> +	}
>> +	return 0;
>> +}
>>  int __weak arch_crash_exclude_ranges(struct crash_mem *cmem) { return 0; }
>>  
>>  int __weak arch_crash_exclude_mem_range(struct crash_mem **mem,
>> -- 
>> 2.43.0
>>


