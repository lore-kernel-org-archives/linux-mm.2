Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACFABFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BDBE6B00A3; Wed, 29 Apr 2026 11:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DC16B00A4; Wed, 29 Apr 2026 11:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035076B00A5; Wed, 29 Apr 2026 11:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DEAFA6B00A3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:05:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7DF561402FB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:05:27 +0000 (UTC)
X-FDA: 84711917094.24.3521C94
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 51C611A0017
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:05:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="US/XeSct";
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777475124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUTLsAIEpGj17Dq3l/AJDprb4dis7oVAYZKNdJ3rJyI=;
	b=6HnX+VsnHDyBn3cysiXhmNoak7RJaCFe8aNz9tvmmEBw8Y5pY3TPBhd4rMvykODeyOvu3a
	nzbLsfC6K+48RpwGuIg2I3ziaW6b5Xi94galAc+fCXz/G2hMZQZNukqNOF3AWxcg1Px8Pw
	uBVYCNYdK/+qzn8qV0D6w42X/cPTTZ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="US/XeSct";
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777475124; a=rsa-sha256;
	cv=none;
	b=JFuasUhjbZ0PnFm5ztPNlow2H17JIhKiIzrCU4zIG9tBYpwsHaU+nJId5xlFrN8zyjBOuM
	P0MA6Lh9nHR8swkvqALLylUbj9UjOraRUNJsMDyYlnTtHnIYPCo1I2Y2ewabEM5FDR7lo8
	0Qc8pq1m6gsGYBQGXO07btbnrRdsseE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777475123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aUTLsAIEpGj17Dq3l/AJDprb4dis7oVAYZKNdJ3rJyI=;
	b=US/XeScthOE5paYFZ/wFSASbnj9WF/ZNRF8Dp4DimuZdQvbHIoW84cYqt3+Z73ilyyPV+c
	RQJnO6hkQtFIFc2u7dYpG6nHOxyyFyP1bjN24Hash6fSK5h7RgEgEf88fTE0z4vgpqmA2r
	QXjCaND6CG+q8stZpTaElGUqrL7t/CE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-JBVx3CmlM1KI5y_UiVt6yQ-1; Wed, 29 Apr 2026 11:05:16 -0400
X-MC-Unique: JBVx3CmlM1KI5y_UiVt6yQ-1
X-Mimecast-MFC-AGG-ID: JBVx3CmlM1KI5y_UiVt6yQ_1777475114
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38ec3a86367so52162111fa.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777475114; x=1778079914;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUTLsAIEpGj17Dq3l/AJDprb4dis7oVAYZKNdJ3rJyI=;
        b=VUbW0Os2UccSmRUYsCf+focFcjbObkbUUWtu6f/cjGFVBcD35I5arCIDWptPZqPVc4
         zTqyu3hjz7riktg7FSmlt44SbXghSkCRVsJNjCMOeno4akmVUMkmrTdkZ0Ud3IC3wCLG
         PUhiYd0XeG4GapcBm5NHfe7eNA8Jrn8pkiZM3suwMDM2AfCsmdjVqz+hln43OAN5Rgsq
         TZbzWYl57ygLYuG+jIA6rXnJBBrM/1d/nDA+dxmGfPLz642exo+vZhhSHQ6IIDCCmkbf
         PFRa3fjN8c8IhAAU1+m/JoQjk1CfWj5RkUD2l2KZtaglC3pGgoQ2Z+y/FnPF7/W4hpYn
         TyOg==
X-Forwarded-Encrypted: i=1; AFNElJ8bEDroMUkog2+MzjIdyQxZKHOwDs6u08u9X07HELec8kTiNiIYiSIy3MI0Wy7ZIFFeX8NNwRHy4Q==@kvack.org
X-Gm-Message-State: AOJu0YzGEmyROYfxhmQIOgLJ2ibhdG7OL5DrrmZyxXcz5NcY7KuXpG5O
	WsPsZCn3lb9Dk4MIH/AMcWvaj06baUENmLE704tRoIGi4ifPyR2sUs9epJaP6O8DlgvKge1DC7G
	3//uVlO9uUBq1ucTKumT4sgL8TA43y7tlRImUlUnHP0aoNsHFQaQ9ti1YR432ZUejrYiMN7b0A0
	6+eOMnSOnzUa4klG9dVvsuF8C2Szw=
