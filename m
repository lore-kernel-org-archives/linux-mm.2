Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC51E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B622F6B00B7; Sun, 21 Dec 2025 04:47:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0CA36B00B8; Sun, 21 Dec 2025 04:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39926B00B9; Sun, 21 Dec 2025 04:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 915C46B00B7
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:47:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B9446095D
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:47:27 +0000 (UTC)
X-FDA: 84243000534.09.F0B38EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9CBC3A000B
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:47:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y5a3IyuU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766310445; a=rsa-sha256;
	cv=none;
	b=tooLucAK6J1zPezaubtOIC/JsAQQWJlAjYUZJtCjHZNjpNxHnj3zMrkw3fOJ5QjfJg9Gzk
	mXBcE2i5v92D3jQQ8zgV6oZ3VLTd1a0zg1B7gk7Mr7GwfxRSiPd3kmVQ2gA0SxRJh6KfSy
	QF/oDIF8Ej8WztrvpqI/snWdixL423k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y5a3IyuU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766310445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQtdbxqfQQvhkiNPWH73yUn3UODlDSbgg6qD0h/9gp4=;
	b=PGh9aC4XuxrrDWXeGJyf3YYvR+EoKw+xuep13PMG0NtSrxf0M4ovOCsmUFNOgptjtlPYH7
	Lffi0d+rB3A3hmLRR4pyYsxFLQ6+Wi6xTdsu+MK00I0gLtanZ+BEijiFi5R9/py7njnHvH
	p3Z4kaYCiuEqgyEH1jFEZc07mL1wAGs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B66560007;
	Sun, 21 Dec 2025 09:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4EEC4CEFB;
	Sun, 21 Dec 2025 09:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766310444;
	bh=vp604r4Y7Pl/Q/XQ0942K/pumGcTi3Mwg3rv81trnYU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y5a3IyuUg7cHuPhkilmmGKhepHgkuzS3NVjKbESjeiiMvbL/fT4SNJPyFaVge+B1P
	 mN/rr1dxTkNVPQkSiNwAoMgQLH+TCphVBIy4SJA/ixHVhAPI7+R4D+KpNi0uXkthFL
	 ib3M6v/eVKmGypOTEY57G1Id4Tyjm6gnXtvMEctdCsmafWaVCeeJJ6c9jO0wm7wdGg
	 L8L9V227qyIwX1wCkTznCxqJiUMVjMHR9ADiUMuKQjl6eVN4CLUdWT5nz6rQ/sQrnL
	 vLHQnen8IISLTAG/azQ5sdbJ0i+KOlOpqhJ92v6YPJ+S/s7SNZPBD+08F1SPbzPcNr
	 uw0MW1zdnZ9nA==
Message-ID: <d8854406-7b5a-4c54-b93b-5362cf4d3ad4@kernel.org>
Date: Sun, 21 Dec 2025 10:47:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: avoid unnecessary PTE table lock during initial
 swap folio scan
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, hanchuanhua@oppo.com,
 v-songbaohua@oppo.com
References: <20251216075943.29593-1-richard.weiyang@gmail.com>
 <20251216075943.29593-3-richard.weiyang@gmail.com>
 <de04d804-d27b-4029-9b0b-30e863440aac@kernel.org>
 <20251220033627.xy6yralcx76vucs7@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251220033627.xy6yralcx76vucs7@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9CBC3A000B
