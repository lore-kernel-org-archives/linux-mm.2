Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A799C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 18:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C00B6B008C; Thu, 17 Sep 2026 14:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2894E6B0092; Thu, 17 Sep 2026 14:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160456B0093; Thu, 17 Sep 2026 14:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3EF06B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:28:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E41971A0433
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:28:21 +0000 (UTC)
X-FDA: 85224089202.05.432413B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0B57FC000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:28:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hx4f6/Jv";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789669700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5zVLhEkKOWEwakOfls77zzn3VcbclTffxYn4L85i8c=;
	b=J1myLX1+mzIuv6fdttmMNWokugRLF8qyd8HJj4gd+Zy3/qtdnrc+qfANOWjCG21Illnwe4
	w+zYCRwqfXElI7F5W00kHFi7quht/z5AOQ2shcrmOPbZdmeWVo6o9ECfVhnssc8mobV5fc
	MgdCAG8pZeY0uvCrr7HgDfA9iquBIKE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hx4f6/Jv";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789669700;
	b=rwAtCDNDJ1K0fIyDtREdezxH+pR+7zz2TNpFRthbmBC/hyd5UpGuDSC34T29Uedimes6pK
	3AqFmvG/cv6X0tYEa08Rzr/S+/UBp+td5aej9HiEKUpndL8JrB43OcTvBL0HqPR0uA03wg
	WjL/yOjTjDzZpbxs8uLXZBVeYzJiAsE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FFF6435A7;
	Thu, 17 Sep 2026 18:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D881F000FF;
	Thu, 17 Sep 2026 18:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789669697;
	bh=b5zVLhEkKOWEwakOfls77zzn3VcbclTffxYn4L85i8c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hx4f6/Jv3cwrMptmmP/azM4P7NNl4TgzLMYGPYxUvgj5fA03oSL4gHfl55lsCvHTT
	 pn5EvppKp1xmJVGJoCg35YpgKo//7RnjqDcC6S8a+5bv13BmFQXoavodtPLD14ATOC
	 rmLLzfgKdbwPSczeH8sX7PRwlBQtwwRWVY2CYFlhqSagmfzeq2QSmTyLzn5Sn1v1ez
	 GsYSrSrknJk0CULzb4njUW5QsatEUpC4El2M6cPUEGGYdRiyicyK7Mntpp8rww/Avk
	 Qil1cbyfX1lJNXxc5p1cZu4mSWyl9wU4Cbmp/v2R2k2C3fUf7DbdZRhNL48WnmlEFp
	 ySmtFZ+wMOr1w==
