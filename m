Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76AFCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 17:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11BA6B00B1; Wed,  3 Jun 2026 13:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9F16B00B3; Wed,  3 Jun 2026 13:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF486B00B5; Wed,  3 Jun 2026 13:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AFC9C6B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:40:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54297A0486
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:40:12 +0000 (UTC)
X-FDA: 84839315064.18.9683456
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id D7174100014
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:40:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UiXCDT5z;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780508410;
	b=nyHFy0NPt4EEZDyinauuwjMxmeSWsr6IV7DE8E0O9klCQFx/Z9/JK0mpcfP/Qqn4cKpCzj
	Ah/BGge++S60hrDRpLb8FDKebrde52cXjOBpRIv+yLFNBCKdp5bnfv4agQN8HqEVZeoGSr
	KD3DQRNBgSyn2Cb70bqlRR15iheqFRI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UiXCDT5z;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780508410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGxdjpqe3cr/pic4Bd1eU4ewAXsVZ/j+LFNRpPoH17w=;
	b=ygyLyVoXt+a7sEzZl0kfKLwlAdclfcl6qnfwI02cYK9qfrfGrZ9V+9q+qUTpacxBAaqjCB
	B332mWI/PqSIEO6JOwB7iIDAx2YCtZBvAHMpvTWeNDY2P7KGsaWW6UTEGaLzVD5ClIgjap
	cjK09o6dSCkH/+RlB0VfBbG5mvas+cM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780508409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nGxdjpqe3cr/pic4Bd1eU4ewAXsVZ/j+LFNRpPoH17w=;
	b=UiXCDT5zJym6wSZq8wS6SRYGAZxCZ6LMr3i14lroATdZEg/ccjf00fYtQmc1PnYjZu3HJh
	bgP0c76TYjX9xAqORxsa+G2ja2kRZTM1jdczt0y+lcJBJVCJzxjmSdf9Jc0eOl25S3mGXU
	uIgJPSYtEG+6fKscc81gAtC37CbHjvk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-z7NToQdJNzGp4OC2bVlFxQ-1; Wed, 03 Jun 2026 13:40:06 -0400
X-MC-Unique: z7NToQdJNzGp4OC2bVlFxQ-1
X-Mimecast-MFC-AGG-ID: z7NToQdJNzGp4OC2bVlFxQ_1780508405
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-91576c147a4so761554485a.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 10:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780508405; x=1781113205;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nGxdjpqe3cr/pic4Bd1eU4ewAXsVZ/j+LFNRpPoH17w=;
        b=jzpRwLgbZr3D0Pd3DWJ6uGLCCpt0RCXnmLp3Yu1AY8r1475rdfw5PvHFpELDosJd29
         q5I4TRTnSaFx4rq8tat9vIAMY/Mz7EfoaEBXpKf0AQWM4JE1LqYZAvt185Rs9a84BbTe
         xk0It8chxMt8Q9gZrN586klTHw0Pu5BnHOdrzfGUzn1VAj3IhWzIK/Nj/U3VVGXUtOxt
         AiEf4fZ/g2fXtbH18TjRDJeuVdYsmdBDbGZrW/UyUBwni/LaLa42b3GUygXdXvdmhzRu
         2s97f8L2/P2dz7EDYcqMJEuh2+nkEzd4OyDT2mmREpyuzcHCgofBxLlq1fy5N1Td9yeM
         Jb3w==
X-Forwarded-Encrypted: i=1; AFNElJ/8tc4lQ6wLFw88h/6ufo23aU3NunrtBIFlLwN79rmlcJn0RxiJD1geUMGo05y5kwuavjCeMV49NQ==@kvack.org
X-Gm-Message-State: AOJu0YwMDk5KalqPN3R3WxH2spLUhgoUImtAl0i1aUaUD88av3j56BO9
	Qb3E52U6RpH1tOjgt/KpTRetKvxnpX1+W3RI+GglnZQ7atIr1MlqSEaWDU7Du84XXvHAJJaLJxE
	yWSNiT4xBFUoZlPH7LYUzLpTAA/pdt4L6svcT1jXncr8I6WG3wDRA
