Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 933D1C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5E56B00B1; Mon, 29 Jun 2026 08:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8868D6B00B2; Mon, 29 Jun 2026 08:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7754F6B00B5; Mon, 29 Jun 2026 08:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 421596B00B1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:30:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C302E903FE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:30:14 +0000 (UTC)
X-FDA: 84932882748.28.5905FBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E9BDB40005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:30:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLNXU5kn;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782736213;
	b=LOVbiHmObbQV3SXpeTi1rnr+FzUuVkiuC+VBMG7KaGuN6Lm+vYcJ5gIxMuNKkViARpWIek
	5A+vZmAK1XTt2J45U65GVMgzjt/nNJTEmedNpGEIYM+EAkrqIRZ5ceNfUcsH9Ur087VdaQ
	tAaq7QKZXN8g/JdKcH1KAN1dp9PSauY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782736213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0FbGvFoXBPHpc88ruFVuL9aF9fGlwmJMKH5fBSm8aE=;
	b=xRnka4CK29ZeOhWejz3MIuNJk3rHvEGAjpg/sv0CusftYfPLlQWzYhzfDr5/ZYEiAOxd7M
	CgxPXBXuR2HwbR6O7cfxbAoHdKYSJK1dWhkmZ+24d5TWfj3Qw+qU90IppFf7bpDTlFYT8x
	pAPq7oJ6Ktj8ILbdgEW0YRTSQ3J4ezQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLNXU5kn;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 797C760008;
	Mon, 29 Jun 2026 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE051F000E9;
	Mon, 29 Jun 2026 12:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782736212;
	bh=G0FbGvFoXBPHpc88ruFVuL9aF9fGlwmJMKH5fBSm8aE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kLNXU5knlHa3KmPye65lbh7Fo2+k3BFQRh76KUtsvTNCDRW1TugDSfOp598AyqSVf
	 fQhV+bgMJdGNNbrlOy9NWbiClQdKu9qLLobOz0c2uZixhN9z5fYjCMZ1zfnv+lqPDm
	 MPlNzKBTu6zceRDAFlc8KX1eg85HeXSoEDDk4nPr43jzIIuQgVn3qMf8+k6yqtCvBF
	 rcks7qAJS9l4HXfUNu8okAJsU6UxRxP1B4uJQSD9P9WBtiD4zYKCHWq3IQylxKclrZ
	 liXeuT5DYGZh3izx0OqIfZtiaannaqVNwIWiFlN38Bf2GD4k/Ic4uNgiR7fslAkBDy
	 2MxKm25Wvg8ZQ==
