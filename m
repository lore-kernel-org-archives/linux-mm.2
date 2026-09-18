Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27293C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF176B0093; Fri, 18 Sep 2026 04:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1897D6B0095; Fri, 18 Sep 2026 04:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0541D6B0096; Fri, 18 Sep 2026 04:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C44066B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:22:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 009A3A5FC7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:22:24 +0000 (UTC)
X-FDA: 85226191050.14.6008CFD
Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1021640005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:22:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oV14+HPv;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789719743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CjigVRuOlpSLvwuFF0kw47lERwh/eIzaGM/o/mwNyVQ=;
	b=0yHvljkcSSLHr/x79z1JHhCuXnjU3HlnR8jVLj/D0s63uQt7/uUNo7N1jze9Yb+YwplIGe
	uibOqGAX6GQOSGTFbbp5El6t7lxK9r6rCZN/ws6NKkCsgZ52+MFdqReAUYH5kvhw8KgRI/
	P3bEdZyH0PbjQz7d7PVxGmI1khy9FUc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oV14+HPv;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789719743;
	b=TEL4jfAr7ha8qOO5sx/gLLHp6gZH6zrnGJJH3rd3tUizFeJgKdpDrSl0/dH5p3cof0EdDY
	DgE/aO5BMj/cw735x0EgJto2qgvlotWPwwnh2iOsBVIrI04Hik1xXK2e12BFNd8IGKafC3
	FIGPx57PqGwZucsJurK7o/z0+jbI+M4=
Received: by mail-pj2-f5.google.com with SMTP id d9443c01a7336-2d6fbdc8772so2518885ad.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789719742; x=1790324542; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CjigVRuOlpSLvwuFF0kw47lERwh/eIzaGM/o/mwNyVQ=;
        b=oV14+HPvw9bpVfPFXBNyhHzlVSUdg2BHEk2xk10MWX1eXEMmBVoxG32F6dnXjEEK1U
         IvjmElcd7/FN3oKvJtylpDTtwh42B7Un3Pj+u/rqdKcAIU/Jxmm4EHsiQ9egXRe37NxY
         eQ3lj7kNGZ5Yy3n54Gx05yr+iVBsN+ynzL3ra+cuhJU+NuVT3zCeEuUOyU/RaGJT4rPH
         rHiSCI0WVrQ8ckFmQpgVoeeE4yUGnOrXuHWXfSzTBE2G8+JPT4xtdA2Zv3hFtf47CDxQ
         poV5Zpoy5jcQOyj97mKnkLVk04xNjIG1PbSbu2X1fE08THpNsr4E9cuOH0xNhqBgZt5Z
         TpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789719742; x=1790324542;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CjigVRuOlpSLvwuFF0kw47lERwh/eIzaGM/o/mwNyVQ=;
        b=N4TvTR+a2m4dw5TPTBkiPQ5KHMxcTaiAn+yF9q2N7OX1IVSovWpjzu9buYDdjNMfQQ
         kncsxQmcHrqBD1bDMvy+WyhmPL1/9c8tkxn7v3ka7kOJMF/8mMbxHQ5s7BU7rD8yMHmP
         SoMnncyAPZ9zdkxPDqYApuE3E/bVuzEVa+DfZ5nwgZ0/tXsjHXUidpb5UnJ4GM60q86u
         19l4Q9X3Fo8wmt0tU6uhM5EfxPsoQJPyJjhBz3RZhqp+DnuDjgFMAwNJ3IT22j135lZQ
         /rHcfHtjUmdEO/GF+GR6oAQdFBb3fFouZRwCmDUin4PzRwzdYfi32+jXCHH+kXGF00OD
         bEmw==
X-Forwarded-Encrypted: i=1; AKwUvByYHK1m3AlsfxW8uAQyQq/wAS+3HUkUnEhV0bFBTKALQ3WKovMi65sFyhaCAvCs7q3Ofd9iUCip0A==@kvack.org
X-Gm-Message-State: AFuF++nAkq/C/X6SeezFytJn8tmjqd8YFNNJiB7nyt7fP0fFu9M+iz4T
	49dVUVr3TDEGJI/qUZA7bU8EiQwRMmTWpr8g6lTvMbUOZ3s7pXOjsTsu
