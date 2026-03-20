Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751F2108B8E7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F476B0095; Fri, 20 Mar 2026 06:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBFBB6B0096; Fri, 20 Mar 2026 06:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87CF6B0098; Fri, 20 Mar 2026 06:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B45D26B0095
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:08:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 814A81C0CF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:08:58 +0000 (UTC)
X-FDA: 84566017956.04.5280E05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C3EB52000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:08:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IJQM5ROq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774001336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hT6WB5bszTOhqnUm5fy+THkFLxCXIdRQc+jNhfVBqaA=;
	b=L5hOSP3dzEZRhvrLoqPwr8+7MuiMHoHKNReM+SWC6tsIBqn6NptSri0cRE21Iye69V6KXm
	S0/DLfrqRb57TnlaDBGESHVDEZSk/Ix7CgzpknBOah6ywVmFZxWWGiXQQOWBaSAVLh3Vzs
	FHm8nCNCg6XsSi/rmeF7hIbkAuJ5o8M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IJQM5ROq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774001336; a=rsa-sha256;
	cv=none;
	b=TzZPbJkNPcZ1ttF7vOwqliHB7s1RVSz7RsGiBrXcxzNvgz/AYfIkCWFp/cNF4u1la+51go
	bxuBuG6DZJd8RpwCsDdiDDlDERe9nU0zn/+BAD9fproowAGHKBTKtIWXxupaYy9wm7tpw2
	5SYtKFvxEukdKcYAitFRjBEmS7qXLKg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2306360126;
	Fri, 20 Mar 2026 10:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8D3C4CEF7;
	Fri, 20 Mar 2026 10:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774001335;
	bh=GHXK4cL8G6huHh3bZExopaK3L+IrDeQMp6F3V1JuQjM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IJQM5ROqb8W0WDCmr+pHfaRt3XF4XzdYnjPbAW9hrFllS1RIF7cFUmKGPmZygwxjv
	 RCD2I1evj3o3aclTr3lKV+KSzSCmIQPUiKTa+Z5gBQ61tNj5MzuBfg+K2SPmiizG5B
	 i3QTrSxa51XEFQ0uMyaiyyvCdeF7ImNQPBF07lWU5MyE2A8cfxjpSDw1HNr3K+/2ve
	 ZUg981zwnNv9OpNnO2r4kGFiVSazeXPTjTieyZTbcoLeEO/yed+2KwKgk1ucOYZxMR
	 4rdnhK/ENTXtuvVkOw32VDD6rF7rnVrcuE4FpA6yP0W7aY0EjKgvvrmXplPaHoZ3h+
	 p+RFTPzt/fzhQ==
