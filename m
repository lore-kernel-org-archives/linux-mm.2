Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33377C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B2E6B0092; Mon, 14 Sep 2026 22:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC036B009B; Mon, 14 Sep 2026 22:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC876B009D; Mon, 14 Sep 2026 22:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4E1F6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:30:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0792BC02E9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:30:59 +0000 (UTC)
X-FDA: 85214419038.16.CBB9C54
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id A81D040003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:30:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="b/cTbEK0";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789439457;
	b=HS43EwZ6tkXyWQCu3N03YOtsCyyOlLgSQzBzX5ymeAF7ZGtDcw/HqeHp9VwWYlaEXECJES
	PTsmkJ7nheOdO1f+wvJ/9I4tm/no+dZl+ehfkWtxmBbhbgNNP0bjbAZ8g+wMhA1+LQuaCS
	x/nmiz+0qIexNQjv/SkGiJJBFkwPjYk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="b/cTbEK0";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789439457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3zoP75eshcusIq4zAJHkrJgPYj9IyXUMvCpsktAJxc=;
	b=r0t3mtgowZwuIgL+spIi4MJL1six2/qzJQ/Yf8vhKOH58DLsEBujJZNqykLXS3EcrRQiLF
	J/mAod5h3ssrCZoFzMN5ww+0fOM+F6L80Di/MAAb7nIBvJ4+h/tG83G0qV0gv+J3vj3qCC
	PX1oUl9hDU57YTRCIqzWVTCdsAA4l2Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789439452; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=T3zoP75eshcusIq4zAJHkrJgPYj9IyXUMvCpsktAJxc=;
	b=b/cTbEK0eBsOWxbTfyoZEpLFf+tCOC2DIBtyGHCPxFzQtnZ3bIjoU22yrrqMPI2jjscKXVu5PgpJbjORNQk0H9k+cLBCWA+b/bJr3UgO45SQJMKvpSZHUknRS4MuurCYAOw3a8yNVjqPhPafIbGGfhANgH4HiVc3geZy8NufXFo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XB.cn-a_1789439451;
Received: from 30.74.144.126(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB.cn-a_1789439451 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Sep 2026 10:30:51 +0800
Message-ID: <1abcc4cf-fc84-4dcc-947f-8733df44e625@linux.alibaba.com>
Date: Tue, 15 Sep 2026 10:30:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] mm: Improve pgdat_balanced() to avoid
 over-reclamation for higher-order allocation
To: Lian Wang <lianux.mm@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Wang Lian <wanglian@kylinos.cn>, Kunwu Chan <chentao@kylinos.cn>,
 liz2nku@gmail.com, xueyuan.chen21@gmail.com
References: <20260422021842.78495-1-baohua@kernel.org>
 <aejtfpBUu7gNV6Tk@cmpxchg.org> <20260914113353.94964-1-lianux.mm@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260914113353.94964-1-lianux.mm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A81D040003
X-Stat-Signature: idetw3zu5g3gwbu5sfcipkrheaj859b7
X-HE-Tag: 1789439455-517969
X-HE-Meta: U2FsdGVkX195OfsfD8sGJqQCz2t/5HBJopdtauzgoEzkXBDKjFZne37cIa9ieWSEAmHs8nQkj6n7S4cWb2ZdUOccNMbkzod84buu2zOy26MCeUzTMjqBYSCje73hNLMOTFs46NtOPpwQt/wS9KoefvRI46EX8g7pXlgMR8eBI2xbO6orrTdsG47+WolTMKwVV+Ibw9Mv13iVzExyEEDhFgE4vn99k41AljPOH3OidQKjjgENN1FVIo4IlcNgGmCe56ZRy7zRJSFAZD5KVVJcLv67//k6GBKaPZNTwdVe98X1MaVJmKfmdDv1qKjD6cj5Nz14sxU2ffb9Bgsl+ydQg9Kd7wuh26AGV3jB/qt7LyJ45+Er4koqAoJldiT8IKrgRAvVhSe/yUVMc+SvJq0a3TGVbSkr2rbh4V3fKcusrm+voowhX8vl17gmwAX1IKo/edfxJjj5o26r0orKBMzZ5/p1EdQJGdzXHX108MVK0tzBBoXNrye5CoC7JPAj4XqsuuTIznzmmhYZakM7aRpHcxlYG8AaDHtfx7SkueM3LlHJOcQ9zoYLyS49wIPAJchlq+/qV1RgahW6r0Dczp15ILPLEooO9EnwnJtvwkvfGcrNdBHRpEWHV3vZd6ExkBCrSF4/N7MWElM9so7k/XNu8WZV9bWh2EFSEy3VahTMahLo+sWckgRsPdwQS6OiPHkDfOl3cmu9E8NesRXE3iezn1S67+1asfD7ckedBQnlYBUfrEbNg/rX4sdWA0EP5qBbQ22wu4USGFGVC6D5EUHwMHLd09PSEQKmHOnk045p686SixuTn33Ui+GJ4eBS0OBCB8/oPHrR78HQHS2iZiCz81xarXfBxjBdmwA/om3u7gxb94iheviwNZU0UHAOVL2GnSh/LTJrqIcnZJd1hKcSuhddQgP2JpnBznvt8UhK9hamFVLPWoFS/QjaHiMAaMf1yf37KpL8t27zRQ6v0sp
 rpZrXVhm
 7MoK6ee3J6pPwCi6CkfRl/FRwWwTQYR2i/K5ogrQNUDGt2mo+p3b0ykmW+N/ecMijyD5taqwGQgX4PJXuPh6PI9U7GkLLprZN1+/noPnbmVfuY/NBLj5S9E1gQaIzZNpmz8rTSqa0qJ3yTAkedIn5w4MdZSzPu6Qys1ede1jtXi6ROntI9SKin7SCGE/ntkrrs1dGwvSo8o7fjIMfs95orZGoqLo6Xh/+dy/mPZBwj5j+19e6Q+hdCZl2yrSc3mwDGybTBWx694eGh6fX+xGbrvPbkd/sY5ADliBHUwwmJexu8qmjYdrlQCWDxnmCbVYuPTdBtdy9ADNl70mow14nyYmKVReJhbaMLb1F2L0H8+Ut3pgSmWoT1HfzZrMpe7uMfNo/NTxcqpAhKtJOf1GryLnoMCsmhELIEGjZzSFYqdZphU7oro6sr7Qe2HAzExsXDVY70YSGd6aoz6E8LdwXl9wJvS8nmt8uZffziVVA9MUp1jhRxCgAu6mwKdsyEmu2PlnG4glTVdNZxSRAuwhHPdZ8IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lian,


