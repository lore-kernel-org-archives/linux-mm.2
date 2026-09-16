Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4449EC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B886B0088; Wed, 16 Sep 2026 06:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB776B008C; Wed, 16 Sep 2026 06:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB0E6B0092; Wed, 16 Sep 2026 06:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0463E6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:19:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F5E940666
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:19:43 +0000 (UTC)
X-FDA: 85219229046.30.281B126
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 72E0D20009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:19:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789553981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=d/k2QwEHlu9GdoguTxDgcOGaFD5m3zZTSVSnJJvXJYw=;
	b=49BuAkEbXW0oBR3rp1U4g3YCX660D4ttxvf0y9OcUvS4LJu4cd5QSxQc9iLvxos8sEeSII
	2+1yXLtM/Ih37wu16nLm+5ZsHlCXUHMlgebGHmeX1s6ABWDinzcniqsrKx4wxsbrETuOtr
	yE8j3jHNtG7f+WfCAze/zfsulW9zsrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789553981;
	b=5PYqgZz4NbOFfMKl59DFrYZWUm/0Mmsq3NPDM5kCowMHX03PB4XMuSz54lX5K6UhKSzO7p
	n21pZm4vZydotKxXktOuyBkT2uaQC+TR/lPCZ6SalQ/1VBboPKDk5K4nQdnOSR+tSjVW3S
	C8XQGVQVDTNKWAvefEWK9iRZ1tbNIio=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8bd0561a397f3082;
	Wed, 16 Sep 2026 10:19:38 +0000
X-Mizu-Trace-ID: 8bd0561a397f3082
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
Date: Wed, 16 Sep 2026 18:19:07 +0800
Message-ID: <20260916101929.149106-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 72E0D20009
X-Stat-Signature: hcjy4qzzgmixfq4ynuagfiy8o6b75c39
X-Rspam-User: 
X-HE-Tag: 1789553980-707728
X-HE-Meta: U2FsdGVkX18DbBdzUFoUDlU6UnrEFl0vgMdcML2XUO7TOOT6rFWO9AaEPA5jQQDbc+h0SO4ehBocj2clWlccrWKsTgLxO0SBR19+ESLJqV7ZBeASRc4/BWrsBpvaAtg5jSreeVOG6iGzWowjN/Znnsht+dKlnjxjNmCT4RursV7vctCzBEjS/npVMRd/jeBKgCT3D/+wRefmx0gtPI574Y0p4eyF13nUvaJTacQrRgpBUgQu/dwshhuDDz6GJk6fZaiJu2nV/69RxAWH+d68sVjY0SzjLpEZpvQlpUIFzONJFunzuI4TL7KnqlL9Kj2iAKSWVIOQ7Be1xOFS1gMIDf5dBdRfSPSQTd27nL810opCKqCdcpki39o/lIEWOajldHCINRfmgn5TOM72ar1/f73LmK/vzwfcIx+5kHkVpigHscUZt8NdCyWuLLPpj0Et/6nUJY6UjdnPpKPaN7Ud6H/iJ8aTKRG8SL0lZsQX8NZtN318Ogd4FGAH+ZgtVFNOJNXiFKVuumWzNmyFPbCqFs0aNL3P8LPsiEmPG3i9vIgpaXzz41DXAOQihQ/mZsBRIQLJL4/NIUJgSm7VTh+kqpmA8pVutiPXMbbekaH4BVlBiSruwMj1kxqicAFS4rkO9xGtbMvilaoxGgMh3oHO5tdE+NHLt19TJGi0y8JK34hRq9so1uO/a41e5CJdiur/KIO8gDhcs0Nn/j+u1WSaBkMSSIb+GorJ9kCoheppNmTK+rZuVBlaVj1pQVIr4hsnU92yVMOeMHaux/T5sWQXhgf+o856vs6Au7BKtiPQTdIzie1ko1yjCPwChYUIFkvLZdf9MSgOKJ0hia3feJYnjAIqYfAURohr5VKZAsfFmsKZfnKXj4TH8k6eer3gtnuLhBCeIm0ut8AaklsPJnkSIfJC7wZ4/D35ANjmHPGVHkviCLFA3iYAflfXZ0a9n84uqODtF+kMj2xphobIHcP
 k96Ar3CB
 WtmhH+Idcx9GlGP+w27zTUVhzCAygNikF1EoCWxwS+XxdZCdf37Yf6SUQ4+I3rlAHtwwgGAk5rCztSohO0Fv+awbaTlqcb5INukjAEe+hg5DN3yGkClV+xBfXZxrX1V9adSWw4YinpQI5ZIeLIEoOTWi4zyOZPqiMUbvI6O1m7KAupR+JkWe7mp8Z+7iaKXYIXsTVRGUzOFdyq+/suVTMXZ0QLZOXSFpzoPvB9wm09mHbCbmS3/5apxBP+E1xfuzrnp4TN57zt4GoqrJnp49XxzuO4pe6/yzXUTNtAFMfhtb5cCPakabjNiI6fJxcko0ML3bVSzsxPd6rkbk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap is a swap device with no backing storage. Swapped-out pages live                                
