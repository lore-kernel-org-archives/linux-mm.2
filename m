Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4312DC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36BF76B0095; Mon,  7 Sep 2026 12:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D5B6B0098; Mon,  7 Sep 2026 12:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233636B0099; Mon,  7 Sep 2026 12:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEA166B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:14:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 839E7A01A5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:14:24 +0000 (UTC)
X-FDA: 85187463648.07.D63DFD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A19E41C0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:14:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IVG4/GHp";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788797662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WgI0iNBWchDmZzxLFmjvIjEn2+5Z7VoBkjhiPKThMfo=;
	b=Xg8cCkqhbMFHo1hE7TzDl4u7wlikCkfj512QfyNe7jSnjvz9sPT5dVLPNswfXBqEe2PxqD
	zlWLLt1RqOBVFZAebQWh9amZodCqq1Dy7pxyAoWmrtCqzxuhlQPQ+P3cVxwhjuHb1/+Asq
	wjZtGrfqogJqz90Dftazs2HfK1MJfY4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788797662;
	b=st7SOth0D57GzprC7w2usXI4wn+6riRVMoTQgHZVTTHdS/15SL6SkgbB5JftK0fpV9UCWB
	L6G3KQmQS/5ourRvTjmKAq0p7K/cfKpOQWtr3tvtFXPfiBPd1G+jp3JctOYvnUjD9rM1df
	b/kamUfjK6zdkLxC2JgOkJZnCI70hok=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IVG4/GHp";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC29A4150A;
	Mon,  7 Sep 2026 16:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE941F00A3A;
	Mon,  7 Sep 2026 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788797661;
	bh=WgI0iNBWchDmZzxLFmjvIjEn2+5Z7VoBkjhiPKThMfo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IVG4/GHpPL+vUHOsMFCbXNOtuArwUxJ7rkzHCjn7QDiJc9Gz6rUAweiF7wF1fdRpx
	 KhHEy+kiH0FVQDhvBiP5GzDuwcMYUMJH7QTcYUjXResiYUY8+uvYR2X5du/sHumjXu
	 u1MEx9cvejvr+bdZvq9A4JYCK4QYRs3lRQXrJ7eSQUO66tuJ5/EUZ8KmwAy54ucfs3
	 d7LgWbwHQ09Pz7tiwCOcix+ULPYANt547byrTXZAXbTOZuUabGCg4cebE3pOydMddR
	 8zAMek+qTfZuRLeepe06Gf3smUrZ4NbQZziZlV98RctqlRYt56RN0x423jp8XhjSJf
	 rVHVKKWKknG7g==
Message-ID: <034a2687-3551-485a-a382-e7e77aa3919b@kernel.org>
Date: Mon, 7 Sep 2026 18:14:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Cedric Le Goater <clg@redhat.com>, Saravanan D <saravanand@crusoe.ai>,
 stable@vger.kernel.org
References: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A19E41C0006
X-Stat-Signature: jiwui13i7w4fnwq3rbxthmcmrb63ztq9
X-HE-Tag: 1788797662-190542
X-HE-Meta: U2FsdGVkX18Dxu9OTSc5EVwJV5mWBPpqUG0SVaOWRMNWgh7bwcaS1fwL4ZK/Cl+hyf8POg8UJHzDLP9yN0ncWfz776Wsflr96LItjk3/6iufA2luvQ8rAU2GIDVgNoURK3SmTKfx70wrO+xplXE4BbCp64z9vAzBY7HVbrfPrYL47gAZ5ngxQxiWdG0yMkpJTpkr1bgs+ZQodwVfBXeVQSLNnYokcZqGMrIewQ0ZXJvigp5oajRXl0BCYNihB09ERyLFKxJrZCKKTfSp3rfcylhUJL7zGvP8upZhmDUPEf9Ov6BEa+uboXBA+tuYYAKFCKpC6wPOeCkUGVhHwOfk07OP1HPb7GD1kEeDL022A9RAr595aOqNL8cnbDD7l9ojeu2jEW/yyxF1lqgqdcXRp7uj+KfnXdOVLhaSSic/xZyNfs49BtaWyhKfml/sZF0M/ZEdiv6FAGiZFsmMk3vwaJqt9jcDIQTT+PCUP7O2fyF1+NB4D1N1kzjnar2vrmJ+vvcixCCNvHNE5RJdcD7cRuCJi+14Wy17O5h6PQR3J9cjPRMewU4jkgZYWCelwiJS4w2ZlNTRj7U0GvEkU9Hmjq0I4aGVV0HKISWQnUiEzvpMW/5G0DJ/Jt5grDRoT0W+1bJ761DwlduKHi/5LnxXbYkYB0ZYCKiTDkeeWDhi58OYGNc7YihbgGUiUYasL4gKDLfXURqOmtz1zVXub/1FHoJ+eC55k9Iq22G5YC4x8R+WTInbyM5z2JWHEIVFE2D+xVPPMdMCP4asTVdEGUaafOwojCiijxzfzONbd5mWV0xH053mmhF2tf7jWJbPZVwfkDCIL1KwWFAEhFRezVr8fReitnz0UT98LOwTATpPQ+qIX2HwqFR2S545JoigoBFJ0HVAGKZyhSfERc+WrenX1qVlJeXEd0vkB6h2VXNOzMLWzEyGpjeL2fwlXZ3KqDiCfq4qF6IdzMgDXS3y6JD
 PVlvH5nn
 i6f95ayHaBR8IuD0msoz6S+QEMvnc2YobsgUFkURkS2wTq/AgtF6T8VzSeGjQV83oMj8sCYZ4vd8TLrHTkr5eh+Biz1O7FvapYcX23b11dis5E4fIHoXRNRN8piYwndTfJgzjUkJ8GIHiv1pTVBvpd4zqe3Ckcz7yntifjHG9zHxCeXMP/ugZgVxKPJykxeCvHbYS4g0z7TGlFsf0omJilOPmfErFb54T61/MPzUpHPDa0oT3QWItrnRBvMwHX7LtoVZbTkYIxcoFE2KF9xYibRbnE2aiMT6q/sZYcCHYj4yfZUPJzo0DujKmM6Exuy5FMq71EKWVIJMlNASKjHpSdqlerJRddWj+iFBq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 21:55, Lorenzo Stoakes (ARM) wrote:
