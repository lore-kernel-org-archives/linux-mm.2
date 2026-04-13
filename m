Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BEFF531C9
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674486B00B0; Mon, 13 Apr 2026 15:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AE46B00B1; Mon, 13 Apr 2026 15:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587CE6B00B2; Mon, 13 Apr 2026 15:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3066B00B0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:12:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDCAD1396D6
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:12:02 +0000 (UTC)
X-FDA: 84654477684.26.977C2E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1F1F42000D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:12:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lN2KnZxk;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776107521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mFwsYgeV0j6bToLjRgaH326Ie8WJHBAAHs77SnHqnk=;
	b=IX8MTuqPNdRMwzQlJUPTq92Hx6OqeEoF9qWBRKsdX7G2QW0ECOxNoXWc5TmEhu6D8pqn8/
	TDdZp56qcUpafGEKti1V56SvjUA5qEXiYe4aROsKPz7YSpNBe8KOzAH2i/f70fTWfeMLfd
	6RSC4gpAs8FDHKQ12qNGKgTI2dAXf08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776107521; a=rsa-sha256;
	cv=none;
	b=60TCJqP6iOwsUvhm/xqhzL+B0fl5fX1XRTsKsOK189nckqToF1PCwgG10wjrxeEnl2Ctv0
	PR9c5JuW7reuSzCRZc28y0Tafipk47yicxQ5Rem2v7dejlLXrMpeJq6HIsjg1F4voOUUVb
	J6XhoMlCwCCzB6sfABbNYnevwPppNWA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lN2KnZxk;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CCA96183B;
	Mon, 13 Apr 2026 19:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE510C2BCAF;
	Mon, 13 Apr 2026 19:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776107520;
	bh=MxX8wt+PtDGl8J/2Seud1f/icOdBa7LsiBhLxw5jILY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lN2KnZxkDamOr6ulzzzsOtuWkA9vGRCPVx1F7hCKAlborqdv6Y7xznBREeJUgcwif
	 LfCfPa0d2oFzzrcr5dwMggI6fAmOxdMUL/B21wWunAD9fBqJJpu3xw4uGyvbfBfkxo
	 T+EoaympWixmlhFmF6R8v+zQfFavbTfsTcqf4SMRSsp82C7P9aL5tQSygcgP6gMg9f
	 2DuMDBo7RVVBNlzMnOr0u9YOieF5MWFWZxw5aBrttOe9dyY/pqfq3rSWn1df/I6eiC
	 zNWbe4m5zoZSZ0afgU3Emk1FffKHWsjQosY7C8iczzqPr2cHKw6ygl0MSNTapi6gFM
	 +m+h/e9LvGQ5w==