Message-ID: <efdec0bc-cab0-451f-ad70-ac24c1f69fdd@kernel.org>
Date: Thu, 17 Sep 2026 20:28:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 06/14] arm64/mm: Enable fixmap with 5 level page table
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-7-anshuman.khandual@arm.com>
 <be1c0a62-4589-4fe4-a500-d3fe16a6e610@kernel.org>
 <pi6o4hjdaz2tndzlx64qvzbgxhuyh3kyewpfetiqnnetbtpzpa@prrxusgc3lpm>
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
In-Reply-To: <pi6o4hjdaz2tndzlx64qvzbgxhuyh3kyewpfetiqnnetbtpzpa@prrxusgc3lpm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xa3c5xnsr5iuak914binct8hjjkfuu8n
X-Rspamd-Queue-Id: 0B57FC000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1789669699-576018
X-HE-Meta: U2FsdGVkX190aL87Y7nX39NAIrli8MDkA+5ua0F3bgwjgl3DKWCpsQBGed1qEiO3dzFpCaZG17Qts233QHOha768t15iwqmXvbAqlKtjtefvi5B19z40m3FHLjUiHsHXn/5tzWTJg60+QmGrFZI6QoxedibSZ7YB/iKVPvSsmU7Pb2aHlmJI8wrdnwz7DqaGBhZXk34pQ1xOpan3c2aUHwetKgf19iT/OVLELNvyE2mgsODo8Sok7qXQTAXvSjOFARs6yHA2eVPQ3eb1NJG54Qz+7xTJ5LOtSf/SMyohQuAWRziawqXF1wjWG3wLsZHJSwJb0DKmcyCsAHauyFJIdubYWI9pil3g21nP9+n3/XTQrQ8j45WEi6Z4SXBGMQYLtyN93i0142qxdU0QnMTYM+DRjihUtTptDrh4TgktyQGH+8OFakmwx569gFmOjLCJ9/sVtr2tTgQrfJh3S6Apk8wHTHVpkmvkxZew+RFQxxhByq6zecINW7tAp1n9JkOveJOSqSGAaz1uejackz4EDtwirCCC+bmqwZVIzMWH4DhPnhH54HmY6fBM2TnpHj2sPL1qcpMKO4ULv4xzJyDZwQ8J6XAvdUhUgu2molfzTUW969YBeVA/fLFDrmw/gT5XZsp2Qqk8GfESQhpOv/178GbKHWPqbT9kMMDLcBriydPlm/jYEq2Ohq6+XTEBmAGyvlMVF9GxMQzItQ6G319YUkT3zA8S9+lFNq4cjwDVq9UL8zpIo2XVLsQrcVsLao2KvIzjLRfX6eKFNEV+4IsJANeWBzXQ5D/0vFbk3aUFkv/PF5KBdTGXbb0SXaAxBDYAIoO5odw1bo9sGGetMWt07B2jMWncN/9dYxntyPsNX7rl1T4Hx7tY6FzO2pFNwDxInDsri0AJqrlpka5bY2XZq64zorVMOfeVbxSrUXi72aWwjOw4RkdHAIo98f4e4hv0qiNemQcoPLQSpPuA2m0
 lCxxabdk
 7EMW0oaGTpxAfxd3xcBAS1DrWvePF0+fcTv/rCDTxVVDZagI7Dcpy6ZfuVIUbMRuKkdZ1ofESgBfXBfufRGQwZwn/CHNlA2zipwgFnDSsbXieYwyetaegLb2DUamgXa8mkI1dUcphGLSv4HD1F0pL6rjeU7m0Cwh7cZcDmMJckcdM9IzRCaTOs9cvy8dLSZX12vOfJo5Fn1BB5ZvVZaKvd+R63ogITGnBijXsanfmopy7jU1nlMr/XSgRxya5NwBo3Qx1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 08:18, Anshuman Khandual wrote:
> On Wed, Sep 16, 2026 at 04:30:05PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/7/26 05:50, Anshuman Khandual wrote:
>>> FEAT_D128 halves PTRS_PER_PXX thus shrinking the VA range coverage
>>> for each page table level. Hence in order to preserve all existing
>>> VA range configurations, some geometry now need to become 5-level.
>>>
>>
>> Hmm, wasn't this 5-levels before, but other code allocated+initialized the p4d
>> table for us?
> 
> But fixmap was never 5 level earlier.

I mean the page table hierarchy. It's confusing.

> 
>>
>> I mean, I see how we are filling in another level, but I don't see how we would
>> reconfigure something to use 5 page table levels?
> 
> IIUC existing configurations which never required 5 levels would not need
> this reconfiguration even now.

We only map a handful of MB into a single leaf page table. The only reason why
we have to install more page tables into upper levels is because they were not
instantiated by other code.

> 
>>
>>> Since fixmap is used to build and manipulate page tables early on
>>> during boot the mapping must also gain that additional level which
>>> was not required earlier.
>>
>> I am no expert ... but I am confused :)
>>
>> We do have a loop only in early_fixmap_init_pmd(). So we cannot possibly span
>> more than a single ... PTE table?
>>
>>>
>>> Enable fixmap with 5 level page table when required. This creates table
>>> entries at the PGD level. Add a fallback stub for pgd_page_paddr() when
>>> (PGTBALE_LEVELS <= 4) which helps in intercepting any unintended usage.
>>
>>
>> Again, I am very confused. Is it really just "As the page table layout changes,
>> we might no longer have a p4d table pre-populated for the range our fixmap falls
>> into. So if there is no p4d table yet, populate a static one just like we do for
>> the other levels."
> 
> Right.

Best to rewrite the patch description along these lines.

-- 
Cheers,

David

