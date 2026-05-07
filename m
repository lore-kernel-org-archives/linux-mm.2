Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B83CD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 09:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92D86B008A; Thu,  7 May 2026 05:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68A46B008C; Thu,  7 May 2026 05:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958406B0092; Thu,  7 May 2026 05:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8502E6B008A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 05:39:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E6BA120479
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:39:31 +0000 (UTC)
X-FDA: 84740126142.12.FFDFA04
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf17.hostedemail.com (Postfix) with ESMTP id ABDEF40005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:39:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=h3DRiF+N;
	spf=pass (imf17.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778146769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfUL/fvaGnUTKvsv1GzX2Lkgd+M9acofoMo8NpSe9dI=;
	b=gezRqz6Q3ECtsZIw8rj5QaORuN1LAGj3dfE7AlLQehoF7jkDSWOxpRGv/Oz+Z41dV2QkwX
	NX1zzM9coFbH9GKG/tshrOKO1eskySi4inrOSZ62bYnY9QqF0JOm81GOi8S6r9yKkMkC1R
	/rt7gnFvlXj76GeuNgkuZFJxs9jf6Wg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=h3DRiF+N;
	spf=pass (imf17.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778146769; a=rsa-sha256;
	cv=none;
	b=Hv7gsw+Ak9ATH8Rf3275fmvWq6YWErXbwxq8dO+33r+qrCc7Gk5skkXomUow6tXxgKhT4i
	iBGhck8naYnb5zQS8YVi4XKkgH171LFHuuBJ652j4vpDml6eHPtQzcVE0ZUw4y/jcBIIIQ
	SyAujbK3p3RNlzb9Dpe8KnNZ5j3OwX0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778146764; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=JfUL/fvaGnUTKvsv1GzX2Lkgd+M9acofoMo8NpSe9dI=;
	b=h3DRiF+NB54dnsdHS2DK2kgMfS8TMkYP5GP1E6Fxn+xRlFubZ5MfSvkn+AM433itgV6kchO29VvWsTsZfEr4eNfsriENN1E8x9tYBxY/R4YjI8j2uRFKML9ccSSOHweE9YsGucrhV8NvRno1q6X7qXksHOe9MGNS8u30SW0Q+qU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X2UA4zj_1778146736;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2UA4zj_1778146736 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 May 2026 17:39:22 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Sunny Patel
 <nueralspacetech@gmail.com>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Balbir Singh
 <balbirs@nvidia.com>
Subject: Re: [PATCH v3] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
In-Reply-To: <24ab5ddc-11a9-40ed-90b2-1a6c68010928@kernel.org> (David
	Hildenbrand's message of "Fri, 1 May 2026 21:08:25 +0200")
References: <20260501115122.23288-1-nueralspacetech@gmail.com>
	<20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
	<24ab5ddc-11a9-40ed-90b2-1a6c68010928@kernel.org>
Date: Thu, 07 May 2026 17:38:54 +0800
Message-ID: <87ik8z36fl.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ABDEF40005
X-Rspam-User: 
X-Stat-Signature: n8xrmbotsy46rdq1hzi8oxzpdqot8k5w
X-HE-Tag: 1778146767-47192
X-HE-Meta: U2FsdGVkX1/U1N5ffKx7rn3PsMboEwgHR8qLLpsEnCj8s7ov6qXIfqHcTn/rEpqAvz5dRUG4I7gLF4vNzi7hy4H1x55p1Rz4M85/gxKbD0rbRs9KhZuUlw8CRufmAtxo4HOaSCQO7FvU6Vfnl2dzvmq9b7hWEV1HEoMnrAgTfEWVpPNSHUOofYvktr0yehVCNr6u7pRkOayow36KxJ05MmeDPQLkXQR2O1Oya4W/cw8h5dqU1oBZJTqG/mXhlgG/+0F6+oLnyS+Wl3vgJEOnka5Ocjpkr1XDDGlQxhzH1oTwr+B1pTkRGG44VuIeGivf1XH81GHvkdHzQZE1YJneViZK/ZQwLYWwjpu7HusbDl5Ug0o7Rgwjouiftwm9mP5mT7cJSXY1bT5BTn58x17Ll85yp7DmVjekTyB1UtMnZ8MmwIPOSJmlTMXiL1vxAGy8ULW6M7QHqNBChFklOZHiH0GCAdd2S9ass+eYO4q6ImYDKMoXIVgLy+x4pyVxK121gd5gO5fThNFId1vzlmuslz9n9gPOAGbk9wx4/Upr55za97Y0V/FJuQRIBf/acGX2a07wXgVjU8jLbCguWp9pIy1F1/KjPi8Nhze9VdQZUtQ1S7dZzaxgZ+PW95HbYdrIXITApGHAiqWQdYO/BnjrYghAw2WCzFe2PaUeapoQC0gUTgiyCQ34oy1PZMC4oMMO2gKH+FI17SXHW0/ucqvfQRWh1b6ijE9N7o0CINT5mOn0TB+08gLV/M8ot/hMIQDj0MZWWjBcYcdwCar/CuJLNwdBi5tmExZuTjN3M/942rHJ9AtAh3mH1qdlOUxi45EzL2CbyAwczLb1qpB2HjUvN56PbJVYwxXxUMPloGsucq1HBAK2y+asSeSFEhZ8MlT/f7Aoqa6dXSf8D5AMIwqMX+2v7WGNB50pIZSAjnyv0mav0ye75+meqyEa2uvSVTZhfpMHk7AvrPg9E5qG1fd
 JscFea7x
 B/ZsJDNMroAHB5oe1PURTDhICwdlH5GDS9mBrAxr/dV+rODMZfBr7bGy8r/1oyi4Mh+ushi7+gmwmcOC2yjtUpAla+K1cdzlXYMCy67TuKS8q8+aFV1bt+mcEaKsMOPZ4hWE9hLthZSwk9hs2UYFDCaMSmx/He28qX443eJ7YDgpvE78CSVjjNQyRJTxvsXaNbZ8O6EXLq9XhNqRt1OLQWhoJTEYI0qqCMsEKCpr8zLDXqcRNfx0J3Nahg4OVlOj7EDpUMmtMEHgWyJHA0+2y53DufKuvJl4Ib5fISVxI8/zHe00Y9dD0mpW8bAUmma94xUsvZwg/stiFO/SK1eBJdk7VzVJq+AmncxEgDzRQNkUp4h7ZNCly6NG1sX26kBjNLBsO/HWjxjKmDwamM2Xy0KjPxudN4dOcT3EiY52H5h+VTAo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 5/1/26 14:44, Andrew Morton wrote:
>> On Fri,  1 May 2026 17:21:16 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:
>> 
>>> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
>>> to a PMD check failure, the pgtable allocated earlier via
>>> pte_alloc_one() is never freed, causing a memory leak.
>>>
>>> Added free_abort label to release the pgtable in error path.
>>>
>>> ...
>>>
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>  	} else {
>>>  		if (folio_is_zone_device(folio) &&
>>>  		    !folio_is_device_coherent(folio)) {
>>> -			goto abort;
>>> +			goto free_abort;
>>>  		}
>>>  		entry = folio_mk_pmd(folio, vma->vm_page_prot);
>>>  		if (vma->vm_flags & VM_WRITE)
>>> @@ -893,6 +893,8 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>  
>>>  unlock_abort:
>>>  	spin_unlock(ptl);
>>> +free_abort:
>>> +	pte_free(vma->vm_mm, pgtable);
>>>  abort:
>>>  	for (i = 0; i < HPAGE_PMD_NR; i++)
>>>  		src[i] &= ~MIGRATE_PFN_MIGRATE;
>> 
>> Yikes, we leak that page on several error paths.
>> 
>> Thanks, I'll retain David's ack from the v2 patch.
>
> Yes. If we want to avoid more labels, we could do something like:
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index ab49d4dcdb60..babb56c4d47f 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -795,8 +795,8 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>         struct folio *folio = page_folio(page);
>         int ret;
>         vm_fault_t csa_ret;
> -       spinlock_t *ptl;
> -       pgtable_t pgtable;
> +       spinlock_t *ptl = NULL;
> +       pgtable_t pgtable = NULL;
>         pmd_t entry;
>         bool flush = false;
>         unsigned long i;
> @@ -818,14 +818,14 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>                 count_vm_event(THP_FAULT_FALLBACK);
>                 count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
>                 ret = -ENOMEM;
> -               goto abort;
> +               goto error;
>         }
>  
>         __folio_mark_uptodate(folio);
>  
>         pgtable = pte_alloc_one(vma->vm_mm);
>         if (unlikely(!pgtable))
> -               goto abort;
> +               goto error;
>  
>         if (folio_is_device_private(folio)) {
>                 swp_entry_t swp_entry;
> @@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>         } else {
>                 if (folio_is_zone_device(folio) &&
>                     !folio_is_device_coherent(folio)) {
> -                       goto abort;
> +                       goto error;
>                 }
>                 entry = folio_mk_pmd(folio, vma->vm_page_prot);
>                 if (vma->vm_flags & VM_WRITE)
> @@ -850,21 +850,21 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>         ptl = pmd_lock(vma->vm_mm, pmdp);
>         csa_ret = check_stable_address_space(vma->vm_mm);
>         if (csa_ret)
> -               goto unlock_abort;
> +               goto error;
>  
>         /*
>          * Check for userfaultfd but do not deliver the fault. Instead,
>          * just back off.
>          */
>         if (userfaultfd_missing(vma))
> -               goto unlock_abort;
> +               goto error;
>  
>         if (!pmd_none(*pmdp)) {
>                 if (!is_huge_zero_pmd(*pmdp))
> -                       goto unlock_abort;
> +                       goto error;
>                 flush = true;
>         } else if (!pmd_none(*pmdp))
> -               goto unlock_abort;
> +               goto error;
>  
>         add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>         folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> @@ -891,9 +891,11 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  
>         return 0;
>  
> -unlock_abort:
> -       spin_unlock(ptl);
> -abort:
> +error:
> +       if (ptl)
> +               spin_unlock(ptl);
> +       if (pgtable)
> +               pte_free(vma->vm_mm, pgtable);
>         for (i = 0; i < HPAGE_PMD_NR; i++)
>                 src[i] &= ~MIGRATE_PFN_MIGRATE;
>         return 0;

Both look good to me, feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future versions.

---
Best Regards,
Huang, Ying

