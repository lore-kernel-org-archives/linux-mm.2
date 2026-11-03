Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC5D606D82E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GcEj3cmz
Received: by kanga.kvack.org (Postfix)
	id 44FFF6B05BB; Tue,  3 Nov 2026 11:25:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427766B05BD; Tue,  3 Nov 2026 11:25:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D716B05C6; Tue,  3 Nov 2026 11:25:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3966B05BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:25:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99D6512047E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:14 +0000 (UTC)
X-FDA: 85394332548.05.6D2FE9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C495D160003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GcEj3cmz;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793723112;
	b=mwOnHb2CwMz3oNYb1gmtMpWBaJn6TL75SEYQvrKW+XNjudNCNF7ZPiS29msOikM2oAwXCQ
	RMAwmTmftQXB8rVd923XYQW81tqmvfspsmPkExqWWwqDgIqsh7XX7z934h9ZMhYN97BD3d
	AqfY5c5MBoTcrPKxqTx8Pkab/VFYRr0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GcEj3cmz;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tE53mJP8e3yfIaR1ey1Z14MPWDz6kEM9Vpvw5x6rx3k=;
	b=DCT4Ywh033xCNul5kzDOs+5TkJJi/ZZ74TewcP4TT2/7PT/b5YhCgZXEZ8zFOpYeT/zYcu
	T5aUqu2DEBJATuN/9NMNhmnLRh0NLMbOmtvikh1D9Grx4qmG3kn+NP8TPPKafYfRNs/G8J
	9cgc5DsHticbPreqtz9kohz2UHOYjFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 117344063B;
	Tue,  3 Nov 2026 16:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07211F00A1F;
	Tue,  3 Nov 2026 16:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723111;
	bh=tE53mJP8e3yfIaR1ey1Z14MPWDz6kEM9Vpvw5x6rx3k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GcEj3cmzbXb4U0frxQu4gW6/ltlFA+NJX84JBJ56sTJFIKecsTS04Kgx0ZKPBUZEy
	 P0KkCxb7o4I4e2ZDg43ql/WmLE7Vb9VxnNRbsZFsrP0ziQGASDxnmUh5FF6JKJpgqM
	 asrvNRTZCB5JVWYvbbwKMeV2QP136PSX2fVGr6dtcd2cNcU8sQLiiA4N4DeAuiwF2R
	 k7MMr7ljY3pxrCdEPvDNaKIBQlv7WMbR4cj7G9/TSb0zCxH33+k845Op6TJznd48b2
	 pnnFf4rq82AlNvgT5QqCW8irdLfmDmFaC4oeCR7ajudbPnvWrJn9u40t33EdMd5mcK
	 6VYM4og4+0sVA==
Message-ID: <ae8f4805-70ee-427a-b288-da2e95b24e3c@kernel.org>
Date: Tue, 3 Nov 2026 17:25:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: uffd-wp-mremap: keep the THP sizes in
 unsigned long
