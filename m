Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 798DECD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54246B009E; Mon, 11 May 2026 04:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05226B00A5; Mon, 11 May 2026 04:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4AD6B00AB; Mon, 11 May 2026 04:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE3886B009E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:59:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70E3FC237A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:59:45 +0000 (UTC)
X-FDA: 84754541130.22.68D8D8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id AD12B40006
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:59:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lJimFy3X;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvRQyb40btosTijbcekYBCjcrQlscPMTMIXf895Ko0s=;
	b=qbZiPTNhEL/e+94CQ9QS2SP54yGMg7He/A/RCsmCyGiHJXRkN+coXWBQBepR0wHUNPy3r/
	LqGWYlIFm84JluiW3ohSwgamXG+kc4mSqR+1CRjc4ayvg+uCqN8CqREWhURCT8PyzCucZc
	c3Y62b4FmTiI4z545RAz+MBh9YQ64wQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lJimFy3X;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489983; a=rsa-sha256;
	cv=none;
	b=MazopkoTMV5t7tD/gTFq+OR+Du5lqBdXrY0ixPzi60wusELL+Z6bTN/kJAg9/FV69+nZ7O
	8Q2geW85dvWLqTqZM+8UNX/juuY+CIWjgTeGl6hmzuxqzfpZNk9wr0QX9n7e9Oo4pM+emg
	XbHLE1SWurDDpkCS3EvqD/5TDqw/Xf0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 119F06001A;
	Mon, 11 May 2026 08:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50192C2BCC9;
	Mon, 11 May 2026 08:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778489982;
	bh=4GymnGq3ZLjKJIR22N12zMnTywRK44ioF56s34ZZC5E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lJimFy3X/ep7ZSi2QaKlVNTJ6kglkHTPykSY513m05guI88+vbz/L+C0vQE4INe07
	 c7OTNGE6TYmqojp2BlFWhUDgJCkJ6wNMWbZbjxlqrTg2TTAiRgUhC1LAnYdkNqQ+SS
	 PDtVehOv3x6iIYOC21dFd7JdD49RJwdTADiX+hRvb+v53oAbuIVLcPq0t4sK82qHhE
	 Hb90laTMWpqdc9N5fTChYDsqoa6zBGv7SZR2WdNDbgEErSlLziEe9Bc6cSlcb/9gqP
	 NdjFZ/W81ptX2HYNznqUonr6EMdyOE8K6QQKHrlgxUdSO2PpymJnIa/Z6JlrfG26F4
	 vlqfAlOGwLQTg==
Message-ID: <f3ec1b78-e405-4b58-8588-faa97070cb3b@kernel.org>
Date: Mon, 11 May 2026 10:59:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/9] mm/rmap: refactor hugetlb pte clearing in
 try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-3-dev.jain@arm.com>
 <5a4c3c3d-66c8-4ef6-bb6a-2ec0e32694a1@kernel.org>
 <d2f11bbd-93ec-4a7e-9de3-ed4541914ad9@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d2f11bbd-93ec-4a7e-9de3-ed4541914ad9@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: na8zi8scin1txm78g48bb6txnezhoxuh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD12B40006
