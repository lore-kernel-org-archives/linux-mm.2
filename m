Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E6F5F3381E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ADF06B0005; Tue, 17 Mar 2026 05:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F096B0088; Tue, 17 Mar 2026 05:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74DD86B0089; Tue, 17 Mar 2026 05:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6606B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:05:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E392EB9FE7
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:05:53 +0000 (UTC)
X-FDA: 84554972586.21.250FC27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1ED1220008
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:05:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kP7Ici7H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773738352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ew+xuRAmBQAMG19DlsKdHCE6NGseHlNGZHKCnhY1Qg=;
	b=0fN2PiObRVXcUPH+5DJO5nW9lV8kp6rA0OIlzjFSX2O3pVOcLDnMTeml5R/jWZQyaT/VcC
	P1U8y9RRcJr5jXNVFfx6ySJpQRIogjNmN5jXHbgIdMcmNOM/DFiqzQk/g/BwTUv9t4rVnv
	HvU04qUOSJAxCisL+f44/NOHAPsvSN8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kP7Ici7H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773738352; a=rsa-sha256;
	cv=none;
	b=HvukJbhbYQ6gU3bWlFLZFWrGdkDa5OkaNHagCqO9Ma0wXT7naQgDcQHPCmlXSwjHMaBAwh
	SHKw8Cf4KfqA+dhexhoKGYcn6fUV7dNNvkAYoBinPCvZjbf+TMNFDReR6vKs0c+UQWdKDI
	xKYWR0wno0jHOgOXLjhuXkp+QyfKi6A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23C814046F;
	Tue, 17 Mar 2026 09:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B205DC4CEF7;
	Tue, 17 Mar 2026 09:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773738351;
	bh=60NzU8YkM6iiNLUY0cDgOBqgulQyzYJR4ZpS5nAoKLU=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=kP7Ici7H+aJUMRHtWb2tkP2qGDmvHXShG1b9j1WI8PTdcx9aMtyPAKkb2GrjN/5P6
	 j03L8EMmu9j/B27o2ex70jUTnaYpdaZIPCWFdGKq7kQY/idsKz/pw9HaemsfpUFvpO
	 aTN3pvgA5OpqT1dPaWGBEPYESzG4Sy2lGEa/duzmMb7wNlKwRCDquZ18TEEwcE+/SF
	 6lGdBpYd3ygrdisYEAVHbZ1dJW8uVRf/2xhHh8jgAqRDB4x/kAIZBPdNgbhxkAzIz/
	 pzCSYaoQ5BYGeUL21N2eU3q7nBG5MdZoU4mYLRSm6C0ROHxO1p4LnMKW3VRUUwWtPr
	 wYToyZQhjLoVA==
