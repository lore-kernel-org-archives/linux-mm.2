Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF3C606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 07:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LdMbv88D
Received: by kanga.kvack.org (Postfix)
	id 5967F6B05B1; Wed, 28 Oct 2026 03:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546866B05B2; Wed, 28 Oct 2026 03:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435636B05B3; Wed, 28 Oct 2026 03:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1586B6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:56:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 876A7C0BC7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:56:37 +0000 (UTC)
X-FDA: 85371278034.11.9F86F8D
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id AACCD40003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:56:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LdMbv88D;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793174195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHjcBED3Ycog4A3HXnCvRQAGAdc1n7vzZLXNcrluU/c=;
	b=yKrGnXOiZRBEtiDO4XyVFWBxzpRxMVX4wuaccVPHqoB/bE8FGiHN3aWghzkHb/gaEwl/y3
	6yTTGthAM8Dv4kYixlZBFnOIUJhfFXhWPjwOgoM2kjC9hQ4xw8zi+bjdGiOBbRdv5GU7K+
	+wjSxH0XvitNfORrh1RdUHAExxIU+mE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793174195;
	b=UV89LfScXdaRTCfppcb3D2+eR0ii6nrRLcBzquNDcbqNc0525IYvH81YBlh+GjtfnRd7rN
	EYYY6ascYfhdHCJj96+jfONu7TQ/UIISvETKcH2uNtV/Gb8cgKD5Qf4cTdBFTWXgCkD31w
	/D81AkdOyVH3bE63012e7aAOU+BkkHc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LdMbv88D;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793174189; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kHjcBED3Ycog4A3HXnCvRQAGAdc1n7vzZLXNcrluU/c=;
	b=LdMbv88DsHfP5BNmZrH5JZ4tjB9eb0cURyKLKqmRvFtZpE4ZJOuLwyCg3xLZ3RQTwmhNvgu1+iW9fVLMhJh30F3eO6bckP14w7TwbagpvnAK5MxCtc6LF7TYRctQvS32tIeO6wREx4EWqwRvjX9udDK4aLgYiPKc8sG5YdFJiRE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XDg8HhM_1793174186;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDg8HhM_1793174186 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 15:56:27 +0800
Message-ID: <03363c4b-ed04-4921-8bc8-165ed8c363e4@linux.alibaba.com>
Date: Wed, 28 Oct 2026 15:56:26 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/shmem: trace swapin results and allocation
 fallbacks
