Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62FE0C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E356B0159; Wed, 12 Aug 2026 07:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305FD6B015A; Wed, 12 Aug 2026 07:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D056B015B; Wed, 12 Aug 2026 07:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 001DD6B0159
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:19:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81C22C02EC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:19:36 +0000 (UTC)
X-FDA: 85092371952.24.548EFCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7CA8100008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:19:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lEqlYMMD;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786533574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/Wc313GCSl3I+9bKCPbE8GI5lwCsPHIrZHzJG1vSW0=;
	b=5DW8Pk1QnxGTpaWjpArHGQrOcG/DWVTzu5q9KrWusZq5Mt9NyAsnbHh0MbbUk9Lqwoxxwi
	iYwINiobB1MJlBuNpOvrOSqx0KrK+XMbftBPa9u2NoI+t3JA8UBSWJySavJTSwWJonhbER
	oSj3Vyc/ZFcRGHJ74kogKJIWIsG+N2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786533574;
	b=0i7XkmJ56DwJ47KEFkpcQgpVgNxlyfccSNifq+RMsv/hBt5rok+Bv33Zh0BQXcy+7aLjT3
	1eulKLCqCFXUj/fng+K/EL8qpmVqDvxEvPxZ6j+nrgua35NxPPqAKlct7vnl7v9OprtWvJ
	yQtEgcTp7kQhZH2hrpbUEFAaxz0FbFs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lEqlYMMD;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 041DB436E1;
	Wed, 12 Aug 2026 11:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C931F000E9;
	Wed, 12 Aug 2026 11:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786533573;
	bh=l/Wc313GCSl3I+9bKCPbE8GI5lwCsPHIrZHzJG1vSW0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lEqlYMMDgeTWx8AQyeZDeNvVbDlKRIB4pQGJ6n2Dxbb98LpTz0OaCHQKEnqr3cLQO
	 F8jABLEmGoA1eFi4yVM0INwhQZjWwbUYh7kTVOrw13k2eL3i2sW9WF2p60zuAyPddP
	 niXXnwlds6idzM5cDHLT0T+ggPH9mu6eUdpb0cX2zrdJxENvwR165k34SkTa7s6aoc
	 LFxIZtHzHee3VQz88+b0DgeVjRYMNM3AX4QyDpXnOJXq7kpjD9FuUCvETmfwaJFFh5
	 2++70MQ443NWiphSX+NfcfZdMz1tERFm69ZeBbb67w/gKKmzYzzoK0vYS8YytEqOHW
	 l6wOnqNizwyeQ==
