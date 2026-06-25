Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBC4CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381476B00FB; Thu, 25 Jun 2026 03:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3588E6B00FC; Thu, 25 Jun 2026 03:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2495E6B00FD; Thu, 25 Jun 2026 03:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE4C36B00FB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:50:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67D151C32DE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:50:06 +0000 (UTC)
X-FDA: 84917661612.12.D195291
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A2939100003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:50:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SG1WT17A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782373804;
	b=5+w1xFoUPu0+8O11JiRmi0DRcNuwyJRCes6SiA8sZo/bS/ss3FLDtge27AMXUG1fDrg0gC
	sypkRk4K2rsA12RdKzEZ3+6VAnwpRdnr3cpJ/QL3dYLs4vh75inEBGudscNmYiMJTqPZK5
	TpftbuWpxNcQpahs4bVHoz+xYi5cS6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mjvDm6wc662Q3j5xc6LNyuyos/WPV/sprSHNbnLMDY=;
	b=IGze4BwHE2Ngf4I+1cx7wDhVGYFnYIkAMNLMbIaFs1fxl++J2bscBMBHKRIhggrnc0ZZc1
	Y8ldmrUzNmAWyxbgHoKwStbTNnV6VAXpEXGLkimrR0xO5tCM9afDwWEF7uKgSo8XGiyna/
	Wcw6WBCriC0fPWtZsoY61ZjCm7uwyRw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SG1WT17A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E50460217;
	Thu, 25 Jun 2026 07:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780981F000E9;
	Thu, 25 Jun 2026 07:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373803;
	bh=3mjvDm6wc662Q3j5xc6LNyuyos/WPV/sprSHNbnLMDY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SG1WT17AXH8H0rBfsv8gpBfHL8MfVexRe92YQELgaeGghMfk6UU7i/qi+DOwjV4Uj
	 93Ojq9qtIuVps3MoODxWL5pKNGNlY9SxjJ6pSoIhGv1Si1QXBDjfnqSyH4EOmHjslN
	 EIYlUrMFZk3X8KcmcyXR6fqSKRl+jEOZmi5Ksg7Kp2kzLdjIHFc/zY7AeWGhAq2s87
	 Jrzkm+2iIAoLDgCTCp0Xddc2HXewVRKofU2fNQcpZjQm/yOfxcE76fejz+885oPU6H
	 amN8pNhDuScXBv3XqRf0Bizynr/SqIjrHF0ym1fdEKbQIPIq/St65i656qyfXcHZe9
	 PS8wbC71cNomQ==