To: Xuewen Wang <wangxuewen@kylinos.cn>, hughd@google.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AACCD40003
X-Stat-Signature: ccqpxq7n69orqe8oimi5bptpyxdtf359
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793174193-13048
X-HE-Meta: U2FsdGVkX1/o6wg3OT4opAX6QvI7sGg8K6OKllEfmB63CDxig/uwK1jJFVPAlCk52xgANXh5N8v0tA/Fy19AF6CNrXU5p11WDS9JzttJpVFip8BJ4CnHDiQFomlKcLzdIZX0nUJeUZ+MMJP5fS3bAJ1fT4S1ZbQEbhaGZ+a49CQQPhN3pu3jPD4b0Ib0t/myCZKuB3lgkPY4lRzQlMzhbO4IjO7aGyyeA3pnShJSENgr/WbCF01DeGJdoWyr3fhyAJ8qcz5GQeGFK5sYB1xWgWa6UyHoUvEo1WF1KWbmqUdIqPburSkvAG6qxrQzX/L0ohWuQiE4Xk143Kuk52Q8inV/HPkak2XYMP65zRvqcd7cwdjJ7pyDcfCXo5JFi0vubSCkQp6+QkC9ExtyUwHUCliXrUXdh9JVo6+lOQX3R+tydlyLpX5JlpX95+kDaaTNmNV/7AmUNAxEhAnxm6oBFx/kPnyF6GLm3ZgYZlFOxeXQjX7BuQutg39a4ej5KrBwWBs0mKgJ+MgrWbBcXJ5INnEvmsn55V6PT4+KyUwPbFWhduxj2NQumdNhoU7YQPYiUkOFv08ov4IusHNnuyTJxDMT3yXa7GWRZOUnI1X+Z3wMZyOr0+Cnx3Q9oN4aBXsyO7rglyf9jmo+E3/fDfm44NNrAppGQbIUqsKoQj7+izBiBaaFtIOqg6zciMUaWuJusItjnW3JEjTxMVsYnimNVgb8NrRm3a+El1CGsh0zUJ3+xMBYPrwXe6aA3qvPHxv98TLRl95uSMiM2oFNxjYU/GQqWaz7ykGm+fPif/bQfthcJc6HW3vuM2w8ufksrN1aI6s58uJC7Fb/MkdjAaK6zVsJu7IF3B8WtaW+eR3K/1VZjcgd7nQDd4KSYPDFI/0EZC4cqpbOu7Fqiocxti3XjcX3KzIWM41UCTjN/ElnNJf62gFyi9EDbu4Bn7UXOehzW9/pA5irv+0dQqRBgbs
 Z/XyGpcd
 c0x4UjRfRNHzDKjbybGKVqHQ9r0OxWCy+NThLFut5riPBF4vhd7mhgTzcXSLMyOLC4s48iTdQMZyasfqFZhlVriW3F3AF/c+HV2C/yx1IqacqiU/82qIhzb/Ylhapi67Nvp5t3IL6bqNQDhEVfsbxlA5BN38gH4gIjLwk1EtNWmacdOvkdiaCu6VPz8Z5t0dlqYoaEzLmrH7bL3cQNoyVRcmsk+Kx32KG6MjtSSghgEz8FlBdZeKj90Xl9pJ7SN6JhNcFtmY/PL6oXlwZsHmULt/prPNoH3hpwlqcKLUWtJWDJKkdGowCbgbq8Xa6MjL3vjqh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 5:40 PM, Xuewen Wang wrote:
> The tmpfs swapin and allocation paths are currently a blind spot for
> tracing: the swap layer has no tracepoints at all, the existing
> counters cannot attribute events to a file, and an mTHP request can be
> silently downgraded at two layers - or fail outright - with only one
> of those having any accounting.
> 
> On the swapin side:
> 
> - PGMAJFAULT only accounts the page fault path; swapins triggered by
>    read()/write()/fallocate()/truncate/symlink go through
>    shmem_get_folio() with vmf/fault_type NULL and are not counted
> - PSWPIN/ZSWPIN are counted at the I/O and zswap layers with global
>    and memcg granularity, but cannot be attributed to an inode or file
> - the mTHP order degradations in shmem_swap_alloc_folio() (uffd/zswap
>    forced order-0, order-0 retry after sync allocation failure) have
>    no counters at all, unlike the swapout side which counts
>    THP_SWPOUT_FALLBACK and MTHP_STAT_SWPOUT_FALLBACK
> 
> On the allocation side:
> 
> - the order mask from shmem_suitable_orders() (vma filtering, page
>    cache layout conflicts) can drop the order with no counter at all;
>    the code comment notes that -EEXIST "would be the right code, but
>    not here"
> - the allocation fallback loop is counted by MTHP_STAT_SHMEM_FALLBACK
>    without attribution
> - a fully masked-out request fails with -ENOMEM while the caller
>    silently retries at order 0
> - when mem_cgroup_charge() fails with the target range already
>    occupied, the error is rewritten to -EEXIST, making a cgroup limit
>    event indistinguishable from a benign insertion race
> 
> Patch 1 adds a single shmem_swapin_folio event at every return from
> shmem_swapin_folio(): the original caller index and XArray entry, the
> requested (entry) and actual (folio) orders, the branch taken -
> validation failure, initial swap cache hit, synchronous helper,
> readahead helper, or poison marker - and the return value. For the
> synchronous helper it also records why the request became order 0: a
> fallback bitmask reporting the userfaultfd and zswap restrictions
> together when both apply, sync_fail plus the initial errno when a
> higher-order attempt failed and was retried, or none.
> 
> The fallback field is a bitmask rather than an enum because the two
> policy restrictions are independent: a VMA can have userfaultfd armed
> while the boot-wide zswap latch is also set. Reporting only one value
> would hide that the other restriction must also go away before large
> folios come back. sync_fail never combines with them - a policy
> downgrade forces order 0 before the first attempt, so the retry that
> sets sync_fail can only run when no policy bit was set.
> 
> Patch 2 adds a shmem_alloc_folio_finish event with the full order
> chain (requested/suitable/actual) separating VMA and page-cache
> filtering from allocator fallback, a stage value (filter, alloc,
> charge, cache, account, done) identifying where the attempt ended,
> and both the stage errno and the returned errno: a memcg charge
> failure stays visible as error=-ENOMEM even when a page-cache
> conflict rewrites the return to -EEXIST. A fully filtered-out request
> reports stage=filter with error=0 and suitable_order=-1 because no
> allocator call occurred. Successes at the requested order - including
> ordinary base-page allocations - are omitted, so order-0 traffic
> never floods the ring buffer.
> 
> shmem_swapin_folio does fire on every swapin attempt, and that is
> deliberate: a swapin is a major-fault or I/O slow path whose rate is
> bounded by actual swap traffic, and each event is precisely what
> PSWPIN cannot attribute. Folio allocation is the opposite - it runs
> for every page ever touched, "succeeded at the requested order"
> carries no information, and it is already counted by
> MTHP_STAT_SHMEM_ALLOC and THP_FILE_ALLOC. Hence the asymmetric
> gating between the two patches. Both events, their fields and the
> attempt semantics are documented in Documentation/trace/events-shmem.rst.
> 
> Three questions answered up front:
> 
> Why not vmstat counters?  Counters show trends, tracepoints do
> per-inode attribution; the two are complementary, and the trend side
> already has its counters.
> 
> Why not eBPF/kprobes?  BPF programs attach to tracepoints, so this
> series is an enabler for BPF rather than competition. The interesting
> data is mid-function state (suitable_order is a local consumed by the
> fallback loop, the fallback bitmask is an internal policy decision,
> and the charge error is rewritten in place before the return) that is
> not visible at any function boundary; the functions involved are
> static and may be inlined, so kprobe scripts silently break across
> kernel versions, while a tracepoint's fields are documented in its
> format file and any change is visible in review.
> 
> Why not extend trace_mm_filemap_add_to_page_cache()?  tmpfs never
> emits it.  Its only call site is in mm/filemap.c, while
> shmem_add_to_page_cache() runs its own XArray insertion loop with no
> trace calls at all, so tmpfs folios entering the page cache produce
> no filemap event.  Even if they did, it reports only the final order -
> no requested/suitable/actual chain, no stage, no errno - and nothing
> whatsoever for the swapin side.
> 
> Reproduced on x86_64 (8 CPUs), kernel v7.3.0-rc3 + this series, tmpfs
> on disk-backed swap with cgroup v1 memory limits forcing swapout
> deterministically; zram provides the SWP_SYNCHRONOUS_IO device for
> the synchronous path.
> 
> Swapin attribution - three tmpfs files (400M + 500M + 150M) charged
> to one cgroup, 965M forced out with a 100M limit, then the 400M and
> 150M files read back with read():
> 
>      PSWPIN +116219 pages, PGMAJFAULT +0
> 
>      ino=2 (db_shm,    400M, read back): 102400 events - every one of
>                                          its 102400 pages
>      ino=3 (app_cache, 500M, untouched):      0 events
>      ino=4 (misc,      150M, read back):  16661 events, exactly the
>                                          pages that had left memory
> 
> 104528 events took the cache branch and 14533 the readahead branch;
> all carry error=0 and fallback=none. PGMAJFAULT never moved while
> 119061 read()-triggered swapin events were recorded.
> 
> mTHP order degradation on the readahead path - huge=always mount,
> 512M faulted in as 256 2M folios, 414M swapped out to disk swap and
> read back:
> 
>      102672 events  requested_order=0 actual_order=0
>        1656 events  requested_order=5 actual_order=0
>        1449 events  requested_order=6 actual_order=0
>         207 events  requested_order=9 actual_order=0
> 
> The 3312 events with requested_order > 0 all came back order 0 while
> fallback stays none: the readahead path returning a smaller folio
> without any policy downgrade, exactly the case the documentation
> describes.
> 
> Synchronous whole-folio swapin - the same workload with zram as the
> swap device and the zswap latch unset:
> 
>      207 events, all path=sync requested_order=9 actual_order=9
> 
> 207 2M folios account for the 414M that went out: with no policy
> restriction the synchronous helper preserves the entry order end to
> end.
> 
> zswap policy downgrade - zswap enabled once then disabled (arming the
> one-way latch), 128M fault-written with zram swap, 90M forced out:
> 
>      23040 events, one per page swapped out
>        720 events with requested_order > 0, every one fallback=zswap
>            360 order=5 / 315 order=6 / 45 order=9, all actual_order=0
> 
> fallback_error=0 and error=0 throughout: policy downgrades, not
> failed attempts. The remaining 22320 events are order-0 entries that
> had nothing to downgrade (fallback=none).
> 
> Combined policy restrictions - a userfaultfd registered over the
> faulting VMA plus the armed zswap latch, 158M forced out and read
> back through the armed VMA. This is the case a single-value fallback
> field cannot report:
> 
>      1264 events  fallback=userfaultfd|zswap
>          632 order=5 / 553 order=6 / 79 order=9, all actual_order=0
> 
> The 39184 order-0 events in the same run report fallback=none: an
> order-0 request has nothing to downgrade.
> 
> Allocation filtering - MADV_NOHUGEPAGE 64K stripes every 2M on a
> huge=always mount, 512M fault-written:
> 
>      1280 events, all stage=done error=0 ret=0
>      256 each for requested_order=9 with suitable_order and
>      actual_order of 4, 5, 6, 7 and 8
> 
> Not one 2M folio is allocated across the whole 512M file
> (shmem_alloc 2M stat delta 0), yet nothing today reports why.
> 
> Allocation failures under a cgroup limit - 300M fault-written inside
> a 100M memory limit, 8365 events in one run:
> 
>      1976 stage=charge  error=-12 ret=-12  memcg charge failure, the
>                                           errno preserved
>      1976 stage=filter  error=0    ret=-12  suitable_order=-1
>                                           actual_order=-1, no
>                                           allocator call occurred
>      4413 stage=done    error=0    ret=0    cascade fallback,
>                                           suitable_order 1 to 9
> 
> Filesystem accounting - a 16m tmpfs mount written with 64M of 4K
> pwrites: 24576 stage=account events, all error=-28 ret=-28, firing
> at the block where accounting ran out; 12288 carry requested_order=9
> (the large-folio write attempt) and 12288 requested_order=0 (its
> order-0 retry), two events per failed write.
> 
> Negative controls: 0 events for re-reading a file already in cache,
> 0 with the events disabled, and 0 for a 64M plain order-0 write
> (patch 2's volume filter).
> 
> Not exercised at runtime: path=lookup and path=poison with nonzero
> error, fallback=sync_fail with fallback_error (these need a failing
> higher-order synchronous attempt or fault injection), userfaultfd
> without zswap (the latch is one-way per boot and was already armed
> for the combined test), stage=alloc with a real allocator failure,
> and stage=cache (a concurrent insertion race). Everything quoted
> above was observed on the target machine.

Sorry, I'm not a fan of adding such tracepoints without any real use 
cases in production to show which data is truly useful. And as you 
mentioned, eBPF can do most of the data tracing.

Moreover, I don't think shmem is special. I don't want shmem to have its 
own swapout/swapin tracepoints while anonymous memory has its own 
swapout/swapin tracepoints. If there are swap related tracepoints that 
are actually needed, they should be considered together as proper 
interfaces.

Finally, tell your LLM to simplify the cover letter.

