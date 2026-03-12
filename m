Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF9CCFED2F0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 08:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1692F6B0088; Thu, 12 Mar 2026 04:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141C06B008A; Thu, 12 Mar 2026 04:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015F26B008C; Thu, 12 Mar 2026 04:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2DD06B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:55:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 844535BF93
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:55:36 +0000 (UTC)
X-FDA: 84536802672.03.C2AAA1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D543A180002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:55:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mEzPIQnv;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773305734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtiTwh9otkwNbXTac6KoCJC7ZsUiQWhZSi2C4yUd7dk=;
	b=zZIhZg3SQ7w3qppccox4EuA9+YoseIDiY2B2n2Yi1fgkqJqK0HHgJZaSn2CWx2wgYx0l/f
	97Yuqp2UGi9MZMjtUZNcnqZIH4ybjaeqpDuBohfPLYiqCzSO5+4sj8GURLo19T/2J6ust/
	hjL48GAaKL8HVSC1O1GtNrAKL/n0J6c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mEzPIQnv;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773305734; a=rsa-sha256;
	cv=none;
	b=W4UNqVl6kd/QLZ5mqyz5KGBx/J3k2wYETahXlfjFfV2Dec51uP5+xlLz22OUryX4JCsNjs
	8VlzjMOth0oqPG4IjpUoCaRjE6Yp3wlYGQWct6Im2CJLaGP8ZX8+QmBYAdUUCKOZg0ApEx
	Hs/Oa0xs70SJvG9yfj0o+36p94JpiXY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EF7960141;
	Thu, 12 Mar 2026 08:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3B5C4CEF7;
	Thu, 12 Mar 2026 08:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773305734;
	bh=HxJoocjOCYFRNNtremEq4a9gZs6/4+/JZzLejhliau8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mEzPIQnv7lpcbrKWbQSKEdwI+BmCAqv9+EhC7qg6Um/kMDsgtjDEe93CG4shWLgkg
	 gqTkxBO8owX1eCgVCyx4jJCC43iB7ou0V0GuWAGcW4rXjypPMQUMV1pHreHaoZSDKe
	 4doGDFgYMIwDauXbDCHFPPI6z2ZD4esYqqhXADOo1YNu725Iay0VVjaoKiCt1hKmJc
	 5z1re9/loSTGJ3veQ+m5147YICU/ztkucG7JjDj1XR6jieHJI39l6UJDOsCaKjCuI1
	 GdaQ43Yxx/XLOEARcmwCeIU/9xKt1ar5josIKAZi6/s6pDw42HW20TQ4j3OQbO9tXM
	 vv3OIO8m9oBhQ==
