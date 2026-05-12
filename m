Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE323CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 23:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9646B0005; Tue, 12 May 2026 19:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83206B008A; Tue, 12 May 2026 19:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4AA66B008C; Tue, 12 May 2026 19:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0AD26B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:14:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C2D11C1520
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:14:50 +0000 (UTC)
X-FDA: 84760324740.11.F6AF58F
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id D66C91C0004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:14:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h9AKQxjA;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778627687;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lw9fzchRFgfkvRIdlxPrTBX7TqGm6u/FMto+t8FqrcA=;
	b=z/gar69wiUigZPvHNqy9Emlu7HHdM69Z5yRLQ5m273bZQ/3QK2QGEq6wOuo2zmF/JWy0xp
	cB4jdabuhuT2dSynd8qslj9N40eCADUZtayWFnzS0871+FqXhCuxWdXWvWHIJCRSZ5fHrV
	gbU2jPop3l0pDrU42iWoo3UJZf2JkQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778627687; a=rsa-sha256;
	cv=none;
	b=Wsth0Gx/3nJ3yxDJ9fr7KUrLZPMP+zICI4dqV26pjHV+AUmTwxXWWwTsGVju0blI3LKQhu
	AveGFgPa6lEWvqGuPRqeB52F1np5X6Wg6cWJXuJ/ZI3JQkQeUFch4XPu2W/PYuyd6PlZDl
	H20Grnq8F6PDIn2/eNrSMFlm7h4j0Mg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h9AKQxjA;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-682714e8f9eso347599a12.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 16:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778627685; x=1779232485; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lw9fzchRFgfkvRIdlxPrTBX7TqGm6u/FMto+t8FqrcA=;
        b=h9AKQxjAMpahIgsfYgghfor2lLHykva4TQd3Lh0O0tZM36OEmMDpBrAcIRxIQ0w5oW
         BDwdHmH+d7JthG/N576H5A3jeuM+eSLzhFrOZqLzDkXYhmmnchIwpmWI+RFymAWuI9es
         5KfZ6MBY3AhC+UEYMlmThq7D8dDk7rmF0TDURC967bgXx5VUOHjYEPLxbpb1Lg1MWhYm
         TZYirMWfEj1eUi+E0eV2qdR/dq4vIYaqEG/qUY0PmPXAIVxWA1sOROjHT/IJbDsB0ACX
         y9FDt5e/2ngQRpgtQe03oJuCfhO8Unclw+RQ6VtxHMsYx5XvSw04hxsbYAHP+mB11hm5
         3P/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778627685; x=1779232485;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lw9fzchRFgfkvRIdlxPrTBX7TqGm6u/FMto+t8FqrcA=;
        b=AGV6+UMXkz5tbAeYiq+41oKGQMlBre0zpA4S0D2sWmULqW9IbLO50TejFIG/zRAY4Z
         Ddr5rwnitBTAUiztFxyBr88KEghJu5OSQCHZkbVEAYTzU+yfRUBVngEJrBLRQSLslGGl
         xD8lHAyPFcFpZx6JrvslENzCUVS7qh+xeupCBJMVsPvewfqhfwyoaGff8INCar2SakEi
         hvtHnZlOca81TMRpCKYIRNbCG2vSIb8qwq83XrXHUxAhSKWwfeXOcRqP01on9t64r1hA
         ba2A1N/3UDwUz62OPBpi5otuL77UOcmu3OvS0jqzIdNDTQSLsLj/VIZiw1TGVqlDiIAq
         BwfA==
X-Forwarded-Encrypted: i=1; AFNElJ/gcZxTM5Amezwcl42O/k7jt8Nz/jRWgSVOfBslhoR5sVAThQ5iOmKwj1wePYliqzsApd94izQqDA==@kvack.org
X-Gm-Message-State: AOJu0YyfZztY8YlOnMmXP3WKphYAlBKnTf+Z223O2NkKmtjWqGRkFPuS
	upqesTtVlITi/oFdnrguRaJE71v34RgR5UVjoMIdPeY5IyNBUd6bJOn/6NzDBK84
