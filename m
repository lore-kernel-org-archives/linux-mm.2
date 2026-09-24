Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1799C98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 11:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF68E6B0096; Thu, 24 Sep 2026 07:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE9E6B0098; Thu, 24 Sep 2026 07:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC756B0099; Thu, 24 Sep 2026 07:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6B86B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:23:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0A5D1602FD
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:23:28 +0000 (UTC)
X-FDA: 85248420096.18.11EFEAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B56D20002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:23:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iys0hoQv;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790249007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhV4Eg9T44LxurIyyLkrw3Z+JXOB/cbv08FDOkNxdEI=;
	b=CMmy9I7JXjHrmC1/3w0RBNQNuRU9GUepG4JDDxDQtA7mCu2gE0qlj6UWfPAdtKqApesDOB
	IeMsarHSLMO0dmGmgs2EsEhWPMa/+O3gzN3VJkQ7D6bg0Wc6Cd+fOjdWviyFNY94tOMKoI
	A50lmcEyqRt3ZUE6UnRZRZMIMq+jmBU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iys0hoQv;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790249007;
	b=icZdagperfn2APFHGKnZ4fltu9crxw5HXiEq8fM9nJSdvTqWD8ctQh1qr0/pjnjf2Z1Gln
	hBFoqxzM2M5xnSiHpo6Imlq6+Ktrxx5WiijAhZYiOwVA8Ve+otyFGuV232oBTWoAtfMzbS
	RMEzoMqGUJJj0OfMgGvDV/OA2okfoR0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B14640AE0;
	Thu, 24 Sep 2026 11:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907871F000FF;
	Thu, 24 Sep 2026 11:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790249005;
	bh=hhV4Eg9T44LxurIyyLkrw3Z+JXOB/cbv08FDOkNxdEI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iys0hoQvNxPyv8wESrU1CfxLXmoq9WrKRFiR1q+ees7JXBwaj2n3/C8qQ1Bd15T2o
	 CF37ogQyhsmJI6Qh5mQU20iCjwsaRkLFhO086AuAj0s0euAFqTp5cZZ87IGz355Fl6
	 ULSd3TUYTyhuXxjR9w/ZZzX36uqKtsaTYTiVia+W3Dv3wd0JNS1+XwMhjxblt7W8m2
	 +SjT5lRat2kTufiGMeJF33jz+juHeo3RegrqxwY7yH66TzPZ8VcyZyJcWeStyM3YPE
	 ozjEQqjYypddUu1UannWOXsNZ78JqHgatubSnIdz4jCDcQwPZBGGk+Stci0nzGQbZq
	 GAVDOvFO+1xIQ==
Message-ID: <9a36d20b-ae48-49a2-807e-28e5e1461974@kernel.org>
Date: Thu, 24 Sep 2026 13:23:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] Linux MM Alignment Session on Hwpoison on Wednesday
To: Kiryl Shutsemau <k.shutemov@gmail.com>
Cc: Harry Yoo <harry@kernel.org>, David Rientjes <rientjes@google.com>,
 Amit Shah <amit@infradead.org>, Andrew Morton <akpm@linux-foundation.org>,
 Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>,
 Christoph Lameter <christoph@gentwo.org>, Dave Hansen
 <dave.hansen@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mel.gorman@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <mike.rapoport@gmail.com>, Peter Xu <peterx@redhat.com>,
 Raghavendra K T <rkodsara@amd.com>, "Rao, Bharata Bhasker"
 <bharata@amd.com>, Rik van Riel <riel@surriel.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>,
 Sterling Alexander <stalexan@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yang Shi <shy828301@gmail.com>,
 Zi Yan <ziy@nvidia.com>, William Roche <william.roche@oracle.com>,
 linmiaohe@huawei.com, ljs@kernel.org, osalvador@kernel.org,
 nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, muchun.song@linux.dev, liam@infradead.org,
 shuah@kernel.org, boudewijn@delta-utec.com, linux-mm@kvack.org,
 Breno Leitao <leitao@debian.org>
