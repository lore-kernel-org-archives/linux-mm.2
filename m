Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66217E668B4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 12:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F4A6B0088; Sat, 20 Dec 2025 07:34:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1CF06B0089; Sat, 20 Dec 2025 07:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929B06B008A; Sat, 20 Dec 2025 07:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB956B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 07:34:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2121C601D9
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:34:58 +0000 (UTC)
X-FDA: 84239793876.28.13A987D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 198C7180005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:34:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CYuFAnq+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766234096; a=rsa-sha256;
	cv=none;
	b=irJdRHfbkf1Xdq8zypJhR2LvsbtQOG6VAbTfHsWItalP9/QOFZIR/r57Y1eEUwVhNZNnLh
	6XuU0u4MxqLBcKjxNsX1opF6s/ZxmVAHwo+/Ml9qOZY0XlFouiDUZMtzZ2h/vMntHA4e4f
	LrBxFHivzKsC1j4S0eGo8sAP6npL4uA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CYuFAnq+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766234096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1HzDltyBKjzeygGtrpa51qJUu6D5dQuY0xY8PUvjRA=;
	b=sWuH0RYEFkK0CzTlhsLZhWgRr4rBqb8IfqL87wYgz0B059Vt913auvwV3kvPTnzmE9Otzh
	blm5GQlWMzP1UhnwhdkxklEzYQVhqCkbiPQs+GbB6bY5c7Zkb6dDoiYdf2141SGBEKrrlZ
	fE5JgjWSDm9V7VP6kIBsOGPRTxN+BLQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766234095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N1HzDltyBKjzeygGtrpa51qJUu6D5dQuY0xY8PUvjRA=;
	b=CYuFAnq+XcmMnar4L7pKSLz7gmncE9etjT964k+PdkXEpg+GpugM467O3OQ3RYkrhwAkYl
	JNhNx00EORMk2hpnXNU5D2oSDaD+k3z/k2CEPL0YkBZPBzgFY6BiZXjr0rlN0tET2szYAb
	PrRxykQzwBJGMthLHc2rHkn3xoVeggM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-Irr-uDjTPjeJRvhM-fb6dg-1; Sat,
 20 Dec 2025 07:34:51 -0500
X-MC-Unique: Irr-uDjTPjeJRvhM-fb6dg-1
X-Mimecast-MFC-AGG-ID: Irr-uDjTPjeJRvhM-fb6dg_1766234088
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55583195DE48;
	Sat, 20 Dec 2025 12:34:47 +0000 (UTC)
Received: from localhost (unknown [10.72.112.41])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 191D030001A2;
	Sat, 20 Dec 2025 12:34:43 +0000 (UTC)
Date: Sat, 20 Dec 2025 20:34:38 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
	linux-pm@vger.kernel.org,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Subject: Re: [PATCH v5 00/19] mm, swap: swap table phase II: unify swapin use
 swap cache and cleanup flags
