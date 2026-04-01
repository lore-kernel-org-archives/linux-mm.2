Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 018A3107637E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422026B0005; Wed,  1 Apr 2026 10:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3166B008C; Wed,  1 Apr 2026 10:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2156B0092; Wed,  1 Apr 2026 10:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8A16B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:11:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C22F91608BE
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:11:00 +0000 (UTC)
X-FDA: 84610173480.13.770B102
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CEE01A0006
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:10:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EVtkVC0K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775052659; a=rsa-sha256;
	cv=none;
	b=y9SvmK1uGFf0m/XyowExyfA/xlhGsMLzIGDEzcd2+XAJSSrDT3LdwpeNKpYmGhUO1Goxgz
	rG91uMmnQZ2uIJLC4ifoLl3nJ2iofeR6euKBxuYroWgvYAJ/6PGJMSBfOmx9Y3WMDuLxKN
	c3CPlfSjzb3dwlg7vveZvOzs4uT3I1Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EVtkVC0K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775052659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihs7ql9+V7i2jsV+Fz+TOoJH9NgFzocVSWGjd1tnnG8=;
	b=sURzq+IX0TW3OfcpU1HnRJNjAZxkdSzq62cb3ZH+nsfdip61bxtHKYaEV99CyrDObgOoqT
	Cd+g1x+94O3Z3OJQFfFXVsXpOpQ8pMhhyrucgK1H5g3HaOw93q/k0bqFi84IictAFVLvQc
	nhKB6e0YTuyLSBquHrqNBEJZNNsyJ4Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B91324089F;
	Wed,  1 Apr 2026 14:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA854C19421;
	Wed,  1 Apr 2026 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775052657;
	bh=y9AZ3kPGoHublxbM40WNj5WyT0fJ5pu6ZSBg2xxPUXM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EVtkVC0K0I6FJox73TKW/Bx7q/dEY4tNpkzJoZqc9VoM5MX9GOTFVnOQ9eqLz7fTt
	 xHfpZyN+DdIdzs6aSCnUdS1E1rzPqX9K0cGIS2P/lcAtjkq/xMbunYz4Wt8JJwHoAK
	 Pq9g8E9qiPs5uVsSD6ZO1tsAcA39t6bDwU69m5irmlIpXRpIXKk1z+OcMIybSlMQdy
	 s9QC1w3DFHiUJ0kgQbcJwM/7C6S6H4fVS0ehb8yhaACrRMOK7AQo5m4DksLS1tjxGD
	 2M4hyTLZUbmibYBR4DjVRPy/3ENNUFj0yHk5v+FJL+XF9SSCdboUk5MuMJp4Y1fen2
	 zDQyJktu+qzLw==
Message-ID: <4e859cfa-db79-4676-9509-81a2140db3f3@kernel.org>
Date: Wed, 1 Apr 2026 16:10:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/13] selftest/mm: adjust hugepage-mremap test size
 for large huge pages
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <fd252496169a91c80e339910978f21c3f4aac9f7.1774591179.git.sayalip@linux.ibm.com>
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
In-Reply-To: <fd252496169a91c80e339910978f21c3f4aac9f7.1774591179.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CEE01A0006
X-Stat-Signature: 5rqmagcg58fa8cj3podits6mzywms6q9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775052658-943137
X-HE-Meta: U2FsdGVkX1+S5hd49z43MKOAXZVP4a+5PMtMCFIJBYbc++WpTQ7+MrzL665gXIxbGauNvSaGYmzlIMxGoE0r55DpUQ+iADFGf9HXyAXBeoosGAIV28RbnLKorQ519wqhWFgOClMISdkcnEKGBjkbmXmDmAYDvY7dctC7c3/tkOQPDpCJ9Abzcpyv/Wo81rRbfH66Mp+8Bo238CUohOOEVS5nl8Tr1/neU/27YnoMyjJjgfyJXgYjMKjyoaiqCKqrFvPmisMusnxP57mPJoZPA6bnzhNl0EPb51mJ+ChGknsoOBFpyG+mnM3ljpRQLtpq2Z6tx0OsS5LAV/eedsvFQCW/VoN0p2m9+3p5XmrF8xYYXIP6tDkX44je1M9GopFtsEj9f3ue/c4WRYolUu1N/hHJJMcKSlcNqnXzuzXXC8ns3uTgszUKOZQ6wWds/v+c2QskvfUNHzP6oSMO2tUh5S/pyCkEnfZUXwqBq1ajYdKZmTc6iZf3eMHVYPP2CWHbEtAcg7spcg85N6ngTn9Wz/HFkNOFe4tRFhE7wbghPOkFklOvFrMr86qU2kK2ROSYZ1/yXg+OR8qYeTvUdIJksPssIEnsjCyGCkaArDjN5xjoJRjs2oC/Faqp1S2QKVHaFYzwHjRNiG5OaR55K6pCIPgzuTHMrs4DAYMFyRpmvFQa9gWoH4Yp3FRHSLTiNZyspyndr6lgJTOpCTKfdpRtaLPvuBgxRaO4Jm7Q8/iwRHQ3ho3gvNwQG0bzK4LihNAr62Gn4Dpc6PPnGxUrsiMrvL0xtqp7pfyg2saiNLqQBkO8ppLLnxWIU+GSU2Juxi49vCXSkcXKLoAv9ALUw2lKn6d/ev39nrFINa0+CQDRe5rVEAqf+CwBc/GmP6Sc3+EHkJX3USEMJ6GYNg982zpmCJXpIPfGtN8jME8p3uIsc5Hy1q461D2j+3AWdpCCrQzAH2ih4wNOGOKv2q4egp0
 imhXrIei
 cTpzBohbybWLrLd/FVbMQqt5t8MWfX8lLj+nxPDd100DxKW8rKJVsMsfYwYGVwI0W9kw0YYTczSYjt1ZbvRUL6CGFLIXCFJjV8wJmoKPPnF9NAkp+i8pOTB1zGkYEniIWJaJWfe7MhLmJzHBoU4TSxNmFqAKKU8HDKkQjt5pSctqSKJ5kPyRjSWclmTFKD4Nf7rBIhfvihBOy2H2A26u/CrJCgq2fLU4w349cgLz7FN/I6HbtTi8dpC4DOo7hNsmWeZpcN3/XNrAbNckKdXzI9M7T1jhTz9LMcc1IYaX5EaK+ObS74VmQnJM5PT6gCVZfbXsaoAIIXIsdTSKgqOeI6xGhK//DRlEmwv6i86XgMo8Y8rQDSZWiYVdxIAZdIeGrFoayqsGShoTME4PB0zAcOxzTBNVktjYG2Kbe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 08:16, Sayali Patil wrote:
> The hugepage-mremap selftest uses a default size of 10MB, which is
> sufficient for small huge page sizes. However, when the huge page size
> is large (e.g. 1GB), 10MB is smaller than a single huge page.
> As a result, the test does not trigger PMD sharing and the
> corresponding unshare path in mremap(), causing the
> test to fail (mremap succeeds where a failure is expected).
> 
> Update run_vmtest.sh to use twice the huge page size when the huge page
> size exceeds 10MB, while retaining the 10MB default for smaller huge
> pages. This ensures the test exercises the intended PMD sharing and
> unsharing paths for larger huge page sizes.
> 
> Before patch:
>  running ./hugepage-mremap
>  ------------------------------
>  TAP version 13
>  1..1
>   Map haddr: Returned address is 0x7eaa40000000
>   Map daddr: Returned address is 0x7daa40000000
>   Map vaddr: Returned address is 0x7faa40000000
>   Address returned by mmap() = 0x7fffaa600000
>   Mremap: Returned address is 0x7faa40000000
>   First hex is 0
>   First hex is 3020100
>  Bail out! mremap: Expected failure, but call succeeded
>  Planned tests != run tests (1 != 0)
>  Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>  [FAIL]
>  not ok 1 hugepage-mremap # exit=1
> 
> Before patch:
>  running ./hugepage-mremap
>  ------------------------------
>  TAP version 13
>  1..1
>   Map haddr: Returned address is 0x7eaa40000000
>   Map daddr: Returned address is 0x7daa40000000
>   Map vaddr: Returned address is 0x7faa40000000
>   Address returned by mmap() = 0x7fffaa600000
>   Mremap: Returned address is 0x7faa40000000
>   First hex is 0
>   First hex is 3020100
>  Bail out! mremap: Expected failure, but call succeeded
>  Planned tests != run tests (1 != 0)
>  Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>  [FAIL]
>  not ok 1 hugepage-mremap # exit=1
> 

Why are there two "Before patch" in here?

> After patch:
>  running ./hugepage-mremap 2048
>  ------------------------------
>  TAP version 13
>  1..1
>   Map haddr: Returned address is 0x7eaa40000000
>   Map daddr: Returned address is 0x7daa40000000
>   Map vaddr: Returned address is 0x7faa40000000
>   Address returned by mmap() = 0x7fff13000000
>   Mremap: Returned address is 0x7faa40000000
>   First hex is 0
>   First hex is 3020100
>   ok 1 Read same data
>  Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>  [PASS]
>  ok 1 hugepage-mremap 2048
> 
> Fixes: f77a286de48c ("mm, hugepages: make memory size variable in hugepage-mremap selftest")
> Acked-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index afdcfd0d7cef..eecec0b6eb13 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -293,7 +293,18 @@ echo "$shmmax" > /proc/sys/kernel/shmmax
>  echo "$shmall" > /proc/sys/kernel/shmall
>  
>  CATEGORY="hugetlb" run_test ./map_hugetlb
> -CATEGORY="hugetlb" run_test ./hugepage-mremap
> +
> +# If the huge page size is larger than 10MB, increase the test memory size
> +# to twice the huge page size (in MB) to ensure the test exercises PMD sharing
> +# and the unshare path in hugepage-mremap. Otherwise, run the test with
> +# the default 10MB memory size.

PMD sharing requires, on x86, a 1 GiB area with 2 MiB hugetlb folios.

How does doubling sort that out?

Also, why the magic value 10mb?


-- 
Cheers,

David

