Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4508FC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130EB6B00A1; Tue,  7 Jul 2026 04:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3346B00A2; Tue,  7 Jul 2026 04:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F181E6B00A3; Tue,  7 Jul 2026 04:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C331A6B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:26:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 543058D580
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:26:26 +0000 (UTC)
X-FDA: 84961298772.13.D82F463
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C32720005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:26:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qb2NMapP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=47HDgQybI+3t5P+eb3AQpo+jGwETFx3wSiNf2a7otpQ=;
	b=MvBHw6PNcGNNd2YveB+kvtlrwobmZTldR/FFO06Yhw0CN9kGcQra7co2mGEF6pdsRs1LdR
	Tp4W4+jZ/EEI45OYbJJ9p71+sN9xzsK9wx72qoNNVMhi393Rwzt6Tuk+V8YJ8XKc9gVSTQ
	004M0UPNF+J6C6v8mdiQ1vBeV2z7ZEs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qb2NMapP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412784;
	b=PUQ2rpRwr56Y0JhsfvMuZqR2T7YDbyLeBZqdTs+TGZhhKX+IfqAZ040pGihG+MsjHtDHQ6
	+rs6+CoxokVuwvg1mfkQ1ri23Vs84uKB8E7ctCHaEvXwkBPj/Bs7s+bwXYrxXCbFQftF/V
	tOlOXfF793ujtU1RmcelvagtmnPQ91g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=47HDgQybI+3t5P+eb3AQpo+jGwETFx3wSiNf2a7otpQ=;
	b=Qb2NMapPhOb2KOQ3rJlfqhuKlRoAbITD0I7wmfCox+Ny8QM6YwO6fsZcZz5Ct6QotTK50F
	hLXs0XGQnMbmjXKZdScN+ruY4MFHetQ8nIblM22UXvcvMnaxN+QPsUUkkqIy0v2TD5rAPI
	KM28kDxW6Xl/EtggVHp1zkFD5DCSvbY=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching via Redirect entries
Date: Tue,  7 Jul 2026 16:26:02 +0800
Message-ID: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6n1hgxsngaoqzypszksio58okpw8jqcu
X-Rspamd-Queue-Id: 7C32720005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783412784-64063
X-HE-Meta: U2FsdGVkX19KischSLQjPvRjN+PwyETBvWMo4KazBpFflVGTFshX3n2eae4JaCNOwoo/qeUnLznadAWJE1PVSfhAzPJ03wW20NtoHDTUCkNtCVhUd9QKbKr0nz+HmHF4zipuOoepKF17Ejx0bktLe4x8+9NyLG9GTlg3DvaOxXV/VOPO/9DeyK4cR4qAFuTobqB4foqWAPCk22VRbgrgjf2jRg/8AO08dITEwteGeYNZZ2puxMqGlXIApR75ZWpD19lwfN4xgqDDhAo8tSlNpB1xrMXqRcEea+eQZLjbm4bG/4xB9ruwslaoT3FgWpUsNft0QhHX+jhrOjdBlF2+BExU59qo0Cs1nYY+r1wgf2FpUhiWFosMJuCqEv1s862xuWMDg1MsHyb2e6mVCR2EA/gjrNXxKAp7CvXN1ByWEThvHpjt7r87Yl+ZDXWmdENUg1Rpbb8qeDmUMqi6LwNQQgCF86TEYlpiKhNxMH4nsjQqDxzUbq+5du4xy65PRpnjRvZGG4QSydQMBjCrupBsimRZg9UM/aePH0xyvJBJ2jBiiGcJulxAS/G92Uyt1cW/C+tZQc9UsUNlTnQU4rOd0rwPaYn5tI8yzKlKT0DSonbnpBSZgyaFQIiBuPOlTMkO9YoMmSHHSVy2hs2NvKeDJ4TSZuh4kAryexFB8rsbOC77tYthGpGYISsNNXE0KoCSjSUvdkra9comNXzaM8UDSMjGx5TLVuBtUULN7Mj+eptVasWteojGWdtYBFqdf8YAfio3JonCoEMV7ZntE7pAoU1PklXZRX8N1NcSd0zrZewfEqLAbWkn4BacnIQ4KXZ/93rYYXq10uSbLfqHSB76cowBHzgG7He2I/IHEoh1ibgbB+Y/0eNUOTzgX3vRHkCf2pXych939BK1wubn/ITvhcF+cg8LauA1qcJ3EcCVug4+rolPtPvBDhJLjVV3qoyprjRGy+qBdh8Q+vqF4rg
 2zRASJBN
 GE8U7uJhsm3Lo5B7pbirC3D2kWzLb7U5fgqqwUhaeb0/V7UiUMEJY6h6nAq8C2tvlv8/wFDaMhEmDWrziWy+hd0Aw5y+HYQ/A/o/NJQ+WwhZiBPxAbY8l0J29bdIod4enxwePXZOusmagzAFdM9DvwPWMQBsDc+2TjOM4JpoQhG6RwLw16ga+Mx/3P4L6mRwkoXLz0vxJj2c02BE6P6N1MqlidWJQ+Su4/7HtAHtDkv3ZZYI9fgU6x0waPznpCni0wkfb/YhdkegE1lzq0kp2f6fLbWxdAUlb6Q1hwzrg6UafpG4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces a virtual "ghost" swapfile that can be backed
