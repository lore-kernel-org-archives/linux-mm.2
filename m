Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7618AC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370766B0251; Thu, 13 Aug 2026 06:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3480E6B0486; Thu, 13 Aug 2026 06:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2854B6B0487; Thu, 13 Aug 2026 06:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05D376B0251
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:49:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92E3A12052B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:07 +0000 (UTC)
X-FDA: 85095923934.26.86CC5AE
Received: from mta1.migadu.com (out-81.mta1.migadu.com [95.215.58.81])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6F745160006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.81 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=RJH+i2BxsbLS2UywASM/dlDbnueH9NbHRCgNQLtHw5c=;
	b=hybWy7qyevBjXWmeW5w/2hoos99Dkobn9x9XRrxV/lvv76HtA94bbKKPblme2x4SWANCHH
	ZnPC4TqJ/oXTVNFRUouMFyoaJpN+G+V+7e0eazSD9uWy0XNV5XhXcgfAqWTnzlDZ1eyQm2
	cZn8hGC+Uu3FdDmhhnYZeRPP9c6c5IQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.81 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618146;
	b=GK9U5XabMHNc+DPuIJdFXpAIVnMUwrHloLGXW4sKLwtOyFtFVKWsubfnzSq/BrYlNd9bgt
	0qquLLCh5qhebvvRfMOH+KTVVCxaGlD63u0UB7cKtNgSak66Kd621jjdfQBFa8J34ELymX
	no1D8M9IOU7PSx9LbzI4Q6JcJq2Mut0=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 5e9b508ab49f9b79;
	Thu, 13 Aug 2026 10:49:03 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 00/15] xswap: extendable (virtual) swap device backed by zswap
Date: Thu, 13 Aug 2026 18:48:39 +0800
Message-ID: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ti8uksydhc8j3iagqsryyy8hut4x5ptk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6F745160006
X-HE-Tag: 1786618145-932043
X-HE-Meta: U2FsdGVkX19V9mzNucoeqc0Q+Lcv046127SOQRdgVKagaZO9QQO5klizh6fnlKAbCcfzIl1qHovsNRPvpJ+J+xlrUN1Pg2CEpcWUpbQMez+8tgjmP2AaEr+uAIzvYi0PWgBXvVruK9I3nfKMPKEbQMBMcp1ouje4qpF4OECIwdaIBN8D96UgaE+wEgED/B2290S+pliAgHoHpSBoK5EYcHkN3scvmXyBpOaNXY85sO0H1wmW0uK1G5wo7FLINQuzPZAknO68XJ5Jq72fYAOuPPK1HIeWzaeQRZDn96KiuNWbX7U9LS5NNkmoe2jZ00nqN86YBSlIji7DStkS148UfVk+n3MrLU4PdnZZLF47CaPKiOxsTZja2dbwrX3Z4ERRwFer8x8lLXE+u6tT+mEur70Agj/YSXYh7RbQCJ/wMxM1m8PlC/MMU2JHFpavwq6qqqqYmmPO9GHM+B76oXs/Mn9FgoEdJnmy1PNACqvhxvW1MDTauRgySr45qFM0BuarkE+wI6wcaLea4d+DT/BGSNHvwTj6TSs380ftzY5R0Zbsj5S4zM9rckyK7XvNuNpKanCQvTrpcSyz1JL4UiQP94iBtf9Q8oR1ZgCcgsiof63qPQzzmKNc5Efe1vi3y4p771zRlzf8bUQD/Q3f6jdOhcyjw/0pSrSlxMBH9w7iMkglkauORyR6LMs39z0JBKLk0cRADFd1p/RFRQI72mbSuFvtnm9/XHA7Em/1Cq2I9iV31pIYDdg7v2osr8b6x2fxy5lSpTDNtEtHbKsDKs3fVnT808iuKx1oSI+fZetxSRbnDOzLFBW3opDmlNxdSfQuQWcAJ2mcDO8ArZ+yw6ZMwivDNykec7pko48cW50bj6WQ5AmHe7TeoyTGjhMX78xYKQ+XAzE/zDgx1spubSN3p/we2TBmxcXL6CsTkZGqj/qBLzRMncOBNIxeWL+IemDcRiy6xZ+gLlpqn+81z6P
 rlZeqUyZ
 FwnLylS6NmNgwOGaNyoNknONTG7wqnjZR0jVC6PX873eccQQ29o4CSASDb2DzDkce9TlNZNYPx8iGtncVrEFusXemzWByPsDXvOT24yYSedL01tw15/QrvaPZ2+rQn2JjpT6wCX8SOhBmr5+Ke80CaDvSvkjpkLpoEfUi18S8TI2tJaCUShSrxHIgt2GjGAUzBCRPlJ6MYZyRuq72GgpFQuteKtPu4eV6OurgKApEdcTeDMu9H9MZcvq9LqEwOsMjNvsqGc01MMZRKGCzIk9k9KKWQBivudSPpRnScAw6G858DGrHc/733G9q51T2jpSfXm9fKMJNHidEr51dWkSn3gyk+QDJOPhIh0N62Ai5oLym0RnUmV91s6cp7uiS2C15Fz6ajknQZJUd4eFueHmV2xIcTucwJe30j+rh1O8sTG5cUH6yyzKlR1oEeZmHogvFzhQ0zEORuzWrd64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap is an extendable swap device with no backing storage.
