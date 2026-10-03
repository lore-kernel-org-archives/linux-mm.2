Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E8BCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C6E6B008C; Fri,  2 Oct 2026 20:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD2D6B0092; Fri,  2 Oct 2026 20:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312E96B0093; Fri,  2 Oct 2026 20:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 092B26B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:59:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F8941607DA
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:14 +0000 (UTC)
X-FDA: 85279506228.26.10431BF
Received: from mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8EAD9A0004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=YoA91wKeJ+a+rYY2+H8k6QS/TUpiZEOnjdZPmpbgz08=;
	b=X9upjcJW3q6fwo4aBnuEfauDb3AH8kj0slzH0RVw76xOf/ssc6aR5ZSKNCQOq1PBkhj79Z
	U6Y7DKkZCXG/cM5Zm6H6gcQxzwrMUebfDBA5UYUHW2IF/4DxvKfKdvM3T9mofqa9sVQOy2
	46wAk/0TXks+/1+/vOpeF0iGrr+pejE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989153;
	b=ELgzVoFsa5WYWKO/n3XCHo2+sEeUa2G0gWCN4+MZcPHVfDYtYPpUkPfRit30o9aX+leFmS
	v5AC0LEUswrt2n8TMJAJx7y6fdQuF8TvjWNnujcSjYyk/mC+mzHVWzS8P730hpcXIR7k0P
	gwuIsC/Om2OTNndU2FyLSOTTAEdDIaQ=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 37893696af6de25d;
	Sat, 03 Oct 2026 00:59:11 +0000
X-Mizu-Trace-ID: 37893696af6de25d
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 00/12] mm, swap: give xswap a physical backend (xswap phase II)
Date: Sat,  3 Oct 2026 08:58:48 +0800
Message-ID: <20261003005900.909710-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EAD9A0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: afh5jim5q9jqcnzibuhxdh46pm1t4x1e
X-HE-Tag: 1790989152-126306
X-HE-Meta: U2FsdGVkX1+heCQwx5zlK6atjO9bUkFlmpfwmh3pQ30UchBaKfGQmzQAJqUuARiwfVe4WWxdFF9EP96sWsUFOf+2skJmxaj1Kcr6NNfpUDW9+EkvMxc5H5jiA3aAX+BcVmBrVqDVCS/7Rvqn9smuzZMphIZM402er0hVNH8akzuXPBX5BmJFxuEiRWD9hPzbDg6B3j0RERIh0CSSoWjOxdW3a6fsYewAuKqzA1DPZHNVbsO53J4wiYfUh9HBQIEbDXAWHac61/PDlyKNbhIziD8CAvqalVAtyL5Wj6F1pe9+zrCUdvsXvizte/Qr0hmnfAWryb8OAeRshMAzelp6dCQrfqoNYqOR1Kk5Mn6NHh9IrA+aT4L9pOhBm6ppEBIWqazLuNHMbzAf1bt5Boz2w6P8EkxQbDwDnSKeRDFsxiNUGVExeNI+6YJbHxhMc6Fk2AoN2lC+OOGsyxyWn66yjLNAWpH9AmcRHF1z43C+dzBEhPZO6XBZ1j7OYCSOW3DEAqdsjqwESVDNrcrY7bSlXqcGoDm3LxjJzKDK1r/fq9RYcHIxDP9p7d5+NBQkyipEemsX+4VPO2M8owNbeyO3I8hEib3B9QMyi9QBaLt+hJ5SY3wouQIvkjQwh0veeniWxAMaydSq5HGBt9sbejctUt5Sl+mk5qnuA962ZNF1PENlpeLsw3U0VTGBxdoDyPJTOp/X7qy5QIKZW49F0WqsxF7ndf0+nvMArqZ9FXpXUW9c4labZnY8BTGgwr6CyX4GxwSEI+7FDHTVnlPw1nqQhm1wlML/I7o9P5PKB6RI6Vji5tNW5hh/H/XcoktHL48AbQg3o637zU1yylT7NukSA65GXH/OQaSyBFJR+OmhPkouYNVbGG/965KRGIP6sOgKp3OzPTvCMgAQeGRctdUXnR8plQ7GJ4Awy/v1KMdq0i7JnRDH7JninAnbHT9eNGENN9o/XkffipN24U2cD4w
 zRkakznI
 kd6j2p6Sw2vhn1ioa/nVZYhBF/fY0w920MuowhDb39zPqlkD1iiPLmzdkd1IBxb+PaPDTX6/KCwpzEV/zcMhlhEBDz9csxFf/fbii+xQpNp8vJAboXW3zley6/fBtCUo3vM3rkZckP/Mv4l7Beaa5p6ZZ5WyOimEPjAIBc6afwPRqfGUraaaonLtZgSRkobKUlZsuh5PxJ9Cr4AWY83nTycXC3O+yPnoQBHtc/Qprs+n6QVYKUzhJxaJGB1lggJ+HfA433luV49AlsoIIl13VH4jkfJbOXY9bTPQdNPPDe4IQ0C0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap entry holds a page in zswap. That works until zswap will not
take the page. Then the page has nowhere to go. 

This series gives an xswap entry a second home. When zswap refuses a page,
the entry takes a slot on a real swap device and the data is written
there. The xswap entry does not change when the data moves. It is what the
process's PTE names, and the physical slot is recorded behind it.

Phase II of three. Phase I is the device itself, 14 patches.

Design notes
------------

