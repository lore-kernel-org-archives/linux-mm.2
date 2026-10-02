Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63138CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5656B008A; Fri,  2 Oct 2026 08:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285A76B008C; Fri,  2 Oct 2026 08:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14EB96B0092; Fri,  2 Oct 2026 08:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3FAB6B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:08:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BF3DC0744
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:08:19 +0000 (UTC)
X-FDA: 85277563518.13.82FB7DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AAE7B140003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:08:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qhdt8Ng3;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790942897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUHbJ2wYZgiOnAwObcV975WzRcpiwXyJLliBcLauNuc=;
	b=LtX/Soe+g5YqrcHcMkxEiKqMVKmjuEcP3EHWZlvUmaLaH6ApbD5E60RD1pwc+Z8HyExGV4
	IvbjQfyGjRZVWhFG8rpcooWVZDORXlwYi1xdMGiF5MhaOyPW0N13ulUH1eGfoPUd6jl6hc
	anKb4eQ4uoqmMZgz6l0Qxys45oyzG4U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qhdt8Ng3;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790942897;
	b=D8MC0wkydZJ8JA9qR3BSekxRVYqD/BIP7FcvL6aJTFM7Zbk6GMItCsAiiBGIG/FOLmKe7z
	XXZfb5lALWOvsIT/9HICWa2r0nfEZ4VdPV76tBNOVQ7jWsD0U0/8qwOnyjKM2CjhSf4GXi
	c0NgwMixAW1Rv+JrfAZbu9ion2IF+Nk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E9F6760A8A;
	Fri,  2 Oct 2026 12:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F1A1F000FF;
	Fri,  2 Oct 2026 12:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790942896;
	bh=JUHbJ2wYZgiOnAwObcV975WzRcpiwXyJLliBcLauNuc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qhdt8Ng3BHQCcF6XLWHIK3XVYvyTGIo1LuSR7+HBC/swZH28L6G+DvlB3cOOWvOkD
	 DtKXltQK+JBlcV2quCjFoDeV1lxUtJxiYvwuR2S3Cu+lV0QRny8RkXGRa3BYKgZZVf
	 QfiSVRfw/N0RKmNfxM26bk4ETWD50h7YjBF7ZKlHmmULShnii9lQ6GKBjHlXzOaI46
	 8pUznw1iNoCz3QjbvvnKwcYB6/mMYg+AKhOxJk16GJsKwJmwFOKSWRnP/w3R4SGnjD
	 Cj6G+xnl35BKOtIJTvIE/GsBbICb7v9QQQIrMYPAyxElTig5783sZb4vhxN7jKeBBb
	 V4qHHVzKo1bCg==
