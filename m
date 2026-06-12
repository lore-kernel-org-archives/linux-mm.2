Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0BD5CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 02:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE2F6B0005; Thu, 11 Jun 2026 22:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F046B0088; Thu, 11 Jun 2026 22:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5DD76B008C; Thu, 11 Jun 2026 22:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4E0C6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:48:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7705A1C3B03
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:48:47 +0000 (UTC)
X-FDA: 84869727894.01.C273DD6
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 822D340009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:48:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mvJjVKRP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781232525;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mW5LTHcSdOfeWakS3C16seYcAzTrZg2/iKaqqksQyEk=;
	b=j9+k2HUmjP2cA4/P1aUkwDIlhwlPfA7r94p7/3RH4GERD58xtsB0anByBrKj61ECC0lOhW
	iQF82i38IhWX2VlG+Mp6c8n0uU1r354yqxmxrk3+VcDHQ1Z7b5+4YF9AUF3dJQhE3ddx/u
	zL/e32bEH6A+/11NHsOHsgZf6CkY31Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mvJjVKRP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781232525;
	b=3UUPyO5AyZeGAz7eidpu0dAogwQ2+ef8fshwneMyLeKY4KOuyiuTqOXWxrWZw/PT5PkcQC
	87E4es97/r60v+dP6U8SSMql97MnbSP0vYhOW8mmywxcbNFeDe0vTXER2NK6fRG+IZD+/N
	USKPV6tKzVMUiC70Es55C7EyuOUaQHE=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6912f4acca4so872817a12.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781232524; x=1781837324; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mW5LTHcSdOfeWakS3C16seYcAzTrZg2/iKaqqksQyEk=;
        b=mvJjVKRP1ITsB0tN/xDx/9YKRJL8+dy4MMRujbrpmckE2kmhX6nmvCypPfce+agxYz
         3W5wg2KuXXfKMrLrxd5KaKXyTjfXZ6hj4oOteP2UFs1OZ6GzKPFihxPT4vvGUl2Bf16k
         g+4RH/r4q+sOc5eVA0dF+7yzj9lrnnGA4N7YyfUX0AfZt98TyO8sjDcoqXcMwwtl45cM
         VLqysgyrpw2czRv/bQ3BKYICDEobm0ljwbdSuacafvaj2TLnk5B6YxepBKMviWGV9z5k
         KctGvGteAUtMb3d/wnwfkhB9eCSmyzPOMO5nz90ZZZBh28PpcmLo2oj7DXLqpacbKpVi
         BlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781232524; x=1781837324;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mW5LTHcSdOfeWakS3C16seYcAzTrZg2/iKaqqksQyEk=;
        b=T0sASYLZth8CrYMBSGynCLvX+ox1gbC9QkvoWw0pXQAggae4P8V52vXhNlZDEPvHZL
         m/KqSg7IDabZoN5jUHJvyPd5+G8lNTL1+kRfz9vJJoH/wNQKSREFUzoUZ8D78c/PRmix
         MgGFwai1CHu1SPJvAwZYVKMdXJXmXPWudSF3QXTxtgB88PMkIxFgfBrCNdEkXaspcj80
         jveit2AUAMV4jbcb5LV85LC4F5sy4hHX5nx509ayDrHgO9yG0AUkcwzqnCf4YLNTvkDj
         6v8Tr1XqKm5BsHrg3NLMYAMAAcSxTaQE51zeDZNxpkudCb7SEE0VsqAk0DlWSuuWGIyO
         l2Yg==
X-Forwarded-Encrypted: i=1; AFNElJ/tCBM1ihD3nrTKTgiIwr4Vf4MZvClEN9ZiyLQ+n2UdmAAc0Mlqexg7eCoildzekyZXX64dMxcx5g==@kvack.org
X-Gm-Message-State: AOJu0Yzxz/a7jZi66+be41xFlnGc7uyDe6hTVAxoGL9zUqfrW94I3ScF
	6OHlkhOVibdbRw7fjYp+SXZct+Tkooq6Ll/izSVVcxOYJ2ZeHtkKRk8o
