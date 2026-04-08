Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B4D105D9BD
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836306B0005; Wed,  8 Apr 2026 16:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7DD6B0088; Wed,  8 Apr 2026 16:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5F36B0089; Wed,  8 Apr 2026 16:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B65B6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:38:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D80414021A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:38:06 +0000 (UTC)
X-FDA: 84636550572.21.1081A59
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id AF165C0008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:38:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fgb2OH9K;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775680683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjYnu4owpf/zaSuq0bbFHdaqsldn4LQ2NanTgIzt0b0=;
	b=KBtWJG4NaYuezoy0qkGlxy8ardc/9zZdqyJAv+RKMSVNFXMsdwOoyffeVo3C23oYJMhgUq
	QZMRv8vS1kXlabmHr9HMuP6Ld/ApQkXTQ9dxJZvOYrNoEE3n+eOqex85xrEYbtPRO3Jxvz
	9E80IsyaFWUfnWPy0wrQqo0klLSZxgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775680683; a=rsa-sha256;
	cv=none;
	b=3Tm24n1I0q7ppGxyotDjAZ3E9Oy5CboBQ//y6bJ7EgXZufBbZe8ioe7JDnCHXeYK4qhcGY
	4NhZBtmENDHmAY3PSqr80PF5wwMJ6SiBf4ZVliSfpem13yHgEboeBwTgBZeYgU7XxRhOfr
	KGKk0rqJY/VY1bmSRvmM6hDeci/5YAw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fgb2OH9K;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775680683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LjYnu4owpf/zaSuq0bbFHdaqsldn4LQ2NanTgIzt0b0=;
	b=Fgb2OH9KR46JDGSoZVh12KMZme7vHrIVlRhWaf4V0IDPqQ1P6kjjbPjW1XwkIomjnvrROR
	k/mvpi2F9M+/Xh3aDRucWJTmjr6IehbTMAq7dlcYcIWTmCk4yu+vQLgu3x9OmpBq5oiDo/
	oiOnh+BmQt8csQ9/wvEjXvg0UPN0aR4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-d3hbxVU1P_uDkxv-Coeh3Q-1; Wed, 08 Apr 2026 16:38:01 -0400
X-MC-Unique: d3hbxVU1P_uDkxv-Coeh3Q-1
X-Mimecast-MFC-AGG-ID: d3hbxVU1P_uDkxv-Coeh3Q_1775680681
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8d5b5d607d1so58049585a.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 13:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775680681; x=1776285481;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LjYnu4owpf/zaSuq0bbFHdaqsldn4LQ2NanTgIzt0b0=;
        b=spifczFtcl/SPhA9QQmWklnSKyovzCKAwa6lb1sMWOwZ/g1RP8axwy60DkwGAjbHAn
         t7QnUKezG6S4uvGYoZbCX1VCmu64QGPfvptZ2tMnHtWRYaBF7Rbj3eueraMDv1X1ZSiU
         ZZZ8jZfwdIYp1i80/Ai53uHbLVd053InabjL54shCGMF6qoj2B283mi/z59s4Zgh06MZ
         6rj/NB5KBIvfwgXRW9toGw4NK41BZzPUsK5Mq5MWnnJ14OnQ5uJkOU0m7TPKKgwYPjez
         uaWMxtihQLy+ppAo7pEQtyphaedpasDeu9jgW57YAQQbOeLdS2MKYOTME7boyhgDonTp
         Igqg==
X-Forwarded-Encrypted: i=1; AJvYcCUoLcic88YDdGOh9qfT7IvdEpSjCA3eRgYpy6lUSgiZX81eYTTpuD88skeRjYAM4z/WbkYHLm3HYA==@kvack.org
X-Gm-Message-State: AOJu0Yx1WBiDvc+F7Nc4UMEiad45CE41tbkwlVobLLF6tjPWYSf5cCOJ
	Ls1DzRQHBos5cjeFvKdRICcRn2RQTeAcNuoNKDV8Lz3CPVDCgq9SDHEy/WexLbdJkLdcEPprHgr
	NsAVBBVvnJLH+E22UGne6HRXFgwVLjWImfwqi7hxIbcXUvnbhPI27
X-Gm-Gg: AeBDietKFkh8KUO4Qt3VB9YqOueB9hyPw8QF4qwBZcBHkjxfgG2Ut9Ncra+3KUIhEx1
	AZAECR8CkDCFWdc1ux3MxbQjT5n1G4cnchy49Fjo7XmzlrFKijAsq9NUbjojJPFeFTJkjM1iocH
	sTC4I3QmrkmsEUqaqy9MynawDaoWMD3jqvC2gn0Fb0Pmq6EtWsR5wJA6WJsMGGUi6K5B/a2Q5Km
	Bp7qjlAM5rdxEnKrr+lHXiXMbnwNSqjPxxYonLCuFdUC57lyHMGGzSI3sieUspnA3FKEoxUIWef
	+lQcpfKLAntqxy2WMEN+LUa28Zy4wik7C3HkWT9txuFNNxJXm+GGvaY5IZwKE7488S1ZB7eysut
	efxVZsFx1ePzZLR8lhZd9px8onA==
