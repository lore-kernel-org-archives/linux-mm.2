Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11BDBC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E26C6B0093; Wed, 16 Sep 2026 09:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2928F6B0095; Wed, 16 Sep 2026 09:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8A26B0096; Wed, 16 Sep 2026 09:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC5716B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:23:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C1891C2BA6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:23:20 +0000 (UTC)
X-FDA: 85219691760.11.2F0433C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A5BCB180009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:23:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyqfQ56R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789564998;
	b=poqs9HNGRhkgBAG0H0ej3mQjGEEMgwrpetKYyRtWJsXYQOJXjZh/Ih8Qlg1oE/4qrkML5a
	i3nOAIByHGRnhIuriqML9Fj9+bBY7mZYCF2ne4bOTR0Ah/ivLw1w3u+pRGoJ2IQINRNDHM
	zBih+z7eJoXrHpQ6ivQo1JiPqdEix0E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyqfQ56R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789564998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1n21esTWFIARb22DabL327mvFBcDYA8LulYh58X1JM=;
	b=MbxlRtauHCQMh9tXHIYc4fZGeJePkXUDV31yk1K4y4JxoV0J1yNWXWk4AnIN6G2CEkGsSU
	ZYJoN3DqWnP/q4lLamcnkpLzagZ118HBk0p3WAB/ldzDvywAtuZrevWXNdAxQDehNfs9O4
	63jRInM39ic6jkAsLe/mBkMdJvhKLtI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43984602CB;
	Wed, 16 Sep 2026 13:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2A01F000FF;
	Wed, 16 Sep 2026 13:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789564998;
	bh=t1n21esTWFIARb22DabL327mvFBcDYA8LulYh58X1JM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iyqfQ56RCSKneDh03pMqIw3w4xWZI6hlxEMUUXydQndV49m08vRmeRcTuK5Ef+WjO
	 o9QTFocyfQEIerKgrSC3l9RQGmjvcP7quw6zXK6TDxv+tr+tGyrXLlnRm8CHnm3ts+
	 tZvsitIFUR7yj7H2xjQR3atAhMD4MMwUeaYpSbFJr1tTo5hnQ/mJwAMDS0kIW9DA4Y
	 smXDfOHMOFBUa+BqOm7WKQrGUCUIWZb4o1HXfMHnzR4W/Arupulis00Ym4dCVjWJOG
	 sUb/pChJrOO216PGv0ZVv3oiEsr/qZPi8j5QkjKCq8XIJ2IYqoCb8aVDZiELS49uiE
	 TLZchf3Rqv8Xw==