To: Sasha Levin <sashal@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261103150232.291827-1-sashal@kernel.org>
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
In-Reply-To: <20261103150232.291827-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8rw8ohd5k9c4ywc97tau8oymgejs4yxz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C495D160003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793723112-158878
X-HE-Meta: U2FsdGVkX1+DdUySZlG+JBugiL/1ao79rqiWcCDztrro6HLmA2QWbuYvgXka+MBR+R9riGH2TeT1ZlJ5rWy8nHG8XLg/Q6JSDy0SW16JWQf7ZIZwjryZfhjkF31B1erukyF+H0hCvAsjSaD9p6vWvIzUFEzAY9okNRS/8qMNgiU25AxXWQ2VeduI+Ockv8Ipj+xtGgIyzI5Zcmc4UmuegrvS/moP845mKyRcj7y73YLlUl0rbZ4lbdGtQmcesPel3uuncIdQFpwp7sE7ji3vzTj5GbdjO5o7+Fcr5XZXuNTGmCeMlugF7jAhJHX6+mBV5qdve7SMUIxqEph6I+7vIfJHX9HrYj/5/HZ9RyLJ5rkuwiTzdk3hQqaB9R6XzBgW2DHNQdTsuHfcdBK5LRmo1U+8XTGUW6dl8SFXKASay45WJE0iWwBRB3Rw7xKc4p2HE6scOlCiFuCj2LM6lMATxvk6msf/QYxiWNKM+tFbBCRf+H0//GVl1sXoAdaN1GLX9vC/NWjITMaV1o77ojttncrmvSDmIKAXGQ02ScOCc1sp2sYMjGLz2p/XTJZ3lXIkboEF5MJROwNnMSgmWsLeE3D8k+7aX2XCxkxOSMZEK1sgURimAzkx6RrHyZIIOrNbfa9ZefnqX/hhpI3qWzIWEHJ5p/Tp3/77lkG/wnbE+pUe1MedGwo+9AfyRUb3K3sFHSFDcSZbWuS8Qx0WY+WdcidzCZdZb7QmcsFVQ6LG9wj7BwEdgKjn6nD3QomBMXRqVJtu79O5tz6Be+9d/ej32pfln9jl3Ak3/B0CVTcfpE3SIx90JgGtkfgbG/EOkyFEKu39bjrnt24adl8MFo86jfiXH5Y08biI9qvFLH7QhR5TKJXkiBmps16NQVuWwf4b/G/hqY4Hs43wAvzCjh8+mrevjNTJxrVbgBteaUJuJw0BbpajtXYTPouzwBuHPIp8ysQzFALl9vle6zyqy1p
 1GXxDE8R
 V/FQUr1/sQvTeeK0a/qnWiXJEigxjJjn+ehNzYq3RqO6CHDVGUinQ/xZO5S5qR43/URMdaMQmVu73foXItvp8zL0PXddtNjxFPL0ciSqadRSU3TTj1MEc25IYpOAvDX5og1c/xMku7ZoR3uNIcCF3oL9DDmZcgVixC+y3J27AHNhI4Lg9JMo+MVw6zSekrSqk+Kqensl6oC2q0p7nJzMgQ/A/rB13hzsKjBQf3stxFp+Qsmh5LMSHsIBzqnlU7/qdV0g62ufpE8Xr1Z/KyNKxQ2kX9RRGnyyGvP+C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 16:02, Sasha Levin wrote:
> Commit 0020a1f5ca36 ("selftests/mm: hugepage_settings: use unsigned long
> in detect_hugetlb_page_size") changed the sizes of the test cases to
> unsigned long, but left thpsizes and detect_thp_sizes() with size_t. On
> 32-bit architectures size_t is unsigned int, and gcc 14 rejects the test
> cases that point at thpsizes:
> 
>   uffd-wp-mremap.c:299:26: error: initialization of 'long unsigned int *' from incompatible pointer type 'size_t *' {aka 'unsigned int *'} [-Wincompatible-pointer-types]
> 
> Use unsigned long for the THP sizes as well.
> 
> Fixes: 0020a1f5ca36 ("selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> KernelCI's 32-bit arm kselftest builds hit this. Built the mm selftests
> with gcc 14 and gcc 16 -m32 (four errors in this file before, none
> after) and natively with gcc and clang (no change). An i386 build with
> clang runs and detects the THP sizes as before, up to the point where
> the test needs root.
> 
>  tools/testing/selftests/mm/uffd-wp-mremap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
> index c48eaab8e75cf..fb5582ec5b201 100644
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c
> +++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -15,7 +15,7 @@ static int pagemap_fd;
>  static int nr_pagesizes = 1;
>  static unsigned long pagesize;
>  static int nr_thpsizes;
> -static size_t thpsizes[20];
> +static unsigned long thpsizes[20];
>  static int nr_hugetlbsizes;
>  static unsigned long hugetlbsizes[10];
>  
> @@ -30,7 +30,7 @@ static void check_uffd_wp_feature_supported(void)
>  		ksft_exit_skip("uffd-wp feature not supported\n");
>  }
>  
> -static int detect_thp_sizes(size_t sizes[], int max)
> +static int detect_thp_sizes(unsigned long sizes[], int max)
>  {
>  	int count = 0;
>  	unsigned long orders;

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

