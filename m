Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0CEC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2E3A6B007B; Tue, 28 Jul 2026 08:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05456B0088; Tue, 28 Jul 2026 08:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DAB6B008A; Tue, 28 Jul 2026 08:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75FFF6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:50:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0136940371
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:50:55 +0000 (UTC)
X-FDA: 85038170112.02.942CB1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2CD4D180009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:50:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6esq+r6;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785243054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ne1QxTrwUiufj27QLOxN+cEuVrvrZctkzV6bT7vB6lY=;
	b=paEpk53V2ApuVnRJ3Wqxy/ecztuAGKSR9luO9I85vCe7jdgwPyzxgdCHV/9iC974SpRV/k
	I76+/hryVn5/jL04UGYFe3KLZ30eipCTrtznqPQ2/5VmR9WUgekX8E8qR+cXI1PPaLr5nC
	Vp3h3tSwSn4DpIRrSljkZ7JEVSS5Ki0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785243054;
	b=r3ragcG3g28j2mn3sYXjGqQDXl0jpUYw1acf6a1ZzHd+SkgHwLvmuxRKax6NAfqBQe5Tf5
	JPxrI4vsA04Xt4Ol+MqCoEvdJe1nl6TC27akxGpWSqWKkWV9LwVk8Dmw9cTjuJtoLs9gsS
	mp5K5ORlOjyqNbSlgHXsI5/DMyEbdjo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6esq+r6;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EA324323F;
	Tue, 28 Jul 2026 12:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AF51F00A3A;
	Tue, 28 Jul 2026 12:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785243053;
	bh=Ne1QxTrwUiufj27QLOxN+cEuVrvrZctkzV6bT7vB6lY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I6esq+r6jOKQTWD243iyapiiUo/D7oSzgNZ/yPfvQVkJrw7NKpAw8Vs2cdvEkHLC6
	 9dr16Mkre69dNZ5teA7l4qKieFv5QxHvRUlaChOihWHvk+TjTiFCxT73bZDCyV7H7O
	 a4j33KKBPY1HT3D+sbkMiwesFyl9IgoC2Buu2YN9u8ML0bwEge4XZZpl3XbF8HsJJK
	 TJplOrd06l0Txhk1PWSyHI3cTUTlkmePckZOWoNWrfneWt+PyNXDSz0zI++19X5DVQ
	 TkowH7a/aVf4enaTfpg4PiM0geRWXjRJgAltc7sC2tUl7C8tJ+UwM2PE9S7ke0bgwV
	 ycYdjkzKl5tAg==
Message-ID: <8d50f94b-6d95-4967-aa1f-2c14333ffd85@kernel.org>
Date: Tue, 28 Jul 2026 14:50:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: Arvind Yadav <arvind.yadav@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, ziy@nvidia.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 balbirs@nvidia.com
References: <20260728062832.1107127-1-arvind.yadav@intel.com>
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
In-Reply-To: <20260728062832.1107127-1-arvind.yadav@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CD4D180009
X-Stat-Signature: km5or6ab1nu6x1de178s9rgkxqh3xrpd
X-Rspam-User: 
X-HE-Tag: 1785243054-797297
X-HE-Meta: U2FsdGVkX18GccsSLFd9mQXgbBOE1Hcwjz4Im2FdIp1DTmyDXDFFD9Y5BVTLob2F6rucXYU8NAYncrrYIN7PdUM8FdC+9RfIkCcMtSaddYEBU38zFZw4zTRXEEWE7UtYQc6uD0qYKorsftVfNGx2nCVsEYxbhTYMoYyg3E455qYuNvwwHd507/fEQzu/WWexcMRnApjMqZh/MP8V4Y0720+vUejL9WIvEjE4RNTML30TqIpsreDSWaGopfWtiy+N/SfGzO4oM0KBjVLSsKpWJWiv7gos6c7SoJU3JtoO+HcdiVwntZiRjSVl2iCHH28lpAeT/C3p8djtn7Fa+r34IwfYQw65k6naxzF7DR4iEQJllCW2aJko3s4rqLmRCGThUxT84M14SE9vyf7Y4nmXTIkdCDrhmhRPxy4JdTdAU58Hpve6ygZsLFa/P0dZY2KTfJWaH2YSY8lrxZN8BSL/ssBp6/LXZDmgqpUWUF09BhwnVyKQvJ2Fe4+vgrihm4btuzfWdjohZZ1Cr3Vvz/LO+jgtC61gFL+qAlZbxIRx+A0WeptDCkltPIboDhStDMBSLBnQkq9lRCTDzncfghVKNyBZDYT74JGv5hfZQUpVMYUbp26TjOry1R4W0/u+h+D4/eoBFReO9Rt50JxIvhtVXJTkN2KNNhKHYz4P8wPLNqvAbm7TpKPUHPgDlTO7DcU38PccS4N3Mwv4FASTG7GsiU0hayGLHJ4qwrgmUVH3tw6K2dLzMZjDJxdCXSLPnJhPqUk1ONXbH2axkkYyTmvSZ3tyAy4ZLVbG9WiS7q/WLjLATmvfzHHC+J4gYFVNfFtkuHqv5ogE166Au6/EQG0/G/1duLeZ6Cr3OGu8Gm1etra/N3tYxCTRCcth175DauqBzVq0qkHlWd1Av4LELEdlJW3d5pUC8VyMPWDfH1ur3dyuE+gxIdZ3W765GrEsXfngax7PXPePeUZ4RGj528p
 gkJ1Cs8/
 vhcl/RrUo+5nut5+91/3sPXsSnxi0oCLtHLiko3jV/eKy/2n0sR1BiM52a0xKcQSJXRE9yalFEZIYBxaS8/18G4Cp1DBzwOgHhzZMdomioC3pvQlhfBv+Ap/TR0c/wZLAeobJXABF9Otd0sSgSLJb2A26NMgqwSwexiT1wEQC+Z0kwC+DQ5ro1LXlqOOZbXEpc0MsytLkX1iwQLC3PCZooX18l60S7Yrhmvwl9edaVBQqousfELOzabqEuUAGUFYFB1zi2B0Xbf/sKVmO9uT86uUvUZK70hYaMxPzlGWTLO1+vusj6y+OXYWAasEiwUuOQyNrhv5M1z4zP5sw8ZA43szsw2ae/tuxt47cTXV80nMa3HMpZlNU09MwEI+At97tWgb/jzgBpsaRqwgnfifKDfFcWoUf9ZjDAMAE11wWbXGoM8ZQhSzAuq9OoyOfJeBjfzJWVNGvGbiwPHc8RtXv7xFWg4FCKJFLs25hz0r8/XCVVKe7qDhzgC73ZJkYw9X1O/3DbGTfhUVqu0KwkYck2lTiuVnq9HMI45+zPdBJ7AmDaIQCskBsKL0Ttgzkp+HmIdxCwIKzDhcVX85OKvQLUuEhNV6fgYDl7Sm0wixFV9uaqK9HBBhIQN46F/KR353jq2/RL7z34CDokGPmuRIPcqJjzp5Wmy0M93/4eIUDoODGH40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 08:28, Arvind Yadav wrote:
> __migrate_device_pages() reads the folio mapping before calling
> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
> from the swap cache, but the saved mapping still points to swap_space.
> 
> Passing the stale mapping to folio_migrate_mapping() makes it use the
> mapped-folio path for a folio that is no longer in swapcache. It can
> then operate on swap_space.i_pages with invalid reference accounting,
> eventually triggering a folio reference count BUG.
> 
> After a successful split, nr still contains the number of pages in the
> original large folio, although each resulting page is now a separate
> order-0 folio. Reset nr to 1 so each split folio is processed separately,
> including its own swapcache removal and mapping lookup.
> 
> Refresh the saved mapping after folio_free_swap() so the current folio
> state is used during migration.
> 
> v2:
> - Refresh the mapping using folio_mapping(), as suggested by Zi Yan.
> 
> v3:
> - Reset nr to 1 after a successful split so each resulting folio is
>   processed independently, as suggested by Zi Yan.
> 
> v4:
> - Re-read each source folio's mapping immediately before
>   folio_migrate_mapping(), as suggested by Balbir Singh.
> - Add a warning to validate the post-split order-0 invariant,
>   as suggested by Balbir Singh.
> 
> Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
> ---
>  mm/migrate_device.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 554754eb26ff..0e6f00190fd8 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1182,6 +1182,13 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>  							 MIGRATE_PFN_COMPOUND);
>  					goto next;
>  				}
> +
> +				/*
> +				 * reset nr so that only first after-split folio
> +				 * is processed below
> +				 */
> +				VM_WARN_ON_ONCE(folio_test_large(folio));
> +				nr = 1;

This function is surely a beauty. (had to rephrase that sentence 3 times ;) )

migrate_vma_split_unmapped_folio() modifies the src_pfns() entries on success.
(and somehow assumes that it's always a THP, what? After a MIGRATE_PFN_COMPOUND
value is set? What? Why the "nr = 1 << folio_order(folio);" in the caller).

If we ended up modifying the current entry in such a way, shouldn't we just have
retry: label and restart at the very top of the function, where we just
naturally re-read the entry/page/folio and do the right thing?

>  			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
>  				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
>  				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
> @@ -1221,6 +1228,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>  			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
>  			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
>  
> +			/*
> +			 * folio_free_swap() removed the folio from the swap
> +			 * cache. Refresh the saved mapping before migration.
> +			 */
> +			mapping = folio_mapping(folio);
> +
>  			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
>  			if (r)
>  				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;

While this looks good, I do wonder why do we have to supply the mapping here at all?

Is there a path where we call folio_migrate_mapping() and the old folio (folio)
does no longer have the right mapping attached?

It would be a lot less error prone if the function would just obtain the mapping
from the old folio.

-- 
Cheers,

David