X-Gm-Gg: Acq92OH6l/VSxSmkVyXpKklYrlfqXT+sE6d/6a+TqamJXi/SbRPIuEYKqHh0qsVNOkh
	nx8ZcRjRVV0K8h/myeZ9dtk6TRkAGUYOf/rjUcDjfmRBPvqIP64MQVSXT3uWtJGlNZoFAX5M8HU
	wIHX5/kCRprZyQDAAm0veZko8yQeEBdTUZAEJjYFnpl/mk4PXpPCV2AyZMRG3kggPcpR1c1I1dW
	Q6s0ouc6KM+emrwbdWbxuySVu732rzvexr2CfgoDoSLPif/DcTsA2bNSvXszDhYYq5jzWsIrasw
	VPZXPNcMnI1HQKaj6CGrsGZrWTNH4SaRbyaiVmIuu4r9FRKefwmAau4z1wrU3FzUkeJHw7Hfljq
	vhHyqPdskLvl6GnpLwE18Lt/Rr/YB9GU/FH4xXRVvQdzrVMxnb8Z6d6VUct2/umOoUlOymidn2H
	wCoxc5cESYIg2C3EFQX/W1RJo=
X-Received: by 2002:a05:620a:6908:b0:912:c0b3:7d99 with SMTP id af79cd13be357-9158a674e2fmr740797185a.2.1780508405598;
        Wed, 03 Jun 2026 10:40:05 -0700 (PDT)
X-Received: by 2002:a05:620a:6908:b0:912:c0b3:7d99 with SMTP id af79cd13be357-9158a674e2fmr740790485a.2.1780508405121;
        Wed, 03 Jun 2026 10:40:05 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd06b231sm26386306d6.33.2026.06.03.10.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 10:40:04 -0700 (PDT)
Message-ID: <710692d6-27e7-434e-a308-e717793d4fce@redhat.com>
Date: Wed, 3 Jun 2026 13:40:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/14] mm: thp: always enable mTHP support
To: Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, corbet@lwn.net,
 tsbogend@alpha.franken.de, maddy@linux.ibm.com, mpe@ellerman.id.au,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org
