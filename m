Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F06AC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C18C6B00EA; Mon, 27 Jul 2026 09:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5991A6B00EB; Mon, 27 Jul 2026 09:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D68C6B00EE; Mon, 27 Jul 2026 09:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA4B6B00EA
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:50:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC723806C6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:50:40 +0000 (UTC)
X-FDA: 85034691840.16.0650AE7
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf09.hostedemail.com (Postfix) with ESMTP id 79CD5140009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:50:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hJN+gDnG;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785160239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BGyK7+kni4WDqT8HPxpy+b9wtS9F9Uy+0Ux7JobaO0E=;
	b=HfMDN3+mhkhr5jd5XXR7y7XeamSKCXkA4O+VPx0tFQo7706ErqXHB78SUmM55T6AMv1UuD
	vP1zYM0domhWNCAvnViJNn0wxUp54LZNcJyxpbDgcSlKz++Oek08OvxZgDBatXPfJcsm90
	p+ob5GVaPYGuJLFW+2yGxgeUT4i5xNg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hJN+gDnG;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785160239;
	b=iwrgVok+3wNN/yx4QGbt10O2HNlbfiDdu/Ku1LDkQCDwhAZr7yIr7hceq4dJpsXYbmfyMl
	nieY6tWoIVLYsISVhM4raN/DLUK2ZbNe527qPooOU7fEPtVxlTS+6ysMTCWj19S7zm+0Iz
	i6LQR12iyCHn4Kul8dC0BB0VQelxrkw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785160236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BGyK7+kni4WDqT8HPxpy+b9wtS9F9Uy+0Ux7JobaO0E=;
	b=hJN+gDnGWewd8FsTyxLP4GzfWLXlWOQ1NwTUXSYh0KUrI9kyOT3Jf9Dfv41TGAB1FEz4bQ
	J78WQ8PfLzJPerzXXsjCBpnwC0ghpoF+fkroNrPgrneH4gxKQkTh+3tmOi0Y1Wcad4Koab
	4hIVNbj1660ogWP5AvrenHRomPg7zmM=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	david@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 00/11] mm, swap: dynamic cluster management for xswap devices
Date: Mon, 27 Jul 2026 21:50:11 +0800
Message-ID: <20260727135029.1059441-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 79CD5140009
X-Rspam-User: 
X-Stat-Signature: zpfhnpx6scmeewchcre5njz86qgcsops
X-Rspamd-Server: rspam04
X-HE-Tag: 1785160238-408896
X-HE-Meta: U2FsdGVkX18zMp/fRmFN3PkUmWht0ZH6Ys6FIBnCOastBesIrRo2zePqvTe5BiBLJoKX66sg5MpE77H4JQxG4KYGfvfbhaxcrfpUzlQGjHJCgMSZBTpDt2OEmlcJZy3HQBrJNDpOd8OUf46Hp2A5DLm+ayANsnqCu7GxHyY93fodLPC5Wwf6sVqxZ0OHIwc/8owNzFYhedif3W+zU9ToqW95SkxOav+5ZMO+n0dWVvtyaMU20+swCaCNVLWqhxXns7/kvRJXFGtJmGQvu7YpLx2lqRCZBpCh3XhJhEZkzHToUdsnGjQJLTCmmEgpeVNMJKvWbny4Zr4eLnRm94H9HjYky3EVcOuZhd38L8wbfhenQArPBXuWLNfESBjngfqAB9+bowuO0iBCootc6pd+RIX72T6jEsNRnYtHJ7+tGqwW17Xp4aWYTp2U/PcMzymr4nOpJBuiBWE0lCfSxbu10lzxkznKoV1RcI+ohflUH0+SOXDDpXg4tFHwzrep32J44cDEnLCeUOtBk0QIGzTtUFkMW08ZRmR1KeNcEuXRJPIlQh/Pvifbo3CsGSrxgWU9nESnFRpzgdOxbXFbFPX2M7+zizKncRtOXQK1JOtxaz+kUnIXN7dD468bgQQAsj0Z4FcssEScoWiuN4a7HQwHCvA5k20xhYiYQUgWXvPTeNQls/VksOu1F7uJlXpR9F7YiG3nkUSb9IIY1/MUlTnBpNhrEyH6LpQ2/Fc15rgBr6REmRRsmIdX2I56p01za6i9xqkk4zzmGNY/VMEyCktf+4OhM58IeycKDJh5cl+raVKppcnVC/qlKB9HiJ152uLMzktGA9a27JcUYQb0w0zfRYO/KHs7oEQ0UzRew+AvWJmWNGoUsrSLLfMl8ce1uQJTe4OZ8z+Riadtk54U46SPCL1UcoYcBi/Vs7yvMe5xbwiTgY4ojY2LwjLmT6JbUnifwuL3gqxv/QEcDJ5R7n8
 7iPbCv9k
 7QSFiGZc1Dco7EEngUBQczi6/idbO7OPzMJjXNDjZxBSXPI/d5wT9au0el3W6UuMo+qk21NRDfkLy2FJiGLx2nnHM6+YdcR6gCP60MvGuZibNtxOWRHjhMj70/PzHRCCfsM10QJa6EJsh4422p/HA9xuFGYaJw0//GUyCzJvcovlaIziNLwB5ZmbIbfiPwQcvHc8RKWhizXXCPT72Fl3eLR8EXnBFYZTfr8AGatv/9GqKaVW6tsh+HhkMqLIplkFT2gtAKuloltKT0NITwSsI3OTMj3mO5GHO5uU9shns8jRmyWDfHmh+ecoCtm1jYpsOImpvAhLffU4r2psGtRpuiSLbCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series implements step 3 of the incremental path proposed in [1]:
a virtual swap device with dynamic cluster growth and shrink, backed
only by zswap, no writeback yet.

During the discussion in [2], Chris and Nhat debated xarray-based vs
array-based cluster lookup for virtual swap.  Chris argued for keeping
the swap table and cluster_info in the same place with O(1) array
indexing, and suggested that the kvmalloc grow approach here should
provide the cluster management VS needs.  He further proposed using
the same grow technique for the future per-slot backend pointer array
(vs_table), keeping a single coherent array layout throughout.

This series therefore serves as the foundation: once the dynamic
cluster management lands, Nhat's VS series can build the per-slot
backend pointer, writeback, and rmap on top of it — without an extra
xarray lookup in the cluster access path.

A note on naming: Nhat's series uses "virtual swap" (VS), Chris
originally used "ghost swap", and now suggests "xswap" (extendable
swap).  This series uses "xswap" as a temporary convention; the final
name is open for discussion.

xswap decouple swap slots from physical backing storage.  Currently
zswap requires a backing swap device sized for the full virtual
capacity, even when writeback is never needed — wasting disk space on
slots that zswap will never use. An xswap device is a swapfile: a 4K
on-disk header advertises the capacity, but there is no swap data
section.  This eliminates the wasted backing storage.

This series replaces the fixed allocation with a VM_SPARSE vmalloc
area that grows on demand and shrinks when clusters are freed, within
the bounds set at swapon.  The cluster_info pages are mapped lazily
via vm_area_map_pages() and unmapped in bulk when contiguous free
clusters accumulate at the tail.  Lookup is O(1) via simple array
indexing, which matters on the swapout hot path.  The trade-off is
coarser shrink granularity (full pages, not individual clusters), but
for the initial landing where swap usage tends to be ratchet-like,
this is a reasonable choice.

[1] https://lore.kernel.org/all/al8ohWshSSZ64AtT@MiWiFi-R3L-srv/
[2] https://lore.kernel.org/all/CACePvbVJGVDbhvPRNsZx-f4t16TU-t6H754JOUQQ4uF2Xe6Q5w@mail.gmail.com/

Design
======

The cluster_info[] array lives in a VM_SPARSE vm_struct.  Physical
pages are allocated and mapped into it in chunks of XSWAP_GROW_CLUSTERS
(256, configurable).  When the allocator runs out of free clusters and
the mapped range hasn't reached the ceiling, the grow path maps more
pages.  Symmetrically, when clusters are freed, a shrink path unmap
pages from the tail if enough contiguous free clusters accumulate.

To avoid scanning cluster_info[] on every shrink opportunity, a
nr_free_tail counter provides O(1) detection — it tracks how many
clusters at the tail are free.  Shrink fires when the counter reaches
the threshold.

A per-device runtime ceiling (nr_clusters) allows userspace to cap
the mapped range below the hard limit, and a debugfs knob exposes it
for live tuning without swapoff/swapon.

Testing
======
1. Create xswap swapfile
touch swap.4G
truncate -s 4G swap.4G
mkswap swap.4G
dd if=swap.4G of=ghost.4G bs=4096 count=1

2. swapon
swapon ghost.4G

3. memory pressure testing
echo 1 > /sys/module/zswap/parameters/enabled
stress-ng --vm 1 --vm-bytes 4G --vm-keep --timeout 120s

4. shrink and grow memory via debugfs knob

root@fedora:~# cat /sys/kernel/debug/xswap/type0_cluster_limit 
4096
root@fedora:~# echo 2048 > /sys/kernel/debug/xswap/type0_cluster_limit
root@fedora:~# cat /sys/kernel/debug/xswap/type0_cluster_limit 
2048

I did test cases and all passed:
swapon, swapoff
swapon, during stress-ng shrink and grow xswap size
swapon, stress-ng, then poweroff when stress-ng finished
=====

Baoquan He (10):
  mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
  mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
  mm, swap: add xswap grow trigger on cluster allocation
  mm, swap: add xswap_try_shrink and shrink trigger on cluster free
  mm, swap: free backing pages in xswap_unmap_clusters
  mm, swap: add nr_free_tail for O(1) xswap shrink detection
  mm, swap: add adjustable runtime ceiling (nr_clusters) for xswap
  mm, swap: add debugfs knob for xswap per-device cluster limit
  mm, swap: defer xswap shrink to workqueue to avoid lock recursion
  mm, swap: serialize xswap map/unmap with a mutex

Chris Li (1):
  mm: xswap support for zswap

 include/linux/swap.h |  12 +
 mm/Kconfig           |   9 +
 mm/page_io.c         |  16 +
 mm/swap_state.c      |   7 +
 mm/swapfile.c        | 677 +++++++++++++++++++++++++++++++++++++++++--
 mm/zswap.c           |   9 +-
 6 files changed, 709 insertions(+), 21 deletions(-)

-- 
2.54.0