Message-ID: <e467a4ea-2e42-4b27-8179-e97139badd88@kernel.org>
Date: Thu, 12 Mar 2026 09:55:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: prevent droppable mappings from being locked
To: anthony.yznaga@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
 <ba9a99a0-2ab8-4726-8287-ab21b3da8df5@kernel.org>
 <9d90dd0b-1d60-4e45-922a-84637cab16a3@oracle.com>
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
In-Reply-To: <9d90dd0b-1d60-4e45-922a-84637cab16a3@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D543A180002
X-Rspamd-Server: rspam07
X-Stat-Signature: omkxb9sffgeoody6fox5fqhen16kkxd7
X-Rspam-User: 
X-HE-Tag: 1773305734-98621
X-HE-Meta: U2FsdGVkX19loHcXL2o8Z6pX8LDXdli7xBpQtmdIffTAG3zDGZnQJq9IdGiYDRnEl4c9OO7lYWonvvWZTHIqcFSaN+SO0gWGwh6/dOLvJMcwjU4BGVO5RRQGUuDpe6AvZ9nWWigm3oCpVZnzr+3BAJjaZPW6qW+oqQa/czqUQp+MhC/IM83QgOQ/mg85v4mdKau9WkTPGArPfRwIt1v4ueK2E6vl7uaQ9CQOLGmp6gFr+97L4SuwG3hHJBROF2QT+l991RX+w7pGfN7OUKmJZzIeDbYLCMU4jcW+TH74j2zNzfYCTMBMsszBkKJ8iq6zJ9GFRQ2R+4Od5VyuQfVWkJSH1ZiTygi9HrUuhCHIuFJHtse8uoMA865lmrIW+++QfMqrBVG/y3YwfDaUdax6Ra8FNTJ6BmiesrMJYakIHO1+Bv20xsF0faaMxUZnaX0IGKW/oV/3L5DIIFwGiJx8iWBb23JQShRh3HP8/PIV/5MfWr098O6bOlCR8Zcj6fQ3vG5YQv94pAWCskgZTC/0a4TLuHgibNHIJOB9mvfqVsUwCKdOVuUM+VJvxBwleSRDuzqET+AnddyA57920ncS/2UsKMgVa5Pt4KqNS/hbAf/qlnhxFk34yiBTbOzHOZyyDXmHf8NCCxl0sBsipquqFd2cOzfaoE67KVbozAIq6AeVjdH/H4zqenqTAupSrcAaw8GuZZr5oEaC5m9zd94rAqDS5DbwvpKIsZ+HmQ5nfuKqtQ4iYjb2NwndxTaPbQNtUy6QUKEVA8gJVtjsxw/jazcfsflNwlesNRcTSHInlAHdKv9PE5JgTvb35WCQaxqYm+Ak3Km6xAFA7WQALAnsVH+KLUAz2KY5eZ2PEy1doHsuwM8pEm8XbkapUyalr42eBCqXOslDq0yd0NRaYiI/UB5B9gmCIAF+9ODLKZy87YBu6tyGIOMqJEytJfO5JvBE7bHB3ScTjJ0L9SKdRl6
 mnVQ2w6A
 9qQoJcu8qb+i8eFMgf1oOdz2X/uQHTio+CgMaQYD7VBZ+vqIWDC9Tr9FbiM8UM+jPqVqWsxwrBa5Yia7Q84SI4tC/P9OjKGY2TjDSCIJiHgtgWaWXVL29jZqZHI2553zGELI/4mWWSs2MCIe/bq0SEHKxO5eex2FZICtxGUaR/s2bwDGwvmWLJ60lkMS9/Jyv5tATbrTxmvJ8VFjf2BHTtNC7qHOoolB9Xb67zg900gn1A5pZHGViBoZ7IkrN+Y4mZOsHaeEzqCK1IR30aZicIyjwgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 03:01, anthony.yznaga@oracle.com wrote:
> 
> On 3/11/26 2:27 AM, David Hildenbrand (Arm) wrote:
>> On 3/10/26 16:58, Anthony Yznaga wrote:
>>> Droppable mappings must not be lockable. There is a check for VMAs with
>>> VM_DROPPABLE set in mlock_fixup() along with checks for other types of
>>> unlockable VMAs which ensures this when calling mlock()/mlock2().
>>>
>>> For mlockall(MCL_FUTURE), the check for unlockable VMAs is different.
>>> In apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set,
>>> the
>>> current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
>>> applied to it. VM_LOCKONFAULT is also applied if MCL_ONFAULT is also
>>> set.
>>> When these flags are set as default in this manner they are cleared in
>>> __mmap_complete() for new mappings that do not support mlock. A check
>>> for
>>> VM_DROPPABLE in __mmap_complete() is missing resulting in droppable
>>> mappings created with VM_LOCKED set. To fix this and reduce that
>>> chance of
>>> similar bugs in the future, introduce and use vma_supports_mlock().
>>>
>>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always
>>> lazily freeable mappings")
>> Should we Cc: stable? I think we should, to fix mlockall(MCL_FUTURE)
>> behavior.
> 
> I found this issue through code inspection while doing mshare dev work.
> I don't have a strong idea how likely it is to happen in practice. If it
> did it might not be easily diagnosed so I'm fine adding the tag.

IIUC, mlockall(MCL_FUTURE) will result in future MAP_DROPPABLE mappings
to get mlocked. I assume that implies that all pages will get faulted in
and might not be reclaimable.

With a quick test program that mmaps 4M, we indeed fault in all these
pages (I assume you test does something similar).

7f5fc4600000-7f5fc4a00000 rw-p 00000000 00:00 0
Size:               4096 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Rss:                4096 kB
Pss:                4096 kB
Pss_Dirty:          4096 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:      4096 kB
Referenced:         4096 kB
Anonymous:          4096 kB
KSM:                   0 kB
LazyFree:              0 kB
AnonHugePages:      4096 kB
ShmemPmdMapped:        0 kB
FilePmdMapped:         0 kB
Shared_Hugetlb:        0 kB
Private_Hugetlb:       0 kB
Swap:                  0 kB
SwapPss:               0 kB
Locked:             4096 kB

It's a good question whether memory reclaim would still be able to free
these pages. I'd assume the folios would get mlocked and essentially
turned unevictable -- breaking the whole concept of droppable mappings.

So I think we should CC stable.

-- 
Cheers,

David