Message-ID: <aUaX3mypyTXXM07x@MiWiFi-R3L-srv>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 198C7180005
X-Rspamd-Server: rspam03
X-Stat-Signature: mpsbxcrsbqazfpktitem8cp119hogke3
X-Rspam-User: 
X-HE-Tag: 1766234095-112890
X-HE-Meta: U2FsdGVkX187ga4GSThhrCHbPE+M84EKbuK0PqvtjY5l6sor7qyi3Y0WuAkeuJJZRHB7UwYJTyWj1C8hLzQbpL0+Lf1Iqk5vY/3mb6szlqKRmx7S2Bx9oh/YkJoGL1pJkCGIH4HDtjn0aqhx0MuUgVFAgQXv+MO6Ct23j6cb+YAy4kn2QQfBbRtv8DrWyJ/7tbVcGHTqPqcVLxeFMRPPugXoWciJmoL6LbyFOX7PdG7xfoOiaH2RmtBNOUhNpuSdlRlLd3N4Hltn9mjvoYfCfEj8prLv+1vIiGi+B26/v1uXjFldFPwWuaxS0Rd82eM/Jlk4i+gWb/8qU294eUG1SIGO1rJmRQBPm7zI3Ghc8zTk2vYxR55BM90mjsxNG/qourjyRi4N8ogyhMzn9KecsLBNrzDdFlGJ1vKNUiRQg6xYU+2kEgFuS9UoFAFbZm4zv9/eookLA54x58LqGhCsf0oEejPHIhuTrVhfpuy4qP9YxqfcnHPB0IFECM0OrGhsq+JHrc/nag5Fsb4oXBApHEUwQQCZymqXEer+3qr/GcKCzktSyRyVrS0hNZO3MdN4Xle2KHYQbm4b8cqliLKE+nG7YsXoSP7GHryx0NRuAvM97ApDbkTX2S/PuKENEXL6QHWlv7BYx3W3c+axqj1aIO5ucw5Mrpyo8duxFm/XrLX7FopecXC8xfZdp9UXnGMisM14BiAxU26qiu73sruY7xNv2Q3Gx9fjuw2AeK8U2205ITAUeByat+XEN3sTouujAysFXAw14ptGkoIs6bkpC52O9Qbx25+zk6a5eOM/F81z6d2egSriAQNZwGIFxNDX2QA8sV1G7z9PmwPZ0IiLw7fcQesEHPt3qoO9Sz3OlWDBcT9Ufm+6ELxKO+5q0L7M92JFhIwnYk6foA+93G5947cwYGUdjg0ySuHXBR5LYtfw9Q3SEudd86CzB6PQM7E73Z1uEUwdWlx1KrJMBSi
 2eF6mCyj
 dNi6QGP+4teylIBadhgZ/LenTKiXyfwc07qcFxYuq6E7oqWdxjnxe/Y+jngnRnV93z95NFtPhz5/DynCTprFscqdglP8bvj8ZiySZh8+c4mZF+vMtjwoNNfKisJ2edT9jJ1Ur6J5J/drKzuC34x+qkxFLRkdyQApFMkmaFIU77LNvdjFXdDFW39HzDTw1VM7jXE+F/KwrIW6v7MOZrMCb0OZxywgSWxOOg/Tle+8SKjEh0CiP1mWXrG3NCXb4bNxtWaLExW0VP5cZzPXzueqS6ATg5/7U/h6OKPchzdLbX9To2hvIXaBbrXzO3ytFBoNadiAwHGHgAlanVfHWu1DfB85ZZhvcT8K1AXeuMtf2NI3ozPtV4R8O2s+jxhz+I+nn75eUzBAbAORlY3Vw1jow4mgQHTVe2wAIKJy3JjiDVMjT87CEHkM7avv/qZ6obkpIn+6MuwvcwrXVdnkFQMOnyJXGgutPXch4EQx62S+S7iKqqg4q4HnBsk4FYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 at 03:43am, Kairui Song wrote:
> This series removes the SWP_SYNCHRONOUS_IO swap cache bypass swapin code and
> special swap flag bits including SWAP_HAS_CACHE, along with many historical
> issues. The performance is about ~20% better for some workloads, like
> Redis with persistence. This also cleans up the code to prepare for
> later phases, some patches are from a previously posted series.

Thanks for the great effort on the swap table phase II redesign, optimization
and improvement. I am done with the whole patchset reviewing, with my
limited knowledge, I didn't see some major issues, just rased several
minor concerns. All in all, the whole patchset looks good to me.

It's not easy to check patch by patch in this big patch series, especially
some patches are involving a lot of changes, and some change could be related
to later patch. I think it's worth being put in next or mergd for more testing.
Looking forward to seeing the phase III patchset.