Message-ID: <e0ada89f-26b2-4e82-8273-8ea7b391c147@kernel.org>
Date: Wed, 12 Aug 2026 13:19:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 1/6] loongarch/mm: Stop using pte_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-2-anshuman.khandual@arm.com>
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
In-Reply-To: <20260811042119.3652929-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fm9m1uzqj5is5aojx4q9d1sff666dr3c
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B7CA8100008
X-HE-Tag: 1786533574-228037
X-HE-Meta: U2FsdGVkX1/Bvv5Z4pK2doS1pEukLOGZ0RHvhamLq3qBE28zU2LHkRicsp9m/MBbZoTO5mhJ/pCxHtPE0KMgJn61cMijc8Ugxvf4GZuxeRKNS8WE67thKQaE3EAkdUD2vwfU/CywdlDweg9mfzZgnjOsqrSXg7ve46LA5BCGNJvGkjz0EIf+xK+cHmC9VkOAEFcmoYEdhiojWOwuVtoW161f89MhkY6PPm/NxJV4iLNB2J0ylLX84i4xudm+hMU+ig8M/YPlvCDQ9Kp7P1mv4/bPA0/QorsSZhuUq9hz3XAtnkH8IP+vGC4V77Y77P4+Suy+OhjFdCtnUB5ABTNcWg8ugpk0T84FRgxWxcP/FrrFxnGj0XJHV7TmZo4FXkq2/xEo2RbmTR+p/ICphPB70VplAnStQbu59SDYM2t2XM3+KnUD8RwJ5stD6neRdJwy4E8j7zZUfUAi7c3EPHHlz2dWiwyxXL9IzSi4HKnFjO0Z0BZsQuMt01No/2jja9XV8CGF9P8ktHRMxPJQR0AblB1J7C2vXRAqpe9VMINSsW7qG4lr4WGLY1mJSiWplU0EFzKaD/ADvPuRFmRbw3oZkzjRyw1X115szFydAKC9rjeYPCbP5SpK8zx4pE9p61Moc0mCNm4PnwGyH/3bRXTSEgANPBkx7KlCq49I/thzigLNEnlz1LVHw45Dkz7EBputo+xvNdLYSis5ZpsMyD1ZArkypQ/BZcee1E1Ss4GFKIpl/YxCy3aoGCl8xxdkHEHwk03Ct/nByCB40i0TfzbGUWlkZPeQpRJhJ3DXV+nBs9uk7CHrilYAzo+/wvzstMF3hPIWuye313ApX+3vZxEOjyvf4/9Q5XLptZ3lOWFNvFunTLESi/vFTbynQbndnhUu2HQClhf+9PrRT3DkwGExT/8HnQCobNlqRE+DuuW5pq2lBAL4euuS5kNsv5Da6tNGkfk9rNTBZDN+OMjHpaL
 vKJtj+JJ
 6TStatsxkpbz7Z2kpFRQWQgKW0Bp4mds9WRTi8te+QKjViDOIgkea2In5hXke1oeIePb1u6GV5A8xi9XYgOEQ+hyKu6gez2pn8qj5N88dRGSjFfg33rWn6oL8rasdTGF2F3vjpVzZmr55X5qInV+m+wsCt4VBRSFaYAYu3QQsIGR0fiehSy0XY1Rf14sFLUv25qEoJStsMbGhuq8fA8X/P7CliEYGESsmDvUW83wTuvMnRiEHFXlpwFPISBCy1mRFHQ8oEI3SFasZWUBXF7hwTdP7VpWi4i2cQbWUkCLWZ0JinyEVffsHc4VIp4i6WXspcvSe4rTfGOJlHALf9sk1uIRPSXTS2ct8Bpcr/L1cLEN1r2pHIQdiczxYhUod18YgsiIyA64JJkx6JI4M2Oz3lo98i7DoDQ3K41nEuc0RRxjcmditjs4uVGm3e9mNvQSuCWat120JuRSh8NCm+Mc1kup8/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 06:21, Anshuman Khandual wrote:
> Directly use pr_err() in __set_fixmap() and drop pte_ERROR() which helps in
> eventually dropping pte_ERROR() macro across the tree. In this new printing
> __FILE__ and __LINE__ has been dropped because they are always the same and
> don't really add any value.
> 
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: loongarch@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/loongarch/include/asm/pgtable.h | 2 --
>  arch/loongarch/mm/init.c             | 2 +-
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
> index 223528c04d73..a32a8fff70c1 100644
> --- a/arch/loongarch/include/asm/pgtable.h
> +++ b/arch/loongarch/include/asm/pgtable.h
> @@ -128,8 +128,6 @@ struct vm_area_struct;
>  #define ptep_get(ptep) READ_ONCE(*(ptep))
>  #define pmdp_get(pmdp) READ_ONCE(*(pmdp))
>  
> -#define pte_ERROR(e) \
> -	pr_err("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
>  #ifndef __PAGETABLE_PMD_FOLDED
>  #define pmd_ERROR(e) \
>  	pr_err("%s:%d: bad pmd %016lx.\n", __FILE__, __LINE__, pmd_val(e))
> diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
> index 3407030f3e7a..be9b127daef2 100644
> --- a/arch/loongarch/mm/init.c
> +++ b/arch/loongarch/mm/init.c
> @@ -203,7 +203,7 @@ void __init __set_fixmap(enum fixed_addresses idx,
>  
>  	ptep = populate_kernel_pte(addr);
>  	if (!pte_none(ptep_get(ptep))) {
> -		pte_ERROR(*ptep);
> +		pr_err("bad pte %016lx\n", pte_val(*ptep));
>  		return;
>  	}
>  

Ah, I missed that we want to print actual values, I somehow thought that we
would be printing pte_none() ...

Maybe we should just be more verbose while at it?

pr_err("unexpected set PTE at %ul in __set_fixmap: %016lx\n",
       addr, pte_val(*ptep));

-- 
Cheers,

David

