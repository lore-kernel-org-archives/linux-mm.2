Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97AFFC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9D46B008C; Sun, 13 Sep 2026 03:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C436B0092; Sun, 13 Sep 2026 03:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7CE6B0093; Sun, 13 Sep 2026 03:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D24C6B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:50:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93BEC805DA
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:27 +0000 (UTC)
X-FDA: 85207966494.12.D20AFB9
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6537F20008
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=TX0OITl7P7V5AUxoPA8e9i41wKhvI8WTlmi8zwJG46k=;
	b=xMNWRojh8uXIDSNgCPLJnUA5374VKjiukPKOfqQla7IeNvty1J1G8Wq+u4qIikBN6hQn3w
	dolCVxb0hPYbxremJ66Nk9gSSBcvcguOiifEUYkemYuR1VxsfVBalB4XWBs2F6wgcw8H1/
	ExyZacXW+J/JH+cWAlzajL9ItnOZmME=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285826;
	b=X3B1oaVs04YfwGQtVzvNm1N5L6FJSo5iy+Fg8c25NWEGpFPrHR95CJehE+JJGbWuxXa0w1
	lJX5a2kG/QXZehGulDS41rWC7MA5WRiBL8wFHtL4TwIYbleXQwJE1OMQTErztUxxdXUn/6
	R/uSfgCJpYirQvm85FLUaRSUxKAT0Ts=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 2cded7e6ea0aa955;
	Sun, 13 Sep 2026 07:50:19 +0000
X-Mizu-Trace-ID: 2cded7e6ea0aa955
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
Subject: [PATCH v2 00/12] mm, swap: extendable swap devices (xswap)
Date: Sun, 13 Sep 2026 15:50:02 +0800
Message-ID: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6537F20008
X-Stat-Signature: yscrqg6wd4hio1z14whtt39cx48fqxt8
X-Rspam-User: 
X-HE-Tag: 1789285825-829245
X-HE-Meta: U2FsdGVkX18854dxJwV/oHSo1ohB2YGmxsMikQfmB0snoD6zXHCfBQuhzfC9pgF/NWL/Lqx5KXIUCIOrguHww8xHK31Cd7qOzDTzJkA8Zt7FS75e1ch+VJ82zZx24DMsGQFD4zxf7M7KmG7/S+nTqV5dL90QznbIv4nywdgHYX5+EP8VLMJX8g3dFCoJNRpLGpRaszyN0VGCKv1/PWpsXCOkbEh7AsVG0QKZbD+k/LF/xm/k+DuZV9nua5U1oqOLgINok1+m8kFe70w7IK8clKEIxkkQ0ThckkeRm4KTYtlS6tO26GUFIFNilpb3IjvFZzANsDAaGVxJTJVOrvwiQyCYipIhAhOO1w18Uyneluub0Q5CxXZLQtvyC+zPvB9nxRy80tEQnkoaHBdIwh/w6MfIer7Ec4LhQUHnHhukyLibDgi0WUlIt0ZrgkAz+3BCxlW6ZmbIFJXBGAgVJlPzG9gk1JpDkCx5lU3cQymSlZ8iBeTTMpDkU3KbVCRZ1N45DiCbzabJo30enpwgfP6HhfCajekMgN3y2BQBOjOqHZEcFDMw3viX8Zbgp8DblGT/nvVZvceUAHoK7eiOMxa+nQJH/0wvXzJIAVhhCozvuRkEg6xHEH2YPzB8w1t6gGhW5StTRfpNm/wiqmvEHjX2cOvfggAVVAi114faBcKNc6LNxnSJWWsPxpl6HE1/AVAyGbRXdOdsAWJZFn6Q5UtOsClR026z1DSfbo/y0eGQaGeeSmSI5cHFCEN9Y8A6b7Tfa1BR9ot2kDzBWVxh6jhB42UK7iJ+P11Tqf0hylwsJnj6FawLY5bpC8tfiffwmo7jjcqzCbWgnC7ZPjWszQ4BAyEvH1NzglNZx2jfx5V1d5TfdwUl8wB+lCSD9E7BDvQyOaCpWkmD3ZCpcKrDaiSTJVrqCAzmygXQYqWawUXNHHzOyzRA4lGft/cFtBOoclXWLNAAB3VUHxGSg6NdT9d
 94k5Y5kA
 cTN6/vJwqL0NzfRjgqiEw5DlM3uggF6/dWVAgQ3RN0aal9FFeANe6cj+WSXar+vD9Ag1FXVrUPl2IkI3xHO6LlW/zIHacwOrmvygcGH+QvXrDQVlbGnFRbYhvTGzxHlfnQ00OwvN7GXZfpeFXHlgr1I67X4zfRSEOOZ34y1INKv9rF3gkCsu9xridVTrsFT6exKBvAa+rgDwgdFeDuQhIhhl1Qfsc8EFBDti8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xswap is a swap device with no backing storage. Swap out pages live
