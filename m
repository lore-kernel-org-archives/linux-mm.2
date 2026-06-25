Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 931FFCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 875336B00B9; Thu, 25 Jun 2026 02:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C616B00BA; Thu, 25 Jun 2026 02:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73BDA6B00BB; Thu, 25 Jun 2026 02:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 504556B00B9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:46:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0278405FC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:46:15 +0000 (UTC)
X-FDA: 84917500710.24.6B03808
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0E39120009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:46:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iV4Ydx7Z;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782369974;
	b=kXd/mPe1huZs9n3gM7t9VQKqCUeaIDJf8PaqUgNGCWkU75iS+2dmbAEbvqILdbA5rH3UHJ
	d7Vj326ihJp9UNbTviP60hzhj5qapGUiWvg3Vt4yy268WFpBB5Ou3POtpgm9od1uU4amXJ
	bPzQsH8BInXuAVTjRhOxcZwJN7i9qGk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782369974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9q6EIQf7iznyig2evji5XbOB/64u93bLawrJvslC1Vs=;
	b=WJ8L+xY5J3xUyEwZ4M5v1uaIxOl/a/EF25p+iXCcEErCdIzUZHpBNzfbB08w7MXouJ7MOb
	1QyMVkd54w9oBfyCXhmgV7VC4P4aZbJg0uuHRSrJVnZwwfa75n3iS8oRmn9pyug4BB3+f0
	/YR3q+Vnw5haAF4kTAxSSJgvN2ZbYKk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iV4Ydx7Z;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D35F42AEC;
	Thu, 25 Jun 2026 06:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDE11F000E9;
	Thu, 25 Jun 2026 06:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782369973;
	bh=9q6EIQf7iznyig2evji5XbOB/64u93bLawrJvslC1Vs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iV4Ydx7ZGplsvRZlB2I9+aX0jI+3RmZTKd1altCskoLzMtZ+2eHTYUXd/9Mjmb8QM
	 pUjgH1oS+Ap2v69p1vE0rCyy3/ldMWscLbGB4h979v5oYH32xNehrRkOu4nn+js10/
	 FuUOz4Qx4MR0BdiQ+sOeV5RGXmSYJtSvsnkd9H0oAm1i6kJN6XzbftmFGB9X8WQPi9
	 HAN+Ll2UyhSqmwyekSbg6JsuvN1ILBVdY8NHzzeTA+5CrX3h3A4cIiRiaFhM4JjAXN
	 +F76gVJZkXdz632qWRQ1qgYKyT7+ZW4kYy0do5vzKHr4w6/nj/fvoNEXEme7g65wja
	 TETOPSmW3C+jw==
