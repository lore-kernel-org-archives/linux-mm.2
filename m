Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4414AE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F0D6B0005; Thu, 19 Feb 2026 10:53:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9CF6B0089; Thu, 19 Feb 2026 10:53:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90FF96B008A; Thu, 19 Feb 2026 10:53:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B30A6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:53:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 330EC1605D8
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:53:54 +0000 (UTC)
X-FDA: 84461651988.08.DE7A6CF
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9EF751C000F
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:53:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W0DedDsJ;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771516432; a=rsa-sha256;
	cv=none;
	b=dBAnP21Er7aGk1MG/pNWbrDRqlk1eisnXRYg11nEESnZ5umiPFSmSbSzftm7+jepoPf9zq
	X7UZbxBFEJQdg7wwDjgwL0/D6dAOHk75pEhJ6xj5TPYTGMFdSHyoMea7e8Tj3gLLFa4FCh
	ZpjSTcIx0as6idbmZHwnRuAt8yd6dO4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W0DedDsJ;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771516432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dSP/e2rQjKm5La6eyDuAyZddRv1Avp/Z7iJj0oftI2s=;
	b=nP39qoVnIj6Gw3QIcrLJtTeP0t6cpD+uzgYkdpqZjBW7yUIeP4iSksZmXJB8+zzz+XWYPm
	2A/q1VGQvMrfYShWq/rgmixhQk35rkp5QbxtjQhevByGYhemXlmiT9ZftJFHcdSjvq3SFp
	78es52zGBrjjocYXkmygtetV+EVALys=
Message-ID: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771516426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dSP/e2rQjKm5La6eyDuAyZddRv1Avp/Z7iJj0oftI2s=;
	b=W0DedDsJRFOqezMnja3LDy9h1C3uDcPJP3wlKYXXYUCqKiAKMaHEephxHbS4gw8ciUp44D
	9lRFP/NB3an9X0TfznYqlKoiJl7kfXPOhK/daLZCsGtc84cb7IE/mS67FBDXRgwGwQrzG4
	0RWb0HFMzFqaFI2TmQbZig1stpei58g=
Date: Thu, 19 Feb 2026 15:53:35 +0000
MIME-Version: 1.0
Content-Language: en-GB
To: David Hildenbrand <david@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 lsf-pc@lists.linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, "riel@surriel.com"
 <riel@surriel.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Lance Yang <lance.yang@linux.dev>,
 Frank van der Linden <fvdl@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
