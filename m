Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCED6C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86D26B00CC; Thu,  2 Jul 2026 20:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A114F6B00CE; Thu,  2 Jul 2026 20:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88A846B00CF; Thu,  2 Jul 2026 20:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5426B6B00CC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:28:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A39FAC1277
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:51:53 +0000 (UTC)
X-FDA: 84945033306.21.B6437EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F2516140007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:51:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iajhnKKl;
	spf=pass (imf26.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783025512;
	b=sixXlqhYZVyCkzDNyoL5CLcvrm32iosxO4Ox/E+evqT7ifMDVQ1bLVgNpudEqzNkgOl3kk
	bvmhjDXtTHzQ0ZzMhmqVwxxRF+Hm0OO5B6fyHLtuRAkc5lBLGdZexTzRBn8mteqWqRXU9Z
	dTpNMCpDnT799ayrgiNV2ZZzSPvGUPw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783025512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwQijCaGsc94GM9rnfFTM/tXZ07/BingjWXiAAMHlS8=;
	b=u/t9GsA0pnpx4Kc1w9FF8QpmCGysUWEYNN3ZacpvgCTG6pC4EuTVx8Bf3rjPVrlj9Y6RIy
	m/llkrjo3wVyWyPNm+8lSYTbKO6l0R8AelfH96Tu6EOS+SDoN6mEBFtuQyA0OqOeuXoAim
	jhc7rskvxhXEGyurzhuBKECzakrX4zc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iajhnKKl;
	spf=pass (imf26.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E498601CA;
	Thu,  2 Jul 2026 20:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E321F000E9;
	Thu,  2 Jul 2026 20:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783025511;
	bh=BwQijCaGsc94GM9rnfFTM/tXZ07/BingjWXiAAMHlS8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iajhnKKlhOb7iy8tLplN0NrfXXSk0CTtQkSAT2K8oL27v15/kirOoELh+9aOfxhN5
	 zvC4W6tJ7B7l3oZYsfzxKZEZDE7F4rwAlDGsPx37tONw88vpDpraXGrdTW5cu70sEz
	 X6lvJTw65VfOBFTnmn3Eth1UOFSuFNedwYIZQBj+RWxSIbiVgN7OrHPdc5y53Jr4NJ
	 h9vfWem6J6ZehTjwjTc6QvkvKgkAHj8YVzOi29kVaAC9lFAkzbFsWPHCFzFyALhbqA
	 9S7vhz/v+TxGMaoP2MAu7cLoBBNHLqFYAXdxUFmrwHEVg7XqHYO7FPVnEj1b3pu5vd
	 69DtomoqC4DPg==
Message-ID: <6dbee972-566c-4aa7-9fb3-dbc5f90e923f@kernel.org>
Date: Thu, 2 Jul 2026 22:51:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in
 zswap_shrinker_count()
To: Johannes Weiner <hannes@cmpxchg.org>, Yunzhao Li <yunzhao@cloudflare.com>
Cc: linux-mm@kvack.org, nphamcs@gmail.com, yosryahmed@google.com,
 shakeel.butt@linux.dev, akpm@linux-foundation.org,
 zhouchengming@bytedance.com
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <akbHBZP9HxOJMtQB@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F2516140007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: hu9tkp6mb9fwuqncpc6c3aneqxzuw7tu
X-HE-Tag: 1783025511-893431
X-HE-Meta: U2FsdGVkX191o/Pj/K+dBPy+u73XW4iNyNlMsCWnxk49ylW644a/LeqcS+WDGC+7erFr/R81Ozraz+3er+PmfYmfBsgcXhF8iEjlAQe12gx1SwHGlYrqAsRWUNtMI22Z2+S+LM2HB7RM67Fuq1oV0DbG8Uhz7qyyRAyu+AQvfPk2ZzkwD+WdIa2RlAyKOXcTf+lkyqpeqx8aWUDY/hcMJ+rTNbc0JN7w38C/7CmJ6jDc31Pbkpf92tZmDZhhyPXoRx6E6UuxjmkBbEA4e2/IhTWVx0rBpjRN5wq0jMjssqdvbGrojHdSn3sBxwpnUxp1n0FBZXJHaco4o0OsGorLchgTeIKLlwa4HB0h6PaGEQ3ca1+qi6ha+oHmXyaJZ5rVYeIXMe8LzEdcSE5DVkbZ/V1m05fB9ljw7sM/OW6yO80nJYjpOXSNdsbC5LFTaOxN9R/IB8TfBwjtTTMX7cDxeC4x3FhuSZLuZCjDK+HJo6+wTSEbhK2SC8azjYRz69blPKt34rYzn/DzIZPhFHwhXISVLpJSwaL/6cQ+5f99k9TWwiZQcU/1YIxeXWh3mxiLY2mQ7/DOIDkZZYSLwL/twExN9bus1wT3x4pyeMTvRcTbKgi5fAWQaMddVY3Juu+j253DVTJqe/agfjC1GzTCHxK9ZetPHDfI4zMQqO71HQaY5C6cePTRVHNqR1IiJGGIagr3MUl+61JIKyQuMs8AND8GA1utsRfHC4N1vPXtBVrg4VT3LlGzpngVySX4tVmcHWIt6/UlMEwSYCF+NtFBWRlRJHK4xwVts647n8WhcWJNZhn74VZHC63HNxm4u2TColDJQ2hYlod932fwOTtRcLiewZjIW0mqY3Y+wuFIyVw4i0HKIu2R/mHrNl3lt8GHsma1A/N/hoA8DE0vex4fZdlZiqTY8RpcKTwNoukaBAUHmHy+kL+wsKNH7P0OinPD76qvWqgkm48pUfQZwGA
 6Y6uS/9M
 rjk/upZjWTujFgR0yhwekElLpcMzfpD8rzn91uKpNilzNggOmjGbP5tGf3xRf5HWrO5yQ2FUZOHwVu+zN3ic5IlY03b8JTJLOd7FICjwm5nebj8dmrN+3P4KAzWmjZJpHVqiZjKrn81mq7Q12vqAlLIoEo9jCr0CaOMQPdjzkopCiyR/M9BnBPiHOAFc9P+kDWLICF3ju9kBMahTSeSzdOAWYJbfIaXFUKBHpS2NMw4td1SX0IHTtXYMIq5U3pzvfdXxu8MwNys8DaD/iA5RumHZWwKTOc11fNJVQSvv/wvX0x9mWBw55GAihuaycWV34WakKFlQm6hn1dbUBJ77ZUWzPvsjYQBq6VY7MN87xJTbOP56Mch5+YFuQfP0O8pZI7SH5xDxJQCE75Uqsy+XQGLO3gMbKrDSLx7SCmlX+kYDrnEZQ2WdFQSqA8LXwCVIWLKrhch9Lip36S/1fd/1D0uF6i37spCST1KBd0BV5BiufsS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/07/2026 22.16, Johannes Weiner wrote:
> On Thu, Jul 02, 2026 at 11:07:35AM -0700, Yunzhao Li wrote:
>> zswap_shrinker_count() calls mem_cgroup_flush_stats(), which takes the
>> global cgroup rstat lock synchronously. On machines with many CPUs and
>> NUMA nodes, this creates severe lock contention in the kswapd reclaim
>> path:
>>
>>    - Multiple kswapd threads (one per NUMA node) run concurrently.
>>    - do_shrink_slab() invokes zswap_shrinker_count() for each
>>      memcg-aware shrinker pass.
>>    - Each call flushes the full cgroup rstat hierarchy under the global
>>      lock.
>>
>> On AMD EPYC 9684X machines (96 cores, 192 threads, 12 NUMA nodes)
>> running production workloads with zswap enabled, perf shows 2.88% of
>> kernel cycles in osq_lock contention from this path:
>>
>>       2.88%  [k] osq_lock
>>                --__mutex_lock.constprop.0
>>                    --__cgroup_rstat_lock
>>                        --cgroup_rstat_flush_locked
>>                            --cgroup_rstat_flush
>>                                --zswap_shrinker_count
>>                                    do_shrink_slab
>>                                    shrink_slab
>>                                    shrink_node
>>                                    balance_pgdat
>>                                    kswapd
>>
>> 84% of kswapd kernel cycles are spent in
>> shrink_slab -> zswap_shrinker_count -> cgroup_rstat_flush, not in actual
>> page reclaim (shrink_lruvec).
>>
>> Controlled A/B on identical hardware and workload:
>>
>>    shrinker=Y: 2.88% osq_lock, memory PSI 1.58%
>>    shrinker=N: 0.00% osq_lock, memory PSI 0.57%
>>
>> eBPF-based rstat lock wait measurement across 8 production metals
>> confirms the contention splits cleanly along shrinker enablement:
>>
>>    shrinker=Y: 50-250x more contended lock acquisitions (248/s vs 1.1/s)
>>    shrinker=N: baseline lock wait (0.0017 s/s vs 1.04 s/s)
>>
>> zswap_shrinker_count() only produces a heuristic estimate, scaled by
>> compression ratio via mult_frac(). The actual writeback happens in
>> zswap_shrinker_scan(). Slightly stale stats are acceptable here.
>>
>> Switch to mem_cgroup_flush_stats_ratelimited(), which only flushes if
>> the periodic 2-second flusher is one full cycle late. This matches the
>> approach already used in prepare_scan_control() (mm/vmscan.c) for the
>> same reclaim path.
>>
>> After applying this patch, rstat flush latency and lock wait time on
>> shrinker=Y machines dropped to the same level as shrinker=N controls,
>> while the zswap shrinker continues to function (pool size remains
>> bounded under the max_pool_percent cap).
>>
>> Previously discussed:
>>    - Chengming Zhou (Dec 2023): rstat contention from
>>      zswap_shrinker_count [1]
>>    - Shakeel Butt (Aug 2024): zswap_shrinker_count still uses sync
>>      flush [2]
>>    - Yosry Ahmed (Aug 2024): suggested eliminating in-kernel
>>      flushers [3]
>>    - Jesper Dangaard Brouer (Sep 2024): cgroup/rstat V11 patch [4]
>>
>> [1] https://lore.kernel.org/linux-mm/20231206103935.3440502-1-zhouchengming@bytedance.com/
>> [2] https://lore.kernel.org/linux-mm/CALvZod7LFxLCxVpOFH8b2Ppm8T40HPGMKQwX_=NPCWB_mFW+oQ@mail.gmail.com/
>> [3] https://lore.kernel.org/linux-mm/CAJD7tkYvFyOSX+rP_FKGBhxvZiCDxtpsNp-c5CGOA-4Bq9oXSg@mail.gmail.com/
>> [4] https://lore.kernel.org/linux-mm/172616070094.2055617.17676042522679701515.stgit@firesoul/
>>
>> Suggested-by: Jesper Dangaard Brouer <hawk@kernel.org>
>> Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
>> Signed-off-by: Yunzhao Li <yunzhao@cloudflare.com>
>> Tested-by: Yunzhao Li <yunzhao@cloudflare.com>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> A lot can happen in 2s, but I agree doing this every time is
> silly. vmscan has been good with 2s for a while, so this should be
> fine as well. We can re-evaluate if we run into weird behavior.

I don't know if an ACK from me is needed, but I'm just acknowledging
that I helped Yunzhao with developing this patch internally at Cloudflare.

Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>

--Jesper