X-Rspam-User: 
X-HE-Tag: 1778489983-658724
X-HE-Meta: U2FsdGVkX1918r/djFL2knDDns4SH83YyzFwnpdoRqsrx0a3acZM06HtMl3w46F5XvmIFLtD/NNAXDNlOuXCVgBCcudatkb8tmzL8LnoZBAq3YQn0OvD57kZWk6aKaCKQhPEUVVZpAyJ5VTqh5aCEuYD5Eqxf+2OH/CCXRGBuMOsPMpTGIKeyNzLq/P4enGFfJTvnwnpQN5YBMytWjsi96V2IAIvRqBudvr9efZN0aGK5GOq9nbQpaPk99j8l3Iv0Qp7BNAaNqmCqcxzTEIEM1vntKXXt2/HWwSfbbtLH+Ds2t115oYq+Ms7zHkYIvfl65Bxj3gC4b9TrNYebkPXiD2UR9XElsxyAX0q8P07rdbp6INhVoOOiQNKiDm54zQX8s26wyNAjUhZX+GsWybhDpTPZwaYvp1PLc2ZLOKwxaJaL9dDs7AKBBVZYIdtNpz4evB7k8ZkFl7oi97sV3VSVaK1VPMY2X3OTTV6Zi08qcNfgtiQbAvOS5iLDCcfOGxhCRIgxVm6k3rzYXX38e3Zj+vkk49WiRE2qMEVrNTLtj3JmBXuz15oHYOd0XzWfiXF8ZOpOa/wGNFbhl3E8TOC2CsMpM91S3HzY24aTh7Z0YN4jz+/zn1JXQI5WJBLjNNK4JmNAvqVdHgDe0O+2JVyjsy8pScBMNpTv4epOgNaRsNuVeAzDVWc+H2/iQxeICTy5N1Mw19Urr1Mwq0THP1XAMzsR0vMa9QB2raeoK9zJbOHuoFLyyMySHt7t+w6m3yPlJHBfUqB+Gq+mb2aIr8j1LVnw8KKnPH32NERYzKTlo14nCLkdyg5s6stlcxH2TH/RdtsZFRvvr3Ry2HfYqF6tsbCM47WVSX/a146xw38RTqDPWoN99o0WAu8yOvwGmdCVgKquXlF0pqAyBqEgX8DCYzD1RVoF+C84e4eU7XRcYDMa4ORrvAbPX8G905UCTebOr0tc+jTXN44siPjhPB
 Cl5FODFv
 0Vz7CR2YvyWbVOLeC+CZb3qc2rg5avpLrTRvNbzg3MGL4P9BBTjbA3gon4lNnZd9deV7nfDhAnw0lTQq54185MMi1w+6QmLxKixtIRQdtXvRFExabK9kd/KsM2cHE/bNNmeMFsaa0ymq7NjtV+DGMT2tjKYzdQgGVTtJHN7S1NgvXl6JlRuLSZmozmBI56M0aXEbSVwE0qeLOo0QUdmG4+xOzm2QbbholhX+LBggQhuaLIhIV9Q/wA+SsPReor9gg6GngLsUWjZG+UKXNdHE0JUhFwUlgPMeh8Ibi5QnfvrL5lUlQzHlJ3kXzHguHdazMglbja2nT1b8WOIRf4yFgxEBZH0Mb6B565WW3CDTrsgoI/eBGjj73x6NXmpJl3/+v8PCoPvaGFRERM5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 10:53, Dev Jain wrote:
> 
> 
> On 11/05/26 12:40 pm, David Hildenbrand (Arm) wrote:
>> On 5/6/26 11:44, Dev Jain wrote:
>>> Simplify the code by refactoring the folio_test_hugetlb() branch into
>>> a new function.
>>>
>>> While at it, convert BUG helpers to WARN helpers.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>  mm/rmap.c | 117 ++++++++++++++++++++++++++++++++----------------------
>>>  1 file changed, 69 insertions(+), 48 deletions(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index a5f067a09de0f..a98acdea0530a 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1978,6 +1978,68 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>>  }
>>>  
>>> +/* Returns false if unmap needs to be aborted */
>>> +static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
>>
>> I'm wondering whether we should make it clearer that this belongs to the
>> try_to_unmap family by calling it
>>
>> 	ttu_hugetlb_folio
> 
> Yes I had suggested a ttu_ prefix somewhere else in the first version,
> Lorenzo didn't like it (or probably he didn't like that specific use
> of ttu):
> 
> https://lore.kernel.org/all/a8b06f36-98e1-435c-881f-67242bc4304a@lucifer.local/
> 
> Don't know about a better name other than "commit_ttu_lazyfree_folio" in
> that case, but for the hugetlb case, I like ttu_hugetlb_folio.

Yes, in particular, once we just process the whole hugetlb oddity in there.

I don't really care about the exact name as long as it's clear that this is not
something fairly generic.

[...]