X-Gm-Gg: AeBDieus/ChKZkb14y8/cOscKd/Eq7bBXBq0HpBLjNEkrdGb3Xm9tqy54liXGEIMj4Y
	SIaOphDAzrrjd/qrMJ7WMegmwDQcUqDpZxAtSEisW4U2Wy1pcazs2yLL1I9RIjmXBdMG80K2bRy
	mT9dhmn2n+izVqFODSbCUCVbL8l1r9IIg9q7ZeccukP9r6uhfdIPlLjgIQ1uBocfIv490w01vby
	ct9N2/xcuF937+bBr+0kKBkgGAbljakCUT4iFylyOzmTBY/sZs=
X-Received: by 2002:a2e:be90:0:b0:38a:291c:dbcc with SMTP id 38308e7fff4ca-39240f7ae4bmr32131311fa.19.1777475113411;
        Wed, 29 Apr 2026 08:05:13 -0700 (PDT)
X-Received: by 2002:a2e:be90:0:b0:38a:291c:dbcc with SMTP id
 38308e7fff4ca-39240f7ae4bmr32130881fa.19.1777475112731; Wed, 29 Apr 2026
 08:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260419185750.260784-5-npache@redhat.com> <20260420135554.27067-1-usama.arif@linux.dev>
In-Reply-To: <20260420135554.27067-1-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Apr 2026 09:05:16 -0600
X-Gm-Features: AVHnY4KqhjJ7yDGmLi98Dh0LcQMTG9pjpcmQvJpRxqOZ7Z3wYdlwUP6DO0sgnOE
Message-ID: <CAA1CXcAbUwWgZapCRiRbCDsxBAZVWV59fQF+RfHoWaX+HnRpbg@mail.gmail.com>
Subject: Re: [PATCH 7.2 v16 04/13] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BrcVmb6q5CvnG7hJe59hTV21MfRg61ROJazClKQAqHM_1777475114
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 51C611A0017
X-Rspam-User: 
X-Stat-Signature: hk86rx3bm5mbdpxnr5uwfjd7jgf6xgxs
X-HE-Tag: 1777475124-842616
X-HE-Meta: U2FsdGVkX1+XtnfKNo7Rs+DC0jTHWZtvsr/kts/9K4IsRnsoWVpSJYStJstrpJZYhSbHhoAoDTkB7nzBK2KfZG1CJGFUHrWkRgLQh6Nl+87yslfE7YnpxtdMPOYSb6HReopaPzogK5AVG2Ug6rLIOFG7BgTjf004YIr7CggURLPYS1YJWOKmezxKoGpE3SwzSHFK5UOj/JMT5mAJ4xb7bn5lnG0A7UVXzk5i6OnQ2v2yzQtPcNkbpQuhWrR0R4XwzE0m/ivUgYpmnn+S4PRoPJaDIKU3gSoPXh4mY81EnjN3vCThSVgoH2aRCl234l+AwiGGPAMXDdBQUYTXbGNVuz3LyYdmlBNAPaOE47UslalFUwJPVgoM4XLTYTJDxdLHMgwOjH2lZoOgoTnFPeWAe7wyRBazQYHCVmlWf/LVKFwC6yYRwi8igtfISroO1888RSDykBsuuw9At4XO+RICxMZY6dLbdnQ+Y2S4OBiHXwig4ajagilEOvRc1DsJOawSovJZZyTvbRHH9R0zSvZ3/SITVA3xKlph0qqHWuDcP0B4zFu+9bVLd55x8+DP9o5HMsZXCEuPzUngXILrPrH92XS1qoYNHhC/60baaB/OMS12x6TUIQrsh3U4Nuv8T6wKzB37CvgNJ2Avl4F+G4+j4zmvtrziTZrZF9lpFuEnxctcs3BAU4AG/1Yz6mvh8OjAwiGApplNUsawdq9z8WSj2Ynl/hAe19wMrFdnWcxBxlLWiPr+SCCAuKOBqL2a/Mq8+yZkipJRzDxKcSVvU9UA5ep19y7sNFdcfgTbmvUzw0Ca8MSA4iK/siJXbUNeruzVeJ/qxoN6dmriSelCl2zayTLGF4fLB+b80QdIhC0vF4ctMR9E8dadzoPswKDBx5qkqvyqD6lGSGkgNmDMP0+7If/U3kaqMFF6sSEuu6k/itNTkF8q3f2AXGd1MCRHZXSrDz03osFQzxv3aXl2fol
 cS4hlQkw
 rs6mE6AfvJsm6nX/Al6f+0emVknxdTpEsT7xwScxOabkj/XzlRzO7gsT4HJLSdJPVe7RaMacj+sKBvXz66BoygmrJuBk27sazrJnIjq4lKB4K15stQyt1wNBML1uKPUozqrNQVwu5zy72TT4s0WQXGLpJT6OKLhiGBSoOfkz6IeCbsv/aAI80irTccMNM81tjglTFxcsOEM2+BIKwYT5u8hKXzLH7enHFnli0Ib61L1ixdRYHEarN5sT0jg+dBNa5fEWfC0oZUCdhNq1JolcpA8oyM590wPuT0JW42i4avLbJRSbKzovEWHKSAjQurlh8S7gVYatgJWhFJaF35GpGSGZfjkn4kfQNZX87Qb2H8B/cJ3+xLm9kSJEIbqi1y6p4zEJjoRzHQ8RdbBe/Ay+f/xcC1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 7:55 AM, Usama Arif wrote:
> On Sun, 19 Apr 2026 12:57:41 -0600 Nico Pache <npache@redhat.com> wrote:
>
>> generalize the order of the __collapse_huge_page_* and collapse_max_*
>> functions to support future mTHP collapse.
>>
>> The current mechanism for determining collapse with the
>> khugepaged_max_ptes_none value is not designed with mTHP in mind. This
>> raises a key design issue: if we support user defined max_pte_none values
>> (even those scaled by order), a collapse of a lower order can introduces
>> an feedback loop, or "creep", when max_ptes_none is set to a value greater
>> than HPAGE_PMD_NR / 2.
>>
>> With this configuration, a successful collapse to order N will populate
>> enough pages to satisfy the collapse condition on order N+1 on the next
>> scan. This leads to unnecessary work and memory churn.
>>
>> To fix this issue introduce a helper function that will limit mTHP
>> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
>> This effectively supports two modes:
>>
>> - max_ptes_none=0: never introduce new none-pages for mTHP collapse.
>> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>>    available mTHP order.
>>
>> This removes the possiblilty of "creep", while not modifying any uAPI
>> expectations. A warning will be emitted if any non-supported
>> max_ptes_none value is configured with mTHP enabled.
>>
>> mTHP collapse will not honor the khugepaged_max_ptes_shared or
>> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
>> shared or swapped entry.
>>
>> No functional changes in this patch; however it defines future behavior
>> for mTHP collapse.
>>
>> Co-developed-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>   mm/khugepaged.c | 124 ++++++++++++++++++++++++++++++++++--------------
>>   1 file changed, 88 insertions(+), 36 deletions(-)
>>
>
> Small nits. Most might not need change.

No you brought some good points :) Thanks for your reviews!

