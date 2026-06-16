Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D149ECD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E236B0095; Tue, 16 Jun 2026 17:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57176B00C5; Tue, 16 Jun 2026 17:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BC76B00C7; Tue, 16 Jun 2026 17:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79AA56B0095
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:00:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9EB391C094A
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:51:54 +0000 (UTC)
X-FDA: 84885914148.20.0D0580D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E09994000D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:51:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e9vCwaSi;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781617912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwHACTTFql24JLhpRs/SKKJ5Pukn1cbDl1znL1oY7TQ=;
	b=7A2tA+oMgv+a2JlSkPqDB4pD9qI6LARgWsnO+eBOriwqi3YpbiyZzscSE8Ufb8wvNTNhX2
	zLnua9OoGaNn9vH5ahxLMAMmGzitIlp7GGye87wWCIZ0HNohexhayOxRvdUdtepQ358w/B
	FeWlwmRjLqorjz3Mp7vwo0aXCkTNMDw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e9vCwaSi;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781617912;
	b=S12hH4vXOHOtZTKGsXvjldqspec0GYBw9c4yfTnyGrLENUZe78G2H/wufoP/87N/REKn1K
	KI221lJn07pyHwlIMDkJIVme40JH8wDF5m7a4Ba+TQEzQ5YWjerNAMK/YabNeYAAZM/ucj
	By4E4ooS9eWYJlxrFQy8pzDxWT4+/Vg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75DD06012B;
	Tue, 16 Jun 2026 13:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D086A1F000E9;
	Tue, 16 Jun 2026 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781617910;
	bh=KwHACTTFql24JLhpRs/SKKJ5Pukn1cbDl1znL1oY7TQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e9vCwaSiLr1deDMrhdRjdvNsGwaxmDybQYV61mAAQYH2Iz4GKnnGi+/7PaC59EwzL
	 AOPmq+n2zRtdCNtxN1jdYqwkQUdItRe9rMiwWMAN6IdE6ola59I9f/OxltGVrLqT83
	 lgBHlT4qsazD2WG/oKqGBXUmda4LozIDkt2dHwVRQXA7bKuPvGovAqIbZBcfIgvSUf
	 HB3kuDMlB3S5bqUriaJ7aWH4RkAl1dNO4N4HeD4faoPUUpN1K13jzDfMGNhEI0vAOE
	 Tk9kSISPcQN8a6tcyAGwoWTvRmHu8KfGijPKNl+1oCBVbF9PhekIE2t4zc9ZbKDWb4
	 rMteAxo0hgjBA==
