Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B8C606A33D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5zrqDaC
Received: by kanga.kvack.org (Postfix)
	id 7F0F86B05F9; Mon, 16 Nov 2026 06:14:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8816B061C; Mon, 16 Nov 2026 06:14:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7FE6B061D; Mon, 16 Nov 2026 06:14:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 482006B05F9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:14:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCFFA40975
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:14:26 +0000 (UTC)
X-FDA: 85440723732.24.DEFDB5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43763120003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:14:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5zrqDaC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNPAh5bBD/DCtRCxR0hqcD+XfwtFgFjRzluMrGXNBRI=;
	b=tsNISHO9M1gfz1yL7i+syRPEr6ko4CxAIFClph+OHuGLz8+Zzrrg/2e0r8yi7UEeEVXFpj
	31QMsBWvwOh4hxF7QMkvPZGJ1zSs4advmBKASXEjYZ3jczdgwrXfWyVfiwcTw/ZpJNHSTD
	E/qNOI972MQX85eurv25uzRB3UAXaxU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5zrqDaC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827665;
	b=Bio7WrLbc84Gh29srZrgKRk9n2F/m9pN/ec/qJJC39itTDfgN7FwmBwMGohHNngumGCxa3
	b6LB9wQ0w8qrAobSJfnN1nERXebrrRWb4NcWJAzC7j1AVSwxDUVeluQ0rpgyo0Z+Ows6H0
	IC4MpOGo2C7SQxsOEST9fAiYTYRQD8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6AE561230;
	Mon, 16 Nov 2026 11:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E331F000C4;
	Mon, 16 Nov 2026 11:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827664;
	bh=KNPAh5bBD/DCtRCxR0hqcD+XfwtFgFjRzluMrGXNBRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O5zrqDaCTmINWztAloFXN+rib9w6MXO+Cig6Cqk8sJgar8MILTmb6qSQTzdhtT5vQ
	 /ai9JqDwBZCd7Bj+66UtHdzRGQDUWraCnMEPl+H+91qobdHvRBE09minUyXSPTDOHN
	 SR+Z1HO69AKxCZozQX2A13wcm5W1p7E/BSAAzcXVEhs/gGNPHLVeJwRsAhCy42glLk
	 sZzo45Lyuk1zo5M3067MD/U5Kh3sJlqEb0fmFvM6jPpWFQNAtIp4vwa8652NKBEqcq
	 gXMnfrqG3xlHcUMPkCUaZyXk5hZd2JZpuKmAXRzngkZkn3miQVNMe57FPiGEnq0Vq6
	 plAw86jLVh3yQ==
Date: Mon, 16 Nov 2026 13:14:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: nakixii <nakixii@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed
 pages
Message-ID: <avrliOfBi326au6B@kernel.org>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 43763120003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: yt91eycbik3txjhmy5oa7rm95jd33ddb
X-HE-Tag: 1794827665-449414
X-HE-Meta: U2FsdGVkX18ti6FF/L4wKO9n3juX+AjN1pNGCuufqWDCgvJ+M2Hto/Wm9+pgyzW89LnFlOL2caCae3aZqOXT9XTNmNUgQV0J7N09nERPfe07p61F61avxtQ06mMaGzlCMgbbbhZLQMaVF3XJa7OyqzpOD/2ux/GaN2gnV5uaozVwfdm5onFTqrA9P9kkzORPF2/gU8h2dNt6HZDu8vVXvJOiYyd1uZilcLvKd3Sce4PK3mzwa7ttW9yvGqMlSlDwMBSW34FQ/hCkhl5L6DAncKA0Yf13x3dhbtPetYSZBQvSbUTr5O+7nASXmJA1JHx5okViwXCG3flNQznaNphQVHlppXJ4rfwIjEzr8w7SNRkZkeJecoYRLO/sL5gGwXh4V2CRQVpyWHXDnmhoIg3fmNkasVeQZA4Y9C3+yJ2TbQzUt5nkMbHVYGjzCVZMA66FfB6hsX2A0uf0nLiCa05FsTkVRTbQhU4Y5qYcIHMwlp7OdAF5+RyVRNQwjGhqldmhZLnPSujuf9IaLtmFIHgQWFC89GGOgwxWIU2bvn2ukvVjii+kbTBzxeEv5jQ1eoy3VKcx9ee3D8YGNwn+rkYfH+SAkov6KjM598J6bDGXxvlOaUWj4TzTdcZkfZ3iKb94AESkpOHoFrfySuxQCTooTEtsuFeCwRzXKhOOQz7zrAB1GRoMuWb/oMU7mBSJrVhkuCLC7F1VJrhZM5yWhvqCVmvojQF7GR4fnIcYoL5eJuTdoq6V2ptpViXjOymhPCq+aRGmxVDp8oy5/VbdsmJVLK7/2tvYp7hqxljly2e0DHe5qC3B3GeSGpIYaINsINmMkeABVgJMiyWjRcsDXV7cuiPaNQHgXT51oGlAZ1FSuc0lYtv6l1wjyN1XsVduwqG7Z9nnLKtRMOpwiKSiZSX/ZiYyMNx1wg+ByJmWPKboibxwQjr/k/Sz2hKof1eUA1ZhB+aFFqcm6Hj6JlndDsh
 HLiQUvFJ
 Vj+MDPRj8u/06MIClGmMGFRJIwLEli2Ea/O4pC9Qgutm7FZVLCVlJbrooPB9xzzasp6pos+1016sfTD1tclv/DuNYQKcAM6eRooF2IHdqkq0oi5WuA44nRn2E4j1Yno8Pp1I62rqPuAGjAQHXTPQWxWghg8oo/1piFuAeS1ZPvQ5qqayLr1SBg4vUZQGgtFfRw0n2M7m0az80rBfafbl5xPdsN1Zs5h8Gjf9g75Hhwr//vbqa1F/KpgJGcGLJS8zbbbNX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Mon, Nov 16, 2026 at 07:01:06PM +0800, nakixii wrote:
> This is a proof of concept, posted to ask whether the approach is worth
> pursuing. It is not meant for merging. The series is based on Linux
> 6.12.23, not on mm-unstable, and has not been ported to the swap-table
> and zpool changes that have landed since. If there is interest, the
> next version will be rebased onto mm-unstable.
> 
> memcomp stores reclaimed anonymous and shmem pages in compressed form
> in memory, using the kernel's compressors and zsmalloc unchanged.
> Reclaim replaces the PTE, or the shmem page-cache entry, with a
> swap-like token that names a 16-byte slot. A fault on the token
> decompresses the page and maps it again. No block device is needed. If
> swap is configured, cold entries can be written back to it. The sysfs
> interface is under /sys/kernel/mm/memcomp.
> 
> Results
> =======
> 
> The comparison ran 965 fresh guest boots on real application pages,
> under nested KVM on WSL2, with a paired rule fixed before collection.
> Selected results:
> 
>   Without real swap, single-page refault p99 was 10.7 us against 20.7 us
>   for zram with lz4, and 22.0 us against 27.3 us with zstd. Under
>   512 MiB of anonymous pressure, refault p99 was 37% lower than zram
>   with lz4 and 36% lower than zswap.
>   Completed-switch p99 with zstd was 33-36% lower than zram in 10/10
>   rounds and 20-22% lower than zswap in 9/10; these differences were
>   smaller than the reference's variation between rounds.
>   After writeback, readback p50 over an 832 MiB target was 11.9 us
>   against 105.5 us for zswap and 114.0 us for zram writeback, with
>   70-76% fewer bytes written before readback; p99 was about the same.
> 
> Less favorable:
> 
>   With real swap, single-page refault p99 was 4.8 times zram with lz4
>   and about 1.5 times zram and zswap with zstd.
>   Sequential refault was 30-31% slower than zswap, since there is no
>   swap readahead. Single-page pageout p99 was 35-38% slower than zswap.
>   In the pageout and refault workload, 64 MiB of real pages per
>   application, memcomp used 5-8% more memory than zram; this leaves
>   out zram's disksize-sized table, which was larger than the difference.
> 
> nakixii (16):
>   mm: userfaultfd: check the exclusivity of the page being moved
>   mm: add a swap entry type for in-memory compressed pages
>   mm: memcomp: compress reclaimed anonymous pages in memory
>   mm: userfaultfd: let UFFDIO_MOVE move memcomp entries
>   mm: memcomp: charge compressed pages to the source memcg
>   mm: memcomp: store shmem and tmpfs pages
>   mm: memcomp: write cold pages back to swap
>   mm: memcomp: compress foreground batches asynchronously
>   mm: memcomp: batch unmap reserved large folios
>   mm: memcomp: queue restored large folios for splitting
>   mm: memcomp: account user eviction and refault
>   mm: memcomp: report precise token residency
>   mm: memcomp: add KUnit tests
>   selftests/mm: add a memcomp pageout and refault test
>   mm: memcomp: add the design doc
>   mm: memcomp: add the admin guide
> 
>  .../ABI/testing/sysfs-kernel-mm-memcomp       |  363 +
>  .../admin-guide/kernel-parameters.txt         |   10 +
>  Documentation/admin-guide/mm/index.rst        |    1 +
>  Documentation/admin-guide/mm/memcomp.rst      |  149 +
>  Documentation/mm/index.rst                    |    1 +
>  Documentation/mm/memcomp.rst                  |  215 +
>  MAINTAINERS                                   |   12 +
>  fs/proc/task_mmu.c                            |   20 +
>  include/linux/memcomp.h                       |  481 ++
>  include/linux/memcontrol.h                    |   45 +
>  include/linux/swap.h                          |   52 +-
>  include/linux/swapops.h                       |   22 +
>  mm/Kconfig                                    |   75 +
>  mm/Makefile                                   |    1 +
>  mm/hmm.c                                      |    3 +
>  mm/huge_memory.c                              |   44 +
>  mm/internal.h                                 |   84 +
>  mm/madvise.c                                  |   10 +-
>  mm/memcomp.c                                  | 6181 +++++++++++++++++

... (a lot of memcomp/ +++ changes)

>  mm/memcontrol.c                               |   99 +
>  mm/memory.c                                   |   42 +-
>  mm/migrate.c                                  |   11 +-
>  mm/mincore.c                                  |  125 +-
>  mm/page_io.c                                  |   42 +
>  mm/rmap.c                                     |   41 +-
>  mm/shmem.c                                    |  251 +
>  mm/swap.h                                     |    4 +
>  mm/swap_state.c                               |    5 +
>  mm/swapfile.c                                 |   49 +
>  mm/userfaultfd.c                              |   94 +-
>  mm/vmscan.c                                   |  651 +-
>  mm/workingset.c                               |   32 +
>  tools/testing/selftests/mm/Makefile           |    9 +-
>  tools/testing/selftests/mm/config             |   11 +
>  tools/testing/selftests/mm/hmm-tests.c        |  112 +
>  tools/testing/selftests/mm/memcomp.c          |  831 +++
>  134 files changed, 46825 insertions(+), 14 deletions(-)

This seems to big of a change and the wall of text in your "results"
section does not explain clearly why would we want to bother reading this.

-- 
Sincerely yours,
Mike.

