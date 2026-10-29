Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C52606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pfoUasuV
Received: by kanga.kvack.org (Postfix)
	id 064486B00EF; Wed, 28 Oct 2026 20:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C366B05B1; Wed, 28 Oct 2026 20:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93FE6B05B2; Wed, 28 Oct 2026 20:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C78336B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:41:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B0DF1401DA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:41:13 +0000 (UTC)
X-FDA: 85373809626.23.3DD0354
Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3205320006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:41:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pfoUasuV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793234471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgify3Ps3ysA38ANbUdTtbw6FPLHnNTTLVy0kFUYagE=;
	b=ueUZvTWWUb3xGx1kRyBCijXQZLYk3YqfB9czFHhHYP1jazZYKtbzZm+7gNk/Dw/TheITWq
	stcloXPiFhFYeWeW4hd7aLUWoRXXEyPjqN5LQuSdcvc7L9XXDtUDgBSse757NIgkeY3SSG
	24WiSq1MvC2tn957L1tZ+CFP6BihnXU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pfoUasuV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793234471;
	b=oHwtN7BQNv53o/Hn9ERS7wQLTbw6s3uud+Q+GO8KWyUia/NNU+mYZ0KmWNi7Cm6kFV/PDE
	tB1kugfNXF9n4V3vYxz0WAAsSHjoc8QaAr1VTb86UtasTIzBkCOcudIZ0EnsWiZWJ77URD
	ehW8zf3Qq3m8XUpMnN//banDmfl5Lu4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nrCLj71iMMOCDy6LERksd1mB3zJ6XRfaBd4m3WwX4io=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793234466; v=1; x=1793839266;
 b=pfoUasuVHU8xtonQVRHvgBW5mvpHwrKVB4+aOtplLC4BSTYmwzfe2Di05uAnlkDsFOzUWX9q
 39nzQ4QZ90IQJtqjudTdQm2Xw03RWallAYPrDMle5F3LL3Lc4UxSIYWAxK3GNhwfai/lNfQEp+K
 0C7RbbKGb1eG5lXM6GgGz+Jg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 07904de55bd63c7d;
	Thu, 29 Oct 2026 00:41:06 +0000
X-Mizu-Trace-ID: 07904de55bd63c7d
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 17:41:04 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, yosry@kernel.org, 
	joannelkoong@gmail.com
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
Message-ID: <auKSeCFvsWzP-XYy@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028185034.3607746-1-kuniyu@google.com>
X-Rspamd-Queue-Id: 3205320006
X-Stat-Signature: umjaoinkqskqk4y9uxxexzabwz4bcyff
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793234470-101940
X-HE-Meta: U2FsdGVkX18uk+Afy0TjbNRodMagvmtG6gBDnmzu1n+XHs+zVC5qdCmXtbluRIwtU1uQB84LB/VIQEGEG5zT/KBRCxW15RvhczPBD7L/pIxvCf2P0dD7OHqZ8HC4yCrn0cAgQrJNOEpLvc8eQxN+y6cPQE7bUMCgyzCuXYgZuwQ8X2AmdVFNZLfVKdepqmwMQM+3AxCcKGtJpDDTRtfLLlC3U9KWjACXoxck7i7liwSzRumvMI0EWCUXlf5x//cJzAVQJ6zxOSEmMMT3YlLxNJrpVgWL9DDqp3AeVjEkypgXIpPf8s/V3x0CA2mwFJanV4lxqQq2z+m0Zkrszkr2tUma5VMAxJX7xaKs6Ub5NAe5F0L04pjQ2Nscc4aFCTAzdMaMgTY25Y0F9AwDwONzou4CJiFxVFYQbSImD6ehHERkP3GlvzFgd1ehvUd5XWUxuAWruYRggM5ON4gESOaWk8K6xWO5pjiCkjRrMNTTEWYa0ElGWerJ1d4iXf/H+HsUjXYR5LtOUVJR55Wjbc9QbptlFs0tOql1HV6zFL73E3/MtseXosV89cQmR9tLOY52TNrantbf9iF1L54CIbp4YFhkM6rbjHMzDiq6tKxz8RtW7lBCCLKmm5kErIxhwj2QTaMwF0yw6nwYCQz1kwPJszRvpmTu3ClOCAtIisNRmqSPSrBPwDmg/yHWgAXeXwDkX1Xaw93V6fXTZT0WkQAC1e7kWfaGFvBj7MYWzhZZTnQcPzL/5m3TdWRRfRmB5yzrfsVcYXmp5iop1/SHsaBE5iQ/rzPpqb/bCTJX4MrB4zTdFjm3e7v2OtOTYd6VtQglW0jG+gn+z8+QuqmUuZ1JAl2KRNzUS0YUiLvhcO2O7KIIawPiqiisaVwlGagdoIf5QRcoPk/mtap+j9x5vNJ7npcJ0DPnyvwhT76IgGndSk6CpFOwrkxoWzTk/WfYCenHMZC30xM+hD+91G8QchB
 BOcIROxb
 qiGk3wWb/0k8/Tg0lU4T71jMpoZA6eLZRmv2c53xtz1TN9xZYY5F9uvNlWKn1XJcOiPl90Kf8t6RaASLxEN0lW77aKMijKLlWwaHAu+NCMVBV7T7GaCQYQbEZ0QsdSX7rTJ/Pt15X2b6m0ja+Y4HHaF9no3pvTKPEsIBSgNxgVsUdZArb+YxZCm85W3/Kgo/ja+yipIQa49CrHM74n8UrEVhppjskHOyohUP/PNEZr0Z3i6hzATMOPfc2MdajlEE+V7XVGneVH/+qIAuKNV+D+hSvWMvG7Kys34zDr544spsq5AoeyPd36xec07j09ddZ/40cpZsRYfos35o8GXwD9Vaj5/M3f3Qxe9gCFi6B114SYhvdBTP2ptH9Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 06:50:12PM +0000, Kuniyuki Iwashima wrote:
> On our production fleet, we saw mem_cgroup_sk_charge() spent over
> 3x the cycles of try_charge_memcg() although the former should be
> a thin wrapper of the latter.
> 
> Looking at perf during tcp_rr, most of the cycles were spent in
> mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
> due to cache line misses. (see patch 4)
> 
> Also, tcp_rr w/ 20000 flows throughput often degrades by ~50% on
> many core machine. (see patch 5)
> 
> This series adds nr_sock[] to struct memcg_stock_pcp to batch
> mod_memcg_state() for MEMCG_SOCK and move heavy operations to
> out of local_lock(&memcg_stock.lock).
> 
> With this series, tcp_rr w/ 10000 flows achieves 31% more
> throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
> Processor (Zen 2 Rome, 2 sockets, 256 vCPU)
> 
>   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> 
>   Metric                     |       Baseline |        Patched |    Diff
>   ---------------------------+----------------+----------------+--------
>   Throughput (RPS)           |     20,884,499 |     27,466,490 | +31.52%
>   Latency Mean (us)          |         478.46 |         363.71 | -23.98%
>   Latency p50 (us)           |         453.96 |         356.68 | -21.43%
>   Latency p90 (us)           |         669.00 |         479.56 | -28.32%
>   Latency p99 (us)           |         969.38 |         617.80 | -36.27%
> 
> 
> Changes:
>   v2:
>     * Rebased on mm.git/mm-new
>     * Add patch 5 for flaky throughput issue
>     * Patch 4:
>       * Benchmark again after rebase and update numbers
>       * Check in_nmi() in __refill_stock()
> 
>   v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/
> 
> 
> Kuniyuki Iwashima (6):
>   memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
>   memcg: Reduce nesting in consume_stock() and refill_stock().
>   memcg: Annotate slow paths in consume_stock() and refill_stock().
>   memcg: Batch mod_memcg_state() for MEMCG_SOCK.
>   memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
>   selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.

Decouple the 4th patch (batch MEMCG_STOCK) from the remaining and send the
remaining patches separately and upfront.

For the 4th patch, I would prefer we first try to move the network sockets
from memcg to objcg path. Then I would prefer we optimize the stats update for
all stats instead of special casing for MEMCG_STOCK.


