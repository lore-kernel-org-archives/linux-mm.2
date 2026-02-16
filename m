Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26EF2E63F15
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 17:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FEAF6B0088; Mon, 16 Feb 2026 12:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD5C6B0089; Mon, 16 Feb 2026 12:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481436B008A; Mon, 16 Feb 2026 12:17:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32FDF6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:17:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2CE41A0E7B
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:17:07 +0000 (UTC)
X-FDA: 84450975294.19.B801ED8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0EDE818000A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:17:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SH9QOzkB;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771262226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYQ8jh/zAOmbD0lLNTvd1spEJsAkP9fB5g1zESW9vmE=;
	b=KVtAXL6rs9e0pWlt0rTooQUs9cM8eJLK5If9X7k/IIIbW7dMTZ7X/90KXXUDZ44671dW9e
	6yTbaKJA5Fq+rQbk4DuiGfyvf/nCn+VvLg3LLK6t876K1rO6Pghq7JRRXxbR5ens2zTAt4
	82s4qNUli3ypTEG/XyIfwDD18O29Ht4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SH9QOzkB;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771262226; a=rsa-sha256;
	cv=none;
	b=lIxKCRBZ/snnOBSVaVvrlT/ZnI6Qh4Krjs+hCzfcOVDPwT1uKXLCDADACNYvJf8WC8U6BX
	9qVoUUX1lNUCsqOc0YinmWAdr+w3beXKmv5wOITA5Lw8LmCMpDyJ0iTw7RHDVLq9692u0k
	BY28oNHeSMX0Eog0oVbSkXfqlyi648A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 062EE441F2;
	Mon, 16 Feb 2026 17:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF313C116C6;
	Mon, 16 Feb 2026 17:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771262224;
	bh=r6yPf/QJySC05WCWq8z122f3ngJ/L4oBRGuAAEsEPxE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SH9QOzkBXRn0pbjk5UdbauM/NCAjrQjvNFLMjfL1VaafdItLKhHun6OAxOtYZy0cT
	 J7N0gxq299q8fG2p7N+ljKOECbcnzSRzjjNRhfTVId+p7oz7xBM/bqplT6v4ud+Kr1
	 JhXOUgmfvjLXuaFcsKyWX9FafdanO0u6+WihTSrMPtnm+8BVWS+ZUiaS6H+wTKAxnB
	 kzLokF8pYMHoybJjEPEFAmRy4r9ide77gKciwz8m2l4oQOE50eMBMp1O7aZSf1EH8Q
	 YU9gqyVSxJ8FrSD6zfGNyYn4EwE+UPurCAu7F7ml2JKUPKvDr0xGC8aFEdI8qE1mvf
	 AxqgyRlLRlxGQ==
