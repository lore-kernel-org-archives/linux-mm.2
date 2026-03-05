Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ADFCF30946
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5846B0089; Thu,  5 Mar 2026 06:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578A76B008A; Thu,  5 Mar 2026 06:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484D06B0093; Thu,  5 Mar 2026 06:44:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 397F06B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:44:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A93891CC71
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:44:30 +0000 (UTC)
X-FDA: 84511826700.08.942E05C
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id B060614000C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:44:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a/qWqMU5";
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddRQSUpzR8bRhlhTQBip0BDAIGV0lwUiZeArCVwecRs=;
	b=PGhNaFa8BH1OmeCF7mhiQoW3gMIwM3gqiOsJdSjE4dPfGR1WJdrvugqTgEl0I5FUHkTLKc
	eVcdd7obqXw3NfVCMwFabvKnId2tBZy2Hw2mZ74IZ5AeJ/FROVft84gaV68sxeXoaP2z7v
	G84OhHz121Ia2vBjzlZ8H/VW/Jgl2Tg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711069; a=rsa-sha256;
	cv=none;
	b=gCkOTxhslasN2xArjLBglLFEvY8CaMhmsR3JmsRtvlHjFE4tVaDIdThDuhea7bCm6DCHLm
	6IfPsauzcITzRFtUh51Poaa5DXnqc0hF3mFJWQ+Vw20THycukrN7nnO4HYwdqy7wUNsN9u
	06BNg75gv6HOO2m8e03oX+X+h1I5aq0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a/qWqMU5";
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f427c5f7-93d6-4eeb-bda6-5e40d42f2bba@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ddRQSUpzR8bRhlhTQBip0BDAIGV0lwUiZeArCVwecRs=;
	b=a/qWqMU5Yf8yyNjXfk6Oy/9D+nDcKqmO370hdBQqe9JXom5N+/9LDQn4n9ZOErIv6t2Qkw
	CUZQ1QFcyU0jnb1ZR1rQgtxNyp2RyFhppjTOUAG5+clkomGUjL8W8xtHg9lxfYX6kSugiI
	VNrMwzqeYp5Vz0FTDrzgLcWZrQevdPs=
Date: Thu, 5 Mar 2026 14:44:20 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Content-Language: en-GB
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Kiryl Shutsemau <kas@kernel.org>, matthew.brost@intel.com,
 npache@redhat.com, david@kernel.org
Cc: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
 <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
 <5e59c077-9f06-4e45-86e1-ca696e6105b4@nvidia.com>
 <622eb392-8c04-473d-b42a-ecdc489799c4@linux.dev>
 <942f2df4-6fb5-415f-b7d4-87a83315890b@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <942f2df4-6fb5-415f-b7d4-87a83315890b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: h99j5catxyxzfsdxnkwffd1u61bt7sws
