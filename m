Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E19C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC52F6B0088; Thu, 27 Aug 2026 05:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77546B0095; Thu, 27 Aug 2026 05:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C3E6B0096; Thu, 27 Aug 2026 05:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 664EC6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:45:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED7E5A3B55
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:17 +0000 (UTC)
X-FDA: 85146566274.18.31537E0
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	by imf01.hostedemail.com (Postfix) with ESMTP id D838840008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=5rfz/TFhRrUqOZeQmsVSIhdEifohxFsy8luPtLtjgDM=;
	b=i8ZPJoU0dAYFqsHRDKTvDg9d0YpLq6bSES1ZcNYlfu7Duhr6OE37VcpqjAY5kQCUkK/Ekm
	32XDi7zoJWMMvAigbQLz6L9xgu5RVGuFnIuXnEcFRo2FnE0a/NJ1K4JI+exDHhjjte2Y2J
	o97XttRzv7AZQLkxF1CZcDLtT8shRHI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823916;
	b=8GdziFpNrBesXkc25Sy7njaHbGd5j6Z9ba3wM24K463loWpG+1q8qwvAS1BrcRZU9YXl+I
	L50jjpe5w30nhhsXrj0Eo2t7OgOiOadQOORoPcUPbL0NFpVx1PuG49YbEjNVZ7t+RiISmw
	NbUFxstyxNb2u0ukHZ3n9+4pAr0bHAI=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id a013d3723c0a0f63;
	Thu, 27 Aug 2026 09:45:14 +0000
X-Mizu-Trace-ID: a013d3723c0a0f63
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
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 00/16] xswap: extendable swap device backed by zswap
Date: Thu, 27 Aug 2026 17:44:50 +0800
Message-ID: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fo7y6m4tchytw6kky8nj4focnikinrdw
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D838840008
X-Rspam-User: 
X-HE-Tag: 1787823915-520440
X-HE-Meta: U2FsdGVkX19Wp3I0670px81w6FB2TeqKeicBAH7Sf+2D1U3dqG0xPh4sO6kKKHactysWcyQOnqq8BShyBf9dcj4Y+zHTShea5udcbHZ+DVtjdP+ByPLiBrBXNZoD9NUkHztSt9HI713GUTOS2oCCQYL4CHyjHkSQeZ00egbzD15BqhtCZmz4A/0BgPQ4UIJeIRYswu3U/sjqCiO5ymiZ3sbg5InQpyUNYCijhKgZ4qPJJLF+CTklQoxVTyDh7YCPZzqzTnNJP0fsY9X54ISg6lxya0o0T9HaOpjUjeC0fHUn0xFUaMakLyizU0Qf6ofgPLAbdSXgv9G0sduGuJVy1gyIfh+HuxR45C3w8AJBAF0EYBa4Z6HhLI4uKkvsINgGr6VZ4KNY+oof5UJCqguMLBHoJ1BMoIWxAVXyeOTAPJsbI7zuwttECLWm13BsBa9feVFte5iCKyDgVbdJS/20Q0NEkDe5KJw8+hefXNaG4eya398GMtQUqBW8L9TbICC2Pon+rKz5E6xe9shAXJF38CCrLiPKJ80k4khXRAqR+VSOp6KRW7Gblkabg14Fuc2i3cT6cFS4tME0UEhBxJH0yOD//pyO1JvLoZbh2BJsZyobtUdynsBtxKuYMvu3H5GQ28jRMs+GGYVTrPGe9WtroKkBzroC7iFQNmO81kl1TQHcJJAZ6K9IEctDsnbKaxDK4bnunN7TXgVkSYjmhsUJgwb/Ol8S5HbZLLD0VZb685Dfmo7mfR+wsdPPMCzJnV7L7r3z1DozTVvqto24qHr3m6fE34v58zVxXfkrMPvL8tNKcXB3ddt4mATGZtnVmDWJHH2TJfseleDD8mXQA/wQWb0mlc509F+F7CjkDTZYsaf6ddOGkiv7e7At5XuHqZ/fU1DmqKsGauFeOnttc4eUX3x6M5n4PP/zQOfa0Rv8zbaAnVJ577okjrqtcpCp1OhuN/l8ftIgysSEjOjoSYp
 7rwLTgzz
 u1UiY4aJ6iitmRlp/Vg6bLF0EFBFANTsBYU3V/y5DfKw3F5j9KGk/SkYbk+B/5++2bZFaqf/9w0Sm1ESLyy+UJ0gQXLpkp9xjnEJDn8/nL+wHE/Yxe+JOmnS/CaX99GBa/+7QM1GO4qrUru6SxRWKwYUWVlngpSSdHJZ/lYPXxLqRleDjvQ4lXxf812krIuotjGk/mlnvtMPEYwTkmhd3Rgxadekk0QnyK5D4GxKh9QHgXuFU8BiFlX8KxYAuFeiAULI5xSIZI4Gexe5R5CJqgz44d2xmc3SJf9qurP7ziK5545s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap is an extendable swap device with no backing storage. Swapped-out
