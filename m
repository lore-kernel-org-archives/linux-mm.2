Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F04ED3CC88
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 01:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08436B0005; Wed, 14 Jan 2026 20:40:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5846B0089; Wed, 14 Jan 2026 20:40:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2216B008A; Wed, 14 Jan 2026 20:40:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7F5F6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:40:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 839A6B67AF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:40:36 +0000 (UTC)
X-FDA: 84332493672.20.4246A23
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf15.hostedemail.com (Postfix) with ESMTP id BDE0FA0003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:40:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wUZCjXnn;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768441234; a=rsa-sha256;
	cv=none;
	b=MHmNOoAdZIqwNrYX7Yy9ZxQnYR+7uCN1WMg6/EY2ZuttJVocG8k+3Ue4PpNRWOyzeXpYjQ
	v28qiDT7cct/MJqOPLxSU+e/fCZMwbHWGqjabxBARnSfNVMibA1mGrkG+cA0459NZT9CE7
	wIQz5eOIVnj5t6kwhQoEw4ZLy+53FQY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wUZCjXnn;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768441234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80TCqG31BZccfJd1y9d1qf5FUP3rjufN8RqunSRYkQE=;
	b=t3bQBV50sKF2V93zP25GByRqXXbwTUg58JCPgt1STAFNVP9tDIuIn9ONpboy1KUqfT0MCO
	TvniZMKROi7OQ4SvNspyNvtv1PzIslZDq4AzFJ+oJj6jJlbqSPSmTvDrYoB3a3KAnpANoo
	JpHNc+v94rqWHSqSe7Z0qZtYNWlL6Ao=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768441230; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=80TCqG31BZccfJd1y9d1qf5FUP3rjufN8RqunSRYkQE=;
	b=wUZCjXnnWC0aKV0mvoBRJCYL2Q2xvI3qDItjuMgKFGrI0EwJoEtzjqmHo5s6wFgpkc4eGqiO7VP+8sLaYLQjbswu/OvLUkMRvx6j6XklzoI0ZLZNGg561963LP7xhJjChX56aKk6ADpZupabVAQ6Hb2sllMzNfeLNNxTYUDaduY=
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wx4h7kd_1768441227 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 15 Jan 2026 09:40:28 +0800
Message-ID: <03529c5c-daaa-4999-b1c0-32ba1590db4b@linux.alibaba.com>
Date: Thu, 15 Jan 2026 09:40:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: Fix OOM killer inaccuracy on large many-core
 systems
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
 David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
 Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, stable@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik
 <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
References: <20260114143642.47333-1-mathieu.desnoyers@efficios.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260114143642.47333-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BDE0FA0003
X-Rspamd-Server: rspam06
X-Stat-Signature: egmfnxus8o3urzcx5re6bqx8z8exjc3k
X-Rspam-User: 
X-HE-Tag: 1768441233-3142
X-HE-Meta: U2FsdGVkX18CSrSsBVuDzx7OIkQoQLshuxvKQ6/U0kZ2dfIbeYYkfrjSyOY9AaFHtON41+ROzKs3PIAg/TPjds8RJstr1kgEuv7KTgCzLoA/zpdjV5ysDxHsiEVgZyKV02dDASX6GAAjs8pF3DQXZk2Fb8UZVpVGj8I8/kx8lVEdaHQLjnvTS/l6x7ZID54UQriZoB8hID5WLe3BcEct5UcBix2c15ZEfgTAPG3BoHzlxATjrPr/gA6Ma+BD+pJ40YbO13uK6rJkW9o+Df5Gp55YWcg7epWY0essXFw/La4B0jRqD7RnMGkqvFutpYTnxeWpVR3BCCVlnoIrzWjdpskR+e54YEcqjXXNTdCfAXq/IJzFseryEGbqnrcpPo5pc1BIwTK5XVo8oS2QDl7P9mbzVsqWIQnOD6WQPYzaA8W7Emga1wCiW4BJDj/sa8X8zp5QRR1o36f6HytYHGpqRVJf81sAuruMZKHcgnC4Z5wgnZzHbLJPY5ALWtGwvjw9tZO2Irjb/eqB/qIlzhjpJHEQZqTSbffNK6dPzNOXQOS+InHWws5ujOVytVU/7QpREbaI4yagEBDVKffJHmDE0QRfQYTQgm6x+KHULQBnyfZ+ryrVpkj2mCH8bXwFP8y4k3g4tO2hQkRFozTnNtS5zPLxYv18iskTDccqsRIufCMpQldwoLkSz58TZyDe3AU1B+sIp7N4aoBa4XBrIonnelQHQpTZSwPJvIkaX3bfHiwRV0jUKgKt1S94gUU/Cez7NDG6Ztlyzqx5TQdNrC6Su6t1U/bRUO+zmj3zLDvoXzviW8GW2subfWAoW0zBhoBs2ltTzOxh5yH7nlxEInHssNMVGZQsuFi8oB+R9eOIctyNQYC+mOW6Ck2vQkdrEdps+dMC/lPF2DOwx4/Gbu4vo6JjiFHEws/IvgodL6/WYm4SlsevVlCrtlDB4qgqe7jTlNPAu0GqJBoN7vRhhsj
 TCwOXoN6
 v22ZOT5AmIv/WabNs9072ssxc980Jk+OiNeAs1sw7fxg9NHK6i1wl1U/LDVUjB0XmbTtizPiKP16W7x4DX/FYoXeYYYQdFP+RwmnxTmnttAlkwtOCSAMh8IzLVPU0WzmvABc4nprtk6kNvpXOL/NDoabYvPktIKZQsm8MCuVUnAQWZWMfyIcGGz4N0MnYUkZBWBY17+Cc621vZST/FMqFbUGc+1HVOTxqQmRDc71EkU/FLGWPymZMtuz/Yhm2hLGXoFH2HPIufDKuade6YVldiJIBkn5bT6IpwzMZ0m6BbZujqKU1O9uMHXKP6NVsiFi2TYQramMi4e0afA7/YoPVEnhzDKwEMyiivYBEf2QRADo1bQKwA0gZeMoFg9yvYBmG5kWO+PhedsRcHB8vJ3ZScBITl/jp0NkgwvbbBh+2zHRmJlgw8B3i551rhrppouzOpRz4x8nKXgbtRrD4OeH38LVEQ3Uyc82dBMaF2PggnSSLiuMGhGp1Nun+lJof39WHB2dtU6IfltWlUdxLK35t0RXnO8IT18M47PIfiGV9YoNobIc39hnraqTCuxZwkakurqbAUKQUYsK7E++TQh8WQMqRpW7CM34MhnuftfIX2TFMvX1nhANseu/RZi9vBNzVu9E0r9NcFtZm8hE/JoQEnCCEfQF4vxTApWh9S+O76uNjn+ibIHrCCR5yaKIqfBvcCa+fPn+jIrfsqYhJGNI5e5YFMQgmGe2+/JqAExVJ/lsCVAKqmFH8job9td7DXv+wmCQ+yTHSmrSj2jsn4Cz2yOyxsK0jAHCkCgdtQr1TbiVkVuitAtpkTuqak3Fnbni0ci+BVH7tp30z7FvB/Wdte9GGieZGzK1ZA7f+DufZvPCnHYtmIuEYZtLVvo8dNzrnUU065gV2IV1K/fBgN0nnqFiwWnRydcsuxY139Nud+2GAhiRJMY77FiVASiP+Av/uj7n/SjN24vkiAKRwR01lEX6iS6yo
 SnStwrt+
 G92yx4s19w4CMJ8vQBE/0Kt4DqJTEtlHrfXNuosA/9hhXwoICZ2gD4ElRVdHOJjEclpJZSAiNFQWDr0pFRWSihq/NMq6GmPAETB5g+logluPlygkjO2Ijw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/14/26 10:36 PM, Mathieu Desnoyers wrote:
