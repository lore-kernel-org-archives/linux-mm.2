Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA870CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 09:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53316B0092; Mon,  5 Oct 2026 05:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04036B0093; Mon,  5 Oct 2026 05:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2CD6B0095; Mon,  5 Oct 2026 05:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A981D6B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:25:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21E191401BC
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:25:09 +0000 (UTC)
X-FDA: 85288038738.01.6502FE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 650E2C0003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:25:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZuIjpnA8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791192307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=byVa2dejwe5R5G4MFSTCg2eRH8VZASl2SG1iY0abgbw=;
	b=YeDjLO19RPqGlUXn7Gda140evgSwE8+OhImTaS27iooAHzXqrsJYGEZpNV0ST3ghUKVII7
	m1K7BQZ7zxnBwIeVV6gfULkL4x19dSMTa52pukRvNZXeakOvHVQSHAV1IyrCIY3yPhNyPx
	uU1/JXWLny2JLyxAAf3yuJT+zOv6B1E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZuIjpnA8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791192307;
	b=Z64MFn/tafrS9X6Osy1PCf2lmA/Mr1jVYR27osGY3zs/r5xPsA92876F9mp0HQ+FFaVUBJ
	MHetKOKToxFptYHlcS6G35GeQUbCQ5m4z4ie2Zc73pksWiDm9nS51uP7H7MjWv2rEAgCGg
	YRi11qG9gnZNCioNXNV7j2vub0SAXR0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA27060235;
	Mon,  5 Oct 2026 09:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D261F00893;
	Mon,  5 Oct 2026 09:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791192306;
	bh=byVa2dejwe5R5G4MFSTCg2eRH8VZASl2SG1iY0abgbw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZuIjpnA8ddooEStEs7wryYcVO1ILKnXO+zFolrn4vCFMg5+znQPR09/KaibiR/dAU
	 REi69GMUP0DrPTrMn+DvbpMk7ZK4Od72xgIPVQButQsZ+RfSQT3ooR4P3q89ViCf/E
	 kzcAHClDGvdGI1Z9YWbZfnSzLHAI+7MO+LOYKdpPjW/4klDa8NgdRqinc7yWKcao06
	 nDkapS+x5gHgzSgQV1qpJZabM0ttmXMrB6+Si0xhhvInUcrrvlEnHmz/KVWgUp/oIJ
	 03FYfGFarjbVXAryam41K6H3YWAGhDwQPpsq5LkAsMENFj4mowwULNmnekvXiWrim/
	 aYKz7Wt1ovTaw==
Message-ID: <2b4571c5-8e51-4c91-9d88-11929f200875@kernel.org>
Date: Mon, 5 Oct 2026 11:25:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
To: Li Zhe <lizhe.67@bytedance.com>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, muchun.song@linux.dev, osalvador@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260930064308.58159-1-lizhe.67@bytedance.com>
 <arzVaC2IYkqSb0_U@gmail.com>
 <9a7c026e-f5f2-40e0-84aa-919c988cc136@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <9a7c026e-f5f2-40e0-84aa-919c988cc136@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 593z9qsy3gxx11nxsp3ayw81de68i6h4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 650E2C0003
