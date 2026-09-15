Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E82C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49ED66B00B5; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4758C6B00B4; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CB96B00B7; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 108CD6B00B4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 967A8402F5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:09 +0000 (UTC)
X-FDA: 85214535378.17.ADCA4EC
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf15.hostedemail.com (Postfix) with ESMTP id 530B0A0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf15.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=JV2EKUxvLvmrgNBCbIT2jn3kzPc8k+jHwAZEyQRN/hI=;
	b=dlmWjPEvySRlrByNIzEa01y3y+ipb/YZADPcd7mB95K0+37ZXontzQNTI7UOHbf3ChnFDd
	3vNBmyOaZhBoz16SwfMHK3I+sJZVKC6Jpu4BVCZDO3a1iz6hwYx44MNJaLMlEPDchEBRaS
	qJEoB0i8hw3HJKVBJMcZaZ0N80Q82QI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789442228;
	b=Z3W5lk3LhgFFzLAYFTjg79421vIYYOxhxAelmohqkCVObLuhnNApcpfasExF4pFYj4eI+S
	bStvdO2crm13jaaCAj5Uka7ZV/ff557ckx1J+tRq9O1wvbWLEKtVkyJyAm4SIy5ljfLPqi
	0Cc+/sP/p0BLd7f8yXfwFmRwZ94t8/M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf15.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:03 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	her0gyugyu@gmail.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH 00/10] mm/swap, PM: hibernate: improve image slot allocation and I/O
Date: Tue, 15 Sep 2026 12:16:48 +0900
Message-Id: <20260915031658.1505680-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 530B0A0004
X-Stat-Signature: kud4k86ujao19zfdc75nm7rpmdug7c4h
X-Rspam-User: 
X-HE-Tag: 1789442227-336773
X-HE-Meta: U2FsdGVkX19LmMy2EU0n1joIrQ7aWjwKOjie48TqW3d6cUMM/tcV1TCYEJijhsZW5AmhEkfl/ZqfmvNl371CqFSM7wJ8SsQqPdV8x7YK1AdDAq6xiHxvnkMF8P9bB3fiCLoWE+YBxVkHnJ2toa47GnCYU7CNTi77DbWaNPjQnubM780lV+NHBWKElxwRyNOpnpp/i5u6aIMLpfQnSpYlfgy7RX7Tu1cCDWFi1Na+u+xgBZQrLRacxc/JeEQ5JowKpewntRnyDIEIUrsfKjQnlh/xA497LwDCajI45AePhtDsKGQAPIPHNqP5v5FmgAJYGh/kvby/LNp++Zk7zVgUFtNQ4tGOm05EoCX52nxK9rE0y6gBK5F3Lw/lP0aYO4r4qGEuLz5+RBTr0/QHLCMfYcy+hHYXZQSgQqmxHoStOZbQgtjpVXhSg7QlIoEQ9hWlcdlsBrfKNCekLbJYLg8/CwlIU0iX4aYT5Q2fj5z0c9HCvk02Aucx4I4UOIXNvEz4eLKDZ3Mr9DJz23JRH/OhqOCugSe90KQbC+aN2f5lubEziffO5iCg6mg+avOw4ZUn+Ko2Szo+/zCGjJF6x6IoEZTTASc+PkdHu+6TctUH/0HyTPNShL7KzFellLGQhA6Vg8YcMYAWRPe1eo9dpjsp8+GgivBHueyh3RGRLcVtCjcARP4m1l/ecz9Ng8fy8dZJvTZd1upzrOuqJad1lvqlG721sDAOI49DG5w+bUGu17Lk9TTLTc6068X6Xob+OLN/1q4xvi5Hq0HqsOUtOFzbawrSulO4KMOVlVsrvgzD+r8cez/3k56anvnmrCGZX/SPspSs4QxScf4k5UGeBtqOt/TGuBqE/C5jKe3vEsJlkF7PVm0TSKWmdeVQlKk4TM+fzabtXDRV83f3wr34FgCAhzEZkpQc/f5wEcfdsbr5LkhHQtU9PFZMhAbLDzxpeNpxkHUP/Xd/wxdpkmJUgpo
 CvX1qRlt
 UkR1DYGIu8SWOe+t7Ij5LYg+CjWn+XFvrZBvmf3JbA2VBPoj4r32ibWXy4/kRUlQxerikD1zP7tur8x9oJ1Uxpyv+ReAHcv7Cet+7ef/6w9YzroafEZ3EDfRX05hNLU08SKGI8fpb3FAhgk5GKZHm4EbkKO773mhmNHjNn3h2JNaJgRn8usd2xBdPHTx3JRe0BLhx336LESQkjwEfsXWUknqtJuOJr9x26CfZss/f6GVkKnwLCYV4T7J9gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series improves how hibernation allocates swap slots for its
