Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3983606D802
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D5FX/qth
Received: by kanga.kvack.org (Postfix)
	id E25DF6B05B0; Thu,  5 Nov 2026 05:29:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7016B05B1; Thu,  5 Nov 2026 05:29:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9DED6B05B4; Thu,  5 Nov 2026 05:29:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 914296B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:29:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8870512091A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:29:01 +0000 (UTC)
X-FDA: 85400692482.24.C5C7E46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B221740007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:28:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D5FX/qth";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSkOHXuDBf1pgGwk7mqhtOIuvilX/GFlHMjt2QNkx6I=;
	b=nzSwiOBWTFCqKBtebaSL3jKhshqW+3EcTlzqfwgEqm/2EHbmJXgfUVB92aA6QK0xhWzmtg
	Tl2YgTItjsStPUEonI4sFfiG+6ZT42fDZNr4x/MXq2VEg0imn5YSd7cVXTZYWRsVA0l30s
	wqiJUNbPNXplKEATPa/vPj+Iza3LPS0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874539;
	b=d0p2+P0Fhgke6TILPRER6jsQkAQ80hI6hqJmq5ktD24I5lgl/92FuEQnk/hMtJ4ASbGC9x
	sIaAMr4t72iGNOrhisy6dL/CtDIjzbcKPCVvNdj+T8ucAJri2dq9yU9rCarXiU/0kn9EjO
	kFVkfNy42MylIEvroPBzHLIjAFqG4mU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D5FX/qth";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8610414EC;
	Thu,  5 Nov 2026 10:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9919D1F000C1;
	Thu,  5 Nov 2026 10:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874538;
	bh=DSkOHXuDBf1pgGwk7mqhtOIuvilX/GFlHMjt2QNkx6I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D5FX/qthyK0NqnE0cZ6gDihcGQqcR+80V0Pvt0dHUbgQZE6mFbffUCUREvE5DEvzS
	 99vhZZ6A/YabImxHJ8X34i2j8aeyZ24ncS/tjQ6Dghp3ahbNi7qRasKjsE4tb+0LDp
	 8rY2fNrgoGg+v6Mqr7rnbzY3H423iPxrkGBWXayxV5cpx3WLY3ITr67vMcSkW4eDlm
	 PIU7REyUmeiVu7VELSVOleQQdjnEkae/F48HBht2qROXj+W0/yCABs32z49O8Ux/zl
	 V1zSQNF0Brx8TEz+dnYPI0qYdNgOhltl+vaCGSQpG39O6T22vky+xsm0yM6ZTWDwns
	 2JypCrn1Hzzrw==