X-Received: by 2002:a05:620a:198f:b0:8cf:e0fe:f22f with SMTP id af79cd13be357-8dc3bbece88mr175182085a.18.1775680681160;
        Wed, 08 Apr 2026 13:38:01 -0700 (PDT)
X-Received: by 2002:a05:620a:198f:b0:8cf:e0fe:f22f with SMTP id af79cd13be357-8dc3bbece88mr175178285a.18.1775680680629;
        Wed, 08 Apr 2026 13:38:00 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d2a8c29f00sm1562313885a.45.2026.04.08.13.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 13:38:00 -0700 (PDT)
Message-ID: <0d9bfc3e-dad1-4856-9319-040135bed91b@redhat.com>
Date: Wed, 8 Apr 2026 16:37:49 -0400
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
X-Mimecast-MFC-PROC-ID: TzXuBDl7vu9rFqk9n7N4Sbj4RVkE3Wl2zjUOg5guZ40_1775680681
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AF165C0008
X-Stat-Signature: cqp87monb6n59uzih4qpxfuujzuh1rxz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775680683-895454
X-HE-Meta: U2FsdGVkX187e3Pc5/uYYPtSr+vTZkoJiJpr+NgAkCnlAcL/whnrafhOoRSgMbWNytrvGf9WIr6Jmuhamsukf3yCw5Wzf1o+i35T2/nGvOEyRrAKujgV8F2ASxhPAq4NhSd0hm0AoMIHHzFfnCcdBXSasZbpMVBAumJPu7qzHYRL7lmt7WcNCA1j4uo2YSwT4EZfYaerlmEcvtN0HpzOP9JyYTUtphiDI2GHWPYjNyrBMUu+2Us8C4JdneH920a3K2Zad7c8DWrnx8n6jeeRbkkkPXcVVE60aGfg5xg/Yuqcbh0/BTo1Hq0ZnHOTkYJ2iW+/C/7GUeHUkNVlsgrG1TELeTqQzLDJ9WUVL6lC9kNUOxj4es0d3j1OHhTk+PE//ekpy6L6+K2cWKYxqpQVhDBPZFBguApwjzIFWZgGNHxHwaBlZu5NQLZNqlr4t0Jza2j3gCmeaIgFSObmjMcsjaY5BfCUsmCdTwLYcabSLYy01jg+uaVdGDt7nouoXrDV/bPoHyBwqOIIfXsXALPVyGig1KIQlo+0e2vc9oG8Y94NupPx67jG0DCTK54xDzLdpf6/CESn95g8vtKbDRTpuFnuN7Mqcs6xUI36exuPlcQEPFUVgOVJNfznfdjOPlhDBqMVbfrKRySDRn1qM0Qz68E79pis3uMkGir0EVHJK1tRqZR4Gyw1KKuFiyJjlgyTgI8XKLemv1ATY+f8XEhU88iwg2YS+KHunb+xITaK/GusQEfwBipsJpuC6iWCFaXqhtkrQQM+8Rx/S64v5TyP7H3CgHkwqWSmdVhRkQ/MVsNeNK3IIh8BSq/PfhoXNUFsJFOcIaXQRPSnuUVgj0ZEK5TSh2eIHKDjum0c6bgZxilNYNvw6rAGy3BoviKhrJJCoTUNxouGNI1jahSVXSdNighZ8NkiARRjqrbcDo/SYV6RNig82s5OeJU9WWPSIprfswIEDCCCaqikrEbpQ97
 k9iN4y1s
 Gkn9g6MJTj4IAOa7pBnc85WPlAQsVpvp1CpIUl6VCcWuPfaAIZxBBJaSihQaqMyPePAi3ig+Q0DoloMODxKRTRj7fYm6dLkXT4CwA56Kj80mIuseqwMfTISbkx3kT+rIYd3hS221bzH7gdVdOPRDFTfgwzR/kxLRQiG3qbnX+YcYn50rY3kH38Itg52+e/mAXIR6I1PLWaTEbrGU9iMeLZFRLj0oNX/9GdwnLrHru4xquzJPIj3ZITg4UPV4l6cMTgXM3MqykArYIRXD8VT2zEmSIOe/BrWoHBlVZ/dugr3dUeoBb553JddU13YxUIIlUn+QpiIHjpWOs38JwU0NWnBWDxG56/rKKZFgFki1Y+8SNsWoYqTboLxE+rG2P08H+QoJR1RuIUqohEZthaKN8sshMrZO0GDyzFo3046BGZ+Q8W/sxnQyXyXkCnxg4IeOHvZl745mwmrfDQPs=
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

I added the check you suggested in the other email for this in v3. One more
item below.

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

I kept this check for v3 because I found that it's consistent with
the IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) check. If you feel strong
about your suggestion, then I think we should move both checks to
shmem_allowable_huge_orders() (which would require a small refactoring
to shmem_allowable_huge_orders() so that we return the allowable orders
from a single point).

> 
>>       if (orders > 0) {
>>           suitable_orders = shmem_suitable_orders(inode, vmf,
> 


