Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424D7606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 00:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KDUPZmYP
Received: by kanga.kvack.org (Postfix)
	id 348C56B05B2; Thu, 29 Oct 2026 20:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FBAA6B05B3; Thu, 29 Oct 2026 20:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2124B6B05B4; Thu, 29 Oct 2026 20:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBB1D6B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:19:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 612BF1A05E9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:19:24 +0000 (UTC)
X-FDA: 85377383448.11.4E57D73
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf17.hostedemail.com (Postfix) with ESMTP id 23F6040006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:19:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KDUPZmYP;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793319562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvTEWT4tzbsI9cJ16jquNJfiv3JAh46yKR+2DLJfzKk=;
	b=qu0gydCG2qlaqsAAyrjcUN9GXq9Vh5ceSTGlTy5Q9ZhW+BK3BIW2mfx8Z/21FW1cHhddAI
	EzyeQWt5b7HPGkt63tB6WihZceSNkwT9G+16/aWkV1rDPJ2LSG4C2a5FWhjfuH1MLebFLQ
	yTp7ck7XTrdd36JbwDm3fCO6nvi3ArA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KDUPZmYP;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793319562;
	b=jq3zNzucHrcTXXMBhJ8DQ10gKQV66a5HnDKMUgS0IuQ0R+NkLo+vhTL+949JMC4cN7UUvT
	tYvEwgdYnUuxFefkjCgWZSEJiTTZZu4id/ck6ffxV6darfY2WhTXKExfBCO7q05gr/H0uu
	BYq0bA2HlA3yprIquV80VpaivP2Wh7M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Z5Bh+KyvVIFM4C1bFYYm95MahEVzuEtoL1Ii4Fx+x8w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793319560; v=1; x=1793924360;
 b=KDUPZmYPkk0etsF5vk9qRRVxKTYD8EzUIKCdPb6EubtP3Cl09P3Imioey7zbHsKEtg7YAhqQ
 gPS4J9eJ5znUjmyWVwmm+XBiHnp8fTmUG6FhZ+Gnxd6k8Tsms2Fw7dqtbbpeRkJu7XWJgg+vw/7
 W6Bt3AbPP/qQucrT7q9Azels=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 174ca938c3421467;
	Fri, 30 Oct 2026 00:19:20 +0000
X-Mizu-Trace-ID: 174ca938c3421467
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 17:19:15 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: move LRU size stat updates out of lru_lock in
 folio batches
Message-ID: <auPhT70GU-Zqe9Qy@linux.dev>
References: <20261029204157.117879-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029204157.117879-1-joannelkoong@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 23F6040006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 43mau7gwii1fscx3g9gqttxfd9t8bu13
X-HE-Tag: 1793319561-424944
X-HE-Meta: U2FsdGVkX1/8FpBA76B0vo+x8mjy7Wt/NNlofbMHjzpNb2zCntbkD1cU+eHWozRJ9FZDVWM43+kw+Dt6iJgvw7P/fZw2eMaUMVU3RcEPtPw5stJ4v4mIv19+xcfwbE5S23ljlkySaolNl57e2H3M2dy7Bo68TqLIONXiza3miAlNC+Lvnooa8rLor7qUvB1gZT+5Fdu038PFhv8/P7zCPBmb2pJe+mi+QGQJyZLyQH+SzKAKmZg9wTDQEZMq/IFVXrEe1ofqX+2T5OtIFmMCpjGbM8z1/a3/FdK8Z4tzA31nsDJEp6WflBfRDMtGQQmm50SKxsVpafePECOlCH3tYh3k73QDWU41eVli8Vb0YApFjQi7zLEui/jgVyLyOZKx51U3UUchH01PVSXcOvMXxSvtC8WAV0j5eBz6kZQaISX/vf5PnCiwPWrQb13DDzTIwX6XmECPbmk2u6wGme09TtZcUSwuTeVI27tH2TxhmWik60mmuGUaiMUz36HN+VKorv0dRJBm2DlkZ+UNev07G4QDhsks3UZHtnWNm+tPXoEH+Fc7GsUXSBOy7CaD5UVrONEJ2tokf/igO9P0sfXZfYisydJ5YO3caGbeOiw2N6MPU9NiJf944XxJNf/s8P8zlPVo5mEq/YOwzp6IIjdQUFakPbl1r/V7qQlMthL9LUwnGohNENyBnMhEI7I0+fQiFukrGWPSjmTOw7faSyeZ2QTeRs0QzjL7+opbivzftB+j8TWg5YGGfWB1jT1mH/qom3h00VeRoOw0Qg7vDTXAHN8ZZd+WVEcFUjXk0v6Enf2+zyGL5Gd1rUetR9LU5qGuU+CU1P0LFG1uNHghmC9lOBECFYiiBIqW0aX8or4Xf4Fzct8JTGK87sYK7u5n8U8eXrr/rmPcRMYMi4H2MmxNv2CtvMCSkw1IOTxf2Kx+oojFus2d40rWnhaMA8brHBy7K3xciAb8hfK6MRHbbJQ
 kPW0IIQR
 z3i0FoLNkGBOUgYy6yano/4hYL4/xIGbWfZomzQlIanuh+RQrKQRM7vu6mZ2A+gafyO6VxmpZPniXXAcpQRyl9+/jVu8VT0xAfjVA9NNaHajNpaxD2iyWIwDTTnNTVN+4LBeiEs8F3q40LlzBwO0XqxqjWiudC/py24OMcnYkGfZ8szzrmV08wuXlmDYipXDBQIl6h4/ww0Yg9XpGaLrEvWIBmxUMUZ6xpoKUVQMfKrbmHhwjjy9FF5H712aAWgvHvvQciQMxKxl7yv6hi8mpp+yo3XTwcJG36TV7+PzzkcxNGnx/yDOZEb5Sdv4cG7i6at0iU3tDUECC082IK1RTSt+fpJ7FBkol+fDYHeEPl8nvV9jxUehe9noL0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 01:41:57PM -0700, Joanne Koong wrote:
> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
> once per batch, but they update the node and memcg lruvec stats for
> every folio in the batch while holding the lock. Only the LRU lists and
> the memcg lru_zone_size need lru_lock. Updating the stats while holding
> the lru_lock is unnecessary, and they make up a large part of the
> critical section, as seen in [1] where a change that added just a few
> instructions to the memcg stat update path cost about 2% throughput
> because the LRU stat updates run under lru_lock, and the overhead went
> away once they were moved outside of the lock.
> 
> With many threads faulting and freeing memory in a single memcg, about
> half of all cycles are spent waiting for lru_lock, and the hold time of
> the lru_lock directly limits throughput. A perf profile with 80 threads
> faulting in and freeing shmem in a single memcg shows 52.8% of all
> cycles spent spinning on lru_lock, split evenly between
> folio_batch_move_lru() and folios_put_refs(). About 25% of the time
> spent holding lru_lock in those two paths goes to the LRU stat updates,
> mostly cache misses loading pn->memcg, pn->lruvec_stats_percpu and the
> per-cpu counters. The stat updates are only 0.7% of all cycles, but they
> lengthen the critical section that the other threads are waiting on.
> 
> Accumulate the stat changes per LRU list while holding the lock instead,
> and only apply them after dropping the lock (while still inside
> the RCU read section that keeps the lruvec's memcg alive). This moves
> the stat updates out of the lru_lock critical section and turns the
> per-folio updates into at most one update per LRU list per batch.

This updating of stats after dropping the lru lock does introduce one behavior
change i.e. race between reparenting on offlining and stats update. I think it
is safe and correct though. Better to document it.

> 
> The batch is attached to the lruvec while lru_lock is held so that the
> LRU add/del helpers don't need to pass it down. To keep struct lruvec
> from growing, cost_lock is moved into the hole after lru_lock, which
> leaves room for the batch pointer in the same cacheline as lru_lock.
> 
> The stats can now lag behind the LRU lists by one batch, which is well
> within the per-cpu batching they already have.
> 
> On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
> CPUs repeatedly faulting in and freeing memory in a single memcg,
> average pages per second over 7 freshly created memcgs per run, 2 boots
> each:
> 
>                      before    after
>   shmem, 20 threads  4.74M     5.47M   (+15%)
>   shmem, 80 threads  7.94M    10.33M   (+30%)
>   anon,  20 threads  3.04M     3.35M   (+10%)
>   anon,  80 threads  3.23M     3.41M   (+5%)
> 
> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