References: <45af1b22-49d4-5d60-e7ad-14a1a33c8dc9@google.com>
 <arPElEV0zDhXrteb@thinkstation>
 <42221bdb-44f9-4c86-a572-1d1372026836@kernel.org>
 <arPdnxhX9VHnDx15@thinkstation>
 <ce6659a6-a658-4311-8c8d-193d309bf85b@kernel.org>
 <arT9TVHmM3WDjWnk@thinkstation>
 <6c79bc6c-abb7-407d-84cb-c9ab29732646@kernel.org>
 <arUDeFDdSV1xANiU@thinkstation>
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
In-Reply-To: <arUDeFDdSV1xANiU@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B56D20002
X-Stat-Signature: k59csbf4kj4ybutscgb6rmoxgmb3berm
X-Rspam-User: 
X-HE-Tag: 1790249006-53363
X-HE-Meta: U2FsdGVkX19f9LXWUE2I1rYV+eQd5w5BoWa6ZtZMAtxAgkVIj7PPxk+V5xjeWYBbSmj8ViloYEmWlVNAxC8CAml6oO8zfmTMVcaDbxTCOkNtYaZU6qx++WmI/4wWQh3s4TN1UyaYYrkVMGTWkVWPB3CTm6ZyQ5APxgXHwda/hKt0/16ZzRTv6oZbueIDQVPkd0h2HSXjG8di+lCI0Y3VPm558hLMPNkd5eQPdn3QckJEAo7ORBez9jh52x8I4hE39IBDqDaQpFFCcTcIocVqza2v/BUvgds91OTPGhmUqj4F72XfGR1nHBouSr9rHtud2f2ZKjJ5G1uNhUNKZG6lri0Gp/W+Gb9OR8ML0icalBPXT5XMv68V+vsOTvcir4A6VDgEMpISBcR/laF4YHAiGVBKtUyjNL5zjUeKVAvW5sken7UyFa5/BJGIpkfCRG+3P0iiPdzpRxvKLBfr9p/1ff9RiqXkKOWI0aTJiqcx14IRSpZHKiPQqdLhFilZyGp98JhXrXgiH7KhJHA5jbkPZgMB/JepFrQMm0Et3DJbIibV88nF+mfnBRWuQwDI4BZnIoRhFaLaw2wYKixOLo/cjaEWv9q45oen9TEiIltJ9SI2+HGHzMVeLDF9dx0edZMCEH+FamzrOS5xe5ihmpHCluVhiBnqB6xnn8aCmMkfS9yHxkoV10zViq7dU+TSuDFwEvWm0MiKgJJzybk6RUmcvNtfoJpbcGvXTuFJa3jnChxlAsK8G8Pqp8cZMR+AzHOExdZcy7n4qdu20x1L99kSLkrKlOPRfZnzwpYE+Q9ubK5V5mls/mIOPSP0YSFtbn25PgivSGINUsxuSVvR6wLKpjbzcVxczdQSngKZJrfpA0QCTPne/ylsxj181dhqfdIjA4bpqv7Jj3KT1FVyVJx5weD7cyTnLzy/S1Ie6ragPvNM2/WyGEDqSMCTp3KrVjByswBISrworqN87RU/4FS
 k2/lfdCm
 9xxdjqUDWMN0XJtlSmtwRfZ0Txcyi9wrTVuEdkZ+DjSqfCgTjiSNBZyyAjVYLka2h9dzTfdrcaGfl6us0nkv0itJb/w+o7wGZtfPGylTNMKBqp5Dhr1Cz77YAVKrBiC0dd262w4lXnO6l6BAWkWQeHmFENj5DSvwubkFmknA5NyFEcjOp6TtTpmQR3xKIRHJyiejmDYT8zTa5yi8qsVOGX8KcY1m7Z/5PaBbr133Sk6a99RHKt+XAXeIm8rFNncYs71ni0Sm4tUzNl9GqgDIEM8GzXcXq3SN6QZE7kuqgC8gkXV+dE87U4UhapNR7f/nKmBufxaN8Yy92lC6MTpmRDO2kLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 13:19, Kiryl Shutsemau wrote:
> On Thu, Sep 24, 2026 at 12:55:10PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/24/26 12:46, Kiryl Shutsemau wrote:
>>>
>>> I suggested using a bitmap because ranges are not scalable. Some memory
>>> failure modes generate errors repeated across the physical address space
>>> (think of a column failure, for instance). It would produce too many
>>> ranges to be viable.
>>
>> These are in 2M granularity. Is that a real problem?
> 
> 2M is arbitrary. We can trade finer granularity for the size of the bitmap.

Sure. And if you run into scalability problems you can go to coarse granularity.

> 
>>> We already consult a bitmap in memblock for unaccepted memory. We *can*
>>> do the same for poisoned memory.
>>>
>>
>> We can do many things. I don't want it.
> 
> What's wrong with it? The last step on allocation from memblock check if
> the memory is poisoned in bitmap. If it is, try again next range,
> starting from the next non-poisoned address.

See my reply to Breno on the other thread.

-- 
Cheers,

David

