Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53171D29FF9
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76686B00A2; Wed, 14 Jan 2026 07:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24866B00A3; Wed, 14 Jan 2026 07:45:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FF86B00A4; Wed, 14 Jan 2026 07:45:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDF66B00A2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:45:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2212E8BE21
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:45:13 +0000 (UTC)
X-FDA: 84330539706.09.DA8FFE1
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf30.hostedemail.com (Postfix) with ESMTP id 06C308000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:45:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pPDRJ5h4;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768394711; a=rsa-sha256;
	cv=none;
	b=Hqi6NY/g7ShUVwl7oOByaP4ucpSRLDUnpo1g3oJwK8aVm2QPmSKHL7H5As5npq3s7XbEED
	H7D4BjH2lOnvEhwrbqMMdke9XgBCYUxTP9943pOg111MnsLyLHQVLoVwyJkFab4ohoo8Rt
	NXWNkPl42eSyzx4sUEiRuFQLFKWzYbI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pPDRJ5h4;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768394711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kkx9U6E3R5XQonI/fhBV4DP/DMljouvF3+/pnXfZpGk=;
	b=2tdxANCnDy42v6LcGxXlkTIDlX4DWJVj832+ZtE3hZTRMH6PfsoCoLGLgScwTRhnkoHx7l
	zyz/vqkN7jPAXikoKMQc/C2WNRUrdZlOoZ++Q4JfFqrJ1S8LJ+H9uTNm0RkV3eOb2W+JKm
	BVTDtT8eQrTyFzTPF6TgKWHIbpf0J60=
Message-ID: <56c004dd-fe54-42a7-a8a0-38aeaf97c8c4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768394705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kkx9U6E3R5XQonI/fhBV4DP/DMljouvF3+/pnXfZpGk=;
	b=pPDRJ5h4aaAaWS8SPzqMcI9dLtCOQsHPUFI0aChPzmXXOfA4rNIbXcdqBxhPt3mafVhoKM
	vAbjusKIDRJjPNHcPWblUaINahoJbPGFML3j2S9Kl/xU/xL5e/ZsYMKpCbVUFrgJGDNbVU
	VF+zYeNTeCpZzEIJjjYvYMVSHL/rFnI=
Date: Wed, 14 Jan 2026 20:44:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v4 5/6] mm: khugepaged: skip lazy-free folios at
 scanning