>>
>>
>>> +	/*
>>> +	 * huge_pmd_unshare may unmap an entire PMD page.
>>> +	 * There is no way of knowing exactly which PMDs may
>>> +	 * be cached for this mm, so we must flush them all.
>>> +	 * start/end were already adjusted above to cover this
>>> +	 * range.
>>> +	 */
>>> +	flush_cache_range(vma, range->start, range->end);
>>> +
>>> +	/*
>>> +	 * To call huge_pmd_unshare, i_mmap_rwsem must be
>>> +	 * held in write mode.  Caller needs to explicitly
>>> +	 * do this outside rmap routines.
>>> +	 *
>>> +	 * We also must hold hugetlb vma_lock in write mode.
>>> +	 * Lock order dictates acquiring vma_lock BEFORE
>>> +	 * i_mmap_rwsem.  We can only try lock here and fail
>>> +	 * if unsuccessful.
>>> +	 */
>>> +	if (!folio_test_anon(folio)) {
>>> +		struct mmu_gather tlb;
>>> +
>>> +		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
>>> +		if (!hugetlb_vma_trylock_write(vma)) {
>>> +			*exit_walk = true;
>>> +			return false;
>>> +		}
>>> +
>>> +		tlb_gather_mmu_vma(&tlb, vma);
>>> +		if (huge_pmd_unshare(&tlb, vma, pvmw->address, pvmw->pte)) {
>>> +			hugetlb_vma_unlock_write(vma);
>>> +			huge_pmd_unshare_flush(&tlb, vma);
>>> +			tlb_finish_mmu(&tlb);
>>> +			/*
>>> +			 * The PMD table was unmapped,
>>> +			 * consequently unmapping the folio.
>>> +			 */
>>> +			*exit_walk = true;
>>> +			return true;
>>> +		}
>>> +		hugetlb_vma_unlock_write(vma);
>>> +		tlb_finish_mmu(&tlb);
>>> +	}
>>> +	*pteval = huge_ptep_clear_flush(vma, pvmw->address, pvmw->pte);
>>> +	if (pte_dirty(*pteval))
>>> +		folio_mark_dirty(folio);
>>> +
>>> +	*exit_walk = false;
>>> +	return true;
>>
>>
>> Can we instead introduce some enum that tells the caller how to proceed?
>>
>> I assume we have
>>
>> (a) Abort walk (ret = false + page_vma_mapped_walk_done())
>>
>> (b) Walk done (ret = true + page_vma_mapped_walk_done())
>>
>> (c) Continue walk (call page_vma_mapped_walk())
>>
>> enum ttu_walk_result {
>> 	TTU_WALK_CONTINUE,
>> 	TTU_WALK_ABORT,
>> 	TTU_WALK_DONE
>> }
> 
> I had replied to such a suggestion here:
> 
> https://lore.kernel.org/all/caa7c455-7472-48eb-a5dc-145e587d67ba@arm.com/
> 
> Probably we don't have any other solution : )

That looks like the right way to. The boolean return is just nasty.

>>> -					 */
>>> -					goto walk_done;
>>> -				}
>>> -				hugetlb_vma_unlock_write(vma);
>>> -				tlb_finish_mmu(&tlb);
>>> +			ret = unmap_hugetlb_folio(vma, folio, &pvmw, subpage,
>>> +						  flags, &pteval, &range,
>>> +						  &exit_walk);
>>> +			if (exit_walk) {
>>> +				page_vma_mapped_walk_done(&pvmw);
>>> +				break;
>>
>> In the old walk_abort case you wouldn't set ret = false?
> 
> ret will be set appropriately in unmap_hugetlb_folio.

Ah, right. Confusing ;)

>>
>> When returning the enum you could simply do something like
>>
>> switch (ret) {
>> case TTU_WALK_ABORT:
>> 	goto walk_abort;
>> case TTU_WALK_DONE:
>> 	goto walk_done;
>> default:
>> 	break;
>> }
>>
>>
>> While I like this patch, can we please just move all the hugetlb shite into this
>> helper function?
>>
>> Essentially, get rid of hugetlb special casing in the remainder of the function.
>>
>> That also makes the function name clearer (right now it's only doing a part of
>> hugetlb folio unmapping).
> 
> Okay I can try that. That would mean splitting the pvmw walk for hugetlb and
> non-hugetlb, but I suspect it would be very less code duplication.


Right, and it would also be clearer that hugetlb really only is called for
hwpoison handling.


-- 
Cheers,

David

