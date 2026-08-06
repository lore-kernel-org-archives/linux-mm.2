Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911F3C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7065B6B00A0; Thu,  6 Aug 2026 12:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE326B00A1; Thu,  6 Aug 2026 12:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6586B00A2; Thu,  6 Aug 2026 12:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCCA6B00A0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:34:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0159160127
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:34:13 +0000 (UTC)
X-FDA: 85071391986.20.53DC02E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id EBF5E1C0013
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:34:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Riwuq8hT;
	spf=pass (imf18.hostedemail.com: domain of clg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786034051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQp5RwExOV2Y6Ewnz0reZlcW0GsOQG1VQZgGAw/gAgM=;
	b=W7WRLDhAu0FGwKL34cCMnrKgkd5Ghx9Zzokry7ls8QSThyIDhLzTR2c3VjqsGSmfoGzBHy
	CBaQVbeoOA2Mdr+awBDOCe0oOllEb9LJS7OHLqKTRBJVjRwpWLwiFRSpd8NFdNeQs1MSFo
	9ZgPkxELjA7kRA7lPIi75sl3CgJ/bIA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786034051;
	b=G9slZf+YvdlsiNC0xYSJQ+SHsB/NtsK4TAWVpDTcoZ2LCftBBCJf41FCVUm8+WRxP0437z
	VM+47GRXCqzcOX26I2UrwZacLhvtbkqish1sxd+4hiHRGV37UX9aTeyuF+lRmTyHX44lsD
	SKCtxwCuT99U4gB6vd0bMHWfhcUPkd4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Riwuq8hT;
	spf=pass (imf18.hostedemail.com: domain of clg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786034050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JQp5RwExOV2Y6Ewnz0reZlcW0GsOQG1VQZgGAw/gAgM=;
	b=Riwuq8hTTT2SiS0TdVlyWpFiPHu25rcRoAOWm6mtBI2PEI3w6Nq393FTMN4YKRqvVtwJYr
	kS621wcEn39CLN1QBWDAKZtaLd5SAXU67LPGmCsIWdW0D79hEhMRnxDIAL+69Izpq4OYd3
	9sXaJaO4wbZKlF75aHa49aWCET2rMqA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-CcTHb3mHPn-OHT6azD4jNA-1; Thu, 06 Aug 2026 12:34:04 -0400
X-MC-Unique: CcTHb3mHPn-OHT6azD4jNA-1
X-Mimecast-MFC-AGG-ID: CcTHb3mHPn-OHT6azD4jNA_1786034043
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f83999cceso1926488f8f.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 09:34:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786034043; x=1786638843;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JQp5RwExOV2Y6Ewnz0reZlcW0GsOQG1VQZgGAw/gAgM=;
        b=ozpskqCxVcB5Lb4uQPKsJ5RE8rbnn5zehyd9+dU1jdDyDlN3YSTpf5futhzFvuQc+p
         bl6UGjnqtv0DhYc9VHV3dMXjAqmKF174irjfbcSAJf2AL6unYWac5ESutjGrIjPBkXJT
         +vhfVN/pN7mcfnlS5qX28Jez+OkQJhhBY9JnL5A8hr7feEOwLAZyiwmTJZsDI3UxcNBe
         tAAhsiqn3JTvV0kp0jkWMcZ++btb7R7S6L8UjiwVhb2Cv3g8MRgEuTpU93lvmklGdArH
         HA3k3uHcOS/fNVXSiEdKhD/dssyKn3odu3ZRI4yCJMWATJMkrg3E/+yfyrh6CKI97mno
         usFA==
X-Forwarded-Encrypted: i=1; AHgh+RrPD7lyBHwt21uZNrXokmelfcjksdT7D+oZkne30/ky2VfeoWtfNqV0Nai2Af798zUIC+YVnsRagw==@kvack.org
X-Gm-Message-State: AOJu0Yy1F//WJrsM1VboiiDzsCeROC14M/JTMnRQMmjOHBhJANMIjqLu
	HZg27uyy7bvCycVUtty0ECM2VItU2JMIVb/CGr+0UkWW7gfWYHF/kKeP7Rqkvsv5aaFozSzrxgk
	ncYi9/DcSM27gR8CA84+eNEnJgr+Tn7XSoL8MMhbadwe2jxXUPl9l
X-Gm-Gg: AR+sD10KdxLBDlSkMBqOlhiv6XBxYKmiOkYL3bK62bPeaJD1qA9u0QrCW2/xJ+3kxQp
	D9tn/XEIu+lzUo8XA1HXOfRchsWSuaD6ZWqQErmurQPn+wqn2nTe6PKw7D15MlgzeGNss5oekxr
	KZN1C4RKVh4AEqWiH9jwvqSBAGr5LAhd0exJrieP9376mBot889jkIJl3f+rjOcOinVAagbi7pt
	pcx9/E+ECU2cxil6SqfdQG6Kzv4YRpMIILQ/8nGpcSw/pxMAXqMfy2ejDvENvwETowXs2X0MCQ8
	3VTTSLX4wusHJg1CpZswmcEt8fHmZtQoQaiIUSycXicVn/eGzh23m4nuUusupS6EwLsMTyV44WF
	AlVmYLjWjTa+dFqRTv9lvOvEYedTYrIO95izaKRw=
X-Received: by 2002:a05:6000:29cc:b0:47f:e748:3ae3 with SMTP id ffacd0b85a97d-47fec4e7431mr21184626f8f.3.1786034042808;
        Thu, 06 Aug 2026 09:34:02 -0700 (PDT)
X-Received: by 2002:a05:6000:29cc:b0:47f:e748:3ae3 with SMTP id ffacd0b85a97d-47fec4e7431mr21184557f8f.3.1786034042349;
        Thu, 06 Aug 2026 09:34:02 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm6656072f8f.33.2026.08.06.09.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 09:34:01 -0700 (PDT)
Message-ID: <2a7686ee-56ab-439a-90fd-ad3c10e4c336@redhat.com>
Date: Thu, 6 Aug 2026 18:34:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260805055544.1568534-1-clg@redhat.com>
 <anL-NZkNMSSxN0YN@lucifer> <0bd6d355-e6d9-4f5a-b101-9a041c2a2436@kernel.org>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <0bd6d355-e6d9-4f5a-b101-9a041c2a2436@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BEVQnnIO3H0Cv-c4_uTHlY6DOUHCxJBd6iblXmE-P6E_1786034043
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBF5E1C0013
X-Stat-Signature: 6rxmrdbdxacnpnotaxkz81xqjxa4985n
X-HE-Tag: 1786034050-808920
X-HE-Meta: U2FsdGVkX1/K7QZDrDWJLdmWmGkcmgBbkFn7eR2wmHMLd4uiJMrZfhCpwXm7F3/tUw7tEnPWxC1k/rPedEK+0NJqYmcl7bz1x73wM/PM0siZ0gOQh8nsAwk6E843l/+q7+1T6+lipLmCLXwi3PCq2uLQOzNPbgKmykLMnW2gRsvH7C7QjNqlxgYJx/GPShFUgZEHGLm1Ig7Fsg7M0FwsMtBM6IRVB8dexC9ZZFij6IKb29xQA8F3VGFsTloJWtfH2tW0mU4uIoIYhis3jG+KtOwDZvH5y3FKViDpNnZ1Nz39IFdctHL5PTju099VSeS4HD6Psh3kNHSeoQjA8NNsLTSAqxOH4V/6Em8Jpq0y6+FKvSWjMRyYFQcZxf6pepmpkShnAdEwbeW2FTC1Nq45OoAc86EeQZLxNKku6E6Q4aDA6EKfIwbgYKsRDf62gzh2thEU/RUesfxiLbZIp5jcefMRp3WGMpUH4Fvif/2Rx6xiMauoRYs10ESk+MyV/fzUQ040eQks7npYT/jlYCmoxBVcACiqj/fqHHdh/WkLktOHHMrkn8QXho0O2RmZQDn6oZk36heiu/+YRhBR00E//jJimGeGYD6/ndO8+kNJTeKs31syl7yfzfZXC4NNDA45WGt+9QIRLw7QBjI0vIeYuxvC+v1P0wEAeuKE7BU6Tc6+tMHZXtrD375cd5Ip5XU8ZGibkRBkvGHvmHCe6XE0x8f8yhaWPTLMVzD51nk+sDwVLeay/GKWlGg3fj6XnuL1+xQ6uLiYV9V7RO+wVDlbFowhQg3qSCvAgJzQmW7bWeCpsdlO9jGwLP4bxU9FG/+Re/+RoEMEZNOCHIrOK802KrJ6E8Q5nWfTG7xqbn9hjjczEBh1k7RSq4IB/p60LKGtbzaUPO1aoKy8a9nJ6T0/FsTAJUth3VVgK0iLSUkhjGo/i2BzzqzvWg2tOksJJ7QDNDr2C8vZ1qJHj8+Z3s8
 JeIlrrr8
 4R+jtmMmHfYRicOiqOJtwwsGRR0UtSzOTcktcUONxi9txmJZiqAsAZnHkI3kF0AMk3qTUK8y+o6w583LEeC48rNh4o/lKzrCu4tUPJF9JLfZAt8W8imfKsEGpeiMFHFHPvRV9Hw2iRnsouqxw7T8KR4EapkIq7wdm3r7PRNkKEQQ9gf/W/LzbAiEhfM4pE/u2oVOrNZ6izqy9Ocp3lWamN/wCmnsYhzoW6mvGi+HuBD9HYVlQ/Sa8F5rO9yqKC/pIGiT7eY/FKYlF5XScHsa+vTiKtHYLmVlY57R49KKLXbPwjizlZ0zhRPoO1Kxrrk4ND28w+13XgVMPetSqLrfYLNgdO8WYAxHQdKpWCd5JFVmnJs2mUrDj3/W/W2AwX2BXD8DBXdBtxki9xyLd8Wbq1FTPAPq9xYpx07WVRIFq1dqALe48C499gYslA5H5gh212Bpm6kRWgTc6Dn7gxcJW/kr6k6viq7iD57pZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 18:19, David Hildenbrand (Arm) wrote:
>>  From d6537260722c8741586e6295c8eea68d06087efa Mon Sep 17 00:00:00 2001
>> From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
>> Date: Wed, 5 Aug 2026 11:35:13 +0100
>> Subject: [PATCH] ideas
>>
>> ---
>>   mm/huge_memory.c | 32 +++++++++++++++++++++++++++++---
>>   1 file changed, 29 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index abc65d608c23..5fa01364f089 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -111,6 +111,34 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
>>   	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
>>   }
>>
>> +static bool should_obey_thp_file_tunables(const struct vm_area_struct *vma,
>> +					  bool forced_collapse)
>> +{> +	if (forced_collapse)
>> +		return false;
>> +	VM_WARN_ON_ONCE(vma_is_anonymous(vma));
>> +	/* Huge PFN mappings allocate no folios so the policy doesn't apply. */
>> +	if (vma_test(vma, VMA_PFNMAP_BIT) && vma->vm_ops->huge_fault)
>> +		return false;
>> +	return true;
>> +}
> 
> If that's sufficient, then this is is the better direction.
> 
>> +> +static bool can_thp_collapse_file(const struct vm_area_struct *vma,
>> +		vm_flags_t vm_flags, bool forced_collapse)
>> +{
>> +	/* Override THP tunables? */
>> +	if (!should_obey_thp_file_tunables(vma, forced_collapse))
>> +		return true;
>> +	/* THP=always? */
>> +	if (hugepage_global_always())
>> +		return true;
>> +	/* THP=madvise? */
>> +	if (!hugepage_global_enabled())
>> +		return false;
>> +	/* Has VMA had madvise(..., MADV_HUGEPAGE) applied to it? */
>> +	return vm_flags & VM_HUGEPAGE;
>> +}
>> +
>>   unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>   					 vm_flags_t vm_flags,
>>   					 enum tva_type type,
>> @@ -188,9 +216,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>   		 * Enforce THP collapse requirements as necessary. Anonymous vmas
>>   		 * were already handled in thp_vma_allowable_orders().
>>   		 */
>> -		if (!forced_collapse &&
>> -		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
>> -						    !hugepage_global_always())))
>> +		if (!can_thp_collapse_file(vma, vm_flags, forced_collapse))
>>   			return 0;
> 
> I played a bit with that and came up with the following. Not quite happy about
> it, just for your inspiration on naming and what to split out.
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index a00df56a68b57..8ba77608959d4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -111,6 +111,54 @@ static bool vma_is_special_huge(const struct vm_area_struct
> *vma)
>   	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
>   }
> 
> +static bool file_vma_honors_thp_toggles(struct vm_area_struct *vma,> +		enum tva_type type)
> +{
> +	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
> +
> +	if (forced_collapse)
> +		return false;
> +	/* Huge PFN mappings allocate no folios so the policy doesn't apply. */

So, may be rename the routine to file_vma_thp_policy_applies() ?

> +	return !(vma_test(vma, VMA_PFNMAP_BIT) && vma->vm_ops->huge_fault);
> +}
> +
> +static bool vma_thp_toggles_enabled(struct vm_area_struct *vma,

This routine could use the same 'file_vma_' prefix.

> +		vm_flags_t vm_flags)
> +{
> +	/* THP=always? */
> +	if (hugepage_global_always())
> +		return true;
> +	/* THP=madvise and actually advised? */
> +	return hugepage_global_enabled() && vm_flags & VM_HUGEPAGE;

I would add extra parentheses around 'vm_flags & VM_HUGEPAGE'

> +}
> +
> +static bool file_vma_forces_order_0(struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, enum tva_type type)
> +{
> +	const bool in_pf = type == TVA_PAGEFAULT;
> +	const bool smaps = type == TVA_SMAPS;
> +
> +	/*
> +	 * Enforce THP collapse requirements as necessary. Anonymous vmas
> +	 * were already handled in thp_vma_allowable_orders().
> +	 */
> +
> +	if (file_vma_honors_thp_toggles(vma, type) &&
> +	    !vma_thp_toggles_enabled(vma, vm_flags))
> +		return true;
> +
> +	/*
> +	 * Trust that ->huge_fault() handlers know what they are doing
> +	 * in fault path.
> +	 */
> +	if (((in_pf || smaps)) && vma->vm_ops->huge_fault)

and there remove the extra parentheses.

> +		return false;
> +	/* Only regular file is valid in collapse path */
> +	if (((!in_pf || smaps)) && file_thp_enabled(vma))

there too.

Thanks,

C.

> +		return false;
> +	return true;
> +}
> +
>   unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   					 vm_flags_t vm_flags,
>   					 enum tva_type type,
> @@ -183,27 +231,8 @@ unsigned long __thp_vma_allowable_orders(struct
> vm_area_struct *vma,
>   						   vma, vma_start_pgoff(vma), 0,
>   						   forced_collapse);
> 
> -	if (!vma_is_anonymous(vma)) {
> -		/*
> -		 * Enforce THP collapse requirements as necessary. Anonymous vmas
> -		 * were already handled in thp_vma_allowable_orders().
> -		 */
> -		if (!forced_collapse &&
> -		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
> -						    !hugepage_global_always())))
> -			return 0;
> -
> -		/*
> -		 * Trust that ->huge_fault() handlers know what they are doing
> -		 * in fault path.
> -		 */
> -		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> -			return orders;
> -		/* Only regular file is valid in collapse path */
> -		if (((!in_pf || smaps)) && file_thp_enabled(vma))
> -			return orders;
> -		return 0;
> -	}
> +	if (!vma_is_anonymous(vma))
> +		return __file_vma_forces_order_0(vma, vm_flags, type) ? 0 : orders;
> 
>   	if (vma_is_temporary_stack(vma))
>   		return 0;
> 


