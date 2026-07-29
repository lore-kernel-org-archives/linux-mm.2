Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA20C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EA386B0107; Wed, 29 Jul 2026 10:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA856B0109; Wed, 29 Jul 2026 10:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A95E6B010A; Wed, 29 Jul 2026 10:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D272C6B0107
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:39:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F1981406B4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:13:15 +0000 (UTC)
X-FDA: 85041703950.06.C965834
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 492054000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:13:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F0ixN0N5;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZR21/LWo3BbtQVJieDL33KfOBPCn88cKz4sy64n1Ak=;
	b=4ZhTg+Kde6ys2AdvTyNecVg7ht2uQdVDGatxvbg6HDAbb3VxL5wVNGkNZXbFyhH0OiBAhu
	34hzc567cbI6WAQ1DuwKObuFFfPrz9Fx3h24cXi6KgeeHnBKVLI1xuoLqQJ10/5UyDDA23
	TZp1kKpdd+Jb5gZJwEhhRJhv/hBD97s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327193;
	b=p8y6P35tQdNhA4nLyYs4hfoeCkdEz71GIoJa3ItgZU6910tt69TAF6ghuiXrPTFkIV9PMT
	vucxJLDFkGKLSMMqVBe6rhOSIdj/p6OMaxaJlUXofO+336imavZ8cqEwqh+9U7gSIfxMnJ
	qGDumFr1xGv/03dYLIQem4OAMUcxItQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F0ixN0N5;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F689600B1;
	Wed, 29 Jul 2026 12:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4ADC1F000E9;
	Wed, 29 Jul 2026 12:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785327192;
	bh=KZR21/LWo3BbtQVJieDL33KfOBPCn88cKz4sy64n1Ak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F0ixN0N5y6bgzuowllPKQswouLSamyCsNDGFf9VK6mms/P/girlt6ZKJ6ChiSjEtx
	 sGRXLDvzYNPeajPzxxIp9yEmIiXaG8hLs2hWXiY8DKpKlTpffwQlKWiR+0J1v3D0Lh
	 js0tF735ZdJDu3DL46YeDgATXtJdmS7dRUS/iF42b4oVFs+HrkSKzhbaC/FJqstyKI
	 9vmCml3aBLa0JL2sQeoO99o6pBWyi+59K26sSwTwpGD5c3Xr4HQLL9ae4saIcsIz37
	 uILZKrOIJ6iBsRh/AGGGhYjQ54dXDU94YjzJlUPwCZhmU8//5ELYneQGvxus/JC8nu
	 5hWXQNfZuGygw==
Message-ID: <229c3079-8fde-41b4-9d6c-f0e34f780555@kernel.org>
Date: Wed, 29 Jul 2026 14:13:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/2] mm: allow smaller large folios to use
 lru_cache
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org, ljs@kernel.org
Cc: baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
References: <20260709081536.82768-1-baohua@kernel.org>
 <20260709081536.82768-2-baohua@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260709081536.82768-2-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 492054000D
X-Stat-Signature: gaudgge8oztzdz8sogck79tmsq6kamwo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785327193-13233
X-HE-Meta: U2FsdGVkX196muWcdRliawunF2T6BArwsQ4j1N9G3zBH4Mwqr/fU27DerwdHdGnqGafr27RM4aEvTYjzryTaTp4JKU8ttX+2hGXUvbvOoJVtpZLcrbfPEAyqhSgvrFhDiIeXlH6p3wwmROuJ2uoWnyaB+beFjzOO6Kjf4516qwDytxY0ifTPFulyaPHVe8JXJg25lYE1WqTU2NMIgyMuensIyr3207+zIBm1dEoiHUv1+pqHzVITwGL4fHSOKNYHckhTy0l0bAxWs1Rg7L7T7u/itVKayTZykGvNsJkEB03POX7kWCK/UzJ1wCBHhgTRO7WKEtW79BzdCyVjPhM3t6phGIelKTihkesJDV6zCUvapX+fPPr3q5b1hmilFAdksuS+XBIPQ+Bm6SxnoBe63YVvhmnzJrwmhJRCU9BPgHPa1D4Wri2bQfUnbdv9f75gdfQzsx1kFjHb2VxMyMLXzgQE+0ZPyLpcr6vcvNw1zCQROIb+8lyVFIx2KZYgebWNJwDEYmf3SRFYmBaZ6BIGol2C3Gwuu5Xw0nn0Ex2CBxUzvDtE0NDR5k/7HJnOUjobCN2fY6wXfRvtH5tVoqtKdMf6AoRZYPggJWjuW20qAbsQRztojv2k1gco0eGAXseeu3sAn8Lo2ZzXwZZGsCyRhN8PfN90dfMbmvAuUOJwKwFAPEtBeXDnPmOJ4MsIwUn6WWCLRlI4l2GZeP2LGSLrXtKEYvjGh/YiooXDQCa6exr2UfzUjrl8SsXPtSClcDuVxLvUv9tp/19ZxbPp2ApOyKpDmM8u46HvDyqxT8mW1AIO5tnCOPKC0oE7mm1O1PONI8P69DPXRU19ddwVvP7NggQHUNU1rObeLd9ayuR9eIrtbFWAhXXTC57e1acTn0TFgcukd39z9FDWU0eEYgBlv2RdB8hKUtQ3sWlbof9QCGeO5cwlUfKj0V+ildLITF6KiHX6KMRiquY22XmXRuv
 9Nfj476m
 IAUrv83P12BEL7OxWw/pGKYKotnzzCcCCiJQz/a+/qXWo0RzosDeN8cHmVFGhJcZ3J1LXFodJzX0GvdNqFFatSaJII+39lVHYm3ZH840DiJourwx00IKXOVgf81z3RtOni/qUr0NCcuoVlwiXXI2KWax4H+0zFHu3JTIC12Yq68TCJEXGZOaXCxwqsegxLFM5KK8klMgp5Ryi4klser7CsqAUO84/RnujbpmX4G6uUvchWxk9bNtUzADHXHQXwaY8DNlYiTAWFGlGTwzoMhDwM3X3yKowV5H/3gp0Rdy2rf4J1XdatT+KZSYVOnIebRb+I9LWQpBstFxJrbpjz8TIWfwQLDztJWbT62M1TgtAIp/D7i8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 10:15, Barry Song (Xiaomi) wrote:
> For a system which primarily uses smaller orders for large folios,
> it could be beneficial to enable lru_cache to avoid lock contention.
> 
> For large folios with higher orders, the number of folios involved
> would be small, so the contention is less significant.
> 
> The following small program runs on a system with 16 KiB
> mTHP enabled.
> 
>  #include <pthread.h>
>  #include <sys/mman.h>
>  #include <string.h>
> 
>  #define NUM_THREADS     20
>  #define MEM_SIZE        (16 * 1024 * 1024)
>  #define LOOP_COUNT      1000
> 
>  void* thread_worker(void* arg) {
>      void *addr = mmap(NULL, MEM_SIZE, PROT_READ | PROT_WRITE,
>                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 
>      for (int i = 0; i < LOOP_COUNT; i++) {
>          memset(addr, 0x55, MEM_SIZE);
>          madvise(addr, MEM_SIZE, MADV_DONTNEED);
>      }
> 
>      munmap(addr, MEM_SIZE);
>      pthread_exit(NULL);
>  }
> 
>  int main() {
>      pthread_t threads[NUM_THREADS];
> 
>      for (long t = 0; t < NUM_THREADS; t++) {
>          pthread_create(&threads[t], NULL, thread_worker, (void*)t);
>      }
> 
>      for (int t = 0; t < NUM_THREADS; t++) {
>          pthread_join(threads[t], NULL);
>      }
> 
>      return 0;
>  }
> 
> Before patch:
> root@barry-desktop:/home/barry# time ./a.out
> 
> real	0m20.233s
> user	0m21.739s
> sys	6m21.143s
> 
> Perf lock report:
>       Name   acquired  contended     avg wait   total wait     max wait     min wait
> 
>              21158662   21158662     29.20 us     10.30 m      67.83 us       884 ns
>                 13547      13547     14.68 us    198.93 ms    135.39 us       982 ns
>  rcu_state         41         41      1.83 us     75.21 us      3.46 us      1.27 us
>  rcu_state         34         34      1.83 us     62.09 us      2.60 us      1.16 us
>                     5          5     21.31 us    106.57 us     25.77 us     18.17 us
>                     5          5      3.01 us     15.07 us      5.19 us      1.53 us
>                     3          3      6.42 us     19.26 us      9.63 us      4.22 us
>                     3          3      4.20 us     12.61 us      7.45 us      2.10 us
>                     2          2      5.03 us     10.06 us      7.88 us      2.18 us
>                     2          2      2.79 us      5.59 us      3.34 us      2.25 us
>                     1          1      4.70 us      4.70 us      4.70 us      4.70 us
>                     1          1      9.77 us      9.77 us      9.77 us      9.77 us
> 
> After patch:
> root@barry-desktop:/home/barry# time ./a.out
> 
> real	0m17.796s
> user	0m24.962s
> sys	5m28.774s
> 
> Perf lock report:
>       Name   acquired  contended     avg wait   total wait     max wait     min wait
> 
>               1407013    1407013     25.44 us     35.80 s     127.83 us       972 ns
>                845113     845113     47.96 us     40.54 s     152.86 us      1.21 us
>  rcu_state       1920       1920      5.87 us     11.27 ms     25.02 us      1.76 us
>  rcu_state       1889       1889      5.80 us     10.96 ms     30.35 us      1.61 us
>                   140        140      3.97 us    555.52 us     12.51 us      1.20 us
>                    10         10     61.34 us    613.42 us     96.90 us     44.48 us
>                     8          8     24.03 us    192.26 us     37.64 us      6.95 us
>                     8          8     12.32 us     98.56 us     25.55 us      4.16 us
> 
> Both system time and lock contention are noticeably reduced.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  include/linux/swap.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 8d19be675baf..9c5f7a11c7b0 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -316,9 +316,9 @@ static inline bool folio_may_be_lru_cached(struct folio *folio)
>  	/*
>  	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
>  	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
> -	 * will be sensible, but nobody has implemented and tested that yet.
> +	 * will be sensible.
>  	 */
> -	return !folio_test_large(folio);
> +	return folio_order(folio) < PAGE_ALLOC_COSTLY_ORDER;
>  }
>  
>  extern atomic_t lru_disable_count;

Sashiko rightfully raises that split_folio() can now fail more easily.

So we might want to proactively drain (earlier?) on some more of the split paths.

-- 
Cheers,

David