>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index f42b55421191..283bb63854a5 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -352,51 +352,86 @@ static bool pte_none_or_zero(pte_t pte)
>>    * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
>>    * @cc: The collapse control struct
>>    * @vma: The vma to check for userfaultfd
>> + * @order: The folio order being collapsed to
>>    *
>>    * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>> - * empty page.
>> + * empty page. For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the
>> + * configured khugepaged_max_ptes_none value.
>> + *
>> + * For mTHP collapses, we currently only support khugepaged_max_pte_none values
>> + * of 0 or (KHUGEPAGED_MAX_PTES_LIMIT). Any other value will emit a warning and
>> + * no mTHP collapse will be attempted
>>    *
>>    * Return: Maximum number of empty PTEs allowed for the collapse operation
>>    */
>> -static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
>> -            struct vm_area_struct *vma)
>> +static int collapse_max_ptes_none(struct collapse_control *cc,
>> +            struct vm_area_struct *vma, unsigned int order)
>>   {
>>      if (vma && userfaultfd_armed(vma))
>>              return 0;
>>      if (!cc->is_khugepaged)
>>              return HPAGE_PMD_NR;
>> -    return khugepaged_max_ptes_none;
>> +    if (is_pmd_order(order))
>> +            return khugepaged_max_ptes_none;
>> +    /* Zero/non-present collapse disabled. */
>> +    if (!khugepaged_max_ptes_none)
>> +            return 0;
>> +    if (khugepaged_max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
>> +            return (1 << order) - 1;
>> +
>
> There are 2 reads of khugepaged_max_ptes_none here.
> A concurrent sysctl write between reads can yield "0 then non-zero" or "LIMIT
> then mid-value".
>
> Would be good to just snapshot once at the start of the function and use that
> value?

Yeah good point, that would avoid any really hard to reproduce, but
probably very unlikely to occur bugs.

>
>> +    pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %u\n",
>> +                  KHUGEPAGED_MAX_PTES_LIMIT);
>
> IMO, warn_once can get lost quickly in dmesg. Maybe pr_warn_ratelimited?
>
> Not sure what others opinions are..

I see David already reply'd to this. I guess we keep the warn once or
hard limit to 0. My fear with the latter is that would then violate the
whole concern (and the only reason we have 0/511) support in the first
place. If we could violate this uAPI expectation then I would then want
to reintroduce hardcapping max_ptes_none to HPAGE_PMD_NR/2 if its above
this value.

So in eyes, lets just keep this as is for now.

>
>> +    return -EINVAL;
>>   }
>>
>>   /**
>>    * collapse_max_ptes_shared - Calculate maximum allowed shared PTEs for collapse
>>    * @cc: The collapse control struct
>> + * @order: The folio order being collapsed to
>>    *
>>    * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>>    * shared page.
>>    *
>> + * For mTHP collapses, we currently dont support collapsing memory with
>> + * shared memory.
>> + *
>>    * Return: Maximum number of shared PTEs allowed for the collapse operation
>>    */
>> -static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
>> +static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
>> +            unsigned int order)
>>   {
>>      if (!cc->is_khugepaged)
>>              return HPAGE_PMD_NR;
>> +    if (!is_pmd_order(order))
>> +            return 0;
>> +
>>      return khugepaged_max_ptes_shared;
>>   }
>>
>>   /**
>>    * collapse_max_ptes_swap - Calculate maximum allowed swap PTEs for collapse
>>    * @cc: The collapse control struct
>> + * @order: The folio order being collapsed to
>>    *
>>    * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>>    * swap page.
>>    *
>> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
>> + * khugepaged_max_ptes_swap value.
>> + *
>> + * For mTHP collapses, we currently dont support collapsing memory with
>> + * swapped out memory.
>> + *
>>    * Return: Maximum number of swap PTEs allowed for the collapse operation
>>    */
>> -static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
>> +static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
>> +            unsigned int order)
>>   {
>>      if (!cc->is_khugepaged)
>>              return HPAGE_PMD_NR;
>> +    if (!is_pmd_order(order))
>> +            return 0;
>> +
>>      return khugepaged_max_ptes_swap;
>>   }
>>
>> @@ -590,18 +625,22 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>
>>   static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>              unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>> -            struct list_head *compound_pagelist)
>> +            unsigned int order, struct list_head *compound_pagelist)
>>   {
>> +    const unsigned long nr_pages = 1UL << order;
>>      struct page *page = NULL;
>>      struct folio *folio = NULL;
>>      unsigned long addr = start_addr;
>>      pte_t *_pte;
>>      int none_or_zero = 0, shared = 0, referenced = 0;
>>      enum scan_result result = SCAN_FAIL;
>> -    unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
>> -    unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
>> +    int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
>> +    unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
>> +
>> +    if (max_ptes_none < 0)
>> +            return result;
>
> Would a dedicated SCAN_INVALID_PTES_NONE make more sense here instead
> of SCAN_FAIL?

Yeah thats a good idea, let me see if i can make that work.

>
>>
>> -    for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>> +    for (_pte = pte; _pte < pte + nr_pages;
>>           _pte++, addr += PAGE_SIZE) {
>>              pte_t pteval = ptep_get(_pte);
>>              if (pte_none_or_zero(pteval)) {
>> @@ -734,18 +773,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>   }
>>
>>   static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>> -                                            struct vm_area_struct *vma,
>> -                                            unsigned long address,
>> -                                            spinlock_t *ptl,
>> -                                            struct list_head *compound_pagelist)
>> +            struct vm_area_struct *vma, unsigned long address,
>> +            spinlock_t *ptl, unsigned int order,
>> +            struct list_head *compound_pagelist)
>>   {
>> -    unsigned long end = address + HPAGE_PMD_SIZE;
>> +    const unsigned long nr_pages = 1UL << order;
>> +    unsigned long end = address + (PAGE_SIZE << order);
>>      struct folio *src, *tmp;
>>      pte_t pteval;
>>      pte_t *_pte;
>>      unsigned int nr_ptes;
>>
>> -    for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
>> +    for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
>>           address += nr_ptes * PAGE_SIZE) {
>>              nr_ptes = 1;
>>              pteval = ptep_get(_pte);
>> @@ -798,13 +837,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>>   }
>>
>>   static void __collapse_huge_page_copy_failed(pte_t *pte,
>> -                                         pmd_t *pmd,
>> -                                         pmd_t orig_pmd,
>> -                                         struct vm_area_struct *vma,
>> -                                         struct list_head *compound_pagelist)
>> +            pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
>> +            unsigned int order, struct list_head *compound_pagelist)
>>   {
>> +    const unsigned long nr_pages = 1UL << order;
>>      spinlock_t *pmd_ptl;
>> -
>
> Shouldn't remove the newline above?

Ack thank you

>
>>      /*
>>       * Re-establish the PMD to point to the original page table
>>       * entry. Restoring PMD needs to be done prior to releasing
>> @@ -818,7 +855,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>>       * Release both raw and compound pages isolated
>>       * in __collapse_huge_page_isolate.
>>       */
>> -    release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
>> +    release_pte_pages(pte, pte + nr_pages, compound_pagelist);
>>   }
>>
>>   /*
>> @@ -838,16 +875,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>>    */
>>   static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>>              pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
>> -            unsigned long address, spinlock_t *ptl,
>> +            unsigned long address, spinlock_t *ptl, unsigned int order,
>>              struct list_head *compound_pagelist)
>>   {
>> +    const unsigned long nr_pages = 1UL << order;
>>      unsigned int i;
>>      enum scan_result result = SCAN_SUCCEED;
>> -
>
> Same here?

its probably from me reordering nr_pages to the top. ack! thanks

>
>>      /*
>>       * Copying pages' contents is subject to memory poison at any iteration.
>>       */
>> -    for (i = 0; i < HPAGE_PMD_NR; i++) {
>> +    for (i = 0; i < nr_pages; i++) {
>>              pte_t pteval = ptep_get(pte + i);
>>              struct page *page = folio_page(folio, i);
>>              unsigned long src_addr = address + i * PAGE_SIZE;
>> @@ -866,10 +903,10 @@ static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *foli
>>
>>      if (likely(result == SCAN_SUCCEED))
>>              __collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
>> -                                                compound_pagelist);
>> +                                                order, compound_pagelist);
>>      else
>>              __collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
>> -                                             compound_pagelist);
>> +                                             order, compound_pagelist);
>>
>>      return result;
>>   }
>> @@ -1040,12 +1077,12 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
>>    * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
>>    */
>>   static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>> -            struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
>> -            int referenced)
>> +            struct vm_area_struct *vma, unsigned long start_addr,
>> +            pmd_t *pmd, int referenced, unsigned int order)
>
> Will probably find out in later reviews, but there is tracepoint in __collapse_huge_page_swapin.
> Would be good to add order in that tracepoint if you are adding order here?