by multiple physical swap devices, switching between them at runtime
using a new "Redirect" swap table entry type.

Motivation
----------
Physical swap devices have fixed, large sizes but a machine may only
need a fraction at any given time.  Ghost swap decouples the logical
swap capacity from physical swap allocation: it presents a large
virtual swap device to userspace while lazily mapping slots to
physical devices only when data must leave zswap (writeback).  This
enables overcommit of swap capacity without wasting physical disk
space, and allows the ghost device to grow dynamically at runtime.

Ghost swapfile characteristics
--------------------------------
Ghost swap decouples logical swap capacity from physical swap allocation.
Key properties:

- No backing store required.  A ghost swap device can operate purely
  as a zswap container — compressed pages stay in the zswap pool without
  ever touching a physical swap device.  No physical swap device needs
  to be attached.

- Optional physical backing.  One or more physical swap devices can be
  swapon'd alongside the ghost device, acting as writeback targets when
  the zswap pool needs to evict cold pages.  The Redirect entry in the
  ghost swap table links each evicted slot to its physical destination.

- Dynamic size growth.  The ghost device can be extended at runtime via
  sysfs, up to a current maximum of 1TB.  This is implemented through
  lazy vmalloc: a sparse 64MB virtual address space is reserved at
  swapon time to cover the full 1TB range, but physical pages for
  cluster_info[] structures are allocated only on demand as the device
  grows.  The cluster_info pointer never changes, so all existing
  accessors (__swap_offset_to_cluster, cluster_index) work unchanged.

- sysfs control.  Each ghost device exposes attributes under
  /sys/kernel/mm/ghost_swap/ghost_<N>/:
    path (RO) — backing device name
    max  (RW) — current max pages; writing a larger value triggers
                swap_ghost_extend_max()

Design overview
---------------
A swap table slot can now hold a Redirect entry:

  Redirect: |----- physical swp_entry_t -----|101|

This stores a plain swp_entry_t pointing to a slot on a real (physical)
swap device.  The low 3-bit mark (0b101) distinguishes it from Pointer
(0b100), PFN (0b10), Shadow (0b1), and NULL (0) entries.

The lifecycle is:

1. swapon a ghost device — reserves sparse vmalloc area (64MB virtual)
   and physically backs only the initial range.  The device starts with
   no physical backing store: pages swapped out go to zswap, and zswap
   pool evictions go to any concurrently attached physical device.

2. zswap writeback from ghost: when the zswap pool needs to evict,
   zswap_writeback_ghost() allocates a physical slot from any real
   swap device, writes the data there, and plants a Redirect entry
   in the ghost's swap table pointing to the physical slot.

3. Swap-in from ghost: swap_read_folio() detects the ghost device
   (SWP_GHOST), resolves the Redirect to the physical swp_entry_t,
   and forwards the read I/O to the physical device.

4. When the swap cache folio is removed, the Redirect entry is restored
   from an xarray (redirect_xa) that persists the mapping, so
   subsequent reads still find the physical backing.

5. When the physical slot is freed, the ghost slot is also freed,
   cascading through swap_range_free().

Note:
------
Ghost swapfile is a proof of concept. Compared with the other patchset:
[RFC PATCH v2 0/7] mm, swap:  Virtual Swap Space (Swap Table Edition),
it explores a different approach to implementing virtual swap on top of
the existing swap table infrastructure, with a simpler implementation.
It builds on Chris Li's earlier ghost swapfile work and is currently
tentatively named "ghost swapfile" — alternative naming suggestions are
welcome. Ghost swapfile setup can also be integrated through modifications
to the swapon API and the swapon command in util-linux, for example:
swapon --ghost ghost_1:2G -p 5.

Baoquan He (9):
  mm/swap_table: add Redirect entry encoding for ghost swap backend
    switching
  mm/swap: add redirect_xa field and ghost redirect helper declarations
  mm/swapfile: implement ghost redirect helpers and free-path cascade
  mm/swap_state: restore Redirect entry when swap cache folio is removed
  mm/zswap: implement ghost-to-physical writeback for backend switching
  mm/page_io: forward ghost swap reads to physical device via Redirect
  mm/swapfile: manage ghost cluster_info via lazy vmalloc
  mm/swapfile: implement swap_ghost_extend_max() for dynamic growth
  mm/swapfile: add sysfs interface for ghost swap extension

Chris Li (1):
  mm: ghost swapfile support for zswap

 include/linux/swap.h |  10 +
 mm/page_io.c         |  51 +++-
 mm/swap.h            |  16 +-
 mm/swap_state.c      |  28 +++
 mm/swap_table.h      |  38 +++
 mm/swapfile.c        | 579 ++++++++++++++++++++++++++++++++++++++++---
 mm/zswap.c           |  98 +++++++-
 7 files changed, 772 insertions(+), 48 deletions(-)

-- 
2.54.0


