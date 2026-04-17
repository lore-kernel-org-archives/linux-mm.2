Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65889F43697
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FEAA6B00FD; Fri, 17 Apr 2026 08:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF7C6B00FF; Fri, 17 Apr 2026 08:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6116B0100; Fri, 17 Apr 2026 08:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 688826B00FD
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:57:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E62A31B6CCC
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:57:38 +0000 (UTC)
X-FDA: 84668049396.15.2121D45
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 75CA940010
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:57:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CMhwdnQx;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776430656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bR2LlG2Z9OwJ3IbsfdJKwXcRLEurdguo/ZlSUV0sDIE=;
	b=KilKr6KYnCgijQm/+lDvulGyV3ND8FZ5yjlpTPcyQKaR+3edXaPSeV8zmZdZazpUAkYon6
	p7/xPXkTjEKDZNIdsshRfvcdjueh1CCXbFR+cCH8TnqUkTGkZlluhRZ7iOf7DEXwbRqiIl
	4vEr8dsYlIX+7BgBHCbpuTRhDhPOjqE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CMhwdnQx;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776430656; a=rsa-sha256;
	cv=none;
	b=FAQtoAhyR9cP7kY1RPt2OaZY+3PVmmbkPgCarRSeH5iY6j7kysWg5lJGvdFY+5C457sr37
	zYYvCTSKiwqYjrfv0mHlewsa0AXtcCKVLvfl+hyx+Xc+gNphKPmW+z1HKhn9+vyX+Sk6Aj
	CF41gKTXdtJs1xSUWDShjGd9AWMk0zw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776430655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bR2LlG2Z9OwJ3IbsfdJKwXcRLEurdguo/ZlSUV0sDIE=;
	b=CMhwdnQxwkA09C1SGpyvbJBS0VZEIozchpoUPcP6apPIkwb54f2uvWCsCUmGiSt5ho+c6F
	RLV2dIVvYxN9BtxF1zuiT0f7pzp2FWhVjv7BFPEbrPomjVfBA0qvvj6rzYAEBIkZcWCtc6
	Cg6nF0Omr4grpFIFtYtbn8fcuBe1r4g=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-pg_Bw-txPW-wp0x_yi7hhA-1; Fri, 17 Apr 2026 08:57:34 -0400
X-MC-Unique: pg_Bw-txPW-wp0x_yi7hhA-1
X-Mimecast-MFC-AGG-ID: pg_Bw-txPW-wp0x_yi7hhA_1776430654
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8aca29dcd69so15876376d6.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776430654; x=1777035454;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bR2LlG2Z9OwJ3IbsfdJKwXcRLEurdguo/ZlSUV0sDIE=;
        b=ssxler5m32aDpaZu34LmVgUKw73FZ/bwQ2KxJN9DcAm2CvGJFIjwtZytNZ84T6PKFH
         XGfBObz9gVXVdw2h38r5GVIfFvtjBC6kEb/PZhC9BZXEosBoxYa7UN33x+9HaK2iEzL7
         xIKqbchWlPi/uXVEdqRABywAStgBJFfDrzPUJnGbqmS5ph3McDpJE/MmberNjxreEtWx
         qwEc8p29YPme9IFipc21vjAwdVnQx7o3QoTKXDIXBh/dHcD1savFeBDCxZdLiQAGbJOq
         H1vE104k2xT1x+tlRe/R4iqyrqEKmFKPOUBizOK8qCZMczeIpXdEFQOb4o1PKr7tYfi5
         EiDQ==
X-Forwarded-Encrypted: i=1; AFNElJ8BCoHh+PXEsZ6ii1sa+20fk8H6gFHjrRhhzviKwteOGHVM0qvW+QniIssQyVX+Y9BkfZ5N4R99kw==@kvack.org
X-Gm-Message-State: AOJu0YywWzkwir/yNSFAH31x6iOQTjpYALbqpKvsvGNE2UGcpQtGXISC
	1qavQoypDnNZRFfuWO2LlGEabMcPWQpt/8QT9luz5l1kmNvi9Q10lkSLIfg9olun/Nz6nVZmE9e
	56klVPgczmWrimN/jWMAJB849XwB+qBLr0Re6NRADmEqsft2/cJEL
X-Gm-Gg: AeBDieum5AppYWzV/hdrpvPRs+Q+03oqx0IdHO6BAU5MuygwfRPQ2QHQbSImbN5jxjt
	zADVnQl3Hi9Eq9F5wQ+E6TS9+0csrd+CwIz8FI3ktY1y2Ttai7M2OP4yx2AdeyV4+TDTzI26+f+
	I/cWn+tibbI0KF8lgp43Sx7DKoephNlX2Zm4CALxhuXvQieU/zDsqADnTGs1QQmhH7fIl8Ktk+V
	qMn8YzVUWlA2A9lLuhQ2UPlHmco5fqCVdH3+oZ3Y/7nsxASY9yR8ANbVHuLklooCmNb4F/lBsKw
	ervcRHU0/YUHdLRa09R2S5rp5LsIimS0KcepZ66gDUOJRUwdr+SPH2a1Il48g90Xi0/oHn/Ddl+
	keNIaWrb53gC7fOOhpf9y07zLJrnkwGfCYAag