Message-ID: <69a7987f-15fb-4793-81b6-cc436525224e@kernel.org>
Date: Wed, 16 Sep 2026 15:23:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 01/14] mm: Add read-write accessors for vm_page_prot
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-2-anshuman.khandual@arm.com>
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
In-Reply-To: <20260907035030.2839978-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A5BCB180009
X-Stat-Signature: 9xgxrxnogb8x78gfhhoz6tcs9karb7ze
X-HE-Tag: 1789564998-111392
X-HE-Meta: U2FsdGVkX18XihjqrLfK8/g0nOgdETgRui/4ClUawlLIZwMp+UOvC9exKNq6HI4B3o85IT9ZVcy3cD8fePxHahLbEWOBHKFXd9SOAzjGfdisBg8cAl/wsbqtOxScSYVu/DTEjm0YBkmf32xtCePZL/ZMSWSFCX9aGM5dCzYP2GmpZ9wm+B/y2MWi/qSUA+Q2Y2kRLI+iz2BPQlx/+bkXH8RX15KwUQqzUGqlro6+C3XInPN/K96i8JZXuPcogU+V1ATv+qLinbk3CCVecpqk9n0G81ewan55Tn3UqLbPqNASdIHcVVt9wO9bDMq4Ft6OMEjne2sfNbi2ksUJ9RlPbhMuxwEtzdIM0EyutH5jqdKoRgFh1MXbk3/57fggnG8ycBc3KdhnjnA1CpguAb45nmqDnrTbBAIZJpEty15OvDVwtk5JICvT3LUnZZ/B6SJBfj2bwRTLCHvCnl0SifY6ttIXiJmPXwmNFVTfbnjHtg97PiJDuVF3rfIIdsLC2RU6iM5jxmbf3ZM0il7cYMTNVN5bK+XQQBFhdUEj9i1wF19hA57Y+tm4ofTeMQDLthjdMIo7zaPmsePZjQ9l0FM1V8OY6DqTBH2XC3zwGsKuiOmP6IvMR43VHhsUxZUCtzjf38ZvAlCzN+KtuRt+fB/0ETP12PyMnlAGNsUoGj2aT/vmFdKocspMgMqVV1CMJFMN4NWHVOpkpk0XxiDfyUq217MVRDJQFgxDOJgpyENweKAmdmmMBYOmt/bCBmL57Q8L6GSNjPiBqP2Fw3Kj0BCQwXWcia9zRrJjFchQkR3aKqNsfkuVAMv3Zlq8I/Mmt7hfkyalEu2nDZ6zFW9fntmgPg6sZQcO7Xr1NEKUyo8rR2hENImlPxK6sFUGBlEIDvI4lIhGNFbl0PgTKejrEqIk2iQbPnABPgJAzxhJPsuZVcxCH6t5A9Y2keLZb8RpfqsLBgxghniBINOPqBIU5ub
 a+tTu1rb
 qNs+J1DvfD4aYmuWDJM0EaR2nbk4tSbVJzc8CchswDsC1nsP5rXlR7Uf1nH1EaChVA4H7v1dh9Fy4koX6rTARLq8uOFBEIJBESzBB7UMggYTAW0as5cRYHmyYVJjsnKJIqb9d2256s+7E6QG2m7HSR38xtdqpdkXT3Hw8YibofROuTALf5Iph2CsFMD5S6rbE406AKlBasjJFO20qYQuy+bHX/8T5dqpOtKJ30r4Q+yJkTM+txNGKeyjbUdcKZCWuiHvXd9au0I6+czggooVAVgli70jrKSpqKY/ceJjHTtYUpCeZ9SJ/B9A1xOnNN/RAp18VORm/c3uP7ZTI5ssIW3haDKFkMLd+5e0VMIr2YIHsMsJwD+eL44F/2GV/7XUwO0pnii3eXsxU+HIInpTCEc4HjJuVzRWxXjM7AMTwW6srj25E4+xajH/zGMX4p8OLOD9yn1QbvVOVIvPCXnFz+Q/5ReMDunRXSnojHjynMMpYh4waVa/o+yGu4mwp88EovvyATe/dnD6EPdvJiqOx7hCntA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 05:50, Anshuman Khandual wrote:
> Currently vma->vm_page_prot is safely read from and written to, without any
> locks with READ_ONCE() and WRITE_ONCE(). But with introduction of D128 page
> tables on arm64 platform, vm_page_prot grows to 128 bits which can't safely
> be handled with READ_ONCE() and WRITE_ONCE().
> 
> Add read and write accessors for vm_page_prot like pgprot_[read|write]()
> which any platform can override when required, although still defaulting as
> READ_ONCE() and WRITE_ONCE(), thus preserving the functionality for others.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  include/linux/pgtable.h | 14 ++++++++++++++
>  mm/huge_memory.c        |  4 ++--
>  mm/memory.c             |  2 +-
>  mm/migrate.c            |  2 +-
>  mm/mmap.c               |  2 +-
>  5 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index e3c8ab96941c..0df57a5c19ef 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -524,6 +524,20 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
>  }
>  #endif
>  
> +#ifndef pgprot_read
> +static inline pgprot_t pgprot_read(pgprot_t *prot)

Try passing "const pgprot_t *prot" instead.

[...]

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa..579152cce502 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -387,7 +387,7 @@ static bool remove_migration_pte(struct folio *folio,
>  
>  		folio_get(folio);
>  		new = folio_page(folio, idx);
> -		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
> +		pte = mk_pte(new, pgprot_read(&vma->vm_page_prot));
I do wonder whether a

ogprot_t vma_get_page_prot(const struct vm_area_struct *vma)

where we hide the pgprot access would be a good complement for vma_set_page_prot().

Just a thought.


> diff --git a/mm/mmap.c b/mm/mmap.c
> index 4bf26b0f1e6e..729bc244b317 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -89,7 +89,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
>  		vm_page_prot = vma_pgprot_modify(vm_page_prot, vma_flags);
>  	}
>  	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
> -	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
> +	pgprot_write(&vma->vm_page_prot, vm_page_prot);
>  }
>  
>  /*


-- 
Cheers,

David