> The sysfs THP tuneables at /sys/kernel/mm/transparent_huge_pages/ rather
> confusingly only control the behaviour of THP in some instances.
> 
> They are not applicable to MADV_COLLAPSE operations, nor to DAX mappings.
> 
> Long-term, THP is predicated upon compaction being able to obtain large
> folios to populate THP ranges.
> 
> However, vm_normal_folio() returns NULL for PFN map mappings, thus their
> reference count is maintained by the driver, not core mm.
> 
> As a consequence, the folios are not subject to reclaim nor compaction, so
> are not truly part of the THP mechanism at all.
> 
> However, since commit 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> introduced the ability to establish huge PFN maps, they have been subject
> to THP tuneables.
> 
> This is incorrect - if a huge PFN map is available (defined by
> vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
> should be mapped huge upon fault-in.
> 
> Correct this by explicitly checking for this while ensuring that smaps
> continues to accurately report THPeligible statistics.
> 
> While here, abstract the entire file-backed THP check in
> vma_can_map_huge_file(), with sensible separation of logic into helper
> functions.
> 
> Note that drm_gem_shmem_mmap() and panthor_gem_mmap() establish huge PFN
> maps of shmem folios, however they are marked unevictable in
> drm_gem_get_pages(), and in any case would fail the reference check in
> __remove_mapping() even if they weren't.
> 
> Failing to map huge PFN maps has resulted in significant real-world
> performance degradation, see links for details.
> 
> Reported-by: Cedric Le Goater <clg@redhat.com>
> Closes: https://lore.kernel.org/linux-mm/20260805055544.1568534-1-clg@redhat.com/
> Reported-by: Saravanan D <saravanand@crusoe.ai>
> Closes: https://lore.kernel.org/linux-mm/20260821070520.25759-1-saravanand@crusoe.ai/
> Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 86 +++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 64 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index afbb5974bd22..4bf7b670586d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -92,7 +92,7 @@ unsigned long huge_anon_orders_madvise __read_mostly;
>  unsigned long huge_anon_orders_inherit __read_mostly;
>  static bool anon_orders_configured __initdata;
>  
> -static inline bool file_thp_enabled(struct vm_area_struct *vma)
> +static inline bool file_thp_enabled(const struct vm_area_struct *vma)
>  {
>  	struct inode *inode;
>  
> @@ -118,6 +118,67 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
>  	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
>  }
>  
> +static bool vma_bypass_thp_tuneables_file(const struct vm_area_struct *vma,
> +		enum tva_type type)
> +{
> +	const bool has_huge_fault = vma->vm_ops->huge_fault;
> +
> +	/* MADV_COLLAPSE ignores tuneables. */
> +	if (type == TVA_FORCED_COLLAPSE)
> +		return true;
> +	/* Huge PFN mappings are uncompactable so the policy doesn't apply. */
> +	if (vma_test(vma, VMA_PFNMAP_BIT) && has_huge_fault)
> +		return true;
> +	return false;
> +}
> +
> +static bool vma_thp_tuneables_allow_file(vm_flags_t vm_flags)
> +{
> +	/* THP=always? */
> +	if (hugepage_global_always())
> +		return true;
> +	/* THP=madvise and marked MADV_HUGEPAGE? */
> +	if (hugepage_global_enabled() && (vm_flags & VM_HUGEPAGE))
> +		return true;
> +	return false;
> +}
> +
> +static bool vma_check_thp_tuneables_file(const struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, enum tva_type type)
> +{
> +	return vma_bypass_thp_tuneables_file(vma, type) ||
> +		vma_thp_tuneables_allow_file(vm_flags);
> +}
> +
> +static bool vma_can_map_huge_file(const struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, enum tva_type type)
> +{
> +	const bool has_huge_fault = vma->vm_ops->huge_fault;
> +
> +	/*
> +	 * Enforce THP collapse requirements as necessary. Anonymous vmas
> +	 * were already handled in thp_vma_allowable_orders().
> +	 */
> +	if (!vma_check_thp_tuneables_file(vma, vm_flags, type))
> +		return false;
> +
> +	switch (type) {
> +	case TVA_PAGEFAULT:
> +		/*
> +		 * Trust that ->huge_fault() handlers know what they are doing
> +		 * in fault path.
> +		 */
> +		return has_huge_fault;
> +	case TVA_SMAPS:
> +		if (has_huge_fault)
> +			return true;
> +		fallthrough;
> +	default:
> +		/* Only regular file is valid in collapse path. */
> +		return file_thp_enabled(vma);
> +	}
> +}
> +
>  unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  					 vm_flags_t vm_flags,
>  					 enum tva_type type,
> @@ -190,27 +251,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  						   vma, vma_start_pgoff(vma), 0,
>  						   forced_collapse);
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
> +		return vma_can_map_huge_file(vma, vm_flags, type) ? orders : 0;

I don't have the time to find out how these functions ended up being named, I'll
have to trust that it will be alright.

Adding to what Zi say, vma_can_map_huge_file is also confusing, no?

are we mapping a huge file? :)

-- 
Cheers,

David