Message-ID: <b96f27d5-95a5-477d-9529-bf932905ddc5@kernel.org>
Date: Mon, 29 Jun 2026 14:30:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/12] mm/rmap: refactor some code around lazyfree
 folio unmapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-4-dev.jain@arm.com>
 <dcfcc52e-7e1c-4940-944a-faf0c02672e0@kernel.org>
 <dbe63454-6ee8-49f9-b956-f5a211785aec@arm.com>
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
In-Reply-To: <dbe63454-6ee8-49f9-b956-f5a211785aec@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E9BDB40005
X-Stat-Signature: 3uxpf9rh1opsyqqwwpnzor9wdxo59zpq
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782736212-807032
X-HE-Meta: U2FsdGVkX19XUSzezFf3LsBD7ooP+pNhj/LbmcohpZvb6OwULEH4kSc3RtAE0wGrwZvLr+Vlfy9+PVyPHZu/LkHAzRLSE8bVVyV9wRjg6Jcedst8GvAwJaRwPTnKNQF0YiAvNq4LhQSsCM6UjpzIbFVrhAuR3jGPzo836AaEbxKOWEwtsg9RmoEY/BHr+SbXEKlVA24pYkgNWmfI6C6gBjskm2WB2ZoDotTKUJmp3+Y/glv4KxJrvVgjVIweL9xpA2BdSiN9TcFV1uhqrCkOH2nkRdVmGmMe6aU4AMTFzgmEztafkom40ZHRHCGb0AAd85UoIoCtn3h48Ey9eey6RsZaqxHmtvWXDLArmbAWg9TSkgrmf+TLZoRRbia6WCXELAOHzjy4Bzfnaf2PlnvC2/MO8e0f6vsPwRLf3qnTY1Z1OU12tb2hKRRFetqGFWBcwOaxdmKKThVEWwrccH2PGLjisIQqIpyYhrPasTQWJo3r2NTBFPUxcmtfnwduVuvzaF39MHCZkLi+D+ukHPSAfovFhgikMVytGis8sloUJI6t4rFmbFetQknigk2JlfCwkGfeJPoviUQqxg7VQbdmI1RX2Qy5X1v7eLiL6u7+z9GMlpRyjT8vFzdiYTDUQtcwpIG6vlDSHuf8fQqvGa6l1emHOLMaQi9yU8TUVb7irBZoyQGW3lz9Y9LOFyzAsd6SsUc9EBCv1nj59dFlpN25HL42cY0G4J7Rqgz89NRVZIU/x7URgcCY1wVlVqmwh+rZvszjsp7+L4lof1LS/y2tHlEu1ZEAiWa4Arz7Snt9RiOxKSav/n7XSJuDT7BHhZDYGXbVZ/C5Qwnc7dBs1Lkzw6IWV/CyLOXn8/rxEFdzGtdsXTnKKURcdiFAv/NhacEqTRPgU8T7SyvvvSXLopHy/t+isbNHY+tQK1PQGAIFAGKJbD715qQ30PMDtpUTUEJTpoakRShU/jzyxWIhceC
 j85fqAk8
 Ix5JCPpC3JPnRfTBKGHW6fJlM4wVNeQyW0thq2wPgGKRxIJjASl2bpRzkybvH0Y+871goyrtxP88gdco7fSZCWVFUJZtpXtQQv4M5ymQDy78x3LsqvE57m8umo6J/eoe43KVJ6dPwVm9F1om3tx0QYahwyO4mYMISKL6cRIH4QjM60RyA4OH/tztaTx9eyRh4WZ2SGFjyfuPxSjSCDNMvR/eT9McUzp9PR+Z0VqTVKSyGHjYgMQJ9xC6B/1ByIvM3hdhml4Dg6tra9WhB9LWnYwSeTqZdXxxaju1hFaOsLjiHRWso9wcBWX0NIQ69puXCioQd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 10:42, Dev Jain wrote:
> 
> 
> On 09/06/26 7:50 pm, David Hildenbrand (Arm) wrote:
>> On 5/26/26 08:36, Dev Jain wrote:
>>> For lazyfree folio unmapping, after clearing the ptes we must abort the
>>> operation if the folio got dirtied or it has unexpected references.
>>>
>>> Refactor this logic into a function which will return whether we need
>>> to abort or not.
>>>
>>> If we abort, we restore the ptes and bail out of try_to_unmap_one.
>>> Otherwise adjust the rss stats of the mm and jump to a label.
>>>
>>> Also rename that label from "discard" to "finish_unmap"; the former
>>> is appropriate in the lazyfree context, but the code following the label
>>> is executed for other successful unmap code paths too, so 'discard' does
>>> not sound correct for them.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>  mm/rmap.c | 88 +++++++++++++++++++++++++++++++------------------------
>>>  1 file changed, 50 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 06ab1158d4cd1..12bbee57f20da 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2093,6 +2093,52 @@ static bool try_to_unmap_hugetlb_one(struct folio *folio,
>>>  	return ret;
>>>  }
>>>  
>>> +static inline bool ttu_lazyfree_folio(struct vm_area_struct *vma,
>>> +		struct folio *folio)
>>
>> Nitty, but I wonder whether we want to return an int with 0 vs. -EBUSY instead.
>>
>> Reading "!ttu_lazyfree_folio" naturally makes me assume that this would be a
>> success path (which it is not).
> 
> You have a point but if you don't have a strong opinion I'll prefer to keep as is.
> -EBUSY won't be consumed by the callers anyways : )

Yeah, works for me, the "try_to" part implies what a bool return code means.

-- 
Cheers,

David