X-Rspam-User: 
X-Rspamd-Queue-Id: B060614000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1772711068-568121
X-HE-Meta: U2FsdGVkX18Gf6KOnzcVWnXoDn0u9L8nUA06lZ1tm4M2FOMzDQ4P3VlylEmIkJVjTy8jY5Nn2nesUtSruZ5R4rz/WUjip6KC1zJfoXxHdUm8npSnVgJJDOdsWqxgRwiZJUQcL4IzdPq/E7a6xZSZucV6UNB/cziZy4N9JFZ6Uo5qLp6j7uD7OmSg4qTJDXt1iq1djp2GQd04QIN+4sQDzTyQY04s62/VMVuMEFNG1IgPtQQcdKRALUymwKmr04Z3e3aAQaAvSwdRvfSyK9xU6p81xhF9gIhUQZJeoQ4gvNoooG0Dx5hQsTWCNtZSiSvieYh09Zk3a1T+jizUjJJumuFqJvLKiUNmyp/tbh9w4/Qd9nOORFKH3xWWWB1+F+QdeHCzZI6U7xksYMvasH2+9paxzU4hfzV+z8p6lG1UZS2FLTaKB+2binUE87JdDzQBdACrFDaiCBxGdfd0HX+I173lxCh5+5hJn0eSiJhwaGpD+apBeRC3LtGm3EAIMvOkUZdnw5NeXUKyVYZN7Nz9/KYanuNG0SHJLdo56yblbvVtMuyPGi775pVrPcLCe310rPIq9m7opozzV9ssLD5juja+uYiz89j1jSgflslzMsG9YhElK9g0eWE5cxg3WUW7E3o4uBzteWH5K9MHyKU/LHYNn3jW+DzEuOU84sZBw00J94OLkJL3Gdsp4aLGaapXXlJ8rTq84nWe0HJinxCFnn1y5Ghh6cx2Zikd7gKKCpZ6FeQN3m2or8rpmA+yyS4M2B5mEkpssnnDfhEKo+h2pyHBg0PpLIWoxCOpm8NNnSOVe7DXoVarBmYm/TRMOF80bOz0u6H5HR9aD4ahtZxM4OkIfTFhCY+kX8u4BZ38IFHdowMDGR34WF6VZ35c22dMfrMo3taks5jNI4rr8AIzQJhLq+P9ol08HE3H0ymoEe+orHipmyN6qCMNXJ30Lz22rmJd/7s+4VxuEfZxz6Z
 yhZrbzEk
 Y2meMNFTC8YdQIXNcihwpxRfyHsLYgCC4ujv8epbgpA7svt6Jk/BLMF9TeIWfTgi5rKUnYdfVTJSGWoFsjVfMspy6G6jSThYgk0+UJ94eAwK6eAh9sEQD2c08wSINKHpKymSDl7Q7yXa3630QDoDWKVrLxJoY7D3lNubBQNg/EkU6GkfosDchrsd5L9UR/Bido84MmMa5BoBhzB2G5mtzNnlLFYlm4llZwaZAaZfLevroi04hHEWkIxP2z+ejcr6wcnzA7aYa59qZP62NGv2YHM1dNEr73+X1tVRX0rQXcagBjCpPHkV6guBItwyuHP8AzCqoNg1nBMCzWI4CBhUb1XSadll0TtsxV9+NwIseYMa7Qy3Xi0qOcuOHTwQZQB6ixiyhsihZbc9pLL7tK1RpudQMbW6T+yCQaSS9fDTgSwhd8UST5EZT0h5PLHwjzkM1OXLvIKjye+y80+iTbXy5NV2tYnSBDGL0pce9jmjDn981nCO1/s+HF+velVRcxLOYRxDf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/03/2026 06:09, Mika Penttilä wrote:
> Hi!
> 
> On 3/5/26 01:28, Usama Arif wrote:
> 
>>
>> On 04/03/2026 22:09, Balbir Singh wrote:
>>> On 3/5/26 08:54, Zi Yan wrote:
>>>> On 4 Mar 2026, at 16:48, Balbir Singh wrote:
>>>>
>>>>> On 3/5/26 02:17, Zi Yan wrote:
>>>>>> On 4 Mar 2026, at 7:01, Usama Arif wrote:
>>>>>>
>>>>>>> From: Usama Arif <usama.arif@linux.dev>
>>>>>>>
>>>>>>> migrate_vma_split_unmapped_folio() takes an extra reference via
>>>>>>> folio_get() before calling folio_split_unmapped().  On success, the
>>>>>>> split consumes this reference: __folio_freeze_and_split_unmapped()
>>>>>>> expects the +1 in its folio_ref_freeze() check, and distributes it
>>>>>>> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
>>>>>>> are later balanced by folio_put() calls in __migrate_device_finalize().
>>>>>>>
>>>>>>> If folio_split_unmapped() fails (e.g., unexpected pinning returns
>>>>>>> -EAGAIN), the function returns without calling folio_put().  The extra
>>>>>>> reference is never released.
>>>>>>>
>>>>>>> Add the missing folio_put() on the error path.
>>>>>>>
>>>>>>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
>>>>>>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>>>>>> Reported-by: Nico Pache <npache@redhat.com>
>>>>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>>>>> ---
>>>>>>>  mm/migrate_device.c | 4 +++-
>>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>>> index 0a8b31939640f..351ecd9065d13 100644
>>>>>>> --- a/mm/migrate_device.c
>>>>>>> +++ b/mm/migrate_device.c
>>>>>>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>>>>>>  	folio_get(folio);
>>>>>>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>>>>>>  	ret = folio_split_unmapped(folio, 0);
>>>>>>> -	if (ret)
>>>>>>> +	if (ret) {
>>>>>>> +		folio_put(folio);
>>>>>>>  		return ret;
>>>>>>> +	}
>>>>>>>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
>>>>>>>  	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>>>>>>>  	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>>>>>>> -- 
>>>>>>> 2.47.3
>>>>>> Add Balbir, who wrote the code, to comment on this.
>>>>>>
>>>>> Thanks Zi!
>>>>>
>>>>> Just wondering if there is a reproducer for the issue and how the fix was tested?
>>>>> I expect migrate_vma_finalize() to be called for folios, even when split failed and
>>>>> drop the lock.
>>>> Does migrate_vma_finalize() do folio_put() for failed-to-split folios?
>>>> If so, how does it distinguish between split folios and failed-to-split folios?
>>>> By comparing source and destination folio orders?
>>>>
>>> We reset the MIGRATE_PFN_MIGRATE flag for failing to migrate pfns.  We do a folio_put
>>> on the src in finalize, if it is split then on all the split folios as well.
>>>
>>>> What we see from migrate_vma_split_unmapped_folio() is that
>>>> it adds a refcount for all input folios, but only drops a refcount
>>>> for the split folio. Isn’t it cause failed-to-split folios to have
>>>> additional refcount?
>>>>
>> Hello!
>>
>> Thanks for reviewing everyone. So its very difficult to create a reproducer I think
>> the extra reference would need to appear after migrate_device_unmap() but before
>> folio_split_unmapped() in migrate_vma_pages()? That's hard to trigger reliably from
>> userspace.
>>
>> The fix came about when Nico indicated there might be an issue if split_huge_pmd_address
>> fails in my patch [1].
>>
>> Below is my understanding of how refcounting is working over here step by step. I
>> might very well be wrong on this, and the refcounting is a bit all over the place
>> and I might miss a reference change somewhere so would really appreciate if someone
>> can confirm this!
>>
>>
>> 1. migrate_vma_collect_huge_pmd():
>>   a) folio_get(folio) -> +1 (collect reference)
>> 2. migrate_device_unmap():
>>   a) folio_isolate_lru() -> +1 (isolation reference)
>>   b) folio_put() -> -1 (drops the collect reference)
>>
>>
>> Without this patch fix:
>>
>> 3. migrate_vma_split_unmapped_folio():
>>   a) folio_get(folio) -> +1 (split reference)
>>   b) folio_split_unmapped() -> fails
>>   c) Returns error — without folio_put() which is the fix
>> 4. Caller in migrate_vma_pages(): clears MIGRATE_PFN_MIGRATE | MIGRATE_PFN_COMPOUND
>> 5. __migrate_device_finalize(): sees !(src_pfns[i] & MIGRATE_PFN_MIGRATE), restores the folio:
>>   a) remove_migration_ptes(src, src) — re-establishes user PTEs
>>   b) folio_unlock(src)
>>   c) folio_put(src) -> -1 (drops the isolation reference)
>>
>> The split reference in 3.a is never released and the folio has a permanently elevated refcount.
>> Unless I missed a folio_put somewhere for the refcount increase in folio_isolate_lru() (2.b)?
>>
>> Please let me know if this makes sense!
>>
>> [1] https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>
>>> Thanks! Yes, the patch makes sense
>>>
>>> Acked-by: Balbir Singh <balbirs@nvidia.com>
>>>
>>> Balbir
> 
> I remember stumbling on this while ago also. The folio_get() in migrate_vma_split_unmapped_folio()
> is balanced with put_page() in __split_huge_pmd_locked() (freeze = true), can't fail for device pages.
> Folios at this point are unmapped but have 1 refcount from "collecting". 
> After folio_split_unmapped() the refcount(s) is still 1.
> 
> So it seems the code is good as is? A comment though would be good for the extra folio_get..
> 

hmm I dont think the put_page() in __split_huge_pmd_locked() is there to balance the folio_get() in
migrate_vma_split_unmapped_folio(). There are other points where split_huge_pmd_locked() is called
with freeze = true [1] and they don't get a reference before calling split_huge_pmd.

I think the folio_put() in __split_huge_pmd_locked() freeze = true case is there as migration
entries are being installed?

[1] https://elixir.bootlin.com/linux/v6.19.3/source/mm/rmap.c#L2334 