Content-Language: en-US
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-6-yanglincheng@kylinos.cn>
 <06c2e619-0e60-4e57-b2ea-37333b2f6f5d@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <06c2e619-0e60-4e57-b2ea-37333b2f6f5d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wez7nhd1w4kz6ogekh61bn7kp1q11m9s
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 06C308000B
X-Rspam-User: 
X-HE-Tag: 1768394707-689601
X-HE-Meta: U2FsdGVkX1+ea8nMNisL0/DELF9/zFlSNIqnzCHrDWzBicDLyTeFnqndu4Soth9xygMCwyxElGSWkdb+IgB8D8OF+n9civYsuHzwN6SKJoVqLookH54X3cUI1xsJaehGtCpFlsmVhlsZUW3nB14NbX0LGt2kYYL42OaF/rwrb+4Tjw4KOfenoKt16GttWQs4xVwoZ00Zbes/OHZ65DmcC2xhubZw91Ody6D7t9ohrO6Pj8N0txSwHZTbe/EugLDYt0Z/YzGV0BMzsgQLxN4dqAENnbmVKnv5UAygwoNVUQvxmTCTvU1pXs/8IKQZ83+LuDh7bFwhn4WAf8NIK80hb2ftFdseoZ9GB9KO/L1d76dygdEvG1LzP7paFHXJ+CZ5Y1fIu6wF2nbjHet6e382fj/Zmi/VWlMMeVUqlYh9Gv8TxtqUVz3BD/zVFSjLvucuiSbrZIJadCgWnd8hNiAuDPwnAt5Yy1IpQ/Cc13Y8uYzvNjTohYt+BaPH5zS1NaL+aWKiSy6YN3YWfEuNy2xgFFR5R/I2h8YUfq3Hbaud+ttDInUO3o+LEwgjmHX4qU9zY7Z/cmvW2YvxJmoK0wKX8o/IEblRbpW2zOi/ZMrE72jx90yA/U44cASk4jxAYzitLka68/Qg13TM+VikrmH+1sQVZ92bUAC6A4jkAXcOMpCVIMZAg1GLnhv0TNrOcOFqsNarA7T03xTxG4VTmY1aHyB7YloKAG44YAgaSEZpwiT2Km6XyPKwusn3vMFl4LOvr2jJFiDVrPZI3pqf58rzLYhFGCalhbohsIMF2oJFOKAcCBNf9C3JqozUE+XJ7RPEXAd7/NAaBuLD+69mPE69Ma/zKXC28pW8e6M3sJv8bd3U4Z9kHY0OL9o2lbNn+p9GVR7A/VbdAFXG3jgGo6NmyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/14 19:50, David Hildenbrand (Red Hat) wrote:
> On 1/11/26 13:19, Vernon Yang wrote:
>> For example, create three task: hot1 -> cold -> hot2. After all three
>> task are created, each allocate memory 128MB. the hot1/hot2 task
>> continuously access 128 MB memory, while the cold task only accesses
>> its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
>> still prioritizes scanning the cold task and only scans the hot2 task
>> after completing the scan of the cold task.
>>
>> So if the user has explicitly informed us via MADV_FREE that this memory
>> will be freed, it is appropriate for khugepaged to skip it only, thereby
>> avoiding unnecessary scan and collapse operations to reducing CPU
>> wastage.
>>
>> Here are the performance test results:
>> (Throughput bigger is better, other smaller is better)
>>
>> Testing on x86_64 machine:
>>
>> | task hot2           | without patch | with patch    |  delta  |
>> |---------------------|---------------|---------------|---------|
>> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
>> | cycles per access   |  4.96         |  2.21         | -55.44% |
>> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
>> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>>
>> Testing on qemu-system-x86_64 -enable-kvm:
>>
>> | task hot2           | without patch | with patch    |  delta  |
>> |---------------------|---------------|---------------|---------|
>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>> | cycles per access   |  7.29         |  2.07         | -71.60% |
>> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
>> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>>
>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>> ---
>>   include/trace/events/huge_memory.h |  1 +
>>   mm/khugepaged.c                    | 17 +++++++++++++++++
>>   2 files changed, 18 insertions(+)
>>
>> diff --git a/include/trace/events/huge_memory.h b/include/trace/ 
>> events/huge_memory.h
>> index 3d1069c3f0c5..e3856f8ab9eb 100644
>> --- a/include/trace/events/huge_memory.h
>> +++ b/include/trace/events/huge_memory.h
>> @@ -25,6 +25,7 @@
>>       EM( SCAN_PAGE_LRU,        "page_not_in_lru")        \
>>       EM( SCAN_PAGE_LOCK,        "page_locked")            \
>>       EM( SCAN_PAGE_ANON,        "page_not_anon")        \
>> +    EM( SCAN_PAGE_LAZYFREE,        "page_lazyfree")        \
>>       EM( SCAN_PAGE_COMPOUND,        "page_compound")        \
>>       EM( SCAN_ANY_PROCESS,        "no_process_for_page")        \
>>       EM( SCAN_VMA_NULL,        "vma_null")            \
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 6df2857d94c6..8a7008760566 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -46,6 +46,7 @@ enum scan_result {
>>       SCAN_PAGE_LRU,
>>       SCAN_PAGE_LOCK,
>>       SCAN_PAGE_ANON,
>> +    SCAN_PAGE_LAZYFREE,
>>       SCAN_PAGE_COMPOUND,
>>       SCAN_ANY_PROCESS,
>>       SCAN_VMA_NULL,
>> @@ -1258,6 +1259,7 @@ static enum scan_result 
>> hpage_collapse_scan_pmd(struct mm_struct *mm,
>>       pmd_t *pmd;
>>       pte_t *pte, *_pte;
>>       int none_or_zero = 0, shared = 0, referenced = 0;
>> +    int lazyfree = 0;
>>       enum scan_result result = SCAN_FAIL;
>>       struct page *page = NULL;
>>       struct folio *folio = NULL;
>> @@ -1343,6 +1345,21 @@ static enum scan_result 
>> hpage_collapse_scan_pmd(struct mm_struct *mm,
>>           }
>>           folio = page_folio(page);
>> +        if (cc->is_khugepaged && !pte_dirty(pteval) &&
>> +            folio_is_lazyfree(folio)) {
>> +            ++lazyfree;
>> +
>> +            /*
>> +             * The lazyfree folios are reclaimed and become pte_none.
>> +             * Ensure they do not continue to be collapsed when
>> +             * skipped ahead.
>> +             */
>> +            if ((lazyfree + none_or_zero) > khugepaged_max_ptes_none) {
>> +                result = SCAN_PAGE_LAZYFREE;
>> +                goto out_unmap;
> 
> I dislike adding another khugepaged_max_ptes_none check. Gah.
> 
> 
> Can't we should just keep it simple and do
> 
> if (!pte_dirty(pteval) && folio_is_lazyfree(folio)) {
>      result = SCAN_PAGE_LAZYFREE;
>      goto out_unmap;
> }
> 
> Reasoning: once they are none, we have a zero-filled page that e.g., the 
> deferred shrinker can reclaim.
> 
> If you collapse with a lazyfree page, that content will never be none 
> and the deferred shrinker cannot reclaim them.
> 
> So there is a real difference between them being none and them still 
> being around.
> 
> 
> We could also try turning them into none entries here, that is, test of 
> we can discard them, to then just threat them like none entries.

Right, I would prefer turning them into none entries, but that seems to
complicate things a bit, e.g., making sure we don't copy content from them
during collapse ...

So let's keep it simple: just bail out if the page is lazyfree and clean :)

> 
> 
> Why don't we want to similarly handle this in 
> __collapse_huge_page_isolate() ?

Yeah, that should be added there as well.