X-HE-Tag: 1791192307-844586
X-HE-Meta: U2FsdGVkX1+9h5kblA/TkiBbYuNGiQun3EC1TIlLxSvUpMo3+IvHWiPj6whgDPVeM37HVAEAK/qywh8gPwBEcMkPxh7QWUSoNNxVXziojTPD0TVI6/yh0R9whzXGfUAca1l5WfAZiYqUe1mkikEDDK64i5GaLehQtxc5HjOjsevjhHV+Jyt8VAqSXdQjOccJR1Xq+ks0r9tZiS6yIs80WkQdHACyxQUUGNceaqqDpHa03AgUlqeCv1hQItu04Ld/+a4CyHUuXxAhVPN9PhtD6aaPicfGB0pb/w25skC4SU/kj3Ak0BSR5hiicAgOKvxY+i8w/Vfat+GmtfesUalbsJtVYiqkqo/SnCA2pfb2qz9W4qo75FomganlC4loj40enBit/6q1RpXQklMpFa0hODfMbAKADAKeqAlNtgNuaRRoaIcvQi/y9f5ENe13jzfVrTpeDMWZQ/3FH1xrCyYyA7NfuSbbjVd87NGdRNf7hQ/kW56qSYSNDRFE7ZTLbgJTlAVxz6USEzGinebBKuYl83riTZyQi817CqlpIck6uoihEqJWfUk1xrZGWCG41KrZveDwit+Tkv1/y+bWVT0AFv2EGlwvttuvtQycaFemcWOhFtuZwoR2sfMVkgEtGF4pLW/ILqUODcR2J5mSc33a2a3MY6BNkSPCl7G3S42RLceASYGz5jYzaC7K1OOyAJKcXp0k8DDXCdX2pDF4YCQo+ZQMn+c//pjGRu5pU9d9/0stmjHoTC7odlbWuIpaUcomIWH4G55HzpWZaUEieo+MIuc/Jors7XE8Kxdes2rWRixRRcTGB9xYTtXXHoLRxox+sGSEVU2Vntg/fMfH356mohWl0+JbOUHZq8QjuYLABlU6SP75N+9SSK8U3FGTbGmVHuI6jwI28StgiHuaHv2heYU9SDup+SqC8+B/Vwg9Dq17VJNeGbDGOoCwB9AJxfRz7WXQmWlSDXg3TjaVpXF
 TNKtrX5n
 XEskLjwFSjGksyV9BxgNJRuNrN/mAjcABmfjxtfntxHjXKbG2p73CNjfX/QdWZy2YMUmN+7fwuFWPj57tYk2uuj7zVjEWFKrYTBZJdseERyD2bacBMphS1Iub+kcEO6BtGo6C3AZZR9k0/9fGMO4YRnJoWt/656pSNgcv8KODbH2Uz38zG7UAylCf3O+XohoAR8TB9SYfHc7XXJsOXEMDn0kihsGiJmA4usd+iBNSoEzfxDAEgj+gx9NM+7xv8Q+w5JGYUVGNuVMcfBhMpeophpNRqGC1MQ34XWZQCiBL0f2idNekWnBJrxgYoxmXv+OTT+77G7WAodwuDJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/5/26 11:03, Li Zhe wrote:
> On 9/30/26 5:31 PM, Jose A. Perez de Azpillaga wrote:
>> On Wed, Sep 30, 2026 at 02:43:08PM +0800, Li Zhe wrote:
>>> huge_pmd_share() always takes i_mmap_rwsem for read before looking for a
>>> shareable PMD page table.
>>>
>>> That is unsafe for callers that already hold the same mapping lock for
>>> write.  In particular, move_hugetlb_page_tables() takes i_mmap_rwsem for
>>> write to prevent truncation races, then calls huge_pte_alloc() for the
>>> destination address.  If the destination PUD is empty and PMD sharing is
>>> possible, huge_pte_alloc() can call huge_pmd_share(), which then tries to
>>> take the same rwsem for read and can deadlock on itself.
>>>
>>> PMD sharing is only an optimization.  If the read side of i_mmap_rwsem
>>> cannot be acquired immediately, fall back to allocating a private PMD
>>> table instead of blocking in the sharing path.
>>>
>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>> ---
>>>   mm/hugetlb.c | 14 ++++++++++++--
>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index cea25773a6c95..75631101a6807 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -6995,7 +6995,15 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
>>>   	pte_t *spte = NULL;
>>>   	pte_t *pte;
>>>
>>> -	i_mmap_lock_read(mapping);
>>> +	/*
>>> +	 * Some callers already hold i_mmap_rwsem for write, for example
>>> +	 * move_hugetlb_page_tables(). PMD sharing is only an optimization, so
>>> +	 * fall back to a private PMD table instead of blocking on the same
>>> +	 * rwsem in read mode.
>>> +	 */
>>> +	if (!i_mmap_trylock_read(mapping))
>>> +		goto alloc;
>> try deadlock is not a fallback here. both callers already hold the write
>> lock, and that is enough for the walk, so sharing is never attempted on
>> these paths.
>>
>> hugetlb_change_protection() does thr same thing on the uffd-wp path and
>> is not in the changelog.
>>
>> and no Fixes tag either. does this want Cc: stable?
> 
> 
> Thanks for the review.
> 
> I agree that holding the write lock should be enough for the walk, and
> that avoiding PMD sharing on these paths is not the right direction.
> 
> David mentioned that Oscar was planning to send a proper fix for this
> issue, so I will wait for that patch instead of moving forward with this
> trylock fallback approach.
@Lorenzo, if Oscar is too busy, I guess we can paste the overall idea for the
fix here as well (publicly)?

-- 
Cheers,

David

