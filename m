Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4015D606A33E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UuYi+P0t
Received: by kanga.kvack.org (Postfix)
	id 64E8D6B05B3; Wed,  4 Nov 2026 18:03:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6001C6B05B4; Wed,  4 Nov 2026 18:03:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515926B05B5; Wed,  4 Nov 2026 18:03:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 296BD6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:03:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9E661608AB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:03:02 +0000 (UTC)
X-FDA: 85398963804.10.E6F3E34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 96AEAA000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:03:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UuYi+P0t;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793833380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtDJVlSwaDZV2kPnN+e71gVYTRxFI7GApJtZA+uD56Q=;
	b=tGJJ0vBhE0tuXr9sLvLloRYrZK6XQeRfoOTZCNglNAIeu3Vhq/7jauxLsC74Wohogarjkb
	SXX6Xq7tuIW4zPfDC0Uf79hrA2HU2N7p0um+rJ39TUeOVykyTIyVgAXcWYQzThHZUVvpxk
	kWTCLT5EwDyKSqSyqAcYTNyuCHPjPAo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UuYi+P0t;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793833380;
	b=PcXBusC/0SRyNV+kbyYX5Vixch5prbEtvHEdDC6hriLjGF501Xs6juLZu7xrZqS3f9z1pG
	pWS5TnuN8CdhmmvhG3LnnC5hlj0SO1J/jZkvFJz9u6IdvwIxtjNGSkuu4MOdwOMBUoROLC
	5Si8U2Q22zEr4INTRJYqYdwlKSfZ6MM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 679F043EB3;
	Wed,  4 Nov 2026 23:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9BF1F00A21;
	Wed,  4 Nov 2026 23:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793833379;
	bh=RtDJVlSwaDZV2kPnN+e71gVYTRxFI7GApJtZA+uD56Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UuYi+P0trryxGTFIB7MaSORDfU4+JZ1hS7sHUVk1M7row6E1je8aH4BekGP7golkS
	 1miU+ExvCZpGvWuGN23th4WuCq0iCxaVaUWeLE5/5xT4vnZDgSEXoCChzWCZNt/h+v
	 4srV9O8Mpsdtmiqvst4vAAkRpWRRM0wVDOdCHVPk=
Date: Wed, 4 Nov 2026 15:02:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Kuniyuki
 Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 0/4] memcg: Misc cleanup and perf improvement for
 TCP.
Message-Id: <20261104150258.56cf6be2efe442cdf5ff8da1@linux-foundation.org>
In-Reply-To: <20261029194452.3189365-1-kuniyu@google.com>
References: <20261029194452.3189365-1-kuniyu@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 96AEAA000F
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: yu7jmdg88tye7d8eiyuuh3y169qt9rn1
X-HE-Tag: 1793833380-376046
X-HE-Meta: U2FsdGVkX1+TZe0zLt/FXWDBAC6DmAEbhHZ6CbPBa06S5lz8vsysCd+uu3KqC0lP7+G0Ry7TIdkCQ918lLEURWluVttHVyQFGGUdHMYPWqUDftmqX7stPOI4NYrSfAfiQ0ChyXPw98dfJxJ9WgR2gcl58NpjGQJc9E+w/v2J6egxc7wf1wdgtSLvMmPbMLpsbei0RlWlY09kt2TJaDhsOo94P5HAr4BDbT27MI9S09wsJpSsYuzkhzWaSW6aiE8WXHUpm5CwJFuNIg+fQEkgGT58S/4YSZR9nGYzmXEExEIk6DEKrQmMvILFTO6Cu9Uo/k++ndChb/585QJGw4bF8AKdL5HlWgt54OlAi60oww0UUUDv6WKd642h5SJUYTibZBoj8Gt5yVjl0+dMwixrU3ECYlFwsTGbH+Noyg81jcW66knCWRRV4CzuemaUlVopjd2uzm5SCPGBuDxjqE9MNY3u5nEFpqNaQRhfKA+etrAvnMMwfuOj6Aa4Uyu1RB5cQ/LHHIep6AXd+zf3CSEl+LMFdPoCF6qF5JQOUJLl3Hibq6xNy3Coxaw/Qhxn3qROhk0iogxo1EsDecuU+FZ0YkoNb8jhnr7XWfbANvbrfO9klNm2YgdiB3y7MMIAsB83l4ehp4P9b5FVyhhYzgTs25txmBqXTTsWpIhgwU/1s6ia21bSo35iDKVb5bn/1peSQsWkO451jg8qx/qP6GaaQrz0djGg3gkZypm7a8GxcLFarLcxwSHqt4aKEEbklPkJfNVwn3DC3gFnuy+kbqdqPT62XOjI4Rjy1yE3OasS/3GSbQgDGrbnSAt/EgmY7+TTnHgdDN3zKFfiadc6RKwrV144pJOT7C1Usls4rTVmsadgu5VXsZgjOUECsqNOeTV6YkxQY06jdcQALjKeeUyijPns9RMq4TrqhhZBnES539yZYMaAgNaqry0nTO7kI0loCwdzX/0GmfAx23ucPBX
 UdTOSKi3
 /FTSeuU8TSu3Y4N/YpbqfWCDf/0NQkDqGCBYGYBJtoo1u6DBdXbBnJBJKfx7M8CA400gDSN3/rVZ6AQ52juWnsVM29ohj7h8IrC+JXMZNnRpsTFkPnyAdlhTb4YzzKZ5mfOHihV088HST4SL3XOxDzxNL8Al9dB4ctuiHOkLEJPuI5HSGEj6DzRIZcUeImBIEoJEX3M1wzW4jwDSfE5zMOrjM638vateAFYPauTkO5kiHv5LpWOkgslqjYBsnZ6ol2OIRpBrgdX6/qzQzkKZUyj+WIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 19:44:11 +0000 Kuniyuki Iwashima <kuniyu@google.com> wrote:

> On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
> 2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
> degrades by ~50%, 32M -> 17M~27M.
> 
> In the bad case, the number of involuntary context switches
> was extremely high by 12x (241733 -> 3093367).
> 
> The root cause was that refill_stock() calls memcg_uncharge()
> or drain_stock() while holding memcg_stock.lock.
> 
> Patch 1~3 are misc cleanup for better asm output and patch 4
> moves heavy operations to out of local_lock(&memcg_stock.lock).
> 
> This series removes the flakiness and gives ~3% gain on the
> 512 vCPU platform.
> 
> In addition, on machine w/ AMD EPYC 7B12 64-Core Processor
> (Zen 2 Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves
> 36% more throughput with lower latency.
> 
>   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> 
>   Metric                     |       Baseline |    Patched |    Diff
>   ---------------------------+----------------+------------+--------
>   Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
>   Latency Mean (us)          |         478.46 |     351.07 | -26.63%
>   Latency p50 (us)           |         453.96 |     343.04 | -24.43%
>   Latency p90 (us)           |         669.00 |     479.57 | -28.32%
>   Latency p99 (us)           |         969.38 |     593.92 | -38.73%

Thanks, that all checks out here.  I fed the series into my
LLM-controlled live kernel testing setup.  tl;dr: no correctness issues
but the performance gains on this setup are much more humble.

Gory details for the morbidly interested:


: I tested all four patches before/after on Linux 7.4.0-rc1.
: 
: Correctness testing used a four-vCPU, 8 GiB Debian QEMU/KVM guest
: with KASAN and lockdep. Both kernels passed all 22 memcg/kmem
: selftests, cgroup/socket churn, guest CPU hotplug, socket lifetime
: across migration/cgroup removal, and payload-checked TCP transfers
: under memory pressure. Final socket charges and dying descendants
: reached zero, with no unexpected kernel diagnostics. Traces confirmed
: stock trimming, eviction and fallback coverage.
: 
: Performance testing used 56 guest vCPUs pinned individually to 56
: physical cores of a 64-core Threadripper 3995WX, with 32 GiB and
: KASAN/lockdep disabled. Host and guest each had one socket/NUMA node;
: the guest exposed one thread per core. Neper used 10,000 flows and
: one-byte requests/responses. All 24 runs completed: three 60-second
: runs per kernel/condition, with alternating A/B boot blocks.
: 
: Median throughput changes for the full series:
: 
:     Workers per endpoint     RPS off     RPS on
:                       28      +1.21%     +1.38%
:                      128      +0.14%     +0.72%
: 
: The smaller machine likely explains much of the difference from your
: 36% gain. Your reported systems have two sockets and 256/512 vCPUs.
: Here each endpoint had just 28 vCPUs backed by 28 physical cores;
: 128 workers oversubscribed those CPUs rather than adding parallelism.
: There was no physical inter-socket traffic. These differences can
: reduce shared-counter contention and the lock-held interval behind
: the RPS/charge-fallback/ksoftirqd amplification you described. I
: exercised stock and RPS paths, but did not reproduce your collapse
: or establish comparable amplification. This explanation is plausible,
: not demonstrated by the measurements.
: 
: Three conditions consistently favored B; 128 workers/RPS-off was
: essentially tied. Frequency was uncontrolled, limiting sub-percent
: claims. Both kernels had VM CPU-feature/watchdog diagnostics without
: an unstable-clock message, and softnet drops with RPS off.