References: <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
 <20260603081207.1375-1-lance.yang@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260603081207.1375-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G5ftWm1j7jraq32mgmiqEPsb1Rxq9VOe9-wdWCKhUig_1780508405
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D7174100014
X-Stat-Signature: 56boi6aeptt1b7ogk6ge1x6z7jre95pt
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780508409-968259
X-HE-Meta: U2FsdGVkX1/IFKeRA2OWEgX0LUg0DEXAyvBzF6XSC9ZPu+xlUqemnBcGKEikHGeJbUN1vYDuoJpWQVw2qMD8Z56Ko8c25AlfAAKT0yz3G4ZT+WglLFeahb1Aa/ge4eh9+IV5QQ2I1HYg7wuX1ZuaQ2EhhIuI8UgGqzBAQR07GsUxZQ9JaEkMn8efeWTbTz8uWHrw0jUXB8WfJAPnt6ybObVPwhQMMJkZxUefj1ickXqChqcBtRUL5MpUciqywLoqMuoLkqljPcmwwT04N1RPYxMDO2X7+EmOrwprFjQtbR9DbksF0W6PCTBOwJShkcxWcZxmphzeyQPWIFP7B1YHKWHZZDafmfWOsVGms9xpSI+RJTfMvA33cLy7oR2DWHEXBvKDdVIRODI0pyTcNf06Ad2pSGFqejVkuqZTJhw99JPKgiQb5WidSFHQG6SRLX63RQSUhNGpIDCsdOKbVdmbFmwjqD3PdTogIQI2wHs5q1ydKS2i+V0si+EWptbvnPR+0+76Q9nHaTk1eHRHu1Ov6+xYIFcCyxVMk48IMwMD+6ZXFyCYOBr1dTknWmvnO5yy8zPoGOBdSSOjVb5Ge9lYu96Fp6An91GNfJl4pilYcXOxQu/0KwF1XHznLPKuKQ1aTJ2eWzbEfcuCWP4MpTxgPlkRdn3Y9M0grg82SpeZik5G3spW6ave7A5kezTtKwa6VQRo0FIFfyFctUKU0K8v+keOmAO7P3DgRnzU6cvWWiyn+ip6gDEWzRR4Ml1yoxIg740NvWPMY8j500Sv4Dq5VGGU3wXGtmV0usm08M5XfWaciiTuwh6+PazTB1j5lMz2AkK243TBNhN3kgCKvk+K49JeWERHIHkLD5R95XaHhYZTg8QhN5SCYCJFFa6qcX2jGpRfAeVFJ7aftYH+wtRuf7wLLeGUB3bVxquSdrwR4vKxNVIY7hbaGIZi0EkJ3C1GOhvcnigtGaTDkRBAFkn
 LyF6tLLv
 rHJcuo2PjIuPExo3s3x/IKuwQ6Ot+tgJfEP7DFG6P5RdoL4TbA0Cx0uo1WZKm5koHi8qMcDpGZkA2PEJdHo9gn8Np7uDDTwasq00bm6Yu0SNgi8P5mGpmjIQNDE5yZc8ME57o8scp81i19aIogXiyI2cpoT4Y1CQyejWQyfGaOVoNkzPXRjpJCB8AaWWKRzzih3PcnF6M8OD2FMtTFfk9SmZZMpUJJceSw6rFR3FKCz8/D0g6Dr4dI1Lv/H/qks5MoWkJ75jjDmhCuBrIUBBVM9vCy7pxdApWhyxbeRdHe+VottzcDtXcrdRp3YAm6bw1DbuDVEyqutgPnk3MDllRzWxs5Zbu0kJ2NJGPG3XLbrnjcN5mNzvj0SzU9pCnwnUZ07l6UsMMMEkynw8lTfer1Oniy6h5eaOtVLUCew7eSE7nlirRc/A42O8Riy2kF3CzMCLgZYaPiYwpIy0gjOPtR+2ZAS+h/4vUsRbG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-03 04:12, Lance Yang wrote:
> Would it makes sense to call khugepaged_enter_vma() for anon mTHP faults
> as well?
> 
> vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> {
> [...]
> 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
> 		return VM_FAULT_FALLBACK;
> [...]
> 	khugepaged_enter_vma(vma, vma->vm_flags);
> [...]
> }
> 
> Without PMD leaves, do_huge_pmd_anonymous_page() is not reached. Apart
> from MADV_HUGEPAGE, AFAIK, the mm has no chance to enter khugepaged
> from the fault side :)

Hey Lance,

Wouldn't we also skip do_huge_pmd_anonymous_page() page today if
PMD-sized THPs are disabled in sysfs but mTHP is enabled?

In any case, by reading through khugepaged_enter_vma() I see that
khugepaged only supports PMD-size for now. So, shouldn't this case be
addressed in Nico's series [1] ?

[1] https://lore.kernel.org/linux-mm/20260522150009.121603-1-npache@redhat.com/