X-Gm-Gg: Acq92OGQu0aJGMTaIaeqc6nB0teLyADlH8WF7/hSLF+hF0LhlW925NM7jDrzh7IWo1t
	3z0e0w5itXlqIcNfNGdAnogfKsx77eys7AOZEMhBZPJ/yETKFRJOEHkjBn42q0qJjJ/B78wB6Do
	+ZhGK/qSIPb4TS0ejQ1p/S3jgyJuVQ726i5zXg6WFMXvqG5XnL30MoLn4Y8C383MTK21ulsnEPE
	2WeOCHtZZ3drnENWQRbcwhSWrMv5bc0S5e5GCSPDrmyj79H91F+4Xj4sPl15cmhsL90JkwFKzXB
	ry9upEduS2nSKj7AG56pYSPVTgS3Z5xaX+eHciXCscW2neBlWexOsqjdopRZcNrg0d+vV3YjHLx
	pn4Bz8TH96pxql79buwcwj5VdgeUVU5VwQZslYgRb0YAYEZqUySg5TRWtrWBfR05ybisOJS58ZN
	OKsEbU3l+WQRovmVM4RY9kQA==
X-Received: by 2002:a05:6402:51c8:b0:68a:5107:4f6f with SMTP id 4fb4d7f45d1cf-693788fd509mr309343a12.12.1781232523794;
        Thu, 11 Jun 2026 19:48:43 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6937919a009sm108066a12.2.2026.06.11.19.48.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jun 2026 19:48:42 -0700 (PDT)
Date: Fri, 12 Jun 2026 02:48:40 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
	akpm@linux-foundation.org, ljs@kernel.org, riel@surriel.com,
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, sj@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260612024840.qdw76serbgj67yrv@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
 <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
 <0aab59b8-71c5-4059-8281-5dd876946528@kernel.org>
 <20260512143542.izpp3gu4iqxttw3f@master>
 <113dddc5-27e3-4e9e-a90c-f076a4629f51@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <113dddc5-27e3-4e9e-a90c-f076a4629f51@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: orkuntce6d14pywfuu58qmn8s1j86nbo