image.  It starts from a few observations about what happens while
the image is written.  With them the allocator can hand the image
contiguous runs, the image I/O can be batched per run, and
hibernation gets faster. Contiguous I/O pattern is friendly to flash device also.

Slot allocation matters for hibernation speed.  After commit
0ff67f990bd4 ("mm, swap: remove swap slot cache") in v6.15, writing
the image was about ten times slower on some SSDs [1], until
commit 396f57b57200 ("mm, swap: speed up hibernation allocation and
writeout") fixed it in v7.1.

Note
 - I was responsible for the observation and design, 
 while receiving substantial support from LLMs throughout the series.
-  Submitting this patch to confirm whether this work is progressing or not.

Observations
============

1. While the image is written, swap can only hand out slots that are
   already free.  Swap cache cannot be reclaimed to make more.

   folio_swapcache_freeable() refuses every folio while storage is
   suspended.  The image may already hold a folio as clean swap cache.
   If its slot were freed and reused for the image, the resumed kernel
   could later drop that folio and read it back from the slot, now
   with the wrong data.

   Storage is suspended before the image is written, so every
   allocation for the image falls in that window.

     hibernate()
       freeze_processes()                user space is frozen
       hibernation_snapshot()
         freeze_kernel_threads()         kswapd is frozen
         hibernate_preallocate_memory()  may swap out to shrink memory
         pm_restrict_gfp_mask()          storage is suspended from here
         create_image()                  the snapshot is taken
       swsusp_write()                    image slots are allocated here
       power_down()

   uswsusp can send SNAPSHOT_ALLOC_SWAP_PAGE before storage is
   suspended, but s2disk sends it only after SNAPSHOT_CREATE_IMAGE [2].
   An early request is still served by the normal allocator.

   So the image does not need to walk the nonfull and frag clusters.
   It can take the free clusters first and use the others only when
   those run out.

2. Image slots are not freed and reused while the image is written.
   And whatever the allocator changes during the write is gone at
   resume, because the resumed kernel is the snapshot.

   With observation 1, once the image owns a free cluster it can use
   all of it.  Nothing has to be recorded per slot, neither in the
   swap table nor as a memcg id.

3. User space and kswapd do not swap out while the image is written,
   and allocations from the page allocator cannot start swap I/O.
   What is left is rare.  DAMON pageout and the memcg high work can
   still reach swap(This is all I found. anything else?), 
   and both were seen running in that window.

   So the allocator can favor the image then.  Other users take slots
   from the nonfull and frag clusters and leave the free clusters to
   the image.

With these the allocator gets simpler and faster, and batching the
image read and write becomes easy.

What the series does
====================

  1-2    fixes, a slot leak after a failed test_resume and a NULL
         dereference for a swapfile with no block device (some bug fix)
  3      move the hibernation code to mm/swap_hibernate.c (refactor)
  4      skip swap cache reclaim while storage is suspended (optimization)
  5-6    hand the image whole free clusters, in disk order (exploit contiguous space)
  7-8    write and read the image one bio per run (batch I/O)
  9-10   optional reservation at swapon, hibernate=reserve (assure contiguous space)

Based on mm-new (383fc05d4650) with patches 2 to 4 of [3] under it.
Patch 1 of [3] is in mm-new as 10d9012e83ef.

Note.  [3] gives hibernation slots their own swap table entry, keeps
readahead off them, and frees them by offset alone.  The single slot
path of patch 5 builds on that.

Results
=======

Setup
  - qemu, 12G RAM, 4 CPUs, no KVM.  Times only compare against each
    other.
  - swap on virtio-blk as a non-rotational device
  - image 5.0G, written with hibernate=nocompress
  - 3 reps of two hibernations each.  Times are medians of the 4 to 6
    samples per cell that no host load hit.
  - base is patch 3 and allocates as mm-new does, allocator is
    patch 6, allocator + bio is patch 8

Rows.  runs is how many contiguous stretches of the device the image
ends up in.  bios is how many bios the kernel allocates and submits to
write it.  In both cases the image fits in free clusters, so the
fallback to nonfull and frag clusters is not measured.  Percentages
are against base.

Shuffled free list.  A device that has been in use, emptied.
  - 6G swap, 5.4G of 2M tmpfs files swapped out, then all removed in
    random order
  - every cluster is free, the free list is in free order, not in
    disk order

                        base       allocator   allocator + bio
  write, s             10.60     9.32 (-12%)       7.94 (-25%)
  read, s               9.15     8.92  (-3%)       8.10 (-11%)
  runs                  3560               1                 1
  bios                 1.30M           1.30M             12.7K

Holes in nonfull clusters.  What taking free clusters first buys.
  - 12G swap, one 4G file swapped out, every other 64K of it freed
  - 2G of 64K holes in 2048 clusters, 8G of free clusters
  - mm-new fills the holes first, the series takes the free clusters

                        base       allocator   allocator + bio
  write, s             10.69    10.07  (-6%)       8.81 (-18%)
  read, s              12.21    10.89 (-11%)       9.78 (-20%)
  runs                 31899               1                 1
  bios                 1.30M           1.30M             12.8K

Summary against base
  - the allocator cuts write time by 6 to 12%
  - allocator + bio cuts write time by 18 to 25% and read time by
    11 to 20%

These are VM numbers without compression.  Compression, the default,
and real hardware are still to be checked.

Next steps
==========

Things to keep working on after this RFC.  Comments are welcome.

1. Dropping swap cache before hibernation starts, so more slots are
   free.  This series does not do that.

2. Whether the reservation in patches 9 and 10 is worth keeping.  It
   makes sure the image gets contiguous slots when swap has room to
   spare.

3. A block device of its own for hibernation instead of swap.  Not
   taken for now.  Sharing one device keeps the spare space useful, the
   existing infrastructure stays, and the ideas above give much the same
   effect.

4. Whether the extent tree can go.  A normal hibernation never walks
   it, the swap state comes back as it was at the snapshot.  It is only
   walked to free the slots after an error or a wake from hybrid sleep.
   With the slots marked in the swap table [3] and taken as whole
   clusters, a free could find them without it.

5. Whether SNAPSHOT_ALLOC_SWAP_PAGE should refuse a request made before
   storage is suspended.  Such a request gets single slots from the
   normal allocator today, and s2disk only asks after
   SNAPSHOT_CREATE_IMAGE anyway.

6. Two cases are not measured yet.  A device with both a shuffled free
   list and partly used clusters.  An image bigger than the free
   clusters, so part of it comes from nonfull and frag clusters.

[1] https://lore.kernel.org/linux-mm/20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-utils.git
[3] https://lore.kernel.org/linux-mm/20260811132209.2862708-1-youngjun.park@lge.com/

Youngjun Park (10):
  PM: hibernate: give the image's swap slots back when test_resume fails
  mm, swap: skip swap devices without a block device in hibernation
    lookups
  mm, swap: move hibernation swap code to mm/swap_hibernate.c
  mm, swap: skip swap cache reclaim while storage is suspended
  mm, swap: hand the hibernation image whole free clusters
  mm, swap: hand the image's free clusters out in disk order
  PM: hibernate: build one bio per contiguous run of the image
  PM: hibernate: read the image back a run at a time
  PM: hibernate: tell swap how much space an image needs
  mm, swap: hold swap space back for a hibernation image at swapon

 .../admin-guide/kernel-parameters.txt         |   8 +
 MAINTAINERS                                   |   1 +
 include/linux/suspend.h                       |   3 +
 include/linux/swap.h                          |  11 +-
 kernel/power/hibernate.c                      |  32 +-
 kernel/power/power.h                          |   1 +
 kernel/power/swap.c                           | 172 +++++-
 mm/swap_hibernate.c                           | 547 ++++++++++++++++++
 mm/swapfile.c                                 | 344 ++---------
 9 files changed, 783 insertions(+), 336 deletions(-)
 create mode 100644 mm/swap_hibernate.c

base-commit: 383fc05d4650b021f3c17e36a145106dcc61a294
-- 
2.48.1

