Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF5ECD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218986B0093; Thu, 18 Jun 2026 08:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFB16B0095; Thu, 18 Jun 2026 08:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108046B0096; Thu, 18 Jun 2026 08:36:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D044B6B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:36:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49B7240764
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:36:39 +0000 (UTC)
X-FDA: 84892982118.11.2B5BB3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6AF5240005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:36:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KzUnWw2j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781786197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdWgWriMzVNJt/W/nkcNsEreC6xCA0ElpI0RGsAGQxY=;
	b=hHMyHeh4HMUUpSzHJPkwcdq2heVIoNcOCsBiFRfA8JY8dO6+Nm3uLoVY1UblTTeX81XJfG
	E/37j4AMbKRaSHvzigeMDWKFaQR1YpZe+8mdOifGrAGS0g2VyAmVWpazGCPtrKqAVzoiE1
	ZGFzHtwyobXsnUNOzl/9P92pb/tR6pg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KzUnWw2j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781786197;
	b=CRyjEi29c6/vMbZwaN4J7bFJTZ8+nstnHVuZcqugAnnqc7XUBb3zx3tDShkwcUrTp5ugQU
	EaYIGebYJuCcml97gXdYj7udoAWN6gZV3EU1VayZRBnHaJLxBkalMshBuPcr8hx8gxeGFx
	6Wt9UB44gW+0mNiBUuli3fAp8dNzvZY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5306541934;
	Thu, 18 Jun 2026 12:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B991F000E9;
	Thu, 18 Jun 2026 12:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781786196;
	bh=PdWgWriMzVNJt/W/nkcNsEreC6xCA0ElpI0RGsAGQxY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KzUnWw2j5Vyr/D9W95J6/+7kPMLi0jCCd8jZOrHYYdcqEyTc5+01mJ171Gl3qHLIn
	 wHrb2H78BM5ktFgpzmyNv444zlwHurCF4C4PSZjmshxgjn0Quch4IHt21WDRDq8hvn
	 QRk8IxpsaI9yg7GarR+xecr2eBPz/pzb52W1YO1rviuwZoZe+s85YlwREqkiDb3a6+
	 wfEKOg60GwAtE5FvG1PZf1eBjYpZZKvWxVpR6+grv71pEe6P8Zq9HACMmJIRuohXCm
	 5ew0TZXYtWqLKs4BnCKa2An3/UDJKcNUu+RCTOE8onxW3G5PIfRwDD68r0xU9DnpiL
	 RLQ9Te8RgsDfQ==
Message-ID: <0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org>
Date: Thu, 18 Jun 2026 14:36:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero
 folio read-only
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: dave.hansen@intel.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, hpa@zytor.com, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, yang@os.amperecomputing.com,
 jannh@google.com
References: <acca377c-a308-480c-9840-4edf1a94a3a0@kernel.org>
 <20260618114822.165413-1-xueyuan.chen21@gmail.com>
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
In-Reply-To: <20260618114822.165413-1-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 1fhsajqbarq55m5dpi5bcbshors5upek
X-Rspamd-Queue-Id: 6AF5240005
X-HE-Tag: 1781786197-66704
X-HE-Meta: U2FsdGVkX1/HYzOtr+FvMOU9+FMB/mpugnIdKb+M3qtnZe5XHtPYUDRZPcPaGqqZsf4DL0azMba98e2pKJmbuJmVK9CqQEEgFGa1xvh9iapAeLTfmhtDsKvcuyW/iy24b/Q225gIj3PO7PcBFxkMwoO7jLAy4Y0WVs+SJEd3uAr602/t2gRAQfcZJ30CqdJvphg3yHEewLMZCNi4fMDvckmHN79vaOU3UAMUavjFZaYD7rlkoz/m+oTAtZGDT+NPoIHf8FjQYkxoEgCeFxC+2nqtskuU/X4tHfwlvsuxOWB1y67q8E9d3qln4PygWAYMxhrlcZfctt3TvD27y5dL3huAAdpCDC8IF2uPRf5qZhWy947o6Adm3vK2RgB0NeNVox0p9Oijav7GZt0s0CpBbcHOwOR3xMyOOERbjAH5BT0A5EB4DDoC6sHDqhP9C90T/RyM/9FP9yCt3/igBIoqblMtbKBebMuQVMDUqJDbNvcKnFCq4B3CWzveqtD/R9SHSK4PyLuInZ6ybyxihQtyTxCwtyzLwx52kGtx6IIn3JrwI0qYanYL6H6Wvy8XYGRivEayWY0xMQkfA48MIOyus85FHVFbQ7vGYtcIBhXN6yJPmFtdqrN5n8fj5cc/udYa5W8W8aIUSf95mlaCN4ho43yoffaPFqxWfKfhuoVj20HEKUVoRxLVPXMFwhgURDxBKZU4vWxTKuIUYhGFosrBVn8dbqYkj5gMA6/aiqc2apr0r3ve3IzqpAoW5in9Rj8LBMpxDiJgipIx9YsvotprKvTgE+Fe7jR4YiCcRCnL387EZEDru82L1CbkfH22cG3ZqMOIgkUpE/GkaqG3YIzHjNtxA5Qr59NN4oopM7Vp+qNFq1qxjGr8LdOrUayqI+e4KRHQDZT5T66Q3GAaGd6K0c2gkkEKqEeG9ObAC613RH7N/RKdDBRchNvfdCrvJYVB1WTb8cgPfyGaPaxmF6G
 T98E5WQg
 XgFbG/RiMdSbexgM3u+Q80MyDJ9oY4S99qp26AhXurSbJIc2MCuqsN+TFXQp93Msm3rsTzx3oivmBFt8zZUa7hEVRcJFp0zh56583lDcP7HqSmJ+bMSHO8i9Go4iETmnhEO3ONelSHdBJgVIQvFhM8u0goxjNXO75QEdqF5QzQY7kr/nziiBgE0hyDL8Svb7xSKNg6c509XHgU7ITdHIMoSu6gW9rv9eIzHy7vgTjzS8uBnUUvUHlQhfMw7BRoIHV/xlfWennLENSq+8fGDSm2JYxPetjnX+iF/Q8snvWY3gL0lW9b1CuDWFRDsZGU3l6PbKNi8pJVo131Q7gfXJ1XWB5CRGxsLPR3eupFGgqso/nviygxsQp/IKQfDfzYuIv02YkaHENkSNXUI8mRJncDRXrekEbKQQp/276tL/m6UBSzRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 13:48, Xueyuan Chen wrote:
> 
> On Thu, Jun 18, 2026 at 11:06:41AM +0200, David Hildenbrand (Arm) wrote:
> 
> Hi, David
> 
> [...]
> 
>>>
>>> How about naming it int set_direct_map_ro(struct page *page, unsigned nr)?
>>
>> To distinguish it from "set_memory*" cruft, maybe best to use "remap" or
>> "adjust" instead.
>>
> 
> OK, how about `remap_direct_map_ro`? If no objections, I will add this 
> API to `set_memory.h` in the next version.

Best to wait for some feedback.

I do wonder whether we want to pass an address instead of a page.

https://lore.kernel.org/r/20260410151746.61150-2-kalyazin@amazon.com

Wants to convert existing ones as well.

That would imply that the caller must check for highmem.

But then, we could just use existing set_memory_ro(), right?

-- 
Cheers,

David

