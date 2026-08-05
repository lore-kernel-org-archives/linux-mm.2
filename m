Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FEA8C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444FD6B009E; Wed,  5 Aug 2026 03:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F56C6B00A0; Wed,  5 Aug 2026 03:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C06F6B00A1; Wed,  5 Aug 2026 03:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EECE16B009E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:53:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7DD44803BA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:53:48 +0000 (UTC)
X-FDA: 85066451736.23.4E217DF
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 74A2E120002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:53:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wdUpa093;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BqaM4wUj92iZ1vDkhQERHfsRI3c7ZswGDLYTxXTXJnk=;
	b=JGg9fVhrEOtbLihB61LK/FrijqIKFJ7PjQH71FLtiqgTNaJsgjYz37J7tcvWBWSliI++ch
	W8FIY3c5J5AnYY3mKMcy9I+KPqkFIs49TZmYw73ZSx8zs0pbECo++vk4Q8QBzdoRMb/Y6w
	G4nA/+MOkY/QWcsuAv16QA4J3ylvYcg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wdUpa093;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916427;
	b=21KBpMvXwBJrFD02rQmVf4OhQ6XEaF70C9xqSbLBPHKNGQmFYMeEs6XUOHROQYC4BfQHrT
	FwVVNvCf85/JLmdVbcy5gV5NvP6ai/bbpRSHNJ0pVW4NdMtTpMoVttaHfz3GlBUa2RAtF1
	YPwjQQhfWEIvaE8ROFiqDRznyQwjJNI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BqaM4wUj92iZ1vDkhQERHfsRI3c7ZswGDLYTxXTXJnk=;
	b=wdUpa093o1tt1oKg4ckOQ5XXOsHiUtvrrN4JIXZG6soRac6VWqkN1xN90+qfKI0kid6agd
	fyZKYI5XDK8V4cIvqmyhcMvgTEoxVsvpNg/IpYeel/aIZKiSZYsuPNvwSHEa+hRW8SaZbd
	sylBcEe9/0sTmBw5ZJsyaBYwZVgs0e0=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
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
Subject: [RFC PATCH v2 00/10] mm, swap: dynamic cluster management for xswap devices
Date: Wed,  5 Aug 2026 15:53:23 +0800
Message-ID: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 74A2E120002
X-Stat-Signature: 1d3tbgcsy7u6dy6fxoyoqict8pi3xr5a
X-Rspam-User: 
X-HE-Tag: 1785916426-648181
X-HE-Meta: U2FsdGVkX1/oeR8xAf/3/s2kItsOtFgO3+eXRWjilIIcOTph+dhT0utgyFFM9mIKVJDFnyrNODnm0FZRtaRipH60oT7SE/YgJrv4YnjgsWpDDOcKlBU/vkb9cLlVao+hzz9iGBa1gRCWE9VHPy+fc0h8lZ9tQcNJxi1JEcB0OndK0NSF5T6/pAKvSlm0FtO0Kic/sYXaLkICEmBdTAmajN3waJ6Y7eTEnGBICqD/eAdU78u+9Sah/VonjCmuvnLF440cH2Mszp1HRrQfZAJutFm+8Dw1GwbI+twfZceKHQsf4X1EIYcIv2HPqdlmuzIbDUxoTStFi8WXeGpYcAXeRsAaSaFWkWcbW7JY2IbaWXKjr6WrIISWbd6RYSYhqfY/jiu6Uu6ek1CHPqnLbuUnqSOJ5fsWIQmTzHlCr2SWPbRroznAvB58+LQyFLcQaGq+xYBX6Mc5AYVKqObXO8lRuXFtEN8WJivY5IXk+ZBNAjFXXd7lDQyx+7I4Et5oy04COGxYYjZq/Ed0J3GwrnloG/x0+u1ICfeT6A/ZCD313Zajdcz2HPMjx1m7L3IT5pwVoj5P0lOg5/pcinI22C7m2V52N+XhqygdDdbrPfKvmmwpRVyPx2sRhE0PTWgCNdxLWV7l1z7wYphDmsGPqOwamXkOuIq3sw6a+C0/8D4JqnOiDubiJr6S+sFmE1v+z6jo0WwZbY1N0B7Lzy4y4q0Gi+X+Q7tKIL5w6WsLf1UDrMrXwz2k6LN8jPIyn91UVZxf8tpilIwfTU/rqvk9SH+QmvHDkLj2T0cx9rrJr2c8laXtyu9Ot65LRnJXzW99s7Qx+q7U8EvCUo5yiwpW6i2e0UgwVneLQzkCAHGm6T7764S1DjZNn8DHYuaoo4YNnVp2jwzMFGs9+uBO+6IZ6BIwrYAWP6LSiYhASoN5K+vjAXyTCEk8jhg3G6na/AubEGt5MmCr2tkgDCgrarMz9T4
 FJuUviIz
 K1zWh7378/pFJkv2LAIxoJcs+ChmJB8y0xPfhuytxaM0cUPBVM+fhWrAdFwhabp0r1OzgtfaERJBMszYgJaIXMsmAlVIiARNE7K/sgxKvTxQb1+e/4OyWLd+KloFKw3HmuDoGmXYcqqvqB/6GzzoA/EyA7/A8AbqWVZ6Hy5h4FHDcBKXMG1pdLsuzCSdLMk1pw9F1xxEeqWyBk+xsx3j7NrF9Lyd81QK5ke/Rte4HJghND+nehX+/JHV/+4htwYIfxnhyvPb/2FNz8FtVqHj0cfELcWPID8hCuVVQT0q7Hi8VuV0idQvBslHwL4c5XMYPMUHK
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
backend pointer, writeback, and rmap on top of it ??? without an extra
xarray lookup in the cluster access path.

A note on naming: Nhat's series uses "virtual swap" (VS), Chris
originally used "ghost swap", and now suggests "xswap" (extendable
swap).  This series uses "xswap" as a temporary convention; the final
name is open for discussion.

xswap decouple swap slots from physical backing storage.  Currently
zswap requires a backing swap device sized for the full virtual
capacity, even when writeback is never needed ??? wasting disk space on
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
nr_free_tail counter provides O(1) detection ??? it tracks how many
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
swapon, during stress-ng running shrink and grow xswap size
swapon, stress-ng, then poweroff when stress-ng finished
=====

Chnagelog
=========
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

Baoquan He (9):
  mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
  mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
  mm, swap: add xswap grow trigger on cluster allocation
  mm, swap: add xswap_try_shrink and shrink trigger on cluster free
  mm, swap: free backing pages in xswap_unmap_clusters
  mm, swap: add nr_free_tail for O(1) xswap shrink detection
  mm, swap: add adjustable runtime ceiling (nr_clusters) for xswap
  mm, swap: add debugfs knob for xswap per-device cluster limit
  mm, swap: defer xswap shrink to workqueue to avoid lock recursion

Chris Li (1):
  mm: xswap support for zswap

 include/linux/swap.h |  12 +
 mm/Kconfig           |   9 +
 mm/page_io.c         |  16 +
 mm/swap_state.c      |   7 +
 mm/swapfile.c        | 692 +++++++++++++++++++++++++++++++++++++++++--
 mm/zswap.c           |   9 +-
 6 files changed, 724 insertions(+), 21 deletions(-)

-- 
2.54.0