Message-ID: <c29f90c6-2075-43e8-8f0d-0d6718a0f124@kernel.org>
Date: Thu, 25 Jun 2026 09:49:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, kasong@tencent.com,
 lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, npache@redhat.com, qi.zheng@linux.dev,
 ryan.roberts@arm.com, shakeel.butt@linux.dev, weixugc@google.com,
 yuanchu@google.com, zhaonanzhe@xiaomi.com, ziy@nvidia.com,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org>
 <4aa8350e-712f-4380-b3bf-2ff06cf2a35d@kernel.org>
 <CAGsJ_4xR0Ge707s8JAfd5Fw10+U+25_nuBGuVayx9qnxR+NnGQ@mail.gmail.com>
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
In-Reply-To: <CAGsJ_4xR0Ge707s8JAfd5Fw10+U+25_nuBGuVayx9qnxR+NnGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2939100003
X-Stat-Signature: yugaxrz6wjhyjx95tq8yqo8dpiiucdh4
X-HE-Tag: 1782373804-114978
X-HE-Meta: U2FsdGVkX18LVAd1wfkzAwJfSKH7kd5VpelOZ45xbdl7WNixZzro6v8wZ9pVyohOqRU/YYLKycYnnlD8Oh4YD5G3WGzNW8yYW/wRUSncYrznah1S/ypUeAG23JsqonFTH6s83c9twx0nrXRYJtmG5/swGAUqgvtAuusTeqJD9ojS9eP6abcFERL16gaJHYJlEqUNIjmPlQLALt6gTGF3KcyzI/Ix7qbwO24PtamvEEciAZAvpzu3lrnUqczHkYbX+npL2bQjrT+x06saWUQw2oIjYxP5HXDeDkfkbyA0GlwPzIOKv9IysohU9JjBNjSOyv4M5j5LXlNylvBhr3L/2d4UNVt3+IkOYHp7uw+PUhDk7Qx6pCpqt0zJ3WL7GBs05eBv9rfQzQcQDAid844fd7hgg9l9aXppYXYwJsXx3ToB9Olf20ry5abqiuLrfFrLpgKz+SoSHgBBxS/lHGAMdg+tgsB6gVHeT2M56KN5GRvttVNctIfsdBhxmecRO7SRILERCOA3TW6f/heSV5ws3pjLGG4V6T/jdWAMxm4cNCja4AMu8lwjFHDCYm2FSBpCxsn2/1bPmqsQh7ztccCziZDcszcT2si6nI2UcrnxVngRJ0N3y1EzvxXdXMAWpqWybX8Y7u5//gMW9ZUrYiTYsihF0HuLPySkerppTNubI//taw0Kcvfn6ZmDLFQn+HPBrCgM05n8RRQCMDrWgpcMrK627TYm7nSbFnijDR+Wt/SsVRGkHAGlzAjDmOrP+ogMxY4b/6DH2DIytct5CpHG/SqZ82uquCt5UaERIGGYLpa/SBeSP8qA6GrvxKrZedz0UyguUDWVm9X8W6Y4WjPRn+i4TUjUbBVf/TiAzFrjLJuTxjgURqpgHO6zFcNpBAQDrP1o8es2/sLebFraHei6sEvoSlMsoWYtirKbSxiFW4VxBzZVNXB8cAOZCNZq/k/poiAOr+nvEHKVlAI+vy2
 m/lPXKe2
 1zoOzkrDtjYh2LbaJzf6FRv7Sx9qP4Fh5fdFmvLvsm0UeH9OXHpB50uKBcPDf8001FRPiBFl4tGIPF1YaZU5ey80ITqdh856+r2FrjUEOJGSqGpPoagwP4f4hgYfX9bezrBQrwe2+XD7zq3mHJL16si5UmwRo+DlgIgLxPa7o5Lm5OzwFpNgG/QB7qDQse7U61xkxf6nUlO+kdwF9eDwVDZCPk0qZaUUS0ZAsMBZ8FELOg1ek2sfUduE8x8yGVCo+mDmX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> But now I wonder whether we would also want to check "is there any free swap
>> space", not just "is there any swap".
> 
> I don't quite understand you. get_nr_swap_pages() returns
> nr_swap_pages, which increases or decreases as swap is allocated or
> freed. I guess it just reflects how many swaps we currently have
> available?

Indeed, I was confused by the function name it's "free swap pages". So all goof :)

> 
>>
>>
>> Essentially, try returning -E2BIG if there is the chance to swap out after
>> split, and  -ENOSPC / -ENOMEM if a split wouldn't help.
>>
>>>       }
>>>
>>>  again:
>>> @@ -1769,11 +1772,13 @@ int folio_alloc_swap(struct folio *folio)
>>>       }
>>>
>>>       /* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
>>> -     if (unlikely(mem_cgroup_try_charge_swap(folio)))
>>> +     if (unlikely(mem_cgroup_try_charge_swap(folio))) {
>>>               swap_cache_del_folio(folio);
>>> +             return -ENOMEM;
>>
>> Here we wouldn't have the information whether we could charge after a split.
>>
>> So that would require a rework to signal this more cleanly to the caller.
> 
> Yep. The tricky part is that mem_cgroup_try_charge_swap() cannot
> return how much swap quota is available in the memcg. Do you prefer to
> add an output argument to mem_cgroup_try_charge_swap() to expose
> that
That would probably be cleanest, if that is easily possible. We would want to
get memcg maintainer feedback on that.

@memcg folks: we'd like to know whether splitting a large folio would make
mem_cgroup_try_charge_swap() succeed on a split (smaller) part, to distinguish
"there is no way we can swap out anything, don't split" vs. "we could swap out,
split".

What's the best way to obtain that information?

-- 
Cheers,

David