X-Gm-Gg: AYBFou055UJ6kHtwISheOqOiCfIMkIVEpSQAbaLYWgM3QPp5Ls3gKAkki4R7EOFgm5+
	mnMYypLbEegi68wdbAJIDPcCJ1y8KPUpBfFEHRCdmPG8t58ikAcDQTVDTBdwmC5ji9um/hptjG7
	R1Y1DY37IWRKrqxyJ0eQvNklft9V71lCwwQmGFxrSpKNCaqUJdEwTy0LNidBSIALyNvJPTfHtNM
	8cbzmYgCEC8Taoz5HrS7CP5iD08JBdCNdeDH8tm5O2AmWG9SfnZCT05LpLIC0OP2uk6wne7BoJL
	xowYWLIjPH6v6TDnTB82VKCDeXHmpMofBTfMI8GjQbU/OynngZBIpIXOEfV1mqh/J8JVAUzN5Mv
	jiu+ozyTxdhazFky1R0nx8Uv8hX0OvwiSL9D/8tJqhOab8dLfA83mNTQFOOJD0hT5ueq78sVeWK
	7PGqQGpAh9WL1mgIHosnN8RHlX3AFWafI0oyaVNuYA70R4C+TdCNhfASfs4WSzrjNfBNrxuYPhW
	6bRRQ==
X-Received: by 2002:a05:6a00:4196:b0:874:708d:b637 with SMTP id d2e1a72fcca58-874df800839mr3426122b3a.35.1789719741686;
        Fri, 18 Sep 2026 01:22:21 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc5c50e79f1sm541488a12.30.2026.09.18.01.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 01:22:20 -0700 (PDT)
Message-ID: <bc6cf467-84d1-40a0-b570-1b5256a6e2e2@gmail.com>
Date: Fri, 18 Sep 2026 16:22:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] memblock: introduce MEMBLOCK_NODUMP flag
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
 <20260902073116.802752-7-chenwandun1@gmail.com> <aqzxavL91icLw-Xv@fedora>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <aqzxavL91icLw-Xv@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1021640005
X-Stat-Signature: y9y4yr3ukykwnfq16z33sj9xwut6jdpu
X-Rspam-User: 
X-HE-Tag: 1789719742-85430
X-HE-Meta: U2FsdGVkX18uvGTqDyQyFus4UvFDSUglxpUDHxSukDHUn0ek6NtFsmueeP/iFJqiseKzC5c6bvkSWteO115XS0KjGGFhIlHsQ//At5EEvpC6ddMpvstY7a+0EFqwwOSvgYykJ0XG0QVQn/HJrRu73PFJtLIEzCZuQ2TXCmQjBN78Y7k6v3yTvkW8OTnw/99ThtQvjrcMG8+xAJZGMmjyYuPVbRdIyxTB1oFOHlaM2+OoIT+0fPMT1SgWzIq+M2v8aKmRpd9MvE1QzxeADwRUsoO1YmGrwdUQGVfZfupAXbGGHvjJwR4v3AOehpiJvIq4F6HjfohNgc+mR2PSDy3Y0yGRv9VF7OnWy8uyDCUYUyXaiWWlYl3GumQSSNvDAylcS8l3/M1PmNK/fNaXO9LJpraSCdT8HJtPYbTugg7AVxbLtuMh2MtDgy2YUbyU9n6T4NLWLjgZIna+8Tk6IqkYd+y+KRqcnwhv7EojwOAogKk28GSXru1ube/C99zcFGLp3fsE9SKh3LJ5qt59r6FWZHTFv1ZNl250pD6JiIJEMTvLn7pzU6ng4TwYeZ13dsJuQC1cJZCwHjL0X+Xv4KUWhXWhrc7/v+teQxzPyrdWdh9fSc5VFQw8erpj6GoEO79g/bxBdRQ2WI8bLbgyYM53kBQxdPuxdYDLjl5Nr8gBG10YDt8ENfrtcZ9eQsiPbW0Tkwfs3D3OfLjb2B/A2q/wccPMASZcVYoOY9ZXKpRGmzS3Fo37hxUWk3Yoy4x2GYfOhaLq5z4/A5PnWUFzMTZhRQj95YwgAzZWKa9UkZgzNygM2hAry3RGQlOZQGTc0o2s7qrMpTl2UqHqnUD6NYindEArcld9dFt9jNn3USg6iSZ3SNbG/MJz56JCXLabeGtOJfYp/3bJZL7jzNSTQuGLhquAA+i8DJUJtr8P+jCsMAHq4epa00Qj4obVwAOUj57Hh2iu6dhADnLTRNHsCf3
 6lzTrvWO
 vuZSvwD/I78Sb4AKt7fX+UevgTOBSw7h1sCcOrltDFww2IbCBAMUOlD57+5B96tElIKqrzke0urKhbXWPlR7tSm5Zm8a5AxdiiAxYBLHBkTFjLhmy7KMywzWOiBrHYNQmZpasBc1hBrxyyO2NcYkPhmopCEp+ef3quHkBO1HugqFbHiLn9+jHoKq6wFihsfOBFFYAtUjt0tkK6uzVeaWSs3DBVvAFwHt4hGORdgFyDS7aTd1SwOSKEI59UUhDTPcbn/4eC3nlwZ18QOWGYbZc7xnZe60cxqKz/aLgQA1L0Gh3f7Ygg7KVEfAhSMaZOgnuhuSoyWb9/S6CGU3sGL8fQ8oRqqb+5rHKF8UIfsEAJ3cPT9s4acXu6/q4OvoV796rHNjmQVtjMGO9z+JheJ9v7gJlRPtCUM7J6J9fj0aExRU6i59LrGQSHuBdhlqRMxXMVPcp41nIcB8ZC04TLq7dBDvCr5edFf5CwSMNvzWqRQQLxCpkkjaPCrS/SxURkhkeLSDEPT0kkyo9IrYV6SQX3Okpm/qyXB8mRYM0TPAeb9+xAmLj7vbsEdY3OaCRjAgMPo8t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/26 16:08, Baoquan He wrote:
> On 09/02/26 at 03:31pm, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> Add MEMBLOCK_NODUMP to mark regions that should be excluded from
>> kdump vmcores.
>>
>> The flag is meant for reserved memory that carries no data useful for
>> crash analysis. Reusable reserved regions such as CMA may hold useful
>> data, so these regions must not be marked MEMBLOCK_NODUMP. Subsequent
>> patches wire this up for /reserved-memory and /memreserve/ entries.
>>
>> Suggested-by: Rob Herring <robh@kernel.org>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
>> ---
>>  include/linux/memblock.h |  9 +++++++++
>>  mm/memblock.c            | 16 ++++++++++++++++
>>  2 files changed, 25 insertions(+)
>>
>> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
>> index d62db9e776cf..b2fcf11fba2b 100644
>> --- a/include/linux/memblock.h
>> +++ b/include/linux/memblock.h
>> @@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
>>   * kernel that we know is good to use. It is the only memory that
>>   * allocations may happen from in this phase.
>>   * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
>> + * @MEMBLOCK_NODUMP: exclude from kdump vmcore. It carries no data useful
>> + * for crash analysis (e.g. firmware carveouts).
>>   */
>>  enum memblock_flags {
>>  	MEMBLOCK_NONE		= 0x0,	/* No special request */
>> @@ -63,6 +65,7 @@ enum memblock_flags {
>>  	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
>>  	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
>>  	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
>> +	MEMBLOCK_NODUMP		= 0x100,/* exclude from kdump vmcore */
>>  };
>>  
>>  /**
>> @@ -160,6 +163,7 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
>>  int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
>>  int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
>>  int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
>> +int memblock_mark_nodump(phys_addr_t base, phys_addr_t size);
>>  
>>  void memblock_free(void *ptr, size_t size);
>>  void reset_all_zones_managed_pages(void);
>> @@ -306,6 +310,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
>>  	return m->flags & MEMBLOCK_KHO_SCRATCH;
>>  }
>>  
>> +static inline bool memblock_is_nodump(struct memblock_region *m)
>> +{
>> +	return m->flags & MEMBLOCK_NODUMP;
>> +}
>> +
>>  int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
>>  			    unsigned long  *end_pfn);
>>  void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index f2952d725c10..2e87f39826dd 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -1204,6 +1204,21 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
>>  				    MEMBLOCK_KHO_SCRATCH);
>>  }
>>  
>> +/**
>> + * memblock_mark_nodump - Mark a memory region with flag MEMBLOCK_NODUMP.
>> + * @base: the base phys addr of the region
>> + * @size: the size of the region
>> + *
>> + * Mark the region as not to be included in crash dumps.
>> + *
>> + * Return: 0 on success, -errno on failure.
>> + */
>> +int __init_memblock memblock_mark_nodump(phys_addr_t base, phys_addr_t size)
>       ~~~~~~~~~~~~~~^
> Is it impossible to use at runtime even thought it claims to be generic?
It is currently only used during initialization, so I added __init_memblock.

If other modules need to use this function in the future, this annotation can
be removed.

Best regards,
Wandun>
> 
>> +{
>> +	return memblock_setclr_flag(&memblock.memory, base, size, 1,
>> +				    MEMBLOCK_NODUMP);
>> +}
>> +
>>  static bool should_skip_region(struct memblock_type *type,
>>  			       struct memblock_region *m,
>>  			       int nid, int flags)
>> @@ -2887,6 +2902,7 @@ static const char * const flagname[] = {
>>  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
>>  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
>>  	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
>> +	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
>>  };
>>  
>>  static int memblock_debug_show(struct seq_file *m, void *private)
>> -- 
>> 2.43.0
>>


