Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D9CFED3C5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39986B00A4; Fri, 24 Apr 2026 08:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FF16B00A9; Fri, 24 Apr 2026 08:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926236B00AC; Fri, 24 Apr 2026 08:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7C06B00A4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:59:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 450FD1B6CCC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:59:27 +0000 (UTC)
X-FDA: 84693455574.09.202D28B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5492C40007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:59:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DNmYyg05;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777035565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cl4Ey1BLfxMWasTDDmeceGKhTzpL4e4kASI4VE/Jik=;
	b=MJH5BlSb5uxQz9LYpx8dxB8YOivTXiXHdOEtkayWAhKZncvB6GIK32Hh6gjG2MtxW2DR7F
	TYG0f1PUFT23MWpWbNX8/5S0kwRqvUks6ngLmMSQKeQkBnh6oXsWkI8B7XVPTQFTev2n0k
	I2+qJKZ57KZcuvXUaUPNHk20nvbL97Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777035565; a=rsa-sha256;
	cv=none;
	b=mMBPnC2hQDQVO6iFne5EKoudlkWigSBhvBQtZOIjKNEbIKdAuID7K8iC+Pvue8oyGnZQgR
	CJF0txT8LF6N+5WiyjziBiH9qLS3n270s2c7cBZw5F/f5xLaIhkngKzIu8N4tMN6OzFodO
	aj0bL0r1iFUT1n9hmkugDtIcg+A3sl8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DNmYyg05;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12D58417A7;
	Fri, 24 Apr 2026 12:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECBDC19425;
	Fri, 24 Apr 2026 12:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777035563;
	bh=KNJcDQF8Ts4X/HuTfNn5ZOh0jQmL3ALukE7ezDpGgZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DNmYyg05xVJzFvK8CAIYDLpqGikMLhSkf9F3DyHzV/iOxDemR7t7t+xU+P7NXI8AV
	 oj43RaU2xhiTRvRx+74e536bU4pCr/6+HW9Wg+WvsendzfEXnpE0J1MDYrDjKSlKYv
	 b1TJEqebnJ+iienjWokf1e2uVKLC6XiG3TI6PSI/0U8J9Wb/VRjyi9SALQSG6Cz5Lk
	 QewMo4iKv/XZXfT00UO+J6X7vNjBaWls9em6sWRDCA7O/EoaQrLJYN8ToQvoqYh+OU
	 3hhNNQfYOF1ZePaRRleqPT+RQpWLrVazFl8RYrL1d9UsYuDHJxq5pQtQTyvIKeSz1h
	 +x51Y7PaJX3Bg==
Message-ID: <a7b30a6f-0fd8-489a-9623-912fd4d84fe3@kernel.org>
Date: Fri, 24 Apr 2026 14:59:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v4 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 code from guard-regions
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-13-ziy@nvidia.com>
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
In-Reply-To: <20260424024915.28758-13-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: obnnoghfzqt4yqs5j8k6ew4pqs3jb4yx
X-Rspam-User: 
X-Rspamd-Queue-Id: 5492C40007
X-Rspamd-Server: rspam05
X-HE-Tag: 1777035565-958261
X-HE-Meta: U2FsdGVkX19P5ylsSbMXOaOSXHHujP5wvE8FhkgE9W4BEl6LiD+xQMzO6tsPs5S+ORHOAm0cbAiCoYChB0Rl2hgIFq0/ZPNKfAO9uUZcoSZFmgNAVkY+gmEt2zBDgCQa1NWAmA2NECO463u3dxv+pVKQ1JIcFNsDkk5CdzvLQPzeLXejdzNsm8ty65JfOPr7gnpPuWL0vN02o0ntG/RhqGyeMKCbxihkiF4+xJSWGbonuBpbXrK4ckfWYe9dlHme4+GXoUJD/DCjT5tGRSNUXJzMJhWc967DKOT8s5hPX6k+WYZGxouAm5p11VOJhRVwjBDNSs+nP4U/DvMfP8tmJhi1cOPMwumWX+zjT7oNtmcOTdOPpW3/+mJVvzAmlNbAEklH88Q7PURqVmvoBXKSSCKjtZI7F1YrPzM3J1C8BkTpjRtxraNIFN1l55X4CiGaXERAYzNa/XdCry6mbZjtIT9HFY6t1+sWAK1Dchmv1d2xnSpP4WYa1/RzAdLwWWHa0RxHI0KjLpmQ8HcThmU8iTS+OMfkDgW7AxC3ATn0acR01+s9qnyye8St1ZLV7K1tCbDhQKxjWtfi4vM9V15ZiIGX2QTbmjbPOndeTeevvYvvU62lxR2hOu99HKwGvbU5L5XweIph0wIb7sgwMlnyg4C6s1jZZBG33fqp049prhHNQWqIx1VLq0gswUies4Di2vmzs23iScSi31DEQG6taDu0MvBKBqoyhs0s4iOpYeRsbCXGimJEapQYR+/NkJoJHCb3ni9pEWDqQMn7E4n+X/TMiMRRMAv/BCxa38IjWCQuqFpu4VmbyCaiVMiNQPnCrBelXQ//RflfdImBBJFszxvHYxdbPy9Y5EqJDG1XWVpv54W6K1yLNwck7iYIeR5Ri/S+6dTNm0+rra7jjBxJ25cEX2j6wya4egKvYXbuG555hZOTXtiTn/RO9Hd576eZtUwgoT4OCtM48U0O/Yg
 PvhJVWta
 DEjV8NJiZ8XNNtYKBESAPTtTj+JThcqjodELV7fxaIE9Z/iXTSD8RvuSyZX/ljDR63aLQi3NTQZn0+pDAjkE2KZljjEOfkiOQPoDlXTMcRrAnPJvkPVJyTTlW/53o6hoHFYdF/sO2eUUxtYBvkVWMlV4dTGPHZBSQi7T4EfucdmsBFJvtXAiKrARQgynRkGFEcoXXMPo119rBuOYROAIpQks1/EdM+GJ9KCA2ufepai2hbiGU4tphqCW9tPVCFzQcaNEHkScsKdqWH3YuwI3OTGo9LJmSDs1Z7gumXw4oxLuCRvmoSiPe9M/IAXIK1fJ1vBSGbvJHE18+b9KysoYh14PNQIFdaozAeGFx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 04:49, Zi Yan wrote:
> Any file system with large folio support and the supported orders include
> PMD_ORDER can be used. There is no need to open a file with read-only.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  tools/testing/selftests/mm/guard-regions.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 48e8b1539be3..117639891953 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2203,17 +2203,6 @@ TEST_F(guard_regions, collapse)
>  	if (variant->backing != ANON_BACKED)
>  		ASSERT_EQ(ftruncate(self->fd, size), 0);
>  
> -	/*
> -	 * We must close and re-open local-file backed as read-only for
> -	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
> -	 */
> -	if (variant->backing == LOCAL_FILE_BACKED) {
> -		ASSERT_EQ(close(self->fd), 0);
> -
> -		self->fd = open(self->path, O_RDONLY);
> -		ASSERT_GE(self->fd, 0);
> -	}

What if someone runs this with a filesystem that does not support large folios?

Would we want an allowlist for known-good fs'es, similar to how we handle
gup_longterm.c, and SKIP otherwise, because we know that MADV_COLLAPSE would
always fail for a different reason?

In any case, the test would not misbehave if passed an unsupported FS, so LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