X-Stat-Signature: 14oc6tuyikmry4dg5z8zprdqrxrdfciy
X-HE-Tag: 1766310445-720723
X-HE-Meta: U2FsdGVkX1/xmPIJ77pOikVOJ3EzNiBAOdVFSO01VaKa8/2ImsxEwzsmCQw7YKv6L8LZP4JpzM2+xFGtZtifBTrswgMJtiWUnrY1Yd8T+xPju2grbdZA4aNOixgomzmanrlKzNC5zZNo4inBWaAUsbgzTTMJjQwE3ZbM8KFYJF5STrmOpEDZzkJOlkHjN+0lZ/7hGXQIQuIY1uUbv87kbEmm3knqLKaUCjiywLW5SISiBYWCcAzzHEPIr7/cgyK7urWXgxFJV2AbfaKHeRTvPxNPpGK6Ffy0gKdPNuRDeRW39/q9hp9o6Hmev+O1lzEsLUldiPzmQ3IQdAT6T6Lx4T5fzdJNaEV/eyY3nR7o2Sj3yczgrt7DWM80lWbJDNbO4aXqlUbj1AYVz4rj/bZ2JPqfyPUCE9UJVpvzb8KVSzvQZM4/EwnL5RqRyrBqkw42JUc2ZHyjVq7OZXbRnPWJRCV2InJ7gTvpKhUjpuKajBIkOb6BJYu7oK9DE3TYXNn9VGo7OY78Us5luXm+2DtTcgbvO4rcNa5RxBJbyqMWxoPwHVyMvn+xKa0MlV0MoqgxeeZD4uVO9T1qeLWNQyCEX8/z0P15t/rsOjVrNOqZ5pt9PfxpJrllmBqQLv6lx8+qcHx48j2nm23Tbxruo9Zn0MxlX7TL9BjEeT76qVIKlF1+FVnEJkxw6vKA8siK2ji1f4M8d+Phnkb2u2jzEHByU6pMgqSzjdJyqRZ6t68wXNIoj34+oB//F1oEFCYVNDMwh6fs58nn3AY7vav4Z5ctZYzwSBwA7+qSkzee4x23iJv/iWHPaCZOy+C8dATjAxFkYm2qJEi2+H+fv0QbYlzIVhulke0LwtCxrfHjPe33wUgybrOEnEzbBqv/RQzQgCsXzRR4m0BW3f+Wu6cnUEe+PQvnq1EeNJJI+DKpAWcQZg/Yn67y5tmdSCNf4k66dWatLBxKBxFSVDpHxqBMSmc
 hM0ZD0MU
 DYhqpGXgt+7Foy+4fhfT23IBzqBgbPY3/kOnc8Dqq6kqh9cVFnlvZaes46MwgYtN0jLAMeeLseTGO5cg0HjGxmqX1912x568BhkU5hXPgSk9Zo5oNtHhf7PwChyuCyeed4s0cTrALIebDBhKl30phCVG7BJt/Ai6Y8v4305v/vz3VifVold8ShAjtl/sdo99li6XyUr+P06Lo7XynBqlAbyFM9GbvoV8CGYl08SsyfsVJpgL/w60XF/FTa9RAVrdpskpzn/6S7ghUIng0lyqAJdS4Vthnqa3awaGPxWcLzQyEg11KFZjgAnJ0yOaoKMDPj1M+tohRl8sPk9ZcY/azniolQNvaQ5BlpVXgXWPzMLElu/k5EUuP7ZEivg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 04:36, Wei Yang wrote:
> On Fri, Dec 19, 2025 at 09:47:17AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/16/25 08:59, Wei Yang wrote:
>>> The alloc_swap_folio() function performs an initial scan of the PTE
>>> table solely to determine the potential size (order) of the folio
>>> content that needs to be swapped in.
>>>
>>> Locking the PTE table during this initial read is unnecessary for two
>>> reasons:
>>>
>>>     * We are not writing to the PTE table at this stage.
>>>
>>>     * The code will re-check and lock the table again immediately before
>>>       any actual modification is attempted.
>>>
>>> This commit refactors the initial scan to map the PTE table without
>>> acquiring the lock. This reduces contention and overhead, improving
>>> performance of the swap-in path.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Chuanhua Han <hanchuanhua@oppo.com>
>>> Cc: Barry Song <v-songbaohua@oppo.com>
>>> ---
>>>    mm/memory.c | 6 ++----
>>>    1 file changed, 2 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 1b8ef4f0ea60..f8d6adfa83d7 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4529,7 +4529,6 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>>    	struct folio *folio;
>>>    	unsigned long addr;
>>>    	softleaf_t entry;
>>> -	spinlock_t *ptl;
>>>    	pte_t *pte;
>>>    	gfp_t gfp;
>>>    	int order;
>>> @@ -4563,8 +4562,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>>    	if (!orders)
>>>    		goto fallback;
>>> -	pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
>>> -				  vmf->address & PMD_MASK, &ptl);
>>> +	pte = pte_offset_map(vmf->pmd, vmf->address & PMD_MASK);
>>>    	if (unlikely(!pte))
>>
>> Can can_swapin_thp() deal with concurrent unmap and possible freeing of
>> pages+swap?
>>
>> We have some code that depends on swap entries stabilizing the swap device
>> etc; the moment you allow for that concurrently to go away you open a can of
>> worns.
>>
> 
> Sorry I don't follow you.
> 
> You mean some swap entry would be unmapped and cleared?

We could concurrently be zapping the page table. That means, after we 
read a swap-PTE, we could be concurrently freeing the swap entry from a 
different thread.

So the moment you depend on something that goes from PTE to something in 
the swap subsystem you might be in trouble.

swap_pte_batch() does things like lookup_swap_cgroup_id(), and 
can_swapin_thp() does things like swap_zeromap_batch() and 
non_swapcache_batch().

I don't know what happens if we can have concurrent zap+freeing of swap 
entries there, and if we could trigger some undefined behavior.

Therefore, we have to a bit more careful here.

Because I assume this is the first time that we walk swap entries 
without the PTE lock held?

-- 
Cheers

David

