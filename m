Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26511EA8114
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E5B6B0005; Tue, 10 Feb 2026 08:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525B66B0088; Tue, 10 Feb 2026 08:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431BA6B0089; Tue, 10 Feb 2026 08:28:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 318276B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:28:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1E281C21F
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:28:36 +0000 (UTC)
X-FDA: 84428626632.06.DFEFAE1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6529F1C0018
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:28:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BXkYspqr;
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770730114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l03HnZXbsOr3bfTMcnwfLvCVQcb4y4TgKk1IHdA354w=;
	b=h71YSEWON+HyCrVM+VfPS7TW1q8vl0DMRCub2csELTTSfZ9zFN76/coyzj8yRuCgac883K
	D1Vqz5cfzXgUf/vca+wtTY7aGQNZVUGZk95iDGaqpciAv5H3yN4Ho5akgABrd4G9ghXcaM
	yatl2VZV57PwemOmm/uOxLoeHGARXzs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BXkYspqr;
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770730114; a=rsa-sha256;
	cv=none;
	b=wd0K1M93NsH8x2D9geYfsWrzdFGuaDoKJyYy0Qkgxjjd1l+osg/ZlucQER6oSYQp0ap6J+
	8X1GYIGNPKgtxm0NpYB7DdG9N53NffOmCiy25oeCcHeVt3jIefXkBuUBRwHlYoYH61C+rB
	ez67ZVmgDnVmQLKJfPFlTVhmQZDOA9M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770730113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l03HnZXbsOr3bfTMcnwfLvCVQcb4y4TgKk1IHdA354w=;
	b=BXkYspqre13wxC8n8CTHEbpL5sscVK2NFHYatd87YKwqygNEhjIodHXE3DUMY7RU1N3BDL
	QxNP/JH4Vs+8jbTao0A7agCznkWTOSIIbhHsmLmOZparqqq31ehkULSgDORQPj2QOb+OEI
	oXc7oxebhUqEAHqmQIkgCTuFVY6Jr60=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-J7HbQg95PFiUOs7eZi_ARA-1; Tue, 10 Feb 2026 08:28:28 -0500
X-MC-Unique: J7HbQg95PFiUOs7eZi_ARA-1
X-Mimecast-MFC-AGG-ID: J7HbQg95PFiUOs7eZi_ARA_1770730108
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5059656723eso190909991cf.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:28:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770730108; x=1771334908;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l03HnZXbsOr3bfTMcnwfLvCVQcb4y4TgKk1IHdA354w=;
        b=kTIaz+wnyZCCm4UwHLAx51s0iWtS5BvPFswo/PLsoaplgMyepvBdfeA5KqUHjfQln2
         pOjkVftgdYQggBLwmusdCTLNVkZ4dtQvsSUzR3gC7BwUjKh5nbkG2P8tBOw/4byBabQq
         JlCXdHdoKMTEHcfc7U8fZw9JIsnniEA5gX+ekLUVisJ011Bi2Qxj8fItQP0Ya4ERnU/+
         TAZjXo98l52s7ITLIgci8UqPZpQL3SLgkFgQUzspdxcVC4bmDKJfXOqTkuwQk2OPxDdM
         xPo+lnI3eVDWKXFMFpKJQRlJ+0dSm5r/PLoHkMLkVYmmZnAV5/7m9HVLix68/tA7gi7V
         Op9A==
X-Forwarded-Encrypted: i=1; AJvYcCVo63Tlejhh8SgMVu7J+YJ59MUNOn1+4pmJ1ufBr+0/hIvv49sjJUC0tyoQrXxRtY7bVkAotli8iw==@kvack.org
X-Gm-Message-State: AOJu0YxN3YfDs6WCxdqa8R5QiPiN2UqMdpjfxod1EJ80jUqaKaS/ebEW
	S1L6fC5fFuLzvsBCNOC9x2FPFJetI0dxC8YK/j0tndb8isG+QvfQKX2f4yaFUO7BbSchSc0RQ3B
	tnZJTPiVXZhMkZlPAFltIINHnfqF7jOMaTEJfhXj38bnekoPfyCqJ
