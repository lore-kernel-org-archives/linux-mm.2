Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 026C7C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C976B0099; Thu, 27 Aug 2026 13:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103D76B009D; Thu, 27 Aug 2026 13:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0191F6B00A0; Thu, 27 Aug 2026 13:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7B006B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:07:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5BD6E8011B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:07:48 +0000 (UTC)
X-FDA: 85147681416.20.E0AECCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8A4DC100005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:07:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpG3+WHr;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787850466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Z6o8710DzidIAipF/VZF9PscAZF/OQSOxpmYRB67qA=;
	b=GgvOLsX958GfarKtQemVmNi1pG7x/XsxYFBo1LkbYBsmdG/r5Ii6Q1cgfRgkpe36FMkzTZ
	y4205mIOzlruToWtZrHXmc6YLndPQL6K1+SiUnG9Q2iqKudvdclJTdKuW6nHl34rhSEz63
	bZAIj7OV9eUe8mlwpuMk2nDif/0G3eE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787850466;
	b=JgkzrmDfV93x00RasZsi5JuIphlyDkmzIquySboGTTkRdLzgvSI9P6I2eulkCo1VxBii1v
	qEyu7OltZcYSYMnAH7VXjotTKE5Ec9zyvHpBHdgr/9u13cY8vxq61oy2WW9m6laj2hnz1H
	Z/oh9eiC4OzM33CHCF+X8wnnFsoa5Uk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpG3+WHr;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 038D1600D2;
	Thu, 27 Aug 2026 17:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39FF1F000E9;
	Thu, 27 Aug 2026 17:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787850465;
	bh=7Z6o8710DzidIAipF/VZF9PscAZF/OQSOxpmYRB67qA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cpG3+WHrJbTUk6ZbVbYSUULv/PzBHhY+6COJiJmNTPFJTKr6aJSWimMlfMvmMnu6P
	 F2R3oOVDJnLy9vt9Awvh2AUDRruAD+t92f9ZLGW4VHZ6CqW2nhJWaF6xFgviPPCyPL
	 dXup5fMDE1HeIDpgjezNcmCLC1xcdq6TbRAE2z86KNgiR4nreCif9Ij1sWdrEahZi/
	 +pqoBwMQ/LZd9h5nchLgeUifDMhcUX9+pU95sGscOSJIgbxAL1ENTo+SB2NRNYu0Eo
	 uxp2yaS9dj37FaBXFnWeRueqTu+WU2BB9iWVd1joBj52hSJu0chjoiQ/+LDuflsUgh
	 fZfGfIEAvuwdA==
Message-ID: <01865a13-2c18-464e-94eb-466613de7bb3@kernel.org>
Date: Thu, 27 Aug 2026 19:07:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/madvise: use vm_normal_folio_pmd() in cold/pageout
 PMD range
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, jannh@google.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 peterx@redhat.com, jgg@ziepe.ca, sashiko-bot <sashiko-bot@kernel.org>,
 stable@vger.kernel.org
