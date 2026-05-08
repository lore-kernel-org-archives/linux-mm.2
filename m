Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E3BCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 10:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E146B013A; Fri,  8 May 2026 06:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E151B6B013C; Fri,  8 May 2026 06:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B716B013D; Fri,  8 May 2026 06:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BFFBB6B013A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:51:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D58B1C160F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:51:41 +0000 (UTC)
X-FDA: 84743936802.21.69F656D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8E9AA40005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:51:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hFyUY/4R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778237499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGGhdmtD4t8YuerKBjceRuz77LrqZ+pIjvP6tCg1isA=;
	b=G5EiAaecdmUMoajvNV0CiLiSHYiE7NNQjjr5zKyhR/npzPNDb1COYGjVN0Lg+Uub4DLK/y
	XciwUATwtw/e98kTW4/3BfjPGIKla3uUezjf7GWfW1qpx8V+PLGZy+iP2k9YbYD4HzT148
	Ph9191kV6GNEi7a2PRe2TpR8E5mD1B0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778237499; a=rsa-sha256;
	cv=none;
	b=tJgC9L1zTcXa+aJJloNxUEfAlUHiSoTwUFNm6Nn5FT4M8Put1vjz5eYMKqPLyntI6fT5kV
	FE2IwLJ4/zwF3Ts+ZA2Tkm3lugpF3kYpRc/8npZFuXa85gMhtgEbSRotWER5UInPF+O0eR
	Oi5aHo/or7/iD9t1aC0e7Dn/8WmEx10=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hFyUY/4R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6156E40181;
	Fri,  8 May 2026 10:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6125AC2BCB0;
	Fri,  8 May 2026 10:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778237498;
	bh=qCpEEfxXt+O2YalNOz8YFSPd7ea9aZm7SxUJ43Dltv4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hFyUY/4RVuCp9PbaDxytWEEh5iyW1CSlyT8wIvpIfGE+c17XC4wEEtzslZWwYLIPK
	 lngFKI70LiyK0+lA4OOoIvpfjpAtULpiL6HuAMJWS0REi3HtCWqJglVQSm4G8wrpGx
	 X5BrVT0vHz5MUiDzsBEB6ZzWqVskqNqpamiHDQpbCMtmQLLM3/voRHlXN/OiuuXbAG
	 R291+c13szL/G7sg10Cdllhc+46mqJ+Zh1alQ4NkIB41hRGiMsRVg+Bsvj1MLr4P7X
	 7/SB+xOG8ybgJb5B2J3X4ISSt29Lb/qYJo7pjmWRKULLsAeEUWxDDrs1MraCRaMFaD
	 P8gNZl34eATiw==