An xswap slot and a physical slot are different things with different
owners, and the physical side has to find its xswap entry again. A swap
table entry already carries its type in the low three bits, and 0b100 was
unused. It now points at the owner, with the xswap type and offset above.
The places that hand out or cache a swap table entry learn to skip a
pointer entry.

folio->swap no longer says where the IO goes: a folio whose data is on the
backend still sits in the swap cache of its own xswap entry. So the
batched IO path carries the entry explicitly, instead of deriving the
device and sector from folio->swap. A large folio is read back with one
IO starting at its first slot, so its slots have to be contiguous; the
reserved-run allocation provides that.

An xswap entry's swap count can reach zero while its folio is still in
the swap cache. A page faulted back in during its write to the backend
ends up there: do_swap_page() does not wait for writeback, folio_free_swap()
refuses a folio under writeback, and a write to a real device does not drop
the cache when it completes. The physical slot is then redundant, but still
held. A single bit in the slot's swap table entry marks this, and the
physical reclaim scanner frees it. The scanner reads the bit directly;
taking the xswap cluster lock would invert the lock order.

An xswap entry that is still in zswap costs no swap space, so it is not
charged. Charging is phase III. Here the entry is only recorded.

Testing
-------

qemu KVM guest, 8G RAM. memhog is a small local helper: it faults
<total_gb> of anon, fills it with a fixed pattern, and holds it.

A 4G swap disk /dev/vdb is the backend. The xswap device has to exist
before zswap is turned off, because creating one requires zswap. The
number written to create is the device's swap priority; 100 puts it above
the backend at 0.

  # echo 1 > /sys/module/zswap/parameters/enabled
  # echo 100 > /sys/kernel/mm/xswap/create
  # mkswap /dev/vdb && swapon -p 0 /dev/vdb
  # echo 0 > /sys/module/zswap/parameters/enabled
  # mkdir -p /sys/fs/cgroup/xswap_limit
  # echo 4G > /sys/fs/cgroup/xswap_limit/memory.max
  # echo max > /sys/fs/cgroup/xswap_limit/memory.swap.max
  # ( echo $BASHPID > /sys/fs/cgroup/xswap_limit/cgroup.procs
  #   exec env MEMHOG_FILL=pattern numactl --cpunodebind=0 --membind=0 \
  #       ./memhog 5 600 ) &

The pages reach the backend, and the xswap side accounts for them:

  # awk 'NR == 1 || $1 ~ /xswap|vdb/' /proc/swaps
  Filename                Type        Size      Used      Priority
  xswap0                  xswap       8155132   2392176   100
  /dev/vdb                partition   4194300   2392176   0

The two Used values are equal. An xswap slot and its backend slot each
hold one reference to the same page while it is swapped out. It is one
page of data, not two, and the backend slot is given back when the xswap
entry goes.

With the workload still alive, destroying the device returns every
backend slot:

  # echo 0 > /sys/kernel/mm/xswap/destroy
  # sleep 5; awk 'NR == 1 || $1 ~ /vdb/' /proc/swaps
  Filename                Type        Size      Used      Priority
  /dev/vdb                partition   4194300   0         0

Also tested these, and nothing crashed or warned:

  - ten create/fill/destroy cycles, each returning /dev/vdb to 0
  - a shrink racing a swapoff of the same device, 20 rounds
  - a swapoff of a device that has pages on the backend
  - THP swapin: a large folio read back as one IO, and byte for byte
    what was written

Changelog
=========
RFC -> v1:

- Charging is phase III, so its six patches are out. An entry is
  recorded here and not charged, and the RFC's two charge tests go with
  them.

- New patch 12: skip a NOFS backend when reclaim cannot enter the fs.
  may_enter_fs() sees the xswap device, not the backend.

- Cache-only reclaim marks the slot with SWP_RMAP_CACHE_ONLY instead of
  handing it to __try_to_reclaim_swap().

- A large folio is only written to a block device backend, and the
  backend is recorded before the reverse mapping that finds it.

- An xswap entry goes back on the zswap writeback LRU.

- swapoff reads an entry back under memalloc_noreclaim_save() and
  xswap_lock.

- Patches 1 to 11 keep their subjects and order, rebased onto the new
  phase I, with rewritten commit messages.

Baoquan He (11):
  mm, swap: tag a swap table entry with its owning xswap entry
  mm, swap: prepare the folio-less allocation path for xswap
  mm, swap: add a physical backend for xswap slots
  mm, swap: use the xswap physical backend
  mm, swap: fall back to disk when zswap refuses an xswap page
  mm, swap: support swapoff of an xswap physical backend
  mm, swap: reclaim physical slots backing cache-only xswap entries
  mm, swap: back a large xswap folio with a contiguous physical run
  mm, swap: enable THP swapin for xswap entries
  mm, swap: drop swap_folio_sector()
  mm, swap: skip a NOFS backend when reclaim cannot enter the fs

Nhat Pham (1):
  mm, swap: prepare the swap IO path for xswap backends

 include/linux/swap.h     |   2 +-
 include/linux/swap_ops.h |  10 +-
 include/linux/zswap.h    |   4 +-
 mm/memory.c              |   7 +-
 mm/page_io.c             | 102 +++--
 mm/swap.h                |  37 +-
 mm/swap_state.c          |  12 +-
 mm/swap_table.h          |  92 ++++-
 mm/swapfile.c            | 783 ++++++++++++++++++++++++++++++++++++---
 mm/vmscan.c              |   4 +-
 mm/zswap.c               |  61 ++-
 11 files changed, 989 insertions(+), 125 deletions(-)


base-commit: 128a882559e489eea535bf31b7293058708d351b
-- 
2.54.0


