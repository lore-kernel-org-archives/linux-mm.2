Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 217C0C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD246B00A1; Mon, 21 Sep 2026 05:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3E36B00E4; Mon, 21 Sep 2026 05:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2746B00E5; Mon, 21 Sep 2026 05:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFD816B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:44:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CFF21205AD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:44:25 +0000 (UTC)
X-FDA: 85237284090.07.29D6121
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id C356814000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:44:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qwUc8yek;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789983863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yu9bHXGQw+DaXYWxFGKYbAE+cSQo+BWii/VuW+Fkk1M=;
	b=ufWeUYseG+mxnIj1jru29exueUqiejMMcMACD6/KSWrmohcqMIC8vLF31i1QvK/FpjpBHm
	ozI7t5OKMqZknWzv4bQjnp+JBdBvKRc0NQGZnkjbUAY+WzGBUeM7AIIQJ9qxN/wRj1/YCn
	54OqG0isVGeufnnDtP6F09KcwrvgwYg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qwUc8yek;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789983863;
	b=K00KRd+YFPSDU3w7nP0PTulbYiSkZTB6C+P9yq69k7Ew7D0lKyqz306+qYzgxYW77P1Dir
	iodmPxRp7MZwUfie830jDTMuHBtWHyzl7uhbJMKnV6lCAPKwKznSBHpmaneuEFbl+vJliy
	PQVXI69U1NeSxs20WrzoAbPIKX1/MOE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2998F153B;
	Mon, 21 Sep 2026 02:44:18 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7468D3F86F;
	Mon, 21 Sep 2026 02:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789983861; bh=QGwc+dAkTPXAJc9o4T5hZxy9BZq11nu1Z0f1P5saI/Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qwUc8yekPnle5iyolREB22nxPCxek0508Oh9aZKHTFLruu7FqF8h71LWhAgNuw5e8
	 QO8MRf3saEnhCc9HduCxILbEzWErOEEfJEa25crNaoG3YkHcqnb9MTAiu+kCe9UwNQ
	 wWUie9GNe6r5o8kHoxX5FXP83fHJqGFNHbtOiC5c=
Message-ID: <89d44eaa-2ea8-478a-8a39-af91373485fb@arm.com>
Date: Mon, 21 Sep 2026 10:44:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] arm64: use HW PTE accessors in early map_range()
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-5-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-5-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C356814000F
X-Stat-Signature: oat7nfuxwt9r1r8jxjuxnkhrw3nry5x6
X-Rspam-User: 
X-HE-Tag: 1789983862-395334
X-HE-Meta: U2FsdGVkX1/tpLKFIziYhowDphxwuyUttTmoFuqQjI1D5bg6VEzHxYN1xONewBWp0kjKEGtl5FES9X5bFzdJGMbTmzAxSYwkYi/IUqjzDKMrT8bbmMG7aGXZGFYGnRRhjFBQiKDifgxOqvrpyX7XUY6Q/70dmu7Rpm/NMvpRehAheFIeI4H048T9ZeF67nS5CTGxu/KYkhHPiP7F/1rl3AoC9vMZXX09+6kzXuMaDuLSgodyIllxkW4/L+i1/FAn9bYOYMuVg+AoXNRW2TUs81mkoNBw8Vt0AhHbz02tMgqsewWMuaa5fiK1ffdVzdh1A8DJ4I8a11YCJNjpPg1gKLByHD+6qAsx9qdt96vRBtXTdFILaIh4ThdUUYiEgY1oYtlU91EeFJ9iUSbe1Wwh1xtZhFABw39QDyiDpoSUInccEeeF17147f78GTHt4LgvJb+V/7Mkyp7NpYJEJMVJRJjWWF0DKS8MCR94TF107Bci2rvTl60H7z2C0MAD3fRSzGHQRSDbOQ2jV7CGX5z9cxbnqU2nC4YqrToipc9Z7pWbTpMhudhhAc1HVkbQOsRaXy1MoPj4xsE8fVKt3Lk31wjs93f31brEpdFJNEfk66hqvB9err9ssSyqpcOXEm5hk1rTFQmUTrddi2s/3wQZ+Htu7aUAluvs0erEVyRUlmkYTeZXayJhWw7wYfhY1+DHmS48ni5BFVDLuZ4ojFblbfh1WlfeexFRoT823rqz1uJjQ0UeBiQ+ggkKqtAdD52WVqwBk3b8TAF4xS+YHz9156PISUcRNeIe1Q42BjDtIuV915fu+3GLnqq0HOEp7wxzH+D4KrDsMEmqoyIPAF5CnwWOrFn6FqcChCvIvj97ZoWfDuKV+FuS588NhN9wv0vD8O8c2m4mg2CmqfIvpej5A/s2vYDLnK6fjtz+be5gR++NdMuh4N3D2oyTDE5BqzVZwQQqf7jEKn1ExzseVuC
 +afJK7t4
 PA/HvgvwyOpAmQUaFNo5gXnRJS4bshzcFtAJvE9ZbWklMaoYOxJ+n5FRkOBRvjbN6ENda2hVsqKa53vBNmzuhyqmxJz81qHohiC2ja1Xt/F8xexn8K9iRRCuB0lsZCxHzMOIAU3wfzDkVpD3GcsbCBw18zjOREKu8edqWjr0xED2smxmL6ZQ6cNwBcbF4wggZiTLzLOWqT6Rp5qTAgCAvrp6zHlfiRRQexfU2Q+WYOvv7XVST7IBQQMXifQmHa0rCOvQT1AYBekGcsqJoRgauhSTZFU2iXTTWfa7bCDUz1cmHSsx1vXMgH9Iu1nxZ8bAnPzMlWneRcOpfn3XsAzMYwcGdw2CXf7Hmrw7QBAVX1OHAewCdfBzqNAkeaD2bVOFn+dfe5HwXbhCfDHPalamvgsm8N/R1Ra93cU3YMdv2xxsGohxfC16K6nlo0HtlyzU4ZCZbdkOhf8/MnHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> map_range() uses HW PTE pointers to build early translation tables at
