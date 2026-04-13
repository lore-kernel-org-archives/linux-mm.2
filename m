Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA0AF34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 334086B008A; Mon, 13 Apr 2026 11:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30AAE6B0092; Mon, 13 Apr 2026 11:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220946B0095; Mon, 13 Apr 2026 11:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 159FA6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:39:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CCD0B7141
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:39:45 +0000 (UTC)
X-FDA: 84653942730.20.3691A3C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 18616160003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:39:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JhZtvl4T;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776094783; a=rsa-sha256;
	cv=none;
	b=lM0oEiT8Ick2isRoCM0/wzm3JuQoCs9sUUmyotIfixFlH80KYFiB4w9QSKFTvZvieqetgv
	dXyWj5q4Uh96uXUXRubFaeBBelZ5r7acf+9ptL2mnyth2dYsmgVfon210sBy2clhvLSF4H
	/iX5i6clFVl7mspk5Bfr5e85vjudRQo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776094783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHZkKQhb0KBgrbbqGFooXSKLcTZ9GYrV66wxni4Hy6I=;
	b=iEwuvhm/kWZvcWt/kKUbgnyzgnh4zqHDVlWkFw19UT4fySpcsNZKHhlWwywlHCKmDTkgZO
	KKgr15f29uMJOTdW/HjCSi2PLyKiSlqlMPf4YcGIxXqxUIOlxloyoJE6hZW+q294MO797h
	DoDNWFZvUU7+E6o8fznjty0PkNMzqWE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JhZtvl4T;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776094782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LHZkKQhb0KBgrbbqGFooXSKLcTZ9GYrV66wxni4Hy6I=;
	b=JhZtvl4Tu4UlXt1hdjn53JymKYeafIwKkbKi234MTAXblvDUzcLZDR231R0pBL8yV3LXJX
	4lJp4XiUiA8+04WDELidEX2IeEafnAIPJtPxWphQEym2iWyY3gWtBJ7gy5TYXYwOzJKAIa
	h4NjAT/9zyEJQfXpyGln9oZxygBbxQY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-mn391iUYMn24gIs6Qjwgdg-1; Mon, 13 Apr 2026 11:39:41 -0400
X-MC-Unique: mn391iUYMn24gIs6Qjwgdg-1
X-Mimecast-MFC-AGG-ID: mn391iUYMn24gIs6Qjwgdg_1776094780
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cfc1bc572cso812078685a.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:39:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776094779; x=1776699579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHZkKQhb0KBgrbbqGFooXSKLcTZ9GYrV66wxni4Hy6I=;
        b=GQ8rInjOxWMjaO7RVUKuOitJ15IHTiDPzkm1zisuXPx9A3cnvz5CS2mcIBUQVSQ19S
         l7Gsp2d7h0KFDzx+Pt9HF3AYAf5uPvr1Xo30kepELsU18sJ1suUkkvPoQnw3MzITO5Tu
         CR2KBRpwfFl2RhCObZTjcgOxMwPLaBYCJeHEBMlo+dtMDPwPSZV7hI3MAXDrcys378hw
         ppr8WCD/t4d66PMHhQoqkeQ9zoRl7KAqPUgpR2zWXLjHTOUXDfkI+4dKXXDZ/h69OE4j
         AkmI0vdLF0Y/SpecFU0vvbvdfi3CRvj0ba79f7ABZBOs6/jhvNpYXJOB1IXzGLtN/8Lw
         WuBQ==
X-Forwarded-Encrypted: i=1; AFNElJ+6J2qdybiHSMAdCdHi9EED/klALOdUsO0t5G39uhH2vbpeBjC6OC+grLGEXb1uSo9+9b2nPDKVRg==@kvack.org
X-Gm-Message-State: AOJu0Yw3Fuf2aQbZ4XiWsFG9IRrY7T6uUr+4tD6X4XHbR/EwpRDIItrj
	kE+q/tWSG9YnHQzpWJrESEAqF3olCRtbj2TFltvqH1xwkpyG9pvLvXZa2FLQSuNlJ/PJllrF4ou
	JlEl8YVzeDxwpC1KHYsSuuKQKFWQ66zUd3Qps25AQavzNz+Upo6ksdnuME+ft
X-Gm-Gg: AeBDietR6CzIzrOBkNHjoZUNYM5rVG/MKAiW6CnOTee/mwGyPZOrrB1ypmOys0+/xFo
	3hxQLtsqQweUvUTQQwBMv6NJvdtn+nUusflprNX2qRd5ar5ta2VXqGcNVWTKZkRhlse3o6WPGs1
	1jugNGIFp1uNFHj2x99MwK/G/1wRQOgvMvS65zVSYHqejw2Zu3MdJTLk9kVTaxTFgmCc1wHpUoV
	U2vkXWV5bhSOCIVqvJMyEuoJ0ta9X08GsQuLmitYVaLGntUx1kpDqKDU2v/5pab8C/jsJSgtqy3
	MnL2hg39L2WGnPfFLONHIKaWKL/UqSp1h8d2YVlW9yfSecfPflD5EAnTR/FApMw/Axlo6nVm/o5
	ooTKowbHrSyU0sBs5xIfaR+x2GQ==