Message-ID: <05031b51-9c77-4bfb-ba03-68d1cf7c31b3@kernel.org>
Date: Mon, 16 Feb 2026 18:17:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
To: Michal Hocko <mhocko@suse.com>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
 Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation>
 <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
 <aZMEvl7WUKyxmgIh@thinkstation>
 <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
 <aZNI9mo34vs27DXz@tiehlicka>
 <b20695bb-227a-4e00-a36d-9fc389aa1ab6@kernel.org>
 <aZNPhm954AqQQ3Q3@tiehlicka>
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
In-Reply-To: <aZNPhm954AqQQ3Q3@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yb17syf631rumwk6zpe6eb4xdxkw4p3t
X-Rspamd-Queue-Id: 0EDE818000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771262225-742643
X-HE-Meta: U2FsdGVkX18smLBbwyqHMRs+/xwDuf/9ZbrpynT0PlqWRVOiisiAG6sVxWDRAGEpkJjXzu53ZsBXH3m68b8wBjhwPsd1TM1i+2Q5nYTTHxuO/2vhXFZdmzhnsrhAHhu+K2CFNINvypNi8uK94uk0MOfih1zEX697P9iGf/xt1F8g6703Xaps+/fy6dByS+QlFxWqlc9lQEzGpZ7F41XHMbghMHMvfCCYpWm/o8RxO6lMbq7i+5qZLU8/XCDfVXEz6n2gmY9PnDCR3m+pY8xTzQMj9fMPLZQTtQCRC1DciwQZ3EenV1A4g3064imi/DB0jH/CIjGm2+J/Zl/HibzzpUfuveiyU9qRLlwV+7tvzWRmFflgLDT9WAlFyJKI3xovgPKEivan6W7baPW2VEWd0hmQfDhvOOnQPYXwJeuPB2ltNS1e0HHwUl1tv+IMA8SybgeHeNytryneDNgm/B5hXWA66KT2kcR8WJ6I9OBpjR/Lb0q+sfC3JYRrNaBGr0zgDgegFSZCtsJ+YPMGQUvjgJQcvKGo6PPzvV5iDg/73V0ruiS/Y8gEOp3A4ijVd6ATBHwaANVddKJkASjEus2nYksfd4sb+q16zE4+wX3hLVtGXdgd4bxTSmExzGrJ0+KwyEn8jjF2l9uNMK2KsNSIBrMdKpD/e+lAlIUV7vLyq7/pfsc4PZmqAfAs/N2EuFBJRHxsa37MJdEhwSvLHEwGRw3/hnydqBiltKOUWyvTNVKhG1hDJKnzMUFxjDZA3S2a9o6Jv0hChjH6IdXxnXyQVh6Ky0I3tjZipP6ZYtSvpm0nvygWi3vjXVFqS++ffDJRUQ69DDbskjyyEFb7+I8OorEz6K0k8EFBo77LRUlGfDdTKWGyGcnjeLf+2r5fRm4y1PhYBHD/5RK687xRAoxdYZI2ud5fHhBI36DCQrZreEWKNL5EneYTxECBIbtS4m/unUf8ZmW80TVNWeS1nCK
 kls18AH3
 SDE5S8l4JNqiAt/o5h1OQPO9/0mTbcbcl0nukFTNTefOcHe3pUmhEOtWG7lShB4JpsWB1oug5XkUQa1xxwq9XtoPfF/Urldy/Zh1lLsOs8VXDviDyuEkgypGD/VMVXmPWuv02udvPI2ROSsdUl3VSfIRmE7eMqb2JpFNQewyb5bEmEibGzqyHoL+RysZm+nzHZ99k6zeOmktSYJs4Ceg9MHs+4mxAKAc6wTx/6iPXB1XPNSd224kJ8PrCRALC/sn4CM2J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/16/26 18:10, Michal Hocko wrote:
> On Mon 16-02-26 17:56:12, David Hildenbrand wrote:
>> On 2/16/26 17:42, Michal Hocko wrote:
>>>
>>> You are comparing content of all anon pages, aren't you? Depending on
>>> the content this can add a lot of overhead.
>>>
>>>
>>> MADV_GET_ZEROPAGE would make more sense to me. But a more fundamental
>>> question is whether this metric is really what you want long term.
>>> Kernel can do all sorts of optimizations behind userspace back - e.g.
>>> map shared zero page - so just learning that a process has a lot of
>>> pages filled up with zeroes doesn't tell you all that much. Or does it?
>>
>> If a sysadmin wants to see where THP hurt (zero-filled pages), surely
>> MADV_GET_ZEROPAGE is the wrong (ugly) interface.
> 
> The question is whether sysadmin should really ask questions like that.
> Without a deeper understanding of the workload the answer could be
> misleading at best, no matter what interface is available.

Given the requests for per-process control of THPs I assume some 
sysadmins (at hyperscalers :) ) really care about the relevant processes 
and even the relevant memory areas (e.g., jmalloc area).

> 
> If you know and understand the workload you already know that THP is not
> a good fit and you do not need to ask about that. If you want to
> understand whether your particular workload has a big internal
> fragmentation due to THPs then MADV_GET_ZEROPAGE sounds like a
> reasonable fit to me.

You could also just scan the pages yourself for 0-content, or what's the 
benefit of letting the kernel do that?

> 
>  From a sysadmin POV you care about the overall memory consuption, right?

I'm not so sure about that.

-- 
Cheers,

David