Message-ID: <bfd598cd-60cc-4060-abd8-6865519e6524@kernel.org>
Date: Thu, 25 Jun 2026 08:46:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260625053958.918738-1-hui.zhu@linux.dev>
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
In-Reply-To: <20260625053958.918738-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E39120009
X-Rspam-User: 
X-Stat-Signature: szihbfdfimd3hhbs8y8xo3wagszweb1i
X-HE-Tag: 1782369973-281421
X-HE-Meta: U2FsdGVkX1+hSNVg+WMvw5zgOkvHcTmKtsYiD+7ayTkGEgGhWUpNqmC/F5irrmFquTqvGro8Uvmc4FjUPN4ETeqvxGUPs5yDUYcJTlxArSn+UMhOLd+H5bAt/CCvNN1Cn7W1o/AH+Uvruu+DBPQlYk9uBjuuNNCT3E4j9g4SJuTdcTxelkqanxFxIKy617ZzpGuyDuuQySbvKVhHvam66zWyeF9gOGmCY7nCn1seNKDpwY7SNZIgrBLFfllWMuxQuEXYIWK60jlJS/cs4mKeerTjhJRlCjR79SvY4XnD0n5XuYUAD4V/wuGjiqXCXVPwsMHnQl84OrSDTawsr5kAswhtks6DwMNOs4JuTuGyRbiWzjoWvW0TCL6AFbUceaBNX0O8RsODjUhCFL+FdODhzZl5w1vgDY6bWo+iB7oLTvkpzvM8soBqu0GQ9y+datqOy/rSLamSYTO/ZcELWwrtNdrZsbiSiA56S7f1uhN+BueV++eiANNbqyCbvRCQA21rup4dY7q1OT+FkPtR30BG29oBJwCm+4TCmHC5SpCze4zv7/kGbEGs4/sM13gIjoC+VtQCaCNBN2ejS6SPTJ1rAHvDsTIBigqtth7lGC50vNVPxMA69mtvb4pPrk/8D9xNRn56odqt0soeWra2sNJCAczo/xwFEBMTXx89ovcM6AAJa1FDGG+agrseqp5+qGa15hhBE4tPWhbRjMHc1+9R8Zbcv5AFUResQgCVLEQCls63yj0GWVz/ff2KaGNrH9u8aJXrtUUjl9uHKPfUCnSYq/vNys3coRhdOXbSDk1WJRtjAuPyQMgrquisWNs84iSnc0UrPl1YrRv2NFm2zohrvxZovOSmTtZ+xh8fEjhujF+6ZAmvp83UqCE9BjLx3BtVE15QQUvoXPm20JT4RtjE2tU+IBpn0bIm015ru1f8HCSaPYoUjY52ovZQ27IwdFaIB/81J7rDHbTY9bBhyby
 ODTxj7PY
 bCZP16hWAoEZ+rgSqzHZrAPrGRhWgqiRlosUKcGEXdeHkxcZKQrRJ1l2/fZcS9Xl1kTQh97fLRXgAkdPMFYf9NdOaI/4EFW5JrAwGvf9lXZfPKOBpCMCbgC1cJcs7c/KLhRBwGIKIh5VplbPxF4UGbLjzBYnbGgqH8f0ENkysYR1VGsbckTWD8VeLvrbzs1aC4dvTHj8qy3xcxP+RKJwceRjLTVOnBUJhTbgDx/oAmPI9TzVon7AIvEr+onSvnZQgseqt0i/n0M4a21M0rJXXY0L1L0XUs813c0CtInO5ZCA6h3iZ9Sy+FAzTWfl0NZhssdSeoTaEOOK4W34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 07:39, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
> page->flags and folio_trylock()/folio_lock() concurrently doing
> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> 
>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> 
> The node id and zone id occupy fixed bit-ranges of page->flags that
> are set once at page init and never modified afterwards, so they can
> never overlap with the low PG_locked/PG_waiters bits touched by the
> folio lock path.
> 
> ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
> checks a by-value copy of the flags word, not the actual shared
> page->flags/folio->flags being modified concurrently, so it doesn't
> reliably assert anything about the real race.

Is that the case? I thought the existing ASSERT_EXCLUSIVE_BITS() reliably worked
before?

Maybe the compiler optimizing out a local copy sorted that for us.

> Move the assertion to
> page_to_nid(), folio_nid(), page_zonenum() and folio_zonenum(), where
> flags is dereferenced directly from the page/folio.
> 
> On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
> folded to a constant, so page->flags/folio->flags was never actually
> read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
> folded away, so doing it unconditionally would add a pointless read
> of page->flags/folio->flags and a check that can never fire. Keep
> page_to_nid()/folio_nid() as plain "return 0" static inline stubs
> under CONFIG_NUMA=n instead.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changelog:
> v4:
> According to the comments of Andrew and Sashiko, set
> page_to_nid()/folio_nid() as static inline stubs returning 0
> under CONFIG_NUMA=n.
> v3:
> According to the comments of Andrew and Sashiko, move
> ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
> into the page/folio call sites.
> v2:
> According to the comments of David, remove useless comments and use
> ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
> page_to_nid().
> 
>  include/linux/mm.h     | 9 +++++++++
>  include/linux/mmzone.h | 3 ++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..56b39194605a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2294,15 +2294,24 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
>  }
>  #endif
>  
> +#ifdef CONFIG_NUMA
>  static inline int page_to_nid(const struct page *page)
>  {
> +	ASSERT_EXCLUSIVE_BITS(PF_POISONED_CHECK(page)->flags,
> +			      NODES_MASK << NODES_PGSHIFT);

Performing the PF_POISONED_CHECK() twice is a bit odd. One time is sufficient,
maybe simply before both statements separately?

>  	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
>  }
>  
>  static inline int folio_nid(const struct folio *folio)
>  {
> +	ASSERT_EXCLUSIVE_BITS(folio->flags,
> +			      NODES_MASK << NODES_PGSHIFT);
>  	return memdesc_nid(folio->flags);
>  }
> +#else
> +#define page_to_nid(page) (0)
> +#define folio_nid(folio) (0)
> +#endif
>  

LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