X-Gm-Gg: Acq92OGCkYjIBWYN4EvAeelE0bx/mSkuF1MdTdgf7MbOVuLsMrxb61gX/nCm6OCEUn5
	lML4B1raBLYr5S7VoxwAqcUIpRd8J/M8ojYvk/U4c4MICWBteaqJooPD37y7QVmnc/0mMkcIl/1
	gRJe2y0ez/VSbY4ze4aQ0a5PE/Td59uLIlLJF3bmZOJiNc4IgGR67nD55XJLcKXNls4OPR2T0vS
	dMnyNRaAeb03oHsqpbGck336ZTSZD9KA6Hx0sM3OWnl++91xLpCbFkdbjuiqw2ZcaYHoQP3stSK
	HWkysfsuINbqQ89mxYJX/SU56AMTNXlSd0Gu5dKMB61i/khZAM3L6orQbvJ4/wlry2xu51Nud9v
	JiJJGcpvXlSS6PYEaDKraKgXe8QUGq4OC6O2cD1AS/qzyilFNXv/8GWLmPGC8DV2yi1sz97o1sf
	b34xGvolEWIpDHd3DPAzGZ/Q==
X-Received: by 2002:aa7:cacc:0:b0:67b:e6fd:2ece with SMTP id 4fb4d7f45d1cf-6823178d136mr356803a12.10.1778627684946;
        Tue, 12 May 2026 16:14:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67ef0b6a648sm5557471a12.7.2026.05.12.16.14.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 May 2026 16:14:43 -0700 (PDT)
Date: Tue, 12 May 2026 23:14:42 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	sj@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260512231442.53qwj37fbykp2qus@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
 <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
 <0aab59b8-71c5-4059-8281-5dd876946528@kernel.org>
 <20260512143542.izpp3gu4iqxttw3f@master>
 <113dddc5-27e3-4e9e-a90c-f076a4629f51@kernel.org>
 <9a56d762-ebe5-429e-9fc8-a9c9e5d0d434@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a56d762-ebe5-429e-9fc8-a9c9e5d0d434@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D66C91C0004
X-Rspam-User: 
X-Stat-Signature: yddth6qe8mynmd7h39s1qgrpxj53rxkp
X-HE-Tag: 1778627686-841388
X-HE-Meta: U2FsdGVkX18t7YT9/7pTWthNVf1ShnORw8nQuN1RNvLBNaQT04uM1oKzWec1kS3XZYtDHF5sgk4jhoJn20TKeJCaioUMC7GeOb014BJvznci/DIwlCE2lktf7oZBLF/3hr6MfgFifDklHR0wyvJWiSfSy680B5rxV6UewKqmzKzt0DwEEFm+qXvQxkj67qeY7vflaWUnGXDWfP1kfdrcLN7WR0T0kMy+8eTY3hgQz2ESzHlcgUC47OY+kOOB4UkKw9IoFsvBBEZBt3p5hX3tVS11FlvcegTYsnhyjNzXYF+LIcRxFO2bF57gFsJ8YaZxq8cBBDmr1Os+yp7C2jtrkwjHoPeh+n5bCxdOm4Vaog351LAA8ALBtVIdU1+1WLMFvXMQuzHJW81wmHtgtTykaQRXVYX8gpbaJLHFR+JjDfeEfrZhXe7ngw0MqcF6rRvqgCxKqd6+fRm1B4FijOJp8Fvi2jbD2M5I0J9j268EADCvbgyEreTFtek9zQC/tzSThtBpZA/QOMUDDqr8HaoCsNjesmewoFzCkuUEragckhVxnNMDNjmZdwbLYQQgW2W4QK6UqVlhRy0P7vE2qt0grSU4RGrnqQ7Yl/jVOqmI2sDbmPnq4610ApIjkEkVAOeJzcHStPIgX6OoTlzwg4aR1fmmiz0hFx6gYsk33xfgEGWu5mongmZCzjF7LaiDv4lPoNBaP9ulZPcyLv9J/I5eOX/zkuOvO6oaM9K+RpVCOX280qR3qww0l6DfKZER0KLgzQ98DVhLJkIgHsX6qpkQzXsQToAtp4OOW/ng6dYqqqWCm4WeegzU30s+nVQgYoqKQZd1UEIH0TMhNI9zfrjm4bwidssB6MA8mKCR539OQcv5BREJ3AkrABnHGQBhARSmbKaTw5fYAWiHd+QAnvLv6L41sFuQ8qV13ypNelXxMkLabemUNBIwcHoN7v69Z5Gx5BXOEpe7Q+gAVBulMaC
 3G58HHKW
 RwfTv/uUJ8EOWEG50bOOuMcVHKwOA//09cyPwdBzOSsZuPVaX1ZBpwN6uvW5gwAPP4C8Nu3SCWP62TMgTf0bKW2X8w7D/gIUvW3UxhXYdMxAdFOSQeqhW+R7fMYr3zvU7/jNSV9UDdqhZnCUt6ku5HtX/uNDGE+JzYSGuzqr6MiEkupnReBaicFD50FmnVH1R1+ZGOLkmDGLD67wT9Pmb78Insmh6nUEgjPmOJbzcgqbGig9GuImoL13hj5c9UtnQSvQM6UUxqfLKOQpiH7HphHSHnImzDHpTiEgNgKvJzrUOaLwhsEx2BciYDDzQnsrCQaFeQoxQvDCo0yqDnQFf6IuJphddNRlw82KFy/Ooj2sJjOKLVwTqssEIwqTiOwEHimnkOGBE1Q+zmVCYI3ADwtMBborU2F9Jn2byMHI/YdIaNM5EfAumXgDY22mYww5TJuYpi19xj4BRGXQGW6xb/csNIFSiL0UKdrjmw2hxtVSEJNm7M0GvJhF+Tznq5XatCeVZ5jXl78KquU+QcIyg5TCYRL5o4L9UmIL2m6AHTIRIWEySMWZeIjdXqeMhCER2jBj/MNDiCR0d217FGimFuSpv/7+nsg3nLm2weuKZms9Kp44M+194WFyBHnaG6nEuA0lUpeKpkDOI+bUE3QnR3nbSPK7HVJK5NsuoLMbicFNGicBB60NhzU+/rnUw5gtFaehSKTndwCNQkTZCnlhPywSVB+VsJFWnRgpEzYVuCP62voemaEKnlCoXxRbUD7mK3WeG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:03:47AM +1000, Balbir Singh wrote:
>On 5/13/26 04:55, David Hildenbrand (Arm) wrote:
>> On 5/12/26 16:35, Wei Yang wrote:
>>> On Tue, May 12, 2026 at 02:43:54PM +0200, David Hildenbrand (Arm) wrote:
>>>> On 5/9/26 00:48, Balbir Singh wrote:
>>>>>
>>>>> Could you elaborate a more on the improper situation?
>>>>>
>>>>>
>>>>> Do we need to check softleaf_is_device_private() twice, can't we hold the pmd
>>>>> lock and check once?
>>>>
>>>> I think what we try to do here is, is to only grab the lock if we verified that there is something of interest in there.
>>>>
>>>> I wonder if we should rewrite that whole thing to just do a pmd_same() check after grabbing the lock.
>>>>
>>>> Something a lot cleaner like:
>>>>
>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>> index a4d52fdb3056..de6a255cc847 100644
>>>> --- a/mm/page_vma_mapped.c
>>>> +++ b/mm/page_vma_mapped.c
>>>> @@ -242,40 +242,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>                 */
>>>>                pmde = pmdp_get_lockless(pvmw->pmd);
>>>>
>>>> -               if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>>> -                       pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>> -                       pmde = *pvmw->pmd;
>>>> -                       if (!pmd_present(pmde)) {
>>>> -                               softleaf_t entry;
>>>> -
>>>> -                               if (!thp_migration_supported() ||
>>>> -                                   !(pvmw->flags & PVMW_MIGRATION))
>>>> -                                       return not_found(pvmw);
>>>> -                               entry = softleaf_from_pmd(pmde);
>>>> -
>>>> -                               if (!softleaf_is_migration(entry) ||
>>>> -                                   !check_pmd(softleaf_to_pfn(entry), pvmw))
>>>> -                                       return not_found(pvmw);
>>>> -                               return true;
>>>> -                       }
>>>> -                       if (likely(pmd_trans_huge(pmde))) {
>>>> -                               if (pvmw->flags & PVMW_MIGRATION)
>>>> -                                       return not_found(pvmw);
>>>> -                               if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>> -                                       return not_found(pvmw);
>>>> -                               return true;
>>>> -                       }
>>>> -                       /* THP pmd was split under us: handle on pte level */
>>>> -                       spin_unlock(pvmw->ptl);
>>>> -                       pvmw->ptl = NULL;
>>>> -               } else if (!pmd_present(pmde)) {
>>>> -                       const softleaf_t entry = softleaf_from_pmd(pmde);
>>>> -
>>>> -                       if (softleaf_is_device_private(entry)) {
>>>> -                               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>> -                               return true;
>>>> -                       }
>>>> +               if (pmd_present(pmde)) {
>>>> +                       if (!pmd_leaf(pmde))
>>>> +                               goto pte_table;
>>>> +                       if (pvmw->flags & PVMW_MIGRATION)
>>>> +                               return not_found(pvmw);
>>>> +                       if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>> +                               return not_found(pvmw);
>>>> +               } else if (pmd_is_migration_entry(pmde)) {
>>>> +                       softleaf_t entry = softleaf_from_pmd(pmde);
>>>> +
>>>> +                       if (!(pvmw->flags & PVMW_MIGRATION))
>>>> +                               return not_found(pvmw);
>>>> +                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>>> +                               return not_found(pvmw);
>>>> +               } else if (pmd_is_device_private_entry(pmde)) {
>>>> +                       softleaf_t entry = softleaf_from_pmd(pmde);
>>>>
>>>> +                       if (pvmw->flags & PVMW_MIGRATION)
>>>> +                               return not_found(pvmw);
>>>> +                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>>> +                               return not_found(pvmw);
>>>> +               } else {
>>>>                        if ((pvmw->flags & PVMW_SYNC) &&
>>>>                            thp_vma_suitable_order(vma, pvmw->address,
>>>>                                                   PMD_ORDER) &&
>>>> @@ -285,6 +273,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>                        step_forward(pvmw, PMD_SIZE);
>>>>                        continue;
>>>>                }
>>>> +
>>>> +               /* Double-check under PTL that the PMD didn't change. */
>>>> +               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>> +               if (pmd_same(pmde, pmdp_get(pvmw->pmd)))
>>>> +                       return true;
>>>> +               spin_unlock(pvmw->ptl);
>>>> +               pvmw->ptl = NULL;
>>>> +               goto restart;
>>>> +pte_table:
>>>>                if (!map_pte(pvmw, &pmde, &ptl)) {
>>>>                        if (!pvmw->pte)
>>>>
>>>>
>>>>
>>>>
>>>> There is likely room to clean this up / compress it further.
>>>
>>> I tried to compress above logic like this, hope it could look cleaner.
>>>
>>> 	if (pmd_trans_huge(pmde) || pmd_is_valid_softleaf(pmde)) {
>>> 		unsigned long pfn;
>>> 		bool is_migration = pmd_is_migration_entry(pmde);
>>> 		bool for_migration = !!(pvmw->flags & PVMW_MIGRATION);
>>>
>>> 		if (is_migration != for_migration)
>>> 			return not_found(pvmw);
>>>
>
>I got some time to look at PVMW_MIGRATION, remove_migration_ptes
>is invoked for device private pages, would we want them to skip
>device private pmd pages?
>

Not get you clearly.

You mean skip device-private pmd page in remove_migration_ptes()?

>>> 		if (pmd_trans_huge(pmde))
>>> 			pfn = pmd_pfn(pmde);
>>> 		else
>>> 			pfn = softleaf_to_pfn(softleaf_from_pmd(pmde));
>>>
>>> 		if (!check_pmd(pfn, pvmw))
>>> 			return not_found(pvmw);
>>> 	} else if (!pmd_present(pmde)) {
>> 
>> It's more compact, but not necessarily cleaner. In particular, I detest
>> pmd_trans_huge(), we should phase it out.
>> 
>> if (pmd_present(pmde) && !pmd_leaf(pmde)) {
>> 	goto pte_table;
>> } else if (pmd_present(pmde) || pmd_is_valid_softleaf(pmde))
>> 
>> ...
>> 
>> Might work as well. But once we add support for other softleaf types, we'll have
>> to touch it again. So I'd rather just list what we actually expect.
>> 
>
>Balbir

-- 
Wei Yang
Help you, Help me