FWIW, for the whole series,

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> Swap cache bypassing and swap synchronization in general had many
> issues. Some are solved as workarounds, and some are still there [1]. To
> resolve them in a clean way, one good solution is to always use swap
> cache as the synchronization layer [2]. So we have to remove the swap
> cache bypass swap-in path first. It wasn't very doable due to
> performance issues, but now combined with the swap table, removing
> the swap cache bypass path will instead improve the performance,
> there is no reason to keep it.
> 
> Now we can rework the swap entry and cache synchronization following
> the new design. Swap cache synchronization was heavily relying on
> SWAP_HAS_CACHE, which is the cause of many issues. By dropping the usage
> of special swap map bits and related workarounds, we get a cleaner code
> base and prepare for merging the swap count into the swap table in the
> next step.
> 
> And swap_map is now only used for swap count, so in the next phase,
> swap_map can be merged into the swap table, which will clean up more
> things and start to reduce the static memory usage. Removal of
> swap_cgroup_ctrl is also doable, but needs to be done after we also
> simplify the allocation of swapin folios: always use the new
> swap_cache_alloc_folio helper so the accounting will also be managed by
> the swap layer by then.
> 
> Test results:
> 
> Redis / Valkey bench:
> =====================
> 
> Testing on a ARM64 VM 1.5G memory:
> Server: valkey-server --maxmemory 2560M
> Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get
> 
>         no persistence              with BGSAVE
> Before: 460475.84 RPS               311591.19 RPS
> After:  451943.34 RPS (-1.9%)       371379.06 RPS (+19.2%)
> 
> Testing on a x86_64 VM with 4G memory (system components takes about 2G):
> Server:
> Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get
> 
>         no persistence              with BGSAVE
> Before: 306044.38 RPS               102745.88 RPS
> After:  309645.44 RPS (+1.2%)       125313.28 RPS (+22.0%)
> 
> The performance is a lot better when persistence is applied. This should
> apply to many other workloads that involve sharing memory and COW. A
> slight performance drop was observed for the ARM64 Redis test: We are
> still using swap_map to track the swap count, which is causing redundant
> cache and CPU overhead and is not very performance-friendly for some
> arches. This will be improved once we merge the swap map into the swap
> table (as already demonstrated previously [3]).
> 
> vm-scabiity
> ===========
> usemem --init-time -O -y -x -n 32 1536M (16G memory, global pressure,
> simulated PMEM as swap), average result of 6 test run:
> 
>                            Before:         After:
> System time:               282.22s         283.47s
> Sum Throughput:            5677.35 MB/s    5688.78 MB/s
> Single process Throughput: 176.41 MB/s     176.23 MB/s
> Free latency:              518477.96 us    521488.06 us
> 
> Which is almost identical.
> 
> Build kernel test:
> ==================
> Test using ZRAM as SWAP, make -j48, defconfig, on a x86_64 VM
> with 4G RAM, under global pressure, avg of 32 test run:
> 
>                 Before            After:
> System time:    1379.91s          1364.22s (-0.11%)
> 
> Test using ZSWAP with NVME SWAP, make -j48, defconfig, on a x86_64 VM
> with 4G RAM, under global pressure, avg of 32 test run:
> 
>                 Before            After:
> System time:    1822.52s          1803.33s (-0.11%)
> 
> Which is almost identical.
> 
> MySQL:
> ======
> sysbench /usr/share/sysbench/oltp_read_only.lua --tables=16
> --table-size=1000000 --threads=96 --time=600 (using ZRAM as SWAP, in a
> 512M memory cgroup, buffer pool set to 3G, 3 test run and 180s warm up).
> 
> Before: 318162.18 qps
> After:  318512.01 qps (+0.01%)
> 
> In conclusion, the result is looking better or identical for most cases,
> and it's especially better for workloads with swap count > 1 on SYNC_IO
> devices, about ~20% gain in above test. Next phases will start to merge
> swap count into swap table and reduce memory usage.
> 
> One more gain here is that we now have better support for THP swapin.
> Previously, the THP swapin was bound with swap cache bypassing, which
> only works for single-mapped folios. Removing the bypassing path also
> enabled THP swapin for all folios. The THP swapin is still limited to
> SYNC_IO devices, the limitation can be removed later.
> 
> This may cause more serious THP thrashing for certain workloads, but that's
> not an issue caused by this series, it's a common THP issue we should resolve
> separately.
> 
> Link: https://lore.kernel.org/linux-mm/CAMgjq7D5qoFEK9Omvd5_Zqs6M+TEoG03+2i_mhuP5CQPSOPrmQ@mail.gmail.com/ [1]
> Link: https://lore.kernel.org/linux-mm/20240326185032.72159-1-ryncsn@gmail.com/ [2]
> Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [3]
> 
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Changes in v5:
> Rebased on top of current mm-unstalbe, also appliable on mm-new.
> - Solve trivial conlicts with 6.19 rc1 for easier reviewing.
> - Don't change the argument for swap_entry_swapped [ Baoquan He ].
> - Update commit message and comment [ Baoquan He ].
> - Add a WARN in swap_dup_entries to catch potential swap count
>   overflow. No error was ever observed for this but the check existed
>   before, so just keep it to be very careful.
> - Link to v4: https://lore.kernel.org/r/20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com
> 
> Changes in v4:
> - Rebase on latest mm-unstable, should be also mergeable with mm-new.
> - Update the shmem update commit message as suggested by, and reviewed
>   by [ Baolin Wang ].
> - Add a WARN_ON to catch more potential issue and update a few comments.
> - Link to v3: https://lore.kernel.org/r/20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com
> 
> Changes in v3:
> - Imporve and update comments [ Barry Song, YoungJun Park, Chris Li ]
> - Simplify the changes of cluster_reclaim_range a bit, as YoungJun points
>   out the change looked confusing.
> - Fix a few typos I found during self review.
> - Fix a few build error and warns.
> - Link to v2: https://lore.kernel.org/r/20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com
> 
> Changes in v2:
> - Rebased on latest mm-new to resolve conflicts, also appliable to
>   mm-unstable.
> - Imporve comment, and commit messages in multiple commits, many thanks to
>   [Barry Song, YoungJun Park, Yosry Ahmed ]
> - Fix cluster usable check in allocator [ YoungJun Park]
> - Improve cover letter [ Chris Li ]
> - Collect Reviewed-by [ Yosry Ahmed ]
> - Fix a few build warning and issues from build bot.
> - Link to v1: https://lore.kernel.org/r/20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com
> 
> ---
> Kairui Song (18):
>       mm, swap: rename __read_swap_cache_async to swap_cache_alloc_folio
>       mm, swap: split swap cache preparation loop into a standalone helper
>       mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
>       mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devices
>       mm, swap: simplify the code and reduce indention
>       mm, swap: free the swap cache after folio is mapped
>       mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
>       mm, swap: swap entry of a bad slot should not be considered as swapped out
>       mm, swap: consolidate cluster reclaim and usability check
>       mm, swap: split locked entry duplicating into a standalone helper
>       mm, swap: use swap cache as the swap in synchronize layer
>       mm, swap: remove workaround for unsynchronized swap map cache state
>       mm, swap: cleanup swap entry management workflow
>       mm, swap: add folio to swap cache directly on allocation
>       mm, swap: check swap table directly for checking cache
>       mm, swap: clean up and improve swap entries freeing
>       mm, swap: drop the SWAP_HAS_CACHE flag
>       mm, swap: remove no longer needed _swap_info_get
> 
> Nhat Pham (1):
>       mm/shmem, swap: remove SWAP_MAP_SHMEM
> 
>  arch/s390/mm/gmap_helpers.c |   2 +-
>  arch/s390/mm/pgtable.c      |   2 +-
>  include/linux/swap.h        |  71 ++--
>  kernel/power/swap.c         |  10 +-
>  mm/madvise.c                |   2 +-
>  mm/memory.c                 | 276 +++++++-------
>  mm/rmap.c                   |   7 +-
>  mm/shmem.c                  |  75 ++--
>  mm/swap.h                   |  70 +++-
>  mm/swap_state.c             | 338 +++++++++++------
>  mm/swapfile.c               | 861 ++++++++++++++++++++------------------------
>  mm/userfaultfd.c            |  10 +-
>  mm/vmscan.c                 |   1 -
>  mm/zswap.c                  |   4 +-
>  14 files changed, 858 insertions(+), 871 deletions(-)
> ---
> base-commit: dc9f44261a74a4db5fe8ed570fc8b3edc53a28a2
> change-id: 20251007-swap-table-p2-7d3086e5c38a
> 
> Best regards,
> -- 
> Kairui Song <kasong@tencent.com>
> 