in zswap. Its cluster_info[] array lives in a VM_SPARSE vmalloc area,                                 
and the area is grown and shrunk on demand as swap usage changes.                                     
                                                                                                      
The problem being solved is the static size of compressed swap. Both   
zram and zswap need the size fixed in advance, and neither gives memory 
back when the workload shrinks. The solution should be a device whose
size can scale up/down as per usage. xswap does that by mapping the
metadata lazily instead of reserving it for the whole range.

Design   
------                           
- si->cluster_info[] stays a plain array. Access is still
  &si->cluster_info[offset / SWAPFILE_CLUSTER]: no per-access branch, no 
  RCU discipline, no tear-down state machine, no NULL return.              
- Only an initial chunk is mapped at creation. The rest of the address     
  space is reserved, not allocated, so an idle device costs nothing.
- Growth is driven by allocation. When no free cluster is left and the       
  address space has room, the next chunk is mapped and added to the free  
  list. No userspace involvement.
- Shrink is driven by frees. The free tail is scanned, and whole chunks
  are unmapped once the mapped range is at most half in use and several
  chunks can go. One chunk is left mapped as slack, so the next                                       
  allocation does not map it straight back. A ceiling lowered below the                               
  mapped range skips the half-in-use rule and is enforced at once.

Size
----
A device starts at 1xRAM, rounded down to the cluster. That costs
nothing, because the mapping is lazy. The underlying address space is
2xRAM. An optional per-device cap,
/sys/kernel/mm/xswap/type<N>/limit, lets an admin lower the ceiling;
the excess is unmapped right away. Grow and shrink both work without
it. Creating a device requires zswap.

Interface
---------
  /sys/kernel/mm/xswap/create           write an optional priority
  /sys/kernel/mm/xswap/destroy          write a swap type
  /sys/kernel/mm/xswap/type<N>/limit    read/write, in pages
The device shows up in /proc/swaps as xswap<N>.

Note
----
Writeback, rmap lookup, etc. are consumers of this base. I have a
writeback prototype on top of this base and will post it as a reference.

Testing
-------
qemu KVM guest, 8G RAM.

Tested create/destroy, raising and lowering the limit (including clamping
when it is written below the pages in use), shrink with live entries, and
2000 create/destroy cycles for leaks; all passed.

The workload is memhog: it faults in N GB of anonymous memory inside a
cgroup with a much smaller memory.max, forcing the pages to swap.
Set MEMHOG_FILL=pattern: the default fill is all-zero pages that zswap
compresses to almost nothing, so the device never fills.

  # echo 1 > /sys/module/zswap/parameters/enabled
  # mkdir -p /sys/fs/cgroup/xswap_limit
  # echo max > /sys/fs/cgroup/xswap_limit/memory.swap.max
  # MEM="MEMHOG_FILL=pattern numactl --cpunodebind=0 --membind=0 ./memhog"

1. Create and destroy

   # echo > /sys/kernel/mm/xswap/create
   # swapon
   NAME    TYPE  SIZE USED PRIO
   xswap0  xswap 7.8G   0B   -1
   # cat /sys/kernel/mm/xswap/type0/limit
   2035199
   # echo 0 > /sys/kernel/mm/xswap/destroy
   # swapon
   (nothing)

   limit is in 4 KiB pages; 2035199 is RAM (2034976 pages) rounded up to a
   whole number of clusters. The device starts at RAM, not twice RAM.

