Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE17C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A04E6B00B0; Thu,  9 Jul 2026 10:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177226B00B1; Thu,  9 Jul 2026 10:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041BE6B00B2; Thu,  9 Jul 2026 10:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2E526B00B0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:24:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 320651C1130
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:24:26 +0000 (UTC)
X-FDA: 84969458532.08.21653DB
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B53A120007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:24:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Btk+aZVn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783607064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUy+Ri2pT7wvVY/ajX0BV3e3H7R/seUWuMeezghtcHk=;
	b=u/Aqe1xV23MTbAbKu68B5AGwDXf4kF9q/kfLaTJxo72jQNsq75ExN/ZmxbFNiYFURJyFnb
	Yq8x3+fzXt9t+kvsvPW9UC46vk4B0IaxsyHnmH14U+E0wVXZ8JOBr3uoVR6yYfbuaq9oq8
	5/V7sIZrXEGSimeo6rSs4tNUdkjHzuM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Btk+aZVn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783607064;
	b=cKPCRjhBglvCvVWUR1GxDAnY4oDNgIJKnSXG7Ms2XrWsy2zLi5MxQj6/tVryNUs0SOX8IY
	hSWjsuxq2Zt+Mb1c9mD9hR3gmfELseA5iD03tnEOk9Cn0FtXpeHHvF5DhYkONYDhIwmw8V
	o20BFyHt10E75RD/WsUrAzm2XRyCCT0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783607062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EUy+Ri2pT7wvVY/ajX0BV3e3H7R/seUWuMeezghtcHk=;
	b=Btk+aZVnVrfetD0/oZcoqxzqskUtquanN86nBAQQy2GMIakYKxG6K18qS76Eb9X434e39/
	TvJH+sZo7/dtDfDgg+nTqQa5FHgW7AALn/bO2K+ZBt7ZDy5exPzUJd+zdv2IRElB9yMvXd
	Q9FVDnwysjJC2HD9vFL2xq2PDCIZK9k=
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Subject: Re: [PATCH 0/1] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
Date: Thu,  9 Jul 2026 07:24:11 -0700
Message-ID: <20260709142412.91707-1-usama.arif@linux.dev>
In-Reply-To: <20260706122954.3552990-1-usama.arif@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4xqoarfe3oi5b4mszjhu4s8uigewf8eq
X-Rspamd-Queue-Id: 5B53A120007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783607064-636357
X-HE-Meta: U2FsdGVkX19YzxTS9uu+pp7JtQaVVTIFIsnJyBZnIynfJGlUidg1y1el8L6sMl/eE8eb2JyuuYU4spSonhaXXgvwZJ0oG/coo7Dx/KFpKpayDSOF2TXgnVQ6jERBf9HDHw5ecx6VXu8CuI98jThk7ppjOvblQrxs8sI/mRsIzoRGARn4k9LUyo/Nu54y6K6z5gE9/3i2epD6HFLZvbUDcTexCoFCXvCy4ZbbeVPTdaClEv+J4B0bfqB6opTo/EPIa7U4b9Th6Qh2Ap3FjVM7kzighugaLu7oWtNluW2iwEPn4u+7sTGcwDXgBwCUSpJ2W3eIT/Ai+8H1J8C4p4aTevWmaxzerY5c/qB6vC4gcvrUjccFuF+NrUYNUvA8yqLQG9XlhD93yd6Je30TAXctfGFyiYO1OFlcN4VbYr6CHKKgHO/jLO9fN5L3fQxgNoUEiD9KFFgfwbH4eyRmiPP2pS9m3k08QM+SoZofbhzhoe9k6xPqxt0513fo3quk9rUjTTr3/mkJUXzEEzBWbF0Vv+6Vs2YcsMOMd7gnf0dTh/ToVMXojXVVU3gbufb+BSWxZ0eGy8oqI0fxu14/iT8l1NszgqA3aiJ0MIw7u1xI/u9GEmGQUAhaP6VsuAyABnrVlwC9AvYp2r4BeVGx7oxnsM3+Jv18zfjnHG/9nu7YfhETCCXco4xRUgY35IbnzuKqztiFMbqJvTMVCz8Zqlbo1qXXU4FA2Iyj213Hix2XOVgrJ30bQeXnzniJwWPkR5SZl+irM1ShkGiG0ZGhBPTkve2r07qHN3w9FF5D0ETs0iuRsm/2uT9ubrZPy0AOQDum7ZRx8ZqxQTe6Bq+6LJpiyvTlbzh1nIsFwSQlhy2NAa3Rtg6AT9xooZ3mA8649x5diXHQ9S570s8PVFPAjbRy1kMpeAd4rm0Sz+P9zPNDRpGfFdjdAeSVhiQc6NNOMhEUHyUazlnYApuYWhohgi1
 koMWAcLN
 XIYFsLqXmBE/C5E704Sa3b9xq9HkB2ROFER1wWmF605BJQZ5lRK9BQo6vBLOcIBi3U4/mRsRTvH/xUdPNDtEFOjRudm/Nr+wqPq05KicpKtbfaQnGN6nGzGG/0yqCrPaVEghJIVOnWDlfJngTEAjE0ORfnB+59ofhxR+iVVwP8wGjDwcFwqYFAHNCMnXnSF1v9SM5Yjg094p6IcvNs5VyzqJqf+LgjxzKYN2htdgnh4D7BZo3h4qB/fyAfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 05:28:25 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> The anon/file scan balance heuristic in get_scan_count() is fed by two
