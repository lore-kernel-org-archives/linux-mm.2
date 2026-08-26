Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C08DC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A252D6B00A0; Wed, 26 Aug 2026 04:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD616B00A1; Wed, 26 Aug 2026 04:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9131A6B00A2; Wed, 26 Aug 2026 04:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6722D6B00A0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:02:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2BE014027C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:02:19 +0000 (UTC)
X-FDA: 85142677998.28.2D74D84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 43AF810000B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:02:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNZ4G9mi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787731338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDJRoIekcA15nn++VrsQGBSf6tTPo6NnuWXU6FKWUf8=;
	b=Jq4xIdiTtA2OvNAgC/XBTVv0Z0x8fF0SIA0COHoosGYXovvkfoZLhiB+pTI/iH2Yak5cKO
	HXK1yN1dKJDHTaX+n/YOWZriwm5uITaxHQekwmrnUtiiAjDFgRwTn4dKneOk7n8nyCkhkI
	4gB1HvaJ5a/a64ktllX20mKJrVJeJLU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787731338;
	b=pbfWlL0BeakRXO4lHO+WwQmmrgeL3CGPxvxDMWIRlo2DClMLdfO31zCHMw9zFlI0ffCfDW
	+3wdOSgO1bR1N3TgWpvGavonPZmTNC5SlBXSJUXSAUcaSH8wBA0cLejlTxFO/riZX/HlfR
	pjv2TNn238rHthfKkX/ssrHzcFXtV6c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNZ4G9mi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6321601E9;
	Wed, 26 Aug 2026 08:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D304B1F000E9;
	Wed, 26 Aug 2026 08:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787731337;
	bh=qDJRoIekcA15nn++VrsQGBSf6tTPo6NnuWXU6FKWUf8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hNZ4G9miUTg8auGY2TB1dTe3EJ6ritKi9XnVUZ2KEsTKRbGa9OwUq7yDMOzITE8eE
	 rVGp358P9iDjbMBMZz/LQXHQ34rEmwyKPAAedbGE5KzkawvQFrIcPIMaqMlAL8afhg
	 9YmN5Sz9PfucI16g28FNIE73dapfeI/rTatpKJduj417XxkJJu2J8UYopMxmxlU6gD
	 /+D5QQiMhWuT9pAsZdRsS371sLoGTS3nHRrjuo2AR6qrfXoUR6RNeCVadwGBVJz02s
	 FirKLBJGGWjTMfOTJp657pDMr17tFqKvCqghrlOQrgOFaNiWc2ijzZrAluS7XkoW6x
	 bDNa4+40dmcSA==