2. The cap holds

   # echo 2147483648 > /sys/fs/cgroup/xswap_limit/memory.max
   # ( echo $$ > /sys/fs/cgroup/xswap_limit/cgroup.procs; eval $MEM 11 300 ) &
   # awk '/SwapTotal|SwapFree/' /proc/meminfo
   SwapTotal:       8140796 kB
   SwapFree:         354012 kB

   The cgroup runs out of room before the device does and the OOM killer
   takes the workload — that is the pass signal. SwapFree never exceeds
   SwapTotal, so nr_swap_pages never goes negative.

3. Raising the cap

   # echo 3052543 > /sys/kernel/mm/xswap/type0/limit
   # awk '/SwapTotal/' /proc/meminfo
   SwapTotal:      12210172 kB
   # ( echo $$ > /sys/fs/cgroup/xswap_limit/cgroup.procs; eval $MEM 11 300 ) &

   No OOM this time: 2473705 pages in use against 2034976 pages of RAM, so
   usage goes past RAM.

4. Lowering the cap below the pages in use

   # echo 1000000 > /sys/kernel/mm/xswap/type0/limit
   # cat /sys/kernel/mm/xswap/type0/limit
   2426879
   # awk '/SwapTotal|SwapFree/' /proc/meminfo
   SwapTotal:       9707516 kB
   SwapFree:             860 kB

   The write is clamped up to the clusters covering the pages in use, so
   the free slots in the partially used top cluster stay accounted for.

5. Shrink with live entries, then destroy

   # echo 4069887 > /sys/kernel/mm/xswap/type0/limit
   # sleep 60
   # awk '/SwapFree/' /proc/meminfo
   SwapFree:       16279548 kB

   The shrink unmapped the tail — the state find_next_to_unuse() must
   survive. Put live entries back and destroy:

   # ( echo $$ > /sys/fs/cgroup/xswap_limit/cgroup.procs; eval $MEM 3 300 ) &
   # echo max > /sys/fs/cgroup/xswap_limit/memory.max
   # echo 0 > /sys/kernel/mm/xswap/destroy
   # swapon
   (nothing)

   dmesg stays clean across create, shrink, swapoff and destroy.

6. 2000 create/destroy cycles, diffing /proc/slabinfo before and after:
   the largest growth is 142 objects. One object leaked per cycle would
   be 2000.

Performance
-----------
(qemu KVM guest, 8G RAM, zram as the swap device)                                                         
This series should not slow down a kernel that never creates an xswap
device. I measured that overhead by comparing the base tree with this
series. Both were built with the same .config and CONFIG_XSWAP=y, and no
xswap device was created. I ran three 3G MADV_PAGEOUT workloads, three
rounds each, alternating between the two kernels across reboots. I
counted retired instructions per page swapped out with perf stat:

  workload                      base       series     delta
  swapout                       50824.8    50866.2    +0.08%
  swapout and swapin            63770.4    63796.8    +0.04%
  swapout into a full device    67729.9    67707.8    -0.03%

Two runs of the same kernel differ by less than 0.1%, so the differences
above are real, not measurement noise. I cannot use wall clock time for
this comparison, because two runs of the same kernel differ by more than
the two kernels do.

Changelog
=========
v2 -> v3:
- Rebased onto the latest mm-new.

- The grow path now honors the user-set ceiling (si->nr_clusters) instead
  of growing up to nr_clusters_max, and a ceiling below the mapped range
  is unmapped exactly instead of rounded to a chunk (patches 12 and 14).

- The limit write clamps the ceiling up to the clusters covering the pages
  in use, replacing the earlier WARN_ONCE; si->pages becomes mutable at
  runtime (patch 13).

- Minor comment and cleanup changes.

v1->v2:
- Patch 1 (mm: zswap: return -ENOENT when the swap device is gone) is not
  part of this series; it was posted separately.

