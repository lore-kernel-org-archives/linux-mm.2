Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEBAFCA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 17:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D1C6B0088; Sun, 11 Oct 2026 13:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E256B008A; Sun, 11 Oct 2026 13:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7583E6B008C; Sun, 11 Oct 2026 13:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 488F56B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 13:28:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AEF86140880
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 17:28:45 +0000 (UTC)
X-FDA: 85311030210.26.B375F5F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 910BD140002
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 17:28:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e5i5ed4y;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791739724;
	b=VPP8PB7H9p8s3Emq/dzYGzSOvxHS6TlxR6go05bTIczx9vW7Ea3+dZ9SdHjc7Tz8X8hiJB
	wtemF9g20h+kPUeiN8cOZl2D3g+Xcj5EaqgB+8TlYBLj8+dhGZBCjhHKxI/6/9tL1XZ1Ta
	fFmUBvXqfr9V/xvliEYg91NZ7H08+Tk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e5i5ed4y;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791739724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7AHwIKUhVldMu/MK4hxhH1gFljWE5FsITRU37dhKxg=;
	b=ZdwqC2+3bFPC3LLjXpwad0hGPMUOHCLirzYMt52XHKC3sl3fzYjDUUKB8MnvYoe12ZXvR1
	7bAKrrkYMN+UTqZ7oPV9m+IE0s6u99Ij7Fjhm/QQGk5L/QdZNDy7pM7Gr1FaI+FgUN5TA7
	l2CJ6y67bUshutS++48pUPCeUG/GCJI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BB781682;
	Sun, 11 Oct 2026 10:28:38 -0700 (PDT)
Received: from [10.163.146.225] (unknown [10.163.146.225])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70BF03F673;
	Sun, 11 Oct 2026 10:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791739721; bh=MI7LMwrl97b6i73iVI7u88+57sLGUKgyb2/wfD4KW0A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e5i5ed4yeGKLd8XXvpMve9XQf9OE36u6gKWXUn8hs8RNJ8mDOugFUGMY+UJhssT1K
	 6T7eIoA8lkMm1Cc+GA7VJURQuqfc1NFvwGTmadPfq3XGvamCF7G4dQ+/U4YC/zjMmb
	 vqlCzDr583JwWnHkFjKYEUCKjtwmlN3W6flfTfrY=
Message-ID: <55adcc67-e545-4bf5-93ba-7e4180f1b523@arm.com>
Date: Sun, 11 Oct 2026 22:58:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PROTOTYPE] mm: reliable 1GB page allocation
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>
References: <20261004013657.03a63c4c@fangorn>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261004013657.03a63c4c@fangorn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 910BD140002
X-Rspam-User: 
X-Stat-Signature: kcmc3x7fgr99uzr3ofizf7oh4dweqxhx
X-HE-Tag: 1791739723-319357
X-HE-Meta: U2FsdGVkX188jUWcUx5BKJRYeUe0QeuNcnFmr8V6E+kiPjfE2OVJ7Cru+lmkcL+TNqn6cyPd3KUf1BJKjStsqx9H5QZfFzysaHC3SiGGFYssLmC75cUxGdijOzSq3msVKQJ+zgwjHI152FQOGIcXxZNyb/QStiBQ0fETne5gq78MMPHD+y1ujsiezDbjI1uNFOgnPuud4LSGBI2X+3hBQGbOoXLxorng0lJwIsSoxXN0iEJOb8pPMcNXpuUW9Xl/sq6d6I31mM9c6R8fOyS3M+8MJ0TaTxfqaK58Y3BciY8ramHBr5j+dLdk+TgnITCHluz8EETA945zPbU60p1ZTZGm0+uxx4TPXtK9tVP6htlzdmndU0Qm/vQoqNZ2ZJzKiGGn0EovxdI1ckrrclDAw6cDkwlQMWQrx1D5bNfvYyGn6I1yX+BvltoD+2AWj7ZzVzn6uKpVMqFQZbUeU5yUrTC07GLTJxkNfu/e2r4z53RWC+Zpxlz+AKDqifAl2ZD0Ltf7ypfDGrwgrLnabQTnIIuElOd6AKhXvEpGpdis6gioLZJVlLZksqveiEEC+9H5bLdhDb+x8Sqn4a6cuXgmPpI2XEtA3jSPlGPdC5KwbLvn9mpgu5vesAH+fKL2fLAiOiMJ2ZRDxYRJTBbaVE6fRTGo9qR+RFL/Qzlh8/8V4/WlIg6hIXY3ECBHmvleS8NMqXLO32NnaBm339/5FgE8Vvk8ZEc50JOjpu4zfhy7Ku764uxPtNJtKssUigSCyKRJHw3mpgRaZahLrtKMAAInDdptWmOcF0kXJo7VbQWuN5PmyO7qWkIrN4K8UKqZ6krdOnY2pNUzD+RxOcoeFT3GggFlrTcFkFDSyCz2vFL6KRO3VTfj6mFJ9U9TH/j1VGVMBV0FVtSUdpppZRU6RoJn4Hdhpu55zGyRboCaZfYiIOesHWVKGCyo+PlkcuBOXV0z5SshQIiPkDWjgxNeNqX
 3MvNyXIj
 ZJ2ZMqcRudDPl/1B6/N7tJebXK0QpkO3Jm07oNqV8ZUBS8LeszhJC9ki4BuRoPm+bBk0NHtUkoEn99sIXhRzzYO12Fxzq8R13wLEwT5frsSIViMcvOD2T3Enya6CZ6gckuM73wuRoh38pKkzOnJ34p5cDeLP1s0VLQLhryNjtgUbcuMMzwtEvVdNuT/abJTj8TIHB+Bnkq6TfZyY2VTqegv4PBjAVKgqPVgPlSWjgxG5ku5XJ8g+n1UywaT4DnkvAkEAUE+tnDu1l2ntTP+uSKnihY+22ooUcPrJHzV+tCpMqp6Ca5a5EiEXw7QM3sUH3nJIs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/10/26 11:06 am, Rik van Riel wrote:
> The goal of this series is to keep gigantic (1GB) pages allocatable
> after weeks of uptime, by concentrating non-movable pageblocks in a
> small number of 1GiB-aligned ranges.
> 
> Design document: https://linux-mm.org/GigaBlocks
> 
> Code: https://github.com/rikvanriel/linux/tree/riel/gigablock-2026-10-03
> 
> A 1GB page needs a 1GB-aligned range in which every page is free or
> movable; one unmovable page disqualifies the range.  Over time a small
> amount of kernel memory spreads across nearly every range.  On a 765GB
> node after 53 days of build and filesystem work, none of 754 1GB ranges was
> free of non-movable pageblocks.  On a 253GB test host the same class of
> workload mixed 251 of 254 ranges in 9.2 hours, and a request for eight
> 1GB pages returned none.
> 
> This series uses the separate free lists for each migrate type
> in zone->free_area[] in the fast path. The idea is to satisfy kernel
> allocations from the unmovable and reclaimable free lists, while
> movable allocations come from the movable free lists.
> 
> For each gigablock, the system tracks whether it contains non-movable
> content, or only free and movable page blocks. A gigablock can contain
> a mix of non-movable and movable data.
> 
> When the kernel free lists run low, the slow path moves pages and page
> blocks from inside mixed gigablocks onto the kernel free lists.

Did you consider a design to introduce MIGRATE_POLLUTED: simply
have another migratetype which stores polluted pageblocks.
This idea can work in general, not sure how relevant it is
for gigablock concept.

 >
> Creating kernel free memory inside mixed superblocks is done
> by claiming page blocks in a mixed superblock, when the kernel
> free lists are exhausted, and a non-movable allocation has to
> fall back, or by compaction evacuating movable content from
> previously claimed kernel pageblocks that have movable content inside.
> 
> Claiming a new pageblock in a mixed superblock is done from the
> allocator path, using a bounded scan, only once the kernel free
> list is unable to satisfy an allocation.  Evacuation is done by
> kcompactd, and kicked off when the kernel free list falls below
> a watermark.  The goal is for the asynchronous path keep the
> page allocator on the fast path.
> 
> Movable allocations can fall back to the kernel free lists.
> That content can always be moved later.
> 
> Region size is fixed at 1GB rather than PUD size, geometry is frozen
> at boot, and a hotplug span change disables tracking for the zone rather
> than resizing metadata.
> 
> The diffstat shows that this version adds too much code to page_alloc.c,
> which is already too large, and should probably be split up somehow.
> 
> One candidate in this series is to split the evacuation code and gigablock
> slow path into its own file, moving that out of both page_alloc.c and
> compaction.c. 
> 
> Duplicating a small amount of compaction logic may be preferable to 
> complicating the existing logic at this point.
> 
> This code is not ready to be merged yet. The full design document has
> a list of things that still need to be done.
> 
> I am posting this in the hopes of getting feedback on the basic design,
> so that can be incorporated in the next rounds of tuning and cleanups.
> 
> Specifically feedback on design concepts like:
> - Using only zone->free_area by migrate type in the fast path
> - Moving pages around in the slow path, to keep the kernel free
>   lists stocked.
> - Some amount of scanning in the page allocation code if the
>   kernel free lists cannot satisfy an allocation, in order
>   to claim a block in a mixed gigablock.
> - Using compaction to evacuate movable content from pageblocks
>   claimed for kernel use.
> - The policy of restricting how much kernel allocations can
>   claim new pageblocks anywhere.
> - The policy of letting movable allocations fall back to the
>   kernel free lists once the movable free list is exhausted
> 
>  Documentation/admin-guide/kernel-parameters.txt |    8 
>  include/linux/mmzone.h                          |   83 
>  include/linux/pageblock-flags.h                 |    2 
>  include/linux/sched.h                           |    4 
>  include/linux/vm_event_item.h                   |   48 
>  mm/compaction.c                                 |  170 
>  mm/folio.c                                      |    5 
>  mm/internal.h                                   |  147 
>  mm/memory_hotplug.c                             |    3 
>  mm/mm_init.c                                    |  150 
>  mm/page_alloc.c                                 | 5553 +++++++++++++++++-------
>  mm/page_alloc.h                                 |    6 
>  mm/vmstat.c                                     |  273 +
>  13 files changed, 5015 insertions(+), 1437 deletions(-)