Message-ID: <7e4e9662-d876-4493-a0b3-e31640937dd1@kernel.org>
Date: Wed, 26 Aug 2026 10:02:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
To: Eric Chanudet <echanude@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <5970a8d4-fe7c-4dde-bdc8-1c66bfb57f12@kernel.org>
 <ao3CQicH0t-k95NA@tiehlicka>
 <ao3gLqsF4WSeKBIa@echanude-thinkpadx1carbongen13.rmtusma.csb>
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
In-Reply-To: <ao3gLqsF4WSeKBIa@echanude-thinkpadx1carbongen13.rmtusma.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43AF810000B
X-Stat-Signature: p34niukupoa6p8jfnz1k8867zd9nof84
X-Rspam-User: 
X-HE-Tag: 1787731338-590729
X-HE-Meta: U2FsdGVkX18y1tuRpYcP9R3BdoXviKhPZcnR80qJ0FdmOZ5tWVI9zR8tDhaC9tSkCYcxeLV7QyqmoEg6/G3sUwpwZwkG5ZPJtA+7KAb4y9Wu2yPeqZcrBV7EFk0HmLdp2Oj/PDA3MfdZw5S8t9RwwmH1rEBbe1OunE1T34+ibDcdtqjn8p4q+w2RP/GueuI+N+zy8GOfXZd01pteHcWAHtK5qFffkx1s7dFGgcR84VwLxG68VTcCTtNztQJ5ufjsKAJiuW2JjuvcJ18k3ToFKLhGg1YCoYQhqU95Jzn+CkmDsh03UNnw9vR8wxIfDi9GWTqiBoQq/uEniseaPEJQOVnBMdEovKEBmUwM3ZlVdVWQ4EIMrel92Z/q73r6qg0jk3g1awNZzhW5HPRvd2nJvLBLkp5enu6OMFUmUfBf2llD1JWH3/ns/xld0l5NgbF3MdldD8/kzCl4kZq3g0FIg4xteprS/kSVKuVo+3fRA2XH8hdVZCgNAZ5cq+JiEjGlIgHJ1cUBx7glWSO7fN4cp/QVdZdmSbndI0vTcbVMWWMc7+3HK9lD3u+BuPdrhLtyR6BrzyTiW8YACZ8OpI400gdA7Swdlv8fe9rM6YmPb/huFkfZ7EucNso5KVzFhkc6wyaAs1Dc1jF5qjCrNBH3LRl82doMisvSMqOVe7PAMBuMkYfH2bexqMBbl91E0N65WAuKPv7nIAB/gwbHlPqTXjvOVlX04RvBIPvztX0vOW9bzl79ax0Rwu4Atj9+05mwd/EGoNc2/SXk/Q7TjeKAxy8BddUxEC/FrL7bPxWWW8GONJ3X28FxI0LytFfIMnj9F5//2rES9pWhAe1GYCKn3IpwU6QYyaIKNFlD3SXDmHrceVdOLb1gWAD69DrN4uGCIVZ6syYtK4WYSqEBJVciuv5tvOQQuyeULL6K2rCEE53FqY1QSO+4V6PACIrmBaGnhdswhl9PllDFMTyqNPE
 oDZ7PZqT
 1Sd/h/htamK6T3HNB/T3kZb9hKadHCH7NnmJwF/yGIgnhAzCJpePnFaJOX1yxIv0xg31E6FBs+DvZ+enU+0KCp4qA1zU5T5UIkGY8BeZIvWUpGb/gd+IPZxAyKoI7in1Z+38qVD0pEOSUuoiQyU/e8HhKYRQcY6xy9dk/aRMq32yr63J/aOI+0V8V9GWXAR8mEfovW/9afQAcDN3dx+IVqCHyATWMKWdO3s0Wq24R2iJhXn7AuHdtL/fBhiQtFKzwjF8r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 20:50, Eric Chanudet wrote:
> On Tue, Aug 25, 2026 at 06:26:42PM +0200, Michal Hocko wrote:
>> On Tue 25-08-26 17:45:56, David Hildenbrand wrote:
>>>
>>> How does this e.g., relate to hugetlb allocating from CMA, to then charge to a
>>> hugetlb cgroup?
>>>
> 
> AFAIU the system defines CMA areas to allocate hugepages from. For this
> initial series, I failed to handle it. The intend was to consider it as
> any other CMA area. It entirely missed that hugepages are already
> accounted for by their controller (cgroupfs opt
> memory_hugetlb_accounting) and they are charged when faulted in from
> their available pool.
> 
>>> I always thought of CMA being a low-level allocation mechanism with various
>>> different use cases, and actually the higher-level users should decide how
>>> to/what to charge instead.
>>
>> Exactly. There are many different users of CMA all with different
>> requirements. Then there is CMA reservations if an area is shared and
>> the overall memory consumption. That is why I am really not able to
>> wrap my head around this proposal.
> 
> It is nonetheless available almost directly to userspace via dmabuf
> heap, or as a result of drivers ioctl providing a contiguous buffer, and
> unaccounted for by existing controllers, with the exception of CMA
> hugepages with memory_hugetlb_accounting.

No. The charging really only makes sense for selected mechanisms that built onto
CMA.

It does not make any sense for subsystems that declare CMA for their own use only.

Like hugetlb. Or s390x's VMCP region. Or PPC KVM stuff. Or the crash kernel area.

-- 
Cheers,

David

