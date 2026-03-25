Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD20109C024
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF48D6B0089; Wed, 25 Mar 2026 10:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA55C6B008A; Wed, 25 Mar 2026 10:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBAA66B0095; Wed, 25 Mar 2026 10:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A07FD6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:34:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36B89140817
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:34:43 +0000 (UTC)
X-FDA: 84584831646.18.A961AAA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 47BF44000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:34:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BPDlcuAx;
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774449281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRt4DJdFCetftqTlbCfStqMHbX75OE0GMvpU713/3BM=;
	b=KZRPECyx5yFoFlcHk5FZS9lL8KDMMAACUhoecWvYqsA/9XUaiFwsmR+7tRXwm2N/UGV48a
	TwvOPdHqYttVmSfS97vQiM4X5VDxyKSd8eQz0ov4d7lzsTfOyHNcyKBA0nR+y/3HQDqmoq
	1Gb/0InLiNsO+cFVI33ieQm39sKMNJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774449281; a=rsa-sha256;
	cv=none;
	b=roaHSH7Z96qLWxupIeONoEEG+oCM1/uJJOPsozzkIdyZggjDvOpoNPnb8pgG+SmPFnSd4A
	owyMVVeBgMBuLxvn4OIYdny172tr/3rcg9fR7SMId4Efa+FicL5Yh8LqWWL9NAIQVU3PKE
	369HilWG0CwNxZ4WffScGr7S3X7ii/k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BPDlcuAx;
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2216D1F91;
	Wed, 25 Mar 2026 07:34:34 -0700 (PDT)
Received: from [10.1.194.63] (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B644F3F836;
	Wed, 25 Mar 2026 07:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774449280; bh=6/u6HKYQDsWx6V41hulRBAMFC+hy/qZJazOJY5r5Rmk=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=BPDlcuAxL4aXuXQ8Rz7EjB+h55HmaQlwOQxJGa3gYVwAmSuKM5tpQ7gB738eHHnlf
	 k12R0YuctQPWcvu5NQEdtTVUtt2sbw8t90IUopt1Yd6Fj9KVK2j8oIaH08yx8g9ZN9
	 99yOkdve+glFLZtZjDymTldx7BrJmgMrb7LoXZqo=
Message-ID: <c379889b-42eb-44ea-8cf4-1f29a45b6ce1@arm.com>
Date: Wed, 25 Mar 2026 14:34:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v3 2/3] vmalloc: Optimize vfree
To: Zi Yan <ziy@nvidia.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-3-usama.anjum@arm.com>
 <1D88CFF0-8A74-413F-9A6A-39E27B760AE1@nvidia.com>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <1D88CFF0-8A74-413F-9A6A-39E27B760AE1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 47BF44000A