> 
> Cheers, Lance
> 
> On Fri, May 29, 2026 at 10:55:32AM -0400, Luiz Capitulino wrote:
>> If PMD-sized pages are not supported on an architecture (ie. the
>> arch implements arch_has_pmd_leaves() and it returns false) then the
>> current code disables all THP, including mTHP.
>>
>> This commit fixes this by allowing mTHP to be always enabled for all
>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>> created and their mapping will be disallowed at page-fault time.
>>
>> Similarly, this commit implements the following changes for shmem in
>> shmem_allowable_huge_orders():
>>
>> - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>>    considered
>> - Filter out PMD and PUD orders from allowable orders when
>>    PMD-sized pages are not supported by the CPU
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>> mm/huge_memory.c | 25 ++++++++++++++++++++-----
>> mm/shmem.c       | 14 +++++++++-----
>> 2 files changed, 29 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 32254febe097..059901a8c6cb 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -126,6 +126,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>> 	else
>> 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>>
>> +	if (!pgtable_has_pmd_leaves()) {
>> +		/*
>> +		 * If the CPU does not support PMD leaves, assume for
>> +		 * now that it does not support PUD leaves and disable
>> +		 * both folio orders.
>> +		 */
>> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +	}
>> +
>> 	orders &= supported_orders;
>> 	if (!orders)
>> 		return 0;
>> @@ -133,7 +142,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>> 	if (!vma->vm_mm)		/* vdso */
>> 		return 0;
>>
>> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
>> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>> 		return 0;
>>
>> 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>> @@ -848,7 +857,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>> 	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>> 	 * constant so we have to do this here.
>> 	 */
>> -	if (!anon_orders_configured)
>> +	if (!anon_orders_configured && pgtable_has_pmd_leaves())
>> 		huge_anon_orders_inherit = BIT(PMD_ORDER);
>>
>> 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
>> @@ -870,6 +879,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>> 	}
>>
>> 	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
>> +	if (!pgtable_has_pmd_leaves()) {
>> +		/*
>> +		 * If the CPU does not support PMD leaves, assume for
>> +		 * now that it does not support PUD leaves and disable
>> +		 * both folio orders.
>> +		 */
>> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +	}
>> +
>> 	order = highest_order(orders);
>> 	while (orders) {
>> 		thpsize = thpsize_create(order, *hugepage_kobj);
>> @@ -969,9 +987,6 @@ static int __init hugepage_init(void)
>> 	int err;
>> 	struct kobject *hugepage_kobj;
>>
>> -	if (!pgtable_has_pmd_leaves())
>> -		return -EINVAL;
>> -
>> 	/*
>> 	 * hugepages can't be allocated by the buddy allocator
>> 	 */
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 079e299ea789..c15dffd0eb41 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1844,16 +1844,19 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>> 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>> 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>> 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>> -	unsigned int global_orders;
>> +	unsigned int global_orders, disabled_orders = 0;
>>
>> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
>> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>> 		return 0;
>>
>> +	if (!pgtable_has_pmd_leaves())
>> +		disabled_orders = BIT(PMD_ORDER);
>> +
>> 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>> 						  shmem_huge_force, vma, vm_flags);
>> 	/* Tmpfs huge pages allocation */
>> 	if (!vma || !vma_is_anon_shmem(vma))
>> -		return global_orders;
>> +		return global_orders & ~disabled_orders;
>>
>> 	/*
>> 	 * Following the 'deny' semantics of the top level, force the huge
>> @@ -1867,7 +1870,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>> 	 * means non-PMD sized THP can not override 'huge' mount option now.
>> 	 */
>> 	if (shmem_huge == SHMEM_HUGE_FORCE)
>> -		return READ_ONCE(huge_shmem_orders_inherit);
>> +		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
>>
>> 	/* Allow mTHP that will be fully within i_size. */
>> 	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
>> @@ -1878,6 +1881,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>> 	if (global_orders > 0)
>> 		mask |= READ_ONCE(huge_shmem_orders_inherit);
>>
>> +	mask &= ~disabled_orders;
>> 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>> }
>>
>> @@ -5461,7 +5465,7 @@ void __init shmem_init(void)
>> 	 * Default to setting PMD-sized THP to inherit the global setting and
>> 	 * disable all other multi-size THPs.
>> 	 */
>> -	if (!shmem_orders_configured)
>> +	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>> 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>> #endif
>> 	return;
>> -- 
>> 2.54.0
>>
>>
> 