pages live only in zswap, so the device wastes no disk space and its
size is independent of any physical device.

xswap decouples PTE swap entries from physical backing storage. The
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

  /sys/kernel/mm/xswap/create           write "<percent> [<prio>]" to
                                        create a device; percent is a
                                        percent of RAM (0 for the default),
                                        prio is an optional swap priority
                                        (default DEF_SWAP_PRIO)
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
(co-hosted with Yosry) the swap ops and the xswap extension interfaces in
this series are moving toward exactly that. I don't have a strong preference
between xswap and vswap, so if reviewers object to the name, please comment.

Note:
=====
This patchset only build the base. On top of this, the subsequent core code
implementation of xswap writeback, rmap etc can be done more easily. E.g, we
only need add one field in struct swap_cluster_info to let xs_table point to
physical swap entry, or zswap entry etc. On top of this patchset, no need to
stir core data structure too much or introduce extra data structure.

--- a/mm/swap.h
+++ b/mm/swap.h
@@ -57,6 +57,9 @@ struct swap_cluster_info {
        u8 order;
        atomic_long_t __rcu *table;     /* Swap table entries, see mm/swap_table.h */
        unsigned int *extend_table;     /* For large swap count, protected by ci->lock */
+#ifdef CONFIG_XSWAP
+       unsigned long *xs_table;
+#endif

Testing (taken on qemu kvm guest with 8G memory):
=========
1. enable zswap and create/destroy xswap device
~# echo 0 > /sys/kernel/mm/xswap/create
-bash: echo: write error: Operation not supported
~# echo 1 > /sys/module/zswap/parameters/enabled
~# echo 0 > /sys/kernel/mm/xswap/create
~# swapon
NAME   TYPE  SIZE USED PRIO
xswap0 xswap 2.3G   0B   -1
~# echo 0 > /sys/kernel/mm/xswap/destroy
~# swapon

2. create xswap device and tune the zswap size

~# echo "50 10" > /sys/kernel/mm/xswap/create
~# echo 0 > /sys/kernel/mm/xswap/create
~# swapon
NAME   TYPE  SIZE USED PRIO
xswap0 xswap 3.9G   0B   10
xswap1 xswap 2.3G   0B   -1

~# cat /sys/kernel/debug/xswap/type0_cluster_limit
1990
~# cat /sys/kernel/debug/xswap/type1_cluster_limit
1194
~# echo 2048 > /sys/kernel/debug/xswap/type0_cluster_limit
~# echo 2048 > /sys/kernel/debug/xswap/type1_cluster_limit
~# swapon
NAME   TYPE  SIZE USED PRIO
xswap0 xswap   4G   0B   10
xswap1 xswap   4G   0B   -1

3. under heavy memory pressure tune swap size or destroy xswap device

~# stress-ng --vm 1 --vm-bytes 8G --vm-keep --timeout 120s &

~# echo 1024 > /sys/kernel/debug/xswap/type0_cluster_limit
~# swapon
NAME   TYPE  SIZE USED PRIO
xswap0 xswap   2G 2.6G   10
xswap1 xswap   4G 182M   -1
~# echo 1024 > /sys/kernel/debug/xswap/type1_cluster_limit
~# swapon
NAME   TYPE  SIZE   USED PRIO
xswap0 xswap   2G   1.4G   10
xswap1 xswap   2G 315.4M   -1

~# echo 0 > /sys/kernel/mm/xswap/destroy
~# swapon
NAME   TYPE  SIZE USED PRIO
xswap1 xswap   2G 1.1G   -1

I tried create/destroy and grow/shrink xswap device under heavy
memory pressure, all passed.

Changelog
=========
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


Baoquan He (15):
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
  mm, swap: allow setting xswap device priority at creation

Chris Li (1):
  mm: xswap support for zswap

 include/linux/swap.h |   12 +
 mm/Kconfig           |    9 +
 mm/page_io.c         |   16 +
 mm/swap_state.c      |    7 +
 mm/swapfile.c        | 1027 ++++++++++++++++++++++++++++++++++++++----
 mm/zswap.c           |    9 +-
 6 files changed, 993 insertions(+), 87 deletions(-)


base-commit: 169393fff5d1ec2690934067eeb95544ff5ebdd7
-- 
2.54.0