> scalars in struct lruvec (anon_cost, file_cost) that every reclaim
> producer updates under lruvec->lru_lock. The cost-recording work
> itself is trivial, but it both contends for and contributes to
> contention on lru_lock - which is often a contention point on
> memory-pressured workloads. Specifically:
> 
> - shrink_inactive_list() re-acquires lru_lock at function exit just
>   to call lru_note_cost_unlock_irq().
> - shrink_active_list() does the same after rotation accounting.
> - workingset_refault() takes folio_lruvec_lock_irq() purely to
>   record the refault cost.
> - prepare_scan_control() snapshots anon_cost/file_cost under
>   lru_lock.
> - lru_note_cost_unlock_irq() itself walks parent_lruvec() and
>   re-acquires lru_lock on every ancestor, multiplying the cost
>   of every update by memcg-hierarchy depth.
> 
> This patch removes those producer-side acquisitions entirely. The
> producer-local inputs (PGROTATE_*, PGRECLAIM_PAGEOUT_*) become
> per-LRU vmstat counters; WORKINGSET_RESTORE_* already captures the
> refault input. prepare_scan_control() reads the raw cost signal
> lock-free from those vmstats and folds the delta into a per-lruvec
> accumulator. A dedicated per-lruvec cost_lock, not touched by
> isolate_lru_folios(), move_folios_to_lru(), or folio_add_lru(),
> serialises the accumulator RMW and the lrusize/4 halving check.
> Hierarchy aggregation is implicit in rstat propagation, so the
> parent_lruvec() walk and the lru_reparent_memcg() cost-splice both
> disappear.

Another update on this, I was profiling another Meta workload that suffers
from very heavy reclaim and has a lot of cgroups. I ran:

bpftrace -q -e 'profile:hz:99 { @[kstack, comm] = count(); }'

The biggest entry was below:
@[
        lru_note_cost_unlock_irq+146
        shrink_lruvec+1913
        shrink_node+869
        do_try_to_free_pages+197
        try_to_free_mem_cgroup_pages+311
        __mem_cgroup_charge+1832
        filemap_add_folio+127
        page_cache_ra_unbounded+347
        filemap_fault+956
        __do_fault+40
        handle_mm_fault+4034
        do_user_addr_fault+406
        exc_page_fault+105
        asm_exc_page_fault+34
, Func___]: 5354

5354 represents 51.42% of all kernel samples collected.

A very signifcant amount of time was being spent just in lru_note_cost_unlock_irq

