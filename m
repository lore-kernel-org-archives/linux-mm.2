Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B36C7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887BE6B00AB; Wed,  1 Jul 2026 04:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E1B6B00AC; Wed,  1 Jul 2026 04:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776966B00B2; Wed,  1 Jul 2026 04:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6366B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:54:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC13C1A024C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:54:31 +0000 (UTC)
X-FDA: 84939596742.26.210D87E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 13752180002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:54:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hP8v8/0N";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896070;
	b=ReYd8oNM/QoxqbsaJ+DurhLxaqGcvzi5dG7qr+PVXC9HseQ0CNXxnMyfZiGw5MwppnuAE6
	NLL9t57klj/BP++vcGK1hcAIr1W0dtm35SWPoRtBs2m80C/Wo4FpuGy5aEnwwLLfqoZfpL
	Qad8FTozOXBT2QXpcZ2RN2IVtCg1qws=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYVQIlwEfjilOow910BIkxI5FyBqsmJxN4ghTULpcag=;
	b=W9niyXHcr2GRDapOvrTVhaRG06t+xYoXtaZCgUQHOeLQiRGk5/wcs33nxrrvDDbMoVBesJ
	jja0L8pNj/jLBqRGHAdsx3DOPVckOVzqpzrtUfTvJTwWthtxHg6/4sg5NMbLeYJtbQPjBV
	Rudpu7b/VjRpgYTYrxwRjwAeuZX2J8g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hP8v8/0N";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 585B4423D7;
	Wed,  1 Jul 2026 08:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6616D1F000E9;
	Wed,  1 Jul 2026 08:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782896069;
	bh=uYVQIlwEfjilOow910BIkxI5FyBqsmJxN4ghTULpcag=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hP8v8/0NFELNx7n3MBOKIe3+wR3FZECmPHN8OMzS1Z+7PI8CDHPZL6/DAhC3d2j6k
	 JQncU2m57nDJqNLglA78EdNPuFYWTar8iTUMi1ygT9xB5JyakzTKKv1DiDbGUiuNJj
	 TSVTh1SV41ASts259mfQ+khhbYPuD0qudHIsklGoKVSR7q0CFNx95n2LKg0HcDMAkZ
	 uJy3l11M9gc2fwF4OcYkwrZX0KKTX8r6JdTq7DFSeXaN5A+x4jT6iZqwzNtv0qVxkm
	 D6EfuAbTbOUZr/K2zrR7jALND7Fgi0Us5MO5gQTPsFI+6PAbkzt6lg3Yogsfl3QECC
	 7zGoT0Hq1i1kA==
Message-ID: <3fb5ee48-259c-4c25-a749-1e6b2aa10ae2@kernel.org>
Date: Wed, 1 Jul 2026 10:54:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/compaction: stop recording free page order in
 page->private
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-1-f4ce3930d10f@nvidia.com>
 <4154c23d-faac-4d84-990e-a9a0aec5ed46@linux.alibaba.com>
 <DJLZZTX7E1X9.34WYVOYEX83TK@nvidia.com>
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
In-Reply-To: <DJLZZTX7E1X9.34WYVOYEX83TK@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 13752180002
X-Stat-Signature: ax1ft5xhpd7d8pb1kw95tdpxsc3nej5j
X-HE-Tag: 1782896069-309788
X-HE-Meta: U2FsdGVkX1/E5Ftlipe9iB6T92Z7SkHZ4gBdJ341COnYY/RVcFuKwPYL4iMjyNK23kpoHiAf4W6joRsu9D/ES7/3c22XKGkNZVjEqkNQANkNc5aG9qzr8VHMr5OWdTlA/U/KvMC8zMyG2th4xMs2B0sc98g0NB4FsjzrY7z31GXwyU3JgmuRz2IRDLZIVBGUQp4MCPd8S/Uk/ZWLQdeXjm7ogmpmGIpdHJBpRyhGsSCylqnnoeA2v/mjei66DOEHM8r70kjy/Z3qYTm5oeLLy0zCS0S56nowfNddyp4GfD2uB7+ar89LfhScj0P/7m0ONm/tJtabqW32LllwxRmgNs+bGlW8BZeY+Mc3IO5P4z2kdvBnLvdG4dt1FJ8wnLt1vZ4oXBUhpVoSiIQgX9ns7scPzP542tMHOJxB5K1HTBQDj1fu6vBFZp0hNbWOXFLAxTzftt9fasxxYRJ2lsFeqx/ysh0IQTudsAlktfS9avUngyn5pZGWA5V9pvOzvdV541ghIr6Q9c8GBQgBMhBPUnXzEszGzODkXoBqaqCfFhuW67+L6smuPtmW+CNSehmg2A/DhPfM/B00/w8QngN/YVi1YMZdWxeABeXMxAUQ/2S7KYs0yDKNV2wgdtkaRUXU0CTS0x7lI+AikqDdpZr8qk5yDCQVe6ZHRvpHLBXks4vbDqeUBgJDC9eJYJwpo9VceccpLK702N2XY6bR3zddEfRJl3BPylNqaBaKQxfSmHmkIkmw8QRIBad8/6+dndJTVm3f3QkqvsWL0uJnrP1boxi/3FpkXhbz93Ub2DO8+VUJs1OXe3d/Ch6s1iKuCLtTdZFUFgHfdmJ0Kz4ZboSEZwmuJ/Vd6hvcSfusbf729LGPMqALbZC5pgXTWwpmRiuD7U1kBkB3jFP7vxPBs1MpMncKNe9qUQRPepzp01k7q9N4mYDk5dpDFgxFz39I+WqKQnrHHs2+1HZqBiniAgs
 hqIQfpBe
 PVN+3zXlo9N2RLovJHePKYM5FjrP+FvMxyoQsLdT4HVwzTsARZPBi/0e9NlA9BaRWRDgZlzTG9BMzK2NpRlkTmvUfWugTAVJzFVeHixpAq/ryheZaYxZZYNGHEeh7yNlc2RJdREMiFOeE7uJqIuZ22LpLMgJ3/UP4ldNguygqNea5So9HnJ/h/xh75dWuTSwJa7L7e6ykI++IZ4RqLze4hef11wLolG/c6p9E+hBH024dKDJthnky8ezmzraT/sdxY4f+4FcAFVdiMSnFB816TS+GcUO5fVTaaBalME8sOPPE0MVfK5EEiAbvfZJXA2o5yZjDO+gnby/76ZVjVn9DX41twirYbCkfWo+Xvz7WxWIxnmZbVk4lo6eGQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 03:37, Zi Yan wrote:
> On Mon Jun 29, 2026 at 9:32 PM EDT, Baolin Wang wrote:
>>
>>
>> On 6/29/26 10:56 AM, Zi Yan wrote:
>>> Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
>>> memory compaction.") stores isolated free pages in an array indexed by free
>>> page orders, it is no longer needed to store the order in each page's
>>> ->private field. And there is no code using the stored order. Stop doing
>>> that.
>>>
>>> It also prepares for an upcoming change that ensures subpage->private is
>>
>> I noticed that people tend to avoid using the term "subpage" now, though 
>> I understand what you mean by it here. :)
>>
>> [1] https://lore.kernel.org/all/20260623125723.2503832-1-dev.jain@arm.com/
> 
> Thanks. I was confused which to use subpage or tail page. Now I know
> tail page is the way to go.

Agreed, and agreed that the large comment is not required here.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

