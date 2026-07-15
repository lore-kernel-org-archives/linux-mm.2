Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4801C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FBF6B00EA; Wed, 15 Jul 2026 09:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46D76B00EB; Wed, 15 Jul 2026 09:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D526B00EC; Wed, 15 Jul 2026 09:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0176B00EA
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:49:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91026120194
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:49:44 +0000 (UTC)
X-FDA: 84991143888.28.750DE98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CFA92A000D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:49:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UdKtIFvb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784123382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRKF5saQFKGslnQkGiAHV5FSLzc2XKltwHSjBxCLx7A=;
	b=uwqvGFLydclBm6Y7VEGRqAZlfkiAt5APfQHJ8cPiSV9G3ntQQGNkbsrvdpKB128YWym24C
	/Ci2B+pAC/NtsYi7VJ40A5/0/7iMf8RquNQuJDfJETyjrCclJuOoOsMdPjgqDrAtDJNp0N
	/FItUev5ab6LzwWDzAhMZ2e7qMQ3FkI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UdKtIFvb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784123382;
	b=fQvmYzujvJJboGu7R6HZzu3KYuPagRnhL/+X6eFrzmhCQCnfVRTwAcb8+lzFctcI3CC2aQ
	kssV6o9gcUJXk8+GPgDU50tTFvj2pQ2tplx4APe2ij50e7rFadLy0bAtv7a4hoHACKj/2J
	lHvfkmT+lqUeanzFlQoSuG2jjTrnf5s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AEEA600BB;
	Wed, 15 Jul 2026 13:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3626B1F000E9;
	Wed, 15 Jul 2026 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784123381;
	bh=NRKF5saQFKGslnQkGiAHV5FSLzc2XKltwHSjBxCLx7A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UdKtIFvblXdZVXisvFZKUzkMS4xvBGIACCQz4R8NmuNnwLFJX5IFN9oSrGDzzqKlG
	 RECKS/vUl7S1duvGtx3xGb2mmYq2GuDeomNo3aiJI0qyWTbTUGilOnKip701ruxE2/
	 PdF+wcwP15LG8oSJ2F8eBbpKr67iwiER0nVaWAVAOTWeU62f0jU0xLkc+N9N0YzCsB
	 1vyVo/jFLvy4j3VqpzZnPSBoOtXPTDaaVWVUcITUp1esq/OwvOD0aeURvOVGfsc9Zz
	 gKplP45RS2CRYXjiDqrWag6SQuhhKqUMIMI3cZ3609YvKKk3jpqZe6AKxudsACkxgP
	 NYZRDRawfiwLQ==