X-Stat-Signature: 1hmm34tpjqibeo4yt49eh1kdcyoff6d3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774449281-116224
X-HE-Meta: U2FsdGVkX18YvhHmt0hg1VNORb7ZYbFdvoKvSkEg2irVGMUMN2ERJuDWYVeEjp8PmKd97DGjtxJEwtvSQywBf/JbBCsGnwdiTgbk/L1R4YSfd4e+hbE0uc+CiwJW+Tha88TrBzvt+Mv96hWsB77Ki6mvNrvSye8LZBiYoRzgs6IPH2rRFqJ2FmrHsB8njxGIeLzV5tIQVcBX97bJOfJ7Cs3NBVF/NaWQP8ZyVP58wcr4/E4/ePIRx0PjftTHq+ucgdL/P/ZwOULg7jX/0omomlylfzOE+L9YwljZkrVfbMIv3Uih9sT9qrF4mDgmhgiqTE6ew6DP2iO1SE7w5LpijFsCTmwGGJcc6VKXKQVyaCfHgM+J+Cc5aSVrhgvpRlOSubNXD1P9uAuAdMZIBaIriIa3gJUkbBM+IR05rp2gkGb22csLB9OP/Jskqo2lBXY9Hx9iIGDgAOkZvpu/niqIO7dsD8oemjjFqxeJyMAma3arwIM+wMSQRv1OPvuoajsUBX9g7t+DNMoynVkuaw91IlxfFoiLIdlblvZ9JJBOzktrOFM79mySQO1YNbeWOOBpvKsugPpmksXCEvDvttG8887cpCEDmcMn/e+jA9OjBEBuv2MdIKnOjw0XzAlS6nveK26us3hDY/7yTsWVkbzZMLbRC7fZp0Kj0W10P+bWLHWkd1LP54rjurdJjQV3PRk3stJEte/Zcrg/6f1oaJdm1tNWw2xg8IWfypjlNRkY3p8tpwFHVtwwTNjzyzzo/9zavvr/nxwelQ3oXsSKR8S6qItx1u1i5CbayFyXNDbAxU2nZo+nuc6aWnx3nULOFYm6yZ0LdEXnT9V7LMdR23qWwtrJOSB12KtPf2GnibPifp2PdDLwJvsq8iclCTx8xx5lZ0y7xc6OuJFhk9V+jbFR0I9WRe56IxZNrtjQ6e/Mx/q9tjHMxRKk12C08PyzDpOONLz8DiUX1zZviOoV1FR
 2B7iPM7r
 85mWBllacAZtEcWtENZ/6d4O33kBEyNchLvwOUW6fVXceNEPixdtPk+7KyieYDeDfbrLyb3Ul97AErC+cEvPUwgxTL744P2p5PxEHzgrsT3VfT+hnm1MR3ehLjTkhna/+dpLN8PyXIWbBItr6IXhiky+wp+Z2GiYBnm0AjJigYX7zrL0Trbxv1Q9NMPfUqibhLdeoJdfA54F+dnzKenjNOnU/gycjTMKzf2XLnwXjYf3AsLTUUUuJmcP1dkWWv0JCXsbTuv2VvNvpTDiWRRzB4YbkTtmcmQzsJxC9zN9LsVNk02qfD8CKhNpk91g21jhd0sB6pEdLwc2OoAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

<snip>
>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>> +{
>> +	unsigned long start_pfn = 0, pfn;
>> +	unsigned long i, nr_contig = 0;
>> +
>> +	for (i = 0; i < nr_pages; i++) {
>> +		pfn = page_to_pfn(page_array[i]);
>> +		if (!nr_contig) {
>> +			start_pfn = pfn;
>> +			nr_contig = 1;
>> +		} else if (start_pfn + nr_contig != pfn) {
>> +			__free_contig_range(start_pfn, nr_contig);
>> +			start_pfn = pfn;
>> +			nr_contig = 1;
>> +			cond_resched();
>> +		} else {
>> +			nr_contig++;
>> +		}
>> +	}
>> +	if (nr_contig)
>> +		__free_contig_range(start_pfn, nr_contig);
>> +}
> 
> free_pages_bulk() assumes pages in page_array are sorted in PFN ascending order.
> I think it is worth documenting it, since without sorting, it can degrade
> back to the original implementation.
I'll add the kerneldoc comment.

> 
>> +
>>  /*
>>   * This is the 'heart' of the zoned buddy allocator.
>>   */
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index c607307c657a6..e9b3d6451e48b 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3459,19 +3459,13 @@ void vfree(const void *addr)
>>
>>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>>  		vm_reset_perms(vm);
>> -	for (i = 0; i < vm->nr_pages; i++) {
>> -		struct page *page = vm->pages[i];
>>
>> -		BUG_ON(!page);
>> -		/*
>> -		 * High-order allocs for huge vmallocs are split, so
>> -		 * can be freed as an array of order-0 allocations
>> -		 */
>> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
>> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
>> -		__free_page(page);
>> -		cond_resched();
>> +	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
>> +		for (i = 0; i < vm->nr_pages; i++)
>> +			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
>>  	}
>> +	free_pages_bulk(vm->pages, vm->nr_pages);
>> +
> 
> stats is updated before any page is freed. It is better to mention
> it in the commit message.
I'll mention it.

> 
>>  	kvfree(vm->pages);
>>  	kfree(vm);
>>  }
>> -- 
>> 2.47.3
> 
> Otherwise, LGTM.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> 
> Best Regards,
> Yan, Zi
> 

Thanks,
Usama