X-Received: by 2002:a05:620a:4688:b0:8d7:f950:ea4d with SMTP id af79cd13be357-8ddcce2b2camr1911697685a.4.1776094779476;
        Mon, 13 Apr 2026 08:39:39 -0700 (PDT)
X-Received: by 2002:a05:620a:4688:b0:8d7:f950:ea4d with SMTP id af79cd13be357-8ddcce2b2camr1911690585a.4.1776094778787;
        Mon, 13 Apr 2026 08:39:38 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb646d715sm856838885a.15.2026.04.13.08.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 08:39:38 -0700 (PDT)
Message-ID: <87f89b9c-002e-4210-adbf-f24201797ccc@redhat.com>
Date: Mon, 13 Apr 2026 11:39:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] mm: thp: always enable mTHP support
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1775679721.git.luizcap@redhat.com>
 <6dea717fe8c86003e7da33c9a7623b834649d5ee.1775679721.git.luizcap@redhat.com>
 <5e653a9b-9265-4bfd-89ce-f0fbe0df2ae6@linux.alibaba.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <5e653a9b-9265-4bfd-89ce-f0fbe0df2ae6@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9RAsLDzAES7lsUz2SONHm1-noPjgv9KdL3kuutWXOTE_1776094780
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 18616160003
X-Stat-Signature: p6rgmsducp9f5uhyz4ar39rcoeytc6qq
X-HE-Tag: 1776094782-261248
X-HE-Meta: U2FsdGVkX18k5WCx/0Ga+J6QO+76kFd9hLl8H94yp/wOPT6xCo8U1JRa51H0WrnYa90u/D5VyHqfUccTFGQqlnPaea4dP4dPBUJX7JRrFArhY3ELl3EsV3rORLsp4CEMw0zgwG3LWuJKxQG2wV+VHCZbOqVQx8R8n9DJe3/ibNsOsOVmrsWBCSRGja5UA6NODh8uadFZ3ws8tYhpJ4Hvg/0l1qUSs8MhDEw/q95/sDlIEnPkCobxla8yth+dsTuT++96keopp6DS54GPE7JqnOjP/dwfDcGiDmjfnW2VFpd7uYqCqhmcV+2cUF3FXvS19LePXm05+k9pklGKncwPLajGjqeYoiCNccKQrZSMWc4exPN+yuEbqX86qB/Wo9Dii6TUpftQ3Q/JtlpPEtejomtcOCs63YUcLUl5I3lpqEJDsFkocOLwv3v02QxoS7kv7N8/BLz6El9cUEicyTZ83Y9gbrKZjQ4ExPXcJUfvskNKCffrgd/Vam7oQ79PSBaszEMuZSXvQsr+9AstLs2snNOQYHTnZZy8KMNl0tdxSK96wELtqs9M4Q3aqCHVJ7EXnjGBlU9qbdgMWqqZHOvRBxSWly6W3816S5ekdCd7Ph/LBibfJnx9gPPPPyUqsQZT2H39FJUVr9Txya2vgY42uGH1gEuDzOrGuxgD4s6wPQtagjJ3IYzX+CNEDBxz3M8PyoYOrISBo6g/V2IW0Ul1Ttsax/NqRP3JdWazHnOWwr2cuT7fL35csFZsC7t4bgL9KejIib835n/UuojQMHo6ZfqKLMt5Wp9B4i7cZERqn0XvZfe5IIh9/AwlpGpx3ldn8NuCNFro6bBLodwLiN5xs44gv66Nim1INCf0K+ZZP+xPzHCZMAvoJqhdOe//kw0dJm84Y0EIddQd2ZQmlxctAHHfYfcYzRpBCqHq578yNw6x7+XhNOpVyhRe4mpU/dmwo/PCchk7j1saDH/niEq
 JS2uADu1
 MjdnxEuI5BqQ+wOS7kwAUac2ZrYKDi4XvUJsIbG376tDEfvgikvLFnhVIbKFt+dtv6Kx+FXuGBwRKmy0mOhF5bVQ68BkdOnpNmCa7VW0p5WLpOTIAMeS4uGDiO7Uqrr5NVL74O/l9DAeKzeU7k2A7TcLP1V90dU+0BjbpLYMK3hTyCgmno0xFQbW4DZIMvx2AU9oWkzE9Co1z1O/0Xl2EqLC2vQ60Im7DWIrX53PM+g1y5uMSzJtw46Ur5E/++sB8yCrGM2ehDYdo5hmyjcHXs0qhBWg9qeFGEDOhHDnzNpLwxkIaDe40Tz7Uhr6nS8pUH7Szh3Oc5ayXGksMXb/+cWxYnX+9xs5Ls+ZX425Zr0MNamKjxJVHeqb1lTvKCOqnHMA88+O4SxPWsoL//PzKi+FujrcvOPU6XQG0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-11 03:22, Baolin Wang wrote:
> 
> 
> On 4/9/26 4:23 AM, Luiz Capitulino wrote:
>> If PMD-sized pages are not supported on an architecture (ie. the
>> arch implements arch_has_pmd_leaves() and it returns false) then the
>> current code disables all THP, including mTHP.
>>
>> This commit fixes this by allowing mTHP to be always enabled for all
>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>> created and their mapping will be disallowed at page-fault time.
>>
>> Similarly, this commit implements the following changes for shmem:
>>
>>   - In shmem_allowable_huge_orders(): drop the pgtable_has_pmd_leaves()
>>     check so that mTHP sizes are considered
>>   - In shmem_alloc_and_add_folio(): don't consider PMD and PUD orders
>>     when PMD-sized pages are not supported by the CPU
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/huge_memory.c | 13 ++++++++-----
>>   mm/shmem.c       |  4 +++-
>>   2 files changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 86e489c0a150..6de3d8ebc35c 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -118,6 +118,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>       else
>>           supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>> +    if (!pgtable_has_pmd_leaves())
>> +        supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +
>>       orders &= supported_orders;
>>       if (!orders)
>>           return 0;
>> @@ -125,7 +128,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>       if (!vma->vm_mm)        /* vdso */
>>           return 0;
>> -    if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
>> +    if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>>           return 0;
>>       /* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>> @@ -787,7 +790,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>>        * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>>        * constant so we have to do this here.
>>        */
>> -    if (!anon_orders_configured)
>> +    if (!anon_orders_configured && pgtable_has_pmd_leaves())
>>           huge_anon_orders_inherit = BIT(PMD_ORDER);
>>       *hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
>> @@ -809,6 +812,9 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>>       }
>>       orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
>> +    if (!pgtable_has_pmd_leaves())
>> +        orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +
>>       order = highest_order(orders);
>>       while (orders) {
>>           thpsize = thpsize_create(order, *hugepage_kobj);
>> @@ -908,9 +914,6 @@ static int __init hugepage_init(void)
>>       int err;
>>       struct kobject *hugepage_kobj;
>> -    if (!pgtable_has_pmd_leaves())
>> -        return -EINVAL;
>> -
>>       /*
>>        * hugepages can't be allocated by the buddy allocator
>>        */
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 613393eae5a9..b49a30475cb0 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1839,7 +1839,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>       vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>>       unsigned int global_orders;
>> -    if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
>> +    if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>>           return 0;
>>       global_orders = shmem_huge_global_enabled(inode, index, write_end,
>> @@ -1947,6 +1947,8 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>>       if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>>           orders = 0;
>> +    else if (!pgtable_has_pmd_leaves())
>> +        orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> Sorry, I still don't like the changes here, because shmem_allowable_huge_orders() is meant to determine which large orders are allowed. Something like below (untested):

Sure, I can do something like this.

> 
> @@ -1834,6 +1834,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>                                  struct vm_area_struct *vma, pgoff_t index,
>                                  loff_t write_end, bool shmem_huge_force)
>   {
> +       unsigned int filter_orders = pgtable_has_pmd_leaves() ? (BIT(PMD_ORDER) | BIT(PUD_ORDER)) : 0;
>          unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>          unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>          vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
> @@ -1846,7 +1847,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>                                                    shmem_huge_force, vma, vm_flags);
>          /* Tmpfs huge pages allocation */
>          if (!vma || !vma_is_anon_shmem(vma))
> -               return global_orders;
> +               return global_orders & ~filter_orders;
> 
>          /*
>           * Following the 'deny' semantics of the top level, force the huge
> @@ -1871,6 +1872,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>          if (global_orders > 0)
>                  mask |= READ_ONCE(huge_shmem_orders_inherit);
> 
> +       mask &= ~filter_orders;
>          return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>   }
> 
> 
> Additionally, we also need a pgtable_has_pmd_leaves() check before setting huge_shmem_orders_inherit as well.
> 
> @@ -5428,7 +5430,7 @@ void __init shmem_init(void)
>           * Default to setting PMD-sized THP to inherit the global setting and
>           * disable all other multi-size THPs.
>           */
> -       if (!shmem_orders_configured)
> +       if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>                  huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>   #endif
>          return;
> 