in zswap. Its cluster_info[] array lives in a VM_SPARSE vmalloc area,
and the area is grown and shrunk on demand as swap usage changes.

The problem being solved is the static size of compressed swap. Both
zram and zswap need the size fixed in advance, and neither gives memory
back when the workload shrinks. The solution should be a device whose
size can scale up/down as per usage. Xswap does that by mapping the
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
- Shrink is driven by frees. The free tail is counted, and whole chunks
  are unmapped once the mapped range is at most half in use and several
  chunks can go. One chunk is left mapped as slack, so the next
  allocation does not map it straight back.

Size
----
A device starts at 1xRAM, rounded down to the cluster. That costs
nothing, because the mapping is lazy. An optional per-device cap,
/sys/kernel/mm/xswap/type<N>/limit, lets an admin lower the ceiling.
Grow and shrink both work without it.

Interface
---------
  /sys/kernel/mm/xswap/create           write an optional priority
  /sys/kernel/mm/xswap/destroy          write a swap type
  /sys/kernel/mm/xswap/type<N>/limit    read/write, in pages
The device shows up in /proc/swaps as xswap<N>.

Note:
--------------------------
Writeback, rmap lookup, etc. Those are consumers of this base. I have
a writeback prototype on top of this base and will post it as a reference.

Testing
-------
x86_64, 8 GiB VM, lockdep and PROVE_RCU on, 4 and 8 GiB MADV_PAGEOUT
workloads against a zswap-backed device:
- grow from 36 clusters up to the 3974-cluster limit, and stop there
- shrink on workload exit, then grow again
- fill the device to the limit and shrink again
- create, swapoff, destroy, recreate
Throughput is within ~2-3% of plain swap+zswap on a 64G/64-thread
swapout, so it is dominated by zswap compression, not the cluster table.

Changelog
=========
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

Baoquan He (11):
  mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
  mm, swap: refactor free_swap_cluster_info to take swap_info_struct
  mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
  mm, swap: add sysfs create interface for xswap
  mm, swap: add xswap grow trigger on cluster allocation
  mm, swap: add xswap_try_shrink and shrink trigger on cluster free
  mm, swap: free backing pages in xswap_unmap_clusters
  mm, swap: defer xswap shrink to workqueue to avoid lock recursion
  mm, swap: refactor swapoff + add xswap_destroy
  mm, swap: require zswap for xswap devices
  mm, swap: add sysfs per-device size limit for xswap

Chris Li (1):
  mm: xswap support for zswap

 include/linux/swap.h |   13 +
 mm/Kconfig           |    9 +
 mm/page_io.c         |   16 +
 mm/swap_state.c      |    7 +
 mm/swapfile.c        | 1170 ++++++++++++++++++++++++++++++++++++++----
 mm/zswap.c           |    7 +-
 6 files changed, 1118 insertions(+), 104 deletions(-)

-- 
2.54.0