Message-ID: <c05cb7a5-35b7-4364-9b7a-a87e54bf0ecf@kernel.org>
Date: Thu, 5 Nov 2026 11:28:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm/khugepaged: drop/reacquire mmap read lock if
 skipped enough VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yonghong Song <yonghong.song@linux.dev>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-5-a07ab16ac860@kernel.org>
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
In-Reply-To: <20261103-khugepaged-latency-fix-v1-5-a07ab16ac860@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pxf9osm5gr3i6gig3rh5sbgo14hi7ocr
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B221740007
X-HE-Tag: 1793874539-739291
X-HE-Meta: U2FsdGVkX19pXJZ7Eab5HzeMc/FHRFBMkCPWApaPW+Yq6O46UYOmVXEcKmBTv+733xAQXY0metoUDhAaPdNJftQEtDNlpLcjx07uy8hJM5AZxrqrK/1Bt4QFWzAheBKiBUYcFvdkOl68fcOhoDbIrqhc7Tl7KTwCw4yfEwSpfeHgsaxLoBYH7b8XiSLGxPguhu362vIAxtxFIpgxw6d6Fmfz2Wu103/bbtftfm7Vtw8VYFoK80oxMQ9WRopolrpiolYj982mNZwyMPkfBXnyvAGe+DoP9pC6pNsKZmJa2lPKq5Nl8dywoa2s2jBHXIPXA1uOWJTjVXsoXEkmNfoRELotN1mOaNqBod8ajcd3RAXIalDR8/2AejPEMfTJ7CMvOjTXQifLow9KfvEtdVACAvXBcDujpbGaFdcJXLOqW7xQEuyHr35g+w7uNN72K8xg3IlglaDCZy56spF2hak0gWHmG6GE1YJdA66BIEnt0cK4MBDW7qlP+8MR9wL1VSYEISI39CDlWOdQkrlg0FYnVKf/j14/Lutbelu70B2pAqyigb8cJndQMoHRxYUgM/DfEaUuwRxj3D1S9VUcco0HZc7CbJuOqGfAimdLn7auqmIo+M2qlXH16dapR1UmuX/cOQY8/TMaAZpIQEZl5qBeGtt3rnDlFvrx02ev6WcWjRxzufXiUe1f1geDXEFVvb7RH3Cg1EfjtP9WPhEJhcQIKPajDd+dD2eSTTFx90WJEwCWuIEq8xFe3EKbDhd0kTaNXKbHIw58FyxJ5UEiCtKEn++eUWsJWMk7wQrqqO4zez4ek7fml0r5l9Dmbd2+Fww4LTVDMHNAyLbDgw2B378l6BvKSlyhQ6AxxWdMt6ToONS7jusSPfmPyVXt8qb9T0v6byKynFQOVJqhZ+lbcSrpTehtlvvtxMr+fQYtN1/KsXhkgryb6sBND0BkD4hUtRoctE9nuzOMuzenAbKQw3Z
 R9pj0Ya1
 D7oPJ1VMkLaOvBhUHYUrGNiQsdnCflQ6M6cybeDYoUznY31DV3tvuUfkxc2vEapFIrgjluwOcJpW68jbWrkajfygKm6AUMMcWGqXUGD0BiVbuzHHjiu6QWVwfHqWv0+I8MbotWMcEfsdkY69QbSAJArQKV5QuGm90zSYh/MFn5s7YIKpRRsEdISBlMmDTKIAsoXjz3Z8qhMq+4eI7QL6AGsYOjmz4J56dynUsL4e68UXrnQsYUKO5AhP/EWsAO69R3+hclJpzi0Ww5AlQ2ZfOCcDqGXWSF48iR82b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 09:27, Lorenzo Stoakes (ARM) wrote:
> khugepaged walks an mm's VMAs under the mmap read lock in
> collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
> them if encountered.
> 
> It charges cc->progress 1 page against the 8 * HPAGE_PMD_NR budget when
> these are encountered, however only checking this budget once an eligible
> PMD-spanning VMA is encountered.
> 
> It can therefore hold the mmap read lock for a long time if there are a
> large number of ineligible VMAs present in an mm, over which time no mmap
> write locks (and thus no VMA write locks) can be acquired.
> 
> Address this by dropping + re-acquiring the mmap read lock after
> KHUGEPAGED_MAX_SKIP_BATCH VMAs have been processed. Use the newly
> introduced mmap_read_lock_nosteal() to ensure queued writers take
> precedence when doing so.
> 
> This was tested locally with ~1M ineligible VMAs mapped ahead of a
> collapsible region of memory, and resulted in a reduced mmap_lock hold time
> of 170us down from 95ms.
> 
> This was also observed to reduce mmap_lock stalls in concurrent threads of
> a similar duration.
> 
> KHUGEPAGED_MAX_SKIP_BATCH was derived empirically to a conservative value
> of 1024 VMAs, which should not interfere with mm's that have an ordinary
> number of VMAs.
> 
> Local measurements indicated no change for ordinary use cases, so this is
> all upside.
> 
> This work came out of investigations into mmap stalls when getting latency
> numbers for an unrelated patch series.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/khugepaged.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 216c4b8d28c4..b9c72ee8b421 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -66,6 +66,12 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>  
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>  
> +/*
> + * The number of VMAs with nothing to scan to walk before dropping and
> + * reacquiring the mmap_lock to relieve lock contention.
> + */
> +#define KHUGEPAGED_MAX_SKIP_BATCH 1024

I don't quite enjoy this magic number.

Besides it saying nothing about "VMAS", so the name it self is pretty unclear.

I was wondering whether we can give the "cc->progress += 1" a different weight.
Skipping VMAs seems to be more expensive than we thought.


(Maybe we should also just say "skip after X" VMAs in general, whether we
skipped them or not?)


-- 
Cheers,

David

