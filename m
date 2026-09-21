Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 967BAC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55456B00C9; Mon, 21 Sep 2026 10:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06066B00CB; Mon, 21 Sep 2026 10:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4D86B00CC; Mon, 21 Sep 2026 10:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6176B00C9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:47:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B91CF1401BF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:47:06 +0000 (UTC)
X-FDA: 85238046852.12.63D3564
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C6772C0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:47:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XZvbjTYh;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmEsUEvY9vo2zaj1qCqnPiixs7yLoUz5iuxdnJ22dzs=;
	b=RRwiJ7xIdaV/TAndwPKF23uU5U/FQ+KZrFE2uZKomRXKKbvzyU7LRX9C3xAkSZXJE4QKPb
	227pJA6iulGTgFzi6pEgd3Zw7bVwvD7TAINTWSJ/EZxDhhLyfR5HZZNgW54nIlICe5SZGD
	hSMWd++Va+quicZP6vsLLPl8PyvwkKQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002024;
	b=3nAx2WDy6gZa5miJzA3zEIEgSMjPD7/3OwmIZnLPcau0mbEuCB+JslyOv+XfppbrM7vpvE
	dqw5MXvhRCxz/bGu4WsNsqaph70TCwYy0rp+y3Maz14rg7uDCXXH7thgpmWv3DbRMEdspC
	N1RtAmM6WNOSiT4jQzRMTCpHo4cxXUQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XZvbjTYh;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26BDD42A9B;
	Mon, 21 Sep 2026 14:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2091F00893;
	Mon, 21 Sep 2026 14:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002023;
	bh=kmEsUEvY9vo2zaj1qCqnPiixs7yLoUz5iuxdnJ22dzs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XZvbjTYhHMYYLm5eZryPH0+GXR5XNmEMgeQMCPy79tnA6n+P5f4CcDTyQnt4dJkto
	 r+7dWlUrTZUruCEFkrdYRqfgrryNweCGyoS3uEbYCGDDYF12dPpKVfhxiyX0IKkc32
	 6sCF1bMHAl3m5tjQsau8dPeZdeT68CkcU+/ulfYl7AuORlXF5fmBX+WJH7wTSYtNKO
	 FeYi5cxWeXWmzKF/Lmmr8NGPq15bxbtIY/8dmxDI8/s+tuMQ2VJ0MVB3S7slT258mA
	 7wteppWFHsnd2xoU9oBuTlOirIaGCLhQ3kXhHOPIcAiQyCd0UaP1JsRJ9WwQhVdQiK
	 HyLMzG10qlNyw==