Subject: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need 1GB
 Transparent Huge Pages
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9EF751C000F
X-Stat-Signature: c65bc54cky8r67difijhpt44dgbfy33w
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771516430-899511
X-HE-Meta: U2FsdGVkX19WkPHpwn8sqKH6Nx3lzxshB1Tq9s89wFik9sQsWwopP0De3kniutGBVP4QNSfiHOzsRX4o89To1BGGYr3HQ8nulMU5B/1Ww7d0OjcvEhsqvaauPwiVkPqFIsFSExwvlSazLisduGvuOPcBJnWbP2IJPha6182dunLKObVpYs1W2idNR5yGzIMzDyVjeKbqZ42L8cBEBMJJfGlZZU/nAeTd3RNB4/wogtaEvmgvSnRh/Ag5ktnNsEviHUt+GNdshInlYJQX/ZYn+WGu/zQ+gxxt0yqh7vFlOeTqbL4XieiPpoq+Z+RddkzosDKtfLsWJk0fSwVSXUj4FVywJFHJMWHY1X/F6FvBQ8h1J8SiSsjtlxjAahyPP+PKZgCt7WP240CW4W9D/6e6/+SYFIcrWDyKLPOZlCCOJPBM4xRg5742Ps3pewEw6zOALNUAKCc8mWmN7F9J1+87HDJ4kgyCL9Qsql/vHta63ZScPknJm3mpUE+Hd0d8TanPgg4+37Ys99Y5FtlVWGom1awNsjDtveVALifoE8+VlBPm5uhbCzX861O8XnoiE/HvI0vKvoI39WadHasJstoAUO3MtHpKefAbm+5sK7FxytArh8wWu5zviNSgm8AL/qcsyk2YlsXtnkQ42dcqQ/gxKJ3fszrKAiwKstABwQJGLBBcX8UDV7zJksKOpkCUJnaWtIID3hcd98QkqJnGehM1f9UYRm03DXWkNdVwYVZLPWykt0+LbisJmGsH77wgnSXX6i/5bl2J78EzBJOPvRLThbcT1Sr6JcQdu5+z0Dg9vt6W/96BKvINo2g0Gi/5Z21AigUTbVyaET1+wD2uQZ2rixVl6PPlct9OIeYi+X5ltKbQY3BBasqWLaS8XjEJEpGB3t5oaGgydtZMvRp8xTQNBfkJOSyc8o1N9VPy3h0I2lgUSPpngv3uAveRdhPRyfnJbmP2IRiERgoxcHa+/8/
 GDkYbg9w
 Vhi8Uiu+VTFYZ4kx7+EklQLqVYZcnNx6Q57CFQ5NH6z5TiV5iBZxLvgTWFs0UfKecxsLWsA22LuBagH9ZyEz5p/jm3bEtTJo7DyKOG2UL8U0+SBvEzLDBbaFdl4JhZxoNfnWA/SWn7ITPWMduEQ4k9vvQMIbjIB4fV7nEbNfPpzQsQ/GYOtNlpwRHuuI1MfHZisgl8NNjEl3dps2H0cUe9fy7YNUU4KDfWAc4MX66umijlRsD9YzhI2re47wrbjxMEUasIsJ3Pf6IfHZv2Hp5N078PWmGbivaozKR5L+i2lBbdteIoIw7s9Ic6LM/Msc3Aj71yw4Q0ZWxnTY3StilWsjV561Z23Ol8xCS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When 2M THPs were introduced, the new server hardware coming out had memory in
the scale of low hunderds of gigabytes. Today, modern server hardware ship with
several terabytes of memory. This is widely available at all hyperscalers (AWS,
Azure, GCP, Meta, Oracle, etc).
While 2MB THP have mitigated some scalability bottlenecks, they are no longer
"huge" in the context of terabyte-scale memory. There are concrete scalability
walls that large-memory machines hit today. This includes LRU lock contention,
zone lock contention when missing PCP cache at allocation, extremely low TLB
coverage, amount of page tables used...

1G THPs come with their own set of challenges, more difficult to allocate, higher
compaction times…

Why 1G THP over hugetlbfs?
==========================

As mentioned in the RFC for 1G THPs[1] while hugetlbfs provides 1GB huge pages
today, it has significant limitations that make it unsuitable for many workloads.

The classic hugetlb user is a dedicated machine running a dedicated HPC workload.
This approach just doesnt work when you run a multitude of general-purpose workloads
co-located on the same host. Enlightening every one of these workloads to use
hugetlbfs is impractical -- it requires application-level changes, explicit mmap
flags, filesystem mounts, and per-workload capacity planning. Sharing a host
between hugetlbfs consumers and regular workloads is equally difficult because
hugetlb's static reservation model locks memory away from the rest of the
system. In a multi-tenant environment where workloads are constantly being
scheduled, resized, and migrated, this rigidity is a serious operational burden.

Concretely, hugetlbfs has the following limitations:

1. Static Reservation: hugetlbfs requires pre-allocating huge pages at boot
   or runtime, taking memory away. This requires capacity planning,
   administrative overhead, and makes workload orchestration much much more
   complex, especially colocating with workloads that don't use hugetlbfs.

2. No Fallback: If a 1GB huge page cannot be allocated, hugetlbfs fails
   rather than falling back to smaller pages. This makes it fragile under
   memory pressure.

3. No Splitting: hugetlbfs pages cannot be split when only partial access
   is needed, leading to memory waste and preventing partial reclaim. It would
   also make recovery from HWPOISON much easier, by splitting the 1G THP
   which is not possible with hugetlb.

4. Memory Accounting: hugetlbfs memory is accounted separately and cannot
   be easily shared with regular memory pools.

PUD THP solves these limitations by integrating 1GB pages into the existing
THP infrastructure.