Message-ID: <54a7252b-ab2d-4230-9a1a-d4d1b670b7c8@kernel.org>
Date: Fri, 2 Oct 2026 12:15:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] Optimize anonymous swapbacked large folio
 unmapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
 davem@davemloft.net, andreas@gaisler.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, pfalcato@suse.de, jgg@ziepe.ca,
 thuth@redhat.com, sparclinux@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260924131106.1730494-1-dev.jain@arm.com>
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
In-Reply-To: <20260924131106.1730494-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAE7B140003
X-Stat-Signature: ry7gnx65amzyu8pmmfhy7b5scmn14zsw
X-Rspam-User: 
X-HE-Tag: 1790942897-1831
X-HE-Meta: U2FsdGVkX18yvf80bAla3LYZtZVQoWr0o6wRWqw9oPbg/PGezAVXgEKFq6nQ0eP1kJjX97OZFZm38sWojsIi3T/i4z6vGhwSRu+NyRcUXCr/w9LEPe3Btbeb5spvMRkYZYbtlSIL4fhacjrAcaliLZ85Vi6e+DVAcOrF9bjTwtI0zpCZZxwGFDWkoJ6NJp8UQ22/EfhS31JF8a4LfiQMn1UfhCoyGpCqP6UJnkg8KpfBBzWc1Hu+8erDj0h8PyOHE7SgiYY+GJVY45gMBziAyFjpr0wTpkirGgyIESWLu1qdxodW49M2VYzobYILIejP0FzVtAIun2JkPMlUWQPeOmQV58Hec3rooRqqy88IeC4Sbg3cVTrduszkHbkx67yD1K9i57FTby0W+hJivZLEye3yuucV6scvfxuyN5A6pCJgnyyRqnBThiQLQ+9PWhZdj7IFoEYtWUojpTA3pLQR8FVsFeFTF3sKQHTydu/wyya9mlUpN6arCAQXSIdRlrAZnJ9TOeC9ZnFxQrUC/k9U+Jq8IS6CUV6aOfHK0BbyYyLpEFjK4ZSX/0Y5p1YcUHrK1ineqeSa4wW8KubjVK62MnH+pWsTAquMnWJmYgBYJOzDoH6ES/032ZHl/J5SPi2ifORHqUXULTQXlh4Ba5nT/UDPBnJPxEgl+QkvSFJomyh8QXbE/LcaFvAWsuQXmTTJMoXUXgR9VxtpMsW19tBkFDjwLZRdTT7NW+qPsdFTn4BOW1UNFmhsb9JtzCtEOpyDiB96Xl+lEtYKf6naOccL68C6tTbDKnAtai9sqy8tcZVov28NptPOfJI80v/0MfkwZSHE+uWuV8pfwieuNp3Xw7dDN6PjT2WpVp71LAsoa4q3sATs4pEb01HfsHPFcS5yUOES8GdU7ke2JCeTzJzcBZZKDE2ueX2+0JAq5+MceuPMs4NTDotjNSqruQmtYJ3EYteQ2rlTkDxUffKDcyT
 fOBm1UOO
 5vK5yED9USDwBtfBGMDSuWc3vfzx3rCYpwbf2kuR0BHKJmN13DkNunAoNSmSvm4Bm/tTy6ImGp3+2GGWn2XedrSyi7jVsJf1MZqgCyPES/l97ApXEbCOeKL4YgF5IKe5JiEywP6knDEP21hiuVwyENC1YHy15xhgga/TguXEgBxH9l/A9JFIJEaR28WUTnKgUnHdBmjUzCgJfIeJz0t/1mjo4wrGCYBMhWljzmH298B0RMpO0U6NxLGa4CiqH52vgMNVh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 15:09, Dev Jain wrote:
> Speed up unmapping of anonymous swapbacked large folios by clearing
> the ptes, and setting swap ptes, in one go.
> 
> The following benchmark (stolen from Barry) is used to measure the
> time taken to swapout 256M worth of memory backed by 64K large folios:
> 
>  #define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <sys/mman.h>
>  #include <string.h>
>  #include <time.h>
>  #include <unistd.h>
>  #include <errno.h>
> 
>  #define SIZE_MB 256
>  #define SIZE_BYTES (SIZE_MB * 1024 * 1024)
> 
>  int main() {
>      void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
>                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>      if (addr == MAP_FAILED) {
>          perror("mmap failed");
>          return 1;
>      }
> 
>      memset(addr, 0, SIZE_BYTES);
> 
>      struct timespec start, end;
>      clock_gettime(CLOCK_MONOTONIC, &start);
> 
>      if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
>          perror("madvise(MADV_PAGEOUT) failed");
>          munmap(addr, SIZE_BYTES);
>          return 1;
>      }
> 
>      clock_gettime(CLOCK_MONOTONIC, &end);
> 
>      long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
>                         (end.tv_nsec - start.tv_nsec);
>      printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
>             duration_ns, duration_ns / 1e6);
> 
>      munmap(addr, SIZE_BYTES);
>      return 0;
>  }
> 
> Performance as measured on a Linux VM on Apple M3 (arm64):
> 
> Vanilla - Mean: 37401913 ns, std dev: 12%
> Patched - Mean: 17420282 ns, std dev: 11%
> 
> resulting in more than 2x speedup.
> 
> No regression observed on 4K folios.
> 
> Performance as measured on bare metal x86:
> 
> Vanilla - mean: 54986286 ns, std dev: 1.5%
> Patched - mean: 51930795 ns, std dev: 3%
> 
> I tried magnifying the difference on x86 by using 1M large folios, but
> can't spot an obvious improvement (looks like my system is too fast to
> benefit from batched atomic operations!), hinting that the benefit lies
> mainly in the reduction of ptep_get() calls and the reduction of TLB
> flushes during contpte-unfolding, on arm64.
> 
> No regression is observed on 4K folios on x86 too.
> 
> ---
> Applies on mm-unstable.

Given that we are approaching rc6 and are flooded with stuff, this will target 7.5.

I have this on my todo list.

-- 
Cheers,

David