Message-ID: <b330143f-f3aa-4f4c-8467-d91102094e8d@kernel.org>
Date: Mon, 13 Apr 2026 21:11:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/9] mm: page_alloc: propagate PageReported flag
 across buddy splits
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
References: <cover.1776033471.git.mst@redhat.com>
 <a74ad3652d9bd68c78fbb5360fa7adfd0606689f.1776033771.git.mst@redhat.com>
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
In-Reply-To: <a74ad3652d9bd68c78fbb5360fa7adfd0606689f.1776033771.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: zqhbe5n8zuot87i4pi97prm7xobzfwkw
X-Rspamd-Queue-Id: 1F1F42000D
X-Rspam-User: 
X-HE-Tag: 1776107520-218498
X-HE-Meta: U2FsdGVkX18yt6TE8RJa6eA7BF3zE/Hh+bWKG8ouFgYl00bOe/GPEGIxWg6dRq4cDyv04x02vQIGGgN7UUQeNmoHQMAaW1JT2qLVnDa3FfrCwk32GNtA85rzsvPCK3bRJ0eKJqNJu9BjtDRPwHEn5s8CUqZi79meityQC+tCz8NsnevuyZ5YC0IEscaDUnxeeCNRvsg0TWD5fNS45g0ZKj0A9VFNk6lQlc60aZ8PH7MllyL4jI1FgdauMrJkUv9vIrJLNtmUIa+AUwBnw1ZMjd9cAuQoaX3+a1ZmIv9FahyxLQ4UaaiovWppQ5jRGP7Kbx2/DAjfFlJ/RG/PyIBdenvQ2OF5gNzF2FTK2EtcAgwvuBHeNAgrJxc3hHH+dV9n0Z++KGZqUI0ey32aI39fJuAYp3PeC0Qr6uppiuZCowWFi1nGrQ4chSOyLm1dHM7RUAFeYjvx6u/2Vju0clKPnOBCjnjQUi7Hc7jLCVkt5moEB4WaSw8grcpFRNjx0uciK7rB6v7EO3NfAXDtuTeROLBRLwoL1Z5lzP2OA71TXbqJKFZqrKd3CbrZza/qIfcXO4kYj9Wvxd+MV78Sv+ZtC+bzUYGTJzPJeGrBzsN5o5GJ0hpLCb8h8pAjeMvtjxlz7tUQnhDgBBssvdxoJ6QOuTlJU/0KqShdzZJK69IY1iCapAqKDpEBoFAQWuwcc2ejjE3Ct3iljbgdxv1FqQslEtahXEZDlfbyo9hYELGRxo8+lm55Av1Z0Y7iz051V3ESdEUUvTIcr9/T7QYHN9tAJ0+O4Dw5ZNRcP6B6SDHEfFGmD6w0MLgl7KfL14umbaJA9REoVD1ReFQoICTM7yL2d89mQVRZ8VseM8df9TMaheR7El65YqUmdLzhXGnRw6CoscksE3spmZjyEkCfNHc1q7X6dA79eCxPCxj4HCHfvbaarIcz+FcfIkLzmDLw/9w28I98bIWwApt+VY+8ULA
 pKg/cXaF
 zvm9P1aD3uyC98LSSVSw9PoxW0iJmKBPaitUfh1DX9sCw6b6Z8M+Kvz1Yl39qw6WU+0nSRd7AG99hAjW1O75uKJdG61f1zZjIl5o+gPyzlr+6OCQG1Owpu/gbaFbvb0h+ZAL/AqXwS8DcnHKeeC2V8Ismn15WoW19KnKBsrIErIadI5O5utngNfCM+fjonN0bHyjje/1W6z8NgqE0hZ3tS5Wff/bCD28VR/eneFTqmMNDrzRFUEhAWhTuYjBl9hEHczZ7KUfobbWD6HCnvOzQJc5YGtUJH8j5gfNmkaGNvUdIi1u0ow/5pDxiTeioj9W5fLV8djk5MN8tYxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 00:50, Michael S. Tsirkin wrote:
> When a reported free page is split via expand() to satisfy a
> smaller allocation, the sub-pages placed back on the free lists
> lose the PageReported flag.  This means they will be unnecessarily
> re-reported to the hypervisor in the next reporting cycle, wasting
> work.
> 
> Propagate the PageReported flag to sub-pages during expand() so
> that they are recognized as already-reported.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  mm/page_alloc.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..edbb1edf463d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1730,7 +1730,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
>   * -- nyc
>   */
>  static inline unsigned int expand(struct zone *zone, struct page *page, int low,
> -				  int high, int migratetype)
> +				  int high, int migratetype, bool reported)
>  {
>  	unsigned int size = 1 << high;
>  	unsigned int nr_added = 0;
> @@ -1752,6 +1752,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
>  		__add_to_free_list(&page[size], zone, high, migratetype, false);
>  		set_buddy_order(&page[size], high);
>  		nr_added += size;
> +
> +		/*
> +		 * The parent page has been reported to the host.  The
> +		 * sub-pages are part of the same reported block, so mark
> +		 * them reported too.  This avoids re-reporting pages that
> +		 * the host already knows about.
> +		 */

The comment is a bit excessive. I'd say you can drop it completely.

> +		if (reported)
> +			__SetPageReported(&page[size]);
>  	}
>  
>  	return nr_added;
> @@ -1762,9 +1771,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
>  						int high, int migratetype)
>  {
>  	int nr_pages = 1 << high;
> +	bool was_reported = page_reported(page);
>  
>  	__del_page_from_free_list(page, zone, high, migratetype);
> -	nr_pages -= expand(zone, page, low, high, migratetype);
> +	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
>  	account_freepages(zone, -nr_pages, migratetype);
>  }
>  
> @@ -2322,7 +2332,8 @@ try_to_claim_block(struct zone *zone, struct page *page,
>  
>  		del_page_from_free_list(page, zone, current_order, block_type);
>  		change_pageblock_range(page, current_order, start_type);
> -		nr_added = expand(zone, page, order, current_order, start_type);
> +		nr_added = expand(zone, page, order, current_order, start_type,
> +				  false);

In MM land we started doing

/* reported= */false


This raises a good question: how does buddy merging handle the reported
flag?

-- 
Cheers,

David