The RFC [1] coverletter contains performance numbers for 1G THPs on x86 and
512M PMD THPs on arm which I wont repeat here.
The RFC raised many good questions for how we can approach this and what the
way forward would be. Some of these include:

Page table deposit strategy:
============================

The RFC deposited pagetables for the PMD page table and 512 PTE page tables,
which means ~2MB of memory was going to be reserved (and unused) during the
lifetime of the 1G THP. David raised a valid point if this is even needed for
2M THP, and I believe the answer is no. As part of cleaning up the current 2M
implementation, I am currently working on seeing how kernel would look like
without page table deposit for 2M THPs [2] (for everything apart from PowerPC
hash MMU).

For 1G THPs a similar approach to [2] can be taken. And probably no initial
support for 1G THPs on PowerPC hash MMU which requires page table deposit?

There will also be a lot of code reuse between PUD and PMD, and similar to
page table deposit cleanup, it would be good to know what else needs to be
targeted!

Is CMA needed to make this work?
================================

The short answer is no. 1G THPs can be gotten without it. CMA can help a lot
ofcourse, but we dont *need* it. For e.g. I can run the very simple case of
trying to get 1G pages in the upstream kernel without CMA on my server via
hugetlb and it works. The server has been up for more than 2 weeks (so pretty
fragmented), is running a bunch of stuff in the background, uses 0 CMA memory,
and I tried to get 100x1G pages on it and it worked.
It uses folio_alloc_gigantic, which is exactly what this RFC uses:

$ uptime -p
up 2 weeks, 18 hours, 35 minutes
$ cat /proc/meminfo | grep -i cma
CmaTotal:              0 kB
CmaFree:               0 kB
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           1.0Ti        97Gi       297Gi       586Mi       623Gi       913Gi
Swap:          129Gi       659Mi       129Gi
$ echo 100 |   sudo tee /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
100
$ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
100
$ ./map_1g_hugepages
Mapping 100 x 1GB huge pages (100 GB total)
Mapped at 0x7f2d80000000
Touched page 0 at 0x7f2d80000000
Touched page 1 at 0x7f2dc0000000
Touched page 2 at 0x7f2e00000000
Touched page 3 at 0x7f2e40000000
..
..
Touched page 98 at 0x7f4600000000
Touched page 99 at 0x7f4640000000
Unmapped successfully


I see 1G THPs being opportunistically used ideally at the start of the application
or by the allocator (jemalloc/tcmalloc) when there is plenty of free memory
available and a greater chance of getting 1G THPs.

Splitting strategy
==================

When PUD THP must be break -- for COW after fork, partial munmap, mprotect on
a subregion, or reclaim -- it splits directly from PUD to PTE level, converting
1 PUD entry into 262,144 PTE entries. The ideal solution would be to split to
PMDs and only the necessary PMDs to PTEs. This is something that would hopefully
be possible with Davids proposal [3].

khugepaged support
==================

I believe the best strategy for 1G THPs would be to follow the same path as mTHPs,
i.e. not having khugepaged support at the start. I have seen khugepaged working in
ARM with 512M pages and 64K PAGE_SIZE, so maybe there is a case for it? But I
I believe the initial implementation shouldn't have it.
Maybe MADV_COLLPASE only support makes more sense?
I would love to hear more thoughts on this.

Migration support
=================

It is going to be difficult to find a 1GB contiguous memory to migrate to.
Maybe it's better to not allow migration of PUDs at all?
As Zi rightly mentioned [4], without migration, PUD THP loses its flexibility
and transparency. But with its 1GB size, what exactly would the purpose of
PUD THP migration be? It does not create memory fragmentation, since it is
the largest folio size we have and contiguous. NUMA balancing 1GB THP seems
too much work.

There are a lot more topics that would need to be discussed. But these are
some of the big ones that came out of the RFC.

[1] https://lore.kernel.org/all/20260202005451.774496-1-usamaarif642@gmail.com/
[2] https://lore.kernel.org/all/20260211125507.4175026-1-usama.arif@linux.dev/
[3] http://lore.kernel.org/all/fe6afcc3-7539-4650-863b-04d971e89cfb@kernel.org/
[4] https://lore.kernel.org/all/3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com/