References: <20260821144947.167382-1-gourry@gourry.net>
 <20260821144947.167382-3-gourry@gourry.net>
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
In-Reply-To: <20260821144947.167382-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: esz8geii8kiuzxf998mah571je9sebzw
X-Rspamd-Queue-Id: 8A4DC100005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787850466-587576
X-HE-Meta: U2FsdGVkX19ViHVkcO+7mNgBvs8f5IY7AioqiB/ZOe4VYSC4/nW+D9Q36PYY0tts3mrGvQF7ud1lA2vb+sNGFDAT73GWC4MIv0wgRG3uwr7Znjk119jYVdW+4n8dFY0UPOwOqfO7aWBuSLtYBjVETKoTwJ9j6hdWTc3vOx7wj8mO5U5TRFm0q26TiklMa4qcQTrpiHaouBuKWVsathWYVgfJjQBc8mhkFGyLMz2JGGLgbKZSp7Lu+LuCghx1+8kjqF39i8XDzJMfuINzcvxtc7dEKdMuGSlQgjKUUsnfOY/mtTjqTex96AztaFCrek3jeN9wNM/jIkgVpV6FUGSrm9aZH3hthsjsVTgxcV9MBI1g+FH0FEKmMizmBmbxiWXaj6FEPaxOOFfDGDOlhPtIPwca9erCeObvWUV2Qpe+CPLDWP6lcCNhQYZWq0LONkqgG5Il3NICeUrmc/GhBIsBAeUuQOPAfDqtnEAvWxgt3cToh0OrcG9jhvG2IWmmspzUByd9cBrCzA3NkjpPY2TWYGOO6b55JbwusnCNgOhtBJdXTbt+v5xvWPvTQnCYiGxxyh2dry8DnzfTGwvOmK1thzLdfw4YMp7xSx7GD/FrXXg6wtXnrrdKoUpSqMWdQVuiDR1gaz5TiSkZdtUhvOzIjs0yyCY4LrH/wn44Jn64MosteNP8ZH7gUVHDl74lrJVyaYNXL4yY/OH5qAMkwYJo1PF5uoMjK7oDN4LfidhJ/W1Vyhw+FxWxzb3vbDDcEaYFhw3Koi19en/1CKwet/Uq8A6wRgnuR4TgZ/RKwtcQkP6JINNCHmRtzK6pIrpSTUR3xegD0ye8pR+40RitxeUtCxz7hhn55NnsgVs5jnt92NAoqI1zX6TS45dreCEeUD3kqnt1z9L5kn3T7ZwwzKhjI1FIMsTRwj/oHjXxJelWSP6+0kFKuidpKi+N/fYq7+9dlFDkGqfJJx14sYgiVFF
 erOyVKdP
 SZhlqooQoMAK3u12v4dwmyR7OmZX0A3tBn+IzpPgqPfxRDfsFV1DueFYJRacvhpQ7BQwV5o3AS4rYKMFworqoxGKj6r2bublqtWTNO1YmrPcGMZjahGOcPuDq7BP8qZKUjyIrWwxRedoXACuPG+MTiYWUdh7lXnBjt/iYGsHBREKyXyhOw93Asm2ICcPBW9PqHEs26355U94jN/PazEu+KGpOnvmvQwvhttF15JxQGdn6GHGNElWMnQxt2gmkB8M2xK3xS9JczGirVtRJ+FvDJpm5XlY3q8gUk4H2WfgWQ9lAAgH91QLW48nbij2JXGq/ym7TKWcKEFJ0CRiCsJjDSXrehOZSHYFKZxIocYdD0GFtdy6oKedrmUiFZvCUrNTkx20zmZXhdLvYvV6btrXxsdamViCtNpyZG6+gwXlcD60oYbQDetOB/wjX3+Mk/4SNlJ6YgKJIPPw5BfjeTI2qe7Rux8fpR0wNQ74ITYlaJixehjYhIKt9GxG6EUFEBVF5Ei9lna5njzj/J6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 16:49, Gregory Price wrote:
> mmap a VM_MIXEDMAP region whose ->huge_fault installs a PMD through
> vmf_insert_pfn_pmd() - mshv_vtl_low does this, and needs CAP_SYS_ADMIN to
> open - then
> 
> 	madvise(p, PMD_SIZE, MADV_PAGEOUT);
> 
> With a stand-in module for the driver:
> 
>   BUG: unable to handle page fault for address: fffff587c0000008
>   RIP: 0010:madvise_cold_or_pageout_pte_range+0x410/0x9b0
>    walk_pgd_range+0x52b/0xaf0
>    __walk_page_range+0x6a/0x1d0
>    walk_page_range_vma_unsafe+0x8e/0x120
>    madvise_pageout+0xb2/0x180
>    madvise_vma_behavior+0x46b/0xa90
>    do_madvise+0x108/0x190
>    __x64_sys_madvise+0x26/0x30
> 
> Nothing validates the pfn on the way in:
> 
>   can_madv_lru_vma()     rejects VM_PFNMAP, but not VM_MIXEDMAP
>   can_fault()            *pfn = vmf->pgoff & ~(mask >> PAGE_SHIFT);
>   vmf_insert_pfn_pmd()   no pfn_valid() check
>   pmd_folio()            pfn_to_page() -> unpopulated vmemmap
> 
> Even with a valid pfn the path is wrong.  The mapping carries no rmap, so
> folio_maybe_mapped_shared() sees mapcount 0, and the walker goes on to
> folio_deactivate(), or folio_isolate_lru() plus reclaim_pages(), against a
> folio this mapping does not own.
> 
> Use vm_normal_folio_pmd() and skip on NULL, as the PTE half of this same
> walker already does with vm_normal_folio().  The huge zero PMD is already
> handled further up by is_huge_zero_pmd().

The last part doesn't make sense, see below.

> 
> Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
> Cc: <stable@vger.kernel.org> # v6.19+
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/madvise.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index ffd6a68320a8..ab362bc482a5 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -393,7 +393,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  			goto huge_unlock;
>  		}
>  
> -		folio = pmd_folio(orig_pmd);
> +		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
> +		if (!folio)
> +			goto huge_unlock;
I think you can now drop the is_huge_zero_pmd() check, because
!vm_normal_folio_pmd() includes the huge zero folio.

-- 
Cheers,

David