X-Received: by 2002:a05:6214:acf:b0:8ae:5fcc:8069 with SMTP id 6a1803df08f44-8b02813d122mr43680226d6.22.1776430654227;
        Fri, 17 Apr 2026 05:57:34 -0700 (PDT)
X-Received: by 2002:a05:6214:acf:b0:8ae:5fcc:8069 with SMTP id 6a1803df08f44-8b02813d122mr43679756d6.22.1776430653673;
        Fri, 17 Apr 2026 05:57:33 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aa4f1f9sm10565916d6.0.2026.04.17.05.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2026 05:57:33 -0700 (PDT)
Message-ID: <988b8af9-1966-4f74-bc40-35685be7d53f@redhat.com>
Date: Fri, 17 Apr 2026 08:57:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] mm: introduce pgtable_has_pmd_leaves()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lance Yang <lance.yang@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, dev.jain@arm.com,
 baohua@kernel.org
References: <b65d560458b2488f715b5afc1603d786e786ccf7.1775679721.git.luizcap@redhat.com>
 <20260410081938.51302-1-lance.yang@linux.dev>
 <8a0b6d67-121a-4ac8-a74b-737d52d8b7ac@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <8a0b6d67-121a-4ac8-a74b-737d52d8b7ac@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j7T965V0xG7pAjUhttJmeXMnnBwSH_c-7pxZ90Gioko_1776430654
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aqsmeatini8nwxf5eqqkxci38up3rzxt
X-Rspamd-Queue-Id: 75CA940010
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776430656-19093
X-HE-Meta: U2FsdGVkX18m+vwizVBnIKk8M71w9bQ7wYdJHWTd1G8Y1ToNln0MtuQZbqM/dAHGkt2z1dLLANpl9C6EOeCCxUOsgLsAyvx3CZ4Y2nO321749c1oqZF+LSVk7mBoLmdPOWPwZZM3tBF6z+7PmN8N0+aS3QeQQD1HT00lcMVVmQKvQacQr9Xg6aFkR5kogvY4wVfCax9BvoPsbrSK7zg5xclxIDxUsaXTh1EJK3IbFmxM8quHAjnqsNdpjZA9zd3kQrOdLJ/JaRYf4u+RNIS2PVjs6DFr/PNTY0AOl0a6diKIOTDN+l1GxjDGFf5PJQMAItVZ0XJhgPZ6fK1YvXalR6at908JdMftoFmzsuiazOSDVuU5JirS44sh8TS54v/dPXmCCq2NM8/EtbOJirgFlt1+HLxHwXhX9Mbs98uXXKs34rZPe9oPCbBRULS5q0a29XKHxH6Gt+nKwzd6ETQLKAluSflK3LFGrXRBGaRvA1SAIF01PhA0U5jx2ZozjIAU8s0CkqX/Xw0ExRm1otbhuXd8Vm0GsnqxOJCJAob/uswfZR3pJNuBl+yukFbbZE8pD6IcaHuGY2FdkKOAotLDq9NswhZTgT8aARQuHWFAAvY9Y4i7QTT+AogQGpMqY1dN/vIlVqrevmx4ByeZg9zoR2Ybb4AxQ3/Ua5fsSGR90EdlbYsBET53uMyxQnYKYdGm+CDyQnarm1Gzt/7NNyWI/SQ/Cdw/iAd3pChX3pD7AeGa8dV4exnMudzNpTOQ0qkBFp56v8KPNh11lpcw8sA77mVU+duWjSSlR9yut/6gsvOqlqGcMQFfJO5iDXPOl4T7KXXGx4ugoTmKDinlbphQrTCYEFODRr2DSCQf3jBt7uhT4Z1R9cdeB6Xpuz/XmmwBiZIPQb7WSpKKLhoU/DsBf9ilq99CgZc2tbHFWsMroIFfCEB2GIe5TE6FVGjCKSJ3dFNZOqh9KrFA56AKvNS
 u7oRJGdu
 6i0CyVFjBUkFRCQHR7ruMjL0w6pO4so2oHtokWoaw4k0XYNXGMG0vwmUp+XNv0MUnb3SL8Ar6ePrOFYlVTWO1CGKEkLiMttr6J6BQhzwellFYo7GEFpxBHrejxjSx0G5+bzb/C/kM1b4DpFsBOxoIKKCoJIwm7vbceMWDADtIyrpiWIeXF9XmIEMYl1XFEUDj+MpTihRrctK8QFyOdjQLW9ZZIN23SxJ5YhpLv0Q0VSBbEfFXgPdNKQZfNNNEsSLG4zI2Cu/kSIQ/iko6Qp42v0QNcI79P9qmtm4dWEmyfJ7MVzLI3yK8w58ZxW5Bn2lfydHz2t6h1/tH+W6GCZ1bTJlRegpXrAeeDdMukgoAcwTrXM+XXCwBx7vCNi71zQIqhkdDxA/FSBdw2fNYsvWT1MNTxcDiejLa5lo3RWTl+TZuo24eq9jbrkACm5mJZjWkdsc9jI5pYxrIWMOqMnWeuwenCqzKEmYSxUP/xvLy1ynR8X9Nm9nAaLa5dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-17 05:57, David Hildenbrand (Arm) wrote:
> On 4/10/26 10:19, Lance Yang wrote:
>>
>> On Wed, Apr 08, 2026 at 04:22:57PM -0400, Luiz Capitulino wrote:
>>> Currently, we have two helpers that check for PMD-sized pages but have
>>> different names and slightly different semantics:
>>>
>>> - has_transparent_hugepage(): the name suggests it checks if THP is
>>>   enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>>>   implements this helper, it actually checks if the CPU supports
>>>   PMD-sized pages
>>>
>>> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>>>   by the hardware, but it just returns a cached value acquired with
>>>   has_transparent_hugepage(). This helper is used in fast paths
>>>
>>> This commit introduces a new helper called pgtable_has_pmd_leaves()
>>> which is intended to replace both has_transparent_hugepage() and
>>> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>>> it returns true if the CPU supports PMD-sized pages and false otherwise.
>>> It always returns a cached value, so it can be used in fast paths.
>>>
>>> The new helper requires an initialization step which is performed by
>>> init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() early
>>> during boot in start_kernel() right after parse_early_param() but before
>>> parse_args(). This allows early_param() handlers to change CPU flags if
>>> needed (eg. parse_memopt() in x86-32) while also allowing users to use
>>> the API from __setup() handlers.
>>>
>>> The next commits will convert users of both has_transparent_hugepage()
>>> and thp_disabled_by_hw() to pgtable_has_pmd_leaves().
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>> include/linux/pgtable.h | 15 +++++++++++++++
>>> init/main.c             |  1 +
>>> mm/memory.c             |  8 ++++++++
>>> 3 files changed, 24 insertions(+)
>>>
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index a50df42a893f..c4c5282f795c 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -2192,6 +2192,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
>>> 	}
>>> }
>>>
>>> +#ifdef CONFIG_MMU
>>> +extern bool __arch_has_pmd_leaves;
>>> +static inline bool pgtable_has_pmd_leaves(void)
>>> +{
>>> +	return __arch_has_pmd_leaves;
>>> +}
>>> +void __init init_arch_has_pmd_leaves(void);
>>> +#else
>>> +static inline bool pgtable_has_pmd_leaves(void)
>>> +{
>>> +	return false;
>>> +}
>>> +static inline void __init init_arch_has_pmd_leaves(void) { }
>>> +#endif
>>> +
>>> #endif /* !__ASSEMBLY__ */
>>>
>>> #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
>>> diff --git a/init/main.c b/init/main.c
>>> index 1cb395dd94e4..07f2ddbf9677 100644
>>> --- a/init/main.c
>>> +++ b/init/main.c
>>> @@ -1044,6 +1044,7 @@ void start_kernel(void)
>>> 	print_kernel_cmdline(saved_command_line);
>>> 	/* parameters may set static keys */
>>> 	parse_early_param();
>>> +	init_arch_has_pmd_leaves();
>>
>> One more thought here: I don't see why we need boot-time caching.
>>
>> has_transparent_hugepage() does *not* look expensive on the common
>> archs. On x86, it is just a CPU feature check. MIPS is different, yes,
>> only the first call there is more involved ...
>>
>> But if we *really* want caching, couldn't we just do it lazily instead
>> of adding another early boot init step?
>>
>> Something like:
>>
>> bool pgtable_has_pmd_leaves(void)
>> {
>> 	static int __arch_has_pmd_leaves = -1;
>>
>> 	if (READ_ONCE(__arch_has_pmd_leaves) < 0)
>> 		WRITE_ONCE(__arch_has_pmd_leaves, has_transparent_hugepage());
>>
>> 	return READ_ONCE(__arch_has_pmd_leaves);
> 
> Would look easier when just using two booleans: "has_pmd_leaves" and
> "probed".
> 
> I do like static keys, though. And wonder whether just putting that into
> hugepage_init() would be sufficient?

Do you mean the static key initialization? I think it's sufficient today,
but we'd be tying the new API to THP and the initialization ordering still
occurs although it's indirect.


