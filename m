Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB68EE0AE4
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 13:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3CA6B0005; Sat,  7 Feb 2026 08:51:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70CB6B0088; Sat,  7 Feb 2026 08:51:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D006B0089; Sat,  7 Feb 2026 08:51:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 930656B0005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:51:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1147CC1BC7
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 13:51:52 +0000 (UTC)
X-FDA: 84417798864.18.7F4CAB3
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1872A8000D
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 13:51:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xHmb1kdD;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770472310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSB2XM91w6fSVPuXGvQO0MuxeMJ61wrne3hP9UNvlAE=;
	b=uPZyIrVvor3qr1O8O4TAu7FwvfneGIe0BrsggrXGmC8U4FHsgvnTkw6iZorKLQGxRpXwm8
	2ffBAlzCQ1APC7mKDHxyyBYhMlnRj/ppK3t6J87n1y5p0Odwai7zOc4IXFLg6Eqeyiq0E3
	mSIfHGAa+2dPH+7UZXZvQeoUn5XSMKk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xHmb1kdD;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770472310; a=rsa-sha256;
	cv=none;
	b=lwxAAGGemrcppUU7S1OockN+sG+vR17gl3nYCxWSzCtIm1Zm4xK6CV5UbM58HNXn4cxd6G
	xQ85BuJRhwBtnII+PAHHKzBOqzN075ImzumtMWJ86ip2zShRZnCuCU0lOlTo2Te0H3U7F4
	biAyMs92YxP4Yti6tolo84PAxZ/oeSc=
Message-ID: <e106bb45-5563-4b9b-bcb5-defd6e204c79@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770472307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OSB2XM91w6fSVPuXGvQO0MuxeMJ61wrne3hP9UNvlAE=;
	b=xHmb1kdDVoTY+CPrgUgv92dGrk+LLjmEYijSlvIPVV06VZqPKwOyE9l8A1jKVZdD71Rtq7
	ObAcef0sV35J60v1OrfCLMBw7cmKk9n1oY+QHBlCzxz8ZqefBTA+p3MElBX4/FT3bOhNGU
	WJYb+qvfOgZ9WRsPRzRzGmGiCtXBMHE=
Date: Sat, 7 Feb 2026 21:51:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
Content-Language: en-US
To: Barry Song <21cnbao@gmail.com>, Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, dev.jain@arm.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
 <20260207081613.588598-5-vernon2gm@gmail.com>
 <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: s87eoxnnh3hzmpdaemdycttksbwj8q8q
X-Rspam-User: 
X-Rspamd-Queue-Id: 1872A8000D
X-HE-Tag: 1770472309-558083
X-HE-Meta: U2FsdGVkX18fJ0OB0maO6e0E/HQ3hQaXGK88i4ixCg+8i/xmry8EhttVmW7S9pOUsMHqlG9/o0haw3w8fVCCDdfDod0cc97jDTH8HjRRfnatD2s0llBiJrHx5bgO+aPEoX2SnLH4id6h5ImCtFzWzkLcFd2Emvjic30fLSrrjucL8ZkyhRoj12eukcdaphrC7CP52L08rqolYwktjstQPdfIUvqPXtdWNOY5Dq14c3gwnyIDchhcCBP+y9belfLjfsNfhSJZLvaZJpANPPanUguLEFDMPXW5uT80DBPP+1mKFFeu5OrbziQ+6mBFS8acEM5c++fyPJSLTXDJmSNSdQ2k6MwXM9bwc/o2PiP1v6hVp/f2QwriH6FEf3yuKrEugtS7liSMVM5L/gk6zYRDchibJgOOwzbJhgk9I7Y2s/je3mRzCWY0BenIHLky8xdmRP9Q5Gwc0atjxPjtYdLq5geMW5X1V3oyTtHD+Y/UsjyhNtazIxR4YibXLOeLNkofcDUgMfDUYGDvpjB6NzutXpltqL5QT8h9HDKu9hkXjGoI70U1m32Eekh2p/zwt/hJebjJImiuWIdAg8BI/YqYTJkZdux4OmIHcvZAXkF2+ZyZsIXQa2UARCVdfk2942bUyRcs69FzGitIVhUEC6xAylnoo7D35vTHGoqL43onrzSeikd+TCcrA9KqpEP/eIqVpz4no04S3MdU6PHdS/PqDi3sbwvBSIy6OaFlwIINBaJ3iwKKfwdq2TZcYI0jGCouMlhVje4h17HlUTUAUEJ+UDjnJ1iQl69D7nGvKfvUDlEaWz4HTUQfsHGXLPaoJvSBY/8EZTVhyNEYACHgue6J6QSg9NdGm4WdLbp/O6noYPEQuWGOrazB+w120zR+p0sEcTx8LS2A50U3rKouM8UkrekXSKhiKsKvYf56YtoY6RMa1Nd47/MOZ/fSEsfWRLZImXSJP3GkONjYGgEITOO
 CD6UXXEo
 WCuh8rGE1zebQtnJiNrHFMLucUkZ0hd3rkS/pI4UGvLlVC0eJIGKWY4HBo1j5yfXQtGHmY/yfROu34UXn4njXzLTYPjnQzZxdpRWdIooJJsdHu+8Enu+KtK4ZheuyONCBLVPbU6CQb/t9p3fFjRATsnKf+CVDmL6RVESw3zo5LVjzBqEMC6Pv0JDZuXzQY6PJBk9ASL4V9udh+nTvdixIQxPxrQgOURRAbF5e66C/Tfvzhe2SMV/hhEmudz2kgpo0VDDp3lbIHzyVD7uJDrB2Ndo+ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/7 16:34, Barry Song wrote:
> On Sat, Feb 7, 2026 at 4:16 PM Vernon Yang <vernon2gm@gmail.com> wrote:
>>
>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>
>> For example, create three task: hot1 -> cold -> hot2. After all three
>> task are created, each allocate memory 128MB. the hot1/hot2 task
>> continuously access 128 MB memory, while the cold task only accesses
>> its memory briefly and then call madvise(MADV_FREE). However, khugepaged
>> still prioritizes scanning the cold task and only scans the hot2 task
>> after completing the scan of the cold task.
>>
>> And if we collapse with a lazyfree page, that content will never be none
>> and the deferred shrinker cannot reclaim them.
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
>> | task hot2           | without patch | with patch    |  delta  |
>> |---------------------|---------------|---------------|---------|
>> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
>> | cycles per access   |  4.96         |  2.21         | -55.44% |
>> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
>> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>>
>> Testing on qemu-system-x86_64 -enable-kvm:
>>
>> | task hot2           | without patch | with patch    |  delta  |
>> |---------------------|---------------|---------------|---------|
>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>> | cycles per access   |  7.29         |  2.07         | -71.60% |
>> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
>> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>>
>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>> Acked-by: David Hildenbrand (arm) <david@kernel.org>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   include/trace/events/huge_memory.h |  1 +
>>   mm/khugepaged.c                    | 13 +++++++++++++
>>   2 files changed, 14 insertions(+)
>>
>> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
>> index 384e29f6bef0..bcdc57eea270 100644
>> --- a/include/trace/events/huge_memory.h
>> +++ b/include/trace/events/huge_memory.h
>> @@ -25,6 +25,7 @@
>>          EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
>>          EM( SCAN_PAGE_LOCK,             "page_locked")                  \
>>          EM( SCAN_PAGE_ANON,             "page_not_anon")                \
>> +       EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
>>          EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
>>          EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
>>          EM( SCAN_VMA_NULL,              "vma_null")                     \
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 8b68ae3bc2c5..0d160e612e16 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -46,6 +46,7 @@ enum scan_result {
>>          SCAN_PAGE_LRU,
>>          SCAN_PAGE_LOCK,
>>          SCAN_PAGE_ANON,
>> +       SCAN_PAGE_LAZYFREE,
>>          SCAN_PAGE_COMPOUND,
>>          SCAN_ANY_PROCESS,
>>          SCAN_VMA_NULL,
>> @@ -583,6 +584,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>                  folio = page_folio(page);
>>                  VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>>
>> +               if (cc->is_khugepaged && !pte_dirty(pteval) &&
>> +                   folio_test_lazyfree(folio)) {
> 
> We have two corner cases here:

Good catch!

> 
> 1. Even if a lazyfree folio is dirty, if the VMA has the VM_DROPPABLE flag,
> a lazyfree folio may still be dropped, even when its PTE is dirty.

Right. When the VMA has VM_DROPPABLE, we would drop the lazyfree folio
regardless of whether it (or the PTE) is dirty in try_to_unmap_one().

So, IMHO, we could go with:

cc->is_khugepaged && folio_test_lazyfree(folio) &&
	(!pte_dirty(pteval) || (vma->vm_flags & VM_DROPPABLE))

> 
> 2.  GUP operation can cause a folio to become dirty.

Emm... I don't think we need to do anything special for GUP here :)

IIUC, if the range is pinned, MADV_COLLAPSE/khugepaged already fails;
We hit the refcount check in hpage_collapse_scan_pmd() (expected vs
actual refcount) and return -EAGAIN.

```
		/*
		 * Check if the page has any GUP (or other external) pins.
		 *
		 * Here the check may be racy:
		 * it may see folio_mapcount() > folio_ref_count().
		 * But such case is ephemeral we could always retry collapse
		 * later.  However it may report false positive if the page
		 * has excessive GUP pins (i.e. 512).  Anyway the same check
		 * will be done again later the risk seems low.
		 */
		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
			result = SCAN_PAGE_COUNT;
			goto out_unmap;
		}
```
Cheers,
Lance

> 
> I see the corner cases from try_to_unmap_one():
> 
>                                  if (folio_test_dirty(folio) &&
> !(vma->vm_flags & VM_DROPPABLE)) {
>                                          /*
>                                           * redirtied either using the
> page table or a previously
>                                           * obtained GUP reference.
>                                           */
>                                          set_ptes(mm, address,
> pvmw.pte, pteval, nr_pages);
>                                          folio_set_swapbacked(folio);
>                                          goto walk_abort;
>                                  }
> 
> Should we take these two corner cases into account?
> 
> 
>> +                       result = SCAN_PAGE_LAZYFREE;
>> +                       goto out;
>> +               }
>> +
>>                  /* See hpage_collapse_scan_pmd(). */
>>                  if (folio_maybe_mapped_shared(folio)) {
>>                          ++shared;
>> @@ -1335,6 +1342,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>                  }
>>                  folio = page_folio(page);
>>
>> +               if (cc->is_khugepaged && !pte_dirty(pteval) &&
>> +                   folio_test_lazyfree(folio)) {
>> +                       result = SCAN_PAGE_LAZYFREE;
>> +                       goto out_unmap;
>> +               }
>> +
>>                  if (!folio_test_anon(folio)) {
>>                          result = SCAN_PAGE_ANON;
>>                          goto out_unmap;
> 
> Thanks
> Barry