Message-ID: <198df371-4599-4e71-814c-b94bddd41254@kernel.org>
Date: Mon, 21 Sep 2026 16:46:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] arm64/mm: Convert pgtable READ_ONCE() as pxdp_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260903060657.2717457-1-anshuman.khandual@arm.com>
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
In-Reply-To: <20260903060657.2717457-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C6772C0005
X-Stat-Signature: srtkkjjogyxyeh7nf8awqemxhx7ypz7r
X-Rspam-User: 
X-HE-Tag: 1790002024-695835
X-HE-Meta: U2FsdGVkX1+N2m+wR3NzV/x98/mRHN9izVqaiGczR+O1n+ynXKSNgL+O37wMUDz6z7+onPH4UumJhHUvH/S/FyMj2EivC5NkAEMh7pmdHJ3CxuAeawaif+G6cHbqSmpuZ25rf15m+a9hSaTErSbojMWv3pgPbr1jDWdtZEAwCnVBCpsdmzlBsDNT14KueR04+498Y1jNCRdm4n8VC0jDD+glpxMEzyohsIWTKLwczas1LoH+DQOc4ZMXlXc9d/7sPXtDcm07xMcgnJTXW5G6D3HFdWSRDj5ou5v//e9pcrBdMx1uG9v0zk5vA6cpyZXRJzGxaU1b691jEhelg42H1aaOwcpGzHfUH1PkPH+p97Oy6f4YAjN4Oe0yVphIvr5w1lXVC8l7LfPgVk2ATueLVv7JNB9mGpf9TRQUhs70/yn5o7U18WMXBIQsv0VusYV5HdtT0BKpeBv2R8gOY3I2FEGEVpl+gxB2/zIVGRm7Ox8AHs2V9bTqNnzaeIi5WvYBGrVYBJ3joSd6ZUEm432uO0AAHPoclWoygH737YINTVx8WTcV8Can3MgR6yBcfDwZrypUiWYtk+tAiTxwyTUhX7o7rkewCh8IP890lm7xr94Yd5V5t1QrcxYcUhh+PcwGEZTl8JXajxx/3T67ur1+yiuVQomHKhUJrsfNtFCQWiJYzqhRZb2dPPxSk5dNUGPOsGTiI2FLMfRMDVndmLn7AFBKOQ+L0an6WAqG/en813WTNq2GZNQ8KYtoeIMkO7vlC55kFYKKzmSyYBRGoKpmnEQH43COPKI3cZPkvWU1UyXLBWleZFywOKRG5vaz04hRql8SBnqf0ePPiCOTtMpURUrvUowDoDd56sSVc5Hcwred22RhnvPfOQ2v3aCggrmiII/KwUZxFnjJ6ONS55YRHudx2aaFaa1ts7R8FijtHHzvOnDT+epmMSSdWFecgLm/E+475oR9qibzn57eQE3
 twLQopr/
 mvvWi5X0ZgkKHzLKvUWqwPg5/kGWmwQGkvoBUx715tbrNshlpX7RUFz+Ib+X2zi0oQ/vOXPd/K/5Ke6CTXClbH8IILmpMt6WPuXeMJ5uJLukaMRW0o1tmFUBhBh8STiGKDE8InIQkli9MUnXbZ6/1TZd57PqL/4nByxhVXkLLlv1E5KT+xgR6aDpacMtI5RZ6OBT5qhHOXvFn4utzFmzozMbg+JZM+kFXsY5TvOcmlu9tF3JEyDcp+1q0mzog6Fu6PoZXnZzrlYEpgX5Iqbeb5W6VYPIQ1nZ6wTJf3i6K6Hg4Qp+6yGBccaZ8C6TLy7f+FcV10ZCEo4Fkt81xWvumcXCdZ7PjqaX+LzRQ5+b+4lP8nldu1zBsH8lpFZR74d5VsUW7LgjHGHCR09cnCXIH1iREC7nIOFNXKxDAv49ZuqF1fAZJTZujRK8leN98ttrcfcJxbBM25inLQyuRd7uweo23Ez8vZ5qXglf5PCf12vp9X92FhlHUx8wxSNbiVnT6J4EwyB1sVpiRwRDaboDSjitcQI9ShBadoO4UEnHfeC8XQpmM/YZRBZTIpksOV53+S35Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 08:06, Anshuman Khandual wrote:
> Route READ_ONCE() accesses on pgtable entries via level specific generic MM
> pxdp_get() helpers which platforms could then override when required. These
> accessors on arm64, will help in ensuring page table accesses are performed
> in an atomic manner while reading 128 bit page table entries later. But for
> now they just default to READ_ONCE(), thus preserving existing behaviour on
> current D64 translation.
> 
> This is similar to generic MM, where all atomic accesses have already been
> converted from READ_ONCE() into pgtable level specific accessors.
> 
> These are preparatory patches for D128 enablement, although standing their
> own for D64 translation as well. These patches are split from earlier D128
> V1 series. There are no functional changes here, and besides mm kselftests
> do not show any regression.
> 
> https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/
> 
> This series applies on v3.7-rc1 but after applying the following patches
> related to pgtable entry print standardization posted earlier.
> 
> https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/
> 
> https://lore.kernel.org/linux-mm/20260901065454.1906343-1-anshuman.khandual@arm.com/
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Linu Cherian <linu.cherian@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> 
> Anshuman Khandual (4):
>   arm64/mm: Convert READ_ONCE() as pmdp_get() while accessing PMD
>   arm64/mm: Convert READ_ONCE() as pudp_get() while accessing PUD
>   arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
>   arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
> 
>  arch/arm64/include/asm/pgtable.h |  6 ++--
>  arch/arm64/mm/fault.c            |  8 ++---
>  arch/arm64/mm/fixmap.c           |  6 ++--
>  arch/arm64/mm/hugetlbpage.c      | 10 +++---
>  arch/arm64/mm/kasan_init.c       | 18 +++++-----
>  arch/arm64/mm/mmu.c              | 60 ++++++++++++++++----------------
>  arch/arm64/mm/pageattr.c         |  8 ++---
>  arch/arm64/mm/trans_pgd.c        | 14 ++++----
>  8 files changed, 66 insertions(+), 64 deletions(-)
Skimmed the changes, purely mechanical changes, so looks good.

Consider spelling out in the patches "No functional change intended."

-- 
Cheers,

David