Yep! There is a patch that updates the tracepoints.

>
>>   {
>>      int swapped_in = 0;
>>      vm_fault_t ret = 0;
>> -    unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
>> +    unsigned long addr, end = start_addr + (PAGE_SIZE << order);
>>      enum scan_result result;
>>      pte_t *pte = NULL;
>>      spinlock_t *ptl;
>> @@ -1077,6 +1114,19 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>>                  pte_present(vmf.orig_pte))
>>                      continue;
>>
>> +            /*
>> +             * TODO: Support swapin without leading to further mTHP
>> +             * collapses. Currently bringing in new pages via swapin may
>> +             * cause a future higher order collapse on a rescan of the same
>> +             * range.
>> +             */
>> +            if (!is_pmd_order(order)) {
>
> Would it be good to introduce this in the patch that activates it? No strong
> preference btw. Just that its dead code in this patch itself.

No we are trying to get everything ready before the patch(es) that
actually activates this feature. Everything related to order is
currently dead code at this moment until the later commits.

Cheers,
-- Nico


>
>> +                    pte_unmap(pte);
>> +                    mmap_read_unlock(mm);
>> +                    result = SCAN_EXCEED_SWAP_PTE;
>> +                    goto out;
>> +            }
>> +
>>              vmf.pte = pte;
>>              vmf.ptl = ptl;
>>              ret = do_swap_page(&vmf);
>> @@ -1196,7 +1246,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>>               * that case.  Continuing to collapse causes inconsistency.
>>               */
>>              result = __collapse_huge_page_swapin(mm, vma, address, pmd,
>> -                                                 referenced);
>> +                                                 referenced, HPAGE_PMD_ORDER);
>>              if (result != SCAN_SUCCEED)
>>                      goto out_nolock;
>>      }
>> @@ -1244,6 +1294,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>>      pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
>>      if (pte) {
>>              result = __collapse_huge_page_isolate(vma, address, pte, cc,
>> +                                                  HPAGE_PMD_ORDER,
>>                                                    &compound_pagelist);
>>              spin_unlock(pte_ptl);
>>      } else {
>> @@ -1274,6 +1325,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>>
>>      result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
>>                                         vma, address, pte_ptl,
>> +                                       HPAGE_PMD_ORDER,
>>                                         &compound_pagelist);
>>      pte_unmap(pte);
>>      if (unlikely(result != SCAN_SUCCEED))
>> @@ -1318,9 +1370,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>>      unsigned long addr;
>>      spinlock_t *ptl;
>>      int node = NUMA_NO_NODE, unmapped = 0;
>> -    unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
>> -    unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
>> -    unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
>> +    int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
>> +    unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
>> +    unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
>>
>>      VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>>
>> @@ -2371,8 +2423,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>>      int present, swap;
>>      int node = NUMA_NO_NODE;
>>      enum scan_result result = SCAN_SUCCEED;
>> -    unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL);
>> -    unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
>> +    int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
>> +    unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
>>
>>      present = 0;
>>      swap = 0;
>> --
>> 2.53.0
>>
>>
>