Message-ID: <3c0578a9-ce1c-4d26-86d5-681cae4b8200@kernel.org>
Date: Tue, 17 Mar 2026 10:05:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH v5 2/6] mm: Add helper to convert HMM pfn to migrate pfn
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
 <20260211081301.2940672-3-mpenttil@redhat.com>
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
In-Reply-To: <20260211081301.2940672-3-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1ED1220008
X-Stat-Signature: twn71opi4nsrn49xzorhu1e77ywwco77
X-Rspam-User: 
X-HE-Tag: 1773738351-261851
X-HE-Meta: U2FsdGVkX19CWe4yI4IthaZ1bMSHMZDc2cesbALB4SSEXLjyOvwVI48/JgQdbfpl1/M45RKdYzirS5MiH0WQ3dBzAzID1VXjrPAjpdZQse1Gl55CqpNY6/29vcCRSJXLxepHBMcrmNuP48hGIl8DQRlNpsZl2ASv4BCuRfkKFyDRTUq34aU/BfSrAchnuoYHTvGjA3cjhGDR3B/SKwRmjCNCMX+zrA9M3537ql8+NgrSKC0lxguvk8ykYtSgKX4gONNueOvFPTYydl3sd5ranlOioSqDz4/KlDw1Tw2C6KWwkKkjOE0riJQUw8lPp+6xnlRB7Kti/dEWV0wopSDI4B/51Cuqi5lOcTFIHN/RHehEVzeZ9HHqzmMmpEgpXCD1tNqMkcDVInBqX/wgiMXN7RmPzx2AJG4HNmLi85hXvbresz/Q2jMVgkHoagK0FNQe/zM/58ilU4Li6nz+RZMsnd6XaXtt+KIy5vuShyvFLFhXgJf5789lPmOLIvU+hj3YAIpuG2TtBYZ4wZaHGhuOmIwJoCCKdXclJQJ70h5aTb4s083N3/z51f+J6S0G0Z6Hi9fqn5Epz9V5V+ewNwWuT59qUjZytKteN8fA2gwfVd5QjwiokEqBsHLokMUTicTPGDuixcuG5oNRc5QMndZjhSsa+HZBNq9ubnh4O5bz3gt87KvCwLTh/mHvs+SAmYKXZdxRQRLf1iQ5/sw/3IjyIvXDYiJ2phJQfEJNhaS5o2O8gG0vzshmTO/eeiumDeW47qn9OB5gmSman52nXUPZ/nw+ogGkwfBwkLC4GegwHm3b5ZldRdWTQbSJpy1vrtAjf+DJ0GQObIFPHJYG8YY0cM81DA/Ue9J9Q8ulrZ31TCu/+GjGKQuxZpT3EuiYgPXkY31cVmV+42vWyg+W/MPjhjdXpWLAcyJmy2xbyk7FdyXDeKMQRKGW4gHTJF0YpADJLpU3TJ0iExw1GXAnTdU
 f4NiKQbb
 FkSZDjW6GAOBEw0L0gLO6ib9+FJipNE0fpRsDhQ7ohTQeq0YpQEdNZYblFJIlCtAKQiW1yh1Wk5lDogGXgYeHa2TqzLQfeLKyH1AChUSYPPwRGqjZ5RyBc6q/xl8nBIWm4LUpHRyaeFZ/m67De/Efy42Q1iYuvJr1+DVLrKqpB/R6BGRvSD9geRu+w63E/dT9xIlfwyvNbMCzD6Qta9Tz1UyJ2JIrnerCQt+n5mqyQH72RXum8PiDTMjg+AhwccbNC38rvjhoHPHxsP1U1Pa+SS7La9mWGs0BcBVtqtUIL9AJVgkiTQiox2K7ldG1mqtdb0P6EhFWbGKN0brn5/L6xJtkuRyGXyTR7ScHafDRqbSDxSfqPLK9d0VlYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 09:12, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> The unified HMM/migrate_device pagewalk does the "collecting"
> in HMM side, so need a helper to transfer pfns to migrate_vma

s/in/on the/ ?

"so we" ?

"to the" ?

> world.
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> ---
>  include/linux/hmm.h     | 18 +++++++++--
>  include/linux/migrate.h |  3 +-
>  mm/hmm.c                |  6 ----
>  mm/migrate_device.c     | 69 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 87 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
> index db75ffc949a7..b5418e318782 100644
> --- a/include/linux/hmm.h
> +++ b/include/linux/hmm.h
> @@ -12,7 +12,7 @@
>  #include <linux/mm.h>
>  
>  struct mmu_interval_notifier;
> -
> +struct migrate_vma;

Keep the empty line, please.