Message-ID: <32fc4c35-acdb-4202-8369-ac0fe00c5b86@kernel.org>
Date: Fri, 8 May 2026 12:51:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/mm: fix freeing of PMD-sized vmemmap pages
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lance Yang
 <lance.yang@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
 <0c20d1e6-1a39-42c5-8c94-9bd2222fb6b3@kernel.org>
 <20260508092341.GP3126523@noisy.programming.kicks-ass.net>
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
In-Reply-To: <20260508092341.GP3126523@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E9AA40005
X-Rspamd-Server: rspam04
X-Stat-Signature: r1w6wmswk6f75qh3h7sr9n353hwgs6k1
X-HE-Tag: 1778237499-428496
X-HE-Meta: U2FsdGVkX199Ib5Vuw4xx20UvfUST3cWyHB6pw1RTmykwmdoNo4mKkbArIwCV/Vazrln/ksy7hH24nYsFwnMv+mBXDhUGAtgVLiPngzrMTOay4kOkGNYr0wq8jBtz+xiPzZLWpZ5ZhlL6QB3CAslAuIlumdokmQourLlZHF/6koUtD+KUpHHVwDemPWyqp2n9Ae9nq73Urg92HUKPIdNo1vPofwz2n7FsD/MojokeFFhkgODfMC1QGzy8LMYl5dpaadPyMOlxhQLktFubj1goTo2lBPEwqWxCUXhhBaSG41D4pp2yAcaoCar2eB4LoM3I1kBdHAvRfpRtG8NezZjDoMl/+vl9edbWcrxWlJBaT2hF9FzkJ+q076mwK76r/o95rT6LgC3bJJyBGSAIygKD4qR36e6QvZ9rvugcm2iXK4reCVlsMZzb3sxqx3DujuhiPVc80zhECVGiPj+qx0mERv7JMJ2ixmZ3WzKfbOi4EAejvxF+Mc7DL350KIsIbP8E8PD7oI7HhxfQTIIyTP65yhcM+bs+g7GR2OQ4VnYEQEjdXHkBk9pwvF6OxHEb8Ckeutp6Uog94aHuwcJkp9ZXZ6lnX9nkKCJKT5dA8QBRYKKplUfeX6FoRNKAeEpVCnVfrFbETbaF4Z8L7bFkKQpva90FR9YwUsi/C7yl7TSoWKO4xpoIDYFUHGl6lkwW5gncnm0JD3FJmbkixQGCNQjh1lM0xLld1eD2nN4SYZlhYlyzN089yQ3A5Q6hbDQWdqyFf+9CWMAdTfmzdFgWAJIb8M2K+zV0H3u9qVND+yQEDEifzAQ+darUEW4qowFAchXnFY+dwE1UNU0aNfwnQpaPELvjq5pR6EyHkYHrkk3CHnulUvGx/TLQbK6A2o4bpXZqmeTBGb3rM4cSGUm8K7TKem/+gVusB8NKiB1oIGRDHXBdtUDTC+v8dWg2VjPre972tIVajtArpXaPEbjain
 6oYsMhU/
 KwhgS3wS2OBMoGoD54MDmyjZ0B+FEBzcElzYvnybI/E6kSSj+U6+UGtxgRQRffYWGOP8FMTClgaRupX68kHvISBjMAL5l9Va2GOdTtjGSJhLPymXyHDMdayZrYq4hjpclXmy6emN0zGdFskFSba+bQir0AbIrOOzRdYprlkdbUb1Hii6JyMS/euUiOF+Tau/O5NFON3cetRgJNs1UepWeNh4Pfx5OckuUvDHoTGCjFvdFOunPlFPIHvRGR/0pjT9cieu5GlGvfv7glTqka9V8mc6cxzpY1pX4z60o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 11:23, Peter Zijlstra wrote:
> On Fri, May 08, 2026 at 11:19:26AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/29/26 12:49, David Hildenbrand (Arm) wrote:
>>> In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
>>> from freeing non-boot page tables through __free_pages() to
>>> pagetable_free().
>>>
>>> However, the function is also called to free vmemmap pages.
>>>
>>> Given that vmemmap pages are not page tables, already the page_ptdesc(page)
>>> is wrong. But worse, pagetable_free() calls
>>>
>>> 	__free_pages(page, compound_order(page));
>>>
>>> As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
>>> except for HVO, which doesn't apply here -- we will only free the first
>>> page when freeing a PMD-sized vmemmap page, leaking the other ones.
>>>
>>> Fix it by properly decoupling pagetable and vmemmap freeing.
>>> free_pagetable() no longer has to mess with SECTION_INFO, as only the
>>> vmemmap is marked like that in register_page_bootmem_memmap().
>>>
>>> The indentation in remove_pmd_table() is messed up, let's fix that
>>> while touching it.
>>>
>>> Note that we'll try to get rid of that bootmem info handling soon. For
>>> now, we'll handle it similar to free_pagetable(), just avoiding the
>>> ifdef.
>>>
>>> Tested-by: Lance Yang <lance.yang@linux.dev>
>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>> Reproduced and tested with a simple VM with a virtio-mem device,
>>> repeatedly adding and removing memory.
>>>
>>> Found by code inspection while working on bootmem_info removal.
>>> ---
>>
>> @x86 maintainers, do you want to take this through your tree or should we merge
>> this through the MM tree?
>>
>> I have another MM series coming up that will touch this code (no fixes, though).
> 
> I'm thinking this should go in rather more urgent, yes?

Yes, please :)

-- 
Cheers,

David