On 9/14/26 7:33 PM, Lian Wang wrote:
> From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
> 
> Hi Johannes, Barry, Baolin, Kairui, everyone,

Thanks for raising this issue again.

> We revisited the thread and Johannes's earlier analysis on the kswapd/kcompactd
> handoff. We agree that a single static `compact_gap()` cannot represent
> hundreds or thousands of concurrent higher-order requests. In such workloads,
> repeated kswapd wakeups often reflect real unsatisfied demand, and stopping
> kswapd too early can shift the burden to direct reclaim and direct compaction.
> 
> At the same time, related reclaim issues are still appearing in several
> environments:
> 
>    - Barry observed order-3 network allocations causing persistent kswapd
>      activity and device heating on phones, even though requesters can fall back
>      quickly to order-0.
>    - Baolin and Kairui have seen similar fragmentation-driven reclaim behavior
>      on servers.
>    - We have reproduced on PCs and VMs that order-0 memory and total available
>      memory can remain plentiful while order-3 blocks are scarce, yet kswapd
>      consumes substantial CPU and runs heavy reclaim/scan loops. We have not yet
>      reproduced this consistently on our server systems.
> 
> There is a useful parallel in Johannes's production work on reclaim storms in
> defrag_mode:
> 
> https://lore.kernel.org/20260626182215.1107966-1-hannes@cmpxchg.org/
> 
> The allocation paths differ, but both threads expose a similar feedback problem:
> reclaim may report progress in the number of freed pages, while not making useful
> allocation progress for the order, migratetype, or fallback intent that triggered
> it.
> 
>> The compaction gap is sized for a single allocation, but
>> kswapd/kcompactd are a shared resource for potentially hundreds or
>> thousands of incoming requests.
> 
> We share this concern and do not want to replace the existing incremental
> pipeline with one fixed value. We would like to separate two possibilities:
> 
>    1. One high-order kswapd wakeup overshoots `compact_gap()` substantially
>       before `sc->order` is reset and kcompactd is woken.
>    2. Each wakeup makes bounded progress, and the total overhead comes from
>       repeated wakeups after best-effort callers have already fallen back to
>       order-0.
> 
> For the first case, limiting the high-order reclaim scan or per-wakeup reclaim
> budget when order-0 watermarks are already satisfied may preserve the repeated-
> wakeup pipeline while avoiding a large single-pass overshoot. For the second,
> we may need stronger accounting of outstanding higher-order demand, instead of
> treating every repeated best-effort attempt as a request that still needs
> background progress.
> 
> Would it make sense to align on a common, parameterized reproducer and trace set
> before choosing between changing `pgdat_balanced()`, bounding the high-order
> reclaim budget, or improving demand accounting? A useful matrix could cover:
> 
>    - best-effort order-3 allocation with immediate order-0 fallback;
>    - sustained and concurrent THP or pageblock-order demand;
>    - default mode and defrag_mode;
>    - phone, PC/VM, and NUMA server environments.
> 
> We can share our reproducer and the PC/VM traces, and adapt the workload to
> collect per-wakeup `nr_to_reclaim`, `nr_reclaimed`, `nr_scanned`, order reset,
> kcompactd activity, allocation success, and fallback path details. It would be
> very helpful if Barry, Baolin, Kairui, and Johannes can tell us which parts of
> this matrix and which counters best represent the phone and server cases. Then
> we can compare scenarios with aligned measurements and work toward a solution that
> does not trade mobile reclaim storms for server direct-reclaim/compaction storms.

Like I said before [1], the problem we ran into is that in scenarios 
where fragmentation caused kswapd to be woken up and reclaim too many 
file folios (even when free memory was sufficient), leading to severe 
I/O contention that impacted some applications.

In such fragmentation scenarios, I don't think we should reclaim a large 
number of file folios, instead we should wake up kcompactd to perform 
defragmentation. So in theory, I prefer Barry's earlier proposal to 
adjust 'sc->nr_to_reclaim' [2]. But let's see what Johannes thinks.

Based on our problem, I think we can setup a simple test scenario: one 
workload tries to allocate THP under fragmentation (and free memory was 
sufficient now), while another fio workload accesses file folios 
periodically. In this scenario, kswapd's reclaim should not affect the 
fio workload's performance.

[1] 
https://lore.kernel.org/all/8d4df864-2954-4eb6-b8d7-ae6595646e6e@linux.alibaba.com/
[2] 
https://lore.kernel.org/all/CAGsJ_4x9vkv2G7d-gANf8kqUJVxQh_P9=AJxr98LFUgQeOTqow@mail.gmail.com/