Swapped-out pages live only in zswap, so the device wastes no disk space
and its size is independent of any physical device.

xswap decouples PTE swap entries from physical backing storage.  The
cluster_info array is backed by a sparse vmalloc (VM_SPARSE) area that is
grown and shrunk on demand:

- Grow: when cluster allocation runs out of free clusters and the device
  is below its ceiling, more physical pages are mapped into the VM_SPARSE
  area and their clusters are added to the free list.

- Shrink: when contiguous free clusters accumulate at the tail of the
  mapped range (tracked in O(1) via nr_free_tail), they are unmapped and
  the backing pages freed.  Shrink is deferred to a workqueue to avoid
  lock recursion.

A per-device ceiling (nr_clusters) bounds growth and is adjustable at
runtime via debugfs.

Interface:

  /sys/kernel/mm/xswap/create           write a percent of RAM (0 for
                                        the default) to create a device
  /sys/kernel/mm/xswap/destroy          write a swap type to tear down
                                        a device
  /sys/kernel/debug/xswap/type<N>_cluster_limit
                                        read/write the per-device
                                        cluster ceiling

Since xswap has no backing, swapped-out pages are stored compressed in
zswap: physical writeout is skipped, and zswap writeback is disabled when
every swapfile in the system is an xswap device.  xswap requires zswap, so
device creation is refused when zswap is unavailable.

Naming:
======
I'm going with "xswap" (the "x" for extendable/extension) rather than "vswap".
Chris suggested this name, and this aligns with the "VFS-like swap layers"
direction Chris Li described in the first swap abstraction LPC talk
(co-hosted with Yosry) — the swap ops and the xswap extension interfaces in
this series are moving toward exactly that. I don't have a strong preference
between xswap and vswap, so if reviewers object to the name, please comment.

Note:
=====
Most of the added lines come from the switch to a sysfs-based create/destroy
interface. v2 created an xswap device by handing swapon() a "header-only"
swap file (mkswap followed by dd of just the first  4K), and teardown reused
the normal swapoff path. v3 makes xswap truly file-less:
/sys/kernel/mm/xswap/{create,destroy} replace that file dance.

This patchset only build the base. On top of this, I believe Nhat's core code
of xswap writeback, rmap etc can be implemented simpler. E.g, we only need add
one field in struct swap_cluster_info to let xs_table point to physical swap
entry, or zswap entry etc. No need to introduce struct swap_cluster_info_dynamic.

--- a/mm/swap.h
+++ b/mm/swap.h
@@ -57,6 +57,9 @@ struct swap_cluster_info {
        u8 order;
        atomic_long_t __rcu *table;     /* Swap table entries, see mm/swap_table.h */
        unsigned int *extend_table;     /* For large swap count, protected by ci->lock */
+#ifdef CONFIG_XSWAP
+       unsigned long *xs_table;
+#endif


Testing:
========
1. enable zswap
# echo 1 > /sys/module/zswap/parameters/enabled

2. create xswap device
~# echo 0 > /sys/kernel/mm/xswap/create
~# swapon
NAME   TYPE  SIZE USED PRIO
xswap0 xswap 1.2G   0B   -1
~# echo 80 > /sys/kernel/mm/xswap/create 
~# swapon
NAME   TYPE  SIZE USED PRIO
xswap0 xswap 1.2G   0B   -1
xswap1 xswap 3.1G   0B   -1

3. tune the zswap size
~# cat /sys/kernel/debug/xswap/type0_cluster_limit 
1179
~# cat /sys/kernel/debug/xswap/type1_cluster_limit 
3145
~# echo 2048 > /sys/kernel/debug/xswap/type0_cluster_limit
~# echo 2048 > /sys/kernel/debug/xswap/type1_cluster_limit
~# swapon
NAME   TYPE  SIZE   USED PRIO
xswap0 xswap   2G 377.9M   -1
xswap1 xswap   2G 376.2M   -1

4. add memory pressure
stress-ng --vm 1 --vm-bytes 4G --vm-keep --timeout 120s &

create/destroy and grow/shrink xswap device casually, all passed.


Changelog
=========
v2->v3:
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

v1->v2:
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

Baoquan He (14):
  mm: zswap: return -ENOENT when the swap device is gone
  mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
  mm, swap: refactor free_swap_cluster_info to take swap_info_struct
  mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
  mm, swap: add sysfs create interface for xswap
  mm, swap: add xswap grow trigger on cluster allocation
  mm, swap: add xswap_try_shrink and shrink trigger on cluster free
  mm, swap: free backing pages in xswap_unmap_clusters
  mm, swap: add nr_free_tail for O(1) xswap shrink detection
  mm, swap: add adjustable runtime ceiling (nr_clusters) for xswap
  mm, swap: add debugfs knob for xswap per-device cluster limit
  mm, swap: defer xswap shrink to workqueue to avoid lock recursion
  mm, swap: refactor swapoff + add xswap_destroy
  mm, swap: require zswap for xswap devices

Chris Li (1):
  mm: xswap support for zswap

 include/linux/swap.h |   12 +
 mm/Kconfig           |    9 +
 mm/page_io.c         |   16 +
 mm/swap_state.c      |    7 +
 mm/swapfile.c        | 1012 ++++++++++++++++++++++++++++++++++++++----
 mm/zswap.c           |    9 +-
 6 files changed, 979 insertions(+), 86 deletions(-)

-- 
2.54.0


