Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCF7C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 476006B00A9; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426776B00AB; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362686B00AC; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBEB6B00AB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9547C801AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:06:43 +0000 (UTC)
X-FDA: 85071776286.04.0FB310B
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf06.hostedemail.com (Postfix) with ESMTP id BE504180005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:06:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786043202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=4Gg888KklwgFCXzAZIIH4w7PVgPxXmF7ajrQyyBhWDc=;
	b=6i0LFIkyWq330Xaj4eCbdwU7tFu5LJJQYD0MaoiGYPm0PmFKeNrMQ0BlIljj6eK1vRqhuK
	4s9rm/QNmPhrANIDF8ahPfafs4U9iFtpYUD3WanNxxXccmJqeDgg1WqshuhNTqm1fZml8m
	NNNKfJKFjQucC2zyHH3SqJqHNup46I4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786043202;
	b=I0FmOHaXIqL3E6L2i7gAAJhXidFFso+Vl7AdW+6IwJa13s70OjiF45n95fPv/W2I4PEpJR
	YKbPxMYmUqX3mJx/mvOSFDzeU8+3DKKfAYj1VTXgiX8mx5QHA/Se4mTliOPfjDg81JLKSp
	zn5oZHgn9OSpCPW406016liZ0r9k02U=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 7 Aug 2026 04:06:36 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Jianyue Wu <wujianyue000@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mm, swap: keep hibernation swap slots out of the swap cache
Date: Fri,  7 Aug 2026 04:06:32 +0900
Message-Id: <20260806190636.446205-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE504180005
X-Stat-Signature: if8ksc1a6s3khnb6117zk8gmfh8zhrp6
X-HE-Tag: 1786043200-104312
X-HE-Meta: U2FsdGVkX19A+4VmJ7pu5Xd1M97fc1LCmtE6NOSDMKUSqCLo4nS/kraCxTW27RbRptY7KvMZWD0cCbQXElwEVwlGwedmTSbwTRGBmFSEtQvBAgC/8w6gu6finxWfHq+Uxv9UpMIPiwO5X7fgoItL0lIifWtZkP9EYC44W8IJg8yvPo4Axi2H4GFwbOr7ncqFl9s1yS2qPAkLeLzuTP7E5qyEYE+xDBD2BNATIVgKQzl0guhl75YJOSvFRJuOKSQ0eOIwnmAwFIAz96dCYLycSjidKLxD05lFJA7eATQfptzWlZF+9XYXlPF6btsAJpBJOt9Eq+NAXp5oqINwVSSJlpPWnWmRXotF8Yc0HpHMhT6fcLr8P00LE0Q5rsgO8thnGXP45zNtufDw0eZUMqESH8QROwZBqgvVrCKYrv99AoGae+p7PZDOpj/hC4p2qlPiuDeCC4tLeEpwhRP8lh22LGVE1mOvX7GK1fg5Yjy9Qs2huER/mu8SdeIzTIJbx+VhIT2DOgH/ES+k7GMHXzEgTT/QgbaZX/34ibr25DRyOkTzFfjjznJCZKrwo5xZ2V9C4UB2Lm5OUyCWbbpNelld4LGqanoO33BRdVM5yqxcJy+EHZDv9xemgtPxhNkOq5bEXtgVksPJAOOC9lmk0Qa6Ghv2nH9eEzGkngBtYIstmxM9Bwm2O9/x5dhrZqEhivxtg03FoMyJOlx5s1ZLVc8yhd9PFIB+a+eB7H+b8j7OllmIhU+ucn4XVDeqtG/MZYpTdr6rIA3s5IXIKQOi4rJL6tmCdbO0Pynlols2K3mUimcZ6aGahpG8XV3Adw/QnY1PxuB5CP0wCaM9R2+rdtP7VL/gLiGsC/amXKAFS/tsf6aTLE/J0V4gK/rEL6M/1HBAstIcRFQqLiQOJw0Hhbo7MFel98RPnAXarJbMTcjBtWodJ2DjFHqj3USzZAR7E+JNZJM0MJmi2FxyUrMestV
 EyJg6Vi8
 AuEhKXsE3JFP2UfHyNH7FUyhDoSqcfQo3gzXjCITOOVMKfC7te9jvd6b8OGTyziUEilOxh8pFkCaP9Ys4xsD8r/xwc/xCx3D7VrdbCl2ftQ4NvW5IXrnVv+25kTotKuwRD6xMIKqVabMOs8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cluster readahead walks a raw page_cluster sized window of offsets around
the faulting entry.  A hibernation slot looks like an ordinary swapped out
slot, so __swap_cache_add_check() lets it in.  Readahead reads the offset
off the device into a folio and puts that folio in the swap table where the
hibernation entry was.  This has been possible for a long time.  It only
wasted a folio and a read.

That changed with commit 0d6af9bcf383 ("mm, swap: use the swap table to
track the swap count").  A slot with a folio in the swap cache should only
be freed when the folio leaves the cache.  swap_put_entries_cluster() still
does that, but the conversion left swap_free_hibernation_slot() freeing the
slot either way.  Nothing points at the folio after that, and when reclaim
drops it later, it writes to the table entry at the old offset, which
someone else may own by then.

Patch 1 is the fix.  It puts the missing check back, so both free paths
behave the same again.

The rest removes the cause.  Readahead should not touch these slots at all,
so patch 2 gives hibernation slots their own swap table entry type, patch 3
lets only swapped out slots into the swap cache, and patch 4 drops the
check and the reclaim, since no such folio can exist any more.

For any of this a task has to hold hibernation slots while the system is
still running.  The in kernel path does not, it allocates, writes and frees
the slots with everything frozen.  Userspace hibernation is different.  The
process writing the image is not frozen, and SNAPSHOT_ALLOC_SWAP_PAGE does
not check that anything is frozen.  The swap device must also not be
SWP_SYNCHRONOUS_IO, or swapin takes the direct path and never reaches
cluster readahead.

Tested with a debug patch generated by AI that counts hibernation slots through the swap
cache paths.  virtio-blk swap, page-cluster 3, SNAPSHOT_ALLOC_SWAP_PAGE
interleaved with MADV_PAGEOUT of a shmem region so the hibernation slots
land in the readahead windows.

                                unpatched   +patch 1   patches 1-4
  hibernation slots allocated       2732       2732         2732
  readahead landed on the slot      2731       2731         2731
  admitted to the swap cache        2731       2731            0
  reclaim found the folio              0       2731            -
  slot left unfreed                    0          0            0
  VM_WARN in the free path          2731          0            0

The VM_WARN is the existing assertion in __swap_cluster_free_entries(),
not something the debug patch adds.

Youngjun Park (4):
  mm, swap: don't free a hibernation slot that is in the swap cache
  mm, swap: give hibernation swap slots their own swap table entry type
  mm, swap: only allow swapped-out slots into the swap cache
  mm, swap: drop the swap cache guard and reclaim in
    swap_free_hibernation_slot()

 mm/swap_state.c |  9 +++++++--
 mm/swap_table.h | 12 ++++++++++++
 mm/swapfile.c   | 16 +++++++---------
 3 files changed, 26 insertions(+), 11 deletions(-)


base-commit: 0b53bff4fa05ff0d3ffbd3d3bb10fae69dfab498
-- 
2.48.1