Message-ID: <c10553ba-aa03-48bb-985c-fd16197be851@kernel.org>
Date: Tue, 16 Jun 2026 15:51:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm/swapfile: Add batched version of
 folio_dup_swap
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-8-dev.jain@arm.com>
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
In-Reply-To: <20260526063635.61721-8-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E09994000D
X-Stat-Signature: 19s8w1rw5cdith1p3eok7i5yyjr64rm9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781617912-352050
X-HE-Meta: U2FsdGVkX18NwDwDh6fvD086tGUrWO9f7T4bogdLSUvDEedtRZt/XcYqQBk4WAb+LqNVS078LERyRwoSdTdXHWsldNiwsgbV6a63EyLvHjRRoRcM2C98EzYejjzd1WYAJLixJ2/3bf0WVDt5InLM/4EF5wR7HEyZc5BSK9xcVp6KEexYZzrASc/MaFiTIFQwRgBy0YxYiqpa7VRD5AhwnqYwovFjZfRkA8waCvRrWwnkcP1enJ3U1TG3R4fSNeVval/NhGuhOVd0vNOpfZK1RF+/oNvl5T71Wnxn2+sPdePJmeU+gleh+wy+MKD2e1TXkbw9DjMuBFU7ullR1fwoiIIq5zNEko0DotQ7k/booxNLGgys04Z87PIsQ/IJjtuq6Bs3xQqT+e9pr00t1zeElmndzAJbW1OvkS68fVxuO+fAyL5Qv8WkGfjvcOA5iuDZcptfjblSBxkoeCtriCf60uw2sF1dpC7JTVH9tLwU2/ahuuK0lwz3ikGvgkJKLVzhCxaeGxFQd3ZFQFwp4WXEMcLGXo0ayS9jt44jMU0AqU1Nytkk1LwRGdyV6tU9YG8SVflefGb1ql0Dkd2p6FD2BJ9zzgtNbsB0NbQ/4Os8zoTeocDlnPAaVG2ZyUj3SgP9CRj0iXuLa/T8hESH5nUbFua6edLj6yATGows96kDywdPEFs1u38iO+tvFJCLwRgGoXOry25l/V25jWtoQ6+TfSOCRn8LJZxHN9Dhe12wK+a5hrtydMerNKZM7muTQXDeRY7spoWVv7gCi/zcTKndKOMSNyDZ4IY/iGMvafxhzSxRmgpVS21jIE4Rfo0M1jHxMxRL7ZaOfbZ6Y/88OL/L+rjUrTMorGYX9MBi7cH38nlvjLTqKDAySqnpBvlp81Igv5eOVpnqFXLGFRdVMdhMkei/TfWi7M4bM/UN8cPNfb0dKlHNbXS+kU4INVrft7Xnfr79dPe3NNbYUL4M6wo
 Y8Ek+7hc
 pqKOrVob+H0NtDgoCeTIi4eYgyswGKFj1FSi6IpQTBukOHPiGovBWT89sz4qpbUu+woPm66cPC7BooETxLEvl0+3KWnTi8CA7GQKviyIFzv7IwiFA3U3YrO8Hal7PHNIqjNP4NrzCHtt/uNqI01Y1sDV7GAhM6XpuYsNLc3Qi1lIfZb/DER1L0kfPtiVLCyhPu7K/SMR8T3aSOtqkBJ+IykvP4xW9y5RpJWv6MvMl0UI9+rbzy3RrWiwPFRa4aXCyzwGzOWbiXtJtDny7GqjKh8FjpJXDCh5RaC1dyLlEcvZ4HINgk0b8HPsBDVFyMborwQETPL+D4QheyOYOV5V0XE1MC+mC9zwpiZT3EOLabGIzH6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
> that folio_dup_swap already can handle a subset of this: nr_pages == 1 and
> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
> 
> Currently we have a not-so-nice logic of passing in subpage == NULL if
> we mean to exercise the logic on the entire folio, and subpage != NULL if
> we want to exercise the logic on only that subpage. Remove this
> indirection: the caller invokes folio_dup_swap_pages() if it wants to
> operate on a range of pages in the folio (i.e nr_pages may be anything
> between 1 till folio_nr_pages()), and invokes folio_dup_swap() if it
> wants to operate on the entire folio.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c     |  2 +-
>  mm/shmem.c    |  2 +-
>  mm/swap.h     | 19 +++++++++++++++++--
>  mm/swapfile.c | 14 ++++++--------
>  4 files changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index ead031361bc61..3065d384cadf8 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2331,7 +2331,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  				goto finish_unmap;
>  			}
>  
> -			if (folio_dup_swap(folio, subpage) < 0) {
> +			if (folio_dup_swap_pages(folio, subpage, 1) < 0) {
>  				set_pte_at(mm, address, pvmw.pte, pteval);
>  				goto walk_abort;
>  			}
> diff --git a/mm/shmem.c b/mm/shmem.c
> index bab3529af23c5..5e4f521399847 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1698,7 +1698,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  			spin_unlock(&shmem_swaplist_lock);
>  		}
>  
> -		folio_dup_swap(folio, NULL);
> +		folio_dup_swap(folio);
>  		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
>  
>  		BUG_ON(folio_mapped(folio));
> diff --git a/mm/swap.h b/mm/swap.h
> index b57547c25ffc9..36c69b2788c77 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -206,7 +206,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
>   */
>  int folio_alloc_swap(struct folio *folio);
> -int folio_dup_swap(struct folio *folio, struct page *page);
> +int folio_dup_swap_pages(struct folio *folio, struct page *page,
> +			 unsigned long nr_pages);

Nit: \tab\tab

-- 
Cheers,

David

