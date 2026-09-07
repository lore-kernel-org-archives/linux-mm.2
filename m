Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F15CC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207C86B00A3; Mon,  7 Sep 2026 09:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8616B00A4; Mon,  7 Sep 2026 09:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9006B00A5; Mon,  7 Sep 2026 09:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDAF76B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:44:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C1B0140190
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:44:28 +0000 (UTC)
X-FDA: 85187085816.26.D1D54B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8AD0920009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:44:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XsNGdcn0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788788666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AU/2q2RjFTQV8CKHYz9OqViFmABICgmL5+psZGMcbnw=;
	b=PRVV6o0RdGmkn9oFQPm6RiDRqwYUaJA195h+sSeVeu1wynKDoQPiJQmG1TjCttGIgBkA5P
	VzlDkU+g0xPZYZCsospzpTsmscIcQehs5yJvveQUTyBj9hCa+Dc9BG/WKVlwf+gglHBJYp
	Pr46x+KouzNrrCY85aJs3FY84bFnrHA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XsNGdcn0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788788666;
	b=a87VXYkdklnWpCNIBeh9jEYlNo3o2REscoNkc3l9pqOAMmY7ayNz0P1poNvoe6fOBjPa9n
	mKGNS61/JwKYx38cI7vCGo7x6x5b8PoNZqodOHosfmlBQgSa2x8U/ZpBtvDc6OsiICtNI2
	XDhfivODJvOpanxjkRAv7nYxbGqEns8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB972413D0;
	Mon,  7 Sep 2026 13:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE81C1F00A3A;
	Mon,  7 Sep 2026 13:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788788665;
	bh=AU/2q2RjFTQV8CKHYz9OqViFmABICgmL5+psZGMcbnw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XsNGdcn0HY+Fek1KKRl0zvn6EWQhXtA7Go4AUMmfM9ZQaxEMz5Z7/kHkKPtKLAVzW
	 1AMiW0AO6GXKxw/qhYAC+8sz6SimYNO6IAPh3ptu+48aG950tkn/yRGX35alaNbEi0
	 9FNDWYzBgyVVQc5xX9gfq07ci6aOt3ZJsRkFcLPFJJYsvL+qDhICiAAJghNgV3k2z+
	 UXR+O+dopOjzjD0qcRezwFtdE+aIFWQAY9raKgzakNPdjr/EcvhpXIsHM9wlngTJQ2
	 dMW797dtRdOw0nAeL78XNwFLTK7UbGiGxC/u+We6l8z8cwfGGUb6ltbikYEEO9UYHo
	 nWMIx9Vxmh8IQ==