>  /*
>   * On output:
>   * 0             - The page is faultable and a future call with 
> @@ -27,6 +27,7 @@ struct mmu_interval_notifier;
>   * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
>   * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
>   *                      to mark that page is already DMA mapped
> + * HMM_PFN_MIGRATE    - Migrate PTE installed

I have no idea what exactly that means. Can we a bit clearer?
Especially, what does it mean when this is set alongside HMM_PFN_VALID? What if it
is not set alongside HMM_PFN_VALID.


Shouldn't we document what HMM_PFN_COMPOUND and HMM_PFN_MIGRATE mean as well somewhere?

>   *
>   * On input:
>   * 0                 - Return the current state of the page, do not fault it.
> @@ -34,6 +35,7 @@ struct mmu_interval_notifier;
>   *                     will fail
>   * HMM_PFN_REQ_WRITE - The output must have HMM_PFN_WRITE or hmm_range_fault()
>   *                     will fail. Must be combined with HMM_PFN_REQ_FAULT.
> + * HMM_PFN_REQ_MIGRATE - For default_flags, request to migrate to device
>   */
>  enum hmm_pfn_flags {
>  	/* Output fields and flags */
> @@ -48,15 +50,25 @@ enum hmm_pfn_flags {
>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
>  
> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
> +	/* Migrate request */
> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
> +	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
>  
>  	/* Input flags */
>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
>  
>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
>  };
>  
> +enum {
> +	/* These flags are carried from input-to-output */
> +	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
> +		HMM_PFN_P2PDMA_BUS,
> +};

Why is that an anonymous enum with a single value? Ah, you are moving
that. This should be spelled out in the patch description (and why you
are doing it).

Is there any reason we can't move that into hmm_pfn_flags?

> +
>  /*
>   * hmm_pfn_to_page() - return struct page pointed to by a device entry
>   *
> @@ -107,6 +119,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
>   * @dev_private_owner: owner of device private pages
> + * @migrate: structure for migrating the associated vma

Is it really for "migrating a vma"? I assume it's for migrating a range
of a VMA.

>   */
>  struct hmm_range {
>  	struct mmu_interval_notifier *notifier;
> @@ -117,6 +130,7 @@ struct hmm_range {
>  	unsigned long		default_flags;
>  	unsigned long		pfn_flags_mask;
>  	void			*dev_private_owner;
> +	struct migrate_vma      *migrate;
>  };
>  
>  /*
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 26ca00c325d9..8e6c28efd4f8 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_MIGRATE_H
>  
>  #include <linux/mm.h>
> +#include <linux/hmm.h>
>  #include <linux/mempolicy.h>
>  #include <linux/migrate_mode.h>
>  #include <linux/hugetlb.h>
> @@ -192,7 +193,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
>  			unsigned long npages);
>  void migrate_device_finalize(unsigned long *src_pfns,
>  			unsigned long *dst_pfns, unsigned long npages);
> -
> +void migrate_hmm_range_setup(struct hmm_range *range);
>  #endif /* CONFIG_MIGRATION */
>  
>  #endif /* _LINUX_MIGRATE_H */
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 4ec74c18bef6..21ff99379836 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -41,12 +41,6 @@ enum {
>  	HMM_NEED_ALL_BITS = HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT,
>  };
>  
> -enum {
> -	/* These flags are carried from input-to-output */
> -	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
> -			      HMM_PFN_P2PDMA_BUS,
> -};
> -
>  static int hmm_pfns_fill(unsigned long addr, unsigned long end,
>  			 struct hmm_range *range, unsigned long cpu_flags)
>  {
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 23379663b1e1..c773a82ea1ed 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1489,3 +1489,72 @@ int migrate_device_coherent_folio(struct folio *folio)
>  		return 0;
>  	return -EBUSY;
>  }
> +
> +/**
> + * migrate_hmm_range_setup() - prepare to migrate a range of memory
> + * @range: contains pointer to migrate_vma to be populated

"pointer to hmm_range to be migrated" ?

Why can't we just pass the migrate_vma? Or is there another use case for
adding the migrate_vma to hmm_range?

> + *
> + * When collecting happens by hmm_range_fault(), this populates
> + * the migrate->src[] and migrate->dst[] using range->hmm_pfns[].
> + * Also, migrate->cpages and migrate->npages get initialized.

Can you please document what exactly this function does with
the magical HMM_PFN_VALID | HMM_PFN_MIGRATE, and why it skips
everything else?

What is the caller supposed to setup?

I am getting the feeling that this is severely under-documented :)

> + */
> +void migrate_hmm_range_setup(struct hmm_range *range)
> +{
> +
> +	struct migrate_vma *migrate = range->migrate;
> +
> +	if (!migrate)
> +		return;
> +
> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
> +	migrate->cpages = 0;
> +
> +	for (unsigned long i = 0; i < migrate->npages; i++) {
> +
> +		unsigned long pfn = range->hmm_pfns[i];
> +
> +		pfn &= ~HMM_PFN_INOUT_FLAGS;
> +
> +		/*
> +		 *

Please don't add unnecessary empty comment lines above/below the text.

> +		 *  Don't do migration if valid and migrate flags are not both set.
> +		 *
> +		 */


/*
 * There is nothing to migrate if the entry is not valid
 * migration entry.
 */

Which raises the question:

When would HMM_PFN_MIGRATE be set without HMM_PFN_VALID

> +		if ((pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) !=
> +		    (HMM_PFN_VALID | HMM_PFN_MIGRATE)) {
> +			migrate->src[i] = 0;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +
> +		migrate->cpages++;
> +
> +		/*
> +		 *
> +		 * The zero page is encoded in a special way, valid and migrate is
> +		 * set, and pfn part is zero. Encode specially for migrate also.
> +		 *
> +		 */
> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE)) {


I think you can simplify all that by doing a

if (pfn & ~(HMM_PFN_VALID|HMM_PFN_COMPOUND|HMM_PFN_MIGRATE))
	migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)));
else
	migrate->src[i] = 0;

migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
migrate->dst[i] = 0;


And I wonder whether you could replace the (HMM_PFN_VALID|HMM_PFN_COMPOUND|HMM_PFN_MIGRATE)
by HMM_PFN_FLAGS, to only check for non-zero PFNs?


-- 
Cheers,

David