Message-ID: <5732e382-3ebb-43e2-8aaa-4729387cea5e@kernel.org>
Date: Fri, 20 Mar 2026 11:08:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/mprotect: encourage inlining with __always_inline
To: Pedro Falcato <pfalcato@suse.de>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-2-pfalcato@suse.de>
 <9943a6ad-9c85-439c-ad9e-39a694a29147@kernel.org>
 <hmme2zpc4klftq56t7cfuvrzrp2k4t22g264fs3zloohuwelqe@ubrzpz37qlvm>
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
In-Reply-To: <hmme2zpc4klftq56t7cfuvrzrp2k4t22g264fs3zloohuwelqe@ubrzpz37qlvm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C3EB52000B
X-Stat-Signature: s1bh9w3t6tcxbk65cao15ybrax1u66ou
X-Rspam-User: 
X-HE-Tag: 1774001336-987749
X-HE-Meta: U2FsdGVkX1/eIXD53G1BhIYxgVHqVhIOcQHBz2NLh4LeMBpopkB/MynYHgkLkSjWCON45L+9Xux/bRsOLDFzFoG09KBYLWQXcmiH3MQvV7sgcuIYRwiAIlrpiQ7KRYZC/7E06cEejCHb+ouRFsjHSIzY7kGCq3Aov3o/ySBOgpmKWbmXDBnXSDJCpQ2ZuNkuGUwWZHcO5B1OyrRQ7Q/VxUaNTx+CATw2X12WM06itHKb31izqHfyfxsd6HVQieEqzx/6gH6fGXWN7KOYzrkcUOfWGCX0lc8mH/WqvnIGxlZV3j1poGEiRVucPXE6IxA/0DALpzRkNnOp7tGwpEaKbO/8vNPY30JGLp9qycq1ueZ6b4wqKKbIuS5v1ZgqtaA4GfJwCkEofqfaf79Jh6NZExYYHjq3/ktWdBQO/7+TyIxgbMW0S1Z6WXRqcYcz/qG4nYoYBmWSl0leevIPCv+odS5Bo8v6kn3OGVkODfYB68foI5tiHkFmdbqqm2aThSSPTvN7tKAtl7LHxvCN5nj4+ZZjnvhde5efqIqQ0Enhlog8Fpw37er9c26ita8CD1MSe0AHkVRTw3VQDcqUX6MccLgZARZ7Zu+bW3oAxl3VmIFoOgvPoIMesGlzBPpW8R8RRSpzluKIfjUlelhpxIqVoe0g/w2E3jcD7jAnW/A5Ofe2coRRDma+cmlObIgP2ZesASNQNq/30loD2TN7ymtiTYMJZTycDM+KmQAvCVdacFtbZw8NgQfE34KECKwhLKWXdAV27g8OuVmfJlcCuIJmiW9RXZ2dd4sYX2lZhNVLGm/h/stmfvJ9uDEGbkNObHVnZo+0ViOrKJpcB8+y8dJuCabThzjnAUUtqgK2AW9eqmjYDxNxKWSTdIN0XF6AbXBNqtLddPgnZ0gjMsrqUj+Sxdca29V7mb3mD7ejnZmS4LkqXVPlwWgoF0QX/optqdfRPtbEwPHO/rGIZrcNDyd
 /3uB/4k6
 LC2ibU4OIZH1XSTP154qmntjIgDyviWwmnvfQWaOf+hZYFHN5w4PtW7fnNsZbpLN7kyi10noneY5XPa2SPPCvYA8c16Wttr/zdMLR0J9ib680HqeWQ7MZR+XXcOsZoZWmQ7w33beLPTev7hpXCtW5HaZdEmkIy1DD2tcn2iGuixmB+YJp2SFTuhaV2PnkzfPtmSmdH3AlliWaTlWrKz0JeS8SngLNZ4MUipeFxW45TKVz2eKhw6C/jyG+QG3HRud+0VYDuMY3SHnigvseRkmNqCW3IVUdzse7HSUkAk1+7m+4H/w/GspcybLNqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 10:59, Pedro Falcato wrote:
> On Thu, Mar 19, 2026 at 10:28:47PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/19/26 19:31, Pedro Falcato wrote:
>>> Encourage the compiler to inline batch PTE logic and resolve constant
>>> branches by adding __always_inline strategically.
>>>
>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>>> ---
>>>  mm/mprotect.c | 10 +++++-----
>>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>>> index 9681f055b9fc..1bd0d4aa07c2 100644
>>> --- a/mm/mprotect.c
>>> +++ b/mm/mprotect.c
>>> @@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>>>  	return can_change_shared_pte_writable(vma, pte);
>>>  }
>>>  
>>> -static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>>> +static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>>>  				    pte_t pte, int max_nr_ptes, fpb_t flags)
>>>  {
>>>  	/* No underlying folio, so cannot batch */
>>> @@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>>>  }
>>>  
>>>  /* Set nr_ptes number of ptes, starting from idx */
>>> -static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
>>> -		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
>>> -		int idx, bool set_write, struct mmu_gather *tlb)
>>> +static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
>>> +		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
>>> +		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
>>>  {
>>>  	/*
>>>  	 * Advance the position in the batch by idx; note that if idx > 0,
>>> @@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
>>>   * pte of the batch. Therefore, we must individually check all pages and
>>>   * retrieve sub-batches.
>>>   */
>>> -static void commit_anon_folio_batch(struct vm_area_struct *vma,
>>> +static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>>>  		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
>>>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>>>  {
>>
>> From my micro-optimization work on zapping and fork, I learned that
>> these batching functions are best optimized for order-0 page by
>> explicitly calling them from the code with "nr_ptes == 1" and then
>> force-inlining them. nr_ptes and all loops will essentially be optimized
>> out.
>>
>> With no such explicit constants, is there really a real benefit to be
>> had here?
> 
> Per my measurements, I could measure a real speedup here. Of course things
> may heavily depend on the microarchitecture you use. I want to note that
> these three functions are part of the hot loop and thus we definitely want
> them inlined. Particularly if we start special-casing stuff. You can cut
> down _a lot_ of code if you simply tell it "yeah don't bother you're looking
> at 1 pte only".

That's why I think this change is a lot more valuable when squashing
patch #4.

-- 
Cheers,

David