X-Rspamd-Queue-Id: 822D340009
X-HE-Tag: 1781232525-517829
X-HE-Meta: U2FsdGVkX1/p1na8lj925T1RSa8gp4nLoXAd8f/6M5JbxTmqWKBJvVtwfE96TGEse6hHNOIFueLeCPEqLn8pTL6rwt00gL229AU3nhw5a97AS/LGIIJAoGlqM+9XcvzwAwgEBPZhBdFdCAolfoK9/exZBibyeAnCjDcOQRUcdjfvmePhfoIxsByvns6F43ZY8t/64ArUyAawIJO8jAB3FUN1EuJ5I/7WwB5vpJLIzvcshMNyzWBtMda/AfouFQ9LGGk7PnVhOKnOvnEI6J9EJrIJ71hCYfa+rmi+EnkzToo+QI8gGlyKGXJz1kAiCre+03w1Q3kyAbQBcWBLotNGtuRd2y40fJDXuR2KbMLP9ragCDij+VGp2DhLzO3KjXLkOll1pz7c1qikHctkCRyLnY8RosQlFClcT03rLzBVQMP+4dNbOzE23ui/4WjYbbUVeRIrNIkgj5qDA+Tifo72aDMx256Dc7SRESU9Kap2ZIK7pKkZ2ki9ONxNDwOz9ZpzfnmBjep2iQCo7RaUiTSGaWpUgr2hOJ5BXsml5N4lZN+h7QTkrkr+3HJiUzIKQXFxFhyZSKmJsl0cDPDiXKE59KKCZGKv6P00Yw/iTec2ZHxo1dYT86/SDeXiB7o/XZpFsNVOdbDTm7gnivPFFIfxBZ1NjCsV6iS1Df09cM7J2kFCJHVqCdnTps54PAyjWaa/cx2kzIx1tYtAKir78lsGAlqopx1ikoHomQDt/AF1sYV0ST6sAS0vDp/lJiAQMqMir2MpvsvOYN8d3tfuA/zMPUL+IC1pRlvxhXkhKTws+3zeN9aH58nuhtY7NsXWZ+M0BfQh+oVC+fvVnzocIMTJviu0wq58K2+y/0W2rbF/YEQBT+00JpMUuELN5/8ZLOWPe3iwA1MP8Iw6oH6NydkGq0sZGbU/u3WRyrMDXCZ+r2cO/t2RyGrTQ/6fXXjGpsYuswUmRj0ZYuGoZX7EHC2
 hU1lilyF
 BoYULPzu1poy4Q5myIGoPtxXC/dwnw8pDA+dKUpJPF08MbanfLSlWR+PJIIwAXFZQuG2I4bqO9OZA8b6WH3n+dlBifpUlZv51jhe5iOcMvM4cFtvgnnZkOEv7xozjmhd5adNtfQETesddag2u1vVa2EyB2/kZ1wdPsJQnKFNmtq2yXfXmrouymB9sLjg02sUSPi26GbDPvMEvmdvE30D+RsYbbh9zIL9pivIhgF7c1f8BF2s+faipbBOZ5dr+vi1W2N9e+wMS32ZAXo3AbeonKOMoN6oqSRdg1JaFfc8D+QB0isRyZePrmmunPvN/AJtT0W10Y3Xjk1YbOZ92xKqUT2SUFLVescaXGtjgwJtZLOrMz9SwJTz8gwxMkrJ8ckKgf6bWQpH3jeCguN2zf93OAlLSoTZSita2XUgm0XZY2oT6tvYK/uUdv01SxMjeXRlAftdCy0NiV8IPq8AtQfxkp7XM7hu5xZqTSzYqpELOaSZrFEACy7uN3qDWb7ZAZGbdeR7fmhF9boKTXavBe/bx6P8VvrDMvqVKrsLSsQmtFMdSpEo0EbGhODbAwwL+fuJhsYQsgiHJeQSnnIW76RM9WWHa3HxneuK7giAeWmFjW69iVlysok7DjhKXgoYk/X/tOamtJF5XAxOpXm0lF1Dij+XbRUcZayqnok3v3+Oso03qvOCUlnfsgI6wMOM1VqzJBy1hhbtboD9dccpGsAuxDCZAoHNtAZZR7I5U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 08:55:47PM +0200, David Hildenbrand (Arm) wrote:
>On 5/12/26 16:35, Wei Yang wrote:
>> On Tue, May 12, 2026 at 02:43:54PM +0200, David Hildenbrand (Arm) wrote:
>>> On 5/9/26 00:48, Balbir Singh wrote:
>>>>
>>>> Could you elaborate a more on the improper situation?
>>>>
>>>>
>>>> Do we need to check softleaf_is_device_private() twice, can't we hold the pmd
>>>> lock and check once?
>>>
>>> I think what we try to do here is, is to only grab the lock if we verified that there is something of interest in there.
>>>
>>> I wonder if we should rewrite that whole thing to just do a pmd_same() check after grabbing the lock.
>>>
>>> Something a lot cleaner like:
>>>
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index a4d52fdb3056..de6a255cc847 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -242,40 +242,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>                 */
>>>                pmde = pmdp_get_lockless(pvmw->pmd);
>>>
>>> -               if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>> -                       pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>> -                       pmde = *pvmw->pmd;
>>> -                       if (!pmd_present(pmde)) {
>>> -                               softleaf_t entry;
>>> -
>>> -                               if (!thp_migration_supported() ||
>>> -                                   !(pvmw->flags & PVMW_MIGRATION))
>>> -                                       return not_found(pvmw);
>>> -                               entry = softleaf_from_pmd(pmde);
>>> -
>>> -                               if (!softleaf_is_migration(entry) ||
>>> -                                   !check_pmd(softleaf_to_pfn(entry), pvmw))
>>> -                                       return not_found(pvmw);
>>> -                               return true;
>>> -                       }
>>> -                       if (likely(pmd_trans_huge(pmde))) {
>>> -                               if (pvmw->flags & PVMW_MIGRATION)
>>> -                                       return not_found(pvmw);
>>> -                               if (!check_pmd(pmd_pfn(pmde), pvmw))
>>> -                                       return not_found(pvmw);
>>> -                               return true;
>>> -                       }
>>> -                       /* THP pmd was split under us: handle on pte level */
>>> -                       spin_unlock(pvmw->ptl);
>>> -                       pvmw->ptl = NULL;
>>> -               } else if (!pmd_present(pmde)) {
>>> -                       const softleaf_t entry = softleaf_from_pmd(pmde);
>>> -
>>> -                       if (softleaf_is_device_private(entry)) {
>>> -                               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>> -                               return true;
>>> -                       }
>>> +               if (pmd_present(pmde)) {
>>> +                       if (!pmd_leaf(pmde))
>>> +                               goto pte_table;
>>> +                       if (pvmw->flags & PVMW_MIGRATION)
>>> +                               return not_found(pvmw);
>>> +                       if (!check_pmd(pmd_pfn(pmde), pvmw))
>>> +                               return not_found(pvmw);
>>> +               } else if (pmd_is_migration_entry(pmde)) {
>>> +                       softleaf_t entry = softleaf_from_pmd(pmde);
>>> +
>>> +                       if (!(pvmw->flags & PVMW_MIGRATION))
>>> +                               return not_found(pvmw);
>>> +                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>> +                               return not_found(pvmw);
>>> +               } else if (pmd_is_device_private_entry(pmde)) {
>>> +                       softleaf_t entry = softleaf_from_pmd(pmde);
>>>
>>> +                       if (pvmw->flags & PVMW_MIGRATION)
>>> +                               return not_found(pvmw);
>>> +                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>> +                               return not_found(pvmw);
>>> +               } else {
>>>                        if ((pvmw->flags & PVMW_SYNC) &&
>>>                            thp_vma_suitable_order(vma, pvmw->address,
>>>                                                   PMD_ORDER) &&
>>> @@ -285,6 +273,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>                        step_forward(pvmw, PMD_SIZE);
>>>                        continue;
>>>                }
>>> +
>>> +               /* Double-check under PTL that the PMD didn't change. */
>>> +               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>> +               if (pmd_same(pmde, pmdp_get(pvmw->pmd)))
>>> +                       return true;
>>> +               spin_unlock(pvmw->ptl);
>>> +               pvmw->ptl = NULL;
>>> +               goto restart;
>>> +pte_table:
>>>                if (!map_pte(pvmw, &pmde, &ptl)) {
>>>                        if (!pvmw->pte)
>>>
>>>
>>>
>>>
>>> There is likely room to clean this up / compress it further.
>> 
>> I tried to compress above logic like this, hope it could look cleaner.
>> 
>> 	if (pmd_trans_huge(pmde) || pmd_is_valid_softleaf(pmde)) {
>> 		unsigned long pfn;
>> 		bool is_migration = pmd_is_migration_entry(pmde);
>> 		bool for_migration = !!(pvmw->flags & PVMW_MIGRATION);
>> 
>> 		if (is_migration != for_migration)
>> 			return not_found(pvmw);
>> 
>> 		if (pmd_trans_huge(pmde))
>> 			pfn = pmd_pfn(pmde);
>> 		else
>> 			pfn = softleaf_to_pfn(softleaf_from_pmd(pmde));
>> 
>> 		if (!check_pmd(pfn, pvmw))
>> 			return not_found(pvmw);
>> 	} else if (!pmd_present(pmde)) {
>
>It's more compact, but not necessarily cleaner. In particular, I detest
>pmd_trans_huge(), we should phase it out.
>
>if (pmd_present(pmde) && !pmd_leaf(pmde)) {
>	goto pte_table;
>} else if (pmd_present(pmde) || pmd_is_valid_softleaf(pmde))
>
>...
>
>Might work as well. But once we add support for other softleaf types, we'll have
>to touch it again. So I'd rather just list what we actually expect.
>

Hi, David

I may not follow you. Just want to confirm whether you prefer this goes as a
fix first, or you prefer it goes as what you suggested here as a cleanup?

>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

