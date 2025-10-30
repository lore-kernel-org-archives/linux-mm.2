Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBCECCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 23:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF248E00A7; Thu, 30 Oct 2025 19:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B66E8E006B; Thu, 30 Oct 2025 19:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F35C8E00A7; Thu, 30 Oct 2025 19:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0938E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:05:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F41812A927
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 23:05:04 +0000 (UTC)
X-FDA: 84056312928.16.4B0147A
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03DF9C000B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 23:05:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hKAjuKoZ;
	spf=pass (imf10.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761865502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bQJC1QXkt5VkE/jRY6BIklJjlsax/KlvqbIZU2KJ9/I=;
	b=lUGTDl0LQweGr5Bcd49kqHnOKwlcO8zqIWyiQTsXn3XYRGJIKB+X/j3EBQcMpo8AG4DwUi
	1sOXjcMJv1pu6FGhhTUYzBP9xm7e7gHiNdkHN4IRbVU6vA2/SvAH7q66yk0KzOE4UFg0bg
	er2AjMuPC1hNo1/iQ62yFb2hUxSrll4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hKAjuKoZ;
	spf=pass (imf10.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761865502; a=rsa-sha256;
	cv=none;
	b=BQcslpU76n2jOaAYSZh3kElHJfeNjVV3bEmF9xOio7ZUkfBS6kZ+G6VzLVkbMFuyo9zA2o
	YvUsfcgQnAadP30arZsapyqEdPOFX+zXzytk4L/Ydf6c45OejW7rx+UCuphku9VmH66HgR
	/YXETREOVw6JIoURwiyJ/ItudBRDHTU=
Date: Thu, 30 Oct 2025 23:04:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761865500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bQJC1QXkt5VkE/jRY6BIklJjlsax/KlvqbIZU2KJ9/I=;
	b=hKAjuKoZUMHePmJrJZeXuGp/FYZptRWwan1Piz6OQKJJT4xJLJYcHQqatl3bxqsIsmrAKV
	0KsSIj6YukHYK/5o7uZJZimgtjjie7sE9BG/EMvHpl8OuMEwsg/wORe3DProeIr8iBaQEI
	1a5hgpaFQ19F/sQ5fk+QR8gQURrEdkQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH 00/19] mm, swap: never bypass swap cache and cleanup
 flags (swap table phase II)
Message-ID: <bvavihwrtkbnsqgjbotwihckxzmnhdd4e6jre4j7xdiyyeyv5o@dnnuyacthvms>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03DF9C000B
X-Stat-Signature: 15mpbczdo1g6az5uk7dikf8cwiwoy19m
X-Rspam-User: 
X-HE-Tag: 1761865501-646683
X-HE-Meta: U2FsdGVkX1/ExXgHFvbgy1a8IacGx25kn7+n+kGMNTZJ06eASl1Qw8E95RSk81IE4/fX0a1HeovtH18otCnDJA+U3nrvBdtZ7Caarc6tJkbvCmVF8QtuEyfcrVtt5A5VmOQyMLBRs5pAnS0xD59F0wynKCFAS/vQzUQxfvwdhujjvGmZ+YdMwOMNt3SeXvXtzXrTGbjBJ316wAWc/sFc1pObko5WHt9AvvNmj5bN2k4Ycs71yw6HQceXtszXkDTmP+eyiihTGPK4dVX+6JuvTgeBJ0ebZAXyYzsqLNHKREDe+sTb+9yz+44njxj4Jp70T1MtNgkXtjRQUaCqi9EHJwB7jqNKD3fGBWXexzDNQPAAEqgpf/xEQwsmM3N5KArlqjBP9xBwMuKtVCI+cWp5PXyfeU8lR0gttuRMX7GzIEU72FvUmgwtrNVgP0gWSeL9M+D4CcPHPw64ZBQS+Dogj43lEpvYx86WmTeD2WgGaZ9FRgHe0s+HNp/kAUSXwzdQ+fHa/R8Bi+dL5UUEazI2GU60hk7sEktN+Xw7w0AtHghBmvBzb+NUEjF7w71KMervy+cEe92y0jB7nQB2lK4vzrKc2MTKBOw+zVaAJTIUmNZuNVbLuF0zj6pKczPgjrMCaD/oLsZEfr00dsqBXF3hhi8HNdzd5ZlATi4olVvNy7kKhpRQk24qznUKw76lXVJq0CzETWt4yO64i37dkKmcEAXfyKfTrdHmvJ1po6olL8Zshe9i7GHQ6DNyrf7/YF0wOr0S4e8+IkWmyi5WJRV/zR1yfcK7UokF5+LRPvnEJ7G+VrFRFnNN9oVjmXUJSnmTJeHZA335MUm5+QjC07bpVBDupj3YttqyVsdMRH8qdmHi2yZDSMfs0Gn/8thzjuppt0LOn39t/Y1UVZvBLE/sHE1PjriOFJShFjMcDNPYfkYh/PbcrCfptg292VYkfeYVPkpQPVxS6Wn+2+RokIj
 pm250ikF
 xYc0UhLwJ/Lb5M9/nUm64EaSOQrpXc6f9ZUHxxUk0ZngWVwAqjKuT/D0mbIH5uR/ySFTBG+uCG7uUw5Mj+7/nidLqUDIp57kluZkNH07rDaSMDBf1yqmjb/Ye4dqY2TNRg+xtaIN5N2P06KyD9p1IpAJ1OvGd4E1mgU6raP941g3VrvkEhBAvKoHQ15BxpwN+bAP3xcJYncBQfY3H4m2a/+qfZZfKceajtcyd6fFwx0MusD4Fjh65zctnadyPs0HMVBMpC4Dt3LswYAvH8nvJKqCRDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:58:26PM +0800, Kairui Song wrote:
> This series removes the SWP_SYNCHRONOUS_IO swap cache bypass code and
> special swap bits including SWAP_HAS_CACHE, along with many historical
> issues. The performance is about ~20% better for some workloads, like
> Redis with persistence. This also cleans up the code to prepare for
> later phases, some patches are from a previously posted series.
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
> enabled THP swapin for all folios. It's still limited to SYNC_IO
> devices, though, this limitation can will be removed later. This may
> cause more serious thrashing for certain workloads, but that's not an
> issue caused by this series, it's a common THP issue we should resolve
> separately.
> 
> Link: https://lore.kernel.org/linux-mm/CAMgjq7D5qoFEK9Omvd5_Zqs6M+TEoG03+2i_mhuP5CQPSOPrmQ@mail.gmail.com/ [1]
> Link: https://lore.kernel.org/linux-mm/20240326185032.72159-1-ryncsn@gmail.com/ [2]
> Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [3]
> 
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Unfortunately I don't have time to go through the series and review it,
but I wanted to just say awesome work here. The special cases in the
swap code to avoid using the swapcache have always been a pain.

In fact, there's one more special case that we can probably remove in
zswap_load() now, the one introduced by commit 25cd241408a2 ("mm: zswap:
fix data loss on SWP_SYNCHRONOUS_IO devices").

> ---
> Kairui Song (18):
>       mm/swap: rename __read_swap_cache_async to swap_cache_alloc_folio
>       mm, swap: split swap cache preparation loop into a standalone helper
>       mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
>       mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devices
>       mm, swap: simplify the code and reduce indention
>       mm, swap: free the swap cache after folio is mapped
>       mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
>       mm, swap: swap entry of a bad slot should not be considered as swapped out
>       mm, swap: consolidate cluster reclaim and check logic
>       mm, swap: split locked entry duplicating into a standalone helper
>       mm, swap: use swap cache as the swap in synchronize layer
>       mm, swap: remove workaround for unsynchronized swap map cache state
>       mm, swap: sanitize swap entry management workflow
>       mm, swap: add folio to swap cache directly on allocation
>       mm, swap: check swap table directly for checking cache
>       mm, swap: clean up and improve swap entries freeing
>       mm, swap: drop the SWAP_HAS_CACHE flag
>       mm, swap: remove no longer needed _swap_info_get
> 
> Nhat Pham (1):
>       mm/shmem, swap: remove SWAP_MAP_SHMEM
> 
>  arch/s390/mm/pgtable.c |   2 +-
>  include/linux/swap.h   |  77 ++---
>  kernel/power/swap.c    |  10 +-
>  mm/madvise.c           |   2 +-
>  mm/memory.c            | 270 +++++++---------
>  mm/rmap.c              |   7 +-
>  mm/shmem.c             |  75 ++---
>  mm/swap.h              |  69 +++-
>  mm/swap_state.c        | 341 +++++++++++++-------
>  mm/swapfile.c          | 849 +++++++++++++++++++++----------------------------
>  mm/userfaultfd.c       |  10 +-
>  mm/vmscan.c            |   1 -
>  mm/zswap.c             |   4 +-
>  13 files changed, 840 insertions(+), 877 deletions(-)
> ---
> base-commit: f30d294530d939fa4b77d61bc60f25c4284841fa
> change-id: 20251007-swap-table-p2-7d3086e5c38a
> 
> Best regards,
> -- 
> Kairui Song <kasong@tencent.com>
> 