> Use the precise, albeit slower, precise RSS counter sums for the OOM
> killer task selection and console dumps. The approximated value is
> too imprecise on large many-core systems.
> 
> The following rss tracking issues were noted by Sweet Tea Dorminy [1],
> which lead to picking wrong tasks as OOM kill target:
> 
>    Recently, several internal services had an RSS usage regression as part of a
>    kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
>    read RSS statistics in a backup watchdog process to monitor and decide if
>    they'd overrun their memory budget. Now, however, a representative service
>    with five threads, expected to use about a hundred MB of memory, on a 250-cpu
>    machine had memory usage tens of megabytes different from the expected amount
>    -- this constituted a significant percentage of inaccuracy, causing the
>    watchdog to act.
> 
>    This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
>    into percpu_counter") [1].  Previously, the memory error was bounded by
>    64*nr_threads pages, a very livable megabyte. Now, however, as a result of
>    scheduler decisions moving the threads around the CPUs, the memory error could
>    be as large as a gigabyte.
> 
>    This is a really tremendous inaccuracy for any few-threaded program on a
>    large machine and impedes monitoring significantly. These stat counters are
>    also used to make OOM killing decisions, so this additional inaccuracy could
>    make a big difference in OOM situations -- either resulting in the wrong
>    process being killed, or in less memory being returned from an OOM-kill than
>    expected.
> 
> Here is a (possibly incomplete) list of the prior approaches that were
> used or proposed, along with their downside:
> 
> 1) Per-thread rss tracking: large error on many-thread processes.
> 
> 2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
>     increased system time in make test workloads [1]. Moreover, the
>     inaccuracy increases with O(n^2) with the number of CPUs.
> 
> 3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
>     error is high with systems that have lots of NUMA nodes (32 times
>     the number of NUMA nodes).
> 
> commit 82241a83cd15 ("mm: fix the inaccurate memory statistics issue for
> users") introduced get_mm_counter_sum() for precise proc memory status
> queries for some proc files.
> 
> The simple fix proposed here is to do the precise per-cpu counters sum
> every time a counter value needs to be read. This applies to the OOM
> killer task selection, oom task console dumps (printk).
> 
> This change increases the latency introduced when the OOM killer
> executes in favor of doing a more precise OOM target task selection.
> Effectively, the OOM killer iterates on all tasks, for all relevant page
> types, for which the precise sum iterates on all possible CPUs.
> 
> As a reference, here is the execution time of the OOM killer
> before/after the change:
> 
> AMD EPYC 9654 96-Core (2 sockets)
> Within a KVM, configured with 256 logical cpus.
> 
>                                    |  before  |  after   |
> ----------------------------------|----------|----------|
> nr_processes=40                   |  0.3 ms  |   0.5 ms |
> nr_processes=10000                |  3.0 ms  |  80.0 ms |
> 
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
> Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Martin Liu <liumartin@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: christian.koenig@amd.com
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
> Cc: linux-trace-kernel@vger.kernel.org
> Cc: Yu Zhao <yuzhao@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
> ---
> This patch replaces v1. It's aimed at mm-new.
> 
> Changes since v1:
> - Only change the oom killer RSS values from approximated to precise
>    sums. Do not change other RSS values users.
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