Message-ID: <d35a4da9-aed6-4b25-8a6b-2ffaf5263009@kernel.org>
Date: Mon, 7 Sep 2026 15:44:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/gup_test: report actual pinned bytes
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260831101304.162867-1-sarthak.sharma@arm.com>
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
In-Reply-To: <20260831101304.162867-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jtcj8o5a8uhp1r1d6p177d56tnmbb9go
X-Rspamd-Queue-Id: 8AD0920009
X-HE-Tag: 1788788666-728401
X-HE-Meta: U2FsdGVkX198SAp1tMf110Hml3qUpGLD1OoD9sbUWeVMf2MD2JX9PKLPdV9/wfhTYL3QLgme22SPEJ/iC/c3FACqCQ/9vP9d+HN4rxUDXLxdt3h6/IVJIlt95YF3dcpKIh2s814sx43O5Yn65Jl95qkoV3RRWAgQRPR+9jnnaDJantWTdHzNoYX2WnBRUIBKNTGvDpG5a8XyJS99Cf2uynN5zyg5B3DVub1SmRpFgF3PMhJFoAiXuUCzSQOTc7qUn+Aa1LNndRpH/f13tMsvkX7J/uClvcNCq/mfIICnyNLb82yyB4Q+PIym6NB0PHN10WxCbiaCP+ki9eaIc01KOyReSb3wGBUfFZzt4jI8V1x2uVOpqjtR3UvXIRgE9c2zlKlT+z3tkGyOIDjSP0u46ccLp7SqI0DOWFy2lc+0VtuyltwQ1ZDaMQzJBN0JeaCm1I3s6AZc6Vy43h0Z1OU4N3i7ENbJA3l9hHV1LuJTAb7u1QuOs6ErCzXrMj0WJo9hsMLhLtzdlM5paL+ojUZ+ZKoz4RBdJj+MV623LFInq1pel1ntGRjtVEdw58T3mR1iX72zO6rayuAfGrGWqcWzx1JNPCby0b7hwSyF3pdDmT8nHrdF70bNYE2qhK7wpJnEX0VZ2Qb/t9IoslRPXB8gVw+rYLllkmFqR8Qyzfxo7OKB9u0uT6XwYA+72bfEiyW6i0e1n0GhPTeSSrowdMDfPezr9GbEe4CesspIx/KfNQ3lol04AF0Xa4q7N78gdICNKyE8cfdek+OIyWbKPWOIE0fNIFFHtWCw+f231o7iPAweUgwg98xxbUWnjKi5PNy6mWHMmeuMUj+siCgLVI1dyFIFg/xo7g/BJnhWja/8vbEb3vhnd0tVzwxkttkC0cc+It6VoZKYP3E2a6HZzEF4MBdWuj36/Cglmx0Qf9MG08xDgDxiRPGhl1CYsHipfni0YcQvusQ93BUYi7sJmL9
 vgJKM43+
 +L4pBH0wjtgUFTSjsL8Bd2QWMJszygpAkQqngpoYEgLssBul+K7ttiSpIl+SZfIlFIygbYYB9lU4WL0IQPsVXvkOaIEuBnX+LtfuMBsEYkedmAY/I4IXHDxqErQyWZJgFFJi8UJWA9UqFOwJlCL/9n1n+/XJDQig/uJJY+E6T9rLKrG7yEK2WzBGUK1rKt9eYeGRkB3hc2l7Iu06ds//pOlPiD4i0DMIl2mc0WD6xP+ZBjhanyvdI7RLGtMeWomt7cSU6LXT52PbtoNtVATK0zz90s+WEAJyLYk6oydMBaDbP/SjwKCQIwS9a9hbQKGL+2CT+VUp/X6ARVXGG+QlnM3CGh3LxodbbBkA5NCuF2vSJueUju64f6slfiG6UM5DR9Qgo4zdjkWhudFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 12:13, Sarthak Sharma wrote:
> __gup_test_ioctl() advances addr to the end of the current batch before
> checking if GUP pinned the entire requested batch. If GUP pins more than
> 0 pages but less than the requested batch size, addr still advances by
> the requested batch size.
> 
> The next iteration detects the partial pinning and breaks out of the loop.
> Again gup->size is calculated using addr - gup->addr, so it also includes
> the unpinned pages of the requested batch.
> 
> Calculate gup->size using the actual number of pages pinned multiplied
> by PAGE_SIZE.
> 
> Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
> Changes in v2:
> - Fix typo in the commit message
> 
> v1: lore.kernel.org/all/20260831064808.77768-1-sarthak.sharma@arm.com/
> 
>  mm/gup_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/gup_test.c b/mm/gup_test.c
> index 44c1cdfb9c37..185ba3bb8ed1 100644
> --- a/mm/gup_test.c
> +++ b/mm/gup_test.c
> @@ -188,7 +188,7 @@ static int __gup_test_ioctl(unsigned int cmd,
>  	nr_pages = i;
>  
>  	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
> -	gup->size = addr - gup->addr;
> +	gup->size = nr_pages * PAGE_SIZE;
>  
>  	/*
>  	 * Take an un-benchmark-timed moment to verify DMA pinned

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


I assume that loop handling could get cleaned up a bit.

-- 
Cheers,

David