> each level. Directly testing, decoding, or assigning *tbl treats an
> HW PTE as a SW PTE value, which requires explicit conversion once
> hw_pte_t becomes distinct.
> 
> Use __ptep_get() to load a SW PTE value for the empty-entry check and
> child-table address, and __set_pte_nosync() to convert SW PTE values to
> HW PTEs on stores. The no-sync helper performs WRITE_ONCE() without
> adding the completion barriers used by __set_pte().
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/kernel/pi/map_range.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/pi/map_range.c b/arch/arm64/kernel/pi/map_range.c
> index 94f06da76e333..9c4c8060c5df4 100644
> --- a/arch/arm64/kernel/pi/map_range.c
> +++ b/arch/arm64/kernel/pi/map_range.c
> @@ -51,19 +51,21 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
>  
>  	while (start < end) {
>  		u64 next = min((start | lmask) + 1, PAGE_ALIGN(end));
> +		pte_t entry = __ptep_get(tbl);
>  
>  		if (level < 2 || (level == 2 && (start | next | pa) & lmask)) {
>  			/*
>  			 * This chunk needs a finer grained mapping. Create a
>  			 * table mapping if necessary and recurse.
>  			 */
> -			if (pte_none(*tbl)) {
> -				*tbl = __pte(__phys_to_pte_val(*pte) |
> +			if (pte_none(entry)) {
> +				entry = __pte(__phys_to_pte_val(*pte) |
>  					     PMD_TYPE_TABLE | PMD_TABLE_UXN);
> -				*pte += PTRS_PER_PTE * sizeof(pte_t);
> +				__set_pte_nosync(tbl, entry);
> +				*pte += PTRS_PER_PTE * sizeof(hw_pte_t);
>  			}
>  			map_range(pte, start, next, pa, prot, level + 1,
> -				  (hw_pte_t *)(__pte_to_phys(*tbl) + va_offset),
> +				  (hw_pte_t *)(__pte_to_phys(entry) + va_offset),
>  				  may_use_cont, va_offset);
>  		} else {
>  			/*
> @@ -81,7 +83,8 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
>  				protval &= ~PTE_CONT;
>  
>  			/* Put down a block or page mapping */
> -			*tbl = __pte(__phys_to_pte_val(pa) | protval);
> +			entry = __pte(__phys_to_pte_val(pa) | protval);
> +			__set_pte_nosync(tbl, entry);
>  		}
>  		pa += next - start;
>  		start = next;
> 