- There is only one size knob now. The runtime ceiling and the debugfs
  per-device limit are gone. All that is left is the optional per-device
  cap, /sys/kernel/mm/xswap/type<N>/limit. Grow and shrink work without
  it.

- The shrink no longer keeps its own count of the free tail. It scans the
  tail instead, and dropping the counter also removes a call from the
  cluster allocation path.

- The priority is no longer a patch of its own. The create attribute
  takes it:
    echo 100 > /sys/kernel/mm/xswap/create

RFC v3 -> v1
- Add patch 16 to support setting xswap device priority at creation.
  The create sysfs interface (/sys/kernel/mm/xswap/create) previously
  hardcoded every new device's priority to DEF_SWAP_PRIO, it now
  accepts an optional priority:

    echo "<percent> [<prio>]" > /sys/kernel/mm/xswap/create

- Bug fix: xswap_lock init ordering. mutex_init(&si->xswap_lock) was called
  after xswap_map_clusters() (which locks it), i.e. locking an uninitialized
  mutex. Init now before the first xswap_map_clusters() call. Thanks to Klara.

- Bug fix: Fixes a compile error in !CONFIG_XSWAP builds. xswap_debugfs_root
  is declared inside CONFIG_XSWAP ifdeffery scope, so the ungarded use
  caused error when CONFIG_XSWAP is off.

RFC v2-> RFC v3:
- Replace the "header-only swap file + swapon" creation hack with a
  proper file-less device created and destroyed via sysfs
  (/sys/kernel/mm/xswap/{create,destroy}).  This required the
  __swapoff() refactor and the free_swap_cluster_info() signature
  change (patches 4, 6, 14).

- Require zswap: refuse to create an xswap device when zswap is
  unavailable (patch 15).

- Split the unrelated zswap -ENOENT fix out of the series into a
  standalone patch (patch 1).

- Fix nr_free_tail over-counting on concurrent grow, shrink leaking
  detached clusters on early bail-out, a re-init race on cluster
  spinlocks in xswap_map_clusters(), the nr_clusters_mapped update
  ordering, and swapoff accessing the shrinker-unmapped cluster tail.

- Minor cleanups (checkpatch, /proc/swaps alignment, commit messages).

RFC v1-> RFC v2:
- Added __GFP_HIGH | __GFP_NOMEMALLOC to alloc_page() and kmalloc_array()
  in the grow path, plus memalloc_noreclaim_save/restore() wrapping,
  to prevent the grow path from consuming emergency memory reserves
  or recursing into swap under PF_MEMALLOC. This is folded into patch 3.
  This was pointed out by Nhat.

- Folded the mutex serialization fix into the cluster grow patch (patch
  3). This is suggested by Nhat.

- Fixed coding style issues: corrected indentation of declarations in
  xswap_unmap_clusters(), removed unnecessary block scope around the
  err variable in xswap_map_clusters().

- Rebased onto mm-unstable

Baoquan He (13):
  mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
  mm, swap: refactor free_swap_cluster_info to take swap_info_struct
  mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
  mm, swap: add sysfs create interface for xswap
  mm, swap: add xswap grow trigger on cluster allocation
  mm, swap: add xswap_try_shrink and shrink trigger on cluster free
  mm, swap: free backing pages in xswap_unmap_clusters
  mm, swap: defer xswap shrink to workqueue to avoid lock recursion
  mm, swap: refactor swapoff and add xswap_destroy
  mm, swap: require zswap for xswap devices
  mm, swap: cap xswap growth at nr_clusters
  mm, swap: add sysfs per-device size limit for xswap
  mm, swap: shrink xswap to the ceiling when it drops

Chris Li (1):
  mm: xswap support for zswap

 include/linux/swap.h |   26 +-
 mm/Kconfig           |    9 +
 mm/page_io.c         |   19 +
 mm/swap_state.c      |    4 +
 mm/swapfile.c        | 1240 +++++++++++++++++++++++++++++++++++++-----
 mm/zswap.c           |    7 +-
 6 files changed, 1174 insertions(+), 131 deletions(-)


base-commit: baa8de2f3448d1466a888a805c18d01c998fe052
-- 
2.54.0