Message-ID: <21e7746b-9bc2-4643-b0ca-c59e0c77f810@kernel.org>
Date: Wed, 15 Jul 2026 15:49:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
To: Mike Rapoport <rppt@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
 <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
 <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev> <akpBWmnujSnj1ZEE@kernel.org>
 <503aee9e-97fc-4889-a379-3c0a5d140554@kernel.org>
 <DJZ3TQV3GPDO.6AN321FGTTX@linux.dev> <aldv8U-lzCn0SCBL@kernel.org>
 <7e7f20de-c43d-40f7-82d3-8d05ceb3656b@kernel.org>
 <aleOvBtB3WCSsqEd@kernel.org>
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
In-Reply-To: <aleOvBtB3WCSsqEd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CFA92A000D
X-Stat-Signature: 8wqk6n4pxqm7xzz7yzcy9zxmwwd8gyej
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784123382-272098
X-HE-Meta: U2FsdGVkX18spq4LNYJswZlMH4EfDAZbzl4CW49khS75UE4gwzhBy4VRgnHVXaGze/u9NO5FCmCRkAw5H/WC1J948I3g52YDwn1FcgcATrL/ze0Q126uVZ3vU1EYrgPel+5BxK84zPTH8sJlwid6F8uZciIjQeziyXh9ueTt3mSFavI60bPpxBJZYPveS5LduipEmJfHxZ8fzD/IRLHXYqZtf68EVq2HwQp5giy75vselSmiD0ErbO3BCgvgZail6q/Tdd8tvl1kfBiPAHW5j/crnd1aKw7I1JxAEWI9KxHvuU2XZi3BCCreWYqN/WBwssQOlshdJ5lFxihZZxUpZIISljTHxSbcHBIulJ867Vu2CBAyKrzus8lQU15tRKixUj2iNqhHUWa95W6C994NKCX2AiEwh4bXQzzcybHt4md2xQoDQRvJFrWqJHQdHOtxdf3K9Sj1dcaOnd8e8CCFJmAQwtF7N+qx9xZYdcgrFvkJ3xSMwRQild6Nrphw+bELB5tCYL8G53eUyWfWlQMLyHgdGV2J1mLz1/JA1Dgs9x6Pdobqkk7I3dy32PG1pGkk2USES/eHDMKU4NhcgCP45XRYU1weWTRaYJvhl0LiPIbEH0ep99M47foMlQXoDj40TZVsOOPyFXpJ/KdcHwfmYOqEYou0Pq4CoPURfZHYHuRSIWs6OaKFDXPT5XWBXpybSsxV4uepin/niPJfbvJmq+8iUAWW3X61AfQkZXeHRuO6EqWRW+zS+NBG8ywK+lYpIZ1eYFTIuqJyyN/4AgU/tf0k65sJJ8rsQl4iwiuFALB3uGDUJO12bIyCYkmJ6V2I/+i62r9MWKXErBLuFPMr2Ry6uDQuXYc8HVfYvoxmHHM74Ou9YIfpmmg/impA6hiK3Hw/0cC6n3M29z7IfKLUJ3YtJsp8LCxqz6j6MBmfc8hEy+EDSxE2eV6wERRsOV1tJ/yWdbLq3MMycc3FGzX
 sp4svblB
 /6pymAH5fFIxNI8q8Bm6/GwPqYDrByZrElkjRH3eG3uOslmlgOV40Ev328k7tMTaeuwHHyVB1BTm8PxM5EMQk94SdV1VmLiQBUw7HPhY4FbHUhw88UW87nTfWk4QizyBgkUxPK7TW3Pvk2beacg4OBufumgxtfT2PoZ5gfLHqaXZf6pJM12GERVItfMZl6PMaBwksmq75eQWULao80A0hFSoYOSxdExNrlPlwC5etisdQoZK/AQtrHueA/xDf5FVDkyes
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 15:44, Mike Rapoport wrote:
> On Wed, Jul 15, 2026 at 02:31:08PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/15/26 13:33, Mike Rapoport wrote:
>>>
>>> Right :)
>>> Supporting 32-bit without HIGHMEM is easy, so I don't think we should limit
>>> it to 64BIT at this point.
>>
>> You mean
>>
>> diff --git a/mm/secretmem.c b/mm/secretmem.c
>> index 4877c262cb1f6..d29865075b6ea 100644
>> --- a/mm/secretmem.c
>> +++ b/mm/secretmem.c
>> @@ -202,7 +202,7 @@ static struct file *secretmem_file_create(unsigned long flags)
>>         if (IS_ERR(file))
>>                 goto err_free_inode;
>>
>> -       mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>> +       mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
>>         mapping_set_unevictable(inode->i_mapping);
>>
>>         inode->i_op = &secretmem_iops;
>>
>>
>> then?
> 
> No, I mean what Brendan's patch did:
> 
>  config SECRETMEM
>         default y
>         bool "Enable memfd_secret() system call" if EXPERT
> -       depends on ARCH_HAS_SET_DIRECT_MAP
> +       depends on ARCH_HAS_SET_DIRECT_MAP && !HIGHMEM
> 
> We can change gfp_mask as well for the sake of pedancy

Why not change the gfp mask only then?

-- 
Cheers,

David

