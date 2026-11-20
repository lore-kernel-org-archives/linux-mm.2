Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46310606A335
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZTuu+/kE
Received: by kanga.kvack.org (Postfix)
	id 6FD596B05FD; Fri, 20 Nov 2026 03:59:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D42C6B05FF; Fri, 20 Nov 2026 03:59:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611686B0600; Fri, 20 Nov 2026 03:59:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 435746B05FD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:59:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D18A440DD7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:59:49 +0000 (UTC)
X-FDA: 85454899698.16.62779E6
Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	by imf13.hostedemail.com (Postfix) with ESMTP id 79C3920008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:59:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ZTuu+/kE";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.118 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795165188;
	b=kiyGu2SzOV515r/KRCzlHB6m8D2W8TIr5PatkuxjTuHG7w3TUugMdMYRaVbQHvwAHk0VHJ
	CYnwoC8H5yQBVrNuvIj5aX47zZRafosGf80cE7ncUj25PMIkx48HDjK91XOaVqGB3/Vfnb
	99npmziRj5iBiQtaATGZvRSbVNNI7NU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795165188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yc9PKLM1TRlGBdAGztoHr3hWSYWm+6yS6vAIXll0IPg=;
	b=KEhApOzhHxtZ77ykGs7KTlUMt+5cA31VjjFd1rEkDlc/zw4c8Y9CJ50PQUOS4ZAZO/mx9u
	xa8MR5SAOcNRJCqdCTg5UwE6o2jhrU3i/UFuuWEpZLSgzkKtgweA1JCVktBJl4eeYIDBtB
	qGfJEGTSBikeWrGGDTZwYAeokGkW3k4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ZTuu+/kE";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.118 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=j5sy5dx6lTWHNP91V+IG2oaea8AWB1IF7PeLayynPtU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795165186; v=1; x=1795769986;
 b=ZTuu+/kErGbrYo2EAUfdxPsJCulCf/mPmE+cx+8a/P4Szyb57xHYVvLt47wm0vx3T4zDn6sx
 8FYBuQIOQv4YIq1Uy8gwodwX4PMKEtuks16140GAL9kQ5PUPmIU6yxlaAmXtHUyq9jkd/a/cKGR
 970u3E1iYGzwaNsILxITdGjY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ff20ff19d5265770;
	Fri, 20 Nov 2026 08:59:46 +0000
X-Mizu-Trace-ID: ff20ff19d5265770
X-Migadu-Flow: FLOW_OUT
Message-ID: <18eed3f7-1403-4738-b8f8-f11551e1cd7c@linux.dev>
Date: Fri, 20 Nov 2026 16:59:41 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: hugetlb: allocate larger early CMA pages first
To: "David Hildenbrand (Arm)" <david@kernel.org>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, fvdl@google.com,
 Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261120074701.48298-1-qi.zheng@linux.dev>
 <8a43c25e-0828-492b-90cf-beeb72ecdbb3@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <8a43c25e-0828-492b-90cf-beeb72ecdbb3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79C3920008
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: mqhno4p8en5ci4pidu9f6pn3b6tzx5k5
X-Rspam-User:
X-HE-Tag: 1795165187-462359
X-HE-Meta: U2FsdGVkX1+feV6wRsEMfelOE2HPfFt4bFOSS9jy4vomxBtXP2jPi+sY5A8ewaST1Be1jFTjWaZ7nbFnucjATdv9LBV8BYPSdO31uj8savl0enB+b0FKnmLe6iWGjTFNwlx2+e03ACHaj2eBtSWxWemRzuZ25H83X37di9NakcNwpusquDB/ueB+dboY17xhkzR/2jFkpir97kvRN8wWFc+rJjaxpO4BJfMb/F489BBHxlwRgHJlY/kLOQnRst896RkkoW96JmFU8carxd9Gxq/pGpdZ18Zs2jjI1zVTj0N1x62umQ/md9/y8uKWzpk2aKasLhD2sGi9SA92N+bStN9P85I1wznuuSvv1A7+JwMqBT3Abmf84mrQ/jMhFZDEeBUD9IIzkTZ8e3tUc6GEyYgcZtgjT68JHLw753LL+pxDOHGhwrQEIqL78aq24Q9mRdWHbT8Uy3LXaoLwncYVWt7EkHDElWrpA1y76z2oUEqqRfj3+z97CyhwaeTkY3Uff+Gbed3G9ucbhkC5uejgURXYueric6HfbFosB+CupAREyhg52E6TIa6uJ/99xT8b52ewtWMHB6EwMoB3V3u+/v4WejIu4iLT0cHccVSm4U/0iwaHcPq6nVQuydOXmiQlsRBzOmFadNzeKwKyK60ilIAWhmmP8SoXE59JkTQWndBuasO+oJDWQfoQr913gct7NZ2ru1saQi66HT/ipZa6kVe+rhKWcGCsgRypjdOHFzLXXvU8ugJtoSPDcnmb190zoCWggVxWWLj68CFS/At1MuthpzDMiz8ElxAFwkfRX+/r106fF6qLFWo19NZLXFXgo9+1kr7OXut9BC+aucCkxelW4G8EtyRfzKHdnI8cHETtvKkLRcThun7i1Gx/z/guz6Z3rPvU947qXrFryg0yw+EiBBCBpUenLhgkmwYCUjSPd0CwoDqZIZr7YblASvVaaRoemIpsfzQNCKWtocQ
 xyMZdcDp
 j7D13Rb0YaM1AIJJpGKTN8MV+ejD5f2vVwHZGRghi2YNjN8nUZjsKffYow0qdzJmUu8xSw8+YB5AH+VqbdthxxoEk0gVljhB29HJFZ03FeoxsQKBWt1jp2BUP2KhIJel5X5yAgO4f/QE1xDnyN18I98sny5m/mBmhu3sZKzR8OjvzIyxN1gDm3BvQ1K+GS1nzQf/HdSa8uW5hH5207ErIrhaUDdEEcGoRoGTrEVnRhRA9ofOkM4Vm7X+Gind0A2616ZaucEX068zUo7okJAA56WlL2lcXXglpc+MFhkbubC4xsIa7FfXeFsRrHuA0ln6e+9QsWeh7t/+F2YwFfyXpVGjzGK/sGSbcOp5ZtKRdF5GMfJDuQiHMEZ89v1rOuvXRXB+oW/pdY2hLvSISo13DrL1nupQzLJcBbKE4ZKerBnkb/sDnO1mdrDfGWPz+3PCIcaJ2cMN/RxcduAwKtE45545EjqNf2rlan8wHWwwMbYWE7cYXWwbzVp5lxo2jb9kI3BZvjVR1ZVEGsXoot0b2/F8RZN/Q/YuStPLYr8L0l05kJI8Ilt/QlMvs5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 4:55 PM, David Hildenbrand (Arm) wrote:
> On 11/20/26 08:47, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> With hugetlb_cma_only=1, early HugeTLB CMA allocations follow hstate
>> registration order, which can depend on the order of hugepagesz= and
>> default_hugepagesz= parameters. cma_reserve_early() advances early_pfn by
>> the requested size without aligning the start of each allocation.
>>
>> On arm64 with 4 KiB base pages, 32 MiB and 1 GiB pages share a CMA pool
>> aligned to 1 GiB. In a 2 GiB CMA range starting at 4 GiB, allocating a
>> 32 MiB page followed by a 1 GiB page places the latter at 4 GiB + 32 MiB,
>> violating its required 1 GiB physical alignment.
>>
>> Simply rounding early_pfn up before the 1 GiB allocation would leave a
>> 992 MiB gap and advance the cursor to 6 GiB. cma_activate_area() marks the
>> entire prefix below early_pfn as allocated and only frees pageblocks after
>> it. The gap would remain reserved with its bitmap bits set, and releasing
>> the two HugeTLB folios would not reclaim it, permanently losing 992 MiB
>> of usable CMA capacity. An alignment-only fix would therefore also need
>> to track and reclaim such gaps.
>>
>> The same alignment issue can affect non-LPAR PowerPC64 hash MMU systems
>> supporting 16 MiB and 16 GiB pages, with 64 KiB base pages and
>> CONFIG_ARCH_FORCE_MAX_ORDER=7. The 16 MiB size then has order 8 and is
>> also gigantic, sharing the 16 GiB-aligned CMA pool.
>>
>> Allocate early CMA hstates in descending order. Each range starts aligned
>> to the largest supported size, so this preserves alignment for subsequent
>> smaller allocations without creating gaps.
>>
>> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
>> Cc: stable@vger.kernel.org
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/hugetlb.c | 28 +++++++++++++++++++++++++++-
>>   1 file changed, 27 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 4a448c5909d36..d69a9532ad5ef 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -4600,6 +4600,22 @@ void __init hugetlb_bootmem_set_nodes(void)
>>   		node_set(nid, hugetlb_bootmem_nodes);
>>   }
>>   
>> +/* Return the largest early-CMA hstate below the given order. */
>> +static struct hstate *__init hugetlb_next_early_cma_hstate(unsigned int order)
>> +{
>> +	struct hstate *h, *next = NULL;
>> +
>> +	for_each_hstate(h) {
>> +		if (!hugetlb_early_cma(h) || huge_page_order(h) >= order)
>> +			continue;
>> +
>> +		if (!next || huge_page_order(h) > huge_page_order(next))
>> +			next = h;
>> +	}
>> +
>> +	return next;
>> +}
>> +
>>   void __init hugetlb_bootmem_alloc(void)
>>   {
>>   	struct hstate *h;
>> @@ -4615,9 +4631,19 @@ void __init hugetlb_bootmem_alloc(void)
>>   	for_each_hstate(h) {
>>   		h->next_nid_to_alloc = first_online_node;
>>   
>> -		if (hstate_is_gigantic(h))
>> +		if (hstate_is_gigantic(h) && !hugetlb_early_cma(h))
>>   			hugetlb_hstate_alloc_pages(h);
>>   	}
>> +
>> +	/*
>> +	 * CMA ranges are aligned to the largest supported size. Allocate larger
>> +	 * sizes first to keep the early reservation cursor aligned without gaps.
>> +	 */
>> +	h = hugetlb_next_early_cma_hstate(MAX_FOLIO_ORDER + 1);
>> +	while (h) {
>> +		hugetlb_hstate_alloc_pages(h);
>> +		h = hugetlb_next_early_cma_hstate(huge_page_order(h));
> 
> Was thinking that this could be written in a neater way, but it really can't.
> Best we could do is issue a single hugetlb_next_early_cma_hstate().
> 
> order = MAX_ORDER - 1;
> while (h = hugetlb_next_early_cma_hstate(order)) {
> 	hugetlb_hstate_alloc_pages(h);
> 	order = huge_page_order(h);
> }

Yeah, that is indeed simpler — will rework it and send v2.

> 
> Thanks!
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

> 