X-Gm-Gg: AZuq6aJBIykiogOj07whOK+An/lHdCiorm3Ep3FWbHvyZhrixOY0B2lypesrr73Sb5R
	32MAtMEQV05zxcNbNnCsQBqtEUFBPgYAgW/NGLGjaziU1G02C7MyDXgDHelKVu49lN0suRd2R6P
	WjPAP0JtJXSWr6mgkrfMSR6T7Whtyfzuo6UZ8BmI2yzH4+ZmaDOYPM2euSQPYwhNk4PsWv0dNIW
	ld34CYXoJ5awDw8YmodnqfyxhymAzxEWuN5uoBJwr5tq02uCNZ8R/nPT5Q8WA9XrVTIv8d+B8pm
	+9zBCMKqiVPcqUnBzaSchyL8SbdenXpVwDlSkG5oH2rDyUEotbYP8dQ6DatUkXo82r8b61/gbkp
	4ZKz5/geq5ONLBrkJpgpoB3Y=
X-Received: by 2002:ac8:7f55:0:b0:4ee:c1a:f11f with SMTP id d75a77b69052e-506399e4b33mr199812691cf.84.1770730107821;
        Tue, 10 Feb 2026 05:28:27 -0800 (PST)
X-Received: by 2002:ac8:7f55:0:b0:4ee:c1a:f11f with SMTP id d75a77b69052e-506399e4b33mr199812401cf.84.1770730107444;
        Tue, 10 Feb 2026 05:28:27 -0800 (PST)
Received: from [192.168.2.110] ([76.65.77.217])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8caf9fdfa1bsm1047769185a.45.2026.02.10.05.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 05:28:27 -0800 (PST)
Message-ID: <0c0886d5-2561-40e4-94e9-6fca15f25127@redhat.com>
Date: Tue, 10 Feb 2026 08:28:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/11] mm: thp: always enable mTHP support
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1770675272.git.luizcap@redhat.com>
 <29e8dfc2772af4b6e0db24134ca3563ec422b91a.1770675272.git.luizcap@redhat.com>
 <d2bc3d79-5d00-4943-80bd-01b144529177@linux.alibaba.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <d2bc3d79-5d00-4943-80bd-01b144529177@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aN9DsbBSsvDyNinglysF7JEAljJL8S3vxLa2Mmleeeg_1770730108
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6529F1C0018
X-Rspamd-Server: rspam07
X-Stat-Signature: n9wxhkhhu5eq5sdtoqwf4zoa8o7m1nzn
X-HE-Tag: 1770730114-299307
X-HE-Meta: U2FsdGVkX18b8+WFIwQdEJC/PRx08rCYDkXlksRMEjdwB8DPwfvbNSZ8gZjNjQR8Bg8cqbgSElARoIkXNjs1In7AB2yMw87XuXA3gs4Aur53yNBmuCZ0mMbErDQY8T/DdlXeU/dTOcCBP6fxHyVfWNYWEXP77Nmew4bCxKR5PymIW0KDaAXHcRb6OGTZLdhXhJPF79hDQipiCadI060ePLkqMHpRUckPjLWzSRDZCRuIJe19nrmBQu2TRcfOXQ65tjzO9SWpsZ3k84Q5lYmVee+ky1ZhiDhfZxwUpVlktBXtnwlkCvi4MUWcFvkDjeli3H9sAjQnV8gPyBNWB0w3zlX/4rQ7Qq65Y/wdPfcxZct+4bCFW41aCF7M7K5ceGjE0c2kwTBEX5kVhBIiFh+h7IAmfaR1GfH88SLqKPeoCEC//i7H+/5oXYqH6002gk6B+j4dNrMM6ND2kRZU9ZI06W6xCeqnfGumwGzuBQ+0IREUmgXwfwj5z8cSmUpkBbvQAYAD4H3tXKQGqSBKcqhZr/NfeOyGarLqghG+zrisuUAJKqy4076ImtLcWlsJmozUBiOue5D2ipLgbKNFSMfr4Zw6ZZrHA4e5ILaoD1nUCrHpsmf8VW1plVzrnMWYPGr5wLerkh/o7xdwo0mXeSXDHH7LnVGgQNt6sGsRIFp04yiHTj6x21wY/EkNAE1UqmH0AEgZHYFrwB3XdS5JRgrJH8+sH8h+kFIiMicoilELilhx3y/eE1mgEFaAAy3tjIionrFz1kdO+Ok0Ld6XTsp4RgwP386XjpFe5UJP9l0BSxqbfrI/ARDOAHfw4bgH5DXaLK8onpemqlyO+Qc7OnL6Qqd8DH8ufVV5IG80GY1KfqFV/pAqXyR+AjtFIeuP5YuXPF8bn2zU8E2fk5LIcVZ7bpz1CpAXwJzuZBLKJri0ccjM+GMqRiQUhfZ89V7lUDEy6Z85vS3M6lbmgARv2DL
 tUXxZzek
 LDD08z65fUAZIXeDARrJ3IMz/wIPxjdKuYeJ0xMK67uTP9RmXvKHP6bLfkVzgSPiX9Lq/BYLZPhpjGVTlNZW91NqUclLWN9rpmDIfCPs+1TXLqcdnhyqTTIBgMbK2eWyCJKksN1wVyLZypaiWay3Carid/O5UWyJyk23iZXaUR2hHxoVl0VxDCQz1X+a0Wo2xwxKkQBV0ktakDNA3afV0mNqtPpy5D6yvPbJTZBBURTcBC9fbjMMuuBhzcLfaORliyqB9nZu2BnNbztIpbrWSXxugJPDYSBo6WlZ1ESvwlQM6R1Sq11CyaSgVAfYdmH4oESrjpfFQRH6YB/m/lRfU2PjtHbLqLL7Wd7N4NTVbMf13pnFlefg3mY3ymSv/z4ZzQOCAFMnWc/D5mWMnTNjJkEG5Gp3AChNOzHuM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-10 04:56, Baolin Wang wrote:
> 
> 
> On 2/10/26 6:14 AM, Luiz Capitulino wrote:
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
>>   mm/huge_memory.c | 11 +++++++----
>>   mm/shmem.c       |  4 +++-
>>   2 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 1e5ea2e47f79..882331592928 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -115,6 +115,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>       else
>>           supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>> +    if (!pgtable_has_pmd_leaves())
>> +        supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +
>>       orders &= supported_orders;
>>       if (!orders)
>>           return 0;
>> @@ -122,7 +125,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>       if (!vma->vm_mm)        /* vdso */
>>           return 0;
>> -    if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
>> +    if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>>           return 0;
>>       /* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>> @@ -806,6 +809,9 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>>       }
>>       orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
>> +    if (!pgtable_has_pmd_leaves())
>> +        orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> 
> I think you should also handle the 'huge_anon_orders_inherit' setting in this function if pgtable_has_pmd_leaves() returns false. Shmem as well.
> 
> if (!anon_orders_configured)
>      huge_anon_orders_inherit = BIT(PMD_ORDER);

Good catch. So, would you agree that should set it to BIT(PMD_ORDER - 1)
in this case?

> 
>> +
>>       order = highest_order(orders);
>>       while (orders) {
>>           thpsize = thpsize_create(order, *hugepage_kobj);
>> @@ -905,9 +911,6 @@ static int __init hugepage_init(void)
>>       int err;
>>       struct kobject *hugepage_kobj;
>> -    if (!pgtable_has_pmd_leaves())
>> -        return -EINVAL;
>> -
>>       /*
>>        * hugepages can't be allocated by the buddy allocator
>>        */
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 1c98e84667a4..cb325d1e2d1e 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1827,7 +1827,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>       vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>>       unsigned int global_orders;
>> -    if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
>> +    if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>>           return 0;
>>       global_orders = shmem_huge_global_enabled(inode, index, write_end,
>> @@ -1935,6 +1935,8 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>>       if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>>           orders = 0;
>> +    else if (!pgtable_has_pmd_leaves())
>> +        orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> 
> Moving this check into shmem_allowable_huge_orders() would be more appropriate.

Will do.

Thanks a lot for the very fast review.

> 
>>       if (orders > 0) {
>>           suitable_orders = shmem_suitable_orders(inode, vmf,
> 


